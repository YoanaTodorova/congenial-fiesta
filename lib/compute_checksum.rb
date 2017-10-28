class ComputeChecksum
  def self.call(**args)
    new(args).call
  end

  attr_reader :original_string, :modified_string

  def initialize(string:)
    @original_string = string
    @modified_string = string.dup

    raise ArgumentError, 'Missing required argument string' unless string
  end

  def call
    apply_modifications_to_string

    {
      count_of_original_words: ,
      count_of_newly_created_words: ,
      count_of_upper_case_vowels: ,
      count_of_consonants: ,
      length_of_original_string: ,
    }
  end

  def apply_modifications_to_string
    remove_non_english_alphabet_characters
    split_into_limited_characters_strings
    capitalize_each_word
    upcase_vowel_after_consonants_and_upcase_vowel
  end
end
