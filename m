Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793964787;
	b=RNRZfAcCYICG9mTbNmAo6b6fQ9JXiY1P3me6u0h8J8nlLxF1VgUXcd4MJbaFUFnLBj7a
	 VUgvwF2kicJz7bb3OsxYsX8t6vvK3LDaRuQ8ff45in/jYfWZRx4vZdukyGkT2neDR1PQI
	 e/r86sDwf1hFK0BHXmih4Ybom9P6DVKDsb/2PvDeuISNhvG4PRk/sddQtScb9WWNIAyT4
	 bS3M/uZwJwPBbeKfPiYcp3KxJN85CU2DX5KyXL/zxe4KVJPyu/9muQhafUIMZXhyaq9MM
	 IPSz1LQlciB3YCjY1s6o+hAOUBOI/aa7fCR4mPvVd7x6HdiEhRH8YU7e2Yiv9HkYgkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964787;
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
	bh=nwNTp1wOsltBnsrh/iC0UWXH+UYbmQM7qEG/oxD+yaE=;
	b=tm/pLRXOm6AzbaaLzx96YNdSOAfWWnjcUD3ZV9pbd1kKYpgUoN4Az22Qk/7EFTkFoE+k
	 9o2pQfHwgwld1rpWAF2Sc6ReM6LmRat/tOGIMdbtINjsGmClYzgH+JI6GyFja1+3mDgxe
	 mq9IRHgnVNNPxIn2vKl5dydE1U+emd/Wo06ienhtLWt7jFNX1J5vDFas5NVC8zLtecb1M
	 9tkUrkzxHXmB4G9Y/qcyl0YxREeAmbwBw1r8BbosxhVVGka42r/1Nu68io45HStRoQZSn
	 dfwt6FfXTX25sNR8f336WaF+HLa+2BfIEG8bgu1dDWUa23Nv6hYxbMLcHhDdioIlJBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dKr0+2D6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.69
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7170606F8FB
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 11:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7170606F8FB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dKr0+2D6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnK0HFVRWPRpWHkig2eeE/eF6OJ78ES+ADtZ8iMTq6yv39OM80eiv+Ypa83vHviZWwvWZTAr5J2/GWyTZFNyx8iv8n/QDrZtvDUsjozsHois7XX3s20SDIQXFLC2R5izpOfCxYzE8np+agrSemCd4FqfRkjpxx2h0Tzxw2HhIXTF3Ulz2f1M3rGgPuJIC/OkgjH43m9ZT/Rd9MFewlSuag0JI7ffn/YBC7bSP0FYcGf8dldap5dGYTygd/v/OSMjZAi8chvNsNHkcw80VAobQX0nASpsQK6zfkXx29bo1PG8K73yXKnvfVMuc9NyG2A0WLdFXiAfiediqubQV6Bh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwNTp1wOsltBnsrh/iC0UWXH+UYbmQM7qEG/oxD+yaE=;
 b=sE96avD1AwQVyw7A823F6eZRspx3zk6znMhEU9gxVMapMLHyNnaDiHX+UGS+3ttdgZqQisdNzNkCt/0R+SStA3iN8K2vCQjs6je5W6JVv6Nd89iVcoju7LZlNJOMytu8lD0mgHZtfzhH3NS/Da/Jn6InYBE+FYFj0vf4H2ahKE7gu077+sZ9bMZDBe6k/pGx8gstcgRG+o6JKHKIZFjBlLJEhpq2OzmnrJpvv0jhgi3HxacXEx2RgvxD4Aalj/1OtePE0fc3q0yNWMDxtsMZBxJy2APB5N24cLvVlbT9c91RRYoYZVW8nbDR4uXsGeoywrX/yNJEHp2OIDVw7YGP0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwNTp1wOsltBnsrh/iC0UWXH+UYbmQM7qEG/oxD+yaE=;
 b=dKr0+2D6gok4R0JS2kJSFUGeEoQ9k6th7ZaINNFKOdIM1+v5Fvcvszv+QqWMNR8R/FouD607TMIfQNVHuC/xu6n8Q1XKOB/2EzTbzBYlPpMqkNvNvByEp/B59GC6EK8uUreCyi39rRIaubYeu10ybDoiZWgSMtPi8SFLN6jTmfiJQ6Phw81Lc1B0qR3RsFsW6cO2XqY9UUCU1Bq1n0M2QS3qchCizz+rf55sNqEudRPqQ73ZRfcNvfrm8EEaGSRDjxZy1YjxiZnh3t8xnRgbOVEFH3VQHj3QTN1HymUS708R8gmdvXiUXfT7vc9XHdIparsOt7TyKD7n40n4rsOsxQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by LVXPR12MB999198.namprd12.prod.outlook.com (2603:10b6:408:3dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Fri, 6 Nov
 2026 11:32:57 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 11:32:57 +0000
Message-ID: <d4b37f93-8ec7-49dd-ac58-6e987d32314e@nvidia.com>
Date: Fri, 6 Nov 2026 13:32:50 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Junxian Huang <huangjunxian6@hisilicon.com>,
 Or Gerlitz <gerlitz.or@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
 <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
 <515a4612-dea9-9603-1918-a9e6b1ca5430@hisilicon.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <515a4612-dea9-9603-1918-a9e6b1ca5430@hisilicon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|LVXPR12MB999198:EE_
X-MS-Office365-Filtering-Correlation-Id: 18bf9ba6-555f-463a-3779-08df3bf9b469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|4143699003|56012099006|261021121427099003|261022105027099003|261022075727099003|261021123027099003|261021135927099003|261009223027099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	FQN9bB3Vq7KVuUTA+K/YTVH+YnMvYH+vgHAc4qTCbSLbiVI7cLYwdabaveAw4SEVHWlzsq90TKyVqmyMqGBzacQzM2CSu9+77dhxLSu9UR7bBojMtgeI2JuWdKpOnxGEkn7VUchFgxiVxY+Xmt0X6B1KQ1D0CBu4hPX2x/6gWuOu5aZk7Jogd5xHNyaUdts8VMdV/Sms0mF2vic5QI76lI6jJnzc9214KI4fRLT+KxXTrC/FG78I1Utt7uKLLzQdZgmduhM2W3XJPzUlbG6hTmgjW7C1ph3DhuMVlpBe7AVHfjymvCRDeVObqVejSHVoKdAkqhF1y65G2irgoNsLhzFIqmMIpnCM25DSqzcsgmiSeEa9bAvbqlF+dSlUKmRtUuIj/JmLBfgDrWhQYy7AUcU4r9aiKlFE+Hog9K0KCaewX8EPhKwPIH6XC+2Me+zMwnM/CSDTCmgASxuJBxpcSXl655O7XsHScUDYkb4geQfLzBSwe6Rm06rSDYRlGCb13NskjwYvYs0fIfPxqZTX579Z196LiCaZeNH3d9/VE7eDPS6lwhIjLjjTjSrHiZ+5QZ6Qt87CEHp8wFWTqy+nINswlP5rQXIMWj34BKzo+/n/hDfF4WMbStx/z86up3Vt0wM++27ZNC81xM5tEh9F3CzFqFv20fi5Dhlghhp18FI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021135927099003)(261009223027099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlBwMmR4NjMyRi8rMVpZaDErcHcxQTAxWENvbEUrRjFSZTlSM1I0Uk83NUh6?=
 =?utf-8?B?blgzZW15cloyNWI3aGY4RzhpbGdHajZnTnh3VWFVNC9vUXZhQzFUNGU4LzVR?=
 =?utf-8?B?b2JBYlFacTROSXdFVVFWVUJtSFJRbGV3S0VxTnZkSXg3UkVzNC85S1ZHNW5M?=
 =?utf-8?B?cEFLUmpWZkdVVTJWY0pyTnZTYUVnTW9NT3d6aXdTcXFwckJoRDAzb3pkMHJw?=
 =?utf-8?B?OUovbUcwb2V1a2ZCNi8vT3krclc0OWtvenlGUm9yQXd3VXhPTFhiRG9IKyt0?=
 =?utf-8?B?Q0x4Yy9sMmxRNkVLRGRhenBheVBmY3NvMit1QkdNTkd4SXdMSlVlakJHT2Js?=
 =?utf-8?B?MDlXZGtPSkZUMGRjTXhlYzFMYmR6czBUazFXRS9BZ0VYVXRLZVNaZ25xZUhj?=
 =?utf-8?B?ZGVoMUJpTGcrR0g3R0ZwS2JxKyttTjljdDNOWVFhVzZFTkFPY29HUUZmSmJS?=
 =?utf-8?B?clQxVSsyd0RFSE1pbEFabUZsejVjeUlKeHFTcGgreXJXNUp2WHpPckg3L01j?=
 =?utf-8?B?cjB3K2tId010cEwwWExEMnNVM1UxM2dwa25mbEJSYzJ5bE91OWovQkszRVZH?=
 =?utf-8?B?R2NZSjltNkMwcUp2YXBzYnVKcHBaR0lIaVVLdkpzeGd6dldGNFFuNEJCWFN4?=
 =?utf-8?B?dTRtUmpaWnFkbk9kbzlxNDhETFRpNkswUXRQNkZOamt3dFcvMkV5WjVPSjBn?=
 =?utf-8?B?bXJpdnhOTlpEeURVZ0xrUVlpRmtsOFNEckxyRHZlMi9XdkFZNU1ua1k3U0tu?=
 =?utf-8?B?UUFnR2g0WWhUTDdpRDhIMVhtWkZPMU1IVU50VnVIVlkzalhITFJ0Qkh4QUdR?=
 =?utf-8?B?R2xxTHVSWFAzTG9PTXN5aEVKL0k0VjBENU9ScXZZSEg5ZGIwbG1KQlRaVXZs?=
 =?utf-8?B?aHV1VlQwbVpqT2pJYWRhU1JBNTExL1hFdjZFekVzN1lGcTJmblJDSUxUVXdR?=
 =?utf-8?B?OGVoRmwwSHprRnF5YkNXQWU5Y1ZWQ0VGQTdnTmEzcjlQWWpvWDZRYmNIQ0hV?=
 =?utf-8?B?N0ZpQUcydXFjTkpKWTUyV282MkVBcDEySmlwdWxJNm1qcjc2SjVaT2VCd056?=
 =?utf-8?B?NjRzSEtvTVB2K2VMcUs5bWJZOUJhY2p1M21mZE5CNDVJV0NuUURudWlhakRu?=
 =?utf-8?B?OXpZSndhTE1vdERMK1kvRXZZenVoRUFNaXREM2lsOHBCSTZmekFZZ2dZRW5Q?=
 =?utf-8?B?MTgvSDFCNmFhSGlaL1Q4Q2ZyMWZwVHVBd1J3NHBTTjdZYlRmcWdCYlp1QS9w?=
 =?utf-8?B?cXh0dm9HdXpueThPSk96MDhsN09ad3IzYzJUZEZ3S0VPTjRFN0NqaVFTNGFN?=
 =?utf-8?B?MEJtVVRhZmQzb0E0NDdXaitIcGd6QWx2NnJlSVJXUXBvM0tZcXlmUDEvOC9D?=
 =?utf-8?B?dytwQU5mQitPYTJ4SFVZcU96U2d4b2Y0TENZcjZhUVVpaGlqeGtVN1RTUUZs?=
 =?utf-8?B?VWpFQXN1azVTTWF3blNESGdPcENxL1lScW4vemJ3RVAxZWJlWGNRZ05OZXpz?=
 =?utf-8?B?K0srb2VVOUR2TGo1L3BvZU9zb0djNVdrWXFIY3dPRFI3cm5IcGlyT2hvSU5H?=
 =?utf-8?B?MDhzaVpPdnFvRnh5ejliZTJvQmlyUzA3elJhcVlqQ3BqTXJibVBNZ3phSmkv?=
 =?utf-8?B?YkY2azZSZkNmb1dTbVlyc3g3SUN2Z2gvdnJYMU8vNzhINlpXWngzVkpKcVds?=
 =?utf-8?B?QmJ2c241TDdqd1hZMHVRV1p6MXd6bVovU0VXS2xlQzRrMWZUTTlvUGFyUExR?=
 =?utf-8?B?cTBnbVByb3ordTZuQmJmYlRoK2xoQXhVU3YrYVliNGxvNWplVGdmbGFCS3Nv?=
 =?utf-8?B?ZG8wenh1K3l0bXN6dVo4SU9yVm5TNTVmZmVYYmhLVFdRQ1h2TUhGcS9pZnZS?=
 =?utf-8?B?Z0lHaWYvOWVQQTZCc3M0UUhOVWdxalBHdVlFOExWRFU0OW54Nmloc2xRdzVs?=
 =?utf-8?B?VzhOTGI0d3A0Nm5BQW91WXVIWkNpeGk2MmZvTUVyZ3pGbDJPT1NIdVBCc1Np?=
 =?utf-8?B?YWFEVFdXRlB4WkVxNjlQVGNIZFRqS2F0eU90WXBKRzdsZk51QjhvM2pLUy9Q?=
 =?utf-8?B?Vm8xY3JPMGY0eVNDcy93dkZ5TTBaRGVuaUtBeUUxOTUxbHh3QXdyeWdoY3ox?=
 =?utf-8?B?RS9PUEV5Sit2dlFTQ3kwNmxpY1JFdVlMbGRBWVhqbmdpRTRGdCtsM1JpSVNH?=
 =?utf-8?B?dVRyU1Mwem5VYXFnRllUSzJPVUdOM2kxUWpuSGR5MVJBUlUwc1pOUmM2VW0r?=
 =?utf-8?B?MEtXRE9sakc2OVRkczF2ckpRMWxYVzRDWHNhN1hsaWo1UDZvNHFRZUZlYjRF?=
 =?utf-8?B?MkdKcVBSZU9XQ241Z0lPbDZmWis2UElkOFNBTCtLTlRkZEZjTHdEQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18bf9ba6-555f-463a-3779-08df3bf9b469
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 11:32:57.1092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB17nKLUdSOtdJ/2GaPeSqljJZrlF/WB5S5czp/wQcLIBLibztEEwc6WlrY7/SLw0hjc0lgEWtFpLlhLhiFIcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR12MB999198



On 06/11/2026 3:45, Junxian Huang wrote:
> 
> 
> On 2026/11/5 15:57, Mark Bloch wrote:
>>
>>
>> On 03/11/2026 17:54, Or Gerlitz wrote:
>>> On Sun, Feb 26, 2023 at 4:46 PM Mark Bloch <mbloch@nvidia.com> wrote:
>>>> On 26/02/2023 14:53, Leon Romanovsky wrote:
>>>>> On Fri, Feb 24, 2023 at 11:14:47AM +0000, huangjunxian (C) wrote:
>>>
>>>>>> We've been working on LAG in hns RoCE driver, and we notice that when a FAILOVER event
>>>>>> occurs in active-backup mode, all GIDs of the RDMA bond device are deleted and new GIDs
>>>>>> are added, triggered by the event handler listed below.
>>>
>>>>>> So, when a FAILOVER event occurs on a RDMA bond device with running traffic, does it make
>>>>>> sense that the traffic is terminated since its GIDs are deleted?
>>>
>>>> Yep, please read the original commit message:
>>>>
>>>> commit 238fdf48f2b54a01cedb5774c3a1e81c94e1a3a0
>>>> Author: Matan Barak <matanb@mellanox.com>
>>>> Date:   Thu Jul 30 18:33:27 2015 +0300
>>>>
>>>>     IB/core: Add RoCE table bonding support
>>>>
>>>>     Handling bonding and other devices require us to all all GIDs of the
>>>>     net-devices which are upper-devices of the RoCE port related
>>>>     net-device.
>>>>
>>>>     Active-backup configurations imposes even more challenges as the
>>>>     default GID should only be set on the active devices (this is
>>>>     necessary as otherwise the same MAC could be used for several
>>>>     slaves and thus several slaves will have identical GIDs).
>>>>
>>>>     Managing these configurations are done by listening to:
>>>>     (a) NETDEV_CHANGEUPPER event
>>>>             (1) if a related net-device is linked, delete all inactive
>>>>                 slaves default GIDs and add the upper device GIDs.
>>>>             (2) if a related net-device is unlinked, delete all upper GIDs
>>>>                 and add the default GIDs.
>>>>     (b) NETDEV_BONDING_FAILOVER:
>>>>             (1) delete the bond GIDs from inactive slaves
>>>>             (2) delete the inactive slave's default GIDs
>>>>             (3) Add the bond GIDs to the active slave.
>>>
>>> Hi Mark and team,
>>>
>>> (using modern & PC language of child devices)
>>>
>>> So I believe that the generic code which is pointed out in this reply
>>> has to do with the general case
>>> of applying bonding over two RoCE enabled netdevs (delete gid in child
>>> A, add GID to child B).
>>>
>>> Wheres the special case of RoCE LAG - namely the mlx5 feature which
>>> comes into play when
>>> you bond two mlx5 Eth devices belonging to two ports of the same NIC
>>> is slightly different - b/c
>>> the two associated rdma devices are deleted and a bonded rdma device is born.
>>>
>>> In that case, we saw this week that the connection breaks, likely b/c
>>> of the GID add/delete
>>> thing etc and for no reason user-experience wise - the user sees one
>>> rdma device the device has
>>> two rdma links below the cover, one is still functional, why break?
>>>
>>> Indeed for LACP mode the session doesn't break.
>>>
>>> Can some enhancement or fix be applied here to make it work also for
>>> active-passive?
>>>
>>> Or.
>>
>> There might something we can do, can you please try the patch bellow?
>> it assumes fail_over_mac=none is used with your bond device.
> 
> I tested this patch on our hns RoCE bond device (with an enablement
> of the new core_cap_flag in hns driver) and it works well.
> 
> If you're going to send a formal patch, feel free to add:
> Tested-by: Junxian Huang <huangjunxian6@hisilicon.com>
> 

Thanks! good to know. let's wait for Or's input as well.
I'll submit an official patch next week hopefully.

Mark

> Thanks,
> Junxian
> 
>>
>> [PATCH RFC POC] RDMA: Preserve fixed-MAC bond GIDs across failover
>>
>> A provider supporting bonding failover can redirect existing QPs to the
>> active physical port without replacing their GIDs. Deleting bond-owned
>> GIDs on failover clears their hardware entries while live QPs still hold
>> their indices.
>>
>> Add a per-port capability, advertised by mlx5 RoCE LAG at registration.
>> For active-backup bonds using fail_over_mac=none, skip the failover GID
>> purge and allow bond/VLAN address events through either associated
>> child.
>>
>> Keep address-change, address-deletion and unlink handling in place.
>> Policies active/follow and providers without the capability retain the
>> existing behavior. mlx5 still removes old-child GIDs and updates its
>> hardware LAG mapping through the existing paths.
>>
>> fail_over_mac=none must be set for this.
>>
>> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
>> ---
>> diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
>> index 4a2a4638b476..3fa7d5b499e5 100644
>> --- a/drivers/infiniband/core/roce_gid_mgmt.c
>> +++ b/drivers/infiniband/core/roce_gid_mgmt.c
>> @@ -141,6 +141,22 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
>>         return BONDING_SLAVE_STATE_NA;
>>  }
>>
>> +static bool bond_preserves_gids(struct ib_device *ib_dev, u32 port,
>> +                               struct net_device *ndev)
>> +{
>> +       const struct ib_port_immutable *immutable;
>> +       struct bonding *bond;
>> +
>> +       immutable = ib_port_immutable_read(ib_dev, port);
>> +       if (!(immutable->core_cap_flags & RDMA_CORE_CAP_BONDING_FAILOVER) ||
>> +           !netif_is_bond_master(ndev))
>> +               return false;
>> +
>> +       bond = netdev_priv(ndev);
>> +       return READ_ONCE(bond->params.mode) == BOND_MODE_ACTIVEBACKUP &&
>> +              READ_ONCE(bond->params.fail_over_mac) == BOND_FOM_NONE;
>> +}
>> +
>>  #define REQUIRED_BOND_STATES           (BONDING_SLAVE_STATE_ACTIVE |   \
>>                                          BONDING_SLAVE_STATE_NA)
>>  static bool
>> @@ -159,8 +175,9 @@ is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u32 port,
>>                 real_dev = cookie;
>>
>>         res = ((rdma_is_upper_dev_rcu(rdma_ndev, cookie) &&
>> -              (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
>> -               REQUIRED_BOND_STATES)) ||
>> +              (bond_preserves_gids(ib_dev, port, real_dev) ||
>> +               (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
>> +                REQUIRED_BOND_STATES))) ||
>>                real_dev == rdma_ndev);
>>
>>         rcu_read_unlock();
>> @@ -248,6 +265,18 @@ static bool upper_device_filter(struct ib_device *ib_dev, u32 port,
>>         return res;
>>  }
>>
>> +static bool bonding_failover_filter(struct ib_device *ib_dev, u32 port,
>> +                                   struct net_device *rdma_ndev, void *cookie)
>> +{
>> +       /*
>> +        * The provider remaps existing QPs without changing the bond's GIDs.
>> +        * Either child may still be associated with the RDMA port: do not
>> +        * depend on the provider having processed the failover notification.
>> +        */
>> +       return upper_device_filter(ib_dev, port, rdma_ndev, cookie) &&
>> +              !bond_preserves_gids(ib_dev, port, cookie);
>> +}
>> +
>>  /**
>>   * is_upper_ndev_bond_master_filter - Check if a given netdevice
>>   * is bond master device of netdevice of the RDMA device of port.
>> @@ -771,7 +800,7 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
>>                                 .filter = is_eth_port_of_netdev_filter
>>                         };
>>         static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
>> -               .cb = del_netdev_upper_ips, .filter = upper_device_filter};
>> +               .cb = del_netdev_upper_ips, .filter = bonding_failover_filter};
>>         struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
>>         struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index 4e5180e097c6..28b1c4debde9 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -3537,6 +3537,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
>>         immutable->pkey_tbl_len = attr.pkey_tbl_len;
>>         immutable->gid_tbl_len = attr.gid_tbl_len;
>>         immutable->core_cap_flags = get_core_cap_flags(ibdev, &rep);
>> +       if (mlx5_lag_is_roce(dev->mdev))
>> +               immutable->core_cap_flags |= RDMA_CORE_CAP_BONDING_FAILOVER;
>>         immutable->max_mad_size = IB_MGMT_MAD_SIZE;
>>
>>         return 0;
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index cb3b6163961b..cb9e52b8ffbc 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -650,6 +650,8 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
>>  #define RDMA_CORE_CAP_IW_CM             0x00000008
>>  #define RDMA_CORE_CAP_IB_SA             0x00000010
>>  #define RDMA_CORE_CAP_OPA_MAD           0x00000020
>> +/* Existing QPs can switch bond members without replacing their GIDs. */
>> +#define RDMA_CORE_CAP_BONDING_FAILOVER  0x00000040
>>
>>  /* Address format                       0x000FF000 */
>>  #define RDMA_CORE_CAP_AF_IB             0x00001000
>>
>>
>>>
>>>> and please read: https://wiki.linuxfoundation.org/networking/bonding
>>>> especially the section that explains some of the restrictions of
>>>> active-backup mode.
>>>>
>>
>>

