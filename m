Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793890836;
	b=g2TVgvOaI0CvLx3ZxGXoEsQ8TgeI42R0LIudNR5cru8TkxHamAXnNt+v1prOjndXw+Ps
	 flvSRf/w701y3K2fZ8njldc5V00NPTcBvwrYAZ8uUApIp60iyqKA49VOUsZI9IrJ33b+V
	 hFxTH2CErpK6IZxhaEe9K+Sy3z8MBZkDXDriZuScpGZmenw7khVm0HrfjXhh048vPtUnd
	 xL1nCqDJE0KygIunKZv7CbLIHa21D+aSQ5Zw7Qmb5l8N4xItjwMWcO4cmO1XAGjmqe5gt
	 GXvwutfu6j93dJaEar9zqM473ackxgY8U2ztXY8R17iQpSGaTYLQEHKmUN/A/Zqbv7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890836;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
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
	bh=/DhubdjaCRpGrWlZWXv76vY8iGrMr+PD0s78mBeS8Dw=;
	b=47n9LMc0lMrjrGpFPQFzq+YDzZ3FHf79+WdnKF410Q4KfFvbmIZ5U8Fk2Q2D/7B58PsX
	 kDRn15rghjjkws0AaMVYMGaRF6op1oETl4kF4KFWfb6dO7cEtXwcrVniwJ8X1hZw9QEU3
	 I5iB49UrH3xwO2JP1/3koC85we17CXDZpBUTUxnQNfKF4aucD0jmci1CHDfMT8xBPAbEj
	 O+fxE/SuMvc8Z+fCW5S44wpJ5LZvcuft7Q4QbCPPNoYjjhJ3TgttPbEwBuEGLBlvCZlEx
	 a69vpjbd85UYlgkygidgeuRWQ7TPotboOP9/E/vxfa0VmFKKx1Q1pBa6xZafkgjbQSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ECPlxMFl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.10
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011010.outbound.protection.outlook.com [52.101.62.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EEF606A333
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 15:00:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89EEF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ECPlxMFl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uhy139IcNNooM0OvO9UZBlFCcdW6+G0HlBCLiy1PGc5QIH7iRXlJI10/S+7jg6cIQ/qy+n1U5t+XfZDt2Hhy4grrsR/fvpmq4k6bUSeBTPY2gQqOFGhh+zhXqHNldo6cwCcu5rAuGX8NkHsjNgf+irdIXizNw4EOYV33DZfVKP1cIIVX/enEPHzH1odgAuEzkRJvvhT0dk0ipRH5LBqdaZnMXN2Hkh/qbWlrSC8778UYl1hF7kfsGYibDOivM6ZzTbrRkBVprqFlntyZa6oONK0ymJLY4lvNwW3ykVfRz1GAUWpDTTHilT1a7fETEFFVHu9LxPaPa4UCMrs//vJUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DhubdjaCRpGrWlZWXv76vY8iGrMr+PD0s78mBeS8Dw=;
 b=nIEpIH5ThBw0JZsqg+S/jRH8YCH4NbmXg6dp/ccmQunWtl0GxUtPm52nUsXWOh4EMapkrtDHRD/uTmiuolIl0nfh8s/vP8DMwQBjYX2UPmaOlR/suPph10UFH1TNcoxahWJTdBpBedCv9Y6vK2rI9EbLp3Ur3uQYKv6L8rIrSk9QAcJpJ5L7wwc+oCyV2yZh9Ub5WzGqyrf6+MLzUkJpqUJnn5RgdPKFvBhOP767IpqMUP+Zf94os/Zo3T543lHYdJkq5oTGk2cXD7l9XTa3VFeL8xXo6arv9aJefmvwWRmrmk+b7xzVf3GCqXykhwR5XRPMSeD8tfD5TAPIx2Re/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DhubdjaCRpGrWlZWXv76vY8iGrMr+PD0s78mBeS8Dw=;
 b=ECPlxMFlvCY77UGc0FlISHBR2xrs/CzjLfEze+7jxrbBozxS0pnZDsnIPEtWtrKMFx9sCyPAr0v9heZGNxKsVES1oU2vrjAwfveXfa/qA/JgJGnPenfBf4Zrdyruxjuji5qEyZbFNg5GL5NkbXTC25tU1n78dIQhsBd5bG2aSM16w61saYTnIZ4VUfFQLfAXvIa6VtHS2oQ8Gy2kDLtE6yTeXIuPmKltTZ2wNdKtcDWqzNvU5gEMXP5/ge4xoi2UXuMIVQ3CafSG5YaXUWC+uBe6OzhbmWL95lyccXiu5zkL2u0CBxbtQVHo16Qsz39gzL5lJjBz66CQHqAfHMnBxQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by LV3PR12MB9095.namprd12.prod.outlook.com (2603:10b6:408:1a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 15:00:23 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 15:00:22 +0000
Message-ID: <c3d9f511-638d-49bd-9e27-19005480add3@nvidia.com>
Date: Thu, 5 Nov 2026 17:00:18 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v2 15/15] RDMA/mlx5: Enforce relaxed ordering
 when HW requires it
To: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-16-michaelgur@nvidia.com>
 <sashiko-outbox-196140@kernel.org>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <sashiko-outbox-196140@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::13) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|LV3PR12MB9095:EE_
X-MS-Office365-Filtering-Correlation-Id: 6105c61b-03b4-4d6f-35ea-08df3b4d8379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|6133799003|4143699003|56012099006|10067099003|11063799006|261026121527099003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6Oqt+CnF7Kf1uvB+jLFfI75n+znqpV3BQfw4nvnH9mD/ba0oNu8wpFgfiV7LVfLhPF03IC0BCtPYW8zzrkYhCPvNgOwNi7kdJBWXt+U305iupt/EeGHdWzXxWzQr2iK4z3j3QaP+6jJfCEdaSPS4qcsZEh47I86xdle9nA5Y2/uMdJIbwNO1SZ6ojZasDoov0xcz/Ms1nqmqY3t0w5b5O08mZU9zmRNBTkvRRLsinZKfB0clxqmaP5pim+p52MhqWcXFhiR7usRxSUYbdGqGhAKeE+Dhzryd/nmdfJeh6oAGqdqqFux36caVz2YeJt/khFPnnwUBdE5dyyf7GG+bB3zL/OiNZLIaXCdfPYHIuMTMCun4Y24DAzxUAkisV2C9D3IrYn6Co1tuoTCBcq4TrroGR+KJrkEiLVx18xyVLJ5gsH3JW1DvZBCKSY4BLDOm2zs3NS9/w15tW/fBUOZYg0q8LJSnhqr2lAyOsknJFly1IuSG+ODlD3uRonX16TBTy9q84AWSRXK5wE2siGTQXxRy/rFN+16ojDCKROvzE8YhGL6IYaJ5CZPR5gmw7VT9dY6Z6xBs31A6CFmTxWSZIWptvRILw4nTN1akKTHKgkz9HK+WPA3y0wUmVnqUcMZ73VfVoWAEcblba7r6VEtNSbsJmbutI6ERLy+IawXLUh8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(6133799003)(4143699003)(56012099006)(10067099003)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGZlYTZYUUc0Vzd6a1k1WFIvaFJROGFMUkxCaUl1NTdPNlczL0F3bFdxdWpI?=
 =?utf-8?B?RHg1cnRnOUVsNXJaUmJnU2lwaW5BbkUyMU9ybHEzaWFDTEYwUTBrQ29lWksy?=
 =?utf-8?B?UDJiSHRWVUNwazJmODQzK2YvM0tSRC9jc2FPN0F3VVhyOGcxa2pYZGxiSUxh?=
 =?utf-8?B?QlFHUU4vTFdKQkFkdyswV25NZGpHVWxsOFlWOG12YURrRmt3cXdWdHlnYmUz?=
 =?utf-8?B?Z0d3MTBJOWoxTTRVMUs3TXUyMDRIUzZVN3VQaDIyb3VhUjVVMC9raklTY1Uy?=
 =?utf-8?B?UXlabzBnektpNVB4SGV1Q296cC9XbnlFbi8vSVIwZjQrNTBKNm9qTStnc0p5?=
 =?utf-8?B?L1B5ZkFObTUwaERSbmhnNmw4ZldUSDhKazFrVCt4aU1DVURMaGI2THYyT1c0?=
 =?utf-8?B?Vi9nclFDN0xOT0lJekJTd3FMS3pEQUR3bWI0K0w1R1N0RlRFTDBsRDFzaHJY?=
 =?utf-8?B?eFozM2ZmcjZQd1k1UUxIWXZwbTdrRDNmVDlFbHAzcVpkWmQvYlU3RmlRa3dm?=
 =?utf-8?B?Rk1JdWNDcWlVb29lMHFBeXRHbTZpTFVIejB0Rk1pZWRoQnZFaHJaaDFBL1VM?=
 =?utf-8?B?amsrakpZSXVPUzVvME5GTTl0dzRlckN2VDF4U016VXo1ZVQrbzBVQU51Z1Fm?=
 =?utf-8?B?V0tBaUhwcmhXVGJEUG81SnR0TXJHYUZ3RnhkTFQxY2xwRjNVa0RycUFsTXFu?=
 =?utf-8?B?U0o4a2xxait4ZDJwV2FkUm8rZmZKbjVFcENlYWg4bEJ1K05pWTIvcXhRdkxI?=
 =?utf-8?B?Mk1OMFRUajZBcUhZakFxUEhkaFQwRTQ2VmdOMlJXblgvdHBTdWJXbk1PWGdE?=
 =?utf-8?B?aVVIVFMzOVFENTk0anVsN0Z6RFZ4d2tpOGN4YW1iMWI2RHdLU1hQTnJ5cHVu?=
 =?utf-8?B?bE1DejNaYmk3SkMwTWZMbXh3UGYyNTdGNHNXR3ROK3BKam9zYlFzSEswYWtr?=
 =?utf-8?B?M0xsSi9DeSs5L2VTVXFXV0xCK0NQT3NydFZadytyeUw2NFZSMUpKQ2VSaHZp?=
 =?utf-8?B?eVpmd3UrODd6SUc2QVRvbjNHTW9taERXWXEydzZKYzlOWm0zcFdKYXZ0RCs5?=
 =?utf-8?B?cEpBdWNxS3cyZkE4YzJ0T2VXVGtYTGJEZWNuNFd4ayttdVZjNUVuMmJXY0ZS?=
 =?utf-8?B?eEprM1dQTEhpdm9CZmhrd3htb1pjbThQb2FBWXlMWVFyUDNibmYwTVJ0ZWxr?=
 =?utf-8?B?SzRIZjMySDZDL3AxKzhmTFJpY2lMUW9TYXJScWVFbElwODROYXhVYVBuRWdW?=
 =?utf-8?B?SFNBNkw3Q2pQb2s1V1NLa1o1MEk0ZUkrRExsZ1VaTEVCUXFzUlNvNllvZUpo?=
 =?utf-8?B?T2g2MW1JM1FHblVGZDdlcEt1T2R1amNXaHdMOFMvM3Bib1VsNHkvcDh1ZnpY?=
 =?utf-8?B?QXI4VlFQNmhXUjJyQk5IM0ZZTWRiR2pISkdzZzFycXlvdjFPVDkxd2JVSTZx?=
 =?utf-8?B?eDlKbjBhVHJwcUZVSmhUN01KamlYSVZ6eFdubmNqQnRuQjJFUEEyLytOblpk?=
 =?utf-8?B?cnBSS08yUHNCclc4UG1SM1BZWkFwV2RSa0kxODl2d3Y1dDNFUUxKSXA2aHNJ?=
 =?utf-8?B?WWdvMXlzTEZPektMSnVpSUR5b3NibjRybFVEMngwVk9YeTh5VWVxaHNiQWY3?=
 =?utf-8?B?QUYyQktuc2hYbEUrVDNQSW95NjYreHc3alJneUgybm5BRjdheHErTnkxUE5O?=
 =?utf-8?B?REYwZGkzUCs1Y0U0alQ0dEZEZmNCYTIyVERpWlk2Y2h5ampTTHRabWVRZ2JC?=
 =?utf-8?B?WUJCcTEvbTNxRHV0VkN5YkhRSzZ0ZmRpdCtxRnJqRU95dk5HTnMreXNnOFhB?=
 =?utf-8?B?aVo4clJyYUo0eE5PeWdKNkZlYVdqQXVSSFU5TVBEb1ppcEZPS0tZL3pQYnBl?=
 =?utf-8?B?cVhTa3VJUXZTejhOUUtCTFI3RWNGVkRLS0xPMkhwNDFuemFXKy94ZnlaRnc4?=
 =?utf-8?B?YjJ2YkoveldTbUpXYTVOQzI2T3NLczJVVDc2Sm53ZUVWNlBobE5zOEFwZzI3?=
 =?utf-8?B?WVdldndFL1gwK0hXNFBBUGJUYmczVmUrbmNsUEhjdXpPbmlyb0dyOEt1aFR2?=
 =?utf-8?B?TnVwUEFxRmpwVHV2VGNzMU8zMDJJMGRCOFA5a2t5ZWJnaVVTTmxBVHZ3UVVl?=
 =?utf-8?B?WUMrTE9PU1JwZnZMeVpqazRuOUhXa0p5SHV6UDRLT1pCdm1oS0phTDVMeHJI?=
 =?utf-8?B?Y0lEZlVqVXRiaEdncWJvZXJTZlRnbGN2dXZPRU1IZGwzcnpjeXJmSXFZcXpo?=
 =?utf-8?B?V3k0UjBvSEFtcmMvY2F0ZW9KOTNHME02K2duSzFRWlJSeUJhZ0IxTTRHUktz?=
 =?utf-8?B?a3BYclZxRDQwb1M4UWc1NTZseWRUSmEyNXZYRnhoaFB1aHpBNi8wZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6105c61b-03b4-4d6f-35ea-08df3b4d8379
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 15:00:21.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6ltXUkQiOyqWTrxGEC/lPcXt9WzsUJxDmVl8UPfg1YwPGgq4tL1pIEVyAPGyi1LjLoq898y1a7DsjTA8JVLQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9095


On 11/4/2026 12:35 AM, sashiko-bot@kernel.org wrote:
> External email: Use caution opening links or attachments
>
>
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] RDMA/mlx5: stripped RO flag in FRMR key breaks mlx5r_create_mkeys()
> - [High] RDMA/mlx5: ordering check bypass in reg_user_mr_dmabuf_by_data_direct()
> --
>
> commit 939d1d09c02a86f15171e7a38c5bf57aaefbee3f
> Author: Michael Gur <michaelgur@nvidia.com>
>
> RDMA/mlx5: Enforce relaxed ordering when HW requires it
>
> This commit adds validate_ordering_access() to reject MR registrations and
> FRMR pool requests that do not specify IB_ACCESS_RELAXED_ORDERING or
> IB_ACCESS_UNORDERED when the hardware sets
> mkc_order_write_after_write_ro_only.
>
>> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
>> index 6848515e06d77..7952d80349dc6 100644
>> --- a/drivers/infiniband/hw/mlx5/mr.c
>> +++ b/drivers/infiniband/hw/mlx5/mr.c
>> @@ -78,6 +78,16 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
>>        MLX5_SET64(mkc, mkc, start_addr, start_addr);
>>   }
>>
>> +static int validate_ordering_access(struct mlx5_ib_dev *dev, int acc)
>> +{
>> +     /* If HW disallows Strong Ordered writes, RO/UNORDERED must be set */
>> +     if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro_only)) {
>> +             if (!(acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED)))
>> +                     return -EOPNOTSUPP;
>> +     }
>> +     return 0;
>> +}
>> +
>>   static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
>>   {
>>        u8 key = atomic_inc_return(&dev->mkey_var);
>> @@ -288,6 +298,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
>>                                struct ib_frmr_key *out)
>>   {
>>        struct mlx5_ib_dev *dev = to_mdev(device);
>> +     int err;
>>
>>        /* check HW capabilities of users requested frmr key */
>>        if ((in->ats && !MLX5_CAP_GEN(dev->mdev, ats)) ||
>> @@ -297,6 +308,10 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
>>        if (in->vendor_key & ~MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED)
>>                return -EOPNOTSUPP;
>>
>> +     err = validate_ordering_access(dev, in->access_flags);
>> +     if (err)
>> +             return err;
>> +
>>        out->ats = in->ats;
>>        out->access_flags =
>>                mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);
> [Severity: High]
> Can this cause mkey creation to fail when mkc_order_write_after_write_ro_only
> is set and the device supports modifying relaxed ordering via UMR?
[...]
> In addition, because the stored pool->key.access_flags has
> IB_ACCESS_RELAXED_ORDERING stripped, querying a pool via
> RDMA_NLDEV_CMD_FRMR_POOLS_GET and passing that key back to
> RDMA_NLDEV_CMD_FRMR_POOLS_SET will fail validate_ordering_access() in
> mlx5r_build_frmr_key() with -EOPNOTSUPP.
This is theoretical. It requires a device that supports modifying RO via 
UMR and no such HW exists.
Without the UMR RO caps, RO is kept in the pool key, so the mkeys are 
created with RO and the pool key reported by GET passes validation on SET.

I'll still fix it, in v3 if other comments come up, or in a follow-up 
fixes series.

> [Severity: High]
> As reported by Sashiko on v1 [1], if MLX5_IB_UAPI_REG_DMABUF_ACCESS_DATA_DIRECT
> is set in mlx5_ib_reg_user_mr_dmabuf(), doesn't
> reg_user_mr_dmabuf_by_data_direct() bypass this ordering check when
> mkey_ro_valid is false?
[...]
> Furthermore, if the user passes IB_ACCESS_UNORDERED (without
> IB_ACCESS_RELAXED_ORDERING), validate_ordering_access() succeeds, but
> _mlx5r_umr_update_mr_pas() only checks IB_ACCESS_RELAXED_ORDERING when
> selecting between mdd->mkey_ro and the strong-ordered mdd->mkey:
Also Theoretical since no device supports both Data Direct and RO-only 
or UNORDERED, so neither case can happen.
As replied on patch 14, IB_ACCESS_UNORDERED is an optional access flag, 
so falling back to the strict mkey on the Data Direct path is still correct.

