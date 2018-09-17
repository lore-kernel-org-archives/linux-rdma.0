From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 2/2] IB/mlx4: Add port and TID to MAD debug print
Date: Mon, 17 Sep 2018 20:52:55 +0300
Message-ID: <20180917175255.GP3661@mtr-leonro.mtl.com>
References: <20180917145309.1255642-1-Haakon.Bugge@oracle.com>
 <20180917145309.1255642-3-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917145309.1255642-3-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, yishaih@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, jackm@dev.mellanox.co.il
List-Id: linux-rdma@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2018 at 04:53:09PM +0200, H=E5kon Bugge wrote:
> Add said information and make the debug print format consistent.
>
> Signed-off-by: H=E5kon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/hw/mlx4/mad.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbn+n3AAoJEORje4g2clin+gQQALRcu1z/F1uuFfCCkmDSg1Pc
yIiGR+1o1rdTwXmwooL+dj+Bp4gNHLx6d7iXNdDF4m7bLUaElfmO+vkfnUVRk7uK
vJQP2mjTZdrskbgXK/G9lujYE/elsI+ZyNIkyDYSSwRnOWHB8vdTOQlvNKBSiUFC
UJ78pgryTs6g7S5NYyN2JuvJpgcONjcHotqse+L5wCWufXDhi52YFIoX0M8jZoMH
jujlhx2uwGOzDcCzhRsEmpbpXShHSnpX47mq6CscPh2LXnnBgRi4YWMC+6z6WNXJ
5h1iGi2hfRgsZgWxC0kC6XzMiW0W5UEwT4tqhxQhssNwJ4sDUkEv8PJ6QN0Wsqru
wInBMPvc+U5ax5rUw5WKOk/h6Ccby0HB08Rf7BlHaYeRhbB8DCObPIkbhAkO8rrz
50h6TL+APC/2rBMpTHpSXv8m9akoPdcurlFjTWk+KW8Od7f37NHFRij9XXdpuBip
ON3m+Btkivmn/OnBgPZ5d/PCArYuWqrtVIiJVZJ3xL1K/Yf0FOm0YzQQXqb4EbeC
ZboBYyQOpIC2mltgbJAg5E6AMslmbzxPQdxiPJhhrKlTDcYJD9HefLvsG5PMQe3q
WLWTjJMcLOGN+Gd9LdVi2wpD9GfcA8bIVbSAjjZfa7LOU18yn2REqoKwJb6hZmyf
zSYeKhdy5wV28P9y8O8s
=bF+g
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
