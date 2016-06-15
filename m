From: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/8] nvme-fabrics: add a generic NVMe over Fabrics library
Date: Wed, 15 Jun 2016 15:16:03 -0400
Message-ID: <20160615191603.GC1919@localhost.localdomain>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
 <1465829128-22993-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465829128-22993-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Armen Baloyan <armenx.baloyan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 13, 2016 at 04:45:26PM +0200, Christoph Hellwig wrote:
> @@ -107,10 +108,19 @@ struct nvme_ctrl {
>  	u8 event_limit;
>  	u8 vwc;
>  	u32 vs;
> +	u32 sgls;
>  	bool subsystem;
>  	unsigned long quirks;
>  	struct work_struct scan_work;
>  	struct work_struct async_event_work;
> +
> +	/* Fabrics only */
> +	u16 sqsize;
> +	u32 ioccsz;
> +	u32 iorcsz;
> +	u16 icdoff;
> +	u16 maxcmd;
> +	struct nvmf_ctrl_options *opts;
>  };

The pci only stuff goes in 'struct nvme_dev' and embeds 'struct
nvme_ctrl', but fabrics gets to use nvme_ctrl directly?

If we need transport specifics for anything, like you have during
nvme_init_identify, I think we should add function callbacks to
nvme_ctrl_ops to set up those specifics, then we don't need 'is_fabrics'
checks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
