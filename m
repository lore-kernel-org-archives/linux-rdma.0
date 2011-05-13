From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: XRC patches for upstream
Date: Thu, 12 May 2011 22:10:09 -0700
Message-ID: <BANLkTimihK7VNADH_dA-vJBzMqrk8yD0Og@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373F294@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373F294-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I'm assuming that the latest XRC patches trying to work their way ups=
tream are in your git tree in the xrc branch. =A0I didn't see any patch=
es for the mlx4 driver. =A0Do you have any patches in progress on those=
 that you can share? =A0(If not, I can pull them from the OFED 1.5 git =
tree.)

I don't really have anything for mlx4.  I spent some time a while ago t=
rying
to get XRC mergable, but I ran out of steam trying to factor out the pa=
rts of
the "receive QP" stuff that were in mlx4 but I felt should be in common=
 code.

my xrc branch has pretty much everything I did.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
