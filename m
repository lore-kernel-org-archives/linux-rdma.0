Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795409655;
	b=Q6O8z/jDaAcJJps5xLHWTux6y3gE0E/K4mG7KF+H1MneACbM0nwWGVsoRS2ShayMxCTi
	 Mz+rBPeNHlIY6aQxcOwcAXpa3Gn0oJhXjgJR+S+YVWHOynFD2e3sGY/Jcc7tj5AmgLOcf
	 ry6yD8tkGuFflbrwSSeVVITQ8vKLNkt6WGdfXVrMzH2aWyDsVAvuv35qsID1bmiLjLiV7
	 jfQfCOjHM7qthZ6zj7lnHO3ySkAE1W29RCavp+UkTRj0ZyfyaB50CqhCngQTb/B9b2vXY
	 HQa1Jy0IGcqWHLAe5h7wm74pXk0KgO81vK7iLexoSk/pfTDICiuKrNvR8tsfx0xEmDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795409655;
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
	bh=KT4o8nt4llyColJJhwIRSZnGIF/d+XeGV38+L12l4L4=;
	b=yGSJVc6a04/0Pos1cT/Y4CVxeqfOtOXXldDwdujahDnZA6XHUaK6OE7lroVCSkUp64pL
	 2HqUDpd2+CrwaCrEWChAVuhHjSGTVYtTXNbOkT+4eCtq9ly9Uxbh1910Qw2U0EAvT8gz0
	 a+IT3k0LVBrOUmAypRJgFWMk0sOLv9BUuAD6a+C1g12qjkvwuNtuWe21+43oTxuG5PcdR
	 iEgQTANOU+NDmYRwf75rbZYUL7lzsXq3FUlTgGy3HwChWnFsKYyG/bGDjrokrTJvXYy0h
	 sbCKZ/bqaKrJppWqR3jOqqkO4D3nyl2IqO50XriQW1BVkNmQXAGEP8e6iHjCSaYoFuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uOiYFirB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.25
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D19B606A339;
	Mon, 23 Nov 2026 04:54:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D19B606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uOiYFirB
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bY65t3voyZ9aUnDf447FLv2o0APhFSN+lT75ztdFNUFv/8jVDQ3VQSubRo2p3laTUW25h/sJlVzDopnGsNSQHx9e/C69MRObc9jt+bi5Fnv6uQ5UDjK6N4JzOmsFXuc+Xq6RUn3fUG8BDkmPWBKlFxsBf4bTIZ+/8SE4vWE+RN8yvVI3vE0M2ZFYVT/4lA/hmv88E57n4hOUKdRByBOJJF2LAF2bZpKCGai/DsF7/9pwqy7Y0QqUVTrYwqc/RWuYxc7GZG2QJO09wWZHQjBv1A0TkSux5DloiFNDvJ2NFf7X+A+axE70cl+QUVoeofXdpHy7eF1JF9mqxbQSrCGS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KT4o8nt4llyColJJhwIRSZnGIF/d+XeGV38+L12l4L4=;
 b=qVkg7LrSBgl3pmj+ZoUlHxohiUNUOJna36lGVtWL6JTWXe9maObf6BpA4F2CxPcFGMdDfVQZvSbVVw281yrOgoRHIBmo2UyoUUIBk8JzYwazjiXntw8cBrDo9UQP2OaTwP4YLQyZ7V5IjdRNZl9FxlFdX6Ooisq2ikvkf4vu1VHM9mJm0C+k4HS4oGq3/lOTGi8NkhFqkvX98bnUEi6yTEq2aOTWnuf9QugL3TI1wYrKOK6Jrxd8B5keyK1+hJObPgo6Y1An1BxJjMbQiQKFXQM+QiaO/0LGufiFR7d973jvI1WCravQevQcAJOjBWbV1I+mb3DVY+DeEqfKPJBTaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=cmss.chinamobile.com
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT4o8nt4llyColJJhwIRSZnGIF/d+XeGV38+L12l4L4=;
 b=uOiYFirBBBNpBtuieaoZ2m6ndnnYFT7KtRmRGXcR+wjN8/RVAupsEUIPeirc+QItnyKsFz8UugceMBuu24Rx+d15SLRPa1Z4xkt/EFqQZyET2FSeEJ6i2eoWEn+9ZOWkHNniajfSX48VJ/o6kcPGLrFHW5Qmnbvva/2J1L4HIb+oV77P0odMAj0ngxIzmU/hQxozFNg7flV8IL5t0NMSMxRiyabHhYuMs7dgPdsJh1Vz9z1+rjnO0/kLn4708j/WEKI3Yk1cd6QeDwyewic8R8SCyEg4xD+C3RwC4oiBp3jEqW/QKRepfftQzncViL/V87DjmIQ96wCeF2J/3Z7FiQ==
Received: from PH8PR07CA0018.namprd07.prod.outlook.com (2603:10b6:510:2cd::15)
 by LV1PR12MB891283.namprd12.prod.outlook.com (2603:10b6:408:516::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Mon, 23 Nov
 2026 04:54:12 +0000
Received: from SJ1PEPF000037A7.namprd04.prod.outlook.com
 (2603:10b6:510:2cd:cafe::99) by PH8PR07CA0018.outlook.office365.com
 (2603:10b6:510:2cd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Mon,
 23 Nov 2026 04:54:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037A7.mail.protection.outlook.com (10.167.244.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 23 Nov 2026 04:54:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 20:54:00 -0800
Received: from [10.221.192.64] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 20:53:56 -0800
Message-ID: <bad9d7cf-1f34-4027-82aa-42f8e4d50d82@nvidia.com>
Date: Mon, 23 Nov 2026 06:53:54 +0200
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
Subject: Re: [PATCH net v2] net/mlx5: fix a stack over-read in the QP debugfs
To: Aibing Chen <chenaibing@cmss.chinamobile.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
Content-Language: en-US
From: Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20261122145152.1473-1-chenaibing@cmss.chinamobile.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A7:EE_|LV1PR12MB891283:EE_
X-MS-Office365-Filtering-Correlation-Id: aea3a74d-01aa-4c4f-d2fe-08df491dd0d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|22082099003|18002099003|3023799007|11063799006|56012099006|261026121527099003|261026140227099003|261102123227099003|261028144727099003|261022105027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZrGyGybsqFGt/Qrv2tW4homE4cA0Y3X8UfG+/yb6eR9QDcj6KLKnJ3ttD7TfaJVEhDWqF9rc/l2uO8XtiuC71IThjcu7bxQIp/NtZXhiSomeaJ7UGKBtE0swMVW9QW3FmcjQmWs2CtUW2Ctg0o8x55az4drJ62ySuyeX177sSSjYr45FoRixhdbQGi9iBXNQs7OOHTZ4yDw4wa2ALbqH92JpBltmLguZ73WpB630WG+yItqnI6N4+egRHP0TIWw2I0E2t5ceheFxi2zGT7LuyzH/3xOuclMOSO034VGc7E/nd9okNQZKCNpKjOVg6aXxmoOAUK6TYWrSYDZzInjOfCJ9BnWdMURpYEUH1I2kFzsTG3C6hOWWzNT+ooAQ9zKkbakyoAlJpRBvpXguTgcL3gIBNE4gJ/8X+DmRopmSa07Q/C8SQYKCXtxHeAS4PWRvIuijiOX+5bHi4moPLLk/jlqNYGhg+3tbT0QL5ChEquPG0f3DLb9/jUGI4NbBHzUr5kII1diZ3TLQ2GAUyGJlCf/Fm6R7NJIF8u4HDwDRNnpc+OJVMNtoXz58Ve5DHnOgE/wCv0XB6IHqB4Dj/eyj9hvjtrRDenl/+5+4RYgkf9IKmejHGymdmajayU+xG1AJ+D610Y3zCNU6nDIuzNj3/eisZqOSui4vceMZzq/szYbVceAN25EWmJS2cBTiOWva1IZ8YLGBc+eAua6zoJQF3g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(22082099003)(18002099003)(3023799007)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261102123227099003)(261028144727099003)(261022105027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OlLFFT9tCLfxhaxXmXJwj2Iw7ZPvMrg1pCzkY7ldfU4XOm7rDyTXxvQ80ChewvrnVXHFnjKRKP6eXKPSeAhZdGByeb4o9qJdCQ6eZMf2nMBAD3acvM3C41rDyV2TTeIGxWHx2rSkRu8SJpR9ZfhBq519g96IVAAqZRROyvemP03rO1oxt/U6T3g9OjuJxXGQAnqaE3p7e03s3mGBamFm5cNffaaFtrt+GfRUbJXTJYSX0D42VKWPH/RSWQBBG63aDQHjjSgT0PYYxLtLqP73iuNxoWsQHfmNzN5ZUoVRBLq7dzHFNetQ6blpJoQoGuWoJQVwMEwz2UPLHixOPqt/sBq6VvUsxr4UZ/wVDFmXcfi6fPJRpBSCvfBWzapmPCmwNUEGMRALZzifnjxgZjj7QL/d56NUFJWN8VFNPk9/u1OaMkgQESv8ZTs/YM2Ohm5H
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 04:54:11.5916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aea3a74d-01aa-4c4f-d2fe-08df491dd0d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB891283



On 11/22/2026 4:51 PM, Aibing Chen wrote:
> dbg_read() formats the field into char tbuf[18] and passes the return
> value of snprintf() to simple_read_from_buffer() as the number of
> available bytes.  snprintf() returns the length the output would have
> had, not the number of bytes written, so when the string does not fit
> that value is larger than the buffer: the longest QP transport string is
> "Invalid transport type" (22 characters), so with the trailing newline
> the function returns 23 while only 18 bytes were written.
> 
> simple_read_from_buffer() uses that length to bound the copy to
> userspace, so reading .../qp/<qpn>/transport copies up to 23 bytes out of
> the 18 byte stack array, leaking 5 bytes of stack.
> 
> Enlarge the buffer so the longest string fits and use scnprintf(), which
> returns the number of bytes actually written.
> 
> Fixes: db81a5c374b5 ("mlx5_core: Improve debugfs readability")
> Signed-off-by: Aibing Chen<chenaibing@cmss.chinamobile.com>

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>

Thanks.
