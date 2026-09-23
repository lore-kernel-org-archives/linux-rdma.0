Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id AC937468C28;
	Wed, 23 Sep 2026 08:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.3.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790151318; cv=none; b=YN4vnXEZ4v0bqR7wbsZ7wuv6Gpzq+Q5DNk4bidXk0eaIS1F1nPrZyGmcgGaV95ji8al38qlmBSlXYApObM5Q26jF4a/gF9O7fGitLls9Bg6+CXTR0uuxsGOdw/siXoZf1gXz1mc3AZHDYrkgW0BNP71f/kheAaI3+x2UjC8od4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790151318; c=relaxed/simple;
	bh=cUlRkQSrFkQP46KfQS5RmYTcBEiQhp/R1lfVhX9ZYUE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AkG79lNc76wRZI5EnSsOThAx/HsGz4K/XZh55NJ/xJvutuSlyI1/XHcjfRvT/sNnD4ZD6CwQolAGblD9sAZjV3egIFUeJATfOerKgAA/gGeOpQc6FJThCVUEZY1TYeIY0FK9yTYHcH64fMVfr9WhrmMoK3KW6B/cRHsbO8gGrYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=VGEROovM; arc=none smtp.client-ip=220.181.3.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="VGEROovM"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] RDMA/mlx5: Unbind data direct device on IB device unregister
Date: Wed, 23 Sep 2026 16:14:42 +0800
Message-ID: <20260923081442.2520-1-lirongqing@baidu.com>
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
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1790151303;
	bh=wP/8Zs1UvN7ZV3Tmp06VjiXmF23YNcg9uGQ7o26GR4g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=VGEROovM1deDAqwJKx6Qg4gbD3RMAzinyibZRSdscNa3ZVCHcoNV6f36OZldu4oMW
	 /NUcEc7QMDufFp9LCuWvL+/B4tgJVoTUM8oGIW0TqTqi7UzTXIzb07p4ayAA7qsHhA
	 CWEyUJu3gqWV9OieYWtijcN5DCvbP5BSr8H09DsLyLJUjGyNzD+cAZcwUBhx0YWFsZ
	 cL584txmgK0bMVdDjFaYFdtbjN3zza3KSQ2jJxmRfeNv5vqReL55ZqboWvvKr57zIC
	 xF4SGJfzcDKrWrCfla/fPWvlrLpgW9T99vUJ5x8AQCIPsR/2esnsZTlESgDg8uuUrR
	 iVz7+vjFfWGRQ==

From: Li RongQing <lirongqing@baidu.com>

mlx5_data_direct_ib_unreg() removes and frees the registration entry
but, unlike mlx5_data_direct_dev_unreg(), does not call
mlx5_ib_data_direct_unbind().

As a result, when an IB device is unregistered while its affiliated
data-direct device is still registered, its data_direct_dev pointer
is left set and its data-direct MRs are not revoked.

Call mlx5_ib_data_direct_unbind() before removing the registration so
that the data-direct MRs are revoked and data_direct_dev is cleared
during IB device teardown as well.

Fixes: 6910e3660d86 ("RDMA/mlx5: Introduce the 'data direct' driver")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index d574842..54c07ac 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -113,6 +113,7 @@ void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev)
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (reg->ibdev == ibdev) {
+			mlx5_ib_data_direct_unbind(reg->ibdev);
 			list_del(&reg->list);
 			kfree(reg);
 			goto end;
-- 
2.9.4

