Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010043.outbound.protection.outlook.com [52.101.193.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2C3876A0
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620052; cv=fail; b=pah8AOWeYCl+3J2+4snEBNdDCtKT5fV9hdbETV+lvDTxE0tkPqWgIt+XktKHn8riNzNeM+Kywvh1LY4y7usIl48dFgKIKcE8VvTc+1taU4zb4CTDs4TL4a3SSUnPnQmcjLg2njXNwyAiidB4vWAJDZx0H1m3xwIqgUzFJCclEjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620052; c=relaxed/simple;
	bh=arAnNSne8mxnKxkvNl5KxSEtJdGyLY9aYU5EuIMguzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i5NQJD5s765uJEC+z7iiwsKFemMcJSzzU1XKpxrfUzniVROx3VY2yZ1+5lr8fbuI/GLixFRIPgiBt8a7oamLATwxUZMAk5/oKqIZtvgAL7xNYs1kOW4X9f0GuCTJt2lUHIsJd0Yl3lWVr1W7s0QDHnXXRfTRdEZv6TIfi0Kglrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VxE6nqo8; arc=fail smtp.client-ip=52.101.193.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VxE6nqo8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6y1EXpPIYK4XqRcay+rgu5bd0cObxSrNPpYwJE6zQYVA7b2OtZZTw8or0o5TlLaL7l9zQmMLLMkhu62lhCVKsnX7vRmmM86rbIukn4HqO0a36tHHiAKJuWW4+WfE6knDn6pjia022s+8388cwpzkcbJnkQJ3wMbiE2v+R7wpNgM+AB5BZYhC7CfjUefl+s0e4Fo8B3QxI1HUIyL1MFCzwZ/eVerCGOtIVaqPrXvGShSrvfmEfoAKXe/0O9iT0wl3goFM1aO3vX/0r/dU+koNwZ19FGQqdCk0KtG61V1afQUkukOJMGlJ2TjNGWaEIdUUzTVqYQx/2V72THpkf1rCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=076DXNcxsbyHTT7SXh+dHu5khrk/98MLlFz2VMiBcX4=;
 b=KxLsWNMri87y9UpKD5/9xiEkOfor9LepOfL8isC720QQAiZt+I7wVucr1/6f5dv7NsjuKL0kFD7J4cnq9kQlirQLfVhB+hqJ2aH36U4L8tt526iHjiErAwBcgbRlUo7en6OOCU+DqFCTUjTaRndPRyPdV1vsBdQeyIV/rWdhdTUFbbiLRK+KGaHdqodzj/zXJvTNuiZXPrfF+MZg1RMMKmKXOnwtqjdnsdjiKFAk7fZJQAZjqcbiSoPHTKZ4a5cJJmOTxd/2SFI1a22Jv1ZiGxJ71HTEsi5b1piYqwLiIuzMEvay3yuN7fIkHuofUDUzr9keI70AkdvQrTrlUg5R6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=076DXNcxsbyHTT7SXh+dHu5khrk/98MLlFz2VMiBcX4=;
 b=VxE6nqo8HVHaSMvxyhtmoCze1rs6FbEt6HYKALbjHgaeVJySAABzy7DSgbXNCkXecWBSIt6saWKjFKnny00AUKmxtzOSeRZBaqgA9Sodx1tQCCZA6LzKemOuAsgSEDO92HD4MIvuxU0sQAOeioxf0yjN0bCsnnGogI5b/O6F1d/UOvd98kLnLuo41bInGRrd3WZTapCtZxINOQ9QerOCjcrMjstw8U1i7l7xXOQQKA6BChklCUaldc4lwNHtmGYRwAzB8R87Y2yq+K2N1wQhPKoRFYKOWBGAoLA27R7LFxDfdozUIHVg39FKsgqS7re9NH3jCpSKMq7e+vfh4Rd26w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB6696.namprd12.prod.outlook.com
 (2603:10b6:510:1b3::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 28 Sep
 2026 18:27:23 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 18:27:23 +0000
Date: Mon, 28 Sep 2026 15:27:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Margolin <mrgolin@amazon.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>
Subject: Re: [PATCH for-next] RDMA/efa: Use __GFP_RETRY_MAYFAIL for ring
 allocations
Message-ID: <20260928182721.GA1783910@nvidia.com>
References: <20260917105101.9365-1-mrgolin@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917105101.9365-1-mrgolin@amazon.com>
X-ClientProxiedBy: SJ0PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::27) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: e6724f6a-7e44-4f0a-7dc9-08df1d8e238f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6rfCXMl11gDSJkW8ztQexCCO+4GV3mZ5A6C2n9alaDJgnVszSShGeT3R7qu2GXghYFskTgjZOt6/+xfXrmiPOX7PBPEgJ+Jh8xFQFngIZ9oc72o2TwIgricWAlsObu46gmhmaicNbOUPblGIqx0msa3+Z9VkaPvVdYY+t4yk5E6wbpmuySZiCU75IcuvBByYxBGex9hwxwQSCbuFgWCez6gnZVNjX36ga7dtUWv1OJVgAAUz3Z7lG0usfbWrZEf3QcGA1iDsLM82FZ53buN2rYGFi7g7Wh3eSDTSVJ5AZQ7CsdIRzcJbZJMtvxxRpEsNERc3wXsIDa7+OfyV6jPs4jSob2XhosDqHko9ihi4OSJvsXnLTssBe7thFBvOw30IM0Ki/VIZrpv7TKg2Y2xatuTNAttW+Uud1MB+BGu5KYLYEHdAu0FNXCPaA6nrrwgm8bIxNWyC5MTWwsyPzI9Av9tuLKuwj/vJyYOIlo7a4NTlC/00KMU723fDcA4pMFPw042X9S1BF9Lp+LtWmO26PylxMAPD0PaPeS/0ZF0DrM6Es1wQfKdlHM6ReGgHFaHShlGVRLnKnpfYhH30xVK9Xx54LIjj6z5vPF2s2+U0MbMNzvb4CprX5Ukv0wld8nmZWFm6BSn7MiKY9PV3aLHioyFOSiF4tJQnMpE1x/hbkLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TrfnU8Crau0eFziu3qPoeXcBOga/WmApLsTeBahMl//6V/4sxC5xrBh8ZwJ8?=
 =?us-ascii?Q?gINzzVSTSzDIiVfcufh7aNZSo0N94XVlzzph89uVxDMfW7UTkKFCejFouFhK?=
 =?us-ascii?Q?uxoV9A5Z1thedxw9lHjKIUiPwmF8rcgUkc26nH4pfaAPz7aQpzzy6lNe5zaG?=
 =?us-ascii?Q?DWZ8X1ahwk/zAkYK644BY00fTyr0tVoAWN8EcIdN8hA0JWooIdAwX/jFpFld?=
 =?us-ascii?Q?et25avf1bj581ULBsb+Qvrl6StqcEwlGPanrlrIbR2tjE1pRq8B+Ms+QbgqL?=
 =?us-ascii?Q?cRc4awrnolG7wOl6tfXOLEH5iu2KggYzhqebAz7FCcod1PKM8sNbbkI+w0dd?=
 =?us-ascii?Q?QiHl58uhKA/8mfTg44UpgS1rQle8K9Rq7PqF/lmpLiVETtjv/1WsQbq+epSW?=
 =?us-ascii?Q?Ob2bsYPX0YZkz5kNGN20wO/xrOb4SbDazLMXok//u1r/aZwiEIyNTQoXzggz?=
 =?us-ascii?Q?vuHsRuJDPCJvZqLX+cHqwelnEYY7s9y0xPwLK58N0dZ8ZT+x5keZ+qJND3yP?=
 =?us-ascii?Q?yaXPG++VfR1UYGk8vJDx8j8zKTXGELwcHpseisKYtpmPyBgg7JK72f39V5JX?=
 =?us-ascii?Q?M/JEjgidiqCT6ZtsgdR0ZrFLSqtJNBLdhrPBW11+HeQgfL9rizpRInYhADgY?=
 =?us-ascii?Q?M6SpqdeE0hRyO6uIBF3MC4TLWpYOxe4lJqUNcowEYu1tDZpZPilkBb9OhHIg?=
 =?us-ascii?Q?qgfxfj3jD6x3HSrycIX9FlQ3wx/DcwJRFdcTbp4/xO6KSUfSDhoipbuinjuN?=
 =?us-ascii?Q?lfCCXuMMcftu8HRNWtsx8j4PrRlX7Ot8EbKS1wvyddFCng8iYeWNgOezs+k5?=
 =?us-ascii?Q?yaVYi7M/mL7AIEDGUQPbQogFX4cMXzz0a/7VY4xDdBZpfkbnKtcOJ2QeDq9d?=
 =?us-ascii?Q?9sHlp+rAoyWDvlqnMJeUGXEu2uxp3LAAsXD30hYYllA8dwkd6ho89zT0nlwn?=
 =?us-ascii?Q?5YiF5FOte9swmmwDCLV/gSuw0KVtK4anLiFEveKzRGJYd9uVW126HZnURSAq?=
 =?us-ascii?Q?7Jw3vHLMBLYOLxKJiAGu7N0LUwbrdVo1sCIdD/seTc03piwoTPVaILC0ZV4K?=
 =?us-ascii?Q?2S3++ssIA+wo/66hMl1SohWhwr9cKoyT36k4iLL7eprr2cN2n40WG+CJHJw4?=
 =?us-ascii?Q?ig4gKdNldwdKXKnJhRurjpo89gDQ9qX8Z3ZgdwLWsbSBbPNnKdvZ3H6gqqLe?=
 =?us-ascii?Q?aVFQl0hCRRDxJ0UxQ0P4F0Q/Cn+AAmXUI5LXWnnwemO0es8qYYMS+RyvDhn0?=
 =?us-ascii?Q?H5fEBBUoEBE96b5up4kuFEni/ysutNHVenZEysextWx83YOAF1iR59VqCvp4?=
 =?us-ascii?Q?V2y9m/BDWa/9rHV8OiqDD6GX/SQPcDeurqopmNoXcdf30MFc/CUouYkNKGdq?=
 =?us-ascii?Q?vTupry80BLdEBI+AAjuSdEvPMfItJ+Ah3mptyJkzpE33wYexrBaJz+cusAxr?=
 =?us-ascii?Q?rpnMwVXG7oeUyQHyEFBspKl0NE59HEjOip96/EZqzsJNj+5Kw4APl0S5CasM?=
 =?us-ascii?Q?AtXdfHArcZ/LRvTtdUrmxZyx+vYshmcszwUJ9tTOYEt8b4rUNb8rz3xjnGIm?=
 =?us-ascii?Q?h7Ai3/BpW0nGOM64C2x0OLVhhHlbajrpRVqRXN7NyMJCrji5FAR5T/t3TBss?=
 =?us-ascii?Q?lguWM59b7X5gKQZxUotIIdIuN1RnAIdP/bDDcMRmy21T3KsdgPOIUI/gv7fV?=
 =?us-ascii?Q?Uho6B2oSMkho3YFOmfZsJ2zS7NtZmwKUgEdglMvZFTuRCofZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6724f6a-7e44-4f0a-7dc9-08df1d8e238f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 18:27:22.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7hGj+kHmSjf4yXSCI/1z6o5ZlIQ5gU8zbGWIsxjLL0BUm2BboNaIMFRhe+pqEQU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696

On Thu, Sep 17, 2026 at 10:51:01AM +0000, Michael Margolin wrote:
> RQ and CQ ring buffers require physically contiguous memory. On
> systems under memory pressure, high-order allocations can fail
> even when sufficient free memory exists because the allocator
> gives up after a single reclaim and compaction attempt for
> costly-order requests that lack __GFP_RETRY_MAYFAIL.
> 
> Add __GFP_RETRY_MAYFAIL to the GFP flags in efa_zalloc_mapped()
> to allow retries with escalating compaction priority and release
> of highatomic reserves before giving up.
> 
> Reviewed-by: Firas Jahjah <firasj@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Michael Margolin <mrgolin@amazon.com>
> ---
>  drivers/infiniband/hw/efa/efa_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
