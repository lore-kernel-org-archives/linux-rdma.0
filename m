Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9007B3B38B5;
	Thu,  3 Sep 2026 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466160; cv=none; b=iygeOV6+4h2zEgGQQBTiOcfGXVI5rkcVe5MnBCMxtwhv2TlPvNq0OAwk7wVEVzE736zFpYrxRe+wTpceM3FqjCdYwUZ3g1nv1Tz4OG0JB++x6FaRBf39l+MyNCFsHXKkkTz+WEZETx2vwkyCMM00UkHKN4dj4GyqOB4DglQlwXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466160; c=relaxed/simple;
	bh=iFbrxM7/KeWgNAGvUZXcbTRY7xsG8dQdyh+aXPyt+oE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0kIYZvScxpE2XnKXn46X41M2aa0leHjl3ME9D7CbxZcUaJ/sI4AqjPJuWc1WzPdLNEu/80jdHsTGS7dusiKoGzUi+J7a4v5HAf+xsO7DuvA5eYiQH9WxSYiProk04tQyRh+MOfpQCrNe2gtN+0NWKXNyWzWnABGO1ZixmNQ6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=B8rEomDS; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="B8rEomDS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466156; x=1820002156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QpFTsHeEK2z7IzY99lKS2P3SWscaHRBEoR7hiMVAqtI=;
  b=B8rEomDSq5VFuzLDg/TroJQVB32vPK+pI6kzGlt7yGIR/2gv1kLSErD7
   no+eeOilLWOU2qALhmUEWWi3W5D4rmAayvmQvoHtfO0WKZJZW5FY3ToNw
   G8LPZR9U4yQQPLj9sBdWvwPuLn+n7Rk8MpnURwo0N58ciSWr5/Y3q/cDt
   +qarzVU7G6up2Z0l5ixBUfCbJQSPRTgtY9dkEe8PpPhctmG0UtKRk+i2v
   Fsylc2ufpS3xr90O87JgOuY3YstfTPoVXir1IczSC4Jx8pA5uGKyrK88D
   Om5DOaoFFrxkjPJ74taoQfSnDbWuZbQMHcKqDwDmvel2GycqZF61WtmQ+
   w==;
X-CSE-ConnectionGUID: gHAO71QmQKKeosme222Q9Q==
X-CSE-MsgGUID: XaC/t+MjTdKBG/144nMXlA==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27553490"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:09:08 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:18424]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.249:2525] with esmtp (Farcaster)
 id a877bfdb-e817-4b5c-8a69-73a651dcf220; Thu, 3 Sep 2026 20:09:08 +0000 (UTC)
X-Farcaster-Flow-ID: a877bfdb-e817-4b5c-8a69-73a651dcf220
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:09:08 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:09:07 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, <doebel@amazon.de>
Subject: [PATCH 5.10.y 2/4] RDMA/rxe: Missing unlock on error in get_srq_wqe()
Date: Thu, 3 Sep 2026 20:08:49 +0000
Message-ID: <20260903200851.566276-3-doebel@amazon.de>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 36941dfe0e8c3e2da7851b9648fd74bd3a3e78ce ]

This error path needs to unlock before returning.

Fixes: ec0fa2445c18 ("RDMA/rxe: Fix over copying in get_srq_wqe")
Link: https://lore.kernel.org/r/YNXUCmnPsSkPyhkm@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Majd Dibbiny <majd@nvidia.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[doebel: Clean cherry-pick. Needed as a prerequisiste for
 "RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe" ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 38e6535196849..207889332b963 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -307,6 +307,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 
 	/* don't trust user space data */
 	if (unlikely(wqe->dma.num_sge > srq->rq.max_sge)) {
+		spin_unlock_bh(&srq->rq.consumer_lock);
 		pr_warn("%s: invalid num_sge in SRQ entry\n", __func__);
 		return RESPST_ERR_MALFORMED_WQE;
 	}
-- 
2.50.1

