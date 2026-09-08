Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BE55C334
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881425; cv=fail; b=Vi02ajJKOvtRLBVs8toPpdQ2nCqM6fq64y5AO8b0DEmrIycMpY0dFcVef8fVIougFdmtJUtUMiMs+RJ6qHforGnDBxTZR/DAqMedvUAHrg+SGV2NqxAkV/+N+AMs/lYEqgRGAkVXSMTrH9QOB9cjo8lC7A1yxVC9BjdcGP+8xGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881425; c=relaxed/simple;
	bh=zH+pOwEr4SoN8Ehrk0pmpHwIVsD36/t7WmuWyOIdkTw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxD7J7q7qZOD79pmuRlXiAS7vLIYwFXwBSvgirulXpOLx8xDus7xv5LwIks+k/iBOgIOd+j7qlQcOQo5yuhhjQ+6/w0dR0fqpM1j5XBN+EogR0F+tWpjdKaeWIoD+cfbzHgI+YCCCwSjwsXgdaisHWMBODYtSoxJAyR8521Jc1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RGZ2T/1B; arc=fail smtp.client-ip=52.101.56.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RGZ2T/1B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=je5zRvRpm7BeUZwyoOE90d6xlBX2HVnJ4RV2cK6F1LAeKgcJUtql+LeKunys9dI0SNIPAkNV2BSH/To7AdtuL+ZzIfnRot1EpqxYmOpHNV0P6BiqB8nW7TrOIrwe23Ra/aCKJvk8P+s3RNy9vchO9WM7rNf8NMVtB1AdJLQNncYJaDB2u3nQfH4rB/qi62FSZEMSfEznkx8xp/1urzKCY+Fb0sH3bi2XQCdnNi1uXtxWoPc+oraJheKehtXoE08Fl9xJH/2yESlTB6fqFPqq9o7+tpYFect3U3APgEHE7cV45lR+dID5tQvMcYQhsWLl3BZ6SzQM6qlDXIpWo5O6xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIkS6JQKUbcGYMeMcj9LwnQrSKIUkGeUDy9Y5W6HXUM=;
 b=ap/VVAGNjYdH4CP4Xe5Wk/DwIewDojHOTAJyQ3y4bHm2uipILUda56le+fyNmzJyXDt3gvyU+VBTHvAzfiFMGTjIvX6aRK33QWnry0or392/X0gjVv+liY6WgP1FPM7E9kpi5+I5JuVxdqbP8imQS4/88rDhh+GUYvak/UN8SeFurVjA/vxbEoNuIthyK6/85LooofAGHuHTdOc/Z1vJHOXbnxLyHPsez5Z+/ZsRKX+Wz09CPf9nzDL/Jvb1LanFK4VTICzPQOlMnSD8y19+cWwbVocZzXJHtFSH5bmDuBg2b8EtenZTNyY3sle46jnbuuSQLKuGk1apwhfl0JagWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIkS6JQKUbcGYMeMcj9LwnQrSKIUkGeUDy9Y5W6HXUM=;
 b=RGZ2T/1BlGiTmC7p/fa+nDq/oS9ddGOob1j1tt24bV9O7KMBNNnh1HdyE0jHclwrJlwLNRyI73vlFxSI52+Qmea4jYOlfDZd4tVukb3+An0Z/hkk9EsrpFtsNmOROi6GidX6fjl6gtIzbHGdrkgrwIggVXMIB6JrEgV6MGvxu1qzG4UZ7C1TeKn540KyTOr0syn8rPxS7zXpfkuO98whAtPj7sQfGQ59ftCjcvofEIE84unCKPkuEBaNJIqYNDFRFNXGa+x2zqzWvDYQQyHhWWeBoyg4cODoOINVrNLOeJ1syGpPCeyX3TPK/0bEKSmAOZu0NDQQf3Cmsqm1svPw3w==
Received: from CH2PR14CA0047.namprd14.prod.outlook.com (2603:10b6:610:56::27)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:29:59 +0000
Received: from CH2PEPF0000009B.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::7a) by CH2PR14CA0047.outlook.office365.com
 (2603:10b6:610:56::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Tue, 8
 Sep 2026 15:29:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009B.mail.protection.outlook.com (10.167.244.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:29:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:33 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:33 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:28 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 01/15] RDMA/erdma: Pin CQ buffer writable to match device DMA write access
Date: Tue, 8 Sep 2026 18:28:37 +0300
Message-ID: <20260908152851.1307294-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009B:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 242e6e2b-8e75-42a4-0d0b-08df0dbe0b85
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	f4unkVnqglZQ/e/QQfs60MoQAMcFe5GxfbXLK5HiMEHaRYtfKLsuewAQNNZ7DqodiZSPYRlJFI2QVqC/LCYkaltO+ZtNJw3/FtAhJHLBtTBeEwsXHdFTxbvcAhv/KGOAOdYSDtBhcgZhZP4+UXnDcuLGY8mtnKaT+DbBAozmBJS8Nsj9HF5DJg6GJLKFSI5lUb1Tlha30On8z6vn10nq+E4ljHDk+xYSEJ+5jTe912u+6ILfTUWbdbhij8920tA2IXWQFMyMtHbebl9HxKCyEGjOpo6Wd1IHpDIPnTt0+Ae6FVBQZU8dO0oNBMBRbLJg+D76KryqExqgCvrL/fbbkt9AUCwNo9IOHmAk3TSeKxOZ6coe+2Ofm8FvS6DCJO5PpWcO1iIDUTjqnoYdte5RTkgsdgrSER87gz24tVj1oWbkWvGEn0PDFBhE0k8iG6hizhbNOYw3m5QW/9Zpvh0gQnfP9kZnbUE+jHcTlqTo7H5V+9WpI5fQB3PSNTi9q1726/1ZG4HKqtdE/wuBvhOWb2zkrvYOhTY4/JYCUxIxvGgIbCc34j+/SBuIO5Bzqc0mnWe2KOCA175sgx+HYPbrxXOfKLqYR4ciJitXk3jh69Nz289wwkpZpBDsAlVxW6LymFrRj78TzGX/5PCL21fsmzg++fwfKR5yoo2MM9mM5TCA8vv1/SXBhEriHP2qQpFIDswcUhpneW6e03P+8dGWFw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	piLBnuDhbeopXtO/xRYFNYIEdWaUs7TA1rA+dPqs8V0usF29gkMIIXVuU84U4YDCo6pGj658VHG5/NH+oIegd8CHIwYgclGFDMy33PoD1G4boj/IXxRDLiO/1cU3Q93U7NhJHpeks7/QLzxXbLhAXECpgQEA7nXy5QrxD2WIt+0KXo2dn01NVld4vBVERmK+JORRExebfsuEWQs13B4HiF4+LQi02Kepb75u993Gs+rpCL6/eMbG97mQGoYC0aB3tzT1o/2vrcoMX4lqrwR/Xi9J66XAGGu7+uJQlvlJ2tYBpO2urBSzQRVJFVFFY9vhfjrznetzUDoTJAxQ0MWaqAD4vlxQVg+XTGPmnOJXnatg4m5s4PPbsw9N9te4qeGlI534MbGVEu/T6JXGzk2lP/67ZFIRBqEZj6DCm/k5ae0GpwiXvEOaJIu1KwVZERyv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:29:59.5555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 242e6e2b-8e75-42a4-0d0b-08df0dbe0b85
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318

erdma_init_user_cq() pins the CQ ring with access=0. The device writes
CQEs into this buffer via DMA, but access=0 means ib_access_writable()
is false, so ib_umem_get_va() pins the pages without FOLL_WRITE and does
not mark them dirty on unpin.

Without FOLL_WRITE, pin_user_pages_fast() can hand back a page this
process does not exclusively own (e.g. the shared zero page for an
untouched anonymous mapping) instead of forcing a private copy. The
device is then free to DMA-write CQEs into that shared physical page,
corrupting memory visible to every other mapper of it. Missing the dirty
mark on unpin also risks the device's writes being silently discarded on
reclaim.

Pass IB_ACCESS_LOCAL_WRITE so the CQ buffer is pinned consistently with
how the device actually uses it.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index 65b1af1e6623..fca2553e47ad 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1930,8 +1930,8 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
 	struct erdma_dev *dev = to_edev(cq->ibcq.device);
 
 	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
-			      ureq->qbuf_len, 0, ureq->qbuf_va, SZ_64M - SZ_4K,
-			      true);
+			      ureq->qbuf_len, IB_ACCESS_LOCAL_WRITE,
+			      ureq->qbuf_va, SZ_64M - SZ_4K, true);
 	if (ret)
 		return ret;
 
-- 
2.18.1

