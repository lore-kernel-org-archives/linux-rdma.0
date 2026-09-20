Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980D231D39A;
	Sun, 20 Sep 2026 05:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881361; cv=none; b=HYUH0EK9yQAu+HgbZMKORNlkEBEL198A3pridwcsVxyqH3USyT89m5ssHQYdO8SHOvjJAJlyvcg4MAt3oOs3YKVVrvLWdezQxiczrxdut2FBB0GY5OkvFEoSLcf2mxULU0PvJ/e61byJHtGekXVVFxGGc5ovzN0zc13DnRA/23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881361; c=relaxed/simple;
	bh=plPxIX51rPlaZc0YSCpgmLn4ik/g9oQkSyU1YdeWeqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqGD62qVNy0O5LjKjyJ693htZKbvXl+kkAJ1txNqYlK7feS+I1RXJyn6OodlXCB/OIx75iLiRkwC0OqElF8CystYvJ2LM/XbCv7cJYPuMlJrUE+Xf+6qnr6OP5EQgLEWfHbtC0cXphvR5jNjR9a2r/Dc9/TXRIHw23bLx4T5Ir4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmGKXw7q; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmGKXw7q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789881360; x=1821417360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=plPxIX51rPlaZc0YSCpgmLn4ik/g9oQkSyU1YdeWeqg=;
  b=nmGKXw7qC4pHyN6TdO6j50g/3fMYRD3SeGKZAmCAFDLOu+sM0AgO03I4
   5vbU5UZKAnWD1w/hxtp280q8FcnZGBlSoWD5rwY6ZqbJurMF9y4165K5P
   Kvbr3oGObd4X/V5RlyraS+xE5kZS4oDpWLBHLHBTRbC0ZonA6YUS63L8x
   i88b4gg+nl9/O4nqQywZb6F7KIlJmNkE5VB/KSxsv3JVMkk0c+fFmskFb
   pkKGZjg3Hl1LaKSVOZFOoIRZ0tidnFI37Aywvyr/da+IOpDVFXV3sH+hs
   lfH6a1jPcCQKDcbTUcEN9Icm/+w35U5kOD+1iQ8f3KJYvuShz2/m+U0An
   Q==;
X-CSE-ConnectionGUID: GmLTavybTbWcKPIFD6qdLA==
X-CSE-MsgGUID: aippFETqSwqEouDVlKog9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="90406445"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="90406445"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:14:21 -0700
X-CSE-ConnectionGUID: qBGolkCORJKbxc1KBeUoHw==
X-CSE-MsgGUID: ENvXtCh1TsOS7qW/9DY9Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="268706679"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:14:18 -0700
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
Subject: [PATCH 5.10.y 1/2] net/smc: check smcd_v2_ext_offset when receiving proposal msg
Date: Sun, 20 Sep 2026 13:14:02 +0800
Message-ID: <20260920051403.712116-2-junjie.cao@intel.com>
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

commit 9ab332deb671d8f7e66d82a2ff2b3f715bc3a4ad upstream.

When receiving proposal msg in server, the field smcd_v2_ext_offset in
proposal msg is from the remote client and can not be fully trusted.
Once the value of smcd_v2_ext_offset exceed the max value, there has
the chance to access wrong address, and crash may happen.

This patch checks the value of smcd_v2_ext_offset before using it.

Fixes: 5c21c4ccafe8 ("net/smc: determine accepted ISM devices")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ jcao: drop the af_smc.c hunk, the !smcd_v2_ext test already there
  covers it; result matches the 5.15.y backport a36364d8d4fab ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
---
 net/smc/smc_clc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index a57a3489df4ae..f7f656b297f9c 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -306,9 +306,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 static inline struct smc_clc_smcd_v2_extension *
 smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
 {
+	u16 max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_smcd_v2_ext) -
+		offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		offsetof(struct smc_clc_v2_extension, hdr) -
+		offsetofend(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset);
+
 	if (!prop_v2ext)
 		return NULL;
-	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
+	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) ||
+	    ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_smcd_v2_extension *)
-- 
2.43.0

