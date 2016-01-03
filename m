From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/srpt: Fix a race condition related to SRP login
Date: Sun, 3 Jan 2016 11:51:27 +0100
Message-ID: <20160103105127.GA10025@lst.de>
References: <5684ED4B.2010303@sandisk.com> <5684EE16.8070701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5684EE16.8070701-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 31, 2015 at 09:57:58AM +0100, Bart Van Assche wrote:
> Since patch "IB/srpt: chain RDMA READ/WRITE requests" there are
> two loops that process the command wait list. ch->cmd_wait_list
> is accessed without locking which means that all code that
> accesses this list must be serialized. Since processing of the
> RTU event happens from another context than IB WC processing,
> remove the wait list processing code from the RTU handler.

But now the first I/O(s) could be lost if no other I/O comes in,
right?  I suspect that we need to keep this loop to protect against
such corner cases.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
