From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/15] IB/rxe patches for kernel v4.11
Date: Tue, 10 Jan 2017 16:57:48 -0500
Message-ID: <1484085468.2149.27.camel@redhat.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YjmLvkou2bbSxELCcLnn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-YjmLvkou2bbSxELCcLnn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-01-10 at 11:15 -0800, Bart Van Assche wrote:
> Hello Doug,
>=20
> The patches in this series are what I came up with by reviewing and
> testing
> the rdma_rxe driver. Please consider these patches for kernel v4.11.
> The
> changes compared with v1 of this patch series are:
> - Modified patch 4 such that an unused argument is removed from
> get_mtu().
> - Introduced the "notify" argument in patch 11 instead of patch 10.
> - Modified patch 11 such that the comment that refers to the IBA spec
> is
> =C2=A0 preserved instead of removed.
>=20
> Thanks,
>=20
> Bart.
>=20
> Bart Van Assche (15):
> =C2=A0 IB/rxe: Suppress sparse warnings
> =C2=A0 IB/rxe: Constify the pool name
> =C2=A0 IB/rxe: Remove an unused function
> =C2=A0 IB/rxe: Remove an unused variable and an unused argument
> =C2=A0 IB/rxe: Remove superfluous casts
> =C2=A0 IB/rxe: Enable type checking on SKB_TO_PKT() and PKT_TO_SKB()
> =C2=A0=C2=A0=C2=A0=C2=A0arguments
> =C2=A0 IB/rxe: Let the compiler check the type of the cleanup functions
> =C2=A0 IB/rxe: Issue warnings once
> =C2=A0 IB/rxe: Add a runtime check in alloc_index()
> =C2=A0 IB/rxe: Introduce functions for queue draining
> =C2=A0 IB/rxe: Generate a completion for all failed work requests
> =C2=A0 IB/rxe: Fix a MR reference leak in check_rkey()
> =C2=A0 IB/rxe: Fix reference leaks in memory key invalidation code
> =C2=A0 IB/rxe: Remove a pointless indirection layer
> =C2=A0 IB/rxe: Fix an skb leak

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-YjmLvkou2bbSxELCcLnn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAABCAAGBQJYdVjcAAoJELgmozMOVy/dk5IP+PWjQddG2PI52/IQjrQHa2rd
Zy3r3kSjamMKOoucOd4sGtOMTfCvj8sfWm/vlgWFnt52ENVgSRIfqF0Ruo2hUdsr
Wl15Igakk6tqPtufb/uzFSOjkyQLbKtkLe+XRMGL2N32AAJ6dAWV11QOAUptQbLW
2/acfCEd9GleXLCQo6zKntXgaPopMyL5aEGqWv20DgiVw/SFqPkUm8/9ltFOl0Ja
t1z8hMk62yKT7RfgCG1RKtTEKN9k5egJMYknLa2ExIm7/gO56TcyeJM8uE7GUD7T
K42pBLai5YP0yyOyYB0HCY+WKmK4FBKi/DI5nUGHaJyTJHnmyiVM8pGheTt63hCr
I0+bZSjeFC52SxPM0Q1Ei8MFoIkhr0jO9rU+AnErJscMM3/ow8pIcxVor8lZcKuB
f6Zia+6Y3goyDaxM87qHeCvvBU9+J6QdYlBAlPCEjT4fRhIGlMaSyPI4YqsbqcIL
DOEGHY6wg00oKh737Jrtf8/xUihmonadeumXGECKc8GwQW5hwQUreaY3xJcipFxv
pSpkz5nIvpRj0SMFS5gPsYcQP89RWP46ryGNkQ0XF8UVzXN6MPdpE1PBH2HI0IdM
fNdW9qzHDu1bXFMLXMmxjliueiRuGYW8XigQ+xIrBZm0PGwpgjU5bPwgjLULooRt
2RPbL1mxv8VMnza3lxA=
=VPMT
-----END PGP SIGNATURE-----

--=-YjmLvkou2bbSxELCcLnn--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
