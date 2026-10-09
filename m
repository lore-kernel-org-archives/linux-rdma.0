Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F97C4ED1B3;
	Fri,  9 Oct 2026 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556919; cv=none; b=K0QxmHDftGqf4rqUugy1/7h06wsQG0JlkFfjk9hk+8iNK9dBOh6lkrQSenwEEghGUfEcN1CUntxP+mY58Hp4r6VSmSzJqyvYmkLtXhyrbKVQ4J1vpyoMJoreHXle2IVJY5ozIP+YIRjM9fj2FqkuvdRXVuSIbRu7opBvODMD6to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556919; c=relaxed/simple;
	bh=OJN1ZuOwnM22qiBGqARF3g3FPW+GavwStkvWjmUjjN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm46JcHSnw6rBXcFWeUX0JmOKK6jnD2llS5N7AU0fVjwgV6HCPVP4Afe8Pa739LE8uzz9328kAGP7M6cVFfNhISAXQB8hhEyEQpGXIi/EKIKkf3l4Vw/KjhkXkA6UxtA7nFeSjGiq54aG7lmLgKTmsAxGhPCGYRuzZRzvvL7tW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=M/wdzJg1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="M/wdzJg1"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 89B3320B716D;
	Fri,  9 Oct 2026 07:41:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 89B3320B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791556916;
	bh=YD5B9YEMds/448OypixxWy/SDnxeCGeQHcjjdh7+wM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/wdzJg1Ul4bKFTk2IfhSyzoTsNSgZ+cfHmT4TbMVF5gidlhGTqeT8OpbeSeV1vyc
	 IzQtNhMpGeaaFUZBofGHCshz0Qjbq92mmGa88+x4lzYVorA3JjBO17AUwFTTMBD0uU
	 PdNI2e0UKggfXHTet1RDwOU/7gC60QK7KkjNYLIA=
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
Subject: [PATCH net-next v6 12/13] net: mana: keep the surviving queues when the channel count is reduced
Date: Fri,  9 Oct 2026 14:41:23 +0000
Message-ID: <6cd5cbe37973685f58b5cc54a598f3df8ac48e52.1790795005.git.weh@linux.microsoft.com>
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

Split the live set into a kept prefix and a retiring tail. Reductions
allocate only pointer arrays and steering tables, retaining the kept
queues' page pools, buffers, NAPI state and XDP references.

After publication, wait for TX-selection readers before freeing the old
containers, then retire only the tail. Failed publication discards the
new containers without freeing shared queues.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 112 +++++++++++++++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |  30 +++++
 include/net/mana/mana.h                       |   4 +
 3 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5619c6a763c2..2fe53adda119 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -4149,6 +4149,114 @@ void mana_qset_scratch_free(struct mana_port_context *scratch)
 	kvfree(scratch);
 }
 
+/* Split into kept queues and a retiring tail without changing live ownership.
+ * Queue i retains EQ i.
+ */
+int mana_split_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int new_count,
+		    struct mana_qset *out_new, struct mana_qset *out_tail)
+{
+	unsigned int old_count = apc->num_queues;
+	struct mana_tx_qp **new_tx, **tail_tx;
+	struct mana_rxq **new_rx, **tail_rx;
+	unsigned int tail_count;
+	bool indir_lost;
+	unsigned int i;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(new_count == 0 || new_count >= old_count))
+		return -EINVAL;
+	if (WARN_ON(!apc->tx_qp || !apc->rxqs))
+		return -EINVAL;
+
+	tail_count = old_count - new_count;
+
+	/* Build steering separately so it cannot index beyond the shortened RX
+	 * array.
+	 */
+	scratch->num_queues = new_count;
+	err = mana_rss_table_alloc(scratch);
+	if (err)
+		return err;
+
+	if (mana_rss_table_keep(apc, new_count, &indir_lost))
+		memcpy(scratch->indir_table, apc->indir_table,
+		       apc->indir_table_sz * sizeof(*apc->indir_table));
+	else
+		mana_rss_table_init(scratch);
+
+	new_tx = kzalloc_objs(struct mana_tx_qp *, new_count);
+	new_rx = kzalloc_objs(struct mana_rxq *, new_count);
+	tail_tx = kzalloc_objs(struct mana_tx_qp *, tail_count);
+	tail_rx = kzalloc_objs(struct mana_rxq *, tail_count);
+	if (!new_tx || !new_rx || !tail_tx || !tail_rx) {
+		err = -ENOMEM;
+		goto free_arrays;
+	}
+
+	for (i = 0; i < new_count; i++) {
+		new_tx[i] = apc->tx_qp[i];
+		new_rx[i] = apc->rxqs[i];
+	}
+	for (i = 0; i < tail_count; i++) {
+		tail_tx[i] = apc->tx_qp[new_count + i];
+		tail_rx[i] = apc->rxqs[new_count + i];
+	}
+
+	out_new->tx_qp		= new_tx;
+	out_new->rxqs		= new_rx;
+	out_new->indir_table	= scratch->indir_table;
+	out_new->indir_table_sz	= scratch->indir_table_sz;
+	out_new->rxobj_table	= scratch->rxobj_table;
+	out_new->default_rxobj	= apc->rxqs[0]->rxobj;
+	out_new->num_queues	= new_count;
+	out_new->rx_queue_size	= apc->rx_queue_size;
+	out_new->tx_queue_size	= apc->tx_queue_size;
+	out_new->priv_flags	= apc->priv_flags;
+	out_new->mtu		= apc->configured_mtu;
+	out_new->bpf_prog	= apc->bpf_prog;
+	out_new->rxfh_indir_lost = indir_lost;
+
+	scratch->indir_table	= NULL;
+	scratch->rxobj_table	= NULL;
+
+	memset(out_tail, 0, sizeof(*out_tail));
+	out_tail->tx_qp		= tail_tx;
+	out_tail->rxqs		= tail_rx;
+	out_tail->default_rxobj	= INVALID_MANA_HANDLE;
+	out_tail->num_queues	= tail_count;
+	out_tail->rx_queue_size	= apc->rx_queue_size;
+	out_tail->tx_queue_size	= apc->tx_queue_size;
+	out_tail->priv_flags	= apc->priv_flags;
+	out_tail->mtu		= apc->configured_mtu;
+	out_tail->bpf_prog	= apc->bpf_prog;
+
+	return 0;
+
+free_arrays:
+	kfree(new_tx);
+	kfree(new_rx);
+	kfree(tail_tx);
+	kfree(tail_rx);
+	mana_cleanup_indir_table(scratch);
+	return err;
+}
+
+/* Free containers only; the live port still owns the queues. */
+void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq)
+{
+	kfree(newq->tx_qp);
+	kfree(newq->rxqs);
+	kfree(newq->indir_table);
+	kfree(newq->rxobj_table);
+	kfree(tailq->tx_qp);
+	kfree(tailq->rxqs);
+	memset(newq, 0, sizeof(*newq));
+	memset(tailq, 0, sizeof(*tailq));
+}
+
 int mana_alloc_qset(struct mana_port_context *apc,
 		    struct mana_port_context *scratch, unsigned int num_queues,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
@@ -4419,9 +4527,7 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 	if (err)
 		goto rollback;
 
-	/* Install XDP and per-RXQ references before steering reaches new
-	 * queues.
-	 */
+	/* Install XDP before steering reaches the incoming RXQs. */
 	mana_chn_setxdp(apc, mana_xdp_get(apc));
 
 	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index a53e19b15bae..d3e465ea9428 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -737,6 +737,36 @@ static int mana_set_channels(struct net_device *ndev,
 		goto clear_flag;
 	}
 
+	if (new_count < apc->num_queues) {
+		struct mana_qset tailq;
+
+		err = mana_split_qset(apc, scratch, new_count, &newq, &tailq);
+		if (err)
+			goto free_scratch;
+
+		err = mana_publish_qset(apc, &newq, &oldq);
+		if (err) {
+			/* Discard containers only; their queues still belong to
+			 * the old set.
+			 */
+			mana_discard_split(&newq, &tailq);
+			goto free_scratch;
+		}
+
+		/* Wait for ndo_select_queue() readers of oldq.indir_table. Free
+		 * only containers; the queues belong to the kept set or tail.
+		 */
+		synchronize_net();
+
+		kfree(oldq.tx_qp);
+		kfree(oldq.rxqs);
+		kfree(oldq.indir_table);
+		kfree(oldq.rxobj_table);
+
+		mana_free_qset(scratch, &tailq);
+		goto free_scratch;
+	}
+
 	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
 			      apc->tx_queue_size, apc->priv_flags,
 			      apc->configured_mtu, apc->bpf_prog, &newq);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9dad03150d1b..fef800bea2c0 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -735,6 +735,10 @@ int mana_alloc_qset(struct mana_port_context *apc,
 		    unsigned int rx_queue_size, unsigned int tx_queue_size,
 		    u32 priv_flags, int mtu, struct bpf_prog *bpf_prog,
 		    struct mana_qset *out);
+int mana_split_qset(struct mana_port_context *apc,
+		    struct mana_port_context *scratch, unsigned int new_count,
+		    struct mana_qset *out_new, struct mana_qset *out_tail);
+void mana_discard_split(struct mana_qset *newq, struct mana_qset *tailq);
 int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
 		      struct mana_qset *out_old);
 void mana_publish_close_if_needed(struct mana_port_context *apc);
