Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1CB2D9484;
	Sat, 11 Jul 2026 04:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783743285; cv=none; b=WQX7Qnu7/CHDfZjkfQWxkCqhUBr9gT8wpiEsldwXziytO1gnzP5i3qYQpHewcW0US1saAKSwqXj6QNpyBLSaqRFAkaZIT+iarB6GxU3cgGT4bTDFV2QX0Tz/wUeHeLIdcGAL6XQIKYlq8EfBbc1XJKd/f1gZ050shg4f5ImDvYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783743285; c=relaxed/simple;
	bh=GI4xE8tLcJ3I5eTnTFZUtvazG4zrp4dA7vaT/I8J+R0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amvV1rvQIIZyuaekvYd7KJGErloviRcnShOwsaC5JZo9MnmCb7A1SfRud13jqzWecFZdKpBHLqem0gbRauRCOrjv93TUubE/sXfOT7yxqx8TiQZGKrexqVLp76YVhJiiuktNk/oH6xjnpp9eLLRdYdzufynDktRZv6aWTjj6EkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bxGnGysD; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bxGnGysD"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 842F120B7171;
	Fri, 10 Jul 2026 21:14:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 842F120B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783743274;
	bh=pUTgPHbBLdDpOumpYw+qKCD/KZRKukRKQBAkcVeS4C8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bxGnGysDK4Lbc3yD+AqAKLAPTiHQOYBywtg/IOt18hqW1+7GCJyd+Qzfg9bb8VLiC
	 wohnPPSIJQUz2WA0SOyd+me9KOybVla2JdBg3vQdyCL97XFXWRNmQoPDfJsK0yomB7
	 0YjroI9WJ9FbZdAymPDdEseGmmGQd+fyODMpb85Y=
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
	pavan.chebbi@broadcom.com,
	schakrabarti@linux.microsoft.com,
	gargaditya@linux.microsoft.com
Subject: [PATCH net-next v12 4/4] net: mana: recover port on attach failure in ethtool operations
Date: Fri, 10 Jul 2026 21:10:24 -0700
Message-ID: <20260711041415.3008868-5-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
References: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mana_attach() fails during ethtool ring size or channel count
changes, the port is left in a broken state with no recovery
mechanism, requiring manual intervention to bring the port back up.

On VM SKUs without a netvsc fallback interface, this results in
complete loss of network connectivity to the VM.

Fix by scheduling queue_reset_work when mana_attach() fails. The
preceding patch ensures mana_detach() always completes its full
teardown (netif_device_detach + cleanup), so the reset handler's
mana_detach() takes the "already detached" early return, preserving
port_st_save for a successful mana_attach() recovery.

When mana_attach() fails, choose retry values that maximize recovery
chances: if the operation was an increase, fall back to the previous
working values; if it was a decrease but still above default, fall
back to defaults; otherwise use the minimum supported values.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Tested-by: Aditya Garg <gargaditya@linux.microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 48 +++++++++++++++++--
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index f77509818d07..71e69d5a9a04 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -646,6 +646,7 @@ static int mana_set_channels(struct net_device *ndev,
 	struct mana_port_context *apc = netdev_priv(ndev);
 	unsigned int new_count = channels->combined_count;
 	unsigned int old_count = apc->num_queues;
+	bool schedule_port_reset = false;
 	int err;
 
 	/* Set channel_changing to block RDMA from grabbing the vport
@@ -675,8 +676,19 @@ static int mana_set_channels(struct net_device *ndev,
 	apc->num_queues = new_count;
 	err = mana_attach(ndev);
 	if (err) {
-		apc->num_queues = old_count;
 		netdev_err(ndev, "mana_attach failed: %d\n", err);
+
+		/* Choose a retry queue count that maximizes recovery
+		 * chances in the reset work handler.
+		 */
+		if (old_count < new_count)
+			apc->num_queues = old_count;
+		else if (new_count > MANA_DEF_NUM_QUEUES)
+			apc->num_queues = MANA_DEF_NUM_QUEUES;
+		else
+			apc->num_queues = 1;
+
+		schedule_port_reset = true;
 	}
 
 out:
@@ -685,6 +697,11 @@ static int mana_set_channels(struct net_device *ndev,
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
 	mutex_unlock(&apc->vport_mutex);
+
+	if (schedule_port_reset)
+		queue_work(apc->ac->per_port_queue_reset_wq,
+			   &apc->queue_reset_work);
+
 	return err;
 }
 
@@ -707,6 +724,7 @@ static int mana_set_ringparam(struct net_device *ndev,
 			      struct netlink_ext_ack *extack)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
+	bool schedule_port_reset = false;
 	u32 new_tx, new_rx;
 	u32 old_tx, old_rx;
 	int err;
@@ -752,11 +770,35 @@ static int mana_set_ringparam(struct net_device *ndev,
 	err = mana_attach(ndev);
 	if (err) {
 		netdev_err(ndev, "mana_attach failed: %d\n", err);
-		apc->tx_queue_size = old_tx;
-		apc->rx_queue_size = old_rx;
+		NL_SET_ERR_MSG_FMT(extack, "failed to change ring params: %d",
+				   err);
+
+		/* Choose retry ring sizes that maximize recovery
+		 * chances in the reset work handler. Handle RX and
+		 * TX independently.
+		 */
+		if (old_rx < new_rx)
+			apc->rx_queue_size = old_rx;
+		else if (new_rx > DEF_RX_BUFFERS_PER_QUEUE)
+			apc->rx_queue_size = DEF_RX_BUFFERS_PER_QUEUE;
+		else
+			apc->rx_queue_size = MIN_RX_BUFFERS_PER_QUEUE;
+
+		if (old_tx < new_tx)
+			apc->tx_queue_size = old_tx;
+		else if (new_tx > DEF_TX_BUFFERS_PER_QUEUE)
+			apc->tx_queue_size = DEF_TX_BUFFERS_PER_QUEUE;
+		else
+			apc->tx_queue_size = MIN_TX_BUFFERS_PER_QUEUE;
+
+		schedule_port_reset = true;
 	}
 out:
 	mana_pre_dealloc_rxbufs(apc);
+
+	if (schedule_port_reset)
+		queue_work(apc->ac->per_port_queue_reset_wq,
+			   &apc->queue_reset_work);
 	return err;
 }
 
-- 
2.43.0

