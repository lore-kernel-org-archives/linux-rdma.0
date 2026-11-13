Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.80
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794563000;
	b=n3y712qMa4SOAYb3KQjB91finA3rlgBaIvNkfI1pcFdp4NQlUxuwGaAmymrzkKjstwpy
	 bs91jHkCLJ1lB4LDVxhxUdGNuzs25we2TU6Oo/wczx57Rmfxi0oD616QbKedrvddS7+Ip
	 JbyHIW7hkt5qrUBoRuAThyt2MsNrT7uyKZLGlfmrgVe7ZY/z2kRwu+Ps+gP04fr7aoQ8c
	 BBhhrbAOHegTtFhCZ0SZK7bWbcjUhbMKjMT2GclgXEuPoj6rgo1W+flw0Tsx8X96D49gZ
	 A3DUYj05dEyTwIJb21FeP6BL/3xgwvA6wcUejqgrFJ2ZWlYCMMmo0zEH4wJbxY3FGkg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563000;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-traffictypediagnostic:x-ms-publictraffictype:
	 client-request-id:request-id:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=zy4Q8xWNYDoTXK8k5IsqQEHkm/sMtvtNl/WR1nzf1Do=;
	b=KU4D1dDCzbX1GVK4gYOYSrcCiwgLsgFEtQURp2SsXoUYzJ4W5mVm45iXgTqwuPdWnyXP
	 8iCeKh/SnpkkHTQ5rbCMoLGWta5OnCyEPKc8LKskSRK061e4r7cBuG/jXdrxgz1hEicwK
	 vINd33CF9tYwC2dGBG2k5qKzHkV9fOBjUo8HNS3KRJV/GNf+0sZu+xRTzLKez9LfbE7RO
	 Rf48Lf4QMu69Uv3M3LyK4w4rss1dsvwKr3gv92odOuMI6A3y6HOPISBoF9tewMBRD9QEN
	 ekzUWLq7raN2ioTH1oTSuvFNNYJoQc7LOJYXiYOAGkD/evvabDnqDYDiF0mi9ysPdHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=EVhNsK+p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.80
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021080.outbound.protection.outlook.com [40.107.130.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759DD606A323
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 09:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 759DD606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=EVhNsK+p
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wCLa8GUSslcGc+5mZTvwsaAWaT8zRvShnRxhmG17RlDzAQomZ9H+O4iy4tfHh8wBduDJkgR/FeZ9OFxaJSVL4yEqZqt1TelYHiDxYOSjPxPf4Cueb86NT8fcChZnWQUpvPDd0bhVLodE/F6Xr5bftLqZzKsDOx8EiEzmj2wyE94sC5oMymO11FS+PI1ng6JbJOWNMvuSeEzlNO9XbdT2pfD+Jw8OZMdtkVNbKt5qFpVjcuvmI4rdgxydRk3rdqwdvQIB5r01xYLBNmfsI88uNCr7l77SyJ0w62Hn+l3ScCMNvNn0Me7Hl0HHFU+vbRAL2uXOPCnKTOqSqWNjVd67gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zy4Q8xWNYDoTXK8k5IsqQEHkm/sMtvtNl/WR1nzf1Do=;
 b=OkD6aKPZYZpZqlBdlSP8bBTmV+7gE72fL5lKV+NKJTQb9Dqq1wIKrvHkO+GIDN8GKS4CR43sT4daizcUdAOU8C7txeAqkI31zZeGRa9vjgXTpZKlo9etOVu/U0NzTfa9/lcbZk58edtC87ZlM//9rkBLMfMlOH6DsvTeu+4WuRJPCMPqWZQC2SouU/dJYnEDtEsfLFqANci5G+8IOWbbJC7yKs39invpOzv5AmqqYxFAGh5fGfPUBKr7g0OY+CIjLTB2j8Z0A4mj+omZZqu0liE8kHoftU4pxCAMfHlgUfgrGETsgi+9ijbz1JpQ0yGS7GEKTowV65nmvwtTUUAndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zy4Q8xWNYDoTXK8k5IsqQEHkm/sMtvtNl/WR1nzf1Do=;
 b=EVhNsK+pxtBJ7tLoE8La5sORsXXucOct3/mHmRHbWiBUUsuLS7xp0FESohZoG7z7R32RKvI83QdQNCk0nvcgk4/BQivC+dCB/PVOQJ1333/+FMjL6t/OheFPlr2FLHQu8kLd0yMV63mftS1+vUGjz5IOo0XDCWKmjluxUBWESX0=
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 (2603:10a6:250:7c::20) by ZR6PR83MB223992.EURPRD83.prod.outlook.com with HTTP
 via P2P; Fri, 13 Nov 2026 09:43:16 +0000
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102]) by MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102%5]) with mapi id 15.21.0639.000; Fri, 13 Nov 2026
 09:43:15 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	Konstantin Taranov <kotaranov@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH rdma-next v11 9/9] RDMA/mana_ib: Handle
 error CQEs for kernel QPs
Thread-Topic: [EXTERNAL] Re: [PATCH rdma-next v11 9/9] RDMA/mana_ib: Handle
 error CQEs for kernel QPs
Thread-Index: AQHdcoJzI70KLvjrDEyU1qWVtpjmsLcqKDMAgAGZbKA=
Date: Fri, 13 Nov 2026 09:43:15 +0000
Message-ID:
 <MA8PR83MB465002321391E39E6589A88340B47F2@MA8PR83MB465002.EURPRD83.prod.outlook.com>
References: <20261112084716.1483342-1-kotaranov@linux.microsoft.com>
 <20261112084716.1483342-10-kotaranov@linux.microsoft.com>
 <sashiko-outbox-210859@kernel.org>
In-Reply-To: <sashiko-outbox-210859@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=48dc3aa0-00e0-4eb2-8da0-8ca2ad140f92;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-13T09:42:39Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: MA8PR83MB465002:EE_|ZR6PR83MB223992:EE_
x-ms-publictraffictype: Email
client-request-id: 2151a23b-fa77-40d0-be52-58e0ab0f9d69
request-id: fa930d81-13b3-487e-08dd-08df416a8aba
x-ms-office365-filtering-correlation-id: fa930d81-13b3-487e-08dd-08df416a8aba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|38070700021|261009223327099003|261009221227099003|261009221727099003|11063799006|261021133027099003|261021121427099003|4143699003|261102123227099003|261021123027099003|261022075727099003|261026140227099003|261022105027099003|261009220027099003|261022115727099003|261026135527099003|261022113327099003|261026130827099003|261021130227099003|56012099006|261021135927099003|261028144727099003|261009223027099003|261026121527099003|22082099003|18002099003|4133799003|10067099003|7146999003;
x-microsoft-antispam-message-info:
 DVkS+0hz8YFgpbHANPOKL/KELJckK1b8zEHFtZqyaOU1/LJMtNEOgjO6p6XO3opQCeG6musrMPZzIKLFD+WWGdWLkUTSqg2pFDfUqKXt8o4FUs+M21Glldvl5yNtinZ5tg2kpJ2i5UjZEKNQwQQCCnl1vw8BOfk50ecqJNU/h/vZ1XPOadHo2TwGpmP6vUtJmKWXSqDYFaBzOhLEAan//Ek18LKMvjckQx7P3ONN5FiRqpgIyBeliV/mshKx1+NBXO81NcO6+i8rURka8NonUdZC5rUK/uZbiiciL793mDjz0XriOtEmpU5E/H3kXjHfmU6GGpopFfG6IA8JAKuEaJqtzqgm+a6PivKT/zac98eLxIFz94oLQzosKsZ3aF0Cs38/VqRQuhZktaf72259BYoz3nUjwkP3EZkqGEm+AtoVfAljlKmchNlxQVVlE5XJ6riKEVUI1J49P13Q6vFJek+Y/brTxQx5KcS9nitsUB5y/dgde8Sk6kDfAL+il7MzYeJyL0Zcst9OFSm1zMVHjvhfvn4u77n9X76ElTgrHo9efZUghtQDs1Yx/aOCfxHEWPO240GHDQFVvYu38d/6E2UvdbH8UtMNydL3P++4wXAgt4txvczeSPxS7XjSqFarpfH08QwXIOonENelEP4q73CpmTCc6rF8nbmJMrt9u5aJmBlPBFWHOy9RDBts3+70xFyJy8H107VEBtSlROoRYYlUuitiGySsv42a8iYBz/k=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(38070700021)(261009223327099003)(261009221227099003)(261009221727099003)(11063799006)(261021133027099003)(261021121427099003)(4143699003)(261102123227099003)(261021123027099003)(261022075727099003)(261026140227099003)(261022105027099003)(261009220027099003)(261022115727099003)(261026135527099003)(261022113327099003)(261026130827099003)(261021130227099003)(56012099006)(261021135927099003)(261028144727099003)(261009223027099003)(261026121527099003)(22082099003)(18002099003)(4133799003)(10067099003)(7146999003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?E1+tWaT2NRRepBw5mdAXfCZEr7qOi3zKC75/7Ajd2wyBQuEORyX0Pr/6kyS1?=
 =?us-ascii?Q?exNFzkvS4Q8cSrOdRSHP8F+THv5QlId9rCMkpTjHD28l0D3c7sod5meMLaFn?=
 =?us-ascii?Q?yvj/kCOyGNnK6qSl6Xb3zT3izdFGaf0FzsqbIEgLbxp2gtImhpF9GHyU7/wg?=
 =?us-ascii?Q?2qqqUsn6pD9NdJ3yH1lplhsRU21YoeeeNIQpiQcVnXU4NtvaSjdOj2S053iK?=
 =?us-ascii?Q?vRQCaursJcMtAKfjg4xQVq3QEK0IhQf+rlCMPyIjTG6l1bGIyOs/oNns1Z7T?=
 =?us-ascii?Q?uRgobE4zA4P8moBZzywAz4Yr3TJx1gWrFDwvGsKo9umu0MOneoBwU3hWRINM?=
 =?us-ascii?Q?piSJMcCcQavfOFWy1R07/QfcmM1cxY/PqJ+Aouux/xubx9PAJlxtQMmYN9jK?=
 =?us-ascii?Q?767PH32l922WOhw4hcNrkje2+k08gYEgNtXfZG+3A2mZvzw0FPKYV/zD3UeX?=
 =?us-ascii?Q?dVsVCr6PtbpfqD2PXlwxWoNhZeFp4hPKh0gB+DYYMaFJg6gpvJoN95/14UgE?=
 =?us-ascii?Q?mRRXfab5dz7hNR4MoJRl++1uvEbZC5VctjbFkeSkSnaDr8SRk3Ps6pk4QzIp?=
 =?us-ascii?Q?awiJipffNf9CttHrxmfQcKbMKWjUGUURP1wwPHSZ0AZn5P6vAgTr0PhxGdhS?=
 =?us-ascii?Q?1ftZo6c45EVbZbDuhmM8aQNNgNh0rAI5LB3kYanx155MUjEOF0QUJY3h24JO?=
 =?us-ascii?Q?HZc05mPskA0ID/O4lVYhkVcbX3AUHcm4/2DPoUcJZar+1D3BcFgBcPPSy9DL?=
 =?us-ascii?Q?vVTbDeedGEVBVwVush5yD6hreynHdyECjwg2YeL2/KLM+nbLrdKXDJCDxRUX?=
 =?us-ascii?Q?jtoH20v1Uay4v04DtBonXyZKJEwy7MKRFNVTrlpwcjH2+wk7isdb4eDRmwK1?=
 =?us-ascii?Q?AUtHGluoZ1sHEdJdL37T+a1fFsTdyOMBB8JHKLGw15r/kRfYplP5kg6s16vC?=
 =?us-ascii?Q?pSyKbMUTEYYnsNM++y4be42lyWbA5n1C/jfpbQXq0+y1ZOlvQXQixAsfY3sl?=
 =?us-ascii?Q?pOhJ8i6lt7p5nHW0CKqRyxYYojz3a4fRT7kkubw4w6KKsJKQ4j3fwMGN1S2r?=
 =?us-ascii?Q?n4k4n4QOzwoReqK6h4w6At22tUEXrVZ68UJutW0Qkn3hpcOZ3wkiG6dFcTZB?=
 =?us-ascii?Q?AVqKbT2stlkfX69MbvvYa6lh4r+lIP5czE/wbX8d9L1RBVQW650VIKezVMkh?=
 =?us-ascii?Q?7TiBW4Mj0KF1xYT7GkQZVIaU8ndyOf42cE1kUfx731jR4vkFpdHWuzD2hhIk?=
 =?us-ascii?Q?PDZ5G1F4GSCQWjrLLUx5n+nqE6E/wCUZ733t8Hzeb6/uIOxwczm8Io+ZCV2J?=
 =?us-ascii?Q?IHURsBk/evZGRZ3p3MD3Ue7TRo8XH0I4BvEZbySKH5EGluEvzVh87l5hQ8zw?=
 =?us-ascii?Q?PgSfi/MKH1gHR7lqg5ztTYwijTwF+PmZ2tFaXEFguvnQ/C1QHsXCF8tTGUOL?=
 =?us-ascii?Q?4PavXAjWYZfvpEEANO8/sIc1d5Wn7zW1Ex6pcLFfSGLphWiy5fWHGsA/sHZi?=
 =?us-ascii?Q?yocK1qh2qsDWXzTD7hOLMBZbtPfRee/2aGEZ7K43+w7Bi/UgO5J6UzNVkJFN?=
 =?us-ascii?Q?wE6fBz7+90lgF9Nu8t/EX9/mFzAZ10G8KhvhEFhj/tWV4OMX9lJFQLDYmwcr?=
 =?us-ascii?Q?OlDRlcQza4rtfj07GkE5pug51NGL4oQav2k26Fx4pVAdy47KstryHZaAzShu?=
 =?us-ascii?Q?C+fFqA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA8PR83MB465002.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa930d81-13b3-487e-08dd-08df416a8aba
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2026 09:43:15.9153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmQAUXLNIhpCAzFRV7t4nc8h5jgg+ztG2wpSMsZzNDXF+nyC7bmqea5k5vfTfrH//Vu/Rs1yZ6/WvPb4tuyqAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR6PR83MB223992

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e to
> consider:
> - [Medium] RDMA/mana_ib: wrong WC status in vendor_error_to_wc_error()
> --
>=20
> commit 3890146d1e1c2dc4555e62f3e8c6c195602b6f98
> Author: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> RDMA/mana_ib: Handle error CQEs for kernel QPs
>=20
> This commit decodes hardware error CQEs for kernel QPs, defers moving
> errored QPs to the ERR state via a workqueue, and cleans up pending CQEs
> when resetting or destroying kernel QPs.
>=20
> > diff --git a/drivers/infiniband/hw/mana/cq.c
> > b/drivers/infiniband/hw/mana/cq.c index 3d09ff5e5414c..24dca3b6e5bfc
> > 100644
> > --- a/drivers/infiniband/hw/mana/cq.c
> > +++ b/drivers/infiniband/hw/mana/cq.c
>=20
> [ ... ]
>=20
> > @@ -37,12 +40,30 @@ static enum ib_wc_status
> vendor_error_to_wc_error(uint32_t vendor_error)
> >  	case VENDOR_ERR_TX_ATB_WQE_ACCESS_VIOLATION:
> >  	case VENDOR_ERR_TX_ATB_WQE_ADDR_RANGE:
> >  	case VENDOR_ERR_TX_ATB_WQE_CONFIG_ERR:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_MISS:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_IDX_ERROR:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_TAG_MISMATCH_ERROR:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PDID_MISMATCH_ERROR:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_AR_ERROR:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_OVF:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_PT_LENGHT_MISMATCH:
> > +	case VENDOR_ERR_TX_RDMA_ATB_CMD_ILLEGAL_CMD:
> >  	case VENDOR_ERR_RX_ATB_SGE_ADDR_RANGE:
> >  	case VENDOR_ERR_RX_ATB_SGE_MISSCONFIG:
> >  		return IB_WC_LOC_PROT_ERR;
> >  	case VENDOR_ERR_RX_ATB_SGE_ADDR_RIGHT:
> >  	case VENDOR_ERR_RX_GFID:
> >  		return IB_WC_LOC_ACCESS_ERR;
> > +	case VENDOR_ERR_RX_OP_REQ:
> > +		return IB_WC_REM_INV_REQ_ERR;
> > +	case VENDOR_ERR_RX_ATB_RKEY_MISCONFIG_ERR:
> > +	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RIGHT:
> > +	case VENDOR_ERR_RX_ATB_RKEY_ADDR_RANGE:
> > +	case VENDOR_ERR_RX_REMOTE_ACCESS_NAK:
> > +		return IB_WC_REM_ACCESS_ERR;
> > +	case VENDOR_ERR_RX_INVALID_REQ_NAK:
> > +	case VENDOR_ERR_RX_REMOTE_OP_ERR_NAK:
> > +		return IB_WC_REM_OP_ERR;
>=20
> [Severity: Medium]
> Should VENDOR_ERR_RX_INVALID_REQ_NAK return
> IB_WC_REM_INV_REQ_ERR instead of IB_WC_REM_OP_ERR?

No, the mapping is correct.

Konstantin

>=20
> --
> Sashiko AI review *
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsashi=
ko.
> dev%2F%23%2Fpatchset%2F20261112084716.1483342-1-
> kotaranov%40linux.microsoft.com%3Fpart%3D9&data=3D05%7C02%7Ckotaranov
> %40microsoft.com%7Cc8c774311d0f4029843d08df409feabe%7C72f988bf86f1
> 41af91ab2d7cd011db47%7C1%7C0%7C639300727742495506%7CUnknown%
> 7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJX
> aW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DoCF2jr
> vC59G%2F6C0p8ZlWVzVnNTUTr5o0bpN%2FnQOX52Q%3D&reserved=3D0

