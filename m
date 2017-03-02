From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/14] mlx5: Update to use new udma write
 barriers
Date: Thu, 2 Mar 2017 11:34:56 +0200
Message-ID: <24bf0e37-e032-0862-c5b9-b5a40fcfb343@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <d5921636-1911-5588-8c59-620066bca01a@dev.mellanox.co.il>
 <20170227180009.GL5891@obsidianresearch.com>
 <2969cce4-8b51-8fcf-f099-2b42a6d40a9c@dev.mellanox.co.il>
 <20170228170658.GA17995@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228170658.GA17995-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/28/2017 7:06 PM, Jason Gunthorpe wrote:
> Okay, my mistake, then it must be this, which increases the leading
> barrier to a wc_wmb().. See the discussion with Ram:
>

> diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
> index cc0af920c703d9..1ce2cf2dd0bbd4 100644
> --- a/providers/mlx5/cq.c
> +++ b/providers/mlx5/cq.c
> @@ -1281,16 +1281,16 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
>
>  	/*
>  	 * Make sure that the doorbell record in host memory is
> -	 * written before ringing the doorbell via PCI MMIO.
> +	 * written before ringing the doorbell via PCI WC MMIO.
>  	 */
> -	udma_to_device_barrier();
> +	mmio_wc_start();
>
>  	doorbell[0] = htonl(sn << 28 | cmd | ci);
>  	doorbell[1] = htonl(cq->cqn);
>
>  	mlx5_write64(doorbell, ctx->uar[0] + MLX5_CQ_DOORBELL, &ctx->lock32);
>
> -	mmio_ordered_writes_hack();
> +	mmio_flush_writes();
>
>  	return 0;
>  }
>

The above seems fine, can you please send a formal patch to fix the 
original series, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
