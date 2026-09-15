Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011048.outbound.protection.outlook.com [52.101.62.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD09368D65
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481540; cv=fail; b=SJqhh4F7F6UTdUOJLOSX8jwZoMGvMINkg7vhNqABp748ijOfQe6Kg552eLgjehQ+mi6d6AAsNY0+0wMl/bYT8Hk74thEPTfeglHHm/EV8jxSpKqxZiydihrXr86vALCjlxeooJlNC+mDfoO4GuTRU0uo5YZqb/smRL1soTxQSP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481540; c=relaxed/simple;
	bh=QjK8FaQyFaYwPTwh45rFRVmdndMpty8dIzXSCajaQhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i43YLb+2lqcWjw/L1zjEocH45GME0u3EpDKA+op8W781mK2as2ldaDjwlDkwBOX8a5l/g0yTB0voe57HyzvSYXv+NgkB3JWk77KAvESetibY8O8d9YeLMUolw59EDLwGhBtSnukQ5kYGRnN63eekx+i0pEkZcqWza3h2Z8es698=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s9AeFRXA; arc=fail smtp.client-ip=52.101.62.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s9AeFRXA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qxu5NnBxcn9LUUNrhP3npKXqzTqVdTW87v7R7LCCYsTMSpcoFTgzL5aiAaV6RmNXdfKqWBpDfnYQ54fLw69FYTq9txXe3NP9iw216EO7I5XFIKJBof3oeSJcLsTK7RhVTwBu1uTIx6WQoLN/w5ov8EFSVvx/olox1ce6sJbZkoHg3vKPeZtowDR5wo8Id4p4oTbEwmn8nmeAyH9irO4WW0yZuDlB8fDpOTAuPQBrWDeFIJ6p+vyllG27ht2y8Uqw0W5Uwn3Qto53LciqzAtM+E7ZZE9EmHGM5p9PjAfJEP7j1vrUGRcYsr3XwGYczjXs57/mnpwbQMfwkoLiUYp91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGeHCbefJGlXkvhTStxMdf1sbJa8cG/poLiFpE/gcYg=;
 b=BL8y4zQ+FiRvJQPp7T69mLxJ+bPwtdM9p7ss9yVRZCwbq2kYIPVtNfF8by5tor/TPsKKXEmyNm0JTkpYjelMZMOst9m9/f7ng2aZuD4wWPQQi7nHwbejHJdtDJGnmZgLNG6gZfAiM5Xq1C8LPX836Xtz9oJjP1NWVLVJCcHH9suFQgKZZ4u5uM9/gsnkin4+Z8Rt5UhAA6VN6M3497f5XAv5BrPZrc+potW3wTfP0wDdlZenK5+sJuFKON400Vlr3ct5s1GRrD78IEUjWbY5b7T5SgTRR84DFQXaOnH4O0nQQgtGhzplRXE9jqkVC0UJ7ElzyIPGoJqGneinzd0tQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGeHCbefJGlXkvhTStxMdf1sbJa8cG/poLiFpE/gcYg=;
 b=s9AeFRXAVv+NaEGqinKGaPKTVdog7KQkcI5/2Ny7InvnmS/RcpbYjjs7yA6jZu3mwUjiFPQpSjIIuMZ2vLaZ9fjGdeWssb5GIQDKWlJOl7ABlTc5KgQMeqrp8obTaOPcyS/WWCBfWdYJG+yubou5jCYWwebj4GnEnQxlIy2UDN4R8WiBl5gTAf0UAdgoewu+L4771h+vB1GbjPaBTsBkCafkoG/M2Ts3CHvvXrWPW1mGaFVY4z6NZz05TuYDMS8NNE754Q6FoJYLS0r0CTv7SxRkwApyCqmAZNgNSacgDc74BVDzaF+DZPQJGdPL4C6v0hDyxmtqZbeO8JFyck5+yg==
Received: from PH0PR07CA0081.namprd07.prod.outlook.com (2603:10b6:510:f::26)
 by SN7PR12MB7449.namprd12.prod.outlook.com (2603:10b6:806:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:11:30 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:510:f:cafe::94) by PH0PR07CA0081.outlook.office365.com
 (2603:10b6:510:f::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 14:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:11:04 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:11:03 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:59 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 11/15] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Tue, 15 Sep 2026 17:09:29 +0300
Message-ID: <20260915140933.40580-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: ff485894-8057-4833-aaac-08df13333d14
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|82310400026|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	oEk864JJNAFeiz5EyTnw8jqIVI0+uQq9Ad2We9h/PZ9GmcoTfiOpv1jQEKICkXr6utMyimKP1NdY5uvw/iIh9MFSM/m8+3iSMQdgu5h6zPTzhTclAsuKNG7RMSSHvZSj5xMY3leBuDfHcBsmIBSQVz13+ifwyRANeAJTEgFNwaVPMlgwOgMCj2MbPaazFewFW9WSXjDgrFtvKgp5g7Zp/ATCJR/lwxvCIxoFABK6DDXtHXajBwRrgUqO+msbv27SGE6jP0KlsiHqnLAgYYgLSvERdLUuj5MQuS5QCaCNWOgBJFhlDG+Cd5vLqCYBr7Yf/+UgL+Q76KztkmX7TX6RgmqNYm9ZZeI58A5Grkp8vynHhVyPsbBX6ioJbh9kTeOFNL6NQFsIhIDwKlpfisGj8jQbG+E5Maf0wLRb5i+8x9HraDtbiEmGnnVhnSaLJiPVtOTCOqc1/ixrOVZ8FPRH4f/qIS/HKKXL8jZNf+GTsYBDJCaZjrXYIXNKfLrl/WXvSQnOx2j+VVqNwAwYu/9wr2aFg7dV7FNhssdHZiUEi/UYLl4o9wh9Cn0i9FkcOUmML8CghRoNmOSqQtuaFsg1H0m82YwDVVnWwHAl31hp6zEcWW6cVjgcORUqWLHS/CoilKXiQPxMEBrYgnK/6pqBwFOvW0FoUEPe+sym/Rrv8TKvvn8/KHM1sRwIpTEMEUV/FsNGYbKeN1lmToYR98UBWw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(82310400026)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8cd3rM4+ekxqCrdA6eOwfZ+uSy0G/SVI30iWg26wUKToilKWUuEXYHNUUYYJbFnw7TuBWGrt7+9JNU8YNEpFS5UzCAf11/VG4TbNNo8Mp0Wiop2D+ykOwIsPFYC3AEg6c5Gep4M1fqQw783FJ8+ceBRyKOwt8GKFj1uGfiCZAyEKmiFAUGHDw9Fv16IRsmLnjiDBiwvmLgtp2f3t/HGF/5laiQz21vJqANiPEZ+nsZGnue4BFbf+vCrxJn+tAKHRDbm61yUNO80jR5NTOkgyrwehq/PL6++kjIOQ11gA649chg+cbsquo19GIOadf2WctywK4luqGJnZXqtWZbWj73qqz5f/LgQ0bXi+3OsGuJs+ItPEv+8mY90ps+t935NZ0g0W+fdhuEjpzYfKJ5LTHw2vHeAzeO0di28Y1BHEy8+wNNtuuhiPSS4nD2rzM4n/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:29.7498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff485894-8057-4833-aaac-08df13333d14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

mlx5_cmd_create_srq() stores the SRQ into the xarray before
srq->msrq.event was assigned. A firmware SRQ event arriving in that
window calls through a NULL pointer.

Move the assignment before mlx5_cmd_create_srq().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a973c1b7515f..6a4a937d97ce 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -284,6 +284,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -292,8 +293,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.18.1

