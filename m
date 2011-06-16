From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 21:06:09 +0300
Message-ID: <BANLkTi=r5kG4rUH1+dsgOg1LcdrzZRA_Ew@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
	<4DFA1BB8.9000305@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373021813@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373021813-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I don't know if user space can allocate raw qps, but to be safe, I'll=
 add XRC INI and TGT
> QP types after IB_QPT_RAW_ETHERTYPE (values 7 and 8) and adjust ibver=
bs to
> make the mapping simple. =A0What I was trying to suggest in my other =
email is for OFA to
> do something like this going forward:
> enum ib_qp_type {
> =A0 =A0 =A0 =A0upstream values... ,
> =A0 =A0 =A0 =A0IB_QPT_OFA_SPECIFIC =3D 2 << 24,
> =A0 =A0 =A0 =A0IB_QPT_OFA_XRC,
> =A0 =A0 =A0 =A0IB_QPT_OFA_RAW_PACKET
> So, we don't end up with conflicting types, and OFA can treat OFA_XRC=
 differently if
> the accepted XRC patches end up being different. =A0(Of course, it's =
too late to fix OFA
> XRC this way, but maybe it's possible for OFA to support existing app=
s with only a
> recompile?)

I can't speak on behalf of XRC consumers, but as for the ethernet
packet qp, we don't
want to have two qp types, upstream one and ofa one. If it doesn't
work for upstream to reserve the value of 8 for the packet qp
(hopefully to be reviewed and merged soon...) we'll require everyone
to recompile.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
