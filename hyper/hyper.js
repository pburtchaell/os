module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 14,

    // font family with optional fallbacks
    fontFamily: 'Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    // terminal cursor background color and opacity
    cursorColor: 'rgba(248,28,229,0.75)',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BEAM',

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor: '#000',

    // border color (window, tabs)
    borderColor: '#333',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#000000',
      red: '#ff0000',
      green: '#33ff00',
      yellow: '#ffff00',
      blue: '#0066ff',
      magenta: '#cc00ff',
      cyan: '#00ffff',
      white: '#d0d0d0',
      lightBlack: '#808080',
      lightRed: '#ff0000',
      lightGreen: '#33ff00',
      lightYellow: '#ffff00',
      lightBlue: '#0066ff',
      lightMagenta: '#cc00ff',
      lightCyan: '#00ffff',
      lightWhite: '#ffffff'
    },

    // Shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: '',

    // Shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ['--login'],

    // Environment variables
    env: {},
    
    bell: 'SOUND',

    // If true, selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // hypercwd config
    hypercwd: {
      initialWorkingDirectory: '~/Repositories',
    },
  },

  // List of plugins to fetch and install from npm
  plugins: [
    'hyperterm-atom-dark',
    'hyperlinks',
    'hypercwd',
  ],
};
