Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DD445D5C2;
	Thu, 24 Sep 2026 10:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244370; cv=none; b=FIlxR46MavQxKUCrafl2Oj6+FzSv6TgPhLoO2nD+9IZ9TLBJXXSiMsTBO9D+95k17yaCV3XMqkdPihNlS6Ej775w4sfGycu6LCKW2TgeWIt0Le/fdLCXTTI2unu1Jul7N0x7VVmKmqermfVxumS0ohWREy6FkFQ+5YmHk9EUQzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244370; c=relaxed/simple;
	bh=7Oq+vLT4tPPyoKtPdNE/V8miypJeJAkaurFnyGq9+Qo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aRYwa5la16GXNTwa5DJUFKqO0rqUWeH9dRn9GsxF5bQqtD/2UlItrBl/LO+OhAXUDH7PIaidUBQo38+FZJf9viKK+ClGCQZqc6+roZyXvLGD5HlTadZyaeuN/CEBDebERX5Mww1D42At6NBrhNTOGjob8M9DAjUect77wN7795w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=IxmMvvGw; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="IxmMvvGw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=wj
	qGdZ17LAj21U9xpGkUHVZhqMjNEKPTXYZxII6d1KE=; b=IxmMvvGwbxt/4lCY0j
	8Uz85z3DhAwMWvdWdar/6M1DbiaUJpTuVkZTAfPSU7+sOd+S2Qenh+x5YxudHBGz
	uUU7aiRG2UsqVZ8IYrN7/2CTxuZGtkLFGYBP0ybWTOO7T1tHMANnhT8StHvtPdnH
	FCWLztT53O3bw82gcbvaB2z4c=
Received: from pc.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDXxz7c9bRqdsOeBA--.22760S2;
	Thu, 24 Sep 2026 18:05:17 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Moni Shoua <monis@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Doug Ledford <dledford@redhat.com>,
	Amir Vadai <amirv@mellanox.com>,
	Haggai Eran <haggaie@mellanox.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] RDMA/rxe: Validate inline data range in user WQEs
Date: Thu, 24 Sep 2026 18:05:14 +0800
Message-Id: <20260924100515.502912-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDXxz7c9bRqdsOeBA--.22760S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4fGw4UAry5AF1Duw1xKrg_yoW5Jr4rp3
	y5KrWUKrWfJa13CF4DAa18ZFWFqwnxur1jgasrW3say3Z0kryj9asF9ryY9FW8JrsIka42
	qF15Zas7uwnxJaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pimhF7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8B98tmq09d8qsgAA3J

For a user QP, the send queue is an mmap'd ring which userspace writes
directly.  rxe_post_send() only schedules the send task for such a QP,
so rxe_requester() must validate the WQE before using it.

Commit 126c757e4cd46f866ddc283143b58eb4d9bf52cd ("RDMA/rxe:
Validate num_sge/cur_sge before indexing wqe->dma.sge[]") added bounds
checks for two members of the userspace-controlled dma structure, but
left sge_offset unchecked.  For an inline WQE, finish_packet() uses that
value directly as an index into inline_data[] and copies dma.resid bytes
from the resulting pointer into the packet payload.

A local user with access to uverbs can therefore put an out-of-range
sge_offset in the mmap'd SQ ring.  This can disclose kernel memory in the
outgoing packet or cause a vmalloc out-of-bounds access.

Validate that the remaining inline data range fits in the per-WQE inline
area.  Check the offset first and use subtraction for the length check to
avoid an integer overflow.

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
 drivers/infiniband/sw/rxe/rxe_req.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f..f3b3f65d1d0c 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -716,6 +716,15 @@ int rxe_requester(struct rxe_qp *qp)
 		goto err;
 	}
 
+	if (unlikely((wqe->wr.send_flags & IB_SEND_INLINE) &&
+		     (wqe->dma.sge_offset > qp->sq.max_inline ||
+		      wqe->dma.resid >
+		      qp->sq.max_inline - wqe->dma.sge_offset))) {
+		rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
+		wqe->status = IB_WC_LOC_QP_OP_ERR;
+		goto err;
+	}
+
 	if (rxe_wqe_is_fenced(qp, wqe)) {
 		qp->req.wait_fence = 1;
 		goto exit;
-- 
2.34.1

