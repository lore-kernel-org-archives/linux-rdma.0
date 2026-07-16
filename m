Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152D32B130
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 05:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784181192; cv=none; b=jsDwaTbAFPlGkYq8IeChFeK/IfLZRo8jtt3y4Im8QL8Uc/p5zB/jWQ8vOne9kWyU8OUq1zFZyLOPM/2amqOAggqL3K7D5Xi1yr5alDflMr00knK+NiUl3GnjUW8OwUlKZ2kUgFAQ+pDRGKBbRfKYjuKTS6XvealmVbDm19q2oxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784181192; c=relaxed/simple;
	bh=uo4vAUXs7BOqcGQGztUnzHRUWaI2aWPIzosDYE1Q7JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=URfVAjJ+6rgKz+UIY/jMywblniHTAlv88Kn5obavZm8Khs12hXyqnjrKZEF9zxXVx8c1rCEWwRm14I9Q3OuTHbVKFBljyJA6ogMNP92LDm5H8nftSDOwyVHl+8+JKNpK3t8Ww7TpCgJ5A+qzhLBUgx0KNtT4IMWvfuzfQ28YxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=e/S+ymFO; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="e/S+ymFO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=0r
	X1vxiKF5okFBs2tmircIVhQADPoEvN22PWgv7tOAI=; b=e/S+ymFOQfPFHpLWFM
	Y2IHFhgKnIZxpAJataw1H5SDMatA+AIZBiTu1HSeaVdRlfk9jNtwRU4NTjZnYRMs
	x1gJsL8PqhdwwV5skGxIycr7R1gvev39MNe3K1//Gr05kQd4AISKyq6HjIkZ/aCL
	ehSJSsfhQGADRNb8BSQEl3Das=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3t2eycVhq65V9Jg--.762S2;
	Thu, 16 Jul 2026 13:52:50 +0800 (CST)
From: Weimin Xiong <xiongwm2026@163.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@nvidia.com,
	leonro@nvidia.com,
	yanjun.zhu@linux.dev,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: [PATCH v3] RDMA/rxe: Hold netdev reference for transmit skbs
Date: Thu, 16 Jul 2026 13:52:55 +0800
Message-ID: <20260716055255.157674-1-xiongwm2026@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3t2eycVhq65V9Jg--.762S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jw48CFyftrykWF1DAF4kCrg_yoWxuFWkpa
	1UGay5Kr4xXa129Fn0yrWUZFWay3W8Ja98KF9Fq34Yvrn8Cw47WFsxuryUZF45CFZ5Gw1a
	qF1jyr98Ga1fGFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZL0OUUUUU=
X-CM-SenderInfo: x0lr0wdzpsijqw6rljoofrz/xtbC8BI5yGpYcbLoaQAA3j

From: xiongweimin <xiongweimin@kylinos.cn>

rxe_init_packet() assigns skb->dev from an RCU-protected GID attribute
without holding a netdev reference. If the netdev is unregistered before
the skb is freed, subsequent accesses to skb->dev are unsafe.

Hold a reference with dev_hold() when the skb is initialized and release
it from the transmit destructor or via rxe_put_skb() on error paths that
run before the destructor is installed.

skb->dev can change on the TX path (VLAN/bond/tunnel, ip_finish_output2,
etc.), so put must use the same netdev that was held. Stash that pointer
in skb_shinfo()->destructor_arg: skb->cb is already used by
rxe_pkt_info and is rewritten by IP control blocks.

To avoid blocking netdev unregistration on held skbs, flush all QPs to
the error state on NETDEV_GOING_DOWN and NETDEV_UNREGISTER so pending TX
work is drained and references can be dropped.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
v3:
- put the held netdev from destructor_arg, not live skb->dev
  (skb->dev may be rewritten by the TX stack)

v2:
- rebase on current mainline so the patch applies cleanly
- flush all QPs on NETDEV_GOING_DOWN and NETDEV_UNREGISTER to
  release pending TX skbs before netdev unregister
---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  1 +
 drivers/infiniband/sw/rxe/rxe_net.c  | 68 ++++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_req.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c |  4 +-
 4 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf8..7c3cc48e8 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -92,6 +92,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 				int paylen, struct rxe_pkt_info *pkt);
+void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
 int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 3741b2c4b..86c9b19f6 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -429,6 +429,29 @@ int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 	return err;
 }
 
+/*
+ * skb->dev may be rewritten on the TX path (VLAN/bond/tunnel, etc.).
+ * The netdev we held in rxe_init_packet() is kept in destructor_arg so
+ * that put always matches hold. skb->cb cannot be used: it is already
+ * occupied by struct rxe_pkt_info and rewritten by IP control blocks.
+ */
+static void rxe_skb_set_held_ndev(struct sk_buff *skb, struct net_device *ndev)
+{
+	dev_hold(ndev);
+	skb->dev = ndev;
+	skb_shinfo(skb)->destructor_arg = ndev;
+}
+
+static void rxe_skb_put_held_ndev(struct sk_buff *skb)
+{
+	struct net_device *ndev = skb_shinfo(skb)->destructor_arg;
+
+	if (ndev) {
+		skb_shinfo(skb)->destructor_arg = NULL;
+		dev_put(ndev);
+	}
+}
+
 static void rxe_skb_tx_dtor(struct sk_buff *skb)
 {
 	struct rxe_qp *qp = skb->sk->sk_user_data;
@@ -441,6 +464,18 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 
 	rxe_put(qp);
 	sock_put(skb->sk);
+	rxe_skb_put_held_ndev(skb);
+}
+
+/*
+ * Free an skb that still holds a netdev reference from rxe_init_packet()
+ * and does not yet have rxe_skb_tx_dtor() installed. Once the TX
+ * destructor is set, callers must use kfree_skb() instead.
+ */
+void rxe_put_skb(struct sk_buff *skb)
+{
+	rxe_skb_put_held_ndev(skb);
+	kfree_skb(skb);
 }
 
 static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
@@ -529,7 +564,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	goto done;
 
 drop:
-	kfree_skb(skb);
+	rxe_put_skb(skb);
 	err = 0;
 done:
 	return err;
@@ -574,8 +609,7 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 
 	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
-	/* FIXME: hold reference to this netdev until life of this skb. */
-	skb->dev	= ndev;
+	rxe_skb_set_held_ndev(skb, ndev);
 	rcu_read_unlock();
 
 	if (av->network_type == RXE_NETWORK_TYPE_IPV4)
@@ -710,6 +744,28 @@ void rxe_set_port_state(struct rxe_dev *rxe)
 	dev_put(ndev);
 }
 
+/*
+ * Move all QPs to the error state so pending send/recv work is drained and
+ * in-flight TX skbs (which hold a netdev reference) can be released. Called
+ * from the netdev notifier so unregister cannot stall on held skbs.
+ */
+static void rxe_flush_qps(struct rxe_dev *rxe)
+{
+	struct rxe_pool_elem *elem;
+	struct rxe_qp *qp;
+	unsigned long index;
+
+	rcu_read_lock();
+	xa_for_each(&rxe->qp_pool.xa, index, elem) {
+		if (!elem || !kref_get_unless_zero(&elem->ref_cnt))
+			continue;
+		qp = elem->obj;
+		rxe_qp_error(qp);
+		rxe_put(qp);
+	}
+	rcu_read_unlock();
+}
+
 static int rxe_notify(struct notifier_block *not_blk,
 		      unsigned long event,
 		      void *arg)
@@ -721,7 +777,12 @@ static int rxe_notify(struct notifier_block *not_blk,
 		return NOTIFY_OK;
 
 	switch (event) {
+	case NETDEV_GOING_DOWN:
+		/* Start draining TX queues before the netdev disappears. */
+		rxe_flush_qps(rxe);
+		break;
 	case NETDEV_UNREGISTER:
+		rxe_flush_qps(rxe);
 		ib_unregister_device_queued(&rxe->ib_dev);
 		rxe_net_del(&rxe->ib_dev);
 		break;
@@ -735,7 +796,6 @@ static int rxe_notify(struct notifier_block *not_blk,
 			rxe_counter_inc(rxe, RXE_CNT_LINK_DOWNED);
 		break;
 	case NETDEV_REBOOT:
-	case NETDEV_GOING_DOWN:
 	case NETDEV_CHANGEADDR:
 	case NETDEV_CHANGENAME:
 	case NETDEV_FEAT_CHANGE:
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 12d03f390..927ef68de 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -796,7 +796,7 @@ int rxe_requester(struct rxe_qp *qp)
 			wqe->status = IB_WC_LOC_PROT_ERR;
 		else
 			wqe->status = IB_WC_LOC_QP_OP_ERR;
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		if (ah)
 			rxe_put(ah);
 		goto err;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index d8cbdfa70..ee3630e4b 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -866,7 +866,7 @@ static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 
 	err = rxe_prepare(&qp->pri_av, ack, skb);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		return NULL;
 	}
 
@@ -994,7 +994,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
 			  payload, RXE_FROM_MR_OBJ);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		state = RESPST_ERR_RKEY_VIOLATION;
 		goto err_out;
 	}
-- 
2.43.0

