Received: from mail-lr2-f11.google.com (mail-lr2-f11.google.com [74.125.230.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB523CD8BF
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 08:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275121; cv=none; b=BwubjQxGBW3RHjnxW/0eMCG9Sa+6iwQi62nAimb3ns8s6orJPvo3VRAwswBvKqz4cI0fT1bl/u0VcJMAahMl4E8fzRiaWwJfm/pQFNlC8nighkU2IwHhke7BTYAH8E8h/fCqRO0lt8seRHh1pGJgpgdSAdb/EqfnRpzPe7/O43Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275121; c=relaxed/simple;
	bh=8CFmkxKpRFqhw9jrde40c9rb1WJEJtIVozzjHWTho9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LXzJ5oqxoE61YvJisaQ/3yA+yqvsOgx4HHDJnaQXxAeh0gL0YSfk5Pnv0cy7WdP8511p1Q7DOvg645MIRF+Ump5KXlWxc9mXqdeQSMUDSKhtMaollwC/JLE/cEDwuYQOYNNAWSdO4tlYOVDRQCjodqjCkYy3GK2p5keytjWOpDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSPFZIgM; arc=none smtp.client-ip=74.125.230.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSPFZIgM"
Received: by mail-lr2-f11.google.com with SMTP id 38308e7fff4ca-3a782b861ccso19033041fa.0
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 01:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791275118; x=1791879918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1gZjlHRYt36AYHmrS72ppy1MygmeYzlOolTpnm0Towo=;
        b=LSPFZIgMFzcDkyGunkj6oomnG57+qRsigyDi8V7ad0jih+4zO89NCEjIKnFiTgzyZ5
         Q22g9zewxkTvOsowHOSKRGdGPnuYo/u4ZeAcqXvaCh5tuqeEPqs7QjY/pwIAwbuY48Tc
         0rMfjYNYW0Feceag6lK7zaOiD3gsHbuoIRpNvfyS3O84vlY1BimijLX5igIq4QJhGekl
         yzEjr8dgQ99xQ2a1/KxHNXMEi4rLOLmWtihl7Y2tQuxF/fYUVXG8Qa9+gKrj2UpVNs7+
         8SlrGwEOVo0iqwYDDPEEpYlokPoL2T267ATKeDer5+jJP8bEqCogmvU32bONcTTzh3sL
         f41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791275118; x=1791879918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1gZjlHRYt36AYHmrS72ppy1MygmeYzlOolTpnm0Towo=;
        b=uGYSYMOUUX2oz6iA+SV1QxImsN/7IQHidhwqy5QbcPzuzxpBkxd5asJbrLwhY6usdD
         F+jlJZmDmohvhLkj0uSinwsOU1Id3IJIH2lMv8KLFJssgJ4W/FV5JJtvtXO3yvsTiYhE
         VlWDiTJQTPPT/40k+aRAO4a8xqUjm4s/RNuuaAsAWmOmjWWerx9CNXZFmhkOx+gFts4b
         tCtqmryfOOHu55SADSfsiQbzIFO8mV9vyWq2nqkvQEDpoi5aPPmWIcegO4fHTipALsLU
         yhS1h7QxoQp2bhUL9xAtj5eK606VHVi2PnXPnaiHp/tpFWtpzb0gA6CuvkSGkS+YN9DL
         hwfQ==
X-Forwarded-Encrypted: i=1; AKwUvBySEMMOk0Sfsyekerf9rtz56VVM140A+iKgVZUtxV3yNfEli5j91bgmN0Bt20JjIMcM0eGGbfkZnhLR@vger.kernel.org
X-Gm-Message-State: AFq9FYL2yJ3bNeOAUGE8WpSrP6SxVU1yr1xbK54AQjf1uWcoYn4t0xjc
	ZyfqPH0rX6cNW90amFW4zN4ueK5Ez8M090YposNlsNgyBpEStx0+XPch3n0eGZ8v
X-Gm-Gg: AYBFou2baqWAjyp0KP3RLguDXcCPw/QO8zlkto9y2rIQw0zvP8JKeyuJXfgioE+Tq9Z
	QvW9tzQMUnnGMvXvRPZBGbSDt6xSmyMqlftysxhuZz2eaHiksejOYSs/P1vHy3O51knRa3lEFux
	0tAGi3jP2AJ05VG6wM0hELIvQQLzswde+4HLrs4sZe25NS+b861ES3tSYM8yajTnxuw8Qo9Kj10
	zQ6MqkINi2auDBnvn6othmjddoNFu1gqW8IpLvzb5N8BuT7Dx0ZFX6nkiuGIesiCuhEvplLG0x/
	BgLPgY04qQFVXgv8xcfR0te6ffYW8VyyZ28o2i43brg+DbYUKt2xubIdi7x/HcVcKA+eUEKfl6i
	6WDiPd+2ZaqczQB7aw7EtF3CA3DYhC7xYbneV9A6g7x2FGpEQ1yAc/va/ae0l0wa0z3N0eY7Z19
	3DpjxDl7Apea2GenlSI0KZDOsYsFqvyVLEO6UD7pGtexk4FkjAcLsyWc064AnmY1gKM38WE9RsL
	ExbAJPRB538p9o/eLNrViIrm1Q=
X-Received: by 2002:a05:6512:3baa:b0:5b6:4ae:8c02 with SMTP id 2adb3069b0e04-5bccc6f92efmr311171e87.29.1791274726992;
        Tue, 06 Oct 2026 01:18:46 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bb7c71911bsm3903389e87.11.2026.10.06.01.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 01:18:46 -0700 (PDT)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Yixian Liu <liuyixian@huawei.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10] RDMA/hns: Fix WQ_MEM_RECLAIM warning
Date: Tue,  6 Oct 2026 11:18:39 +0300
Message-ID: <20261006081840.125567-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengchang Tang <tangchengchang@huawei.com>

commit c0a26bbd3f99b7b03f072e3409aff4e6ec8af6f6 upstream.

When sunrpc is used, if a reset triggered, our wq may lead the
following trace:

workqueue: WQ_MEM_RECLAIM xprtiod:xprt_rdma_connect_worker [rpcrdma]
is flushing !WQ_MEM_RECLAIM hns_roce_irq_workq:flush_work_handle
[hns_roce_hw_v2]
WARNING: CPU: 0 PID: 8250 at kernel/workqueue.c:2644 check_flush_dependency+0xe0/0x144
Call trace:
  check_flush_dependency+0xe0/0x144
  start_flush_work.constprop.0+0x1d0/0x2f0
  __flush_work.isra.0+0x40/0xb0
  flush_work+0x14/0x30
  hns_roce_v2_destroy_qp+0xac/0x1e0 [hns_roce_hw_v2]
  ib_destroy_qp_user+0x9c/0x2b4
  rdma_destroy_qp+0x34/0xb0
  rpcrdma_ep_destroy+0x28/0xcc [rpcrdma]
  rpcrdma_ep_put+0x74/0xb4 [rpcrdma]
  rpcrdma_xprt_disconnect+0x1d8/0x260 [rpcrdma]
  xprt_rdma_connect_worker+0xc0/0x120 [rpcrdma]
  process_one_work+0x1cc/0x4d0
  worker_thread+0x154/0x414
  kthread+0x104/0x144
  ret_from_fork+0x10/0x18

Since QP destruction frees memory, this wq should have the WQ_MEM_RECLAIM.

Fixes: ffd541d45726 ("RDMA/hns: Add the workqueue framework for flush cqe handler")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260104064057.1582216-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
Backport fix for CVE-2026-46265

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index bb744ba155e2..56c7af1c3b24 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6087,7 +6087,8 @@ static int hns_roce_v2_init_eq_table(struct hns_roce_dev *hr_dev)
 		goto err_request_irq_fail;
 	}
 
-	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq", 0);
+	hr_dev->irq_workq = alloc_ordered_workqueue("hns_roce_irq_workq",
+						    WQ_MEM_RECLAIM);
 	if (!hr_dev->irq_workq) {
 		dev_err(dev, "Create irq workqueue failed!\n");
 		ret = -ENOMEM;
-- 
2.53.0

