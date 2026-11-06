Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793965227;
	b=JxKBCGwpits3E+ncCJcP8IQwgLgDL3TA8PWqE1VThA2VlIHdnRQcCfoY5DeeQgULQegR
	 F98YSFYzUDHBLeSHwYUDTB54TEggyVnOF8x+mgxRjY7/lILk7AIIfQbeds4Ti44DmcdTb
	 vkaIEclSvxhDnOy2bNU1T5YXwdeokMGIuo/G8hUZVAA06iJQzaBnwAc9E4UPC0ILePwIr
	 A708ko9Otfe3rW40qqkgFqAkGadgOlZbrE5c2hO0/dNECajaOnJgI9pcZ2YvNwATZX7y2
	 N976WPB3xO177Xp/KsxkjDfZSnJAYNX5ks3WdyeP9its4eutyakGxASDP1UI8Ntrlmw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965227;
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
	bh=FobfScHhT+YW+u4sNn6c0OobnByO2kZ/ov2k9N1JD5s=;
	b=vDcn4aNGiMJcxrdLCWqs8j3tT9lyL4C92tLOyaSULaF+jHNNnLCu8Td3wRrMv7KRPRCX
	 J2RiHTvPOeyIfbutvKq7CjlJgjyaNkf9pDAf6y/cUsUOAZYCFe6Wph6+0X2ebsWqfKueQ
	 X/z/Vezq8k6wJGfKBi/3zjYawh1g8WTAUmuK+rDg3A6o0IY2GBTEi8yWJu3gYTMeq2tSu
	 9D1jw58yjRJL8669QIhV7Ac60XVH4Jf+NmZ33TCddiB0U3d2pKKcHR2GZJljUAKwCbRpw
	 /QDcKqHsruKPyr8WvH+CFmYwWhOJo8E0/VtHezHA7gfN6oauUSFZSfKxgPcBjJmelQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FhFNyHhP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.42
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010042.outbound.protection.outlook.com [52.101.61.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41481606BD4C
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 11:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41481606BD4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FhFNyHhP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksg+wTnP9/7hiHlZBiDqoMEmC9XyiUM033P9xpZQYbt46liZEpnd6nfgAzj9sfc5lGVliXb4XsE2NGouOoIIP30QSagMpK9hryCS6q4yngvn8gRfzMNvQKPhOEuVzS/pMigPBd5+S6NkxEhj8FCNw4UERxOISJce0REOYOYWy7hSYPNToqw0kT8ZyXgXkOXjGh0ho7S7uXBHl4uzBnvwL6qoYmfc4DMrrz04qe2+r+asVblxde/azuZMzSbqreLcLh32uLy2rT9J8nZY2gn/k4STqMJ+crrOqvlxsUcM9PpmBVFscpl7PtwHMTtyXew/dY6mK5L+VjNaWFEPXZm8QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FobfScHhT+YW+u4sNn6c0OobnByO2kZ/ov2k9N1JD5s=;
 b=n3X3m30D0vPA7+tHasouz0EVuaw11GbJzJNZmuZFNWW3+ipUsjS9jJU9nU0lBiowbAOhIAmpoqUzlSTjRNnc/JG3HE8zqWlU2YO2jBXIbNxo1+7W+eVbg28Ga3KtN63iAKLURIx/hBkGDYdGV1/V4cAxrE7ueHefuiYxfMeMXBndCert+tIXXXVxvD/7LUDNFGvuPHxlyMjf8o0fSwxkdq5crH9lGXyk7VxYVkWjBdCeRpQQ9/mb3FA9/vxFODGD1miJqmjUidqWwFd3E6hH1Tjo68fY/tAROLUrogYgCJ0RDkD2L+0bHKlPea5cK1EqdwA5lP/G1YdoT+Nh2gbzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FobfScHhT+YW+u4sNn6c0OobnByO2kZ/ov2k9N1JD5s=;
 b=FhFNyHhPzG+MnfIgnXWzC9NCB240axHfeDojUfE2bs9n1enCluraPfv2IFs5Js6nfiPPAzOAHWrFAPQ47cYarf6hBUF76z1iUfk6bwCkq0Q9XeXLHq4yDlqUbzB14ODQPZV8Oqgymb2vIxwve44DLi8Grj3z1x8AoPE/tEJ+nZE9PJzstOE8NWrmHXXFo4MWsbVLvuTW2iBI1tgle+7GlBZ2n0B2x9v6OZ4/8mD+trTtjx/iomFeTWmKSPOJ5Pw8NdEJt0f00PCn0ig45sheJsnQX2uBLbbtJWmVt9aC9738ytWxoj0X/q26rTOEbE6absNnZS7kJFY/WvYvVj7iIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by LVXPR12MB999195.namprd12.prod.outlook.com (2603:10b6:408:3dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 11:40:24 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 11:40:24 +0000
Message-ID: <0f042520-b1c7-494a-9044-7970e78d35c3@nvidia.com>
Date: Fri, 6 Nov 2026 13:40:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>,
 "huangjunxian (C)" <huangjunxian6@hisilicon.com>,
 Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
 <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
 <CAJ3xEMiG55XUPtt7Zs2xON=EZtJ7Oriwt5m6qbsL-s2cVgZHyQ@mail.gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <CAJ3xEMiG55XUPtt7Zs2xON=EZtJ7Oriwt5m6qbsL-s2cVgZHyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0029.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::19) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|LVXPR12MB999195:EE_
X-MS-Office365-Filtering-Correlation-Id: 2acca9ec-defb-4840-73ce-08df3bfabf3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|22082099003|18002099003|10067099003|4143699003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261009223027099003|261021135927099003|261021123027099003|261022105027099003|261021121427099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	QC7ErzGe9Rq+zIii0PHEwF4y6zyJ9szyTb9pog7j0U/qZvlofnB+UB45fHUukRxKwlcdZYfbLKVKWsWudlgkP9gVPSAmmJhr0bnqfNdh9igOphU4TNisv0U7TpT46vORRkKJkFZtwf7mP2LgcSFBfGW7y0pSzNs00dyXG4Fk3/xL6DQ5l4wVsonKe3CUkk28HdPtSXRt7OPO4fEMOtZyKnykmcuazDVhTAKl09DDk47yXWGPWtbx8N/+XZOydS4K0oCt7gN6k1nwTUJ+OsJCH1h562jx7ry+ahhHedVhMUd73uEN78czeW1Ubjs2183m6SnvwkbpzEiF5O+D0qiW6NdS9/BlcUCLbJuNgRnIWprEzASNPD1diLcJDKIM7jLBtMp8xUrgJKqcgqZyXPbhQmcY1wn/V+eWPJUkL99RhPWzM+K3zqoBMbav8GUp9ICDz4hW1m5d8tlAdUahrI3JNvZyK70qZQS3/6NrZFyX3pdEyaagBxu9DC5T64Ayb5jDxT/PyyZeKc3JGzVrGsrZKKBLUYf6Y2AN0rxQDvOZwlcrWG8jLPPVfKXJA4C2MMvu/ikyT5gpqH0du7ULOvvVVCzMwburCpIYbbjARt9HoOeCNxIgkuWWVr+2jPAPSkdYNJSkPhEZb9uwnGrTfOwiWP0eVHZf3StIYFoMAhSFmHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(10067099003)(4143699003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223027099003)(261021135927099003)(261021123027099003)(261022105027099003)(261021121427099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnppdzNNcDNhTytNVEpoaXBWL2xZYW9OTXkwdmJuOEE5V3hGUFhVQzlwSFRw?=
 =?utf-8?B?Z2dhcEE4S1piWW1OdzdLbXhNL1kxZDUzY2pTRVh5ckc2d09wd0lveHlVM0dZ?=
 =?utf-8?B?VTRnVmhnYmQwdW4wMkpSV2V0cXYrcWhrWW0rUFc3MDB2TVlVRlNsR0RPMFQ5?=
 =?utf-8?B?cUhSczNKeDEweCtWYldBcnhSSXFsb3M5bENaS09SUW5WenJ6YWlBWExuWHRG?=
 =?utf-8?B?V2NBaUViYzR5UkFCVTNNRUQ1d2Z3M2RDY0twQU4vN1kwS0ROeWJ6K3o0aXFX?=
 =?utf-8?B?aXJpdGpSTWMwVGIyOWxBUXFiUzI0bUFrRndHN09OWmxWNUpLb3VmMFAyNzM0?=
 =?utf-8?B?SndrZUxLaXZBbnJ4TFVCM3JqUzFJSys2OXpXMlNwOHU1YnJUc3laRHJFYkRE?=
 =?utf-8?B?NFU5NXB4eng2VHF6OVRtVUpGU0E5Ry9sdmxZY3BsTHR0T3FhMnRFeDAvSlpy?=
 =?utf-8?B?ZHBEWEhKTXZXS1VhakNxcGFRL1dsWjRwM3RZbXhaL0lURWdiZzdtNE1GRXd2?=
 =?utf-8?B?dXVDMStaSkJITi9Mc3dPV1M3WWhwdGZ3Yk5ubExHMVpzUnAvYUZvU0hQdTg5?=
 =?utf-8?B?eFRDaXN1bDdCZm9aWFBBSGxJUmV0VTVraWlQcFRwUURweGEwWXNVWFRKSkZZ?=
 =?utf-8?B?RklaV3o1czRacjNNRGN6OEhSSTRMazIrUnZtbkJ4WVJoOFRnbmRZdEgvWlJx?=
 =?utf-8?B?dm14OTVjcVZYakthYWVTQ0FCbngzYVhjdWFoeUVGMnBnOWxyb1oxWlpsdmlZ?=
 =?utf-8?B?WDg2ZUdpaW9wcVk1M3k2dFNqNFNTSHRmM1FkT0NTUjVTZ2dCYk5PVThJNmk4?=
 =?utf-8?B?czhlM25UVitMVmpwMHUxbmlsVFFZc1A2NGpOYUFGTWJkeWxhRnhQcTR2cnlY?=
 =?utf-8?B?eVpvRmNwVU85L2d5dGx2OTd0RUoxR0YxUVNhQmJoWGtqTkFmNDhXKzk5WDNT?=
 =?utf-8?B?ZFVHbkNXbmROekZPd2RucEo3VzA3TmJaejdrTDV4ZlRUMGN0S3pScytZUTNi?=
 =?utf-8?B?V0NrNzE0TXBLeTh3R2pjOXpUMi9MRUtzbDVwd1Y0TW9PN2MvcWFoYTMvZkNE?=
 =?utf-8?B?aXJnVXg4L1pFS1lGcjQ5T1lVZDFUampNYkxybGpFeFp0WG01T05IUnZRMzJo?=
 =?utf-8?B?eThmNi90bWgrSVlqb1cvYUMvNU5TWU0vQ1d3bC9BZWRueVM5a2doZmtWZEN5?=
 =?utf-8?B?ZlFVWU9BKzdaaktOcjZtVjBQcGJ6VC82WnBnYVd5TFI5NW96dWYwS0daMzhB?=
 =?utf-8?B?Ty9rWVhyL29PTnhIT3BHWkx5T1RPSndTQnlsNEpqUFVCMHR1VHhCejk4d3Bh?=
 =?utf-8?B?WTYwa0gwQ2h3K0toUllrNTIxUGdjMVRZOWgrdEhrSnFWN2VEK2o4RW40Ni9Z?=
 =?utf-8?B?bS9jMDFhNTlDaEtuMDN0OGlyNFIxV2ZpQTlGdDU0cHBQcjk3ZVY0N3RNbCtx?=
 =?utf-8?B?dlV5NWV4Q0tzb1VocS9Fdms4Y24zd09IenY0b0VkVml6VENQaXpScnVDUm9N?=
 =?utf-8?B?R3EzVDZLUkNNdjZGMmJ1aUZOcDVVK202MCtabW1seXVsM0p0bFNkcEM0eGRx?=
 =?utf-8?B?YnlWSkNvR3huOEdjMlJWNW1JMmFnYXhyYzc4Wkt1eGxMb2pmSXZUNWNpMU1N?=
 =?utf-8?B?a3dUcWhKby8yeG9SVndndTJGZS9Ja1VUZ0NFc3o5OUtHWlFYbEJTUVREZzQ5?=
 =?utf-8?B?bmdzejIwQlRKblJZWEJUU2czWTlLU24ydXRZaGpldUlIVWtmZW15b3RCOGRs?=
 =?utf-8?B?K0pRc2F3VFJibURHb3BYWlBUYjg2NFgyeC9BNm9ld29sdmlrQysvNWdCTXBS?=
 =?utf-8?B?WHI2M2lPL2NweUtNSTA3K3JPc1l6eS9JakNyb1J5eUxEWXB0dTJFU1lPWTYw?=
 =?utf-8?B?L09FRHdQbUdvYjJXMFFPc0g3bTAwaGZiRzdNWVhPb3d5TU1wYUtVaFJwQnV5?=
 =?utf-8?B?RExuUmZubDNadUhaK2dETGlTZUxZUGRvRjFJTU9xQzYvcUx5UVVhK0NLQ0Jn?=
 =?utf-8?B?c0lqNkpFOFp1T2tGZHpKRzlFYXlJczl3QTM4NVAvK0k2RHgyc3J6WUpWTytU?=
 =?utf-8?B?enIrUTVuYzJ2TFl3NklXcjAxcWgxNVZlTFJ6VStDOU55MHFMNnI0NVFWYmF5?=
 =?utf-8?B?Y1BDTWFuckJtM2ZvYXZBamNaVW9WTDhsUE16dTNERVFpUktvY1pxek9xcGhs?=
 =?utf-8?B?V0hFVzF4eHZ6bjZ5SGxORTM1WnI3OGxudHdaZ3ArYjczdHUwWXhmaWRKckpZ?=
 =?utf-8?B?N0k1RFR3dGZ4dXdqancxcndFMk9Dd0JMUkErdzZ3UDZqOVdtNDhmck5HUEFa?=
 =?utf-8?B?OVFhY2dWQmt6K3VVU2krS09icHhvWC9BODJSTWthVEo0MGNFMTQvZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2acca9ec-defb-4840-73ce-08df3bfabf3b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 11:40:24.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+DeIXDRAkSzmaF4tpzYrmXPnC0wPAqqlklC4sBsFi8E5M4sQCCgH1Er2GYAS68XZXhmBSvF1guyQ27QiFzPxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVXPR12MB999195



On 05/11/2026 19:23, Or Gerlitz wrote:
> On Thu, Nov 5, 2026 at 9:57 AM Mark Bloch <mbloch@nvidia.com> wrote:
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
> Well, in the env/lab I am working we are not really have the means or
> allowed to
> change the kernel..

I get that, but I'd feel better knowing the patch actually fixes your
issue before submitting it. Can you try to find a way to test it?

> 
>> [PATCH RFC POC] RDMA: Preserve fixed-MAC bond GIDs across failover
>> A provider supporting bonding failover can redirect existing QPs to the
>> active physical port without replacing their GIDs. Deleting bond-owned
>> GIDs on failover clears their hardware entries while live QPs still hold
>> their indices.
> 
> So, indeed in my env, I noted that doing the bonding fail-over caused a change
> of the GID index for the RoCE v2 ipv4 based GID used by the app
> 
>> Add a per-port capability, advertised by mlx5 RoCE LAG at registration.
>> For active-backup bonds using fail_over_mac=none, skip the failover GID
>> purge and allow bond/VLAN address events through either associated
>> child.
>>
>> Keep address-change, address-deletion and unlink handling in place.
>> Policies active/follow and providers without the capability retain the
>> existing behavior. mlx5 still removes old-child GIDs and updates its
>> hardware LAG mapping through the existing paths.
> 
> so with the above RCA in mind, the patch should address the issue and LGTM.

I did some basic testing too, and it looks good so far, but testing it under
real usage would give me more confidence.

Mark

> 
> Or.

