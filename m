From: Joe Perches <joe@perches.com>
Subject: [PATCH 05/12] IB/ehca: Use DECLARE_BITMAP
Date: Tue, 19 May 2015 18:37:53 -0700
Message-ID: <cd2eb3a07f039222fcd266b793a03d3439b07588.1432085659.git.joe@perches.com>
References: <cover.1432085659.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1432085659.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use the generic mechanism to declare a bitmap instead of unsigned long.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/ehca/ipz_pt_fn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index a801274..19bc344 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -65,7 +65,7 @@ struct ipz_page {
 
 struct ipz_small_queue_page {
 	unsigned long page;
-	unsigned long bitmap[IPZ_SPAGE_PER_KPAGE / BITS_PER_LONG];
+	DECLARE_BITMAP(bitmap, IPZ_SPAGE_PER_KPAGE);
 	int fill;
 	void *mapped_addr;
 	u32 mmap_count;
-- 
2.1.2
