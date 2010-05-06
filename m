From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 5/7] RDMA/cxgb4: clean up a few printks.
Date: Thu, 06 May 2010 18:06:41 -0500
Message-ID: <20100506230641.25362.90934.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c |    2 +-
 drivers/infiniband/hw/cxgb4/ev.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d146639..30ce0a8 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2033,7 +2033,7 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	 */
 	ep->stid = cxgb4_alloc_stid(dev->rdev.lldi.tids, PF_INET, ep);
 	if (ep->stid == -1) {
-		printk(KERN_ERR MOD "%s - cannot alloc atid.\n", __func__);
+		printk(KERN_ERR MOD "%s - cannot alloc stid.\n", __func__);
 		err = -ENOMEM;
 		goto fail2;
 	}
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index ca05b5b..491e76a 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -51,8 +51,8 @@ static void post_qp_event(struct c4iw_dev *dev, struct c4iw_cq *chp,
 		return;
 	}
 
-	printk(KERN_ERR "%s - AE qpid 0x%x opcode %d status 0x%x "
-	       "type %d wrid.hi 0x%x wrid.lo 0x%x\n", __func__,
+	printk(KERN_ERR MOD "AE qpid 0x%x opcode %d status 0x%x "
+	       "type %d wrid.hi 0x%x wrid.lo 0x%x\n",
 	       CQE_QPID(err_cqe), CQE_OPCODE(err_cqe),
 	       CQE_STATUS(err_cqe), CQE_TYPE(err_cqe),
 	       CQE_WRID_HI(err_cqe), CQE_WRID_LOW(err_cqe));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
