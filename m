From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/8] IB/hfi1: Stricter bounds checking of MAD trap
 index
Date: Sun, 13 Aug 2017 08:08:46 -0700
Message-ID: <20170813150845.23208.61782.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamenee Arumugame <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The macro size is valid. This change makes it less ambiguous.
Bounds check trap type for better security.

Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   13 ++++++++++++-
 include/rdma/rdma_vt.h           |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 1be1d74..ba6f58e 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -151,13 +151,24 @@ static void cleanup_traps(struct hfi1_ibport *ibp, struct trap_node *trap)
 	unsigned long flags;
 	unsigned long timeout;
 	int found = 0;
+	unsigned int queue_id;
+	static int trap_count;
+
+	queue_id = trap->data.generic_type & 0x0F;
+	if (queue_id >= RVT_MAX_TRAP_LISTS) {
+		trap_count++;
+		pr_err_ratelimited("hfi1: Invalid trap 0x%0x dropped. Total dropped: %d\n",
+				  trap->data.generic_type, trap_count);
+		kfree(trap);
+		return NULL;
+	}
 
 	/*
 	 * Since the retry (handle timeout) does not remove a trap request
 	 * from the list, all we have to do is compare the node.
 	 */
 	spin_lock_irqsave(&ibp->rvp.lock, flags);
-	trap_list = &ibp->rvp.trap_lists[trap->data.generic_type & 0x0F];
+	trap_list = &ibp->rvp.trap_lists[queue_id];
 
 	list_for_each_entry(node, &trap_list->list, list) {
 		if (node == trap) {
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 1d94f3c..1ba84a7 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -64,7 +64,7 @@
 #define RVT_MAX_PKEY_VALUES 16
 
 #define RVT_MAX_TRAP_LEN 100 /* Limit pending trap list */
-#define RVT_MAX_TRAP_LISTS ((IB_NOTICE_TYPE_INFO & 0x0F) + 1)
+#define RVT_MAX_TRAP_LISTS 5 /*((IB_NOTICE_TYPE_INFO & 0x0F) + 1)*/
 #define RVT_TRAP_TIMEOUT 4096 /* 4.096 usec */
 
 struct trap_list {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
