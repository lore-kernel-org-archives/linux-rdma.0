Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793080138;
	b=mP/BSJirriywcPd3U0veN+xSQonMnBDsbDhigqGWkjcjwS6MrlIJ5KH5bLRdrd88q0EO
	 Wk9Wkn1eo+0Uz62xIwSse9yrB1DJbmIkzzKjZw0+vXdNeYsakZr/i0SYAPbuSFcsOw2b/
	 vhAU0YLqsXqD3/zqpsdYi1VUwW2o7QDJOQJd5fvSR58qBhPH8mIQxBPZOeD9HcRILeOOg
	 hhmILI14+XDDlFHWvxEO832HUST71GdrQhd/wQpde3bJu+qw4i7tz8PVmRHihNRcuzEOM
	 oYGZMW0hlk7UEplQfePYGudBMICWYzZWD43IW9lz+sdgmST2MMalr0/7orNzfvyy25g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793080138;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=orew0HFCOjG6QeMy39zxQad9wZITCwtfKZiHsv0QIYE=;
	b=5iAvYm2qg/w2IbpK/sbVL4+O9selljySQFgKzIE/5tJhnz7G4gIYfLcvkay2isbs0jLC
	 RQQ2IPC2sNyGBX0SGClN2XdVAuVbODCRna0hKJ0wdgmumV43GavjHiBLQ5qjNgvBNW00Z
	 dQz/OpTWhz4Imz8nWrF7n0awjd8/+NtF047iXYX3DjPSuonxyzTi4r2ORUcvt781/j3ui
	 kBDygeLdmRvHuomGaXZLF87KdpN7lnCE+Ti50DbUCTvLIkwdmnVl1pirZhD1Cs8lbBZoF
	 U3JuI5XbJTkKTAbK6UWUQ8e5bqc2JX9gJ7lcAViAUCVdfCsZzTrh6HWZyv18K7lP7NA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UwFNZ2Un;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.71
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010071.outbound.protection.outlook.com [52.101.61.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA1A606A31A;
	Tue, 27 Oct 2026 05:48:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FA1A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UwFNZ2Un
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=euDw0Vfwn8cLkGnm/1+5S8qx7GiqrSx2fJWBqMXAK3cgjz5fn014t78BNaUVDpqmmXRero/2huRN3kMXhys+geckfA1c8phi3pwXKfbfv0mn03O9Mkac/Qnj08sgDDoUazU85FWtiRykydjROp63xdOhUaUK8rbcRbasp4XolkhFrs/PtN28rhFVm039aLYsMI+dfKEHsj5p2JhB9oXMGHzpM0DAL89FE+p6lUhOhiQcJaeFOaVNOtC7Ra3bSFLcHrCjBy7G/7rANm4m7JGZF+Dq7Et1NpUWpxSuFUUyWS/x5TILJNssOx5tr++oAJctvFpXKw5vRfSlndkkOHWlOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orew0HFCOjG6QeMy39zxQad9wZITCwtfKZiHsv0QIYE=;
 b=rp9qFOtSbWbGv0H5b3rrG+sFzc2BjxdEjyUsps83qqo2PSMGxeAf8A3O9tZ+oPHP9UhDUbKU7c05zv/U27GxoIypHcjDh+vaXIy+uO8g7Mdn+RNYEaR5EDDy0HxmeR8MVy2VkAOT+PqPW6EHRmX0V6ZfJltV+EDhcVPYk70EkRZggDnBgPjwdNjo48kX13RhuYKY+ExB7S6ti0aNNojamDYTqtXX+xY1cccCP1EruijzqQEfgUMLv1mCo5ma0LF9NP6S5o4jk6zAmo1An40KD6Jf9nks24XqHtw+0ohIAJLNDqIom1W+6xztyK/1lrTtw3wF61givFrOwC1jppO8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orew0HFCOjG6QeMy39zxQad9wZITCwtfKZiHsv0QIYE=;
 b=UwFNZ2Un2+2zbdghrUhERdBLcyw8OljZI5xVocfvqbjHRBusO3w9e96XFKIL4VW8Y5jA18aVfQ4H++CWocPmMhiV0+WOYBe/nYyJ3h3DGyFvWapyq5vINLAfrKxWImPyssTYFdoeNagBq2qcv8ZUQHkwc+ZcxSNcxKu29pTAlUIVyaF0dHbU4vSz5MYet7brK7XndMYQFCb6xCuTksxRKaZhmyftOkBwnrQOllMivmM5Iqf44ZGJ9EcGByPJak+9+V6ALFbOrI8UwtwrV5+ahMr2VkoL63KS2dEAluL9KLNhemLTuFGYPrPI8E/XfGeuGZVRreie2ZBwsJn6ifsmEg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CY5PR12MB6645.namprd12.prod.outlook.com
 (2603:10b6:930:42::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 05:46:28 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 05:46:28 +0000
Date: Tue, 27 Oct 2026 16:46:22 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: dri-devel@lists.freedesktop.org, christian.koenig@amd.com, 
	sumit.semwal@linaro.org, jgg@nvidia.com, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling <felix.kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, 
	treding@nvidia.com, jhubbard@nvidia.com
Subject: Re: [PATCH 05/26] dma-buf: Let the exporter select mapping type at
 pin/map
Message-ID: <auA0XzHv9lgImZLP@nvdebian.thelocal>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-6-apopple@nvidia.com>
 <at8IQZ34wkHQ_5PL@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at8IQZ34wkHQ_5PL@gmail.com>
X-ClientProxiedBy: SY6PR01CA0002.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::7) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CY5PR12MB6645:EE_
X-MS-Office365-Filtering-Correlation-Id: 9759392c-6858-4783-3821-08df33eda533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|7416014|22082099003|18002099003|261026121527099003|261022075727099003|56012099006|5023799004|11063799006|4143699003|10067099003|261009223027099003|261022105027099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	znck1QSyz04bugkYl6we+im5AaNhJVC+eyT6b1RfHtlbr1gQxYLeiztucY7dxkJAY78m2wdoS2UOALZyloWMKn5q4orfqQFuNl0TvSt4/BAeSAZLPPnpjRSjn2QyiNM9umIOTItcxfDajU1E+ku0cdr6w6TGuH2vFnOWTSI1DNzBjKAYv8KNUNEkaN7TXkoxsKSb3JKpo0AiBWrwzxttpmDYm5xzxvhaTWV9yj/+7DCANFqYpAl65048TsgTASgM/BAnVxtk4Xy07iTl+2NpQ1RPT4Sw6ypHjtOdatcGf7uH1PSQM4fSd7R1QZm4ij1rgv7W4H9AJUST1X6gT8dO6OQp3dkMV5DuDn6c6U5HZSZARMVtyKUqDo3i5cVzx2X6XKxPK5CiO57Z16g1VIYs8JV2K2qIVzjFXAA9YqHGkJO7YuYCgkUOC4Uh+9JRjWqUmRGo3X6Amcm/T6ZQqBPgDPXKeNEVRAmtEW3b0R2egwsaVwQIkI8sMV4SBYGm5b2lqonslRzm2T3Wk3gucFHO7TQzZPz7IDg68bpv5jbQ1eOEq5DZhLDW5vpfdix4FYPH4XfI49W+8VlFtUVpRxj1XAZ9u+558AciAm+GSpuV6q/F1Cjs1qgrvVapCOGu9ILI1/FGcYDDbo6VVaY5W1exhmSE10djTt5QZ3XyQx1fWzw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(7416014)(22082099003)(18002099003)(261026121527099003)(261022075727099003)(56012099006)(5023799004)(11063799006)(4143699003)(10067099003)(261009223027099003)(261022105027099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0YAxFUJ8cEEBfare/UyqRza9a9mnEpSKgQYBzt3Z63o/Z+eCVHkStkO/nYL4?=
 =?us-ascii?Q?jzN8ajZIwouaoTyCn5psMDrjjEa3mkL0En4ZKjx1bXFz0hU7816XQA6MS+F7?=
 =?us-ascii?Q?LCQhPtFyiCEeMic+c39W+xBhpSrQoFT4PJHJit6sSxNHgWKxha6KFjMggywO?=
 =?us-ascii?Q?ckdvwJZ6p3EqvM6qNcsq+ligzaIJ3BtO38jf3ZvSIs9iy3F/Trz+Uydu7qO0?=
 =?us-ascii?Q?kioclCJJl4x/hGlQQvndRVRDAqqwIdMLhTsgZlNit94y1mRRyKxOBQ7YacxP?=
 =?us-ascii?Q?LAus0Il0QCHeQU5qEEM0xJSU2NjRAL5I6r8X2GLJJGNfg2xEkVxY/5+nC1bG?=
 =?us-ascii?Q?K3Qdez28BBbLUCJ5fVzc+Sg72VXx57c7y0Zospjvcj/prt47HTNcXXaJnoB7?=
 =?us-ascii?Q?akGAWO53UQaizfaM2j7wLbu1uRClAutDzWRrOwAKX+a1M1BuhmXGjgr76Fmw?=
 =?us-ascii?Q?th5qAE9BwG0EYRbLqt1aNqfLaMSRo53M6dYzuawkViCO36bq4ALX11dcJs1q?=
 =?us-ascii?Q?jlEeVsnjS+PvZz5ivPRR4+MJbIBe28nc34Xc8ry2u6Iulq8SjGH0UeuC58g7?=
 =?us-ascii?Q?FCCzHCAAjZqnyuA8i3azouptiGYzrTtnPkJ+lXSsq02DzVoW509qesQWB3Sh?=
 =?us-ascii?Q?4vqJithTLjAQe0N3lIP9CuQ+mXLseD9yNSLQZymIg1NxV7Bulil2FmMydvgz?=
 =?us-ascii?Q?MEoPY9f6cE/lV38UxygjM4mPMYJKM4tBTB7U7A41kkDlOB9A8iPa10S9ldM0?=
 =?us-ascii?Q?jAzi4GofzotDpZjwm92jCmTOMacqfwF/NOsChtUjEA5RtyOaTYdZEnd3Kdya?=
 =?us-ascii?Q?RX7dtJ7tVhpeZMkO4aOOhbdj4mdT7HfpqgvmM94eJHGdeIF162m9Zm1/Pctb?=
 =?us-ascii?Q?HckSclrVyXxC25Cirvk8EHnQkRm+MXwWfJOk22+q7Keu7/HoXulwKzvKGZEB?=
 =?us-ascii?Q?DF/hZhWd940jRFhiGFMXYAJGgm3j0HRgdBmzFPBEAidOX5ghNWl4TiWJiouW?=
 =?us-ascii?Q?Oy02wtdF901Znb1KAlG7GvTc5faM0PuGDTfFkDRx+yfSjyKigs2mxVEftpt+?=
 =?us-ascii?Q?hWaBYFlO7uBpsAqT7MmQorIzbhTIH3A6xUoXa3KsiGyKuqbpA+wyIJPNr54b?=
 =?us-ascii?Q?97wY0Bhpzw+wD/dSzuluekon6mvOrSDLYBM/lSVGYn0ubdfvBh2ceisYFOWQ?=
 =?us-ascii?Q?xdHGtev1xTEtZ3WDY7HxdT256w83V1d0tI8K+Sh9SZ5Y8Pyz1Cc8bg90k78c?=
 =?us-ascii?Q?1NHziSgOdrYzyIsSIL2h3S4xJ2/8MSflb7N/ClOs7oCwhaBeeZSfTseAciuK?=
 =?us-ascii?Q?QwJxx+MbhYZrVgTJ4Jfdw+c8cY93orHh/Q6b7tkdf7aSw7t8P8RYMu9kxH7z?=
 =?us-ascii?Q?EmmN3PTbCn2SwWthFTEAJIgW/LDKfjLX68OI61ILprj6KBJUmHOKsXpsPCn3?=
 =?us-ascii?Q?RRpq1Z2tDHPVjQdd0mOKGK0QGJQJR7UBv4XNcE/hvrgc0OIIvjNBKyc1itmB?=
 =?us-ascii?Q?U/tQtRTbTfEXaY0nhlVip8pxPSiexo2MaW3h225KAqnrZOeTHAvQZcxJ8NRo?=
 =?us-ascii?Q?HmlR0k+UJbEpN0388MvOX5srilU4bq3avzEWZBK6JN0AxIxQRQSnlemKnjAx?=
 =?us-ascii?Q?rZeoGyj6xNqu4IGBaRQ9q94g6su74OU3SrFKcrnbCWLF56jSxV+jB/rRt8Lv?=
 =?us-ascii?Q?WqvQpt16RmLvDyTSpwVqbKb+/IF9iosbLyBJyYZAlO7rXaWx6/s2KHDy0GEb?=
 =?us-ascii?Q?2f8nu4A8/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9759392c-6858-4783-3821-08df33eda533
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 05:46:28.3993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSNEgZ5vxiyFMECzjOFPBjAJ92nBZUhaWxcFiok652GeudCENXfbzY0gJ82CX76zY60igr4zCsXf+t5wDy0G/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6645

On 2026-10-26 at 19:03 +1100, Karl Mehltretter <kmehltretter@gmail.com> wrote...
> On Mon, Oct 26, 2026 at 04:35:56PM +0100, Alistair Popple wrote:
> > +struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
> > +					enum dma_data_direction direction)
> > +{
> > +	struct sg_table *sg_table;
> > +	int ret;
> > +
> > +	might_sleep();
> > +
> > +	if (WARN_ON(!attach || !attach->dmabuf))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	dma_resv_assert_held(attach->dmabuf->resv);
> > +
> > +	ret = dma_buf_mapping_select(attach);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	sg_table = __dma_buf_sgt_map_attachment(attach, direction);
> > +	if (IS_ERR(sg_table))
> > +		/* Nothing was established, so the choice may be made afresh */
> > +		attach->selected = false;
> > +
> > +	return sg_table;
> > +}
> 
> The map-failure report from Sashiko [1] reproduces with a KUnit test
> against the full series:
> 
>   pin selects B -> map returns -EIO -> selected is cleared
>                 -> retry selects A, with the original pin still held
> 
> The exporter pin count stays at 1. Preserving selected when it was true
> on entry makes the test pass. Patch 7 needs the same fix.

Agreed, thanks for looking. A failed map shouldn't undo a previous selection.

> Could dma_buf_mapping_select() report whether it made a new selection?
> Then the error path could undo only that choice, without dropping one
> established by an earlier pin or map.

We could do. At one stage I had a prototype of this returning the old match, but
that got complicated. We do need to undo in the error path though, so will fix
this for v2.

> On the Sashiko failed-pin report:
> ("Because the attachment is not pinned, the exporter may migrate the
> buffer elsewhere without invalidating it")
> 
> I don't think this follows from the documented contract.
> select_mapping() requires the exporter to keep the recorded type
> servable and invalidate before an incompatible move. That obligation
> still applies if ops->pin() fails.

Yes, I think that statement is correct.

> Is retaining the selection after a failed pin intentional? If so, this
> can be added as a test documenting that alongside the map-failure
> regression test.

No, that was not intentional. As noted about I think if the first pin/map of an
attachment failed it should effectively go back to the selected = false state.

 - Alistair

> Thanks,
> Karl
