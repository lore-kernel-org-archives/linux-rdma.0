From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/hfi1: Prevent a NULL dereference
Date: Wed, 10 Jan 2018 17:03:29 -0500
Message-ID: <1515621809.3403.175.camel@redhat.com>
References: <14063C7AD467DE4B82DEDB5C278E8663A9F7F391@fmsmsx107.amr.corp.intel.com>
         <20180109200346.rlsrxa24xmltpz2r@mwanda>
         <14063C7AD467DE4B82DEDB5C278E8663A9F7FC30@fmsmsx107.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8ikicQG7I5V6RyPAKsw9"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663A9F7FC30@fmsmsx107.amr.corp.intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-8ikicQG7I5V6RyPAKsw9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 20:39 +0000, Ruhl, Michael J wrote:
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> > owner@vger.kernel.org] On Behalf Of Dan Carpenter
> > Sent: Tuesday, January 9, 2018 3:04 PM
> > To: Marciniszyn, Mike <mike.marciniszyn@intel.com>
> > Cc: Dalessandro, Dennis <dennis.dalessandro@intel.com>; Doug Ledford
> > <dledford@redhat.com>; Jason Gunthorpe <jgg@ziepe.ca>; linux-
> > rdma@vger.kernel.org; kernel-janitors@vger.kernel.org
> > Subject: [PATCH v2] IB/hfi1: Prevent a NULL dereference
> >=20
> > In the original code, we set "fd->uctxt" to NULL and then dereference i=
t
> > which will cause an Oops.
> >=20
> > Fixes: f2a3bc00a03c ("IB/hfi1: Protect context array set/clear with spi=
nlock")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: In v1, I accidentally moved the __clear_bit() out from under the
> >     spin_lock().  Thanks for the review, Michael!
> >=20
> > diff --git a/drivers/infiniband/hw/hfi1/file_ops.c
> > b/drivers/infiniband/hw/hfi1/file_ops.c
> > index 82086241aac3..bd6f03cc5ee0 100644
> > --- a/drivers/infiniband/hw/hfi1/file_ops.c
> > +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> > @@ -763,11 +763,11 @@ static int complete_subctxt(struct hfi1_filedata =
*fd)
> >  	}
> >=20
> >  	if (ret) {
> > -		hfi1_rcd_put(fd->uctxt);
> > -		fd->uctxt =3D NULL;
> >  		spin_lock_irqsave(&fd->dd->uctxt_lock, flags);
> >  		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
> >  		spin_unlock_irqrestore(&fd->dd->uctxt_lock, flags);
> > +		hfi1_rcd_put(fd->uctxt);
> > +		fd->uctxt =3D NULL;
> >  	}
> >=20
> >  	return ret;
> > --
>=20
> Cc: <stable@vger.kernel.org> # 4.14.x

Unfortunately, patchworks doesn't pick up additional Cc: tags, only
reviewed-bys and acks.  In any case, I hand added it.  Thanks, applied
to for-rc.

> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>=20
> Looks good.  Adding tag for stable too.
>=20
> Thanks,
>=20
> Mike
>=20
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-8ikicQG7I5V6RyPAKsw9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWjbEACgkQuCajMw5X
L90LNA/+LaT/dchBLJ32A2LG0hCehHZubf6IC/UwnRaBA1QMuNa599HNWXwB35vv
wSil4bQxV7g526yPj0zK7Pg0a4yiyWKaH79VYJvmHER1yNXtO7Cst6GqWAeIbPLS
jmRWM4KyBfvHMWwIYtbmqaXUNq+Mr7dm+SlbyoW0gUjov6nYrQzIG218knhaMkQ8
86tFay804HVnrOeoGGobINQQL1G4av3Vh8s6zLb7Shz0SHWIu30XFBp9REslQRSx
23gEbVGLbBoF+JIaTmpC8TO/V9tKL2yn2Fa5S7FeTNINAKVlwTjYetusEbaYcDp8
1wOGVLoe8cL9Y3VnJIVc2iHYx866sXsWU4uAp6Adqcr/oMQRZ8fz/KjnRFUb7kvW
B6UgmVvC0LhU/1dYzM3+dNHmLSxC51OTOoqvQDKYumNCZc8iwo2Ds8O0YIcEYvZK
lpxO1o7r3fKpcQKbCcNUQoZyDW9/b87IY9YrxEavS8mYBThczVhuqX4Hmj1vx1Hd
9ELKbhcByE/3EahePRvEJnG6ZJYr0qakPHagGynzeCqe0OXsidFpyNJZRDAYMkxY
NoHNWLMAqRX0ISQjZrCjLPKUnXMG/vzQikPMNwfT7uWNRTI7OCbovcnwuY/aoWA2
DOT/SmfaGDYHQiBUZcCf8ymCKMXH2DdDGzaxjP4izTqNZ0hq8uI=
=hAYV
-----END PGP SIGNATURE-----

--=-8ikicQG7I5V6RyPAKsw9--

