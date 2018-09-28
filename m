From: john.hubbard@gmail.com
Subject: [PATCH 0/4] get_user_pages*() and RDMA: first steps
Date: Thu, 27 Sep 2018 22:39:45 -0700
Message-ID: <20180928053949.5381-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Christian Benvenuti <benve@cisco.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Hi,

This short series prepares for eventually fixing the problem described
in [1], and is following a plan listed in [2].

I'd like to get the first two patches into the -mm tree.

Patch 1, although not technically critical to do now, is still nice to have,
because it's already been reviewed by Jan, and it's just one more thing on the
long TODO list here, that is ready to be checked off.

Patch 2 is required in order to allow me (and others, if I'm lucky) to start
submitting changes to convert all of the callsites of get_user_pages*() and
put_page().  I think this will work a lot better than trying to maintain a
massive patchset and submitting all at once.

Patch 3 converts infiniband drivers: put_page() --> put_user_page(). I picked
a fairly small and easy example.

Patch 4 converts a small driver from put_page() --> release_user_pages(). This
could just as easily have been done as a change from put_page() to
put_user_page(). The reason I did it this way is that this provides a small and
simple caller of the new release_user_pages() routine. I wanted both of the
new routines, even though just placeholders, to have callers.

Once these are all in, then the floodgates can open up to convert the large
number of get_user_pages*() callsites.

[1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"

[2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
    Proposed steps for fixing get_user_pages() + DMA problems.

CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christian Benvenuti <benve@cisco.com>
CC: Christopher Lameter <cl@linux.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Dennis Dalessandro <dennis.dalessandro@intel.com>
CC: Doug Ledford <dledford@redhat.com>
CC: Jan Kara <jack@suse.cz>
CC: Jason Gunthorpe <jgg@ziepe.ca>
CC: Matthew Wilcox <willy@infradead.org>
CC: Michal Hocko <mhocko@kernel.org>
CC: Mike Marciniszyn <mike.marciniszyn@intel.com>
CC: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org
CC: linux-rdma@vger.kernel.org

John Hubbard (4):
  mm: get_user_pages: consolidate error handling
  mm: introduce put_user_page(), placeholder version
  infiniband/mm: convert to the new put_user_page() call
  goldfish_pipe/mm: convert to the new release_user_pages() call

 drivers/infiniband/core/umem.c              |  2 +-
 drivers/infiniband/core/umem_odp.c          |  2 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |  2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |  6 ++--
 drivers/infiniband/hw/qib/qib_user_pages.c  |  2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  8 ++---
 drivers/infiniband/hw/usnic/usnic_uiom.c    |  2 +-
 drivers/platform/goldfish/goldfish_pipe.c   |  7 ++--
 include/linux/mm.h                          | 14 ++++++++
 mm/gup.c                                    | 37 ++++++++++++---------
 10 files changed, 52 insertions(+), 30 deletions(-)

-- 
2.19.0
