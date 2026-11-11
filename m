Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.116
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794415574;
	b=KiPfWybdizDu1Behe43bm2m0x74vPGSFoR7LYHP9C/JWeFrKd7Pr6ZoW6ejhj+Vusea4
	 5VKSKWpUc2Pm5Q7RUeQMYkq3lEM8FWDyRYlOV21/yw+eRU15Xu4lSgYZlFR0hRHMJfucy
	 6uTqQlLTp/MNICwGp5Va97vEoxjSvtx3nxrzDSO/gUCAT+x1QOnwMI//uNgK6JsUuylxL
	 BIOpxe+IOPfLs7+80c24rguZqUEdJ0gPUX/r8ZSDtGfYlq8gYIFhaG6NPR/snv7Th9u4i
	 llP3v6C54L6DlVYmzsSZIhzNjE0RYtu+n5LJ1SwOs7S7/x07uKJORDRzhBwUXx4rkuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415574;
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
	bh=WIm+xev5S67Rr3fpeJSN371vx8wimKygIxx31hlMlFs=;
	b=LPkhIq8S0wcyZCPd3TCcrA0f6ge5xYQGGcKDVmNdYWsJjPRhwC/h/MRhEX7n7vSmAEHw
	 TdJc11u7P1RR7s1lgTxBTgOZdyYoy9R2GkIkQM2xyEQMX7CS9RO/GnAFxirWY80x0jT+4
	 9bxG7XOJZ2iST5SqAJk8elxkRrdtfhnnrIXfNwwyi0Zk/wOmzTUilJiUAj8+wsAj6C+Rs
	 Dh+5EyM+pv7fK67lj8iMBptMjiLWP61NsPqxri/2aD2JlZBjc2gchQN61xucDx+AOJX/f
	 XswlFKm/ph9plVSMiTvKCDKrcvyu2diFgfCL7ikCJrbPccuZ+pKL+uon+E2ZcLE2Htw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=hoFZFM35;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.65.116
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021116.outbound.protection.outlook.com [52.101.65.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0014C606A339
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:46:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0014C606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=hoFZFM35
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=einNmhWk95jtZyTRK9hTm48wUULEH7MJJWz9WibM7ib9UCMWdsTuQqr2FMnUrJU++8bTmkkNGcotLwYmXxEAIcpEjmfor7sJnDYNhKnfuYnlT1QGb1k8IuZcn4NY/dQnWesXwkyy+6cracFTTfOw+Q3CGKhyeO+3k0pFMCXqpEytYGNSO+OXBvhLR4WO9EzcrvJYJ00xz7zTjqt0UTs4egdBeH8IdTTRx45x7JNoZkc2E8Fwcm8p+OPS1JQnIcSNgWasUBDvf/mGLiXkvdyL1HmULuuw6QRKS4X4mPt/3b4NWofgHHdDWYvEopNT0+EMWkkWzLNfPmTQtHd+rPV89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIm+xev5S67Rr3fpeJSN371vx8wimKygIxx31hlMlFs=;
 b=r7AURUXQPxt490xmLSkPafL8KNZMsPOleZTuexytWwe371cwRVDFWTyyeIYbAEYhBKE7mCkP9LsWjuvvqtI3lkHVsYxgeQv5mTNruWcCw0Surp/QArTbKIAKYvSe8VvSi3cXsgQVq3UsmF0TC79/UU9dgDL+wXOYjYYnEYom/+cNkAl4UeamlJBkiaeV5seP63k+b9p1AUH04PavBYbQR0EfS3zljuMdmpTzxl0VTLI1KgJ+D6i4A/qfTRmuGNa8pXxjxpV1Pkzd6bqlBjbZyuSSwE+Nb7RBIkcdHZKuhJUkDu2IXZsbIiO/FlWIjm3hHAC/7aSCQZeaUy6ZC3zS+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIm+xev5S67Rr3fpeJSN371vx8wimKygIxx31hlMlFs=;
 b=hoFZFM356U8maC3iBSKczmOAc6/BpChyHWZoXjZDP68rkbwLL+ioqNYlI8ZMjBWJA/8wHXc1saYOhLZVWuEQPAKWCRGwyWrBsdVdLu2fF9xlzJvJAf18E9ZWJAuVvOAaSk9kUaZ+2LLPO3WfRqhV+JGIRAfOrc95wdGKNnMmN0w=
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 (2603:10a6:250:7c::20) by GV2PR83MB0835.EURPRD83.prod.outlook.com with HTTP
 via P2P; Wed, 11 Nov 2026 16:46:09 +0000
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102]) by MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102%5]) with mapi id 15.21.0639.000; Wed, 11 Nov 2026
 16:46:09 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	Konstantin Taranov <kotaranov@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v10 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Thread-Topic: [PATCH rdma-next v10 9/9] RDMA/mana_ib: Handle error CQEs for
 kernel QPs
Thread-Index: AQHdcfwnLGQhZiKBtkCSz7begmAIog==
Date: Wed, 11 Nov 2026 16:46:09 +0000
Message-ID:
 <MA8PR83MB4650023202AB5433A15948DF07B4712@MA8PR83MB465002.EURPRD83.prod.outlook.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-10-kotaranov@linux.microsoft.com>
 <sashiko-outbox-209110@kernel.org>
In-Reply-To: <sashiko-outbox-209110@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3f41b577-7b8e-453d-9598-0367d88da0ad;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-11T16:44:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: MA8PR83MB465002:EE_|GV2PR83MB0835:EE_
x-ms-publictraffictype: Email
client-request-id: da0c0f29-872d-49ea-8ce4-347f455175ec
request-id: 75f8e8ad-78de-4699-5ee0-08df40134983
x-ms-office365-filtering-correlation-id: 75f8e8ad-78de-4699-5ee0-08df40134983
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|10067099003|18002099003|22082099003|4133799003|7146999003|38070700021|261021135927099003|4143699003|56012099006|261028144727099003|261102123227099003|261009223027099003|261026130827099003|261021121427099003|261022115727099003|261022105027099003|11063799006|261026140227099003|261021133027099003|261026121527099003|261021123027099003|261026135527099003|261021130227099003|260925021311599003|261022075727099003|260925022911599003|260925021911599003|261022113327099003;
x-microsoft-antispam-message-info:
 yXlP6PhUoGyzYtEAVWmJ7mzd4vDLjAMDYnDiCvDxpjpm98Na8Ig7zUSgkXxsIUtz67OsyO9Ghdn15JpsRLbMcTsd0lnlTr50p9H9/3P2G4EyYy5lTrSfJNnLitaCNLQnbQDiY3k4hUo2BX+vBH3c/cFOJSduI4LIiBrwt36979U2ogUy3N55zxbfcyYJ4J8xQCb/IxrjsygPQIMbxH5kpP2q5FhwmvmUw81I89Fe4ouUN8eDUjsKFDFj/SMlDETkIL9AFUyc7yzfE9K69NnNOAFu4XjDsKR6boW+zY/veUVJnL8EtmOSF8/oaEalOUZ/iTXnccCSRBNfJfi3qcsDqIg8v2sr9mxW6RZgwvXXquQHS+SNfHX15HWMqgy++K+pQdmYVnjHA/xjw8vqtmNrDtgMiOSUaLipS8HdR05EOCdB7j1gVTJMYtjzcMBEMZG5CndUBpZObttPZvppo1ULhGijqdTLF79RNUDR/j1ARcMEeBE1cEvrRrKJag8OG7GtsqWFU8T7ewri4AJYGYhBknGFw6g00NgwJ7b/5hAU60US3tnpQDnpSpUbN5UqYknHLFpZWwExRkuqN8u4g7HNr1dRw7kKNpb947FJNY2y0z5k6mf4wF4A1sWHB4UvUvjQfSFNJryfTWKVN9YKBAa8LHp6K2xlGRugMFlpohslrdMNOrmOVpLUfvoI8Y4d5N3iyyE/t1uaLFUC6kbCCxbAQ87aPSl1POiuHN6Nk996CmU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(10067099003)(18002099003)(22082099003)(4133799003)(7146999003)(38070700021)(261021135927099003)(4143699003)(56012099006)(261028144727099003)(261102123227099003)(261009223027099003)(261026130827099003)(261021121427099003)(261022115727099003)(261022105027099003)(11063799006)(261026140227099003)(261021133027099003)(261026121527099003)(261021123027099003)(261026135527099003)(261021130227099003)(260925021311599003)(261022075727099003)(260925022911599003)(260925021911599003)(261022113327099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?w8iGYaVUOnMJ2sDy4PDGzPeetGhHT459tBcC/C4aY7TmAepirPCqOcMfHzAU?=
 =?us-ascii?Q?hBXzf4cZ2eBziW57Za9jxzvhcqZlnn6ZYivG9OLTLGkVRMFlFBqy+FWGRRo1?=
 =?us-ascii?Q?NMd/W4N9n2wt1n3g5ijkDvB8oln6rDvFMvwOvT2i5HYwOMfS5K/pVFw+5pSZ?=
 =?us-ascii?Q?JCy7lBr8/ky3wZBx9ESTrpY8L8sWb0Sbrcu3OU8jvWKS+b5e13DyCDzEDiqk?=
 =?us-ascii?Q?G856zefiMv/D4O9Viusg9uYPM2ryEPELr3KZJzavbnxeCY0QJH9PYvskEsWH?=
 =?us-ascii?Q?Ny8J06xxLEz+Gjjww7TEiWnrJWdKwoCBpg8kXU/Y3/TYKyy4bsigunna/Rxb?=
 =?us-ascii?Q?NixucTAc6vbFS/jjAqOck8v5sGNknklh87ZJHwyEfrcHmDqVlLUA295snp51?=
 =?us-ascii?Q?QM1rU90XL4M70XA9wttlUL4d+f5Nya0LuV2vVwuKA0k4TzLn6yoIv4m04oEI?=
 =?us-ascii?Q?KTJWN36oxVsJ7FSiY9RqYRdqXZ9S484b2gbcr4qJVQeBwjR07d/My5wrEmH2?=
 =?us-ascii?Q?BBZ2NVQIdBqnzU8nx7YHc5SGbxA6gsM+iLDEEIWJRCf6LfaL08pKesPsV3+U?=
 =?us-ascii?Q?uquJBkVkkhVd9Cr3X97x9gA9WKKKHnii8TIVvc9nYckdEXJDn8ZlALzIMfI0?=
 =?us-ascii?Q?SXzKRYCoL7aucWCI9ZEQX7DE0UYfYXaO5mGq06vlMptnQXe9tFgjUQREbb3e?=
 =?us-ascii?Q?sQ4WyDhgdk6h3eCR9WW5xGf2BgqfTz9uyVgRSU0KEl6kvLWDhveJ01dO8/fE?=
 =?us-ascii?Q?z3Yh7Dsrk27LpORFJIO2ZhEolWQn997b5XOixlFuWNYhutvmXPD/WDDq9Syp?=
 =?us-ascii?Q?ncmZemcdZZpaAiOD5Ktgh8gGhemKjVqHYMw5N8EyIVEQSoPH1kZ1cScnyJ5p?=
 =?us-ascii?Q?HRLPb6HdAA9J2PV4s4WXZmnliZ17igfvN86o4PK7vUFm1ZX8ekKNmyQHx9p8?=
 =?us-ascii?Q?oRRzujajh8K/YlGZ35fywQAIdl046XVa+H/2rf6CAgEcCu5WQab601I7Wsaz?=
 =?us-ascii?Q?aONFU6MKAHbkdE/Xj7Vr7O5zcQWrkJGiB1L8v9NP2JFpqFcJssvFL8p2HJGe?=
 =?us-ascii?Q?GHijEuXw9Gh19Fq/NtBeaUJHIKy9ZWzqkSYmyShfbSAtqaX9G0uwj8/b8kAz?=
 =?us-ascii?Q?J83xesRWGPuJ6953TJRSgzkiuIyvHx+OEAEeqqgum+3yWupJ2H0mt1S5KGiX?=
 =?us-ascii?Q?R03Ai99r6L0uRXiYYUCOlISKdOev5+OInqtgBswdPwyPWCCASHTGQdOh2dX6?=
 =?us-ascii?Q?dTLKgAqlF9yeTt5o3wQoez6xV2a1uGYW3GDypzMe5XHkUO0vO7MmP1EEDG1e?=
 =?us-ascii?Q?WyBIuSQ/08YaWJA00ukI76ZPMQdyELPswgBO5RT8z2PIlOLWqNgz2xnc3Tee?=
 =?us-ascii?Q?RW6pJLiin+RaFH10OKLJuSvvMqqubnK1aEOz69QnBuB+O6Ubssx3YLTjdR0b?=
 =?us-ascii?Q?vCnhWWTydGUfABZzWar6wqgUDMH3+PNXe3zDj5RrxJDYJNkpG9qvicQSa/iN?=
 =?us-ascii?Q?arpBaGhndQhYbK80lTVXIgqn0gvt/pVbBc+pThoXlv7JlFho78LGd+zYRBxz?=
 =?us-ascii?Q?szDsUd25VIM1MqLVoMwbhO53B5NLtWOE9cnu3EsX1eKWKJpcyZC3+MuQofh7?=
 =?us-ascii?Q?wuUEdfjhILFxfRqmeM7JWtPt4MChec/WmUja/g6VJFGDWLtrmBNijEH2dWmb?=
 =?us-ascii?Q?0Y7leQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f8e8ad-78de-4699-5ee0-08df40134983
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 16:46:09.1307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqLK6cO2V0CyEatPB81vTcycGM/xVYM2TynIsbCuSvndpr7UTA6th0m9kyYgIbsEh8JFRhmiBRTtn2QcvO6A+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR83MB0835

>=20
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e to
> consider:
> - [Medium] RDMA/mana_ib: race in mana_remove_qp_from_cqs() when
> send_cq
>   =3D=3D recv_cq
> --
>=20
> commit a21cd9814010904d171e9602dc8b61668d553074
> Author: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> RDMA/mana_ib: Handle error CQEs for kernel QPs
>=20
> This commit decodes hardware error CQEs on kernel QPs, defers moving fail=
ing
> QPs to the ERR state via a work item, and cleans pending CQEs on QP reset=
.
>=20
> > diff --git a/drivers/infiniband/hw/mana/qp.c
> > b/drivers/infiniband/hw/mana/qp.c index c021e58817628..837e5c46ed778
> > 100644
> > --- a/drivers/infiniband/hw/mana/qp.c
> > +++ b/drivers/infiniband/hw/mana/qp.c
> [ ... ]
> > @@ -774,15 +777,19 @@ static void mana_remove_qp_from_cqs(struct
> mana_ib_qp *qp, bool reset)
> >  	list_del_init(&qp->send_err_node);
> >  	/* Keep shadow reset serialized with hardware polling and SW flushing=
.
> */
> >  	if (reset) {
> > +		mana_ib_cq_clean(send_cq, qp);
> >  		reset_shadow_queue(&qp->shadow_sq);
> >  		reset_shadow_queue(&qp->shadow_mmq);
> >  	}
> >  	spin_unlock_irqrestore(&send_cq->cq_lock, flags);
> >
> >  	spin_lock_irqsave(&recv_cq->cq_lock, flags);
> >  	list_del_init(&qp->recv_err_node);
> > -	if (reset)
> > +	if (reset) {
> > +		if (recv_cq !=3D send_cq)
> > +			mana_ib_cq_clean(recv_cq, qp);
> >  		reset_shadow_queue(&qp->shadow_rq);
> > +	}
> >  	spin_unlock_irqrestore(&recv_cq->cq_lock, flags);  }
>=20
> [Severity: Medium]
> When send_cq =3D=3D recv_cq, can a concurrent mana_ib_poll_cq() between t=
hese
> two critical sections flush receive shadow WQEs whose hardware CQEs were
> already invalidated?

I agree that there was a gap in locking, and mana should not unlock if it i=
s the same CQ.
Will be fixed in v11.

Konstantin

>=20
> mana_ib_cq_clean() checks mana_ib_cqe_matches_qp() using cqe_info.is_sq, =
so
> the first call invalidates both SQ and RQ CQEs for qp in the shared CQ.
> Dropping cq_lock before unlinking qp->recv_err_node and resetting
> qp->shadow_rq opens a window for mana_ib_poll_cq():
>=20
> CPU0                                CPU1
> mana_remove_qp_from_cqs(qp, true)
>   spin_lock(&cq->cq_lock)
>   list_del_init(&qp->send_err_node)
>   mana_ib_cq_clean(cq, qp)
>     /* invalidates SQ and RQ CQEs */
>   reset_shadow_queue(&qp->shadow_sq)
>   reset_shadow_queue(&qp->shadow_mmq)
>   spin_unlock(&cq->cq_lock)
>                                     mana_ib_poll_cq()
>                                       spin_lock(&cq->cq_lock)
>                                       mana_poll_cqe()
>                                         /* skips invalidated RQ CQEs */
>                                       mana_flush_completions()
>                                         /* flushes qp->shadow_rq as
>                                          * IB_WC_WR_FLUSH_ERR */
>                                       spin_unlock(&cq->cq_lock)
>   spin_lock(&cq->cq_lock)
>   list_del_init(&qp->recv_err_node)
>   reset_shadow_queue(&qp->shadow_rq)
>   spin_unlock(&cq->cq_lock)
>=20
> If recv_cq =3D=3D send_cq, unlinking qp->recv_err_node and resetting
> qp->shadow_rq inside the first critical section (and skipping the second
> lock acquisition) would keep the CQ clean and shadow queue resets atomic.
>=20
> --
> Sashiko AI review *
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsashi=
ko.
> dev%2F%23%2Fpatchset%2F20261111121417.1265896-1-
> kotaranov%40linux.microsoft.com%3Fpart%3D9&data=3D05%7C02%7Ckotaranov
> %40microsoft.com%7C9f8f9f58c72044d9648008df3ffb3264%7C72f988bf86f14
> 1af91ab2d7cd011db47%7C1%7C0%7C639300020333767886%7CUnknown%7
> CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXa
> W4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3D6Bv2Lz
> %2BUboL2%2BXC6uYBH2i7y%2BJ7%2Fo1SKjfHC5RuOp%2BU%3D&reserved=3D0

