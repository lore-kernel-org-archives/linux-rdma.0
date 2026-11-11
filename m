Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.114
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405812;
	b=LwHnZyHpJdgMPvG2LvEnwNDbO+rWJhcqrR+DiICmebaQR9d2Bc8WcX5lsZRzD4OD7Nl2
	 cZ0X9NhvY3qd7G2z+kJ4XUGoLxhckNa3hx6PoHgYKXhd1bYoWWkDWtOQS3QtZZh25uh0B
	 W9vtaMUfzrLIDqkRjcywXkg4/npxf463jo6SruEBAMXV6FlA3/3CNkQDN4zvpR4c0uzwv
	 HNl6JPQ584cAnetbpY+dQLDT61nj6DiVFblGtLJSZqHt5aj1uPqFyHh+thxYxgXQflf5E
	 QFuo/OPDsBY+sw/QCCPb03S3bQ2bEU1bZSde5gzfcPfCXXW7HaF3qE47HamCtKWEODA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405812;
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
	bh=y3e2tBnimtlVQON8IDAQEAlvy105ueOX1a0YENk/diw=;
	b=oBUgn4lXXLwHLr4BShWBHCv5xA2oEwosnjmHwRy3NrkQI/JAz0h1x2v+ZBRTlPCoDSiN
	 aolDru6HmN+Tk3XqSjnBr5NrGdwjKRwcn6RQPzaeue0JITi+Cjxyenn/vidRQ679/GMNQ
	 KyukI9cDqG6rwmAZmvswk1Ci/FiGxIDxn5WXD3oI9eyD0HMrePvgeg2x1pKMIuFxSEEzP
	 pRhrgZwQ2Y3ffUyT3h3DgmFuWcbqV6bhGnw05PT/9nu++uXTJ7U2x5L0aa34+64mzG+wq
	 KR65vlPSwqEmvs+2x8DynijA8QgQVOHQyA05KMp5jDl2krQC79Regkw0cdLqlBkgXxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=K3lpKFiK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.114
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021114.outbound.protection.outlook.com [52.101.70.114])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B8E606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 14:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37B8E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=K3lpKFiK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z75DNobOJ7bFi0Rwinv6i3Me0OAAcbm1N/rfZbraYGiz2SE5/Q5JrSGxAUTbK0XWdu04L1Hac4bbWqacHEkRDnCDnMQhogMlzbRC7cUP2Sy01wvuf6hStTbwZgriYdrmZdX32bzI86smXVInTePA9TmqJrX78PeKDPbASE/vF+h2FNRVM/o7kgRCXdgFt126QXPtCg3d1EFOa7cadvATeHAZqmuX9v0xTT2ChRx1IvqHZQDwCqgaBQKUKF2EuFUl1I1vO1RtTd3x7APfMzSPFYyGZjg/f4XhCmrHpqWm/rKIBDE4a6Og5Wvs0PWR3SLcyF+Wlax8ibGYyd2/zfg55Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y3e2tBnimtlVQON8IDAQEAlvy105ueOX1a0YENk/diw=;
 b=uaG9DTaGnSHhxdBiZh3PGKYnxc8ZjIQGhQOwm2kvRV++h4s9wno4anYeCo26wpTbTGS1xEyuLILRMSyRTkOI59sYI2SvzRGjrEpz8Q2WIJKyGlE77hyiQ2Nnsnn3900YWYp0MYF2D84kkOHjvQK/p/W8ZJpFtPAGMdYvBqNb3XtupgXiPwTOhV0vE9bIY5LxoXXDWLL/uSJRxsx7VA5N7AiBG+QzdH7+1PrnwUGlDYD11XQ3kK3kA+B+AOiGpeblkiblVwlMgV4+nv9zhBZBNFUsJ23iBbHHs5KJFtNRko+pgvRCwlU935qAYewVP/+NbtmDaMIT0y6sIrsnnTCHyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3e2tBnimtlVQON8IDAQEAlvy105ueOX1a0YENk/diw=;
 b=K3lpKFiKCq1IOzMYkBVWms1h+Cm5w1vLCXbbeglbGio9YtxjgqFtMG2IdcutuL3l5+81Xl79FLxwJYQbwupejOhOto+7HTU1oeGemaA72EtPWAlaZ6RJal0CsSRGYdxE/bgvThIx+QFldlJ5sHVF5dC9yHKdc/L4QMLuc4AcXZ4=
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 (2603:10a6:250:7c::20) by DU6PR83MB0826.EURPRD83.prod.outlook.com with HTTP
 via P2P; Wed, 11 Nov 2026 14:03:28 +0000
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102]) by MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102%5]) with mapi id 15.21.0639.000; Wed, 11 Nov 2026
 14:03:28 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, "sashiko-reviews@lists.linux.dev"
	<sashiko-reviews@lists.linux.dev>
CC: Konstantin Taranov <kotaranov@linux.microsoft.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Enable RDMA devices on the CDX
 bus
Thread-Topic: [PATCH rdma-next] RDMA/mana_ib: Enable RDMA devices on the CDX
 bus
Thread-Index: AQHdceVtYi6daMcyq0y10M9ezSvIXQ==
Date: Wed, 11 Nov 2026 14:03:28 +0000
Message-ID:
 <MA8PR83MB465002960449176635E159479DB4712@MA8PR83MB465002.EURPRD83.prod.outlook.com>
References: <20261103115032.736554-1-kotaranov@linux.microsoft.com>
 <sashiko-outbox-195213@kernel.org> <20261104094108.GA478286@unreal>
In-Reply-To: <20261104094108.GA478286@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=88976812-7e08-4c4f-bc7a-2f936f8e70b4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-11T13:58:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: MA8PR83MB465002:EE_|DU6PR83MB0826:EE_
x-ms-publictraffictype: Email
client-request-id: e1af5f30-9d55-44dc-a9b0-87e81b7cc59f
request-id: 7cf34227-1ae9-40e4-8e1b-08df3ffc8f8c
x-ms-office365-filtering-correlation-id: 7cf34227-1ae9-40e4-8e1b-08df3ffc8f8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|261009223027099003|261026140227099003|261028144727099003|261021135927099003|261021123027099003|11063799006|4143699003|261021121427099003|261009221227099003|56012099006|261102123227099003|261026121527099003|261022105027099003|7146999003|18002099003|6133799003|22082099003|10067099003;
x-microsoft-antispam-message-info:
 t52Hgiva4Dh+O0eYPkXehAcQhdmjrPIP5DSHZik0qwvurdKqu5XY5X6F86RUs7zk3CITLBJ4NaB1t3p1BEDHuiFDlj5mWeydb75OBiDgQIvAoj2ZlnJ/D5fxlQrduTASaT9Lgu2NGrvKbv31BjXh2yydAhCuRLqnwK1lLEhx7H8VUgWL7OK+Wqu9TCMfTSGb/Yup55tMp3vuMACrllH60djhoG296jEvBcT3jdvdDaqG/W/HGVcA0N1i23KEuSju79T6GgMQNUl7YrL2to4hVIglxWoIBr2g5rD5HUYb4+Put4r6F34NLwEsi8+ef3+GUPsGFY8NSpcIM7PngJyCJk/rKsYF37uQeNCt+wAFkcufkSFzxRmcSjLKQCvhI5mVUbeJxmAb7onX1RKFG9h8ksOESjHIN+t1RtxUvYbzdlrC1PSudU5zIXD+0cZfLz7dqZhvtyuckiLf6HOqjmh2nKdOjZSwhCl1JEi5EQEIPOezFCgGRmC8FaCJWArcEveYmNyWocw12e/enYydt01pGXkhi56QwSA7glUirSqzDDVf3hdambaAxj8U8CHE8HucepZiMN3dq+Y15b2m2/e6OF9Z58m9K8nYqgTyyWCCU2rGBpQQeSvlYtHSq2coU0ZrYEjkVlfCKlptbAA+nrFqikRqSujOogHqwDY2gJ6g11e0K9GceAnOw70ccywUjAl1XEbxBAaaE0tnzWj/owDpAVVU+bXuItQc2c7IyMOPqkk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(261009223027099003)(261026140227099003)(261028144727099003)(261021135927099003)(261021123027099003)(11063799006)(4143699003)(261021121427099003)(261009221227099003)(56012099006)(261102123227099003)(261026121527099003)(261022105027099003)(7146999003)(18002099003)(6133799003)(22082099003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?q2+Tl4HfBOMrMtG5ijCsOVeBwRIUokb0qANlbOkrpKJziiDJY+THg5rvP4RT?=
 =?us-ascii?Q?P7Pzlu6mEpP9bMMANHtUn6ztIEY+VIHvTPYd6Uq2d+oUvXoSTW4taB68eb7z?=
 =?us-ascii?Q?dYDh9x1PZEaOxAuG4OO+wdfN/EU6MfzPLcOTkeJQw6VYpdo2/aDRyf2LJvMp?=
 =?us-ascii?Q?5kcrjBDELgweYpMlxd/rbLPYPOMPNLcpfvx59quzVPhCB9s/PFkbdv+3AOoF?=
 =?us-ascii?Q?N4HB3orAKjiNzUYS0OwF+dDnPyS1QrTWu1z3TTSVOT1YbRal6W8wEy+iNJRz?=
 =?us-ascii?Q?BVNSU05AWRY7e5XV69g3reIc3L9yU7rvmdpmEmiU0rzeDPtISWgxy3Lm6Vdu?=
 =?us-ascii?Q?ZqMRQzREV40ha8WlFsvRv09+mI0C0aqeaI5UIhGsveUsNNAE1c8BGaqA07eP?=
 =?us-ascii?Q?0b6oO2RN8GFtrkunXpeGbgPw91MNxTWBhjX4f8QPx/M7+yWq3ophezZmASfY?=
 =?us-ascii?Q?zEm5TDL0gQfWHwtnncAd8JCm1hOBBGqe+HWKcFn2ohFVKdJn7qdNZGwBSjTq?=
 =?us-ascii?Q?vQuQCgLta8sQUHpl+9tEtd3ZNhPdW/F+cUCOR6Yq5Yh5iFebXhtMArvwSlpA?=
 =?us-ascii?Q?mREJ4YGa5gTHBFrnlSVbY4wh2Cyr3tLoFqzNhFsH7WZ7Tz2ti9kz+PJzUig6?=
 =?us-ascii?Q?X4V1iQdSlrLTDQece0V82wo3P/yOOKLn/rw6FWyXfVUTkG+WzPOoLtKFtyAc?=
 =?us-ascii?Q?mcOpiI1s7hdUxvwE7+8rdlX9tNAYYOpGoJS16F4Q32CwJ43K9n+9ZoiRsJTM?=
 =?us-ascii?Q?vjt48C+NCyk256lUX+gI0+060ia+DzQXqS0J7XcnrZugi0LspbN9+zX9sPjN?=
 =?us-ascii?Q?an1vZPaILWDylaMOsXAtVBtjBZ4cvyT0yrC1ffzPpoEivYpqrNISQCJTBVTN?=
 =?us-ascii?Q?XqfYFdCFzu+oWUrqyz3aPlJIGzIrLYeA/wuMuI1sLv61s3pyHS7dHxaGADQP?=
 =?us-ascii?Q?u/Sze3DbgbaRdEWQkluYLOt7j18O1Nc4go8LQmDRA1q8CC+uVKy7MVjst9yW?=
 =?us-ascii?Q?3GjoBJeBPPCM9FghpwtXi5f6Pv+ymtbAgYLbDWEVbVTZo71vWRVWQimFwBIz?=
 =?us-ascii?Q?qWEShUay8TD2YDGQkcVCYTCbeIS7P/bSK6H+XyjJteVkUUpvSIbTysFLTOvP?=
 =?us-ascii?Q?0wxuhljae/+0KOwEmmg0O3oFQkt76CahJo85WMCzcqk/WDGS6KJhjXsqMT4B?=
 =?us-ascii?Q?wWWiPoS3svy5YeaexSXe5k1Q/igqR6TaGn/+Uzi7a3vC/fNp9DvBlubHvgyY?=
 =?us-ascii?Q?k6FA0F0AqzPoKz2y4Q5RCgJX6zE/SXHrS84cgpMc/2t/s6tf+XYGs5Q2oojv?=
 =?us-ascii?Q?rUGs+sOiBzhrSYO3d2NDAY76yp3wTk447RK7nMv6IKFUrtQeCYl3ItMtsdfz?=
 =?us-ascii?Q?JMZ9nqkNyWfdzwP5zds/24Vz4GnxJN6GyKSVvEenIuAVOdyQkpd6FpZg/Ae+?=
 =?us-ascii?Q?/dovcpY+JU6liRWmCOzzWPNXgB9vWAWDPZgHTzkXp8yEyths2zm7buZHzhZ8?=
 =?us-ascii?Q?LxJYlF/jxpUs5faaq3vcgyczqnv9VlQbOgpmg47i71mYmVL8P90IG/u4r1vz?=
 =?us-ascii?Q?ioxGAgc3VLWY9A0n0u2sdn95mRM+E1MjI1MFZ7btrODWo+zje7EOepdODxPE?=
 =?us-ascii?Q?M5cme/vmYV2uMAcs+acBwn8JUWvQa+ile4egoOQge3TONb0Uf4ZDQDcDcjQv?=
 =?us-ascii?Q?RKGdTA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf34227-1ae9-40e4-8e1b-08df3ffc8f8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 14:03:28.2132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6GJDubdMuSkjjvkTHiwmI1IHymT4S76jVqMmyRM8rFj1JZOwio33ilbD7jGWJPJ7cNnXg0axXRT5FqcbgjA0sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU6PR83MB0826

> On Tue, Nov 03, 2026 at 12:05:41PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s)
> to consider:
> > - [High] RDMA/mana_ib: NULL dma_parms in mana_ib_probe() on CDX
> > devices
> > --
> >
> > commit 4f88c8811c923b9c16d7e0dbf8674249f05b4f08
> > Author: Zhiyue Qiu <zhiyueqiu@microsoft.com>
> >
> > RDMA/mana_ib: Enable RDMA devices on the CDX bus
> >
> > This commit enables MANA RDMA on the CDX bus by depending on the
> > shared GDMA core, matching CDX auxiliary devices, mapping non-PCI
> > userspace doorbells with pgprot_device(), and reporting the Microsoft v=
endor
> ID directly.
> >
> > > diff --git a/drivers/infiniband/hw/mana/device.c
> > > b/drivers/infiniband/hw/mana/device.c
> > > index 62c7803ca6c60..33e47490755f6 100644
> > > --- a/drivers/infiniband/hw/mana/device.c
> > > +++ b/drivers/infiniband/hw/mana/device.c
> > > @@ -257,6 +257,8 @@ static void mana_ib_remove(struct
> > > auxiliary_device *adev)  static const struct auxiliary_device_id
> mana_id_table[] =3D {
> > >  	{ .name =3D "mana.rdma", },
> > >  	{ .name =3D "mana.eth", },
> > > +	{ .name =3D "mana_cdx.rdma", },
> > > +	{ .name =3D "mana_cdx.eth", },
> >
> > [Severity: High]
> > When mana_ib_probe() binds to mana_cdx.rdma or mana_cdx.eth, does
> > passing
> > gc->dev to ib_register_device() trigger a warning and fall back to a
> > gc->64 KiB
> > DMA segment size limit because gc->dev->dma_parms is NULL?
> >
> > In drivers/infiniband/hw/mana/device.c, mana_ib_probe() registers the
> > IB device with gc->dev as the dma_device:
> >
> > 	ret =3D ib_register_device(&dev->ib_dev, mana_ib_is_rnic(dev) ?
> "mana_%d" : "manae_%d",
> > 				 gc->dev);
> >
> > And in drivers/infiniband/core/device.c, ib_register_device() checks:
> >
> > 	WARN_ON(dma_device && !dma_device->dma_parms);
> > 	device->dma_device =3D dma_device;
> >
> > Unlike struct pci_dev, struct cdx_device does not attach a dma_parms
> > structure, which is noted in mana_cdx_setup_hwc_irqs() in
> > drivers/net/ethernet/microsoft/mana/gdma_cdx.c:
> >
> > 	/* The PCI path also calls dma_set_max_seg_size(), but that is
> > 	 * deliberately omitted here: the CDX core does not attach a
> > 	 * dma_parms to the device, so the helper would only WARN, and
> MANA
> > 	 * never builds scatter-gather lists, so the limit is never read.
> > 	 */
> >
> > In addition to triggering the warning in ib_register_device() on
> > probe,
> > mana_ib_create_queue() and mana_ib_reg_user_mr() build scatter-gather
> > lists via ib_umem_get_cq_buf_or_va() and ib_umem_get_va(), where
> > __ib_umem_get_va() calls ib_dma_max_seg_size() ->
> > dma_get_max_seg_size() and falls back to SZ_64K instead of UINT_MAX whe=
n
> dma_parms is NULL.
>=20
> The analysis looks correct to me. How was it tested?

Thanks for pointing it out. Yes, it was tested but manually with our RDMA t=
esting scripts.
The difference is that CDX is on a test lab machine that cannot be used in =
our existing
automated VM testing. So all the tests succeeded and the dmesg was not prop=
erly checked.

We added the check of the dmesg in the tests to not miss it next time.

Thanks for understanding

>=20
> Thanks

