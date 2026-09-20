Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0F3C3F42;
	Sun, 20 Sep 2026 05:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881618; cv=none; b=cYIhZySe8jXGepw+pz6UBbKntra2ao9BykN3wi6IjZ2SN3/XnvTeKMbI3O+B4+SfYDKiy6YTFjAI9cgZn708ZCNYP/sRRwFzRt2tZArjHvvWOjHJbFZ4yitfTUexI2EIeR2DDYaeeTaU32um3QqNhhHHk8TwsTC9xNInB3rp0Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881618; c=relaxed/simple;
	bh=QJ7NBogoil3o38vDvzfc39ykKJVM2Pe7CmNlwVif5QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YS/e/MjkFC09+/bQG6ZJSf9WH/nHGy+cSjr1ctc/8cy6SV/lmCUh2ubThqIipCPisei34UT+9kT3jQsQhCUyZHSKDBPoNNnFnv0hDrYwr7IJduukJAEYFOa74A/k6gRH1n8p+FoZ2pPr6ojImHeRPCl8Bw8/sJO4WdcTcz5dLjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kTMLLHxc; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kTMLLHxc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789881616; x=1821417616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QJ7NBogoil3o38vDvzfc39ykKJVM2Pe7CmNlwVif5QY=;
  b=kTMLLHxcqxRWBeFydgxL3HLe2UL3cKN64poJDEBil5GdlOxKWToivzPl
   CZ3oSpefYvJhBuD42/yydouU/NnCB60OgQeOuq3AkNnrySU79V6IJxVW2
   bMfTz87iN09VGS9+PbNvv5ThfO3JV4GMHlCQm/qT+6gpaXEcB1xqAp0lw
   tX9YodZoZFH5BB8Qd5+7tkzOfKYJgk+t8UOK8asBLD4sFGi2nPQYx7nkL
   DJSybq/C0CmKkziP7VmX/kYUSCu1aowVaec9HqaMjNJ4x73aGj/coF7Wq
   DvtOJI9e9EibaAwoyYpBaEGtszdvFOiJvJTl+ZIfdNYdFLhB5abtSOPzt
   Q==;
X-CSE-ConnectionGUID: MIYH04GqTdWr+tTTmoAAqA==
X-CSE-MsgGUID: EqYM6zEFSDyvfHbRXUS9jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="901749"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="901749"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:16:13 -0700
X-CSE-ConnectionGUID: 8Ob3o2IISBaGt2g1yePU7g==
X-CSE-MsgGUID: rharG24aSIKsuUIkdS6YVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="272338563"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:16:10 -0700
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
Subject: [PATCH 5.10.y 2/2] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Sun, 20 Sep 2026 13:16:00 +0800
Message-ID: <20260920051600.712147-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920051403.712116-1-junjie.cao@intel.com>
References: <20260920051403.712116-1-junjie.cao@intel.com>
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
 net/smc/smc_clc.c | 8 +++++++-
 net/smc/smc_clc.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index bdbe82b306c50..8d72865dd7fb1 100644
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
index f7f656b297f9c..0c8e752f09f44 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -153,6 +153,7 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 } __aligned(4);
 
 #define SMC_CLC_MAX_V6_PREFIX		8
+#define SMC_CLC_MAX_UEID		8
 
 struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal		pclc_base;
@@ -292,8 +293,14 @@ static inline struct smc_clc_v2_extension *
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

