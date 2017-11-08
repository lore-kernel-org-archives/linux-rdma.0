From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/4] Cleanp SUSE Tumbleweed build
Date: Wed, 8 Nov 2017 16:50:42 +0200
Message-ID: <20171108145042.GV18825@mtr-leonro.local>
References: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="w1A23YewkF9s+fLd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--w1A23YewkF9s+fLd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 03:30:38PM +0100, Nicolas Morey-Chaisemartin wrote:
> This series is to fix the issue reported by Alaa here: https://www.spinics.net/lists/linux-rdma/msg56580.html
>
> #1 adds details on the existing situation and an option in the spec file to allow rpmbuild to work
> #2 adds support for env specific rpmbuild options
> #3 Add the option from #1 to the tumbleweed env
> #4 switches the default SUSE env to tumbleweed for validation
>
> Nicolas Morey-Chaisemartin (4):
>   suse: add a bcond to disable usage of curl-mini
>   cbuild: allow envs to pass custom options to rpmbuild
>   cbuild: disable curl-mini usage for tumbleweed env
>   buidlib: validate tumbleweed instead of leap 42.3
>
>  buildlib/cbuild             |  4 +++-
>  buildlib/package-build-test |  2 +-
>  suse/rdma-core.spec         | 12 ++++++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>

Please pay attention and try to avoid empty commit logs.

Thanks, applied.

--w1A23YewkF9s+fLd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloDGcIACgkQ5GN7iDZy
WKe9NhAApGy9/VZl43Lq2hNRJFiMWBgA7mzxudzCZr+TKjeSQ2JCiKXMnnjV5kLA
2+0soIUxsqv7PqzX2Lwrlyac6Es+mlMnmUjerDpUTpIontdgXBrlPjva0iAfqjV4
w6GycZI6WYPmo/fo8bdqOqRDufxuNTNUf19NNivQie0jNrMGBg/HKblKIcguYJzO
xWbw+Vvfv+s+O1RUPNAOLL57FBmTrSetVJIqvdAuDWpYXhbCnM2Ik+VUk5kDKH7R
qQceyoSdWlhuvrkmBrLhxvgJ/6mWvqCpAbAFfCBhX6BQ7hbGrM56BzTxQBa04VA7
HbiEfxSPNAWv9fZaJZTp/6hoH9zhPexYZAUnvGlZJbiZi++CYqmFzq/Tl+Ep5CcL
OkzojvEeULRmkhzpQI+YQsGkENaE5gEgG/JoU1sAQeIPjPomNpBWGHqfDVZDVhXM
ZUKcTRSFrS6qpk0TPEUx3U31XxQcyhH/kyAtw6YhknmrxQe5MiKTGc5GJUP5+mfO
g/+ETWqmqLH0mU3SM1ojXjA9ORy7iigwoI27xYexi9rXMlez97y/58hu8ZalzHXd
pUZtOWupbFsGwKX7RYayhi5FNvCVlYof4Q4aMnm5LeJ0RSCWoTCq0vWIg/1qqi2W
BoXvd2nsASeI3f9Mzo/5iCbWeDLPaQDCnzD+A6pWZDbBCzObejY=
=M6vg
-----END PGP SIGNATURE-----

--w1A23YewkF9s+fLd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
