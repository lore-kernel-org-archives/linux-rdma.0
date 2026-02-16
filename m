Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292151F8723
	for <linux-rdma@vger.kernel.org>; Mon, 16 Feb 2026 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771248855; cv=none; b=nF1B4rtxToEcUufsDMcXumkRUTHI5SdVByTRfk0teNM36P869DkqXT/AXbljnpbzjUMsuCTwDsi9cDFCzen66iukaaDPTOAJoPvmAfwaFbZbKxEUH6vrXnJGdAm/v1Wx1EQC3JHPyDN2KOh+DRcb3fhl37Pw1pdFzDbySjstR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771248855; c=relaxed/simple;
	bh=6Bf1GLkH7Ne+EKe4A4PUhXIkDg/2ap10kQ0JV6+AN1M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/GWQRm9NfzAQYVx4ufM9qWyr1+e/1E0LFQsEkeY34BVDCPLmBzVtsjHsS6CQzEsWjOrsomVnEOioT/THN2XE/Nx2DbPTutKMav9UgLngvtG2daxrdFaRigKLbYSKMHrDM90P6cHxMkMJPmSjseKXCD1GcAm5uc7bjSWThjnL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RrUa5rHr; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RrUa5rHr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1771248854; x=1802784854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mlClrv1hOv/2S6xgBk+m2G0EitQoMVPzUtU+e3bQhXI=;
  b=RrUa5rHrYCnRyme6a7eEKJbJnB0OD+OxSvqY/yV7rs5wMxRTMfMQgoan
   j0SWKBjHwnHijnd/QQcas9sH4oBcdAR0YFMemXCJkDrcqjr5+FGXzwObE
   jOjY75pO+TGX8RW/B7cmqy91y1qU/NC6RYyVOd3quYViQGPpWaXG8FPhO
   Dhhg38azulG5nibtUrl1s9ELFvEiZGwSWQSflR+8Mz5qmkqSMyrdGb2Cf
   i520g1QQiWssh+SJdMBrzF16WbSxmAG7vIYEN2LYCVJuWbEKDTdklRZBR
   iQV8LBX6DjK11SJdmhHlHCCU9B+qM/TUcjTzOFQCQ5dYbD8FhdGvtcBcC
   g==;
X-CSE-ConnectionGUID: 7z7S8PBDTXGMIUcJlzR7/Q==
X-CSE-MsgGUID: 5jZViJlbR+uT6RwSC0QzwA==
X-IronPort-AV: E=Sophos;i="6.21,294,1763424000"; 
   d="scan'208";a="12952425"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 13:34:13 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:21405]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.156:2525] with esmtp (Farcaster)
 id 5bce4a1e-cc79-4f57-bbb6-ba088c0fbfef; Mon, 16 Feb 2026 13:34:12 +0000 (UTC)
X-Farcaster-Flow-ID: 5bce4a1e-cc79-4f57-bbb6-ba088c0fbfef
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 16 Feb 2026 13:34:11 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Mon, 16 Feb 2026
 13:34:09 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v2 3/3] RDMA/efa: Use extended inline buff size for inline validation
Date: Mon, 16 Feb 2026 13:33:51 +0000
Message-ID: <20260216133351.14896-4-ynachum@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260216133351.14896-1-ynachum@amazon.com>
References: <20260216133351.14896-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On QP creation we validate the requested max inline size is supported by
the device. Use the new extended max inline size instead of the old one
to support actual max inline available.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 85c3a7dd4335..e5756b479eba 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -641,11 +641,11 @@ static int efa_qp_validate_cap(struct efa_dev *dev,
 			  init_attr->cap.max_recv_sge, dev->dev_attr.max_rq_sge);
 		return -EINVAL;
 	}
-	if (init_attr->cap.max_inline_data > dev->dev_attr.inline_buf_size) {
+	if (init_attr->cap.max_inline_data > dev->dev_attr.inline_buf_size_ex) {
 		ibdev_dbg(&dev->ibdev,
 			  "qp: requested inline data[%u] exceeds the max[%u]\n",
 			  init_attr->cap.max_inline_data,
-			  dev->dev_attr.inline_buf_size);
+			  dev->dev_attr.inline_buf_size_ex);
 		return -EINVAL;
 	}
 
-- 
2.47.3

