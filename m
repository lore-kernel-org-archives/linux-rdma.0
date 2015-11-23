From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Add a missing rcu_read_unlock()
Date: Mon, 23 Nov 2015 11:47:13 -0700
Message-ID: <20151123184713.GD32085@obsidianresearch.com>
References: <564F6EAC.7070608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564F6EAC.7070608-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2015 at 11:04:12AM -0800, Bart Van Assche wrote:
> Ensure that validate_ipv4_net_dev() calls rcu_read_unlock() if
> fib_lookup() fails. Detected by sparse. Compile-tested only.
> 
> Fixes: "IB/cma: Validate routing of incoming requests" (commit f887f2ac87c2).
> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>  drivers/infiniband/core/cma.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Yep

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

You say sparse detected this? Mellanox/Or folks - I thought you ran all
the common static stuff on your patches?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
