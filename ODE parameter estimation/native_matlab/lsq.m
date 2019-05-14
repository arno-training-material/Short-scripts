function squared_error = lsq(mu,tspan,y0,ym)
    odefcn = @(t,y) vdp(t,y,mu);
    [~,y] = ode45(odefcn, tspan, y0);
    squared_error = sum(sum((y-ym).^2));
end

