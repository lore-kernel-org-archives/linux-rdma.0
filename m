Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273DB3E4117;
	Thu,  8 Oct 2026 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448409; cv=none; b=KDO05QuhWrhagPEEYKjdTQhB1d8sM0adQMNwo3CiIof6QpY4tGiBnnhRPiBHXlxkp+NZDjAHbajqCyiM5SclOXnav1sW5IyfbPJPKMUV/dtC/BQEqM4b4sB2VoMhX/7gVKMZ2NR7zm1Xnczfn8hiGorHSJtvTW5Um61m3ZU/Aus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448409; c=relaxed/simple;
	bh=K+8ZbQLfCg0PV60dBTg4VgqRWIwicKQQgKOKwxC36pw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gcCjaV/fIv0+Ipn0iMVtf1SskG3FQNxVE9EY6hBgyjvHDYbsL5SZRoKtyJYxwe/yN+na+pD/xsyz4VtBYMfZy9Efzg3V3oRAVLnKAu/8t7X0ooFKM0aef8IbGtXtKfUeLqJcOfZTaG7NZ5lVw66m6T+KbE484PvSIJnobYgqH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mPgLOUlY; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mPgLOUlY"
Received: from kali.mshome.net (unknown [4.213.232.17])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3FBB820B7167;
	Thu,  8 Oct 2026 01:32:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3FBB820B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791448350;
	bh=Pn9xSQav7Mt56V0G61/8zYZp9JX8VoM9Cp2v/Ee6wtE=;
	h=From:To:Subject:Date:From;
	b=mPgLOUlYD6U3WQheqPW6sGS2jag1ERBDY/iQRUUUUZ88obHOtmn2VlsUJK/+ngx/1
	 muAtb6Fm+fqRZhZrN30KAs/dUXrM5MCuSB4ne7IRTZTCpdmCNotm9avHcCQiq/fZVd
	 O9AVf3WRwDEz8W/hOfgm6VtX7xcP/pFaZTYHZWkc=
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
Subject: [PATCH net-next] net: mana: Add support to process throttled EQEs
Date: Thu,  8 Oct 2026 03:33:05 -0500
Message-ID: <20261008083315.306076-1-sahilchandna@linux.microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an event queue nears full, the hardware coalesces the per-CQ
GDMA_EQE_COMPLETION notifications into a single throttle EQE of type 4
that carries no cq_id. The driver does not handle this event type, so
it falls through to the default case and is dropped. Any CQ whose
completion notification was replaced by the throttle EQE is then never
scheduled again and its queue stalls.
Add support to process the CQs which belong to a throttled EQE of type 4.

Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 43 ++++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  7 +++
 include/net/mana/gdma.h                       | 12 +++++-
 include/net/mana/mana.h                       |  1 +
 4 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ae0ed700b3b9..b8e5ad2c6d31 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -747,6 +747,18 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
 	gc->service_wq = NULL;
 }

+static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
+{
+	struct gdma_queue *cq;
+	u8 i;
+
+	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
+		cq = rcu_dereference(eq->eq.child_cq[i]);
+		if (cq && cq->cq.callback)
+			cq->cq.callback(cq->cq.context, cq);
+	}
+}
+
 static void mana_gd_process_eqe(struct gdma_queue *eq)
 {
 	u32 head = eq->head % (eq->queue_size / GDMA_EQE_SIZE);
@@ -777,6 +789,11 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)

 		break;

+	case GDMA_EQE_THROTTLE:
+		eq->eq.throttle_count++;
+		mana_gd_schedule_eq_cqs(eq);
+		break;
+
 	case GDMA_EQE_TEST_EVENT:
 		gc->test_event_eq_id = eq->id;
 		complete(&gc->eq_test_event);
@@ -1063,17 +1080,41 @@ static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
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
+	struct gdma_queue *parent = queue->cq.parent;
 	u32 id = queue->id;
+	u8 i;
+
+	if (parent) {
+		for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
+			if (rcu_access_pointer(parent->eq.child_cq[i]) == queue)
+				RCU_INIT_POINTER(parent->eq.child_cq[i], NULL);
+		}
+
+		synchronize_rcu();
+	}

 	if (id >= gc->max_num_cqs)
 		return;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index ece7ff9cc409..1004c3334532 100644
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
@@ -261,6 +263,11 @@ static void mana_get_ethtool_stats(struct net_device *ndev,
 	 */
 	mana_query_phy_stats(apc);

+	apc->eth_stats.eq_throttle_events = 0;
+	for (q = 0; q < num_queues; q++)
+		apc->eth_stats.eq_throttle_events +=
+			apc->eqs[q].eq->eq.throttle_count;
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
index 83b7eff4646e..46aa843737b8 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -439,6 +439,7 @@ struct mana_ethtool_stats {
 	u64 tx_cqe_unknown_type;
 	u64 tx_linear_pkt_cnt;
 	u64 rx_cqe_unknown_type;
+	u64 eq_throttle_events;
 };

 struct mana_ethtool_hc_stats {
--
2.53.0

