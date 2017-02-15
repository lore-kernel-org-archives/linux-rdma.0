From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/hfi1: use size_t for passing array length
Date: Wed, 15 Feb 2017 07:24:51 +0200
Message-ID: <20170215052451.GL6989@mtr-leonro.local>
References: <20170214212358.2730288-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170214212358.2730288-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <ira.weiny@intel.com>, Jubin John <jubin.john@intel.com>, Jianxin Xiong <jianxin.xiong@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 14, 2017 at 10:23:07PM +0100, Arnd Bergmann wrote:
> gcc-7 produces a mysterious warning about the size argument being potentially out
> of range:
>
> drivers/infiniband/hw/hfi1/verbs.c: In function 'init_cntr_names':
> drivers/infiniband/hw/hfi1/verbs.c:1644:2: error: 'memcpy': specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Werror=stringop-overflow=]
>
> This seems to refer to a the case where an 64-bit size_t gets truncated
> into a negative 'int' and subsequently turned into a high 64-bit number
> again.
>
> The fix is clearly to use size_t here, which matches the type that gets
> used for this value elsewhere.
>
> Fixes: b7481944b06e ("IB/hfi1: Show statistics counters under IB stats interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/hw/hfi1/verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlij5iMACgkQ5GN7iDZy
WKcInhAAuf/K+z5uJkqDPp47gnCdPjdPpcmVEw9psBqq4hB5XQqLxSE2BA3VtpYJ
UZkPk2Q0VyVp5j8m2AFdFA4vwXjo0a2JjrcoajXG0kCdn97s5Lmh+0UZQaCbiPto
MXvbZDa+vWn5YDd5gXezf5gfRlAccW+7LuD+f2IMz0GiEjS17inDeABD34qFiYyy
4qymoy4JA7mAG84UdsOuiQZmZKaWGx7bJv/lbq0uss+s2Gjtd97hArTKkdXOCnTV
k4fIMds7OQtUd8wY2gZb/gmE+xphpcwoI6ydpodFQAtLusoOTwX5rhKmIgy6JjPz
OB+BXCTIJ3wTc5EGqx/HzUZpqrv6VMCgphMzG0NCjFAeXOPz+WXRc7CJ8Gt8b+KZ
Z8bauXwC4cWmpdyKFrLFUaD2ilvRLVXDDa1Zq3eirGgiLV3qop4lH6eWsF96olp0
Rqa+JelgC/yJsgFmtRGI9jvN1iEDO1g0w7Q8Fpe+OMFamlz4hPQpisgQB7kcMdA3
IkACB52h8W2ETjH5r7NLFbq9aP/OvWk7opA6EiPTqS9CsrgoJqiM9C3+EhfG4B+W
Wm1iLwRoM8idRSrAOP7Sf+ITM4ZCZ83Sr2zIG9oks6jBJHl4BrdFm/3+xvquTDgQ
wTiMHofLUIBigDZxDj83q3U1PJWEYPTa7OdwE928ShNnnOxEJOM=
=K69E
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
