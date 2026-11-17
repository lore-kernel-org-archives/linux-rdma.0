Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935469;
	b=QzEL3lx7j7txF9jW4m4BhuPaR7I6G0iRRenEktXDBbqR/ih1F2qD8DNfQJpU/8+7sbke
	 v+U0TAo8jHXtooLknvMtQrgkRaz31y+QnRYX4BnlNX7i5t7pFWDnSbP6wwPPV2c3/UST0
	 +CExzaTOOfIDN6ZC3pHTlQ9KMgwlIxNJFq4kWAfxJOk/47Ffe80hDfMXWewnJkDtoVvav
	 lAForiXHlhMwk/ObdGmIOqsjiGOe0prBz5unxYml7/ndsT1c/1DtnlXTnGakkc+qShAOx
	 7V+OwcLNTIiSP7O0qmKFwI+iW/2udS2CmEiGlrfEMrwadWdfaiZEebfRk/E6ETcaxLA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935469;
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
	bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
	b=hChLTPmVIseqM6HWIzre2Ezap6m9EggX0qvz6+HcQ0Wli2KNvIK/EUPxO61Z8W8NanBC
	 OqpX85PK7WxEaUy312Osg4yCrFWmhM/063wJEfJUuvRLFq+gV6mOb9NXti3jITNom+ZEG
	 41kB8Rp2k+jeBU9R64J+X9ixaxk6cbNRyWq5BZq+2lxmH3gCDMI8/4ymdkjjXWXpWRCQn
	 CtQUhZmQryJFhUHNT/n/rGjmiuLqahtERgQ9oKsf6TuVDk+DCZU8vVGzwcGn8zfxSuL44
	 9I29Hrs7sX95ajkWkz2n8dkXzSybIjGaakgwzcBRkuUTsdYUz+5dNY6lfUsqJD0x1qA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oDUFdPj6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.37
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012037.outbound.protection.outlook.com [52.101.53.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728B0606A897;
	Tue, 17 Nov 2026 17:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 728B0606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=oDUFdPj6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=js0YQZtPf0abiOHjoHY4Ii7o0LCIIMfM5+ADlnbM+j7BlyrHIk/kwDu4Aw9ZCLwvd6qcoCcd1LSVfAQUHNaAV1CYgXcUNWLm4ARtwDm9Tssjj1zjSnloG1VUjkaCCF/iU5DogOh/3ooZL2821lfeDSpgKuBXAAdLixTTRpd18nSuwNwBbXAQxVBm5zKProd8W167ucWB5KDV/IfM+tTYi3rFpc+gjH1PRjtaA69+vpHVSqyhr1+F98KFM/lToSrJ+3yykGILWnWKHWCtytNjLhiBuXrVUPUkJZ1QFl1h26rGgbTbCP1a9tBU/xjkDJL0VmgXEoyk391M28U0lmFxHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=w0oNChHlWfwABkUcZZio4IKeqElGCVK6q0tUdDnM6CBJtZFHKgAQi6WcQ8eQY+R6PvQhRVzATpFEwQSESHmT3rTCihEsxkIlB3nHI0QbdXsVnzIOtVfTfmteEgZae2QuvaoLXK5LHgYnxPVQgYODcVIn0qAqP0KYRW3Kk5gn8bxqx8r9Ii02y3XMjRsPOs9c3a+8/T30sd6PzvL3Dq//GeiklHKSvyO13HSw18gj9x8NaoIHPDrZM0YZ8h141mHwpN1qsBpN62cRxi43AWy9D+kTJBpv14GmnFonziXB1Hs3hHeTdS1Fe3rGeRHoQux0Q8cKUkK+RxtguIC7wwVvFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lps4D5W9mJL6ou8wqNZ/a5adRPBt1+9AAkuo8/kVpWE=;
 b=oDUFdPj6O/6Vrp+NwC3HitHWCnB21pNXNOXXHJbCKqR23TANC+Xi6Gq2h/3G17omt1HZVcvmpASTD2nIaK1LlhTLBnTr2JKrdfbtFfG79OhQaXgrFHSCsYeaG59u7KHnPTW8IVnChxc5Mlppd0ZIgUZjKY4+e4WVl6WJTbxE94c7yIsGoDTYTvvfAzVWK4tExPjoM64BcVKGYBxn+GAPMBm5VAR9IbJ6eOJozFhi64FsH4xgyYOPJs4yROyWrxYRg+xBWcwGOy0KwEVbDEOPm828uyAZ/UCg2+DgjhtHmAWv/hzJFqRIH5EK+kXU/WpYfo9U0SKbqvfqCXH2nLOWKA==
Received: from BY3PR10CA0028.namprd10.prod.outlook.com (2603:10b6:a03:255::33)
 by IA0PPF7D094C5BF.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Tue, 17 Nov
 2026 17:11:01 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:a03:255:cafe::e) by BY3PR10CA0028.outlook.office365.com
 (2603:10b6:a03:255::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 17:10:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:20 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:20 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:16 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 08/21] RDMA/core: Suppress kverbs_provider for adversarial_mode devices
Date: Tue, 17 Nov 2026 19:09:01 +0200
Message-ID: <20261117170914.27410-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|IA0PPF7D094C5BF:EE_
X-MS-Office365-Filtering-Correlation-Id: 748762f4-1410-414f-c5f6-08df44cdbf0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|1800799024|23010399003|18002099003|22082099003|261009221227099003|261009223027099003|11063799006|261021135927099003|56012099006|261102123227099003|261026140227099003|261028144727099003|261022105027099003|10067099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	wOKc+4k9BCjYuURe/qVfPa+swHlefg9Bh1tn02VadA0BlQAkVbveilqOCSOHdH1J2z2+c0/5Dt5j7ivkgJS7DLdd+r6Ds//8DiMsc2wApUGrXSQB69j2UPM+PRd2iWnzJizDndaoCJvEXGt7PIAFFm6F/ia8f3TG9cM3u8uLwrFyePyTkzMMmEZt6VFd4BJzb0j6cu4BZpN0XPRL3+2rWa46m0V7xWEs4xPN+6B4q9SMr4Xmwxrf3ENiqFKw2h46xX/5xICRHyoOVzhKmoh5n4n5JO1muqQhFbYKWO66nBjnOvn8p6v5X/q7Zot5HOZiVbk70LCRwgBR6NhWA2xhMm7D2wpYsjc/R3c4/iK/3i5tOF+8cqxsRjJTQHbop+Jb+swIzA41NI7h0Qqk/Ayk3NtOg/oxyeoBi7KqXOxlczfeXhxghBiCIxy4v3L2BjRHLHzqv113yXwMNfrmSTXDoCWiMD4thp8fgj8Z8CHVBoU32b7+KFh0u98q1FG3ERsevrrxj8gsYuZWoDMN9S0piFyBEli7W9gXUJcG5pOa4cIZMoKHeY8j/TMIueSS94bcbiIU8R0mVSjCoGuAvTW/5Fa3z+8rzIFeT2ac+PgWR0EjpLles55t8lW70dUcKsxrir88fVASsIQTHwLcriCMMQoqVcq1YV92DrEzH0UBbntT9PNhCUiJRlNV7SCPv/9UUYs5XE5x69f6LXDu022Qkg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(1800799024)(23010399003)(18002099003)(22082099003)(261009221227099003)(261009223027099003)(11063799006)(261021135927099003)(56012099006)(261102123227099003)(261026140227099003)(261028144727099003)(261022105027099003)(10067099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NNI2ov4/6OPj+vWsBb6o/uqPf13bO+6GrFsSQPGU4MwlPJm/H8PQufgDtW9UCcjxgkcqsV+ZeRlh+AFsW22nCrH0VDhrRucvEFWajFwTO2XzVanlnUHzrqseNvDewb1MDAhUwii9gfDAZU9RP8PzGXUAXOUA1MRN8ao4giChDrSI75CgUrFMFQMb8r1Wn+LsZNTYLz9dSCd3lkgjQWYWxdI8/PXkvcQFLJ1FF5WMaDzNbkrI7g0EjoxotGLB6YsOpGkjE2IW8MiKAFqj+EsnXHxqPmKEkxDxRtLgFlTP0RZB2zcw2pzX/QaKdnkqGJEzq/09NZiBT9is7p+6VbOPdGuSnHFZgzoJrvB6soNxMXevg4Vr7wqjczko8UTxzzvv0KG4UTAWepCl4bmJzglN7NsgqHzTbAKSv3RnLAkJQ5rMHR/KE+5EdylCRK88q1hZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:57.2953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 748762f4-1410-414f-c5f6-08df44cdbf0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF7D094C5BF

In adversarial mode the NIC is not trusted. Kernel ULPs such as MAD,
IB CM, rdma_cm, IPoIB, SRP, iSER and NVMe-oF trust what the device
reports, its completions and the data it writes, so they must not use
such a device.

Add an adversarial_mode field to struct ib_device and clear
kverbs_provider when it is set. add_client_context() then skips every
client but uverbs, the only one that sets no_kverbs_req, so the kernel
ULPs never bind to the device.

The driver still implements the kverbs ops, as the uverbs path shares
them, so kverbs_provider can't be cleared by the existing check of the
mandatory ops.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/core/device.c | 8 ++++++++
 include/rdma/ib_verbs.h          | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 29af9fe860e2..eb6aa567d365 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -312,6 +312,14 @@ static void ib_device_check_mandatory(struct ib_device *device)
 			break;
 		}
 	}
+
+	/*
+	 * Kernel ULPs must not bind to an adversarial_mode device. Its kverbs
+	 * ops are still present, as uverbs uses them, so clear kverbs_provider
+	 * explicitly. uverbs sets no_kverbs_req, so it still binds.
+	 */
+	if (device->adversarial_mode)
+		device->kverbs_provider = false;
 }
 
 /*
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d6eaa3fee66e..6209a5166f0d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3008,6 +3008,8 @@ struct ib_device {
 	u16                          use_cq_dim:1;
 	/* CoCo guest with DMA bounce buffering required */
 	u16                          cc_dma_bounce:1;
+	/* Untrusted-NIC, adversarial mode is required */
+	u8			     adversarial_mode;
 	u8                           node_type;
 	u32			     phys_port_cnt;
 	struct ib_device_attr        attrs;
-- 
2.18.1

