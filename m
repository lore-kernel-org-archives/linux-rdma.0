From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/6] IB/uverbs: Enable QP creation which is associated to underlay QP
Date: Mon,  5 Jun 2017 08:00:17 +0300
Message-ID: <20170605050021.12236-3-leon@kernel.org>
References: <20170605050021.12236-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605050021.12236-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable QP creation which is associated to underlay QP. This comes as a
pre-patch for downstream patches in this series to enable flow steering
from user space application on the underlay IPoIB QP.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 11 ++++++++---
 include/uapi/rdma/ib_user_verbs.h    |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb156414..d819aa01da5e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1385,8 +1385,9 @@ static int create_qp(struct ib_uverbs_file *file,
 		attr.rwq_ind_tbl = ind_tbl;
 	}

-	if ((cmd_sz >= offsetof(typeof(*cmd), reserved1) +
-		       sizeof(cmd->reserved1)) && cmd->reserved1) {
+	if (cmd_sz > sizeof(*cmd) &&
+	    !ib_is_udata_cleared(ucore, sizeof(*cmd),
+				 cmd_sz - sizeof(*cmd))) {
 		ret = -EOPNOTSUPP;
 		goto err_put;
 	}
@@ -1484,11 +1485,15 @@ static int create_qp(struct ib_uverbs_file *file,
 				IB_QP_CREATE_MANAGED_SEND |
 				IB_QP_CREATE_MANAGED_RECV |
 				IB_QP_CREATE_SCATTER_FCS |
-				IB_QP_CREATE_CVLAN_STRIPPING)) {
+				IB_QP_CREATE_CVLAN_STRIPPING |
+				IB_QP_CREATE_ASSOC_QPN)) {
 		ret = -EINVAL;
 		goto err_put;
 	}

+	if (attr.create_flags & IB_QP_CREATE_ASSOC_QPN)
+		attr.associated_qpn = cmd->associated_qpn;
+
 	buf = (void *)cmd + sizeof(*cmd);
 	if (cmd_sz > sizeof(*cmd))
 		if (!(buf[0] == 0 && !memcmp(buf, buf + 1,
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 270c350bedc6..f882ed62de72 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
 	__u32 comp_mask;
 	__u32 create_flags;
 	__u32 rwq_ind_tbl_handle;
-	__u32  reserved1;
+	__u32  associated_qpn;
 };

 struct ib_uverbs_open_qp {
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
