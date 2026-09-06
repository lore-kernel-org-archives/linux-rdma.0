Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D016E3CA4AB
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716768; cv=none; b=LOJqgQk4ynasV9Xw3nLE4qAHE91k3RxmkR4guKae4CiWxBjgzYPWkwQnBHXHg2t4d490EO6Kcpk7lN82v8OcUBVgqzZf/oODZU9srp+trWPmej6PkHUHSmvCAo30cqVnbjN6mrIpZ4K5RKV7tbyYL1O+XKzFQn9nwVQ37VLDje8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716768; c=relaxed/simple;
	bh=0OnVbxbBR5VT7ytB1nVCkzZlF32151hCNLDHdqjWXX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TY8Ov+x5KIGAbUfzMH0QdtnDmeYh55ggqH/pvS32LTbbD/wqd+YSD109l5UFIEQZ3OyGIos9E6LiLSKV/ksViUNoHIwZ2vMleVDTeQcLFftnSDtFDgFuqdEOoGq5fUKGKmhCG2zc6xtKpw1WDFdOJZyvjMKrTjft+hd1EgsjKWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RwDQWyko; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RwDQWyko"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3966791a6eeso3298708a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716766; x=1789321566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vWwt5BbfO0xTfwcqu5Tba/4OVavavIe3TAsdtieQA9E=;
        b=Lchs2GzUWZjzWkhK/59kfYRaGmulX5qFmmrJ7Gmch1wkyFva06sNku5wBeui0AkI/f
         j3Km5bNmjV6+ba7zFE2h3S/NWejFjqevm4HxdWTFIr32RZm2ONAAtNPUVLHJ1ybNUrMw
         iPWLLzJOADjqqtfdrDu4Frm8jhS+NWPNlxzDHv0azdXyH6rjD9bJaG8t2zV7oXV/yYj2
         +isBqRSQ8p1umlAgPOr2Rb2QXQ0klG9tQGEFyvifNaXSDWSDB7ATmDoq7JQa8ZKu3/rf
         6z+OzjF9JT8f4NAiRZmd4lPOI4bitnAukk2lKahQohGwdVsTtQWuQnuAZ0W589/v7out
         1ACw==
X-Gm-Message-State: AFuF++mC7Y+i+SCKd6XIoedjuvLIH5Yqe4T0i7cgxl0NS/dpvPYOb6zN
	tdiD6mKoxSOi1pihUCTrXHk0LNzLdoB6zMfO9JwXvhMRYvz65JA9ChIrjOwZ9j24wmcncK6MP6P
	BoAw2n8Qi6YY8QPmRhlBm+6cVZFzZYH0tj6cxcG0b5pwADQ20QMM6hqiXvf1wND8nLFiHLnfIz4
	G0fzLQ8Hq03aKqGQW64QafQtA1Go/BCKf1qAN+784ipJqqYO95TvcmwxwjHHq+HTYae9Ay42/RR
	DFiR7BfC15aXC5LzQ==
X-Gm-Gg: AYBFou1nDvnXjKTEIBQ8Yck9wW45Zc5ixCEY+DQpAuBvxuvY66YfuXhdFTJxrj+1vO6
	tGnooqVfsmtM7agBbX7oyPxYZfnt+QEB5Ldf8FL4uhpbx0fmOBO2zx+Bw0MrNna3pitjbSesP8t
	Aq0umiWCbgbw3Ecoiac9cXoARp98jOWintuvgiMr/Y5Fv2iNirexDJxDZnhc3p8rx2qA/CQHFrH
	3jHQLdl8486txUX351LTfoGyau6qaAfBzjcBQYbhPI50jI98+PWJRzfbGljitrupbbJHFPvmFK0
	nmpcJiyG6tqOq93uN195M7eocEVjtpQsI3m7GWDx5WeXJpNXHdbQdVV/ng7JIh8MjISPmQpDpog
	JdE4y1IvW/xiJXbuYgWjQNj971nnxbZn4GyWCdY1p5SE9H14Gsn7qPu+mFbK9VmgZyi/WPKkDnJ
	8y8XJL+gbuF+z73eHgxJYLVSg4KMhWCpTIiMc7
X-Received: by 2002:a17:90a:e7ce:b0:398:bacb:1137 with SMTP id 98e67ed59e1d1-39b2624a1bbmr26652210a91.19.1788716766195;
        Sun, 06 Sep 2026 10:46:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b1600a8fbsm6747955a91.3.2026.09.06.10.46.05
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:46:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c89704da8c7so3447229a12.0
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716765; x=1789321565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vWwt5BbfO0xTfwcqu5Tba/4OVavavIe3TAsdtieQA9E=;
        b=RwDQWykoHOw1/l2gsoTIpwIY2PQzXkVIEMBtJuQDdiqkD3S8v2R5ScjRJDSV1+M+qX
         Ly1NG1Bb76C2kVqQIyM0Jepue1v8wPKUuq7mBaeRnaljIFzYYLwfF1ifO0qH0hEPBUjv
         Lo7PQOOPhPz69Lp37rKApSFSAEQdFfXbucsDk=
X-Received: by 2002:a05:6a21:6f12:b0:398:8870:b58f with SMTP id adf61e73a8af0-3da3a03ef42mr28356314637.14.1788716764709;
        Sun, 06 Sep 2026 10:46:04 -0700 (PDT)
X-Received: by 2002:a05:6a21:6f12:b0:398:8870:b58f with SMTP id adf61e73a8af0-3da3a03ef42mr28356277637.14.1788716764248;
        Sun, 06 Sep 2026 10:46:04 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:46:03 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 6/8] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Sun,  6 Sep 2026 16:06:58 -0700
Message-Id: <20260906230700.12233-7-selvin.xavier@broadcom.com>
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

The PD and DPI bitmaps were sized as max >> 3 (bytes),
but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
test_and_set_bit()) operate on whole unsigned long words,
so whenever max isn't a multiple of BITS_PER_LONG,
the buffer under-allocates and the top word's bitops
read/write past the end of the kmalloc()'d buffer.
Most exposed on the DPI table, since dpit->max comes from the
firmware-reported dev_attr->max_dpi with no alignment guarantee.

Fix the size both allocations with BITS_TO_LONGS(max) * sizeof(unsigned long).

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

