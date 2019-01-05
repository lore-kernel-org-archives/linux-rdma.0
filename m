From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] [v2]RDMA: add checks for the status of nla_put in ib_nl_send_msg
Date: Sat,  5 Jan 2019 11:09:26 -0600
Message-ID: <20190105170928.4086-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Gal Pressman <galpress@amazon.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The fix inserts multiple checks for nla_put, and changes the return type of
ib_nl_set_path_rec_attrs() from void to int

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/infiniband/core/sa_query.c | 56 ++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 97e6d7b69abf..5d81158381d5 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -747,8 +747,9 @@ static inline int ib_sa_query_cancelled(struct ib_sa_query *query)
 	return (query->flags & IB_SA_CANCEL);
 }
 
-static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
-				     struct ib_sa_query *query)
+static int ib_nl_set_path_rec_attrs(struct sk_buff *skb,
+				     struct ib_sa_query *query,
+				     struct nlmsghdr *nlh)
 {
 	struct sa_path_rec *sa_rec = query->mad_buf->context[1];
 	struct ib_sa_mad *mad = query->mad_buf->mad;
@@ -775,29 +776,45 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
 	/* Now build the attributes */
 	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
 		val64 = be64_to_cpu(sa_rec->service_id);
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
-			sizeof(val64), &val64);
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
+				sizeof(val64), &val64))
+			goto nla_put_failure;
+	}
+	if (comp_mask & IB_SA_PATH_REC_DGID) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
+				sizeof(sa_rec->dgid), &sa_rec->dgid))
+			goto nla_put_failure;
+	}
+	if (comp_mask & IB_SA_PATH_REC_SGID) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
+				sizeof(sa_rec->sgid), &sa_rec->sgid))
+			goto nla_put_failure;
+	}
+	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS) {
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
+				sizeof(sa_rec->traffic_class),
+				&sa_rec->traffic_class))
+			goto nla_put_failure;
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
+				sizeof(val16), &val16))
+			goto nla_put_failure;
 	}
+
 	if (comp_mask & IB_SA_PATH_REC_QOS_CLASS) {
 		val16 = be16_to_cpu(sa_rec->qos_class);
-		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
-			sizeof(val16), &val16);
+		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
+				sizeof(val16), &val16))
+			goto nla_put_failure;
 	}
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
 }
 
 static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
@@ -856,7 +873,10 @@ static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
 	}
 
 	/* Add attributes */
-	ib_nl_set_path_rec_attrs(skb, query);
+	if (ib_nl_set_path_rec_attrs(skb, query, nlh)) {
+		nlmsg_free(skb);
+		return -EMSGSIZE;
+	}
 
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
-- 
2.17.1
