Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BA3B2FD9;
	Mon,  8 Jun 2026 08:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780909001; cv=none; b=IhlSe/UTJoE7PWtIFsNPKYcE/LnmByvJrtGD9uZjV20kFgSFjObL66+YgvpJxF63RFXTLQDhBXstVH0IkMUtaCYN+rRBM4HnLL9oKmiNUIdGypyw+/hnkwHv/IrexcDJPycVayP+z+6VjMJgBW5PXhwSCqB0i/Qsua6KA9Np9bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780909001; c=relaxed/simple;
	bh=V8YyLbC29J+xHZiuI3J0B1RohcgYzmcTezj17IaNcw4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mu2acgBT6VYxOVoNvUty92GoEM4vCVc9WxCXwPg9LhoT/TNdloU2urZBew84YEJXllsSreagkqKFzQ6Y+htQsKnpkJtlTs5SgRgZYr3GC8Z6SQJPWNmKrBSGVxA7MJFuxEvhDhve2DG+k5CqlQUtX2eeWnDuODdXH3S/CQX1luM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACHLtfAgyZqgdbhAA--.5522S2;
	Mon, 08 Jun 2026 16:56:33 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/core: fix refcount leak in __ib_alloc_pd()
Date: Mon,  8 Jun 2026 08:56:25 +0000
Message-Id: <20260608085625.138331-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACHLtfAgyZqgdbhAA--.5522S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr15ZF47tFy3Xry3ZrWkWFg_yoW8Xr4Upr
	Z8J342yrWDCF4fCw4Uta4UAFWFkayrArW5W39akwnIvFn8ursayr95Ja4agr4kAr9rGr4I
	vrs0yr43KF4xCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbYFAJ
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgwMA2omaa0jsQABse

The error handling in __ib_alloc_pd() has a refcount leak.  When
get_dma_mr() fails it calls ib_dealloc_pd() which invokes
ib_dealloc_pd_user().  If the driver's dealloc_pd operation returns
an error, ib_dealloc_pd_user() returns early and skips both
rdma_restrack_del() and kfree(pd).  This leaves the resource tracking
kref held and the pd memory unfreed.  Because ib_dealloc_pd() has a
void return, __ib_alloc_pd() cannot detect the failure, so the leak
persists.

Fix it by always calling rdma_restrack_del() and kfree(pd) in
ib_dealloc_pd_user(), even when the driver callback fails.  This
ensures the software state is cleaned up regardless of the hardware
operation result.

Cc: stable@vger.kernel.org
Fixes: 91a7c58fce06 ("RDMA: Restore ability to fail on PD deallocate")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/infiniband/core/verbs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac87de9cc67..6437ede11908 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -398,8 +398,11 @@ int ib_dealloc_pd_user(struct ib_pd *pd, struct ib_udata *udata)
 	}
 
 	ret = pd->device->ops.dealloc_pd(pd, udata);
-	if (ret)
+	if (ret) {
+		rdma_restrack_del(&pd->res);
+		kfree(pd);
 		return ret;
+	}
 
 	rdma_restrack_del(&pd->res);
 	kfree(pd);
-- 
2.34.1

