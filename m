Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A331A682C
	for <linux-rdma@vger.kernel.org>; Fri, 17 Apr 2026 01:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776388196; cv=none; b=XD65R3Uo7Rf1rryUMmRTsS9lUaiNxFK6BfSqEtZkI5Dgq4bbwwwlao3KMMI3zcNAAiUuYaPPoux/Ek06fb4LjfUbRtuZBd7aplNUdaCLh3yfKeD5FbZzr40/Doc4ukrRPLu4oe7qt2bGPfNUEf+3A7T2wo8LbGc05FGXIe6fqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776388196; c=relaxed/simple;
	bh=BzBsW2EoOiVXBwmRUYlTxU0hLaG00q8tOB6dZVDEswE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q97a1yKKWl6uZhFrQYeeWhMMCsgYv2abVnF5PBxFQhiBQky9UyQFu4ZhC0dItL9ayFmTFxAerbSoACbJLQJhHe8gOA44IpCPEFmkdbSXKKgfU/mu1rndmANUEfcwtSQT39Taie/cKQIqaXaQWaKHrAz3jVtmMeqDIucL6wduVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1fb46dba39fa11f1aa26b74ffac11d73-20260417
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:bb963fa5-eaa2-46c0-9d59-bb9e6ff3e059,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-20
X-CID-INFO: VERSION:1.3.12,REQID:bb963fa5-eaa2-46c0-9d59-bb9e6ff3e059,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-20
X-CID-META: VersionHash:e7bac3a,CLOUDID:613d0436985aac6daccb317496add6f6,BulkI
	D:260410154105WSQHVMYT,BulkQuantity:1,Recheck:0,SF:10|38|66|78|102|127|850
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:41,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1fb46dba39fa11f1aa26b74ffac11d73-20260417
X-User: zhaochenguang@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <zhaochenguang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 898646432; Fri, 17 Apr 2026 09:09:46 +0800
From: Chenguang Zhao <zhaochenguang@kylinos.cn>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chenguang Zhao <zhaochenguang@kylinos.cn>,
	linux-rdma@vger.kernel.org
Subject: [PATCH RESEND] RDMA/mlx5: use QP port when decoding responder CQEs
Date: Fri, 17 Apr 2026 09:09:40 +0800
Message-Id: <20260417010940.178697-1-zhaochenguang@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The responder CQE path determines the link layer via
rdma_port_get_link_layer(). Use qp->port instead of
hardcoding port 1, which can mis-decode completions on
multi-port devices.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index d0cd3f805bcb..2481b3361c1d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -169,7 +169,8 @@ enum {
 static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			     struct mlx5_ib_qp *qp)
 {
-	enum rdma_link_layer ll = rdma_port_get_link_layer(qp->ibqp.device, 1);
+	enum rdma_link_layer ll =
+		rdma_port_get_link_layer(qp->ibqp.device, qp->port);
 	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.device);
 	struct mlx5_ib_srq *srq = NULL;
 	struct mlx5_ib_wq *wq;
-- 
2.25.1

