class ApplicationCommand
  include Dry::Monads[:result, :do]

  def self.call(...) = new(...).call

  def call
    raise NotImplementedError
  end
end
