From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH v3 0/6] mm: make pinned_vm atomic and simplify users
Date: Wed,  6 Feb 2019 09:59:14 -0800
Message-ID: <20190206175920.31082-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jgg@ziepe.ca, akpm@linux-foundation.org
Cc: dledford@redhat.com, jgg@mellanox.com, jack@suse.cz, willy@infradead.org, ira.weiny@intel.com, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave@stgolabs.net
List-Id: linux-rdma@vger.kernel.org

Changes from v2 (https://patchwork.kernel.org/cover/10774255/):
 - Added more reviews for patch 1 and also fixed mm/debug.c to
   use llx insted of lx so gcc doesn't complain.

 - Re did patch 3 (qib rdma) such that we still have to take
   mmap_sem as it now uses gup_longterm(). gup_fast() conversion
   remains for patch 2 which is not infiniband.

 - Rebased for rdma tree.
 
Changes from v1 (https://patchwork.kernel.org/cover/10764923/):
 - Converted pinned_vm to atomic64 instead of atomic_long such that
   infiniband need not worry about overflows.

 - Rebased patch 1 and added Ira's reviews as well as Parvi's review
   for patch 5 (thanks!).
   
--------

Hi,

The following patches aim to provide cleanups to users that pin pages
(mostly infiniband) by converting the counter to atomic -- note that
Daniel Jordan also has patches[1] for the locked_vm counterpart and vfio.

Apart from removing a source of mmap_sem writer, we benefit in that
we can get rid of a lot of code that defers work when the lock cannot
be acquired, as well as drivers avoiding mmap_sem altogether by also
converting gup to gup_fast() and letting the mm handle it. Users
that do the gup_longterm() remain of course under at least reader mmap_sem.

Everything has been compile-tested _only_ so I hope I didn't do anything
too stupid. Please consider for v5.1.

On a similar topic and potential follow up, it would be nice to resurrect
Peter's VM_PINNED idea in that the broken semantics that occurred after
bc3e53f682 ("mm: distinguish between mlocked and pinned pages") are still
present. Also encapsulating internal mm logic via mm[un]pin() instead of
drivers having to know about internals and playing nice with compaction are
all wins.

Applies against rdma's for-next branch.

Thanks!

[1] https://lkml.org/lkml/2018/11/5/854

Davidlohr Bueso (6):
  mm: make mm->pinned_vm an atomic64 counter
  drivers/mic/scif: do not use mmap_sem
  drivers/IB,qib: optimize mmap_sem usage
  drivers/IB,hfi1: do not se mmap_sem
  drivers/IB,usnic: reduce scope of mmap_sem
  drivers/IB,core: reduce scope of mmap_sem

 drivers/infiniband/core/umem.c              | 47 ++----------------
 drivers/infiniband/hw/hfi1/user_pages.c     | 12 ++---
 drivers/infiniband/hw/qib/qib_user_pages.c  | 75 +++++++++++------------------
 drivers/infiniband/hw/usnic/usnic_ib_main.c |  2 -
 drivers/infiniband/hw/usnic/usnic_uiom.c    | 60 +++--------------------
 drivers/infiniband/hw/usnic/usnic_uiom.h    |  1 -
 drivers/misc/mic/scif/scif_rma.c            | 38 +++++----------
 fs/proc/task_mmu.c                          |  2 +-
 include/linux/mm_types.h                    |  2 +-
 kernel/events/core.c                        |  8 +--
 kernel/fork.c                               |  2 +-
 mm/debug.c                                  |  5 +-
 12 files changed, 65 insertions(+), 189 deletions(-)

-- 
2.16.4
