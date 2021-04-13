# @Author: Robert D. Cotey II <coteyr@coteyr.net>
# @Date:   2014-10-17 00:02:43
# @Last Modified by:   Robert D. Cotey II <coteyr@coteyr.net>
# @Last Modified time: 2019-01-08 09:16:12

# Including objects are stating that they should register stuff with a Application level variable.
# Common uses are classes that need to register as being importable.
module Registerable
  def self.included base # :nodoc:
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods

  end

  module ClassMethods
    # Registers the class in the +section+ of the application level variable.
    def register_class(klass, section, options={})
      # [ {thing: [one, two, three], other: [four, five, six]}]
      array = Reportsla.configure.registers[section.to_sym]
      array = [] if array.nil?
      array << {klass: klass.name, options: options} if !array.include?({klass: klass.name, options: options})
      Reportsla.configure.registers[section] = array
    end
    # Returns class names registered in that +section+
    def regestered_classes(section)
      Reportsla.configure.registers[section].map{|c| c[:klass]}
    end
  end

end
