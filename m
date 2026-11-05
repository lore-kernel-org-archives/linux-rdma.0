Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793909457;
	b=CKhc+WaSEj4AlN0lA0cTCrFpcD2xipVuCczJLPmVNnsZuDm8DeLTRB7yLgNyA2vfTZeO
	 nM1HBWyFEhvg1rK4S8VqcgkTEIBY27x51qse/xzsLC/Uu5YSwvaTfF/sb4vrdOkKFQ6oB
	 oncqpcNXhgQnetI/WdfJNghQHEFfUEJxqNdyca7w5FOMNxeUfrSMXEuIDseFOiTz3cSsk
	 Rc59XK3uIxMxuCGLvhBuE67XGL9HKXHQpLeoYa9fibTnRQBuyz3Sh1OncyvbkH0nw3GI+
	 OvbYaSW690Lrqox8cGxb0uNdxKkznb1+Tp4GfsBq8XbujlLrEB9LplN34zZowMpb64A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909457;
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
	bh=zYCJebudwU3CezUkO/m4vHkV2IHoom7yU7aBaKf5/QQ=;
	b=ogeIUpMWlUAtPqWEGjqaVUAU4wtS8KMjDCZRvUgM34j8JKazTKFr3rtqnGW0vNN8ZI1V
	 7+kvq0J+XHQGMviD8IsXBqwp/c7xi1uzlNaZ1hx+28ZaIghilzIJ1Nzd6PiTBb2SWC5QD
	 EDDjsl4wUyZyKeJKmyLsTG8+14a2DDLwu0MVnhtX5tkMGkgnXEMeVRT0D2UOo9p8LnW6u
	 buimVgcxCyK/MAsvON8bbXpTposwITUPrAeGC2ZL+hr63Mp2YMeeiW6K49JwlHtIHAvvi
	 iY8+w08izVZEp3L5iElA9LHA6PvTtsy6+Kpk01t2AmDxV3eNMyI+pd4kym5CODeXnRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=totrs3Aq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.63
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB4B606D828;
	Thu,  5 Nov 2026 20:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CB4B606D828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=totrs3Aq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0B9zREuH2bGLgEziH0h3+MTkTkLkn+ILAeo+yDaDxK58xCUnSLX9eLjM3PlZkoGEUfpFv009IhOEcYEhCfSkXEvSqQwf8gUlvCJK1865Vkzp75bU4oldpsILwQ+zCS2xdlTLcUblFVCXgYdSKIKnZoJ0tIBFDPGX4Y6rvJh68N4beNcSuz8IvCK7DSlV2AVnQ2kGvm2r6QWCONYyE9HcfkJlab3JEHW2yyL4iHWR8dA9iEThMAK8J3mU3swyB6Bs1SghMRn6cArmC6XQ71tVP55y8m5YLH18JKXdPJtne7WdDA1D1zOuUf2bNPOWLGoqbi970ZFrtl8Os7kyjaPVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYCJebudwU3CezUkO/m4vHkV2IHoom7yU7aBaKf5/QQ=;
 b=CJate6LmQvBfXWHFisTZDPEklQOlOaPyc9DeYgZdLScHHfJZxHBXwXA6rD4NnLbbWUv5NEoAxWgVWMzoRM0KabiNJIZdMfNis3bn4ZanaTrKiLaDaG7gbClsdX94ZAgnwXjDmmyQguvU3gGxxsJlkW4TzamAmhk9UqMNVigm0rDPDWgYiZ73QhUAmsC1fHq3qCyaciR7K137m9Eq9cqv/QEbkmHc/mmvawY5Se1O3XQr0M55KBhUWctfeVhmQORITGoPYMOtnVrs3ar+qdvVZP605SUAl4VFKrXVJn3z1DOrNK9W0T3Al5X6ZmUvwUX7dBXSfjQjpIKoU8sM8VX2ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYCJebudwU3CezUkO/m4vHkV2IHoom7yU7aBaKf5/QQ=;
 b=totrs3AqUtcgz/6qBE0FH/V6pUB3/BSR1GHNPPMD6rmeIKYlSqwAsdceCKec3JXXs0qoxI6sc/26I/np6GE+ZpM6rueYv+sijdkNsfi8OCwR0oJMdmnLkpEKm50pn41DHdyvGaZ7Pe7MRqg1uHWrM/yztPo4ChVQxqVwW84COfa+J8yNM3kzHJ5xZcXkEf/xw0HvdQ+Tr2KsaJxrsw5/ICkHWYhtos6EgJ2SjGXEN/LYpRw9JkQh9zNwud5msNAzWRxPBglkSTYxS7W9sRBe+CeqAZsgIpqQdks0cIVSGG6fsPs74gdyOGUkoHUBUu3h+l/fmyI7h1KOk/STHrIH1g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA3PR12MB9131.namprd12.prod.outlook.com
 (2603:10b6:806:395::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 20:10:52 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 20:10:52 +0000
Message-ID: <c5242a74-b5cd-4066-967a-1154a3c85ae0@nvidia.com>
Date: Thu, 5 Nov 2026 22:10:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
To: Paolo Abeni <pabeni@redhat.com>, Thomas Fourier <fourier.thomas@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
 Roi Dayan <roid@nvidia.com>,
 "open list:MELLANOX ETHERNET DRIVER (mlx5e)" <netdev@vger.kernel.org>,
 "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20261028145805.54595-3-fourier.thomas@gmail.com>
 <deb337e3-f7aa-447b-8227-fca872b8cbd7@redhat.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <deb337e3-f7aa-447b-8227-fca872b8cbd7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::7)
 To IA4PR12MB932075.namprd12.prod.outlook.com (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA3PR12MB9131:EE_
X-MS-Office365-Filtering-Correlation-Id: 736cf905-c1f8-479e-2ab3-08df3b78e478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|3023799007|11063799006|4143699003|261026121527099003|261026140227099003|10067099003|261028144727099003|261102123227099003|261021121427099003|261022105027099003|56012099006|261009223027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	r8jcYbM8es2DcJ58bnqvTZx3ujx7kluU3Hcb7sDYhqx7odb7tK3slaBqiQsKj8lm5HWFDINRjt8hrv/zMKIDUYWnUCp9SYMVCa2DtzqdmLG530sVjpzRBYqV3BxYLMRsacPQMOIunKQ6aF3Z2rhI0oxAtyRXxXEwf7tMcrxli7tO5XUW07h2YQ59f73OB3xbfn/9vgPqgnTM0TTjh673FsgzXGxl/K4rKi4R2XNo5h9oTzOiVm3SBsC0i1J9sroovYnE+QQUeeVupIIO0uHK9Ed+ywK+EMiCRL6GxeMsTyLVzCvCrpCQsZYo0AvhAKwWZH3ItRld4gwRBikzSH/QZ5DDeFiIeT2kM3CflIEOGFnVa+ioM/B85WQSoSiYey0bsNA6EiN5Wu6Uhwv9IUVdt8pUN4fFKnBOALkGc8bhhy0Wf/diPJXJm4a95tdx/9J6Y8RWojlnSYTlwuJQyIL/+gancRfxClyCvJhFLpdMbgwAlR+qloXXw1tsMTZK5LtPffSRxDi3G8TT6tdoHvhRAiGHwr6G06NDJ88w0lFK78YYUNmgC08d0xDjWcSR2IjzAoLbjMoG9StqTM1gxhSdt1ziFr2kdGpXepqOJYiMhan9ijzWWXPpu2edEN1MHyc/hnDibMUpzg++2k95NNj9K8qfL82Z5A6zMGNjbS41WW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(3023799007)(11063799006)(4143699003)(261026121527099003)(261026140227099003)(10067099003)(261028144727099003)(261102123227099003)(261021121427099003)(261022105027099003)(56012099006)(261009223027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVlOclc2ZjNwbHJ6Wm9OOEl5dWw1WHNPakpYTjgwS2xlTWt3OU9zTFREMnZM?=
 =?utf-8?B?bmN1NDJmVTFKaWE0bWZDMkVxelhjSmRoS05EY29YTkltQU5helQ3NGwxWTlj?=
 =?utf-8?B?MzdXQmZ2eGdWclBBdEhTL3dHVDR1K3dEWnY5Q3g2aWIxYUpRZHhIVlliZ2Yw?=
 =?utf-8?B?S0d0UHpOK3A2ZTI3Smw2M0lQa0c2bHppYUJJWnRSU3V6Vm1UVXdpOVVxSHZ1?=
 =?utf-8?B?Y0owdENMVi9DZHVpTEdCcW1lU2c5OGVuOVFCWE4zR0VFTFZsNnNiQTlJcEhV?=
 =?utf-8?B?clFGSzhRaHdsS0d5aTNpdisrLzN3NTEyVDdhY2pkS2xKczRKUUU0b1ExSDVV?=
 =?utf-8?B?RkVVZm0xU04wdFNQWDRPVFFYbG9vdHVkakMxdXplVnFuVWRQeTRlWTdyQjdz?=
 =?utf-8?B?YnFxOG95am5ST1Y5S3RKQ2lpYzN4cVBKOXdlZUphamxEN1Vua3JFSzg1V2VC?=
 =?utf-8?B?SXFteXhoTDBvd2ExZHh5WVhYSnluVStzQXY2dTFnL2pzQjlXNzRNRzJBYjJt?=
 =?utf-8?B?UDFHeDd5cklDa1B0VTN3YWN1Z1hGUWw5V3Y5SzV5YklVckdvL3NTcjlXMENn?=
 =?utf-8?B?dHNDWjhISVdVWko4OFl2aHB6cytxZkdTMVpVcElpN291YlR5SWRyZDg3WWRP?=
 =?utf-8?B?b2tVZS83dEtQSkxJaUNHZ0IzK3h6eTdnT1lra2FHR2ZSYzkwQWtzZnFTL2hh?=
 =?utf-8?B?ODQ2cEl3V2NyUng1V0lvMWZrZ0loTU5VZVRTTFd4M0szWnlGZ252VFZSZnhy?=
 =?utf-8?B?Z1UyYXU5L09IK0k2ZWZrb0FaQjhDMkg1MndKOURqbS9Qbktqd3ZoZndjTkRX?=
 =?utf-8?B?RlN4QWczNXlndXdtYUVUL2t5K1drb2tjdUJuVTdLd0RaVmFpU2xyMmJCZlYy?=
 =?utf-8?B?RjRvZlJuM1JBSWRPUGF4eUhVV3lyRjdNRFYweEU3UXVFVERDVnFZQnEzQzZV?=
 =?utf-8?B?UTZYOTZ0Und1SEdZSzIvbFdRaWVZQldtTjh1UWZtWWRxbk1ydUsxZ1VtVVFG?=
 =?utf-8?B?YjNDVnJwWFROSWdteDR0QWlVV3dYbCszUnZzUmpyQWZoN3FmanFjOTBMcjlQ?=
 =?utf-8?B?UGJOamVoMG5TN01KUDRTYUdiMkhtbU1wK1RyU0lqOFAyWFZya2lKK2Z3VHo1?=
 =?utf-8?B?K1BlMjJ1NDJHVkZUUlNCeSs4WEdlcW9nQ0xYc0laZHhXSlF3WC9yMXJmN3o5?=
 =?utf-8?B?cE05U0ZBaHI4bldkb1dMNFVYZHpnQTNtS3hQN0thVmNtc2ZRNU80SnpTTHN3?=
 =?utf-8?B?Z3RONkxmT2MzamlQMnhHaW91Ync3aUNRRG1SbVRXZmZvTXo0ZHp0UHk0OSt6?=
 =?utf-8?B?Sm1YYUhXckt4dk9oc3B1YXpJZnk0UHBlNjJnNTI2TFlDWnhYVlQ1NDUvdlc2?=
 =?utf-8?B?SjJ4aWJmbi9nOVpsVGtZQjllNGpSRWcvSG40VFVrNVdqSFRNUWs0aWMzQm03?=
 =?utf-8?B?Q1BkcnMvdm9IZ0lEVk1qK3ZaSHVXNzlGM000ekVpbmVlQWZRNTd0dCs4NEtm?=
 =?utf-8?B?Zzd4SCt5cmYvdEdMZVkraTRFNVZPUmVxZUpyTExNMklSSmVHay9NNmdzeGh0?=
 =?utf-8?B?U2h4Y3FyaXVZak9NUXR3TDJHYjlraWVLM0wwSEFEc0N2bWR3NlRFK2NTVzFV?=
 =?utf-8?B?RlU1a3ltOEN1bWVod2hoTUM1azluNThyeFZyZ2JVZURNVjlCR1cwTUJaS211?=
 =?utf-8?B?WlNvb0pvOTg0L1o3NE93RFp6cTI4elV3Tm1KZVBsa0Y3T1NGQlNGdm9VV2I5?=
 =?utf-8?B?Zms3ZzgvYzZOYVlmNm9zY2ZwaTQ4TnEyYU9OeXB6Y2R3SEEwdG4zL3p5Mkhq?=
 =?utf-8?B?N3kwK3FFMDBpZitjZFNHRkY2L0h4VzR5MVk5aE9pUE9UL29rU2Y3MlJBcmdH?=
 =?utf-8?B?bis1RnExcStPdFpPZnJRWHM4VXdqUVQ0NlkrVnVNZ1JwQjJldHlVdFhVWDhF?=
 =?utf-8?B?NjZ4SkVydU1oREg3VmUweGFWaGh0T3YwRE5WU0JOUkxvLzFJb0pjN1ExVFZH?=
 =?utf-8?B?U3pYSzJoNGdZY1YzTng4Z21NWGZiaXBKdGRibzBVcXVBd2dLV3RPbzlEOGxY?=
 =?utf-8?B?ZWJraVI5bTFNRlJKTmZ0QjhURzhOMWtQcVJaMUlLUVZ0SURMNGZOUmZ1NGJZ?=
 =?utf-8?B?OWJhUkdlcHhwaEpaS1dxZU9WcktUN3gveEtDSDE1MjNjQkd5Wk9BNzVzWW1s?=
 =?utf-8?B?NXk5MG43b1RqZkxOc2duN3kwTzJlc3ZVcDF6R01sOVdYaWxYUytDeDg5NVFM?=
 =?utf-8?B?SVpROHJVUTZWMlgydi8xODBMT3VYV1FqTzNBcmNMR25XTkVZUnlZVUFqUTQy?=
 =?utf-8?B?dEhqUTg3eWVJMjhyT0cvR2pJbEN3aEtWODhpKzVxNHdmdUtqM0sxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 736cf905-c1f8-479e-2ab3-08df3b78e478
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 20:10:52.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdYLhDwSEszXwAncQhXYK5kMfMPUX/iYA4BUSCxJKmt0EizPq2N6K4TfkGvyx4LexEdG8Y8bWrUigaPjw+PfiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9131



On 05/11/2026 11:18, Paolo Abeni wrote:
> On 10/28/26 15:57, Thomas Fourier wrote:
>> When allocating the false branch fails in parse_branch_ctrl(), the
>> already allocated true branch is freed but attr->branch_true is left
>> pointing to it. The caller parse_tc_actions() fails the flow, and
>> free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
>> free_branch_attr() on attr->branch_true.
>>
>> Clear the pointer after freeing it.
>>
>> This bug is theoretical and was compile tested only.
>>

I reproduced it on ConnectX-6 Dx in switchdev mode, with KASAN:

     tc filter add dev $UPLINK ingress protocol ip flower skip_sw \
             dst_ip 192.0.2.2 action police rate 1mbit burst 20k \
             conform-exceed jump 1 / jump 1 action pass action drop

Every attempt reports a double-free in mlx5_free_flow_attr_actions().
With this patch, 50 attempts reported none.

>> Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
>> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> Given the lack of H/W testing I would appreciate an explicit ack
> from the mlx crew.
> 
> Thanks,
> 
> Paolo

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Tested-by: Tariq Toukan <tariqt@nvidia.com>

The same command also leaks the parse_attr of the false branch, as 
alloc_branch_attr() frees only the attr on its error path. I'll send a 
separate fix for that.

Thanks,
Tariq

