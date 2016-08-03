From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/5] nvme-rdma: Remove duplicate call to
	nvme_remove_namespaces
Date: Wed, 3 Aug 2016 11:03:12 +0200
Message-ID: <20160803090312.GA11321@lst.de>
References: <1470124419-30405-1-git-send-email-sagi@grimberg.me> <1470124419-30405-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470124419-30405-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2016 at 10:53:36AM +0300, Sagi Grimberg wrote:
> nvme_uninit_ctrl already does that for us. Note that we reordered
> nvme_rdma_shutdown_ctrl and nvme_uninit_ctrl, this is perfectly
> fine because we actually want ctrl uninit (aen, scan cancellation
> and namespaces removal) to happen before we shutdown the rdma
> resources.
> 
> Also, centralize the deletion work and the dead controller removal
> work code duplication into __nvme_rdma_shutdown_ctrl that accepts
> a shutdown boolean.

Looks fine:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
