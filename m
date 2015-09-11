From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Fri, 11 Sep 2015 09:40:25 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 10 Sep 2015, Doug Ledford wrote:

> +		 * 1) ifdown/ifup
> +		 * 2) a regular mcast join/leave happens and we run
> +		 *    ipoib_mcast_restart_task
> +		 * 3) a REREGISTER event comes in from the SM
> +		 * 4) any other event that might cause a mcast flush

Could we have a timeout and leave the multicast group on process exit?
The old code base did that with the ipoib_mcast_leave_task() function.

With that timeout we do not longer accumulate MC sendonly subscriptions
for long running systems.

Also IPOIB_MAX_MCAST_QUEUE's default to 3 is not really enough to capture
a burst of traffic send to a multicast group. Can we make this
configurable or increase the max?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
