From: ira.weiny@intel.com
Subject: [PATCH 3/3] IB/HFI1: Use new get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 12:16:43 -0800
Message-ID: <20190211201643.7599-4-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211201643.7599-1-ira.weiny@intel.com>
Sender: netdev-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Use the new get_user_pages_fast_longterm() call to protect against
FS DAX pages being mapped.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/infiniband/hw/hfi1/user_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 24b592c6522e..b94ab5385a09 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -105,7 +105,7 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t np
 {
 	int ret;
 
-	ret = get_user_pages_fast(vaddr, npages, writable, pages);
+	ret = get_user_pages_fast_longterm(vaddr, npages, writable, pages);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1
