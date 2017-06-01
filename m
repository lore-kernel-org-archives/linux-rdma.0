From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Thu, 1 Jun 2017 08:12:20 +0300
Message-ID: <20170601051220.GO5406@mtr-leonro.local>
References: <1496281714-3035-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i7KxW38SoMauyveo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496281714-3035-1-git-send-email-baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--i7KxW38SoMauyveo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 01, 2017 at 09:48:34AM +0800, Jia-Ju Bai wrote:
> The driver may sleep under a spin lock, and the function call path is:
> post_one_send (acquire the lock by spin_lock_irqsave)
>   init_send_wqe
>     copy_from_user --> may sleep
>
> To fix it, the lock is released before copy_from_user, and the lock is
> acquired again after this function.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 83d709e..6fb7e1a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -725,7 +725,7 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
>  {
>  	int num_sge = ibwr->num_sge;
>  	struct ib_sge *sge;
> -	int i;
> +	int i, err;
>  	u8 *p;
>
>  	init_send_wr(qp, &wqe->wr, ibwr);
> @@ -740,8 +740,11 @@ static int init_send_wqe(struct rxe_qp *qp, struct ib_send_wr *ibwr,
>
>  		sge = ibwr->sg_list;
>  		for (i = 0; i < num_sge; i++, sge++) {
> -			if (qp->is_user && copy_from_user(p, (__user void *)
> -					    (uintptr_t)sge->addr, sge->length))
> +			spin_unlock_irq(&qp->sq.sq_lock);

In original spin_lock, the flags of irq were saved, hence it should be
restored here too, but it is unclear to me if spin_lock is needed here
and it can't be converted to mutex_lock.

> +			err = copy_from_user(p, (__user void *)
> +					    (uintptr_t)sge->addr, sge->length);
> +			spin_lock_irq(&qp->sq.sq_lock);
> +			if (qp->is_user && err)
>  				return -EFAULT;
>
>  			else if (!qp->is_user)
> --
> 1.7.9.5
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i7KxW38SoMauyveo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkvojQACgkQ5GN7iDZy
WKcx1RAAhfYGLKndoL1F5Zr5p/zLjD4D48IQOQRVfiR4EcttgxTovtWktw1Rk6D5
5qENjpIeps7MUfSj9/ZqBFRcA70T4SjXJGKfrY9JD5ijFD3U4aoN5vAs1HlTPvsV
jIZRfyHDuTCZM91fjVAPY4SAiQXsAoBkUBUwmQXOfUsnev9Uf2fOCZ6ohlcZcJT2
nUXDchE4ZOTHh1l0qQCHrZVjnQsjvHj7b0nZK5dkK/G2To74hqFw9T3dTBeemhni
xRjQVw4FDDh6uDl1la6ho/APIR8ccHMh+lsZBEOtr1PNzlefQiUMrSn3Q3IvwDyz
KdH5Rzp8wWvJpn9XiWvNUqmE6p5BmFi1tWiRSxdZR4PzVZKlErqSByK80BEDU4Id
ueH5qjYf0sFwcVLcqvQmwG8FXgUvOKe97ojcXDoaF/aHy4E18GgdumS6H6LZ2fwy
8G2+dDkZTcwi8LxmLHYX6Wxv8Kbxr4rtlxMnRS3z0sHxRl9obJ495InGT4SyzAUC
Dz0CUk0jFWPuLwAyYNJxJmlYAVbJWUnmQ1TUqsLeQqvt8Djiw0n6UgDP/J4eJtFk
i6jhVSJp5BCAJESrrueK8wnP88Cb3N5eFLgpKQGZui5cNgZ9EUITe6Q4Q62rL07U
ALAF7QXPKgQyQMY9Z5oSf6sR7x5GiXeHGxmXSfa6afqJhGQvQkM=
=hMmB
-----END PGP SIGNATURE-----

--i7KxW38SoMauyveo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
