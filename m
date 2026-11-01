Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793529703;
	b=lboME8rUScXqvEuQBBQmHZ9uM675gIqwW5p+v6jWRnhyL7xUVsLm0dqSlJ/RlsQJ2zYX
	 UPyK3AE5gxCcykATZ7jWTcaM2Sj283UgWVXTqh2YT1YOsd2jmSafFWsty6ZSjdiSqQPau
	 fA9H11tcQBT3Sr40aiH6EH/REre6GHecwxBwoScxe8s9BepOFQ2b7Pevfw8lnBfhvHhJq
	 qVurZS5VAg9RKmKS23JkE9aHPkRMsOFYxnwp+4Ts9TkL1VuOzn9TlbQyAFHp+of1+hp+k
	 GTjCn/3cHckXtAIpGR5+tzvmTuKESgecu14v8ut01y6B9KdUbz0+EKYbSQK1XJeJZJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793529703;
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
	bh=Xit8D5MjK+x61ju7BRNSSGUolMqHAK831XSJsrg0uHw=;
	b=y/dnAeRXQuQyAXDNtM+uElnP1SlAOoTctAbD06s5x7p4/00/O0txhVz0vWiAj/1b6vYh
	 LDNIJV1I4Y7rU6S3lXDCQXQAChH0nvXyzwzGW3Y0sRqX2Q4JAofUN/bNgnClE1FQZ2QCm
	 TIii8as1YmQl3U7ckFnihKhoQDleQl2Fcj05R/L0+0xhmooE9xjHwy39MmH4wAm2NDnf5
	 fk7C/heTRMyJ13im8JTCO7O1WG10G+lqUDbHpjQ2KogrUUcM67uRc9w02RNE06fqGHIr5
	 jl82u/zHsvfeKBOK1f9gw2dEwzxBdy2sOJHuPSEZnPQyG6tIucfyRFXguEnJx1Pp6zA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dwAUMl08;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.34
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5792F606A324;
	Sun,  1 Nov 2026 10:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5792F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dwAUMl08
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jRVc6QgH78q5j7qNg3mNpiFGm7RiIORegO2DRMTsPnIG93pe1BHHPm2qwclFe0TTYd/OjWZvEMuSj3ERYXabldEMQ21xmz2n967ojNPShHZJBZNxqLY1dtLLc42KHFO8MsQJCLgwYhnR4UqkHxCfbRm3W1IffM7TLL3kdcOqG6hywEfIEScuK8M2jhmnYfF7oLg83DMFZIHqpDeBgoRxPlNFG05QlJZnEXXzrzlSq7DtSzmHSx5WvHFcGB/p4bsPa7Yyo7ipgRkd2pPt96GONEKw7yprOSWg9LVFbxcxgd8HGrS6rHlLAtp3+XxcwiF0z0E8HyfX6Or7fg7IDu780w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xit8D5MjK+x61ju7BRNSSGUolMqHAK831XSJsrg0uHw=;
 b=riqUnYAQ4amCWGUGk5TEb2S/AOotrrlmuIJ8ISaRVB2dxZSc/ZTt1S9WSBpWSdzS/7ea/7tWe98y4DdXtRGGM0f+BaGxCsLjtMAx4R5AU/mEmY6ygehc6V+vLV8oGd/sgZ1SkxuwZ97luUzJQsu09535teURC0TVABgquaiBRqCFZmHipok+BMe1qpDjc9Uu46DxYDcF6mz3ZPfn+c0rqjE68x2QA18qY9zkv7xGRHj6Hg51wrZqwVz+X0fScMbZJBpCDvyC/mQNAyfQMEkDeXozGJsxDt52UquqUxiMH9fs5PnWMSSodbtaCyuw8MuNRqUMbgy0laJWk5YEQaDyqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xit8D5MjK+x61ju7BRNSSGUolMqHAK831XSJsrg0uHw=;
 b=dwAUMl08URAk5JP/tkWGMhg3OX7Fj5Eus8e+tTVJG11c5JtOAPuJVfzOq+b9yCA/OcSeeeTiwLQV2pyJ/XhMfkBx0aO+OmAsusRwGHZ90BQkGPH9ouk4GkjYK9guny5xxAA/Zaxsyd0kSz70v/nJvC1yIfLAybsl0y/vLQjbp2eLqbV+Voy0K+GgcYc2SLuBEj1BfPUVV8Bo4/aeNq+2zuFF3PDdjDoWvJcJgGZ1lzfJwGAWFl/xj2tEb9cM98fFgDwKWXbuqGkOTRB+ymTzLnvjkKlYChmgl8Y7yh2iI57SK2BxmqgsfrMEaOa+ua8eJ2EZ/FFLMUWGktlSZ/DQRA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CY3PR12MB9701.namprd12.prod.outlook.com
 (2603:10b6:930:103::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sun, 1 Nov
 2026 10:41:39 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0569.011; Sun, 1 Nov 2026
 10:41:38 +0000
Message-ID: <53ba3677-af71-4d8e-b445-39e08eea8b2d@nvidia.com>
Date: Sun, 1 Nov 2026 12:41:32 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v1] net/mlx5e: kTLS, Fix missing error unwind when
 enabling RX offload
To: Simon Horman <horms@kernel.org>, Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, borisp@nvidia.com, witu@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261026095346.1212609-1-xuanqiang.luo@linux.dev>
 <20261029134019.GG257209@horms.kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261029134019.GG257209@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CY3PR12MB9701:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8e1df3-ab36-48b2-b18f-08df3804b5a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|6133799003|10067099003|22082099003|18002099003|56012099006|11063799006|4143699003|261021123027099003|261021121427099003|261026121527099003|261022075727099003|261021135927099003|261022105027099003|261026140227099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	iXHwgjpNNFRE2P+EjeWb3wNjXXrX+N88lotN4c/8lfpqHLkZkb+B1ITKPpjGa57M+T1zlnfNSR5HWAVfHeKKh/RtP/em3aQ4qAYRfxQPD1E80ZxEgpqqaq99ceAtLLB7ZiLttYpLz5+DuypdPfiodiuc76LsTw0/axjvsX8/kudpqn3lGlTrHGbdAxwTFoDqSOoevUn9OWZT5qYLuxn63jc8u8326bBnI3/ny8dyjEwSespByFiWgA49WDGy0foQJFc0YPgp9UtpHfuAuFIekFckEegp9wvup1Jkd954BgnedtYMnJ9VJmLir6bo3k7h5v7YFRj6qorzsuDGim0RqIlwAbHhtd1CS6czAYEWyztn2MH4trFlWB9Txxt9NheYbGzrQBHAsWUiXjT8vWV7UnQF1zGMSaGr5hb0HoMXIlDaR067VtwgRWz7knAgBiMfcL9gyYX2xUqBhIdAHA093LdQJnGqyf9yPR6JvIbVmlZ1ffm0fJcYyORddkLBPx77JpX9zSMWVsCGEkHUg2/9aq7apo90Hlxs9rD6Xo5M4f0ua1MlUy6bSR+q8QOpzfRr1ve/TpPK132bbB66RJ7U9c0iLXev9dOdcmAcrAMvCubcPQFvCWIvyno27B4CFzvIsFMsFaT4gsbZdNKo5IQhMILdHy69gIqQHgDCOQ8xuV8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003)(261021123027099003)(261021121427099003)(261026121527099003)(261022075727099003)(261021135927099003)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEVSNENFMEJnanNlK1htQzhjUWN3bElvWEx6WlNBMDFFRFJJZG9jU3NvU09r?=
 =?utf-8?B?dFk5Ri9lTXYyTFdUVHpYL1REeFJnZUw4TFZXZi9ZTTFPbjRUeXY0U0Y0NXRZ?=
 =?utf-8?B?U1JzZHpGVHl0UGZCWWxQZGpWWHNJVC8wNzB0Vk1aaFR1YUNZRzBrZHJjZU1p?=
 =?utf-8?B?QkhBQU4zWGpWcjdHTUNSeVlBaFpkdEZzV2hXS1BweUFoMVlmSlBrMnlXVUVV?=
 =?utf-8?B?VjRpbmVYOUZOMlpqMzJ2K1BlU1padmJNbHJKM3RGV25icVQwSWVFdzRZZ291?=
 =?utf-8?B?bk92MHlZT0x4NitOMkxZcGI0aWF1dnBjcXpBS3VTWjZ2RllFTkUzWFZ5SHZW?=
 =?utf-8?B?WXBZd1BEeEZydGVXSXdNUWZlL1pmYW9BbEk5TGdWakdWR3AxcVNBU0pEdHRL?=
 =?utf-8?B?cytySCtaa0dCakNkQm16cXlVM2tFaHZmcTNSNHBUTEVNU3VuQVBMSldFT3Fv?=
 =?utf-8?B?cGdVbXFDL2MvU0dOYnZ4cnA0VmV2MWJudXIvVE85WnZBRFlxWkxkQlFBd242?=
 =?utf-8?B?TUtzVUtzUnFKVlJmZkc5aitOZ0k5OW84NjY2OFU0dm9uNlVjL2xrZjR1ekJG?=
 =?utf-8?B?bnNaVXVDMHN6dWl5Sm1tOUs0NkxWQStuK0p6TkRjbFQzRHIzRXgvdkN3L1NZ?=
 =?utf-8?B?ZEtuNVl6d2hKa2VnckE2cVRjd0czNzFmV01jb0Z0R05KdXAvVVVJOTNsZk9q?=
 =?utf-8?B?bGMrSmUvVnF5RG9EeHdIYzNWZ00zMUViVG5ib3E1UWxlVXcvQzNIdWp3Mm5r?=
 =?utf-8?B?OHEzNzhUWExQZHVxMER6d1FEOHJ4N0pxZklNTzhZWU5mREM4d25HaXFpZDhB?=
 =?utf-8?B?dW9jUHdtZVl0MkIwN1NmOEp6bjFtWWF6WnJMRWVqYXg2VHVDQzM5bnpLejJs?=
 =?utf-8?B?MXFNejJQSVJTQk40MWgxN2IzS2lQQTNuRHdHRXBlYVpITDJVYmNGOEhKdW11?=
 =?utf-8?B?bkhUMlpHR3l1TW9JVUZkUzNTS3hwcnN0Ykh6S1RTMkNPYXdXaXBmNFd2QUpl?=
 =?utf-8?B?c2NTTktvMTdtaGJDQWRwbDkvMHUrSGlPd3I2RVVhRHhLZmZEK3p6c01TMXhv?=
 =?utf-8?B?MzJ4Y25OZGl1TkN0ZXRKT29Ua2dPM3dkN3VLSitaK3RieDdpK2UvMnlGWHlB?=
 =?utf-8?B?REpPakF0blhpK1hzQWxla2Ixb0tZTlVzZzgxU2hvWktqUW56WGd0empvYm5j?=
 =?utf-8?B?VnJvb25CLzk3SGlpTThYV3BJdlRzNkJCSjFGMGtNZm5YSHQvdHdjRThja0kr?=
 =?utf-8?B?c0h4TmVPbytTUS96QVBjcnBaVEt1QitEdWc2bnVkbW8wNy9BNmtmemRZaytx?=
 =?utf-8?B?VXFZc2NDOFhpdVp0bFM1MzZZNmx2cUJ3OXM4K2ZSWEh3RldpVXUvbGMxekdX?=
 =?utf-8?B?bDNmaFRaQjg3RS9aRXVNV0tlTzVYK3JYdXlaTFByTUNHaDlvV09RVlg2cUhY?=
 =?utf-8?B?SzBudDEvL0grcWVuUVNLenp0ejd0MGJiMjdqb2NuVFJ3ZzVRSU84bGZtSE5j?=
 =?utf-8?B?VDFadmRhK1ZwdlNRN1Bja1RFNDNxcFJqUzFsWitjWEpPMjllRzd3Y3RzSlZF?=
 =?utf-8?B?N0FGcGVwcE1PSWQ0eDErMUp6cWVNN1dwcGRvQlFGT2xQblRvN2s3VFFHZEhF?=
 =?utf-8?B?MkJvMVVUQmdLbXBBQ1NQeG14Z21MbDRLUDRTNldORUFmNjRFRE5xVHdTUWhu?=
 =?utf-8?B?NEtCUVlGc2FpOVdiWFJEdnRtQTBIanpDUWNla01MYWkvem5ESktKejhrMDVO?=
 =?utf-8?B?UnRzSEFvcVVuUVZWVzJnNU9mWEVLNkdKbjFEOUhUdFUxK2xEZXJmVHhUc3VW?=
 =?utf-8?B?Tkl0WWZBVk1qVjNXY0NHdWExVklaZTZVNmNFYVd6Z0U1R29naGNKblQ5Ui9I?=
 =?utf-8?B?MmlHV2FoUEJwNnl0UGptdzdlRXN6WHJaV0NkT0xYSk5FZU1UR3JQTTNoM0Vu?=
 =?utf-8?B?aEFPYXNkOStaM1VlUHo1Tlp6THVMZzdDcmUzU3RDSkkrZG5QSUh1MzZFUnRz?=
 =?utf-8?B?OWk1NXdUWlpWMGpQMmJpL2tiOUVmNlQ5bVVkZndrYVhRc2I4M1c5Q1hsaERz?=
 =?utf-8?B?V3pUV2N6bVptaU5xbncyMUxIY3c0UHA1WElQdGNXZldXd0hSVyt2emErVUc2?=
 =?utf-8?B?NW1ZVmRIOUZzVWNOa2lHREtTbTcxZjc2NHc3T3ZuOTNlajhKeHpmeVVtS2ZJ?=
 =?utf-8?B?ZVZ6dThOR09xc051RFRZTDhSUlIrQkhuamNiWHppOHkwQ2V3elFPWFN3Tm80?=
 =?utf-8?B?dW54ZG1SRnp6OWFKMXZuMjJ6RWliRERGNmIrVk5VWmRBbWVmY3hTZERTbm5k?=
 =?utf-8?B?Ni9KaVF4aFNSMWxUTHcvS0FkdzhWZWZicmlzYm9nV09kNGd3VDUrZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8e1df3-ab36-48b2-b18f-08df3804b5a6
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2026 10:41:38.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5qxFoP/jDhTjDjw7H4E9kWyuTqN8R12nDpsIPoJQ2yDBBaCYzb/4ewMHZziB8nfX9kGiLUYcvkfTPmM+ai1+uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9701



On 29/10/2026 15:40, Simon Horman wrote:
> On Mon, Oct 26, 2026 at 06:53:46PM +0900, Xuanqiang Luo wrote:
>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>
>> Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
>> ICOSQ"), the async ICOSQ is only created when an XDP program is attached
>> or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
>> the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
>> the channels so that they get the queue, but it ignores the return value
>> of mlx5e_safe_reopen_channels().
>>
>> If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
>> which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
>> enabled. The next offloaded RX connection then dereferences the NULL
>> c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
>> not help, as the flag is already set and the reopen is skipped.
>>
>> Propagate the error, clear the flag and destroy the accel TCP flow
>> tables again, so that the feature stays disabled and the next attempt
>> retries the reopen.
>>
>> Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
>> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>> ---
>> Found by code inspection while backporting commit abed42f9cd80 to a
>> downstream kernel. I do not have a crypto-enabled ConnectX NIC, so the
>> failure has not been reproduced and the fix is only compile-tested.
>>
>> The crash itself is the one described in the changelog of abed42f9cd80
>> ("async ICOSQ allocation is not triggered, causing a NULL pointer
>> crash"). This patch only covers the case where the reopen that should
>> create the queue fails. ktls.c is also the only caller that ignores the
>> return value of mlx5e_safe_reopen_channels(); the callers in health.c
>> and reporter_tx.c check it.
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> I agree that a minimal approach to addressing this problem is appropriate
> for net.
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>


> Reviewed-by: Simon Horman <horms@kernel.org>
> 
> However, I do think the logic of this function is becoming somewhat
> convoluted and would benefit from:
> 
> 1. Handling error paths in conditionals while leaving
>     the main thread of execution unconditional.
> 
> 2. Use goto for unwind.
> 
> This is approach is complicated by the function needing to
> handle the enable condition. But at any rate, maybe a follow-up patch do do
> something like this would be worthwhile?
> 

Agree.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> index 3cc1213c2f68..0f5dcd1b822e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> @@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
>   	mutex_lock(&priv->state_lock);
>   	if (enable) {
>   		err = mlx5e_accel_fs_tcp_create(priv->fs);
> -		if (!err && !priv->ktls_rx_was_enabled) {
> -			priv->ktls_rx_was_enabled = true;
> -			err = mlx5e_safe_reopen_channels(priv);
> -			if (err) {
> -				priv->ktls_rx_was_enabled = false;
> -				mlx5e_accel_fs_tcp_destroy(priv->fs);
> -			}
> +		if (err || priv->ktls_rx_was_enabled)
> +			goto out_unlock;
> +
> +		priv->ktls_rx_was_enabled = true;
> +		err = mlx5e_safe_reopen_channels(priv);
> +		if (err) {
> +			priv->ktls_rx_was_enabled = false;
> +			enable = false;
>   		}
> -	} else {
> -		mlx5e_accel_fs_tcp_destroy(priv->fs);
>   	}
> -	mutex_unlock(&priv->state_lock);
>   
> +	if (!enable)
> +		mlx5e_accel_fs_tcp_destroy(priv->fs);
> +
> +out_unlock:
> +	mutex_unlock(&priv->state_lock);
>   	return err;
>   }
>   
> 
> ...

Makes sense.
