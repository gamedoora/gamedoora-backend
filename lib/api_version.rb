# frozen_string_literal: true

# According to the Media Type Specification, you can define your own media
# types using the vendor tree i.e. application/vnd.example.resource.
# The vendor tree is used for media types associated with publicly available products.
# It uses the "vnd" facet.
# Thus, we define a custom vendor media type application/vnd.gamedoora.{version_number}
# giving clients the ability to choose which API version they require.

# app/lib/api_version.rb
class ApiVersion
  attr_reader :version, :default

  def initialize(version, default = false)
    @version = version
    @default = default
  end

  # check whether version is specified or is default
  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  def check_headers(headers)
    # check version from Accept headers; expect custom media type `todos`
    accept = headers[:accept]
    accept&.include?("application/vnd.gamedoora.#{version}")
  end
end