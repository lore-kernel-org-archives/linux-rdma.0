From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Fri, 23 Jan 2015 09:01:44 +0200
Message-ID: <CAJ3xEMi7mowr_qFMUXtM5m8p974qF39nPf-Qh-NOYK_jUzswSg@mail.gmail.com>
References: <cover.1421936879.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1421936879.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 22, 2015 at 4:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> My 8 patch set taken into 3.19 caused some regressions.  This patch
> set resolves those issues.

Doug, Roland - eight rc1 patches followed ten rc6 fixes - sounds a bit
too much to me. If we (and Linus) like or not, probably the right
thing to do is revert the rc1 patches and come up with a set of
hopefully < 18 patches for 3.20 - using squashes and such, and there's
not much time for that too, BTW.

Taking into account Doug's listing of the remaining problems in the
original set which are not addressed by the patch Erez suggested, this
isn't an option either.

Alex, you acked all the series, haven't you noticed the IPv6 and IPv4
multicast breakage or it worked for you?

Or.

> Doug Ledford (10):
>   IB/ipoib: fix IPOIB_MCAST_RUN flag usage
>   IB/ipoib: Add a helper to restart the multicast task
>   IB/ipoib: make delayed tasks not hold up everything
>   IB/ipoib: Handle -ENETRESET properly in our callback
>   IB/ipoib: don't restart our thread on ENETRESET
>   IB/ipoib: remove unneeded locks
>   IB/ipoib: fix race between mcast_dev_flush and mcast_join
>   IB/ipoib: fix ipoib_mcast_restart_task
>   IB/ipoib: flush the ipoib_workqueue on unregister
>   IB/ipoib: cleanup a couple debug messages
>
>  drivers/infiniband/ulp/ipoib/ipoib.h           |   1 +
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      |   2 +
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 234 ++++++++++++++-----------
>  3 files changed, 131 insertions(+), 106 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
