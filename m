Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010018.outbound.protection.outlook.com [40.93.198.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540840B360;
	Thu, 30 Jul 2026 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405503; cv=fail; b=QIArVXYi0O/cRofn99NFZYuaqXMdrGEcZaxafpFyvyZ7BbjCKmyWBY+zsnIntVdPjJuOzU/Kmvsn8jSQVVTwUWaVObpZ4/emGToZDR+ra2c6LdHez2F3g7w5m6WI5yF2ZSmBhqsXLY5D+HfzWfYqz+h/8RyTlbZEvBIDGod41cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405503; c=relaxed/simple;
	bh=pUlNkL4ySX7Jgmuv7VTZzKJtF2LtOZXBLTwPMUSvNeM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lu3AQ6diM+G16mNDad7uiwCg+eEiV6Y9mPydsHMEhtdkaXg80NLntpxghxtbQ3emV1EArJvyupH/kVgMfIXg1fhdeqLGG4AdASyyKx3VidiYdxtQdgtIrMdIjDLXKANqAKLSvRXzKtkltHZv9getmya0YTO7qYeQ5Y3+7Ax5S4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EMQfMK9d; arc=fail smtp.client-ip=40.93.198.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EMQfMK9d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezwTJzs4mChTzAnu0BFJzUsu1AyxqsfM4X5jTpjdAGAOR9b4LnDcbVr9Wc/XvToCV+w/c5EfIhqsKWFzQ2aS7MtrVbDaTb5AGM34OFM+izGBgrnelEsm7MqZcgGBaX4l1zXwTnRXIIGLiUMY/1kJ3CCW1QTpKC32DRs4rT0fRXxn5n6iemE2PkCC7mvn4s8z2kNdtYncS6YFI6LNsYokiHk7jv15+N9qbfhUR6NGZooK8FAhzy3ZHBmjMUXXwG6jFnztIwIKQlc11daGQxz0vkNF32JvwDDlLgN6eW7PUHoneHTzvpj/uH0fe+XkWP5p6rlR1GEdLRHQk20wOgckXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBVGO0CG7Fl4X6qXjJBMTL/WVrC9OLdb7zf1xeaRQEQ=;
 b=I62SPuM9xZhE7bchkuNizMB5Pt+f6PQ0z74k4qBiv39X5YKhnATtm4FI0Zl9pJHCKkaC3Rxc7MHdy1TBkYmIRWEvji1eUTTqBhXqeqrQKzj2YRl3vGKo8ylDjKrxHTO8lKQNOCpK+PkrrAT11zXC61L/1xgWj7JkTBgw47KNI46E1IlXw+6aafPYdqqlA1FKhuHMrXejCugaROTVwDAz+BxA7oyYQ88W7yThhC8QgG21SKUKVrxyqrua6sM1xmTIVF1U8QzCwB5a3hQXghgnopWlhXzjSceIBhi8N6xL4KyJ9JyTDsW77zKfNFm6c/LJomsw+U9ToG3VJVIfkhLEOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBVGO0CG7Fl4X6qXjJBMTL/WVrC9OLdb7zf1xeaRQEQ=;
 b=EMQfMK9dICiPbJWrJRpdI1Uj1kJsGAj/a1shD8r6SC3mp6mEcxpvQoGmeJaWNDr52dlo1i/phtYFY8SJI0Cu9K8vkdqe4KrZYiibE5LELQCFCsu2fH7ak09OBLbHgMqKt8+kBc7HIoc37Z2eFdZpLN+IOxrxvyKCs12ooP0sE+ws26alU/vtxM4s488C1Bs+GMU5k+BGCuKaJBp3B4/5h1LrEW0N376BMfIzCrV3HddoUOpFNpawXapGjkglRbk1hUxzBGcDtJnI2jA1H7umz+D0gsI5vhRkGZ+UvHC/yFwUmj/ZYe1bA8o7HCM3jYvX7qO6ztIgIZRciy4IHfWigQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by IA1PR12MB9521.namprd12.prod.outlook.com (2603:10b6:208:593::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 09:58:18 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 09:58:17 +0000
Message-ID: <d90068b2-8c88-4675-9e51-62f1ce72966f@nvidia.com>
Date: Thu, 30 Jul 2026 12:58:07 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 12/12] net: psp: Add a self test for PSP with
 HW-GRO
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>,
 Jianbo Liu <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>,
 Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Patrisious Haddad <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>,
 Rahul Rameshbabu <rrameshbabu@nvidia.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
 <20260730091756.2543777-13-tariqt@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260730091756.2543777-13-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0265.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::8) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|IA1PR12MB9521:EE_
X-MS-Office365-Filtering-Correlation-Id: 4774ffa1-7a2f-445b-4532-08deee211453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10063799003|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oqeIfY2SKlQyCY1lZvdJAXbbfa3F55q7d3iV9d5CC/uBFLVelGJDSNUzoQuvFmI2Qw6GD7XGOAczOot79mjuCAGPYc5RmwSg8gMM/n0vHJDD4RWpTrHdYQGViUGK16/HFj4zblSrC9KOaF7cdILXvupd3EheuzKXp38ia2V5o//lhlJO6oScjqY+HmSvnnMUbthTLHsMzvNJhShRKUTlJ8xuhUGReMtLoaC4hmKhYzCe7hKwvZGRnBkukzEk6k1J3iEFgQ55ldbla4S2Y1FBoDK7iPm1pJc4hZMCN1DIaFGSR6QdThLd/of6MK/FdW1kNzLU7LhDeoY5kBMkZyDQQu0Xd+cn4Hl0+HAxFfI2JZJH6bAyryHhLDG8b7D32iwnKDr5+bOf0RBTyDmUAYco01xXFngo6W4gmTOLBZUEhyowdm05eid2ZXMQYS+tb1nmNTVgw92NnllONT24MtpTqSYOjzLB4YpCTc+W74CgHdcpVd7DvfpCzrxv32V4aTUWnvLaoS0E0FIj3DjxswDn0m6XAtvuD/zk2fGLR2gUClvw00f6IlbTGBPyHBOyTZ+7y01XUL3gFR64uqK3W4RlZdUokXkoLXnL5Hy4sW1gcqnAK2/UXBNRTbuRhsMOz3pyTTYXy5UoWZSXdBSBajPh+ludojPWpkYmmdjSv6PfGQs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10063799003)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2xMVXZ2Wlk4a0NqQjdDcFZyYjltdGN3Q2xia1VJR3h6d0IybVpHcG4vOEZ2?=
 =?utf-8?B?bjlZeFptaGxTbDREdUV2aFFaclo1L1lWM1RNaGQyc2liWWc2OXo2MGVrTk5m?=
 =?utf-8?B?ZDFPdUxEQXpZbUdQNGFtOW1TQlJWSG9WRDcvd3JCL2RnWG5kak9OUzh6bVI2?=
 =?utf-8?B?Q2V4TE1HdkdmWkdGekhRQzdJSW0vUm43V2Zvd0k5UTI3OXJ0QVJ2VDlxNnVj?=
 =?utf-8?B?cWlLOGVieTZqbzVsd1F6Zm9vWXg3eVZyVTNjQlJXRVFEd3pqYjkvMzlRclFj?=
 =?utf-8?B?MWJmMVV5RWhFbERQaVdMc1hobkpscjR2VWN2U0VYRFpKRnpuM2lNTlFWSkFL?=
 =?utf-8?B?czlidU9xanAxdDcrS3lqN2tFODhNckQxRHpvMUdLT1g1blAwWlpUTElVUVdt?=
 =?utf-8?B?U3JmK2ZHNWwxMzlObVdlMFJ5cWtoZmhjRGVobWpQVFVhbEJCRU1sL3ptVUha?=
 =?utf-8?B?cFdTRmxCUzY3SXJKVllUMERKNWZuWE5lTHQ0azFkS0F5TithMVlrU2lza0gr?=
 =?utf-8?B?YnhUaUdSenBrUnRDVG56S0FQQWpRRUtGYzZrcW11VFhhMlloMUFnWm9QRXZI?=
 =?utf-8?B?Zml2dVFyd3U4di81TUxzUkRQMGZxMHFaYkdrTUZpekhXN2lrREJVUUFmWGY2?=
 =?utf-8?B?cCs3N20zNG8rL25IZUdvQW96QlZpbWFVZC95cE03Tm9TNHNWZjMyd1NwNEZB?=
 =?utf-8?B?R2kyK0xjMjNCRVhpalRSZWF6VFBpUlVSb2tIU3RGcDNjN0U3ZXZISTQwTnlJ?=
 =?utf-8?B?dVNJM25YNk5vakMzdFU3bzBWN0J2UzNkNVVxM2E3WEJtY2lTTnZvak8rUW5D?=
 =?utf-8?B?UmY3QnY3WlQrdkhxaUpnU0xEV3pxQ2dwNTdkdVlGK1pzNWx6N1UzeHdTM1Ay?=
 =?utf-8?B?cW9wMUprdTFYSVFoOEpyVy9MRFNkcGkwcVFsUmhYcStZZVF3d2twUGptY0Rn?=
 =?utf-8?B?b0N6N2I4M29SdXB1czRBVEhNOXlVZ0FwZ1JNYmd1bENNNmx0QmVRY2FCUm1k?=
 =?utf-8?B?dUNlRTdXRS85OVN6UUJmaFBPMHNVUGl5S28vb0FZYnZVQ1hVdGJUTDFJUEY4?=
 =?utf-8?B?SmlCOFFnOFNCOW1GbU1rVldTRU8rOXlXdWxUVlZSSjkyWS9rUDBrMTNUOHVM?=
 =?utf-8?B?d1gvcGpUcmZJOXNaczZGK2pya1NQUWZqeXJCM2JZRWRDSVp3OHZSU1N5SUNz?=
 =?utf-8?B?TjQ2L3REbTRkaGowY050ZnpjeWlIMXRxdmNVZkZKYklZNW5mOXZQWkx4RGI0?=
 =?utf-8?B?RTl5U0VuU2xKSGNhalRkUmpPdWgxMDdVdm9HYUpOcTJEZDc1S254UnlKVWZV?=
 =?utf-8?B?aTVxSUJ5eG00b3NzOWQ4YVQrQjBLL3A0VTVIOFVReUhUOFhEME42MFdLZHF5?=
 =?utf-8?B?OUEvSlhUcFVNeUNacFo3Nno2c0NpbDV6cFgrOHcrTlJpcmVXenhqOVlpcW5z?=
 =?utf-8?B?N3dXTkJmY2dxWHVsc3U0M0F6SUVUK29Fd1VKdmtRRklsci91NEV0dHdUOG1O?=
 =?utf-8?B?ZytSRzdPMGExR2dWTmRkejBNdmw5SnN4bnFFODJjbXRuQ1k4d0RISVVFUHNr?=
 =?utf-8?B?QjZiZUNTcWhTSWk2MEFnUzBvZnFKTkxlYnM4Z1dOT2NkRlNUb1VTUnd1Vko1?=
 =?utf-8?B?TllWQytVVlRhUHhIcW9LT0c4VldRczBpSmJQQzFxSzI0UGhwTDY3K0l4NHlx?=
 =?utf-8?B?YVNUb3NycnozL1dFdncvVjZGTjcxamN1dENPQlZHUDEyVTFtWUJzSXVLZlIx?=
 =?utf-8?B?UzlpR1lDYWRlR0U5OVFoU0VIY21hVEVxd25MK0hKak9OK2tGcjNoR1RpbjZo?=
 =?utf-8?B?T1hwMkh4WlNjcGtIaElnUHM4eDM4a1lseExtWUEzeG5KbkR6MzJVTWFuSE1D?=
 =?utf-8?B?eGY3OFFMUXh5WWNHMFpHQkk2RGZwRi9zTnlwOXc5M0tMOThPaXBTOHF6Mkd0?=
 =?utf-8?B?QXEzMXhVQWw4ek1mRzE2QzU2ajlndE9WRXFCZWR1dnphaWlRWXBRSENWTE1j?=
 =?utf-8?B?MU9nMzVkYjdGd0Izc1hRRWhkVkxBSmNSNlAvTXc3OHBvbEk5eWhtQVFZU3Vy?=
 =?utf-8?B?VGU2MEN1T09EbmhrM1lXVzAyaG5Zd2x0UUVQK25LMXE1NlFSSGt1bDlGaWxG?=
 =?utf-8?B?cFc5a3A2VVV6R21VVnhFTnlIemEwVHdZbjZRRDJhd211cDhUUEdmZjMxTDdU?=
 =?utf-8?B?QlY0ZC9xZ3NGNU90bE5OSll0M1grdW42N2lydWV1SENWcmxTQUg5aDBQenRQ?=
 =?utf-8?B?N0RYalVIdlVORDVnYkZNb1hrVVh5NG1DaXdPVDdOakJSZE9Balp1Y2c0TEJW?=
 =?utf-8?B?REFYd0VjVWFHblhaanBkOXN5bVRGazc5M0VnNWluZElPWFBiUUM3UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4774ffa1-7a2f-445b-4532-08deee211453
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:58:17.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2/fLoXMiaIPNPAB+lCOINpiS763CphnFEVF0ose0zqf4qzAPS6AIjn8HsenT222/ZEbrOZ2XcWsD8LmYSDJ3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9521



On 30/07/2026 12:17, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Add a test case which attempts to send several 64K chunks over PSP,
> which is more than MTU, and thus trigger GSO on the TX side and
> hopefully HW GRO on the RX side. Verify HW GRO counters increase.
> This required the addition of a new command in the psp responder, so it
> sends the data in order to get it reassembled on the local (DUT) side.
> This is required in order to read the qstats.
> 
> Some light refactoring of the PSP responder was also done, because the
> number of indentation levels started making checkpack unhappy.
> 
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
Oh, please ignore this one. Sent by mistake.
It's a leftover I had locally.
