Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444648;
	b=L/iYdda79TkZI0u8daH6hj9Zd7PmLXtKXRfQFcF/5fWsyMhYzm8MVtABQ8duFMbR2oKA
	 i+bd2y21kzmFMLFV99vaw13YUc14y8FYpebefq7ekp1+XzbPhr8riS7bHlVFuG7OFC6wM
	 hRrUluzemskWQg4ZbZuvf8vBCSN2WytF466eTownpxSMbZc79jsw4/UTrjjp2JX8OceDh
	 ArU5915FDAw8BnW8EscpYLYU03+tHB53H2LrcL1u5EFd5u6EaHrzRWvGlxHqhW6B4Hkkn
	 u9pjSonRblGcrX6qED5Ukc7tTyqvsSLhE4HGShENIra5+KPZLhd/rcjXkAu+9f2Nq3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=NRvsxGZ+NUErwOy3fRsv6NSczA2Tq3p7OdShy/hIZ9M=;
	b=Xu+LuSe/1+JOjiVkuN/VrYoL9NhjDqLeY9fH/UCESFQV8aWIULWdo9Tc74vL6SRbcJ8j
	 tpTHuOa2BUQvbYHBsW1O8q8xiiftVeG1uwD7JmHJRgQVZs6urCnxX1SixmROLN55Xz/81
	 wqRXnTMNbGZHTWQDoQBmzSDQ8GmLHwmNpdRrZoNnHIl1rfnF3ZsaijHFGRGb3kfZD46zs
	 z64IxUfO6jDM/xoEi2Y4YXwjOlG8u8apK34q5aBJWAOFzSMjtUH7agj0St7Fj3xqR8KQZ
	 MLBx15mtUE4KxLRZHFiZiFh4o44NsqYhZz6yFhFH70H7GzcuopUjWNASvUeFfySh0oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=K+gYTzFP;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698C2606A333
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 698C2606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=K+gYTzFP
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so28243045e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444647; x=1796049447; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NRvsxGZ+NUErwOy3fRsv6NSczA2Tq3p7OdShy/hIZ9M=;
        b=K+gYTzFP5i/Y6KJdbOr+iUR22pG2Imk47B3klhu1Xpjsl6AMcb41I+mLldmZPi3y6D
         t0VqZ1xU5vseT4KuTefKzjQwNObjlTEfRpofMcnxeEvrhNyEMlL5Z/bcN6WafbbPU/zy
         ACoYwnIb1QdWHiZADRmjKKxDQHSGUFLwM2rosutYUKCuSyovEV604hawJwF3DkXxW+67
         7ra/b6fGliF8zQngv6aJw/bgKrauMEiD42tGMfiLbLfiHLFxepanZFj+NSxZaqMF/lTh
         QEmyrSglRm584xwRTdcdj4YZT26U+xlL0Y8o/26p/jfCSoeWgP6p2RtAn0sBx+hcLKef
         VWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444647; x=1796049447;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NRvsxGZ+NUErwOy3fRsv6NSczA2Tq3p7OdShy/hIZ9M=;
        b=Q8aLviRgc99S43254319TV/vHLsiAUwSdi/cGiZYLBj9tHmLZ3Z0WSXwyHMalwKuYG
         P0De7LN8+3yeq0LbDwaeWWTE5IpLfSYhgvZhu5CB/t4OW3GickEg7fJ82yTxFNeMaU1R
         uYZ3to/EedMHZ5597LB6ukeDhfaz/rkQtJZeS2um4jUevV8BzSfqpj5KynDjatoilCzF
         ZiFnr7rboMOrgxB7UQox/8F1+pFWWTbD25dFXMeiuHvgA0zf+PtZxVcqz4LjkxBxPe6t
         CG1Lv1RtX7uoHzXKglr0U1rjAcjmtviGKe7MTCmzdjZqtX5d3d2V+yzghSXMte91kF6Y
         4gAA==
X-Gm-Message-State: APuU4Z/nCcgxUP8ZcHa0bQVRY4LOL3nl4Yvj5cHtLovF26UjLMkFzxSO
	hU/paagyMVOWNN7rO/svozJJNrfZ3AH2k6TSvVr+cjs0dN3CuDtP6mMIdkZ8aC5Oh3NNdJGAV5z
	UcSAcPho=
X-Gm-Gg: AZFdTZcx9jY+gE5SSqmvTspQTwvYUZJ21hyYRsI415iFNSBjymfvJGfc3pTJPi7XwOs
	O0bLjTQnfz30USb+gBRtgykMFZqA01elvF2BRIDF4K2r10tDcQHQn7r4KkgDtGaa/GVjlcFSuP8
	g9xYalpiKDR/gExUogRlSzPN6BmzeB1iR7JKJIBM3aVBTulTkPRiuM/SyxBss4E5nt1jZ9ERA0Y
	KVPjtoKeZ9/ud7Q9hDgDwNy9QcmynQm1yyVqOc6cqIZo8HgAPm9toryzZFnE6RVOFCG/mJJ4o/N
	03dQmYtt55fvyVuAJEVM0mLkSDzwerkmzk5vmbriB4NzTX6PClzchcuZAyua25Jko0zoWiUsFSD
	iCaXbkMCZ1tXKrtClrZ6c+lz/fp3CzOIFXeSAaGXBE2yfPmdergX4iDiqc/fTIovCnBpXnZLoWh
	/8KPlyxzQWVcGk+5iOx4AbvdHBh5L8eKXAyTjgTF/YQgRiELcbmTm9SV6BpSFtcLeFs6Ut1nhdd
	X+dlx6JVFIteFd5WykQ7ZhkOLi1m8jq8suR88VjNK6C2Km5aE1s2XL6QnF5GUtbEnx4Mo8rDscP
	PWlOXOntdOnava/43Aa8DwLthrBhNESNH8o/nUq/K2iii4l4tGrzle0NzPfGmBfHWCbMyM4pQnl
	HhMldEDg1irA2Ihouv8dGkiZXW4bfRyksYYy/DUG0iAIpWaoj687D06jI5Ubh8RUogpiV/hBXIe
	PPV1ZbAM/oLLDUUKxi/4lQiJllE8iXqc1Zpkw=
X-Received: by 2002:a05:600c:4ecd:b0:4a3:12fb:1ef1 with SMTP id 5b1f17b1804b1-4bb8881e81cmr252914825e9.29.1795444646724;
        Mon, 23 Nov 2026 06:37:26 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:26 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benjamin.stuerz@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 8/9] RDMA/rtrs-srv: Snapshot the READ request header instead of reusing it
Date: Mon, 23 Nov 2026 15:37:18 +0100
Message-ID: <20261123143719.938876-9-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Stürz <benjamin.stuerz@ionos.com>

process_read() validates the READ request header and then keeps a
pointer to it in srv->chunks[buf_id]. The client's permits normally keep
that chunk stable until the server responds, but the server does not
enforce it: once the client gives up on a request and releases the
permit, the chunk is reused for an unrelated I/O, while a slow backend
can leave the original operation in flight on a path the server has not
yet declared dead.

rdma_write_sg(), send_io_resp_imm() and rtrs_srv_resp_rdma() re-read
sg_cnt, the invalidate flag and the descriptor from there at completion
time, so they act on whatever now lives at that offset. The RDMA write
can then go to another request's remote address with its length and
rkey, or the response can invalidate the wrong rkey.

Snapshot sg_cnt, the invalidate flag and the descriptor into
rtrs_srv_op when the request arrives, and drop rd_msg. The WRITE path
reads none of them, so nothing needs clearing there.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Benjamin Stürz <benjamin.stuerz@ionos.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 33 ++++++++++++++------------
 drivers/infiniband/ulp/rtrs/rtrs-srv.h | 13 +++++++++-
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 7a47b90e8539..c1c76ec65d0f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -210,8 +210,8 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	struct ib_sge *plist;
 	struct ib_sge list;
 
-	sg_cnt = le16_to_cpu(id->rd_msg->sg_cnt);
-	need_inval = le16_to_cpu(id->rd_msg->flags) & RTRS_MSG_NEED_INVAL_F;
+	sg_cnt = id->sg_cnt;
+	need_inval = id->need_inval;
 	if (sg_cnt != 1)
 		return -EINVAL;
 
@@ -220,7 +220,7 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 	wr		= &id->tx_wr;
 	plist		= &id->tx_sg;
 	plist->addr	= dma_addr + offset;
-	plist->length	= le32_to_cpu(id->rd_msg->desc[0].len);
+	plist->length	= le32_to_cpu(id->desc.len);
 
 	/* WR will fail with length error
 	 * if this is 0
@@ -236,8 +236,8 @@ static int rdma_write_sg(struct rtrs_srv_op *id)
 
 	wr->wr.sg_list	= plist;
 	wr->wr.num_sge	= 1;
-	wr->remote_addr	= le64_to_cpu(id->rd_msg->desc[0].addr);
-	wr->rkey	= le32_to_cpu(id->rd_msg->desc[0].key);
+	wr->remote_addr	= le64_to_cpu(id->desc.addr);
+	wr->rkey	= le32_to_cpu(id->desc.key);
 
 	wr->wr.opcode = IB_WR_RDMA_WRITE;
 	wr->wr.wr_cqe   = &io_comp_cqe;
@@ -347,15 +347,10 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 	int err;
 
 	if (id->dir == READ) {
-		struct rtrs_msg_rdma_read *rd_msg = id->rd_msg;
-		size_t sg_cnt;
-
-		need_inval = le16_to_cpu(rd_msg->flags) &
-				RTRS_MSG_NEED_INVAL_F;
-		sg_cnt = le16_to_cpu(rd_msg->sg_cnt);
+		need_inval = id->need_inval;
 
 		if (need_inval) {
-			if (sg_cnt) {
+			if (id->sg_cnt) {
 				inv_wr.wr_cqe   = &io_comp_cqe;
 				inv_wr.sg_list = NULL;
 				inv_wr.num_sge = 0;
@@ -363,7 +358,7 @@ static int send_io_resp_imm(struct rtrs_srv_con *con, struct rtrs_srv_op *id,
 				inv_wr.send_flags = 0;
 				/* Only one key is actually used */
 				inv_wr.ex.invalidate_rkey =
-					le32_to_cpu(rd_msg->desc[0].key);
+					le32_to_cpu(id->desc.key);
 			} else {
 				WARN_ON_ONCE(1);
 				need_inval = false;
@@ -512,7 +507,7 @@ bool rtrs_srv_resp_rdma(struct rtrs_srv_op *id, int status)
 		return false;
 	}
 
-	if (status || id->dir == WRITE || !id->rd_msg->sg_cnt)
+	if (status || id->dir == WRITE || !id->sg_cnt)
 		err = send_io_resp_imm(con, id, status);
 	else
 		err = rdma_write_sg(id);
@@ -1072,7 +1067,15 @@ static void process_read(struct rtrs_srv_con *con,
 	id->con		= con;
 	id->dir		= READ;
 	id->msg_id	= buf_id;
-	id->rd_msg	= msg;
+	/*
+	 * Take a private copy of everything we still need once the I/O
+	 * completes: by then the chunk is not guaranteed to still hold
+	 * this request's header, see struct rtrs_srv_op.
+	 */
+	id->sg_cnt	= sg_cnt;
+	id->need_inval	= le16_to_cpu(msg->flags) & RTRS_MSG_NEED_INVAL_F;
+	if (sg_cnt)
+		id->desc = msg->desc[0];
 	data_len = off - usr_len;
 	data = page_address(srv->chunks[buf_id]);
 	ret = ctx->ops.rdma_ev(srv->priv, id, data, data_len,
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.h b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
index 3d36876527f5..bf27e01402d1 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.h
@@ -52,7 +52,18 @@ struct rtrs_srv_op {
 	struct rtrs_srv_con		*con;
 	u32				msg_id;
 	u8				dir;
-	struct rtrs_msg_rdma_read	*rd_msg;
+	/*
+	 * Snapshot of the READ request header, taken when the request is
+	 * received and validated.  The client's permits normally keep the
+	 * chunk stable until we respond, but that is the client's
+	 * bookkeeping and not something we enforce: reconnect and failover
+	 * edge cases can leave the chunk rewritten by a newer request while
+	 * this I/O is still running.  The completion path must use this copy
+	 * and never read srv->chunks[msg_id] back.
+	 */
+	bool				need_inval;
+	u16				sg_cnt;
+	struct rtrs_sg_desc		desc;
 	struct ib_rdma_wr		tx_wr;
 	struct ib_sge			tx_sg;
 	struct list_head		wait_list;
-- 
2.43.0

