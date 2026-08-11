Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092C13F9263;
	Tue, 11 Aug 2026 06:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430171; cv=none; b=hLg4unwqMWyJFgC21DrVAgUCOFAiBoHqqIrybSjzhGhTapuRoqQm6JTBsxgD1Nitja3gXq4KqVwk3ypnOXeixQbVCNEd5hIB5i6a8nPY77Qn+gNhmIW8nnxO+8WjoF4STmlCkSg1VTgK1ilJ93QqK09kl9iN6JETFJjK9jk4gbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430171; c=relaxed/simple;
	bh=ItMMRrATtMbI4KzMRreCT2bDzclprvPMsKsGGsgXYP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmLuEQIKcfe95hCEDRNmHC69/hYDiY4pD+dRy2qpjRyc4JtUn+kMvwRBr/I8J3hQDUsTuCR3fHVJLVxUJI2AvJm82WWnZ9mczTL9ezSlAyZFsFSy3t6GndZ67L0gPgoqMmxh6ZUJ89P7M39kbqi7yalQYP+X1X37hJrA3VE6A8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1202)
	id A1BBE20B7007; Mon, 10 Aug 2026 23:35:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A1BBE20B7007
From: Long Li <longli@microsoft.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	shradhagupta@linux.microsoft.com,
	Simon Horman <horms@kernel.org>,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 11/13] net: mana: keep a user-configured RSS table across a queue rebuild
Date: Mon, 10 Aug 2026 23:35:28 -0700
Message-ID: <20260811063530.2428424-3-longli@microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260811063530.2428424-1-longli@microsoft.com>
References: <20260811063530.2428424-1-longli@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mana_rss_table_init() overwrites the indirection table with the driver
default every time the queues are rebuilt. Both rebuild paths do it:
mana_alloc_qset() for the ethtool/MTU/XDP queue-set swap, and
mana_alloc_queues() for ndo_open and for the TX-timeout reset.

A table the user installed with "ethtool -X" is therefore lost by
operations that have nothing to do with RSS. Resizing the rings, changing
the MTU, toggling a private flag, attaching an XDP program, or simply
taking the port down and up again all silently reset the steering:

  # ethtool -X ens1 equal 1        # everything to queue 0
  # ethtool -G ens1 rx 1024
  # ethtool -x ens1                # back to 0..15, silently

The entries are queue indices, so they stay meaningful as long as the
queue count does not change, and mana_config_rss() already maps them onto
whichever RX objects the new set has. Carry the table over instead of
regenerating it.

Only a user-configured table is preserved, which netif_is_rxfh_configured()
reports: a driver-generated table must still be rebuilt so that it spreads
over all the queues of the new set. ethtool_check_max_channel() refuses a
channel-count reduction that would leave a user table pointing past the
last queue, so the entries are in range by construction; the bounds check
is a safety net for the rebuild paths that do not come from ethtool, and
reports the table as lost rather than steering to a queue that is gone.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 50 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 0d87440fbfbee7ac5729945d101eaa0c37745fbe..4cab3f658f2487671d26243d4e91f834580b3c5c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3545,6 +3545,38 @@ static void mana_rss_table_init(struct mana_port_context *apc)
 			ethtool_rxfh_indir_default(i, apc->num_queues);
 }
 
+/* Decide whether @apc's indirection table can be carried over to a queue set
+ * with @num_queues queues, instead of being rebuilt from the driver default.
+ *
+ * Only a table the user installed with "ethtool -X" is worth preserving: a
+ * driver-generated one has to be rebuilt so that it spreads over all the
+ * queues the new set actually has.
+ *
+ * ethtool_check_max_channel() already refuses a channel-count reduction that
+ * would leave a user-configured table pointing past the last queue, so the
+ * bounds check below is only a safety net for the rebuild paths that do not
+ * originate from ethtool. If it ever trips, the table cannot be honoured for
+ * the new queue count, so tell the core the user's table is gone rather than
+ * silently steering to queues that no longer exist.
+ */
+static bool mana_rss_table_keep(struct mana_port_context *apc,
+				unsigned int num_queues)
+{
+	u32 i;
+
+	if (!netif_is_rxfh_configured(apc->ndev))
+		return false;
+
+	for (i = 0; i < apc->indir_table_sz; i++) {
+		if (apc->indir_table[i] >= num_queues) {
+			ethtool_rxfh_indir_lost(apc->ndev);
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
@@ -3860,7 +3892,12 @@ int mana_alloc_queues(struct net_device *ndev)
 		goto destroy_rxq;
 	}
 
-	mana_rss_table_init(apc);
+	/* Keep a user-configured RSS table across a rebuild; the entries are
+	 * queue indices, so they stay meaningful as long as the queue count
+	 * is unchanged. Only a driver-generated table is regenerated here.
+	 */
+	if (!mana_rss_table_keep(apc, apc->num_queues))
+		mana_rss_table_init(apc);
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
 	if (err) {
@@ -4317,7 +4354,16 @@ int mana_alloc_qset(struct mana_port_context *apc,
 	if (err)
 		goto cleanup_rxq;
 
-	mana_rss_table_init(scratch);
+	/* Carry a user-configured RSS table over to the new set. The entries
+	 * are queue indices, so mana_config_rss() in mana_publish_qset() maps
+	 * them onto the new set's RX objects. A driver-generated table is
+	 * rebuilt instead, so it covers every queue of the new set.
+	 */
+	if (mana_rss_table_keep(apc, num_queues))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
 
 	mana_qset_snapshot(scratch, out);
 	return 0;
-- 
2.43.0

