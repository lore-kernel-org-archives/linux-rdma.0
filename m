From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-core v5 0/8]  Broadcom User Space RoCE Driver
Date: Mon, 24 Apr 2017 15:51:40 -0600
Message-ID: <20170424215140.GA14907@obsidianresearch.com>
References: <1493059995-636-1-git-send-email-devesh.sharma@broadcom.com>
 <1493067443.3041.63.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493067443.3041.63.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 24, 2017 at 04:57:23PM -0400, Doug Ledford wrote:

> I'm not aware of anyway, which is always possible, I prefer to see
> mutexes instead of spin locks in user space because they are safer and
> more likely to result in forward progress in the event of
> contention.

It is true that if the callers of verbs adjust their thread priorities
we will certainly completely fail to make forward progess in the worst
case situations, as high priority waiters will no yield the CPU.

For this reason alone it is probably a really bad idea to use
spinlocks at all in library code.

However, AFAIK, default pthread mutexes well known to be much slower
than spinlocks for various cases. They have weird performance aspects
from the fairness policy on unlock we may not really want.

Perahps this is why Sean open-coded locks using atomics in rdmacm and
acm?

However, there are many kinds of mutex locks in glibc, and perhaps
something like PTHREAD_MUTEX_ADAPTIVE_NP gives performance close to a
spinlock?

Someone would have to benchmark different options and see.

Since we are so very performance sensitive, we might do well to
open-code our own locking primitive, similar to
PTHREAD_MUTEX_ADAPTIVE_NP, based on futexes. Inlining the
non-contended case alone would probably be notably helpful.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
