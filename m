Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C4B348C7C
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038327; cv=none; b=piM2mpyA1g3FJSRhSwhyFCjTED2303zu9Vdx/8PZ6zkRWQDgPuBhbEtamEFMflWzerj6JUHzBHQj4cb/1IQImBTxZaJRloJ3BXkI/jafhtaupCvnFs8zDs2Q/HN8eiF2BdSYLjK+rMrhBRYEoyqzVXSL/0eSG5zYGOPKZzMsxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038327; c=relaxed/simple;
	bh=brRb//m+/m4Lv2qomnZdmrwJSKqqphUGq3K+gMNECy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZCMa+HjvUrDp9bt5qlqkt5Iom145sje75lq3m8Yf4UhXCx9azEB702xkG7VsO2JI56HVGvsNRIw5h0V/gSzrifcqb5XgSRyPGBxpS9ltCIG7d9JdVdp8b42KTsuUpYM2jolj8AkVZA56Pc/ss18d2kzY7uGzmLZmrYPmNZJ6QZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LX97Itdf; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LX97Itdf"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2dcff8f44f2so25442335ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038324; x=1790643124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=sX/1ASQvbUH1t/SXCWcZk4u3ili18g2fnNm0JIjaYBH/JSht/h5zWIiEIiMzgaZ3Vv
         Ppp/aDlVP3R1RmBYR+kvCsvf1xHOqTbVUatzry5mVBaR/ee2TSn5h0z07t2TLNUCC3HP
         15kqGR+uP0pj2cgmi6Ue0AP4lF4ERBfqBBULyIIldnL0NGvVwOUXkfHknwRdbOW8Xjb/
         6oTwyjVe+RaPHC/dfr8DGlUuEiwDBPoRPFiid2OIrrhx+YnPT7dcS7AOpQQ7F2oRGvqp
         MzQRq/9MfFc7LMeiMZSSqkz2HmRn6nGmG8aroCqxjaEirF6NbLTH5dti+8nB9CX5AiWu
         1PDw==
X-Gm-Message-State: AFuF++lO1U+EToLM2Plo85/grxT8FLaXviijbQTiuCCNBDVsVfbJcyIp
	/vLCF7uCRLq//9HOpZIkVVq4DFhBYF0xD9lr/KDBHIbeid7xRQ2eYS+51eJx+dB8B+Iq0DHTNBy
	PGvFc/gNil7mUnuuwIluRSNQiPlAIXND7qjF4jZMmoLxHLLJIiXzXs8HmQtMd/GNU34en7PpbLT
	idoi0ckR9JitF9iISd9O98GIoWCEA4lkSS1G8mqA7bVI81Ux22HB4JP3WCfBrkVyVI6KZRLRvIv
	REqr6XQGvyxVzQEzQ==
X-Gm-Gg: AYBFou06vCO4ug3eiPXwQYvNipD4lBWoQAnRcctf6Kw8RhXUxBpG2ixLxwuC5v+SurP
	g2KuGf0sOwzJihvTBNXATlKiODwExg0CrLrpb+CU8XiUwCrCr+/mbcwXNjIJHSpfRnfphFH7R0Y
	xDpFUsHclpqEGhlQyIZXzhagUZAsxKuunW9qeI1mlYa6RIDIFrVDgX0lP7x6gGBwuP82pVvfl75
	1+kHYJnEPBKl1veys2XTflGnHuyntAhA1tgPnnZSjgSNxSbk7IevadvOP7hkoo95Fxuk11elI4U
	gT2rlOBVSm2QKxJ1ZiTR3ZdPVTXJIPHY3ZrNOwZWqtcQx0fAtvXmEbkg3HEZ4NxFol3NS0WS+Tp
	67Cjb3+zFsLplDpZ3NoKzvdouRgwPUTaNEl5nTzg4msa3dP6WAsQjxm5rKIQcvk5kzpzqrh514C
	EMaJn3QG6+YRp5eeaGQzDmazLesniZuY2CHkDGIyk=
X-Received: by 2002:a17:903:2a8f:b0:2d9:1dee:43db with SMTP id d9443c01a7336-2ddb1b7ac15mr185970695ad.15.1790038323904;
        Mon, 21 Sep 2026 17:52:03 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2df5d02dedcsm168945ad.27.2026.09.21.17.52.03
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:52:03 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d6f75c1219so76983465ad.3
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038322; x=1790643122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=LX97ItdfJBJHGz/qqn+0IIVyydQ/iK94urcA0cJmJpTw1ABgViI7EEBvEpZDoWZKxf
         Kj5e/eG53y7hlkkHJIp6G1XJ6I2e7gq+Y9pANrs6+cLZ5Qh1iwPUjq+G5i6TmccdxyBq
         haxUkMtCDGreq+dXf0PpzTNtbLHv9adyABkPE=
X-Received: by 2002:a17:902:c950:b0:2dd:c100:312f with SMTP id d9443c01a7336-2ddc10031e0mr115436595ad.43.1790038322037;
        Mon, 21 Sep 2026 17:52:02 -0700 (PDT)
X-Received: by 2002:a17:902:c950:b0:2dd:c100:312f with SMTP id d9443c01a7336-2ddc10031e0mr115436425ad.43.1790038321634;
        Mon, 21 Sep 2026 17:52:01 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:52:01 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 8/8] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Mon, 21 Sep 2026 23:12:30 -0700
Message-Id: <20260922061230.7909-9-selvin.xavier@broadcom.com>
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

