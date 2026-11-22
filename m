Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795342132;
	b=rezgdXAbRsK6O7UTPjsJoMIyEFW/A7A9v8Bi2ugNT4vZMEUAqyEBaWXt1qlVkDicghIW
	 lzWTn2CCMo6J/Oq12c9cCxNu3XNTflGjrW1Isf0467nyHqyKiBOqAvWFwEjiV5Rupzixt
	 QoNhYUSLp3PIGRlVKbdH9jCulf6ZYjqdJL5ZjpvRSUJl4P8TUBfAoJfARfdikWNgnnKCM
	 d8WmGQmZq4zGJkNOJEGj2Akjh8nl3YFrIAc2UDp7+CUtjdmT0J7qDHxEqirm/lHpxr3tx
	 pXqRbDKGmKU4Ssz8j0kroNIbzZvm4DBURekAaytfkP8XcCrpZL5rZKg7aROyH1slZ/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795342132;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=SFCL+nGTZrqDukoqI+TD4w6kluc4pq0GCHYgZdTvnjE=;
	b=fgDtZSlwNBr0nUfhhk3NCe0U4L2u5wEFztXCYg8a8X7DQKliF6NwhX5DAEApTl3gOlG/
	 3HsVhc1WLnuhFNr6JihEM5LpGa+1H486Da0q39AOoObt4mQlx97rtOK+GwHWzRUbSCJ8u
	 i3QbR0FFmLJq5WRrrdp1R3tNcBg0NtWNEYjrgTYHBEoV3YQJz3ptHkE4ky1KD0aQmQuFZ
	 tm1hK1qA5RXuzV9PGDhT8jtu/gC3K4zkLMLsk8QLEDBwP40vygIcjENIBQub4FT6eQJxl
	 EnecRPRVrCDjYNPkCXO7nqNSlzG7LG/kIMQ+AmjYdOQkB7h0ybNcim0niLivtOcdpjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NRag7HDh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.12
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63593606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 10:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63593606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NRag7HDh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S106L1idqoiiKd/43OrxkH1lTzxcbJfCrQIH0KV849eyMFh8+V9lyOshNJ6/zdA6i1KUhWmarhZHi5iFcadLO5geC2wTTL/RnAVwFHf1cumFeHDW/JO29C6xU7TajTeKKXOzxR2n6GUtga2G8wO4c6YTRJKeUK/DOrS4GPEKzf/MkCuY7V2SvmlJUElp3UsusrvB+siPIEyHSzjtI3X6HEB3x9qkx91PgoWYc+D17IhghzF4o31880rcTaoO8FjXhlp04xjx+mRlVmULvBxfR37K/18EfNeZTqenc/lKfw8ed862fg2V3NIWzlKN7eXuKb8rX8ydylIjieplSxOilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFCL+nGTZrqDukoqI+TD4w6kluc4pq0GCHYgZdTvnjE=;
 b=JzdnK1ERRNuwzHDH/NX8+HPOMdK2nTp23Er7LduoqMjYPgn9aggjGyFPTWYvcXAAcI9rfeOO6kWdSGjyspFKFm12ovCtcZTEJ41BeGFWnnFV2fl5HySGjiF0hjMs6hnyVDnFcMHfJg9ptkKcY464iGMag7wHZALDu8QXs5ko2H6UbmKDI3+h3qMCFStYnQcjeVyuRRNAUA/XDPpXA3goAK6ss+XPzOY8TFD75e64zFs1bt1eaMPq2yjins6jhyvmkrS9k0XumIDHvYFSlXgzGSMD90nw7Q/h2T3K/UQ/vnLzjS7AtmgJTGdRXD6aAjMhkqkd7Kg/UuBsAC1C3lF3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFCL+nGTZrqDukoqI+TD4w6kluc4pq0GCHYgZdTvnjE=;
 b=NRag7HDhVfeh494N528bZgkIhA2Jyq5M0/HS9oM2anq+U1PFCLl2s8Gjw5YOfyiaMyXD2kF/dw9tKCOQDb5IY4zNjN9tn1OlqGbTXTGoC6KhnaKgAvKxLoWwInhoptEtpFnvAb5KisUv+bZGBHvj71HpNyTNn0xKGd//OidD96cptEsaVeDHdxOjeelKl3HkEM++ANMoupfC3aUv9VBrA2TsYseaI9yGeb/aiKF0sSv0ufFhuKab+f58Hzf7Xz2JIAd68135osuNlBLMP51A3aRWQ1wMs9NehiQlOa1RIvysdhi8IcGKF6QdxC8OgGIiFcqH+g0AM6bl/Y8KZXrePA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by DS7PR12MB6046.namprd12.prod.outlook.com (2603:10b6:8:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Sun, 22 Nov
 2026 10:08:48 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 10:08:48 +0000
Message-ID: <45237f26-af37-4390-ab34-8b6cc78ec510@nvidia.com>
Date: Sun, 22 Nov 2026 12:08:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] IB/mlx5: Fix a potential memory leak in setup_qp()
To: Wanhui Fu <fuwh1120@163.com>, leon@kernel.org, jgg@ziepe.ca,
 haggaie@mellanox.com, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org
References: <20261121095902.442960-1-fuwh1120@163.com>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <20261121095902.442960-1-fuwh1120@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0026.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::13) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|DS7PR12MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: 5deb69b7-8361-4bb7-44b2-08df488099b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|22082099003|261009223027099003|56012099006|261102123227099003|261022105027099003|261021121427099003|261026140227099003|261021123027099003|261028144727099003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Gfu9jk3zuwo07Z4I929h5EDgwn2lpafBTlGdKf8fJ1kQQal108FqAqCx68CO1o0ioEpdxuZw/kNZM/RJ73rmJAj0u8N0O57EDW63RhrkByMT5Scn6KPAHsV+ulF2/rSsloaIjm6eY0tYFZUIHmKs+Qyf4tSlrDJeYIGcOvS9EHoxqzFZxHhLcpQa3rnGeP8cuR5x7yLVNJ+meh14t6JGVqJsuO7EbRGwuisP/IdYWGDclfBrytf4kmItw4g6S98vK0dDeSbQ6t55/O4BF3n/DoJWFwSNT3a/9mh6uI4bzn1H/6e/ZuNBlNERmIVrAVnet+cpyHw8NQi8CUVWhvKCAEq+C3IfzmrU/agYICLQV+nlaoyHVP2Cl7ahhGt9s717BRPUInPgrZj1b012DJAvnSQjeIDGR/aRgjILBoHjGqOHaszlIbvU8b2JALsKG+LMdeNhlzsWBAFo7XyjBHZNktF42AYnO4DJqcFV0fE78tXlhK2eX7aW82RwFhSN5m53A4+/tY2jKAEzAfltn0x0u2AGyOKfVvKuw8nxm5ZKWyIJQDTmBU+7h2Kt16uMLUdlwjzo4k+FIiLSfFDJvIGSSPuaaUOT1RhRHVnYzPxySfF9yua6/3Ryt/crmWfSFzvxckzRbYscksOtJ/+XtS5OArne4KjHZOeGEQGxFDr88ao=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(22082099003)(261009223027099003)(56012099006)(261102123227099003)(261022105027099003)(261021121427099003)(261026140227099003)(261021123027099003)(261028144727099003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnlpQWxjaWtNcEJ6TVA1V0tLYlY5cnpEVExSNFJHUlZFRTNpamh6MUdKYTI2?=
 =?utf-8?B?dFZ3NklXYkwvWEQ2VmcrRmh1TExPNTFPMlhzNlZ6WEdIb1YxRWlIVmF0RlFz?=
 =?utf-8?B?L0pGT21OMDd3NVk4ZDF1T1JaeVdrcFNLdG4waERpN0liWWFrNVZ4S2ZjODRL?=
 =?utf-8?B?UGUvdzc1QUVIR1hrSlBYa0dBUUc3YytWYVQ1MVp0SGRnRFFKakNXT01VWSs3?=
 =?utf-8?B?eDlqR0dMcHhTTjBjcFc5dWFtaXNZaWdObjJUdWhyRVdGV1ZTbDc3SGYzekVB?=
 =?utf-8?B?Vno0SjZ4WVVLdi9JcGd5NEJVeUpPelRoc2dBV3lCQ21Qakd3WVFnb1VzZ2ZN?=
 =?utf-8?B?Qlp4cWsrK3NvSXVLU1l0MTdNcnVSV2FXZnVuM0hodDZvSzJVV2EvSUdrRlJx?=
 =?utf-8?B?S3hpOFJyVzZmVGIxNmJJMkxicDZTTHNxbWZjVTVBRFlyQ1IzanhFMzdGNzZH?=
 =?utf-8?B?YmFhaFBMMHR4VU1wd21SQlk2TWZyM1o1b2tlTml5QU5SeENSQXd4QlhsMnFx?=
 =?utf-8?B?L0ZGVGZjVm9URHR1Z214bUpsb2tCeXV3ckNnODlSUzFsaHJjenlGU2FZTC9Z?=
 =?utf-8?B?WnVONlVGQVpycGRKSmxVOXc5cXNJemxmNE5sUEtlRE5sMENDTVRqaFdJT3VB?=
 =?utf-8?B?bFlHWlZnQ0lpV0E1bEgrd2VKbzcyRFBteVZ2S1RtMFJjSVpPUStBQk5PSHRR?=
 =?utf-8?B?WjVDbkdQOGJRbCtYelFGNzFKcTRaZ2dJWUF2d0xxakg0ZEVKN3hGdVFBSGVO?=
 =?utf-8?B?U3k0M2p3aVE5aGdwVHpRalVDbkp6cEZHSWZzQXNKcUx2TndRamhNV2FONzdV?=
 =?utf-8?B?N2lQeFM0Y2FqQ2pJbm9MV0JBTE5ZbjdRQXpsamUvZTFFaG82cTBJMUZZdHVr?=
 =?utf-8?B?QXVBRDdtWUZVMkJ2TEE1QTdIa01SOVJQK1UwL0k5dk1PQ2ZNVFFTMnFKNmNh?=
 =?utf-8?B?Y29HTFN6c2NKbnJzWEtpb1FrUzBmRW4xWkV5VVdGcEZ1N1lEMk8wdUY3VHRa?=
 =?utf-8?B?WVRRQ1MvSWtOcDNFaXhLdWdwMXdoRDc3d05qemoyWVZRcy9QdnlzTXpvOGtx?=
 =?utf-8?B?QlhDTklwZ0lKelJ0SU5kOTFvY1BmNWNqRkQ5U1RtNWlJa2toK0R4d21acDJM?=
 =?utf-8?B?WG84TkRHMW01OTFoNlFNZWd3UnB4T1NKUHVhVXNabE9Wakw1Q1U4ZXNXRzEw?=
 =?utf-8?B?ZExURlV0aGx4cEQwcTJrWFZUY2hPaEtMNGsxV0gwTXZNbE1reWpPZGZLRmxq?=
 =?utf-8?B?ZXlremZ4ZXRWRnJYd2RFRzVyaTVrVk9yT0xJVXQrU3hEVWZRTnFNbTBMRHIy?=
 =?utf-8?B?Nm5vdzVqQ1VsNk9VV0RyWXZqYzZlVmVmT3JTU0JSc1lBQktqNDRSWHpTT2VW?=
 =?utf-8?B?Y1BIVTZ1cVZnUldVOTNkc0FKUnlMc3pVaUtTc0VHUEFnZkZSdmp3L3FyL2dK?=
 =?utf-8?B?RUpQcjdqalluWWhLdlBDSHpZQ05oWmg1NW4vUmtXQVg0SEl5S2MxZDVMNVBQ?=
 =?utf-8?B?ZFAvMXh5UUNYbUpOcEpLcEtPcytRL0ZzMG5RRFFiaUVWM2ZUYlVSUXlEajJh?=
 =?utf-8?B?eDJiK0FCSDQvNFpZNVk1Qi9QT1FaTWgwb2RnQXhXVmFxWW42SWYzVjNTbjZL?=
 =?utf-8?B?Mk9hRkFTT0VHbENnTmQ0LzBxMS83eTNBUUFiMXE2bFpHL2RhZTdLUlUyY0wr?=
 =?utf-8?B?NUFXbHpNczJ0ckI1T090eUllSE9tTzBUVTNzUEdaUElaek1ybHZiY0lNaW1u?=
 =?utf-8?B?Nnh4MkM3UlVXNTJmdlNiaHl1Qm43OUx2b0JUVmdwQVcrSCt2Z0ViZUxtY0hV?=
 =?utf-8?B?UzVTK1ZTcmFZRmh2NGpaRUpZOFJTZzYxWU4zTWh3MUczNjF0MHB4eVVMcWlR?=
 =?utf-8?B?bEl4NE9KTWt4WTZrcnp2L3c5SmdJbmxTTUJxZ3NQSWJ0ekRmQXVqZWJxbUR6?=
 =?utf-8?B?bngvOVgxZ0M4anVxQlV5RjM0MTFSUUI1aWhvMFpjTEJnak54Y0FyOFkxWXZO?=
 =?utf-8?B?SGVHYTJYTWw5WjZ0NkE5NjFwSllCYVJScGQzS1JrcUdpRU52M2ZQZGpCallQ?=
 =?utf-8?B?SC80RjZWaTIxNXY0akgxOXc1Y29jczNWVE5EbjVlZWorZk1uKzN2bnlLRHVT?=
 =?utf-8?B?UUdSR1BMbHY2MUlZeGVLS0ErMDN6b2FuNkx3a2RqTWtOT0Rrc3h5ZHovZUVM?=
 =?utf-8?B?RFJIS0pKdERyQ3lSWUhNU0xDeHlIRm52Ky80TXpnSytiTnA3V3VoUW5GS3JR?=
 =?utf-8?B?eG11WGxPMi8xcVlRM1VvbEJ3aWptajVkSGJKcTcvRVVPQWRrRUR4ZjJ2RE85?=
 =?utf-8?B?V3VzMksrVUs5WStieGw2ZlVCUzBNdExKTW0zMmh0Y3F6REtPYzhtUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5deb69b7-8361-4bb7-44b2-08df488099b7
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 10:08:48.3268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZEm+iAYy794OeslU4UAaFAXKxa/VJlAysyIpA2IcvmtWl1b91buanlSq58hSlA2dx8FxrTpAt+ukYE0pdX1vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6046



On 11/21/2026 11:59 AM, Wanhui Fu wrote:
> External email: Use caution opening links or attachments
> 
> 
> create_gsi_ud_qp() creates a QP but the QP is not
> released if modify_to_rts() fails. Free the QP by
> calling ib_destroy_qp().
> 
> Fixes: ebab41cff4db ("IB/mlx5: Create multiple transmission GSI QPs")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>
> ---
>   drivers/infiniband/hw/mlx5/gsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/gsi.c b/drivers/infiniband/hw/mlx5/gsi.c
> index b2e2a219639d..535a9f45fb33 100644
> --- a/drivers/infiniband/hw/mlx5/gsi.c
> +++ b/drivers/infiniband/hw/mlx5/gsi.c
> @@ -316,7 +316,7 @@ static void setup_qp(struct mlx5_ib_gsi_qp *gsi, u16 qp_index)
>          return;
> 
>   err_destroy_qp:
> -       WARN_ON_ONCE(qp);
> +       WARN_ON_ONCE(ib_destroy_qp(qp));
>   }
> 
>   int mlx5_ib_gsi_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
> --
> 2.25.1

Reviewed-by: Edward Srouji <edwards@nvidia.com>

