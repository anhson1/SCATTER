function resp = instrument_resp_afc(freq)

% uses generate_response.m from http://www.iris.edu/hq/files/programs/education_and_outreach/lessons_and_resources/docs/bb_processing_matlab/

% % zeros and poles from STS-2 Coefficients

% 1
% zeros = [
%      0.000000e+000 +  0.000000e+000 * i
%      0.000000e+000 +  0.000000e+000 * i
%     ];
% poles = [
%     -3.700000e-002 +  3.700000e-002 * i
%     -3.700000e-002 + -3.700000e-002 * i
%     ];
% k = 1;

 2
 zeros = [
     -1.333888e+004 + 0.000000e+000 * i
     ];
 poles = [];
 k = 1.333889e+004 ;


resp = nan(size(freq));

for f = 1:length(freq)
    resp(f) = generate_response(zeros, poles, 1/k, freq(f));
end

%figure
%loglog(freq, abs(resp));

return
