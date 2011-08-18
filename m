From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] mm: Distinguish between mlocked and pinned pages
Date: Thu, 18 Aug 2011 18:51:43 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1108181851100.11512@router.home>
References: <alpine.DEB.2.00.1108101516430.20403@router.home> <20110817155412.cc302033.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110817155412.cc302033.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 17 Aug 2011, Andrew Morton wrote:

> Sounds reasonable.  But how do we prevent future confusion?  We should
> carefully define these terms in an obvious place, please.

Ok.

> > --- linux-2.6.orig/include/linux/mm_types.h	2011-08-10 14:08:42.000000000 -0500
> > +++ linux-2.6/include/linux/mm_types.h	2011-08-10 14:09:02.000000000 -0500
> > @@ -281,7 +281,7 @@ struct mm_struct {
> >  	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
> >  	unsigned long hiwater_vm;	/* High-water virtual memory usage */
> >
> > -	unsigned long total_vm, locked_vm, shared_vm, exec_vm;
> > +	unsigned long total_vm, locked_vm, pinned_vm, shared_vm, exec_vm;
> >  	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
> >  	unsigned long start_code, end_code, start_data, end_data;
> >  	unsigned long start_brk, brk, start_stack;
>
> This is an obvious place.  Could I ask that you split all these up into
> one-definition-per-line and we can start in on properly documenting
> each field?

Will do that after the linuxcon.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
