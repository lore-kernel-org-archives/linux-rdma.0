Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795075643;
	b=zwdtrQt/anL8qgeJiuCuo7Y77WQTWh/ReJwAOxsQFS0QrJawvdIrlz1/NtAPkTuzxPwf
	 TNn/+bakuZh294hbNJkTgbw4BB7CI/52AqIzoyn+cnWcxDiLzAbcczTtgj2JkNUkuopG8
	 YobVxi7tpe+oOCBwvFjUKGi0gi67ad9Qb3NPg8hZNaugjKXFNusx+SWHkdQotKYlEds6C
	 bjCi+aYeUeRtPmyBOHNe2xNcBtTQMEJ1f9Q8rdjhFAIrrQdtdjszhCxgqDExm7YhztMQF
	 v2IeIpNFMWyReRyttYOv7CKi5+Z6VGI8jzZ394QJamxTlTkCAMG/ks2+UWoyw4whYQA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795075643;
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
	bh=9/R6CFg7wdOV/MvaYD30zCEsr84guM0iFeUdVlUWfmM=;
	b=SPtB/g+ohuKXTm+YxNtaKFfnzTmVfAaY4vGO3dOxaidWIBmw1rRgUHXu4raemWtp8Wrv
	 sX2HeYGauVMthXEPxrP+CN9zS/bKkUjo1t27DtGmvpENBcDQTTKdD9nDM3dfeOoZPPx/V
	 1cNR2EJpOmugI16LBgqAUL4XyU25P9AMt7imWuPFlaFNcLM9NM9dupknL5PHvfduLujF1
	 f8PoyD5CZ6gES4ggO7rLKc4Ozz099MZf31W25bcNPYaJS2RGYIsp+8GpJnE7H5JrClkGW
	 M7I0a6IhsUMMWoN6vhaX0UQkE0kKKFplPhdsJuWuz77nZG9HEsDCEiiNYz233QJkutA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ncGGK5dL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.29
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012029.outbound.protection.outlook.com [52.101.43.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D542F606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 08:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D542F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ncGGK5dL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lap8vWQi3zcNYD3PYulAP7d+/BNWrUY5HE13U0Eel59GH7cI9boTQ583NdCvLBDG3tc0/yr2gIVGeoWvd/6DF862y0gIVmksCyGS/wPrL+8Zslj83UaYeU8f1PxnGHWHboFUkFSzr4dVzMaqcmb3khdtiU7QyDb1DxSbrxFIWOWZzpTanmblP/otXX6XdvInbzfjYtyKrnImAyibeqpqLI2bxt/+T7kTbBy5QRnCGPjXOZt2x51DuePnv9Kuoymvwi5WuQFWCxdRT+vca8aU+Dly9ITNc5uN0Njtdk/y/t8O4b3jwdJbbkYSb7spSOcdMocKDc+HOW6IOfIUikjF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/R6CFg7wdOV/MvaYD30zCEsr84guM0iFeUdVlUWfmM=;
 b=t8el6c0nFM5aKQLLIPIDGl6DYVV+s+pvijAVPER8REU8wEBzAcrDGQj0A0C6NiCAcJlb33RlyZNnPjm+7KY/nCPxcGx4zgjDCJBiZ0zMqQEWnCvzdoSJl9+u75zH8Mm6uVMo6Z1/KQJUhuaqWXFuCaQ+jiZ26IEVccm2U6Nj1wYYvxKafQ6SenjfAltmRXcqrPtlZxbLF+viVhgSEps+r4QWQkIBgB0GxWw1A31RGFeYYdO/l5LUum/tCVfkFsnitBfRBbg2I3Fug9+ITTft+LxNv7nEBgSmwMUX8D3pmsUNnJsCDz7hUFKvwoMNMUyubEJHABzmgJriLHC9217isQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/R6CFg7wdOV/MvaYD30zCEsr84guM0iFeUdVlUWfmM=;
 b=ncGGK5dLrVP0bLNtsPAF2DF09upptf+Upy+OiBgy7BpprL+a1PjTBwfqbcr0kCGl+KQl768wEGz3nMI0fpt+2cJ+bTiSDpIoc1W2U6ejoUzlw1jlwn7Da2jW/qliV60PJG9k3WsW3n2roFESWdExd/8BxklXeozNbVdWr+DXcQwgGs2K0SiHaqUUTr17ORV5wajXT7ZKfIwXYqef8ohHhoLOfZ0f0Jdqx3cAM6LP5ZMj0skB72iz/QtjzPIBpfz4v6qju8o3gP5XBnsmlonhleTMPKyI/PBqO024GJhi5dPwC45PkN+otIM2+GIn5Sapa6D763oZ5fbr03WsUFvvRA==
Received: from CH0PR04CA0118.namprd04.prod.outlook.com (2603:10b6:610:75::33)
 by FT1PR12MB249006.namprd12.prod.outlook.com (2603:10b6:170:34::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 08:07:17 +0000
Received: from CH01EPF000BE94B.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::3f) by CH0PR04CA0118.outlook.office365.com
 (2603:10b6:610:75::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Thu,
 19 Nov 2026 08:07:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH01EPF000BE94B.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 08:07:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:07:02 -0800
Received: from [10.125.206.246] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 00:07:01 -0800
Message-ID: <fbdada8a-a6a6-4d5e-a8f6-29ee161a8fba@nvidia.com>
Date: Thu, 19 Nov 2026 10:06:59 +0200
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
Subject: Re: [PATCH V2 rdma-next 01/21] net/mlx5: Add
 mlx5_trigger_health_work_force()
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-2-yishaih@nvidia.com>
 <sashiko-outbox-221602@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-221602@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94B:EE_|FT1PR12MB249006:EE_
X-MS-Office365-Filtering-Correlation-Id: b84aae44-2c19-4ff1-0835-08df46142079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|10067099003|11063799006|4143699003|56012099006|261021121427099003|261009223027099003|261102123227099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|261026121527099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	wDf+hnMo2uUae07rAiwS5RukrV9QPOH/UeM7xvaDKQ/8DCIyDh4hTfbjFidvBFHTSs49U9mn67sYQdIEQkoY0NCYmB+sIi72rw6MToax2igy186N+l4ZIpOCGDEAdZ3meNiQ0EApW+gJ7nfC5Fpcpz9zRkUztyBY2Cxiam4HFoTyqd427CwkWa3ivKw4mIyGSnP7xLseZfR9/hNfZ8hMdKPwwLo+5Le7hFZVNhuWJQR4pEnL250qvvj3Nz30AJRay7JsE2urhntH9gKOzGvV1Cz8JB1b9M5I+J4nHwqkdWLiHd5gUBATN7iktQULkRq4vocz19VHqDsvxdFX5gp7lrCBds7kjZ7EwW1GE/o/InLAu8n5vD3x4lcu4DKIVkDsk2GtNzJwqZ4B+UdiB2wK6jD+jKAQ2XPVm3HvMnrnaMNFZla1bBFrcGKBdF4+7BIhsNHHGHCb/VDxMW4UM3Y26N9dbcpP1U+QlZDZZfrUoy+iw43o60VjF0gtihkwDC3/d804fRXm6nX0vvxCNa6VEqP+3FQRTxhuXf6W3ujs6xjgcH/q7luC35P6KA1Uh6be3PeWFAew218DRj1xDBdXnKlBlfhylv/CU8m7A+zHYh2F372Y7TxUK/MFgsEfBukAWQNFpum7rOkkMk3qPegOKXHGShTDDpIyxufJQ6j9/VRD1WESWLtM/965hAkZjA7PSUYADmjrsDrRtBr5sEsOoA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261009223027099003)(261102123227099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	x5+YrKSxU5TKiJOrvjbiMSgI19EinOyP7nFtmndf/OQszl1g6phgp1lfZsbmhVKziWBDh+DuwL8hhJxV2K/vRtJrgc0/9CAGgOIJntynj1C7pF6Bz+P523wJyqL8sCDZR+e1Vi50ViaZwB2MHOVoXomzBrAjfrwQiM5s5zUicxmWj2cZbJX0fD08zTlpRck04+1RlleBhIEgdUJAPENnh3LhyA7+ohFTvQuWaTw0YYvcQG6X8f6X9kATB4qJK8VOUyse20954N6yg3GGrBYtu4sq+HCa6zinNh5azKGtf0PJPpI2RpeklMWsaTvXLk6lfg64WKH3WpYK0FKDVbxgz+UYuBPM/fgd/TfqiLWxFexHfJusV15FzxTU5iq9zX/c7oUawkBWFnZAN7/8I56Z+KJmnqMqtd4hFVKggpJuySn/dNhxB2B6nYPWyl2WkDZF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 08:07:16.6584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b84aae44-2c19-4ff1-0835-08df46142079
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB249006

On 18/11/2026 19:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] net/mlx5: uncanceled force_fatal_report_work tears down
>    recovered device
> --
> 
> commit 8880445e0e3559ece304416ceb136dde00d937a0
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> net/mlx5: Add mlx5_trigger_health_work_force()
> 
> This commit adds mlx5_trigger_health_work_force() to queue a dedicated
> health work item that stops the firmware and forces the device into the
> internal error state even when the health sensors report no fault.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> index aeeb136f5ebc7..e76351860b154 100644
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
>> @@ -646,8 +639,39 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>>   		mutex_unlock(&dev->intf_state_mutex);
>>   		return;
>>   	}
>> +	if (forced) {
>> +		int err;
>> +
>> +		/*
>> +		 * Once the interface is down, the unload already removed the
>> +		 * consumers that need the error flow. Once the cmd interface
>> +		 * is down, the path that brought it down owns the flush and
>> +		 * the recovery.
>> +		 */
>> +		if (mlx5_cmd_is_down(dev) ||
>> +		    !test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
>> +			mutex_unlock(&dev->intf_state_mutex);
>> +			return;
>> +		}
>> +		/*
>> +		 * The firmware might still be running, so stop it first. Do it
>> +		 * under intf_state_mutex, so the cmd interface is valid.
>> +		 */
>> +		mlx5_stop_health_poll(dev, false);
>> +		err = mlx5_cmd_fast_teardown_hca(dev);
>> +		if (err)
>> +			err = mlx5_cmd_force_teardown_hca(dev);
>> +		if (err)
>> +			mlx5_core_err(dev, "Failed to stop the device before forcing the error state, err %d\n",
>> +				      err);
>> +	}
> 
> [Severity: Medium]
> Can a queued force_fatal_report_work run right after an in-progress
> recovery completes on health->wq and tear down the newly recovered device?
> 

The existing fatal_report_work behaves the same way. If queued before a 
devlink reload, it runs on the reloaded device and triggers a needless 
recovery, or an unload within the grace period.

In any case, a device that forges a CQE can cause a DoS anyway, which is 
out of scope for this series.

Yishai
