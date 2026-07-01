Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A28339B41;
	Wed,  1 Jul 2026 14:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915519; cv=none; b=AR+wo6GTStoARbdpOAcxYPk/A10Pumng/GIH4gKJmg83pV7sWFiVr6AYtdDchD8rFHqEO+EXMl7Zql25uwc1MXmKOjGQRtruQhsiAR0cL2ZxRSTtjaoyBxCKrO/uIbGpkJOVGWhmmEiwjc8Inozq28IEMrR5TdNL7TIyQcEtnC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915519; c=relaxed/simple;
	bh=HtfWR/AsjNBfzPAOF9cs3tFznMgu/13TG68jyAPu2aA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITnEFMLgtPLXMlwt7CSCnz8SO2P85Vo+IKu/P7O89YjwsXfzvSfBdEvzxtmxwQDE/WfkV7TYroq4XVTv0u3yme7pdMxglzpN/mSNcnWYGTYeCrrWtdCG3copl5aKwtadQqv5tatg1kff16V3Um+f08mAvt1P6KbLHP7KkeEkEyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CsHCq/qN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CsHCq/qN"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8885D20B7167;
	Wed,  1 Jul 2026 07:18:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8885D20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782915516;
	bh=zZywVkShZZzwufYPKW1iD4QtulQDcTGDl6pLltC0KuM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CsHCq/qN1vens0zQZR3Vc0OfxYl3teenZos1P3HCCqZANoWT3FIYxA1CLQIDr31q8
	 M/FlVQi4bhTaQhogod0VqG9jw+cHohPx89r3IhGAsskGPwrEyMbOj3JmuOmN8RnEzq
	 32Cv43cyPIGPN2Ag7eOXjEM+zMX1NFFOI0g0I050=
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
	yury.norov@gmail.com,
	pavan.chebbi@broadcom.com
Subject: [PATCH net-next v11 1/2] net: mana: refactor mana_get_strings() and mana_get_sset_count() to use switch
Date: Wed,  1 Jul 2026 07:15:45 -0700
Message-ID: <20260701141808.461554-2-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260701141808.461554-1-dipayanroy@linux.microsoft.com>
References: <20260701141808.461554-1-dipayanroy@linux.microsoft.com>
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

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 75 ++++++++++++-------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 94e658d07a27..fa9c49592828 100644
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

