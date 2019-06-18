function dydt = VDP(t,y,mu)
    dydt = zeros(2,1);
    dydt(1) = mu*((1-y(2)^2)*y(1) - y(2));
    dydt(2) = y(1);
end

