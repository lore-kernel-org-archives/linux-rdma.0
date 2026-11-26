Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795664437;
	b=FvLW03rBVkKWrr7sluRE7PfgEIaiR/HyZaaE1SUQlbMCL6HzBqLy4uZg6rPjxQTlQhI+
	 VvQvXm9nN767zGiG587jnt//vb6nblHuHapMPLanMaARNhOC/JyTA6GEE/0AUB3lvaNpC
	 dhvPpBnXF8v1o2WocaVIlY0Z5SJs0+J8n2WAPJHWBxMJyDZ8TG6BPA0vJ9QDGSFGZw6BQ
	 MlqTqwP2BwJLr3s2afNlkmSWcwdcIVkxkZr/jw1mHg2Y+tZn4nF7+9aRt0kgNg2DuBKR/
	 D2fd5bUlyOqZMJkUtbls8TTh0QQhl3ehf67y6rIov+mWz44a7nXHhRr868yyjJ6rqbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664437;
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
	bh=3ZuYmTE94y07p0o90PvGGBE5II2EoQ2tJ0N3w8YFe9A=;
	b=GUC3CAJkknHQ8U1Yu/ZAzrMkmGhjcQ3mSKkodQZG7cXyu7qxXQP6xLjpVYo7XU5yHn/i
	 ShUtKkKM9AiRiqOxOBKxHZhkKQW4W93V87Y5nN+THjGLvCZofhLMMoeBEyDxTfsS9D/17
	 vxtjqoxJaIXegHN0OOuJW2EI+8ZaaozlmLVfIOEa7mg3FwUDyTIy7L1gEPn95AFHdFzqW
	 1LtLp+VP7Ujdzr9AjJTI7rZZ1JzYZUNQV/aObrvWwh+HN6VSf84X8AT9e/Rra7HXCx586
	 NuFag8IG0hi/YIAf9CPlYD1jKxMexrg9/ZjIIIvjQERJaOnBNYcOwj8NQI8VMLOkaqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mYxb7UuQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.34
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98120606A338;
	Thu, 26 Nov 2026 03:40:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98120606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mYxb7UuQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcFn3WA6Z9ZZ2E3kgXhLGdriAdzUkLOW3sCH0x5SVPugu/lCwP2Js0Kw6FF20PrkQY6mZUZQ9JtH5fvFVb51UtvJ+pC0r8421jFdfLkQlVjFi0km0loPV2TIWtK2NsxLofJ5RyGQnmuUy29E8DCHOk/0LoULGIZWgfXEIN03EZXY95zQ/DXRYrew3igmtF6T37EJumsfEaXgOF0R3MLCkDSc2G87YCr0hVrmQ0I29Cs0K1Vh2xJ7/2F4UD0Dvhjyc8wIw5ZQtaehvpH3ifes7Rwx9eSiVVRGcZsMzPcS3G5ZXL+RCzk9KP3zz25xY145vh6geyard16TTk5TPtAJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZuYmTE94y07p0o90PvGGBE5II2EoQ2tJ0N3w8YFe9A=;
 b=RyuQBnCwZOfjad0aFz7BhvkP5JVCo/wKFg9zeSkIeQeQmahH40+8WHjk0PoaxWwIspUC97P8nsJvfq0/lkggqiGeZGM93bsKvqvUvX0r6NUkX1IONFTC6OCrN4PKvAoAyj4RVX5q96qlS8k9YKLIeXRP80wNw4Nrgn2outXvvQL5RTa4VRirN8fx1geVgRpJIcpXvwinopwR8UARY66dB0nOogRxgsSc8iCUiMcFb+0iMA7ikED0Wyziy9imiYiXmJj1pZBOyRTwAwJVkQhiKCbWY//BqOM45MBvyJSB4VnODMUmwlEl8YKgOuf509Gr4ajiJpEmdr3g5QT1a7roaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZuYmTE94y07p0o90PvGGBE5II2EoQ2tJ0N3w8YFe9A=;
 b=mYxb7UuQPAYfYGAnpUDgBg99Qdm3M0IMhRE5ivozl/UvbOaehhNJnrtyMkI+7ZB5iJ2/Ykg2sjSAMrLIEJZJpfNmEKzebUlCG6mJqwJKfTLT31HsnrH7SmevyN6fKxsfsjGscnWiUsuyKThaXlO2ZfgTRNctW1z395N0VCsfkD4qcGuBcCcapWCP6q01iLukjyXEUsHLrDmh+zdfuo1mRMdLBm9DQf8WWr65ZisLYcXGrrzRRQvuWYxqbDTssc9WpC34e1XJIR9nf1mcm9SVEgKeQzTYRPwjsm58z/GXzxKFME9CmKpZrbjJsZy/uoPPMuUXzMCLePHK6sQDb/1SSg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22)
 by SA1PR12MB7126.namprd12.prod.outlook.com (2603:10b6:806:2b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 03:40:33 +0000
Received: from DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d]) by DM6PR12MB4354.namprd12.prod.outlook.com
 ([fe80::7106:c186:62e:bc0d%5]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 03:40:33 +0000
Message-ID: <494ef918-3808-4f22-9e80-94508e801e13@nvidia.com>
Date: Thu, 26 Nov 2026 05:40:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 3/5] net/mlx4: factor HW loopback DMAC into
 mlx4_en_set_loopback_dmac()
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261125180021.1804204-1-joe@dama.to>
 <20261125180021.1804204-4-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261125180021.1804204-4-joe@dama.to>
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
X-MS-Office365-Filtering-Correlation-Id: 93cd0268-dc10-44a1-745f-08df4b6f060d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|11063799006|56012099006|4143699003|261021121427099003|261021135927099003|261021123027099003|261009223027099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	icVegYcTiuPyKxwNcVS4JevKpbl/L0rbKr+7f4VOnPbKUbHha0oc+BW1PnhdFp4Ljs7biXVnRdiGvMSZ0pfgvzYZ59+S4cNQli+WJahxZwcp9W6D+NOhyxOxKBIXQRBUxtFTRKsHp5FkmTglEa7mhG/2uR1v0a+QWZXdO7Ns5yFHLedrNu5U8jFhvXjcqLcGKHJtAVZVKxF3uZBehX1Y1GmP5zSdI0lkSMGeaf2emCg0PrSAt/CyHSG8zQ1lncwFSRFdCvv31j0ct1j+ND2X5K1Qx1QAev3r27DylhwwqX9KqcA5/WXE5xtih9lI3kmLar/KSv80jeQjPln70nMP3HLFuCDvTeIumocGauQkIK1YR1xXiWzBKxoDFfRqebLzeoMblxseNNYFd/R+g1gbS8DmVLm3siO7ELW0b9BLF1f6pzVyC6fwLr1mQ+5AnkbLQHq5GxtCmMsl2gCl/gAWPFPxBa5dYAQxLKXePYc+f/cq84JgTi31GqUSiookvMxqYni+JFyQimVNCLSTRjFSxPdmEX2SDjRyHVMum01zMKbIqsoiIhV03Lgfks2ZbeV1iXOUN+bU6MuDvWoRipPVhjs9LTDh+kP4BDmMPdWdtmn+sCs2DXpOFLUBkkwBnzRLtF95OCdYFAEjIP5gIjST6Wm8FBw84xl5YyaMH9G13LA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4354.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261021135927099003)(261021123027099003)(261009223027099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHJlam5seFBndUJzVkFyL00rOWZGeENOWFNaYnVNQ09kbFVhM3g5aXVVT3RW?=
 =?utf-8?B?MU1EeTI3anJVWC8wSzRwNUJNbTEwOGNtM0k0aExpa050dEdVYkxRd3ZGc3RM?=
 =?utf-8?B?L0pMUnZqUXVLWDIxOTRnZzh6QnU3MGNTZ1dWMkxJdlNFMHVlamN2K21xTXBq?=
 =?utf-8?B?MjgwQUpFcHR6WndQdWsxWnZOU2dRRzZ0bmxDbzVFajBkeDF3Z2Y0aW54d2ZW?=
 =?utf-8?B?ZnoraFU0V01oUEVxT25WRVN0YXk3VE9jRFJaOFFnS1hMdjlraGszK25KWkNn?=
 =?utf-8?B?YjErVm5uMEp1VDhMekM1K3dWVnJXSXRkeUI0eFlIaTd4dFU5Q3lqWWNHNlBT?=
 =?utf-8?B?MmFCV0JaN1RwbWlXMHZ4aGtDdzUrNHVxQW50RDhMdkM1Nk15NS9WUHhvbS9r?=
 =?utf-8?B?UU4zOVp6ckhtVW10MW5RdERXZWwzSG1mSVIvMGZwNnhiSW5zbUJ0Tkt6MlZW?=
 =?utf-8?B?Z1ArRVBEYm5jQmtZczcwRFFuQzFiNFViSTNMV2NEK0VpSVBQZld6Ujh5ZExH?=
 =?utf-8?B?Ty9SSG5KUjFOdzloMUt3bnFxN2Z1elVsTHc3U0J4NnBJR1R5ZWtPZWFnMGNH?=
 =?utf-8?B?cWIrSk9uYTRyR3BRTm9uUzRnNFJ0T2ZBcU90MnFMV3FIMGZGVjlmWlZDQ3Js?=
 =?utf-8?B?UEVybGlVRTFya0tXRVpwYTBzTkpzMU1QUWVFeUdRcmFMcW9OYkRkdDNhdXkv?=
 =?utf-8?B?dDV6aHN3S2FJSmh6L1pXS21RM015UUlPYUphL2JuQnhhSDRaUDRpZTk5SzdD?=
 =?utf-8?B?UGtSTThwVnhXSlZacG1FZHJmcVpjRmJ2cDA0SS9wNlVMaEpjRUl0cEQrVEJN?=
 =?utf-8?B?ZDkvbDZnTkR5SzFxcW5kdXk0ZkFjWTFZaHRKU21tTkF0NWtHTkxvQk8zZFov?=
 =?utf-8?B?cWZXWTBvSE5RKzlzUmVrTXFJdVpYeEdlRVdLcWdGRFo2b0lGZTl1VnJSWTR5?=
 =?utf-8?B?RTcyR1hYV0FibTBWTWprN0hqR2E5NzBIYzBwZVMwenAzQXdSazNHbzdqaUhO?=
 =?utf-8?B?emV3Q0ZOa0ZVd2ZyYmZLZFVVaGhGV0I4NWdUYUFZRndXZEM5dlZtTXhsTTFk?=
 =?utf-8?B?aTZYUnZiZG9jaTZjL0JpRUtWV1BSTzE0WWZXN0ZtTTM1NytRbkpsT2hwRklo?=
 =?utf-8?B?Q2hCUzBXZFJac01wOHNiYVlUdjZJajZ3djJOZWw0NjlLVnNjbWFUY3pWa3F0?=
 =?utf-8?B?SEJHT0xNZXNKb2xGaDNZUkhKVm5TeHB0V0tXS20rZm16WGJ0aVJKN2hWODI2?=
 =?utf-8?B?cnpYenkyazJjSVpCWFlCbXN5Q0dza1hLRlF2dko2ZGIwcnBJdmloYjNhdzVv?=
 =?utf-8?B?SmFCMFpLWGZ6U1pCSUFSWUJpL1ZDb1pyN1duQ1F3K3l3Wldkdzd1OUE4ZUpL?=
 =?utf-8?B?WU96NVkxS3dLcGhTdSt4UkROZm1OM3FLbW82NHZPM0thY3lyTFVEajRNZDAv?=
 =?utf-8?B?SzFmSEVkdDRaTnorL0RBbEdSeTZDU0I4cktqbWU4TGJZaWdmVSszaC9EYnNL?=
 =?utf-8?B?aGFob0FXS1NFdWFkM21ISFlueHl5RnZ1aUtVUmx0Zno4RUJ5RXZHTW83L0lq?=
 =?utf-8?B?Tzk2Sk1HbHhtZmU4TGl3MUsza3VTSmdLcHFCZC9YZVV5WGxaeUFqbXhuQkJR?=
 =?utf-8?B?TitvNXhqYTNJTjVXNzYyV3I2VlZHZHRPeTJPaUxnelVEVjFkUitvbERwWlV5?=
 =?utf-8?B?eENEajhvd0FlY3g2d004d09YMFVtY2R0a09LY2IvK2NqRU0vd0pnblIrVkdu?=
 =?utf-8?B?QTFyWVY4Z251ZDVNYm9JMXUvNnhxRzFHQkFJV2lxUnlLL3FrZ0IwSzBFSVNi?=
 =?utf-8?B?WUludC91NVR0T0NZK3IyZWlOc3RQSEx2SFF6OUpPVzN5SjdDamU0eDYwVXdG?=
 =?utf-8?B?NFRBcy9ocVI5bDJDeDRDNFRxLzB0eHR1WHZiRytqZ2tUcnVFOWt0RDZUbU9C?=
 =?utf-8?B?cEl4VjR2RG5BRXVrUytjdmhDdTc2WlNIa1plbE1oZ1RnaGRMa0MrV2VFSGpW?=
 =?utf-8?B?bytjcjZqRUpZZTNiZ3NIZEl4SENxL2NEOExzSGJBeW1oa2N4dytLdW5PcFR2?=
 =?utf-8?B?MDhrYitQUURSWFJQSTF2a21wQkhtWExDSXI5WkoyWVdGWnJZYkNsdzFwcCtt?=
 =?utf-8?B?VXJUUGdGblFSbmpOc3lETmFPYVRwSENZTTRvQmdzSk15UTdlcVZUY2t3SkRV?=
 =?utf-8?B?KzhzdVVXUHZ1cEhQUnVEbTd6UGc4NnRRT0JJeDBWdTk3OUl0NzBUWFVyZ0ti?=
 =?utf-8?B?Smgxc1lRMVBSaVNRTW13M3N4M1B1TUY4UjJkSjhKM0xjLzMvVWdnMkNXQXFn?=
 =?utf-8?B?N3JqZWlVcDJBWmpEbVdGSVRBMXB6R21Oa1AzbktZWWpaalErbUVJdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cd0268-dc10-44a1-745f-08df4b6f060d
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 03:40:32.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpPWuehdBIA+F1RvftvD2h09LRfBP/Qs2neAxyFiobsL2A77zytGRF96uwQutHK9OwGgg+qaLsXN0NmYVGovVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7126



On 25/11/2026 20:00, Joe Damato wrote:
> Extract the code which copies the destination MAC into the WQE for
> eSwitch loopback into a helper. This helper will be used by a follow-up
> series implementing software USO, so USO packets between functions on
> the same port are looped back too.
> 
> Signed-off-by: Joe Damato <joe@dama.to>
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

Thanks for the patch,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 28 ++++++++++++++--------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 1fb265a30a30..40dc4f6a7329 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -870,6 +870,23 @@ static __be32 mlx4_en_csum_flags(const struct sk_buff *skb)
>  	return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM | MLX4_WQE_CTRL_TCP_UDP_CSUM);
>  }
>  
> +static void mlx4_en_set_loopback_dmac(const struct mlx4_en_priv *priv,
> +				      struct mlx4_en_tx_desc *tx_desc,
> +				      const struct sk_buff *skb)
> +{
> +	struct ethhdr *ethh;
> +
> +	if (!(priv->flags & MLX4_EN_FLAG_ENABLE_HW_LOOPBACK))
> +		return;
> +
> +	/* Copy dst mac address to wqe. This allows loopback in eSwitch,
> +	 * so that VFs and PF can communicate with each other
> +	 */
> +	ethh = (struct ethhdr *)skb->data;
> +	tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
> +	tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
> +}
> +
>  static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
>  			      union mlx4_wqe_qpn_vlan *qpn_vlan)
>  {
> @@ -1007,16 +1024,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
>  		ring->tx_csum++;
>  	}
>  
> -	if (priv->flags & MLX4_EN_FLAG_ENABLE_HW_LOOPBACK) {
> -		struct ethhdr *ethh;
> -
> -		/* Copy dst mac address to wqe. This allows loopback in eSwitch,
> -		 * so that VFs and PF can communicate with each other
> -		 */
> -		ethh = (struct ethhdr *)skb->data;
> -		tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
> -		tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
> -	}
> +	mlx4_en_set_loopback_dmac(priv, tx_desc, skb);
>  
>  	/* Handle LSO (TSO) packets */
>  	if (lso_header_size) {

