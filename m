From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC rdma-next 2/3] IB/core: Export mlx5 vendor specific
 strucutres
Date: Thu, 15 Sep 2016 10:17:18 -0600
Message-ID: <20160915161718.GD18154@obsidianresearch.com>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
 <1473841649-8923-3-git-send-email-leon@kernel.org>
 <20160915061336.GA4869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160915061336.GA4869-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 11:13:36PM -0700, Christoph Hellwig wrote:
> > index 4edb0f2..e804cc3 100644
> > +++ b/include/uapi/rdma/Kbuild
> > @@ -7,3 +7,4 @@ header-y += rdma_netlink.h
> >  header-y += rdma_user_cm.h
> >  header-y += hfi/
> >  header-y += rdma_user_rxe.h
> > +header-y += providers/
> 
> Can we avoid the horrible providers name?  The directories for drivers
> in the source tree so far are called hw/ and sw/ so we should stick to
> that here as well.

I also don't like the provider name, it is not consistent with Linux.

Not sure hw/sw is any better, other subsystems don't split their
drivers like that.

Just driver/?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
