Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168024;
	b=JKWDGTlJuscynewKWnrZM+Fmc2TpfF2s/5o4RbZDohbVLOZxcIPvpGO1SznL7fd5pjuf
	 LEniYZJJ3luaKoQdOjAuL4fqLgLKQ9S8vZhC0ignqls4r9/kcbmQEVskmRN1CrF9EDQNK
	 2vPmhPrYAHFkSKJ0sQo3MX+13Y64NNtxLl7pJpl9DX4dxX7TrJYTUFlvC9uAXDLZWK3dr
	 vFOmKdesUzcDk5WsLW3VBvinY6DDriIxJa+VMIix8ZxkyZ5Xz+5ztXc0l8CMWagJRbUg5
	 0/GbKECfhPhKAxg2bx2vKFSGGb3mLHmYnP/AX5kGLWlsdBw6gh1tSE0VN2r7PMt35CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168024;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=ACOiuT0W50l+mXuxbZjcwQiHl6F0leLm55e7A/s9UXs=;
	b=c+gZ9rWM+2qJFZcHzm7QboaOLMhtVvu5qnKiiQmCDmQChMv4D8TE+BM0y+UXAJU6YYHW
	 QJWDAIoW7D4NdgzERVGtwU5vV7wu5QUSUxWsrEn4MhEM/aRtQah/9jNfuEnbZYN0xpjhi
	 r5Fx0+0KGjIl9z7Oo65DCzHsRTv2Q1l39faZyQh9IX2zXtXgDsb5fNVfkPW83q7L59JON
	 HbOrCYXAcInvnYBNTMbGiCl1gMXda/P9jC3clHzKCoHA8jZAyWMkHXwj46vU/BRe+5slH
	 bn1qpQUcnYx3xLRbTbgr5mDHplZxzhk/LXmqidvDlkAJG+l9cMh7lNoBWNqcsw9i4Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Z4Uke8As;
	arc=none smtp.remote-ip=209.85.160.225
Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67701606A31D
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67701606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Z4Uke8As
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-5365d26ccbdso9463501cf.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168023; x=1793772823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ACOiuT0W50l+mXuxbZjcwQiHl6F0leLm55e7A/s9UXs=;
        b=YtewQN/0whYdkGbdDuCQkDYw909XnbOi6UsAZWGRBuI3f9hEn0+S6sWGcsZfZCfEtj
         NJJbPlRRGdAIrJ6UhFs36ttdv0Y2bDNiHhlUXngjmrp+zK8RG2/z3AGC0HATYAPcPcAu
         u3SwcCrWPO2NfKcOXGPo5tmZabFcu9WCwx4qER3LSqAKZuJ9iykUCSAzgIp3SK+x0C77
         e8zjZ8YZGXMHEd4dLVc8jfHMzeW3AjCxuCxfMs7UeXyy/582SXn0MFueVTM7Q8xfFLWI
         wMMXyuwNXZZMDG77l6jos3VJeebG0KuQCDCe9Khy0l5+QellwwwhC8TO1tINA9FRsCb4
         dfqw==
X-Gm-Message-State: AFq9FYKwcOP0OaqzrJNTvR7lLgSc1517dZ+0mtIyyndR5NDVqeWRF6Cm
	sI0OGdvfEqsF0JfP2qoTON4rbGD7DDI1yEpRnlNOMKwPsVIT8xjHsK+eM2eJ4S1ycFVn8ppj58w
	U2/AlB3kITUycQvcE7OS21UnWsvVksVJkfcLpZob7MP+qcslX3NFVGjB7jNgnsUIre3d/pbCn83
	oFVkAscPU3RPlKT8pH+urzcc9KtDp6vCnAzKxe2cuIxGuYYMzgjgkd8PRq84kUcFPOANqtxWGQa
	NTPKFXagUogsc5a0A==
X-Gm-Gg: AYBFou1V8Kaw7TYAhJXm428erWAd6ckEzB+4hHYJWnLYvk2HAVQJ8p6ErKWVADxPm1b
	2P5zQ5khlPNx98BMsJCjMZZmcni5lXel0sQ5xcjfSCz1p23jTXSQRb8zdH8ianc9RTf12UM2aBM
	e1/24aUgToem+F9kAkja8+43xcdWeQEQFTsIIGT45QGPvKrCJWNJWKxNqEYtBAbCfy+tS5Ga0Jy
	IOFJKVgNnTo48/RvtOZ817/CTLa/VMmlQUxpomaI+038iROBYm3oWfu196zz7aWYrvnh8jo9Nwg
	v/92tJ4p0yhHg8Fd3/4hi61GAreaqemkBVrRxBdPlRgid8PTxiAMxgi6SjMwgXO2AQPGfKKYpg9
	8X7Dp5VtduQbpqm/9aVU3KRuDV7PfV++vkwtJl7ZAwgyK8AowHKycGqR/aM+MXd0kEMD1fSXimK
	hKh5xaGytqWXTOPBgrqlOLQKmXHI36qJBirOtc
X-Received: by 2002:a05:622a:1b06:b0:537:a19c:6e5f with SMTP id d75a77b69052e-53fcc4cc76cmr24404131cf.28.1793168023339;
        Tue, 27 Oct 2026 23:13:43 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-538382fc9d2sm976341cf.44.2026.10.27.23.13.42
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:43 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a59717b0c0so612331b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168022; x=1793772822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ACOiuT0W50l+mXuxbZjcwQiHl6F0leLm55e7A/s9UXs=;
        b=Z4Uke8Asn3NAD4PTg3KtRtCNrKXE9kBeXhBXbjq0U6aoMRuYG5Yqa3gH5s7uQ3lJYu
         32B6bVwtlBFlm4In7D8xsIghlFHLmn2RYSUsDFsgG/jGufIIFiswJdPLeRXG8ch2XsC/
         MjAAEkF3p1iJtRkAa7frns5XLI082OEhxnN40=
X-Received: by 2002:a05:6a00:2442:b0:882:2b16:c314 with SMTP id d2e1a72fcca58-8a6e9353ff2mr1101081b3a.52.1793168021823;
        Tue, 27 Oct 2026 23:13:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:2442:b0:882:2b16:c314 with SMTP id d2e1a72fcca58-8a6e9353ff2mr1101067b3a.52.1793168021415;
        Tue, 27 Oct 2026 23:13:41 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:40 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 7/7] RDMA/bnxt_re: Bound FRMR page list by max_num_sg
Date: Wed, 28 Oct 2026 04:34:04 -0700
Message-Id: <20261028113404.33289-8-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_set_page() checks against frpl->max_pg_ptrs, which is rounded up
to a power of two, while mr->pages[] is allocated with max_num_sg
entries. For a non-power-of-two max_num_sg, ib_sg_to_pages() can write
past the end of mr->pages[].

Track the allocated size in mr->max_pages and bound against it. Also
reject max_num_sg of 0.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 1ca481806578..811f59f02f75 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4555,7 +4555,7 @@ static int bnxt_re_set_page(struct ib_mr *ib_mr, u64 addr)
 {
 	struct bnxt_re_mr *mr = container_of(ib_mr, struct bnxt_re_mr, ib_mr);
 
-	if (unlikely(mr->npages == mr->qplib_frpl.max_pg_ptrs))
+	if (unlikely(mr->npages == mr->max_pages))
 		return -ENOMEM;
 
 	mr->pages[mr->npages++] = addr;
@@ -4584,7 +4584,7 @@ struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
 		ibdev_dbg(&rdev->ibdev, "MR type 0x%x not supported", type);
 		return ERR_PTR(-EINVAL);
 	}
-	if (max_num_sg > MAX_PBL_LVL_1_PGS)
+	if (!max_num_sg || max_num_sg > MAX_PBL_LVL_1_PGS)
 		return ERR_PTR(-EINVAL);
 
 	mr = kzalloc_obj(*mr);
@@ -4603,6 +4603,7 @@ struct ib_mr *bnxt_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
 	mr->ib_mr.lkey = mr->qplib_mr.lkey;
 	mr->ib_mr.rkey = mr->ib_mr.lkey;
 
+	mr->max_pages = max_num_sg;
 	mr->pages = kzalloc_objs(u64, max_num_sg);
 	if (!mr->pages) {
 		rc = -ENOMEM;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index b7b33f6acf91..d12cadaef10c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -124,6 +124,7 @@ struct bnxt_re_mr {
 	struct ib_umem		*ib_umem;
 	struct bnxt_qplib_mrw	qplib_mr;
 	u32			npages;
+	u32			max_pages;
 	u64			*pages;
 	struct bnxt_qplib_frpl	qplib_frpl;
 };
-- 
2.39.3

