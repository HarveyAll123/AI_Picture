"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateProfilePicture = void 0;
const https_1 = require("firebase-functions/v2/https");
const firebase_functions_1 = require("firebase-functions");
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const storage_1 = require("firebase-admin/storage");
const node_fetch_1 = __importDefault(require("node-fetch"));
const generative_ai_1 = require("@google/generative-ai");
const uuid_1 = require("uuid");
(0, app_1.initializeApp)();
const MODEL_NAME = 'gemini-2.5-flash-image'; // 'gemini-3-pro-image-preview' or 'gemini-2.5-flash-image'
exports.generateProfilePicture = (0, https_1.onCall)({
    region: 'us-central1',
    secrets: ['GEMINI_API_KEY'],
    cors: true,
}, async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
        throw new https_1.HttpsError('unauthenticated', 'Authentication required.');
    }
    const imageUrl = request.data?.imageUrl ?? '';
    const prompt = request.data?.prompt?.trim() ||
        'Create a professional profile headshot with even lighting.';
    if (!imageUrl.startsWith('http')) {
        throw new https_1.HttpsError('invalid-argument', 'A valid HTTPS imageUrl is required.');
    }
    const geminiApiKey = process.env.GEMINI_API_KEY;
    if (!geminiApiKey) {
        throw new https_1.HttpsError('failed-precondition', 'GEMINI_API_KEY secret is not configured.');
    }
    try {
        const sourceImage = await downloadImage(imageUrl);
        const generatedBuffer = await runGemini(sourceImage, prompt, geminiApiKey);
        const fileInfo = await saveGeneratedImage(uid, generatedBuffer, prompt);
        return {
            imageUrl: fileInfo.imageUrl,
            resultId: fileInfo.resultId,
        };
    }
    catch (error) {
        firebase_functions_1.logger.error('Generation failed', error);
        if (error instanceof https_1.HttpsError) {
            throw error;
        }
        throw new https_1.HttpsError('internal', 'Generation failed, please retry later.');
    }
});
const SUPPORTED_MIME_TYPES = new Set([
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif',
]);
async function downloadImage(imageUrl) {
    const response = await (0, node_fetch_1.default)(imageUrl);
    if (!response.ok) {
        throw new https_1.HttpsError('invalid-argument', 'Unable to download image.');
    }
    const arrayBuffer = await response.arrayBuffer();
    let mimeType = (response.headers.get('content-type') || 'image/jpeg').toLowerCase();
    if (mimeType === 'image/jpg') {
        mimeType = 'image/jpeg';
    }
    if (!SUPPORTED_MIME_TYPES.has(mimeType)) {
        throw new https_1.HttpsError('invalid-argument', `Unsupported image mime type: ${mimeType}. Allowed: ${Array.from(SUPPORTED_MIME_TYPES).join(', ')}`);
    }
    return { buffer: Buffer.from(arrayBuffer), mimeType };
}
async function runGemini(source, prompt, apiKey) {
    const genAI = new generative_ai_1.GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({
        model: MODEL_NAME,
        generationConfig: {
            temperature: 0.65, // 0.35 or 0.65
        },
    });
    const result = await model.generateContent([
        {
            text: 'You are an expert portrait retoucher that creates clean professional profile photos.',
        },
        { text: prompt },
        {
            inlineData: {
                data: source.buffer.toString('base64'),
                mimeType: source.mimeType,
            },
        },
    ]);
    const parts = result.response.candidates?.[0]?.content?.parts ?? [];
    const imagePart = parts.find((part) => part.inlineData?.data);
    if (!imagePart?.inlineData?.data) {
        throw new https_1.HttpsError('internal', 'Gemini did not return an image.');
    }
    return Buffer.from(imagePart.inlineData.data, 'base64');
}
async function saveGeneratedImage(uid, buffer, prompt) {
    const bucket = (0, storage_1.getStorage)().bucket();
    const firestore = (0, firestore_1.getFirestore)();
    const resultId = (0, uuid_1.v4)();
    const path = `users/${uid}/generated/${resultId}.jpg`;
    const file = bucket.file(path);
    await file.save(buffer, {
        contentType: 'image/jpeg',
        metadata: {
            cacheControl: 'public,max-age=3600',
        },
    });
    const [signedUrl] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 1000 * 60 * 60 * 24 * 7,
    });
    const userRef = firestore.collection('users').doc(uid);
    await userRef.set({
        lastGeneratedAt: firestore_1.FieldValue.serverTimestamp(),
    }, { merge: true });
    await userRef.collection('results').doc(resultId).set({
        imageUrl: signedUrl,
        imagePath: path,
        prompt,
        createdAt: firestore_1.FieldValue.serverTimestamp(),
    });
    return { imageUrl: signedUrl, resultId };
}
//# sourceMappingURL=index.js.map