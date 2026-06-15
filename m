Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04AD416D0E
	for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781544351; cv=none; b=F8CA1GNMjMHSGHC/jvT6t1D91m7LktJqSWy8NGDcmgTfoL5mnpP6983JVOqSJJ25K/6qJIFkn9LLIhv2hstKj1a7dJXgpE/d+PROmZH7uZHO7S5wjPYfqvr5SLS+5pRMvPxgew+n86110vMQfQGOVOg62YK9W7FFvg/AEjqDuIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781544351; c=relaxed/simple;
	bh=1ddqw047SxrM5WuZBfKM3LdObgnRVrap6zSmky+hNkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=urgygD4MD7RMsYvFJvikGUyPTR39CC7jgrWmAk1TYSH5EljeaSWswNUm2kRHrauSFgPlC759pVdRjXnu4dxw7hOCQRUaNGIJ+lbGcvVm55At0AM6t+Ak7Giwt7qmRT0ZfQu6qr7N6aZVA7yX2DsjCGlmHo5cUTGUh/ZRYhfowpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AurIZjnC; arc=none smtp.client-ip=209.85.128.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AurIZjnC"
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-7f4f1c27e61so21731917b3.2
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 10:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781544349; x=1782149149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITfuQ91Jxy7qMMEjRseo4ZgnYZDLoeclpkZ94HKoSNk=;
        b=oCaaBqinnJjvHwMcEEemY1pj6vijtr1GKELjVpeE5z2DMFH6FLYnzXaOFgaLbnPDR+
         GSR4saXUSMGAwgBYw8e4HYmNs8tSCQqK3eSwr39mVggt6o1qEYkBF5AJ8yby96okJuSc
         rDc+KQpWgPIfuZbSN3GSjysMsuL8SmcA0piNa7nAEIs8jCEZVHWDEfyRVj1Myl1H+SFO
         jqp/+oeXnV2oRmT1/0OOxBr4uzSWBZdaLh6Tw+2n+aNwME1cEz1pdjt0RImyjxSRZcHL
         xrsn1AL50lV/YuMCnSztq+T6WP82DlCa/JImF885oM53EDJr0s3zueHD+mF1Cgfs+bIF
         JRJQ==
X-Gm-Message-State: AOJu0YxRYk28pgEHldSsljtUXs75ki+A2uNgeL5XoBAdCb20C2iDiEfd
	6soaYCyu8sm/Bgrp/Vtu3k+KzWSQUy/A4cCRWbQpoRefAW/+vDW2GDJXyA+4oa27mYfWJGxuGr/
	/KcN/G0NWVFyB/YypmFV8cU8fZ5hRNNYzKkn17jorFcBbfX0oRwQUyc7Z/PuPPW6xHDVUqlMtER
	ZHOrbndKufRCkESYXATtP0FblHgVqmsyGDI2jG3negEVZUiTC8g26wS5wgjrTrxzPDH0il00dWx
	qyZTD1CcQWDMu47sA==
X-Gm-Gg: Acq92OHrD9wSpnsKtmoen5FLfueZXpu5F+eDPLN0Xjv/0tFCNWwG0/FC9YIN2sKpoWR
	yTFaKGjweWqaLSujZzujvsDb/D8LGG1ajh4UQr/mw0isC5m8R2RNfGr4Nvn79/5DRy37cHyetJv
	XQ77hNaG/Yf6sEcnoc8Dj9d14Lb0LntohkPUmDq48Yxv22B3UJwkm+7Qz4FWl1pRXXclM0jSKov
	u3we0nlsZcSgSmyxjzn4i7+eNQ+IpO6kwGUL5wbUEo4F0LkSSNS8HQfkpT3gVxU9HjwPNrqBaBP
	UsFB15wOCw5XO23Oqe57mDSfMYhhsrss42ZML1oQevjNH2nHsec5GqEh+Kb8RL+zF/uaMEpHnhj
	7zieDyjrZ20MBlPXWYVqoHm2IHqVKT1DXKyuuoDUbhNSdzcPn4DL0917K0ICMo/ctohsctYn7tb
	9w8VRp6K+YO7gW/nvYinxKZw47/NDfVT7Wp0AKU2xonMK60qLps0d8M/gfYQ==
X-Received: by 2002:a05:690c:9a8e:b0:7dd:63c7:3998 with SMTP id 00721157ae682-7fcfd03fefemr78927b3.5.1781544348574;
        Mon, 15 Jun 2026 10:25:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-18.dlp.protect.broadcom.com. [144.49.247.18])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7fcd306ad40sm260447b3.25.2026.06.15.10.25.48
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2026 10:25:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2bf32fb7cb2so26517085ad.2
        for <linux-rdma@vger.kernel.org>; Mon, 15 Jun 2026 10:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781544347; x=1782149147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITfuQ91Jxy7qMMEjRseo4ZgnYZDLoeclpkZ94HKoSNk=;
        b=AurIZjnCES57nsJ47e7bSBNy3w2CiW4rUsfMkIzxYwDXsv5Kw2G+XZ6Z2yVMpFBIj+
         nxhzO9FFXfJa5+v/1bp1foUefHXlBCFbaPFaCDYP9CuLsc+N72GKYdozwCW7Nv12mWs+
         9GpirjdsRVmd45CZPmf7rZp87rS7mAHW5MhtM=
X-Received: by 2002:a17:903:41c5:b0:2c0:a373:89b9 with SMTP id d9443c01a7336-2c69a0dc355mr1969175ad.6.1781544347429;
        Mon, 15 Jun 2026 10:25:47 -0700 (PDT)
X-Received: by 2002:a17:903:41c5:b0:2c0:a373:89b9 with SMTP id d9443c01a7336-2c69a0dc355mr1968825ad.6.1781544346923;
        Mon, 15 Jun 2026 10:25:46 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a43c9sm108289285ad.41.2026.06.15.10.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 10:25:46 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH rdma-rc v2 07/15] RDMA/bnxt_re: Add ownership check while getting the SRQ toggle page
Date: Mon, 15 Jun 2026 15:47:43 -0700
Message-Id: <20260615224751.232802-8-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260615224751.232802-1-selvin.xavier@broadcom.com>
References: <20260615224751.232802-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The SRQ resource id provided by user-space is used for
searching the driver SRQ structure. Validate if the context
currently issuing the request is same as the context
created the resource.

Fixes: eee6268421a2 ("RDMA/bnxt_re: Move the UAPI methods to a dedicated file")
Fixes: 181028a0d84c ("RDMA/bnxt_re: Share a page to expose per SRQ info with userspace")
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.h | 1 +
 drivers/infiniband/hw/bnxt_re/uapi.c     | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 13b18e4ae7cd..e7a08b12ca21 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2246,6 +2246,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 
 	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
 	srq->rdev = rdev;
+	srq->uctx = uctx ? &uctx->ib_uctx : NULL;
 	srq->qplib_srq.pd = &pd->qplib_pd;
 	srq->qplib_srq.dpi = &rdev->dpi_privileged;
 	/* Allocate 1 more than what's provided so posting max doesn't
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 7217b4692419..ff3148340fd3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -73,6 +73,7 @@ struct bnxt_re_ah {
 struct bnxt_re_srq {
 	struct ib_srq		ib_srq;
 	struct bnxt_re_dev	*rdev;
+	struct ib_ucontext	*uctx;
 	u32			srq_limit;
 	struct bnxt_qplib_srq	qplib_srq;
 	struct ib_umem		*umem;
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 3f5ae1920aef..ae8f46ab6961 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -270,6 +270,11 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		if (!srq)
 			return -EINVAL;
 
+		if (srq->uctx != ib_uctx) {
+			bnxt_re_put_srq(srq);
+			return -EINVAL;
+		}
+
 		addr = (u64)srq->uctx_srq_page;
 		bnxt_re_put_srq(srq);
 		break;
-- 
2.39.3

