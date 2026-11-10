Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.104
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794336955;
	b=M0kaoSpyxoLuEXrI1s6MXW6Ztaldg9Wi0V3F/lcDrPak+oKQmbiUhX99Jd6GSu+A7iVn
	 7o9dmy7+KhHNxisBfcvDZtwucTlgjPEqss5SwmY5nPlDAqxeQswClJOBYqbNlUVoNPSsd
	 SCiPjQRUqrKJbFOT/ZVCH5zDIcsN0O/HJvt3FUga3U98LLr4V6sKZzqFJskC/8b9REiWp
	 iS355yXItjuGsY1Z8iQZ0pS7HKExxbMLi0cL6b+XqCL34Rs0XJGZLpJRhIrfpIkA3xukX
	 SiDom36X2rgVIZEs9oekxCp/SiWCtklNeUtYsOFqV+bmIsfeWyfUwppNT6CEuMqZjTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794336955;
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
	bh=daMOFw+sPERhjtovlGH+0mp6nNFPc5RD2JGgOfPmUhE=;
	b=DFp4w5HcmAbEfCZNAWgU/MONR1/V2gn9/qwFMJ/MNXboGIkBIA9wWjy9SQP1mQm8Jgnn
	 o1zOHInPluTFZGOHvOFQFhqd501w81yGxsL7XGMgrT5M++eUXpAEofoA2mcEL/njRFzJt
	 pKcWpUrRebdMYU+p3vi2WXfSMjU+xHzNqvb5loeOx5YjGYFa4qa0Hppel3pd8bPa3tzfC
	 Nu0fRe+3XZ4wD/iCknzro3kWogHE1ETybKU9RQY2IHHjIpssr3/nWm9rHJA5BlrI6LB6y
	 m2KUghrIiIwjYjPa9YmcF1fb5WWSy+hjmC4xg0/C3RdT6NlK7Gpnho+Kjr+L2hV7f9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=LlhswCiy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.104
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023104.outbound.protection.outlook.com [40.107.159.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA9360A2628;
	Tue, 10 Nov 2026 18:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FA9360A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=LlhswCiy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AZfhWhd3RuZ0Bg9zx5gLnYoCoFrrM1tTcV3jKG84JXDHfZMSR+7YIE1LXSaKpm+X53tcZCDUtWTN01pXqSahUxS9DtwqOA0leuUjQ8lLNoRgGyuTSoGkhseeQ/b6mWxCFsnE1PToI9cr8pNJocLjiSo+b5JerpEHS0yotO3nslpTpHKSUBb1Dv5+U4wZqh+EJSy4Es+FereXR93BVQZRZgNHymHQ6/e8/ByhVmsIZ3A9Qeubvdo9rVhwaJYrAlTn8m1U8el2D9JHBvTsF9VfUZRFir2gDjL/DIn2NC5JqbPgEcQxn79jn2T2hHfyYVLc9fto9p4Uxix+c5tDIxKghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daMOFw+sPERhjtovlGH+0mp6nNFPc5RD2JGgOfPmUhE=;
 b=Uea9aBTQM7ld03TsCGrFmTVqMTIx8YcYRE75XXQZPZZ4ztbKscidDe98oNCZ5OHuboDKJbbYecmIk4OO8PhX9x6NePaIRt9JV0ONGZByi4pb1tB1DO0N4xbZ6Lin5A3MlA0teF4TaKdbhT6Fe3JDO8ASjUMxdsCFFvVxRwkIriBZpThAKeeX0VdxIf5mz2EkUNMcOotPMI1095yRdb14fKtQ1M3Jq6pA9okdituoeECcnGoUMkDAAq9UkU48Ka1VkrN141F1Z6fu/HGZCSkrb//wMaTSDeO31gE+5z8DnkHCT24zH8IBF9qZ/4b1rDYuwsHzgW3BFhqY8wxTymOHAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daMOFw+sPERhjtovlGH+0mp6nNFPc5RD2JGgOfPmUhE=;
 b=LlhswCiydTO4wGguTjqw0+Rilj2lR+nhhzDa7DpkgmD1ohzrtEM/evZUD3GxLJhOBh8SwwxAtR/gcWoiUSkjKXUfUnUOrtFDqR38YzdYCCPVxyLY+YTq2FCB5i8EpPFwtwmcORYKx1SqtfHuixSOhI9q/jDv4R059TtPU6UhDLo=
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 (2603:10a6:250:7c::20) by GV1PR83MB0753.EURPRD83.prod.outlook.com with HTTP
 via P2P; Tue, 10 Nov 2026 18:55:49 +0000
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102]) by MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102%5]) with mapi id 15.21.0639.000; Tue, 10 Nov 2026
 18:55:49 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: Leon Romanovsky <leon@kernel.org>, Konstantin Taranov
	<kotaranov@linux.microsoft.com>
CC: Snehal Sanghvi <snsanghvi@microsoft.com>, "longli@microsoft.com"
	<longli@microsoft.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rdma-next v9 2/9] RDMA/mana: Create and destroy kernel RC
 QPs
Thread-Topic: [PATCH rdma-next v9 2/9] RDMA/mana: Create and destroy kernel RC
 QPs
Thread-Index: AQHdcUUa3o74yQcgyUSr8N0dPY7KeA==
Date: Tue, 10 Nov 2026 18:55:49 +0000
Message-ID:
 <MA8PR83MB46500225F6F556D2D6D930B45CB4722@MA8PR83MB465002.EURPRD83.prod.outlook.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-3-kotaranov@linux.microsoft.com>
 <20261110154117.GN8635@unreal>
In-Reply-To: <20261110154117.GN8635@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=37836565-49fc-43bf-8548-6386ac7c1102;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-10T18:42:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: MA8PR83MB465002:EE_|GV1PR83MB0753:EE_
x-ms-publictraffictype: Email
client-request-id: 1bd144e3-a396-4fe8-bcea-d536ae7b13d2
request-id: 660694d3-7643-44bb-79d5-08df3f5c3cab
x-ms-office365-filtering-correlation-id: 660694d3-7643-44bb-79d5-08df3f5c3cab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|22082099003|18002099003|7146999003|10067099003|38070700021|4143699003|261028144727099003|261021135927099003|11063799006|261021121427099003|261021123027099003|261022075727099003|261009223027099003|261102123227099003|261022105027099003|261026121527099003|56012099006|261026140227099003;
x-microsoft-antispam-message-info:
 SQCgqgmh8Fc3sa9at2ZVCGTzNsIrBRtbMda/ryAPx0bIQKxtiodemN37R1sTYlAwqTAOrUzfsHmZO8Mmo2iiZoU22nNWaSgA8siYHi7JF+FYOPPG/JhqP2Q462niybE2plo4emIIexHcbVRDLYbRNVOniRGy+5EKkOJtY7wJl8/f1hTB2UjMaCSy1a+zjcvrwOmhl9eKtKjTqGWpJkuKXidsykaxQ7jt3PHjUIy1BWgCbJo+uSoJffgpOORsSjElEXiiP2Jb1V2OtNSdQH8vn7TlrhreZVI63kpB0M2+9iDYyNagpDIG3gIVTD4G64RqhYvuPy9M9HcFMYUvSZZDddw4nb61qkbSm1ZdzllLOv6moKeVWl7OcQjdv154lNRURZkeHmTLY77D91zDv6SaNOd8D6QfsFnGGaaUfM4VQi/CPdWZ2GkCIssXEml1lC9StLUFJ4vJupNPiaHew7f/mlmFPB20oK06V24oCoW8cGYrcld+EzmyaS9+EW6oPMLLM9qUcH8j0UQpc4vS2W2ZQcTzHm18q9g1eXNDSJ1Eh9ZkA+eZKPKJBBZKkaAy0V1o8Df3KY3c0sNpxHA++vvaPgbkRz6DK4JISPK2+6G865qBSA5YW3iSeVfeyvgigw6RSTqRPaMY0ENyx4oya3HdAL8doFX9iAFV5QJ+kK9xxxl0lceoW8ythk9Cme/xDttWKxq9J9GTtua7jNqI+tO2YIDtP9iXl01TUwD4tx6MYBM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(7146999003)(10067099003)(38070700021)(4143699003)(261028144727099003)(261021135927099003)(11063799006)(261021121427099003)(261021123027099003)(261022075727099003)(261009223027099003)(261102123227099003)(261022105027099003)(261026121527099003)(56012099006)(261026140227099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?PlVyXJntJjwzFjIYZ7lzvuu32DEunrZvUZzlEIWn4STkbNauHIjgPzZNCwsG?=
 =?us-ascii?Q?J1B05GeZMnUqdkebpUQOyOE8yxwgQy40THhdmK2JLWXfFOP0kLoXCcPDrma7?=
 =?us-ascii?Q?LjA4nCqb7Gc9YUkhYjc6ahxQ0RnLFWL3vL/agZcIldiF3mW0c12qpwV2i0ML?=
 =?us-ascii?Q?wHvE28ISVb6pEl+5N27d7UyBLK+LvaCdA79+Xn5tX7LiNVIPFWQTWOYT30kg?=
 =?us-ascii?Q?Dhxkb9AQA/LjNvwNSBMHGNm3jQ4pdmF5KhGqtl49rlg8jg5Cl1+EpzzJITdi?=
 =?us-ascii?Q?/y2DkQG8mp1sMxNXf4TeFGGBMdVpDgHsWSa2mPsGLUwxzO1x+HuNEeEgdvU6?=
 =?us-ascii?Q?APbtAzQ8jPFHTY633dyfZKvyNUPngNRag4VRE28s8Nwve3FWxDmP9oT1YUVb?=
 =?us-ascii?Q?LT1CAg2z/Q4eakBTpDrnpXB5FedVAZ6ZJzKmbD0L9AWV/irkz1ZZCOtp/klK?=
 =?us-ascii?Q?O3nAM723kVbj52LALcCtf6veQXDzah/7TNcGrL9zGO/aRU+VaJu0VzWsMpIa?=
 =?us-ascii?Q?aBzj/SvxjaMgFbDDIAxq6qNmTCL2gXaOXXcbCoDi8NzPoF85PgVW1/4D/by1?=
 =?us-ascii?Q?oGi5cfRe/a8QgB56TuRRNXh4+PmHpDCv+ysnfDYBpsN1igf3gAV5EiLnDBg1?=
 =?us-ascii?Q?ptpnYks39rWu/occcASJwgANgNeK0fVItBnh/4/nrDLClbOjLu4nQEw90dwU?=
 =?us-ascii?Q?NzXsHYT8+k7P5WnCxyKYo4cpv73uwkXFX6VplBvAS8xMQthx/8UoSzbWPvQ3?=
 =?us-ascii?Q?VGdFcNCQGhPBxXa4YfYLszaoFE8C7HdgKRqxzO+odPrP+/Ni41vK2QODt+vN?=
 =?us-ascii?Q?ri0xkUX1U2GJIvoSP/o7/l5lcEYWTF+u+KN8bcyMBiMzhABNNts1cCnVQnsa?=
 =?us-ascii?Q?z49lKkNKC0PewH43FU4Vg3z7ypO0TKb6hAL3sIJHdnjw1kXbEDjKtJG4Jw7t?=
 =?us-ascii?Q?WoVtJ0HHJaH6krDg4BLS907jAE1fauD7oFj9uhXqdxjWyRkWefOvSyg/Zria?=
 =?us-ascii?Q?an2Hq6UD9bkKW7m9LOzkLCKIYK8ADf0tkSOUwjDHmhwf3XpUdkgpYJzIA0OX?=
 =?us-ascii?Q?xVo3vahKYVsTkkn66TdEIHic9BXBa3Jy+L65QD6uPDs/Jo7d+thw1dmopaYb?=
 =?us-ascii?Q?ysrJAUGxJ45ZkoTP3iKEQ6uxHpY8im3C8M4453V1HlpD3KhpKoNZNYq7eAiM?=
 =?us-ascii?Q?yJP0FcXb+i00ZRGK+FSSR+e+joG7kcLxCYHb4VJL53NLflQ7IaPSTM0HvsGQ?=
 =?us-ascii?Q?8b4rnolOX+bwjrcfCM7mkVAArlak5BP32o0CRb6FAn56xCwvypH6/CNzv0mH?=
 =?us-ascii?Q?/jsgOmADBdr1eOZQE3Hx5Ss366dvs79coYZbF5ymZtEVF3VrIf+ifQvxAte7?=
 =?us-ascii?Q?lTezTrf5HLCAVFFJaDM3dCMOqfJSSjL5jLb7Nf49r6ntqNec3UKgmS6yfWtV?=
 =?us-ascii?Q?4NZxtB3xzhYzD6xxrHK5JYkfgtElTVuL8kw/NKUF2xzeJVvPNDocbIyzccjT?=
 =?us-ascii?Q?gYSacT87plvGDMYW1x6Qv0pma0eAOOdhrsPveXRVul1SLkiy79aN7rx7vhr4?=
 =?us-ascii?Q?4fkEobfhd7LbdpDxqQX1Eydk+1fpJN4VJufCPVRcOnhjnV9R/brnjSCTaxIE?=
 =?us-ascii?Q?WMP8eWoIz9mpUgFKQKd/+eHUXyfOWr0pakJ5C9HxRClnzwwItqooutt3/EkT?=
 =?us-ascii?Q?UcAWjQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 660694d3-7643-44bb-79d5-08df3f5c3cab
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2026 18:55:49.7145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I4v2LJTWxZUWZVTrYzASLUs8HED0FeCmw99Rj4qWvsgx/TuljVEJ6bkWijKLPGfKj4YmdEiiVEpu+cEAwdsAeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR83MB0753

> On Thu, Nov 05, 2026 at 09:59:21AM -0800, Konstantin Taranov wrote:
> > From: Konstantin Taranov <kotaranov@microsoft.com>
> >
> > Implement kernel RC QP creation and destruction. This feature requires
> > extended-WQE and power-of-two-SQ support from the HW.
> >
> > Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
> > ---
> > v5:
> > - Validate kernel QP queue sizes before allocating queues.
> > - Bound SGE counts and enforce the TX/RX WQE size limits.
> > v4:
> > - Reject RNIC firmware send-SGE counts below 2.
> > - Subtract the reserved SGE for extra-large OOB only for RNIC mana_ib.
> >
> >  drivers/infiniband/hw/mana/main.c    |  10 +-
> >  drivers/infiniband/hw/mana/mana_ib.h |   6 +
> >  drivers/infiniband/hw/mana/qp.c      | 206 +++++++++++++++++++++++++--
> >  3 files changed, 211 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mana/main.c
> b/drivers/infiniband/hw/mana/main.c
> > index ceb4ec58023a..f54905764f59 100644
> > --- a/drivers/infiniband/hw/mana/main.c
> > +++ b/drivers/infiniband/hw/mana/main.c
> > @@ -733,6 +733,13 @@ int mana_ib_gd_query_adapter_caps(struct
> mana_ib_dev *dev)
> >  	if (err)
> >  		return err;
> >
> > +	/* Hardware supports at least one data SGE plus one reserved for extr=
a-
> large OOB. */
> > +	if (resp.max_send_sge_count < 2) {
> > +		ibdev_err(&dev->ib_dev, "Invalid max_send_sge_count %u,
> expected at least 2\n",
> > +			  resp.max_send_sge_count);
> > +		return -EINVAL;
> > +	}
>=20
> This check does not make sense here. If this firmware is present, continu=
e to
> support it; do not fail just because the kernel has been upgraded. If it =
is
> not present, why check for it?

It was Sashiko comment at some point that I should add this protection as
a faulty HW could respond with sge cap to be 0 or 1. I can remove this chec=
k as=20
it is useless, but it is true that a faulty HW could return 0 or 1 and it m=
ay result
in a bug. I am happy to remove, but I also think that AI had a point.

Leon, should I remote it?

>=20
> > +
> >  	caps->max_sq_id =3D resp.max_sq_id;
> >  	caps->max_rq_id =3D resp.max_rq_id;
> >  	caps->max_cq_id =3D resp.max_cq_id;
> > @@ -748,7 +755,8 @@ int mana_ib_gd_query_adapter_caps(struct
> mana_ib_dev *dev)
> >  				resp.max_requester_sq_size /
> GDMA_MAX_SQE_SIZE,
> >  				resp.max_requester_rq_size /
> GDMA_MAX_RQE_SIZE);
> >  	caps->max_inline_data_size =3D resp.max_inline_data_size;
> > -	caps->max_send_sge_count =3D resp.max_send_sge_count;
> > +	/* Account for the SGE reserved for extra-large OOB. */
> > +	caps->max_send_sge_count =3D resp.max_send_sge_count - 1;
> >  	caps->max_recv_sge_count =3D resp.max_recv_sge_count;
> >  	caps->feature_flags =3D resp.feature_flags;
> >
> > diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> > index 5ca6e2acf974..6f5df64e838a 100644
> > --- a/drivers/infiniband/hw/mana/mana_ib.h
> > +++ b/drivers/infiniband/hw/mana/mana_ib.h
> > @@ -267,6 +267,10 @@ struct mana_ib_qp {
> >  	u32 sq_psn;
> >  	bool sq_sig_all;
> >
> > +	/* Serializes receive WR posting. */
> > +	spinlock_t rq_lock;
> > +	/* Serializes send and memory-management WR posting. */
> > +	spinlock_t sq_lock;
> >  	/* Serializes QP modification and error-list transitions. */
> >  	struct mutex modify_lock;
> >
> > @@ -274,6 +278,7 @@ struct mana_ib_qp {
> >  	struct list_head recv_err_node;
> >  	struct shadow_queue shadow_rq;
> >  	struct shadow_queue shadow_sq;
> > +	struct shadow_queue shadow_mmq;
> >
> >  	refcount_t		refcount;
> >  	struct completion	free;
> > @@ -315,6 +320,7 @@ enum mana_ib_adapter_features {
> >  	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT =3D BIT(5),
> >  	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT =3D BIT(6),
> >  	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT =3D BIT(7),
> > +	MANA_IB_FEATURE_EXTENDED_WQE_FORMAT =3D BIT(9),
> >  	MANA_IB_FEATURE_RC_QP_SQ_POW2_SUPPORT =3D BIT(14),
> >  	MANA_IB_FEATURE_MULTI_PORT_GSI_SUPPORT =3D BIT(15),
> >  };
> > diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c
> > index ae2ebbcc759a..387586c45aa0 100644
> > --- a/drivers/infiniband/hw/mana/qp.c
> > +++ b/drivers/infiniband/hw/mana/qp.c
> > @@ -427,27 +427,88 @@ static u32 mana_ib_fixed_wqe_size(u32 sge, u32
> oob_size)
> >  	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
> >  }
> >
> > -static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_=
type)
> > +static u32 mana_ib_queue_size(struct mana_ib_dev *mdev, struct
> ib_qp_init_attr *attr,
> > +			      u32 queue_type)
> >  {
> > -	u32 queue_size;
> > +	u32 send_wr =3D max(attr->cap.max_send_wr, 1U);
> > +	u32 recv_wr =3D max(attr->cap.max_recv_wr, 1U);
> > +	u32 max_wqe_size =3D MAX_TX_WQE_SIZE;
> > +	u32 wr, wqe_size, read_sge;
> > +	u64 queue_size;
> > +
> > +	if (attr->cap.max_send_sge > MAX_TX_WQE_SIZE / sizeof(struct
> gdma_sge) ||
> > +	    attr->cap.max_recv_sge > MAX_RX_WQE_SIZE / sizeof(struct
> gdma_sge))
> > +		return 0;
> >
> >  	switch (attr->qp_type) {
> >  	case IB_QPT_UD:
> >  	case IB_QPT_GSI:
> > -		if (queue_type =3D=3D MANA_UD_SEND_QUEUE)
> > -			queue_size =3D attr->cap.max_send_wr *
> > -				mana_ib_wqe_size(attr->cap.max_send_sge,
> INLINE_OOB_LARGE_SIZE);
> > -		else
> > -			queue_size =3D attr->cap.max_recv_wr *
> > -				mana_ib_wqe_size(attr->cap.max_recv_sge,
> INLINE_OOB_SMALL_SIZE);
> > +		if (queue_type =3D=3D MANA_UD_SEND_QUEUE) {
> > +			wr =3D send_wr;
> > +			wqe_size =3D mana_ib_wqe_size(attr-
> >cap.max_send_sge, INLINE_OOB_LARGE_SIZE);
> > +		} else {
> > +			wr =3D recv_wr;
> > +			max_wqe_size =3D MAX_RX_WQE_SIZE;
> > +			wqe_size =3D mana_ib_wqe_size(attr->cap.max_recv_sge,
> INLINE_OOB_SMALL_SIZE);
> > +		}
> > +		break;
> > +	case IB_QPT_RC:
> > +		switch (queue_type) {
> > +		case MANA_RC_SEND_QUEUE_REQUESTER:
> > +			wr =3D send_wr;
> > +			wqe_size =3D mana_ib_fixed_wqe_size(attr-
> >cap.max_send_sge,
> > +
> INLINE_OOB_EXTRA_LARGE_SIZE);
> > +			break;
> > +		case MANA_RC_SEND_QUEUE_MMQ:
> > +			wr =3D send_wr;
> > +			wqe_size =3D mana_ib_wqe_size(1U,
> INLINE_OOB_EXTRA_LARGE_SIZE);
> > +			break;
> > +		case MANA_RC_SEND_QUEUE_RESPONDER:
> > +			return MANA_PAGE_SIZE;
> > +		case MANA_RC_RECV_QUEUE_REQUESTER:
> > +			wr =3D send_wr;
> > +			max_wqe_size =3D MAX_RX_WQE_SIZE;
> > +			read_sge =3D min(attr->cap.max_send_sge, mdev-
> >ib_dev.attrs.max_sge_rd);
> > +			wqe_size =3D mana_ib_wqe_size(read_sge,
> INLINE_OOB_SMALL_SIZE);
> > +			break;
> > +		case MANA_RC_RECV_QUEUE_RESPONDER:
> > +			wr =3D recv_wr;
> > +			max_wqe_size =3D MAX_RX_WQE_SIZE;
> > +			wqe_size =3D mana_ib_wqe_size(attr->cap.max_recv_sge,
> INLINE_OOB_SMALL_SIZE);
> > +			break;
> > +		default:
> > +			return 0;
> > +		}
> >  		break;
> >  	default:
> >  		return 0;
> >  	}
> >
> > +	if (!wqe_size || wqe_size > max_wqe_size)
> > +		return 0;
> > +
> > +	queue_size =3D (u64)wr * wqe_size;
> > +	if (queue_size > U32_MAX / 2 + 1)
> > +		return 0;
> > +
> >  	return MANA_PAGE_ALIGN(roundup_pow_of_two(queue_size));
> >  }
> >
> > +static int mana_ib_check_kernel_qp_sizes(struct mana_ib_dev *mdev,
> > +					 struct ib_qp_init_attr *attr, u32
> num_queues)
> > +{
> > +	u32 i;
> > +
> > +	for (i =3D 0; i < num_queues; i++) {
> > +		if (!mana_ib_queue_size(mdev, attr, i)) {
> > +			ibdev_dbg(&mdev->ib_dev, "Invalid kernel QP queue
> %u size\n", i);
>=20
> If your code needs to validate in-kernel users, something is fundamentall=
y
> wrong
> with your design. We trust them.

It was Sashiko comment at some point. I also agree that it is partially red=
undant, but it also
helps to detect u32 overflow. I think we should keep as we had a similar co=
mment
for CQ u32 overflow, and Sashiko rated it as High. I think better safe than=
 sorry

>=20
> Thanks
