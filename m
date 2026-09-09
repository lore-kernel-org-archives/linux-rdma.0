Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674342192FA
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788942562; cv=none; b=kCwzZbBZZ9lLainPjXgsltyrRa3IDr01S6bSFp9a0+/T/2rv7NjwNHivoBxVUF9/DZxM3sufZn1I6lqYY/WXtmRmczfMfn9wdGuOGrh6NKIbunlBdXPxfUIMKmNimyn/QjIYT892N7CnPuoyv6tPWjIS0tzgCKuB3FSSzOX0Fu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788942562; c=relaxed/simple;
	bh=otTS3tcVA4IVxcFRmMXjpKGDYyshBZbawkRvXrlWSuE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ltVaSXWgdGf7XZn7f+0knMzdn7VL+R0buAXAFmLcnZdivk/g+KPG0YqHWWQ4NET+3Euv2tSq3bA9Ni8fr1Bo8H404K8eB9U96cJOyxp1pLnCdb4Lcd6m7glWy/Sw8gBSHEVKJ23IEAIWSXENJrBDbQEUMBqQdr6WVO7sELfGF1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JgwSuUiK; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JgwSuUiK"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-853c07a76adso5351668b3a.0
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:29:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788942560; x=1789547360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GJ7NXtG8KT/Nkh/AdNTsN9m1UyI+HMg3XwPiCeRLzgo=;
        b=ZksHXU2XeXhtRSNTuZ9/+7ooSDWhOYowuXfvqiDrvCzZVnnnjuHfmLirBFzN8mngvq
         XkwStkMvAM5jLqEbBFQJwl7nJGtQTe4SW0CrwevHRWXLYdL1sUOXO3Ch2O5uR/rwLQyi
         PEGQfqhfYKoFMOpCjLtFJse4UP2VByc/mw2xfbEl3gRf9DLGbjtNaglLecAYwOzBMFly
         Ltx6hiDmBeXw3G8t/0xpgReyStYDYYqFieiCopmKbAY+p/HDLy2IJthXg8VmFwibEtkE
         rqhkXR0PJXJ/QXrrnAQGC4QSI6FY9GjU+i06+sNvhXehYSrcqhrwBzt29DKCn+otWlW+
         LGUA==
X-Gm-Message-State: AFuF++lQ3J/NkRU5IpdMH3l6vE/uyJ3yHVvwGi8tO0g3vreD6ay3CP53
	hhgoD4saztGSmQRbY0gVCOCfTP8sJoume1kl4Yh2bZWCnxUD/dQ3Py3MvSriULnqycpXBOmHPDZ
	UHv9RLP6St/dfX35rRwl3aDHATlHYVchY3HNOeUEZnis8iGU1vMNYFPTqrHGyCfiB3fFK8NtfmM
	qXT+OXg8C4D33ywBPQbwOcwot8or89ZC9U+ZF4p7IsNC6OqpCPfpslNV3unxCMDtffH0/9y8ORl
	Z8G/OH2u+vzVckefA==
X-Gm-Gg: AYBFou1Lka5ncgVTLEcMUONQIYJFL8Tq35LEVbBTqUW7gha18oCrXF6S+yrnfx04Nj2
	vnA60kGjIiAlotplyXuHc+EP9xnqZ9taoUeDyNCy63PW+odUrfv0kfui8KC9UVON8e0KiUzLLNo
	28QGkeAEVxSwoEbuedcmLRO/ewaP3/YN+ttrMao3b23ptCeJ/UoPSg/BOUMeSz8/UtH6gKKVPDs
	kNb3pVEl9gpPMHS34eQ7VYWkewWFP1jbsJ8fp54MRcvATAxF3nsJe8gG8PARHvTqrN6BUcDskwk
	1I8EMGPN2lpy2V6vT3t+ZL+BepEE7u03xF7Rq0xIzr13XkLB6nqIomcUUmBqBtp/ZWXFptpe8f8
	wqXpO0fpzrYKegNnWWOdFIvdhGyTq97AXtsfAw0vu+nXlG8s+WymBiPAWZ0RdNHj0nHgTfPL4tD
	BCXgJAzy8M8LMggYAVtmrG1Xhuyt7o5r7z4d2o
X-Received: by 2002:a05:6a00:1a17:b0:868:d657:3dae with SMTP id d2e1a72fcca58-868d6574063mr2147875b3a.11.1788942559643;
        Wed, 09 Sep 2026 01:29:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-86150750042sm4990094b3a.3.2026.09.09.01.29.19
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Sep 2026 01:29:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so6842287a12.3
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788942558; x=1789547358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJ7NXtG8KT/Nkh/AdNTsN9m1UyI+HMg3XwPiCeRLzgo=;
        b=JgwSuUiK3TPULngVvJaMOUfgHmtUFfMMH+gimAEHMNu8v2lBXAuAuRLVF3SJJ3TYbH
         sA1jIcNnCaOmNefLHvdtdw99f6XWS36pCDfnZavSL508wwZbjwroXjzYx3Ny0qpYxkeO
         zxVbqy4BFR4HhvmwshuAVYl+Hv9ZdGt+o35mY=
X-Received: by 2002:a17:90b:1c8b:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39b26214502mr47256826a91.19.1788942557827;
        Wed, 09 Sep 2026 01:29:17 -0700 (PDT)
X-Received: by 2002:a17:90b:1c8b:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39b26214502mr47256771a91.19.1788942557294;
        Wed, 09 Sep 2026 01:29:17 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432423f99fsm39157065c88.1.2026.09.09.01.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 01:29:16 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v2 0/8] RDMA/bnxt_re: Fix input validation and lifetime bugs
Date: Wed,  9 Sep 2026 06:50:11 -0700
Message-Id: <20260909135019.122711-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series fixes some of the bugs found while auditing bnxt_re's handling
of user-supplied values and object/device lifetimes.

Please review and apply the series.

Thanks,
Selvin Xavier
 v0 -> v1:
  Handle review comment about clearing VM_MAYEXEC vma flag

Selvin Xavier (8):
  RDMA/bnxt_re: Reject executable mappings of the DBR and toggle pages
  RDMA/bnxt_re: Detect wrong sge_len passed for inline
  RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
  RDMA/bnxt_re: Validate SRQ max_sge at create time
  RDMA/bnxt_re: Fix rdev lifetime races in  suspend/resume/shutdown
  RDMA/bnxt_re: Fix the PD and DPI table size
  RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
  RDMA/bnxt_re: Check is_in_used before trusting RCFW completion

 drivers/infiniband/hw/bnxt_re/hw_counters.c |  6 ++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c    | 26 +++++++++++++----
 drivers/infiniband/hw/bnxt_re/main.c        | 32 ++++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c  | 12 +++++---
 drivers/infiniband/hw/bnxt_re/qplib_res.c   |  9 +++---
 drivers/infiniband/hw/bnxt_re/qplib_sp.c    |  2 +-
 6 files changed, 64 insertions(+), 23 deletions(-)

-- 
2.39.3

