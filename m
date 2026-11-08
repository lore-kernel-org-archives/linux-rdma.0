Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794135176;
	b=29RwpGzdwUAopFftwOr599NXbo3YmUz1Quz7CsN4Yv/0J3Zl94da0KJerv6G9uGtcGZ1
	 ZB+9M72ZQokWpJJ7G1GQocpho/njQCj8etr5rrqrwcEIThdbPTJkzIoM886xjte0N2i9A
	 V+acEWVh9bXD4q7LDi6VHH1IS6HAgKI8GoVf2azm/gfy+NjV+te2UXZpGH8G4ZsHH973l
	 Dc+qprcZmBFnzdxshGYpmlCZMO9ohUAWQViL2+fCsDNl5hxNBw+lzBuSCx6wGvYftVk5K
	 MGGWHrSa7CU+QoK/lf7DznetC74io7OjghxFVOa0om0rFgNspHD4PAxpYG1J3pH6TyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794135176;
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
	bh=578g5knDjIfkkutB2OCEVnPMxywy0GguUr698uS06xI=;
	b=p0gSkrHMaI4u5bDU6hSyII6SclGlcA8Rf6cVZdK2MybVQbVLUx6cwSTcc8bTZs+yaCBF
	 x27LW3lV19KHxc/JmnpTOZzXBkMeHnWE07HUue74UiUTXMJQ52C5cMcT3xXPTxXyf/FWG
	 /dMGdYan7SvzgVYV2jluWAvxGfOm8yQX0HZOiZ3ftqKw4TVXaAngMIXbm4svJoIKdH9/z
	 JCORM/LBA8bS4TBrc4KzJVeuPYD1VoEnMld/8ACCw4NIjJwElXAcOINUKTLK/7uSlaOdF
	 zLx/OfIvK0RATU3wCcXjpofASEHJDjElhMftQrgbs7r3J/3DBihqsDQ8NEht8MZrIlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N3sZFZqs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.47
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CA1606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 10:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17CA1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N3sZFZqs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xe9AfAXGdOPAii2fvHxIBfbl/SvOdTvOnhCGLN3Ugr9hr7u2haxEiTBIt2ZDBPb1icqIDL/LQ8HSXmBcbS8vGqWVVUcfdSrpzrAum6y+ti66K1NCP6vJ1ifY0UjRMF7xi15mtnSrVfXOadXBtETygalqoFaYwmSBX2rvrs6R5vxhERAKIYRWy1JCaWUQYhDjk4g9eeTLZb0Az1XY0D1CQt76zUryWPGNtgBN0zXdOIAnwt1Ht4xfc60Xp5nT8LNtwuQ0cspULIGgnVUr+JxkDJa0dMyEsAyqRjw5+QQ+8l7mx1TA36CMwh1r3Is03nf+huUtqzcs5eQEb6dyN1hvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=578g5knDjIfkkutB2OCEVnPMxywy0GguUr698uS06xI=;
 b=Ltdk78azYmmEnqg/kR7XjfufwnJgjIWOiSAVNJOyBQQfNX0GYPf3QgzH093jwLz0rD9r/XVCBF+CtUsZV57LFmqen2309Z2w/4A7OezOILU4hMmTh20/SxDKpeqyztejC6PKwZxguEOj9FBweTanuCjo+08DQQU5b6VVaXRZxzqb/J8tmbl8MTN+SiZ7iMQ6zz0C0m/BISRP94gfmOJHwqqdyG+8Jr8lO8fKyrUaD/teNGvyKUema4MbbmZ0xzhbzUonPtlYdorZnyVr5Y+291MBtWXdPEyie+2IOjoyHgBwTxP1NejrVHTYlw3bL3Uob+IUJy2DrZUsVTfBjZ94bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=578g5knDjIfkkutB2OCEVnPMxywy0GguUr698uS06xI=;
 b=N3sZFZqsoUJuNCWD8FVsti9pJcXKIVC3kCn4+4LSzqjUozaEQG2XrARpRDTWKiIbD4WbBTiqwlCgfEuce35yb/hlOokX1C33f5nnnAULZToS7mFbBAEJTqt1p6PU7OjuKmBoPPG2Wb6B5XGGAYZKMkCMFBV3rzVYPiKbmqOnjDm2YE7BSZRgGwOYJyCY/Y538fzBsAjQcVt5d0joXQXMqUVddIt7etPXeVBY1d/bulMl7qOkYCRTUBr+Te7m4Hf/7ImzO3uE2cxr6rwQk4FrQov7Z34BwgbL8cU/llfr15fTqcVTBm3rTHA9J00os0nc6v2TaGU8LdlxhlFizLhzCg==
Received: from CH0P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::25)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Sun, 8 Nov 2026
 10:50:49 +0000
Received: from CH1PEPF0005BD5D.namprd02.prod.outlook.com
 (2603:10b6:610:116:cafe::c) by CH0P223CA0028.outlook.office365.com
 (2603:10b6:610:116::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sun, 8
 Nov 2026 10:50:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0005BD5D.mail.protection.outlook.com (10.167.244.246) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 10:50:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 02:50:37 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 02:50:36 -0800
Message-ID: <08f88e2d-0d88-42f5-8f82-8c76ee1f3597@nvidia.com>
Date: Sun, 8 Nov 2026 12:50:28 +0200
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
Subject: Re: [PATCH rdma-next 15/23] RDMA/core: Set the CQ comp_handler after
 its poll context is set up
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-16-yishaih@nvidia.com>
 <sashiko-outbox-197668@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197668@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5D:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: dccc8390-eb6a-40bb-43a2-08df3d8626be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|261021121427099003|261102123227099003|56012099006|261009221227099003|261026140227099003|261009223027099003|11063799006|4143699003|261022105027099003|261026121527099003|5023799004|261022075727099003|261028144727099003|22082099003|6133799003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	764YzBuM4fDb8SgJRlfp+tfcKek3DNqZwG48NKp1/0R39GSte8HjzLAyp9wBrNA+rMwDO+l7IGui6pKbD2kMJPkNGCoiYCjecHriIputoEDl+YAn/cfv95vVjUDflnkR73BDcQpbPlH4b6+8AFzsW2qJuPbEhDxQ3WPsZcPyNsgrbEeWdGQPLVRobTWa5PM4RKflVFnOPxvY6bjLNeamFyvY5CmTU4SoxP9vaEk0FxN1ReJVPVdyrmesvXaSAjdBgH8BBLZycuO5uibTWKTWz90ScLo4NuDY1wAvZ7pTBY7yzcCjhzJKiTHh1xJDAaAoOZ64G8rSt/G3TWBZcsRNrxMITrgEvMSchbNpyzQF27VYsNsMJN5UiMOZ1LGKjSGnflEaYwF+hdMpWnsPn6wJYfHOUl1viRm0367O+KICYFUke6maKN6kPilAw5s/ibJzrV2kUn5LN0c+0IPp7fyAlICV6836W0XtXdn6SW5JPpg/uXjatZP8p+wqEHHgR3uB4I+CVAYsPHn7rVu169Z97pQsMYZzn25diM9yf8asv/5xWg6RqXdu6gv8jau3m22izSJD4dRfbGwukPJxvC4lvR1g1omGNrZI0xYbUHuG8diGqML3LXl74uzctGgCpQ2B6+tvtz4/gC0dKFGdpPZ6uDwcjCKJt8m5agC1ySnT6JsAx1v1u/g9Fkike3nknUh84eFxn+gOi8EnzRXizwfBkQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(261021121427099003)(261102123227099003)(56012099006)(261009221227099003)(261026140227099003)(261009223027099003)(11063799006)(4143699003)(261022105027099003)(261026121527099003)(5023799004)(261022075727099003)(261028144727099003)(22082099003)(6133799003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uTutKafQCAHeQiJ0BKQDRAx/hSXmf51BRY6ptvDOT2+z+TTpkUp8GHrE68CIKhKDvBIHYh28yB17PP1i711DLCYIha/NiyEAG75/8Im6Ro44wGKJV7xuxiJT5vxxi9NZjB0G6d53KTQ6DQSKOotNa50mcTd5axitNehJ/8veXdY4jGd/a4URGWOkO/oV4nj3lA28X/oPM43ETzA++Hj7bmwemXgdamoWVBFkvjoZYLbDeB8Y9QVO8tJJ3aTmS7FJbTVnpMzuMjmK75C4qeqO07yilyNvXFTSDLIu9EYXinfAY/OD9gh872qDUHCWL85MbP1aym3bueG9oM+zsiP3tCve8GgHldE3xGgQ9aKOys20fcQhUMEA8FdkK8uG7FiwoqmIeuyqzyri/2OAR6vXnQVaB9Aw0RdoVNHQqAAHBxrf/tu/9zAFYfZp/9sNWJe7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 10:50:49.3423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dccc8390-eb6a-40bb-43a2-08df3d8626be
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/core: comp_handler initialized after create_cq() in __ib_alloc_cq()
> --
> 
> commit 08ca16c59be95a85d42f773522716fafbd346f19
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/core: Set the CQ comp_handler after its poll context is set up
> 
> This commit updates __ib_alloc_cq() to initialize the CQ poll context
> (irq_poll, work_struct, and comp_wq) before setting cq->comp_handler and
> arming the CQ via ib_req_notify_cq().
> 
>> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
>> index 12304c9a9403e..42e4d272f5ade 100644
>> --- a/drivers/infiniband/core/cq.c
>> +++ b/drivers/infiniband/core/cq.c
>> @@ -217,6 +217,7 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
>>   		.cqe		= nr_cqe,
>>   		.comp_vector	= comp_vector,
>>   	};
>> +	ib_comp_handler comp_handler;
>>   	struct ib_cq *cq;
>>   	int ret = -ENOMEM;
>>   
>> @@ -248,19 +249,16 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
>>   
>>   	switch (cq->poll_ctx) {
>>   	case IB_POLL_DIRECT:
>> -		cq->comp_handler = ib_cq_completion_direct;
>> +		comp_handler = ib_cq_completion_direct;
>>   		break;
>>   	case IB_POLL_SOFTIRQ:
>> -		cq->comp_handler = ib_cq_completion_softirq;
>> -
>> +		comp_handler = ib_cq_completion_softirq;
>>   		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
>> -		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>>   		break;
>>   	case IB_POLL_WORKQUEUE:
>>   	case IB_POLL_UNBOUND_WORKQUEUE:
>> -		cq->comp_handler = ib_cq_completion_workqueue;
>> +		comp_handler = ib_cq_completion_workqueue;
>>   		INIT_WORK(&cq->work, ib_cq_poll_work);
>> -		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>>   		cq->comp_wq = (cq->poll_ctx == IB_POLL_WORKQUEUE) ?
>>   				ib_comp_wq : ib_comp_unbound_wq;
>>   		break;
>> @@ -269,6 +267,15 @@ struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private, int nr_cqe,
>>   		goto out_destroy_cq;
>>   	}
>>   
>> +	/*
>> +	 * The CQ is reachable from the completion interrupt once created. Set
>> +	 * the handler only after the poll context it schedules is set up, and
>> +	 * arm the CQ only after that.
>> +	 */
>> +	cq->comp_handler = comp_handler;
> 
> [Severity: High]
> Since __ib_alloc_cq() calls dev->ops.create_cq(cq, &cq_attr, NULL) before
> initializing the poll context and setting cq->comp_handler, can a completion
> interrupt arriving right after dev->ops.create_cq() registers the CQ in the
> device EQ table race with this initialization?

Not for a conforming device: an event is raised only for an armed CQ, 
and the CQ is armed only after the poll context and the handler are set.

> 
> Unlike __ib_create_cq(), ib_uverbs_create_cq(), and
> UVERBS_HANDLER(UVERBS_METHOD_CQ_CREATE), which set cq->comp_handler before
> calling dev->ops.create_cq(), __ib_alloc_cq() calls dev->ops.create_cq() while
> cq->comp_handler is still NULL:
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
> 	...
> }
> 
> At this commit, mlx5_ib_cq_comp() calls ibcq->comp_handler() without a NULL
> check (until the subsequent commit "RDMA/mlx5: Ignore completion events for a
> CQ without a handler" adds an if (ibcq->comp_handler) check in mlx5):
> 
> drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_cq_comp() {
> 	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
> 
> 	ibcq->comp_handler(ibcq, ibcq->cq_context);
> }
> 
> Other RDMA drivers (such as efa_process_comp_eqe() in
> drivers/infiniband/hw/efa/efa_main.c, mlx4_ib_cq_comp(),
> mthca_cq_completion(), and cxgb4) also unconditionally invoke
> cq->ibcq.comp_handler() without a NULL check once the CQ is inserted into the
> device CQ table during create_cq(), and cq->comp_handler is never set if the
> default branch in switch (cq->poll_ctx) jumps to out_destroy_cq.

For a conforming device these drivers are fine: the first event comes 
only after the arm, and the handler is set before it. A NULL handler can 
be hit only by a device that raises events for an unarmed CQ. That
matters only in adversarial mode, which only mlx5 supports, so the next 
patch handles it in mlx5.

> 
> In addition, even in drivers that check if (ibcq->comp_handler) in their
> completion interrupt handler (such as mlx5_ib_cq_comp() after the follow-up
> commit and hns_roce_cq_completion()), the CQ is already reachable on other
> CPUs while irq_poll_init(&cq->iop, ...), INIT_WORK(&cq->work, ...), and
> cq->comp_wq are being initialized. Because cq->comp_handler = comp_handler is
> a plain store without release ordering (and the interrupt handler reads
> ibcq->comp_handler without acquire ordering), can compiler or CPU store
> reordering on weakly ordered architectures allow an interrupt handler on
> another CPU to observe a non-NULL cq->comp_handler before the stores to
> cq->iop, cq->work, or cq->comp_wq are visible?

The arm orders them: ib_req_notify_cq() rings the doorbell with a wmb() 
before the MMIO write (e.g. mlx5_cq_arm()), so a conforming device can't 
raise the event before those stores are visible.

> 
> Now that ib_req_notify_cq() is called after the switch (cq->poll_ctx) block,
> would it be safer to initialize the poll context (cq->iop, cq->work, and
> cq->comp_wq) and set cq->comp_handler before calling dev->ops.create_cq(),
> leaving only rdma_dim_init() and ib_req_notify_cq() after create_cq()
> succeeds?
> 

For a conforming device both orders are the same, as no event comes 
before the arm. For a device that raises an early event, a handler set
before create_cq() would run during it: it would poll a CQ the driver
has not finished setting up (e.g. mlx5 initializes cq->wc_list after
the CQ is added to the EQ table), and if create_cq() then fails, the
scheduled poll could run on a freed CQ. Keeping the handler NULL until 
create_cq() returns lets the driver ignore such an event, as the next
patch does for mlx5.

Yishai
