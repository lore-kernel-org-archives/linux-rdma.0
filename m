From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 03/16] ib/mad: Add check for jumbo MADs support on a device
Date: Thu, 13 Nov 2014 14:54:12 -0500
Message-ID: <1415908465-24392-4-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Check for IB_DEVICE_JUMBO_MAD_SUPPORT in the device capabilities and if
supported mark the special QPs created.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 26 +++++++++++++++++++++++---
 drivers/infiniband/core/mad_priv.h |  1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 4673262..9f5641d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2855,7 +2855,8 @@ static void init_mad_queue(struct ib_mad_qp_info *qp_info,
 }
 
 static void init_mad_qp(struct ib_mad_port_private *port_priv,
-			struct ib_mad_qp_info *qp_info)
+			struct ib_mad_qp_info *qp_info,
+			int supports_jumbo_mads)
 {
 	qp_info->port_priv = port_priv;
 	init_mad_queue(qp_info, &qp_info->send_queue);
@@ -2865,6 +2866,7 @@ static void init_mad_qp(struct ib_mad_port_private *port_priv,
 	qp_info->snoop_table = NULL;
 	qp_info->snoop_table_size = 0;
 	atomic_set(&qp_info->snoop_count, 0);
+	qp_info->supports_jumbo_mads = supports_jumbo_mads;
 }
 
 static int create_mad_qp(struct ib_mad_qp_info *qp_info,
@@ -2911,6 +2913,17 @@ static void destroy_mad_qp(struct ib_mad_qp_info *qp_info)
 	kfree(qp_info->snoop_table);
 }
 
+static int
+mad_device_supports_jumbo_mads(struct ib_device *device)
+{
+	struct ib_device_attr attr;
+
+	if (!ib_query_device(device, &attr))
+		return (attr.device_cap_flags
+			& IB_DEVICE_JUMBO_MAD_SUPPORT);
+	return 0;
+}
+
 /*
  * Open the port
  * Create the QP, PD, MR, and CQ if needed
@@ -2923,6 +2936,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
 	int has_smi;
+	int supports_jumbo_mads;
 
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
@@ -2935,8 +2949,14 @@ static int ib_mad_port_open(struct ib_device *device,
 	port_priv->port_num = port_num;
 	spin_lock_init(&port_priv->reg_lock);
 	INIT_LIST_HEAD(&port_priv->agent_list);
-	init_mad_qp(port_priv, &port_priv->qp_info[0]);
-	init_mad_qp(port_priv, &port_priv->qp_info[1]);
+
+	supports_jumbo_mads = mad_device_supports_jumbo_mads(device);
+	if (supports_jumbo_mads)
+		pr_info("Jumbo MAD support enabled for %s:%d\n",
+				device->name, port_num);
+
+	init_mad_qp(port_priv, &port_priv->qp_info[0], supports_jumbo_mads);
+	init_mad_qp(port_priv, &port_priv->qp_info[1], supports_jumbo_mads);
 
 	cq_size = mad_sendq_size + mad_recvq_size;
 	has_smi = rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_INFINIBAND;
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index d1a0b0e..4b4110d 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -192,6 +192,7 @@ struct ib_mad_qp_info {
 	struct ib_mad_snoop_private **snoop_table;
 	int snoop_table_size;
 	atomic_t snoop_count;
+	int supports_jumbo_mads;
 };
 
 struct ib_mad_port_private {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
