Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794147863;
	b=mBi1gJlOd2JznViz099bWKvgdsoex0RjyRCBK63cSupSnqnq05NytaO0OWpKx7AwkNry
	 XhPX0QcCySbMuIep9TRqqcHowi9Lh/cg18kIpxywywGBp4nRmQ0O3woDfecc8KXU17ZdX
	 Yi3z+Plz89k9Tefid/peruqfKfO1IpkflrS1kqIif4fk2cBIn8nJKVYsCdAlSwDoHKM+8
	 /NfoUb4FjNaqDvj03CDA74mWsttibigNNdnf7HaAWeO+U2aASImrR9Id1Os+1vb0GO2Ub
	 dooNM5bD9jAcuNFrU+GNeYfQr/WwQ0halnIU5sqbMRBXsNa3s2+V0Zb+laB9fIEWaiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794147863;
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
	bh=WDGHk/oPgEvSTYKAVyBLQrolOJj0va/TO9wm28qQ/g8=;
	b=H6GWhKU3UEqt2eemN988Qmpp7ss46dKhfbrvIeZyu7bXX4cTeBKI0a0Ai/688C8yB61T
	 5+nVVv7avJeCbjMaa77O/xQ6rngAl85hQx0wWlEJFTXpLOKKJ/ZZs13rnux2JrtgtPpu/
	 L6tvDSLiayAc0GIHFQdGAgRdgzircs5s4a731aM40vAfNWgno4oq3Kq3v2R0Z3p2lWm2U
	 OgKdzvd7+eN1XraC87/iFS3g+QrEpJbSh+/4rHWunbPL9TY1ZWHO/a/F127x9OuZ1YrhP
	 Do818Ssr4ll4SufFa3ZOYkBA8AsxKSL7kdBB5Ln/M8/aMQQQc1/6VDBxREQi7WRUL7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O3hcVn5k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D7606A331
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 14:24:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF5D7606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O3hcVn5k
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qn4Eh8NuzMGME9zYk2J3rXk6gv6cLf3UHrEPwKeorgX2SDsAkXl0+/R2MFnugiDWLLvd4a1+ytU4hPYzakygIuBhC3xMWTp751jjPKuFgHLCbJX+NV3ZLcBLOtCLAK0tZ/3mKDB4kw/7ZXLy0H4nmgCgqnFsk3SjnBMP9DsBZTojXLFxj4d92T9IT3KirP61REsIjQZgrDVa1PNhVLuA660x5hG/UCEpItpLlaPCRsNMr95kn+iPSH1sGv3mGdeG05LoMplZPMmd2fZ9AJJfEwfvL1dv1n+3PDSKNUIyme9atE0C2ip4+dRqF1rrX5CYJ4xoMeru0QhGnEKLLBeABA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDGHk/oPgEvSTYKAVyBLQrolOJj0va/TO9wm28qQ/g8=;
 b=SGKp8PU2AUrotlGn301hRtAI5nl0NKPYgjqqIme5BXBTix9VbkWHD5/V/Iq8jF3n8tuabxphKVuN1SN/89nWf2PT+6/fk6ZlKqvMvohFMBe1Kvr2/5BUGHWsYLRAPdDj7sCQURH5XHEqeQd+DZydm+JOaaV2+tWvxNc2FFfTjV9jiknp7oEpV/j0aM44O8bCggr41arJ+hWfr4XFv7+OfQqpDiP8fPSIiGkbm1m8ddpx8/ougZiT5yATmvHtdNrcOBXk9/7nDZVXfP7sw+22fWCVmVDXTM8tzzUqA/GlDUZqbjmRT4GVmvkacCLvt6z8x46FVJwUjOpsmxKpF/av9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDGHk/oPgEvSTYKAVyBLQrolOJj0va/TO9wm28qQ/g8=;
 b=O3hcVn5kgoPkmlKSmDtsbb6yliUIO14ibhQVA47TZrYo7X//Fj1eaBEvLc3dKRKKrnMBS1ckP1JLVWpNQnZUincH7kqDjbpbI7jVRyyEGXM1K90U/KrNRrjx2zbcNjbgKRZcIiJ5lJTBbsRAZ+3rwsdaqBfzQ+QuVkcGFsLW55EpCLka+xOXzf+1avWGfeOZpKObPOzUkv7bYEBeXJXcSsN5rGUNiMygJQ3kHnuV4XTq7SPtnYgYGxXIL9ixy1qFaA6RHHMCG55Oh98WUNJzkAjB7ud1Mu9tNYYHL3eCFsR74sso7B7/eGKREM/JveCvt5UFyf9XxbD8EBP6IjBT0Q==
Received: from SJ0PR03CA0333.namprd03.prod.outlook.com (2603:10b6:a03:39c::8)
 by DS0PR12MB379256.namprd12.prod.outlook.com (2603:10b6:8:3df::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 14:24:17 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::6d) by SJ0PR03CA0333.outlook.office365.com
 (2603:10b6:a03:39c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 14:24:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 14:24:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 06:24:06 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 06:24:04 -0800
Message-ID: <f943ff0f-f40d-488b-ade4-3021ad689980@nvidia.com>
Date: Sun, 8 Nov 2026 16:23:57 +0200
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
Subject: Re: [PATCH rdma-next 21/23] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-22-yishaih@nvidia.com>
 <sashiko-outbox-197674@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197674@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|DS0PR12MB379256:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e1f78fb-3a24-417e-0dd6-08df3da3f8b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|22082099003|18002099003|6133799003|10067099003|4143699003|11063799006|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	gD4su5XDNkKCXS86gGR3oLeJTBcmGmFBzb7CK39hvRoW/qvxCCaYifrnsFLf8thaeOWa7KiXZPkw8wLgM8Woal7WyMLPZaLgat9SyIsyJIf5EZP99OCuv36h9rkYPXyaooV9+ANU3xoIW34vOfRfNUT9RL0y+dd9AXSy5T1fYl8Q+2DwvV0Bx8JJCjKSdLIZ5zneYE8Rqsta5atfdMgtAfLMKBD+JtGP8Jv08PUxdKjALuVlEzA60+RiqCkt2JZU4Euzdq0Zhe/q2Z9+FK2ZziqVqRppDbZdjicVeHuAWQQSnBpaaaGttC5CfBlDQv3zZa1WFA+bXuIy1/Ajy6W/lpQlIJDgZG35pBSuot2MZRwbRqpNTbFxAuzyprvma7zqbBw6EZq7ULR1t0hYip+2j4k0/O9wCCHiGoU4PeDIxpF6FkOII0a17ZPvfsA53g9TvnSsuMqHE9XpF2XeYo5mNJCb9ga8SJpXyjIqgNp5OQWa64iGNwXsbYY7JeorahNWxWBaYOLNsfmhZKOpaNcY+066T2X7Cj147JLScoOR8vVSRMBqNDbci3oQQ4PBZII67YBEdXmgPPQgV4pLSBTS/KPHretGQkg58Ly3Dd1zHTGKf0h3S0sTXK3sE9OEg4l5QY6Ss5U5AFKMUMZTWvyFFDgDp4QxQ0KLrM8jXkAJv0lmgCAyxcfB2hynhKaoHnP90wS8EgArYxPbpQqJCSoa3Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Hgwn4uKhHz0B3T2pAwqiSycsCp7T9MJyAulsXLKUiha7bmlwLbGw+XkL+6LPx7ikIlMUW3udXDFEcbeUvXpPOTSP1vESku7Km+byndazL5ClFwRoYwxxEs0yDaDW6w69GHaLGcUHHgWn94gQiFdv/nzOD2U6p39reQ3q4nE3nECPHaVU4cHhChRySsoyK8Isd/8QMmkZuNDf0RkF6JC/zGPe+WCwRObNzcNmorHYD4iC7oUZwQ0eSxFtRZPNm1UrPSps6ssp6uYzearalBTP19OC8Hl5Oxn7hSZ/odqYtdhHFGG+x17mp/d2dF0yfVubQ8KhBbzaQYASEoGWf+T/9htQouhhkftIvZfEm7vujT8ghxmCRntlLy24a4QV7GUpnsMSwFkZlE+NbfpvdEf4QUXMyRRJfZqdzcDuin0/dP0G6hT0m9MfdLL0GrohVgPi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 14:24:17.0853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e1f78fb-3a24-417e-0dd6-08df3da3f8b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB379256

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/mlx5: integer overflow and size truncation in mlx5_ib_create_srq()
> --
> 
> commit 9361613960626bd9707489f3ac7caf042edc2d19
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths
> 
> This commit replaces open-coded shifts of 8-bit log_max_* and log_pg_sz
> firmware capabilities with MLX5_CAP_GEN_LOGSZ_U32() and
> MLX5_CAP_GEN_LOGSZ_U64() in device, port, ucontext, and SRQ paths, and
> saturates products that can now exceed 32 bits.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
>> index 6a4a937d97ce9..3fbb0eaf12558 100644
>> --- a/drivers/infiniband/hw/mlx5/srq.c
>> +++ b/drivers/infiniband/hw/mlx5/srq.c
>> @@ -198,7 +198,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>>   	size_t buf_size;
>>   	int err;
>>   	struct mlx5_srq_attr in = {};
>> -	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
>> +	__u32 max_srq_wqes = MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz);
>>   	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
>>   			    sizeof(struct mlx5_wqe_data_seg);
> 
> [Severity: High]
> With MLX5_CAP_GEN_LOGSZ_U32(), max_srq_wqes can now reach 2^31 (0x80000000U)
> when the firmware reports log_max_srq_sz >= 31, which allows
> init_attr->attr.max_wr values in [0x40000000, 0x7fffffff] to pass the
> init_attr->attr.max_wr >= max_srq_wqes check in mlx5_ib_create_srq().
> 
> Can this overflow srq->msrq.max and truncate buf_size later in
> mlx5_ib_create_srq()?
> 

Yes, thanks. v1 will reject a rounded up size above INT_MAX, and compute 
buf_size with check_mul_overflow(), rejecting it above INT_MAX.

Yishai
