From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
Subject: [PATCH] RDMA/cma: Make CM response timeout and # CM retries configurable
Date: Sun, 17 Feb 2019 18:09:09 +0100
Message-ID: <20190217170909.1178575-1-haakon.bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

During certain workloads, the default CM response timeout is too
short, leading to excessive retries. Hence, make it configurable
through sysctl. While at it, also make number of CM retries
configurable.

The defaults are not changed.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/infiniband/core/cma.c | 51 ++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index c43512752b8a..ce99e1cd1029 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -43,6 +43,7 @@
 #include <linux/inetdevice.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 #include <net/route.h>
 
 #include <net/net_namespace.h>
@@ -68,13 +69,46 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define CMA_CM_RESPONSE_TIMEOUT 20
 #define CMA_QUERY_CLASSPORT_INFO_TIMEOUT 3000
-#define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
 #define CMA_PREFERRED_ROCE_GID_TYPE IB_GID_TYPE_ROCE_UDP_ENCAP
 
+#define CMA_DFLT_CM_RESPONSE_TIMEOUT 20
+static int cma_cm_response_timeout = CMA_DFLT_CM_RESPONSE_TIMEOUT;
+static int cma_cm_response_timeout_min = 8;
+static int cma_cm_response_timeout_max = 31;
+#undef CMA_DFLT_CM_RESPONSE_TIMEOUT
+
+#define CMA_DFLT_MAX_CM_RETRIES 15
+static int cma_max_cm_retries = CMA_DFLT_MAX_CM_RETRIES;
+static int cma_max_cm_retries_min = 1;
+static int cma_max_cm_retries_max = 100;
+#undef CMA_DFLT_MAX_CM_RETRIES
+
+static struct ctl_table_header *cma_ctl_table_hdr;
+static struct ctl_table cma_ctl_table[] = {
+	{
+		.procname	= "cma_cm_response_timeout",
+		.data		= &cma_cm_response_timeout,
+		.maxlen		= sizeof(cma_cm_response_timeout),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &cma_cm_response_timeout_min,
+		.extra2		= &cma_cm_response_timeout_max,
+	},
+	{
+		.procname	= "cma_max_cm_retries",
+		.data		= &cma_max_cm_retries,
+		.maxlen		= sizeof(cma_max_cm_retries),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &cma_max_cm_retries_min,
+		.extra2		= &cma_max_cm_retries_max,
+	},
+	{ }
+};
+
 static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_ADDR_RESOLVED]	 = "address resolved",
 	[RDMA_CM_EVENT_ADDR_ERROR]	 = "address error",
@@ -3745,8 +3779,8 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	req.path = id_priv->id.route.path_rec;
 	req.sgid_attr = id_priv->id.route.addr.dev_addr.sgid_attr;
 	req.service_id = rdma_get_service_id(&id_priv->id, cma_dst_addr(id_priv));
-	req.timeout_ms = 1 << (CMA_CM_RESPONSE_TIMEOUT - 8);
-	req.max_cm_retries = CMA_MAX_CM_RETRIES;
+	req.timeout_ms = 1 << (cma_cm_response_timeout - 8);
+	req.max_cm_retries = cma_max_cm_retries;
 
 	ret = ib_send_cm_sidr_req(id_priv->cm_id.ib, &req);
 	if (ret) {
@@ -3816,9 +3850,9 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.flow_control = conn_param->flow_control;
 	req.retry_count = min_t(u8, 7, conn_param->retry_count);
 	req.rnr_retry_count = min_t(u8, 7, conn_param->rnr_retry_count);
-	req.remote_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
-	req.local_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
-	req.max_cm_retries = CMA_MAX_CM_RETRIES;
+	req.remote_cm_response_timeout = cma_cm_response_timeout;
+	req.local_cm_response_timeout = cma_cm_response_timeout;
+	req.max_cm_retries = cma_max_cm_retries;
 	req.srq = id_priv->srq ? 1 : 0;
 
 	ret = ib_send_cm_req(id_priv->cm_id.ib, &req);
@@ -4701,6 +4735,9 @@ static int __init cma_init(void)
 		goto err;
 
 	cma_configfs_init();
+	cma_ctl_table_hdr = register_net_sysctl(&init_net, "net/rdma_cm", cma_ctl_table);
+	if (!cma_ctl_table_hdr)
+		pr_warn("rdma_cm: couldn't register sysctl path, using default values\n");
 
 	return 0;
 
-- 
2.20.1
