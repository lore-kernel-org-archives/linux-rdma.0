From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 15:47:41 -0400
Message-ID: <eb6edd23b76a176b876002cc19c546a0669cf66f.camel@redhat.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
         <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
         <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FBiqdOJLUZGq2YN6kkwY"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-FBiqdOJLUZGq2YN6kkwY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 13:37 -0600, David Ahern wrote:
> On 5/14/18 9:42 AM, Steve Wise wrote:
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/=
rdma/rdma_netlink.h
> > index 60416ed..40be0d8 100644
> > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > @@ -249,10 +249,22 @@ enum rdma_nldev_command {
> >  	RDMA_NLDEV_NUM_OPS
> >  };
> > =20
> > +enum {
> > +	RDMA_NLDEV_ATTR_ENTRY_STRLEN =3D 16,
> > +};
> > +
> > +enum rdma_nldev_print_type {
> > +	RDMA_NLDEV_PRINT_TYPE_UNSPEC,
> > +	RDMA_NLDEV_PRINT_TYPE_HEX,
> > +};
> > +
> >  enum rdma_nldev_attr {
> >  	/* don't change the order or add anything between, this is ABI! */
>=20
> I asked this before and did not get a response. As the comment above
> states with an emphasis (!) ...
>=20
> >  	RDMA_NLDEV_ATTR_UNSPEC,
> > =20
> > +	/* Pad attribute for 64b alignment */
> > +	RDMA_NLDEV_ATTR_PAD =3D RDMA_NLDEV_ATTR_UNSPEC,
> > +
>=20
> ... are you really adding new attributes in the middle?

Not really.  The new item is being explicitly set to the same value as
the item above it.  It therefore becomes two entries with the same enum
value.  The rest of the enum is all unchanged.

> >  	/* Identifier for ib_device */
> >  	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
> > =20
> > @@ -387,6 +399,20 @@ enum rdma_nldev_attr {
> >  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
> >  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
> >  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> > +	/*
> > +	 * driver-specific attributes.
> > +	 */
> > +	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
> > +	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
> > +	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
> > +	/*
> > +	 * u8 values from enum rdma_nldev_print_type
> > +	 */
> > +	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
> > +	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
> > +	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
> > +	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
> > +	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
>=20
> and again here.
>=20
> > =20
> >  	/*
> >  	 * Provides logical name and index of netdevice which is
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-FBiqdOJLUZGq2YN6kkwY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7OV0ACgkQuCajMw5X
L92mJQ/+NqfZ7C1shZNKon05pqHxXqAMQMdjq3zri08K18jSVO9NmkEw9dIID0R4
TArSXYJxGey4Xo5YVboY8MJopyL0tGPSlIw4ZoSERS0mnMtL9hH4mcDLIdiMYpp7
/kagQrlOAK7awztMm9dWvMsNploYWDAL7PApmgqwrnkxTljpEcGz1jbNllYFSPJo
lTvlS3fymUBEGyLFJqD+PrggLwFtGtnyZazzSrAll6T0wuHcJBQornCNBbIUD80M
8PVvZ74qJuekrrV7pklqytawoaI8OZbdpDFLK+k/0I1Yu9YKLpZIMDhVQmjyrIKu
FKHrFM3cav8suibPWw6mQH2sEIm37VOyw+6TN3rOEZL9diWd7S7z0WvqXnoua6UO
Dy+MhprtVeGNO3qipyDW951bUfPMsDhumcUiCP9/Koteydg0vJQpDaRGWRq4UYv3
O7psngN76JYNzsIEwn1WBR7O5zqEYUkQHWAFYcE61m5vREmwbgrOUGUxcaV4axiq
MKXgnXYYUkU+EhAzcVsJuoX1AaNTnlt00axu5cmGnC2ZWH87UkxqrdhZRZYDGkEb
dbR2icwuqmysIwG00evLAeD4kWVQp/a8hzOhfHJe7lVF5O1vivSrxj5nOnMlXNhw
ha6bSOJJNzTbMmmuNmzS8IRvBk4wlHVz/+jtdrEEvqumbvnSuoI=
=8y91
-----END PGP SIGNATURE-----

--=-FBiqdOJLUZGq2YN6kkwY--
