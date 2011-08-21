From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Sun, 21 Aug 2011 17:42:18 +0300
Message-ID: <201108211742.18803.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201108031337.24527.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237316E3E55C@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E3E55C-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Shamis, Pavel" <shamisp-1Heg1YXhbW8@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Shumilin, Victor" <victor.shumilin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Truschin, Vladimir" <vladimir.truschin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devendar Bureddy <bureddy-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>, "mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org" <mvapich-core-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 11 August 2011 01:20, Hefty, Sean wrote:
> To help with OFED feature level compatibility, I'm in the process of =
adding a new call to ibverbs:
>=20
> struct ib_qp_open_attr {
> =A0=A0=A0=A0=A0=A0=A0=A0void (*event_handler)(struct ib_event *, void=
 *);
> =A0=A0=A0=A0=A0=A0=A0=A0void =A0*qp_context;
> =A0=A0=A0=A0=A0=A0=A0=A0u32 =A0 =A0qp_num;
> };
>=20
> struct ib_qp *ib_open_qp(*xrcd, *qp_open_attr);
>=20
> This provides functionality similar to ib_reg_xrc_recv_qp(). =A0It al=
lows any process within
> the xrcd to modify the tgt qp and receive events.=20
> Its use is not required, so we can support both usage models.=20
>=20
> I believe we can define this generic enough that it could eventually =
be used
> to share other QP types among multiple processes, though more infrast=
ructure would be needed.=20
>=20
Hi Sean,
Sorry for no reply until now -- I was on vacation for 2 weeks, and got =
back to work only today.

I am a bit concerned here.  In the current usage model, target QPs are =
destroyed when their reference count goes to zero
(ib_reg_xrc_recv_qp and ibv_xrc_create_qp increment the reference count=
, while ib_unreg_xrc_recv_qp decrements it).
In this model, the TGT QP user/consumer does not need to know if it is =
the last user of the QP (and therefore should
destroy it).  The QP simply gets destroyed when no one is left using it=
=2E

In your proposed model, it looks like the last TGT QP user needs to kno=
w that it is the last user and must therefore destroy
the TGT QP (rather than the QP being destroyed automatically as the res=
ult of the ref count going to zero).

Am I correct?

(Or does every user -- both the creator and the caller of ib_open_qp do=
 an ib_destroy_qp() -- and the destroy actually
occurs when no users who did open/create remain?).

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
