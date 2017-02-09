From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/14] RDMA/cxgb4: Delete an unnecessary variable
 initialisation in create_qp()
Date: Thu, 9 Feb 2017 11:02:23 +0200
Message-ID: <20170209090223.GM6005@mtr-leonro.local>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
 <b319a50e-9e2a-61c0-5707-b4549b077d6a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mUkVHLrPAbedpyr7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b319a50e-9e2a-61c0-5707-b4549b077d6a-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mUkVHLrPAbedpyr7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2017 at 10:22:28PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> Date: Wed, 8 Feb 2017 21:07:07 +0100
>
> The local variable "ret" will be set to an appropriate value a bit later.
> Thus omit the explicit initialisation at the beginning in this function.
>
> Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 373d66a511a8..ac63b1f70731 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -202,7 +202,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>  	int wr_len;
>  	struct c4iw_wr_wait wr_wait;
>  	struct sk_buff *skb;
> -	int ret = 0;
> +	int ret;

The more clean approach will be to initialize this variable to -ENOMEM
and remove rest "ret = -ENOMEM" from the function.

>  	int eqsize;
>
>  	wq->sq.qid = c4iw_get_qpid(rdev, uctx);
> --
> 2.11.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mUkVHLrPAbedpyr7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlicMB0ACgkQ5GN7iDZy
WKdC2w//TkD7Y7i9Zwj31zNfkyBr6PUPd61P2/QTaXGzPtIyIP/VplgjUqQ0yX2s
g2hZkQt5aJL0Sm4hM7DPXjg0I3srbRpJVAKQLW3UFIoGNbv/cchGr42as6iJTTWa
386URqZqDiybHJI+vFFEPjiDmdpTX8LIsV7qauuNulHCHep5zC2AsoEbQkhb1NBy
/a1M9IjSZXbOMLgZsyd2dwwcrL+UMb3gcSa0Zns35hMWnH6MsVJbGsp1nDrQdqQQ
m4spCVqvZMaCQzT04eOAk67G8phdLL3C0XB7LPE7Do6Sacr/bHRyMbHjw8iD1GC0
7eIYRBqUm5r3gLxpBTCdQFF010ivYRU8rZmynW5mm3yC++HLw81LCjja0tF4Z3Mn
s9lwuEVIGe3IjL4aq0KQ5A3AN9hCg5F2+V/OCW6JleO1DXo0XWk2KX7xM4LJ2nIe
yiYBCOkwm6stIg/zLR9MEXoS5YwuojlwIhDd4hCF5bvIf2Ou/ONBKvRvn2dnz6pq
cVPPyBLT6QLP7wWj43F2MAfnP3zIHPag4NuU28JxrTeko87NZ/NaimDAFehhCFt5
TLvVjNRv71DytejOqsnn8OURHzZ0qjz313L0VpJ5a6tJB+ZzJbgpYgrGpHCPGn5z
65kBk+/aPZ2eqxuabwWLMPxW7dkfB+q4jhfx/muTUuO+d9zKe/Q=
=cArn
-----END PGP SIGNATURE-----

--mUkVHLrPAbedpyr7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
