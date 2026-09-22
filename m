Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E603242BD
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038316; cv=none; b=C+bLoa6sSnHPJ6j9+73NGwABxy2ojIZ6F9q72VKq08XV5+NQEjNIkTwyjlpb+7IwEEvQmY7QPG2gzfF7YMulGeK7spTtRUYmiP1o2rYlRTWV2I/ZTpFZCefFmim0ussx8Un/TL9sUnTl/MQfLaezu795HQs+tbN5+iyaLsWtn28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038316; c=relaxed/simple;
	bh=IrmF0pZ3kV/+jptLCgqq/SXhAcm4VJcEQaKjuzRvCO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kKvXEvvelC1uZ8KLLc0mmk1ER7eGZipA16S4RA8TYyLF1kuhvp5AJRcdab49rH/ep24KRIV2qmciHe92mZI2xjSKRxjLELVi2ud6Ru2Up/o2bedMJmZWc0enct6J0Ky9xbTAOmfo1ESHYXg1wkkNRjoRyAdkU7eMYJFgV1v/lSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ap3vwm3a; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ap3vwm3a"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d58efc7356so24249415ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038314; x=1790643114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PxPajWRf6dCXc7YWlT40jlO5EA/ML/FsRYuXammo3b8=;
        b=DepB30W8SbZF+Zm7TTWWE8z4RV4hADbRiAx13uDEHD6JlgDzvYUamx0NDiJsKtIJSQ
         w0nCjy1QVVw5kTl999fRwyJd5duFf486W4UW2vY41O5eOC6qt3dygs28zGLkf0eK22Go
         S58t2SHugA6M75aZpUoOTh8mT9c80gRnJf4NQw+LWxtd7OwvVcvCGmQ9LDs3GeuIhd44
         j3A+2ahLIQBQwCFsUEE4LgZRREl584Pygs/VOwTGISjIiaZf1ruPfXVYFIvDvmpYS4Uj
         lXep4JpK5wkqm9CW047MrlxydFK86WHvVei6IuAWJmp+kcV7N8KNzNlDU3OhoaFCrZeO
         H2/A==
X-Gm-Message-State: AFuF++mHZBHg2UToQgouhfYTMYqEG3VqVCjBnE4AvxppE0JpkRMdWHa/
	7SCojtKAu+Q3foO2lpWO4xmPv5ZF5Zh1mw0vYsWusOwGZtFzsA1NToc+YMVLGtlbqkXlZ8wgO60
	9KC3kLiHH60oaTlrCfYalKi/qRyzNrtLzGo/ueUdeKmfCWwS0T3IBFb9v+JFSl86MV/8LundJHv
	YtxFL194M5sD2LspYuPuJ6kvG/fbuOalwo1C9gDY17A53sTqgwF109c587T2XHKX5ZGiEexehne
	2cTZdjjbdhfjZZbIA==
X-Gm-Gg: AYBFou0WgCyZllLiiPVPPUvZ2VAbIAbTqxFwWrtVJAVjJjIvpg06YHcCqIPIgNRnG8D
	RsDOD53LkYNRXx+bL5VQPNsQCGEtquSnNBDRJJBbTr7ITHQR0MP/Z8VwCJyZUrhVl5NnKHFbGTr
	3LJT4ay+fuPfJoUcrns29b1+83qtDJlOwi1FElP+0JOTn+ipaCPBFPCpV6CCxoPVOSxe5/qiruo
	Xthz4d7DbhRNqy020RLlR8puuWFPx2LGJ1lGM8kLNa6ODNeJ/xe6quPNpSX1JuQWbvc2ZeqSVRU
	gIA2+osZ6do34s3q0TJk4w0Rt2heHHBMlCBPb8bxG5iqQJvZpaKyf/i4i+c4HS9k8JRfrzHGcnL
	fE9aq4tqrhWScZrs6fr7oQ2Jc0hVf5GDPbDFcdrYe/E6UoDn/sS/NzZPW1d4XhHv0tr59ytYy//
	iHtxbeCzpnBB3gEWpOWKmDASHFecAkJKVob6fkKa4=
X-Received: by 2002:a17:90b:2743:b0:39e:6c69:34de with SMTP id 98e67ed59e1d1-3a06b0ccf6fmr665266a91.66.1790038313937;
        Mon, 21 Sep 2026 17:51:53 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a06df4bb0bsm118451a91.0.2026.09.21.17.51.53
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:53 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc7361c62b9so2844843a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038312; x=1790643112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PxPajWRf6dCXc7YWlT40jlO5EA/ML/FsRYuXammo3b8=;
        b=ap3vwm3atdCeJCXPXwKUTij1MCZkqzLvXkNejaPv4/Tw4pKbLzWsenv8LmG4E3vfs/
         HivKf2PIoJyma4806ETk15KYcU80xdedXnB9/xe5XXRqCQxXR51Cd9jAcKLXSfuqhKjX
         zPS7WrlbDm9La0gA13YzxGyVao84qdsyEMF1A=
X-Received: by 2002:a17:90b:4acf:b0:39d:ec43:3cc3 with SMTP id 98e67ed59e1d1-3a06adebd67mr738200a91.10.1790038312392;
        Mon, 21 Sep 2026 17:51:52 -0700 (PDT)
X-Received: by 2002:a17:90b:4acf:b0:39d:ec43:3cc3 with SMTP id 98e67ed59e1d1-3a06adebd67mr738193a91.10.1790038311840;
        Mon, 21 Sep 2026 17:51:51 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:50 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 5/8] RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
Date: Mon, 21 Sep 2026 23:12:27 -0700
Message-Id: <20260922061230.7909-6-selvin.xavier@broadcom.com>
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

Add a check if max sge for SRQ is exceeding the device
maximum.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 22583d2d361d..e744a3cae3a2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2399,6 +2399,13 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 		/* Transcribe each ib_recv_wr to qplib_swqe */
 		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
+		if (wr->num_sge > srq->qplib_srq.max_sge) {
+			ibdev_err(&srq->rdev->ibdev,
+				  "Limit exceeded for SRQ Receive SGEs");
+			rc = -EINVAL;
+			*bad_wr = wr;
+			break;
+		}
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
 		wqe.type = BNXT_QPLIB_SWQE_TYPE_RECV;
-- 
2.39.3

