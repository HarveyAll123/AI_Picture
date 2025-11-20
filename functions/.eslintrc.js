module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: ['tsconfig.json'],
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'google',
  ],
  rules: {
    'quotes': ['error', 'single', { 'allowTemplateLiterals': true }],
    'max-len': ['warn', { 'code': 120 }],
    'require-jsdoc': 'off',
  },
};




