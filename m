Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE712F2918;
	Wed,  6 May 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778086860; cv=none; b=sMQ27CT4In6RSgpHcmW5ttmWtf5tUchQNoIzr5rLTF42FfvWyz2ZVif/nTJkdEUImqWhle5T65UyRZn9IPVpA8zirNRvBODsL1uWn4TIuZMqtmN4Su1H+JP/6gaVUWPtWXeac8sB7IDpgGZ1ATag9wKFgOw2s4ScXuP16dhfQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778086860; c=relaxed/simple;
	bh=nZ3PEPjXz02eJX/JIhSD3+m5eowdY0WI6laAM8b2o0M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKyHF08o86LxroasRmsMnj2Q/UrelVXl4orbNEthqyA290qEnvyRw87QkfB2Ncn5US0IrQJemT3pRau3w43RrqueuKtOZe+MIBTYdaXwEDZR6esuROFdw64TCr8shmnx1ynhKKxXLmw8YqYmxJJjzz2akrqO4FdJoJbRrKvv8tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=H7xZSFmq; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="H7xZSFmq"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 93D8B20B7168;
	Wed,  6 May 2026 10:00:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 93D8B20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778086855;
	bh=hmet5ykTD8e2tDq18DPjT6PHgc+wVdVqYFqMb8f4RmM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H7xZSFmq3sAlJ2hii2EEZRpwMqa2Uok4YxJ84CzG2sMu3gMrbqQHcifuuvdfQKlyC
	 joHym2krBgXcV156tmusxbDwP/aGOFnDSDfo3DiRLYPyybbC6QDBDvsmIOjCeNYyqY
	 njhAv7h8Ct3iPpTi4W/AQjhzms7sLGZBrCPsQb/k=
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
	shirazsaleem@microsoft.com,
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
	yury.norov@gmail.com
Subject: [PATCH net-next v7 1/2] net: mana: refactor mana_get_strings() and mana_get_sset_count() to use switch
Date: Wed,  6 May 2026 09:58:57 -0700
Message-ID: <20260506170034.327907-2-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260506170034.327907-1-dipayanroy@linux.microsoft.com>
References: <20260506170034.327907-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor mana_get_strings() and mana_get_sset_count() from if/else to
switch statements in preparation for adding ethtool private flags
support which requires handling ETH_SS_PRIV_FLAGS.

No functional change.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 75 ++++++++++++-------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 6a4b42fe0944..a28ca461c135 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -138,53 +138,70 @@ static int mana_get_sset_count(struct net_device *ndev, int stringset)
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int num_queues = apc->num_queues;
 
-	if (stringset != ETH_SS_STATS)
+	switch (stringset) {
+	case ETH_SS_STATS:
+		return ARRAY_SIZE(mana_eth_stats) +
+		       ARRAY_SIZE(mana_phy_stats) +
+		       ARRAY_SIZE(mana_hc_stats)  +
+		       num_queues * (MANA_STATS_RX_COUNT + MANA_STATS_TX_COUNT);
+	default:
 		return -EINVAL;
-
-	return ARRAY_SIZE(mana_eth_stats) + ARRAY_SIZE(mana_phy_stats) + ARRAY_SIZE(mana_hc_stats) +
-			num_queues * (MANA_STATS_RX_COUNT + MANA_STATS_TX_COUNT);
+	}
 }
 
-static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+static void mana_get_strings_stats(struct mana_port_context *apc, u8 **data)
 {
-	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int num_queues = apc->num_queues;
 	int i, j;
 
-	if (stringset != ETH_SS_STATS)
-		return;
 	for (i = 0; i < ARRAY_SIZE(mana_eth_stats); i++)
-		ethtool_puts(&data, mana_eth_stats[i].name);
+		ethtool_puts(data, mana_eth_stats[i].name);
 
 	for (i = 0; i < ARRAY_SIZE(mana_hc_stats); i++)
-		ethtool_puts(&data, mana_hc_stats[i].name);
+		ethtool_puts(data, mana_hc_stats[i].name);
 
 	for (i = 0; i < ARRAY_SIZE(mana_phy_stats); i++)
-		ethtool_puts(&data, mana_phy_stats[i].name);
+		ethtool_puts(data, mana_phy_stats[i].name);
 
 	for (i = 0; i < num_queues; i++) {
-		ethtool_sprintf(&data, "rx_%d_packets", i);
-		ethtool_sprintf(&data, "rx_%d_bytes", i);
-		ethtool_sprintf(&data, "rx_%d_xdp_drop", i);
-		ethtool_sprintf(&data, "rx_%d_xdp_tx", i);
-		ethtool_sprintf(&data, "rx_%d_xdp_redirect", i);
-		ethtool_sprintf(&data, "rx_%d_pkt_len0_err", i);
+		ethtool_sprintf(data, "rx_%d_packets", i);
+		ethtool_sprintf(data, "rx_%d_bytes", i);
+		ethtool_sprintf(data, "rx_%d_xdp_drop", i);
+		ethtool_sprintf(data, "rx_%d_xdp_tx", i);
+		ethtool_sprintf(data, "rx_%d_xdp_redirect", i);
+		ethtool_sprintf(data, "rx_%d_pkt_len0_err", i);
 		for (j = 0; j < MANA_RXCOMP_OOB_NUM_PPI - 1; j++)
-			ethtool_sprintf(&data, "rx_%d_coalesced_cqe_%d", i, j + 2);
+			ethtool_sprintf(data,
+					"rx_%d_coalesced_cqe_%d",
+					i,
+					j + 2);
 	}
 
 	for (i = 0; i < num_queues; i++) {
-		ethtool_sprintf(&data, "tx_%d_packets", i);
-		ethtool_sprintf(&data, "tx_%d_bytes", i);
-		ethtool_sprintf(&data, "tx_%d_xdp_xmit", i);
-		ethtool_sprintf(&data, "tx_%d_tso_packets", i);
-		ethtool_sprintf(&data, "tx_%d_tso_bytes", i);
-		ethtool_sprintf(&data, "tx_%d_tso_inner_packets", i);
-		ethtool_sprintf(&data, "tx_%d_tso_inner_bytes", i);
-		ethtool_sprintf(&data, "tx_%d_long_pkt_fmt", i);
-		ethtool_sprintf(&data, "tx_%d_short_pkt_fmt", i);
-		ethtool_sprintf(&data, "tx_%d_csum_partial", i);
-		ethtool_sprintf(&data, "tx_%d_mana_map_err", i);
+		ethtool_sprintf(data, "tx_%d_packets", i);
+		ethtool_sprintf(data, "tx_%d_bytes", i);
+		ethtool_sprintf(data, "tx_%d_xdp_xmit", i);
+		ethtool_sprintf(data, "tx_%d_tso_packets", i);
+		ethtool_sprintf(data, "tx_%d_tso_bytes", i);
+		ethtool_sprintf(data, "tx_%d_tso_inner_packets", i);
+		ethtool_sprintf(data, "tx_%d_tso_inner_bytes", i);
+		ethtool_sprintf(data, "tx_%d_long_pkt_fmt", i);
+		ethtool_sprintf(data, "tx_%d_short_pkt_fmt", i);
+		ethtool_sprintf(data, "tx_%d_csum_partial", i);
+		ethtool_sprintf(data, "tx_%d_mana_map_err", i);
+	}
+}
+
+static void mana_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	struct mana_port_context *apc = netdev_priv(ndev);
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		mana_get_strings_stats(apc, &data);
+		break;
+	default:
+		break;
 	}
 }
 
-- 
2.43.0

