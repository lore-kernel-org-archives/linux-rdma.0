From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Thu, 11 Jun 2015 10:27:34 -0600
Message-ID: <20150611162734.GA22825@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
 <20150610184954.GA26404@obsidianresearch.com>
 <CAAKD3BB90iZ98B2ADG+=ZYuEVtLq26a99BEjQCR8U1vzvcG+Gw@mail.gmail.com>
 <20150610220154.GA4391@obsidianresearch.com>
 <CAAKD3BChd10Gd4P2Mwm+46aW+PJBT3j7K-BLex0Fkm5UdtUG3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BChd10Gd4P2Mwm+46aW+PJBT3j7K-BLex0Fkm5UdtUG3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 12:49:14PM +0300, Matan Barak wrote:

> No, that's not true.
> For example cm_init_av_by_path calls ib_find_cached_gid *in a
> spinlock* which in turns go to the roce_gid_table_find_gid.
> So it's obvious you can't use a semaphore/mutex.

Of course, spin lock is the appropriate trivial locking primitive for
that case.

> write_gid calls the vendor's modify_gid which might be a sleepable
> context - so you can't use spin locks here.

> There are other ways around this, but I think seqcount does this pretty easily.

A spinlock replacing the seqcount would be equally easy and have a
higher chance of being used properly. If you use a spinlock then the
RCU around ndev goes away because the ndev cannot become deref'd while
the spinlock is held. It is not longer necessary to combine RCU and
seqlock to protect ndev.

> READ_ONCE protects something entirely different.
> roce_gid_table_client_cleanup_one sets the roce_gid_table to NULL in
> order to indicate future calls that its being
> destroyed and then flushes the workqueue. In order to avoid crashing
> in roce_gid_table, we first store the pointer with
> READ_ONCE such that we'll always have a valid pointer.

I haven't even looked carefully at the tear down process, but it was
obvious that READ_ONCE was being used as another performance locking
scheme. And the smb_ barriers are strange to include along with work
queues. And it is strange to continue to inject new work when shutting
down.

> No, that's not what I'm saying.

Oh, well you should be saying that, because it is right.

> When roce_gid_table_get_gid is called:
> rcu_read_lock();
> roce_gid_table_get_gid(..., attr);
> /* attr->ndev is valid here */
> rcu_read_unlock();

This pattern never appears in the patch series, what are you talking
about? Also, the memcpy in roce_gid_table_get_gid is missing a RCU
read side for ndev.

Even so  that is ugly, callers that need the net_dev should have a
held ref returned for them by the API and should not be holding rcu.

> > Honestly, since RCU is done wrong, and I'm very suspicious seqlock is
> > done wrong too, I would *strongly* encourage v6 to have simple
> > read/write sem and mutex locking and nothing fancy for performance. I
> > don't want to go round and round on subtle performance locking for a
> > *cleanup patch*.

> How is seqcount relates to RCU exactly?!? Anyway, I explained why
> seqcount was chosen here and unless there is a good reason to switch
> to another locking method, I prefer not to.

Using seqcount requires RCU protection for ndev, they go hand in
hand.

> "Having a feeling" that if
> A is wrong (and to be exact, the rcu usage you pointed out above isn't
> wrong but might just be unnecessary because of netdev_wait_allrefs)
> doesn't mean B is wrong.

No, I looked at the seqcount and it sure looks slightly wrong, seeing
RCU *and* seqcount be wrong makes me throw up my hands and say: Stop
using performance locking.

> > There is also this RCU confusion:
> >
> > +                               rcu_read_lock();
> > +                               if (ib_dev->get_netdev)
> > +                                       idev = ib_dev->get_netdev(ib_dev, port);
> >
> > When holding the rcu_read_lock it should be obvious what the RCU
> > protected data is. There is no way holding it around a driver call
> > back makes any sense.
> >
> > The driver should return a held netdev or null.
> >
> > .. and maybe more, I stopped looking
> >
> 
> I agree, rcu_dereference is missing here, but as you suggested we'll
> use dev_hold by the vendor driver.

What? You think rcu_dereference is somehow needed above?? Why??

> We'll go over the RCU usages here. A lot of them just compare
> pointers, so they are safe as it is.

Comparing pointers is safe under certain situations, but you still
have to use rcu_derference and rcu_read_lock on the reader side of any
writer side RCU protected data.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
