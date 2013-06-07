From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: Revert pinned_vm braindamage
Date: Fri, 7 Jun 2013 14:52:05 +0000
Message-ID: <0000013f1f1f79d1-2cf8cb8c-7e63-4e83-9f2b-7acc0e0638a1-000000@email.amazonses.com>
References: <20130606124351.GZ27176@twins.programming.kicks-ass.net> <0000013f1ad00ec0-9574a936-3a75-4ccc-a84c-4a12a7ea106e-000000@email.amazonses.com> <20130607110344.GA27176@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130607110344.GA27176-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 7 Jun 2013, Peter Zijlstra wrote:

> However you twist this; your patch leaves an inconsistent mess. If you
> really think they're two different things then you should have
> introduced a second RLIMIT_MEMPIN to go along with your counter.

Well continuing to repeat myself: I worked based on agreed upon
characteristics of mlocked pages. The patch was there to address a
brokenness in the mlock accounting because someone naively assumed that
pinning = mlock.

> I'll argue against such a thing; for I think that limiting the total
> amount of pages a user can exempt from paging is the far more
> userful/natural thing to measure/limit.

Pinned pages are exempted by the kernel. A device driver or some other
kernel process (reclaim, page migration, io etc) increase the page count.
There is currently no consistent accounting for pinned pages. The
vm_pinned counter was introduced to allow the largest pinners to track
what they did.

> > I said that the use of a PIN page flag would allow correct accounting if
> > one wanted to interpret the limit the way you do.
>
> You failed to explain how that would help any. With a pin page flag you
> still need to find the mm to unaccount crap from. Also, all user
> controlled address space ops operate on vmas.

Pinning is kernel controlled...

> > Page migration is not a page fault?
>
> It introduces faults; what happens when a process hits the migration
> pte? It gets a random delay and eventually services a minor fault to the
> new page.

Ok but this is similar to reclaim and other such things that are unmapping
pages.

> At which point the saw will have cut your finger off (going with the
> most popular RT application ever -- that of a bandsaw and a laser beam).

I am pretty confused by your newer notion of RT. RT was about high latency
deterministic behavior I thought. RT was basically an abused marketing
term and was referring to the bloating of the kernel with all sorts of
fair stuff that slows us down. What happened to make you work on low
latency stuff? There is some shift that you still need to go through to
make that transition. Yes, you would want to avoid reclaim and all sorts
of other stuff for low latency. So you disable auto NUMA, defrag etc to
avoid these things.

> > > This leaves the RT people unhappy -- therefore _if_ we continue with
> > > this Linux specific interpretation of mlock() we must introduce new
> > > syscalls that implement the intended mlock() semantics.
> >
> > Intended means Peter's semantics?
>
> No, I don't actually write RT applications. But I've had plenty of
> arguments with RT people when I explained to them what our mlock()
> actually does vs what they expected it to do.

Ok Guess this is all new to you at this point. I am happy to see that you
are willing to abandon your evil ways (although under pressure from your
users) and are willing to put the low latency people now in the RT camp.

> They're not happy. Aside from that; you HPC/HFT minimal latency lot
> should very well appreciate the minimal interference stuff they do
> actually expect.

Sure we do and we know how to do things to work around the "fair
scheduler" and other stuff. But you are breaking the basics of how we do
things with your conflation of pinning and mlocking.

We do not migrate, do not allow defragmentation or reclaim when running
low latency applications. These are non issues.

> This might well be; and I'm not arguing we remove this. I'm merely
> stating that it doesn't make everybody happy. Also what purpose do HPC
> type applications have for mlock()?

HPC wants to keep them in memory to avoid eviction. HPC apps are not as
sensitive to faults as low latency apps are. Minor faults have
traditionally be tolerated there. The lower you get in terms of the
latencies required the more difficult the OS control becomes.

> Here we must disagree I fear; given that mlock() is of RT origin and RT
> people very much want/expect mlock() to do what our proposed mpin() will
> do.

RT is a dirty word for me given the fairness and bloat issue. Not sure
what you mean with that. mlock is a means to keep data in memory and not a
magical wand that avoids all OS handling of the page.

> > That cannot be so since mlocked pages need to be migratable.
>
> I'm talking about the proposed mpin() stuff.

Could you write that up in detail? I am not sure how this could work at
this point.

> So I proposed most of the machinery that would be required to actually
> implement the syscalls. Except that the IB code stumped me. In
> particular I cannot easily find the userspace address to unpin for
> ipath/qib release paths.
>
> Once we have that we can trivially implement the syscalls.

Why would you need syscalls? Pinning is driver/kernel subsystem initiated
and therefore the driver can do the pin/unpin calls.

> > Pinning is not initiated by user space but by the kernel. Either
> > temporarily (page count increases are used all over the kernel for this)
> > or for longer time frame (IB and Perf and likely more drivers that we have
> > not found yet).
>
> Here I disagree, I'll argue that all pins that require userspace action
> to go away are userspace controlled pins. This makes IB/Perf user
> controlled pins and should thus be treated the same as mpin()/munpin()
> calls.

Both IB and Perf are kernel subsystems that pin as a side effect of
another syscall.

> This goes back to what you want the limit to mean; I think a single
> limit counting all pages exempt from paging is the far more useful
> limit.

Then you first need to show that the scheme account for *all* pages exempt
from paging. This includes dirty pages and various pages of other
subsystems that have an increased refcount in order to keep these pages
were they are. We need a couple of passes through the kernel to find these
locations and build up counter for these. Not all of these pages will be
associated with processes.

> The only way to get an MCL_FUTURE is through CAP_IPC_LOCK. Practically
> most MCL_CURRENT are also larger than RLIMIT_MEMLOCK and this also
> requires CAP_IPC_LOCK.
>
> Once you have CAP_IPC_LOCK, RLIMIT_MEMLOCK becomes irrelevant.

mlockall does not require CAP_IPC_LOCK. Never had an issue.

> > The semantics we agreed upon for mlock were that they are migratable.
> > Pinned pages cannot be migrated and therefore are not mlocked pages.
> > It would be best to have two different mechanisms for this.
>
> Best for whoem? How is making two RLIMIT settings better than having
> one?

The pinned pages do not need to have a separate limit. They are kernel
resources and could be bounded in other ways together with other resources
that could cause danger to the kernel (such as too many dirty pages).
Pinned pages are often not associated with a process.

> > We do not need a new API.
>
> This is in direct contradiction with your earlier statement where you
> say: "I agree that we need mpin and munpin.".
>
> Please make up your mind.

Yes we need mpin and munpin as a in kernel API. Glad to clue you in.

> > Having the ability in
> > general to move processes is a degree of control that we want. Pinning
> > could be restricted to where it is required by the hardware.
>
> Or software; you cannot blindly dismiss realtime guarantees the software
> needs to provide.

I cringe when I hear realtime guarantees and intending that to refer to
low latency.... But maybe they turned you finally? And I may just feeling
my decade old frustration with your old approach to "realtime".

What do you exactly mean by realtime guarantees? (Given that "realtime" is
such an overloaded marketing term).

> > Excessive amounts of pinned pages limit the ability of the kernel
> > to manage its memory severely which may cause instabilities. mlocked pages
> > are better because the kernel still has some options.
>
> I'm not arguing which are better; I've even conceded we need mpin() and
> can keep the current mlock() semantics. I'm arguing for what we _need_.

We need the kernel to track the pinned pages (all of them not just those
from IB and perf) and provide proper global boundaries to avoid kernel
failures. Yes.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
