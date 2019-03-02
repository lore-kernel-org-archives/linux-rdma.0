From: john.hubbard@gmail.com
Subject: [PATCH v2] RDMA/umem: minor bug fix and cleanup in error handling paths
Date: Sat,  2 Mar 2019 12:24:35 -0800
Message-ID: <20190302202435.31889-1-jhubbard@nvidia.com>
References: <20190302032726.11769-2-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190302032726.11769-2-jhubbard@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

1. Bug fix: the error handling release pages starting
at the first page that experienced an error.

2. Refinement: release_pages() is better than put_page()
in a loop.

3. Dead code removal: the check for (user_virt & ~page_mask)
is checking for a condition that can never happen,
because earlier:

    user_virt = user_virt & page_mask;

...so, remove that entire phrase.

4. Minor: As long as I'm here, shorten up a couple of long lines
in the same function, without harming the ability to
grep for the printed error message.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

v2: Fixes a kbuild test robot reported build failure, by directly
    including pagemap.h

 drivers/infiniband/core/umem_odp.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index acb882f279cb..83872c1f3f2c 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -40,6 +40,7 @@
 #include <linux/vmalloc.h>
 #include <linux/hugetlb.h>
 #include <linux/interval_tree_generic.h>
+#include <linux/pagemap.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -648,25 +649,17 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 
 		if (npages < 0) {
 			if (npages != -EAGAIN)
-				pr_warn("fail to get %zu user pages with error %d\n", gup_num_pages, npages);
+				pr_warn("fail to get %zu user pages with error %d\n",
+					gup_num_pages, npages);
 			else
-				pr_debug("fail to get %zu user pages with error %d\n", gup_num_pages, npages);
+				pr_debug("fail to get %zu user pages with error %d\n",
+					 gup_num_pages, npages);
 			break;
 		}
 
 		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
 		mutex_lock(&umem_odp->umem_mutex);
 		for (j = 0; j < npages; j++, user_virt += PAGE_SIZE) {
-			if (user_virt & ~page_mask) {
-				p += PAGE_SIZE;
-				if (page_to_phys(local_page_list[j]) != p) {
-					ret = -EFAULT;
-					break;
-				}
-				put_page(local_page_list[j]);
-				continue;
-			}
-
 			ret = ib_umem_odp_map_dma_single_page(
 					umem_odp, k, local_page_list[j],
 					access_mask, current_seq);
@@ -684,9 +677,11 @@ int ib_umem_odp_map_dma_pages(struct ib_umem_odp *umem_odp, u64 user_virt,
 		mutex_unlock(&umem_odp->umem_mutex);
 
 		if (ret < 0) {
-			/* Release left over pages when handling errors. */
-			for (++j; j < npages; ++j)
-				put_page(local_page_list[j]);
+			/*
+			 * Release pages, starting at the the first page
+			 * that experienced an error.
+			 */
+			release_pages(&local_page_list[j], npages - j);
 			break;
 		}
 	}
-- 
2.21.0
