From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] ConnectX-4/Connect-IB Port Counters
Date: Thu, 23 Jun 2016 11:41:11 -0400
Message-ID: <b4dc9bd0-a84c-201a-475a-a9afd9bffb44@redhat.com>
References: <1466165456-31857-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oJf3f2wjH1QGLpJsgssVEAV3omQWJEDQi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466165456-31857-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oJf3f2wjH1QGLpJsgssVEAV3omQWJEDQi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 08:10 AM, Leon Romanovsky wrote:
> This is supplementary part of mlx5 driver to generic IB counters infras=
tructure.
>=20
> Mark Bloch (2):
>   IB/mlx5: Add per port counters
>   IB/mlx5: Add port protocol stats
>=20
>  drivers/infiniband/hw/mlx5/main.c    | 134 +++++++++++++++++++++++++++=
+++++++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
>  drivers/infiniband/hw/mlx5/qp.c      |   9 +++
>  3 files changed, 147 insertions(+), 2 deletions(-)
>=20

Took a little work to make it apply, but series applied for 4.8, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oJf3f2wjH1QGLpJsgssVEAV3omQWJEDQi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXbAMXAAoJELgmozMOVy/duLcP/AzGUeufaGPqGtW+ci8ebnYB
fN1pzKtZK/wVPTSMzH3NL2kr6J2COSiS+EnYI52CZvW1pnoLy0Qou0Upnd1GME4H
UpBoTGH5GYa3Ty7VxcExRR1oyCEn8DuH3AAwlcKABxIwRiVEsQ0zuqwF+NZo4w1o
cmWxNssTb3MgXooNMoH/cFfVItnZphJlTtd/mmK32a6ra83ZkglI22mzqkLalvY+
+S1Nonm7JDXbe/aTzs6u2WHB35UjGKWBtIr9gILbknj4ycBxb6c35YK6deGH9+IJ
jmLwhh/9qIsFRrmtXM0ytTJ8+iIefZ93TDTDQB8TKAPhiYQBg3XZcIAfKyllqRkk
pCmO8hWF+6MjsqMlTUBGhww6zaql2/4S+HxiGlStqSsEI5tbTLyMjLsb2FqXJAFj
GPgH9YREE6RvGRkarHHIMO7Dsr21s7Z6lk9bZMdeNYG/aSL5yRRtLQIAJzo068Dv
b7ez/x91ziWUNKCNOJ3eTy3RlkB1g655Zq1vKtBofSpPOasLuikC9+ifKatotoYz
lp1q8h5cglues+mpcH45tx73HrIuMCWTuy6a6W2k2sYx8a7Eiop9fN8zCPTeepYU
LwhBOr/aFQtJiQQ7drK64Bmuh3a5TH6e3ii1KqfzJzlsV8v6ZnreephfKS4EW/3z
gNWhicwsdpfNrqbZNozG
=EWVW
-----END PGP SIGNATURE-----

--oJf3f2wjH1QGLpJsgssVEAV3omQWJEDQi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
