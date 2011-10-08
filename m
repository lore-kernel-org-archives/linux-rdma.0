From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.2 v2 1/5] ib/core: Add extended link speeds
Date: Sat, 8 Oct 2011 22:40:07 +0200
Message-ID: <CAJZOPZ+Urd33RdT9R0Sd0-ysZ0xHig4EHpHobY7Ht29XK-uNaA@mail.gmail.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
	<201110051321.48023.marcela@dev.mellanox.co.il>
	<1828884A29C6694DAF28B7E6B8A8237316E697CA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E697CA-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 5, 2011 at 8:40 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:
>> The following extended speeds are introduced:
>> FDR-10 =A0- is a proprietary link speed which is 10.3125 Gbps at 64/=
66 encoding rather
>> FDR =A0 =A0 - represents the IBA extended speed: 14.0625 Gbps.
>> EDR =A0 =A0 - represents the IBA extended speed: 25.78125 Gbps.

> Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> FWIW - this series looks okay with me.

Roland,

Just wanted to check if anything else if needed here beyond Sean's
thorough review.

BTW what's your estimate on how long do we have before the 3.2 merge
window opens?
I was under the misconception that the top (Linus) mainline kernel is
under hold as of the kernel.org being down, upto two days ago when I
noted that the first github hit for Linux is Linus tree which is @
-rc9, anyway,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
