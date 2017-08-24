From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/qedr: fix spelling mistake: "invlaid" -> "invalid"
Date: Thu, 24 Aug 2017 12:24:08 +0300
Message-ID: <20170824092408.GG1724@mtr-leonro.local>
References: <20170824082553.18619-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f3uHgXesLFB1/u0Z"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824082553.18619-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Ram Amrani <Ram.Amrani@cavium.com>, Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--f3uHgXesLFB1/u0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 09:25:53AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in DP_ERR error message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--f3uHgXesLFB1/u0Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmemzgACgkQ5GN7iDZy
WKfV6BAAxkn2o/yOwzJIYf5D1Wp7J5x9FkkYrtGzO6IU+7lbpXyewb28z4axeVba
jHtrAt001WOWvtTJ8O821f/bwpD/7UNuTdLGzpOhuY+GVdy9/BAQHWX/w9GZrRMz
doxNy6wb3sr4TzPd26ignOO+aFmH0hPjRhV8TTjrTzM8orkt1qlOTsZAe5m1CjAD
Hi99b4arnc50F4iQga0n6BjWi6oPPp7vdVctNdLJVSEr95c+l7C1PL2vRqege7jI
PQl/C7gfFz3Mo8tNrxd14b1WlLTUFHUz/+GuCvGV9kj28lRMQDOVIK3rjh8MBKzH
b7lHLs3IpwvrgRmgoAhczq3rY2G1Pmg00uX7s3fTBBCdDsWO5elnqDifFqh4DUWn
0cUWTIl7Jl5P7rQVQeJeQDWredG5rlgaKe811uwIN2PdYmbsRaoRM/7eyTba9sst
5V5tPp2O8QyESfRQkM9887A/Xhy7oSfoM0xn7Cd7PL72CEfFxo/hwS1nhZUMSaR0
BkhWkdTBpx2zy4NgurwVztvkYfmyzhgaBf4JtFWCABP4azwecR9hlWmArA/9TFmX
paneus57tGZSNxAe9eX2q9Xr9OASinOTLYcCS/hNAkrPl0KSWHf8NAyTHVz6lMqZ
yN+crO80XXdjDzra687S9CoYYZLkCnamkSU405u90jF11f/Zm28=
=LGgO
-----END PGP SIGNATURE-----

--f3uHgXesLFB1/u0Z--
