# Features

## Document Symbol

Document Symbol is a way to represent the structure of a document. They are used to provide a quick overview of the
document and to allow for quick navigation.

Ruby LSP already provides document symbols for Ruby files, such as classes, modules, methods, etc. But the Rails addon
provides additional document symbols for Rails specific features.

In VS Code, you can open the document symbols view by pressing `Ctrl + Shift + O`.

### Active Record Callbacks, Validations, and Associations

Navigates between Active Record callbacks, validations, and associations using the `Document Symbol` feature.

![Document Symbol for Active Record Callbacks, Validations, and Associations](./ruby-lsp-rails-document-symbol-ar-model.gif)

### Active Support Test Cases

Navigates between Active Support test cases using the `Document Symbol` feature.

![Document Symbol for tests](./ruby-lsp-rails-test-document-symbol.gif)

## Go to Controller Action Route

Navigates to the route definition of a controller action using the `Code Lens` feature.

![Go to Controller Action Route](./ruby-lsp-rails-controller-action-to-route.gif)

## Go to Controller Action View

Navigates to the view file(s) of a controller action using the `Code Lens` feature.

![Go to Controller Action View](./ruby-lsp-rails-controller-action-to-view.gif)

## Go to Definition

Go to definition is a feature that allows you to navigate to the definition of a symbol.

In VS Code, you can trigger go to definition in 3 different ways:

- Select `Go to Definition` from the context menu
- `F12` on a symbol
- `Cmd + Click` on a symbol

In the following demos, we will use the `Cmd + Click` method to trigger go to definition.

### Go to Active Record Callback and Validation Definitions

Navigates to the definitions of Active Record callbacks and validations.

![Go to Active Record Callback and Validation Definitions](./ruby-lsp-rails-go-to-ar-dsl-definitions.gif)

### Go to Active Record Associations

Navigates to the definitions of Active Record associations.

![Go to Active Record Associations](./ruby-lsp-rails-go-to-ar-associations.gif)

### Go to Route Helper Definitions

![Go to Route Helper Definitions](./ruby-lsp-rails-go-to-route-definitions.gif)

## Ruby File Operations

The Ruby LSP extension provides a `Ruby file operations` icon in the Explorer view that can be used to trigger
the `Rails generate` and `Rails destroy` commands.

![Ruby file operations](./ruby-lsp-rails-file-operations-icon.gif)

### Commands

These commands are also available in the Command Palette.

#### Rails Generate

![Rails Generate](./ruby-lsp-rails-generate-command.gif)

#### Rails Destroy

![Rails Destroy](./ruby-lsp-rails-destroy-command.gif)

## Run and Debug

The Rails addon provides 3 ways to run and debug `ActiveSupport` tests using the `Code Lens` feature.

### Run Tests With Test Explorer

![Run Tests With Test Explorer](./ruby-lsp-rails-run.gif)

### Run Tests In The Terminal

![Run Tests In The Terminal](./ruby-lsp-rails-run-in-terminal.gif)

### Debug Tests With VS Code

![Debug Tests With VS Code](./ruby-lsp-rails-debug.gif)
