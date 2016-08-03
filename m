From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 3/5] nvme-rdma: Free the I/O tags when we delete the
	controller
Date: Wed, 3 Aug 2016 11:03:30 +0200
Message-ID: <20160803090330.GB11321@lst.de>
References: <1470124419-30405-1-git-send-email-sagi@grimberg.me> <1470124419-30405-4-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470124419-30405-4-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2016 at 10:53:37AM +0300, Sagi Grimberg wrote:
> If we wait until we free the controller (free_ctrl) we might
> lose our rdma device without any notification while we still
> have open resources (tags mrs and dma mappings).
> 
> Instead, destroy the tags with their rdma resources once we
> delete the device and not when freeing it.
> 
> Note that we don't do that in nvme_rdma_shutdown_ctrl because
> controller reset uses it as well and we want to give active I/O
> a chance to complete successfully.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Looks fine:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
