Received: from mail-pf1-f230.google.com (mail-pf1-f230.google.com [209.85.210.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA22046C4BC
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519198; cv=none; b=Kyhb6EONNjTWsLyS0SbeG1M77EZvxUPFjLGmksmiK9DqCnO8VYKGYJZ1MaZledwb4pVeAlp0A6/UWAGx5U3YugFrLVZKn3IO0AyTw5YQXxxSBy0wwQkNGtlol6tEk5VU5CNUq18MQCQgcNMxlBL2FqN7I+eluy2bb3QMJnzvq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519198; c=relaxed/simple;
	bh=ybBjmGulK2f056Lo6gH3CL/k5l3YkSxJhFFhiSgOgdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwHTF3AC4oBYb2X2ERi+gnN0aLlsc6yf5KuS8rH3PKHcgmDSeB1DwsrC3Ere8RqizwjpI25kgCcWXRhvJZjG8FK4CS9PmBe9YlGyuuCPAQPjG61d6livFAHSIR9i8qmvh12QtpYqu7DnfjxNQt4YoT9O9FiGiVBmaKLmPkdty3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MpTfSxR2; arc=none smtp.client-ip=209.85.210.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MpTfSxR2"
Received: by mail-pf1-f230.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso772859b3a.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519176; x=1789123976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uqYyKzSmmyJjxbqNiOnqA0CKb5MwkXDtu8qUE6Hez3o=;
        b=p4Bh9p4z8dRw9esHhIY4sqZFByY3lfyE91GoosdG3WYee1NLW9C/k+Q6Ol9E+pJzus
         HEZ3FbBUZUH7ug4XyLH/Jcm7jXhAMZanXUEVqx/fCiwydBdQf/fQHDQZuAb+btYrKiat
         TKtmYLfhKKa9yABaWXqx13MAcXJk23Y+++UZnld4xzKeXT+HIlgPKMLTsKRxNxwt7dQK
         EiKDD+3TpmXgOsvJouWAISV065a0vfa40s3X+taLZ6SZ6LRkmSzaC2Wysn8Q7QXVbg30
         slcrKk/d3p2vKMwD8rWpF0T7Jhefk/vm0P+Wd9ak2lBpXP+jkklVXTc3GnVgC51hj/pg
         onZw==
X-Forwarded-Encrypted: i=1; AKwUvBz5Fgzyefgd45wCw24TyJ/l17PLUEYBzO6HbDZ+mNCAHXf3dIpVtX/9T7oq1TyMITCADPs0Gx9hVmBL@vger.kernel.org
X-Gm-Message-State: AFuF++kfyJtxBj9kN6SA9P/RMV1jbtit1TufONEHWKYZf8Wwjgtb+fgs
	YklVDM0vpWZ6TNGreeeExJfFiy+kZQQ9l4FgMoUUgwrtgJYAnJdBzGiOAS6ecYjOpuJ5k9Jcp/9
	AAiCqQj9bdxJHMil2Wcj6LcM7tE/86Vj+ZKo2ateOceO1QMARTA3uXlKqf4wUaREiGYlJOR68mE
	iHV2BgmEwPzlbeupXEZtZmnSNzPl5bkV5atJ85rgtI0JfZTsIBdcycQuNrrXXdo3wL0Fj+27csq
	DZNQ2j81BPjLEPW+2Z3
X-Gm-Gg: AYBFou0hSEusqoXI3vbKnGvTYB4zwnc6kPHJbQxxsySCliv/KY3yeUObVZA7i7uNh5/
	30kMzM+t163ADXQi65Xh7xd2OKd0yh3VXO53k+O+49xl9hZiC7un41InZLOOyecbh/FJuRPU6Ck
	3qDYg4i/tUwOo59RsG/owOnjOh2KqDbUbEsMNkuCfQDMv2imQXioaIccyT4zRTkJiCTyRSgI6dh
	4OEJQwOGtAuw1veKN3djqvxRgRBYFMkZk96d3CMYwSAiyR7LEvAwHV8i6V+xN4kQdwkCg5fZ9z6
	8d4GIXrAkX57LLjWbhRlxOna4RxUkQVYbROWmlLsQrAFH198Ggmk89rGC64PP7KA/DJBrf4ZNlQ
	cEieTw4yjEMiZDEPHUGC87r+FPg91uIA1Fst2QD80c7WUXBHNIi/SqPsub+zxFRqPW9n8eXCLgj
	FtrHWzAYAtJkjP7+HKp/WCW+JpBz/3p72bIg==
X-Received: by 2002:a05:6a00:991:b0:848:4c3a:a359 with SMTP id d2e1a72fcca58-85ffeadd0famr10102693b3a.19.1788519176139;
        Fri, 04 Sep 2026 03:52:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8614b297b3asm765732b3a.0.2026.09.04.03.52.55
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-385d2703b64so2282821a91.1
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519174; x=1789123974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uqYyKzSmmyJjxbqNiOnqA0CKb5MwkXDtu8qUE6Hez3o=;
        b=MpTfSxR2a8yMqh7u0hObfxZJhyNOaAZtw7W/3m2mGll48F6gUlvC8tsi5PqAG+bLuy
         v0eYiR+ofVPREHEtSWNQbzwngvLoFYMLC7Tds6+psLuL5tiTag55WD6UHKwFcCovV7WO
         y5gvk2DtqQOrcXseo6SxJFx1pmOjn9GTdc650=
X-Forwarded-Encrypted: i=1; AKwUvByXuTyXOCW64rDwImU7Mw5eu1XJ39OrlHyFn2YjA1/3R0nlhUCpJP65tIgNNHlMLS5KEJTgcNIU6etZ@vger.kernel.org
X-Received: by 2002:a17:90b:5604:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39b07fead40mr13446792a91.9.1788519173041;
        Fri, 04 Sep 2026 03:52:53 -0700 (PDT)
X-Received: by 2002:a17:90b:5604:b0:398:c6e1:dceb with SMTP id 98e67ed59e1d1-39b07fead40mr13446702a91.9.1788519171847;
        Fri, 04 Sep 2026 03:52:51 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:50 -0700 (PDT)
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
	"Usman S. Ansari" <usman.ansari@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 14/15] RDMA/bng_re: Add QP verbs
Date: Fri,  4 Sep 2026 03:43:22 -0700
Message-ID: <20260904104328.763768-15-siva.kallam@broadcom.com>
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

From: "Usman S. Ansari" <usman.ansari@broadcom.com>

This patch adds below verbs.
-bng_re_query_qp
-bng_re_create_qp
-bng_re_modify_qp
-bng_re_destroy_qp

Signed-off-by: Usman S. Ansari <usman.ansari@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c        |    5 +
 drivers/infiniband/hw/bng_re/bng_fw.c         |    5 -
 drivers/infiniband/hw/bng_re/bng_fw.h         |    7 +
 drivers/infiniband/hw/bng_re/bng_re.h         |   43 +
 .../infiniband/hw/bng_re/bng_re_mpc_roce.c    |    2 -
 drivers/infiniband/hw/bng_re/bng_res.c        |   45 +-
 drivers/infiniband/hw/bng_re/bng_res.h        |   75 +
 drivers/infiniband/hw/bng_re/bng_roce_hsi.h   |  158 ++
 drivers/infiniband/hw/bng_re/bng_sp.c         |  870 +++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h         |  172 +-
 drivers/infiniband/hw/bng_re/bng_verbs.c      | 1582 +++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h      |  198 +++
 include/uapi/rdma/bng_re-abi.h                |   35 +
 13 files changed, 3188 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 3ebdd777eca3..6e9df737c751 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -62,12 +62,17 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.modify_srq		= bng_re_modify_srq,
 	.query_srq		= bng_re_query_srq,
 	.destroy_srq		= bng_re_destroy_srq,
+	.query_qp		= bng_re_query_qp,
+	.create_qp		= bng_re_create_qp,
+	.modify_qp		= bng_re_modify_qp,
+	.destroy_qp		= bng_re_destroy_qp,
 	.alloc_hw_port_stats	= bng_re_alloc_hw_port_stats,
 	.get_hw_stats		= bng_re_ib_get_hw_stats,
 	.create_ah		= bng_re_create_ah,
 	.create_user_ah		= bng_re_create_ah,
 	.destroy_ah		= bng_re_destroy_ah,
 	.query_ah		= bng_re_query_ah,
+	INIT_RDMA_OBJ_SIZE(ib_qp, bng_re_qp, ib_qp),
 	INIT_RDMA_OBJ_SIZE(ib_ah, bng_re_ah, ib_ah),
 	INIT_RDMA_OBJ_SIZE(ib_srq, bng_re_srq, ib_srq),
 	INIT_RDMA_OBJ_SIZE(ib_cq, bng_re_cq, ib_cq),
diff --git a/drivers/infiniband/hw/bng_re/bng_fw.c b/drivers/infiniband/hw/bng_re/bng_fw.c
index a69221368ba8..a6b43866666c 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.c
+++ b/drivers/infiniband/hw/bng_re/bng_fw.c
@@ -732,11 +732,6 @@ static inline bool _is_hw_retx_supported(u16 dev_cap_flags)
 }
 
 #define BNG_RE_HW_RETX(a) _is_hw_retx_supported((a))
-static inline bool _is_optimize_modify_qp_supported(u16 dev_cap_ext_flags2)
-{
-	return dev_cap_ext_flags2 &
-	       CREQ_QUERY_FUNC_RESP_SB_OPTIMIZE_MODIFY_QP_SUPPORTED;
-}
 
 int bng_re_init_rcfw(struct bng_re_rcfw *rcfw,
 		     struct bng_re_stats *stats_ctx)
diff --git a/drivers/infiniband/hw/bng_re/bng_fw.h b/drivers/infiniband/hw/bng_re/bng_fw.h
index 011dc18592d0..c2d9fc94c674 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.h
+++ b/drivers/infiniband/hw/bng_re/bng_fw.h
@@ -125,6 +125,11 @@ struct bng_re_rcfw_sbuf {
 	u32 size;
 };
 
+struct bng_re_qp_node {
+	u32 qp_id;
+	void *qp_handle;
+};
+
 /* RoCE FW Communication Channels */
 struct bng_re_rcfw {
 	struct pci_dev		*pdev;
@@ -140,6 +145,8 @@ struct bng_re_rcfw {
 	atomic_t		rcfw_intr_enabled;
 	u64			oos_prev;
 	u32			init_oos_stats;
+	int			qp_tbl_size;
+	struct bng_re_qp_node	*qp_tbl;
 };
 
 struct bng_re_cmdqmsg {
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index 217383a2b252..ef81e09f262b 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -244,6 +244,7 @@ struct bng_re_nq {
 	u32				load;
 
 	struct workqueue_struct		*cqn_wq;
+	int (*cqn_handler)(struct bng_re_nq *nq, void *handle);
 };
 
 struct bng_re_nq_record {
@@ -268,6 +269,37 @@ struct bng_re_ring_attr {
 	u8		mode;
 };
 
+struct bng_re_gsi_context {
+	struct	bng_re_qp *gsi_qp;
+	u8	gsi_qp_mode;
+};
+
+struct bng_re_dscp2pri {
+	u8 dscp;
+	u8 mask;
+	u8 pri;
+};
+
+struct bng_re_tc_rec {
+	u8 cos_id_roce;
+	u8 tc_roce;
+	u8 cos_id_cnp;
+	u8 tc_cnp;
+	u8 tc_def;
+	u8 cos_id_def;
+	u8 max_tc;
+	u8 roce_prio;
+	u8 cnp_prio;
+	u8 roce_dscp;
+	u8 cnp_dscp;
+	u8 prio_valid;
+	u8 dscp_valid;
+	bool ecn_enabled;
+	bool serv_type_enabled;
+	u64 cnp_dscp_bv;
+	u64 roce_dscp_bv;
+};
+
 struct bng_re_dev {
 	struct ib_device		ibdev;
 	unsigned long			flags;
@@ -303,6 +335,17 @@ struct bng_re_dev {
 	struct bng_re_ctx		ctx;
 	struct workqueue_struct		*dest_ah_wq;
 	refcount_t			pos_destah_cnt;
+	struct bng_re_gsi_context	gsi_ctx;
+	struct mutex				qp_lock;	/* protect qp list */
+	struct list_head			qp_list;
+	u8					d2p_count;
+	struct bng_re_dscp2pri			*d2p;
+	u8					p2cos[IEEE_8021QAZ_MAX_TCS];
+	u8					lossless_q_count;
+	u8					*lossless_qid;
+	union ib_gid				ugid;
+	u32					min_tx_depth;
+	struct bng_re_tc_rec			tc_rec[2];
 };
 
 #define to_bng_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
index 3ecf5f34180a..91cfdcdc2ff4 100644
--- a/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
+++ b/drivers/infiniband/hw/bng_re/bng_re_mpc_roce.c
@@ -63,8 +63,6 @@ void bng_re_mpc_handle_event_cmpl(struct bng_re_dev *rdev,
 		dev_warn(rdev_to_dev(rdev),
 			 "unexpected event mpc cmpl: xid=%d event=%d data=%d\n",
 			 xid, event, event_data);
-	/* process even if event / event_data isn't as expected, as we don't use them rn */
-	/* bng_re_qp_xid_pending_process_unsolicited_cmpl(rdev, xid); */
 }
 
 /**
diff --git a/drivers/infiniband/hw/bng_re/bng_res.c b/drivers/infiniband/hw/bng_re/bng_res.c
index 024d49f68b09..b40c13cbc3a1 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.c
+++ b/drivers/infiniband/hw/bng_re/bng_res.c
@@ -10,6 +10,11 @@
 #include "bng_roce_hsi.h"
 #include "bng_sp.h"
 
+bool bng_re_init_fw_state_rtr_enabled(struct bng_re_chip_ctx *chip_ctx)
+{
+	return chip_ctx->modes.init_fw_state_rtr;
+}
+
 /* Stats */
 void bng_re_free_stats_ctx_mem(struct pci_dev *pdev,
 			       struct bng_re_stats *stats)
@@ -395,8 +400,40 @@ static int bng_res_alloc_pd_tbl(struct bng_re_res *res,
 	return 0;
 }
 
+static int bng_res_alloc_reftbl(struct bng_re_reftbl *tbl, u32 max)
+{
+	tbl->max = max;
+	tbl->rec = vzalloc(sizeof(*tbl->rec) * max);
+	if (!tbl->rec)
+		return -ENOMEM;
+	spin_lock_init(&tbl->lock);
+	return 0;
+}
+
+static void bng_res_free_reftbls(struct bng_re_res *res)
+{
+	struct bng_re_reftbl *tbl;
+
+	tbl = &res->reftbl.qpref;
+	vfree(tbl->rec);
+}
+
+static int bng_res_alloc_reftbls(struct bng_re_res *res, struct bng_re_dev_attr *dattr)
+{
+	struct bng_re_reftbl *tbl;
+	int rc;
+
+	tbl = &res->reftbl.qpref;
+	rc = bng_res_alloc_reftbl(tbl, BNG_RE_MAX_QPC_COUNT);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 void bng_res_free_tbls(struct bng_re_res *res)
 {
+	bng_res_free_reftbls(res);
 	bng_res_free_pd_tbl(&res->pd_tbl);
 	bng_res_free_dpi_tbl(&res->dpi_tbl);
 	bng_sp_free_sgid_tbl(&res->sgid_tbl);
@@ -406,10 +443,14 @@ int bng_res_alloc_init_tbls(struct bng_re_res *res)
 {
 	int rc;
 
-	rc = bng_res_alloc_pd_tbl(res, res->dattr);
+	rc = bng_res_alloc_reftbls(res, res->dattr);
 	if (rc)
 		return rc;
 
+	rc = bng_res_alloc_pd_tbl(res, res->dattr);
+	if (rc)
+		goto free_reftbl;
+
 	rc = bng_res_alloc_dpi_tbl(res, res->dattr);
 	if (rc)
 		goto free_pd_tbl;
@@ -425,6 +466,8 @@ int bng_res_alloc_init_tbls(struct bng_re_res *res)
 	bng_res_free_dpi_tbl(&res->dpi_tbl);
 free_pd_tbl:
 	bng_res_free_pd_tbl(&res->pd_tbl);
+free_reftbl:
+	bng_res_free_reftbls(res);
 
 	return rc;
 }
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 5a6db1786886..d5a6db80de59 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -4,6 +4,7 @@
 #ifndef __BNG_RES_H__
 #define __BNG_RES_H__
 
+#include <linux/bnge/hsi.h>
 #include "bng_roce_hsi.h"
 #include "xid_allocator.h"
 #include <linux/bnge/hsi.h>
@@ -39,6 +40,7 @@
 #define RCFW_DBR_PCI_BAR_REGION		2
 
 #define BNG_RE_FR_PMR		0x80000000
+#define BNG_RE_MAX_QPC_COUNT	(64 * 1024)
 
 enum bng_re_toggle_modes {
 	BNG_RE_CQ_TOGGLE_BIT = 0x1,
@@ -102,6 +104,9 @@ struct bng_re_drv_modes {
 	u8				roce_mirror;
 	u8				dbr_primary_pf;
 	bool				st_tag_supported;
+	u8                              driver_alloc_xid_supported;
+	u8                              init_fw_state_rtr;
+	u8                              te_bypass;
 };
 
 struct bng_re_chip_ctx {
@@ -212,9 +217,30 @@ struct bng_re_pd_tbl {
 	u32		max;
 };
 
+/* Reference record structure with MPC support */
+struct bng_re_refrec {
+	void *handle;
+	u32 xid;
+	u8 initial_mpc_sent; /* indicates xid has been sent at least 1x to fw */
+};
+
+/* Reference table structure */
+struct bng_re_reftbl {
+	struct bng_re_refrec *rec;
+	u32 max;
+	spinlock_t lock; /* reftbl lock */
+};
+
+/* Collection of reference tables */
+struct bng_re_reftbls {
+	struct bng_re_reftbl qpref;
+};
+
 struct bng_re_res {
 	struct pci_dev			*pdev;
 	struct bng_re_chip_ctx		*cctx;
+	struct net_device		*netdev;
+	struct bng_re_dev		*rdev;
 	struct bng_re_dev_attr		*dattr;
 	struct bng_re_dpi_tbl		dpi_tbl;
 	/* Serialize access to DPI table */
@@ -222,6 +248,7 @@ struct bng_re_res {
 	struct xid_manager		*qp_xids;
 	struct xid_manager		*ah_xids;
 	struct bng_re_sgid_tbl		sgid_tbl;
+	struct bng_re_reftbls		reftbl;
 	bool				prio;
 	struct bng_re_pd_tbl		pd_tbl;
 	/* Serialize access to PD table */
@@ -238,6 +265,28 @@ struct bng_re_ctx {
 	struct bng_re_stats		stats;
 };
 
+struct bng_re_q {
+	struct bng_re_hwq		hwq;
+	struct bng_re_swq		*swq;
+	struct bng_re_db_info		dbinfo;
+	struct bng_re_sg_info		sg_info;
+	u32				max_wqe;
+	u32				max_sw_wqe;
+	u16				wqe_size;
+	u16				q_full_delta;
+	u16				max_sge;
+	u32				psn;
+	bool				condition;
+	bool				single;
+	bool				send_phantom;
+	u32				phantom_wqe_cnt;
+	u32				phantom_cqe_cnt;
+	u32				next_cq_cons;
+	bool				flushed;
+	u32				swq_start;
+	u32				swq_last;
+};
+
 #define to_bng_re_res(ptr, member)	container_of(ptr, struct bng_re_res, member)
 
 static inline void *bng_re_get_qe(struct bng_re_hwq *hwq,
@@ -414,6 +463,31 @@ static inline int bng_ext_stats_supported(struct bng_re_chip_ctx *ctx,
 	return (_is_ext_stats_supported(flags) && ((virtfn) || (!virtfn)));
 }
 
+static inline bool _is_optimize_modify_qp_supported(u16 dev_cap_ext_flags2)
+{
+	return dev_cap_ext_flags2 &
+	       CREQ_QUERY_FUNC_RESP_SB_OPTIMIZE_MODIFY_QP_SUPPORTED;
+}
+
+static inline bool _is_min_rnr_in_rtr_rts_mandatory(u16 dev_cap_ext_flags2)
+{
+	return !!(dev_cap_ext_flags2 &
+		  CREQ_QUERY_FUNC_RESP_SB_MIN_RNR_RTR_RTS_OPT_SUPPORTED);
+}
+
+#define GET_REFTBL_INDEX(id, tbl) ((id) % (((tbl)->max) - 1))
+static inline u32 map_qp_id_to_reftbl_indx(u32 qid, struct bng_re_reftbl *tbl)
+{
+	return (qid == 1) ? tbl->max : GET_REFTBL_INDEX(qid, tbl);
+}
+
+static inline bool _is_change_udp_src_port_wqe_supported(u16 flags)
+{
+	return !!(flags &
+			CREQ_QUERY_FUNC_RESP_SB_CHANGE_UDP_SRC_PORT_WQE_SUPPORTED);
+}
+
+#define BNG_RE_UDP_SP_WQE(a) _is_change_udp_src_port_wqe_supported((a))
 
 void bng_re_free_hwq(struct bng_re_res *res,
 		     struct bng_re_hwq *hwq);
@@ -440,4 +514,5 @@ int bng_re_dealloc_dpi(struct bng_re_res *res,
 void bng_re_alloc_kernel_dpi(struct bng_re_res *res,
 			     struct bng_re_dpi *dpi);
 void bng_re_dealloc_kernel_dpi(struct bng_re_dpi *dpi);
+bool bng_re_init_fw_state_rtr_enabled(struct bng_re_chip_ctx *chip_ctx);
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
index 3001b9d4d056..efef9de95361 100644
--- a/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
+++ b/drivers/infiniband/hw/bng_re/bng_roce_hsi.h
@@ -6606,4 +6606,162 @@ struct mpc_ah_modify_cmpl {
 	__le32	reserved_3;
 };
 
+/* mpc_qp_modify_cmd (size:1792b/224B) */
+struct mpc_qp_modify_cmd {
+	u8	req_type;
+	u8	req_subtype;
+	__le16	cookie;
+	__le16	target_id;
+	u8	resp_size;
+	u8	reserved;
+	__le64	resp_addr;
+	__le32	qp_cid;
+	u8	qp_modify_flags;
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_MASK \
+		0xffUL
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_SFT \
+		0
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_QP_FIRST_MODIFY \
+		0x1UL
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_QP_FREE \
+		0x2UL
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_XID_FIRST_USE \
+		0x4UL
+	#define MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_LAST \
+		MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_XID_FIRST_USE
+	u8	qp_type;
+	__le16	schq_id;
+	__le32	qp_flags;
+	u8	sq_pg_size_sq_lvl;
+	u8	rq_pg_size_rq_lvl;
+	__le16	sq_fwo_sq_sge;
+	__le16	rq_fwo_rq_sge;
+	__le16	sq_max_num_wqes;
+	__le16	flags;
+	u8	type;
+	u8	unused_2;
+	__le32	modify_mask;
+	u8	network_type_en_sqd_async_notify_new_state;
+	u8	access;
+	__le16	pkey;
+	__le32	qkey;
+	__le32	flow_label;
+	__le32	dgid[4];
+	__le16	sgid_index;
+	u8	hop_limit;
+	u8	traffic_class;
+	u8	tos_dscp_tos_ecn;
+	u8	path_mtu_pingpong_push_enable;
+	u8	timeout;
+	u8	retry_cnt;
+	u8	rnr_retry;
+	u8	min_rnr_timer;
+	u8	max_dest_rd_atomic;
+	u8	max_rd_atomic;
+	__le32	rq_psn;
+	__le32	sq_psn;
+	__le32	sq_size;
+	__le32	rq_size;
+	__le16	sq_sge;
+	__le16	rq_sge;
+	__le32	max_inline_data;
+	__le32	dest_qp_id;
+	__le32	pingpong_push_dpi;
+	u8	unused_3[4];
+	__le16	enable_cc;
+	__le16	dest_mac[3];
+	__le16	src_mac[3];
+	__le16	vlan_pcp_vlan_dei_vlan_id;
+	__le32	ext_modify_mask;
+	__le32	ext_stats_ctx_id;
+	__le64	qp_handle;
+	__le32	dpi;
+	__le32	scq_cid;
+	__le32	rcq_cid;
+	__le32	srq_cid;
+	__le32	pd_id;
+	__le32	request_xid;
+	__le64	sq_pbl;
+	__le64	rq_pbl;
+	__le32	msn_iqp;
+	__le32	irrq_iqp;
+	__le32	orrq_iqp;
+	__le32	msn_size;
+	__le32	irrq_size;
+	__le32	orrq_size;
+	__le16	steering_tag;
+	__le16	eroce;
+	__le16	rq_prod_idx;
+	u8	reserved_1[2];
+};
+
+struct qp_modify_data {
+	__le32	qp_cid;
+	u8	qp_modify_flags;
+	u8	qp_type;
+	__le16	schq_id;
+	__le32	qp_flags;
+	u8	sq_pg_size_sq_lvl;
+	u8	rq_pg_size_rq_lvl;
+	__le16	sq_fwo_sq_sge;
+	__le16	rq_fwo_rq_sge;
+	__le16	sq_max_num_wqes;
+	__le16	flags;
+	u8	type;
+	u8	unused_2;
+	__le32	modify_mask;
+	u8	network_type_en_sqd_async_notify_new_state;
+	u8	access;
+	__le16	pkey;
+	__le32	qkey;
+	__le32	flow_label;
+	__le32	dgid[4];
+	__le16	sgid_index;
+	u8	hop_limit;
+	u8	traffic_class;
+	u8	tos_dscp_tos_ecn;
+	u8	path_mtu_pingpong_push_enable;
+	u8	timeout;
+	u8	retry_cnt;
+	u8	rnr_retry;
+	u8	min_rnr_timer;
+	u8	max_dest_rd_atomic;
+	u8	max_rd_atomic;
+	__le32	rq_psn;
+	__le32	sq_psn;
+	__le32	sq_size;
+	__le32	rq_size;
+	__le16	sq_sge;
+	__le16	rq_sge;
+	__le32	max_inline_data;
+	__le32	dest_qp_id;
+	__le32	pingpong_push_dpi;
+	u8	unused_3[4];
+	__le16	enable_cc;
+	__le16	dest_mac[3];
+	__le16	src_mac[3];
+	__le16	vlan_pcp_vlan_dei_vlan_id;
+	__le32	ext_modify_mask;
+	__le32	ext_stats_ctx_id;
+	__le64	qp_handle;
+	__le32	dpi;
+	__le32	scq_cid;
+	__le32	rcq_cid;
+	__le32	srq_cid;
+	__le32	pd_id;
+	__le32	request_xid;
+	__le64	sq_pbl;
+	__le64	rq_pbl;
+	__le32	msn_iqp;
+	__le32	irrq_iqp;
+	__le32	orrq_iqp;
+	__le32	msn_size;
+	__le32	irrq_size;
+	__le32	orrq_size;
+	__le16	steering_tag;
+	__le16	eroce;
+	__le16	rq_prod_idx;
+	u8	reserved_1[2];
+};
+
 #endif /* _BNG_RE_HSI_H_ */
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index b44af599e675..7e93a1be9bad 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -10,6 +10,11 @@
 #include "bng_re.h"
 #include "bng_re_mpc_roce.h"
 #include "bng_fp.h"
+#include "bng_verbs.h"
+
+#define CQE_CMP_VALID(hdr, pass)                        \
+	(!!((hdr)->cqe_type_toggle & CQ_BASE_TOGGLE) ==   \
+	   !((pass) & BNG_RE_FLAG_EPOCH_CONS_MASK))
 
 const struct bng_re_gid bng_re_gid_zero = {{0,}};
 
@@ -1224,3 +1229,868 @@ int bng_sp_fill_and_send_mpc_ah_modify(struct bng_re_res *res,
 
 	return rc;
 }
+
+void bng_re_flush_cqn_wq(struct bng_sp_qp *qp)
+{
+	/*
+	 * Partial create (e.g. attr without send_cq/recv_cq) or teardown ordering
+	 * can leave scq/rcq or NQ workqueues unset; flush must not dereference them.
+	 */
+	if (qp->scq && qp->scq->nq && qp->scq->nq->cqn_wq)
+		flush_workqueue(qp->scq->nq->cqn_wq);
+	if (qp->rcq && qp->scq != qp->rcq && qp->rcq->nq && qp->rcq->nq->cqn_wq)
+		flush_workqueue(qp->rcq->nq->cqn_wq);
+}
+
+static void bng_re_free_qp_hdr_buf(struct bng_re_res *res,
+				   struct bng_sp_qp *qp)
+{
+	struct bng_re_q *rq = &qp->rq;
+	struct bng_re_q *sq = &qp->sq;
+
+	if (qp->rq_hdr_buf)
+		dma_free_coherent(&res->pdev->dev,
+				  rq->max_wqe * qp->rq_hdr_buf_size,
+				  qp->rq_hdr_buf, qp->rq_hdr_buf_map);
+	if (qp->sq_hdr_buf)
+		dma_free_coherent(&res->pdev->dev,
+				  sq->max_wqe * qp->sq_hdr_buf_size,
+				  qp->sq_hdr_buf, qp->sq_hdr_buf_map);
+	qp->rq_hdr_buf = NULL;
+	qp->sq_hdr_buf = NULL;
+	qp->rq_hdr_buf_map = 0;
+	qp->sq_hdr_buf_map = 0;
+	qp->sq_hdr_buf_size = 0;
+	qp->rq_hdr_buf_size = 0;
+}
+
+void bng_re_free_qp_res(struct bng_re_res *res,
+			struct bng_sp_qp *qp)
+{
+	bng_re_free_qp_hdr_buf(res, qp);
+	bng_re_free_hwq(res, &qp->sq.hwq);
+	kvfree(qp->sq.swq);
+
+	bng_re_free_hwq(res, &qp->rq.hwq);
+	kvfree(qp->rq.swq);
+
+	if (qp->irrq.max_elements)
+		bng_re_free_hwq(res, &qp->irrq);
+	if (qp->orrq.max_elements)
+		bng_re_free_hwq(res, &qp->orrq);
+}
+
+static void bng_re_acquire_cq_flush_locks(struct bng_sp_qp *qp,
+					  unsigned long *flags)
+	__acquires(&qp->scq->flush_lock) __acquires(&qp->rcq->flush_lock)
+{
+	spin_lock_irqsave(&qp->scq->flush_lock, *flags);
+	if (qp->scq == qp->rcq)
+		__acquire(&qp->rcq->flush_lock);
+	else
+		spin_lock(&qp->rcq->flush_lock);
+}
+
+static void bng_re_cancel_phantom_processing(struct bng_sp_qp *qp)
+{
+	qp->sq.condition = false;
+	qp->sq.send_phantom = false;
+	qp->sq.single = false;
+}
+
+static void __bng_re_add_flush_qp(struct bng_sp_qp *qp)
+{
+	struct bng_sp_cq *scq, *rcq;
+
+	scq = qp->scq;
+	rcq = qp->rcq;
+
+	if (!qp->sq.flushed) {
+		dev_dbg(&scq->hwq.pdev->dev,
+			"SP: Adding to SQ Flush list = %p\n", qp);
+		bng_re_cancel_phantom_processing(qp);
+		list_add_tail(&qp->sq_flush, &scq->sqf_head);
+		qp->sq.flushed = true;
+	}
+	if (!qp->srq) {
+		if (!qp->rq.flushed) {
+			dev_dbg(&rcq->hwq.pdev->dev,
+				"SP: Adding to RQ Flush list = %p\n", qp);
+			list_add_tail(&qp->rq_flush, &rcq->rqf_head);
+			qp->rq.flushed = true;
+		}
+	}
+}
+
+static void bng_re_release_cq_flush_locks(struct bng_sp_qp *qp,
+					  unsigned long *flags)
+	__releases(&qp->scq->flush_lock) __releases(&qp->rcq->flush_lock)
+{
+	if (qp->scq == qp->rcq)
+		__release(&qp->rcq->flush_lock);
+	else
+		spin_unlock(&qp->rcq->flush_lock);
+	spin_unlock_irqrestore(&qp->scq->flush_lock, *flags);
+}
+
+void bng_re_add_flush_qp(struct bng_sp_qp *qp)
+{
+	unsigned long flags;
+
+	bng_re_acquire_cq_flush_locks(qp, &flags);
+	__bng_re_add_flush_qp(qp);
+	bng_re_release_cq_flush_locks(qp, &flags);
+}
+
+static void __bng_re_del_flush_qp(struct bng_sp_qp *qp)
+{
+	if (qp->sq.flushed) {
+		qp->sq.flushed = false;
+		list_del(&qp->sq_flush);
+	}
+	if (!qp->srq) {
+		if (qp->rq.flushed) {
+			qp->rq.flushed = false;
+			list_del(&qp->rq_flush);
+		}
+	}
+}
+
+static void __clean_cq(struct bng_sp_cq *cq, u64 qp)
+{
+	struct bng_re_hwq *cq_hwq = &cq->hwq;
+	u32 peek_flags, peek_cons;
+	struct cq_base *hw_cqe;
+	int i;
+
+	peek_flags = cq->dbinfo.flags;
+	peek_cons = cq_hwq->cons;
+	for (i = 0; i < cq_hwq->max_elements; i++) {
+		hw_cqe = bng_re_get_qe(cq_hwq, peek_cons, NULL);
+		if (!CQE_CMP_VALID(hw_cqe, peek_flags))
+			continue;
+		/*
+		 * The valid test of the entry must be done first before
+		 * reading any further.
+		 */
+		dma_rmb();
+		switch (hw_cqe->cqe_type_toggle & CQ_BASE_CQE_TYPE_MASK) {
+		case CQ_BASE_CQE_TYPE_REQ:
+		case CQ_BASE_CQE_TYPE_TERMINAL:
+		{
+			struct cq_req *cqe = (struct cq_req *)hw_cqe;
+
+			if (qp == le64_to_cpu(cqe->qp_handle))
+				cqe->qp_handle = 0;
+			break;
+		}
+		case CQ_BASE_CQE_TYPE_RES_RC:
+		case CQ_BASE_CQE_TYPE_RES_UD:
+		case CQ_BASE_CQE_TYPE_RES_RAWETH_QP1:
+		{
+			struct cq_res_rc *cqe = (struct cq_res_rc *)hw_cqe;
+
+			if (qp == le64_to_cpu(cqe->qp_handle))
+				cqe->qp_handle = 0;
+			break;
+		}
+		default:
+			break;
+		}
+		bng_re_hwq_incr_cons(cq_hwq->max_elements, &peek_cons,
+				     1, &peek_flags);
+	}
+}
+
+void bng_re_clean_qp(struct bng_sp_qp *qp)
+{
+	unsigned long flags;
+
+	bng_re_acquire_cq_flush_locks(qp, &flags);
+	__clean_cq(qp->scq, (u64)(unsigned long)qp);
+	qp->sq.hwq.prod = 0;
+	qp->sq.hwq.cons = 0;
+	__clean_cq(qp->rcq, (u64)(unsigned long)qp);
+	qp->rq.hwq.prod = 0;
+	qp->rq.hwq.cons = 0;
+
+	__bng_re_del_flush_qp(qp);
+	bng_re_release_cq_flush_locks(qp, &flags);
+}
+
+int bng_re_alloc_init_swq(struct bng_re_q *que)
+{
+	int indx;
+
+	que->swq = kvcalloc(que->max_sw_wqe, sizeof(*que->swq), GFP_KERNEL);
+	if (!que->swq)
+		return -ENOMEM;
+
+	que->swq_start = 0;
+	que->swq_last = que->max_sw_wqe - 1;
+	for (indx = 0; indx < que->max_sw_wqe; indx++)
+		que->swq[indx].next_idx = indx + 1;
+	que->swq[que->swq_last].next_idx = 0;
+	que->swq_last = 0;
+
+	return 0;
+}
+
+static bool bng_sp_get_initial_created_flag(struct bng_re_res *res,
+					    struct bng_sp_qp *qp)
+{
+	struct bng_re_reftbl *tbl;
+	unsigned long flag;
+	bool val = false;
+	u32 qp_idx;
+
+	tbl = &res->reftbl.qpref;
+	qp_idx = map_qp_id_to_reftbl_indx(qp->id, tbl);
+	spin_lock_irqsave(&tbl->lock, flag);
+	/* Make sure we have the right table index */
+	if (tbl->rec[qp_idx].xid == qp->id &&
+	    tbl->rec[qp_idx].handle == qp)
+		val = tbl->rec[qp_idx].initial_mpc_sent;
+	spin_unlock_irqrestore(&tbl->lock, flag);
+	return val;
+}
+
+static bool is_optimized_state_transition(struct bng_sp_qp *qp)
+{
+	if ((qp->cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_INIT &&
+	    qp->state == CMDQ_MODIFY_QP_NEW_STATE_RTR) ||
+	    (qp->cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_RTR &&
+	    qp->state == CMDQ_MODIFY_QP_NEW_STATE_RTS))
+		return true;
+
+	return false;
+}
+
+static void bng_set_mandatory_attributes(struct bng_re_res *res,
+					 struct bng_sp_qp *qp,
+					 struct cmdq_modify_qp *req)
+{
+	u32 mandatory_flags = 0;
+
+	if (qp->type == CMDQ_MODIFY_QP_QP_TYPE_RC)
+		mandatory_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_ACCESS;
+
+	if (qp->cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_INIT &&
+	    qp->state == CMDQ_MODIFY_QP_NEW_STATE_RTR) {
+		if (qp->type == CMDQ_MODIFY_QP_QP_TYPE_RC && qp->srq)
+			req->flags = CMDQ_MODIFY_QP_FLAGS_SRQ_USED;
+		mandatory_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_PKEY;
+	}
+
+	if (_is_min_rnr_in_rtr_rts_mandatory(res->dattr->dev_cap_ext_flags2) &&
+	    (qp->cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_RTR &&
+	    qp->state == CMDQ_MODIFY_QP_NEW_STATE_RTS)) {
+		if (qp->type == CMDQ_MODIFY_QP_QP_TYPE_RC)
+			mandatory_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_MIN_RNR_TIMER;
+	}
+
+	if (qp->type == CMDQ_MODIFY_QP_QP_TYPE_UD || qp->type == CMDQ_MODIFY_QP_QP_TYPE_GSI)
+		mandatory_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_QKEY;
+
+	qp->modify_flags |= mandatory_flags;
+	req->qp_type = qp->type;
+}
+
+static int bng_sp_get_iqm_xrrq_size(bool xrrq, struct bng_re_res *res, struct bng_re_qp *qp)
+{
+	struct bng_sp_qp *sp = &qp->sp_qp;
+	int xrrq_overflow = 0;
+	int dattr_xrrq_size;
+	int iqm_xrrq_size;
+	int qp_xrrq_size;
+	int xrrq_size;
+
+	iqm_xrrq_size = xrrq ? qp->iqm_res.irrq_size : qp->iqm_res.orrq_size;
+	qp_xrrq_size = xrrq ? sp->max_dest_rd_atomic : sp->max_rd_atomic;
+	qp_xrrq_size = max_t(int, 4, qp_xrrq_size);
+	dattr_xrrq_size = xrrq ? res->dattr->max_qp_init_rd_atom : res->dattr->max_qp_rd_atom;
+	/* To avoid irrq overflow, irrq needs to be greater than orrq */
+	xrrq_overflow = xrrq ?  BNG_RE_IQM_IRRQ_OVERFLOW_COMP : 0;
+	qp_xrrq_size = qp_xrrq_size + xrrq_overflow;
+
+	if (!iqm_xrrq_size) {
+		/* Allocate IQM resource for both orrq and irrq (applicable only for PF) */
+		/* Will be used once IQM resource allocation is moved to INIT to RTR */
+	}
+
+	if (xrrq)
+		iqm_xrrq_size = IRRQ_CACHELINE_TO_ENTRIES(iqm_xrrq_size);
+	else
+		iqm_xrrq_size = ORRQ_CACHELINE_TO_ENTRIES(iqm_xrrq_size);
+
+	/* irrq/orrq size will be minimum of device attribute & per qp rd_atomic size */
+	xrrq_size = min_t(int, iqm_xrrq_size, qp_xrrq_size);
+
+	return xrrq_size;
+}
+#define QP_FIRST_MODIFY	\
+	MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_QP_FIRST_MODIFY
+#define QP_MODIFY_XID_FIRST_USE	\
+	MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_XID_FIRST_USE
+static int bng_sp_fill_mpc_qp_create_parms(struct bng_re_res *res,
+					   struct qp_modify_data *d,
+					   struct bng_re_qp *qp)
+{
+	struct bng_sp_qp *sp = &qp->sp_qp;
+	struct bng_re_q *sq = &sp->sq;
+	struct bng_re_q *rq = &sp->rq;
+	struct bng_re_pbl *pbl;
+	u32 qp_flags = 0;
+	u8 pg_sz_lvl = 0;
+	u16 nsge;
+
+	d->qp_cid = cpu_to_le32(sp->id);
+	if (!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &sp->flags)) {
+		u8 qmf = QP_FIRST_MODIFY;
+
+		if (!bng_sp_get_initial_created_flag(res, sp))
+			qmf |=  QP_MODIFY_XID_FIRST_USE;
+
+		d->qp_modify_flags |= qmf;
+	}
+
+	if (sp->type != CMDQ_CREATE_QP_TYPE_GSI &&
+	    _is_ext_stats_supported(sp->dev_cap_ext_flags)) {
+		d->ext_stats_ctx_id = cpu_to_le32(sp->roce_stat_ext_xid);
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_EXT_STATS_CTX_VALID;
+	}
+
+	d->qp_type = sp->type;
+	d->type = sp->type;
+	d->schq_id = 0;
+	d->dpi = cpu_to_le32(sp->dpi->dpi);
+	d->qp_handle = cpu_to_le64(sp->qp_handle);
+	d->sq_size = cpu_to_le32(sq->max_sw_wqe);
+	d->scq_cid = cpu_to_le32(sp->scq->id);
+	pbl = &sq->hwq.pbl[BNG_PBL_LVL_0];
+	d->sq_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+
+	qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_RESERVED_LKEY_ENABLE;
+	qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_FR_PMR_ENABLED;
+	if (sp->sig_type)
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_FORCE_COMPLETION;
+	qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_VARIABLE_SIZED_WQE_ENABLED;
+	if (sp->type == CMDQ_CREATE_QP_TYPE_RC)
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_RDMA_READ_OR_ATOMICS_USED;
+	if (sp->type == CMDQ_CREATE_QP_TYPE_GSI || sp->type == CMDQ_CREATE_QP_TYPE_UD)
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_RESPONDER_UD_CQE_WITH_CFA;
+	if (res->dattr &&
+	    bng_ext_stats_supported(res->cctx, res->dattr->dev_cap_flags, res->is_vf))
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_EXT_STATS_ENABLED;
+	if (res->cctx->modes.te_bypass)
+		qp_flags |= CMDQ_CREATE_QP_QP_FLAGS_OPTIMIZED_TRANSMIT_ENABLED;
+
+	pg_sz_lvl = (bng_re_base_pg_size(&sq->hwq) << CMDQ_CREATE_QP_SQ_PG_SIZE_SFT);
+	pg_sz_lvl |= (sq->hwq.level & CMDQ_CREATE_QP_SQ_LVL_MASK) << CMDQ_CREATE_QP_SQ_LVL_SFT;
+	d->sq_pg_size_sq_lvl = pg_sz_lvl;
+	d->sq_fwo_sq_sge =
+			cpu_to_le16(((0 << CMDQ_CREATE_QP_SQ_FWO_SFT) &
+				    CMDQ_CREATE_QP_SQ_FWO_MASK) |
+				    (sq->max_sge & CMDQ_CREATE_QP_SQ_SGE_MASK));
+
+	d->sq_max_num_wqes = min_t(u16, sq->max_wqe - 1, SQ_MAX_NUM_WQES_DEFAULT);
+
+	if (!sp->srq && rq->max_wqe) {
+		pbl = &rq->hwq.pbl[BNG_PBL_LVL_0];
+		d->rq_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+		pg_sz_lvl = (bng_re_base_pg_size(&rq->hwq) <<
+			     CMDQ_CREATE_QP_RQ_PG_SIZE_SFT);
+		pg_sz_lvl |= (rq->hwq.level & CMDQ_CREATE_QP_RQ_LVL_MASK)
+						<< CMDQ_CREATE_QP_RQ_LVL_SFT;
+		d->rq_pg_size_rq_lvl = pg_sz_lvl;
+		nsge = rq->max_sge;
+		d->rq_fwo_rq_sge =
+				cpu_to_le16(((0 << CMDQ_CREATE_QP_RQ_FWO_SFT) &
+					    CMDQ_CREATE_QP_RQ_FWO_MASK) |
+					    (nsge & CMDQ_CREATE_QP_RQ_SGE_MASK));
+
+		d->rq_size = cpu_to_le32(rq->max_wqe);
+		d->rq_prod_idx = cpu_to_le16((u16)(rq->hwq.prod & 0xffffU));
+	} else {
+		d->rq_size = 0;
+		d->rq_prod_idx = 0;
+	}
+
+	if (sp->srq) {
+		d->qp_flags = cpu_to_le32(le32_to_cpu(d->qp_flags) |
+					  CMDQ_CREATE_QP_QP_FLAGS_SRQ_USED);
+		d->srq_cid = cpu_to_le32(sp->srq->id);
+	}
+
+	d->rcq_cid = cpu_to_le32(sp->rcq->id);
+
+	if (sp->type == CMDQ_CREATE_QP_TYPE_RC &&
+	    qp->iqm_res.irrq_addr != BNG_RE_IQM_INVALID_IDX) {
+		d->msn_iqp = cpu_to_le32(qp->iqm_res.msn_addr);
+		d->irrq_iqp = cpu_to_le32(qp->iqm_res.irrq_addr);
+		d->orrq_iqp = cpu_to_le32(qp->iqm_res.orrq_addr);
+		d->msn_size = cpu_to_le32(qp->iqm_res.msn_size);
+		d->irrq_size = cpu_to_le32(qp->iqm_res.irrq_size);
+		d->orrq_size = cpu_to_le32(qp->iqm_res.orrq_size);
+	}
+
+	d->qp_flags = cpu_to_le32(qp_flags);
+	d->pd_id = cpu_to_le32(sp->pd->id);
+
+	return 0;
+}
+
+static void __filter_modify_flags(struct bng_sp_qp *qp)
+{
+	switch (qp->cur_qp_state) {
+	case CMDQ_MODIFY_QP_NEW_STATE_RESET:
+		switch (qp->state) {
+		case CMDQ_MODIFY_QP_NEW_STATE_INIT:
+			break;
+		default:
+			break;
+	}
+	break;
+	case CMDQ_MODIFY_QP_NEW_STATE_INIT:
+		switch (qp->state) {
+		case CMDQ_MODIFY_QP_NEW_STATE_RTR:
+			/* INIT->RTR, configure the path_mtu to the default
+			 * 2048 if not being requested
+			 */
+			if (qp->type != CMDQ_CREATE_QP_TYPE_GSI &&
+			    qp->type != CMDQ_CREATE_QP_TYPE_UD &&
+			    !(qp->modify_flags &
+			    CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU)) {
+				qp->modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
+				qp->path_mtu = CMDQ_MODIFY_QP_PATH_MTU_MTU_2048;
+			}
+
+			/* Bono FW requires the max_dest_rd_atomic to be >= 1 */
+			if (qp->max_dest_rd_atomic < 1)
+				qp->max_dest_rd_atomic = 1;
+
+			/* TODO: Bono FW 0.0.12.0+ does not allow SRC_MAC modification */
+			qp->modify_flags &= ~CMDQ_MODIFY_QP_MODIFY_MASK_SRC_MAC;
+			/* Bono FW 20.6.5 requires SGID_INDEX to be configured */
+			if (!(qp->modify_flags & CMDQ_MODIFY_QP_MODIFY_MASK_SGID_INDEX)) {
+				qp->modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_SGID_INDEX;
+				qp->ah.sgid_index = 0;
+			}
+				break;
+		default:
+			break;
+		}
+			break;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTR:
+		switch (qp->state) {
+		case CMDQ_MODIFY_QP_NEW_STATE_RTS:
+			/* Bono FW requires the max_rd_atomic to be >= 1 */
+			if (qp->max_rd_atomic < 1)
+				qp->max_rd_atomic = 1;
+
+			/* TODO: Bono FW 0.0.12.0+ does not allow PKEY_INDEX,
+			 * DGID, FLOW_LABEL, SGID_INDEX, HOP_LIMIT,
+			 * TRAFFIC_CLASS, DEST_MAC, PATH_MTU, RQ_PSN,
+			 * MIN_RNR_TIMER, MAX_DEST_RD_ATOMIC, DEST_QP_ID
+			 * modification
+			 */
+
+			qp->modify_flags &=
+					~(CMDQ_MODIFY_QP_MODIFY_MASK_PKEY |
+					CMDQ_MODIFY_QP_MODIFY_MASK_DGID |
+					CMDQ_MODIFY_QP_MODIFY_MASK_FLOW_LABEL |
+					CMDQ_MODIFY_QP_MODIFY_MASK_SGID_INDEX |
+					CMDQ_MODIFY_QP_MODIFY_MASK_HOP_LIMIT |
+					CMDQ_MODIFY_QP_MODIFY_MASK_TRAFFIC_CLASS |
+					CMDQ_MODIFY_QP_MODIFY_MASK_DEST_MAC |
+					CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU |
+					CMDQ_MODIFY_QP_MODIFY_MASK_RQ_PSN |
+					CMDQ_MODIFY_QP_MODIFY_MASK_MIN_RNR_TIMER |
+					CMDQ_MODIFY_QP_MODIFY_MASK_MAX_DEST_RD_ATOMIC |
+					CMDQ_MODIFY_QP_MODIFY_MASK_DEST_QP_ID);
+				break;
+		default:
+			break;
+		}
+		break;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTS:
+		break;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQD:
+		break;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQE:
+		break;
+	case CMDQ_MODIFY_QP_NEW_STATE_ERR:
+		break;
+	default:
+		break;
+	}
+}
+
+static int bng_sp_fill_mpc_qp_modify_parms(struct bng_re_res *res,
+					   struct qp_modify_data *d,
+					   struct bng_re_qp *qp)
+{
+	struct cmdq_modify_qp temp_req = {};
+	struct bng_sp_qp *sp = &qp->sp_qp;
+	u32 m = (u32)sp->modify_flags;
+	u32 temp32[4];
+
+	/* Check if QP free flag is required */
+	if (test_bit(BNG_SP_QP_FLAG_MPC_QP_FREE, &sp->flags))
+		m |= MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_QP_FREE;
+
+	/* Filter out the qp_attr_mask based on the state->new transition */
+	__filter_modify_flags(sp);
+	m = (u32)sp->modify_flags;
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_STATE) {
+		/* Set mandatory attributes for INIT -> RTR and RTR -> RTS
+		 * transition
+		 */
+		if (_is_optimize_modify_qp_supported(res->dattr->dev_cap_ext_flags2) &&
+		    is_optimized_state_transition(sp)) {
+			bng_set_mandatory_attributes(res, sp, &temp_req);
+			temp_req.flags =
+					CMDQ_MODIFY_QP_FLAGS_SRQ_USED;
+			d->flags = temp_req.flags;
+			d->qp_type = temp_req.qp_type;
+		}
+	}
+
+	if (bng_re_init_fw_state_rtr_enabled(res->cctx))
+		d->rq_prod_idx = cpu_to_le16(sp->req_buffer_count);
+
+	if (sp->udcc_exclude)
+		d->flags |= CMDQ_MODIFY_QP_FLAGS_EXCLUDE_QP_UDCC;
+
+	d->modify_mask = cpu_to_le32(m);
+	d->qp_cid = cpu_to_le32(sp->id);
+
+	if (d->modify_mask & CMDQ_MODIFY_QP_MODIFY_MASK_STATE) {
+		d->network_type_en_sqd_async_notify_new_state =
+				(sp->state & CMDQ_MODIFY_QP_NEW_STATE_MASK) |
+				(sp->en_sqd_async_notify
+						? CMDQ_MODIFY_QP_EN_SQD_ASYNC_NOTIFY : 0);
+	}
+	d->network_type_en_sqd_async_notify_new_state |= sp->nw_type;
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_ACCESS)
+		d->access = sp->access;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_PKEY)
+		d->pkey = cpu_to_le16(IB_DEFAULT_PKEY_FULL);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_QKEY)
+		d->qkey = cpu_to_le32(sp->qkey);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_FLOW_LABEL)
+		d->flow_label = cpu_to_le32(sp->ah.flow_label);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_DGID) {
+		memcpy(temp32, sp->ah.dgid.data, sizeof(struct bng_re_gid));
+		d->dgid[0] = cpu_to_le32(temp32[0]);
+		d->dgid[1] = cpu_to_le32(temp32[1]);
+		d->dgid[2] = cpu_to_le32(temp32[2]);
+		d->dgid[3] = cpu_to_le32(temp32[3]);
+	}
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_SGID_INDEX) {
+		if (sp->is_roce_mirror_qp)
+			d->sgid_index = cpu_to_le16(res->sgid_tbl.hw_id[sp->ugid_index]);
+		else
+			d->sgid_index = cpu_to_le16(res->sgid_tbl.hw_id[sp->ah.sgid_index]);
+	}
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_HOP_LIMIT)
+		d->hop_limit = sp->ah.hop_limit;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_TRAFFIC_CLASS)
+		d->traffic_class = sp->ah.traffic_class;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_DEST_MAC)
+		memcpy(d->dest_mac, sp->ah.dmac, 6);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU)
+		d->path_mtu_pingpong_push_enable = sp->path_mtu;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_TIMEOUT)
+		d->timeout = sp->timeout;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_RETRY_CNT)
+		d->retry_cnt = sp->retry_cnt;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_RNR_RETRY)
+		d->rnr_retry = sp->rnr_retry;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_MIN_RNR_TIMER)
+		d->min_rnr_timer = sp->min_rnr_timer;
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_RQ_PSN)
+		d->rq_psn = cpu_to_le32(sp->rq.psn);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_SQ_PSN)
+		d->sq_psn = cpu_to_le32(sp->sq.psn);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_MAX_RD_ATOMIC)
+		d->max_rd_atomic = bng_sp_get_iqm_xrrq_size(0, res, qp);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_MAX_DEST_RD_ATOMIC)
+		d->max_dest_rd_atomic = bng_sp_get_iqm_xrrq_size(1, res, qp);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_SQ_SIZE)
+		d->sq_size = cpu_to_le32(bng_re_set_sq_size(&sp->sq));
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_RQ_SIZE) {
+		if (!sp->srq && sp->rq.max_wqe)
+			d->rq_size = cpu_to_le32(sp->rq.max_wqe);
+	}
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_SQ_SGE)
+		d->sq_sge = cpu_to_le16(sp->sq.max_sge);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_RQ_SGE && !sp->srq)
+		d->rq_sge = cpu_to_le16(sp->rq.max_sge);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_MAX_INLINE_DATA)
+		d->max_inline_data = cpu_to_le32(sp->max_inline_data);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_DEST_QP_ID)
+		d->dest_qp_id = cpu_to_le32(sp->dest_qpn);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_ENABLE_CC)
+		d->enable_cc = cpu_to_le16(CMDQ_MODIFY_QP_ENABLE_CC);
+
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_TOS_ECN)
+		d->tos_dscp_tos_ecn =
+				((sp->tos_ecn << CMDQ_MODIFY_QP_TOS_ECN_SFT) &
+						CMDQ_MODIFY_QP_TOS_ECN_MASK);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_TOS_DSCP)
+		d->tos_dscp_tos_ecn |=
+				((sp->tos_dscp << CMDQ_MODIFY_QP_TOS_DSCP_SFT) &
+						CMDQ_MODIFY_QP_TOS_DSCP_MASK);
+	if (m & CMDQ_MODIFY_QP_MODIFY_MASK_VLAN_ID) {
+		d->vlan_pcp_vlan_dei_vlan_id =
+				((res->sgid_tbl.tbl[sp->ah.sgid_index].vlan_id
+						<< CMDQ_MODIFY_QP_VLAN_ID_SFT) &
+						CMDQ_MODIFY_QP_VLAN_ID_MASK);
+		d->vlan_pcp_vlan_dei_vlan_id |=
+				((sp->ah.sl << CMDQ_MODIFY_QP_VLAN_PCP_SFT) &
+						CMDQ_MODIFY_QP_VLAN_PCP_MASK);
+		d->vlan_pcp_vlan_dei_vlan_id =
+				cpu_to_le16(d->vlan_pcp_vlan_dei_vlan_id);
+	}
+
+	m = sp->ext_modify_flags;
+	d->ext_modify_mask = cpu_to_le32(sp->ext_modify_flags);
+	if (m & CMDQ_MODIFY_QP_EXT_MODIFY_MASK_EXT_STATS_CTX)
+		d->ext_stats_ctx_id = cpu_to_le32(sp->roce_stat_ext_xid);
+
+	return 0;
+}
+
+static int bng_sp_fill_mpc_qp_modify_and_create_parms(struct bng_re_res *res,
+						      struct qp_modify_data *d,
+						      struct bng_re_qp *qp)
+{
+	if (!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags) &&
+	    !test_bit(BNG_SP_QP_FLAG_MPC_QP_FREE, &qp->sp_qp.flags))
+		bng_sp_fill_mpc_qp_create_parms(res, d, qp);
+
+	bng_sp_fill_mpc_qp_modify_parms(res, d, qp);
+	return 0;
+}
+
+static void bng_sp_set_initial_created_flag(struct bng_re_res *res,
+					    struct bng_sp_qp *qp)
+{
+	u32 qp_idx;
+	unsigned long flag;
+	struct bng_re_reftbl *tbl;
+
+	tbl = &res->reftbl.qpref;
+	qp_idx = map_qp_id_to_reftbl_indx(qp->id, tbl);
+	spin_lock_irqsave(&tbl->lock, flag);
+	/* Make sure we have the right table index */
+	if (tbl->rec[qp_idx].xid == qp->id &&
+	    tbl->rec[qp_idx].handle == qp &&
+	    !tbl->rec[qp_idx].initial_mpc_sent)
+		tbl->rec[qp_idx].initial_mpc_sent = true;
+	spin_unlock_irqrestore(&tbl->lock, flag);
+}
+
+int bng_sp_fill_and_send_mpc_qp_modify(struct bng_re_res *res,
+				       struct bng_re_qp **qps,
+				       int num_qps,
+				       bool *xid_cleanup_handled)
+{
+	struct mpc_qp_modify_cmpl resp;
+	struct mpc_qp_modify_cmd cmd;
+	struct bng_re_qp *qp = *qps;
+	struct qp_modify_data *d;
+	u32 cpu_modify_mask;
+	int rc = 0;
+
+	if (xid_cleanup_handled)
+		*xid_cleanup_handled = false;
+
+	if (num_qps != 1)
+		return -EINVAL;
+
+	if (bng_re_init_fw_state_rtr_enabled(res->cctx)) {
+		if (!test_bit(BNG_SP_QP_FLAG_MPC_QP_FREE, &qp->sp_qp.flags)) {
+			if ((qp->sp_qp.state == CMDQ_MODIFY_QP_NEW_STATE_RESET ||
+			    qp->sp_qp.state == CMDQ_MODIFY_QP_NEW_STATE_INIT) &&
+			    (qp->sp_qp.cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_RESET ||
+			    qp->sp_qp.cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_INIT)) {
+				dev_warn(&res->pdev->dev,
+					 "MPC-skip modify qp- id: %d State: %d->%d\n",
+					 qp->sp_qp.id, qp->sp_qp.cur_qp_state,
+					 qp->sp_qp.state);
+				qp->sp_qp.cur_qp_state = qp->sp_qp.state;
+				return 0;
+			}
+		}
+	}
+
+	memset(&cmd, 0, sizeof(cmd));
+	memset(&resp, 0, sizeof(resp));
+
+	d = (struct qp_modify_data *)&cmd.qp_cid;
+	bng_sp_fill_mpc_qp_modify_and_create_parms(res, d, qp);
+
+	cmd.resp_size = sizeof(resp) / BNG_RE_MPC_CQ_STRIDE;
+	if (res->is_vf) {
+		cmd.req_type = MPC_CMD_HDR_REQ_TYPE_PFVF;
+		cmd.req_subtype = MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY;
+	} else {
+		cmd.req_type = MPC_CMD_HDR_REQ_TYPE_RCA;
+		cmd.req_subtype = MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY;
+	}
+
+	dev_err(&res->pdev->dev, "MPC: ROCE QP modify id:%d %d->%d\n",
+		qp->sp_qp.id, qp->sp_qp.cur_qp_state, qp->sp_qp.state);
+
+	cpu_modify_mask = le32_to_cpu(d->modify_mask);
+
+	if ((MPC_QP_MODIFY_CMD_QP_MODIFY_DATA_QP_MODIFY_FLAGS_QP_MODIFY_FLAGS_QP_FIRST_MODIFY &
+					cmd.qp_modify_flags) &&
+					!(cpu_modify_mask & CMDQ_MODIFY_QP_MODIFY_MASK_STATE)) {
+		dev_err(&res->pdev->dev,
+			"%s: bad state trans. cqpst:%d,qpst:%d,xid:%d,mask:%x",
+			__func__,
+			qp->sp_qp.cur_qp_state,
+			qp->sp_qp.state,
+			qp->sp_qp.id,
+			cpu_modify_mask);
+		return -EINVAL;
+	}
+
+	if (!res->rdev) {
+		dev_err(&res->pdev->dev, "%s: no rdev for MPC xmit\n", __func__);
+		return -ENODEV;
+	}
+
+	rc = bng_re_roce_mpc_xmit(res->rdev, &cmd, sizeof(cmd),
+				  &resp, sizeof(resp), false);
+
+	if (rc) {
+		dev_err(&res->pdev->dev, "MPC: QP modify failed for QP %d, rc=%d\n",
+			qp->sp_qp.id, rc);
+		return rc;
+	}
+
+	if (le16_to_cpu(resp.error_code) != MPC_QP_MODIFY_CMPL_ERROR_CODE_SUCCESS) {
+		dev_err(&res->pdev->dev,
+			"MPC: QP modify cmpl error=%u qp=%u\n",
+			le16_to_cpu(resp.error_code), qp->sp_qp.id);
+		return -EIO;
+	}
+
+	if (qp->sp_qp.id != 1 &&
+	    le32_to_cpu(resp.xid) != qp->sp_qp.id) {
+		dev_err(&res->pdev->dev,
+			"MPC: ROCE QP modify xid mismatch cmd:%d resp:%u\n",
+			qp->sp_qp.id, le32_to_cpu(resp.xid));
+		return -EIO;
+	}
+
+	if (qp->sp_qp.state == CMDQ_MODIFY_QP_NEW_STATE_RTR)
+		qp->sp_qp.lag_src_mac = be32_to_cpu(resp.lag_src_mac);
+
+	if (!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags)) {
+		set_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags);
+
+		/* INITIAL_CREATE_SENT is reset when the QP state is modified to RST
+		 * QP_DESTROY has QP_FREE flag to release some stats resource
+		 * as part of QP destroy in FW and can be sent in RST state
+		 */
+
+		if (!test_bit(BNG_SP_QP_FLAG_MPC_ALLOW_QP_DESTROY, &qp->sp_qp.flags)) {
+			set_bit(BNG_SP_QP_FLAG_MPC_ALLOW_QP_DESTROY, &qp->sp_qp.flags);
+			dev_dbg(&res->pdev->dev, "MPC: QP %d marked as initial create sent\n",
+				qp->sp_qp.id);
+		}
+	}
+
+	qp->sp_qp.cur_qp_state = qp->sp_qp.state;
+
+	/* If the QP is moved back to INIT->RTR then send create params again */
+	if (qp->sp_qp.cur_qp_state == CMDQ_MODIFY_QP_NEW_STATE_RESET) {
+		clear_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags);
+		dev_dbg(&res->pdev->dev, "MPC: QP[%d] CLEAR initial create sent flag\n",
+			qp->sp_qp.id);
+	}
+
+	bng_sp_set_initial_created_flag(res, &qp->sp_qp);
+
+	return 0;
+}
+
+int bng_sp_mpc_modify_qp(struct bng_re_res *res, struct bng_sp_qp *sp_qp)
+{
+	struct bng_re_qp *qp = container_of(sp_qp, struct bng_re_qp, sp_qp);
+
+	return bng_sp_fill_and_send_mpc_qp_modify(res, &qp, 1, NULL);
+}
+
+int bng_sp_query_qp(struct bng_re_res *res, struct bng_sp_qp *qp)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_query_qp_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct bng_re_rcfw_sbuf sbuf;
+	struct creq_query_qp_resp_sb *sb;
+	struct cmdq_query_qp req = {};
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_QUERY_QP,
+			     sizeof(req));
+
+	sbuf.size = ALIGN(sizeof(*sb), BNG_FW_CMDQE_UNITS);
+	sbuf.sb = dma_alloc_coherent(&rcfw->pdev->dev, sbuf.size,
+				     &sbuf.dma_addr, GFP_KERNEL);
+	if (!sbuf.sb)
+		return -ENOMEM;
+	req.resp_size = sbuf.size / BNG_FW_CMDQE_UNITS;
+	req.qp_cid = cpu_to_le32(qp->id);
+	sb = sbuf.sb;
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, &sbuf, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (!rc) {
+		qp->state = sb->en_sqd_async_notify_state & CREQ_QUERY_QP_RESP_SB_STATE_MASK;
+		qp->cur_qp_state = qp->state; /* Assume same for now */
+		qp->en_sqd_async_notify =
+			(sb->en_sqd_async_notify_state &
+			CREQ_QUERY_QP_RESP_SB_EN_SQD_ASYNC_NOTIFY) ? 1 : 0;
+		qp->access = sb->access;
+		qp->pkey_index = le16_to_cpu(sb->pkey);
+		qp->qkey = le32_to_cpu(sb->qkey);
+		qp->ah.host_sgid_index = le16_to_cpu(sb->sgid_index);
+		qp->udp_sport = le16_to_cpu(sb->udp_src_port);
+		qp->ah.hop_limit = sb->hop_limit;
+		qp->ah.traffic_class = sb->traffic_class;
+		qp->ah.sl = 0;
+		qp->path_mtu = (le16_to_cpu(sb->path_mtu_dest_vlan_id)
+				& CREQ_QUERY_QP_RESP_SB_PATH_MTU_MASK)
+				>> CREQ_QUERY_QP_RESP_SB_PATH_MTU_SFT;
+		qp->timeout = sb->timeout;
+		qp->retry_cnt = sb->retry_cnt;
+		qp->rnr_retry = sb->rnr_retry;
+		qp->min_rnr_timer = sb->min_rnr_timer;
+		qp->port_id = le16_to_cpu(sb->port_id);
+		qp->rq.psn = le32_to_cpu(sb->rq_psn) & 0xffffff;
+		qp->max_rd_atomic = sb->max_rd_atomic;
+		qp->sq.psn = le32_to_cpu(sb->sq_psn) & 0xffffff;
+		qp->max_dest_rd_atomic = sb->max_dest_rd_atomic;
+		qp->dest_qpn = le32_to_cpu(sb->dest_qp_id);
+		memcpy(qp->ah.dgid.data, sb->dgid, sizeof(qp->ah.dgid.data));
+	}
+	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
+			  sbuf.sb, sbuf.dma_addr);
+
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index a6f688c0af3d..60f1cdef145e 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -21,6 +21,35 @@
 #define NQE_PG(x)		(((x) & ~NQE_MAX_IDX_PER_PG) / NQE_CNT_PER_PG)
 #define NQE_IDX(x)		((x) & NQE_MAX_IDX_PER_PG)
 
+#define BNG_RE_MAX_SQSZ 0xffffu
+
+#define BNG_VAR_MAX_SLOT_ALIGN		256
+#define IRD_LIMIT_TO_IRRQ_SLOTS(x)	(2 * (x) + 2)
+#define ORD_LIMIT_TO_ORRQ_SLOTS(x)	((x) + 1)
+#define SQ_MAX_NUM_WQES_DEFAULT		16
+#define IB_DEFAULT_PKEY_FULL		0xFFFF
+
+#define BNG_RE_IQM_INVALID_IDX                  (0xFFFFFFFFU)
+#define BNG_RE_IQM_ROUND_UP_BYTE_SIZE           128
+
+#define BNG_RE_MAX_ORRQE_ENTRY_SIZE           sizeof(struct xrrq_orrq)
+#define BNG_RE_MAX_IRRQE_ENTRY_SIZE           sizeof(struct xrrq_irrq)
+#define BNG_RE_IQM_IRRQ_OVERFLOW_COMP                                   \
+	((1) * (BNG_RE_IQM_ROUND_UP_BYTE_SIZE / BNG_RE_MAX_IRRQE_ENTRY_SIZE))
+#define IRRQ_CACHELINE_TO_ENTRIES(x)    ((x) * (BNG_RE_IQM_ROUND_UP_BYTE_SIZE / \
+						BNG_RE_MAX_IRRQE_ENTRY_SIZE))
+#define ORRQ_CACHELINE_TO_ENTRIES(x)    ((x) * (BNG_RE_IQM_ROUND_UP_BYTE_SIZE / \
+						BNG_RE_MAX_ORRQE_ENTRY_SIZE))
+
+struct bng_re_qp;
+
+/* MPC slowpath software bits in sp_qp.flags */
+enum {
+	BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT = 0,
+	BNG_SP_QP_FLAG_MPC_QP_FREE = 1,
+	BNG_SP_QP_FLAG_MPC_ALLOW_QP_DESTROY = 2,
+};
+
 struct bng_re_dev_attr {
 #define FW_VER_ARR_LEN			4
 	u8				fw_ver[FW_VER_ARR_LEN];
@@ -33,6 +62,7 @@ struct bng_re_dev_attr {
 	u32				max_qp_init_rd_atom;
 	u32				max_qp_wqes;
 	u32				max_sq_wqes;
+	u32				max_rq_wqes;
 	u32				max_qp_sges;
 	u32				max_cq;
 	u32				max_cq_wqes;
@@ -53,6 +83,7 @@ struct bng_re_dev_attr {
 	bool				is_atomic;
 	u16                             dev_cap_flags;
 	u16                             dev_cap_flags2;
+	u16				dev_cap_ext_flags2;
 	u32                             max_dpi;
 };
 
@@ -287,6 +318,135 @@ struct bng_sp_ah {
 	u8				nw_type;
 };
 
+struct bng_sp_qp {
+	struct bng_sp_pd		*pd;
+	struct bng_re_dpi		*dpi;
+	struct bng_re_chip_ctx		*cctx;
+	u64				qp_handle;
+	u32				id;
+	u8				is_user;
+	u8				type;
+	u8				sig_type;
+	u8				wqe_mode;
+	u8				state;
+	u8				cur_qp_state;
+	u16				dev_cap_ext_flags2;
+	u64				modify_flags;
+	unsigned long			flags;
+	u32				max_inline_data;
+	u32				mtu;
+	u8				path_mtu;
+	bool				en_sqd_async_notify;
+	u16				pkey_index;
+	u32				qkey;
+	u32				dest_qp_id;
+	u8				access;
+	u8				timeout;
+	u8				retry_cnt;
+	u8				rnr_retry;
+	u64				wqe_cnt;
+	u32				min_rnr_timer;
+	u32				max_rd_atomic;
+	u32				max_dest_rd_atomic;
+	u32				dest_qpn;
+	u32				ext_modify_flags;
+	u32				roce_stat_ext_xid;
+	u8				smac[6];
+	u16				vlan_id;
+	u16				port_id;
+	u16				udp_sport;
+	u8				nw_type;
+	bool				is_roce_mirror_qp;
+	u8				tos_ecn;
+	u8				tos_dscp;
+	struct bng_sp_ah		ah;
+
+	struct bng_re_q			sq;
+	struct bng_re_q			rq;
+	struct bng_sp_srq		*srq;
+	struct bng_sp_cq		*scq;
+	struct bng_sp_cq		*rcq;
+	struct bng_re_hwq		irrq;
+	struct bng_re_hwq		orrq;
+	int				sq_hdr_buf_size;
+	int				rq_hdr_buf_size;
+	void				*sq_hdr_buf;
+	dma_addr_t			sq_hdr_buf_map;
+	void				*rq_hdr_buf;
+	dma_addr_t			rq_hdr_buf_map;
+	struct list_head		sq_flush;
+	struct list_head		rq_flush;
+	/* 4-byte scrambled MAC received from FW on RTR transition */
+	u32				lag_src_mac;
+	u32				msn;
+	/* indicates buffers avail for rq; at transition to rtr */
+	u32				req_buffer_count;
+	u8				rtr_transition_pending;
+	u8				dev_cap_ext_flags;
+	bool				udcc_exclude;
+	u32				ugid_index;
+#define INVALID_VF_IDX 0xFFFFFFFF
+	u32				vf_idx;
+};
+
+/* SWQ */
+struct bng_re_swq {
+	u64			wr_id;
+	int			next_idx;
+	u8			type;
+	u8			flags;
+	u32			slot_idx;
+	u8			slots;
+};
+
+static inline u32 bng_re_get_depth(struct bng_re_q *que, bool is_sq)
+{
+	u32 slots;
+
+	slots = (que->wqe_size * que->max_wqe) / sizeof(struct sq_sge);
+	if (is_sq)
+		slots = ALIGN(slots, BNG_VAR_MAX_SLOT_ALIGN);
+	return slots;
+}
+
+static inline u32 bng_re_set_sq_size(struct bng_re_q *que)
+{
+	return bng_re_get_depth(que, true);
+}
+
+static inline u32 bng_re_set_sq_max_slot(u8 wqe_mode)
+{
+	return 1;
+}
+
+static inline u32 bng_re_set_rq_max_slot(u32 wqe_size)
+{
+	return (wqe_size / sizeof(struct sq_sge));
+}
+
+static inline const char  *__to_qp_state_str(u8 state)
+{
+	switch (state) {
+	case CMDQ_MODIFY_QP_NEW_STATE_RESET:
+		return "RESET";
+	case CMDQ_MODIFY_QP_NEW_STATE_INIT:
+		return "INIT";
+	case CMDQ_MODIFY_QP_NEW_STATE_RTR:
+		return "RTR";
+	case CMDQ_MODIFY_QP_NEW_STATE_RTS:
+		return "RTS";
+	case CMDQ_MODIFY_QP_NEW_STATE_SQD:
+		return "SQD";
+	case CMDQ_MODIFY_QP_NEW_STATE_SQE:
+		return "SQE";
+	case CMDQ_MODIFY_QP_NEW_STATE_ERR:
+		return "ERR";
+	default:
+		return "NotSupp";
+	}
+}
+
+int bng_re_alloc_init_swq(struct bng_re_q *que);
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -322,6 +482,7 @@ int bng_sp_resize_cq(struct bng_re_res *res, struct bng_sp_cq *cq,
 		     int new_cqes);
 int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq);
 int bng_sp_create_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
+int bng_sp_query_qp(struct bng_re_res *res, struct bng_sp_qp *qp);
 int bng_sp_query_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
 int bng_sp_destroy_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
 int bng_re_qext_stat(struct bng_re_rcfw *rcfw, u32 fid,
@@ -331,5 +492,14 @@ int bng_re_get_roce_stats(struct bng_re_rcfw *rcfw,
 int bng_sp_fill_and_send_mpc_ah_modify(struct bng_re_res *res,
 				       struct bng_sp_ah **ahs,
 				       int num_ahs, bool for_destroy, bool block);
-
+void bng_re_flush_cqn_wq(struct bng_sp_qp *qp);
+void bng_re_free_qp_res(struct bng_re_res *res, struct bng_sp_qp *qp);
+void bng_re_clean_qp(struct bng_sp_qp *qp);
+int bng_sp_fill_and_send_mpc_qp_modify(struct bng_re_res *res,
+				       struct bng_re_qp **qps,
+				       int num_qps,
+				       bool *xid_cleanup_handled);
+void bng_re_add_flush_qp(struct bng_sp_qp *qp);
+int bng_sp_mpc_create_qp(struct bng_re_res *res, struct bng_sp_qp *qp);
+int bng_sp_mpc_modify_qp(struct bng_re_res *res, struct bng_sp_qp *sp_qp);
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index c40f8686b6f6..e91fd111d2f1 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/io.h>
+#include <linux/crc16.h>
 #include <net/addrconf.h>
 #include <rdma/ib_cache.h>
 #include <rdma/ib_verbs.h>
@@ -22,6 +23,7 @@
 #include "bng_re.h"
 #include "bng_verbs.h"
 #include "bng_fp.h"
+#include "bng_xid.h"
 
 int bng_re_query_device(struct ib_device *ibdev,
 			struct ib_device_attr *ib_attr,
@@ -578,6 +580,21 @@ static void bng_re_check_and_set_relaxed_ordering(struct bng_re_dev *rdev,
 		mr->flags |= CMDQ_REGISTER_MR_FLAGS_ENABLE_RO;
 }
 
+static int __qp_access_flags_to_ib(u32 cctx, u8 access)
+{
+	int qflags = 0;
+
+	if (access & CMDQ_MODIFY_QP_ACCESS_LOCAL_WRITE)
+		qflags |= IB_ACCESS_LOCAL_WRITE;
+	if (access & CMDQ_MODIFY_QP_ACCESS_REMOTE_READ)
+		qflags |= IB_ACCESS_REMOTE_READ;
+	if (access & CMDQ_MODIFY_QP_ACCESS_REMOTE_WRITE)
+		qflags |= IB_ACCESS_REMOTE_WRITE;
+	if (access & CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC)
+		qflags |= IB_ACCESS_REMOTE_ATOMIC;
+	return qflags;
+}
+
 static int __from_ib_access_flags(int iflags)
 {
 	int qflags = 0;
@@ -1627,3 +1644,1568 @@ int bng_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
 	rdma_ah_set_static_rate(ah_attr, 0);
 	return 0;
 }
+
+/* Helper functions for QP operations */
+static bool bng_re_init_qp_wqe_mode(struct bng_re_dev *rdev)
+{
+	return rdev->chip_ctx->modes.wqe_mode;
+}
+
+static u8 __from_ib_qp_type(enum ib_qp_type type)
+{
+	switch (type) {
+	case IB_QPT_GSI:
+		return CMDQ_CREATE_QP1_TYPE_GSI;
+	case IB_QPT_RC:
+		return CMDQ_CREATE_QP_TYPE_RC;
+	case IB_QPT_UD:
+		return CMDQ_CREATE_QP_TYPE_UD;
+	case IB_QPT_RAW_PACKET:
+		return CMDQ_CREATE_QP_TYPE_RAW_ETHERTYPE;
+	default:
+		return IB_QPT_MAX;
+	}
+}
+
+static bool bng_re_test_qp_limits(struct bng_re_dev *rdev,
+				  struct ib_qp_init_attr *init_attr,
+				  struct bng_re_dev_attr *dev_attr)
+{
+	bool rc = true;
+
+	int ilsize = ALIGN(init_attr->cap.max_inline_data, sizeof(struct sq_sge));
+
+	if (init_attr->cap.max_send_wr < 1) {
+		ibdev_err(&rdev->ibdev, "Create QP failed - max_send_wr must be >= 1");
+		rc = false;
+	}
+	if (!init_attr->srq && init_attr->cap.max_recv_wr < 1) {
+		ibdev_err(&rdev->ibdev, "Create QP failed - max_recv_wr must be >= 1 when not using SRQ");
+		rc = false;
+	}
+	if (init_attr->cap.max_send_wr > dev_attr->max_sq_wqes ||
+	    init_attr->cap.max_recv_wr > dev_attr->max_rq_wqes ||
+	    init_attr->cap.max_send_sge > dev_attr->max_qp_sges ||
+	    init_attr->cap.max_recv_sge > dev_attr->max_qp_sges ||
+	    ilsize > dev_attr->max_inline_data) {
+		ibdev_err(&rdev->ibdev,
+			  "Create QP failed - max exceeded! 0x%x/0x%x 0x%x/0x%x 0x%x/0x%x 0x%x/0x%x 0x%x/0x%x",
+			  init_attr->cap.max_send_wr, dev_attr->max_sq_wqes,
+			  init_attr->cap.max_recv_wr, dev_attr->max_rq_wqes,
+			  init_attr->cap.max_send_sge, dev_attr->max_qp_sges,
+			  init_attr->cap.max_recv_sge, dev_attr->max_qp_sges,
+			  ilsize,
+			  dev_attr->max_inline_data);
+		rc = false;
+	}
+	return rc;
+}
+
+static int bng_re_init_qp_type(struct bng_re_dev *rdev,
+			       struct ib_qp_init_attr *init_attr)
+{
+	int qptype;
+
+	qptype = __from_ib_qp_type(init_attr->qp_type);
+	if (qptype == IB_QPT_MAX) {
+		ibdev_err(&rdev->ibdev, "QP type 0x%x not supported", qptype);
+		qptype = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (init_attr->qp_type == IB_QPT_GSI) {
+		qptype = CMDQ_CREATE_QP_TYPE_GSI;
+		rdev->gsi_ctx.gsi_qp_mode = BNG_RE_GSI_MODE_UD;
+	}
+out:
+	return qptype;
+}
+
+static int bng_re_init_rq_attr(struct bng_re_qp *qp,
+			       struct ib_qp_init_attr *init_attr,
+			       struct bng_re_ucontext *uctx)
+{
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_sp_qp *sp_qp;
+	struct bng_re_dev *rdev;
+	struct bng_re_q *rq;
+	int entries;
+
+	rdev = qp->rdev;
+	sp_qp = &qp->sp_qp;
+	rq = &sp_qp->rq;
+	dev_attr = rdev->dev_attr;
+
+	if (init_attr->srq) {
+		struct bng_re_srq *srq;
+
+		srq = container_of(init_attr->srq, struct bng_re_srq, ib_srq);
+		if (!srq) {
+			dev_err(rdev_to_dev(rdev), "SRQ not found");
+			return -EINVAL;
+		}
+		sp_qp->srq = (struct bng_sp_srq *)&srq->sp_srq;
+		rq->max_wqe = 0;
+	} else {
+		rq->max_sge = init_attr->cap.max_recv_sge;
+		if (rq->max_sge > dev_attr->max_qp_sges)
+			rq->max_sge = dev_attr->max_qp_sges;
+		init_attr->cap.max_recv_sge = rq->max_sge;
+		rq->wqe_size = bng_re_get_rwqe_size(rq->max_sge);
+		/* Allocate 1 more than what's provided so posting max doesn't
+		 * mean empty.
+		 */
+
+		entries = init_attr->cap.max_recv_wr + 1;
+		entries = bng_re_init_depth(entries, uctx);
+		if (init_attr->qp_type == IB_QPT_GSI)
+			entries++;
+		rq->max_wqe = min_t(u32, entries, dev_attr->max_rq_wqes);
+		rq->max_sw_wqe = rq->max_wqe;
+		rq->q_full_delta = 0;
+		rq->sg_info.pgsize = PAGE_SIZE;
+		rq->sg_info.pgshft = PAGE_SHIFT;
+	}
+
+	return 0;
+}
+
+static u16 bng_re_get_swqe_size(int ilsize, int nsge, int align)
+{
+	u16 wqe_size, calc_ils;
+
+	wqe_size = __get_swqe_size(nsge);
+	if (ilsize) {
+		calc_ils = sizeof(struct sq_atomic_hdr) + ilsize;
+		wqe_size = max_t(int, calc_ils, wqe_size);
+	}
+	wqe_size = ALIGN(wqe_size, align);
+	return wqe_size;
+}
+
+static int bng_re_setup_swqe_size(struct bng_re_qp *qp,
+				  u32 *max_inline_data)
+{
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_sp_qp *sp_qp;
+	struct bng_re_dev *rdev;
+	struct bng_re_q *sq;
+	int align, ilsize;
+
+	rdev = qp->rdev;
+	sp_qp = &qp->sp_qp;
+	sq = &sp_qp->sq;
+	dev_attr = rdev->dev_attr;
+
+	align = sizeof(struct sq_sge);
+	ilsize = ALIGN(*max_inline_data, align);
+
+	sq->wqe_size = bng_re_get_swqe_size(ilsize, sq->max_sge, align);
+	if (sq->wqe_size > ALIGN(__get_swqe_size(dev_attr->max_qp_sges), align))
+		return -EINVAL;
+
+	if (*max_inline_data) {
+		sp_qp->max_inline_data = sq->wqe_size -
+					 ALIGN(sizeof(struct sq_atomic_hdr), align);
+		*max_inline_data = sp_qp->max_inline_data;
+	}
+
+	return 0;
+}
+
+static int bng_re_init_sq_attr(struct bng_re_qp *qp,
+			       struct ib_qp_init_attr *init_attr,
+			       struct bng_re_ucontext *uctx)
+{
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_sp_qp *sp_qp;
+	struct bng_re_dev *rdev;
+	struct bng_re_q *sq;
+	int diff = 0;
+	int entries;
+	int rc;
+
+	rdev = qp->rdev;
+	sp_qp = &qp->sp_qp;
+	sq = &sp_qp->sq;
+	dev_attr = rdev->dev_attr;
+
+	entries = init_attr->cap.max_send_wr;
+
+	if (sq->max_sge > dev_attr->max_qp_sges) {
+		sq->max_sge = dev_attr->max_qp_sges;
+		init_attr->cap.max_send_sge = sq->max_sge;
+	}
+
+	rc = bng_re_setup_swqe_size(qp, &init_attr->cap.max_inline_data);
+	if (rc)
+		return rc;
+
+	/*
+	 * Change the SQ depth if user has requested minimum using
+	 * configfs. Only supported for kernel consumers. Setting
+	 * min_tx_depth to 4096 to handle iser SQ full condition
+	 * in most of the newer OS distros
+	 */
+
+	entries = init_attr->cap.max_send_wr;
+
+	if (!uctx && rdev->min_tx_depth && init_attr->qp_type != IB_QPT_GSI) {
+		/*
+		 * If users specify any value greater than 1 use min_tx_depth
+		 * provided by user for comparison. Else, compare it with the
+		 * BNG_RE_MIN_KERNEL_QP_TX_DEPTH and adjust it accordingly.
+		 */
+		if (rdev->min_tx_depth > 1 && entries < rdev->min_tx_depth)
+			entries = rdev->min_tx_depth;
+		else if (entries < BNG_RE_MIN_KERNEL_QP_TX_DEPTH)
+			entries = BNG_RE_MIN_KERNEL_QP_TX_DEPTH;
+	}
+
+	diff = bng_re_get_diff(uctx, rdev->chip_ctx);
+	entries = bng_re_init_depth(entries + diff + 1, uctx);
+	sq->max_wqe = min_t(u32, entries, dev_attr->max_sq_wqes + diff + 1);
+	sq->q_full_delta = diff + 1;
+	/*
+	 * Reserving one slot for Phantom WQE. Application can
+	 * post one extra entry in this case. But allowing this to avoid
+	 * unexpected Queue full condition
+	 */
+	sp_qp->sq.q_full_delta -= 1;
+	sp_qp->sq.sg_info.pgsize = PAGE_SIZE;
+	sp_qp->sq.sg_info.pgshft = PAGE_SHIFT;
+
+	return 0;
+}
+
+static int bng_re_init_user_qp(struct bng_re_dev *rdev, struct bng_re_pd *pd,
+			       struct bng_re_qp *qp, struct ib_udata *udata)
+{
+	struct bng_re_qp_req ureq = {};
+	struct bng_re_sg_info *sginfo;
+	struct bng_re_ucontext *cntx;
+	struct ib_ucontext *context;
+	struct bng_sp_qp *sp_qp;
+	struct ib_umem *umem;
+	int rc, bytes = 0;
+
+	sp_qp = &qp->sp_qp;
+	context = pd->ib_pd.uobject->context;
+	cntx = to_bng_re(context, struct bng_re_ucontext, ib_uctx);
+	sginfo = &sp_qp->sq.sg_info;
+
+	if (udata) {
+		if (udata->inlen < sizeof(ureq))
+			dev_warn_once(rdev_to_dev(rdev),
+				      "Update the library ulen %d klen %d",
+				      (unsigned int)udata->inlen,
+				      (unsigned int)sizeof(ureq));
+		rc = ib_copy_from_udata(&ureq, udata, min(udata->inlen, sizeof(ureq)));
+		if (rc)
+			return rc;
+	}
+
+	bytes = (sp_qp->sq.max_wqe * sp_qp->sq.wqe_size);
+	bytes = PAGE_ALIGN(bytes);
+
+	umem = ib_umem_get_va(&rdev->ibdev, ureq.qpsva, bytes,
+			      IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(umem)) {
+		dev_err(rdev_to_dev(rdev), "%s: ib_umem_get_va failed with %ld\n",
+			__func__, PTR_ERR(umem));
+		return PTR_ERR(umem);
+	}
+
+	qp->sumem = umem;
+	sginfo->npages = ib_umem_num_dma_blocks(umem, PAGE_SIZE);
+	sginfo->umem = umem;
+	sp_qp->qp_handle = ureq.qp_handle;
+
+	if (!qp->sp_qp.srq) {
+		sginfo = &sp_qp->rq.sg_info;
+		bytes = (sp_qp->rq.max_wqe * sp_qp->rq.wqe_size);
+		bytes = PAGE_ALIGN(bytes);
+		umem = ib_umem_get_va(&rdev->ibdev, ureq.qprva, bytes,
+				      IB_ACCESS_LOCAL_WRITE);
+		if (IS_ERR(umem)) {
+			dev_err(rdev_to_dev(rdev),
+				"%s: ib_umem_get_va failed ret =%ld\n",
+				__func__, PTR_ERR(umem));
+			goto rq_fail;
+		}
+		qp->rumem = umem;
+		sp_qp->rq.sg_info.umem = umem;
+		sginfo->npages = ib_umem_num_dma_blocks(umem, PAGE_SIZE);
+		sginfo->umem = umem;
+	}
+
+	sp_qp->dpi = &cntx->dpi;
+	sp_qp->is_user = true;
+
+	return 0;
+rq_fail:
+	ib_umem_release(qp->sumem);
+	qp->sumem = NULL;
+	sp_qp->sq.sg_info.umem = NULL;
+
+	return PTR_ERR(umem);
+}
+
+static int bng_re_init_qp_attr(struct bng_re_qp *qp, struct bng_re_pd *pd,
+			       struct ib_qp_init_attr *init_attr, struct ib_udata *udata)
+{
+	struct bng_re_ucontext *cntx = NULL;
+	struct bng_re_dev_attr *dev_attr;
+	struct ib_ucontext *context;
+	struct bng_sp_qp *sp_qp;
+	struct bng_re_dev *rdev;
+	struct bng_re_cq *cq;
+	int rc = 0, qptype;
+
+	rdev = qp->rdev;
+	sp_qp = &qp->sp_qp;
+	dev_attr = rdev->dev_attr;
+
+	sp_qp->vf_idx = INVALID_VF_IDX;
+
+	if (udata) {
+		context = pd->ib_pd.uobject->context;
+		cntx = to_bng_re(context, struct bng_re_ucontext, ib_uctx);
+	}
+
+	sp_qp->is_user = udata ? true : false;
+	sp_qp->pd = &pd->sp_pd;
+	sp_qp->qp_handle = (u64)sp_qp;
+	sp_qp->max_inline_data = init_attr->cap.max_inline_data;
+	sp_qp->sig_type = init_attr->sq_sig_type == IB_SIGNAL_ALL_WR;
+	qptype = bng_re_init_qp_type(rdev, init_attr);
+	if (qptype < 0) {
+		rc = qptype;
+		goto out;
+	}
+	sp_qp->type = (u8)qptype;
+	sp_qp->wqe_mode = bng_re_init_qp_wqe_mode(rdev);
+	ether_addr_copy(sp_qp->smac, rdev->netdev->dev_addr);
+
+	if (init_attr->qp_type == IB_QPT_RC) {
+		sp_qp->max_rd_atomic = dev_attr->max_qp_rd_atom;
+		sp_qp->max_dest_rd_atomic = dev_attr->max_qp_init_rd_atom;
+	}
+	sp_qp->mtu = ib_mtu_enum_to_int(iboe_get_mtu(rdev->netdev->mtu));
+	sp_qp->dpi = &rdev->dpi_privileged;
+	if (init_attr->create_flags) {
+		ibdev_dbg(&rdev->ibdev,
+			  "QP create flags 0x%x not supported",
+			  init_attr->create_flags);
+		return -EOPNOTSUPP;
+	}
+
+	/* Setup CQs */
+	if (init_attr->send_cq) {
+		cq = to_bng_re(init_attr->send_cq, struct bng_re_cq, ib_cq);
+		if (!cq) {
+			dev_err(rdev_to_dev(rdev), "Send CQ not found");
+			rc = -EINVAL;
+			goto out;
+		}
+		sp_qp->scq = &cq->sp_cq;
+		qp->scq = cq;
+	}
+
+	if (init_attr->recv_cq) {
+		cq = to_bng_re(init_attr->recv_cq, struct bng_re_cq, ib_cq);
+		if (!cq) {
+			dev_err(rdev_to_dev(rdev), "Send CQ not found");
+			rc = -EINVAL;
+			goto out;
+		}
+		sp_qp->rcq = &cq->sp_cq;
+		qp->rcq = cq;
+	}
+
+	if ((init_attr->qp_type == IB_QPT_RC || init_attr->qp_type == IB_QPT_UC) &&
+	    (!sp_qp->scq || !sp_qp->rcq)) {
+		ibdev_err(&rdev->ibdev,
+			  "Create QP: RC/UC requires both send_cq and recv_cq\n");
+		return -EINVAL;
+	}
+
+	/* Setup RQ/SRQ */
+	rc = bng_re_init_rq_attr(qp, init_attr, cntx);
+	if (rc)
+		goto out;
+
+	/* Setup SQ */
+	rc = bng_re_init_sq_attr(qp, init_attr, cntx);
+	if (rc)
+		goto out;
+
+	if (udata) /* This will update DPI and qp_handle */
+		rc = bng_re_init_user_qp(rdev, pd, qp, udata);
+out:
+	return rc;
+}
+
+/*
+ * bng_re_create_qp_stage1
+ *
+ * Return: 0 on success, negative errno on failure (all partial allocations unwound).
+ */
+static int bng_re_create_qp_stage1(struct bng_re_res *res, struct bng_re_qp *qp)
+{
+	struct bng_re_rcfw *rcfw;
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_sp_qp *fp = &qp->sp_qp;
+	struct bng_re_q *sq = &fp->sq;
+	struct bng_re_q *rq = &fp->rq;
+	u32 tbl_indx;
+	struct bng_re_reftbl *tbl;
+	u32 sqsz;
+	int vf_id = 0;
+	int xid_out = 0;
+	int rc;
+	u32 qp_idx;
+	unsigned long flag;
+
+	if (!res || !res->pdev || !res->rcfw)
+		return -EINVAL;
+	rcfw = res->rcfw;
+	if (!rcfw->qp_tbl || rcfw->qp_tbl_size < 3) {
+		dev_err(&res->pdev->dev,
+			"Stage1: RCFW qp_tbl missing or too small (size=%d)\n",
+			rcfw->qp_tbl_size);
+		return -ENODEV;
+	}
+	if (!fp->dpi || !fp->dpi->dbr) {
+		dev_err(&res->pdev->dev, "Stage1: QP DPI / doorbell not initialized\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(&res->pdev->dev,
+		"MPC: Stage1 enter type=%u srq=%d wqe_mode=%u rq_max_wqe=%u qp_tbl_sz=%d dpi=%u\n",
+		fp->type, fp->srq ? 1 : 0, fp->wqe_mode,
+		fp->srq ? 0U : rq->max_wqe, rcfw->qp_tbl_size,
+		fp->dpi ? fp->dpi->dpi : 0U);
+
+	fp->cctx = res->cctx;
+	fp->flags = 0;
+	sq->dbinfo.flags = 0;
+
+	hwq_attr.res = res;
+	hwq_attr.sginfo = &sq->sg_info;
+	hwq_attr.stride = sizeof(struct sq_sge);
+	hwq_attr.depth = bng_re_get_depth(sq, true);
+	/* Thor3: no SQ aux ring for retransmission metadata */
+	hwq_attr.aux_stride = 0;
+	hwq_attr.aux_depth = 0;
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+
+	rc = bng_re_alloc_init_hwq(&sq->hwq, &hwq_attr);
+	if (rc) {
+		dev_dbg(&res->pdev->dev, "MPC: Stage1 SQ hwq alloc failed rc=%d\n", rc);
+		goto exit;
+	}
+
+	sqsz = bng_re_set_sq_size(sq);
+	sq->max_sw_wqe = sqsz;
+	if (!sqsz || sqsz > BNG_RE_MAX_SQSZ) {
+		dev_err(&res->pdev->dev,
+			"bng_re: Stage1 SQ size %u invalid (max %u)\n",
+			sqsz, BNG_RE_MAX_SQSZ);
+		rc = -EINVAL;
+		goto fail_sq;
+	}
+
+	if (!fp->srq) {
+		rq->dbinfo.flags = 0;
+		hwq_attr.res = res;
+		hwq_attr.sginfo = &rq->sg_info;
+		hwq_attr.stride = sizeof(struct sq_sge);
+		hwq_attr.depth = bng_re_get_depth(rq, false);
+		hwq_attr.aux_stride = 0;
+		hwq_attr.aux_depth = 0;
+		hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 RQ hwq depth=%u max_wqe=%u wqe_sz=%u\n",
+			hwq_attr.depth, rq->max_wqe, rq->wqe_size);
+		rc = bng_re_alloc_init_hwq(&rq->hwq, &hwq_attr);
+		if (rc) {
+			dev_dbg(&res->pdev->dev,
+				"MPC: Stage1 RQ hwq alloc failed rc=%d\n", rc);
+			goto fail_sq;
+		}
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 RQ hwq ok max_elems=%u is_user=%d\n",
+			rq->hwq.max_elements, rq->hwq.is_user);
+	} else {
+		dev_dbg(&res->pdev->dev, "MPC: Stage1 skip RQ hwq (SRQ)\n");
+	}
+
+	if (!sq->hwq.is_user) {
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 kernel SWQ path max_sw_wqe=%u\n", sq->max_sw_wqe);
+		rc = bng_re_alloc_init_swq(sq);
+		if (rc) {
+			dev_dbg(&res->pdev->dev,
+				"MPC: Stage1 SQ swq alloc failed rc=%d\n", rc);
+			goto swq_sq;
+		}
+		if (!fp->srq) {
+			rc = bng_re_alloc_init_swq(rq);
+			if (rc) {
+				dev_dbg(&res->pdev->dev,
+					"MPC: Stage1 RQ swq alloc failed rc=%d\n", rc);
+				goto swq_rq;
+			}
+		}
+	} else {
+		dev_dbg(&res->pdev->dev, "MPC: Stage1 skip kernel SWQ (user SQ)\n");
+	}
+
+	rc = bng_re_qp_alloc_xid_and_iqm(res, fp->type, 1, sq->max_sw_wqe,
+					 vf_id, &qp->iqm_res, &xid_out);
+	if (!rc)
+		fp->id = (u32)xid_out;
+	if (rc) {
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 XID/VF path failed rc=%d (no fp->id assign)\n", rc);
+		goto swq_rq;
+	}
+
+	fp->cur_qp_state = CMDQ_MODIFY_QP_NEW_STATE_RESET;
+	INIT_LIST_HEAD(&fp->sq_flush);
+	INIT_LIST_HEAD(&fp->rq_flush);
+
+	sq->dbinfo.hwq = &sq->hwq;
+	sq->dbinfo.xid = fp->id;
+	sq->dbinfo.db = fp->dpi->dbr;
+	sq->dbinfo.max_slot = bng_re_set_sq_max_slot(fp->wqe_mode);
+	sq->dbinfo.flags = 0;
+	spin_lock_init(&sq->dbinfo.lock);
+	sq->dbinfo.seed = fp->id;
+	sq->dbinfo.res = res;
+	sq->dbinfo.is_l2 = false;
+
+	if (rq->max_wqe) {
+		rq->dbinfo.hwq = &rq->hwq;
+		rq->dbinfo.xid = fp->id;
+		rq->dbinfo.db = fp->dpi->dbr;
+		rq->dbinfo.max_slot = bng_re_set_rq_max_slot(rq->wqe_size);
+		rq->dbinfo.flags = 0;
+		spin_lock_init(&rq->dbinfo.lock);
+		rq->dbinfo.seed = fp->id;
+		rq->dbinfo.res = res;
+		rq->dbinfo.is_l2 = false;
+	}
+
+	tbl = &res->reftbl.qpref;
+	qp_idx = map_qp_id_to_reftbl_indx(fp->id, tbl);
+	spin_lock_irqsave(&tbl->lock, flag);
+	tbl->rec[qp_idx].xid = fp->id;
+	tbl->rec[qp_idx].handle = fp;
+	spin_unlock_irqrestore(&tbl->lock, flag);
+
+	if (fp->type == CMDQ_CREATE_QP_TYPE_RC) {
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 ok id=%u tbl=%u IQM irrq=%#x sz=%u orrq=%#x msn=%#x\n",
+			fp->id, tbl_indx, qp->iqm_res.irrq_addr, qp->iqm_res.irrq_size,
+			qp->iqm_res.orrq_addr, qp->iqm_res.msn_addr);
+	} else {
+		dev_dbg(&res->pdev->dev,
+			"MPC: Stage1 ok id=%u tbl=%u type=%u (no RC IQM dump)\n",
+			fp->id, tbl_indx, fp->type);
+	}
+
+	return 0;
+
+swq_rq:
+	kvfree(sq->swq);
+	sq->swq = NULL;
+	if (!fp->srq) {
+		kvfree(rq->swq);
+		rq->swq = NULL;
+		bng_re_free_hwq(res, &rq->hwq);
+	}
+	goto fail_sq;
+swq_sq:
+	if (!fp->srq)
+		bng_re_free_hwq(res, &rq->hwq);
+fail_sq:
+	bng_re_free_hwq(res, &sq->hwq);
+exit:
+	if (rc)
+		dev_dbg(&res->pdev->dev, "MPC: Stage1 fail exit rc=%d\n", rc);
+	return rc;
+}
+
+static enum ib_qp_state bng_re_cmdq_new_state_to_ib(u8 state)
+{
+	switch (state) {
+	case CMDQ_MODIFY_QP_NEW_STATE_RESET:
+		return IB_QPS_RESET;
+	case CMDQ_MODIFY_QP_NEW_STATE_INIT:
+		return IB_QPS_INIT;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTR:
+		return IB_QPS_RTR;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTS:
+		return IB_QPS_RTS;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQD:
+		return IB_QPS_SQD;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQE:
+		return IB_QPS_SQE;
+	case CMDQ_MODIFY_QP_NEW_STATE_ERR:
+	default:
+		return IB_QPS_ERR;
+	}
+}
+
+int bng_re_query_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
+		    int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
+{
+	struct bng_re_qp *qp = to_bng_re(ib_qp, struct bng_re_qp, ib_qp);
+	struct bng_re_dev *rdev = qp->rdev;
+	struct bng_sp_qp *sp_qp;
+	bool is_alloced = false;
+	int rc = 0;
+
+	if (rdev->bng_res.qp_xids &&
+	    (!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags))) {
+		sp_qp = &qp->sp_qp;
+	} else {
+		sp_qp = kcalloc(1, sizeof(*sp_qp), GFP_KERNEL);
+		if (!sp_qp)
+			return -ENOMEM;
+		is_alloced = true;
+		sp_qp->id = qp->sp_qp.id;
+		sp_qp->ah.host_sgid_index = qp->sp_qp.ah.host_sgid_index;
+
+		rc = bng_sp_query_qp(&rdev->bng_res, sp_qp);
+		if (rc) {
+			dev_err(rdev_to_dev(rdev), "Query HW QP (0x%x) failed! rc = %d",
+				sp_qp->id, rc);
+			goto free_mem;
+		}
+	}
+	qp_attr->qp_state = bng_re_cmdq_new_state_to_ib(sp_qp->state);
+	qp_attr->cur_qp_state = bng_re_cmdq_new_state_to_ib(sp_qp->cur_qp_state);
+	qp_attr->en_sqd_async_notify = sp_qp->en_sqd_async_notify ? 1 : 0;
+	qp_attr->qp_access_flags = __qp_access_flags_to_ib(0,
+							   sp_qp->access);
+	qp_attr->pkey_index = sp_qp->pkey_index;
+	qp_attr->qkey = sp_qp->qkey;
+	qp_attr->ah_attr.type = RDMA_AH_ATTR_TYPE_ROCE;
+	memcpy(qp_attr->ah_attr.grh.dgid.raw, sp_qp->ah.dgid.data,
+	       sizeof(sp_qp->ah.dgid.data));
+	qp_attr->ah_attr.grh.flow_label = sp_qp->udp_sport;
+	qp_attr->ah_attr.grh.sgid_index = sp_qp->ah.host_sgid_index;
+	qp_attr->ah_attr.grh.hop_limit = sp_qp->ah.hop_limit;
+	qp_attr->ah_attr.grh.traffic_class = sp_qp->ah.traffic_class;
+	qp_attr->ah_attr.sl = sp_qp->ah.sl;
+	qp_attr->path_mtu = __to_ib_mtu(sp_qp->path_mtu);
+	qp_attr->timeout = sp_qp->timeout;
+	qp_attr->retry_cnt = sp_qp->retry_cnt;
+	qp_attr->rnr_retry = sp_qp->rnr_retry;
+	qp_attr->min_rnr_timer = sp_qp->min_rnr_timer;
+	qp_attr->port_num = __to_ib_port_num(sp_qp->port_id);
+	qp_attr->rq_psn = sp_qp->rq.psn;
+	qp_attr->max_rd_atomic = sp_qp->max_rd_atomic;
+	qp_attr->sq_psn = sp_qp->sq.psn;
+	qp_attr->max_dest_rd_atomic = sp_qp->max_dest_rd_atomic;
+	qp_init_attr->sq_sig_type = sp_qp->sig_type ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
+	qp_attr->dest_qp_num = sp_qp->dest_qpn;
+
+	qp_attr->cap.max_send_wr = qp->sp_qp.sq.max_wqe;
+	qp_attr->cap.max_send_sge = qp->sp_qp.sq.max_sge;
+	qp_attr->cap.max_recv_wr = qp->sp_qp.rq.max_wqe;
+	qp_attr->cap.max_recv_sge = qp->sp_qp.rq.max_sge;
+	qp_attr->cap.max_inline_data = sp_qp->max_inline_data;
+	qp_init_attr->cap = qp_attr->cap;
+
+free_mem:
+	if (is_alloced)
+		kfree(sp_qp);
+	return rc;
+}
+
+int bng_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
+		     struct ib_udata *udata)
+{
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_re_qp_resp resp;
+	struct bng_re_dev *rdev;
+	struct bng_re_pd *pd;
+	struct bng_re_qp *qp;
+	struct ib_pd *ib_pd;
+	int rc;
+
+	ib_pd = ib_qp->pd;
+	pd = container_of(ib_pd, struct bng_re_pd, ib_pd);
+	rdev = pd->rdev;
+	dev_attr = rdev->dev_attr;
+	qp = container_of(ib_qp, struct bng_re_qp, ib_qp);
+
+	rc = bng_re_test_qp_limits(rdev, qp_init_attr, dev_attr);
+	if (!rc) {
+		rc = -EINVAL;
+		goto fail;
+	}
+
+	qp->rdev = rdev;
+	rc = bng_re_init_qp_attr(qp, pd, qp_init_attr, udata);
+	if (rc)
+		goto fail;
+
+	rc = bng_re_create_qp_stage1(&rdev->bng_res, qp);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to create HW QP (stage1 / XID prep)");
+		goto free_umem;
+	}
+	if (bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx))
+		qp->sp_qp.rtr_transition_pending = true;
+
+	if (udata) {
+		resp.qpid = qp->sp_qp.id;
+		resp.rsvd = 0;
+		if (udata->outlen < sizeof(resp)) {
+			ibdev_err(&rdev->ibdev,
+				  "create_qp: udata outlen %zu < sizeof(bng_re_qp_resp) %zu\n",
+				  udata->outlen, sizeof(resp));
+			rc = -EINVAL;
+			goto free_umem;
+		}
+		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		if (rc) {
+			ibdev_err(&rdev->ibdev,
+				  "create_qp: ib_copy_to_udata failed rc=%d qpid=%u outlen=%zu\n",
+				  rc, resp.qpid, udata->outlen);
+			goto free_umem;
+		}
+	}
+
+	qp->ib_qp.qp_num = qp->sp_qp.id;
+	if (qp_init_attr->qp_type == IB_QPT_GSI)
+		rdev->gsi_ctx.gsi_qp = qp;
+	spin_lock_init(&qp->sq_lock);
+	spin_lock_init(&qp->rq_lock);
+	INIT_LIST_HEAD(&qp->list);
+	mutex_lock(&rdev->qp_lock);
+	list_add_tail(&qp->list, &rdev->qp_list);
+	mutex_unlock(&rdev->qp_lock);
+
+	return 0;
+free_umem:
+	bng_re_free_qp_res(&rdev->bng_res, &qp->sp_qp);
+	ib_umem_release(qp->rumem);
+	ib_umem_release(qp->sumem);
+fail:
+	return rc;
+}
+
+static unsigned long bng_re_lock_cqs(struct bng_re_qp *qp)
+	__acquires(&qp->scq->cq_lock) __acquires(&qp->rcq->cq_lock)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->scq->cq_lock, flags);
+	if (qp->rcq != qp->scq)
+		spin_lock(&qp->rcq->cq_lock);
+	else
+		__acquire(&qp->rcq->cq_lock);
+
+	return flags;
+}
+
+static void bng_re_unlock_cqs(struct bng_re_qp *qp, unsigned long flags)
+	__releases(&qp->scq->cq_lock) __releases(&qp->rcq->cq_lock)
+{
+	if (qp->rcq != qp->scq)
+		spin_unlock(&qp->rcq->cq_lock);
+	else
+		__release(&qp->rcq->cq_lock);
+	spin_unlock_irqrestore(&qp->scq->cq_lock, flags);
+}
+
+static u8 __from_ib_qp_state(enum ib_qp_state state)
+{
+	switch (state) {
+	case IB_QPS_RESET:
+		return CMDQ_MODIFY_QP_NEW_STATE_RESET;
+	case IB_QPS_INIT:
+		return CMDQ_MODIFY_QP_NEW_STATE_INIT;
+	case IB_QPS_RTR:
+		return CMDQ_MODIFY_QP_NEW_STATE_RTR;
+	case IB_QPS_RTS:
+		return CMDQ_MODIFY_QP_NEW_STATE_RTS;
+	case IB_QPS_SQD:
+		return CMDQ_MODIFY_QP_NEW_STATE_SQD;
+	case IB_QPS_SQE:
+		return CMDQ_MODIFY_QP_NEW_STATE_SQE;
+	case IB_QPS_ERR:
+	default:
+		return CMDQ_MODIFY_QP_NEW_STATE_ERR;
+	}
+}
+
+static int bng_re_copy_to_udata(struct bng_re_dev *rdev, void *data,
+				int len, struct ib_udata *udata)
+{
+	int rc;
+
+	rc = ib_copy_to_udata(udata, data, len);
+	if (rc)
+		dev_err(rdev_to_dev(rdev),
+			"ucontext copy failed from %ps rc %d",
+			__builtin_return_address(0), rc);
+
+	return rc;
+}
+
+static u8 __qp_access_flags_from_ib(struct bng_re_chip_ctx *cctx, int iflags)
+{
+	u8 qflags = 0;
+
+	if (iflags & IB_ACCESS_LOCAL_WRITE)
+		qflags |= CMDQ_MODIFY_QP_ACCESS_LOCAL_WRITE;
+	if (iflags & IB_ACCESS_REMOTE_WRITE)
+		qflags |= CMDQ_MODIFY_QP_ACCESS_REMOTE_WRITE;
+	if (iflags & IB_ACCESS_REMOTE_READ)
+		qflags |= CMDQ_MODIFY_QP_ACCESS_REMOTE_READ;
+	if (iflags & IB_ACCESS_REMOTE_ATOMIC)
+		qflags |= CMDQ_MODIFY_QP_ACCESS_REMOTE_ATOMIC;
+
+	return qflags;
+}
+
+static void bng_re_update_qp_addr(struct bng_re_dev *rdev, struct bng_re_qp *qp)
+{
+	/* User-space can extract ip address with sgid_index. */
+	if (ipv6_addr_v4mapped((struct in6_addr *)&qp->sp_qp.ah.dgid)) {
+		qp->qp_info_entry.s_ip.ipv4_addr = ipv4_from_gid(qp->qp_info_entry.sgid.raw);
+		qp->qp_info_entry.d_ip.ipv4_addr = ipv4_from_gid(qp->sp_qp.ah.dgid.data);
+	} else {
+		memcpy(&qp->qp_info_entry.s_ip.ipv6_addr, qp->qp_info_entry.sgid.raw,
+		       sizeof(qp->qp_info_entry.s_ip.ipv6_addr));
+		memcpy(&qp->qp_info_entry.d_ip.ipv6_addr, qp->sp_qp.ah.dgid.data,
+		       sizeof(qp->qp_info_entry.d_ip.ipv6_addr));
+	}
+}
+
+static u16 get_source_port(struct bng_re_dev *rdev, struct bng_re_qp *qp)
+{
+	u8 ip_off, data[48], smac[ETH_ALEN];
+	u16 crc = 0, buf_len = 0, i;
+	u8 addr_len;
+	u32 qpn;
+
+	if (qp->sp_qp.nw_type == CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV6) {
+		addr_len = 16;
+		ip_off = 0;
+	} else {
+		addr_len = 4;
+		ip_off = 12;
+	}
+
+	memcpy(smac, qp->sp_qp.smac, ETH_ALEN);
+
+	memset(data, 0, 48);
+	memcpy(data, qp->sp_qp.ah.dmac, ETH_ALEN);
+	buf_len += ETH_ALEN;
+
+	memcpy(data + buf_len, smac, ETH_ALEN);
+	buf_len += ETH_ALEN;
+
+	memcpy(data + buf_len, qp->sp_qp.ah.dgid.data + ip_off, addr_len);
+	buf_len += addr_len;
+
+	memcpy(data + buf_len, qp->qp_info_entry.sgid.raw + ip_off, addr_len);
+	buf_len += addr_len;
+
+	qpn = htonl(qp->sp_qp.dest_qpn);
+	memcpy(data + buf_len, (u8 *)&qpn + 1, 3);
+	buf_len += 3;
+
+	for (i = 0; i < buf_len; i++)
+		crc = crc16(crc, (data + i), 1);
+
+	crc |= 0xc000;
+
+	return crc;
+}
+
+static void bng_re_update_qp_info(struct bng_re_dev *rdev, struct bng_re_qp *qp)
+{
+	u16 type;
+
+	type = __from_hw_to_ib_qp_type(qp->sp_qp.type);
+	bng_re_update_qp_addr(rdev, qp);
+
+	if ((type == IB_QPT_RC ||
+	    (!BNG_RE_UDP_SP_WQE(qp->sp_qp.dev_cap_ext_flags2))) &&
+	    (qp->sp_qp.nw_type == CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV4 ||
+	    qp->sp_qp.nw_type == CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV6)) {
+		qp->qp_info_entry.s_port = get_source_port(rdev, qp);
+	}
+	qp->qp_info_entry.d_port = BNG_RE_QP_DEST_PORT;
+}
+
+static int bng_re_update_ah_dscp_sl(struct bng_re_qp *qp, struct ib_qp_attr *qp_attr)
+{
+	struct bng_re_dev *rdev = qp->rdev;
+	bool dscp_valid = false;
+	bool pcp_valid = false;
+	u8 cos, dscp_pri = 0;
+	u8 dscp;
+	u8 i, j;
+	u8 pri;
+
+	/*
+	 * The traffic class passed by the applications
+	 * contains both dscp and ecn values. DSCP is
+	 * upper six bits of the traffic class.
+	 */
+
+	dscp = qp_attr->ah_attr.grh.traffic_class >> 2;
+	pri = rdma_ah_get_sl(&qp_attr->ah_attr);
+	qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_VLAN_ID;
+
+	if (!dscp && !pri)
+		goto default_queue;
+
+	if (dscp) {
+		for (i = 0; i < rdev->d2p_count; i++) {
+			if (rdev->d2p[i].dscp == dscp) {
+				dscp_pri = rdev->d2p[i].pri;
+				cos = rdev->p2cos[dscp_pri];
+				for (j = 0; j < rdev->lossless_q_count; j++) {
+					if (cos == rdev->lossless_qid[j]) {
+						dscp_valid = true;
+						break;
+					}
+				}
+			}
+	}
+
+		if (dscp_valid) {
+			qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_TRAFFIC_CLASS;
+			qp->sp_qp.ah.traffic_class = dscp;
+			qp->sp_qp.ah.sl = dscp_pri;
+			return 0;
+		}
+	}
+	if (pri) {
+		cos = rdev->p2cos[pri];
+		for (j = 0; j < rdev->lossless_q_count; j++) {
+			if (cos == rdev->lossless_qid[j]) {
+				pcp_valid = true;
+				break;
+			}
+		}
+		if (pcp_valid) {
+			qp->sp_qp.ah.sl = qp_attr->ah_attr.sl;
+			qp->sp_qp.ah.traffic_class = 0;
+			return 0;
+		}
+	}
+	if (!dscp_valid && !pcp_valid) {
+		dev_warn_ratelimited(rdev_to_dev(qp->rdev),
+				     "Given DSCP %d and/or SL %d not mapping to lossless queue",
+				     dscp, pri);
+		dev_warn_ratelimited(rdev_to_dev(qp->rdev),
+				     "Changing to default roce traffic class DSCP %d and SL %d",
+				     rdev->tc_rec[0].roce_dscp, rdev->tc_rec[0].roce_prio);
+	}
+
+default_queue:
+	qp->sp_qp.ah.traffic_class = rdev->tc_rec[0].roce_dscp;
+	qp->sp_qp.ah.sl = rdev->tc_rec[0].roce_prio;
+	return 0;
+}
+
+static void bng_re_handle_cqn(struct bng_sp_cq *cq)
+{
+	struct bng_re_nq *nq;
+
+	if (!(cq && cq->nq))
+		return;
+
+	nq = cq->nq;
+	spin_lock_bh(&cq->compl_lock);
+	if (nq->cqn_handler) {
+		dev_dbg(&nq->res->pdev->dev, "%s:Trigger cq  = %p event nq = %p\n",
+			__func__, cq, nq);
+		nq->cqn_handler(nq, cq);
+	}
+	spin_unlock_bh(&cq->compl_lock);
+}
+
+static void bng_re_manage_flush_qp(struct bng_re_qp *qp)
+{
+	struct bng_re_q *rq, *sq;
+	struct bng_re_dev *rdev;
+	unsigned long flags;
+
+	if (qp->sumem)
+		return;
+
+	rdev = qp->rdev;
+
+	if (qp->sp_qp.state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
+		rq = &qp->sp_qp.rq;
+		sq = &qp->sp_qp.sq;
+
+		dev_dbg(rdev_to_dev(rdev),
+			"Move QP = %p to flush list\n", qp);
+		flags = bng_re_lock_cqs(qp);
+		bng_re_add_flush_qp(&qp->sp_qp);
+		bng_re_unlock_cqs(qp, flags);
+
+		if (sq->hwq.prod != sq->hwq.cons)
+			bng_re_handle_cqn(&qp->scq->sp_cq);
+
+		if (qp->rcq && qp->rcq != qp->scq &&
+		    rq->hwq.prod != rq->hwq.cons)
+			bng_re_handle_cqn(&qp->rcq->sp_cq);
+	}
+
+	if (qp->sp_qp.state == CMDQ_MODIFY_QP_NEW_STATE_RESET) {
+		dev_dbg(rdev_to_dev(rdev),
+			"Move QP = %p out of flush list\n", qp);
+		flags = bng_re_lock_cqs(qp);
+		bng_re_clean_qp(&qp->sp_qp);
+		bng_re_unlock_cqs(qp, flags);
+	}
+}
+
+static void bng_post_recv_db(struct bng_sp_qp *qp)
+{
+	struct bng_re_q *rq = &qp->rq;
+
+	if (unlikely(qp->cur_qp_state != CMDQ_MODIFY_QP_NEW_STATE_INIT))
+		bng_ring_prod_db(&rq->dbinfo, DBC_DBC_TYPE_RQ);
+}
+
+static bool bng_re_is_qp_valid(struct bng_re_res  *res, struct bng_sp_qp *qp)
+{
+	bool is_valid = false;
+
+	if (qp) {
+		if (!res->is_vf) {
+			/*Chk if the QP ID is valid*/
+			is_valid = bng_re_xm_is_id_allocated(res->qp_xids, qp->id);
+		} else {
+			/*revisit for vf*/
+			is_valid = true;
+		}
+	}
+	return is_valid;
+}
+
+int bng_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
+		     int qp_attr_mask, struct ib_udata *udata)
+{
+	struct bng_re_qp *qp = container_of(ib_qp, struct bng_re_qp, ib_qp);
+	enum ib_qp_state curr_qp_state, new_qp_state;
+	struct bng_re_modify_qp_ex_resp resp = {};
+	struct bng_re_modify_qp_ex_req ureq = {};
+	struct bng_re_dev *rdev = qp->rdev;
+	struct bng_re_dev_attr *dev_attr;
+	union ib_gid *gid_ptr = NULL;
+	int rc, entries, status;
+	bool update_fw = true;
+	unsigned long flags;
+	u8 nw_type;
+
+	dev_attr = rdev->dev_attr;
+
+	if (qp_attr_mask & ~IB_QP_ATTR_STANDARD_BITS)
+		return -EOPNOTSUPP;
+
+	if (!bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx))
+		qp->sp_qp.modify_flags = 0;
+
+	qp->sp_qp.udcc_exclude = true;
+
+	if (udata && ib_copy_from_udata(&ureq, udata, sizeof(ureq))) {
+		dev_err(rdev_to_dev(rdev), "qp %#x udata copy failed",
+			qp->sp_qp.id);
+		return -EINVAL;
+	}
+
+	if (qp_attr_mask & IB_QP_STATE) {
+		curr_qp_state = bng_re_cmdq_new_state_to_ib(qp->sp_qp.cur_qp_state);
+		new_qp_state = qp_attr->qp_state;
+
+		if (bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx)) {
+			/* don't update fw; as we want to hold
+			 * the parameters until we move to rtr.
+			 *
+			 * Also- only reset the modify flags if we've at least
+			 *  sent the initial create; as we're accumulating flags until then
+			 */
+			if (qp->sp_qp.rtr_transition_pending && new_qp_state != IB_QPS_RTR)
+				update_fw = false;
+			else if (test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags))
+				qp->sp_qp.modify_flags = 0;
+		}
+
+		if (!ib_modify_qp_is_ok(curr_qp_state, new_qp_state,
+					ib_qp->qp_type, qp_attr_mask)) {
+			ibdev_err(&rdev->ibdev,
+				  "Invalid attribute mask: %#x specified ",
+				  qp_attr_mask);
+			ibdev_err(&rdev->ibdev,
+				  "for qpn: %#x type: %#x",
+				  ib_qp->qp_num, ib_qp->qp_type);
+			ibdev_err(&rdev->ibdev,
+				  "curr_qp_state=0x%x, new_qp_state=0x%x\n",
+				  curr_qp_state, new_qp_state);
+			return -EINVAL;
+		}
+
+		if (!bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx)) {
+			if (curr_qp_state == IB_QPS_RESET && new_qp_state == IB_QPS_RESET) {
+				if (!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT,
+				    &qp->sp_qp.flags)) {
+					dev_warn(rdev_to_dev(rdev),
+						 "%s -%s:%d,%s:0x%x,%s:0x%x,%s:0x%x,%s:0x%x,%s:0x%x\n",
+						 "FirstModify Not Sent: NoStateChange",
+						 "is_valid:",
+						 bng_re_is_qp_valid(&rdev->bng_res, &qp->sp_qp),
+								       "attribute mask:",
+								       qp_attr_mask,
+								       "qpn:",
+								       ib_qp->qp_num,
+								       "type:",
+								       ib_qp->qp_type,
+								       "current_qp_st",
+								       curr_qp_state,
+								       "new_qp_st",
+								       new_qp_state);
+					return 0;
+				}
+			}
+		}
+
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_STATE;
+		qp->sp_qp.state = __from_ib_qp_state(qp_attr->qp_state);
+
+		/* MTU settings allowed only during INIT -> RTR */
+		if (qp_attr->qp_state == IB_QPS_RTR &&
+		    qp->sp_qp.type != CMDQ_CREATE_QP_TYPE_GSI &&
+		    qp->sp_qp.type != CMDQ_CREATE_QP_TYPE_UD) {
+			rc = bng_re_init_qpmtu(qp, rdev->netdev->mtu, qp_attr_mask, qp_attr);
+			if (rc) {
+				dev_err(rdev_to_dev(rdev), "qp %#x invalid mtu %d\n",
+					qp->sp_qp.id, ib_mtu_enum_to_int(qp_attr->path_mtu));
+				return rc;
+			}
+		}
+		/*
+		 * if we're moving from init => rtr, then for non user and with posted
+		 *   rx buffers and not srq, set eq buffer coount
+		 */
+		if (bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx)) {
+			u32 indx;
+			struct bng_re_db_info *info;
+
+			if (!qp->sp_qp.is_user && !qp->sp_qp.srq &&
+			    new_qp_state == IB_QPS_RTR && qp->sp_qp.rq.hwq.prod) {
+				spin_lock_irqsave(&qp->rq_lock, flags);
+
+				info = &qp->sp_qp.rq.dbinfo;
+				indx = (((info->hwq->prod / info->max_slot) & DBC_DBC_INDEX_MASK) |
+						((info->flags & BNG_RE_FLAG_EPOCH_PROD_MASK) <<
+						BNG_RE_DB_EPOCH_PROD_SHIFT));
+
+				qp->sp_qp.req_buffer_count = indx;
+				spin_unlock_irqrestore(&qp->rq_lock, flags);
+			}
+		}
+	} else {
+		curr_qp_state = __to_ib_qp_state(qp->sp_qp.cur_qp_state);
+		new_qp_state = qp_attr->qp_state;
+
+		if (bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx)) {
+			/* don't update fw; as we want to hold
+			 * the parameters until we move to rtr.
+			 * Also- only reset the modify flags if we've at least
+			 *  sent the initial create; as we're accumulating flags until then
+			 */
+			if (qp->sp_qp.rtr_transition_pending && new_qp_state != IB_QPS_RTR)
+				update_fw = false;
+			else if (test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags))
+				qp->sp_qp.modify_flags = 0;
+		} else {
+			/* Fix me: we can't check new qp state if the
+			 * state modify bit is not set.
+			 */
+			/* Check First modify is sent */
+			if ((!test_bit(BNG_SP_QP_FLAG_MPC_INITIAL_CREATE_SENT, &qp->sp_qp.flags))) {
+				dev_warn(rdev_to_dev(rdev),
+					 "%s -%s:%d,%s:0x%x,%s:0x%x,%s:0x%x,%s:0x%x,%s:0x%x\n",
+					 "FirstModify Not Sent: NoStateChange",
+					 "is_valid:",
+					 bng_re_is_qp_valid(&rdev->bng_res, &qp->sp_qp),
+					 "attribute mask:",
+					 qp_attr_mask,
+					 "qpn:",
+					 ib_qp->qp_num,
+					 "type:",
+					 ib_qp->qp_type,
+					 "current_qp_st",
+					 curr_qp_state,
+					 "new_qp_st",
+					 new_qp_state);
+				return 0;
+			}
+		}
+	}
+
+	if (qp_attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_EN_SQD_ASYNC_NOTIFY;
+		qp->sp_qp.en_sqd_async_notify = true;
+	}
+	if (qp_attr_mask & IB_QP_ACCESS_FLAGS) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_ACCESS;
+		qp->sp_qp.access =
+			__qp_access_flags_from_ib(qp->sp_qp.cctx,
+						  qp_attr->qp_access_flags);
+		/* LOCAL_WRITE access must be set to allow RC receive */
+		qp->sp_qp.access |= CMDQ_MODIFY_QP_ACCESS_LOCAL_WRITE;
+	}
+	if (qp_attr_mask & IB_QP_PKEY_INDEX) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_PKEY;
+		qp->sp_qp.pkey_index = qp_attr->pkey_index;
+	}
+	if (qp_attr_mask & IB_QP_QKEY) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_QKEY;
+		qp->sp_qp.qkey = qp_attr->qkey;
+	}
+	if (qp_attr_mask & IB_QP_AV) {
+		const struct ib_global_route *grh =
+			rdma_ah_read_grh(&qp_attr->ah_attr);
+		const struct ib_gid_attr *sgid_attr;
+		struct bng_re_gid_ctx *ctx;
+
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_DGID |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_FLOW_LABEL |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_SGID_INDEX |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_HOP_LIMIT |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_TRAFFIC_CLASS |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_DEST_MAC |
+				     CMDQ_MODIFY_QP_MODIFY_MASK_VLAN_ID;
+		memcpy(qp->sp_qp.ah.dgid.data, qp_attr->ah_attr.grh.dgid.raw,
+		       sizeof(qp->sp_qp.ah.dgid.data));
+
+		qp->sp_qp.ah.flow_label = grh->flow_label;
+
+		sgid_attr = qp_attr->ah_attr.grh.sgid_attr;
+
+		/* Get the HW context of the GID. The reference
+		 * of GID table entry is already taken by the caller.
+		 */
+		ctx = rdma_read_gid_hw_context(sgid_attr);
+		qp->sp_qp.ah.sgid_index = ctx->idx;
+		qp->sp_qp.ah.host_sgid_index = grh->sgid_index;
+		qp->sp_qp.ah.hop_limit = grh->hop_limit;
+		qp->sp_qp.ah.traffic_class = grh->traffic_class >> 2;
+
+		status = bng_re_update_ah_dscp_sl(qp, qp_attr);
+		if (status) {
+			dev_err(rdev_to_dev(rdev), "%s: qp %d: error updating ah_dscp",
+				__func__, qp->sp_qp.id);
+			return status;
+		}
+
+		ether_addr_copy(qp->sp_qp.ah.dmac,
+				qp_attr->ah_attr.roce.dmac);
+
+		gid_ptr =  (union ib_gid *)&sgid_attr->gid;
+
+		if (!sgid_attr->ndev) {
+			dev_err(rdev_to_dev(rdev), "%s: qp %d: sgid_attr has no netdev",
+				__func__, qp->sp_qp.id);
+			return -ENODEV;
+		}
+
+		memcpy(qp->sp_qp.smac, sgid_attr->ndev->dev_addr, ETH_ALEN);
+
+		nw_type = rdma_gid_attr_network_type(sgid_attr);
+		switch (nw_type) {
+		case RDMA_NETWORK_IPV4:
+			qp->sp_qp.nw_type =
+					CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV4;
+			break;
+		case RDMA_NETWORK_IPV6:
+			qp->sp_qp.nw_type =
+					CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV2_IPV6;
+			break;
+		default:
+			qp->sp_qp.nw_type =
+					CMDQ_MODIFY_QP_NETWORK_TYPE_ROCEV1;
+			break;
+		}
+		memcpy(&qp->qp_info_entry.sgid, gid_ptr, sizeof(qp->qp_info_entry.sgid));
+		qp->sp_qp.udcc_exclude = true;
+	}
+
+	if (qp_attr_mask & IB_QP_TIMEOUT) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_TIMEOUT;
+		qp->sp_qp.timeout = qp_attr->timeout;
+	}
+	if (qp_attr_mask & IB_QP_RETRY_CNT) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_RETRY_CNT;
+		qp->sp_qp.retry_cnt = qp_attr->retry_cnt;
+	}
+	if (qp_attr_mask & IB_QP_RNR_RETRY) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_RNR_RETRY;
+		qp->sp_qp.rnr_retry = qp_attr->rnr_retry;
+	}
+	if (qp_attr_mask & IB_QP_MIN_RNR_TIMER) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_MIN_RNR_TIMER;
+		qp->sp_qp.min_rnr_timer = qp_attr->min_rnr_timer;
+	}
+	if (qp_attr_mask & IB_QP_RQ_PSN) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_RQ_PSN;
+		qp->sp_qp.rq.psn = qp_attr->rq_psn;
+	}
+	if (qp_attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_MAX_RD_ATOMIC;
+		/* Cap the max_rd_atomic to device max */
+		qp->sp_qp.max_rd_atomic = min_t(u32, qp_attr->max_rd_atomic,
+						dev_attr->max_qp_rd_atom);
+	}
+	if (qp_attr_mask & IB_QP_SQ_PSN) {
+		qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_SQ_PSN;
+		qp->sp_qp.sq.psn = qp_attr->sq_psn;
+	}
+	if (qp_attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
+		if (qp_attr->max_dest_rd_atomic >
+		    dev_attr->max_qp_init_rd_atom) {
+			ibdev_err(&rdev->ibdev,
+				  "max_dest_rd_atomic requested%d is > dev_max%d",
+				  qp_attr->max_dest_rd_atomic,
+				  dev_attr->max_qp_init_rd_atom);
+			return -EINVAL;
+		}
+
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_MAX_DEST_RD_ATOMIC;
+		qp->sp_qp.max_dest_rd_atomic = qp_attr->max_dest_rd_atomic;
+	}
+	if (qp_attr_mask & IB_QP_CAP) {
+		struct bng_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bng_re_ucontext, ib_uctx);
+
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_SQ_SIZE |
+				CMDQ_MODIFY_QP_MODIFY_MASK_RQ_SIZE |
+				CMDQ_MODIFY_QP_MODIFY_MASK_SQ_SGE |
+				CMDQ_MODIFY_QP_MODIFY_MASK_RQ_SGE |
+				CMDQ_MODIFY_QP_MODIFY_MASK_MAX_INLINE_DATA;
+		if (qp_attr->cap.max_send_wr >= dev_attr->max_sq_wqes ||
+		    qp_attr->cap.max_recv_wr >= dev_attr->max_rq_wqes ||
+		    qp_attr->cap.max_send_sge >= dev_attr->max_qp_sges ||
+		    qp_attr->cap.max_recv_sge >= dev_attr->max_qp_sges ||
+		    qp_attr->cap.max_inline_data >=
+						dev_attr->max_inline_data) {
+			ibdev_err(&rdev->ibdev,
+				  "Create QP failed - max exceeded");
+			return -EINVAL;
+		}
+		entries = bng_re_init_depth(qp_attr->cap.max_send_wr, uctx);
+
+		if (entries > dev_attr->max_sq_wqes)
+			entries = dev_attr->max_sq_wqes;
+		entries = min_t(u32, entries, dev_attr->max_sq_wqes);
+		qp->sp_qp.sq.max_wqe = entries;
+		qp->sp_qp.sq.q_full_delta = qp->sp_qp.sq.max_wqe - qp_attr->cap.max_send_wr;
+
+		/*
+		 * Reserving one slot for Phantom WQE. Some application can
+		 * post one extra entry in this case. Allowing this to avoid
+		 * unexpected Queue full condition
+		 */
+		qp->sp_qp.sq.q_full_delta -= 1;
+		qp->sp_qp.sq.max_sge = qp_attr->cap.max_send_sge;
+		if (qp->sp_qp.rq.max_wqe) {
+			entries = bng_re_init_depth(qp_attr->cap.max_recv_wr, uctx);
+			if (entries > dev_attr->max_rq_wqes)
+				entries = dev_attr->max_rq_wqes;
+			qp->sp_qp.rq.max_wqe = entries;
+			qp->sp_qp.rq.q_full_delta = qp->sp_qp.rq.max_wqe - qp_attr->cap.max_recv_wr;
+			qp->sp_qp.rq.max_sge = qp_attr->cap.max_recv_sge;
+		} else {
+			/* SRQ was used prior, just ignore the RQ caps */
+		}
+	}
+
+	if (qp_attr_mask & IB_QP_DEST_QPN) {
+		qp->sp_qp.modify_flags |=
+				CMDQ_MODIFY_QP_MODIFY_MASK_DEST_QP_ID;
+		qp->sp_qp.dest_qpn = qp_attr->dest_qp_num;
+	}
+
+	if (udata && (ureq.comp_mask & BNG_RE_COMP_MASK_REQ_BUFF_CNT)) {
+		qp->sp_qp.req_buffer_count = ureq.req_buffer_count;
+	} else {
+		dev_warn(rdev_to_dev(rdev),
+			 "QP %d : no req_buffer_count set in user data",
+			 qp->sp_qp.id);
+	}
+
+	if (update_fw) {
+		rc = bng_sp_mpc_modify_qp(&rdev->bng_res, &qp->sp_qp);
+	} else {
+		/* Transition the state ourselves if we're skipping the hw update */
+		if (qp_attr_mask & IB_QP_STATE)
+			qp->sp_qp.cur_qp_state = __from_ib_qp_state(new_qp_state);
+	}
+
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to modify HW QP");
+		return rc;
+	}
+
+	if (qp_attr_mask & IB_QP_STATE) {
+		/*
+		 * When the QP moves to INIT to RTR in the modify_qp
+		 * call, firmware has a workaround to update the context
+		 * field with CDUDMA read/write. During the QP INIT
+		 * state in the post_receive driver needs to ensure
+		 * no doorbell is rung to work this properly. And once
+		 * QP moves to RTR ring the doorbell if the producer
+		 * index is present.
+		 */
+		if (qp_attr->qp_state == IB_QPS_RTR && !qp->sp_qp.srq) {
+			if (qp->sp_qp.rq.hwq.prod) {
+				spin_lock_irqsave(&qp->rq_lock, flags);
+				bng_post_recv_db(&qp->sp_qp);
+				spin_unlock_irqrestore(&qp->rq_lock, flags);
+			}
+		}
+
+		if (bng_re_init_fw_state_rtr_enabled(rdev->chip_ctx)) {
+			/* Turn off rtr pending after we've transitioned to rtr; or,
+			 * ; when back to reset.
+			 */
+			if (qp_attr->qp_state == IB_QPS_RTR)
+				qp->sp_qp.rtr_transition_pending = false;
+			else if (qp_attr->qp_state == IB_QPS_RESET)
+				qp->sp_qp.rtr_transition_pending = true;
+		}
+
+		bng_re_manage_flush_qp(qp);
+	}
+
+	/*
+	 * Update info when qp_info_info
+	 */
+	bng_re_update_qp_info(rdev, qp);
+
+	if (udata) {
+		rc = bng_re_copy_to_udata(rdev, &resp,
+					  min(udata->outlen, sizeof(resp)),
+					  udata);
+		if (rc) {
+			dev_err(rdev_to_dev(rdev), "%s: qp:%d error copying user data:%d\n",
+				__func__, qp->sp_qp.id, rc);
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * qp_destroy_qp_mpc - destroy a QP w/mpc / rca
+ *
+ * @res: resource info
+ * @qp: qp to destroy
+ *
+ * Return: 0 for success, anything else; error
+ */
+static int qp_destroy_qp_mpc(struct bng_re_res *res, struct bng_re_qp *qp)
+{
+	int rc = 0;
+	bool xid_cleanup_handled = false;
+
+	/* Reset modify flags during QP destroy and set only the required mask */
+	qp->sp_qp.modify_flags = 0;
+	qp->sp_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_STATE;
+
+	/* Set state to RESET to take QP back to first state */
+	qp->sp_qp.state = CMDQ_MODIFY_QP_NEW_STATE_RESET;
+
+	if (test_bit(BNG_SP_QP_FLAG_MPC_ALLOW_QP_DESTROY, &qp->sp_qp.flags)) {
+		xid_cleanup_handled = false;
+		/* Set the QP Free flag for actual QP destroy */
+		set_bit(BNG_SP_QP_FLAG_MPC_QP_FREE, &qp->sp_qp.flags);
+		rc = bng_sp_fill_and_send_mpc_qp_modify(res, &qp, 1, &xid_cleanup_handled);
+	} else {
+		dev_warn(&res->pdev->dev,
+			 "MPC-skip destroy qp- not yet created to FW. id:%d.State:%d,%d\n",
+			 qp->sp_qp.id,
+			 qp->sp_qp.cur_qp_state,
+			 qp->sp_qp.state);
+	}
+
+	if (!xid_cleanup_handled && qp->sp_qp.id != 1 && !res->is_vf &&
+	    res->qp_xids) {
+		dev_warn(&res->pdev->dev,
+			 "MPC- pathological xid cleanup. id:%d.State:%d,%d, destroy_flag set:%d\n",
+			 qp->sp_qp.id,
+			 qp->sp_qp.cur_qp_state,
+			 qp->sp_qp.state,
+			 test_bit(BNG_SP_QP_FLAG_MPC_ALLOW_QP_DESTROY, &qp->sp_qp.flags));
+
+		bng_re_qp_free_xid_and_iqm(res, qp->sp_qp.type, (int)qp->sp_qp.id,
+					   &qp->iqm_res, true);
+	}
+
+	return rc;
+}
+
+int bng_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata)
+{
+	struct bng_re_qp *qp = container_of(ib_qp, struct bng_re_qp, ib_qp);
+	struct bng_sp_qp *sp_qp = &qp->sp_qp;
+	struct bng_re_dev *rdev = qp->rdev;
+	unsigned int flags;
+	int rc;
+
+	bng_re_flush_cqn_wq(&qp->sp_qp);
+
+	rc = qp_destroy_qp_mpc(&rdev->bng_res, qp);
+	if (rc)
+		ibdev_err(&rdev->ibdev, "Failed to destroy HW QP");
+
+	if (rdma_is_kernel_res(&qp->ib_qp.res)) {
+		flags = bng_re_lock_cqs(qp);
+		bng_re_clean_qp(&qp->sp_qp);
+		bng_re_unlock_cqs(qp, flags);
+	}
+
+	bng_re_free_qp_res(&rdev->bng_res, &qp->sp_qp);
+
+	mutex_lock(&rdev->qp_lock);
+	list_del(&qp->list);
+	mutex_unlock(&rdev->qp_lock);
+
+	ib_umem_release(qp->rumem);
+	ib_umem_release(qp->sumem);
+
+	/* Same as bng_re_flush_cqn_wq: tolerate partial QP / missing CQ-NQ links. */
+	if (sp_qp->scq && sp_qp->scq->nq && sp_qp->scq->nq->cqn_wq)
+		flush_workqueue(sp_qp->scq->nq->cqn_wq);
+	if (sp_qp->rcq && sp_qp->scq != sp_qp->rcq &&
+	    sp_qp->rcq->nq && sp_qp->rcq->nq->cqn_wq)
+		flush_workqueue(sp_qp->rcq->nq->cqn_wq);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index c5643ee70885..f89db8d33ded 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -6,10 +6,26 @@
 
 #include <linux/refcount.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_addr.h>
+#include <rdma/bng_re-abi.h>
 
 #include "bng_sp.h"
 #include "bng_re.h"
 
+#define BNG_RE_RESERVED_QP_WRS	128
+#define BNG_RE_XID_AVOID_REUSE		false
+#define BNG_RE_MIN_KERNEL_QP_TX_DEPTH	4096
+
+/* GSI QP mode enum */
+enum bng_re_gsi_mode {
+	BNG_RE_GSI_MODE_INVALID = 0,
+	BNG_RE_GSI_MODE_ALL = 1,
+	BNG_RE_GSI_MODE_ROCE_V1,
+	BNG_RE_GSI_MODE_ROCE_V2_IPV4,
+	BNG_RE_GSI_MODE_ROCE_V2_IPV6,
+	BNG_RE_GSI_MODE_UD
+};
+
 struct bng_re_ucontext {
 	struct ib_ucontext      ib_uctx;
 	struct bng_re_dev	*rdev;
@@ -94,6 +110,48 @@ struct bng_re_ah {
 	refcount_t		*ref_cnt;
 };
 
+union ip_addr {
+	u32 ipv4_addr;
+	u8  ipv6_addr[16];
+};
+
+struct bng_re_iqm_res {
+	u32 irrq_addr;
+	u32 irrq_size;
+	u32 orrq_addr;
+	u32 orrq_size;
+	u32 msn_addr;
+	u32 msn_size;
+};
+
+struct bng_re_qp_info_entry {
+	union ib_gid		sgid;
+	union ib_gid		dgid;
+	union ip_addr		s_ip;
+	union ip_addr		d_ip;
+	u16			s_port;
+#define BNG_RE_QP_DEST_PORT	4791
+	u16			d_port;
+	u32			rate_limit;
+};
+
+struct bng_re_qp {
+	struct ib_qp		ib_qp;
+	struct list_head	list;
+	struct bng_re_dev	*rdev;
+	spinlock_t		sq_lock;
+	spinlock_t		rq_lock;
+	struct bng_sp_qp	sp_qp;
+	struct bng_re_iqm_res	iqm_res;
+	struct ib_umem		*sumem;
+	struct ib_umem		*rumem;
+	u32			send_psn;
+	struct bng_re_cq	*scq;
+	struct bng_re_cq	*rcq;
+	struct dentry		*dentry;
+	struct bng_re_qp_info_entry qp_info_entry;
+};
+
 static inline struct bng_re_ah *to_bng_re_ah(struct ib_ah *ibah)
 {
 	return container_of(ibah, struct bng_re_ah, ib_ah);
@@ -112,6 +170,139 @@ static inline u16 bng_re_get_rwqe_size(int nsge)
 	return 16 + (nsge * 16); /* header=16, each sge=16 bytes */
 }
 
+static inline u16 __get_swqe_size(int nsge)
+{
+	u16 wqe_size;
+
+	wqe_size = sizeof(struct sq_atomic_hdr) + nsge * sizeof(struct sq_sge);
+	return wqe_size;
+}
+
+static inline u32 bng_re_get_diff(struct bng_re_ucontext *uctx,
+				  struct bng_re_chip_ctx *cctx)
+{
+	if (!uctx)
+		return 0;
+	else if (uctx->cmask & BNG_RE_UCNTX_CMASK_RSVD_WQE_DISABLED)
+		return 0;
+
+	/* old lib */
+	return BNG_RE_RESERVED_QP_WRS;
+}
+
+static inline enum ib_qp_state __to_ib_qp_state(u8 state)
+{
+	switch (state) {
+	case CMDQ_MODIFY_QP_NEW_STATE_RESET:
+		return IB_QPS_RESET;
+	case CMDQ_MODIFY_QP_NEW_STATE_INIT:
+		return IB_QPS_INIT;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTR:
+		return IB_QPS_RTR;
+	case CMDQ_MODIFY_QP_NEW_STATE_RTS:
+		return IB_QPS_RTS;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQD:
+		return IB_QPS_SQD;
+	case CMDQ_MODIFY_QP_NEW_STATE_SQE:
+		return IB_QPS_SQE;
+	case CMDQ_MODIFY_QP_NEW_STATE_ERR:
+	default:
+		return IB_QPS_ERR;
+	}
+}
+
+static inline enum ib_mtu __to_ib_mtu(u32 mtu)
+{
+	switch (mtu) {
+	case CMDQ_MODIFY_QP_PATH_MTU_MTU_256:
+		return IB_MTU_256;
+	case CMDQ_MODIFY_QP_PATH_MTU_MTU_512:
+		return IB_MTU_512;
+	case CMDQ_MODIFY_QP_PATH_MTU_MTU_1024:
+		return IB_MTU_1024;
+	case CMDQ_MODIFY_QP_PATH_MTU_MTU_2048:
+		return IB_MTU_2048;
+	case CMDQ_MODIFY_QP_PATH_MTU_MTU_4096:
+		return IB_MTU_4096;
+	default:
+		return IB_MTU_1024;
+	}
+}
+
+static inline u8 __to_ib_port_num(u16 port_id)
+{
+	/* Typically Broadcom driver has a 1-based port number mapped to port_id 0 */
+	return (u8)(port_id + 1);
+}
+
+static u32 __from_ib_mtu(enum ib_mtu mtu)
+{
+	switch (mtu) {
+	case IB_MTU_256:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_256;
+	case IB_MTU_512:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_512;
+	case IB_MTU_1024:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_1024;
+	case IB_MTU_2048:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_2048;
+	case IB_MTU_4096:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_4096;
+	default:
+		return CMDQ_MODIFY_QP_PATH_MTU_MTU_2048;
+	}
+}
+
+static inline enum ib_qp_type  __from_hw_to_ib_qp_type(u8 type)
+{
+	switch (type) {
+	case CMDQ_CREATE_QP1_TYPE_GSI:
+	case CMDQ_CREATE_QP_TYPE_GSI:
+		return IB_QPT_GSI;
+	case CMDQ_CREATE_QP_TYPE_RC:
+		return IB_QPT_RC;
+	case CMDQ_CREATE_QP_TYPE_UD:
+		return IB_QPT_UD;
+	case CMDQ_CREATE_QP_TYPE_RAW_ETHERTYPE:
+		return IB_QPT_RAW_ETHERTYPE;
+	default:
+		return IB_QPT_MAX;
+	}
+}
+
+/* Extract IPv4 from last 4 bytes of IPv4-mapped GID (bytes 12-15, host order). */
+static inline u32 ipv4_from_gid(u8 *gid)
+{
+	return (u32)(gid[15] << 24 | gid[14] << 16 | gid[13] << 8 | gid[12]);
+}
+
+static inline int bng_re_init_qpmtu(struct bng_re_qp *qp, int mtu,
+				    int mask, struct ib_qp_attr *qp_attr)
+{
+	int qpmtu, qpmtu_int;
+	int ifmtu, ifmtu_int;
+
+	ifmtu = iboe_get_mtu(mtu);
+	ifmtu_int = ib_mtu_enum_to_int(ifmtu);
+	qpmtu = ifmtu;
+	qpmtu_int = ifmtu_int;
+	if (mask & IB_QP_PATH_MTU) {
+		qpmtu = qp_attr->path_mtu;
+		qpmtu_int = ib_mtu_enum_to_int(qpmtu);
+		if (qpmtu_int > ifmtu_int)
+			return -EINVAL;
+	}
+	qp->sp_qp.path_mtu = __from_ib_mtu(qpmtu);
+	qp->sp_qp.mtu = qpmtu_int;
+	qp->sp_qp.modify_flags |=
+		CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
+
+	return 0;
+}
+
+#define to_bng_re(ptr, type, member)	\
+	container_of(ptr, type, member)
+
 int bng_re_query_device(struct ib_device *ibdev, struct ib_device_attr *ib_attr,
 			struct ib_udata *udata);
 int bng_re_modify_device(struct ib_device *ibdev, int device_modify_mask,
@@ -176,6 +367,13 @@ int bng_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
 int bng_re_destroy_ah(struct ib_ah *ib_ah, u32 flags);
 int bng_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr);
 void bng_re_posted_destroy_ah(struct work_struct *work);
+int bng_re_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
+		    int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
+int bng_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
+		     struct ib_udata *udata);
+int bng_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
+		     int qp_attr_mask, struct ib_udata *udata);
+int bng_re_destroy_qp(struct ib_qp *ib_qp, struct ib_udata *udata);
 
 #endif /* __BNG_RE_VERBS_H__ */
 
diff --git a/include/uapi/rdma/bng_re-abi.h b/include/uapi/rdma/bng_re-abi.h
index 36bc902600be..7cee818f06d1 100644
--- a/include/uapi/rdma/bng_re-abi.h
+++ b/include/uapi/rdma/bng_re-abi.h
@@ -25,6 +25,14 @@ enum {
 	BNG_RE_COMP_MASK_REQ_UCNTX_RSVD_WQE = 0x02,
 };
 
+enum {
+	BNG_RE_COMP_MASK_MQP_EX_PPP_REQ_EN_MASK	= 0x1,
+	BNG_RE_COMP_MASK_MQP_EX_PPP_REQ_EN	= 0x1,
+	BNG_RE_COMP_MASK_MQP_EX_PATH_MTU_MASK	= 0x2,
+	BNG_RE_COMP_MASK_MQP_EX_OOO_DP_EN_MASK	= 0x20,
+	BNG_RE_COMP_MASK_REQ_BUFF_CNT           = 0x400UL,
+};
+
 struct bng_re_uctx_req {
 	__aligned_u64 comp_mask;
 };
@@ -80,4 +88,31 @@ struct bng_re_ah_resp {
 	__u64 comp_mask;
 } __attribute__((packed));
 
+struct bng_re_qp_req {
+	__aligned_u64 qpsva;
+	__aligned_u64 qprva;
+	__aligned_u64 qp_handle;
+	__aligned_u64 comp_mask;
+};
+
+struct bng_re_qp_resp {
+	__u32 qpid;
+	__u32 rsvd;
+};
+
+struct bng_re_modify_qp_ex_req {
+	__aligned_u64 comp_mask;
+	__u64 path_ctx_id;
+	__u32 dpi;
+	__u8  no_grp;
+	__u8  rsvd[3];
+	__u32 req_buffer_count;
+} __packed;
+
+struct bng_re_modify_qp_ex_resp {
+	__aligned_u64 comp_mask;
+	__u32 ppp_st_idx;
+	__u32 path_mtu;
+} __packed;
+
 #endif /* __BNG_RE_UVERBS_ABI_H__*/
-- 
2.43.5

