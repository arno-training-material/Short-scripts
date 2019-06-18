function cost = lsq(mu, time_measurements,y_m, Int_opts)
sol = simulate_vdp(time_measurements,mu,[],[],Int_opts);
cost = sum(sum((sol.x-y_m).^2));
end

