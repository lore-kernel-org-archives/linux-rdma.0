Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724120;
	b=ZTriaRxFF9WpGD+g5ZrmkEoTaZlrAA6Tu4vEcYkAOh5QpNG9LWBq/d9FjJFMa/D/QVol
	 FbsZpnxcToft3J1BZ02LJ8oQ5ipEDheoAT6DwtMgcTPDrUwWebvl2/8iGElDdYpSSV985
	 jZJauU8W+rC4cfFBi0Nj/C4imbUE73QIDPAYyjKjHGfryAU8JRqMHr7n0NsrIQYkfB0Hw
	 +SwsbTVHSdnvEwASBLU5q5szxxI/WDgKFNfwT4IX5R+BKhhL+waAm/jL2IW+vQOt4j2uG
	 8AHTubh6l1TKZOQzEbo/warlUhM4oFiT8l64LzaTiOq0ZfdMWf96yUJwFdwE+lBH5jA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724120;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2KPDu+UIXYumSN2gpqodbR46tllqODtRKKCUDI5o+eM=;
	b=Slmw5Zr7T4IMePcVZZlWUvj6YoDD+YKSyTquvkuxtmeaAxQEj4rMu/VUbmEN22zO0XVv
	 jYXbBZNnCQ2KehdVGOinmQ9qVGuJCy8/4C4BCgAKwp506mXy/igXQu2S9GWzUUhkmkZeF
	 U9/6Og76LCb/GCIvDvyfHwkfqJLnp41yJ5KZC4sTS3eOTa32qejjWRHKAmuckupE+6e7u
	 E6zK5LgOscib8YRZ/VPpj+T6BotvS097dga9GoL4xzvJUMirFrLjgbi9iI2kdakuaYmiM
	 sVT0QaA+0sFF6mpeP/W47GjC673CiUc2hD499l0KDiJrJhhGfiWPqbgUtsm6nimIo5w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="e/NS4r8u";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.41
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012041.outbound.protection.outlook.com [40.107.209.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C621D606EEB8;
	Tue,  3 Nov 2026 16:41:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C621D606EEB8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=e/NS4r8u
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MgnBYtWXEq+FQ1JgP5TJ3TaXEGO/RfRhOzQ1l1bpp8g6ud5+b41BMiB38SzdOnaYSxhLcyseS5NnoJKKOTKl1bD+3pUKb6hajaxCpVNita193/zefcGZS692+M5aRFvA0W/HJu0XBQTYrqjTXKkpzNNPgef1BVMWUJXbAAtP+qtneQ3Bs3HvJn/Mg7e6qyshoEPWYjpy+p+cLBw8JnlBAtd/zsr1aPGJyxReIfWWmfjN/DnSn10+qT/dyMozyuYHve2lfVGKhCC8+4Cm3yO0mxA+Cv2a2D84z9cJJKcqtM4sKM/rJ9Ws7H5q+J9yweSMAbeBuJY0fPtVnnsbRRWHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KPDu+UIXYumSN2gpqodbR46tllqODtRKKCUDI5o+eM=;
 b=UDtB0V38QgD5/2BKVf+PEiGEv4iAqvtGNYasvUcR3iJrSDstma0Cjbi/1y+yJRdeOgYjLe5EYHJ+fH3+aJnOLzl65KGbNe2S6Q1sgqIsW4dSzkULF359sNThVIaH3QAQZMfkBxBSt5ja9cs1nMTt/UT8pzce5bA2r2tA8cuoOWtSr9NCs1hq97Gawe4kOR6SS8cZM6Stdw4M6/1cEBATr5DuZDc2CGiGhh1zIQ3L5TPm1/9wporgWacuHggyxt9ElvfG93B75Y6udInwksw6h0NGrIioAosHX9j5LxFPPI7KCi6BVwh2pgHsNKFJmCMtrHruNHG3bgDZu2w7nf73hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KPDu+UIXYumSN2gpqodbR46tllqODtRKKCUDI5o+eM=;
 b=e/NS4r8uBgNYA1du/AdyVIlqioqqtbmUCb4crf/Tip2CYFusBwkm4E3QMU6EuLMLm0VdNz4Di6ahYbESwgYhxNc5Z9WLroOcsLHvddcOVDoWFm20rYvFp5gLuqyXEWlH6RIy9Jc+ZuImScwPvLFMK4aIhimVKW5fXfNc0VdDBvQxFgXVmxc1HySMQMCypa/bnyFimZqjiEUvw37zQ3JKqG3tVjoMwlp7EKnVNkOdUWpfNzDL3rd6RgralmvdqxDamRcxEaFIBdbDJgmywkBE3PeXQoGbnufT4d1k+sPtKVjd3rU2x2uQIUFI5lHPo7II1hYs8A3kTlDDVnluDZ88Sg==
Received: from SJ0PR13CA0118.namprd13.prod.outlook.com (2603:10b6:a03:2c5::33)
 by LV8PR12MB9232.namprd12.prod.outlook.com (2603:10b6:408:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:50 +0000
Received: from SJ1PEPF000037AE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::1a) by SJ0PR13CA0118.outlook.office365.com
 (2603:10b6:a03:2c5::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AE.mail.protection.outlook.com (10.167.244.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:29 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:25 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:21 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 14/23] RDMA/mlx5: Block generic CQ poll path in adversarial mode
Date: Tue, 3 Nov 2026 18:39:40 +0200
Message-ID: <20261103163949.1554-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AE:EE_|LV8PR12MB9232:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e989fe0-b576-4e69-df46-08df39c95ba6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|261022105027099003|261028144727099003|261021135927099003|261021121427099003|5023799004|11063799006|261026121527099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	vJtp01+s+VJEBWq66aMko+fYTiqzKQPMCxbcGjBcoFtRDfd/hs3RtoscvkpJofwa3U9fmSOXXVLNVFET7+KhJ34EP0apTK9YALb02GQhcYwsgl7b63sf0pCX6eZhyUWtE0VHI0K3DnpuZGlWI8TJtiC+66eFlcv2hB860thYLTlMVK7mtwtMd2rUVrJOMtO0tKwE4tPz3M7fDbPn6fdCtCvUsNffGcmcqvRyOxJiNzwihpNrooOrkw7cwU4RnAxecOwD4D8LR2N+QxCH7vuM+I2hR/jFgUw8Ku0jaz3Y+Nah86Q9PDCqTpiYzYMvWzKq1p8mYRj+bfdsy2R1zKdmFr+FMTJdw3yUoeRNWpEDtG2K/Dtxs5DHRNDCn61maq23LE+v/s75Ap5oSMrmf8NnGN7SQ0CzDVfQXnTMwFh1GGKplGHD3rcu5135oM6SWEG2Usl8jLLqviateFvKHV0g0690ZrO6kU6O8jP+90n1UW/5y6oS6RqRcbuRDo6fGGZdOmszNppACDfx3lfekHrtTW75QCAoq7fjMrg+VB3hsyp9zjzAeyQksRi1hP9w79nsA/1IHFbb1ixiK/0SG9GHNZw0edMHSHdbUWpH2FIZwZTEZ2qaq8LAkug7FbxAYi8v3tsstCxyMg9nzdcWNngXKhRc3na6ffNe5k9mMkDXsRDCTsTzLucIRku3uR/8X2pVAGAdiQXiDC/CKO0tu8JIQA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021135927099003)(261021121427099003)(5023799004)(11063799006)(261026121527099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y0IcrsHCbC+/qv1Dh/I9OwuwYaISzDusdhGNYBsDXem9o+lhGTpuVdCg0wYsmi8GS7aMTPVBgqEjs2S7I7upschAyN8wqL6kJs2fmEU52RF3FHmejC/rvmoOpA5gEF/yvV0ApJs2Vo3V/ihQbw5o7FfLIsXMMeuOOrLrn7YlshqI5LHLIk8BwzI5ED8Zn7+pX1twIF174/wnBW3RQKG0nWWexJGqCJ1WHTvjY0387NboHnZxN8JDl34lBaLEJA/IVt8bAgMb7Bbmh2Uoerksz/zDny3qWJCI4f9qcRdmGD0NY/5zArBIR1PAU/BJesq7xd4lYQD61NV0OfTAYyE20eAV+ji6umznvKY0k+ybs4FHv9MbjcPUP8Wwmi2URQiGxIux5zxypIPerxIYhSTFiEAjFyx2r7bPCh3YWYOcDe4whi1olfxWXVDCfdX4wlm+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:49.7526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e989fe0-b576-4e69-df46-08df39c95ba6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9232

mlx5_poll_one() trusts the CQE content, so it must not run on a CQE
from an untrusted NIC. In adversarial mode no CQ needs it: the UMR CQ
has its own poll_one that validates the CQE, kernel ULPs don't bind to
the device, and user CQs are polled by userspace. Refuse it there, so
an unexpected caller, such as the uverbs POLL_CQ command, finds the CQ
empty and no CQE is interpreted.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 1a98263ec311..5cc86c3f93f3 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -464,6 +464,15 @@ static int mlx5_poll_one(struct mlx5_ib_cq *cq,
 	void *cqe;
 	int idx;
 
+	/*
+	 * This path trusts the CQE, so refuse it in adversarial_mode. Only an
+	 * unexpected caller gets here, e.g. the uverbs POLL_CQ command or an
+	 * event on the UMR CQ before its own poll_one is installed. Nothing is
+	 * consumed, so such a CQE is left for that poll_one.
+	 */
+	if (unlikely(mlx5_ib_adversarial_mode))
+		return -EOPNOTSUPP;
+
 repoll:
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
-- 
2.18.1

