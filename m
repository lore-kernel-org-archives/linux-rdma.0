From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/9] ib_{uverbs/core}: add new ib_create_qp_ex with udata arg
Date: Fri,  2 Sep 2016 02:09:27 +0200
Message-ID: <1472774969-18997-8-git-send-email-knut.omang@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472774969-18997-1-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Necessary to get device specific arguments through to XRC QPs.
Added new local header file to serve as support interface
between ib_core and ib_uverbs.

Right now there is a lot of duplicate setup code in uverbs_cmd.c
on the ib_uverbs side and verbs.c on the ib_core side. This commit
is a quick fix to have XRC support working, but similar calls
can be added to consolidate the code for other parts of the API.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h  |  3 +++
 drivers/infiniband/core/uverbs_cmd.c |  2 +-
 drivers/infiniband/core/verbs.c      | 13 +++++++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..0819006 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -152,5 +152,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 			     struct netlink_callback *cb);
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 			     struct netlink_callback *cb);
+struct ib_qp *ib_create_qp_ex(struct ib_pd *pd,
+			struct ib_qp_init_attr *qp_init_attr,
+			struct ib_udata *udata);
 
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 35d18e0..4323093 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1905,7 +1905,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		}
 
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
-		qp = ib_create_qp(pd, &attr);
+		qp = ib_create_qp_ex(pd, &attr, uhw);
 	else
 		qp = device->create_qp(pd, &attr, uhw);
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6efe23d..8f71b00 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -751,8 +751,9 @@ static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
 	return qp;
 }
 
-struct ib_qp *ib_create_qp(struct ib_pd *pd,
-			   struct ib_qp_init_attr *qp_init_attr)
+struct ib_qp *ib_create_qp_ex(struct ib_pd *pd,
+			struct ib_qp_init_attr *qp_init_attr,
+			struct ib_udata *udata)
 {
 	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
 	struct ib_qp *qp;
@@ -836,6 +837,14 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 
 	return qp;
 }
+EXPORT_SYMBOL(ib_create_qp_ex);
+
+
+struct ib_qp *ib_create_qp(struct ib_pd *pd,
+			   struct ib_qp_init_attr *qp_init_attr)
+{
+	return ib_create_qp_ex(pd, qp_init_attr,NULL);
+}
 EXPORT_SYMBOL(ib_create_qp);
 
 static const struct {
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
