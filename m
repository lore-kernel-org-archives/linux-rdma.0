From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure
 dynamic
Date: Wed, 16 Mar 2016 12:17:23 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1603161213560.15010@east.gentwo.org>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <20160316154738.GA26530@phlsvsds.ph.intel.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160316154738.GA26530-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Mar 2016, Dennis Dalessandro wrote:

> > +	return sprintf(buf, "%llu\n", stats.value[index]);
> > +}
>
> This works fine when there are few counters, but if there are lots? What about
> changing things to include the index in the get_protocol_stats() call so that
> we just grab the single item we are looking for?

Right now there is a limiting in the source to a max of 128 counters. In
practice all users use less than 30 counters at this point. So we have
some space to go until we may need a better solution. We could also save
the stats we have retrieved so it can be used for multiple counters.

But I think this something for the future.

> > +	for (counters = 0; stats.name[counters]; counters++)
> > +		;
> > +
> > +	BUG_ON(counters > MAX_NR_PROTOCOL_STATS);
>
> Should we really be bringing the machine crashing down here?

The counter tables are defined at compile time. The BUG_ON ensures that
the driver will bug immediately when testing if we hit that limit.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
