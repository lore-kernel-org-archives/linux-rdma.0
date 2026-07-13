Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420BA33B6D6
	for <linux-rdma@vger.kernel.org>; Mon, 13 Jul 2026 10:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783937003; cv=none; b=FWbEvumnuDzWphklDNkMJtxhnoDdTPTQVsI25vfroOcLeSLGdBgfq5vqlld2OgWFVV5JCL81uFAOTub/nLYXvuYzZEpfqe5ianf25Df+uQG6T4DftKAJ41s99rSQEUs+Npbn4lY01kxeJsuZi7u+TRQR061i4aIpclUptL6znWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783937003; c=relaxed/simple;
	bh=6RePnZwNrX/R091StCaDeMVkWY+kRAKhvTeWLxVqYfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k6xXLloCi45NzsehRTP/kzoM2WJllsd/WfgkDPgdaW4W9KyIo+SkVqQD2Rm1gUI5gLKaOu4eBhBOyxzmgpQzJJpxw9ZVKiejA8aqq4CuBln1L9aVoIxxUIMYKm130e2V4e5Nl3Ye8SZ163FpzUl5X9NAwcdSFTPNBv7yadRNTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dib7GYCF; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dib7GYCF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ik
	vqmgflSF7m/ky6Ga7/h0ewrc3wGl0VScsAOZLrbDo=; b=dib7GYCFzJnYjItx+I
	wdi25c17s3M6ApEODfYZgP++zjFC0ZO/aKPtNTWc2HuiytlH418/v7RSddf/eI7e
	fz6qJuLYQtQuXvHY7OasVgY05ssWt3EydDdLVxfxIMDZbHIgH6+lHSZ4dCoi19yQ
	RFHGpBf9ZN8JkuC+KajeNK74w=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr1Tdt1RqNbdoJA--.59703S2;
	Mon, 13 Jul 2026 18:03:09 +0800 (CST)
From: weimin xiong <15927021679@163.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@nvidia.com,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: [PATCH] RDMA/rxe: Hold netdev reference for transmit skbs
Date: Mon, 13 Jul 2026 18:03:09 +0800
Message-ID: <20260713100309.101189-1-15927021679@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnr1Tdt1RqNbdoJA--.59703S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFWfAw1kXw4DJry3KF48Zwb_yoW5Wr1rpF
	WUGay5Kr4fXw47uF1DA3yUZFWay3W8Jry5GF90q39IyrnYkw42gFnrCFW2vF4rCFZ5Gw17
	tr1IqFZ5Ga13JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07USeHgUUUUU=
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC8x3UXWpUt90n6wAA3-

From: xiongweimin <xiongweimin@kylinos.cn>

rxe_init_packet() assigns skb->dev from an RCU-protected GID attribute
without holding a netdev reference. If the netdev is unregistered before
the skb is freed, subsequent accesses to skb->dev are unsafe.

Hold a reference with dev_hold() when the skb is initialized and release
it from the transmit destructor or via rxe_put_skb() on error paths.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
Cc: linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>
---

--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -95,6 +95,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 				int paylen, struct rxe_pkt_info *pkt);
+void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
 int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -355,6 +355,16 @@ static void rxe_skb_tx_dtor(struct sk_buff *skb)
 
 	rxe_put(qp);
 	sock_put(skb->sk);
+	if (skb->dev) {
+		dev_put(skb->dev);
+		skb->dev = NULL;
+	}
+}
+
+void rxe_put_skb(struct sk_buff *skb)
+{
+	if (skb->dev)
+		dev_put(skb->dev);
+	kfree_skb(skb);
 }
 
 static int rxe_send(struct sk_buff *skb, struct rxe_pkt_info *pkt)
@@ -441,7 +451,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	goto done;
 
 drop:
-	kfree_skb(skb);
+	rxe_put_skb(skb);
 	err = 0;
 done:
 	return err;
@@ -486,8 +496,8 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 
 	skb_reserve(skb, hdr_len + LL_RESERVED_SPACE(ndev));
 
-	/* FIXME: hold reference to this netdev until life of this skb. */
+	dev_hold(ndev);
 	skb->dev	= ndev;
 	rcu_read_unlock();
 
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -793,7 +793,7 @@ next_wqe:
 			wqe->status = IB_WC_LOC_PROT_ERR;
 		else
 			wqe->status = IB_WC_LOC_QP_OP_ERR;
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		if (ah)
 			rxe_put(ah);
 		goto err;
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -817,7 +817,7 @@ static struct sk_buff *copy_data(struct rxe_qp *qp,
 
 	err = rxe_prepare(&qp->pri_av, ack, skb);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		return NULL;
 	}
 
@@ -945,7 +945,7 @@ static enum resp_states read(struct rxe_qp *qp,
 	err = rxe_mr_copy(mr, res->read.va, payload_addr(&ack_pkt),
 			  payload, RXE_FROM_MR_OBJ);
 	if (err) {
-		kfree_skb(skb);
+		rxe_put_skb(skb);
 		state = RESPST_ERR_RKEY_VIOLATION;
 		goto err_out;
 	}

