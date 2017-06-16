From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v5 for-4.13 3/7] mlx5: move affinity hints assignments
        to generic code
Date: Fri, 16 Jun 2017 11:47:46 +0200
Message-ID: <20170616094746.GB12547@lst.de>
References: <1497533594-11579-1-git-send-email-sagi@grimberg.me> <1497533594-11579-4-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497533594-11579-4-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>  
> +static int mlx5e_get_node(struct mlx5e_priv *priv, int ix)
> +{
> +	return pci_irq_get_node(priv->mdev->pdev, MLX5_EQ_VEC_COMP_BASE + ix);
> +}

This helper seems very useful indeed..

>  	rq->mpwqe.info = kzalloc_node(wq_sz * sizeof(*rq->mpwqe.info),
> -				      GFP_KERNEL, cpu_to_node(c->cpu));
> +					GFP_KERNEL, node);

Why the reindenting?

>  	/* We allocate more than mtt_sz as we will align the pointer */
> -	rq->mpwqe.mtt_no_align = kzalloc_node(mtt_alloc * wq_sz, GFP_KERNEL,
> -					cpu_to_node(c->cpu));
> +	rq->mpwqe.mtt_no_align = kzalloc_node(mtt_alloc * wq_sz,
> +					GFP_KERNEL, node);

Or the moving of GFP_KERNEL to the next line here?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
