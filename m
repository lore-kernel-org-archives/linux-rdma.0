Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793082305;
	b=BImHPotl6gc0y0sXgYSMlxEIj1h9QNntnMZHU+f/JTM7u6qcJxECq/6cmgg2OUk0AQ1g
	 VdvBjZSl07QGcddBf8O5Iu6PkQMFAOpMqQKEhMlZk2NakgoYXoFeDQdpYSNbU1f9c/rwr
	 RdRH1mV1zNUxN92arop59lHb+VHGF9g0w4HLRvppiqe63zHyNWxO6Jj41mT/yvnsNUz5G
	 ahGxQcotWwmyd8IJaGUr3vOpYWFLrj8TvTO+2hYoMSb1e3NteidreyA2DDYQsiXiLIC6/
	 +lF352evx7/NC9xoj7mCZLJwX7pB5Z+d+/GZ88sH7A6QmnutqHQHDPYlcNTniRJABMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793082305;
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
	bh=nakFLURflKXIT1/m5R3B4sNF0XQMX6vgmP3Em/Ss07E=;
	b=FhN35p4ryGFEuQqt5cuSiTTbRhvFJPhq0VOak8KbdEL8SB6F+eB6yOod4wYOTz6kgHMm
	 Q5v4m85Fp3kSow3XW/sgLbWJd7dbSmRlYPSMo82ywF6T4zTQ3WuEda35Gf+WFnA44b7sD
	 9O5tr70oSkO4Eng9bjIUdAZY3tM30+mfavlQ/oEzQpNpPdGN0xeDGi4+oYzyIY0t1Tbob
	 fFAHCcvjtPBXsviOdp5IlgFbrFbtYkJxJhz6/H9Y71rQCqeLitzJQt+9Q95QOfglLdgE+
	 W+Mtg4143dEkzyhgyPxOnF5Qg47ObcdsjB3pEWgCKNFuTJONgRoUuoIYtJu0uolonXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MMYUoJGT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.61
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F93606A31D;
	Tue, 27 Oct 2026 06:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81F93606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MMYUoJGT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzIL/q4XNluIZgaUp/5nXsyn2SVItrSK6L7OLeHy6xDZd4PIo70BONZ+g8Kj9KKeizbM4Nfa4awnCLlPvt2gkCQkxnF9k9yJuEejUVjjqQFrRYXtSSlIyu1VpOyMyhtSg88XZt4y8C8QLany1oZaLYVSB83a9waH7kEr9HovR04swtJnz0ZPdWDHeZ19oOT6X3F8uqrzlEytWgq0QkwIyYPUyA138ORa5RaPiM6k+nHFBm54zn4IG5Z9yzAgSsX0E2PGuX51jAKzvSkTtmGRoFdol4BBxQDcP+NpUkK03nT+MmJVwMUMpv8m6nRt+4vc3i14+KX54fNLrBs/1jaj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nakFLURflKXIT1/m5R3B4sNF0XQMX6vgmP3Em/Ss07E=;
 b=lYSevr30OyRArjzBksk2cJQHsi95PMCe7QZLatupD3gCFh7iMWdYH9Mk888YxbYH9/Lx4qeW6D8la5QY4JoirzisJ/+4chls6aCWQPiFfhDXAdAMFjc2JTcAz92MtNaTjbN+fDq7y5P7xegP2NQWQLiigqdNO5kESZ9nD6cQJQuJ0ypEY9gLuMlKGw53r0F8Tq78Yp5pF7gvbk/OpR1gksKxrsaSqiMPv9jeVBr+WRGQ/HOH0vrJdVQ1ixJ1G2HRBoRQ7S591dj4PMmpQc0mqOL993gHX99ipQsC4oG+M7rcjt7tU5SzDGE/4hWLDuvWXL2AzUlY1dAgkl/urkxJSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nakFLURflKXIT1/m5R3B4sNF0XQMX6vgmP3Em/Ss07E=;
 b=MMYUoJGTMF69/szuSNWAUG2315XCPPz5RftwOGkqwKXQsMxGhA451uvlgKELlA0hn58aXVlnK2q7grK2DmfhfhcL6nUbKtmQLZclUqQ9SF0pUDXWpt6sGnZvjjUBj25+l3GwvCwz//LkpVo5SsVn2MyvmQhh1s2yyU1n9O4QZETmWZgAxV3Gi9EwP7dxGuZjpq9Yv9CtkGgO1dANsW5TuXqoZy6BxtQdJsp0qgbll6p/C73VKB56ZsTUoWWuU6E4aymdWDJY10KDgxKLG4QhWAQnr4Tve27wHR+c5r3mpg1X+HIcru51XSpBqpZU6D3Op+f/K9v8z634//zVgdW16w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by SJ2PR12MB9211.namprd12.prod.outlook.com
 (2603:10b6:a03:55e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 06:25:01 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 06:25:01 +0000
Message-ID: <8dd825ca-3f23-41d0-994e-430e6642cc7f@nvidia.com>
Date: Tue, 27 Oct 2026 14:24:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Bridge, fix bogus MDB offload errors
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, bsoares.it@gmail.com, cratiu@nvidia.com, gal@nvidia.com,
 kees@kernel.org, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, maord@nvidia.com, mbloch@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, vladbu@nvidia.com
References: <20261021122115.3737284-1-tariqt@nvidia.com>
 <179279457212.3134.243255340288032723@kernel.org>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <179279457212.3134.243255340288032723@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:195::10) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
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
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|SJ2PR12MB9211:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0c2f9f-77a8-4125-3ff9-08df33f307cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|4143699003|5023799004|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|10067099003|18002099003|22082099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	IIDa/sy7LQgfteRtrr104Zi+RnDLDCtLCLXXplWtI9WttoeXXtolXyKd0nHmAiA/CISPGaVrfsbXJFOBovs3F+QR8OW1pZeq4UIbpvEHbkle2u0TuuGjDpLCcwhFKXFDp69P/2nSFYKlF1UEsi/FfJWWF9Xr33doeT25gNr7Oe/BCiPD7o6yLh3ywhCix/QPAA5TtyPFcr5aY9iVm3NDwO00I+WoET4w1lbEigPalV+FqGlQi5CPsPCJnMjwHq0A4ecK9R+qJeL4uDDkLSQASSY/yapQc/TG8Ko8o/g9PxGGmoVjOqJdZYlakKYiIdLpMwVoW7UOf1gZ3p7SSRX4EpXeZam8OPa1OifN7zOL2hAOEb2iuqQT+zLVivM1GR9tpoyLRwewxbKW9H3m6JabuvGSs2CnV29GJ5D/e312VScvGMirUNnel8NB74NVrMrHpEj5kvGXwSMQZT14v8Pa9A5nY/warxsMc++y8UJFC94GPBH5kQxIFNXsb6z2ppYINqZ9ZhDc/TFUoYDnY6uGBmHRjDpxqVZEK1TqwC61yTZ4dj0cEZpifZI+GielnQQLHhhCDD7p9bddFoFTr1zB7Kj4MU7cCYll9gVotjO9/OtWJqST1aCRO4ThIAQQMf0Y6Ry9cx56ggjPZxpiMc81eKaLKYzYCxM4is46jR6p3zg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(4143699003)(5023799004)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEVDSE5UQUN0aFQwU1NudHdXRTcyTCtRSEZ3VWdLeXhscnNKZHhmTUhWN3hh?=
 =?utf-8?B?bVlpNjhJeGV1R1VPckdjTXBsMnkrT0ZjZmhMRVJGaGd0WVVPeFo4QXZRU09w?=
 =?utf-8?B?cUJ3Y0pXeXJIZytKWHlEQVk4QkpYeDRNbmVFN1BsQVZxZkN6SWlJSHlENkc1?=
 =?utf-8?B?dWRLYW4vL1R1VncrN0krekNSTWlzK2pUd2kwbGgzNkNWcTRYLzJPYkVPckpq?=
 =?utf-8?B?bngzc2xlSlB0czgveVI5WDMxWWpnWFVlQUpvQ2lvV2lld0tKRWxqVVEydjNX?=
 =?utf-8?B?SjkvdFZoUTJkamFON2UzRnJlMW1JYUdDQmIxWFBjNEJBV1BpN3RqU0lEMWRQ?=
 =?utf-8?B?LzdtMjBLSUJ4TGxoeEw1TnNITDFtRmsvSkljc1BTNkQzaWxiczZkRTVURTJh?=
 =?utf-8?B?cG12ZTk1aXRvTkYva2NMd0NlZ3orb3J3QXFPYXowMUdoSDdLc0dBWVdZbDlL?=
 =?utf-8?B?SjlYMXdxaWYrMWd2Qkx1Wm1IYzNRbStmZXpyRUw2OXlYdnh1T2JuV2Zhdzgr?=
 =?utf-8?B?dDR1MkhSMnppNGg2Z0c3blVhQlR1SkpudG8wZlF5Q2JzVytudDBUVk1UMUJS?=
 =?utf-8?B?all0YVlBTTUybTQ5SXNzTXBBZjVaRnA1ZnVyL2ZRdmNxNUZHeFh0bkxhV1RL?=
 =?utf-8?B?Q2hLYWdiUUp6ZElnK0hhSHNFTmhvbXY3eXBGMCtqK0NBaW9rcE81NlZ0RFJr?=
 =?utf-8?B?dGtORVJSb1dYWVpob1VJN05kMFJzV083VXUzM2kxSThONmhoMUY4Q3FSeHB3?=
 =?utf-8?B?VkVhZWxNL2NSblJKTjFpUWFKQ2dqZjFJUUh5WmYyYXE5RUdaQnBsSkM2bjcz?=
 =?utf-8?B?VTJIZllNVXZMNGJraWN5YUsvemR3a3IvQ3FOT1h1NXo2RTJ1M3BBdFduRkRY?=
 =?utf-8?B?RW51UjVXZTdSUU02cm4ycUVITEU5dnJGNE01YjN5MzVLeWVIR1V3SlBsVW1C?=
 =?utf-8?B?WjF3bVB0Uk1RVzdUcVkrNC80SlFOTllXZ2tCWG02WUI0VkdkcnNvQXYrZlRx?=
 =?utf-8?B?RmVuejhRNUhzL1Y5YWZVVzAwYjR5MWdnTWZwN2tOM1JZcmx3N0toUjJEOHhL?=
 =?utf-8?B?OXZhN0VUZmJXZU5vYnkySy9FMmY5WVFGVnU3aGlLQmtXMzR6anlWNXpTd1Rw?=
 =?utf-8?B?MVVkQVEwVUtCUkRhZWgwdk1MWEFubTI1b3BaNHFoSC9WbjE0RzUyaG5hZ0li?=
 =?utf-8?B?emxveXI4dUtQWnpqeVpoVFFoMTMzVjBTbDBtSHNnaXZjNHZUSk11N0xKZmhR?=
 =?utf-8?B?TGwwVUdia3hFMWdFaUJFWHZ0bElMZ0hDQytSbzNydzZTdmZCL0pwVnFhS3FX?=
 =?utf-8?B?R2ptZlcrQzF3dklkVGxSbXpGTlhCMFY1RWZ5QVVnKzlaZXFSTUVRRi9YRDFH?=
 =?utf-8?B?UW1acG9iQnFFak5WU0lEb0Q3SjJLUmZEbmhWRXFQb3V5Tzl5bjVWUGxhVUdx?=
 =?utf-8?B?aG1tNFpMNHRtOENWbWRaSERRMksrYk1CcEl4WDUrQm9DRDVPYUVaZmNuN0Ni?=
 =?utf-8?B?cU81UTZqb3pYbDR3OWpVUTdLSlI2YTJXZk8yeWVjeHI1TVIraHV0cEF1bEpL?=
 =?utf-8?B?QXg0MG1CS2haY0MrL0JBSmtSZkRWOTVHRVBBakszL1JXTklYOGR6SldSeTNE?=
 =?utf-8?B?bG1zRkUxTEFMYmJCQ0RBYjNsei9PYnpXK0ZDcFJDYnJrZ05MRTNWUS90WEhR?=
 =?utf-8?B?bjdTS0s3ZWtZSlBFdmpvcHdObERoclVSbkt6OGRlVXFpY2pzMVp0dG5nL1hn?=
 =?utf-8?B?ZkQzQmQ3NXZubWZkWjVCamdQVlN5UWEzc2tGWXB4dDlDNDl3WUFtN0szMFlS?=
 =?utf-8?B?WUFVV3RTUThsVDRPMTcrQ2xCRXMvd0h0UUhOYnQ4Q0FVV1AvOFpsSGpmMTB1?=
 =?utf-8?B?QjZadWRoTDE0UHZwSDZzbk5VL1kwWUk0ZGMwandsc1lUc2IrTDYwRHFPN3NW?=
 =?utf-8?B?VTdjWk54OUpqMmpJbXdXSU9PS3JuYXNIV0VRQ1NnS2hkNVM0cVlqVktRT3Qw?=
 =?utf-8?B?SzRLeGpuSnNnMWtPVFZOalJuejN1VGlzNXpIQS9PZE90WkxHY3FJcmh6R0Iw?=
 =?utf-8?B?VGxEQ1k1clFsK1hxUUZPTU81bUJxVUFxOHBscW9XL0E5MjRzdjM4UlI0cmJF?=
 =?utf-8?B?MEpKVEhXaUErRlg2dENwMmhGdDZKdDVkL2p4cms5alFOb2FXZ0t4cEExNm5K?=
 =?utf-8?B?c0pwdFl1alBhZHFQSmZGbVJ4U0ljdS9pUThGS2pzb2tDQlBjazBFMFJXaTJF?=
 =?utf-8?B?ZGIrYlhFUVNVR3V3c2dIZ3UwVHlHaHZ6VmIwaWFDQ1dQOXAwZGNjUW1oaXZq?=
 =?utf-8?B?SjNtdnZ0R2pDVW1WQmJFbkZHVW9zM3RRZ3kxMVBzMDZhUmN6MWFNdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0c2f9f-77a8-4125-3ff9-08df33f307cf
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 06:25:01.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPfGRVLxGwXSboCDi7H3QHGLMwRMaGprVV5qD82MAJ7HHgOGydpIUFJ08ofpunrmMnUBjbRi0KoXATFj4JLK2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9211



On 10/24/2026 6:29 AM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] In drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c,
>    mlx5_esw_bridge_port_mdb_add() now returns 0 when the bridge port…
> 
> --
> 
> net/mlx5: Bridge, fix bogus MDB offload errors
> 
> This patch changes mlx5_esw_bridge_port_mdb_add() so that it returns 0
> instead of -EINVAL when the bridge port or the port vlan cannot be found.
> It also lowers the log level from warn to info. The goal is to stop the
> error messages that appear when a 'bridge vlan del' overtakes a deferred
> MDB add.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
>> index b4cf3c5ac0dde..7c32dc9db098e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
>> @@ -1867,26 +1867,27 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
>>  
>>  	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
>>  	if (!port) {
>> -		esw_warn(br_offloads->esw->dev,
>> +		/* MDB is added asynchronously from the switchdev deferred
>> +		 * queue while port might have been deleted concurrently.
>> +		 */
>> +		esw_info(br_offloads->esw->dev,
>>  			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
>>  			 addr, vport_num);
>> -		NL_SET_ERR_MSG_FMT_MOD(extack,
>> -				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
>> -				       addr, vport_num);
>> -		return -EINVAL;
>> +		return 0;
>>  	}
>>  
>>  	bridge = port->bridge;
>>  	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
>>  		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
>>  		if (!vlan) {
>> -			esw_warn(br_offloads->esw->dev,
>> +			/* MDB is added asynchronously from the switchdev
>> +			 * deferred queue while vlan might have been deleted
>> +			 * concurrently.
>> +			 */
>> +			esw_info(br_offloads->esw->dev,
>>  				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
>>  				 addr, vid, vport_num);
>> -			NL_SET_ERR_MSG_FMT_MOD(extack,
>> -					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
>> -					       addr, vid, vport_num);
>> -			return -EINVAL;
>> +			return 0;
>>  		}
>>  	}
> 
> [Severity: Medium]
> Both of these early exits now return 0. Will the bridge then report the
> MDB entry as offloaded, even though nothing was programmed in the
> eswitch?
> 
[...]
> Would returning -EOPNOTSUPP here work instead?

Right, the entry ends up flagged as offloaded without a hardware rule.
Will respin with -EOPNOTSUPP.


