From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 14:57:16 -0700
Message-ID: <20180125215716.GA11537@ziepe.ca>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
 <20180125201023.GA9162@ziepe.ca>
 <20180125202710.GS1393@mtr-leonro.local>
 <20180125210026.GA10719@ziepe.ca>
 <20180125211831.GT1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125211831.GT1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 11:18:31PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 25, 2018 at 02:00:26PM -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 25, 2018 at 10:27:10PM +0200, Leon Romanovsky wrote:
> > > On Thu, Jan 25, 2018 at 01:10:23PM -0700, Jason Gunthorpe wrote:
> > > > On Thu, Jan 25, 2018 at 09:44:36PM +0200, Leon Romanovsky wrote:
> > > > > > > +	/*
> > > > > > > +	 * @kref: Protect destroy of the resource
> > > > > > > +	 */
> > > > > > > +	struct kref		kref;
> > > > > >
> > > > > > Sticking a kref in a random structure that is itself not malloc'd is a
> > > > > > big red flag:
> > > > >
> > > > > It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
> > > > > malloced as part of their creation.
> > > >
> > > > I mean the kref isn't in any way linked the lifetime of the malloc
> > > > that contains it. So it isn't really a kref, it is just a refcount.
> > >
> > > For now, yes, in the future no. IMHO it is the direction to manage RDMA
> > > objects.
> >
> > Maybe but until we do that this doesn't have struct kref semantics at
> > all and shouldn't be called kref..
> 
> You are actually open-coded kref semantics with addition of completions.

I generally don't like seeing 'complete()' as a kref release
function. There have been very subtle problems with code trying that
in the past..

But yes, you can force things to work that way if very, very careful.

I've often thought I'd like a helper type that had the kref+complete
semantics, because that does seem to crop up in a few places and it
would really help clarity.

> > > > What I sent you wasn't remotely like this, it had two nested locks,
> > > > the outer mutex and a very special open coded inner read/write lock
> > > > that doesn't deadlock when nested..
> > >
> > > I still didn't like your approach, because it has three words which i don't want
> > > to see here: "special open-coded variant". I believe that the way to go is to add
> > > completion structure and convert _del to be something like that:
> >
> > Well, we can code the same idea with a completion, it is a little
> > clearer but uses more memory for the per-object completion struct.
> >
> > Read side:
> >   mutex_lock(list_lock)
> >   for_each_list(...,obj...) { // Must NOT use _safe here
> >      // The object is in process of being deleted
> >      if (refcount_inc_not_zero(&obj->refcount))
> >           continue;
> >      mutex_unlock(list_lock);
> >       ...
> >      mutex_lock(list_lock);
> >      if (refcount_dec_and_test(&obj->recount))
> >          complete(&res->completion);
> >   }
> >
> > Destroy side:
> >    if (refcount_dec_and_test(&obj->ref))
> >          complete(&obj->completion);
> >    wait_for_completion(obj->free);
> >
> >    mutex_lock(list_lock)
> >    list_del(obj);
> >
> >
> > The refcount starts at 1 during init. Destroy triggers the freeing
> > process by decr. Once the refcount reaches 0 it latches at 0 as 'to be
> > destroyed' and the pointer can never leave the list_lock critical
> > section.
> >
> > It is still tricky..
> 
> This is more or less how nldev does reads, with exception that counters
> (kref) incremented and decremented under r/w semaphore, it eliminates the
> check "if (refcount_inc_not_zero(&obj->refcount))" and instead complete
> it calls to release (kref semantics).

Well, the read side is close, but no you can't skip the
refcount_inc_not_zero approach. It is subtly avoiding a race.

The v6 maybe tried to solve that race by having the release function
delete from the lists, but that just creates a deadlock:

Read side is doing:

+               down_read(&device->res.rwsem);
+		rdma_restrack_put(res);

Which could eventualy call

+static void restrack_release(struct kref *kref)
+{
+	down_write(&dev->res.rwsem);

Which is obviously an instant deadlock.

If a kref is used then the only thing the release function can do is
call complete, and you still must use kref_get_not_zero.

This is why I hate forcing krefs to do this - krefs evoke certain
expectations regarding how get and put work that this scheme throws
out the window. It makes it very hard to review if krefs don't follow
the usual kref expectations.

And this sort of bug, not using kref_get_not_zero or similar, is
actually the thing I usually find when people try and build these
things out of krefs :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
