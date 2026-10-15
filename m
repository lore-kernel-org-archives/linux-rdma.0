Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924602C1584
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027235; cv=none; b=d4qw3pTgjQM888Ese+nVQZmWZ7MZn+jN62bNCmPrGbQrFR4eJicQCfDKmWowNd9SVmVjrXRt2rIe573KNUEivpcf3c7Y+xekGu5FtTrMMTMaYIR2ALJScV3/UtMPIhAAvQCvUKysn3jnUbB+UszZqXEGfI+rZsBsKSVQemN+DmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027235; c=relaxed/simple;
	bh=jTFn0G9EzavugzJPmJvlzejlEHc3Co4QJpBAmpWNwuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/jhs82fpMABs/miTr/w9sFZyhm5ePpfNx95SKyRziNKlYs7ufJ1jKHhVn/+l2OAHWZGMI5A8M7+IUEydpBJQsFmnnMiCsHfs/4XPYMCpnHXTMZjQJcxtWRXlqUZaw/r4GfhxJ7JcQjy1Dw7SllvXqGkM2uHxZOWis4GM9h2OaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=ewOMxtdL; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="ewOMxtdL"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5e519c39196so1512362e0c.3
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027232; x=1792632032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHRdrP5s3+iqmCtgS46tJJ2/oV+nzfV5ob90EmdolCg=;
        b=ewOMxtdLOJ1G/GNbUmp3xBvif+NLMElISBB8eZ6/va+owDVoCMEZK2R3hFR0B3Wcrp
         5215vekRCLYg6Z0cXkZynLZb4vMAi0E2fEF02Tjd7gshjWU9LdsLEW9EiJ4/YbiHEez1
         QIbplk6m8+exm3+cmiAcTsxG5wub/fafWFOvA/V2x5ncAjXGNKBnPq5b0/HwP7F4lLSO
         P27vFF8kp+Uhpkaxg0zdcWteDE6/mjRhscUP4YB0BEqDwevC0lYydSUkQ7c6csCoZ5qJ
         BjY8zIpDDZhp7iHUarieO3UFgieNxgxg5undQSmJqqcVMus4ALXGac0ZzA5uJH9A8TjO
         u9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027232; x=1792632032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHRdrP5s3+iqmCtgS46tJJ2/oV+nzfV5ob90EmdolCg=;
        b=KrE19QcGBZ2vajv1h5qH1jK4mXMctUjxxdeWOHb4QOPQhx6026uvxZOp0g/dtALa2c
         hxQmnGa+AYEX//dqo/52IlSb66djSzO0kCgWzpEMUvQcUAq/0MXUFAsm+Jo+nI386Jgd
         2HIwrOB2HPsnTlm08QMfPxwzZxFhyPRXuvCarAFkp/w6BhLHCnao1j8SFE4quB88JfOh
         U16dp+ChZlgE0112DTRax8NzST7hEwqxAqAwNdS3/pHd8lE1qnM42Tt/v/aek53GLSQM
         Z1/CKiL5Ms0OauaCZQj5zaPPAdUDraCHpVB9WDdqSzqujaNio6zDJsXYUdwE3McsqZk4
         mE/A==
X-Gm-Message-State: AFq9FYLZeWqPkWeKJsuI33fb1TNKJ0vnnAzPtRgjI5PEH+QtEDdmSIw+
	HPxE3nOvEEYTFtllKhdN2ee0xjDyGZ0hjdT+7LBVFWux/FBFUa7QWERX55yzCN8ICuyf
X-Gm-Gg: AYBFou1zsQw/6i/l7F+9qVAmFaNKoYp/YcJXfLKxAcQaT/iUGW4d6GmudWSsq0ETvNH
	1viR3N2a6jpRzswQHAzAzD3te71coz0+dp+CN1qeI1ACvwZ+BGw2iz6HYQkDtDHIVO8h4Rao4d+
	C4Fsrxc9I9NXUAjeskSdXp42atSdSDg1f8U1MBrEeUo3FlYPA2CPpetyF+Bw9hh3Lxi36zmtwV5
	HSmk27pyD2y8lAKmLH3WCqFavJ1lV0Kt7xC2TMVdfluxWOVD/TWGzpGHBJc15jrS8YOlUTuvMm6
	HNUk/DS/AClxbujf/rdICXwpn3CsUu/jQoSt+2vIqRdoIC7xT0v8NF7h0p3AwXQ1LBQtLmie+vp
	F8+ua46/sV6FXMci+DYJbH78NBNdkOESLxPp4/Ac7IOE1+CjGrsJb8m2Eipf9gIwJ1XbNjBpOLo
	wc9+seSrB1AHZHWecpRPGPVQQHJxExnmS3F2LFZdLFuxkOCqXUz0Tco9sq6roFAthh8TVo3SS5K
	CjMm3v2YZsmRK77UKhxwHo3VXJb7wyXQkzpC5bMxZ0YFLZGgvfd8q3gyl+dA46AQb1Ndap92RBY
	WIhjLsootg==
X-Received: by 2002:a05:6123:107:b0:5d7:7ee1:c678 with SMTP id 71dfb90a1353d-5e91f524633mr6008127e0c.16.1792027232415;
        Wed, 14 Oct 2026 18:20:32 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:32 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 1/6] RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
Date: Thu, 15 Oct 2026 01:19:35 +0000
Message-ID: <20261015011940.4122452-2-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015011940.4122452-1-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

In preparation to support modern UVERBS ioctl attributes (such
as UVERBS_ATTR_UMEM for CoCo DMA bounce buffers), we pass down
`uverbs_attr_bundle` for inner QP, SRQ routines. Since standard
uAPIs provide `ib_udata`, we derive it via the helper macro,
`rdma_udata_to_uverbs_attr_bundle`. `irdma_create_cq()` supports
`uverbs_attr_bundle` already, therefore, this patch fills the gap for QP
and SRQ.

QP, SRQ uAPI will now have `ib_udata`, and CQ uAPI has `uverbs_attr_bundle`
as a top level input. However, we think it is a future project to unify
them.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..10c790fdfc57 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -637,13 +637,15 @@ static void irdma_setup_virt_qp(struct irdma_device *iwdev,
  * @iwqp: qp ptr (user or kernel)
  * @info: initialize info to return
  * @init_attr: Initial QP create attributes
+ * @attrs: uverbs attribute bundle
  */
 static int irdma_setup_umode_qp(struct irdma_ucontext *ucontext,
 				struct irdma_create_qp_req *req,
 				struct irdma_device *iwdev,
 				struct irdma_qp *iwqp,
 				struct irdma_qp_init_info *info,
-				struct ib_qp_init_attr *init_attr)
+				struct ib_qp_init_attr *init_attr,
+				struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_qp_uk_init_info *ukinfo = &info->qp_uk_init_info;
 	unsigned long flags;
@@ -981,10 +983,14 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 	struct irdma_qp_init_info init_info = {};
 	struct irdma_qp_host_ctx_info *ctx_info;
 	struct irdma_create_qp_req ureq = {};
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq *iwsrq;
 	bool srq_valid = false;
 	u32 srq_id = 0;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	if (init_attr->srq) {
 		iwsrq = to_iwsrq(init_attr->srq);
 		srq_valid = true;
@@ -1071,7 +1077,7 @@ static int irdma_create_qp(struct ib_qp *ibqp,
 
 		init_info.qp_uk_init_info.abi_ver = iwpd->sc_pd.abi_ver;
 		err_code = irdma_setup_umode_qp(ucontext, &ureq, iwdev, iwqp,
-						&init_info, init_attr);
+						&init_info, init_attr, attrs);
 	} else {
 		INIT_DELAYED_WORK(&iwqp->dwork_flush, irdma_flush_worker);
 		init_info.qp_uk_init_info.abi_ver = IRDMA_ABI_VER;
@@ -2337,7 +2343,8 @@ static int irdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 static int irdma_setup_umode_srq(struct irdma_device *iwdev,
 				 struct irdma_srq *iwsrq,
 				 struct irdma_srq_init_info *info,
-				 struct ib_udata *udata)
+				 struct ib_udata *udata,
+				 struct uverbs_attr_bundle *attrs)
 {
 	struct irdma_create_srq_req req = {};
 	struct irdma_ucontext *ucontext;
@@ -2420,6 +2427,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	struct ib_srq_attr *attr = &initattrs->attr;
 	struct irdma_pd *iwpd = to_iwpd(ibsrq->pd);
 	struct irdma_srq *iwsrq = to_iwsrq(ibsrq);
+	struct uverbs_attr_bundle *attrs = NULL;
 	struct irdma_srq_uk_init_info *ukinfo;
 	struct irdma_cqp_request *cqp_request;
 	struct irdma_srq_init_info info = {};
@@ -2430,6 +2438,9 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	u32 depth;
 	u8 shift;
 
+	if (udata)
+		attrs = rdma_udata_to_uverbs_attr_bundle(udata);
+
 	uk_attrs = &rf->sc_dev.hw_attrs.uk_attrs;
 	ukinfo = &info.srq_uk_init_info;
 
@@ -2470,7 +2481,7 @@ static int irdma_create_srq(struct ib_srq *ibsrq,
 	attr->max_wr = iwsrq->max_wr;
 
 	if (udata)
-		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata);
+		err_code = irdma_setup_umode_srq(iwdev, iwsrq, &info, udata, attrs);
 	else
 		err_code = irdma_setup_kmode_srq(iwdev, iwsrq, &info, depth,
 						 shift);
-- 
2.56.0.385.gd3acb90ef8-goog

