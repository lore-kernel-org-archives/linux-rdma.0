From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA READ
Date: Wed, 27 Apr 2016 09:25:35 +0300
Message-ID: <20160427062535.GL7974@leon.nu>
References: <1461352469-16504-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1461352469-16504-6-git-send-email-tatyana.e.nikolova@intel.com>
 <20160424073510.GC7974@leon.nu>
 <13AA599688F47243B14FCFCCC2C803BB10978BE8@fmsmsx104.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYrjF+tKt+ApYAdb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB10978BE8-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--aYrjF+tKt+ApYAdb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 26, 2016 at 03:27:46PM +0000, Nikolova, Tatyana E wrote:
> Hi Leon,
>=20
> We support multiple sges for RDMA WRITE. In the patch, the fall-through c=
ase above RDMA READ is RDMA READ WITH INVALIDATE.

I believe that we are looking on the different trees.
In official tree, the case above RDMA_READ is RDMA_WRITE.

>=20
> Thanks,
> Tatyana
>=20
> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]=20
> Sent: Sunday, April 24, 2016 2:35 AM
> To: Nikolova, Tatyana E <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-rdma-5NWGOfrQmneHXe+LvDLADg@public.gmane.org=
rceforge.net; Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH 5/7] RDMA/i40iw: Fix for using one sge for RDMA READ
>=20
> On Fri, Apr 22, 2016 at 02:14:27PM -0500, Tatyana Nikolova wrote:
> > From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > A check is added to validate the requested sge number.
> > iWARP doesn't support multiple sg elements for RDMA READ work=20
> > requests.
> >=20
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/i40iw/i40iw_verbs.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c=20
> > b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > index 2d832c7..45f70f5 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
> > @@ -74,7 +74,7 @@ static int i40iw_query_device(struct ib_device *ibdev,
> >  	props->max_cqe =3D iwdev->max_cqe;
> >  	props->max_mr =3D iwdev->max_mr;
> >  	props->max_pd =3D iwdev->max_pd;
> > -	props->max_sge_rd =3D 1;
> > +	props->max_sge_rd =3D I40IW_MAX_SGE_RD;
> >  	props->max_qp_rd_atom =3D I40IW_MAX_IRD_SIZE;
> >  	props->max_qp_init_rd_atom =3D props->max_qp_rd_atom;
> >  	props->atomic_cap =3D IB_ATOMIC_NONE;
> > @@ -2117,6 +2117,10 @@ static int i40iw_post_send(struct ib_qp *ibqp,
> >  			inv_stag =3D true;
> >  			/* fall-through*/
>                         ^^^^^^^^^^^^^^^^ Do you support multiple SGE for =
RDMA WRITE?
>=20
>=20
> >  		case IB_WR_RDMA_READ:
> > +			if (ib_wr->num_sge > I40IW_MAX_SGE_RD) {
> > +				err =3D -EINVAL;
> > +				break;
> > +			}
> >  			info.op_type =3D I40IW_OP_TYPE_RDMA_READ;
> >  			info.op.rdma_read.rem_addr.tag_off =3D rdma_wr(ib_wr)->remote_addr;
> >  			info.op.rdma_read.rem_addr.stag =3D rdma_wr(ib_wr)->rkey;
> > --
> > 2.7.4
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
=20
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=20
> > info at  http://vger.kernel.org/majordomo-info.html

--aYrjF+tKt+ApYAdb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIFtfAAoJEORje4g2clintNUQALruvUZjuJpsX4nAq25Pyk5O
ydytMAdyligTa+MdQ3IJsvJJbl8UP8k4CnZ7IhmMKB5giPhvgqbr+TEIeJqsKWne
bPp7UCrYsFg/sOSe48PBJ29/rVOCFlFb4XRooW4WsqehGw4Bx3Y0IrWiPt60OpoQ
6T0eYHTWqNKEWRitcIIxIFIQz4mromx/7qdE4jIVEe6rkKFuKsF9tYSDG5uC52ye
VIWp/rimeEXKleLIiyr7F+0qpZQV48jrEl3PYLlKfbpdZwFjk1CkynYFo3X4a1DG
XsBxFQnqJybfA2lR3SYjK/32V27ThydUOAQtwjGAMvo2gbejuaI0Pn6nfPX+Perk
hNHPm19E6Xaaxn06ZouYUWSKi+j7z08f6PTFKLhLM7R/+NB68NkI5WDrbeEQFrLW
XOvR9ioZKcSNQxXEyA8Of+yWYzHy7EELAjwvz0dCMFXN9F7/TuM0xt5UhEF3Ql1s
b+0Jno5E0+Qa2krqmqB8QdjbzM+TZ6K1dIKhbS2jiO+Undkbx9cjo6NZ/J2hFFjq
R8fx0kuz/baseW0VXSSZxkQzeYHsP6pVjHivSEqW7KIOCxl7DR+IhBnvHlAtN5ep
MbjqEYkFiIRZRyZElD2eVERcit3TXeNQpxHIxOr3zxf6BOfZn4EQRsBSZllw3MIy
h7wen2GGrNpMIGo3Y3dx
=7T0g
-----END PGP SIGNATURE-----

--aYrjF+tKt+ApYAdb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
