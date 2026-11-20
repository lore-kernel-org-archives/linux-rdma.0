Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795185577;
	b=lan7LAPtZ9LsnY/JizA05Trx/qEElJ1x7Ltcaw3Gfx7HQ+YOF+oCeU2x3wfcWO3o9GND
	 BcE2ptpslqfwzsBK0dfqAH/NVx4zxwYYAdXzWB1ygYFw7hgixwL6GM1LqbaLWrMA5nf4j
	 OE2Sc0leucyvkXVAvx6Zs1rLfJ6HssSirzcVwr4Jz35BtOYdeAUblk8u8o48ffu+d4LCZ
	 A0X7tyHF1JMQC35qsXTaiZkxbL6vr/6JFVl6pE43UgDSUEY7xbJAmeGEG5edwmRFiV5p8
	 UAYcSYy3/7k6uGRNzuQeKmU5H/xZzbTKLDZlvvii6HgkhCFxm0TynQYwQSly/1a/cLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185577;
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
	bh=CPYYGs1qJ0frGZGNeeQXWduNRRnrpiqvseueyttxZpI=;
	b=ZlJssQvoAOwFGFw0/ZZqKyrbPPBIvQCUt2TIsqRlkIOmB2HoYX86AlTAOrXF1jbIWWFp
	 sBeY+5iyT2Swf/1e52XF1sZNVJHtMiBmoqQyxT2+qFV/Zzy2cbk0MV6B7xgGjMUaPIGvC
	 k93Q1Ov5KmI4VnzNGs5VpZ6qdgMzukPSbQeXSexAv6FqdXY27xcsHrAbNHihqmR1AKjCD
	 VH091hF0t7XZ1fE/vR8mt/1/8TQ8nmVC9EU5kIgBB+687ORQojFqHO1fh4QWIk4DqFI/m
	 Uc+9jTvhLi6S+dP3AxzVg6dsC6CZ2ujA/dWSREZPvluTQqwaZ8MUXKLpeueClb6w4NQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lRvykem6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.71
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA40606A32A;
	Fri, 20 Nov 2026 14:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBA40606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lRvykem6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qi7RWsgOjvSevFsGY4qQY0Bq9HwXCEiyexPwK6RsWqWSxYMLrN3ab4Jd24Wzo+8J9bvS+UqxsoKXC+92Zkl5prdIQdHUuR3GGQyu3WEzS5EMoqgAAJCCOD39y2Sl71gkHSoMwY2mdhfNUqP2fC3Lo2ZCukffPfa9krHxI3zjSeW8JUJc0syTWRJT+0kqX87ax3ET1PLYA72ASO289SypCZKI0FISuhf4fKpTjfaCEiNklBkzBZuSU+eqLL3x9SWdiPzAlf0T6miWk15NHCYRZbsRpeooEgbB7pQh1E/LGX7BakdfZXMRiJeVIfvfeeZ7AcwH25Ld9q44ZINOj4YvhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CPYYGs1qJ0frGZGNeeQXWduNRRnrpiqvseueyttxZpI=;
 b=C9gujATIhKi4QKyP95PCEnzHK4yiDYByly9FDz8cKVCVZPyTQyxxxYufTTv4CN7VUWU+3ELL7YRgf590hSwQRhQs6HZu54lpsq/V97fh9zdDsaFiZ76CbGMwD11Azb/mHcP10HSmCS9/ndUPud0uc/MlWF/NFKXfeSHS2CcFy10+szIGhCwoR4HjaStcL57u32KnGKKQiVfz5aS0tNRobVRu3eNE+NnT9E8xzZvtueGA0sE87/I+ozGaDfTZLvJQlE0GICxELIz0dSxOC1mrQfo8hkd7xneqjVtX/OgCBGqNCTY2N8KRCSpFToDhIjPNqTjsW4QLP2nW/5zukdQiWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPYYGs1qJ0frGZGNeeQXWduNRRnrpiqvseueyttxZpI=;
 b=lRvykem66DCLTcH33m5Cj7dHOzcC0shlxPORnOYdBB5Xmsn/D/NJbCZZNqFLFvFOKb2HUiOve7kq8vIeTV0bXPlRizyNYonlchg1J6ToTQuqRoMpaKd2q1k4Y46G7aklNmNbD+3+rYUNzauuOUpADahwD18L3K7hlqQe+52lvxYUoaLXvcRHnyZn8uX8OvH2DcYuP/STVLBwdvF1KvO1bkl2xnqtYacq4GEZ7yoOgzPeWGbbqVw17akg569YN/Pz+ocoOd6pp1YJQC91E1ednVCuNvqNlfTGPL/YTJBPY+A6ntRPPNPQ5vHxffGN8k7KLVPAQgi/tPfhELh1coaWTg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by CH3PR12MB8235.namprd12.prod.outlook.com
 (2603:10b6:610:120::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 14:39:28 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 14:39:28 +0000
Message-ID: <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
Date: Fri, 20 Nov 2026 15:39:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data
 direct
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Bobby Eshleman <bobbyeshleman@meta.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
 <almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0272.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::13) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|CH3PR12MB8235:EE_
X-MS-Office365-Filtering-Correlation-Id: a17cf947-133e-4c17-ae84-08df4714148f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|6133799003|18002099003|22082099003|11063799006|261026140227099003|261022115727099003|261022075727099003|261026130827099003|261022113327099003|261022105027099003|261026121527099003|261028144727099003|56012099006|261021121427099003|261102123227099003|261021130227099003|261021123027099003|261009223027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	K9LsQcYvZHZW3Wa20rlFIaPMEDkQHfauhsz/1u/dyo6gPerSB8j6inQUyPhPKgXw6Cx2vYSM/Qfgb5+tp9D8oaCjYVknOyebdolp//wk+qjeObtZqVf63nw0pO+q94e0QZePTejO5ywwix2AMYf+zVhnyWwSby8cjiOtUaTJeZwzeMilYA1XVtlQitgEmvdo2ZpaPz/TpuBQ16gjOkEexl34bkRMPOWOmamLgBvBYAuoNL+BWxhym/t5RXfwqxl2RvrfoSoeL87N07Fn/dpN17dyPLADzR2GPVN5FySNt3SQEsPPxk1asaQmu84PNoYTyTDJNtmZMEt5lhfG0WwKRjvF05TUO+wBEA1m0h8QGyZ9HrPSAO5e3N8XyYXPR4FI9a46J+Bwg43DkOalN8fRxcpTlaooIRcHX9sw096kf1PviOBcnPM0XbD7l994aro0WEwxLZZYcwDBXOUD8JTWTkhT0mWEo/u/HtVeF61yAclQb7qloMlU41bSJHexh2w6r8h5Q/ZPnGfYoiIG5lCVcWb6ftYjFFyt6fMYcA5vNNbX5rq81wDUNb0Wx//RZuQjwldiSmidUuVvF8IO0sK54sznlKwzdw++9mBA94R6gGSppbjKbKChRgFlGdNLgKEwccaafndlkcgc/yzLpCyTMCXrsbgFqLXXqPg+FA5Kkj4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(11063799006)(261026140227099003)(261022115727099003)(261022075727099003)(261026130827099003)(261022113327099003)(261022105027099003)(261026121527099003)(261028144727099003)(56012099006)(261021121427099003)(261102123227099003)(261021130227099003)(261021123027099003)(261009223027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0ZieEZ0alB2R1QxdndNOHhad1NSbnFMQk1KKzYrc3cxcDFoUmJONm4yZjdO?=
 =?utf-8?B?Nk1ZZVlXRVk1RlVCNDMySEdkV2t2OStGK1RMaHdpRzNQTzM0YU9hUXQ3aEtu?=
 =?utf-8?B?T1I3NnR5cGhRamJSbS9zeUpXcmkrY3oxajRPNTlFa2l6bExmVlVKbmVMYmV1?=
 =?utf-8?B?Nkd0d0I5ZzFab0xqZzVNQzRJaWpPemladFpKblRkQyt5WXRqeWtHbzhHK2Nz?=
 =?utf-8?B?NFU0MTRLb2xqaVd5WEh3VVJuaUt5MTJqcjd4aGxraFRnNzN3WHZLOEFLSlM4?=
 =?utf-8?B?WDc2S2JGcDhwaEhKMHlpLzdYNzNIa1BFOEVBdFVNejM1QVUyZmdvTk13MFJ5?=
 =?utf-8?B?UG1hekwrMGhpSzE4d1dVNXUyaExCZVFiU2E3U0p2aldEVHBBM2dmMDUwQXhy?=
 =?utf-8?B?RVd5YXVQblhRK0Z6QVhQanZoY0dzYkZja2RKUWdPUzh5emJ1RXhXbTNZT1Vx?=
 =?utf-8?B?cVRwRkdkQzJ4WWc5M3VyR3VwbU5rN3NuejRnTXRTd09NS2J0cHg1a0ZocW8x?=
 =?utf-8?B?dWxOM0ErTFF3SG84WjdjN2c1ZHk5UWNkKy9YZEgxeVpwVXBHZVhaQmFvdXdS?=
 =?utf-8?B?U0VBSDJtQ25IN1BYNEVaSGpWN21QNFkrTXdCaHJ1U1FHLzIvQ3c5R2tnUmhs?=
 =?utf-8?B?N0U3S3AyVjgwSjdjY0FXVUxVQVJla1Y3UWllN0piWVpXY1J6RWFhZDhiYU42?=
 =?utf-8?B?Tk1KdjVFTkV0WGgyaDZvRitIRFNodE8xaXpSTDg4cDk2MEd5MmJzTDRqYjRV?=
 =?utf-8?B?azdMSVBEeVBJMDBPUGNUeHdIa0dWOUJPRW1qM29Cdzhqd2JSeUdjNzZqWTJY?=
 =?utf-8?B?dHhWd0NSY1htc0RFMDlxUWRrUG1oankzek1tZTYvazRmc3VRUEcvZ3FRdWRH?=
 =?utf-8?B?ekd1OXdUTTduZVFkbFI0V3dUeHRRbFliRlVCU1UwWlpxd2N5TWhLOVRQL0J1?=
 =?utf-8?B?Q0dZcjRvK3R6ZzREWTZQQTBwTDZHZkJ5U2UyRGROZFltcnFndGNhc2w5azQy?=
 =?utf-8?B?UlhCY2hYRCtIL0VldGx4VDhjb3M1SDA4aCtxc01UbjNET2d6QWtpM0wrbFZG?=
 =?utf-8?B?ckNvUTd1ZC92VHRQNlhGeE9Bd2d2ditzYzdGR2tPMnNyR1lIdTRMSGxlS1o1?=
 =?utf-8?B?a3YvczIzelNDTHFkc1RIMk1jNzY4YlJxRk9BOHlhR28xWFhFNE1TWTg3dGFZ?=
 =?utf-8?B?VzBOemJTd0ZQaEVvTjhHbnNOTkc0cVBIRXI3RHNJWHhiT2RIdm9wOWZ3QzZS?=
 =?utf-8?B?T3dncGxMU0prU25BbGRXMWlDT3FlV21lMnhlK3pKSktsUm0zNDBOelNXallv?=
 =?utf-8?B?NG8wNmlGR05mRXZ1ZGJwNUpSVGdoMGF5elNPUlRNalNkb1Q4enJQdzdOb1RG?=
 =?utf-8?B?aU9zajlEd2phMU91V1k0dFRRSmlIcEh3SE9kQmkvNFdFTzVCNzRreHVYeXJP?=
 =?utf-8?B?M2tmdWRZc3ZidW5pRkxIcm5ObjFYcWkzYk9iQ2dJN3VUazczampzNkJVeFp5?=
 =?utf-8?B?dWpMYlBvWks3WXNKQ1VHcDBKOWM2TENqdVRvRTVhd3RiU2t4V2hFMHU4Sldm?=
 =?utf-8?B?QStyc1B4Y0pRTUlDWFdaY2o2MkY3QnBZUUd6T3ZZcDlVK1l4aml4cGFMbkhM?=
 =?utf-8?B?ejhZWnhkNmpSRUdmMVFZRDJSYm9KeUxtR2RmV1cxSlgvZ1dlblcrTmZLQWtS?=
 =?utf-8?B?T24raU9NZy9oVTNUZXFDTlFNQVkzaEo5cTF4WVEvK2VYeFBZQWFYUVVzZnRS?=
 =?utf-8?B?ZjV5V2h1UWpPTy9hSkllbEtuckp0NXhvR0dkM1BRL3JkSjhvcnJiQ1RBYkZ3?=
 =?utf-8?B?cDBUWnFwUkMydEZTakg4MUZTUFlMbm1oZktOK2FhSHhmS1k1ZkxGbUxpbElS?=
 =?utf-8?B?S2ZHOFluVkYrb2w1cnFTeWFZUjFMd1lKYmluNjdyQ25ENkgrT09DQUdTSWxM?=
 =?utf-8?B?U2R4clpSZDQ0YjRaYW83UCtlNm9oS29rU1V6SzZFajNsK1RDdS9ER3gzRUkr?=
 =?utf-8?B?d09UblBoUEUwMDdCaE5PL0RnQUoveXF4bzVobWFDcUptOFR1RStqc2E0ck1n?=
 =?utf-8?B?QlJwbTFWOG9qM0pXbU4rT1EwaHREOWxhUHFVVGI2K3dMYXNSZjYzMjVMMUhH?=
 =?utf-8?B?Q1JMYzhUT0YvYXcxdWNwQU10RXdDL0t4RFVJM3Z4dzNKdWtlTXhISEpScDFI?=
 =?utf-8?B?RTlsODdBcENPclU2TmEzWk11MkNNOXUwSUIwN2lWcVpJRjROdVJrY3h6Q25T?=
 =?utf-8?B?K2lrK0JjQis4R2dGOE9aUWpmWkQyeDlremtvSExJTmxpTEFmTG1UUHQ3VzBh?=
 =?utf-8?B?d2NRbW0yL2V3NmN1RXdOZ241cGZNMHBmcG1id3NrY3dWd1BBODFUdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17cf947-133e-4c17-ae84-08df4714148f
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 14:39:28.2106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKIuumkCpjM0jHBhLcEqyC3WB9Fl4s/4kbIud+84ZSbwnVPqryffISxkuzmiT2WzwBx9kVShX5x0K2SAZ7kieQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8235

Hi all,

On 10.11.26 19:38, Tariq Toukan wrote:
[...]
> 
>  .../ethernet/mellanox/mlx5/core/data_direct.c |   9 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +
>  .../ethernet/mellanox/mlx5/core/en/params.c   |  18 +-
>  .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
>  .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
>  .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
>  .../ethernet/mellanox/mlx5/core/en_common.c   |  38 ++-
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  67 +++++
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 253 +++++++++++++++++-
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +--
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
>  include/linux/mlx5/driver.h                   |   1 +
>  include/net/netdev_queues.h                   |   1 +
>  include/net/netmem.h                          |  24 ++
>  net/core/devmem.c                             |  85 ++++++
>  net/core/devmem.h                             |   6 +
>  net/core/netdev_queues.c                      |  51 ++++
While working on V3 I realized that keeping the core part in
this series is not the best approach. Initially it made sense
because the change was small.

I think I should re-spin it in a separate series with netdevsim
based selftests for the new APIs. I would base it on Mina's devmem
leased queues unregister [1].

Any reason not to?

[1] https://lore.kernel.org/netdev/20261120045918.1239746-1-almasrymina@google.com/

Thanks,
Dragos
