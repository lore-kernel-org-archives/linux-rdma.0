Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795197995;
	b=hPJNScizKxDF6IdTu1cor2uig4u1IHQEzYOeg41kPVkLdxIK39SFsMoDdCHEbY3lWaeF
	 lHQMXH6F+69421Jvyh97KZBki8LyIEwBL74BwrY8OqJbnHZQhP80F30sjoireW5Xp3g+m
	 TnmtZR3mcY9ZI7KgbKAbmec6vguLp7UmqUnPIbWYMlyvdgvxxadLb9eB2G09l+b7G6ktA
	 Txg5W0XqWtAQMLOLHzyqTZ7BsB1maxEAXKc+VcCY05QcgT6gGgpVvNCLThANjOrYXtrmv
	 2Mq/7m/8GDrS1HKE6GR9SD9/zQ44kT3UTKQkmwVBZOUwMr5Q34m60gX7Mv9fJjsOA/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197995;
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
	bh=ptdOMaD+9vZV0Uu2KA6YrEAuhqi8FlfBehAYo+ruinU=;
	b=DoTmUygrGcF5rSWdxrwsKIwwX4E+FwgoVT7TyJu76l27Yzx+M1fHtZ+lJi0KwhHzIhhR
	 18jQfdnro00UIhNiS03d5VRxP4NCZuDvNCSmYUXFoNgs93XlgRPqtq6Nj544v6ZpurEvh
	 eLtOaC6rPUONU4KPRtBpFZCTigo/XwaNeorZaGbQ5Hlyrc40cI4ax3LRWvT/pULTALW29
	 /+7yA+dpljdKlpYB23TJTv5+e5xauRDtiImVg7GR/KalVOg9jy8xoa4YVYwAI28wkJKF6
	 2RtC7Pw8wUoF+FKRowG1mf2CSgj3NJre/wURCxV1Dk2ll+AL6JFlsqRw6owbosy0Gow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZjpzeoEG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.35
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F109D606B11C;
	Fri, 20 Nov 2026 18:06:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F109D606B11C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZjpzeoEG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gih4hKNJqSWpByN0yEMQg9r60WYZNJFH8dCLe7kPPg2wYCP+abZM77mqbJzeJ7jIlN/7ziMJFPLcnA8hBRoUibpitp/9JjlaK6KZpgILNQyi6Sgkoo6QWzKSiOlczUZoxQcEpXkNRqNh2n43HTM0amW2Qly2ckS95UpBp69WFT1fvlNNhbr2xNLS0RbA3CP3hr/EzhGJM626hju2JA6z+halV/XLVaxRFTRo3Ver95uFqC0J6X8ReEgwlnEFMZoOk7ASgPShjHNZ0ecixuY3nk2j7O2m0R0PHvOfJ/3KKYqpE1OX/cmK0ZodQ1rYx3gOIkkW8jNSenSXGbQ0nsSuDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptdOMaD+9vZV0Uu2KA6YrEAuhqi8FlfBehAYo+ruinU=;
 b=UF6q2ejxPWweARPVHMnjP5bxb3wqIs4acOM6FJqXA4ZNvr+mNhFxFCslo+MahNXweQPJpELFAQWmKs26NXu48RW3vpLDkAuwhIC4WSJcoHcRF2VbgNZfpk1NKT3V1F0uNyQ9lLNkquFmml5ksau7FlVCSQ55jPZA8DXUKEMWLG9TASkh1HrkdYMvcwvWmz2dnvwR67Szayh0EZ6SsGNOXg+sgZdQFvuH/ht+1coK2xCMjoT7m1YJDduaI01BPAedgkPZHJDlTayz5S7e4OEzyMVXEbNdwEBbThnliXg4waL8L35UtkaS0CilpNiPzVRJT8aMM8TJwwok0hZEYHKCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptdOMaD+9vZV0Uu2KA6YrEAuhqi8FlfBehAYo+ruinU=;
 b=ZjpzeoEGJ4JwqoVKp9i0wv8LogufVC5x4zcvLMW3XL9oi0+y7SSgT9iQbOs7MnNZFSzTqVFf9bule5+b1UWVQvpS18b5gNAI1w5NC15bG2JVWl85ENql/ZEOz2pYAWNANBvMhBO2SA+ebiYrW0s22CGWpX+F5dK/+0p42fb3zE+E930qaIj8zYVsG2MPxx5Amt33Y2IC610Xq34lC34FJiGwvtpsM4snUY520phlLcXmWqW8kOK+Ca5wAl41WeMNpo/6f7Dftv2Prqv6I10JAKlqahSSALFF/5X3NCyUlc8wZZMTW30NUj7z1J4kywmuHvkcVGe0pZJ+aj+0bY1h0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by PH7PR12MB9253.namprd12.prod.outlook.com (2603:10b6:510:30d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 18:06:22 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 18:06:21 +0000
Message-ID: <0a9b34c9-32d8-4325-aaef-c358c41a9f5a@nvidia.com>
Date: Fri, 20 Nov 2026 20:06:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mlx5: Allow police as the last action of a
 TC rule
To: Mohsin Bashir <mohsin.bashr@gmail.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, idosch@nvidia.com
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
 <82d9959a-8176-4433-94a4-ff72445306ca@nvidia.com>
 <09ae2064-38ff-4d25-83e5-0ac4c3eb1658@gmail.com>
 <194e1103-0d28-45d4-986a-819955e11268@nvidia.com>
 <acd93d7c-1e91-45f4-b178-07c6afea7fe5@gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <acd93d7c-1e91-45f4-b178-07c6afea7fe5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0011.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::14) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|PH7PR12MB9253:EE_
X-MS-Office365-Filtering-Correlation-Id: b40fe2a3-c236-4b80-2cef-08df4730fba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|261022105027099003|261026140227099003|261028144727099003|11063799006|261021123027099003|56012099006|4143699003|261021121427099003|261009223027099003|10067099003|261102123227099003|18002099003|261026121527099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	gkzYBvlcffYyscikb8hZTw1dcwslFdJrgDgEGgYh2ib40yWD+1opGviZsng15qgI5q3ZxZWres9NsAUrxCRydV4pW6VsXD6g/4hP1qWVds/ZmHVtXqh6oYz2m5X4ee7abgkarB2oe4sLXk4B3SSKzBGT/pADQI1takne6JdnAnB/+jMWx5UIBed7WWCANlF7jtHLNFeXiQxiDmKnM/LSnm80A2SMmG+I967m6rbZ8NXoieZkotjS5+tqN2I+rHChCgI4XI1oBFvFVa52V57lOVodylkufqV48AcsqLyPoh0SKeQd4zE3tcqMbmAeawNmbgppSY38w+0xMYuY9oDAbYTakPFdjdU4YczxaKIBha/sHO/cpeYfH+FAAV1/PuhCzvUput8vYuzADWZoGDmbyPogsSJ2bqPR0hhfgmo8ujwkVgOvrKMaVT5MdFuMlBpcLChMkPuLkJGpaizkyaqiK1U49JAisy0HzOg6+rlVuslDnVK5gnjgsRuXiZrzi8CKrm/+uqVmuYsyJc5KZzHAGldDpUAHmopSG67F5aurrrzRsRVzXRNP5zNsSTE8SPCWrnioKZPjxyM4QNXaQlNp0a2CyJUtqA8ynoZOj+FOK0scor71E3CcrUm0+r99OsC8flqu6d091eWmfjnrPB+5rnLk0JDndpUBFVTzHYQm330=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(261022105027099003)(261026140227099003)(261028144727099003)(11063799006)(261021123027099003)(56012099006)(4143699003)(261021121427099003)(261009223027099003)(10067099003)(261102123227099003)(18002099003)(261026121527099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1pNa0lqaE1sZGpIdHI0WE5yUlFEQjI2aDM3YWJOMXZxVkJKT2RabGhvL1R1?=
 =?utf-8?B?NlFhb0NnVG85OGFKZGRvd2RGWlA3MThZMUtDMUE2OWNxVGZQU1VTVFlTMGhp?=
 =?utf-8?B?SldFZ3EydHg5b1g2c0xHbVRTU3pjY0VSYjJIOG5vYmhqbXUrc29SNks0MkR6?=
 =?utf-8?B?ekdZelBDMVFiNEJORmdBRHV4TklVQWZlZ2VzbExudDJueVowV09nRlg3K00v?=
 =?utf-8?B?NmpJZ1JrYlBIV201NkIwdUZGVlc0Y2dSUldrcGVnU1VUbW01M0NGWjdQaWxY?=
 =?utf-8?B?bm5tOCtZSXFSTzY5bnZadXIrTUVLWXA4eEdzbDNwZmJpeHFMVWNUL0hqYUJO?=
 =?utf-8?B?eE0zMnVMSUZEdVNLL0RtK05tRjQvQ2pXUmUvVndYVGdjSVNlUFZPWWk2dzFm?=
 =?utf-8?B?THBCU1VKbFoyMFlKUUtoM3VDUDhrcXJraGdKQjZvdE9HUG9hNmQ0QTMvNjlM?=
 =?utf-8?B?VUl0QUsxNHpqaFBNOEFaRXkzZy9MaGNjNkxaSXRpOWlMNXZCTWNtZ2hDSDJ5?=
 =?utf-8?B?cWxrckl0UExlc3ZrOUhSNFc1R0dEZ0lqN2ZJenNqUGxqbGQxeVZjN3hBb1FF?=
 =?utf-8?B?cjVYYTl4clgvWFVzWVkvY3dZNTdydXRvc3dIeEQxQlVWNGJPNi8rNTFhU1ho?=
 =?utf-8?B?b1F0dzY3SUJ0NTVZTXQ3ZjdhUFU0MEZjZkRkRXhSOUNXOEpJQ0VMOEg5L1Vw?=
 =?utf-8?B?Yjd1OGlxUXJuYng5Z2NuQnZLYVZRQ1JlNUVyZ3lsQTE2c09URXhraGNaaVZr?=
 =?utf-8?B?eGNBdERMTE8yTy9QbXVoK3JaU3VJTlBmVVI2UU9CeGdyL1JEbDNPL3UwMjlY?=
 =?utf-8?B?ZkRlVFA0WXdFWk8xaUtYTDFKWVRIVUFUSm9Qd1BoeGVUNllNRnFTR1Q3N3dn?=
 =?utf-8?B?Y1hXVExITXp5clllTWoyRXQ4aFF4a3BrVDJoZHBaTnhIcmgvWXBZMjBZUlU1?=
 =?utf-8?B?bE9QbndaL21VNHQxVUUraGdJTmxnK2VoWkF2V1lwSDNTOXMzbGFhbWpNcC9o?=
 =?utf-8?B?enE0ZTliZFoxRURFcHNLQjBmWnh4WnNBU2wvUW9XbHdFTFArWnlWd3B4b285?=
 =?utf-8?B?S2lxQ29JeFhMeW5OalJYb1o2bW5GRnBkT0hWNUgvQy9LMVdldjY0QVJJY2kr?=
 =?utf-8?B?c3Z3ZXhRR21XVVBqNjRlUGdGSUoxbEFrMTNDeHhYL0xRaUNVc0Q3UUJCOHBs?=
 =?utf-8?B?dGZDMFNHYUs5MndLZkFVRWhTK21EckFpODQ4ZitKMWlLRVFaL21VTVVlVFFw?=
 =?utf-8?B?eFAvNnRUQmdNTjI0ZG4wVmxwbkZCZm01OEhKeXA1Ukd3SjhlSlNtZ1BIODQy?=
 =?utf-8?B?OHhhM1lWVUJDeEFQSHRGNzZ6OVZsQTN4L1pYNHIyNnJpZE1maWRFMjkweEYz?=
 =?utf-8?B?bTNnVkZOYklOOXZhZFFNZVEvN0xRVWhENmtmc2gyWmRUMVJnUmtSSGZVdjNJ?=
 =?utf-8?B?L084bkVEaTlNVHFPay91bFZBbDNLWTgzK3ZxSWRMOElrRUhxNDJtcEhSTmY0?=
 =?utf-8?B?ekRGa05BTkRPSHpUOHlTVFhHZ01BNWF1dnRoM1dqRU1PVm5HdFBGaHpMZ2NQ?=
 =?utf-8?B?VDZwaDhyaVdEQnJKeEZqc3kvYS9DbmdCU3RRZDhYdFBCbGdLQzFwMVRaOUcw?=
 =?utf-8?B?dEs2eVRrOFUxU3ZNVVptNFlZVGd2eitHb2F2ZVFFTHUvQ3JOenJJSmNtUnRY?=
 =?utf-8?B?ZWZuWHpLZ21BVG9WWnVuV3pvYXR0b1oveStOOG1ydW5KZGxrYUJjeVAyVC9H?=
 =?utf-8?B?Tk5SSWgxSkgzUHloQW04ZlR5L0NSVG92ZHR1R2pHWkdQMndRS0EvNlNJS0dY?=
 =?utf-8?B?SlFNQXVTdVhwOE5Yam5Mb1FjdDlvQTNVMVZLZGZpTjRVdHliOVJyRkhDSFpE?=
 =?utf-8?B?R1lueVg2MXlhZnByL2hSOFVHN0ovNE1DbUtzSUxWQ2R5VGtnZXgycTAwbU4w?=
 =?utf-8?B?cWtRN1VpNDJqRlFWclN4bWlmcHhGZmM2MHYyajJvYkJhY1RUVStBVHJyd1pS?=
 =?utf-8?B?Vm1VNkFNazF6REk2SVFQNWZWZC9MQ3NNRDlRN3pmN1pqUFdXRUplOGZ0ekVW?=
 =?utf-8?B?Sy91dzdPWVBFK0lnRll2Z2E3ZDBjeXBvS2RSblZFYndPbWlodUVlYkUrTnhm?=
 =?utf-8?B?eXhBL2JyN0tDZTVWWGV4dkk0Z0tjdG5jNU4zSWwyNThkaHdOMnpvWGJkSDQy?=
 =?utf-8?B?N3JmWVJwWEZGVlJCN1kwcUtyYTVpZUFTbTd0bkoyejdZVkNZQWFvcGxWQ0FM?=
 =?utf-8?B?VVVwZDRvMnBZNXlFNWppTElzNTdZN1JHRDl0VVNOREdmTllNYWFSYmpYczll?=
 =?utf-8?B?amJVb0lTL1MySURId2s3cFJEd3R2enF3WUNvczJ2eFdScXdWdEJBQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b40fe2a3-c236-4b80-2cef-08df4730fba9
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 18:06:21.8403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqsneEpRk5587vj+RwWbHl8h4X5vo1AbVi3FEF2ybJJVFauuC2rXPB/tSvatvt32P+9T5HG2DA532aYTy9hSEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9253



On 18/11/2026 2:52, Mohsin Bashir wrote:
> 
> 
> On 11/17/26 2:14 PM, Mark Bloch wrote:
>>
>>
>> On 17/11/2026 23:52, Mohsin Bashir wrote:
>>>
>>>
>>> On 11/17/26 11:18 AM, Mark Bloch wrote:
>>>> On 17/11/2026 5:13, Mohsin Bashir wrote:
>>>>> From: Mohsin Bashir <hmohsin@meta.com>
>>>>>
>>>>> In switchdev mode, mlx5 offloads police only when other actions follow
>>>>> it. TC needs no extra action for a police-only rule to work. The mlx5
>>>>> driver makes every police rule forward to the post meter table, but for
>>>>> a rate police it adds that forward only after verify_attr_actions() has
>>>>> checked the rule, so the check rejects it. The ok result of police is
>>>>> also handled as pipe. In TC, ok accepts the packet and ends the action
>>>>> list, whereas mlx5 goes on with the actions after police.
>>>>>
>>>>> Support police as the only action of a rule. Set the forward while
>>>>> parsing police, as is already done for police with mtu, and forward
>>>>> an ok result to the end of the TC chains, as the driver does when it
>>>>> offloads the gact ok action. The upcoming selftest series also relies on
>>>>> such rules for TC offload validation.
>>>>>
>>>>> The patch was tested on a ConnectX-7 in switchdev mode with the command
>>>>> below, and it was verified that the rule is offloaded and limits the
>>>>> matching traffic to the configured rate, using the hardware drop counter.
>>>>>
>>>>>     tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>>>       ip_proto udp dst_port 5201 \
>>>>>       action police rate 100mbit burst 1m conform-exceed drop/ok
>>>>>
>>>>> Cc: Carolina Jubran <cjubran@nvidia.com>
>>>>> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
>>>>> ---
>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
>>>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>> index 1bd1c94fb977..52295f5d644c 100644
>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>>>> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>>>>>                  MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>>>>>                return -EOPNOTSUPP;
>>>>>    -        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>>            attr->flags |= MLX5_ATTR_FLAG_MTU;
>>>>>        } else {
>>>>>            attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>>>>>            attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>>>>>        }
>>>>>    +    attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>
>>>> This makes every police that is the lact action pass verify_attr_actions()
>>>> not only ok case described.
>>>>
>>>> what happens with:
>>>> "police ... conform-exceed drop/pipe"
>>>> with this not writes to FTEID_TO_REG so what happens once a packet
>>>> reaches the port action table?
>>>>
>>>> also what about:
>>>> tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>>       ip_proto udp dst_port 5201 \
>>>>       action police rate 100mbit burst 1m conform-exceed drop/pipe \
>>>>       action police rate 100mbit burst 1m conform-exceed drop/pipe
>>>>
>>>> won't this create a loop?
>>>>
>>>
>>> Thanks for reviewing Mark.
>>>
>>> Ahh! I missed the loop case. I had a patch to handle pipe on the last police but I dropped it, since my testing showed the post_act table still passed the packets up. Let me respin and send pipe and jump on the last police to the end of the TC chains. Would that work in your opinion?
>>
>> Yes for PIPE.
>>
>> For JUMP, we need to check the target. tcf_action_exec() counts from
>> the start of the action list, so even the last police can jump back
>> to itself or an earlier action. If we can't offload that, we should
>> probably reject it.
>>
>> That's how I read tcf_action_exec(), but please correct me if I'm
>> missing something as I'm not really a tc expert.
>>
>>>
> 
> Yeah, jump restarts the list. Before this patch police as the last action was rejected anyway, so I believe rejecting jump there in the respin should be okay?
> 
>>>>> +
>>>>>        return 0;
>>>>>    }
>>>>>    diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>> index 1d35c97aea0b..8685e41487f3 100644
>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>>>>            attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>>>>>            break;
>>>>>        case FLOW_ACTION_ACCEPT:
>>>>> +        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>>> +        attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>>>>> +        break;
>>>>>        case FLOW_ACTION_PIPE:
>>>>>            err = set_branch_dest_ft(flow->priv, attr);
>>>>>            if (err)
>>>>
>>>> This also changes rules where police is not the last action.
>>>> The conform result defaults to ok when it is not given.
>>>>
>>>> action police rate 100mbit burst 1m conform-exceed drop \
>>>>           action mirred egress redirect dev eth2
>>>>
>>>>
>>>> won't with this change the conforming packets go to the tc end table
>>>> and not to the redirect dev?
>>>> The rule is still reported as offloaded and installs the redirect
>>>> which can't reached now.
>>>>
>>>
>>> Maybe I am missing something here, but when the conform action is not given, doesn't it default to ok? For example, if we have
>>>    action police rate 100mbit burst 1m conform-exceed drop action drop
>>> shouldn't conforming packets still be pushed up rather than dropped by the following action, making the action drop (or the action mirred) dead code?
>>>
>>
>> Yes, agreed, the following action is dead code in software too,
>> a separated cleanup patch maybe?
>>
> 
> Yeah probably.
> 
>> What about packets that reach the rep? I don't see anything in
>> the ACCEPT path that tells software TC the packet has already been
>> processed. For example:
>>
>> tc filter add dev eth2 ingress pref 100 protocol ipv6 flower skip_sw \
>>      ip_proto udp dst_port 5201 \
>>      action police rate 100mbit burst 1m conform-exceed drop/ok
>>
>> tc filter add dev eth2 ingress pref 200 protocol ipv6 flower skip_hw \
>>      ip_proto udp dst_port 5201 \
>>      action drop
>>
>> Wouldn't a conforming packet reach software, skip the first rule and
>> get dropped by the second, despite already being accepted in hardware?
>>
>> Can you test this? The existing gact ok path might have the same issue.
> 
> Yeah, in both cases (police and gact ok) the conforming packets are pushed up, where they get dropped by the skip_hw rule. My understanding is that with existing behavior the restore doesn't happen on accept path, so sw tc takes the packet through classification again.
>

Hi,

Sorry for the delay. I had other things to deal with and wanted to
go through the original internal reviews before replying.

I'm fine with supporting this, provided we preserve TC semantics:

- ok stops processing; later actions are not executed.
- jump executes the correct target, or we reject the offload.
- pipe executes the next action, or ends processing if it is last.

Please address the issues discussed in the next submission.

Mark

>> Mark
> 
> 

