Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DA503BD1;
	Thu,  3 Sep 2026 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466171; cv=none; b=LtOq7TgvFiRLen+lDNTaxFqXUUMXVqnprqwID8RMoXIRnyr4OwG5+dgRkan5kYYZulZgAYk5xkLDmFmJoMRrcTnKNbzxg8EMEYHAD0VPRBZ51Ddqts1VyMxrBE4/TuBzqLhaSMKAs7g3Ly/OTpJmQIYX2nON+9yoKgIcjBX0UIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466171; c=relaxed/simple;
	bh=jxRJiQcFRmMLYBdOagYt1L7oKM9gBGbOkfIfUyTmEus=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVMrmbQ20kUfrONkljb24P7wHlKyLpDwbYUA9oPYcUy7otn3LV4NY5F45ZEMiRO+ZKOKnoGIxrQW+jvx0DBgG7d40p5TfXZg1Sgt6CfoQiA7YTKeocIEUPAG16tsL9N7hAYp9oiPL4U+e9kN3t2xnWD5JVDJ/WnGmRtmCTeCwJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=VbHSDL0e; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="VbHSDL0e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466157; x=1820002157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CKAZl1q4IqEuOQ2EsBevATJipxvlqdkWvb4FBjUhQEs=;
  b=VbHSDL0eIzXlTNqS4KZHs3BVRPgm5ViKUV5DxIcYREXoTyuZMAxQsUaj
   6pU36VcuXuP9FDJJirxh/EV/yt5ezyXeJSKuTptTYLAlmyLi+3eAe09y3
   hyIWAiExH2Zw+E+qe1C6HR+5OGOhKbXLpP56NSB1V8CNDuJeCR5rAy8Gt
   Qw5P6b+G+6Hs+fGaUY4b1styXDjHDZuLOJJ3Nh5hH9HRnux3LPzyl58q+
   Cwu7gW8fq/h/epIL73BFV/9a9vms+Agq4rW2uaHzEUBJa9TL6LWoJ1ZzQ
   YOook4mC9JiHcQxzJ0cERGBNw8sf//qQmnbtmp8tFCRQWsTKz90mxUd/L
   w==;
X-CSE-ConnectionGUID: zsK4nWodQtOfFCp+PwD6VQ==
X-CSE-MsgGUID: PlO4DTqZS9OuzimhB/wklw==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27542484"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:09:07 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:24143]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.170:2525] with esmtp (Farcaster)
 id 7a36d1bd-2ee5-4184-a0a4-918f2832190b; Thu, 3 Sep 2026 20:09:07 +0000 (UTC)
X-Farcaster-Flow-ID: 7a36d1bd-2ee5-4184-a0a4-918f2832190b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:09:07 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:09:06 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, <doebel@amazon.de>
Subject: [PATCH 5.10.y 1/4] RDMA/rxe: Fix over copying in get_srq_wqe
Date: Thu, 3 Sep 2026 20:08:48 +0000
Message-ID: <20260903200851.566276-2-doebel@amazon.de>
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

[ Upstream commit ec0fa2445c18ec49a0b7ee0aaa82d1ec00968fc9 ]

Currently get_srq_wqe() in rxe_resp.c copies the maximum possible number
of bytes from the wqe into the QPs copy of the SRQ wqe. This is usually
extra work and risks reading past the end of the SRQ circular buffer if
the SRQ is configured with less than the maximum possible number of SGEs.

Check the number of SGEs is not too large.
Compute the actual number of bytes in the WR and copy only those.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210618045742.204195-5-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: context adjustment from upstream patch to 5.10. needed as a prerequisite
 for "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 83c03212099a2..38e6535196849 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -292,6 +292,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	struct rxe_queue *q = srq->rq.queue;
 	struct rxe_recv_wqe *wqe;
 	struct ib_event ev;
+	size_t size;
 
 	if (srq->error)
 		return RESPST_ERR_RNR;
@@ -304,8 +305,13 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 		return RESPST_ERR_RNR;
 	}
 
-	/* note kernel and user space recv wqes have same size */
-	memcpy(&qp->resp.srq_wqe, wqe, sizeof(qp->resp.srq_wqe));
+	/* don't trust user space data */
+	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
+		return RESPST_ERR_MALFORMED_WQE;
+	}
+	size = sizeof(wqe) + wqe->dma.num_sge*sizeof(struct rxe_sge);
+	memcpy(&qp->resp.srq_wqe, wqe, size);
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	advance_consumer(q);
-- 
2.50.1

