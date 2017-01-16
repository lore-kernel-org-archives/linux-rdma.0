From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data
        structures
Date: Mon, 16 Jan 2017 16:31:09 +0100
Message-ID: <20170116153109.GA16170@lst.de>
References: <1484412337-10860-1-git-send-email-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484412337-10860-1-git-send-email-parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +++ b/drivers/nvme/target/rdma.c
> @@ -438,6 +438,14 @@ static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
>  {
>  	struct ib_recv_wr *bad_wr;
>  
> +	ib_dma_sync_single_for_device(ndev->device,
> +			cmd->sge[0].addr, sizeof(*cmd->nvme_cmd),
> +			DMA_FROM_DEVICE);
> +
> +	if (cmd->sge[1].addr)

0 can be a valid address returned from dma_map_single on some
architectures. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
