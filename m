From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Tue, 12 Dec 2017 16:08:16 -0800
Message-ID: <20171213000815.GE20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190218.GA744@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208233049.GB23239@ziepe.ca>
 <20171211183314.GA20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211201421.GD27709@ziepe.ca>
 <20171211215936.GC20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211221425.GA7551@ziepe.ca>
 <20171212171300.GD20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171212185530.GB16603@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171212185530.GB16603-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 12, 2017 at 11:55:30AM -0700, Jason Gunthorpe wrote:
> > > What? You can't combine one thread doing
> > > 
> > >  if (refcount_dec_and_test(&srq->refcnt))
> > >          wake_up(&srq->wait);
> > > 
> > > With
> > >   if (!refcount_dec_and_test(&srq->refcnt))
> > > 	wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > > 
> > > It makes no sense, how is that a refcount???
> > > 
> > > They can't *BOTH* refcount_dec_and_test!
> > >
> > > I can understand doing
> > >
> > >   if (refcount_dec_and_test(&srq->refcnt))
> > >          wake_up(&srq->wait);
> > >
> > > and then
> > > 
> > >    wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > > 
> > > That makes perfect sense.
> > 
> > Perhaps I am mistaken in my understanding of refcounts here, but
> > what is wrong with this? If it's not that the refcount is set to
> > 1 on resource creation (which, by your earlier suggestion of
> > checking refcnt == 1, seems to be fine), and both callers (the
> > resource event handler and resource destroy call) need to make
> > sure the destroy sequence only happens once (when the refcount
> > reaches 0), then using refcount_dec_and_test seems right to me.
> 
> I think the issue here is trying to fit an optimized approach that was
> using atomics into a refcount.
> 
> I have certain expectations when I see something called 'refcount'
> that this scheme really doesn't follow anymore, and those expectations
> are pretty much matched by the protections inside refcount against
> going to 0 and so on.
> 
> The algorithm works OK, but I'm not sure it is a 'refcount', more of a
> 'usecnt'..

Hm, it's still not clear to me what expectations are not followed here,
and how you're differentiating 'refcount' from 'usecnt'. And not that
it makes it right, but I did notice that mlx4 uses the same pattern as
what I've done here [1].

If it makes the most sense to revert to atomic operations or use a
rwsem, I can do that. Just trying to understand what the expectations
are for using refcount_t.

Bryan

[1] Commit ff61b5e3f041c2f1aa8d7c700af3007889973889
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
