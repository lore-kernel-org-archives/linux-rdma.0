From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Can't build ofa-kernel-1.5.4 from OFED-1.5.4-rc4 with linux-3.1.1 on sparc64
Date: Tue, 15 Nov 2011 08:18:14 +0000 (GMT)
Message-ID: <1321345094.76211.YahooMailNeo@web24714.mail.ird.yahoo.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello together!

I've tried to build ofa-kernel-1.5.4 from OFED-1.5.4-rc4 with linux-3.1=
=2E1 (vanilla) on sparc64.
That's the whole log:
http://net.razik.de/linux/T5120/linux-3.1.1/ofa_kernel-1.5.4.rpmbuild.l=
og


I've got this error during build:
---

In file included from include/linux/time.h:9,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/skb=
uff.h:20,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/if_=
ether.h:131,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/net=
device.h:29,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/ine=
tdevice.h:8,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from /var/tmp/OFED_top=
dir/BUILD/ofa_kernel-1.5.4/drivers/infiniband/core/addr.c:37:
include/linux/math64.h:5:23: error: asm/div64.h: No such file or direct=
ory
In file included from include/linux/if_link.h:5,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/net=
device.h:31,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from include/linux/ine=
tdevice.h:8,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 from /var/tmp/OFED_top=
dir/BUILD/ofa_kernel-1.5.4/drivers/infiniband/core/addr.c:37:
include/linux/netlink.h:32: error: expected specifier-qualifier-list be=
fore '__kernel_sa_family_t'
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4/drivers/infiniband/core/add=
r.c: In function 'addr4_resolve':
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4/drivers/infiniband/core/add=
r.c:191: error: 'struct flowi' has no member named 'nl_u'
/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5.4/drivers/infiniband/core/add=
r.c:192: error: 'struct flowi' has no member named 'nl_u'
---

BTW1:
I've done a "make headers_install" in linux-3.1.1.
I have symbolic links
/usr/include/asm -> /usr/src/linux-3.1.1/usr/include/asm
/usr/include/linux -> /usr/src/linux-3.1.1/usr/include/linux

etc.
And there's no
linux-3.1.1/usr/include/asm/div64.h
BTW2:=20
include/linux/math64.h (which tries to include the inexistent asm/div64=
=2Eh)
isn't from
linux-3.1.1/usr/include
but from
linux-3.1.1/include



Regards,
Lukas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
