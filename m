From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Mon, 3 Oct 2011 16:35:46 -0700
Message-ID: <CAG4TOxN8FYggab5Juk+VhSbbQ5a8mn0KJGM4=7uJB0Df8rpA4g@mail.gmail.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237316E690F8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E690F8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 3, 2011 at 11:53 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> I like this approach better, but I wonder if it still couldn't be sli=
ghtly cleaner. =A0Rather than returning 'rounded' and having the caller=
 assume that 1 means add .5 to the result, we could return the fraction=
al part directly. =A0I.e. rename 'rounded' to 'fraction' and return 5.

Why not just define this function to return the rate in units where
it's a whole number?
ie just have the function return the value in Mbps instead of Gbps, so
it returns
2500, 5000, etc. instead of 2+(*rounded=3D5), 5+(*rounded=3D0), etc.

By the way, you say:

 > FDR     - represents the IBA extended speed: 14.0625 Gbps.

but AFAIK FDR is 14.025 Gbps (and my suggestion above would let this be
returned as 14025 Mbps).

> Or if ib_rate_to_int() is only used to convert the rate into a string=
, we could just return the string directly.

Maybe... I think it gets used in IPoIB too if I didn't misread things.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
