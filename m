Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794581063;
	b=Y1tYh/CBhKFrbW6SNh9hIm+7C2i0Yi6kDparsQ71eq9XH5mAVKMkbVumya91iaQBp6zr
	 Rn6ICRl4bd7KEH43eRwMGDPSRvfGlc6fbxe0CNN8LN72Rs5fUNesocJgEDLE+ATx+Q1vm
	 iudrVFdET2orMTeBdZmLS0tC3phAkXspcSQVd8KslF7YJtDb8G8xZgoph+9CSSodlbgeO
	 VVz/9zJcq+BEVcJ9wUaaDcKVeVMAqtYeivjC1SUL2L3fhVu0fGR8szOE3qNXU0MeJ1/NF
	 JkAQHlTgL0D1cVD4lHMtsoWW5P8VgEWqx6e++AvsRr7fxWj1bBcg0MsYDsPZc18dc2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794581063;
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
	bh=tk9wlrWDUXO1lVweVNM5p2rIifI9hxafN2aho22NTwU=;
	b=rWPfZceKulFyEFBcdBg9QF5C/tfh5I1vn2AV5n4XzByN1ZQDrZvbdetYQBWutwntkj3+
	 kM1hoWtb2G97dsLgQh7Y2g5sHuPceJUo/PNQAjXhmPcZCQBRuPqN094d2Dosb4wxyhqKt
	 Qjbjay54WcfXnS7zGuLCl/Acc95jASBEC6O4u05kAVqhPT30IgcpTwABYtJpDaSxW+w3W
	 xE2WfbajQo+HX97kxVwNyCTfTr9daVz8PQouQpitQ5jZFJ5Q4wKOaCLllx1RdO9l5F1k0
	 ZscZ8zKxC5EnXXVbSR2J8QsJEgVrBSKi8y0swT3eJ87xn1ZkZIf/sJEHmFsxew1R55A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ndDqXs3u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.34
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7CB606A32E;
	Fri, 13 Nov 2026 14:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D7CB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ndDqXs3u
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i71OVbPfH8RXiWveAe6RQP5kbSeZ6BH5UOxm+ITeAIdt47hVv5Zm3Le6/jKbiLRQUbi4mMZccwKRnq2dotSwKWCkFQKFuArAMUjMBwrow34JgMN9ffLWSCy3hyURqEV9CInvZzCqog9PxeT71e53OYYSMsrPupN3SAaPyJhS2AE8IWdoH2BG91BL0CKEEUvC3geOiWyfSFNFZsdlDVt7dLCnJ0uB/CJJDmqDKIXURt/JIgE4dDTRNQZxdAv+qB1YOQ/DfYysk4BSL85lGVMfA345lRpKS078FkNTcby8IgsE2z8O/n7exsMgGqdMmfM+xruMdSKAVGN++SVI5/yzAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tk9wlrWDUXO1lVweVNM5p2rIifI9hxafN2aho22NTwU=;
 b=SpVNsoDdp7fHg88iIsqSIgPHoZL42PijeaUy6ehzkVFEyrJRXjQ5DGiw1ItnYkuWLRymO6QY+SO6vn7HdqCYT4TnqBJhTVA51cuK168JX06Q5p5zchWWP2TmwYm/aElsLS8EDANO7K3lstKbpX47OlFYRb/rwRrQz5bJjci0fOgyijqCYll7POJDSw6oxIXG+keESXiEI9wdWvRyDIUr5A5oyxI/R6b1sZJo2hqqs77ZnAs5YtlwcYZf+nm7fc/hU9znXC+2L6xrdWPyatGsKJDDKU615n0wR3D3mLr+unvQ/W1L6q2Sb6d7KPJiedPMq7MULFxlo036ilt6p8McwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tk9wlrWDUXO1lVweVNM5p2rIifI9hxafN2aho22NTwU=;
 b=ndDqXs3urSSkPrlCo2yJPoM8ymhAS+sBiFN0Pgr/diEwYo7Dse5nxhT9MpLf7UGfQUtIKx5ZT8OPqzmTmGhPIvQauxEdktUQkxBzqlEcKYdrkOTMjjCcyaQ4Ezr3GRkTbkrfFWu13OiF/1a+evwR7W717Q8hECeEyurwPRyE/Yzrm90HsDP56xLkrhafBTDjmvhYMTPWDNIpj/JT9zpXRZl4rXYJVuY6h/8peQ5BxvRlLaeCIxXsinK+x31YJAfnpkrvp6OJKPGFh5NvjnfA9S90wpy46rCtbbW9gkLfbLZ5S2gwA9Z3g7pLVgozN/4fIp4HEylT4GATFAP+9T4SvA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by PH7PR12MB6812.namprd12.prod.outlook.com
 (2603:10b6:510:1b6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 14:43:57 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 14:43:57 +0000
Message-ID: <251bb36e-3cb3-419f-b47f-30d464bd4239@nvidia.com>
Date: Fri, 13 Nov 2026 16:43:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 09/13] net/mlx5e: Use the correct DMA dev when
 data_direct is enabled
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, erfansh@meta.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kaifengw@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me, sdf.kernel@gmail.com,
 witu@nvidia.com
References: <20261110183826.2927274-10-tariqt@nvidia.com>
 <179447641026.2199510.5931919267235772242@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447641026.2199510.5931919267235772242@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0032.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:b::6)
 To CHAPR12MB999248.namprd12.prod.outlook.com (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|PH7PR12MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: f6a25159-74ab-4c52-6b59-08df41948c06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|11063799006|5023799004|4143699003|261021121427099003|261026121527099003|56012099006|261102123227099003|261009223027099003|261028144727099003|261026140227099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JrfFDe7eB7UqClqxU+is2MB8z4K0jgJp96S1BUf/nPZ4ElqzlCIGoXfnn/nu+Q+KYv/YLUEUQUV9t8kwYFKEUZoZYokTnSWxKsN6ri8AYL/JU1PKa+jaapknexqGpf7bwudUY/7fX7hojGHLIO+y2DLtN2yKaIOzjPxAXaZApAa+gkgr02NqN14hLvg7+0W7KPAhTo8Uql7wZwFtW+E1iHajhxTK1K4DNPrTRMjXSdyRFJpi0osJWx2VYCIbAVnM1o3X0c8Ds+Pgsr6zXfJHB7fkG/bKQ9CvYV52DYz/C4pPFlkinmjZ+h8Qg+nWQJcfH2V7dpgCTdibR3Ee55bybwVPslc+LVyuKKimxIu6/SkI5umZeWdBhcoE9cZaTHXR0B6GGAKvG3MpNxyO3caJdWvFwvcDDelVckKyigjSa0aqI7Xpb5FRlH3Xlb9bj+X2n7vVoXqyV58Uv04cAyL3sZdJz073hhoLkB6zjRibNAS/ljjPm0unLf4ZGCp8PuPPrFVOHVZDch2CnsmmVnwOcJqUBZdBiM5BNLWT+iDoKMr1J7EJZr2LkU0Czsn9oDoD9MnbANsbv7f/NOYsYybLdHvlhnFfi9wsgXgJiTRsabDCWPnBh40SYTSzbHgMdNz3ik4H57WsbnubOpkTLbuxlueSW8vGS0a4MReTH6J5ETM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(11063799006)(5023799004)(4143699003)(261021121427099003)(261026121527099003)(56012099006)(261102123227099003)(261009223027099003)(261028144727099003)(261026140227099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3FmKzF4WU9wdjNoSXY3SmxMTHpVWnlab0NLWmg0eTgzRDZSSVBadko2Q2I3?=
 =?utf-8?B?T2pnakhUU0pON2k3SE5lcGR2ZU41UGxIaitGdVZMelVhU3JuczBzWE0wVUxM?=
 =?utf-8?B?cDk2aTVqdUovZytjN3VLanBqV0FUY3lRVm5tY2daRFFwdmhJQWpWbGhOQVVG?=
 =?utf-8?B?T1BMRFliVFdHNlRTelVoUnc1V2RGTDR0dEFSS2IvOHhSMWdqc2gzMWVpN2hE?=
 =?utf-8?B?dWtKM3NsNzBOOGZoUDRtRTlFR2ZWbnAxWWxoQlVEVkhGbHRkRE1jMmtWaEJl?=
 =?utf-8?B?WHBvZmdLZENSQ3QwdS9xelE4bHNRVSs5V013RGQ5ZEZQRTRZOHpRN21RWVpO?=
 =?utf-8?B?ZWh3dWhEdDNZQnBjU3lLK2tKZGlScExXUU5sTzBnTjBaZCsxL3FTV24wT1BO?=
 =?utf-8?B?NDNsOTVlT2xnY3A4c1pEOG1DNitlNVQycmpXazJEU0NtQ1NCalZqOTA0QWZC?=
 =?utf-8?B?b2lkcHB2c0N2eTB2N09oN016MDFkSGNzRyt1Y0RYNzhMbFRKbWNBVlhYaDJn?=
 =?utf-8?B?WlRSOGJ0T01FZEkzVEUrQWlqS2MrOHhBZ216WWo2dmpHaXdBNEZINnVydU9l?=
 =?utf-8?B?cTR6QlJCSTNHcEVYL3JHZG1sZWh3NmZTU1NiMjZkc2I5Znk0ZXNSa3NyL0F3?=
 =?utf-8?B?YTJLd1ZMQnlZcDEyZWtmUUZhQW9CWkNLTzdyd3lWY0psMDlXdzVYbjJIU2xS?=
 =?utf-8?B?bE5OSzN4ZWtncGZWakYyeGZYT0ZMMXB1Q3c1NjJpcVNyd0tKT1p6Nlh4L1Rl?=
 =?utf-8?B?UWRtS1dsU3dkVmZ3RERpV2pJOTFKY3BUcXk3ZjdrTkJXSE5NSkNkRW44ZEln?=
 =?utf-8?B?enh1K0R6alBpQWpYYmgwUG9IZkROOTg3M3l1dWZIOVY2THM3R3hRanNmVDRh?=
 =?utf-8?B?UFp5a2pwYzFtQStEa2N3bllSZXZ1UHMreWk5TnlpeHd5emNjOE81UzU4cEpJ?=
 =?utf-8?B?U0tLeGRzN0hCeUo3ZDdmUy92cUJoanMxN0JVZ2pTVVMzWitTK1NHK1JCYUpL?=
 =?utf-8?B?V00xbi90MEpTd05uclZzY3VCTEhrUTIzQ05WK052RndBTmhhcE5XemppU1Vx?=
 =?utf-8?B?cld6L2xZczBBaUdLTXhKT2xTVWtoWlpIV2dINmxNeFIyQXBWTXRWWjVmNkdu?=
 =?utf-8?B?R0J1TVNrb0tlaE9FRW9oOS94WXI0WFdrblRCcCtFN0R6RGVNNDdXVGpUL2RY?=
 =?utf-8?B?MDBmK205Q1FPWDc0Tk1qYy9qT3JncGdkbkxFSlZNYzZhSmViczkrNjJRdHoz?=
 =?utf-8?B?Ym9zL1RpcGdMbDRLVG1qalkvU1BGQVIvanZLN2dzZzFtVWJqVnNiUmJXdGpS?=
 =?utf-8?B?QzAwTHF5M29UUGltRzl6K2oyZSs3emVpQkU0YWRhTkhhZjRqdmlnUDRlVjZ3?=
 =?utf-8?B?RTFRVXVDUk9vZEhvNkdUTjgvbXB1V0J6Z0NvVDNvdjNsTm1ueW9mVjN1enND?=
 =?utf-8?B?dDZlelRMeXVQY2xvZVRzaEllMTF6NFRaTTU3dzhIMGh4RVhYODBUUnRndnBn?=
 =?utf-8?B?dWRNbDcxVm5KcktxdVBrSUg5WS9IQ242eDFudVZtL2hlVmJ4cG1tMkllbS9v?=
 =?utf-8?B?Umc2SXM1SmIrckl2aFAzVnlDOTEzNmhSTlBSZHhYVWhCSHBSZGtrVHZtY3p1?=
 =?utf-8?B?ekFIWmVZeFhSMmo0UEZTenJ2QWZ4bFBlRGlHNEQwQXh4cVYwOUV4bGxDR0I1?=
 =?utf-8?B?NDZ5S2FGOHVHV1pFT1hEZ21Ua2pZMzBKaTczSWpKY1dyMENwcHpkaXlsbnZL?=
 =?utf-8?B?NlNTa3NZWTBZczhZaEdncy83UlBXVDJNRHhkOEYycWc1WFplS1pmSkh1Nk03?=
 =?utf-8?B?ckRMYTBoSEFTNTVLOXhiZktWRFVQZ29VM3pDdUtmM2IwKytZSnRHNWVuaW9l?=
 =?utf-8?B?N1laU0dGS3RONFE3aWk2bWdEVkRVOXluck9CS3dRN1ZTYnI2akd4bFBwSEhY?=
 =?utf-8?B?NHc2UzQ4MEdnN0xocW1FcEV4U3pqeit1d0JZVkNST3YzWEE2ZzRHdXR3dGFl?=
 =?utf-8?B?emp3cjRPby9ZbTVNTTdYQlRRYVdGenNuMFNIQm9sQnRFUHM3eDE1NnBoN1R2?=
 =?utf-8?B?OFozWnlWaFUvamhZTkJJV1UrLzFzdjBxTVkzcUxqbmVkUkY2Y0J0RjVwRlFJ?=
 =?utf-8?B?aHMwN21jL3V5ZDBvMFpxRzh5WU9iNElrSTQ3MkRUQ3Y1NHVFdGQyUlNwc0xE?=
 =?utf-8?B?Y2ZuR0Qxd1BxblhTbndBYzdYL1dWS3ljSHhCMDBsZzlDU2c1NlBBL2N1M3ZR?=
 =?utf-8?B?WGpCdzR2eDNPNFBFR0ZNOHZySDFVVnQwbXZ3ZEpqUHZMTVdDczNCRHBKOHZ0?=
 =?utf-8?B?YUUrOHQ4a3B5bmJ0TkM5aUo1L2FrUW9LUm9vSWN3aFNLbnVIRVNNZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a25159-74ab-4c52-6b59-08df41948c06
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:43:57.1367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJ8wV2biTWdGe0bNRZe30Hv2OiK6PPaGI1+6mkHfuc0MxCgVZcKewXc16/Wy/aziOAVntWqA8ZBybLvC8EWaYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6812

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] This patch makes the data-direct PCI device (dd_dev->device) the
>   DMA device for the page_pool of data-direct RQs (mlx5e_alloc_rq,…
> - [Low] mlx5e_get_dma_dev() (en_main.c:965-976) reads
>   mdev->data_direct->dev with READ_ONCE() through…
> 
> --
> 
> net/mlx5e: Use the correct DMA dev when data_direct is enabled
> 
> This commit adds mlx5e_get_dma_dev(). When data_direct is enabled it
> returns the data direct device instead of the PF PCI device. The helper
> is used for the RQ page_pool DMA device and for .ndo_queue_get_dma_dev,
> and the latter now refuses to return a device in data-direct mode when
> RX queues are leased.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 5b99099e4ed0c..ebd41f24330d0 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -962,6 +962,19 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
>>  	kvfree(shampo);
>>  }
>>  
>> +static struct device *mlx5e_get_dma_dev(struct mlx5_core_dev *mdev,
>> +					bool data_direct)
>> +{
>> +	struct mlx5_data_direct_dev *dd_dev;
>> +
>> +	if (!data_direct)
>> +		return mlx5_core_dma_dev(mdev);
>> +
>> +	dd_dev = mlx5_data_direct_get_dev(mdev->data_direct);
>> +
>> +	return dd_dev ? dd_dev->device : NULL;
> 
> [Severity: Low]
> Is anything keeping dd_dev alive between the READ_ONCE() in
> mlx5_data_direct_get_dev() and the dd_dev->device dereference here?
> 
> The unbind side clears the pointer, runs the notifier chain, and then
> frees the device:
> 
> mlx5_data_direct_remove()
>     mlx5_data_direct_dev_unreg(dev)
>         ...
>         mlx5_data_direct_do_unbind()
>             WRITE_ONCE(reg->dd.dev, NULL);
>             blocking_notifier_call_chain(&reg->users,
>                                          MLX5_DATA_DIRECT_UNBIND, NULL);
>     pci_disable_device(pdev);
>     kfree(dev->vuid);
>     kfree(dev);
> 
> At this commit, mlx5e_data_direct_event() only logs on
> MLX5_DATA_DIRECT_UNBIND. It takes none of the locks the readers hold,
> which is priv->state_lock in mlx5e_queue_get_dma_dev() and in the channel
> open path that reaches mlx5e_alloc_rq().
> 
> If a reader has already loaded a non-NULL dd_dev, can it dereference it
> after kfree(dev)? The returned struct device pointer is also used
> without taking a reference.
> 
> This does not look reachable at this commit. set_pflag_data_direct()
> still returns -EOPNOTSUPP, so data_direct is never true here.
> 
> Later in the series, "net/mlx5e: Disable data direct on data direct
> device unbind" makes the notifier take rtnl_lock(), netdev_lock() and
> priv->state_lock before it returns. That serializes it against these
> readers before kfree(dev) runs.
> 
You said it yourself. So nothing to change in this patch.

>> +}
>> +
>>  static int mlx5e_alloc_rq(struct mlx5e_params *params,
>>  			  struct mlx5e_rq_param *rq_param,
>>  			  struct mlx5e_rq_opt_param *rqo,
>> @@ -1105,7 +1118,11 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>>  		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
>>  		pp_params.pool_size = pool_size;
>>  		pp_params.nid       = node;
>> -		pp_params.dev       = rq->pdev;
>> +		pp_params.dev       = mlx5e_get_dma_dev(mdev, data_direct);
> 
> [Severity: Low]
> With this change, the page_pool of a data direct RQ is created against
> dd_dev->device. mlx5e_queue_get_dma_dev() also hands that device to
> memory providers (devmem, io_uring zcrx), which map their buffers
> against it.
> 
> What tears these down when the data direct device is unbound? At this
> commit, this is the only mlx5e consumer of MLX5_DATA_DIRECT_UNBIND:
> 
> mlx5e_data_direct_event() {
>     ...
> 	if (action == MLX5_DATA_DIRECT_UNBIND)
> 		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
> 
> 	return NOTIFY_OK;
> }
> 
> It doesn't close the data direct RQs, destroy their page pools, or
> unbind the memory provider mappings. mlx5_data_direct_remove() then
> runs pci_disable_device() and kfree(dev) right after the notifier
> returns.
> 
> Could the page_pool and dmabuf mappings outlive the device they were
> mapped against?
> 
> This also doesn't appear reachable at this commit, since
> set_pflag_data_direct() in en_ethtool.c still returns -EOPNOTSUPP.
> 
> Later in the series, "net/mlx5e: Disable data direct on data direct
> device unbind" rewrites mlx5e_data_direct_event(). The new version calls
> netif_close() and netdev_unbind_dma_dev(), then clears
> MLX5E_PFLAG_DATA_DIRECT. The flag only becomes settable later, in
> "net/mlx5e: Enable the data direct netdev feature".
>
Same.
 
Thanks,
Dragos
