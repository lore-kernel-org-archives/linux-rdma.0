Received: from mail-oi1-f225.google.com (mail-oi1-f225.google.com [209.85.167.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C1E2D0C98
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119235; cv=none; b=d9wRxq6ptKsszelU2zeUt4MLjq3qajHyueQO1VCpc71xcmE3qsYeufvFDq+JOTgTpmDJOuJPfjaJTS/k8JNJRh6FvuT7nHJkcjVWdNSpLnL9V62u1G4H+MGm/nJlcC/EhzwH5z4WHY6ME4PECnPgJP26r0zGOqC3XVW1AD9ZqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119235; c=relaxed/simple;
	bh=KozjCnmDyh00wXXAvAiMXzO/C4dPtgJ2UhJzj6Qr230=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmZhRz29Ke9/qBVVTQPoMoOeWig7ba5E5fJY7m4HDCm3UM8v1H6+kXrlhlvjHRItS2wWLB5J1CtFfrkrysetn88Idal9k5Tlh9zHaIqZ90i+7a9CZ08Iofv5X3ZHYnX88uwCVKYjO1AufTbGxYs1gQjh6gxwbrao9cdfSSqls3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UZJYEnLR; arc=none smtp.client-ip=209.85.167.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UZJYEnLR"
Received: by mail-oi1-f225.google.com with SMTP id 5614622812f47-484d3c0855aso559310b6e.3
        for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 08:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779119223; x=1779724023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oyg8SngrjQiQb/ZJedYuFylnSvfHgQI1cpjrRp8UOOQ=;
        b=Ty7nPhOB3q1Vt3B74Xskfm10req9nQminu6F/kBRWhml0Ky+G2HwgDIdpPQErK/1/c
         TDRa4H8Uy9aVeVxvP8i4yfv2bYfej44KW+EIuz+th4WsVwqyIrsKqZE5foMu4ptvYmZM
         CBTtLKQ370JCm6nITVtNASGt/MAO6ixAXMQdl4ome/A+X0XvhBFXwqfE8gjY8UvjGu/s
         rD9pKSzGVGaJoprwglqP0lM/0Mpd2mO3UrWvBR+rlhNuuMFnFlggvN7htPqC0nV7uSVx
         SmTuhLxNVYfiUFNshjAbHftsr//JF6sgjPiitn1999V/xQfsfj5eKqYyuXyGcj1VS/aa
         BiZQ==
X-Gm-Message-State: AOJu0YyXo0jCDkXli1e8Yl8CF5zxctGnIm0vZ23QR0XPLSNIGu2WP+92
	I8Hq2inE3nCl0mHZjKQgZ9hGy305sKNvtAeJwUbG/+NSPqxCaIq3sBp38Wtl7SNLjUeVAVPjxnY
	CR+1vGgZLErQ+t/mLy8721Ltkb0ODGXiJUc7iql/hxa11R2LQ8W8KtGJl8F1rfkVN9ZETylMjlB
	2dUAjRXeZCC4bpoWEWXsh5mVIAPtQXepR9ejndjeGW6BN8ZM/ZHI2s10qnY31wkj4ZtULFHGyyU
	XG7x4ZL5QfpINicBDJ2f4ofXtLR
X-Gm-Gg: Acq92OGcAWXQNYyHxA8Q3DBf0cV7iK9gaPKp0Z7iciLuv9+kEVvvxNz2N0tVcYXCnUv
	XJW8LmKktuFC+dPFuu4le2TRvW9G4ujs5NJkMEfv4Fjf9j00XTpsw9pWU3zG9lSNyVUVFpJk2Vp
	q41gRegc6/MJMNUttnHafBSJGRvf5dxFOCDmwYZ8SDgV5fMLbdG+FbgEfJ9h7rSfx4CnWbk12ow
	rWZ832WcPsB8toWSBUnWWrDwjFMLQRQbRO8GKBKY4OAOYPFwoXAYCREBFZduIFgaTMTuM95ipu7
	/6ClX+RMIvgZ7bJU6Qd0jDnV+yK6Ss6deTzJi2K55yV7CsyiRcpiFn2JXBlLLqp/0tpsYqTC31A
	KkV1TGGl738rUf98uJSlD1daAnSIu6O3CCz5qROKob5hl/Xf7t8a4tf0UNn29DExgoNEFT73x7U
	y5oROnmCooS3drlUYT3I9Gv0c3fkKCGsEOmhH/jXoJ+t2mnqyHtx5FGTJQRfU3ZTM69cTq
X-Received: by 2002:a05:6820:3103:b0:69b:5486:e85 with SMTP id 006d021491bc7-69c9bfd479emr9651227eaf.36.1779119222836;
        Mon, 18 May 2026 08:47:02 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-69d045db4besm551042eaf.3.2026.05.18.08.47.02
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2026 08:47:02 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ba3245a43dso26910145ad.0
        for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 08:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1779119221; x=1779724021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oyg8SngrjQiQb/ZJedYuFylnSvfHgQI1cpjrRp8UOOQ=;
        b=UZJYEnLRXVb/hgtJyfSJZ2ATtuZ8C1v5kjrxShMVMehLHOTy/DWUBh3+Yp640BhvsM
         reib6OpyE3rG/zg+PxWvaqvIFXspVs3EYvg6njbKgmf2Cp9HF6pHQoo8NCGbqdxeg6wI
         jZinardHVijHeBM8edx64IJdxcxQul8ENU+Yc=
X-Received: by 2002:a17:902:76cb:b0:2ae:ba5f:3ac3 with SMTP id d9443c01a7336-2bd7e78576cmr131288605ad.2.1779119221298;
        Mon, 18 May 2026 08:47:01 -0700 (PDT)
X-Received: by 2002:a17:902:76cb:b0:2ae:ba5f:3ac3 with SMTP id d9443c01a7336-2bd7e78576cmr131288495ad.2.1779119220804;
        Mon, 18 May 2026 08:47:00 -0700 (PDT)
Received: from dhcp-10-123-156-119.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d2360e8sm163954285ad.82.2026.05.18.08.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 08:47:00 -0700 (PDT)
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v6 7/9] RDMA/bnxt_re: Enhance dpi lifecycle logic in doorbell uapis
Date: Mon, 18 May 2026 21:07:19 +0530
Message-ID: <20260518153721.183749-8-sriharsha.basavapatna@broadcom.com>
X-Mailer: git-send-email 2.51.2.636.ga99f379adf
In-Reply-To: <20260518153721.183749-1-sriharsha.basavapatna@broadcom.com>
References: <20260518153721.183749-1-sriharsha.basavapatna@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

If the DPI is freed when the dbr object is freed, but if the
process has not unmapped the page yet, then the DPI slot could
get reallocated to another process while the original process
still has it mapped. To prevent this, save the DPI info in the
mmap entry during dbr allocation and free the DPI slot from
bnxt_re_mmap_free(), which enures that there are no references
to it.

This change is needed to support doorbell allocation to QPs
in the next patch.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |  4 ++++
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  1 +
 drivers/infiniband/hw/bnxt_re/uapi.c     | 12 ++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9fd85d81bcea..b8e46feafee7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4943,6 +4943,10 @@ void bnxt_re_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
 	bnxt_entry = container_of(rdma_entry, struct bnxt_re_user_mmap_entry,
 				  rdma_entry);
 
+	if (bnxt_entry->mmap_flag == BNXT_RE_MMAP_UC_DB && bnxt_entry->uctx)
+		bnxt_qplib_free_uc_dpi(&bnxt_entry->uctx->rdev->qplib_res,
+				       &bnxt_entry->dpi);
+
 	kfree(bnxt_entry);
 }
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 13dac48ed453..1caef68a5c38 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -161,6 +161,7 @@ struct bnxt_re_user_mmap_entry {
 	struct bnxt_re_ucontext *uctx;
 	u64 mem_offset;
 	u8 mmap_flag;
+	struct bnxt_qplib_dpi dpi;
 };
 
 struct bnxt_re_dbr_obj {
diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index b8fc8bfba2ad..866df9206f5a 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -368,6 +368,12 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_DBR_ALLOC)(struct uverbs_attr_bundle *a
 		goto free_dpi;
 	}
 
+	/* Save DPI info to the mmap entry so that bnxt_re_mmap_free()
+	 * can free the DPI slot only after the last reference to the
+	 * mmap entry is released.
+	 */
+	obj->entry->dpi = *dpi;
+
 	obj->rdev = rdev;
 	kref_init(&obj->usecnt);
 	uobj->object = obj;
@@ -396,10 +402,12 @@ void bnxt_re_dbr_kref_release(struct kref *ref)
 {
 	struct bnxt_re_dbr_obj *obj =
 		container_of(ref, struct bnxt_re_dbr_obj, usecnt);
-	struct bnxt_re_dev *rdev = obj->rdev;
 
+	/* Drop the driver's reference to the mmap entry (_remove()).
+	 * The DPI slot gets freed from bnxt_re_mmap_free() only
+	 * when there's no VMA mapping reference to it.
+	 */
 	rdma_user_mmap_entry_remove(&obj->entry->rdma_entry);
-	bnxt_qplib_free_uc_dpi(&rdev->qplib_res, &obj->dpi);
 	kfree(obj);
 }
 
-- 
2.51.2.636.ga99f379adf

