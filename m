From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v3] nvmet-rdma: Correctly handle RDMA device hot removal
Date: Tue, 2 Aug 2016 14:53:48 +0200
Message-ID: <20160802125348.GE13235@lst.de>
References: <1469967347-20466-1-git-send-email-sagi@grimberg.me> <20160801111530.GB16474@lst.de> <307087d1-88af-5244-38e8-5b9786285488@grimberg.me> <20160801155054.GD22771@lst.de> <dc6286c3-a5c0-48a8-284d-f53b6830da22@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dc6286c3-a5c0-48a8-284d-f53b6830da22-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 02, 2016 at 09:39:48AM +0300, Sagi Grimberg wrote:
> I'm not exactly sure what you mean. Do you mean placing
> cmpxchg in nvmet_rdma_device_removal()? To what we cmp
> when we want to xchg?
>
> Care to explain in a bit more detail?

Right, plain xchg() should be enough.  E.g. do an xchg both
in the device removal handler and ->remove_port and only delete
the CM_ID if the caller was the one taking it out the private
data.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
