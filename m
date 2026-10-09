Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64EF84EC648;
	Fri,  9 Oct 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556917; cv=none; b=J03nK/sN8WXL0+Lg10GAczHxQ7gE/AuAZEXR8qOhcfJZUtPCSBtCrM6jvbE3AOb9v1RLhpb0UzcftONOcqfaBFfzWJuWX4S4haU/1oyS/4G4aqFjq6Jkp+/eZ2sflK/8FfM06b7x29x+1evK5hkU5tScS52g0dVRsDwGxXPayWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556917; c=relaxed/simple;
	bh=QUiFC7rcemyKYdV1iCB/mWiSZ26aRyV96U2si69nZwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp6QGbk33BF00x9CtPA+07C6xJMjNGBomY9OLWiQ0TvHXZio5gqz5FuQtGg5Cpq3tsxhlQQNOaKA0vbV7QKe8TwFvIzrEasm/JayTFeg0y0o97Zj1i/pE+AaHw3n9ygO7rg+UTfMf4rkgb9WqhsmlaxN6+3DlmB12M34v2I84Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=JbSJnX6A; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="JbSJnX6A"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id EC72E20B716B;
	Fri,  9 Oct 2026 07:41:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC72E20B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556915;
	bh=OqUmduQCxnR2iaI4Vd0eZfeeNmtpA4pzhT5I+RqLk08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbSJnX6AP2FMzVzKtuJxZbIk9eYZFyOTurOyL9jnOq0JWtpnvk7Bgil+q5C1ef+g5
	 O7siQQwpm7TdXmWfr2FltUcNM5uzVAdTEqFoWgekDFkMUwyDqHoW97/nc5ukek+DDW
	 bNcg7KJgs73RgvI1/ft//DWuByJFHJJwm9lM4LWk=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com
Subject: [PATCH net-next v6 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Fri,  9 Oct 2026 14:41:22 +0000
Message-ID: <c55b41e6ee099a5c49d68a167b91b0810435c291.1790795005.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>

Preserve a user RSS table whenever all entries fit the requested queue
count. Regenerate driver defaults. On growth, a retained user table does
not steer RSS traffic to the added queues until the user updates it.

Report table loss only after successful queue-set publication. The
non-swap allocation path still replaces invalid tables silently because
its callers do not consistently hold the notification's netdev lock.

Require RTNL for RSS setters to serialize them with reset/resume rebuilds.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 41 +++++++++++++++++--
 .../ethernet/microsoft/mana/mana_ethtool.c    |  3 +-
 include/net/mana/mana.h                       |  2 +
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 86a09828b5f4..5619c6a763c2 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3595,6 +3595,27 @@ static void mana_rss_table_init(struct mana_port_context *apc)
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+/* Keep user tables with valid indices; defer loss notification. */
+static bool mana_rss_table_keep(struct mana_port_context *apc,
+				unsigned int num_queues, bool *lost)
+{
+	u32 i;
+
+	*lost = false;
+
+	if (!netif_is_rxfh_configured(apc->ndev))
+		return false;
+
+	for (i = 0; i < apc->indir_table_sz; i++) {
+		if (apc->indir_table[i] >= num_queues) {
+			*lost = true;
+			return false;
+		}
+	}
+
+	return true;
+}
+
 int mana_disable_vport_rx(struct mana_port_context *apc)
 {
 	return mana_cfg_vport_steering(apc, TRI_STATE_FALSE, false, false,
@@ -3865,6 +3886,7 @@ int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	struct gdma_dev *gd = apc->ac->gdma_dev;
+	bool indir_lost;
 	int err;
 
 	err = mana_create_vport(apc, ndev);
@@ -3910,7 +3932,9 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_rxq;
 	}
 
-	mana_rss_table_init(apc);
+	/* Loss notification needs a netdev instance lock we may lack. */
+	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost))
+		mana_rss_table_init(apc);
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
 	if (err) {
@@ -4069,9 +4093,10 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
 	out->priv_flags		= ctx->priv_flags;
 	out->mtu		= ctx->configured_mtu;
 	out->bpf_prog		= ctx->bpf_prog;
+
+	out->rxfh_indir_lost	= false;
 }
 
-/* Vport identity and port debugfs outlive queue sets. */
 static void mana_qset_install(struct mana_port_context *ctx,
 			      const struct mana_qset *qset)
 {
@@ -4131,6 +4156,7 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_qset *out)
 {
 	struct net_device *ndev = scratch->ndev;
+	bool indir_lost;
 	int err;
 
 	ASSERT_RTNL();
@@ -4166,9 +4192,14 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq;
 
-	mana_rss_table_init(scratch);
+	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
 
 	mana_qset_snapshot(scratch, out);
+	out->rxfh_indir_lost = indir_lost;
 	return 0;
 
 cleanup_rxq:
@@ -4407,6 +4438,10 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	WRITE_ONCE(apc->port_is_up, true);
 	mana_start_txqs(apc);
 
+	/* Report a lost user table only after successful publication. */
+	if (newq->rxfh_indir_lost)
+		ethtool_rxfh_indir_lost(ndev);
+
 	return 0;
 
 rollback:
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 611521d2d6d1..a53e19b15bae 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -953,7 +953,8 @@ const struct ethtool_ops mana_ethtool_ops = {
 	.op_needs_rtnl		= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
 				  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
 				  ETHTOOL_OP_NEEDS_RTNL_SPFLAGS |
-				  ETHTOOL_OP_NEEDS_RTNL_GLINK,
+				  ETHTOOL_OP_NEEDS_RTNL_GLINK |
+				  ETHTOOL_OP_NEEDS_RTNL_RSS,
 	.get_ethtool_stats	= mana_get_ethtool_stats,
 	.get_sset_count		= mana_get_sset_count,
 	.get_strings		= mana_get_strings,
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 5f9461bc16e9..9dad03150d1b 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -709,6 +709,8 @@ struct mana_qset {
 	int			mtu;
 	struct bpf_prog		*bpf_prog;
 
+	/* Notify the core only after this set is published. */
+	bool			rxfh_indir_lost;
 };
 
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
