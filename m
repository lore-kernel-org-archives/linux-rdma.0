From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Thu, 11 Sep 2014 12:19:01 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B010E2456AE@MTLDAG02.mtl.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
 <20140909153627.GA3545@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E244E86@MTLDAG02.mtl.com>
 <20140910201432.GA3801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140910201432.GA3801-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Wednesday, September 10, 2014 11:15 PM
> To: Shachar Raindel
> Cc: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sagi Grimberg
> Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for
> MMU notifiers regarding on demand paging regions
>=20
> On Wed, Sep 10, 2014 at 09:00:36AM +0000, Shachar Raindel wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > Sent: Tuesday, September 09, 2014 6:37 PM
> > > To: Shachar Raindel
> > > Cc: 1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Hagga=
i
> Eran;
> > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jerome Glisse; Sagi Grimberg
> > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support
> for
> > > MMU notifiers regarding on demand paging regions
> > >
> > > On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wrote:
> > > > Hi,
> > > >
> > > > > -----Original Message-----
> > > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > > Sent: Thursday, September 04, 2014 11:25 PM
> > > > > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > Cc: Shachar Raindel; Sagi Grimberg
> > > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement
> support
> > > for
> > > > > MMU notifiers regarding on demand paging regions
> > > > >

<SNIP>

> > > >
> > > > Sadly, taking mmap_sem in read-only mode does not prevent all
> possible
> > > invalidations from happening.
> > > > For example, a call to madvise requesting MADVISE_DONTNEED will
> lock
> > > the mmap_sem for reading only, allowing a notifier to run in
> parallel to
> > > the MR registration As a result, the following sequence of events
> could
> > > happen:
> > > >
> > > > Thread 1:                       |   Thread 2
> > > > --------------------------------+-------------------------
> > > > madvise                         |
> > > > down_read(mmap_sem)             |
> > > > notifier_start                  |
> > > >                                 |   down_read(mmap_sem)
> > > >                                 |   register_mr
> > > > notifier_end                    |
> > > > reduce_mr_notifiers_count       |
> > > >
> > > > The end result of this sequence is an mr with running notifiers
> count
> > > of -1, which is bad.
> > > > The current workaround is to avoid decreasing the notifiers cou=
nt
> if
> > > it is zero, which can cause other issues.
> > > > The proper fix would be to prevent notifiers from running in
> parallel
> > > to registration. For this, taking mmap_sem in write mode might be
> > > sufficient, but we are not sure about this.
> > > > We will be happy to hear additional input on this subject, to m=
ake
> > > sure we got it covered properly.
> > >
> > > So in HMM i solve this by having a struct allocated in the start
> range
> > > callback
> > > and the end range callback just ignore things when it can not fin=
d
> the
> > > matching
> > > struct.
> >
> > This kind of mechanism sounds like it has a bigger risk for
> deadlocking
> > the system, causing an OOM kill without a real need or significantl=
y
> > slowing down the system.
> > If you are doing non-atomic memory allocations, you can deadlock th=
e
> > system by requesting memory in the swapper flow.
> > Even if you are doing atomic memory allocations, you need to handle
> the
> > case of failing allocation, the solution to which is unclear to me.
> > If you are using a pre-allocated pool, what are you doing when you =
run
> > out of available entries in the pool? If you are blocking until som=
e
> > entries free up, what guarantees you that this will not cause a
> deadlock?
>=20
> So i am using a fixed pool and when it runs out it block in start
> callback
> until one is freed.=20

This sounds scary. You now create a possible locking dependency between
two code flows which could have run in parallel. This can cause circula=
r
locking bugs, from code which functioned properly until now. For exampl=
e,
assume code with a single lock, and the following code paths:

Code 1:
notify_start()
lock()
unlock()
notify_end()

Code 2:
lock()
notify_start()
=2E.. (no locking)
notify_end()
unlock()



This code can now create the following deadlock:

Thread 1:        | Thread 2:
-----------------+-----------------------------------
notify_start()   |
                 | lock()
lock() - blocking|
                 | notify_start() - blocking for slot




> But as i said i have a patch to use the stack that
> will
> solve this and avoid a pool.

How are you allocating from the stack an entry which you need to keep a=
live
until another function is called? You can't allocate the entry on the
notify_start stack, so you must do this in all of the call points to th=
e
mmu_notifiers. Given the notifiers listener subscription pattern, this =
seems
like something which is not practical.

=20
>=20
> >
> > >
> > > That being said when registering the mmu_notifier you need 2 thin=
gs,
> > > first you
> > > need a pin on the mm (either mm is current ie current->mm or you
> took a
> > > reference
> > > on it). Second you need to that the mmap smemaphore in write mode=
 so
> > > that
> > > no concurrent mmap/munmap/madvise can happen. By doing that you
> protect
> > > yourself
> > > from concurrent range_start/range_end that can happen and that do=
es
> > > matter.
> > > The only concurrent range_start/end that can happen is through fi=
le
> > > invalidation
> > > which is fine because subsequent page fault will go through the f=
ile
> > > layer and
> > > bring back page or return error (if file was truncated for
> instance).
> >
> > Sadly, this is not sufficient for our use case. We are registering
> > a single MMU notifier handler, and broadcast the notifications to
> > all relevant listeners, which are stored in an interval tree.
> >
> > Each listener represents a section of the address space that has be=
en
> > exposed to the network. Such implementation allows us to limit the
> impact
> > of invalidations, and only block racing page faults to the affected
> areas.
> >
> > Each of the listeners maintain a counter of the number of
> invalidate_range
> > notifications that are currently affecting it. The counter is
> increased
> > for each invalidate_range_start callback received, and decrease for
> each
> > invalidate_range_end callback received. If we add a listener to the
> > interval tree after the invalidate_range_start callback happened, b=
ut
> > before the invalidate_range_end callback happened, it will decrease
> the
> > counter, reaching negative numbers and breaking the logic.
> >
> > The mmu_notifiers registration code avoid such issues by taking all
> > relevant locks on the MM. This effectively blocks all possible
> notifiers
> > from happening when registering a new notifier. Sadly, this functio=
n
> is
> > not exported for modules to use it.
> >
> > Our options at the moment are:
> > - Use a tracking mechanism similar to what HMM uses, alongside the
> >   challenges involved in allocating memory from notifiers
> >
> > - Use a per-process counter for invalidations, causing a possible
> >   performance degradation. This can possibly be used as a fallback =
to
> the
> >   first option (i.e. have a pool of X notifier identifiers, once it=
 is
> >   full, increase/decrease a per-MM counter)
> >
> > - Export the mm_take_all_locks function for modules. This will allo=
w
> us
> >   to lock the MM when adding a new listener.
>=20
> I was not clear enough, you need to take the mmap_sem in write mode
> accross
> mmu_notifier_register(). This is only to partialy solve your issue th=
at
> if
> a mmu_notifier is already register for the mm you are trying to
> registering
> against then there is a chance for you to be inside an active
> range_start/
> range_end section which would lead to invalid counter inside your
> tracking
> structure. But, sadly, taking mmap_sem in write mode is not enough as
> file
> invalidation might still happen concurrently so you will need to make
> sure
> you invalidation counters does not go negative but from page fault po=
int
> of
> view you will be fine because the page fault will synchronize through
> the
> pagecache. So scenario (A and B are to anonymous overlapping address
> range) :
>=20
>   APP_TOTO_RDMA_THREAD           |  APP_TOTO_SOME_OTHER_THREAD
>                                  |  mmu_notifier_invalidate_range_sta=
rt(A)
>   odp_register()                 |
>     down_read(mmap_sem)          |
>     mmu_notifier_register()      |
>     up_read(mmap_sem)            |
>   odp_add_new_region(B)          |
>   odp_page_fault(B)              |
>     down_read(mmap_sem)          |
>     ...                          |
>     up_read(mmap_sem)            |
>                                  |  mmu_notifier_invalidate_range_end=
(A)
>=20
> The odp_page_fault(B) might see invalid cpu page table but you have n=
o
> idea
> about it because you registered after the range_start(). But if you t=
ake
> the
> mmap_sem in write mode then the only case where you might still have
> this
> scenario is if A and B are range of a file backed vma and that the fi=
le
> is
> undergoing some change (most likely truncation). But the file case is
> fine
> because the odp_page_fault() will go through the pagecache which is
> properly
> synchronize against the current range invalidation.

Specifically, if you call mmu_notifier_register you are OK and the abov=
e
scenario will not happen. You are supposed to hold mmap_sem for writing=
,
and mmu_notifier_register is calling mm_take_all_locks, which guarantee=
s
no racing notifier during the registration step.

However, we want to dynamically add sub-notifiers in our code. Each wil=
l
get notified only about invalidations touching a specific sub-sections =
of
the address space. To avoid providing unneeded notifications, we use an
interval tree that filters only the needed notifications.
When adding entries to the interval tree, we cannot lock the mm to prev=
ent
any racing invalidations. As such, we might end up in a case where a ne=
wly
registered memory region will get a "notify_end" call without the relev=
ant
"notify_start". Even if we prevent the value from dropping below zero, =
it
means we can cause data corruption. For example, if we have another
notifier running after the MR registers, which is due to munmap, but we=
 get
first the notify_end of the previous notifier for which we didn't see t=
he
notify_start.

The solution we are coming up with now is using a global counter of run=
ning
invalidations for new regions allocated. When the global counter is at =
zero,
we can safely switch to the region local invalidations counter.


>=20
>=20
> Now for the the general case outside of mmu_notifier_register() HMM a=
lso
> track
> active invalidation range to avoid page faulting into those range as =
we
> can not
> trust the cpu page table for as long as the range invalidation is on
> going.
>=20
> > >
> > > So as long as you hold the mmap_sem in write mode you should not
> worry
> > > about
> > > concurrent range_start/range_end (well they might happen but only
> for
> > > file
> > > backed vma).
> > >
> >
> > Sadly, the mmap_sem is not enough to protect us :(.
>=20
> This is enough like i explain above, but i am only talking about the =
mmu
> notifier registration. For the general case once you register you onl=
y
> need to take the mmap_sem in read mode during page fault.
>=20

I think we are not broadcasting on the same wavelength here. The issue =
I'm
worried about is of adding a sub-area to our tracking system. It is bui=
lt
quite differently from how HMM is built, we are defining areas to track
a-priori, and later on account how many notifiers are blocking page-fau=
lts
for each area. You are keeping track of the active notifiers, and check
each page fault against your notifier list. This difference makes for
different locking needs.

> > > Given that you face the same issue as i have with the
> > > range_start/range_end i
> > > will stich up a patch to make it easier to track those.
> > >
> >
> > That would be nice, especially if we could easily integrate it into
> our
> > code and reduce the code size.
>=20
> Yes it's a "small modification" to the mmu_notifier api, i have been
> side
> tracked on other thing. But i will have it soon.
>=20

Being side tracked is a well-known professional risk in our line of wor=
k ;)


> >
> > > Cheers,
> > > J=E9r=F4me
> > >
> > >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
