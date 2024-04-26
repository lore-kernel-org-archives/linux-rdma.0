Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8190F146D69;
	Fri, 26 Apr 2024 13:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714137169; cv=none; b=dc8L3JGM5HEXRyFHG3C6MSbSzXK7eF4JaH9NKKnEyckgxHLKz6v3vMIerUqetETBJr9N3X5CFQLdLtfqB6zu3SncUvx+Lx6AByCwLq/PYiLmVdOgNNBjIFcWDkVsmg6IQOZGQqe+DkYJMGI7zv+eMtBSIKMY5XJRH5/0+KZDHv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714137169; c=relaxed/simple;
	bh=71RwQwi9TFTUPNDyPLmoKi09b5OBg6kwngITmrLKZ2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aOmLgGoV2vn4ui6UJox/ws8MkgJsJrvXTbmvCDIlHk+b0tAiqITFf7CvAixDNpvRzbyYklLECjXajlAR66n3PrLuZPnfyEvkow+brdeAuu+p3Z/sC63z9raV8G7DsJS84PQR4qVgkkeJB4h5gKOkznEOe/4exYMTX4u0RiHZfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mUjKyMn7; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mUjKyMn7"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 39D7C210EF29;
	Fri, 26 Apr 2024 06:12:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 39D7C210EF29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1714137166;
	bh=HfSrTbBlObJZ5QgMLDom1PtUczMN227beKLXYqpagmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUjKyMn7qOr7/Q+0ayG2nOy7nleg3db2XX5+gBFcQ7+i0kyuntO8WfMloWqgy0vtN
	 Ad/7NFleTrYKOvmaKR/OLa3pI1P+gyXL4KsBpfpwgTR16MdV3VIr55WQ+miwQOhtQI
	 sv698RBGFXQ18nymwLF+//vM7ol27Rs8cqLeqTjk=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	sharmaajay@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 4/5] RDMA/mana_ib: boundary check before installing cq callbacks
Date: Fri, 26 Apr 2024 06:12:39 -0700
Message-Id: <1714137160-5222-5-git-send-email-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1714137160-5222-1-git-send-email-kotaranov@linux.microsoft.com>
References: <1714137160-5222-1-git-send-email-kotaranov@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

From: Konstantin Taranov <kotaranov@microsoft.com>

Add a boundary check inside mana_ib_install_cq_cb to prevent index overflow.

Fixes: 2a31c5a7e0d8 ("RDMA/mana_ib: Introduce mana_ib_install_cq_cb helper function")
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 298e8f1..688ffe6 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -70,6 +70,8 @@ int mana_ib_install_cq_cb(struct mana_ib_dev *mdev, struct mana_ib_cq *cq)
 	struct gdma_context *gc = mdev_to_gc(mdev);
 	struct gdma_queue *gdma_cq;
 
+	if (cq->queue.id >= gc->max_num_cqs)
+		return -EINVAL;
 	/* Create CQ table entry */
 	WARN_ON(gc->cq_table[cq->queue.id]);
 	gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
-- 
2.43.0

