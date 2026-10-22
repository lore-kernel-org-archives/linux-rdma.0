Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792677211;
	b=XylBByIGc1w2rCM3A6VIMEpZOoZCSM2mMb4Q4ntV+7IkVOc2WzLaAcnlWfYKlq1f215c
	 DFa3zLdc3do5gd1gji3+P8HfVQv/MKwZo5OgF+KmbdYhfD7z2XztE293TfcwmNKmnxWyd
	 kri3CBustlMih7A3p6VMaa5PtnpHxlkMmRYabaCSdBn0OXYvT0dq5AJ6YQfrMyFUUsKIZ
	 +S6Bst1v8x1vdSA7VrUD//y4bycG5MNP118I8EWGnGQaBtyqt9VGYVx+N9/D060Pv5MAy
	 0qsnlUX5IdDpT6t4gpknHuEjmLHC6ybvapRuWf43qBx3SDGCf++T4T5vZKIfwNWt2PQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677211;
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
	bh=ec01Jgm6Gss+TXuLAb5SkaFD7+Er9y0XiDzrqSLudUs=;
	b=Yi/E5aTH06qM6qjlDarLoYZ+mncvhuK/2uXxBXcu8yn329Ntg04HUkXAap2+yEnlGyNs
	 sU6u887JrAeu7KuL7WetuVjesy9P1obt2ldIJlJDJr4CDRLlMfZyS5534/+2F+ekEZSWi
	 3nGV78d/Ut7z83CMnN3JveiqZfGiMd1lAzWvpSaOjK+OzBjOXC5eMq3M3B6bagg8FIGe+
	 ihdxUayxUZwPNBIxTvF8vfy5Tk5Xl+9aenh+2eNK9vswvuz8gZBVMVRvuzn85eAgScRz+
	 ShUAXPLkd0IQOtSA30txu4GyNcEsoYBUCnGePYCailNq5T+CyFPICYynx7Q5PNXpYPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="i/yLjJtD";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.0
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013000.outbound.protection.outlook.com [40.107.201.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D71A606A33E;
	Thu, 22 Oct 2026 13:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D71A606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=i/yLjJtD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8OcbIlNPV8V49LbiFF85G4qVZHYctShIqtQhvewgduuCJiM6Adnf9kcBiFzWFrXNAMyK2CkliAv8u52VcdZb6Ho1BjnGGxJG791Tvub6323ADzceiAhNt2Ez3FkDd8VQifU6JrxHaU6O29SOTMv6T1SrD4+eVP4nR2dHF9f9ZpLKQRa908k/q83OQ9/nbtFJdcdrwBKq1aS9whWoxAhoxbdSGDl3wDXkxQDAUBSaGqKBrZSAW2NWRDUx4nyDE0EY1LByXdmLQxuysopg8VRc4/PB5FqL04zh0EhoD5Oh9sE6S/5B3o/JdW27r+8+bRULqqKI/hDQrycMB/jy1f1Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ec01Jgm6Gss+TXuLAb5SkaFD7+Er9y0XiDzrqSLudUs=;
 b=ROYKoQbm+xNFCKMIZtBqo+KA3UtcgFO5ud4BU8qxMkd385n154Z5OrV3a2zxHCQjVdVlUDxlgfdzX14rl6Y2i1hFZryiV6RtEJSJMiSJlWHyS4hs0/Nu50Zj3U17fwfjtTt3WFzgsJTmqkgtDVgJqM4sqPohOjMAgWLjscBaf68rO3KJ37etlxur1VU17ZDo14DA2FzJC6x/ArubqWxn02xGN5aHE+tvycyBn0qcTgfcVso1b8dmeFUijNQTJtnIYezes1L913HExPNkyyc39HXTy267W9Bq9KY4/QeCaqmiWv9jMl5UFGwTmtmefrAbg3kEu8a2VQF+VorFhywefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec01Jgm6Gss+TXuLAb5SkaFD7+Er9y0XiDzrqSLudUs=;
 b=i/yLjJtDFJAPnJF77gDpFIkimRGY9HsT6SvJ7Krc+5+iSU/Adq+TvmaB4lC/VeYvl+q1nzJGIo24lep15kgq7sEhl1qgUIkVqBlx16O2xaneXiA7BlnjOqUTu7si9TGRh3jdMvPhE6pGezEb/1D90GRikeWbzSzxOtz98qLiWY9uGMHgXNpVf0hDeI6BjDSath+AJNDQunPX/8w010XoHdBeRudV6OdIIZXSDvoMPbdtARHSIlg/Ge9Zm0/Oza4kqgNO2hxqReDBbVOdiKO+hUHGbYqWx8Ti3L4H2Kh039V5P09MyIKnXusqeGyGiKdZ8HXOmo2Phew3VQq651NfZQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by MW3PR12MB4492.namprd12.prod.outlook.com
 (2603:10b6:303:57::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 13:51:24 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 13:51:24 +0000
Message-ID: <bf7ecec5-8bf4-47b0-bbf5-6dc8fa4e64d4@nvidia.com>
Date: Thu, 22 Oct 2026 16:51:19 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
To: Josef Bacik <josef@toxicpanda.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jakub Kicinski <kuba@kernel.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
 <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
 <17926738093796.1.mlx5e-threaded-napi-stall@toxicpanda.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <17926738093796.1.mlx5e-threaded-napi-stall@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::19) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|MW3PR12MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8be122-b17a-4eb2-ae86-08df30438f82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|18002099003|22082099003|5023799004|4143699003|11063799006|261021123027099003|261009223027099003|261021121427099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	DIxxaNiwPS2H9Y3bvBrn0mHCHQHwodV+ML2lJE5IUJuenJtlrdhFP7SQHlQxTYja+uh240GNl8Z551Y8L3xynOepAD3aKRgwmnCrkPHzIIeY0YtraHlD/N5WWh/PEH0uRp6bc2/hivBwm34mhU5uKGt1i+vkifOQclk337T9XJBI8lV+vuFS5wMsj/joH2w6Y3Hc/iSn6IkdDzparzU+E+LrMRlvta+BiuQnsO6qplDlJM0DRFdzMKlHmoV8C+8RM0A7/g38xOj9aA+mR8uLcxjsW2hCsGnxbW4pC1woXDHjhtWwoSuYAjcfB7yGEvnmRXXLJ+1Z8vmU9QYOHj9xJHNtUIvLUfjvp9wYGlDO1xp92kiQeswDb6m+/JTTgU2JU2joYIg3n8pG0n5wxVokY/Bv+Hov9iWFKJWMJf+pi1QFi7sTT6UHvMNHvoU3udq/qG4tIvbDfG4pQMzT0XnxjH4qltw6N4bB3hCdtlnsqJMxLkXBWgQ0MEJwOg1J8EMqyYgojmbSLsY/Hn7T78VNLfWhyC4mf8xBqV20zA/0JwZ+lgoQ1KlPJ7dupMA843NebH5hZq0ajyg9xAeMnMZ+MLEoybaunSWUnODaQr28BrtV5Ik1VKcN/ONAVZYqBwTNXoTuETxtmZyGl8CA0BA6P6fc7I2ngtWq1toGU7PmXH8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(18002099003)(22082099003)(5023799004)(4143699003)(11063799006)(261021123027099003)(261009223027099003)(261021121427099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmJ0RWdVWE4vM2twbDU2M0RXUk14ck40ODUzelI2bzZCNjdXQ01sbWlXOGN2?=
 =?utf-8?B?czl3Q1VTQmlkQzNuaXBCaTdPVVB6Zkp2MXJkZlhITWJQTTdUM1l6SjlyR1d2?=
 =?utf-8?B?Sm1TQVUrSE4reWpieHRBdGZENHhtanpZRU40cTJ4OFlOVkMvODBSaGQyOGtM?=
 =?utf-8?B?M1paN2xvT21na3hsN0Zkc2pob3I0Z0tPNk40aE0vL1o4VmdITW1OS0NYazBX?=
 =?utf-8?B?bUl3T09BRVVwbms1cERlNlBZVno5TzZhTXJVb0wvcmFLUkRRRnIzNDUzOUh4?=
 =?utf-8?B?MHdLdkhON3dROTkvU0RUL1Z3K1VIOUxyN1FqUzRNWTFKYkoyb0Rvc2RSTXcy?=
 =?utf-8?B?UkEyL3grQ0hkN1RXSzFXUm5MTks3a3lKMERlREtONTBCLzR5VjVzTzErRGhS?=
 =?utf-8?B?bW92eTlzcVAydENqd3BOdElzUEZPOUJtbVNzL3EwUFJRTzZqOTFTeDZMbmFB?=
 =?utf-8?B?WUVIUEttbXFnNmRpczVRR3FuOTZIOHNmMVgxOHV6OEN1V0tERFJPSGxCbnNx?=
 =?utf-8?B?T1ZOM3ZjajJiaUJneFFOWHJZSHN3YjF5eFNkKzFnOGUwa1ZNMWxoSmdONDJO?=
 =?utf-8?B?Yk5XU05aVWcyNUZCMEswd1VNQVF6TVFZOFk4VG5MbXJJUkd4OXVGcjE4Wndr?=
 =?utf-8?B?dUxBazhhMnVEMmp3UVlHNFpTWmdWanRRR1BscjdIcEtkeVAyRFh6YVo5M2Zo?=
 =?utf-8?B?TitQa3RjVVpJejkzZkxLRW1zdERxM2NOM0hjV003Z0lUTWNySkg1ZmNYc2J4?=
 =?utf-8?B?Q1BVZ1NueE16UG9XZDlQMWM0U2huWERScGpudTNSdWhJNjVrM1dhS0tQK3BF?=
 =?utf-8?B?ZDhyUzhzaVVmK1BjTEhIb2liY0s2TWljejJpOS9keFp5cXBwVlhlQnJYT2FF?=
 =?utf-8?B?eDRIYmVxYkxUaFdJSmNzemdnOWlUaTF1dkdtYmkyQUpSNWRjRXN1Z3pJUC9L?=
 =?utf-8?B?dkFQaS9vUHRVWXZQbHcyT0hJelozbFozRGQrak5yMFY1NTVJL2pjVXBLUFpM?=
 =?utf-8?B?UFEzc1ZGYkhVZzhZQmJqZ1NzSkNYYmpzOGROV000SVNmMmEvRGNMZjlqTE0r?=
 =?utf-8?B?Q1JmQWEwV01ZejFuS1kzL0czM1E2UEMwS0tQVVhuWU4vMVBqdFBFV21HWHdM?=
 =?utf-8?B?elc2U1ZudG1GNU5nam9wWXV4M1o4Yk5tME11d3dkUDNLMWdhK2VwQytBTWQy?=
 =?utf-8?B?dXBaamtVM0VTMENuUDMzVlRRblpIT1RMeW5GTVJkRHFVT281OTYySi9OUWpy?=
 =?utf-8?B?c2x2YzB1ZlpIcDVwOUh3WVR6Vmx3NDM1M285cllOTWVxVzUxSEJFeEtWZ0tS?=
 =?utf-8?B?MTRtWHp3S3lXR3Qyckl2TjhSNzk0a3lZczI5aVQ1YVdvNWtiSjRiWDFZcFdo?=
 =?utf-8?B?MFJnalNsR2t3V2J2ZlRmenFHMFFWUHgyRnBsdVN1OTVIdDQ3bkQwME50dUNM?=
 =?utf-8?B?dEpzbGJBZHBwdmFnQ3dlQVVBWHhCUFNIbERuZ2ZTdkQzY25aMVRBSzYxUkpW?=
 =?utf-8?B?N2NaOGNhaktmUy9PYVhURXloZmlFOG43aDYvL2pWVkhiOEJEeDR6Q3JxSHIr?=
 =?utf-8?B?akd1ZUFoZXpBTEdLNlhlMEhrWEdtTXRCZWR3ZkVka3g1cGVXejZLSW9TWXR4?=
 =?utf-8?B?WHYwNlRXeWNjRmNHcmE5MEt0YkdZMjk5bVhZUTBBczg3RWFLQlhUSGxvS3lw?=
 =?utf-8?B?S1hOMkNPL1MxcFYrZUNIaU9jUlhQTTRjSDljVThGY2FkZ1E0OGIydWJvRjhI?=
 =?utf-8?B?NkhzK04vMlRQZTdxZFM5eFgrYUtDL2tSV2xMZktPM1laeGxCRnVOc3hkaVF0?=
 =?utf-8?B?Vk1SeTNwQ1JGOUU0YXVUNFFwOHR5YW9HcHk1Rm1qZmJiK2M0Z3A0aTlCNWFP?=
 =?utf-8?B?N0V3WGgrTkYvam0wWi90bjFIL2FjME4xdWVqd21BNDZUMzFpdmYwekJaN0Jj?=
 =?utf-8?B?T21jWWVkYTJRMEZlTno2bVNCeTlzMkRLWWtmOWlOdVFMUDJkYStHdWYzbkZP?=
 =?utf-8?B?Z3BPa0MrTHBGZG5NbXN4VU51VURYdXB6a2RvVlV6RE1Ba2xIbGN3Q0RXZmxJ?=
 =?utf-8?B?TGVOazZ2cklXNGRWV3NuWG0ySDVpazlBb3lxdFFHNHd4bmVpRWZlS2grR0lm?=
 =?utf-8?B?bkZ5em1ZUkUxMm15UDZhajNKcnZtVjQxL2JxM3FFUHNCNDFlc3pWZlFHNW5t?=
 =?utf-8?B?R1IxdlBEckw0cjltTm42bGZ6d1B5SVkvcml5M1ZvVzNxa1pWVmQ2RXh5dS8z?=
 =?utf-8?B?NDdnVXVVSDNQYTl5RktvVVNpN0lkVzJTckxOQWFKL0o5cDc5ZXBLL0ErR2hO?=
 =?utf-8?B?SDcyOE9uVy93MFdOdEgyZlhzRmh2ZHRVMDV6MG54cGhsQWZwUjMrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8be122-b17a-4eb2-ae86-08df30438f82
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 13:51:24.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+SpLos+hfzGERSTIRXQZIUxiH32BWRNZrFP50wPHWQmVgvnT2yYffRrbmCa5FNn6lnwxq/fWfYPSuO6RDlybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4492



On 22/10/2026 15:56, Josef Bacik wrote:
> On Thu, Oct 22, 2026 at 02:38:41PM +0300, Tariq Toukan wrote:
>> The arm doorbell carries the consumer counter, and the device tracks the
>> last index it reported an event for. Arming while CQEs posted after the
>> last event are still unconsumed generates an event right away.
>>
>> The affinity path depends on exactly that, since commit a8c2eb15797a
>> ("net/mlx5e: Stop NAPI when irq balancer changes affinity").
>>
>> Event moderation can delay that event, but not drop it.
>>
>> So the root analysis doesn't match the mlx5 device behavior.
> 
> The CQ has a backlog much deeper than one poll, about 6900 CQEs in the
> run in the changelog.  The thread polls 64, is off the IRQ's CPU,
> completes and arms.  There are CQEs posted after the last event, so the
> event comes right away, and the device now remembers the current
> producer index.  The thread polls another 64, completes and arms again.
> If nothing has arrived in between there is no CQE posted after the last
> event, only older ones that are still unconsumed, so there is no event.
> The rest of the backlog waits for the next arrival.
> 
> That matches the counters of the stalled channel.  It had 0 polls and 0
> events for 150 seconds.  New connections then gave it 16 events, 16
> polls and 1018 packets, so one poll of 64 per event.  It was armed the
> whole time, it just took a new completion to get an event.  Then nothing
> for 14 seconds, then 93 polls and 5917 packets, and it was empty.
> 
> Is that how the device behaves, no event on arm when everything that is
> unconsumed was posted before the last event?  That part is my reading of
> your description, I haven't got a way to check it.
> 

I have to soften my previous reply: the immediate-event guarantee I 
quoted covers CQEs posted after the last event, so it does not rule out 
your scenario, where the leftover backlog was all reported by that 
event. Your reading is consistent with the documentation and with your 
counters.

I'm checking the exact behavior with our HW architects and will update 
here, hopefully within a few days.

>> Is it a degradation? Did you have any "good"/working version?
> 
> I don't know.  I've only run threaded NAPI on these machines on the
> 7.3-rc5 based kernel, I have no older kernel that I know to be good.
> 
>> If arming really doesn't raise an event here, softirq NAPI would stall
>> the same way when the IRQ affinity changes under load, for example by
>> irqbalance.
>> Was it seen there too? I believe not, so it must be something else
>> causing the stall...
> 
> I haven't seen it there, and I haven't tried changing the affinity under
> load.  If the above is right I wouldn't expect it.  With softirq the
> path is taken once, that arm raises the event, the interrupt lands on
> the new CPU, and from then on the check passes and the poll goes on
> until the CQ is empty without arming again.  A NAPI thread takes the
> path at every poll, so it needs a second event for a backlog that the
> first one already covered.
> 
> I'll fix the changelog and the comment in v2 once I know I've got the
> device's side of it right, and move the check into
> mlx5e_channel_no_affinity_change() as Jakub asked.
> 
> Thanks,
> Josef

