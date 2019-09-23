function dataMag = powerLog( data )
%POWERLOG Summary of this function goes here
%   Detailed explanation goes here

dataMag = 10 * log10( abs( data ) + eps );

end

