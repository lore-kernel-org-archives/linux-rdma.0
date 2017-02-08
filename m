From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/14] RDMA/cxgb4: Use kmalloc_array() in
 c4iw_id_table_alloc()
Date: Wed, 8 Feb 2017 22:20:42 +0100
Message-ID: <a1ea1b82-db23-f591-0b13-8cf1c2faf06b@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 20:03:24 +0100

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/id_table.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/id_table.c b/drivers/infiniband/hw/cxgb4/id_table.c
index 0161ae6ad629..51a0b7244e35 100644
--- a/drivers/infiniband/hw/cxgb4/id_table.c
+++ b/drivers/infiniband/hw/cxgb4/id_table.c
@@ -93,8 +93,9 @@ int c4iw_id_table_alloc(struct c4iw_id_table *alloc, u32 start, u32 num,
 		alloc->last = 0;
 	alloc->max  = num;
 	spin_lock_init(&alloc->lock);
-	alloc->table = kmalloc(BITS_TO_LONGS(num) * sizeof(long),
-				GFP_KERNEL);
+	alloc->table = kmalloc_array(BITS_TO_LONGS(num),
+				     sizeof(*alloc->table),
+				     GFP_KERNEL);
 	if (!alloc->table)
 		return -ENOMEM;
 
-- 
2.11.1
