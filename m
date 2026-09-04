Received: from mail-ua1-f98.google.com (mail-ua1-f98.google.com [209.85.222.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C64476CD8
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519173; cv=none; b=uvWI/+IT552+0HRitaAabT0Ql59kidfXOgr/7DYmcrQ3yMMgFx7r/rvNAQb/d2/QtwAkdR2zjYhZybAdUhupkPeJBJaBCC7fj0H3BYp2ElX8I+pXUJ4/NUYpilPgDfsWEwjgxSKxUKTmjvxj3UjyJ8cFX7SiJFrtDwcwERXLQ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519173; c=relaxed/simple;
	bh=tTgtgyFIKd3q9DiaMOuxIhyUZuqzafNqO++JxmVf1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9OXIwu4d5fiYU+FQ+Z7v3AisxQ74RrGamxLM359LvQeYOyjcsRzEsrxUg5bZ9lYLY8GbBK+Mm/g30KjbnNClayYBJpj4uFYh7cThNwVdJVGYsiU1LsX+CXcxVzib8lDyM3oke7O59SbWcDWlgA5S0ZTy8+0kQPJH3Q5qbraQ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BByScYKP; arc=none smtp.client-ip=209.85.222.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BByScYKP"
Received: by mail-ua1-f98.google.com with SMTP id a1e0cc1a2514c-9808f46d89eso375494241.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519165; x=1789123965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHKvq6U9+uHkmjRYJnuNGHeZf+WZK0TeIRdc8ogSsSA=;
        b=RqPfI1MD8Xbzqrh3oMET1NG5tvoLafDuQt8GFYATQ4NePGwuFUXHmC0AgsiXRPE7yO
         AqS+mREyQq1+cidCdTflV2bIbofsxvGTD+wN1svbO80dqEVgyKEYHAXZYbTiKtdwhvGK
         WInI8qngXcQGAn7YHiKUKquC9Drfk6mZltTnW5HDYgPNdvfR2e3TTo4GNErTIMhJKeE/
         iTXmKnls++2uP1m5BMmzL1Pttpz8Yi2cbf+fp/iC2zsIyw5s576r8YCdEJLUniJc3L0K
         WBqlhvT1Is6oOv+liSwyHdZzltNGuOHQ+ye8/AnNHDObT29pzH5gbVRi2CR4h+w2Z4QA
         G6TA==
X-Forwarded-Encrypted: i=1; AKwUvBwsg7eX7tjb4aGeGDdYil2qgB4mf7nsccpw/mXgb9500tIIulzfkAqMtmVjPqzDgKc5yRjDiwPm6XEx@vger.kernel.org
X-Gm-Message-State: AFuF++mDwTPGskzBkxHiJBNLxvbTztpd3OkkMyQvLO+9DPT5SekLFdB3
	7CYGoNe+1VwiaNSr3UFjuQfjtpz8na851YlSJta2pjMfLeYgJEIt+eFUGfMHORrLJ4Lp7a8EyUZ
	Eq/8G2J9jbOxonpGFwX2r7MguIt/jHEvaYN3+R6C417ro7FZG0d/DBCl9pwpjyMkuGsHuH6eoZ0
	PlZ17J3+rzGy6OKKWWQZWdCVF68PM9S1G43v1adPrFGu8JRvaKdHOEyjtx4okoHTlbr9j1aQDkU
	yIVlpPfQVtg0mrokg==
X-Gm-Gg: AYBFou3WCktHMnNC6SSma5XU211KVHW2edZsFaGvTcWk4tsN8CqIiWAdkdzc5ftCleL
	pBSifqOOWMb9A2AQZBAaW8d0MI71IkAAPEKZWxfOdy2TipcIZNic/Y39mV1Uuglk1wZuQ28sP1e
	EtPcOafGIXBxryMTdUEPjlL1Cs63YLTIXdmWBGWv3CXagB5+OUrLFE3gFZ4d0auOzTra0nBEEZC
	BXfV/qAynIuSfjGnahndfh+VXzptihxb4cnael3dLalzekHZNM6z0VUA8iNoy96BxyFNV5MRx6C
	90nHF5QtRQMX7PxepcdP1K0d4uEkh/iNeAHF2/gZVEq/kmTWFLAE5vhdHKW2AT2yeuM36Khxk+U
	LFSYGQsLnPBRDS4b57d3RNN2jTnu8gBbBCwrjd942xhIdlJ0RJKPsKufcAmsfWB9/0Wyqu5ssGt
	m49D78oX3c/DxUhV7p1+udA+LGOCmD4d0BkA==
X-Received: by 2002:a05:6102:50aa:b0:77f:9278:af6e with SMTP id ada2fe7eead31-78a4aabb472mr1491247137.9.1788519165505;
        Fri, 04 Sep 2026 03:52:45 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-78a47b72f48sm61764137.17.2026.09.04.03.52.45
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:45 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6fb956002so13016585ad.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519164; x=1789123964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SHKvq6U9+uHkmjRYJnuNGHeZf+WZK0TeIRdc8ogSsSA=;
        b=BByScYKPY2T4f+0e3BU/AGWwnbybutXs3OL1R3LoIBWgpTFyDAzqIIBJJHW6292ru4
         4XvtkI1KmzRCeTa7W0AJyhqxwv+bRoKrxNkA1HO4DXmAlwn3MxjxXQK2wtGqpimWRKU+
         NcJzO36uTgfCujPytDQqdeYGRs6oH3CNGxRKU=
X-Forwarded-Encrypted: i=1; AKwUvBwmOA3ZY/rtiqiiCDsKPMDmjZ9/46uPny37M9ng4aDGVnadMxxo/k+SLIPDDfTw+Uk/nyGMSw5lSrdS@vger.kernel.org
X-Received: by 2002:a17:902:f1d3:b0:2da:f3f6:7cb1 with SMTP id d9443c01a7336-2db12666affmr45712495ad.19.1788519164085;
        Fri, 04 Sep 2026 03:52:44 -0700 (PDT)
X-Received: by 2002:a17:902:f1d3:b0:2da:f3f6:7cb1 with SMTP id d9443c01a7336-2db12666affmr45712155ad.19.1788519163535;
        Fri, 04 Sep 2026 03:52:43 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:42 -0700 (PDT)
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
Subject: [PATCH 11/15] RDMA/bng_re: Add SRQ verbs
Date: Fri,  4 Sep 2026 03:43:19 -0700
Message-ID: <20260904104328.763768-12-siva.kallam@broadcom.com>
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
- bng_re_create_srq
- bng_re_modify_srq
- bng_re_query_srq
- bng_re_destroy_srq

Signed-off-by: Suresh Rupanagudi <suresh.rupanagudi@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c   |   5 +
 drivers/infiniband/hw/bng_re/bng_re.h    |   1 +
 drivers/infiniband/hw/bng_re/bng_res.c   |   1 +
 drivers/infiniband/hw/bng_re/bng_res.h   |   9 +
 drivers/infiniband/hw/bng_re/bng_sp.c    | 144 +++++++++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h    |  28 +++
 drivers/infiniband/hw/bng_re/bng_verbs.c | 216 +++++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h |  25 +++
 include/uapi/rdma/bng_re-abi.h           |  14 ++
 9 files changed, 443 insertions(+)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 9c35c56ae583..a42e24691cad 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -57,6 +57,11 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.resize_user_cq		= bng_re_resize_cq,
 	.req_notify_cq		= bng_re_req_notify_cq,
 	.destroy_cq		= bng_re_destroy_cq,
+	.create_srq		= bng_re_create_srq,
+	.modify_srq		= bng_re_modify_srq,
+	.query_srq		= bng_re_query_srq,
+	.destroy_srq		= bng_re_destroy_srq,
+	INIT_RDMA_OBJ_SIZE(ib_srq, bng_re_srq, ib_srq),
 	INIT_RDMA_OBJ_SIZE(ib_cq, bng_re_cq, ib_cq),
 	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, bng_re_ucontext, ib_uctx),
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index 47b4037e124e..70851f1180d0 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -296,6 +296,7 @@ struct bng_re_dev {
 	struct bng_re_dpi		dpi_privileged;
 	struct bng_sp_cq_coal_param	cq_coalescing;
 	DECLARE_HASHTABLE(cq_hash, MAX_CQ_HASH_BITS);
+	DECLARE_HASHTABLE(srq_hash, 8);  /* SRQ hash table */
 };
 
 #define to_bng_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bng_re/bng_res.c b/drivers/infiniband/hw/bng_re/bng_res.c
index 8bf6e8efa182..024d49f68b09 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.c
+++ b/drivers/infiniband/hw/bng_re/bng_res.c
@@ -265,6 +265,7 @@ int bng_re_alloc_init_hwq(struct bng_re_hwq *hwq,
 	hwq->max_elements = hwq->depth;
 	hwq->element_size = stride;
 	hwq->qe_ppg = pg_size / stride;
+	hwq->is_user = !!hwq_attr->sginfo->umem;
 	/* For direct access to the elements */
 	lvl = hwq->level;
 	if (hwq_attr->sginfo->nopte && hwq->level)
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 0f832f9bae20..00429b4a7d30 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -170,6 +170,7 @@ struct bng_re_hwq {
 	u32				cons;
 	/* queue entry per page */
 	u16				qe_ppg;
+	u8				is_user;
 };
 
 struct bng_re_stats {
@@ -288,6 +289,14 @@ static inline void bng_re_ring_nq_db(struct bng_re_db_info *info,
 	bng_re_ring_db(info, type);
 }
 
+static inline void bng_re_srq_arm_db(struct bng_re_db_info *info, u32 th)
+{
+	u64 key = 0;
+
+	key = BNG_RE_INIT_DBHDR(info->xid, DBC_DBC_TYPE_SRQ_ARM, th, info->toggle);
+	writeq(key, info->priv_db);
+}
+
 static inline void bng_re_hwq_incr_cons(u32 max_elements, u32 *cons, u32 cnt,
 					u32 *dbinfo_flags)
 {
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index 04488db6d016..78e2bb9ad859 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -816,3 +816,147 @@ int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq)
 	return 0;
 }
 
+int bng_sp_create_srq(struct bng_re_res *res, struct bng_sp_srq *srq)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct creq_create_srq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_create_srq req = {};
+	struct bng_re_pbl *pbl;
+	u16 pg_sz_lvl;
+	int rc, idx;
+
+	hwq_attr.res = res;
+	hwq_attr.sginfo = &srq->sginfo;
+	hwq_attr.depth = srq->max_wqe;
+	hwq_attr.stride = srq->wqe_size;
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+	rc = bng_re_alloc_init_hwq(&srq->hwq, &hwq_attr);
+	if (rc)
+		return rc;
+
+	srq->dbinfo.flags = 0;
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_CREATE_SRQ,
+			     sizeof(req));
+
+	/* Configure the request */
+	req.dpi = cpu_to_le32(srq->dpi->dpi);
+	req.srq_handle = cpu_to_le64((uintptr_t)srq);
+
+	req.srq_size = cpu_to_le16((u16)srq->hwq.max_elements);
+	pbl = &srq->hwq.pbl[BNG_PBL_LVL_0];
+	pg_sz_lvl = ((u16)bng_re_base_pg_size(&srq->hwq) <<
+		     CMDQ_CREATE_SRQ_PG_SIZE_SFT);
+	pg_sz_lvl |= (srq->hwq.level & CMDQ_CREATE_SRQ_LVL_MASK) <<
+		      CMDQ_CREATE_SRQ_LVL_SFT;
+	req.pg_size_lvl = cpu_to_le16(pg_sz_lvl);
+	req.pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+	req.pd_id = cpu_to_le32(srq->pd->id);
+	req.eventq_id = cpu_to_le16(srq->eventq_hw_ring_id);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req), sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		goto fail;
+
+	srq->id = le32_to_cpu(resp.xid);
+	srq->start_idx = 0;
+	srq->last_idx = srq->hwq.max_elements - 1;
+
+	/* Allocate shadow queue for kernel SRQs */
+	if (!srq->hwq.is_user) {
+		srq->swq = kcalloc(srq->hwq.max_elements, sizeof(*srq->swq),
+				   GFP_KERNEL);
+		if (!srq->swq) {
+			rc = -ENOMEM;
+			goto fail_swq;
+		}
+		for (idx = 0; idx < srq->hwq.max_elements; idx++)
+			srq->swq[idx].next_idx = idx + 1;
+		srq->swq[srq->last_idx].next_idx = -1;
+	}
+
+	srq->dbinfo.hwq = &srq->hwq;
+	srq->dbinfo.xid = srq->id;
+	srq->dbinfo.db = srq->dpi->dbr;
+	srq->dbinfo.max_slot = 1;
+	srq->dbinfo.priv_db = res->dpi_tbl.priv_db;
+
+	/* Arm the SRQ */
+	bng_re_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
+
+	return 0;
+
+fail_swq:
+	bng_sp_destroy_srq(res, srq);
+	return rc;
+
+fail:
+	bng_re_free_hwq(res, &srq->hwq);
+	kfree(srq->swq);
+	srq->swq = NULL;
+
+	return rc;
+}
+
+int bng_sp_query_srq(struct bng_re_res *res, struct bng_sp_srq *srq)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_query_srq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct bng_re_rcfw_sbuf sbuf;
+	struct creq_query_srq_resp_sb *sb;
+	struct cmdq_query_srq req = {};
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_QUERY_SRQ,
+			     sizeof(req));
+
+	/* Configure the request */
+	sbuf.size = ALIGN(sizeof(*sb), BNG_FW_CMDQE_UNITS);
+	sbuf.sb = dma_alloc_coherent(&rcfw->pdev->dev, sbuf.size,
+				     &sbuf.dma_addr, GFP_KERNEL);
+	if (!sbuf.sb)
+		return -ENOMEM;
+	req.resp_size = sbuf.size / BNG_FW_CMDQE_UNITS;
+	req.srq_cid = cpu_to_le32(srq->id);
+	sb = sbuf.sb;
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, &sbuf, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (!rc)
+		srq->threshold = le16_to_cpu(sb->srq_limit);
+	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
+			  sbuf.sb, sbuf.dma_addr);
+
+	return rc;
+}
+
+int bng_sp_destroy_srq(struct bng_re_res *res, struct bng_sp_srq *srq)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_destroy_srq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_destroy_srq req = {};
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_DESTROY_SRQ,
+			     sizeof(req));
+
+	/* Configure the request */
+	req.srq_cid = cpu_to_le32(srq->id);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req), sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		return rc;
+	bng_re_free_hwq(res, &srq->hwq);
+	kfree(srq->swq);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index d05151123f98..da4dceba4f46 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -166,6 +166,31 @@ struct bng_sp_cq {
 	u16				cnq_events;
 };
 
+/* SRQ shadow work queue entry */
+struct bng_sp_swq {
+	u64		wr_id;
+	int		next_idx;
+};
+
+/* SRQ SP layer structure */
+struct bng_sp_srq {
+	struct bng_sp_pd		*pd;
+	struct bng_re_dpi		*dpi;
+	struct bng_re_hwq		hwq;
+	struct bng_re_db_info		dbinfo;
+	struct bng_re_sg_info		sginfo;
+	struct bng_sp_swq		*swq;
+	u32				start_idx;
+	u32				last_idx;
+	u64				srq_handle;
+	u32				id;
+	u16				wqe_size;
+	u32				max_wqe;
+	u32				max_sge;
+	u32				threshold;
+	u16				eventq_hw_ring_id;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -200,5 +225,8 @@ void bng_sp_resize_cq_complete(struct bng_re_res *res, struct bng_sp_cq *cq);
 int bng_sp_resize_cq(struct bng_re_res *res, struct bng_sp_cq *cq,
 		     int new_cqes);
 int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq);
+int bng_sp_create_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
+int bng_sp_query_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
+int bng_sp_destroy_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
 
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index b08ac20d788d..e48caefa64ee 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -1196,3 +1196,219 @@ int bng_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	kfree(cq->cql);
 	return 0;
 }
+
+/* SRQ helper function */
+static int bng_re_init_user_srq(struct bng_re_dev *rdev,
+				struct bng_re_pd *pd,
+				struct bng_re_srq *srq,
+				struct ib_udata *udata)
+{
+	struct bng_re_ucontext *cntx =
+		rdma_udata_to_drv_context(udata, struct bng_re_ucontext,
+					  ib_uctx);
+	struct bng_sp_srq *sp_srq = &srq->sp_srq;
+	struct bng_re_srq_req ureq;
+	struct ib_umem *umem;
+	int bytes = 0;
+
+	if (ib_copy_from_udata(&ureq, udata, sizeof(ureq)))
+		return -EFAULT;
+
+	bytes = (sp_srq->max_wqe * sp_srq->wqe_size);
+	bytes = PAGE_ALIGN(bytes);
+	umem = ib_umem_get_va(&rdev->ibdev, ureq.srqva, bytes,
+			      IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem))
+		return PTR_ERR(umem);
+
+	srq->umem = umem;
+	sp_srq->sginfo.umem = umem;
+	sp_srq->sginfo.pgsize = PAGE_SIZE;
+	sp_srq->sginfo.pgshft = PAGE_SHIFT;
+	sp_srq->srq_handle = ureq.srq_handle;
+	sp_srq->dpi = &cntx->dpi;
+
+	return 0;
+}
+
+/* SRQ operations */
+int bng_re_create_srq(struct ib_srq *ib_srq,
+		      struct ib_srq_init_attr *srq_init_attr,
+		      struct ib_udata *udata)
+{
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_re_ucontext *uctx;
+	struct bng_re_dev *rdev;
+	struct bng_re_srq *srq;
+	struct bng_re_pd *pd;
+	struct ib_pd *ib_pd;
+	int rc, entries;
+
+	ib_pd = ib_srq->pd;
+	pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	rdev = pd->rdev;
+	dev_attr = rdev->dev_attr;
+	srq = container_of(ib_srq, struct bng_re_srq, ib_srq);
+
+	if (srq_init_attr->attr.max_wr > dev_attr->max_srq_wqes) {
+		ibdev_err(&rdev->ibdev, "Create SRQ failed - max exceeded\n");
+		rc = -EINVAL;
+		goto exit;
+	}
+
+	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
+		rc = -EOPNOTSUPP;
+		goto exit;
+	}
+
+	uctx = rdma_udata_to_drv_context(udata, struct bng_re_ucontext, ib_uctx);
+	srq->rdev = rdev;
+	srq->sp_srq.pd = &pd->sp_pd;
+	srq->sp_srq.dpi = &rdev->dpi_privileged;
+	/* Allocate 1 more than what's provided so posting max doesn't
+	 * mean empty
+	 */
+	entries = bng_re_init_depth(srq_init_attr->attr.max_wr + 1, uctx);
+	if (entries > dev_attr->max_srq_wqes + 1)
+		entries = dev_attr->max_srq_wqes + 1;
+	srq->sp_srq.max_wqe = entries;
+
+	srq->sp_srq.max_sge = srq_init_attr->attr.max_sge;
+	/* 128 byte wqe size for SRQ. So use max sges */
+	srq->sp_srq.wqe_size = bng_re_get_rwqe_size(dev_attr->max_srq_sges);
+	srq->sp_srq.threshold = srq_init_attr->attr.srq_limit;
+	srq->srq_limit = srq_init_attr->attr.srq_limit;
+	srq->sp_srq.eventq_hw_ring_id = rdev->nqr->nq[0].ring_id;
+	srq->sp_srq.sginfo.pgsize = PAGE_SIZE;
+	srq->sp_srq.sginfo.pgshft = PAGE_SHIFT;
+
+	if (udata) {
+		rc = bng_re_init_user_srq(rdev, pd, srq, udata);
+		if (rc)
+			goto fail;
+	}
+
+	rc = bng_sp_create_srq(&rdev->bng_res, &srq->sp_srq);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Create HW SRQ failed!\n");
+		goto fail;
+	}
+
+	if (udata) {
+		struct bng_re_srq_resp resp = {};
+
+		resp.srqid = srq->sp_srq.id;
+		if (rdev->chip_ctx->modes.toggle_bits & BNG_RE_SRQ_TOGGLE_BIT) {
+			srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
+			if (!srq->uctx_srq_page) {
+				rc = -ENOMEM;
+				bng_sp_destroy_srq(&rdev->bng_res, &srq->sp_srq);
+				goto fail;
+			}
+			hash_add(rdev->srq_hash, &srq->hash_entry, srq->sp_srq.id);
+			resp.comp_mask |= BNG_RE_SRQ_TOGGLE_PAGE_SUPPORT;
+		}
+		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (rc) {
+			ibdev_err(&rdev->ibdev, "SRQ copy to udata failed!\n");
+			if (srq->uctx_srq_page) {
+				free_page((unsigned long)srq->uctx_srq_page);
+				hash_del(&srq->hash_entry);
+			}
+			bng_sp_destroy_srq(&rdev->bng_res,
+					   &srq->sp_srq);
+			goto fail;
+		}
+	}
+	spin_lock_init(&srq->lock);
+
+	return 0;
+
+fail:
+	ib_umem_release(srq->umem);
+exit:
+	return rc;
+}
+
+int bng_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
+		      enum ib_srq_attr_mask srq_attr_mask,
+		      struct ib_udata *udata)
+{
+	struct bng_re_srq *srq = container_of(ib_srq, struct bng_re_srq, ib_srq);
+	struct bng_re_dev *rdev = srq->rdev;
+
+	switch (srq_attr_mask) {
+	case IB_SRQ_MAX_WR:
+		/* SRQ resize is not supported */
+		return -EINVAL;
+	case IB_SRQ_LIMIT:
+	{
+		unsigned long flags;
+
+		/* Change the SRQ threshold */
+		if (srq_attr->srq_limit > srq->sp_srq.max_wqe)
+			return -EINVAL;
+
+		spin_lock_irqsave(&srq->lock, flags);
+		srq->sp_srq.threshold = srq_attr->srq_limit;
+		bng_re_srq_arm_db(&srq->sp_srq.dbinfo, srq->sp_srq.threshold);
+
+		/* On success, update the shadow */
+		srq->srq_limit = srq_attr->srq_limit;
+		spin_unlock_irqrestore(&srq->lock, flags);
+		return 0;
+	}
+	default:
+		ibdev_err(&rdev->ibdev,
+			  "Unsupported srq_attr_mask 0x%x\n", srq_attr_mask);
+		return -EINVAL;
+	}
+}
+
+int bng_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
+{
+	struct bng_re_srq *srq = container_of(ib_srq, struct bng_re_srq, ib_srq);
+	struct bng_re_dev *rdev = srq->rdev;
+	struct bng_sp_srq sp_srq = {};
+	int rc;
+
+	/* Get live SRQ attr */
+	sp_srq.id = srq->sp_srq.id;
+	rc = bng_sp_query_srq(&rdev->bng_res, &sp_srq);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Query HW SRQ failed!\n");
+		return rc;
+	}
+
+	srq_attr->max_wr = srq->sp_srq.max_wqe;
+	srq_attr->max_sge = srq->sp_srq.max_sge;
+	srq_attr->srq_limit = sp_srq.threshold;
+
+	return 0;
+}
+
+int bng_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
+{
+	struct bng_re_dev *rdev;
+	struct bng_re_srq *srq;
+	int rc;
+
+	srq = container_of(ib_srq, struct bng_re_srq, ib_srq);
+	rdev = srq->rdev;
+
+	rc = bng_sp_destroy_srq(&rdev->bng_res, &srq->sp_srq);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Destroy SRQ failed: %d\n", rc);
+		return rc;
+	}
+
+	if (srq->uctx_srq_page) {
+		free_page((unsigned long)srq->uctx_srq_page);
+		srq->uctx_srq_page = NULL;
+		hash_del(&srq->hash_entry);
+	}
+
+	ib_umem_release(srq->umem);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index 839967c73f08..dd9fac0f33c0 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -64,6 +64,17 @@ struct bng_re_cq {
 	struct hlist_node		hash_entry;
 };
 
+struct bng_re_srq {
+	struct ib_srq		ib_srq;
+	struct bng_re_dev	*rdev;
+	u32			srq_limit;
+	struct bng_sp_srq	sp_srq;
+	struct ib_umem		*umem;
+	spinlock_t		lock;		/* protect srq */
+	void			*uctx_srq_page;
+	struct hlist_node	hash_entry;
+};
+
 static inline u32 bng_re_init_depth(u32 ent, struct bng_re_ucontext *uctx)
 {
 	/* roundup_pow_of_two(0) is undefined (UBSAN: shift by 64 on 64-bit). */
@@ -71,6 +82,12 @@ static inline u32 bng_re_init_depth(u32 ent, struct bng_re_ucontext *uctx)
 				   ent : roundup_pow_of_two(ent) : ent;
 }
 
+static inline u16 bng_re_get_rwqe_size(int nsge)
+{
+	/* RQ WQE header + SGEs */
+	return 16 + (nsge * 16); /* header=16, each sge=16 bytes */
+}
+
 int bng_re_query_device(struct ib_device *ibdev, struct ib_device_attr *ib_attr,
 			struct ib_udata *udata);
 int bng_re_modify_device(struct ib_device *ibdev, int device_modify_mask,
@@ -122,6 +139,14 @@ int bng_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udat
 int bng_re_req_notify_cq(struct ib_cq *ib_cq,
 			 enum ib_cq_notify_flags ib_cqn_flags);
 int bng_re_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
+int bng_re_create_srq(struct ib_srq *ib_srq,
+		      struct ib_srq_init_attr *srq_init_attr,
+		      struct ib_udata *udata);
+int bng_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
+		      enum ib_srq_attr_mask srq_attr_mask,
+		      struct ib_udata *udata);
+int bng_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr);
+int bng_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata);
 
 #endif /* __BNG_RE_VERBS_H__ */
 
diff --git a/include/uapi/rdma/bng_re-abi.h b/include/uapi/rdma/bng_re-abi.h
index 2a88f36bcacd..49931b7c1344 100644
--- a/include/uapi/rdma/bng_re-abi.h
+++ b/include/uapi/rdma/bng_re-abi.h
@@ -61,4 +61,18 @@ struct bng_re_resize_cq_req {
 	__aligned_u64 cq_va;
 };
 
+struct bng_re_srq_req {
+	__aligned_u64 srqva;
+	__aligned_u64 srq_handle;
+};
+
+enum bng_re_srq_mask {
+	BNG_RE_SRQ_TOGGLE_PAGE_SUPPORT = 0x1,
+};
+
+struct bng_re_srq_resp {
+	__u32 srqid;
+	__aligned_u64 comp_mask;
+};
+
 #endif /* __BNG_RE_UVERBS_ABI_H__*/
-- 
2.43.5

