Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022116.outbound.protection.outlook.com [52.101.48.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9D350C29E;
	Mon,  7 Sep 2026 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809884; cv=fail; b=oKR4ivXFcCHvbBWOloeEfEWDcI+YjLYO5PKBAS/2VY8nJ1YnBhn0Krm8Mma83gr6pEb0C7YbkzPqgG5+NA+vgUAD37NP9hOScIWn6gaB+xPbdYwIN0y87WyceYvjhtf76LSqA6Wn/aJhs1XcNolxJcUMsvNfl6QVLlZwncGOT38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809884; c=relaxed/simple;
	bh=qQeGMdRxQG90gx7UBNJ5kfK4IhIfLhZs9Y9FsFgY02o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XpKxTv+99EdCvbooYhmt9j1pjcJfLPsLy4y8rjmmZbGfcJcklqb2YoSSQ9sUQxPFtR10SwW4KSWNSjyHeAiIOz3mdr6ArDPJuxCZuxKocgcHa1TzyxI1MONd5OrYYjZ5FZTKNYHLu0AIl/+M1JJr8lnMHiJrGVvg6mTZa3/62Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Nv0KT2hv; arc=fail smtp.client-ip=52.101.48.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Nv0KT2hv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/o6bkN6CnSVUipe/CEaugA9WXzWj1Gl8mKki7rhzYfexMEHEiA0qcfrJnkWRhmAc7XO7jNIzb0D9745hYvO0S4rRihOLT8+GpKowEL2Ss32ndkQe5G2JtgiDCdC9z3/LOKAV4rwTINBUSQU4vCjZU5o1IyewP1o6Orpuo88XI4q6ftXjJ/5hSttf0VyJKfOr3OKzwEoDiUnZO5FiWyasb0O/1EImef+b721EYGmZ7NN5YsmUEeV9Yn/14MKKAVU2DExbauUhgsUIKBx0twO5wz39+aiC3CRnILmhSPrsSQifvCImB3MKIl2SESAiGYX0gfz+gxuXtTbjVlE2TqfeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfWEJ4Z91df/MC4RaeL3wVU+Ae4CiJfaUoTeKlV/EG8=;
 b=m7qMFtTgYWq7wtp8PJmM0aa7efpFZq90UI//LQrE1BFVHzqREIpVm7qZb5IU8LTZGoT36IIBz9CD9Ixbe6rlHNu8ZDIvBmkz4tKPqAfQOEEWnBoiuEMCFtttMIyNX5KTibE1bOft+rfZjGo/lZIdkQJA9fz2Ns9bNKCWCxgjJziZVdoH2L9EoaEt+eWHGHyg5MI1Y+cbbPPXPvVKNAA6VbjxeI1XOQs6nvxV02s5WZUZG6VIj3bJWLdbl5K06qqJkl9dvePkfYTVxxU924661lO6RjStLsuyvyPr0KAYRqK7F3tpZbd6MQob8gl3vZ4AY4hNd8QNkpI2LdeKsruUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfWEJ4Z91df/MC4RaeL3wVU+Ae4CiJfaUoTeKlV/EG8=;
 b=Nv0KT2hvkxhYrEwcq/6FdpKjLys8eyTuXWh5g0oPBubhExBw6VbFMMJatgFg5viOxI15MAIWWlLfd9nZAUK5+b1mtEJFqCXRxxeq54elvq4u7T1yT+y3aJHsMoHX2MDeGFu+/oOk4OAbFFB/EniGB1wZULnJT/Wt4qKp7MFI8II=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6754.namprd21.prod.outlook.com (2603:10b6:806:4af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.0; Mon, 7 Sep 2026
 19:37:59 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Mon, 7 Sep 2026
 19:37:58 +0000
From: Long Li <longli@microsoft.com>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang
 Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>,
	"horms@kernel.org" <horms@kernel.org>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "shirazsaleem@microsoft.com"
	<shirazsaleem@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v3] net: mana: Clear RDMA teardown and
 suspend state in mana_rdma_probe()
Thread-Topic: [EXTERNAL] Re: [PATCH net v3] net: mana: Clear RDMA teardown and
 suspend state in mana_rdma_probe()
Thread-Index: AQHdOwPcQaAS2vbBik6H0+Y/iWMwHLbAcWQAgAMZB0A=
Date: Mon, 7 Sep 2026 19:37:58 +0000
Message-ID:
 <SA1PR21MB6683FF5A173E8F4E98F2C6A4CEB22@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260902175153.3410560-1-longli@microsoft.com>
 <178863950861.219967.11031826205252016526@kernel.org>
In-Reply-To: <178863950861.219967.11031826205252016526@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f2d9ca80-2fc7-45ad-a4d1-1e9e176de9c6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-07T19:36:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6754:EE_
x-ms-office365-filtering-correlation-id: 04726ace-3491-40e8-10c9-08df0d1785a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|23010399003|1800799024|366016|376014|18002099003|22082099003|4133799003|38070700021|10067099003|56012099006|6133799003|7146999003|5023799004|11063799006|4143699003;
x-microsoft-antispam-message-info:
 w9VWrebR7CBnTKZ8as7PA6x2DdZPl9ck6Ud2bJKedydsoMSOMTgZvq/sx3pam+HnKr9+Z7aw43X6NHWKS5mXnIxoE0b+FreTtPVUUN/0iwZ2JRc21JSckhxZPBKU88F6OP/n4FBBMZD8ZeMkCjsE5POv3a8zksskvWy6UyGPkL61yu94YROsg7i1pnRczcaH8ezPPz2bMPO5hs4t9F//U8zF8zk4pFUuGEo/gavdDbReWmhPDIfv+G7ubG2FeDsyHukGxg+p9vteDuWc9qw6edVtO6KHymGCkX1qmWP6eBHuLQedIo0v80doojd9nZadZMtN3BnwkG354arvkyU8fUYSiNpRS0Cxt9asRmgGKly7yiJhJ0Z82IVfaWNMovMRbhrMSY4Jpz+bgckH7i02KNRKwBhTaIlQPvoFS/qgVWr2UlAQ/IHPrBhuIhjWkCAqmt+H7cmpAEomq55XkRk2Erm3wsGPWb7e4ywEhAPTf+OFSRBmkFkJvw4aiobTHulNCAX5JieKI7XJYhQbDSH0Tsv1Z3w5mInyt8hSnL9wB0OCtt+ORT1Gd3MgxC5avOtur1Vr9SxtTqCMA5qHhazVQmUXkqxwLqepwSyKu6o8C3B6gwuDV2atu5FJxhMwIaTaKAGAqlVgUx7DMGLLiyanImisW3vzwmKRpSeiAKvNBpg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(1800799024)(366016)(376014)(18002099003)(22082099003)(4133799003)(38070700021)(10067099003)(56012099006)(6133799003)(7146999003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3qJQJva/gYIxfyxSGDDy7TlyD9SFyLgk5N3rK1DRNq0OL0nR1zWBW0jYwZ?=
 =?iso-8859-1?Q?aSHB5ux+mzWVUnl9pzJdEDxlkwvEys6BLoPkNQaFvkrnNUYmn7CaPw9qmt?=
 =?iso-8859-1?Q?hzK4rsduMwuVk0mqVnhseKNWaPCB3DWkZB7aedQ7wN+C5nFsL1tQkiOERz?=
 =?iso-8859-1?Q?+ZJDh6B9pfqjKFvnSzKFmy0J8v3CZa5jnNp2Umahnynai6vCTIy6O/eKYd?=
 =?iso-8859-1?Q?zYFy9zAgX8QEno77kgCBRjPypwDYc4velJj5FQI2swcKG0CO16ri+5o8cz?=
 =?iso-8859-1?Q?Npq6Jzo3lOi5DRn+NnZOkjB0W48nafnvPWWMyOiI1GDJkwVdGm7gZzN0j/?=
 =?iso-8859-1?Q?KeEOOOFc5ahsFv8ym2uwQeHbnqQf0n2zucTA24s6TB1JVXxsLb8QjVJWVP?=
 =?iso-8859-1?Q?ZW0Pj95+n7LAwp8LKwRbHft91DF+LxfDQLJeYgKNlaIAcWi0s20Jz4PX65?=
 =?iso-8859-1?Q?W3iNWHXIiuXIiPdjPIPXBk4YXPpLtrTBF1yY+dfN3e9aWM6fVF8seWUNiI?=
 =?iso-8859-1?Q?Ij8DbThNMDZ+hXwUl/5rEySnrbEsFaWa0G/hpXy5qJpeLffCYJVBwhao2B?=
 =?iso-8859-1?Q?POhu4KZKIl83Nzxd65QFN3bFhmKcMlcyBY5ViWGLp81TGmmdHw7TxLAHGV?=
 =?iso-8859-1?Q?jJMRRCJLVEed2NWXoD+IXTa8hOf6F3cAAxuIiCrCGF3y+tA6CBpcGKUMCn?=
 =?iso-8859-1?Q?U+7fR7BSeWjq+IVF0kBmliDVmZaXyEoAQg0ngbKXt3NZhbQOlHXFR/jaTz?=
 =?iso-8859-1?Q?usn/d/crSEI1Smek5mKnlDDl958C9vRqZJa7LHRRbMiISpStv8TblQJq6n?=
 =?iso-8859-1?Q?jwXoorIISz9Hbz/Hw9FEDV1bPxZtmm+J0hAEcKj/2MFNpzzPqQnHlO5F02?=
 =?iso-8859-1?Q?tQJTy8oTj+9hZfy7T2FJPkU+4fsVq4FCkQayPJimqsCiA2gdn5/nENoZDo?=
 =?iso-8859-1?Q?yNiwiJ0cjj4A8FTAJKP7lEu0GbABl1lGjLa8hvDWFNI6rRzxG/tC8j4b16?=
 =?iso-8859-1?Q?1/QoNtWX8nczYFiVwIbWosRy48yZMvZ/Lm10QDOIaPaTFn+XqvoK7y0V1r?=
 =?iso-8859-1?Q?4+NmES9WqIiGtjhkd2iy1+t5Qs229JZ4Ejpdr85gTKJpPg75lnwnII3WUu?=
 =?iso-8859-1?Q?eoyAlo48eKhs8X25OayClLyxHv+1KnjTycfjAawSbExXefhqwegRDhY9cQ?=
 =?iso-8859-1?Q?l+xsPd8WMvuSOp+EbNDraBBTyaMz/ch3bDdGy7uW27RqRDirR/H3+HHjc8?=
 =?iso-8859-1?Q?/O6+FSETDWd0IU16STv/NlEQMBCwaPCkpmY4bHQ5EINKg6Usc15fHuvokN?=
 =?iso-8859-1?Q?LzaLDqUby/336f8xcPMBIK57yoUo+lszIzpFpnXKlHuyfj5l7y1N0VbnPR?=
 =?iso-8859-1?Q?pHcXgZb1jeew/oUPpg7eCevnFH7hZtroBI4QgSpDluY1PzR9iPPKOeSVMw?=
 =?iso-8859-1?Q?3tGMcumehEvEEF1YOt86aL22BhzJH6xR7QaOsjmcHJAJee9yamnjii97YE?=
 =?iso-8859-1?Q?/QdpKFoFxRxNKOZYl25M1nIYv3rcQE7AY4BauNuMiRkj7FLyLvuxpTnQLP?=
 =?iso-8859-1?Q?b22Zae/ulC6YVE6SdSKs6Zrm/8Jo+QMSpMeU+3vcJlSNGSqpm6/rUbbYm7?=
 =?iso-8859-1?Q?73KpzgFvG6qMxFXkC1rKPD8fR1mzx7Kp/z9/D7tKVd3bwvQ6MrkTxVj0Eo?=
 =?iso-8859-1?Q?hgReEtS0mdmN4YxpZde0Ar9DHCbxd0jjiibyUiOriUeToefCAHMMtfKaDQ?=
 =?iso-8859-1?Q?icPs5NvLDqHHdi859L/610mrpza5sVOQUzFE2jg45Uy/kh?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 04726ace-3491-40e8-10c9-08df0d1785a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 19:37:58.6813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kN7L/22WYDmmqe9Tfm0IVmmM4Cy6ui2GNXKGLgHZ0y/LIgFM620OlB1PqqyF8aH0gyxfeaROKUEY31YjA16yYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6754

>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
>=20
> Critical: 0 =B7 High: 0 =B7 Medium: 1 =B7 Low: 0
>=20
> - [Medium] In mana_rdma_probe()
>   (drivers/net/ethernet/microsoft/mana/mana_en.c:4296) the servicing.
>=20
> --
>=20
> net: mana: Clear RDMA teardown and suspend state in mana_rdma_probe()
>=20
> mana_rdma_remove() sets gd->rdma_teardown and nothing ever clears it, so
> after the first hardware service reset every GDMA_EQE_HWC_SOC_SERVICE
> event returns early.  This patch clears gd->is_suspended and re-opens the
> gate with smp_store_release() in mana_rdma_probe(), paired with a new
> smp_load_acquire() in mana_rdma_service_handle().
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index 7a1ac853e3ab..d8e847df7a44 100644
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
> > @@ -4279,6 +4280,21 @@ int mana_rdma_probe(struct gdma_dev *gd)
> >  	if (err)
> >  		return err;
> >
> > +	/* Clear the state left by a previous mana_rdma_remove() so
> servicing
> > +	 * events are handled again after a reset cycle.
> > +	 */
> > +	gd->is_suspended =3D false;
> > +
> > +	/* Publish is_suspended before re-opening the gate, so the handler
> > +	 * cannot observe an open gate with a stale is_suspended.  Pairs
> > +	 * with the smp_load_acquire() in mana_rdma_service_handle().
> This
> > +	 * matters on the reset path, where mana_rdma_remove() closed the
> > +	 * gate and drained the workqueue; on the initial probe path the
> > +	 * gate was never closed and both flags are already clear.  It does
> > +	 * not order gd->adev, which add_adev() publishes below.
> > +	 */
> > +	smp_store_release(&gd->rdma_teardown, false);
> > +
> >  	err =3D add_adev(gd, "rdma");
> >  	if (err)
> >  		mana_gd_deregister_device(gd);
>=20
> [Severity: Medium]
>=20
> Would it be better to open the gate after add_adev() succeeds rather than
> before it?
>=20
> As written, the store that re-enables the handler happens while gd->adev =
is
> still NULL from the remove half of the reset cycle.  The publication happ=
ens
> later, at the end of add_adev():
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
> A GDMA_SERVICE_TYPE_RDMA_SUSPEND handled in that window passes the
> gate and then hits the gd->adev test in mana_rdma_service_handle():
>=20
> 	case GDMA_SERVICE_TYPE_RDMA_SUSPEND:
> 		if (!gd->adev || gd->is_suspended)
> 			break;
>=20
> 		remove_adev(gd);
> 		gd->is_suspended =3D true;
> 		break;
>=20
> so the suspend request is discarded, probe finishes with a live aux devic=
e
> and is_suspended =3D=3D false, and the matching RESUME is then also swall=
owed
> by the "if (!gd->is_suspended) break;" test.  Is the resulting state (hos=
t asked
> for a quiesce, RDMA aux device still live) recoverable without another re=
set?
>=20
> Is the concurrency here real on the reset path?  From what I can follow, =
the
> probe runs from system_wq while the handler runs on gc->service_wq:
>=20
> mana_schedule_serv_work()
> 	schedule_work(&mns_wk->serv_work)   /* system_wq */
> 	  mana_serv_reset()
> 	    mana_gd_suspend() -> mana_rdma_remove()
> 	    mana_gd_resume()  -> mana_gd_setup()
> 	                      -> mana_probe()
> 	                      -> mana_rdma_probe()
>=20
> and mana_gd_resume() calls mana_gd_setup() first, which re-creates
> gc->service_wq, re-arms the HWC IRQs, re-creates the HW channel and
> re-detects devices so gc->mana_ib.dev_id.type is valid again, all before
> mana_rdma_probe() runs.  So an event arriving during probe reaches
> mana_hwc_init_event_handler() -> mana_rdma_service_event() ->
> queue_work(gc->service_wq) and mana_rdma_service_handle() can execute
> on another CPU while mana_rdma_probe() is still in add_adev().  Since the
> event timing is driven by the host, is that window reachable in practice?
>=20
> In the opposite interleaving, the handler reads gd->adev with a plain loa=
d
> and immediately destroys the object through remove_adev()
> (auxiliary_device_delete/uninit, mana_adev_idx_free) while probe is still
> finishing.  The new acquire load only orders is_suspended against the
> release; the "gd->adev =3D adev;" store has no release pairing with the
> handler's load.  Would publishing gd->adev with release semantics, or
> moving the smp_store_release() below a successful add_adev(), cover this
> too?
>=20
> There is also the question of what rdma_teardown now is.  Before this pat=
ch
> it was a write-once teardown flag; with the clear in mana_rdma_probe() it
> becomes a gate that mana_rdma_remove() closes on entry:
>=20
> 	WRITE_ONCE(gd->rdma_teardown, true);
>=20
> 	if (gc->service_wq)
> 		flush_workqueue(gc->service_wq);
>=20
> and that mana_rdma_probe() re-opens on the way back in.  That is a flag
> guarding a code region rather than expressing device state.  Would a mute=
x
> held across mana_rdma_probe(), mana_rdma_remove() and
> mana_rdma_service_handle() be a better fit here, since it would also remo=
ve
> the window the comment documents instead of describing it?

This is a pre-existing issue, not introduced by this patch.

The concurrency is possible: reset/probe and RDMA servicing run on differen=
t workqueues, and =A0GC_IN_SERVICE=A0 does not serialize them.

The underlying probe-window issue already exists before this patch. On init=
ial probe, =A0gc=A0 is zero-initialized, so =A0rdma_teardown=A0 is clear. =
=A0mana_gd_setup()=A0 enables event processing and detects the RDMA device =
before =A0mana_rdma_probe()=A0 publishes =A0gd->adev=A0. A SUSPEND processe=
d then already encounters:

if (!gd->adev || gd->is_suspended)
        break;

This patch fixes a different problem: after reset, =A0rdma_teardown=A0 prev=
iously remained set permanently, discarding all subsequent servicing events=
. It also clears stale =A0is_suspended=A0 to prevent a later RESUME from ad=
ding a duplicate auxiliary device. Reopening the gate makes the existing pr=
obe-window race reachable after reset too; the patch does not resolve that =
race.

Moving the release store after successful =A0add_adev()=A0 would improve pu=
blication ordering on the reset path. However, it would not preserve the SU=
SPEND request: a handler observing the closed gate executes =A0goto out=A0 =
and frees the work item without retrying. Publishing =A0gd->adev=A0 with re=
lease/acquire semantics alone likewise would not prevent a handler from obs=
erving NULL before publication.

There is no automatic replay of the missed SUSPEND. A later SUSPEND can sti=
ll be processed, but the matching RESUME cannot retroactively provide the m=
issed quiescence.

I agree that proper serialization, or retaining pending events, is needed t=
o close this existing window. A mutex implementation must cover initializat=
ion before servicing can run and must not hold the handler's mutex across =
=A0flush_workqueue()=A0. That is separate from restoring servicing after re=
set.

>=20
> --
> Sashiko AI
> review =B7 https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A=
%2F%
> 2Fnetdev-
> ai.bots.linux.dev%2Fsashiko%2F%23%2Fpatchset%2F20260902175153.341056
> 0-1-
> longli%2540microsoft.com&data=3D05%7C02%7Clongli%40microsoft.com%7Cf8
> 5ef293a80341ee9ed308df0b8adad7%7C72f988bf86f141af91ab2d7cd011db47
> %7C1%7C0%7C639242363166629979%7CUnknown%7CTWFpbGZsb3d8eyJFbX
> B0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFp
> bCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3Dnn4%2FxPu1A7bHbISZYnIuG
> xaoXjh%2FkS1prtwKZ4RSKao%3D&reserved=3D0
