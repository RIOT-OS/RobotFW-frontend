const gulp = require('gulp');
const filter = require('gulp-filter');
const postcss = require('gulp-postcss');
const terser = require('gulp-terser');
const concat = require('gulp-concat');
const del = require('del');

const paths = {
  css: {
    main: 'assets/css/styles.css',
    src: [ 'assets/css/styles.css', 'assets/css/**/*.css'  ],
    dest: 'static/'
  },
  js: {
    src: [ 'assets/javascript/main.js', 'assets/javascript/**/*.js' ],
    dest: 'static/'
  },
  img: {
    src: 'assets/images/**/*.+(png|svg)',
    dest: 'static/images/'
  },
  zondicons: {
    src: 'assets/zondicons/**/*.svg',
    dest: 'static/images/zondicons/'
  },
  favicon: {
    src: 'assets/favicon/**/*.+(png|ico|xml|webmanifest)',
    dest: 'static/'
  },
  fonts: {
    src: 'assets/fonts/*.+(woff|woff2)',
    dest: 'static/fonts/'
  },
  clean: [
    'static/*',
    '!static/.gitkeep'
  ]
}

const includeIcons = [
  'add-outline.svg',
  'minus-outline.svg',
  'calendar.svg',
  'information-outline.svg',
  'link.svg',
  'time.svg',
  'timer.svg',
  'menu.svg',
  'clipboard.svg',
  'close.svg',
  'close-outline.svg',
  'cheveron-up.svg',
  'cheveron-down.svg',
  'cheveron-left.svg',
  'cheveron-right.svg',
  'cheveron-outline-up.svg',
  'cheveron-outline-down.svg',
  'cheveron-outline-left.svg',
  'cheveron-outline-right.svg',
  'chart-pie.svg',
  'navigation-more.svg'
]

function css() {
  return gulp.src(paths.css.main)
    .pipe(postcss([
      require('postcss-import'),
      require('tailwindcss'),
      require('autoprefixer'),
    ]))
    .pipe(concat('styles.css'))
    .pipe(gulp.dest(paths.css.dest))
}

function js() {
  const terserOptions = {}
   
  return gulp.src(paths.js.src)
    .pipe(concat('scripts.js'))
    // .pipe(terser(terserOptions))
    .on('error', function (error) {
      this.emit('end')
    })
    .pipe(gulp.dest(paths.js.dest))
}

function img() {
  return gulp.src(paths.img.src)
    .pipe(gulp.dest(paths.img.dest))
}

function zondicons() {
  const iconFilter = filter(function (file) {
    filename = file.path.split('/').reverse()[0];
    return includeIcons.includes(filename);
  });

  return gulp.src(paths.zondicons.src)
    .pipe(iconFilter)
    .pipe(gulp.dest(paths.zondicons.dest))
}

function favicon() {
  return gulp.src(paths.favicon.src)
    .pipe(gulp.dest(paths.favicon.dest))
}

function fonts() {
  return gulp.src(paths.fonts.src)
    .pipe(gulp.dest(paths.fonts.dest))
}

function clean() {
  return del(paths.clean);
}

exports.clean = gulp.series(clean)
exports.copy = gulp.parallel(zondicons, favicon, img, fonts) 
exports.build = gulp.parallel(css, js);
exports.default = gulp.parallel(exports.copy, exports.build);
exports.watch = function() {
  gulp.watch(paths.css.src, css);
  gulp.watch(paths.js.src, js);
}
