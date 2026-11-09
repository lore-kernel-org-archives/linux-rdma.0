Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794220049;
	b=yunYgYR2K/i1qxlUst+rWEmLQpVSogg9Za44JEgw7suwPzpgvB1rZLem9RQatYf8AKhw
	 A2y4eUMhPaQek9dymApfwGANJpMrcBqNbWnn9lSrWWNlOuWxFolCA60lSKVX70dpMsckj
	 t6sTzwUdO6yywGosqw7eDecPk+UUOeJiMePSfSOQspahSsmf0KeXPZnPx5+INuK5BCuI8
	 fvaW3//VJDm6rETo1Nk9h2sVjoATLinDLBnJiT7l9U8qYN+31Y1c5p1OabV1HEYefkt7H
	 +1lLfJPZCfkGzR47uSFqOtxKn0BUuYVf+sN48vW16My3ZxXbAaAI5zCPZGEW4azg+Zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220049;
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
	bh=XuzOXFEqIopuSbh9NC4DY0BTxhBXCWj404YNLepCOjQ=;
	b=YxEAqV1VnYKYm/Tcrba+shjWFVT0TMtn0yugozePT7KB3Y56x0gRxK19GYzukG2ELItd
	 gTiOL1uLiQpQwGd5bKKdwvDN4p95dS1eON22uMh4/f/E+/8IlFxzBn26NfJjrEnjcctdV
	 oPliuGRWbWcazgHYUsodxNEDiGCLMgUfv8+ipKPBtiO+TYmVVbdgRy/VpfRmVY3olAo1j
	 0HWGQ6UNZTHVw1wYl6axgPstH7apSGSTIxk3Of5wPFWgtAFeI3cG3rBn0WOLKUaBnm4wL
	 8yYy9lsFx+no5pR6c1HVxPZoCta1lNKK+HNMyoaOa0e9D4RUp1CybzWJg6mnpq/9F4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cFk1S1Jr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.64
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57540606D807;
	Mon,  9 Nov 2026 10:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57540606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cFk1S1Jr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zE355SNncu8vmRfeA/gLsUcF6qSl7R808v8x4z/j5GDSFpuK0L6f7ULF0riBuqTDDjNZ18Af3AWIUBeSDu64q7AUhwuGW4D6Yv9LN/I3kNozrL1pVBUqTJLcjqzbFcx7SdXGJOHEm4nBgXaZ0q6Jp47UXWnrkisiXZ9znAJ2/VwA2vgAGz3hkAijVX8CKbJOhhqzhjzboKX76jeZB3s4UY9IRNlfir3amyt0y1tAAWHteyz+tmMNZzTBFG0LMZgSi9nyy0MVQ2hSFBl+UuwRmlC5oRmBm2wdTZ2ljHH/y+5Ul7iEogSWmTqEoAY75KD4abPZfQ4vF4OBDAYdkcIz9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuzOXFEqIopuSbh9NC4DY0BTxhBXCWj404YNLepCOjQ=;
 b=tFPcBJqFiTJDn1peotFNYc++LZWoXza9oYTcZ/64xsECOL24SbIPVdV79M1cV+PD3PKjRDY3zYRWu5URO3y8ETCu9sZv6qf33ERZVDkV1ALtAfVbfrY0u8IAZ/UfQBPwomwX8taUCgKXemtrSOChOA/ZCd5/QCgyaKwOuKqO1UmiWkuI5SIvmAZLZSFnILgrl7hOaKufGtAmNApOn8zCy7dIGtqSsmGtXEcnS2vDu0JdZw0FJkioeO/UpVyEhw2kiIsg9LzT+2864+MoOnypDzBYkyYYQ5WoyEP9iSR68oBAinor+vShIhxlJoqzZqFvqTM2p0l0m4Iy1ZKW9Bw/XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuzOXFEqIopuSbh9NC4DY0BTxhBXCWj404YNLepCOjQ=;
 b=cFk1S1JrvASBD+SKhTWu6G7DdUG5LbSi3uH4ZjV0MsJQtJve/pHvGgTyDFXm/qVbz9eqkQGhrBfHvam4EH7+EkJ6saJUdxQE37hiwoFKVtxyNXcUMqk3gKofJ105z6roQcVTbvWx6eVS0Koy+rFjW9526xubJbOhYkfo9rXkmNGlmFlk6x+iepkwekYpUAiS11ZptJpflrCZ8mPsOe1dB4gw0eQbu3Jw5r7XrS80nOilRSR2N6KpmxnAU5XKuvhwvHFZvw1uNTIpPp0KQY7YsgYI+BPHWceNYIFfNQJHf1kmZ3nJmIfvVv6GTWCurfo7CJT8AqkJ7axVVvADIF32rA==
Received: from SJ0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:a03:331::29)
 by LV8PR12MB9619.namprd12.prod.outlook.com (2603:10b6:408:2a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 9 Nov
 2026 10:27:25 +0000
Received: from SJ1PEPF000037A7.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::7a) by SJ0PR03CA0084.outlook.office365.com
 (2603:10b6:a03:331::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Mon, 9
 Nov 2026 10:27:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000037A7.mail.protection.outlook.com (10.167.244.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:27:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:27:10 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:27:05 -0800
Message-ID: <05c7526e-90a9-4240-bce3-98ae5e06bc79@nvidia.com>
Date: Mon, 9 Nov 2026 12:27:02 +0200
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
Subject: Re: [PATCH rdma-next 19/23] RDMA/mlx5: Clamp log_max_cq_sz shift in
 CQ size checks
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-20-yishaih@nvidia.com>
 <179408310459.994134.3829922527726679973@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310459.994134.3829922527726679973@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A7:EE_|LV8PR12MB9619:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4fae41-6029-460d-45a5-08df3e4c0c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|7416014|23010399003|1800799024|10067099003|18002099003|22082099003|261022075727099003|11063799006|4143699003|261022105027099003|56012099006|261026140227099003|261009223027099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	UtLHTL3W/oy05LzCC9BRgSunuNb2AJJHEebmIS70fXFLRmvCddyFaRwzKj8m1jMqGTIls2iLyqxcZ9oxkEtpVOSudnL4/1jRlt0wfwh/WcNBry9WM5M1/qaICa2NO+9x/67S4gQHI5IWaYvx/JdDxIIzO7R4ilAk155/dBNzMc9DeFH9LYR+kgIVPupfKENti4L3quaGCl7kEqhadAsUb15x+ViMXjrvdT6tk4xjyvgNNepJC9T8QaTTA7HS80370hRLFhuwkV5C9ZIeNJju+OrtF2fy6f1+nxsyqf1cWdgURtEdlLqNezvw4mEfT6VsvQA9nDp5gkRQ33rgYrVmpPi+BPjKWtErP9yQ3DpH4uNCPn7PKRytcZsL4rkDGdPX5zcp1q02uMVhUfGqHSSgghOAQVpVKpXiB/+91PnVd1ktFGkbRRUTrpADbWmTjtMkTU+uOb9eJZJ37YARh3A+ffwu9wZ5Q588pI0Qp7PZsuYJX38CrYIhhKr+1mitOLud5vgUDqbX6mOaa82lVwtLIqbt8UA5UeuMHQ4bk7Ofgusq2h311+fQq8MEsgz9Rb4HjVEnmcOxIORacnCgF+GeM+012odHX/8NOND2KAd7T9fszK1k17NxVBxzHd/q+PCqOfmtUzta6qTnZ6Nx/0WJROgyhz+RTxt0qKdTqqP4zFdydrE1iBJzOMugi6PSBNu90rrkIYH3+UuqpL52j97XTA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(7416014)(23010399003)(1800799024)(10067099003)(18002099003)(22082099003)(261022075727099003)(11063799006)(4143699003)(261022105027099003)(56012099006)(261026140227099003)(261009223027099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+VDY5vmCH96bhbQuEoluJ+yRoYTw0XBoEbjMxs1bCjdWN/rncVRd0jxrDpin4XB5g8UxyXS/Zub/wBiLBFae80Ue9Uc7QgE9xqclTsz7SID50ufICj1wvo2S2S36YIHfzuT4yod1tqB5iOEzm6ut1D4oEDUjQgKZz23/TmKxEKhYjRNVCIv8jJ86oq8v9V/9JSzouZcvcqVsguArQm/Maad/FhS92Uvs6x64KxYKkBjTF1CkORrH6qKGbKxr3LG7vzj54MTKHwV6IAdt+jwxQfWQabEFodczShKxx0xx58N+LXqhubdmqJsZsTTTzD6qmdHnys6QW4XOEYAnZCUNoKDatxDQPCnCm0wigbUhN5B03evrG7j2WRbnaWYYvobEv23VPgxaIQajlmdmg3pG5I5Xgh28wC9e4aQFdotW19EKEn5HXTW5wPkPbg0YZk8L
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:27:24.9382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4fae41-6029-460d-45a5-08df3e4c0c00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9619

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The new `entries > INT_MAX` check only keeps the CQ entry count
>    inside an int.
> 
> --
> 
> RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
> 
> This commit computes the CQ size limit with MLX5_CAP_GEN_LOGSZ_U64(), so
> an untrusted log_max_cq_sz no longer causes an undefined shift. The
> requested entry count is now rounded up in 64 bits. Sizes above INT_MAX
> are rejected in the create and resize paths.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index f955eb762051d..25344dfba1c12 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
> 
> [ ... ]
> 
>> @@ -1226,12 +1237,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>   	int cqe_size;
>>   	int eqn;
>>   	int err;
>> +	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
>>
>> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	if (attr->cqe > max_cq_entries)
>>   		return -EINVAL;
>>
>> -	entries = roundup_pow_of_two(entries + 1);
>> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	entries = cq_roundup_entries(entries);
>> +	/* cq->ibcq.cqe and create_cq_kernel() take an int */
>> +	if (entries > max_cq_entries || entries > INT_MAX)
>>   		return -EINVAL;
> 
> [Severity: High]
> Is INT_MAX the right bound here? It keeps the entry count inside an int,
> but the CQ buffer's byte size is still computed from it in 32-bit
> arithmetic.
> 
> With a device-reported log_max_cq_sz of 26 or more, entries can now be up
> to 2^30. They are then passed to create_cq_kernel() and on to
> alloc_cq_frag_buf():
> 
> drivers/infiniband/hw/mlx5/cq.c:alloc_cq_frag_buf() {
>      ...
> 	err = mlx5_frag_buf_alloc_node(dev->mdev,
> 				       nent * cqe_size,
> 				       frag_buf,
> 				       dev->mdev->priv.numa_node);
>      ...
> }
> 
> Both values are powers of two. So nent * cqe_size wraps to exactly 0 for
> nent >= 2^26 with 64-byte CQEs. With 128-byte CQEs
> (cache_line_size() == 128) it wraps at nent >= 2^25.
> 
> With size 0, mlx5_frag_buf_alloc_node() sets npages to 0, and
> kcalloc_node(0, ...) returns ZERO_SIZE_PTR. The function then returns
> success, and buf->nent is still set to the full count.
> 
> init_cq_frag_buf() then does:
> 
> 	for (i = 0; i < buf->nent; i++) {
> 		cqe = mlx5_frag_buf_get_wqe(&buf->fbc, i);
> 		...
> 	}
> 
> Won't mlx5_frag_buf_get_wqe() dereference fbc->frags[0].buf through
> ZERO_SIZE_PTR on the first iteration and oops?
> 
> mlx5_ib_resize_cq() with udata == NULL has the same INT_MAX-only check.
> It reaches the same code through resize_kernel()->alloc_cq_frag_buf()->
> init_cq_frag_buf().
> 
> The user path in mlx5_ib_create_user_cq() has a similar problem.
> create_cq_user() passes this as the minimum umem size:
> 
> 	cq->buf.umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, attrs,
> 						ucmd.buf_addr,
> 						entries * ucmd.cqe_size,
> 						IB_ACCESS_LOCAL_WRITE);
> 
> That is a 32-bit unsigned multiply, and it wraps to 0 the same way. On the
> UMEM-attribute path, the only length check in ib_umem_get_desc_check() is
> umem->length < min_size, so any umem passes. The device is still
> programmed with log_cq_size = ilog2(entries). resize_user() already uses
> (size_t)ucmd.cqe_size * entries for this.
> 
> The commit message says a large limit made the CQ size get "truncated
> when passed on as an int". Since create_cq_kernel() still multiplies that
> int by cqe_size, can this truncation still happen?
> 
> Should the bound account for the CQE size, for example by rejecting
> entries > INT_MAX / 128? Another option would be to compute the byte size
> in size_t with check_mul_overflow().
> 
>>
>>   	cq->ibcq.cqe = entries - 1;
> 
> [ ... ]
> 

Right, V1 will compute the buffer size with check_mul_overflow(), using 
the real CQE size, in the kernel and the user paths.

Yishai
