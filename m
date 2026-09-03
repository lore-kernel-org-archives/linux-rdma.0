Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C23CAA31;
	Thu,  3 Sep 2026 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466162; cv=none; b=c2O4fJ2pXa6WlZglPpncjqQMW8N8Al+1U2/160wwL2zUKkQZVJuE+Rfbd0tkXp7KEhXweOT1qg0wstFP5Dv+tZ99IHH9cCVKUUgf4N9+khWejwWcp0sQ+BkblymqLXOQ8lUISeZmciXd/1GE38crujJuPB+0A++7zBl+muiQgx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466162; c=relaxed/simple;
	bh=CMlA6JOv+DwS0leEIoirX/TfsBDe3Ds4JM+49IQagg0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOww0/oPr8gNQuNkyR5OQZzJ7Ixxcek2Rx/uJs81/IlUPyPkRnaeEd5jT1VQE8DtSjvKCPDn7Nyr7ViPpuexZ4gcKj5SWTfNUpYZ43Z1+sGYLmeX56T2eCfJaDV3y7ag6bEDIICK/ivumf6MH8ffsY6tZI/1athraJzNsIpi0EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=B8N9FOV9; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="B8N9FOV9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466156; x=1820002156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aoSzZrcqvLMLsiAM1Y+Hofna5HRKsoi6LCWxfvLlAUM=;
  b=B8N9FOV9WL03b8vqaJFRGMNX+UteLkHz/EpSz+3eVGqvLymGYrmUIvy/
   iiWV9b9Y6kyCNMkOTYltW+t/Tc/8jAcyn7i2bxDTkdcSI25WgktQOkg+f
   hUd04nbIOlinjDTfpnLpwKKBcJlIQp18dnCv9IjSdteZ65La8SClniNO5
   PqP8Y7SWAr3xe8NFLwTBFYpUq6tctjrUFvwgppIOKjvj4/nB8XN0BGt39
   yFAvlPcjZgT9R98M3Pr5xgcxSLrtCDmmcm8XJB2fFcA+7047n559nUuY0
   x7A0X6UjZ+a71edDugyewqxkA+CwHhdM9s9oiDhFgsuZQMP3ICW9TRyUT
   Q==;
X-CSE-ConnectionGUID: wlXqAJ8SSYqBeg8snKy2TA==
X-CSE-MsgGUID: oz+2ZtplReyIYW1iJiBAsw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27665070"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:09:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:16462]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.132:2525] with esmtp (Farcaster)
 id 0c0be6e5-2034-4ec9-8120-aadc1d1f8edc; Thu, 3 Sep 2026 20:09:10 +0000 (UTC)
X-Farcaster-Flow-ID: 0c0be6e5-2034-4ec9-8120-aadc1d1f8edc
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:09:10 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:09:09 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, <doebel@amazon.de>
Subject: [PATCH 5.10.y 4/4] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Thu, 3 Sep 2026 20:08:51 +0000
Message-ID: <20260903200851.566276-5-doebel@amazon.de>
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

From: Tristan Madani <tristmd@gmail.com>

[ Upstream commit 22b8fbded65b8c441b634a185f8da67657df6c50 ]

get_srq_wqe() reads wqe->dma.num_sge from the shared receive queue
buffer, which is mapped into userspace. It validates num_sge against
max_sge, but then re-reads the same field to calculate the memcpy
size. A concurrent userspace thread can modify num_sge between
validation and use, causing a heap buffer overflow when copying the
WQE into qp->resp.srq_wqe.

Read num_sge into a local variable and use it for both the bounds
check and the size calculation.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260518215040.1598586-2-tristan@talencesecurity.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[doebel: cherry-picked from v6.1.178 (3cfa2a3adc51), accomodate for context changes]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 55b5146424e61..d22d95f5e2e3c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -292,6 +292,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_queue *q = srq->rq.queue;
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
+	unsigned int num_sge;
 	size_t size;
 
 	if (srq->error)
@@ -306,12 +307,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 
 	/* don't trust user space data */
-	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > srq->rq.max_sge)) {
 		spin_unlock_bh(&srq->rq.consumer_lock);
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-	size = sizeof(*wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
-- 
2.50.1

