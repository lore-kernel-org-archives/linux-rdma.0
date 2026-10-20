Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792491091;
	b=uXqjQ6D/Vic9eAA5yHW6fsQqUUOnSjxjdwmBEUtTJhyvTjRUOxm942r6+ICXHi8dW6S8
	 xY4jNIYGpU7NtcrMq1CCUQvnoYvi9HYsjS5Edz6AD1gzu6dbja/Y11PidnbpWtYGJ52Zq
	 AwHN5HHXNqAffW5yNJPZvoCRqw+AFGvYmbGmJ9v4lYSvB2sOeI63ArOWCW0bltSo2T1kY
	 yVBbXVxDypLiGfi82SD7J6l2D37yjjOe/GhnD9ABO6gQkB2shiGkiqb0OLRhgPlD5oRrl
	 Eq/63Nh2REEPEyOkRxr4dixVMWVPa3KbZ6zVRKl9XiPQNI3WATfKZVUyef0lS/oUNzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792491091;
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
	bh=cjSvkt6pmDTNKcq4L0k86IwWllmzcxKoSKxeBKyKWFA=;
	b=fDOzpeB+WX09FMkLwGlzICXGbUERXmc4A5huCMEpv9HMXBCALuZry4L4qmqlEqNoPmco
	 bXDtGv5KX1SXUMxEQSh8wMznyJHZQ0AouHe1Qyr4eHHLlxfPlf2TVuBMVcEglEd0oxETt
	 nqFE3J7NsYCQsIcZkSrIGZTc9eW9aNtbUklhHj2yqUaCvhkfwaU4xL4Z9TkSxfVVDc12x
	 tGKNiOHmkJZGbO2hHrwB+nT85UGZQHM7L9HSfklRcVYfw/8dbzXZPQCOXF/cPqY2zm3e5
	 l/K1ndqeFcyQkjJqK+xkjxSQmQB4lUoSWzFRtQLSytQfVjYzsGK+++aRJVCbBvzkyvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="hP0rY/i1";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.55
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012055.outbound.protection.outlook.com [40.93.195.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F8606A31C;
	Tue, 20 Oct 2026 10:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 535F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hP0rY/i1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifFDMUOJ5oxEgSvFd7Mn7desF+lTTMdj4UnL4plviRSrhsGyEiaCEB748rr9UMoRrs4i99R5GbUMndwMix8quCGjko01PrhxuOrdbFF593OWal2CiBGsE+SypPrlHF3kSGybO9vD1e8hVSJZ9T/AGiwH5wbtX8tep/73Uw1SOmqwed5Pz6hGYsDf3RG2zYmYW8lh26/s/ZgGHpSLAH8kBA/HIDV+wUVBhTERikRf/zmbmn1ltKH+zHZ9DK4xLqjO0/g5WDh/zIfOL+Z5y9fVnxZm/E2wM3ygUeqWGDGSP+4rAe8rt0l+svironTwqYJRmf5pJINyBPOxLJjM3kgAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjSvkt6pmDTNKcq4L0k86IwWllmzcxKoSKxeBKyKWFA=;
 b=r498A6GqFd/Cly2NkvmgqLNt5qE3VmLi8LzG6wDI+SzjXCLbMw2o/HA8WESjy7XPgOqm1K67d3DBK9E8tCL5a83I4kTbTirz8pusdAcfHazY9G1InOWMmflfEZsrPsxY+5exkeIW5rkAK/+5CfIqhfgEg+yxOwXOG/VyGKC/qJ+E8Gu+WHiPfoZoDrYhShb7nuVQt8c7HCidEGe5TDZHohmKNseIP+4+n5lbZLjyZPuIVbKY0ciExnThE5M7UYG23WY1FS1tC1NfTv5qoVR8JBJcIxAgDq63VNTDiSdYV/mwrFw2IRBgyMa4b1rI0pW8sFzbRUzFAqpL1RP4s+HdOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjSvkt6pmDTNKcq4L0k86IwWllmzcxKoSKxeBKyKWFA=;
 b=hP0rY/i1xj1JZ9nGqzIbufj94rlYpUK8A/7omDhrbIQNn6A3+t/i9ItqKBfdKORzD5YgPY4DMIJfLxwIxVwf/8cehVKfgaOyO9se29Q1YE4y8xPz8C9ZpLkGikDGJSy1yOyFpmzU6v335wQhBb+Dh5fv4M2W3ntN4nE0RGMBTO7+5gRRvHI3Z60N2zN6RieLOiF5odLtqzQQoEWcr1vsOZPWfCX7HvppULYOwBXBSEb9UcAyDju98rI1MOCv2kFElumDyA+6zEWpOUSEOeoY4X0rJPO3DUdCFBYQ0RxPAS+Iy7BxFWFgExJd1CRLdqVvOizC6l8O1mR5/EvGgmUI8g==
Received: from CH2PR02CA0011.namprd02.prod.outlook.com (2603:10b6:610:4e::21)
 by DS7PR12MB8203.namprd12.prod.outlook.com (2603:10b6:8:e1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 10:11:24 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::9b) by CH2PR02CA0011.outlook.office365.com
 (2603:10b6:610:4e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.18 via Frontend Transport; Tue,
 20 Oct 2026 10:11:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 20 Oct 2026 10:11:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 03:11:06 -0700
Received: from [10.242.141.2] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 03:11:02 -0700
Message-ID: <8255a276-f13e-4aa9-b5e2-d814103f9368@nvidia.com>
Date: Tue, 20 Oct 2026 13:10:54 +0300
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
Subject: Re: [PATCH net v2 0/2] net/mlx5: HWS, fix pool creation races
To: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, "Simon
 Horman" <horms@kernel.org>
CC: Alexandre Cassen <acassen@corp.free.fr>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
 <09192a25-f141-4a88-bc5e-ffda957da554@nvidia.com>
 <20261019185104.7a2135c3@kernel.org>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261019185104.7a2135c3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|DS7PR12MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: f124edbc-56e1-4f88-4c31-08df2e927f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|23010399003|82310400026|261009223027099003|10067099003|56012099006|22082099003|18002099003|4143699003|11063799006|41080700001;
X-Microsoft-Antispam-Message-Info:
	C6cz2I4IzycBM44RTYinJnP5Q0475mmjwUgZGw8irlvfNuZnBsNCaKA32OvPpCpi56qkWeo3/tc16LZquw1G9r03palOw9FGjQvMOZeOzvWqfuqACnz52yypDpoxMzfck7Y4gy6IDTtwqJ06KsPcSOkw4AyAbxx0CQ1a3QXY8mZnim+nYWZFe6otbB5VV9yDsLduHWmrHx1pGCLx4+Tloj64nFaCmxqPvcQpZcLS3PGW/mwIh1XPSwDbr6jaWPoBFAKCaO+6mwOudAnS89GW/QRgrauk1ibD5O5mUsz4MjGcItl8Gr4wqklnM0s4suqSLvHlFR3rPJ0BnXO+m60oLPwquA27K+vBdHe9+s7ffG9j0ys4TX8e9FJBKK4g8nLiZIm/hTE9dcxKvJOmw4zadLuGRzwZH/+MR1rxKT0ikvnoIESsb4dZ2XxWn7BasCU+vwJP3Tfp9KQimXocPlYCt7jLZDWsNNz+w5II349OeHu7Scr/qH0kZw+oJXKNM+as64Lv0DWoYWMCe/btZeMnr3fblbPRBhrGwPFkMiynMqpohk2xV1DhXidwcqjgrlY1dEMn4BQh4ucC31OqkZ+0Uwf8ZBPjrIbrhlpZu8xs8ty/fmwi1N6hk9Q96zvlhV8A+haFbQYpiHdqbruzMO0A4PgefxB1tCwih5igYvTTAz4Ufr3P1wSPBN9w3bOSU5ZgITstECH4TTUGx7VTbIRy2Lbb25UQgaH+MUuOX73wC0yw8fEy3nL/y2QPzOjh+zcnMXvSOLscJ0wTUDP4QoDaYw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(23010399003)(82310400026)(261009223027099003)(10067099003)(56012099006)(22082099003)(18002099003)(4143699003)(11063799006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cerbUXCtRz8JPZwBMvma8I4BLwV/GoSLHt2x5EuPRxnCsw8gQo7vb7PctvkU8z/H4K0VslUWpVNhh0KRoTaIxm4C4V4b5XSMIq4VzeGtNyQl2nrHbffyUUeE/WPPwzyPcGMfkRG99VJr46bFzcooR86rmyDO+VD0E7/NGfHmWV01bmHe4t/wcD46bC9/N2/60e+XBYRiuWaqpJe5IYFFKGotz27P/NZwNWNTMpxGCVtKwLoxIdjpfWGX8WYuxSBh/12PF/V7Fdn0AX7AJjrjgqRr//QuE9YQmXuQOGS3/jCvC9oQ+OlTQVEJG20zoWLX8V1ox4ZkATQlb4nMuypuLuKE/KPsNKA6vo2yKbPGJOYu6J/lYCvEyT7UdXlEyw17ZWOIhdpqr85oIN9ZbOebbzEMD1FSyT0QXSTdQd0GS7D+Y4R4TbeEvDry8NoL+z8r
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 10:11:23.9937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f124edbc-56e1-4f88-4c31-08df2e927f0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8203



On 10/20/2026 4:51 AM, Jakub Kicinski wrote:
> On Mon, 19 Oct 2026 14:25:38 +0300 Tariq Toukan wrote:
>> Acked-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Clashiko keeps saying that the problem solved by patch 1 doesn't
> actually exist, could one of the reviewers of this series pls
> confirm that the AI analysis is wrong? The commit msg says
> the problem itself was found by AI, so is it not a hallucination?

There is a race here.
mlx5_cmd_hws_packet_reformat_alloc() doesn't take a lock while calling 
mlx5_fs_get_pr_encap_pool(), so it can run concurrently for the same 
size. Reformats can come from independent flows as TC and RDMA flows.

Note that the race did not create any leak or UAF. As the commit message 
says "Two callers allocating the first reformat of a size at once both
create one and the second fails with -EBUSY.". After the fix the second 
won't fail but get the pool the first caller allocated.

