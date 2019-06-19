# frozen_string_literal: true

FactoryGirl.define do
  sequence :apns_token do |i|
    "ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b596#{i}"
  end

  sequence :gcm_registration_id do |i|
    "APA91bHPRgkF3JUikC4ENAHEeMrd41Zxv3hVZjC9KtT8OvPVGJ-hQMRKRrZuJAEcl7B338qju59zJMjw2DELjzEvxwYv7hH5Ynpc1ODQ0aT4U4OFEeco8ohsN5PjL1iC2dNtk2BAokeMCg2ZXKqpc8FXKmhX94kIxQ#{i}"
  end

  sequence :fcm_registration_id do |i|
    "egp-7jEODbM:APA91bGODoU9taMK10FDVvJI_ZhKXHl_GKoLKIDrQ0PTJn5SD2mFOtOiPxeTlkATAYI-eU4oucF6rPsAiXdgu9fFbmuDsprmx_bakCFPvIoN1Axg8SzqtnZpzagc0LZOJxNeZB-VVgcc#{i}"
  end

  sequence :mpns_device_url do |i|
    "http://s.notify.live.net/u/1/bn1/HmQAAACP-0esPuxBSkzBNNXH4W0lV3lK-stEw6eRfpXX39uYbM7IwehXOTO9pRBjaaGECWOdD_7x5j5U4w4iXG4hGxer/d2luZG93c3Bob25lZGVmYXVsdA/EMDhx32Q5BG0DWnZpuVX1g/kRFAu0-jnhMQ-HG94rXzrbb0wQk#{i}"
  end

  sequence :wns_device_url do |i|
    "https://hk2.notify.windows.com/?token=AwYAAABe%2bpjShu%2fzcVaaf1NPm%2b2dpiosm7RnmBJGMVkBDiYNXpAEp0mETldEu8axFoamgwb%2fdKCuNSfGGDHZ3RcaO2fcNGfxC6Y4Yp3xTFkDOhv5kNfgSXef7pSP0uwueIpqbWI%3d#{i}"
  end
end
