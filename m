Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0046C4BC
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519174; cv=none; b=NDrDijw6T/xFELKi+MZ5AZS/uBAALcEMZkhvJHoKH5DntWd5C5pPfGA8l5RAoBD92Lwu45J3S0ECAntbjkIHcp/mrTXXCP+WLG0o1/JOp6SiDE3FxfbtnfXaF7vRePlTtNHhluywDU9KmBFxR0/D1sb9kqiWa+HvVa7LhYLd1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519174; c=relaxed/simple;
	bh=viRaCPo5YHaiEcl+azpxon3HYStvJzOI9Ej4z1U2YY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFPKvGr+uFCQ8wnoJbIzUL0Qtb4G+/PK4okrdQ33WGZIsiU8PpCRTYJ/MLO9GX2bft0c35EdO4jIN911waFWXcXhSay8DepnGMTNvgG+i1spY7LZpQ3k+RdpLF2lpI5QWorgSYOh6mVAA5Is1VxNeSIvdCpTNartte+dfcZd2Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=DkzxYfaT; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DkzxYfaT"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso1090436a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519161; x=1789123961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ExK6Cc2ds2XilVIq9fO163k/yfk/DjaJUZLyRhH88WQ=;
        b=ZRChYB4nY42G/wZM2dkx/yhpLEebZ3zYUMRV5gYb//GJ0AnLffyePlLqzTQk3Xfn9l
         ghCsEUjEa7KHWtf1Uosx3dSWvEbLEUA2AmDhNniX+jAQLtlW45IOZGki0ZDfDl5cS+qK
         XUazWX7kszqvfbvGU1Fp93BAfcE+byKdCo7TW6pve8nXsICKkEKdDqo8CXJT5tilcgpg
         Lle8hzyB1a6SBAD+Zy94x3I+FdJ6I8gZ8yevVOQWN2iefyrS/qwD7IL0gVyq0/n1vAkz
         z6XeFefutkY/e7M/S485/tylOWr6ZFl/ZmTaflGyh2DTZzwqKg0raWcAITtsqsKusOVL
         0lRg==
X-Forwarded-Encrypted: i=1; AKwUvBykEMqmt3BcQPxz8y9wtlTne2inY/Z6Hv1c5iNaM2YAUwSPYNZDlkzFlagO3s9Lylf6r6wxadgYlkJk@vger.kernel.org
X-Gm-Message-State: AFuF++keH6W6M2DUhqeZEkkjLyCVDKeZLO5UO2O08tPDY1Av/1/jFhJ4
	Sh34gNmXUJ6vwz+P4i7uXaxVt7R6dszMJw7rEmjfcn49wije8mnio81cdFXr+YFexXG2H4jGown
	xCjf92AMtRCHXYi6JMCx9NxNYa1CwXK5BCsL+mFdQ3/MF1YvOLAEyLpyqAxslg6QVOeImAqVtc8
	MhMOPyd6tG2ty+iftElf8aRsccyP4bUK012AGqrLeZRqTQRoT++8FNBWrX1z5Mwq/+2LnmmXrWK
	KKh0fTDKnkd4+s=
X-Gm-Gg: AYBFou0dh2U3fUKgJMkZEXwQxr0G+l7f86QqLeNwRrLk8yEqLAaaqhrVX0Imn/yiIJg
	Id3tpePF6/AORK2+FfIQM+SNYktdB4MRjRxjxBuJVjnqbNAWTYMLM6/HOs2uB0/KEN0SO666cVb
	oA74gx1AMF4wjM5Aum4ZaF9cDjSMg6WkESDG8JxD9pUF0f6XStbgRZRT1LTOpkgI95MSZvNRpIw
	7UPRF3xPqI+UfZ7vjv12jN6CQHJZbx0HmXyeR1sxBqJvzI6x2yROXQZg/ElHNMb9188uYZi80mK
	/uen/chei8JHh1zljaRy6Yv9UJcsdCyxbOcb6rU23lQt9cjAriCn/6IbupxKdDYHLWa4IVq7J7j
	WB0sxtvP+I2Houv1e5RjvKr6Zs49LEPLZnsT67ekxMlVIS7JIe7D3siDtBpWLi5cSyG2W23Tc+k
	M2tw9mS7Y5PfNlPbnKCgDyIamFTh8QBoeSyGzn
X-Received: by 2002:a17:90b:2f87:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-39b260fe42amr8405672a91.5.1788519161397;
        Fri, 04 Sep 2026 03:52:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b16055f3fsm2546706a91.6.2026.09.04.03.52.40
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso1369870a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519159; x=1789123959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ExK6Cc2ds2XilVIq9fO163k/yfk/DjaJUZLyRhH88WQ=;
        b=DkzxYfaTtrEDwgl9qRYcoBNsPOCVwPPlL4cpHPZUQJAGh9WlJI1uSx4yERBeKlk0xO
         xPGAxDWhgcA9+A1nArm73g+PPVgzC+j6sIggywNEGQTeVHUHH07bqUCmeqtgAt8YssFw
         25/HOz9N7SfUYoEbZUrx03/7Y0J7XwS11FqEI=
X-Forwarded-Encrypted: i=1; AKwUvBwR1fHtoF35cS7MHjkIcsLIz3XwuOIomqGYtnaDpZp2ZmxOITdoflnvoOCR/ojbn8xYnjLuMvEQuQMI@vger.kernel.org
X-Received: by 2002:a17:90a:51c6:b0:39b:29ca:3d23 with SMTP id 98e67ed59e1d1-39b29ca41d5mr4043866a91.17.1788519158790;
        Fri, 04 Sep 2026 03:52:38 -0700 (PDT)
X-Received: by 2002:a17:90a:51c6:b0:39b:29ca:3d23 with SMTP id 98e67ed59e1d1-39b29ca41d5mr4043807a91.17.1788519158140;
        Fri, 04 Sep 2026 03:52:38 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:37 -0700 (PDT)
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
Subject: [PATCH 09/15] RDMA/bng_re: Add MR verbs
Date: Fri,  4 Sep 2026 03:43:17 -0700
Message-ID: <20260904104328.763768-10-siva.kallam@broadcom.com>
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
- bng_re_get_dma_mr
- bng_re_alloc_mr
- bng_re_map_mr_sg
- bng_re_reg_user_mr
- bng_re_reg_user_mr_dmabuf
- bng_re_dereg_mr

Signed-off-by: Suresh Rupanagudi <suresh.rupanagudi@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c   |   8 +
 drivers/infiniband/hw/bng_re/bng_res.h   |  15 +-
 drivers/infiniband/hw/bng_re/bng_sp.c    | 210 ++++++++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h    |  52 ++++
 drivers/infiniband/hw/bng_re/bng_verbs.c | 333 +++++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h |  27 ++
 6 files changed, 640 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index b8a50c8cd299..44c278a93778 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -46,6 +46,12 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.del_gid		= bng_re_del_gid,
 	.alloc_pd		= bng_re_alloc_pd,
 	.dealloc_pd		= bng_re_dealloc_pd,
+	.get_dma_mr		= bng_re_get_dma_mr,
+	.alloc_mr		= bng_re_alloc_mr,
+	.map_mr_sg		= bng_re_map_mr_sg,
+	.reg_user_mr		= bng_re_reg_user_mr,
+	.reg_user_mr_dmabuf	= bng_re_reg_user_mr_dmabuf,
+	.dereg_mr		= bng_re_dereg_mr,
 	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, bng_re_ucontext, ib_uctx),
 };
@@ -91,6 +97,7 @@ static void bng_re_destroy_chip_ctx(struct bng_re_dev *rdev)
 	chip_ctx = rdev->chip_ctx;
 	rdev->chip_ctx = NULL;
 	rdev->rcfw.res = NULL;
+	rdev->bng_res.rcfw = NULL;
 	rdev->bng_res.cctx = NULL;
 	rdev->bng_res.pdev = NULL;
 	kfree(chip_ctx);
@@ -117,6 +124,7 @@ static int bng_re_setup_chip_ctx(struct bng_re_dev *rdev)
 	aux_dev = rdev->aux_dev;
 	rdev->bng_res.pdev = aux_dev->pdev;
 	rdev->rcfw.res = &rdev->bng_res;
+	rdev->bng_res.rcfw = &rdev->rcfw;
 	chip_ctx = kzalloc_obj(*chip_ctx);
 	if (!chip_ctx)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 72afe51c6bfa..cb0f302fc06a 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -38,6 +38,8 @@
 
 #define RCFW_DBR_PCI_BAR_REGION		2
 
+#define BNG_RE_FR_PMR		0x80000000
+
 struct bng_re_gid {
 	u8 data[16];
 };
@@ -123,14 +125,16 @@ enum bng_re_pbl_lvl {
 
 enum bng_re_hwq_type {
 	BNG_HWQ_TYPE_CTX,
-	BNG_HWQ_TYPE_QUEUE
+	BNG_HWQ_TYPE_QUEUE,
+	BNG_HWQ_TYPE_MR
 };
 
 struct bng_re_sg_info {
-	u32	npages;
-	u32	pgshft;
-	u32	pgsize;
-	bool	nopte;
+	u32			npages;
+	u32			pgshft;
+	u32			pgsize;
+	bool			nopte;
+	struct ib_umem		*umem;
 };
 
 struct bng_re_hwq_attr {
@@ -216,6 +220,7 @@ struct bng_re_res {
 	struct bng_re_pd_tbl		pd_tbl;
 	/* Serialize access to PD table */
 	struct mutex			pd_tbl_lock;
+	struct bng_re_rcfw		*rcfw;
 };
 
 #define to_bng_re_res(ptr, member)	container_of(ptr, struct bng_re_res, member)
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index 97768a25c0e4..cd33ff32845a 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -371,3 +371,213 @@ int bng_sp_dealloc_pd(struct bng_re_res *res,
 	mutex_unlock(&res->pd_tbl_lock);
 	return 0;
 }
+
+/* MR allocation/de-allocation functions */
+int bng_sp_alloc_mrw(struct bng_re_res *res, struct bng_re_mrw *mrw)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_allocate_mrw_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_allocate_mrw req = {};
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_ALLOCATE_MRW,
+			     sizeof(req));
+
+	req.pd_id = cpu_to_le32(mrw->pd->id);
+	req.mrw_flags = mrw->type;
+
+	if ((mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_PMR &&
+	     mrw->access_flags & BNG_RE_FR_PMR) ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2A ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2B)
+		req.access = CMDQ_ALLOCATE_MRW_ACCESS_CONSUMER_OWNED_KEY;
+	req.mrw_handle = cpu_to_le64(mrw);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		return rc;
+
+	if (mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE1 ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2A ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2B)
+		mrw->rkey = le32_to_cpu(resp.xid);
+	else
+		mrw->lkey = le32_to_cpu(resp.xid);
+
+	return 0;
+}
+
+int bng_sp_alloc_fast_reg_page_list(struct bng_re_res *res,
+				    struct bng_re_frpl *frpl,
+				    int max_pg_ptrs)
+{
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_re_sg_info sginfo = {};
+	struct bng_re_hwq *hwq;
+	int pg_ptrs, pages, rc;
+
+	pg_ptrs = roundup_pow_of_two(max_pg_ptrs);
+	pages = pg_ptrs >> MAX_PBL_LVL_1_PGS_SHIFT;
+	if (!pages)
+		pages++;
+
+	if (pages > MAX_PBL_LVL_1_PGS)
+		return -ENOMEM;
+
+	sginfo.pgsize = PAGE_SIZE;
+	sginfo.nopte = true;
+
+	hwq_attr.res = res;
+	hwq_attr.depth = pg_ptrs;
+	hwq_attr.stride = PAGE_SIZE;
+	hwq_attr.sginfo = &sginfo;
+	hwq_attr.type = BNG_HWQ_TYPE_CTX;
+
+	hwq = &frpl->hwq;
+	rc = bng_re_alloc_init_hwq(hwq, &hwq_attr);
+	if (!rc)
+		frpl->max_pg_ptrs = pg_ptrs;
+
+	return rc;
+}
+
+int bng_sp_free_mrw(struct bng_re_res *res,
+		    struct bng_re_mrw *mrw)
+{
+	struct creq_deallocate_key_resp resp = {};
+	struct cmdq_deallocate_key req = {};
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct bng_re_cmdqmsg msg = {};
+	struct bng_re_hwq *hwq;
+	int rc;
+
+	if (mrw->lkey == BNG_RE_RSVD_LKEY)
+		return 0;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_DEALLOCATE_KEY,
+			     sizeof(req));
+
+	req.mrw_flags = mrw->type;
+
+	if (mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE1 ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2A ||
+	    mrw->type == CMDQ_ALLOCATE_MRW_MRW_FLAGS_MW_TYPE2B)
+		req.key = cpu_to_le32(mrw->rkey);
+	else
+		req.key = cpu_to_le32(mrw->lkey);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		return rc;
+
+	hwq = &mrw->hwq;
+	if (hwq->max_elements)
+		bng_re_free_hwq(res, hwq);
+
+	return 0;
+}
+
+int bng_sp_free_fast_reg_page_list(struct bng_re_res *res,
+				   struct bng_re_frpl *frpl)
+{
+	struct bng_re_hwq *hwq;
+
+	hwq = &frpl->hwq;
+	bng_re_free_hwq(res, hwq);
+	return 0;
+}
+
+int bng_sp_reg_mr(struct bng_re_res *res, struct bng_re_mrw *mr,
+		  struct ib_umem *umem, int num_pbls, u32 buf_pg_size,
+		  bool unified_mr)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_re_sg_info sginfo = {};
+	struct creq_register_mr_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_register_mr req = {};
+	int pages, rc;
+	u32 pg_size;
+	u16 level;
+
+	if (num_pbls) {
+		pages = roundup_pow_of_two(num_pbls);
+		/* Allocate memory for the non-leaf pages to store buf ptrs.
+		 * Non-leaf pages always uses system PAGE_SIZE
+		 */
+		/* Free the hwq if it already exist, must be a rereg */
+		if (mr->hwq.max_elements)
+			bng_re_free_hwq(res, &mr->hwq);
+		hwq_attr.res = res;
+		hwq_attr.depth = pages;
+		hwq_attr.stride = sizeof(dma_addr_t);
+		hwq_attr.type = BNG_HWQ_TYPE_MR;
+		hwq_attr.sginfo = &sginfo;
+		hwq_attr.sginfo->umem = umem;
+		hwq_attr.sginfo->npages = pages;
+		hwq_attr.sginfo->pgsize = buf_pg_size;
+		hwq_attr.sginfo->pgshft = ilog2(buf_pg_size);
+		rc = bng_re_alloc_init_hwq(&mr->hwq, &hwq_attr);
+		if (rc) {
+			dev_err(&res->pdev->dev,
+				"SP: Reg MR memory allocation failed\n");
+			return -ENOMEM;
+		}
+	}
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_REGISTER_MR,
+			     sizeof(req));
+
+	/* Configure the request */
+	if (mr->hwq.level == BNG_PBL_LVL_MAX) {
+		/* No PBL provided, just use system PAGE_SIZE */
+		level = 0;
+		req.pbl = 0;
+		pg_size = PAGE_SIZE;
+	} else {
+		level = mr->hwq.level;
+		req.pbl = cpu_to_le64(mr->hwq.pbl[BNG_PBL_LVL_0].pg_map_arr[0]);
+	}
+	pg_size = buf_pg_size ? buf_pg_size : PAGE_SIZE;
+	req.log2_pg_size_lvl = (level << CMDQ_REGISTER_MR_LVL_SFT) |
+			       ((ilog2(pg_size) <<
+				 CMDQ_REGISTER_MR_LOG2_PG_SIZE_SFT) &
+				CMDQ_REGISTER_MR_LOG2_PG_SIZE_MASK);
+	req.log2_pbl_pg_size = cpu_to_le16(((ilog2(PAGE_SIZE) <<
+				 CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_SFT) &
+				CMDQ_REGISTER_MR_LOG2_PBL_PG_SIZE_MASK));
+	req.access = (mr->access_flags & BNG_RE_MR_ACCESS_MASK);
+	req.va = cpu_to_le64(mr->va);
+	req.key = cpu_to_le32(mr->lkey);
+	if (unified_mr)
+		req.key = cpu_to_le32(mr->pd->id);
+	req.flags = cpu_to_le16(mr->flags);
+	req.mr_size = cpu_to_le64(mr->total_size);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		goto free_hwq;
+
+	if (unified_mr) {
+		mr->lkey = le32_to_cpu(resp.xid);
+		mr->rkey = mr->lkey;
+	}
+
+	return 0;
+
+free_hwq:
+	if (mr->hwq.max_elements)
+		bng_re_free_hwq(res, &mr->hwq);
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index 136703942e1f..6dd3ff911548 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -4,6 +4,8 @@
 #ifndef __BNG_SP_H__
 #define __BNG_SP_H__
 
+#include <rdma/ib_umem.h>
+
 #include "bng_fw.h"
 
 #define BNG_VAR_MAX_WQE		4352
@@ -57,6 +59,45 @@ struct bng_sp_pd {
 	u32	id;
 };
 
+/* Access flags */
+#define BNG_RE_ACCESS_LOCAL_WRITE	BIT(0)
+#define BNG_RE_ACCESS_REMOTE_READ	BIT(1)
+#define BNG_RE_ACCESS_REMOTE_WRITE	BIT(2)
+#define BNG_RE_ACCESS_REMOTE_ATOMIC	BIT(3)
+#define BNG_RE_ACCESS_MW_BIND		BIT(4)
+#define BNG_RE_ACCESS_ZERO_BASED	BIT(5)
+#define BNG_RE_ACCESS_ON_DEMAND		BIT(6)
+
+struct bng_re_mrw {
+	struct bng_sp_pd		*pd;
+	int				type;
+	u32				access_flags;
+#define BNG_RE_MR_ACCESS_MASK		0xFF
+	u32				lkey;
+	u32				rkey;
+#define BNG_RE_RSVD_LKEY		0xFFFFFFFF
+	u64				va;
+	u64				total_size;
+	u32				npages;
+	u16				flags;
+	u64				mr_handle;
+	struct bng_re_hwq		hwq;
+	u16				ctx_size_sb;
+};
+
+struct bng_re_frpl {
+	int				max_pg_ptrs;
+	struct bng_re_hwq		hwq;
+};
+
+struct bng_sp_mrinfo {
+	struct bng_re_mrw		*mrw;
+	struct bng_re_sg_info		sg;
+	u64				*ptes;
+	bool				is_dma;
+	bool				request_relax_order;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -76,4 +117,15 @@ int bng_sp_dealloc_pd(struct bng_re_res *res,
 		      struct bng_re_pd_tbl *pdt,
 		      struct bng_sp_pd *pd);
 
+int bng_sp_alloc_mrw(struct bng_re_res *res, struct bng_re_mrw *mrw);
+int bng_sp_alloc_fast_reg_page_list(struct bng_re_res *res,
+				    struct bng_re_frpl *frpl,
+				    int max_pg_ptrs);
+int bng_sp_free_fast_reg_page_list(struct bng_re_res *res,
+				   struct bng_re_frpl *frpl);
+int bng_sp_free_mrw(struct bng_re_res *res, struct bng_re_mrw *mrw);
+int bng_sp_reg_mr(struct bng_re_res *res, struct bng_re_mrw *mr,
+		  struct ib_umem *umem, int num_pbls, u32 buf_pg_size,
+		  bool unified_mr);
+
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index 140a972a0316..fe227d20513a 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -560,3 +560,336 @@ int bng_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata)
 	}
 	return 0;
 }
+
+/* Helper functions for MR operations */
+static inline bool _is_relaxed_ordering_supported(u16 dev_cap_ext_flags2)
+{
+	return dev_cap_ext_flags2 & CREQ_QUERY_FUNC_RESP_SB_MEMORY_REGION_RO_SUPPORTED;
+}
+
+static void bng_re_check_and_set_relaxed_ordering(struct bng_re_dev *rdev,
+						  struct bng_re_mrw *mr)
+{
+	struct bng_re_dev_attr *dev_attr = rdev->dev_attr;
+
+	if (_is_relaxed_ordering_supported(dev_attr->dev_cap_flags2) &&
+	    pcie_relaxed_ordering_enabled(rdev->aux_dev->pdev))
+		mr->flags |= CMDQ_REGISTER_MR_FLAGS_ENABLE_RO;
+}
+
+static int __from_ib_access_flags(int iflags)
+{
+	int qflags = 0;
+
+	if (iflags & IB_ACCESS_LOCAL_WRITE)
+		qflags |= BNG_RE_ACCESS_LOCAL_WRITE;
+	if (iflags & IB_ACCESS_REMOTE_READ)
+		qflags |= BNG_RE_ACCESS_REMOTE_READ;
+	if (iflags & IB_ACCESS_REMOTE_WRITE)
+		qflags |= BNG_RE_ACCESS_REMOTE_WRITE;
+	if (iflags & IB_ACCESS_REMOTE_ATOMIC)
+		qflags |= BNG_RE_ACCESS_REMOTE_ATOMIC;
+	if (iflags & IB_ACCESS_MW_BIND)
+		qflags |= BNG_RE_ACCESS_MW_BIND;
+	if (iflags & IB_ZERO_BASED)
+		qflags |= BNG_RE_ACCESS_ZERO_BASED;
+	if (iflags & IB_ACCESS_ON_DEMAND)
+		qflags |= BNG_RE_ACCESS_ON_DEMAND;
+
+	return qflags;
+}
+
+static inline bool _is_alloc_mr_unified(struct bng_re_dev_attr *dattr)
+{
+	return dattr->dev_cap_flags &
+	       CREQ_QUERY_FUNC_RESP_SB_MR_REGISTER_ALLOC;
+}
+
+struct ib_mr *bng_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	struct bng_re_mr *mr;
+	struct bng_re_res *sp_res;
+	int rc;
+
+	mr = kzalloc_obj(*mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->rdev = rdev;
+	mr->sp_mr.pd = &pd->sp_pd;
+	mr->sp_mr.access_flags = __from_ib_access_flags(mr_access_flags);
+	mr->sp_mr.type = CMDQ_ALLOCATE_MRW_MRW_FLAGS_PMR;
+
+	if (mr_access_flags & IB_ACCESS_RELAXED_ORDERING)
+		bng_re_check_and_set_relaxed_ordering(rdev, &mr->sp_mr);
+
+	sp_res = &rdev->bng_res;
+	rc = bng_sp_alloc_mrw(sp_res, &mr->sp_mr);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Allocate DMA MR failed: %d\n", rc);
+		goto free_mr;
+	}
+
+	mr->sp_mr.hwq.level = BNG_PBL_LVL_MAX;
+	/* Infinite length for DMA MR */
+	mr->sp_mr.total_size = -1;
+
+	/* Register the MR */
+	rc = bng_sp_reg_mr(sp_res, &mr->sp_mr, NULL, 0, PAGE_SIZE, false);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Register DMA MR failed: %d\n", rc);
+		goto free_mrw;
+	}
+
+	/* Set the keys */
+	mr->ib_mr.lkey = mr->sp_mr.lkey;
+	if (mr_access_flags & (IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_READ |
+			       IB_ACCESS_REMOTE_ATOMIC))
+		mr->ib_mr.rkey = mr->ib_mr.lkey;
+
+	return &mr->ib_mr;
+
+free_mrw:
+	bng_sp_free_mrw(sp_res, &mr->sp_mr);
+free_mr:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
+
+struct ib_mr *bng_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
+			      u32 max_num_sg)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	struct bng_re_res *sp_res;
+	struct bng_re_mr *mr = NULL;
+	int rc;
+
+	if (type != IB_MR_TYPE_MEM_REG) {
+		ibdev_dbg(&rdev->ibdev, "MR type 0x%x not supported\n", type);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (max_num_sg > MAX_PBL_LVL_1_PGS) {
+		ibdev_dbg(&rdev->ibdev, "Max SG %u exceeds limit %d\n",
+			  max_num_sg, MAX_PBL_LVL_1_PGS);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mr = kzalloc_obj(*mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->rdev = rdev;
+	mr->sp_mr.pd = &pd->sp_pd;
+	mr->sp_mr.access_flags = BNG_RE_FR_PMR;
+	mr->sp_mr.type = CMDQ_ALLOCATE_MRW_MRW_FLAGS_PMR;
+
+	sp_res = &rdev->bng_res;
+	rc = bng_sp_alloc_mrw(sp_res, &mr->sp_mr);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Allocate MR failed: %d\n", rc);
+		goto free_mr;
+	}
+
+	mr->ib_mr.lkey = mr->sp_mr.lkey;
+	mr->ib_mr.rkey = mr->ib_mr.lkey;
+
+	rc = bng_sp_alloc_fast_reg_page_list(sp_res,
+					     &mr->sp_frpl, max_num_sg);
+	if (rc) {
+		ibdev_err(&rdev->ibdev,
+			  "Failed to allocate HW FR page list: %d\n", rc);
+		goto free_mrw;
+	}
+
+	mr->pages = kcalloc(mr->sp_frpl.max_pg_ptrs, sizeof(*mr->pages),
+			    GFP_KERNEL);
+	if (!mr->pages) {
+		rc = -ENOMEM;
+		goto free_frpl;
+	}
+
+	return &mr->ib_mr;
+
+free_frpl:
+	bng_sp_free_fast_reg_page_list(sp_res, &mr->sp_frpl);
+free_mrw:
+	bng_sp_free_mrw(sp_res, &mr->sp_mr);
+free_mr:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
+
+static int bng_re_set_page(struct ib_mr *ib_mr, u64 addr)
+{
+	struct bng_re_mr *mr = container_of(ib_mr, struct bng_re_mr, ib_mr);
+
+	if (unlikely(mr->npages == mr->sp_frpl.max_pg_ptrs))
+		return -ENOMEM;
+
+	mr->pages[mr->npages++] = addr;
+	return 0;
+}
+
+int bng_re_map_mr_sg(struct ib_mr *ib_mr, struct scatterlist *sg, int sg_nents,
+		     unsigned int *sg_offset)
+{
+	struct bng_re_mr *mr = container_of(ib_mr, struct bng_re_mr, ib_mr);
+
+	mr->npages = 0;
+	return ib_sg_to_pages(ib_mr, sg, sg_nents, sg_offset, bng_re_set_page);
+}
+
+static struct ib_mr *__bng_re_user_reg_mr(struct ib_pd *ib_pd, u64 length,
+					  u64 virt_addr, int mr_access_flags,
+					  struct ib_umem *umem)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	unsigned long page_size;
+	struct bng_re_mr *mr;
+	int umem_pgs, rc;
+
+	if (length > BNG_RE_MAX_MR_SIZE) {
+		ibdev_err(&rdev->ibdev, "MR Size: %llu > Max supported:%llu\n",
+			  (unsigned long long)length,
+			  (unsigned long long)BNG_RE_MAX_MR_SIZE);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	page_size = ib_umem_find_best_pgsz(umem, BNG_RE_PAGE_SIZE_SUPPORTED, virt_addr);
+	if (!page_size) {
+		ibdev_err(&rdev->ibdev, "umem page size unsupported!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	mr = kzalloc_obj(*mr, GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	mr->rdev = rdev;
+	mr->sp_mr.pd = &pd->sp_pd;
+	mr->sp_mr.access_flags = __from_ib_access_flags(mr_access_flags);
+	mr->sp_mr.type = CMDQ_ALLOCATE_MRW_MRW_FLAGS_MR;
+
+	if (!_is_alloc_mr_unified(rdev->dev_attr)) {
+		rc = bng_sp_alloc_mrw(&rdev->bng_res, &mr->sp_mr);
+		if (rc) {
+			ibdev_err(&rdev->ibdev, "Failed to allocate MR rc = %d\n", rc);
+			rc = -EIO;
+			goto free_mr;
+		}
+		/* The fixed portion of the rkey is the same as the lkey */
+		mr->ib_mr.rkey = mr->sp_mr.rkey;
+	} else {
+		mr->sp_mr.flags = CMDQ_REGISTER_MR_FLAGS_ALLOC_MR;
+	}
+	mr->ib_umem = umem;
+	mr->sp_mr.va = virt_addr;
+	mr->sp_mr.total_size = length;
+
+	if (mr_access_flags & IB_ACCESS_RELAXED_ORDERING)
+		bng_re_check_and_set_relaxed_ordering(rdev, &mr->sp_mr);
+
+	umem_pgs = ib_umem_num_dma_blocks(umem, page_size);
+	rc = bng_sp_reg_mr(&rdev->bng_res, &mr->sp_mr, umem,
+			   umem_pgs, page_size,
+			   _is_alloc_mr_unified(rdev->dev_attr));
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to register user MR - rc = %d\n", rc);
+		rc = -EIO;
+		goto free_mrw;
+	}
+
+	mr->ib_mr.lkey = mr->sp_mr.lkey;
+	mr->ib_mr.rkey = mr->sp_mr.lkey;
+
+	return &mr->ib_mr;
+
+free_mrw:
+	bng_sp_free_mrw(&rdev->bng_res, &mr->sp_mr);
+free_mr:
+	kfree(mr);
+	return ERR_PTR(rc);
+}
+
+struct ib_mr *bng_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
+				 u64 virt_addr, int mr_access_flags,
+				 struct ib_dmah *dmah,
+				 struct ib_udata *udata)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	struct ib_umem *umem;
+	struct ib_mr *ib_mr;
+
+	umem = ib_umem_get_va(&rdev->ibdev, start, length, mr_access_flags);
+	if (IS_ERR(umem))
+		return ERR_CAST(umem);
+
+	ib_mr = __bng_re_user_reg_mr(ib_pd, length, virt_addr, mr_access_flags, umem);
+	if (IS_ERR(ib_mr))
+		ib_umem_release(umem);
+	return ib_mr;
+}
+
+struct ib_mr *bng_re_reg_user_mr_dmabuf(struct ib_pd *ib_pd, u64 start,
+					u64 length, u64 virt_addr, int fd,
+					int mr_access_flags,
+					struct ib_dmah *dmah,
+					struct uverbs_attr_bundle *attrs)
+{
+	struct bng_re_pd *pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	struct bng_re_dev *rdev = pd->rdev;
+	struct ib_umem_dmabuf *umem_dmabuf;
+	struct ib_umem *umem;
+	struct ib_mr *ib_mr;
+
+	ibdev_dbg(&rdev->ibdev, "Register user DMA-BUF MR\n");
+
+	umem_dmabuf = ib_umem_dmabuf_get_pinned(&rdev->ibdev, start, length,
+						fd, mr_access_flags);
+	if (IS_ERR(umem_dmabuf))
+		return ERR_CAST(umem_dmabuf);
+
+	umem = &umem_dmabuf->umem;
+
+	ib_mr = __bng_re_user_reg_mr(ib_pd, length, virt_addr, mr_access_flags, umem);
+	if (IS_ERR(ib_mr)) {
+		ib_umem_release(umem);
+		return ib_mr;
+	}
+
+	return ib_mr;
+}
+
+int bng_re_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
+{
+	struct bng_re_mr *mr = container_of(ib_mr, struct bng_re_mr, ib_mr);
+	struct bng_re_dev *rdev = mr->rdev;
+	struct bng_re_res *sp_res;
+	int rc;
+
+	sp_res = &rdev->bng_res;
+
+	rc = bng_sp_free_mrw(sp_res, &mr->sp_mr);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Dereg MR failed: %d\n", rc);
+		return rc;
+	}
+
+	/* Free page list if it was allocated for fast registration */
+	if (mr->pages) {
+		bng_sp_free_fast_reg_page_list(sp_res, &mr->sp_frpl);
+		kfree(mr->pages);
+	}
+
+	ib_umem_release(mr->ib_umem);
+
+	kfree(mr);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index ea017f70142e..0ef7a7535e87 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -37,6 +37,16 @@ struct bng_re_pd {
 	struct bng_sp_pd	sp_pd;
 };
 
+struct bng_re_mr {
+	struct bng_re_dev	*rdev;
+	struct ib_mr		ib_mr;
+	struct ib_umem		*ib_umem;
+	struct bng_re_mrw	sp_mr;
+	u32			npages;
+	u64			*pages;
+	struct bng_re_frpl	sp_frpl;
+};
+
 int bng_re_query_device(struct ib_device *ibdev, struct ib_device_attr *ib_attr,
 			struct ib_udata *udata);
 int bng_re_modify_device(struct ib_device *ibdev, int device_modify_mask,
@@ -64,5 +74,22 @@ int bng_re_add_gid(const struct ib_gid_attr *attr, void **context);
 int bng_re_del_gid(const struct ib_gid_attr *attr, void **context);
 int bng_re_alloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata);
 int bng_re_dealloc_pd(struct ib_pd *ib_pd, struct ib_udata *udata);
+
+struct ib_mr *bng_re_alloc_mr(struct ib_pd *ib_pd, enum ib_mr_type type,
+			      u32 max_num_sg);
+int bng_re_map_mr_sg(struct ib_mr *ib_mr, struct scatterlist *sg, int sg_nents,
+		     unsigned int *sg_offset);
+int bng_re_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata);
+struct ib_mr *bng_re_get_dma_mr(struct ib_pd *ib_pd, int mr_access_flags);
+struct ib_mr *bng_re_reg_user_mr(struct ib_pd *ib_pd, u64 start, u64 length,
+				 u64 virt_addr, int mr_access_flags,
+				 struct ib_dmah *dmah,
+				 struct ib_udata *udata);
+struct ib_mr *bng_re_reg_user_mr_dmabuf(struct ib_pd *ib_pd, u64 start,
+					u64 length, u64 virt_addr,
+					int fd, int mr_access_flags,
+					struct ib_dmah *dmah,
+					struct uverbs_attr_bundle *attrs);
+
 #endif /* __BNG_RE_VERBS_H__ */
 
-- 
2.43.5

