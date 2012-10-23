From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: no-snoop flag in memory registration?
Date: Tue, 23 Oct 2012 16:32:57 +0200
Message-ID: <OF72E3714A.302C2D7F-ONC1257AA0.004EFF39-C1257AA0.004FEEE9@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi all,
we are implementing a Linux/RDMA solution based on Mellanox/RoCE. Our
memory registration is done via "ib_get_dma_mr()".
During a problem follow-up someone asked us about the "no-snoop" flag a=
nd
how it is set during memory registration in Linux. I digged into
drivers/net/ethernet/mellanox/mlx4/mr.c, to find some MLX4_MPT_FLAGS_
visible there. Nothing seems to be related to a "no-snoop" flag.
Can anybody shed some light on this, whether we can set the so called
"no-snoop" flag, or is that beyond the scope of Linux support.

Kind regards
Klaus Wacker
IBM Systems &Technology Group, Systems Software Development
SW Linux on System z Dev & Service
Phone:  +49-7031-16-3779   IBM Deutschland  E-Mail:  kdwacker-tA70FqPdS9Zhl2p70BpVqQ@public.gmane.org=
m
Schoenaicher Str. 220   71032 Boeblingen   Germany
IBM Deutschland Research & Development GmbH / Vorsitzende des
Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: Amtsgericht Stutt=
gart,
HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
