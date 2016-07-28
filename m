From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too many
 SGEs
Date: Thu, 28 Jul 2016 18:44:29 +0300
Message-ID: <20160728154429.GR4628@leon.nu>
References: <20160727193718.29482.73416.stgit@manet.1015granger.net>
 <20160728052246.GM4628@leon.nu>
 <DB5PR05MB1848930C5B1D2D52CD2AC3AAC5000@DB5PR05MB1848.eurprd05.prod.outlook.com>
 <80BD326A-06FD-48F3-B701-E7F9DC385EA9@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uLzYCuFow5JXEQYy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <80BD326A-06FD-48F3-B701-E7F9DC385EA9-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--uLzYCuFow5JXEQYy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 09:18:33AM -0400, Chuck Lever wrote:
> Hi Eli-
>=20
> > On Jul 28, 2016, at 9:08 AM, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> >=20
> > I am not sure I agree with this. I intentionally put ENOMEM since this =
indicates that the WQ buffer is not large enough to contain all the s/g ent=
ries. I return EINVAL if the opcode is invalid for example.
>=20
> All other drivers I reviewed return EINVAL in this case. So
> there is an implied API contract already.
>=20
> The functional issue here is that the consumer has attempted
> to post a Send WR with an incorrect num_sge value. sq.max_gs
> is a limit also specified by the consumer. There's no dynamic
> memory allocation here to fail.
>=20
> ENOMEM would be correct if a dynamic memory allocation failed,
> where posting again with the same arguments is likely to
> succeed. In this case, an invalid parameter has been provided
> by the consumer, which is a permanent error.
>=20
> Therefore EINVAL is the correct return.

You are absolutely right, this is why I added my Acked-By.

>=20
>=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-fy+rA21nqHI@public.gmane.org=
rnel.org] On Behalf Of Leon Romanovsky
> > Sent: Thursday, July 28, 2016 12:23 AM
> > To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too m=
any SGEs
> >=20
> > On Wed, Jul 27, 2016 at 03:38:36PM -0400, Chuck Lever wrote:
> >> Other similar functions (mlx5_ib_post_recv being the closest) return=
=20
> >> EINVAL in this case.
> >>=20
> >> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >=20
> > Thanks Chuck,
> > You are absolutely right, it should be EINVAL error.
> > Do you mind if I submit it by myself together with other mlx5 fixes?
> >=20
> > Looks ok, except title :)
> > Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> >> ---
> >> Hi Matan, Leon-
> >>=20
> >> I noticed this nit while debugging a problem in xprtrdma.
> >>=20
> >> drivers/infiniband/hw/mlx5/qp.c |    2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/drivers/infiniband/hw/mlx5/qp.c=20
> >> b/drivers/infiniband/hw/mlx5/qp.c index ce0a7ab..b0e5498 100644
> >> --- a/drivers/infiniband/hw/mlx5/qp.c
> >> +++ b/drivers/infiniband/hw/mlx5/qp.c
> >> @@ -3436,7 +3436,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct=
 ib_send_wr *wr,
> >> 		num_sge =3D wr->num_sge;
> >> 		if (unlikely(num_sge > qp->sq.max_gs)) {
> >> 			mlx5_ib_warn(dev, "\n");
> >> -			err =3D -ENOMEM;
> >> +			err =3D -EINVAL;
> >> 			*bad_wr =3D wr;
> >> 			goto out;
> >> 		}
> >>=20
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
=20
> >> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=
=20
> >> info at  http://vger.kernel.org/majordomo-info.html
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

--uLzYCuFow5JXEQYy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmihdAAoJEORje4g2clinoZEP/2t9GMhDNBs/tWEH3h6HrgV9
Dav5hEY6PLpPKMUtMXmHVBDLiT3FP75DLXQbBoGkr3JuAPak3CVFG/v3tWFSHIgu
6xed4hNgtGdvz6VwW1k7p6tMUd8k3Hzo005/dteb9wSxBhUdYIhYWPiFQDC1QJWg
A49EhYZLi+So3UaQPsECR/QnPddZFc3SrtKGNhRtSTBdQUsuE/J3cmTTFjqqZke/
AROzkr/mvXDB6e9VGnzznn2nhZAdSBQ/Vz2UZA9KM2eGmwAkeEcGFKtC2MlsG9TO
pODN1hyvzrBcqcuU/id1V8Xbayj5b0QYQB+ni7UAmuNnIWB8LVr3Eu+hQvbKXEYM
0yT1Fq+GTwYFwQNQVtl1foCJhLVZGYwOOlDNdCrKKmgFd9J7gVARJsEEqdsNUWzg
9Ioyw2wx1Fl0tv90Os09gKX3iTvfR3lMwWgOzC3wGVyJPhHUUkxEjLLK+OP7xQMD
PfmVpL77rGwSuhguD8Jvv7cXF0qow+J6ZOSSN0qlmGvvN5K1zjQnyCUgCrcBmVPG
eYaKONEWW6RgimSU3o1z2N83rctrJQSWEBKQkjossuuxuJ4T0EVfRn1TzDM0Nq0W
hYMRbcYDrtsBEVWHykXuolIxxq/VKp3T94rSMJs42rDcsBJ4bYFa8cnriS26ghb4
YezEkSrFyWDvrQVgeC9F
=8ccu
-----END PGP SIGNATURE-----

--uLzYCuFow5JXEQYy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
