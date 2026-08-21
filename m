Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67041463B74;
	Fri, 21 Aug 2026 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787303378; cv=none; b=IbOuKZt6TH3irEtaXGVSmHI0C9psIt+jCP/dfrzxfpfnNHLEvgO66gwpPEtkjViivOQJVksd2wK1HfDdK9xAjAWkTMWD/1zAM6omihpn8pkWxq24E7+PbbqTrW5LELIKGnBxN4vRkD21ZY5OIvU5L2WfAVMy+QBwufsiK0BySEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787303378; c=relaxed/simple;
	bh=eJF11FA4r2ULGA6aUJmYSNCRBWAYFm+LwDQ9zipf29U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ocONikKkeY4lDjfIKr5DsigITEU8o+C8wAIZ4wwvyO50WyWYqaW38mafV8L0W9kozY4kSqH/mxk/oltV7w2I/kKdtOLRXbZ0a3F28bZZxRPsm3XFYu7bWSLqbsX3QtbA6s9XB9GSJI24racYGA8JteIk6lVrUXwRfsjfGWQGMrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: fa4ff4aa9d3f11f19a56ed5b684f684d-20260821
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8cfa0622-db07-4785-9126-88bc3b38479c,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:01bd9755aed6d8fb9daacadcaee373fd,BulkI
	D:nil,BulkQuantity:0,SF:102|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3|
	-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fa4ff4aa9d3f11f19a56ed5b684f684d-20260821
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2017648742; Fri, 21 Aug 2026 17:09:13 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gonglinkai@kylinos.cn
Subject: [PATCH] RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup
Date: Fri, 21 Aug 2026 17:09:08 +0800
Message-Id: <20260821090908.1310605-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bnxt_re_init_dcb_wq() ignores a failed allocation. The async DCB
handler later calls queue_work() on the NULL pointer.

Fixes: 51dc5312dcd9 ("RDMA/bnxt_re: Add support to handle DCB_CONFIG_CHANGE event")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
---
 drivers/infiniband/hw/bnxt_re/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index d25fdc458120..c2fa83eb0da5 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -356,9 +356,13 @@ static int bnxt_re_update_qp1_tos_dscp(struct bnxt_re_dev *rdev)
 	return bnxt_qplib_modify_qp(&rdev->qplib_res, &qp->qplib_qp);
 }
 
-static void bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
+static int bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
 {
 	rdev->dcb_wq = create_singlethread_workqueue("bnxt_re_dcb_wq");
+	if (!rdev->dcb_wq)
+		return -ENOMEM;
+
+	return 0;
 }
 
 static void bnxt_re_uninit_dcb_wq(struct bnxt_re_dev *rdev)
@@ -2343,7 +2347,9 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 
 	bnxt_re_debugfs_add_pdev(rdev);
 
-	bnxt_re_init_dcb_wq(rdev);
+	rc = bnxt_re_init_dcb_wq(rdev);
+	if (rc)
+		goto fail;
 	bnxt_re_net_register_async_event(rdev);
 
 	if (!rdev->is_virtfn)
-- 
2.25.1

