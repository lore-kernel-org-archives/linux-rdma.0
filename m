From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 12/33] RDMA/netlink: Rename netlink callback struct
Date: Thu, 10 Aug 2017 14:08:06 +0300
Message-ID: <20170810110827.9952-13-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The RDMA netlink client infrastructure was removed and made obsolete.
The old infrastructure defined struct ibnl_client_cbs. Now that all
uses of this have been updated to the new infrastructure, rename the
struct to be compliant with the current stack naming standards:
struct rdma_nl_cbs.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c     | 2 +-
 drivers/infiniband/core/device.c  | 2 +-
 drivers/infiniband/core/iwcm.c    | 2 +-
 drivers/infiniband/core/netlink.c | 4 ++--
 include/rdma/rdma_netlink.h       | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0c85f140e616..d8edd8b11561 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4458,7 +4458,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static const struct ibnl_client_cbs cma_cb_table[] = {
+static const struct rdma_nl_cbs cma_cb_table[] = {
 	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats},
 };
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7ae29cc49a5e..33a39518848c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1086,7 +1086,7 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev,
 }
 EXPORT_SYMBOL(ib_get_net_dev_by_params);
 
-static const struct ibnl_client_cbs ibnl_ls_cb_table[] = {
+static const struct rdma_nl_cbs ibnl_ls_cb_table[] = {
 	[RDMA_NL_LS_OP_RESOLVE] = {
 		.dump = ib_nl_handle_resolve_resp,
 		.flags = RDMA_NL_ADMIN_PERM,
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 8599271d8be6..452a3115e3e6 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -80,7 +80,7 @@ const char *__attribute_const__ iwcm_reject_msg(int reason)
 }
 EXPORT_SYMBOL(iwcm_reject_msg);
 
-static struct ibnl_client_cbs iwcm_nl_cb_table[] = {
+static struct rdma_nl_cbs iwcm_nl_cb_table[] = {
 	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
 	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
 	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = iwpm_add_and_query_mapping_cb},
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 514959ccaf2d..a7082adae16b 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -44,7 +44,7 @@
 static DEFINE_MUTEX(rdma_nl_mutex);
 static struct sock *nls;
 static struct {
-	const struct ibnl_client_cbs   *cb_table;
+	const struct rdma_nl_cbs   *cb_table;
 } rdma_nl_types[RDMA_NL_NUM_CLIENTS];
 
 int rdma_nl_chk_listeners(unsigned int group)
@@ -84,7 +84,7 @@ static bool is_nl_valid(unsigned int type, unsigned int op)
 }
 
 void rdma_nl_register(unsigned int index,
-		      const struct ibnl_client_cbs cb_table[])
+		      const struct rdma_nl_cbs cb_table[])
 {
 	mutex_lock(&rdma_nl_mutex);
 	if (!is_nl_msg_valid(index, 0)) {
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 348e0bbe0fc9..92f8832297ab 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -5,7 +5,7 @@
 #include <linux/netlink.h>
 #include <uapi/rdma/rdma_netlink.h>
 
-struct ibnl_client_cbs {
+struct rdma_nl_cbs {
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *nlcb);
 	u8 flags;
 };
@@ -21,7 +21,7 @@ enum rdma_nl_flags {
  * @cb_table: A table for op->callback
  */
 void rdma_nl_register(unsigned int index,
-		      const struct ibnl_client_cbs cb_table[]);
+		      const struct rdma_nl_cbs cb_table[]);
 
 /**
  * Remove a client from IB netlink.
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
