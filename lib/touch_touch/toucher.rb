module TouchTouch
  module Toucher
    class ClassNotDefined < StandardError; end

    class << self
      def included(klass)
        klass.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods
        def touch_alias(*args)
          al = args.first.to_s
          pa = args.second
          classs = pa[:class]
          limit = pa[:limit]
          class_name = classs.name.downcase

          define_method(al.to_sym) do |arg|
            raise(ClassNotDefined, "Class is not defined") unless arg.instance_of? classs

            redis = TouchTouch::Redis.new
            redis.set(self.class, self.id, al, arg.class, arg.id, limit)
          end

          define_method("#{al}_#{class_name.pluralize}".to_sym) do
            redis = TouchTouch::Redis.new
            touchee_ids = redis.get(self.class, self.id, al, classs)
            classs.find(touchee_ids)
          end
        end
      end
    end
  end
end
