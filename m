From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core v2 0/3] libbnxt_re bug fixes
Date: Wed, 31 Jan 2018 16:04:43 -0500
Message-ID: <1517432683.19117.40.camel@redhat.com>
References: <1517412531-25195-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yLFFcR/1+XIPVa3A8ZMe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517412531-25195-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-yLFFcR/1+XIPVa3A8ZMe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 10:28 -0500, Devesh Sharma wrote:
> Changelog:
> v1->v2:
> * fixed the DCO error in travis build checker.
>=20
> --------
>=20
> This patch series contains important bug fixes.
> Patch 1 addresses a latency test failure. Patch 2
> improves the f/w version display. Patch 3 updates
> the PCI-ID table.
>=20
> Devesh Sharma (2):
>   libbnxt_re: Fix lat test failure in event mode
>   libbnxt_re: Update and sort device pci-id table
>=20
> Selvin Xavier (1):
>   libbnxt_re: Display FW version using ibv_devinfo
>=20
>  providers/bnxt_re/main.c  | 17 +++++++++++------
>  providers/bnxt_re/main.h  |  3 +++
>  providers/bnxt_re/verbs.c | 19 ++++++++++++++++---
>  3 files changed, 30 insertions(+), 9 deletions(-)
>=20

Thanks, merged.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-yLFFcR/1+XIPVa3A8ZMe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpyL2sACgkQuCajMw5X
L91JTxAAq2T2xgMZr9t+uELNbvn5+gYo7TD4hzZEXihCjD+ZoKHU3LlFJCLfX37f
w94NnI4H+2m57duJuv50NGfpvx6LdM/oX+T4XttUHk+b3/0KrQ3AVX0KRg6uUt+g
Un9m2DDPpab5io5ZlC9VUZOZroYjLoVWpWqyqAIZgqfEkgLYniIDZmSPRX9Po4tx
nRZVgUXfs1CXnDGsF/w399JNR7KRFBDPMSYBfIWQLayb8OmY1Q4sglY8mE3Er9KO
kpPIwTTp9zmJEvZXf5+qMTBUeStUM8I1m1hzDJl0js7DyXHMMZdUBGLdihAeHjpB
4/cQi9QaZ8vsNxvOQwd93z3oGpDTmi+vwSFLbRHKapZJ9c4C4cafa6c9Cq2nmMX+
gh+BxmChtX7uqGi3Q4yM0sC+2ZmjCJVWTgp75V2DnBWhegzxSOMwHIRoITts5Ibo
DG6dBsGjW+ul/0FkGga2f1vWbYNLV0oZOLO8VPOfP8aBmMdNPZz8ThLwhZkdJiwS
7lPcITRUuaJI/JJVWeGQZIo4VBnOjtIMsm4vGK/QVfTya/pvyudumySnxTT/W8vf
7BoWYbnFiLZKNNqdHcdXT2ivD/D3sARvd+RsA2bJGxvmrZZpkIF9lQn0M/OJPLIk
aqK1a01mrf+wKrnGiWLEH/bD6gtBDVjtEdI/KTcLxPArol4M0/s=
=6IwD
-----END PGP SIGNATURE-----

--=-yLFFcR/1+XIPVa3A8ZMe--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
