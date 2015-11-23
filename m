From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/3] staging/rdma/hfi1: Method to toggle "fast ECN" detection
Date: Sun, 22 Nov 2015 21:15:02 -0500
Message-ID: <20151123021501.GC3304@phlsvsds.ph.intel.com>
References: <1447112084-12532-1-git-send-email-ira.weiny@intel.com> <20151120005444.GA32083@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151120005444.GA32083-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 19, 2015 at 04:54:44PM -0800, Greg KH wrote:
> On Mon, Nov 09, 2015 at 06:34:44PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Add a module paramter to toggle prescan/Fast ECN Detection and remove the
> > Kconfig option which used to control this.
> 
> Ick, no, not a module parameter, that's horrid (hint, it isn't a
> per-device option...)

This is a good point.  Previous to this patch we had a compile time option
which would have affected all devices and I think we just continued that.  I do
like the idea of making this per port.  I will respin the patch.

However, I want to be clear on your hint.  Are you saying that sysfs would be a
better place to put such a flag?

> 
> Why can't you do this dynamically?

ECN is always on.  The key is the reaction time of the individual port.
Attempting to turn this on and off would affect both the reaction time and the
processing time in a negative way.

> Why would anyone ever want to make this "slow"?

This is a tuning nob for over all fabric performance not individual node
performance.  ECN controls congestion spreading through the network as is
explained in this paper.

http://infocom2003.ieee-infocom.org/papers/28_01.PDF

As is shown in figure 1 and 2 of that paper congestion at node Bc is affecting
traffic at node Bv.  The default reaction time of ECN is likely to be
sufficient for most users based on our experience so far.

However, should a particular network see system wide degradation, this option
can be turned on to increase the reaction time at node Bc.  However, node Bc is
already overloaded so the trade off is likely acceptable.

Unfortunately, it is hard to predict when a user may need this option as we
don't have the resources to build extreme scale fabrics for testing.  Nor do we
know all users workloads or the fabric topologies those workloads may be
running on.

We developed the code which this option enables based on lab experiments.  So
we need this to be an option available to users.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
