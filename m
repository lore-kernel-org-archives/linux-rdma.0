Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D9438DD3
	for <linux-rdma@vger.kernel.org>; Wed,  8 Apr 2026 00:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775607027; cv=none; b=e0jHQEDM015QnDLp8txHyAVRyTzFzUDZzxeMBzd2wyI+kykVqeWgmqPJiWI/lF8CQmOO+38NrkBc5acT2IpnMRxK+yjnAFtZHNLUOkCSC/saIMPzqcJW8KTKG3q6mPIuv0a2h6onBF5TvJFw7fnSRCKicWVEuXWS76qxU0AU3MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775607027; c=relaxed/simple;
	bh=ELC5Aa2urYtusIfibB/7Fu6EIJmnCqfSr71rffWhcMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHzaBWY09m/PWLtZzPFzbGE9LyuzFw7GzpD3YB+oteS3K7zuf/imQtFi6ApTfShKUPnFtrxqGHWzp8av9oaoB+sXACLh1QAmyAMJVkN8e9VE3anudUDqEqnQ7BfKlQQDTC/zyCDpo8xwVm6lDQYGp/XNssBSaHwev52r6SQewTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CqruLoys; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CqruLoys"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775607024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=khPAm7yRKyvsyjet7XrXUNeDJARjrHbHUKpjHIDa6EI=;
	b=CqruLoysXE+INNlYxG8Qomhmn2Z63xfPm3vGshgIwBR61EQfG5RSF1SQ0vPphb4x6/RRKl
	wSmVQOvzAOQmZPG/hzOE2Av5U/K30imtE1U+toh4njvaZIAq8U/KeqWT8xi78i7JHb/Doo
	EBfYD/j7XfsZowSTaPr8qGlFUTj3+LE=
From: zhenwei pi <zhenwei.pi@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	zhenwei pi <zhenwei.pi@linux.dev>
Subject: [PATCH v5 2/3] RDMA/rxe: add SENT/RCVD bytes
Date: Wed,  8 Apr 2026 08:09:55 +0800
Message-ID: <20260408000956.486522-3-zhenwei.pi@linux.dev>
In-Reply-To: <20260408000956.486522-1-zhenwei.pi@linux.dev>
References: <20260408000956.486522-1-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There is a lack of sent/received counter in bytes.

Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 ++
 drivers/infiniband/sw/rxe/rxe_hw_counters.h | 2 ++
 drivers/infiniband/sw/rxe/rxe_net.c         | 2 ++
 drivers/infiniband/sw/rxe/rxe_recv.c        | 2 ++
 drivers/infiniband/sw/rxe/rxe_verbs.h       | 6 ++++++
 5 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
index 437917a7d8f2..17edaa9a9b9b 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
@@ -22,6 +22,8 @@ static const struct rdma_stat_desc rxe_counter_descs[] = {
 	[RXE_CNT_LINK_DOWNED].name         =  "link_downed",
 	[RXE_CNT_RDMA_SEND].name           =  "rdma_sends",
 	[RXE_CNT_RDMA_RECV].name           =  "rdma_recvs",
+	[RXE_CNT_SENT_BYTES].name          =  "sent_bytes",
+	[RXE_CNT_RCVD_BYTES].name          =  "rcvd_bytes",
 };
 
 int rxe_ib_get_hw_stats(struct ib_device *ibdev,
diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.h b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
index 051f9e1c3852..01b355103cbc 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.h
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.h
@@ -26,6 +26,8 @@ enum rxe_counters {
 	RXE_CNT_LINK_DOWNED,
 	RXE_CNT_RDMA_SEND,
 	RXE_CNT_RDMA_RECV,
+	RXE_CNT_SENT_BYTES,
+	RXE_CNT_RCVD_BYTES,
 	RXE_NUM_OF_COUNTERS
 };
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 6621d01ac32d..86660031ffa2 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -503,6 +503,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	int err;
 	int is_request = pkt->mask & RXE_REQ_MASK;
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
+	unsigned int skblen = skb->len;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->state_lock, flags);
@@ -526,6 +527,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 	}
 
 	rxe_counter_inc(rxe, RXE_CNT_SENT_PKTS);
+	rxe_counter_add(rxe, RXE_CNT_SENT_BYTES, skblen);
 	goto done;
 
 drop:
diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 5861e4244049..e7bab89e7d8d 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -318,6 +318,7 @@ void rxe_rcv(struct sk_buff *skb)
 	int err;
 	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 	struct rxe_dev *rxe = pkt->rxe;
+	unsigned int skblen = skb->len - skb_network_offset(skb);
 
 	if (unlikely(skb->len < RXE_BTH_BYTES))
 		goto drop;
@@ -341,6 +342,7 @@ void rxe_rcv(struct sk_buff *skb)
 	if (unlikely(err))
 		goto drop;
 
+	rxe_counter_add(rxe, RXE_CNT_RCVD_BYTES, skblen);
 	rxe_counter_inc(rxe, RXE_CNT_RCVD_PKTS);
 
 	if (unlikely(bth_qpn(pkt) == IB_MULTICAST_QPN))
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index e800545d1046..0f5ffd94643f 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -455,6 +455,12 @@ static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
 	atomic64_inc(&rxe->stats_counters[index]);
 }
 
+static inline void rxe_counter_add(struct rxe_dev *rxe, enum rxe_counters index,
+				   s64 val)
+{
+	atomic64_add(val, &rxe->stats_counters[index]);
+}
+
 static inline struct rxe_dev *to_rdev(struct ib_device *dev)
 {
 	return dev ? container_of(dev, struct rxe_dev, ib_dev) : NULL;
-- 
2.43.0

