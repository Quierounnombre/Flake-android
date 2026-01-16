{
  description = "Flake for developing on react";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
		flake-utils.url = "github:numtide/flake-utils";
	};
	outputs = { self, nixpkgs, flake-utils, ... }:
		flake-utils.lib.eachDefaultSystem (system:
			let
			pkgs = import nixpkgs {
				inherit system;
				config = {
					allowUnfree = true;
				};
			};
			node = pkgs.nodejs_24;
			in {
				devShells.React = pkgs.mkShell {
					buildInputs = with pkgs; [
					node
					jdk17
					android-tools
					sdkmanager
					androidenv.androidPkgs.emulator
					];
					shellHook = ''
						echo "React shell ready: node=$(node --version)"
						java -version
						adb version
						echo "sdkmanager = $(sdkmanager --version)"
					'';
				};
			}
		);
}
