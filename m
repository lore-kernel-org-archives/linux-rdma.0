From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Tue, 25 Aug 2015 12:22:33 -0600
Message-ID: <20150825182233.GA20744@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DCAACD.3000307-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 25, 2015 at 01:50:05PM -0400, Doug Ledford wrote:
> On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
> > Even though we don't expect the group to be created by the SM we
> > sill need to provide all the parameters to force the SM to validate
> > they are correct.
> 
> Why does this patch embed locking changes that, as far I can tell, are
> not needed by the rest of the patch?

test_bit was lowered into ipoib_mcast_join, which requires pushing the
lock unlock down as well. The set_bit side holds that lock.

> If the locking changes are needed for some reason, then they likely
> need to be their own patch with their own changelog.

It doesn't make sense to move the locking without the code motion that
motivates it, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
