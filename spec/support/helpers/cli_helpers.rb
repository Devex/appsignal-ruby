module CLIHelpers
  def cli
    Appsignal::CLI
  end

  def run_cli(command, options = {})
    cli.run(format_cli_arguments_and_options(command, options))
  end

  def format_cli_arguments_and_options(command, options = {})
    [*command].tap do |o|
      options.each do |key, value|
        o << "--#{key}=#{value}"
      end
    end
  end
end
