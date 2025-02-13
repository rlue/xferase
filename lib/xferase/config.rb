# frozen_string_literal: true

require 'singleton'
require 'optparse'

require 'photein/config'

module Xferase
  class Config
    include Singleton

    OPTIONS = [
      ['-v',              '--verbose',                 'print verbose output'],
      ['-i INBOX',        '--inbox=INBOX',             'path to the inbox (required)'],
      ['-l LIBRARY',      '--library=LIBRARY',         'path to the master library (required)'],
      ['-w LIBRARY_WEB',  '--library-web=LIBRARY_WEB', 'path to the web-optimized library'],
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
          opts.version = Xferase::VERSION
          opts.banner  = <<~BANNER
            Usage: xferase [--version] [-h | --help] [<args>]
          BANNER

          OPTIONS.each { |opt| opts.on(*opt) }
        end.tap { |p| p.parse!(into: @params) }

        @params.freeze

        raise "no inbox directory given" if !@params.key?(:inbox)
        (%i[library library-web] & @params.keys)
          .then { |dest_dirs| raise "no destination library given" if dest_dirs.empty? }
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

      def extract_photein_opts(path)
        path.to_s.split('/')
          .grep(/^(shift-timestamp|local-tz):.+$/)
          .map { |opt| opt.split(':', 2) }
          .select(&method(:validate_photein_opt))
          .map(&method(:normalize_photein_opt)).to_h
      end

      private

      def validate_photein_opt(opt)
        case opt.first
        when 'shift-timestamp'
          opt.last.match?(/^[+-]?\d+h$/)
        when 'local-tz'
          Photein::Config::TZ_GEOCOORDS
            .transform_keys(&:downcase)
            .key?(opt.last.tr(':', '/').downcase)
        end
      end

      def normalize_photein_opt(opt)
        case opt.first
        when 'shift-timestamp'
          [:shift_timestamp, opt.last.tr('+h', '')]
        when 'local-tz'
          [:local_tz, opt.last.tr(':', '/')]
        end
      end
    end
  end
end
