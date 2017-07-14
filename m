From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 11/14] IB/uverbs: fix gcc-7 type warning
Date: Fri, 14 Jul 2017 12:46:31 +0300
Message-ID: <20170714094631.GX1528@mtr-leonro.local>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714093129.1366900-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ee0603b/+xKyHz99"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714093129.1366900-2-arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org, linux-media@vger.kernel.org, akpm@linux-foundation.org, dri-devel@lists.freedesktop.org, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Ee0603b/+xKyHz99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 14, 2017 at 11:31:04AM +0200, Arnd Bergmann wrote:
> When using ccache, we get a harmless warning about the fact that
> we use the result of a multiplication as a condition:
>
> drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
> drivers/infiniband/core/uverbs_main.c:787:40: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:787:117: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:790:50: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/infiniband/core/uverbs_main.c:790:151: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
>
> This changes the macro to explicitly check the number for a positive
> length, which avoids the warning.
>
> Fixes: a96e4e2ffe43 ("IB/uverbs: New macro to set pointers to NULL if length is 0 in INIT_UDATA()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/core/uverbs.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--Ee0603b/+xKyHz99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllokvcACgkQ5GN7iDZy
WKdunw/+LLcL3bFxt6Jb1Xg/2r0CxgcYf5oO8ehOVaPYHBnLsI3zheWbrOARxAQO
+ACWy3W/t6cjKTgdme2GsPpFxUk/vhEDa6d0r0YwVomStSnA6QCKgn1SZpbnszZ4
LrMB+2HK34GA835xlJkVYgYV8sG1Ncbbv7OuvojsfFqBonOJ5deob4LWdP5IHoxG
uHZthMD3MlF2aail5faoUm0CyocXPvnB3oR1Wop74xrcAeiRghRICtRgXICKNKl0
3CKpneP+7MtoCpDemKwhjWeiH0FGseP44L1183zrVU5u61R4YV6Lixx/t2lz2Imw
kuMAONs3QbP+xxcvK99wqX0JTKrFqbTD7eVYNQEt9kZI/eviAvHkq51iRkZ0nA+b
h46iuvs//jshbPn9gLT1rUFNOiXfoUss+hNzeN1jAW07h+zNTdvQprKdqcKAxxKM
sDsKX3MQfbc4yKSdP9cVG4N+b8P/QZP3Imq6k5UQltrXsnwNi+twVUVVWV14nJbl
cIgC8PP/DRJziklsZzqTQuxXuBjvrQkZB0zYyw0iQTpDEm+zfhnsr+PKe43p4M51
DO2f8rKzqauj6/bsb8IwicjTbXnvdlSDwejl8HvsiihDuD9fMOEmPAMa19/lhCH5
4Emn+YSH7F05w1VwSrs7gLynvQLycuz7PnFD+xBWNWBZ7iuxlow=
=79Js
-----END PGP SIGNATURE-----

--Ee0603b/+xKyHz99--
