require 'byebug'

module Orchparty
  module Transformations
    class Mixin
      def transform(ast)
        ast.applications.transform_values! do |application|
          current = AST::Application.new
          application.mix.each do |mixin_name|
            mixin = application.mixins[mixin_name] || ast.mixins[mixin_name]
            current = current.deep_merge_concat(mixin)
          end
          transform_application(current.deep_merge_concat(application), ast)
        end
        ast
      end

      def transform_application(application, ast)
        application.services = application.services.transform_values! do |service|
          current = AST::Service.new
          service.delete(:_mix).each do |mixin|
            if mixin.include? "."
              mixin_name, mixin_service_name = mixin.split(".")
              current = current.deep_merge_concat(ast.mixins[mixin_name].services[mixin_service_name])
            else
              current = current.deep_merge_concat(application.mixins[mixin])
            end
          end
          current.deep_merge_concat(service)
        end
        application
      end
    end
  end
end
