From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 08/14] RDMA/mlx4: Avoid potential derefence warning
Date: Mon, 31 Jul 2017 19:21:33 +0300
Message-ID: <20170731162133.GB13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UEW5kU42M6+IO/TD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731070924.7193-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UEW5kU42M6+IO/TD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 10:09:18AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The smatch complains about possible dereference, it is unclear from
> source how it can occur, since in case of failure to find/allocate
> group, the acquire_group() will return error.
>
> Avoid the following error, by changing IS_ERR() to be IS_ERR_OR_NULL().
>
> drivers/infiniband/hw/mlx4/mcg.c:964 mlx4_ib_mcg_multiplex_handler() error:
> 	potential null dereference 'group'.  (acquire_group returns null)
>
> Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV")
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/mcg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Hi Dan,

Bart [1] and me both believe that smatch tool is incorrectly reported error.
Do you think that the tool should be fixed?

Thanks

[1] http://marc.info/?l=linux-rdma&m=150151394813006&w=2

> diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
> index b73f89700ef9..9c26a6837c62 100644
> --- a/drivers/infiniband/hw/mlx4/mcg.c
> +++ b/drivers/infiniband/hw/mlx4/mcg.c
> @@ -956,7 +956,7 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
>  		mutex_lock(&ctx->mcg_table_lock);
>  		group = acquire_group(ctx, &rec->mgid, may_create, GFP_KERNEL);
>  		mutex_unlock(&ctx->mcg_table_lock);
> -		if (IS_ERR(group)) {
> +		if (IS_ERR_OR_NULL(group)) {
>  			kfree(req);
>  			return PTR_ERR(group);
>  		}
> --
> 2.13.3
>

--UEW5kU42M6+IO/TD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/WQ0ACgkQ5GN7iDZy
WKdEAhAAnNmgSFfhpuo/876U+6+RfMIQmf9WjGZgsyVa5qpf7cYQxYNuQmWbtS0x
9t7JEvCNYj9tKBiqfX9+VqpuKIx/NsHMSAi27vpJkN46lhHwORtrBr8J9K4llFuh
oFVHvRCFnDM2vAjeTzRC1TKFLVIhaugiz89hybIMMBqsXdr3RTCqRHzDrNb1aEA7
OXXgCOuwY1nQNOSBS0cxRp2lfgmHpC2SkZfJjSV1QT0Iz+9toskVCAChgY/3PwYa
LF1HDnjlHIiDKczj2jHbvzChQizY1gZV9T13m29cAIAkUQ9Zv9SBLIO8GLQ6Rm9+
Nl/stCmop4TFPkAj0UxShMD16xdM8ENQv7qf+wqqgoYmAqPhzCNU6mpY828T0A9L
r2hADKnnrk/ZDQI9f/FvTr00lyyKDUByIffalP8PeBF66KwDHzbbhxNnUJb4DyaA
F/Nl5STJXH6QuQog3QQf7xRhSc5aLJneGWuNud/Ucb7j70vcGXgZfD9Zwe2XeBIK
/T7BHDUVjtbnzRkk56pTzm0pnX4XdUbo654+ytIHnQfm+qDn0bYKKXp/BKGvOKk1
kjqMadleB+dnPmUnuphK5hDY03Z9SY7nFJMlLbr1FUBNheFDv2+yJdyjdCRdgoWd
6AFkS9b+FW4HLW+o56oJ5riHmJlJ2my5aP/OWRrVNv0kRXfTpCo=
=rfM/
-----END PGP SIGNATURE-----

--UEW5kU42M6+IO/TD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
