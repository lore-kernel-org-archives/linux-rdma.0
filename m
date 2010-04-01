From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/26] rdma/ucm: add support for RDMA_PS_IB when creating an ID
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <B2764842B58C432384BCF32526E85ECE@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to support RDMA_PS_IB, we need to know the qp type
to associated with the rdma cm id.  Receive the qp type from
user space using currently reserved fields.  Previous kernels
do not support RDMA_PS_IB, so we only read out the qp type
data if PS_IB has been selected.  This avoids issues reading
uninitialized data from existing applications.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |    3 +++
 include/rdma/rdma_user_cm.h    |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 9feb18b..7a59039 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -359,6 +359,9 @@ static int ucma_get_qp_type(struct rdma_ucm_create_id *cmd, enum ib_qp_type *qp_
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
