# frozen_string_literal: true

require 'fileutils'

require 'tty-config'

class Configuration
  CONFIG_ALLOWED_SYMBOLS = %i[set append fetch remove].freeze

  def initialize(
    config_dir: default_config_dir, config_name: default_filename
  )
    @config_dir = config_dir
    @config_name = config_name
    @config = create_config
  end

  def nuke
    create_config.write(force: true)
    self
  end

  def config_file_path
    config_dir + '/' + config_name + '.yml'
  end

  def respond_to_missing?(symbol)
    CONFIG_ALLOWED_SYMBOLS.include?(symbol)
  end

  def method_missing(symbol, *args)
    return super unless CONFIG_ALLOWED_SYMBOLS.include?(symbol)

    mkdir_once
    config.read if config.exist?
    resp = config.public_send(symbol, *args)
    config.write(force: true)

    resp
  end

  private

  attr_reader :config_dir, :config_name, :config

  def create_config
    config = TTY::Config.new
    config.filename = config_name
    config.append_path(config_dir)

    config
  end

  def default_config_dir
    "#{ENV['HOME']}/.config/kudrykv/michael"
  end

  def default_filename
    'config'
  end

  def mkdir_once
    @mkdir_once ||= FileUtils.mkdir_p(config_dir)
  end
end
