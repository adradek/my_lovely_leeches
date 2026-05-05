class ApplicationCommand
  include Dry::Monads[:result, :do]

  def self.call(...) = new(...).call

  def call
    raise NotImplementedError, "#call method should be implemented in the #{self.class} subclass"
  end
end
