From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
Date: Thu, 1 Nov 2018 09:34:12 +0200
Message-ID: <20181101073412.GQ3974@mtr-leonro.mtl.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="apbmkPN6Hu/1dI3g"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--apbmkPN6Hu/1dI3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 01, 2018 at 12:24:08AM -0700, Joe Perches wrote:
> The line continuations unintentionally add whitespace so
> instead use coalesced formats to remove the whitespace.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> v2: Remove excess space after %u
>
>  drivers/net/ethernet/mellanox/mlx5/core/rl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--apbmkPN6Hu/1dI3g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb2qx0AAoJEORje4g2clinWpkP/09XlGPvkyX6zrG6u4zHwDu6
dTQu4lQ7xkqVyul/QumZRgGv/9EI78I9NyUlnRZjeA9gZSLkoexxinEF5VZirtOo
5r3/d7GeCZLBYc9NXN2lJvVO1C3oT0w/+995qAhCqhEBBFVqB6bKyJhiMf4B+ets
dQnvU0PQN1q0Uwhm8q9fjURUr2erA9B6QdeXlI2+wE6J5BZ57IkTLFUl70Xuudgn
kENJWj06f2WmUR2JZz2ocwROE3eqPzVIEWxe8FYuwFnzu4WTeA6A5BCxuFrzsQtc
mUWf4P7dRVHtf76lX6khdq9aqw4GykKnaKTX33qjZJ++vVOZHHyj4ozcJlva9xIQ
W/6yfqXbJllBMs1FRIPvCnq3kYuEPDL+KGqyFOkucueabYrqAXJyiTy2R67TW1AZ
a1oeVmsFxuJGsqtFi6/IuSeAvaPO2vjXacp+A7DtgMj1+6IiNF+fyc5U582lw8hb
Q2no9s5VgrUaXT6pmgyQtyEe+NOPgVxlKThDHOf3oye8XG+8g5IGTmezeBrqm8Ll
7JWO6BnnUqvzid05uKQ8zCSA0LDyDj/UixsxRSA3+fOE9kfZOIGNvDTnhysJOjJj
ZEEQa8kHtjNgkR8e2EAs89M9Q7AO6hOcl39RapzVfP1lp3I9rNYSt5S7Qz2FAREp
2kmbOfzeC9P/5U9SUtxA
=j94Z
-----END PGP SIGNATURE-----

--apbmkPN6Hu/1dI3g--
