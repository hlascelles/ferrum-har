# frozen_string_literal: true

# This module is prepended to Ferrum::Page to add the #har method.
module Ferrum
  module Har
    module PageExtension
      class HarNotReadyError < RuntimeError
        # Used to loop until the HAR is ready.
      end

      # This method waits until the page is idle, then fetches the HAR and decodes it.
      def har
        network.wait_for_idle
        execute("document.ferrumHarRequested = true;")
        base64_encoded_har = Ferrum::Utils::Attempt.with_retry(
          errors: [HarNotReadyError],
          max: 200,
          wait: 0.5
        ) do
          found = evaluate("document.ferrumHar;")
          raise HarNotReadyError unless found

          found
        end
        inlined_har = Base64.decode64(base64_encoded_har)
        har_hash = JSON.parse(inlined_har)
        raise "Result does not appear to be a HAR" unless har_hash.key?("log")

        JSON.pretty_generate(har_hash)
      end
    end
  end
end
