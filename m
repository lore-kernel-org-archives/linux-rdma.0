Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D7B5158A4;
	Wed, 14 Oct 2026 13:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985408; cv=none; b=jY2dMqWGvjO4/OSdCm27l2vdiAaSiUgyfiwn37WaM8fiFDnxKwSK+yyWCPYbuz+jQcrxh2IQNKiu+k94dA/xqE6LoI40xGzqPv4iyRs0w1+B7//17bqAm+8ETcmCjKy6st8v6B13O50jd/88SOBXWGriWUgbxg6GZv8WdMr8yCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985408; c=relaxed/simple;
	bh=Z3J1JCN1E/KrXGWOCh8TnXpLHC4hDSH+EZBzi8fLHxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cosVd7JJZvD83iB7lUa7filKBDN5UhH/hqNk8+5d5EabdyhwbO5Wpsp8NjyiqBy8pWzIhcU5xyWtyQuA91EIUy4NNSp4H2dTMqHTP+YVxsnZgnIK3YBWSQIY0/VTbvpOlPV083kO7+MdkKnAEAt4FiN1281gIh58NKYPVXpfKp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iWCt85OI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iWCt85OI"
Received: from kali.mshome.net (unknown [4.213.232.18])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9433A20B7166;
	Wed, 14 Oct 2026 06:43:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9433A20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791985396;
	bh=bBhI9+7cimdAIYb3M5SIUEKugO422WVOkTtxhxLhiEU=;
	h=From:To:Cc:Subject:Date:From;
	b=iWCt85OIBLBWqOoqiyitse5lT0NrcBbpjTp5AQtREU4dfrscRzDdKSO1i7/4AQ6Fl
	 aU8a4rBNNaSXcZLMcVSPKRsYfh0s1PoDp3Nj/8jAAPY7Sjjfgr+AiijuO6+m0+27BP
	 BXp15yTu+ki3Bq3MeCSJXD+jjU4G1ZJhOz6XiwLw=
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
To: haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	mawasthi@linux.microsoft.com,
	leitao@debian.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH net v2] net: mana: Add support to process throttled EQEs
Date: Wed, 14 Oct 2026 08:43:01 -0500
Message-ID: <20261014134304.4177657-1-sahilchandna@linux.microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an event queue nears full, the hardware coalesces the per-CQ
GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
that carries no cq_id. The driver does not handle this event type, so
it falls through to the default case and is dropped. Any CQ whose
completion notification was replaced by the throttle EQE can remain
unserviced, causing its queue to stall.
The issue was observed internally and following Tx stall logs were
seen:

2026-10-03T05:29:01 hv_netvsc eth0: VF slot 0 removed
2026-10-03T05:29:23 mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 45:
                    transmit queue 1 timed out 15133 ms
2026-10-03T05:31:05 mana 7870:00:00.0: HWC: Request timed out: 60000 ms
2026-10-03T05:31:05 mana 7870:00:00.0: Gf stats wk handler: gf stats
query timed out.
2026-10-03T05:31:21 ens1: NETDEV WATCHDOG: CPU: 20: transmit queue 0
timed out 15859 ms
2026-10-03T05:31:37 ens1: NETDEV WATCHDOG: CPU: 15: transmit queue 0
timed out 31731 ms
2026-10-03T05:31:53 ens1: NETDEV WATCHDOG: CPU: 21: transmit queue 0
timed out 47603 ms
2026-10-03T05:32:08 ens1: NETDEV WATCHDOG: CPU: 42: transmit queue 0
timed out 62451 ms

Add support to process the CQs which belong to a throttled EQE of type 4
and advertise capability bit, also add a counter to store the throttled
EQEs count.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Cc: stable@vger.kernel.org
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
Changes in v2:
- Use WRITE_ONCE() when clearing max_num_cqs and add RCU
  grace period wait during HWC teardown.
- Use synchronize_net() during CQ destroy only when the CQ was
  attached to its parent EQ.
- Use WRITE_ONCE() and READ_ONCE() for the throttle-event counter.
- Add Fixes tag and net instead of net-next.
- Fix commit message to describe capability bit and counter.
Link to v1: https://lore.kernel.org/all/20261008083315.306076-1-sahilchandna@linux.microsoft.com/

 .../net/ethernet/microsoft/mana/gdma_main.c   | 56 ++++++++++++++++++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |  4 +-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  9 +++
 include/net/mana/gdma.h                       | 12 +++-
 include/net/mana/mana.h                       |  1 +
 5 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ae0ed700b3b9..95ba6ba161ae 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -747,6 +747,27 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
 	gc->service_wq = NULL;
 }

+static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
+{
+	struct gdma_context *gc = eq->gdma_dev->gdma_context;
+	struct gdma_queue *cq;
+	u8 i;
+
+	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
+		cq = rcu_dereference(eq->eq.child_cq[i]);
+
+		if (!cq)
+			continue;
+
+		if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
+		    !gc->cq_table || gc->cq_table[cq->id] != cq)
+			continue;
+
+		if (cq->cq.callback)
+			cq->cq.callback(cq->cq.context, cq);
+	}
+}
+
 static void mana_gd_process_eqe(struct gdma_queue *eq)
 {
 	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
@@ -777,6 +798,11 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)

 		break;

+	case GDMA_EQE_THROTTLE:
+		WRITE_ONCE(eq->eq.throttle_count, eq->eq.throttle_count + 1);
+		mana_gd_schedule_eq_cqs(eq);
+		break;
+
 	case GDMA_EQE_TEST_EVENT:
 		gc->test_event_eq_id = eq->id;
 		complete(&gc->eq_test_event);
@@ -1063,17 +1089,45 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 			      struct gdma_queue *queue)
 {
 	u32 log2_num_entries = ilog2(spec->queue_size / GDMA_CQE_SIZE);
+	struct gdma_queue *parent;
+	u8 i;

 	queue->head |= INITIALIZED_OWNER_BIT(log2_num_entries);
-	queue->cq.parent = spec->cq.parent_eq;
+	parent = spec->cq.parent_eq;
+	queue->cq.parent = parent;
 	queue->cq.context = spec->cq.context;
 	queue->cq.callback = spec->cq.callback;
+
+	if (!parent)
+		return;
+
+	/* For throttled EQE store the child CQ */
+	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++)
+		if (!rcu_access_pointer(parent->eq.child_cq[i])) {
+			rcu_assign_pointer(parent->eq.child_cq[i], queue);
+			return;
+		}
 }

 static void mana_gd_destroy_cq(struct gdma_context *gc,
 			       struct gdma_queue *queue)
 {
+	struct gdma_queue *eq = queue->cq.parent;
+	bool attached = false;
 	u32 id = queue->id;
+	u8 i;
+
+	if (eq) {
+		for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
+			if (rcu_access_pointer(eq->eq.child_cq[i]) == queue) {
+				RCU_INIT_POINTER(eq->eq.child_cq[i], NULL);
+				attached = true;
+			}
+		}
+
+		if (attached)
+			synchronize_net();
+	}

 	if (id >= gc->max_num_cqs)
 		return;
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 3bca4b683134..ba42da821e12 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -820,9 +820,11 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	 */
 	if (gc->max_num_cqs > 0) {
 		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		gc->max_num_cqs = 0;
+		WRITE_ONCE(gc->max_num_cqs, 0);
 	}

+	synchronize_rcu();
+
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 33db79569d3b..bc1db86acf64 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -22,6 +22,8 @@ static const struct mana_stats_desc mana_eth_stats[] = {
 				       tx_linear_pkt_cnt)},
 	{"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
 					rx_cqe_unknown_type)},
+	{"eq_throttle_events", offsetof(struct mana_ethtool_stats,
+					eq_throttle_events)},
 };

 static const struct mana_stats_desc mana_hc_stats[] = {
@@ -250,6 +252,7 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	u64 short_pkt_fmt;
 	u64 csum_partial;
 	u64 mana_map_err;
+	u64 throttle_events;
 	int q, i = 0, j;

 	if (!apc->port_is_up)
@@ -261,6 +264,12 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	 */
 	mana_query_phy_stats(apc);

+	throttle_events = 0;
+	for (q = 0; q < num_queues; q++)
+		throttle_events += READ_ONCE(apc->eqs[q].eq->eq.throttle_count);
+
+	apc->eth_stats.eq_throttle_events = throttle_events;
+
 	for (q = 0; q < ARRAY_SIZE(mana_eth_stats); q++)
 		data[i++] = *(u64 *)(eth_stats + mana_eth_stats[q].offset);

diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index c610fc1067e0..03fe9395604d 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -58,6 +58,7 @@ enum gdma_work_request_flags {

 enum gdma_eqe_type {
 	GDMA_EQE_COMPLETION		= 3,
+	GDMA_EQE_THROTTLE		= 4,
 	GDMA_EQE_TEST_EVENT		= 64,
 	GDMA_EQE_HWC_INIT_EQ_ID_DB	= 129,
 	GDMA_EQE_HWC_INIT_DATA		= 130,
@@ -286,6 +287,7 @@ struct gdma_dev {
 #define GDMA_EQE_SIZE 16
 #define GDMA_MAX_SQE_SIZE 512
 #define GDMA_MAX_RQE_SIZE 256
+#define GDMA_EQ_MAX_CHILD_CQ  2

 #define GDMA_COMP_DATA_SIZE 0x3C

@@ -366,6 +368,10 @@ struct gdma_queue {
 			unsigned int irq;

 			u32 log2_throttle_limit;
+
+			u64 throttle_count;
+
+			struct gdma_queue __rcu *child_cq[GDMA_EQ_MAX_CHILD_CQ];
 		} eq;

 		struct {
@@ -752,6 +758,9 @@ enum {
 /* Driver supports non-contiguous queue buffers */
 #define GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS BIT(30)

+/* Driver supports handling throttled EQEs */
+#define GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE BIT_ULL(32)
+
 /* Capabilities in the PCI-only group below rely on dynamic MSI-X allocation
  * and on the servicing and reset paths reached through
  * mana_schedule_serv_work(). Transports that provide neither leave
@@ -776,7 +785,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY | \
 	 GDMA_DRV_CAP_FLAG_1_EQ_MSI_UNSHARE_MULTI_VPORT | \
 	 GDMA_DRV_CAP_FLAG_1_DYN_INTERRUPT_MODERATION | \
-	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS)
+	 GDMA_DRV_CAP_FLAG_1_NON_CONTIGUOUS_BUFFERS | \
+	 GDMA_DRV_CAP_FLAG_1_THROTTLED_EVENT_QUEUE)

 #define GDMA_DRV_CAP_FLAGS2 0

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 8c3dc9d0b299..1d4be069f869 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -450,6 +450,7 @@ struct mana_ethtool_stats {
 	u64 tx_cqe_unknown_type;
 	u64 tx_linear_pkt_cnt;
 	u64 rx_cqe_unknown_type;
+	u64 eq_throttle_events;
 };

 struct mana_ethtool_hc_stats {
--
2.53.0

