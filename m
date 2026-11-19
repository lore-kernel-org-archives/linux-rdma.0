Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795074477;
	b=YP8BSC5TqvPTn2GHaGS53ga57UAz4xOclkiQHjgI8Wd8cs4NLQhITF74GgECsp7wdID9
	 U9wkZpqCoEiqxz6Xt/aD4cxorj45NKWj17QjcYNvKP/G3Q1qsk3Yp5Va6uoPicsVSkSxt
	 AUpBgLoG9sDQvmrjDDvrJuPwRzRUNBbV/T6yEYhbigcq1L0XuBSSQe8ab9ex7cPS2n/o+
	 YFAKtqGJVSjspRqwzHKh1D7M3kJU4JwWL0SM7pUXe0F1xAkO5ZyLu07UU1dYKH9qCqkoO
	 JdMTO/9gRZpuKSymNowVQCkQQb+BogJo0rX+yEfROfdeOWUOkypWglDxzIjPZ2pxQ9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795074477;
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
	bh=NxaDLy3kTu/T3sN/sIsjcH9V/GiOz2OxLtfG9LFDhC4=;
	b=ySUZidb4kCR4RW9VN/Ci0LTkHKJFAFKhYjcs724XbtpL56lHRfyBLZBjFPCIXtyLdhVr
	 +czHMHbMURdwDPL4gAHoyFqANPImOA1BWSiBYn5hKK9vvWrvwAcUFSa9rzR52rOg3+Mf/
	 j41zh+x07vamNvlP+92J7/2gJtzgB3jnMech/IjaA5IxzuzYtJKYMNnTEMgxhVuVu5pz3
	 lj4QryatR15k+D2wjK0n9rp2VYRJ4lcw86aaDRSfaSv1n2o/WuIkQkROXnzkjUY9Ol5fJ
	 L9N+2sA+fQPrBh+8+6bhIDBPn7irVBdHs4oI3C3j5yELPCqefunxKV8rXxxcN8dbqgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qVuQ89w+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.47
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67A606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 07:47:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A67A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qVuQ89w+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkytAd0UynQb1g76qQm/781EoYyJwPRABkQ8A9IVu0B+9Mam3igTBBoD950In0W/4ldS+WjdcxNXxMnPk7N5vbGbE19i42ZNym2ar+w1Im6QV924hpupUBxZaPd5xkBn/CRgRSNtrpQHjwlngsSZSKwlYFs4EO40cqovxzz1gaCQgtApjBId60hNJSKfzEEs9PI0+0jqjdD7QBG+4ORVfLR3Z0Tqjgtid7Xwg6wOgc82V31/yypoIGpeCM7UtpNC4/Fs/fsHcSHr5DnbS6Ql2551kntzluydVZVyA8rY4FkqUMky4pk3U8BqaeZnQk00brcjLbz6tQoDQuDisvAD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxaDLy3kTu/T3sN/sIsjcH9V/GiOz2OxLtfG9LFDhC4=;
 b=GIAKAKq1wtiF6XHxqDgOxjkWhTJGRSr76sOFpStWFAIvx0DB/kcCCebVrYNb1uFNqTxyNzBthpYzELIdITxLLlEDoKNlIe8h6JlBI2OMSRxTzJunxo/04VjTv0CvQcHK4vsTE4KeWT1MRC8Xwc2F7YFhirW3IGSlEohhIn3XC/oMkfzwkeysGKXXFRun3DfLpdZtq91r6nZws4IYmvXFLBN7fo+thGfk3r6U3PbRvChZ3LxHRQFt09JN6WXFSJhVA1YEuVNppHovWapG7jJBvCK9ZNx0XoTwUBNOlypraNOb09s9uKaHEpvKwoC3zkvH55NJcGwVeQ8K9lcClVVZsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxaDLy3kTu/T3sN/sIsjcH9V/GiOz2OxLtfG9LFDhC4=;
 b=qVuQ89w+eU1Hiyw4JESmibkc8z11in4jLBc/bE/GyJUdop9WHjJjCWozeogWTGaUuhTNhA9Rtdms7Bl7CiCl8GIZdQxJKvIIIXpFzZvKEBTc7nFtiOQlDqaJiEPO+vhBc/O0fkplrLtGtv/849ClbVO9x1oGlNn8zUvl8zKlEMxPRXsX762pXTcz300YqjG7zN+o1b1QUs3IrYymHnEXB18pca2+X+khDpmojnVePoSp/Y6lrqEFZsoHfLzasG5LyGFGkIQfCD4pBG5sMw1AOWLFwCNEPtWv+xNC04qh10OeyCJyfVKh35MVpMV1gv6+VmDMiUG8mOab3R4Z1Aa2CQ==
Received: from CYZPR19CA0002.namprd19.prod.outlook.com (2603:10b6:930:8e::8)
 by IA1PR12MB8286.namprd12.prod.outlook.com (2603:10b6:208:3f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Thu, 19 Nov
 2026 07:47:52 +0000
Received: from EA8PEPF0000000C.namprd05.prod.outlook.com
 (2603:10b6:930:8e:cafe::64) by CYZPR19CA0002.outlook.office365.com
 (2603:10b6:930:8e::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 19
 Nov 2026 07:47:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 EA8PEPF0000000C.mail.protection.outlook.com (10.167.249.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 07:47:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 23:47:32 -0800
Received: from [10.125.206.246] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 23:47:31 -0800
Message-ID: <b244b29c-8a42-47a8-9fcb-e741a4f232ab@nvidia.com>
Date: Thu, 19 Nov 2026 09:47:29 +0200
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
Subject: Re: [PATCH V2 rdma-next 04/21] net/mlx5: Catch too low max number of
 EQs
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-5-yishaih@nvidia.com>
 <sashiko-outbox-221605@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-221605@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: EA8PEPF0000000C:EE_|IA1PR12MB8286:EE_
X-MS-Office365-Filtering-Correlation-Id: 389882dc-05bf-4167-3b4a-08df46116a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|22082099003|18002099003|56012099006|11063799006|261022105027099003|261026140227099003|10067099003|261028144727099003|261009223027099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	HqCW7yYD2aCRuLAzalfsGFbGj4DtSPU+bUoKACCWrwMH4xw5RocMFGtH033gWOSI+B6Hao7JU6Em/p9A+kZeL6HM7k77PX72JN2OlIEXyVxdmyAiusBZMQOt8BQpFQWfzESr4VFQiKuPyROu6vZvHKGK0ZF9aunxFyGjBsP0eGOd4VkyK2Ngway+wuHgli0AwSyi8dKyInG6XYJ4epptzLxYimmdjMyR966alQrAzp9sViQ54r4uGkrtP1rO31sc3UQ+I7BCNMCbDlz09ge38uwcVCH5P7z1SpZDOKVVKAIyarDaNVLqP0QM1mUU/xQGbBsiHo7MhsPn1jqkex59XFpIFzi0BxKOMIlnHmTZrXpz+Rs+X2VQzK6gRSKSLfu6JmUmA6rWNf1OEdYUzxJdOuiY/WrNYPEQFNTkd58kksw8AjVDLMb03fb+F6BopokCvr4GkzZ3Gs1qF26zLLDCs3/2xdHnwmhuLHROJhx0BTEFFk8dUyJyGG/T3gFtFktz+4Iae7eF9UlAOSRuOvDKCQT35lGHVamTQa7FtsLCSey1XRCY9IVuU6zHggZ+eBTKB/pNc9CPxS3LrsvKLmqBnPiUK6PqySXcm0OVh4Kyk0+ivTZ2f6yLbSCs6v3IepyHu9RI1+0oBWoYY26n1jYNNlrOqbqIo2+H6up3X7CRuQi4CLruBfHLkX2oQD4i6/a3KqpG0qZi2q6voJpqb3yIlg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(22082099003)(18002099003)(56012099006)(11063799006)(261022105027099003)(261026140227099003)(10067099003)(261028144727099003)(261009223027099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bewwUQCqnEPeLYDTvaMNB93CpMRKbqa0KdbqyQQS9+bOIqAZ3VRFnlpjVFvp23XTV3yXQcl0LAn8Bv9+6vhgAm7ORzwCRyfkR/F7xO+PGajFta1GEhszW8XikkLLyNS9Czm+DN9RxLxL90yTX+3gqX8CyW0KeoiVTty7Z79IUYa8oLi53DGa225J0RqJHzuDeIHj8g9CT9/TYwV4adKaC7ZG6LBlmzlFNDHi/4zZccoAI4FjnohgN4M/yJHWyhXL4dM4mKpSG1NzBRczgcHBLxTMldwsoU15PPGiNmQ3Km4s7UFOEBm7wKOKGoNwiKoEsCEMm3eUwPma766Ds3SVqmAPVXGKkhfqo7yEMsVHddBvF+QqsbHbitKpjt52YUONrhjDhMcIG44GSQRPUvVfFglHS4K8Yi1Fr9sLIkJRY4c31xUc/Tua1ujcSh480ozH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:47:51.6954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 389882dc-05bf-4167-3b4a-08df46116a16
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	EA8PEPF0000000C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8286

On 18/11/2026 19:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] net/mlx5: divide-by-zero in alloc_rmap() when get_num_eqs()
>    returns 0
> --
> 
> commit 3ffd9856318c7a723d1d765cb083af29c7442990
> Author: Dragos Tatulea <dtatulea@nvidia.com>
> 
> net/mlx5: Catch too low max number of EQs
> 
> This commit checks for a negative return value from get_num_eqs() in
> mlx5_eq_table_create() and returns -EINVAL when firmware reports fewer EQs
> than MLX5_MAX_ASYNC_EQS.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> index d11ec263d53c9..b34670eb037cf 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>> @@ -1195,9 +1195,13 @@ static int get_num_eqs(struct mlx5_core_dev *dev)
>>   int mlx5_eq_table_create(struct mlx5_core_dev *dev)
>>   {
>>   	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
>> -	int err;
>> +	int err, num_eqs;
>> +
>> +	num_eqs = get_num_eqs(dev);
>> +	if (num_eqs < 0)
>> +		return -EINVAL;
>>   
>> -	eq_table->max_comp_eqs = get_num_eqs(dev);
>> +	eq_table->max_comp_eqs = num_eqs;
> 
> [Severity: High]
> Can allowing num_eqs == 0 cause a divide-by-zero in alloc_rmap() on non-SF
> devices?
> 
The num_eqs == 0 case is not specific to adversarial mode. A trusted 
device can hit it as well, so it's a bug fix for net with a Fixes tag, 
not part of this hardening series.

We may send it separately, failing alloc_rmap() with -EINVAL when a 
non-SF function has no completion EQs.

Yishai
