module Straight
  module AddressProvider
    class Bip32
      class << self

        def new_address(args, gateway)
          if gateway.address_derivation_scheme.to_s.empty?
            # First check the depth. If the depth is 4 use '/i' notation (Mycelium iOS wallet)
            # TODO deal with other depths later. Currently only supports 0 and 4
            if gateway.keychain.depth > 3
              gateway.keychain.node_for_path(args[:keychain_id].to_s).to_address
            else # Otherwise, use 'm/0/n' - both Electrum and Mycelium on Android
              gateway.keychain.node_for_path("m/0/#{args[:keychain_id].to_s}").to_address
            end
          else
            gateway.keychain.node_for_path(
              gateway.address_derivation_scheme.to_s.downcase.sub('n', args[:keychain_id].to_s)
            ).to_address
          end
        end
      end
    end
  end
end
