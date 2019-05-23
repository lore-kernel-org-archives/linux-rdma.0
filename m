From: john.hubbard@gmail.com
Subject: [PATCH 0/1] infiniband/mm: convert put_page() to put_user_page*()
Date: Thu, 23 May 2019 00:25:36 -0700
Message-ID: <20190523072537.31940-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Christian Benvenuti <benve@cisco.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@mellanox.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

Hi Jason and all,

IIUC, now that we have the put_user_pages() merged in to linux.git, we can
start sending up the callsite conversions via different subsystem
maintainer trees. Here's one for linux-rdma.

I've left the various Reviewed-by: and Tested-by: tags on here, even
though it's been through a few rebases.

If anyone has hardware, it would be good to get a real test of this.

thanks,
--
John Hubbard
NVIDIA

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Ira Weiny <ira.weiny@intel.com>

John Hubbard (1):
  infiniband/mm: convert put_page() to put_user_page*()

 drivers/infiniband/core/umem.c              |  7 ++++---
 drivers/infiniband/core/umem_odp.c          | 10 +++++-----
 drivers/infiniband/hw/hfi1/user_pages.c     | 11 ++++-------
 drivers/infiniband/hw/mthca/mthca_memfree.c |  6 +++---
 drivers/infiniband/hw/qib/qib_user_pages.c  | 11 ++++-------
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  6 +++---
 drivers/infiniband/hw/usnic/usnic_uiom.c    |  7 ++++---
 7 files changed, 27 insertions(+), 31 deletions(-)

-- 
2.21.0
