From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] infiniband: add checks for the status of nla_put
Date: Tue, 25 Dec 2018 20:11:39 -0600
Message-ID: <20181226021141.71538-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>, Alex Estrin <alex.estrin@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The fix inserts multiple checks for nla_put, and issues warnings if it
fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/infiniband/core/sa_query.c | 39 ++++++++++++++++++------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index be5ba5e15496..0e5d7a6dde36 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -775,28 +775,37 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
 	/* Now build the attributes */
 	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
 		val64 = be64_to_cpu(sa_rec->service_id);
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
-			sizeof(val64), &val64);
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
+			sizeof(val64), &val64))
+			pr_warn("nla_put failed\n");
+	}
+	if (comp_mask & IB_SA_PATH_REC_DGID) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
+			sizeof(sa_rec->dgid), &sa_rec->dgid))
+			pr_warn("nla_put failed\n");
+	}
+	if (comp_mask & IB_SA_PATH_REC_SGID) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
+			sizeof(sa_rec->sgid), &sa_rec->sgid))
+			pr_warn("nla_put failed\n");
+	}
+	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
+			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class))
+			pr_warn("nla_put failed\n");
 	}
-	if (comp_mask & IB_SA_PATH_REC_DGID)
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
-			sizeof(sa_rec->dgid), &sa_rec->dgid);
-	if (comp_mask & IB_SA_PATH_REC_SGID)
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
-			sizeof(sa_rec->sgid), &sa_rec->sgid);
-	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
-			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class);
 
 	if (comp_mask & IB_SA_PATH_REC_PKEY) {
 		val16 = be16_to_cpu(sa_rec->pkey);
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
-			sizeof(val16), &val16);
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
+			sizeof(val16), &val16))
+			pr_warn("nla_put failed\n");
 	}
 	if (comp_mask & IB_SA_PATH_REC_QOS_CLASS) {
 		val16 = be16_to_cpu(sa_rec->qos_class);
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
-			sizeof(val16), &val16);
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
+			sizeof(val16), &val16))
+			pr_warn("nla_put failed\n");
 	}
 }
 
-- 
2.17.2 (Apple Git-113)
