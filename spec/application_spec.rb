require 'spec_helper'

describe 'main_application requests' do
  describe 'GET /' do
    it 'returns OK' do
      get '/'

      expect(last_response).to be_ok
    end
  end

  describe 'POST /compute' do
    let(:string) { 'example input' }
    let(:checksum) do
      [
        :count_of_original_words,
        :count_of_newly_created_words,
        :count_of_upper_case_vowels,
        :count_of_consonants,
        :length_of_original_string
      ].map.with_index { |key, index| [key, index] }.to_h
    end
    before do
      allow(
        ComputeChecksum
      ).to receive(:call).with(string: string).and_return(checksum)
    end
    subject { post '/compute', string: string }

    it 'returns ok' do
      subject

      expect(last_response).to be_ok
    end

    it 'calls ComputeChecksum.call' do
      subject

      expect(ComputeChecksum).to have_received(:call)
    end

    it 'returns checksum result' do
      subject

      checksum.values.each do |value|
        expect(last_response.body).to include(value.to_s)
      end
    end
  end
end
