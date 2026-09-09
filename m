Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC69847A0D4
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942697; cv=none; b=nInj4HqZVGjU2rLEKUuOhnGkNx/UvWBXKeSqr+pPkr58KnMsRcZIeKi127peAKN3Fh+2T79ISSe8at9a8e63SFJOB48+cYlB3aS/0KQCF8HFXWvpDV9VXJJ6M2mWEQP7aTqJaVwiy3wVUIqXoV9fs9gMti2l/BhWXwi28k8j15A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942697; c=relaxed/simple;
	bh=0OnVbxbBR5VT7ytB1nVCkzZlF32151hCNLDHdqjWXX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MFDiPAv+AoM+5tvcPStA6uRPbRsOhOJJ+Qw9hBpKE42nGwCytyL7imfT+VGa9PnUKZSwEHD+mEcxLrhV5WmTvLvrsDTU3BKW4PYocaM7Snr4CZw4zOamZe4kjtrjxjD2/1OeZHaA2ntwhLcMV1rMdoXwwCDHzJxyL2/6YfkYT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=L1pr7Hzv; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="L1pr7Hzv"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4902427c1so1393813a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942695; x=1789547495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vWwt5BbfO0xTfwcqu5Tba/4OVavavIe3TAsdtieQA9E=;
        b=pgLm/xBIDTf8ZXk8ZDHUWksqhHGdt8Cg7pP/CREWKzyytm0Xi8T/mK0lHefA9jKrtE
         6m+62N1+2/08AhtwKZUxGZ7XRVu65SWNRqZlYS5NbEKlwRloRcW568nWP714NEdDJFvL
         YsYIyciTkChQNUtOsPPzsuFZLibHeDDWQAFcZ7GlcYlcQr0N+0bz8ptzCmpbxqlCz16e
         3QFgTkvGXW6/CHc5McBACs5JNFF4m3glChcAEFHmF3gJQau7dWJAGfCdFy9xBsThAOly
         7wF62DU0eJQlP6lw5V/OiqOFuXlr/8GkLcsn7akxOnjR1OxljRyI9GDSucIBxRftZ2v5
         zPWw==
X-Gm-Message-State: AFuF++mJ8fmuP+1KNqF4wQZbjUb3xAUXp9WEbMyTzzrmu8LHyk7LwKy6
	hFRNs2DdYCRdHEuDwpv00R/yul4fk1sLlbGdRIoq0cTWYdVrQ+B/9pDuyWcGU+biS+UHEGz2otb
	q70ik1BjFK0MOQAGR8AEJexlwfr/IAhfDjIDPXJjuvYyro6jjKtrtamtLpVTi5oXZcnDK5F9PD8
	fU5eDPYSjnpc2+V6iNmWgfwqmKxcDkaHHbJU7fGZ7hQa0/KxtvGUgR1g0vK7NUtMA4bgXMOTV3T
	kx7F/W5JtUStximXQ==
X-Gm-Gg: AYBFou0h+kz6wgbOf4A8IjQopa7K6U52ZWzEDVD3AOmnGuvdO6iRnlqvsk5kwWwJmwa
	R08P9huni17IEFZZ+YwowPF52LunOutLHY0I3m8IAWoP0LD9HGBl+QfvnKwwRi6+m3X60Fy4iqD
	gArK62BkOLs0yzYGaa5seMoQipfdGqJKXzPkktpz2jXE02KEFP2r40ksyJq2MtfvWiblLWIfbJP
	R+RUg8ibzluNYFNi/rz9SbNVD5miejZp1+CMSOwuHqbrtxjBvu/xCiwou9mXRL46sX+WswtDblj
	smypAYXeNGgmoKl2sevZGaqgV0P4kHmXv9Ok+Qi4l+KMAg7NI2Vzl8sgVFfJ6iVugXl90771GvW
	kuBTxKyGt0LRfgRMaotUrCT8KY641+gs+/RkJzmiBmImgEVXqSjYLOiy6V1wXhD6CDoDZJgoTxf
	xS1SZaJTvFHibGETgkyqL9e0mQsAClNNcEhA==
X-Received: by 2002:a05:6a20:1449:b0:3d3:aed2:6f29 with SMTP id adf61e73a8af0-3da2168db67mr39247550637.29.1788942694738;
        Wed, 09 Sep 2026 01:31:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc45541e742sm3425343a12.7.2026.09.09.01.31.34
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb48f41343aso5917560a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942693; x=1789547493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vWwt5BbfO0xTfwcqu5Tba/4OVavavIe3TAsdtieQA9E=;
        b=L1pr7HzvNLkG0lppohAeJas/cxLA6pcrpO4Qx2pFxH2fkYqHKxsFreYpAaWVBEdWca
         Ds2YhI4NXXFbsSETrSs39oe5cK34z6ChtL/+qPiT15VOLDalJQZUMgahzz+QONfAockL
         tqVQutma/pNiAnb0kx+q2UAIeJaPqsQnDoMMc=
X-Received: by 2002:a17:90b:1d44:b0:38f:cab0:9aa9 with SMTP id 98e67ed59e1d1-39b0803b0efmr39122248a91.13.1788942692527;
        Wed, 09 Sep 2026 01:31:32 -0700 (PDT)
X-Received: by 2002:a17:90b:1d44:b0:38f:cab0:9aa9 with SMTP id 98e67ed59e1d1-39b0803b0efmr39122212a91.13.1788942691938;
        Wed, 09 Sep 2026 01:31:31 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:31 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 6/8] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed,  9 Sep 2026 06:52:42 -0700
Message-Id: <20260909135244.122747-6-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
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

