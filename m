Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021141.outbound.protection.outlook.com [52.101.57.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7363939A2;
	Fri, 28 Aug 2026 19:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787946272; cv=fail; b=W6FqrbYaLlARVHwsV41DBd6Iakaukr1l2qObCyC8WF4sixY1kQDxJwgofzt02xJKQVTpsyzABgAVe5hYH37r9OM/XzM623GZt6DP+N4I43HpvzH/CB8PARrqavr7ZJLMtc21BZ+HVjcGtk51c5EsFrWoFQzyMkHRDJoYvxHMtc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787946272; c=relaxed/simple;
	bh=+Ef9B00QgtKWrS5+DK6Ejf0931WC45frgWRf7f0LOHU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n58/b6OV71uK2Ni3pTM1HoJp6/bdpHeK9Y3Gsw4qGxm4GOdpTVKu2cBep94CxBysIZ7M/d/OaRsYWm28CDJJm+hWy/J41dguDzLolXUJkCiqwy4cKdJqBN45vRqhXHUcgPvGb88FtQEm7nUBydtQtGfcQBojeLzJGa+xv2zfB7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=gPocWFD+; arc=fail smtp.client-ip=52.101.57.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="gPocWFD+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVMQesn5J5RccJeV7mZqtN8jtKDHVVB/nHOpKGIATA85gOVw+lzIdLYW/2RfGO2bogKQtYiOfSdKH7VwwICKZpW/MiEUFx2LLDQy2WFJAnOJlNOvCXz+DJK5K666RWeiLbyI7c1TwsONAI4Ehuluwy8KtFs8dbuej2xeYm6LZlj0OcHW1Rk+pnhL/AF6qCNrEvgu6fqJ9pWetx/K+B/juIkS1lovX/iREZAooEe2dSICPHUDoLHdM2ftbeIDvgdo+/Lp71gedN4oMy1pMGjpfG/+PPKm+J3FSaKIblArCAFTfvknGxl22XR/tV6Ust8AWCMLsiPT0JUqQe+bZd4eVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp7gLx0mBhCRxapxJlASgK2m171jFX1Tc/NTliITul0=;
 b=QkPqXg69nO9nhOmbX/LIV/D+1rUHyI0MWOtiobkcocLhfSKQ0LcRHoB0PpFS11MkhTCaJnWKk6JwXlnFJVjhqU47tQSqxChEFtr+7l68mj6GbZH4ojG4En16z7hw2YPrOR4UHw5NtoVNu1XLe6m/HpvbvtX3Je92cirAapWT5Mkud+1JF13NqsTuDsHk+2u2o4ItDLVaa7D+8Vnpa/u8FiI2tIAbmlF+W/h8RBI/4L4w3alPqtQYgAW38gUHH2VMPOPBuU1CsFwHtIbL9gn2Cr1hbFx7MlwhgyKAOLb1I+fDHftBgU0O/NuiJXjMxVLQ3M4+HxvhITYqP3ljiopbRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp7gLx0mBhCRxapxJlASgK2m171jFX1Tc/NTliITul0=;
 b=gPocWFD+ljrxkLAscWSMFgIwotExAcpuzdpwkdmJWw/rzCwMqdG374K37bLRqjKmnL7x9lEzedo7B/kTBWnnazjgpvJTXAMOsGA4niCtIY6I6Swh5KJrtUZDi3S1FYc2MHKyOiB2UpAsBJdAPb8BK8DMiISbRN0AabtgvnL6w9Q=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA3PR21MB5720.namprd21.prod.outlook.com (2603:10b6:806:498::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Fri, 28 Aug
 2026 19:44:27 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Fri, 28 Aug 2026
 19:44:26 +0000
From: Long Li <longli@microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, Snehal Sanghvi <snsanghvi@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next v2 3/3] RDMA/mana_ib: fixed send wqe size
 support for RC QPs
Thread-Topic: [PATCH rdma-next v2 3/3] RDMA/mana_ib: fixed send wqe size
 support for RC QPs
Thread-Index: AQHdNjGwIom3UJuOs06lRm6Pp2DwMraz3s2w
Date: Fri, 28 Aug 2026 19:44:26 +0000
Message-ID:
 <SA1PR21MB6683F6B321B56C462F376240CEAC2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
 <20260827143736.2013093-4-kotaranov@linux.microsoft.com>
In-Reply-To: <20260827143736.2013093-4-kotaranov@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9704c345-a029-49c9-9e74-f346ba6da84d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-28T19:44:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA3PR21MB5720:EE_
x-ms-office365-filtering-correlation-id: c07fb08b-9770-4495-b7b2-08df053cc4d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|22082099003|18002099003|11063799006|38070700021|7146999003|10067099003|56012099006|4143699003;
x-microsoft-antispam-message-info:
 5TmBQqMxr4ENoLkvoVvKLJTpETFnQVfDMSvyg382VXchjuWCI6bzjhUJn1i69X9ZhWZK2jPmDixlKl9JSAaBlf1OlfXoKLgiGP9rjrGbEVsJK34IugZ0XNLMzznNxIkYQisB2Qv8Z0TbnTkQ8+jiMEfmXvysoBvIiswfStZ0vCrhBY6k+WIaxfKAQZ3ipGQCbDPWrSj80BascLj6f31EoohG8B4pdajV8CjJMP6+WqmMnBPIh0ID3I7L+igWyp2FPsOlPPw4OUP4R/ODAXrTMD9ZNh2LLu7blFhhynQ5X87EyRSnZD55j/6jZYD/eRlrrRqeB7tl5jekQFkt+F4ZGxkVgNhga+g4m7wHcO0ARIwBIAxlHB4AHagDbwHetbmaWTqdQ/r9sTNPrK1KBJI/J17vyF7tuzSZjBn8H3hH2az5U5mZAverUWCrI/H6p/wJmIscA4hlgV7HnK/z1yilo1wPJGiLcajUcNloIiE7puJvy+nAa7KOd6bzv76oquA/XK9Ac6yYKKqa2cUBSsni5PorZ2FqqyQraqXP9ayO3CevKn2mqhbIPVTCV+FJPG0euvqKMuCeXN6+qQmsHDgmkP7Lfm6aJ0t2QjyIL+xgKPqTcO7oIXHCKVt+Mf4vH39PxlcbbDoQ7xTYRSiu+lnyZWFx/WzxtGUqgF/yyJwW8MgU1dKPasE6km+U483cveoKkygNukBnh+0yWTT7T3cTgNL9R4QgjypZuF/YKDEIXBs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(11063799006)(38070700021)(7146999003)(10067099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1Yo2ibhX3c3YhbXAADao190aAM+1RwxwJwHKlKBBqXsdlHhybJar0TqeWHc5?=
 =?us-ascii?Q?8i7s4/QNn4YE/9+HW8hy9VoGTTwnx6R98bK6QoaCST2ieDato2A7fEn+EF31?=
 =?us-ascii?Q?LiuO/x8zfNXYZIrQSjy2sa523n5FVT9LVgp25F3MoXtcqZgP7rZJmkIGkyTi?=
 =?us-ascii?Q?18uP2TSkY977kQi5IjyXccxaxuohwcy3LrhqN7lY0r0n9xWW/F1uavlB5f2v?=
 =?us-ascii?Q?xiP9YhkAq+I8STkYl+aZ79QyvPyRJosm71q0FPks4C235FrgPV2mq2+zJMxe?=
 =?us-ascii?Q?DN+mVmqOvA9LnLgaF+6eiV0ZVyNEhwpgUds9PVbZ4bb0/bPnYIR+5BU9kcA1?=
 =?us-ascii?Q?pQB7YIrM2vVCTnPRAcInl5MaN68T5TYpxhKfu01f7HH/2HmDAMJftC8FXHv4?=
 =?us-ascii?Q?LbdlXvGSpjgJHObyv+VIO6kZAlXwqNjS9HKWAsm/Fxu0M4IXTIsrMsLYdOM4?=
 =?us-ascii?Q?ye2HPilivTMdQsGV/+su4iZ+3K1NztaHLsefhv7zJF7ila2Wj0SlJj2d4I90?=
 =?us-ascii?Q?1wnBks2KTevUjHKKUiImSc/reEcR5cIlrZj+9Vv249iMea2AoeRPw2jjEeRK?=
 =?us-ascii?Q?EoTD1Rlr1Sybce2mW4wRDnoJDSeLFTvhnT+vcOAz8uq257QXUivQ04co3UoH?=
 =?us-ascii?Q?j+/IqbtcqLPD0RKCZlb/II/zF0CdDDoXdXm8UTAHSBQ+XtvO5gTJobvFjQTg?=
 =?us-ascii?Q?q7UAMMhL0BBAGxH1w0O8CTEpR+YukVTajryjwdpxkYpC0XZ8lIR91zpLPa02?=
 =?us-ascii?Q?CKBktSgof7PD0rNNesC+sinrP5ZFAqkZ9E7le/QYCekG160ltGy70yoYYdOf?=
 =?us-ascii?Q?UIa2RZxMLMmjiSYerpHZF+gnGXXOOQZGhKQvHezh64UYxRI6RYLkXyt4nGkh?=
 =?us-ascii?Q?nCG63NgcaBvzUVSJR1r6l+Uv7p6zemsvmK2hylH1AqAYo6LQ2eRdLkkRTYEx?=
 =?us-ascii?Q?5OVTKGBsNM1vn8fgP1En4C7EvWbOjFDb6+PjOJsxXhM+k1xa417Gg/Wdy9j5?=
 =?us-ascii?Q?Crit6A8MlAIOvG6JGiLBFoBY0/PSbWscROz7+MqDCwb6zyHY0y5M1N929bj2?=
 =?us-ascii?Q?cETymMucaJL6PF+Fz/IVd0HO9Buj8Ic6OARPH1c7yaoBOPJybBj5wyknga0F?=
 =?us-ascii?Q?nP9cIvdxLZOQD2Mgb9b/TuwnrCJVXPVRY0h8b1+zSSQgA37MBF6dt8S5iqkh?=
 =?us-ascii?Q?y/6lfhdHxBmjKqPXLD+ijmlKD7T6dysdgTbfDVIrF/UF/NPOG4BhAXzYsqxP?=
 =?us-ascii?Q?bbDhbsAHkQzHL1h8Rx6WJZQ2VIW7bq0KgZhEQBVeon7rKa8H9ZRX1TqashmB?=
 =?us-ascii?Q?nfnZQbvclROM48I8D+3vfF0lxKiueq+2mLxmZg/UpxhRurZNNhZQ4f5a4lCM?=
 =?us-ascii?Q?RYrj3gQ5xntUsY7rsBdaru/X9DN2wcPGHfS/5tgB6IDsnJ/XsOyG5cFQNNaW?=
 =?us-ascii?Q?L6OqBC0BwY/tQVxzyILpB/N/hbKc2sIoyAdd2+K1MW1Dd3XO8I5nhQ/FXnw9?=
 =?us-ascii?Q?hmZQzFHzhfih2cGtk8Hei5jyaSp5C7N691TZx25VTq1NB20Il4wtVAnxfGDh?=
 =?us-ascii?Q?8W/BKvj/9Y8ztAgEx4umoPIyxugiWRHserBoPeFDK6xT2kTgtJ60sRrSQPXn?=
 =?us-ascii?Q?DAGANGWTBhfcxMdW31tzPFcQ88lVk9PGN9rEHi7E7kBkKzAS5Fs8ykec0nSc?=
 =?us-ascii?Q?lWNKJwxj53WAUxHJEc3D/rqqochik0uFO2dEL4dgh5zIdOzw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c07fb08b-9770-4495-b7b2-08df053cc4d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 19:44:26.7688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6WdDjlmL27F4lkd6s4Sm+6oWtlp5lQGZKsUhJfjX1JC12lxEcgyAfnHG3Suq2QWDedMOLRm9vDoO/jbju5NmHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB5720

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Support fixed-size send WQEs for RC QPs when requested by userspace.
> Calculate the WQE size from the maximum send SGE count and the 32-byte
> inline OOB size, round it up to a power of two, and pass the size to hard=
ware in
> basic units.
>=20
> When supported by the adapter, also enable placing the message sequence
> number in the WQE. Preserve the existing variable-size WQE behavior when
> userspace does not request fixed-size WQEs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>




> ---
>  drivers/infiniband/hw/mana/main.c    |  3 +++
>  drivers/infiniband/hw/mana/mana_ib.h |  5 ++++-
>  drivers/infiniband/hw/mana/qp.c      | 14 ++++++++++++++
>  include/net/mana/gdma.h              |  1 +
>  4 files changed, 22 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/main.c
> b/drivers/infiniband/hw/mana/main.c
> index 9d043f48e..57c6d9faa 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -1060,6 +1060,9 @@ int mana_ib_gd_create_rc_qp(struct mana_ib_dev
> *mdev, struct mana_ib_qp *qp,
>  	req.max_recv_sge =3D attr->cap.max_recv_sge;
>  	req.flags =3D flags;
>=20
> +	if (flags & MANA_RC_FLAG_FIXED_SIZE_WQE)
> +		req.wqe_size_in_bu =3D qp->rc_qp.wqe_size_in_bu;
> +
>  	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> &resp);
>  	if (err)
>  		return err;
> diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> index 547ddf9dd..828ca75fd 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -180,6 +180,7 @@ enum mana_rc_queue_type {
>=20
>  struct mana_ib_rc_qp {
>  	struct mana_ib_queue queues[MANA_RC_QUEUE_TYPE_MAX];
> +	u32 wqe_size_in_bu;
>  };
>=20
>  enum mana_uc_queue_type {
> @@ -262,6 +263,7 @@ enum mana_ib_adapter_features {
>  	MANA_IB_FEATURE_CLIENT_ERROR_CQE_SUPPORT =3D BIT(4),
>  	MANA_IB_FEATURE_DEV_COUNTERS_SUPPORT =3D BIT(5),
>  	MANA_IB_FEATURE_MULTI_PORTS_SUPPORT =3D BIT(6),
> +	MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT =3D BIT(7),
>  };
>=20
>  struct mana_ib_query_adapter_caps_resp { @@ -391,7 +393,8 @@ struct
> mana_rnic_create_qp_req {
>  	u32 max_recv_wr;
>  	u32 max_send_sge;
>  	u32 max_recv_sge;
> -	u32 reserved;
> +	u8 wqe_size_in_bu;
> +	u8 reserved[3];
>  }; /* HW Data */
>=20
>  struct mana_rnic_create_qp_resp {
> diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index c6821ae5f..29bfee9ac 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -422,6 +422,11 @@ static u32 mana_ib_wqe_size(u32 sge, u32 oob_size)
>  	return ALIGN(wqe_size, GDMA_WQE_BU_SIZE);  }
>=20
> +static u32 mana_ib_fixed_wqe_size(u32 sge, u32 oob_size) {
> +	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size)); }
> +
>  static u32 mana_ib_queue_size(struct ib_qp_init_attr *attr, u32 queue_ty=
pe)  {
>  	u32 queue_size;
> @@ -576,6 +581,15 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>  		j++;
>  	}
>=20
> +	if (ucmd.comp_mask & MANA_IB_RC_QP_FIXED_WQE) {
> +		u32 wqe_size =3D mana_ib_fixed_wqe_size(attr-
> >cap.max_send_sge,
> +
> INLINE_OOB_EXTRA_LARGE_SIZE);
> +		flags |=3D MANA_RC_FLAG_FIXED_SIZE_WQE;
> +		if (mdev->adapter_caps.feature_flags &
> MANA_IB_FEATURE_MSN_IN_WQE_SUPPORT)
> +			flags |=3D MANA_RC_FLAG_MSN_IN_WQE;
> +		qp->rc_qp.wqe_size_in_bu =3D wqe_size /
> GDMA_WQE_BU_SIZE;
> +	}
> +
>  	err =3D mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
>  	if (err) {
>  		ibdev_err(&mdev->ib_dev, "Failed to create rc qp  %d\n", err);
> diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h index
> de17c9bba..f3601ca78 100644
> --- a/include/net/mana/gdma.h
> +++ b/include/net/mana/gdma.h
> @@ -522,6 +522,7 @@ struct gdma_wqe {
>=20
>  #define INLINE_OOB_SMALL_SIZE 8
>  #define INLINE_OOB_LARGE_SIZE 24
> +#define INLINE_OOB_EXTRA_LARGE_SIZE 32
>=20
>  #define MANA_MAX_TX_WQE_SGL_ENTRIES 30
>=20
> --
> 2.43.0

