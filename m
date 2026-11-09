Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794218977;
	b=5QYvNcIivTwnvU5Nap8/z05ODgoV9iwVsu56rbUiY2FHYZaqBeTlmCghrWdtGDZgFAQ7
	 DU+JpMIt32hkBPUITR1fMi0Er89tkLcTJcTamnwJgo2DQ92H8oROf5WlwJesedV8b+eIh
	 oJ229pF84MjsNPB/DJMplVrkSVy1U5NngJflvdHUQxPSmUNRpTBPZwYrLKzroYerWHSAT
	 H5DIjqz+7L+V16TxNLKqfGmBcASQPzLHvl2e+GYqSJtKTyuTVQJsFfSvCVbkLRknxItSL
	 pKjlLErxEKd3J8GdTFp2KrXzho44vndzhuVVKmu9QMjhDICGsfaTN1MRRSFWQotEBrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218977;
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
	bh=VV4KsSBphAaiH2NWOLiWOtymQT0+VFehqzQ3XjqSMf8=;
	b=T8jmuI15DOM0FTvvFY/mnNXC9VaTlvfB7jNLUDcKXspOSBRgy/Rx5apUIT0H9U1x0pxw
	 YAbs9mCZFGZOTcwmbVEWdpZgXfGXkx2qF7IeWvayyPnattSdI1Aht02e/nvCA4ajfETcK
	 uVFDMu7lEtZOBfLLBMe3QRMfTGnCN+w9U1LbwrJiPKyZSC2ev8n58ggolTJr+LE3eIIOi
	 XCk1WdUp3GvKo+GyBF8QK/W0ormZGkO03XOv4hHZN5SzCuUjM5+EEyjRJtblfWqnahNqF
	 oQPhp11dWarQV4PExlGZWgMvB1CEOp9qbaQRY4HVffG3L6tUCwgT/dKBP9fWHgRFyWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KLpD48y1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.40
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE4606A31C;
	Mon,  9 Nov 2026 10:09:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68DE4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KLpD48y1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxqdFTrdKsrQlfMfDvWHXXnXhR3FeBhzGZqNZUiZH4bdONe8yz0Jd5jqBtQT+xJDRPKY2DwwrEpb9hoD7ciJ5/ZjrwBhG/wQn2bPK8J+9pEoQY7PlFhAtQa8hk0vqEHMBux0Fu8dcHRylt+TabIgtWsTvwQTjzrkLmaF33qjL6cwXXzZXxrQ6ZQP+nYec8yJcphSdYjvgIk57JJ/OaWlQ5f7InLXx1p9fYuk8iSx7uls4y5Gg35aDtruu4Fq9IUbfofGVdNdnF84iiDhg8obKu0KPbjeABGFNaIwDAg2QffRt82OF1vmSIZl5JTQiHnwuiUBu/uVC2xhHaoVQvokow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VV4KsSBphAaiH2NWOLiWOtymQT0+VFehqzQ3XjqSMf8=;
 b=RVNpg/BvxKbKQR/VXfcJj05cnTO//HcDI8LNe9vXo5YlHQJ87VgS5vnQB2SyedJv3hwatz6Cv8fCTZIu5w43FoYvSEOg7X87nRQPdE+6FjMZ1QxdB8qdyGuRPbnZCQXah2Hrxxvzs5ac3OWqUcGAPzL6jyndFJKXpP9uMu2kd1WsXdNFXNxS9CIXuS6vBBhlxmu6djz25CfYGoaGiPUVm5OdJxJMK7ahiGz4kqKFznUmWcXnmy/ZRzMfCEdNe4KrWqBP3hUcU0v6A030HvJQqwDSZY9XRV8ZGJowFwdiy4ZY2Ig4meFLPDodWc+M/GjLw2tJZwT+YyzA18UfW8adLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VV4KsSBphAaiH2NWOLiWOtymQT0+VFehqzQ3XjqSMf8=;
 b=KLpD48y1nugaGstgmzggJoYioYclOPSXXrnvjvjN1FZK5J8kBrMcA6XXncl7keHmVxSWFPx96rl0TO+XI5iebT5+EfkjwaVET1WIfRsEKG1LF7/+/optQEUcGlQiIhJmEhqU+Fr1dW0qfW/EgqLhyCxH7WZ9TuvnAZtm9xzkaM+vxAvsTFahiayDB8YssWaB/HTbnLQaC7qgTaPwYiBZoC8jPTU2thLN94hWWtdofmPkgw1z95ycrzGQg14iyaZxigV8USP+ssfYS46744N+lk0Oind+wdAGg8FugWIfzo+uKL/tMFM6D4jFnCrwHZlcLCrv2/w3NO4m9qzL5eM9HA==
Received: from BN0PR04CA0088.namprd04.prod.outlook.com (2603:10b6:408:ea::33)
 by CY8PR12MB8266.namprd12.prod.outlook.com (2603:10b6:930:79::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:09:28 +0000
Received: from BN3PEPF00022BBB.namprd04.prod.outlook.com
 (2603:10b6:408:ea:cafe::28) by BN0PR04CA0088.outlook.office365.com
 (2603:10b6:408:ea::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 10:09:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF00022BBB.mail.protection.outlook.com (10.167.248.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:09:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:09:08 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:09:04 -0800
Message-ID: <a15e59e8-fbfc-430e-a848-79759616287a@nvidia.com>
Date: Mon, 9 Nov 2026 12:09:00 +0200
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
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-17-yishaih@nvidia.com>
 <179408310019.994134.8139150984682840933@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310019.994134.8139150984682840933@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBB:EE_|CY8PR12MB8266:EE_
X-MS-Office365-Filtering-Correlation-Id: e6dc7fed-9fba-4834-12f1-08df3e4989fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|22082099003|18002099003|10067099003|4143699003|11063799006|261028144727099003|261102123227099003|261022105027099003|261021123027099003|56012099006|261021135927099003|261021121427099003|261026140227099003|261026121527099003|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	aE9KYtcUztBcgY79fk1DlsKcToHtij8Vganp1INYoivGoLjJRL2/PxkryRNpg/dsH/EU6IRkPZYcOGftgP/1SpV6ai+LrgGtUpdB2K2wdI0itxIHqBVJBc4BUn5hAoRRZY1pM5vTTT9ulHrG0beaKSyKRQa+3yT8YvPT09GEgAm2slh8KeM44MPRQdLe2ApWB0Id/T1cpVkEdXdsqDViSJAgP+xHhb6PncVzQ8qLxOufpOtjYHbxltfYcqGhk1S7+ymNP0J9agr/hmbD9DFpFnWSfg8ffUaKT2ym/AO/vteW+2k3PRT+8RXk9CBckvzBw+WaJjEHMym1bKjFwxkJJOIZhdQDaMUROa01gsKq8gTt551fltCZmjDMi4AsTftjXMStta6oSfZiLWxfDC2QZc+nxE8fsjp4MuK4U9w6fWNoNgQX+9D7ZEh47auPqWct25cmhMKODrdeqmar1iOXEH/J/a6AubDjOpW9EFeDvNDVOr9+CRgAa/G4UIMjrRq7iH5VfHHLhsEq6/GKAK5IpZJpzgxUcj9X22DowETfzIGDUVs4O2vVZTlrG1CDxL3E8Q0Ul2uFTtZDKTnvantxKTaDSjERkq1J5AvvPxpMXyEpNyQCVvOG0IgFBZD+mBUMch1Hjs71YCWER+ZT0t2o9t5S+PXwXIf0S8NKlzdktuQ/v2vchr2O+Vsdnh62C9HC0cApDZcgjFonAnSGXTwwtQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261021123027099003)(56012099006)(261021135927099003)(261021121427099003)(261026140227099003)(261026121527099003)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ODkd3xrhMX2HUDlBq5Zk0VmQVsOWFYW1fPNPWVNYgGR4g0CxtVGJSyti3cbPzN9z44ZE0jSBuy+2W4kPhahEMz/A/lJeAU+SUEX7W+Hum86+wqC4MgCr1uc5q/ulXVGWqGrAVldlJMgSqz09G0JUrzzsKRF7Kn5tRDiaDh3oaH3r4bCsbqQja/21NBhaN0KPrGL2vLXpet5Xdnv8XTehGq+ZhLNc7JwUWzLPVE0w/4QIjIdJZk87K0lb/ZrRLV8q0kSJkt/70BoOzQhcGXW8IBfHDeQc72Cat2xpeTGSFMlnw2qtT6ee8nOOBhKmpzPTEeMmxO74F0fpTtUTybbq48Dhoqw5dNSnIMLCahRpnTEMh4IV8tSBMlBeof89jk6aZvcuP98yVZR3fCKxlmz/EBg9uJYk2/PzgN4KA69G8pCocQ8QcMI8fgv2L7fgcyAk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:09:27.6767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6dc7fed-9fba-4834-12f1-08df3e4989fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8266

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
> - [High] The fix leaves a memory-ordering race on comp_handler.
> 
> --
> 
> RDMA/mlx5: Ignore completion events for a CQ without a handler
> 
> This patch makes mlx5_ib_cq_comp() skip the comp_handler call when no
> handler is set. The case it targets is devr->c0, which is never armed, but
> a hostile NIC in adversarial mode can still raise a completion event for
> it.
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
> For devr->c0 this check is enough, because comp_handler stays NULL for
> that CQ. Is it also enough for the CQs set up by __ib_alloc_cq()?
> 
> The companion commit "RDMA/core: Set the CQ comp_handler after its poll
> context is set up" relies on this NULL check as a "poll context ready"
> gate. Neither side of that gate has any ordering, though.
> 
> On the writer side, the CQ can be reached from the EQ interrupt once
> create_cq() puts it in eq->cq_table.tree. The handler is published later
> with a plain store:
> 
> drivers/infiniband/core/cq.c:__ib_alloc_cq() {
>      ...
> 	ret = dev->ops.create_cq(cq, &cq_attr, NULL);
>      ...
> 	case IB_POLL_SOFTIRQ:
> 		comp_handler = ib_cq_completion_softirq;
> 		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> 		break;
> 	case IB_POLL_WORKQUEUE:
> 	case IB_POLL_UNBOUND_WORKQUEUE:
> 		comp_handler = ib_cq_completion_workqueue;
> 		INIT_WORK(&cq->work, ib_cq_poll_work);
> 		cq->comp_wq = ...
>      ...
> 	cq->comp_handler = comp_handler;
>      ...
> }
> 
> On the reader side, mlx5_eq_comp_int() gets the CQ with mlx5_eq_cq_get(),
> which is an RCU radix_tree_lookup() plus a refcount increment. That orders
> against the tree insertion, but not against the stores made after it.
> mlx5_ib_cq_comp() then loads comp_handler twice with plain loads.
> 
> Adversarial mode is enabled when cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)
> is true. That includes arm64 Realm and pKVM guests, and those CPUs are
> weakly ordered. Take the UMR CQ, which mlx5r_umr_resource_init() allocates
> with IB_POLL_SOFTIRQ.
> 
> Could another CPU see comp_handler == ib_cq_completion_softirq before the
> memset(), INIT_LIST_HEAD(), weight and poll stores from irq_poll_init()
> are visible? If so, irq_poll_sched() would link iop onto the per-CPU list.
> The delayed irq_poll_init() stores could then overwrite iop->state and
> iop->list while iop is still on that list.
> 
> Possible results are per-CPU list corruption, irq_poll_softirq() spinning
> on a stale entry, or a NULL iop->poll call. For the workqueue cases, the
> compiler is also free to move the plain comp_handler store ahead of the
> INIT_WORK() and cq->comp_wq stores. That could lead to queue_work() with a
> NULL workqueue or an uninitialized work item.
> 
> The wmb() in the later ib_req_notify_cq() only helps if the device waits
> for the arm doorbell, and a hostile device does not wait.
> 
> Would it make sense to publish the handler with:
> 
> 	smp_store_release(&cq->comp_handler, comp_handler);
> 
> in __ib_alloc_cq(), and read it once in mlx5_ib_cq_comp() with:
> 
> 	ib_comp_handler h = smp_load_acquire(&ibcq->comp_handler);
> 
> 	if (h)
> 		h(ibcq, ibcq->cq_context);
> 
> That also removes the double fetch. KCSAN would likely report the current
> plain check against the plain store as a data race. Later patches in the
> series do not change this code.
> 
>>   }
>>   
>>   static void mlx5_ib_cq_event(struct mlx5_core_cq *mcq, enum mlx5_event type)
> 

The race needs a hostile NIC, as a conforming device raises an event 
only after the CQ is armed. V1 will fix it in mlx5, as only mlx5 
supports adversarial mode: a kernel CQ will ignore events until its 
first arm, using a release/acquire pair. This also covers devr->c0, 
which is never armed.

Yishai
