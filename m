From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/1] ib/ipoib: Added adaptive moderation algorithm for better latency.
Date: Sun, 14 Aug 2011 11:49:23 +0300
Message-ID: <201108141149.23448.erezsh@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>From 8ea4a6d4387a07b4e0abfb92f164f5181cf636e4 Mon Sep 17 00:00:00 2001
From: Erez Shitrit <erezsh-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Date: Thu, 30 Jun 2011 09:58:09 +0300
Subject: [PATCH 1/2] ib/ipoib: Added adaptive moderation algorithm for better 
latency.

[PATCH V2]:
Adaptive moderation is controlled via ethtool: adaptive-rx on/off.

When adaptive moderation is enabled,the adaptive moderation task is started.
 The task runs on new workqueue, and reschedule itself for the next run.
 The task periodically (every 250 ms) samples the traffic (packet rate and 
average packet sizes),
 and runs an algorithm to define a new moderation time for the receive queue.
 The algorithm classifies the incoming traffic during each sampling interval
 into classes. The rx_usec value (i.e., moderation time) is then adjusted 
appropriately per class.

 There are two classes defined:

  A.  Bulk traffic: for heavy traffic consisting of packets of normal size.
      This class is further divided into two sub-classes:
        1. Traffic that is mainly BW bound
            - This traffic will get maximum moderation.
        2. Traffic that is mostly latency bound
            - For situations where low latency is vital such as cluster or 
grid computing
            - For this traffic the rx_usec will be changed to a value in the 
range (ethtool.pkt_rate_low  .. ethtool.pkt_rate_high) depending on sampled 
packet rate.

  B.  Low latency traffic: for minimal traffic, or traffic consisting almost 
completely of small packets.
            - This traffic will get minimum moderation.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Reviewed-by: Eli cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |   39 ++++++-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   67 +++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    6 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  167 
+++++++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    8 +-
 5 files changed, 278 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h 
b/drivers/infiniband/ulp/ipoib/ipoib.h
index 7b6985a..c58f231 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -91,6 +91,7 @@ enum {
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
 	IPOIB_FLAG_UMCAST	  = 10,
+	IPOIB_FLAG_AUTO_MODER	  = 11, /*indicates moderation is running*/
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
@@ -253,9 +254,43 @@ struct ipoib_cm_dev_priv {
 	int			num_frags;
 };
 
+/* adaptive moderation parameters: */
+enum {
+	/* Target number of packets to coalesce with interrupt moderation */
+	IPOIB_RX_COAL_TARGET	= 44,
+	IPOIB_RX_COAL_TIME	= 16,
+	IPOIB_TX_COAL_PKTS	= 5,
+	IPOIB_TX_COAL_TIME	= 0x80,
+	IPOIB_RX_RATE_LOW	= 400000,
+	IPOIB_RX_COAL_TIME_LOW	= 0,
+	IPOIB_RX_RATE_HIGH	= 450000,
+	IPOIB_RX_COAL_TIME_HIGH	= 128,
+	IPOIB_RX_SIZE_THRESH	= 1024,
+	IPOIB_RX_RATE_THRESH	= 1000000 / IPOIB_RX_COAL_TIME_HIGH,
+	IPOIB_SAMPLE_INTERVAL	= 0,
+	IPOIB_AVG_PKT_SMALL	= 256,
+	IPOIB_AUTO_CONF		= 0xffff,
+	ADAPT_MODERATION_DELAY	= HZ / 4,
+};
+
 struct ipoib_ethtool_st {
-	u16     coalesce_usecs;
+	__u32 rx_max_coalesced_frames;
+	__u32 rx_coalesce_usecs;
+/*	u16     coalesce_usecs;
 	u16     max_coalesced_frames;
+*/
+	__u32	pkt_rate_low;
+	__u32	pkt_rate_high;
+	__u32	rx_coalesce_usecs_low;
+	__u32	rx_coalesce_usecs_high;
+	__u32	rate_sample_interval;
+	__u32	use_adaptive_rx_coalesce;
+	int	last_moder_time;
+	u16	sample_interval;
+	unsigned long last_moder_jiffies;
+	unsigned long last_moder_packets;
+	unsigned long last_moder_tx_packets;
+	unsigned long last_moder_bytes;
 };
 
 /*
@@ -289,6 +324,7 @@ struct ipoib_dev_priv {
 	struct work_struct flush_heavy;
 	struct work_struct restart_task;
 	struct delayed_work ah_reap_task;
+	struct delayed_work adaptive_moder_task;
 
 	struct ib_device *ca;
 	u8		  port;
@@ -409,6 +445,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour 
*neigh,
 void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh);
 
 extern struct workqueue_struct *ipoib_workqueue;
+extern struct workqueue_struct *ipoib_auto_moder_workqueue;
 
 /* functions */
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c 
b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 29bc7b5..b41c061 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -46,18 +46,30 @@ static int ipoib_get_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-
-	coal->rx_coalesce_usecs = priv->ethtool.coalesce_usecs;
-	coal->rx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;
+	coal->rx_coalesce_usecs = priv->ethtool.rx_coalesce_usecs;
+	coal->rx_max_coalesced_frames = priv->ethtool.rx_max_coalesced_frames;
+	coal->pkt_rate_low = priv->ethtool.pkt_rate_low;
+	coal->rx_coalesce_usecs_low = priv->ethtool.rx_coalesce_usecs_low;
+	coal->rx_coalesce_usecs_high = priv->ethtool.rx_coalesce_usecs_high;
+	coal->pkt_rate_high = priv->ethtool.pkt_rate_high;
+	coal->rate_sample_interval = priv->ethtool.rate_sample_interval;
+	coal->use_adaptive_rx_coalesce = priv->ethtool.use_adaptive_rx_coalesce;
 
 	return 0;
 }
 
+enum ipoib_auto_moder_operation {
+	NONE,
+	MOVING_TO_ON,
+	MOVING_TO_OFF
+};
+
 static int ipoib_set_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
+	enum ipoib_auto_moder_operation moder_operation = NONE;
 
 	/*
 	 * These values are saved in the private data and returned
@@ -66,6 +78,15 @@ static int ipoib_set_coalesce(struct net_device *dev,
 	if (coal->rx_coalesce_usecs       > 0xffff ||
 	    coal->rx_max_coalesced_frames > 0xffff)
 		return -EINVAL;
+	priv->ethtool.rx_max_coalesced_frames =
+		(coal->rx_max_coalesced_frames ==
+			   IPOIB_AUTO_CONF) ?
+				IPOIB_RX_COAL_TARGET :
+				coal->rx_max_coalesced_frames;
+	priv->ethtool.rx_coalesce_usecs = (coal->rx_coalesce_usecs ==
+			  IPOIB_AUTO_CONF) ?
+				IPOIB_RX_COAL_TIME :
+				coal->rx_coalesce_usecs;
 
 	ret = ib_modify_cq(priv->recv_cq, coal->rx_max_coalesced_frames,
 			   coal->rx_coalesce_usecs);
@@ -74,16 +95,50 @@ static int ipoib_set_coalesce(struct net_device *dev,
 		return ret;
 	}
 
-	priv->ethtool.coalesce_usecs       = coal->rx_coalesce_usecs;
-	priv->ethtool.max_coalesced_frames = coal->rx_max_coalesced_frames;
+	priv->ethtool.pkt_rate_low = coal->pkt_rate_low;
+	priv->ethtool.rx_coalesce_usecs_low = coal->rx_coalesce_usecs_low;
+	priv->ethtool.rx_coalesce_usecs_high = coal->rx_coalesce_usecs_high;
+	priv->ethtool.pkt_rate_high = coal->pkt_rate_high;
+	priv->ethtool.rate_sample_interval = coal->rate_sample_interval;
+
+	if (priv->ethtool.use_adaptive_rx_coalesce &&
+	    !coal->use_adaptive_rx_coalesce) {
+		/* switch from adaptive-mode to non-adaptive mode:
+		cancell the adaptive moderation task. */
+		clear_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags);
+		cancel_delayed_work(&priv->adaptive_moder_task);
+		moder_operation = MOVING_TO_OFF;
+	} else if ((!priv->ethtool.use_adaptive_rx_coalesce &&
+		    coal->use_adaptive_rx_coalesce)) {
+		/* switch from non-adaptive-mode to adaptive mode,
+		 starts it now */
+		set_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags);
+		moder_operation = MOVING_TO_ON;
+		queue_delayed_work(ipoib_auto_moder_workqueue,
+				   &priv->adaptive_moder_task, 0);
+	}
+
+	if (MOVING_TO_OFF == moder_operation)
+		flush_workqueue(ipoib_auto_moder_workqueue);
+	else if (MOVING_TO_ON == moder_operation) {
+		/* move to initial values */
+		ret = ib_modify_cq(priv->recv_cq, 0, 0);
+		if (ret && ret != -ENOSYS) {
+			ipoib_warn(priv, "failed modifying CQ (%d)"
+					 "(when moving to auto-moderation)\n",
+				   ret);
+			return ret;
+		}
+	}
+	priv->ethtool.use_adaptive_rx_coalesce = coal->use_adaptive_rx_coalesce;
 
 	return 0;
 }
-
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
+
 };
 
 void ipoib_set_ethtool_ops(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c 
b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 81ae61d..e29e314 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -739,6 +739,12 @@ int ipoib_ib_dev_down(struct net_device *dev, int flush)
 			flush_workqueue(ipoib_workqueue);
 	}
 
+	/* cancell the adaptive moderation task. */
+	if (test_and_clear_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags))
+		cancel_delayed_work(&priv->adaptive_moder_task);
+
+	flush_workqueue(ipoib_auto_moder_workqueue);
+
 	ipoib_mcast_stop_thread(dev, flush);
 	ipoib_mcast_dev_flush(dev);
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c 
b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 86addca..6a304e1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -80,6 +80,8 @@ static const u8 ipv4_bcast_addr[] = {
 
 struct workqueue_struct *ipoib_workqueue;
 
+struct workqueue_struct *ipoib_auto_moder_workqueue;
+
 struct ib_sa_client ipoib_sa_client;
 
 static void ipoib_add_one(struct ib_device *device);
@@ -127,6 +129,13 @@ int ipoib_open(struct net_device *dev)
 
 	netif_start_queue(dev);
 
+	if (priv->ethtool.use_adaptive_rx_coalesce) {
+		set_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags);
+		queue_delayed_work(ipoib_auto_moder_workqueue,
+					   &priv->adaptive_moder_task,
+					   ADAPT_MODERATION_DELAY);
+	}
+
 	return 0;
 
 err_stop:
@@ -913,6 +922,148 @@ static int ipoib_neigh_setup_dev(struct net_device *dev, 
struct neigh_parms *par
 	return 0;
 }
 
+
+static void ipoib_set_default_moderation(struct ipoib_dev_priv *priv)
+{
+
+	/* If we haven't received a specific coalescing setting
+	 * (module param), we set the moderation parameters as follows:
+	 * - moder_cnt is set to the number of mtu sized packets to
+	 *   satisfy our coaelscing target.
+	 * - moder_time is set to a fixed value.
+	 */
+	priv->ethtool.rx_max_coalesced_frames = IPOIB_RX_COAL_TARGET;
+	priv->ethtool.rx_coalesce_usecs = IPOIB_RX_COAL_TIME_LOW;
+	printk(KERN_ERR "Default coalesing params for mtu:%d - "
+			   "rx_frames:%d rx_usecs:%d\n",
+	       priv->dev->mtu, priv->ethtool.rx_max_coalesced_frames,
+	       priv->ethtool.rx_coalesce_usecs);
+
+	/* Reset auto-moderation params */
+	priv->ethtool.pkt_rate_low = IPOIB_RX_RATE_LOW;
+	priv->ethtool.rx_coalesce_usecs_low = IPOIB_RX_COAL_TIME_LOW;
+	priv->ethtool.pkt_rate_high = IPOIB_RX_RATE_HIGH;
+	priv->ethtool.rx_coalesce_usecs_high = IPOIB_RX_COAL_TIME_HIGH;
+	priv->ethtool.sample_interval = IPOIB_SAMPLE_INTERVAL;
+	priv->ethtool.use_adaptive_rx_coalesce = 1;
+	priv->ethtool.last_moder_time = IPOIB_AUTO_CONF;
+	priv->ethtool.last_moder_jiffies = 0;
+	priv->ethtool.last_moder_packets = 0;
+	priv->ethtool.last_moder_tx_packets = 0;
+	priv->ethtool.last_moder_bytes = 0;
+}
+/*
+The function classifies the incoming traffic during each sampling interval
+into classes. The rx_usec value (i.e., moderation time) is then adjusted
+appropriately per class.
+There are two classes defined:
+	A. Bulk traffic: for heavy traffic consisting of packets of normal size.
+	This class is further divided into two sub-classes:
+		1. Traffic that is mainly BW bound
+		- This traffic will get maximum moderation.
+		2. Traffic that is mostly latency bound
+		- For situations where low latency is vital
+		- The rx_usec will be changed to a value in the range:
+		(ethtool.pkt_rate_low  .. ethtool.pkt_rate_high)
+		depending on sampled packet rate.
+	B.  Low latency traffic: for minimal traffic, or small packets.
+	- This traffic will get minimum moderation.
+*/
+static void ipoib_auto_moderation(struct ipoib_dev_priv *priv)
+{
+	unsigned long period = jiffies - priv->ethtool.last_moder_jiffies;
+	unsigned long packets;
+	unsigned long rate;
+	unsigned long avg_pkt_size;
+	unsigned long rx_packets;
+	unsigned long rx_bytes;
+	unsigned long tx_packets;
+	unsigned long tx_pkt_diff;
+	unsigned long rx_pkt_diff;
+	int moder_time;
+	int ret;
+
+	if (!priv->ethtool.use_adaptive_rx_coalesce)
+		return;
+
+	rx_packets = priv->dev->stats.rx_packets;
+	rx_bytes = priv->dev->stats.rx_bytes;
+	tx_packets = priv->dev->stats.tx_packets;
+
+	tx_pkt_diff = tx_packets - priv->ethtool.last_moder_tx_packets;
+	rx_pkt_diff = rx_packets - priv->ethtool.last_moder_packets;
+	packets = max(tx_pkt_diff, rx_pkt_diff);
+	rate = packets * HZ / period;
+	avg_pkt_size = packets ?
+		(rx_bytes - priv->ethtool.last_moder_bytes) / packets : 0;
+
+	/* Apply auto-moderation only when packet rate exceeds a rate that
+	 * it matters */
+	if (rate > IPOIB_RX_RATE_THRESH && avg_pkt_size > IPOIB_AVG_PKT_SMALL) {
+		/* If tx and rx packet rates are not balanced
+		 * (probably TCP stream, big data and small acks),
+		 * assume that traffic is mainly BW bound (maximum moderation).
+		 * Otherwise, moderate according to packet rate */
+		if (2 * tx_pkt_diff > 3 * rx_pkt_diff ||
+		    2 * rx_pkt_diff > 3 * tx_pkt_diff)
+			moder_time = priv->ethtool.rx_coalesce_usecs_high;
+		else {
+			if (rate < priv->ethtool.pkt_rate_low)
+				moder_time =
+					priv->ethtool.rx_coalesce_usecs_low;
+			else if (rate > priv->ethtool.pkt_rate_high)
+				moder_time =
+					priv->ethtool.rx_coalesce_usecs_high;
+			else
+				moder_time = (rate - priv->ethtool.pkt_rate_low) *
+					(priv->ethtool.rx_coalesce_usecs_high - 
priv->ethtool.rx_coalesce_usecs_low) /
+					(priv->ethtool.pkt_rate_high - priv->ethtool.pkt_rate_low) +
+					priv->ethtool.rx_coalesce_usecs_low;
+		}
+	} else
+		moder_time = priv->ethtool.rx_coalesce_usecs_low;
+
+	if (moder_time != priv->ethtool.last_moder_time) {
+		ipoib_dbg(priv, "%s: Rx moder_time changed from:%d to %d\n",
+		       __func__, priv->ethtool.last_moder_time, moder_time);
+		priv->ethtool.last_moder_time = moder_time;
+		ret = ib_modify_cq(priv->recv_cq,
+				   priv->ethtool.rx_max_coalesced_frames,
+				   moder_time);
+		if (ret && ret != -ENOSYS)
+			ipoib_warn(priv, "%s: failed modifying CQ (%d)\n",
+				   __func__, ret);
+	}
+
+	priv->ethtool.last_moder_packets = rx_packets;
+	priv->ethtool.last_moder_tx_packets = tx_packets;
+	priv->ethtool.last_moder_bytes = rx_bytes;
+	priv->ethtool.last_moder_jiffies = jiffies;
+}
+
+static void ipoib_config_adapt_moder(struct work_struct *work)
+{
+	struct delayed_work *delay = to_delayed_work(work);
+	struct ipoib_dev_priv *priv = container_of(delay,
+						   struct ipoib_dev_priv,
+						   adaptive_moder_task);
+
+	if (!(netif_running(priv->dev) && netif_carrier_ok(priv->dev))) {
+		ipoib_dbg(priv, "%s: port is not ACTIVE, no configuration"
+				" for adaptive moderation\n",
+			  __func__);
+		return;
+	}
+
+	ipoib_auto_moderation(priv);
+
+	if (test_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags) &&
+	    priv->ethtool.use_adaptive_rx_coalesce)
+		queue_delayed_work(ipoib_auto_moder_workqueue,
+				   &priv->adaptive_moder_task,
+				   ADAPT_MODERATION_DELAY);
+}
+
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -934,10 +1085,11 @@ int ipoib_dev_init(struct net_device *dev, struct 
ib_device *ca, int port)
 	}
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
-
 	if (ipoib_ib_dev_init(dev, ca, port))
 		goto out_tx_ring_cleanup;
 
+	ipoib_set_default_moderation(priv);
+
 	return 0;
 
 out_tx_ring_cleanup:
@@ -1037,6 +1189,7 @@ static void ipoib_setup(struct net_device *dev)
 	INIT_WORK(&priv->flush_heavy,   ipoib_ib_dev_flush_heavy);
 	INIT_WORK(&priv->restart_task, ipoib_mcast_restart_task);
 	INIT_DELAYED_WORK(&priv->ah_reap_task, ipoib_reap_ah);
+	INIT_DELAYED_WORK(&priv->adaptive_moder_task, ipoib_config_adapt_moder);
 }
 
 struct ipoib_dev_priv *ipoib_intf_alloc(const char *name)
@@ -1342,6 +1495,7 @@ static void ipoib_remove_one(struct ib_device *device)
 		rtnl_unlock();
 
 		flush_workqueue(ipoib_workqueue);
+		flush_workqueue(ipoib_auto_moder_workqueue);
 
 		unregister_netdev(priv->dev);
 		ipoib_dev_cleanup(priv->dev);
@@ -1390,6 +1544,14 @@ static int __init ipoib_init_module(void)
 		goto err_fs;
 	}
 
+	ipoib_auto_moder_workqueue =
+		create_singlethread_workqueue("ipoib_auto_moder");
+	if (!ipoib_auto_moder_workqueue) {
+		ret = -ENOMEM;
+		goto err_am;
+	}
+
+
 	ib_sa_register_client(&ipoib_sa_client);
 
 	ret = ib_register_client(&ipoib_client);
@@ -1400,6 +1562,8 @@ static int __init ipoib_init_module(void)
 
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
+	destroy_workqueue(ipoib_auto_moder_workqueue);
+err_am:
 	destroy_workqueue(ipoib_workqueue);
 
 err_fs:
@@ -1414,6 +1578,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	destroy_workqueue(ipoib_auto_moder_workqueue);
 }
 
 module_init(ipoib_init_module);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c 
b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3871ac6..d403112 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -364,7 +364,6 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
 	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
 						   carrier_on_task);
 	struct ib_port_attr attr;
-
 	/*
 	 * Take rtnl_lock to avoid racing with ipoib_stop() and
 	 * turning the carrier back on while a device is being
@@ -379,6 +378,13 @@ void ipoib_mcast_carrier_on_task(struct work_struct 
*work)
 	rtnl_lock();
 	netif_carrier_on(priv->dev);
 	rtnl_unlock();
+
+	/* enable auto-moderation */
+	if (priv->ethtool.use_adaptive_rx_coalesce &&
+	    test_bit(IPOIB_FLAG_AUTO_MODER, &priv->flags))
+		queue_delayed_work(ipoib_auto_moder_workqueue,
+				   &priv->adaptive_moder_task,
+				   ADAPT_MODERATION_DELAY);
 }
 
 static int ipoib_mcast_join_complete(int status,
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
