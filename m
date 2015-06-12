From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Fri, 12 Jun 2015 10:11:58 -0600
Message-ID: <20150612161158.GA21425@obsidianresearch.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com>
 <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
 <557852EE.5030107@mellanox.com>
 <20150610184954.GA26404@obsidianresearch.com>
 <CAAKD3BB90iZ98B2ADG+=ZYuEVtLq26a99BEjQCR8U1vzvcG+Gw@mail.gmail.com>
 <20150610220154.GA4391@obsidianresearch.com>
 <CAJ3xEMiXWN9wC5u6iapKMVb4=bfzdnuy3CaZryV0nOFL_Cgmhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMiXWN9wC5u6iapKMVb4=bfzdnuy3CaZryV0nOFL_Cgmhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 12, 2015 at 03:29:25PM +0300, Or Gerlitz wrote:

> I understand the email thread went down into further details from this
> point and on, but still, I'd like to stop here and ask for short
> clarification -- my understanding of things re this reader-writer
> scheme is the following:
> 
> 1. some reader/s can't be made to sleep as they make calls in atomic context
> and hence it wouldn't be correct to use RW semaphore
> 
> 2. some writers go to sleep (invoke driver call to the firmware) and
> hence they can't be holding RW spinlock
> 
> Agree? if not, can you shortly say what's wrong in these assumptions,
> or I should just deeply read the thread.

Sure, broadly.

> B/c if these assumptions are correct, seqlock/seqcount seem to me very
> much like the right approach. It addresses the constraints 1 and 2
> above, simple/robust to implement/use

Well, it is anything but simple. There are two subtle complex things
going on with this use of seqlock:
 - If you hold a seqlock while sleeping and ignore the read-retry
   mechanism then upon update readers see three states: NEW,OLD,INVALID
- It is impossible to dev_hold attr->ndev without using RCU

You read the patch, did you understand those subtle details were
happening? It took me a few re-reads to get it..

Far better is a simple spin lock:

lock(table->lock)
spin_lock()
attr = ...;
invalid = 1;
spin_unlock();

driver->update_gid

spin_lock()
invalid = 0;
spin_unlock();
unlock(table->lock)

Which solves *exactly* the same problem and doesn't require RCU to
extract the ndev. [In this case, I think the invalid state is actually
undesirable, so I'd work to eliminate it]

I keep being suprised by this insistance on performance locking.  99%
of the time the performance locks and simple locks are
interchangeable. If you reach a situation where you think you *NEED* a
performance lock and can't see how to do it with a simple lock, almost
certainly, you are doing something wrong.

So as a reviewer, asking for simple locks should get the author to
consider their locking carefully and either produce something correct
with simple locks or solve the issues with their performance locks,
independently.

Especially with RCU, there is no excuse, there is a RCU review
checklist, and both Matan and Yishai's v1 patches *blatantly* fail points
in that list. 'RCU is used wrong, read the checklist' is all a reviewer
should have to say.

Being drawing into a stupid argument is pointless, and in future I'm
going to stop taking the bait. :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
