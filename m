From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 8 Oct 2015 08:10:08 +0300
Message-ID: <5615FAB0.8050601@mellanox.com>
References: <1443091747-13881-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443091747-13881-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 1:49 PM, Wengang Wang wrote:
> @@ -1050,8 +1057,9 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
>   					      &qp->db);
>   		ib_umem_release(qp->umem);
>   	} else {
> -		kfree(qp->sq.wrid);
> -		kfree(qp->rq.wrid);
> +		kvfree(qp->sq.wrid);
> +		kvfree(qp->rq.wrid);
> +
>   		if (qp->mlx4_ib_qp_type & (MLX4_IB_QPT_PROXY_SMI_OWNER |
>   		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI))
>   			free_proxy_bufs(&dev->ib_dev, qp);

when you fix issue A you don't conduct cleanup for issue B, remove the 
new line added here andadd

Acked-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When you re-submit patches makes sure to maintain version, e.g the 
re-post would be [PATCH V2] (I believe
this is going to be the 3rd version, so V0... V1 ... and now V2)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
