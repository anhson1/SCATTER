% generate_response.m
% usage:
% [complex_valued_output] =
% generate_response(complex_zeros,complex_poles,scalar_constant, scalar_frequency)
%
% function is a subroutine of transfer program
% routine mimics the analog laplacian transfer function as programmed in
% evalresp.
% Original c code:
%   1 analog_trans(struct blkt *blkt_ptr, double freq, struct complex *out) {  
%   2    int nz, np, i;
%   3    struct complex *ze, *po, denom, num, omega, temp;
%   4    double h0, mod_squared;
%   5 
%   6    if (blkt_ptr->type == LAPLACE_PZ) freq = twoPi * freq;
%   7    omega.imag = freq;
%   8    omega.real = 0.0;
%   9    denom.real = denom.imag = num.real = num.imag = 1.0;
%  10 
%  11    ze = blkt_ptr->blkt_info.pole_zero.zeros;
%  12    nz = blkt_ptr->blkt_info.pole_zero.nzeros;
%  13    po = blkt_ptr->blkt_info.pole_zero.poles;
%  14    np = blkt_ptr->blkt_info.pole_zero.npoles;
%  15    h0 = blkt_ptr->blkt_info.pole_zero.a0;
%  16 
%  17    for (i = 0; i < nz; i++) {
%  18          /* num=num*(omega-zero[i]) */
%  19          temp.real = omega.real - ze[i].real;
%  20          temp.imag = omega.imag - ze[i].imag;
%  21      zmul(&num, &temp);
%  22    }
%  23    for (i = 0; i < np; i++) {
%  24          /* denom=denom*(omega-pole[i]) */
%  25          temp.real = omega.real - po[i].real;
%  26          temp.imag = omega.imag - po[i].imag;
%  27      zmul(&denom, &temp);
%  28    }
%  29 
%  30    /* gain*num/denum */
%  31 
%  32    temp.real = denom.real;
%  33    temp.imag = -denom.imag;
%  34    zmul(&temp, &num);
%  35    mod_squared = denom.real*denom.real + denom.imag*denom.imag;
%  36    temp.real /= mod_squared;
%  37    temp.imag /= mod_squared;
%  38    out->real = h0 * temp.real;
%  39    out->imag = h0 * temp.imag;
%  40  }
%
%
% The use of numerous points and structures makes the c code complicated to
% look at. This matlab function utilizes arrays of poles and zeros and the
% scalar constant to just do the math and output the real and imaginary
% components of the response at a desired frequency.
%
% input frequency in hertz. Code multiplies by 2pi to get angular frequency
%
% If making a sac pole zero file from a RESP file, make sure the constant
% is the overall sensitivity * the A0 normalization
% overall sensitivity is given at the very end and the A0 normalization is
% with the sensor poles and zeros


function out = generate_response(zeros,poles,constant,freq)
    %Initialize
    freq = freq * 2 * pi;
    omega = 0 + freq * i;
    denom = 1+1*i;
    num = 1+1*i;
    %zeros
    for j=1:length(zeros)
        temp = omega-zeros(j);
        num=num*temp;
    end
    %poles
    for j=1:length(poles)
        temp = omega-poles(j);
        denom = denom * temp;
    end
    %constant
    temp = real(denom) - imag(denom)*i;
    temp = temp * num;
    mod_squared = real(denom)*real(denom)+imag(denom)*imag(denom);
    temp = real(temp) / mod_squared + (imag(temp) / mod_squared) * i;
    out = constant * real(temp) + constant * imag(temp) * i;
    
    return

