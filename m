From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Thu, 20 Apr 2017 14:27:59 +0300
Message-ID: <2bd673ee-8455-32b7-1bad-34fa9eebb076@grimberg.me>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492098977-5231-4-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-4-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>  	if (ctrl->quirks & NVME_QUIRK_STRIPE_SIZE)
>  		blk_queue_chunk_sectors(q, ctrl->max_hw_sectors);
> -	blk_queue_virt_boundary(q, ctrl->page_size - 1);
> +
> +	if (!ctrl->sg_gaps_support)
> +		blk_queue_virt_boundary(q, ctrl->page_size - 1);
> +

I think it would be better if the ctrl will hold a virt_boundary
provided by the fabric driver? Then we would always
blk_queue_virt_boundary but with capable devices the fabric driver
can set it to 0. This will also allow for dword aligned sgls to
fit in pretty easily.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
