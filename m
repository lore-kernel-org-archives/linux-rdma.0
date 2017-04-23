From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix mlx5_ib_map_mr_sg mr length
Date: Sun, 23 Apr 2017 16:51:24 +0300
Message-ID: <9db143b2-1bc5-89df-fa7a-ccc6e160cc4a@mellanox.com>
References: <1492947102-3133-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492947102-3133-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 4/23/2017 2:31 PM, Sagi Grimberg wrote:
> In case we got an initial sg_offset, we need to
> account for it in the mr length.
>
> Fixes: ff2ba9936591 ("IB/core: Add passing an offset into the SG to
> ib_map_mr_sg")
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index b8f9382a8b7d..d9c6c0ea750b 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -1782,7 +1782,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
>  		klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
>  		klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
>  		klms[i].key = cpu_to_be32(lkey);
> -		mr->ibmr.length += sg_dma_len(sg);
> +		mr->ibmr.length += sg_dma_len(sg) - sg_offset;
>
>  		sg_offset = 0;
>  	}
>

Israel,
Can you please test it with our regression test suite (SRP can send 
sg_offset != 0) and send Tested-By signature ?
Also run Laurence scenario with SG_GAPS patch applied too.

thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
