Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=40.93.195.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794151480;
	b=4qL16eu3t0SM4HwrzEN39bOgOYz3S8Su0si1+EtkWIYg9obH56tuiYNOdXlxkh5gFuM0
	 khVxFn4dSeY89een6s2TFf3Te/IkncfBJdaml6V8NTCnGXgi82VzHmOha8Vp40EJF1VII
	 WWyVcn8eVa1yEGPL9di9pgrJ47JAYCD/mfarBA+5ZtfILZHMHl3XcqPf/230bAKneUkgD
	 pPqzlb/1gHK9q+3foko55P3umlTEveNUjlQayzyru2PbY8/g8jB81+//C8kxDBGPI2dBS
	 H7Wr9jJC7lAllgXKzRwZEMBF81La3afT0RAXe8ve1EGbZAQDr8v5n//Ilaf3QQhek/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794151480;
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
	bh=eOdiydIvOgccWMDzeIq8H8p2djzQZYfpLV3wc0+6i5M=;
	b=eaqBlsYeB6eAd6icyP4rgj0djzUqapQ5zkV/+bRnKZS/xn4ZgyAJ+GMzaEyeoUWBXIBT
	 kA52PuLX8dxfj5D4S4XxZpV3RVuWWfJsKP2IW0AkGJUwnrc/nn1nPGJg6KnobmjFhVcTf
	 5DGREzd4Lq7MYDcddhj2fHBMTo9xMzkS9bR1YCgHHRD7I54k3fH9EFCZSYnJ8RtuoFT7K
	 htsI4cZnFEOS3tv4h4u99bg4ygWbelPgXWEEmIuKxe6FfEh/b4p/Z9ztx/xspGXsC5oJZ
	 tjNdbwDw189a5BGUNm17qXUKp6PUO3JSHoj1fgA1EoWoEDDeoS19tkTOwJi6I5Taiqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fwi2r5vk;
	arc=fail smtp.remote-ip=40.93.195.65
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8364D606A320
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 15:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8364D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fwi2r5vk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk+cdAyZaxyiyHRwzL484MkWRpflt3+8YhU+tEqac8J97gfSv2RNCYhXAfr5UiseFhEyAqECz5LMyF2T7EUoTDvnvkmBuTNpbYcPPLodOmcWkM/kljEcQvk7pkfBhMnW8kU2A9pJwBwXfCmYQ7+kI29nJs/KP8R4Gm/CLV8sFEqB9iIfPurfBN+tPIdNKbYxLoVvKhnKzOr91c8VNZ/Rnt2AnJnYzhdcYO7+/IvGMGpW+jsyORHef1+PORZ4aDpXvXd6u4yN2Dmn9ytWAx0N015aCQpfYyqimvP5S9LncX6yCLkvGtSIvUXbBQiRqkJjnxo04J7QsY8g6HCf5CAB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOdiydIvOgccWMDzeIq8H8p2djzQZYfpLV3wc0+6i5M=;
 b=Jux9hf1L0ZHHJzcQUkTxPgl9Mmamkiv82zLDFzYR24qFYeSy0Bxua/g9dre0ACYzkpWTNW9yP2TWvBm8r1Js4X0tL/GyDyJMji670qCN4AHw7j+yL3ORs2EejU9hRRgSCO/Px9i60FPJZvswt2DA93BUlf8VR0lB3ppOVSXd9ZZAsCITuvtFnGmKAjx2DLYVA82Usj0JCd6SkRn5OxQeBk0qcTewFMYws6tEqoFIi5hy9xOwOL0xIQC+an0ATx/hRbUrI8d5AkP/H7nyEtUj68znGdtwNXia0+SacP0tBEI2AeoFlROuT25FSf28T5A5h+rlZkDLRLuEnMUAJe3njA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOdiydIvOgccWMDzeIq8H8p2djzQZYfpLV3wc0+6i5M=;
 b=Fwi2r5vktxaWJiDgBcpwsHTbVG+80YHCwsV9YMlmwWhdPG8NYqVpxY7MvgTljYMzbWQrcD11tSTP2VTiz0cCrSUN0JEqjKSEY5kafJdjqC/ZQV14u21pnkf8miBxPSng5o+jCTuC2OPELoEkGuxIn6axv7W7wOUoYFRjCPsx4JcGSaOHQlLRQYfr/JdJiOs345adU77GBipkRszJ3KPPSMqUUu//G1I63O7bNfaozAVC9cRPW7y9NbsavifKyJtEl0mRPbDHo8IOUUmytkYGs+LqpjRhLxZ2YWhkGru6HBPhZkpbXaO4JU4GXWOBWb3tRuAGU8df1t1K8vaJjHVDJw==
Received: from BN9PR03CA0623.namprd03.prod.outlook.com (2603:10b6:408:106::28)
 by SA3PR12MB7783.namprd12.prod.outlook.com (2603:10b6:806:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sun, 8 Nov
 2026 15:24:34 +0000
Received: from BN3PEPF00022BD9.namprd03.prod.outlook.com
 (2603:10b6:408:106:cafe::62) by BN9PR03CA0623.outlook.office365.com
 (2603:10b6:408:106::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 15:24:34 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BD9.mail.protection.outlook.com (10.167.248.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 15:24:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 07:24:17 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 07:24:16 -0800
Message-ID: <2301f2ff-1fe3-4991-989b-2c7d7c5de6c8@nvidia.com>
Date: Sun, 8 Nov 2026 17:24:08 +0200
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
Subject: Re: [PATCH rdma-next 01/23] net/mlx5: Add
 mlx5_trigger_health_work_force()
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-2-yishaih@nvidia.com> <sashiko-outbox-197654@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197654@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD9:EE_|SA3PR12MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b6b0c53-1248-4c97-da63-08df3dac645c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|18002099003|22082099003|6133799003|10067099003|11063799006|5023799004|261026140227099003|261028144727099003|261102123227099003|261026121527099003|261022075727099003|56012099006|261021121427099003|261022105027099003|261009223027099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	uRszZVjFW/Nxfg1xTMjJ4ToPO8iiFcTranDxH1NJtE6AYoeg4vaH/ZAqSZnzC1KtFhMb8P0A8NX+OBNaL+gcUT53ywlJf5XguU1YjxAIsgkuUia/j5etk/1iHzPjEPDMQT1DT7UGlYe7SoOK97hEjuohEu4OwcQLVCvP81RWcPdyqF6PDeXGePliG+CxbogmjIc3Z76pYU8gtwzdHskcE5JFySUHVwWMGYwe0Ee2Tx6lsScc8d/U/vM/QIY1jPnir6j1hMLIM3leTR4pNDaGr/lMxByBXMkdxSbkQMGkZRJb74oY+mwmk+biEwS8PRE/xLSVqXflfoSr/CCkpV58ehLl4H0cSh3TR6DLYis2dP3ZAbToNWksRW6n5Ciuql9x1R6bydgKUeBGh1TMGD49SlaKUPSrUeGNabjPi05+L/FqEfPdi3UwyWnqKZrRGNmKdeuHGXonlt67ty+8lRfI76hOjlS7WaIWXI52LaCF8pYNXyUNg+H0XqZcfMdjSzV6T5q4RSm8Yc6SY3jJJuksbEkctzm9AEx99kZWHtKRfO399Hga7RE282JcnYQlIpM87DsS1SjohrCGRTkhYcextMBG7V+Gapf+X8BUsMHF7flC6S1CglLWWmEHH0aXqBJNZbKCqEnNWjpbjVxfXS5VmGNvgp6ocuY4pi2/ThXCAODmrj5/CPLmkvoxFfvUcdjyvq/m6NH19Hx7t/s0AU7/GA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(5023799004)(261026140227099003)(261028144727099003)(261102123227099003)(261026121527099003)(261022075727099003)(56012099006)(261021121427099003)(261022105027099003)(261009223027099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KW8cyg4OXd3XvRjw7GqSnFRioDi2RYQrFuj3L3lullBzVM70HbIhrjay1DkGT7UlVwZpPcfcFnAgoXooS93/ZFngZv+VanIN2qU1i84VAgPxfPVAuLHzAoonFImjlTDRPj5FSVI1LqVv5snwguKRDDk2DC1CrVLlL6aoI2PHPX8V/X0isleHMTf9Xo+6TH2wyUc0AEtLgelfv+bvd5W8W2HPvgXwdE0TzqI3cClXXb3Qc2JsHNXB3W71FWOtUaGFMKYKPxFWZ1/iLBlWeCQhN90m30ZkzXYsoFcdUG//AO9l6mZkCtBlsoOQDR/9DwX0IimEdN0Vv7R0Sujejb6rU8OXdknQrCtgpqlJXl8EV7G8Dk4NE0TyoKsuDUn1Gw31xoF/QWEM1v8JRFWx7b6IT2D2Jt3DfQRqMbb3KisMwsEAMvdRjqyFh+Jmk54bgfu9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 15:24:33.5655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6b0c53-1248-4c97-da63-08df3dac645c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7783

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] net/mlx5: missing internal error check before mlx5_cmd_fast_teardown_hca()
> - [High] net/mlx5: forced health work recovers device when interface is already down
> --
> 
> commit 2777ddd787832a64204ac170752c47964f6bf998
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> net/mlx5: Add mlx5_trigger_health_work_force()
> 
> This commit adds mlx5_trigger_health_work_force() to queue a dedicated work
> item that stops the health poller, runs fast HCA teardown, and forces the
> device into MLX5_DEVICE_STATE_INTERNAL_ERROR before running health recovery,
> even when the fatal health sensors report no error.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> index aeeb136f5ebc7..d000ac335fa7a 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> @@ -627,18 +627,11 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
>>   	return err;
>>   }
>>   
>> -static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>> +static void mlx5_fw_fatal_reporter_err(struct mlx5_core_dev *dev, bool forced)
>>   {
>>   	struct mlx5_fw_reporter_ctx fw_reporter_ctx;
>> -	struct mlx5_core_health *health;
>> -	struct mlx5_core_dev *dev;
>> -	struct devlink *devlink;
>> -	struct mlx5_priv *priv;
>> -
>> -	health = container_of(work, struct mlx5_core_health, fatal_report_work);
>> -	priv = container_of(health, struct mlx5_priv, health);
>> -	dev = container_of(priv, struct mlx5_core_dev, priv);
>> -	devlink = priv_to_devlink(dev);
>> +	struct mlx5_core_health *health = &dev->priv.health;
>> +	struct devlink *devlink = priv_to_devlink(dev);
>>   
>>   	mutex_lock(&dev->intf_state_mutex);
>>   	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
>> @@ -646,8 +639,26 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>>   		mutex_unlock(&dev->intf_state_mutex);
>>   		return;
>>   	}
>> +	/*
>> +	 * The firmware might still be running, so stop it first. Do it under
>> +	 * intf_state_mutex and only while UP, so the cmd interface is valid.
>> +	 */
>> +	if (forced && test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
>> +		int err;
>> +
>> +		mlx5_stop_health_poll(dev, false);
>> +		err = mlx5_cmd_fast_teardown_hca(dev);
>> +		if (err)
>> +			mlx5_core_err(dev, "Failed to stop the device before forcing the error state, err %d\n",
>> +				      err);
>> +	}
> 
> [Severity: High]
> Should mlx5_fw_fatal_reporter_err() also verify that dev->state is not
> already MLX5_DEVICE_STATE_INTERNAL_ERROR before calling
> mlx5_cmd_fast_teardown_hca(dev), similar to mlx5_try_fast_unload()?

Yes, thanks. In v1 the forced work will do nothing once 
mlx5_cmd_is_down() is true, which covers internal error, as the path
that brought the cmd interface down owns the flush and the recovery.

> 
> [Severity: High]
> What happens in mlx5_fw_fatal_reporter_err() when forced is true, but
> MLX5_INTERFACE_STATE_UP is already cleared?
> 
> During a non-remove unload such as mlx5_suspend(), mlx5_devlink_reload_down(),
> or mlx5_pci_err_detected(), mlx5_unload_one_devl_locked() clears
> MLX5_INTERFACE_STATE_UP and calls mlx5_function_teardown(dev, false) ->
> mlx5_function_disable(dev, false) -> mlx5_stop_health_poll(dev, false),
> which stops the timer without setting MLX5_DROP_HEALTH_WORK:
> 
> drivers/net/ethernet/mellanox/mlx5/core/main.c:mlx5_unload_one_devl_locked() {
>      ...
> 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
> 	mlx5_unload(dev);
> 	mlx5_function_teardown(dev, false);
> out:
> 	mutex_unlock(&dev->intf_state_mutex);
> }
> 
> If mlx5_trigger_health_work_force() was queued just before the unload completed,
> mlx5_fw_fatal_reporter_err(dev, true) sees MLX5_DROP_HEALTH_WORK == 0 and
> MLX5_INTERFACE_STATE_UP == 0. It skips mlx5_cmd_fast_teardown_hca(), but still
> calls enter_error_state(dev, true) and proceeds to devlink_health_report() /
> mlx5_health_try_recover(), which will reset and reload a device that was
> just suspended or unloaded (or tear down a device that just finished
> devlink reload).
> 
> Should mlx5_fw_fatal_reporter_err() unlock dev->intf_state_mutex and return
> early if !test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state) when forced
> is true?
>

Yes, v1 will do that. An unload clears UP only after it detached the 
consumers, under intf_state_mutex, so once the forced work sees the 
interface down there is nothing left to force.

Yishai
