From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v2] IB/mlx5: Fix a warning message
Date: Wed, 14 Jun 2017 13:41:21 +0300
Message-ID: <20170614104121.GA17846@mtr-leonro.local>
References: <CAAKD3BDGH1STMhcCgz=K6-8EtnGGOYkx7KPS+iPidUiuLmpjNw@mail.gmail.com>
 <20170614102009.GA5171@elgon.mountain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170614102009.GA5171@elgon.mountain>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 14, 2017 at 01:20:09PM +0300, Dan Carpenter wrote:
> "umem" is a valid pointer.  We intended to print "*umem" or even just
> "err" instead.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: style change
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllBEtEACgkQ5GN7iDZy
WKfosA//balkH6XR99u8UsMOaORl/MbsYJxA2kzkXOvw0SoDe+DF53Em0AaJ+7kP
W/PdJYvzp6XNYEoubWbBwigQcsApl4gHx86X9ArH4A5iJE7d6cM/y5vynVq1f/QZ
zdHUIkG8tE8KjzMmr8D4fU/6+njrO2LGa1GYGm7WxTJQ5VwU2VSNK7lmHD1ZcVjR
sbr/yVs+3JrDY1LyNMmQ9PMFNnfMXXddpoBsn5u7LWa45b9LRdNANPQgk2bG65PO
W4nFpR7KGBeqzHlGH2SJxNkHRW5Zsy3ykoaTuGFMz9VHIvGtPTtk784Qfqd9sQQ2
gxrXNUT+qG7Kh2YYHJ/CgAVC0G+ZtKkK4zZZ4jKn83mWGvyYQUMDRDBUOJYclLGc
/lZ7MAgxiqUInadGwCslwSdQK/hqtvBHfFk5f2Ufyom5MH4safQCaImK30rjQetd
l2smOdLkBhja9ZmLjep7DBPnArInNuzG9KmsYw+t67autpPhOLZ1vxqM0xDHB1fO
Gdz05HEDQuvxizIhgCLUDfP3EiSAJkxTiWfyd8Hiv/A9VLHIAsyy/3ECei4LLsP0
f7wq5TePPGmyA1FUXWa5cudfh8k6EPFenrpr3XesfqaJQ4vXOB2nDAZgluuYW0yC
s3MFjAlkK7t8k7MQYtVMs9m3lnLyntugq5VIvik4ReIYFH3uWpM=
=mpKw
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
