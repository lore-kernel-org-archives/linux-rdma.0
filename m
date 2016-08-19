From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 17/22] IB/mlx4/mad: Remove deprecated
 create_singlethread_workqueue
Date: Fri, 19 Aug 2016 18:50:25 +0300
Message-ID: <20160819155025.GJ18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
 <18c4505e94d23ab7a34c2aaa9c4ee9f7ace09cef.1471283718.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="F4+N/OgRSdC8YnqX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <18c4505e94d23ab7a34c2aaa9c4ee9f7ace09cef.1471283718.git.bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--F4+N/OgRSdC8YnqX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:43:10PM +0530, Bhaktipriya Shridhar wrote:
> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
>=20
> The workqueue "wq" queues work item &ctx->work and the workqueue "ud_wq"
> queues work item &dm[i]->work.
>=20
> Both the workqueues have been identity converted.
>=20
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
>=20
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
>  drivers/infiniband/hw/mlx4/mad.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx=
4/mad.c
> index 9c2e53d..35b1260 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -2070,7 +2070,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_d=
ev *dev,
>  	}
>=20
>  	snprintf(name, sizeof name, "mlx4_ibt%d", port);
> -	ctx->wq =3D create_singlethread_workqueue(name);
> +	ctx->wq =3D alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
>  	if (!ctx->wq) {
>  		pr_err("Failed to create tunnelling WQ for port %d\n", port);
>  		ret =3D -ENOMEM;
> @@ -2078,7 +2078,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_d=
ev *dev,
>  	}
>=20
>  	snprintf(name, sizeof name, "mlx4_ibud%d", port);
> -	ctx->ud_wq =3D create_singlethread_workqueue(name);
> +	ctx->ud_wq =3D alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
>  	if (!ctx->ud_wq) {
>  		pr_err("Failed to create up/down WQ for port %d\n", port);
>  		ret =3D -ENOMEM;
> --
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--F4+N/OgRSdC8YnqX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyrBAAoJEORje4g2clinRPMQAJHnfhtOtCmVK27/B/jgRQ5H
eXF7BwI/Z2qf4yF0ibrUDwx8itzrr9TQp0iA7Zmf9bFd82cuS4MkBH1JY8lbPKXg
N/neww+r3KfjnqdCIHJGNaBh8DvWOSNJyUw4l9q/7n6fqNdAcuvIBz2gw6N+aiyX
ZQznzVGC/waX7ZlkNtEit/15iRbYmQzwJ4am75iDv4UYcEnV+tCnZae3haFjXwr/
93ZFu38mhnJ2n+iFzPuHIqEYmoGRck+bYnisAcV00g9c1FsaXCLniO21fwTCPR0v
WWQbA9ZJRwc2LgEdt37K+QvCB5+fhk6+iDMZF8Unh4YlX2ejP9qT1t9SgdC7Q7ON
0d9z8JmXuk6vN5XIeSWtHvVqIkU9FSR7b0nLdzxV4NbOLHycVT7na3pt3Gz3UT+9
6EDVTmxXCrjgnhtjy+udec+eseRpx2azOOq0eNSnQ2P3cRVF/gTpD2uMUzYdDsfn
5c/zQZlI0iKEjXk1b2OMHj3bW8Is20hgGZK97LnkY10CGJ6QxRlAGlhfqO4EWtSd
+Kc4UHmlMFXgCuNrV9ZbnelD2L42+DYuvDMEssaLBkfTRc8C4e1mdeBIcHQL/jbr
8zsWMKhF4H4h0u2l+YuYl13c17Rv892JHXJsBuIPaghw0gX68OvaSqj3goIwA9eF
CvS9yLl5as6hmR/4yi4t
=IAQW
-----END PGP SIGNATURE-----

--F4+N/OgRSdC8YnqX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
