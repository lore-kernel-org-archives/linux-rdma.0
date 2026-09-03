Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4734FECD8;
	Thu,  3 Sep 2026 20:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466043; cv=none; b=sy1u/PrL37kBDoL6lht1RypYlsErfjs8maA/TeY4wbTrVF1Cojra96EEOKDMNlfnIlfhDWaB/8DuTyLiKzmv5Rp7/mHdgu+ROMlnxk46xE4iQx40R/Epsg1+WHYx0u2eHdJECl6vprMkvst8pFpG4l+gvc/ISk6OAtyIdj32dAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466043; c=relaxed/simple;
	bh=KvYoZNwP8Ivf676L1PaYOe029xPct+3hovkHtOg/egY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ixatCwsDhZ2BK2BgrNqakvV+aOIr0+yOB4ShAzJPLTjlj/K6lhwQ3OKWQW6vP6Eoi4JWxFKNhnORvOVX0cW2dMQpOCKoaRLoP2hn1qTHeZjPIXWIHb4eXunqT7SW/3na1vH48DxQieNmP9MxJi6Yej8eS0sCIMnnyUsvVSHVRvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=V5XVyCh0; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="V5XVyCh0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466025; x=1820002025;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XlrbAwlSQH8TTc05lo3SPl9VsXkqmWE/vVWLwG8Utyc=;
  b=V5XVyCh0EO6LdFJdtQVFbCpqJm8Hoy3sBECwolELslmZ/Vw8YBOhpmlK
   IfFrpKWg2z/yicb0OaLN9hpP5iDvfHX22c9mUUgqB1OExN/ptkhVE88kg
   xmY1cq2+6lL19xH3N8eu3B/CAenS1ixgVAYM72DqH4U73vWhUHY+QyxKU
   JgE/JGnVV5FpHdsDGFIkqvaNRww83Js8gpsiOT4HhmfH2yrKoR90YlMkE
   316DtTmOWTudYpfzaTMQsczcIz1kwOXffzdzaFqTrKjrgPNIspnEyaNpp
   wMbV8uHe7pZEFQ93T0LltqN8ylILGS908h0fC7AZFWa3STxXddAuJ1byw
   Q==;
X-CSE-ConnectionGUID: wTMGapjnTk605suGrJZFNA==
X-CSE-MsgGUID: XnTK5MC9QKypaJq6OvQKag==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27257870"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:06:58 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:23398]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.7.25:2525] with esmtp (Farcaster)
 id 2c17be10-3f87-4600-824a-94010dc6ee34; Thu, 3 Sep 2026 20:06:58 +0000 (UTC)
X-Farcaster-Flow-ID: 2c17be10-3f87-4600-824a-94010dc6ee34
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:06:58 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:06:57 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun <yanjun.zhu@linux.dev>,
	<doebel@amazon.de>
Subject: [PATCH 5.15.y] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Thu, 3 Sep 2026 20:06:45 +0000
Message-ID: <20260903200645.561393-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

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
[doebel: cherry-picked from v6.1.178 (3cfa2a3adc51), adjusted for
 context]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index e7dec84810614..27f24c77993ca 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -296,6 +296,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
 	unsigned int count;
+	unsigned int num_sge;
 	size_t size;
 
 	if (srq->error)
@@ -310,12 +311,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
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

