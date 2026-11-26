Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664429;
	b=vEzpua5wL9ZgVm/PlkjQVnWHbrQyatkW+qvinoBS5rHDUK6PoZaNemNUHzd68ZNKYQIv
	 uKzKUtJc7RCK5YsyG/JN9iBXwcY4YRHQH24/U89qf7W664cRlPib4xL18pxe2d1cqJUl+
	 SbPfiU+EpPEY7ddlMHJI48WVaN5NIMOte0xkTDWFG5/jUSF8va2ecVCgKB7IUfDBN7Gn7
	 kM2L2DGrmaFkCTHcOKzF7acFXV0Wa3uopRI1TL8Zw2sdLNMjVHo0yvPhcJ3gBf3y7siBw
	 cC3QjfHlmlk0UI0n2IU2MmiK998dPM7WbK4F7UF0Uh24b9OMQ2Gi7YgVTrUquJ9GzkA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664429;
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
	bh=ThzE/SBZntp7t+2ieGjMI0JLIPfmqyOOJrha6hPbgns=;
	b=U5yddogmizlMzkMRpAI2KK8yAv/Ng1QWuD5Ebhw39B4YEOdPA0NdTepzwOt3io+qD7r9
	 9YWL7sQ4RY4ypYwL8xK8kC/CbZhlQGpKSXPegL5YFbbr/ZmEYO6Bydwn5FMmxz7YLUk96
	 rgpQJT2pgHxS5lYs3VS/VbCRkcWnVOGg+nzcKGKxP6p6sYRDSToww0oivhhxJ4UJ13IYd
	 rt8aSgNBG3p7SIMpAnlI9oO/XZ33PIGKfRWZsdT5tQIZC7a+dCW7nK3Eux6c02LE4iaZn
	 c2EueuTjiuaeS0fgMtIaFcgyg+ILqCqUMMDi9LvKXM7Gv8QvSJTx8bMPOKMF+9q6zOQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MJSvN328;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.34
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012034.outbound.protection.outlook.com [52.101.53.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68A8606A321;
	Thu, 26 Nov 2026 03:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D68A8606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MJSvN328
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6AfiLc5OrNiyjb8nJYjO+geUT0gFa8Q+6SZOUyoBtmpT6u7MwLGeudeohIh/h2yZ0HohlLnnLKu+xNV/JqpOsyv3iCr4j1LcN+fBbgL1BtJg3ikWPrqjYKRruzHgRT3nC1VVrsf76VyhoLMwvPBqWzP7d05d0pht6vqzLpEbdppnfxUm9MeTxZxMzgzOQY/DV1gPVExzlXqZ+lu7DUPKo2m3Ff+dDb9/dr30DZaYFExFEhem4fy4QBWvkSmB45p6UWyAVLVDpSEqAuU1bxTJO/+qJyUPKXHIPJ3Po7HNf9FfISAwk3sjnJ/dNF2JAXYIWN+4KKIYNWjIo7+AR+Uqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ThzE/SBZntp7t+2ieGjMI0JLIPfmqyOOJrha6hPbgns=;
 b=KRCdZeYzYzVzjPaSrE9QtyTaWbEUuUB8CbinnqT/Kohz46pZxG4l4Rc4xt6R1EOcTNVbWawYi6G+AThZ8lbS4BsfR9Xv6J77ohc/CyKl9AeELvhO6ESe25h1vIvruLtaL9VipkozUKieOC7KZKjFXVjStMhYJObJ6shsMrI1bh37kXb8572XVMnuR7rMp9Y71mSfltGulvYVJ16hcOWDLeiKK8yHKphxv4MMZH9ZvFZZktl2sO1V1EswlMTq36mFN8dMWw4YYJAiQMq8eayWF89kgJCJVQ5+pd5ulPd35pqI2oSxVc8aN5yFEs8B8ZO8RtLmf0vaJr8MYIg52JSZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThzE/SBZntp7t+2ieGjMI0JLIPfmqyOOJrha6hPbgns=;
 b=MJSvN3283Ls1VvAsXbkRx+FcMbHwye4c6wrAAn0wZf1c+ZQjkyQ9jqYlVAu3sFx+XlHbdNJhbWErquK3pIFq14ctdLTNdYFu9KsLzDWzkrQPawr/EJVq6Pzi8kUdcFLNhUlsGXRCnjVaSdx1M4FwG4NhX3Ie3FWU+c3WqpQ5KrXv1bCYtZ0KRr6iCvPtFhuvbrRRXb+1eMdNtArAeaut30YzFpekjhNKEmN5yzpw7L9THRM4E54aO9lY/awwVuVRCHJwSkW94w4szN4bOTIxS2ClQucUjSfVhTqQxxmYzAOk/W0hlva+M8I3fCruwdJGpD4usEMVF5OHfOVoo90ZYw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:40:24 +0000
Received: from DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d]) by DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:40:23 +0000
Message-ID: <9916db2a-3062-4136-97a8-c791213b7ab5@nvidia.com>
Date: Thu, 26 Nov 2026 05:39:58 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 1/5] net/mlx4: factor VLAN parsing into
 mlx4_en_prep_vlan()
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261125180021.1804204-1-joe@dama.to>
 <20261125180021.1804204-2-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261125180021.1804204-2-joe@dama.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0013.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::6)
 To SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: DM6PR12MB4354:EE_|SA1PR12MB7126:EE_
X-MS-Office365-Filtering-Correlation-Id: a7064e63-b791-418d-7a51-08df4b6ef636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|11063799006|56012099006|4143699003|261021121427099003|261021123027099003|261009223027099003|261102123227099003|261022075727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WeLv3sN4/YY46WE8Q/5+y9iFq43ABfK6d8Zohpz4N5ak6o81G+eYIHRfUk5L4WJsoKCNCwdVK7118Kg5rcvajhhICkH9gQ/75F/7qa2ec0cqTJmacmHZIyRYiJruTmmSt5gv/kYckh4PH8VIJKK9P730YE8P+GU1fg36uuRwzpvNsCSSdtaus3egrizJJig8YsdbURbZufFu6FTst6LP7nJkA5u3BcqgHBNY9VUMrb2bLt5tJR1Q/6Kj3q6/GDLGSd0JdFsv7X2DpiIlhkMPIp+YE5hbY3RK07ZYRR+wh1OsRG7Hex2qhVbrxUIWBrGbMmk1jDKIm12Wx+TK4ZlBcDjr4dbDeMVnZKLRbMFoiC8uiOsdBqg/EWsDIQmsTi2RQhtvNjKnSgEWi3jqNd/0COB5xPTeHlOLSabsnx3mOFe5KOniP12XMRyZzovpOd64clen6EV911aNeBL95qkg5uQIAZfY3erWhVhBOlKqQ9wzdtpc0/7T6vLmjHiubiZwmBYkP4HNfstrM+3BW3cqArAfJWfaRu3ykWU7TjxT9D7W6HEnHes40ObGu6THGfDlacUHvSTmyOO0JNfZVlYT2O3ZJATtnXb/UMLfY/N2QlgsxFX55ndaO1Ry+hELkQ6kbMsGaeFAmx5lyG60dADrmhkgqZqv4NWJpwy+GqwKFeg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4354.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3hqNGlubHYvcUdwUkJETUFScmRsMEM3eGlhOHJocE5ldllLQzFmNW5oQXpk?=
 =?utf-8?B?N2kzU1MyK1ZzOVJpMEdjOXU5NzMzUEhIanFRQTU1THRBWFdqUFo2QWZTQWxw?=
 =?utf-8?B?L0txaTlXZjZKUlZzdFVvaG9NcTU5anduUzlBQkQ1T3lMRHVUUzBmM2FYOGFF?=
 =?utf-8?B?ZkVlOUZDa3AvSjdvZnY1U1ZZWWdzWlJWdk4yaEdUYk1ucStCS1FSMnc5UkN1?=
 =?utf-8?B?aU9BVTg4ZU9Cb3U4YmI2K0NrdGt3Qi9oM0ZFVmhDMXJ0dEdvWGk1RUJKZjdp?=
 =?utf-8?B?WWhtbHRpL05xRlN6cVNVWGNGeEh0RmNOTmRzYlRjTHN5RmNDTkFrZFM0MFRv?=
 =?utf-8?B?YjJwd1FQUE9SMkNJQkphSlB1TlBDOEE2VGxvc3JOK1MyVDgrckZRbVdYVkx1?=
 =?utf-8?B?MG1pU1FvYVhxNWpNK3dSRkE5Y2tkTDhOOHc1Zlllc3pXd1drSDVNbjBsaVpk?=
 =?utf-8?B?SVJiR0M3S3RJMy8vb2lsMGlBSGFodmNiZ0dRMFVIdGU1K1phd291YVN2VDl1?=
 =?utf-8?B?Tk1DVzBjSlZFb1lEaTdyUDNWNWZsRmpmandXbnVGSzhHeDJaZGhRVHhFR1dq?=
 =?utf-8?B?ZVlKb3RWUXhLbjNXc21xNFBMQXlvRXpteWlLSnN6Z1hia0d5OEdMaHFwY2pl?=
 =?utf-8?B?amFmZUh1bTkwWEdYTnR6ZWxQb0ZXcmlYcGdWVElOM2tjTGZBcHBCdDZ6WmxV?=
 =?utf-8?B?VTAxZVo0RnJYcjFxeTNESFp2T3lncnU0Z3ROM0RlS0crMm5HempQM3NaQi9w?=
 =?utf-8?B?ZkpLYXRLTHkxSURUWlY0WTNEOU1FMUNqcXhxWitraWhhNGprcmxWUUVmVFlL?=
 =?utf-8?B?RTRpL1Axam1KUG5UaFYrVUE3TSsvbE14Q2oyRzZTemxtOGt5aHMrYVVkdm4x?=
 =?utf-8?B?cE1lR2xndTVUS09ac0FHbnMwNG0rZ3FHTmNoVWZUNk1iZXNjQkJQekpQVDhT?=
 =?utf-8?B?WkVhQXpwS0NBMGw3bHJRQ2dEdkRtekZNdzBlV2F6TEpONHpHYndpVFJIK0NB?=
 =?utf-8?B?dnRqYUFOMkhsNWV1WUF4Q1FaME5SekJTNWU2cEJZK1JDSU1zTnUyaXZaRHFW?=
 =?utf-8?B?UmMvQlZVdWNsb241QU1zdlk2eFg2a2d2dzF0V0dVRGFsV1N0TXBCQ05qNmZE?=
 =?utf-8?B?Y2hxb1hRVllwMnNoSGtLZE54ZWJkT0JvZ0tQc2xLdStRdG8rY3B3bS80MU4w?=
 =?utf-8?B?bmJUNVdBT0l1a1FNTkEvcURLdysvWWNWNEFOQ3piUEkzWUVJWE11V3lONzdD?=
 =?utf-8?B?QVlWMWxtRWFERDJvdDZRVWwrS0hnVWhCS3NweUhKekdTV0RkenhKTG5kbUdD?=
 =?utf-8?B?cUcyVnZUMW16ZS94ei8xQmlER1BtM1BaRkpFZ1M0blRFS2xKaU02V1d3blFi?=
 =?utf-8?B?ejBjMkJFYVRPYTNYSXd1bmJQRmV1eHdZQnN0dHlWVml5MlR1R0h3MHE5N0NY?=
 =?utf-8?B?YUQ1aUFXd1BBMlFhWlpXN01YSUxOWWU3VVY5NVJFMUxMUVE5cTQ0cGhJTWxF?=
 =?utf-8?B?TkJjc2o3Vk9XdWpxNk9vdDJrdEZRZzdqWnh4dmxiQThwTjRhZHo3NkFmME0r?=
 =?utf-8?B?aXg1R0lxbWx3MTJZOFl3cFlsaUttcDl0bG4wNlBBb1RPdmluTHVDK2QyL0JT?=
 =?utf-8?B?YTNzaHJtUTBjNVdsMEVldE5OUkM0Y3czQVhsdy9CTDRST2lIdVNqcE1GUWw2?=
 =?utf-8?B?cVFWcG5tMjRVWXlpVEpxbUZwMmdRbXdBdnFTZVFGbDRobFhHM0EweU1iRzhp?=
 =?utf-8?B?Ri9sOWFraU9TNG12OHRLM3d0VityNlFuTmNMSk9qY1ZCUW1xSHlLWWJQY2lY?=
 =?utf-8?B?cjVVdHlqbldBMG41OU1UanZpZy9zN1EwTnc2aDN6TEFBTzRxTWJTcjZYQ3Rt?=
 =?utf-8?B?bWpkWEFxczV1Rmd6WFhDaUFkSW9QQmxIMUFzTnJrb05nWjVkcW5wSFl2M1pk?=
 =?utf-8?B?ek9DT0UyRFFOY1l1S0RNUHZ4MHYvYWFVQURHRzZvcER2WGc4dHBrcEtrTkRV?=
 =?utf-8?B?Y1BhVmpreEpHRXFWK0VrK000dFFvaUkxRVI4dlh5RXlmdmIvdXE3UHFQdEx2?=
 =?utf-8?B?YjdWZG95eEV3TVhWRzQ2TCtPczVKNjIwMFRhYTdPYmN3L21IMTVKYmlaUHRQ?=
 =?utf-8?B?b2pERGJqb2VhbkNiYXdWTGZIMDZvNHJBUXVRaVhZT1NYTlBMY1gwUnVzaWJu?=
 =?utf-8?B?U21GQlBMY2U2OFoxTGRwNkxZRUlnYUVKNW1JeGFybXpqaEVaY21yNmdkREdI?=
 =?utf-8?B?aUY2SWlnY1JRd1VmU1FHYmZqbG5lVUdrK243dGtWVXZxNFFhUEhHN1VzZVVH?=
 =?utf-8?B?WVBxcWV0RjI1cW1ZamtIdHJCVzZITEhvNXNKU3diUlFycmtsWkJqUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7064e63-b791-418d-7a51-08df4b6ef636
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:40:23.0337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndRs5NpDURvKkcEGX44rdNVtJN1rnZMAmZA6SROkipfQl8HdyhrR0t/DZ/WfrAcqKxFrEU2ijPXnJQ7lY7T3KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126



On 25/11/2026 20:00, Joe Damato wrote:
> Extract the code which converts an skb VLAN tag into WQE fields into a
> small helper. This helper will be used by a follow-up series implementing
> software USO, to avoid code duplication.
> 
> Signed-off-by: Joe Damato <joe@dama.to>
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
> ---

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

>  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 33 ++++++++++++++--------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 9865ccd8d6e9..29eda78b9977 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -860,6 +860,26 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
>  	return false;
>  }
>  
> +static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
> +			      union mlx4_wqe_qpn_vlan *qpn_vlan)
> +{
> +	u16 vlan_proto;
> +
> +	if (!skb_vlan_tag_present(skb))
> +		return false;
> +
> +	qpn_vlan->vlan_tag = cpu_to_be16(skb_vlan_tag_get(skb));
> +	vlan_proto = be16_to_cpu(skb->vlan_proto);
> +	if (vlan_proto == ETH_P_8021AD)
> +		qpn_vlan->ins_vlan = MLX4_WQE_CTRL_INS_SVLAN;
> +	else if (vlan_proto == ETH_P_8021Q)
> +		qpn_vlan->ins_vlan = MLX4_WQE_CTRL_INS_CVLAN;
> +	else
> +		qpn_vlan->ins_vlan = 0;
> +
> +	return true;
> +}
> +
>  netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct skb_shared_info *shinfo = skb_shinfo(skb);
> @@ -901,19 +921,8 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  	nr_txbb = desc_size >> LOG_TXBB_SIZE;
>  
>  	bf_ok = ring->bf_enabled;
> -	if (skb_vlan_tag_present(skb)) {
> -		u16 vlan_proto;
> -
> -		qpn_vlan.vlan_tag = cpu_to_be16(skb_vlan_tag_get(skb));
> -		vlan_proto = be16_to_cpu(skb->vlan_proto);
> -		if (vlan_proto == ETH_P_8021AD)
> -			qpn_vlan.ins_vlan = MLX4_WQE_CTRL_INS_SVLAN;
> -		else if (vlan_proto == ETH_P_8021Q)
> -			qpn_vlan.ins_vlan = MLX4_WQE_CTRL_INS_CVLAN;
> -		else
> -			qpn_vlan.ins_vlan = 0;
> +	if (mlx4_en_prep_vlan(skb, &qpn_vlan))
>  		bf_ok = false;
> -	}
>  
>  	netdev_txq_bql_enqueue_prefetchw(ring->tx_queue);
>  

