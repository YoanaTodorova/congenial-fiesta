require './lib/compute_checksum'

RSpec.describe ComputeChecksum do
  describe '.call' do
    context 'when a string is not provided' do
      subject { described_class.call }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when a string is provided' do
      context 'example 1' do
        let(:expected) do
          {
            count_of_original_words: 7,
            count_of_newly_created_words: 4,
            count_of_upper_case_vowels: 5,
            count_of_consonants: 21,
            length_of_original_string: 37
          }
        end
        let(:string) { 'foo bar baz wibble fizzbuzz fizz buzz' }
        subject { described_class.call(string: string) }

        it 'returns a hash of all checksums' do
          expect(subject).to eq(expected)
        end
      end

      context 'example 2' do
        let(:expected) do
          {
            count_of_original_words: 9,
            count_of_newly_created_words: 4,
            count_of_upper_case_vowels: 3,
            count_of_consonants: 24,
            length_of_original_string: 43
          }
        end
        let(:string) { 'The quick brown fox jumps over the lazy dog' }
        subject { described_class.call(string: string) }

        it 'returns a hash of all checksums' do
          expect(subject).to eq(expected)
        end
      end
    end
  end
  describe '#remove_non_english_alphabet_characters' do
    let(:string) { 'здравейте The fiv5e boxing wizards jump quick#ly' }
    let(:expected) { ' The five boxing wizards jump quickly' }
    subject do
      described_class.new(string: string).remove_non_english_alphabet_characters
    end

    it 'removes characters that do not belong to the English alphabet' do
      expect(subject).to eq(expected)
    end
  end

  describe '#split_into_limited_characters_strings' do
    let(:string) { 'The five boxing wizards jump quickly' }
    let(:expected) { 'Thefivebox ingwizards jumpquickl y' }
    subject do
      described_class.new(string: string).split_into_limited_characters_strings
    end

    it 'creates words which are 10 characters long' do
      expect(subject).to eq(expected)
    end
  end

  describe '#capitalize_each_word' do
    let(:string) { 'The five    boxing wizards jump quickly' }
    let(:expected) { 'The Five    Boxing Wizards Jump Quickly' }
    subject { described_class.new(string: string).capitalize_each_word }

    it 'capitalizes each word' do
      expect(subject).to eq(expected)
    end
  end

  describe '#upcase_vowel_after_consonants_and_upcase_vowel' do
    subject do
      described_class
        .new(string: string)
        .upcase_vowel_after_consonants_and_upcase_vowel
    end

    context 'when preceeding consonants are next to each other' do
      let(:string) { 'Thequickbr Ownfoxjump Soverthela Zydog' }
      let(:expected) { 'Thequickbr OwnfOxjUmp Soverthela Zydog' }

      it 'upcases the vowel' do
        expect(subject).to eq(expected)
      end
    end

    context 'when preceeding consonants are separated by a whitespace' do
      let(:string) { 'childrEn do need freedom' }
      let(:unexpected) { 'childrEn dO need freedom' }

      it 'does not upcase the vowel' do
        expect(subject).not_to eq(unexpected)
      end
    end
  end
end
