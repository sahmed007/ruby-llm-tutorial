import { defineConfig } from '@tutorialkit-rb/theme';

export default defineConfig({
  theme: {
    colors: {
      accent: {
        50: '#FEF2F2',
        100: '#FEE2E2',
        200: '#FECACA',
        300: '#FCA5A5',
        400: '#F87171',
        500: '#DC2626',
        600: '#B91C1C',
        700: '#991B1B',
        800: '#7F1D1D',
        900: '#651A1A',
        950: '#450A0A',
      },
    },
  },
  content: {
    pipeline: {
      include: '**',
    },
  },
});
