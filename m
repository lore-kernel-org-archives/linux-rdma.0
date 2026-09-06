Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752073C3F4F
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716760; cv=none; b=UHo4vn7SBcEBGCl0Qru5j3K4n1ql8sUBKmXdy2h8v5G382j9pKjPLFLlDlmIy6withNiHhXxvSJdgeJt5zc3in23sLdG1uSb9WWNAJc8/1LeiwtW3L67zO3MEoyQfoawfHWHKvBTg2a8cOF8DpGjiREGnhkiZlI+KdOfdEbUv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716760; c=relaxed/simple;
	bh=fHZXkzNfxpPJ03yoSzFnGK9KsEQZzXY6L1fKZrjHr6M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MBp+oNkh9T180ZR4r5gXCPJPpUTs8wDCqKKggQZ6BMqrQhoKpvSweDZoRW8Fa5GzCUqfEhMorG1nweVm7kFEFK5zIAVmAszbb30iHMfCw90IOjaJfUcJRMzLuifIhw9+YYrr2OWSqFs4aE3kTu2CizVuPC0RHCPYjYFZUnzMiqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OJhHLfxI; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OJhHLfxI"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38759bcd877so2740747a91.2
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716757; x=1789321557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uC9YjQsKnxJ8TDL9hPQCQxOLanXtsl8beCjFw8R60W0=;
        b=OHTwaR/IUWgunSiVkCwiNdXzz9H+81yDoc01zEjEBSAQybDZc3ilfeh0menXczAZj/
         +zqoEYJbO9eLeDy/CMINrCrzSaUESGbkKxya8No4OAqZJfSk0Ji1oP1S3w//eM46fe0a
         FM4EBvL79g20nZ2+3zD3Vy/9dCJwwizQazZ4frerB4WI/bsN+CYUIv+MmvgWGBSaAzr0
         +wSISd0bukHhb0jBNus2Mz53KCCLkqqBuQQyDlQETxNqC7pE+LydPCjjIb5zQOuqMgds
         ECCIdfwzVHrgg4CnRAGZl9yfwKqu12qCawuY41HHOH0SJzkh2CeB9QQ64b2rkv2SClCv
         WNTw==
X-Gm-Message-State: AFuF++n0xu3VA91HYstbUnwNtOXjUgzT936hpZfD2/JBrUuclowOCsRj
	mIZPA1jUF14kcVUL3QrJ9C+E48kfofaLu1ptrvComoPhc1+oHEuAwS80pPIy7c+3hTrebizILN6
	2UUCSGw5RW6FHtFKz6k3Hv834gMID+mKzO0udkNu12kVsC4Q0J5TfwoXoSPW+gV6fKvDn/D8C60
	nqLMWxfiCkFXM91UBNGinwNJzYjedwvBcNYKWgjyZArC7I4n2z/SQiPvB0GvAWAAHPsDUSlj6m2
	ODWIw0QxOfdQgMk0w==
X-Gm-Gg: AYBFou1nAdqrCIqGg02mBmhKMymQno2VrybcFXNAugQjRyo9Zm9JmMu7S2dmcgZ7lCy
	huPWCKXeYU08RvVqnAqXWJpCCWprS7YpwbKx4xy6jopYhUv1LkPKJrlc/Oo0T75IwUXCdx7FuVp
	ghJS/Jr9XkqHOjjRXGSiZ2o4y9vmGH3+VvtlP6K2/Yab9+rSiuv2YSdKkcT7DfMPYORv0JuVght
	XYDercX9Rr4eU4dwpwaLMvgI+va9xobiLgIP+AdqLWPuD0iIr75FJlsDZx4ExBcJVbOIZYfI4vJ
	9kVTrIw0JYOXvxo1ZvuXS8Gg5ZlQfW0/jfVLnOR7jBGrWHwn3hkE7HP8vIP3NITA9DPNXwX3GJG
	leMsY607QPFEBgMV8yJtGaGlrzAFRZi8yqEQ2IiSD8/Ww+MgJquPzyiJvz6c3lS6RCLSvm/M2CB
	wetw2d8URhfgXC+J7GZSQCZwvg23MBDXCXAYoZ
X-Received: by 2002:a17:90b:3809:b0:396:4dfb:5890 with SMTP id 98e67ed59e1d1-39b260d333amr28142355a91.2.1788716757505;
        Sun, 06 Sep 2026 10:45:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b551b44a8sm1822594a91.7.2026.09.06.10.45.57
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:45:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398e1f7d1a5so3972659a91.0
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716756; x=1789321556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uC9YjQsKnxJ8TDL9hPQCQxOLanXtsl8beCjFw8R60W0=;
        b=OJhHLfxIe3vXq3+wTACWv10+oSKj+bkIqrDzYh2eag20BReuU5MJWWQtXLubWAzlV4
         u244+AeAV4c8bL2EJee1JJVy+lpaga6Y/gL/rj0cX00gx+ODeJm/1QeESB0WJi28oHYI
         clrZG15aOv9QM3+W0qcFZLGhvr2Uy6xCAzuHY=
X-Received: by 2002:a17:90a:d2c6:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-39b260d2f07mr28576335a91.3.1788716755691;
        Sun, 06 Sep 2026 10:45:55 -0700 (PDT)
X-Received: by 2002:a17:90a:d2c6:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-39b260d2f07mr28576265a91.3.1788716754998;
        Sun, 06 Sep 2026 10:45:54 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:45:54 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 3/8] RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
Date: Sun,  6 Sep 2026 16:06:55 -0700
Message-Id: <20260906230700.12233-4-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260906230700.12233-1-selvin.xavier@broadcom.com>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add a check if max sge for SRQ is exceeding the device
maximum.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 108be3a68b25..ab5d06034c20 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2389,6 +2389,13 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
 		wqe.num_sge = wr->num_sge;
+		if (wr->num_sge > srq->qplib_srq.max_sge) {
+			ibdev_err(&srq->rdev->ibdev,
+				  "Limit exceeded for SRQ Receive SGEs");
+			rc = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
-- 
2.39.3

