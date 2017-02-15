From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/cma: Family of destination address should
 be equal to family of source address
Date: Wed, 15 Feb 2017 10:12:10 -0500
Message-ID: <1487171530.86943.95.camel@redhat.com>
References: <20170214052408.16361-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GSAPMsGv0PN+WqLiwLOD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214052408.16361-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-GSAPMsGv0PN+WqLiwLOD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-02-14 at 07:24 +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> The destination address in a listening rdma_id does not have an
> address
> family. Since address family in both sides of a connection must be
> the
> same in rdma_bind_addr() we set the address family of the destination
> to
> the address family of the source.
>=20
> This patch serves the logic in cma_port_is_unique() which requires to
> know if destination address that is associated with a rdma_id is any
> address
> (cma_zero_addr() and cma_loopback_addr()).
>=20
> This can happen when port reuse is checked for a port number
> that is being listened to.
>=20
> Fixes: 19b752a19dce ("IB/cma: Allow port reuse for rdma_id")
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-GSAPMsGv0PN+WqLiwLOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYpG/KAAoJELgmozMOVy/djz0P/1K6q1u2V/dUE/+5ZwpW39op
v0WPayymve49LwHtzcDf2Wl1bF3VdUCdFTLw3uRY04u/cb7zqmvVQEKk5JFWFGu/
4tFgD1SY9H4SuLncE6g7h5tDJtAsq8ZEnK8uEieBzwIXpDGLG7aattx4lQOMDQ/9
7Ux+eZmlCDOdVSzTsDnrtEBcvdXnLBWXGpfvPXs2lI5A6JdU+cdahNPd3p9wMdhB
EMHKw7X0gpePlC88Ke1bPb4zqd7Pv6NnRF1pmKGOMXHGajICYCPq2ORLDB57pkhP
pHjPR8npZv9aWZM1Z/mQuFxam6ASzZ3XvzgcCNTkEuOE2P3JUaTPBA+MB+M1IReB
zJnAb2U92yfeRUdWVjjYm9q3iGlth4uHftQoj5xJsM65fhTD53x15vt+tMkALDyt
zi3NUwkWfAxGIwbD/wADRnVpNII7nxNr62A8YSvxMTQuS6UqkyL/CDuAHBQ8GUm9
uYoW3wvfL63pFDO7dXlJk4biOBConJSjgoaupp+Iq8F6FuMcl/Sg2bawLdFKqZlA
apPGllCA3Z12wNmDHh5504r8irMEZBZ/lh8ynldTo1bqMmp/ZmHg/CCGCv9jann2
QhD9Zn6rhFj6aBula4LB6tM3e3LIqnX1viiWTkGwBn5JGQCz38KRkQMpni5UBykh
zRO3x97WKe3IhQ+f2wQM
=fdoe
-----END PGP SIGNATURE-----

--=-GSAPMsGv0PN+WqLiwLOD--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
