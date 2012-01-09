From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: enable changing HCA default max resource limits
Date: Mon, 9 Jan 2012 11:45:58 -0800
Message-ID: <CAL1RGDX=YQ3X0cUN=cRSWkXmkYQ0paRPSf3D71hKZb+DDBr_kQ@mail.gmail.com>
References: <20111108173940.GA23912@mellanox.com> <4ECBDE16.5040200@mellanox.com>
 <CAL1RGDXBwDoXs-cRD4b+8WrS0eRzwAaVn4g4+_14YSAsxpkNbw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E9BE26@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9BE26-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 22, 2011 at 12:52 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> Is there some easy way for nodes to discover the size of the fabric, =
so that drivers and applications can adjust their algorithms accordingl=
y? =A0If not, would such a feature be useful enough to consider approac=
hing the IBTA?

I don't think there's a good correlation between per-HCA resources and =
size of
the fabric anyway; for example nodes with a lot of memory probably woul=
d want
to register a lot of memory independent of the size of the fabric.

(So maybe the limits on memory registration should scale based on syste=
m
memory?)

# of QPs, multicast groups etc. is hard to know how to tune... They see=
m to
be app dependent, rather than dependent on the size of the fabric or th=
e size
of the individual nodes.

But is anyone going to know what RDMARC per QP even means, let along ho=
w
to set the value?

As I said before, it's pretty ugly to force users to learn about what
these values
mean, although I don't really have a better solution in mind.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
