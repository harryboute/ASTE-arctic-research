function array_info(A)
    
    % Display information
    disp('Array Information:');
    disp(['Size: ',     num2str(size(A))]);
    disp(['NaN: ',      num2str(length(A(isnan(A))))]);
    disp(['Mean: ',     num2str(nanmean(A(:)))]);
    disp(['Magnitude: ',num2str(min(abs(A(A~=0))))]);
    disp(['Maximum: ',  num2str(max(A(:)))]);
    disp(['Minimum: ',  num2str(min(A(:)))]);
    disp(['Positive: ', num2str(length(A(A>0)))])
    disp(['Negative: ', num2str(length(A(A<0)))])

end
