function coef = coef_correntropia(x,y,weight_kernel)
    uxx = correntropia(x,x,weight_kernel);
    uyy = correntropia(y,y,weight_kernel);
    uxy = correntropia(x,y,weight_kernel);
    coef = uxy/(sqrt(uxx)*sqrt(uyy));
end