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
 * The XpmInitTemplate module.
 *
 * It is re-exported publicly by `index.js`.
 *
 * To import classes from this module into Node.js applications, use:
 *
 * ```javascript
 * const XpmInitTemplate = require('./template.js').XpmInitTemplate
 * ```
 */

// ----------------------------------------------------------------------------

const path = require('path')
const fs = require('fs')
const readlineSync = require('readline-sync')
const shell = require('shelljs')

// https://www.npmjs.com/package/shopify-liquid
const Liquid = require('liquidjs')

const Promisifier = require('@ilg/es6-promisifier').Promisifier

// ES6: `import { CliCommand, CliExitCodes, CliError, CliErrorApplication }
//   from 'cli-start-options'
const CliExitCodes = require('@ilg/cli-start-options').CliExitCodes
const CliError = require('@ilg/cli-start-options').CliError

// ----------------------------------------------------------------------------

// Promisify functions from the Node.js callbacks library.
// New functions have similar names, but suffixed with `Promise`.
Promisifier.promisifyInPlace(fs, 'writeFile')

// ----------------------------------------------------------------------------

// Provided:
// language (c, cpp)
// boardName (hifive1, e31arty, e51arty)
// content (empty, blinky)
// syscalls (none/retarget/semihosting)
// trace (none, uart0ftdi)

// useSomeWarnings=true
// useMostWarnings=true
// useWerror=true
// useOg=true
// useNano=true

// Computed:
// fileExtension (c, cpp)
// deviceName (fe310, e31arty, e51arty)
// deviceMacro <string>
// boardMacro <string>
// boardFolder  <string>
// boardDescription  <string>

// ============================================================================

// The result is in the properties map:
// context.config.properties[key] = value
// The description is shown when '?' is entered as selection.

const properties = {
  language: {
    label: 'Programming language',
    description: 'Select the preferred programming language',
    type: 'select',
    items: {
      c: 'C for the application files, C and C++ for the system',
      cpp: 'C++ for the application files, C++ and C for the system'
    },
    default: 'cpp'
  },
  boardName: {
    label: 'Board',
    description: 'Select the SiFive board name',
    type: 'select',
    items: {
      hifive1: 'Freedom E310 HiFive1',
      e31arty: 'E31 Arty',
      e51arty: 'E51 Arty'
    },
    default: 'hifive1'
  },
  content: {
    label: 'Content',
    description: 'Choose the project content',
    type: 'select',
    items: {
      empty: 'Empty (add your own content)',
      blinky: 'Blinky (blink one or more LEDs)'
    },
    default: 'blinky'
  },
  syscalls: {
    label: 'Use system calls',
    description: 'Control how system calls are implemented',
    type: 'select',
    items: {
      none: 'Free-standing (no POSIX system calls)',
      retarget: 'POSIX (system calls implemented by application code)',
      semihosting: 'Semihosting (POSIX system calls via host)'
    },
    default: 'retarget'
  },
  trace: {
    label: 'Trace output',
    description: 'Control where the trace output messages are forwarded',
    type: 'select',
    items: {
      none: 'None (no trace output)',
      uart0ftdi: 'UART0 (via FTDI)',
      stdout: 'Semihosting STDOUT stream',
      debug: 'Semihosting DEBUG channel'
    },
    default: 'uart0ftdi'
  },
  useSomeWarnings: {
    label: 'Check some warnings',
    description: 'Enable -Wall and -Wextra to catch most common warnings',
    type: 'boolean',
    default: true
  },
  useMostWarnings: {
    label: 'Check most warnings',
    description: 'Enable as many warnings as possible',
    type: 'boolean',
    default: false
  },
  useWerror: {
    label: 'Enable -Werror',
    description: 'Instruct the compiler to stop on warnings',
    type: 'boolean',
    default: false
  },
  useOg: {
    label: 'Use -Og on debug',
    description: 'Use the new optimization flag for the debug configurations',
    type: 'boolean',
    default: false
  },
  useNano: {
    label: 'Use newlib nano',
    description: 'Use the size optimised version of newlib',
    type: 'boolean',
    default: true
  }
}

// ============================================================================

// export
class XpmInitTemplate {
  // --------------------------------------------------------------------------

  constructor (context) {
    this.context = context
    this.log = context.log
  }

  async run () {
    const log = this.log
    log.trace(`${this.constructor.name}.run()`)

    log.info()

    const context = this.context
    const config = context.config

    this.isInteractive = false
    // Properties may have been set by --property name=value.
    if (!config.properties['boardName']) {
      if (!process.stdin.isTTY || !process.stdout.isTTY) {
        log.error('Missing board name.')
        // this.help()
        return CliExitCodes.ERROR.SYNTAX // No project name.
      }

      this.enterInteractiveMode(properties)
      // Reset start time to skip interactive time.
      context.startTime = Date.now()
      this.isInteractive = true
      console.log()
    } else {
      let isError = false
      for (const [key, val] of Object.entries(config.properties)) {
        const value = this.validateInput(properties, key, val)
        if (value === undefined) {
          log.error(`Unsupported property '${key}'`)
          isError = true
        }
        if (value === null) {
          log.error(`Unsupported value for '${key}=${val}'`)
          isError = true
        }
      }
      if (isError) {
        return CliExitCodes.ERROR.SYNTAX
      }
      // Add defaults for missing properties
      for (const [key, val] of Object.entries(properties)) {
        if (!config.properties[key]) {
          config.properties[key] = val.default
        }
      }
    }

    // At this point context.config.properties have full data,
    // including defaults.
    const liquidMap = Object.assign({}, config.properties)

    liquidMap['projectName'] = config.projectName

    switch (liquidMap['boardName']) {
      case 'hifive1':
        liquidMap['deviceName'] = 'fe310'
        liquidMap['deviceMacro'] = 'SIFIVE_FE310'
        liquidMap['boardMacro'] = 'SIFIVE_HIFIVE1_BOARD'
        liquidMap['boardFolder'] = 'sifive-hifive1-board'
        liquidMap['boardDescription'] = 'HiFive1'
        liquidMap['march'] = 'rv32imac'
        liquidMap['mabi'] = 'ilp32'
        break

      case 'e31arty':
        liquidMap['deviceName'] = 'e31arty'
        liquidMap['deviceMacro'] = 'SIFIVE_E31ARTY'
        liquidMap['boardMacro'] = 'SIFIVE_E31ARTY_BOARD'
        liquidMap['boardFolder'] = 'sifive-arty-boards'
        liquidMap['boardDescription'] = 'E31 Arty'
        liquidMap['march'] = 'rv32imac'
        liquidMap['mabi'] = 'ilp32'
        break

      case 'e51arty':
        liquidMap['deviceName'] = 'e51arty'
        liquidMap['deviceMacro'] = 'SIFIVE_E51ARTY'
        liquidMap['boardMacro'] = 'SIFIVE_E51ARTY_BOARD'
        liquidMap['boardFolder'] = 'sifive-arty-boards'
        liquidMap['boardDescription'] = 'E51 Arty'
        liquidMap['march'] = 'rv64imac'
        liquidMap['mabi'] = 'lp64'
        break

      default:
        log.error(`Unsupported board '${liquidMap['boardName']}'.`)
        return CliExitCodes.ERROR.SYNTAX
    }

    liquidMap['fileExtension'] = liquidMap['language']

    const currentTime = new Date()
    liquidMap['year'] = currentTime.getFullYear().toString()
    liquidMap['authorName'] = '<your-name-here>'

    this.liquidMap = liquidMap
    await this.generate()

    return CliExitCodes.SUCCESS
  }

  validateInput (properties, name, value) {
    const propDef = properties[name]
    if (!propDef) {
      return undefined
    }
    if (propDef.type === 'select') {
      if (propDef.items[value]) {
        return value
      }
    } else if (propDef.type === 'boolean') {
      if (value === 'true') {
        return true
      } else if (value === 'false') {
        return false
      }
    }
    if (value === '') {
      return propDef.default
    }
    return null
  }

  enterInteractiveMode (properties) {
    const context = this.context
    const config = context.config

    for (const [key, val] of Object.entries(properties)) {
      let out = `${val.label}?`
      if (val.type === 'select') {
        out += ' (' + Object.keys(val.items).join(', ') + ', ?)'
      } else if (val.type === 'boolean') {
        out += ' (true, false, ?)'
      }
      if (val.default !== undefined) {
        out += ` [${val.default}]`
      }
      out += ': '

      while (true) {
        let answer = readlineSync.question(out)
        // No need for more trimming
        answer = this.validateInput(properties, key, answer)
        if (answer != null && answer !== undefined) {
          config.properties[key] = answer
          break
        }
        console.log(val.description)
        if (val.type === 'select') {
          for (const ival of Object.values(val.items)) {
            console.log(`- ${ival}`)
          }
        }
      }
    }
  }

  async render (inputFileRelativePath, outputFileRelativePath, map) {
    const log = this.log

    const str = await this.engine.renderFile(inputFileRelativePath, map)

    // const headerPath = path.resolve(codePath, `${pnam}.h`)
    try {
      await fs.writeFilePromise(outputFileRelativePath, str, 'utf8')
    } catch (err) {
      throw new CliError(err.message, CliExitCodes.ERROR.OUTPUT)
    }
    log.info(`File '${outputFileRelativePath}' generated.`)
  }

  async generate () {
    const log = this.log
    // const context = this.context

    const liquidMap = this.liquidMap

    const lang = (liquidMap['language'] === 'cpp') ? 'C++' : 'C'
    log.info(`Creating the ${lang} project '${liquidMap['projectName']}'...`)

    if (!this.isInteractive) {
      log.info(`- boardName=${liquidMap['boardName']}`)
      log.info(`- content=${liquidMap['content']}`)
      log.info(`- syscalls=${liquidMap['syscalls']}`)
      log.info(`- trace=${liquidMap['trace']}`)
      log.info(`- useSomeWarnings=${liquidMap['useSomeWarnings']}`)
      log.info(`- useMostWarnings=${liquidMap['useMostWarnings']}`)
      log.info(`- useWerror=${liquidMap['useWerror']}`)
      log.info(`- useOg=${liquidMap['useOg']}`)
      log.info(`- useNano=${liquidMap['useNano']}`)
      log.info()
    }

    const templatesPath = path.resolve(__dirname, '..', 'assets', 'sources')
    log.debug(`from='${templatesPath}'`)

    this.engine = Liquid({
      root: templatesPath,
      cache: false,
      strict_filters: true,       // default: false
      strict_variables: true,     // default: false
      trim_right: false,          // default: false
      trim_left: false            // default: false
    })

    const fileExtension = liquidMap['fileExtension']
    const boardName = liquidMap['boardName']

    // ------------------------------------------------------------------------
    // Generate the application files.

    await this.render('LICENSE.liquid', 'LICENSE', liquidMap)
    await this.render('oocd.launch.liquid', 'oocd.launch', liquidMap)
    await this.render('jlink.launch.liquid', 'jlink.launch', liquidMap)
    await this.render('package.json.liquid', 'package.json', liquidMap)
    await this.render('README.md.liquid', 'README.md', liquidMap)

    await this.render('xmake.json.liquid', 'xmake.json', liquidMap)

    // Exit upon first error.
    shell.set('-e')

    shell.mkdir('-p', 'include')
    await this.render(`include/led-${fileExtension}.h.liquid`,
      'include/led.h', liquidMap)
    shell.cp(path.resolve(templatesPath, `include/sysclock-${fileExtension}.h`),
      'include/sysclock.h')
    log.info(`File 'include/sysclock.h' copied.`)

    shell.mkdir('-p', 'ldscripts')
    shell.cp(path.resolve(templatesPath, 'ldscripts/libs.ld'),
      'ldscripts/libs.ld')
    log.info(`File 'ldscripts/libs.ld' copied.`)
    shell.cp(path.resolve(templatesPath, `ldscripts/mem-${boardName}.ld`),
      'ldscripts/mem.ld')
    log.info(`File 'ldscripts/mem.ld' copied.`)
    shell.cp(path.resolve(templatesPath, 'ldscripts/sections.ld'),
      'ldscripts/sections.ld')
    log.info(`File 'ldscripts/sections.ld' copied.`)

    shell.mkdir('-p', 'src')
    await this.render('src/initialize-hardware.c.cpp.liquid',
      `src/initialize-hardware.${fileExtension}`, liquidMap)
    await this.render('src/interrupts-handlers.c.cpp.liquid',
      `src/interrupts-handlers.${fileExtension}`, liquidMap)

    shell.cp(path.resolve(templatesPath, `src/led.${fileExtension}`),
      `src/led.${fileExtension}`)
    log.info(`File 'src/led.${fileExtension}' copied.`)

    await this.render('src/main.c.cpp.liquid',
      `src/main.${fileExtension}`, liquidMap)

    shell.cp(path.resolve(templatesPath, 'src/newlib-syscalls.c'),
      'src/newlib-syscalls.c')
    log.info(`File 'src/newlib-syscalls.c' copied.`)

    shell.cp(path.resolve(templatesPath, `src/sysclock.${fileExtension}`),
      `src/sysclock.${fileExtension}`)
    log.info(`File 'src/sysclock.${fileExtension}' copied.`)
  }
}

// ----------------------------------------------------------------------------
// Node.js specific export definitions.

// By default, `module.exports = {}`.
// The Template class is added as a property to this object.

module.exports.properties = properties
module.exports.XpmInitTemplate = XpmInitTemplate

// In ES6, it would be:
// export class XpmInitTemplate { ... }
// ...
// import { XpmInitTemplate } from 'template.js'

// ----------------------------------------------------------------------------
