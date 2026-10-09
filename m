Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF7D4E80DB;
	Fri,  9 Oct 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556909; cv=none; b=KJXr7mQj9oUqhCPQ2nPr8mnspNt6JSsOrmPUQOGsMm5+vXA2Y+zjxoCAn2/wgzH5fztWhvpIrIJpMKyz0I6aKVezclX9mk+c4QzzNHw1G5UVfvTqs1f9IRDckvDfmkRVfK4ffse7cbxPK1EOMLyPKeUpeenIaJFW/uk+vv2+fsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556909; c=relaxed/simple;
	bh=ES6CNWHnQe5DGoeHP5ZASQPEINf1BibTOlw+degowTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/ewM4NkGU/4KyOb7Q52MDtoBicu/2HYpN+a28GijC/lxCFOYkhelIQ+MS2FZd8hAZ1VjTjqH/7qs4ZvdiCLsmplkrUIYJfFcjET9sJ8fvMKwrYe+FY5ibbuSVY9O6MlxKHrzQXe2r8UX4zo88tVmG1ZZyvmPU7wU1pLbCMKoCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TvFugSQm; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TvFugSQm"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 33A6020B7169;
	Fri,  9 Oct 2026 07:41:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 33A6020B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556906;
	bh=YE9YD/C7HhynIzpi+IHj6a6oFQLAledM+JKGOh4MyU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvFugSQm+soopf9HGaTrUrQXmmbRbDM0AZJMg8DpuZ3KrTUSDbQkXan/aF1Y8KzVt
	 I3+UNVI86n0h3qTcraxoCVt+cF/zH+9/1sRbGA+gIcysjBOQaadKsNB35vGbTf1u3D
	 PClE5qslokJRbyIK/+hsmYozEBTsp/hrExoqC/Lk=
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
Subject: [PATCH net-next v6 06/13] net: mana: swap queue sets in mana_set_priv_flags
Date: Fri,  9 Oct 2026 14:41:17 +0000
Message-ID: <57c94d333f2c3168c5d68190ff2aed23daa39a67.1790795005.git.weh@linux.microsoft.com>
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

Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
the RX layout. Carry priv_flags with the queue set so allocation failure
leaves the live configuration unchanged and rollback restores the flags.

Retain shortcuts for an unchanged RX buffer flag, a down port, or a
configuration whose MTU or XDP already requires full-page RX. A failed
rollback closes the port.

This full rebuild temporarily keeps both sets of SQ/RQ/CQ objects,
RX buffers and page pools live. The port-owned EQ pool is shared,
not doubled. Device resource limits may reject this temporary peak;
allocation failure preserves the live queues and configuration.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../ethernet/microsoft/mana/mana_ethtool.c    | 74 +++++++++----------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 10d672cc9e60..7a1120342208 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -881,7 +881,8 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
 	u32 changed = apc->priv_flags ^ priv_flags;
-	u32 old_priv_flags = apc->priv_flags;
+	struct mana_port_context *scratch;
+	struct mana_qset newq, oldq;
 	int err = 0;
 
 	if (!changed)
@@ -891,54 +892,51 @@ static int mana_set_priv_flags(struct net_device *ndev, u32 priv_flags)
 	if (priv_flags & ~GENMASK(MANA_PRIV_FLAG_MAX - 1, 0))
 		return -EINVAL;
 
-	apc->priv_flags = priv_flags;
-
-	if (changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) {
-		if (!apc->port_is_up)
-			return 0;
-
-		/* If XDP is attached or MTU is jumbo, single-buffer-per-page
-		 * is already forced regardless of this flag. Skip the
-		 * expensive detach/attach cycle since nothing changes.
-		 */
-		if (ndev->mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 ||
-		    mana_xdp_get(apc))
-			return 0;
+	/* No rebuild is needed if the RX buffer flag is unchanged, the port is
+	 * down, or full-page RX buffers are already required by MTU or XDP.
+	 */
+	if (!(changed & BIT(MANA_PRIV_FLAG_USE_FULL_PAGE_RXBUF)) ||
+	    !apc->port_is_up ||
+	    ndev->mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 ||
+	    mana_xdp_get(apc)) {
+		apc->priv_flags = priv_flags;
+		return 0;
+	}
 
-		/* Block RDMA from grabbing the vport during detach/attach */
-		mutex_lock(&apc->vport_mutex);
-		apc->channel_changing = true;
+	mutex_lock(&apc->vport_mutex);
+	if (apc->channel_changing) {
 		mutex_unlock(&apc->vport_mutex);
+		return -EBUSY;
+	}
+	apc->channel_changing = true;
+	mutex_unlock(&apc->vport_mutex);
 
-		err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
-		if (err) {
-			netdev_err(ndev,
-				   "Insufficient memory for new allocations\n");
-			apc->priv_flags = old_priv_flags;
-			goto clear_flag;
-		}
+	scratch = mana_qset_scratch_alloc(apc);
+	if (!scratch) {
+		err = -ENOMEM;
+		goto clear_flag;
+	}
 
-		err = mana_detach(ndev, false);
-		if (err) {
-			netdev_err(ndev, "mana_detach failed: %d\n", err);
-			apc->priv_flags = old_priv_flags;
-			goto out;
-		}
+	err = mana_alloc_qset(apc, scratch, apc->num_queues, apc->rx_queue_size,
+			      apc->tx_queue_size, priv_flags, &newq);
+	if (err)
+		goto free_scratch;
 
-		err = mana_attach(ndev);
-		if (err) {
-			netdev_err(ndev, "mana_attach failed: %d\n", err);
-			apc->priv_flags = old_priv_flags;
-		}
+	err = mana_publish_qset(apc, &newq, &oldq);
+	if (err) {
+		mana_free_qset(scratch, &newq);
+		goto free_scratch;
 	}
 
-out:
-	mana_pre_dealloc_rxbufs(apc);
+	mana_free_qset(scratch, &oldq);
+
+free_scratch:
+	mana_publish_close_if_needed(apc);
+	mana_qset_scratch_free(scratch);
 clear_flag:
 	mutex_lock(&apc->vport_mutex);
 	apc->channel_changing = false;
 	mutex_unlock(&apc->vport_mutex);
-
 	return err;
 }
 
