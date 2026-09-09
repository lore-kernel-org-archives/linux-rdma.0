Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F49A478E5D
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942699; cv=none; b=R4EhDSvhZs94VrhzOjjQZ2/ohhcwxGIrw6rhor5W9HcTrOvL1Nk81jbLdn/NerounHL2/VMdPAfzE3ftNt0znKvLGt0z6XptapXEa3yJusF0haKUz36UidEdqnOKvrD6sZ8A0Y+xixwzjbnDJZEdxNgzciKiP/f6axa29Lrw66M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942699; c=relaxed/simple;
	bh=brRb//m+/m4Lv2qomnZdmrwJSKqqphUGq3K+gMNECy8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eHfOrxeUihbeotlQqotZ+32KfmB5kSIL2qq1A0d2fBfV35lZuryAss0x7cwZYWAcjmAke6Zn3Fc0KXKEIVW4yd1hbQeLn+Lg0ulta76CkRsuCvN8rwf3XCZ1JUl5f7YYJJy/9JOjJiAt41Ave13V2o1HcYtlj00CfvHTGCaK3Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RsNoo+K0; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RsNoo+K0"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7f4f3683fbcso5433841a34.0
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942697; x=1789547497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=iKSg3ACkIhZ2E8siMnUwWPsTk67BqIqPcUhkFCqM2ScHiVniQ8qdLbAfVFbLnTosWY
         5YaNO3yLwVxCWbfqZWt9Mmc1GPs/XGla21HIWFK7I4a0g3crLEuSImN+b9NEKD8ZIqfo
         JEelLBlPI0FG41iCAw5eCX20r2mGo9BG912rX5xYG06teDnufzEiGyjQ4mTWmBvmEayb
         NxUCyNZiFEq0XHAf43I3KpjvXVX9jGJUfeZoIsW45NXBEb5ks9kjofhLZ981mDOy6sUC
         9AAdahxkQvc2l2VdaRLmKRmEVmREgmX3El2J9p1MNRwiI3waU7oMzGD0S+1O2VvjZxzg
         FV2A==
X-Gm-Message-State: AFuF++ln0S+ntiCWoBsfuX62QTYOMplUBANETp7HaecTYr78kj58FL6u
	saSU/1gyNI77Pu5eM304za5CkLg7jAN+d5ZLRtFlzRGTwrS65SwvdFN2E9YqON/pf0CprdHTanO
	t19C8AuSdqzR+ULxcUTS9R4uGOYmmroMwXKXyXAhKemfXhi514FK9zneTZv4eHJXJQc++Kx1Ns9
	oDMg08zZvwANSEfhYQ5T6bp+H7NgRLpjxRzsLRk7oO7l+fIk9IUiXKXCIgvlJj8JJRB4estEN76
	s/vFIp06LF1YnqlgQ==
X-Gm-Gg: AYBFou1rTYdSzwytKn90HpdF5MG0ERNe/8BKtp+hb1nLGCCo9dU02fZcnCdZqDLyTYr
	MDg+5PVd1JihIxhXKSmnCBHQDV52SFXU/MvIQgD6dx3SkI0YvGoTTNzZaK0+5Onz9aR9KbDBUOc
	7sexE7u9JzDlBpRDGdt/4oTKK3Xu1KrLOS99HNNH9m9HyCZvYTv4I8bGprNlDH3u/UJlZoYlG7F
	6s9EhTRv20ipbjCHGbr1pAfFw90EO4q3kHfFHXUzjHt4BJCL9DffxPTiSJ6IKGhHMiMOl/ujUqg
	hVEw3y8r06130yNpxY/uYXu9SIDHQ/4N3KqExDZ4Tj8Dn5HJCz8PeJriY2sPNmvBpfx+pgFRJ9r
	nVRF85gqhKwsxLxSG3rDkIZYixkY+8r3D2f1YhvrlJhaLM0YQa0rlz993oUgMux+8jtBEqsG9Ds
	FyB2n8ZpaExak89DGVrxO7PaxjXRPX+YtCeg==
X-Received: by 2002:a05:6830:c0b:b0:7f4:3902:3a26 with SMTP id 46e09a7af769-7ff475c2afcmr4608251a34.1.1788942697113;
        Wed, 09 Sep 2026 01:31:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f9f668f694sm2121182a34.4.2026.09.09.01.31.36
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:31:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso6635878a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942696; x=1789547496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ru1DueZqhWiwjCwqgljsC86WrC8vaKrn2xQzdYgc9no=;
        b=RsNoo+K0UKPU02PnjSBou6LWuD/ff1yaASuY2Zb5owdd58plvrFK+IOtIA6aDwSFgS
         eVBoa+HlfzAlcacb5Zw07FLyxPGvLJqtwuKeh6Si1YOnk3YzHLe0rp1vSs/jnsRyiIiI
         hbNb1VsvxtGGy7iOtonDds2BWxOoQKlZ5NBDM=
X-Received: by 2002:a17:90b:4b04:b0:396:4ce0:6400 with SMTP id 98e67ed59e1d1-39b07f33963mr43365397a91.2.1788942695539;
        Wed, 09 Sep 2026 01:31:35 -0700 (PDT)
X-Received: by 2002:a17:90b:4b04:b0:396:4ce0:6400 with SMTP id 98e67ed59e1d1-39b07f33963mr43365359a91.2.1788942694980;
        Wed, 09 Sep 2026 01:31:34 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1433171a97esm45999620c88.12.2026.09.09.01.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:31:34 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 7/8] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Wed,  9 Sep 2026 06:52:43 -0700
Message-Id: <20260909135244.122747-7-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260909135244.122747-1-selvin.xavier@broadcom.com>
References: <20260909135244.122747-1-selvin.xavier@broadcom.com>
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

