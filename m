Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4455C32F
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092889; cv=none; b=EkwQvg1bY3En9mAGBHbjE7AU0f4aKT/ou/2LufQsLeL9jUytKpvh3eyoCrF7QP9vr+mFuP5dGLD88+66ML9s3lcrCbdfqRWHYLrfhRWA37ZGA42Uh6Wdb7gqu+CmmHDILNAed3dtVLhOReOz4pH8xx/gkt29f/0nKgdXec57pkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092889; c=relaxed/simple;
	bh=3VWAztQEz8RVBM4l1Wo58IYCc07YEX0C2X1RdKGU0kw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXpUiFULS/PAaoTzIS35z8ad/SCqOhOT/D2noAG20UX71oDTDnJjXNFxQAOgH2icg8NMs0bTa5LAQSNFDGZUn113LWG1MNT02tiUGSiLbiFmP5+lLDAjc8zH5FY4h4/ZmJRds44/lKWzRY7WA/6UoTLKznh9g8rKCTWLnHIBlPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=EaVlj/nE; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="EaVlj/nE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790092888; x=1821628888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RKbjOROyxBoC4wFiJR7+qFb3RCJCwHGwOIaSPMIH/SM=;
  b=EaVlj/nEviCESHFAMRtDNwXr9xsNufio/6y9DN04Tg1pyb0vPhMnfE0Y
   O472MpPnajw3e7TRN5rq+DpSQg1O7WNuwaSOV89OM/MqoY0mEFS6yF0Ap
   8IIJM7+tDcmeP+z8t9JngJsF9mW1Tk3e+mHEfO09eAQhC9g/vAika+4y8
   5J8xaY/8m9s0BSBrJySvWSMgYwXbnBZLo95fdZRkHy7w5msUwuSHmzWzq
   Ou5p2iex/PggU1ljoXAoc500ruxuxDw/nW8P69JJlLCjR62nFQkIcMpJ3
   0xDffsi+zDVqcAdCBFkhKAwO3nRSRJ7swPu8kSJlgYYDqW4h8tK3lE1YG
   g==;
X-CSE-ConnectionGUID: RckaDD+nQ8iPb3Kk4qha4g==
X-CSE-MsgGUID: +ckavjmWTfOROzzffon3LA==
X-IronPort-AV: E=Sophos;i="6.27,116,1787011200"; 
   d="scan'208";a="29156123"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:01:25 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:26455]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.40:2525] with esmtp (Farcaster)
 id 949925b3-eba4-46ee-927d-d5973e11c04c; Tue, 22 Sep 2026 16:01:25 +0000 (UTC)
X-Farcaster-Flow-ID: 949925b3-eba4-46ee-927d-d5973e11c04c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 22 Sep 2026 16:01:24 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Tue, 22 Sep 2026
 16:01:23 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Dana
 Malachi" <danamala@amazon.com>, Chen Brasch <cbrasch@amazon.com>, "Yonatan
 Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v3 2/2] RDMA/efa: Pass relaxed ordering flag to device
Date: Tue, 22 Sep 2026 16:01:18 +0000
Message-ID: <20260922160118.990-3-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260922160118.990-1-mrgolin@amazon.com>
References: <20260922160118.990-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Dana Malachi <danamala@amazon.com>

Accept the relaxed ordering access flag during memory region
registration and forward it to the device firmware via the
admin command path.

Reviewed-by: Chen Brasch <cbrasch@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Dana Malachi <danamala@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
 drivers/infiniband/hw/efa/efa_com_cmd.c         | 2 ++
 drivers/infiniband/hw/efa/efa_com_cmd.h         | 1 +
 drivers/infiniband/hw/efa/efa_verbs.c           | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
index ab830764e3b4..30a38e633bfd 100644
--- a/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
+++ b/drivers/infiniband/hw/efa/efa_admin_cmds_defs.h
@@ -358,7 +358,8 @@ struct efa_admin_reg_mr_cmd {
 	 * 5:0 : phys_page_size_shift - page size is (1 <<
 	 *    phys_page_size_shift). Page size is used for
 	 *    building the Virtual to Physical address mapping
-	 * 6 : reserved - MBZ
+	 * 6 : relaxed_ordering_enable - Enable PCIe relaxed
+	 *    ordering for this memory region
 	 * 7 : mem_addr_phy_mode_en - Enable bit for physical
 	 *    memory registration (no translation), can be used
 	 *    only by privileged clients. If set, PBL must
@@ -1203,6 +1204,7 @@ struct efa_admin_modify_event_counter_resp {
 
 /* reg_mr_cmd */
 #define EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK      GENMASK(5, 0)
+#define EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE_MASK   BIT(6)
 #define EFA_ADMIN_REG_MR_CMD_MEM_ADDR_PHY_MODE_EN_MASK      BIT(7)
 #define EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE_MASK        BIT(0)
 #define EFA_ADMIN_REG_MR_CMD_REMOTE_WRITE_ENABLE_MASK       BIT(1)
@@ -1231,7 +1233,6 @@ struct efa_admin_modify_event_counter_resp {
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_RDMA_WRITE_MASK  BIT(3)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_UNSOLICITED_WRITE_RECV_MASK BIT(4)
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_EVENT_COUNTERS_MASK BIT(5)
-#define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_SHIFT 10
 #define EFA_ADMIN_FEATURE_DEVICE_ATTR_DESC_SQ_64_BIT_REQ_ID_MASK BIT(10)
 
 /* feature_queue_attr_desc_2 */
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index aac0e936601a..07bfcb093df8 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -236,6 +236,8 @@ int efa_com_register_mr(struct efa_com_dev *edev,
 	mr_cmd.mr_length = params->mr_length_in_bytes;
 	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
 		params->page_shift);
+	if (params->relaxed_ordering)
+		EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_RELAXED_ORDERING_ENABLE, 1);
 	mr_cmd.iova = params->iova;
 	if (params->permissions.local_write)
 		EFA_SET(&mr_cmd.permissions, EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE, 1);
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.h b/drivers/infiniband/hw/efa/efa_com_cmd.h
index 7b0399811cfd..524407f36d43 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.h
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.h
@@ -209,6 +209,7 @@ struct efa_com_reg_mr_params {
 		u8 remote_write : 1;
 		u8 remote_read : 1;
 	} permissions;
+	u8 relaxed_ordering;
 	u8 inline_pbl;
 	u8 indirect;
 };
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 635687275350..9e4435401a4c 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1679,6 +1679,7 @@ static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start,
 	params.permissions.local_write = !!(access_flags & IB_ACCESS_LOCAL_WRITE);
 	params.permissions.remote_write = !!(access_flags & IB_ACCESS_REMOTE_WRITE);
 	params.permissions.remote_read = !!(access_flags & IB_ACCESS_REMOTE_READ);
+	params.relaxed_ordering = !!(access_flags & IB_ACCESS_RELAXED_ORDERING);
 
 	pg_sz = ib_umem_find_best_pgsz(mr->umem,
 				       dev->dev_attr.page_size_cap,
-- 
2.47.3

