Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57843E4C84
	for <linux-rdma@vger.kernel.org>; Mon, 16 Mar 2026 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686469; cv=none; b=dgDfJaJSIDn+/+kR8SZ7pdse/BC+sY3VhdARRp5lutQJFgIqEriF3hFrCZEckGLeNdBsWGm31mj0mZTvsDmFL5sVI1xYo87ASis8e21WuBJIlVWznHEY42+rAV3WeTwtcgvK01ChrANfe22KvUbrQRFxhcNG3QZEu+aU4wusrdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686469; c=relaxed/simple;
	bh=0LTOQjROBVoO+/PpqqpdX2FNAJIecX/+e9+Ohig0zcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnC1SEjgzP33R9ue8qbdgWN18TU2Omwrp1Uvi0VorCCj6GiP9ZAzFKfCNNZYLUNRQxVEVUNFDjPdT0ohmV84VEXi+AvOndFGB+ahF8JTLh7n49M24LLnxewyW+Qw+2xaU32dwYZlnoXexc7yoQ9G89XqNrta6JL8xHXZmi+4XxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ay5dOvIH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ay5dOvIH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773686464; x=1805222464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0LTOQjROBVoO+/PpqqpdX2FNAJIecX/+e9+Ohig0zcc=;
  b=ay5dOvIHZITkHd+Ov2hrlQbL3B7kkGbpAJG6geC/ACSAFH7BPz38NRPb
   msbHv9NPbzZJ+wSdfFBW+CgD9lCMHqCer/zenatyGgHkpTeGCTMKiCQsV
   Cjnbh05THHPAT+ourtrQYaPGQhkUGDLOwjyMeUGkOUbyIjjmDPtnSx1Ic
   mxujkWcDQfjS7Kalz7noddZXuMmE8Z+stoezdbDfDbIPctEe8125D6Neo
   cf+MSmTZ/SMHVwFbgWEaKWPPRjJaVL3xh+72xOA+7VQeXHOi416zwNPXm
   tpLz8UQHD4stYbEpZmxNUOIO30FlT+MAAjT/BJlNiLwHunOyTnxnvtLHg
   g==;
X-CSE-ConnectionGUID: Q87G3NUFRK64OCrXTAkEfw==
X-CSE-MsgGUID: SCkUWu3aQ6K7erWpDILy1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="86067616"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="86067616"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:40:51 -0700
X-CSE-ConnectionGUID: WZNeT/LlQCO14Pk62AhCRQ==
X-CSE-MsgGUID: IdOUPfXMTIiXe1nvwsOL6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="252520428"
Received: from soc-pf51ragt.clients.intel.com ([10.122.184.229])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 11:40:48 -0700
From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
To: jgg@nvidia.com,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	tatyana.e.nikolova@intel.com,
	krzysztof.czurylo@intel.com
Subject: [for-next 07/12] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Mon, 16 Mar 2026 13:39:44 -0500
Message-ID: <20260316183949.261-8-tatyana.e.nikolova@intel.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20260316183949.261-1-tatyana.e.nikolova@intel.com>
References: <20260316183949.261-1-tatyana.e.nikolova@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During reset, irdma_modify_qp() to error should be called to disconnect
the QP. Without this fix, if not preceded by irdma_modify_qp() to error, the
API call irdma_destroy_qp() gets stuck waiting for the QP refcount to go
to zero, because the cm_node associated with this QP isn't disconnected.

Fixes 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
---
 drivers/infiniband/hw/irdma/utils.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index be2dc92d008f..18d0f29100f3 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2324,8 +2324,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.31.1

