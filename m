From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/4] Add support of NOIO allocations to IPoIB
Date: Sat, 22 Jul 2017 13:08:30 -0400
Message-ID: <a46ae5f3-ac2d-f67e-2e89-8391e3db1ea1@redhat.com>
References: <20170523113816.32657-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4PEOco3KTD3rgCus78Ek1dAbVHo4K6agc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523113816.32657-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4PEOco3KTD3rgCus78Ek1dAbVHo4K6agc
Content-Type: multipart/mixed; boundary="oD9aoGuIFkArLgSLvgJUvt0E1WBr1HaA1";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>,
 Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <a46ae5f3-ac2d-f67e-2e89-8391e3db1ea1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/4] Add support of NOIO allocations to IPoIB
References: <20170523113816.32657-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170523113816.32657-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--oD9aoGuIFkArLgSLvgJUvt0E1WBr1HaA1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/23/2017 7:38 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> These patches adds native support to NOIO allocations during
> create QP for IPoIB.
>=20
> In contrast to the commit 09b93088d750 ("IB: Add a QP creation flag
> to use GFP_NOIO allocations"), which added specific QP create flag,
> this series uses standard memalloc_noio_* calls to mark GFP_NOIO
> for all allocations paths below.
>=20
> This change allows to all drivers benefit from this facitlity
> and not only mlx4 and qib. As a nice outcome, there is a lot
> simplification in the mlx4 and qib drivers by removing need to
> carry GFP flags.
>=20
> Thanks
>=20
> Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
> Cc: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This series has been accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--oD9aoGuIFkArLgSLvgJUvt0E1WBr1HaA1--

--4PEOco3KTD3rgCus78Ek1dAbVHo4K6agc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4aOAAoJELgmozMOVy/dAuQP+wfS8rTO1KefIePq+OmUaAX5
HCHjd3mF0F+dTQcNU2f492CsjdB+pMThpGqlkNVpQXJQvn3d39gwhFabQs4vmkvj
FYQIOWon/zLs5Strs4bFlxzJmhE4PzHCECW3r5lej1nuhAmJUcmsTvncostBK7+3
t8aUa+NeeikgCOB0iEsbvvVvnC74KGz4UiufckHWGEpeDT8kkGXwcm0lctN57fbi
QPXiTEE3VYotUjtlLNbF6kMAqfLI9wvWgXh8mDGPkfA9/HOmDe1q41QNToZmrog7
25DIsSv9I3JhQrxnM7mysuq/eU01xayqUoxeYi7joWmW77V4vHLLfUlHrw12HpaB
EV+4gNYm8yOVDMrg+ofW64Lu4n2pYzShINeFWtJOMR3EZHncOGMnP6uMtdi9akPj
zQ/bOix+3y0xq4L/AnyXkgCkRlnmRDH+NptwZsILxrow0muKGLFbmC46BFkOunh5
7jtGPLUNiMriw9rTHKPVhMsDju8CKMnCYRJyfoNi3bHaEIgtr0PQ2ed/E/RRho+0
H0NlWtGkXOVxJ2t8wTwJ/E8HBY7fhZRL3qs614/b+CvgQXt1CKR3fRItQF/gCwuC
HJ91f5MLrnhefJzDytwRNDDJbEMDJqyzB2G3hIYQlHVmCw2JKyjpBFJN9PpHjdPa
ZfEIXNNfVxKmBbeyoebe
=ho6y
-----END PGP SIGNATURE-----

--4PEOco3KTD3rgCus78Ek1dAbVHo4K6agc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
