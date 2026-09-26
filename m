Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9E734DB41;
	Sat, 26 Sep 2026 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790406279; cv=none; b=Zahf0UVgA/tCt/DJbh5orUoJ1/AmyESAYuoWgbYEXm5d+kPKzTXR/Qbc5sZBscQxigqrdlb+YrGMcBwRZxytt3Xijb/RvtA5qAogqfTg2jmho4vZx4DWGqp7dyU3VeVn85y7OtxyhvbqGDzjrmCRq1RMM1C9K2dg9brciykKFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790406279; c=relaxed/simple;
	bh=klEuKHpXjgAqTY3r+p2aQa+Aono8lHWPfIaYLd7FLSg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ThjvYqpYvDohz/Yp/E5p/l6vTxEuRBYeCSzQb3o7yAOYbGeeW07MC2XIoM2r7e+PMbISrqJdatzAqU018VnEsLfPqneAJmy9KdBub03xwSQ1fwlg0KnkZ0F+Hn6yXYkcwDOxDb+qQ5h+7PTYZYqQgyijj4eFHdiKpz95lg68HbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=StRGiEaI; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="StRGiEaI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Bs
	hm+rtOuEV3Ddh1R5bOiU0hQtJQ3+k2BHzQb7InIyM=; b=StRGiEaIKSabYYHhmP
	ijF/tl7K3jFktAGRcU1Cz/tlDTdf2Om+UlEOdXPndNIcFIDkbhyzOvhSkQ2VcyC5
	ObhpZUeVCEV0V93vh9QY9Su5MzcAJOhYm6wXxaLuTbUc1agKq8brCE9jLz1YWy6w
	ikJSVvnEqp718cE2aQFbcuYPo=
Received: from pc.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgC3nIVkbrdq_pnhBQ--.30025S2;
	Sat, 26 Sep 2026 15:04:06 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Doug Ledford <dledford@redhat.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH v2] RDMA/rxe: Validate inline data range in user WQEs
Date: Sat, 26 Sep 2026 15:04:03 +0800
Message-Id: <20260926070403.3005250-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgC3nIVkbrdq_pnhBQ--.30025S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFyUCFyxZr4UAF4ftF4DCFg_yoW5trykpF
	W5GF1DKryfta1fGr4qvFsrZFWft3WDAr17KF9Igwn2v3Z09r1qva9Fvr1j9a48JFn3Ca47
	tF15Xa98u3W7taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pimhF7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wg+eGq3bmgNSQAA3+

For a user QP, the send queue is an mmap'd ring which userspace writes
directly.  rxe_post_send() only schedules the send task for such a QP,
so userspace can also change WQE fields while rxe_requester() processes
the WQE.

Commit 126c757e4cd46f866ddc283143b58eb4d9bf52cd ("RDMA/rxe:
Validate num_sge/cur_sge before indexing wqe->dma.sge[]") added bounds
checks for two members of the userspace-controlled dma structure, but
left sge_offset unchecked.  For an inline WQE, finish_packet() uses that
value directly as an index into inline_data[] and copies dma.resid bytes
from the resulting pointer into the packet payload.

A local user with access to uverbs can therefore put an out-of-range
sge_offset in the mmap'd SQ ring.  This can disclose kernel memory in the
outgoing packet or cause a vmalloc out-of-bounds access.

Since sge_offset comes from shared memory, validating it in
rxe_requester() and then reading it again in finish_packet() leaves a
TOCTOU window.  Copy it into a local variable in finish_packet(), validate
that local value, and use the same value for the copy and update.  Check
the offset first and use subtraction for the length check to avoid an
integer overflow.

I reproduced this on Linux 7.3-rc4 with an RC user QP, IB_SEND_INLINE,
a 64-byte residual length, and sge_offset set to 0x100000.  KASAN
reported:

  BUG: KASAN: vmalloc-out-of-bounds in rxe_requester+0x1f27/0x4940
  Read of size 64 at addr ffffc90000191250 by task kworker/u16:0/12
  Workqueue: rxe_wq do_work
  Call Trace:
   __asan_memcpy
   rxe_requester+0x1f27/0x4940
   rxe_sender+0xe/0x30
   do_work+0x184/0x3d0
   process_scheduled_works+0x7c0/0xf10

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcode.ai/
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
V1 -> V2: Copy sge_offset from the shared WQE into a local variable in
  finish_packet(), validate that local value, and reuse it for the memcpy
  and update. This closes the TOCTOU race reported by Sashiko.

 drivers/infiniband/sw/rxe/rxe_req.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f..f7e59805a664 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -503,6 +503,7 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 			 struct sk_buff *skb, u32 payload)
 {
 	int err;
+	u32 sge_offset;
 
 	err = rxe_prepare(av, pkt, skb);
 	if (err)
@@ -510,12 +511,19 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,
 
 	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
 		if (wqe->wr.send_flags & IB_SEND_INLINE) {
-			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
+			sge_offset = wqe->dma.sge_offset;
+			if (unlikely(sge_offset > qp->sq.max_inline ||
+				     payload >
+				     qp->sq.max_inline - sge_offset)) {
+				rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
+				return -EINVAL;
+			}
 
-			memcpy(payload_addr(pkt), tmp, payload);
+			memcpy(payload_addr(pkt),
+			       &wqe->dma.inline_data[sge_offset], payload);
 
 			wqe->dma.resid -= payload;
-			wqe->dma.sge_offset += payload;
+			wqe->dma.sge_offset = sge_offset + payload;
 		} else {
 			err = copy_data(qp->pd, 0, &wqe->dma,
 					payload_addr(pkt), payload,
-- 
2.34.1

