Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B273D5C07
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044600; cv=none; b=K++8lg5SV5bT4XbkxWH+xTTSdRlx92CpNkKKPmC2B6QUMipwdl/4efye7ux9F3iG09/6bWHCl+XwTzolPzI1YFyIkCjuCnieLx1hCyoS8L5WZOdZvmkdjYysU0UasZWw4UejAr/sbRHtvcfMzVoU1H5Mf3m1Mu5w98NolQKMDqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044600; c=relaxed/simple;
	bh=9RYKEVQ8DA/hjWq/ngGmAfHOpPGV8ANT8BNEg2xmfJA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I+n1GQVwmeXZkOs9wu1iW0Y5+WSkGlnIBuUOv1oclkFIKII5pInS4W06pfd4Rx2lrsZY9hWVUm0HrGkYklZ+Tn3MSTAyF2dmg1wpSl5MOA1/kMatSWCLi8t2kweyqSptUuqO/RGhvJiBif3LlXRhm0QM8vp0X50jscyqJw6krN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cU99pftG; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cU99pftG"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso2238833a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044597; x=1786649397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qCDgI+JlB9+5qVYI3gm4I/u2nQn4/OSLIi+wiIh4Y2E=;
        b=U60pVMtcixmDRo3LQta/AGJbZkOid+ziLP2mXj+1F0s+D7AxlwA3p5469Zsbp/l4eR
         lcW4eEmDp8eN75+ISESRGcvqWZLceSYT5KotdD4X2JCtO0BE11/BGxgEFQZzwhVc3j2i
         zqWptWX3617NfpR2ibqrLnJSK62T3n/O2d/ba/jeVNPxhBFY7YGtC7SYreL/JTmwu4F9
         hSYQCwfrw4KSs8aBrLmTpSvokthDXpS6xN+S87UI38y/hcN0udDxm1eA+PTNG5rs4eeI
         qHG/lg24em7Xv7wP4HDwjoJmzE1gvWduyUw10hfeFpYHdZYPYMhXyt+4j+qfzRiDq5U7
         rYRw==
X-Gm-Message-State: AOJu0YxFsC7PhGqFfCvgo8LVYIDsNurNZqaNGIuNNOMTT/0COXXyl3LO
	Lm99sXiJFvjlcwuJy1CrJNMSb7bnN86JWw/tE5x4ZrNqM3QdreVlXVzFP0eDbY+6lxYsVAunveV
	RXC8lQCSFF+EqiPfsevDtrlb1OyZvoB1Q5kOyKgw80KMKhWz5uXDaT3I6yyz28J+PbNEJmnUezF
	r0KEvZvSaFO/E2Vxi7RYU8QNpnSyMYaDJm3aGo2eSYFzWbnpKl6dj5HWPST5fy47c6n2N546Sqm
	JlpoPPnAfCRpYzvTA==
X-Gm-Gg: AR+sD13iqfIvs6+RzmuYW0RELVwWh6WiPuG9yZVCYIyf9KOUW5jjDI2is3Vsx9QIvR1
	DPlrdTCcfAUX5KY0yJeF1ACa+QnVXFXWeCs5fM0ECQF/AtfGm65HXL4716pV4Lw3M27bf0eCgyr
	93Fzppgiw0oi0V//nPWwvD8JAUh1+EiOB+hNofeVs92WLXarmNWB0FEDb9EK7l8I/k/mIswU3SJ
	e0RmoZgkJeNlYKG+Iqm7teebD2CCIqg2GPkKa09AgrmcCpB2VurTY5i6JcbJmiglTYFvnrjR3pv
	JTAFjhWfBWUxx6UEvCf34vX4azShrDWt95GL113ShVStyodXWWOZo/08lJ2c20/ViL3Nqi/HeaP
	q+pe/yobC4l6c5Oh0xWYLbMwJjOQY6fKLZdWLqIKnn/CehfPPk5FXmUtZofS75MUX+wAAAhjeyl
	4hTENE17Zy72hR3zZaa5fmOxzK0vmwbGdcxA==
X-Received: by 2002:a17:90b:1d02:b0:37f:fd1f:d30f with SMTP id 98e67ed59e1d1-3903c595ef1mr17202978a91.12.1786044596959;
        Thu, 06 Aug 2026 12:29:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-390a9697ab5sm314530a91.7.2026.08.06.12.29.56
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:29:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc640dfde3so29710755ad.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786044595; x=1786649395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qCDgI+JlB9+5qVYI3gm4I/u2nQn4/OSLIi+wiIh4Y2E=;
        b=cU99pftGGSf0G0jDeZ33dOxa4EVUgOzAQ6K+j1gNcbIR/Xdy7cbnXrvhHpdjBohyGJ
         XTmNiFcKl7SwVC57WHdOzovrR8xbxuz1jqBVLnLXint5/acg/1t7CF3ru9nUhZsXG2aS
         OuWVXU9jIZs2TGyKpCdkdS9Ed6sQXmUHlulWg=
X-Received: by 2002:a17:902:c402:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2d0ca7b024fmr188143365ad.2.1786044594989;
        Thu, 06 Aug 2026 12:29:54 -0700 (PDT)
X-Received: by 2002:a17:902:c402:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2d0ca7b024fmr188142955ad.2.1786044594452;
        Thu, 06 Aug 2026 12:29:54 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm28484575eec.13.2026.08.06.12.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:29:54 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	saravanan.vajravel@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 3/4] RDMA/bnxt_re: Add support for larger PBL pages for CQ
Date: Thu,  6 Aug 2026 17:51:37 -0700
Message-Id: <20260807005138.771669-4-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260807005138.771669-1-selvin.xavier@broadcom.com>
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Advertise the PBL page size and first-completion offset (FCO)
in CREATE_CQ so the firmware can use huge-page CQ buffers.

Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  9 +++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c  | 11 +++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_res.h |  1 +
 drivers/infiniband/hw/bnxt_re/roce_hsi.h  | 13 ++++++++++++-
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 430d54f8f736..da4de44cf90d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3611,6 +3611,15 @@ int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *att
 	if (rc)
 		goto free_umem;
 
+	/*
+	 * The FCO field passed in the CREATE_CQ command is expressed in
+	 * 32-byte units, so the offset must be a multiple of 32 bytes.
+	 */
+	if (cq->qplib_cq.sg_info.fwo_offset & (BIT(BNXT_QPLIB_CQ_FCO_SHIFT) - 1)) {
+		rc = -EINVAL;
+		goto free_umem;
+	}
+
 	cq->qplib_cq.dpi = &uctx->dpi;
 	cq->qplib_cq.max_wqe = entries;
 	cq->qplib_cq.coalescing = &rdev->cq_coalescing;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 5301e4f21ade..0319fe76c634 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2147,9 +2147,16 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
 	pg_sz_lvl |= (cq->hwq.level & CMDQ_CREATE_CQ_LVL_MASK);
 	req.pg_size_lvl = cpu_to_le32(pg_sz_lvl);
 	req.pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+	if (bnxt_re_pbl_size_supported(res->dattr->dev_cap_ext_flags_1)) {
+		req.flags |= cpu_to_le16(CMDQ_CREATE_CQ_FLAGS_PBL_PG_SIZE_VALID);
+		req.pbl_pg_size = bnxt_qplib_get_pbl_page_size(&cq->sg_info);
+	}
 	req.cq_fco_cnq_id = cpu_to_le32(
-			(cq->cnq_hw_ring_id & CMDQ_CREATE_CQ_CNQ_ID_MASK) <<
-			 CMDQ_CREATE_CQ_CNQ_ID_SFT);
+			((cq->cnq_hw_ring_id & CMDQ_CREATE_CQ_CNQ_ID_MASK) <<
+			 CMDQ_CREATE_CQ_CNQ_ID_SFT) |
+			(((cq->sg_info.fwo_offset >> BNXT_QPLIB_CQ_FCO_SHIFT)
+			  << CMDQ_CREATE_CQ_CQ_FCO_SFT) &
+			 CMDQ_CREATE_CQ_CQ_FCO_MASK));
 	bnxt_qplib_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
 				sizeof(resp), 0);
 	rc = bnxt_qplib_rcfw_send_message(rcfw, &msg);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index ce6823af167e..d2b3835789f3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -167,6 +167,7 @@ struct bnxt_qplib_sg_info {
 	u32				pgshft;
 	u32				pgsize;
 #define BNXT_QPLIB_QP_FWO_SHIFT		12      /* FWO is conveyed to firmware in 4K units */
+#define BNXT_QPLIB_CQ_FCO_SHIFT		5	/* FCO is conveyed to firmware in 32-byte units */
 	u32				fwo_offset;	/* first-word offset into huge page */
 	bool				nopte;
 };
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index c89fc54f61c3..bbcd723cd2b5 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -1146,6 +1146,7 @@ struct cmdq_create_cq {
 	#define CMDQ_CREATE_CQ_FLAGS_STEERING_TAG_VALID                0x2UL
 	#define CMDQ_CREATE_CQ_FLAGS_INFINITE_CQ_MODE                  0x4UL
 	#define CMDQ_CREATE_CQ_FLAGS_COALESCING_VALID                  0x8UL
+	#define CMDQ_CREATE_CQ_FLAGS_PBL_PG_SIZE_VALID                 0x10UL
 	__le16	cookie;
 	u8	resp_size;
 	u8	reserved8;
@@ -1178,7 +1179,17 @@ struct cmdq_create_cq {
 	__le32	cq_size;
 	__le64	pbl;
 	__le16	steering_tag;
-	u8	reserved48[2];
+	u8	pbl_pg_size;
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_MASK  0x7UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_SFT   0
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_4K   0x0UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_8K   0x1UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_64K  0x2UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_2M   0x3UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_8M   0x4UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_1G   0x5UL
+	#define CMDQ_CREATE_CQ_PBL_PG_SIZE_LAST   CMDQ_CREATE_CQ_PBL_PG_SIZE_PG_1G
+	u8	reserved8_1;
 	__le32  coalescing;
 	#define CMDQ_CREATE_CQ_BUF_MAXTIME_MASK          0x1ffUL
 	#define CMDQ_CREATE_CQ_BUF_MAXTIME_SFT           0
-- 
2.39.3

