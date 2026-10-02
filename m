Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901F623ABB9;
	Fri,  2 Oct 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790951001; cv=none; b=pPBPAd9oLPfcoBzQ8zxNRhVuYFkyEkHGP+YLIVZEuZxZffyDkXZDeMvxVTO1MWUGzRj5pBlKjH9+6+THHjRB7k/5rJdXzxPNNTDrBEfqzEe1PHeK5I6Gd0qtGMRQ2rNRoXRtFHuDqXKyRVr6A9zsJVFfzBPhbK1lcUGPkxUnqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790951001; c=relaxed/simple;
	bh=7EluAUMYopXwDqJIYdgnhTnAkV16kAigRNYyjiUdvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dzY/0poseEDIYxp4Oqr12kv8qAXlN9RC6F89FSdBdXFCIuYjpewSiVL7gucmUa4AYxkxcq34XnjX3qjM7eCB48zj5iYvZYZyyEjbqQ/AVAkeCGagkb5ijhCz7FAGLHUv0wa6+bI+jGhBYePMfx/UN+QhtMjlxpbafIf9qDi11K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KAGp2O1z; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KAGp2O1z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=xz
	im8dXFI79ErmJdczGuAmJuzsHyH8+ZvemHiQTzCqA=; b=KAGp2O1zpwdFs4QtBf
	jE9BYc3/i8mH/EfuXErTSbpsINthcoMhbYbXAFev0rcauGbOqYj0RFe6d7Hyut/s
	moLro+PQBDQqULdVK8T5i2CKl9UugoK/gK7BCmhCBv58jAoiKwb7dW8DpUSI/Dfr
	SYujZhV3U80LAf/DaiMZcYnkY=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgB3WhlBvr9q6tuZCA--.61780S2;
	Fri, 02 Oct 2026 22:22:59 +0800 (CST)
From: Honggang LI <honggangli@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Honggang LI <honggangli@163.com>
Subject: [PATCH v3] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
Date: Fri,  2 Oct 2026 22:22:50 +0800
Message-ID: <20261002142250.657151-1-honggangli@163.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgB3WhlBvr9q6tuZCA--.61780S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Ar1DKr1fGw1rKr1DXFW5ZFb_yoW7CrWrpF
	W8Jw1Ykr4fXF4I9an7Zw4DZFWay3WDGasrGF9Iq3yYvF15CrWYgFnIkFy7uFW5GFyDGa1x
	tw12yryDGr43GFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRpOJbUUUUU=
X-CM-SenderInfo: 5krqwwxdqjzxi6rwjhhfrp/xtbC7ANKj2q-vkM0XAAA3q

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
v3 -> v2:
Rebased on branch wip/leon-for-next of tree
git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git

v2 -> v1:
Use u32 for must-be-unsized quantities, no unsigned-to-signed conversion

 drivers/infiniband/sw/rxe/rxe_loc.h  |  4 ++--
 drivers/infiniband/sw/rxe/rxe_mr.c   |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c | 17 +++++++++--------
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 7c3cc48e845c..e57861a62823 100644
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
 void rxe_put_skb(struct sk_buff *skb);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 615da4bb9a38..884e3953b870 100644
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
index 9f1c7f21d88d..c572cda8fe18 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -571,7 +571,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 }
 
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt)
+				u32 paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index ba3b2d23b36b..1b7f31737225 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -614,7 +614,7 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 }
 
 static enum resp_states send_data_in(struct rxe_qp *qp, void *data_addr,
-				     int data_len)
+				     u32 data_len)
 {
 	int err;
 
@@ -829,20 +829,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
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
@@ -936,9 +937,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
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
@@ -984,7 +985,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min(res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-- 
2.55.0

