From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: message size, was Re: merge struct ib_device_attr into struct
	ib_device
Date: Wed, 23 Sep 2015 16:47:18 +0200
Message-ID: <20150923144718.GA2983@lst.de>
References: <1442869187-5556-1-git-send-email-hch@lst.de> <1442918846.4412.0.camel@opteya.com> <20150922203217.GA10825@lst.de> <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com> <20150922215514.GA13252@lst.de> <1442996798.4412.4.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442996798.4412.4.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 23, 2015 at 10:26:38AM +0200, Yann Droneaud wrote:
> Perhaps you could change ib_query_device() to use the ib_device_attr
> from struct ib_device so that ulp doesn't have to be modified at the
> same time the drivers. Then further patches can update the users of
> ib_query_device(), one at a time. And the last patch would remove
> ib_query_device().

That would still leave us with a useless struct ib_device_attr embedded
into struct ib_device.  Anyway, I'll resend it now that the message limits have
been bumped.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
