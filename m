Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793904511;
	b=sfV0HzxcfyGKQJMNfEGjDBgcBTOfk0HdvMtA19igbAv5N49LPb/GEPKkMWVQJxtawp7O
	 8TC/KriDMYPzlFSBDCnQdsc/Bl9ZxDFLrEssLjhb/xST91Lzt5jsIzXk2CtXQPnlfkEJN
	 CBHJOIj9YmAy8UQs5ms017nO62YUpmoB13RTSI8AOTnDK0T+9RoCxWwFjSv4GVfl90iDS
	 GEGb6FoHnuCJ7eEVfjvvBdLoY9kAUR5C9rOBvJF4l1gEWwVAmdf5KLor/qSFje1QF2/0J
	 DUX2+W1SUoS1Bj5ufgqJK3DBInxKcn7twVcJOsDF8uxoO3JzQeE03jqM9DJwWN1Mrow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793904511;
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
	bh=Q1kRMNOS2g/T6CP/CKHGpVzLDLKUYfA3eewEiLLpqHA=;
	b=nX49vWL3SwrjKueyXeacf2W/TYB7ZmfnnL7S+ds+/fbhdpCeQzgEl+w14/KLsrq+6XJ6
	 xOBz4eYpfRLKfnkmUlduPw5lwsTy3+x3eVT4yRvXDygCO43IgEw04C8uTAkqLLYlPqsY8
	 rN7GzXBUE+5P3JWjCTGgAmE0aItEtkbbPiLXw+K+fPiOSbRUSeyO8sBOKnG5M/6OF50bJ
	 bgsnDnQ8V9uiItg6Vsg0EZxVvEwNF11gA2477vRKjl7EQzCIPHveWUQlTQeqCvoKk8tor
	 Fapxh4OTvotuTva4RaACfi1Znue6Ti1j+nbHUaMdJUzi3r+QBpc62DxxLgcXQfet+0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jGNKY1tN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.32
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DC3606A31B;
	Thu,  5 Nov 2026 18:48:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79DC3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jGNKY1tN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pquRiI97yw2IvfB+t9wmSrjrG+LmebKQnyK1hblAuGT9hO0yHnR9FhOcMWerefRT/QwxiU5oxvUuLrvO79rk4bBNvIpLlXo7bvmqVOeHKxbgORp2/4LAsSnQy8Z1QoMZnTF51EKr1yCmt7q3OtG0HH3wUtg0KLotulVpCpZFO8P/5YmvXlEHVn1ZmccYyPyJvEOHfw4n0R2JjSUzIg+jkQHlaXw3aNoorA9A55iAozo+BKA3UUuQGwiE7fXkLXz7cIzJYbW7KcZSS4u/sVKTrgaR/ao+fCfudMz8Z09iNGYz4AEwfv+Cg566nhq15QOY1gZrhOMN5gxya7ED2Z8OeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1kRMNOS2g/T6CP/CKHGpVzLDLKUYfA3eewEiLLpqHA=;
 b=KwnPkSmzIq0/nDbU2UladuJeBaVh+k8CtOtO19yOnmqIQ2nSMhrNdg8AgiHnvsuu/Tpgj4ChFW++QoqSSsQYjs/XFl9NENOKlkkDbNSTkBtE9eseqBReMV6Wg4EFhNjihewXtQhLa6Ojv3fFVkTIBCidyfP5sUhXj8Wd8gbMnz/1MQ0bcb+hjlhQIzlfe3tLsxPwlAzw8LSI4sW4SsWDvIdbSTxooiI9YUP/1rBAn0yeOAAv/svPTl5hbrJe1+iXnYDQfb9/Kd5l2FzJ//Ldjh+yqTMjQ1T1GLCdxcqcHVc7cvxk4xoDLPn1bq2132BB/iDm8KVl7XNk4yuo61oxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1kRMNOS2g/T6CP/CKHGpVzLDLKUYfA3eewEiLLpqHA=;
 b=jGNKY1tNSFCpZXT8ZxM3tQUabgEp6QS4Y2RJhXPma85UdGhCXy8hcmP3x7bsbUyYg+eQGIRVLhmVfdUktt4TG8MShoUEw+99DbdHbAt5uNqDlxFJi8n7gg8gGm8hyK9deT4bJ8dOwtYDq7F74q5eHQ8CJXm+v2pAVMeldf9RZCTd2b/iv2sGoS0xTURyx0iWXf2RPz+Q+9tzZ1MP+MiOnRY58ggGSB98xZEOX90lSdatoKPr97BcrLALqen0fFHixHP3pxtiGfZBVqpkTcN8xBMs/Er0VbZARcAIukQrlDZKETp48SsFeBMCaIm7NpGH0WH5uGdRMh49guQACvDyfw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by BY5PR12MB4225.namprd12.prod.outlook.com
 (2603:10b6:a03:211::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 18:48:27 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 18:48:27 +0000
Message-ID: <65b12759-48a6-4550-a847-de40cff176c0@nvidia.com>
Date: Thu, 5 Nov 2026 20:48:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5e: IPOIB, Fix QPN lookup race
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: dtatulea@nvidia.com, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Erez Shitrit <erezsh@mellanox.com>,
 Alex Vesker <valex@mellanox.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261031225749.14214-1-prathameshdeshpande7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0016.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::18) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|BY5PR12MB4225:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a1440d-b9b6-46b8-c00f-08df3b6d60a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|921020|56012099006|11063799006|261021123027099003|261022105027099003|261009223027099003|261102123227099003|261021121427099003|261026140227099003|261028144727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	drrnmDUBkNVYtQP2HwCsYdtwG4BiLoYTo56E+OPnCCq3UMCdpHgu7fhNBsLOrSDasjUVemvUxFFqwS1jgSzKxeE2PLLElM9LqlXHN+BBt2ZXd6kwLYJqwZ8kTfUquyLD6gnSKz2NttjrxQGH5Y0bwp9d/2q7K81/X8LUaog6dmHkD2vXM08fzxWmn2YZ48x2KhhS389XoOsqHFO2j1mbV1nVZbxV83dqmyqdGaPvrQsRWQMfBe2jZBdvrH0vFzr3qZYxHJBcoTLt/PhGJoycGxrUwKMLrGkzyjaL0yhHZLwp6xKC9InThtqotkTw+nBof6BdcqgQ7ZN5XJcBSVBH7pZoVSxyPRS5qYRoh2jT30c07z8wIHbodx1JAVQfdemrJaN0M+TLjJUaNXjDgyJjHad+7wvXaREAWzNtm7l7yA/s92Px0J2bX7gSdWZ6y5fT+icQwZRfPsyagAaslektb716FnrJiCwFiSodmUolV19QAeZ3S953l4qf4BTbVEBxUmnDw4vYB2Z0E6xRfO9SokQOl85orM/J6Bt0pD5o9g3XIOwc+m/4aTwvKobiZgnJuyrEwC5tGWh70+dAHU1Fk1elRCfONQWu7s9rejICmgPnE0I8MGs9F/1aCTV5AsSlnHbm3vLga97jLbDfwWXHrwKC9OOP9dxrnf51ndvdJItoBQhv9jLyauJSnjBmKZvQ3+vYcBo8hTcFZxjGVNMK6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(921020)(56012099006)(11063799006)(261021123027099003)(261022105027099003)(261009223027099003)(261102123227099003)(261021121427099003)(261026140227099003)(261028144727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDEwa2dVWkJKYmV5aUwrZi9IeFJXYnNNMk5TYVVkMTJESVUyY0cwL3l4WGxH?=
 =?utf-8?B?MG5JblYvUVU2UmRWdUE2ZzNCVHduNDF0dGl1aVZRMHdZWDVhbkFrOEFjbFo3?=
 =?utf-8?B?b0xxOGRkYjNVZElhNkRVK0FnNTQzckR1VytGWHpOL1JhQkVaWm8wbjZ1Z3hr?=
 =?utf-8?B?eDR2TW14TjVsUitBSkdQQ3FpR3lORTFvdkVvR3NFVEp5ZGx3djRsckpDVzRy?=
 =?utf-8?B?VFlSM1JjQzdZOC8wek5FVHZHNkNUT3prV1VmVXVsQWloczh0UHZySGFkR2do?=
 =?utf-8?B?Q2puL3p6L1FoNjZGR1ByY0Z4SlNmaUc2cUMzelJwcFR3V1pESVZ1ZVlsZEo0?=
 =?utf-8?B?UVFvcXRTdlpXc1VwQUZGeThSUXBRc0w4YVFIeW52aDlzSUE2Q0hWN0YvYmpT?=
 =?utf-8?B?YjdPMm1SQzNCTEFleWZ6NHEyVnFRTFFiWG8zUFRMaDFieTNCYkVMN1JHRjdp?=
 =?utf-8?B?U0l1a1Y0aFZBVnFMamE0Y0pTQ0cwK05SdnpjdEx5Q3BhVTV3YTdXTGhoZWVX?=
 =?utf-8?B?RXhxUXBhMW15OXRqVzZsL05UbXRyWDQxcXBmTERjdHJKenY4MFQ1MHVleDJN?=
 =?utf-8?B?cHVlSFRGNVQ0akhFc3hka1VFbElKaW02ZEE3QytEOUN1OEQrTGd2WkdtRU1E?=
 =?utf-8?B?aXFZNTZlRm9SSUJrN29OM0RSYTgyZ2xpbTBqdGJxdWtNSVREYWozVWZueXRN?=
 =?utf-8?B?MXhJV2VwYmxtKzFRcW5JUlVaeHVZY0NtK3lITzY2di9MTHd3NFZVTjZ5UzZv?=
 =?utf-8?B?R3UyVTF3TGVHRXhUT2o0NEp1NkI3UHVDZ1hDNHJvNjNFUmdkZS9sQjIwc1JL?=
 =?utf-8?B?WWRLYUlFZ1lsclhNNWJGL3Y3dnBqbzVWU1pOYUFwKzhjZGFwN2I1RUVjUFpW?=
 =?utf-8?B?M1p0SlgyQUovZFBMNEtNK3g5WE8zRWordHJKWW9keXQvL0twa1RtdjB1bjl6?=
 =?utf-8?B?Zk5qaVp4bERhYnIxZGZJT25sNTJaZWVQUm5GYjZMS0ZNMDVGcmFjVWRGMmpu?=
 =?utf-8?B?NmJIOXNpTVI1N0dWQlpoeXBSb2VhM3Z6V01tZDhwTGhBZEFMbC95K3NNOTdz?=
 =?utf-8?B?OWNBczVtN0g5aVhQdytZOTBBY2lEZko3cTU0NzB6ZFBPVmpwMHg2Y011VytF?=
 =?utf-8?B?YUx0b3BkTWtkbStBcHFDZ2M0VVhMVDFLQjhtdkhtdUFmWEFySjNHUFpzRTJI?=
 =?utf-8?B?MU1oZENveEVrdmNmWTRId1JSclZGMDlXVEdjZXJnYk41Vy9wUXVwY0xzZEFN?=
 =?utf-8?B?Mm93V0sySDhMRUZSSWIyQ1BNY3pNSi9VbjU2QjZrZnJML1UyTCtTMHNMR3B2?=
 =?utf-8?B?MEp3eXhjRml0TFByNVNvbW1UWTBNckV3ZDJKZlVTM1ZSdlluNFRreTdIbFBx?=
 =?utf-8?B?MStkbXpmNXlkRkl4WTJtYUlDZjVybWNIQWlEMytjRE9PcGQrZHA2MFIxMGVF?=
 =?utf-8?B?ME5BdGRENUFXbFl6bHdNb1RVUzk4UWJqOWtacEhQc1NiSy9MdXJhaUZVTFoz?=
 =?utf-8?B?Z2tMRkRGTCtYMkNINktEQ0R0VWVKeUlhMDZBaTZQeFJnQllaR0o3UW1GUVp1?=
 =?utf-8?B?ZkpwaXZYYkdPcVE1cEtaTWMyMDZ2SHI2RXIyWkRydzdFRVlvRzQ0RUdoRmhy?=
 =?utf-8?B?OHh5Sm9wQ3o3UTFKMUxsNnVqakVxc1hNOXhqczlMdFY0TnkyR1E2M1hTa1BU?=
 =?utf-8?B?YUZuQUpTVGRLWGZXeTNKRkdpYm1lcklLZG9mWHNOOW5zSUc5cXhBZ3hETVVQ?=
 =?utf-8?B?UyszR2I4aTBqaWUxSTk0MEFwTkt6RjFuVlJYRnE0WU5OaWcyQ2FWM3hHTlpQ?=
 =?utf-8?B?VkhGbk5tdmtXaUZQWWVTdXFXWDd5L3ZReVpFL1IyUEZVbjBvSm5FYnJWZlVM?=
 =?utf-8?B?bFJOamlCOU1YdHY5alVjbU9VdCtabHRiME5PVHJiSGVwcjVhMXBoL0MxWjh0?=
 =?utf-8?B?U3IrRHI3MlJNd1J6Z1o3bHNhdDdQRG9UYVlmdHFFSkZKY2hPUURxSjFUT0Z5?=
 =?utf-8?B?eUU3alZYR3VLQ2RvVTlHeHdsV0VCY25WYXFOUEFwckVlL1hETnNsa0dobjd6?=
 =?utf-8?B?cTZtU2tUS3JSbm9aRUJVQTF6QUM5SjVrRjF1M00wM205N0pudkU1MDN0Rytk?=
 =?utf-8?B?ZFY0bk5scHAvYWg2MTJEWEVCVkU5S29zRGs2R1BVNVVBQ0dXUDN2VU5zQ0F3?=
 =?utf-8?B?NlVrUERmZ3AvNVplbFhMeFlyaHFEWmlUUFV3NFB2VE1JMnVOUWtJelVQM09y?=
 =?utf-8?B?M0FOMG1wYStSNnoyS2ZQY1ZpMThleGtWWFV5MytUQzNmQ0RsemJ3azJ6Sktr?=
 =?utf-8?B?UEVpb05PNkcxSUJtZFNrRi9JTGtEVUladGRBYnh1VUxGRHd0VGMxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a1440d-b9b6-46b8-c00f-08df3b6d60a8
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 18:48:27.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6btohIRcpf2jQNembU/h4JRyVohusNpuDj3JssRheH+k1xf4EHW7rp1iU3W/pwt60aDdKsIoZ8aHuaKSJm4r8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4225



On 01/11/2026 0:57, Prathamesh Deshpande wrote:
> The parent RX completion path can load a QPN hash entry before
> mlx5i_pkey_del_qpn() unlinks and frees it, then dereference freed memory.
> 
> Use RCU hlist operations and defer freeing with kfree_rcu(). The existing
> RCU read-side section in mlx5e_napi_poll() covers the lookup. Keep ht_lock
> for writers and acquire it before looking up the entry to delete.
> 
> Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
> Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
> ---
> 
> Changes in v2:
> - Replace the RX spinlock with RCU traversal and deferred freeing.
> - Narrow the description to the parent CQE lookup race.
> 
> v1: https://lore.kernel.org/all/20261030002241.8508-1-prathameshdeshpande7@gmail.com/
> Review: https://lore.kernel.org/all/ade46454-e575-43e4-85aa-eeb5ad79408a@nvidia.com/
> 

nit: Convention is IPoIB, not IPOIB. Maybe can be modified while applying.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
