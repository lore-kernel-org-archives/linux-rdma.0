Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A7744AB95;
	Wed, 22 Jul 2026 08:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709948; cv=fail; b=K9PU4FtPyoxcoag0krMJa41Pgx1xE1GPGEBUZlKz6HCx+Q068/nVL0gVl2+EMoYLasZ2vmCwVOoQXMzfnDRQr1Mf2loiQEdhgNGY3oG6xIJ+jP/EBR8oJBShDW7FI9KhGqsO/q+iz+Aa1ywpkCQDQq49iNshsRMmfUWXb5trVvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709948; c=relaxed/simple;
	bh=OitWRKnFHRQUcXWHz7A0og4NvbsvCQTy4BTGfPduUUs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nb3Ao5FC0c5ckzGNu/xluT+lhe9qY0yG3JUI+ajijjNM7eh78mDYAE2ooZzvLvi2xTy+atlYlTb36qmfxXrx3A1ii8A/wBygrcwa3V5wfnHOp6BdgLU++NWyaUxt90zhGU4JTuwAMn0edFAeumxze/XP2byMoPIjbsDu1Y6qEU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4JN0n6eZ; arc=fail smtp.client-ip=40.93.195.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4JN0n6eZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RJ7QkQrET/UuUe9WEWqfF4e4snKrHTnQ/lZA6GL6llNAmzikBwYLLOE2dtAv3I9mQnpxC4F9vDrXPmQvVl0ZzV68G5fJDlZNVBSpFl4DXFWlp8jvjcNMo5/D1MMgto6sIHYuVuyxxX4KcTX0UOFLMEPjD6EU7s6JI6yH4Xp/LAZTz3MTciBnrmfPa0i2C5haTKGPmi/5rd9kbWt2wo+ATI2b9ds+0zAGd/5AbwR+go4/nz/6wDQGOZcxYiUtRpZVJCzz1AxyqXM5F6Sh96BSEx2EpkyjBzy8JecerX/hgrmATPS48eCNGO7OGdaznaVTlq6ZnDAT3sWaAzGxwnQTNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hi7hwlOaZ1ZvPidzQJr4V2AIzZlsYKzM8G1ny4h6wVM=;
 b=r4iNVLREIcbQmGhx1jNDMOBFbBRY1VkJfIQlnuXsMk0cBw5OURaXlv24le9FwEvsD6kKuLOPkxRd1mm8/OdPHRPBwUaVNBX7xW7HxnRxRzO+lzRVUA7VBkYHbVQ9c5kESVgXfw8IQK7sSzwj2gKlwrt1RAKhodnd8AegdGuf7ozILyZ6IpxqwVRFWvTZqSt65l/utmGelcIqSqNLjGexxPIQQfjNIx7BfmzHrQMbQE8bL1q1Qt1SORinNb5asmp/K2Z14bkeV5u5u6wOz4UIjeEZNVSuP0JhVVsxKXlW+B909mCSm+3pV5u5pSNUd8vn9rOy7xzCXb7ilwhJCW8+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi7hwlOaZ1ZvPidzQJr4V2AIzZlsYKzM8G1ny4h6wVM=;
 b=4JN0n6eZEpTjaKGioaLuwIZTDAl+1lfmUMn4S9sS3JzeDskj+10os5uvelXzeE/trQPhr4huJoNldEeK6ZDJON4Q0mf2SudBL/pwtbKagIxDvMOsLP78YO4cLRg+ZAxiZwPR7ntPxs9MlJYwcZBGsB3El+GHBGpjTJKm7kaozHM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.27; Wed, 22 Jul
 2026 08:45:42 +0000
Received: from DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74]) by DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74%4]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 08:45:42 +0000
Message-ID: <f9757427-8ada-5c3f-2177-25750af65dbe@amd.com>
Date: Wed, 22 Jul 2026 14:15:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, kuba@kernel.org, davem@davemloft.net, allen.hubbe@amd.com,
 andrew+netdev@lunn.ch, brett.creeley@amd.com, edumazet@google.com,
 pabeni@redhat.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
 <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>
 <20260716080110.GA70906@unreal>
 <7b5f02bb-26db-175e-34cc-40318b0752b2@amd.com>
 <20260716091916.GC357857@unreal>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260716091916.GC357857@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0267.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1f2::16) To DS0PR12MB7777.namprd12.prod.outlook.com
 (2603:10b6:8:153::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7777:EE_|MN2PR12MB4344:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a9e0bfe-340c-4d61-3032-08dee7cd9cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|22082099003|18002099003|10067099003|56012099006|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	StZtq7TZI4Fe93UtsVpQAJc9ajv0s6cyoW7/OaerKvkKx9TemoHuhYoaSQY5qIFxFVGYpeXvhoZAVLES+Lkdesx5IIV929W1i7Kfmxr/KJ7IYfLeEHArg4Tmzm50Cuok5vwi6gzieuKmSACU56ypY3sN3uHjaW4VWZt0pTOhuS+wMB4Z4OxhLvPexdEp7G+LsUewDYZs7ibapRoyjxf7r7rZ1Lold47oWFqU6gSxD/hMlqSUUxwbfWh9YaWyoTU9OD0LamCtPJ3p//WHuDKa8gBE69oyZCtIaYqa5NibMVCrW7N3frxta1nYGRbH+zInMdThTYWWBzSLTPFsdecm1CIzBG1i2a3CepuVSvH5+J8lnFLOR4xNzarSemZoQBpK+clbUpF7T0ShL4ZuvEsED8xka86boqxGVcXTwQwFoiy3x9qAe/yeDz13lU9jRj+FlukeDIKz1Ma29OUrvhFgVQ6Flm/GT1FVuU3ysFQTBxBQIYu/XjdOehP75CEO8Lks2pJ1SJ23m+DciAH68vdpa67a+5hxfPD7kfpeb2sRnlXPy+7xsjwPxDZe/hX0gGMdKqdZv6NN4T2vXLzA/nnS8b1SQsnttV8LbdDzjbTf28pWT9H9TNZmfIt55Hq+EOeC2vNMaHBAvHq5ijl/fBEcsnEwxTOwXQG8Wn1UHFo6QBk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7777.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(22082099003)(18002099003)(10067099003)(56012099006)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnNHc1I0UWYwaG8yOXl2a2M4U1VEVWVlMkNpRm5PMytxT3pXb2VDOGxvSFJ3?=
 =?utf-8?B?ZUJQNEl0a2FyUVBCR0NUUElwSnNkNmxCWFFBZG9XelFUOHNlcGFKMjhVSDFl?=
 =?utf-8?B?Q2FkeTBpTmZMZFJodUJ2djUwRWRMSkJsSW1JSCtQUU10YS9QVkR2K0cwdmFJ?=
 =?utf-8?B?Q0tGT3JuTmNSRHFLdkZIdVZ6UnRlemZwRG5CWnVOdllFeXlKYkxFK2F1Tko3?=
 =?utf-8?B?V2tZa3l1VUdIdnNXbVRTQ3ZwWDNtaE10S3NscDVpME1uM25OVHhqUStzdWxL?=
 =?utf-8?B?UTBQdWVVdXdFSWEvS3gvTzY0bURrVUphU3F6ci9GQ1NxUngvWm1XSzh6dmZv?=
 =?utf-8?B?dFEvdDVMWlpWMm9QeVlQYitPa21mSmNyTWRNYUVWRmRuQzhjeERrNVd3SGJ5?=
 =?utf-8?B?VG5KZjhGcHloSlJmOGlSWVF1MHVtOWZtSG5nbFdBckpBdlpUR3dFNmNleExv?=
 =?utf-8?B?aE5HQ0YrOUtYVk9TZXZpZ3h2dW9NMDdGeENkblNIVTd0cEdzbG4xaGRQTmJF?=
 =?utf-8?B?NTlLQUZRMGprM1NRY2ZwRHluaHJ3bk8zMlhMWldqRVNtSmkzOGE4OTVIWmoy?=
 =?utf-8?B?dXZOeW80b2IrYkZvQXpTZHJJK3FMODgxM3NKU0tidkl0U1o1QjBOQnc3R3pX?=
 =?utf-8?B?TkJqSkQwekJ6dXRKRUt3TWVDOEhhbmVOV3NQdTBWUWhaTE9TVmxUWm14K2Uw?=
 =?utf-8?B?OHV4dFgyTEIxalBUL0Z2S0ZFeGdON0NYQ0FYQlBYNm5hNWRVeWJSeUpteGdp?=
 =?utf-8?B?ZlZXN21ERDlSQjhOM1p4cDVpY21tMmxHd2duTUNqL0hjZkI4RWRDdXJJdUo0?=
 =?utf-8?B?R25jSWdON21FYlAzS0Jid0xvQmZqUzZiUlBXeDdvWlpOSUpxMWNCQmVURmIr?=
 =?utf-8?B?UjRSU1ljRWg0WUd5Nnc4Z1h0TFlPQ2krUGJFeFE0TXdLclRzL2NyQ1NMSE5Q?=
 =?utf-8?B?aVB4VjZEaC9QMXg4bmwwem5zNWpQSm5sNGQ1bEUweVZXVGowc01xTmNxMmJV?=
 =?utf-8?B?Wis1VnBpQlN0cmg0QnVDTksxSlNNMzNSNkIrUUZ0VS9rbnZWNEZlVXVSdWFQ?=
 =?utf-8?B?SzkwYjI0bFVJSlRRbU9RS0t2NHhEYTRHZjF3TkJnOGZEcDJhYSt1YlYxTHQ5?=
 =?utf-8?B?aHp4ZHpYUkxPTEhoQjNzK0dzY0NNQzFUZEttNjJxLzQybHp1WlpTSHV5dnA1?=
 =?utf-8?B?RFVHOUZDOElGVmU1NmpBb2VIbHAwbE53ZTJtR2pNOXMxOWQraElCTnUvVi9P?=
 =?utf-8?B?U2FGSWdxSjBiSW1Zb0E4VXVNMjgyTHdaMUVGTWdpdW01NE5NNmJBUFB1elRE?=
 =?utf-8?B?K2ZScFlQc0FITUhYMCtseUFxQlhaeEJ2SU15S0dZR1hCNllFbmFaOExmZUNE?=
 =?utf-8?B?RnR5V3Z6Mno4YmROcGJualpVc0JlOW44MjBPR2tNUlRMSUI3LzVObUgxZzdN?=
 =?utf-8?B?VmZ5ZmloUnRjdGJzV0t3VG1MN05WL3BzNFUyK2tSQ2prTXp1Sytsb1RLallY?=
 =?utf-8?B?OEZuTjNhMi9IWDM2OWdIalNrNmUxeWl1MVlYazd6S3BCdERKd1VWN2dGSjJw?=
 =?utf-8?B?bzNrK0pJeW9wWS9xbUpiVkxCM1VpcEZ2NkhNMFg5NzFqUVJTeEIxeWtXTmtl?=
 =?utf-8?B?akJNYThqUnF3RmQ2dEdOYU8wWVdUQUhYNkoxbytZeFcxQU50RjhxakJZUGJy?=
 =?utf-8?B?cFFTRmtKWFlhdi9oRjJQdk1iRmFCRXBVb3drT2VBZDhrZkR0SEpNY2hhSFdH?=
 =?utf-8?B?SEhsN3J4bVAxY1Jlb3czYzVQMlp6a0F1c0haTFEzL2pEOFY3WGZZcVc1cWtq?=
 =?utf-8?B?OGlnb2RUZURsRnlpUmZZT3ZjSFNydXBFTktaTE1VZ3R5TVNRUTFMSnljMTdV?=
 =?utf-8?B?aE5Jb29PVlllK3FVbEpBRGx2ZVoxYnJGbTM1R3psTzlBd0s5ZTRiN01mM3k3?=
 =?utf-8?B?QlZtaTBZTVhwWFVadjEyN3kxQTF1eDIvbzNVUFNRU1B4U3pielFia2ZwTWhK?=
 =?utf-8?B?R09BNndBTmtzcENWTmdkZnJFY0x3RmVQenNoWW1XM2c2dHZMdkV2cTVvNnI1?=
 =?utf-8?B?UFQvWWxvcVFIcW1PZ1NiZHNmd201TmJiUU5lbzlFOUVxQjIxM3VFSXM0dHlU?=
 =?utf-8?B?bmNaRWNJQ0p6SkxvV21xWjZlWm5TY1FsYmYrZnB5bFlFc3o1andQOWdWZzcy?=
 =?utf-8?B?NDlkandaNkZVNnNHTkhYeW5yREo5bWUwempCV3ZkS0x6eTZLMHFSd3dBT1lv?=
 =?utf-8?B?SEdOa21peTdFc0l2cHQ2SHg1Z2VQdllGRjkweGFTZmRJZTcrWHA5bTdmMm1o?=
 =?utf-8?B?QlJpeEN2ay9ZekNOL2k0T256d0ExdGtiUEU5TFZIYXF1RUUwaEQwQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9e0bfe-340c-4d61-3032-08dee7cd9cf7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7777.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 08:45:42.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cf+E7zmhyiPg3Ftx8XshpWLBcUBYjvb84BqfcsywUDKUZWJSfy6iYBi6Mm47Pxu7kNrHQ34nv5hSLAyUpq4y/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344


On 7/16/26 14:49, Leon Romanovsky wrote:
> On Thu, Jul 16, 2026 at 02:26:22PM +0530, Abhijit Gangurde wrote:
>> Thanks Leon. This is already addressed in https://patchwork.kernel.org/project/linux-rdma/patch/20260617132605.1888205-3-abhijit.gangurde@amd.com/
>> which was sent after this series. Happy to rebase if needed.
> You need to rebase this, as we moved ib_respond_empty_udata()
> from the end of the function to the beginning.
>
> Also, please send this as a separate patch or series.
>
> Thanks.

Hi Leon,

The robust udata patch has been picked up, and this series still applies 
cleanly on
the latest for-next. Are there any remaining concerns?

Thanks,
Abhijit


>
>>
>> On 7/16/26 13:31, Leon Romanovsky wrote:
>>> On Wed, Jul 15, 2026 at 06:38:06PM +0530, Abhijit Gangurde wrote:
>>>> Hi Jason, Jakub,
>>>>
>>>> Gentle ping — if there are no further concerns, could this series be merged
>>>> through the rdma tree?
>>> Jason requested converting any driver that extends udata to
>>> use uverbs_robust_udata.
>>>
>>> https://lore.kernel.org/linux-rdma/13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com/
>>>
>>> Thanks
>>>
>>>> Thanks,
>>>> Abhijit
>>>>
>>>> On 6/10/26 21:12, Abhijit Gangurde wrote:
>>>>> Hi,
>>>>>
>>>>> This series adds RDMA completion timestamp support for ionic.
>>>>>
>>>>> It enables PHC registration for RDMA timestamp capability, exposes a PHC
>>>>> state page for safe user-space reads, maps that PHC state through RDMA
>>>>> ucontext mmap, and extends the RDMA CQE format to carry completion
>>>>> timestamps.
>>>>>
>>>>> With this, user space can read completion timestamps and convert them to
>>>>> wall time with low overhead.
>>>>>
>>>>> Provider's PR: https://github.com/linux-rdma/rdma-core/pull/1724
>>>>>
>>>>> v4:
>>>>>      - Added alias mapping of mlx5_ib_clock_info to ib_uverbs_clock_info
>>>>> v3:
>>>>>      - Renamed ib_uverbs_phc_state to ib_uverbs_clock_info
>>>>>      - Moved mlx5 to use the common clock info structure
>>>>>      - Addressed review feedback from Sashiko
>>>>>      - https://lore.kernel.org/linux-rdma/20260606050003.3648306-1-abhijit.gangurde@amd.com/
>>>>> v2:
>>>>>      - changed ionic_phc_state to ib_uverbs_phc_state and moved it under
>>>>>        ib_user_verbs.h
>>>>>      - https://lore.kernel.org/linux-rdma/20260512092623.1157199-1-abhijit.gangurde@amd.com/
>>>>> v1:
>>>>>      - https://lore.kernel.org/all/20260401102501.3395305-1-abhijit.gangurde@amd.com/
>>>>>
>>>>> Abhijit Gangurde (5):
>>>>>      net: ionic: register PHC for rdma timestamping
>>>>>      net: ionic: Add PHC state page for user space access
>>>>>      RDMA/ionic: map PHC state into user space
>>>>>      RDMA/ionic: add completion timestamp to CQE format
>>>>>      RDMA/mlx5: move mlx5 clock info to common struct ib_uverbs_clock_info
>>>>>
>>>>>     .../infiniband/hw/ionic/ionic_controlpath.c   | 34 ++++++++++
>>>>>     drivers/infiniband/hw/ionic/ionic_datapath.c  | 43 ++++++-------
>>>>>     drivers/infiniband/hw/ionic/ionic_fw.h        | 12 +++-
>>>>>     drivers/infiniband/hw/ionic/ionic_ibdev.h     |  2 +
>>>>>     drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  2 +
>>>>>     drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
>>>>>     .../ethernet/pensando/ionic/ionic_ethtool.c   | 12 ++--
>>>>>     .../net/ethernet/pensando/ionic/ionic_if.h    |  1 +
>>>>>     .../net/ethernet/pensando/ionic/ionic_lif.c   |  5 +-
>>>>>     .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +-
>>>>>     .../net/ethernet/pensando/ionic/ionic_phc.c   | 63 ++++++++++++++++---
>>>>>     include/uapi/rdma/ib_user_verbs.h             | 33 ++++++++++
>>>>>     include/uapi/rdma/ionic-abi.h                 |  1 +
>>>>>     include/uapi/rdma/mlx5-abi.h                  | 15 ++---
>>>>>     14 files changed, 179 insertions(+), 48 deletions(-)
>>>>>
