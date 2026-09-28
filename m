Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBD54D2EC0;
	Mon, 28 Sep 2026 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602920; cv=none; b=VQiS/NorfYd6OE1HLz2BYX7noALzsFXPxT+8QoewjfU1kPI2VMd8LpES4DcFon4x1+Qjksm4ODg4cOshFO3po874elCS13Q8dgJaJzBB3JxZ5YcSflkwQVoLRkvQgP16lMO/zDdMFqbHdhWs4Z5urffsK2SDrtm8gIq4NliSMlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602920; c=relaxed/simple;
	bh=bXeX0RHnH6V7MUu04Xt6uO6r5ykNgEcagzLjywQ3SDA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=brUz2oF1LWOAv29jggZRQxIzSCysngZpd8Q/xcT5nZtEeogsBNBpoap+TGcd6qEk53PXPo5+XDulu8SbC5dcpd9nIA6JCq3SKi5WOE10k3C2tqpRdkJjE8JznCqWjP3HlxRlOIE8ZrC9ZkE7cTwDTqcmHH1SfDRf7/PONv6/xcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=KJ26t9Yr; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="KJ26t9Yr"
Received: from LAPTOP-99KJFSET (unknown [36.153.54.109])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f5d6f43e;
	Mon, 28 Sep 2026 21:41:52 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@nvidia.com
Cc: leonro@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Hongyan Xu <getshell@seu.edu.cn>
Subject: [PATCH] RDMA/hfi1: shut down the trap timer before unregistering
Date: Mon, 28 Sep 2026 21:41:51 +0800
Message-ID: <20260928134151.1213-1-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e84020c003a1kunmfc133760200222
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTkgfVkJIShhNH0lNTUJKTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlITVVKTkhVTk9VSktCWVdZFhoPEhUdFFlBWU9LSFVKS0hKT0
	hMVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=KJ26t9Yrau9/eqL4qdEgmFWzl6uxM8nENLwOFj2eCwyAiutVHM6173j78rlgjmn2uW/eklHIdxwwwx82rv1D1ayy1VifXlfvd64uJm0sR3WbQPgvZGugT6GJO7E9c750k1LL8D8Y2wT9A3aKT7NkBrPcoEhC7qbDLv/+6lzeQJ4=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=PrFlNbJAZooYrXoHr4dWB8uR/4vpNwAIJwGA3YshlGs=;
	h=date:mime-version:subject:message-id:from;

MAD processing arms a trap timer embedded in each hfi1_ibport. Device
unregistration does not stop the timer, so its callback can run after
the port and its containing hfi1_devdata have been released.

Shut down every port timer before unregistering the IB device. The
shutdown form also prevents a concurrent path from rearming the timer.

Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
---
 drivers/infiniband/hw/hfi1/verbs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e569b647d611..0ef3b1a89a53 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1888,6 +1888,10 @@ err_verbs_txreq:
 void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 {
 	struct hfi1_ibdev *dev = &dd->verbs_dev;
+	int i;
+
+	for (i = 0; i < dd->num_pports; i++)
+		timer_shutdown_sync(&dd->pport[i].ibport_data.rvp.trap_timer);
 
 	hfi1_verbs_unregister_sysfs(dd);
 
-- 
2.50.1.windows.1

