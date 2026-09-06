Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756933CB2D0
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788716771; cv=none; b=GGoHM1claDSp1ZwJe3u/5Ahf2DB7O0aCet+1S9BbFNR+HvUBrRxTMeaJy9s3nFQAzJtDEM95wzVMCkhA2n4IxIVBKhqZ2fZedU6BGMamTK2sjwIUsMZ+Hvs5gLDjVgWSDRfdkv6PMoxWIPbQ3BOmetEhp9neGrSGoO8OdwMXiUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788716771; c=relaxed/simple;
	bh=brRb//m+/m4Lv2qomnZdmrwJSKqqphUGq3K+gMNECy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fGw1IYvtyY1pHcM+o5UEhDA+4bnVSEbN2GGKiZCv0UaSaCoQMkUGQsrq6Ai3Y1stTRQyAxlc6csuH1VmGwzZKHYMYTyVnhks1e2Jb6hO+N5gmikxDr1jfABFopeahGby6qqM65DlX1JUs/8WPim7g5mCRmyYdrPABTT9/u0CxN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Zf+G7DN/; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zf+G7DN/"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc1bcdb3c4cso1831382a12.2
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788716770; x=1789321570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=qRVr5aRr1pj8x2VGEraum8sgJalleqIm8eqXXSWLFt0A+nz93o64jMU9VnidrCHQeK
         hvoNd2Z/pHAZ2DWjY7Q16VovJ/Y46V48+OBZ7H9rQI8mi6gpBqzvKeXl8TwdizUwAMAU
         DtK3AaRTPnFhyE/ca9etPPDR/hZDuXoie2qAgRqAd3v2VvPMtmLB91B3LhROTTTwO6Mo
         pwGe3ko62lM7JUtj80hdPZUAARya9jI8t+e/drjWkjwwtwK+jptcS+PU7/unL+jSIHkX
         kWVWe/6/yvq4+7EndHUI8VHfkxqq1CWqan24F2dHkRyUaI25VH5d6XUa/1buXcypNNQn
         iOOA==
X-Gm-Message-State: AFuF++mvIC9hBzumHyFrgUZncpgVIEfmOggW1I4Vs+4K1N31w37zKi/s
	XjynPzL+0DckgXv7vY39GmCBjZOTxxFWP2Y98afEjcfPa4ulKlwrqkd+AjnYjHGFmXiZno51xH+
	4GlBLAx6Iy9DZOy3bWj9n5ZXwYcuPv1SIWDWCwNtfGyBlsLcvqZ6CjvnisuRxB+qCCb77JaW5ET
	Al5xA3PxH+X0pInXa6WXsGmkXWXlUm3FScVc+U6l+SwJHYCeRmbT0r1wf7YgDL6P4OOZ/csFD43
	RjtlfdpGWRNdGlrKw==
X-Gm-Gg: AYBFou2SkP+8q0dssg2wLX5suYFcd6gH5mYgtziZsbHq1DTY+XLrwkKu35tsZE6gpPo
	YdaH4rar0ubimQZ7ViZS1bPyxsAJq4zg31xg9kMJqUzjUtafRgvkndVcQGReZYFNtdZ1qZzMt9J
	sRZoI8wX5Nu/OwE4sN5kdg60m+0nGiiF4c0kVPb4ErT6u5qosS4HG7v6OvcYRcLNfsBv/29/IYt
	Uz/EsMSyfeZRjoLPa6mQXML0Btthp6sZgKTTRjSX0HaH8KX9vTpxHYCR8czRs88K/GeTCwJVcOp
	tbjI8WIbe7cRA5ViswZ0fV/4k/CVWp5ThEdpDqB7iu6ZKCD670RJE8I6vVMV6C+HmUDzlxiHdHj
	+2++neyijXu5InFrlWHmDOfjrzKEj/YlfAxKlN+r2eO41tLsR3NfJar5VICzJgoUcrNMIe4FONd
	+PJgpaT2LpsEMWxARXhwncboc8wBglepDCo/Md0yQ=
X-Received: by 2002:a17:90b:33c9:b0:398:c16e:69d3 with SMTP id 98e67ed59e1d1-39b26122fbamr25691760a91.1.1788716769785;
        Sun, 06 Sep 2026 10:46:09 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b25fadaa6sm5347347a91.1.2026.09.06.10.46.09
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Sep 2026 10:46:09 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398d7e0f3b4so3428118a91.3
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 10:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788716768; x=1789321568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=Zf+G7DN/5gYBNuO+DWN2E1MNKU6aUpGNuU8hdVklgjKibNH9cyBWJiFXfTiwy3aBnX
         /GdhXIF9YHLUnl73MCCKpJ28Z2d75rgyiMHghrFvPPHaMpkdVIe7bMdUTEuv0hKu4RWs
         eLSPs5mIWmpw0eTCPjevh9A6L1tgstUVXvnxc=
X-Received: by 2002:a17:90b:57cb:b0:398:9be6:f998 with SMTP id 98e67ed59e1d1-39b262e2139mr29603919a91.23.1788716767855;
        Sun, 06 Sep 2026 10:46:07 -0700 (PDT)
X-Received: by 2002:a17:90b:57cb:b0:398:9be6:f998 with SMTP id 98e67ed59e1d1-39b262e2139mr29603841a91.23.1788716767253;
        Sun, 06 Sep 2026 10:46:07 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3356dc5c04dsm11075108eec.8.2026.09.06.10.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 10:46:06 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 7/8] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Sun,  6 Sep 2026 16:06:59 -0700
Message-Id: <20260906230700.12233-8-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260906230700.12233-1-selvin.xavier@broadcom.com>
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Selecting between BNXT_RE_NUM_EXT_COUNTERS and
BNXT_RE_NUM_STD_COUNTERS relied only on
bnxt_qplib_is_chip_gen_p5_p7(), which doesn't account for the
extended stats capability flag or the PF/VF restriction. Use
bnxt_ext_stats_supported() instead, matching the check already
used to populate the extended stats, so the counter count stays
consistent with what gets filled in.

Fixes: 8238c7bd8420 ("RDMA/bnxt_re: Fix the statistics for Gen P7 VF")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 651cf9d0e0c7..575b97030587 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -413,7 +413,8 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 	}
 
 done:
-	return bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
+	return bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+					 rdev->is_virtfn) ?
 		BNXT_RE_NUM_EXT_COUNTERS : BNXT_RE_NUM_STD_COUNTERS;
 }
 
@@ -423,7 +424,8 @@ struct rdma_hw_stats *bnxt_re_ib_alloc_hw_port_stats(struct ib_device *ibdev,
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
 	int num_counters = 0;
 
-	if (bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
+	if (bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+				     rdev->is_virtfn))
 		num_counters = BNXT_RE_NUM_EXT_COUNTERS;
 	else
 		num_counters = BNXT_RE_NUM_STD_COUNTERS;
-- 
2.39.3

