Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665533EB0E8;
	Tue, 29 Sep 2026 05:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790661571; cv=none; b=hGrP62UWjIEP8aqjVEzS7jfqeM27/fthSLl5c5CfwE5mEIu83fIa+U6RAbAmhcbVLVGeAURiluPYyZXP759XUVZxsGwkbaY9636S70GJtEX7j9XZTTL2QtkJCVvm7GiMW1utMXu44C22MNFeq8G+H3hLV8uDv+eByAaT1kj+A1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790661571; c=relaxed/simple;
	bh=D9JLd4dpIZzZZ7DE9txpT2El/UV4sRsYdrIuSBZkI7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tQqMMX/1eOuf1Wc8VbQRlmVGu5pwcCQ9fdbX28Kx6x08DMAP9M7krvkf25Lb2ND8cJrHfAEvmlRye5g2MV5V79n2hN/VBI/2E1FACnTFSktpFT7/LcGQzAL8KUOGdB/xVaGnjC9J1eTiODZC7ExVASt1aRPlug6tA+8X5rGjSuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=U9W4vr1h; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="U9W4vr1h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Y9
	4BlHEBr2KvDHcQY3ow1m8Cf6wzf7CF6maD4AwfmVU=; b=U9W4vr1hCQYE24v2tG
	nSOcjKVFRQZDqiijIATSJMqjUOA0ehtav+C4XqfQfFgnOA93umLe7e+Mc/HjqKmn
	lYWf0algWK3btpOb0LM3vLVVFX0dlW4aYgLttVfN3FTHEu0xwtV2spzZBeV8Yvbc
	z4RuRFnXSsGwXsgYxtN0xMEnE=
Received: from localhost (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDH71qqU7tqpgbuBw--.44037S2;
	Tue, 29 Sep 2026 13:59:08 +0800 (CST)
From: Honggang LI <honggangli@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Honggang LI <honggangli@163.com>
Subject: [PATCH v2] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
Date: Tue, 29 Sep 2026 13:58:53 +0800
Message-ID: <20260929055853.164026-1-honggangli@163.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDH71qqU7tqpgbuBw--.44037S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ar1DKr1fGw47CFyDCF15urg_yoW7AF45pF
	W8Jw1Ykr4fXF429Fs7Ar4DZrWay3Z8Ga4DGF9Iq3yYvF15C3yYgFnFkry7uFW5GFyUGa1x
	tw12yryDGr43GFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wXUUUUU=
X-CM-SenderInfo: 5krqwwxdqjzxi6rwjhhfrp/xtbC6wyJzmq7U6xZwAAA3X

When RDMA READ request for 2GiB in single WR, res->read.resid is u32
0x80000000, which is INT_MIN (-2147483648).

    payload = min_t(int, res->read.resid, mtu);

The `min_t` function will return -2147483648 for payload. The wrong
size is propagated through call chain, `read_reply` -> `prepare_ack_packet`
-> `rxe_init_packet` -> `alloc_skb` . `alloc_skb` failed because of
invalid size. The passive side failed to emit response packet for RDMA
READ request.

After fixed it, the active side of RDMA READ failed with error code
"IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.

   int resid	= dma->resid;

This conversion set resid to -2147483648. `copy_data` abort as length
greater than resid.

RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
---
Change log:
v2 -> v1:
Use u32 for must-be-unsized quantities, no unsigned-to-signed conversion

 drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..b5aaba7cf76f 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
 int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		unsigned int length, enum rxe_mr_copy_dir dir);
 int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
-	      void *addr, int length, enum rxe_mr_copy_dir dir);
+	      void *addr, u32 length, enum rxe_mr_copy_dir dir);
 int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
 enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
@@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt);
+				u32 paylen, struct rxe_pkt_info *pkt);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
 int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..f2ffbefb9675 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -418,13 +418,13 @@ int copy_data(
 	int			access,
 	struct rxe_dma_info	*dma,
 	void			*addr,
-	int			length,
+	u32			length,
 	enum rxe_mr_copy_dir	dir)
 {
-	int			bytes;
+	u32			bytes;
 	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
-	int			offset	= dma->sge_offset;
-	int			resid	= dma->resid;
+	u32			offset	= dma->sge_offset;
+	u32			resid	= dma->resid;
 	struct rxe_mr		*mr	= NULL;
 	u64			iova;
 	int			err;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..f548f312b393 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -536,7 +536,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 }
 
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt)
+				u32 paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8..4e71bc985721 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -612,7 +612,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 }
 
 static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
-				     int data_len)
+				     u32 data_len)
 {
 	int err;
 
@@ -827,20 +827,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
 static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 					  struct rxe_pkt_info *ack,
 					  int opcode,
-					  int payload,
+					  u32 payload,
 					  u32 psn,
 					  u8 syndrome)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct sk_buff *skb;
-	int paylen;
-	int pad;
+	u32 paylen;
+	u32 pad = 0;
 	int err;
 
 	/*
 	 * allocate packet
 	 */
-	pad = (-payload) & 0x3;
+	if (payload % 4)
+		pad = 4 - payload % 4;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
 	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
@@ -934,9 +935,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 {
 	struct rxe_pkt_info ack_pkt;
 	struct sk_buff *skb;
-	int mtu = qp->mtu;
+	u32 mtu = qp->mtu;
 	enum resp_states state;
-	int payload;
+	u32 payload;
 	int opcode;
 	int err;
 	struct resp_res *res = qp->resp.res;
@@ -982,7 +983,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min(res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-- 
2.54.0

