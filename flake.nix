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
					android_sdk.accept_license = true;
				};
			};
			node = pkgs.nodejs_24;
			in {
				devShells.React = pkgs.mkShell {
					buildInputs = with pkgs; [
					node
					jdk17
					android-tools
					androidsdk
					];
					shellHook = ''
						echo "React shell ready: node=$(node --version)"
						java -version
						adb version
						echo "sdkmanager = $(sdkmanager --version)"

						export ANDROID_SDK_ROOT=${pkgs.androidsdk}/libexec/android-sdk
						export ANDROID_HOME=${pkgs.androidsdk}/libexec/android-sdk
					'';
				};
			}
		);
}
