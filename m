Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794943118;
	b=G0hUdu4cU2h8IOxdlBnLyaq0NrHb2EYMp0a8EW31Wb+rJ44FAGowTRODc/jYz9KEjgsj
	 VftBRrNlGekBslggCvqf2fqyOnpVvXU+GzECo/6ubKbHPmeW+Su5INUjTiMMB2K5qT5oh
	 T9GhUtzrSbakEzCJyddxqqEOwDbmwNpqEkJ18XsCOFn4ijbvDSytFSmDVkmVGXtlIyfOG
	 WWhB9vkyNXTQY1INFEi97rITjSrbuTNNuENdAsgojk3BPFd6MMJ2ZEFNGGrcbGdIoSCS1
	 7n4FLLzYNp04QEpPb+8LRQToT8Zro6srOISxiWuym/9Or2hBjbZV/9EApxsmxkw7HKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794943118;
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
	bh=RRV2dCZRN0J5FvXJlcW6c+6oOF3yGngYfzYJp6Lk1jE=;
	b=grURhm1FExNu1IhhLDHuAjpRU8vyl+giHMr9Lm/IVhC6LjHoibjfefNDkSpl4J/to1Fq
	 sBu7qnWlIsGzkLCHODJVfcbxBYc5m23dwD/e4JXlnfNDlRY6oe1OywNsh2p432OiMAJ19
	 4+LAW4W7Am6SwJ3qtFZEl6PdyYYTLc9vIqVP1YJwM0R/CHrRH7TRSa2kayGW2YvzX2keB
	 mhxN7hV4XAq7ZlB6zWnJaZXi6v9Pq3CzNS9MfijXE9svn+JBr6oQAhwv1VcZX8Zc8WXG6
	 W7BTXcCji16GMFmNmK4Pbr/WLK23ShqIluRA52FcDe3xjZ7KBLNQyEbefcWqXSzPOfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ayvxKAar;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.17
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013017.outbound.protection.outlook.com [40.107.201.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB231606A31C;
	Tue, 17 Nov 2026 19:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB231606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ayvxKAar
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXzQ0apeZoteTsrhdYlgUtEBjedupHc2STiGHRr+c4JdjLO3RMx0FW6s2uLisbTR8SiuvNH0SX8FqbUCH6KIUaKL9z3pp7y9YZErOxAgFF/uCX6jpg2sqhdqcyustf3c0Mm4x7TLSHu4YGI4sdn5tJbEQTFVGPkMvN+I29MIjXLQbdJA4FAGfnnFJsKOzeX1PNUgnrpiDHu3sKRJFSHN4yoclhYoYC2dsEOgzQmcsswDYRTcsd++MUG9OTM8vXRaWFLIku4//qbgsOxqAe9zmum8/iLToNhJ7a6HIU08SeYx/tEP+vGBYhujHTbo96uz6yimtgPWKL95C7cPn1O2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRV2dCZRN0J5FvXJlcW6c+6oOF3yGngYfzYJp6Lk1jE=;
 b=s9bUoRIfjt/N2cW42yUH303u+GSUlkWhdIp7q4LKAqqLleBbECo9JZqeBSC7Xrvwxn9fABpZ6GOeARBIVFqKPbjCAO873ct8mVAGu88YTyImF5nV5U5bMP4MUfzelQ9e0M/oH3u3WjX0GZTEnCiZiiGX16/RIqgf0YNy6qdVxsJDRTkqlAr5Iaw+sAnBGadL6f82Efozr2lFGvQOafIYoHriljiDL5uwg+rwVMzqOWJq/LSHamPVRrj02sxIv206TEovC5+b0fdA1X3T3sI3TaXITJ2YSpxbsWm56/NdKcYdgjraKoftcy26wKoHsqRZMW9DRIYhSoDdK8ldKzmlzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRV2dCZRN0J5FvXJlcW6c+6oOF3yGngYfzYJp6Lk1jE=;
 b=ayvxKAardQle5GQRNFsSajLKRM2dJj40FzJIW39mbQmClZPncfjQyAbpSRkAqBBv5W61hsgfHHGv6XCFPF26PPX4KTOQzwWi/Ee1+j/w0Kcute/twYxf2llVIxmjmycDyNTeFORCK3e6+S/IgK4E4bnNQatOke7Rbc4eNATavP9aKrQEWuHL4JV5zghA/nOLLzb/qlj8GdU0nLZkMs8KJVVyUyoWZeIpXkU0IQEAmaX/hVFxNC2KIf7x6F+GihaM0kuyet0qIP/ajWX8a7VdxUKhtr+yrYZUt/gm1OejhdFo3WyL7CsHrFQX8IBXpSlrMN5mm7N/N6T9coQSCvsm1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by DS2PR12MB911612.namprd12.prod.outlook.com (2603:10b6:8:405::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 19:18:34 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 19:18:34 +0000
Message-ID: <82d9959a-8176-4433-94a4-ff72445306ca@nvidia.com>
Date: Tue, 17 Nov 2026 21:18:29 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mlx5: Allow police as the last action of a
 TC rule
To: Mohsin Bashir <mohsin.bashr@gmail.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, idosch@nvidia.com
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::15) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|DS2PR12MB911612:EE_
X-MS-Office365-Filtering-Correlation-Id: afc020ab-0efb-4f0e-6fc1-08df44df929f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|18002099003|6133799003|22082099003|261009223027099003|3023799007|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ycQ204CFhzI9FWEA2t6rwdVIziEkQkmjfsjuiu47K84uA5/V6UotMsg0izDRktsx1b8aykPsjaxKYC66xEcv2CuO2WhrT/DB9FyUocSJH6HEzr1rf7otUB31rEw/lUr9rhTOP6ncFrnVd4ye9BpjqEdNFyV0L5NACwZWUqh8k/0NvkBmgzmSQRf6C8kEyne/OsAZ8pjJlHz1rm09xz48y8l8eAkwRcwKzisi4KBJbzb1Mbfbt5wCJqQZK57IgIHVobROtdWLLtT5pGFEqreoTqMZkXt4UEYdP2UZJdxRNxyf/kJauMkeeFOAJTro13SV1U1o31uwbCOD+gezheHCAtdedu2KsdG1LtsbPYhT8MzZ+7WP0H8NUS0qScSlM2m77OAs60/EDDNSE5bVMMwoO+Lm5Qc101tJsUB38Rhl2WpBrV4GrqYS2TYH7AM4DXptffoaSP9FUyZs1lSd1H9QHT0pQC6vLfOIq/39aJ0vY1yyIv4BxgEFRMkGsSfY5YpIb83/WCp9WdjEG4I6mRq3IRLGjwX3bfJGGNTLKcBYDPsXKLTHwAXss64FncMAa5SGKwmSj79bO5iNKUGgdKqCbihIGwzhLjBNG+ovRAysdDaVrC5wq4xYe2AAIfqWcuQ6hboag9oEzbotgVliN+9WPzMXzeMERkiOObkiJF9bVGQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(18002099003)(6133799003)(22082099003)(261009223027099003)(3023799007)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXJsbEZ5dzZFcXlGRU5EVHFpTHVCWm8yZlF0VVdmbElDbXFkU0NNamhRVlN2?=
 =?utf-8?B?cXdITlp1RUxnOHJKNU5oOU5zcVFKdUg3aDlmMmI2TzdKOGpSY0lBc2hSMEk2?=
 =?utf-8?B?dkk0VkluOW5mRXJlV0FLNFQvMi9TTlZ0UEl4cExIMWUyalk5ak1GWUtBVFhB?=
 =?utf-8?B?Wm9HQ3pRVGNDNzZWWHVLVW40ZUlWc1luNmcvbWFZcmhsd2JnOGtEVHdXNHZF?=
 =?utf-8?B?M3Mxc3I5WnRBVXhvaEpucjBwN2M4NU43ekFtSkdTN1QxZlltMGdlNTlSK1k0?=
 =?utf-8?B?aCtHckFQUXRJTERValI2ZHJNTUJKSUNEclpESk9ETG94aEhxbUkwVklaTU1O?=
 =?utf-8?B?bU9HTy9GU2x3UFNML3dVQ2FSK1JGbmJacHREQVhncXp2WEdMQ29UaWc4OFVt?=
 =?utf-8?B?R0ZpWTZ4aUxBaU1oTkJwSVJ2YXQxWEtVT056bmxuQ09CMEZwVDhkZnEybXNR?=
 =?utf-8?B?S0hNbVZidXIwOVVXNjA1U2tJNi9XVEI1eGZ2ZXQyekxoQ0pTaVlYU3dFZE9Q?=
 =?utf-8?B?RnNjZ1hqUFNrc1hKZFFyUmpOZFNtWWMrT3JGcHJDUXdFazBJbkRzR0pPajZV?=
 =?utf-8?B?MjFycE16TnBGKzN0YjBDMHVVeEowZGVlbWpwdnlFQ0V5YTlUTXQydVA4c0Zp?=
 =?utf-8?B?eTNDMkJUWGRnOWtsSVFwV0JlQXNZWGpEc3VzbXBPMWROaUpGSTdxS3lzUFJ5?=
 =?utf-8?B?RFp4UDd3Sm1DMDZHWTQ0SEVoV1pzMG94cmYzcVI4NlpiaHNuRGwxL1hnWW0r?=
 =?utf-8?B?NXVFZHZMY2dBNHRtamx4WE5NQkQvY2txM0QybWIrZFczSlByOWovYlJnN2M5?=
 =?utf-8?B?Skh2bVBhVElJYnFVOWJ6MU1LT0tnYVRZWEY3R3M4RlRkSUpkR0tZSWNnZTV6?=
 =?utf-8?B?d3oxL0FEZ1FSSlNQSis4a3RqWnl5eEdQN2FXZXJ4cml5dzhhNFhIeTBxckRJ?=
 =?utf-8?B?S3czTnRRR1l4RXpPQnl4c1B0TTU3SGRxZ2pMSWZQaTNCK2NTSlhJMyt1K3U4?=
 =?utf-8?B?VVFDanJnWEg4NVZqUVh0RGdpN2pPNHowVXFHajJYTG5LM3diNTE0NndoYTdS?=
 =?utf-8?B?bFVHb2FTbldHRlZHMmI5Y24xUkZFYUJ1bTBQRzBETUkvTkZRWXN3ZUZxTmpR?=
 =?utf-8?B?R3BSdkFJUkRuVC9CYlladCt2NWl3UkduWkQvYXZFSTRRRi9wQ2x1Y2tFb3hL?=
 =?utf-8?B?Nm9yY0xFQkZVdkxDWEFvWk8vYlpkLzY0YmI5cnExYkIzaUxCbTQvSmwxUnNq?=
 =?utf-8?B?S3BmTnR0cExQcURCK0hUU3B2MGxVdlo3M1Q4bUJlTmloS0RNY2tiRUsycmVB?=
 =?utf-8?B?RmhHUUx0OUhXN1pHQ3hoODZjQzFFTllJVkk0a21LNE1aNFVUeTM0VjNEWGZs?=
 =?utf-8?B?bnEyTGJhbjQzU1RkaitTOGNvSk9IUlF6QXcvNUE5TjBVbmFLcTZWTk5JS1dj?=
 =?utf-8?B?V1VIbGRBQmpuZm00RzVZT241dnNTM1RZSFNKS21La0dPMGw2Vit1VGQzbSsz?=
 =?utf-8?B?OHMzaCtVMlJ5Q01VWTIwdDZkNkF5bzJEYVcxM3oxWDZXd3VLZk1UZXdQa0J4?=
 =?utf-8?B?dmNITEZZU2lPZG43dCtmaUtDQnhvVFRaNjV1dkJvTzlJc2tFejNtd243U09k?=
 =?utf-8?B?WEhhaEFmcExhWGJiQ0trVk1aM1pGaGFXVTF0MzV1YWhlZHo0R3Fmdzlkc1BI?=
 =?utf-8?B?ZCtQZXlTRXNkLzgzS0REVU14R2dDSlpKalJleXJHOE1mZU5rODRlR0IrYS9y?=
 =?utf-8?B?R3BtUlRSOU1mQVJqdEZ1cGw5N252TDdmcGpmS25IcVYrWlFOcDNhVjVnWHpk?=
 =?utf-8?B?Vmx5Q0hRNVRCUmMwZVhpcGQyNGZUQTQ2c0F5dmtCZ3lHZnVHdGJPV3pjZ1JG?=
 =?utf-8?B?TUFJWVp0aHBmTG1DT005bExyVElkY0puTEN4cW9nNWVBWlN5MGZjakd0NEM2?=
 =?utf-8?B?QVVTWnZ3ZDdDNUx4cEpVcGpBR2dUNDk4b2J4bFQzNURFQm1VbXJkanBQS1JE?=
 =?utf-8?B?bUw3Q3dxT1M3ZFpqam93ZHkyZ1l4SHJVVmpneUdlQ2x6UXpsempuWDZXSCsy?=
 =?utf-8?B?cUpVZ2djWDhvZm9zd3Q1RnB5cHBHZENWOWIxdjBsZ1hlWVgzclJTSkRXL3Y0?=
 =?utf-8?B?ZlhydUlOU2k3QWlVQStsSXpnZnNkVmZrOGJ2eGZUWTFKUDFPMW9VU09Gam1D?=
 =?utf-8?B?ZEhKQlZJQng5ZzlwM2hLV0ZhaDRSdFlCQTA1eVlxMEFSZUdRbjIvNyt0ZHI3?=
 =?utf-8?B?NlpLeVkyOTd3cEM1QXlYd2p2WEtMM1cycUdJbkU0OUhGdzFtb0loczVQK29u?=
 =?utf-8?B?RVA1Smk5OUpDUWpBZmFlRDJZNDFFLzdMc0tHSWpZQ2R0VHd2ZElMdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc020ab-0efb-4f0e-6fc1-08df44df929f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 19:18:33.9825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXhDMtJdDech9346yXQH+Iu2g+rQmj8bWhgYUNMJSds414iUcjmYMM9Tn0SYHjwwGtLGop4VYjEsbIWfKqxcxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB911612

On 17/11/2026 5:13, Mohsin Bashir wrote:
> From: Mohsin Bashir <hmohsin@meta.com>
> 
> In switchdev mode, mlx5 offloads police only when other actions follow
> it. TC needs no extra action for a police-only rule to work. The mlx5
> driver makes every police rule forward to the post meter table, but for
> a rate police it adds that forward only after verify_attr_actions() has
> checked the rule, so the check rejects it. The ok result of police is
> also handled as pipe. In TC, ok accepts the packet and ends the action
> list, whereas mlx5 goes on with the actions after police.
> 
> Support police as the only action of a rule. Set the forward while
> parsing police, as is already done for police with mtu, and forward
> an ok result to the end of the TC chains, as the driver does when it
> offloads the gact ok action. The upcoming selftest series also relies on
> such rules for TC offload validation.
> 
> The patch was tested on a ConnectX-7 in switchdev mode with the command
> below, and it was verified that the rule is offloaded and limits the
> matching traffic to the configured rate, using the hardware drop counter.
> 
>   tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>     ip_proto udp dst_port 5201 \
>     action police rate 100mbit burst 1m conform-exceed drop/ok
> 
> Cc: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> index 1bd1c94fb977..52295f5d644c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>  		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>  			return -EOPNOTSUPP;
>  
> -		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>  		attr->flags |= MLX5_ATTR_FLAG_MTU;
>  	} else {
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>  		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>  	}
>  
> +	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;

This makes every police that is the lact action pass verify_attr_actions()
not only ok case described.

what happens with:
"police ... conform-exceed drop/pipe"
with this not writes to FTEID_TO_REG so what happens once a packet
reaches the port action table?

also what about:
tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
    ip_proto udp dst_port 5201 \
    action police rate 100mbit burst 1m conform-exceed drop/pipe \
    action police rate 100mbit burst 1m conform-exceed drop/pipe

won't this create a loop?

> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 1d35c97aea0b..8685e41487f3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>  		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>  		break;
>  	case FLOW_ACTION_ACCEPT:
> +		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
> +		break;
>  	case FLOW_ACTION_PIPE:
>  		err = set_branch_dest_ft(flow->priv, attr);
>  		if (err)

This also changes rules where police is not the last action.
The conform result defaults to ok when it is not given.

action police rate 100mbit burst 1m conform-exceed drop \
        action mirred egress redirect dev eth2


won't with this change the conforming packets go to the tc end table
and not to the redirect dev?
The rule is still reported as offloaded and installs the redirect
which can't reached now.

Mark

