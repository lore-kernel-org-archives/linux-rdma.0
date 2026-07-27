Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBDF389E1A;
	Mon, 27 Jul 2026 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785116504; cv=fail; b=RvxEMXkqgSD+mcM+tPH98tlhmPP1f77X2Nghpyo2A5PIPky5OFiwLoF4KMxEyKD/uq1f17w9N+vXCNTChYcKfgR64dcX4SjgqzDU5rzg07G6rDto38Tl+s3HGilqig9yNZRQTRJPj8eipcjxOc7oC79ks2d+mnCkkcVgips1je8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785116504; c=relaxed/simple;
	bh=l6l7/e24gFUovIOWzdxRNdEPNf2XfHv8FEWxLmIQr7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZCkPbUcHBySGJTijm0B3hYWlbzIli+1PAV1R5m+gE6H0JoWKiycm63ApXwsFFgZl6n/ntrN/MizwmADXcVxsiT9ZGqRmVnL2guTgKBz2iRnG8Eh3FCuq88xdEZtsMWt2KE9iQgNzkNbLtQ6fcLL7kuALxHQRs6PFqFodxymo4HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jIYNuogx; arc=fail smtp.client-ip=52.101.52.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jIYNuogx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIwqt2vYqFkAG5+NZslClFI8ZvtPUQd2qCAJSfJVCtknoq+jomx3cAhn9wABxEQOI3PhKuqrg2qCAs2IoTRvCgBqKN2zIaRc4Jwkxzm2kRpEQ5qPb1L+5z5ob1KSn8dUxLtOTEGB84PBSsGS4cFdjbkwTcDPah+TP/Pv3OCDAeWo8slSM2s/G3gUXmZGesFlHnfL2qcO31NWEba6gWIyFpMiLEx6flPUblNEPPHxEJ2HpI48tZyOymNziCIPZZ0ZA7TxDRMgTJziEr/jWWd2PETEfFJ6DLxgTY7sRLgzDYEdxOhhdBP3S/RLo14Kev/XBOi1rNmOCQzQOvGIvIZ+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPzyQrQQGWbiSn2TY7/ukuxCl1vnihWtmhQA6AXih7k=;
 b=Vdk6B5GyM9A4Ki0KwGcpF74naIK5JytESmnC7sk60DWtvrPZwtI1bLmxqifV9tKdHHZW1lM4Iuq9vD94CpOZdBgDqKoCBM329yy6rJOCK3wKHT7/lfEvuLHIZUcGj0TLrpFQYCNwexIipF/is7r0TSoE6T3kKnjgntn465rYiia2x/tox8QRWzPW+8NOd3f1s9W9hZxyRDGvoc2G/fDX58uxMWqDvJGB5xpGzKUH/r5FcXCjyZU80z5mqj7gmsFVeOE4w1l18APPUpF2czDGowMLQMygGTm6jdZOia3OxAiPpmjyyDGKHa0bH/uXpKquBsLAmogI6Q5yPUViVLkcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPzyQrQQGWbiSn2TY7/ukuxCl1vnihWtmhQA6AXih7k=;
 b=jIYNuogx2gvgbKQ1nywY6I8mMPj8IFmZI11l/YKvX3K8NSzDn5nlzKaoc2G0tw2w0tnJzQCoMGe6zZnY3zHLW6gk2Brjm9Adw0Ysc3W15i28lgLmsyjLnb71mSzAOwJ9wDvnJcGEoieAAgg+N1fN248lUSgJyUn4FVpxihqpMEMePFMbJrn2lXO/fmpTmtBjUBiZnEtCHU7ep2Rzi/rgwkxuR2uAV7GABZLsVPMIW656o3/52r+6hZv+/RzXeL27QyZyh3+zEgI6eSRnlm36tvDgmFQE5yjxNhJvpv2YY0psuAVuPTp4qahBBAk9nowmzK266EsZ+N6a4FilOikCdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SJ0PR12MB8137.namprd12.prod.outlook.com (2603:10b6:a03:4e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 01:41:33 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 01:41:33 +0000
Date: Mon, 27 Jul 2026 11:41:27 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, namcao@linutronix.de, 
	ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com, clg@kaod.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 5/6] lib/test_hmm: remove dead NULL checks after
 GFP_NOFAIL allocations
Message-ID: <ama3NaduNkQ16lEA@nvdebian.thelocal>
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-6-gouhao@uniontech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724022851.466017-6-gouhao@uniontech.com>
X-ClientProxiedBy: SY5PR01CA0091.ausprd01.prod.outlook.com
 (2603:10c6:10:207::8) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SJ0PR12MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: 5328bfbe-0382-459e-e43d-08deeb80307d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	kqL5wzav1S0165cdl58A1VVjJCf+0PV6kjMlWyYUn0BnXucbYBlGGZX5GQSpX2KS56DZdX59S4bhEKT4Km3IteUrXKq1FHgPqPm72+xAJTaZ8B2r0Foe+K252oLz8yx1aDRHdyoZ/eBl2xWTDBSsdvhzZJu4cjU4ue8OAupBOtY0wphBPE+mglK4Z6aYSTqLXxlu5YNdSwN7bnH+BsZYfUKB+vmZ45s5GCUvaXin/T7xB2Os0znn/phFfvLP2Ob1iW2Zc+3MCP53anGlYsnyI5TvZq6nZVCUCtuZ0p+DXJxs43KBObpcQtBxBRNPMRwmSIYh4W/8ajtjddTS6D/kIoVBeJPTHE5EdxVBqmw22oaDN0bs1V7VP4tTX47nXeTjUcaL0JlKS5Ya4d/I3PbLHbXYwb4gdLxhyUn3zEpsWuDmpU5cxLghgD4n5pTg9WESitqh2iIfZ2HuYqFnZ8z+O66MdqxMJsHmO8kA3mpBq0xsRKy0lI3HoK3JWOeyyOAubHq+fLprczWNIeybCW9Iekzee0xxgBoKz86REgVvX1JNqeCgtBpAKiWJDFRuw7XaAWRRtPScCm/pm1Eei3yfSrmxt6gYmE5L0NGcRGzr8s6mhXyvzX0raJPKZfpsR5jtYoco34sno4HfqXPyuN5jA4lmmBOPnl1q5SQRxAUGbgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VEE/fcNWvmcfAtecmA8pIuNyd2Q9VAacMa025gdZFXFBdk1PMWxANbHKDHd5?=
 =?us-ascii?Q?+eEeJQ5nsAkdvXmclLFX1Yj8fNW/GXNwRa8uQGTj969CcwZz86RDEypyRowU?=
 =?us-ascii?Q?apOIlPkj6hvPf4zhmZB+4ejg1dsPkSuwDmheTgpT6BPnLD6OD81ZuU/btiK/?=
 =?us-ascii?Q?orEYNFHvFZYjLiDKumRG47Kc61PIQqZlyUfbGI0zdBTxsTj/s5dQUteGanQ7?=
 =?us-ascii?Q?g5uIMZh0tJMqk5enaBbUQ7OqblVyG6heZyfzHc7MT/gSqC3brr7EAHaknUhW?=
 =?us-ascii?Q?LzO5q8VF7dOuksXwJOXTFt4V0+duuCEU1i8ddvTjZ62SmMBaPvnVshOOjH6R?=
 =?us-ascii?Q?GywDl9rIWfjksfm7bx4gMi6C+ypEokKOjFh3U4xxxqw2dVvwuHiwb1KhhPdo?=
 =?us-ascii?Q?GLTWd5Y9i5I1UBy+EKBebO5yQoA7SYhc055APYHs2TWpJo0BqK9HXpU4h8Wn?=
 =?us-ascii?Q?oJOY9ORP1w2wIPVrj1Cybxe/+WtYtyP1KKJVPYoAt7z1xMsx/xouSnt7c44Y?=
 =?us-ascii?Q?TC/rKqcUz1QkwQXZp0pO8x9PUSzcEz9YVDSFeWXqVP0fFsbeCyGIxMFtv/Kw?=
 =?us-ascii?Q?oPgVNFwT2MY7D3zJQFpOCsgjqfHx/OxdaSm6wnUazwZ8e+yFXHJd4paA0ljp?=
 =?us-ascii?Q?t3WfF1rQ6ALWsOduittzadZ8VMKd4sGeZGwSmAGlfbRNmXIPOb8Y0sjqGz6W?=
 =?us-ascii?Q?f7xKL85njeYhBMouwhHoUBqtcbIK1u2nC/ZdsNf2mevtn8EFdFSIMazcijZU?=
 =?us-ascii?Q?Ey01C8lg38C/vzPkJYLzaM6cmn6ylqsCjBpU9Sgw2TBZK9gkL+O/8pQPbUXe?=
 =?us-ascii?Q?qX3LD2dVIES+j1D8b5bOAsk94kuGnxC0jmuZXl1jhxw3R1TMNM8vrA9tER/h?=
 =?us-ascii?Q?U202xUBhXrNk/mDg1IGHv9TPd/9tqg0RX/5tRXQCCU3fKdLcLIwOrJkPRAnq?=
 =?us-ascii?Q?LlPSkxAN1zfEDNK/yZpq1af7L4HjyFrBByRuVsHhYe0zxcbEcxcC5hDqPqKV?=
 =?us-ascii?Q?jybeATCRnw+BVb2qORS3q0MYVY0oKzrI4wYK8z+OSzWGqecl5ynDo7kSnGd2?=
 =?us-ascii?Q?LR4wdO3LUsEaf/iwFg6QVIStzyc6jFhfbDpAc+9Sw3sm+lTX62Cfp484fvdq?=
 =?us-ascii?Q?YxpwQ/YVRaDZTwdbKcAHXJa8zp85zhMaSjogOND9tafgKT30ifWCv4sTRC5R?=
 =?us-ascii?Q?7QcKwMkDWp+9Dk99wP1Ccsn5xrrBAVdf4p9JoeEN6oLkj13QLTTRFDYgXQmI?=
 =?us-ascii?Q?XT/yH3KZTt5iROk7cFRmIxOL9jqpzlvNAzrtQDMOvupyaOZj63v+Ku77sT9v?=
 =?us-ascii?Q?Xwm92D8EfuAuoR3y1au0Fc6iAyv38urktSoggv5SHIPfD+q3Qahz7GXRfU2I?=
 =?us-ascii?Q?2dsbBnnztgWrmpikNIc/j5tL/ugonPZMB8ApEb3p8Qj5rv2GCg4q8WlxZRg3?=
 =?us-ascii?Q?kbUxE3J6ghKu0Xm4N0GOp7MnY1CMT8RzuM9T2gj4Sju+DyTvMc9byJCZemg+?=
 =?us-ascii?Q?teCCBlWiCdqp0YA+gayNOyUZmdS6XxRYHKk4kOCEkudvLXv3/+H/Yj7SaOpv?=
 =?us-ascii?Q?gJv4jqxUIeUUcKnnWQKNUx5yuq88aItKvm8gsNQhvg9bKJY/YlJVEx1auiAO?=
 =?us-ascii?Q?wbmOyCN8bBVJlTiJyup3QBg6/1/ZQrgbTbIOMpNBCexBs4z5y+wmZ3vQzByO?=
 =?us-ascii?Q?2eAHu0LH1+Edn6Yj2qXAAL8IsO6Tq6JZ/Txm0f3xqzXGWfRY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5328bfbe-0382-459e-e43d-08deeb80307d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 01:41:33.6764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PXFc8yY67cUglQnhUskVtF6vSBIUSHGLO7Fj59Ka0YyPBIks3PplCXc7zwk51SILAtzPQHQeRUWS5iL6e5hkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8137

On 2026-07-24 at 12:28 +1000, Gou Hao <gouhao@uniontech.com> wrote...
> kvcalloc with the __GFP_NOFAIL flag will never return NULL, so the
> subsequent NULL checks are unreachable dead code. Remove them.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  lib/test_hmm.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 9c59d1ceb5b57..d615e4e5fc447 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1209,16 +1209,10 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
>  	if (!mmget_not_zero(mm))
>  		return -EINVAL;
>  
> -	ret = -ENOMEM;
>  	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns),
>  			  GFP_KERNEL | __GFP_NOFAIL);
> -	if (!src_pfns)
> -		goto free_mem;
> -
>  	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns),
>  			  GFP_KERNEL | __GFP_NOFAIL);
> -	if (!dst_pfns)
> -		goto free_mem;
>  
>  	ret = 0;
>  	mmap_read_lock(mm);
> -- 
> 2.20.1
> 
> 
