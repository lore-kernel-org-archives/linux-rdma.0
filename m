Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613C02EEE86;
	Thu,  6 Aug 2026 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021353; cv=none; b=IWu+Z0Bhm7nfbPzzNzPESCGftbJr6CTzxZh74jYy8wIE8ZQ5/zMoRbZXLQfYuKl5I1L987lW8KkEwd7f1Nq1FynQJIWBX0iydbelV431b/WD0Xxbw+An2jHN6z4CyE0+1LA5z509qvDy1SqxTSuV5nLVnQ7vhX3nCbwlLgct3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021353; c=relaxed/simple;
	bh=EwC3i8duz2QjK8+gnxoASkVQgHT0bc26zqGvRL3TU3c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RhTHEKk/1uRcrH6ZCqFa2093zg2+ry5OLaMs8BtcV616ilx4Xc5yIcYGL7AI+BjGCiC+HQWbmhsZz+J2+WdgsApYawRjSUVlubKuj9v4mJgSNyfLHJUkqAb1ANK/7zZ+s1M0m5agzyrDOVpj55wkIAsElp6orD8RSfLjCdYEM0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wBHQH_ghXRqEDZuAA--.4850S3;
	Thu, 06 Aug 2026 21:02:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with SMTP id zC_KCgAnl8zghXRqKF+cAw--.10149S2;
	Thu, 06 Aug 2026 21:02:24 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-rdma@vger.kernel.org
Cc: bharat@chelsio.com,
	larrystevenwise@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dledford@redhat.com,
	linux-kernel@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] RDMA/cxgb4: Cancel reg_work before freeing device on remove
Date: Thu,  6 Aug 2026 13:01:27 +0000
Message-Id: <20260806130128.465460-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgAnl8zghXRqKF+cAw--.10149S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?5/PxEwXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfncGSG+szpQCInt5Y8rbJUI30aW1F0YWGPFmewFYDlPVQtbkHEl+rH9gfyjgGr/KEhoVN
	9gjUrjLiOiK1yQO4/+16Vgm8kPMNCmb0liPq5gw6
X-Coremail-Antispam: 1Uk129KBj93XoW7Kw45ur1kJF15Zw4fKw45urX_yoW8GF4xpw
	1rGa43KrW5Xa12ka1IvayxAFy5Gw4xXa13uryqg3sFgrs8ZryakryDKFWUuFWkAFWkCFyU
	AF45trZ5urW8CabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU818BUUUUUU==

c4iw_uld_state_change() queues reg_work to register the RDMA device.
c4iw_remove() can free ctx->dev while this work is pending or running,
leaving c4iw_register_device() accessing the freed device.

Cancel reg_work before removing the device.  The registration work can
tear down ctx->dev when registration fails, so do not unregister or
deallocate it again in that case.

This issue was found by an in-house static analysis tool.

Fixes: 1c8f1da5d851 ("iw_cxgb4: Fix possible circular dependency locking warning")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 102c5646b..c1815972a 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -951,6 +951,12 @@ void c4iw_dealloc(struct uld_ctx *ctx)
 static void c4iw_remove(struct uld_ctx *ctx)
 {
 	pr_debug("c4iw_dev %p\n", ctx->dev);
+
+	/* c4iw_register_device() may still be using ctx->dev. */
+	cancel_work_sync(&ctx->reg_work);
+	if (!ctx->dev)
+		return;
+
 	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);
-- 
2.34.1

