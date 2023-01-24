function CBL_PDF = CBL_verticalPDF(wA_bar, wB_bar, sigA, sigB, A, B)

mu = [wA_bar; -wB_bar];
sigma = cat(3, sigA^2, sigB^2);    % concatenate two(=k) 1x1 covariance matrices via the third dimension 
                                    % sigma(:,:,k) contains a covariance matrix for each gaussian component k
p = [A,B];

CBL_PDF = gmdistribution(mu,sigma,p);
end

