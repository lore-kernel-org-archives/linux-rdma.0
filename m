Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905EB4D2EC2
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 19:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044598; cv=none; b=W6U+eEwAGudclXx4F5HlR2I0mR88A9VuaSCd/fNLybCgM7zKufZvtENZRg6fBOYJwOTjFoIayCWfPIQQg+5bxVimGG93omH6BvWoC8Yvmj/lsea5vK+QAtwAnbwlb1q6TdRFITQiMFLnejdKROU17LNdVil6l/cnhF2xQ/6LNCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044598; c=relaxed/simple;
	bh=r4GnphE0mlp6eOGOWAahB1Modn6UNUuxVfxUGPWh9M4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDfiWU40W8zPCl7Za7aC+wP3WLi/gOB1DbhK0hhiaDsxFoXItfIAUxG4eLH2BZT8oWXNefaRXJ7xvzbaiKFjsAsvQYW9wIMDKnLNXm1Nf+yXcECtJ6ubC4toXqGaNThstzhCpS6toRlOTgZk6tR3gBmDrSfGS72aUBIk/c4oyOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dvzul2po; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dvzul2po"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2cace91f112so30259495ad.0
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044594; x=1786649394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w8cHUB6qDZNnZlrOdWgqMHJkuQh/6G0Q2CmRQL5oQs8=;
        b=Zcyi6o50lYHL/iPL6xK7ifJR+G9SSWjwrCBXXVjID69HxZY7eahC0ocP0TdMPsY0pD
         4EGbKzsYmjkkt7YJYJu2Cf8dxN5KJWsculW06kUT7TpyHUo8V16lFVhs92QvzOmz8KE9
         rBg6IMTiJ3290fHTRl18Hh9SwBE7cNrw66NEjbT1ySmNtTq+8CVGV2SJXn/zKwKZqvq8
         lhClVER++pzmBrjkXrkBxj1mtrehyb+dd4qciZOVwmeCWfotME7WT0lfEr+QGhiYCt6V
         cdgMZqY0g5bpxT/ZiPNV5uBEPM8c0PfRC5pKJYaC6h0aROg9zIO0AIEOQH7/pYYWBxAV
         PM4w==
X-Gm-Message-State: AOJu0YypjXNuzJ8GXr29r1fvgMeYmpIlEtW/up9VJpKpkiBZd3JeqJnG
	DAPWJ4ptlEF9zRqrL4kXxvRGArPzNIo2UHSSL9ciGVgmJB+4YGtg9o81p3KfCjQMBJCEX4AYYCk
	i7iHfMrXb4n0Rxy8pmNP0+LVC8kouQi1N4joIBOffMuAnQGMsbj4/xybLfHhu0yGVir2aB0QvoJ
	wwKFJiY85z40DlNcmeBNvVsFIUd5/nDde0lDe8DHdsw47c40d3PqOFjEPSx4PENAl5Fx7nOJXVF
	wd5TkXqU5enxFRfXg==
X-Gm-Gg: AR+sD13527pDqDhts8XQuyr0ow+5YYwcTiCeZN6LhnSsLyHygisPjn9K+GVUgmtbqil
	RfzseI99kOL5Q+fA6QHzL5CcvIm+wd37vQzJKURXWLD84YxUR0DD8omA9MvhooSH+RQ/qBbsUUK
	GxvDRjbSotH9EtOkXY4LU6bMLp1uarIWCZQg1Szi0fXfLp4yxV6uIhGCcPfLvrRBj8M6QlGMsnN
	XnwRllggCeHbVnc+FZQwKYKIsnxVvXGa2nt7W9bjxkeZc40XlU+uK/fuG1+Jv0DMwbIQ/9knYLP
	J8pZmw1/4DOxbFjRM32Bdr9g3DbGmWeU9MknQuoaCPQ2UQZaEj0xg3XdTZPV/Yx9PhPU6wPoNew
	aPJETaWYPlbjwqYf1PjCLnLuqpNgWNYsUmGht5x93vCBQoujePuw8SqK7eqbUGQNv/fiuduQWeu
	ob7ib1LVQeHlSJgcvzt8eRlufWrSBGkwFNDSzp
X-Received: by 2002:a05:6a20:7285:b0:3c3:7a0a:18a6 with SMTP id adf61e73a8af0-3cb85eea69cmr17136058637.18.1786044594192;
        Thu, 06 Aug 2026 12:29:54 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-141009f782csm51891c88.7.2026.08.06.12.29.53
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:29:54 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso2216744a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786044592; x=1786649392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w8cHUB6qDZNnZlrOdWgqMHJkuQh/6G0Q2CmRQL5oQs8=;
        b=dvzul2poTArJt/c+8/JCCdLmFlRsjEnXVYcBtdoGepELhicnz6c6zQcqt+iQoUY7DM
         5sN+OX/qBK9+8Z6LwJzBYEkGFVd04UUKlYl1ejmAePDxHunnNRyqd5vo79bH7D/++XbA
         vxoj7k0uBRYCbMI6TUjfwxQPAu/x4uojjfsDE=
X-Received: by 2002:a17:90b:4b87:b0:38e:85fb:71b9 with SMTP id 98e67ed59e1d1-3903c538254mr15731226a91.4.1786044591914;
        Thu, 06 Aug 2026 12:29:51 -0700 (PDT)
X-Received: by 2002:a17:90b:4b87:b0:38e:85fb:71b9 with SMTP id 98e67ed59e1d1-3903c538254mr15731167a91.4.1786044591297;
        Thu, 06 Aug 2026 12:29:51 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm28484575eec.13.2026.08.06.12.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:29:50 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	saravanan.vajravel@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 2/4] RDMA/bnxt_re: Prepare infrastructure for larger pages for Queue memory
Date: Thu,  6 Aug 2026 17:51:36 -0700
Message-Id: <20260807005138.771669-3-selvin.xavier@broadcom.com>
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

Add page-shift/FWO helpers, firmware capability detection
(dev_cap_ext_flags_1), and the fwo_offset field so CQ/QP setup
can be done with page sizes more than 4K. This also enables
using PBL pages of size more than 4k. Currently, the PBLs are
defaulted to 4K pages.

Also, update the variable type that holds the max queue entry
per page to accommodate more number of pages when huge pages
are used.

Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c  | 41 ++++++++++++++++++++---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 21 ++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_res.h | 34 +++++++++++++++++--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c  |  3 ++
 drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  2 ++
 drivers/infiniband/hw/bnxt_re/roce_hsi.h  |  4 ++-
 6 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 21caf34a1dc8..430d54f8f736 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1141,23 +1141,42 @@ static int bnxt_re_setup_swqe_size(struct bnxt_re_qp *qp,
 	return 0;
 }
 
+static int bnxt_re_get_page_shift(struct ib_umem *umem, u64 va, u64 cmask)
+{
+	unsigned long pgsz;
+
+	pgsz = ib_umem_find_best_pgsz(umem, cmask, va);
+	if (!pgsz)
+		return -EINVAL;
+	return __ffs(pgsz);
+}
+
 static int bnxt_re_setup_sginfo(struct bnxt_re_dev *rdev,
 				struct ib_umem *umem,
 				struct bnxt_qplib_sg_info *sginfo)
 {
+	struct bnxt_qplib_dev_attr *dev_attr = rdev->dev_attr;
 	unsigned long page_size;
+	int page_shift;
 
 	if (!umem)
 		return -EINVAL;
 
-	page_size = ib_umem_find_best_pgsz(umem, SZ_4K, 0);
-	if (!page_size || page_size != SZ_4K)
-		return -EINVAL;
+	if (bnxt_re_pbl_size_supported(dev_attr->dev_cap_ext_flags_1)) {
+		page_shift = bnxt_re_get_page_shift(umem, umem->address, dev_attr->page_size_cap);
+		if (page_shift < 0)
+			return page_shift;
+	} else {
+		page_shift = __builtin_ctz(SZ_4K);
+	}
 
+	page_size = BIT(page_shift);
 	sginfo->umem = umem;
 	sginfo->npages = ib_umem_num_dma_blocks(umem, page_size);
 	sginfo->pgsize = page_size;
-	sginfo->pgshft = __builtin_ctz(page_size);
+	sginfo->pgshft = page_shift;
+	sginfo->fwo_offset = ib_umem_dma_offset(umem, page_size);
+
 	return 0;
 }
 
@@ -1224,6 +1243,15 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 	if (rc)
 		goto fail;
 
+	/*
+	 * The FWO field passed in the CREATE_QP command is expressed in 4K
+	 * units, so the offset must be a multiple of 4K.
+	 */
+	if (qplib_qp->sq.sg_info.fwo_offset & (SZ_4K - 1)) {
+		rc = -EINVAL;
+		goto fail;
+	}
+
 	if (qp->qplib_qp.srq)
 		goto done;
 
@@ -1242,6 +1270,11 @@ static int bnxt_re_init_user_qp(struct bnxt_re_dev *rdev, struct bnxt_re_pd *pd,
 	if (rc)
 		goto rqfail;
 
+	if (qplib_qp->rq.sg_info.fwo_offset & (SZ_4K - 1)) {
+		rc = -EINVAL;
+		goto rqfail;
+	}
+
 done:
 	if (dbr_obj)
 		qplib_qp->dpi = &dbr_obj->dpi;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 756f8b5f042a..9a980f561661 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -174,6 +174,25 @@ void bnxt_qplib_free_hwq(struct bnxt_qplib_res *res,
 
 /* All HWQs are power of 2 in size */
 
+/*
+ * At PBL_LVL_0 there is a single PBL entry and firmware uses it as the
+ * literal queue base address rather than walking an indirection table,
+ * so it never applies the FWO field for this level. Adjust fwo_offset
+ * directly into that entry's DMA address instead.
+ */
+static void bnxt_qplib_adjust_lvl0_fwo(struct bnxt_qplib_hwq *hwq,
+				       struct bnxt_qplib_hwq_attr *hwq_attr)
+{
+	struct bnxt_qplib_pbl *pbl;
+
+	if (!hwq->is_user)
+		return;
+
+	pbl = &hwq->pbl[PBL_LVL_0];
+	pbl->pg_map_arr[0] += hwq_attr->sginfo->fwo_offset;
+	hwq_attr->sginfo->fwo_offset = 0;
+}
+
 int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			      struct bnxt_qplib_hwq_attr *hwq_attr)
 {
@@ -220,6 +239,8 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 		if (rc)
 			goto fail;
 		hwq->level = PBL_LVL_0;
+		if (hwq_attr->type == HWQ_TYPE_QUEUE)
+			bnxt_qplib_adjust_lvl0_fwo(hwq, hwq_attr);
 		goto done;
 	}
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.h b/drivers/infiniband/hw/bnxt_re/qplib_res.h
index b925db796729..ce6823af167e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.h
@@ -166,6 +166,8 @@ struct bnxt_qplib_sg_info {
 	u32				npages;
 	u32				pgshft;
 	u32				pgsize;
+#define BNXT_QPLIB_QP_FWO_SHIFT		12      /* FWO is conveyed to firmware in 4K units */
+	u32				fwo_offset;	/* first-word offset into huge page */
 	bool				nopte;
 };
 
@@ -192,7 +194,7 @@ struct bnxt_qplib_hwq {
 	u32				max_elements;
 	u32				depth;
 	u16				element_size;	/* Size of each entry */
-	u16				qe_ppg;	/* queue entry per page */
+	u32				qe_ppg;	/* queue entry per page */
 
 	u32				prod;		/* raw */
 	u32				cons;		/* raw */
@@ -369,7 +371,7 @@ static inline u8 bnxt_qplib_base_pg_size(struct bnxt_qplib_hwq *hwq)
 	u8 pg_size = BNXT_QPLIB_HWRM_PG_SIZE_4K;
 	struct bnxt_qplib_pbl *pbl;
 
-	pbl = &hwq->pbl[PBL_LVL_0];
+	pbl = &hwq->pbl[hwq->level];
 	switch (pbl->pg_size) {
 	case ROCE_PG_SIZE_4K:
 		pg_size = BNXT_QPLIB_HWRM_PG_SIZE_4K;
@@ -639,4 +641,32 @@ static inline bool _is_modify_qp_rate_limit_supported(u16 dev_cap_ext_flags2)
 		CREQ_QUERY_FUNC_RESP_SB_MODIFY_QP_RATE_LIMIT_SUPPORTED;
 }
 
+/* PBL page size encoding values for HWRM commands */
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_4K	0x0UL
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_8K	0x1UL
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_64K	0x2UL
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_2M	0x3UL
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_8M	0x4UL
+#define BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_1G	0x5UL
+
+/**
+ * bnxt_re_pbl_size_supported - check if firmware supports non-4K PBL pages
+ * @dev_cap_ext_flags_1: value of the dev_cap_ext_flags_1 field from QUERY_FUNC response
+ *
+ * Returns non-zero if the firmware can accept PBL pages larger than 4K.
+ */
+static inline int bnxt_re_pbl_size_supported(u8 dev_cap_ext_flags_1)
+{
+	return dev_cap_ext_flags_1 &
+		CREQ_QUERY_FUNC_RESP_SB_PBL_PAGE_SIZE_SUPPORTED;
+}
+
+static inline u8 bnxt_qplib_get_pbl_page_size(struct bnxt_qplib_sg_info *sginfo)
+{
+	/* Only 4K PBL pages are supported for now; extend this when QP/CQ
+	 * PBLs start using the larger page sizes sginfo can report.
+	 */
+	return BNXT_QPLIB_HWRM_PBL_PG_SIZE_PG_4K;
+}
+
 #endif /* __BNXT_QPLIB_RES_H__ */
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 71240f7be9e6..5fa78f156df3 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -176,8 +176,11 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 	attr->max_sgid = min_t(u32, BNXT_QPLIB_NUM_GIDS_SUPPORTED, 2 * attr->max_sgid);
 	attr->dev_cap_flags = le16_to_cpu(sb->dev_cap_flags);
 	attr->dev_cap_flags2 = le16_to_cpu(sb->dev_cap_ext_flags_2);
+	attr->dev_cap_ext_flags_1 = sb->dev_cap_ext_flags_1;
 
 	attr->mr_page_size_cap = BIT_ULL(28) | BIT_ULL(21) | BIT_ULL(16) | BIT_ULL(12);
+	/* For Queue memories */
+	attr->page_size_cap = BIT_ULL(21) | BIT_ULL(16) | BIT_ULL(13) | BIT_ULL(12);
 
 	if (_is_max_srq_ext_supported(attr->dev_cap_flags2))
 		attr->max_srq += le16_to_cpu(sb->max_srq_ext);
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index b16e12d3b7ab..5d2a5b905405 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -79,6 +79,8 @@ struct bnxt_qplib_dev_attr {
 	u32                             max_dpi;
 	u16				rate_limit_min;
 	u32				rate_limit_max;
+	u8				dev_cap_ext_flags_1;
+	u64				page_size_cap;
 };
 
 struct bnxt_qplib_pd {
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index aac338f2afd8..c89fc54f61c3 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -2244,7 +2244,9 @@ struct creq_query_func_resp_sb {
 	__le16	max_inline_data_var_wqe;
 	__le32	start_qid;
 	u8	max_msn_table_size;
-	u8	reserved8_1;
+	u8	dev_cap_ext_flags_1;
+	#define CREQ_QUERY_FUNC_RESP_SB_PBL_PAGE_SIZE_SUPPORTED		0x1UL
+	#define CREQ_QUERY_FUNC_RESP_SB_WQE_INLINE_OPTIMIZER_SUPPORTED	0x20UL
 	__le16	dev_cap_ext_flags_2;
 	#define CREQ_QUERY_FUNC_RESP_SB_OPTIMIZE_MODIFY_QP_SUPPORTED             0x1UL
 	#define CREQ_QUERY_FUNC_RESP_SB_CHANGE_UDP_SRC_PORT_WQE_SUPPORTED        0x2UL
-- 
2.39.3

