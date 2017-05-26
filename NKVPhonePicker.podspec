#
# Be sure to run `pod lib lint CountryPicker.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = 'NKVPhonePicker'
  s.version          = '1.0.0'
  s.summary          = 'A UITextField subclass to simplify the selection of country codes.'
  s.description      = <<-DESC
    With this pod you can easily select country codes with just making your textFields class - the NKVPhonePickerTextField.
                       DESC

  s.homepage         = 'https://github.com/NikKovIos/NKVPhonePicker'
  s.ios.deployment_target = '9.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nik Kov' => 'nikkovios@gmail.com' }
  s.source           = {
    :git => 'https://github.com/NikKovIos/NKVPhonePicker.git',
    :tag => s.version.to_s }


  s.module_name  = 'NKVPhonePicker'
  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {
    'CountryPicker' => ['Sources/Bundle/*']
  }

  s.social_media_url = 'https://vk.com/lightwithme'

end
