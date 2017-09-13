From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] bnxt_re: Free up devices in module_exit path
Date: Wed, 13 Sep 2017 20:42:55 +0300
Message-ID: <20170913174255.GV3405@mtr-leonro.local>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
 <20170831035735.19595-5-somnath.kotur@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NqNl6FRZtoRUn5bW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170831035735.19595-5-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--NqNl6FRZtoRUn5bW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 31, 2017 at 09:27:31AM +0530, Somnath Kotur wrote:
> Clean up all devices added to the bnxt_re_dev_list in the
> module_exit entry point.
>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/bnxt_re/main.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index 82d1cbc..00a3b74 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -1375,6 +1375,22 @@ static int __init bnxt_re_mod_init(void)
>
>  static void __exit bnxt_re_mod_exit(void)
>  {
> +	struct bnxt_re_dev *rdev;
> +	LIST_HEAD(to_be_deleted);
> +
> +	mutex_lock(&bnxt_re_dev_lock);
> +	/* Free all adapter allocated resources */
> +	if (!list_empty(&bnxt_re_dev_list))

Hi Somnath,

How is it possible to have the bnxt_re_dev_list to be empty at this
stage? Doesn't the call to bnxt_re_mod_exit mean that at least one entry
exists?

Thanks

> +		list_splice_init(&bnxt_re_dev_list, &to_be_deleted);
> +	mutex_unlock(&bnxt_re_dev_lock);
> +
> +	list_for_each_entry(rdev, &to_be_deleted, list) {
> +		dev_info(rdev_to_dev(rdev), "Unregistering Device");
> +		bnxt_re_dev_stop(rdev);
> +		bnxt_re_ib_unreg(rdev, true);
> +		bnxt_re_remove_one(rdev);
> +		bnxt_re_dev_unreg(rdev);
> +	}
>  	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
>  	if (bnxt_re_wq)
>  		destroy_workqueue(bnxt_re_wq);
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NqNl6FRZtoRUn5bW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm5bh8ACgkQ5GN7iDZy
WKdDOA//UPlM8tmC7bA12W8Nd3kzOJNt6hlA/VcyhuR4H/WB+8nkKl/xcWxKWFxN
gck/yzzmzLPYUeLJvZsQ6OpoSbSu/T3K17KC6h6NskFfaD32O32Q0npUtZDlFwiB
innKn0DNKN6YCuLhfNlbuDxOGn2lg/bddd91uGFud1xINgaeQ5yMTgsv1ELr0g6N
FLdy5aYoOlyoQmJb4GPH1CxRX9XYorf1fgLfmGyb35Rgu+oVpxYrGybBD4dPlWzN
KNsz48Z3YdytsnyNRoBjOwClWqK1dTn+TyqwHDJJJOQoYOssfm4VNj6AxNH+VAxX
Qs7+n/6H6LbLVY7VrAvqFRYna0SjgJvSByP14+s9jL5OsGMFWKIVV3WzN2ewLk9X
x8KFM0R4qlXaW1tNOmydd2R9DR+kg4boEgcWCjH1nh4kTOv8mwpfJB8itpz26Gfs
jpVVsQ4TAuS4NLZe4WYIWWB3mtJDsJUcqQLd4OUKNJb7Esw52fFzNDPC+QTuB68C
TOA+ZG3dqiUoK3xg2lgMPNzPgSiQsU6vw3SNiiYtIpz3lvMT2XN9+bQ6YNBkR8a2
AAfn/cNCZh3NeZynVRIrXMkbNjbvXDPMawONiDqX/fS+pqSQWrfC+xDRHM3LMpPB
y/LP3+YK2RKmJy8S9STWFL3ufbnSU+phQh7QUrXJCMRDiJ1kXdw=
=BLRg
-----END PGP SIGNATURE-----

--NqNl6FRZtoRUn5bW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
