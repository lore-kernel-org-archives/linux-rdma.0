Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F22499F18;
	Thu, 15 Oct 2026 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792057084; cv=fail; b=iPYJ8nsavjfk6pN2GIrro1zuOa8XOvkz4BgTt4dkdvceaKFToFrfwrQGQqYu39FCHxB9I90xUN+jAZJaGT9+tC1CujKetJ/G+ekZ1fILCkGJgUBVnqq8MeHRvo6zQvsujIQZ7lXwXVc5PELxWWu+tZActEFjNoJHmgUBpzGK46Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792057084; c=relaxed/simple;
	bh=yWUTkrB+n3Wve+BB5F1izAZ7FdQ6YX03sf4mxz3Qkc8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lLfB/FC/0yVZQfHZlQ8gVq47LxyKLJvagaSbKXicrRYaxildn2RIjQ0XEFxix9x3xvwo4C2Xv5gvq1hlqw7/WKd6nVQCal0LVAKLfn4felVos/pPjBesKYV30Af5mkffN5SGbF6ppqjvev+JaZsFooqqmNwmhS0bU2E05kL5UdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DzfNLlct; arc=fail smtp.client-ip=40.93.196.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DzfNLlct"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kVBbLGGkeN5PD9rTJfoiYsWEKFlRwhLp3y6LxMY9DKipm62Sm+GrpWhWr0dnWlXREXJuNNd5qudBtiI3CpGODT7oIuNgu4H4M2I6T9OCDYkiGn9gtAIjMTS1MHlqWenSgvZTjaR3Vnbsc5VDNNBk1j6FNEk/NzkJ/vi9PUpHmMhEIFByxDBdGPofE8PMqiOTp2+DejJgUomqvSOtxwa6Mrc88FiDSTvLOXGOuzkRVMbzRnA2LasiOq5hDJfIMy6GkY5+Vxk+2nBv7aAJQI7fhPolnyieWVBpx5ZArLroEB3ibRbmXPCEjfxWqTcC2v2d5+Z3OWVFQ/Opg0SG4jGlHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADQm2zvZsxwGeRfw78pCpBq2uj0GR5HvcAPC3tb3KJ0=;
 b=Sj8DBXi/8WVRIAzunQD0SLoDjMqPKoKCZYMMjo+J/KGzkgQ19so+H+pFNcSN10HxVY/USyVlN/LxZTOPXurqecUvuH2QuEPumtXBNz5CbH2xwOowBTeHktnOGjOKDtShthDDpEgAIMA0ZQkwzoFIPRBGP5DpBQ+YKETkvvA/xpJTtsyRFEPi2qAJxhdMXGUnj3gZF13FGcHDHgUqQlMC6gvrrvdtteRMNnkSQeojKcc0E7bbEm2e0Qbzp8qjWAoQj8hfuiYbMy0deGOx2ayNb4nb2KWwc0h1t69EzPSjbcoxgd0nXEo8l4qz2zLliQgld/eeUafTU+2YaehRLGLETQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADQm2zvZsxwGeRfw78pCpBq2uj0GR5HvcAPC3tb3KJ0=;
 b=DzfNLlctmolYL8AdVwCVDZVIOdgP5zLw9L42AoBdwD8HuycR73MZPiTGs657+lVMPrN1xwjW4U7bZAue/JhPwwzW5b7KuY3Zc7oNfTY4hoHRip1ab1Cu0otzkGPmvvojLvZ/ypxQWezEWSBjedpJQPC7fXp5bpdznVECaKdrmT2FT/v64XwryLFC3sBvltHEPdkvi8hBJ5U3Su/cMksM4LZqg0TwXhd5MlF0SxuJ+YzTBeVxznLvLfDkTRKdQ0h1ocsQQNt7uf/Jqkkno8AJgAto98qJl6Xf1ltmLe6lhlO6W4CQB9WCDVUnv/npKId1yXZ8eKH9X1zeljRo3oAX4Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by SN7PR12MB7936.namprd12.prod.outlook.com (2603:10b6:806:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 09:37:54 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 09:37:54 +0000
Message-ID: <842aba00-2293-4fd8-bc17-dc109b16da56@nvidia.com>
Date: Thu, 15 Oct 2026 12:37:48 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery warn
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Alex Lazar <alazar@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shahar Shitrit <shshitrit@nvidia.com>
References: <20261015080218.1102172-1-tariqt@nvidia.com>
 <179205178078.408196.12399315538524843906@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179205178078.408196.12399315538524843906@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0027.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::11) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|SN7PR12MB7936:EE_
X-MS-Office365-Filtering-Correlation-Id: a73115e3-4094-4af0-6ff1-08df2a9ffd00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|261009223027099003|10067099003|11063799006|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BnhCW2Qu99LxGLbAvDWKzukLK4EY+RJiUd0zILPrYdMkAiUhR9+ovGgEghr3z/eRKt9fie00f9FuEx3u3Yur+CSsNB0yINHwtdtSCz7iRjPhKWetkL3ygmTOPHdXvljNY2h+cY+1Tz1a8LcLrspow7OuWZ05v7zUVsVFnexUURclt2PdqYO1KpoPCtr+yDv2+NxP2NRjmKROWQ0kPRxToVy5Nvy8x9egQE7Sz4Oax7UneWvjMsjdHa3pholi5w4YCH4X0Zwf7wmM4WBmwT1J2fAi4SH9p91De8HsItq3Jw8Gc4CP5pCdhNgPgKmxZzVKje3lTycCbbGDj0YUg7lM4p9jCR9OkXiLaBm4xZr1pTvmmYgsTBx0jUVpgsnQEdT/oCiYJ+39Vkg5Kmc9ai2PXBkQFQuyrJ+Z+8yQTv91FBrQCWgGyo81fCsP8lbTxWG1tnXiyOYOQ5e94/krUVlxuefYDH1Z4NXI47lQsSFa/8nYr/YxvQCstuYkEm1l6fRQseXSjkhXhVPW8/o2rKIwk91jsVT+NQXoq8zj9PUXDXwTDtydRNsSzxo9l5D0CamOEte+OKQGfQgKrgve2WaC72Dfuc+pRECOIxQwmt9GYV6fUxe02ng5mRP/ARbyu/hMTl5fXVCYSLJNVzmfYtF5XEyiqlsDFwfYWpxqB3b0vkw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(261009223027099003)(10067099003)(11063799006)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVpXSFFVUWJIVzZXdTVnTitDdkNVdEtiZEVWYXpzL2lsanMrL0xBejdlei83?=
 =?utf-8?B?blZqSjhHYlQzWHNRT0twZkhpUUk0SVN6Qmh2MmNzWjNyT1ZORGQxZ01uWENV?=
 =?utf-8?B?aERKYXlQeU9QbG51ZkNzczNFbW1xZk0wcWVXT295ZzVLc3VRZDdkeHcva0F5?=
 =?utf-8?B?VDVDVyt6MUJsaTFtVkxWQUJtbTU5dlNYZlJpV1c5V2JHb1Bva3VTUEM5WHF0?=
 =?utf-8?B?OW5ZcWlQbW90aGJHenZHUzBlSHI3YzFVbDUvbnNucGNRbThydjZUQjJVSEEy?=
 =?utf-8?B?bFlwUEtGK0x4c1JSdllENFhxVzg3Wi94MUlxSmc1M2RqUThsNWZDZHRCYU5i?=
 =?utf-8?B?UVorNDZxdUwwSHZMc2xwTmY4blRGVEYzU3FHK1c2KzdQZjJ5MzVzbk1odnlB?=
 =?utf-8?B?NFFZYzI5NmpkZGRiNHlKVXNDTCs4Q2FqakdiMlhqZ3haRTltRkpHNEtTM0hR?=
 =?utf-8?B?d3lDaHFOMmttZWVGc2crZGpuN1VETklHeWs5aXhyS3NGZHVaWUxqbUVMVS9V?=
 =?utf-8?B?NHFQZDd4a1k3NnNiMnNZVVhpSkk2UUZnOWIzTVNwN2k4MThPM0V4UDYyUXdH?=
 =?utf-8?B?OGhVRjc1TXlVMTBSbzI0L0wvSWhXN3BtdXFXZTNlT2N6cG1Ed05JNXJCSXl4?=
 =?utf-8?B?UFBWa3U5RjlOM0M2SnZ5R1NjRGJhRXBTUlpGRFk5NHBwTk1tek1nRWdFYjV4?=
 =?utf-8?B?dEVYQXFoKzlDQ0RxS2VvSTFSK3ZXSnNPSjliS1FVck5SZjUzMDVvRUN3SXZJ?=
 =?utf-8?B?SElzcDdkNDk0R2xNZ2xUL0FHb3UrMFRDK1gydkdtZ2M0cVZKWkp6Tzc5S1VH?=
 =?utf-8?B?MkxxYTllbk1qMW1lK2RZSDlUdnBqTDcwU3FpYWthc2tBNWVxVVhwcmMxWXBp?=
 =?utf-8?B?dWxTc2oySXVhRVU4OWZiQS9zTUdpeWJiZHF4VFlnMlFnd3gxT2lBR29GT1N3?=
 =?utf-8?B?RndTSVBJcjJ2bDZBOU1PcmhPMVpOV3V2U0FPSytUQWhtL1FjTk5jbFJMQzBw?=
 =?utf-8?B?S2xnZThhNkM5MFE3QU5hN2N3dDB2V055dVF4ZmVjNElJallBaExmS2ZZZUpn?=
 =?utf-8?B?R3NrUzBnN3N2UWNkNkpMTmcvVDVZRXBNeWVsd0lWNDYvSmtESDFnV01GZFVZ?=
 =?utf-8?B?WnJxYWU3TTdEdlNZbGs2Q056bGxBUTNYYTJ1SVRnTHhKS1FYWkpNSmp2bXdZ?=
 =?utf-8?B?QTBIZEJOWHFXaHFpUzlzY0c5R3hCZDJyOEdQQ1lRTG1jWldQbE5qUVRQdFoz?=
 =?utf-8?B?YXN5Sm9vZ3ZYV0t2dnM1WDQ0dnhmZ0NmRXRRWWJFN3hFSVhwRVRNSEl6eW1u?=
 =?utf-8?B?eWEzUTkvQ2JjODY3SldMYVJuTVF2eHArSjNVSTljUzlHdDBTeHFKNmdEVnpx?=
 =?utf-8?B?VG1JemlYR2twUDdTYmEzeXhkN0lnTEo1QTlGeHpxeU1vQ1RlWHdXMERtdUVx?=
 =?utf-8?B?bTNPS3ZpSlR5QnBIVUhWWTJRTGZqRlE5K05OQUptYkRTUTV5OW8xY0VGWTEw?=
 =?utf-8?B?TFc1Rmc5djRYVnRaMmF2aHpjMWdyZ3cyMUxLVGtqUTFpZ25aSExlZHFBLzNt?=
 =?utf-8?B?blJUaXZiNWRmUWFlZDMwZFFyakE3NTVLRElYdXlkNGQ4d1R1MDB5Um1TWElZ?=
 =?utf-8?B?SStlUTZYZWMrTXVNYXd3R3RhYmxXN3ZDc0hqUE01eU5PcElRdGxaM0FDWGFl?=
 =?utf-8?B?OWJPcHlOdEJrTHovUWZGNURMQ2R0a0hCTHkyRzM0c0FpQWdPZE1BREhheWVT?=
 =?utf-8?B?YTJOamptMmJLZGFmMndvUDVaMS94Ukd3VkZsQmJiK1ZtUnkwQ0N5dGk4bmhj?=
 =?utf-8?B?WEFmeDE1Szh3OExZQy9GUE1sWjZzbmNZNFhTWkhHZGpZV0JvTUR3d1hJWWZm?=
 =?utf-8?B?ZnNhNjBnUXZCTkRuUVJucEttSGpjTVN3alBFblBHMDhlNDAyTzhsdDlLVWZH?=
 =?utf-8?B?N0FCMnF3aWNXQ0E0RXU3US9QdmJ0VmxlTlk0MlZxNWlseVhoOWxDL0tHOUkx?=
 =?utf-8?B?U2lLOWNLSFBiUU1ieDdML0RzRUxnYUxJMVB6Qk1VK2NrYWdkWGN6dEhiYVRQ?=
 =?utf-8?B?aXcwUHpVRSt0UHZydlR4UUFPWFBOSmRjTWFXUGhvNk5helBQUmRiM3ZMenhL?=
 =?utf-8?B?dzdnVWt5Z201NjhDUkFYUVAwSkFSZmxUM0UzZkY1RWdrcUZxemJldkpmb1R6?=
 =?utf-8?B?cFUxWHZOY2c4dnFGMU5nRVY2R1pqNjcxbERDcDBIVFRRcWFxajFYaW9WeTJz?=
 =?utf-8?B?NHAzZkoxWnV4ams5aU5nQnkyYUUvYWtDcjArOXRWcVJ0cHpxTE5Zamg0dnNm?=
 =?utf-8?B?aDRqVCtWUVhXZFF3KzRpcEtDbWhHRnZhWFJpNUFsN1BzY1R6RGdhUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73115e3-4094-4af0-6ff1-08df2a9ffd00
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 09:37:54.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57a8N/i8mypXq0Nj6ZGCbF0ZmXc+CKTA1hvmhXmKvL9y+fyyDN1+20ZrRkFbFceqQYd/OoYdlpG4YRPLgoZ8Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7936


On 15/10/2026 11:09, netdev-bot+sinfo@kernel.org wrote:
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
>
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.


Hi,

The issue was observed during our internal regression testing.

The kernel reported:

BUG: unable to handle page fault for address: 0000000000002ea8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 1a9bfc067 P4D 1a9bfc067 PUD 1a9bfd067 PMD 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE
RIP: 0010:mlx5e_skb_cb_hwtstamp_handler+0x10c/0x140 [mlx5_core]
RAX: 0000000000000000
CR2: 0000000000002ea8
Call Trace:
   mlx5e_ptp_poll_ts_cq+0x228/0x5b0 [mlx5_core]
   mlx5e_ptp_napi_poll+0xad/0x380 [mlx5_core]
   ? mlx5e_napi_poll+0x750/0x7e0 [mlx5_core]
   __napi_poll+0x30/0x200
   net_rx_action+0x181/0x2e0
   handle_softirqs+0xdb/0x340
   __irq_exit_rcu+0xd9/0x100
   irq_exit_rcu+0xe/0x20
   common_interrupt+0xa4/0xb0

So far, the issue has only been observed during our regression testing,
and I am still working on reproducing it reliably.

Thanks,
Carolina

