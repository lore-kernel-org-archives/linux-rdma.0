Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795605382;
	b=WMWILYVk9bRc0Uqy+aOSYDoYVKvFD2pWqkdKf4jEZWoNE1L9WgsM3BxiwO09yXQq+d8H
	 zAXBKrNVUDrPzDN8i+s+boCIV4oqUwGkjJ1xND37KNiuDWnpq9gogeOKNkdjZbnMNOmCh
	 X7UkAjYJDKXccKTg6+PEC/c9pEl3J/590kxV2eKq82dIV0ZmrEe/e0ucft3elI0r68o1/
	 ncSVm+6kQjwGzHmavALWL8WzfSFs/2i6dcALJb92zo5bi4rrDzJrDajdM/fqEoa7z0oMh
	 esl6xhAycCxwYLUxOibOABA7I3y1VN5rl5dRe3p1yrK8w4lSgNOcnQVdrPWcJ2cV2xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605382;
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
	bh=BhCoM+KfPIYBrDpSdGotepsagxhVpySY4heCDSw5tj8=;
	b=nbMIjtRC/D3/Ln0Q95UjoyzStOlm9Qy90ETM78s5JuAJ71cJeVHxGK1jiwicQq9pyDN1
	 9j0LGrwxSAUwlN9sn+6AWKQ3RL/cqyd8tLqKemXKHDia/5N6Eu8m1ibNGoWnTF1xZO683
	 7/gWwESKjNs3LDmf58JM7lRN7p7u3Uig9sSFQVX1NwFfVoISfhAOeLutBOHfoyYW2H/cp
	 DJlYvrdi01CFYC1jJIBl7JZMTWNHjnPE6YgNdE8w5dYudEWAADDH0lU3wF+cjWerAXFVF
	 o7fXXGJECsFPiPbKG1Ee7n7i63wz3QlwLfmsXJtPWmjSoX+jeu7WE73PmHHcJHFoIiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eiDXT2bW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.20
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6E9606A321;
	Wed, 25 Nov 2026 11:16:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF6E9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eiDXT2bW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDFokgviU+95oWbDGjucY6gelkh2bKJKbasPmj5Ctmv0Nz7sWwxXnpwZoRtpyRwx4mddfYbbLninvxf5OLBfF0ahlmFdPHb81k6GvGuY07UoIvyLnLFg/Y8bTDQ+842zFdRnoDoqNbeJ2yDN4loPljoghnOVi4SdhxH1PBCjffEWZqQys5xk/8LxQidQboPVt6Ygv3bMO5hTCW/N0tMrqoIopqqDXKOTi5IJIZrwtSZRRhfRLCujHdFLsch81yabZKHkQPBzwbuhPBE2EeCN52Gm4H2ulE7U9wpzxMsYRQMiekigKyDiwZTqnjGGP2opHY5tXCcANN8hV52vvP5Jog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhCoM+KfPIYBrDpSdGotepsagxhVpySY4heCDSw5tj8=;
 b=WPyzMBFZudaWcZUN2iRyIpVeWVIfGTH0lCNyTqWgY2jNwOa92zfu4nVyXyrWbMWcwR+JQgN+AJ47e9Es4hKLoZcQ8zC2yZnBG3DfHJmWS7nNnC7MQn/gmcYn8mHEMIrlURCYcd4SfWjwaPaE3QV5kkzCecN+a3k4JnX/nV9EA3utGu8UTqc5KGAEfX347xpRJPVXqZ2A1rmGXA2Rl4YlhJGFaOZtyzZKAVU3WPi0r61XmTFdoAZxUTK6GHIvIMA8VTpj7atTP862D1E1IOgo423PsiBbFOCY9mevMWQk17y3PZEhnp89TRMKs2kKI9zhEsgMME6HxoM8I1HpayFXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhCoM+KfPIYBrDpSdGotepsagxhVpySY4heCDSw5tj8=;
 b=eiDXT2bWFq8OXe83FdV7kFB2ldRAEDQurjrT1suCu5Fy9zH6B+Tgafjzlwsyo4EHh60sgrH1J+Nq/lbIJm0uyTBZdcV9UdMX9O7dwM9NLyf69uczaHXw73pOjgvAS4iXlzDNHllJ++G/IRi/NlbxY1bNEjvJOi4wMVvNH/GEMvYdx/OrFGw/cMhLRkwZ8jCGV5B6+9y8mZ57bv7+SrIeOiUuXVedYc06IttgSlfgFxrdz9ZGco1TsSf/MwecSEziO8dkwpP1qOkBUGAp0TD8tDDytBlnYd6c4DpDUzWsMauvXuOyctGg+OFszjVcwvuHzaQ6+4/d2pn0wQImz3GkAQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CH3PR12MB9097.namprd12.prod.outlook.com
 (2603:10b6:610:1a6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Wed, 25 Nov
 2026 11:16:14 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 11:16:14 +0000
Message-ID: <923fa815-b22d-4546-a73b-9bb865beff2e@nvidia.com>
Date: Wed, 25 Nov 2026 13:16:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v7 1/9] net/mlx5e: ring the tx doorbell when an accel
 offload drops a packet
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Boris Pismenny <borisp@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 David Ahern <dsahern@kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
 Eric Dumazet <edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
 Jakub Kicinski <kuba@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, stable@vger.kernel.org
References: <20261124010601.3995693-1-toddfreed@meta.com>
 <20261124010601.3995693-2-toddfreed@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261124010601.3995693-2-toddfreed@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0010.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::14) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CH3PR12MB9097:EE_
X-MS-Office365-Filtering-Correlation-Id: 9719d310-6acb-4e2f-430c-08df4ae5847d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261026121527099003|261022075727099003|261022105027099003|261026140227099003|261028144727099003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	WcYICe12L4ZoOkgHW/Eq/IBu0zYs1YTY9N1C83uGp2mNWanGZjYpLATZm1vHaNJCpJi/QFBPIVlIWYxC6fbOPgTFED7fV/8AB/cLNmAYcVBxKmkEGivNDQ1646HH/cq8aVAjnKMfoePfB6Kr1qD9QoCxA9OUM+zQ12P1f7zRQ47GKi5yvFkY1nRClj610PPWMbZG/zEljIHwUlrUu6vgzstNaoDVZPG+ucG7Q7ORkUXVIcEki4cNZk9bUq0C+OF+IkdlOAoNp+CnHG7oOBuA5mVycx37tTefsSz0FY790IDlZLFKtfo+XA8TtZ7eklhkRPWXVLydcLM9qE2yyEkLEAFnov+RCNxDB/bKMF0FvSTo1va9CVpXvR9FPk3B6pBeVVRyE7bqyCTNFnY6NQzcNm8MQ8solueJd+v+gQHQoX1t8upnAqcRT4BWinLvcmA7QvWFdWAx09bvh+kzk5waLGiEGYjurbYVvRjPWJIVQSGXqfuvfM7ZDwHRAuA5MiMAfwadjuOCzfifWpeCoOQ9mCWdESeWbWNqRG7XOp+dkMk5rAtGhbXxvzlgSp9StvIAaE5uEYXEJ6yqloTlLX+GgiR4hlN6ETSX47k42UkvixxRldvU1M6oq4Q1ikX7l3ZQyBO4CZ/FGiGf7US7yRDhcdD1g0DdsZrhhgF1NIZpK/s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261026121527099003)(261022075727099003)(261022105027099003)(261026140227099003)(261028144727099003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDRxWnlNeXZUN2o2cjlGUzhPZEZHSEQ5TDR2NVc4VFZseERNVUEwMHZMa1F5?=
 =?utf-8?B?aWZLN284bGZWeDBDR2dwSzFBRFJwTGhGem5UdGllTWRXc1dvZmxnbmIyNmVU?=
 =?utf-8?B?eXJIdmxjNFNlWHBHVmpFQkdpRWNtWHhTR3o4NlVEZUwyRTdESUs0enJVZVY1?=
 =?utf-8?B?a01iVmRQRHVzT3RPTkFoUDNmNDNTZjdKOFpycHIwSFJnbGtudjVad2plaVFx?=
 =?utf-8?B?RkpabVhJeWkzbDJ4ZnlwdHhGRlpMSTA0RmNGc1V2VkI0dkNnYnJ6RUtwUEpB?=
 =?utf-8?B?V0txM3MvcVZkUE9nd1FlOUMzNHhnK1drQmE4MW0rUW5ITkZocE1KaWY4SExn?=
 =?utf-8?B?QVFJeUhWVndKbmVOV2hUYis1NGp2a05XbUp2bWRQYzZiMUJZNm1uajhmQkZR?=
 =?utf-8?B?TUQvVG9lRkVRYUJ2R3hnQjVRVWRDem5VL1JsWm1jU3UrelRwWUJqeTVmZWlU?=
 =?utf-8?B?YkszVTlSYUVrWUo5Ny9LUVF3aDR6eS9VQnpoU1BCV2JubVlPZnQ5Q2l5YzJq?=
 =?utf-8?B?bit4TGYxYUFpM1RoQkI3Q2lodVFuZSt2c1RBU3kweGtVb01nVUI5aWpkMlhR?=
 =?utf-8?B?eXNlR2lMbDAzdkR2VzFGSzVERGE0L2xjeGZ6YzkyK20zOGpMNDNCNUNUb1dk?=
 =?utf-8?B?Q01sTlVQL3ZaZ1JWbTFqRTBJaTQxZmo1a2dQVTJ0R29EaHRBeXcxWjBUazlM?=
 =?utf-8?B?MklNZWdBWDc2U2tkaXJHS2xsaXBUOEYzV1dsbFFDZExXbHhhcVlmQWRGekZ3?=
 =?utf-8?B?eUNSdUo4NHFKUGtkTVErOWZXcVhBZmNQZngxS2VmZG5rbWYxOHZ0UFBUMlAv?=
 =?utf-8?B?c0djRU5nMFJHbzVWNElzN3FxV25UY09TSTEvSWhNQmFRRG5zaE1LMEFNZlUx?=
 =?utf-8?B?NkprS29Gb3F1WnVMbldTcXdkcmR5N0ZBUTk0b0ZKeHlMY2NBOXdLcFUzS3BU?=
 =?utf-8?B?R051TFJQMXBwcWM2cXkxWnpXa3lKSjV1MVFYV2pRQXpZbEpLek9PQ2d5ZDVM?=
 =?utf-8?B?eTdGeUN5dmp0SDVkYWNnMzlCNUV5TW9XUmFBVXg0NVJUTXV4QmxXMVo4dFJN?=
 =?utf-8?B?bFIxYis1dVV0cFFTQWtmNWcyQUp4VDlBUWJPalM1MUk3c0RMSzZsUU9HeTN4?=
 =?utf-8?B?cW96L1E5OWVIQTVGcEc5OFVKcG9yeVM1bzVrWVMzUjYzVEVZMXQ2b1ozTnhn?=
 =?utf-8?B?eDVkSDgxd1FuUkRFL1FJOHIrZnZDenc0RkdYYnA5cmRtcFdOMFRZNjNUQ2lm?=
 =?utf-8?B?UlBOWmdTY0ZOM0N2QkVDUHBkZENyRkV0dml3b1NHZFVOQW5TTHZUWGRqeVhE?=
 =?utf-8?B?aENURnB4M2F6RG5BNGIwZjVGbTMvU3pJeDk2ZFdTY2hsMlBzaWNMWEZkS05B?=
 =?utf-8?B?WERSb0xoR3hqSDZ2bDYvREhPcnNGSXZFRnJMVnpHREJXcnNpQ3gwY0NvTnA0?=
 =?utf-8?B?Wlo2OGJCRVl2WlVxTHZBTjlhUWV2NUNrUk9peUZBS2d1Qk94amIyZVJ2RFJI?=
 =?utf-8?B?b0dVcGhseXR0UnZZbmYzZXp4UUJNWnlnUnVnc1pyc0krbG5rT1g0ZjNiTVVi?=
 =?utf-8?B?Y09XMEdnVHNOaVFHd29tZUtVcFZrQ29GN0FsSHdVNlNDYXZOblQxSElCaUVG?=
 =?utf-8?B?M1pjcjRxV3lkd3hZSUtoakRFbXl0dHV6aEszTlRqcHgxbnE0V3RUM1pzTzhl?=
 =?utf-8?B?ZXpxdlRlZGxpOFUxa281SUthdktYVG1mTFBrb3MyYmpwMzE4NHNZNDBvd3Iv?=
 =?utf-8?B?TzJiMGUzMkZLZGdjREJHMTZ5Y3NJR1Yvd2hCejlTV2lMb2JZQ2hjdXFtNGE3?=
 =?utf-8?B?UXc4dTJGVkhRNFlDdDdnQ01QMXF2TXZFUnd1NlhNcUVXVlFIV0tQWmlCN0p6?=
 =?utf-8?B?UVBuOTZlYTVJOU81SVRJTHdwVGQvZkpzSFhkZlBnSjcycFVNY3ZtZW94a3o2?=
 =?utf-8?B?Y2N6djZKSFQwQ0tRY1QzZ0tqdGpXTHZDQXJSd21ORDF4OXdQN25xYlJ6d0s2?=
 =?utf-8?B?TFBCTHdONHNCWENOTkd3R25iTDNZTmV3TUg5TFQ3VkZOTldTZ0xubEI0UEZG?=
 =?utf-8?B?aVV1VTZRdmNGMVgyN1orMGtBVjVkOUp3Y2k2cytweCtPZVpXQWhEekt0M0dG?=
 =?utf-8?B?RERJL2ozaFVuVG1OMllmTjdmdGpiQkhhalhoUWxoWWRDMVI5QktUaEE5c0tV?=
 =?utf-8?B?QWEvVmYwNmdxSCsrYzJoV0RDK3dNMWF5dWlnM21qdEpuK2RkdkJMbUZmVkF3?=
 =?utf-8?B?OUdZWTRlelBDb3V3aXNiaFBmbFRKVCtGRWdod2dOQ1c2b2Z0U3VxQk9ZZ0c5?=
 =?utf-8?B?UHFDeWgrWGcxUWZNMjZBdlN1NnFIcTU3UmR1ei9kUVVmbVNqUzhPUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9719d310-6acb-4e2f-430c-08df4ae5847d
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:16:14.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SkvXwsFgAkCqTz65KIpi/vPNHBIUIh35GqfKn2f/PMI8dDfOLCHiYImvfauVA+kdS/cST7tXsep2oPbRxwQVhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9097



On 24/11/2026 3:05, Todd Freed wrote:
> When mlx5e_accel_tx_begin() drops the skb, e.g. because PSP can't
> encapsulate it, mlx5e_xmit() returns without posting anything. The skbs
> before it in a bulk dequeue may have been posted with xmit_more, which
> defers the doorbell to the next one, and an MPWQE session may be open.
> The device then doesn't see them until the next transmit on that SQ, and
> since the queue isn't stopped, the TX watchdog doesn't fire.
> 
> Flush the SQ on this drop like the DMA error paths do: close the MPWQE
> session, post a NOP and ring the doorbell.
> 
> mlx5e_tx_flush() doesn't check whether the NOP leaves less than
> stop_room in the SQ. For the DMA error paths that is rare, but a run of
> offload drops would post NOPs without stopping the queue, and could
> overrun WQEs in flight. So check it in mlx5e_tx_flush(), like the other
> producers do. The completion of the NOP wakes the queue again.
> 
> The next patch makes the PSP drop reachable from user space, with an
> IPv6 extension header set on a PSP socket.
> 
> Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks.

