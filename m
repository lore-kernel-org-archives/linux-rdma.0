From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] IB/mlx5: make function mlx5_ib_get_vector_affinity
Date: Wed, 16 Aug 2017 13:03:34 +0300
Message-ID: <20170816100334.GL24282@mtr-leonro.local>
References: <20170816092940.11158-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yV94raM4eJLN8srE"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170816092940.11158-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--yV94raM4eJLN8srE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 10:29:40AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The function mlx5_ib_get_vector_affinity is local to the source
> and does not need to be in global scope, so make it static.
>
> Cleans up sparse warning:
> symbol 'mlx5_ib_get_vector_affinity' was not declared. Should it be static?
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Hi Colin,

It was already posted to the mailing list:
https://patchwork.kernel.org/patch/9901353/

Thanks

--yV94raM4eJLN8srE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUGHUACgkQ5GN7iDZy
WKfK+hAAnPZ0sxCEW4qOZdNbAUcCaoGf9uAP8pI33FqDY6EnqbXnC0UID9WryHe6
H8vxBEwZNlDb8Gtvb4lVownthY61vpVu9o4xV7OJf/3Ey5MyD5x12S6x12BWkxRc
KvM3ZwKrbxqjBVTGdP9MJgC+0bjFd2HJE2e0h+kxUpeO+GqdYztm5Da92OIJY+KU
EMNMNF9PUV5eLPzKO9yTc9wutMwMI2crlKPKQPiXlO/jgPXZE4qOdpJdAK6Qn0Hm
o2vJhleFOZ/q943AgFdP9JVzzUQnQ/MVBK5QLrSjiQojG4DUUuYKXLD74Vn/jv2w
UnbZ91yHlhh3e3lG4jdAfsh2lqxPGIYA6euoQP3filrwLbXA5CFuaZp8NsTYr4fh
swb7d79d0deEmP9/mczEqLcjOriR8o7zWo9Kumdv22jjis87r5joKTPFqTY1mijr
DeyAyCANJhphhjR/Xevb2KkhA3plIvuvojNDmfqPntp3jrojHCy73pYo+im1blyO
01GhAvJrwAvZUPz2JPzdvP9RGhQzPEUCltcKAaVKi53eEiVPnMrKHQK7Y9YioWM+
L03cvMffyJZfplqVyVEFTXwV79LQtKHrcmf2l3oCtRpj755kLCz6pnSoNo0CYXRS
KrjQeHdMZ5pbORnU7v1iOKggPEHLZ5us7/h2w9YYrT6Y/zzA7LA=
=xU+e
-----END PGP SIGNATURE-----

--yV94raM4eJLN8srE--
