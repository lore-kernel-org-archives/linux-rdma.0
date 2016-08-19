From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 18/22] IB/mlx4/mcg: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:50:55 +0300
Message-ID: <20160819155055.GK18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <4045f5014733b227e085c76f00f9ecf7f6266803.1471283718.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1y1tiN5hVw5cPBDe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4045f5014733b227e085c76f00f9ecf7f6266803.1471283718.git.bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--1y1tiN5hVw5cPBDe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:43:35PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "mcg_wq" queues work items &group->work
> and &group->timeout_work.
>=20
> The workqueue "clean_wq" queues work item mcg_clean_task.
>=20
> Both have been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>  drivers/infiniband/hw/mlx4/mcg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx=
4/mcg.c
> index 8f7ad07..7d30be0 100644
> --- a/drivers/infiniband/hw/mlx4/mcg.c
> +++ b/drivers/infiniband/hw/mlx4/mcg.c
> @@ -1045,7 +1045,7 @@ int mlx4_ib_mcg_port_init(struct mlx4_ib_demux_ctx =
*ctx)
>=20
>  	atomic_set(&ctx->tid, 0);
>  	sprintf(name, "mlx4_ib_mcg%d", ctx->port);
> -	ctx->mcg_wq =3D create_singlethread_workqueue(name);
> +	ctx->mcg_wq =3D alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
>  	if (!ctx->mcg_wq)
>  		return -ENOMEM;
>=20
> @@ -1246,7 +1246,7 @@ void clean_vf_mcast(struct mlx4_ib_demux_ctx *ctx, =
int slave)
>=20
>  int mlx4_ib_mcg_init(void)
>  {
> -	clean_wq =3D create_singlethread_workqueue("mlx4_ib_mcg");
> +	clean_wq =3D alloc_ordered_workqueue("mlx4_ib_mcg", WQ_MEM_RECLAIM);
>  	if (!clean_wq)
>  		return -ENOMEM;
>=20
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1y1tiN5hVw5cPBDe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyrfAAoJEORje4g2clinIeYP/3gd8EvnRHYhFBfnIU82uMZw
4yn/yo2MVyK7ALEo+Es30wbao4NkPyWj/SZhoBm1tc7A2uusqLhJ2suQjQ8hAUCM
iN68nNt9RPsZgv5GODDO1w4z0mhB6g+plPb2GtxTBJfr+gCKm6lR5CPmKe+f+Bzk
bF7aRuAGiV+GwaIFCB4HCALgoUdD1DBXNgw6f/Uh8FO8Tzz5kRrJcRQ3sgMauoK5
SMWyoLR06mMU6zvOyhg/cXieQdlwaeUW2A+78+rpFNjg/Ibgu+jbzaF4UbMTPvpg
73NTxp1N+owNHH4ieO8YU8IHGa12f9P84/Aq32vF7iDhDbnhVqbSPuxH0wwVToSZ
Tdd6zIF+91fDQ9mde4Pjp0Zg2hGvwQm5i+PhmWFTN++QCeFSgQeJnRSFH/ULA1XI
Tdjs9qiKOtgfpKbclyhQQ1SPfHAcdD3XdxhRELhRkZnr9l5AOijktmHKECM8TwdL
UzVQVpvoHSagOdbZ2l/kdpPrOWS3ux2Pt47WSVB9m9+u0UeJHmZjSkkZgexVc1YN
z0HP9xb4eHRWOudjtmWoptnK8ur5juyRrm7Vos0KezTUTCnlJag1WfAT0TC/ERkc
1j94YmtMvqiErarGDGvkdqyLQ+wBww56XfOmP7w1ItrxGtCw7wBs1QMS0Lr1s33V
aKeSXNO6zEWczerJUuPg
=K5FG
-----END PGP SIGNATURE-----

--1y1tiN5hVw5cPBDe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
