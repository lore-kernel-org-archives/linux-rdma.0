From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Questions regarding CMA
Date: Sun, 17 Jul 2011 10:08:53 +0300
Message-ID: <201107171008.53552.jackm@dev.mellanox.co.il>
References: <201107141058.29879.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E14C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302E14C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday 14 July 2011 20:46, Hefty, Sean wrote:
> Although it's a minor performance gain, I'm leaning towards keeping i=
d_priv->cm_id.ib =3D NULL on failure, either by resetting it or using a=
 local variable. =A0cma_has_cm_dev() can then be replaced by checking i=
d_priv->cm_id.ib for non-NULL, and checks for IS_ERR(id_priv->cm_id.ib)=
 are removed.
>=20
> > Please consider the patch below as a starting point (I did not touc=
h the iwarp
> > code).
> > Please let me know (ASAP) what you think.
> > (I still leave a window here where id_priv->cm_id.ib is ERR. Is thi=
s a
> > problem?
> > =A0Would it be better to use a local variable instead of id_priv->c=
m_id.ib, and
> > =A0only assign to id_priv->cm_id.ib when all the error checks have =
passed?
> > =A0This would leave a window where a successful cm_id creation is n=
ot
> > immediately assigned
> > =A0to the CMA object -- would this be a problem?).
>=20
> Without adding more synchronization, we need to ensure that id_priv->=
cm_id.ib is set before a user can receive any callbacks.
> This restricts our use of a local variable to the create_cm_id calls =
only.
> See cma_connect_iw() for an example of using this approach. =20
>=20
Agreed.  That way we never have to test for IS_ERR. I'll send a patch.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
