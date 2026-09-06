Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2603D0C09
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716763; cv=none; b=Meef0pCnPZDLs0pPPB25cTGJVJBbebczDY0mWGz8NRxXwatRTscntYgECHICEEWPIPUcvzGZ2lsG3uo8acxwNq9KCkLahN1JYi26P8k0dgskBhN5sfM4tSqX/4XuxvfgNbDh8/EaaKLCHZUnjxN9RjVh98KLFxCAGMjsEjMVjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716763; c=relaxed/simple;
	bh=nyHzpFZddIUARAancNs0u4Se0RQCLUiBQU0QadOJlDo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oyZ/Jl7ReT+FITmRmA6hot5sqFfRIjJjNVX6usnt3dw1KQB7/jLjKXaFeN9sSiUkCmEYOotVKZvNHxyP5ufteF3YTS6vJrwMr5U8aLduFLVSEXXXya3siEPVDi3gIOTuotlAmN9VBXKn+/rW5QVfALCkITmx/x8stpHSxlbmc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fvBTRsx6; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fvBTRsx6"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2d58efc7356so34285875ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716761; x=1789321561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2KTEnu/wDi12ltmIR8vM/A4bsy6DjZieTYGS1jyZ2wo=;
        b=iW9GLUd4FR5zDs25sTV5dtymgpt97ysg2ya3w6LJ0AFiMxurm3H+LVJqsFlLJiKwr7
         nH81k2Z/5644lQpsPvAL8lH1qvOFQ9rB1oIRWX8vHfG8YXstoedEMkZOCyNVIEqhcfKh
         a9LEHc1olGF7Rds43UUUbBFp6HqqwamCw1ALoIAgM/jOXk+kzrI3lTea5LH80KdfDSLa
         Wq8iPq7vcH34WzWkpGkblWj8KKQlJ4yrbOaQqdVNvwJ/4EA/Y/+PuBlZas4Fp07Yq7X8
         hhrGsHEljiEsJ3AXIToH+9ho9xhejfnXnfXiTrWpfFjmAUY0b9atsTBSQfMM4w7PpOOk
         5EUg==
X-Gm-Message-State: AFuF++me8Gm0GBVmzMtMvv/K06NuS3m9tP4XzMT4wjPwWjJyOalJ/POB
	ME0eHG+1ygAbY3FfkdqgLCo4cX4+0stKZudzU3Bny8lZ06VOsxIEx6EjOVUtJqQv8BEyYeqIRBi
	OulM0muq1Ib7C9VTtBj4WqM6A+pdHN1/Un2VMQpuv9aGSe179z3DBTR4wFq7xzb9VYMlKU2teQm
	9T45+ce6EqlzFBm2MkWPxBcFOBZ1YmH9XeSvO64tj0TtncyMuXkGFtR0R/7PmXNPhdCBtuqD+eY
	kKLIMKulxmSwGthdQ==
X-Gm-Gg: AYBFou2oxAC1id6S0pgnKzIVIv6gaCx1yA06lV5dHpqXmNcgvzGJaj51nhF/cGUNCNw
	nrXYCdy8RSgOz+5bQVmBT+FkJOVfxv9P9dxtF7uNmGNGKfC+J56y2AdVeRsGEbyY7xBzri/LNrZ
	G7EO9swqt4i7O/tvIqCETxfxVDofmoGPCGqNZk5iTGUAR6g08BX08Jxe53xUK6EpybQgzjNL214
	068GsHgBbpRbncHibNCYqpt8ubpVi+O5eOxvzbxAwu1WP4uS8lhA5vSQRIMllHSf6FSSZj3fCGJ
	5tj/xQL8hTAfJwFF7sfppIt9zu0iJ+7bG1K+21zzaC/VUkG9bSOg4NWYkp1Y/dXJxCOz635HDQ8
	+Q8riRJaZ2L+01n5WM/ie0y9RB6avwzilJIk7uSGIF/rWCZgtzrH0FgZ7pfxrQ5tTotwqh60T5D
	FfZUFNGkBgPTKWT3hSkDtEiyvk9ukyHpRKobuZ
X-Received: by 2002:a17:90b:3b46:b0:398:dcfe:967a with SMTP id 98e67ed59e1d1-39b2620a2ecmr26995583a91.17.1788716760717;
        Sun, 06 Sep 2026 10:46:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39ae8dfd9d4sm1824335a91.3.2026.09.06.10.46.00
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:46:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d52734fc41so50317165ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716759; x=1789321559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2KTEnu/wDi12ltmIR8vM/A4bsy6DjZieTYGS1jyZ2wo=;
        b=fvBTRsx608ql20jEqhT/F8zoRmSrHKXLK6llI/Pim1veRLQKMNt9DkGw7afqWjmFYq
         SUaJLmTeSkWBC4uMho867NFkw709Sf89w8s0HwNRZ2hU7wlcztAO7JsaXCdLUuXHD3/5
         VdpTkImxuqImgOmECn2I6d9kEjX9KbusrgAt0=
X-Received: by 2002:a17:902:da8a:b0:2ce:9c48:22d3 with SMTP id d9443c01a7336-2db127ce3bcmr273331885ad.11.1788716758650;
        Sun, 06 Sep 2026 10:45:58 -0700 (PDT)
X-Received: by 2002:a17:902:da8a:b0:2ce:9c48:22d3 with SMTP id d9443c01a7336-2db127ce3bcmr273331565ad.11.1788716758220;
        Sun, 06 Sep 2026 10:45:58 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:45:57 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 4/8] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Sun,  6 Sep 2026 16:06:56 -0700
Message-Id: <20260906230700.12233-5-selvin.xavier@broadcom.com>
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

bnxt_re_create_srq() validates attr.max_wr but copies attr.max_sge
into srq->qplib_srq.max_sge unvalidated. This lets an unprivileged
user request an arbitrarily large max_sge, defeating the num_sge
check added in bnxt_re_post_srq_recv() and overflowing the fixed
13-entry (BNXT_VAR_MAX_SGE) sg_list[] array in bnxt_re_build_sgl().

Reject max_sge > dev_attr->max_srq_sges at create time, as create_qp
already does for QP send/recv SGEs. Also clamp max_srq_sges itself in
bnxt_qplib_get_dev_attr() to BNXT_STATIC_MAX_SGE (6), the actual max
SGEs an SRQ ring entry supports, since it was taken straight from
firmware with no bound.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ab5d06034c20..b3aa3c9f8941 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2235,6 +2235,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf..9aaa2b5204b8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -160,7 +160,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.39.3

