Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97EB2D9EDB;
	Fri, 11 Sep 2026 06:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106963; cv=none; b=LuO+jAd6dt6tLbLvyw6XRDofkvvdL3QoAsO9/x+zMlJQYfUuZty6g2r/r+iNfLBolIrwqWeRqBCUJ4T3R/dnMLKVuAtn31zq/tGxgpO/RwiFYwtNHKGn6GHiQaVfPzvKvY0ure8ADb/QN09HUzX8XPDwoE0QmYUmZVAddR1Uf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106963; c=relaxed/simple;
	bh=hMAOndQstB9jaeB87Kst5wgSrHGWGAzMoe7vgDnmoW8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=huiXINfQBGPte66dyvyiT98ZgEwO8obdXh715EKoQSorGdtXA3a3c8xyyFZfSXFzHc2kYDFqXealuNvJcGNUre4S7GIVmgGXgvdc1FpKfUDk9yP4Cwgl+PYHY4awvBVP7ubnYnEI/utJev0MMCg6X9aoqUk/fcAaUO6DCxxEe4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=LlRFgjFu; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="LlRFgjFu"
Received: from seu.edu.cn (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d62c4fab;
	Fri, 11 Sep 2026 14:09:11 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: tatyana.e.nikolova@intel.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH RFC] RDMA/irdma: check vport device allocation
Date: Fri, 11 Sep 2026 14:09:09 +0800
Message-Id: <20260911060909.94219-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa08f1592c203a1kunmeb1546831c7326
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHhpMVkxMQk9KTxpKT0weGlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSU
	hOQ0NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=LlRFgjFuqIbeEO+tT7k8XJZO9eEy4Na1/KdlsMPxTme9jCwT4e74FD1kTWT4ZfPKVrFpOuXjFTdhPVOr+nQfGqQdDYDglaiNezm/ouGPPgvOXprKq0MMuEaSliQsP+4oISFEGRB0KZcxmeXLkslvlFzLBQ5yngT1I0I8VNo/ijo=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=FzoTm1DeV8BT7ix80HmrQ+s7jx4kGWKwr2kYUyysO7M=;
	h=date:mime-version:subject:message-id:from;

An existing RDMA function does not guarantee allocation of the new
vport device. Return -ENOMEM before initializing a NULL iwdev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 2ad49ae7330b ("RDMA/irdma: Introduce GEN3 vPort driver support")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/infiniband/hw/irdma/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/main.c b/drivers/infiniband/hw/irdma/main.c
index 95957d52883d..106915b51e7c 100644
--- a/drivers/infiniband/hw/irdma/main.c
+++ b/drivers/infiniband/hw/irdma/main.c
@@ -80,6 +80,8 @@ static int ig3rdma_vport_probe(struct auxiliary_device *aux_dev,
 		return -ENOMEM;
 	}
 	iwdev = ib_alloc_device(irdma_device, ibdev);
+	if (!iwdev)
+		return -ENOMEM;
 	/* Fill iwdev info */
 	iwdev->is_vport = true;
 	iwdev->rf = rf;
