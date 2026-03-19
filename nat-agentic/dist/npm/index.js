#!/usr/bin/env node
/**
 * Nat Agentic CLI Entry Point
 *
 * This is the main entry point when installed via NPM.
 * It sets up the environment and delegates to the main CLI script.
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

// Get package version
const packageJson = require('./package.json');
const VERSION = packageJson.version;

// Set up environment
const NAT_AGENTIC_HOME = process.env.NAT_AGENTIC_HOME || path.join(os.homedir(), '.nat-agentic');
const CLAUDE_SETTINGS_PATH = path.join(NAT_AGENTIC_HOME, 'config', 'settings.json');

// Banner
const BANNER = `
 _   _ _______  ______  _   _ _____    _    _ _   _ _ _   _
| \\ | | ____\\ \\/ /  _ \\| \\ | | ____|  / \\  | | \\ | | | \\ | |
|  \\| |  _|  \\  /| |_) |  \\| |  _|   / _ \\ | |  \\| | |  \\| |
| |\\  | |___ /  \\|  __/| |\\  | |___ / ___ \\| | |\\  | | |\\  |
|_| \\_|_____/_/\\_\\_|   |_| \\_|_____/_/   \\_\\_|_| \\_|_|_| \\_|
`;

// Parse arguments
const args = process.argv.slice(2);

// Handle special flags
if (args.includes('--nat-version') || args.includes('-v')) {
    console.log(`Nat Agentic v${VERSION}`);
    try {
        const result = spawn('claude', ['--version'], { encoding: 'utf8' });
        result.stdout?.on('data', (data) => {
            console.log(`Claude Code: ${data.toString().trim()}`);
        });
    } catch (e) {
        console.log('Claude Code: not found');
    }
    process.exit(0);
}

if (args.includes('--help') || args.includes('-h')) {
    console.log(`
Nat Agentic - Custom Claude Code Distribution v${VERSION}

Usage: nat [options] [prompt]

Options:
  --nat-version       Show Nat Agentic version
  --nat-update        Update Nat Agentic to latest version
  --nat-config        Open configuration file
  --profile <name>    Switch to a profile (web-dev, backend, minimal)
  --no-banner         Don't show ASCII banner
  --help              Show this help message

Any other options are passed through to Claude Code CLI.

Examples:
  nat                          Start interactive session
  nat "Fix the bug in app.ts"  Run with a prompt
  nat --profile web-dev        Use web development profile
  nat --nat-update             Update Nat Agentic

Documentation: https://nat-agentic.dev/docs
`);
    process.exit(0);
}

// Initialize home directory
function initHome() {
    const dirs = [
        NAT_AGENTIC_HOME,
        path.join(NAT_AGENTIC_HOME, 'config'),
        path.join(NAT_AGENTIC_HOME, 'marketplace'),
        path.join(NAT_AGENTIC_HOME, 'logs'),
    ];

    dirs.forEach(dir => {
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
    });

    // Copy default settings
    const settingsPath = path.join(NAT_AGENTIC_HOME, 'config', 'settings.json');
    if (!fs.existsSync(settingsPath)) {
        const defaultSettings = path.join(__dirname, 'config', 'settings-default.json');
        if (fs.existsSync(defaultSettings)) {
            fs.copyFileSync(defaultSettings, settingsPath);
            console.log('[Nat Agentic] Created default settings');
        }
    }

    // Copy marketplace plugins
    const bundledPlugins = path.join(__dirname, 'marketplace', 'plugins');
    const targetPlugins = path.join(NAT_AGENTIC_HOME, 'marketplace', 'plugins');

    if (fs.existsSync(bundledPlugins)) {
        const plugins = fs.readdirSync(bundledPlugins);
        plugins.forEach(plugin => {
            const src = path.join(bundledPlugins, plugin);
            const dest = path.join(targetPlugins, plugin);

            if (!fs.existsSync(dest)) {
                fs.cpSync(src, dest, { recursive: true });
                console.log(`[Nat Agentic] Installed plugin: ${plugin}`);
            }
        });
    }
}

// Show banner for interactive sessions
if (!args.includes('--no-banner') && args.length === 0) {
    console.log(BANNER.replace('{VERSION}', VERSION));
    console.log('');
}

// Initialize
initHome();

// Set environment variables
process.env.NAT_AGENTIC_HOME = NAT_AGENTIC_HOME;
process.env.NAT_AGENTIC_VERSION = VERSION;
process.env.CLAUDE_SETTINGS_PATH = CLAUDE_SETTINGS_PATH;

// Find claude binary
function findClaude() {
    // Try common locations
    const paths = [
        path.join(__dirname, 'node_modules', '.bin', 'claude'),
        path.join(__dirname, '..', '.bin', 'claude'),
    ];

    for (const p of paths) {
        if (fs.existsSync(p)) return p;
    }

    // Fall back to PATH
    return 'claude';
}

// Spawn claude with our settings
const claude = findClaude();
const child = spawn(claude, ['--settings-path', CLAUDE_SETTINGS_PATH, ...args], {
    stdio: 'inherit',
    env: process.env,
});

child.on('exit', (code) => {
    process.exit(code || 0);
});
