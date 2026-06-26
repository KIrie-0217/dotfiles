// hr autocomplete spec — herdr wrapper with git-aware layout selection.

var aiSubcommands = [
  { name: "claude", description: "Start with claude (default)" },
  { name: "kiro", description: "Start with kiro-cli chat" },
];

var completionSpec = {
  name: "hr",
  description: "herdr launcher with git-aware layout selection",
  subcommands: aiSubcommands,
};

module.exports = { default: completionSpec };
