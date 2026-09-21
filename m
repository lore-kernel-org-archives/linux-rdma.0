Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 63BF0331EB5;
	Mon, 21 Sep 2026 03:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789962030; cv=none; b=B7Ylwaa68hzytEVo3djWGA21fnDm+LpVibVDy86ouKulA6BBLlPTZlscRTGTa8JsV8XYmrZ3eN8w4urwd4u0/nrTnFhXjn7DyMFy1JMIJRZUm/giuVT2tECLykjDALAm0HpRIYdgO49a5iG4elbwfSe28QNu0BCxTNpZ1hJs+Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789962030; c=relaxed/simple;
	bh=zFSc73ByU5dvbW48g0HgFzom4E+XKXGbY//slp92TM8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=d1FStdIVxttJz0yWGMlBjJJTdFGhq6zvdJoxQqqZmcYsGpeE/D9KnH4dc5xpl0Xd3aUp91wvih0HdIy5+IpIamjUTl4kr+F+dcLk6hnSjB1d8dov6tqb0B5KlImKsJGF0y0+4fPYV2FCTrarKvfrJF+cEfFlfGhbjBwOx4UyIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=d+JWlAFz; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="d+JWlAFz"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Jenny
 Derzhavetz <jennyf@mellanox.com>, Doug Ledford <dledford@redhat.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/iser: Unmap Data-Out header DMA on send failure
Date: Mon, 21 Sep 2026 11:39:49 +0800
Message-ID: <20260921033949.1803-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc8.internal.baidu.com (172.31.50.52) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789962016;
	bh=/eJTJQWvSCed/B3fvVg859B7AD9IdJ+KSlC6xZuw16A=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=d+JWlAFzvanA+r6Nbu3gmW6Sue4kvKLVgz4BzYnxYC7SfteA25iMwjIsuu773crGy
	 FReXRT4ghUXCDiMWcPeVlsNXZKZs3cQPqPIt5IKe1ByASmD+/QO2dxBf32K/1Q9aLS
	 3ew7ZlKZS6gXdP0LfUKBhCOlDdXt60A9QRGbIwO7q6iNQu3v5q8U5N1oj4bMP4yfcZ
	 8tFhqmuAFw0PRQSd3VRfbdex2oeOYUyaLDIXoDKD23tZ8ECZuWPxwnEYmW19i8dS5p
	 lZM2bPdiDkTJdViTBhLkxPURWe8UUF79WYGUvbprGII1xTt9Edd47UvHba4aktM1X1
	 BHu4d9rF8ZxbQ==

From: Li RongQing <lirongqing@baidu.com>

iser_send_data_out() maps the tx_desc header for DMA via
iser_initialize_task_headers() (which sets tx_desc->mapped and calls
ib_dma_map_single()).  The normal completion path hands unmap and free
off to the iser_dataout_comp() completion callback.

However, if a later step fails -- the bounds check
(buf_offset + data_seg_len > data_len) or iser_post_send() -- control
jumps to send_data_out_error, which only calls kmem_cache_free() without
ib_dma_unmap_single().  Because the WR was never posted, the completion
callback never fires to unmap it, so the DMA mapping is leaked.

Unmap the header DMA in the error path when tx_desc->mapped is set,
mirroring the pattern already used in iscsi_iser_cleanup_task().

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/ulp/iser/iser_initiator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 7ea6888..9685e0a 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -464,6 +464,10 @@ int iser_send_data_out(struct iscsi_conn *conn, struct iscsi_task *task,
 		return 0;
 
 send_data_out_error:
+	if (tx_desc->mapped)
+		ib_dma_unmap_single(iser_conn->ib_conn.device->ib_device,
+				    tx_desc->dma_addr, ISER_HEADERS_LEN,
+				    DMA_TO_DEVICE);
 	kmem_cache_free(ig.desc_cache, tx_desc);
 	iser_err("conn %p failed err %d\n", conn, err);
 	return err;
-- 
2.9.4

