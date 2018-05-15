From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 15:52:37 -0400
Message-ID: <39cd4caf34da44885021d8646699889ced482008.camel@redhat.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
         <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
         <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-KjCCRKZ9TbkTIr4wsZTr"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>, Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-KjCCRKZ9TbkTIr4wsZTr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 13:37 -0600, David Ahern wrote:
> On 5/14/18 9:42 AM, Steve Wise wrote:
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/=
rdma/rdma_netlink.h
> > index 60416ed..40be0d8 100644
> > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> >=20
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

This chunk, however, is a problem.  We'll need to fix that in the kernel
and in this patch too.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-KjCCRKZ9TbkTIr4wsZTr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7OoUACgkQuCajMw5X
L90QvA/8DLmwc5bVDz0jhqFUGvWjPKYT4yWlt4NPlwk3DDUHkIyRI1bMpmz5A1ji
1oXgbuXFajM2yVOyASLTMRIAXR9Vy9bsOeKE6+cfd+0yvrDbnSkBnbmg1BenmqrA
QdPhFba5z5v8pRd+TkewcdQYG5AiXePV7Lj57FOj0D6t5rajxKxUr4OR0ujmKr+M
tajkSxYeKpBADhanMir439AdYQyQeoghXhyxVlSTyfnIDxDx8Wq/6LBVeB/LysSy
zMH5bVyvDvCehDbC04O7FZBAaON4Sx/LRYc8wp/vrx7GEGZwS2VSIpcWwDIf+qZa
qqszK+KOslVRffgYYdaifQwwrSPtv3t101IT6DJqGIi17qKckFUIcJjBpRljrzFs
ojL6fhrTjwMheXB+cMKWzrwnHGhR2fIhOE+vx5pfyVDoDuNrh/seD3SvijNjIBzr
iYiyQV9T7jlmxQ96Xraqs3jH05eGNTXMoWx3zviLHHmLZHDW6y0me17/Xz+rkx6v
cDLVyreAiqyUGBpviA7RDDZhq9kuRvvnI/mstnpPBVESSg3r640xtm8p1928xBLm
3vlnC4u7GQUAQuuCc2kJqysIZdjBKRSz1E7+UljkCNlYjFv42jSDNhIK2M3+vVG4
INWjNFnL+J6vhuyN1U2f3juwOI+FkRonudhpvQcxqQ+FLWYNMkw=
=bVCM
-----END PGP SIGNATURE-----

--=-KjCCRKZ9TbkTIr4wsZTr--
