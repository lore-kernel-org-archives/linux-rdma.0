Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794212901;
	b=WPpPQSKQcOm5G9T2uf6d3oMPs9l1K185lP/iVQdlZe9tUqodd7KQ9HzA/nOpH2E9MnSk
	 i9kw5fuYjMDvk+k2oTCqUxxxxDjBIjKMUFw9osG6NOw259EN31TVxJ7DIvkKutAdTr366
	 tgdd3lfvVdm4Jl9n58sNIawipoUHRCBclS51EQLDhZWtYR+1GQGtkLYXZWy21GjyMiDgZ
	 DwcN0nhTQQ1T3nbxPdG8VhL+71c71lE32EZtWkProUuA3HI0MASuBm3yT0H/I9I0qZFrw
	 lVuZCoaBwwSG0t5ozfMk//uqxwtx0QL1L3Us2lf1bFrWF43YRHeBnDcqYMLJD5gZagw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212901;
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
	bh=F3ItkgNwfdZy468TY8vSKSMrv0iO0nS74uGiIO4H8dU=;
	b=YqQVWQdMKw+hzmWsqvW3oYLPvOunp6xqGpImE6oko96YLWyjRm8PjJAtfRL4SYMxQNiJ
	 0XPvK1Z6g/Vv1eEmncSBNpFmXNvZUu+Bt7Mq7uGIIigyLDCY9MQkUUMlmKe/CB8Hmvkog
	 u7jok/Rww93li6maogZ2tEIN1C08cLp/06Mj8kNvH00JPpMWuMNkY1hpgdSp0W005MaH4
	 AW+oPThTqvcnTTPzdGMkwV7ndwrZGoTFRNSrv2BKOm0ZIhY7qHCfTasBJPOcywytWeC2P
	 wJUg5LGHsp6aUJOYNQFumWl/odGrTOTkuNZNbxWlGT5tvm7sBGvWvxZkOK0hvrOutdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CBXqr1CH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.11
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010011.outbound.protection.outlook.com [52.101.61.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E333606A321;
	Mon,  9 Nov 2026 08:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E333606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CBXqr1CH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OFZMSCnC+7gsjNGVX/bM7Bs+/AFItkYzb/Z4XUoFjMLQd36FYZPRd4lfL7D+Ij4OKin5NcuRV5c1qUBu6VM6nwboyVh5OuUG0CCEbsbKTzBi1v0WAtszCZZDVM7v0WgyXdwCOA4FaCxgQ198+jBg5oePS/uAykjy9Nl733uReZKfI53JNWExpWG8Oq61H5e6OcDI2o1ykXDONg80sPsasSkwcJT+W5fgtE9mV/C7b61+KyJPn2qQkkrDkfr0eQFp1RfPJBi48uTGhNd53mYN1Mu0RYrDL4LpV+KzGpeaYuwBTFAiT9ykTbrO7T3iedue+ewMI+2PP4UnvDbG5uoXRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3ItkgNwfdZy468TY8vSKSMrv0iO0nS74uGiIO4H8dU=;
 b=ad2/sImtYGkTygGg8CeY7Yv8lX4yU4hsB4vvk4pnoqCG1F/8PKB3BsYi8+Um/EL98Zi06seg6Pt2W6qgR8ve5eP13NlOwq3R5iSBg+rbIs/P3sY/l5x4mmmDyIW5zvyS5SMiikYLH8+1t7HuVqnMnOAVK3sYKaznueMDI+J82VAKYWNkOQ+xEiVD7hyyCffxRMqaHnEBPWGIoxJlo7xZjd1v2wHapGY2rmK8s5FMSqaqPsocsv7niuKZnliQNViykEWn4KZ2FWD7rUFa0KNRexzQzi8V6e4opm7UUCA/ifdtRzLWlL8Khl4s7ixlzmQYFQYAh9dl3fkXPzDe1t6Yrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3ItkgNwfdZy468TY8vSKSMrv0iO0nS74uGiIO4H8dU=;
 b=CBXqr1CHBMw0X00n9UTE0pgpUv7sx/Z/QDwSE5Tg9dEChiZx/xIMTs8PALC5QI7+IsSg9bOPZcSP/8hDLM3YjlWdm/531NYqRn7ALYJZZPhQSULO5hSgCt+bD3NqgxmnW1X3uNySBEWl6H3ix+xFu0LyzEv56N7Pr9MSMTdV5yrNOheBs3xGhPADDjlZaCyMDNFvqGYRFfLR5kazfF9RXLillmhRlFADyaQgnmUvrB/7aBgS2N2hVs3aA9FA0yDOwCCzcXvPRDJuNOTl+c1TqrCyfXymtIoJ2Yex9qNoqk/qKYh+ScKCPLqKKiPI4FfMfCSgB5OQ3iX0F5zf9dRBpQ==
Received: from BN1PR13CA0017.namprd13.prod.outlook.com (2603:10b6:408:e2::22)
 by MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 9 Nov
 2026 08:28:08 +0000
Received: from BN1PEPF0001854B.namprd05.prod.outlook.com
 (2603:10b6:408:e2:cafe::3d) by BN1PR13CA0017.outlook.office365.com
 (2603:10b6:408:e2::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.7 via Frontend Transport; Mon, 9
 Nov 2026 08:28:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0001854B.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 08:28:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:27:30 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 00:27:25 -0800
Message-ID: <02149fa6-3ded-4a32-a0fe-986c5c35e8bd@nvidia.com>
Date: Mon, 9 Nov 2026 10:27:23 +0200
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
Subject: Re: [PATCH rdma-next 03/23] net/mlx5: Add capability filtering in
 adversarial mode
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-4-yishaih@nvidia.com>
 <179408308320.994134.5973332884050170035@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408308320.994134.5973332884050170035@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854B:EE_|MN2PR12MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d91639-4f9b-4225-a889-08df3e3b6240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|1800799024|36860700016|261022105027099003|261021135927099003|261022113327099003|261021133027099003|261026135527099003|261021123027099003|260925022911599003|260925021911599003|261026140227099003|261021121427099003|260925021311599003|261022075727099003|56012099006|261022115727099003|261026130827099003|4143699003|5023799004|11063799006|261026121527099003|261021130227099003|261009223027099003|261028144727099003|6133799003|10067099003|22082099003|261102123227099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	FXcjKZvEWEnsYLFNG/lxYTI/yUXpMzx06WG85u/L2XZAtLejBm3K9JaPfBk/ETVF059af+/IeLZmI1owsUPxxqMfw2Lc90X/9Ne5QejtjOfLpK3LFJecIl0cQcUmnYzkO//ei/4RHf87l+UCcGV1mmOMcM8BpjTZP2LOdmBmcDQGZ3S5NcOB7iB8bMO5SVY2ssm3q5PfDl4Zk9w5SITEQ3HTrtCtzROTHD+2mtlvcb/go4wEXK4Dno2HSusOCx8oGZ0ZKa3hMLrPRh2SixM3ESEbzKHpzyLEWezQVh3LEQuXPutLOT3AOg3ZyZ2uvfZ33nMO1RDNB1oqpZ6uhRIuZB1tzMgM3T++MOWfrQp/tzhNtYue0R0iBlwqjG+zIzMqVym62LQ/FXKxm7+B8/aT4i3wz6pMmDqNxQO+EAk2v13Q+p+pfB1py5yImStL8zjCVPdTubEh2lFa2BKTr8P60XI7eXxL+We+Mtdid7ac/FFzwhdeEuQ9Ent13J9jZ+5CwgtXl8SbvibzgRQKvQyrxs9A6uzmKauunrnnfeB+EU/vVyt0B58+6zELQI2/v2C7AFfeW9XeQfar0fIS/0Jri4HRhsMuRhEroEc4b8Qucd3KDYmgSwllaBtYSwzZapp8QwNmFB6glT0BonMaTMvVcbVUD5UF7niK6i3tqAsSbjqh4OyvNTcniky74yOYeXjwxvSwCJtilJS94c0VUjv5fQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(1800799024)(36860700016)(261022105027099003)(261021135927099003)(261022113327099003)(261021133027099003)(261026135527099003)(261021123027099003)(260925022911599003)(260925021911599003)(261026140227099003)(261021121427099003)(260925021311599003)(261022075727099003)(56012099006)(261022115727099003)(261026130827099003)(4143699003)(5023799004)(11063799006)(261026121527099003)(261021130227099003)(261009223027099003)(261028144727099003)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wghLEWWSu3SM8Ck9kqYuaU1uNUZ5Y9Tk9VxrQej6RWYk0j+DML2p2EoHI9tZCKk6EnQqxWwRjs3dB9P62EFl5twhDN7ImOZoxpFnvKDNXyEvP5nHAtJHnHpBnhlL8k9VKKBpqj/2bi8PE1Szuihrp1oMeDFOlGKgIxV07Dvmrw2FBmU3cnRmicp+F//sht/dfEO9Mxie3DY+xz9vFxd9/N/kmYiH2HfKUmWM429MKlrviMUKm6yv+P46wX2feJ5bJdsnOYD5UZyXEF8vFU3te9sGGID8fOnmKVAZdQTrC94Qkak/DmpOxfb/+aljHipEH2bj2hWdc2jRbD5sM9rj2iHj98Sjlhv3BvuV6OlJ7FRdwVNV88tHmdIn7ztGscPv/e0cNkB1Cb5b0fXW/Cg6XVL0n7BDdKGewfWYTIn70oh5OBEdd5Ge4wDOZX9EbTur
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 08:28:08.0595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d91639-4f9b-4225-a889-08df3e3b6240
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 3 · Medium: 3 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The adversarial-mode filter copies cmd_hca_cap.max_tc from
>    firmware with MLX5_HCA_CAP_ALLOW and never clamps or checks it…
> - [High] net/mlx5: unchecked minimum EQ caps cause divide-by-zero in
>    alloc_cpu_rmap()
> - [High] net/mlx5: unclamped log_max_flow_counter_bulk causes OOB heap
>    read
> - [Medium] The commit message says the patch will "trust only a subset of
>    capabilities" and will "Start off by clearing all firmware…
> - [Medium] In adversarial mode, dev->caps.hca[MLX5_CAP_GENERAL]->cur no
>    longer reflects firmware's current configuration: -…
> - [Medium] mlx5_adversarial_filter_general_2() checks
>    log_min_mkey_entity_size only against (max_mkey_log_entity_size_mtt ?:…
> - [Low] The num_ports clamp uses the literal 8 as its upper bound, and
>    the comment says the bound comes from MLX5_MAX_PORTS (`/* 0 is…
> 
> --
> 
> net/mlx5: Add capability filtering in adversarial mode
> 
> This adds mlx5_store_caps(). In adversarial mode it replaces the raw
> memcpy of firmware HCA capabilities with per-field allow-list filtering
> for the general, general_2 and ethernet offload capability types. A few
> numeric capabilities are clamped or range-checked, and a failed check
> aborts driver load. The remaining capability types are either passed
> through whole or zeroed.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> new file mode 100644
>> index 0000000000000..67b2603397450
>> --- /dev/null
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/caps_filter.c
>> @@ -0,0 +1,381 @@
> 
> [ ... ]
> 
>> +static int mlx5_adversarial_filter_general(struct mlx5_core_dev *dev, void *dst,
>> +					   void *src)
>> +{
> 
> [ ... ]
> 
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, port_type);
>> +	/* 0 is invalid, 8 is for MLX5_MAX_PORTS */
>> +	MLX5_HCA_CAP_CLAMP(cmd_hca_cap, num_ports, 1, 8);
> 
> [Severity: Low]
> This isn't a bug, but the comment says the bound comes from MLX5_MAX_PORTS.
> Could the clamp use MLX5_MAX_PORTS directly instead of the literal 8? The
> two values agree today.
> 
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, log_max_msg);
>> +	MLX5_HCA_CAP_ALLOW(cmd_hca_cap, max_tc);
> 
> [Severity: High]
> Should max_tc be clamped or checked here too? It is a 4 bit field, so
> firmware can report up to 15. mlx5_max_tc() turns it into a loop bound:
> 
> drivers/net/ethernet/mellanox/mlx5/core/port.c:mlx5_max_tc() {
> 	u8 num_tc = MLX5_CAP_GEN(mdev, max_tc) ? : 8;
> 
> 	return num_tc - 1;
> }
> 
> That can return up to 14, but the callers assume at most 7 and use it to
> index 8-entry arrays.
> 
> This path runs at netdev init with no user action. It is gated only by
> the qos and ets caps, and both are allow-listed above:
> 

This capability is not used by RDMA.
Currently, netdev doesn't handle adversarial flows.


> [ ... ]
> 
>> +static int mlx5_adversarial_filter_general_2(struct mlx5_core_dev *dev, void *dst,
>> +					     void *src)
>> +{
> 
> [ ... ]
> 
>> +	val = MLX5_GET(cmd_hca_cap_2, dst, max_mkey_log_entity_size_mtt) ?: 31;
>> +	err = MLX5_HCA_CAP_CHECK(cmd_hca_cap_2, log_min_mkey_entity_size, 0,
>> +				 val);
>> +	if (err)
>> +		return err;
>> +
>> +	/* The fixed buffer min is don't-care when its valid bit is clear. */
>> +	if (!MLX5_GET(cmd_hca_cap_2, dst,
>> +		      min_mkey_log_entity_size_fixed_buffer_valid))
>> +		return 0;
> 
> [Severity: Medium]
> log_min_mkey_entity_size is only compared against the MTT max here. Is
> that enough for the code that consumes it?
> 
> In mlx5_ib, get_min_log_entity_size_cap() uses log_min_mkey_entity_size
> as the KSM minimum exactly when the fixed buffer valid bit is clear. The
> KSM maximum comes from max_mkey_log_entity_size_fixed_buffer. This
> combination passes the filter:
> 
>    max_mkey_log_entity_size_mtt = 0
>    log_min_mkey_entity_size = 20
>    max_mkey_log_entity_size_fixed_buffer = 12
>    min_mkey_log_entity_size_fixed_buffer_valid = 0
> 
> mlx5_umem_mkc_find_best_pgsz() then builds GENMASK_ULL(12, 20). That mask
> is empty, so KSM mkey registration fails.
> 
> There is a second case. The filter accepts log_min_mkey_entity_size up to
> 31, and mlx5e_mpwrq_min_page_shift() uses it directly. For a regular RQ,
> mlx5e_mpwrq_page_shift() hits this whenever the value is above PAGE_SHIFT:
> 
> 	if (WARN_ON_ONCE(!xsk && req_page_shift < min_page_shift))
> 
> Should the filter also bound log_min_mkey_entity_size by
> max_mkey_log_entity_size_fixed_buffer and by PAGE_SHIFT?
> 

The PAGE_SHIFT bound will be added in V1. The KSM case only makes the 
registration fail.

> [ ... ]
> 
>> +	switch (cap_type) {
>> +	case MLX5_CAP_GENERAL:
>> +		return mlx5_adversarial_filter_general(dev, dst, src);
>> +	case MLX5_CAP_GENERAL_2:
>> +		return mlx5_adversarial_filter_general_2(dev, dst, src);
>> +	case MLX5_CAP_ETHERNET_OFFLOADS:
>> +		return mlx5_adversarial_filter_per_protocol(dev, dst, src);
>> +
>> +	case MLX5_CAP_ATOMIC:
>> +	case MLX5_CAP_ROCE:
>> +	case MLX5_CAP_FLOW_TABLE:
>> +	case MLX5_CAP_DEV_EVENT:
>> +		memcpy(dst, src, MLX5_UN_SZ_BYTES(hca_cap_union));
>> +		break;
> 
> [Severity: Medium]
> The commit message says:
> 
>    When in adversarial mode, trust only a subset of capabilities
>    and do some additional validations.
> 
>    Start off by clearing all firmware capabilities and enabling
>    them one by one.
> 
> Is the whole-structure pass-through for MLX5_CAP_ATOMIC, MLX5_CAP_ROCE,
> MLX5_CAP_FLOW_TABLE and MLX5_CAP_DEV_EVENT intended? MLX5_CAP_FLOW_TABLE
> in particular carries numeric limits that the steering code relies on.
> 
> There is a related case. mlx5_adversarial_filter_general() allow-lists
> sbcam_reg, qcam_reg, mcam_reg and pcam_reg. In mlx5_query_hca_caps() those
> bits gate mlx5_get_pcam_reg(), mlx5_get_mcam_access_reg_group() and
> mlx5_get_qcam_reg(). These store firmware data straight into
> dev->caps.pcam, dev->caps.mcam and dev->caps.qcam without going through
> mlx5_store_caps().
> 
> If this is deliberate, could the commit message say which capability
> areas are still trusted wholesale?

Yes, it is deliberate. This series filters the caps that the RDMA paths 
use as sizes and limits.

> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> index f9e10464a71b5..e76a4486b5a31 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> @@ -325,12 +325,12 @@ int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_ty
>>   
>>   	switch (cap_mode) {
>>   	case HCA_CAP_OPMOD_GET_MAX:
>> -		memcpy(dev->caps.hca[cap_type]->max, hca_caps,
>> -		       MLX5_UN_SZ_BYTES(hca_cap_union));
>> +		err = mlx5_store_caps(dev, cap_type,
>> +				      dev->caps.hca[cap_type]->max, hca_caps);
>>   		break;
>>   	case HCA_CAP_OPMOD_GET_CUR:
>> -		memcpy(dev->caps.hca[cap_type]->cur, hca_caps,
>> -		       MLX5_UN_SZ_BYTES(hca_cap_union));
>> +		err = mlx5_store_caps(dev, cap_type,
>> +				      dev->caps.hca[cap_type]->cur, hca_caps);
>>   		break;
> 
> [Severity: Medium]
> In adversarial mode, dev->caps.hca[MLX5_CAP_GENERAL]->cur now holds the
> filtered image:
> 
> - it is zeroed, and only allow-listed fields are copied back
> - num_of_uars_per_page is forced
> - num_ports, num_lag_ports, num_vhca_ports and log_max_rqt_size are
>    clamped
> 
> handle_hca_cap() still uses ->cur as the template for SET_HCA_CAP:
> 
> drivers/net/ethernet/mellanox/mlx5/core/main.c:handle_hca_cap() {
>      ...
> 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
> 				   capability);
> 	memcpy(set_hca_cap, dev->caps.hca[MLX5_CAP_GENERAL]->cur,
> 	       MLX5_ST_SZ_BYTES(cmd_hca_cap));
>      ...
> }
> 
> It then writes the whole structure back with set_caps().
> 
> Does this program every firmware-writable field to 0 if it is not on the
> allow-list and handle_hca_cap() does not set it explicitly? Are the forced
> and clamped values also written back to the device?
> 
> If so, adversarial mode changes the device configuration, not only what
> the driver trusts, and the commit message doesn't mention it. Is that
> intended, or should handle_hca_cap() start from the unfiltered firmware
> values?

Right, in adversarial mode SET_HCA_CAP starts from the filtered values.
The default mode is not affected.

> [Severity: High]
> Should log_max_flow_counter_bulk be clamped like log_max_rqt_size?
> It is an 8 bit field, so firmware can report up to 255.

This capability is not used by RDMA. Currently, netdev doesn't handle 
adversarial flows.

> [Severity: High]
> Should the EQ count be range checked as well? log_max_eq and
> max_num_eqs are allow-listed here, and max_num_eqs_24b is allow-listed
> in mlx5_adversarial_filter_general_2(). Nothing makes sure the device
> reports more EQs than the driver reserves for async EQs.
> 
> mlx5_max_eq_cap_get() returns max_num_eqs_24b if it is set, otherwise
> max_num_eqs, otherwise 1 << log_max_eq. get_num_eqs() then takes the
> minimum of two values:
> 
> - the IRQ table's completion vector count
> - max_dev_eqs - MLX5_MAX_ASYNC_EQS
> 
> MLX5_MAX_ASYNC_EQS is 3 or 4, depending on
> CONFIG_INFINIBAND_ON_DEMAND_PAGING.
> 
> Suppose firmware reports exactly MLX5_MAX_ASYNC_EQS, for example
> max_num_eqs = 4 with ODP enabled. Then eq_table->max_comp_eqs becomes
> 0, and probe continues into:
> 
> mlx5_load()
>    mlx5_eq_table_create()
>      alloc_rmap()
>        alloc_irq_cpu_rmap(eq_table->max_comp_eqs)
>          alloc_cpu_rmap(0, GFP_KERNEL)
> 
> alloc_cpu_rmap() fills the near[] table with:
> 
> 	rmap->near[cpu].index = cpu % size;
> 
> Doesn't that divide by zero during driver load? This path is taken
> with CONFIG_RFS_ACCEL on non-SF devices and needs no user action.
> 
> If firmware reports fewer EQs than MLX5_MAX_ASYNC_EQS, max_comp_eqs
> goes negative instead. alloc_cpu_rmap() rejects that value as too
> large. But when the rmap is not allocated, what do
> mlx5_comp_vectors_max() and the completion EQ code make of a negative
> count?
> 
> With trusted firmware this predates the patch. The three fields come
> from two different cap types, so one MLX5_HCA_CAP_CHECK() in a single
> filter function can't cover them all. Would it be simpler to reject
> max_dev_eqs <= MLX5_MAX_ASYNC_EQS in get_num_eqs() or
> mlx5_eq_table_create()? Or is there a good place in the filter for
> this check?
> 

OK, it will be fixed as part of V1.

Yishai
