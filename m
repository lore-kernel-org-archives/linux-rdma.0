From: Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for MMU
 notifiers regarding on demand paging regions
Date: Thu, 11 Sep 2014 11:32:56 -0400
Message-ID: <20140911153255.GB1969@gmail.com>
References: <20140904202458.GB2685@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2442C7@MTLDAG02.mtl.com>
 <20140909153627.GA3545@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E244E86@MTLDAG02.mtl.com>
 <20140910201432.GA3801@gmail.com>
 <6B2A6E60C06CCC42AE31809BF572352B010E2456AE@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B010E2456AE-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 11, 2014 at 12:19:01PM +0000, Shachar Raindel wrote:
> 
> 
> > -----Original Message-----
> > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Wednesday, September 10, 2014 11:15 PM
> > To: Shachar Raindel
> > Cc: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Sagi Grimberg
> > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support for
> > MMU notifiers regarding on demand paging regions
> > 
> > On Wed, Sep 10, 2014 at 09:00:36AM +0000, Shachar Raindel wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > Sent: Tuesday, September 09, 2014 6:37 PM
> > > > To: Shachar Raindel
> > > > Cc: 1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Haggai
> > Eran;
> > > > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jerome Glisse; Sagi Grimberg
> > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement support
> > for
> > > > MMU notifiers regarding on demand paging regions
> > > >
> > > > On Sun, Sep 07, 2014 at 02:35:59PM +0000, Shachar Raindel wrote:
> > > > > Hi,
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Jerome Glisse [mailto:j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > > > > > Sent: Thursday, September 04, 2014 11:25 PM
> > > > > > To: Haggai Eran; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > Cc: Shachar Raindel; Sagi Grimberg
> > > > > > Subject: Re: [PATCH v1 for-next 06/16] IB/core: Implement
> > support
> > > > for
> > > > > > MMU notifiers regarding on demand paging regions
> > > > > >
> 
> <SNIP>
> 
> > > > >
> > > > > Sadly, taking mmap_sem in read-only mode does not prevent all
> > possible
> > > > invalidations from happening.
> > > > > For example, a call to madvise requesting MADVISE_DONTNEED will
> > lock
> > > > the mmap_sem for reading only, allowing a notifier to run in
> > parallel to
> > > > the MR registration As a result, the following sequence of events
> > could
> > > > happen:
> > > > >
> > > > > Thread 1:                       |   Thread 2
> > > > > --------------------------------+-------------------------
> > > > > madvise                         |
> > > > > down_read(mmap_sem)             |
> > > > > notifier_start                  |
> > > > >                                 |   down_read(mmap_sem)
> > > > >                                 |   register_mr
> > > > > notifier_end                    |
> > > > > reduce_mr_notifiers_count       |
> > > > >
> > > > > The end result of this sequence is an mr with running notifiers
> > count
> > > > of -1, which is bad.
> > > > > The current workaround is to avoid decreasing the notifiers count
> > if
> > > > it is zero, which can cause other issues.
> > > > > The proper fix would be to prevent notifiers from running in
> > parallel
> > > > to registration. For this, taking mmap_sem in write mode might be
> > > > sufficient, but we are not sure about this.
> > > > > We will be happy to hear additional input on this subject, to make
> > > > sure we got it covered properly.
> > > >
> > > > So in HMM i solve this by having a struct allocated in the start
> > range
> > > > callback
> > > > and the end range callback just ignore things when it can not find
> > the
> > > > matching
> > > > struct.
> > >
> > > This kind of mechanism sounds like it has a bigger risk for
> > deadlocking
> > > the system, causing an OOM kill without a real need or significantly
> > > slowing down the system.
> > > If you are doing non-atomic memory allocations, you can deadlock the
> > > system by requesting memory in the swapper flow.
> > > Even if you are doing atomic memory allocations, you need to handle
> > the
> > > case of failing allocation, the solution to which is unclear to me.
> > > If you are using a pre-allocated pool, what are you doing when you run
> > > out of available entries in the pool? If you are blocking until some
> > > entries free up, what guarantees you that this will not cause a
> > deadlock?
> > 
> > So i am using a fixed pool and when it runs out it block in start
> > callback
> > until one is freed. 
> 
> This sounds scary. You now create a possible locking dependency between
> two code flows which could have run in parallel. This can cause circular
> locking bugs, from code which functioned properly until now. For example,
> assume code with a single lock, and the following code paths:
> 
> Code 1:
> notify_start()
> lock()
> unlock()
> notify_end()
> 
> Code 2:
> lock()
> notify_start()
> ... (no locking)
> notify_end()
> unlock()
> 

This can not happen because all lock taken before notify_start() are
never taken after it and all lock taken inside a start/end section
are never hold accross a notify_start() callback.

> 
> 
> This code can now create the following deadlock:
> 
> Thread 1:        | Thread 2:
> -----------------+-----------------------------------
> notify_start()   |
>                  | lock()
> lock() - blocking|
>                  | notify_start() - blocking for slot
> 
> 
> 
> 
> > But as i said i have a patch to use the stack that
> > will
> > solve this and avoid a pool.
> 
> How are you allocating from the stack an entry which you need to keep alive
> until another function is called? You can't allocate the entry on the
> notify_start stack, so you must do this in all of the call points to the
> mmu_notifiers. Given the notifiers listener subscription pattern, this seems
> like something which is not practical.

Yes the patch add a struct in each callsite of mmu_notifier_invalidate_range
as in all case both start and end are call from same function. The only draw
back is that it increase stack consumption in some of those callsite (not all).
I attach the patch i am thinking of (it is untested) but idea is that through
two new helper function user of mmu_notifier can query active invalid range and
synchronize with those (also require some code in the range_start() callback).

> 
>  
> > 
> > >
> > > >
> > > > That being said when registering the mmu_notifier you need 2 things,
> > > > first you
> > > > need a pin on the mm (either mm is current ie current->mm or you
> > took a
> > > > reference
> > > > on it). Second you need to that the mmap smemaphore in write mode so
> > > > that
> > > > no concurrent mmap/munmap/madvise can happen. By doing that you
> > protect
> > > > yourself
> > > > from concurrent range_start/range_end that can happen and that does
> > > > matter.
> > > > The only concurrent range_start/end that can happen is through file
> > > > invalidation
> > > > which is fine because subsequent page fault will go through the file
> > > > layer and
> > > > bring back page or return error (if file was truncated for
> > instance).
> > >
> > > Sadly, this is not sufficient for our use case. We are registering
> > > a single MMU notifier handler, and broadcast the notifications to
> > > all relevant listeners, which are stored in an interval tree.
> > >
> > > Each listener represents a section of the address space that has been
> > > exposed to the network. Such implementation allows us to limit the
> > impact
> > > of invalidations, and only block racing page faults to the affected
> > areas.
> > >
> > > Each of the listeners maintain a counter of the number of
> > invalidate_range
> > > notifications that are currently affecting it. The counter is
> > increased
> > > for each invalidate_range_start callback received, and decrease for
> > each
> > > invalidate_range_end callback received. If we add a listener to the
> > > interval tree after the invalidate_range_start callback happened, but
> > > before the invalidate_range_end callback happened, it will decrease
> > the
> > > counter, reaching negative numbers and breaking the logic.
> > >
> > > The mmu_notifiers registration code avoid such issues by taking all
> > > relevant locks on the MM. This effectively blocks all possible
> > notifiers
> > > from happening when registering a new notifier. Sadly, this function
> > is
> > > not exported for modules to use it.
> > >
> > > Our options at the moment are:
> > > - Use a tracking mechanism similar to what HMM uses, alongside the
> > >   challenges involved in allocating memory from notifiers
> > >
> > > - Use a per-process counter for invalidations, causing a possible
> > >   performance degradation. This can possibly be used as a fallback to
> > the
> > >   first option (i.e. have a pool of X notifier identifiers, once it is
> > >   full, increase/decrease a per-MM counter)
> > >
> > > - Export the mm_take_all_locks function for modules. This will allow
> > us
> > >   to lock the MM when adding a new listener.
> > 
> > I was not clear enough, you need to take the mmap_sem in write mode
> > accross
> > mmu_notifier_register(). This is only to partialy solve your issue that
> > if
> > a mmu_notifier is already register for the mm you are trying to
> > registering
> > against then there is a chance for you to be inside an active
> > range_start/
> > range_end section which would lead to invalid counter inside your
> > tracking
> > structure. But, sadly, taking mmap_sem in write mode is not enough as
> > file
> > invalidation might still happen concurrently so you will need to make
> > sure
> > you invalidation counters does not go negative but from page fault point
> > of
> > view you will be fine because the page fault will synchronize through
> > the
> > pagecache. So scenario (A and B are to anonymous overlapping address
> > range) :
> > 
> >   APP_TOTO_RDMA_THREAD           |  APP_TOTO_SOME_OTHER_THREAD
> >                                  |  mmu_notifier_invalidate_range_start(A)
> >   odp_register()                 |
> >     down_read(mmap_sem)          |
> >     mmu_notifier_register()      |
> >     up_read(mmap_sem)            |
> >   odp_add_new_region(B)          |
> >   odp_page_fault(B)              |
> >     down_read(mmap_sem)          |
> >     ...                          |
> >     up_read(mmap_sem)            |
> >                                  |  mmu_notifier_invalidate_range_end(A)
> > 
> > The odp_page_fault(B) might see invalid cpu page table but you have no
> > idea
> > about it because you registered after the range_start(). But if you take
> > the
> > mmap_sem in write mode then the only case where you might still have
> > this
> > scenario is if A and B are range of a file backed vma and that the file
> > is
> > undergoing some change (most likely truncation). But the file case is
> > fine
> > because the odp_page_fault() will go through the pagecache which is
> > properly
> > synchronize against the current range invalidation.
> 
> Specifically, if you call mmu_notifier_register you are OK and the above
> scenario will not happen. You are supposed to hold mmap_sem for writing,
> and mmu_notifier_register is calling mm_take_all_locks, which guarantees
> no racing notifier during the registration step.
> 
> However, we want to dynamically add sub-notifiers in our code. Each will
> get notified only about invalidations touching a specific sub-sections of
> the address space. To avoid providing unneeded notifications, we use an
> interval tree that filters only the needed notifications.
> When adding entries to the interval tree, we cannot lock the mm to prevent
> any racing invalidations. As such, we might end up in a case where a newly
> registered memory region will get a "notify_end" call without the relevant
> "notify_start". Even if we prevent the value from dropping below zero, it
> means we can cause data corruption. For example, if we have another
> notifier running after the MR registers, which is due to munmap, but we get
> first the notify_end of the previous notifier for which we didn't see the
> notify_start.
> 
> The solution we are coming up with now is using a global counter of running
> invalidations for new regions allocated. When the global counter is at zero,
> we can safely switch to the region local invalidations counter.

Yes i fully understood that design but as i said this kind of broken and this
is what the attached patch try to address as HMM have the same issue of having
to track all active invalidation range.

> 
> 
> > 
> > 
> > Now for the the general case outside of mmu_notifier_register() HMM also
> > track
> > active invalidation range to avoid page faulting into those range as we
> > can not
> > trust the cpu page table for as long as the range invalidation is on
> > going.
> > 
> > > >
> > > > So as long as you hold the mmap_sem in write mode you should not
> > worry
> > > > about
> > > > concurrent range_start/range_end (well they might happen but only
> > for
> > > > file
> > > > backed vma).
> > > >
> > >
> > > Sadly, the mmap_sem is not enough to protect us :(.
> > 
> > This is enough like i explain above, but i am only talking about the mmu
> > notifier registration. For the general case once you register you only
> > need to take the mmap_sem in read mode during page fault.
> > 
> 
> I think we are not broadcasting on the same wavelength here. The issue I'm
> worried about is of adding a sub-area to our tracking system. It is built
> quite differently from how HMM is built, we are defining areas to track
> a-priori, and later on account how many notifiers are blocking page-faults
> for each area. You are keeping track of the active notifiers, and check
> each page fault against your notifier list. This difference makes for
> different locking needs.
> 
> > > > Given that you face the same issue as i have with the
> > > > range_start/range_end i
> > > > will stich up a patch to make it easier to track those.
> > > >
> > >
> > > That would be nice, especially if we could easily integrate it into
> > our
> > > code and reduce the code size.
> > 
> > Yes it's a "small modification" to the mmu_notifier api, i have been
> > side
> > tracked on other thing. But i will have it soon.
> > 
> 
> Being side tracked is a well-known professional risk in our line of work ;)
> 
> 
> > >
> > > > Cheers,
> > > > Jérôme
> > > >
> > > >

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-mmu_notifier-keep-track-of-active-invalidation-range.patch"
Content-Transfer-Encoding: 8bit

>From 037195e49fbed468d16b78f0364fe302bc732d12 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 11 Sep 2014 11:22:12 -0400
Subject: [PATCH] mmu_notifier: keep track of active invalidation ranges
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The mmu_notifier_invalidate_range_start() and mmu_notifier_invalidate_range_end()
can be considered as forming an "atomic" section for the cpu page table update
point of view. Between this two function the cpu page table content is unreliable
for the affected range of address.

Current user such as kvm need to know when they can trust a the content of the
cpu page table. This becomes even more important to new users of the mmu_notifier
api (such as HMM or ODP).

This patch use a structure define at all call site to invalidate_range_start()
that is added to a list for the duration of the invalidation. It adds two new
helpers to allow querying if a range is being invalidated or to wait for a range
to become valid.

This two new function does not provide strong synchronization but are intended
to be use as helper. User of the mmu_notifier must also synchronize with themself
inside their range_start() and range_end() callback.

Signed-off-by: Jérôme Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/gpu/drm/i915/i915_gem_userptr.c | 13 +++---
 drivers/iommu/amd_iommu_v2.c            |  8 +---
 drivers/misc/sgi-gru/grutlbpurge.c      | 15 +++----
 drivers/xen/gntdev.c                    |  8 ++--
 fs/proc/task_mmu.c                      | 12 +++--
 include/linux/mmu_notifier.h            | 55 ++++++++++++-----------
 mm/fremap.c                             |  8 +++-
 mm/huge_memory.c                        | 78 ++++++++++++++-------------------
 mm/hugetlb.c                            | 49 +++++++++++----------
 mm/memory.c                             | 73 ++++++++++++++++--------------
 mm/migrate.c                            | 16 +++----
 mm/mmu_notifier.c                       | 73 +++++++++++++++++++++++++-----
 mm/mprotect.c                           | 17 ++++---
 mm/mremap.c                             | 14 +++---
 mm/rmap.c                               | 15 +++----
 virt/kvm/kvm_main.c                     | 10 ++---
 16 files changed, 256 insertions(+), 208 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
index a13307d..373ffbb 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -123,26 +123,25 @@ restart:
 
 static void i915_gem_userptr_mn_invalidate_range_start(struct mmu_notifier *_mn,
 						       struct mm_struct *mm,
-						       unsigned long start,
-						       unsigned long end,
-						       enum mmu_event event)
+						       const struct mmu_notifier_range *range)
 {
 	struct i915_mmu_notifier *mn = container_of(_mn, struct i915_mmu_notifier, mn);
 	struct interval_tree_node *it = NULL;
-	unsigned long next = start;
+	unsigned long next = range->start;
 	unsigned long serial = 0;
+	/* interval ranges are inclusive, but invalidate range is exclusive */
+	unsigned long end = range.end - 1;
 
-	end--; /* interval ranges are inclusive, but invalidate range is exclusive */
 	while (next < end) {
 		struct drm_i915_gem_object *obj = NULL;
 
 		spin_lock(&mn->lock);
 		if (mn->has_linear)
-			it = invalidate_range__linear(mn, mm, start, end);
+			it = invalidate_range__linear(mn, mm, range->start, end);
 		else if (serial == mn->serial)
 			it = interval_tree_iter_next(it, next, end);
 		else
-			it = interval_tree_iter_first(&mn->objects, start, end);
+			it = interval_tree_iter_first(&mn->objects, range->start, end);
 		if (it != NULL) {
 			obj = container_of(it, struct i915_mmu_object, it)->obj;
 			drm_gem_object_reference(&obj->base);
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 9a6b837..5945300 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -419,9 +419,7 @@ static void mn_invalidate_page(struct mmu_notifier *mn,
 
 static void mn_invalidate_range_start(struct mmu_notifier *mn,
 				      struct mm_struct *mm,
-				      unsigned long start,
-				      unsigned long end,
-				      enum mmu_event event)
+				      const struct mmu_notifier_range *range)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
@@ -442,9 +440,7 @@ static void mn_invalidate_range_start(struct mmu_notifier *mn,
 
 static void mn_invalidate_range_end(struct mmu_notifier *mn,
 				    struct mm_struct *mm,
-				    unsigned long start,
-				    unsigned long end,
-				    enum mmu_event event)
+				    const struct mmu_notifier_range *range)
 {
 	struct pasid_state *pasid_state;
 	struct device_state *dev_state;
diff --git a/drivers/misc/sgi-gru/grutlbpurge.c b/drivers/misc/sgi-gru/grutlbpurge.c
index e67fed1..44b41b7 100644
--- a/drivers/misc/sgi-gru/grutlbpurge.c
+++ b/drivers/misc/sgi-gru/grutlbpurge.c
@@ -221,8 +221,7 @@ void gru_flush_all_tlb(struct gru_state *gru)
  */
 static void gru_invalidate_range_start(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
-				       unsigned long start, unsigned long end,
-				       enum mmu_event event)
+				       const struct mmu_notifier_range *range)
 {
 	struct gru_mm_struct *gms = container_of(mn, struct gru_mm_struct,
 						 ms_notifier);
@@ -230,14 +229,13 @@ static void gru_invalidate_range_start(struct mmu_notifier *mn,
 	STAT(mmu_invalidate_range);
 	atomic_inc(&gms->ms_range_active);
 	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx, act %d\n", gms,
-		start, end, atomic_read(&gms->ms_range_active));
-	gru_flush_tlb_range(gms, start, end - start);
+		range->start, range->end, atomic_read(&gms->ms_range_active));
+	gru_flush_tlb_range(gms, range->start, range->end - range->start);
 }
 
 static void gru_invalidate_range_end(struct mmu_notifier *mn,
-				     struct mm_struct *mm, unsigned long start,
-				     unsigned long end,
-				     enum mmu_event event)
+				     struct mm_struct *mm,
+				     const struct mmu_notifier_range *range)
 {
 	struct gru_mm_struct *gms = container_of(mn, struct gru_mm_struct,
 						 ms_notifier);
@@ -246,7 +244,8 @@ static void gru_invalidate_range_end(struct mmu_notifier *mn,
 	(void)atomic_dec_and_test(&gms->ms_range_active);
 
 	wake_up_all(&gms->ms_wait_queue);
-	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx\n", gms, start, end);
+	gru_dbg(grudev, "gms %p, start 0x%lx, end 0x%lx\n", gms,
+		range->start, range->end);
 }
 
 static void gru_invalidate_page(struct mmu_notifier *mn, struct mm_struct *mm,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index fe9da94..51f9188 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -428,19 +428,17 @@ static void unmap_if_in_range(struct grant_map *map,
 
 static void mn_invl_range_start(struct mmu_notifier *mn,
 				struct mm_struct *mm,
-				unsigned long start,
-				unsigned long end,
-				enum mmu_event event)
+				const struct mmu_notifier_range *range)
 {
 	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
 	struct grant_map *map;
 
 	spin_lock(&priv->lock);
 	list_for_each_entry(map, &priv->maps, next) {
-		unmap_if_in_range(map, start, end);
+		unmap_if_in_range(map, range->start, range->end);
 	}
 	list_for_each_entry(map, &priv->freeable_maps, next) {
-		unmap_if_in_range(map, start, end);
+		unmap_if_in_range(map, range->start, range->end);
 	}
 	spin_unlock(&priv->lock);
 }
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0ddb975..532a230 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -828,10 +828,15 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 			.mm = mm,
 			.private = &cp,
 		};
+		struct mmu_notifier_range range = {
+			.start = 0,
+			.end = -1UL,
+			.event = MMU_ISDIRTY,
+		};
+
 		down_read(&mm->mmap_sem);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
-			mmu_notifier_invalidate_range_start(mm, 0,
-							    -1, MMU_ISDIRTY);
+			mmu_notifier_invalidate_range_start(mm, &range);
 		for (vma = mm->mmap; vma; vma = vma->vm_next) {
 			cp.vma = vma;
 			if (is_vm_hugetlb_page(vma))
@@ -859,8 +864,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 					&clear_refs_walk);
 		}
 		if (type == CLEAR_REFS_SOFT_DIRTY)
-			mmu_notifier_invalidate_range_end(mm, 0,
-							  -1, MMU_ISDIRTY);
+			mmu_notifier_invalidate_range_end(mm, &range);
 		flush_tlb_mm(mm);
 		up_read(&mm->mmap_sem);
 		mmput(mm);
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 94f6890..f4a2a74 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -69,6 +69,13 @@ enum mmu_event {
 	MMU_WRITE_PROTECT,
 };
 
+struct mmu_notifier_range {
+	struct list_head list;
+	unsigned long start;
+	unsigned long end;
+	enum mmu_event event;
+};
+
 #ifdef CONFIG_MMU_NOTIFIER
 
 /*
@@ -82,6 +89,12 @@ struct mmu_notifier_mm {
 	struct hlist_head list;
 	/* to serialize the list modifications and hlist_unhashed */
 	spinlock_t lock;
+	/* List of all active range invalidations. */
+	struct list_head ranges;
+	/* Number of active range invalidations. */
+	int nranges;
+	/* For threads waiting on range invalidations. */
+	wait_queue_head_t wait_queue;
 };
 
 struct mmu_notifier_ops {
@@ -199,14 +212,10 @@ struct mmu_notifier_ops {
 	 */
 	void (*invalidate_range_start)(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
-				       unsigned long start,
-				       unsigned long end,
-				       enum mmu_event event);
+				       const struct mmu_notifier_range *range);
 	void (*invalidate_range_end)(struct mmu_notifier *mn,
 				     struct mm_struct *mm,
-				     unsigned long start,
-				     unsigned long end,
-				     enum mmu_event event);
+				     const struct mmu_notifier_range *range);
 };
 
 /*
@@ -252,13 +261,15 @@ extern void __mmu_notifier_invalidate_page(struct mm_struct *mm,
 					  unsigned long address,
 					  enum mmu_event event);
 extern void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
-						  unsigned long start,
-						  unsigned long end,
-						  enum mmu_event event);
+						  struct mmu_notifier_range *range);
 extern void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-						unsigned long start,
-						unsigned long end,
-						enum mmu_event event);
+						struct mmu_notifier_range *range);
+extern bool mmu_notifier_range_is_valid(struct mm_struct *mm,
+					unsigned long start,
+					unsigned long end);
+extern void mmu_notifier_range_wait_valid(struct mm_struct *mm,
+					  unsigned long start,
+					  unsigned long end);
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
 {
@@ -300,21 +311,17 @@ static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 }
 
 static inline void mmu_notifier_invalidate_range_start(struct mm_struct *mm,
-						       unsigned long start,
-						       unsigned long end,
-						       enum mmu_event event)
+						       struct mmu_notifier_range *range)
 {
 	if (mm_has_notifiers(mm))
-		__mmu_notifier_invalidate_range_start(mm, start, end, event);
+		__mmu_notifier_invalidate_range_start(mm, range);
 }
 
 static inline void mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-						     unsigned long start,
-						     unsigned long end,
-						     enum mmu_event event)
+						     struct mmu_notifier_range *range)
 {
 	if (mm_has_notifiers(mm))
-		__mmu_notifier_invalidate_range_end(mm, start, end, event);
+		__mmu_notifier_invalidate_range_end(mm, range);
 }
 
 static inline void mmu_notifier_mm_init(struct mm_struct *mm)
@@ -406,16 +413,12 @@ static inline void mmu_notifier_invalidate_page(struct mm_struct *mm,
 }
 
 static inline void mmu_notifier_invalidate_range_start(struct mm_struct *mm,
-						       unsigned long start,
-						       unsigned long end,
-						       enum mmu_event event)
+						       struct mmu_notifier_range *range)
 {
 }
 
 static inline void mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-						     unsigned long start,
-						     unsigned long end,
-						     enum mmu_event event)
+						     struct mmu_notifier_range *range)
 {
 }
 
diff --git a/mm/fremap.c b/mm/fremap.c
index 37b2904..03a5ddc 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -148,6 +148,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	int err = -EINVAL;
 	int has_write_lock = 0;
 	vm_flags_t vm_flags = 0;
+	struct mmu_notifier_range range;
 
 	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
@@ -258,9 +259,12 @@ get_write_lock:
 		vma->vm_flags = vm_flags;
 	}
 
-	mmu_notifier_invalidate_range_start(mm, start, start + size, MMU_MUNMAP);
+	range.start = start;
+	range.end = start + size;
+	range.event = MMU_MUNMAP;
+	mmu_notifier_invalidate_range_start(mm, &range);
 	err = vma->vm_ops->remap_pages(vma, start, size, pgoff);
-	mmu_notifier_invalidate_range_end(mm, start, start + size, MMU_MUNMAP);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	/*
 	 * We can't clear VM_NONLINEAR because we'd have to do
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e3efba5..4b116dd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -988,8 +988,7 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 	pmd_t _pmd;
 	int ret = 0, i;
 	struct page **pages;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	pages = kmalloc(sizeof(struct page *) * HPAGE_PMD_NR,
 			GFP_KERNEL);
@@ -1027,10 +1026,10 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 		cond_resched();
 	}
 
-	mmun_start = haddr;
-	mmun_end   = haddr + HPAGE_PMD_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
-					    MMU_MIGRATE);
+	range.start = haddr;
+	range.end = haddr + HPAGE_PMD_SIZE;
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(mm, &range);
 
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
@@ -1064,8 +1063,7 @@ static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 	page_remove_rmap(page);
 	spin_unlock(ptl);
 
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	ret |= VM_FAULT_WRITE;
 	put_page(page);
@@ -1075,8 +1073,7 @@ out:
 
 out_free_pages:
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
 		memcg = (void *)page_private(pages[i]);
 		set_page_private(pages[i], 0);
@@ -1095,8 +1092,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page = NULL, *new_page;
 	struct mem_cgroup *memcg;
 	unsigned long haddr;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	ptl = pmd_lockptr(mm, pmd);
 	VM_BUG_ON(!vma->anon_vma);
@@ -1166,10 +1162,10 @@ alloc:
 		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
-	mmun_start = haddr;
-	mmun_end   = haddr + HPAGE_PMD_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
-					    MMU_MIGRATE);
+	range.start = haddr;
+	range.end = haddr + HPAGE_PMD_SIZE;
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(mm, &range);
 
 	spin_lock(ptl);
 	if (page)
@@ -1201,8 +1197,7 @@ alloc:
 	}
 	spin_unlock(ptl);
 out_mn:
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 out:
 	return ret;
 out_unlock:
@@ -1633,12 +1628,12 @@ static int __split_huge_page_splitting(struct page *page,
 	spinlock_t *ptl;
 	pmd_t *pmd;
 	int ret = 0;
-	/* For mmu_notifiers */
-	const unsigned long mmun_start = address;
-	const unsigned long mmun_end   = address + HPAGE_PMD_SIZE;
+	struct mmu_notifier_range range;
 
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_HSPLIT);
+	range.start = address;
+	range.end = address + HPAGE_PMD_SIZE;
+	range.event = MMU_HSPLIT;
+	mmu_notifier_invalidate_range_start(mm, &range);
 	pmd = page_check_address_pmd(page, mm, address,
 			PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG, &ptl);
 	if (pmd) {
@@ -1653,8 +1648,7 @@ static int __split_huge_page_splitting(struct page *page,
 		ret = 1;
 		spin_unlock(ptl);
 	}
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_HSPLIT);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	return ret;
 }
@@ -2434,8 +2428,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	int isolated;
 	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -2475,10 +2468,10 @@ static void collapse_huge_page(struct mm_struct *mm,
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
 
-	mmun_start = address;
-	mmun_end   = address + HPAGE_PMD_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	range.start = address;
+	range.end = address + HPAGE_PMD_SIZE;
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(mm, &range);
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
 	 * After this gup_fast can't run anymore. This also removes
@@ -2488,8 +2481,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	_pmd = pmdp_clear_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -2872,36 +2864,32 @@ void __split_huge_page_pmd(struct vm_area_struct *vma, unsigned long address,
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	BUG_ON(vma->vm_start > haddr || vma->vm_end < haddr + HPAGE_PMD_SIZE);
 
-	mmun_start = haddr;
-	mmun_end   = haddr + HPAGE_PMD_SIZE;
+	range.start = haddr;
+	range.end = haddr + HPAGE_PMD_SIZE;
+	range.event = MMU_MIGRATE;
 again:
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_start(mm, &range);
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_trans_huge(*pmd))) {
 		spin_unlock(ptl);
-		mmu_notifier_invalidate_range_end(mm, mmun_start,
-						  mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(mm, &range);
 		return;
 	}
 	if (is_huge_zero_pmd(*pmd)) {
 		__split_huge_zero_page_pmd(vma, haddr, pmd);
 		spin_unlock(ptl);
-		mmu_notifier_invalidate_range_end(mm, mmun_start,
-						  mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(mm, &range);
 		return;
 	}
 	page = pmd_page(*pmd);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	get_page(page);
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	split_huge_page(page);
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ae98b53..6484793 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2551,17 +2551,16 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	int cow;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 	int ret = 0;
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
-	mmun_start = vma->vm_start;
-	mmun_end = vma->vm_end;
+	range.start = vma->vm_start;
+	range.end = vma->vm_end;
+	range.event = MMU_MIGRATE;
 	if (cow)
-		mmu_notifier_invalidate_range_start(src, mmun_start,
-						    mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_start(src, &range);
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
@@ -2612,8 +2611,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	}
 
 	if (cow)
-		mmu_notifier_invalidate_range_end(src, mmun_start,
-						  mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(src, &range);
 
 	return ret;
 }
@@ -2631,16 +2629,17 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	const unsigned long mmun_start = start;	/* For mmu_notifiers */
-	const unsigned long mmun_end   = end;	/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
 
+	range.start = start;
+	range.end = end;
+	range.event = MMU_MIGRATE;
 	tlb_start_vma(tlb, vma);
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_start(mm, &range);
 again:
 	for (address = start; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
@@ -2711,8 +2710,7 @@ unlock:
 		if (address < end && !ref_page)
 			goto again;
 	}
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -2809,8 +2807,7 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
 	int ret = 0, outside_reserve = 0;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 
 	old_page = pte_page(pte);
 
@@ -2888,10 +2885,11 @@ retry_avoidcopy:
 			    pages_per_huge_page(h));
 	__SetPageUptodate(new_page);
 
-	mmun_start = address & huge_page_mask(h);
-	mmun_end = mmun_start + huge_page_size(h);
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end,
-					    MMU_MIGRATE);
+	range.start = address;
+	range.end = address + huge_page_size(h);
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(mm, &range);
+
 	/*
 	 * Retake the page table lock to check for racing updates
 	 * before the page tables are altered
@@ -2911,8 +2909,7 @@ retry_avoidcopy:
 		new_page = old_page;
 	}
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end,
-					  MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 out_release_all:
 	page_cache_release(new_page);
 out_release_old:
@@ -3346,11 +3343,15 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long pages = 0;
+	struct mmu_notifier_range range;
 
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
-	mmu_notifier_invalidate_range_start(mm, start, end, MMU_MPROT);
+	range.start = start;
+	range.end = end;
+	range.event = MMU_MPROT;
+	mmu_notifier_invalidate_range_start(mm, &range);
 	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
@@ -3380,7 +3381,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 */
 	flush_tlb_range(vma, start, end);
 	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
-	mmu_notifier_invalidate_range_end(mm, start, end, MMU_MPROT);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	return pages << h->order;
 }
diff --git a/mm/memory.c b/mm/memory.c
index 1c212e6..c1c7ccc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1008,8 +1008,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	unsigned long next;
 	unsigned long addr = vma->vm_start;
 	unsigned long end = vma->vm_end;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 	bool is_cow;
 	int ret;
 
@@ -1045,11 +1044,11 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * is_cow_mapping() returns true.
 	 */
 	is_cow = is_cow_mapping(vma->vm_flags);
-	mmun_start = addr;
-	mmun_end   = end;
+	range.start = addr;
+	range.end = end;
+	range.event = MMU_MIGRATE;
 	if (is_cow)
-		mmu_notifier_invalidate_range_start(src_mm, mmun_start,
-						    mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_start(src_mm, &range);
 
 	ret = 0;
 	dst_pgd = pgd_offset(dst_mm, addr);
@@ -1066,8 +1065,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
 	if (is_cow)
-		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end,
-						  MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(src_mm, &range);
 	return ret;
 }
 
@@ -1370,13 +1368,16 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unsigned long end_addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range = {
+		.start = start_addr,
+		.end = end_addr,
+		.event = MMU_MUNMAP,
+	};
 
-	mmu_notifier_invalidate_range_start(mm, start_addr,
-					    end_addr, MMU_MUNMAP);
+	mmu_notifier_invalidate_range_start(mm, &range);
 	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next)
 		unmap_single_vma(tlb, vma, start_addr, end_addr, NULL);
-	mmu_notifier_invalidate_range_end(mm, start_addr,
-					  end_addr, MMU_MUNMAP);
+	mmu_notifier_invalidate_range_end(mm, &range);
 }
 
 /**
@@ -1393,16 +1394,20 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
-	unsigned long end = start + size;
+	struct mmu_notifier_range range = {
+		.start = start,
+		.end = start + size,
+		.event = MMU_MUNMAP,
+	};
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, start, end);
+	tlb_gather_mmu(&tlb, mm, start, range.end);
 	update_hiwater_rss(mm);
-	mmu_notifier_invalidate_range_start(mm, start, end, MMU_MUNMAP);
-	for ( ; vma && vma->vm_start < end; vma = vma->vm_next)
-		unmap_single_vma(&tlb, vma, start, end, details);
-	mmu_notifier_invalidate_range_end(mm, start, end, MMU_MUNMAP);
-	tlb_finish_mmu(&tlb, start, end);
+	mmu_notifier_invalidate_range_start(mm, &range);
+	for ( ; vma && vma->vm_start < range.end; vma = vma->vm_next)
+		unmap_single_vma(&tlb, vma, start, range.end, details);
+	mmu_notifier_invalidate_range_end(mm, &range);
+	tlb_finish_mmu(&tlb, start, range.end);
 }
 
 /**
@@ -1419,15 +1424,19 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct mmu_gather tlb;
-	unsigned long end = address + size;
+	struct mmu_notifier_range range = {
+		.start = address,
+		.end = address + size,
+		.event = MMU_MUNMAP,
+	};
 
 	lru_add_drain();
-	tlb_gather_mmu(&tlb, mm, address, end);
+	tlb_gather_mmu(&tlb, mm, address, range.end);
 	update_hiwater_rss(mm);
-	mmu_notifier_invalidate_range_start(mm, address, end, MMU_MUNMAP);
-	unmap_single_vma(&tlb, vma, address, end, details);
-	mmu_notifier_invalidate_range_end(mm, address, end, MMU_MUNMAP);
-	tlb_finish_mmu(&tlb, address, end);
+	mmu_notifier_invalidate_range_start(mm, &range);
+	unmap_single_vma(&tlb, vma, address, range.end, details);
+	mmu_notifier_invalidate_range_end(mm, &range);
+	tlb_finish_mmu(&tlb, address, range.end);
 }
 
 /**
@@ -2047,8 +2056,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	int ret = 0;
 	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
-	unsigned long mmun_start = 0;	/* For mmu_notifiers */
-	unsigned long mmun_end = 0;	/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 	struct mem_cgroup *memcg;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
@@ -2208,10 +2216,10 @@ gotten:
 	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
 		goto oom_free_new;
 
-	mmun_start  = address & PAGE_MASK;
-	mmun_end    = mmun_start + PAGE_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	range.start = address & PAGE_MASK;
+	range.end = range.start + PAGE_SIZE;
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(mm, &range);
 
 	/*
 	 * Re-check the pte - we dropped the lock
@@ -2282,8 +2290,7 @@ gotten:
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (mmun_end > mmun_start)
-		mmu_notifier_invalidate_range_end(mm, mmun_start,
-						  mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(mm, &range);
 	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
diff --git a/mm/migrate.c b/mm/migrate.c
index 30417d5..d866771 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1781,10 +1781,13 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	int isolated = 0;
 	struct page *new_page = NULL;
 	int page_lru = page_is_file_cache(page);
-	unsigned long mmun_start = address & HPAGE_PMD_MASK;
-	unsigned long mmun_end = mmun_start + HPAGE_PMD_SIZE;
+	struct mmu_notifier_range range;
 	pmd_t orig_entry;
 
+	range.start = address & HPAGE_PMD_MASK;
+	range.end = range.start + HPAGE_PMD_SIZE;
+	range.event = MMU_MIGRATE;
+
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
@@ -1819,14 +1822,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	WARN_ON(PageLRU(new_page));
 
 	/* Recheck the target PMD */
-	mmu_notifier_invalidate_range_start(mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_start(mm, &range);
 	ptl = pmd_lock(mm, pmd);
 	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
 fail_putback:
 		spin_unlock(ptl);
-		mmu_notifier_invalidate_range_end(mm, mmun_start,
-						  mmun_end, MMU_MIGRATE);
+		mmu_notifier_invalidate_range_end(mm, &range);
 
 		/* Reverse changes made by migrate_page_copy() */
 		if (TestClearPageActive(new_page))
@@ -1879,8 +1880,7 @@ fail_putback:
 	page_remove_rmap(page);
 
 	spin_unlock(ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(mm, &range);
 
 	/* Take an "isolate" reference and put new page on the LRU. */
 	get_page(new_page);
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index de039e4..d0edb98 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -173,9 +173,7 @@ void __mmu_notifier_invalidate_page(struct mm_struct *mm,
 }
 
 void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
-					   unsigned long start,
-					   unsigned long end,
-					   enum mmu_event event)
+					   struct mmu_notifier_range *range)
 
 {
 	struct mmu_notifier *mn;
@@ -184,31 +182,83 @@ void __mmu_notifier_invalidate_range_start(struct mm_struct *mm,
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->invalidate_range_start)
-			mn->ops->invalidate_range_start(mn, mm, start,
-							end, event);
+			mn->ops->invalidate_range_start(mn, mm, range);
 	}
 	srcu_read_unlock(&srcu, id);
+
+	/*
+	 * This must happen after the callback so that subsystem can block on
+	 * new invalidation range to synchronize itself.
+	 */
+	spin_lock(&mm->mmu_notifier_mm->lock);
+	list_add_tail(&range->list, &mm->mmu_notifier_mm->ranges);
+	mm->mmu_notifier_mm->nranges++;
+	spin_unlock(&mm->mmu_notifier_mm->lock);
 }
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_start);
 
 void __mmu_notifier_invalidate_range_end(struct mm_struct *mm,
-					 unsigned long start,
-					 unsigned long end,
-					 enum mmu_event event)
+					 struct mmu_notifier_range *range)
 {
 	struct mmu_notifier *mn;
 	int id;
 
+	/*
+	 * This must happen before the callback so that subsystem can unblock
+	 * when range invalidation end.
+	 */
+	spin_lock(&mm->mmu_notifier_mm->lock);
+	list_del_init(&range->list);
+	mm->mmu_notifier_mm->nranges--;
+	spin_unlock(&mm->mmu_notifier_mm->lock);
+
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->invalidate_range_end)
-			mn->ops->invalidate_range_end(mn, mm, start,
-						      end, event);
+			mn->ops->invalidate_range_end(mn, mm, range);
 	}
 	srcu_read_unlock(&srcu, id);
+
+	/*
+	 * Wakeup after callback so they can do their job before any of the
+	 * waiters resume.
+	 */
+	wake_up(&mm->mmu_notifier_mm->wait_queue);
 }
 EXPORT_SYMBOL_GPL(__mmu_notifier_invalidate_range_end);
 
+bool mmu_notifier_range_is_valid(struct mm_struct *mm,
+				 unsigned long start,
+				 unsigned long end)
+{
+	struct mmu_notifier_range range;
+
+	spin_lock(&mm->mmu_notifier_mm->lock);
+	list_for_each_entry(range, &mm->mmu_notifier_mm->ranges, list) {
+		if (!(range->end <= start || range->start >= end)) {
+			spin_unlock(&mm->mmu_notifier_mm->lock);
+			return false;
+		}
+	}
+	spin_unlock(&mm->mmu_notifier_mm->lock);
+	return true;
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_range_is_valid);
+
+void mmu_notifier_range_wait_valid(struct mm_struct *mm,
+				   unsigned long start,
+				   unsigned long end)
+{
+	int nranges = mm->mmu_notifier_mm->nranges;
+
+	while (!mmu_notifier_range_is_valid(mm, start, end)) {
+		wait_event(mm->mmu_notifier_mm->wait_queue,
+			   nranges != mm->mmu_notifier_mm->nranges);
+		nranges = mm->mmu_notifier_mm->nranges;
+	}
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_range_wait_valid);
+
 static int do_mmu_notifier_register(struct mmu_notifier *mn,
 				    struct mm_struct *mm,
 				    int take_mmap_sem)
@@ -238,6 +288,9 @@ static int do_mmu_notifier_register(struct mmu_notifier *mn,
 	if (!mm_has_notifiers(mm)) {
 		INIT_HLIST_HEAD(&mmu_notifier_mm->list);
 		spin_lock_init(&mmu_notifier_mm->lock);
+		INIT_LIST_HEAD(&mmu_notifier_mm->ranges);
+		mmu_notifier_mm->nranges = 0;
+		init_waitqueue_head(&mmu_notifier_mm->wait_queue);
 
 		mm->mmu_notifier_mm = mmu_notifier_mm;
 		mmu_notifier_mm = NULL;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 886405b..a178b22 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -144,7 +144,9 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 	unsigned long next;
 	unsigned long pages = 0;
 	unsigned long nr_huge_updates = 0;
-	unsigned long mni_start = 0;
+	struct mmu_notifier_range range = {
+		.start = 0,
+	};
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -155,10 +157,11 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 			continue;
 
 		/* invoke the mmu notifier if the pmd is populated */
-		if (!mni_start) {
-			mni_start = addr;
-			mmu_notifier_invalidate_range_start(mm, mni_start,
-							    end, MMU_MPROT);
+		if (!range.start) {
+			range.start = addr;
+			range.end = end;
+			range.event = MMU_MPROT;
+			mmu_notifier_invalidate_range_start(mm, &range);
 		}
 
 		if (pmd_trans_huge(*pmd)) {
@@ -185,8 +188,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
-	if (mni_start)
-		mmu_notifier_invalidate_range_end(mm, mni_start, end, MMU_MPROT);
+	if (range.start)
+		mmu_notifier_invalidate_range_end(mm, &range);
 
 	if (nr_huge_updates)
 		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
diff --git a/mm/mremap.c b/mm/mremap.c
index 6827d2f..83c5eed 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -167,18 +167,17 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 		bool need_rmap_locks)
 {
 	unsigned long extent, next, old_end;
+	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 	bool need_flush = false;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
-	mmun_start = old_addr;
-	mmun_end   = old_end;
-	mmu_notifier_invalidate_range_start(vma->vm_mm, mmun_start,
-					    mmun_end, MMU_MIGRATE);
+	range.start = old_addr;
+	range.end = old_end;
+	range.event = MMU_MIGRATE;
+	mmu_notifier_invalidate_range_start(vma->vm_mm, &range);
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
@@ -229,8 +228,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	if (likely(need_flush))
 		flush_tlb_range(vma, old_end-len, old_addr);
 
-	mmu_notifier_invalidate_range_end(vma->vm_mm, mmun_start,
-					  mmun_end, MMU_MIGRATE);
+	mmu_notifier_invalidate_range_end(vma->vm_mm, &range);
 
 	return len + old_addr - old_end;	/* how much done */
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index 0b67e7d..b8b8a60 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1302,15 +1302,14 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 	spinlock_t *ptl;
 	struct page *page;
 	unsigned long address;
-	unsigned long mmun_start;	/* For mmu_notifiers */
-	unsigned long mmun_end;		/* For mmu_notifiers */
+	struct mmu_notifier_range range;
 	unsigned long end;
 	int ret = SWAP_AGAIN;
 	int locked_vma = 0;
-	enum mmu_event event = MMU_MIGRATE;
 
+	range.event = MMU_MIGRATE;
 	if (flags & TTU_MUNLOCK)
-		event = MMU_MUNLOCK;
+		range.event = MMU_MUNLOCK;
 
 	address = (vma->vm_start + cursor) & CLUSTER_MASK;
 	end = address + CLUSTER_SIZE;
@@ -1323,9 +1322,9 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 	if (!pmd)
 		return ret;
 
-	mmun_start = address;
-	mmun_end   = end;
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end, event);
+	range.start = address;
+	range.end = end;
+	mmu_notifier_invalidate_range_start(mm, &range);
 
 	/*
 	 * If we can acquire the mmap_sem for read, and vma is VM_LOCKED,
@@ -1390,7 +1389,7 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
 		(*mapcount)--;
 	}
 	pte_unmap_unlock(pte - 1, ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end, event);
+	mmu_notifier_invalidate_range_end(mm, &range);
 	if (locked_vma)
 		up_read(&vma->vm_mm->mmap_sem);
 	return ret;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0ed3e88..8d8c2ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -318,9 +318,7 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 						    struct mm_struct *mm,
-						    unsigned long start,
-						    unsigned long end,
-						    enum mmu_event event)
+						    const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int need_tlb_flush = 0, idx;
@@ -333,7 +331,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
-	need_tlb_flush = kvm_unmap_hva_range(kvm, start, end);
+	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
 	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)
@@ -345,9 +343,7 @@ static void kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 						  struct mm_struct *mm,
-						  unsigned long start,
-						  unsigned long end,
-						  enum mmu_event event)
+						  const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 
-- 
1.9.3


--ZGiS0Q5IWpPtfppv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
