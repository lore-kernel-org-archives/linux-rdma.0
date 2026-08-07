Received: from mail-vk1-f228.google.com (mail-vk1-f228.google.com [209.85.221.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81193D6CDD
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044602; cv=none; b=stCMvUlRxdV5jDdejvQDFAamqeVAXaWMvjrk6zdbpeUxo/Os3vFnOsVRuJrO8V0Ql03nlwDZTffOg/UgTOBqwTsjDjuGa+2wm57KA5a28FCjyNkXVR2u9SY4TsZVn1TJLUwGhnbSGVs8TNCrMou5cM0l3WsLGiw/EV8sTI8ZLzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044602; c=relaxed/simple;
	bh=kH2BdwdC2VnPNHSwN9gVlL7kbkWIln7fwObl9Mij53U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j7v5lFlKNDjKE9dH2PUfYyYTIWpaiCeF9L9TxmrwZdjFRujV00wciGDjQFEIxe2qjwTdxUUdiVknYwrl9iiBE7dBRllQzCXykVEHMCjNXn1ITTclGrEm6YimOc3Kg7k0R58y1mWoRBrWwXVqomLi4Z5WIEtm/++F/1mI14TUYZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ehgdwo9/; arc=none smtp.client-ip=209.85.221.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ehgdwo9/"
Received: by mail-vk1-f228.google.com with SMTP id 71dfb90a1353d-5c2c0df0b45so880272e0c.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786044599; x=1786649399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0T+fJOaRtQwKYzPWhLYqkOXp6DYAUNRLscX8XontZ2s=;
        b=QW+QoBEFi9cWpCu8h8Jg0Dpc5d+3jEKB/4R4Yw0E9ydZLx73yF2m+PUredxyEB5Kdg
         NIX+1Rn38VHe/VdpkOfcZMyF9i5Y8E68DWWQ/7/ZFPVx66xdjSv7It5Bk0RHepBQwcFp
         05/vGRKTa6oYZYrdyLZ4yeL12qS/JdN7ITgCiqX1BlarrudeLe8K3TTdCsGDktrukYKM
         xSYiI61u6AnJRe+ld4v+1g+VLRFhPvngmYkhPNl2//tYT5zqDGqjEAw5jE6VFk+8V4l3
         7ftycrlxRPk7CjttJgBU6EhgfudE9eFLZ0IlS+dZtZCwBK7am7EBRbgTEICCpIRQzXMr
         Z1kw==
X-Gm-Message-State: AOJu0Yy/pCJZb0iyN1Zc50ahQUTr2w4A9QuwfzHYPFh0IApy9KjcQskR
	iTjnUGO949+6xMys+ZcxWSe9fE+6zOrcgd+xRr7pfGbbOdnM/1tBpO95DSLm8bNBWvtytK7v5hK
	VL+VgFgV5RrQvADpueY3gDKtS4A0UhxR8oSecC9Sg2SfnGsp6eSjKlQNNdLxZcdffaX95mL9hwy
	Xyqj6f7RdSPQlG5xSV4i3QrTLtYvLThgNvpE1DHDGerW18veg4DtsitaWvRrUs33zBHZGTlD+c2
	xMm0pFZ/IGC73ZhGw==
X-Gm-Gg: AR+sD13R8ftBuua//SU6jGw1ds61MWJqC17+D9Oi/g//jp1KxLbaLHBPJ2bmXiVWe7L
	AKQRv9THP3afX+YqwJQ8RyDAh+1VqNzID+zCwlgJQ8qlYxPHtcivKCxbAfkpyMoENcoMveoH9+B
	ukG52XEpkXRjhqYpSDAYXNZVqoS1Yy0ZObBmk/P3QERVVq/bjXL0p6zYpkckn/3e3oY0ei/9Pnn
	LaeEGGVH3hakMHceaAI8BGA0v31yt/ZeE1Rl1hr4uDjf4b0GSC4lS+PygqDOa8968LJuNChwHpK
	5EGck5FPX3bjZU+ndxAcn6FDp7UFI478XnTesSGUBF1v6zftv3OFa2PxaUtZLgO93zNwZ63PlnO
	RZkVJttZPEH8+77QQvJ68EXLvFPqJF/q8xHCuU7HjKy1djZfKawEgMxr1qbVFuWqlrQMlAxZJcE
	U9J457rmHnYACcAPJm1UcgAtzP1tlvRJBaSQ==
X-Received: by 2002:a05:6122:2492:b0:5c1:781:7122 with SMTP id 71dfb90a1353d-5c3d907e08amr2070498e0c.3.1786044599266;
        Thu, 06 Aug 2026 12:29:59 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c3d04d7310sm1839746e0c.2.2026.08.06.12.29.59
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 12:29:59 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca8aee88725so3625317a12.3
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 12:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786044598; x=1786649398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0T+fJOaRtQwKYzPWhLYqkOXp6DYAUNRLscX8XontZ2s=;
        b=ehgdwo9/ljtC1Jc2n7fJl4B9PPYxQk/xme2rsb7KUQ8RDNf0aOAuSlNBzBzfK7K700
         ZXB0vebb1OhYIljn2qZ4PwMNKpcrDKyptjtEMV1yKyDOQUwplFvmPdz2ae5MR38d+WMv
         3O6Mr8ewAlsfAe94nMo0ICNBQz7MaSFjmPQQM=
X-Received: by 2002:a05:6a20:4321:b0:3c3:b57b:6291 with SMTP id adf61e73a8af0-3cb85e6689fmr18884563637.18.1786044598118;
        Thu, 06 Aug 2026 12:29:58 -0700 (PDT)
X-Received: by 2002:a05:6a20:4321:b0:3c3:b57b:6291 with SMTP id adf61e73a8af0-3cb85e6689fmr18884530637.18.1786044597669;
        Thu, 06 Aug 2026 12:29:57 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm28484575eec.13.2026.08.06.12.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:29:57 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	saravanan.vajravel@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next 4/4] RDMA/bnxt_re: Add support for larger PBL pages for QP
Date: Thu,  6 Aug 2026 17:51:38 -0700
Message-Id: <20260807005138.771669-5-selvin.xavier@broadcom.com>
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

Advertise the PBL page size and first-word offset (FWO) for SQ/RQ
in CREATE_QP so the firmware can use huge-page QP buffers.

Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 19 +++++++++++++-----
 drivers/infiniband/hw/bnxt_re/roce_hsi.h | 25 ++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 0319fe76c634..2fb06abda552 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -985,9 +985,14 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	pbl = &sq->hwq.pbl[PBL_LVL_0];
 	req.sq_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
 	req.sq_pg_size_sq_lvl = sq->hwq.pg_sz_lvl;
+	if (bnxt_re_pbl_size_supported(res->dattr->dev_cap_ext_flags_1)) {
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_SQ_PBL_PG_SIZE_VALID;
+		req.sq_pbl_pg_size = bnxt_qplib_get_pbl_page_size(&sq->sg_info);
+	}
 	req.sq_fwo_sq_sge =
-		cpu_to_le16(((sq->max_sge & CMDQ_CREATE_QP_SQ_SGE_MASK) <<
-			     CMDQ_CREATE_QP_SQ_SGE_SFT) | 0);
+		cpu_to_le16((((sq->sg_info.fwo_offset >> BNXT_QPLIB_QP_FWO_SHIFT) <<
+			      CMDQ_CREATE_QP_SQ_FWO_SFT) & CMDQ_CREATE_QP_SQ_FWO_MASK) |
+			    (sq->max_sge & CMDQ_CREATE_QP_SQ_SGE_MASK));
 	req.scq_cid = cpu_to_le32(qp->scq->id);
 
 	/* RQ */
@@ -997,12 +1002,16 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		pbl = &rq->hwq.pbl[PBL_LVL_0];
 		req.rq_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
 		req.rq_pg_size_rq_lvl = rq->hwq.pg_sz_lvl;
+		if (bnxt_re_pbl_size_supported(res->dattr->dev_cap_ext_flags_1)) {
+			qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_RQ_PBL_PG_SIZE_VALID;
+			req.rq_pbl_pg_size = bnxt_qplib_get_pbl_page_size(&rq->sg_info);
+		}
 		nsge = (qp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC) ?
 			6 : rq->max_sge;
 		req.rq_fwo_rq_sge =
-			cpu_to_le16(((nsge &
-				      CMDQ_CREATE_QP_RQ_SGE_MASK) <<
-				     CMDQ_CREATE_QP_RQ_SGE_SFT) | 0);
+			cpu_to_le16((((rq->sg_info.fwo_offset >> BNXT_QPLIB_QP_FWO_SHIFT) <<
+				      CMDQ_CREATE_QP_RQ_FWO_SFT) & CMDQ_CREATE_QP_RQ_FWO_MASK) |
+				    (nsge & CMDQ_CREATE_QP_RQ_SGE_MASK));
 	} else {
 		/* SRQ */
 		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_SRQ_USED;
diff --git a/drivers/infiniband/hw/bnxt_re/roce_hsi.h b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
index bbcd723cd2b5..aa85cd379e48 100644
--- a/drivers/infiniband/hw/bnxt_re/roce_hsi.h
+++ b/drivers/infiniband/hw/bnxt_re/roce_hsi.h
@@ -437,8 +437,10 @@ struct cmdq_create_qp {
 	#define CMDQ_CREATE_QP_QP_FLAGS_EXPRESS_MODE_ENABLED       0x100UL
 	#define CMDQ_CREATE_QP_QP_FLAGS_STEERING_TAG_VALID         0x200UL
 	#define CMDQ_CREATE_QP_QP_FLAGS_RDMA_READ_OR_ATOMICS_USED  0x400UL
+	#define CMDQ_CREATE_QP_QP_FLAGS_RQ_PBL_PG_SIZE_VALID       0x2000UL
+	#define CMDQ_CREATE_QP_QP_FLAGS_SQ_PBL_PG_SIZE_VALID       0x4000UL
 	#define CMDQ_CREATE_QP_QP_FLAGS_LAST                      \
-		CMDQ_CREATE_QP_QP_FLAGS_RDMA_READ_OR_ATOMICS_USED
+		CMDQ_CREATE_QP_QP_FLAGS_SQ_PBL_PG_SIZE_VALID
 	u8	type;
 	#define CMDQ_CREATE_QP_TYPE_RC            0x2UL
 	#define CMDQ_CREATE_QP_TYPE_UD            0x4UL
@@ -501,7 +503,26 @@ struct cmdq_create_qp {
 	__le64	orrq_addr;
 	__le32	request_xid;
 	__le16	steering_tag;
-	__le16	reserved16;
+	u8	sq_pbl_pg_size;
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_MASK  0xfUL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_SFT   0
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_4K   0x0UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_8K   0x1UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_64K  0x2UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_2M   0x3UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_8M   0x4UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_1G   0x5UL
+	#define CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_LAST   CMDQ_CREATE_QP_SQ_PBL_PG_SIZE_PG_1G
+	u8	rq_pbl_pg_size;
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_MASK  0xfUL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_SFT   0
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_4K   0x0UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_8K   0x1UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_64K  0x2UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_2M   0x3UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_8M   0x4UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_1G   0x5UL
+	#define CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_LAST   CMDQ_CREATE_QP_RQ_PBL_PG_SIZE_PG_1G
 };
 
 /* creq_create_qp_resp (size:128b/16B) */
-- 
2.39.3

