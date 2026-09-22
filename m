Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2F6345749
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038302; cv=none; b=Sf/QC2bbN3M+kq9iflMv8r8+cW1DzX+CH3OUeStlT/5FpjhAHIlpzfLbOa+6eghAZRPtSdpS1lL8D3oAvf0Ar5MvJiDkp7yq6WEqxRK/utJQuEjPQ3IIxYIr08+dwpGZhUcwvfa9/yozL56WvuZm6R3kpfm7gzR8lAfB6Em3KgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038302; c=relaxed/simple;
	bh=ks5D4YcT5v7w1dirnjIJJnzuP4hbzuX8b4sFRkA+aJI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDGMi8U783mNHm3TMt0+yqyEzRCirlhkEY4oFPoKEAsekWtmQeguSyqag/SdwrDzmIDXNBOlAF8bvQeGvzYlamsLSiPhC9N4VgsJZnXzkUJVHzz7OqG+xD2mXiT2DVQTwR3P64GSymksC65jNqS/5FYrD+Lf3aNvlH7gPgMx3Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Il8iRINn; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Il8iRINn"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso325119a12.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038300; x=1790643100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jtZCHEmkEQnL3NZb3NodmBnHdXWAiMIt+o7PQN/6N5k=;
        b=wdMdNgcytZqQpntFYXdtHg3jk2gwBOOGlgwViy/eEaXs162V1XuSlxNYBhKsXoQRPu
         o8GLqdvr0eU8V1ZmVWdgKm09iBozSTyDTpkKZGHSC/gYimyvnaWwhi/IwqG6XURWtssS
         kACHfRKuI9PRtm2dfEekrRSgmyJBWlaiEi2SbeBaPoM8vqM/HGc40U7U6hko7OfkMOau
         j6KRAn4HrIzpv2QFqm9O3myj0QYMNSSS1fQoY7Pc0BeZEwZot6jmsjdKs8TM1EvVBuaS
         VkLDs9EEm5fUbFcMPeRzPmw3BEWH/uHiN7oo64BXr9krq4ivHXGYpIltpo68N0Vyy4LA
         mIpg==
X-Gm-Message-State: AFuF++nsaMKObbIC9xKqewRhkL91J7UNtG2Ye4wJFiOYfu3LrGeb1I2R
	zfJou1NOfuIT7olkZOTi3gZhaoGrUNMoexmr3wa/qjALPXpnPaFErs8tKpeDGZYtFSqYMhLQBsR
	zkTSGETs+awuJ3Sgmp/aIUFbpj48NYY+r7r20aoUFPPY5QV8E6i4WPXiskeol7OOxy9jIpN6cTD
	D4ruxVTwFvu1R535dh9r28eDG3sZzZL3PfXMiOuKaWT2C1+pWHUzoeuiFoa+/hnSx+Pme+Wta+s
	+EFThRj2fcVxIMzXQ==
X-Gm-Gg: AYBFou0CneNMIazx3nT84uqaTHdxUlUwGfzFZnFux5EROnD06NK+RkgaAatAP3+zcs+
	gcLoGMqZPkaFgDab7oaH/7C6nIp4jIqqxSwYlBpJOTQ9iR+vbgRht5CIQbQG/0shkUVtk3H+uqC
	f1SB8osfyLHLvHsfrdpsLdMd4wmP4RdV/wNgeiay8el4M5ebV+o+rt5JYLKWW5pQRnIGUIe4xec
	6O8WDIIhSYsfWq1WIjpd/CqKE2l3MPDHYENsbjvBI1V4gLUQ6jYVCoGfQUlSIxpL/IVgzhziBLB
	SzSkmpM+wpsieRZEHj5fAC7rGS86jFpYUDZ3k5sejVCK7Rd2ZN7ttqSQWb9RKZnOHF1UNrYkpI6
	3NQPvvNylmX7LfoTR387vY8cHEzlZmuri5UnnbLym0pU6JUuyg/NhXSNxVva53B0prp/zJLQmkv
	mT/bTvYIKSbegUmyPLRqCxuyJ7cwPXHs29EMfTTNs=
X-Received: by 2002:a05:6a20:1604:b0:3dd:a196:ffd8 with SMTP id adf61e73a8af0-3dde03d6e36mr1042947637.40.1790038299853;
        Mon, 21 Sep 2026 17:51:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc75697feafsm42198a12.2.2026.09.21.17.51.39
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:39 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2df5a65671eso4773535ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038298; x=1790643098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtZCHEmkEQnL3NZb3NodmBnHdXWAiMIt+o7PQN/6N5k=;
        b=Il8iRINniwGYXIBzdoQn4dtDmH35shsdeDKcqQ/Qy+Q7q3+nROWyXDqwXQNq/yF28Y
         l4hzaCpZU2jtL7W7LnJclyXAlGwUWBk8m1p6S2Go+6TDsZVK1x0Nv4Mk3156gAUABXjQ
         ZJ6ZHTev6kHjv/8is2l4qQs+vKMjcIbj8LhHo=
X-Received: by 2002:a17:902:ef45:b0:2df:34c0:72fe with SMTP id d9443c01a7336-2df59ac77a4mr10285265ad.35.1790038298056;
        Mon, 21 Sep 2026 17:51:38 -0700 (PDT)
X-Received: by 2002:a17:902:ef45:b0:2df:34c0:72fe with SMTP id d9443c01a7336-2df59ac77a4mr10285155ad.35.1790038297591;
        Mon, 21 Sep 2026 17:51:37 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:36 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 1/8] RDMA/bnxt_re: Fix integer overflow in send payload size computation
Date: Mon, 21 Sep 2026 23:12:23 -0700
Message-Id: <20260922061230.7909-2-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260922061230.7909-1-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

bnxt_re_build_sgl() summed SGE lengths into a signed int, which could
overflow. Make it return u32, and have bnxt_re_copy_wr_payload() report
the size via a u32 out-parameter with the return value carrying only
the error status, instead of overloading a signed int with both.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 44 +++++++++++++-----------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ccd2702db78b..9775a22b8d0d 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -165,10 +165,11 @@ static void bnxt_re_check_and_set_relaxed_ordering(struct bnxt_re_dev *rdev,
 		qplib_mr->flags |= CMDQ_REGISTER_MR_FLAGS_ENABLE_RO;
 }
 
-static int bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
+static u32 bnxt_re_build_sgl(struct ib_sge *ib_sg_list,
 			     struct bnxt_qplib_sge *sg_list, int num)
 {
-	int i, total = 0;
+	u32 total = 0;
+	int i;
 
 	for (i = 0; i < num; i++) {
 		sg_list[i].addr = ib_sg_list[i].addr;
@@ -3185,17 +3186,22 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 
 static int bnxt_re_copy_wr_payload(struct bnxt_re_dev *rdev,
 				   const struct ib_send_wr *wr,
-				   struct bnxt_qplib_swqe *wqe)
+				   struct bnxt_qplib_swqe *wqe,
+				   u32 *payload_sz)
 {
-	int payload_sz = 0;
+	int rc;
 
-	if (wr->send_flags & IB_SEND_INLINE)
-		payload_sz = bnxt_re_copy_inline_data(rdev, wr, wqe);
-	else
-		payload_sz = bnxt_re_build_sgl(wr->sg_list, wqe->sg_list,
-					       wqe->num_sge);
+	if (wr->send_flags & IB_SEND_INLINE) {
+		rc = bnxt_re_copy_inline_data(rdev, wr, wqe);
+		if (rc < 0)
+			return rc;
+		*payload_sz = rc;
+	} else {
+		*payload_sz = bnxt_re_build_sgl(wr->sg_list, wqe->sg_list,
+						wqe->num_sge);
+	}
 
-	return payload_sz;
+	return 0;
 }
 
 static void bnxt_ud_qp_hw_stall_workaround(struct bnxt_re_qp *qp)
@@ -3218,7 +3224,8 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct bnxt_re_qp *qp,
 				       const struct ib_send_wr *wr)
 {
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -3234,11 +3241,9 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 			goto bad;
 		}
 
-		payload_sz = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe);
-		if (payload_sz < 0) {
-			rc = -EINVAL;
+		rc = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe, &payload_sz);
+		if (rc)
 			goto bad;
-		}
 		wqe.wr_id = wr->wr_id;
 
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_SEND;
@@ -3279,7 +3284,8 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 {
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_qplib_swqe wqe;
-	int rc = 0, payload_sz = 0;
+	int rc = 0;
+	u32 payload_sz = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->sq_lock, flags);
@@ -3296,11 +3302,9 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, const struct ib_send_wr *wr,
 			goto bad;
 		}
 
-		payload_sz = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe);
-		if (payload_sz < 0) {
-			rc = -EINVAL;
+		rc = bnxt_re_copy_wr_payload(qp->rdev, wr, &wqe, &payload_sz);
+		if (rc)
 			goto bad;
-		}
 		wqe.wr_id = wr->wr_id;
 
 		switch (wr->opcode) {
-- 
2.39.3

