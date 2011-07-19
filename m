From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] rdma_cm: avoid assigning an IS_ERR value to cm id pointer in CMA id object
Date: Tue, 19 Jul 2011 09:45:43 +0300
Message-ID: <201107190945.44326.jackm@dev.mellanox.co.il>
References: <201107141058.29879.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E6B9@ORSMSX101.amr.corp.intel.com> <CAL1RGDWn_wqK3-0NM4NG1=wHw9_Q-2TT2goB_H_3RtyPEdS7aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWn_wqK3-0NM4NG1=wHw9_Q-2TT2goB_H_3RtyPEdS7aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday 18 July 2011 19:39, Roland Dreier wrote:
> On Mon, Jul 18, 2011 at 9:35 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> w=
rote:
> >> - =A0 =A0 if (ret && !IS_ERR(id_priv->cm_id.ib)) {
> >> + =A0 =A0 if (ret && !IS_ERR(id)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_destroy_cm_id(id_priv->cm_id.ib);
> >
> > I would change the above line to ib_destroy_cm_id(id) to align the =
destroy call with the if statement.
>=20
> OK, I'll grab this and make that suggested change as I merge it... no
> need to resend.
>=20
>  - R.
Thanks, Roland!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
