Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206813B42FE;
	Thu,  8 Oct 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791481297; cv=fail; b=JBHufAzEDUUn+rjTAcs13R6DAyjCp/9gA0XU3bKF6f52HBug3ZYPSntQm8WXTOVwq5DaEzqAFj9un7MuBoQ4e5/aDNQUEHNu7pg7us4JzP9mG7E+6P/b+TTODDabR1ZVH0cLPyX0aqpeMf8oLwLG5OAK385d3YzuPQvvZGEX5XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791481297; c=relaxed/simple;
	bh=rE+aR70s00Uqsbty4QWH+xrtihxavD7XqsIMSISk96I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L5s150lWG/4cb47TCcjlBEi5Y27RRebEGRzl227MRU++ECMoQJP64Q5iZJSoj6rAUihHhy+dLhC7V+k6qSfyy7Tqb9DKugcpNscGNHZE+Eo0czWJ5LXifiVwqErboL0i/WxFHycJySH4nxAMLkGH8ZRVYYX5NFpa2pt8KCjHh48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hJEnuEX7; arc=fail smtp.client-ip=40.107.209.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hJEnuEX7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9dmQSavdF5t6TCq4BkqXjG1Hs+in6jrpCiNkd8xVAn1cZXC/uMFgP6+mZ7MzxW5o2xetq+CDZe66QhBGNG9VFTinw41rRn5puLgMofD8SJo4X3+H64DCsmKhmca651eC2er/vRbw2K+kCiqd7HQM+A+WPbJuDQU9HzuTwVekQHC9Q1ZZ54pt9WZX8MioRAzydwJo5R0GTfl9KxCcf1iZbOGMncyaiKE9Jastc5NhQkKGFxDF+UqqtZKofLLHmun7aZxLv2vhNpYTYgNa8YIzm6iPOKyeWADrRXyYHtdKmkNEtgk0UgR5P2x3iDMRcYioksjlTy6UHfEZzXxE6rr7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itmcPnx9nlowtmo8fldKxxuVTe26ua2YQ2gle6fvWWg=;
 b=YzNpjtI4b4WzyL89tJjN34mx0Mk/hx0Sf0SS/2/bO3y/7OudnOnWThUrrtspFEtlNHtavmxX5kHP9Fkc4rjb+K3sP5hR7Ny1hNYccMyXEIazMZe4rwbVVwluZHpoYlLDquAzyAH73u6xLXFwtXrYiaTh2sW8cUUuf8UJpQ0jDlr/98m0FSys8ABP7pGRsYLNjbYK/PwfkBJDCwuZs309tfuHHuYka0ZXFCU3uVUm1I7F6L/xXxqkmlnA80GxhckTw6Jb9hMYjGg8dStfMbg9vCB4pouW84gs+AlxCrEtFCU6PWJbPFIXWqB/ZdxQEIu/DUOfWngWRiKEWHSfT50/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itmcPnx9nlowtmo8fldKxxuVTe26ua2YQ2gle6fvWWg=;
 b=hJEnuEX78BM9gZgMnr66Z0l8IKIoF+Cmtck9cAMCJgfDC36lCcVZGhCNUPSr2adUG744TBNk4mcTEDLq3OMKpmHnG7QL9aDOyvIsL11aQuVCFx2pfvY+ZqKvvzr4ue2+yJXNela5QS+SgOGTq4j+rVPSahZezj+VMey447Brv1LjU/GkPzZ/Mapgv8wH07lA1/6DFWRbPi8SUhYbA6doyk3jrCICznPEHhtuw5DToJnzlszszkE5cyYyI43g+G14rTXq505F0oGGIsVyZh1tsu5GjqeBS4nKeScTcbrH/Iu3SChy37Gfclodowy3TuZrA1dgQBp543mwSFCoa5LEmA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by PH8PR12MB6961.namprd12.prod.outlook.com (2603:10b6:510:1bc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 8 Oct
 2026 17:41:31 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Thu, 8 Oct 2026
 17:41:31 +0000
Message-ID: <3b650188-f8f1-4d73-bde7-5ca877a9dfe9@nvidia.com>
Date: Thu, 8 Oct 2026 20:41:16 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
To: Jakub Kicinski <kuba@kernel.org>, netdev-bot+sashiko@kernel.org
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, ohartoov@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
References: <20261004070246.215239-1-tariqt@nvidia.com>
 <179118614831.434549.13938965801473464638@kernel.org>
 <20261008094847.46b9b72f@kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261008094847.46b9b72f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0062.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::7) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|PH8PR12MB6961:EE_
X-MS-Office365-Filtering-Correlation-Id: a9fd02a4-88e6-4279-18b4-08df25636377
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|11063799006|10067099003|56012099006|18002099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info:
	i3OxP6BRwnSgdkKpfpsW68WX9s8Q10gEGpVh6V+YWQUCLYW3KMOAP1q8h66fpM9u7uChZV5XL2PO7XUE+LzXNbanKeZUAa1VmLkpURODRQGFFkqr4Ry9oGeYuIi4O6ZhH/Ec1dK12Rw392lTMs7lqp6vU6EqbY6E4MqVRkTycZ2zcFD+TihDST532U8JoQiKpcEdDOtG1IgvUqw692cwU+EdmHeyovJ3UfceXSM3TUOLdqIm5wzv5zNUviRLm0OrbZdzKb57dqHiKtyn9jQTSpC62UV0h9dC87ZCawSr7U54sM/QxLcQRJlsTgtqjjTfb/3q9ONJxVS4NF/6B0JF56+0kRgvQiu7ibAMDnJRQK5uGUwYVIkYc9c9TaBzug69CN40ppkD6kkqZAFccP78XZsXHNg6q5b9NYqQDpEOK5eJHKMa5e3QuVZeAIVfIUmg7BWHnf8M2BPHjN7pN0Wp/E3i+tjuLVkg3u7ilLkXv/mbR4gYjeXPf9Nrbht0LhejdAV/txxMdss40dYoWhcKjxRHT0TSXd8n8NMBP+XEK7bEKcJaXjvPxASd27J55oDr1j0himz7pyjDvom4JR/e3Hq4/gOuycN9Fy7gdt4QD9zipj8TyOB4HmD0XSMRACkNCnXdH3Pa9wwn0TmrE4g2ZZUnJie41Kxrxu3WMJrICfU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(11063799006)(10067099003)(56012099006)(18002099003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3pJbGFiL2d1R2pwWVB1WDlBMUJqRHAvN0VBZktlTGliNWwwV0I2Q08zSWox?=
 =?utf-8?B?ZGRpY0VBMFFnSzBraTdJZ1Q3UG5pZ0tRWFI4VnZGc2VYcmJ4NTBHZmZYYnlX?=
 =?utf-8?B?UkZBWm95MXFaYmZlQzBDRUhqTjFOeVFCbUF5VXpPdWpjeXZnNW4xbHRxZjNy?=
 =?utf-8?B?ckhEVHpuS1Z0aGI0MjZlaSswa2s3UmxoZkVXbVlXNUYvMmpwUmZhVkN5Mmsz?=
 =?utf-8?B?OUI5ZVBZcDFXWHkzTFZKaTQwOGpTSXJBcjZ1MDBFN3ZoSWlWb0wydkhvaEJp?=
 =?utf-8?B?WU1sZ2Q0UG5pRXk2cngxTU5hZVhEakc1eFlHMjQ4dXI4Vml2a2IrWGJ0MXRV?=
 =?utf-8?B?VUVQU05BeE1OL0EyOXZ5aFRLRUFlbWtuazFUMWNDUWtqUWo1WHE4VXN2d3Jy?=
 =?utf-8?B?VjJIc1lPUTJJT1JKam44bG81REk0V3pmcm9pRGJiU0dXclg0RThoMks0bW1U?=
 =?utf-8?B?S3ltRlBlMzlkTG9IeStRTWRWcHlEcXVqUWhFNlJocEs1NFRkZlNYZG05clNX?=
 =?utf-8?B?N3JsR003cFJadWkyamZPdnI5OU1PUDJ1TmoxSU5sSUZZajlrbFRLTStkWUoy?=
 =?utf-8?B?WFlIQ0E3UzVjZ3pwQXdMZVhaR2tNaTFTZDhhdWVmYUhXeVpJZytsL2RYeTd6?=
 =?utf-8?B?TytUSzBoV0d3RGJOVDVMNy9PVllveEVvV0ZndHlXM2FVRlB2SEtsYkk4SjI2?=
 =?utf-8?B?Q3YyQXJRSVNDT1RkalNXQXRuYWlCMFJHdnFUcnlNUXVYZ1ZjMXpHTFdOTTFT?=
 =?utf-8?B?eGlDbnJyeHRhbFJ6U2lXUmlZWmpIZ0FDV05NNU82alBUMDJoalNxeFNFQ3R2?=
 =?utf-8?B?Z0VkSjY2TTdiUmtPZXVaOXpwck0wTVZoUkg1UFdkaTA0RVJ4eVJoNEhSTGpz?=
 =?utf-8?B?Vkh1aVArK1BvUzlsY0lwSjZacGthMi9sUHJUczRZOWtKY0FmM2JObGZwV0o0?=
 =?utf-8?B?Rytodk1YWjc0WFlMaDBLcnVianpTRXBOeWFnaVZlcTI1ZWtPOXNDU0dkUEdB?=
 =?utf-8?B?TE5pRzQ3Y1JPL3ZjekI3Qk8vNFl4Nm9tK1dpMHpJQ2JPVVVvdCszRDI5VWpv?=
 =?utf-8?B?NG9NOUdJYVZGVWUwc1M0Uys4ZXFqMkppM09FdEhOY1RlOWVHNjdxOGhNUEQy?=
 =?utf-8?B?ZkFtdXlWTHowSi9TbTdOUmw1NDBjeTFhV3lyanhvMngzc205ZnJxQnBudklw?=
 =?utf-8?B?QUhXYllDZ0w5dWlYaEZTYUozQVkrMk1vYmhhWFgzU3RzcVVHd0w1RGZNczhN?=
 =?utf-8?B?K2ZscTJVM1hIYmdFZWZmTGJmdTY4WU9JUExOYW1aelNFRytMQWVNbUpFVEFY?=
 =?utf-8?B?SjI3MUpPU3FUbCtjMFNpNVhyaWd0OWNMMGtkR3l6Qk1qdjBUbFBoRElaRHJB?=
 =?utf-8?B?aUhsZXQyNkx0d09WNlpWWkhYNUlwZjJtVWtBUnNSbklaQ1ZSOEVJQng3VVFD?=
 =?utf-8?B?RUo4M21NcjQ3M0FzRHEwR1lTM1FveVBwZHpPNjRZaUs2aXFGUWFrNXRhNVpN?=
 =?utf-8?B?WHVkeFpXM0xLRk42QU0za2wvVXZBa0t5NHp3ZmFCcGVYdHkwZHJiVVV6SjFi?=
 =?utf-8?B?NS9TLzRiRGhWaGo5WUtVTVV3RDJyT2RqbGVOaGdLSUc0SzA1eWl6UldaenZ5?=
 =?utf-8?B?TGduSDZUL2x5Z0VpeENLQVNYTTNEVm03WGg5Wk1HTXJKT2NuVlczS0RLYlox?=
 =?utf-8?B?SVVHSGkxV1NVRXhFVEM4V1o1b3dzU25rNW5pV3JkS3dNZ05DcU1NYW54Q0lU?=
 =?utf-8?B?ZHVjWlNMTkN3bFhQdERqMkE2SUNPN0Y1NjUvS2xKa1Z3TkptTkZnbVd3MThm?=
 =?utf-8?B?OVhibDAwQ0NobHpRQ005aEJvaHBFZkRsTEQyNitrWExIRGxhc3JqdlUvZmdj?=
 =?utf-8?B?U0JNRFBSWjdscnRydk1DNVhBbXJrVWgvRUdmU0ZQOXZpc2pONmY5ME41ZThN?=
 =?utf-8?B?ODlGcFI1bDlTbkF3ZUdCVnNKM1lLQ2ptaHYxbGRmdkNQc0ZqLzJ6S0c3TWM2?=
 =?utf-8?B?UVh4Ly85aFV6Y3A5cTJuNmp4MklUK1M4MXZCYkJyNEk3aEw1NWwybHNkVmR4?=
 =?utf-8?B?NEY1RzFJUWZ1d3JtdHZLaUV5MmxZUUpsSmtlTWp1Rll4NkZFMTdqa0tXNXlV?=
 =?utf-8?B?WTRvZGlyWmF0aTF1bnljb2xsaFdvM3lhMWt3U3FCUDV6VmVwaXNQMzU2Y2Ux?=
 =?utf-8?B?Nk9CZlg3WlZmNUVxWklZdTZtaXZraWNLMFY2blNuSlVIcUZ2QzhUWVphVGZ4?=
 =?utf-8?B?am1RSjBjY2dYYVMvWTZBVlQ2Q0dIVFloTldWdkVFSkRTL3ZQOENVMFdOSFNL?=
 =?utf-8?B?cjduZGNuVWh0L3dOTURyMHlxakJXbWNONk5iWURlK1pyWGl2TSt0UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9fd02a4-88e6-4279-18b4-08df25636377
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 17:41:31.5082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CiTYwzIaeOk84TCoOhSDStgrQN50iC2pn+D8GA390Z0LGmGE0DWXkqjgZE8iwsQJI1aQNgWEZ3nw6Itb4/1D5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6961



On 08/10/2026 19:48, Jakub Kicinski wrote:
> On Mon, 05 Oct 2026 07:42:28 +0000 netdev-bot+sashiko@kernel.org wrote:
>> - [Medium] This patch breaks the query-failure fallback added by commit
>>    ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport…
>> - [Medium] The commit message does not match the code change.
> 
> Can y'all comment please? It's been 3 days

Hi Jakub,

We received 3 different emails from Sashiko bots for this single patch.
Or replied to a similar issue in another Sashiko mail, but now I see it 
wasn't the netdev one.

Anyway, sorry for the delay.

The fallback readers in mlx5_modify_vport_admin_state() and 
mlx5_esw_adj_vport_modify() were removed by 86b785b18f8f ("Revert 
\"net/mlx5: E-Switch, preserve max tx speed on vport state 
modification\""), which is now in net, so clearing the cache no longer 
affects them.

The second point is fair. The issue is theoretical (found by the AI 
review of an earlier series, not observed), and the commit message does 
not describe the actual change, which is to stop replaying values FW 
already accepted.

pw-bot: cr
