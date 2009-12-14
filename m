From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: InfiniBand/RDMA merge plans for 2.6.33
Date: Mon, 14 Dec 2009 10:37:40 -0800
Message-ID: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since 2.6.32 is already out, it's probably a good time (or at least I
shouldn't wait longer!) to talk about 2.6.33 merge plans.
Unfortunately I lost pretty much a week and a half after Thanksgiving
to the flu, so I'm pretty late and didn't get as much done as I hoped.
Anyway, all the pending things that I'm aware of are listed below.

I've merged and pushed out what I plan to merge in my for-next branch,
and everything has cooked a couple of days in -next, so I'll send a
pull request to Linus shortly.

Boilerplate:

If something isn't already in my tree and it isn't listed below, I
probably missed it or dropped it unintentionally.  Please remind me.

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch or reading it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Read your patch over so I don't see a memory leak or deadlock as
   soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  None of this
means you shouldn't remind me about pending patches, since I often
lose track of things and drop them accidentally.

Core:

 - Merged a series improving IPv6 CMA support, with work from David
   Wilder, Jason Gunthorpe and Sean Hefty.

 - Merged a bunch of small fixes from various people, including a
   number found via code analysis.

ULPs:

 - Nothing major -- I think maybe one IPoIB fix and one iSER fix.

HW specific:

 - Merged a series of fixes from Frank Zago to make the error handling
   behavior of various post_send / post_recv implementations more
   consistent.

 - Merged a bunch of fixes and cleanups for the nes driver.  Nice to
   see continuing work to improve the code from Intel.

Here are a few topics that are not ready in time for the 2.6.33 window
and will need to wait for 2.6.34 at least:

 - Userspace MMU notifiers ("ummunotify").  When I requested that this
   be pulled earlier, I got feedback asking me to explore moving the
   userspace ABI to the perf events framework.  I haven't had time to
   do this yet, so things are kind of stalled.  I'm not convinced that
   perf events fit ummunotify particularly well, but we need to see.
   It also might be worth exploring again whether we can define a set
   of semantics tightly enough to do kernel-level MR caching to avoid
   the complications of defining a more general kernel facility.

 - SRP faster failover.  I haven't had a chance to look closely at the
   latest patches.  I still have the feeling that some corner cases
   are not being handled, but the main problem here was my lack of
   time.  If anyone else (Dave Dillow?) wants to weigh in, that would
   be appreciated too.

 - mlx4 SR-IOV support.  Again, main problem was my lack of time.  I
   agree in principle with this stuff, just want to be careful that we
   don't turn the mlx4 driver into an unmaintainable mess of "if
   (sriov) something; else something_else" all over.

 - New QLogic qib driver.  Needs at least one more iteration of
   cleanups; and I have not had time to look at the latest code in
   detail to see exactly what cleanups are needed.  I am concerned
   that QLogic chose to abandon the ipath driver as unmaintainable,
   and now wants to replace it with an even bigger driver (measured
   by lines of code) that does not support the HT device that ipath
   supported.  How can we make sure qib has a longer future?

 - Jack's XRC patch set.  I still need time to work through and clean
   up the code.  I am in the middle of adding reference counting to
   handle sharing XRC domains between processes, and once that is done
   I'll need to merge the mlx4 changes (and hopefully take some of the
   generic reference counting back into the core).  If someone else
   wants to take a stab, that would be fine by me.

 - IBoE.  In principle I think this is starting to get there.  Still
   want to see better ABI compatibility at least, and also make sure
   the interface chosen works for both rdmacm and non-rdmacm
   applications.

Here all the patches I already have in my for-next branch:

Akinobu Mita (1):
      IB/ipath: Use bitmap_weight()

Alexander Schmidt (1):
      IB/ehca: Rework destroy_eq()

Bart Van Assche (2):
      IB: Clarify the documentation of ib_post_send()
      IB: Fix typo in ipoib.txt

Chien Tung (7):
      RDMA/nes: Add support for IB_WR_*INV
      RDMA/nes: Correct fast memory registration implementation
      RDMA/nes: Add additional SFP+ PHY uC status check and PHY reset
      RDMA/nes: Implement IB_SIGNAL_ALL_WR as an iWARP extension
      RDMA/nes: Clean up struct nes_qp
      RDMA/nes: Add max_cqe check to nes_create_cq()
      RDMA/nes: Update copyright and branding string

David J. Wilder (1):
      IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()

Eli Cohen (2):
      IB/mlx4: Remove unneeded code
      IB/mlx4: Remove limitation on LSO header size

Eric Dumazet (1):
      RDMA/addr: Use appropriate locking with for_each_netdev()

Faisal Latif (11):
      RDMA/nes: Fix MAX_CM_BUFFER define
      RDMA/nes: Fix query of ORD values
      RDMA/nes: MPA request/response error checking
      RDMA/nes: Resource not freed for REJECTed connections
      RDMA/nes: Fix crash in nes_accept()
      RDMA/nes: Abnormal listener exit causes loopback node crash
      RDMA/nes: Fix Xansation test crash on cm_node ref_count
      RDMA/nes: Check for zero STag
      RDMA/nes: Free kmap() resources
      RDMA/nes: FIN during MPA startup causes timeout
      RDMA/nes: Fix stale ARP issue

Frank Zago (5):
      RDMA/nes: In nes_post_send() always set bad_wr on error
      RDMA/nes: In nes_post_recv() always set bad_wr on error
      RDMA/amso1100: Fix error paths in post_send and post_recv
      IB/ehca: Fix error paths in post_send and post_recv
      RDMA/cxgb3: Fix error paths in post_send and post_recv

Jason Gunthorpe (2):
      RDMA/cma: Correct detection of SA Created MGID
      RDMA/cma: Fix AF_INET6 support in multicast joining

Julia Lawall (1):
      RDMA/nes: Pass correct size to ioremap_nocache()

Or Gerlitz (1):
      IB/iser: Rewrite SG handling for RDMA logic

Roel Kluin (1):
      IB/uverbs: Fix return of PTR_ERR() of wrong pointer in ib_uverbs_get_context()

Roland Dreier (1):
      Merge branches 'amso1100', 'cma', 'cxgb3', 'ehca', 'ipath', 'ipoib', 'iser', 'misc', 'mlx4' and 'nes' into for-next

Sean Hefty (7):
      RDMA/ucma: Add option to manually set IB path
      RDMA/cma: Replace net_device pointer with index
      IB/addr: Verify source and destination address families match
      IB/addr: Store net_device type instead of translating to RDMA transport
      RDMA/cm: fix loopback address support
      IB/addr: Simplify resolving IPv4 addresses
      IB/addr: Fix IPv6 routing lookup

Steve Wise (2):
      RDMA/cxgb3: Remove BUG_ON() on CQ rearm failure
      RDMA/cxgb3: Remove BUG_ON() on CQ rearm failure

Yevgeny Petrilin (1):
      mlx4_core: Fix parsing of reserved EQ cap
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
