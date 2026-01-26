Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25588311C19;
	Mon, 26 Jan 2026 07:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769413715; cv=none; b=rKO3mbcVeOiwnrGMCXPC+/sRO+QbpJ6Pxc5gmyjKtE2MHavlz8NM1iJRYpAOgkCgysvZ8CbQn7Ok2nkYsEswMgLAbM3r3LhN+MzxLiD43VYaF4Q93mpMRv9ipHGgXJF5JCqavwt0iW5qPxMC9F0nwcK6z7inwbF5IhQYw1T+4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769413715; c=relaxed/simple;
	bh=y+IpNS5tg/yzDy5rk9ieuu6rqDhiMXnhxW0Y8RxarRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ayPgUczEQWpiJ86f3ljuohyR745moHK4xHIR4TZCsnVZrpIkYakchkqfq16Atkt4qbEt33rFi7lhwZczuHV98XAZvnJZfam5iAI2hPLyLb7kVAh8+fTkc86jo7OFyNhA75FAS66K8jqN/SASrgjMaqLFQU/dhJ/NdBJfK0NpuE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=bnDY2TLp; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="bnDY2TLp"
Received: from LAPTOP-N070L597.localdomain (unknown [81.31.232.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 31f66bd9d;
	Mon, 26 Jan 2026 15:48:20 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	yishaih@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler
Date: Mon, 26 Jan 2026 07:48:01 +0000
Message-Id: <20260126074801.627898-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9bf946681303a1kunme479b18a12fb99
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTx4fVk9PS09KTUwfSB8YQlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlDSlVISlVJSElVQ01ZV1kWGg8SFR0UWUFZS1VLVUtVS1kG
DKIM-Signature: a=rsa-sha256;
	b=bnDY2TLpVwOU6r4s9jTmqC70UK1vDoWxGo1QNP1WR2ndb5Ql8+X5FYRIYWnev7ZbxQiOm6JLQywquilBdWlJ3gpvS9lk3S11+z8C67ESHpwiEJl39mHOIdTbh5R/tL+LqQ0KTzKVohOmzqq1ls3BdDnXF+ZtGjFqGNmHuwArr78=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=Ltq57aFHG+GYUrukETVUy2NpvmINKB8SHEwIQmVX7u8=;
	h=date:mime-version:subject:message-id:from;

The UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH) function
allocates memory for the device path using kobject_get_path(). If the
length of the device path exceeds the output buffer length, the function
returns -ENOSPC but does not free the allocated memory, resulting in a
memory leak.

Add a kfree() call to the error path to ensure the allocated memory is
properly freed.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: ec7ad6530909 ("RDMA/mlx5: Introduce GET_DATA_DIRECT_SYSFS_PATH ioctl")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/infiniband/hw/mlx5/std_types.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index 2fcf553044e1..ed4f5abb63c8 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -218,6 +218,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 	dev_path_len = strlen(dev_path) + 1;
 	if (dev_path_len > out_len) {
 		ret = -ENOSPC;
+		kfree(dev_path);
 		goto end;
 	}
 
-- 
2.34.1

