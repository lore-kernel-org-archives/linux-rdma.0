Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF726372049
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787592901; cv=none; b=Zz0pMkkH32CuNaF4Lj0xTYnkWf+ohduI/vE13eRNi43jCF6JF0MJvjHC/sglUxEe7lZtwWb6gp31F9lZz9yHUGQ9B9LCVBl4XdTIKZ9L9CNDPoE/71BfZM9Qd1KjhwWL1blyWinlNM5pob8STAEo1twf8PDHFaDtrjRO8UH2XvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787592901; c=relaxed/simple;
	bh=L/rBBfr7a9PTNow2YC4GLaNpT6VdYvB8cJGMgffEDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSnwS2ZaQzjm6Mi3wjt/nRbdFkNyoVIVfx9c4Y8d1R78BoIkIGZ3i6mAMJwBpy89iqEctmSSBDNHsPDvP5kPUyJOaJ6JU5Kv5iTOwFc7od8HfGRxbdw937oxbnmURWYPFeuSYAF2Z210pLk8VXJkfSHRK7TOTWY/yXWCyKjjN2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AGPSSd+p; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AGPSSd+p"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-84867f07d63so4029937b3a.2
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 10:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787592893; x=1788197693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=S7ngy60SYvef13oCq5HQRp4oYPUBJeOBEWdUBxi/guI=;
        b=eat3aWP1hAgl0CE40EMcinTtvbqI3+8gt0dMSo91Oqp88etI45XkSBfRFKi2ZDX7K4
         z3mFAH7G5sbWqP5sGQ9Yl4Mf025UWR7Yvaqf1KA8nqS/9iUEq7h3Efjla3Asl2CLDuEX
         5zDlQtYBs99J1I/9skprwl9RSZQG69AsGGpGXJTRvdtPGZbRfdBjnC3uDwa6+4fWCJnb
         yA2skhAFFkI6XFir6VS+/NZBqZ54kEv0MxpMW4cUpZ15g42al8gDNvWFLZ4zAKzW9RdW
         BrCRZY5JBvaFkZyPIPne7SZSsMzLbI4LLPvtliZN7+V4ixQpLxImAIB1EkB0Py5cXt74
         8DRQ==
X-Gm-Message-State: AFuF++mBH7O3RGf1Zt8/s1y8+5T5jK1/2J9j8YRHpkBTgoNo2AAbpATe
	5X190a1C/dszUGG4pTWZg8TBChF1f3ZhOeT9mCSjWRs3CsAMQC99qsMzbnXJA6bcrClDO1InhaU
	t3zi4gUrYdxQgonRFtxk5JPTLxE7m2jKL/0uw7438Ue+TXuAWWTX036ZaZG623SD6NXjTZotsmX
	OwGua7id2HR2yM75UroXzDSnp/DdcRvW2wU3tCwNd+u85zxUVIt4usi8JVdVIqYtEBvxOxvqkMT
	nSGfJ96vj08zeILg8TP6EbmD5gq
X-Gm-Gg: AR+sD13omcMHHGmv/fbjn99pFAcvXPwoh/z+0JOeCXEPbuD8yNNmmLtAYgBZowneORn
	t1QTz01hZoqOTrqLu3odCYXzBPaydRkd21G5K6QUCsvKfaWfbctYZC1xgrbF2kJgGRtfHCyM2QS
	u+w3ZUFEUpXGGfKfUYy1ypAcce+HR1pfwIjG01NDKrfDOhCHL/IElo4i9oD7RYTg9tvUpoD7iai
	Y+al3RGf4UKZcdGg9ATI82QgWpPT3rYe0YQGib3APOt/c6YSmvAevrzrlvFFZM7Nq0cHknZdO3c
	0rAKBaUzi33mJ1OzfwFy29ASupIt7pyNJLes9K+DWdrV+E8mQkxqrS/7m+ZNTsuamRhlbARBQYc
	FulEYSfHyWA1PTMhhDtirrre6j/51nFMGnDCC+uNwU/TY6STagbKUKB15dJu5YpOg355hj9KwK3
	ugiag5dZXp/VzchJBUmLJyPkQf/Kcdddq2vSRF/TKzi0h/nzc=
X-Received: by 2002:a05:6a00:234c:b0:848:77b3:579a with SMTP id d2e1a72fcca58-8520be4a4b5mr32351501b3a.17.1787592893218;
        Mon, 24 Aug 2026 10:34:53 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-852102693cdsm3640629b3a.2.2026.08.24.10.34.52
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2026 10:34:53 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb835525b10so4954636a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 10:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787592891; x=1788197691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S7ngy60SYvef13oCq5HQRp4oYPUBJeOBEWdUBxi/guI=;
        b=AGPSSd+p56/hyfUnDW9BlFjGmcsQoJ/uCd8zOSfuJVgO+M8Y+54vGIoojYk3JyPAET
         9MlpV6GRKMvi4sbhcHyA7ea3QR6YVMpQYcK4xoeZmJMf7y6QD81P7Hzt8rQ/GeF/mUH3
         vFx3XZbT6GYnzNCxsnAp64JbMPiGz3UAA9VDM=
X-Received: by 2002:a17:90b:580d:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-395df24e757mr39499472a91.9.1787592891216;
        Mon, 24 Aug 2026 10:34:51 -0700 (PDT)
X-Received: by 2002:a17:90b:580d:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-395df24e757mr39499351a91.9.1787592890729;
        Mon, 24 Aug 2026 10:34:50 -0700 (PDT)
Received: from dhcp-10-123-156-119.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f909adc8sm30387811eec.2.2026.08.24.10.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 10:34:50 -0700 (PDT)
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-rc] RDMA/bnxt_re: Avoid exposing umdbr to userspace
Date: Mon, 24 Aug 2026 22:54:43 +0530
Message-ID: <20260824172443.33943-1-sriharsha.basavapatna@broadcom.com>
X-Mailer: git-send-email 2.51.2.636.ga99f379adf
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The umdbr field in struct bnxt_re_db_region returns the raw
unmapped PCI BAR address of the doorbell region. Avoid sharing
this field to the userspace. Change this to a reserved field
and stop populating it, keeping the ABI layout and size
unchanged for existing binaries.

Fixes: 1234a9d8aebb ("RDMA/bnxt_re: Support doorbell extensions")
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/uapi.c | 6 ++----
 include/uapi/rdma/bnxt_re-abi.h      | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 263238a6e4cd..f278c4f70ff7 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -409,7 +409,6 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_DBR_ALLOC)(struct uverbs_attr_bundle *a
 	uobj->object = obj;
 	uverbs_finalize_uobj_create(attrs, BNXT_RE_ALLOC_DBR_HANDLE);
 
-	dbr.umdbr = dpi->umdbr;
 	dbr.dpi = dpi->dpi;
 	ret = uverbs_copy_to_struct_or_zero(attrs, BNXT_RE_ALLOC_DBR_ATTR,
 					    &dbr, sizeof(dbr));
@@ -472,7 +471,6 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_DEFAULT_DBR)(struct uverbs_attr_bun
 		return PTR_ERR(ib_uctx);
 
 	uctx = container_of(ib_uctx, struct bnxt_re_ucontext, ib_uctx);
-	dpi.umdbr = uctx->dpi.umdbr;
 	dpi.dpi = uctx->dpi.dpi;
 
 	ret = uverbs_copy_to_struct_or_zero(attrs, BNXT_RE_DEFAULT_DBR_ATTR,
@@ -490,7 +488,7 @@ DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_DBR_ALLOC,
 					    UA_MANDATORY),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_ALLOC_DBR_ATTR,
 						UVERBS_ATTR_STRUCT(struct bnxt_re_db_region,
-								   umdbr),
+								   reserved2),
 								   UA_MANDATORY),
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_ALLOC_DBR_OFFSET,
 						UVERBS_ATTR_TYPE(u64),
@@ -510,7 +508,7 @@ DECLARE_UVERBS_NAMED_OBJECT(BNXT_RE_OBJECT_DBR,
 DECLARE_UVERBS_NAMED_METHOD(BNXT_RE_METHOD_GET_DEFAULT_DBR,
 			    UVERBS_ATTR_PTR_OUT(BNXT_RE_DEFAULT_DBR_ATTR,
 						UVERBS_ATTR_STRUCT(struct bnxt_re_db_region,
-								   umdbr),
+								   reserved2),
 						UA_MANDATORY));
 
 DECLARE_UVERBS_GLOBAL_METHODS(BNXT_RE_OBJECT_DEFAULT_DBR,
diff --git a/include/uapi/rdma/bnxt_re-abi.h b/include/uapi/rdma/bnxt_re-abi.h
index a4599d7b736a..0a125c2a8cc4 100644
--- a/include/uapi/rdma/bnxt_re-abi.h
+++ b/include/uapi/rdma/bnxt_re-abi.h
@@ -247,7 +247,7 @@ struct bnxt_re_query_device_ex_resp {
 struct bnxt_re_db_region {
 	__u32 dpi;
 	__u32 reserved;
-	__aligned_u64 umdbr;
+	__aligned_u64 reserved2;
 };
 
 enum bnxt_re_obj_dbr_alloc_attrs {
-- 
2.51.2.636.ga99f379adf

