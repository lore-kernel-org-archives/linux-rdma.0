From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] IB/hfi1: might sleep under spinlock in hfi1_ioctl()
Date: Wed, 11 Nov 2015 00:53:07 -0500
Message-ID: <20151111055305.GA9594@phlsvsds.ph.intel.com>
References: <1446240749-5003-1-git-send-email-khoroshilov@ispras.ru> <20151030235817.GA13800@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151030235817.GA13800-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Khoroshilov <khoroshilov-ufN2psIa012HXe+LvDLADg@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 30, 2015 at 07:58:18PM -0400, ira. weiny wrote:
> On Sat, Oct 31, 2015 at 12:32:29AM +0300, Alexey Khoroshilov wrote:
> > Hello,
> > 
> > hfi1_ioctl() contains many calls to might sleep functions with
> > dd->hfi1_snoop.snoop_lock spinlock held (for example, access_ok,
> > copy_from_user, kzalloc(GFP_KERNEL), etc.).
> > 
> > Should dd->hfi1_snoop.snoop_lock be acquired just before updating state?
> 
> I believe you are correct.
> 
> I am currently in the process of pushing fixes to the staging tree.
> 
> We have a patch which fixes this queued up but it depends on at least one other
> patch in my queue.
> 
> I will do my best to get this submitted soon.

I have just posted a series which addresses this problem as well as doing
general clean up on hfi1_ioctl.  The specific fix is contained in this patch.

[PATCH 7/8] staging/rdma/hfi1: Reduce snoop locking scope in IOCTL handler.

Thanks for the report,
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
