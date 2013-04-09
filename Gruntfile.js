module.exports = function(grunt) {
    'use strict';

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        folders: grunt.file.readJSON('folders.json'),

        coffee: {
            'public': {
                expand: true,
                cwd: '<%= folders.coffee.public.src %>',
                src: ['**/*.coffee'],
                dest: '<%= folders.coffee.public.tmp %>',
                ext: '.js'
            },
            test: {
                expand: true,
                cwd: '<%= folders.coffee.test.src %>',
                src: ['**/*.coffee'],
                dest: '<%= folders.coffee.test.src %>',
                ext: '.js'
            }
        },
        coffeelint: {
            'public': '<%= folders.coffee.public.watch %>',
            test: '<%= folders.coffee.test.watch %>',
            options: {
                indentation: {
                    value: 4
                },
                max_line_length: {
                    value: 100,
                    level: 'error'
                },
                camel_case_classes: {
                    level: 'error'
                },
                no_implicit_braces: {
                    level: 'ignore'
                },
                no_tabs: {
                    level: 'error'
                },
                no_plusplus: {
                    level: 'error'
                }
            }
        },
        compass: {
            tmp: {
                basePath: '<%= folders.compass.src %>',
                config: '<%= folders.compass.configpath %>',
                src: './',
                dest: '../../' + '<%= folders.compass.tmp %>',
                forcecompile: true
            },
            dist: {
                basePath:'<%= folders.compass.src %>',
                config: '<%= folders.compass.configpath %>',
                src: './',
                dest: '../../' + '<%= folders.compass.dist %>',
                forcecompile: true,
                environment: 'production'
            }
        },
        exec: {
            co_deploy: {
                cmd: 'git stash; git branch deploy; git checkout deploy; cp .slugignore .gitignore; git rm -rf --cached .'
            },
            commit_build: {
                cmd: 'git add .; git commit -am "New production build." --amend;'
            },
            heroku_deploy: {
                cmd: 'git push heroku deploy:master -f; heroku open; git checkout master -f; git branch -D deploy; git stash pop;'
            }
        },
        jasmine: {
            src: '<%= folders.test.src %>',
            options: {
                specs: '<%= folders.test.specs %>'
            }
        },
        requirejs: {
            compile: {
                options: {
                    baseUrl: '<%= folders.coffee.public.tmp %>',
                    include: 'main',
                    mainConfigFile: '<%= folders.coffee.public.tmp %>' + 'main.js',
                    out: '<%= folders.coffee.public.dist %>' + 'main.js',
                    paths: {
                        'jquery': __dirname + '/lib/jquery/jquery.min'
                    }
                }
            }
        },
        watch: {
            files: [ '<%= folders.coffee.watch %>', '<%= folders.compass.watch %>' ],
            tasks: 'develop'
        }
    });

    // https://github.com/vojtajina/grunt-coffeelint
    grunt.loadNpmTasks('grunt-coffeelint');

    // https://github.com/kahlil/grunt-compass
    grunt.loadNpmTasks('grunt-compass');

    // https://github.com/gruntjs/grunt-contrib-coffee
    grunt.loadNpmTasks('grunt-contrib-coffee');

    // https://github.com/gruntjs/grunt-contrib-jasmine
    grunt.loadNpmTasks('grunt-contrib-jasmine');

    // https://github.com/gruntjs/grunt-contrib-requirejs/
    grunt.loadNpmTasks('grunt-contrib-requirejs');

    // https://github.com/gruntjs/grunt-contrib-watch
    grunt.loadNpmTasks('grunt-contrib-watch');

    // https://github.com/jharding/grunt-exec
    grunt.loadNpmTasks('grunt-exec');

    // Compile and build for production environment.
    grunt.registerTask('build', ['compile', 'requirejs', 'compass:dist'])

    // Compile CoffeeScript and Compass for development environment.
    grunt.registerTask('compile', ['coffeelint:public', 'coffee:public', 'coffeelint:test', 'coffee:test', 'compass:tmp']);

    // Stash git changes, change to deploy branch, create a build and deploy on heroku.
    grunt.registerTask('deploy', ['exec:co_deploy', 'build', 'exec:commit_build', 'exec:heroku_deploy']);

    // Compile and then watch for changes/
    grunt.registerTask('develop', ['compile', 'watch']);
};