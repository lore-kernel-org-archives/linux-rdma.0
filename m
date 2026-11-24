Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795516797;
	b=PIbwGoz7r2Po1URAWqPO4e8eO2dowWj1fJjOAB8UTRKQdjrQLD3a421jnOidH7B39x8N
	 nT+BP5B49VYqPXhvLg1E1qux89ON1cMyaWfe5bY+khEKZI9ls0XxCfz+kIyV4+CHegYMt
	 lHmDIX5UmuLpDztK9uK58OLsDg6Wi2iJrrgDObs3pSEFMqUIzqcZOuTWsA49rObpixn5g
	 G19gGbuFpurz0JWlEoNrDk2wC5ThArpswvvAtloohwHL6/7p/rsvYGjtVcy9+ccJVQz6v
	 kuRhkxOkZhE8zcPNPwkH7LwBjcATTDH9sq4deoPIygLtCeFk2gUzsTzCl+d7Jr60CTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795516797;
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
	bh=IcRJmO4lLeYE+pDpFQLSgklWHjxKRw2WpDcPEzz6gTE=;
	b=emDgCjNUN+3+mXWMEOjV9F/Wlsda1zWm1XygktbDDZgggLeSDq7nChHSu7aYHv0ln/WR
	 vOJGVTKuadf87ZUynZ5+Ro5DXrTLba90G8iQixQg/PEXWutCs9x3Wtzz5pocuA0s9Jdb2
	 rROddul9DJNDebvuzuizeIkTgUzpRNDcRnlkuw08c4tyBJQ6ypK4n4mo85TLoLcrdee23
	 5V4xtbAFjo6ekoPZKkTxyxmkdaxZKa/Y96pTWGEa06ts7zo6423PlMY9ha4VA7LNgqDy4
	 tuj1ez2+G0czUD8CWqMR5HSllOne8/jFCHJQKuvbhYg8r/Ph+FZhvNZjbi4jfSQgMXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="fm1q/1kU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.24
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C928606A32A;
	Tue, 24 Nov 2026 10:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C928606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fm1q/1kU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MWlSPydmnmm7FxWN7boS8VdN5SX2ryteLLs4E4/eC8oMEszlPM4NjM0llkuyRrNi/xFRpZ27Bs3R8PaNpKc99gU6sNrgGZ79XDf6t4DEjUBkQYz4oLuYbuzP8oHWtY3CbpOsrrnSE3qitCcOoP9RLHuE9KoQ4KuwUkkH96M+ITHLiLIK+RE6w30goTGokngJk0ZmpRfwte1SYBDaRIs7vRpepQlOLcQQGzjqP2CpoeVGCs2wEAgJZYNnVGHJP0sDPksvte1+ArsPLWzC+rkOHT93ARX7c2FDYROvjQWINKxteXV3uWpR1lqGN3mfTHgjIJEYTJGd1cokyfPPU53Ojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcRJmO4lLeYE+pDpFQLSgklWHjxKRw2WpDcPEzz6gTE=;
 b=EstoSj0PMms2zccoyrt0YAfTvwmOFYrTNYdtrAg/Bb5e+KJ5hmo2QnCZyMipNCzr+s/+XJkKGj27r5aW5AnXGhTXV/sOOdRn4a5ioWsLrmpjtCW8VogwpEOuINyzAOk/Q1CuLSB8G2gWm0TQ9NFPNlNHp9PRbD0vRI6suuPWkCnKEo+dpHe/BNfQqZCG4J4M7JWqK3d0uAKUd5Pg7JVMXMMhTIoNuKZt9LabB01rVbnsjgyDSIAHrk0Xhqix88+WJOlqZK59mUrPRn7ILddU7zZFfGczv7lyFdvmwxzwhEwM2CG7nSye3qr0DocFt3SGOUs8ZM/HivtezAMPEfRoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcRJmO4lLeYE+pDpFQLSgklWHjxKRw2WpDcPEzz6gTE=;
 b=fm1q/1kUNwjAqznUgfKiKf0f26vcEy/xLGGdPxVyPZVvSuUDFaXYaHfHUUOdCVXtpFwYbsO9Wfn8ieR3mFZvqG/EoWTENrOWuRyT70OhU6FEQdy7Zkcvwb9E9eNZPbg6rdCgyJmv3kCqvJlmyCi6ZVQRkagraf7V+bPeu0bMQZk0aq63lUHk/kr1XA9qCDpE8LrmasgXEe/zVVZ4uRWK5dSG8IPQ76zwm02Mwe0hAB9hbjmlz4WZb/YW9bgIsQ+Ml55Y1NiOgGk2BWuRmXcX6EVagE02XQF5PFrHtnjxHNZG7rLMUJ08aD87ITyZYnjm9mnZ6dhSmoEaX8IRwNsp+A==
Received: from CH0P221CA0035.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::22)
 by SA1PR12MB8144.namprd12.prod.outlook.com (2603:10b6:806:337::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 10:39:51 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:610:11d:cafe::c) by CH0P221CA0035.outlook.office365.com
 (2603:10b6:610:11d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Tue, 24
 Nov 2026 10:39:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 10:39:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 02:39:34 -0800
Received: from [10.125.204.85] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 02:39:27 -0800
Message-ID: <82624f99-cfdd-43e5-bcef-522df8e1f16d@nvidia.com>
Date: Tue, 24 Nov 2026 12:39:23 +0200
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
Subject: Re: [PATCH net-next V2 1/5] net/mlx5: E-switch, add match-metadata
 allocator for nested VF/SF eswitches
To: <netdev-bot+sashiko@kernel.org>, <tariqt@nvidia.com>
CC: <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<agoldberger@nvidia.com>, <gal@nvidia.com>, <jgg@ziepe.ca>,
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, <mbloch@nvidia.com>,
	<moshe@nvidia.com>, <ohartoov@nvidia.com>, <saeedm@nvidia.com>
References: <20261120075959.2533702-2-tariqt@nvidia.com>
 <179550916784.3135.15503627084704234984@kernel.org>
Content-Language: en-US
From: Shay Drori <shayd@nvidia.com>
In-Reply-To: <179550916784.3135.15503627084704234984@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|SA1PR12MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d45e0f7-52c5-4573-f2b7-08df4a1744ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|6133799003|22082099003|18002099003|261009223027099003|13003099007|261021121427099003|261022075727099003|261026140227099003|261022105027099003|261026121527099003|261022113327099003|261028144727099003|56012099006|10067099003|4143699003|11063799006|5023799004|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	fLOxFs1IhbSZO7k9gTMf/H0P4GRWSmMPyqIq84g+SOhkkAP6dAK/U0zHxJniICf2Dc5Thrope6O9wg/6KfXUTaOMFRKinu0xEuMdIwLQsrCoMU1RbObyzIa9zDiB1N/542YzBK32zo4vfLf5fkddwWbcIkktrmub7f3wCVpjvxL0yU0wqGaW/OXPTDDoX8GGM32y5i1rord91ZL3BCuWxbKw20o/pFFhVRJKf1CpE3VwlNIEeapG6fCADbwqrY4jHrDlDblgBVq4i81pCDvXASX7Ju/BSPiCheCaLudqvYQOttP/aCtaAp2CwBToxKPyWJTBaXZ0uuewasNi8XdoJwNF9eL98pxJ+66yRpkG52+KVfmqkl8L7AijiSGXDtMMurUrZNXRXoL1yD8r0uOTRDEEXXv4MEkTsLuqUn7Nm1oYTzz7vM7chzjP55GxK21I5+dAuEwg46kuILMwEfvTMP8BHcf+vUFfHFL4dla0LGzD53DEd+B8dYsuvrTj6EDv6esVMm/xA3UwTI8ePCr9OV/x3uMRtuuHJPkv6nHp5mVBuHECdZ6JMTnXI2N9PQWzZYZtukQ1A4gUQsaTrqa3TJ7X48d1R3LxQPuR4yRIejRM1QLGlG7741WKUDonpyb5HJQHaAqT/IDs08PhatjMAOI/v8rceiArVtGbF51WyKH0PWTqfp2QTZBNyM+v6c92IcrnrT9mAjnDnUAOUG5ssw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(13003099007)(261021121427099003)(261022075727099003)(261026140227099003)(261022105027099003)(261026121527099003)(261022113327099003)(261028144727099003)(56012099006)(10067099003)(4143699003)(11063799006)(5023799004)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nbVLcrMhgrKczvANV+J85CHQa/1ri/oTEnKa1SC9TeilWVBruxeGOJMPNQpEDWWSsjVNeto9FL7c3BMAXd+h12qMwGCF+TFwUe6iRO7ukujmiH2DrNt2waE7uhhoVTTM2vn5Z7ph8eyAN6/kckU8/9oj6OmZrE3rY3AeDZxrpwWjs+lAbVPpHNFdvjuECL1fdSEPx0PXvd/9yCT4NsR0BWE3iUVm2QvU+9rM9k4TowGpQmfVciFrP2c8s+I5XnbZI6ZautlIMzFcSzPzX7goD1X6kJE3vQWssLIP2vJq2vzay7BYlaY7Pq7Bo68MwyTwW6s+W2LF/eVCBHojxaG3xsK9MwE6idxzhp84AySnSzxboJwrAA9lvyDntJdfGJM733KkGpj617m0WztjSPZw5hHtv+XkgAQUZlyi9+XNhNCo1TeaduvIHFFZYueHLlHP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 10:39:50.9206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d45e0f7-52c5-4573-f2b7-08df4a1744ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8144



On 24/11/2026 10:32, netdev-bot+sashiko@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The layout selector added in
>    mlx5_esw_match_metadata_alloc()/mlx5_esw_match_metadata_free() is…
> - [Medium] The nested layout makes LAG admission and the encodable range
>    disagree.
> - [Low] The nested layout cuts the per-eswitch vport id space from 4094
>    ids (2-4095) to 254 ids (2-255) (`vport_end_ida = (1 <<…
> 
> --
> 
> net/mlx5: E-switch, add match-metadata allocator for nested VF/SF eswitches
> 
> This patch adds a source-port match metadata allocator for nested (virt
> LAG) VF/SF eswitches. Its layout is 8 bits for the function's slot in the
> LAG xarray plus 8 bits for a per-eswitch vport id. The nested layout is
> used for any non-PF eswitch, except one that is virt LAG capable but not
> a LAG member.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> index 1323114ce7f93..3c1355f910906 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> 
> [ ... ]
> 
>> +static u32 mlx5_nested_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>> +{
>> +     u32 vport_end_ida = (1 << ESW_NESTED_VPORT_BITS) - 1;
>> +     u32 max_idx = (1 << ESW_NESTED_IDX_BITS) -
>> +                   (1 << (ESW_NESTED_IDX_BITS - ESW_PFNUM_BITS)) - 1;
>> +     int idx;
>> +     int id;
>> +
>> +     idx = mlx5_lag_get_member_idx(esw->dev);
>> +     if (idx < 0 || idx > max_idx)
>> +             return 0;
> 
> [Severity: Medium]
> Can a LAG member be given a slot that this check then rejects?
> 
> mlx5_ldev_add_mdev() hands out slots 0-254:
> 
>      err = xa_alloc(&ldev->fns, &idx, fn, XA_LIMIT(0, U8_MAX - 1),
>                     GFP_KERNEL);
> 
> but max_idx here comes out to 239. A virt LAG VF/SF that lands in slot
> 240-254 is still a full member. mlx5_virt_lag_nonmember() returns false
> for it, it passes the devcom pairing gate in
> mlx5_esw_offloads_devcom_init(), and it gets the nested layout.
> 
> For such a member, every metadata allocation on its eswitch returns 0
> here. esw_offloads_vport_metadata_setup() turns that 0 into -ENOSPC, so
> switchdev can never be enabled on that function, and nothing is logged.
> 
> The comment above says only slots 0-239 are usable. Should virt LAG
> admission stop at the encodable limit, or refuse such a joiner the same
> way a late joiner is refused? Then LAG membership and match capability
> would agree.

This is theoretical only; there is no such use case.

> 
>> +
>> +     /* Use only non-zero id's (2-255). */
>> +     id = ida_alloc_range(&esw->offloads.vport_metadata_ida,
>> +                          MLX5_ESW_METADATA_RSVD_UPLINK + 1,
>> +                          vport_end_ida, GFP_KERNEL);
>> +     if (id < 0)
>> +             return 0;
> 
> [Severity: Low]
> This shrinks the per-eswitch id space from 2-4095 to 2-255. Does anything
> make sure a nested eswitch has fewer vports than that needing metadata?
> 
> esw_offloads_metadata_init() allocates metadata up front for every vport,
> and unwinds on the first failure:
> 
>      mlx5_esw_for_each_vport(esw, i, vport) {
>          err = esw_offloads_vport_metadata_setup(esw, vport);
>          if (err)
>              goto metadata_err;
> 
> mlx5_esw_vports_init() creates SF vports from mlx5_sf_max_functions(dev),
> and that is not limited to PFs:
> 
>      for (i = 0; i < mlx5_sf_max_functions(dev); i++) {
>          err = mlx5_esw_vport_alloc(esw, idx, base_sf_num + i);
> 
> mlx5e_rep_bond_enslave() and the MPESW metadata take ids from the same
> ida.
> 
> Suppose a nested VF/SF eswitch manager reports around 254 or more SFs.
> The ida runs out, this function quietly returns 0, and switchdev enable
> fails with -ENOSPC.
> 
> Commit a5bfbdfebd53 describes a non-PF eswitch as just the manager plus
> uplink, so this may not be reachable today. Would it still be worth
> clamping the vport count, or warning when it doesn't fit the 8-bit field?
> 
>> +     id = (idx << ESW_NESTED_VPORT_BITS) | id;
>> +     return id;
>> +}
> 
> [ ... ]
> 
>>   u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>>   {
>>        u32 vport_end_ida = (1 << ESW_VPORT_BITS) - 1;
>> @@ -3658,6 +3700,9 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
>>        int pf_num;
>>        int id;
>>
>> +     if (!mlx5_core_is_pf(esw->dev) && !mlx5_virt_lag_nonmember(esw->dev))
>> +             return mlx5_nested_esw_match_metadata_alloc(esw);
>> +
> 
> [Severity: Medium]
> Doesn't this condition also choose the nested layout for non-PF eswitches
> that have no virt LAG capability at all?
> 
> mlx5_virt_lag_nonmember() is:
> 
>      return mlx5_virt_lag_is_supported(dev) && !mlx5_lag_dev(dev);
> 
> Take a VF/SF eswitch manager without the virt LAG caps (no
> multi_uplink_eswitch/lag_master, or num_lag_ports >= 2). For it,
> mlx5_virt_lag_nonmember() returns false, so the condition above is true.
> 
> Such a device never gets an ldev, because mlx5_lag_add_mdev() returns
> early:
> 
>      if (!mlx5_lag_is_supported(dev))
>          return;
> 
> Later in the series this check becomes !mlx5_lag_is_supported(dev) &&
> !mlx5_virt_lag_is_supported(dev), which still excludes the device.
> 
> So the call chain would be:
> 
> esw_offloads_metadata_init()
>    esw_offloads_vport_metadata_setup()
>      mlx5_esw_match_metadata_alloc()
>        mlx5_nested_esw_match_metadata_alloc()
>          mlx5_lag_get_member_idx() returns -ENOENT
>        returns 0
>      returns -ENOSPC
> 
> Match metadata is on by default where it is supported. Would switchdev
> enable now fail on these devices?
> 
> Before this patch they used the PFNUM layout, where mlx5_sd_pf_num_get()
> falls back to mlx5_get_dev_index(), and that worked. Non-PF eswitch
> managers have been supported regardless of virt LAG caps since commit
> a5bfbdfebd53 ("net/mlx5: E-switch, disable host functions for a non PF
> e-switch manager").
> 
> The new comment in eswitch.h says this split is for a nested (virt LAG)
> VF/SF eswitch. Would a condition that requires LAG membership, such as
> !mlx5_core_is_pf(dev) && mlx5_lag_dev(dev), better match that intent?
> mlx5_esw_match_metadata_free() uses the same condition.
> 
> Separately, at this commit even virt LAG capable VFs/SFs cannot get an
> ldev. The later patch "net/mlx5: LAG, enable LAG over functions that do
> not represent a physical port" fixes that part. The non virt LAG case is
> still there at the end of the series.

A non-PF eswitch manager without virt LAG support doesn't exist at the
moment. FW doesn't expose such a VF/SF.

> 
> --
> Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261120075959.2533702-1-tariqt%40nvidia.com

