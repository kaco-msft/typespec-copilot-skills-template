# How to generate your Copilot skill

1. Run `tsp install` to install project dependencies.
3. Run `tsp compile .` to compile the TypeSpec (main.tsp)
4. View your OAS output in `@typespec/openapi3/openapi.yaml`.
5. Run `./generateApiPlugin.ps1` to generate your API plugin.
6. Open `output/suno-apiplugin.json` to view your API plugin manifest.