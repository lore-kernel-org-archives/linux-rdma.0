Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793865443;
	b=YndaxXgQHIhGcxarTjoxloauZgj7exBEaENM85nfZT7fg+37LWUvcw9Hwj+pIr4SBfdA
	 IV5x7lbOAwUUAEhm7azXF5TdgvLvu4Onf8+zeIRngYmKQXGnoz3IOd4ruTvF03Q63HE/z
	 YUNllC5gSnhOX3sQNfHbd8Ncfw4CB9Vuq2u2d9auhAb1VqPaAeRicBIjkHSWm0bKd8nGB
	 4qf1HNYsgb8nEmsGI7aEQQBg3Y8k9bsj/vBXCin46eEf5qCQVYFAG3bX4zOsLnfYiUrYY
	 muKymng6DFqk0O+fSMqILEiJmRJI7XQzuj1wk1xWLfuri/tuguCNb1yIXwkAPksZBXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793865443;
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
	bh=McEZa8KnsTZM2IiqtK+51g5Kum+oM18e1ws3Xr06L/g=;
	b=m8ORsmwJJUWZ3ZqQVcyjS4LTfuZAQRM24NtoiqRajO1VMmzLzphllaHqniPCnh2ZSItY
	 Ea+ANc+hNibx19Qitvuh2c8pmevhk5rmWWd50fNKjCY0sLvIIYPZNDfSBA0i13dCKNO+8
	 GzoT5/QaSkoIew7kXIPs3uRYY1PQuwAsf1p8iQZ4MHPa948+GZTlLlodIg1uDdftjh/6A
	 rvb1wNloVeQb9b2QnFKizcqWWSQyX/Vu7pTMzPjdtb8BEKNv6Sjjq9S+cSncrmLWaerIc
	 4sxrR6i7YnIcIPAGsdfbC+Bt5qGp8DQj80lnAC3uxiFphz/GdGNq6uiZ3FGM+d3rP1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UsKMXpJw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.15
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010015.outbound.protection.outlook.com [52.101.61.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AE606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 07:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 016AE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UsKMXpJw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nsp8Tiw3VurUbT6wEXu5PbQkBdW3jVQy/qSxRyx/6vHbM3ZBOfLldC7Ak4DNF6Ney6gCyHtsGDnVReO9S21I5OvRS6/Tf9FJ2tZK76Xj14Qi4DCm2yf55fuwnkuManNKoao3Y+vJdpqdalhB8pwRai+N+MIG+DodAFhsy4NS0oKfzSTYn08dBk0NAVMVX/DHABRbfTaM0YssOhR30f8IBJjSp54d+6vztdblxFlJZjDrYdBaI2m5ADfCMrHy4Dg8xb53q0tpRt4lJKrh70Szo2DWTQbAGMUwyC8lgjmVIiURSeAVqJRr5oynIX5tF6XS/CF50/g2o7zO4TYdEC2reQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McEZa8KnsTZM2IiqtK+51g5Kum+oM18e1ws3Xr06L/g=;
 b=LAPP7ocnRFTS9kjGVgsZX7weuPZyGvTkNYC0I4Ckdwb/tFqW/Y2VoLZ034kLsbcp6gVZN4I3FTHD8E8bhK/9M0654xAwV4S7O02jrT+Qh7mPi18lP0MLxPAV/fIVKa0j+pAiw0aB+P2aj5XTM/pmk1GV72lwbY+vW0GELI7SKpBD76orvXAe9pdv+x6eN+qP0CEBrwtVcWd0iSnGm0OMiqU+ERtRQqJljPfdW606YUgCj6MP6e+GJV74SFHK3QqUucFmm2UNFA1UBtI2j+Mt0wU5hmLy4LiZFqgwgVBIwvqkcyXl+2nywPZaOB8ciCQwPuguqT89gVM4ENo7O68Ugw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McEZa8KnsTZM2IiqtK+51g5Kum+oM18e1ws3Xr06L/g=;
 b=UsKMXpJw3yziegN1MD6ik1QhxLgB7uBiiB5G6SnI2m8+6QcFrp5NLvSWIzKiB7P13MtKllC2Dm6bP+bSv6psYnZlWGDKuMzhRcJ7B8Qd4GFRi1Nn0SOCFLgPRqreUVjhxuWl2lC97LpjFg8u995b2Q4FhmCqWPH7zbEBhZNNEUkIsNPKle9j9JGqIYu016FKk/QUbMP5HDTzf5W4WDZMhfo3NaLzqUqMVSXfYR0zqUWW8yIDxmmeaDY/v2izQFT8aAWLMAFtEu5x5SvurPQDhzjiCbXncWte9pcZkqNizcb9YKyeABu1Drvv3tVPi1LO2ibemSftrDjJUdYR0KwlmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by IA4PR12MB957498.namprd12.prod.outlook.com (2603:10b6:207:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 07:57:09 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 07:57:08 +0000
Message-ID: <2c617198-e394-4c4c-be59-77d8ba14e844@nvidia.com>
Date: Thu, 5 Nov 2026 09:57:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: A question about FAILOVER event in RoCE LAG
To: Or Gerlitz <gerlitz.or@gmail.com>, Leon Romanovsky <leon@kernel.org>
Cc: "huangjunxian (C)" <huangjunxian6@hisilicon.com>,
 Mark Bloch <markb@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ogerlitz@ddn.com
References: <26b0d23202814f60b994ce123830353d@hisilicon.com>
 <Y/tWPpJNz3EHtMgB@unreal> <afd9c082-db31-da9e-8cc9-44410d110ccf@nvidia.com>
 <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <CAJ3xEMjHf89E1FaC_+AQcQv_x8sm2T7Qo3_QOgGTgKs3kbT2UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0070.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::18) To SA0PR12MB4367.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|IA4PR12MB957498:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd519d0-aadd-40a9-be5d-08df3b12641e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|6133799003|3023799007|11063799006|4143699003|261028144727099003|261026140227099003|261022105027099003|261021135927099003|261021123027099003|261021121427099003|261102123227099003|56012099006|261009223027099003|261022075727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	d42ybD2BaPj4OIP60g4LuERd1+HMlS4uigLsSWj+k821a1FeihInNEExSe4tm+d8VEmjHUaCtcnYOlRz2T64vBTv3vsuY2VQEoNtAztq4KgOEQzkWboYea69e4MinQLaPDoN68rXf7AnOiKsVY8dj7OIWhjiWcthfXm0yvrlX27SCVVGdGOMxC9MgjcH/1R7wQ5O0iGZNKG3UR6npSsPMHM/8g5+y5VAjfM5Zw6JG047Rwg45Ui2hnF5Z/u54D8qKRfdujPWvGtjyunqkguRSqvbaNUmLZEPn8THo3O7S/QKIW9nbsq3LSbwZ/5B+sOAtHEtsCFgxzBuJm7kZy94SPzLE5nj+F0Vf+8cEJq0ha3CEvoIZgAEJq6MGdkkuCgcNpd9Tdmscn/9WK1pxzK0qX4PEwFKU8xDJO1S2Vp78exTlkvDYgryJ/ZjykoyVRE4jrxjcOXBoMV/rkDqpMUohFZ2Dmfidw8jZ7K0rZnERbIPwZBqULx65kK/Yvy75lxhr1cYFN1c4+slxhSCiTAM1PKWWFDlolnl9FQr0yTYj5S2h8fLiLlKpFBPxPmdoLQjQ+ajGIK+nEzcTBewpEe/WENwzrAkB6Rc/oRxnahSkUETpJzjWhAnlFO+40I0wdkeQsRY08aZrX9M+RMEEuQ4NnRqozmOncZZupCByBptDxc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007)(11063799006)(4143699003)(261028144727099003)(261026140227099003)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(261102123227099003)(56012099006)(261009223027099003)(261022075727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTBTOHo5VFZtM1hwd1JPMG5PTmdPUkRiRVN0MjU3VVVxUU9ndGxFN0FBWWtD?=
 =?utf-8?B?VGovMjdBR2kxVFJjd0dNUzRDbkE4Q1ArRDd2ZVZlM0QzQ01ic0RQMVNFM2U0?=
 =?utf-8?B?Z21qeEZHVWpvYXUyZDUwRGsxNnNEekNzSjlSNzdLL0lQaFpRMk8rZmtTdGN1?=
 =?utf-8?B?L2FmcXlYQklFUDNBL3JJMlNLdDY3eG9WblpHR2J4QVdmaENRVzN6NWpEUTBZ?=
 =?utf-8?B?RW1UVldUOUx3Q2QySTU1UTNmYVFrRkQ2QXY1MllGWlJIQnFrNHJuT1hIbGJn?=
 =?utf-8?B?N1lZZ1ZjQWNneFBpU1NLWDgwbnpSN285MWYvYTFSdDY3a0pRaXl3SHNJYjJG?=
 =?utf-8?B?SHIvS3k3enU3WjM3c0IrUCtjdkVZYm9GTkZvYU5hcThycm1mOTNXdnBVZjI1?=
 =?utf-8?B?ZVRzRDhDYUhtYUhRdHJ5U2NSV1ZaOVU1UHBGVFg4dzVxOTBiZzh3Q2N4Zng4?=
 =?utf-8?B?NTJkbUFCMG9pY0ZFakJna3ZWTWFkTDFNMi83bjhtNVAzUzZ1N1Z5eXI4QTNV?=
 =?utf-8?B?eVdRZzViTEttajZrUnE5NGZuUXc1anZLY0NSTGJHMW9YcU10UGROSlg0czR4?=
 =?utf-8?B?Znk5bnNXYXRiM25sdGswSk96N3NMNkF4UWRwM1VXVkxnNklENnZPdjd2UUdI?=
 =?utf-8?B?bXY2ZFV5U2hUUktmSkRwTXZvTjFubTF3MGcyVXJLMWNsN1EyRkJiS0RSRnpr?=
 =?utf-8?B?anZEN2Zyamh1WFY4cTJVK0ZLNlRoU1FnUnZaWDVLd0U5SlpUMmFEZHFKTndC?=
 =?utf-8?B?Q0d1OE0xd1laL2kvdHpwU29Jb1VnUnZ0bnVpaUxOS0kvYjh5ZzZtemprUTBm?=
 =?utf-8?B?ampsblVGSDU0WHlKNVVJNEZQS2ZHcnRPWjlSMUxIMUk3ZzFqUDZqMUhVbERS?=
 =?utf-8?B?dk9xRkl5Y1RNMUVYYXVuYnB2MGhPMFZxMmdCNG9IVVY0dVo3cy9wSUU2M3ZV?=
 =?utf-8?B?ZVF1NmkvYW04bStBK0NlZXpKOEwzb0RVSUpjTSttdzJSQ3NwL2Y2cjVMVXhY?=
 =?utf-8?B?WHVJa1ZFd0JGb3ZYdHl6ZStPVml5V21FN1FFZEd3UTV5NE1LWDdyTnJtV3Y5?=
 =?utf-8?B?WHRoRHF4cFFzOXZVOTFRK1hMeWxxSTBvc1QrTW5MaWRQdCtBa0VrbkJHNjc4?=
 =?utf-8?B?a1hPRVppQitnclFzUS9SaFAxbkNSMzRHNTJWMlhFNHU5SjI4QU4wSklQYUpm?=
 =?utf-8?B?elZIOU43UUk2OEg2eC9hQ3BvQi9aSnJTbEd4eS9jbE5TakE5dTBzQ1RVVS8z?=
 =?utf-8?B?S1o2ZXRPTndjNDRzb0sxZ3pvUTBNVmsyOE1ibzFHS3J2OFVHejVZbmZIeGhJ?=
 =?utf-8?B?RDZERWUxd0pCWVVpdUN3TVM1UnM4dSs5aWl3VEU0dFdUZ1dxL25BMm1hVGsy?=
 =?utf-8?B?N0RWUXJhbVJMbngzemp3ZUVyTFRCSUJmeW9qcUhFRE1XcVNkVm1yVURvVnJ4?=
 =?utf-8?B?c1dCOFAxNWRtejczZEVQSmdGT2RzaE1pTFR5V3p1Z3FzWEdzYjZyK1NYc1pp?=
 =?utf-8?B?Wjd2V1Nxdld3c1ZhTGtWSlVpZ1JjLzhQVUdtZmRqY1VDdFRsOGRTWVBDc0Z5?=
 =?utf-8?B?TU80cDh2VHFqYm1EU0IwejBxaGlaamQ5T0k1YUxxNjk4Rnkvcm5TU0YvaDNz?=
 =?utf-8?B?ZFZOWnFGNnFhTUloUDh2YUs5VzlBTDNOWjBHN0tLTlJ0SWcwRXRER2lSYlgv?=
 =?utf-8?B?M09GT3QyT0c4dFpjQ1lJSTlIY2s4MnhlckpCb28xYXJvUHJDRXAvR3FHanYx?=
 =?utf-8?B?TGdpaFVjZ3VGZkg1d3A3VzhDMGtvS1hNN09saWpDNFVTN1B0NmU2S2hSdDlU?=
 =?utf-8?B?NUpoemROTVA5Yk9QbUp2OUgwbFVldkVyWG9qUkcweU9hekMxOWlWdjY0YTJp?=
 =?utf-8?B?YUxuTXJzSTk3aGNlRnpTaFRqeDc4S2M1L3diTS9mMG1VTmpyVyt5R3pVaFNO?=
 =?utf-8?B?TFlJZXdFRjNDanVPbUtXSmR2MDYvcTI1bTA4bEdtM2phVFJoT0lZWnNLU1E5?=
 =?utf-8?B?aTBDQTY0dHpHZWdwZTZJUFh4VmpSbFQ2SmNaNXFkY0MrbVhXOHllQ0lReldu?=
 =?utf-8?B?TFR4L001aG92Uld6elN1YytWazFOekRDMzRKQUpwZ1FScXl6VngwWWhCaUxi?=
 =?utf-8?B?ZTNsVHQwRCthcGNXZjFLZHlweER6SldnNVJ6alNyUndmMC9RaTNReVhyU1ZO?=
 =?utf-8?B?NC9GTnJkK01VKzJ2UitxSHcxVzAzblBUNHp1Ny9QZk1qbEpsOW4xTktFaGFZ?=
 =?utf-8?B?OHIzaWJxL2J3blpVRXNoR0lVc3Z0MEk3amlIKzM3c0Rvc2VvMGFrWElSaUFr?=
 =?utf-8?B?SHhML1FnKy9hdmtEbWt3b01UL0NhYmNTVVlROElLVmU1MUgweExjZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd519d0-aadd-40a9-be5d-08df3b12641e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 07:57:08.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUXEmmg4FbwRDIMWSvbAMRSASnTqcZk7o1ELWNX8EEOEAOaEgkEhBKXZ4aM9d7RvBkdLLYeqAlCptS7iiWZnUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB957498



On 03/11/2026 17:54, Or Gerlitz wrote:
> On Sun, Feb 26, 2023 at 4:46 PM Mark Bloch <mbloch@nvidia.com> wrote:
>> On 26/02/2023 14:53, Leon Romanovsky wrote:
>>> On Fri, Feb 24, 2023 at 11:14:47AM +0000, huangjunxian (C) wrote:
> 
>>>> We've been working on LAG in hns RoCE driver, and we notice that when a FAILOVER event
>>>> occurs in active-backup mode, all GIDs of the RDMA bond device are deleted and new GIDs
>>>> are added, triggered by the event handler listed below.
> 
>>>> So, when a FAILOVER event occurs on a RDMA bond device with running traffic, does it make
>>>> sense that the traffic is terminated since its GIDs are deleted?
> 
>> Yep, please read the original commit message:
>>
>> commit 238fdf48f2b54a01cedb5774c3a1e81c94e1a3a0
>> Author: Matan Barak <matanb@mellanox.com>
>> Date:   Thu Jul 30 18:33:27 2015 +0300
>>
>>     IB/core: Add RoCE table bonding support
>>
>>     Handling bonding and other devices require us to all all GIDs of the
>>     net-devices which are upper-devices of the RoCE port related
>>     net-device.
>>
>>     Active-backup configurations imposes even more challenges as the
>>     default GID should only be set on the active devices (this is
>>     necessary as otherwise the same MAC could be used for several
>>     slaves and thus several slaves will have identical GIDs).
>>
>>     Managing these configurations are done by listening to:
>>     (a) NETDEV_CHANGEUPPER event
>>             (1) if a related net-device is linked, delete all inactive
>>                 slaves default GIDs and add the upper device GIDs.
>>             (2) if a related net-device is unlinked, delete all upper GIDs
>>                 and add the default GIDs.
>>     (b) NETDEV_BONDING_FAILOVER:
>>             (1) delete the bond GIDs from inactive slaves
>>             (2) delete the inactive slave's default GIDs
>>             (3) Add the bond GIDs to the active slave.
> 
> Hi Mark and team,
> 
> (using modern & PC language of child devices)
> 
> So I believe that the generic code which is pointed out in this reply
> has to do with the general case
> of applying bonding over two RoCE enabled netdevs (delete gid in child
> A, add GID to child B).
> 
> Wheres the special case of RoCE LAG - namely the mlx5 feature which
> comes into play when
> you bond two mlx5 Eth devices belonging to two ports of the same NIC
> is slightly different - b/c
> the two associated rdma devices are deleted and a bonded rdma device is born.
> 
> In that case, we saw this week that the connection breaks, likely b/c
> of the GID add/delete
> thing etc and for no reason user-experience wise - the user sees one
> rdma device the device has
> two rdma links below the cover, one is still functional, why break?
> 
> Indeed for LACP mode the session doesn't break.
> 
> Can some enhancement or fix be applied here to make it work also for
> active-passive?
> 
> Or.

There might something we can do, can you please try the patch bellow?
it assumes fail_over_mac=none is used with your bond device.

[PATCH RFC POC] RDMA: Preserve fixed-MAC bond GIDs across failover

A provider supporting bonding failover can redirect existing QPs to the
active physical port without replacing their GIDs. Deleting bond-owned
GIDs on failover clears their hardware entries while live QPs still hold
their indices.

Add a per-port capability, advertised by mlx5 RoCE LAG at registration.
For active-backup bonds using fail_over_mac=none, skip the failover GID
purge and allow bond/VLAN address events through either associated
child.

Keep address-change, address-deletion and unlink handling in place.
Policies active/follow and providers without the capability retain the
existing behavior. mlx5 still removes old-child GIDs and updates its
hardware LAG mapping through the existing paths.

fail_over_mac=none must be set for this.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 4a2a4638b476..3fa7d5b499e5 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -141,6 +141,22 @@ static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_de
        return BONDING_SLAVE_STATE_NA;
 }

+static bool bond_preserves_gids(struct ib_device *ib_dev, u32 port,
+                               struct net_device *ndev)
+{
+       const struct ib_port_immutable *immutable;
+       struct bonding *bond;
+
+       immutable = ib_port_immutable_read(ib_dev, port);
+       if (!(immutable->core_cap_flags & RDMA_CORE_CAP_BONDING_FAILOVER) ||
+           !netif_is_bond_master(ndev))
+               return false;
+
+       bond = netdev_priv(ndev);
+       return READ_ONCE(bond->params.mode) == BOND_MODE_ACTIVEBACKUP &&
+              READ_ONCE(bond->params.fail_over_mac) == BOND_FOM_NONE;
+}
+
 #define REQUIRED_BOND_STATES           (BONDING_SLAVE_STATE_ACTIVE |   \
                                         BONDING_SLAVE_STATE_NA)
 static bool
@@ -159,8 +175,9 @@ is_eth_port_of_netdev_filter(struct ib_device *ib_dev, u32 port,
                real_dev = cookie;

        res = ((rdma_is_upper_dev_rcu(rdma_ndev, cookie) &&
-              (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
-               REQUIRED_BOND_STATES)) ||
+              (bond_preserves_gids(ib_dev, port, real_dev) ||
+               (is_eth_active_slave_of_bonding_rcu(rdma_ndev, real_dev) &
+                REQUIRED_BOND_STATES))) ||
               real_dev == rdma_ndev);

        rcu_read_unlock();
@@ -248,6 +265,18 @@ static bool upper_device_filter(struct ib_device *ib_dev, u32 port,
        return res;
 }

+static bool bonding_failover_filter(struct ib_device *ib_dev, u32 port,
+                                   struct net_device *rdma_ndev, void *cookie)
+{
+       /*
+        * The provider remaps existing QPs without changing the bond's GIDs.
+        * Either child may still be associated with the RDMA port: do not
+        * depend on the provider having processed the failover notification.
+        */
+       return upper_device_filter(ib_dev, port, rdma_ndev, cookie) &&
+              !bond_preserves_gids(ib_dev, port, cookie);
+}
+
 /**
  * is_upper_ndev_bond_master_filter - Check if a given netdevice
  * is bond master device of netdevice of the RDMA device of port.
@@ -771,7 +800,7 @@ static int netdevice_event(struct notifier_block *this, unsigned long event,
                                .filter = is_eth_port_of_netdev_filter
                        };
        static const struct netdev_event_work_cmd bonding_event_ips_del_cmd = {
-               .cb = del_netdev_upper_ips, .filter = upper_device_filter};
+               .cb = del_netdev_upper_ips, .filter = bonding_failover_filter};
        struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
        struct netdev_event_work_cmd cmds[ROCE_NETDEV_CALLBACK_SZ] = { {NULL} };

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4e5180e097c6..28b1c4debde9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3537,6 +3537,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u32 port_num,
        immutable->pkey_tbl_len = attr.pkey_tbl_len;
        immutable->gid_tbl_len = attr.gid_tbl_len;
        immutable->core_cap_flags = get_core_cap_flags(ibdev, &rep);
+       if (mlx5_lag_is_roce(dev->mdev))
+               immutable->core_cap_flags |= RDMA_CORE_CAP_BONDING_FAILOVER;
        immutable->max_mad_size = IB_MGMT_MAD_SIZE;

        return 0;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cb3b6163961b..cb9e52b8ffbc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -650,6 +650,8 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 #define RDMA_CORE_CAP_IW_CM             0x00000008
 #define RDMA_CORE_CAP_IB_SA             0x00000010
 #define RDMA_CORE_CAP_OPA_MAD           0x00000020
+/* Existing QPs can switch bond members without replacing their GIDs. */
+#define RDMA_CORE_CAP_BONDING_FAILOVER  0x00000040

 /* Address format                       0x000FF000 */
 #define RDMA_CORE_CAP_AF_IB             0x00001000


> 
>> and please read: https://wiki.linuxfoundation.org/networking/bonding
>> especially the section that explains some of the restrictions of
>> active-backup mode.
>>

