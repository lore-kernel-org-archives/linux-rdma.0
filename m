From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Remove duplicated include from
 eswitch.c
Date: Wed, 12 Dec 2018 17:10:42 +0200
Message-ID: <20181212151042.GE3933@mtr-leonro.mtl.com>
References: <1544601818-134205-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9AazSAFPVKSPmRXK"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544601818-134205-1-git-send-email-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--9AazSAFPVKSPmRXK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 12, 2018 at 08:03:38AM +0000, YueHaibing wrote:
> Remove duplicated include.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 -
>  1 file changed, 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--9AazSAFPVKSPmRXK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcESTyAAoJEORje4g2clinBBMP/2sB2wGTghrF69ldjECJOFQg
PjtG2varPBEqLzJIt/0tvAa7rMH5nHd9ji+yp8DWwh5WbAqhWibq70CKykqdrZnh
NQD6fDt58D796SWbCzQdjNYLb1ECJ+M3XWnriBAkF8JImYoFCVn/mkQ6L3sGb4lt
lcKCCpaF2uZQ0OQW23blvv1QX66cK6c8ErQzJOhvdkLepoOkKpubZANgALy/6snf
Ki2f/QmsmAqk0wvb0TE5YCyN34F/fsWTg8/ATdIc7bE+vq3pV6W+s1SV5cClDfct
GmbBmLOrBotNd/Ko+JwUvQuHhV+D2wBEFpwQPRglYnG/BAnJj8IC7N6ziTZw3C6e
hhR0iHwy2SsIDfPjwxG+Ys7uIT/PPP5g1OKzyy6IWWLZRXeW0dC/kfh/qIpMLX+S
cuP6+u/zqinm4rZyOSgosQ+4j651lb5dDZobn6iks7ZtarE86X4CLUiL3D/cjNxt
eeHGQaL3eGP+yHe3tVKN/RlpnyZz/Gq0RcbITtnrRPz2WlryEmKZFvUTm59ik1we
Ge5uyr0KRyHa1PrvfGy4UMZ83XynWOkyYNzoN5jkyFc/sj8r3nzm52ReD0Mwa53A
z5DkmHf4J3sZcjflYakRrD7+pA78ZIddMoAnPkqy64gZqg5yvIzaLpJuMuuRLTTR
b72EYcDWjOYNJvKpXgUy
=e8iq
-----END PGP SIGNATURE-----

--9AazSAFPVKSPmRXK--
