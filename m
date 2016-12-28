From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] IB/srpt: allocate ib_qp_attr on the stack
Date: Wed, 28 Dec 2016 13:00:12 +0200
Message-ID: <1482922813-8392-3-git-send-email-maxg@mellanox.com>
References: <1482922813-8392-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482922813-8392-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No reason to allocate it dynamically.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0b1f69e..aa18d74 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -984,24 +984,20 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
  */
 static int srpt_init_ch_qp(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 {
-	struct ib_qp_attr *attr;
+	struct ib_qp_attr attr;
 	int ret;
 
-	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	attr->qp_state = IB_QPS_INIT;
-	attr->qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
+	memset(&attr, 0, sizeof(attr));
+	attr.qp_state = IB_QPS_INIT;
+	attr.qp_access_flags = IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
 	    IB_ACCESS_REMOTE_WRITE;
-	attr->port_num = ch->sport->port;
-	attr->pkey_index = 0;
+	attr.port_num = ch->sport->port;
+	attr.pkey_index = 0;
 
-	ret = ib_modify_qp(qp, attr,
+	ret = ib_modify_qp(qp, &attr,
 			   IB_QP_STATE | IB_QP_ACCESS_FLAGS | IB_QP_PORT |
 			   IB_QP_PKEY_INDEX);
 
-	kfree(attr);
 	return ret;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
