Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5D1FE471;
	Mon, 10 Aug 2026 05:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786341070; cv=fail; b=mjZCGC/yCPqNCRvIfYqFJqzBdO9hD+QcBScSUeDEdgYAfRxlhadpXG3Ue3dKpoabfgdzQCoKYrYfkUttBYPOyHxSVHsnEHzhbXu8X7kXbTDRrQ+D4OwWufn+0h+vhHTSmsJlSgC9om2iHDuYAiM8zWCBuqKzZXYWCTfieVbYwbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786341070; c=relaxed/simple;
	bh=/eyXM7Al9yHO6d6RjAtQaa/YhhqswP+c9lWbDH/HpRM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fyIzY2q5i/2K540szarZltw76zIbb9mYVCfp8blQz/lLMLpMYrEXW3fW3RhpfdI01rGajR5fBDnqsZPusq0CVX6+TTLiIiEtNqN+mVS9jSbmM78zivL06Plqzz9HkSCqvYa1nzUvTu33PfKq/dkm1/Wmf3Mxx5OGUcYDeffw9hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ol5tW60w; arc=fail smtp.client-ip=40.107.200.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ol5tW60w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruNIrYx7ZSpsvBR6dASEUtdHcFBmgX8spS3l0Lodk96QLTSgAv25jaCKsTpcM7kAkAFD8CQDE7PJQbL2675rMDnRXUlyU8h9qYtK2u2NLTkOo/2LCW3R0hyLMYo057vflHB0wvD24bCkkeH3xAbJOaOdaBYaWnMd8+LeuZgiWOEW89r0Pfu04eER3RePabQIJTeqe5WKXDrFLzLVCZAWGutN4eqm98kxWGj7UhUHzNovkuiDDWtCFPwXndm0lAaLYzFsrMfBL6ElyHQVHsBoczgPd5gj98BlfbCdeHRVt8bajM5u5TvVVrdypSf9pPoO1yRba3JYyJCRqPji04tSpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eyXM7Al9yHO6d6RjAtQaa/YhhqswP+c9lWbDH/HpRM=;
 b=yJHuARK+CH0/fD2ke77Gz5qeKAVzrgWwaEu6eDJDvrYT3m0wFuk64vbkLHLpA0L4tjaUNt2G9AvEMLVoQ6kTeJa7ijbo/lGt/6n+V6kwhM5RVwp9E8jaN6Ywh5FpwOOX77jA1eGCn89ydr5zfW9QhSogbXap2W9CWfwBtES/gc0txAF2byJ+KGd2HsznBDBzLQAoN3MjyOoMyXReeFwypDY2ICl64RSuh7WfUxuXEiniY0Y/o3V4UMyNYPz3zr2JKag96CpE5njxeLzNgGa2/4u8+VHLi7lEbpYsxc+WZ8AxjeyJEXhQ2TlwfFJAwLtEUbg8/UaGqCZC1w2PKvsalw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eyXM7Al9yHO6d6RjAtQaa/YhhqswP+c9lWbDH/HpRM=;
 b=Ol5tW60w9yaXk5PVV2Y+G6YRhYH+8qrySLUsmsrn2ysYput5nUXhb+wLe7z/0SLE1e62gx06DKVGx6aE03orEdXEEMOnGAD5BoEsQgoUSVhTSmqG5s+WvNDwgFhiN+zg1b5VvXPGlyA7l30mXCPmSpwqW/D9avB1AgbMTnjAGWltA8TE/GYKp8Lrb/pyV6pRQN61/gPAEKMz+JTSLvG4V81ydz7+WfzvgQCFCvIznHBQqwD+M4NGOvMKTi3XqJm0H87kPritp3j3qEIRS7Yj0LSfETcR5MFCcOuW0BMhzfkJIJPGz9NPqYnr++XNky9g4UXdmBVzMc2pPROAmy13Yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by MW6PR12MB8706.namprd12.prod.outlook.com (2603:10b6:303:249::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 05:51:05 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 05:51:05 +0000
Message-ID: <ab0fc9d0-0aca-49d7-a67d-b240286edb1b@nvidia.com>
Date: Mon, 10 Aug 2026 08:50:58 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: Add mutual exclusion between PSP and PTP
 TX port timestamping
To: Jakub Kicinski <kuba@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Zahka <daniel.zahka@gmail.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>
References: <20260729065137.2420679-1-tariqt@nvidia.com>
 <20260803180631.5813f758@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <20260803180631.5813f758@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::11) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|MW6PR12MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a99367-c3bd-4519-6378-08def6a35dd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fUOQ2J2zhfCgYb99UauO646miUV3WuWhCN+lNOoTwbWVSm/1ay0CX48E5MDDDkzD/dpeX2fA6lZO6dOtS3HfoD1G1Olu/CLg3P6SZzEzstyUWSnAz/wzIFgVPDXuh8iXftFwssC9E77r0yq5IP5z0T33NpjV5M0skXpcOdvn6cwZ714aHNFu8q4uGhyVVFMZQHRdRrll/G08ePsDHqmCpT6GKzXwCpbJvIUPDHHdlf+9TNAjSc3jN0pFVYzrkj4uYKbcmgsmTWAs/E51DGbzaya4ulchz2o/GnZB5Y56hfym2/JpNa77gYFROcKAUj2m4+/oPwsVfhJKHyxt4VJypK135xSuirVBNatohailJYP09/R832K0nZARiJ3sHFEY6w6/lOxaPrU5uzg9NzqWYLO7jTFZ+4DVlpmJXKg7U6A8WuwGcqas+Ds6QMyubGXnsuzDGOV7D9ykKG1GqlJOqH2BGeLl6oiQtAs51BkseKjphgmaFwRIPduXw75loa23ffh/JRyeUK89dUOUrO8lsaqhZtHhiKaGMzwRmrRYSkzwKNaB3xvgEf5o77lF5sXJe4ZTqFRc3sQq4HLEShTY1oRwIIl+0PmBiRz64BsmA7bLtw39YLpQOKTAicV6cRDDE10jJ1ZxqB111eM4OBieVOa0q1PhYJ6QXmusoXB5PyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2d3Y1QyUk84amNET1ZUTmg3c050VUZFYlZRSVErYW9XNm10ajFlS3JYU2Iw?=
 =?utf-8?B?cWZQN2hoa3F0RTRmR3NTUmd5UDIyTlJYYU4rT2ZKejRydndSa3FNZ0krbURL?=
 =?utf-8?B?NUQ1VGc1SnlNYW9qMXduekh5Z1pWK2x2dysvZS9uNWlmMzhHQTNHanprUjNQ?=
 =?utf-8?B?VlhYay9FelE3YlFqeFkxc2tybVc0TW9rVmVqdi9kVUZPcDdiUUZ4WktoZlNk?=
 =?utf-8?B?eE5Mb0hnaVQyVUhvdUVsZWdIT0FzWEZ0ZStLK1lRd2xlT1hBUjdobU84ckpK?=
 =?utf-8?B?dE10NFVxdTM5dU1HZFRKZktyRlFGR084ck43L3MxeGw5QVg1TmFZRVdnYkFX?=
 =?utf-8?B?UjltcGtaOUFLTUlGdS9OeE5sbHhBZGc2UkVrWXhmVzNKUmduc09oNklFbXhq?=
 =?utf-8?B?RnpZdXpWL2hRR1NxTW9kZmVoZU5GVmVFNFlEdmpyWnJoeXlTM1JjVWJDQ0FC?=
 =?utf-8?B?cm1zRE1ENERrVm4rZklUdG9QOTJNYmVkMytoZ2R4dERaMzdPa2plVC9PZkJi?=
 =?utf-8?B?RDJ1ck9kNWZvelNxUHdWWTdQdFQ1bFI5Qjg3WU5BdkRaQy9haCtCK0RRa1Nk?=
 =?utf-8?B?Wk9ucDBIVnVka0lHSkRIYmZmZ0JOdytoUzBnVmdsa2YrOUxWcFdFWHlVblBP?=
 =?utf-8?B?ZmRyMEZ4ak9pNXZHd0luYkN2cXgzOWI4bStTYjhZRHBiWWRkSnZFTjlRNHFH?=
 =?utf-8?B?Z2liNkh2UExEYTFVbWttWXhuQlFWVy9YWnBOQmJpak9TMzR2aW8zZ04wZTB5?=
 =?utf-8?B?UjdBVVpNbFpRNWFwaG9IeElDYitndzVVdGgzQk52VWIyWmtRWkJiVFhkd1hm?=
 =?utf-8?B?bXBoWkdtMStSaFJJM04wQjBtS1ExTmtNQVlCUmtIN1QwZUNmaWh0TnUyQUp6?=
 =?utf-8?B?Vm04a0xBUFA4ZUNmQk1OWWNUenJUSTAvU2hUZ1htb2s3VHM0MGRBTWJDUi9R?=
 =?utf-8?B?bzB6NWMwcDQ2bDRYNVZxZ1F2c004ZUwwWkMrZHMyR2drcU9mdmcwcDM2OGtK?=
 =?utf-8?B?WkMvUlYzV0xRT3pIZjBDSU5MTXRtQ3lmOFdpQVcxOTVhbWNtZC9sN3dmbVJF?=
 =?utf-8?B?RTYxUEI1emUzajJiZkJYTm01a2xCVUg2ZzdBeWFnQ2NneUtGOC9XYTk3U1VO?=
 =?utf-8?B?ekYvWi9YMk1pNFhwU2lVQWRtcWs4NzZpb29JMXFLSEZpYzJNeW1RUmxLVCtv?=
 =?utf-8?B?cFJvUlArdllmdmgyYXp6U1VXQSttc1UwRHVDZGdoZjJ5WTBmOU5IVjdyVkRD?=
 =?utf-8?B?bzhaa2lTQkhJeE5ZSHE3alZWOFZWVXA2eDUxa1o4dnkzeVFJck96WStxc1Jw?=
 =?utf-8?B?cmxKRnlCdURTZ21JN0FHYjd2Z3VUdWZWVzNtekZHb0dnc2hNSjAwbC90enY5?=
 =?utf-8?B?NjZ1NlUyZkVReXMwOGNKdU1jMGZWZWZmYlp6RGJ5Mmg3RUUxRmszOHM3Wldo?=
 =?utf-8?B?aEFHWGJTU1JHVmR2ZFZtV3VWZ1VjWTM4eitlTXRWSFJ2M2pZc3kyRmRHYVdY?=
 =?utf-8?B?ZXphc2dXVnRIM3R4UTBQZklQRldVNDcxWDZrMEx4RHZ0WlZEaFZnSy8vVDlN?=
 =?utf-8?B?RG8wMy9wSnJSN3pIbFZISFMzUkxwNVovUE93bnIzQmlPeGRQU0p2d2hhYUxG?=
 =?utf-8?B?MjV1NlJyNlVnMHIxOCswYk9ZUlpJREZtZUlnVmdnQ1QwWW51VElXQUEyK3ZX?=
 =?utf-8?B?MjBjcDBGVUcxSncxQ28vRmF4SndlQk9CR1NqOXBPVk50cStmcVhZbXBrRkRT?=
 =?utf-8?B?UjlXUm9ZcHM5OFQzY2t3ai81dEIwUExOYmVjWHBVRW8rOTJnRUwxaW5XOVRi?=
 =?utf-8?B?L05oTGlsaGJaT2plK1EyMEhkV3ArTThIME50aUtkdCtER1hpZ1dSQkJnRFYw?=
 =?utf-8?B?UkI0MHhIcjRibkVMcjBqbzFRdnNtY0QwK2lOcmdlcEUyOXFrL29pYUllQlNh?=
 =?utf-8?B?TUQ1U1hPbmtLUXdEaWZpUmZubVZ5SU9OVkRmU21zd1p2amdKOFNDQXAxVzJZ?=
 =?utf-8?B?WlQySnJ4c0VoVFVVYUlpL1dMYnIzbGc4dCtMT3M2RHhaaVgrTHFCWjc5TjFK?=
 =?utf-8?B?NDAzV3ZpRGl5Qlk3b2Z6TW1YRVRKcXdMNWVBUE4xeVpvcVh6eGt3MzNaUDd0?=
 =?utf-8?B?YlpjakgwczUxakxkbzJHdGZBRnU0RjJaaTU2dXdRQjFaL1dQUGNVRStiQTVU?=
 =?utf-8?B?K2tZbUZEMHMwY2Nxa2lJeDJlMkJaNTVSRHhRNGdvaE9pUW52aGEwczRUVlBV?=
 =?utf-8?B?K3BZMWtUYnJUVURtSmJXeEgyRWp6NURpVTJIVGhUUFBNZzZ0bjZXbWs0WG8y?=
 =?utf-8?Q?NY55ObROYn6Md6WJ9r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a99367-c3bd-4519-6378-08def6a35dd6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 05:51:05.0096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOBFvfaQ30DGQG3PSZsVpxH2hud4ea0syjhx+vvBydKSmWnLWbyChjDoSnDpvTNXjaFFznYCaC3tE9FVQFz+sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8706


On 04/08/2026 4:06, Jakub Kicinski wrote:
> On Wed, 29 Jul 2026 09:51:37 +0300 Tariq Toukan wrote:
>> The WQE flow_table_metadata field is shared by multiple TX offloads:
>> IPsec, MACsec, PTP timestamping and PSP each write to it.
>>
>> Commit [1] resolved the conflicts between IPsec/MACsec and PTP
>> by shifting their markers to bits [8+], leaving PTP's 8-bit metadata
>> index in bits [7:0] without overlap.
>> But then PSP support was added in commit [2], which writes a 32-bit
>> keyid across all bits of flow_table_metadata. Unlike IPsec and MACsec,
>> PTP timestamping applies independently of encryption -- a PSP-encrypted
>> packet can also require a HW timestamp. When both write to the same
>> WQE, the values corrupt each other, leading to wrong PTP timestamp
>> tracking and potentially wrong PSP encryption keys.
> Is the concern about Tx? (please clarify)
> If so, Tx HW timestamps are never guaranteed, why can't we just
> skip timestamping for PSP packets? Only TCP supports PSP, and
> upstream TCP and HW timestamps are pretty much mutually exclusive.


Yes, this is about Tx

You are right. I missed that PSP is TCP only, so it never
selects ptpsq. Thanks for the clarification.

I'll drop this patch and I will revisit how to avoid a metadata
collision without adding overhead on the datapath.


Thanks!


>
>> Prevent the conflict at configuration time by blocking:
>> - Enabling TX-port-TS when PSP has active TX keys.
>> - Adding PSP TX keys when TX-port-TS is already enabled.
> Why catch PSP at the Tx key programming? PSP docs very explicitly
> require drivers to _not_ enable the feature by default. And tx
> keys can't be added if it's disabled. So it would make much more
> sense to catch the enable / config callback of PSP?
