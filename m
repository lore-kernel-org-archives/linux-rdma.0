From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Mon, 10 Aug 2015 23:48:52 -0600
Message-ID: <20150811054852.GC13314@obsidianresearch.com>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com>
 <1438697008-26209-7-git-send-email-yishaih@mellanox.com>
 <20150804220903.GE10934@obsidianresearch.com>
 <55C22739.5060808@dev.mellanox.co.il>
 <20150805182117.GA15583@obsidianresearch.com>
 <HE1PR05MB1418EA195D579C09EB1FB746B1740@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB1418EA195D579C09EB1FB746B1740-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 06, 2015 at 03:36:39PM +0000, Liran Liss wrote:
> I don't think that the order matters.

It does if you want a planned 'gental' removal to be possible..

> When you do a surprise removal, you disconnect the application from
> both ucma and uverbs device references.  In this state, the only
> thing that the application can do is close all handles.  It doesn't
> matter if you succeed closing a resource on a device that is still
> accessible, or "close" an already destroyed resource...

Hurm. That makese sense, but that isn't entirely what this patch set
does - it is rough when facing the user, but the kernel side is
actually quite gental.. Ie the RDMA CM still sends GMPs on this
shutdown path.. Looks like the various storage ULP shutdowns are
pretty gental too.

So, it is easy to get confused what the point here is..

> The primary reason for device surprise removal is to recover from
> device fatal errors or PCI errors.

Okay, this makes sense to me. Maybe some more patches will come to be
rougher to the kernel ULPs..

> For the administrative removal use case, can consider providing
> applications a grace period before disconnecting them in a future
> patch set.  Even here, however, I am not sure that if an
> administrator decided to remove a device while there are still
> active applications, we should stall his request.

Well, it can be discussed separately.

As an example, I think it is important, if you
want to hot-unplug a storage controller the admin expects a clean
storage shutdown. I think in-kernel storage drivers do that
already. IB shouldn't really be much different.

> Anyway, let's get this patch-set done.

Still needs to have the locking fixed..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
