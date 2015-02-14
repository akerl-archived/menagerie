require 'spec_helper'

describe Menagerie do
  describe '#new' do
    it 'creates collection objects' do
      expect(Menagerie.new).to be_an_instance_of Menagerie::Collection
    end
  end

  describe '#get_logger' do
    let(:logger) { Menagerie.get_logger }
    let(:quiet_logger) { Menagerie.get_logger(false) }

    let(:produce_output) { output(/hello/).to_stdout_from_any_process }

    it 'returns a logger object' do
      expect(logger).to be_an_instance_of Logger
    end

    it 'writes to stdout' do
      expect { logger.warn('hello') }.to produce_output
    end

    it 'shows debugging by default' do
      expect { logger.info('hello') }.to produce_output
    end

    it 'allows silencing debug output' do
      expect { quiet_logger.info('hello') }.to_not produce_output
      expect { quiet_logger.warn('hello') }.to produce_output
    end
  end
end
