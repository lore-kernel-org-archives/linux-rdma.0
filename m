Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795426011;
	b=qPzjdUccR6N1oOsmaR0tfhHcADeEvoNxC30cCy0P+z9pN9Jw5QUKL8toR6WNC23Oy4oL
	 7BG5KTeDzrWnjvIe0sC60LiWZb5Wn1JwpRNr6axuq0UVVzt69shwvvXI/HNbQKbecSA5e
	 T4gDsCC6TwozrnN8O6kOL+bztKh27vlyCszkJ7S7Y2EaEIW7fwc/OXIdgj1JVqB8eSYwx
	 Y7xFY4NWsVIvwF9rV+d6GjujPjtaiykkHFnGqVQjP4U1r3268PRmNz7wFzcl6XT9TVWAf
	 W+NEWW+FtlOCOeVbYE34Xl8lUA2puYSu22kY8goOY00czu5Rnp1hYo91BhtUyjLVxMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795426011;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:
	 X-Mailer;
	bh=czfx09lVEJ+5qbSUxtIYbjWuSXbhH8LThXJ7vZTPIOM=;
	b=S5tqcnQoxbek271qr3Wulbyy4tTwg81V/KdbkxVeoFgj9jCWOwAF7B+11XWGOXScX6I6
	 d70Ug+mItGhqEvzRPqpzR3s8cXcbg5yr43CtJxuf75CgIGoUwzdnLcJ076+6pMWO6dyMC
	 80rqgZ2QP7zedlnQQfXrfeTfGaBm8lyqo0lDPBAoBJBoLLLTL0Wju30jTk4m1ETAQcPFf
	 T1hS8V5JQ6Qh6b8Ml7V3eCKNUtnPDgVboxljQOuLTBTTCb3IFxworusS0gtjfaWLccVtl
	 3ZOpVje9jJmDMeGnOQOukb4GivIlApmEWF3GeQVTuxKNjL8jCtqN5gLEB7ltfxbNxpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QBIsBHeG;
	arc=none smtp.remote-ip=91.218.175.87
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C766606A321
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 09:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C766606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QBIsBHeG
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g5DXUn2a5VY10LYZ28Rn2x9UC5KFh89OzpiCFa3tU90=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795426008; v=1; x=1796030808;
 b=QBIsBHeG7lHzJ8+PNgp7D176lstmiRez7/rrX9vx1lt+k5wi2O6Fte4uMGymfDgNwYbzDE3P
 N2Tco4AwtPjBJb6MAXVNAupZIP+CQUhRCMB84mAhSXvlvQdpxvm4s2pS+rELEY998ATiszL+LpH
 tYfEgDGbpN4wOGaB6FT2bwqA=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 918bf4bc19c1858d;
	Mon, 23 Nov 2026 09:26:47 +0000
X-Mizu-Trace-ID: 918bf4bc19c1858d
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 23 Nov 2026 04:26:42 -0500
Subject: [PATCH for-rc] RDMA/rxe: Allocate the MR page array with
 kvzalloc()
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-bug-rdma-rxe-large-mr-v1-1-8d0748ac4a3f@linux.dev>
X-B4-Tracking: v=1; b=H4sIANEGBGsC/x2MwQqDMBAFf0X27IJJ1Lb+iniIZmMXqpYXWgTx3
 w0eB2bmoCRQSdQVB0H+mnRbM5iyoOnt11lYQ2aylW2NsY7H38wIi2fswh+PbCzg+Gisr1/h6dq
 GcvuFRN3vb09xA2Oi4Twvub+JWm8AAAA=
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Li Zhijian <lizhijian@fujitsu.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

A user MR keeps a struct rxe_mr_page, 16 bytes on 64-bit, for every
PAGE_SIZE page it covers, in one array allocated with kzalloc() when the
MR is registered. Before the array, the pages were kept in an xarray.

With 4 KiB pages, the array of an MR larger than 1 GiB exceeds
KMALLOC_MAX_SIZE, so registering it fails with -ENOMEM, and the first
attempt warns:

  WARNING: mm/slub.c:5459 at ___kmalloc_large_node+0xe9/0x130
  Call Trace:
   __kmalloc_large_node_noprof
   __kmalloc_noprof
   __alloc_mr_page_info
   rxe_mr_init_user
   rxe_reg_user_mr

Allocate the array with kvzalloc_objs() and free it with kvfree(), so
that MRs of any size can be registered again.

Registering an MR over THP-backed memory, median of 3:

  size     before (ms)   after (ms)   change
  1 GiB            5.3          5.2      -2%
  2 GiB        -ENOMEM         10.8      n/a
  4 GiB        -ENOMEM         21.1      n/a
  16 GiB       -ENOMEM         85.9      n/a

Fixes: 12985e5915a0b ("RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE")
Cc: stable@vger.kernel.org
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 13cb28d3916f6..fbf4d89947383 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -157,7 +157,7 @@ static int rxe_mr_fill_pages_from_sgt(struct rxe_mr *mr, struct sg_table *sgt)
 
 static int __alloc_mr_page_info(struct rxe_mr *mr, int num_pages)
 {
-	mr->page_info = kzalloc_objs(struct rxe_mr_page, num_pages);
+	mr->page_info = kvzalloc_objs(struct rxe_mr_page, num_pages);
 	if (!mr->page_info)
 		return -ENOMEM;
 
@@ -186,7 +186,7 @@ static void free_mr_page_info(struct rxe_mr *mr)
 	if (!mr->page_info)
 		return;
 
-	kfree(mr->page_info);
+	kvfree(mr->page_info);
 	mr->page_info = NULL;
 }
 

---
base-commit: e7732ec135b501e87ab060d992b3b5f2ec4396c9
change-id: 20261123-bug-rdma-rxe-large-mr-f752a49d8365

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>

