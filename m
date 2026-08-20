Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012015.outbound.protection.outlook.com [52.101.43.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83A3B19C2;
	Thu, 20 Aug 2026 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787232507; cv=fail; b=M85Frcsy4RwYASeT3s7mhzMqy+tcHixWD9REenosxrTXzLFha/9ElGiZ0fv71nmU8HedFDr9NH3W+hObNnUkNwpclwYf7Xkyqgjt5tbykP3UTLPbIZSmPeqVbq+ZHBzO/FFVAwa/VC4fWOfIsh1LcewPIa3P4sbUSWZtDI5FJMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787232507; c=relaxed/simple;
	bh=ZEdchA7bJOpIS7EoDs8tYdihIAtcerNJj2MCIoMX1U8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WqyjZ9naxLAnEw1MJOS0TDk5fctC5dv30mVZR5b4gKvg3TsMZNaTgCGAGnni8OLn4Wav0XeobQ1FojZGupteC4WjUlZ67/gJmaOBrRYk6W/qWQtfNbrkV8iNaz72VElNN0umiPoaCeYvi+e3A6pPeXindzBrGwnqljVRoCd/U+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KlbukxJ+; arc=fail smtp.client-ip=52.101.43.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KlbukxJ+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ju7R1hWEARv1ijUIbhEFjyN+HZ1NBTVyL5Ijxy60mCBRkx4MlZaEsnJvWeLbusuWSJCInPer3LOLu9k523G5fYnBo3iDXwrdAnhsSPA5CcgEGn9UIT7uSHY6oRo15ggFs0sRx60u6Dpv5LuhtB+119jYLpubBhBos0gf+Xd7Q+dQVG2dsABVybjYYaN4aTxZ2KNLyB4GHiPDP8hu27eXOcokaeXEjckIKmPhx5MTqesSkSa/Fc3kCiexHwnWkoyBSZQ7y1lTyGwrXAiHsbB4Vmrg6FWSpnsxTfK0iTe1HtJmQdBqHg3BF3VQ4+xPanYLnKIPyYHbUBqJsEKs931b3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWuvBIfB/Z9uBJr2bhveR/kjXYtC0IXv4AxIeP6e7dk=;
 b=TCwgSXU20dKl759iPi7u1nf7/NAWjGM5K4ZMGPDxZewvbodvooTnvoQYMWsaUJNjv/Ok0RtbIDpFeFr6vfH0NyXdP59VSaFmCbkhIk/5A6rPX2ycOEXv73OUqrPJ6J+SMFfmR1W931nbT31pCnOs3j8kQ6AjbObRV9E6CUCeSz2NIqyDCUc5OMvwQT+r88nrLSJQrRFvE//eL+gEWAUlN7ZdFioG6HxOLqz8Z7eNNHwFffSIBJcPhUVGhJy4Is4DdRhUkXVSwz9zo3fbjBBPdr84gv5VqbBc6DInUAqsp4/ilnMrnSjQP2j8cE6mKqO8nZOMK+IGM12WJ7eHgORpFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWuvBIfB/Z9uBJr2bhveR/kjXYtC0IXv4AxIeP6e7dk=;
 b=KlbukxJ+SsIa5eZnBJRFBsPOkXjLdjRc3UPFk3KVlg1oApb+4xR5eY7o3xKDpIS/vX9n0pqhzcrH15IqePbXfNoKlkShralldKmNP9KkxyytLYkZ+LWco0FEEz1ASpo2gXDht7/jGDhJBcQ86573a6PHNvYKTGhCS3dCtQ7MEzgD0by3SDrn7MV8RZ71nj0iYCH+gsvi0Kdy6aRTuNtBtC3EcsGmL0oiGdCydlfcx469amI7HFc6s7yfU9vPoNn+cw6eoiVJtK6EtkxVtk1ADkV/LGZpsiqphu5OXJyTwkrTSWKfiQr2KD+WiSL0MUNNMYyflY06to5Sv0zOHasIMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by CH3PR12MB8910.namprd12.prod.outlook.com (2603:10b6:610:179::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Thu, 20 Aug
 2026 13:28:19 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 13:28:19 +0000
Message-ID: <000f10a9-481c-403d-9240-67c65f69638b@nvidia.com>
Date: Thu, 20 Aug 2026 15:28:14 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v2] net/mlx5e: SHAMPO, Fix IP length overflow on large
 HW GRO sessions
To: Jakub Kicinski <kuba@kernel.org>, Tianyu Zuo <cosmosocket@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Khalid Manaa <khalidm@nvidia.com>,
 Ben Ben-Ishay <benishay@nvidia.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260817181618.2786456-1-cosmosocket@gmail.com>
 <20260819160303.4be803c5@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260819160303.4be803c5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0110.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::20) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|CH3PR12MB8910:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cdcf1c0-d3da-47f4-3197-08defebee5d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|1800799024|376014|4143699003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tAnA4BJ64BQV7+1UByJTeBNAmE6oMO88XBSQBkFcc65KM5Zyp9Id8jJ2q9AZrU/SG0IlU41gBcPzj5oqB4tJp6/WUbUkzMlwkU7oUMo4dFjtuNfCL1duecDEwsWi+A9WIDrdA5rUDJfaTr2HBdPBW4jgStHkJ1yqa63Hg8SZQOsIeXcVVdKpQldn2MAGaAQSK9L6gubB1wYhHBAS6tIRlEoJ46Xv7Zb17nFucGK3+Z6bMrjrG+02ljy7hYNaCDrtjWxVp1ZwVMyzI0fjdNY1OzqS/LANTdNcJCMyMqO/scrWTCo6F455WgVq5VoQMH/CzNFo/symOANC+bq514ryLtdNYrlWWfpaIhMrblq7xNDtem+XbWTuuP2SqPd0ElJPwo0fdfC+DG7J6MWDfa9Phr14uGrqPUYo8LhWJT+EovAyIYo8oLfL1IyTCfHwD+BwYHSzsd4hXeecFls5+/1Uw9ck4gsIPwMqMfbotiHlAe92Xcgm2nRPYfeeSarsoSn1cFczZV89Hh8Tftj1/tWVCZJHy7Sd3ysGoukUewVf6IyZh15Xyk3F1ayEWFof3HcxrbH9MgDz7+gC0vz5rjek6CT2LsdsaPD/4jeEoIZLqZHD98qMxg86c7GtPRHm0yqYwHrjgCZp0doKYhzmrndTgOxH6FVkS1xhvpjfSMmI0uM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(1800799024)(376014)(4143699003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0U2bVYrbysxektoaU5MYzdJaGN0QUlIeGEzNlVQUVIwQjJEeDNOaE4ya1ZZ?=
 =?utf-8?B?STNvZnlkeHMyeVVyVWJ1VzlPK3krQ0ZjRFk0NkQ3S0Y5TG95Nnhwamp4UEFN?=
 =?utf-8?B?U3p3cXNxaDlESzBvZjJoYmFleVM2d09PSXphV1pCaGpPQmRWZ1FPbkVkRnYw?=
 =?utf-8?B?UEpkeFNnRHRubkdhSWNkVHd2d3lxc3pnQWxKRG1tTzIwaUFLaUVzcTB0RUxy?=
 =?utf-8?B?UE5GamZFMUVhWnZBV2pwUXcyNGU2NFo5aW0zT2piZ0FZZXNrRXE5Rk56L29Y?=
 =?utf-8?B?UFVJUVdER3gvdmk5ZnBxU2J6Z0EySU9XMDI4TVBuUDF0QndtemdVbjA4VS9X?=
 =?utf-8?B?NVBoc3QvSnN2ZVQ4UlZDcTl3dXEreEJRRUF6bTNmNmdhQm95UXlmWUNHQjR6?=
 =?utf-8?B?YXo3ckQ4MjRxR2JMUHZOL29UdEVjNDlWMEoyTnk0NE1lTno3aVczMy9kMGpZ?=
 =?utf-8?B?VldJYmp1OVd0YXBJdmlQUGlYZ3FFZmFkTHlZTlFEdjcyazcvQlFLdGhHN1dE?=
 =?utf-8?B?VkNSRTMxZ3dINERvUnBocis4Nm5BTzJrdEFZbWFKbkRMNVh0UlR3dStza0ds?=
 =?utf-8?B?V3o2TzZGVWRtTSszVEFjUDZZWndhcWF0blFZS1BYc0txMDlrdVA4NlhKVTNz?=
 =?utf-8?B?KzcxM3g2M1RtUngwbGQ2NHFxYVhHMklmc1gveEFScFVpNzJDcnJuZE1lWmZY?=
 =?utf-8?B?NWlKSEV4OFljcHdmZDhTQ2dVQVRCcXZvMmdacXlFVXBjMWdkRTY1UkdSd1Vo?=
 =?utf-8?B?bEtsNjJHNUxwMTBrbEZqKzFidXBJdG5UK253T2t5alRtWnhVRDNmREx4SStC?=
 =?utf-8?B?K3hXUm0vZDNtenoyS1hwNlZYT1QzZXRzSGJ6dGwwY1lrNGxUTGIzNVBPZTdU?=
 =?utf-8?B?d0Vsbkt3NkQ3cHhtbnBFKyt6cExWcFp0NkpOYkZZN0VOdzQ1MmM0V1BkWGEv?=
 =?utf-8?B?T0Zhems2UjNEdEg2QzVQRWF4dlF2WkxPeldkUHFaZW5LL21XS3JKblM5TmJy?=
 =?utf-8?B?MTZkT3MvVy8yeUpraFNuME1vWG1iK20yWjR4M0tZMkh0NHBOOE5LTk1CbGxI?=
 =?utf-8?B?SW96SlJFZm91TVBpS0dyNkZjRklhenBEYmpXVHMvUmQ0RmdDKy9Qd0VwWDhR?=
 =?utf-8?B?QXhvbGVGN1FLRVRQVDJYcDMwVE0wQ1JsWTV5T0NYeXdhcUFnRy9oMXB5Z2Fp?=
 =?utf-8?B?T3Z6NjBwTm50UkQwS1Jyc0NZK2Q3VFZQQjgzU3IwRjdoS0c4bE00WFZEQndt?=
 =?utf-8?B?OGFzM29vTnNRWFVaNXJiWWFLZ052MGIrOUlEQU1DQlpWR3hrYTZaRWNLd0R0?=
 =?utf-8?B?YXVrSjFXS3ZZNnlyRjlGUjFJY0lMSkR4K3dWVTd1R0k2MmQrQzBkQ2YwdDFn?=
 =?utf-8?B?QnJ2R25HQU1XS3pjeGxUdFluSWdhMUUvazVodU1FNEFFdXhUTkpFanliMHNI?=
 =?utf-8?B?MVEwQWkwaXhNWE15TVJPNjRXYmliR2Z5V1lXa09ZcUlwT21oeVpZZkJWREVy?=
 =?utf-8?B?ZmhPT01RQmYreU1tQ1kwWDlSWVprcFdHNkhHNUpPSkxNUWllemwzNkV3VEQz?=
 =?utf-8?B?Z0lXeERwdFpyWUZ2VHFBUXVvOHR5UWgzUHNnbkJQME5jcnZ4NElOZnJtM3pU?=
 =?utf-8?B?MFVYb3RyRnNGU2hYOVlYSWxHMlJLSTdwTUdiangyZHdDL3Q4UHZSZVdnL0Fm?=
 =?utf-8?B?MFczZms2OUZhazNWbWtKNXp3NUNWakF0WUVCMitWQ1lrVXJNNjFreExGdDBn?=
 =?utf-8?B?NDQyUWlCMSsvSHdtL2pnaGJ5aU1MamtQRlBZZ2RMMFAwMCtxOVdrckpsOTVK?=
 =?utf-8?B?bXFabWJIQVJtRC9LdzJLTWdqUGlMZCtpekcvallSZFBMeVp2bThnd0RqZUdQ?=
 =?utf-8?B?SjJndWxiamFQSlRTbEE2THRKcmNTWlFwQmkxMnBWek1qQ3FQU3kwbXRwL2ts?=
 =?utf-8?B?L09Kc000cENsSnZ2ZWZhckVESFRUbXdwM2Fud0ZUVStuOXZsV2NQa1REUlZy?=
 =?utf-8?B?NjBDb053c3AzQ0pMMmdNRlNOSDdUU3FYZ1R4V3QvV0hqZGl0TVEyYmltVXdi?=
 =?utf-8?B?NU5ScWtvZnV2ZnljbzNheHNTWE5RY2JHVVluYkZOY0NBS3htVU9pSmdsTmh2?=
 =?utf-8?B?MVViU0RjbGhlditVTW1zUlFYY3UxNVdJNW9ubVB6dTc2UzB2NnJXMlVTUnEy?=
 =?utf-8?B?Q3ErbnZGUjQ4QmoyNU40R1ErWHdOSUZSeE9PQVZPcUtCdGNMODcxeFVCYnBo?=
 =?utf-8?B?c1dZbFRPYWMyVHNmbEo1QVB0NnVDMzUzMVlRaTdtaFVMY0E5b2lPeTFINjU2?=
 =?utf-8?B?L2dFbFhvOHpXd0Q5MFptUzV5N2dFNzlyemgwVHRrT00vNllzUkp4dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cdcf1c0-d3da-47f4-3197-08defebee5d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 13:28:19.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aB0UBCc3VgSO2UNl36FsD7QReT3T68zMBWWqQs+R/mLN+GUruIQnTeyxpyIz+LmTqaW+wDKyoIa81uL9sZAwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8910



On 20.08.26 01:03, Jakub Kicinski wrote:
> On Mon, 17 Aug 2026 14:16:18 -0400 Tianyu Zuo wrote:
>> mlx5e_hw_gro_skb_has_enough_space() bounds a HW GRO session by the
>> payload held in the skb fragments only. The L3/L4 headers that
>> header-data split placed in the linear area are not accounted for, and
>> the limit is inclusive of GRO_LEGACY_MAX_SIZE.
> 
> This regresses both ipv4-large-rem and ipv6-large-rem on CX7
> 
> # # Exception|   STDERR: Expected {64896 600 600 }, Total 3 packets
> # # Exception|           Received {60840 [!=64896]4656 [!=600]600 }, Total 3 packets.
> 
> we could have fit another MSS into the aggregate, easily.
Uh, yes... thanks for the early warning.

I've wanted to improve this function before but had a mental blockage on
the page size difference. Looking at it with fresh eyes I think we
can make it clearer:

+static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
+                                             u16 data_bcnt, u32 page_size)
+{
+      int nr_frags = skb_shinfo(skb)->nr_frags;
+
+      if (nr_frags + DIV_ROUND_UP(data_bcnt, page_size) > MAX_SKB_FRAGS)
+              return false;
+
+      return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+}

Maybe we can squeeze more out of the last frag page, but one too many
extra checks would need to be added because SHAMPO might have moved on
to a new page.

Thanks,
Dragos


