Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794404335;
	b=Gok0hWTR7KYyTazshN5TrNaAGFm1KT5bE5NvywbUQeNwurKiTJNx9DtV+EuOdRFesKuT
	 lLR6viFV4hsRjsIsYirq+8KmxNlOc1JFTKTLqpNbN4y8VjsYQPRxlli4jceZW6ywu20OR
	 V9l93xt0pdqjQVe3ydAPrjvRvj3DC6kEM1ApCYhHZ4tngfsomi7M43lxR+wyE8H9rX9aS
	 vpprmYESUv1Z0Cly5qpbBu3GKwzt9r6tUiwCg3RDJRkXV4+Zmo/GUrbPQAxL9N2rqwRzg
	 LX0JVutd+QRPYJ0bo6EwgxiSWDHIU/SsMqQq7wO5GdG3iccbj7C9m3TVh8mUP0eIXNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404335;
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
	bh=VFm+JKbx8Javeaf6+9inxFNTjv7zM8+hoXw89EI2Ffw=;
	b=BHTIaTMgLEBFPbm8wZCIxKSDPvqMQzdZ3H055ONUYrvY5zfwFBv7xK711PQUZMy++4h6
	 JbvkupVbcpnDWEnEn/gcr85mjQ1p74KC2yb+ICi/RfrasPsSkB+K2MtE/F17gc1ElwqzL
	 sX/lHIadEbB3Vw8sPk7ZePPNQ8st+MAzMJ4SVLngAfr9VNTmcfzTbJLcdBg4JKRsmuvAy
	 cecxqwd6uRNrkujUrh013zboV91HcXkViPjztD0sPba5JKI9qLE3yv9l/4ja8IHl29g24
	 6+k8BiNfS81XDipXpMEVt1yGdNjRREAmLiQlVB3p/kFB4Ol8alNv1jHfl7dZ13eq+yA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Of8Z7i9J;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.48
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010048.outbound.protection.outlook.com [52.101.201.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4492A606A330
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4492A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Of8Z7i9J
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnEoTX52N83Jjr0qoq0T8ezkrhEQAgJhmdid43VJ4Di6KpXcHRI8xFz4a5FOcWnwym69IvkUaHQwDDXfEcX45Yu/et6vGXgA0dbZK46e1dM14SoNaSZ/zUHc5xpcPVT4qDsc7P1gsWNgRG7q4Rxrmx7J8eCPQ1onC28WKSZqtv2B7hh6cfVmFFgJbgPfPdVlNOoFUpQrjcOEtd5Uz39F8t+54jYvvlgccbmCaTBKL1ym4P085Pfy2ox6NFHizw0J65LKPH7qTrRkK8ePI0sDEpPeDjrXAXQuOF648yG4+btKQS7tAL4yhWZBwleGEKzradyoaPFhlw2n6BlB8A+m1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFm+JKbx8Javeaf6+9inxFNTjv7zM8+hoXw89EI2Ffw=;
 b=msW5q5OPfkL2fczoB7FlEZgj3bEdBkfXMuhUzbGrtZ8Uax61yDuLpvG5tF8VGQerJWYDMqitvbyRMoLV5FC6g6rt/h6glvJoPqjSrQ/Qyt2eID2y4LEHPPjq3uxVj2ILLJbbI1iHJhnnT7PEtnFo0+ZpSzeCl1JNHGLtsBOwGem0BgOyqnGvffRc2u78XAaUjxtZ2byxdka1WPQ8JsvGZaxzCvjvoKnCf0F/0HOrG4BqoVB25W3xemoR0aY3ZXJhH8v/Weg8KmuVAaMfAh/dTx9vCFf0dIIa7P6U6wovIr5apAPbRLbg2RB1C4HVm/jg1fipG0IZXYd7SfKnQ4RJKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFm+JKbx8Javeaf6+9inxFNTjv7zM8+hoXw89EI2Ffw=;
 b=Of8Z7i9J3jECIG4c5Zje9GQblCLOMDzdRbr7bosdpB7To02bfCeLPZWkBArhid/vNbQTNj22/lOvD/oH1w9NB0Wvis5ItHmKFwMm9oDu1LgqByW8xMmeEJGurnEIxdC1x79+BLb+ix8EegHtuHcPIFRU++UcluZCo1ihhgb/FELj7IHUF9Zllfv/kvzqZvZI7pxslsLQ8rfT8TD+YdQQtJILYXfRqKzVZtF7lTOKyX2EwBO32gA48iI0Jv0V9rAVV1/ZS2I+gZdLgxwDcEw3SahBviqE+u1PFQXZq7A1cZdIYHPBxWyJQimJQHwrfCf8HLlhcRh8AJdeGqQerZFttg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by IA0PPFD7DCFAC03.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 13:38:52 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 13:38:52 +0000
Message-ID: <64c8de17-dac8-4880-a9b8-63cba3c8c458@nvidia.com>
Date: Wed, 11 Nov 2026 15:38:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 5/5] RDMA/mlx5: Expose NIC_RX_CLASS flow table
 type to userspace
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, Mark Bloch <markb@mellanox.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Edward Srouji <edwards@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
 <20261103-rdma-rx-classifier-v1-5-1ad6c8cfe936@nvidia.com>
Content-Language: en-US
From: Michael Gur <michaelgur@nvidia.com>
In-Reply-To: <20261103-rdma-rx-classifier-v1-5-1ad6c8cfe936@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL0P290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::18) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|IA0PPFD7DCFAC03:EE_
X-MS-Office365-Filtering-Correlation-Id: ba03551c-3aa1-4a1a-31f8-08df3ff91f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|4143699003|11063799006|56012099006|261022075727099003|261022105027099003|261021121427099003|261021123027099003|261022113327099003|261021135927099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	2d+HxAh4LDZAt3i7y4RL2rcIqfF9wFytzCG4i9zqD8Ar9/VeKuh2M5V4SDKKzjmuJZjzMX7TX/+1JwYXMXTf3xJfG4//7KA3VbassBUpPmCWUvDi7no7pU9rYkReHuxdCOGREZqSkUQwfX/NiR5iVP2grQ5sMwepW8xx1YRQRENBOrYsEF7Ae6KjYk3NA2+A7XJ8fct5NAkcvyHyJ5Pfo5//aVhB0SBVgZl0GrH0TSdtvXi2zPrs7IGx3owLhWz9XOWMaPyujs645+lmUhMR5Eu6zcP5DdAshpxaN8V7I6cgPT1xKVQzvNElBioplBWf0PTAPO9aot/M9GFvaqZQVV0BfHfBVqAlF0ZCsyPquAS52HR5v7MqbE6+tWqnGPnV9Fha4I1U7HWm+Y6IZ4vzxYpeqoyWYS3SDJWqq2G7b4/liq6wXuwFA8eXnmLuVAJNuY+VQUtDrgkRM3JnenPpdLoMY/FcRGs2tcr7ZDP2XpsCz7sTo7IKGm9PhH2Uau25/gtn+Wna+sYBn622XucfG6qtupE8VjjF/5eSekDbxje1LszIQcEP9lZymAD48sDoMivBT5hRlfbF/G9+gxJWq6Ft32RbaADzVczXkR14wOUQjKz9JRp+smhN4/9dUBrpqHKjSF6o+ipm99bvvUwehcnr+1PmGfL8K8+V6a8KmmE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261022113327099003)(261021135927099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjJVMWxJU3orTUp6RUdnWlUxT0t6S0FuclhjSEJ2dDFFU2xiblErRm9mVW9W?=
 =?utf-8?B?Mmd0SDV5QU9kMWs3OHRnNGJyZ3BnL1F3MXNVWGxZTGdSK3R5Z3BhazNvWkpW?=
 =?utf-8?B?TlJnd2JRTnBxNklLcUFpVzRMOXpPOUpKOTdOdHowN1U0d1Y2TmtNb3E4L3Q3?=
 =?utf-8?B?N0RRUFVVN2YxMUtwbDlDVCs3M2JFWHE0bzZVdFdqdG9XYkxRNjdmVi9tdlZ0?=
 =?utf-8?B?Nlc5QXdGell3MUwzS1FHbjhnbFB2cjBFbWVUZzlvTm5WT0pwVzFyanpmWThy?=
 =?utf-8?B?U1d1NjQxU1JSMjFIYk1OVWpydTM2L0JwZEtRN0QyUUFReU5EVFdNSG5HRlYy?=
 =?utf-8?B?b0M5Q2ozeWRWV0NaMlEwTjBCeENCNzhMNE1uN1lwZ2tFY3djY3QwOEFZSHdU?=
 =?utf-8?B?ZXlPVkVQSk8zWE5tL05SRTc0dDJPa3d2S21uTjVPclA1dElTd2I3YWVpMWZJ?=
 =?utf-8?B?eEN0VVhjUEJGVE1kdExjalNEK01HZmo1RlUxbjRZZHE5OENsdmVRNkMzVUJq?=
 =?utf-8?B?bUtpWVg1NDVpZXJjQVdwNkdOalMwd1QwenJjc0FjNWR4alh5RlVQM2tuOE4z?=
 =?utf-8?B?ZFRDYXRtQ2RHRWRTMVd5WWNsbndxR0FJdzhrbkdSS3ZQM3BHN0E5SU5hVTc0?=
 =?utf-8?B?VzVENkQ1TUJ3MlRVQTBxY3FsYmtER1p2RzcwWlBJMlExOTJpM0E5VGRubHB2?=
 =?utf-8?B?SUJrWlBBNmloMmdpU0dnOEZvclNzaGRDSURHZUtNczVmbkRpZDF3WEtxaVI4?=
 =?utf-8?B?SVJMV1BVRFg5RE5TUzZSc010bTJBZ1lUSGVnMjdDZ1I5K0x6K1RvN0gyeVhF?=
 =?utf-8?B?VWI4M2VoVzF6TXQ4d3NDV2lFQjB1OWlQaXkzZktBYTh6U1dDK0czTkJmdmF3?=
 =?utf-8?B?ZjAwZ255TFJ1WGFSS2FsanI2bHdCcWZSUHZmdzRQWXVDYXhEMXlhQkVjeDlr?=
 =?utf-8?B?cm5NS3VxYjZuMnZLUWpJdGtXamxkSWR2emlza1pyendRTzQyTU5wMGJxdDZy?=
 =?utf-8?B?dDlBVUt5MHVyTmlMT0xUNUJiRmZmT284SHljSDlodzArZGRCaEJxNjJSdC91?=
 =?utf-8?B?T3hzc2VKdzZycnJhVGs0RGx5OHM0WFp5N3NxcGxFbW9pTVVLWUxmLzVpTjgy?=
 =?utf-8?B?bC92R0RKbGlGQU9oK0pHcmU3WnF2UXpNREZpUVE4RWZsLzJKc1NhOXlWKzh5?=
 =?utf-8?B?b2F3MVduRUNuVjFFN081cGgvZU10VWYrK0Q2R0cvT0J6dFM3S1I0M1hSV2RE?=
 =?utf-8?B?VDY5OW1JNGpGM1E5TzBLb3F6VU5QTGgvb3lXdWNJWW1mSVVzUVNsRWVPZEox?=
 =?utf-8?B?WjVaUnFld3BFclFsWmV1R2NmT05LTlYvOFp0M1V2bk1zcTE1aDd6VG1CUGNh?=
 =?utf-8?B?aFBLWGZMcXZOTTRxY3FYcVJ2RWtZWmtOVVFkZ3JldW9aOGZnT3RvYkE3MmVn?=
 =?utf-8?B?T21BTjlNZVdITUhzczZIcHZMNTN0Yy9ua3luNFovMUN4cnBPQU1LRVptaUYr?=
 =?utf-8?B?bXYwdk03ZmRIMVVIbnNZRG1ON2VFd291NXdXVWVNMGxKc21LaXRiVmJLZ0JF?=
 =?utf-8?B?OTBLMkhtZFo3VVYyWXhJVUpLcnNoZVRMVzB0VSsrNGliTmp3SmhSb00wb3pk?=
 =?utf-8?B?WHFwajZLWFROQWJFUUh6ajZOUEExSVg4QVl3Y1VjSDVQb05GcGNURlk3M05x?=
 =?utf-8?B?c3kvNkRacUtqc3kxcnp0dHZFemQ2SnZUeDYxYklXTUx0bXZNK0VWSW4zdXRr?=
 =?utf-8?B?U0FEUFpXUnJJcEVuV0N0R3NiQ1pLYnVLcGozYVZTc01acnFLYVVpTzZaMnYy?=
 =?utf-8?B?ejRSR1c2TnJWM1cxQzlTay81cVk2cVpVM1M3Q090L3VPUEpjOGZqY3lVMUI2?=
 =?utf-8?B?NjdEUi9XeU1LOXpNYzlEVXNlYVNSZkJYTU9tMUJsVlgrNXhQNTl1azM3b0hQ?=
 =?utf-8?B?VWZmZWtBQ2lIN1owQXE5NDJ2Q3JuSGM3Rk92TWZ3TE1oNGNocDVPdkY0S01W?=
 =?utf-8?B?OStMZ3J1WG1lKzVXZGdZdWFaNnhTV3lNOTVZYWFrQkJPWHRWYnBzc1R1bnpt?=
 =?utf-8?B?aVY3VVJwN2ZoSGUzWXFENHpSMCttZ0FzYkxac2ZyelFhVjN5UlhmUlRnNTU1?=
 =?utf-8?B?VHBtVElzUXhxOFNjVjQ4QmgrOE9FeUQ3V1FjQlM3T0VuUDk0SjBzTXpJM1Ix?=
 =?utf-8?B?SmdxeVBDRlJvMk03WnBCd0VHeWdmRXBCNkFsMHdOUlhNYldqWENNSldLcWYv?=
 =?utf-8?B?UXNGcFVwYUhzQXZBam1EVlVLV3NtT0RMU1dZUHhEbmlCcEowaDlhT2pKeTkr?=
 =?utf-8?B?SDRYdlFZTDhzcHpRelpTT1dHMitSZXczU2FPZElGNFltclEreGhqQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba03551c-3aa1-4a1a-31f8-08df3ff91f8e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 13:38:52.1644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vw/jfCKsBHO6fw1RczcoGfYfhxVzsMxlEu5dVcX80/07r2hYUHlV1KCJ39rceGiYjISpBwT9/T+pIwbpI7/OIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD7DCFAC03


On 11/3/2026 8:12 PM, Edward Srouji wrote:
> From: Michael Gur <michaelgur@nvidia.com>
>
> Let userspace create matchers and rules against the new NIC_RX_CLASS
> domain, the same way it already can for RDMA_TRANSPORT_RX/TX: the same
> per-vport ib_port targeting and eswitch-manager ownership model.
>
> Classification only tags a packet: a rule matches it, optionally
> rewrites it with a MODIFY_HEADER action to mark it as RDMA, and lets it
> continue down the RX pipe rather than steering it to a destination of
> its own. ALLOW says exactly that. It is the rule's terminal action,
> telling the device to proceed to the next steering domain, so a
> NIC_RX_CLASS rule carries no destination. A flow counter may be
> attached alongside it.
>
> Expose ALLOW to userspace as a new flag, matching FW's ALLOW FTE action.
> It is limited to NIC_RX_CLASS: no other namespace's rule creation
> accepts it, since its driver-side handling and uapi flag are only
> meaningful in terms of this domain's semantics today.
>
> Signed-off-by: Michael Gur <michaelgur@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>
> ---

Please add this paragraph to the commit message before applying to 
disclose the limitation this new feature has:

NIC_RX_CLASS sits ahead of NIC_RX, where mlx5 IPsec and MACsec
offload decrypt received packets, so classification rules see these
packets still encrypted. A rule for an encrypted transport can only
match its outer headers; if that is not enough, encryption offload
should not be enabled on the function. Unencrypted traffic and
encrypted RoCE, which NIC_RX_CLASS passes on to NIC_RX unchanged,
are not affected.

Thanks,
Michael

