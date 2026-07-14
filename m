Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403433655ED
	for <linux-rdma@vger.kernel.org>; Tue, 14 Jul 2026 02:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783997092; cv=none; b=BP19opDpcv1F0ZT63QXkYjNapB1iE1AZ1zqQXacfXkXiYQtCethAlaZhDdJJlHtn8kJzum29/2Kv1xlFXc7nVA2FhB4eKKDY26auPWJZXbYYt5FncXksVXCR29y4OkMWX+1TJWyWpss0dMXCeCWDwkCZpao5z6e5n3Sg5zhD/fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783997092; c=relaxed/simple;
	bh=MaHYHp/rWAVMrAgGb68N1asAZMOeHFL4P7dXcqIR8o8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JeMM12LEmUJhxGcwPd9NvuLjiZ3wD32dl20xDvWIiqT3D/EEyCVGZMVU176np1ih6VdMsGF94lQjSu48m/IYWOKxHsAu5SW/Z6KSvb2J3UeISlBP+4lQ50UFWjBy2StLG7wn+UzXUuGDEchzFPcT08vNRXeV+6XmOrQXO6M0/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XL+JaaCe; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XL+JaaCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=rL
	d2kET7SHNklX6KzKALGq+k+rOJV4yKgk9t16w+8uo=; b=XL+JaaCekNCtCfb5Qz
	wCmyY1MQn8osKrvx/XFgAnyhfUuMYXy53Wp/I8erxMud36Rj30A+xNjnOigUpAMv
	rfV1qWao4/BzcUJUzW7jiD1s0gDNkjpiPwxUTGPr/0xV0ts6/8V+eQUoZ73SwZYP
	LgNPvxNg1qm7mv0htdNNofVPs=
Received: from xwm-TianYi510Pro-14IMB.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wC3x6CNolVqgxdVJA--.2748S2;
	Tue, 14 Jul 2026 10:44:29 +0800 (CST)
From: weimin xiong <15927021679@163.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: [PATCH] RDMA/addr: fix spelling of guarantees in comment
Date: Tue, 14 Jul 2026 10:44:29 +0800
Message-ID: <20260714024429.188276-1-15927021679@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3x6CNolVqgxdVJA--.2748S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFyUKr17Kw45uF1rZw1UJrb_yoWfGFg_WF
	y0qr1vgryrCFn0yr1j9FWfuFyqvry093Z5Zr4qqw47J345twn3Gry8AF45uw17XwsrGF93
	Jr43Gr18CFs5GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1vPfJUUUUU==
X-CM-SenderInfo: jprvmjixqsilmxzbiqqrwthudrp/xtbC0Q27RGpVoo07BwAA3P

From: xiongweimin <xiongweimin@kylinos.cn>

Correct "guarentees" to "guarantees" when describing work cancel.

Signed-off-by: xiongweimin <xiongweimin@kylinos.cn>
---
 drivers/infiniband/core/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index e9fb7ad4c..bdaa3eb83 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -769,7 +769,7 @@ void rdma_addr_cancel(struct rdma_dev_addr *addr)
 
 	/*
 	 * sync canceling the work after removing it from the req_list
-	 * guarentees no work is running and none will be started.
+	 * guarantees no work is running and none will be started.
 	 */
 	cancel_delayed_work_sync(&found->work);
 	kfree(found);
-- 
2.43.0


No virus found
		Checked by Hillstone Network AntiVirus

