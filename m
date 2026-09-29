Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013047.outbound.protection.outlook.com [40.93.196.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077823DA7C0;
	Tue, 29 Sep 2026 22:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790722800; cv=fail; b=G1mpITII3LGtKw5DvcGNsrPMXCffuJfjYlFuhkFXWz9sEAKdmG/foqsXnoKA2KjyYsa0KI+UcVv9/9Ixuol0NkDmmvWZWUKYdIdsGjL0f4gAdcujsfFFi3/+EsAoTrRZvwNiLFJU/piW/nTkjKer/oeXUp+wwzDnd8sRVFp55UQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790722800; c=relaxed/simple;
	bh=Te6Z8E8OCzHSv7Aam560DWCYgBerwS0QrfjPhmVPfTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Un61jgkXwcDF3Ry/Xo6edz8n3/kZXnB/OO/SV74CyRT5cXN39P+bLO2GH2PEyz6KNBkRbg8vIQPXDUg/oO5UAQRYPJk5an3g7l2fMINS18bsfOV4OeI1Gvbhsu4IQaqgTEF5ngZFLJhi2paYnLk9LWx3mzLXSXuaje5VDCFe/8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nsLMFS6O; arc=fail smtp.client-ip=40.93.196.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nsLMFS6O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urtsyd6VDEQE68+fEATE90H3s7MhpTgD6jBMTrUU13tDFo+fM/2/E19mEFhwjj1s3Sr5ACiajzTmQxxVPX7FEMhKD65chXwR4GKrY2urzuKxrHQdUgEIgdm85NX5e1+cBoXYKN5Dn8Oxl9n/7hme3z8hggUJjunnacef0FUSxf44WUKxgMiBnNwA6muMsOr9ViZ+yEgMQnbUvybq9HeLAUuEwQ55e6BlVXxLUTtKmJ2cx9FqH7dbIc+yF0yIe4Dl1UqiOh7rQyo6bxoiIh0Tq9gtTf2zU3E8/ywHaa4Ef6VdmVurl3bWMa49xvcjqTcGUcq66UkYAanOT12TwvJq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEby59092FJmWzyn7Hyp13aDdXHHj71JLTk0EX4vdBU=;
 b=MyQ0tiFgxxP2pN6X6jH6qJwOD7AgKwEJhxzdJzF8oxDsL5GmMlrcM82K0gPIaG/dFWurF9hnvNcOXpyus6FF6z4EUMVaMXGntkJQ/Rh10uO2IfYWRkKvu3UFTQubH1cgL1DsE46PbaDTL4J3XkIIo6a/lTt5YGfrT3eQDn0vIH4ZjUqyN55S0Tv+pEMhZ46z7DWFPmsLm+z0Z8cPQf3OjWvBj1FyOY/2Ae67CRTf9ySoNc4YGvK7NU7GivznMTvOT+IjJOx7eJ7Ttr6Sy3478Y0F+KMAVJjtSx7KXnO2L6ENrj3deAiQkVQh4h7xz0xIOkmjJgnzban9rMjj9LuQqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEby59092FJmWzyn7Hyp13aDdXHHj71JLTk0EX4vdBU=;
 b=nsLMFS6O8K+7akB6AC+abEKpz88WePtWkem97V93CZpTe04PU8ZsJhQcxA4oyAfbOPUOENGlelELthQFTSKQMSF6kqvaEfXyzlp0VeWavv7gVqsQB5qsiCj+REwtkAn8m//YSuFP3K56pNRhKT1cI4kKvAEgpHKJTccje+9rEdKj3oVj617UxQFtmAHDkOkftZQf+GgUd3vcCC4O7HzH32+7Jri0wXnBauo049TxPEKloIyZubKipg093OTVIHWCPmXHeYc3KgSzM1kqqbsdLJm/HsAEihUEHpeaAJypEyFhI4bncTSzDK0crMysAirbEz7fbkmmbO8fqCHRODpDwQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SJ2PR12MB8034.namprd12.prod.outlook.com
 (2603:10b6:a03:4cb::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 22:59:56 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.024; Tue, 29 Sep 2026
 22:59:56 +0000
Date: Tue, 29 Sep 2026 19:59:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Serhat Kumral <serhatkumral1@gmail.com>
Cc: Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/siw: Fix length of first chunk in siw_try_1seg()
Message-ID: <20260929225954.GB2446731@nvidia.com>
References: <20260927115351.12245-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927115351.12245-1-serhatkumral1@gmail.com>
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: 3248805a-2b01-4f95-5470-08df1e7d6120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|3023799007|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	4sb5El0yYyl0+E4IXSCubmdRn2DZTU/YgMXXBNOf5urZbPKUNtElR5CNQbeAnFSpx7BZIxGBhwP4zG31xzxXSyViDAOzon9XOM+sWmfDjzXN77oXANWuORT7Mt50B3z+wTEsf2DO4Khs5Z1Lc8LYlyxgLI78ZZ585gZahinbWVL9aGsEmRmDfMfKt61zTqJSvpsgOo60okLEqsptdNeiuQltTVgQKYpdL19wOW1XXGubeF+paBJ4UjX5GBs36uidas8T5zxB2dBB21Imok1hl/rLuAWv8O/bzlezf+HA0kj4j6qJ+w0uvwILNM4SIHYcNlhleWoVpYs4T5SavKpTYPLqT8WYpTwYfIB6WcPpKB833n4cikcG60HySbEbolQc4lqXBCNsXR8RGPkgO1A1Pmtae4gVcXMiMAaYFVw12o129gAF3ODDY75Cxc1cqvr4buf57TrTnKA7lPv8v9zGv6A+7inyAEcYeA2tjJrQwU4SbWuqHhIUUC6bvEWr1nYM1vu7AX8QSFN4GTFUnqH3MOXX+DYgTiIO6DfdHdmLLCOlJ858Ka4Ts6OfO8jbL8aN0rBJP7GKRizKN8lZcXFPGPJgSs882cT6kUoBUOA2WdYKjKbessQeYu5byAPGAfCxnoe1RTPr9Aivho3yRJ8zz1/4aRoYXlOue9ULV/PlKnU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(3023799007)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oWcVP6LP4PwPzIa8C8bu4e+X2DsXJ20S/9TtzNnshZ5v7dtdSgDxhQ6Wvffa?=
 =?us-ascii?Q?r/DE5+ie72TiZY+bl3B8fJ9iQn+crdPhMywCmbXfHflJWgZwk8VlsTsQ9IC7?=
 =?us-ascii?Q?EzIIW+ZOFOnOcvZPukJGpZ+g58zln/tcV/roOY1lGFKIl9uXYs5NuSfF0NfY?=
 =?us-ascii?Q?lNGzzwBTe9j4IahR9vvk73m7zxanJXeu7SVNkLOYl1WTx39fWfutHGokqq52?=
 =?us-ascii?Q?bNELS7tTymNj5hbUkJdsgbqyDAzl5FKKkFrrtzSJuJFzLt7UpZLDZcUTdCl2?=
 =?us-ascii?Q?dxlqBMo357ryTyFWYJBknE1mWkHfEZahsUPrS/dSGUv9pCW3e/EBFkpWZqUJ?=
 =?us-ascii?Q?NX24Fg8RErnH5shRtTEf2wuETI8Tzy38j1jv+T0y0iDWBWuQpnlLsFAll5oX?=
 =?us-ascii?Q?rZ3Z2S4ww7uamviuLs3vsf1+/Pn5irvLzDE9uEkjB8Axf3zmhshFf79E173A?=
 =?us-ascii?Q?BlfnShHP+sf4AhqB2o/uP1fSWoAPORTdp3qNjud4hOTFQvGCZhVpJBm+hedX?=
 =?us-ascii?Q?1JkGTtz478jIP3dzuIoY8Vn+KxuRW/Vi5Slh+4tzpluuzpGM2S2a0coJRvdo?=
 =?us-ascii?Q?zVQQC7YKKq0VQawP4JfvzZJrrGeFhBTgqE4FMz6TqROJV0eNpMoPWTn9qHoB?=
 =?us-ascii?Q?fjc5r6/SyKnW8yRRGU1xeuu7FWP/tWnIakKmYTTg46uhkzlsSN4Y5IsfbBIv?=
 =?us-ascii?Q?unalR51WE8UPgE7Y9YJVs8hl/i6grs2rb8CTBnuzUxpaX8yy/1CMFWJDBZD3?=
 =?us-ascii?Q?JOOcpqmIru1WAc5YRmFzgVIRq63FO5ueEI+AOM9YsVz4si9DJXBelvwz189U?=
 =?us-ascii?Q?axvLmD5gHQLO+1M3YFxHLKMz/MLQHp5kr1a/87iBThyFgAn3LsNkEQJAOv2L?=
 =?us-ascii?Q?SsIVuxpLWqfW1WQbm10uh155GYL18p4yc+2uBBj62O6wARpv+hfySZzQRRJY?=
 =?us-ascii?Q?xDnunSNbGJx0XREapewudGkLv4jMkRByuDgGQGV2J3W9IYiC8znaYrA7rY+9?=
 =?us-ascii?Q?KcC7c6ZfkhunQhYzKA+nkTTNZHz1TgQcEw+nMgt1UHi3gqbrrwjJ4/UZPgbA?=
 =?us-ascii?Q?5Ugi/PyXYAYKZdrCXPjB7fbN7cc5dwsYLAXCRTUv9m8gsWSYE+0huDgW19tb?=
 =?us-ascii?Q?8tsYtwFetJH/nE+rnXLIm/gP2MepJdJOA4ViuXVn7VhgJUOR13yVMw7webay?=
 =?us-ascii?Q?ohos7Rmzoyd428hxt+V65icK/jk5ElMyid3L6kQtBghDGXsh8/XXu8w65UbZ?=
 =?us-ascii?Q?UpDGazWSHyt6nyA9+q0nNFFm9ADyPOCnqOmbjL+x6hrFK0SjF56ZpScmhnMu?=
 =?us-ascii?Q?bRL85L6YShL5csVTKb8T2+6NhaYNXxVOxd1bVANCWgSjofj+QyAr8LcPJKEd?=
 =?us-ascii?Q?ktE3oAL3pGyEHAaX72HGHVjXTUPXOyrRAtQ8okNf9TGZWkM7fs3PUaqlp7a6?=
 =?us-ascii?Q?HCo/ajEBWIhZVD1WzRlT0HIm2YRAElpq0oLf6amMJ8SqDzxGIhAR951vQnGQ?=
 =?us-ascii?Q?DXz6fcRzPuyCUqjcSCUrpATgXwl+aONgY390pLV4RKdzeC0sTx9GTmZYqhnI?=
 =?us-ascii?Q?SJHO0xkfC4T6PBQbsJbM/iQl3YZhgnS4th8dyDhmUoSpZwHPFHlqTITWoVIj?=
 =?us-ascii?Q?g9wy86KvFAnXmAK47JI4YkzmMVDsymHyJ1bTTrELNSlxBalpKORXDYITCJwP?=
 =?us-ascii?Q?hNtPYjcY+l+K3X4GpK3gzpYWfDYMjZj1ex7U5v7oTBgx13qX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3248805a-2b01-4f95-5470-08df1e7d6120
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 22:59:56.0121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+xDlZegkAhUilHtp3Bgq3NEwPQSfQXIRCuXNvQyboEPkCZPv6ua3w1u4T35TPhL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

On Sun, Sep 27, 2026 at 02:53:51PM +0300, Serhat Kumral wrote:
> When a short-single SGE payload crosses a page boundary, siw_try_1seg()
> computes the length of the first chunk as the amount that spills into
> the second page instead of the amount left in the first page
> 
> 	part = bytes - (PAGE_SIZE - off);
> 
> Use the remaining length of the first page as the first chunk.
> 
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Assisted-by: LLM
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
> ---
>  drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
