From: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 05 Oct 2010 18:07:37 +0200
Message-ID: <4CAB4D49.9090107@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When using slow SM allow more packets to be buffered before answer
comming back. This patch based on idea of Christoph Lameter.

http://lists.openfabrics.org/pipermail/general/2009-June/059853.html

Signed-off-by: Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   91 +++++++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
 3 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..159e29c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -698,6 +698,8 @@ static inline void ipoib_unregister_debugfs(void) { }
 
 extern int ipoib_sendq_size;
 extern int ipoib_recvq_size;
+extern unsigned int ipoib_prec_qlen;
+extern unsigned int ipoib_mcast_qlen;
 
 extern struct ib_sa_client ipoib_sa_client;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b4b2257..7101e0d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -69,6 +69,85 @@ module_param(lro_max_aggr, int, 0644);
 MODULE_PARM_DESC(lro_max_aggr, "LRO: Max packets to be aggregated "
 		"(default = 64)");
 
+unsigned int ipoib_prec_qlen = IPOIB_MAX_PATH_REC_QUEUE;
+unsigned int ipoib_mcast_qlen = IPOIB_MAX_MCAST_QUEUE;
+
+static struct ctl_table_header *ipoib_table_header;
+
+#define MIN_IPOIB_QLENGTH 1
+#define MAX_IPOIB_QLENGTH 256
+
+static unsigned int min_ipoib_qlen  = MIN_IPOIB_QLENGTH;
+static unsigned int max_ipoib_qlen  = MAX_IPOIB_QLENGTH;
+
+static ctl_table ipoib_tunable_table[] = {
+		{
+				.procname		= "prec_qlen",
+				.data			= &ipoib_prec_qlen,
+				.maxlen			= sizeof(unsigned int),
+				.mode			= 0644,
+				.proc_handler	= proc_dointvec_minmax,
+				.extra1			= &min_ipoib_qlen,
+				.extra2			= &max_ipoib_qlen
+		},
+		{
+				.procname		= "mcast_qlen",
+				.data			= &ipoib_mcast_qlen,
+				.maxlen			= sizeof(unsigned int),
+				.mode			= 0644,
+				.proc_handler	= proc_dointvec_minmax,
+				.extra1			= &min_ipoib_qlen,
+				.extra2			= &max_ipoib_qlen
+		},
+		{},
+};
+
+static ctl_table ipoib_table[] = {
+		{
+				.procname	= "ib_ipoib",
+				.mode		= 0555,
+				.maxlen		= 0,
+				.child		= ipoib_tunable_table
+		},
+		{},
+};
+
+static int param_set_uint_minmax(const char *val,
+					const struct kernel_param *kp,
+					unsigned int min, unsigned int max)
+{
+	unsigned long num;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+	ret = strict_strtoul(val, 0, &num);
+	if (ret == -EINVAL || num < min || num > max)
+		return -EINVAL;
+	*((unsigned int *)kp->arg) = num;
+	return 0;
+}
+
+static int param_set_queue_length(const char *val,
+					const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp,\
+				MIN_IPOIB_QLENGTH, MAX_IPOIB_QLENGTH);
+}
+
+static struct kernel_param_ops param_ops_queue_length = {
+		.set = param_set_queue_length,
+		.get = param_get_uint,
+};
+
+#define param_check_queue_length(name, p) \
+	__param_check(name, p, unsigned int);
+
+module_param_named(prec_qlen, ipoib_prec_qlen, queue_length, 0644);
+MODULE_PARM_DESC(prec_qlen, "Path record queue length ([1..256], default = 3)");
+module_param_named(mcast_qlen, ipoib_mcast_qlen, queue_length, 0644);
+MODULE_PARM_DESC(mcast_qlen, "Multicast queue length ([1...256], default = 3)");
+
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
 int ipoib_debug_level;
 
@@ -597,7 +676,7 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 				ipoib_neigh_free(dev, neigh);
 				goto err_drop;
 			}
-			if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
+			if (skb_queue_len(&neigh->queue) < ipoib_prec_qlen)
 				__skb_queue_tail(&neigh->queue, skb);
 			else {
 				ipoib_warn(priv, "queue length limit %d. Packet drop.\n",
@@ -695,7 +774,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 		ipoib_send(dev, skb, path->ah, IPOIB_QPN(phdr->hwaddr));
 		return;
 	} else if ((path->query || !path_rec_start(dev, path)) &&
-		   skb_queue_len(&path->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
+		   skb_queue_len(&path->queue) < ipoib_prec_qlen) {
 		/* put pseudoheader back on for next time */
 		skb_push(skb, sizeof *phdr);
 		__skb_queue_tail(&path->queue, skb);
@@ -752,7 +831,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 		}
 
-		if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
+		if (skb_queue_len(&neigh->queue) < ipoib_prec_qlen) {
 			spin_lock_irqsave(&priv->lock, flags);
 			__skb_queue_tail(&neigh->queue, skb);
 			spin_unlock_irqrestore(&priv->lock, flags);
@@ -1425,6 +1504,8 @@ static int __init ipoib_init_module(void)
 	if (ret)
 		return ret;
 
+	if (!ipoib_table_header)
+		ipoib_table_header = register_sysctl_table(ipoib_table);
 	/*
 	 * We create our own workqueue mainly because we want to be
 	 * able to flush it when devices are being removed.  We can't
@@ -1461,6 +1542,10 @@ static void __exit ipoib_cleanup_module(void)
 {
 	ib_unregister_client(&ipoib_client);
 	ib_sa_unregister_client(&ipoib_sa_client);
+	if (ipoib_table_header) {
+		unregister_sysctl_table(ipoib_table_header);
+		ipoib_table_header = NULL;
+	}
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..1f2d28e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -693,7 +693,7 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 	}
 
 	if (!mcast->ah) {
-		if (skb_queue_len(&mcast->pkt_queue) < IPOIB_MAX_MCAST_QUEUE)
+		if (skb_queue_len(&mcast->pkt_queue) < ipoib_mcast_qlen)
 			skb_queue_tail(&mcast->pkt_queue, skb);
 		else {
 			++dev->stats.tx_dropped;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
