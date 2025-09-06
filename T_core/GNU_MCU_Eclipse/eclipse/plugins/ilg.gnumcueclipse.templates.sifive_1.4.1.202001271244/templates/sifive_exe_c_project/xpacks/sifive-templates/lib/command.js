/*
 * This file is part of the µOS++ distribution.
 *   (https://github.com/micro-os-plus)
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

/**
 * The `xgen-sifive-project ...` command implementation.
 */

// ----------------------------------------------------------------------------

const fs = require('fs')
const path = require('path')
const process = require('process')

// const LiquidExtension = require('../utils/liquid-extensions.js')
//   .LiquidExtension
const XpmInitTemplate = require('./template.js').XpmInitTemplate

const Promisifier = require('@ilg/es6-promisifier').Promisifier

// ES6: `import { CliCommand, CliExitCodes, CliError, CliErrorApplication }
//   from 'cli-start-options'
const CliCommand = require('@ilg/cli-start-options').CliCommand
const CliExitCodes = require('@ilg/cli-start-options').CliExitCodes
// const CliError = require('@ilg/cli-start-options').CliError
// const CliErrorApplication = require('@ilg/cli-start-options')
//   .CliErrorApplication

// ----------------------------------------------------------------------------

// Promisify functions from the Node.js callbacks library.
// New functions have similar names, but suffixed with `Promise`.
// Promisifier.promisifyInPlace(fs, 'readFile')
// Promisifier.promisifyInPlace(fs, 'writeFile')
// Promisifier.promisifyInPlace(fs, 'stat')
// Promisifier.promisifyInPlace(fs, 'mkdir')
Promisifier.promisifyInPlace(fs, 'access')

// ----------------------------------------------------------------------------

// export
class Command extends CliCommand {
  // --------------------------------------------------------------------------

  /**
   * @summary Constructor, to set help definitions.
   *
   * @param {Object} context Reference to a context.
   */
  constructor (context) {
    super(context)

    // Title displayed with the help message.
    this.title = 'Generate a SiFive Core Complex C/C++ project'
    this.optionGroups = [
      {
        title: 'Command options',
        msg: '',
        optionDefs: [
          {
            options: ['-n', '--name'],
            action: (context, val) => {
              context.config.projectName = val
            },
            init: (context) => {
              context.config.projectName = null
            },
            msg: 'Project name',
            param: 'string',
            isOptional: true
          },
          {
            options: ['-p', '--property'],
            action: (context, val) => {
              const arr = val.split('=', 2)
              if (arr.length === 1) {
                arr[1] = 'true' // Mandatory a string, it is tested with '==='
              }
              context.config.properties[arr[0]] = arr[1]
            },
            init: (context) => {
              context.config.properties = {}
            },
            msg: 'Substitution variables',
            param: 'string',
            isOptional: true
          }
        ]
      }
    ]
  }

  /**
   * @summary Execute the `code` command.
   *
   * @param {string[]} args Command line arguments.
   * @returns {number} Return code.
   *
   * @override
   */
  async doRun (args) {
    const log = this.log
    log.trace(`${this.constructor.name}.doRun()`)

    log.info(this.title)
    log.info()

    const context = this.context
    const config = context.config

    try {
      const packagePath = path.resolve(process.cwd(), 'package.json')
      await fs.accessPromise(packagePath)

      log.error('The destination folder already has a package.json file.')
      return CliExitCodes.ERROR.OUTPUT // Possible override.
    } catch (er) {
      // The package.json is not present. That's fine.
    }

    if (config.projectName) {
      // Validate `--name` as project name.
      if (!config.projectName.match(
        /^([@][a-zA-Z0-9-_]+[/])?[a-zA-Z0-9-_]+$/)) {
        log.error(`Project name '${config.projectName}' ` +
          'may contain only letters, digits, hyphens and underscores.')
        return CliExitCodes.ERROR.SYNTAX
      }
    } else {
      // Default to the current folder name.
      config.projectName = path.basename(process.cwd())
    }

    // Possibly replace illegal chars with '_'
    config.projectName = config.projectName.replace(/[^@/a-zA-Z0-9-_]/g, '_')

    const xpmInitTemplate = new XpmInitTemplate(context)
    const code = await xpmInitTemplate.run()

    this.outputDoneDuration()
    return code
  }
}

// ----------------------------------------------------------------------------
// Node.js specific export definitions.

// By default, `module.exports = {}`.
// The Code class is added as a property of this object.
module.exports.Command = Command

// In ES6, it would be:
// export class Command { ... }
// ...
// import { Command } from 'command.js'

// ----------------------------------------------------------------------------
