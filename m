Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C33DC857;
	Fri, 18 Sep 2026 04:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789707249; cv=none; b=Jwrec02wC9BLXzkkeBCDv81h3EHxOdXOK2I6gWR0TmfSdKO5iOH1lgQgQxd23BQlUOaSBjip86bHIGUaaqF8FLaWVzVUP1icOfQweqdMUDs713GD8DIERVUQ5WRWKWifs4T0UNfftdW9Y+p6LAnykkYCPwxM5b/7LN8Mv2OeFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789707249; c=relaxed/simple;
	bh=rFLnT4ixhIXXDQ8Ami7C64ucmDIFkvzEFio9TdNSY9I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KhQs8aQd++dJS4NaJt691jE8Uaj7H5ShoWbCRIrUWbJJ83Q8C6QdCNhSXSMiW3OzTWu7vlfKjYaEWU6bA0JvmxesLSPRPsAGTLlZEuOa1s4Xxqmv4g429RQ88AvajuTeV7niVsuioMvtWeVJ7k4+akKOnjbSqcr/MWmImdKtVlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLZr0xrl; arc=none smtp.client-ip=192.198.163.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLZr0xrl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789707248; x=1821243248;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rFLnT4ixhIXXDQ8Ami7C64ucmDIFkvzEFio9TdNSY9I=;
  b=CLZr0xrlrbC6DtS28dTL24syxHI6X+juJb+oPuBvIpCtfNjzGOikHcIp
   3Gpa7mD/5ucEpiTEEk/++r4p7k2NYFiCtQz9z3Al6OS+2i1Uain3uOfLB
   2DiUZ7OaZ0Lmp2AdpJabKA25qChmPvm0/gbLNIALDrTDP0zqcEQKKiby/
   bP9s7aM5dPpoyRkpkvKSenR+Uhg4Wim8QVHvHR3aaO2a0cuMw+dZ5ZhWm
   HWzWXz/XCkpYLEE2PQ0qcuLYwGdv9mEvPUyEIW6wFYowIsUv3+oX/16kB
   KPlgLYchWE6tNk9UYO0opO+A/ocATPXOpLr4stam9wU8cjORqQLC3h0pM
   A==;
X-CSE-ConnectionGUID: 6MobfpCfQGCB6oel3bWJ3A==
X-CSE-MsgGUID: hqKzws1RQ8+RjVaxuuYuZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="696946"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="696946"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 21:54:07 -0700
X-CSE-ConnectionGUID: Ze/B+emsQNusqVZ5mhd/Bg==
X-CSE-MsgGUID: IfUTt0c0Qyqg1htGQpJnfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="270888943"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 21:54:03 -0700
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
Subject: [PATCH 6.1.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Fri, 18 Sep 2026 12:53:53 +0800
Message-ID: <20260918045353.686837-1-junjie.cao@intel.com>
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
[ jcao: SMCD_CLC_MAX_V2_GID_ENTRIES does not exist in 6.1;
  SMC_MAX_ISM_DEVS is the same limit (8) under its pre-b40584d14570 name ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
Backport of the CVE-2024-49568 fix to 6.1.y. The CNA record lists
6.6.68, 6.12.7 and 6.13 as fixed and nothing for 6.1; the affected
code (v2 CLC proposal parsing) dates from 5.10. The other five fixes
from the same series are in 6.1.y since v6.1.122; this is the only
one missing.

The upstream commit cherry-picks cleanly onto v6.1.188 but does not
build there because SMCD_CLC_MAX_V2_GID_ENTRIES does not exist yet;
6.1 names the same limit SMC_MAX_ISM_DEVS (6.6.y has the new name
only because b40584d14570, a 12-file virtual-ISM change, went in as
v6.6.66). net/smc builds on x86_64 with CONFIG_SMC=m, W=1 clean.

5.15.y and 5.10.y are in the affected range as well; the commit
conflicts in af_smc.c there and needs a separate backport.

 net/smc/af_smc.c  | 3 ++-
 net/smc/smc_clc.c | 8 +++++++-
 net/smc/smc_clc.h | 8 +++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6713296fffd99..89fa7295275ca 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2225,7 +2225,8 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 		goto not_found;
 
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
-	if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
+	if (!smc_v2_ext ||
+	    !smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext, NULL, NULL))
 		goto not_found;
 
 	/* prepare RDMA check */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index ad1120a43dbd9..762e50354e11f 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -352,7 +352,6 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 	struct smc_clc_msg_hdr *hdr = &pclc->hdr;
 	struct smc_clc_v2_extension *v2_ext;
 
-	v2_ext = smc_get_clc_v2_ext(pclc);
 	pclc_prfx = smc_clc_proposal_get_prefix(pclc);
 	if (!pclc_prfx ||
 	    pclc_prfx->ipv6_prefixes_cnt > SMC_CLC_MAX_V6_PREFIX)
@@ -369,6 +368,13 @@ static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
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
index 0f6102cd5de17..cdba392b6ec9c 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -347,8 +347,14 @@ static inline struct smc_clc_v2_extension *
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

