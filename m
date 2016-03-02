From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 5/9] IB/core: add a simple MR pool
Date: Wed, 2 Mar 2016 10:14:10 +0100
Message-ID: <20160302091410.GA1308@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de> <1456784410-20166-6-git-send-email-hch@lst.de> <56D5E989.9010006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D5E989.9010006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 11:12:09AM -0800, Bart Van Assche wrote:
> A second question about this patch: why do we need locking in 
> ib_mr_pool_init() and ib_mr_pool_destroy()? Calling ib_mr_pool_get() or 
> ib_mr_pool_put() while one of these two functions is in progress is a bug 
> (race condition). Can the locking be left out from these two functions?

Maybe.  But then we'd need to use barrier to ensure no reordering ever
happens.  Just using the lock in the this slow path as well makes that
a lot easier.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
