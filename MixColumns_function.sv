module MixColumns_function (
    input  logic [127:0] in,
    output logic [127:0] dataout
);
    function automatic logic[7:0] times2(input logic [7:0] a);
        if (a[7] == 1)
            times2 = (a << 1) ^ 8'h1b;
        else
            times2 = a << 1;
    endfunction

    function automatic logic[7:0] times3(input logic [7:0] a);
        times3 = a ^ times2(a);
    endfunction

    function automatic logic[31:0] mix(input logic [31:0] a);
        logic[7:0] a0, a1, a2, a3;
        a3 = times2(a[31:24]) ^ times3(a[23:16]) ^ a[15:8] ^ a[7:0];
        a2 = a[31:24] ^ times2(a[23:16]) ^ times3(a[15:8]) ^ a[7:0];
        a1 = a[31:24] ^ a[23:16] ^ times2(a[15:8]) ^ times3(a[7:0]);
        a0 = times3(a[31:24]) ^ a[23:16] ^ a[15:8] ^ times2(a[7:0]);
        mix = {a3, a2, a1, a0};
    endfunction

    always_comb begin
        dataout[127:96] = mix(in[127:96]);
        dataout[95:64]  = mix(in[95:64]);
        dataout[63:32]  = mix(in[63:32]);
        dataout[31:0]   = mix(in[31:0]);
    end
endmodule
