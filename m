From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/17] rdma/ucm: Allow user to specify qp type when creating
 id
Date: Wed, 15 Jun 2011 06:28:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021040@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the user to indicate the QP type separate from the
port space when allocating an rdma_cm_id.  With RDMA_PS_IB,
there is no longer a 1:1 relationship between the QP type and
port space, so we need to switch on the QP type to select
between UD and connected QPs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c |    5 ++++-
 include/rdma/rdma_user_cm.h    |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index b6c2373..bd4c136 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -276,7 +276,7 @@ static int ucma_event_handler(struct rdma_cm_id *cm_id,
 	ucma_set_event_context(ctx, event, uevent);
 	uevent->resp.event = event->event;
 	uevent->resp.status = event->status;
-	if (cm_id->ps == RDMA_PS_UDP || cm_id->ps == RDMA_PS_IPOIB)
+	if (cm_id->qp_type == IB_QPT_UD)
 		ucma_copy_ud_event(&uevent->resp.param.ud, &event->param.ud);
 	else
 		ucma_copy_conn_event(&uevent->resp.param.conn,
@@ -377,6 +377,9 @@ static int ucma_get_qp_type(struct rdma_ucm_create_id *cmd, enum ib_qp_type *qp_
 	case RDMA_PS_IPOIB:
 		*qp_type = IB_QPT_UD;
 		return 0;
+	case RDMA_PS_IB:
+		*qp_type = cmd->qp_type;
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index 1d16502..d88c23c 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -77,7 +77,8 @@ struct rdma_ucm_create_id {
 	__u64 uid;
 	__u64 response;
 	__u16 ps;
-	__u8  reserved[6];
+	__u8  qp_type;
+	__u8  reserved[5];
 };
 
 struct rdma_ucm_create_id_resp {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
