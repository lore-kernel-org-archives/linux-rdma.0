Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6A3D16F0
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 07:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003103; cv=none; b=evb3ar4e3SOvAFO1WOjWuHm3j/B/IEWtiCRc7hdihH6E1VaaKHLgOvpOK+4A4C4YJrRLkFnVjKlPM/pv0ryNvCRDMfAw7mMcRExDHi03zJ9HcuxxBc4YRU2V36rAnFFuMNyQHHvSeYOSTRqF/VZ4IP1tTZYoUD3AhpDAObSZsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003103; c=relaxed/simple;
	bh=rsDhCfRebURYXNVQyQLwyKO7Qvq0wwb6t+IFWbnhDrM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=odlax4BSStCB/0zaNb/umDUK//kbK+T9N7SXXILgsMV0O18gaKYj5GKqGBXoYhlBUA1UsM9j5pXCER5Fgr9VxQWCfjen2Snix5VBBuczGP64TA3jl03gwHn9HRGrrrntt4mjU2JumSV6zmCN2GhD8+t6rS3Q8lwmxEduzWw4AtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=D5HcagBG; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="D5HcagBG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786003101; x=1817539101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FUqRfHzRZdfc5zhW6mOf1yU53uFL5oEPHvSxC88uX1Q=;
  b=D5HcagBG1lPUsA6ps1LdkmxpZEG8GASQuaibB8XfdopefgStEoDFHo4U
   Mtds4OIqOYIoCnO9cHdF2Dys4E3Dmsu2T21zz62/QMsZTpXIP9gUIsF3W
   2vfUKaz2tsJYbS3yr5MYzAGvMVzbJOw6uGcK1V9Y/UQacM6lFmPpRJDsA
   IfU7b9L98XEGd//XKTNRVIUzcRoDwTCyhCm8MMy7H1hLOnZHIclufJ3XT
   ihBeI5IU1MmIbGOAR6WrHTKuLl2n0ArcPVaUazf3z4vHo9bHqFZKgGO+g
   3XqDRL51EYqM0h7XPqWoc+4ycOj8Trd/D12DAHuCGhCZESSiYhUTXWe3u
   A==;
X-CSE-ConnectionGUID: IRRV2JX3SWOFjVW+wT1l0g==
X-CSE-MsgGUID: ceNOXFo5TUeIn8Xx5yDpYg==
X-IronPort-AV: E=Sophos;i="6.25,208,1779148800"; 
   d="scan'208";a="25238870"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 07:58:19 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:19845]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.136:2525] with esmtp (Farcaster)
 id 06f660cd-68e8-4f1c-8b81-19d1be3b0713; Thu, 6 Aug 2026 07:58:19 +0000 (UTC)
X-Farcaster-Flow-ID: 06f660cd-68e8-4f1c-8b81-19d1be3b0713
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 6 Aug 2026 07:58:18 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Thu, 6 Aug 2026
 07:58:17 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>, Chen Brasch
	<cbrasch@amazon.com>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 1/2] RDMA/efa: Use device ABI MR permissions instead of verbs flags
Date: Thu, 6 Aug 2026 07:57:57 +0000
Message-ID: <20260806075758.3476667-2-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260806075758.3476667-1-ynachum@amazon.com>
References: <20260806075758.3476667-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Dana Malachi <danamala@amazon.com>

Set MR permissions explicitly using device interface definitions rather
than copying raw verbs access flags.  This is needed for the next
commit, to allow access flag bits that are not in the permissions field.

Reviewed-by: Chen Brasch <cbrasch@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Dana Malachi <danamala@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
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
2.50.1

