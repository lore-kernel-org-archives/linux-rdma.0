From: john.hubbard@gmail.com
Subject: [PATCH] RDMA/umem: updated bug fix in error handling path
Date: Tue,  5 Mar 2019 18:00:22 -0800
Message-ID: <20190306020022.21828-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Artemy Kovalyov <artemyko@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

The previous attempted bug fix overlooked the fact that
ib_umem_odp_map_dma_single_page() was doing a put_page()
upon hitting an error. So there was not really a bug there.

Therefore, this reverts the off-by-one change, but
keeps the change to use release_pages() in the error path.

Fixes: commit xxxxxxxxxxxx ("RDMA/umem: minor bug fix in error handling path")
Suggested-by: Artemy Kovalyov <artemyko@mellanox.com>

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/infiniband/core/umem_odp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index d45735b02e07..c9cafaa080e7 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -686,10 +686,13 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 
 		if (ret < 0) {
 			/*
-			 * Release pages, starting at the the first page
-			 * that experienced an error.
+			 * Release pages, remembering that the first page
+			 * to hit an error was already released by
+			 * ib_umem_odp_map_dma_single_page().
 			 */
-			release_pages(&local_page_list[j], npages - j);
+			if (npages - (j + 1) > 0)
+				release_pages(&local_page_list[j+1],
+					      npages - (j + 1));
 			break;
 		}
 	}
-- 
2.21.0
