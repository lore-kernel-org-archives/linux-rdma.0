From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 15/22] IB/mlx5/odp: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:49:20 +0300
Message-ID: <20160819154920.GI18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <fdc8a637db52a5ea829309bf52afec7e1825bafd.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fdc8a637db52a5ea829309bf52afec7e1825bafd.1471283717.git.bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:42:19PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "mlx5_ib_page_fault_wq" queues work item &qp_pfault->work.
> It has been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/hw/mlx5/odp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx=
5/odp.c
> index 34e79e7..cacb631 100644
> --- a/drivers/infiniband/hw/mlx5/odp.c
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -782,8 +782,8 @@ void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)
>=20
>  int __init mlx5_ib_odp_init(void)
>  {
> -	mlx5_ib_page_fault_wq =3D
> -		create_singlethread_workqueue("mlx5_ib_page_faults");
> +	mlx5_ib_page_fault_wq =3D alloc_ordered_workqueue("mlx5_ib_page_faults",
> +							WQ_MEM_RECLAIM);
>  	if (!mlx5_ib_page_fault_wq)
>  		return -ENOMEM;
>=20
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyqAAAoJEORje4g2clinSN8QAKqAlquONXjrm3/9qsBKKyth
eUs0PnKOK6v8C22mqSBMZeOoE9xbXh/9W7OLPnstTlvUVQZeMa2KNwf97MDFt0tm
nLi8xje8d/+Olp0UOMnsWHdc0caaZveiR0MuCqYMaUG9ZMkSi9LLcR2lrtloNRoD
pa7vvbvVGEeIzdApWlKliUCnxyJEjDxIdCc2H7/TiO8bQXH1Xm7fwCdCt1MNeYPK
/4lqBKe3VQi3siZ2G3mS3Dl6dAjllyi4FUUuYtaDjUe/W7kQIhTjZL7cOiNrR6Mb
Ki3lxBCLxVW/om0ESaqIO2WONYLz3P6rEQUSEHrhFhnNg4Aixul6r6SCIkzGVyBd
SYsoYecoOVlQcXw1sBauSS268Z8iHPcrnV38bdmO6PW9duN0HO9tzqCAt/lnIipK
H0XhjdmBqQ5MTS1E5Ssjbv6D3UF51vuaK0c987vqInxZPLS8Fxl+aOtqMuUjEbN/
wvuDmetKJl0QsMUh4grhVo+dGgsyM1IhWkBLA5dOXOQekjILmT+ahggutwhUKSKs
Aqw0LJZRrWSCsYALnie4UfrsNBSCjjodV0UjJU574fq0yMcVjYzlmaN/Eu+m9jwV
WTUiEi4yBEzQVJGcKnC33OaEnHexijwgwcmXXZvrrTIZI+NmPNps1U/nRTousf11
A/4CwvJwJIYLgLg7Yrjj
=dwtX
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
