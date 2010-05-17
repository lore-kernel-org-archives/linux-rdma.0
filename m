From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: InfiniBand/RDMA merge plans for 2.6.35
Date: Mon, 17 May 2010 09:36:09 -0700
Message-ID: <adaiq6mo58m.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since 2.6.34 is here, it's probably a good time to talk about 2.6.35
merge plans.  All the pending things that I'm aware of are listed below.

Boilerplate:

If something isn't already in my tree and it isn't listed below, I
probably missed it or dropped it unintentionally.  Please remind me.

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch now, or trying to understand it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Check your patch over at least enough so I don't see a memory leak
   or deadlock as soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  We currently
have a big imbalance between people who are writing patches (many) and
people who are reviewing patches (mostly me).  None of this means you
shouldn't remind me about pending patches, since I often lose track of
things and drop them accidentally.

Core:

 - Added support for masked atomic operations.

ULPs:

 - Merged a series of iSER failover improvements.

HW specific:

 - Added the iw_cxgb4 driver for new Chelsio T4 adapters.

 - Added masked atomic support to mlx4.

 - Removed use of the older PCI state API in favor of the new DMA
   state API.

 - A few other fixes here and there.

Here are a few topics that are not ready in time for the 2.6.35 window
and will need to wait for 2.6.36 at least:

 - XRC.  While I think we made significant progress here, the fact is
   that this is not ready to merge at the beginning of the merge
   window, and so we'll need to keep working on it and wait for the
   next merge window.

 - IBoE.  Same as XRC; we made significant progress (and I opened an
   iboe branch to track this), but we still do not have even the
   user-kernel interface really nailed down yet.

 - New QLogic qib driver.  If a new set of patches shows up soon, we
   can probably sneak this in, since it is essentially a new hardware
   driver that affects little else.  However the sheer size of the
   driver means we need to get this in early in the release cycle.

Here all the patches I already have in my for-next branch:

Chien Tung (1):
      RDMA/nes: Make nesadapter->phy_lock usage consistent

Dan Carpenter (1):
      IB/iser: Fix error flow in iser_create_ib_conn_res()

FUJITA Tomonori (3):
      RDMA/cxgb3: Use the dma state API instead of pci equivalents
      RDMA/amso1100: Use the dma state API instead of pci equivalents
      IB/mthca: Use the dma state API instead of pci equivalents

Julia Lawall (1):
      IB/core: Use kmemdup() instead of kmalloc()+memcpy()

Or Gerlitz (4):
      IPoIB: Allow disabling/enabling TSO on the fly through ethtool
      IB/iser: Add asynchronous event handler
      IB/iser: Remove buggy back-pointer setting
      IB/iser: Enhance disconnection logic for multi-pathing

Roland Dreier (4):
      IB: Explicitly rule out llseek to avoid BKL in default_llseek()
      RDMA/nes: Make unnecessarily global functions static
      RDMA/cxgb3: Shrink .text with compile-time init of handlers arrays
      MAINTAINERS: Add cxgb4 and iw_cxgb4 entries

Steve Wise (2):
      RDMA/cxgb3: Don't free skbs on NET_XMIT_* indications from LLD
      RDMA/cxgb4: Add driver for Chelsio T4 RNIC

Tetsuo Handa (1):
      RDMA/cma: Randomize local port allocation

Vladimir Sokolovsky (2):
      IB/core: Add support for masked atomic operations
      IB/mlx4: Add support for masked atomic operations
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
