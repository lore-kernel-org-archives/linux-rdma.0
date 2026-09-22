Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E434388F
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 00:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038299; cv=none; b=b+0hBYSOxQIiWtuEXXwrL9/BxcQaoeLaG4o2OGUA29wy90EhUqoQaO0z1T836ZX8Ua8nEcr2L1t566fzOHiath2iXy7ElUM6M7gK8vEyUAFk96cJwTliwdcw8f6cp2NG5oTma/BlNVHa9ZbhwL37HPj5y0iQvicnXGwhXIBR4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038299; c=relaxed/simple;
	bh=W1crlmUc8tjYE46U3hbMiIxqVXb6PPXFj65xZX5yIWU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NQUbjGScLztvC1KBO/XGlwFZydXIRzKgB5TXc+Dm5nc7BPqhUBaBqK0qiV0TwKG0CyaReUgxt08lGMchPLkShOqi0t9NVZMZlLVonSLPKKyK3DWPP3o1qcH4clHQo97Bi+AsGLsIbHZSm9eEVmzlBS5F1Vv/32xYnF6ht+2blRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=P2S0z0lB; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="P2S0z0lB"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-38e58034d05so568763a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038297; x=1790643097;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AWu0V8OCGuJ12PIXuUbua+1n7n7nvMfRgMFKCr4SBIs=;
        b=AZSxWVZNOlHrFQzWFKmced5raK6V1/IPVS/ACVBFXD8w9ZtjBMuXeJdqSTsP3/D8BQ
         43MlmSdMq8TTlstmWA6VTq+gu2E9UipcJ2w6Qq1yAApVfBdaTlD8NkA+Io25pGYo9vvB
         sTxTLVmf7ZEGcBuNml0MxEuo0KNBclv+84/M+KVvzjagk8+uVX7+2alDPIPxMmp/mA9S
         /sbVZrQmwToJSvWUZnxq5JBPXd7x+964essZIo+z/6c/E3Ki0vRtYOUjSyaLkANL2VMW
         7uB2q9Bzw6lHGzmXHEzed7Hbuz/e2GPc/+yco0D1C4AgXeUep0L5s4xii353+AYD2SPq
         75QQ==
X-Gm-Message-State: AFuF++lJg/VCDzGOIki5mOFKnvH+4oPTcrs1SzVmHRIAVPdl0qJ3HWzi
	iRL53XQIDWs9TteKq53QNtt6+1XvVXqbCmp7jI3wRA/wTauFfQ+eDUq39ISBFcv6Bn4aR2evaHf
	2m0Z/Nyv0FEAe66jeD5Ca31pehYeiBibclzCj1Dbfvft7ecaPEhWFVIwN/B10lsPXYngckA+ahy
	zu9lQMD08lm1nuPUhWeblhmaXbvVaTkEMiOwhoknnf4UMdz99Mr54J5miT/Db3kU7LIubDxJlwZ
	06jG5k9/xubaP21nw==
X-Gm-Gg: AYBFou0+WQlTS26rcjrxL1cIo0CcKmksZayY3wEDfySGSaTOMEzgv4UjvH1e0beulqW
	Q8/KVmSJP4lwMWSii0NJb7EktKLgi0QBUXCP4fio4tBFz0YxIqTAWxh8h/9LQHLRvLuz5IN2Elp
	r3jNnGQJRt0HgOMWHTS7FoXa83ajQz5VMZ9zRWWWM0tAIiF6vu+YCcefgC9FgcN/8Icir6xBOWD
	ONqLAdO2zCO8lbOvuHRl4AW0Iy6fEA0WDArfSBQlaHOFhXiFOBePhsYfQXPiMosJDYBTyuKgjLs
	w5sNXYyOxCIQeo9P/PyaY1c7zpMAKgLCar8nfIXkxT9v2E2+OXuwW/kHVu0C2nlVCbG7oZz15VJ
	uAsesYsRv3geQ49VUTAMWYfFM7FROo8hapZfNhwVCHGSZal5JVaWRpyUqFCTFPkgrW5zONa4dFb
	juCvwPpkQax4m/7lhgZSFBaR2MxQ6ayifa2DG0
X-Received: by 2002:a17:90b:2dc3:b0:39d:e9b6:cec9 with SMTP id 98e67ed59e1d1-39e54d36756mr22892826a91.7.1790038296679;
        Mon, 21 Sep 2026 17:51:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a066ab8102sm625519a91.1.2026.09.21.17.51.32
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2026 17:51:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so44603625ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 17:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790038291; x=1790643091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AWu0V8OCGuJ12PIXuUbua+1n7n7nvMfRgMFKCr4SBIs=;
        b=P2S0z0lBCGc1l7N6sTwmAvVPzq5rGd6s7iocT4lAdjRO1Ud8DkcbHwHmi1k/mn2w+i
         +oVoENvW+r3g/8cWpwT6gCp7mqGpt40BEE8Y7raJDYaY0L3MHi6WzZAFSJISFAIjPP/0
         y7toQhoHsJJ1JKIvpfZf/tHkpQwHDiu6gaibI=
X-Received: by 2002:a17:902:fd90:b0:2dd:c053:82f9 with SMTP id d9443c01a7336-2ddc0538482mr113624645ad.48.1790038290817;
        Mon, 21 Sep 2026 17:51:30 -0700 (PDT)
X-Received: by 2002:a17:902:fd90:b0:2dd:c053:82f9 with SMTP id d9443c01a7336-2ddc0538482mr113624445ad.48.1790038290350;
        Mon, 21 Sep 2026 17:51:30 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e61340e56sm804218eec.30.2026.09.21.17.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 17:51:26 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc v3 0/8]  RDMA/bnxt_re: Fix input validation and
Date: Mon, 21 Sep 2026 23:12:22 -0700
Message-Id: <20260922061230.7909-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This series fixes some of the bugs found while auditing bnxt_re's
handling of user-supplied values and some generic bug fixes

Please review and apply the series.

Thanks,
Selvin Xavier

 v2 -> v3:
  - Drop the VM_MAYEXEC clearing patch from this series. Will work on a
    core level series which implements this in other drivers also
  - Dropped rdev lifetime race patch from v2 series as it is reporting
    few more review comments to be handled
  - New fix to serialize dcb_wq against async notifier
  - Removed is_in_used flags related patch to be posted as a separate rcfw
    series
 v1 -> v2:
   - Handle review comment about clearing VM_MAYEXEC vma flag

Selvin Xavier (8):
  RDMA/bnxt_re: Fix integer overflow in send payload size computation
  RDMA/bnxt_re: Detect wrong sge_len passed for inline
  RDMA/bnxt_re: Validate SRQ max_sge at create time
  RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
  RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
  RDMA/bnxt_re: Serialize dcb_wq access against async notifier
  RDMA/bnxt_re: Fix the PD and DPI table size
  RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection

 drivers/infiniband/hw/bnxt_re/bnxt_re.h     |  4 ++
 drivers/infiniband/hw/bnxt_re/hw_counters.c |  6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c    | 65 ++++++++++++++-------
 drivers/infiniband/hw/bnxt_re/main.c        | 24 ++++++--
 drivers/infiniband/hw/bnxt_re/qplib_res.c   |  9 +--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c    |  2 +-
 6 files changed, 77 insertions(+), 33 deletions(-)

-- 
2.39.3

