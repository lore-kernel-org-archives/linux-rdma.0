From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 8/8] RDMA: Use defines instead of hard coded value
 for phys_state
Date: Wed, 23 Aug 2017 18:29:15 +0300
Message-ID: <20170823152915.GQ1724@mtr-leonro.local>
References: <20170815091431.12822-1-leon@kernel.org>
 <20170815091431.12822-9-leon@kernel.org>
 <D5C31047.1DB0A%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UJhykcm+BCcdfd3/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D5C31047.1DB0A%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UJhykcm+BCcdfd3/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 02:59:52PM +0000, Boyer, Andrew wrote:
>
>
> On 8/15/17, 5:14 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Leon
> Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >There are new defines to express the physical state of the link, so
> >let's reuse them instead hard-coded values.
> >
> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >---
> >diff --git a/drivers/infiniband/sw/rxe/rxe_param.h
> >b/drivers/infiniband/sw/rxe/rxe_param.h
> >index 1b596fbbe251..475767262102 100644
> >--- a/drivers/infiniband/sw/rxe/rxe_param.h
> >+++ b/drivers/infiniband/sw/rxe/rxe_param.h
> >@@ -157,7 +157,7 @@ enum rxe_port_param {
> > 	RXE_PORT_ACTIVE_WIDTH		=3D IB_WIDTH_1X,
> > 	RXE_PORT_ACTIVE_SPEED		=3D 1,
> > 	RXE_PORT_PKEY_TBL_LEN		=3D 64,
> >-	RXE_PORT_PHYS_STATE		=3D 2,
> >+	RXE_PORT_PHYS_STATE		=3D RDMA_LINK_PHYS_STATE_POLLING,
> > 	RXE_PORT_SUBNET_PREFIX		=3D 0xfe80000000000000ULL,
> > };
>
> You can also remove IB_PHYS_STATE_* from rxe.h and the places where
> they=B9re used.

At the end, I found the way to avoid the whole this series.
This series is dropped.

Thanks


>
> >
> >--
> >2.14.0
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--UJhykcm+BCcdfd3/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdn0sACgkQ5GN7iDZy
WKenEQ//b6SIemzvEpGxvQqC7gQHQydz0T8i07o//RwE6I5jcJJe4kx0c4NpQEQd
I6kTHFdDOVyN+Gf8WGgHJVnxM7XVTBmcbAkILVZG6jCKYkERBKaU1t6w826DqFIp
/SbjnXc+hO/TwRl8ujFaxV0ys/sLvJr7chZhn4+HQzag1GGU+9I2bVfWJ55Q8RrV
ze9R101RoKzk/Hg/bFGh/dORWE2tC52+YvhlDau0/d+ypjVnULSOxd7eSb8NLMiB
aN0X0IygWBNDmEhuVdYOu8mfMSKz6haEQVtZP9SkJ77KK3UmvqDsqSM2adSKSyfE
8C2ntRA60Su6d3YlFtvrcy3DSSjPrmca2bZGOccRmHr5TeU01TPS/KNF6FSvLiW9
Rk3/ARu1sVVK0p44YIXdo4q8izbeQKr5iYnzGdWIotEu6A9JwWabpA+dhQQN9N7y
s8PopPgYrJAeetjmovOI0U85BIGoT2f3QXJSY9oW1MRbnL6izrzGKcpDyH0aD+TY
F9daroL3ojDX83NR36hlVYE1r8Lg2Lg1YWEUvzJmFPPDfumTpcuFIM/skK9LbRod
BBhp0ipRokMrZNc/WnvfIuD4UZFlYpB185xDh0HWAoq6bce8nQqT0lcP6xIgm1w8
nOpiiiIp38kp0scRrQFqC/peUNL8Erou1OvdOSrFw1m65ykoyNw=
=BjlC
-----END PGP SIGNATURE-----

--UJhykcm+BCcdfd3/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
