From: john.hubbard@gmail.com
Subject: [PATCH 0/6] RFC: gup+dma: tracking dma-pinned pages
Date: Thu, 11 Oct 2018 23:00:08 -0700
Message-ID: <20181012060014.10242-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Here is an updated proposal for tracking pages that have had
get_user_pages*() called on them. This is in support of fixing the problem
discussed in [1]. This RFC only shows how to set up a reliable
PageDmaPinned flag. What to *do* with that flag is left for a later
discussion.

I'm providing this in order to help the discussion about patches 1-3, which
I'm hoping to check in first. The sequence would be:

    -- apply patches 1-3, convert the rest of the subsystems to call
       put_user_page*(), then

    -- apply patches 4-6, then

    -- Apply more patches, to actually use the new PageDmaPinned flag.

One question up front is, "how do we ensure that either put_user_page()
or put_page() are called, depending on whether the page came from
get_user_pages() or not?". From this series, you can see that:

    -- It's possible to assert within put_user_page(), that we are in the
       right place.

    -- It's less clear that there is a way to assert within put_page(),
       because put_page() is called from put_user_page(), and PageDmaPinned
       may or may not be set--either case is valid.

       Opinions and ideas are welcome there.

This is a lightly tested example (it boots up on x86_64, and just lets the
dma-pinned pages leak, in all non-infiniband cases...which is all cases, on
my particular test computer). This series just does the following:

a) Provides the put_user_page*() routines that have been discussed in
   another thread (patch 2).

b) Provides a single example of converting some code (infiniband) to use
   those routines (patch 3).

c) Connects up get_user_pages*() to use the new refcounting and flags
   fieldsj (patches 4-6)

[1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"

John Hubbard (6):
  mm: get_user_pages: consolidate error handling
  mm: introduce put_user_page*(), placeholder versions
  infiniband/mm: convert put_page() to put_user_page*()
  mm: introduce page->dma_pinned_flags, _count
  mm: introduce zone_gup_lock, for dma-pinned pages
  mm: track gup pages with page->dma_pinned_* fields

 drivers/infiniband/core/umem.c              |   7 +-
 drivers/infiniband/core/umem_odp.c          |   2 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |  11 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   6 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |  11 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   6 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |   7 +-
 include/linux/mm.h                          |   9 ++
 include/linux/mm_types.h                    |  22 +++-
 include/linux/mmzone.h                      |   6 +
 include/linux/page-flags.h                  |  47 +++++++
 mm/gup.c                                    |  93 +++++++++++---
 mm/memcontrol.c                             |   7 +
 mm/page_alloc.c                             |   1 +
 mm/swap.c                                   | 134 ++++++++++++++++++++
 15 files changed, 319 insertions(+), 50 deletions(-)

-- 
2.19.1
