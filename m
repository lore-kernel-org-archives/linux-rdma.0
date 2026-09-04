Received: from mail-vs1-f98.google.com (mail-vs1-f98.google.com [209.85.217.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97B347668C
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519174; cv=none; b=b+dhltL/EQHkdiWKp/imRrnrSTpwPPKsup6uZAqM2leBYwVkTqiZ2T1TMr4WndQv1uZhp88Zwyi9qd3nRvJZ6mGYWujMiFGrcz408P/tec5QdcMQWeFWlS0U6RuB95vai6Hu9YptWBozYD3rMjeTLaUTnkUkHvZIg9ej4Eu265Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519174; c=relaxed/simple;
	bh=RxhMhJPKVADd5X3+IjgiTXhFmFB/Yhus2DCtr6cfKPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0lbrDhXcZ8+x3LjFGJkOyQiIpB1XShn6GJN22YiTpkixKjStJ5ZUTEx6S1HyZb90RlT6vm8z/tLw23Nj6xSxuL+kKmVilgYDqYA1jAsgmYfjOAuhXYulm7XufQzYml2ryS/VQIY0/ntZwRJ5fFUQAWX0UvEZc6CgXwTJpU8kF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QktqkmzJ; arc=none smtp.client-ip=209.85.217.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QktqkmzJ"
Received: by mail-vs1-f98.google.com with SMTP id ada2fe7eead31-779d18ef706so628581137.2
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519158; x=1789123958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EZ0587Ok2qEEzZmzTErQUMTvjkwPeP1KFphy75fRsIw=;
        b=eM8eWN4OinFHpZ3eMHxwHAXLDSoYRQQWK1N0fPn3pxM81n6ldsoVean6AFSiCD+Y6V
         kka/n/2swRpIvQpeKNzZGp5YAo5/oQ1fBkjMarU4QYNmCf4t9bxReInUgic23Hh/YXVZ
         mj9BKoiIy91SrIq2KociWI5ZfUcqgRFf68rumEug2eL52BZNjdQIl6PxOjMvPl1RmDyD
         iG6OIpW8a36atPj5vMkchVsXJGgqYsjhj84xtJH3hnPT99kNTDQeMsbc2D86D7U7KLf5
         2bk5c9sZ/bb4fa9c8FatT+wAYB7d6ZIAABSMCixTCNea4sO6u1WKLO6SJXR9duJoXQNv
         ZBrg==
X-Forwarded-Encrypted: i=1; AKwUvBzIpw24CSJqlvxqeZY3Vp1UQPxNbogSiarALFifnha5KdXWOAl2AKO51axrBk2npCNVbrlV0jXF6Yhp@vger.kernel.org
X-Gm-Message-State: AFuF++kH16eIbVNx3osBkZEpVRwbNQrA+KDIBsLmnzNiBjw8ys6P+q0W
	/UKS+Ut4imhBI12rg20SBpwsnP/T6i5ljN+E87Czkj77Fyq0kNGaX9BZAQyV6eEHpW/q/4f5txd
	zBsbc3Fwbp7HRZl6paETdc4feLXFZWJETg/H18v5alKl6rXCF9NmpsGvcrdgpjfqkgBe4MSVhF7
	i4PhPR28BmgO2GltCBmCSGuFRNfIS0zgHgNMl2rc04gMnmY/XAubPDclS4L0eOCWi1PW7BOR1cs
	aLz2/PDpCRrdiYuLg==
X-Gm-Gg: AYBFou3cDu6XPS0yCE1w0d+FT3rj4CEYxcVYu/xFffY+edCVH5YgUJx+6yyEVHwj3iS
	3wDgxhBbDwvt0mO+GkTE7suzG3dKIMFE6XgHdqWCA/H+80f0N0JrgULcL+BTa1uA689dWwANTxv
	dt86ByfW9ZT4o65AYN6iccsmGNtNP/6lu0uq7S9+EkSgGZLco3mQKDFjC4HWzCYvJjB7J3bXfDi
	zsH9tFzYDNufNsmN1PfMCf4/RJo144vndQ0IzclLx7PP/7/MqFYv3VK7k5GXGkcXDVuxiSppGpS
	3voL1lTqbozmbmsvNNJrR4jIN9QR9UCKs4RB4HkEdeA3q4dH2y9xpL65R4RJX8rezhJFRkSvgnD
	mz4dCuQ1Z5Ie/tV5N0Fa8AgGCVgP2AZOkZAmqHaXX3Qlxu8GYz/XB5nAisKoL2EU22SLvO3Dnur
	OjEseCaLdYOTYrft1pdwwUTFeaZLy2slPByA==
X-Received: by 2002:a05:6102:5126:b0:785:5a17:739b with SMTP id ada2fe7eead31-78a4a4944femr1816121137.0.1788519158328;
        Fri, 04 Sep 2026 03:52:38 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-9808eb92e1bsm476467241.2.2026.09.04.03.52.37
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:38 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6f73d0f89so12181295ad.0
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519156; x=1789123956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EZ0587Ok2qEEzZmzTErQUMTvjkwPeP1KFphy75fRsIw=;
        b=QktqkmzJBuFp/0Juw1oBWkFAKwxCRTGFzC0LuWvyfNmlve77qJutYxHlCSXalR0W4v
         j/TSoQgi7KmKvEsS/rQlc6XHKETRyFDE17lNINKX7SxLqb4ttj62VWFI+77t1a5uH9Sr
         2KSuof5SWK5bEbh92fGWfR/QcoWDJAxmtCM8I=
X-Forwarded-Encrypted: i=1; AKwUvBxhUAr4Q5sobgSqBSHHi+wortFNdunCSwBUcj7QsdK0cq9BnV9MJT5uprJpT9kbUIiCl0WNLjA0n4SN@vger.kernel.org
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr8717224a91.9.1788519156117;
        Fri, 04 Sep 2026 03:52:36 -0700 (PDT)
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr8717138a91.9.1788519155572;
        Fri, 04 Sep 2026 03:52:35 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:34 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Suresh Rupanagudi <suresh.rupanagudi@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 08/15] RDMA/bng_re: Add PD verbs
Date: Fri,  4 Sep 2026 03:43:16 -0700
Message-ID: <20260904104328.763768-9-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Suresh Rupanagudi <suresh.rupanagudi@broadcom.com>

This patch adds below verbs.
- bng_re_alloc_pd
- bng_re_dealloc_pd

Signed-off-by: Suresh Rupanagudi <suresh.rupanagudi@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c   |  3 ++
 drivers/infiniband/hw/bng_re/bng_res.c   | 38 +++++++++++++++++++++++-
 drivers/infiniband/hw/bng_re/bng_res.h   |  9 ++++++
 drivers/infiniband/hw/bng_re/bng_sp.c    | 36 ++++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h    | 11 +++++++
 drivers/infiniband/hw/bng_re/bng_verbs.c | 34 +++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h |  8 +++++
 7 files changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 9ce8e1bb420a..b8a50c8cd299 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -44,6 +44,9 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.query_gid		= bng_re_query_gid,
 	.add_gid		= bng_re_add_gid,
 	.del_gid		= bng_re_del_gid,
+	.alloc_pd		= bng_re_alloc_pd,
+	.dealloc_pd		= bng_re_dealloc_pd,
+	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, bng_re_ucontext, ib_uctx),
 };
 
diff --git a/drivers/infiniband/hw/bng_re/bng_res.c b/drivers/infiniband/hw/bng_re/bng_res.c
index a169ed2bb16b..8bf6e8efa182 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.c
+++ b/drivers/infiniband/hw/bng_re/bng_res.c
@@ -365,8 +365,38 @@ static int bng_res_alloc_dpi_tbl(struct bng_re_res *res,
 	return 0;
 }
 
+static void bng_res_free_pd_tbl(struct bng_re_pd_tbl *pdt)
+{
+	kfree(pdt->tbl);
+	pdt->tbl = NULL;
+	pdt->max = 0;
+}
+
+static int bng_res_alloc_pd_tbl(struct bng_re_res *res,
+				struct bng_re_dev_attr *dev_attr)
+{
+	struct bng_re_pd_tbl *pdt = &res->pd_tbl;
+	u32 max = dev_attr->max_pd;
+	u32 bytes;
+
+	max++; /* one extra slot, reserved so it's never allocated */
+	bytes = BITS_TO_LONGS(max) * sizeof(unsigned long);
+
+	pdt->tbl = kmalloc(bytes, GFP_KERNEL);
+	if (!pdt->tbl)
+		return -ENOMEM;
+
+	pdt->max = max;
+	memset(pdt->tbl, 0xFF, bytes); /* mark every pd id as available */
+	clear_bit(pdt->max - 1, pdt->tbl); /* reserve the last pd id */
+	mutex_init(&res->pd_tbl_lock);
+
+	return 0;
+}
+
 void bng_res_free_tbls(struct bng_re_res *res)
 {
+	bng_res_free_pd_tbl(&res->pd_tbl);
 	bng_res_free_dpi_tbl(&res->dpi_tbl);
 	bng_sp_free_sgid_tbl(&res->sgid_tbl);
 }
@@ -375,10 +405,14 @@ int bng_res_alloc_init_tbls(struct bng_re_res *res)
 {
 	int rc;
 
-	rc = bng_res_alloc_dpi_tbl(res, res->dattr);
+	rc = bng_res_alloc_pd_tbl(res, res->dattr);
 	if (rc)
 		return rc;
 
+	rc = bng_res_alloc_dpi_tbl(res, res->dattr);
+	if (rc)
+		goto free_pd_tbl;
+
 	rc = bng_sp_alloc_sgid_tbl(&res->sgid_tbl,
 				   res->dattr->max_sgid);
 	if (rc)
@@ -388,6 +422,8 @@ int bng_res_alloc_init_tbls(struct bng_re_res *res)
 
 free_dpi_tbl:
 	bng_res_free_dpi_tbl(&res->dpi_tbl);
+free_pd_tbl:
+	bng_res_free_pd_tbl(&res->pd_tbl);
 
 	return rc;
 }
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 58a6012998c1..72afe51c6bfa 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -196,6 +196,12 @@ struct bng_re_dpi_tbl {
 	void __iomem		*priv_db;
 };
 
+/* PD table */
+struct bng_re_pd_tbl {
+	unsigned long	*tbl;
+	u32		max;
+};
+
 struct bng_re_res {
 	struct pci_dev			*pdev;
 	struct bng_re_chip_ctx		*cctx;
@@ -207,6 +213,9 @@ struct bng_re_res {
 	struct xid_manager		*ah_xids;
 	struct bng_re_sgid_tbl		sgid_tbl;
 	bool				prio;
+	struct bng_re_pd_tbl		pd_tbl;
+	/* Serialize access to PD table */
+	struct mutex			pd_tbl_lock;
 };
 
 #define to_bng_re_res(ptr, member)	container_of(ptr, struct bng_re_res, member)
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index 8401d1a7ff28..97768a25c0e4 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -335,3 +335,39 @@ int bng_sp_del_sgid(struct bng_re_sgid_tbl *sgid_tbl, u32 index, bool update)
 	return 0;
 }
 
+/* PD allocation/de-allocation functions from Gerrit */
+int bng_sp_alloc_pd(struct bng_re_res *res, struct bng_sp_pd *pd)
+{
+	struct bng_re_pd_tbl *pdt = &res->pd_tbl;
+	u32 bit_num;
+
+	mutex_lock(&res->pd_tbl_lock);
+	bit_num = find_first_bit(pdt->tbl, pdt->max);
+	if (bit_num >= pdt->max - 1) {
+		mutex_unlock(&res->pd_tbl_lock);
+		return -ENOMEM;
+	}
+
+	/* Found unused PD - mark it as allocated */
+	clear_bit(bit_num, pdt->tbl);
+	pd->id = bit_num;
+
+	mutex_unlock(&res->pd_tbl_lock);
+	return 0;
+}
+
+int bng_sp_dealloc_pd(struct bng_re_res *res,
+		      struct bng_re_pd_tbl *pdt,
+		      struct bng_sp_pd *pd)
+{
+	mutex_lock(&res->pd_tbl_lock);
+	if (pd->id >= pdt->max - 1 || test_and_set_bit(pd->id, pdt->tbl)) {
+		dev_warn(&res->pdev->dev, "Freeing an unused PD? pdn = %d\n",
+			 pd->id);
+		mutex_unlock(&res->pd_tbl_lock);
+		return -EINVAL;
+	}
+	pd->id = pdt->max - 1;
+	mutex_unlock(&res->pd_tbl_lock);
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index 05c2749419d8..136703942e1f 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -53,6 +53,10 @@ struct bng_re_gid_info {
 	u16 vlan_id;
 };
 
+struct bng_sp_pd {
+	u32	id;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -65,4 +69,11 @@ int bng_sp_add_sgid(struct bng_re_sgid_tbl *sgid_tbl,
 		    bool update, u32 *index, bool is_ugid, u32 stats_ctx_id);
 
 int bng_sp_del_sgid(struct bng_re_sgid_tbl *sgid_tbl, u32 index, bool update);
+
+int bng_sp_alloc_pd(struct bng_re_res *res, struct bng_sp_pd *pd);
+
+int bng_sp_dealloc_pd(struct bng_re_res *res,
+		      struct bng_re_pd_tbl *pdt,
+		      struct bng_sp_pd *pd);
+
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index 59c7d95830f4..140a972a0316 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -526,3 +526,37 @@ int bng_re_del_gid(const struct ib_gid_attr *attr, void **context)
 	return rc;
 }
 
+int bng_re_alloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct ib_device *ibdev = ib_pd->device;
+	struct bng_re_dev *rdev = container_of(ibdev, struct bng_re_dev, ibdev);
+	int rc;
+
+	pd->rdev = rdev;
+
+	rc = bng_sp_alloc_pd(&rdev->bng_res, &pd->sp_pd);
+	if (rc) {
+		ibdev_err(&rdev->ibdev,
+			  "Failed to allocate HW PD\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int bng_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	int rc;
+
+	rc = bng_sp_dealloc_pd(&rdev->bng_res, &rdev->bng_res.pd_tbl,
+			       &pd->sp_pd);
+	if (rc) {
+		ibdev_err(&rdev->ibdev,
+			  "Dealloc PD failed: pdid=%u, rc=%d\n",
+			  pd->sp_pd.id, rc);
+	}
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index eba56cf42672..ea017f70142e 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -31,6 +31,12 @@ struct bng_re_gid_ctx {
 	u32			refcnt;
 };
 
+struct bng_re_pd {
+	struct ib_pd		ib_pd;
+	struct bng_re_dev	*rdev;
+	struct bng_sp_pd	sp_pd;
+};
+
 int bng_re_query_device(struct ib_device *ibdev, struct ib_device_attr *ib_attr,
 			struct ib_udata *udata);
 int bng_re_modify_device(struct ib_device *ibdev, int device_modify_mask,
@@ -56,5 +62,7 @@ int bng_re_query_gid(struct ib_device *ibdev, u32 port_num, int index,
 		     union ib_gid *gid);
 int bng_re_add_gid(const struct ib_gid_attr *attr, void **context);
 int bng_re_del_gid(const struct ib_gid_attr *attr, void **context);
+int bng_re_alloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata);
+int bng_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata);
 #endif /* __BNG_RE_VERBS_H__ */
 
-- 
2.43.5

