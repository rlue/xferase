# frozen_string_literal: true

require 'singleton'
require 'optparse'

module Photein
  class Config
    include Singleton

    OPTIONS = [
      ['-v',             '--verbose',                              'print verbose output'],
      ['-s SOURCE',      '--source=SOURCE',                        'specify the source directory'],
      ['-d DESTINATION', '--dest=DESTINATION',                     'specify the destination directory'],
      ['-r',             '--recursive',                            'ingest source files recursively'],
      ['-k',             '--keep',                                 'do not delete source files'],
      ['-i',             '--interactive',                          'ask whether to import each file found'],
      ['-n',             '--dry-run',                              'perform a "no-op" trial run'],
      [                  '--safe',                                 'skip files in use by other processes'],
      [                  '--optimize-for=TARGET', %i[desktop web], 'compress images/video before importing']
    ].freeze

    OPTION_NAMES = OPTIONS
      .flatten
      .grep(/^--/)
      .map { |option| option[/\w[a-z\-]+/] }
      .map(&:to_sym)

    class << self
      def parse_opts!
        @params = {}

        parser = OptionParser.new do |opts|
          opts.version = Photein::VERSION
          opts.banner  = <<~BANNER
            Usage: photein [--version] [-h | --help] [<args>]
          BANNER

          OPTIONS.each { |opt| opts.on(*opt) }
        end.tap { |p| p.parse!(into: @params) }

        @params[:verbose] ||= @params[:'dry-run']
        @params.freeze

        raise "no source directory given" if !@params.key?(:source)
        raise "no destination directory given" if !@params.key?(:dest)
      rescue => e
        warn("#{parser.program_name}: #{e.message}")
        warn(parser.help) if e.is_a?(OptionParser::ParseError)
        exit 1
      end

      def [](key)
        @params[key]
      end

      def method_missing(m, *args, &blk)
        m.to_s.tr('_', '-').to_sym
          .then { |key| OPTION_NAMES.include?(key) ? self[key] : super }
      end

      def respond_to_missing?(m, *args)
        @params.key?(m.to_s.tr('_', '-').to_sym) || super
      end
    end
  end
end
