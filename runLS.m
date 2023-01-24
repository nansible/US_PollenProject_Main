
function outputData = runLS(inputvars)
    if  inputvars(1) < 0
        outputData = CBL_model(inputvars(3), inputvars(5), 1./inputvars(1), inputvars(2), inputvars(6));
    else
        outputData = ASL_model(inputvars(3), inputvars(5), 1./inputvars(1), inputvars(2), inputvars(6));
    end
end



