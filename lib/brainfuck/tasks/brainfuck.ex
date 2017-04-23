defmodule Mix.Tasks.Brainfuck do
  use Mix.Task
  alias Brainfuck.Runtime

  @shortdoc "Runs one or more Brainfuck program source files provided as arguments."
  
  def run(argv) do
    Application.ensure_started(:brainfuck)

    {_, paths, _} = OptionParser.parse(argv)
    
    if Enum.all?(paths, &check_path(&1)) do
      main(paths)
    end
  end
  
  defp main(paths) do
    program_count = paths
    |> Enum.map(&retrieve_program(&1))
    |> Enum.map(&start_program(&1))
    |> Enum.count

    main_loop(program_count)
  end

  defp main_loop(0) do
    :ok
  end

  defp main_loop(program_count) do
    receive do
      :done ->
        main_loop(program_count - 1)
    after
      4_500 ->
        Mix.shell.info "#{program_count} program(s) timed out."
    end
  end
  
  defp check_path(path) do
    unless File.exists?(path) do
      Mix.shell.error "Could not read file #{path}: no such file or directory"
      false
    else
      true
    end
  end

  defp retrieve_program(path) do
    {path, File.read!(path)}
  end

  defp start_program({path, program_source}) do
    name = program_display_name(path)
    Mix.shell.info "#{name}> started"
    this = self()
    Runtime.start_program(program_source, fn state ->
      finish_program(name, state)
      send this, :done
    end)
  end

  defp finish_program(name, {:exit_success, outputs}) do
    Mix.shell.info "#{name}> #{to_string(outputs)}"
  end

  defp finish_program(name, {:exit_failure, error_reason}) do
    Mix.shell.error "#{name}> failed with reason: #{inspect(error_reason)}"
  end

  defp program_display_name(path) do
    path |> Path.rootname |> Path.basename
  end
end