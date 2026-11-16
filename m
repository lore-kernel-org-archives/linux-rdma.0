Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794844702;
	b=v5KwG4PGudIWbex8JU+lmTEMjJp5pxb0KUGdvDZj0nMhKsi3L190bxyABR3C4JmDSXgU
	 MsPYVkQeF3880M0j+A6acVPz292frEhBotImWeuZNcEo7h/m6iQbCyrePnqjIWBmGe9QZ
	 /3efO6d225RwzNak01eet6qZzX+3jZ+pPEvAPA9rFcLV8BNrWcstfF+oFk+LzyO4viBnD
	 1uGsR2Dp18eq6QShfg45gvfp6nfffWuwlG9OKeWf/HROyaPPWk/IUANxF7q9OFWkdtHZ4
	 zH9bfNbGycqcRLjtjRGiG9Gta6Z0ufD647xNQl0YCfiI0hiwJTc2eZHfoXcnJGqfRsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794844702;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
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
	bh=SBXNk0mXYTcE7uPr6tXMRVqtZVVU2zQwgUFPvxwy0vg=;
	b=qNiLMP1356bdeDLzHQLa4OszxaRP7DRJuMgzTDIl3yEjYPp4SpM2L1YTrUlai3RICfxi
	 HJV7SUGLPn3xHM0Tnl4z99lxakTKXXXKXCeragOA4DjvsggVrnRyGAFjfRV8AcMKgz5Rs
	 gjJy6+Bmx4rNUfPHIt4kcTTiHDJabyybTmq9+FTq5GnxcRM00nFWdTnyK+Xd+VOklzjG/
	 gmIh+M/f0oTmaGzH74ktIQfVuiw67aQ2bKVrEj43CuknZ8ei3eVzR/ejdtDNzdfYGvA8L
	 ngVckrsvKphmbD2i+V0XsYb76ew1jX5QkG8vXQ8rCfuq0qCINMfXVBErxJQVFCjqRiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PMKiIf4i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.11
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE18606A31C;
	Mon, 16 Nov 2026 15:58:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDE18606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PMKiIf4i
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6ezl6Sw3blwI5qcegRK5/kWW/tumk5IgyQitcJOzw8X3QSTujxvAUb4MaBueXLl5N+3ujk9c2qRRVL6bWgnAxlEOJq82VYhktKKnI5e+5u98V4Kgk7LWqxQrXYxwlC7UtXcjb5j2QHHY11GcI2+Csd16Wh9q/b74BvpCnt7HkQZHvHZPYgbSXrbF01r2VVcNGSfq7PYE+tyNsy2HTMJaWR0ZkL3rV0w5n+8fQs1AeRI2ul5RZwdE/VwZt28G7QkRAELgOF4x17ONtuJvQTp1mRFu0Cu1QxqzXrZxY6MOyRLidh0MEAgylP+fSGbMcc07hGNxbCie06k1ftsZTQ52A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBXNk0mXYTcE7uPr6tXMRVqtZVVU2zQwgUFPvxwy0vg=;
 b=u5+V/elADjIVxqwMQfFOuDm2CLwGFXMzz4CMX2SVPjpXnKgiyUm7ybelbTMh2xEonlPE3tAfn0+GCKxgoLfDMc0RXjyNUeaCvHdehshOSPiADRby2CClY/e21N/m/DEosxhcQLetPTAlffyVtomGni0/E7b3Eb6pGAijGEIe7Lqy3BnPsrkit1amaCXGhG+UY/mz3iCkdlYSi+gGyp7ZXe0n6G1PrUe6dCvJLl6IvVBs4gw0qNZgT6kgaTCbfXg549CHhgvDyRp0f7S2Kjahou7b/ighlkNnhrJPPALoF2lkzToH6wjHEFwQX3mT0az4u8qFkXyvrm5O+6XWEeJXGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBXNk0mXYTcE7uPr6tXMRVqtZVVU2zQwgUFPvxwy0vg=;
 b=PMKiIf4in9BZh0C63S2kP1Kp1gYdx2FrW28rkYG6msJE6Lu3q2yGlAKoQARrx+9mnKjSbjM8LfXOytOdnXVj+XprWqqyMaqWsgC2z+Lbpsg1PytaMHbDP9XrodJMMLsrVq+G+o44qSlX5A39jQOfpL362Yj50w6Y8A/LKPtxmW3QypRKo+eeO7ByESDVYDShhXVhBwRCg+BWgVFNZ3IBwbOnY82wh3wjK116vG6Gg/3dc3LuOMUWSRfh2QxFkGlFg0ykwNIT3Hg15JVI3HC3OThmKCW7qDZnQYgU9PW4tMmE/yTDaSvnI81xaOWlvsZ8aI0n+kNsTPcA2kOEPRbiqg==
Received: from DM6PR01CA0014.prod.exchangelabs.com (2603:10b6:5:296::19) by
 CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 15:58:10 +0000
Received: from DM3PEPF000265B7.namprd04.prod.outlook.com
 (2603:10b6:5:296:cafe::73) by DM6PR01CA0014.outlook.office365.com
 (2603:10b6:5:296::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Mon,
 16 Nov 2026 15:58:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM3PEPF000265B7.mail.protection.outlook.com (10.167.23.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 16 Nov 2026 15:58:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 07:57:50 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 07:57:46 -0800
Message-ID: <a262c03c-85e3-4926-97ba-6b660958e4d1@nvidia.com>
Date: Mon, 16 Nov 2026 17:57:43 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 rdma-next 11/24] RDMA/mlx5: Introduce per-CQ poll_one
 hook in mlx5_ib_cq
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-12-yishaih@nvidia.com> <20261116090141.GC11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116090141.GC11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B7:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 17b69af1-1a8f-40cc-576c-08df43fa6975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|3023799007|4143699003|11063799006|56012099006|10067099003|261028144727099003|261021121427099003|261026140227099003|261102123227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	TG5w1Tp4Emfl/LPL6LDo1q+myn2U+RSU6VyRYcPgkQAmLwU2Z8HwTXIAaynnDkLbuJH88qGgRmNMQmXCXblLI9CMlG3je1WljKIvI59mi4wA108FFHHXB371FM1oso7NOr3k40oLyMEAlrgn4SmMZTxm+jecrczrX/vp0ODtwk54GHp2OxS2y/eQ8rMVtXQrn1YEg8FJVMaaUjX8Z1DwqToCbOPeYCuKFcXQd0//LuHrVQUijK14k/5purw1WdOxM9ks+/dMjU8TqdQQtVPcMhMLWvcF8DkPl76gC9IzNPrtHeEMyDixAQ8R+ozI9WRs81su/0UDrEx5taHpNWfgNNpSkFYkb1gqxo3jbe1ZQSzI1REqb2hSYTyLfPINlf/cYaBLFz6yrjT12mvqpYn1473v4Sft2bNPUNPnii5f5ShCpGkW5nSebjhWat6QrN2inMwc9yN8NoB4CiRb2tPOh7PuKcOcPrhg+qOcp/xygrLMyshPxGe5t3+HPoh3+STeCW/QRBYE7pxTS9U4sjASlqhheUmowv+wcCEgb5TUXZY9ktdwISr/8UIkNd4RxNpt8gf7D05ZREpFk/9fSq81WrKEKK7qGxYQgFSlBKXCSVnqCVUXb0KuxVPVhN9Tn7cChTW3qLSR3Aen36Wrx8p9WDHLVWjMi7qGl8VWdNyvCOTAL/zRKXuwqsMmlyPJrqLGn520bbagE01MzP5aWxxY5w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(3023799007)(4143699003)(11063799006)(56012099006)(10067099003)(261028144727099003)(261021121427099003)(261026140227099003)(261102123227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hxPodUoJFaSBHToxBCd4aR5VOEuDVjW5QCUk3Jr+w8HdxO37n+ToHbZL/IshC8fd0gAc/Do23DMJfbX6kgqxQQ6cNQ5mOW8gBBsxHXFG1hN3RZKL2HZ6GClruWrRanHULcwN1iVgio7U8KlYJQqQLfOcmAWZg5Kvf0z84rggkbybqWvWNPSP5r6gANPbL/13z0MyZ7Nc4C5PGbVe5KT6O6/CuexuO+I0bK2Z5hK2tOmbs6zBSiJsQhc1mwgn6Dw/huueGpymHIfQsL14lIVTBF03yRbJZYdIio6u/3io2lF2eP2LeId91fyUYEWVXib6d0pvnVKl2Jjd08e0W76YsRr+GUyTr+6pkQnm/l85FTDH2soh9Us4m0f/3iuPbZOpTpgrH6NqdOglA1VI3pYrl8uFUV79WOVNUExziOszdCGJ6KxXBlVXmKwNUGtce/wq
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 15:58:09.8732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b69af1-1a8f-40cc-576c-08df43fa6975
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852

On 16/11/2026 11:01, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:07PM +0200, Yishai Hadas wrote:
>> Add a poll_one function pointer to struct mlx5_ib_cq and initialize it
>> to mlx5_poll_one in both mlx5_ib_create_cq() (kernel-ULP CQs) and
>> mlx5_ib_create_user_cq() (uverbs CQs, the path used by both the
>> modern ioctl-based and legacy write-based CQ creation commands).
>> mlx5_ib_poll_cq() is updated to dispatch through the pointer instead
>> of calling mlx5_poll_one() directly.
>>
>> This is a pure refactor with no behaviour change.
> 
> That is only partially true. mlx5_ib_poll_cq() is on the data path, and this
> change adds indirection to a path that is already full of likely()/unlikely()
> annotations.
> 
> Thanks
> 

OK, we can improve it in V2 so the regular mode data path stays as it is 
upstream. The function pointer will be dropped, and the poll loop
and mlx5_poll_one() will stay unchanged. mlx5_ib_poll_cq() will check
adversarial mode once per call under unlikely(), and only then use a
poller that validates each CQE. Today this is only the UMR CQ, with 
mlx5_ib_poll_one_umr().

Yishai
