From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 2/3] ib_srpt: Spelling fixes
Date: Fri, 11 Nov 2011 12:16:31 +0100
Message-ID: <201111111216.31667.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix spelling in one error message and in several source code comments.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   10 +++++-----
 drivers/infiniband/ulp/srpt/ib_srpt.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7699b49..b93e1a0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -298,7 +298,7 @@ static void srpt_get_iou(struct ib_dm_mad *mad)
 }
 
 /**
- * srpt_get_ioc() - Write IOControllerprofile to a management datagram.
+ * srpt_get_ioc() - Write IOControllerProfile to a management datagram.
  *
  * See also section 16.3.3.4 IOControllerProfile in the InfiniBand
  * Architecture Specification. See also section B.7, table B.7 in the SRP
@@ -1162,7 +1162,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	dma_len = sg_dma_len(&sg[0]);
 	dma_addr = sg_dma_address(&sg[0]);
 
-	/* this second loop is really mapped sg_addres to rdma_iu->ib_sge */
+	/* this second loop is really mapped sg_address to rdma_iu->ib_sge */
 	for (i = 0, j = 0;
 	     j < count && i < ioctx->n_rbuf && tsize > 0; ++i, ++riu, ++db) {
 		rsize = be32_to_cpu(db->len);
@@ -2566,7 +2566,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 	/*
-	 * Use the initator port identifier as the session name.
+	 * Use the initiator port identifier as the session name.
 	 */
 	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
@@ -3170,7 +3170,7 @@ static struct srpt_port *srpt_lookup_port(const char *name)
 }
 
 /**
- * srpt_add_one() - Infiniband device addition callback function.
+ * srpt_add_one() - InfiniBand device addition callback function.
  */
 static void srpt_add_one(struct ib_device *device)
 {
@@ -3440,7 +3440,7 @@ static struct se_node_acl *srpt_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct srpt_node_acl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to alocate struct srpt_node_acl\n");
+		printk(KERN_ERR "Unable to allocate struct srpt_node_acl\n");
 		return NULL;
 	}
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index a484941..1269153 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -330,7 +330,7 @@ struct srpt_rdma_ch {
 };
 
 /**
- * struct srpt_port_attib - Attributes for SRPT port
+ * struct srpt_port_attrib - Attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
  * @srp_max_rsp_size: Maximum size of SRP response messages in bytes.
  * @srp_sq_size: Shared receive queue (SRQ) size.
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
