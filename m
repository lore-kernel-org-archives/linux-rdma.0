Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850005;
	b=f2UTJ7cz9V6ACcE3/qzwjMR9ZJ4otrvjrAsbK0mH3caLcfnCKNu87nDfNOUmlFviwjkI
	 R3oApjK+WFZnUnw6cffgFf1rw4HaWKtGX6zhniw7jMPVR+5wbC5jwt0oJv3HOuyFKxANs
	 j3tfGyurJhBST5lcECPeC9bTsVJzh00qLQuyO6dq0skDcCJ6aykzDXp5qYMt2xwKRRUYV
	 jiIl8df9gj58mFALW4UNQZRtQHlpcLOn8u3J5qZ/F6Kkx+qVndv0YwNH66LoyMWBVKE8f
	 iwo8MEHMT/pF6plNazt0+si+enSfDDQu5vCppmHVz57nkYqjPkIpwEUrAtSWl/gimLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850005;
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
	bh=SOs14G8NmV1dCfDhbAckYX0HA3eNxJrwy1qt3mXv5+s=;
	b=lbMab20adHgXtDqb6aamWuXw2PEx5nqF0qQ4TDgoUXrPVXuMR8fZNJiIZErlVPHfHCuW
	 JlhloeK/oxdvkIrrdxAqZMFA6gMoll+QupIGm/kKKBjNESSGxKELQa4O5gyedQwhi5gFr
	 9k/gMGClazWqB6/0NyfQuZCsRPNae3khTBDFgJoSAEJymD9UOyfdt3my5RDsub7wN8TTC
	 XlPNOnRBTnKZBMeMJHkUpoYoVAeP9Ald1ceKBMplaSYV/yOAb+PlaGF+f8g2yTifjiJMb
	 B3cWVYiN3HnpKDwoOXJGrOT1nMGePGweGlM39p4+C2plr9ZgWwlt+XrQmaGbZsymYIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LhFDtW00;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.68
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56C0606A336;
	Mon, 16 Nov 2026 17:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A56C0606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LhFDtW00
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hycdeAR7ywwA4bzmQUcG6Ib3uNshcd21R0mHEbWAKwXiQS/6JdBgPVv8XyKJy2e+3KrZTg51tnw2jjLhj/LCdE9p5xYFz6VJbt6TCliEy2JMp0GQ0p56eqc/8/XzlvG8mQ3ykYt/vunyOW7imCPYrRYQXx65Z6aqJZBM+KhNgYZ51hLQUQ19qsnSGyNa6HpqYc3pF9RSuLZSfKDBM3nrF4BOeoc51H+Vin7v9Rpt4CtQmwL8flWmbe+lgzRKsixWqBsox1TXxNxf6WpYe1+BanU8wJQjt21vwINdmGK6gT5LMwybKP52vNPS/1xz8P4cxY5tdkiSBS6zpVYJCAbFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOs14G8NmV1dCfDhbAckYX0HA3eNxJrwy1qt3mXv5+s=;
 b=jvaIfOmCGeGwgyuRDnXVaGtZlPHi3s2TwG7p2QAmbBY2FBkyGqt7xq9DrKwCCIG0pEt7QPwFIX58DFZ3nwycKaXzzUJU1iM8WFTjMWuJhHuKehdxQqFzuIFYkCfceQljpZDnumHAaQHlOir5sJoTvMd6Gi7rEuRCOoYrkrLk++s75fLMHKuVwusGGQUCH6E2lA43fZ42l+VfcCb4KsNsqqSEybFH1JbVywAoOIq21i0z5sv5jtdHC0lsWsuh5ObZYfi+VvqHY7xox5Gr6XOP4ieRcAn5RZbqvpSMf/f9NMjn/5aLvC002soDiaCO5mdLMjHj0wJnlftuhIqLR9T15Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOs14G8NmV1dCfDhbAckYX0HA3eNxJrwy1qt3mXv5+s=;
 b=LhFDtW00XrNMiSq9XkPX0qh+6R+4ePZzVMXdxkjj5XE5KbNyq7sqaNk/H9zNiExvdu6NDvXLIh1PX0/mFbx0OLEYmgxWWMFHsdy6HkXdzG0mxCxSTSbWjADhNCWOG4p9Ov+kwd9ZC95tz3fkhJnzn4UQYTYZLibw8shcxleCD7/GkenfFCnJzPgeY8c/9PpqW/xpOJTQwtaVEGwh7le+caNuNcKFClialwxh7OmUMpTeNP/r7FvsdT9qlpI22bUIICK2JdKiTaa014a3fE3XWyZGWwUlUTVAPO/Hd0tvk8MnGPhC8oFIi4o6K8agE7ZaJiUb76w8IIfcZQkVvmg+6Q==
Received: from CH0PR08CA0013.namprd08.prod.outlook.com (2603:10b6:610:33::18)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 17:26:35 +0000
Received: from BN3PEPF00022BBD.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::a7) by CH0PR08CA0013.outlook.office365.com
 (2603:10b6:610:33::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Mon,
 16 Nov 2026 17:26:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BBD.mail.protection.outlook.com (10.167.248.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 17:26:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 09:26:08 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 09:26:03 -0800
Message-ID: <a94c46ea-42f0-4b92-a880-daff9fb918fb@nvidia.com>
Date: Mon, 16 Nov 2026 19:26:01 +0200
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
Subject: Re: [PATCH V1 rdma-next 22/24] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-23-yishaih@nvidia.com> <20261116090653.GD11319@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20261116090653.GD11319@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBD:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: dc4e7ced-22a5-44be-6ede-08df4406c335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|6133799003|261009223027099003|11063799006|4143699003|56012099006|261028144727099003|261102123227099003|261026121527099003|261021123027099003|261026140227099003|261022105027099003|261021121427099003|261022075727099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	OlIpjak9xcN8ZOvrIb9oUR4oJF2GxuaPE6aIeaZ2UrwOcsgPBx8bjbb3U/8VfswUa6jXG9vRTgETiw8eDn9a37jWgmtGxM7JVuD8oT5wGee9K6f4kQpjZjhQ6DYjfHm7jQ2gwKAQChpvxe6TGWySGQQGTkqJkpZk2OwfrmT2ZZ4lzOiItEjbinAl3pxXu8zTw0N7VsxUv0QRmTVOkXCXs/WOt/3smog7/DvnpSmtyH6V+T+j3QecPnBDpQtF1x3DHXe64MinUs78putR9urhiqMKgmtLfcZ1i4YnFxLCVgRlWf1WV3g2ISMz1fECAekZTc1ZIprnX+JcXfD8nibUnpLyJUPRh7TC7RAne0hZTHxHUVNZPu31O/en6FAGKxsSVH+1FkMjcME2M9aK04DzYebKgmHdFlEakOJ+zMO8pDFyLHL+MnrUHxwrFYs4yy8xKrl7vmXhjROpQROxpgdWmuCRzFZZfgHzi0pAQXFFy/qr3YGX8PSiE+E5AcJ15f/eL8Y96U/KB5BKk5VPX9TQejfQXGVdB8TfpdLQkLTiFLMYZMW8IdbqUE2o/epGYpSdsbqTdcOIxeBtw/dMciOCdNDuWQUoIpehU6RG18F1d/c2Ilc1hzhJ47b6yuuRTWQEE5S8+F0P107VQ6KLS6qFG4Z9pQR/L/wUeZHpNzMgdwuj2puw3LwHA+c+XxTPb+tFPHgqQgZzvAQ3ZMF54AdhvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(6133799003)(261009223027099003)(11063799006)(4143699003)(56012099006)(261028144727099003)(261102123227099003)(261026121527099003)(261021123027099003)(261026140227099003)(261022105027099003)(261021121427099003)(261022075727099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eGT5KSxkKJYf6T5vthHt8IvjVhPTB+ukZK8nzz9Sa+A/4c+Abo6l93HQljLpkymoPZT89o84jK1ASqVJwiIrLcz08rnqpnBPufODMY3zP+9P3A5AAxy9xVsYZO+jelCTAx15dItVqrBHp3NlLgfXeTsjHjTbc5yhmYYYdqbp26Xh2yg4EV8cTVB5A/owlO76tB6B9mkwurq8MKLp/OrDMDTszTYVKGPvkZJPetPkGchA/bTRsaWfJJNTF6W4muv3u4l59lsydg1HZy8s28MkJ8tzy7DMi1cQE73/mwbgMRoTc04ZDZnKF5zJAz3LU4jL/90+3CZpgiOivZKl+jvEpKR1Jv268RIx3a0yJwSG7HNqmw5B8o7ty1o8kf3wYSH3pvicGbs55KSoVUKnL7ki7hq6IBtJO4tBlofQzRToG8rnxXDoHfuhnx5cism5zZ95
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 17:26:34.3751
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4e7ced-22a5-44be-6ede-08df4406c335
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318

On 16/11/2026 11:06, Leon Romanovsky wrote:
> On Tue, Nov 10, 2026 at 03:43:18PM +0200, Yishai Hadas wrote:
>> The device, port and ucontext attributes and the SRQ size limit are
>> computed as 1 << cap from log_max_* FW capabilities. An untrusted NIC
>> can report 31 or more, which makes the shift undefined. The same
>> applies to 1ull << log_pg_sz with a value of 64 or more, and to the
>> max_tso computed as 1 << max_lso_cap, which can be 31.
>>
>> Use MLX5_CAP_GEN_LOGSZ_U32() and MLX5_CAP_GEN_LOGSZ_U64() for these
>> values, and BIT() for max_tso. As the limits can now reach 2^31,
>> compute max_qp_wr in 64 bits and saturate the max_res_rd_atom and
>> max_total_mcast_qp_attach products at U32_MAX. Cap max_cqe at 2^30 - 1,
>> the largest CQ size the create path accepts.
>>
>> The SRQ size limit then lets the rounded up SRQ size overflow the int
>> srq->msrq.max, and the SRQ buffer size exceed the int passed to
>> create_srq_user() and create_srq_kernel(). Reject both above INT_MAX,
>> computing the buffer size with check_mul_overflow().
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/hw/mlx5/mad.c  |  2 +-
>>   drivers/infiniband/hw/mlx5/main.c | 65 +++++++++++++++++--------------
>>   drivers/infiniband/hw/mlx5/srq.c  | 14 +++++--
>>   3 files changed, 46 insertions(+), 35 deletions(-)
> 
> <...>
> 
>> +	/* The CQ size is a power of two that fits in an int */
>> +	props->max_cqe = min_t(u32, MLX5_CAP_GEN_LOGSZ_U32(mdev, log_max_cq_sz),
>> +			       rounddown_pow_of_two(INT_MAX)) - 1;
> 
> <...>
> 
>> +	props->max_res_rd_atom	   = min_t(u64, (u64)props->max_qp_rd_atom * props->max_qp,
>> +					   U32_MAX);
> 
> Avoid min_t() where possible: it silently casts operands to the specified
> type instead of checking that their types match.

OK, in V2 there will be no min_t(). The products will use 
check_mul_overflow() on the u32 fields, saturating at U32_MAX, and
max_cqe will use min().

> 
> <...>
> 
>> +	props->max_total_mcast_qp_attach =
>> +		min_t(u64, (u64)props->max_mcast_qp_attach * props->max_mcast_grp,
>> +		      U32_MAX);
> 
> <...>
> 
>> +	/* srq->msrq.max is an int */
>> +	max = roundup_pow_of_two(init_attr->attr.max_wr + 1);
>> +	if (max > INT_MAX)
> 
> Please fix types instead of doing this check.

OK, in V2 srq->msrq.max will be a u32, so the rounded up size always 
fits and this check goes away.

> 
>> +		return -EINVAL;
>> +	srq->msrq.max    = max;
>>   	srq->msrq.max_gs = init_attr->attr.max_sge;
>>   
>>   	desc_size = sizeof(struct mlx5_wqe_srq_next_seg) +
>> @@ -238,8 +243,9 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>>   	srq->msrq.max_avail_gather = (desc_size - sizeof(struct mlx5_wqe_srq_next_seg)) /
>>   		sizeof(struct mlx5_wqe_data_seg);
>>   	srq->msrq.wqe_shift = ilog2(desc_size);
>> -	buf_size = srq->msrq.max * desc_size;
>> -	if (buf_size < desc_size)
>> +	/* create_srq_user() and create_srq_kernel() take an int */
>> +	if (check_mul_overflow((size_t)srq->msrq.max, desc_size, &buf_size) ||
>> +	    buf_size > INT_MAX)
> 
> Same

The size ends as an int in mlx5_frag_buf_alloc_node(), shared by all 
mlx5 users, so fixing the types in mlx5_ib would only move this check
there. So we kept it where the size is computed.

Yishai

