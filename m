From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Wed, 26 Aug 2015 10:18:29 -0600
Message-ID: <20150826161829.GA27407@obsidianresearch.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com>
 <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com>
 <20150825194945.GA22335@obsidianresearch.com>
 <55DDC12E.6030705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DDC12E.6030705-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 26, 2015 at 09:37:50AM -0400, Doug Ledford wrote:

> > Sure looks like these two race:
> > 
> > 		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags))..
> > 		clear_bit(IPOIB_MCAST_FLAG_FOUND, &mcast->flags);
> > 
> > Resulting in corruption of the flags.
> 
> Incorrect.  On all arches, the set_bit and friends functions are defined
> to be atomic.

Ah, right, I always forget about that because they don't use the
atomic type or naming scheme like everything else :|

> Which brings me to what I was alluding to earlier.  In your patch, you
> move the complete(mcast->done); to inside the spinlock.  I don't
> actually like that.  While the flags are atomic and therefore visible
> the moment they are done, any other writes to the mcast struct might be
> reordered.  By releasing the spinlock before you call complete(), you
> force a write memory barrier and make all changes visible.  That way
> anything that was waiting on that complete has a guaranteed clean
> picture when they get woke up.  Calling complete() within the spinlock
> takes that guarantee away.

complete() is a guarenteed memory barrier.

/**
 * complete: - signals a single thread waiting on this completion
 * @x:  holds the state of this particular completion
 [..]
 * It may be assumed that this function implies a write memory barrier before
 * changing the task state if and only if any tasks are woken up.
 */

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
