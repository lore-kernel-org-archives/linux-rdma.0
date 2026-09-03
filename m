Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55917509F1A;
	Thu,  3 Sep 2026 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466172; cv=none; b=lkeeXcQ8VhJo1wKDuPYA266hSD0to2t7dXbstjpOAHe6yflS/nS3npbgba57PhOnut3TfZv+77Cju28e1RyGUqW8Bys7/gHzAey91JePN63TwTrHF3xmZbXqK4LiJrg8Q7xHCegmBfdjgdAQ75vAjUCtB6KVFbKJ5VlZ2gC1c6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466172; c=relaxed/simple;
	bh=MSE1bAVgSlxkjtZjqV82xMvOo/aICigEwRo734DLgXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BXdwMeUfxb6e3UnS60gCd8cBTDLuI8wYkCTebZTka89+Juczi9wzbw0Jww6X1euB+UPwd9fq72O7w1yoKas8hLQqSqMCbwBkhuDYR54zyjlaSx53izFl9h/feueNMVrtBsx+aByICtd4l7DljzvxwFca6MKvhp5P+3dhVYKETQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=qJMdEDkl; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="qJMdEDkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466165; x=1820002165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XX48jswlIKKhs+Pt6FVWiePpzzgFkvgeU2ajSFykQE0=;
  b=qJMdEDklyX+1Mn+IBj3Sy74zSZRl0M9eHi+U+9Zb1JqTgzvyQZjjYAQD
   9qLHM1uKWcIuK7rqkGdmvC7/tpHy7uyRz9f2Ext5eoM09JwyfeBR6dHhP
   Q9UjO/NMJB8sQAQeIM1CDLfxDODVDRay9TkpfB8hF0ob5lLEqsxDIkk0A
   7olacMq9yIx44WAOiJ35njVtFXdLERt+6f8pjJURYr51jnH8KvOrxu0oq
   Da4gtlMnvneqzmAUTm6ihg6XB0y96NgKw/oygAMzKTnQDDqn9kPPKOR7z
   +TTc9gsscUQCJ/4whN+qexpgvlMDsw0a+Ka7C5QiMBbHWj7ffl5+Eh3MZ
   Q==;
X-CSE-ConnectionGUID: xYE3o3Z0RU6Og6oDjxqtcA==
X-CSE-MsgGUID: DNIt5TXCQWe9UtwrcEKKxQ==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27553495"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:09:09 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:2758]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.170:2525] with esmtp (Farcaster)
 id d1d2f6f8-215c-4a74-abad-8dde3f703ed7; Thu, 3 Sep 2026 20:09:09 +0000 (UTC)
X-Farcaster-Flow-ID: d1d2f6f8-215c-4a74-abad-8dde3f703ed7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:09:09 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:09:08 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, <doebel@amazon.de>
Subject: [PATCH 5.10.y 3/4] RDMA/rxe: Use the correct size of wqe when processing SRQ
Date: Thu, 3 Sep 2026 20:08:50 +0000
Message-ID: <20260903200851.566276-4-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903200851.566276-1-doebel@amazon.de>
References: <20260903200851.566276-1-doebel@amazon.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit e2a05339fa1188b6b37540f4611893ac4c534fa2 ]

The memcpy() that copies a WQE from a SRQ the QP uses an incorrect size.
The size should have been the size of the rxe_send_wqe struct not the size
of a pointer to it. The result is that IO operations using a SRQ on the
responder side will fail.

Fixes: ec0fa2445c18 ("RDMA/rxe: Fix over copying in get_srq_wqe")
Link: https://lore.kernel.org/r/20210729220039.18549-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: Clean cherry-pick. Needed as a prerequisite for
 "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 207889332b963..55b5146424e61 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -311,7 +311,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.50.1

