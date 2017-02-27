From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/14] mlx5: Update to use new udma write
 barriers
Date: Mon, 27 Feb 2017 12:56:33 +0200
Message-ID: <d5921636-1911-5588-8c59-620066bca01a@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-9-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-9-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/16/2017 9:23 PM, Jason Gunthorpe wrote:
> The mlx5 comments are good so these translate fairly directly.
>
> There is one barrier in mlx5_arm_cq that I could not explain, it became
> mmio_ordered_writes_hack()
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---

>  #ifdef MLX5_DEBUG
>  	{
> @@ -1283,14 +1283,14 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
>  	 * Make sure that the doorbell record in host memory is
>  	 * written before ringing the doorbell via PCI MMIO.
>  	 */
> -	wmb();
> +	udma_to_device_barrier();
>
>  	doorbell[0] = htonl(sn << 28 | cmd | ci);
>  	doorbell[1] = htonl(cq->cqn);
>
>  	mlx5_write64(doorbell, ctx->uar[0] + MLX5_CQ_DOORBELL, &ctx->lock32);
>
> -	wc_wmb();
> +	mmio_ordered_writes_hack();

We expect to use here the "mmio_flush_writes()" new macro, instead of 
the above "hack" one. This barrier enforces the data to be flushed 
immediately to the device so that the CQ will be armed with no delay.

>  	return 0;
>  }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
