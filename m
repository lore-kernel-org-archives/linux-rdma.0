From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix mlx5_ib_map_mr_sg mr length
Date: Mon, 24 Apr 2017 15:20:35 +0000
Message-ID: <1493047235.3394.1.camel@sandisk.com>
References: <1492947102-3133-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492947102-3133-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <5A17096C57F93842B61721A1B8C009AB-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-04-23 at 14:31 +0300, Sagi Grimberg wrote:
> In case we got an initial sg_offset, we need to
> account for it in the mr length.
>=20
> Fixes: ff2ba9936591 ("IB/core: Add passing an offset into the SG to
> ib_map_mr_sg")
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index b8f9382a8b7d..d9c6c0ea750b 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1782,7 +1782,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>  		klms[i].va =3D cpu_to_be64(sg_dma_address(sg) + sg_offset);
>  		klms[i].bcount =3D cpu_to_be32(sg_dma_len(sg) - sg_offset);
>  		klms[i].key =3D cpu_to_be32(lkey);
> -		mr->ibmr.length +=3D sg_dma_len(sg);
> +		mr->ibmr.length +=3D sg_dma_len(sg) - sg_offset;
> =20
>  		sg_offset =3D 0;
>  	}

Hello Sagi,

Please add "Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" to this patch.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
