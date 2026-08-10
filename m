Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65613E2AD1;
	Mon, 10 Aug 2026 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368456; cv=fail; b=f1G/Cvd08gK8RXr2/Q/6tJo61kEKQCglncxnTjPbgasyNu/saQnCkPLJP7UoQwYulG09gUghPm40GEr8Od9DEFLxFkzSFjuWZzzZ1Y0MixK+YVT5chcq9XbnMICSh2R/br2qwjUH5J6GAbvlSMm0fM2jazpgqKy6OBHjqhAK9dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368456; c=relaxed/simple;
	bh=lVTYQti5CVnrWGdAlfhWX96TwAQJ+lSQP9dSyXKrZwU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WRRVP5kk8whPERLoqawDbxOqS1ntwMYEZtyNgXJ0kFD9WZAmMiGHyHzourdbNknXyC0Uhr1CKWUKZJURvDwxtfbCfmw1A8MDftdSM3IBu9Fy2k90DWGDNZGfVVOT6h6hUIPLI6z1PDeDOGKoU+oL78b+GNGph5zud8fe+KrvYUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zj3Iatw9; arc=fail smtp.client-ip=40.107.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zj3Iatw9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJyuDksA7fT+k+fRmpkFSqQZqledJZoJg/bUizuMQVtsjbdRY/IRDIQdMWq2THS27A67oxgZixlKzvozG10INqMd4pv2AlEDGvK/JVsp8EPQzzaxjrxZuMupnAyTv691+buX340uF4C9CrUK7HRhiTSDOv2bfP5cNOSedXZMAmheln7ORBjYnytDy9dno/k17JadzhzvmMPlfPe0sIFqSUwEzr5+2ABUzWoKqGZDltlxvMN0un1J1DzM5FWOCrYCmMlaUd/UixsOAEuNrsfQ0r7au+SXAPSDQ426JoJ4vlsEz45USydamdWCd8/oaZabQJuiZc5YKVYSJqOkvXWYEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMud5fNTiDRY6wR8kxmgnGkE/2AnBWyfbYkyv+7NKdI=;
 b=vweo3QSV3uvr6ZCnOV9VNqG/F3NBmmAcDaK05dde+bXhlu7miupIP2kswxp+CIbVy30V7aB6TOATwRyEQPQ7aqhcgAsOKngHnyQQsD6BrtL0qpGZfNHtNpo0uY1Xx8FNeSnN2zRq0+74HE2QxS1O4KvcB9R5DVq0HP/rxIgI+5WRm13ZOCHq8lerDkfSViuJ+QctFw/Dqpn2whkCpaPKCrPyAvzFzn/kX+Vi9Gl7U7Edt0HRZnl9KCA/sLpAywcoGQETxrQW4vHir47k490UTtLEL9/4EVPUKAjxXwTyJ1WZuHJbaxPuzdrxPJ+gFlKeOl8kptLSO4VNoPNrcq1nbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMud5fNTiDRY6wR8kxmgnGkE/2AnBWyfbYkyv+7NKdI=;
 b=Zj3Iatw9DWNIXQj6LUdphX+amzMz/eKEWlPwbVk7qVjLs0q0IwXVnk8IURa2ZSfcrtV5JIvks1uiTOvlm8hbRj81Dj8wgR6vXVfZ8EG7cmL/4TeByCaLRRCNni9Z1kqse7VRceo3Dd4WsPGlGGd/0oWPYfBDIMjPWyuAtgjpXa0RP9/NG6/342ZEXOasDsHHqBU1C65ku/Yo0Ep53byPh0qL4qn3eMHGPWZB/GEKZVfv3f2r5XAqvN0XFvbXsHoZdHceqMEzIiL4ab0B0TwmyQuM1yhC6qj3m4qeN6tK65+rg7vfvxYuZ3qFkE2dQjKAfi8aOwduCBxQg4Sas5I6ow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by SAWPR12MB999115.namprd12.prod.outlook.com (2603:10b6:806:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 13:27:30 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 13:27:30 +0000
Message-ID: <0fc0b0a8-3d12-4835-9766-f036b051d4f7@nvidia.com>
Date: Mon, 10 Aug 2026 16:27:26 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/15] RDMA: Support HW requiring relaxed
 ordering and add Unordered access flag
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 Edward Srouji <edwards@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260810130510.GA90355@unreal>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20260810130510.GA90355@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|SAWPR12MB999115:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfb8c47-49c3-449e-49d6-08def6e320db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4143699003|11063799006|10067099003|56012099006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1CdZYHEAleDT54qHmLkdNHtZCht6gK8BrWOvA0VAO+eFVpNE3V0MfFNdYhhbeu9zRVq/MjkCBponq3jXlWHqMwF9CI7gFcbn6C5Au3c3jge/S6UOQk+64yW9aqS2wTKfZ0BmQ450w5H/xsuWS2mmL8wFdK1oub2n1H9bq2NaD5TEMyE/c5kzALC31EB0sQvfanfvpou93CCxkuIMzW44tFBweeNW7aaMTv7qec73NoUd0qkD+3hduNcQRxkz8HPrh42dKPw+5UDHIZtwVHa3+70bdK12l+6iwALsTketSDcyMAsAEEOwu0vImaDJOhSzF297Ac7CflHQkeUjQmhahjmp7A2s2h3SUSujR1J09j3pB+42ouAUE99odJ/97skLWjsdSZ1t4LfNEaKSBOdU2cXzZcJIpkKUCSdeSSmUISzhkiVhxcBpE/mesHyneoSbmDptqQ527U7g/2n+WXU7srkrT4dHZsP7Z7RqgmAc6pzB9nn6Z0s5NG93NlvGcoUBFklSSedjhzmnGKyWE2vpC6wrXazZQSB531ArurxmlWL1lf+9Hi0BxZ0GX5gIDKvqtEpOQ3sacSHxKqMlAawn5VTHwzn8t0wjQCslGhKN0E4Jk4j4gQTZs9MjmQXP19QxD2PD/MXxLmQasTCov+S04S+7C9E84wCr2/GPsopfGRI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4143699003)(11063799006)(10067099003)(56012099006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXFwV2dYditLQTk0UTc5UHZaTy91cldOU21lUU9TTldjRUZ0eWJ0bW8zeGhl?=
 =?utf-8?B?MzQvQ3l2OVFrRUJPeGNDYTlxbGtXODUrVVBWa3MzMW51djhVNjliSG92Y0xl?=
 =?utf-8?B?OUJLcGhwREoranJOL2EvNGV6QWNuMnZYdWFZYTUramY0Tk1WR1ZjWVo4ZjRT?=
 =?utf-8?B?cGtRRHlVVEZBZU1YMnJ1cUJJV0duVkx0d3hhVUpEUXR1TTF6MU5IVXZDTWg1?=
 =?utf-8?B?eW9GZHVNT2pTTjltcDN0UTdVbkpIY1RtczlVWGxMQ2dpa0JUQXZ0VTNtUENV?=
 =?utf-8?B?em5yK2lEQkRobVlZMHVDc0FJSEEyNDYyd0ZYbkpXRENnMU0vdVBMOW5KZDZ4?=
 =?utf-8?B?UmM4K0tkZUx0S3Ara3loYUpmbkwwL1N4QXFrVkVNZTlULytXSEk5Mld1YXdU?=
 =?utf-8?B?SzVnTEFiUXk2REpKNGZpOE1CdTV0a3NMVkdHSXI2UVpUVDlzaTBvSEpvQktv?=
 =?utf-8?B?eWJtRVZldWVNZGtSazBpM01aMTU5UFhFWWQwSHZFWi9DdGRMZTExdlJBWDlG?=
 =?utf-8?B?ZWNTOGd3QWh5V1NGaUZqcG0rZmRsd1RTK1RsczBvZ05iY0t5VzlJelIrbk1l?=
 =?utf-8?B?S295NzhzcmJzQk1jZjJsUlV1akMxZEdwdWd4aysrbHFMMTc0YTR0RmI2czdQ?=
 =?utf-8?B?L25NNGNrTnZDUFd0UnVLUW5FRTIyaFdtZnBLTWs0ZWZiVXNHeDBBSzhLVThr?=
 =?utf-8?B?WlJCV2hSbjVTZXZkdGRRblp5bG5GMW9pRXAwYXhlU013cktrUW9uaEo5d3Vs?=
 =?utf-8?B?L0FoUnp4b2x1ME5IVGRFd0p6T3YzTlpDUnIxVURYYnZ5WVYrbkZTUytuRDRL?=
 =?utf-8?B?c1p4MUpDcGVWVmZjZm44MktOT2k3ejMwZlQ0bW5XUmRTQlo2S2JncVhadWRz?=
 =?utf-8?B?K2dJdlh5Tk9KZkV1ZFN5amVBQVMwNFplUjV2KzBrTElvdE1JTE44U243Z1dz?=
 =?utf-8?B?ZU9pZ2ROSHlYK203UFIrTVU2T29YbXFrb1pHR05WcEYyZittcEsyY0lINkRD?=
 =?utf-8?B?LzZOQjNVNFFWWDZuL3hDcEJVMjhZcmNoUmJDK0RFSDVWRE04dWhsdjJLTW50?=
 =?utf-8?B?RGdxMjFaakhGMXJodEw0THlFUGMxeE4vcXZORGRMb1JaUldUVm5HYTFXOUxm?=
 =?utf-8?B?enJpbXVpSXpkNFI3b2pqMFpFcEpmcTRrUnBvOGN3ME1kQUhiZEcyaDFjOXpK?=
 =?utf-8?B?eUI0eGhYWDBvcUo1L090dEJackhtUkNlS24xcEFWVGhsQkMraWt3MUtMdUl1?=
 =?utf-8?B?VStnQlVtQXFVRzBKSTh0Qm5RZWw0am4xdWw4Sktqbm9MTE44amRORERFRGFy?=
 =?utf-8?B?aEZLMnNlMUJBdkM2NDZYZUtudUxyQXZFelNoTVNYR0E4Q2JTTlNxZWdyaWY2?=
 =?utf-8?B?QXVYYlUwdStuWktqSkZHaHRQZG92NVVoZ1dVaFp6NSs4cmZ5K2I5bDBraVZM?=
 =?utf-8?B?UzBlNmd2R2tkL2syU2Erc3J4ODlKUTlpZ0pESURUbWFrS05nUkh3TnVXQ0Jq?=
 =?utf-8?B?TmdYV3k1aGtpSmk2RCtHV0grZmlaS3RyZE5YQytTYlNJbFZuREQ4OU9mL2dZ?=
 =?utf-8?B?bHJOU1VabUN3SUhqb0FudEQrRzVlbkdPRjk4TXV0b2FrUW1GUDMwaGcyWi9l?=
 =?utf-8?B?RjFSUDdSYjhqaXEwVFhSeDJxRXZzYTg2QTY2aWdiZTI5RUx4WndXUFdQSjda?=
 =?utf-8?B?VkY2S1FLaU85QjJpRllURUZDeEcyV1p4NWpjR3E5M1ltRWlJeHhnbXJiOEV6?=
 =?utf-8?B?ZEo0S29SMU1sTnZZT3ltQmVvd2VLVStXcE4xMW14aytLOGlJaloxRzdYenlB?=
 =?utf-8?B?alZsWWJzRkJta25VY0R5cng1S0FaZkNubEx1VW1KWWZFbHFqdHZncVpMUlFF?=
 =?utf-8?B?ZGd6REoycytBaTMxbVRGQlBzYk82VnJqS050TnpZQnV0dWJFYk1OSFRjUDU1?=
 =?utf-8?B?RW8ydGxXY1hNc1BMdTRYZVJQQyt4Q1puTXBFTnFWOEEyZFJXemlNalczQmkw?=
 =?utf-8?B?MFBTNHEwYWVQbnd5anNlcEsxc2w0RTdFdlVKbGtpbVA4Nk5vQkV5ZE9Campa?=
 =?utf-8?B?RUlpTmJESEcvVGtHYWJhNk5OcVZOazR6akVJUWxJSkw0Rm5tUFA1Z3RjMm1H?=
 =?utf-8?B?emhqcm1sRlplcXBlQUhkN3pibHEySTFvYjU0YTFveFZveUM2YXRXUVFuc0tL?=
 =?utf-8?B?R1Zkc3hnSmc2U0d1SWxmWjJnMyt0TTBrTGhDNVJ0cnp4M1M2U25BMFVwckF4?=
 =?utf-8?B?UmNKME1VTHpDNXlCK0loUEhJOTY4SjlhanRoTmhESUtaNE5NV3pjYlllWE5u?=
 =?utf-8?B?eDZEYm1YbGs2RXhhUTBnM3hJeCt3L2hQS1orWkVkMjMrYWVFU0NnUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfb8c47-49c3-449e-49d6-08def6e320db
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 13:27:30.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiynKdm/ZZ9sKxIYolIJ8AHKmFvFtVc74Zr/G5Jd0HhpeaV18DzoHcnpMetsK9269IbMFZvzxq0+QoiKunzR7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999115


On 8/10/2026 4:05 PM, Leon Romanovsky wrote:
> External email: Use caution opening links or attachments
>
>
> On Sun, Jul 26, 2026 at 12:29:14PM +0300, Michael Gur wrote:
>> This series prepares the mlx5 stack for hardware that restricts strong-
>> ordered memory accesses, i.e. HW whose fabric doesn't guarantee memory
>> operation ordering. The HW may choose to reject creation of an mkey that
>> doesn't request relaxed ordering, so every mkey the driver creates -
>> internal and user-facing - has to be handled accordingly.
>>
>> The previously added 'ConnectX-10 NVLink-C2C' PCI device is such a device,
>> as will be any future PCIe Gen7 UIO devices.
>>
>> The series does four things:
>>
>> 1. Allow optional access flags on all memory registration
>>     The uverbs ABI defines the optional access flags range as best-effort:
>>     drivers must accept any flag in this range and treat support as
>>     opportunistic, never failing registration. Several registration paths
>>     (DM, DEVX UMEM, dmabuf ioctl, reg_mr ioctl) did not allow this range
>>     and would reject such requests. These are fixed to allow newly added
>>     optional access flag added later in the series and any future optional
>>     access flag.
>>
>> 2. Groundwork and internal mkeys
>>     Rename the relaxed-ordering IFC fields to the new naming, add the new
>>     ordering capability and mkey-context bits, and consolidate RO-setting
>>     to a single helper in mlx5_core so all consumers share one cap-gated
>>     implementation. Then enable relaxed ordering on the internal mkeys that
>>     don't require strong ordering (resource dump, vfio live-migration data,
>>     ODP null mkey, memory window mkey), so they keep working on strict-RO
>>     HW.
>>
>> 3. New Unordered access flag and enforcement
>>     Add IB_ACCESS_UNORDERED, an optional access flag that additionally
>>     allows read-after-write reordering, and wire up mlx5 support for it.
>>
>> 4. Enforce no-strong-ordering in user MR registration on HW that requires
>>     it.
>>
>> Michael Gur (15):
>>    RDMA/mlx5: Allow optional access flags in DM registration
>>    RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
>>    RDMA/core: Allow optional access flags in dmabuf reg ioctl
>>    RDMA/core: Allow optional access flags in reg mr ioctl
>>    mlx5: Rename IFC bits of relaxed ordering fields
>>    net/mlx5: Add IFC bits for new ordering caps
>>    mlx5: Move RO setting helper to core and consolidate mlx5 consumers
>>    net/mlx5: Enable relaxed ordering on resource dump mkey
>>    vfio/mlx5: Enable relaxed ordering on the live migration data mkey
>>    RDMA/mlx5: Enable relaxed ordering on ODP null mkey
>>    RDMA/mlx5: Enable relaxed ordering on Memory Window mkey on strict-RO
>>      HW
>>    RDMA/mlx5: Converge UMR access-flag cap checks
>>    RDMA/uverbs: Add new Unordered MR access flag
>>    RDMA/mlx5: Support new Unordered access flag
>>    RDMA/mlx5: Enforce relaxed ordering when HW requires it
>>
>>   drivers/infiniband/core/umem.c                |  2 +-
>>   drivers/infiniband/core/uverbs_std_types_mr.c |  4 +-
>>   drivers/infiniband/hw/mlx5/devx.c             |  2 +-
>>   drivers/infiniband/hw/mlx5/main.c             |  8 +-
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h          |  4 +-
>>   drivers/infiniband/hw/mlx5/mr.c               | 79 ++++++++++---------
>>   drivers/infiniband/hw/mlx5/odp.c              |  1 +
>>   drivers/infiniband/hw/mlx5/umr.c              | 18 ++---
>>   drivers/infiniband/hw/mlx5/umr.h              | 45 ++++++-----
>>   .../mellanox/mlx5/core/diag/rsc_dump.c        |  1 +
>>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
>>   .../ethernet/mellanox/mlx5/core/en/params.c   |  2 +-
>>   .../ethernet/mellanox/mlx5/core/en_common.c   | 13 +--
>>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
>>   drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 +++++
>>   drivers/vfio/pci/mlx5/cmd.c                   |  7 +-
>>   include/linux/mlx5/driver.h                   |  1 +
>>   include/linux/mlx5/mlx5_ifc.h                 | 24 ++++--
>>   include/rdma/ib_verbs.h                       |  1 +
>>   include/uapi/rdma/ib_user_ioctl_verbs.h       |  1 +
>>   20 files changed, 134 insertions(+), 105 deletions(-)
> Sashiko is not happy about this series.
>
> Thanks
Sashiko has 4 comments on this series:

2 comments (on patch 14 and 15) concerning data-direct flows not 
handling the Unordered access flag or RO enforcement:
These are irrelevant as we don't have HW that will support both caps. 
That is currently an invalid configuration.

Comment on patch 3: suggesting we need a fix that is actually added in 
patch 4.

Comment on patch 15: Sashiko misreading the meaning of the cap.
'mkc_order_write_after_write_ro_only' means we must set RO in the 
write_after_write field of every mkey, regardless of actual write access 
flags at registration.

Thanks

>> --
>> 2.52.0
>>
