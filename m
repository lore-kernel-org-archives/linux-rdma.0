Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F482306768;
	Tue, 29 Sep 2026 23:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790722823; cv=fail; b=frfZ+QQSWXh4FmNkLshPM+eS5OmK8E7m9XrGZ+ODKxm+vqLI266KfW6WD2MdsXud7NHqQ3i5pcgqz1+fssMMo1e269MOhrZLaz3oGsDbK8ijK1jGoLl9XVvdi2Yn3xfWfc3bP/HJpNJm/X0Oo/JvmSlrrt9yEnnHBPdVrbi2q0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790722823; c=relaxed/simple;
	bh=goz/B8RzTeWDvDkwx9hCrtlniUuukI5lhEhHpz3QsKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TYmNn70bANAgKoHmllE1K5dxsSL8lmEbZBlj8dFxk7yLbpXvUYeI7ZjHXoVDzp47kRfJO6qYyz6jaUS97QkcNZwqszSoKTgBlrOqTCHbvTR4kpjl/cVLzYY9PRPmbOVKThYpFXJQ8UcSjx1CYa9s491uxVVOBve94bZ/6NMGU+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CDBW8qz3; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CDBW8qz3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPWhJdL5Hqurkh+GoJUIfLoFDGDUoc0hIsNEsan9vp4D6YOjHxTUQZqguJuB5Lzq2THV/xPqUt0c6iivedDjdiapxj3R9sNh5A4V9854OjbtwX+8vlZ80aXrEg4yCQI1hlq4xVRPmcEHjt9p3Mj5R5rgfJOR5TiLn3gXPkjv5Y+K90BxhXatGsK6/iGsSLfBn6LjDlhkfte+pwCSbdqrfWeVdZ+Kyvz5A7DcpMwju3qOqCw9aA/r6etZuM9UaLW9S66GM4royyW4rV+iCBkuq6Mfb97XuAqV7OaE9cC7lKSvKzD8LypIZbGwbMJvD8w5gMPOsCxaIs/x7SUpelc1ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3paQFs6Wm6NIg6HMzNygrXX0ufR2Ts8jwtq3pmv/MU=;
 b=nhtmOvqqSZktvTtt0X6y/8qJR6FM96stnUVctWTzsmAJQ0ux31iCKTMLpxkHuFDEga+xo8QL49UZrQWxkv3+Im8sSlki8gxNXdhFGsuVvIk6tJInh4KQn/X6ahNyoUeZN16dX9o7TnVa5goafGShra9UeJBsU4fjQDmeousTadVINTbR3+SOPWpqxnJ4LJCBLqmK7hmqpwFBG5ZcRJo9bPlYHARAQlG+CpJOUodyTkfLSpVGvVxqi+cttZA7nX/wbI3cgHTLYComLHrZOePgM8qpDfadCMTglYLC9hGD4M9UpCkw+E8HGufcpspBUrhnl+ECfeL/FC6HHb4Glpomlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3paQFs6Wm6NIg6HMzNygrXX0ufR2Ts8jwtq3pmv/MU=;
 b=CDBW8qz33oKc42wMCkcSVwN5WpctNyNfP2Q+22p0znaDjW1P0JeQex9oHrTFHdeNxSlWouJaZphJsitTaQAV217eyY5u6PzKozgASjqxiA3k9PV91O8t/IdJaV7ymwCUMuYjFWq9L3iSMDu1f8eIDRhje4hJkSibwMX0dzFfBCaxrlbVNls0kQZB9TZ1DT6HTIZfBatree42bt43k6ZjAxNpezF48VKXnV5NseLDEnQdJ1CXemP8MucVYT+l5y7c4GFoBwpAaySVrzzjNPlKo8VJnXJeLVEqShXjlyb4CE0Ti55TST2nXjk64IYHrOU9KGOZH6sd/c/rsp4ydsrPgA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB8034.namprd12.prod.outlook.com
 (2603:10b6:a03:4cb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 23:00:11 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.024; Tue, 29 Sep 2026
 23:00:11 +0000
Date: Tue, 29 Sep 2026 20:00:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>,
	David Ahern <dsahern@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/selftests: Fix the kernel config fragment
Message-ID: <20260929230009.GC2446731@nvidia.com>
References: <20260927161655.1184153-1-sashal@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927161655.1184153-1-sashal@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: d21e090a-fa70-4338-a1a9-08df1e7d6a4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	W+sxM3UwcWy3FLNP6OJkzPbk3eAD+hXBUDClIxKdR1UTCVy/PlN6F/kov3jB4MonP8WOZTwSm5A+dw5s0cYqUhGHpDam4g1JSAe+ElVnq4WcNvuzNSsaYZrOCg53yW2g6ygADi0IsWEVTaGW4lVKOIfM4KPHoKecTpBaOBmHBCG1DK1jnCS6/PW3zoZK2MeOvJNEcUAV5xRwhbKOREzND49C2EOz18xNqHQGRk2F72lQ9VVCkXI5SPIMuF7C//vGClzvy/DdoQxMDRTq1s3Dhrz8pev0yxTkBaLITz4ifqnEwuYgBscMbn/cYMGkchmWfxjVJofOIHo8Cff57aq9rTkY8Uf7HgPjEeMXIaR6Kk3THHMcRS8kAHIkQwZZEqHcCrGIgVo/Hw8g2OleXEiMMfRci0tbio30JHek4Suzza8brYPhTi6M9fwuriUTjPPNFpQrg66xiiVXCjkgmKnmL61aTvfuIzbkqnML5qJ1y2AAJ+UOyc+iQV/zR6UcIwS+R9m285CnNSb+n/xarag9+l4P/aoa9g75hFy0g1LmxSGO5KI9yDokopgbk38yEC7L2PhABsk+oOBK9U3utnEkt0qxFc+qzlAAj/BxiS7dmRc7uo+fQTZRFqIC5lYka135fSqJa1a677lY5OSGOFKhCp4xnpgKhR4T+aow/O24av4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U7JjAiPYPYAUx58VuxfThsxM4veVbi16rgoNIXRpsPDHP8woEaU6K5s8Ohsp?=
 =?us-ascii?Q?4IZE4w4tPoGOzPQSEFmn5PqCRQpStejB9cwBs2TPWaDeVc8fq/Hh6yj/AYTl?=
 =?us-ascii?Q?31gp2M9GiXc0qbPXEYV1dMxUyM/5dCv2TXVrh5l0vu+6DVlSL1CDxOBYzW02?=
 =?us-ascii?Q?5Pi1wAyjg0ihMO0/kgetkzi4Yt/z9vL4H+XTvKNhuUE50rGLbdR1am+P3gGD?=
 =?us-ascii?Q?jNOAGWe/cUFUMjCbZ51A8itmlyE1F33GFgxJz0lviVXekAaJUU68G4rc9Upd?=
 =?us-ascii?Q?Txh5cLdnl6IQ87aWNDBQXrTdQ1zXX3yGVc5JG4RbfEzsBfQCGLeDXDfQlKXQ?=
 =?us-ascii?Q?kj5TnhHpuJoITA8hcZbL+d8ebuo6GCqhKy2Gu859MPeL79bh6sF8SayR2NSu?=
 =?us-ascii?Q?dGYJUPh9LCq4JUhJBVmMt9DVjxvVSB+h6R6sobzsHsknmwUkAF6086Y++mrE?=
 =?us-ascii?Q?5sbZ9u7TNJvP8fU88nQrlCMF0a4ySULyyy5xd/2rLrj8NB9kfu3COnE0aUm7?=
 =?us-ascii?Q?Bm0zhuvpHcewjiRQKcdE2xKaYytVq+g8/WxbR6N9F526hO26oXivb6hrWcDD?=
 =?us-ascii?Q?aiUCpn16h9+/5G3rX70rhNxV0kyVWVb/J/lx6noDnK6T1G4CMawAyVXDrdHM?=
 =?us-ascii?Q?aS5SPInIde/D0zO88bah4ErH/ECLVX1CeBZrp0nb5U0WvlnvXIIrUmw+hTHx?=
 =?us-ascii?Q?oGTfYH5Y73u9mj7EyL/PYlMcMUUTXShJfHqF3dNhQ7eJug3AacDYcBmdgr4Y?=
 =?us-ascii?Q?5YM+utHostBVgd212uVO+bnDL5knUZGzA4rlgVDmHtRRF89vjvi2hiFmbPz9?=
 =?us-ascii?Q?z4p0uR3dHaYQUeUv/JGI0K84wBfVKkSimrDnOS8RXWCASvQ9SEfSi73OgaTz?=
 =?us-ascii?Q?5inU9gD/+fLA6ab69GIrToN3vMvGcfTFx5HETCadUFfw4XQbCsn1op7vzRem?=
 =?us-ascii?Q?3LcRkv2LXT45BYHgUybfHIDP0plqHHA+z3bhM2dlSe0pltl8Dq3CDIeBiCLA?=
 =?us-ascii?Q?9JdiGjAMYbik+UbS6SACTGEpp2RovXIopMGCLtwBkIhShbPJkHJiEYWrnCj8?=
 =?us-ascii?Q?PMI3xxrCR8QblqMm3ajTpkChSuWY07xFIPFE+RyPEuoshNiVGczJ34QABq5G?=
 =?us-ascii?Q?kfxcEMV4OlWSvQVXSbJWsGTuPj5hoQ8l21q0FZ8YY/oxYDyFddfBy/yAkLaV?=
 =?us-ascii?Q?CN2KNU+MGYLHR9zPquoRgDh0nGJaj4MxbdwfprW/EkLVBXa3ahKF7ev5vE/P?=
 =?us-ascii?Q?CLNGmuambPJyijk7a8NoT2Pt34hVPyPMKmyCH1bnrziT98ysWHvZmaHxolYc?=
 =?us-ascii?Q?rn1mJp4roTIxWBEcuzlIbjQg0+v3KRNs8QmLoKGHlXeeAgvKWw2VTt/pone9?=
 =?us-ascii?Q?ryIIP7tSPZfF4/3Wz7XcaYd14l4ZlA2iHs8ZxzA0VRb6Gh6iyj6NbusFxATk?=
 =?us-ascii?Q?e87j2WLwBbn5icy+qF1sOm2N1Y+qfzrILkCJ+WGQPHpbur74EBBbhn/v81ku?=
 =?us-ascii?Q?MxeIaRRRD1e84ClkYasTtDF2RgygqG42klAaCAWYNNWnFdaoRVEvtaB3nBmC?=
 =?us-ascii?Q?g4vbUOou35XzNJqWEr481qgWz4YQKs2bDENMb4C+K7ZoLKFqCFdacOed1TUt?=
 =?us-ascii?Q?3uJ2YMMoc7FM/9j+8OWYasE88gvj2Q7A6N3q1okE1T3lwhVgOJ5pZq0L3S/M?=
 =?us-ascii?Q?d8v+ZOXUgAuDxe4WGrELzClwIEeoS8R3K27MwMZWHBTQkCtb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21e090a-fa70-4338-a1a9-08df1e7d6a4d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 23:00:11.3868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7sHqbvMbp7XdIoQOLxNVCqxxh93gNmW32sxzWzNm2RR6dVFdjEGOa3TBe2roqKf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

On Sun, Sep 27, 2026 at 12:16:54PM -0400, Sasha Levin wrote:
> The config fragment lists bare option names with no values:
> 
>   CONFIG_TUN
>   CONFIG_VETH
>   CONFIG_DUMMY
>   CONFIG_NET_NS
>   CONFIG_RDMA_RXE
> 
> which is not valid Kconfig syntax. When the fragment is merged, for
> example by "make kselftest-merge" or by CI systems, the lines are
> rejected:
> 
>   .config:5514:warning: unexpected data: CONFIG_TUN
>   .config:5515:warning: unexpected data: CONFIG_VETH
>   .config:5516:warning: unexpected data: CONFIG_DUMMY
> 
> and none of the options gets enabled, so the rxe tests skip or fail
> for lack of the modules they load.
> 
> Give each option a value. The scripts load and unload tun, veth,
> dummy and rdma_rxe with modprobe, so build those as modules.
> RDMA_RXE also depends on INFINIBAND, and rxe_rping_between_netns.sh
> runs rping, which needs the RDMA CM userspace interface provided by
> INFINIBAND_USER_ACCESS, so add both.
> 
> Found by KernelCI kselftest builds.
> 
> Fixes: e01027cab38a ("RDMA/rxe: Add testcase for net namespace rxe")
> Fixes: ecdcc8a455b7 ("RDMA/selftests: Add rxe_netns_names test")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
>  tools/testing/selftests/rdma/config | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)

Applied to for-next, thanks

Jason
