# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `RubyLsp::Rails::ModelsController`.
# Please instead update this file by running `bin/tapioca dsl RubyLsp::Rails::ModelsController`.

class RubyLsp::Rails::ModelsController
  sig { returns(HelperProxy) }
  def helpers; end

  module HelperMethods
    include ::ActionController::Base::HelperMethods
  end

  class HelperProxy < ::ActionView::Base
    include HelperMethods
  end
end