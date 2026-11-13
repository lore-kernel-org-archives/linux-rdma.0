Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794580622;
	b=QUs75/PapX44f1usE64cKeAoD/pPjbZy/0wX2PPAFsiYr81EbS6QlTXluR6y1iVgiymb
	 JK2mJie8cBG0z2ws6yKOPdDtz3uLSfJc9lS55EtPZuFWlydIWyisCmMKTwRI9RsIQRC0O
	 x8RCKOGBeqYO/+GbrXbSpAKID1RVbGs9cg+gUoaiG1gF1aD+h9cGAbn+8DgvVtqJALJZG
	 QbuMyDSklCSC1qSXmy0mE1d5hbbynYOSvZTefZfYRu8wgC06lVt2tP7WN/GYygqXGZn/V
	 oWBinJENE2EA+pb43Bqwtb0LROLW5/RpqHnVKITu6QaFoJ8S9YEearFljtF3RQt47IQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580622;
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
	bh=EbGtaA557lxMyY/FEFCWoxo1l2BrDa8MLktuwy5CtqM=;
	b=rhtM9c+aark0T+XGmi53vJXzn0ifYSbR0lQG03pJWTWL3W1P9+9qYamKL0MBV/JA9vxD
	 FDvL/KFpqg+G6VrFlFEYTthvF/Ipr1t7+x8r1OX2F6y8FiGcQF/PEH2B9m3DiuXJgeBb7
	 8PXXjgy3GwWKR0a1B++mqCaRwFdh3vmw57mkbdsb/ktKKeSonZgiiz8s6PvmTVVppRUVM
	 0Zta2UwZ6JuOHD3Q8KuTbGN6OXr36eOtc2ZOqXv3Ih4pM9qybMnSE88tXd7//4MxKll0B
	 7sVMEFtS+24AK1/ISTgV4cb0IZrDvcFKPNzsXYFxred4KsJ1F/FiKn4fRDJ+smabjBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cPKlmI2e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.57
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010057.outbound.protection.outlook.com [40.93.198.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C59606A32D;
	Fri, 13 Nov 2026 14:37:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34C59606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cPKlmI2e
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPnWisbUP7S8bCxuZmQW5pWQtFS0mzvAq36GpMLarlaOEl+ouIPmbq3QiiOSWNdEYm/RZqLhGS7IEgkgp+z20MXNnblslC5TLPOn79pHnH9OcekgijsgGeSfCkBjlLO8HmB0OixQ8Kq9NIJFJ2PD3EM8xbEaeASLM5/KAvJ/LtMBGq+kZJMFJhKifW/fDd06vY/jfPyZje912Slj8/9+f3DHBdAv+cM6AaR/x0bU4Wbl2lYr9Sq3DkxXkfmlXFrJUm08+iKSHNCMwO17m9SKugRgXBw8Orx6Jd+a2HtZQIsOBjsbxFp9/8TBRi4bFAuH18YnBtAx2xi3tL3lrUqMfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbGtaA557lxMyY/FEFCWoxo1l2BrDa8MLktuwy5CtqM=;
 b=CmRLsB20CrIDmEMWxlu4ZYJMkYYmEtMlDgyV8wXtcUrvQHaQMWaJPY0g/kIohgLV6rn3Zn2Zmnay7lSvm0GYoZXceOSGAGUp7aXVFn5zyguOvM5fjOs5gcjDQ1l2xzDBstt6p2lUeSyLgVDIUIpuYxUjyienz6d1q6s10KUqLmzNJKJ29Qgi+qyWba9Fusi4tdgPeEe6yfc6Zp8QQum/wN2knDfU5YpJzI4s390Lz+7c+XcsqCTjmQHkBWeWg86in/1t9S1Lbn8TbGNcpbWDgwcSN1Ody4MCjpvjT8TR8ya8h99e1KV2d2txYmqdkxrCdJOJ2gKh5n8mWdLlxoF/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbGtaA557lxMyY/FEFCWoxo1l2BrDa8MLktuwy5CtqM=;
 b=cPKlmI2eI3BKVEccJjfzBOr9cQPvU4omWHjwcwfHocK2p0zShIbh48XDColGVirWyT937oNUIEaePCZzeE3zrimFWE1PJV4yhaLvP2L2fZsdTveedK4zRzhfAonfzPdxeGiiCPXZnre80y+hGUGh+jg1wr/DGqKRvSWWt1KtMbCPx6iNBXPa2Y3tLnulgxZqQroNnuLOcmKzBvWOJ+OPeH751Q5yQI7AyWMwTvGBlQUSJp0ih+dZx8ESf4Q2F4H2ny56BSckiXKKQXXk480wlLKIvaR2z3mYNUVWMThEyLbjG/IIDxeEXdv91Q3CcZulU3MPdv7ynRZQKkuj+O/5Cg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by SJ1PR12MB6217.namprd12.prod.outlook.com
 (2603:10b6:a03:458::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 13 Nov
 2026 14:36:47 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 14:36:47 +0000
Message-ID: <0bbaa8eb-f6b5-4949-beec-6c961e1b8d03@nvidia.com>
Date: Fri, 13 Nov 2026 16:36:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 07/13] net/mlx5e: SHAMPO, Use page_pool DMA
 sync helper for SKB frags
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
References: <20261110183826.2927274-8-tariqt@nvidia.com>
 <179447640791.2199510.16646668257000691425@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447640791.2199510.16646668257000691425@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: bf05d99a-b000-492c-8317-08df41938bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|4143699003|11063799006|261022105027099003|56012099006|261026140227099003|261009223027099003|261022075727099003|261026121527099003|22082099003|18002099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JMQQYEISs7DojtWSamkcgfRiODP/ZK+ULs35XZtaTNF3yBNRIYjn7uEPvZ8ytAtH7PNYKUMPUTIQetGgbwlAA1fe9u18QgIhtUchKgIXdzY3u+Ugf7qJaYf4aoc1DMXEQS41fT2XgvD7iCMBcJc7O98unOakvIVfYYEqhyzS3og5nW/4huKpI6ID+DpKwl/iaO2xXEu+pCHNsqzIv9RuAYf+AIDcIFmhX9Bc391lS3wH9e9X7f2AVC6eJ5XTcB/8s5olz9UHZydk1/B1ytH3iXqhqmDfF75O7OfpKW+0p3sqvMSx45L/p4DxbaEaG+Ur3s7LQgXpgXAu0TKhXL7tmkFt7didimRm21U6FJPTDcXChLIeA9YLuLsMGipHwlmFviGwkAPLVPhrHdUPj8nh2cE0S0Day1y6o26+3mzLbYDCDO2nRsF/CkNQ1AQr8aCZjQbPjv0z1g5pkRwDYJ1HNh6/VTunwnGenDj7e+llKql30hF4ZWVojROQjmuf17Au4d7F4GuFBiSvzMrhPfQCuZKTL4fqkvU//4f+litVD0xQ2jIzpFdv+wGIomet/LUNF3E841NC6pcJvXj8uyrAaqjJWdGuvFyhDSoRlLj7+O5tTpcAP4qgNGRzGgnG6XjiRYim/1JCoSfe7ETBjNY7YQ6SbI5jrn6vr9hPRfc6t9w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(4143699003)(11063799006)(261022105027099003)(56012099006)(261026140227099003)(261009223027099003)(261022075727099003)(261026121527099003)(22082099003)(18002099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEU3eC9EWEFBVGFlNVU0eFFpdzhXYkNobDhrQUpoNkF1bHhXT0NBS3NPTDBY?=
 =?utf-8?B?aEcyRC80K2JyQnhkOS9DdE1EeEFCN1phUTk4cS9QTys1SFRINDZGeDE1dGtN?=
 =?utf-8?B?L2Z1aTFucSt4VXpyTWpRRHc0d1ZET2twUklWY25WRWtLMGwxb2hhcUxTYkhj?=
 =?utf-8?B?YlNaRVVJZE5VaFRRcFlQcWJ6SVVadXNJNHc2WUEyQ0FDSURIS3g1eWlBUFQw?=
 =?utf-8?B?WjRiME5zQmg1RytxVmhmMjhXSmkxd0lNMWQrOVI3U1VqcWFMNVFVWG1NdFdV?=
 =?utf-8?B?K2tmeWZOMm1CaWJMeC9UZ2ZYRnE0VHRMWSt6ai9URTE1cWtRSXBUWERRM0tw?=
 =?utf-8?B?UTdMVmpzd0d3N2NyaHMxNGYxcXN4S01ENzhNVHVCT3FRZkFrb1VsalNMNGV5?=
 =?utf-8?B?VitUOTBpWUVvUktTS0J5Ni84dGROWEdlbXhCbTJWZFU5OVJ2TXBRQXFkOVRs?=
 =?utf-8?B?dVBSa3VSekp2T0hNT2ZRQW9qY1RER3E2TjB4NmFOM1JYcGtnUGZFN25BQXhK?=
 =?utf-8?B?eU9FZ0pGKzJpcFNNbEVmZzE1dkMwZFViWGh1UFN6THBLdlF0a094R0ltcWho?=
 =?utf-8?B?WEJRSEg0Uk5GMllPSVdMTU9FeTNOOCtoNWJEbnlFWDBFR2EyRERmZjNVcXA5?=
 =?utf-8?B?ZG90RXE5cjlJZ0JSSWJsVGxWRmZkVmx1dTFIZCtEZWFydUJNdXoxS0J4STF1?=
 =?utf-8?B?dGNqSWJJM2NIajFmMHJsNjhraldjbHNweW5oa3VSbGZRY3BRYWZEQUZ6T2RS?=
 =?utf-8?B?c3NKTkZGTlFMMGZVMjZIbG13V3pNS1FlQS9YUG9YMUVyMDRwbHc3NWp6dlA0?=
 =?utf-8?B?emF3RTh3bkZRY3liSmo3VXdSWTFadU1WWE1wLzFBcjQ5NUNqSUdlZVYraHJo?=
 =?utf-8?B?SkRZMmxka1YvMWFYYmpTbU9DT0hCc3JqbnBaUVlGVUxJS2xLa1R1bjh1bTVL?=
 =?utf-8?B?YmhQb2Y5djM4M2liY3ZNZGszbjdyOE9ueThqcWlLSWtaZHRCNzVTZU9EZVJa?=
 =?utf-8?B?VnFzcUpLQXcyTHUzR2wyWDdvUFh2Skk2Zk1CUjlyY0oyNk1CSisyREwzQTBG?=
 =?utf-8?B?VVliekV4UVBZeUkrOG82ck0xQlo0YnlUbHlUT0c2MXV2dE8ydVZMRlQ5SWNY?=
 =?utf-8?B?eDhFdDlUWHdWWkd5blpta3Eza2RQRlY4OWVEcXlQTmowNXRXN01HV3pKSEhr?=
 =?utf-8?B?bTcrN3d4Q0s0LzBHVXE3K29wZHFWWURqVFVKQk9nWWc5TzhWdWpCa2xJaXI2?=
 =?utf-8?B?ZHpka2FYenZCVDU4UmhxMS9SM2dQWGdFbjc5a0huSVF5RThpdEFjMW0yMnlR?=
 =?utf-8?B?R2g2bDl0V0V4Y1lCOW9QbjBDM0ZDdmlvZDJmQ2hFTXl4dGU4SHJIaGFyS2c2?=
 =?utf-8?B?OXlMMjFSeldLQTN5d2wxcVFlT1lITDFIU0MzY2dzY3AvRm5oOHFPLzR3QVhp?=
 =?utf-8?B?R0gxcTN3ZEh4dFBDVldFVnU4QzNyQXhxaUlmTFg4RVVDQWs3RW96RmgyMWdW?=
 =?utf-8?B?TmpvcTk0TW9TNllTWDJxZVZ3U0ZES3grQzd5VmF1S3hQR1NEOGhHb216WFVU?=
 =?utf-8?B?VEx5K1piTFB6SFp0dmxDNXE4dkU2OSt2bWVGM0VzZ1k3LzBFbHMvM1RycUJn?=
 =?utf-8?B?NjlwalhaMFRlcFRYamxDdlEzWnNhS2ZXQUpYSXh3R0pkSjhLV0crMDk0emUz?=
 =?utf-8?B?MW90a0l1L2lCemVVWjNTck9xbjlGczhlWnBkQUphTG94UHZROG5ldkRaM05V?=
 =?utf-8?B?L1VLMjVXSmo1SmpsdS8rNUFHZWJvTGd1b0g0bis3UFN4R0JacEZYYzNGRkJG?=
 =?utf-8?B?RXcwSlhtUEpCdWxyakVvYU1LcW1hT1pDRXpiZDg2L0lVRG0zL1Y0a1Z6V2I5?=
 =?utf-8?B?YXNrVy9XeEpmNzdQa1VpN0s4WHFDVFBZclNxeERKbUsvczN6YXVxcUtmTTgx?=
 =?utf-8?B?bU1nT0ZObU40by9Edm9MNFpURDVReXV5YTZHS0VuV2lZaUNqK2ppeEw5d0F1?=
 =?utf-8?B?bDdJRzIrQjZNSWRVdDhORU5JdHlEZ2VCVy9PUVBQVDdFeFpjN3Zqei9pdUs3?=
 =?utf-8?B?VXU2dmpRMFNNdVVCcTJLc2VjSzNsSTYzMzlPZ1pOWktVYU5jWVI1WmMyRU5Y?=
 =?utf-8?B?VWF5b0QzSjd6ajJ0a0QrZWtGMUx2V1pkaVN6dEFsWC8rNlN6UWY1dFdBeDRz?=
 =?utf-8?B?RUpTbVJ2SjYwWFhmdTJWUDJ6OHRJRFlHZ1Zpd3gzcTNnWnVhVFRXM0NRUFp3?=
 =?utf-8?B?UDBmR3BpZmhLRTF3ZVVmOXV3cm9RZ0NoaGY3OHZqZGdmOVBtb1JXVGhqakhL?=
 =?utf-8?B?dzNOU201QytzbEZrM2kvTk5ZczM0OHMxN2p6b3JRMHR2cnhKUXVDdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf05d99a-b000-492c-8317-08df41938bde
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 14:36:47.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OdPFID2yz2X7WNaWFwr0ncLdCrBoVl+g7pkCUUh9u2DEZNvoqJ+yzNRttsW44DfRYipVntFmZseyGTgICHJ7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The commit message describes this patch as preparation for data
>   direct only.
> 
> --
> 
> net/mlx5e: SHAMPO, Use page_pool DMA sync helper for SKB frags
> 
> This patch changes mlx5e_add_skb_frag() to call
> page_pool_dma_sync_netmem_for_cpu() instead of calling
> dma_sync_single_for_cpu() on rq->pdev directly. The stated reason is the
> upcoming data direct support, where SHAMPO payload netmem is mapped
> against the data direct device rather than rq->pdev.
> 
>> Switch to the page_pool DMA API which takes care of not calling
>> dma_sync_* for unreadable netmem. Do it only for the place where it
>> makes sense: SHAMPO payloads, the only RX buffers that can be
>> unreadable.
>>
>> Until now it was ok to call the dma_sync_* API directly. But with the
>> introduction of data direct it will no longer be correct: the payload
>> netmem of a data direct RQ is mapped against the data direct device,
>> not rq->pdev.
> 
> [Severity: Low]
> Is "Until now it was ok to call the dma_sync_* API directly" accurate?
> 
Indeed. Will amend commit message in v3.

Thanks,
Dragos
