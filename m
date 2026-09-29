Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3B3C1970;
	Tue, 29 Sep 2026 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790722786; cv=fail; b=c+RlunQz97Uj8FagP7j9ksBGEblamrbm2itNoXT1BY8uIPVB2Xo2dyZpSn6jOTHONuRdu+YiT/bBUFQdjOzTs7JCgtyLDigl2t2Il6QoQ2uo4JeAj+h3g9a+r/N/0YoA2r5GsmU5+l7Squf/McWQZTAwtG9vY0mQROTZC8/x4eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790722786; c=relaxed/simple;
	bh=gC7TPx1JPDEvAbT+Igd4odAN7ym0kezc3Ru15iyd6Bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=USH4rCWjanISFjb4Bcui8ZXLPxbZlibPJXfAK+yp+UO2teA4Kdi4t2dvVLi5D91JRu9kXIsW3P4eNg5ZRhOl4iqsCEt+MtSRUmvIsRmQeejhC1JgdY5B4V0y6IHPSscXYtLYufePSK05pCTd2r3XI5iiXLzoGbd1PW0CAMoDGAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ivnuhx6V; arc=fail smtp.client-ip=52.101.43.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ivnuhx6V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X9rWqFluCm/LU4RdpVwXdUfgTKqxyqMyZLDtB0z8uMSoAJtAb0YoNVNThNzyD7Z1B1Fcvc6UMwHPYWke4cSO89lQ1S+5l2z53ub2qiUf86WrCXvUciOekD2oyYe5UUfxFlv4mPoutMYGg1lLdFM34+5DR6RLvElnBNfxEDOf0+hqWZS6vzaMSCq4EWBELogwBnps3WwbWWJCN0NYnCn9jE1H3g7zNJ0ZCoknf9+QfjnY9Dwcfot+wiVuMKiX5mKvpbuhJoFzofYKARZDQSHBzbNY0nZpw8AeB6jrCwwXzj1Jc3Mj+2H4nK3N/pQzRQVhut9+y3kchdRJ4Av9NTNsJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGc/7+OQcpL0hKqmlG4M6uTJqn1/NGzL5no4NTfH/XQ=;
 b=GNcAiNIltfAtUj7MnCHnZ+DuRgPxPKOPWcW5Uld8lHgGfT3h2rP3gUI5nQrtxOeQw4WpmCoKLyN+6NUjANkLtyvnk3TJaR/PzA3qrHxwqU5ZT4GUlgP5tkypIXj2nGKA0mhXWIdjXhF95OuMhkm+y1aG52173TTcE1V4hhhf76HBBTRyyFGRMw2ssM6zyKW+RzvhOaCxauNDSt+Z5VIwe3ALWh7cr0rNDGStVRgZota98bD/HCMuaDOe/zYx9/uPxNZ3FfZ3FEUJ+CIP1LXRIOm8GdKF1antNm4zYMidAxbafuNRBapATJaI7Kwy8mW3U2RJih231YS6WB+1PFXaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGc/7+OQcpL0hKqmlG4M6uTJqn1/NGzL5no4NTfH/XQ=;
 b=Ivnuhx6VLkkSyIaZXaNZ2e0Jp65OswVS1yWaeyq4iTeCxF0HS6CvVB0cHTkZHFlt06g92BkoQxOSKxJvz4ccOD6WxJlYD6+KTC30gSdzBkaIP+9d5wUpxxk/Bjp+Z12qKddbBEC6W7oLadYMVxA75KAnVLuvHItwEtuFUgAqeVY5aomFvYePE90uoyu+Gfd79D/Rfla9UWOBERqAt7F0M51LsbR8ianm16ML0Rokg8QNjDiM5+cCpOGJnh0EbRzJfVT32a5uK+cQzymT90Te9FznNezw5ZegEiHovVxQPPta1WgEvTDakbEhwErdzEa1dcO7z6AJEB6L8eM4FfC+Gg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB8034.namprd12.prod.outlook.com
 (2603:10b6:a03:4cb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 22:59:39 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.024; Tue, 29 Sep 2026
 22:59:39 +0000
Date: Tue, 29 Sep 2026 19:59:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Quanye Yang <quanyeyang@proton.me>
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Leon Romanovsky <leon@kernel.org>,
	Danil Kipnis <danil.kipnis@cloud.ionos.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH] RDMA/rtrs-clt: Validate peer-supplied IO completion
 msg_id
Message-ID: <20260929225937.GA2446731@nvidia.com>
References: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
X-ClientProxiedBy: SJ0PR05CA0146.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::31) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: 694c277e-091b-49d5-3659-08df1e7d5744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|3023799007|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	T471O9RE6P2L7CbmqVINUgQEgOoBkGPYCqjwtKysqmLyoteERanHJnE8PZDYz9o1mGMfnmWNAYvToOcUU418gRkmbmSDh4+eTYnbN7Qxa2XnmimzTeUGxP17X0O7rccZh5N0i3+dUHhQv6ZU/Y26iOGcdMHA9K9OWXdT+UYwr2MILDdTiTM/+oacjwKQBXOjakdtu11+pmY8cEkbXAZnhRsbfng+lhsbPXpZOGxT4aSFecbw1UAwa10YU/WI67HqG/gp9XhRN4hhf3eCGuCvdbFcKkURG38uqHZZKCAwvXJPppuqMcgvvECXO1uCk2j8i0bKcpuDOSnLxnKO2nLfh56WMJhBwlfXnF4DbXXrGVcKgIL+VENdUmx+HTa11CprE2QFC1GFkLC9G4y7lVB4rccF8IrUDUeH5cajoGDN5bKjxFasjnAb7yY8XuQCYFzIHlBe4uAqu1qOBJPcr1gBWpg1CLdD1gAOQJdmgTSfL47tmF4X79qqgy4zJwrgfMrP2Ay5OMRXNcIbhtVK6vpzRJwlKKgFjogGX2eJ8XPp+y0tlCnseNk+/sKojY7BXMmPc+4O+RTiWSCwdj9Rt2yYs5VOT5BO8DXDjp06A7/0p1nv0OhCmK1VRN1nH1ShIZwrVGxt7HIHmUF8+rpC8TKmg2WvW60WPTLtQMtB2Rv+aqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M1mSGRcHzxiQSijnXxhoMHVbIjNID8SY1EkqybnRrBKqD5FJj+90XgXqlu7x?=
 =?us-ascii?Q?AB0/cSzhObwV8jSiI7b+BrU2WR/ZZNWnm1NyKb17ox1euDFhYOUHBl/eaAjw?=
 =?us-ascii?Q?Sbsl03IqoqjLvY7kKs5MUTU0RlX45P1y6wrYjimJsAQPsBgiyTjJZd2cXoAc?=
 =?us-ascii?Q?SbqKJ1neZNVfXQ9uomwZclZ6zBVXAW18Hd/3/IjJXc4Shnms53o+kzLirVui?=
 =?us-ascii?Q?VAdYtWfL8NhdQl7p7KR99/SiNqCWkUKPTN0FV4sjY1lIEviWSM7npn2pHCaG?=
 =?us-ascii?Q?bH+WGHlQbTFmTDu9a1E0Usj8FY2/ru0rLsIozxG9116K9NEZBNDU/QLaGS1y?=
 =?us-ascii?Q?W31E/IZSic4qhMn2y2c7Uv1KOsgtvAlYqICYwWZHE9no91F5eTV5diVXDOiS?=
 =?us-ascii?Q?VNgqySl9NLuHdismEl7ueQnt0CRx0Z5SVeJW6YMUrueFpQVhUg34qGFnlBpF?=
 =?us-ascii?Q?w5Kb+4Kp7+7SxouTELTbpxNwgQ/pJcMNvly1VRxx5DmyJfkVR+1neLO98xJj?=
 =?us-ascii?Q?cSUmhYj7oUaSXWJ7NncTkmS62YVISepS32F5lFXZ6PRMS2yfKFy9CBy8G5dd?=
 =?us-ascii?Q?iVig/oWyVTvfkaelT9B4n81aZp0dBd8/uaCE547Wlvk/EeXS70nvFQjaa82d?=
 =?us-ascii?Q?NCxOaU/6nYvoWUtgu6St+IO/w2nB8JlAQerwEeD3pSTQvXPKP0q2sit2Vv3E?=
 =?us-ascii?Q?4Ph/84YTrhRfUKHrgPtG5jpAQ9179qGGIkXRkhEZ7b/xmYdXjV8z2G39SzBo?=
 =?us-ascii?Q?lOm66z6+l0fDa3/Q/X3wXUmsJtK1A/D2HX83Kg4/lA7s9M5s0mQ+BNsE825z?=
 =?us-ascii?Q?wmKZN+IuSp8U85BQCBfTfRU2YiDEZQlNCdmW+NaSgUwW0Tv8HiMUh9PuEQRL?=
 =?us-ascii?Q?oDcHrMfw+oisaxPrr/JemJbEykkg/aFnpo2LJNRFExLKADd8WvV4R/ab8qTw?=
 =?us-ascii?Q?QrUSb+q/46ygJSDytmz06sUIR72KZ18XFdvhuWBtSWulHmKLfWVRb2jfPv9E?=
 =?us-ascii?Q?k7yp3ZDQoYqrrOyll6+Y8LBN+sNBtjs9qY+Pz0uako0Cg0d0UUGhLw92GO8U?=
 =?us-ascii?Q?1KAbh1dbTKBFqN/1mWWcHwldqmT+gARkdl6/PHsjszSJJCG0WNl1exeHApAS?=
 =?us-ascii?Q?BESQsz2UarhqmQiEfggunbC9g+5Rg91+xq2Y0JjRzU2CEcUt8dv1ALL1k657?=
 =?us-ascii?Q?XiQJMZVBtPlZkNcl0f6MGJ/Apo8cfkn06l2RfRgR4HFt/XCYFTSgjhYyjFmY?=
 =?us-ascii?Q?f+7kt4JiueijFgDh5tXeQTok8jKgEqkx7B8xnbzrLer6NzQV6tNOqafCGDcR?=
 =?us-ascii?Q?Hrr6r9R+a5t3tW50ZFDLL1pZWtNDLN3Zh/t4MkV0rec1rj3DypLWgEXrNDGV?=
 =?us-ascii?Q?Vg8SVlpdjGi11qaHRNN7lo925KG2BRRT+j0hAhykB483dksCzrApY1KKQfJI?=
 =?us-ascii?Q?rTxwlo9oLk7UTRgQKD7nAXNwNnHU5tonp/hb1Eakz1L3uCM4PjDyQ7ZPRb7Y?=
 =?us-ascii?Q?cnkuq7N3Ac4NKCvipXLQ8g0yiSVIWNArpdtfbmt/BcaT3PhK7+EShRD9VDuJ?=
 =?us-ascii?Q?w2OuOeNHDsYu4EY5iE5zHdRhQHx9pRG7ct6AUr8WUFhPCtbWn9Q8kohqFaID?=
 =?us-ascii?Q?wRC9KFq8kaUdep+dkVdCVlA4otQHLkOC7DpO/gvEBiSsSAaf3hontxOf73pf?=
 =?us-ascii?Q?2IOPpfBdu/oDzHx2NLSrCLH3/326LgmfVmQ9wTgg2Nng7gV3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694c277e-091b-49d5-3659-08df1e7d5744
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 22:59:39.5230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8A26yTGA6yb2NuBsdSuJ0ck0b/9QkHjDp3lgJAFRwN61OBy+NfsaP+8bp5Oq6jl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

On Wed, Sep 23, 2026 at 03:52:11AM -0700, Quanye Yang wrote:
> From: Quanye Yang <quanyeyang@proton.me>
> 
> process_io_rsp() indexes clt_path->reqs[] with the 19-bit msg_id
> taken from a WRITE_WITH_IMM immediate. That value is chosen by the
> peer. The only check was WARN_ON(msg_id >= queue_depth), which still
> lets a completion run after free_path_reqs() has set reqs to NULL,
> or against a slot whose FRWR is already gone. Either path
> dereferences req->mr and can GPF; KASAN reports a null-ptr-deref at
> offsetof(struct rtrs_clt_io_req, mr).
> 
> Treat a missing reqs array, an out-of-range msg_id, or a req
> without an MR as a protocol error and recover the connection.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/r/CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-WratpUE6jczHw@mail.gmail.com
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>
> Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)

Applied to for-next, thanks

Jason
