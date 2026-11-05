Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793890216;
	b=nqd5vo7H46cmEzkOU8C1ctMCoK/3QlsbIoGDTKT99kD2EwJhQXmTS6zrK7IXR/Hy4DSa
	 ERItrsfd7HON6S5KLngid3IHsJSpE0r7uuFJVo7qdlAvDUf+5nohb/Fa1IKmP5v2JZLoF
	 l6CEWurkWcogoWnqpEoBJk9TfAivt/XBkfHJ+C72HnjXeVPkCfczf0vQtAahczi021Y1j
	 36eaGEN5Tf8NKQmdB0fBbK25H81DR/+bOcHTc7F4B0zZ1hiH9ULOGn7pbVhczV6s0nCiS
	 k3zIY8sSt0GT1/OBGrEmvyta7O+EgpNNc6xCIdMKGRq1ywylzyRxoUVYNLs+yzkjRow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890216;
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
	bh=HGSxxViWV9U9a7ZKq1bHfmYajMigMTDFCKzcqHyj6AM=;
	b=zwnh8IKd1At9jPL98eV/3KOoiAZNlqUpDoDaT5XY8S0oSRjWzP4fCvHHxKrCTKEZGI6o
	 YmAiR6RZTNjiEEDltIwpDu0TomXLlO5m8GGYWODbmZhODjSMm+YmMNMVAzRBqi5GiS8a3
	 iM1aYlGVseg7BQlLorydUOUbkBtgLG5Mh0FV+GDJjW9JhXbx9HqruM+JHF+6CHmlt+cUU
	 HuNATmMubfc957u/v0hclnZf8o8+SFQnW/+KPUq0arhLcnFWa4JvXRJ79Bqvr9gPlTtsS
	 CI7xO3d1d4v7dbXIaGOKObilrNB+uZrGqWsSUbiueBAo9mvP5+clhBnkfiJ9yTSXH5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="N5/X0VkZ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.26
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DA5606A32C
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 14:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12DA5606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N5/X0VkZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TR1DL/Ya/RLSwTfBLiCvt7+Z3B5VJmmlp0h37HcHnqdkbFlzG78UgbmhJPt+4cySgXXJbRraeW+oT0fPUpplxS9r1ErGbD1MS8TbFIea4N9kMWVHBo1LQBSS0qa/0WeLfDOAPpoElbvMU0GUehKg6wUimdmzka72mgJE6kk8rDFqhv9t923QiRXMv67NuPuJGv2OAbLL8IfryW2lo+rAsDadr/gFC1K1fVhKxUh3JPPmzeqLb519zilHeepy8oj5MGXml6dGjt5IqHfHnI06NSK+W04OUa7xhD7fbBfVZw5Se/agUD1beUlM9i3PLzSMGRQXzcdIE/IDIKD79vfczQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGSxxViWV9U9a7ZKq1bHfmYajMigMTDFCKzcqHyj6AM=;
 b=yV1S9m6p+IoEdnn3nJ+ctKhOPxsOcU8dmjVI1Czgcbr0pf2eIYW6zln9oGfrKUqTkZGy9tHcs5WbOK6srO0pjLw9BmzbxPsRHAIMLT4k3A4h5Lu/QhaQV8PoAFWG2OfR+CumJ2WahRarm5iTCELvvGqquacjHSS2YBo/fnff5hW0eGMHqNQkRj6xUR9NOuLkFQg7k3dfs37hzXRqohGKvPn1b3yGwvano1syzIAq7K+VP1iPw7W0N3dls+QxsShoE6U/d0oUOFmhpjb+KHA0+YI5vRBZVXsJG2Mx3lWI7+UpPFlSK9PBD/A2Y5UI8U39y/iE9+hg2JOATQRDhWwZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGSxxViWV9U9a7ZKq1bHfmYajMigMTDFCKzcqHyj6AM=;
 b=N5/X0VkZcKLoIoeygCpn0+/wOViynzZBptT7cvxIu9psrvr8WwmXtkq4QrAIF1+ZYlRUCnmY57VxH/q3/PV/aNXOVSvzqAEnhWF2vkBy1d5vmSZeBO3nPO9VcofC3C70226FT+Ntn4pJDPaAcxgxxGFLihpCjd5RGHmn434T/c6aIBo+v7jR0JJG8qsq3dWJkKpqs0SIk9qdBDTYI+WjHc3h5SQfwhEBrW4/xpdItFOyZJ4pNbfnWk8hticA/J4xu/XOTGqzaVkHseFRofDRMichIISWjfyw1im7JzSSnyNkXONQMxDfqMV99oHTSNrPV2sqP4Zyx4IHrPkogCJl1g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA1PR12MB8699.namprd12.prod.outlook.com (2603:10b6:806:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 14:50:12 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 14:50:12 +0000
Message-ID: <35ec1a5e-d8d5-4476-b07e-4f6191784e5c@nvidia.com>
Date: Thu, 5 Nov 2026 16:50:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v2 14/15] RDMA/mlx5: Support new Unordered
 access flag
To: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
 <20261102223325.2115128-15-michaelgur@nvidia.com>
 <sashiko-outbox-196139@kernel.org>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <sashiko-outbox-196139@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::12) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA1PR12MB8699:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe6e7a3-770c-4bd6-8c9b-08df3b4c1824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|11063799006|4143699003|56012099006|261022105027099003|261009223027099003|261026140227099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vTD2A4dwR7sapWyHKIbiWMKi2FPb5Lf6anJx5ptgho3QGqTSqdYDRpz7FNlldENxXwgmg2ejjWM+HX++w89I1gP1CmVS7pYfHANuV7ypd1hFWajZee2YP6rvmnEzCNcoEAwlrVYQ4A0Uly1VShuk4gZfJjmFiwuLSnH9s+fET2GdO2dtPlwje0nOO2pdG3ufO6RKNwd9EAytsKfchBkJVgScwrEoVrhx+gNXVaTvl/TtrzU5x698OZBjk/ibfACq2gSNe5pW/zdY0wJIx235rcQuKK/YsuTixGLJpv8rw6MFVWgAFynkrNjgYAn6DZkZBx6X/an5yG/VakJiLYBxGw/drghgf0Gg5zQZuVN8Q/mxjSjv5kTlGD5dqNzUx6G5RT/wEIHTpIQfFY4yuRfWhnJiglG/jh9r14/tYddveAs8HIiY/05Uj0lo+72G/UXCE+Au/s5F+DwI/0L46ImFr2Db3aDf2krrkcQoa2VJRVHY329rzuthzbIqyh6ro56hl+BEk6vV0LwxMzCmzRSJXdTPMuCVL3svixhEr07FIEQVwEXHzxtJZOOQYJr5K+6GQyD6zrvgV64/bQ0SQrxeLiuSV1D40v6jpQYfmCySINN0X7fx3AmkMHyvfo9luu5K1CG5HDh/kdUGYCba+e6uk/NuUOabVL7mX/OThtjUdTE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261009223027099003)(261026140227099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUdQNEFqQVVDbGZDaEhWdnREajRHUkVoTUJCc2htTXdNdisxajl4MktZVkwy?=
 =?utf-8?B?V3EzVjg0dVc3K1BlRHVEbHhNSTJGdlp3OVRXcEFNeldXOVJTajF4NVo0bGtG?=
 =?utf-8?B?bFlEVkxHc2RESlFWZGp0cjZEZzZLTDVja2g1RlBRQTlsY2VPckVra1BVUzNO?=
 =?utf-8?B?VHpHdXFaQ3FvY0JXeVB6d2gxQlpLRGRhbDFhYTBRc1Juejc5WlNnYnVwTW5m?=
 =?utf-8?B?bzZwVDZMZjVQSnl5WE4yNVNnVGswVHhYQm9pTFVJSExYVXM5WmdtOUZCbGhC?=
 =?utf-8?B?c2MxaHNpY2pBYkN0Y0lzd3Z4bjBRQThmRHR6djZSM2pKV2gxS0FMaUpBbFpI?=
 =?utf-8?B?MWwvU0FkZEYrZzV0SWFnSW0wUU51L2N6U0RjeDJzM1QrWnY2R3FwVU1qbGw1?=
 =?utf-8?B?TThGeTJkZmFkTSt2YzdJaVIrSzlsR2t4VjhsM3M2UkVnZGlya1Bob2t1Qzhw?=
 =?utf-8?B?d2lSNW1meGZqSmpKUlpBRnIvTUdNWEhkRUFzSFlQdUNrbkJveWJoSFQ2NGJz?=
 =?utf-8?B?VHlkbDVCaVhsckgyZlp6d1E5SnMrbWZ6U3RSd1U3TzB1Q2JudGk3Y2VFMXlP?=
 =?utf-8?B?OEJMdlpxeWVhQmxDVEdrTUJzK2lwVlJramlPQjhwUGRpdWlrVXJIUXN3Tkta?=
 =?utf-8?B?ZUdzbDIvR0pyZGpCUDhqUkdFMTM1M1lMa0w5R3JvMFloWkdBVklMbndsbnZn?=
 =?utf-8?B?S0taZTZwL0JuRW5ZaEU4RHBRR3NNalRXR242bEVRSm9LV242ejEvWU1UWVVF?=
 =?utf-8?B?cUZXNU9jRVhRdHdnb3JQOGN4RStUbE4xYVpocWMwOW1kTmt1NWtJR0RXaFMx?=
 =?utf-8?B?cmVydWdGbit4KzB2cGl0V1lTK0UxUVZraUtKelYzclZSODlSMWNhdTM0eTAy?=
 =?utf-8?B?YTZTa0UzWFRyRVd6RVhaN0hnNjFDWml1Q0Z5UmNFNXNuZ0E1NEdSN3Q2Qko2?=
 =?utf-8?B?SlpOQUhUeGk2ekxMT2dYUDY3SzJ6d3M3RmFiQk9lczFReVVHejJscE45SmN1?=
 =?utf-8?B?c0pvS1MvOXVSMG52RENvb1h4N2xsZzh0L0hONWk3NEhPOFQyYmcwRnFTQ1pB?=
 =?utf-8?B?OU8rTE5VNmJZY0lPbG9lL0o4MEFTdUFWQkhnTW5GT0lUWXZ3OWdvRW5rdlVa?=
 =?utf-8?B?SGx4VkZrT2UrdUlIOTNhWFBzOGtjT2E4eGpjWGc0SC9VWGx2WEJ6eVBuVkR6?=
 =?utf-8?B?eFNtcHByaWFUa1hZTjJYVlE4R1dpT2VaQUk4bTZRcVNLbFV0aVdiaUxqZ0hL?=
 =?utf-8?B?Z3VucTRqYU5TMXlQMlBOcnRES1FFRUNOaEhSZlBOeG1Oakw5aXJRSG13Mloy?=
 =?utf-8?B?eUltUEpJc3ZmRVcxQS9OMW5iYjVEaWJ1dmRPaE9BdTJ1VHRGT2g3WXRFOERu?=
 =?utf-8?B?QW9MTGRYZDBaUGNoM1EvbUhsbzJ5WjYrbWdxYkczK0pqb21naUJsaTFTZXRD?=
 =?utf-8?B?OXRtMnpWQ21qVTRYSUtFbWxGb3NsWUtqaXFiakRpZUdmWW5wb29rQjh0cnNm?=
 =?utf-8?B?QnRQRE9NMlJSb3laVDJoSGhjTnZ5NERqazFLc0tjb1hIME1aak90NzAvNjBT?=
 =?utf-8?B?dnFKUGF5NERBaDlyczYxb1AzcHJzTno1K2Z5Nngwb1FkL0V6RHh5NGhJQzhG?=
 =?utf-8?B?QTlYNDVFMGs0RkZuNW1acmt1TXFFME1jRFBLTkR3d05TUlJkOEJocFdrUFVy?=
 =?utf-8?B?UEI0dGFpNWUrNzZkRmthZ2trUVlPQitZTWQ3Z0xOQ3loSjhjRzM1ckNYdHRi?=
 =?utf-8?B?TkFVL3A4eGQxOEZpeXJQV3k0T1RGZDBYM012a29tbzhZNS9ydDB5Q1ByUjky?=
 =?utf-8?B?bXJwelpmOEZUaGNyUHRxdGVKT1RVZjA1ampIYWppenI4NE1kb0oyZzdKK1hU?=
 =?utf-8?B?eVpOZjZxckYvanBzL21QM0o3bXdZZlZsd2c1NVFHMlZBZGtFNUcrTTNJOGVB?=
 =?utf-8?B?ZWJoV0k0Z09XWHY2VzI5TG5PME9ZTHRVYjg4VkhJNzl0U3E5Z3NUZVFqSUNn?=
 =?utf-8?B?MXlFRUR3d3JEN2VsY2lWUEVhR1lPNVY2Z0lLWWR0Y01ybFNvVVl4ZWw3Znl5?=
 =?utf-8?B?S3l1SmIwVEEydVA1dWk4eW9xNEdETjdGVkVXTlJTTFpHMitKaE1vdkcrZGFu?=
 =?utf-8?B?bG5WRU5DT3NqZC9tYnFQY3NBSWd1WDF6Vk13VkNpN0xacHUwbXpudFZha29j?=
 =?utf-8?B?QWFZTWdidkFIcDk5TjN6M1dPdTZ3bVhFRmdGZEk5eGZXaEZScmsrRFZtN0VP?=
 =?utf-8?B?RGdmdTl3NGVlVEtCSlRlSWRuZkN5UGJmR09tNCtvd2NweFBEODQ3NCsyUGIw?=
 =?utf-8?B?Y3ZGM3dMZTRWbzF2Y0xRTjlBdGY1blVONklPUC9vZ01JVHVWNE5LUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe6e7a3-770c-4bd6-8c9b-08df3b4c1824
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 14:50:12.0505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYsDnA4eykoggcISo4xUdrhEfojRxu/e+kCSc8mafrs8cKKIA2O2TutvvQFqxlehfruvddElwM8Bljo5rOyjwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8699


On 11/4/2026 12:35 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] RDMA/mlx5: missing IB_ACCESS_UNORDERED in _mlx5r_umr_update_mr_pas() for DD
> --
>
> commit d54e400e3350128fbcd9fb5d5bce4f37dfe241bd
> Author: Michael Gur <michaelgur@nvidia.com>
>
> RDMA/mlx5: Support new Unordered access flag
>
> This commit adds mlx5_ib support for the IB_ACCESS_UNORDERED flag by mapping
> it to MLX5_MKEY_ORDER_UNORDERED, enabling ATS on DMABUF MRs with unordered
> access, and marking the flag as unchangeable via UMR.
>
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index dd1fe8fd42206..75ea3f91e9314 100644
>> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -1672,11 +1672,13 @@ static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
>>   {
>>        if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
>>                return false;
>> -     return access_flags & IB_ACCESS_RELAXED_ORDERING;
>> +     return access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED);
>>   }
>>
>>   static inline enum mlx5_mkey_order mlx5r_access_to_mkey_order(int access_flags)
>>   {
>> +     if (access_flags & IB_ACCESS_UNORDERED)
>> +             return MLX5_MKEY_ORDER_UNORDERED;
>>        if (access_flags & IB_ACCESS_RELAXED_ORDERING)
>>                return MLX5_MKEY_ORDER_RELAXED;
>>        return MLX5_MKEY_ORDER_STRICT;
> [Severity: Medium]
> As reported by Sashiko on v1 [1], when a Data-Direct DMABUF MR is registered
> with IB_ACCESS_UNORDERED via mlx5_ib_reg_user_mr_dmabuf() ->
> reg_user_mr_dmabuf_by_data_direct(), both crossed_mr and crossing_mr are
> configured with MLX5_MKEY_ORDER_UNORDERED and ATS via
> mlx5r_access_to_mkey_order() and mlx5_umem_needs_ats().

Data Direct handling was not extended for UNORDERED in this series, 
since no HW supports both Data Direct and UNORDERED.
IB_ACCESS_UNORDERED is an optional access flag, so falling back to the 
strict mkey on the Data Direct path is still correct.

Michael

