Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2D2242D76;
	Wed, 25 Feb 2026 08:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772009531; cv=none; b=F7pl5eXW3wUToeWEoi10zm5FCdM5RjNFfe0pIxwcsqPgXcXPW1eEKvwmbq6WADc5kehCtXf/meGiFICOJPbCh4O4h9+jJtL2OI5O8g8pqscrnTHO78/VSQOuGwRkx2/anb7LSMXN9dDEAzR903b3XYac8ciGYNh6hXC0T9nocCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772009531; c=relaxed/simple;
	bh=+pnO8PjjroyFg6yqnFKX+PEXdpjvflB7MLEUTIKD8N4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hwS08ZLzyq4KvbPFLWea2VvdZeEJKtnv+gApLepMtsT6LR1ItedGr//IVBe6t/5z3mboLCEV7DzDgohdfHgg8RftxizBBZHeuEQV0lOTgd3uB0HacEKeADAcJWPb8cx5XRK+yrYV0C/5aKYvXDQgw01BORa1d8Cd95dkkEcNSkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Cheng Xu <chengyou@linux.alibaba.com>, Kai Shen
	<kaishen@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][rdma-next] RDMA/erdma: Use NUMA-aware allocation for MTT tables
Date: Wed, 25 Feb 2026 03:51:43 -0500
Message-ID: <20260225085143.1721-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc13.internal.baidu.com (172.31.4.11) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

Currently, MTT (Memory Translation Table) buffers are allocated without
NUMA awareness using kzalloc() and vzalloc(), which allocate memory on
the NUMA node of the calling CPU. This can lead to cross-node memory
access latencies if the erdma device is attached to a different NUMA
socket.

Switch to kzalloc_node() and vzalloc_node() to ensure MTT buffers are
allocated on the local NUMA node of the PCIe device (dev->attrs.numa_node).
This reduces latency for hardware access and improves performance.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 9f74aad..58da6ef 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -604,7 +604,7 @@ static struct erdma_mtt *erdma_create_cont_mtt(struct erdma_dev *dev,
 		return ERR_PTR(-ENOMEM);
 
 	mtt->size = size;
-	mtt->buf = kzalloc(mtt->size, GFP_KERNEL);
+	mtt->buf = kzalloc_node(mtt->size, GFP_KERNEL, dev->attrs.numa_node);
 	if (!mtt->buf)
 		goto err_free_mtt;
 
@@ -729,7 +729,7 @@ static struct erdma_mtt *erdma_create_scatter_mtt(struct erdma_dev *dev,
 		return ERR_PTR(-ENOMEM);
 
 	mtt->size = ALIGN(size, PAGE_SIZE);
-	mtt->buf = vzalloc(mtt->size);
+	mtt->buf = vzalloc_node(mtt->size, dev->attrs.numa_node);
 	mtt->continuous = false;
 	if (!mtt->buf)
 		goto err_free_mtt;
-- 
2.9.4

