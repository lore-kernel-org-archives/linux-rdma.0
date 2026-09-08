Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010015.outbound.protection.outlook.com [52.101.46.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAB55625E0
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881431; cv=fail; b=AFkDuVRq5FKy4bflUl5SUe/HDnC7UD7adC3PshBOCP6safPayWKULSY+RhsFFrSxUBb6kC3BXhrLuoaEPBTES6P021m0clgPYkZnDrVBmjfBdtpYnok6Ipr8xIIBW5NlIu+HLyzeCxtQ6MWWtBLYEZPlae/T63mLcrvXPposoXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881431; c=relaxed/simple;
	bh=GfquR97vZc/UnzM4gpsS0uSktbGLnInrkQCYpEMMqro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hjCjQSgWh7w7twSe05EtqCTGHtmV5yBaYYnjfcg2E+6MjTshbv2WqO0nuntHd/qx2uOBbOzvt6iLN9HR5YUyKsH+ayFNZEShH0UuD6vt6v1A1pJlyOZ01mt/220QzjxADmBLKT0SK5+tTO3RRPFN5P5n/kCLjOGj91F+RcbY/d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WB1SsEvD; arc=fail smtp.client-ip=52.101.46.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WB1SsEvD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L22aKdQe8rfkDYqM5tWcPUiAOslr/Lnh3bKjwWoczE0eU3n3Euy5uI7WZZkIftvV5v7EoI66PaaTx8YZyq3NUCzQobfggyj1YcRzQxRxvA+/akovIS7JLv/1caSmle/Z3EZNmu8VuZ8mf/P/yvMI63a6ijcogvqVPkUdzNS/bA6aLyuJjqFpECEroHdYa+UAy86UfSf6IaKHao6yGN5ga0UMKf8mphftn05TpikikspdghDmqZCk4ycYCP1CWVU+QJSQP1MSpjRmsbHFKR4FSgossxAXCC2iwDHnc72TGADOZmrhxsCvvKdKVR560jF+/10kcbL7kEPA/fG52o08Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rtsFLvpHAt6DHYyRb/kflOg09UvvYim2VCEXEKb6gA=;
 b=F6CGNGc/1PvCiVDftzKLGKK3eZQ6GjDaERFtPgdpB08zVxFjgEARrMB8C1cs0/Uu091QJ/zkj2/czQbdu2Gx8WrGdHdhpb0XnZ1B8tM7JDqhLL0WpVBtBYgq/epMM1dxfAJmLD7renEHEWCsZ/sLqQdnguY+VPhaEtDE6GngyrN5J8IK66vEeFgQo4bXXu3hI8k9xaU6rAdd5iUUOTGAwoOugH7w1fDfSioz6AdPvcJRLPAmNEMs1olDvspTovpUgGemKIgzf8guAvKtywFUEvLS+2TEXkUZeI03vBYvKkuJAu5J6v7hLyTMPICYfRomvXVO6rgSD93wNVHXvvst9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rtsFLvpHAt6DHYyRb/kflOg09UvvYim2VCEXEKb6gA=;
 b=WB1SsEvDLd3YWiyjkQsiFGExmxe+01oj3oC50DhBFDg3eMD5EobZLkL+/2rCgXsG4rp7xVHjDv22N+zGp3Sdyu3gwiLoSAsLV50td3Zcp598DN1kM6xrodoWwUIGDX3d21g8GyoSBHWjkwzqokszb0LGmjb3i+m7gzHZNJgYdhDhH1+bs4JNo5RMz575+sB2JohGyc9yu5NKRwpFsqeXfxuwL9NcX/HxQC1gSQZ84YUYNaqSMvVKXAu4xQVK8Vhe+7Vss84rxqfs/wn6mVRuCDJJpjtjbO9miWr0dymoIvHtk5jqp5Ta+x/uhI388iH+vZJU+qvu+Az/VYI8IoUszg==
Received: from CH3P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::27)
 by SA3PR12MB8000.namprd12.prod.outlook.com (2603:10b6:806:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 15:30:05 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:1e8::4) by CH3P220CA0009.outlook.office365.com
 (2603:10b6:610:1e8::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 15:30:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 15:30:04 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:39 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 08:29:38 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 8 Sep
 2026 08:29:34 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 02/15] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Tue, 8 Sep 2026 18:28:38 +0300
Message-ID: <20260908152851.1307294-3-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|SA3PR12MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c4bdf4c-8fe9-43c6-b679-08df0dbe0e6a
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|23010399003|1800799024|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ryzzI9FOOZVsunhKZFSIpk9YJ5g5ksnbOlApksM9cfE+GZvXdEl7zCzKO30+Ndv1wWzBjEE4Rb1TmJ5w4q7Q0BM33YZi5vAGjqvkJPMrjzGY9CRaJ8ZoL35FhKkA8tVQfLdRSNDJ/rVPtBCZoHR54JSthmJNffHLUs5tYtTmyTbSU+L7FOfyaAn5tsV7T9GCDaP8tX+2+WvKZCKmHpU5mwB4fwbZNOLFibRhNHexsS8dYdpkLYR1FRLWzL42r6IX1vFBk4Wv/AIv7DWA8/IWtqd2kONdkp7T3U6FkROol4ZHrRKx6iT4YtKbFFoXSzR0KCKSVaXrJwYyptLAv/f+OXAqNhtwlI5fpXZ/B2DbdWlMQTSdZSOBX65mSXx/6mMkebnsV9u/sDwlTzIi+gekvJJSDEud/Bdszw6+tbKIo0sUskdmYZr9b8hjjEnn0gtF7OriaO6jOSMfezAdq9rtuGlVyg+5p/qr5as8iN+JZ914hZtYDPIXgL67Per/E35WWMB9Uti1KpkO6nJw0NILaOuinDqm99K6qWja1fj7Ykf0BxRZAIVPzhzjYCtoB8VyxlDIYdawGdiFabgMHuTf8AtrGFSu7bu2zTexVrIn1nN3cSV/W6gHD//oR1VmzGPym94hCcHP25NxZycyKoLq1clDQ97Mj2l91oju577AX8K7nFQLSqYC0XstUWia0epE7RUD77+/H8HZke2rUGmt9A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Km/CE7g0HyvhaL/70IlH7CXOF5CwMo0kFW99IDJtFV67sMiCwczs9sP8HBnw8bMYtvEvVHboWkxGYrjil/C0Z22SyBMpJIaFVdp3bT4w9t0jFxmQ2abPcpjuBaHpUIO9h7tgo12f8yByqNbsWd9ynF4XhF3oiLRdjwNpCq2eXbng0eZJvpDfRNh6sgkYxec8o0JK15NzJQpaZ4LJuQ4igl+WA4zP/pFELuvodhXFcKZ058eskccv+tytBmao0e8PfvUDKKS2Xrk3FjKRgksIwe1+8GTJhg7CZ8PXvf5DaWUUSOOw4BNezKt3vv4ygVkZSd7ZdGkvaVyWfAekW9uJNNyWPHg6I0OsW2Xms4dftztXVRmeGMJP9V9/izN/D8gnt+8pl5EmWa2wk6IEta8d0CMtUQtVJBbranbaNiT4rHZNGuGTeRVkmrH/He/Q9ZW1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:30:04.5093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4bdf4c-8fe9-43c6-b679-08df0dbe0e6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8000

alloc_cq_buf() builds its hns_roce_buf_attr with user_access left at its
zero-initialized default. The device writes CQEs into this buffer via
DMA, but with user_access=0, ib_access_writable() is false, so the umem
is pinned without FOLL_WRITE and is not marked dirty on unpin.

Without FOLL_WRITE, pin_user_pages_fast() can hand back a page this
process does not exclusively own (e.g. the shared zero page for an
untouched anonymous mapping) instead of forcing a private copy. The
device is then free to DMA-write CQEs into that shared physical page,
corrupting memory visible to every other mapper of it. Missing the dirty
mark on unpin also risks the device's writes being silently discarded on
reclaim.

Set user_access to IB_ACCESS_LOCAL_WRITE so the CQ buffer is pinned
consistently with how the device actually uses it.

Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1dd0efb5620d..ae314f136732 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -261,6 +261,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.18.1

