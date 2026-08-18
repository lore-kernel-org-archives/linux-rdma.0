Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E472D9792;
	Tue, 18 Aug 2026 19:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787080750; cv=fail; b=TEyU2W7SQOYgNSK9e4PXQVdQ9yjqLKTyRyYgxVTC4mjSMopCJc55oc5wjgOtamAZAMhNsPmE7t56wnUt2UeIXqDGY0M+uJnG+XwyJhyFm5zJvtyG1ChNovYge4NJxAApZothjERpIhqIJ+PBzEo+mAuASC+q6rzBGPhoAxU4y6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787080750; c=relaxed/simple;
	bh=Jk8JMlRAYYcNt2powBazlCMZjwUn9R00QuRJssf22vc=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=Wgp3xpV+sHPydz4WsfQgVwe2PZd5y9KRuFc49TfgizBWMkA70sQ61ze7hLB8jdlu3K2NR0mbwmtV83NDEmw2jJT6bOIH7k5UtGv3fdTKidQttrgX+rFOmUR1+lwB713teBaAIBqTTsaEDWQ/DbuRMPzZ/wHRjP+alxQmXERxexs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t91InalK; arc=fail smtp.client-ip=40.107.201.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t91InalK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kUG2BBHftBnnkAbN5QAboz2mQmw7bnJ2Bl3D4PPxcfcvda8REg6KHc92TRKfg7t9Z8B2OhpBYl3xDmKhq4dQKRqtt75BoYAtMjQlRbaVjYFvMtnKeY0OvsM+aBpUpZz4LXcC2YQCwyC9j9qEXG+n/O3bskVb/Izd/b3ABQhes38KtYdR7PJIi9rGR2jsV4/Dsv+QZjFMArQs8G8CMDDppwnhzlPXgoMZHcHaxLn2MTG5zIX+sQVeofSgEvrqB3ZpcRLRnwwkKXZXlsC0iPd9ghCUPqfmjtV+oGfVAR1ejeBLCy5YSDb6zKkk6SfwgsQU/NP529rhPub+8Sv/83cAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cW+Ros3Lj6qsXYNkBwNJK4xfqwXkB3Ugb7fK3ZfzlcE=;
 b=Nzf0Ysxgl0lNtiLii4xGPe5lXK/QGwtAG11IeueeQX7KJHG96zIE00tXEuLC6mlCTOtJtOM8GmAsXlYOtpI8r15MkIHkDNQpdmN7VnHpdDL84yVLm+NmAfFxPG3CHVVQwCfyGHBKoFxljByXU96OnpIPYidWbZF31YZEhKL3ErMJovt+mkgoYzlYfCtCNs6n2DJqYm6Yi9mFdNUrgDdYjr9EZ7hv/GNGsEMLTGf8FYOcgwy5WaxWipCn/0jGNEL582yrohgcb1rkmSmq7jB7n/b0lyZzd+6a/ZwTA4zvb0RBt0waWKaxYzwZt/bhZ6phMTS3RLux+7zyHiE21snL9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cW+Ros3Lj6qsXYNkBwNJK4xfqwXkB3Ugb7fK3ZfzlcE=;
 b=t91InalKkwZz2r125bNW6q8qzNSvk/7NXkdgPjN8p+/4DuIHLfeESx6yoNuMhGbwEbtWX4zHCEOI5GZ6O4IAPuggKeCelAXYIbd04+kg+jPZ0Lvo8F0jr0IOscesIJpbctZsEvrbeEOjbeyVmz3Sb7a0XjjGpjStiPawy0fjeahohE0IjanFF5gKDdeKqtXMJE0NwBkWzIVacuSS4TCkNADb/9rJX31es57HEAUNSyh61AB40R+64Ra6JOoVFL3XNWsdTHQBVAPVwz67tfIn9LYxoBnyhfMhXAJrUnZ0J98nhb6WAgolnV1Z4jpJR9CNaRp+HpuXSvqI7Kx63byl8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPF6B6BCC42C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::612) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 19:19:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 19:19:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 15:19:01 -0400
Message-Id: <DKSB92XOCV9N.2FQPF6H5EEB7J@nvidia.com>
To: "Qi Xi" <xiqi2@huawei.com>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Cc: <longli@microsoft.com>, <kotaranov@microsoft.com>,
 <jan.kiszka@siemens.com>, <kbingham@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
 <linux-hyperv@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
 <wangkefeng.wang@huawei.com>
X-Mailer: aerc 0.21.0
References: <20260818122408.4182417-1-xiqi2@huawei.com>
In-Reply-To: <20260818122408.4182417-1-xiqi2@huawei.com>
X-ClientProxiedBy: BL1PR13CA0383.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPF6B6BCC42C:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a83bf66-aff5-4516-1f5b-08defd5d9002
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	OtU1/XhEoZiOgOrq3n/beh7QOOw5MhHsHYgBQJ1whPSM5gUOd14DcTU1eFH1agHTTBi5lPo5m5nZUZ83s/QISmFE4zrkMuUQ5m54kWpBV0pT+tfpAe84xKWXQBPCFP7c1Lj0jwb5pVD7meIb80qSjriUXL4e9blrzERtSRX9sL2AOQIrrwNoSMo/NH0HGcx+1CTYsZ5obyx2t5aSTi3MVrPRXdfpY01wnEL1gqBDnPjsmsSDyTLtCFBQxxEMnW8ZY1QhlcQgO6tPZ/XG7IvzBAEQ+ZWCbiSaMcWFM+8p7tPuDeKAZXnIeup39yqnGnOYiAz3+vVo9nwfj/B11KZd9/CXAk8GEwTn+X26ERfPGrV2TIlXVRLGxr58xHzdT3H0NK+7ZLdfGRJfFmW4HB9BMJVg3WEaT+D7ASj7Uyl0sWcZtFRhk+f1ylBzvg2eyZRD1L3XtcCrZCrIXQKj/g1PWyO+bhpXZQD/nz7QCuM8oRDT5BGIXOEEoZiPsZUHF3/u5lGsv5uko4W87DgNOQZQ5LqL7wFzIUCKZ6ph1aEbaTj+eYQJUouBkcq5zfNW+FbYRY5DN/wbgF69rnyM8byrOH5ySwEiypBKALpTKunUHzFaZYKV79B9bG3mTVlOaGTN2gGgJTUcdMAusoKy0zJw7n+SfI3jky2ZvZQ7jsU7BJQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDZ3UWlqWUJBQ0todHN6cWkwOUJid2QxZ0ZtRXVuYmszbVN3YTBaOUtrSkRD?=
 =?utf-8?B?Q0RYZEFRb1RzWDhBVjgxS1RTM1EreDkvdEhDK1RrbktVZmNNejE2c1E1NFZN?=
 =?utf-8?B?WEhiOG8ySTZ3My91UGZJOFVhN3hFcUVxd1pGK2VKVnljdUlPYzNOd003c0VO?=
 =?utf-8?B?cUJ4N2VRd1hNZERkVW50UmFDZHdLSTlEdDVxTXp3WkR5MUpqMVdsT1Fpc1NY?=
 =?utf-8?B?Zk1uVndHVHE2ZFNhSkpLRU56SjBoOEFwQkZZMDBhZU83ZjhkenROU1FzeERi?=
 =?utf-8?B?Y2VQei9mNlQ1NDBFZk4yTDVMQUVYUHJpa2Y3djVGVW1RcklEL2xwMlNzZzdS?=
 =?utf-8?B?Rm5MaXlNM3VDcFhBVE12QXMxRnFvUUtMSU5BcUJDWUt2NGpocDJBTDE1RVgz?=
 =?utf-8?B?c1JkTFpLZ3pEWVJLQjZCb3dRRDZQcWhhSjFENmhBNjZHVHlVK3gydTUxUlhW?=
 =?utf-8?B?WjBabFlxUFNLc3lEWVo4UmxHTy9sVmJpWU5SMWlLOWlqQjdVT2J3TWRsM21q?=
 =?utf-8?B?alJibkpZdjFqMzJob0wxcnF5NHRaelc3YmR6dGRIZC9GcDdOYlJZRGE3Vmxr?=
 =?utf-8?B?M25DVlVjNnhrd1IvWFhnNVNkbGF0ZEZ3OExPSGNEUkhtSExlUlFHazRVemRx?=
 =?utf-8?B?dWNrMFlQemh6eTQ2NnB1eURIRlgxczJpRUVVRzdJTjE3WE5RWmxreXJtbzdQ?=
 =?utf-8?B?dWd3QmJmcGRIT0xKQ3pLVmltTkN3Sm1jLzBnTkZKUnQwOGdZOUNKZ1JsYkFE?=
 =?utf-8?B?OThnK0tRZlZSMlU5SGdlUUhFakR3OFBrTEIzQ0tqSkNuZ2Q2Q1Zoc3Ixb2xw?=
 =?utf-8?B?dnFiYk5qK01naFpvWU03M2xuN29EYjhDQjZ3cElPUk93NFBnVjhaSU9GcXhm?=
 =?utf-8?B?SGlwNXdWUmJpZWQrU3l6RFpjL25qSW1DNU9Vd1dDZHJ3YjhoTmQra0krMjlv?=
 =?utf-8?B?dzVybEhEaU5DVFhWQmtHM21rdXZOOU1sb2l4ait1NnhCaW1JaHFaU1pkK2Y5?=
 =?utf-8?B?T0RNL3hmOEh2MkorKzIvTWN6dGFrRVVhQmh0NFRVNVNLUmpiQlVFcldmMmxO?=
 =?utf-8?B?WHlqa1pzZEN5TG1lY1htZm91c3ZiMVNuOW85K0xNTmpmb3g0a3hIY3cyTkdI?=
 =?utf-8?B?aGUwd0xzMTk1MXRpMzhidlhKMjRZZWZNM01vbmsxOEVpNXFnd2VqR2k3UHdX?=
 =?utf-8?B?bVFPemtQRHZoaGFRR0lleGFkcWRiVmFYV2JqQXZ5a2pBdmhlRG9oV2lnNktU?=
 =?utf-8?B?SGw2VXFYZGVUTEJoVUxRNHczenpKV3pKNUJhOW5qVXAwUk96cGo2UFFpOHFS?=
 =?utf-8?B?eldQUmZiOUJuZkdNN09BU0NFbEtPcEpIVTc4RkZlSUtFRVZTQTdIdHVqWnVq?=
 =?utf-8?B?dUNTK01IU1BVcjNzUC9wV3FBcDEyREpIUkJzMkttcDRiQkV0VnMxQ0hheHNm?=
 =?utf-8?B?NXlWa1R4ZDlDVGV4Sk15cG0xa25GVEZFU00vdjB5eVhSTWVuTnU0eHI3YVpw?=
 =?utf-8?B?WVRlZEhqa1FpZTQ2ZnNld3ZuSVV1LzBVZlhmZGVGaTA0dFdBN2pHNkxlRVE5?=
 =?utf-8?B?ajUycFRwbGpOZ2h5Q09DZytQVmlvZ1NuYUVvOG5uby9CWFpNWVpFbTR2N1JF?=
 =?utf-8?B?M1VyNFJLVmZGK1RpenJ1d29MSHVuM2tmV2hGRFVCaStDWWdRSS9DUEFQMVZ4?=
 =?utf-8?B?NHJrZGxmU3poUHl5NzdBVHhDeGxRR0tWa3dmZzR0enkvdkNTcUNlYTdCVDVz?=
 =?utf-8?B?R0xjczR1bUMxSDZ4NGd5U0U5VXkrZHIzZTZQR25hT0FFbmc5KzdXeWZpL2Zv?=
 =?utf-8?B?M0J0YklhUEIxVnVxNXlwQnRFVTlTZUUvVlFpU2Exc0xtU1dtZHFLNTFtZlNq?=
 =?utf-8?B?NDkwTnJjM0tjeEJNM1MydWpXd1pIOFplcXMzMlZ1VFpxNG9wSmlaODkrbDhq?=
 =?utf-8?B?UUNrSUN2ZE1IckZkL2VYbnlDa21CcVBGUDRCb0NlVWZNUEdRVTF3MUVMdllw?=
 =?utf-8?B?SC9KSnJTa21NaWVVVUovYjJLaW1adWoyOXczSFVISmJncEVBVWFHYXA1bmRT?=
 =?utf-8?B?V1RnWkMwWGVRQnhwU0U1MDVuaVJNNVRVWjRjMEFhcnllUU9PeXRheHJSZDlF?=
 =?utf-8?B?NXk2cXNsWUUzeHpPQVBjQXdUa3Jkc3lub0xHbnl6eUFCdnY0RFEyVzhYSlY4?=
 =?utf-8?B?L3o3Z0ZtWjdacVZ6ckdFSnRhUy9qdE5aQWVzendTcGl3SWhQN1pBNEdQcHNC?=
 =?utf-8?B?WE1aSGFxd0dTQnVyL3NHYWtzZkQvdll4Yjc4WkNyUXJRSDJyQ3U5THRFckI1?=
 =?utf-8?Q?/TWs9C+9GFgrTpguBY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a83bf66-aff5-4516-1f5b-08defd5d9002
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 19:19:02.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YB4tXrWiEOWSi8iX9l0aMSHYdZw5ujvqTSL5lPC3WakmXEM45LvXiDhK/KfPOhua
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF6B6BCC42C

On Tue Aug 18, 2026 at 8:24 AM EDT, Qi Xi wrote:
> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
> name:
>
>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
>     a local mirror of the kernel's MAX_ORDER define.
>
> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
> consistent.
>
> No functional changes.
>
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  include/net/mana/mana.h | 4 ++--
>  mm/page_alloc.c         | 2 +-
>  scripts/gdb/linux/mm.py | 8 ++++----
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 04acb6791dbd..1d5bed71d6a7 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -40,8 +40,8 @@ enum TRI_STATE {
>  #define COMP_ENTRY_SIZE 64
> =20
>  /* This Max value for RX buffers is derived from __alloc_page()'s max pa=
ge
> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX =
buffer
> - * size beyond this value gets rejected by __alloc_page() call.
> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages=
. RX

It should be 2^MAX_PAGE_ORDER here, since MAX_PAGE_ORDER is inclusive
now.

> + * buffer size beyond this value gets rejected by __alloc_page() call.
>   */
>  #define MAX_RX_BUFFERS_PER_QUEUE 8192
>  #define DEF_RX_BUFFERS_PER_QUEUE 1024
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..42b5b41432c5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7803,7 +7803,7 @@ static bool cond_accept_memory(struct zone *zone, u=
nsigned int order,
>  	/*
>  	 * Watermarks have not been initialized yet.
>  	 *
> -	 * Accepting one MAX_ORDER page to ensure progress.
> +	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
>  	 */
>  	if (!wmark)
>  		return try_to_accept_memory_one(zone);
> diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
> index dffadccbb01d..28d33624c38b 100644
> --- a/scripts/gdb/linux/mm.py
> +++ b/scripts/gdb/linux/mm.py
> @@ -56,7 +56,7 @@ class x86_page_ops():
> =20
>          self.MAX_PHYSMEM_BITS =3D 46
>          self.SECTION_SIZE_BITS =3D 27
> -        self.MAX_ORDER =3D 10
> +        self.MAX_PAGE_ORDER =3D 10
> =20
>          self.SECTIONS_SHIFT =3D self.MAX_PHYSMEM_BITS - self.SECTION_SIZ=
E_BITS
>          self.NR_MEM_SECTIONS =3D 1 << self.SECTIONS_SHIFT
> @@ -233,11 +233,11 @@ class aarch64_page_ops():
>          self.SECTIONS_SHIFT =3D self.MAX_PHYSMEM_BITS - self.SECTION_SIZ=
E_BITS
> =20
>          if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
> -            self.MAX_ORDER =3D constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
> +            self.MAX_PAGE_ORDER =3D constants.LX_CONFIG_ARCH_FORCE_MAX_O=
RDER
>          else:
> -            self.MAX_ORDER =3D 10
> +            self.MAX_PAGE_ORDER =3D 10
> =20
> -        self.MAX_ORDER_NR_PAGES =3D 1 << (self.MAX_ORDER)
> +        self.MAX_ORDER_NR_PAGES =3D 1 << (self.MAX_PAGE_ORDER)
>          self.PFN_SECTION_SHIFT =3D self.SECTION_SIZE_BITS - self.PAGE_SH=
IFT
>          self.NR_MEM_SECTIONS =3D 1 << self.SECTIONS_SHIFT
>          self.PAGES_PER_SECTION =3D 1 << self.PFN_SECTION_SHIFT

The rest looks good to me.

With the comment in mana.h fixed, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

