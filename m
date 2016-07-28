From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too many
 SGEs
Date: Thu, 28 Jul 2016 18:47:20 +0300
Message-ID: <20160728154720.GS4628@leon.nu>
References: <20160727193718.29482.73416.stgit@manet.1015granger.net>
 <20160728052246.GM4628@leon.nu>
 <DB5PR05MB1848930C5B1D2D52CD2AC3AAC5000@DB5PR05MB1848.eurprd05.prod.outlook.com>
 <80BD326A-06FD-48F3-B701-E7F9DC385EA9@oracle.com>
 <DB5PR05MB184872B96AE45A89A55F289FC5000@DB5PR05MB1848.eurprd05.prod.outlook.com>
 <5A4EA4C2-46DA-4968-9A03-555836DF515F@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfjJTYUClXDJCnRl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5A4EA4C2-46DA-4968-9A03-555836DF515F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WfjJTYUClXDJCnRl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 09:39:57AM -0400, Chuck Lever wrote:
>=20
> > On Jul 28, 2016, at 9:24 AM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >=20
> > OK, sounds reasonable. So if we follow this reasoning there are more pl=
aces to fix in the post send function:
> >=20
> > static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
> >                     struct mlx5_wqe_ctrl_seg **ctrl,
> >                     struct ib_send_wr *wr, unsigned *idx,
> >                     int *size, int nreq)
> > {
> >        int err =3D 0;
> >=20
> >        if (unlikely(mlx5_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)))=
 {
> >                err =3D -ENOMEM;
> >                return err;
> >        }
>=20
> I will let mlx5 driver experts sort those out. Feel free to fold my
> initial fix into a larger patch (or patch series).

No, this place should return ENOMEM because overflow was due to not
enough memory and not because of incorrectly filled wqe.

>=20
>=20
> > -----Original Message-----
> > From: Chuck Lever [mailto:chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]=20
> > Sent: Thursday, July 28, 2016 8:19 AM
> > To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Matan Barak <matanb@mellanox=
=2Ecom>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too m=
any SGEs
> >=20
> > Hi Eli-
> >=20
> >> On Jul 28, 2016, at 9:08 AM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >>=20
> >> I am not sure I agree with this. I intentionally put ENOMEM since this=
 indicates that the WQ buffer is not large enough to contain all the s/g en=
tries. I return EINVAL if the opcode is invalid for example.
> >=20
> > All other drivers I reviewed return EINVAL in this case. So there is an=
 implied API contract already.
> >=20
> > The functional issue here is that the consumer has attempted to post a =
Send WR with an incorrect num_sge value. sq.max_gs is a limit also specifie=
d by the consumer. There's no dynamic memory allocation here to fail.
> >=20
> > ENOMEM would be correct if a dynamic memory allocation failed, where po=
sting again with the same arguments is likely to succeed. In this case, an =
invalid parameter has been provided by the consumer, which is a permanent e=
rror.
> >=20
> > Therefore EINVAL is the correct return.
> >=20
> >=20
> >> -----Original Message-----
> >> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org=20
> >> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> >> Sent: Thursday, July 28, 2016 12:23 AM
> >> To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >> Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too=
=20
> >> many SGEs
> >>=20
> >> On Wed, Jul 27, 2016 at 03:38:36PM -0400, Chuck Lever wrote:
> >>> Other similar functions (mlx5_ib_post_recv being the closest) return=
=20
> >>> EINVAL in this case.
> >>>=20
> >>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >>=20
> >> Thanks Chuck,
> >> You are absolutely right, it should be EINVAL error.
> >> Do you mind if I submit it by myself together with other mlx5 fixes?
> >>=20
> >> Looks ok, except title :)
> >> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>=20
> >>> ---
> >>> Hi Matan, Leon-
> >>>=20
> >>> I noticed this nit while debugging a problem in xprtrdma.
> >>>=20
> >>> drivers/infiniband/hw/mlx5/qp.c |    2 +-
> >>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>=20
> >>> diff --git a/drivers/infiniband/hw/mlx5/qp.c=20
> >>> b/drivers/infiniband/hw/mlx5/qp.c index ce0a7ab..b0e5498 100644
> >>> --- a/drivers/infiniband/hw/mlx5/qp.c
> >>> +++ b/drivers/infiniband/hw/mlx5/qp.c
> >>> @@ -3436,7 +3436,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struc=
t ib_send_wr *wr,
> >>> 		num_sge =3D wr->num_sge;
> >>> 		if (unlikely(num_sge > qp->sq.max_gs)) {
> >>> 			mlx5_ib_warn(dev, "\n");
> >>> -			err =3D -ENOMEM;
> >>> +			err =3D -EINVAL;
> >>> 			*bad_wr =3D wr;
> >>> 			goto out;
> >>> 		}
> >>>=20
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
=20
> >>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=
=20
> >>> info at  http://vger.kernel.org/majordomo-info.html
> >=20
> > --
> > Chuck Lever
> >=20
> >=20
> >=20
>=20
> --
> Chuck Lever
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--WfjJTYUClXDJCnRl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmikIAAoJEORje4g2clinuMwQALauXQ9qrtmZWPu1ixmk8eXM
fFsDM+T0w6yhp1uxmkShF9rWfbW5v4hTGBM6vwSmivAcAkvZXPZQ1c69O76GerNU
LnuJWOFUpZf+o/b4VRkkQdO1j2LuD1X1p+B6HH6XbF5Ik5RWIIOC/KNjW3ugcBj4
rMK7eXoGLiuZqY+W4oyfvJU43oAqYUR5u8xZf1figCpqlu63liuF/vuE8cfYsTv3
LouZt2PqIXDXahJzt++T80XQtzTH6hMtWSJr5x6JWGI/MnS4mZm+AkTOY2FDYNni
ScqBvfFoSeMW2DwcIfNDmoC4C60doPlHLAILEE/ZBWD1CCrlomm1GLyEfvMblXaq
sMxinxhZL93wJvWivSUQW7OhLT1C4nzmCUMZ84da0i9zoOjRAL3QddmDLpazST0j
RPn0r3S9X52sCOcibfyv4uFgRoTFyBN3e+v6zr40UyNmcbGMcmrTCU32LQjPEns2
aSPiVjARSRrL8dsqXWpVtdONH/2aCRcelRiAMp6UvlZI5tXf0qkKlMeACKN9NXTb
g5UrtoJaWYr1YfBLlURiX+1opFIibt9Mdg3DCRTY/wb0LTxM09/yk7hENgV1DxxX
WALS+TOsqSfb1br/mbMUKbSToAom6bhnNJ6HNez539djymemuSXc+UeOwMUXn5KC
MlDekchgxoyR+d0LcoIO
=4c5A
-----END PGP SIGNATURE-----

--WfjJTYUClXDJCnRl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
