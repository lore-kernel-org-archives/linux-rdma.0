Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012048.outbound.protection.outlook.com [40.93.195.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5C39185E;
	Mon, 20 Jul 2026 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527536; cv=fail; b=Mnr0ny5V9YImLCWIeWqv2CRK37yFk8CDaZXhayEc5QYCbbsZlFK7Id2UPk4IwCtzQ8j2eZ29KcXRzS9/8ThFt9cG4Q8+AI8d9GFiE3XGT1P7PKz76Z2ENcLB+4I/TJDKDbQHqbUZAKjDWkHLgEUdNWKCLX1R5Mfd1dQLhbd6MoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527536; c=relaxed/simple;
	bh=+DZEC4mna4alxZr0m+V8MOKQggJDijjgGPF2Z1SEuXg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y6TG+Uoq00VWhLLZqu4XiLeAOTGAvVmyLp99NqziG995DAy2dZSfCmY/8UkVu2m8i92MBjXtWyB19/5DA7wRx0KXBCkaayVXBIMNG81JocOs7pZsmehpkcXZ5t+UEHy108RIrK5FN797U2cCXYNGmG2LFI0JfOgUUO73DwvUBEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eKanYhhw; arc=fail smtp.client-ip=40.93.195.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eKanYhhw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lmF4J54DXINCOpjTsCXKvRTE7xoFaQFMDlFiF1rrnODz6RNgQEmd587AnUtoKQXZywj3EptXcwHdnJnBjQE+OOfgPlG7chUFxjzcUdLnMjV/Qu0sRmKYLXnI0ISl3PZpN7fidccIQkUNZTywPvYpNnl5H/gU7a7NHG4yq3N2EoRBox6FHpj4C3VWaE4yvYEWNivhNJWYLyCHeCwrRrg0vOirY0BgBPssAhkg6pe3/r5w4X0yiF/g1YNDfhKRT5oAITSob63YS2HFR2U4IHGvKZDwnW3ZUe+yWvunLNPjREhmSFVH0kEBqi2EBsFZSdNWfUnpo2ZlQLLVOMYkAsjmZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iU/r5inKaf9CeOiTRYZ8LEWdSXMxhKGeUzgws2oKu8w=;
 b=GQp7xiC8wg7FLVMMeuzaeNTJ2rmLLL0+J2r3Cm+HD+EW6zfz50zG0Q6AdvvBZ24Z6FtB0qvePlqo747YYYVNQSJ+CZeKnRGAZ++kfDbSyOf9Ul12SJ/Jduib6PZfSTFynWlL76wisgfQJvh5iW8Ket5cn53znjmIJK0TzFgAX491RcjWS1yHgQ1MZXotg+eihYS8R199uzrSoPIA4cynZE0X0vM5BZ6GALCfXiadHl0QJFTO4aoFjO/PQrnh31sQ04EVbZcAD6gh2Db5czdPS51ZU1Q5oi5a+Y8Jn0/McDn/oBXsr63COUwemk7fp8YI+GZSVBBGHq40XbQKzgqG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iU/r5inKaf9CeOiTRYZ8LEWdSXMxhKGeUzgws2oKu8w=;
 b=eKanYhhwtiF8hK3zy1kb5AORnpJoFtUQa53xeOYsaGkVhCJZ31Nq9M2rxDHfrjPeE9y8EZzV+hyJ8ypUCfQD5YBwtk6MT8bjipuS4+xg6z5sh2vHCWE9URcpaQyI+h+9f5J54cEQz52zLR+M4qlbtoz6L3z+cKXY+st2uJ3KQB3X9xlaUZF8aY1GmjpLHDjR8s7ROy5orsDeJ5r1i1hC4/KVliYqCRHyjzWgwpu2fgP8GfKvh3S4kqebu0H3PRlXPGqSa0Pzxi19CLP1gfRvyA2TMLOsQg300dZUz8vKVm25JrheNKBZ4qGtQ6/JHg5IBRfugvbU96eufSpm2Qng5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Mon, 20 Jul
 2026 06:05:22 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 06:05:21 +0000
Message-ID: <d7d7949e-746b-4e54-aa97-04e63544a98d@nvidia.com>
Date: Mon, 20 Jul 2026 09:05:17 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/15] net/mlx5e: PSP cleanups and improvements
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Boris Pismenny <borisp@nvidia.com>, Chris Mi <cmi@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <jacob.e.keller@intel.com>, Jianbo Liu <jianbol@nvidia.com>,
 Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Raed Salem <raeds@nvidia.com>,
 Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20260707130858.969928-1-tariqt@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260707130858.969928-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0423.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::13) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d3465a2-da2a-4c3d-f2e0-08dee624e1ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|6133799003|10067099003|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZszCl9h/KbhMe7enJFt7c0UbtSzqnuCRg0RHhXYVIUyNqAIoQYqwzU+gyz6dKreho9sqBNETE/egWNy53a0rExsIIAIFbRgicrKqmNWStB0tGIe5WVYhuyEUw1xhY805at3rA+8ZAUWYiFDfegZT9rdXK2y39WgEdbksrUxFsA30JsOpmDfn15wbRgxyG2i8Z591CmmJGxfiXdTGaLUOU7cE3n6di8nB2/rQlj7qWhbNdKkJmN7qdHviGlf4LcJqHEXxY2zpq/mNNC4CfdabBMNI86LvsSgNvT0VDy9bV/hdWaU/cDzXGcg009X8/VuUUFFkrxux2Ko8+2nEQtW4ddDFcjAzNEhYFfivEUE9TJbQRA+ioPuK61QR2SOTu6Sbjvj0XAW2b21uYpYOoQtDCodSqjYgSraifuRfZjKcCvp+Zvy3oV8+VABfVS2jyGnmhJ/n+FOX+nn/qR31f/3VjTydxjt5Ep4gEkSWupenyXtRbJ5+5kcmVJ8+Pgp0Bzw8NO1xPzVzw5/B7VETgh4IXrl6W8Z2vfEVj6lU8X6qA9n2UxdylI7l6iFEqcYClBI9Sxr82agt2zYS2cBTPcBtpyUyzlZoqHbEIFXZKoFlb/MV2EWWof5XOh4qip47/lvPhYZ7yvL0djKMpl3q1LvauB+KBLTJBGuFv7xmhl7sWQU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(6133799003)(10067099003)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qy9Fd1pNajZpZk5xNHZ5RitMeTJjWDZmeTVNSSttM0Vqb0xoNjlzU3NGNU9m?=
 =?utf-8?B?TmZNbnNpdDZLdnNkVEFsd0s3bng1Y0tCczNCeExGM1hZWUI4cnRUY2Vnd1Ux?=
 =?utf-8?B?c0ZyYzBpbWl3WEVlYmw5MXh3bWRSdnFNT0M1ZlNKZHNwMmljaUIvMVU3eXh2?=
 =?utf-8?B?R1FkV3JheTVQR3UxdWtsMW1qSUhrNkZpdEZ5aHZCdHdIZmF6VGp2d29DK1Uw?=
 =?utf-8?B?UHUvNDNLcENvNURodGdzWVR1cG1EQlp3RlJUOXVEckFFS0NZc0JlOFZCNnh4?=
 =?utf-8?B?RnpMMktJZ3hJeDh2em1jWW1rZG5Bd3BxcnRmWDczaHRobGEvU3JtaUJNVm1E?=
 =?utf-8?B?ZmpmOGRSQUUrY0ZwbVM3M0d4Nng5VW5ZUVNTY1hNQzV2aVY4ZVYybmFMWWds?=
 =?utf-8?B?VFJZRkQvQ3BMa3NPb1Z5dzkrOGF3cEFmNEpzSklCY3ZxeTlKVEs1dE95d1k4?=
 =?utf-8?B?MjY1SkxudjZtSEdpZVRpMzFzNnF6WVl6S0N0cnJpZ0p1a3ZxZFNzZHR0SUYx?=
 =?utf-8?B?eUFjOUlsUWE1UEorZHYyVDZ0UjVvb0JlUUQyZHpLd05IazJVTXpPbU9RaHpa?=
 =?utf-8?B?NjJrc3FpTkc2c2lIb3J2OFI2YkIveVM0YW16YStjejhycTV2TDluY3FjVTda?=
 =?utf-8?B?NWErQ213WGw0Q09SdHl2L2ZRREI3dWJhQ0Rld0t3ZVVoZW1HdVVyRFA0ZjB3?=
 =?utf-8?B?TjQyQ0dVYXVQSVJpMVlLMGV0MHBuSThHSTZrN2RqeVU5VEJYU0JRVS9scVN2?=
 =?utf-8?B?MGVqNXk2QmNYMzFQenA1NE0xWE5rQmFiem1wYTVJS2cyc1dhY0tGSjNmUW5B?=
 =?utf-8?B?RXVOVjIyazV6ZjY0WG80clFDWE5sV04rd0xEZXlabGZEZVdicU9KQ1ZEOUFK?=
 =?utf-8?B?UkVhV09tZis4cEhVNytuckpwR3R2QjZQb2VmTDVlakdBSUg3Q3RnU1pVRTEv?=
 =?utf-8?B?b0JvS0dhOEdNeEluUWIyWjNLUHZzV240L2wrQ2NUbU16RGE3VTdwRUh3T0p2?=
 =?utf-8?B?WUg3SW1vbHl1TE9DZzNmcS9NVXdCUzZ0VnRkOW14dng3OEczWTZxUkRWcUNl?=
 =?utf-8?B?MFhpYXNQbGdZZEN4NjJZSE81d2xWSWNGYWR6Wmw4YTdNTnA0VFE4SWhTaFRQ?=
 =?utf-8?B?OXl0NE5nNHVMZ0RSbkJVcjIwMUtLdGVPZ0ZtNW0rdTVmY0x5MVM5WVN5UE1w?=
 =?utf-8?B?QktDay9Qc1JnTDV0ZTgvV2VuQ3BKaE9ZQTBVbk81MGFHeGJtSmlxcTRJelNE?=
 =?utf-8?B?ZXQ3NFo2VS9tQkVPRy9FSjZkZEl0aGFiRjFDM1A3cktvMWRXSGE2M25VODRJ?=
 =?utf-8?B?bjBDWmdEcHBvdEZicXZNY1ptVFJRUXA4THExSVVrR0Z0TzR5L2F5NTlCeFZX?=
 =?utf-8?B?RCtaUlU5Q1VuSldJblRVNElnamNRbUw3azA1SEVoMEJPMTNscmJNcmN4cVQ5?=
 =?utf-8?B?TjVzYnhBNGxpMjgrSnFkcmpuQUFsSWZLSFg1aWwzNFBxTDlzcU9lNGZQRXR4?=
 =?utf-8?B?ZzNsVjI5OVJRZ1V6RGF3bFpQY3Q4WHdkK2FvRVZUb2pHR3pCTEdQMHFtWjFM?=
 =?utf-8?B?eGRLUEUzeXRZYjVhNUZIbTBLSzI5eVdkaWFHdC91dHF4dlRtR0NpRGExNjMr?=
 =?utf-8?B?eVFUWmY4dVZyL3ppWkpYTElMYnc4UzltM3g0TGE2MUxqeWV5UnhqelUxcWJD?=
 =?utf-8?B?ODlOM3liYk4zWDFzb09EYU9wem5UZzZDdXlEMzZHbmhyS2h0dThWL1hndXBK?=
 =?utf-8?B?Mmh3R1V2c3J2RHQ5NDBYRGo3Z2hGdENBRVYrdUpZZ2R1UGgzcUZFRGlYVTRy?=
 =?utf-8?B?aExSYnFKSjlHQVREZE5mL05hUzUydm5IaVJKRUo3Sk94eGxqemNGZnIwVmlF?=
 =?utf-8?B?K2VCVlNxTEhucStLdFdNVTRTSWVPb0ZZelJNMmM0ZVFsczkrTGk1TW44OGI1?=
 =?utf-8?B?Q00waC9XK01JV0pIQkFqRUpSMENNUWhWZ2xhUXIxQjdlSThoQkttWVJDRFFz?=
 =?utf-8?B?dmFqbnZ6bDBqVmYwd0lSNlZTblFVSXQ0YjFnNW84VUx5eUNFdGNKK3pYVkc5?=
 =?utf-8?B?cWs0M2JVY2ZaUVlsWmNCdTJJY3NvdWkwWll1TWhSeHpQT2xIOW5RR0xZcERU?=
 =?utf-8?B?UTA1d3c1REZNUzZCbjRBZjM3dU5XdjFLdjRlR21mNnBlNnk4Y3BXczQwUjlr?=
 =?utf-8?B?a3FucmlBdlNPUkZHaDROenA1RElqRStEbjZDRnV2QkhFNDZSay93ZGZaME02?=
 =?utf-8?B?ZVJpN0p6VUszQmN5aWpnbkZnT3VmRTl2RFhjYm5jYTNMZDJ1RWlhSHEweGth?=
 =?utf-8?Q?i/Eg81xz65QYz1yLa7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3465a2-da2a-4c3d-f2e0-08dee624e1ca
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 06:05:21.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uwbe9Ojk67fZyUpFi4YNRORI/RGYuqj4KyzjcraQ3f0Nx0pzdxiybqMKoBIM/1R9aq6chfEB6VUm7Y7G+yuD1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071



On 07/07/2026 16:08, Tariq Toukan wrote:
> Hi,
> 
> This series by Cosmin refactors mlx5 PSP support in preparation for
> HW-GRO support.
> There are almost no functionality changes in all but the last two
> patches, which address a long-standing TODO in mlx5e_psp_set_config().
> 
> Regards,
> Tariq
> 
> Cosmin Ratiu (15):
>    net/mlx5e: psp: Rename the saved psp_dev to 'psd'
>    net/mlx5e: psp: Remove PSP steering mutexes
>    net/mlx5e: psp: Remove unneeded ref counting for PSP steering
>    net/mlx5e: psp: Merge rx_err rule add/delete with ft create/delete
>    net/mlx5e: psp: Use helpers for steering object manipulation
>    net/mlx5e: psp: Factor out drop rule creation code
>    net/mlx5e: psp: Remove unused PSP syndrome copy action
>    net/mlx5e: psp: Rename and consolidate steering functions
>    net/mlx5e: psp: Adjust rx_check FT size and use a drop_group
>    net/mlx5e: psp: Add an RX steering table
>    net/mlx5e: psp: Use a single rx_check table
>    net/mlx5e: psp: Flatten steering structures
>    net/mlx5e: psp: Make PSP steering config dynamic
>    net/mlx5e: Return errors from profile->enable
>    net/mlx5e: psp: Report PSP dev registration errors
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |    2 +-
>   .../net/ethernet/mellanox/mlx5/core/en/fs.h   |    7 +-
>   .../mellanox/mlx5/core/en_accel/en_accel.h    |   19 +-
>   .../mellanox/mlx5/core/en_accel/psp.c         | 1007 ++++++++---------
>   .../mellanox/mlx5/core/en_accel/psp.h         |   18 +-
>   .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |   13 +-
>   .../mellanox/mlx5/core/en_accel/psp_rxtx.h    |    3 +-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |   23 +-
>   .../net/ethernet/mellanox/mlx5/core/en_rep.c  |    8 +-
>   9 files changed, 516 insertions(+), 584 deletions(-)
> 
> 
> base-commit: 31816fc5d9acf8cdf226cdd0dc296e8cf15cc033

Hi,
It's been in-flight (still marked New) for ~2 weeks, and is blocking our 
queue...

I don't see it tracked in Suie anymore...
All comments in the thread were answered, no changes required for now.

How do we progress with this series?
