require "minitest/autorun"

class TemplateTest < Minitest::Test
  def setup
    system("[ -d dunnas_app ] && rm -rf dunnas_app")
  end

  def teardown
    setup
  end

  def test_generator_succeeds
    output, err = capture_subprocess_io do
      system("DISABLE_SPRING=1 rails new -m template.rb dunnas_app")
    end
    assert_includes output, "Metronicstart app successfully created!"
  end
end
