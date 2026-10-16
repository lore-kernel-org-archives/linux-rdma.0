Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C88509F06;
	Fri, 16 Oct 2026 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165152; cv=none; b=frf2sdROmVQ2fyodMcXIvB6/Lwx+5uFpHayetPEzI1hgr/xZzhdD0Ww1cJFSo8HnX++YdkUsxjiv7TbiTrKA6dpolgFk9KVmDZwSLk3PBr0RyUast6d311CbzeI3nrym8p3Ak08/TV7G9/qoJ+0K/Zn+6STK0EL2s4d5uVMC5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165152; c=relaxed/simple;
	bh=SOV1VksnCtbwQW1AC9E8T7/u0UEmh4M6Wh7xPNtVNAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpgJ2hUyMbOlKka/ghlPpEJjecz0p6bMHyLnHzbZ5lqgamrduRsdulqIXiNf4wnNZrYu8YqAp3+RUE3AbNnFgHXiaqPg7V7Sqsi+OvWgqKlEs2wN1skT9cYpk05xJW+y42g6nX4rQcW0/ELWqgyTSGx2M2eee0BR1ZVvCSIz4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bOiT1T06; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bOiT1T06"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id E13FE20B7171;
	Fri, 16 Oct 2026 08:39:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E13FE20B7171
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792165145;
	bh=HNeo7+L/c5I8oStJUkk0vd1GW2EWcDGmNQrIkoMB8hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOiT1T06wGBmgBXybFLYevIWhAwNKdtq4Cx1aAGMP/E9km4pVZ9S7U0c/T9lr/vL0
	 Yun4/Rw86BIWFrFT5LR8/I0V89dezG22TPnwT1sRw0wIdkXo9AO3RpW4etmwNhXo7i
	 nDs4cthlPeIkyGsazAWuARNsmnw92nh4OVKtTHFk=
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
	bpf@vger.kernel.org,
	sdf@fomichev.me,
	daniel@iogearbox.net,
	hawk@kernel.org,
	ast@kernel.org,
	john.fastabend@gmail.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: [PATCH net-next v7 09/13] net: mana: do not bail out of mana_detach on dealloc failure
Date: Fri, 16 Oct 2026 15:38:42 +0000
Message-ID: <743b6f30faf788fcbf663ba6bde90fbfc51ad0e8.1791710735.git.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

Remove the early return after mana_dealloc_queues() so detach continues
its device and port-context cleanup.

The return is currently unreachable: mana_dealloc_queues() only rejects
an up port, and mana_detach() clears port_is_up before calling it. This
is a robustness cleanup, not a fix for a reachable reset failure.

Make mana_detach() return void and remove the now-unreachable
error branches from reset and removal callers. Keep ndo_stop's
required integer return and the internal deallocation error log.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 27 ++++++-------------
 include/net/mana/mana.h                       |  2 +-
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 9e952843de14..80f16c96f16c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -114,7 +114,9 @@ static int mana_close(struct net_device *ndev)
 	if (!apc->port_is_up)
 		return 0;
 
-	return mana_detach(ndev, true);
+	mana_detach(ndev, true);
+
+	return 0;
 }
 
 static void mana_link_state_handle(struct work_struct *w)
@@ -345,17 +347,12 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
 		goto clear_flag;
 	}
 
-	err = mana_detach(ndev, false);
-	if (err) {
-		netdev_err(ndev, "mana_detach failed: %d\n", err);
-		goto dealloc_pre_rxbufs;
-	}
+	mana_detach(ndev, false);
 
 	err = mana_attach(ndev);
 	if (err)
 		netdev_err(ndev, "mana_attach failed: %d\n", err);
 
-dealloc_pre_rxbufs:
 	mana_pre_dealloc_rxbufs(apc);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
@@ -4542,7 +4539,7 @@ void mana_free_qset(struct mana_port_context *scratch, struct mana_qset *qset)
 	mana_qset_debugfs_publish(apc);
 }
 
-int mana_detach(struct net_device *ndev, bool from_close)
+void mana_detach(struct net_device *ndev, bool from_close)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	int err;
@@ -4553,7 +4550,7 @@ int mana_detach(struct net_device *ndev, bool from_close)
 	 * previously). Now skip mana detach and just retry mana_attach.
 	 */
 	if (!from_close && !netif_device_present(ndev))
-		return 0;
+		return;
 
 	apc->port_st_save = apc->port_is_up;
 	apc->port_is_up = false;
@@ -4565,18 +4562,14 @@ int mana_detach(struct net_device *ndev, bool from_close)
 
 	if (apc->port_st_save) {
 		err = mana_dealloc_queues(ndev);
-		if (err) {
+		if (err)
 			netdev_err(ndev, "%s failed to deallocate queues: %d\n", __func__, err);
-			return err;
-		}
 	}
 
 	if (!from_close) {
 		netif_device_detach(ndev);
 		mana_cleanup_port_context(apc);
 	}
-
-	return 0;
 }
 
 static int mana_probe_port(struct mana_context *ac, int port_idx,
@@ -4988,7 +4981,6 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	struct mana_port_context *apc;
 	struct device *dev;
 	struct net_device *ndev;
-	int err;
 	int i;
 
 	if (!gc || !ac)
@@ -5019,10 +5011,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 		 */
 		rtnl_lock();
 
-		err = mana_detach(ndev, false);
-		if (err)
-			netdev_err(ndev, "Failed to detach vPort %d: %d\n",
-				   i, err);
+		mana_detach(ndev, false);
 
 		if (suspending) {
 			/* No need to unregister the ndev. */
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index e64aa6ae7a4d..fcb66029e51c 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -729,7 +729,7 @@ int mana_disable_vport_rx(struct mana_port_context *apc);
 
 int mana_alloc_queues(struct net_device *ndev);
 int mana_attach(struct net_device *ndev);
-int mana_detach(struct net_device *ndev, bool from_close);
+void mana_detach(struct net_device *ndev, bool from_close);
 
 struct mana_port_context *
 mana_qset_scratch_alloc(struct mana_port_context *apc);
-- 
2.43.0

