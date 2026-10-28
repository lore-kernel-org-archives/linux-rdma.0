Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793210276;
	b=R8cHC8SSGQ5tY8b+V/3yq51L4u4JKgywaKIbqgrn1MvMBbNX0mWHG2DZ0WROKJJQU9C+
	 JyCa4aJ3EhMkRLRvVpR7MXDUs+deafJjcwxoMXl6dFDejdD055RX6ESIgRvPAupHjHgbq
	 vFc0sKZXAievgOWjnoa7DPV1gR+LBeZxNma0Pe2Wn4jiLRAMF+R5q7/ZNs5Uf+IGqLdDY
	 oEvrqbw91O/LdrwmviDazKwxxvgKvUGCdcFuEJ/HnwpXozVV42995jpXmEaYVwJmYyGYM
	 7x0no6e43esxbMPmEz5SRb2ohMd2YE76kc2vtjzIIYXs/7rnAipIDjhyqEk9J+l5tbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210276;
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
	bh=cB10LEdgYpnTILpWWZUJSHK+8H/mXRmAeQWh8axznCk=;
	b=zvgqcIENoFOfneUP6pUQr6eSwbPuwxjkh75xk5MIHzuAteBYJt82E6O9pcLNIXVcbcJl
	 h7oLDGVDHA5XAlZmPlOzg9ZzQfeW4PtWddhB+O3pHdcWPIluuKEQxaO3+wO4inD9MuGgz
	 RnQ40t3Sb//4ZinNynaL5Y+Ml+aJ+ZVWpPRyKl+Acsp/xmaPYiCRQZZ3R6bAlgBH8R35Q
	 ygua5Wmn12cE/1BSYSQzG4Qar5RergtzHpm+ZwgInmtReYjrbDBQz4jJwjlH06y44j5tn
	 /iV+nmWguKQAjNZ77jQ7NMGMOSPfENONfjZcubyx+nnHZc/ZBFSkrlw+IRDDanrEc9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LOk7NOyi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.8
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012008.outbound.protection.outlook.com [52.101.53.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80463606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 17:57:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80463606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LOk7NOyi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FfjfWjduCImm1h/FuM5nazfTzVqi513EPfxttoCYhvbemKbiFioWQwdZyi4ETXxyO6cryp4XNxi/KxJEZ5INFN++raX2SQRRrUBi2ThPQhkjUGikKjHY8pXIqIqkBBjU+23THMIcLxM4ZrQFGYyHm36H3fVALfS2dQnbuE2aWRsHvVQ8zetIoKJ+E1hndARXpJbRdJX80Y1bLkGMFKh+dhaogzsIH/oVTw4fsjEwzXbrKQIUyPlYmayKUteXIXAtTVw3BHI+YDX2QyInhJd6V4E+hDiWuhJqnD3M8swt7Lu3sw1+nJhbnvyySezZ/uoR185tLHMhUbw8NmFFFbO9AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cB10LEdgYpnTILpWWZUJSHK+8H/mXRmAeQWh8axznCk=;
 b=DwMrDOrBH/v4ZXHkQkdbx9na/W5OxLfbIam69EgE5TAkp6bHk+ZzL6DST8y+RX2rukJ10xLGVawxwAgJzvUh33ZvcowHFgCXjPd7BAcdmvs/6I3lJ4jkCMl15eHGe6CacDq9FBUSLrVb4PXKKRE9fnXcAvErWCYcpwCsSqX+DDrgbteAYQ4+CKANzXsjn0YLrqpTb3kpXeUmXsUBVYUVMj/9OHPtdX+v4pqUjbhtJt0465kci8AF7e+4ZsW0XTElMmqpPFRJ3v7Thd1Uep0NarARyxXHrtKPBZCxps6ZX0vva5OOr89J56UWvZIodLky1WqtgHPfYHLP9nGc48Cd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cB10LEdgYpnTILpWWZUJSHK+8H/mXRmAeQWh8axznCk=;
 b=LOk7NOyiYMojaMI7aORWlFACPpgABe+zDEQq8G+Yjilb7YnvQJwnHWPNRyf2zVBBzUpQKFfM1SO27P42Za+FRW30ZIbbNn8/xj0NtJHXAT2Q3k9dVkkbZbbd5EXB926v3YtQabVbeilD2/4HMypM4G7jI7+lNQ9G19urUjYivA6r9NlUDL+m5a5g0CweMa0odsnH6lRndmvzLaPbDiSzMrTUOoHBIWGAj6vFn0MIIFxIrmUtdOk+ys7PTNH2xAhvW67BWbkkDgoLmHYKIW9P4StgFOV3WjSpALu9pJ9+sgXnTn7DfA1HlPTXkYAGFaivsN+FJwIhqsibHpuX2ey/AA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by BY5PR12MB4034.namprd12.prod.outlook.com
 (2603:10b6:a03:205::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 17:57:50 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 17:57:50 +0000
Message-ID: <ff298fca-07c7-45e4-83d8-47d32d87ab5b@nvidia.com>
Date: Wed, 28 Oct 2026 19:57:46 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 1/4] {RDMA,net}/mlx5: cache and use TX-enabled
 aggregate speed for vports
To: linux-rdma@vger.kernel.org
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <20261022193053.3815866-2-tariqt@nvidia.com>
 <sashiko-outbox-183120@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <sashiko-outbox-183120@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::19) To SA3PR12MB239779.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|BY5PR12MB4034:EE_
X-MS-Office365-Filtering-Correlation-Id: 53dfa5a9-66e5-4e9c-1486-08df351cfb86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|18002099003|22082099003|11063799006|56012099006|4143699003|261021121427099003|261026140227099003|261026121527099003|10067099003|261009223027099003|261022105027099003|261022075727099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	oNZWuqHRFzTM68I4tUMEqshdBDRNpwP1H3dzj3nCSrJJMZzw3Xa1wnKol2qGxJHllxZXqm44sYIpBRFwjPJU9aaAFd/6CeZr8vVcXE/Vh1mlDcvcueTIM0PKRtL8zuvvU2PLqmZSzbATbj/TtHCfce/pJT9lQB6EDz3i5Pag8v3gkbtoGN0cW5kGZreUAdsTZlsdPmdgL6JU/SF77B8Hd9TgJj71MuvX5pN6S6Y3gLPo3IHUnevJSZeaIuyRKwPP7/DV7LPwq84vszTDOwICaynGvqQEcQeT0GEklnoGHdwe+TydUAzr5o+2wo1DWSTpjbRzen/JX4dohj0eWSb1UqweRlgS0yWW15rTw26eidpOKdc1J7rnkBMeQym2f7ArgXkKGrb6+GAjdtWBlTJh5EoBQZz9KolTvHJxvb7kDUHFE1ItH1v7Urf23PRH4IUHp5fLlMuEH5Z70j8IAUv29eEpYwShf6hrwrCOimgSVbL3iwE+WCSBfFZpg8slH6h161WnqLtvgnEJjQMGr1+rgogNWVrkA/62PzQKsT3qdGgINB9qhx2tu+UduNDnzOuOZPbepqtGjOEcVrT8RWJf4jL3UNLnEL/mrJvj0kdYHtiBucviTim7X5EBzCzCNH2ZJjgUyWmS0b6rg5aUDEg3RKkQtiosCsU0CrtWygk+GRM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261026140227099003)(261026121527099003)(10067099003)(261009223027099003)(261022105027099003)(261022075727099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3lXMXJ1QlhZVDFsTnYwdXIyOGxhZ08yL283NWcwWS9iR3h3RXhBMGhGZ2Js?=
 =?utf-8?B?d3UzSWFWODVoZFowdUNKc3hsRUcvMC9UN2FwcHlzdk1sWEQzSVNlM2wzcmt6?=
 =?utf-8?B?U00ydERCeW9FeTVtMEtBWnVMc0lubFcxRlYrNk9tajJMM0tTR2NLQTRKcUV4?=
 =?utf-8?B?eW5wUXdyQ1JTRC9ManRVbHBtbEo0UUdFLzVwQ1dWOFBZZXF5d3JoSU1lZGhs?=
 =?utf-8?B?dEhjWHV5bWtUajFqYzVzanhjblFjVjdVdUp4T3NMRnpwTEhTVFJGdGZjNG9O?=
 =?utf-8?B?RXhRSUZSTWpUMnNWUndZSHd3dTM4c0tENlF5NzhxLzc5dHI4VDlkclVFcW9M?=
 =?utf-8?B?d2Rtc2hTM3k5RXNEaENDenk3TXlveGdJOUxWMUFURjJyY2YyQTA5dlJ2VzlJ?=
 =?utf-8?B?bE9zRlFUbkJCZlR1blExRU9DZndtTXIzOENRVlZzekxHdi9yby82ZnhyWVdY?=
 =?utf-8?B?dFNiNEF2VjBLdkJ2YWNidFFaUkgweWVWMWNKOGZyUWRvRzlXOHkzZE5vSUtT?=
 =?utf-8?B?Vm9SMEwxM1pOL0dpak1mNVBJNWs0bXJhaHhqRTJvcVAyZlllYVl3cWdYb01x?=
 =?utf-8?B?Y0JTK0FOa1hLbXJBZlBVWVlFUnR4TWx0SHdPSEN5MDNTSUtUeTZFSU8xUzJX?=
 =?utf-8?B?MEd0dkdwazdzNVhWK01BZGdGWDlQSVV2S3o4bjRyYVdFR2MrZkhyaEl1bnY0?=
 =?utf-8?B?U2VJUUxIMXRZM1ZnSGlGaEk5U24xR1JLcnRnNGhLRjRkZi9nNDREcWpoNlo4?=
 =?utf-8?B?OTkvMlpNazhmWXR3ZnU1TG05RWVlUzM2emt0WVBsZEp3cU54Z09VSGR2SjZt?=
 =?utf-8?B?aVpvVnpsZWZocklnZnlJTHlnRkhQSVYwRTJtcVFDMUZST0dpQVIyWUxadkJE?=
 =?utf-8?B?bkhSei9KTFExN3FxZkpJVGFBSmE3T0I2TkdTZ0xZZHNPdHlmMHZ0RHFaNGxl?=
 =?utf-8?B?QjA3NkRSUXNSNUdlRnBCdVJFQWFvWHd5OGRyNVF1UE9sTnIwQXMyN2ZwcXJ1?=
 =?utf-8?B?d1hiZTIrUmpLNlowRHYyc0RJdEt6RlNPRzczYlVkWHZMZlcwWmF3QkRpRWpY?=
 =?utf-8?B?aDFpZFZMOHE1UFc3K0NXYjhEZ0Q2UUc1bTFQdmRLQWJkUFZFankwZGJFcmFM?=
 =?utf-8?B?WU4yMjVITUJ0bUxVdENFOEFlOUViZnJiVi9tTnN2bENCZit1bmdMcUdSOUhu?=
 =?utf-8?B?WHV4UUVON0x3blZBKzByZ1VPdFNVdGdUMzk1a2o1WnMxYjZLeDgvQksyWmho?=
 =?utf-8?B?Qk1jWkJCQVJSMXhEUlplK2Z0eVZhMzZmVG9RUGsyd211elRBWk1pc1JRZndp?=
 =?utf-8?B?blRRMC9LT3huZXdXRms1K1NHVUFnNUx0TkRRbEtsa1lOVFpQVVdoKzhCNVBr?=
 =?utf-8?B?L1lDbzdnSnhMeU8yQi9sNU9RaDFyQ1J0TkhZNG5yKzhpUTZlWTVyTUdsL24x?=
 =?utf-8?B?ZGxDT2k0S1oxZXB6dnRCNllXL2NaeHNFaXBjRDlqVW1PM08zZjBJTmdkTGtx?=
 =?utf-8?B?ZmRWVE9udldpVHhlVkFBS2YvYjl1QklXd0xydElMSlUzd3VqUEptMnJOY2c5?=
 =?utf-8?B?YytnL3hvdDAvbUdKN3J0bFpIaEZXOTcwa3NpMmpucll1K2w0Y3VlMjVaNWtG?=
 =?utf-8?B?bnZKcS9UVkNjSGFaaDV3ZzRQcXY2VnROOVVJb1JSSEhDNk4zeitDVHVYeVl2?=
 =?utf-8?B?TFlpajRwT0UwaGF5VlFrakV6R0NBeW1pNmMzeE4wTmtsSytTemFseGZyUGtv?=
 =?utf-8?B?NTFIS2VsTEl1ZG5kNFhCU29NeXNNTzZtbm9wZ3BQQXBiQmdIV1hYZHN4WTd6?=
 =?utf-8?B?SHYya25zMFVvNFZFcnVLQVA3QWp0QllIbWxEaHVKODhHTWxFaEJvWVhBVDVq?=
 =?utf-8?B?ZjJrY3hOWE5MVXk4QzB2QmJxbVRwZEE3RjZ2SjVJeDhBNGwzMEgrTUZrR096?=
 =?utf-8?B?MmY0VXdxcG5CZFo5TEswQXluOWpJUW0ya0RuaFYza1Y4VkQ3bTRYU0p1Slgr?=
 =?utf-8?B?SUlMMXpDakRkSi9BTG14QmpIc1ZyazgyTDhUa2lGcHprTDFwV1NUOTZ4L084?=
 =?utf-8?B?YUVKV0diem44ZUxVa2RJdjgrTFZ6bVVNcmRYRGU1VURzYTZIUTJ4UENRM1U4?=
 =?utf-8?B?K3ZSUVJPUzJmVnJQc2Q0bWxIYzR6dU10V0JqaFV0MC81Ui9LMG5hUDFCTWZm?=
 =?utf-8?B?N0tCWDJPWi83R2pVblRNVDB1QzBCYTJyYXU0U2MveWg3aHJwbUtWTTg2OXQ1?=
 =?utf-8?B?UFJiS2ZPQ1UvTEVnNGl2UlNScUNmb1F4QWZkN2hCMnd0VldHYndNZUhtMm9E?=
 =?utf-8?B?a2dXYVFNZ3U5dmgxdDJPblFSQ2FINFRPNkJhQ2JCa1FTNlkxSU1TQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53dfa5a9-66e5-4e9c-1486-08df351cfb86
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 17:57:50.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6jpbBLRK9g6OaUhTv8VSfJtMwFzPIbi5SGhmtCG10OmiffXvSjYZnH4B3OKQ/D5Qb8nP9qiIP/okwOwlaGIuYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034



On 23/10/2026 22:32, sashiko-bot@kernel.org wrote:
> 
> 
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] net/mlx5: lag: missing agg_speed_mbps reset on MPESW and mode-change teardown
> --
> 
> commit ce16ef57f040ab430add649db26c3f383cbab840
> Author: Or Har-Toov <ohartoov@nvidia.com>
> 
> {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
> 
> This commit caches the calculated operational TX-enabled aggregate speed in
> struct mlx5_lag and exposes mlx5_lag_query_aggregated_speed() to query it
> instead of the bond speed. It also resets the cached speed to SPEED_UNKNOWN
> via mlx5_lag_reset_agg_speed() when resetting vports speed.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index 4e173b08cb37a..57755ceab8a75 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> 
> [ ... ]
> 
>> @@ -1594,6 +1625,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>>        int pf_idx;
>>        int ret;
>>
>> +     mlx5_lag_reset_agg_speed(ldev);
>>        mlx5_ldev_for_each(pf_idx, 0, ldev) {
>>                pf = mlx5_lag_pf(ldev, pf_idx);
>>                if (!pf)
> 
> [Severity: Medium]
> Does calling mlx5_lag_reset_agg_speed() only from
> mlx5_lag_reset_vports_speed() miss resetting ldev->agg_speed_mbps (and vport
> speeds) when LAG is torn down via MPESW disable or mode changes?
> 
> Currently, mlx5_lag_reset_vports_speed() is only called from mlx5_do_bond()
> when mlx5_lag_should_disable_lag() returns true:
> 
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_do_bond() {
>          ...
>          } else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
>                  mlx5_lag_reset_vports_speed(ldev);
>                  mlx5_disable_lag(ldev);
>          }
> }
> 
> where mlx5_lag_should_disable_lag() checks:
> 
>          return !do_bond && __mlx5_lag_is_active(ldev) &&
>                 ldev->mode != MLX5_LAG_MODE_MPESW;
> 
> When MPESW LAG is enabled via mlx5_lag_enable_mpesw() ->
> mlx5_lag_shared_fdb_create(), mlx5_lag_set_vports_agg_speed() populates
> ldev->agg_speed_mbps (and mlx5_mpesw_speed_update_work() updates it).
> However, when MPESW is torn down via mlx5_lag_disable_mpesw():
> 
> drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c:mlx5_lag_disable_mpesw() {
>          if (ldev->mode != MLX5_LAG_MODE_MPESW)
>                  return;
> 
>          mlx5_mpesw_metadata_cleanup(ldev);
>          mlx5_lag_shared_fdb_destroy(ldev, MLX5_LAG_FILTER_ALL);
>          if (mlx5_lag_has_sd_group(ldev))
>                  mlx5_mpesw_restore_sd_fdb(ldev);
> }
> 
> neither mlx5_lag_reset_vports_speed() nor mlx5_lag_reset_agg_speed() is
> called, and mlx5_lag_should_disable_lag() explicitly excludes
> MLX5_LAG_MODE_MPESW.
> 
> Similarly, during eswitch mode or SR-IOV changes, mlx5_lag_disable_change()
> disables an active LAG directly without calling
> mlx5_lag_reset_vports_speed() or mlx5_lag_reset_agg_speed():
> 
> drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_disable_change() {
>          ...
>          ldev->mode_changes_in_progress++;
>          if (__mlx5_lag_is_active(ldev)) {
>                  if (ldev->mode == MLX5_LAG_MODE_MPESW)
>                          mlx5_lag_disable_mpesw(ldev);
>                  else
>                          mlx5_disable_lag(ldev);
>          }
> }
> 
> Because mlx5_disable_lag() -> mlx5_deactivate_lag() clears ldev->mode to
> MLX5_LAG_MODE_NONE, when mlx5_lag_enable_change() later runs mlx5_do_bond(),
> __mlx5_lag_is_active(ldev) is already false. If do_bond is false (for
> example, if mlx5_lag_check_prereq(ldev) is now false after a mode change or
> if the bond was removed during the transition), mlx5_lag_should_disable_lag()
> evaluates to false and the reset never runs.
> 
> Wouldn't this leave a stale speed in ldev->agg_speed_mbps (and stale vport
> rate limits) after teardown, causing mlx5_lag_query_aggregated_speed() to
> return the old speed instead of -ENODATA, and in the subsequent patch
> ("{RDMA,net}/mlx5: notify IB uplink on LAG aggregate speed change") causing
> mlx5_lag_update_agg_speed() to compare against the stale old_speed and
> suppress IB_EVENT_DEVICE_SPEED_CHANGE if LAG is re-activated at the same
> aggregate speed?
> 
> [ ... ]
> 

A fix for the MPESW was sent in 
https://lore.kernel.org/all/16368a7c-af34-4dfd-9e8c-891d455d2935@nvidia.com/
I will send a V3 for this series and add also the MPESW fix
>>
>>
>>
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261022193053.3815866-1-tariqt@nvidia.com?part=1

