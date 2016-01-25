module blackbox(u, c, t, y);
    output u;
    input  c, t, y;
    wire   w02, w07, w39, w46, w47, w49, w53, w54, w58, w59, w64, w65, w72, w75, w76, w78, w80, w87, w88, w91, w93, w94;

    or  o50(u, w58, w64, w87);
    and a31(w58, w80, w59, w72);
    not n19(w72, w49);
    and a71(w64, w59, w49, w80);
    and a33(w87, w65, w47);
    not n77(w65, w59);
    or  o67(w47, w78, w39);
    and a12(w78, w80, w49);
    and a52(w39, w91, w80);
    not n61(w91, w49);
    or  o43(w49, w75, w94);
    and a11(w75, w54, w02);
    not n21(w54, c);
    not n81(w02, t);
    and a5(w94, c, t, y);
    or  o17(w59, w53, t, w07);
    not n18(w53, y);
    not n82(w07, c);
    and a62(w80, y, w88);
    or  o85(w88, w76, w46);
    not n98(w76, t);
    and a9(w46, c, w93);
    not n40(w93, c);

endmodule // blackbox
