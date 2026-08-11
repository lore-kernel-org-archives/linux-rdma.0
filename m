Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011030.outbound.protection.outlook.com [52.101.52.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A5C30CD82;
	Tue, 11 Aug 2026 19:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476722; cv=fail; b=ZCJ81zVNTXv70Fyga20knVoxVUdUky3TcgpmQOQILPlKR8VCNAu3hTy2OKO19K5vHKLrKJ9vFrDVvAJsZHVAi7iYGd8o0MyY8ionORGZZheEJUM+C7lJZIz22RPjQmWxW3O8xyL46hPbIR7Va0geplwb32Nt/7OPuhQWaz+R/pI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476722; c=relaxed/simple;
	bh=SkAuD3b1JePXFTrVWnLbSwd9Vq8ugzzspCwxYwtvYiA=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=jeAT2uSqCXZywOajAebOCw3PgbFEpqleNeLuY9TujsNX3IrS1zioJkhaVfqy7e0DoFGuDWJCvHmc+WdVsW7Ul9zgaN+a4NAJQ54pyqvH7BgF5E/aJF0B2iK51o6mCwPOXWo3+D96m17n+p3m3+V+FLgep8zrDaUoZ9hUq5ziNeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LTPtUqpY; arc=fail smtp.client-ip=52.101.52.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LTPtUqpY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIGsN3Ddy7XHukGevl31CpDhD3uxgz884Do3BX0GGr10owcmneCUh8U03SUTxRiKHVVrk3a0LyZ9Lvnc+Cjdl1XKlTzBfFv7ZmfHYJWCLqtt2nYNsQQi6E0dPGgTFcG8IJ5+dmqxlhUdXRzzSCj+v+gaIpK3zZtyYAkK9SgX9F9XbDP6ydXY7gXTT23vh2EKU7yd4LBmqSy7C0SxRGnZal5CKFenrHNNTYmiy9Ksl65op3Re1EziitHFQKY2C6IzaiwmnC+jSgXiSYayPTe+srZLGHrJOy7QZBojXCXts7WjMMcboByLbozcKE1Es4vw9ongT49d/OQiUtCzAgwmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjEoSu5B6bMp/Z0qTy/bUk+h2pY0oJgZhXVFsEmVqZU=;
 b=ZnIbwDVbiJQ5OuuM9fm7LtRKDxwpCrBYdDYcVKxM7ZE85aMMotN1/4WJ7Ed1nTpsxOGL7W4jrQFHqYzQzJFYeXcxxRs1BqikaE0+LH/nWChN1Yd+fsKZLDzI3+nVewVupFjsY81PEnB2ZqcHV6y5jpkI7MtKDonUZnQPBoVV2ZLKQQP8B8A9hb9ia9oLgWa7SeAvh2FfXRL22gPrVfEg9EFepMQHCPnIbyWB3ebnhDAA91a5gImC0OKC9M8yckGq2cRJKhJGkj3etadWzXMFsppq0NXN1dkQhr44Iq1zIdfuyVZh38NPW2VJGIFU4ZXu+DC7IWp1ZjggyCjBNf7C9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjEoSu5B6bMp/Z0qTy/bUk+h2pY0oJgZhXVFsEmVqZU=;
 b=LTPtUqpYYnL9Mo3m+sn8O4j7xjRNVfnzKRQ6qONbcbTlMCwo0WW5/UxzkIJQD90X7mBGztCPCqH1y45nHZ0FASpaAQn5nAR3KLHL3/J9Jepr8CGkdkDs+zWWGFwtZVLDHHmz16N3M1WvHlbSoj9fNgwsBwJb7D5o6jMcTEibhCpK9q6ZmgQRW3c6wYZ+fvDFbez4aDyVuQubyK964uI6mr7H3uJUm0kbYZsTerVtdo9SQPjPXOrMakTedSXG6lqVACvRYo9quyjGrP/54QMcCB0n6ZfnfKlwoTrMSupMQC1H24BFEgyvIWdsZd36LQomfKwNbdtUtPQSFnkrboWcmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 13/15] RDMA/uverbs: Add new Unordered MR
 access flag
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, 
 Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-14-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-14-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669518.282103.10881077152543881369.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: a17bb550-4513-428d-936f-08def7df3072
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FqyGx8yxOOmAWD7QI0VZ5HLOXpFd8DqNf0Oe6nAWBh+wJtXBOpahi6ixriG0fKVWKxh6LVXdLOkqdYCQ0AOILy9HYcDN4Sp1Cz+qerhaOnYupSAxt4UHTSE4jYfNA4aVjJV07cFg7GTI9CNGCbFu3LG1ObIT0wCuxuxFi2PWY3Fx9ztghUlZvYDMtj8EwcwrPiXOeKshFXHQeoSPJ+2rOXG/d2DFLFxCmo/rsJ8sDwz7ZUVLPHvHpD3lpih693c3QGLNAUD+vUdhDfCjCfC+NhGUnxaW2hjLdhut9pwP6gejSSwcKXpQV8nxpFALlRkTCtjfIwOS3Y4wZD3u3tu9jd5P1g5UitHs4WkbmOG7GWzs1dQnxTervpR9Ig+99ZWhW+93qiwcwzOdSeZ+I7liQY+bx33wg0FhjWPBRLB8Sb5fQPa87XCsT9d4wCZVB9/OjHu3Afr4DJd6cixSIlmKvjn0AnyHl2jB+BRxR0zOr/2PkqXDrXzKb8qCERoHj1S9I7Q/x02Rk8j1ZAELLMU97whErYpIpZgI9Cpj8AIkkOPFUVdH6ovg+C7SJ7PlTqAGhxNlYt3QlQAtSX5uSjo5OV0F+nY61pyBE2MakmNz8IkLXngxfiovM59R6GIqrOl7dRh4oBIfpFvmBTAum7i9lhzTXuzPloRffuQlXuMe+zA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rk1xWXc5Z3RIREtYTVl1NFJFQ1BSWkh2ZU1YQldydUMrdnVmY2RmOHJJLzMy?=
 =?utf-8?B?RWhZb0NVTUVhUUVoUHlGenE5QUNSbFplZzJpclRrTnlRdU1zd2JycjY2SG5z?=
 =?utf-8?B?dnJvYW8zR2hhaThRZFlVTUpjSzV3YWhGMHU0eEtSajZsWnEzTXJER01aa1dG?=
 =?utf-8?B?bXR4YkUxaUduWk9ZQ0wrc2E4VFdxR1U3VmRhNU82N3g1cWFSV1B0N09TSHVu?=
 =?utf-8?B?T1JDaWxxY3VJV1NBaHNTSzdzQ1N6Nk5zL2w3ZTk2WnIzMzI3UTN2WWhrVE9Z?=
 =?utf-8?B?eFA3WS9Rc0cwbzYvSHhwaGJ5TEF0MXpPQjBHNU5YeENoWm1KM1lmZ0JXRXFl?=
 =?utf-8?B?RFA0SFRSSzBERzVHUHo1TEw3enlHc1FuWjhjTTFORWNQem1kbzJJRmRScHNX?=
 =?utf-8?B?SnV5eG1iWVlnVkRIek92T2N4NkE2c1AzNks0QXhsTE94RjZKZXdBQ2pkRzQz?=
 =?utf-8?B?MytkNTN1U0ZhRDl4MmhGMjZWRVNlajdWanhCRllwNTlydUpVM2VHbTJPNG5i?=
 =?utf-8?B?VEFRcWp1V0p2RUhFK05QMEVNeGxuSTBiQ0NsUkNiK0wxNDI3QlFGUGtaS0VJ?=
 =?utf-8?B?WEExZmhNTmM1cktlQ3E4K281QUNJZy83aHVoNmdrZzVENVR2WTRDQUcyNTRG?=
 =?utf-8?B?dTBtMmUrMHZ5ZVBnZlpxdDJkMXJXOUJBM1IvWkR4L3dPN0xWUnNQQ1BWN1Fm?=
 =?utf-8?B?cHJUZlp4TTNYNTBaR2hFUFRnS2ZiV1BCemQ5VitMSGsrTWIvNEJIVHR5eWtP?=
 =?utf-8?B?NmR4Z3YrYjY5SDVUakhoMlcrSkRiVjduWU5leWxNVUNYeEVwUDhNSXdFUnFp?=
 =?utf-8?B?TXFnMzZmdVNNdm9aS24zL0x1MnhLL3NVVmlLUndNYk1MWjVZR2w5R1d2VE1q?=
 =?utf-8?B?M3lZcE9zZGFyRG1CaFZjS3J2SmtsdjVFN3pjVzFHQXVQS2hrZHpRZHAzK0NF?=
 =?utf-8?B?aVlwTGp1SmJIN3dvcm93Ky9VQWQyQzU4UDVNWGJsV1V2eFRUNDBmcDNMc05S?=
 =?utf-8?B?eTZyZlRlNlM4QmVVckk0bm8wYy9VMXl0N0hYTE5QSXluY2FhUzZOL21veTM2?=
 =?utf-8?B?MFk5UG8xTVdua0pVYVN2YzNDS09SbkJvMTlMREpra0NkSDlTTWNVZ0lYMjF3?=
 =?utf-8?B?MmtFblNFeUtnbFBKWXBobHUzOGtET0kyOERXR3BhQnhmbHlJMElQZHRSOG9E?=
 =?utf-8?B?Zzg3VGdtWWFIS3ZzZUZyMnlSMEhIdjhvdjYzbzJza3ZQZEhqeUVvcDk4TUlJ?=
 =?utf-8?B?Mm5BRVV5S0JKTFluOGZsemNQaGxtbkhHTGdlS2phbXFyV0xDS1RuL1ZzUldG?=
 =?utf-8?B?YTRrMVExUVhWTHAyRm4rYmhOc3YwLzE2NHBXbVBlZFRRS0p2bitxS3BjUHhH?=
 =?utf-8?B?L2ZROFFiUUhRY25CUzd6OVo4WmRTdXBtMjcvYjVlRnlibkR4YWhhcXhpNEVa?=
 =?utf-8?B?NmpNUjFNaEZhQVdRRks2RDhETzYwTmFXUnNzNnhCbUgydUNhRlNFSHl1eWdt?=
 =?utf-8?B?MkVRVVpnSHFNd2krNWU0czdnUnlZdzA2Q1hMa3lOWnNuaUpjSk5lYi9RNlhk?=
 =?utf-8?B?UE9KVTZSVU5PUHdGSS9FaDNjdzIwdlBGc2lJTTIycFgzdlk2dTdocy94cTVJ?=
 =?utf-8?B?cVVNS2lXSm9QaVVaczNvbFdoVk9Nc2VMeDFTT2ZNSFYzQ2NSQVU4QkVLRm5z?=
 =?utf-8?B?VmwxZHMreU42NXNKTDJKNVg4MUVoRC83WUVzZUx1Y1orazFLckw2dzhWSkU3?=
 =?utf-8?B?aXo2dWM1NjNveDE1Y3JqemV6c2QyYlgvbERJWktwS0J1VDl1M0NqbVB0WVQ0?=
 =?utf-8?B?eHpHaC91cE1VTjljMDVSZ0pBUDBZdENkajFlU0p0RnQ2cmMxZjRtUUozNXo3?=
 =?utf-8?B?YWZ0bnoyendva3piL2ZueXlZTytlRUIzTjNUMm5vRTZ6a3JlS0JBTkdkaEZK?=
 =?utf-8?B?YUFId2s1b2tHYW4vc1ViYTdnUkttWkNjc2UzMjBsQzR4QU5ueVhscFJFTVFk?=
 =?utf-8?B?MytQaStxVFc4YmErajdvNStZWDVQNFg0UmQ0YitBeFhXWXIwSWg3TTYyQUla?=
 =?utf-8?B?bGdTa3h4T0V2RWFTMEhjT2FqWHk4Q1Jac3J1R2crSXlIWFlNK1QvVkhOM3Ft?=
 =?utf-8?B?MFA4Z2trL3RsbjBSTVhLeWdwL0lydUhSLzhnSXRRbjNKTlFpRHFTcnpYV0Jw?=
 =?utf-8?B?RHNoTkNSUGpETDgzSDlkdXhTRnVjSWNwS2dYOGN3RWloR1BxMFVWVnBWYUlt?=
 =?utf-8?B?dWkvODl6YTlkbGZ4cTFkMmF3Vnl5aXNXK2xIcnlUakw2SFpabndTQWl0YWZY?=
 =?utf-8?B?L3FKdTlaelozN2NXRjkzNHE2YmdjK2JLVXRSa2s4NnZjcGdDckNtQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17bb550-4513-428d-936f-08def7df3072
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:49.8117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytwYXhbJQtKSNf6djXUzmXWHwtvuECE3nu9SN6D3bDSrdPoYs5MZX4QMxvAxCvfz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

On Sun, 26 Jul 2026 12:29:27 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> Add a new Unordered access flag for MR registrations.
> This access flag allows additional relaxing of the order of memory
> accesses to the memory region.
> Using this access flag allows for concurrent reads and writes of this MR
> to be reordered.
> 
> This access flag is part of the optional access flags range, drivers
> shouldn't fail registration for any value in this range and are expected
> to treat them as best-effort.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
