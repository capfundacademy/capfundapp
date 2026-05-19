/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './templates/**/*.html'],
  theme: {
    extend: {
      colors: {
        brand: {
          blue:   '#2D1FB1',
          navy:   '#0F1631',
          yellow: '#FFD23F',
          orange: '#F97316',
          light:  '#F8FAFC',
        },
      },
      fontFamily: {
        sans: ['Inter', 'Plus Jakarta Sans', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
