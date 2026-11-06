Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003142;
	b=4bSKToEBisbZXGmak+SMmLJPPMUvKbghSFjzuGHedKjYXIIkzkL7NOuF74fFm7x9gbhO
	 xZ/u4GcrP855KSNC2iO0WCC2LyLiKpi8reEqJAKkBrLnX5zVtdr38FwtbDecsBDZ5xcAH
	 6m7SfZK7786kKLJh2u8IPZZ6XaY2QlVFLkgZfWrxTqKP0UmejPu2MSR4rJsHb8fGNTsyZ
	 yBA7qfeMUb5x2U2vJaemk5raIT2JB3QJELocLJVdHU9im341AJToJnNKxTFVYBpIpiXtp
	 +4UY7nEgNIdeY87QPd1/covYfs+qwbV/N90OtxK5+lSWO63UOe4hcW2Vt1hJ4FsQJIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003142;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=IaQJzXgBKFlVU2sdaWtAVs7ky9i6gU7I/tU3LHdDGHQ=;
	b=ZzB69M9HYr+mVZUgnGR3LBKcUHb2bhRqM0D1owf63SlSOgd0AMZ4GbVCEVojRzmHdwux
	 cJX6Rz5nm+XU9xgEEQeUIvppHday0cJKV+JxJYInUGjMa6xviPzbIoiiD1+AUeG5qfaDW
	 ATGqeBoYqnQrZkI2Wl62uAF+p/0Q7rpgNB7DluJE9hmk82iZI5gw9BE9Vk5eXybUrvaDI
	 5w46A3l++WfeK7psqxInT+pUnUh2Ml5akiXMM9Ag45YF3elRKk/Jf9heLaIy27a8IXMxL
	 ml7O2z3N+n2HifDDmJBRPqpV8hugbOIkdqQLyE10uddyNOTefrsc0iHJk2vbINtL0zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PD6jsiXi;
	arc=none smtp.remote-ip=209.85.219.69
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68F3606A32E
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E68F3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PD6jsiXi
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91eb3a63064so2775036d6.0
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 14:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003141; x=1794607941; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IaQJzXgBKFlVU2sdaWtAVs7ky9i6gU7I/tU3LHdDGHQ=;
        b=PD6jsiXimEzSEStJ9y+jbWGFLNaQiD48k5V0z+Tb2a2JZR1TUFtgazeWGAWlRy3jO+
         n2OlA0UKNbfP90hQNbMJZU2YdYP+SpRETrBt0sO+uZDASZ+CgNfpdHry9K+THYsfCDQr
         SU6um5Ez6uLA/7TKakl0GRVpXydhVCjAzmc7GPC6da9cDTmCV1GFuCdsTJxc+rvzJaH4
         BTEEmY7/o/prRxnVqHjhAieojhHlilDzOPjOfjr063QjQe46TMvhtMKs9Ss80tb/AeuA
         xoCEWViL8DO/d39r1a4gFc7xr4H/mT9nsyLa1l7Nif1hnageTPynSSihGf6vVh1OYlWL
         hWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003141; x=1794607941;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IaQJzXgBKFlVU2sdaWtAVs7ky9i6gU7I/tU3LHdDGHQ=;
        b=NeAf1aMoEGSpll0IwOSC0FbzxKMzWRolTM/GklEck1LhaCIlCgDhm5h6vCvZDQJ93x
         Z098kSWzGwFhSlGUhCR5ohe/s13+vPxSyYcKfB0/3PnbLeuxhdYmHzclCXwrdafH/K34
         K+AqcdKKe16H5Yub0EW8T8QlqZVjQrODRqH/2Z4vlyL2s/EQLpT8KZZLI65IQwNP6ULb
         VtjUJNd8pNLNDzvO6Supud9/VVf4plEh8q6KMeltrtjZQFoiIEu308p0xJVRTqB0g/2y
         mac3OyCWgS3FdSwNTpk1D1wohWBunAoIsKFrOBRvbdmmio4lG81m4dI7ujEuF8h6nphG
         PaXg==
X-Gm-Message-State: APuU4Z9X5ypJpvGB5THKA+W2n5cRpK/Lnse4NbH7Xu/ZOQcjSNUwbXHT
	jHmUFenJQl1SD2/Dk8KnQrOm2H4wcQWVwiU+M1gPbKHYLAgPoBZp8QdsYModq1O5IBe8frxCV1n
	Qu/Xc/iqJ5g==
X-Received: from qvqu5.prod.google.com ([2002:a0c:ed25:0:b0:91c:9379:7e3f])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a0c:f095:0:b0:91e:7a12:64b
 with SMTP id 6a1803df08f44-91ebd1db2d5mr5431856d6.14.1794003140754; Fri, 06
 Nov 2026 14:12:20 -0800 (PST)
Date: Fri,  6 Nov 2026 22:11:59 +0000
In-Reply-To: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106221201.2266301-4-jmoroni@google.com>
Subject: [PATCH rdma-next 3/4] RDMA/irdma: Fix CQ scrub for SRQ associated QPs
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

When a QP is destroyed, any pending completions for it are
scrubbed by setting the QP handle to NULL so that the CQE
is skipped during poll. However, completions for SRQ WQEs
use a different offset (40 rather than 8) for the QP handle
but the driver did not account for this.

Fix this by checking whether the CQE being scrubbed is for
an SRQ WQE and if so, clearing the correct offset.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/uk.c   | 16 +++++++++++-----
 drivers/infiniband/hw/irdma/user.h |  2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 800b51003e18..05f512b01525 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1764,10 +1764,10 @@ void irdma_uk_cq_init(struct irdma_cq_uk *cq,
 
 /**
  * irdma_uk_clean_cq - clean cq entries
- * @q: completion context
+ * @qp: QP
  * @cq: cq to clean
  */
-void irdma_uk_clean_cq(void *q, struct irdma_cq_uk *cq)
+void irdma_uk_clean_cq(struct irdma_qp_uk *qp, struct irdma_cq_uk *cq)
 {
 	__le64 *cqe;
 	u64 qword3, comp_ctx;
@@ -1790,9 +1790,15 @@ void irdma_uk_clean_cq(void *q, struct irdma_cq_uk *cq)
 		/* Ensure CQE contents are read after valid bit is checked */
 		dma_rmb();
 
-		get_64bit_val(cqe, 8, &comp_ctx);
-		if ((void *)(unsigned long)comp_ctx == q)
-			set_64bit_val(cqe, 8, 0);
+		if (cq->avoid_mem_cflct && FIELD_GET(IRDMA_CQ_SRQ, qword3)) {
+			get_64bit_val(cqe, 40, &comp_ctx);
+			if ((struct irdma_qp_uk *)(unsigned long)comp_ctx == qp)
+				set_64bit_val(cqe, 40, 0);
+		} else {
+			get_64bit_val(cqe, 8, &comp_ctx);
+			if ((struct irdma_qp_uk *)(unsigned long)comp_ctx == qp)
+				set_64bit_val(cqe, 8, 0);
+		}
 
 		cq_head = (cq_head + 1) % cq->cq_ring.size;
 		if (!cq_head)
diff --git a/drivers/infiniband/hw/irdma/user.h b/drivers/infiniband/hw/irdma/user.h
index 4dd3776a4cdd..c7f115b28498 100644
--- a/drivers/infiniband/hw/irdma/user.h
+++ b/drivers/infiniband/hw/irdma/user.h
@@ -581,7 +581,7 @@ __le64 *irdma_qp_get_next_send_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx,
 				   struct irdma_post_sq_info *info);
 __le64 *irdma_srq_get_next_recv_wqe(struct irdma_srq_uk *srq, u32 *wqe_idx);
 __le64 *irdma_qp_get_next_recv_wqe(struct irdma_qp_uk *qp, u32 *wqe_idx);
-void irdma_uk_clean_cq(void *q, struct irdma_cq_uk *cq);
+void irdma_uk_clean_cq(struct irdma_qp_uk *qp, struct irdma_cq_uk *cq);
 int irdma_nop(struct irdma_qp_uk *qp, u64 wr_id, bool signaled, bool post_sq);
 int irdma_fragcnt_to_quanta_sq(u32 frag_cnt, u16 *quanta);
 int irdma_fragcnt_to_wqesize_rq(u32 frag_cnt, u16 *wqe_size);
-- 
2.56.0.455.g6c5a503b38-goog

