From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Thu, 11 Sep 2014 18:43:52 -0400
Message-ID: <20140911224341.GA2558@gmail.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
 <20140909153627.GA3545@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E244E86@MTLDAG02.mtl.com>
 <20140910201432.GA3801@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2456AE@MTLDAG02.mtl.com>
 <20140911153255.GB1969@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140911153255.GB1969-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 11, 2014 at 11:32:56AM -0400, Jerome Glisse wrote:
> On Thu, Sep 11, 2014 at 12:19:01PM +0000, Shachar Raindel wrote:
> >=20
> >=20
> > > -----Original Message-----
> > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > Sent: Wednesday, September 10, 2014 11:15 PM
> > > To: Shachar Raindel
> > > Cc: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sagi Grimberg
> > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support=
 for
> > > MMU notifiers regarding on demand paging regions
> > >=20
> > > On Wed, Sep 10, 2014 at 09:00:36AM +0000, Shachar Raindel wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > > Sent: Tuesday, September 09, 2014 6:37 PM
> > > > > To: Shachar Raindel
> > > > > Cc: 1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; H=
aggai
> > > Eran;
> > > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jerome Glisse; Sagi Grimberg
> > > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement sup=
port
> > > for
> > > > > MMU notifiers regarding on demand paging regions
> > > > >
> > > > > On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wro=
te:
> > > > > > Hi,
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > > > > Sent: Thursday, September 04, 2014 11:25 PM
> > > > > > > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > > Cc: Shachar Raindel; Sagi Grimberg
> > > > > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement
> > > support
> > > > > for
> > > > > > > MMU notifiers regarding on demand paging regions
> > > > > > >
> >=20
> > <SNIP>
> >=20
> > > > > >
> > > > > > Sadly, taking mmap_sem in read-only mode does not prevent a=
ll
> > > possible
> > > > > invalidations from happening.
> > > > > > For example, a call to madvise requesting MADVISE_DONTNEED =
will
> > > lock
> > > > > the mmap_sem for reading only, allowing a notifier to run in
> > > parallel to
> > > > > the MR registration As a result, the following sequence of ev=
ents
> > > could
> > > > > happen:
> > > > > >
> > > > > > Thread 1:                       |   Thread 2
> > > > > > --------------------------------+-------------------------
> > > > > > madvise                         |
> > > > > > down_read(mmap_sem)             |
> > > > > > notifier_start                  |
> > > > > >                                 |   down_read(mmap_sem)
> > > > > >                                 |   register_mr
> > > > > > notifier_end                    |
> > > > > > reduce_mr_notifiers_count       |
> > > > > >
> > > > > > The end result of this sequence is an mr with running notif=
iers
> > > count
> > > > > of -1, which is bad.
> > > > > > The current workaround is to avoid decreasing the notifiers=
 count
> > > if
> > > > > it is zero, which can cause other issues.
> > > > > > The proper fix would be to prevent notifiers from running i=
n
> > > parallel
> > > > > to registration. For this, taking mmap_sem in write mode migh=
t be
> > > > > sufficient, but we are not sure about this.
> > > > > > We will be happy to hear additional input on this subject, =
to make
> > > > > sure we got it covered properly.
> > > > >
> > > > > So in HMM i solve this by having a struct allocated in the st=
art
> > > range
> > > > > callback
> > > > > and the end range callback just ignore things when it can not=
 find
> > > the
> > > > > matching
> > > > > struct.
> > > >
> > > > This kind of mechanism sounds like it has a bigger risk for
> > > deadlocking
> > > > the system, causing an OOM kill without a real need or signific=
antly
> > > > slowing down the system.
> > > > If you are doing non-atomic memory allocations, you can deadloc=
k the
> > > > system by requesting memory in the swapper flow.
> > > > Even if you are doing atomic memory allocations, you need to ha=
ndle
> > > the
> > > > case of failing allocation, the solution to which is unclear to=
 me.
> > > > If you are using a pre-allocated pool, what are you doing when =
you run
> > > > out of available entries in the pool? If you are blocking until=
 some
> > > > entries free up, what guarantees you that this will not cause a
> > > deadlock?
> > >=20
> > > So i am using a fixed pool and when it runs out it block in start
> > > callback
> > > until one is freed.=20
> >=20
> > This sounds scary. You now create a possible locking dependency bet=
ween
> > two code flows which could have run in parallel. This can cause cir=
cular
> > locking bugs, from code which functioned properly until now. For ex=
ample,
> > assume code with a single lock, and the following code paths:
> >=20
> > Code 1:
> > notify_start()
> > lock()
> > unlock()
> > notify_end()
> >=20
> > Code 2:
> > lock()
> > notify_start()
> > ... (no locking)
> > notify_end()
> > unlock()
> >=20
>=20
> This can not happen because all lock taken before notify_start() are
> never taken after it and all lock taken inside a start/end section
> are never hold accross a notify_start() callback.
>=20
> >=20
> >=20
> > This code can now create the following deadlock:
> >=20
> > Thread 1:        | Thread 2:
> > -----------------+-----------------------------------
> > notify_start()   |
> >                  | lock()
> > lock() - blocking|
> >                  | notify_start() - blocking for slot
> >=20
> >=20
> >=20
> >=20
> > > But as i said i have a patch to use the stack that
> > > will
> > > solve this and avoid a pool.
> >=20
> > How are you allocating from the stack an entry which you need to ke=
ep alive
> > until another function is called? You can't allocate the entry on t=
he
> > notify_start stack, so you must do this in all of the call points t=
o the
> > mmu_notifiers. Given the notifiers listener subscription pattern, t=
his seems
> > like something which is not practical.
>=20
> Yes the patch add a struct in each callsite of mmu_notifier_invalidat=
e_range
> as in all case both start and end are call from same function. The on=
ly draw
> back is that it increase stack consumption in some of those callsite =
(not all).
> I attach the patch i am thinking of (it is untested) but idea is that=
 through
> two new helper function user of mmu_notifier can query active invalid=
 range and
> synchronize with those (also require some code in the range_start() c=
allback).
>=20
> >=20
> > =20
> > >=20
> > > >
> > > > >
> > > > > That being said when registering the mmu_notifier you need 2 =
things,
> > > > > first you
> > > > > need a pin on the mm (either mm is current ie current->mm or =
you
> > > took a
> > > > > reference
> > > > > on it). Second you need to that the mmap smemaphore in write =
mode so
> > > > > that
> > > > > no concurrent mmap/munmap/madvise can happen. By doing that y=
ou
> > > protect
> > > > > yourself
> > > > > from concurrent range_start/range_end that can happen and tha=
t does
> > > > > matter.
> > > > > The only concurrent range_start/end that can happen is throug=
h file
> > > > > invalidation
> > > > > which is fine because subsequent page fault will go through t=
he file
> > > > > layer and
> > > > > bring back page or return error (if file was truncated for
> > > instance).
> > > >
> > > > Sadly, this is not sufficient for our use case. We are register=
ing
> > > > a single MMU notifier handler, and broadcast the notifications =
to
> > > > all relevant listeners, which are stored in an interval tree.
> > > >
> > > > Each listener represents a section of the address space that ha=
s been
> > > > exposed to the network. Such implementation allows us to limit =
the
> > > impact
> > > > of invalidations, and only block racing page faults to the affe=
cted
> > > areas.
> > > >
> > > > Each of the listeners maintain a counter of the number of
> > > invalidate_range
> > > > notifications that are currently affecting it. The counter is
> > > increased
> > > > for each invalidate_range_start callback received, and decrease=
 for
> > > each
> > > > invalidate_range_end callback received. If we add a listener to=
 the
> > > > interval tree after the invalidate_range_start callback happene=
d, but
> > > > before the invalidate_range_end callback happened, it will decr=
ease
> > > the
> > > > counter, reaching negative numbers and breaking the logic.
> > > >
> > > > The mmu_notifiers registration code avoid such issues by taking=
 all
> > > > relevant locks on the MM. This effectively blocks all possible
> > > notifiers
> > > > from happening when registering a new notifier. Sadly, this fun=
ction
> > > is
> > > > not exported for modules to use it.
> > > >
> > > > Our options at the moment are:
> > > > - Use a tracking mechanism similar to what HMM uses, alongside =
the
> > > >   challenges involved in allocating memory from notifiers
> > > >
> > > > - Use a per-process counter for invalidations, causing a possib=
le
> > > >   performance degradation. This can possibly be used as a fallb=
ack to
> > > the
> > > >   first option (i.e. have a pool of X notifier identifiers, onc=
e it is
> > > >   full, increase/decrease a per-MM counter)
> > > >
> > > > - Export the mm_take_all_locks function for modules. This will =
allow
> > > us
> > > >   to lock the MM when adding a new listener.
> > >=20
> > > I was not clear enough, you need to take the mmap_sem in write mo=
de
> > > accross
> > > mmu_notifier_register(). This is only to partialy solve your issu=
e that
> > > if
> > > a mmu_notifier is already register for the mm you are trying to
> > > registering
> > > against then there is a chance for you to be inside an active
> > > range_start/
> > > range_end section which would lead to invalid counter inside your
> > > tracking
> > > structure. But, sadly, taking mmap_sem in write mode is not enoug=
h as
> > > file
> > > invalidation might still happen concurrently so you will need to =
make
> > > sure
> > > you invalidation counters does not go negative but from page faul=
t point
> > > of
> > > view you will be fine because the page fault will synchronize thr=
ough
> > > the
> > > pagecache. So scenario (A and B are to anonymous overlapping addr=
ess
> > > range) :
> > >=20
> > >   APP_TOTO_RDMA_THREAD           |  APP_TOTO_SOME_OTHER_THREAD
> > >                                  |  mmu_notifier_invalidate_range=
_start(A)
> > >   odp_register()                 |
> > >     down_read(mmap_sem)          |
> > >     mmu_notifier_register()      |
> > >     up_read(mmap_sem)            |
> > >   odp_add_new_region(B)          |
> > >   odp_page_fault(B)              |
> > >     down_read(mmap_sem)          |
> > >     ...                          |
> > >     up_read(mmap_sem)            |
> > >                                  |  mmu_notifier_invalidate_range=
_end(A)
> > >=20
> > > The odp_page_fault(B) might see invalid cpu page table but you ha=
ve no
> > > idea
> > > about it because you registered after the range_start(). But if y=
ou take
> > > the
> > > mmap_sem in write mode then the only case where you might still h=
ave
> > > this
> > > scenario is if A and B are range of a file backed vma and that th=
e file
> > > is
> > > undergoing some change (most likely truncation). But the file cas=
e is
> > > fine
> > > because the odp_page_fault() will go through the pagecache which =
is
> > > properly
> > > synchronize against the current range invalidation.
> >=20
> > Specifically, if you call mmu_notifier_register you are OK and the =
above
> > scenario will not happen. You are supposed to hold mmap_sem for wri=
ting,
> > and mmu_notifier_register is calling mm_take_all_locks, which guara=
ntees
> > no racing notifier during the registration step.
> >=20
> > However, we want to dynamically add sub-notifiers in our code. Each=
 will
> > get notified only about invalidations touching a specific sub-secti=
ons of
> > the address space. To avoid providing unneeded notifications, we us=
e an
> > interval tree that filters only the needed notifications.
> > When adding entries to the interval tree, we cannot lock the mm to =
prevent
> > any racing invalidations. As such, we might end up in a case where =
a newly
> > registered memory region will get a "notify_end" call without the r=
elevant
> > "notify_start". Even if we prevent the value from dropping below ze=
ro, it
> > means we can cause data corruption. For example, if we have another
> > notifier running after the MR registers, which is due to munmap, bu=
t we get
> > first the notify_end of the previous notifier for which we didn't s=
ee the
> > notify_start.
> >=20
> > The solution we are coming up with now is using a global counter of=
 running
> > invalidations for new regions allocated. When the global counter is=
 at zero,
> > we can safely switch to the region local invalidations counter.
>=20
> Yes i fully understood that design but as i said this kind of broken =
and this
> is what the attached patch try to address as HMM have the same issue =
of having
> to track all active invalidation range.

I should also stress that my point was that you need mmap_sem in write =
mode while
registering specificaly because otherwise there is a risk that your glo=
bal mmu
notifier counter is missing a running invalidate range and thus there i=
s a window
for a one of your new struct that mirror a range to be registered and t=
o use
invalid pages (pages that are about to be freed). So this is very impor=
tant to
hold the mmap_sem in write mode while you are registering and before yo=
u allow
any of your region to be register.

As i said i was not talking about the general case after registering th=
e mmu
notifier.

>=20
> >=20
> >=20
> > >=20
> > >=20
> > > Now for the the general case outside of mmu_notifier_register() H=
MM also
> > > track
> > > active invalidation range to avoid page faulting into those range=
 as we
> > > can not
> > > trust the cpu page table for as long as the range invalidation is=
 on
> > > going.
> > >=20
> > > > >
> > > > > So as long as you hold the mmap_sem in write mode you should =
not
> > > worry
> > > > > about
> > > > > concurrent range_start/range_end (well they might happen but =
only
> > > for
> > > > > file
> > > > > backed vma).
> > > > >
> > > >
> > > > Sadly, the mmap_sem is not enough to protect us :(.
> > >=20
> > > This is enough like i explain above, but i am only talking about =
the mmu
> > > notifier registration. For the general case once you register you=
 only
> > > need to take the mmap_sem in read mode during page fault.
> > >=20
> >=20
> > I think we are not broadcasting on the same wavelength here. The is=
sue I'm
> > worried about is of adding a sub-area to our tracking system. It is=
 built
> > quite differently from how HMM is built, we are defining areas to t=
rack
> > a-priori, and later on account how many notifiers are blocking page=
-faults
> > for each area. You are keeping track of the active notifiers, and c=
heck
> > each page fault against your notifier list. This difference makes f=
or
> > different locking needs.
> >=20
> > > > > Given that you face the same issue as i have with the
> > > > > range_start/range_end i
> > > > > will stich up a patch to make it easier to track those.
> > > > >
> > > >
> > > > That would be nice, especially if we could easily integrate it =
into
> > > our
> > > > code and reduce the code size.
> > >=20
> > > Yes it's a "small modification" to the mmu_notifier api, i have b=
een
> > > side
> > > tracked on other thing. But i will have it soon.
> > >=20
> >=20
> > Being side tracked is a well-known professional risk in our line of=
 work ;)
> >=20
> >=20
> > > >
> > > > > Cheers,
> > > > > J=E9r=F4me
> > > > >
> > > > >

> From 037195e49fbed468d16b78f0364fe302bc732d12 Mon Sep 17 00:00:00 200=
1
> From: =3D?UTF-8?q?J=3DC3=3DA9r=3DC3=3DB4me=3D20Glisse?=3D <jglisse@re=
dhat.com>
> Date: Thu, 11 Sep 2014 11:22:12 -0400
> Subject: [PATCH] mmu_notifier: keep track of active invalidation rang=
es
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> The mmu_notifier_invalidate_range_start() and mmu_notifier_invalidate=
_range_end()
> can be considered as forming an "atomic" section for the cpu page tab=
le update
> point of view. Between this two function the cpu page table content i=
s unreliable
> for the affected range of address.
>=20
> Current user such as kvm need to know when they can trust a the conte=
nt of the
> cpu page table. This becomes even more important to new users of the =
mmu_notifier
> api (such as HMM or ODP).
>=20
> This patch use a structure define at all call site to invalidate_rang=
e_start()
> that is added to a list for the duration of the invalidation. It adds=
 two new
> helpers to allow querying if a range is being invalidated or to wait =
for a range
> to become valid.
>=20
> This two new function does not provide strong synchronization but are=
 intended
> to be use as helper. User of the mmu_notifier must also synchronize w=
ith themself
> inside their range_start() and range_end() callback.
>=20
> Signed-off-by: J=E9r=F4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/gpu/drm/i915/i915_gem_userptr.c | 13 +++---
>  drivers/iommu/amd_iommu_v2.c            |  8 +---
>  drivers/misc/sgi-gru/grutlbpurge.c      | 15 +++----
>  drivers/xen/gntdev.c                    |  8 ++--
>  fs/proc/task_mmu.c                      | 12 +++--
>  include/linux/mmu_notifier.h            | 55 ++++++++++++-----------
>  mm/fremap.c                             |  8 +++-
>  mm/huge_memory.c                        | 78 ++++++++++++++---------=
----------
>  mm/hugetlb.c                            | 49 +++++++++++----------
>  mm/memory.c                             | 73 ++++++++++++++++-------=
-------
>  mm/migrate.c                            | 16 +++----
>  mm/mmu_notifier.c                       | 73 +++++++++++++++++++++++=
++-----
>  mm/mprotect.c                           | 17 ++++---
>  mm/mremap.c                             | 14 +++---
>  mm/rmap.c                               | 15 +++----
>  virt/kvm/kvm_main.c                     | 10 ++---
>  16 files changed, 256 insertions(+), 208 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/dr=
m/i915/i915_gem_userptr.c
> index a13307d..373ffbb 100644
> --- a/drivers/gpu/drm/i915/i915_gem_userptr.c
> +++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
> @@ -123,26 +123,25 @@ restart:
> =20
>  static void i915_gem_userptr_mn_invalidate_range_start(struct mmu_no=
tifier *_mn,
>  						       struct mm_struct *mm,
> -						       unsigned long start,
> -						       unsigned long end,
> -						       enum mmu_event event)
> +						       const struct mmu_notifier_range *range)
>  {
>  	struct i915_mmu_notifier *mn =3D container_of(_mn, struct i915_mmu_=
notifier, mn);
>  	struct interval_tree_node *it =3D NULL;
> -	unsigned long next =3D start;
> +	unsigned long next =3D range->start;
>  	unsigned long serial =3D 0;
> +	/* interval ranges are inclusive, but invalidate range is exclusive=
 */
> +	unsigned long end =3D range.end - 1;
> =20
> -	end--; /* interval ranges are inclusive, but invalidate range is ex=
clusive */
>  	while (next < end) {
>  		struct drm_i915_gem_object *obj =3D NULL;
> =20
>  		spin_lock(&mn->lock);
>  		if (mn->has_linear)
> -			it =3D invalidate_range__linear(mn, mm, start, end);
> +			it =3D invalidate_range__linear(mn, mm, range->start, end);
>  		else if (serial =3D=3D mn->serial)
>  			it =3D interval_tree_iter_next(it, next, end);
>  		else
> -			it =3D interval_tree_iter_first(&mn->objects, start, end);
> +			it =3D interval_tree_iter_first(&mn->objects, range->start, end);
>  		if (it !=3D NULL) {
>  			obj =3D container_of(it, struct i915_mmu_object, it)->obj;
>  			drm_gem_object_reference(&obj->base);
> diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v=
2.c
> index 9a6b837..5945300 100644
> --- a/drivers/iommu/amd_iommu_v2.c
> +++ b/drivers/iommu/amd_iommu_v2.c
> @@ -419,9 +419,7 @@ static void mn_invalidate_page(struct mmu_notifie=
r *mn,
> =20
>  static void mn_invalidate_range_start(struct mmu_notifier *mn,
>  				      struct mm_struct *mm,
> -				      unsigned long start,
> -				      unsigned long end,
> -				      enum mmu_event event)
> +				      const struct mmu_notifier_range *range)
>  {
>  	struct pasid_state *pasid_state;
>  	struct device_state *dev_state;
> @@ -442,9 +440,7 @@ static void mn_invalidate_range_start(struct mmu_=
notifier *mn,
> =20
>  static void mn_invalidate_range_end(struct mmu_notifier *mn,
>  				    struct mm_struct *mm,
> -				    unsigned long start,
> -				    unsigned long end,
> -				    enum mmu_event event)
> +				    const struct mmu_notifier_range *range)
>  {
>  	struct pasid_state *pasid_state;
>  	struct device_state *dev_state;
> diff --git a/drivers/misc/sgi-gru/grutlbpurge.c b/drivers/misc/sgi-gr=
u/grutlbpurge.c
> index e67fed1..44b41b7 100644
> --- a/drivers/misc/sgi-gru/grutlbpurge.c
> +++ b/drivers/misc/sgi-gru/grutlbpurge.c
> @@ -221,8 +221,7 @@ void gru_flush_all_tlb(struct gru_state *gru)
>   */
>  static void gru_invalidate_range_start(struct mmu_notifier *mn,
>  				       struct mm_struct *mm,
> -				       unsigned long start, unsigned long end,
> -				       enum mmu_event event)
> +				       const struct mmu_notifier_range *range)
>  {
>  	struct gru_mm_struct *gms =3D container_of(mn, struct gru_mm_struct=
,
>  						 ms_notifier);
> @@ -230,14 +229,13 @@ static void gru_invalidate_range_start(struct m=
mu_notifier *mn,
>  	STAT(mmu_invalidate_range);
>  	atomic_inc(&gms->ms_range_active);
>  	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx, act %d\n", gms,
> -		start, end, atomic_read(&gms->ms_range_active));
> -	gru_flush_tlb_range(gms, start, end - start);
> +		range->start, range->end, atomic_read(&gms->ms_range_active));
> +	gru_flush_tlb_range(gms, range->start, range->end - range->start);
>  }
> =20
>  static void gru_invalidate_range_end(struct mmu_notifier *mn,
> -				     struct mm_struct *mm, unsigned long start,
> -				     unsigned long end,
> -				     enum mmu_event event)
> +				     struct mm_struct *mm,
> +				     const struct mmu_notifier_range *range)
>  {
>  	struct gru_mm_struct *gms =3D container_of(mn, struct gru_mm_struct=
,
>  						 ms_notifier);
> @@ -246,7 +244,8 @@ static void gru_invalidate_range_end(struct mmu_n=
otifier *mn,
>  	(void)atomic_dec_and_test(&gms->ms_range_active);
> =20
>  	wake_up_all(&gms->ms_wait_queue);
> -	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx\n", gms, start, end=
);
> +	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx\n", gms,
> +		range->start, range->end);
>  }
> =20
>  static void gru_invalidate_page(struct mmu_notifier *mn, struct mm_s=
truct *mm,
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index fe9da94..51f9188 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -428,19 +428,17 @@ static void unmap_if_in_range(struct grant_map =
*map,
> =20
>  static void mn_invl_range_start(struct mmu_notifier *mn,
>  				struct mm_struct *mm,
> -				unsigned long start,
> -				unsigned long end,
> -				enum mmu_event event)
> +				const struct mmu_notifier_range *range)
>  {
>  	struct gntdev_priv *priv =3D container_of(mn, struct gntdev_priv, m=
n);
>  	struct grant_map *map;
> =20
>  	spin_lock(&priv->lock);
>  	list_for_each_entry(map, &priv->maps, next) {
> -		unmap_if_in_range(map, start, end);
> +		unmap_if_in_range(map, range->start, range->end);
>  	}
>  	list_for_each_entry(map, &priv->freeable_maps, next) {
> -		unmap_if_in_range(map, start, end);
> +		unmap_if_in_range(map, range->start, range->end);
>  	}
>  	spin_unlock(&priv->lock);
>  }
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 0ddb975..532a230 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -828,10 +828,15 @@ static ssize_t clear_refs_write(struct file *fi=
le, const char __user *buf,
>  			.mm =3D mm,
>  			.private =3D &cp,
>  		};
> +		struct mmu_notifier_range range =3D {
> +			.start =3D 0,
> +			.end =3D -1UL,
> +			.event =3D MMU_ISDIRTY,
> +		};
> +
>  		down_read(&mm->mmap_sem);
>  		if (type =3D=3D CLEAR_REFS_SOFT_DIRTY)
> -			mmu_notifier_invalidate_range_start(mm, 0,
> -							    -1, MMU_ISDIRTY);
> +			mmu_notifier_invalidate_range_start(mm, &range);
>  		for (vma =3D mm->mmap; vma; vma =3D vma->vm_next) {
>  			cp.vma =3D vma;
>  			if (is_vm_hugetlb_page(vma))
> @@ -859,8 +864,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
>  					&clear_refs_walk);
>  		}
>  		if (type =3D=3D CLEAR_REFS_SOFT_DIRTY)
> -			mmu_notifier_invalidate_range_end(mm, 0,
> -							  -1, MMU_ISDIRTY);
> +			mmu_notifier_invalidate_range_end(mm, &range);
>  		flush_tlb_mm(mm);
>  		up_read(&mm->mmap_sem);
>  		mmput(mm);
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifie=
r.h
> index 94f6890..f4a2a74 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -69,6 +69,13 @@ enum mmu_event {
>  	MMU_WRITE_PROTECT,
>  };
> =20
> +struct mmu_notifier_range {
> +	struct list_head list;
> +	unsigned long start;
> +	unsigned long end;
> +	enum mmu_event event;
> +};
> +
>  #ifdef CONFIG_MMU_NOTIFIER
> =20
>  /*
> @@ -82,6 +89,12 @@ struct mmu_notifier_mm {
>  	struct hlist_head list;
>  	/* to serialize the list modifications and hlist_unhashed */
>  	spinlock_t lock;
> +	/* List of all active range invalidations. */
> +	struct list_head ranges;
> +	/* Number of active range invalidations. */
> +	int nranges;
> +	/* For threads waiting on range invalidations. */
> +	wait_queue_head_t wait_queue;
>  };
> =20
>  struct mmu_notifier_ops {
> @@ -199,14 +212,10 @@ struct mmu_notifier_ops {
>  	 */
>  	void (*invalidate_range_start)(struct mmu_notifier *mn,
>  				       struct mm_struct *mm,
> -				       unsigned long start,
> -				       unsigned long end,
> -				       enum mmu_event event);
> +				       const struct mmu_notifier_range *range);
>  	void (*invalidate_range_end)(struct mmu_notifier *mn,
>  				     struct mm_struct *mm,
> -				     unsigned long start,
> -				     unsigned long end,
> -				     enum mmu_event event);
> +				     const struct mmu_notifier_range *range);
>  };
> =20
>  /*
> @@ -252,13 +261,15 @@ extern void __mmu_notifier_invalidate_page(stru=
ct mm_struct *mm,
>  					  unsigned long address,
>  					  enum mmu_event event);
>  extern void __mmu_notifier_invalidate_range_start(struct mm_struct *=
mm,
> -						  unsigned long start,
> -						  unsigned long end,
> -						  enum mmu_event event);
> +						  struct mmu_notifier_range *range);
>  extern void __mmu_notifier_invalidate_range_end(struct mm_struct *mm=
,
> -						unsigned long start,
> -						unsigned long end,
> -						enum mmu_event event);
> +						struct mmu_notifier_range *range);
> +extern bool mmu_notifier_range_is_valid(struct mm_struct *mm,
> +					unsigned long start,
> +					unsigned long end);
> +extern void mmu_notifier_range_wait_valid(struct mm_struct *mm,
> +					  unsigned long start,
> +					  unsigned long end);
> =20
>  static inline void mmu_notifier_release(struct mm_struct *mm)
>  {
> @@ -300,21 +311,17 @@ static inline void mmu_notifier_invalidate_page=
(struct mm_struct *mm,
>  }
> =20
>  static inline void mmu_notifier_invalidate_range_start(struct mm_str=
uct *mm,
> -						       unsigned long start,
> -						       unsigned long end,
> -						       enum mmu_event event)
> +						       struct mmu_notifier_range *range)
>  {
>  	if (mm_has_notifiers(mm))
> -		__mmu_notifier_invalidate_range_start(mm, start, end, event);
> +		__mmu_notifier_invalidate_range_start(mm, range);
>  }
> =20
>  static inline void mmu_notifier_invalidate_range_end(struct mm_struc=
t *mm,
> -						     unsigned long start,
> -						     unsigned long end,
> -						     enum mmu_event event)
> +						     struct mmu_notifier_range *range)
>  {
>  	if (mm_has_notifiers(mm))
> -		__mmu_notifier_invalidate_range_end(mm, start, end, event);
> +		__mmu_notifier_invalidate_range_end(mm, range);
>  }
> =20
>  static inline void mmu_notifier_mm_init(struct mm_struct *mm)
> @@ -406,16 +413,12 @@ static inline void mmu_notifier_invalidate_page=
(struct mm_struct *mm,
>  }
> =20
>  static inline void mmu_notifier_invalidate_range_start(struct mm_str=
uct *mm,
> -						       unsigned long start,
> -						       unsigned long end,
> -						       enum mmu_event event)
> +						       struct mmu_notifier_range *range)
>  {
>  }
> =20
>  static inline void mmu_notifier_invalidate_range_end(struct mm_struc=
t *mm,
> -						     unsigned long start,
> -						     unsigned long end,
> -						     enum mmu_event event)
> +						     struct mmu_notifier_range *range)
>  {
>  }
> =20
> diff --git a/mm/fremap.c b/mm/fremap.c
> index 37b2904..03a5ddc 100644
> --- a/mm/fremap.c
> +++ b/mm/fremap.c
> @@ -148,6 +148,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, =
start, unsigned long, size,
>  	int err =3D -EINVAL;
>  	int has_write_lock =3D 0;
>  	vm_flags_t vm_flags =3D 0;
> +	struct mmu_notifier_range range;
> =20
>  	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
>  			"See Documentation/vm/remap_file_pages.txt.\n",
> @@ -258,9 +259,12 @@ get_write_lock:
>  		vma->vm_flags =3D vm_flags;
>  	}
> =20
> -	mmu_notifier_invalidate_range_start(mm, start, start + size, MMU_MU=
NMAP);
> +	range.start =3D start;
> +	range.end =3D start + size;
> +	range.event =3D MMU_MUNMAP;
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	err =3D vma->vm_ops->remap_pages(vma, start, size, pgoff);
> -	mmu_notifier_invalidate_range_end(mm, start, start + size, MMU_MUNM=
AP);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	/*
>  	 * We can't clear VM_NONLINEAR because we'd have to do
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e3efba5..4b116dd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -988,8 +988,7 @@ static int do_huge_pmd_wp_page_fallback(struct mm=
_struct *mm,
>  	pmd_t _pmd;
>  	int ret =3D 0, i;
>  	struct page **pages;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	pages =3D kmalloc(sizeof(struct page *) * HPAGE_PMD_NR,
>  			GFP_KERNEL);
> @@ -1027,10 +1026,10 @@ static int do_huge_pmd_wp_page_fallback(struc=
t mm_struct *mm,
>  		cond_resched();
>  	}
> =20
> -	mmun_start =3D haddr;
> -	mmun_end   =3D haddr + HPAGE_PMD_SIZE;
> -	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
> -					    MMU_MIGRATE);
> +	range.start =3D haddr;
> +	range.end =3D haddr + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(mm, &range);
> =20
>  	ptl =3D pmd_lock(mm, pmd);
>  	if (unlikely(!pmd_same(*pmd, orig_pmd)))
> @@ -1064,8 +1063,7 @@ static int do_huge_pmd_wp_page_fallback(struct =
mm_struct *mm,
>  	page_remove_rmap(page);
>  	spin_unlock(ptl);
> =20
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	ret |=3D VM_FAULT_WRITE;
>  	put_page(page);
> @@ -1075,8 +1073,7 @@ out:
> =20
>  out_free_pages:
>  	spin_unlock(ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  	for (i =3D 0; i < HPAGE_PMD_NR; i++) {
>  		memcg =3D (void *)page_private(pages[i]);
>  		set_page_private(pages[i], 0);
> @@ -1095,8 +1092,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, s=
truct vm_area_struct *vma,
>  	struct page *page =3D NULL, *new_page;
>  	struct mem_cgroup *memcg;
>  	unsigned long haddr;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	ptl =3D pmd_lockptr(mm, pmd);
>  	VM_BUG_ON(!vma->anon_vma);
> @@ -1166,10 +1162,10 @@ alloc:
>  		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
>  	__SetPageUptodate(new_page);
> =20
> -	mmun_start =3D haddr;
> -	mmun_end   =3D haddr + HPAGE_PMD_SIZE;
> -	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
> -					    MMU_MIGRATE);
> +	range.start =3D haddr;
> +	range.end =3D haddr + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(mm, &range);
> =20
>  	spin_lock(ptl);
>  	if (page)
> @@ -1201,8 +1197,7 @@ alloc:
>  	}
>  	spin_unlock(ptl);
>  out_mn:
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  out:
>  	return ret;
>  out_unlock:
> @@ -1633,12 +1628,12 @@ static int __split_huge_page_splitting(struct=
 page *page,
>  	spinlock_t *ptl;
>  	pmd_t *pmd;
>  	int ret =3D 0;
> -	/* For mmu_notifiers */
> -	const unsigned long mmun_start =3D address;
> -	const unsigned long mmun_end   =3D address + HPAGE_PMD_SIZE;
> +	struct mmu_notifier_range range;
> =20
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_HSPLIT);
> +	range.start =3D address;
> +	range.end =3D address + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_HSPLIT;
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	pmd =3D page_check_address_pmd(page, mm, address,
>  			PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG, &ptl);
>  	if (pmd) {
> @@ -1653,8 +1648,7 @@ static int __split_huge_page_splitting(struct p=
age *page,
>  		ret =3D 1;
>  		spin_unlock(ptl);
>  	}
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_HSPLIT);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	return ret;
>  }
> @@ -2434,8 +2428,7 @@ static void collapse_huge_page(struct mm_struct=
 *mm,
>  	int isolated;
>  	unsigned long hstart, hend;
>  	struct mem_cgroup *memcg;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> =20
> @@ -2475,10 +2468,10 @@ static void collapse_huge_page(struct mm_stru=
ct *mm,
>  	pte =3D pte_offset_map(pmd, address);
>  	pte_ptl =3D pte_lockptr(mm, pmd);
> =20
> -	mmun_start =3D address;
> -	mmun_end   =3D address + HPAGE_PMD_SIZE;
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	range.start =3D address;
> +	range.end =3D address + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	pmd_ptl =3D pmd_lock(mm, pmd); /* probably unnecessary */
>  	/*
>  	 * After this gup_fast can't run anymore. This also removes
> @@ -2488,8 +2481,7 @@ static void collapse_huge_page(struct mm_struct=
 *mm,
>  	 */
>  	_pmd =3D pmdp_clear_flush(vma, address, pmd);
>  	spin_unlock(pmd_ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	spin_lock(pte_ptl);
>  	isolated =3D __collapse_huge_page_isolate(vma, address, pte);
> @@ -2872,36 +2864,32 @@ void __split_huge_page_pmd(struct vm_area_str=
uct *vma, unsigned long address,
>  	struct page *page;
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	unsigned long haddr =3D address & HPAGE_PMD_MASK;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZ=
E);
> =20
> -	mmun_start =3D haddr;
> -	mmun_end   =3D haddr + HPAGE_PMD_SIZE;
> +	range.start =3D haddr;
> +	range.end =3D haddr + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_MIGRATE;
>  again:
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	ptl =3D pmd_lock(mm, pmd);
>  	if (unlikely(!pmd_trans_huge(*pmd))) {
>  		spin_unlock(ptl);
> -		mmu_notifier_invalidate_range_end(mm, mmun_start,
> -						  mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(mm, &range);
>  		return;
>  	}
>  	if (is_huge_zero_pmd(*pmd)) {
>  		__split_huge_zero_page_pmd(vma, haddr, pmd);
>  		spin_unlock(ptl);
> -		mmu_notifier_invalidate_range_end(mm, mmun_start,
> -						  mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(mm, &range);
>  		return;
>  	}
>  	page =3D pmd_page(*pmd);
>  	VM_BUG_ON_PAGE(!page_count(page), page);
>  	get_page(page);
>  	spin_unlock(ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	split_huge_page(page);
> =20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ae98b53..6484793 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2551,17 +2551,16 @@ int copy_hugetlb_page_range(struct mm_struct =
*dst, struct mm_struct *src,
>  	int cow;
>  	struct hstate *h =3D hstate_vma(vma);
>  	unsigned long sz =3D huge_page_size(h);
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
>  	int ret =3D 0;
> =20
>  	cow =3D (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) =3D=3D VM_MAYWR=
ITE;
> =20
> -	mmun_start =3D vma->vm_start;
> -	mmun_end =3D vma->vm_end;
> +	range.start =3D vma->vm_start;
> +	range.end =3D vma->vm_end;
> +	range.event =3D MMU_MIGRATE;
>  	if (cow)
> -		mmu_notifier_invalidate_range_start(src, mmun_start,
> -						    mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_start(src, &range);
> =20
>  	for (addr =3D vma->vm_start; addr < vma->vm_end; addr +=3D sz) {
>  		spinlock_t *src_ptl, *dst_ptl;
> @@ -2612,8 +2611,7 @@ int copy_hugetlb_page_range(struct mm_struct *d=
st, struct mm_struct *src,
>  	}
> =20
>  	if (cow)
> -		mmu_notifier_invalidate_range_end(src, mmun_start,
> -						  mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(src, &range);
> =20
>  	return ret;
>  }
> @@ -2631,16 +2629,17 @@ void __unmap_hugepage_range(struct mmu_gather=
 *tlb, struct vm_area_struct *vma,
>  	struct page *page;
>  	struct hstate *h =3D hstate_vma(vma);
>  	unsigned long sz =3D huge_page_size(h);
> -	const unsigned long mmun_start =3D start;	/* For mmu_notifiers */
> -	const unsigned long mmun_end   =3D end;	/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	WARN_ON(!is_vm_hugetlb_page(vma));
>  	BUG_ON(start & ~huge_page_mask(h));
>  	BUG_ON(end & ~huge_page_mask(h));
> =20
> +	range.start =3D start;
> +	range.end =3D end;
> +	range.event =3D MMU_MIGRATE;
>  	tlb_start_vma(tlb, vma);
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  again:
>  	for (address =3D start; address < end; address +=3D sz) {
>  		ptep =3D huge_pte_offset(mm, address);
> @@ -2711,8 +2710,7 @@ unlock:
>  		if (address < end && !ref_page)
>  			goto again;
>  	}
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  	tlb_end_vma(tlb, vma);
>  }
> =20
> @@ -2809,8 +2807,7 @@ static int hugetlb_cow(struct mm_struct *mm, st=
ruct vm_area_struct *vma,
>  	struct hstate *h =3D hstate_vma(vma);
>  	struct page *old_page, *new_page;
>  	int ret =3D 0, outside_reserve =3D 0;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
> =20
>  	old_page =3D pte_page(pte);
> =20
> @@ -2888,10 +2885,11 @@ retry_avoidcopy:
>  			    pages_per_huge_page(h));
>  	__SetPageUptodate(new_page);
> =20
> -	mmun_start =3D address & huge_page_mask(h);
> -	mmun_end =3D mmun_start + huge_page_size(h);
> -	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
> -					    MMU_MIGRATE);
> +	range.start =3D address;
> +	range.end =3D address + huge_page_size(h);
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(mm, &range);
> +
>  	/*
>  	 * Retake the page table lock to check for racing updates
>  	 * before the page tables are altered
> @@ -2911,8 +2909,7 @@ retry_avoidcopy:
>  		new_page =3D old_page;
>  	}
>  	spin_unlock(ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end,
> -					  MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  out_release_all:
>  	page_cache_release(new_page);
>  out_release_old:
> @@ -3346,11 +3343,15 @@ unsigned long hugetlb_change_protection(struc=
t vm_area_struct *vma,
>  	pte_t pte;
>  	struct hstate *h =3D hstate_vma(vma);
>  	unsigned long pages =3D 0;
> +	struct mmu_notifier_range range;
> =20
>  	BUG_ON(address >=3D end);
>  	flush_cache_range(vma, address, end);
> =20
> -	mmu_notifier_invalidate_range_start(mm, start, end, MMU_MPROT);
> +	range.start =3D start;
> +	range.end =3D end;
> +	range.event =3D MMU_MPROT;
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
>  	for (; address < end; address +=3D huge_page_size(h)) {
>  		spinlock_t *ptl;
> @@ -3380,7 +3381,7 @@ unsigned long hugetlb_change_protection(struct =
vm_area_struct *vma,
>  	 */
>  	flush_tlb_range(vma, start, end);
>  	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
> -	mmu_notifier_invalidate_range_end(mm, start, end, MMU_MPROT);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	return pages << h->order;
>  }
> diff --git a/mm/memory.c b/mm/memory.c
> index 1c212e6..c1c7ccc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1008,8 +1008,7 @@ int copy_page_range(struct mm_struct *dst_mm, s=
truct mm_struct *src_mm,
>  	unsigned long next;
>  	unsigned long addr =3D vma->vm_start;
>  	unsigned long end =3D vma->vm_end;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
>  	bool is_cow;
>  	int ret;
> =20
> @@ -1045,11 +1044,11 @@ int copy_page_range(struct mm_struct *dst_mm,=
 struct mm_struct *src_mm,
>  	 * is_cow_mapping() returns true.
>  	 */
>  	is_cow =3D is_cow_mapping(vma->vm_flags);
> -	mmun_start =3D addr;
> -	mmun_end   =3D end;
> +	range.start =3D addr;
> +	range.end =3D end;
> +	range.event =3D MMU_MIGRATE;
>  	if (is_cow)
> -		mmu_notifier_invalidate_range_start(src_mm, mmun_start,
> -						    mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_start(src_mm, &range);
> =20
>  	ret =3D 0;
>  	dst_pgd =3D pgd_offset(dst_mm, addr);
> @@ -1066,8 +1065,7 @@ int copy_page_range(struct mm_struct *dst_mm, s=
truct mm_struct *src_mm,
>  	} while (dst_pgd++, src_pgd++, addr =3D next, addr !=3D end);
> =20
>  	if (is_cow)
> -		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end,
> -						  MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(src_mm, &range);
>  	return ret;
>  }
> =20
> @@ -1370,13 +1368,16 @@ void unmap_vmas(struct mmu_gather *tlb,
>  		unsigned long end_addr)
>  {
>  	struct mm_struct *mm =3D vma->vm_mm;
> +	struct mmu_notifier_range range =3D {
> +		.start =3D start_addr,
> +		.end =3D end_addr,
> +		.event =3D MMU_MUNMAP,
> +	};
> =20
> -	mmu_notifier_invalidate_range_start(mm, start_addr,
> -					    end_addr, MMU_MUNMAP);
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	for ( ; vma && vma->vm_start < end_addr; vma =3D vma->vm_next)
>  		unmap_single_vma(tlb, vma, start_addr, end_addr, NULL);
> -	mmu_notifier_invalidate_range_end(mm, start_addr,
> -					  end_addr, MMU_MUNMAP);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  }
> =20
>  /**
> @@ -1393,16 +1394,20 @@ void zap_page_range(struct vm_area_struct *vm=
a, unsigned long start,
>  {
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	struct mmu_gather tlb;
> -	unsigned long end =3D start + size;
> +	struct mmu_notifier_range range =3D {
> +		.start =3D start,
> +		.end =3D start + size,
> +		.event =3D MMU_MUNMAP,
> +	};
> =20
>  	lru_add_drain();
> -	tlb_gather_mmu(&tlb, mm, start, end);
> +	tlb_gather_mmu(&tlb, mm, start, range.end);
>  	update_hiwater_rss(mm);
> -	mmu_notifier_invalidate_range_start(mm, start, end, MMU_MUNMAP);
> -	for ( ; vma && vma->vm_start < end; vma =3D vma->vm_next)
> -		unmap_single_vma(&tlb, vma, start, end, details);
> -	mmu_notifier_invalidate_range_end(mm, start, end, MMU_MUNMAP);
> -	tlb_finish_mmu(&tlb, start, end);
> +	mmu_notifier_invalidate_range_start(mm, &range);
> +	for ( ; vma && vma->vm_start < range.end; vma =3D vma->vm_next)
> +		unmap_single_vma(&tlb, vma, start, range.end, details);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> +	tlb_finish_mmu(&tlb, start, range.end);
>  }
> =20
>  /**
> @@ -1419,15 +1424,19 @@ static void zap_page_range_single(struct vm_a=
rea_struct *vma, unsigned long addr
>  {
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	struct mmu_gather tlb;
> -	unsigned long end =3D address + size;
> +	struct mmu_notifier_range range =3D {
> +		.start =3D address,
> +		.end =3D address + size,
> +		.event =3D MMU_MUNMAP,
> +	};
> =20
>  	lru_add_drain();
> -	tlb_gather_mmu(&tlb, mm, address, end);
> +	tlb_gather_mmu(&tlb, mm, address, range.end);
>  	update_hiwater_rss(mm);
> -	mmu_notifier_invalidate_range_start(mm, address, end, MMU_MUNMAP);
> -	unmap_single_vma(&tlb, vma, address, end, details);
> -	mmu_notifier_invalidate_range_end(mm, address, end, MMU_MUNMAP);
> -	tlb_finish_mmu(&tlb, address, end);
> +	mmu_notifier_invalidate_range_start(mm, &range);
> +	unmap_single_vma(&tlb, vma, address, range.end, details);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> +	tlb_finish_mmu(&tlb, address, range.end);
>  }
> =20
>  /**
> @@ -2047,8 +2056,7 @@ static int do_wp_page(struct mm_struct *mm, str=
uct vm_area_struct *vma,
>  	int ret =3D 0;
>  	int page_mkwrite =3D 0;
>  	struct page *dirty_page =3D NULL;
> -	unsigned long mmun_start =3D 0;	/* For mmu_notifiers */
> -	unsigned long mmun_end =3D 0;	/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
>  	struct mem_cgroup *memcg;
> =20
>  	old_page =3D vm_normal_page(vma, address, orig_pte);
> @@ -2208,10 +2216,10 @@ gotten:
>  	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
>  		goto oom_free_new;
> =20
> -	mmun_start  =3D address & PAGE_MASK;
> -	mmun_end    =3D mmun_start + PAGE_SIZE;
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	range.start =3D address & PAGE_MASK;
> +	range.end =3D range.start + PAGE_SIZE;
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(mm, &range);
> =20
>  	/*
>  	 * Re-check the pte - we dropped the lock
> @@ -2282,8 +2290,7 @@ gotten:
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
>  	if (mmun_end > mmun_start)
> -		mmu_notifier_invalidate_range_end(mm, mmun_start,
> -						  mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(mm, &range);
>  	if (old_page) {
>  		/*
>  		 * Don't let another task, with possibly unlocked vma,
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 30417d5..d866771 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1781,10 +1781,13 @@ int migrate_misplaced_transhuge_page(struct m=
m_struct *mm,
>  	int isolated =3D 0;
>  	struct page *new_page =3D NULL;
>  	int page_lru =3D page_is_file_cache(page);
> -	unsigned long mmun_start =3D address & HPAGE_PMD_MASK;
> -	unsigned long mmun_end =3D mmun_start + HPAGE_PMD_SIZE;
> +	struct mmu_notifier_range range;
>  	pmd_t orig_entry;
> =20
> +	range.start =3D address & HPAGE_PMD_MASK;
> +	range.end =3D range.start + HPAGE_PMD_SIZE;
> +	range.event =3D MMU_MIGRATE;
> +
>  	/*
>  	 * Rate-limit the amount of data that is being migrated to a node.
>  	 * Optimal placement is no good if the memory bus is saturated and
> @@ -1819,14 +1822,12 @@ int migrate_misplaced_transhuge_page(struct m=
m_struct *mm,
>  	WARN_ON(PageLRU(new_page));
> =20
>  	/* Recheck the target PMD */
> -	mmu_notifier_invalidate_range_start(mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_start(mm, &range);
>  	ptl =3D pmd_lock(mm, pmd);
>  	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) !=3D 2)) {
>  fail_putback:
>  		spin_unlock(ptl);
> -		mmu_notifier_invalidate_range_end(mm, mmun_start,
> -						  mmun_end, MMU_MIGRATE);
> +		mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  		/* Reverse changes made by migrate_page_copy() */
>  		if (TestClearPageActive(new_page))
> @@ -1879,8 +1880,7 @@ fail_putback:
>  	page_remove_rmap(page);
> =20
>  	spin_unlock(ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	/* Take an "isolate" reference and put new page on the LRU. */
>  	get_page(new_page);
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index de039e4..d0edb98 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -173,9 +173,7 @@ void __mmu_notifier_invalidate_page(struct mm_str=
uct *mm,
>  }
> =20
>  void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
> -					   unsigned long start,
> -					   unsigned long end,
> -					   enum mmu_event event)
> +					   struct mmu_notifier_range *range)
> =20
>  {
>  	struct mmu_notifier *mn;
> @@ -184,31 +182,83 @@ void __mmu_notifier_invalidate_range_start(stru=
ct mm_struct *mm,
>  	id =3D srcu_read_lock(&srcu);
>  	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
>  		if (mn->ops->invalidate_range_start)
> -			mn->ops->invalidate_range_start(mn, mm, start,
> -							end, event);
> +			mn->ops->invalidate_range_start(mn, mm, range);
>  	}
>  	srcu_read_unlock(&srcu, id);
> +
> +	/*
> +	 * This must happen after the callback so that subsystem can block =
on
> +	 * new invalidation range to synchronize itself.
> +	 */
> +	spin_lock(&mm->mmu_notifier_mm->lock);
> +	list_add_tail(&range->list, &mm->mmu_notifier_mm->ranges);
> +	mm->mmu_notifier_mm->nranges++;
> +	spin_unlock(&mm->mmu_notifier_mm->lock);
>  }
>  EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);
> =20
>  void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
> -					 unsigned long start,
> -					 unsigned long end,
> -					 enum mmu_event event)
> +					 struct mmu_notifier_range *range)
>  {
>  	struct mmu_notifier *mn;
>  	int id;
> =20
> +	/*
> +	 * This must happen before the callback so that subsystem can unblo=
ck
> +	 * when range invalidation end.
> +	 */
> +	spin_lock(&mm->mmu_notifier_mm->lock);
> +	list_del_init(&range->list);
> +	mm->mmu_notifier_mm->nranges--;
> +	spin_unlock(&mm->mmu_notifier_mm->lock);
> +
>  	id =3D srcu_read_lock(&srcu);
>  	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
>  		if (mn->ops->invalidate_range_end)
> -			mn->ops->invalidate_range_end(mn, mm, start,
> -						      end, event);
> +			mn->ops->invalidate_range_end(mn, mm, range);
>  	}
>  	srcu_read_unlock(&srcu, id);
> +
> +	/*
> +	 * Wakeup after callback so they can do their job before any of the
> +	 * waiters resume.
> +	 */
> +	wake_up(&mm->mmu_notifier_mm->wait_queue);
>  }
>  EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_end);
> =20
> +bool mmu_notifier_range_is_valid(struct mm_struct *mm,
> +				 unsigned long start,
> +				 unsigned long end)
> +{
> +	struct mmu_notifier_range range;
> +
> +	spin_lock(&mm->mmu_notifier_mm->lock);
> +	list_for_each_entry(range, &mm->mmu_notifier_mm->ranges, list) {
> +		if (!(range->end <=3D start || range->start >=3D end)) {
> +			spin_unlock(&mm->mmu_notifier_mm->lock);
> +			return false;
> +		}
> +	}
> +	spin_unlock(&mm->mmu_notifier_mm->lock);
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_range_is_valid);
> +
> +void mmu_notifier_range_wait_valid(struct mm_struct *mm,
> +				   unsigned long start,
> +				   unsigned long end)
> +{
> +	int nranges =3D mm->mmu_notifier_mm->nranges;
> +
> +	while (!mmu_notifier_range_is_valid(mm, start, end)) {
> +		wait_event(mm->mmu_notifier_mm->wait_queue,
> +			   nranges !=3D mm->mmu_notifier_mm->nranges);
> +		nranges =3D mm->mmu_notifier_mm->nranges;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_range_wait_valid);
> +
>  static int do_mmu_notifier_register(struct mmu_notifier *mn,
>  				    struct mm_struct *mm,
>  				    int take_mmap_sem)
> @@ -238,6 +288,9 @@ static int do_mmu_notifier_register(struct mmu_no=
tifier *mn,
>  	if (!mm_has_notifiers(mm)) {
>  		INIT_HLIST_HEAD(&mmu_notifier_mm->list);
>  		spin_lock_init(&mmu_notifier_mm->lock);
> +		INIT_LIST_HEAD(&mmu_notifier_mm->ranges);
> +		mmu_notifier_mm->nranges =3D 0;
> +		init_waitqueue_head(&mmu_notifier_mm->wait_queue);
> =20
>  		mm->mmu_notifier_mm =3D mmu_notifier_mm;
>  		mmu_notifier_mm =3D NULL;
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 886405b..a178b22 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -144,7 +144,9 @@ static inline unsigned long change_pmd_range(stru=
ct vm_area_struct *vma,
>  	unsigned long next;
>  	unsigned long pages =3D 0;
>  	unsigned long nr_huge_updates =3D 0;
> -	unsigned long mni_start =3D 0;
> +	struct mmu_notifier_range range =3D {
> +		.start =3D 0,
> +	};
> =20
>  	pmd =3D pmd_offset(pud, addr);
>  	do {
> @@ -155,10 +157,11 @@ static inline unsigned long change_pmd_range(st=
ruct vm_area_struct *vma,
>  			continue;
> =20
>  		/* invoke the mmu notifier if the pmd is populated */
> -		if (!mni_start) {
> -			mni_start =3D addr;
> -			mmu_notifier_invalidate_range_start(mm, mni_start,
> -							    end, MMU_MPROT);
> +		if (!range.start) {
> +			range.start =3D addr;
> +			range.end =3D end;
> +			range.event =3D MMU_MPROT;
> +			mmu_notifier_invalidate_range_start(mm, &range);
>  		}
> =20
>  		if (pmd_trans_huge(*pmd)) {
> @@ -185,8 +188,8 @@ static inline unsigned long change_pmd_range(stru=
ct vm_area_struct *vma,
>  		pages +=3D this_pages;
>  	} while (pmd++, addr =3D next, addr !=3D end);
> =20
> -	if (mni_start)
> -		mmu_notifier_invalidate_range_end(mm, mni_start, end, MMU_MPROT);
> +	if (range.start)
> +		mmu_notifier_invalidate_range_end(mm, &range);
> =20
>  	if (nr_huge_updates)
>  		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 6827d2f..83c5eed 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -167,18 +167,17 @@ unsigned long move_page_tables(struct vm_area_s=
truct *vma,
>  		bool need_rmap_locks)
>  {
>  	unsigned long extent, next, old_end;
> +	struct mmu_notifier_range range;
>  	pmd_t *old_pmd, *new_pmd;
>  	bool need_flush =3D false;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> =20
>  	old_end =3D old_addr + len;
>  	flush_cache_range(vma, old_addr, old_end);
> =20
> -	mmun_start =3D old_addr;
> -	mmun_end   =3D old_end;
> -	mmu_notifier_invalidate_range_start(vma->vm_mm, mmun_start,
> -					    mmun_end, MMU_MIGRATE);
> +	range.start =3D old_addr;
> +	range.end =3D old_end;
> +	range.event =3D MMU_MIGRATE;
> +	mmu_notifier_invalidate_range_start(vma->vm_mm, &range);
> =20
>  	for (; old_addr < old_end; old_addr +=3D extent, new_addr +=3D exte=
nt) {
>  		cond_resched();
> @@ -229,8 +228,7 @@ unsigned long move_page_tables(struct vm_area_str=
uct *vma,
>  	if (likely(need_flush))
>  		flush_tlb_range(vma, old_end-len, old_addr);
> =20
> -	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start,
> -					  mmun_end, MMU_MIGRATE);
> +	mmu_notifier_invalidate_range_end(vma->vm_mm, &range);
> =20
>  	return len + old_addr - old_end;	/* how much done */
>  }
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0b67e7d..b8b8a60 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1302,15 +1302,14 @@ static int try_to_unmap_cluster(unsigned long=
 cursor, unsigned int *mapcount,
>  	spinlock_t *ptl;
>  	struct page *page;
>  	unsigned long address;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> +	struct mmu_notifier_range range;
>  	unsigned long end;
>  	int ret =3D SWAP_AGAIN;
>  	int locked_vma =3D 0;
> -	enum mmu_event event =3D MMU_MIGRATE;
> =20
> +	range.event =3D MMU_MIGRATE;
>  	if (flags & TTU_MUNLOCK)
> -		event =3D MMU_MUNLOCK;
> +		range.event =3D MMU_MUNLOCK;
> =20
>  	address =3D (vma->vm_start + cursor) & CLUSTER_MASK;
>  	end =3D address + CLUSTER_SIZE;
> @@ -1323,9 +1322,9 @@ static int try_to_unmap_cluster(unsigned long c=
ursor, unsigned int *mapcount,
>  	if (!pmd)
>  		return ret;
> =20
> -	mmun_start =3D address;
> -	mmun_end   =3D end;
> -	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end, event=
);
> +	range.start =3D address;
> +	range.end =3D end;
> +	mmu_notifier_invalidate_range_start(mm, &range);
> =20
>  	/*
>  	 * If we can acquire the mmap_sem for read, and vma is VM_LOCKED,
> @@ -1390,7 +1389,7 @@ static int try_to_unmap_cluster(unsigned long c=
ursor, unsigned int *mapcount,
>  		(*mapcount)--;
>  	}
>  	pte_unmap_unlock(pte - 1, ptl);
> -	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end, event);
> +	mmu_notifier_invalidate_range_end(mm, &range);
>  	if (locked_vma)
>  		up_read(&vma->vm_mm->mmap_sem);
>  	return ret;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0ed3e88..8d8c2ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -318,9 +318,7 @@ static void kvm_mmu_notifier_change_pte(struct mm=
u_notifier *mn,
> =20
>  static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notif=
ier *mn,
>  						    struct mm_struct *mm,
> -						    unsigned long start,
> -						    unsigned long end,
> -						    enum mmu_event event)
> +						    const struct mmu_notifier_range *range)
>  {
>  	struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
>  	int need_tlb_flush =3D 0, idx;
> @@ -333,7 +331,7 @@ static void kvm_mmu_notifier_invalidate_range_sta=
rt(struct mmu_notifier *mn,
>  	 * count is also read inside the mmu_lock critical section.
>  	 */
>  	kvm->mmu_notifier_count++;
> -	need_tlb_flush =3D kvm_unmap_hva_range(kvm, start, end);
> +	need_tlb_flush =3D kvm_unmap_hva_range(kvm, range->start, range->en=
d);
>  	need_tlb_flush |=3D kvm->tlbs_dirty;
>  	/* we've to flush the tlb before the pages can be freed */
>  	if (need_tlb_flush)
> @@ -345,9 +343,7 @@ static void kvm_mmu_notifier_invalidate_range_sta=
rt(struct mmu_notifier *mn,
> =20
>  static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifie=
r *mn,
>  						  struct mm_struct *mm,
> -						  unsigned long start,
> -						  unsigned long end,
> -						  enum mmu_event event)
> +						  const struct mmu_notifier_range *range)
>  {
>  	struct kvm *kvm =3D mmu_notifier_to_kvm(mn);
> =20
> --=20
> 1.9.3
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
