From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 7 Nov 2017 10:25:16 +0200
Message-ID: <20171107082516.GD18825@mtr-leonro.local>
References: <20171106143514.GA19786@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171106143514.GA19786-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 06, 2017 at 08:35:14AM -0600, Gustavo A. R. Silva wrote:
> Check on return value and goto label mbx_err are unnecessary.
>
> Addresses-Coverity-ID: 1268780
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> index f8c14c7..db02bbb 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
> @@ -1956,9 +1956,7 @@ int ocrdma_mbx_dealloc_lkey(struct ocrdma_dev *dev, int fr_mr, u32 lkey)
>  	cmd->lkey = lkey;
>  	cmd->rsvd_frmr = fr_mr ? 1 : 0;
>  	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
> -	if (status)
> -		goto mbx_err;
> -mbx_err:
> +

Can you please remove assignment from "int status = -ENOMEM"?
It produces warning too.

Thanks


>  	kfree(cmd);
>  	return status;
>  }
> --
> 2.7.4
>

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBbewACgkQ5GN7iDZy
WKcY4w/+N8NXZgjpoSB4bzY1BTOjJ3rpNUzN/uMPe9PR772hwF9V3jIoMZm5XTpF
hhrHgPjurC/7bX8kPGiFweMtE/jHqTPPx6nYZcGzek6OfdizyMV4NY8ZbzUIjBE3
GLJn3gc7rFF2ifDX+Ipl3uw9E+j0dDhcTrR9oiwnxefRjIP71eEgxRS1hCtFY/gk
QIlHunR/5WrMi0mWgJ3pbBVd1eMPvvAwturIomdfog81wrLgnxoG10kZYapJ/MYA
tAaumHYy0rPAYKFfi0UrNHoblJ47vSysDiLLEnIUYuQ1r27iTgx0ctU73JhmdFyu
YzO7QiXd6Xtum3SytTqJP8FsnvCcjVzGUqwp6qUnNjknpSbJfZztWT5IKUZY3vfU
MAqWz8klndpP+T7fbwidJP6AsBk9EOslehvNO53D1ej3Bl0OA1U2KyUFSN074BS0
p2wIVBhuuymT6iTSlw6K8hbw/rAMbGWy+/e0YPFNqfOv60hq3KfuinBLYceWKo2Y
MpZPjj272RNlWCUgW6YxJrqOA0Vw+E4D/IjWfmTo3Nt99B6qA8OTBQJ9xOLHLtcp
ObQhkItLPzZ4gfuP8ilfXFwf67PyiGh1mlR1aooqRYG4RiPhj3z4tsq/lWay05IQ
FXMGRaL2cwJZ9pKXt4BL95WiIOuK37P4q5pEAs5Af9Nb65ph114=
=3+We
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
