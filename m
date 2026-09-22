Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB89C34A79D
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038323; cv=none; b=ehzjyZA7+TE+1utk3UgR/mAGxas6xtmr6Zw6Rr8Ow6BIZQ8mJBhjP5OHmbLJoyu7D4NFj4A43rVifiVBIlLfZhc5rqP/MTH6HzGr5F1zW/xvJDMmiL99XmEHEQzz9tuVJvznkrTXJOjiduQzd2onGaGs4Nb5m1Yi3Zn3vbal9OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038323; c=relaxed/simple;
	bh=M88SrTQMItEGDdroEPtiFRtT4UjPv/bdzkPhRr1pAWs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dWBfQihOW8PknJCNnW7R9sNldBZYBqm49V3Ar0miHY29/FWX7129dD5x4ZaMdUZhA7jio0sy8Hh4Cfm2EogTML7+wcrcQVMvBWxu8GWQzMIMiatZTdU7Ki8VSv27PGShqFA2eJlA5dclCS+XEowyUDTvD0c8PrJhY0RrPaXLeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=C4olnLsF; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="C4olnLsF"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-93a40a9a01aso40946785a.0
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038320; x=1790643120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gqodx5HDYOCrzHo9RcK/AhC6jhrg2yPxXsgX43ypoJ0=;
        b=cXLMyKoU6y4/SzNyotUK8FJgtbEdKrTSN821C4yONPsuvIlK45dQ2OH5butBVb1SYT
         GosE2Kc8UIK48csKLIg1puzWKWK89/uzjklR/swGdqdsh/VJ99kRUNOEH2EuqxQ3xMub
         +VgM3ILacW7coGEj/10hWHLS9MSQtJX1d4w+bUoIMP4fq0bAjZmGeHE4h46JOnU/fna5
         yONSS40Ys+vcW7s2BVU7Oi0xx7T9DREHA7fNZFoe8IkeuhOshypCdcX5a/E4cpcV193b
         p1vh1/WT89oNhnNJBIztCkRpphthOD4SgQRy8bFZv3rQQtbJHxB51f1vsF9UR0Qe6y6b
         +/GA==
X-Gm-Message-State: AFuF++mf+px5PXev/qKIFQU9tc5fVSWJOFUTvKhzXjUkWBl82TleKpls
	NdhIKdgUw5hZcWLfigzbj9SDgbzm+iZNqVXu3Xii3lhDt7HFSMsWnUkcUFlijWQUMldb1/rGwwz
	aM2kQVOGiKNdwChbxGtxyubpTnZAywBt8M/0mr21QTWzqk71EsbQ6Nmz4seeVHvMGcMTMOnRZj7
	pu+TaUj3zmIjuWtZcAZwKBNLvJQuKuKBde0QQg7EQSl3xTC6puUpCQ6VoH92mJVDNTNZw+aHnKf
	hPHN3GMI3uoWK2ROg==
X-Gm-Gg: AYBFou1MjZPaCxIJ1Kq3q2cwgDYtiTCYlf8NLn77BOmzJQyaDfNKEv7/TOCdOYvB1dk
	CtzgZJiHWXlPhSqpj0Ll9WUXRaHBJeqvePX/K3WXKHY5byUe5tLMTq9zOALr/pRBikyMatVrmQD
	cWdxvn/L9/H/2dQdXzZpz7GrWsZB2y6z16WJFtqFAQM6mL7M7HVql3+I0xr7MBWi83YOIDpRKwJ
	eueIAHdqiZ+/A8+JrwJYP+kFtdEXxHShwBnMT/aIyG1/r6pqG2FINJDfIkxkHMBZaOTRtbA/3oP
	FQwAWDoYnA1JdD/NIwkZE6WK2KEY2J15bCozAPKEdjaV/5XuRNAUekLGWr1PtSkIBa6erSE2S+q
	xJyhghT2ED3eskkZonM4OZ+BjAzL5M/qipFbDkODnUyM631kGQ6ZJJSz07HMXLbrC1tx1DqzLxV
	5d2Wuqm6lmay5Ij0t+qK8h7adBrUbK9+2nkw9j
X-Received: by 2002:a05:620a:44c2:b0:93a:ea:b00e with SMTP id af79cd13be357-93c17f03c18mr213741185a.30.1790038320421;
        Mon, 21 Sep 2026 17:52:00 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93c1d037319sm1003085a.4.2026.09.21.17.51.59
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:52:00 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbedbd182f5so362294a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038319; x=1790643119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gqodx5HDYOCrzHo9RcK/AhC6jhrg2yPxXsgX43ypoJ0=;
        b=C4olnLsFYA3xJ7FVqmbEGMLgZMaLRU2Pi8uqAxzl10JkoZYLXMCJslINjxpvIkuHkz
         zHKTt8L3U44NlVZAiPttmEgOrH0kE6HG49QSUwk5po5F030HVQCunhWvYgEfMP7aX7lo
         1O9NuMsf7gxcJXDto8LnBNAJc56IoHvj2xD+4=
X-Received: by 2002:a17:90b:3b82:b0:37f:e5b1:ec4b with SMTP id 98e67ed59e1d1-3a0669c63b5mr1101280a91.5.1790038318952;
        Mon, 21 Sep 2026 17:51:58 -0700 (PDT)
X-Received: by 2002:a17:90b:3b82:b0:37f:e5b1:ec4b with SMTP id 98e67ed59e1d1-3a0669c63b5mr1101269a91.5.1790038318501;
        Mon, 21 Sep 2026 17:51:58 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:57 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 7/8] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Mon, 21 Sep 2026 23:12:29 -0700
Message-Id: <20260922061230.7909-8-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The PD and DPI bitmaps were sized as max >> 3 (bytes),
but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
test_and_set_bit()) operate on whole unsigned long words,
so whenever max isn't a multiple of BITS_PER_LONG,
the buffer under-allocates and the top word's bitops
read/write past the end of the kmalloc()'d buffer.
Most exposed on the DPI table, since dpit->max comes from the
firmware-reported dev_attr->max_dpi with no alignment guarantee.

Fix the size of both allocations with
BITS_TO_LONGS(max) * sizeof(unsigned long).

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 756f8b5f042a..7ff587ce9126 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -668,9 +669,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
 {
 	u32 bytes;
 
-	bytes = max >> 3;
+	bytes = BITS_TO_LONGS(max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 	pdt->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!pdt->tbl)
 		return -ENOMEM;
@@ -848,9 +849,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res *res,
 	if (!dpit->app_tbl)
 		return -ENOMEM;
 
-	bytes = dpit->max >> 3;
+	bytes = BITS_TO_LONGS(dpit->max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-- 
2.39.3

