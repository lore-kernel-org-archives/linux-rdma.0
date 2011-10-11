From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] net/mlx4_core: remove module param controlling the
 vlan table size
Date: Tue, 11 Oct 2011 10:28:19 -0700
Message-ID: <CAL1RGDVk2EOmgWU_iZQWQqKJFPNYN4o_5_14Qbr_6wUzTJ1bOg@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com>
 <CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww@mail.gmail.com> <4E93EF38.5040707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E93EF38.5040707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 11, 2011 at 12:24 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> Yes, I now understand even better why you hate adding module params..=
=2E
> specifically here, this table relates
> only to IBoE users, which is relatively new (in since 2.6.37) and did=
n't hit
> yet most (if not all) of the
> distros, =A0so I don't expect anything to break, makes sense?

No, I think we need to switch to ignoring the parameter and printing a
warning if someone sets it, and then we can remove it in a year or so.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
