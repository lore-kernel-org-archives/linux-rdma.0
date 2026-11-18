Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795046202;
	b=fK/K1P7CP7dS90Dd33WEylm6bj3f73L8dLkkCEhPMehuujOHUf0PPCZI9t1B2P4ppn3R
	 SXJ6sEoBRy0Oh/j4jJpW/wCfeZBgma7KAcyZ9VHl+AtZ8WL5M/SvD2GYnFQzI1r627cJ4
	 ngxCdZxdmidzQBD7dXvN9xxcLNu56E6640lK1+yMwXpEPtwuUpIrmRD8/7ArYkyA/k3Pr
	 fGbJPxaaeC4sJVm0MkaEwFqmsOjEzLdkbah5ZRn9jH3XezYIYA2T+Fu9p6Xa1cN8gfRtQ
	 mpTkGfmQXew3kUnWb/H0tgDv+5bAkCUrvnoi7XsktWYQce03bLTiqSf+tPAAbaShM/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046202;
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
	bh=gy7//yMxaWvv7C+aFAPpXUHRrmg6qOgFJmGgOvc2Tig=;
	b=chtv6azlfoB/UIDacZ0E90mDzEA9DjMAT12HJ5ItPm1KwL1JCsiLp3mxKRk1LCtcfkHX
	 1x5H++/+VeB1FsnoRwyCzWx9ioefBuMBHyyiEj709s97Pzfs2Ok7EnIOJExB8IZ7htspB
	 BRXscTIW4k5p+yh52C5/9fPwH5ssppAp6tUMrcGHMM9u1RlOUE/8oMNwcIp2m65RvgxFa
	 dWwthnd9RVgj2WD7Okhf2ZENR511sa9gZm4gKtHz3ZbP7OpF1B9EsV4+uwNlpA+vyRrXF
	 F06zPvfYpSNCEN0fl69MUcJItpOVMkA5mtLdrsgnzRxEAaLUBTEKNtwOruEaT0MvJNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gNFmT6Yv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.39
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011039.outbound.protection.outlook.com [52.101.57.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA29606A325;
	Wed, 18 Nov 2026 23:56:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DA29606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gNFmT6Yv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bhmfko3Z7OzO3FzpKq/MX23MVgf3yUzjjfrwcjEHFjlpbI0xF7x9/pTA2FnVKEEth9hMo9nS0q/QvwM8AP+U5cu1hyhnvDCcHXEaL5orvf1m7kJuSBNmUsvb7sI+JMjpXMY2GkT7hyqpzfuCxp1YHaVpLmN9ccvrgL6UWi6w1nRyVYQSGWzyhtXALW1QfZ8Ct29FDQ9Nwqld3HjWfoi2ZNCcAcVOTM9u7SUZ02T67wt5i+fgRegEsbYTZ+5euU8j3Kjp6ngXor6AdWj5R1EqTzVgaMdWBthsGiQDLSEnJTwEbAkGJPBBoYU6jQDAqGMIGnzTVbZQcS1QCXADznPs2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gy7//yMxaWvv7C+aFAPpXUHRrmg6qOgFJmGgOvc2Tig=;
 b=bFVzDbkKsuxJCvWhWQ2GPh/OcTPts62DC5L3ZUVSxbyakxRmRsHpcU+77MAQDLuDmzGKeSfw473i3Bnrl2eirJN5K8Sk2mHum73YcNGpsrhzdv+QmkIXIZb2pxcnH1JHojYgpuLXlpRekiUKKzxRHdy5aO7ESZYhDx6Q2m57Br5wUyRTSVte+pEbIxYLOKYWUI8DK0BTH0n4uVkjYbn1/UTCt2YLsn5kVf+EDUm9aEC0fArqWnsHm3Vf5HBNcKySXSkajVpikDqLKDAxzL1Qm81BaLdciat6wIoWuuZDLNfGpHF5XQfoVyZzGCcy2JG5qOxtD9Ocdw9+fcTGhweBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gy7//yMxaWvv7C+aFAPpXUHRrmg6qOgFJmGgOvc2Tig=;
 b=gNFmT6YvPv/sLn9z1fU4zxsvsYrIaIpUsit19bRu26cw/pcIr2yMM+bKICO4Ncjj7tJhs6k/AZ7/vRBmbqczpc8BZx909m1ijbjgZbuyzShv/yXV3psi8NqpwJg+6dEOvJGQJtwHJOzfDnEmRHOtcRJ/81eyXJZBggS9IBpkwyI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 23:56:35 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 23:56:35 +0000
Message-ID: <cd29a3c1-445e-46a9-99fa-131983ce7a72@amd.com>
Date: Wed, 18 Nov 2026 15:56:31 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 3/3] ionic: add devlink param for command
 timeout
To: netdev-bot+sashiko@kernel.org, nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca,
 leon@kernel.org, jiri@resnulli.us, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.joyner@amd.com, ArunKumar.Prakash@amd.com
References: <20261105-b4-ionic-cmd-timeout-v2-3-35a9a2aa48b1@amd.com>
 <179431289941.994134.11663452629837334156@kernel.org>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <179431289941.994134.11663452629837334156@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::26) To MN2PR12MB3485.namprd12.prod.outlook.com
 (2603:10b6:208:c9::22)
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|SJ2PR12MB9161:EE_
X-MS-Office365-Filtering-Correlation-Id: 508c711d-0aa0-4c57-6a4d-08df45cf93b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|261026140227099003|261022105027099003|261026121527099003|261028144727099003|56012099006|4143699003|261021123027099003|11063799006|10067099003|261021135927099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aUF1LOrfR5+d6RPbqIYXxsFMH9XBZJ4RzvomjwDisP+7VkuO+Ez7/9hLvjI5P4SJnGHeT9SZezSsCBv6qHGrX+dmzyul7Xno4uMMp8UL3sgpRLNUmGMJL4GZQbTojiUxcOGcxxBKK7p+U/5CSlWvfB3a5IUHtjrBv/Nov0qMRjiSm5iCJu1xEXPFu5HWfqQBwU9HTQ44EJzdeDHQvuqaNrpN5f2CG7qqzl6em8WGkRPTddNKHTKsaSHtERLIaX1EQ/+srUNkpho2f+IXOw9yEMd+XvsD+oQ8KkrBwk1Kwf97I1BDO4tthohdERlq8ywj+aBXVUoHT90Td+6oDTP1pGbqg6xigi0qlqfMVxYOUt8dAN5VE0F7sU+tupvMxaI7jlEgBQr8U+LWoL/loP99DBlkW8NNQ/sMLzj1uLucnZIi90L8lu45Ajnp0Pcte6M5FaG9afb0QmBpiL9bC+CHy80CRB6Ntu3HGFBVV2ZwznEhyAOxypLzA9VTrzHzjbu5daS6KCwqq/bt5KVu243gGLHWzzu0GVvgpmWz/YRa9HuzXpYOlOEZnzN3OFczDKmYVQUi15HVnLclSSpNTqgAI/WDCY3nYSV8GcBWI3uA0C/nwsu40ZkOKxi/TIfZqZK/LUSY814bpe65f8ddEBB337fEcMh2wL71mcLgiu4dBzA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(261026140227099003)(261022105027099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(261021123027099003)(11063799006)(10067099003)(261021135927099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVE4TlBkc0JMUXlCWTJSYzBaTDhZcDBnMG82aUNNb1o1MTEvVHdPMHFEdFhZ?=
 =?utf-8?B?MkxUSTBXL1g3UlNHU2NzNEdaN1BRL2lKZmJ2cHVtaFpXYnBhRU11d1VXTngw?=
 =?utf-8?B?bkp1eDg4dHJqK1V5V3dCR082aFNpUGlKTEdmVUN6UkJzTXNra0MxVWxYVC9I?=
 =?utf-8?B?NDhhZSt6aUFOcUZ3VkJXUlNBUDVZL1lMdjQ1SU1FN1hKR2loWTN5bmQwUFhx?=
 =?utf-8?B?SnRaelkxSWUrejY1QmlqMkhUMGFGVGtRejJIS0pvWGdSbG8ybFVWRlFESXUw?=
 =?utf-8?B?eXROZHRRRmZZeW00V0xkVFNadzVoMUIwYmpqRDNoVTV4dzh5dEIxM1BlbTIv?=
 =?utf-8?B?ZjFVNFZvV09GVDdPSEU3cU1kbVdMS1dCNkJSY1pJU282ZGxta2Y0SGpTMnpJ?=
 =?utf-8?B?KzFYZGxzRmw0RUU4RWJGYzZkRmNIVVdmclJCMld4ZlRpVWVhWmJHelBSSkk4?=
 =?utf-8?B?V0dVRjhzOVR0QnFnOUtZaHllVVlnNTRId3dGMWxjc2ZVQkVUeDdLMGNibDcr?=
 =?utf-8?B?Y2lrQWhSYUt0UXI4L2JreExTTVA2VXdLRE9aWTREMVlaWFVKRDBaWXJyeHhI?=
 =?utf-8?B?NEZtV2d2Z0lnK0M3Q0hIek5ETHhwRlpKZmJMejM5NTFKTVZibkxpY0NiWXFU?=
 =?utf-8?B?ZUVtTDdGeXgyc3dFRy9oWHVFNXhERXFPbGVibWZiaW5HSlk2VndyRWRYK0p3?=
 =?utf-8?B?TnF6bXpQdlZvOWNGM011VEwzYTUwZGp4d3djK3lXZE16L2UyTUhQdkZNaXZO?=
 =?utf-8?B?blZUblNDVktjQlZlclJjamh5dW9wb2dyT0o1WnMzak9EUWhJbnM5bXpWQWVp?=
 =?utf-8?B?WjArZVRDTjNTQlVrTzVmMVFjM1Bub0x5alMzS2RQbEt3d2hYTUNoclFvejhi?=
 =?utf-8?B?aHBqL3JNd082TnZrWmdqQ041ejMya3Rqbkx1eU9SN1ZXKzd0VkRIZWgyU29G?=
 =?utf-8?B?QXVoK1JjMitYSjBVKzdVaUZYMlB2UnBlcm51cXVhd2RGWVRGaXVQTzk3cTBk?=
 =?utf-8?B?Sjlzdzc5R1FDbnVmU2xRYU5udDg1MWpNNG5wMjk0dDM3SWJDamNBWlVRWGZ2?=
 =?utf-8?B?MW9QMmJtUURZelhISURFeFNnUjVuUlREcnNLNVlVS0JYclcrZHliZ01DcWR0?=
 =?utf-8?B?eVZFTWR6cUd6UzlNWEZzNENZMkxnUUZlSnY0WnVHeFhFK1phUUdhQ25EaUYr?=
 =?utf-8?B?aTQwZlJWdWtzNXJaSXcydCticGtPMjR6cEpLdml6UzBWdlVtc0pEWHBnRUtj?=
 =?utf-8?B?MFE4VFBkNStOUW9od0FuR0VFdEJPT3lJcWliV1BzcnNraWdsdkhwUUE0MTd5?=
 =?utf-8?B?TlpNV1hoemxPUzIxZlVxUDlRN1RNSjlaMGp6NDJTSUFvZEROZHI5dHdSKzN5?=
 =?utf-8?B?bkVZdnRpYjNNcmMwN2lKMHBBcDdpVTlzZEJsSUNxeUVWYkVXbTd4eWIzZ08x?=
 =?utf-8?B?SWphN2E2RTVBelNIZmprMjRzK0ZBd3AvWjEwS09tTGJYNVZiVHJsQmVleFRk?=
 =?utf-8?B?Skh0NXQwK2JwTHZKN01GVjMwODcxbDFROHZZTjlwem41MExUU09BcXRLU2hy?=
 =?utf-8?B?ZGlEU3FrTng2VHl0MHRmMTFWN25aL3BmTnhxWmNyZXZMZ2tNbDFOZFYxTjMr?=
 =?utf-8?B?Ly9BZDhTbzZwQ0xrYjVwRk1EZm9DT2JPRFU5TjBUR3hBOUdXMkYrNUtnNWZE?=
 =?utf-8?B?NnFPclR2WEhzMEdXNWFhdVByeGRQcEpnK1ZzTFNyNzk0STBNTExHdDF1amY3?=
 =?utf-8?B?R2FSUnZYdlA2M0x3bFFnTWRwZ1ZlNldJRnF6UG9RYjVxTm5oR3FHdzBTQy9J?=
 =?utf-8?B?SHFtYVAyTnJ1QXVzaXlEbk5TdHpuRFIvTGhCNG5NajVrMFhGUWxBME1xVnhP?=
 =?utf-8?B?OTd6bXRXNHlyZ0VPTkxFVXEzSnByQVc0aUd3TFV0cVl4cGRCREtKS0FJTFZz?=
 =?utf-8?B?VG4xQ21wNGl2STdlSEduZlVLSksyOGdwKzV1WGNKbWp1bDhNRmpPT1pwT2Vu?=
 =?utf-8?B?Q3J5aW5VSGRVbXRXK1NCUGZNNU0zSFNRdHY3VTNobkFHOHpUTXNWY2dBWFMy?=
 =?utf-8?B?MzZncTNOek1VNGcvWFpYNXpybGZscGZwbWJ1eFVSUDE2MlBheHZvV2J3N0di?=
 =?utf-8?B?d09VK1Y1amYweU5zR3Q0dERma3gzSHpzN3oxdDBzSGFBcnl4TUFya1hIWDVB?=
 =?utf-8?B?Nmw4Q2xpZzRnWHJzS29FTkFCTVNZb3BqVktmVmVkS0RrNFUzekg4SlA0eTFn?=
 =?utf-8?B?T3hRdVl1MkM5UFhYNVNkMS91REk2Y3B1aHlsOWtWUDZCMlk0VDE5QTRZdTBY?=
 =?utf-8?B?WXMvODRRTEFuOUNFRkZkOXpBWVNZRCtFcEMyeXF6S0tHWURQT1Zudz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508c711d-0aa0-4c57-6a4d-08df45cf93b9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 23:56:35.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQuX2GKhqLRyWvAQkiW2pcUUylyE2p3cJM34VsOxWdBqQM59F9gKLmMGBf+WUu8o++71VmYoPI1hcdR0BxP1Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9161



On 11/10/2026 4:14 AM, netdev-bot+sashiko@kernel.org wrote:
>> +static int ionic_dl_cmd_timeout_get(struct devlink *dl, u32 id,
>> +                                 struct devlink_param_gset_ctx *ctx,
>> +                                 struct netlink_ext_ack *extack)
>> +{
>> +     struct ionic *ionic = devlink_priv(dl);
>> +
>> +     /* devlink fills PARAM_DEL with this on PCI reset; no FW_RESET check */
>> +     return ionic_dev_getattr_cmd_timeout(ionic, &ctx->val.vu8);
> 
> [Severity: Medium]
> Is the comment above accurate for every caller that reaches this getter
> through PARAM_DEL?
> 
> When a devlink monitor is listening, the unregister path calls this getter
> to fill the notification:
> 
> ionic_lif_handle_fw_down()
>    ionic_devlink_params_unregister()
>      devl_params_unregister()
>        devlink_param_unregister()
>          devlink_param_notify(DEVLINK_CMD_PARAM_DEL)
>            devlink_nl_param_fill()
>              devlink_param_get()
>                ionic_dl_cmd_timeout_get()
>                  ionic_dev_getattr_cmd_timeout()
> 
> On the watchdog path, ionic_lif_handle_fw_down() only runs after fw_status
> has lost IONIC_FW_STS_F_RUNNING. ionic_reset_prepare() is also reached from
> ionic_pci_error_detected() for io_frozen, where MMIO reads return 0xff. In
> both cases the firmware cannot answer the GETATTR.
> 
> __ionic_dev_cmd_wait() then prints the warning and returns -ENXIO. do_msg
> does not gate this warning, so the _nomsg variant still prints it:
> 
>          if (!done && !fw_up) {
>                  ionic_dev_cmd_clean(ionic);
>                  dev_warn(ionic->dev, "DEVCMD %s (%d) interrupted - FW is down\n",
>                           ionic_opcode_to_str(opcode), opcode);
>                  return -ENXIO;
>          }
> 
> devlink_param_notify() drops the message on that error:
> 
>          err = devlink_nl_param_fill(msg, devlink, port_index, param_item, cmd,
>                                      0, 0, 0, NULL);
>          if (err) {
>                  nlmsg_free(msg);
>                  return;
>          }
> 
> So no PARAM_DEL is sent, but ionic_restart_lif() sends PARAM_NEW again on
> FW-up. Monitors would see two PARAM_NEW events with no PARAM_DEL between
> them, and a spurious warning is logged on every FW-down.
> 
> There is also the case where FW-down starts while fw_status still reads
> running (a generation change, or IONIC_EVENT_RESET) and the restarted
> firmware does not complete the command. Could the getter then block the
> deferred FW-down work for up to ionic->cmd_timeout? This patch raises that
> limit to as much as 255 seconds.
> 
Fixed in v3: the parameter is registered once at probe and no longer
unregistered on FW-down or PCI reset, so no PARAM_DEL is sent on reset,
and get no longer sends a device command

> [Severity: Medium]
> Can an unprivileged user use this getter to tie up the device command
> mailbox?

Fixed in v3: get returns the value read at the last probe or reset,
or stored by a later set, without a device command.

> [ ... ]
> 
>> +void ionic_devlink_params_unregister(struct ionic *ionic)
>> +{
>> +     struct devlink *dl = priv_to_devlink(ionic);
>> +
>> +     devl_lock(dl);
>> +     if (ionic->dl_params_registered) {
>> +             devl_params_unregister(dl, ionic_dl_params,
>> +                                    ARRAY_SIZE(ionic_dl_params));
>> +             ionic->dl_params_registered = false;
>> +     }
>> +     devl_unlock(dl);
>> +}
> 
> [Severity: Low]
> This adds devl_lock to two paths that did not take it before:
>
Fixed in v3: the reset paths no longer register or unregister the
parameter
> [ ... ]

> [Severity: Low]

> The new documentation only says:
> 
>    The value is stored in device NVM and takes effect on the next driver
>    probe or device reset. Only available when the device firmware supports
>    it.
> 
> The design may be reasonable, since the capability can change after a
> firmware update. Should the commit message and ionic.rst say that the
> parameter is absent while a reset is in progress, and stays absent if
> recovery fails?
> 
In v3, the parameter is registered once at probe and not unregistered on 
reset, so a reset, including one whose recovery fails,
does not remove it. While a reset is in progress or after it failed,
set returns -EBUSY and get reports the last value read.

Nikhil
