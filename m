Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794154661;
	b=yg7T96NNSWMAXLc/CM1jdOTxvt5zhJwRZIxMHVD/QbXJQ/F1eNqfyph+IkB2Ubbm0g4D
	 oR9dBsrksNzzgZbf70HyfUxHZSdA911HiCa43+D7GOgvWumPJ9GtJ8Ms9lnId/YV/sL4V
	 8pyxu6+gSWhfOfS7Kcka12Z0WBBQCKfHrM+Ur+LHC3gOIvFJur17OYyrauPZ4S0wFOSEJ
	 wwgzabSbcE1kioRVuiMnqGUyGevGJ9hVXfpE0XSG2bFPGI5ccRgrpnD+Ew2LGNrLkS9Rh
	 NyWWR55E6wz1Q+h0883r3iW1AznGwZsJzdg8opVHQhRcL62EEO/nN/c1rcv9TO8mchw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794154661;
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
	bh=PvtKRSaJl5KvivraymhQQTT7H+9XnyjxQ7edPe0qY+M=;
	b=sjODWGP+lXwoSGeFNb6RScyZHqwyRmL8WitXcRUuOpWNAcagqjAKLzp0rfmYme7lzuC3
	 WSmNaD3QdITFdrDbudnPEMk/iAacjiP9om5qaAVX2BlkX5x6ZfZ2qXvvAzcaEEOSnh/ab
	 x9TeB8GUJwP1aa1TPyRg0fp8jq+um4RJrmRk7g0eLzLXD/8AOa/XgL4sEAq12fL1L0rVv
	 IFlT+hN196Ta8H7HDlDnn/KPNf44Hp/ZG+1oh2gHyCeBqg1cqKk2S6Jrfs+ObNK3C0YbW
	 2K6i2w+qTxuMmon+0C6hn9ZqB4hxbq8AovpwUrLwrzjZ7XZfGUkALOgjzWqdGMmrPTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MI24uwLR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.65
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012065.outbound.protection.outlook.com [52.101.53.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4764A606A31C;
	Sun,  8 Nov 2026 16:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4764A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MI24uwLR
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGh8eOpRAkIzz+ZVwuUClP8OwK59Y+aNVt9rofzmcBHfCR4O2zjHxt6GlfACD/SsnBIBYiXSZOVxkTuNihYk03Qo18kLV7B7C75mV6aLlQMp1EEqclqe28oQbVG2Z2PwPddLIOmsytGCNx5diptjCci9AY4NDxNt8GoEWuCuq5opk2G+kzMgwTSSZATaMhmaqde92izw1wniTyynuTu55BzA0UYTf6HUrJkil+uF83ob6tgAuOBnaAF2FmMEB+GxwuIWN+edxJ0dUlhdA52ajojarFIuzTCuMRl5+EvG//JMdCYTXPRpfe00fsvUP13CGIlHmPv+4CRDeo9Ql93TqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvtKRSaJl5KvivraymhQQTT7H+9XnyjxQ7edPe0qY+M=;
 b=I0zZFAgCf6WzFRuEiDoHuNR9aoX+lDRrm/rlVw1F6wX7kzthy1rITQmUnZnVb/wJ9Itp21WuKdN0OfNdH9DYwhBzYF7mRnhdryQ96fpMnTwyupJ4t0TL/n5ktAX9bUBIaLCY3DCIltkJbrbtpVzaOgtolEfQ0a6L1sZHv3VnyPfTFHn6OUgFOOfceWSYCIabMYey+9haI7kW1OP4aTO3Fg81q2BmpHsO5rG2uJVQJ0alp+l3LtF58ELm2VYHcWGCxCCm/g5xAI6wGNApzo2F66dy8lH/AarueUCaBanuzqnXemxgB6UUPl1/amKKx/CmtIhOHUozhVEPRqNjYeZb3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvtKRSaJl5KvivraymhQQTT7H+9XnyjxQ7edPe0qY+M=;
 b=MI24uwLRPZp1SBHYotfSPvB9TqnUgil1OXMvzDj6TRA/H4igCizp1UCmor+S7bVSBv4bv1EyeADE14bxrTqkT+vD473srLYe/RmUTOsaRa+lazqpbFlteBOI8fEkhGSCj7sD2v4P0p2n1SrLGIMwlB6ngGTyzWFuboh126XzBM9dEoZewVjHzBCEFxGsibQIob2dpJOhKVZy3W5iZkVz2w1cXbKx0riaLa3KbzhJObCbKcRcz4+E4YI75W8xZ0cUn1gT86rE9q0KzxNiEPU0q3Jvrsj8TZl//sFPF4+3mHwtDn5xj5VHVXZrYyANQWEGvEzp4t3aE9n5IujrRZZMMA==
Received: from CH5P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::12)
 by DS4PR12MB9561.namprd12.prod.outlook.com (2603:10b6:8:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 16:17:36 +0000
Received: from MN1PEPF000793FC.namprd05.prod.outlook.com
 (2603:10b6:610:1ef:cafe::5c) by CH5P220CA0008.outlook.office365.com
 (2603:10b6:610:1ef::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 16:17:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF000793FC.mail.protection.outlook.com (10.167.249.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 16:17:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 08:17:18 -0800
Received: from [10.125.206.9] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 08:17:13 -0800
Message-ID: <c986aada-fa95-4d87-8517-2207af994dad@nvidia.com>
Date: Sun, 8 Nov 2026 18:17:10 +0200
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
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-2-yishaih@nvidia.com>
 <179408308027.994134.17949886966516055410@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408308027.994134.17949886966516055410@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FC:EE_|DS4PR12MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e804d4-6d34-4b2e-97a8-08df3db3cd2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|36860700016|1800799024|82310400026|5023799004|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|261026121527099003|261102130727099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rKcWrl4bHIn09rhAm55WMU2bkw/WE+c6zKnatGeV9QGanrJRQodv8jQ5lBtBu17KIJC7DC2dviswbivA4y3DHlylt6Y7xAEIM3m51eVFclS5HIURxrciiLFPv82PYJIbHcW9JJ5eoNYh5FfYUsh5S/oONhEVpTNQnLMCoAxhTe+8YpYVgmZD6hb89rK0qvY3+pP3wnoSY8wkTKR1b8QjzVEIlhnBeRgjxGftmTD43v6fzPvFgPzl4QK8x/2KMtMXfFAgDcmoJXagxyXkK197iyiXJsyn8b8i5HhrB9GHQy5t8jDijAQl8jyKuJc0Sde//kEDp5wEc2LVLVPzBNz0Vud83VnLCbKbJRZH6MIBlHRsHwmOSB90NjXlulYQg7JfNKnIMW1E7mSa7oIB2AWahFTQfexPwj+oDyCO1wBX1TQX4YAZ+YI8wKHHHC3FhklTdZu6ULeznQmdtGJxh6faau1OKzYPNC5AjV2RKEU8JfKut3CpB7gefmh9PXw0Vmmig5SSnBvNOmscFchSJwixVO66uPiGu4IusbX4XRaY06xXVLF/CpCI+HCOJDF2ZOKQYmjqhoHAEvhddD52FH2McCZGjTgXwkY00pB+dQzK5JWLkp9mtL7lGcsDuiPWEqXeRVblTMyKojeuDhA7oRD0FTnzY4tpQOdhue2B4KZNKVpViXF7DSHZA1bSArctYxC/bwBhUsBrYi6u0pbBKiMcRg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(36860700016)(1800799024)(82310400026)(5023799004)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(261026121527099003)(261102130727099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GgxovoJlK9WK+vnNorx33HptM6zOCITyAU1V2ZhUL6P/+mlioVcbfZbqbGFR8b2jhloXUIT6GOHCCWflyCWMlTONUAtx2GKo5Xsxo3Lw9KQP7IegoJ34+hUIm6+RsYP7VV8ztLyYUzfvDB6Fu4I8UiSJxP/6mcFc7+nUPv3JbCVTpHrFQBTA0ZAWke5KH9GRY0yq4eN1BcwJmp1ASNrqzvgcRBV9tFm65/WWf+ofSMZwijUnnX/6iZnXGL7P8yNbWlKxMhC4N/V9gtKKB/IPLxj0dh8KZJI47ekgUfJAJT3yzU8oNdjLB9/5A5ka+6zvS349wDEN0uJq1Y92k+1NwsOT/fP4/3b6YncyZruvmC+f9cQ1/KrAZZk6PC3yqE/m0B4Zl6vpIem+v2/6vyjeeQ6HQJNAY8nMmoI8EiiluHmshVNyMzN3/m1KPkcGDIFo
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 16:17:35.8953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e804d4-6d34-4b2e-97a8-08df3db3cd2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9561

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 · Medium: 2 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The forced path in mlx5_fw_fatal_reporter_err()
>    (drivers/net/ethernet/mellanox/mlx5/core/health.c) tries only…
> - [High] net/mlx5: forced health work recovers device when interface is
>    already down
> - [Medium] Nothing deduplicates force_fatal_report_work against
>    fatal_report_work or against the device state.
> - [Medium] A forced request is dropped with no record or retry if
>    force_fatal_report_work runs while MLX5_DROP_HEALTH_WORK is set only…
> - [Low] The patch changes the existing sensor-triggered recovery path
>    (fatal_report_work, forced=false) in mlx5_fw_fatal_reporter_err().
> - [Low] A forced, consumer-detected fault goes through the same devlink
>    fw_fatal reporter path as a real firmware-fatal error.
> 
> --
> 
> net/mlx5: Add mlx5_trigger_health_work_force()
> 
> This adds mlx5_trigger_health_work_force(). It queues a new
> force_fatal_report_work that runs the fatal health recovery with the error
> state forced, whatever the health sensors report. Before forcing the error
> state, the forced path stops the health poller and issues a fast teardown
> of the HCA under intf_state_mutex. The function is exported for mlx5_ib,
> which uses it later in the series.
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
> 
> [ ... ]
> 
>>   	mutex_lock(&dev->intf_state_mutex);
>>   	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
>> @@ -646,8 +639,26 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>>   		mutex_unlock(&dev->intf_state_mutex);
>>   		return;
>>   	}
> 
> [Severity: Medium]
> Can a forced request get lost here? If force_fatal_report_work runs while
> MLX5_DROP_HEALTH_WORK is set only for a while, mlx5_fw_fatal_reporter_err()
> logs "health works are not permitted at this stage" and returns. The
> request is not recorded and not retried.
> 
> The FW sync reset flow opens such a window.
> mlx5_sync_reset_set_reset_requested() sets the bit without holding
> intf_state_mutex:
> 
> 	mlx5_stop_health_poll(dev, true);
> 
> On abort or timeout, mlx5_sync_reset_clear_reset_requested() clears it
> again:
> 
> 	if (poll_health)
> 		mlx5_start_health_poll(dev);
> 
> A dropped sensor fault is caught again by the next poll_health(). A forced
> fault cannot be, because the sensors never see it. So dev->state stays
> MLX5_DEVICE_STATE_UP. The kernel-doc of mlx5_trigger_health_work_force()
> says this API exists to prevent exactly that.
> 
> In the mlx5_ib consumer later in this series, umrc->state is already
> MLX5_UMR_STATE_ERR at this point, and cq->poll_one is already
> mlx5_ib_poll_one_stopped. The UMR waiters in mlx5r_umr_post_send_wait()
> depend on the internal error flush to wake them, and they wait with no
> timeout:
> 
> 	wait_for_completion(&umr_context.done);
> 
> If the forced request is dropped this way, would those waiters hang
> forever?

The same rare hang can already happen today: a UMR waiter waits for its 
completion or a flush, and a fatal error while unbind runs, after the 
health work is dropped, leaves its WQE unflushed. A forged completion in 
this window reaches the same state, so it is a pre-existing hang, i.e. a 
DoS, which is out of scope of this series.

> 
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
> What happens here when MLX5_INTERFACE_STATE_UP is already clear? 
[...]

> Should the forced path unlock and return when the interface is not UP,
> instead of only skipping the teardown? Or should the non-remove unload
> paths cancel force_fatal_report_work?

Yes, v1 will return early. An unload clears UP only after it detached
the consumers, under intf_state_mutex, so once the forced work sees the
interface down there is nothing left to force.

> 
> [Severity: High]
> What happens here when mlx5_cmd_fast_teardown_hca() fails? 
[...]

> Does this path need a mlx5_cmd_force_teardown_hca() fallback, or bus
> mastering cleared before the error state is forced? 
> 

v1 will fall back to mlx5_cmd_force_teardown_hca(), as 
mlx5_try_fast_unload() does.

> [Severity: Medium]
> Does anything deduplicate this against fatal_report_work, or check
> dev->state? 

[...]

In v1 the forced work will do nothing once mlx5_cmd_is_down() is true, 
which covers a device already in internal error. The other order needs
a forged completion close to a real fatal error, and at worst ends in a 
second recovery or an unload, i.e. a DoS, which is out of scope of this 
series.

pw-bot: cr

Yishai
