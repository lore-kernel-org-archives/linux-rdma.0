Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795251712;
	b=QTLj68u68rHlCNwXCqSwZXMW2Sr6zdsKhS0RMVEm8md6W1y6QCOJK+ORxvj9wtxYDkhB
	 E9apRGXBKbw8yVMX5tTonn3m9MOKdpe7IQ2ud2EWRM+/+WUDuqcmBrqG/AYagiYJPcTIE
	 FVY+PSLEfZ+SRX3cMBCGMGrOiX9gOT4v07xA+8FFJh+Rwc0GYvgWsI22Ioh+/nHMfph3q
	 HMoOY8ccuXz1p9wsmrAYqoaWqG+zHtFkmqGPq1HTPMS6kOiLScekueaaCsQPN0tu5Jcq9
	 yUozquUaM4DBtzPl2jScN7hP3f6nutMDiV89vB7jipbLDmlK9bHlEpTCmNM4uXsN0kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795251712;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=2iBmeIM6hs+movxRA5ZaXHC2On6Cfl3EL4WF0DR+NjE=;
	b=Yk1/wDbyODcuMdYcVhnVhNZgQStpe8spbkjy/nLoQqK5QvS70FuIaVG/ce2mxefg7ioE
	 xNYmGN8NAwPMHBehnR57skDbWfNDKpXvYYkCIaxgX9wTzmx7tvj9eN2Aqc5/mCNZT5mZY
	 VF2lVeP/Fxma7TyetQAjeWWcJ+s3SpPRYw8EMjsz1+glZXntM1Yj3m+ZQaRDGWMAiM8uS
	 +BAjGdfrKSyitSF0P8sugH5QTUVDrOil0KJIMxeVgtvYFl1a0cWL4OzQGlbSNUpBcvqDp
	 9fwvoRVjdopvp/lhihxByIC1mx5wxKPto2sJoqnz8pxSG+6EQUVIHPLHTpP7mttPXYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=SNPSvjYI;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10269606A325
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 09:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10269606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=SNPSvjYI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2i
	BmeIM6hs+movxRA5ZaXHC2On6Cfl3EL4WF0DR+NjE=; b=SNPSvjYIQocYzMq3kJ
	Dh3w82JznWO6eDbybmf+hoki+8d3Ogv2IEbdH3nJndLwCZv6VW/dHbwo6yLN5G4M
	yfkdSKgU9ckzttmoknPrkHlJtf1dMnUuWGsg3YPQH7vhgl3tNz1yNCf2Lj4VIa0u
	7AixsxUZV+e8Kh/jIZWfcKYHw=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgB374_dXQFruHTmHA--.29205S2;
	Sat, 21 Nov 2026 17:01:19 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH] infiniband: cxgb4: Add cleanup on failure path in c4iw_init_module()
Date: Sat, 21 Nov 2026 17:00:58 +0800
Message-Id: <20261121090058.400020-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgB374_dXQFruHTmHA--.29205S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZrWruFyxJr47trW3WryDKFg_yoW3twc_Gr
	W0vr95Xr4Y9Fn5Ca9I9rnrZrW8tw1Y9FZ5Zwn2qas3Jry3uF93Xw4kurn8Ww4UXrW7Ar1D
	W3yjgr4xWF4fGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjsqXtUUUUU==
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7R+pSWsBXd-YQAAA3i

Add c4iw_cm_term() and debugfs_remove_recursive() if reg_workq is
not allocated successfully to release memory.

Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 24ac9871ce67..e337494e30ff 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1548,6 +1548,8 @@ static int __init c4iw_init_module(void)
 	reg_workq = create_singlethread_workqueue("Register_iWARP_device");
 	if (!reg_workq) {
 		pr_err("Failed creating workqueue to register iwarp device\n");
+		debugfs_remove_recursive(c4iw_debugfs_root);
+		c4iw_cm_term();
 		return -ENOMEM;
 	}
 
-- 
2.25.1

