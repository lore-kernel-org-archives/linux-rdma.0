From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Tue, 4 Aug 2015 18:23:38 -0600
Message-ID: <20150805002338.GB22959@obsidianresearch.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438697008-26209-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 05:03:28PM +0300, Yishai Hadas wrote:
> Currently, IB/cma remove_one flow blocks until all user descriptor managed by
> IB/ucma are released. This prevents hot-removal of IB devices. This patch
> allows IB/cma to remove devices regardless of user space activity. Upon getting
> the RDMA_CM_EVENT_DEVICE_REMOVAL event we close all the underlying HW resources
> for the given ucontext. The ucontext itself is still alive till its explicit
> destroying by its creator.

Implementation aside,

This changes the policy of the ucma from
 Tell user space and expect it to synchronously clean up
To
 Tell user space we already nuked the RDMA device asynchronously

Do we even want to do that unconditionally?

Shouldn't the kernel at least give userspace some time to respond to
the event before nuking the world?

I'm now also wondering if we have some ordering issues on
removal. Will uverbs continue to work while ucma is active?

It looks like at least we can rmmod ib_uverbs and stuff goes really
sideways for poor apps. That is probably a corner case though..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
