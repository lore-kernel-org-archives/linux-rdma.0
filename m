From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Wed, 10 Sep 2014 09:00:36 +0000
Message-ID: <6B2A6E60C06CCC42AE31809BF572352B010E244E86@MTLDAG02.mtl.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
 <20140909153627.GA3545@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140909153627.GA3545-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Tuesday, September 09, 2014 6:37 PM
> To: Shachar Raindel
> Cc: 1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Haggai Er=
an;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jerome Glisse; Sagi Grimberg
> Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for
> MMU notifiers regarding on demand paging regions
>=20
> On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > Sent: Thursday, September 04, 2014 11:25 PM
> > > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Cc: Shachar Raindel; Sagi Grimberg
> > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support
> for
> > > MMU notifiers regarding on demand paging regions
> > >
> > > > * Add an interval tree implementation for ODP umems. Create an
> > > interval tree
> > > >   for each ucontext (including a count of the number of ODP MRs=
 in
> > > this
> > > >   context, mutex, etc.), and register ODP umems in the interval
> tree.
> > > > * Add MMU notifiers handling functions, using the interval tree=
 to
> > > notify only
> > > >   the relevant umems and underlying MRs.
> > > > * Register to receive MMU notifier events from the MM subsystem
> upon
> > > ODP MR
> > > >   registration (and unregister accordingly).
> > > > * Add a completion object to synchronize the destruction of ODP
> umems.
> > > > * Add mechanism to abort page faults when there's a concurrent
> > > invalidation.
> > > >
> > > > The way we synchronize between concurrent invalidations and pag=
e
> > > faults is by
> > > > keeping a counter of currently running invalidations, and a
> sequence
> > > number
> > > > that is incremented whenever an invalidation is caught. The pag=
e
> fault
> > > code
> > > > checks the counter and also verifies that the sequence number
> hasn't
> > > > progressed before it updates the umem's page tables. This is
> similar
> > > to what
> > > > the kvm module does.
> > > >
> > > > There's currently a rare race in the code when registering a um=
em
> in
> > > the
> > > > middle of an ongoing notifier. The proper fix is to either
> serialize
> > > the
> > > > insertion to our umem tree with mm_lock_all or use a ucontext w=
ide
> > > running
> > > > notifiers count for retries decision. Either is ugly and can le=
ad
> to
> > > some sort
> > > > of starvation. The current workaround is ugly as well - now the
> user
> > > can end
> > > > up with mapped addresses that are not in the user's address spa=
ce
> > > (although it
> > > > is highly unlikely).
> > >
> > > I have been trying to wrap my head around this comment. I am tota=
ly
> > > unfamiliar
> > > with RDMA code, but from quick look at it when registering umem y=
ou
> take
> > > the
> > > mmap_sem in read mode so any munmap from userspace would be
> serialize.
> > > Really
> > > the worst that can happen is that a umem pointing to a mmaped fil=
e
> that
> > > is
> > > concurently truncated but even then the address is still valid, b=
ut
> it
> > > should
> > > result in a SIGBUS which here is obviously harder to report (agai=
n
> dunno
> > > how
> > > RDMA works).
> > >
> > > So am i missing something ?
> > >
> >
> > Sadly, taking mmap_sem in read-only mode does not prevent all possi=
ble
> invalidations from happening.
> > For example, a call to madvise requesting MADVISE_DONTNEED will loc=
k
> the mmap_sem for reading only, allowing a notifier to run in parallel=
 to
> the MR registration As a result, the following sequence of events cou=
ld
> happen:
> >
> > Thread 1:                       |   Thread 2
> > --------------------------------+-------------------------
> > madvise                         |
> > down_read(mmap_sem)             |
> > notifier_start                  |
> >                                 |   down_read(mmap_sem)
> >                                 |   register_mr
> > notifier_end                    |
> > reduce_mr_notifiers_count       |
> >
> > The end result of this sequence is an mr with running notifiers cou=
nt
> of -1, which is bad.
> > The current workaround is to avoid decreasing the notifiers count i=
f
> it is zero, which can cause other issues.
> > The proper fix would be to prevent notifiers from running in parall=
el
> to registration. For this, taking mmap_sem in write mode might be
> sufficient, but we are not sure about this.
> > We will be happy to hear additional input on this subject, to make
> sure we got it covered properly.
>=20
> So in HMM i solve this by having a struct allocated in the start rang=
e
> callback
> and the end range callback just ignore things when it can not find th=
e
> matching
> struct.

This kind of mechanism sounds like it has a bigger risk for deadlocking
the system, causing an OOM kill without a real need or significantly=20
slowing down the system.
If you are doing non-atomic memory allocations, you can deadlock the
system by requesting memory in the swapper flow.
Even if you are doing atomic memory allocations, you need to handle the
case of failing allocation, the solution to which is unclear to me.
If you are using a pre-allocated pool, what are you doing when you run
out of available entries in the pool? If you are blocking until some
entries free up, what guarantees you that this will not cause a deadloc=
k?

>=20
> That being said when registering the mmu_notifier you need 2 things,
> first you
> need a pin on the mm (either mm is current ie current->mm or you took=
 a
> reference
> on it). Second you need to that the mmap smemaphore in write mode so
> that
> no concurrent mmap/munmap/madvise can happen. By doing that you prote=
ct
> yourself
> from concurrent range_start/range_end that can happen and that does
> matter.
> The only concurrent range_start/end that can happen is through file
> invalidation
> which is fine because subsequent page fault will go through the file
> layer and
> bring back page or return error (if file was truncated for instance).

Sadly, this is not sufficient for our use case. We are registering
a single MMU notifier handler, and broadcast the notifications to
all relevant listeners, which are stored in an interval tree.

Each listener represents a section of the address space that has been
exposed to the network. Such implementation allows us to limit the impa=
ct
of invalidations, and only block racing page faults to the affected are=
as.

Each of the listeners maintain a counter of the number of invalidate_ra=
nge
notifications that are currently affecting it. The counter is increased
for each invalidate_range_start callback received, and decrease for eac=
h
invalidate_range_end callback received. If we add a listener to the
interval tree after the invalidate_range_start callback happened, but
before the invalidate_range_end callback happened, it will decrease the
counter, reaching negative numbers and breaking the logic.

The mmu_notifiers registration code avoid such issues by taking all
relevant locks on the MM. This effectively blocks all possible notifier=
s
from happening when registering a new notifier. Sadly, this function is
not exported for modules to use it.

Our options at the moment are:
- Use a tracking mechanism similar to what HMM uses, alongside the
  challenges involved in allocating memory from notifiers

- Use a per-process counter for invalidations, causing a possible
  performance degradation. This can possibly be used as a fallback to t=
he
  first option (i.e. have a pool of X notifier identifiers, once it is
  full, increase/decrease a per-MM counter)

- Export the mm_take_all_locks function for modules. This will allow us
  to lock the MM when adding a new listener.

>=20
> So as long as you hold the mmap_sem in write mode you should not worr=
y
> about
> concurrent range_start/range_end (well they might happen but only for
> file
> backed vma).
>=20

Sadly, the mmap_sem is not enough to protect us :(.

> Given that you face the same issue as i have with the
> range_start/range_end i
> will stich up a patch to make it easier to track those.
>=20

That would be nice, especially if we could easily integrate it into our
code and reduce the code size.

> Cheers,
> J=E9r=F4me
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
