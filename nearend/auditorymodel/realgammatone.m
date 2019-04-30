function h = realgammatone(f, f0, order)

h   = zeros(length(f0), length(f));

for i =1:length(f0)
    k       = (2^(order-1)*factorial(order-1)) / (pi*dfactorial(2*order-3));
    h(i, :) = (1 + ((f-f0(i)) ./ (k.*ftoerb(f0(i)))).^2).^(-order/2);
end

function erb = ftoerb(f)
erb = 24.7 * (4.37*(f/1000) + 1);