Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0172BD58A
	for <linux-rdma@vger.kernel.org>; Tue, 24 Feb 2026 09:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771924107; cv=none; b=FEDY7qG3vAJga8lQHsfOyzgpmvfGyqGEXP/sma8gbgZbXVuv0puErTcxeX1K3m8+smsKClIiFRuYETJ7sBgWE98IwirCgRre/CobtuSpTwOWH+hQZovlK+QbYuemZV4JUsJQcugvMB+IuSR4bRzC748XZMPAYggnyS79UCo9mg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771924107; c=relaxed/simple;
	bh=X7VJCX39h5uTFnsyX8tvKyqayqWaiCjQZB+SGOeAspg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KNmeb9+3t2vWTE2uQ9hfw5i4sw2wvr0CTf7uaszSv8fp4cDFBOb+Yme4MFHmBMlcNvdz00GwVoNqGrgSiY7CgodocxXLXUJCbuRp7/NKyfGS/atmAqJ5chg4ZOgyrrpiIa+2YwH5C80OdnVA/EDRdh2zgbatsF6ygbeCgeBtWaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][rdma-next] RDMA/mlx5: Use NUMA-aware allocation for memory region descriptors
Date: Tue, 24 Feb 2026 04:07:57 -0500
Message-ID: <20260224090757.1761-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc13.internal.baidu.com (172.31.51.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The mlx5_alloc_priv_descs() function currently uses kzalloc(), which
allocates memory on the NUMA node of the calling CPU. On multi-socket
systems, this can lead to cross-node memory access if the HCA is
attached to a different NUMA node than the process allocating the
Memory Region (MR).

Switch to kzalloc_node() and specify the node associated with the
HCA's DMA device. This ensures that the MR descriptors are resident on
the local NUMA node, reducing latency for hardware access.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 665323b..5f4b4da 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1990,7 +1990,8 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 		add_size = min_t(int, end - size, add_size);
 	}
 
-	mr->descs_alloc = kzalloc(size + add_size, GFP_KERNEL);
+	mr->descs_alloc = kzalloc_node(size + add_size, GFP_KERNEL,
+			dev_to_node(ddev));
 	if (!mr->descs_alloc)
 		return -ENOMEM;
 
-- 
2.9.4

