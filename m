Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E074C4CDDC2;
	Mon, 28 Sep 2026 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602916; cv=none; b=aWblP2CfE8dRC6dnZzxpTkAxTTdce2hm1N9O8wuXNmBLzenNtO6vZcbfqxnGpILAeRvS41umREnPDTJtpVo5SbWzVHEj3QnmnhsNfm8O5QqYCUD1Zza5kiQd2tGILgYRGL6VygU/u3TFgZXyX6nYdUbWxw2bLU6YOqFcM+Rh1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602916; c=relaxed/simple;
	bh=fTFH+Vdm73mkawdS6OJGPgA6eVO5byA4vIWzzFAJlXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmTiIfkzpjkj6zFhFw+PFsUr4kbgUxW9HH434AEW5KRru0zYP3bZsviZNsu5zwP88eDIS0N9kEZuwqglKoc8vaZLyMlDcgeNb6qrWpZUYSysfMetm7ZztEjCNdCQWKIyZcjSoWCW1NBN8GM4n7pJp62xfF1qziGzDwpMLCAGOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Bo90kISQ; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Bo90kISQ"
Received: from LAPTOP-99KJFSET (unknown [36.153.54.109])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f5d6f43c;
	Mon, 28 Sep 2026 21:41:49 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@nvidia.com
Cc: leonro@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Hongyan Xu <getshell@seu.edu.cn>
Subject: [PATCH] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Mon, 28 Sep 2026 21:41:48 +0800
Message-ID: <20260928134148.977-1-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e84013e803a1kunm4e34150e200217
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHRkaVksfThkdHUlMQk1ISlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlITVVKTkhVTk9VSktCWVdZFhoPEhUdFFlBWU9LSFVKS0hKT0
	hMVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=Bo90kISQJESs9Auc7gPoYdmFVtWFPeH9TNB2TGUPA5gDzEqNgUr0oojUTnBgljVBQo3vlVk7lmJ4OdifDEP1ytsUSEdInwUno8/mulN9G1tjkoUuHP6OiAW4KMAIWx3Xge5AbUvEN4RK6jjz4CdNXXfPLBU7mb/lFQeUn0T5/oc=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=/sgbB/iwatg5GYJX/+EMY9ymnSr9dagViaeQDJdgqvY=;
	h=date:mime-version:subject:message-id:from;

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index f253c8ee182d..a71fc8f2d37e 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1569,6 +1569,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.50.1.windows.1

