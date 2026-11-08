Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794142973;
	b=M9MYV19+IkwP5GU3jYdYb1iQg8MccenyeIN4Ak6hsY2aBjIZFn4gYfMhpS9ij8FMTzPr
	 z35MOgcnKb4+9z/uVxQxmuAXamLpVAMckkT+2sxe8abtX2gNWgjQIKgDLA2/Y9oCvZAsT
	 iQ3JHkxkbDIBlzUzK5j+21LbmWJoetmXGaJ7ISbsEEee/Qrlwo67LNX6Cm9RHcKdbKN2L
	 Rdc07mp6GMAjXbS/RmCNpcgw4rrFjJl7lveMbdFTutVefqiQLO5XifGKh2giOaQh63nmF
	 iy7GdkE2doyPbO6UJFGYl0iOYVFPSrMprxmvYEhsn/TGloAMiCxrsDGX9DmGS1l7GQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794142973;
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
	bh=cYVfRN5o4LHJ1cisQsX6Bkzlhbi8rAvSXb5KG4k82IA=;
	b=hbgPw8bQRDl9wfpABJ4ri7vR3Azws351levtWNMc/Lh8pJLta1nXwQxk4DYJ4+aCSeF/
	 oReyWnyqICLuloovN8yxeSgnqaDVCMI9g4N+1JCjRAbZFAoG8X+5F+WWqCrf67S/0g39I
	 Wn8z67QIS2HRwPPEnIOkJcyu8/cR6VddmWdSnYkfIgKDRsp6f1b8EpLTqZUZHkGhzam1K
	 vPQLWgLCu09YHBFX5T1kA/6k5PTjxPvmjDRd3rDGcQ3UDZPntPdfDcj91q/uCrDPu/R81
	 fqNiBkhpsammP29Y4aNUIhyJHNXHZc/AKoep6/G70il4H6PeCnVu6SH+vd98S8Y255g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="S/EEdgf1";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B30606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 13:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88B30606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S/EEdgf1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=An3OqkcR+uAgr15LzUeRduLsAfpNmwFJO4OmpHBrG2RNt9udPni2vXXjB/1msPr3CuH1+W8TjXRbBgQU9Sez4Yg5KDSok99Ub3hvdk23aj3NIutlFJhlOKO7/A4UtpFRDfB8yVO1NxAH/x2T88R4/m94bJy1iycPKCc+3cpCBHbFBzxoKaOuRmm4fvedeXIEHGzP+3V3xSe3+8rloS2rDLdzwUVFYUsNoaoSWTCxKZODNxFM5nDqHgk2oWXT1Dq98OBacFgq1BJeEIy0TDv1cZEOObHMsJEbRKgdx0EXAW1T2H4C2iieSUh36HC4seBcWlYQzGEbVHfdZQqMPBamXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYVfRN5o4LHJ1cisQsX6Bkzlhbi8rAvSXb5KG4k82IA=;
 b=vfOHGGtsLRM1Y1mYEc5daNF4cu4vYL29vburAM7QMSRJh0jILqEsBHWX4rLkjsLNOUnSa8rypl8X1suft2I3AtJ+G47xGSzdLHl+hcT02fvdV4P/BuZAsCZvLmFfIshspyvaMRMwh6CgLn20tG5iHhtssAE4ZFZ9T59Ymu5vpZSoNUkj5SPP/A3B4sk/Z9Q6SqJbnfZZEcQmHh0cuE5+aaQkZSMY8o2RALhQJk42ok8LMqZ4nBcd43UaByKlkAynOhuVnpfQrmkHUYhsnS/xSI42LPWz7Zdvtdk2dzFPpiG99eFH3O9nkjfSnLLSup1lVbBowoCsR5e3wv9RmY8GEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYVfRN5o4LHJ1cisQsX6Bkzlhbi8rAvSXb5KG4k82IA=;
 b=S/EEdgf1+pFT8SXB/u0uCG1MCnc0c3wpKbhG0Qh4TvkWXKD9GtO7P3g4ZcnPE3eWAPDyC9WdIiNFpfPOPt8/j8BBQvPdeSuyrK1tNR/1nWAIoY8roFiWSNFlNzzvEgYLks58GtjZR0KKwhjmDW8nkydTD/1hX/LhuzZxGhOOjGs8X3H5QwOMcksSE21zHaS1FVgC7DMF46zbNdQm+VUGQ0FXd5I9c+p7h4fOlpqnPr45+e0C/HJ+k5amwk6rfljEkEI5fOvfFydlByyHz7eIBp/Qvuv6qfiSDCyxYI7rWYvqexLuPr9ejIoHmVqxTvxCzAFbyddtqokLJ0JpVVkizg==
Received: from CYZPR17CA0003.namprd17.prod.outlook.com (2603:10b6:930:8c::23)
 by CH1PPF0B4A257F6.namprd12.prod.outlook.com (2603:10b6:61f:fc00::605) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sun, 8 Nov
 2026 13:02:48 +0000
Received: from CY4PEPF000392DD.namprd03.prod.outlook.com
 (2603:10b6:930:8c:cafe::1e) by CYZPR17CA0003.outlook.office365.com
 (2603:10b6:930:8c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 13:02:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF000392DD.mail.protection.outlook.com (10.167.247.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 13:02:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 05:02:34 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 05:02:33 -0800
Message-ID: <b701fd44-5fdd-45e8-a8db-75b7d25a6e2a@nvidia.com>
Date: Sun, 8 Nov 2026 15:02:25 +0200
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
Subject: Re: [PATCH rdma-next 16/23] RDMA/mlx5: Ignore completion events for a
 CQ without a handler
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-17-yishaih@nvidia.com>
 <sashiko-outbox-197669@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197669@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392DD:EE_|CH1PPF0B4A257F6:EE_
X-MS-Office365-Filtering-Correlation-Id: 01dab4a8-9f2d-4b70-cddc-08df3d9896d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|22082099003|18002099003|6133799003|10067099003|4143699003|11063799006|5023799004|261026140227099003|261028144727099003|261102123227099003|261021135927099003|261022105027099003|261021121427099003|56012099006|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	QW0PPp+q9AVwBREuO2amwchdLiIwvZSMgabjMB2A9lTqo+95SWK4f6xtTYf5wOgTWREO7hurZtpmcNvvAhQ7bfdMqrIjSSdx3fosqaQUSLwP3NkSWyxfWvktOpwa/DmeLavhKEi0AwJCcgF92ACRFtf2CpLwOCk7a0CrDZ3TBG6UWr819kexg3MGhhdsFIX8JsKQgV3ZjF/S1iYF8IpZz4kbB3jrrdfSoJhPGOwFUP/hgJO8LG9llxxfr56W3F1Jjgy+eXd+O9dajZorweZx2bk5+lbvKVFzXT56D40Zxk2EyFtn9yr5xbFtFlg7tM47EkvMrKdq9engUWRUHVx9d9TQxxMwAdkS4pcmL7Pxg64iQUjxkFxbWg/lXS8rnWGNihDkMBw5rYo1/3KSWr27G3AflRReTE3Ro0n33GX6bgXBy+PWJS5B7eFQ81l/gUMq+YmEaykTS9MTeP5F+L9ZfJygHgMVO5f7ZDEdmVIkZWcyJAV2jhk7t78UF83HNK1r0i2c4BciWBeITVAUxF+T3S5qgqXK/4eYdtfM+GrShOczdjEEY8/ld7BlkNHdWAUd2mLoOMchjfS0DgUXi8Ca8C//ebrrX0V7s8PvXX+4I9V2V2TslvxAayelZJU5HCE/3KxR1SBc+aXzWe0X3ku/z6PeitCDmIBgimlBs3autZ8O1in+r8Ag0SM8+2TfpyiSdCQP4q2V6rEYbvPun7qkFA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(261026140227099003)(261028144727099003)(261102123227099003)(261021135927099003)(261022105027099003)(261021121427099003)(56012099006)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+qCr8tJmMZSj6CFqh3qKKsKdtgdJFnpkNwy0lvC9HUkbencYF3k6Itc5Sl9VApcO/WvYUwzcJ+qx07WV7ThMqf0yJusqPpeEDESaWT+y4vCf3+Orzxeq7cne9cmkQRcTlKKj3wH+JiE+XHwM85zWiF7L1ROMDzO8Z70U8rErPRXegZv3M9wnixmzf+/WY0cOOAS/1D0DreQe+ARnnlEQ/QiQ+jJ/JiaqscPSm4FuKSLfV6DPvhkOZ+XUE9KTLBGznngipKjEnEKSYNUn1l6QqArkfFxI5w9OMl72hA676wsuMeUgoEfkc6cDDF1FaNdcqNn1A4+aeCzkhdz8tVGqknIPxdXnkZqs0UfF0FG9vdutJlKYpGoGw+P46zzIVJQEFSWnyPyHc77RYWf3g5C7CwdO91ry0wn8F0owXjrmQCVMFM8EaXaygvMga6D9zv11
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 13:02:48.3539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01dab4a8-9f2d-4b70-cddc-08df3d9896d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392DD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF0B4A257F6

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/mlx5: missing acquire/release on comp_handler in mlx5_ib_cq_comp()
> --
> 
> commit 74de7436d2c18504b739bcbd6ccce8e1cfa93dc1
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/mlx5: Ignore completion events for a CQ without a handler
> 
> This commit skips calling ibcq->comp_handler in mlx5_ib_cq_comp() when no
> completion handler is set, preventing a NULL function pointer call if a
> hostile NIC raises an unsolicited completion event on a CQ without a
> handler.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 5cc86c3f93f3e..f955eb762051d 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -46,7 +46,12 @@ static void mlx5_ib_cq_comp(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
>>   {
>>   	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
>>   
>> -	ibcq->comp_handler(ibcq, ibcq->cq_context);
>> +	/*
>> +	 * A CQ created without a handler (devr->c0) is never armed, but a
>> +	 * hostile NIC can still raise a completion event for it.
>> +	 */
>> +	if (ibcq->comp_handler)
>> +		ibcq->comp_handler(ibcq, ibcq->cq_context);
> 
> [Severity: High]
> When a kernel CQ is allocated via __ib_alloc_cq() (such as dev->umrc.cq in
> mlx5r_umr_resource_init()), dev->ops.create_cq() publishes the CQ into the
> completion EQ radix tree via mlx5_ib_create_cq() -> mlx5_core_create_cq() ->
> mlx5_eq_add_cq() while cq->comp_handler is still NULL.
> 
> After create_cq() returns, __ib_alloc_cq() initializes cq->dim and the poll
> context before setting cq->comp_handler:
> 
> drivers/infiniband/core/cq.c:__ib_alloc_cq() {
> 	...
> 	ret = dev->ops.create_cq(cq, &cq_attr, NULL);
> 	if (ret)
> 		goto out_free_wc;
> 
> 	rdma_dim_init(cq);
> 
> 	switch (cq->poll_ctx) {
> 	case IB_POLL_DIRECT:
> 		comp_handler = ib_cq_completion_direct;
> 		break;
> 	case IB_POLL_SOFTIRQ:
> 		comp_handler = ib_cq_completion_softirq;
> 		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> 		break;
> 	case IB_POLL_WORKQUEUE:
> 	case IB_POLL_UNBOUND_WORKQUEUE:
> 		comp_handler = ib_cq_completion_workqueue;
> 		INIT_WORK(&cq->work, ib_cq_poll_work);
> 		cq->comp_wq = (cq->poll_ctx == IB_POLL_WORKQUEUE) ?
> 				ib_comp_wq : ib_comp_unbound_wq;
> 		break;
> 	...
> 	}
> 
> 	cq->comp_handler = comp_handler;
> }
> 
> If a hostile NIC raises an unsolicited completion event for the newly
> created CQN on another CPU while __ib_alloc_cq() is setting up the poll
> context, mlx5_eq_comp_int() -> mlx5_ib_cq_comp() reads and invokes
> ibcq->comp_handler with plain loads.
> 
> Because ibcq in mlx5_ib_cq_comp() is derived from cq (&to_mibcq(cq)->ibcq)
> rather than from the loaded ibcq->comp_handler pointer, there is no address
> dependency between reading ibcq->comp_handler and accessing fields of ibcq
> inside the completion handler, and neither irq_poll_init() nor INIT_WORK()
> provides a release barrier before cq->comp_handler = comp_handler.
> 
> Could a weakly ordered CPU or the compiler reorder the stores to cq->iop,
> cq->work, cq->comp_wq, or cq->dim with the store and load of comp_handler,
> causing ib_cq_completion_softirq() or ib_cq_completion_workqueue() to see
> uninitialized poll context fields (such as a NULL iop->poll or cq->comp_wq)?
> Should __ib_alloc_cq() use smp_store_release(&cq->comp_handler,
> comp_handler) paired with smp_load_acquire(&ibcq->comp_handler) in
> mlx5_ib_cq_comp()?
> 

Right, a hostile NIC can hit this on a weakly ordered CPU. For a 
conforming device the arm already orders these stores, so the core is
fine as is. v1 will fix it in mlx5, the only driver with adversarial 
mode: a kernel CQ will ignore events until its first arm, using a 
release/acquire pair.

Yishai
