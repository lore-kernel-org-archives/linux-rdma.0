From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms()
 overflows the klms[] array
Date: Mon, 24 Apr 2017 18:39:33 -0400 (EDT)
Message-ID: <1726285260.1422143.1493073573791.JavaMail.zimbra@redhat.com>
References: <8992bd28-667f-94b1-e582-106e6b41aa4b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8992bd28-667f-94b1-e582-106e6b41aa4b-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Max Gurtovoy" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Leon Romanovsky" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
> "Israel Rukshin" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, April 24, 2017 6:15:28 PM
> Subject: [PATCH, untested] mlx5: Avoid that mlx5_ib_sg_to_klms() overflows the klms[] array
> 
> ib_map_mr_sg() can pass an SG-list to .map_mr_sg() that is larger
> than what fits into a single MR. .map_mr_sg() must not attempt to
> map more SG-list elements than what fits into a single MR.
> Hence make sure that mlx5_ib_sg_to_klms() does not write outside
> the MR klms[] array.
> 
> Fixes: b005d3164713 ("mlx5: Add arbitrary sg list support")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mr.c
> b/drivers/infiniband/hw/mlx5/mr.c
> index d9c6c0ea750b..99beacfc4716 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1777,7 +1777,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>  	mr->ndescs = sg_nents;
>  
>  	for_each_sg(sgl, sg, sg_nents, i) {
> -		if (unlikely(i > mr->max_descs))
> +		if (unlikely(i >= mr->max_descs))
>  			break;
>  		klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
>  		klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
> --
> 2.12.2
> 
> 

Thanks Bart as always.
Will get this tested this week,

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
