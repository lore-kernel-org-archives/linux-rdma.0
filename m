From: john.hubbard@gmail.com
Subject: [PATCH v3 0/1] RDMA/umem: minor bug fix in error handling path
Date: Mon,  4 Mar 2019 11:46:44 -0800
Message-ID: <20190304194645.10422-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Hi,

Ira Weiny alerted me to a couple of places where I'd missed a change from
put_page() to put_user_page(), in my pending patchsets. But when I
attempted to dive more deeply into that code, I ran into a bug in the
cleanup code. Leon Romanovsky has confirmed that and requested this
simplified patch to fix it, so here it is.

Changes since v2:

1) Removed the part of the patch that tried to delete "dead code",
because that code was dealing with huge pages.

2) Reverted the pr_*() line shortening, so as to keep this to only
the minimal bug fix required.

3) Rebased to today's linux.git.

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-mm@kvack.org

John Hubbard (1):
  RDMA/umem: minor bug fix in error handling path

 drivers/infiniband/core/umem_odp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.21.0
