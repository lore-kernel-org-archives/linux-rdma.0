From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] IB/core: Fix a potential array overrun in CMA and SA agent
Date: Wed,  4 May 2016 08:36:04 +0300
Message-ID: <1462340165-16067-4-git-send-email-leon@kernel.org>
References: <1462340165-16067-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462340165-16067-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c      | 2 +-
 drivers/infiniband/core/iwcm.c     | 2 +-
 drivers/infiniband/core/sa_query.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 93ab0ae..09a0243 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4240,7 +4240,7 @@ out:
 	return skb->len;
 }
 
-static const struct ibnl_client_cbs cma_cb_table[] = {
+static const struct ibnl_client_cbs cma_cb_table[RDMA_NL_RDMA_CM_NUM_OPS] = {
 	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats,
 				       .module = THIS_MODULE },
 };
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index e28a160..5011ecf 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -59,7 +59,7 @@ MODULE_AUTHOR("Tom Tucker");
 MODULE_DESCRIPTION("iWARP CM");
 MODULE_LICENSE("Dual BSD/GPL");
 
-static struct ibnl_client_cbs iwcm_nl_cb_table[] = {
+static struct ibnl_client_cbs iwcm_nl_cb_table[RDMA_NL_IWPM_NUM_OPS] = {
 	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
 	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
 	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 8a09c0f..24c2aac 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -838,7 +838,7 @@ resp_out:
 	return skb->len;
 }
 
-static struct ibnl_client_cbs ib_sa_cb_table[] = {
+static struct ibnl_client_cbs ib_sa_cb_table[RDMA_NL_LS_NUM_OPS] = {
 	[RDMA_NL_LS_OP_RESOLVE] = {
 		.dump = ib_nl_handle_resolve_resp,
 		.module = THIS_MODULE },
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
