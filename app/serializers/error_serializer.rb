class ErrorSerializer
  attr_reader :exception, :status

  def initialize(exception, status)
    @exception = exception
    @status = status
  end

  def format_error
    {
      error: [
        {
          status: status,
          title: exception.message
        }
      ]
    }
  end
end