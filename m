Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795010936;
	b=iUZGnLd3Ce9sSzcCA0THozjUdmTtxs8+5HhHKBOIoFkAMjhdzTmiEJwQbJRPEqbhRl7y
	 Ot1HPxFbo2d4VYFdljny0x03o9mpUhasQVhPkf35psuGRSv5oxuukwI71n+L+rxuZTZ2U
	 25eKCMzhXa6imjEUsXQqNO73p8tGVBx+BHV0qBjuvw9RBmUMocv0ddfN+oTrf947ClNQI
	 tlnfXF/yGfx1QzLeDoykp3YzcOMSS9tMDxcd8wZx6G7bYopuBY4CfvPQKdhwhXovUWM0p
	 HtXDyCyLhx40Tlm5epw8LNrHyhCTHBvq7OUVktaSKS1UDK1khynZYj804G4gC+KRiOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010936;
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
	bh=bfYJSJ2uCd6emmLRjYX4YVuPOGpe2Ld3t+UcQ6cMjpk=;
	b=3Wej0UOHX+HOvcS+cNkUTPuN9Xd/aJDdDQzZnukr3pbQoczHVcrrew4hUvPXy7fMU6OD
	 I7XPAo1f0Rf1jnPK8xbwuBDZoBBCUv7rbWJi0aI4ba+BJAAraH+j3SGCcUvbEWes0flkq
	 qgm/tSf4R9CzVXUN8lZdVuNWwTPpaFdORLa5APsjU6jbD1Vo4yVk5mE54tOUdwfGiskZG
	 G1F+z5yAF7LY9EbjBH6NNBztfbK3i9hwsyir4gpipKTvvuby8cyaAB8jTv573OWjNNJwJ
	 CgOes5u/fXQJp9sTE/WOlN/sAym/GiOdDC0UeMXPZcwLdkDKbxaquRqZZRnZJ2s1v3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=alNIdFhX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.48
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CA60A2606;
	Wed, 18 Nov 2026 14:08:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B69CA60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=alNIdFhX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ElRO14fLEXsd8q4HSoNz+zCCaPUKMEMZ82saADoxgZp2OA4z+A9fX/Jn+RtFriB/cBWQ3gp54h/bBj8uKJH70kT7CJ/4FuZ+6vl9EyLOQVMbVIuEzoW5HtnA8fC3Eso6MQ9vNzprz7AXiOdtW/pkUYwHh92iwPYDDugPJ/v9Y8Sk/OyrUCCWXrsZXd8SIgTuhUDlQOEKpekP31FSxKt4wKkV6iBK0APub4wyow/+jRln44868ZdOhQp3WxXHWK1EBfsVLBfUp27VG5OWjy/SWJtzkIoelJbY9VBdD4LrkqMjFXJtt7ffiEceny1u9EAi9B+EVtQVpdKGWtXwhCqgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfYJSJ2uCd6emmLRjYX4YVuPOGpe2Ld3t+UcQ6cMjpk=;
 b=vSDkmS2jbhwUDQJF+3sFAKfoLwnXIyAnDcPQbFOF194oO1khgFbjrLOgg99jHm2AKsC3tHp5gSF8npM08MqKyQcLCQ7CyXcg0gR9cEwt1f993zZX1aMXqfGnAnXyIGgF1n7LvWBpWyehc7ysyunp761/J0fb6Q6jlU1EUavTVHQaJPhZIc2es+w/VVLXjwqTv7FWwle6SF9Jriw5FysXz5lbfSsDiTKs2drrXqsdqUeD1QP4Ezv/Ms+DbXSFiwnt/aZ+W4sn/wpsrGDl5MP+h3c7o0ldZkBlOHU6030zmANYK/8nzda6qJB9Ix5CnPTGGmjcjW/BqUSx92hnQosIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfYJSJ2uCd6emmLRjYX4YVuPOGpe2Ld3t+UcQ6cMjpk=;
 b=alNIdFhXfq4yJxIfWS4PeS67RVkBnzhYP7bdGwohWw+IvKnbVyrjkdUVKqE+aIsdRY/GQCOwPPjErzqpCvI1NKgpCy5Dok5YPJB/zOb2xa+FOBXLAa6xND7pj8b2SHP5i8Egt/jLdiDZyFUHKt8ciDVC9S8XSZTlwLBk1PMYMqfUE22G/WRzJp+MXaLMEGvFFyy40ZFQ+1Yy6af+ZZNiuSFUkNAc1SESMz7I9IsPg8da7zX5kkGSVXFElkUjxQ3MBVh7vkjxD/U525NIbl6sQt8yzS1fagQ5cOSHwjOSlwN4tIpEKYg4Pw0wSo2yuqiDSCHYV50W50FqnPQQMC/Ngg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by DS0PR12MB7680.namprd12.prod.outlook.com
 (2603:10b6:8:11c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:08:46 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 14:08:44 +0000
Message-ID: <f37fc52a-0a6b-430a-a69e-e7dc7f7e7181@nvidia.com>
Date: Wed, 18 Nov 2026 15:08:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6 1/8] net/mlx5e: ring the tx doorbell when an accel
 offload drops a packet
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Boris Pismenny <borisp@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Leon Romanovsky
 <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, stable@vger.kernel.org
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-2-toddfreed@meta.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261117203137.804424-2-toddfreed@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::7) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|DS0PR12MB7680:EE_
X-MS-Office365-Filtering-Correlation-Id: b87dd026-0f75-44cb-a05e-08df457d74bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|18002099003|22082099003|3023799007|261022105027099003|261022075727099003|261026121527099003|261028144727099003|261026140227099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	kkf09nHnp05VeFFhN5v8xIGEWCkRdd+l3zVN30avCKc8t4EKt+zHFKRuw5q+fXTlqkqhoyo/j4XVBqMgpjGEdgKpnQgXFyzANmnyefQVQUuI8gfhRGX/sEWBjTXbd6+gGwu1wynvfIiTYBV5dvCh91ytPqWpHh/QQS8SGkAfL3KUgmSw0zEvztlhaUhcuoRWlCk8IWV8jawUQGeEBwfeEBxNCb67DlScCsA7f/1YweEeN3EkIGqOR01SH1v0tMd4pg9mJ3EuFYDhx++7jG0dDsv3gIqt1mxuBUPXkCzSXqXWLkeruZEJ51lMPoIkErrXR4DQYkCs2uGTRwWHeTRA5+N7QA2Ja7I3HDCPNWXIdYKrZvOn0lW/1YNTaaPtTxIuRGM6446QfdpJAXDqBtfByMrHtClsDhmsJAvtsZ7Fgn3eXZ2sjFVtudUacCh0ez03tQDY5ssbTj3rl7wevX5Ocsl2NJZjAZWJV0tEb9KT1PlSqk9xqw7riIHb5H0USdZmDVUe9zerQQLTTFN8XWZ5Addstk8unZY9Nhng8RgI8Ra3FnsGfUTPHhXHqGlUWtO2Ef7f4CbkyXtXV3CDuNfFOC+YjbQal/iRrmXMuhOVjIvhqj1yt0b+P2RvQsvlD3lqxdY+3QLBWdTp7vckqfBjvzUfkjR0l60fkEQglfkbYcM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(18002099003)(22082099003)(3023799007)(261022105027099003)(261022075727099003)(261026121527099003)(261028144727099003)(261026140227099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1NWVWJBVmZmWHZRZnlxcnU5MnZJU2NvTGZEMHpFMDJUTkZ5UW1KVDF4Y0Nx?=
 =?utf-8?B?RUF5dyttMGl4Wm9pTFk0MHNvMFMrcVFseFFxZEE0Rko4NGtyK0NMYmxjZW9h?=
 =?utf-8?B?UFlwR0xVTlJobWxRRzhXcHhOd00rM242RXEzM3VLaFQ1OXkzbEtqYmkvSmRW?=
 =?utf-8?B?TjZ2SnMyRm5ST3lFNjVMZnhPTkxPMFRjWVhWc3NOQStrL01NUkU0dnptMW5R?=
 =?utf-8?B?TnlicFhOSFZkbHpjUnl4SkV3VG81UjQzK1RiTUtvcktIemVYRVZQOXBzS0Rx?=
 =?utf-8?B?MURSRVh6akdLaFNyb0RTcG9mVU1Gb1kzVSs2Y0I3UllPZmpMM2RNNWJPdFc0?=
 =?utf-8?B?OG9hVXF0cm5jRnZ3RHZic0lCS1NJcXdzNVZIOWZjMWNLWFJ2K1lGMlpPZXhV?=
 =?utf-8?B?WUdyVXZrZ1N4TUFYalNUL0ZndEIrWGRaalI1N3Mrcm9jN3ptQWFmK2VlbldU?=
 =?utf-8?B?eU42Y0s0elR2UDFDQ0RTMDVaTWRZRWxXRElVTnl2MXRtMStOZUJEUlZNOHdU?=
 =?utf-8?B?NFJvaytTTjQ2QW83WHJOS3kvcnVTVFRrUkNRKzdKSEZjOVJ1Z1VZQ09BeEdV?=
 =?utf-8?B?QUo5MWpiQkFYeHZ0dTl5dnlwUjBtTlBISDUrQTRoSnRHUUFMQ0pKNFo0WHc4?=
 =?utf-8?B?ZnJOM2lqSkpQMzRWNnhpUWVnMjJWMno4S21UMG9TYktZUlk1UHhlaldvRUZz?=
 =?utf-8?B?VXljUDNhZVFLSURDNDVZYTV2Rnh0NWc1VU1Xc2lPZGJsZy81L3AxQjJCRmFs?=
 =?utf-8?B?RWtxSVg0dnVzRWJYQ0RCNGtEdDRTZE5LZ2t2OTVHcGRlNnZRYzEvZzByQkJw?=
 =?utf-8?B?RWpOZTZ4WHl2NnBTaEtlK1ArTDE5ZGhjRHFhSXRrNnVkdWI4QzNpSTBCbWxG?=
 =?utf-8?B?amhEaWFNZWRxeW1zOTZUM1RXRy9RUDNEOGRMUkZHYm1Eb1ptZVhDS0xPOXRQ?=
 =?utf-8?B?OVN5a1JVaXEzWVR5TW05SVI3WEk1a1hvSDZXVkZlTy8wZWVuUzFCL3pTVmFw?=
 =?utf-8?B?L1NnYUpKOU9ScEhOeUJKbUVONzdWeEJhTUR3M2ErTTR2emx6R2FlZWRyVVZE?=
 =?utf-8?B?L01naEVSdUZnOWNVY3Nyczl0MFp5MURSV2JxUzIvRjlzMldWRUpFdFZyeHM5?=
 =?utf-8?B?cHRXVzZKcVN0YzluVFE3SWppaGFMdmJ4My80eitoaks3amp0c1k3NndYcmsw?=
 =?utf-8?B?Y0FqR1FWN0VvLzFJVlVaR3A2b25wREE4VC9pS2ZHNExGbFR2VDdyMm1wM1Vq?=
 =?utf-8?B?STVQNVpwWVQ4U093bURKWmtDUDE0N1dHcFl4dmxhWVhYWDllVC9oTVBJQVBS?=
 =?utf-8?B?a3A0N1dPNjdoWWovU1pMR1h2enBqS2VTa2MxTE0zVnVlL1Nra0tQNWJnZ2ox?=
 =?utf-8?B?SXpNRkNjQWRiWXNYUFRIZ01xUDRUK2lSQ3M2VllvM2ZndndzK1IyM1hseGZm?=
 =?utf-8?B?Y2pFWjRrL2JLeHZ4M0dETVJiZ1dCVHFsVHNHME8vMFRueXptaUI3WkltMkV2?=
 =?utf-8?B?eXJjZFArUEg1OGxKbnp3SUZxcGlySUV1MExuazc4MDE4c2pJZTE1V1hXcEpQ?=
 =?utf-8?B?L3pSV0tWUjFzc1hsVzJWNVFRRHNMeEdxdG5MemRmQXFaaDZFdjg4eFR6Vlp0?=
 =?utf-8?B?Z2VZYk9DV01wMFFzQm13WmFrbUZ5a201OFpSZkptMjdoV2V3dHdVL0dielVt?=
 =?utf-8?B?cGFZeW9MWmJXelBoZy9BRyt5NUhCb0R3N00yUVdUenZSZFl5OGFpVC9Ibmts?=
 =?utf-8?B?empiUXU0WEZxNE1wTUhMZ1lRaW0rcnd3eWJsQU8wOGxHQU1xR2laNUIrWU5N?=
 =?utf-8?B?eXZCaUtQcFdQcHRMT0MrKzVTSGUweG1lL0hqZnFGRUQ2Q1FwRG1NaWQyQzFo?=
 =?utf-8?B?TlNyam8zZGtlVjE2b0RqZG9RT0kzM0FuOXhiZUVnMjdxQ0Q3eDNTNllPTXVi?=
 =?utf-8?B?bGNqd2tQa1MzNVFxQ1FjdTNqN1h1M1JMMld3VmpRUzUzcENxVTFaekoyaDVP?=
 =?utf-8?B?NzBXVVFETkxMSFpvVFZKQmp5S2JBTTgxSUFpV085dEFDcFo0L28yTkpZency?=
 =?utf-8?B?VFJnVXdZYi9CNXVVZUtNM0Y0ZGRDTTdSRHZZc0FPdkQ1Z2o0MU5oM1ZKOUY5?=
 =?utf-8?B?MHAxZzgwbVFCL29Kc1lHdTdaMi85Qm1qQWhTYjF4VWQ0S2g1a3BzMEF6Y1lm?=
 =?utf-8?B?NFVuQUhySXN4Y1o3RFV0cFJwVDYxRkQydjRWZVd6REYrTFBKaWVNZTRyZ1ow?=
 =?utf-8?B?SjBrc05vMU80NTB5eEtoOVQxdHBnemUyeVJTcG9lUVdTZjRkSHBEcm9rZTdj?=
 =?utf-8?B?UFlxWHQva3pLTjV1M1ZDdmpWbXpocDZDRzRlSFBIL2pNNkorNXhiQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87dd026-0f75-44cb-a05e-08df457d74bd
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:08:44.4032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwNEIJyCA/rnuAfqN0uW9jcNGadOZrPs0+UPJ7razsziDRnawD/L3kOwLzxtcwGhtuoQOLwIilRVbHVPKNAC3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7680

On 17.11.26 21:31, Todd Freed wrote:
> when mlx5e_accel_tx_begin() drops the skb, e.g. because psp can't
> encapsulate it, mlx5e_xmit() returns without posting anything. the skbs
> before it in a bulk dequeue may have been posted with xmit_more, which
> defers the doorbell to the next one, and an mpwqe session may be open.
> the device then doesn't see them until the next transmit on that sq, and
> since the queue isn't stopped, the tx watchdog doesn't fire.
> 
> flush the sq on this drop like the dma error paths do: close the mpwqe
> session, post a nop and ring the doorbell.
> 
> mlx5e_tx_flush() doesn't check whether the nop leaves less than
> stop_room in the sq. for the dma error paths that is rare, but a run of
> offload drops would post nops without stopping the queue, and could
> overrun wqes in flight. so check it in mlx5e_tx_flush(), like the other
> producers do. the completion of the nop wakes the queue again.
> 
> the next patch makes the psp drop reachable from user space, with an
> ipv6 extension header set on a psp socket.
> 
> Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

LGTM. Couldn't find any side effects besides the additonal NOP + db
dance which is ok.

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos

