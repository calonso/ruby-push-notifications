
FactoryGirl.define do
  sequence :apns_token do |i|
    "ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b596#{i}"
  end

  sequence :gcm_registration_id do |i|
    "APA91bHPRgkF3JUikC4ENAHEeMrd41Zxv3hVZjC9KtT8OvPVGJ-hQMRKRrZuJAEcl7B338qju59zJMjw2DELjzEvxwYv7hH5Ynpc1ODQ0aT4U4OFEeco8ohsN5PjL1iC2dNtk2BAokeMCg2ZXKqpc8FXKmhX94kIxQ#{i}"
  end
end
