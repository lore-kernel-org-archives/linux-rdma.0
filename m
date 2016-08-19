From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 14/22] IB/mlx5: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:46:48 +0300
Message-ID: <20160819154648.GG18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <7d8b7737365694e925e50cef5d673aba0b9dbc04.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d8b7737365694e925e50cef5d673aba0b9dbc04.1471283717.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--+sHJum3is6Tsg7/J
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
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtynoAAoJEORje4g2clinQSgP/3b8Ee0ply2sUPvdMo/q2Klv
wooM2TdOJn+xeVvvalQtkk3g2EB+DOq0+evmZnOPEgF9Y9N3G+ORdyPdQBsmrJP2
EUG/T1CQDLdV1cuwc0NiyuIwf+RSgtE7g7zFqedX/m+me6Nth8DOYuz31BqQyW5P
qKCuizm4OQ8woWZZPUb4Lp3GuLPPK7m7iUqbrLml6g+rZH1MuGoKpJY//7PUaInU
C5134WtzPICfG0Vmhr4wrZgby0c8rbRjcANZhW5219f9Drz+XpI/joVJh0fF9FpR
sIR2C/4lUxoMGXDR63ou8XcQzR5V0rY1JRVL06WNILjEsW9cNr8Ubac37RbO+VGv
IeDACRmXyfFZ3mE3QTE1BCSRiZmeMEdi9c4Nd1WDQTPDdhVjeBWgVM/7ezfaPXHn
jUibuY26Ie87/DasYSl8+mcbe4A9ptL2vlmdSmqVIE9bn039UR3BeztIvK9G4WBu
XrxnAXQjipYTqynIZhg26Mf6h29gQbwPoTgvKHN9V/2j+ddD77TzGODZC0tIfVk4
rftaxdT7L6n2SGww34MRBe6s14ZcJlNTH8n/cnBrt796mH86GBMcCMgjBMMV5S6l
2HLdiVVvksmE8rH7sDu3qC6DQinJ2WC/CTwknEVqYM+UvIFLt3OdLD0+o0pzuFSm
ousB+MzV4RXugRAjUeI0
=pJUl
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
