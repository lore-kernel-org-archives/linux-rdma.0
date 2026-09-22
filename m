Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41D43242BD
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038309; cv=none; b=Z3SYim2VGkCMPnOt+fzkuEreXnFQSxzuhKO0lr0gH4dd5Tev3VZ8OCJmp544gXE0rhW6OHuIl58I9Ng0FYKplB+kp+EY9AOhC16XZz/30WHcK8ribzYFvgBIULRoLyXbQFi7QOeqlduPtlUHzZhSfNikKP1WUPxSEN95aWNocYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038309; c=relaxed/simple;
	bh=5IeovYX+GNnWJkfPPWz3PJ82zHbCB5a/VmVcPwNn/8g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KWcN+i/Oenod784H/39A59nTcfig0CIQHZOI7GMhyVxiA/BdXApBCU3p2yD52Xh77KgfLdXH+eN0tSiMIqYro7na2fja2o8Op7swvlXNNRw4x4jcQSRWAfyQU5zOpRTqTXzSAMM7VZpZ+KXuucfkjXHcbaZZNV4reaL745I9Nh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cRvWwBnS; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cRvWwBnS"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-86927f9ba4dso1376858b3a.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038307; x=1790643107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFgYpjhidHE2ZpxIhrjqPAlskzKO7TNqf/whz63jBFk=;
        b=VAdIBBJJsYLgz6WBDv6A7mpdXa9DviOS7AenQqCbD7fKlGunyQ1Klpy+rJaCcWedkT
         k5OdwamIL/AkR0ZBfB5F05zF8M4bleHD6harnMt4JGLyU6qwhFHBget1gjdxnuzLCeMU
         cfZKfXcuJ07/PnU8RIIrxS+Qt6Ckv5BYspNP2shYE73Fclw87ly29oqVJ6HIj7gkbGoC
         PQWeTqAk6tNMpBAxvZnXC/zIbVavEgb+31GtXSBMtObDa9sXOJCWBFguCmnfOfwPZ3lm
         dZdCa4ZvTVf+djzX+EdaTZlivzxeAud32q4E4HOqHXTOP+CFz99jxIBLhKeiMX6Mfrx0
         Tk8Q==
X-Gm-Message-State: AFuF++kqwhjRhp48Za5cFzuisiVDRilU8Q3z9MBqURntOGbgpTs/ujq1
	ROipOqXtGpNzMHAmzJaOestGUoSiYPtwFt+fi8aDCjyokPM6mAgSscHLaTC2qMH7XLfc5jdEsHr
	woMJouWCOOut1Ac6jU9BfppeKtEcANRa/jg//AvyIi995OqaQik8qsYlTBqLTHP8hxG6sXFfUzM
	hJmhcQGH2YEU1xGx9duBjDLUGLtJgl/AgoHBCUjWcU/LZhP3o2/qlEz6TqgDx1aRRCl6oIR5Z6+
	0B05zWFbZMzvJV07w==
X-Gm-Gg: AYBFou2YYgg2dTjhAxxNL8ITR7fdrq0HaVDnNslHWvLItvp5RrSYShLbv7xW3hWW1uF
	rlP5sN7R0NYvEw6G1YB87WqQl+J6IJoPF4nBDYudcl2UYhjv5esYo0QiOd/Tpagkq4R8WeoCKbG
	54FUpDDN0bfeI46FkZ5vvVj1ANPM/ODDZMrJO0VzKDTYEQxcpcjK6wbiOLaHaZARsb/TNrDu1pc
	BOaVPI6DB0m3I3r9gCh/VF/Ad8m79YwtSzrOw9BFCOsvPkjKNEFbv+uVIxFZTYaFMzy3bMO9X0U
	M0ptlpRvx3g8UkXZ0WmIZ5JY2Lf14YIjMW7+53sCwUj+YonB2x+LkDapgAVYnFaTqRfitdkEFq9
	i7GIiWgNXMwOZPJJC0CilcIYA9Jbw/wDXkQGOxZV3Suv5bO2oD4dBfgDB19HOmXWjlwKSQ1gz2C
	yU8fKvmXYIKMaeX1XKwpGw6xKL2TKmQicl1vUI
X-Received: by 2002:a05:6a00:a8c:b0:857:7337:5db7 with SMTP id d2e1a72fcca58-874dd9f3db7mr16547627b3a.21.1790038307220;
        Mon, 21 Sep 2026 17:51:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc756a326b6sm29140a12.5.2026.09.21.17.51.46
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc435388657so5260214a12.3
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038305; x=1790643105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SFgYpjhidHE2ZpxIhrjqPAlskzKO7TNqf/whz63jBFk=;
        b=cRvWwBnSK5m4dst8HZnuem4+KbDhWv0CprvVcupzyGNQdD5K7aDAgLbnGanu5zIXyb
         1hiIimkfuC2YYLSXl5rsE+W/mp6EmhfLa+wVIfRjvoMm3NuPN/2OEVNWk0gr9b2IRBYS
         GnM+luUjPOzP81qmq2aZj8vAvIRdHfz4nGuBA=
X-Received: by 2002:a05:6300:14c:b0:3da:4cc6:17d3 with SMTP id adf61e73a8af0-3dd8c57c621mr19718453637.26.1790038305573;
        Mon, 21 Sep 2026 17:51:45 -0700 (PDT)
X-Received: by 2002:a05:6300:14c:b0:3da:4cc6:17d3 with SMTP id adf61e73a8af0-3dd8c57c621mr19718435637.26.1790038305103;
        Mon, 21 Sep 2026 17:51:45 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:44 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 3/8] RDMA/bnxt_re: Validate SRQ max_sge at create time
Date: Mon, 21 Sep 2026 23:12:25 -0700
Message-Id: <20260922061230.7909-4-selvin.xavier@broadcom.com>
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

bnxt_re_create_srq() stored attr.max_sge into srq->qplib_srq.max_sge
unvalidated, which defeats the num_sge check in
bnxt_re_post_srq_recv() since that check compares against this same
attacker-chosen value. Reject max_sge > dev_attr->max_srq_sges at
create time, and clamp dev_attr->max_srq_sges to BNXT_STATIC_MAX_SGE
since SRQ WQEs use the fixed-size SGE array.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++++++
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index c293c30da13e..f81490fab0d1 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2236,6 +2236,14 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		goto exit;
 	}
 
+	if (srq_init_attr->attr.max_sge > dev_attr->max_srq_sges) {
+		ibdev_err(&rdev->ibdev,
+			  "Create SRQ failed - max_sge %d exceeds supported %d",
+			  srq_init_attr->attr.max_sge, dev_attr->max_srq_sges);
+		rc = -EINVAL;
+		goto exit;
+	}
+
 	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
 		rc = -EOPNOTSUPP;
 		goto exit;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index ec9eb52a8ebf..9aaa2b5204b8 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -160,7 +160,7 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
 
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
-	attr->max_srq_sges = sb->max_srq_sge;
+	attr->max_srq_sges = min_t(u32, sb->max_srq_sge, BNXT_STATIC_MAX_SGE);
 	attr->max_pkey = 1;
 	attr->max_inline_data = attr->max_qp_sges * sizeof(struct sq_sge);
 	if (!bnxt_qplib_is_chip_gen_p7(rcfw->res->cctx))
-- 
2.39.3

