#!/usr/bin/env node
// Mandatory shebang must point to `node` and this file must be executable.

/*
 * This file is part of the xPack distribution
 *   (http://xpack.github.io).
 * Copyright (c) 2017 Liviu Ionescu.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

'use strict'
/* eslint valid-jsdoc: "error" */
/* eslint max-len: [ "error", 80, { "ignoreUrls": true } ] */

// ----------------------------------------------------------------------------

const path = require('path')

// https://www.npmjs.com/package/shx
const shx = require('shelljs')

const properties = require('../lib/template.js').properties

// ----------------------------------------------------------------------------

const nodeBin = process.env.npm_node_execpath || process.env.NODE ||
  process.execPath
const executableRelativePath = '../bin/xpm-init-sifive-project.js'

// ----------------------------------------------------------------------------

class Test {
  static start () {
    // Instantiate a new test.
    const test = new Test()
    if (process.argv.length > 2 && process.argv[2] === 'all') {
      test.run(true)
    } else {
      test.run(false)
    }
  }

  constructor () {
    this.count = 1
  }

  run (all = false) {
    this.startTime = Date.now()
    if (all) {
      shx.echo('Testing thoroughly...')
      for (const boardName of Object.keys(properties.boardName.items)) {
        for (const content of Object.keys(properties.content.items)) {
          for (const syscalls of Object.keys(properties.syscalls.items)) {
            for (const trace of Object.keys(properties.trace.items)) {
              for (const language of Object.keys(properties.language.items)) {
                for (const useNano of [false, true]) {
                  this.runOne({
                    boardName,
                    content,
                    syscalls,
                    trace,
                    language,
                    useSomeWarnings: true,
                    useMostWarnings: true,
                    useWerror: true,
                    useNano
                  })
                  this.count++
                }
              }
            }
          }
        }
      }
    } else {
      shx.echo('Testing selected cases...')
      for (const boardName of Object.keys(properties.boardName.items)) {
        for (const language of Object.keys(properties.language.items)) {
          this.runOne({
            boardName,
            content: properties.content.default,
            syscalls: properties.syscalls.default,
            trace: properties.trace.default,
            language,
            useSomeWarnings: true,
            useMostWarnings: true,
            useWerror: true,
            useNano: true
          })
          this.count++
        }
      }
    }

    const durationString = this.formatDuration(Date.now() - this.startTime)
    shx.echo(`Completed in ${durationString}.`)
  }

  runOne (props) {
    // https://www.npmjs.com/package/shelljs

    shx.set('-e') // Exit upon error

    const cnt = ('0000' + this.count).slice(-3)
    const name = `${cnt}-${props.boardName}-${props.content}-` +
        `${props.syscalls}-${props.trace}-${props.language}`

    shx.echo()
    shx.echo(`Testing '${name}'...`)

    const tmp = shx.tempdir()
    const buildFolder = `${tmp}/sifive-templates/${name}`

    shx.rm('-rf', buildFolder)
    shx.mkdir('-p', buildFolder)

    shx.config.silent = true
    shx.pushd(buildFolder)
    shx.config.silent = false

    const executableAbsolutePath = path.join(__dirname, executableRelativePath)
      .replace(/ /g, '\\ ')
    let xpmInit = `${nodeBin} ${executableAbsolutePath}`
    for (const [key, value] of Object.entries(props)) {
      xpmInit += ` --property ${key}=${value}`
    }
    shx.exec(xpmInit)
    shx.echo()
    shx.exec('xpm install')
    shx.echo()
    shx.exec('xpm run build')

    shx.config.silent = true
    shx.popd()
    shx.config.silent = false
  }

  /**
   * @summary Convert a duration in ms to seconds if larger than 1000.
   * @param {number} n Duration in milliseconds.
   * @returns {string} Value in ms or sec.
   */
  formatDuration (n) {
    if (n < 1000) {
      return `${n} ms`
    }
    return `${(n / 1000).toFixed(3)} sec`
  }
}

Test.start()
