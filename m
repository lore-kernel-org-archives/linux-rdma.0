From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Tue, 9 Sep 2014 11:36:27 -0400
Message-ID: <20140909153627.GA3545@gmail.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B010E2442C7-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jerome Glisse <IMCEAMAILTO-j+2Eglisse+40gmail+2Ecom-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wrote:
> Hi,
>=20
> > -----Original Message-----
> > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Thursday, September 04, 2014 11:25 PM
> > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Shachar Raindel; Sagi Grimberg
> > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support f=
or
> > MMU notifiers regarding on demand paging regions
> >=20
> > > * Add an interval tree implementation for ODP umems. Create an
> > interval tree
> > >   for each ucontext (including a count of the number of ODP MRs i=
n
> > this
> > >   context, mutex, etc.), and register ODP umems in the interval t=
ree.
> > > * Add MMU notifiers handling functions, using the interval tree t=
o
> > notify only
> > >   the relevant umems and underlying MRs.
> > > * Register to receive MMU notifier events from the MM subsystem u=
pon
> > ODP MR
> > >   registration (and unregister accordingly).
> > > * Add a completion object to synchronize the destruction of ODP u=
mems.
> > > * Add mechanism to abort page faults when there's a concurrent
> > invalidation.
> > >
> > > The way we synchronize between concurrent invalidations and page
> > faults is by
> > > keeping a counter of currently running invalidations, and a seque=
nce
> > number
> > > that is incremented whenever an invalidation is caught. The page =
fault
> > code
> > > checks the counter and also verifies that the sequence number has=
n't
> > > progressed before it updates the umem's page tables. This is simi=
lar
> > to what
> > > the kvm module does.
> > >
> > > There's currently a rare race in the code when registering a umem=
 in
> > the
> > > middle of an ongoing notifier. The proper fix is to either serial=
ize
> > the
> > > insertion to our umem tree with mm_lock_all or use a ucontext wid=
e
> > running
> > > notifiers count for retries decision. Either is ugly and can lead=
 to
> > some sort
> > > of starvation. The current workaround is ugly as well - now the u=
ser
> > can end
> > > up with mapped addresses that are not in the user's address space
> > (although it
> > > is highly unlikely).
> >=20
> > I have been trying to wrap my head around this comment. I am totaly
> > unfamiliar
> > with RDMA code, but from quick look at it when registering umem you=
 take
> > the
> > mmap_sem in read mode so any munmap from userspace would be seriali=
ze.
> > Really
> > the worst that can happen is that a umem pointing to a mmaped file =
that
> > is
> > concurently truncated but even then the address is still valid, but=
 it
> > should
> > result in a SIGBUS which here is obviously harder to report (again =
dunno
> > how
> > RDMA works).
> >=20
> > So am i missing something ?
> >=20
>=20
> Sadly, taking mmap_sem in read-only mode does not prevent all possibl=
e invalidations from happening.
> For example, a call to madvise requesting MADVISE_DONTNEED will lock =
the mmap_sem for reading only, allowing a notifier to run in parallel t=
o the MR registration As a result, the following sequence of events cou=
ld happen:
>=20
> Thread 1:                       |   Thread 2
> --------------------------------+-------------------------
> madvise                         |
> down_read(mmap_sem)             |
> notifier_start                  |
>                                 |   down_read(mmap_sem)
>                                 |   register_mr
> notifier_end                    |
> reduce_mr_notifiers_count       |
>=20
> The end result of this sequence is an mr with running notifiers count=
 of -1, which is bad.
> The current workaround is to avoid decreasing the notifiers count if =
it is zero, which can cause other issues.
> The proper fix would be to prevent notifiers from running in parallel=
 to registration. For this, taking mmap_sem in write mode might be suff=
icient, but we are not sure about this.
> We will be happy to hear additional input on this subject, to make su=
re we got it covered properly.

So in HMM i solve this by having a struct allocated in the start range =
callback
and the end range callback just ignore things when it can not find the =
matching
struct.

That being said when registering the mmu_notifier you need 2 things, fi=
rst you
need a pin on the mm (either mm is current ie current->mm or you took a=
 reference
on it). Second you need to that the mmap smemaphore in write mode so th=
at
no concurrent mmap/munmap/madvise can happen. By doing that you protect=
 yourself
from concurrent range_start/range_end that can happen and that does mat=
ter.
The only concurrent range_start/end that can happen is through file inv=
alidation
which is fine because subsequent page fault will go through the file la=
yer and
bring back page or return error (if file was truncated for instance).

So as long as you hold the mmap_sem in write mode you should not worry =
about
concurrent range_start/range_end (well they might happen but only for f=
ile
backed vma).

Given that you face the same issue as i have with the range_start/range=
_end i
will stich up a patch to make it easier to track those.

Cheers,
J=E9r=F4me


>=20
> Thanks,
> --Shachar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
