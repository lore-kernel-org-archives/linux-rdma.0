Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794409426;
	b=lqyA0Cis1dAvNm4Z2t100TOKC4Y/AlV9mkGFqtnViLUulTAV94YQuzYLOlFLYy1XP/yo
	 MqZzL8MWWL1Xi3hPzmMXV64N4HPoaoItsjgCy5w2vfukWgYEUAbJGL9m9EJUhw+rM1ET7
	 mc7TrEWU2jnWeMhmsvCJsMOIq37JZIQvVPE9AYlt2xWcHbQbBx/PJcymD2ggPatmrZ6Y2
	 smbR9kLrph7LtkAOTj8ivb5cibVuPoTfPyARyl6wvJ/iYQwgTvCQrqiFE7SY8s7UB//jg
	 nLTwgaOH1sl3e8k2ypOyXgGZ0VlJHsczm7ro6Zmjnj8IXsH0NEmBeQwAaNWCasDXMXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409426;
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
	bh=UOHll4diHLVs/OZ4/FLr1PIbkebBuIERbagQ88Bu9xY=;
	b=xtQPDJYpiNDh4gWhukjG9BYmBby0gXbanQquus4ZPnHvVhBUIvk/3Z6gUaAaUDEOAub5
	 UvsD5/njDvKJ26c3xTr3VYpgybRQsoTUg/id1slM9+OmfpBrGeHBda7DL317Ti92TJ/cF
	 YpF6lAiKl3iR949bdUnQOc6U99MD6wtikzhbGAHIfANWqUqx612RQY6fzQZgK/Gq80vK0
	 jmv+UbS16AiEjJjcOACjkOG7ZUhAdj0YklrP59SpR60msH3KXMnizLOMV+wjEL9xk0Pd4
	 pg65OppBrteu3XyaaOG3iI0/1wroaShi2K0KhdOF+F8j1sDSbXLifLdHgWR4blwOSuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fJSR974j;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.57
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A58606A32E
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 15:03:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A58606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fJSR974j
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9CMUsZs8gwNhBLjJ/hmRRziBVezshKlyFvHIToBtq9Tfgs8B63FeCaMvRxnmc/r/i0g+gJifhl6f6wuC7ckKaw5yZQxsTicXHu94TPHVoWfA7i4qaaTOYsZ8gyqW2y2CEsdG1FfHgt5nrbJZzdB6juwfO8ngu0x7YmWL3dYoyOkYxQCIpt5Ds96B6dQnJzHEQefYh4kgGYroHRCIQ6poIyv4XgHa2VV0DMPV5mabVGPxevmt6WwN7ohqZcOnfcny90kd3beB7iHGkWCYqfvoCdxxv6TYQcHIR973TG9ALjkBuqN7Hl9TND8nqnSHw6G1J1qcs1OunnGkTYHoDiZ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOHll4diHLVs/OZ4/FLr1PIbkebBuIERbagQ88Bu9xY=;
 b=iWubG9JcJYaHimBD/Ju92Svx9xUx+Xmsz1SWt3ETG96gEp1kNOJ59y4Fu21lremdwbmJjUuTku9opFmNbCLUZvsCKuXW1hnu6uV8HXPpVigggPOJsZH4dHUVPdR3vp7gL2O2Hdt7g1l4SjTpjLU28wvftp23NB2qHpUnBsJ17Sufu37hDxESLvnZKTWksDYkXo7KFWu0M2RKEdW0N7qeUX0ZJ5t2J7fzXgiuRiM8GKF0mjthWez1EkxVlrl2REWh8x7Y3t08rtzW9u19/vGM28nyMkKP1VQomf8Rx7FoYUiwJHJxAcuc0/dTOvAA+qcw1djDT12IxbTttb6USY2rog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOHll4diHLVs/OZ4/FLr1PIbkebBuIERbagQ88Bu9xY=;
 b=fJSR974j+6Mzt7h5Ww9yigbqzfwc9AmZRWDva8h9h/fiTP0HVsGtpNp9KxVLGVYWqujNMStI/5hlQUZ1Vm4iyW5j2X9SDElpLHSy2aHhHgvoZw5YwyHfjueBqEzPrfbeAx2xsS4Vnduo2w9CLaO8qMYykJb2si9+eoloxghg/hy3ILGQW/93fKzF+FitX/7FT0t+feEJjTAuHrd1vJY16898TiX78DlnxlQme/4vKsIwrs0LGqCds8E0F63lTYf3W1TjX2wFrycgC3PC3TTNyQK/2IiZeCiaLfh5Db1GdJLXeQnjXWwDak+ToeHtpQLcxv8DqBrunXpjysYDzGtzzw==
Received: from BY5PR04CA0016.namprd04.prod.outlook.com (2603:10b6:a03:1d0::26)
 by DS6PR12MB649431.namprd12.prod.outlook.com (2603:10b6:8:416::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 15:03:43 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::4) by BY5PR04CA0016.outlook.office365.com
 (2603:10b6:a03:1d0::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Wed, 11
 Nov 2026 15:03:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 15:03:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:03:21 -0800
Received: from [10.125.206.103] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 11 Nov
 2026 07:03:20 -0800
Message-ID: <fe82c0d6-e740-4a6d-895a-c542b66c4a65@nvidia.com>
Date: Wed, 11 Nov 2026 17:03:18 +0200
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
Subject: Re: [PATCH V1 rdma-next 01/24] net/mlx5: Add
 mlx5_trigger_health_work_force()
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-2-yishaih@nvidia.com>
 <sashiko-outbox-209086@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-209086@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|DS6PR12MB649431:EE_
X-MS-Office365-Filtering-Correlation-Id: a5bbba63-81fb-42f5-04fd-08df4004fa44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|23010399003|6133799003|22082099003|18002099003|261009223027099003|261021135927099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|56012099006|10067099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	urepzI3xSlFkgUYcPNYYPfXnYx94NQuW35JKIG2VmMbXURoz17dhC5pVyi6nPDTtckgb7HJs0fGq4V86Izm3mJSMQTVW78oJckHrf1fLj8+tGlQyigzqj/pmqVGvU9UKf+0PvpGeUwTW9VR5u6K4QTObL7t+cP/KitaV3qaisqFeaYMnuuw7ApT8iJNBntmv6+0ORtFi2jk+GCDnnFsiOW8oSYZPoxrXZIfoJ90sGzQ6JSYnuC7L+acKd283Qz3+0cGgjxYKQU1uLlk+77DWO9TRmZgXkLUUbbIBBT1icIrf4jAnnLa1l9KHcpTXAITsJCpi7Wh02rVX4PdP+U/1Ee0fPcmDc1uudaTsI3E6dBsPdhoqYOSZy9Yuzj1I06GXApsZY6dnDGRMaKAI58W8qi4ESIaAN7Excmjf832re4L7/nKY/6b4MSPIfGRu40n+3UYhlGBWSRGh6SnT4hBL9sn9KkfE7Ia+fRlOY3ZDH6dPe9F6JBpk9Dyx44dek5CY2AeyyZ/ybqFHvjRwl1ES2SIGQuXD9uZ/Unjd6UOhxP3upxv/rPjlRCMwuzY3xtutpg2hJP4CY7Xliwgp3iw3hOac4qoxLsovDh/e6rgoPglgYJICXZTdpg0NRxbDBd62pp7l3qbmPSVYHU1usUqCjP3kHHDeV2lUctFm2jiALgeZEFeFQzAQNtqo7tYvNgTFvU0N8LIhwkM5NHyzmZ9WMw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(6133799003)(22082099003)(18002099003)(261009223027099003)(261021135927099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(56012099006)(10067099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iMJSODVoYo5kuVfwQoFNN849T3lrY0ZIVVUE5espZQhkl+/uP7gVqbNdyOoTgY5+K36vuIJ7vw90cs2800m/EtL46LGZ9HW4jRGOsLC8oB9Az/soSVLb2HYZn8CRaw/5v2koLjPIbjMjX/4TlMBMdtfa1vbEXRHaOrchOXTPrQDVRq7pXVNZ2WjO5yAq4YFLpRK5/EyBFEdYsv9zui6YaAhMGZ/FPRDVf7mevF2WAnLXQLmcg4RSh4qRiEKN+Z/Tid4AhdMrLZ/NoHu8ZlXTsLoFiXgAxwmNn2FKxlCQdFSVMD5pzTThdFpaIgfDOmk9oDa2dXmlgHD44gMyIDOvbdG7SGfHv8ZxTeQgZriXxCUrz2daUAIXaaULvLQW/lqpDbT1fQrnw036jSMrvdYwj3k+SO5GjAARlJRKaREDyVKjbUstriW3gAZlWUXuNgm5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 15:03:43.2438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bbba63-81fb-42f5-04fd-08df4004fa44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB649431

On 11/11/2026 15:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] net/mlx5: stale force_fatal_report_work unloads device after
>    recovery
> --
> 
> commit 0df37fc156d59f375d27165a97578e68ca1e9e3f
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> net/mlx5: Add mlx5_trigger_health_work_force()
> 
> This commit adds mlx5_trigger_health_work_force() to queue a dedicated
> health recovery work item that stops the firmware and forces the device
> into MLX5_DEVICE_STATE_INTERNAL_ERROR even when the health sensors do not
> report a fault.
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
> Can a force_fatal_report_work queued while recovery is already running on
> health->wq tear down and unload the device right after it recovers?
> 
> Recovery runs synchronously on the single-threaded health->wq via
> devlink_health_report() -> ... -> mlx5_recover_device() ->
> mlx5_load_one_devl_locked(), which brings the command interface and
> MLX5_INTERFACE_STATE_UP back up before the first work item finishes.
> Consumers remain attached until mlx5_detach_device() runs during the
> unload phase of recovery (for example while crdump collection or software
> reset is in progress), and neither mlx5_unload_one_devl_locked() nor
> mlx5_load_one_devl_locked() cancels a pending force_fatal_report_work:
> 
> health->wq                        consumer
> mlx5_fw_fatal_reporter_err()
>    enter_error_state(dev, ...)
>                                    mlx5_trigger_health_work_force(dev)
>                                      queue_work(..., &force_fatal_report_work)
>    devlink_health_report(...)
>      ...
>        mlx5_recover_device(dev)
>          mlx5_load_one_devl_locked(dev, true)
>            /* cmd and interface are back UP */
> mlx5_fw_fatal_reporter_force_err_work()
>    mlx5_fw_fatal_reporter_err(dev, true)
>      /* mlx5_cmd_is_down() is false and
>       * MLX5_INTERFACE_STATE_UP is set */
>      mlx5_cmd_fast_teardown_hca(dev)
>      enter_error_state(dev, true)
>      devlink_health_report(...) -> -ECANCELED
>      mlx5_unload_one(dev, false)   <-- unloads recovered device
> 
> Because fw_fatal_reporter is still within its graceful period from the
> recovery that just completed, devlink_health_report() returns -ECANCELED
> and mlx5_fw_fatal_reporter_err() unloads the freshly recovered driver.

This is the expected outcome. It matches the existing behaviour in 
generic mode, where a second error report within the fw_fatal reporter's 
grace period unloads the driver instead of recovering it again. Here it 
needs the NIC to forge a completion during the recovery, so it is a 
denial of service by the NIC, which is out of scope of this series.

Yishai


