From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 16:39:13 -0400
Message-ID: <da507be52c318109eedf3a2cb038f0b3d0608048.camel@redhat.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
                 <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
                 <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
         <39cd4caf34da44885021d8646699889ced482008.camel@redhat.com>
         <004901d3ec8b$4b9ac5c0$e2d05140$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EqcnTyRBwncv/fEbc23b"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <004901d3ec8b$4b9ac5c0$e2d05140$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'David Ahern' <dsahern@gmail.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-EqcnTyRBwncv/fEbc23b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-15 at 15:28 -0500, Steve Wise wrote:
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Doug Ledford
> > Sent: Tuesday, May 15, 2018 2:53 PM
> > To: David Ahern <dsahern@gmail.com>; Steve Wise
> > <swise@opengridcomputing.com>; leon@kernel.org
> > Cc: stephen@networkplumber.org; netdev@vger.kernel.org; linux-
> > rdma@vger.kernel.org
> > Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h t=
o
> > get new driver attributes
> >=20
> > On Tue, 2018-05-15 at 13:37 -0600, David Ahern wrote:
> > > On 5/14/18 9:42 AM, Steve Wise wrote:
> > > > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h
> >=20
> > b/rdma/include/uapi/rdma/rdma_netlink.h
> > > > index 60416ed..40be0d8 100644
> > > > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > > > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > > >=20
> > > > @@ -387,6 +399,20 @@ enum rdma_nldev_attr {
> > > >  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
> > > >  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
> > > >  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> > > > +	/*
> > > > +	 * driver-specific attributes.
> > > > +	 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
> > > > +	/*
> > > > +	 * u8 values from enum rdma_nldev_print_type
> > > > +	 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
> > > > +	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
> > >=20
> > > and again here.
> >=20
> > This chunk, however, is a problem.  We'll need to fix that in the kerne=
l
> > and in this patch too.
>=20
> I'll fix this series once I fix the kernel side.  Doug, should I send a p=
atch that basically moves the DRIVER attributes to the bottom?
>=20
> Sorry about missing this!

I missed it too.  I knew about the first hunk, but thought this one was
at the end.  Anyway, I've already pushed the fix to my wip/dl-for-next
branch, so you can get it there now.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-EqcnTyRBwncv/fEbc23b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlr7RXEACgkQuCajMw5X
L92PqQ/9HQZxYFMJ8tHXyUOiZ3KSLCHEgj2UiuYCn/zv+Y8h88h+CNdYWyLPsJrB
+Fw+I6bqLophPHJzN6bhaZH/BLRmHaK9mzt+OpGHo7nMomFIsa16kc/ki4qmr5ED
R/Zw19rMhJ0R/u6EPWoq+QhlRrZG96V9JBvJALOFyJlANq5fyicASkbq1N8zLaZ6
j2OYQC6mn2kOs6oWRH3qH0YC/lu5DeNC997QhS1iCexPGKZPvJ4HCGWVD0IICYcn
lKhLlYDVVbT1ZUpRjXjFeTOrN183pI/+/YxXkDSt77zFRYHe9vfcA7uuB1RsoZcX
BPAiRisn7lipi9ifByJMmMMyHdKqi1CvUCv8F44oNy94knoD0YWR+DmvFOE6CMlU
R0Kk7ANRLKOWgD5v7SBkxxE04cbI4r97YTG7f0/x2uPRPS9UR5N213XWlwvMmVt+
qYDhHQTN9sxBIWKwrresXCPo6m3/czQunLdYzSaSGWSjmKTwjNQ6R6boz/X/sCMD
LJH1Bk7bbYvpDJt9zOuS1+WftRj6J5B+DhwtqetMp+G3heR9VOdY/ziLI6zAonYG
A4ampq9IGOykv5oHkWd4Rwitk4wHvHbPKk71b1Hj/F24A0QiciurcB716VBzY8Sr
s9J0DIM8BH8J9XMoHXwTtiZye6rWLQdun4n5FiUdpTrRhsaV5zo=
=4MkK
-----END PGP SIGNATURE-----

--=-EqcnTyRBwncv/fEbc23b--
