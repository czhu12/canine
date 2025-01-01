# Autogenerated by autotester

FactoryBot.define do
  factory :log_output do
    loggable_type { "SomeLoggableType" }
    loggable_id   { 1 }
    output        { "Sample log output text" }

    trait :with_specific_loggable do
      association :loggable, factory: :specific_loggable
    end

    trait :with_long_output do
      output { "This is a very long log output text that exceeds normal length to test edge cases." }
    end

    trait :with_empty_output do
      output { "" }
    end

    # Assuming there are other loggable types in the system
    trait :for_another_loggable do
      loggable_type { "AnotherLoggableType" }
      loggable_id   { 2 }
    end
  end
end
