Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B4A42FCCF;
	Tue, 11 Aug 2026 19:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476736; cv=fail; b=fTdEWvMmvyahYo3vMCdUCPzP6tPTwptR4B6T3N5Ws8OfpLjxSp0T1oRno1XNHugBz2i9ckPMuTdMaAwwNCwhxrChKbVUDKUOOsgzmW/kXLzq0rOLfs3JffHuEaCKtCgYTMaNerpSleaXN+24Ou0iUdPBNWro0rvQanezlEHevJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476736; c=relaxed/simple;
	bh=o6NRU1xqqZemfxKe552kWp5TxTedNTb6Sd8lhULBOTk=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=JRBjGDFzavtOZGFZfn8fI18+UK8h8BKgWL/10MaoNHC/NWvxngKBr+vz5r/tGkj0IG8RpnDBLOAg982pigiq5A+KbWmsNkQ+BfVqkmIPDYJKwRpGOf4yFGGbSYhELoNDVjXojOMF/1x8DSkbc21lI4n2huh8TKl1pu6zdT9ap+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k+WqGb22; arc=fail smtp.client-ip=40.93.194.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k+WqGb22"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLs5vZE6ydtfCBOGmxCtIhO2gIWwvuZoXjF2q+8BgS+c31u0gnDyB8iqmWEfm3SpHH23Ww/T8bJ/ST+whgharkN26skfQQaq13KJ1oC0tdcqc3pVvvACLOcuh+scJ4P1IAobY8zS8iQtaVz3LK3v7OT2AVpeiv75n87Iqv5kIgYSzBYu3Zc/M+mGwDwfMdE6aiK2hKMPLJfFoW5ycRqQZLbMZUNgo+DsBp72wkwLyFGgqrm4I3XpXWzHTKEo36jxcn7JVOS4lrXcP8qXAa8NK6w1UsX9s5zV0spkt+1EVtlG9BybqfCGqdcoU9XGWohGeH8skoyxR1DZFpAd4dNhPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZH173Iyksy3JQ7b9QjULTk+Zq//IloeBNeQ7gdp0hVM=;
 b=fkbrdI5h6j5MHecGM4MiES6mgNjQ9D1OF/25/5XrhsENQ7sqIKVZw4eRSrXfpMde7AsoE/EVNjLVbtlpS69AWCkQ1ZYj1CrNH5bs9k2/G/96LDoidplrXHrNVZV0XBB4WjRpeIZb30y4CDSnFgyuzb0vzJVMjt0bZa8mLnHzerHq4qxzhyfSjA0dusrgm/CfSQ5E2sFymWy7Yws8dAxtANzHASWKO2ESeOeYY9wc4d9a/mSS//NhyPJnLmN8Bpjf2DzuqjJBYOGvGzd1W61usz8ZgduDDrb5+en01BZVugsPZrmV/fXWTylSgs+wwWVr5fNdjzZd43UHK23ZgS9PrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH173Iyksy3JQ7b9QjULTk+Zq//IloeBNeQ7gdp0hVM=;
 b=k+WqGb22rp4thf3/koT+OCtsCazIPcD8jdDSW38uFNo5gYBfWHc5dWp1pQnR+RkzmBykTYSqVQueT+Uczx1LnZpZrWU6A0q7NytwoOCk4+FtLyx+N4JGWSOdBpC1V0xqU3GnaAbOxrg48sLxzL7fIGpfTs93RWz8FOhnTolXAwp55Smam5zIrQYG2Dpi5FgkFKAm2agIbwaqxgNphA1BTrXwE/mFeTyOxbjl9a0d9d5SpX6xURuVk26fHlTlIiDKu2yE/Rkvm3rmerSAOmbL70gqCnnMrk3DzsbJ0lXeUDlSF1YZXKD760Qs5EKNRv0Bmd/tUcnVV0LHROmB3GajVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:48 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 03/15] RDMA/core: Allow optional access flags
 in dmabuf reg ioctl
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, stable@vger.kernel.org, 
 Sean Hefty <sean.hefty@intel.com>, 
 Christian Koenig <christian.koenig@amd.com>, 
 "Michael J. Ruhl" <michael.j.ruhl@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-4-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-4-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669510.282103.13398098220895835246.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: MN0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bdb89d3-cfb1-49e7-2468-08def7df2efa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aQPxvRJ4L9Q6qp43lD5j6X926P+6rh96Qrpg9I6p+nHsW0q4t36vG9RE3OY4Zm0hhRhlF6f1lxwIvivs5Ewe4voCNfxRcDsSDiayIUpICSIxuuVVdutcMxo0Rt8yVSQm83KvuJwYJsIn/TZRLTxxjjqFmCnAtHTRewtCTihIHj+V/k0OKosPpFjxSnANhgSW090Go5/VhDUBLpwO8laBoVoHgc3Tyk9cd9AhxgBTPXbPPk6YCROagPonmSS9yoV/rR5Uu1xw5n37+9UUjcS0Q5ZajktDYQF/wSzqyDjLjG0idk+pOGUaMRthKS0bJWBU5q2nTjuG7rw5iwD5CFodmK3RT4Gw/7diZVJ6wBYYysaej73WAcGArqAHOWGBOkRCGqvPsfnVPeJzqIdxYg2vkfvoqPI/YhwE4P257WYbx7EB5GJWaIexdnG9hVW4OybBHh14UnThdix4JMsPfOPxtXpq1guPfih3ox5WGcBNGJF7aQrmANtItVH0RY63s72UCJLj+0fU4cL/tjoNlUxjoiWn/i2YwC04nI88dOSD3UHQBLCX4usCv2AbJHBZKcgSpSTeQyxtKzLiGICdqXdXzuq+kBpdJn0pNQcDucrzFdB8V8+BKuqSvT039QGgkAoBcCUHZZhCYzQHhBKwI0GalS0mOX6/LDjXLo8RJNodd0A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aCtlRU1UcjczVDRudTBaVXdOc2pRcXdsaU5mSzV5UkZFbkZaaVFBV3ZPbFdI?=
 =?utf-8?B?WENtcjIxZjVJMk9kV0RCUHFLK25pd2kzQjlmTTk1NFRCdWp2ampaT2g1Skho?=
 =?utf-8?B?KzVoNEJGd3dYTFQwa0NYOVJXMHZTQ3FGbmk4NTRUU2ZSTHd1bXFmdFdaaXRQ?=
 =?utf-8?B?REFPdCtuMDlBREw5aGRNS1Q4WFo4cURkaWNnVXVSWHB0MVQ0V0hvZXhDMEx4?=
 =?utf-8?B?QUloRVlYWVlQc2JacVEreXlCSHBhdWpTZVQ3T3RXak9GMEtRSnhoMWFWaXli?=
 =?utf-8?B?SjluK1VjMnJSNWVkV3lWdEVvMGRDd0U0ZHdjQnNvSW91NUl4VEtGZStSVHor?=
 =?utf-8?B?eE5zS1oyeCtPZ2NBcTZkczRwaklsZHNQNGFhKzcxd0xZNFIyZ3ZWeUc0UUZG?=
 =?utf-8?B?Q3RGV2U3TTk0M0NBMVhMRzB2RkZMdjhZK3VtanhjRjFmR0NkOXNPTjlpKzZt?=
 =?utf-8?B?RHVReU9qUDFIRnpFbGVmRlJTdHNPYWQwRTNyOW1IZmw4NXkwdGRDeVhuZFZX?=
 =?utf-8?B?SFVrMDhaWXAzWlRQVzl2blVndzFZb2t6WnR1L2F6NVdmNlJBNWxISmlTR29O?=
 =?utf-8?B?V1RMQnROZm9hV3lGM1RkKzkyTyt2d1V0MzJkTzFhUjh4N3prbW4vd0oyWFgx?=
 =?utf-8?B?VTNCNXZQOThjN1c2UzB0TWRpUk9jYlhBaWFwc3pOeU80enpuY1hwenpqVmlU?=
 =?utf-8?B?S29ZbGV1UjVhZUQ1NGVZQ2xRLy9ZcUl0Njg3NEpYZ3ExeUJ6RFZEa1k1M0x5?=
 =?utf-8?B?UVRPbWRUcWpKdjdlU0ptRmJhMmNZMHNRV0Y3UUZIN0diRGF5QmNHKzB0akVo?=
 =?utf-8?B?RUZGd3pyUU1nWlJxVm9pUTY2SVJhNTlOaC9Hd2lhSCtUY1dhY1BrYVFpU1dO?=
 =?utf-8?B?bUNtd2dEVmt6YUt5ZE1tN0lYTmZXS3ArRnhhdExzMTBEa0VPTkhwdmtYTUtm?=
 =?utf-8?B?UGhkQkFVS29ubjVVR0xmYUxxOFBPMGV6N1FyUEVMS3piNnIzVVNVVVlIQmtm?=
 =?utf-8?B?dnNudWJsQ2Y3eUY5M3BMczdlNE1CK0R2OGcyY0xMOEhDTSttYlVJakp1KzJp?=
 =?utf-8?B?NW02VFNZaVJybkZpNXdFTndWbncxdzV5ZkR2TFUzZ1ZOL3Y4aUdIczByY1RU?=
 =?utf-8?B?ZEVuTDZrZmN0a3hMbitpSHp3YTZtYjNEcGR5ek13R0IxK0kya3gwSiszWE13?=
 =?utf-8?B?WkcyRGJJMFJkYXpERmpYVlNrckZJYk5DMHdBSVZCR0NhQmk2aEc5dmVJaXZr?=
 =?utf-8?B?TDVqUEc2SUx5QnQzQ3J3MDVxempmanJJa2RtcVVnQ2Y4RlQ0eDlhdmpWV0VR?=
 =?utf-8?B?VlIyVlVFMzIzUHZSZzd2SUdrM0RUWW1xMzR1N1QxSVoyak9nR0JhNzdVbzNR?=
 =?utf-8?B?aFRpcFlUQzVtbWhDY1llaXMxUVBZQWprM0ZwOEVkMjFQYzlvOEdFZXFQaGFj?=
 =?utf-8?B?S0dDR21jWTBYTXFjeEtvUG96RDlhak9pUG5NZHl4WjNvdHhoZkpjdzB2T2dD?=
 =?utf-8?B?L3NOYzk2NkVqV25GT3JDZzB1eHA2d3g1ajJJVWZQWkZ6eVNXa3IxUG5kYVlm?=
 =?utf-8?B?YTFhQURuN3V6RDVoTE1HdzVUUFJmWmI3UFBCdWM4SzYzUzdmMldIaHRjSXFG?=
 =?utf-8?B?YkQyQXNQWm9jQlNYZVJzMGJTRTNTVnhycWN0TnJ1SW5ZTk5aNGgrN2swRTEz?=
 =?utf-8?B?VUU3RlU1aXIydndQWGx3N2JQVkdXVm5oeXNOMER5OFpQTWV3RytCMmkvdmxM?=
 =?utf-8?B?YndaTkhrNkZrcjc0a1RIcThKbXRTYU1FM3NtMStIbnNOSEFsU0xaNFJzRit2?=
 =?utf-8?B?bUp2Rkh1dFNRMURPR1E1TnFKdm4xdUNnZGhoQVIyeVlBcTFieGorTTF4UVJC?=
 =?utf-8?B?b2lUWFZ5UHQ3NTdvRWZBcTFvL0pBVkFwNXl4NVllSURydzJabDJZcVp2bm1n?=
 =?utf-8?B?ak1ybkRFaWRnc1IxMGM4R09LTkpDcGFKZXlaUHhvcGluS24raWtQcUxScEhs?=
 =?utf-8?B?aHFScGl6K3hUZUFBQWNOOGVEb2tTUmRCcWdVek1OZHVyMDZ3Mll6aWNVcjNJ?=
 =?utf-8?B?d25pd1BnOVMrY014eFdxbHB6NHJoNy9rWVlEbTF4bzV3RW9EK2RBMzJxWU1F?=
 =?utf-8?B?WndJbmNxTTdHeSt5bXphL3YyOGk5WnpvUzlqQ2pWbVd2U01JL0M2TEhhbUdm?=
 =?utf-8?B?S0tJT1pRUHc3dmZBS0YxVmZ2UEE4WDVTQWp4bVo0Y2ZxL1hoaXRZU2loVHJY?=
 =?utf-8?B?bTNVM092RG5mWXQwL1gzakF2b3FVZ0s5QnFjMk8rVGRJdy9aZnpuTWhaemM3?=
 =?utf-8?B?ajE0aEgrWW55OXp0azZDaHhDVjAyMlNQY0FTUytScnFEL1BzKzQzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bdb89d3-cfb1-49e7-2468-08def7df2efa
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:47.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwlPAwxrlbZEylaPx3JWvU43ruR7N864T90s7397LscPxpp57z6TvYLWusgWZ3DM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

On Sun, 26 Jul 2026 12:29:17 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> The uverbs ABI reserves the optional access flags range as best-effort:
> drivers should accept any flag in this range and treat the actual support
> as opportunistic, never failing registration when an optional flag is
> requested.
> 
> Add the optional access flag to the allow-list of dmabuf registration
> ioctl. Uverbs users can now request any optional access flag on dmabuf
> registrations and drivers will apply the flag's effect on a best-effort
> basis when supported.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
