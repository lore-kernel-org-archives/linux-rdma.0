From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 3/5] IB/core: Fix a potential array overrun in CMA and SA agent
Date: Fri,  6 May 2016 22:45:26 +0300
Message-ID: <1462563928-29164-4-git-send-email-leon@kernel.org>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462563928-29164-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix array overrun when going over callback table.
In declaration of callback table, the max size isn't provided and
in registration phase, it is provided.

There is potential scenario where a new operation is added
and it is not supported by current client. The acceptance of
such operation by ib_netlink will cause to array overrun.

Fixes: 809d5fc9bf65 ("infiniband: pass rdma_cm module to netlink_dump_start")
Fixes: b493d91d333e ("iwcm: common code for port mapper")
Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c      | 3 ++-
 drivers/infiniband/core/iwcm.c     | 2 +-
 drivers/infiniband/core/sa_query.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 93ab0ae..b575bd5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4294,7 +4294,8 @@ static int __init cma_init(void)
 	if (ret)
 		goto err;
 
-	if (ibnl_add_client(RDMA_NL_RDMA_CM, RDMA_NL_RDMA_CM_NUM_OPS, cma_cb_table))
+	if (ibnl_add_client(RDMA_NL_RDMA_CM, ARRAY_SIZE(cma_cb_table),
+			    cma_cb_table))
 		pr_warn("RDMA CMA: failed to add netlink callback\n");
 	cma_configfs_init();
 
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index e28a160..51079e3 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1175,7 +1175,7 @@ static int __init iw_cm_init(void)
 	if (ret)
 		pr_err("iw_cm: couldn't init iwpm\n");
 
-	ret = ibnl_add_client(RDMA_NL_IWCM, RDMA_NL_IWPM_NUM_OPS,
+	ret = ibnl_add_client(RDMA_NL_IWCM, ARRAY_SIZE(iwcm_nl_cb_table),
 			      iwcm_nl_cb_table);
 	if (ret)
 		pr_err("iw_cm: couldn't register netlink callbacks\n");
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8a09c0f..1e7c652 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1820,7 +1820,7 @@ static int __init ib_sa_init(void)
 		goto err3;
 	}
 
-	if (ibnl_add_client(RDMA_NL_LS, RDMA_NL_LS_NUM_OPS,
+	if (ibnl_add_client(RDMA_NL_LS, ARRAY_SIZE(ib_sa_cb_table),
 			    ib_sa_cb_table)) {
 		pr_err("Failed to add netlink callback\n");
 		ret = -EINVAL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
