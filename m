From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v4] nvmet-rdma: Correctly handle RDMA device hot removal
Date: Thu, 4 Aug 2016 13:50:05 +0200
Message-ID: <20160804115005.GB32487@lst.de>
References: <1470230393-23671-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470230393-23671-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2016 at 04:19:53PM +0300, Sagi Grimberg wrote:
> When configuring a device attached listener, we may
> see device removal events. In this case we return a
> non-zero return code from the cm event handler which
> implicitly destroys the cm_id. It is possible that in
> the future the user will remove this listener and by
> that trigger a second call to rdma_destroy_id on an
> already destroyed cm_id -> BUG.
> 
> In addition, when a queue bound (active session) cm_id
> generates a DEVICE_REMOVAL event we must guarantee all
> resources are cleaned up by the time we return from the
> event handler.
> 
> Introduce nvmet_rdma_device_removal which addresses
> (or at least attempts to) both scenarios.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
