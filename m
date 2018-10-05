From: john.hubbard@gmail.com
Subject: [PATCH v2 0/3] get_user_pages*() and RDMA: first steps
Date: Thu,  4 Oct 2018 21:02:22 -0700
Message-ID: <20181005040225.14292-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christopher Lameter <cl@linux.com>, Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Al Viro <viro@zeniv.linux.org.uk>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Changes since v1:

-- Renamed release_user_pages*() to put_user_pages*(), from Jan's feedback.

-- Removed the goldfish.c changes, and instead, only included a single
   user (infiniband) of the new functions. That is because goldfish.c no
   longer has a name collision (it has a release_user_pages() routine), and
   also because infiniband exercises both the put_user_page() and
   put_user_pages*() paths.

-- Updated links to discussions and plans, so as to be sure to include
   bounce buffers, thanks to Jerome's feedback.

Also:

-- Dennis, thanks for your earlier review, and I have not yet added your
   Reviewed-by tag, because this revision changes the things that you had
   previously reviewed, thus potentially requiring another look.

This short series prepares for eventually fixing the problem described
in [1], and is following a plan listed in [2], [3], [4].

I'd like to get the first two patches into the -mm tree.

Patch 1, although not technically critical to do now, is still nice to
have, because it's already been reviewed by Jan, and it's just one more
thing on the long TODO list here, that is ready to be checked off.

Patch 2 is required in order to allow me (and others, if I'm lucky) to
start submitting changes to convert all of the callsites of
get_user_pages*() and put_page().  I think this will work a lot better
than trying to maintain a massive patchset and submitting all at once.

Patch 3 converts infiniband drivers: put_page() --> put_user_page(), and
also exercises put_user_pages_dirty_locked().

Once these are all in, then the floodgates can open up to convert the large
number of get_user_pages*() callsites.

[1] https://lwn.net/Articles/753027/ : "The Trouble with get_user_pages()"

[2] https://lkml.kernel.org/r/20180709080554.21931-1-jhubbard@nvidia.com
    Proposed steps for fixing get_user_pages() + DMA problems.

[3]https://lkml.kernel.org/r/20180710082100.mkdwngdv5kkrcz6n@quack2.suse.cz
    Bounce buffers (otherwise [2] is not really viable).

[4] https://lkml.kernel.org/r/20181003162115.GG24030@quack2.suse.cz
    Follow-up discussions.

CC: Matthew Wilcox <willy@infradead.org>
CC: Michal Hocko <mhocko@kernel.org>
CC: Christopher Lameter <cl@linux.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Jerome Glisse <jglisse@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>

John Hubbard (3):
  mm: get_user_pages: consolidate error handling
  mm: introduce put_user_page[s](), placeholder versions
  infiniband/mm: convert to the new put_user_page[s]() calls

 drivers/infiniband/core/umem.c              |  2 +-
 drivers/infiniband/core/umem_odp.c          |  2 +-
 drivers/infiniband/hw/hfi1/user_pages.c     | 11 ++----
 drivers/infiniband/hw/mthca/mthca_memfree.c |  6 +--
 drivers/infiniband/hw/qib/qib_user_pages.c  | 11 ++----
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  8 ++--
 drivers/infiniband/hw/usnic/usnic_uiom.c    |  2 +-
 include/linux/mm.h                          | 42 ++++++++++++++++++++-
 mm/gup.c                                    | 37 ++++++++++--------
 9 files changed, 80 insertions(+), 41 deletions(-)

-- 
2.19.0
