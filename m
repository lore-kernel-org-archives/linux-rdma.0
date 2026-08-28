Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020114.outbound.protection.outlook.com [52.101.61.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D32DC765;
	Fri, 28 Aug 2026 19:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.114
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787945079; cv=fail; b=Z4kVEqJ3wHPGZ1f9qy89yen6BytsYoIZ6TN28Z5eGyvl8lp3ALce6fQikvg8avRclZ8tzB+trqTgsXiT3EYh/SQtrrukq/oMhqTUIqzoJOwsa7He1BfFYpD6X4htWM+TQi9mbLI4lK9mj2Z0nIPCX4fkKczJPWBNfjeWk+KApe4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787945079; c=relaxed/simple;
	bh=GuvH3oSecXg0N3zh6nMbaa9CeHsrQBsVTpNwzer+ANQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I3P+OzDJmGbBkYlWEpoYzNzAhHajwC5n2n265dz0h8ydrEc9MUW0cBRG6fSE6vq5qRjVqpEL8uSpmCPHq4MSOGj4DOCaFLHtdDoGLEho1EjiLBwRdS866FnblawUYDxPOH8WN9QaVYLd03bm8C2kGdGKDHs8VHL+fIViQThKQ+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=R7+TeWNi; arc=fail smtp.client-ip=52.101.61.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="R7+TeWNi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZE4vj85fqSmWwvFl7iRPg3nd34I3MA3v4CSV6NBm46f7J6UNRvPCSYyGsQ438RNzmD3gZWrl43pyXxBm5bAp1EXbldTtKP0zUd7mqhOXlmxx82lzOZnosf2CvNNkh+WTnh3eQBXjdIm/ypYB1VbYtv4QCHd9l7obQF1WBJv4FLHKnIoZyJZRAbUQomWytBTKM+D1u4fXgaVyXfjXNgnW5l6qp2ZzIou+PvkPsYOOOJ8v95NpC2313iTjz7lLyjLjs4l6T1cTtD1TGizae58wJH8mwE8xUI1JLD7rUx6UrPa4ZP/VFHePFoA81Fj8NTg2Vk5S64jtXn9rKbII9GvtLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oiw5vUC32Pb1vVSqKg4wck0NHwfKV9QAzLZSkIet5ic=;
 b=UPPbYi9ttSUvdWMMcEh4HS/4ifezvtxW6B4l1z0w1vazz0v+GXMv38TD/c55d/ro0+/N5nwOYmhI7OKACZbRDLGk5Q0goT2BABQz3HCpUQ5ScgF1cg2VKsj0nZ35akqBMf+NvjkaxEif4Rk3yGdEiOaXyf+6z2184Fn9bFHzKFuo67BR16ZuJG21S2lJ4FbBd94wNLXVFidykav7EjJmv1CVhVya2MtV+2lWB9CgMG7blO57kyQ3qSO6xyCTs75EFSpUjI1bNpI4PtrIrplkKLAfOVh5TZuKayMXiVY/26n/uDJ+1gPL5SpJQdo083QMhWxhBi+kmnOYEghc49/8DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oiw5vUC32Pb1vVSqKg4wck0NHwfKV9QAzLZSkIet5ic=;
 b=R7+TeWNikW/NL5+/2RC0I6H5J1hVHBdkI7Rjvi7kzN1Y2gUpMZxaMMPlGAv/gfarFSIONfF1kHeaT755DJWeMJc+FI28sUtJq50TpJdIIDoyl+U+0WPW9NrkSv4xGqi++mU2EYexwR7J3+BacbmKmYKobW7wYLoYjQLOWESILY0=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6704.namprd21.prod.outlook.com (2603:10b6:806:4a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.4; Fri, 28 Aug
 2026 19:24:33 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Fri, 28 Aug 2026
 19:24:33 +0000
From: Long Li <longli@microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, Snehal Sanghvi <snsanghvi@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next v2 1/3] RDMA/mana_ib: Extend RC QP udata request
 and response
Thread-Topic: [PATCH rdma-next v2 1/3] RDMA/mana_ib: Extend RC QP udata
 request and response
Thread-Index: AQHdNjGzBa7SZR8FZEav1994D4M/77az2ThQ
Date: Fri, 28 Aug 2026 19:24:33 +0000
Message-ID:
 <SA1PR21MB668351490EA2EDAC649E79AFCEAC2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
 <20260827143736.2013093-2-kotaranov@linux.microsoft.com>
In-Reply-To: <20260827143736.2013093-2-kotaranov@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=151333f9-4654-42cd-b900-4460324aecd3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-28T19:24:11Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6704:EE_
x-ms-office365-filtering-correlation-id: 5e4f1c7b-d632-45ce-43cc-08df0539fd9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|7146999003|56012099006|4143699003|6133799003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 B92DZDtGIV+fbmzTzbdowuVrbTsslSp7IVivlWjQkKQz2Y8u0h+cmbr9Qx1lse7ouZUspGGbh7IH6eStCuhP/PRmRXsd3Y8Lzji1fgxaFdbYbbopAFuV9+SAm1atKxtB4QBqq3YEXz761/ZevClJgiwX9PrCT9+YCP8khgq1Re+wSCQwAXYiFVn6jW0mMbvrqVwyQ4H+tA/P7mCZjnZYujOaKrNb1fXuAt1KxPoSULqW6LlR3fkLkjmYumL0cWkepVX9/ykoGYg8Do3NKm/a3cAJI92j0mEyoCeodzu3WuITkidfHq373xGlt8Wt6IG6Y/ydQVjSC+5rRM4RDXr2nBsjW+elADzFM85+PRiP+n/LoZqIPkpK33C/Ph4Bp6cAwNS8PxyZeYA1CqgzXwc/me0HOK8EjqSZTd6eHaII3ZsgirI4e6ec1nEovoMmEYPI5umQ7ovMRc4LVtcWdk3BLnqvtwVJPCId/+uKfT1DNrdybaoTnVx0IWVgwB8fs5LIaViCxpB0RbRjeXtmlpY2Fcv14F6Zyc9ltl8ZqZEvfSp4vSqW0zeqzByesZTdLbl+k7XPcebrdK0oGqXuh6ry++Gwbkj7NmL+pwlfOTn7crJWroi2mG9ElRFMS7qeWs73PePBAsql6pHpxNMF8u62Dy2hSq9w/c+iase04ukTLozuPfQc/Cm3Xees8lri4Bh/O5Oi3ItBhhQYbeU9tf3Jiy1wf1U7dZgb12DaMloQjlE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(7146999003)(56012099006)(4143699003)(6133799003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Tige+9YAApzx0Wo+hEoNLxJH22+gOlriTLWhmwAGenZH5MdiFyCGXhf5NS/4?=
 =?us-ascii?Q?oSdwkmP1mhm5KrYGYriknnmkr31HH4V2r0vfsEbxQBTLZ+or8cQmHRkpvgBm?=
 =?us-ascii?Q?pE1jdAjzg5sW2MBsKl0Si3m1rIxI06G9EDY8endw57/Vd3YgJJ7aETXBYtfn?=
 =?us-ascii?Q?iJVGBRPhj5u2htyOslK1zLThzsBbjftYMzl34hcRTBkg96ypPCICngJtjIE4?=
 =?us-ascii?Q?lGVlemBp2t3X1i3y9FzyxGhxqteXIb5GGm0ir9l6Q87WdYE0jfcB6kYw2jrR?=
 =?us-ascii?Q?rTNzHzwVSYU+8DZCkBqVaIz8xWpPPANT1D+RknAQlujDafoEr4XsEbeBVhap?=
 =?us-ascii?Q?v9JApF6N24nH63mBFUmTz+Z21aT+H8vE4F6LMu5aJoynn3t7jlmfubFX6LpE?=
 =?us-ascii?Q?ezLSxAhgjs8XVgnNCePTV02ocEYtcm7DPyimQj9plzHLSXxlgrccAHBJTnO5?=
 =?us-ascii?Q?yM9wfCucwn3ixybPclMwUapnrEyWLJ19UE8XeTGi44EGnZkmkLU9GF+w/4xK?=
 =?us-ascii?Q?gyF+IUyYrLLubg/XZPLEkrj7qaiskv+4S2k5dPIHY0MaeaiiNgjDtKRQqR33?=
 =?us-ascii?Q?9VcO8mBjd7HT21WiPCmSRkUymJKEmbqHv4qmJRdsRurt5T5ygQe+kiZdSBSH?=
 =?us-ascii?Q?8vwP3p+kXuhBsmwy2Ul8GFMvYKfgeHrSQIGcC8mUS3MvMSLz2jwVR/nows8S?=
 =?us-ascii?Q?TzfkhcEnaVKsBGVnhRX4CL2vH6tOJEDJ2YIzH3Jw2BZ1Qm7ThJB3zUg8032J?=
 =?us-ascii?Q?yVdU/s9ZKokrF7mRXJ6jwCC/s/xAnugQuQ4ka1qzrMNPWwxKPewwh85c3mcm?=
 =?us-ascii?Q?8Jidcjvkt5CKECVgcndBCBveZro1RMTmoyFABFJQ2IUkgAA69ECTEnBUbOSm?=
 =?us-ascii?Q?/qPsdjvW2y9glpJ2mNdmhOTgxhoQ5757U9s5uj7PlvJbQfRCOtRPMjxysjJ2?=
 =?us-ascii?Q?XOybpGXCF1zmNIvf7+6kq1MeY7W+PwgHRuL5zKfMurz3uZn7x5dgEw5bTGGM?=
 =?us-ascii?Q?0tqneysYCPveRvKW+cT3QQ7e603D0REEFRBgTxIEcUrFQSI7rpGgt7rZCnfq?=
 =?us-ascii?Q?jMWucvCm6hdGy+5SciwEM0oWgwhYpZpZjRps4WuoXm0yVXZgDcGPkP/s+qxE?=
 =?us-ascii?Q?ZZqqWXYd/fy/Jq8/egY38hiJGZap+rLEGfy+B7nBcd+OzVQiaIuw4+QHEDng?=
 =?us-ascii?Q?SruBWzf3f0kFT7rcGqOGvKYfK0h7l29iUjh3+nNw6+MH1Xxz4HrlgVS6kuVt?=
 =?us-ascii?Q?RjqTp+l9GzzZq5EEjcaygIyAcZaCeybVlv1DEFra7wttOdkihxN6g2sClqRQ?=
 =?us-ascii?Q?kKTiuGDPBC4/mkdieFewAw2y4F0dqkbD+l2oet6+kkapUj4iZ4WSUgJ2EmkV?=
 =?us-ascii?Q?7XgPz+RmLeQO5v0gXz5FOS4EmJejzU4EI5Jraz50UaQU7rNu4GGdTZpV0Es4?=
 =?us-ascii?Q?MEBK/xIsf8tJ11O5CgXRmhQo3J9ba2RF0mzcOsPROYgLZA7DS+YghjojaOJT?=
 =?us-ascii?Q?2IwrDRPgxz48H9IxIXiTjL8TrARqk34O7J2R+oYL436UJwwwctqn9ck1u4UJ?=
 =?us-ascii?Q?qz4wAzHap/zk0QxHMXeDrX2q6XA5B9giWw19Jwcn63XjWWXybN9e7SMDcMTG?=
 =?us-ascii?Q?8plASjkBOGQ3oqV8K4PuKxzjpL7P8lgwfy0HC93kV/nOyH6sTrSN8UrRv5m1?=
 =?us-ascii?Q?VQAEgQIQ4284L6M41x2xQQM9n71BXCxPUsttTv7XHMSTgY8Y?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4f1c7b-d632-45ce-43cc-08df0539fd9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 19:24:33.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8qBrmxPDgqC5NRVwz8TJEeKlbxZJBHbT2Ej7DcR36QMNiuawzOyakcdCVIjvm1jZsY4ASY+l+QPVkSFq91quw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6704

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend the RC QP creation UAPI to support optional fixed-size WQEs and an
> MMQ. Add a compatibility mask to the request, return the MMQ ID in the
> response, and advertise the extended ABI through ucontext capabilities.
>=20
> Use compatibility-aware udata validation so existing userspace remains
> supported. Rename the legacy FMR queue definitions to MMQ and add the
> corresponding hardware creation flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>




> ---
> v1->v2: use << instead of BIT() in the mana-abi.h
>  drivers/infiniband/hw/mana/main.c    |  1 +
>  drivers/infiniband/hw/mana/mana_ib.h |  6 ++++--
>  drivers/infiniband/hw/mana/qp.c      | 10 +++++-----
>  include/uapi/rdma/mana-abi.h         | 11 +++++++++++
>  4 files changed, 21 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/main.c
> b/drivers/infiniband/hw/mana/main.c
> index e4414d208..9d043f48e 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -247,6 +247,7 @@ int mana_ib_alloc_ucontext(struct ib_ucontext
> *ibcontext,
>=20
>  	ucontext->doorbell =3D doorbell_page;
>  	ucmd_resp.comp_mask =3D MANA_IB_UCNTX_ALLOC_PDN_SUPPORT;
> +	ucmd_resp.comp_mask |=3D MANA_IB_UCNTX_RC_EXT_SUPPORT;
>  	ret =3D ib_respond_udata(udata, ucmd_resp);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> index f69866696..547ddf9dd 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -172,7 +172,7 @@ struct mana_ib_cq {
>  enum mana_rc_queue_type {
>  	MANA_RC_SEND_QUEUE_REQUESTER =3D 0,
>  	MANA_RC_SEND_QUEUE_RESPONDER,
> -	MANA_RC_SEND_QUEUE_FMR,
> +	MANA_RC_SEND_QUEUE_MMQ,
>  	MANA_RC_RECV_QUEUE_REQUESTER,
>  	MANA_RC_RECV_QUEUE_RESPONDER,
>  	MANA_RC_QUEUE_TYPE_MAX,
> @@ -372,7 +372,9 @@ struct mana_rnic_destroy_cq_resp {  }; /* HW Data */
>=20
>  enum mana_rnic_create_rc_flags {
> -	MANA_RC_FLAG_NO_FMR =3D 2,
> +	MANA_RC_FLAG_NO_MMQ =3D BIT(1),
> +	MANA_RC_FLAG_FIXED_SIZE_WQE =3D BIT(3),
> +	MANA_RC_FLAG_MSN_IN_WQE =3D BIT(4),
>  };
>=20
>  struct mana_rnic_create_qp_req {
> diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index 8b7be1255..aa5f8c607 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -549,14 +549,14 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>=20
>  	mana_ucontext =3D rdma_udata_to_drv_context(udata, struct
> mana_ib_ucontext, ibucontext);
>  	doorbell =3D mana_ucontext->doorbell;
> -	flags =3D MANA_RC_FLAG_NO_FMR;
> -	err =3D ib_copy_validate_udata_in(udata, ucmd, queue_size);
> +	flags =3D MANA_RC_FLAG_NO_MMQ;
> +	err =3D ib_copy_validate_udata_in_cm(udata, ucmd, queue_size,
> +					   MANA_IB_RC_QP_FIXED_WQE |
> MANA_IB_RC_MMQ_CREATE);
>  	if (err)
>  		return err;
>=20
>  	for (i =3D 0, j =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
> -		/* skip FMR for user-level RC QPs */
> -		if (i =3D=3D MANA_RC_SEND_QUEUE_FMR) {
> +		if (i =3D=3D MANA_RC_SEND_QUEUE_MMQ) {
>  			qp->rc_qp.queues[i].id =3D INVALID_QUEUE_ID;
>  			qp->rc_qp.queues[i].gdma_region =3D
> GDMA_INVALID_DMA_REGION;
>  			continue;
> @@ -580,7 +580,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>=20
>  	if (udata) {
>  		for (i =3D 0, j =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
> -			if (i =3D=3D MANA_RC_SEND_QUEUE_FMR)
> +			if (i =3D=3D MANA_RC_SEND_QUEUE_MMQ)
>  				continue;
>  			resp.queue_id[j] =3D qp->rc_qp.queues[i].id;
>  			j++;
> diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
> index 32cbbfc80..c9a241766 100644
> --- a/include/uapi/rdma/mana-abi.h
> +++ b/include/uapi/rdma/mana-abi.h
> @@ -48,13 +48,23 @@ struct mana_ib_create_qp_resp {
>  	__u32 reserved;
>  };
>=20
> +enum mana_ib_create_rc_qp_flags {
> +	MANA_IB_RC_QP_FIXED_WQE =3D 1 << 0,
> +	MANA_IB_RC_MMQ_CREATE =3D 1 << 1,
> +};
> +
>  struct mana_ib_create_rc_qp {
>  	__aligned_u64 queue_buf[4];
>  	__u32 queue_size[4];
> +	__aligned_u64 mmq_buf;
> +	__u32 mmq_size;
> +	__u32 comp_mask;
>  };
>=20
>  struct mana_ib_create_rc_qp_resp {
>  	__u32 queue_id[4];
> +	__u32 mmq_id;
> +	__u32 reserved;
>  };
>=20
>  struct mana_ib_create_uc_qp {
> @@ -100,6 +110,7 @@ struct mana_ib_create_qp_rss_resp {
>=20
>  enum mana_ib_ucontext_support {
>  	MANA_IB_UCNTX_ALLOC_PDN_SUPPORT =3D 1 << 0,
> +	MANA_IB_UCNTX_RC_EXT_SUPPORT =3D 1 << 1,
>  };
>=20
>  struct mana_ib_alloc_ucontext_resp {
> --
> 2.43.0

