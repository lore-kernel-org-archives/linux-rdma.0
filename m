From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm 4/8] acm.c: Fix endian of transaction ID
Date: Tue, 06 Aug 2013 07:45:28 -0400
Message-ID: <5200E1D8.1090005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


It should be in network rather than host endian.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 7de5873..d68746b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -839,7 +839,7 @@ static void acm_init_path_query(struct ib_sa_mad *mad)
 	mad->mgmt_class = IB_MGMT_CLASS_SA;
 	mad->class_version = 2;
 	mad->method = IB_METHOD_GET;
-	mad->tid = (uint64_t) atomic_inc(&tid);
+	mad->tid = htonll((uint64_t) atomic_inc(&tid));
 	mad->attr_id = IB_SA_ATTR_PATH_REC;
 }
 
@@ -1483,7 +1483,7 @@ static void acm_init_join(struct ib_sa_mad *mad, union ibv_gid *port_gid,
 	mad->mgmt_class = IB_MGMT_CLASS_SA;
 	mad->class_version = 2;
 	mad->method = IB_METHOD_SET;
-	mad->tid = (uint64_t) atomic_inc(&tid);
+	mad->tid = htonll((uint64_t) atomic_inc(&tid));
 	mad->attr_id = IB_SA_ATTR_MC_MEMBER_REC;
 	mad->comp_mask =
 		IB_COMP_MASK_MC_MGID | IB_COMP_MASK_MC_PORT_GID |
@@ -1953,7 +1953,7 @@ acm_send_resolve(struct acm_ep *ep, struct acm_dest *dest,
 	mad->class_version = 1;
 	mad->method = IB_METHOD_GET;
 	mad->control = ACM_CTRL_RESOLVE;
-	mad->tid = (uint64_t) atomic_inc(&tid);
+	mad->tid = htonll((uint64_t) atomic_inc(&tid));
 
 	rec = (struct acm_resolve_rec *) mad->data;
 	rec->src_type = (uint8_t) saddr->type;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
