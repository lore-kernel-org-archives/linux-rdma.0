Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794221555;
	b=a6YYhf9W7fM9TQvC4y9pIAzIqYE1jwNynzzXMzNaL6gZDWQqX//jfoQyssFm9slUKMyd
	 xnXFy1FHN7eRu5owUx94GqavUOC7RkHlYiiUudukzGNY8vqrwlviAzuLiooMwzdBg8N4Q
	 pBDs5xZznDcfyVhSWK3o0U/VO44zysyHoC5j98RKhH7jdYUC6Zb6G344v6/PYWExeu0n7
	 PTFUS3TPry9v44WA+cI4dOYDNV4BxhY/Y/4NIldTxl6vg4zlsV1lKKoCw6bX4O5Vh4L0o
	 RdIMQLSBFREoThVYWqD/TORcF6/5nvhSi7hZBls3JswU5Mff76F0rQfUFk2Y9/G51dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221555;
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
	bh=H2m/iIwMg3NWHwB7SnknGQngQY4gKtSyJH9pyTIZWVM=;
	b=oDxx5ws29OJIQkklFl26INg6asBa7H2wug7bwawEJHqZlyx6G/glYwDYWX592ML9B5a1
	 ECAcDnyDyWOrc0gDidFClgS9fDCJFGwr5i+zttfVs7fvZhI+BJ0qteAwDDErvH+hmqRuP
	 5Es6f/4CLxTLa3l5AG7CiOSq9WNrGwo0Ol3yXWzCVJRWbZ73T9gKBFeC6FpSb1iXsVSs3
	 u/O+poBUyeAGASJVnejK3rZUhcwXzIHIKrnS3xzSGeKLP+7gMV5b14mb/b4Yu9eR7b/om
	 OGMoQGQ0pxzqyJUjHWF13yArCR8EY9Jhl/S1yPZ6fN4uNCjgxwrIXyHejSdFP/iuVpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FshHAS+S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.59
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A84606A321;
	Mon,  9 Nov 2026 10:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66A84606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FshHAS+S
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oP2GjQuvPDEALGlwqnNsiuuMfM/jKWmk3KzazEGI68Uc9FcWoIOxOK77PTtNT+z1UbrEddnhAiwCgsZ4TYX0PEQmdSkYUz0Nb3mI1OSpqQ+oCxPan4LX/VMlFB4MRI9R2QX7hQ4xLwEc8JvY52KbHqrizqg2HZkmF2RxEOjOlShS9G4+NWRL1S2XF1dCh7K88RdN09lTW4WIliKrfXOzPQUi+38VSb4G5A6FQlvBMmRTfCf5agilgFliRaieOcvFZkDZfmQ2hJMQ1u4qxbozynbMA5wezWPXMZXHFH35s72BmbPCFqvYWdyuOTI0ugJSl7CZ5dhgtqC6LznIfZ60mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H2m/iIwMg3NWHwB7SnknGQngQY4gKtSyJH9pyTIZWVM=;
 b=FgSys30J406ytIyvgjBss9KzWqjCBqF0cV9ogUN+D206tF49RGc068lqs3x0ASxkKkxDwUjnXjVeHg5V9aYxWLcwujxDfbXs7BzSUUMQLsIJmfOMUBxIbm2ibHKN7Oad+C7Tm6fK76XZq9R6Zbqs6U7r7dnfRwl4ASbN5P2Kbf831Vw++B5xMEPlBWORSVoIysHjcMmYA72j16kI2L5mQE0ccPR69ae4C+R7b64n787bdYOqNfy0i2ouIYYQNhD9JMxIzN3ZAWEc8U0vZXjqCc9sHHBBtehnF/E2ZX6zMbKTkXQqfYz/+WPtztN4E0AhHR7/Ipx8ZZzY8Ln1tg/zBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H2m/iIwMg3NWHwB7SnknGQngQY4gKtSyJH9pyTIZWVM=;
 b=FshHAS+SJ3ZSge6qofR2CWIcS3BKRCDvAeczDtGoTgBYOnUFtA9o0IT6ZSfnnALiU0riRqgMhttFxq3qq0PyxSxUeC/jIa74owDHF0IJCRL/n9ZColotKgL+tyHVSfNduNhc0CDH6zeiyG/jXNK1d9E+H4OPgyYhGTXnv0nn8kRQEXZEh1Hjsqd5rG8eVq/Nm3ga3rKSM7WYWZ0lckO1oGytuLMwf31qcDOmi6A1iCMVCS3l1vjf8+HBvorOVqjFZSA+8Iv4cHHhg/Fj+IOCV0DAC0BNGY/336m8ZuurVP1Y9xZQyqp2YmAlZVKEI1JnjfZFMWcPMhGoSDJThjst4A==
Received: from CH0PR04CA0085.namprd04.prod.outlook.com (2603:10b6:610:74::30)
 by DS8PR12MB333896.namprd12.prod.outlook.com (2603:10b6:8:447::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 10:52:29 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::54) by CH0PR04CA0085.outlook.office365.com
 (2603:10b6:610:74::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 10:52:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:52:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:52:17 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:52:12 -0800
Message-ID: <a9936dee-857d-41bc-b324-cc471172bdbf@nvidia.com>
Date: Mon, 9 Nov 2026 12:52:09 +0200
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
Subject: Re: [PATCH rdma-next 23/23] RDMA/mlx5: Advertise adversarial mode via
 ib_device::adversarial_mode
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-24-yishaih@nvidia.com>
 <179408310891.994134.2389971836310893033@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310891.994134.2389971836310893033@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|DS8PR12MB333896:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fb5536-1b81-46d1-bd97-08df3e4f8c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|82310400026|36860700016|261009223027099003|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dZ9QXqCyZqMq9uUIlqiC8hDUrHJsenc1dyr/iiBNkTLnKWN7yL8bClV7iNxWJ9pc0qEkcGHOeR7eCaJf6YOYVOkJXWuRhC6UdUCUo9ZrZP4R4vSenVmpWnEtZtDb9+mMZem1CCqZQ6rogLPLkhfDnSyomp+0/RmX++tobP2X6Bbvz+gWMsbayJs3g6byFKwyPekFV0LqXg19KdfgTqzmF+qphQGew67IwRxjSd48VJusjB65pe+LY3TP5JY8PfxU1vjAYn+pPsTBoQYy/PGCpNor8N3LoQTNnzuXEcuoD14SFqmgwMANBUg2pmANE4G+F2gJWbXQl9iNvyH2Z7T8nhlyo3It4CoLrm6u+1LXWqGkXu1iFFyNDZQFv18DWeL3nAIrin1jGG9JB6pv3eVXKDMkAfJo0PX1m5jfTECa89S6rfAI8nIRdtkI2gp1ejVbbLQARaBRAeLnC4a7Ryyp7ZMFZ20R1ygmgEqFMp5GM4HMMoRPx9EePrH0pl4m64baiqja0JSqL6ciM/s0lyv/7FuLX7+NLSxJ/teKlobf+LBtaatyQ49z5XKeTiGUlOUbvhALEUgbI2ip1++gxIKXbwLM1XPIqWnZxG6Ksr8wBi5Wmy/2YTMbWmy/r4XK8uG23cDjLvmOnRcRh5SK+K9R3zsWI2MRptGuCZwfq9hWNGVr8laTTeKBCvMpbhc4a967eEu/fOepcT8IvAIuJ50+PA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261009223027099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VKHatse6hNVwJfCBHBPDhe5Qt+LwuWk34YXnM7IiBJtxYtNNh9dzdeHLCp+dElsnCNRyV8Xj/xDKL3czNVaNcOD20OvxTlNJc4EQZnT6/e4iDeuJE74D6wUvXVTcrTd3ByTtv91ky47AVRn5GKlN9JDkGGwc3oO7Th7BQ1fQEtA3VeVA8NoNs47fZ4jpo1Te7tAXjhIzzvhkFxJOpQswJD0gDxgj6JuNW+9Qtsxdl2+oudEFRL9IvdGfdNVxwTPvoPo+SjNWuy7weNJUndVdrGphin1InLcrRlmt/kDBRO+lcdJrJJANgyWCDtmA11hXMIhq6XgTg/ibLHJz97jkYr99c4Oez7BfWqWNPxpUfbFsXHBuWE2dFadsPOGiASxtxLZ6ABJW830+ZqoFODoJvK6gFNwpmLgrxLYG70n5fmaAk/mPHxJJPgN8eRVWxfxV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:52:28.8141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fb5536-1b81-46d1-bd97-08df3e4f8c6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB333896

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The series is not bisectable on confidential-computing (CoCo)
>    guests.
> - [Low] The commit message understates what this one line does.
> 
> --
> 
> RDMA/mlx5: Advertise adversarial mode via ib_device::adversarial_mode
> 
> This commit sets ib_device::adversarial_mode from the
> mlx5_ib_adversarial_mode global in mlx5_ib_stage_caps_init(). The uverbs
> core can then report adversarial mode to rdma-core and only let
> adversarial-mode-aware userspace open a context on the device.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index ace4cdc95c9da..f8af90941b53d 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -4778,6 +4778,7 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
>>   	}
>>   
>>   	dev->ib_dev.use_cq_dim = true;
>> +	dev->ib_dev.adversarial_mode = mlx5_ib_adversarial_mode;
> 
> [Severity: Medium]
> Can the series still be bisected on CoCo guests when this assignment
> comes last?
> 
> An earlier patch, "RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from
> mlx5_core adversarial API", sets the global in mlx5_ib_init():
> 
>      mlx5_ib_adversarial_mode = mlx5_is_adversarial();
> 
> This comes from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT), so it is true
> on any SEV-SNP/TDX guest.
> 
> Next, "RDMA/mlx5: Block generic CQ poll path in adversarial mode" adds
> this to mlx5_poll_one():
> 
>      if (unlikely(mlx5_ib_adversarial_mode))
>          return -EOPNOTSUPP;
> 
> That patch says this is safe because kernel ULPs don't bind to the device.
> 
> However, kernel ULPs only stop binding once ib_device_check_mandatory()
> sees the core flag:
> 
>      if (device->adversarial_mode)
>          device->kverbs_provider = false;
> 
> mlx5 doesn't set ib_dev.adversarial_mode until this commit.
> 
> That leaves a window from the CQ poll blocking patch up to "RDMA/core:
> Report and enforce adversarial mode via GET_CONTEXT". In that window,
> kverbs_provider stays true for mlx5 on a CoCo guest.
> 
> add_client_context() then binds MAD, CM, rdma_cm, IPoIB, SRP, iSER,
> NVMe-oF and the other clients. Their CQs use mlx5_poll_one():
> 
> mlx5_ib_poll_cq()
>    cq->poll_one() == mlx5_poll_one()
>      returns -EOPNOTSUPP
> 
> mlx5_ib_poll_cq() stops at the first non-zero return, so it always reports
> 0 completions. Wouldn't MAD sends time out, the IPoIB TX ring fill up, and
> NVMe-oF/SRP I/O hang in those intermediate commits?
> 
> In the same window, legacy rdma-core would still get contexts, and uverbs
> POLL_CQ would always come back empty.
> 
> Could this assignment move into the patch that enables the driver-side
> mode? Another option is to place it right after "RDMA/core: Suppress
> kverbs_provider for adversarial_mode devices", before any hardening patch
> that changes behaviour. Either way, every commit in the series would keep
> working.

Setting ib_dev.adversarial_mode declares that the device supports 
adversarial mode, so it is done last, once all the hardening is in
place. Adversarial mode is not expected to be used with only part of the 
series.

> 
> [Severity: Low]
> This isn't a bug, but the commit message only says:
> 
>      Set ib_device::adversarial_mode during capability init so that the
>      uverbs core layer can report adversarial mode to rdma-core and enforce
>      that only adversarial-mode-aware userspace opens a context on this
>      device.
> 
> In practice, this line turns on the full adversarial policy for every
> mlx5 ib_device on a CC_ATTR_GUEST_MEM_ENCRYPT guest. The pf, raw_eth/rep
> and plane profiles all run MLX5_IB_STAGE_CAPS.
> 
> With the flag set, ib_device_check_mandatory() clears kverbs_provider.
> add_client_context() then skips every client that lacks no_kverbs_req:
> 
>      if (!device->kverbs_provider && !client->no_kverbs_req)
>          return 0;
> 
> Only uverbs has no_kverbs_req. As a result, MAD, ib_umad, IB CM, SA,
> rdma_cm, IPoIB, SRP, iSER, NVMe-oF, NFS/RDMA, RDS and SMC-R no longer
> bind.
> 
> Because cma and SA never bind, librdmacm users going through ucma can't
> use the device either, even if they are adversarial-aware.
> 
> Unmodified rdma-core also gets -EPERM, both from GET_CONTEXT and from the
> legacy write() path.
> 
> There is no opt-out, since the decision comes only from
> cc_platform_has(). Other patches in the series say this is intended, but
> this commit is where it takes effect for mlx5.
> 
> Could the commit message say that, once this is applied, kernel ULPs and
> rdma_cm-based userspace stop working on mlx5 in CoCo guests?
> 
>>   
>>   	return 0;
>>
> 

OK, will update the commit message in V1.

Yishai
