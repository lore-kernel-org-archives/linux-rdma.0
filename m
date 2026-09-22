Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5739C55D886
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092887; cv=none; b=QrhpohE+pncdsV2eE5KLd8lY1qKzNpmTrSzsfQhuWYFsz3+7rAtQ/2jT6Ys1kifM73GytyPbpyDpU8LfNokGJXWa7NuwQIY9hi9zUbnldovNgG8fUw4StK8RY353dIm5ffzRScTR76v3+jTF5duSx/VnWypxUYfofkVF7tRmpaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092887; c=relaxed/simple;
	bh=Hd938+u8tvq/8aYYbjRUECLtKj9pTMR2MoR/8RE3tHU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TZNyu7GfF7kzcKuWjbfbDLQTWI8ge16bUAr+cCvSZO0nswOYgNXJpyKoSFYWkHjzM6DhnufJ2uvhx+V0srh/FqcMwThb0mC8UGQH+j5ZIxwmyPSB4UvAy5ljlxDv/16yHrO6Z4U2dxWekoj79Dz7FzLGTyhyKE8Q9esuAMMYsx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=et9Z4tjt; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="et9Z4tjt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790092886; x=1821628886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=obYGRb+PPEgeoFLpU0aKRTS2JWCiIi+pBv7/jJfmVDo=;
  b=et9Z4tjtFweF0NmkvK3chRX+sc1bSQv30gGpsaHRaQo07udnoL47+lkQ
   hP46T3P5Ga2Q4qLJqosbSicx2QF6R7FgTvGjL5uJsolEg89zIgIggNc6V
   0+RcloZW2xDJ5KRsWVEcJ2Sm/dlVN+hLkfN1aI6S6/x4uIE2fZXR3Zsd0
   GcGSMrGvBY2VyTpANQKifU5q44p4gQrqf1X73JBDlD+R1FvUryr2uljpZ
   4R76x1tUO6lukEQg6r3OrU5vuAyPt9DciW3zVvlVXdn9GDe4du7UR3usB
   BpUd/rDLofnqj2jxp9Z0b4nEcwHR7Hm8HgvkdVxFMxHLCD5/noz17A930
   g==;
X-CSE-ConnectionGUID: IjHd5CFyS7WON6F+0W/I0A==
X-CSE-MsgGUID: /Kdm9F7ZTEC2zci/KPucRQ==
X-IronPort-AV: E=Sophos;i="6.27,116,1787011200"; 
   d="scan'208";a="29142195"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:01:23 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:17102]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.70:2525] with esmtp (Farcaster)
 id 92aad389-bfde-4415-8a44-fdd4e13bc904; Tue, 22 Sep 2026 16:01:23 +0000 (UTC)
X-Farcaster-Flow-ID: 92aad389-bfde-4415-8a44-fdd4e13bc904
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 22 Sep 2026 16:01:23 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Tue, 22 Sep 2026
 16:01:21 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>, "Dana
 Malachi" <danamala@amazon.com>, Chen Brasch <cbrasch@amazon.com>, "Yonatan
 Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v3 1/2] RDMA/efa: Use device ABI MR permissions instead of verbs flags
Date: Tue, 22 Sep 2026 16:01:17 +0000
Message-ID: <20260922160118.990-2-mrgolin@amazon.com>
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

Set MR permissions explicitly using device interface
definitions rather than copying raw verbs access flags.
This is needed for the next commit, to allow access flag bits
that are not in the permissions field.

Reviewed-by: Chen Brasch <cbrasch@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Dana Malachi <danamala@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/hw/efa/efa_com_cmd.c | 7 ++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.h | 7 +++++--
 drivers/infiniband/hw/efa/efa_verbs.c   | 4 +++-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.c b/drivers/infiniband/hw/efa/efa_com_cmd.c
index 1b00f16b8ea8..aac0e936601a 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.c
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.c
@@ -237,7 +237,12 @@ int efa_com_register_mr(struct efa_com_dev *edev,
 	EFA_SET(&mr_cmd.flags, EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT,
 		params->page_shift);
 	mr_cmd.iova = params->iova;
-	mr_cmd.permissions = params->permissions;
+	if (params->permissions.local_write)
+		EFA_SET(&mr_cmd.permissions, EFA_ADMIN_REG_MR_CMD_LOCAL_WRITE_ENABLE, 1);
+	if (params->permissions.remote_write)
+		EFA_SET(&mr_cmd.permissions, EFA_ADMIN_REG_MR_CMD_REMOTE_WRITE_ENABLE, 1);
+	if (params->permissions.remote_read)
+		EFA_SET(&mr_cmd.permissions, EFA_ADMIN_REG_MR_CMD_REMOTE_READ_ENABLE, 1);
 
 	if (params->inline_pbl) {
 		memcpy(mr_cmd.pbl.inline_pbl_array,
diff --git a/drivers/infiniband/hw/efa/efa_com_cmd.h b/drivers/infiniband/hw/efa/efa_com_cmd.h
index bca722f021ea..7b0399811cfd 100644
--- a/drivers/infiniband/hw/efa/efa_com_cmd.h
+++ b/drivers/infiniband/hw/efa/efa_com_cmd.h
@@ -204,8 +204,11 @@ struct efa_com_reg_mr_params {
 	 * address mapping
 	 */
 	u8 page_shift;
-	/* see permissions field of struct efa_admin_reg_mr_cmd */
-	u8 permissions;
+	struct {
+		u8 local_write : 1;
+		u8 remote_write : 1;
+		u8 remote_read : 1;
+	} permissions;
 	u8 inline_pbl;
 	u8 indirect;
 };
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 2d28d68efe77..635687275350 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1676,7 +1676,9 @@ static int efa_register_mr(struct ib_pd *ibpd, struct efa_mr *mr, u64 start,
 	params.pd = to_epd(ibpd)->pdn;
 	params.iova = virt_addr;
 	params.mr_length_in_bytes = length;
-	params.permissions = access_flags;
+	params.permissions.local_write = !!(access_flags & IB_ACCESS_LOCAL_WRITE);
+	params.permissions.remote_write = !!(access_flags & IB_ACCESS_REMOTE_WRITE);
+	params.permissions.remote_read = !!(access_flags & IB_ACCESS_REMOTE_READ);
 
 	pg_sz = ib_umem_find_best_pgsz(mr->umem,
 				       dev->dev_attr.page_size_cap,
-- 
2.47.3

