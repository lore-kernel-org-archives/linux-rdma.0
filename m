Received: from mail-ot1-f103.google.com (mail-ot1-f103.google.com [209.85.210.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790F44229B0
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615584; cv=none; b=kVDB4y1p26zAq1zhMZ0ZmGxT/nRXPTSgi5myXYsaV6Nv1CBJ4aMl/BVRssMpArr4NfgS91bUxArGJ84WMgxpCozwQdLFjhBQ8eToeSWxI7MCpEUw3ZoFLMl3jylp+ApER+88epNk/sz2s9fqWeg77Mp5NdmDFCh3qW2T523mwp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615584; c=relaxed/simple;
	bh=p1qm5tVCZKvPQ387Z0g9kfO48w/FWXt6ndEPDRrHgoc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WB+PWGAFfqijpFyS/VFe/Luz3/UXkhGkTfX3+EKEUTVVb9X+MhIwqg16bknQ9xb93MZ/hTOn6bCFONDNza3ECmvPqsL8S7AU+1XQ7wFaJq+3+Gtvv4optdygGL4l51T+A2YpZDXOg85HOeL12javQmW8Un8MHNha9Gr8C2w2+xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=HvzeBTaR; arc=none smtp.client-ip=209.85.210.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HvzeBTaR"
Received: by mail-ot1-f103.google.com with SMTP id 46e09a7af769-7ee125ec926so207312a34.2
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615581; x=1785220381;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JAhSrEftSI3xwUdpnjXX75sbRupmZeaRsrO8qHEGfs8=;
        b=ArWEIjabgoHPj1KYzm9eJXuyZwAPd3aqZPtAdTkZVYlThsuDzL0Lf7vPCjbRrW3oQs
         QCPgP5mEBRQzkO3WyRpBrkNFLUiHM7D0DokRej7cnXUXc1oRKIhQLBwT6ZvaCtZ0wZdo
         wEe+SyNvkLglaD4EWLlx8kq2cZ1HE8IwsUSTlXIhEkiiOpsIi5JQdBcrn8dyVxrEAV5K
         YUP0mzhwCz4pjkH7m6Vo9XKa7NhL0yqhBGE4nfa4HuGvgb5+8ekNZnmik2HRB7tJBteK
         fI4Vdc1F9YQdn0hpg00tTP+0VkOrmc0RBD5DgbHpvlfwrzeJRZ7UT17aGfRYMc2tsxJJ
         kW3w==
X-Gm-Message-State: AOJu0YztHO2PqStc+MSYdUbGoOwyj23UB9TXXT+vnylxpFpJwzJTLX/h
	gmOE35+tvmITNtBhsdbXLCiZRDsRA9UPJMnwNCaeWjvniYRSp6pQCitTMl6HeDm8vSw1iUH32TO
	AIbkDDDWQcTcJl2g5AEipga793GkOsseem9YYCrLVTQluv08Va+uqtjKIVYd7nU6bq0uuTsE8zN
	pelWTLEkFGEWgmpsfRjna+5CF5prcQv0YNiHbSmaMcL1Dp+xo4pIPxT8wSrvTfxxLTNaI95J8Lg
	vJcUrBLSKpi0zqNXRx4
X-Gm-Gg: AfdE7cnPifMjC3ouySrPruiwPuqsHo2BvRYax73HvDEafmut6uwPsh5ankTvmnFMLdQ
	06iFtpnLhEsLzKjmLDjmvFIwMG1WO3T9mY0GJUA0i9pjKlMPqcnSfhPs1YuRBxGwdbIC7/KqCon
	eplwAl0z/TmhG0kNDUAakfokiIOCALrApOtmWCquEaZW6CefmBDAblYz3lG0EURvbQAeokqUUlJ
	1+2OAseh1hX0Jxi+21c1xsvNYgeCqgkU0GMJdMvrBeK7rcOEx/wLFLb7f5BPw4bJJxTLSUKuU3a
	uAwWyarJu6dMnB2++gG80Pv92pIFX4VtHVvBgndS438P4lv78CnrvrXOAIaoMnJ7MgLqkjwLN5d
	DcO3ZETY/aFd7WxU/c/fEWpKI574V6LbG83qzI+l3+QMzXf/b+6SAFkR+hwpPoJJZtOVUeVk0Kh
	0qxY9TEBvMW3sthgP83J6hBtd5renNYhMkaBu7ha4=
X-Received: by 2002:a05:6820:1503:b0:6a1:18fc:519f with SMTP id 006d021491bc7-6a535b0dfcamr9274040eaf.0.1784615581036;
        Mon, 20 Jul 2026 23:33:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6a51a218bdbsm722096eaf.24.2026.07.20.23.33.00
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:33:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso14929104a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615579; x=1785220379; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JAhSrEftSI3xwUdpnjXX75sbRupmZeaRsrO8qHEGfs8=;
        b=HvzeBTaRYa7xOjYp4gyj1mZjoyTB3o5jWnZD7RqE1UW+SzoOJlcnErUujQQ3lYIiWV
         Wkh2Ru7hBUMngDZ+Uda07cWXQvg5jLVhKwo669r0FO1NbFkGwmBy85n+9ET60Ej27Ney
         yNA1wUxy9FZBfgOYLNn29PPMIxyw5dayOAGVw=
X-Received: by 2002:a17:90b:3846:b0:38e:7069:7125 with SMTP id 98e67ed59e1d1-38e70697449mr9403637a91.42.1784615579320;
        Mon, 20 Jul 2026 23:32:59 -0700 (PDT)
X-Received: by 2002:a17:90b:3846:b0:38e:7069:7125 with SMTP id 98e67ed59e1d1-38e70697449mr9403624a91.42.1784615578796;
        Mon, 20 Jul 2026 23:32:58 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2900a37sm35230176c88.0.2026.07.20.23.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:32:57 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	alhouseenyousef@gmail.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next v4 1/4] RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
Date: Tue, 21 Jul 2026 04:54:37 -0700
Message-Id: <20260721115440.24021-2-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260721115440.24021-1-selvin.xavier@broadcom.com>
References: <20260721115440.24021-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The CQ and SRQ hash tables (cq_hash, srq_hash) on struct bnxt_re_dev
were used exclusively to look up a toggle-page pointer from a
user-space-supplied hardware queue ID in the GET_TOGGLE_MEM
ioctl handler. This approach has couple of problems. First,
because the tables are per-device, any user can look up another
user's CQ or SRQ by guessing the hardware queue ID. Second,
concurrent add and remove operations on the hash table are not
protected by any lock, leaving a race window.

The correct fix is to retrieve the CQ and SRQ objects via the uverbs
object handle, which gives built-in ownership verification and reference
pinning for the duration of the ioctl. That is added in a later patch of
this series.

To maintain backward compatibility with older rdma-core versions that
do not send a uverbs object handle, the driver must continue to support
the existing TYPE + RES_ID lookup path. This patch replaces the per-device
hash tables with per-ucontext XArrays (cq_xa and srq_xa on struct
bnxt_re_ucontext), which narrows the lookup scope to the calling context,
eliminating the cross-user visibility. Also adds Xarray locking mechanism
for synchronization.

The GET_TOGGLE_MEM ioctl handler is updated to call xa_load()
in place of the now-removed bnxt_re_search_for_cq()/
bnxt_re_search_for_srq() helpers. No ABI changes are required.

bnxt_re_create_user_cq()/bnxt_re_create_srq() publish the uobject into
cq_xa/srq_xa before returning to the uverbs core, but the core only
sets uobject->object once the create callback has returned success.
Guard the lookup against this so a concurrent GET_TOGGLE_MEM racing an
in-progress create cannot feed a NULL ->object into container_of().

Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  6 --
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 87 +++++++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  6 +-
 drivers/infiniband/hw/bnxt_re/main.c     |  4 --
 drivers/infiniband/hw/bnxt_re/uapi.c     | 85 +++++++++--------------
 5 files changed, 107 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 3a7ce4729fcf..a43e678151d3 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -41,7 +41,6 @@
 #define __BNXT_RE_H__
 #include <rdma/uverbs_ioctl.h>
 #include "hw_counters.h"
-#include <linux/hashtable.h>
 #define ROCE_DRV_MODULE_NAME		"bnxt_re"
 
 #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
@@ -158,9 +157,6 @@ struct bnxt_re_nq_record {
 	struct mutex		load_lock;
 };
 
-#define MAX_CQ_HASH_BITS		(16)
-#define MAX_SRQ_HASH_BITS		(16)
-
 static inline bool bnxt_re_chip_gen_p7(u16 chip_num)
 {
 	return (chip_num == CHIP_NUM_58818 ||
@@ -215,8 +211,6 @@ struct bnxt_re_dev {
 	struct bnxt_re_pacing pacing;
 	struct work_struct dbq_fifo_check_work;
 	struct delayed_work dbq_pacing_work;
-	DECLARE_HASHTABLE(cq_hash, MAX_CQ_HASH_BITS);
-	DECLARE_HASHTABLE(srq_hash, MAX_SRQ_HASH_BITS);
 	struct dentry			*dbg_root;
 	struct dentry			*qp_debugfs;
 	unsigned long			event_bitmap;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 90138d64adee..dbf89abde85b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2151,11 +2151,26 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
-		hash_del(&srq->hash_entry);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
+		struct bnxt_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+
+		/*
+		 * Untrack the SRQ before releasing its hardware ID below, so a
+		 * concurrent create that gets the same ID reused by firmware
+		 * cannot have its fresh XArray entry erased by this destroy.
+		 */
+		if (uctx)
+			xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
+	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
-		free_page((unsigned long)srq->uctx_srq_page);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
+		struct bnxt_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+
+		if (uctx)
+			free_page((unsigned long)srq->uctx_srq_page);
+	}
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
 	return ib_respond_empty_udata(udata);
@@ -2262,20 +2277,21 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 
 		resp.srqid = srq->qplib_srq.id;
 		if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
-			hash_add(rdev->srq_hash, &srq->hash_entry, srq->qplib_srq.id);
 			srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
 			if (!srq->uctx_srq_page) {
 				rc = -ENOMEM;
-				goto fail;
+				goto fail_destroy_srq;
+			}
+			if (xa_is_err(xa_store(&uctx->srq_xa, srq->qplib_srq.id,
+					       ib_srq->uobject, GFP_KERNEL))) {
+				rc = -ENOMEM;
+				goto fail_free_srq_page;
 			}
 			resp.comp_mask |= BNXT_RE_SRQ_TOGGLE_PAGE_SUPPORT;
 		}
 		rc = ib_respond_udata(udata, resp);
-		if (rc) {
-			bnxt_qplib_destroy_srq(&rdev->qplib_res,
-					       &srq->qplib_srq);
-			goto fail;
-		}
+		if (rc)
+			goto fail_respond;
 	}
 	active_srqs = atomic_inc_return(&rdev->stats.res.srq_count);
 	if (active_srqs > rdev->stats.res.srq_watermark)
@@ -2284,6 +2300,17 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 
 	return 0;
 
+fail_respond:
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
+		xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
+		free_page((unsigned long)srq->uctx_srq_page);
+	}
+	bnxt_qplib_destroy_srq(&rdev->qplib_res, &srq->qplib_srq);
+	goto fail;
+fail_free_srq_page:
+	free_page((unsigned long)srq->uctx_srq_page);
+fail_destroy_srq:
+	bnxt_qplib_destroy_srq(&rdev->qplib_res, &srq->qplib_srq);
 fail:
 	ib_umem_release(srq->umem);
 exit:
@@ -3474,11 +3501,26 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
-	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
-		hash_del(&cq->hash_entry);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
+		struct bnxt_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+
+		/*
+		 * Untrack the CQ before releasing its hardware ID below, so a
+		 * concurrent create that gets the same ID reused by firmware
+		 * cannot have its fresh XArray entry erased by this destroy.
+		 */
+		if (uctx)
+			xa_erase(&uctx->cq_xa, cq->qplib_cq.id);
+	}
 	bnxt_qplib_destroy_cq(&rdev->qplib_res, &cq->qplib_cq);
-	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
-		free_page((unsigned long)cq->uctx_cq_page);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
+		struct bnxt_re_ucontext *uctx =
+			rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
+
+		if (uctx)
+			free_page((unsigned long)cq->uctx_cq_page);
+	}
 
 	bnxt_re_put_nq(rdev, nq);
 
@@ -3553,14 +3595,16 @@ int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *att
 	spin_lock_init(&cq->cq_lock);
 
 	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
-		hash_add(rdev->cq_hash, &cq->hash_entry, cq->qplib_cq.id);
-		/* Allocate a page */
 		cq->uctx_cq_page = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!cq->uctx_cq_page) {
 			rc = -ENOMEM;
 			goto destroy_cq;
 		}
-
+		if (xa_is_err(xa_store(&uctx->cq_xa, cq->qplib_cq.id,
+				       ibcq->uobject, GFP_KERNEL))) {
+			rc = -ENOMEM;
+			goto free_cq_page;
+		}
 		resp.comp_mask |= BNXT_RE_CQ_TOGGLE_PAGE_SUPPORT;
 	}
 	resp.cqid = cq->qplib_cq.id;
@@ -3573,6 +3617,9 @@ int bnxt_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *att
 	return 0;
 
 free_mem:
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
+		xa_erase(&uctx->cq_xa, cq->qplib_cq.id);
+free_cq_page:
 	free_page((unsigned long)cq->uctx_cq_page);
 destroy_cq:
 	bnxt_qplib_destroy_cq(&rdev->qplib_res, &cq->qplib_cq);
@@ -4794,6 +4841,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 		goto cfail;
 	}
 	uctx->shpage_mmap = &entry->rdma_entry;
+	xa_init(&uctx->cq_xa);
+	xa_init(&uctx->srq_xa);
 	if (rdev->pacing.dbr_pacing)
 		resp.comp_mask |= BNXT_RE_UCNTX_CMASK_DBR_PACING_ENABLED;
 
@@ -4846,6 +4895,8 @@ void bnxt_re_dealloc_ucontext(struct ib_ucontext *ib_uctx)
 	uctx->shpage_mmap = NULL;
 	if (uctx->shpg)
 		free_page((unsigned long)uctx->shpg);
+	xa_destroy(&uctx->cq_xa);
+	xa_destroy(&uctx->srq_xa);
 
 	if (uctx->dpi.dbr) {
 		/* Free DPI only if this is the first PD allocated by the
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 22bf81668cfb..4c78c183784b 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -70,6 +70,8 @@ struct bnxt_re_ah {
 	struct bnxt_qplib_ah	qplib_ah;
 };
 
+struct bnxt_re_user_mmap_entry;
+
 struct bnxt_re_srq {
 	struct ib_srq		ib_srq;
 	struct bnxt_re_dev	*rdev;
@@ -78,7 +80,6 @@ struct bnxt_re_srq {
 	struct ib_umem		*umem;
 	spinlock_t		lock;		/* protect srq */
 	void			*uctx_srq_page;
-	struct hlist_node       hash_entry;
 };
 
 struct bnxt_re_qp {
@@ -113,7 +114,6 @@ struct bnxt_re_cq {
 	struct ib_umem		*resize_umem;
 	int			resize_cqe;
 	void			*uctx_cq_page;
-	struct hlist_node	hash_entry;
 };
 
 struct bnxt_re_mr {
@@ -147,6 +147,8 @@ struct bnxt_re_ucontext {
 	void			*shpg;
 	spinlock_t		sh_lock;	/* protect shpg */
 	struct rdma_user_mmap_entry *shpage_mmap;
+	struct xarray		cq_xa;  /* cqid → ib_uobject, per-context toggle page lookup */
+	struct xarray		srq_xa; /* srqid → ib_uobject, per-context toggle page lookup */
 	u64 cmask;
 };
 
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index d25fdc458120..ce72db1b4bc3 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -2337,10 +2337,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 		if (!(rdev->qplib_res.en_dev->flags & BNXT_EN_FLAG_ROCE_VF_RES_MGMT))
 			bnxt_re_vf_res_config(rdev);
 	}
-	hash_init(rdev->cq_hash);
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
-		hash_init(rdev->srq_hash);
-
 	bnxt_re_debugfs_add_pdev(rdev);
 
 	bnxt_re_init_dcb_wq(rdev);
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 263238a6e4cd..c5e4e6e47b5f 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -22,31 +22,6 @@
 #include "bnxt_re.h"
 #include "ib_verbs.h"
 
-static struct bnxt_re_cq *bnxt_re_search_for_cq(struct bnxt_re_dev *rdev, u32 cq_id)
-{
-	struct bnxt_re_cq *cq = NULL, *tmp_cq;
-
-	hash_for_each_possible(rdev->cq_hash, tmp_cq, hash_entry, cq_id) {
-		if (tmp_cq->qplib_cq.id == cq_id) {
-			cq = tmp_cq;
-			break;
-		}
-	}
-	return cq;
-}
-
-static struct bnxt_re_srq *bnxt_re_search_for_srq(struct bnxt_re_dev *rdev, u32 srq_id)
-{
-	struct bnxt_re_srq *srq = NULL, *tmp_srq;
-
-	hash_for_each_possible(rdev->srq_hash, tmp_srq, hash_entry, srq_id) {
-		if (tmp_srq->qplib_srq.id == srq_id) {
-			srq = tmp_srq;
-			break;
-		}
-	}
-	return srq;
-}
 
 static int UVERBS_HANDLER(BNXT_RE_METHOD_NOTIFY_DRV)(struct uverbs_attr_bundle *attrs)
 {
@@ -244,12 +219,10 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 	enum bnxt_re_mmap_flag mmap_flag = BNXT_RE_MMAP_TOGGLE_PAGE;
 	enum bnxt_re_get_toggle_mem_type res_type;
 	struct bnxt_re_user_mmap_entry *entry;
+	struct ib_uobject *res_uobj;
 	struct bnxt_re_ucontext *uctx;
 	struct ib_ucontext *ib_uctx;
-	struct bnxt_re_dev *rdev;
-	struct bnxt_re_srq *srq;
 	u32 length = PAGE_SIZE;
-	struct bnxt_re_cq *cq;
 	u64 mem_offset;
 	u32 offset = 0;
 	u64 addr = 0;
@@ -265,35 +238,45 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		return err;
 
 	uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
-	rdev = uctx->rdev;
 	err = uverbs_copy_from(&res_id, attrs, BNXT_RE_TOGGLE_MEM_RES_ID);
 	if (err)
 		return err;
 
-	switch (res_type) {
-	case BNXT_RE_CQ_TOGGLE_MEM:
-		cq = bnxt_re_search_for_cq(rdev, res_id);
-		if (!cq)
-			return -EINVAL;
-
-		addr = (u64)cq->uctx_cq_page;
-		if (!addr)
-			return -EOPNOTSUPP;
-		break;
-	case BNXT_RE_SRQ_TOGGLE_MEM:
-		srq = bnxt_re_search_for_srq(rdev, res_id);
-		if (!srq)
-			return -EINVAL;
-
-		addr = (u64)srq->uctx_srq_page;
-		if (!addr)
-			return -EOPNOTSUPP;
-		break;
-
-	default:
+	/*
+	 * bnxt_re_create_cq/srq() publishes the uobject into cq_xa/srq_xa
+	 * before returning to the uverbs core, but the core only sets
+	 * uobject->object once the create callback has returned success.
+	 * A lookup that races with an in-progress create can therefore
+	 * find a uobject whose ->object is still NULL; skip it instead of
+	 * feeding NULL to container_of().
+	 */
+	if (res_type == BNXT_RE_CQ_TOGGLE_MEM) {
+		struct bnxt_re_cq *cq;
+
+		xa_lock(&uctx->cq_xa);
+		res_uobj = xa_load(&uctx->cq_xa, res_id);
+		if (res_uobj && res_uobj->object) {
+			cq = container_of(res_uobj->object, struct bnxt_re_cq, ib_cq);
+			addr = (u64)cq->uctx_cq_page;
+		}
+		xa_unlock(&uctx->cq_xa);
+	} else if (res_type == BNXT_RE_SRQ_TOGGLE_MEM) {
+		struct bnxt_re_srq *srq;
+
+		xa_lock(&uctx->srq_xa);
+		res_uobj = xa_load(&uctx->srq_xa, res_id);
+		if (res_uobj && res_uobj->object) {
+			srq = container_of(res_uobj->object, struct bnxt_re_srq, ib_srq);
+			addr = (u64)srq->uctx_srq_page;
+		}
+		xa_unlock(&uctx->srq_xa);
+	} else {
 		return -EOPNOTSUPP;
 	}
 
+	if (!addr)
+		return -EOPNOTSUPP;
+
 	entry = bnxt_re_mmap_entry_insert(uctx, addr, mmap_flag, &mem_offset);
 	if (!entry)
 		return -ENOMEM;
@@ -322,7 +305,7 @@ static int get_toggle_mem_obj_cleanup(struct ib_uobject *uobject,
 				      enum rdma_remove_reason why,
 				      struct uverbs_attr_bundle *attrs)
 {
-	struct  bnxt_re_user_mmap_entry *entry = uobject->object;
+	struct bnxt_re_user_mmap_entry *entry = uobject->object;
 
 	rdma_user_mmap_entry_remove(&entry->rdma_entry);
 	return 0;
-- 
2.39.3

