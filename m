From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon, 5 Jun 2017 13:12:49 +0300
Message-ID: <20170605101249.GK6868@mtr-leonro.local>
References: <1496655588-5598-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zqjkMoGlbUJ91oFe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496655588-5598-1-git-send-email-baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--zqjkMoGlbUJ91oFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 05, 2017 at 05:39:48PM +0800, Jia-Ju Bai wrote:
> The driver may sleep under a spin lock, and the function call path is:
> post_one_send (acquire the lock by spin_lock_irqsave)
>   init_send_wqe
>     copy_from_user --> may sleep
>
> There is no flow that makes "qp->is_user" true, and copy_from_user may
> cause bug when a non-user pointer is used. So, the line of copy_from_user
> is removed.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
> ---
> V4:
> * Remove the line of copy_from_user.
>
> V3:
> * It corrects the mistakes of remaining legacy code in V2.
>   (Thank Ram for pointing it out)
>
> V2:
> * The parameter "flags" is added to restore and save the irq status.
>   Thank Leon for good advice.
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 83d709e..7c52c7c 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -740,11 +740,7 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
>
>  		sge = ibwr->sg_list;
>  		for (i = 0; i < num_sge; i++, sge++) {
> -			if (qp->is_user && copy_from_user(p, (__user void *)
> -					    (uintptr_t)sge->addr, sge->length))
> -				return -EFAULT;
> -
> -			else if (!qp->is_user)
> +			if (!qp->is_user)

According to the Moni's previous responses the line above is always true.

>  				memcpy(p, (void *)(uintptr_t)sge->addr,
>  				       sge->length);
>
> --
> 1.7.9.5
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--zqjkMoGlbUJ91oFe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk1LqEACgkQ5GN7iDZy
WKeN3BAAxtIr6JDfut2Qtkb8jcWNMyIQx+QyOaUGTw3PujcYdjw5m/IsGUt3HOao
cx3myqOrbreR/2L3Ghew3/L/SsXPUdrBjGNYZdp0jCkfh2vcQ19f9+6igaOZk0i6
p8Jm4SWWgxvLiy5klqMjfw7ny3yj9HUc+4qIXvRIaCUIABDIjPIWFdEDI7NZ5yvH
6n/ZWKBr7riwDG59dteGB4flIcVG/xrMuf4zln/n9d6yWsCk1vnjefmeiUcwygJV
rJeRmNHBb7gHbSlXlCPsLa9jZE4ylfrQaWLObPh5LRitbW0Q9k9xdavsnSRBzpGm
K3zgKReBihbDEBtDdk1U9pIUb1HuAWNFt7/Lsdrs7smvhWhYMR8JyBE7cQXTPuhZ
sJdfML8vzXWDfw/YvKkcGAdLE9AZB0mHlCtxQ6tpigyS5RbTFua/iEO9kMGEFhTi
vMigmBVNDACD6mXcTbLpWreDImqH2DpnO4wO0Ejx7k++xre2VbauWweEO1GFk+Zm
avT/36Q3RvYDYOP2r8PQ5bxHEV8BYn48oSq2flLYxyswzupzzeCcg+11HBaM6lrr
DoS+slVL6gUl+dtnFYdcl4ZkXO2GVNcQVXrRDdMRPEE0GxLmcjtmTbMkRvxFvlUQ
QGByhllvmRh/wHRBhODg07BdYbKtMA6etOF0zD2nphsnCtk+2kU=
=3VLz
-----END PGP SIGNATURE-----

--zqjkMoGlbUJ91oFe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
