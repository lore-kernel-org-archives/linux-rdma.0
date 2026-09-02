Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022116.outbound.protection.outlook.com [40.93.195.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CC83750BD;
	Wed,  2 Sep 2026 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370952; cv=fail; b=goeFv9JuT4N9geR0xD35jvmWQCAhnvwE9IkQLwbftUFDZmh5D93MsFiZyogRu9ppssGAwvdJCUbs3NxKqrSlCfC2Xu4YKSUpySOh3j8JwPPQ7Nv+ZEdKxCDUMEJrTMljFU7jB8506zGDN/4Bbv2eX9fVoRItnt/HfWZc029dwNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370952; c=relaxed/simple;
	bh=uhc4ZbP1hDzob3mhFnckvm1I62RfL6ijRIrAzFjOkXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UERGqJ6k259DiWdPJ6gYkGXu7ObxQ6ykJoJKq3F3Z9/B7NZQA3McC2bDsgjkM7WLoEy5caEsDzxNsiqWdOkbHJMaHsBhNDlee8ugnI0o4/YEkK3qsAkdWKefg1ysD725kSjBvLRiNJjhSVxDqK+FvB/i/Dm86DYJTJjXNf4e8tQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=MFDbqGyu; arc=fail smtp.client-ip=40.93.195.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="MFDbqGyu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X8LuVR8g+PKSaXYtBerGsHH5ECl9bmXfcn7hEzkL4fwzz7UAxqT0GZ6nw6mcQV/Q83yRf4uHbGovb652Ux5oCBcM+e4opMo9eMgxvWcvrYJ/g6MFUp2oYE8l3L75Yxkb0ZI5wsGiZCfYcJT4ebHvMV2ONH9loAvQZ80Pw5aR8PxqpADHc3fDuciCyrvCsBl8i0tletmSRA+8BM4QgO9VyajEM4oWrnIjY+DmvpSWJvVnZXmegO8Q2JZlfL22G1aC1hkSg2DldzPbFX933ym2LEN3K9GRhr+TiQ3W1ctq8jiSiEO+YMNNUeKix3BTc/h0yyHvR5TBuwdagBzRESDtcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6S3TTX33hgVVXgDGZKWYLwIZEuIpiP+IgNwInvGzM2Q=;
 b=c4GVebkemZPvzxwVcU5oWghCD2FyZEJ1lkwNNo6bcNkXYK7+GjT3y5zzXiizE+sfOJT4uz3BwmFiWhkSLKLZowTBAx2s/kQP90c5J3ZUiPzulfezegYQP/tvSVyKlyeoDnDYdb6FtxIONCZ5DIhoOSDEn9XN6wqo5ESgTnsPkGa4muxs9Bkxc0HVqiMglEGXGWqaykCkIJHftoApExb24T8/T6uHouLRO0ORykFRZyA+04iRk7UIxxz+tAxu3rja6YKQLK4bcqGYaTRvaR+y76yDzZudPmTXSgwgGaZQgsbsohcrJx/C4CYSGpbF3utIh6XnTr8mb7iamMyvrbxMjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S3TTX33hgVVXgDGZKWYLwIZEuIpiP+IgNwInvGzM2Q=;
 b=MFDbqGyubML7UxUU7yM1cPmKeyC1/9Ijf5FomknxEbfdZISbBeLD9+KLOwbeISjdWEAusEJPMT13zIVT8U9pLNTsz3yHsdkqGoFBX81i7XLh76OpauFlx+A8IRzMPiZt8/sAtruy94bRkzO1pR6hyMIDKZkQck3/85gBc7V9HJw=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA3PR21MB5677.namprd21.prod.outlook.com (2603:10b6:806:49a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.1; Wed, 2 Sep 2026
 17:42:24 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Wed, 2 Sep 2026
 17:42:24 +0000
From: Long Li <longli@microsoft.com>
To: Simon Horman <horms@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang
 Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"shirazsaleem@microsoft.com" <shirazsaleem@microsoft.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v2] net: mana: Clear RDMA teardown and
 suspend state in mana_rdma_probe()
Thread-Topic: [EXTERNAL] Re: [PATCH net v2] net: mana: Clear RDMA teardown and
 suspend state in mana_rdma_probe()
Thread-Index: AQHdNoHyJHxYt4xOt0q521Qs+wjjDLa7h7UAgAAMHwA=
Date: Wed, 2 Sep 2026 17:42:24 +0000
Message-ID:
 <SA1PR21MB668394D2F100CF7B14FD6FE8CEB72@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260828001202.2110938-1-longli@microsoft.com>
 <20260902164445.528471-2-horms@kernel.org>
In-Reply-To: <20260902164445.528471-2-horms@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0450f7d8-e380-4432-9663-9f996cbfcb98;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-02T17:28:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA3PR21MB5677:EE_
x-ms-office365-filtering-correlation-id: 173a2046-fda8-44a5-99cd-08df09198c58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|7146999003|5023799004|18002099003|22082099003|56012099006|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 4E51XWQbmK2YifwdqNhVAL54/qOl9mIRqMOJBF9V2/TVhdrWsKSnyxBJElahwpp0xDTEt1qFStef+eNs9SxJ5qTTIGNwWiarxkL+qb0AkRVX4Iaxd+uYjZ01lUFacj5nlwXAMwPRt1HmhrQD5KVgAq9NWYu2mjQgMn9RkC39clz6LePTqQekwqHiTN5flYDowfleLQSEMOc3Vw8+LALeUXn0f0oaRRKUKTfXrOlqFmNexARAAdTdgKoEn+3KNALAxosoyAWf5cOZ+yhVD0C5/xnGA+7m28cHiG880qyw+B/P1gUka5m/BgLB4rVSOO+MoF+eImpnRYcHzpJ2Vj9RzXIOn6JVRnQga9K6R1NLJxsDeNmm9bPWkvzcan/ITLcEm0JJdPAdtmeqCaMvfK7X+Aax6rBP1q1zre7Qjkq4Tta4giX1A5kkTI+dCzS1U5fjJfGpVtsfvGKy2t/UzFNFqAN/wUQwmih9AjvnoJoxpZ5Z06wi6Uyh45UhLF9jT5XViXTbzjBZ/cMwE1+qU+Xza79gFVbu3WicJIIFCqypiJpac7/dxT6IgrVLLRuo/0fUmpUt5gxm/tVK2nB0sb1KooaZT+BYyEGy6Jyj7RDhuWJ0KtMLhSFPJzPXkd67wCbGUdOAXq/tjFrE6Bv7Sgui/VVCbqv/viqylJy42fif34PsnKuLvPrWQw9bOvDA8yUWjGAXFegAYd/jV0xPvrzhEUWsA6apegUChirtiKV/mic=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(7146999003)(5023799004)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tshlOD11aKZL4mZ41MZtGOWQTv16AsQA4iyLjWuLaItwHxubJyHxzaZ0sM6H?=
 =?us-ascii?Q?4oQrMzKf5vK/LUQzIH5oekFFdqlU6H5hgN9BBorw1ObupsM/tMWDYAvXiIIb?=
 =?us-ascii?Q?kPYgvL2egoCh1m+tsLHTrxXcuXb1kqbHUb/5mdnT85b2dvXcdHPAoqhm1Mf6?=
 =?us-ascii?Q?3BLWOzlXF9Q5p36rlrSia5rwhKblBTd/b3IL987Gx2bwAx+Y2lcOr5CK9DRk?=
 =?us-ascii?Q?QaZNdcN24P4sAB5IwLCl6mk+mZoyaXKm6PBpB5yWdDt6ZTkt7t2ElqQy9xC/?=
 =?us-ascii?Q?1zEeEzLJ9njentoxqKtsOqxG2Az+EuzKwASXF5Tf+qPiJcs2VnHpLrL4Qtnc?=
 =?us-ascii?Q?y0i/kiy6K2nSj45W+APhQsG0Rx8yHanSzS6W2tuKhX8Nv7FSnthDNDMT1sTM?=
 =?us-ascii?Q?k1nw3pNPmXw+U+IyoPAL2FZ+VhQCvSo7APDdOtGjR6K3c6mEFUL3th2lkWhF?=
 =?us-ascii?Q?l4fExbdoTQ4mdPp4HqFXAEFerX00KF2A2+tRiw86ukVALwIfs1QS3Vrazd2J?=
 =?us-ascii?Q?YrOwMw9fyNCt7TnJqwG7OgH5rKo/+DBNtcdIBIZoCp7wSGu3eheWpHhP04Y+?=
 =?us-ascii?Q?YD2G4/wZpeEf8BjJz2SYC1EdvY9YyW8AgtkYENvSWJIhmTqXUNwenjQB1+tP?=
 =?us-ascii?Q?SWNkprE2m0JAERiFWl4kfDO806uJqtLNKPqyj5SNKMyGahu6b0rIPdlSZJ/l?=
 =?us-ascii?Q?HxDvqv+LBL6ozYe8hA7QHdX/gxm797zqY6OUW45W6Z+PbUNNL2CI/NrruJwH?=
 =?us-ascii?Q?hGA5Z3iwkffcudyKn973476a96MMvmbJlurAhpZs88K/T2K58w2OGGevnqR0?=
 =?us-ascii?Q?0qBMFPmdMA/BAXCJ1OZU8a/0J6YsP0iu5J8a5K6m1HSi2906z0sVGAUK4q2X?=
 =?us-ascii?Q?GFjrc0Vsk3vMlCogs7Rl8MNRtQJY7/cqOVXSGMSOzfW3mFNUqErZuyZgE3iK?=
 =?us-ascii?Q?z/2bnJzRDi+oXhYBMCkzz1zM1RhF0AKRwAIf+u3bx+1xL3kQXcPaqVLPUtm2?=
 =?us-ascii?Q?RGms/zNvKzI0NMkbjyhKIlMZaZz/A+nUrdtOl5HSB+vqERh8UfI8+AWCGjx2?=
 =?us-ascii?Q?27hdIrkVYS3n86CWgZdbQuhV0OsOb7AedVTwFTdgtNzmRFzoToPrWlf0p5oo?=
 =?us-ascii?Q?MRT3Q7z+Y0rckTTHwugLb+RYT5y8jjNZd3bAHuTGyU6c0q/nrYbdM/OZR6Cp?=
 =?us-ascii?Q?dVzUZ10eAPQNnclxP/82PV4nLNzz9nmqcGrTs2m5I3zp9nO/PPvT3sDgQj8E?=
 =?us-ascii?Q?q+IC5f4v5acCuyc9L0DsiHD6isIn8fV32Wr3knubSS50ioIg6XccIU+s5953?=
 =?us-ascii?Q?5+7QIURD1vNLti17DH8non1EpkN4abcQmwg+fGA92QhdgjPeYw9YWn9KFDOW?=
 =?us-ascii?Q?AQMA7qj0zZMWtebReMBR+tV/b3xt6eATnRuDULLaGE3IxoZjcgNpQRLcwypC?=
 =?us-ascii?Q?VTkl+XlppfAwkQmZ0szqYkZi4ObOSoGY3GYZjJE5K3f2+I+/FIaQPPh+NeqY?=
 =?us-ascii?Q?IrflK7E7y5eILpZvVhWKX/jnXxxBo0mZxAufQfDX1cUTqfnbBs/sM4LWyrwH?=
 =?us-ascii?Q?DNOSMZYjz87HT3eOVRwgQyMVvhbQ/i5oLULjbWj4F+KlPtVTPz7Ugru0dQzF?=
 =?us-ascii?Q?04y1hvLwyGHOfADr3vJwAQp/ChuqvFe5IWnvh7jbgFgHV53M17cEVdxmsVBC?=
 =?us-ascii?Q?79T9P+TA/bhqnBZUwrM7ERwhiZFRyeEMeDm1ocjrIXkiUMuo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB6683.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173a2046-fda8-44a5-99cd-08df09198c58
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2026 17:42:24.2906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulBTrKzuCpm7Gm8imtejTrjV0JSvtAFwVXv3EDUthCYyLMxzJ1ZzA6ttsgRtFJBj14Cel9PYIpzKkGm/bA2+/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB5677

> This is an AI-generated review of your patch. The human sending this emai=
l
> has considered the AI review valid, or at least plausible.
> Full review at:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fnetde=
v
> -
> ai.bots.linux.dev%2Fsashiko%2F%23%2Fpatchset%2F20260828001202.211093
> 8-1-
> longli%40microsoft.com%3Fpart%3D1&data=3D05%7C02%7Clongli%40microsoft.
> com%7C588623f27cf64c19cb1008df0911b29d%7C72f988bf86f141af91ab2d7cd
> 011db47%7C1%7C0%7C639239643786367503%7CUnknown%7CTWFpbGZsb3
> d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOI
> joiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DfPON6yyxZubRe8V9
> 4xCzc9ZMoSxXSR0cU2Zug1r8Lck%3D&reserved=3D0
> ---
> net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
>=20
> This clears gd->rdma_teardown and gd->is_suspended in
> mana_rdma_probe() so that RDMA servicing events are handled again after a
> hardware service reset cycle. The gate is re-opened with smp_store_releas=
e(),
> paired with a new
> smp_load_acquire() in mana_rdma_service_handle().
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index 7a1ac853e3abc..56f426da72864 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -3983,7 +3983,8 @@ static void mana_rdma_service_handle(struct
> work_struct *work)
> >  	struct device *dev =3D gd->gdma_context->dev;
> >  	int ret;
> >
> > -	if (READ_ONCE(gd->rdma_teardown))
> > +	/* Pairs with the smp_store_release() in mana_rdma_probe(). */
> > +	if (smp_load_acquire(&gd->rdma_teardown))
> >  		goto out;
> >
> >  	switch (serv_work->event) {
>=20
> [ ... ]
>=20
> > @@ -4279,6 +4280,17 @@ int mana_rdma_probe(struct gdma_dev *gd)
> >  	if (err)
> >  		return err;
> >
> > +	/* Clear the state left by a previous mana_rdma_remove() so
> servicing
> > +	 * events are handled again after a reset cycle.
> > +	 */
> > +	gd->is_suspended =3D false;
>=20
> [Severity: Low]
>=20
> Does the invariant described in the commit message hold on the initial pr=
obe
> path?  The commit message says:
>=20
>     is_suspended is otherwise only touched by mana_rdma_service_handle()
> on
>     the ordered service workqueue, so clear it while rdma_teardown still
>     gates that handler
>=20
> That is true for the reset path, where mana_rdma_remove() set
> rdma_teardown and flushed gc->service_wq first.  On mana_gd_probe() ->
> mana_probe() ->
> mana_rdma_probe() the gate was never closed: gc comes from vzalloc(), so
> both
> gd->rdma_teardown and gd->is_suspended are already false, and
> gd->mana_gd_setup()
> has already created gc->service_wq and brought up the HWC and EQs before
> mana_rdma_probe() runs.
>=20
> So on that path the smp_store_release() is a false -> false store and the
> handler's smp_load_acquire() has no state change to order against, while =
the
> plain write of gd->is_suspended here (and add_adev()'s plain write of
> gd->adev) can run concurrently with the handler's plain accesses to the
> gd->same
> two fields with no lock on either side.
>=20
> The outcome looks benign today, since is_suspended is already false and t=
he
> handler is a no-op in that window, but would it be worth wording the
> comment and commit message so they only claim the property that actually
> holds?

Thank you, Simon.

I will submit v3, with the commit message changed to be more accurate.

The following issue is pre-existing. The race window exists for all service=
 events; this patch doesn't enlarge that race window or make it more visibl=
e. I'll explain more later in this email.

This patch only fixes the issue with the 2nd service event not reaching to =
RDMA probe.

>=20
> > +
> > +	/* Publish is_suspended before re-opening the gate, so the handler
> > +	 * cannot act on a stale value.  Pairs with the smp_load_acquire()
> > +	 * in mana_rdma_service_handle().
> > +	 */
> > +	smp_store_release(&gd->rdma_teardown, false);
> > +
> >  	err =3D add_adev(gd, "rdma");
> >  	if (err)
> >  		mana_gd_deregister_device(gd);
>=20
> [Severity: Medium]
>=20
> Is the gate re-opened too early here, i.e. before add_adev() has publishe=
d
> gd->adev?  add_adev() stores it as its last step, after
> auxiliary_device_add() has already synchronously probed mana_ib:
>=20
> drivers/net/ethernet/microsoft/mana/mana_en.c:add_adev() {
> 	...
> 	ret =3D auxiliary_device_add(adev);
> 	if (ret)
> 		goto add_fail;
>=20
> 	gd->adev =3D adev;
> 	...
> }
>=20
> A GDMA_SERVICE_TYPE_RDMA_SUSPEND work item that runs inside that
> window passes the acquire load, but sees gd->adev =3D=3D NULL because
> remove_adev() cleared it during the preceding mana_rdma_remove():
>=20
> mana_rdma_service_handle() {
> 	case GDMA_SERVICE_TYPE_RDMA_SUSPEND:
> 		if (!gd->adev || gd->is_suspended)
> 			break;
>=20
> 		remove_adev(gd);
> 		gd->is_suspended =3D true;
> 		break;
>=20
> so the suspend event is consumed without setting gd->is_suspended, and
> the matching GDMA_SERVICE_TYPE_RDMA_RESUME then also breaks on !gd-
> >is_suspended.  Doesn't that leave the freshly created RDMA auxiliary dev=
ice
> live across a servicing operation that explicitly asked for it to be quie=
sced,
> which is the same silently-dropped-servicing behaviour this change sets o=
ut
> to fix, now confined to the probe window?
>=20
> Can the two contexts really overlap?  mana_serv_reset() runs on the syste=
m
> workqueue via mana_schedule_serv_work()/schedule_work() (or from
> mana_recovery_delayed_func()) and calls mana_gd_suspend() ->
> mana_rdma_remove() then mana_gd_resume() -> mana_gd_setup() ->
> mana_rdma_probe(), while the handler runs on gc->service_wq, which
> mana_gd_setup() re-creates before mana_rdma_probe() is called:
>=20
> mana_rdma_service_event() {
> 	...
> 	INIT_WORK(&serv_work->work, mana_rdma_service_handle);
> 	queue_work(gc->service_wq, &serv_work->work);
>=20
> Different workqueues, and GC_IN_SERVICE only serializes further reset
> requests.
>=20
> Related to the new comment: the handler's read of gd->adev is a plain rea=
d
> racing with add_adev()'s plain write, so "the handler cannot act on a sta=
le
> value" holds for is_suspended but not for gd->adev.
>=20
> mana_rdma_remove() uses the opposite ordering, closing the gate and
> draining the workqueue before touching gd->adev:
>=20
> mana_rdma_remove() {
> 	WRITE_ONCE(gd->rdma_teardown, true);
>=20
> 	if (gc->service_wq)
> 		flush_workqueue(gc->service_wq);
>=20
> 	if (gd->adev)
> 		remove_adev(gd);
>=20
> Would doing the mirror image in probe work here, i.e. keeping the
> gd->is_suspended =3D false store where it is but issuing
> smp_store_release(&gd->rdma_teardown, false) only after add_adev() has
> succeeded? =20

No, and I'd rather not make that change.

First, this window is pre-existing and this patch does not change it.
The code that drops the event is:

        case GDMA_SERVICE_TYPE_RDMA_SUSPEND:
                if (!gd->adev || gd->is_suspended)
                        break;

That test is untouched by this patch -- it does not appear in the diff.
It is reachable in mainline today on the initial probe path:

        gc =3D vzalloc()                  rdma_teardown =3D false, adev =3D=
 NULL
        mana_gd_setup()
          alloc_ordered_workqueue()     service_wq exists
          mana_gd_setup_hwc_irqs()      HWC events are flowing
          mana_gd_detect_devices()      mana_ib.dev_id.type is set
        mana_rdma_probe()
          add_adev()                    gd->adev published last

gc is zeroed, so the gate starts clear, and mana_rdma_service_event()
already passes its dev_id.type test by then.  A SUSPEND arriving while
add_adev() is still running is dropped on a stock kernel, with or
without this patch.

What this patch changes is only that the reset path now reaches that
same pre-existing test.  Before, it stopped earlier:

        if (READ_ONCE(gd->rdma_teardown))
                goto out;

because mana_rdma_remove() set rdma_teardown and nothing ever cleared
it, so that event and every event after it were dropped for the life of
the device.  There is no input where this patch loses an event that
mainline would have delivered.

Second, on the reordering itself: the gate is a discard, not a defer.
A work item that sees it closed falls through to "out: kfree(serv_work)"
and is never re-queued, so moving the store just relocates the loss from
!gd->adev to the gate, as you noted.  It also leaves rdma_teardown set
when add_adev() fails, reinstating the stuck gate this patch fixes.

> Note that ordering alone still drops such an event, just via the
> gate instead; serializing mana_rdma_probe(), mana_rdma_remove() and the
> handler body with a mutex rather than extending the bool gate would close
> the window entirely.

Agreed, because the handler would wait rather than discard.  One trap
for whoever writes it: mana_rdma_remove() closes the gate and then
calls flush_workqueue(gc->service_wq).  If that flush ends up inside
the mutex while the handler body also takes it, it deadlocks.  The
mutex would also be held across auxiliary_device_add(), which probes
mana_ib synchronously, so it needs a lockdep run.

Since the window predates this patch, I'd rather keep this one as the
minimal fix for the stuck gate and the is_suspended leak, which is what
the Fixes: tag refers to, and do the mutex separately against net-next.


Thanks,
Long


