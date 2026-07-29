Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F5F30C158;
	Wed, 29 Jul 2026 06:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306877; cv=none; b=gUm5eRkw/tVNIyM0KmdFJS0sPdNhk3Yxz+gzy8N9P95uPblNGr6skW+HdV8lwwsyo28xT5kA+IJf+sNu3PHnyLLrJFa4RPeHww1n3pP4RpMNqgVGL3iBrFENyUyVkEoQeGCvf660WR8SlQ3mFgzuyYntoWxXLZm1IXj/zCU+VbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306877; c=relaxed/simple;
	bh=Ugmyof3onGTBz25sg2kprtpm2EWLkbRs09cTkGbDbLo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3Z3doJPRbQnZ81NFT2q9iwu+UyoqfF2jtJfLGeHW6xp8v2tVpoGZBVfrQjqbkIRCA3XTJki9TK2VlVdgbooPBLTRvOYZcurwmcl8N9rkfGCaidHkoLVRHt6tdtl34VgSxz0CuIpH0GpLgMLSC3PROzLS5WTZr7WEAsJ1xjhO/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=GZIHkBT0; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="GZIHkBT0"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 90C8720B7169;
	Tue, 28 Jul 2026 23:34:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 90C8720B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1785306858;
	bh=Yljp5YSERSxDw0VU1Q+HUZYXqeMzSIUZRi3ZK406MOE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GZIHkBT0SQRG/BNdK4NjodlNfyKdT4gvbOI8zbGjvvx7HlDXP2dn9GE0Wyrfnf4Y9
	 7L0VHrtoNfW6XMUCGAN6M2Ps4rRu+qLV9mtRKDqe5pcyg3Uo/x7sc+r+VHxFMuipxl
	 frSfpltSl7IKYW4q/zce6iDpfCxHaxDGZC5LlXTw=
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com,
	pavan.chebbi@broadcom.com,
	schakrabarti@linux.microsoft.com,
	gargaditya@linux.microsoft.com
Subject: [PATCH net-next v13 2/2] net: mana: force full-page RX buffers via ethtool private flag
Date: Tue, 28 Jul 2026 23:21:29 -0700
Message-ID: <20260729063347.3388035-3-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729063347.3388035-1-dipayanroy@linux.microsoft.com>
References: <20260729063347.3388035-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some ARM64 platforms with 4K PAGE_SIZE, page_pool fragment
allocation in the RX refill path can cause 15-20% throughput
regression under high connection counts (>16 TCP streams).

Add an ethtool private flag "full-page-rx" that allows the user to
force one RX buffer per page, bypassing the page_pool fragment path.
This restores line-rate (180+ Gbps) performance on affected platforms.

Usage:
  ethtool --set-priv-flags eth0 full-page-rx on

There is no behavioral change by default. The flag must be explicitly
enabled by the user or udev rule.

The existing single-buffer-per-page logic for XDP and jumbo frames is
consolidated into a new helper mana_use_single_rxbuf_per_page() which
is now the single decision point for both the automatic and
user-controlled paths.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 22 ++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 94 +++++++++++++++++++
 include/net/mana/mana.h                       |  8 ++
 3 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 89e7f59f635d..d859c2eae0a5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -755,6 +755,25 @@ static void *mana_get_rxbuf_pre(struct mana_rxq *rxq, dma_addr_t *da)
 	return va;
 }
 
+static bool
+mana_use_single_rxbuf_per_page(struct mana_port_context *apc, u32 mtu)
+{
+	/* On some platforms with 4K PAGE_SIZE, page_pool fragment allocation
+	 * in the RX refill path (~2kB buffer) can cause significant throughput
+	 * regression under high connection counts. Allow user to force one RX
+	 * buffer per page via ethtool private flag to bypass the fragment
+	 * path.
+	 */
+	if (apc->priv_flags & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF))
+		return true;
+
+	/* For xdp and jumbo frames make sure only one packet fits per page. */
+	if (mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 || mana_xdp_get(apc))
+		return true;
+
+	return false;
+}
+
 /* Get RX buffer's data size, alloc size, XDP headroom based on MTU */
 static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 			       int mtu, u32 *datasize, u32 *alloc_size,
@@ -765,8 +784,7 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 	/* Calculate datasize first (consistent across all cases) */
 	*datasize = mtu + ETH_HLEN;
 
-	/* For xdp and jumbo frames make sure only one packet fits per page */
-	if (mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 || mana_xdp_get(apc)) {
+	if (mana_use_single_rxbuf_per_page(apc, mtu)) {
 		if (mana_xdp_get(apc)) {
 			*headroom = XDP_PACKET_HEADROOM;
 			*alloc_size = PAGE_SIZE;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 482cd16009ab..7e441d6ae5dc 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -133,6 +133,10 @@ static const struct mana_stats_desc mana_phy_stats[] = {
 	{ "hc_tc7_tx_pause_phy", offsetof(struct mana_ethtool_phy_stats, tx_pause_tc7_phy) },
 };
 
+static const char mana_priv_flags[MANA_PRIV_FLAG_MAX][ETH_GSTRING_LEN] = {
+	[MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF] = "full-page-rx"
+};
+
 static int mana_get_sset_count(struct net_device *ndev, int stringset)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -144,6 +148,10 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 		       ARRAY_SIZE(mana_phy_stats) +
 		       ARRAY_SIZE(mana_hc_stats)  +
 		       num_queues * (MANA_STATS_RX_COUNT + MANA_STATS_TX_COUNT);
+
+	case ETH_SS_PRIV_FLAGS:
+		return MANA_PRIV_FLAG_MAX;
+
 	default:
 		return -EINVAL;
 	}
@@ -192,6 +200,14 @@ static void mana_get_strings_stats(struct mana_port_context *apc, u8 **data)
 	}
 }
 
+static void mana_get_strings_priv_flags(u8 **data)
+{
+	int i;
+
+	for (i = 0; i < MANA_PRIV_FLAG_MAX; i++)
+		ethtool_puts(data, mana_priv_flags[i]);
+}
+
 static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
@@ -200,6 +216,9 @@ static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 	case ETH_SS_STATS:
 		mana_get_strings_stats(apc, &data);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		mana_get_strings_priv_flags(&data);
+		break;
 	default:
 		break;
 	}
@@ -756,6 +775,78 @@ static int mana_get_link_ksettings(struct net_device *ndev,
 	return 0;
 }
 
+static u32 mana_get_priv_flags(struct net_device *ndev)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+
+	return apc->priv_flags;
+}
+
+static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+	u32 changed = apc->priv_flags ^ priv_flags;
+	u32 old_priv_flags = apc->priv_flags;
+	int err = 0;
+
+	if (!changed)
+		return 0;
+
+	/* Reject unknown bits */
+	if (priv_flags & ~GENMASK(MANA_PRIV_FLAG_MAX - 1, 0))
+		return -EINVAL;
+
+	apc->priv_flags = priv_flags;
+
+	if (changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) {
+		if (!apc->port_is_up)
+			return 0;
+
+		/* If XDP is attached or MTU is jumbo, single-buffer-per-page
+		 * is already forced regardless of this flag. Skip the
+		 * expensive detach/attach cycle since nothing changes.
+		 */
+		if (ndev->mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 ||
+		    mana_xdp_get(apc))
+			return 0;
+
+		/* Block RDMA from grabbing the vport during detach/attach */
+		mutex_lock(&apc->vport_mutex);
+		apc->channel_changing = true;
+		mutex_unlock(&apc->vport_mutex);
+
+		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
+		if (err) {
+			netdev_err(ndev,
+				   "Insufficient memory for new allocations\n");
+			apc->priv_flags = old_priv_flags;
+			goto clear_flag;
+		}
+
+		err = mana_detach(ndev, false);
+		if (err) {
+			netdev_err(ndev, "mana_detach failed: %d\n", err);
+			apc->priv_flags = old_priv_flags;
+			goto out;
+		}
+
+		err = mana_attach(ndev);
+		if (err) {
+			netdev_err(ndev, "mana_attach failed: %d\n", err);
+			apc->priv_flags = old_priv_flags;
+		}
+	}
+
+out:
+	mana_pre_dealloc_rxbufs(apc);
+clear_flag:
+	mutex_lock(&apc->vport_mutex);
+	apc->channel_changing = false;
+	mutex_unlock(&apc->vport_mutex);
+
+	return err;
+}
+
 const struct ethtool_ops mana_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_CQE_FRAMES |
 				     ETHTOOL_COALESCE_RX_USECS |
@@ -766,6 +857,7 @@ const struct ethtool_ops mana_ethtool_ops = {
 				     ETHTOOL_COALESCE_USE_ADAPTIVE_TX,
 	.op_needs_rtnl		= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 				  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
+				  ETHTOOL_OP_NEEDS_RTNL_SPFLAGS |
 				  ETHTOOL_OP_NEEDS_RTNL_GLINK,
 	.get_ethtool_stats	= mana_get_ethtool_stats,
 	.get_sset_count		= mana_get_sset_count,
@@ -783,4 +875,6 @@ const struct ethtool_ops mana_ethtool_ops = {
 	.set_ringparam          = mana_set_ringparam,
 	.get_link_ksettings	= mana_get_link_ksettings,
 	.get_link		= ethtool_op_get_link,
+	.get_priv_flags		= mana_get_priv_flags,
+	.set_priv_flags		= mana_set_priv_flags,
 };
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 226b61504596..768d9f9bf167 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -31,6 +31,12 @@ enum TRI_STATE {
 	TRI_STATE_TRUE = 1
 };
 
+/* MANA ethtool private flag bit positions */
+enum mana_priv_flag_bits {
+	MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF = 0,
+	MANA_PRIV_FLAG_MAX,
+};
+
 /* Number of entries for hardware indirection table must be in power of 2 */
 #define MANA_INDIRECT_TABLE_MAX_SIZE 512
 #define MANA_INDIRECT_TABLE_DEF_SIZE 64
@@ -565,6 +571,8 @@ struct mana_port_context {
 	u32 rxbpre_headroom;
 	u32 rxbpre_frag_count;
 
+	u32 priv_flags;
+
 	struct bpf_prog *bpf_prog;
 
 	/* Create num_queues EQs, SQs, SQ-CQs, RQs and RQ-CQs, respectively. */
-- 
2.43.0

