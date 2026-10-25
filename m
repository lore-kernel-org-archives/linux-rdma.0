Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792938190;
	b=o+4Y9LCQBwRgEt11u+3CWXOl9XISkmhw1TD86ixaeq1Svd8djC7Ff3ZP7MqmbEIahPQp
	 1C3VQK8pQugMlgYCuZbODJjgQoIRVbm6jR7zYklaakT5U40jHrCxnxJ2fatdUYnMgZcSU
	 +Lt2zTJEb9NM/bQRbVbd1AyLgg0tNDtvNast7Jd7kZcp+QCPt1LX0uwTTVghGWuQk+ICT
	 LclpcD3tGOHVp+V1At7HnThFzbhOspbffwsj//qk7a46kZhqV719pxb0SQMc1MaBf1YIB
	 CMz7/NMvhqQ6H2NwmAgRNcScLtlW6PuDVo1vRhCl0j4JqkdDYHtZzWouSuFn3GpuHRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792938190;
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
	bh=Tyy4SXG7SBl5I/mQ6HtziNSRJVdXkRmsb7D4XoUM6Rg=;
	b=ZFBGfMZ/LXM6xhGjyzD4SpwpAPEEqO6A5UGOIB1SYrFP03ZOx4sp9o0qjwl3WFzEO2wO
	 +TMrptMAmSR7DvHX2Qfce46J0JeZ/Mv5BbHiZfrrz3PeUykydKDEgQXsU3v7kX8Ygmumn
	 Lb8414Ol1lOhSqD52mXl14mU3yWrUD18Dnz8sV0CrOOA4qYRrCIFGqx01jv8o8Em1nuJ/
	 qTp1yQtBU5ECDcwVHsoi8Oo+yrtgGHwNWLItavE5tSL/0d1YwcMwakwOFl4XmO/6WYtoP
	 Sf+ZxqaHmS7gaQEXcqrxpDnWz3XnuP/xoZovO1ocZVUaFZiSu8qejDIXDeJWrf4+RXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UjX+ysJN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.37
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B468606A31A;
	Sun, 25 Oct 2026 14:23:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B468606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UjX+ysJN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOBp/tpCvAyqie2CS3/BDs2YYvFGJZyfZIpNigIjsbcXPiv2E6hW+4A/UhGOx+/VeorIupgkqw/naAP+NoEwL23G1IIfUdl8Rx46EI7dMmxflCjiUyJW80M5KC9NAM2Asq2R5wph8ep2sktl06p2qiIuf6CnSx1QpXL/sD64cYRfaclhmO4QzhnBNuB/W7mP6PklxIutBCC2t0Zj+vMpjRabzi6EFt3uM7fEAEemOEiOgEwwcEVQum+LiGJw0+eq8SGT7mQxhhMS1P+zrtMdOOSB9OTmlV98FVnoUenYQcUEn684t0CMfGm+u0UIDITnK1vcEd4GTNISzTzmTxELrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tyy4SXG7SBl5I/mQ6HtziNSRJVdXkRmsb7D4XoUM6Rg=;
 b=PItG5ljAjmsEj7uv0w48Ym3GYpIomzQ3hOAi5qjILjuwMFwg5a4y+rWu2NbEeuO+aQbUSmoaHvua/Jjccl0C2a82E32V8A7ns1IJ1NVTrvYukxHfsbyxnfpW8LHql/5Bk2dr6QsT6CSzXhQjZMOu/PuQ8AxkTQa3r3KjRCcDMu9icv9Bccv9NXrfotOrhez3oRk5avbDVZpBXj94hgX2aCuMDSKCVf/c8W+4ArDfbT/KCuo2Lrll8sqtWjd4g1IFGam7FWaYSv/i8dJlBv/YhatPzHDGuwqc1c9qEGTNo8mv99cD8P7P6+CM738xt70Fh8lD5PMsMt8/vqfPue9TKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tyy4SXG7SBl5I/mQ6HtziNSRJVdXkRmsb7D4XoUM6Rg=;
 b=UjX+ysJNdFOLQo1EESM56ehV2wtzrU/9oO6YMCgH50XXUKDSABkZgorkdYuhDPj7rNaC3TBNm0O5BuBtapo7vSK+WSnv5vyl+w6Ggj2H2VHljmaDQN+iuek3Ay0DiWSKvJenBMJgez+Hmd6eEGUQFpG2DE2JfFZ1p4TgD4lQPHIi+yg8iBIhHE01HsxjdGxVqDJQMKlp4yqC4qqEgoGABD/UlK96CropAn843KG13aRgZiFAPgvpT2YYgGt5f70plyTTULh5OMIa8kPWbupiGlhhAqR4SV4lkkufd8SQqkRn1jUu1uA6PPsQO+6iqPBWrQCNj9C8hoVyVBod22CaNA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by DM4PR12MB8558.namprd12.prod.outlook.com
 (2603:10b6:8:187::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Sun, 25 Oct
 2026 14:23:05 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Sun, 25 Oct 2026
 14:23:05 +0000
Message-ID: <16368a7c-af34-4dfd-9e8c-891d455d2935@nvidia.com>
Date: Sun, 25 Oct 2026 16:22:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
To: Paolo Abeni <pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
 <4758dc6b-001c-4106-9258-f7d902fb01c7@redhat.com>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <4758dc6b-001c-4106-9258-f7d902fb01c7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0015.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::18) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|DM4PR12MB8558:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4c013b-a696-4279-19d7-08df32a37c03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|11063799006|4143699003|56012099006|261009223027099003|261022105027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	R8bADDxN4RU1zFJAeW+nDarMvBr1aSplaFUs4VUc9V/WWFloVWGjeLuaCg3osc/tMttGsCEmcEb2X27R1JiPwv8Et4xUXpqU+aVRqQV9yR4KQR9JpIxRLYzo2pOjk42wPh1TqA55XZNM+/6dBx6zR4nc2BV13BX4KIxTg6zN9Z7ISM5+lU/k9rr6JXojPKABQreGuy5rEIMPAktCq/a3+yeRQzyxWkV1uWfVosHxv7M0I43uFvZJdkH2gte60TWF+YOg8J//gGxIw541b3A49X8BlEpLzn3nhkkGkITN7zDXwEq8u2wqV/1YEzc6Lu5VfJsLk299ZVHz0ellC5qz0uDbWSAhGLGjKOibmunZGfkiL3k5eM5Y2MLiHP3WG5bLwl66qFM14am0652/zr0L/hlullUmh97aJ7GlqiSuqMFiDBKajJcESSEnOHqk9IA9xSkBogsaXBAugCgafSrK+ARpvMuyXlDdsoTlm/roqs35mqQKa9Is1eQ346R1Es1LqXkeSWFjlEEGOqOjg5ycTzFBro4lu0tIjEMO+8rG5W+Uqdag6G2WMLfJoZudw8PJNfSxkEr0Ct4UazRs4yrv/NPL8D4iALHnLRKVTI8FHnV+Kt74/mYyN15YeJOVNrdYhlVtpuMGeyDhKzkIOPDgEinvmjzyFB67hBQryQSOsJU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(4143699003)(56012099006)(261009223027099003)(261022105027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEo4MEprOVEya2hoS3JLZitwdGpMWWZ0S3BnOUQzSmx0L1ZuWWdidUFUWk9u?=
 =?utf-8?B?eFhCMTMzUGtQY29DeEV2RDNmZy9DVk9QZXlvZ1pZNVVjM296M2g4MEp2elpI?=
 =?utf-8?B?V1BrWWNnUUtxUE0xSzFiczhJZzhVcy9MUXFsd1lDRXVCVEN1V0NhZzRBbXVC?=
 =?utf-8?B?K0dOVGRNOFpYTzR2eDhMdHZzdkFxazRUS2pYQlhsVnR6dWlnTTJKUjB4bnZL?=
 =?utf-8?B?YXFOVVVTVk14VG9HcWV6TENXcWlnbUdSbUdrL2dtVnkyQjF6dmJaS3krVVZ4?=
 =?utf-8?B?Z0t6aDNSc3UzbFBoY25NMGVBRXVTTGdQY3Q4SzNPWXNNTWRCaUo2bFdpZy9P?=
 =?utf-8?B?OTRUM0t2eHZUOUNiNkM3UjFSL3FzeE9QSi9JVHpWSTJNZ3JGSEVJRUNJS2tT?=
 =?utf-8?B?UXh2N3NlbWpTT2FjRUw4a3hQTjJjUkgwUHJCOGJpRm55RnNhb3ZHdkN5dk1I?=
 =?utf-8?B?SDNZSTNzMUlIRFZNZmpydnFsbmhhWGxGc1hVdStVendBRmFsdWZFOG41b2FW?=
 =?utf-8?B?R2hZaTh1dndWK2pQV2xUUnNzOHR5WkxtZjVhV3lHVW1XQ3IzMngzcmRSQncv?=
 =?utf-8?B?S3V1WTc3LzZMZkZYMSs2cW93aUk2cExqN3UzUEdoZjF6VEt0c1VXdnIvSFBj?=
 =?utf-8?B?U25TTzdiSjdVUUVncWpVZG4xM21PTDRUa25TdFdMRVNaeG4yVGcwckRMUWdo?=
 =?utf-8?B?RnVWNGlmcTZKdGJoVnNPWkswSEliVnRUdEh0cjBad3BXNkRjS2twK0tQaDNS?=
 =?utf-8?B?SFNLM1AxT25kL2VBUkNrRFlIOW5aZ3AzNzl3bGNmN3pPcUhSSTRnWTJpK2Ez?=
 =?utf-8?B?U3BHV3JIZXhZRjBBNDJZUnFrQzYzeUVaaW13bVpFWjh2UDJLTG5mUTJMV2F4?=
 =?utf-8?B?bEc3Mlk1UW5RQ000bFFjQ1hsTlpkV0xQRk5RUmYybklDRk1JY0VDTFQ4WVJo?=
 =?utf-8?B?UklpMmpyRnZwY1BDYmZiZ3lBZ3ZsbHllWlg0R2JYcmFpZG80WTJmU0p3RFkz?=
 =?utf-8?B?RWVsL3RlK2hURFlwNFFiZTNRSUxMKzdyRzlTbk1pNXdNWHRreGN6NmYxZTFI?=
 =?utf-8?B?YzlGVE9TMEFxMGNvajdqTzVrQjBvWE5MNmZBcXFhVmRLNVVpQ1RPT21MVE01?=
 =?utf-8?B?R3d3dVpRMEZFdlBiUDN5NEJZak5XYTNNMGtBQkxDRnVZZW5QRi9WdCtJamtu?=
 =?utf-8?B?eGl5aUZXbmlXdU5nRjJlUHBJNW5JWTcxNHRZL1hIRnRCbDNaM0ZJU3hKUUJN?=
 =?utf-8?B?cXlZbTVEV0pQa0xXZlVHTXRzdFcxbFJJODUxb2tUdnEwOXpwclVUcjZUc1lR?=
 =?utf-8?B?SGNaYVNOWndrRE1PU1hJMzZnQWo2NjNWTkdpdnRkbDJoWDBjS1U5ZldyeU1i?=
 =?utf-8?B?TjM1UTIxMnBIL3JNaUN1S2RKUDJ5VkJDelZkQjc5dklUUXgwU3duY3lYaGcy?=
 =?utf-8?B?TmJFMzRrMzNDdU0wYlI4K2w3Mzl1b1pxTjlNQ2dqL3NCNVkrY0tSMjBodGE1?=
 =?utf-8?B?cUtGcnZIc1lLVFc2ZElMQlBkU0NVbFBtWWVCL0dNVlM1alVQVWxud0pQd3dZ?=
 =?utf-8?B?VjlOUFhGZ0UxV09vaWNEejArdlh0cVZXeGs3OXpqWGpTV2RmSjM1V0V3NDZa?=
 =?utf-8?B?bkVOWXZoci9BdkcrVDRScFRvelpaVld3bjhJaHgzS292MnV5VjkvZjlyTGw4?=
 =?utf-8?B?a0c5SDk1U3o4OUlTMDhncjFicVhCS2xLTEd3SDN4VEhaMUcwNUxPUEJtdjJ2?=
 =?utf-8?B?Umgxc0tNN1pWSThWUjc4ZjlvNHlxOUtydWN1c2ZIZGlNQk1iZnFOSG1YNnRZ?=
 =?utf-8?B?eUZxLzUwdThWdzNZTXBhcld6bVkrQVlVWUdaNmx1anp2Z0laT2RLWER5Y0ow?=
 =?utf-8?B?QUh2Vk83aHQvMjB1S2svcnpncXR0enhHcnZVc2VtakEwMTlXb3VuUkZFNjF1?=
 =?utf-8?B?ZjJaTHdLWVRxQVlST3lKb1VJWXVGaURRSk1Zb0Q0ODRkdENyQnltdjB3Szhx?=
 =?utf-8?B?WUJNN0hMYXdvZVlWcFRZMjVjQzREemFXb2VYN3g4NXNtczZ3eHdzVmVxWXFK?=
 =?utf-8?B?QmhkNTV5ZEZuT2lRWFhVdHhZRXpTM1NKNnBzcUlLdFlDZ01Hb05XTUM1VUt0?=
 =?utf-8?B?cFJ0WGczTE1OQnQzdkpha3JBMHlaRWpqZ1VHOXJ6WnJpV2RQalFYcUVKOVNX?=
 =?utf-8?B?Wml0dVJVanA4YkZjNFVTM2ZJamdzOWl2djZybktzZDFxWld2L0dNNGNQdkF4?=
 =?utf-8?B?OE90QS9BS2t3RjFnT1UrTWRJUUFmMmxiZ2hJQkFFT1k5Vk9hZ3FUUDUvb3BV?=
 =?utf-8?B?WnJmOS9zSDl1Rzl4UktWV2lNUzRmMHhvMHlsbVM3Z1pIRjZvTFN5QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4c013b-a696-4279-19d7-08df32a37c03
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2026 14:23:05.2331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJ06DGK7zg28BRqMHJ/sm015ptFA3lwaVfWRXtQGzZN+3oRFdjFVSMHqcTh8VTrYzt3L4em69tOyOc9RyTtLHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8558



On 13/10/2026 14:33, Paolo Abeni wrote:
> 
> 
> On 10/6/26 13:24, Tariq Toukan wrote:
>> From: Or Har-Toov <ohartoov@nvidia.com>
>>
>> mlx5_lag_disable_mpesw() never called mlx5_lag_reset_vports_speed(),
>> unlike regular LAG teardown in mlx5_do_bond(), leaving stale cached and
>> FW-configured speeds after MPESW is torn down.
>>
>> Call it from mlx5_lag_disable_mpesw() as well, so the reset is paired
>> with mlx5_lag_set_vports_agg_speed() on the MPESW path too.
>>
>> Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed 
>> to vports")
>> Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
>> Reviewed-by: Shay Drori <shayd@nvidia.com>
>> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> The AI reported feedback looks like a pre-existing problem with
> mlx5_lag_reset_vports_speed(), but AFAICS it makes also the fix
> (partially) ineffective. I think this late in the cycle it's
> preferable to avoid partial fixes.
> 
> /P

Hi, patch "Lag, save and restore vport max_tx_speed across LAG" 
(https://lore.kernel.org/all/sashiko-outbox-183123@kernel.org/) that we 
also send now it completing this fix.

