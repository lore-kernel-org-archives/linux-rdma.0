From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Tue, 12 Dec 2017 11:55:30 -0700
Message-ID: <20171212185530.GB16603@ziepe.ca>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190218.GA744@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208233049.GB23239@ziepe.ca>
 <20171211183314.GA20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211201421.GD27709@ziepe.ca>
 <20171211215936.GC20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211221425.GA7551@ziepe.ca>
 <20171212171300.GD20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171212171300.GD20684-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > What? You can't combine one thread doing
> > 
> >  if (refcount_dec_and_test(&srq->refcnt))
> >          wake_up(&srq->wait);
> > 
> > With
> >   if (!refcount_dec_and_test(&srq->refcnt))
> > 	wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > 
> > It makes no sense, how is that a refcount???
> > 
> > They can't *BOTH* refcount_dec_and_test!
> >
> > I can understand doing
> >
> >   if (refcount_dec_and_test(&srq->refcnt))
> >          wake_up(&srq->wait);
> >
> > and then
> > 
> >    wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > 
> > That makes perfect sense.
> 
> Perhaps I am mistaken in my understanding of refcounts here, but
> what is wrong with this? If it's not that the refcount is set to
> 1 on resource creation (which, by your earlier suggestion of
> checking refcnt == 1, seems to be fine), and both callers (the
> resource event handler and resource destroy call) need to make
> sure the destroy sequence only happens once (when the refcount
> reaches 0), then using refcount_dec_and_test seems right to me.

I think the issue here is trying to fit an optimized approach that was
using atomics into a refcount.

I have certain expectations when I see something called 'refcount'
that this scheme really doesn't follow anymore, and those expectations
are pretty much matched by the protections inside refcount against
going to 0 and so on.

The algorithm works OK, but I'm not sure it is a 'refcount', more of a
'usecnt'..

On the other hand, having the refcount overflow protections in this
path does seem useful.

I did a random audit of refcount_dec_and_test existing users and
didn't find any that use this pattern.

What you've actually built here is a rwsem out of an atomic and a wait
queue..

So, what is wrong with a rwsem?

> What we're doing is effectively the same as how mlx5 handles
> this (see drivers/net/ethernet/mellanox/mlx5/core/srq.c) I
> suppose using refcount_t requires one to follow a particular
> model of usage but I'm not sure how this isn't right.

I didn't say it was wrong, I asked 'how is that a refcount??'

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
