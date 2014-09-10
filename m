From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Wed, 10 Sep 2014 16:14:34 -0400
Message-ID: <20140910201432.GA3801@gmail.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
 <20140909153627.GA3545@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E244E86@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B010E244E86-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 10, 2014 at 09:00:36AM +0000, Shachar Raindel wrote:
>=20
>=20
> > -----Original Message-----
> > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Tuesday, September 09, 2014 6:37 PM
> > To: Shachar Raindel
> > Cc: 1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Haggai =
Eran;
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jerome Glisse; Sagi Grimberg
> > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support f=
or
> > MMU notifiers regarding on demand paging regions
> >=20
> > On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wrote:
> > > Hi,
> > >
> > > > -----Original Message-----
> > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > Sent: Thursday, September 04, 2014 11:25 PM
> > > > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Cc: Shachar Raindel; Sagi Grimberg
> > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement suppo=
rt
> > for
> > > > MMU notifiers regarding on demand paging regions
> > > >
> > > > > * Add an interval tree implementation for ODP umems. Create a=
n
> > > > interval tree
> > > > >   for each ucontext (including a count of the number of ODP M=
Rs in
> > > > this
> > > > >   context, mutex, etc.), and register ODP umems in the interv=
al
> > tree.
> > > > > * Add MMU notifiers handling functions, using the interval tr=
ee to
> > > > notify only
> > > > >   the relevant umems and underlying MRs.
> > > > > * Register to receive MMU notifier events from the MM subsyst=
em
> > upon
> > > > ODP MR
> > > > >   registration (and unregister accordingly).
> > > > > * Add a completion object to synchronize the destruction of O=
DP
> > umems.
> > > > > * Add mechanism to abort page faults when there's a concurren=
t
> > > > invalidation.
> > > > >
> > > > > The way we synchronize between concurrent invalidations and p=
age
> > > > faults is by
> > > > > keeping a counter of currently running invalidations, and a
> > sequence
> > > > number
> > > > > that is incremented whenever an invalidation is caught. The p=
age
> > fault
> > > > code
> > > > > checks the counter and also verifies that the sequence number
> > hasn't
> > > > > progressed before it updates the umem's page tables. This is
> > similar
> > > > to what
> > > > > the kvm module does.
> > > > >
> > > > > There's currently a rare race in the code when registering a =
umem
> > in
> > > > the
> > > > > middle of an ongoing notifier. The proper fix is to either
> > serialize
> > > > the
> > > > > insertion to our umem tree with mm_lock_all or use a ucontext=
 wide
> > > > running
> > > > > notifiers count for retries decision. Either is ugly and can =
lead
> > to
> > > > some sort
> > > > > of starvation. The current workaround is ugly as well - now t=
he
> > user
> > > > can end
> > > > > up with mapped addresses that are not in the user's address s=
pace
> > > > (although it
> > > > > is highly unlikely).
> > > >
> > > > I have been trying to wrap my head around this comment. I am to=
taly
> > > > unfamiliar
> > > > with RDMA code, but from quick look at it when registering umem=
 you
> > take
> > > > the
> > > > mmap_sem in read mode so any munmap from userspace would be
> > serialize.
> > > > Really
> > > > the worst that can happen is that a umem pointing to a mmaped f=
ile
> > that
> > > > is
> > > > concurently truncated but even then the address is still valid,=
 but
> > it
> > > > should
> > > > result in a SIGBUS which here is obviously harder to report (ag=
ain
> > dunno
> > > > how
> > > > RDMA works).
> > > >
> > > > So am i missing something ?
> > > >
> > >
> > > Sadly, taking mmap_sem in read-only mode does not prevent all pos=
sible
> > invalidations from happening.
> > > For example, a call to madvise requesting MADVISE_DONTNEED will l=
ock
> > the mmap_sem for reading only, allowing a notifier to run in parall=
el to
> > the MR registration As a result, the following sequence of events c=
ould
> > happen:
> > >
> > > Thread 1:                       |   Thread 2
> > > --------------------------------+-------------------------
> > > madvise                         |
> > > down_read(mmap_sem)             |
> > > notifier_start                  |
> > >                                 |   down_read(mmap_sem)
> > >                                 |   register_mr
> > > notifier_end                    |
> > > reduce_mr_notifiers_count       |
> > >
> > > The end result of this sequence is an mr with running notifiers c=
ount
> > of -1, which is bad.
> > > The current workaround is to avoid decreasing the notifiers count=
 if
> > it is zero, which can cause other issues.
> > > The proper fix would be to prevent notifiers from running in para=
llel
> > to registration. For this, taking mmap_sem in write mode might be
> > sufficient, but we are not sure about this.
> > > We will be happy to hear additional input on this subject, to mak=
e
> > sure we got it covered properly.
> >=20
> > So in HMM i solve this by having a struct allocated in the start ra=
nge
> > callback
> > and the end range callback just ignore things when it can not find =
the
> > matching
> > struct.
>=20
> This kind of mechanism sounds like it has a bigger risk for deadlocki=
ng
> the system, causing an OOM kill without a real need or significantly=20
> slowing down the system.
> If you are doing non-atomic memory allocations, you can deadlock the
> system by requesting memory in the swapper flow.
> Even if you are doing atomic memory allocations, you need to handle t=
he
> case of failing allocation, the solution to which is unclear to me.
> If you are using a pre-allocated pool, what are you doing when you ru=
n
> out of available entries in the pool? If you are blocking until some
> entries free up, what guarantees you that this will not cause a deadl=
ock?

So i am using a fixed pool and when it runs out it block in start callb=
ack
until one is freed. But as i said i have a patch to use the stack that =
will
solve this and avoid a pool.

>=20
> >=20
> > That being said when registering the mmu_notifier you need 2 things=
,
> > first you
> > need a pin on the mm (either mm is current ie current->mm or you to=
ok a
> > reference
> > on it). Second you need to that the mmap smemaphore in write mode s=
o
> > that
> > no concurrent mmap/munmap/madvise can happen. By doing that you pro=
tect
> > yourself
> > from concurrent range_start/range_end that can happen and that does
> > matter.
> > The only concurrent range_start/end that can happen is through file
> > invalidation
> > which is fine because subsequent page fault will go through the fil=
e
> > layer and
> > bring back page or return error (if file was truncated for instance=
).
>=20
> Sadly, this is not sufficient for our use case. We are registering
> a single MMU notifier handler, and broadcast the notifications to
> all relevant listeners, which are stored in an interval tree.
>
> Each listener represents a section of the address space that has been
> exposed to the network. Such implementation allows us to limit the im=
pact
> of invalidations, and only block racing page faults to the affected a=
reas.
>=20
> Each of the listeners maintain a counter of the number of invalidate_=
range
> notifications that are currently affecting it. The counter is increas=
ed
> for each invalidate_range_start callback received, and decrease for e=
ach
> invalidate_range_end callback received. If we add a listener to the
> interval tree after the invalidate_range_start callback happened, but
> before the invalidate_range_end callback happened, it will decrease t=
he
> counter, reaching negative numbers and breaking the logic.
>=20
> The mmu_notifiers registration code avoid such issues by taking all
> relevant locks on the MM. This effectively blocks all possible notifi=
ers
> from happening when registering a new notifier. Sadly, this function =
is
> not exported for modules to use it.
>=20
> Our options at the moment are:
> - Use a tracking mechanism similar to what HMM uses, alongside the
>   challenges involved in allocating memory from notifiers
>=20
> - Use a per-process counter for invalidations, causing a possible
>   performance degradation. This can possibly be used as a fallback to=
 the
>   first option (i.e. have a pool of X notifier identifiers, once it i=
s
>   full, increase/decrease a per-MM counter)
>=20
> - Export the mm_take_all_locks function for modules. This will allow =
us
>   to lock the MM when adding a new listener.

I was not clear enough, you need to take the mmap_sem in write mode acc=
ross
mmu_notifier_register(). This is only to partialy solve your issue that=
 if
a mmu_notifier is already register for the mm you are trying to registe=
ring
against then there is a chance for you to be inside an active range_sta=
rt/
range_end section which would lead to invalid counter inside your track=
ing
structure. But, sadly, taking mmap_sem in write mode is not enough as f=
ile
invalidation might still happen concurrently so you will need to make s=
ure
you invalidation counters does not go negative but from page fault poin=
t of
view you will be fine because the page fault will synchronize through t=
he
pagecache. So scenario (A and B are to anonymous overlapping address ra=
nge) :

  APP_TOTO_RDMA_THREAD           |  APP_TOTO_SOME_OTHER_THREAD
                                 |  mmu_notifier_invalidate_range_start=
(A)
  odp_register()                 |
    down_read(mmap_sem)          |
    mmu_notifier_register()      |
    up_read(mmap_sem)            |
  odp_add_new_region(B)          |
  odp_page_fault(B)              |
    down_read(mmap_sem)          |
    ...                          |
    up_read(mmap_sem)            |
                                 |  mmu_notifier_invalidate_range_end(A=
)

The odp_page_fault(B) might see invalid cpu page table but you have no =
idea
about it because you registered after the range_start(). But if you tak=
e the
mmap_sem in write mode then the only case where you might still have th=
is
scenario is if A and B are range of a file backed vma and that the file=
 is
undergoing some change (most likely truncation). But the file case is f=
ine
because the odp_page_fault() will go through the pagecache which is pro=
perly
synchronize against the current range invalidation.


Now for the the general case outside of mmu_notifier_register() HMM als=
o track
active invalidation range to avoid page faulting into those range as we=
 can not
trust the cpu page table for as long as the range invalidation is on go=
ing.

> >=20
> > So as long as you hold the mmap_sem in write mode you should not wo=
rry
> > about
> > concurrent range_start/range_end (well they might happen but only f=
or
> > file
> > backed vma).
> >=20
>=20
> Sadly, the mmap_sem is not enough to protect us :(.

This is enough like i explain above, but i am only talking about the mm=
u
notifier registration. For the general case once you register you only
need to take the mmap_sem in read mode during page fault.

> > Given that you face the same issue as i have with the
> > range_start/range_end i
> > will stich up a patch to make it easier to track those.
> >=20
>=20
> That would be nice, especially if we could easily integrate it into o=
ur
> code and reduce the code size.

Yes it's a "small modification" to the mmu_notifier api, i have been si=
de
tracked on other thing. But i will have it soon.

>=20
> > Cheers,
> > J=E9r=F4me
> >=20
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
