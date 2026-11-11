Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794403085;
	b=4ToLjp7MPDMiG4OwAEqiFoI3N3vwVa/VB3XmfybReO/JX/rFnQBNpTky+wY5V+d3NfkQ
	 jQtu9gupHC7EBbe3FQKLpOtHJ/kSSFi1p50Ok6/rZGBCd0xA0DK3l/cUOQJaUIMN2IHso
	 KGrLo0JzgCTO0/XYdumFmd/d3pjIUSJwqI5wfKlXo+E6Wy+XCCEO1h0bxIiSHpKpS9e5O
	 gIO+Moa8YprqkhfyXq9fjLH0jfac00c0UalbiM0YnCVRHqOXHll2oZyRsjF0zujjkntSH
	 O/5acYTfloB6NcptZFL2TEOKkMaaWF9AgP/wSQEWSYrYcwmYafYVoxXKOP7vTdWeBVQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403085;
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
	bh=TAjge+PdyP6zyxLitLFtlCERzibrbGDExQXYlOinVos=;
	b=olMVmEmNl/zSAauJkdxV53JCKHAe0yiTdQIchMkpL+0EC9wbcIRkvlmk56MXq1zHnPvs
	 voqVN15VbTMW6KXh6bLMuZIwQUOVAcSYbScinCSjhhz38o80shmRxUDwchBnwfGQjfJlW
	 RtL5cNrAt7pkiG9qlUt4gWzH45P+3L8l+GytsyHE1xQkW7+HK+BoUnvLCe/Ky5b5/eTqJ
	 tYIo1bIbZ4aB1Ay/Fv6OTmwrQRJkxlnOPPOkVq6PvSqCYmbCzG88qp/5K72gqppMUVAqB
	 DYj6/U9BWNNnh7+GfPt50UtdXvS04JSyqw7mMvV+MXrzDRC5MvkHQsu2ifGgkH2OLvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lGsn9XIJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.38
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012038.outbound.protection.outlook.com [52.101.43.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2D606A324;
	Wed, 11 Nov 2026 13:18:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38D2D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lGsn9XIJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/cffxBiNQ5LY5U9DwqAHTa0j/lkbV61xlK47nckqS/y6Vxq772Ui9dv04EPhkq8QBMz/F7Aph18/HmUIQhH1WsiKjZgcR0jUbTL/A+gyc+G9VC7fCFwhzwfq6Sux3Qds+O+ENzcjAhCdsuAd8Ap++azzA6FGaHd2ARYLOlisadsr9a/L2KJqG8sK518Ed5JyVl61x75mwUrDiK97OMKpJlY7F75Hy4LIBSe6UCpkQtf2wt2y6yBLaIXU99/8sD3GD9gas48wNynsO0cwNNNZZqax0hIAES7cpJF5tm9/8sn1KFpaV2lL8A/tk8zWkRAV41OWQZEGgiaqQRg4zv59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAjge+PdyP6zyxLitLFtlCERzibrbGDExQXYlOinVos=;
 b=tEeAJuNCc3T4RXZa5ct3fOiGDPY+NvVTFRFK6Bgvk6V07p5BKkgdQHNHAvipdG4fyvKEYpLrv1lzdZaKj+eFxUHj1XzXkbyGFuJXJ09SQB4HYOaDvdSIOVUKYeolJZGqnKKcGT3VTXYLcUTlrqCzeMWygUBnFCWCVkHZLUlSTaRkUXAhZI+pzD00WOWBg3BBCCkLSXn8/hUaFamDBJqNmbY6KuTUXY2LwaQ46pGxkpcGVZ2tH56Nh/bz5FZCnLsNOo/8epAv5BrP7pc5lF1YJ2EtmqKlenGMy0n9U2UW3nm59qQAvz3EycIn5pEen1XVia7yYyxrCVolv19mXu4c9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAjge+PdyP6zyxLitLFtlCERzibrbGDExQXYlOinVos=;
 b=lGsn9XIJWgiWk8ghmWx4xR4PQpTYo8HVO6iqajAk11ckq6EKT3f0k+hoYx2tfIHikg4HTtbnl9LGwZjtk9rKbFgWpdfX0l3/x5RxOflQmOPbzqpW3AK4x3IiTj9/kZjeT61wS2xv18V7UEcFxn6qX7YXrimcXOZc4fbEYPjw3PLOdYPhj8wz5D1UMgfSP4BNVs3mJWo5KVVuQgBvTzgjpzi5qlS+cTdD8lzvsdQ/TRAm4/s13gE4CVEW32PHvzDtTvsx6z1ZakllYOox+Ob0x4YBUKABy3tNfcI5SqbbAqhYd8v4TQ7P4GNylqT1+ZZZSsJDlZN1tOY+c7TtOkSfFA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by DS0PR12MB6391.namprd12.prod.outlook.com (2603:10b6:8:cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 13:18:02 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 13:18:01 +0000
Message-ID: <ff41e0cc-94e0-49c8-a83d-7d602cb4d884@nvidia.com>
Date: Wed, 11 Nov 2026 15:17:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 1/2] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Yishai Hadas <yishaih@nvidia.com>,
 Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Uri Dar <udar@nvidia.com>,
 stable@vger.kernel.org, Michael Gur <michaelgur@nvidia.com>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
 <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
 <20261109144829.GM663069@ziepe.ca>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <20261109144829.GM663069@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0027.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::11) To BL3PR12MB6473.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|DS0PR12MB6391:EE_
X-MS-Office365-Filtering-Correlation-Id: 501fc2f4-3486-45dd-7e8b-08df3ff635dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|11063799006|4143699003|56012099006|261021123027099003|261022075727099003|261021121427099003|261009223027099003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kbVMqB0QcT9E2WyIAMPa30W3zZxAFYrfbC6DsuJz5gGjZhzJrddhb9+VyqQpTuSakNUPz5KM8p9XgsFaB110Ha2ghYh6Z8kU2QstkTZsOJzyHTI/hkuFRTdLxDcr/tW/vB1zHerNDBmteeWPF/kZhHj97BdMI+8achqp5skVYb4/CWcvzq7IOvbhTnIO7kw8uDgTjyonSDXGI6TbS8iHfVRqI9z8rBkzYPeq58P+wehQpvU3M6vbByJcyctxO1mU8acsO3ZZnEuAmQxboguG2fA04WKSziBIMZWSYN/K6hHeY5vu1r32krMHK3o5KucSV6W2bLH0SqqWoJuxoqZl+QhAjWC4DYlBITl+zPtqUM2YiuTKDO+FkJCe3/ReZWYnPn/zOCpHSaHMh675mk5Cm15zFsSrGdpiw6WVnCDvScr1+l/n0ZDQC4Mz0dVYXNhESsDQY+LVAcNRuo1sn1h9lEVU2hdHdBdvIgYJjhv0j6IluBGUrlIdpbPpQfUQWhEJs/rNaZtTLAfoStsPOizWufsBxuiIZBQBE3KmblgT2W498j6cUoP+IOdapT1UD8XqrCjENU3kJwuihTBilOMaLyH8UHpdhEHrswTF1OPLd1vze7bi/EYfhATHGU8EoDb2oNj7PXprdd95pQ+Qx3BDPAoWF1Iyx3Uxd6/Q2SWrRMU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261021123027099003)(261022075727099003)(261021121427099003)(261009223027099003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEJIZHpqcThrS1BUV3VodDV4R2c0RFdhT0hEWm50N1R5dXFxTE1JSE1TRTg2?=
 =?utf-8?B?MmRaN29nQnA5aXdhSWUxd2FEc0ZJZFkvUXZaNkNWZzJUMkJ1d0F3R004L1Js?=
 =?utf-8?B?aG02RXdBZjl3NFZ5VzdUL09zSjdYUy83Mm92NlgvM0hDS084ZVBXcU83eVg2?=
 =?utf-8?B?d096dGllUXZ3ZHRDMk53WmZLTkNnSjVtTkx1TWw5YjdtMjNuUEVkelloRmZh?=
 =?utf-8?B?SzZKMm5NN0VGWVUwMWV2UzJlTXRTODZ3cys2YXZYZ2FYVUlRd1hyQXdrMlFB?=
 =?utf-8?B?MWhqRC94VENoeEtERzlucWRsQnFzdkF3L2U4Umord1g5TXU3NHJlQkVIejdU?=
 =?utf-8?B?eEEyaUIrRHhabExmWTFlWkNKTWZWUEIyVWZXK0JaTjRUNUlkd1V6TkY2OUtF?=
 =?utf-8?B?RWcxR0djbjJuZWNrY3M4ajBwdVBtQllRYURPelM4bk5SMnN6OWpJeWVWeVkr?=
 =?utf-8?B?SkZZaU5CbkQybWtZTVpxSXBXcWVmSUlzRC92NEZNQ2dpOUpoaGRjQ1ZpbFRm?=
 =?utf-8?B?WjZuY1dFVnZwRkdIUVVLbjB1WjlLNnZ5OG5xczBZTU1tb2xGMjhRMEhGQVlU?=
 =?utf-8?B?OWNsb05PN2NKeGRSeFJDRkdvTi92UDM2NEVEeW9nUGNaTG81a1JLbnEyQ0Rh?=
 =?utf-8?B?cWc2TTFxOVBpTHJkSVo2RGlRNm5TVzcvWFI3NGszV2Vsa0FOcjcxS1JPdlA4?=
 =?utf-8?B?ZHY1ZXpqYjNtTW1oS1p6Z2RRZVhwQVpoK090VG5PM2xCUXRNNE1tZjAvdXZy?=
 =?utf-8?B?aHRPWHVPMVVReEZ5Vm5kNGFqMGtmdWNaR25ERGsybnBydUUxcjJZTklXQldY?=
 =?utf-8?B?M1BNYmRyTnJkZkJyNEpVSWVmRGJlL1B5eHVVdUZ2ZVFObmMyMHB1ZmJqbSt5?=
 =?utf-8?B?YjViUFFRZE1jUmVtT1MrVUVWQTJzVmFVbXpIcTRzUndWMGpESFUxaEkwOHE5?=
 =?utf-8?B?OGtXcTVlRFl1alZDbDhvNXU4S1l3WlZFMitEZy9vNmwrNFl0cHJqa0RZd2Rq?=
 =?utf-8?B?aGgzdW0rc2g3NEh0Q0twMW1LSkp1SW1USTZmcEpzU0tyd0RJdVlqSlFRejF1?=
 =?utf-8?B?N25TdlQyMWg4OGtxS3c2TDY2NU5laG5uUFZOQURrbVJsVUFreGZObEdnYXVk?=
 =?utf-8?B?S0pWNDJ3cEg3NUVDTEhZNmtVa0dPbzZ2TGFETkJTc3I4VEozalVpNGQ2Q1hP?=
 =?utf-8?B?YmpIUDZXeDllcEVESHVMMDhPc1AxdXEwK3YvbW1RUmFDUmp2MWt4cEdKeElB?=
 =?utf-8?B?K2p0ajR0Mmg4UThRUnViRmhTdTlnVTdQR2pIZE4rWm1TcFBlZnJSbWpOV0pD?=
 =?utf-8?B?THZzNHFOSXpUYml2dUtsaFAxQzVSQ1JMSmJVUnBzdjM1dTBrR2hpa3JXSnFR?=
 =?utf-8?B?NEcxWDlvYVBTL1lzMFFnOWNDOHllYmxUTVkzNkJlNENYdTd0eFpWd3pxN3Zl?=
 =?utf-8?B?akUyVEl6UXNlNmlJbmZYbEJyNzFWY05QZkhVUFhNc3UxSnpJbnJ1cVFRU3pE?=
 =?utf-8?B?aFpyaDE5ZS9hTUtObmhieUJsc3NGc0hKeE5raUNUOXBnZm1KenBHeHcwK2N0?=
 =?utf-8?B?anZoUXcrUEg4enFkRHFkM3BmNk9vS2E2OFBZNnhNU0hMeDdIMzNHSHovMnE4?=
 =?utf-8?B?ZDBIYkFNaGtUY0wySnZjTWtiSE0waGUwOGV4dHJVMyt2YncyWWdlN0hHSXFD?=
 =?utf-8?B?a05xUkI5TVVDNExIOXlhSS9PY3FPbU03M2MweVFFcTc2aU1veE5TNElLb1Vl?=
 =?utf-8?B?dm8rUjFDTTRQWmZuYmdsZjdmdStMR2xiMGRGOXZudWtTZWJQMlE0VGoyZHpp?=
 =?utf-8?B?RDdRdVU0NTZPVFBab3FteGQrMTNSSXVWd3J5L1A4bmY0Ylh1VVNlTVpMclRw?=
 =?utf-8?B?UEFwbGhjejBvbmt5SUk1NHlEd1kyV0dFTHF1NUZmVTJZOG5DaTBWVjd3eTZz?=
 =?utf-8?B?eE1BQ0p4aTJsWmJHbkczMmxlZTByMklUcUtHU2Y5NWNzQ2JUWU9TakxoYlU2?=
 =?utf-8?B?bmNzSHhtVXpTUDdaalJnS014NmcrUW9LRzN5T0d3VkdxMEFqUndyaUNPMmtr?=
 =?utf-8?B?RVJJcW5YTUtOckkvQ3lrajJPd2d4WGdTQkl1TXA0dm05QmtGSU5CUWxYRVll?=
 =?utf-8?B?WVVpNnQ0cGVaVll1MjVDN1JJeXNndlhTNkRKNDMzNTAva3NEZ21nc092KzlJ?=
 =?utf-8?B?ck1LcHFDR1gxRmcwcWQxd2Nxb0xoTCtzRmJFd2dDOWtVczBNdFI1emFUYStx?=
 =?utf-8?B?a01JTDA1T2laV0RETmZnNElaejd0VzdBSmtYSkFSZWJ5NVZuamlhWS9wUHRP?=
 =?utf-8?Q?YcrpLDMA6X0eO7/R03?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 501fc2f4-3486-45dd-7e8b-08df3ff635dd
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:18:01.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvxHZ7YTLSFLV/yO8is3Md8YDiK6MMRYsBRIPmo5BJkrTAwnUrApnWISxfzoX/3DHFfgXPe6MMuY13txPu98SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6391



On 11/9/2026 4:48 PM, Jason Gunthorpe wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, Nov 09, 2026 at 04:42:32PM +0200, Edward Srouji wrote:
>> From: Uri Dar <udar@nvidia.com>
>>
>> devx_umem_reg_cmd_alloc() stores the CREATE_UMEM mailbox size, a header
>> plus 8 bytes per MTT, in the u32 cmd->inlen. The number of MTTs is
>> derived from the user-supplied length and pgsz_bitmap, so a UMEM of about
>> 2TB registered with 4KB pages wraps the size, the mailbox is
>> under-allocated and mlx5_ib_populate_pas() writes past its end.
>>
>> Store the size in an int, the in_size type of mlx5_cmd_exec(), where a
>> larger value would turn negative, and compute it with overflow checks so
>> a UMEM whose mailbox does not fit is rejected.
>>
>> Mailbox sizes within 512 bytes of INT_MAX still overflow the block count
>> in mlx5_calc_cmd_blocks(), but the command then fails with -ENOMEM
>> before reaching firmware. This predates the change.
>>
>> Fixes: aeae94579caf ("IB/mlx5: Add DEVX support for memory registration")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Uri Dar <udar@nvidia.com>
>> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
>> Signed-off-by: Edward Srouji <edwards@nvidia.com>
>> ---
>>   drivers/infiniband/hw/mlx5/devx.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
>> index fc6f793dcc6584e6a22b40c57e2df8f24579eb14..1da6c0e440d6e19d8791b012a148f479cfdddad7 100644
>> --- a/drivers/infiniband/hw/mlx5/devx.c
>> +++ b/drivers/infiniband/hw/mlx5/devx.c
>> @@ -113,7 +113,7 @@ struct devx_umem {
>>
>>   struct devx_umem_reg_cmd {
>>        void                            *in;
>> -     u32                             inlen;
>> +     int                             inlen;
> 
> Do not change things which must be unsigned into signed values.

I asked to use check_add_overflow() but it was dumb to ignore this from 
my side. Will fix in V2.

> 
> Jason

