From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Fri, 7 Jan 2011 04:24:34 -0500
Message-ID: <ig6m82$k8i$1@dough.gmane.org>
References: <ig5usq$tgi$1@dough.gmane.org> <adalj2xb6h0.fsf@cisco.com> <ada4o9lb42k.fsf@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Unfortunately it's very difficult to debug problems with the denx
> variant of an 18-month-old kernel.

I realize that I'm not only swimming in a backwater (embedded PowerPC),
but a rather fetid one at that (2.6.26).  I'm trying to evaluate how Infiniband
would work for us, using an existing product base so cannot easily change
levels.

I *greatly* appreciate your forbearance and patience!

> It might be instructive to watch /proc/interrupts on the ppc system and
> see if it goes up when the x86 subnet manager does a sweep.

> Also, do you have lspci on the ppc system?  What does "lspci -vvvxx" show?

I've captured this information but let me mention some more about my
environment first.

(1) There's no support for MSI / MSI-X interrupts on this platform at
    the 2.6.26 level.  I'm using conventional IRQs with mthca, and loading
    it with the module parameter msi_x=0 just to be sure.

(2) I've adapted and applied two "reachahead" mthca patches:
    I looked at all changes to mthca since 2.6.26 and found only
    one that looked interesting (DMA coherency related).  The other
    one looked good from a performance standpoint.

    These are both from you:

    commit e8bb4beb2b1f90d499134f2849727ed04c3bedc4
    Author: Roland Dreier
    Date:   Tue Jul 22 14:20:05 2008 -0700
    IB/mthca: Keep free count for MTT buddy allocator

    commit 99987bea474ceca8ec6fb05f81d7d188634cdffd
    Author: Roland Dreier
    Date:   Mon Jun 22 23:04:13 2009 -0700
    IB/mthca: Replace dma_sync_single() use with proper functions

    These patches had no effect on the problem and were present in the
    system when I captured the information below.

(3) I've added a few printk's of my own as well as enabling all code in
    the driver which looked to be debugging-related.  There were a number
    "if (0)" conditionals for debugging which I have changed to "if (1)".

    Unfortunately, I don't know anything about the Mellanox hardware so
    wasn't able to learn anything useful from this.  I'm hoping this info might
    provide additional insight.

I think the *big* change since 2.6.19 was the retirement of the old "ppc"
Linux tree and its replacement with the "powerpc" tree.  I settled on using
2.6.26 two years ago because this transition from ppc to powerpc had been
completed.

I think it was the merger of the 64-bit PowerPC with the 32-bit ppc that led
to things like the phys_addr_t type, etc.  There must be some other aspect
new to the powerpc tree which requires adjustment by the driver.

I've had some experience with this, in getting some of the other drivers to
work in this environment (e.g. a FC driver and some work with USB drivers).
But I haven't been able to figure out what's wrong here.

I suppose it is possible that the problem is not in the driver, but elsewhere in
the 2.6.26 kernel.  I've reviewed the I/O mappings and 440 core definitions
but have not found anything wrong.

I'm including two attachments:

(A) ib-console.txt
    This is the Linux console showing the Infiniband driver load.
    The card is using IRQ 18 and I have displayed /proc/interrupts before
    loading the IB drivers, after loading the IB drivers, and after starting
    the subnet manager on the Intel host.

    While a number of interrupts are seen during the driver loading, *no*
    interrupts occur as a result of starting the subnet manager on the
    Intel host.

    I assume the use of conventional IRQ is OK, as the driver did its NOP
    test and it passed.  But I take it that the incoming messages from the
    subnet manager should have caused additional IRQs to occur (but did
    not).

    I've also displayed /proc/iomem to show the I/O mappings before and
    after loading the drivers.  That's to show that the phys_addr_t changes
    are working and doing the right thing (I think they are).

    I'm loading all IB drivers in my universe, which is overkill at this point,
    I know.  I've also tried just loading the three that would seem minimally
    required to get the subnet manager on the other host happy (ib_core,
    ib_mad, and ib_mthca).  This does not change the symptoms.

    To be clear:  I did not have the subnet manager running at the time of
    loading the drivers.  I waited until they had come up and then started
    the subnet manager.  I have marked this point by manually invoking
    the logger utility to write a message to the messages file:

    logger -t JLB about to start subnet manager

(B) ib-messages.txt
    This is the 440SPe Linux messages file, showing the drivers being loaded
    as well as the driver debugging messages.

    Note that *nothing* happens after the "about to start subnet manager"
    entry.

Should I look at trying to dump some part of the Mellanox card memory
areas?  In December, I had used GDB against the live system using
/proc/kcore.  I used this to display and format the driver's struct mthca_dev.
I was hoping something might "leap out at me" (but nothing did!).

I just don't know enough about the Mellanox hardware to know what to
check.  For example, if there's a queue showing pending work, etc.

But I'll stop here, as I fear this note may already be too big!

Thanks again for your help.

John Burr



begin 666 ib-console.txt
M?B C(&-A=" O<')O8R]I;G1E<G)U<'1S"B @(" @(" @(" @0U!5, H@,3@Z
M(" @(" @(" @(#$@("!524,@("!,979E;" @(" @<&-I96AP"B Q.3H@(" @
M(" @(" @,B @(%5)0R @($QE=F5L(" @("!P8VEE:' L('!C:65H< H@,C Z
M(" @(" @(" @(#D@("!524,@("!,979E;" @(" @<&-I96AP+"!P8VEE:' *
M(#(Q.B @(" @(" @(" T(" @54E#(" @3&5V96P@(" @('!C:65H<"P@<&-I
M96AP"B R,CH@(" @(" @,S<R," @(%5)0R @($QE=F5L(" @("!S97)I86P*
M(#(U.B @(" @(" @-# Y(" @54E#(" @3&5V96P@(" @($E"32!)24,*(#(V
M.B @(" @(" V-S<R(" @54E#(" @3&5V96P@(" @(&5T:#$*(#(W.B @(" @
M(#DV-S,Y(" @54E#(" @3&5V96P@(" @(&5T:# *(#(X.B @(" @(#,Y,3@W
M(" @54E#(" @3&5V96P@(" @($E"32!)24,*0D%$.B @(" @(" @(" P"@I^
M(",@8V%T("]P<F]C+VEO;65M"C1F,# P,#(P,"TT9C P,# R,#<@.B!S97)I
M86P*-&8P,# P,S P+31F,# P,#,P-R Z('-E<FEA; HT9C P,# V,# M-&8P
M,# P-C W(#H@<V5R:6%L"C1F9C P,# P,"TT9F9F9F9F9F8@.B T9F8P,# P
M,# N;F]R7V9L87-H"F0X,# P,# P,"UD9F9F9F9F9F8@.B O<&QB+W!C:4!C
M,&5C,# P,# *("!D.# P,# P,# M9#@P,#%F9F9F(#H@,# P,CHP,#HP,BXP
M"B @("!D.# P,# P,# M9#@P,#%F9F9F(#H@93$P,# *("!D.# P,C P,# M
M9#@P,#-F9F9F(#H@,# P,CHP,#HP,BXQ"B @("!D.# P,C P,# M9#@P,#-F
M9F9F(#H@93$P,# *93 P,# P,# P+64W9F9F9F9F9B Z("]P;&(O<&-I97A 
M9# P,# P,# P"B @93 P,# P,# P+64P,#=F9F9F9B Z(%!#22!"=7,@,# P
M,#HQ,0H@(" @93 P,# P,# P+64P,#=F9F9F9B Z(%!#22!"=7,@,# P,#HQ
M,@H@(" @("!E,# P,# P,# M93 P-V9F9F9F(#H@4$-)($)U<R P,# P.C$V
M"B @(" @(" @93 P,# P,# P+64P,#=F9F9F9B Z(# P,# Z,38Z,# N, H@
M(&4P,#@P,# P,"UE,#$R9F9F9F8@.B!00TD@0G5S(# P,# Z,3$*(" @(&4P
M,#@P,# P,"UE,#$Q9F9F9F8@.B!00TD@0G5S(# P,# Z,3(*(" @(" @93 P
M.# P,# P+64P,&)F9F9F9B Z(%!#22!"=7,@,# P,#HQ,PH@(" @(" @(&4P
M,#@P,# P,"UE,#!B9F9F9F8@.B P,# P.C$S.C P+C *(" @(" @93 P8S P
M,# P+64P,&-F9F9F9B Z(%!#22!"=7,@,# P,#HQ- H@(" @("!E,#!D,# P
M,# M93 P9&9F9F9F(#H@4$-)($)U<R P,# P.C$U"B @(" @(" @93 P9# P
M,# P+64P,&0P,#!F9B Z(# P,# Z,34Z,# N, H@(" @("!E,#!E,# P,# M
M93 P969F9F9F(#H@4$-)($)U<R P,# P.C$V"B @(" @(" @93 P93 P,# P
M+64P,&5F9F9F9B Z(# P,# Z,38Z,# N, H@(" @("!E,#!F,# P,# M93 P
M9F9F9F9F(#H@4$-)($)U<R P,# P.C$W"B @(" @(&4P,3 P,# P,"UE,#$P
M9F9F9F8@.B!00TD@0G5S(# P,# Z,3@*(" @(" @93 Q,3 P,# P+64P,3%F
M9F9F9B Z(%!#22!"=7,@,# P,#HQ.0H@(" @93 Q,C P,# P+64P,3(Q9F9F
M9B Z(# P,# Z,3$Z,# N, IE.# P,# P,# M969F9F9F9F9F(#H@+W!L8B]P
M8VEE>$!D,C P,# P,# *?B C"GX@(PI^(",*?B C("]W9F)N9G,O;F-C<"]S
M8W)I<'1S+VEB+FEN:2XS"E-E='1I;F<@86-T:6]N('1O.B @;&]A9 I!8W1I
M;VXZ("!L;V%D"D-R96%T:6YG("]V87(O8V%C:&4O;W!E;G-M(&1I<F5C=&]R
M>0I#;W!Y:6YG("]E=&,O=61E=B]R=6QE<RYD+SDP+6EB+G)U;&5S(&9R;VT@
M+W=F8FYF<R]N8V-P+VEB"D-O<'EI;F<@+VQI8B]L:6)O<VUC;VUP+G-O+C,@
M9G)O;2 O=V9B;F9S+VYC8W O:6(*0V]P>6EN9R O;&EB+VQI8F]S;79E;F1O
M<BYS;RXS(&9R;VT@+W=F8FYF<R]N8V-P+VEB"D-O<'EI;F<@+VQI8B]L:6)I
M8G5M860N<V\N,R!F<F]M("]W9F)N9G,O;F-C<"]I8@I#;W!Y:6YG("]L:6(O
M;&EB;W!E;G-M+G-O+C0@9G)O;2 O=V9B;F9S+VYC8W O:6(*3&]A9&EN9R O
M;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I
M;F9I;FEB86YD+V-O<F4O:6)?8V]R92YK;PIR8STP"@I,;V%D:6YG("]M;G0O
M=&UP+VYC8W M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV97)S+VEN9FEN
M:6)A;F0O8V]R92]I8E]M860N:V\*<F,], H*3&]A9&EN9R O;6YT+W1M<"]N
M8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I;F9I;FEB86YD
M+W5T:6PO:6)?;6%D97EE+FMO"G)C/3 *"DQO861I;F<@+VUN="]T;7 O;F-C
M<"UJ;&(O:V5R;F5L+V1E;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C
M;W)E+VEB7W5V97)B<RYK;PIR8STP"@I,;V%D:6YG("]M;G0O=&UP+VYC8W M
M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV97)S+VEN9FEN:6)A;F0O8V]R
M92]I8E]A9&1R+FMO"G)C/3 *"DQO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O
M:V5R;F5L+V1E;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEW
M7V-M+FMO"G)C/3 *"DQO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L
M+V1E;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEB7W-A+FMO
M"G)C/3 *"DQO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L+V1E;G@M
M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEB7V-M+FMO"G)C/3 *
M"DQO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L+V1E;G@M,BXV+C(V
M+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEB7W5C;2YK;PIR8STP"@I,;V%D
M:6YG("]M;G0O=&UP+VYC8W M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV
M97)S+VEN9FEN:6)A;F0O8V]R92]I8E]U;6%D+FMO"G)C/3 *"DQO861I;F<@
M+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L+V1E;G@M,BXV+C(V+V1R:79E<G,O
M:6YF:6YI8F%N9"]C;W)E+W)D;6%?8VTN:V\*<F,], H*3&]A9&EN9R O;6YT
M+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I;F9I
M;FEB86YD+V-O<F4O<F1M85]U8VTN:V\*<F,], H*3&]A9&EN9R O;6YT+W1M
M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I;F9I;FEB
M86YD+VAW+VUT:&-A+VEB7VUT:&-A+FMO"FEB7VUT:&-A.B!-96QL86YO>"!)
M;F9I;FE"86YD($A#02!D<FEV97(@=C$N," H07!R:6P@-"P@,C P."D*:6)?
M;71H8V$Z($EN:71I86QI>FEN9R P,# P.C$V.C P+C *:6)?;71H8V$@,# P
M,#HQ-CHP,"XP.B!E;F%B;&EN9R!D979I8V4@*# P,# @+3X@,# P,BD*<F,]
M, H*3&]A9&EN9R O;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N
M,C8O9')I=F5R<R]I;F9I;FEB86YD+W5L<"]I<&]I8B]I8E]I<&]I8BYK;PIR
M8STP"@I^(",@8V%T("]P<F]C+VEO;65M"C1F,# P,#(P,"TT9C P,# R,#<@
M.B!S97)I86P*-&8P,# P,S P+31F,# P,#,P-R Z('-E<FEA; HT9C P,# V
M,# M-&8P,# P-C W(#H@<V5R:6%L"C1F9C P,# P,"TT9F9F9F9F9F8@.B T
M9F8P,# P,# N;F]R7V9L87-H"F0X,# P,# P,"UD9F9F9F9F9F8@.B O<&QB
M+W!C:4!C,&5C,# P,# *("!D.# P,# P,# M9#@P,#%F9F9F(#H@,# P,CHP
M,#HP,BXP"B @("!D.# P,# P,# M9#@P,#%F9F9F(#H@93$P,# *("!D.# P
M,C P,# M9#@P,#-F9F9F(#H@,# P,CHP,#HP,BXQ"B @("!D.# P,C P,# M
M9#@P,#-F9F9F(#H@93$P,# *93 P,# P,# P+64W9F9F9F9F9B Z("]P;&(O
M<&-I97A 9# P,# P,# P"B @93 P,# P,# P+64P,#=F9F9F9B Z(%!#22!"
M=7,@,# P,#HQ,0H@(" @93 P,# P,# P+64P,#=F9F9F9B Z(%!#22!"=7,@
M,# P,#HQ,@H@(" @("!E,# P,# P,# M93 P-V9F9F9F(#H@4$-)($)U<R P
M,# P.C$V"B @(" @(" @93 P,# P,# P+64P,#=F9F9F9B Z(# P,# Z,38Z
M,# N, H@(" @(" @(" @93 P,# P,# P+64P,#=F9F9F9B Z(&EB7VUT:&-A
M"B @93 P.# P,# P+64P,3)F9F9F9B Z(%!#22!"=7,@,# P,#HQ,0H@(" @
M93 P.# P,# P+64P,3%F9F9F9B Z(%!#22!"=7,@,# P,#HQ,@H@(" @("!E
M,# X,# P,# M93 P8F9F9F9F(#H@4$-)($)U<R P,# P.C$S"B @(" @(" @
M93 P.# P,# P+64P,&)F9F9F9B Z(# P,# Z,3,Z,# N, H@(" @("!E,#!C
M,# P,# M93 P8V9F9F9F(#H@4$-)($)U<R P,# P.C$T"B @(" @(&4P,&0P
M,# P,"UE,#!D9F9F9F8@.B!00TD@0G5S(# P,# Z,34*(" @(" @("!E,#!D
M,# P,# M93 P9# P,&9F(#H@,# P,#HQ-3HP,"XP"B @(" @(&4P,&4P,# P
M,"UE,#!E9F9F9F8@.B!00TD@0G5S(# P,# Z,38*(" @(" @("!E,#!E,# P
M,# M93 P969F9F9F(#H@,# P,#HQ-CHP,"XP"B @(" @(" @("!E,#!E-C$W
M-&,M93 P938Q-S1F(#H@:6)?;71H8V$*(" @(" @(" @(&4P,&4W,C P,"UE
M,#!E-S(P9F8@.B!I8E]M=&AC80H@(" @(" @(" @93 P93@P-C@P+64P,&4X
M,#8Y8B Z(&EB7VUT:&-A"B @(" @(" @("!E,#!E.#)A-3 M93 P93@R83AF
M(#H@:6)?;71H8V$*(" @(" @(" @(&4P,&5F,#!D."UE,#!E9C P9&8@.B!I
M8E]M=&AC80H@(" @("!E,#!F,# P,# M93 P9F9F9F9F(#H@4$-)($)U<R P
M,# P.C$W"B @(" @(&4P,3 P,# P,"UE,#$P9F9F9F8@.B!00TD@0G5S(# P
M,# Z,3@*(" @(" @93 Q,3 P,# P+64P,3%F9F9F9B Z(%!#22!"=7,@,# P
M,#HQ.0H@(" @93 Q,C P,# P+64P,3(Q9F9F9B Z(# P,# Z,3$Z,# N, IE
M.# P,# P,# M969F9F9F9F9F(#H@+W!L8B]P8VEE>$!D,C P,# P,# *"GX@
M(R!C870@+W!R;V,O:6YT97)R=7!T<PH@(" @(" @(" @($-053 *(#$X.B @
M(" @(" @,3@T(" @54E#(" @3&5V96P@(" @('!C:65H<"P@:6)?;71H8V$*
M(#$Y.B @(" @(" @(" R(" @54E#(" @3&5V96P@(" @('!C:65H<"P@<&-I
M96AP"B R,#H@(" @(" @(" @.2 @(%5)0R @($QE=F5L(" @("!P8VEE:' L
M('!C:65H< H@,C$Z(" @(" @(" @(#0@("!524,@("!,979E;" @(" @<&-I
M96AP+"!P8VEE:' *(#(R.B @(" @(" T,C$V(" @54E#(" @3&5V96P@(" @
M('-E<FEA; H@,C4Z(" @(" @(" T,#D@("!524,@("!,979E;" @(" @24)-
M($E)0PH@,C8Z(" @(" @(#8W.#D@("!524,@("!,979E;" @(" @971H,0H@
M,C<Z(" @(" @.3@T,#0@("!524,@("!,979E;" @(" @971H, H@,C@Z(" @
M(" @,SDR.#$@("!524,@("!,979E;" @(" @24)-($E)0PI"040Z(" @(" @
M(" @(# *"GX@(R!L<W!C:2 M=G9V>'AX<S$V.C P"C P,# Z,38Z,# N,"!#
M;&%S<R P8S V.B!$979I8V4@,35B,SHV,C<T("AR978@83 I"B @(" @(" @
M4W5B<WES=&5M.B!$979I8V4@,35B,SHV,C<T"B @(" @(" @4&AY<VEC86P@
M4VQO=#H@,# R,E\P,# X"B @(" @(" @0V]N=')O;#H@22]/+2!-96TK($)U
M<TUA<W1E<BL@4W!E8T-Y8VQE+2!-96U724Y6+2!61T%3;F]O<"T@4&%R17)R
M+2!3=&5P<&EN9RT@4T524BT@1F%S=$(R0BT@1&ES24Y4>"T*(" @(" @("!3
M=&%T=7,Z($-A<"L@-C9-2'HM(%5$1BT@1F%S=$(R0BT@4&%R17)R+2!$1593
M14P]9F%S=" ^5$%B;W)T+2 \5$%B;W)T+2 \34%B;W)T+2 ^4T524BT@/%!%
M4E(M($E.5'@M"B @(" @(" @3&%T96YC>3H@, H@(" @(" @($EN=&5R<G5P
M=#H@<&EN($$@<F]U=&5D('1O($E242 Q. H@(" @(" @(%)E9VEO;B P.B!-
M96UO<GD@870@93 P93 P,# P("@V-"UB:70L(&YO;BUP<F5F971C:&%B;&4I
M(%MS:7IE/3%-70H@(" @(" @(%)E9VEO;B R.B!-96UO<GD@870@93 P,# P
M,# P("@V-"UB:70L('!R969E=&-H86)L92D@6W-I>F4].$U="B @(" @(" @
M0V%P86)I;&ET:65S.B!;-#!=(%!O=V5R($UA;F%G96UE;G0@=F5R<VEO;B R
M"B @(" @(" @(" @(" @("!&;&%G<SH@4$U%0VQK+2!$4TDM($0Q+2!$,BT@
M075X0W5R<F5N=#TP;4$@4$U%*$0P+2Q$,2TL1#(M+$0S:&]T+2Q$,V-O;&0M
M*0H@(" @(" @(" @(" @(" @4W1A='5S.B!$,"!.;U-O9G12<W0M(%!-12U%
M;F%B;&4M($1396P],"!$4V-A;&4],"!0344M"B @(" @(" @0V%P86)I;&ET
M:65S.B!;-#A=(%9I=&%L(%!R;V1U8W0@1&%T80IP8VEL:6(Z('-Y<V9S7W)E
M861?=G!D.B!R96%D(&9A:6QE9#H@0V]N;F5C=&EO;B!T:6UE9"!O=70*(" @
M(" @(" @(" @(" @($YO="!R96%D86)L90H@(" @(" @($-A<&%B:6QI=&EE
M<SH@6SDP72!-4TDZ($5N86)L92T@0V]U;G0],2\S,B!-87-K86)L92T@-C1B
M:70K"B @(" @(" @(" @(" @("!!9&1R97-S.B P,# P,# P,# P,# P,# P
M("!$871A.B P,# P"B @(" @(" @0V%P86)I;&ET:65S.B!;.#1=($U322U8
M.B!%;F%B;&4M($-O=6YT/3,R($UA<VME9"T*(" @(" @(" @(" @(" @(%9E
M8W1O<B!T86)L93H@0D%2/3 @;V9F<V5T/3 P,#@R,# P"B @(" @(" @(" @
M(" @("!00D$Z($)!4CTP(&]F9G-E=#TP,# X,C(P, H@(" @(" @($-A<&%B
M:6QI=&EE<SH@6S8P72!%>'!R97-S("AV,2D@16YD<&]I;G0L($U322 P, H@
M(" @(" @(" @(" @(" @1&5V0V%P.B!-87A087EL;V%D(#$R."!B>71E<RP@
M4&AA;G1&=6YC(# L($QA=&5N8WD@3#!S(#PV-&YS+"!,,2!U;FQI;6ET960*
M(" @(" @(" @(" @(" @(" @(" @(" @17AT5&%G*R!!='1N0G1N+2!!='1N
M26YD+2!0=W));F0M(%)"12T@1DQ297-E="T*(" @(" @(" @(" @(" @($1E
M=D-T;#H@4F5P;W)T(&5R<F]R<SH@0V]R<F5C=&%B;&4M($YO;BU&871A;"T@
M1F%T86PM(%5N<W5P<&]R=&5D+0H@(" @(" @(" @(" @(" @(" @(" @("!2
M;'AD3W)D+2!%>'1486<M(%!H86YT1G5N8RT@075X4'=R+2!.;U-N;V]P+0H@
M(" @(" @(" @(" @(" @(" @(" @("!-87A087EL;V%D(#$R."!B>71E<RP@
M36%X4F5A9%)E<2 U,3(@8GET97,*(" @(" @(" @(" @(" @($1E=E-T83H@
M0V]R<D5R<BT@56YC;W)R17)R+2!&871A;$5R<BT@56YS=7!P4F5Q+2!!=7A0
M=W(M(%1R86YS4&5N9"T*(" @(" @(" @(" @(" @($QN:T-A<#H@4&]R=" C
M."P@4W!E960@,BXU1U0O<RP@5VED=&@@>#@L($%34$T@3#!S+"!,871E;F-Y
M($PP('5N;&EM:71E9"P@3#$@=6YL:6UI=&5D"B @(" @(" @(" @(" @(" @
M(" @(" @($-L;V-K4$TM(%-U<G!R:7-E+2!,3$%C=%)E<"T@0G=.;W0M"B @
M(" @(" @(" @(" @("!,;FM#=&PZ($%34$T@1&ES86)L960[(%)#0B V-"!B
M>71E<R!$:7-A8FQE9"T@4F5T<F%I;BT@0V]M;4-L:RT*(" @(" @(" @(" @
M(" @(" @(" @(" @17AT4WEN8V@M($-L;V-K4$TM($%U=%=I9$1I<RT@0E=)
M;G0M($%U=$)726YT+0H@(" @(" @(" @(" @(" @3&YK4W1A.B!3<&5E9" R
M+C5'5"]S+"!7:61T:"!X-"P@5')%<G(M(%1R86EN+2!3;&]T0VQK+2!$3$%C
M=&EV92T@0E=-9VUT+2!!0E=-9VUT+0H@(" @(" @($ME<FYE;"!D<FEV97(@
M:6X@=7-E.B!I8E]M=&AC80HP,#H@8C,@,34@-S0@-C(@,#8@,# @,3 @,# @
M83 @,# @,#8@,&,@,# @,# @,# @,# *,3 Z(# T(# P(&4P(#@P(# P(# P
M(# P(# P(#!C(# P(# P(#@P(# P(# P(# P(# P"C(P.B P," P," P," P
M," P," P," P," P," P," P," P," P,"!B,R Q-2 W-" V,@HS,#H@,# @
M,# @,# @,# @-# @,# @,# @,# @,# @,# @,# @,# @,# @,#$@,# @,# *
M-# Z(# Q(#0X(# R(# P(# P(# P(# P(# P(# S(#DP(&9F(#=F(#$Q(#$Q
M(# P(# P"C4P.B P," P," P," P," P," P," P," P," P," P," P," P
M," P," P," P," P, HV,#H@,3 @,# @,#$@,# @,C @,&4@-C0@,# @,# @
M,C @,# @,# @.#$@9C0@,#,@,#@*-S Z(# P(# P(#0Q(# P(# P(# P(# P
M(# P(# P(# P(# P(# P(# P(# P(# P(# P"C@P.B P," P," P," P," Q
M,2 V," Q9B P," P," R," P." P," P," R,B P." P, HY,#H@,#4@.#0@
M.&$@,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# *83 Z
M(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P(# P
M(# P"F(P.B P," P," P," P," P," P," P," P," P," P," P," P," P
M," P," P," P, IC,#H@,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @
M,# @,# @,# @,# @,# @,# *9# Z(# P(# P(# P(# P(# P(# P(# P(# P
M(# P(# P(# P(# P(# P(# P(# P(# P"F4P.B P," P," P," P," P," P
M," P," P," P," P," P," P," P," P," P," P, IF,#H@,# @,# @,# @
M,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# @,# *"GX@(R!C
M870@+W!R;V,O:6YT97)R=7!T<PH@(" @(" @(" @($-053 *(#$X.B @(" @
M(" @,3@T(" @54E#(" @3&5V96P@(" @('!C:65H<"P@:6)?;71H8V$*(#$Y
M.B @(" @(" @(" R(" @54E#(" @3&5V96P@(" @('!C:65H<"P@<&-I96AP
M"B R,#H@(" @(" @(" @.2 @(%5)0R @($QE=F5L(" @("!P8VEE:' L('!C
M:65H< H@,C$Z(" @(" @(" @(#0@("!524,@("!,979E;" @(" @<&-I96AP
M+"!P8VEE:' *(#(R.B @(" @(" T-C,R(" @54E#(" @3&5V96P@(" @('-E
M<FEA; H@,C4Z(" @(" @(" T,#D@("!524,@("!,979E;" @(" @24)-($E)
M0PH@,C8Z(" @(" @(#8X,C,@("!524,@("!,979E;" @(" @971H,0H@,C<Z
M(" @(" @.3@W.#<@("!524,@("!,979E;" @(" @971H, H@,C@Z(" @(" @
M,SDT-C,@("!524,@("!,979E;" @(" @24)-($E)0PI"040Z(" @(" @(" @
M(# *"GX@(R!L;V=G97(@+70@2DQ"(&%B;W5T('1O('-T87)T('-U8FYE="!M
M86YA9V5R"@I^(",@8V%T("]P<F]C+VEN=&5R<G5P=',*(" @(" @(" @("!#
M4%4P"B Q.#H@(" @(" @(#$X-" @(%5)0R @($QE=F5L(" @("!P8VEE:' L
M(&EB7VUT:&-A"B Q.3H@(" @(" @(" @,B @(%5)0R @($QE=F5L(" @("!P
M8VEE:' L('!C:65H< H@,C Z(" @(" @(" @(#D@("!524,@("!,979E;" @
M(" @<&-I96AP+"!P8VEE:' *(#(Q.B @(" @(" @(" T(" @54E#(" @3&5V
M96P@(" @('!C:65H<"P@<&-I96AP"B R,CH@(" @(" @-3 R,2 @(%5)0R @
M($QE=F5L(" @("!S97)I86P*(#(U.B @(" @(" @-# Y(" @54E#(" @3&5V
M96P@(" @($E"32!)24,*(#(V.B @(" @(" V.#4T(" @54E#(" @3&5V96P@
M(" @(&5T:#$*(#(W.B @(" @(#DY,30W(" @54E#(" @3&5V96P@(" @(&5T
M:# *(#(X.B @(" @(#,Y-C(U(" @54E#(" @3&5V96P@(" @($E"32!)24,*
M0D%$.B @(" @(" @(" P"@I^(",@8V%T("]P<F]C+VEN=&5R<G5P=',*(" @
M(" @(" @("!#4%4P"B Q.#H@(" @(" @(#$X-" @(%5)0R @($QE=F5L(" @
M("!P8VEE:' L(&EB7VUT:&-A"B Q.3H@(" @(" @(" @,B @(%5)0R @($QE
M=F5L(" @("!P8VEE:' L('!C:65H< H@,C Z(" @(" @(" @(#D@("!524,@
M("!,979E;" @(" @<&-I96AP+"!P8VEE:' *(#(Q.B @(" @(" @(" T(" @
M54E#(" @3&5V96P@(" @('!C:65H<"P@<&-I96AP"B R,CH@(" @(" @-3 U
M-R @(%5)0R @($QE=F5L(" @("!S97)I86P*(#(U.B @(" @(" @-# Y(" @
M54E#(" @3&5V96P@(" @($E"32!)24,*(#(V.B @(" @(" V.#8Q(" @54E#
M(" @3&5V96P@(" @(&5T:#$*(#(W.B @(" @(#DY,C(T(" @54E#(" @3&5V
M96P@(" @(&5T:# *(#(X.B @(" @(#,Y-C8Q(" @54E#(" @3&5V96P@(" @
>($E"32!)24,*0D%$.B @(" @(" @(" P"@I^(",*
`
end

begin 666 ib-messages.txt
M2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C
M<"]S8W)I<'1S+VEB+FEN:2XS.B!3971T:6YG(&%C=&EO;B!T;SH@(&QO860*
M2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C
M<"]S8W)I<'1S+VEB+FEN:2XS.B!!8W1I;VXZ("!L;V%D"DIA;B @-R P,CHU
M.#HU,B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I
M8BYI;FDN,SH@0W)E871I;F<@+W9A<B]C86-H92]O<&5N<VT@9&ER96-T;W)Y
M"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC
M8W O<V-R:7!T<R]I8BYI;FDN,SH@0V]P>6EN9R O971C+W5D978O<G5L97,N
M9"\Y,"UI8BYR=6QE<R!F<F]M("]W9F)N9G,O;F-C<"]I8@I*86X@(#<@,#(Z
M-3@Z-3(@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C<FEP=',O
M:6(N:6YI+C,Z($-O<'EI;F<@+VQI8B]L:6)O<VUC;VUP+G-O+C,@9G)O;2 O
M=V9B;F9S+VYC8W O:6(*2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I
M8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!#;W!Y:6YG("]L
M:6(O;&EB;W-M=F5N9&]R+G-O+C,@9G)O;2 O=V9B;F9S+VYC8W O:6(*2F%N
M(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S
M8W)I<'1S+VEB+FEN:2XS.B!#;W!Y:6YG("]L:6(O;&EB:6)U;6%D+G-O+C,@
M9G)O;2 O=V9B;F9S+VYC8W O:6(*2F%N(" W(# R.C4X.C4R($Y#0U @=7-E
M<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!#;W!Y
M:6YG("]L:6(O;&EB;W!E;G-M+G-O+C0@9G)O;2 O=V9B;F9S+VYC8W O:6(*
M2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C
M<"]S8W)I<'1S+VEB+FEN:2XS.B!,;V%D:6YG("]M;G0O=&UP+VYC8W M:FQB
M+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV97)S+VEN9FEN:6)A;F0O8V]R92]I
M8E]C;W)E+FMO"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T:6-E(" O
M=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN,SH@<F,], I*86X@(#<@,#(Z
M-3@Z-3(@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C<FEP=',O
M:6(N:6YI+C,Z($QO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L+V1E
M;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEB7VUA9"YK;PI*
M86X@(#<@,#(Z-3@Z-3(@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P
M+W-C<FEP=',O:6(N:6YI+C,Z(')C/3 *2F%N(" W(# R.C4X.C4R($Y#0U @
M=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!,
M;V%D:6YG("]M;G0O=&UP+VYC8W M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D
M<FEV97)S+VEN9FEN:6)A;F0O=71I;"]I8E]M861E>64N:V\*2F%N(" W(# R
M.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S
M+VEB+FEN:2XS.B!R8STP"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T
M:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN,SH@3&]A9&EN9R O
M;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I
M;F9I;FEB86YD+V-O<F4O:6)?=79E<F)S+FMO"DIA;B @-R P,CHU.#HU,B!.
M0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN
M,SH@<F,], I*86X@(#<@,#(Z-3@Z-3(@3D-#4"!U<V5R+FYO=&EC92 @+W=F
M8FYF<R]N8V-P+W-C<FEP=',O:6(N:6YI+C,Z($QO861I;F<@+VUN="]T;7 O
M;F-C<"UJ;&(O:V5R;F5L+V1E;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N
M9"]C;W)E+VEB7V%D9'(N:V\*2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN
M;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!R8STP"DIA
M;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O
M<V-R:7!T<R]I8BYI;FDN,SH@3&]A9&EN9R O;6YT+W1M<"]N8V-P+6IL8B]K
M97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I;F9I;FEB86YD+V-O<F4O:7=?
M8VTN:V\*2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N
M9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!R8STP"DIA;B @-R P,CHU.#HU
M,B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI
M;FDN,SH@3&]A9&EN9R O;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR
M+C8N,C8O9')I=F5R<R]I;F9I;FEB86YD+V-O<F4O:6)?<V$N:V\*2F%N(" W
M(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I
M<'1S+VEB+FEN:2XS.B!R8STP"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N
M;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN,SH@3&]A9&EN
M9R O;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R
M<R]I;F9I;FEB86YD+V-O<F4O:6)?8VTN:V\*2F%N(" W(# R.C4X.C4R($Y#
M0U @=7-E<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS
M.B!R8STP"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T:6-E(" O=V9B
M;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN,SH@3&]A9&EN9R O;6YT+W1M<"]N
M8V-P+6IL8B]K97)N96PO9&5N>"TR+C8N,C8O9')I=F5R<R]I;F9I;FEB86YD
M+V-O<F4O:6)?=6-M+FMO"DIA;B @-R P,CHU.#HU,B!.0T-0('5S97(N;F]T
M:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI;FDN,SH@<F,], I*86X@
M(#<@,#(Z-3@Z-3(@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C
M<FEP=',O:6(N:6YI+C,Z($QO861I;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R
M;F5L+V1E;G@M,BXV+C(V+V1R:79E<G,O:6YF:6YI8F%N9"]C;W)E+VEB7W5M
M860N:V\*2F%N(" W(# R.C4X.C4R($Y#0U @=7-E<BYN;W1I8V4@("]W9F)N
M9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!R8STP"DIA;B @-R P,CHU.#HU
M,B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R:7!T<R]I8BYI
M;FDN,SH@3&]A9&EN9R O;6YT+W1M<"]N8V-P+6IL8B]K97)N96PO9&5N>"TR
M+C8N,C8O9')I=F5R<R]I;F9I;FEB86YD+V-O<F4O<F1M85]C;2YK;PI*86X@
M(#<@,#(Z-3@Z-3,@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C
M<FEP=',O:6(N:6YI+C,Z(')C/3 *2F%N(" W(# R.C4X.C4S($Y#0U @=7-E
M<BYN;W1I8V4@("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!,;V%D
M:6YG("]M;G0O=&UP+VYC8W M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV
M97)S+VEN9FEN:6)A;F0O8V]R92]R9&UA7W5C;2YK;PI*86X@(#<@,#(Z-3@Z
M-3,@3D-#4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C<FEP=',O:6(N
M:6YI+C,Z(')C/3 *2F%N(" W(# R.C4X.C4S($Y#0U @=7-E<BYN;W1I8V4@
M("]W9F)N9G,O;F-C<"]S8W)I<'1S+VEB+FEN:2XS.B!,;V%D:6YG("]M;G0O
M=&UP+VYC8W M:FQB+VME<FYE;"]D96YX+3(N-BXR-B]D<FEV97)S+VEN9FEN
M:6)A;F0O:'<O;71H8V$O:6)?;71H8V$N:V\*2F%N(" W(# R.C4X.C4S($Y#
M0U @=7-E<BYI;F9O(&ME<FYE;#H@:6)?;71H8V$Z($UE;&QA;F]X($EN9FEN
M:4)A;F0@2$-!(&1R:79E<B!V,2XP("A!<')I;" T+" R,# X*0I*86X@(#<@
M,#(Z-3@Z-3,@3D-#4"!U<V5R+FEN9F\@:V5R;F5L.B!I8E]M=&AC83H@26YI
M=&EA;&EZ:6YG(# P,# Z,38Z,# N, I*86X@(#<@,#(Z-3@Z-3,@3D-#4"!U
M<V5R+FEN9F\@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z(&5N86)L
M:6YG(&1E=FEC92 H,# P," M/B P,# R*0I*86X@(#<@,#(Z-3@Z-3,@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@4$-).B!%;F%B;&EN9R!B=7,@;6%S=&5R
M:6YG(&9O<B!D979I8V4@,# P,#HQ-CHP,"XP"DIA;B @-R P,CHU.#HU-"!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($97('9E<G-I;VX@,# P,3 P,#(P,# P+"!M87@@8V]M;6%N9',@,38*2F%N
M(" W(# R.C4X.C4T($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A
M(# P,# Z,38Z,# N,#H@0V%T87-T<F]P:&EC(&5R<F]R(&)U9F9E<B!A=" P
M>#@P93@R834P+"!S:7IE(#!X,3 *2F%N(" W(# R.C4X.C4T($Y#0U @=7-E
M<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1E<@<W5P
M<&]R=',@8V]M;6%N9',@=&AR;W5G:"!D;V]R8F5L;',*2F%N(" W(# R.C4X
M.C4T($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@36%P<&5D(&1O;W)B96QL('!A9V4@9F]R('!O<W1I;F<@1E<@8V]M
M;6%N9',*2F%N(" W(# R.C4X.C4T($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1E<@<VEZ92 U,3,V($M""DIA;B @
M-R P,CHU.#HU-"!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($-L96%R(&EN="! (#@P968P,&0X+"!%42!A<FT@0" X
M,&4V,3<T."P@15$@<V5T($-)($ @.#!E-S(P,# *2F%N(" W(# R.C4X.C4T
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@3F\@2$-!+6%T=&%C:&5D(&UE;6]R>2 H<G5N;FEN9R!I;B!-96U&<F5E
M(&UO9&4I"DIA;B @-R P,CHU.#HU-"!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($UA<'!E9" R,2!C:'5N:W,O-3$S
M-B!+0B!F;W(@1E<N"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($)A<V4@34T@97AT96YS
M:6]N<SH@;F\*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%X($E#32!S:7IE(#4R,S(V
M-"!-0@I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!-87@@45!S.B Q-C<W-S(Q-BP@<F5S
M97)V960@45!S.B Q,#(T+"!E;G1R>2!S:7IE.B R-38*2F%N(" W(# R.C4X
M.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@36%X(%-247,Z(#$P,C0L(')E<V5R=F5D(%-247,Z(#8T+"!E;G1R
M>2!S:7IE.B S,@I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!-87@@0U%S.B Q-C<W-S(Q
M-BP@<F5S97)V960@0U%S.B Q,C@L(&5N=')Y('-I>F4Z(#8T"DIA;B @-R P
M,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($UA>"!%47,Z(#8T+"!R97-E<G9E9"!%47,Z(#$L(&5N=')Y
M('-I>F4Z(#8T"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z(')E<V5R=F5D($U05',Z(#$V
M+"!R97-E<G9E9"!-5%1S.B R"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($UA>"!01',Z
M(#@S.#@V,#@L(')E<V5R=F5D(%!$<SH@-"P@<F5S97)V960@54%2<SH@,0I*
M86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H
M8V$@,# P,#HQ-CHP,"XP.B!-87@@45 O34-'.B X,S@X-C X+"!R97-E<G9E
M9"!-1TUS.B P"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($UA>"!#445S.B Q,S$P-S(L
M(&UA>"!7445S.B Q-C,X-"P@;6%X(%-242!7445S.B Q-C,X- I*86X@(#<@
M,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P
M,#HQ-CHP,"XP.B!&;&%G<SH@,# S-S S-#<*2F%N(" W(# R.C4X.C4U($Y#
M0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@
M<')O9FEL95L@,%TM+3$S+S$Q($ @,'@@(" @(" @(" @(" @(" P("AS:7IE
M(#!X,C P,# P,# I"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z('!R;V9I;&5;(#%=+2TQ
M,"\R,"! (#!X(" @(" @(" R,# P,# P," H<VEZ92 P>" T,# P,# P*0I*
M86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H
M8V$@,# P,#HQ-CHP,"XP.B!P<F]F:6QE6R R72TM(# O,38@0" P>" @(" @
M(" @,C0P,# P,# @*'-I>F4@,'@@,3 P,# P,"D*2F%N(" W(# R.C4X.C4U
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@<')O9FEL95L@,UTM+2 W+S$X($ @,'@@(" @(" @(#(U,# P,# P("AS
M:7IE(#!X(" X,# P,# I"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z('!R;V9I;&5;(#1=
M+2T@.2\Q-R! (#!X(" @(" @(" R-3@P,# P," H<VEZ92 P>" @.# P,# P
M*0I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!P<F]F:6QE6R U72TM(#0O,38@0" P>" @
M(" @(" @,C8P,# P,# @*'-I>F4@,'@@(#0P,# P,"D*2F%N(" W(# R.C4X
M.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@<')O9FEL95L@-ETM+2 X+S$S($ @,'@@(" @(" @(#(V-# P,# P
M("AS:7IE(#!X(" R,# P,# I"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z('!R;V9I;&5;
M(#==+2T@,R\Q,B! (#!X(" @(" @(" R-C8P,# P," H<VEZ92 P>" @(#0P
M,# P*0I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!P<F]F:6QE6R X72TM,3$O,3$@0" P
M>" @(" @(" @,C8V-# P,# @*'-I>F4@,'@@(" Q,# P,"D*2F%N(" W(# R
M.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@<')O9FEL95L@.5TM+2 R+S$P($ @,'@@(" @(" @(#(V-C4P
M,# P("AS:7IE(#!X(" @(#@P,# I"DIA;B @-R P,CHU.#HU-2!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z('!R;V9I
M;&5;,3!=+2T@,2\@,"! (#!X(" @(" @(" R-C8U.# P," H<VEZ92 P>" @
M(" Q,# P*0I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME<FYE
M;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!P<F]F:6QE6S$Q72TM(#4O(# @
M0" P>" @(" @(" @,C8V-3DP,# @*'-I>F4@,'@@(" @,3 P,"D*2F%N(" W
M(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@<')O9FEL95LQ,ETM+2 V+R U($ @,'@@(" @(" @(#(V
M-C5A,# P("AS:7IE(#!X(" @(#$P,# I"DIA;B @-R P,CHU.#HU-2!.0T-0
M('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z('!R
M;V9I;&5;,3-=+2TQ,B\@,"! (#!X(" @(" @(" R-C8U8C P," H<VEZ92 P
M>" @(" Q,# P*0I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!(0T$@8V]N=&5X="!M96UO
M<GDZ(')E<V5R=FEN9R V,CDQ,#0@2T(*2F%N(" W(# R.C4X.C4U($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@-C(Y
M,3 T($M"(&]F($A#02!C;VYT97AT(')E<75I<F5S(#$R-# @2T(@875X(&UE
M;6]R>2X*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#@@8VAU;FMS+S$R-# @
M2T(@9F]R($E#32!A=7@N"DIA;B @-R P,CHU.#HU-2!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($UA<'!E9"!P86=E
M(&%T(#=A8S)C,# P('1O(#(V-C5A,# P(&9O<B!)0TTN"DIA;B @-R P,CHU
M.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($UA<'!E9" Q(&-H=6YK<R\R-38@2T(@870@,C P,# P,# @9F]R
M($E#32X*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS+S(U-B!+
M0B!A=" R-3@P,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!-87!P
M960@,2!C:'5N:W,O,C4V($M"(&%T(#(T,# P,# P(&9O<B!)0TTN"DIA;B @
M-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($UA<'!E9" Q(&-H=6YK<R\R-38@2T(@870@,C8P,# P
M,# @9F]R($E#32X*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS
M+S(U-B!+0B!A=" R-C8P,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-34@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!-87!P960@,2!C:'5N:W,O,S(@2T(@870@,C8V-3 P,# @9F]R($E#32X*
M2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS+S(U-B!+0B!A=" R
M-C0P,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!-87!P960@,2!C
M:'5N:W,O,C4V($M"(&%T(#(V-#0P,# P(&9O<B!)0TTN"DIA;B @-R P,CHU
M.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($UA<'!E9" Q(&-H=6YK<R\R-38@2T(@870@,C8T.# P,# @9F]R
M($E#32X*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS+S(U-B!+
M0B!A=" R-C1C,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-34@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!-87!P
M960@,2!C:'5N:W,O,C4V($M"(&%T(#(V-3 P,# P(&9O<B!)0TTN"DIA;B @
M-R P,CHU.#HU-2!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($UA<'!E9" Q(&-H=6YK<R\R-38@2T(@870@,C8U-# P
M,# @9F]R($E#32X*2F%N(" W(# R.C4X.C4U($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS
M+S(U-B!+0B!A=" R-C4X,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-34@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!-87!P960@,2!C:'5N:W,O,C4V($M"(&%T(#(V-6,P,# P(&9O<B!)0TTN
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M
M=&AC82 P,# P.C$V.C P+C Z($UE;6]R>2!K97D@=&AR;W5G:'!U="!O<'1I
M;6EZ871I;VX@86-T:79A=&5D+@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!$=6UP:6YG
M($U05"!E;G1R>2 P,# P,3 P,#H*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYW87)N(&ME<FYE;#H@6S P72 @9C P,C!F,# @,# P,# P,# @,# P,# P
M,3 @,# P,# P,#0*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME
M<FYE;#H@6S$P72 @,# P,# P,# @,# P,# P,# @9F9F9F9F9F8@9F9F9F9F
M9F8*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S(P
M72 @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S,P72 @,# P,# P
M,# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@36%P<&5D(#$@8VAU;FMS+S(U-B!+0B!A=" R,3 P,# P,"!F;W(@24--
M+@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!$=6UP:6YG($U05"!E;G1R>2 P,# P,3$P
M,#H*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S P
M72 @9C P,C!D,# @,# P,# P,# @,# P,# P,3$@,# P,# P,#0*2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S$P72 @,# P,# P
M,# @,# P,# P,# @,# P,# P,# @,# P-# P,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S(P72 @,# P,# P,# @,# P,# P
M,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYW87)N(&ME<FYE;#H@6S,P72 @,C$P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@06QL;V-A=&5D($51(#$@
M=VET:" X,3DR(&5N=')I97,*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD
M96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1'5M<&EN9R!-
M4%0@96YT<GD@,# P,#$R,# Z"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M=V%R;B!K97)N96PZ(%LP,%T@(&8P,#(P9# P(# P,# P,# P(# P,# P,#$R
M(# P,# P,# T"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N
M96PZ(%LQ,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# R,# P
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LR,%T@
M(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LS,%T@(#(Q,# P,C P
M(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($%L;&]C871E9"!%42 R('=I=&@@,C4V(&5N=')I97,*2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@1'5M<&EN9R!-4%0@96YT<GD@,# P,#$S,# Z"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LP,%T@(&8P,#(P9# P(# P
M,# P,# P(# P,# P,#$S(# P,# P,# T"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N=V%R;B!K97)N96PZ(%LQ,%T@(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# R,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R
M;B!K97)N96PZ(%LR,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ
M(%LS,%T@(#(Q,# P,C0P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($%L;&]C871E9"!%42 S('=I=&@@,C4V(&5N=')I
M97,*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB
M7VUT:&-A(# P,# Z,38Z,# N,#H@4V5T=&EN9R!M87-K(# P,# P,# P,# Q
M9C0S9F4@9F]R(&5Q;B R"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z(%-E='1I;F<@;6%S
M:R P,# P,# P,# P,# P-# P(&9O<B!E<6X@,PI*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO
M=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($Y/4"!C;VUM86YD($E242!T
M97-T('!A<W-E9 I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P
M.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD
M96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z
M(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H
M8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@
M/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E2
M42!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R
M(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S
M=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP
M,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E
M+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M
M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O
M,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@
M,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M
M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP
M92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@
M25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N
M97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE
M;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E
M+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E
M<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q
M92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@
M,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P
M02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%
M42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@
M,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB
M7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T
M>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO
M=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y
M<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [
M(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U
M8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P
M+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M
M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^
M='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P
M,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P
M,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S
M.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E
M(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)
M4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE
M<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O
M<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q
M92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G
M(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E
M+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!
M+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51
M(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y
M<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP
M92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ
M-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@
M97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E
M<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A
M(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@
M,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@
M15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ]
M(# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I
M8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B
M='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^
M;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P
M.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD
M96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z
M(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H
M8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@
M/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E2
M42!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R
M(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S
M=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP
M,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E
M+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M
M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O
M,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@
M,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M
M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP
M92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@
M25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N
M97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE
M;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E
M+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E
M<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q
M92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@
M,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P
M02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%
M42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@
M,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB
M7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T
M>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO
M=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y
M<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [
M(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U
M8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P
M+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M
M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^
M='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P
M,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P
M,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S
M.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E
M(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)
M4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE
M<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O
M<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q
M92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G
M(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E
M+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!
M+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51
M(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y
M<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP
M92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ
M-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@
M97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E
M<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A
M(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@
M,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@
M15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ]
M(# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I
M8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B
M='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^
M;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P
M.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD
M96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z
M(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H
M8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@
M/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E2
M42!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R
M(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S
M=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP
M,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E
M+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M
M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O
M,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@
M,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M
M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP
M92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@
M25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N
M97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE
M;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E
M+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E
M<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q
M92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@
M,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P
M02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%
M42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@
M,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB
M7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T
M>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO
M=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R
M;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y
M<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [
M(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U
M8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P
M+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M
M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K
M97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^
M='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P
M,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P
M,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S
M.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E
M(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)
M4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE
M<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O
M<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q
M92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G
M(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E
M+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P
M,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!
M+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51
M(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y
M<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP
M92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ
M-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@
M97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E
M<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A
M(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@
M,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@
M15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ]
M(# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I
M8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B
M='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^
M;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($UA<'!E9"!P86=E(&%T(#)F864R,# P('1O(&)F,# P(&9O
M<B!)0TTN"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O
M<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@36%P<&5D('!A9V4@870@,F9A93$P,# @=&\@.# P,# @9F]R($E#
M32X*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB
M7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T
M>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP
M.B!$=6UP:6YG($U05"!E;G1R>2 P,# P,30P,#H*2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S P72 @9C P,C!D,# @,# P,# P
M,# @,# P,# P,30@,# P,# P,#0*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYW87)N(&ME<FYE;#H@6S$P72 @,# P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,3 P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME
M<FYE;#H@6S(P72 @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P
M,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S,P
M72 @,C$P,# R.# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O
M,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@
M,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M
M=&AC82 P,# P.C$V.C P+C Z($1U;7!I;F<@35!4(&5N=')Y(# P,# Q-3 P
M.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,#!=
M("!F,# R,&8P," P,# P,# P," P,# P,# Q-2 P,# P,# P-0I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,3!=(" P,# P,# P
M," P,# P,# P,"!F9F9F9F9F9B!F9F9F9F9F9@I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,C!=(" P,# P,# P," P,# P,# P
M," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+G=A<FX@:V5R;F5L.B!;,S!=(" P,# P,# P," P,# P,# P," P,# P,# P
M," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($1U;7!I;F<@35!4(&5N=')Y(# P,# Q-C P.@I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,#!=("!F,# R,&8P
M," P,# P,# P," P,# P,# Q-B P,# P,# P-0I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,3!=(" P,# P,# P," P,# P,# P
M,"!F9F9F9F9F9B!F9F9F9F9F9@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+G=A<FX@:V5R;F5L.B!;,C!=(" P,# P,# P," P,# P,# P," P,# P,# P
M," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R
M;F5L.B!;,S!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y
M<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@36%P<&5D(#$@8VAU;FMS+S(U
M-B!+0B!A=" R-# T,# P,"!F;W(@24--+@I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)
M4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE
M<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($UA<'!E9" Q(&-H=6YK<R\R-38@
M2T(@870@,C4P,# P,# @9F]R($E#32X*2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!$=6UP:6YG($U05"!E;G1R>2 P,# P
M,3<P,#H*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@
M6S P72 @9C P,C U,# @,# P,# P,# @,# P,# P,3<@,# P,# P,#4*2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S$P72 @,# P
M,# P,# @,# P,# P,# @,# P,# P,# @,# P,&,P,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S(P72 @,# P,# P,# @,# P
M,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYW87)N(&ME<FYE;#H@6S,P72 @,C$P,# S,# @,# P,# P,# @,# P
M,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q
M92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@
M,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P
M02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I
M;F<@35!4(&5N=')Y(#@P,# Q.# P.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+G=A<FX@:V5R;F5L.B!;,#!=("!F,# R,#4P," P,# P,# P," P,#@P
M,# Q." P,# P,# P-0I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@
M:V5R;F5L.B!;,3!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M8S P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;
M,C!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,S!=(" R,3 P
M,#,X," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP
M,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E
M+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I;F<@45 @8V]N
M=&5X=#H*2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@
M("!O<'0@<&%R86T@;6%S:SH@,# P,# P,S *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYW87)N(&ME<FYE;#H@("!;,#!=(" Q,# W,3DP," P,# P,# P
M," X8C1A,V(P," P,# P,# P,B P,# P,#0P," P,# P,# P," P,# P,# P
M," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R
M;F5L.B @(%LR,%T@(# Q,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P
M,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6S0P72 @,# P
M,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P
M,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYW87)N(&ME<FYE;#H@("!;-C!=(" P,# P,# P," P,# P,# P-2 P
M,# P,# P," P,# P,3<P,"!A.3 P-# P." P,# P,# P," P,# P,# P," P
M,# P,# X, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L
M.B @(%LX,%T@(# P,# X,# P(# P,# P,# Q(# P,# P,# P(# P,# P,# P
M(# P,# P,# X(# P,# P,# P(#(U,#(P,# P(# P,# P,#@P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6V$P72 @,# P,# P
M,# @,# P,#=F9F4@,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYW87)N(&ME<FYE;#H@("!;8S!=(" P,# P,# P," P,# P,# P," P,# P
M,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @
M(%ME,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V
M.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E
M<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1'5M<&EN9R!14"!C
M;VYT97AT.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L
M.B @(&]P="!P87)A;2!M87-K.B P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LP,%T@(#(P,#<Q.3 P(# P,# P
M,# P(#AB-&$S8C P(# P,# P,# R(# P,# P-# P(# P,# P,# P(# P,# P
M,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K
M97)N96PZ(" @6S(P72 @,#$P,# P,# @,# P,# P,# @,# P,# P,# @,# P
M,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!;-#!=(" P
M,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P
M,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LV,%T@(# P,# P,# P(# P,# P,# U
M(# P,# P,# P(# P,# Q-S P(&$Y,# T,# X(# P,# P,# P(# P,# P,# P
M(# P,# P,#@P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N
M96PZ(" @6S@P72 @,# P,#@P,# @,# P,# P,#$@,# P,# P,# @,# P,# P
M,# @,# P,# P,#@@,# P,# P,# @,C4P,C P,# @,# P,# P.# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!;83!=(" P,# P
M,# P," P,# P-V9F92 P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+G=A<FX@:V5R;F5L.B @(%MC,%T@(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ
M(" @6V4P72 @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @
M,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [
M(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($1U;7!I;F<@45 @8V]N=&5X=#H*2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!O<'0@<&%R86T@;6%S
M:SH@,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME
M<FYE;#H@("!;,#!=(" S,# W,3DP," P,# P,# P," X8C1A,V(P," P,# P
M,# P,B P,# P,#0P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LR,%T@(# Q
M,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N=V%R;B!K97)N96PZ(" @6S0P72 @,# P,# P,# @,# P,# P,# @
M,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @
M,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE
M;#H@("!;-C!=(" P,# P,# P," P,# P,# P-2 P,# P,# P," P,# P,3<P
M,"!A.3 P-# P." P,# P,# P," P,# P,# P," P,# P,# X, I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LX,%T@(# P,# X
M,# P(# P,# P,# Q(# P,# P,# P(# P,# P,# P(# P,# P,# X(# P,# P
M,# P(#(U,#(P,# P(# P,# P,#@P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N=V%R;B!K97)N96PZ(" @6V$P72 @,# P,# P,# @,# P,#=F9F4@,# P
M,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P
M,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@
M("!;8S!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P
M,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%ME,%T@(# P,# P,# P
M(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P
M(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S
M.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@1'5M<&EN9R!14"!C;VYT97AT.@I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(&]P="!P87)A;2!M
M87-K.B P,# P,# S, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@
M:V5R;F5L.B @(%LP,%T@(#$P,#<Q.3 P(# P,# P,# P(#AB-&$S8C P(# P
M,# P,# R(# P,# P-# R(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6S(P72 @
M,#$P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @
M,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYW87)N(&ME<FYE;#H@("!;-#!=(" P,# P,# P," P,# P,# P
M," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P
M," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R
M;F5L.B @(%LV,%T@(# P,# P,# P(# P,# P,# U(# P,# P,# P(#@P,# Q
M.# P(&$Y,# T,# X(# P,# P,# P(# P,# P,# P(# P,# P,#@P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6S@P72 @,# P
M,#@P,# @,# P,# P,#(@,# P,# P,# @,# P,# P,# @,# P,# P,#@@,# P
M,# P,# @,C4P,C Q,# @,# P,# P.# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYW87)N(&ME<FYE;#H@("!;83!=(" P,# P,# P," P,# P-V9F9" X
M,# Q,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P
M,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L
M.B @(%MC,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P
M(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6V4P72 @,# P,# P
M,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E
M<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51
M(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!$=6UP:6YG(%%0(&-O;G1E>'0Z"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @;W!T('!A<F%M
M(&UA<VLZ(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R
M;B!K97)N96PZ(" @6S P72 @,C P-S$Y,# @,# P,# P,# @.&(T83-B,# @
M,# P,# P,#(@,# P,# T,#(@,# P,# P,# @,# P,# P,# @,# P,# P,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!;,C!=
M(" P,3 P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P
M," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LT,%T@(# P,# P,# P(# P,# P
M,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P
M,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K
M97)N96PZ(" @6S8P72 @,# P,# P,# @,# P,# P,#4@,# P,# P,# @.# P
M,#$X,# @83DP,#0P,#@@,# P,# P,# @,# P,# P,# @,# P,# P.# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!;.#!=(" P
M,# P.# P," P,# P,# P,B P,# P,# P," P,# P,# P," P,# P,# P." P
M,# P,# P," R-3 R,#$P," P,# P,# X, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+G=A<FX@:V5R;F5L.B @(%MA,%T@(# P,# P,# P(# P,# W9F9D
M(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P
M(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N
M96PZ(" @6V,P72 @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!;93!=(" P,# P
M,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@
M15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ]
M(# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I
M8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I;F<@45 @8V]N=&5X=#H*2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@("!O<'0@<&%R
M86T@;6%S:SH@,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW
M87)N(&ME<FYE;#H@("!;,#!=(" S,# W,3DP," P,# P,# P," X8C1A,V(P
M," P,# P,# P,B P,# P,#0P,B P,# P,# P," P,# P,# P," P,# P,# P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LR
M,%T@(# Q,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P
M,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(" @6S0P72 @,# P,# P,# @,# P
M,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P
M,# P,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N
M(&ME<FYE;#H@("!;-C!=(" P,# P,# P," P,# P,# P-2 P,# P,# P," X
M,# P,3@P,"!A.3 P-# P." P,# P,# P," P,# P,# P," P,# P,# X, I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%LX,%T@
M(# P,# X,# P(# P,# P,# R(# P,# P,# P(# P,# P,# P(# P,# P,# X
M(# P,# P,# P(#(U,#(P,3 P(# P,# P,#@P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N=V%R;B!K97)N96PZ(" @6V$P72 @,# P,# P,# @,# P,#=F
M9F0@,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P,# @,# P,# P
M,# @,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME
M<FYE;#H@("!;8S!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M,# P," P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B @(%ME,%T@(# P
M,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E2
M42!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R
M(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ
M(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1'5M<&EN9R!-4%0@96YT<GD@.# P
M,#$Y,# Z"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ
M(%LP,%T@(&8P,#(P9C P(# P,# P,# P(# P.# P,#$Y(# P,# P,# U"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LQ,%T@(# P
M,# P,# P(# P,# P,# P(&9F9F9F9F9F(&9F9F9F9F9F"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LR,%T@(# P,# P,# P(# P
M,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N=V%R;B!K97)N96PZ(%LS,%T@(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E
M<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N
M(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A
M(# P,# Z,38Z,# N,#H@1'5M<&EN9R!-4%0@96YT<GD@.# P,#%A,# Z"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LP,%T@(&8P
M,#(P9C P(# P,# P,# P(# P.# P,#%A(# P,# P,# U"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LQ,%T@(# P,# P,# P(# P
M,# P,# P(&9F9F9F9F9F(&9F9F9F9F9F"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N=V%R;B!K97)N96PZ(%LR,%T@(# P,# P,# P(# P,# P,# P(# P
M,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R
M;B!K97)N96PZ(%LS,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O
M<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X
M.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z
M,# N,#H@1'5M<&EN9R!-4%0@96YT<GD@.# P,#%B,# Z"DIA;B @-R P,CHU
M.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LP,%T@(&8P,#(P9C P(# P
M,# P,# P(# P.# P,#%B(# P,# P,# U"DIA;B @-R P,CHU.#HU-B!.0T-0
M('5S97(N=V%R;B!K97)N96PZ(%LQ,%T@(# P,# P,# P(# P,# P,# P(&9F
M9F9F9F9F(&9F9F9F9F9F"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R
M;B!K97)N96PZ(%LR,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P
M,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ
M(%LS,%T@(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U
M8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P
M+C Z($-R96%T960@541!5B!A="!E9F%E.68R,"\T9#(V-3(U,3H*2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(" @6R P72 P,3 P
M,# P-0I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M("!;(#1=(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B @(%L@.%T@,# P,#,P,# *2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYD96)U9R!K97)N96PZ(" @6R!C72 P,# P,# P, I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@("!;,3!=(# P,# P
M,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B @
M(%LQ-%T@,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U
M9R!K97)N96PZ(" @6S$X72 P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@("!;,6-=(# P,# P,# R"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P
M.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD
M96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@1'5M<&EN9R!-
M4%0@96YT<GD@.# P,#%C,# Z"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N
M=V%R;B!K97)N96PZ(%LP,%T@(&8P,#(P9C P(# P,# P,# P(# P.# P,#%C
M(# P,# P,# U"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N
M96PZ(%LQ,%T@(# P,# P,# P(# P,# P,# P(&9F9F9F9F9F(&9F9F9F9F9F
M"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LR,%T@
M(# P,# P,# P(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LS,%T@(# P,# P,# P
M(# P,# P,# P(# P,# P,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP
M92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ
M-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@
M97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B
M=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I;F<@35!4
M(&5N=')Y(#@P,# Q9# P.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A
M<FX@:V5R;F5L.B!;,#!=("!F,# R,&8P," P,# P,# P," P,#@P,# Q9" P
M,# P,# P-0I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L
M.B!;,3!=(" P,# P,# P," P,# P,# P,"!F9F9F9F9F9B!F9F9F9F9F9@I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,C!=(" P
M,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,S!=(" P,# P,# P," P
M,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)
M4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE
M<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L
M.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I;F<@35!4(&5N=')Y(#@P
M,# Q93 P.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L
M.B!;,#!=("!F,# R,&8P," P,# P,# P," P,#@P,# Q92 P,# P,# P-0I*
M86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,3!=(" P
M,# P,# P," P,# P,# P,"!F9F9F9F9F9B!F9F9F9F9F9@I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,C!=(" P,# P,# P," P
M,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+G=A<FX@:V5R;F5L.B!;,S!=(" P,# P,# P," P,# P,# P," P
M,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@4$-)
M(&1E=FEC93UE93 U-3 P,"P@;71H8V$@9&5V:6-E/65F.6(R,# P"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N;F]T:6-E(" O=V9B;F9S+VYC8W O<V-R
M:7!T<R]I8BYI;FDN,SH@<F,], I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C<FEP=',O:6(N:6YI+C,Z($QO861I
M;F<@+VUN="]T;7 O;F-C<"UJ;&(O:V5R;F5L+V1E;G@M,BXV+C(V+V1R:79E
M<G,O:6YF:6YI8F%N9"]U;' O:7!O:6(O:6)?:7!O:6(N:V\*2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z
M,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [
M(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E
M8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@
M97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA
M;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC
M82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ]
M(#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @
M=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1
M($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@
M/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@
M:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U
M8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P
M+C Z($1U;7!I;F<@35!4(&5N=')Y(#@P,# Q9C P.@I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,#!=("!F,# R,&8P," P,# P
M,# P," P,#@P,# Q9B P,# P,# P-@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+G=A<FX@:V5R;F5L.B!;,3!=(" P,# P,# P," P,# P,# P,"!F9F9F
M9F9F9B!F9F9F9F9F9@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@
M:V5R;F5L.B!;,C!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P
M,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;
M,S!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@
M,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P
M02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($1U;7!I
M;F<@35!4(&5N=')Y(# P,# R,# P.@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U
M<V5R+G=A<FX@:V5R;F5L.B!;,#!=("!F,# R,&8P," P,# P,# P," P,# P
M,# R," P,# P,# P-@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@
M:V5R;F5L.B!;,3!=(" P,# P,# P," P,# P,# P,"!F9F9F9F9F9B!F9F9F
M9F9F9@I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;
M,C!=(" P,# P,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@
M(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,S!=(" P,# P
M,# P," P,# P,# P," P,# P,# P," P,# P,# P, I*86X@(#<@,#(Z-3@Z
M-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP
M,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E
M+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@
M:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M
M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W
M(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P
M,# Z,38Z,# N,#H@1'5M<&EN9R!-4%0@96YT<GD@,# P,#(Q,# Z"DIA;B @
M-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LP,%T@(&8P,#(P
M9# P(# P,# P,# Q(# P,# P,#(Q(# P,# P,# T"DIA;B @-R P,CHU.#HU
M-B!.0T-0('5S97(N=V%R;B!K97)N96PZ(%LQ,%T@(# P,# P,# P(# P,# P
M,# P(# P,# P,# P(# P,# R,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S
M97(N=V%R;B!K97)N96PZ(%LR,%T@(# P,# P,# P(# P,# P,# P(# P,# P
M,# P(# P,# P,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N=V%R;B!K
M97)N96PZ(%LS,%T@(#(Q,# P-# P(# P,# P,# P(# P,# P,# P(# P,# P
M,# P"DIA;B @-R P,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I
M8E]M=&AC82 P,# P.C$V.C P+C Z($E242!%42 S.B!E<64M/G1Y<&4O<W5B
M='EP92 ](#!!+S P.R!E<64M/F]W;F5R(#T@,# *2F%N(" W(# R.C4X.C4V
M($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N
M,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^
M;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME
M<FYE;#H@:6)?;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT
M>7!E+W-U8G1Y<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P
M,CHU.#HU-B!.0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P
M.C$V.C P+C Z($1U;7!I;F<@35!4(&5N=')Y(# P,# R,C P.@I*86X@(#<@
M,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,#!=("!F,# R,&0P
M," P,# P,# P," P,# P,# R,B P,# P,# P- I*86X@(#<@,#(Z-3@Z-38@
M3D-#4"!U<V5R+G=A<FX@:V5R;F5L.B!;,3!=(" P,# P,# P," P,# P,# P
M," P,# P,# P," P,# P,3 P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R
M+G=A<FX@:V5R;F5L.B!;,C!=(" P,# P,# P," P,# P,# P," P,# P,# P
M," P,# P,# P, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+G=A<FX@:V5R
M;F5L.B!;,S!=(" R,3 P,#0T," P,# P,# P," P,# P,# P," P,# P,# P
M, I*86X@(#<@,#(Z-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?
M;71H8V$@,# P,#HQ-CHP,"XP.B!)4E$@15$@,SH@97%E+3YT>7!E+W-U8G1Y
M<&4@/2 P02\P,#L@97%E+3YO=VYE<B ](# P"DIA;B @-R P,CHU.#HU-B!.
M0T-0('5S97(N9&5B=6<@:V5R;F5L.B!I8E]M=&AC82 P,# P.C$V.C P+C Z
M($E242!%42 S.B!E<64M/G1Y<&4O<W5B='EP92 ](#!!+S P.R!E<64M/F]W
M;F5R(#T@,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N
M96PZ(&EB7VUT:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP
M92]S=6)T>7!E(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z
M-3@Z-38@3D-#4"!U<V5R+F1E8G5G(&ME<FYE;#H@:6)?;71H8V$@,# P,#HQ
M-CHP,"XP.B!$=6UP:6YG($U05"!E;G1R>2 P,# P,C,P,#H*2F%N(" W(# R
M.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE;#H@6S P72 @9C P,C U,# @
M,# P,# P,#(@,# P,# P,C,@,# P,# P,#8*2F%N(" W(# R.C4X.C4V($Y#
M0U @=7-E<BYW87)N(&ME<FYE;#H@6S$P72 @,# P,# P,# @,# P,# P,# @
M,# P,# P,# @,# P,#0P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW
M87)N(&ME<FYE;#H@6S(P72 @,# P,# P,# @,# P,# P,# @,# P,# P,# @
M,# P,# P,# *2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYW87)N(&ME<FYE
M;#H@6S,P72 @,C$P,# T.# @,# P,# P,# @,# P,# P,# @,# P,# P,# *
M2F%N(" W(# R.C4X.C4V($Y#0U @=7-E<BYD96)U9R!K97)N96PZ(&EB7VUT
M:&-A(# P,# Z,38Z,# N,#H@25)1($51(#,Z(&5Q92T^='EP92]S=6)T>7!E
M(#T@,$$O,# [(&5Q92T^;W=N97(@/2 P, I*86X@(#<@,#(Z-3@Z-38@3D-#
M4"!U<V5R+FYO=&EC92 @+W=F8FYF<R]N8V-P+W-C<FEP=',O:6(N:6YI+C,Z
M(')C/3 *2F%N(" W(# S.C Q.C$Q($Y#0U @=7-E<BYN;W1I8V4@2DQ".B!A
=8F]U="!T;R!S=&%R="!S=6)N970@;6%N86=E<@H`
`
end


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
