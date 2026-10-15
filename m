Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FF447DFB6;
	Thu, 15 Oct 2026 09:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056524; cv=fail; b=QOyA7Xe6enpGH7f33QRKnMmqlJ6LGRRpm3+Nn1vBVMRh555qKK3lEzjLLoHBQI6GXLPaBeoeGRiDxHLgo3xuLwJzh08FGyAM3m1tb/InqHhXeL/7qtnceENTdBOfWoZRa3bymeKGcssbKjBVUCQIggtXsfBHBC+/aUI9/D13p8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056524; c=relaxed/simple;
	bh=kXcnTPQQU29vZDxiEUSJ09T4uuzACFnNAGFivycMbXI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JhFB2Tw7jNNYt7ckeq7w7EUH6DfiyKiS8kN1TH7NNOJe3fI3pC7wetGZIY6eUVN+ZW+VOma8M6ZMXm5Td7G6DO9VfDxOotMD+JpA8tH0JamOW7I+emX+vfEo9cKi3qLNb+Oc0nMb+0AEKV0T3ElPJ4bpr6ky8PIlQYj/gOcflO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O5OyASyQ; arc=fail smtp.client-ip=40.107.209.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O5OyASyQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jCoSfCU+dm6NdqJLv7dFVozwSc9nNXLRLRxlS7Fo69j1FpTlWFUpscm+QNpXb7LYKESSsWWQ9g0ga3WDKxKXsC8qLN73ugERcwUsUziGoT1KtsbL6BKIObaxMnAGw/JG5OeK0VEnh4xqKh9JbqJxbDztB3Scs3bFMxOojsGaqEHAZoYZDWkytTBzyK+I+Flsc7dgPcVnELLD8xcfwJIktM7LUM01o0TktJXwcr9gPmxhcMJHAJQC6gMyKZ92hgk1MX4msXZX7/ArF4hREgftXP4HcyxXlOazY5V8KoLfC7koxr/OtKrARJt4VpSoI/S/PKG2z1Hbtf7vWZgifxTtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoJQUAiVjTIUyeIbsdUHZ7Hgs8RTNM2CCyk0qG7KoGo=;
 b=Thq5G9ntcvQ9o1IrsfgMnbcRl0x8n8BAyyfTS968WLSUjV8i6aRXZb6xUQ1+C5hqgTKpzIIV3oRYmdLAu7p/Zid7nRx6LdVaYCOSbi89aySWFRta5sl528/YGBTyJ5M22gVkvztHgaxWgh1d/V2RQCmELDp1lMMgsuJ0DOf7alVxGoSwp4ZUwiq70kkiP+YRZOHm7hawhNDUAZUvobyOC9bOpPn4WUz/V+LSDbZ91pgftLx1vvO6TIEa8+3bJTD15UQOp0VehTnvN1McS33jMKiHaQMx/XFvbMGcPQ7nT0OBK9ZeOy69ghbpX9HR8qLzOY5n0p8VNMR+/w15cy6UGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoJQUAiVjTIUyeIbsdUHZ7Hgs8RTNM2CCyk0qG7KoGo=;
 b=O5OyASyQpLF0c/JQh1E3+XYphdu2WVAaRlYTrqgq6VRZAkrJMVoTbumwZs6LBGWOJrYBttvg2Gus7tJTUXb4NgUroYDplSUK32i5KqkOhlM57fRn4j2llGNcFEd+4ynsT2G+w3LPMhnKvlbOd/VchS610gWL2eHeJBHSEQc2ZSB5DBgYNCck3ilywSfGN1gyl78/BS+hggKjhILwrtFMS+XpQ1058Xplf4II78oNYVRBgqPxETRzE/fhKCoQ1QAm0qu75IpHszGLF/309q5Rm8D9JzhpzLyUQ6vrBAXxVoIHexcOwHrxqy8NuoDEQSBBoBoh2kgDEgFYk5RdJneQ4Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by PH0PR12MB7815.namprd12.prod.outlook.com (2603:10b6:510:28a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Thu, 15 Oct
 2026 09:28:35 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 09:28:35 +0000
Message-ID: <42a510da-caf1-4847-b938-1cebeacd3880@nvidia.com>
Date: Thu, 15 Oct 2026 12:28:28 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset
 scaling
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>,
 Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
 Gal Pressman <gal@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
 Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
References: <20261015074035.1092340-1-tariqt@nvidia.com>
 <179205022689.408196.2502809558369367458@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179205022689.408196.2502809558369367458@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0016.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::18) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|PH0PR12MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: f88df33d-b465-46e8-a178-08df2a9eafd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|6133799003|22082099003|18002099003|261009223027099003|10067099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	E/LYKvWz1P3FTrnthmUIiSldkLODmdEiK/37k9zjaHomWWTo71oDFO49/Ac2IOyuo78Wvqshuvr5UNj+kDxm14OlBf64bSqmU++yFibgUJ1c7zwqyB7Ns7bzCdNbovKJBRCUoUjmwSBJwV7OPTJbd+Q5Gw0rP7o8axnkV2s+NbUW0IQL357Yqkd+cOVOAX6XoqFVXqOB861WrO4q4T1u6JOW3U7wf5Ejhl40H8ityNXVF5VBUBS89EpcHs70/f2dSa6zXx+iIgqBXTareT0eCRWG7jaeyHan8LD5ijlGvD4iZu8iENxczmB6uHKuTq8VCmYj02d6bKeJ0Ebp/yNqdc5ZaF/foN3ETHeJ+8QA5wj37mW7yQQ2NbD1oVTJoF4vERHZzBEsIw2Z3AXEv1DqgpFlEA2VPXNUFiDdW2LHhcsv/0YJQu+sd1ddAGDoMT1ULsEo3gLv5pvJrW7cBL2y17N6fN8baeCtO98FAxqi9y5Jl89KHvxxLfIk1bx28xU7UJH0UcRdg8ddOEPa9InuvraJwQXY3nI1V2wH1AtZIOhpXMEf/vTfE9a+E8EzBi3sJXoMOpKpWoh+VuV52Qai1PlZNXHQvGJ2uV8h+hHTOXpZ3b3R765dxZE3xMlZGeiED9Ul91V+xp/xlAShH8apIWmaMLa4tKhqRZR5Rc6dROs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(6133799003)(22082099003)(18002099003)(261009223027099003)(10067099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlljVE0zQjFSVEhFTXM0TG16QlBYZHVxVFNnd0hqMDB4eHlGc0pWMFFqUnZK?=
 =?utf-8?B?blRCMHMxTTVETUlEcWVXc0NFQVZueUx2NlU4elJKVCtnS0dyS1BjeWRBZHhy?=
 =?utf-8?B?VVZ0bTFuT0NIeVJ2a1R1RURVU005YWNZTDdSZ3JpWGJqNG1QZ01xUE1OWDE2?=
 =?utf-8?B?L3dHN1k5M1NVNDJNNTV0cHlQODlwMWx1cCtrTWROOXBjdjRTVVRwTnZnc2JV?=
 =?utf-8?B?dmY4L2Mrbyt0VjNDcGM5Y1JIaG9leFlXTlBTMWFkVmxMaWR6bWg4bVYrL0xH?=
 =?utf-8?B?b25LNXVKOVgzUGdwR2xOUVlscmxITUh0MmJCMU4xOHFpTWY1bHVwbWVDR1Iy?=
 =?utf-8?B?MGlWbENRSFNmMWU5ZTlWQmdoNlNLcEY1ekpTV1EyeENxT3doZW5rQmVSa0Z0?=
 =?utf-8?B?QzRxVktzZWk4azUrUy9sZDhmdGtGQzFRSjdGRkRkYlNBbEFZVHN3VzZ6YjVU?=
 =?utf-8?B?clBRSlE1TnFpdUdrZjZBQkYzOVFCRHlLZ05NY1JJb1hDUzQ0RjE3UDFtNEtQ?=
 =?utf-8?B?cm5TYmRLZ0llb3lnTGQ0WUZ0RVV3anJFNXh6eE85clB6N3JDZlprd3VBVEM2?=
 =?utf-8?B?RTFlL0NjMHZQa2FjbEtvckd3Vk1RN3BaZGxPUUE3VzZPbUxCdTZ4TkJSMEdI?=
 =?utf-8?B?eUdPY2N1Tm51Q0lpd0xibzBJRjRGVU1adVd5VDd4S2dpRXh1cFhHMTEzSDRR?=
 =?utf-8?B?bEIzb2VRQnBnRXdGWFZKcTFRSDAzZWlhMy9kcnA2Z3V6RVArMjRCa1JDZFpZ?=
 =?utf-8?B?WGUzNEZ0UXJoYnEwNFVSK1RYU2pZZzZGRGh1aUQzejcvd3ZtN1FkUE9lWEFu?=
 =?utf-8?B?QVNqaWVLRTdwVlh3d0hWT0kwOTUzdytZSGl1QUdML1NZOFAzN3lvekxMYy9m?=
 =?utf-8?B?bHBKMmJMdEhtdDF0N0kwQk5iUTV4NmVGOU5ZNHdEeXpFNk9VZ0dTb3pxNFUy?=
 =?utf-8?B?UVRDeXpwdjkzUFFVbHVmMmVXY0N5aEpmTVNqT2RCMUtXeEQ5NHhUWG1qay9H?=
 =?utf-8?B?Y3RLMVVobWpWeUI3NzAyZmxwRUJRQmw1SFl5NWMxZUdVK3ZGS2FmR1YzcFFH?=
 =?utf-8?B?amN0dHFVWnlzeFRFL0U5U2FvZERaWitCS2tOUWxlUDFmQ3R4ZnpVd2V1andI?=
 =?utf-8?B?c2tzT0RQM29PUmVpbVZxUVo2eEwxZ09PdDRhdVZROUhWT0c1TUJNMVd6Zm1s?=
 =?utf-8?B?T0FRdXlUY0lwMTQrYWFJM3ZPWEdlajE3bk1JVURaMkJReXUxZDh6cGFaZGJT?=
 =?utf-8?B?dHNudE91UElkbk1jbFZ5bkw0L1VlRGcwcWJuS0pqeHYxUXY4Z0ZEY0JIS2ll?=
 =?utf-8?B?UktDVUJNcWFDVisrc1piVnJpVlF5VHdIeHFaVVUwV0pxSThha25waDJWakZ5?=
 =?utf-8?B?NGdoMWFRK2tqL3BPaUROc3NqbFd1Nk5vNHVzdGw1alpLVXQ5cTRqeTBmYWhy?=
 =?utf-8?B?UCt5T3lJV1ZXUm10d0xEZTZBVENUcWdoeGhLa2U4TmJ3b1NvaGZzOU5YSFB4?=
 =?utf-8?B?ZzVpTTNYdGNyYk43ZFd2UnFiakl2SDJsdEtxUnNjcFRZZ1V4b1dhT2FDV0FV?=
 =?utf-8?B?akpBVS8xSXNsMTdlUXFPS0FCMjk1ZG9FL3FvU2l0ME50d2oxREUwZHJHVm5z?=
 =?utf-8?B?dkY4bGQ0MnZnSnVoSXNuelNMR0hJUDBQMi95M21UcVZORkxZZlo5ODd4K1BH?=
 =?utf-8?B?bVFQcXpGU0lJd3RPWllBVzA1R0t1MmY3eHoyQjlZVEtxMGdzNW04T3Yxdm9q?=
 =?utf-8?B?cWc0UXJFWFdwVFdIRGc2VjdGdkZuRGlISnRlelFzU1dkdE5venFTZEp5MUdC?=
 =?utf-8?B?NkNVb1RsWkdoNzU3eDJoVzRta2hqWFQrakNDL2w1WEFqcEczZWVzZWRXYitU?=
 =?utf-8?B?a0w5Vm0wU0NSb0VSeVN2RUZXSGtaSElIL1RRc3RrZ2w3U0cvWlpBV1E3OVZI?=
 =?utf-8?B?U2Y5UytUQ1E5UWRicjZYNHhxaW16RlZEKy9FZEsvMU56NTlhdFhjN1BKVWZk?=
 =?utf-8?B?M1AzL0xLcnc0dUlJM2R0bWlIWUpOZ0hPL2pDQVBLTk5tejIybWNnQ2h2dWsz?=
 =?utf-8?B?SkY1Nm1CUzdoRnpBUUJpUzNibDhieldwQ2gvdWFwSUNOQk9sdU5GemsxUTAw?=
 =?utf-8?B?Z0lCNkNYblVqSGtFN3hsYWFEMUFQUDVqNXNTYk0yTTMvYmhja3ZwOURJRURW?=
 =?utf-8?B?QmtSZXc5aXN0L3E3dE9lczJ2dlJlQkE5bWhWUEltWU5rWEpBMktiV1ZOOER1?=
 =?utf-8?B?b0hFNE51bUdCREVwZFNhYjZXdFhPejk5V2c4QTQyTENmZlNCTzA0Q1VIRmhC?=
 =?utf-8?B?TkhuNHdnR21pUkptbXJXSWx4S01oQ2RlNEdod3lYUmVXZk1PVXRxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f88df33d-b465-46e8-a178-08df2a9eafd9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 09:28:35.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umAPWL/Xk5S8ugZUVALa/cM6XLT36IbDyTwlAZ+XUHBIG2AXq9y3MtquCpQOL/BXTv42mxy6qRWXGNO54fQKXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7815


On 15/10/2026 10:43, netdev-bot+sinfo@kernel.org wrote:
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
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
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

The issue was found while testing the latest mlx5 driver on an older
kernel that does not support
DPLL_A_PIN_FRACTIONAL_FREQUENCY_OFFSET_PPT.

There was no crash or kernel warning. Just that the legacy
DPLL_A_PIN_FRACTIONAL_FREQUENCY_OFFSET attribute reported an incorrect
FFO value.

The mlx5 firmware reports frequency_diff in ppt. Although the legacy
attribute is documented in ppm, our userspace application has always
expected the value exported by mlx5 to be in ppt.

On newer kernels, the driver multiplies the firmware value by 1,000,000
to account for the corresponding division performed by the DPLL core
when exporting the legacy attribute. Older kernels do not perform this
division and expose the scaled value directly, resulting in an FFO value
1,000,000 times too large.

The change was tested on CX6Dx, and the reported FFO value was verified
through both the DPLL netlink interface and our userspace application.

Thanks,
Carolina

