Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794218657;
	b=mf7Xasn5tdDv7tSHfkVnCUhuHz6mgDn5nVgPxeiSh/6zAI3hK9BHwPgvBklGRRDTAPOW
	 7ziz1UdtS7IR3RqrrlkyCdT20BC06uZN6Ucx6YIg3j3HTdLPA5nY9N6L4DTYzMBmgHJom
	 Euz3b3alAcGU1+RF/5ML0ki67mp2WaR83ze5sUOaLoolMH7dHbMa3PzVC8yMHiUwaZlfM
	 l4+TfLuFe0hXHbrCxRN8b7/kbik+Aca4q4EoCCrFNDZSyzKneRDsdvn/mRerZ8W3sxmd1
	 1x9kqJ4geimxFVEAdJhy7PrU6YpJVw/HVDtTt/R7KeOGtXsTRrtwx9ucwrcbZ7TMwkA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218657;
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
	bh=x/zyD4WwYDWrxgx61ZJ/lS4UHWapoy8DM1keKecejnE=;
	b=h2uMXxz93cbLtNS8vtZr2SBtNjsWQfntp/M0MDuBQMYNr/SX2ywPM+Oc9vjcRAXD+pDi
	 Ac8vlxi3Ovf3yDJPD77pp96yCmgo2A1cIT7ZGPQvgH9GbsUAQCDo6Er6ig2pxETnr0nNa
	 HjYKh0mLmmj5NzD5Yt10LTG+L9cOwpSrfI+s7IMu3yA6SF1Fs5nBCSzFlPE7fLJtD5DBl
	 dsXhc3uY+SzA2RDU1cTtjvSg+zVSVbdtR34+IKeXjILGyB91oK2N+Qw6zQ2x6uZx/T04s
	 FQQy0g4qKOqvBS40T4wh/zl621fHD1V7t6DABYD8YYq/o5qoJQn8/ZofI6q9MgAKomA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MAPZUqLa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.8
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010008.outbound.protection.outlook.com [52.101.56.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FA606A322;
	Mon,  9 Nov 2026 10:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E96FA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MAPZUqLa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cY2pFIapcrI4HGAw1I3dkp7wBNioyc2PdhdLPlZc1bUd2e2G6cTpMaY8Fba8wNV/+wPOXodMLq5fgMkNDzFMQ/Lk8CmsrREHFAaPPJzmwBfMhPXcF+hRyleN7okiUZECyeZrkcrPEjoYVUBzN/onZt5m347ZxbUdvdjS5bnTKrYWgY9/bz7hG4HCccTT4fnaFI0BaR61fqvB1hXw5aa2VUs17+hfwXyuNAgB5/Vfu/bydl0q9PWruIhjhfClj4oaovZX/KLz9cWOgOT6QDEoKdMlmcXyKABp5NjMJdTsYbJ40qUImmtd3wSYCxCOwIw+eYKBVvCgETB6TytWn2jxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/zyD4WwYDWrxgx61ZJ/lS4UHWapoy8DM1keKecejnE=;
 b=muC4wbdOCYfcy7CMl8/8JEGwqWqso0GGmkvn32Xex55kAvA4nVWD7gihOKeOfpatC4Z5zrbNkvycx8dKYtJm2HbxzA4y+/PqejhYO0EKm0aDbKXlgNn50nv6G2fLReZ2vkQftlHZSvZEoxuZhuvu6N8d8WrhyKrINai6g+o9DkynzVj4ADe8ms6A/dvAUqLNApd9yvfEyJYBStQ8+XL7DuQtMZe+1is3TKJOcWlUP8KvUPCv0UzUNBS5TeTxYfsKGQbv9LZ9f/8n80/9tf1PJOdakjW/MkWGmc2O3yt/NONjZS9u/Uj9OYlZn5x7oNuSro6hx5CoSAux4bNMeSxfLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/zyD4WwYDWrxgx61ZJ/lS4UHWapoy8DM1keKecejnE=;
 b=MAPZUqLaLwVc7GXzccDuly31bVKHTQjVH25reLjJOgMscEZIEr2hKKNSpI5rAAD5gqMEuS4plQxMpgQhmtvrT2Lr8Nb4AGWzvoghunhFSUKsTbSEEJMa6ZaX2pKmK+9MHBdlQ5xUNGUem57MFJxJrfgkcVC655YZhzRv5wuSjD9Q3WlTmkUkhrO6hzZXbHTGfgLA4nN1Tqr6KsZhdcA685xKRuFVJUKCyDLD+U5HlFFIUHUUuSl8ZhxWfIIf2Mfg5orMQccydtHF+DY75irxmEd/aK3jFZOvz6xALDdumGL8q+1HK+vSeK1TLDxVbHxhxlPddraO0W7NJpFyBhqNxA==
Received: from BN0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:408:e6::21)
 by SJ5PPFE4FC9FAB3.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:04:08 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:408:e6:cafe::84) by BN0PR03CA0016.outlook.office365.com
 (2603:10b6:408:e6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 10:04:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Mon, 9 Nov 2026 10:04:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:03:50 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:03:45 -0800
Message-ID: <e90e5f1a-4c33-4a1f-8aa3-01f391c1f525@nvidia.com>
Date: Mon, 9 Nov 2026 12:03:41 +0200
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
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-16-yishaih@nvidia.com>
 <179408309884.994134.17628521837326789530@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408309884.994134.17628521837326789530@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|SJ5PPFE4FC9FAB3:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c7f7997-fc43-46f4-cd0b-08df3e48cba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|22082099003|18002099003|10067099003|4143699003|5023799004|11063799006|56012099006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261021135927099003|261021121427099003|261026140227099003|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	nkeqfGha5scBQ6TAp1fL5XQdEM2y2pdhke7KL+Fe8SfejgPM4AliJ/dOdGtMnHVldB6HnkReNZ2gaihelJND/LupZfbagkREwpQBfKZPtPbG+OYI9m4wbiQbNxpLOO7UCPJLFViS24jz8FhEW2yPdbeB42DqG0sOd9DPI1sJ/4MEf16afsL6ThXEMaImcqjlgqqSc+HXftpqiQTnZYBoNn9NbcZ6OljVK8lHE5/iqZyDXDqthDgt9DaUMQ0cOGyO7Kh8sxc2pu2La+rTGFU+g9W3imeviXNHWtsJIPtl+aeYNskNUyAihNfvh5r7UbmVBAtKMEx7qmN3Hy6CPBER83OQ3+D7X20JCDbW5UMvty26bgy4Lo7oaJNxxRkzaEN5hBsswjwTr5OeINrJmXeZmVJ2m+/CgfoZl2BS4avioa94WHuFbkQ6MM2mw0lOmYVUf8TvwQe9jbbeK2oyAwXlF+gk5qeTLjScDx7+P/AJdI2136IBlENBFACXNqcKc6DYWCyNvUOKreYAVV2V9/rG0Cp0whmtr7f7Iy+ANScnmXeH+SijQMSRZqbDYaqrz41dgxY+7cHuwErS4Va7aO4ExR3dNyOOZczudtZieSBKGNziL1CQIVAU7hDzzmC1b5ZOpT4gwsPw0Oxr6ovmXzCitkhL6ajqbNTkr1rkur4f28dTIZ4ErkOlGxsMj4y7EO5rzX3zYfrgXWBoY7BE/S9tew==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(10067099003)(4143699003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021135927099003)(261021121427099003)(261026140227099003)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DUUpSc6ft15yNYpaIfRxjbh6gg4GoomtfYiwrIHF/LBwYwlL69T6GDPWN3joWGIZbOOcgC7XZy4tGzfIYIgVF62rIFJcVXc3DSS5NruJooUH5UnUxX4VnUGVrmVmCgrNCS4kJsjAqjJruzx/vQK6Wu158fb7vqyNM508IcAcYckqjz9o1wnGRDRHzCd5Cw9txWBi+G+nyqyxe0HKH7aRdx71LyzyYne0BTURsuMuld4KPzuisiU5OOMd8/k2k+K2QYeFoRAA9/FcamKXA7c/pB+yg+zGDPLtEfJSWLcgjWb9Sk1CBL+BtyizNB2g3ag6Md//3LWwSRAZPkvinWo9B+wQ2EVHipysnHau+pejjLstOn9AtAQRyoq+CnPCBglt0R+JNcAP1edjsf0P8lfsgMrNkKkXbdYHeiQCwMdXY/gumAvKFMg3l5PAvmGJ8Wg5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:04:08.3041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7f7997-fc43-46f4-cd0b-08df3e48cba0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE4FC9FAB3

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The patch relies on program order alone to publish the poll
>    context before the handler, and that ordering does not hold for…
> - [Medium] __ib_alloc_cq() (drivers/infiniband/core/cq.c) still stores
>    cq->comp_handler after dev->ops.create_cq() has returned (create_cq at…
> 
> --
> 
> RDMA/core: Set the CQ comp_handler after its poll context is set up
> 
> This commit reorders __ib_alloc_cq(). The irq_poll or work context and
> comp_wq are now initialized before cq->comp_handler is stored, and the CQ
> is armed only after the handler is set. The goal is that a completion
> event raised right after ops.create_cq() returns no longer finds an
> uninitialized poll context.
> 
>> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
>> index 12304c9a9403e..42e4d272f5ade 100644
>> --- a/drivers/infiniband/core/cq.c
>> +++ b/drivers/infiniband/core/cq.c
> 
> [ ... ]
> 
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
> [Severity: Medium]
> This store still runs after dev->ops.create_cq() has returned. By then, can
> the driver's EQ dispatch already reach the CQ while comp_handler is still
> NULL from rdma_zalloc_drv_obj()?
> 
> The driver publishes the CQN during create_cq. For example,
> mlx5_core_create_cq()->mlx5_eq_add_cq() inserts it into the radix tree,
> efa stores it in dev->cqs_xa, and mthca adds it to cq_table.
> 
> Several drivers then call the handler without a NULL check. For example,
> in drivers/infiniband/hw/mlx4/cq.c:
> 
> static void mlx4_ib_cq_comp(struct mlx4_cq *cq)
> {
> 	struct ib_cq *ibcq = &to_mibcq(cq)->ibcq;
> 	ibcq->comp_handler(ibcq, ibcq->cq_context);
> }
> 
> efa_process_comp_eqe() and mthca_cq_completion() do the same, and so does
> mlx5_ib_cq_comp() at this commit.
> 
> So an early event from a non-conforming device would now be a NULL
> function pointer call in irq or tasklet context, instead of scheduling an
> uninitialized irq_poll or work. The patch also moves the store later than
> before, past rdma_dim_init() (which can do a GFP_KERNEL allocation) and the
> whole poll context switch, so the window gets a bit longer.
> 
> The commit message says:
> 
>      A conforming device raises no event for a new,
>      empty CQ, but nothing in the core relies on that.
> 
> Doesn't the core now rely on every driver NULL-checking comp_handler?
> 
> The later commit "RDMA/mlx5: Ignore completion events for a CQ without a
> handler" adds that check to mlx5_ib_cq_comp(), which closes the window for
> mlx5. mlx4, efa and mthca still call the handler unconditionally at the end
> of the series.
> 
> __ib_create_cq() in verbs.c, and the uverbs paths, set the handler before
> calling into the driver:
> 
> 	cq->device = device;
> 	cq->comp_handler = comp_handler;
> 	...
> 	ret = device->ops.create_cq(cq, cq_attr, NULL);
> 
> Could __ib_alloc_cq() do the same? 

The handler was set after ops.create_cq() before this patch as well, and 
the CQ is armed only after it is set, so only a device that raises an 
event for a CQ that was not armed can hit this window. For mlx5, the 
only driver that supports adversarial mode, V1 ignores events for a 
kernel CQ until its first arm.

> [Severity: High]
> Is program order enough to make the poll context visible before the
> handler? The irq_poll_init() stores (memset, INIT_LIST_HEAD, weight, poll),
> INIT_WORK() and the cq->comp_wq store are all plain stores. This
> comp_handler store is plain too, with no smp_store_release() or smp_wmb().
> 
> The reader side has no acquire ordering either:
> 
> mlx5 EQ irq
>    mlx5_cq_tasklet_cb()
>      mlx5_ib_cq_comp()
>        ibcq->comp_handler()          <- plain load, indirect call
>          ib_cq_completion_softirq()
>            irq_poll_sched(&cq->iop)
>        or
>          ib_cq_completion_workqueue()
>            queue_work(cq->comp_wq, &cq->work)
> 
> An event that arrives before the CQ is armed gets no ordering from the
> doorbell write in ib_req_notify_cq().
> 
> On weakly ordered CPUs such as arm64 and POWER, can another CPU see the new
> comp_handler before the iop, work or comp_wq stores? In the workqueue
> cases, the compiler is also free to reorder the adjacent plain stores to
> comp_wq and comp_handler.
> 
> If that happens, three things could go wrong:
> 
> - The reader schedules an iop whose memset and INIT_LIST_HEAD land after
>    its own test_and_set_bit() and list_add_tail(). That corrupts the per-cpu
>    irq_poll list.
> - irq_poll_softirq() calls a stale NULL iop->poll.
> - queue_work() is called with a NULL workqueue.
> 
> These are the failures the commit message describes.
> 
> Adversarial mode is enabled through cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
> That is true for arm64 realm/pKVM guests and pseries secure guests. The mlx5
> UMR CQ allocated in mlx5r_umr_resource_init() with IB_POLL_SOFTIRQ goes
> through this path. The plain NULL check that the later commit adds to
> mlx5_ib_cq_comp() does not provide acquire ordering.
> 
> Would this need smp_store_release() on comp_handler, paired with an acquire
> load in the drivers? The other option is to do all of this setup before
> ops.create_cq(). 

Yes, with a hostile NIC. V1 will fix it in mlx5, as only mlx5 supports 
adversarial mode: a kernel CQ will ignore events until its first arm, 
using a release/acquire pair.

Yishai
