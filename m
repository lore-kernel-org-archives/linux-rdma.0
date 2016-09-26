From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/core: Improve ib_map_mr_sg() documentation
Date: Mon, 26 Sep 2016 09:09:42 -0700
Message-ID: <b75ad680-88e5-e725-80cd-9a0b41bbb2ec@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Document that ib_map_mr_sg() is able to map physically discontiguous
sg-lists as a single MR. Change IB_MR_TYPE_SG_GAPS_REG into
IB_MR_TYPE_SG_GAPS.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f2b776efab3a..ff75be35cf28 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1812,13 +1812,13 @@ EXPORT_SYMBOL(ib_set_vf_guid);
  *
  * Constraints:
  * - The first sg element is allowed to have an offset.
- * - Each sg element must be aligned to page_size (or physically
- *   contiguous to the previous element). In case an sg element has a
- *   non contiguous offset, the mapping prefix will not include it.
+ * - Each sg element must either be aligned to page_size or virtually
+ *   contiguous to the previous element. In case an sg element has a
+ *   non-contiguous offset, the mapping prefix will not include it.
  * - The last sg element is allowed to have length less than page_size.
  * - If sg_nents total byte length exceeds the mr max_num_sge * page_size
  *   then only max_num_sg entries will be mapped.
- * - If the MR was allocated with type IB_MR_TYPE_SG_GAPS_REG, non of these
+ * - If the MR was allocated with type IB_MR_TYPE_SG_GAPS, none of these
  *   constraints holds and the page_size argument is ignored.
  *
  * Returns the number of sg elements that were mapped to the memory region.
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
