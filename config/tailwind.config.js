const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: ['./app/helpers/**/*.rb', './app/javascript/**/*.js', './app/views/**/*.{erb,haml,html,slim}'],
  theme: {
    extend: {},
  },
  plugins: [require('daisyui')],
};
