Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9789F358399;
	Sun, 20 Sep 2026 05:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881234; cv=none; b=YTNbMZK9ooLnYgOMGe2a4945dEg9z7Y0L7kbzA7jBouXvRklvv5yK/Oju9J6KWYPBBwWfTxFucKyJ79NJrjwG2ff4DDU/6OGFi4W12tl4Gno+UN5a6kPTo3tC8IdPcW6VDt7pPiGs4EMGviQDt2y66DoAT7NDJUMp8J3oA67TRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881234; c=relaxed/simple;
	bh=BVzb8ADpr9Q9++oyZL46m/pD8j3PJb8p7oRYnB6e4pw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gr/Fsm34+75Twb41gujXnqodT48iZZvQhgYXTWzLTmTAk4nqZwA7EUUMnkR/5gFOdTrBK88YcXMNL+jNGMCdDc7RBivccy8x1ZXXsrWjs3+S3pS/iP7ZCIe4TiO6VGwyi3spx0WBBUKe440CkBEuJdlaT3AEvo+1zii/Rm3dZpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BjJCIkJ2; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BjJCIkJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789881232; x=1821417232;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BVzb8ADpr9Q9++oyZL46m/pD8j3PJb8p7oRYnB6e4pw=;
  b=BjJCIkJ2Dlbes2GFfAIgpmWzTxuur3tcASWLmSfC0v3dIwgjIuzzWnyk
   lDIIFKequXGcHFudfFcSwWlv8pUeo1O03EZR+9DlSQ2mMXge4Uf1pFmDK
   9Ne77278hbaeYdppvEcRSpFDAEsrxk3cWrNcjPy/x8Ms9ZC0/PU8fnb6/
   HMcpKGflWyKrzJXIdVrHe5hWF7Zy6gF1YrNtha+jzwMZd0q7JoRNeSJjv
   zkFBsY6u7ZU48wHDZHb0vfJJtQc3XmFw7GSAROplpfIteTiAIhTCwRCQM
   mQw+91bRpYQQ79a1VjjL28Pp2jghRu2JwHxO9RJv2+NEn5wo/PytjFpe3
   Q==;
X-CSE-ConnectionGUID: 34fOv13yRR+8QXbxdAZD1g==
X-CSE-MsgGUID: PrDeXhM/RsW/viyu8k5tlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="90405736"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="90405736"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:13:50 -0700
X-CSE-ConnectionGUID: Nsna7d9eQrGIvBpkPFKOEA==
X-CSE-MsgGUID: cejYB3qTTfi+htAdR+qP1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="268706574"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:13:47 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	guangguan.wang@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.15.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Sun, 20 Sep 2026 13:13:36 +0800
Message-ID: <20260920051336.712097-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

commit 7863c9f3d24ba49dbead7e03dfbe40deb5888fdf upstream.

When receiving proposal msg in server, the fields v2_ext_offset/
eid_cnt/ism_gid_cnt in proposal msg are from the remote client
and can not be fully trusted. Especially the field v2_ext_offset,
once exceed the max value, there has the chance to access wrong
address, and crash may happen.

This patch checks the fields v2_ext_offset/eid_cnt/ism_gid_cnt
before using them.

Fixes: 8c3dca341aea ("net/smc: build and send V2 CLC proposal")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ jcao: drop the af_smc.c hunk, smc_find_rdma_v2_device_serv() came
  with SMC-Rv2 in e49300a6bf62 (v5.16); take SMC_CLC_MAX_UEID from
  fa0866625543 (v5.16); SMC_MAX_ISM_DEVS is the pre-b40584d14570 name
  of SMCD_CLC_MAX_V2_GID_ENTRIES ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
5.15.y backport of the CVE-2024-49568 fix, requested in the 6.1.y
thread:
https://lore.kernel.org/r/20260918045353.686837-1-junjie.cao@intel.com

Differences from the 6.1.y version: no af_smc.c hunk; the callers of
smc_get_clc_v2_ext() in af_smc.c already handle NULL. The
SMC_CLC_MAX_UEID define comes along. 5.15 has no UEID support and
uses the received eid_cnt only in the length check of
smc_clc_msg_prop_valid(); 8 is the limit newer kernels apply to the
same field.

net/smc builds on v5.15.221, x86_64, CONFIG_SMC=m, W=1 clean. Not
runtime-tested.

 net/smc/smc_clc.c | 8 +++++++-
 net/smc/smc_clc.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index fb214faf5f984..0c2c0b2edfdff 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -47,7 +47,6 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 	struct smc_clc_msg_hdr *hdr = &pclc->hdr;
 	struct smc_clc_v2_extension *v2_ext;
 
-	v2_ext = smc_get_clc_v2_ext(pclc);
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
 	if (!pclc_prfx ||
 	    pclc_prfx->ipv6_prefixes_cnt > SMC_CLC_MAX_V6_PREFIX)
@@ -64,6 +63,13 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 			sizeof(struct smc_clc_msg_trail))
 			return false;
 	} else {
+		v2_ext = smc_get_clc_v2_ext(pclc);
+		if ((hdr->typev2 != SMC_TYPE_N &&
+		     (!v2_ext || v2_ext->hdr.eid_cnt > SMC_CLC_MAX_UEID)) ||
+		    (smcd_indicated(hdr->typev2) &&
+		     v2_ext->hdr.ism_gid_cnt > SMC_MAX_ISM_DEVS))
+			return false;
+
 		if (ntohs(hdr->length) !=
 			sizeof(*pclc) +
 			sizeof(struct smc_clc_msg_smcd) +
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 78a94b9122b64..bda7c0384b845 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -158,6 +158,7 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 } __aligned(4);
 
 #define SMC_CLC_MAX_V6_PREFIX		8
+#define SMC_CLC_MAX_UEID		8
 
 struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal		pclc_base;
@@ -297,8 +298,14 @@ static inline struct smc_clc_v2_extension *
 smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 {
 	struct smc_clc_msg_smcd *prop_smcd = smc_get_clc_msg_smcd(prop);
+	u16 max_offset;
 
-	if (!prop_smcd || !ntohs(prop_smcd->v2_ext_offset))
+	max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		     offsetof(struct smc_clc_msg_proposal_area, pclc_smcd) -
+		     offsetofend(struct smc_clc_msg_smcd, v2_ext_offset);
+
+	if (!prop_smcd || !ntohs(prop_smcd->v2_ext_offset) ||
+	    ntohs(prop_smcd->v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_v2_extension *)
-- 
2.43.0

