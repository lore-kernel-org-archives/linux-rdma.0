From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: message size, was Re: merge struct ib_device_attr into struct
	ib_device
Date: Tue, 22 Sep 2015 23:55:14 +0200
Message-ID: <20150922215514.GA13252@lst.de>
References: <1442869187-5556-1-git-send-email-hch@lst.de> <1442918846.4412.0.camel@opteya.com> <20150922203217.GA10825@lst.de> <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, postmaster-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 22, 2015 at 04:06:17PM -0500, Steve Wise wrote:
> Can you create a series of smaller patches that will fit on the list?
> That would make it easier for everyone to review/comment. 

I don't see how that is possible, as it's a flag day change.

But maybe we really need to bump up the message size limits for linux-rdma,
I'm pretty sure linux-kernel and linux-scsi handle attachments of this
size just fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
