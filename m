Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795045212;
	b=S6zmmqFcYWU8hOPR6rrpO7a/i1cgReDKPJyoZfNlnWpYbV8C8wO8vnAwcuLFK6hl9dtW
	 HgNgX/1icoZiHVnsm7dPD8mzOURhuSdPtMstvzalz4pgcssfsSlo8DE+dZ9C47EUHKx58
	 8A/rOdlwiNXPKWELqFOY3+TgOTl3YqdVdDAc7Zvyr2codjogjgJmrPCR/u305vyrgpqBh
	 KxuexxdE+WvG//bUC3susqFd7P4anYJQFMlogmNRv0PEXVNdPQYnx2kq7ICre8rwoQGbX
	 PR0ZGWflT6ZTmzZFC9NmbKNY9rui+q5jqBSVCaM29XKpwKmIoilFBLa6JGePX2mrN4A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045212;
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
	bh=3tyBNApHLoAdWOa/rfVdWanww9DKhf5i7ZxLkRNls60=;
	b=i5UNAQj58cAt/J+2aMVCTAioIVUb930RYHGsRKrst1GCzWAz9T53EybiBdJR8hfcN9tG
	 JPtvqy3u9WUHg4/iIDCqzwUvxT/LaWoiwmWlt8cmURQC64dB1HQPWJ8lMN7leqLZYJNN7
	 +l0sgUyJGCzAMY06nABfYEnoY9pDFu6jaGAJa/XkPz2bZJWAowlz5gWuLpmZAs+h6Z3bN
	 8HgGH0YePpEipm2TmZMutTGHsf0AqY1oIhWuNsy+ASrht5masubpn3p0HbPWL01XTWHsC
	 b+gjcGQwQA+KSFLDiM2xXfloXv2oBuud35RG0yDWweBlq1/PIhkFcsF4Ze5SNjcc0XA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jYTNq1os;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.50
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011050.outbound.protection.outlook.com [52.101.62.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2685606A32A;
	Wed, 18 Nov 2026 23:40:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2685606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jYTNq1os
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtOuTlXd+oRJEK/WsB7qBTAUql6EOz6ZHD9LOBOdrbI7LxLflTPqgNYhllvz0csK1XbDjsO8XW8njXFykZP0tHKLhsGwmQlhnvGmA5hWH8/O8+5e74kGFCvy7Vm0RAJEq/seYR2OYYNNXxk5Sm9ivZWgQ1KmXhQcSbO4mcqbLJK3mYrPfRXsIOJjg2ovNkq9KtQwyg4tv8IdIoXdJZSpBAJCQwJABB/cjeC8js58n8/mMAVigyxmacz9MTgYWOy0RJjNyKDJuX8ZYHx797lHwGssQetVbh+qZ/DOtAKJ7yNEOZHsHOXM+kAAVDKCUxr8EMpMyehOubTaR0yEqHyrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tyBNApHLoAdWOa/rfVdWanww9DKhf5i7ZxLkRNls60=;
 b=xyIVtZKuVUVoNX8mEWTJjbVL7kFIdkk5/hGOEY8CzRhaOgK8dqXS7KZl/LFw5wtbSCXaiqROcYK5cSm/KnLHkV+TdvVj7NMAGbdzBa1fvArIceuQ/iqv8b/dmqqL1QBRFgMNm7fsR3k495hTRuM19qI1+fHAz6LeAHBi+K3x8lLKqI4SzrFjDU783081JZYPBIKtajDfUfpQE8bfNIf2+2yf9e4/RyBQKnlbGfZz/mJuNveOtyPy61WIxrNVruNqm/YijiMih1glFgWLd2YRnuSR/LFJQurHCANw0ol2VqPtJPXV5JXpqJ/k/Vi9L5J6Ialvf7hjmOAULGo7kF7Pbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tyBNApHLoAdWOa/rfVdWanww9DKhf5i7ZxLkRNls60=;
 b=jYTNq1ospbeOIp7LN/lf1Cx7kRK5K1MXUZzqsTKUqqbPNq2AsbumSzlDsvK9OJPcCTnP0OO5O5syKarMam38BXRnx8a01tJRgWfcDStyfcAQKJykWmRWPFxEEv2odxGnHqleeazyExhPOr7MTL/olZ1hkvyv0KfbmelVJkWMTts=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by DM4PR12MB9070.namprd12.prod.outlook.com (2603:10b6:8:bc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 23:38:00 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 23:38:00 +0000
Message-ID: <8208890f-2453-4431-9fce-d326ecbbcbf3@amd.com>
Date: Wed, 18 Nov 2026 15:37:57 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
To: netdev-bot+sashiko@kernel.org, nikhil.rao@amd.com
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 abhijit.gangurde@amd.com, allen.hubbe@amd.com, jgg@ziepe.ca,
 leon@kernel.org, jiri@resnulli.us, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, eric.joyner@amd.com, ArunKumar.Prakash@amd.com
References: <20261105-b4-ionic-cmd-timeout-v2-2-35a9a2aa48b1@amd.com>
 <179431289755.994134.3080122667953359752@kernel.org>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <179431289755.994134.3080122667953359752@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0054.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::11) To MN2PR12MB3485.namprd12.prod.outlook.com
 (2603:10b6:208:c9::22)
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|DM4PR12MB9070:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1d2ac8-36a8-42a3-ba3c-08df45ccfb6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|18002099003|22082099003|6133799003|261009223027099003|3023799007|4143699003|11063799006|261026140227099003|56012099006|261102123227099003|261021121427099003|261026121527099003|261028144727099003|261021135927099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	XT0p8LBxRd1jKhErnPqHKITjStIg1r/trOXO5KSc5UPuZHOJ3B47U3WErDKD08/HVqtYzUBVXucAkgQfdS2PadgZs+CBwc99978F7ABY+yS000E+hLBTWW0OiDm4Z19YfLURahwXJuJ2KC5MzipLZi9EfY2y0Dzmg55KPpEFojhV286IUSL8pTU+g6sxvDP97pOkFK4XWAmDj7QqzODNwQETHmoeIif4G9zzZJPUhCttB4kNViQQTHWLRW+N2AXhWS1nuLaEBQO7zna0+CHETsH656bn42QDVsLvFSomMoBAB/FIUVGz+5cRKOjkIGYf1o5MPgZRDS3VZuYJfXM1TRBjYIVwfCBucqFMv9SEtlN6OcEe+V2K2T+oIltIiVIYgKmkyCDAKqHYVYk85wnaUQd8iFEE5DLMEg7qq8eTSB7goyIOSreoTWX8TVW0ZrLGVCgvtEvO/esFA7JvWUPdgFthTPLmB44oQtuRFl/V61sPlZFBSOb++J6nAIbEBsdX5Ba8/QaHnYNSxXnOplJ7kqC7LtPqB/UX/kEoB6Isyt5mnoPYztGlfc0vkDcQjca47W66vh8mOLoBLuOdQTT3BmKZ/CZFOTBIAmYTpaiRhIrfvXSfjTT/8GH6FZvqgqKY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(18002099003)(22082099003)(6133799003)(261009223027099003)(3023799007)(4143699003)(11063799006)(261026140227099003)(56012099006)(261102123227099003)(261021121427099003)(261026121527099003)(261028144727099003)(261021135927099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUJCK1oyZ2tvTWQ0aXdoZmtVSWVwWC9uRUZ0Nnd5R0FNKzgwWXFZMTJHSUVl?=
 =?utf-8?B?U3NhR3dVUXM1L0IyQ3hnM0x5ZjliaysvOTRVVERPN0xHT0pJS2x5N2NwNkFM?=
 =?utf-8?B?MGQ4eDdpVXhTckhubFlPOE8reGpHUFVidk1SYWM1VnNSR3MyRTJtaFplSjA5?=
 =?utf-8?B?c1hieGtzbER2d040Rmd4d01RMk9SS2pBNHZvcFpsTkpFdmtZdjdsc2hXakVN?=
 =?utf-8?B?TUh4UEk1ZGxTM0Y5WVlWRkF1R3BZd1VmRTRFT1dQclYxQ1A2WmY1WUl4S1M2?=
 =?utf-8?B?dElMNktzQ29icmFFOU9JN0pBTVBqczhZL3FTMTJ0TnhBdlJZN2V5QUp4em9z?=
 =?utf-8?B?aFN6OG9RckZVbGY3Y1RtNGIrcndzUFlpSS9PRmZUK3p1K0RRcnQyZ1ZPTUhB?=
 =?utf-8?B?WG91Tkx0WHBhUkVGQndQN0lJd0J5VU5RdHNKc1RDN0MwdjJUcVJ3MlFiMUk0?=
 =?utf-8?B?dVJ0SDhUZnUvQkFvUXBKQVY4UUtPQVV3YU1lQU1OWlJQeHRUOTR1MWhaYnJ6?=
 =?utf-8?B?VnFCVTRmTUFLalNYbHVXcEYrV0xxV3ZtMG1QaTc4MGhkQ1licDRBOU5jR1hI?=
 =?utf-8?B?dld3a2NHQUJYeUk3R1pPSDFheVNNb2luWFJjeWI5cU5LZzRUbnU1Vzh0SjFi?=
 =?utf-8?B?U0ZNQnQ0K2lqcmVZNkhPTWE2N3RGd0Q5aWF5ajdBZFhodjdVYkV3VUs2YzFp?=
 =?utf-8?B?UFUwNjBVMGQ3NzdacFFXTForbzFnallXMjdOUWNrZnpmTWxWZTgxTHlLd2ZZ?=
 =?utf-8?B?ZTlVSmQ0ZnV1ZFlHcFo0MlZXR3dWWVdVcFB0OUcrMGZETWtaT3p5cGJMSTVV?=
 =?utf-8?B?VXhDaGl0UDB5TmdoMnlCUkNEZzg0dWRHUUJrRlYvdFg3TGd5QzFhLy9oVXlt?=
 =?utf-8?B?S24wVWo1VDd5LzNEN01TSFNOc1dqZC85WW5POXcvMUxCNEVSMThsYkF4VEk4?=
 =?utf-8?B?Y2RsU2tMZytUREsvdXVXUUZ2ZFlRRUwyUDNkMXVQY005d0xkOExpT2h6UlpL?=
 =?utf-8?B?RHJ4dFZ1WTBPNzdDNTNuOGNxVE04L1RDdmpTNlNCMjJ6WTdtenUvYVJYNng1?=
 =?utf-8?B?clUzenNra3djbG04WDF4b0o5dXpMUDl3eGhVcjVCcVQvSUYxQ1BaN0dsQ3Y3?=
 =?utf-8?B?M2d3UDdDdHRxc1dET3BvVUVMK25jMGp5Yk14NCthd3c3OVBISUlML2cycnNp?=
 =?utf-8?B?RHF4VVhJdlZZdXlPUEp0YzNiSG5WUzhnSGRCcmlxaWhtOFBhV1M0VGN3TEkw?=
 =?utf-8?B?MWpUTmVKTW5abmRiYkQ4cHZMWHUzN3hCUFdaV1U2ZW80NkZ2QlM5cVRPMWU4?=
 =?utf-8?B?MXZwN08yWTBtUjROTkh5MDY1R2NYVXc3a3grMnBMNHpyVnBTYjlwSGQwVlFP?=
 =?utf-8?B?aTRnWjR4U1NTMUlpZlZhdytwR1pRUFVRcGtvTisxbGZ3T1N4MEpGdHZObkJB?=
 =?utf-8?B?ODFUTm8wRzJuelNqQUFTYnhVYzE4NWNsNUJJQStWM2pOTlIzZHo4eGhxYTJ5?=
 =?utf-8?B?NW9WTVdVbHdIeWR3aVJPRzVaMW9CTnp6Q25JUzRvdWdpRXdSV1lkYmVrQzVQ?=
 =?utf-8?B?N3ViTTRXMVBaN213amdmc2kxbHA3YVZSK0ZZMmd4czlKV1JKL0dqYU5RWThK?=
 =?utf-8?B?L2hrTEJkbkJKb3ZLNGltVUdOTU00ZWJYaG9IMkM5eDVFZ0JSQzdLYnFQa3ZN?=
 =?utf-8?B?SXI5dzZZbGMxSlNQa2paOW05QUJpSVZyeFpqSDRlcGUybnRQb1FkTVd4UTZT?=
 =?utf-8?B?dGRuM2MvdjYwTXFPVW9QczF1Vkw0c1FJMmc2dFh6RGNMVkYrS2U1S3RaSEpI?=
 =?utf-8?B?TEJXd2RKM0g3YTYrUmFGcnlOYmg4RkVPaE96VUJDcW5CSlo4K20vdU9oNVBO?=
 =?utf-8?B?SHBkcy9rK1psWjZXZnhXOEVnQjVZMVV1L09UQWlkRHBEVVovbERsUlQ0aCt0?=
 =?utf-8?B?SmhnRCtucDFKN3Z5bHV0UlhTczBJRmlqblBub0JqMVJ0cDI1Y0t0VGs3Tmp5?=
 =?utf-8?B?ZE56bk5xNHpwTzJ0eGJwVkNpYkZJNnZzR3BHMDl1dE81Tllzb20zdnBScFZn?=
 =?utf-8?B?eW01RmpaS2prK0xpamJ2cjVPRS96bmF6YzJUWkt3Ly91UzN3QTlQVlVIOHdK?=
 =?utf-8?B?NEdSWUVCbEltWkc1WmZDQXU0L0czWHVjSEU0REhkMElGQWdibjBjWFdRZUxx?=
 =?utf-8?B?dDRWd1VYOTZwbGI1eWlYZW01czVLdFZsQjhhenhHSlZDMVNwOVU4QkR3cklu?=
 =?utf-8?B?TVU3VWZ0UlUwb2UrcERFam5zNHRpU21iU2tOdWxwWUowUkJjSFh2Y2s2R1Q5?=
 =?utf-8?B?SHl6ajVaNzM3TnFqZjIxNGg4VkQ4N1FUemtFei9VQVFycmFxdGlaZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1d2ac8-36a8-42a3-ba3c-08df45ccfb6e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 23:38:00.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeQTyf0H2ld63vutPEGGnZsbyyrdzdwhkfTX9jvkqQL/jdqFwKANE7y4mdUm7llhn3/11f0pF7fpyqaDVge5Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9070

On 11/10/2026 4:14 AM, netdev-bot+sashiko@kernel.org wrote:
> 
> [Severity: Low]
> This fixes a user-visible problem, but the patch has no Fixes: tag.
> The 2 second IONIC_ADMIN_TIMEOUT removed above was added by f3bdbd42702c
> ("RDMA/ionic: Create device queues to support admin operations"), which
> is in released kernels.
> 
> Should this carry a Fixes: tag for that commit?
Agreed. The 2 to 5 second change is sent separately to rdma for-rc:
https://patch.msgid.link/20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com

> [Severity: High]
> Only the watchdog in ionic_admin_dwork() moves to ionic_cmd_timeout()
> here. Can the RDMA LIF still be reset after 2 seconds through the AH
> busy-wait path?
> 

> Should the busy-wait also be bounded by ionic_cmd_timeout(), or should
> its expiry not trigger the LIF reset?

The busy-wait keeps its 2 second bound: it serves non-sleepable
callers such as cm_alloc_msg(), which runs with a spinlock held, so it
cannot spin for the command timeout, which can now be up to 255
seconds. Its expiry still resets the RDMA LIF, as the admin queue
watchdog's does, so non-sleepable AH commands keep the 2 second limit.
Admin commands that sleep until completion, including every verb from
user space, follow the configured timeout.

Nikhil
