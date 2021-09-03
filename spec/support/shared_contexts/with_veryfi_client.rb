# frozen_string_literal: true

shared_context :with_veryfi_client do
  let(:client) do
    Veryfi::Client.new(
      client_id: "fBvJLm1zCJ8Doxf94mMrpbrkDp8nr",
      client_secret: "FDPXbxHTrSKPAVOJGoB0doUWhJmmbcm3ajFTwtclagdlygkp3yuIMJjirFbO1oKGC4nr",
      username: "john_doe",
      api_key: "123456"
    )
  end
end
