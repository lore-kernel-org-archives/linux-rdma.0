Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E8D37DAB1;
	Tue, 15 Sep 2026 06:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454768; cv=none; b=DOBWX1PxjqWgBcmqXPAqp9AMEbscA+yX/i7436pcJ9EIVATdyPeo1V5LIyy/jizRzkqtTnYQx9owBTT1OWwDS78+HdBIWNt0Fts+PxJbrc4C45gjNqs8zB3Anvdd+jzAHTWEGKvkLfAZqEz3Gkg59mqtu6fYmmu+4LP5UGqRuuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454768; c=relaxed/simple;
	bh=u2a1kD5QeSCOwabSYJvAoBl/nzH3YGyMw+jA1XMQtwE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uLuGg0zR8914t3D8Tu+6KFjPlsWqkyQxRcmjYefWZOAI8xhTmKu4ndsteMhDx2Zo26ep43nGNibp+PBjN6oKv4TQA7i2mm6/EhaOwPNEjoxFkhOQVZ83bRQW9Oe0/QHwCjPQpHm/VpI6m2M3hcdNyGaM3REuBTYQyV1Qqy8/f2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=b4u/Ye7/; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="b4u/Ye7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qC
	tKwumXtXrHO/EcKrgKeUUBUsozyn9QzEcaWhQqRz0=; b=b4u/Ye7/RapBRenETF
	cUr8/bxqa9a9Le9N/Mk7GcXT7fEnJIRn41Wx3h+FOKInwL34AeJDZuTJl5b/1FXL
	lKzHZQjCKenMF20puh7ThzQ9GK7pUYGo4Dh+jDLIl7CKlFnwuP7bXvKsDiMAYvAX
	u/BS7csc7F8vT2H1lS3h1DWDk=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgBnD7uZ6ahqHNn5QA--.42338S2;
	Tue, 15 Sep 2026 14:45:46 +0800 (CST)
From: Honggang LI <honggangli@163.com>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Honggang LI <honggangli@163.com>
Subject: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size
Date: Tue, 15 Sep 2026 14:45:32 +0800
Message-ID: <20260915064532.194540-1-honggangli@163.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgBnD7uZ6ahqHNn5QA--.42338S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrW7CrW5Kr1kZrWUWw1fXrb_yoW5ZF1xpF
	W8Aw1Yyr4fXF429Fs7Zr4UZFWYyanxGa4DGr9Fg345ZF15urWj9FZIka47WFWDJFWDGa1I
	g3W7A34DCr43GF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wXUUUUU=
X-CM-SenderInfo: 5krqwwxdqjzxi6rwjhhfrp/xtbC7Btlqmqo6ZuTZQAA3+

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
greater than resid. Change resid to int64_t fixes this issue.

RDMA SEND and WRITE 2GiB message works too, after fixed these two bugs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
---
 drivers/infiniband/sw/rxe/rxe_loc.h  | 2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c   | 4 ++--
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..9acf2494bb94 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,7 +64,7 @@ int rxe_flush_pmem_iova(struct rxe_mr *mr, u64 iova, unsigned int length);
 int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr,
 		unsigned int length, enum rxe_mr_copy_dir dir);
 int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
-	      void *addr, int length, enum rxe_mr_copy_dir dir);
+	      void *addr, int64_t length, enum rxe_mr_copy_dir dir);
 int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 		  int sg_nents, unsigned int *sg_offset);
 enum resp_states rxe_mr_do_atomic_op(struct rxe_mr *mr, u64 iova, int opcode,
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..1a9005f11079 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -418,13 +418,13 @@ int copy_data(
 	int			access,
 	struct rxe_dma_info	*dma,
 	void			*addr,
-	int			length,
+	int64_t			length,
 	enum rxe_mr_copy_dir	dir)
 {
 	int			bytes;
 	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
 	int			offset	= dma->sge_offset;
-	int			resid	= dma->resid;
+	int64_t			resid	= dma->resid;
 	struct rxe_mr		*mr	= NULL;
 	u64			iova;
 	int			err;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8..52bce17511dc 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -982,7 +982,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min_t(u32, res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);
-- 
2.54.0

