From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/6] amso1100: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 12:50:23 -0400
Message-ID: <20130327125023.159e2309@tlielax.poochiereds.net>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
	<1364390288-30968-3-git-send-email-jlayton@redhat.com>
	<20130327162755.GC7395@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130327162755.GC7395-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 27 Mar 2013 09:27:55 -0700
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Wed, Mar 27, 2013 at 09:18:04AM -0400, Jeff Layton wrote:
> >  void c2_init_qp_table(struct c2_dev *c2dev)
> >  {
> >  	spin_lock_init(&c2dev->qp_table.lock);
> > -	idr_init(&c2dev->qp_table.idr);
> > +	idr_init_cyclic(&c2dev->qp_table.idr, 0);
> >  }
> 
> Why is this necessary?  In general, why is idr_init_cyclic()
> necessary?
> 
> Thanks.
> 

My thinking was that you might want to initialize the "cur" value to an
arbitrary value. All the current users though initialize it to the same
as the "start" value passed into idr_alloc_cyclic. Starting with it at
0 should be fine in all of the existing users.

I'll remove that in v2...

Thanks!
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
