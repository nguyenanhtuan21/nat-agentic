#!/usr/bin/env node
/**
 * Post-install script for NPM package
 * Runs after npm install to set up Nat Agentic
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const NAT_AGENTIC_HOME = process.env.NAT_AGENTIC_HOME || path.join(os.homedir(), '.nat-agentic');

console.log('');
console.log('╔═══════════════════════════════════════════════════════════╗');
console.log('║              Nat Agentic Installation                      ║');
console.log('╠═══════════════════════════════════════════════════════════╣');
console.log('║  Setting up your environment...                           ║');
console.log('╚═══════════════════════════════════════════════════════════╝');
console.log('');

// Create directories
const dirs = [
    NAT_AGENTIC_HOME,
    path.join(NAT_AGENTIC_HOME, 'config'),
    path.join(NAT_AGENTIC_HOME, 'marketplace', 'plugins'),
    path.join(NAT_AGENTIC_HOME, 'logs'),
];

dirs.forEach(dir => {
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`✓ Created: ${dir}`);
    }
});

// Copy default settings
const settingsDest = path.join(NAT_AGENTIC_HOME, 'config', 'settings.json');
if (!fs.existsSync(settingsDest)) {
    const settingsSrc = path.join(__dirname, 'config', 'settings-default.json');
    if (fs.existsSync(settingsSrc)) {
        fs.copyFileSync(settingsSrc, settingsDest);
        console.log(`✓ Created default settings`);
    }
}

// Copy plugins
const pluginsSrc = path.join(__dirname, 'marketplace', 'plugins');
const pluginsDest = path.join(NAT_AGENTIC_HOME, 'marketplace', 'plugins');

if (fs.existsSync(pluginsSrc)) {
    const plugins = fs.readdirSync(pluginsSrc);
    plugins.forEach(plugin => {
        const src = path.join(pluginsSrc, plugin);
        const dest = path.join(pluginsDest, plugin);

        if (!fs.existsSync(dest)) {
            fs.cpSync(src, dest, { recursive: true });
            console.log(`✓ Installed plugin: ${plugin}`);
        }
    });
}

console.log('');
console.log('╔═══════════════════════════════════════════════════════════╗');
console.log('║              Installation Complete!                        ║');
console.log('╠═══════════════════════════════════════════════════════════╣');
console.log('║                                                            ║');
console.log('║  Next steps:                                               ║');
console.log('║  1. Run "nat" to start Nat Agentic                         ║');
console.log('║  2. Run "nat --help" to see available options              ║');
console.log('║  3. Visit https://nat-agentic.dev/docs for documentation   ║');
console.log('║                                                            ║');
console.log('╚═══════════════════════════════════════════════════════════╝');
console.log('');
