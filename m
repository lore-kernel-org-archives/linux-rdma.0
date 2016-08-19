From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 14/22] IB/mlx5: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:44:18 +0300
Message-ID: <20160819154418.GE18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <7d8b7737365694e925e50cef5d673aba0b9dbc04.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7d8b7737365694e925e50cef5d673aba0b9dbc04.1471283717.git.bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:41:18PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "cache->wq" queues work items &ent->work (maps to
> cache_work_func) and &ent->dwork(maps to delayed_cache_work_func).
> It has been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>=20
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index 8cf2ce5..fb0194d 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -614,7 +614,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
>  	int err;
>  	int i;
>=20
> -	cache->wq =3D create_singlethread_workqueue("mkey_cache");
> +	cache->wq =3D alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
>  	if (!cache->wq) {
>  		mlx5_ib_warn(dev, "failed to create work queue\n");
>  		return -ENOMEM;
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtylSAAoJEORje4g2clinUegP/iiBWg3qUL+B3sl/+rUAAPtV
mCMH3ROPIqlUbxCWK5sRHmAsrJiVC51oE/zAonvac9siCb3f9tEYpmYmrczXmVK/
nrlI0SfbJ+ocHwjkKfxrqfDzwqxo0+8Gq5ACD65PZ8OcyO0IAC3Mk6Ko8JgdSqEu
pdyIFN7loq8uR+dvGGav2bjzW2GFnFH/17pRskc+DJb9XQ5mE/lp2U5nieQZMeCb
In1WweKMRv3a3RwPeHFkLtR6MPLwcbnGypp1OeYfexSPHvBd0v9VG6iR7nf2v6Qb
SIsplduONdxJb9D+vb0iGQxJtlWGO8TZZ28JC+7CNAxs85i2yyffsRp0oSpbUNg8
nJ58upIca2hkSIRb6WdQjIVEcp7ew8O1kO7qMfsQWQI9W+Kmn+ljH3Lw3jSDowSj
LOGP23bSiOG/cOatYD57ele4QizRNbK7eTYFHK9Ui0AiYaC2H5/a3IEYNm1513tr
jBY3y6E+CV0ttaOzQsDWeg5FfHknRU5D8fRpe6Xi1adH12zBonaBQ2/Aq1bN02OO
uLYALX10WN/jYCFbZqYe0EzA1/iIeLvuUPPhF5/SB0NW+UkfGckjKP5TVSryK+NY
K62V8kb/ePgzCCRNtXiNx3nMgWSz+mHslEBTFJwW27DR6/GyvRMJtRaDUyjAicuo
uLa4Eu+3HGW0XEo/vdg6
=nR6z
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
