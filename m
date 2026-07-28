Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023075.outbound.protection.outlook.com [40.93.196.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408483D3492;
	Tue, 28 Jul 2026 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785269375; cv=fail; b=YpkKhOpTHUIWQmBsjz1FVQuPc/pc0V8HOXW8lt9aUunxreaNxXs/n8OgkbzVe12jzKLKS+ZGR+dME9BbA/qBTd5wYuG6l7/6w/qXyET5jl6PqPv8GEMnsqPkaJtGJCyKuOh/HhtXE+m2UUWVB6l/kNzvs/BciUUesN7rAVw/pFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785269375; c=relaxed/simple;
	bh=Swnc27Ptu/OEUFxAASgzMgyskmhs7B2U3RrK7rgzHJY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T3RSBCR4jlkXq/PbQtqW/SRj2Bqbr9IFQJp3bDRXRXdJj3KY/2I8s5hVz2BSy4zdcUvSWCIC2wCwPO1+Tnnug9Pky5+j+Dn4UCkKYd5/PDOOhS/85aKjZyon87QMXHAvBKmERfB6DYURHQ5olQkBd7k0CVXMwTO8FU79eeGiRWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=fOgtI5jF; arc=fail smtp.client-ip=40.93.196.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="fOgtI5jF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugDz04Xq03IIlHt9sJAJ/o22OgUEDKVeWBgHUzpP5NdUthV6J/edyHgbHmZ52eTC26iEUCu9l5mZnJIdTSJvJV1hxOH+lohVbzfLFJW2r2PGD9MGuFbGSLVvSBHOC7K4lAfxb9aI+zHz8asII1wb04Ey5Zov9rchie9j5XZ8wzG/TvT5MtO/5vsnP+PNpymSJTAUIvwl6oRZJuHU4WK8YutEXHHuqcR8cjzuJ2tslxnmJgf3SFiAyoxM90TsVu1t2nkLQMgHbXixVVv9gYPdbxtxdCV/x2fOHRAqUxGObxk6V+BrlEAXEfIU+JswNvzj2bes/fzwmsIwKkxL+zUROQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0T5BCgPrUnrdZM5dZpfH7MQL6s/UEfekii4tcfcGe8=;
 b=p1Wey3jFRF2hvuZt0uap8uK7iFZtr8whE6hT36/WuHO/EIu0Wpzn+F9F9/0Dt71m6UUQuBlrR3XyYebag9Y4Iy3SDgK7GHjw4RrCx3CkqX/3Mo5+X4zgIIJoZ7Y8ycSlgIElCL+RocUPmBeOc7D4ljgNIRUKl9PnU6ayhRknLugg2DvB/COKWFXHYC7M7SwBR2kCDlkozbOZD79cGNFE0mh9APBbM+e3rmAqXr7HfvRGJ30WOlg7ZQ0SqOZ+hltExYt7m2lq8j3sqASBTnei74y/HoITgzWuhO7xUGAq8lae94n7aQx+8JV2hFDAStipu9Hj/SXeyc0yAQF4W6a8XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0T5BCgPrUnrdZM5dZpfH7MQL6s/UEfekii4tcfcGe8=;
 b=fOgtI5jFsy8E89Udtwkbnq6QhuGhOGhlCchQW8xtO69TdLODwBZZuraidXmW2YC3vnICIcxeBqXxRPqVJ6rm7vOkRWq/tt4hhAmfCSk+PMlwSUPezLK5HoZlAkqJVYHT0o0fiZbhbJ0LYtHTpPgsfxxF3DnWbx+Tx8VzrzDAWPg=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6320.namprd21.prod.outlook.com (2603:10b6:806:4af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 28 Jul
 2026 20:09:30 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%3]) with mapi id 15.21.0159.007; Tue, 28 Jul 2026
 20:09:30 +0000
From: Long Li <longli@microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org"
	<leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next v5 1/2] RDMA/mana_ib: unify QP lookup table
Thread-Topic: [PATCH rdma-next v5 1/2] RDMA/mana_ib: unify QP lookup table
Thread-Index: AQHdGprRY9pQks+HPUGpx4yMMlNBZbaDZKLQ
Date: Tue, 28 Jul 2026 20:09:30 +0000
Message-ID:
 <SA1PR21MB6683C7824BC889991A3D3AE7CECB2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
 <20260723115955.1859519-2-kotaranov@linux.microsoft.com>
In-Reply-To: <20260723115955.1859519-2-kotaranov@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e185301c-78be-4843-b786-99401cf4d406;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-28T20:08:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6320:EE_
x-ms-office365-filtering-correlation-id: b29dcc49-4ecd-4ef0-8dab-08deece4226e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|11063799006|56012099006|22082099003|4143699003|18002099003|7146999003|6133799003|38070700021;
x-microsoft-antispam-message-info:
 xKTaSi2lv5e/aYuYNwf+sNNIgg8kjb033h+kcpIuSSeTUEvvm1jqP+CUkWF2EndI+QdrhmPElkOeP3Zgs0zIlGPJfwCA9Xh7PC4wH4capGUYYxWzAXIyXZHAJXoIuXBVvFxRFrOhE6dKnpKr8Ih/uqOQPwXT18uRDt57jYeQbl4iNO3RvWEBa+6BfLjG8EH4GSzU0kqKUIwqbjbJKA4H8pZ/1kjCi3/0f5ntaSUO2VRPGRSt0d2EXHt69FojVi3C19we8YAl9BNGspjJhP3R+i9qfDDwCvkb9kLGCPRb+LZxxQ0q6DhUr2/bUYGrk9Ksgf0nzmifyN1X0CRyrWnNv7RmGddlTa5jKY6F08iEfPaPPZ8WrHfiC5KI+n9ipkP1URi6c8OMR9fW5VvxTYcFfz4HB4oiolt0C7CeTGn16q+AT2eatfVSZmfyGTqRYAZ363UrpNszzw/tlmkIR45R/olfA/G9K378K0+p51NhLSOF8Tp539sgZLFj8B1zZiPhpgQsttuXAQlT/N32o2CMDIFkfm0dYwjCrrcYyXM0FusqcBa4NLMm39ugdJ87Pkfu7yJNEEMAxmvdE9DGMKYrcjAQMhjlyDysLg+ctxohavUm9NXOuI4r3BJok4dHaYt7o5jl7WRbqX0aLTx1ppEqlUgX40d/lP5p9iP5CJD/BGu3bmo1rYUXT6o7eJEZ+lJz3JzdLBqQszrsrauKGW22GA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(11063799006)(56012099006)(22082099003)(4143699003)(18002099003)(7146999003)(6133799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1MezULeT/xsyOW9F8d4jFL+DJSYm83fgrqGY9SEoV8hGzgvSnmhroAX4hwcl?=
 =?us-ascii?Q?blSQXEJV73tDj5XkE1LiHVatD5Hu8d42KNvggQUuZ1qWZQMreFQ9XAEnzLsw?=
 =?us-ascii?Q?hfbPnGC2iHky1VlLIxagNmmmwgX33CPS6emulJ/SHWC72mmRa/Zlq48YEky3?=
 =?us-ascii?Q?XHdSticr3/VGrONy10SyzR3oUpb67+YJthBxLndvHOUmWxCrtuN3yViIHPSH?=
 =?us-ascii?Q?g0pEN7r4ghz4kTgzXLVXvcSP3dKxcZ/H+kY5j9EhHdg4UKqiHbXS7yd+46OI?=
 =?us-ascii?Q?uW3gvcBQSl5Zrew7UZEW2VvTHG9/q4fw5SQdugPU/wiee1+xoy+8o5wYWu/o?=
 =?us-ascii?Q?CeqLG0Q/PKGGI65+IvmXAtFduK8b5rCBXVmkYXFjGEnlTFjWCp12/ZWTfxMU?=
 =?us-ascii?Q?T/Mo/UpSP3S01jPNwD7IeAc498erA1WoNYfaptHDWn0dl8hUcS12doYscsHj?=
 =?us-ascii?Q?8ORyeF5TjQq8FsnYxbYut+z5Z+Yz/+Loi73VgMyXq64Pig+0eObKVo5b/QXC?=
 =?us-ascii?Q?gkWcWF6Re44KSKpZsvS9O4S0CARj24SBQjM/LsB0BsSizLTaAzrDwWzdk6Fr?=
 =?us-ascii?Q?ffAUW6HApjZ/wbTTAbw/8A2FScSx1mAWWYgzz4hIqp9lKjwII2gsmryRbN7d?=
 =?us-ascii?Q?AQT8jvCrDnLB4boLeCXAwQ23w3tqWZ9QDAITr4ow1b5mFvA0P/68BTt9UYci?=
 =?us-ascii?Q?oEX77pfBsLZNy5uiD0s0sZZcd3eFiIsvQsNaJkMhSojU283m+FQsy2OqMWxg?=
 =?us-ascii?Q?jPIWz9Dqaes5uWla2PYoft3wLVOIimfCaZlV/3e0X2YO0Is3JJW8niQeP/SW?=
 =?us-ascii?Q?+yppHGvk224Alnp/d9F8uBk+BG3T0YjwwTKDW2TCv85B6DH/4pLJmlcbPsCA?=
 =?us-ascii?Q?nEaV7dx4St+93gJCiAzmP3EsiUmspExeUpVOzskHmQ806csGVuAza+PaItXz?=
 =?us-ascii?Q?ViHBqDUig6AgPdZSJ0JABoZ55BfSEKC9UNht40Y+CT7ANJVBh7WOVy1KNmUV?=
 =?us-ascii?Q?2jtb8MjAUDfvVnooHNLqPic2AB3ujjvJsqYAwO2uDhg4hLg/ZoYggbIvAdiS?=
 =?us-ascii?Q?ufAS12fpAsxMyJxvgrqa7qocONQted+stgkd6m0b22rhdzahcsBPGtk6nmuM?=
 =?us-ascii?Q?sNIe2fwY/1n5F6Mqv2rSl1gciS+5q6Gxbk29fL7VqiRsYyP00ERt+jarsA36?=
 =?us-ascii?Q?sH5I2mJchMXtF7ufnbRpWolV7w9QeCjwxASTV+X8WRelHib2RH6Pg9QFg+Z2?=
 =?us-ascii?Q?2wvGyBT9L2mFDzPOSDWisnTN8LEnNs2XDqyxNH1KRVP+SKcAOs9gnOBmj0X/?=
 =?us-ascii?Q?8UrKs1whV7I+StqXzKmD531tZIrEiWJgpKJbrdFGMftlM4XgbIVavHVJv6ZK?=
 =?us-ascii?Q?Ylr3ubwj7vqrJOkOjBfggDII8D9bQa5qAzmGIyGdGtQ/Y8GrupwKxalCmQI8?=
 =?us-ascii?Q?r39svxrPpeIrxUVCCSuCckvsLau+aaw0tG0Lo9CDGBjc5ijRydCf1XyBg+qs?=
 =?us-ascii?Q?4JSYHW710f06LRcfKe3M+Pr0wS2LDyofhlwEC8FCxE92XC7IneIKOwQLQQ5p?=
 =?us-ascii?Q?44s37AfNqJOCmk7SsbxQKoWWwnk9FMpQZ4lLAb1fxG1AGXXVDaClSoqcYe/y?=
 =?us-ascii?Q?KrEnPc0EV37RD1dwGTmsNdt+cpIRGTZ61kUu4l1mIISJtLFza3+yvbhm7NGt?=
 =?us-ascii?Q?VO/uzD3vRc6kzMvGvaJRqU0qUfkS6o3nSE8P17s6sB1miOAa?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b29dcc49-4ecd-4ef0-8dab-08deece4226e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2026 20:09:30.7540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pU4Tk5yzCLZKFDyKWrZYIZGA7uL7anXfnffoEID75H/VmuvhkJeEsLCCF/fHn2UC5IdQydHOCnlDc9KAct5rDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6320

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Add helpers to retrieve the send and receive queues of a QP.
> Use these helpers when storing queue IDs in the lookup table.
> MANA queue IDs are 2-bit aligned, allowing the two least significant bits=
 to
> be omitted when storing and looking up queue IDs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>

> ---
> v4->v5: inline store functions inside mana_table_store_qp() to
> v4->explicitly
> see the call of drain at the same level.
>  drivers/infiniband/hw/mana/mana_ib.h | 30 +++++++++
>  drivers/infiniband/hw/mana/qp.c      | 97 ++++++++++++----------------
>  2 files changed, 71 insertions(+), 56 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> index da05966af..18688072f 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -26,6 +26,8 @@
>=20
>  /* Send queue ID mask */
>  #define MANA_SENDQ_MASK	BIT(31)
> +/* Queue ID encodes type in the lower 2 bits */ #define
> +MANA_QID_SUBTYPE_MASK 0x3
>=20
>  /*
>   * The hardware limit of number of MRs is greater than maximum number of
> MRs @@ -582,12 +584,40 @@ static inline struct gdma_context
> *mdev_to_gc(struct mana_ib_dev *mdev)
>  	return mdev->gdma_dev->gdma_context;
>  }
>=20
> +static inline struct mana_ib_queue *mana_qp_get_sq(struct mana_ib_qp
> +*qp) {
> +	switch (qp->ibqp.qp_type) {
> +	case IB_QPT_RC:
> +		return &qp-
> >rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER];
> +	case IB_QPT_UD:
> +	case IB_QPT_GSI:
> +		return &qp->ud_qp.queues[MANA_UD_SEND_QUEUE];
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static inline struct mana_ib_queue *mana_qp_get_rq(struct mana_ib_qp
> +*qp) {
> +	switch (qp->ibqp.qp_type) {
> +	case IB_QPT_RC:
> +		return &qp-
> >rc_qp.queues[MANA_RC_RECV_QUEUE_RESPONDER];
> +	case IB_QPT_UD:
> +	case IB_QPT_GSI:
> +		return &qp->ud_qp.queues[MANA_UD_RECV_QUEUE];
> +	default:
> +		return NULL;
> +	}
> +}
> +
>  static inline struct mana_ib_qp *mana_get_qp_ref(struct mana_ib_dev
> *mdev,
>  						 u32 qid, bool is_sq)
>  {
>  	struct mana_ib_qp *qp;
>  	unsigned long flag;
>=20
> +	/* Remove subtype bits */
> +	qid &=3D ~MANA_QID_SUBTYPE_MASK;
>  	if (is_sq)
>  		qid |=3D MANA_SENDQ_MASK;
>=20
> diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index c52f3ec14..47e1fadbd 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -461,89 +461,74 @@ static enum gdma_queue_type
> mana_ib_queue_type(struct ib_qp_init_attr *attr, u32
>  	return type;
>  }
>=20
> -static int mana_table_store_rc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp)
> +static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
>  {
> -	return xa_insert_irq(&mdev->qp_table_wq, qp->ibqp.qp_num, qp,
> -			     GFP_KERNEL);
> +	mana_put_qp_ref(qp);
> +	wait_for_completion(&qp->free);
>  }
>=20
> -static void mana_table_remove_rc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp)
> +static int mana_table_store_qp_qid(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp,
> +				   u32 qid, bool is_sq)
>  {
> -	xa_erase_irq(&mdev->qp_table_wq, qp->ibqp.qp_num);
> +	/* Remove subtype bits */
> +	qid &=3D ~MANA_QID_SUBTYPE_MASK;
> +	if (is_sq)
> +		qid |=3D MANA_SENDQ_MASK;
> +
> +	return xa_insert_irq(&mdev->qp_table_wq, qid, qp, GFP_KERNEL);
>  }
>=20
> -static void mana_table_drain_qp_ref(struct mana_ib_qp *qp)
> +static void mana_table_remove_qp_qid(struct mana_ib_dev *mdev, u32
> qid,
> +bool is_sq)
>  {
> -	mana_put_qp_ref(qp);
> -	wait_for_completion(&qp->free);
> +	/* Remove subtype bits */
> +	qid &=3D ~MANA_QID_SUBTYPE_MASK;
> +	if (is_sq)
> +		qid |=3D MANA_SENDQ_MASK;
> +
> +	xa_erase_irq(&mdev->qp_table_wq, qid);
>  }
>=20
> -static int mana_table_store_ud_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp)
> +static int mana_table_store_qp(struct mana_ib_dev *mdev, struct
> +mana_ib_qp *qp)
>  {
> -	u32 qids =3D qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id |
> MANA_SENDQ_MASK;
> -	u32 qidr =3D qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
> +	struct mana_ib_queue *sq, *rq;
>  	int err;
>=20
> -	err =3D xa_insert_irq(&mdev->qp_table_wq, qids, qp, GFP_KERNEL);
> +	refcount_set(&qp->refcount, 1);
> +	init_completion(&qp->free);
> +	sq =3D mana_qp_get_sq(qp);
> +	rq =3D mana_qp_get_rq(qp);
> +
> +	if (!sq || !rq)
> +		return -EINVAL;
> +
> +	err =3D mana_table_store_qp_qid(mdev, qp, sq->id, true);
>  	if (err)
>  		return err;
>=20
> -	err =3D xa_insert_irq(&mdev->qp_table_wq, qidr, qp, GFP_KERNEL);
> +	err =3D mana_table_store_qp_qid(mdev, qp, rq->id, false);
>  	if (err)
> -		goto remove_sq;
> +		goto err_remove_sq;
>=20
>  	return 0;
>=20
> -remove_sq:
> -	xa_erase_irq(&mdev->qp_table_wq, qids);
> +err_remove_sq:
> +	mana_table_remove_qp_qid(mdev, sq->id, true);
>  	mana_table_drain_qp_ref(qp);
>  	return err;
>  }
>=20
> -static void mana_table_remove_ud_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp) -{
> -	u32 qids =3D qp->ud_qp.queues[MANA_UD_SEND_QUEUE].id |
> MANA_SENDQ_MASK;
> -	u32 qidr =3D qp->ud_qp.queues[MANA_UD_RECV_QUEUE].id;
> -
> -	xa_erase_irq(&mdev->qp_table_wq, qids);
> -	xa_erase_irq(&mdev->qp_table_wq, qidr);
> -}
> -
> -static int mana_table_store_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp)
> +static void mana_table_remove_qp(struct mana_ib_dev *mdev, struct
> +mana_ib_qp *qp)
>  {
> -	refcount_set(&qp->refcount, 1);
> -	init_completion(&qp->free);
> -
> -	switch (qp->ibqp.qp_type) {
> -	case IB_QPT_RC:
> -		return mana_table_store_rc_qp(mdev, qp);
> -	case IB_QPT_UD:
> -	case IB_QPT_GSI:
> -		return mana_table_store_ud_qp(mdev, qp);
> -	default:
> -		ibdev_dbg(&mdev->ib_dev, "Unknown QP type for storing in
> mana table, %d\n",
> -			  qp->ibqp.qp_type);
> -	}
> +	struct mana_ib_queue *sq, *rq;
>=20
> -	return -EINVAL;
> -}
> +	sq =3D mana_qp_get_sq(qp);
> +	rq =3D mana_qp_get_rq(qp);
>=20
> -static void mana_table_remove_qp(struct mana_ib_dev *mdev,
> -				 struct mana_ib_qp *qp)
> -{
> -	switch (qp->ibqp.qp_type) {
> -	case IB_QPT_RC:
> -		mana_table_remove_rc_qp(mdev, qp);
> -		break;
> -	case IB_QPT_UD:
> -	case IB_QPT_GSI:
> -		mana_table_remove_ud_qp(mdev, qp);
> -		break;
> -	default:
> -		ibdev_dbg(&mdev->ib_dev, "Unknown QP type for removing
> from mana table, %d\n",
> -			  qp->ibqp.qp_type);
> +	if (!sq || !rq)
>  		return;
> -	}
> +
> +	mana_table_remove_qp_qid(mdev, sq->id, true);
> +	mana_table_remove_qp_qid(mdev, rq->id, false);
>  	mana_table_drain_qp_ref(qp);
>  }
>=20
> --
> 2.43.0

