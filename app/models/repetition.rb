class Repetition
  include ActiveModel::Model

  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :interval

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :interval, presence: true,  numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def create_repetitions_from(training_course)
    if valid?
      interval = self.interval.to_i

      next_date = start_date
      while next_date < end_date do
        clone_training_course!(training_course, new_date: next_date)
        next_date += interval.days
      end

      true
    end
  end

  def assign_attributes(attributes)
    super fix_multi_parameter_attributes(attributes)
  end

private

  def clone_training_course!(training_course, new_date: nil)
    new_training_course = training_course.dup
    new_training_course.published = false
    new_training_course.categories = training_course.categories
    new_training_course.target_audiences = training_course.target_audiences
    new_training_course.date = new_date if new_date.present?
    new_training_course.save!
  end

  def fix_multi_parameter_attributes(attributes)
    multi_parameter_attributes = {}
    multi_parameter_attribute_values = {}

    attributes.each do |k, v|
      multi_parameter_attributes[k] = attributes.delete(k) if k.is_a?(String) && k.include?("(")
    end

    multi_parameter_attributes.each do |k, v|
      attribute_name = k.split("(").first
      attribute_position = find_multi_parameter_attribute_position(k)

      multi_parameter_attribute_values[attribute_name] ||= {}
      multi_parameter_attribute_values[attribute_name][attribute_position] = type_cast_multi_parameter_attribute_value(k, v)
    end

    multi_parameter_attribute_values.each do |k, v|
      date = Date.new(*Hash[multi_parameter_attribute_values[k].sort].values)
      attributes[k] = date
    end

    attributes
  end

  def find_multi_parameter_attribute_position(multiparameter_name)
    multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
  end

  def type_cast_multi_parameter_attribute_value(multiparameter_name, value)
    multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
  end

end
