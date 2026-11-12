Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794481085;
	b=AVKgaQV1cOkotsv40MiEK9lcHJrcSJtD1Gx+gQ0bhFoLlEb1FTI6X8S7faOBYgban4Qn
	 XmL7lgb/lKIL5nwOZ7ouT4j68h5oLSPHOyifuA4cuiTT+7DOF0IwMYMKy1nb23SmG5wDt
	 r0GdhYnD8HDS0uhbnM1xBZESpnzEVFxDEIzyCey8mq34I7ws/T+S4mpt/30JvXhFydNRz
	 pXfvK6XLktowh9siP50HjD0Y0nr3nC89fIeJWDImtMWT15LpoQGqBeRg+XedSwxRiWHZW
	 V6Bcv/BS7BnO3YfkPGQpPmWqlMPbE6lyR61rGcL3AALs6ItaMob0dvEY/U7YHikbdQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794481085;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=GUeyCkWJ30TKeXscHAtkA+LtWzqmgJiXCIh4pQZpiKI=;
	b=YEE2GMd/acZWOIrOBCVP+36IO47YM+crwR6Iw7dWiYWT8LUBnQct6A5HsFOVTu1GRpfR
	 ZVVuy7W4zrcEhY+eXXha12T0NjVGW2rb8IupMZlElbcWMtk51F1jtDE+NshQ4bjUOjpns
	 78Y07ReyhTByjcSyI6fCijbU1OvgFwGXnT2T/kxV4LnnrHQTrCRz04YH8IjWioDE9UBCl
	 A6GdKqFO23A/RLSJSVeRj9Ql7/AP1ExN5V+WZYknDWmc04TCJ+aXP2pjR3dkfI+DfC440
	 vRN/l/yTU+TWGobfJjWwFSEUdlltrzBynAfQl1lI54meFwLX1ubSIedM4lkyXKOjPQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=lCZb3yKc;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8A6606A321;
	Thu, 12 Nov 2026 10:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB8A6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=lCZb3yKc
Received: from kali.mshome.net (unknown [4.213.232.19])
	by linux.microsoft.com (Postfix) with ESMTPSA id 34F3020B7168;
	Thu, 12 Nov 2026 02:57:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 34F3020B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794481080;
	bh=GUeyCkWJ30TKeXscHAtkA+LtWzqmgJiXCIh4pQZpiKI=;
	h=From:To:Subject:Date:From;
	b=lCZb3yKcup/JAsYlNeFlSW7d8PXVj2Hz/MSwDVQN83kwTfhXK4AgpLDhCRvCQmtV5
	 jKnNe7tRd8nqH/f1Qoa26wo0vROkUk1j6GCz25y9uAGir9TTMa1bsnIQ+1qPvZblgQ
	 Kqd4VjLwW5bfz5eZmTtahbJXAdUt5la0EerHLRag=
From: Sahil Chandna <sahilchandna@linux.microsoft.com>
To: haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	weh@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	leitao@debian.org,
	sahilchandna@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net: mana: Add CQE polling as first-level TX timeout recovery
Date: Thu, 12 Nov 2026 04:57:18 -0600
Message-ID: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current mana_tx_timeout() handler unconditionally schedules a full
port queue reset (detach/attach) whenever the TX watchdog fires.
This is unnecessary for transient stalls where completions are
simply delayed or an interrupt was missed.

Implement a graduated recovery approach: on the first TX timeout (or
when the previous timeout was more than 2 minutes ago), schedule NAPI on
the stalled queue's TX CQ via napi_schedule(). This triggers
mana_poll_tx_cq() through the normal NAPI path, processing any pending
completions without relying on the interrupt and recovering
missed-interrupt scenarios without queue reset.

If any subsequent TX timeout fires on any queue, within 2 minutes of
the previous one, escalate to the existing port-level detach/attach
reset, as the CQE poll did not recover the queue.

This makes the TX timeout recovery three-tiered:

  Level 1: CQE poll via napi_schedule() (this patch)
  Level 2: Port queue reset (detach/attach)
  Level 3: device reset(FLR)

Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 31 ++++++++++++++++---
 .../ethernet/microsoft/mana/mana_ethtool.c    |  2 ++
 include/net/mana/mana.h                       |  4 +++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index e6d494df22e4..0d8c8b8fbc83 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -336,6 +336,9 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 	if (err)
 		netdev_err(ndev, "mana_attach failed: %d\n", err);

+	/* Let the next TX timeout try a CQE poll recovery first */
+	WRITE_ONCE(apc->last_tx_timeout, 0);
+
 dealloc_pre_rxbufs:
 	mana_pre_dealloc_rxbufs(apc);
 clear_flag:
@@ -964,6 +967,7 @@ static void mana_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	struct mana_port_context *apc = netdev_priv(netdev);
 	struct mana_context *ac = apc->ac;
 	struct gdma_context *gc = ac->gdma_dev->gdma_context;
+	unsigned long last = READ_ONCE(apc->last_tx_timeout);

 	/* Debug knob for bringup/qualification: when set, log the timeout and
 	 * skip the reset so the failing state is preserved for telemetry.
@@ -980,11 +984,30 @@ static void mana_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	if (test_bit(GC_IN_SERVICE, &gc->flags))
 		return;

-	/* Note: If there are pending queue reset work for this port(apc),
-	 * subsequent request queued up from here are ignored. This is because
-	 * we are using the same work instance per port(apc).
+	if (!apc->port_is_up)
+		return;
+
+	/* If the previous timeout fired less than
+	 * MANA_TX_TIMEOUT_RESET_THRESHOLD ago, the earlier CQE poll did not
+	 * help and queue stalled again	: escalate to a port reset.
+	 * Note: If there is pending queue reset work for this port (apc),
+	 * subsequent requests queued up from here are ignored, because the
+	 * same work instance is used per port (apc).
 	 */
-	queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
+	if (last &&
+	    time_after(last, jiffies - MANA_TX_TIMEOUT_RESET_THRESHOLD)) {
+		queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
+		return;
+	}
+
+	/* First timeout, or the previous one was long ago: try to recover by
+	 * polling the TX CQ for completions before escalating to a reset.
+	 */
+	if (txqueue < apc->num_queues && apc->tx_qp && apc->tx_qp[txqueue]) {
+		WRITE_ONCE(apc->last_tx_timeout, jiffies);
+		apc->eth_stats.tx_cqe_poll_recovery++;
+		napi_schedule(&apc->tx_qp[txqueue]->tx_cq.napi);
+	}
 }

 static int mana_shaper_set(struct net_shaper_binding *binding,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index a91eb12badca..ff4799c61a6c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -22,6 +22,8 @@ static const struct mana_stats_desc mana_eth_stats[] = {
 				       tx_linear_pkt_cnt)},
 	{"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
 					rx_cqe_unknown_type)},
+	{"tx_cqe_poll_recovery", offsetof(struct mana_ethtool_stats,
+					tx_cqe_poll_recovery)},
 };

 static const struct mana_stats_desc mana_hc_stats[] = {
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 09725e3256fa..5de6eaa02102 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -94,6 +94,8 @@ enum mana_priv_flag_bits {

 #define MANA_RX_FRAG_ALIGNMENT 64

+#define MANA_TX_TIMEOUT_RESET_THRESHOLD (2 * 60 * HZ)
+
 struct mana_stats_rx {
 	u64 packets;
 	u64 bytes;
@@ -447,6 +449,7 @@ struct mana_tx_qp {
 struct mana_ethtool_stats {
 	u64 stop_queue;
 	u64 wake_queue;
+	u64 tx_cqe_poll_recovery;
 	u64 tx_cqe_err;
 	u64 tx_cqe_unknown_type;
 	u64 tx_linear_pkt_cnt;
@@ -566,6 +569,7 @@ struct mana_port_context {
 	struct net_device *ndev;
 	struct work_struct queue_reset_work;

+	unsigned long last_tx_timeout;
 	/* Debug knob to log TX timeout but skip recovery reset */
 	bool tx_timeout_skip_reset;

--
2.53.0

