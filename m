Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020125.outbound.protection.outlook.com [40.93.198.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF993CF69C;
	Tue, 28 Jul 2026 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785269623; cv=fail; b=U+BzO2cOj4jB3OCTj3xymWxH8wu5ewa8VxACYgKmEf7Do3T50qEQB/kjg/6uKAhhG83EWj1OBQb3TgljlTwpKSxkR2kDlGYpIrwz6RuZR/p5kT7U3KIYFTPne/cFB1hdx4oWeAma4ZGe3CONEeLWHK2+g5lWPKZOX80jFHejq8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785269623; c=relaxed/simple;
	bh=nOvF9GVyOghEdWldZf78oYeLdzYdsEAKoirlC5Die2w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vAb9Da7uhDA08y1Sw3FzdRT8tz90UBmQ4ZuZO1HOLLX7I0Zi+2mxf9nNr/uczdZ7lKbulFBHUI6ASw9UP5uOTNyAzI61XRTM74nZOlSQif4NGu2CNhsePEZ0MjFXjHzd/xZGa1rJ2taxwVnEGWQFMjyMkIdlxJOI8Yj+l2nS1sE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=i0Wfl/ZY; arc=fail smtp.client-ip=40.93.198.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="i0Wfl/ZY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AB7W1Mv4HyonqHXOK4F9TuPm51zehKX0HJCo8HucF9QpLWnKt3LN+BPTKddcrKPqsn0JQ/2yuI26WwGaEl15IsNA/jn6erpXghwGlgDk+C1nCdBO4t7xjrOAkDju4DaRcdORLDWriu5sh0Sa6zJ5RtjXq8JyH1oTXpTR+/W7s2dGsgXxet0MR0Q9WlDN9kn2CY24OPX/jqh5YqmwTJZGh6xRVd9uOWECFtigCOvR2mOP51+98Q0bUQARxF/+f4ndUuSzRVcWhXcO8+RZ18vm0wkVeLyCIDpNFHIzU7i0lNrbUgn/5uYE9Rg+WQYJZuUjyGfct8r/+q5kl92kNTdLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QzVyhA8OARTZn+XPjKRtx2aiAlQiLfFnrlAZA040RE=;
 b=jymvYTD/mbabCdKl9BpNvmC/f04sKQBpDou5ScYNKIQO77CCIMzBeATW86VVd/asc1EVF7OAFkobfbpiSYm5e7aQ6JR/OzvTC6CIo49zkPuvXcsp+9Y62kuQxs27c30VXZ/kahyC51XRD2fEmDpgAOULu4KC+qNe8E/1otAG2/0kZWldTrHvbcmG/EF8tJhN46nY1ra7iw6zPXd5sPTPo9hFrCB3KK1DpQ98jwaDAzxh7jQdCDRYfhP15gILOvCsnJgl7KWFlcf8s9vTebukwfRnznBHfo/pBzTAkT8NIzog+jrgFOmDmRIywSzBZRM3Mnz6NlgE/WCEPaWSVWYmig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QzVyhA8OARTZn+XPjKRtx2aiAlQiLfFnrlAZA040RE=;
 b=i0Wfl/ZYZyaMhxpNjq+l/4LZ+Kw2pFCqn9yrLFjCM6YFAyLnSNoA+MTEHpF/ylOJvLEbOW7YYKAu2TOQNxeZK2Ne94IkT/SU5BzpsuU4KAs65yMXWv1X3nN+WQ+go5M1Xt13GypGttX42+zcBQdJU9ndPbNP62vllOS2Xt74198=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB6515.namprd21.prod.outlook.com (2603:10b6:806:4b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 28 Jul
 2026 20:13:38 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%3]) with mapi id 15.21.0159.007; Tue, 28 Jul 2026
 20:13:38 +0000
From: Long Li <longli@microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org"
	<leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next v5 2/2] RDMA/mana_ib: UC QP support for UAPI
Thread-Topic: [PATCH rdma-next v5 2/2] RDMA/mana_ib: UC QP support for UAPI
Thread-Index: AQHdGprV5mFshKHDGEWcEMSIN4/cSLaDZPrQ
Date: Tue, 28 Jul 2026 20:13:38 +0000
Message-ID:
 <SA1PR21MB66834B03039F87100132770DCECB2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
 <20260723115955.1859519-3-kotaranov@linux.microsoft.com>
In-Reply-To: <20260723115955.1859519-3-kotaranov@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8d0dbe34-a74d-4624-9d5b-c87facb316cf;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-28T20:10:10Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB6515:EE_
x-ms-office365-filtering-correlation-id: 0a81aff5-b31b-4a43-8be2-08deece4b62c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|6133799003|11063799006|10067099003|56012099006|4143699003|22082099003|7146999003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 gRauC5vAoLQCMgjQwDvCvSWEREQwBeddl7HSOeA/YHZ3WRz77NmaXYZNxfpBCB3KN1RKZ2AIVnXEj3vs6EsFM8rxgm2skzezxQ/v6aWQE61N4hg71n/2lWCpjH8x3ak0NneN9ibQbTYQaN2ROvYYqoAj7j/aHohEJ/lXo6WneC6wLDn++9r/II6XaLWIZKGu8JGuLANt4W7okHjLa7Akd68QapUU3fx+Y0rCNZK/ww58HYqP7GzUWnkLp3c7jlbgqEq9LyQpEkxeJqu/1EcyUQhyudpFo3JSbuahGAZNGP+gV012PUhYYdIymlY/QLEiN4J/lZG+ZWgm7Wch/4VyAn1osR3s1TcYkm7vD+bUWFirjtzlwhPVmPu9977mPAlu49ZFtD5iyW3YlTYWoA2TN0EUAwj6VkOd3WHMn9SJkOBEuLxJrS9G0/kTGRv8qv8hAumGCE47hijJ989JYfkFq6VarfD5oynb9s24U7TzAXKuw/GPOBtxrS4B3gbnoCXh3JQEpc97YeVv/2r0yz8oQyaeMvBQ60CavvdwhQBfYVjmUO91mX6WRrsWT5/hffjdEqMw11ZjsHPU6W3pa32VHKjytHnAGYdxBT/k0fmLhCygFwe6PT9PVB+jdUc0DSmVUiCnLEw9+fd1XWVtAj6zRZYtCjyMRjQ+aPBaarieP5Ma9nIl2tXwFVkidnbg3tW1weiKBbxYc25wx1VPbggd3+rJ1BoWiJ8OA1PZipT84+E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003)(22082099003)(7146999003)(18002099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?XqbTktyXuMYI1CxAWOgq6OS1ndMM5gtC6mQ701h7eeTKS7mvm/LzX7XXPnXf?=
 =?us-ascii?Q?7iPaKkMmElEd9ri6oMlhoH6+enPzVfVtvS3lXQR+pVWy8nkImz7UtZ/xcrYz?=
 =?us-ascii?Q?BjL9ZX/3/rZ3OQFCQ4V4mmvgNFAlSAB81HOQC9/kcrbIFcVAFBt3QqN3zxuJ?=
 =?us-ascii?Q?PH9m4BCulVestU2EnKuG/KK/wXmMc1rK0cS1GVKpUis5/jqbdXkx1RDVKF8P?=
 =?us-ascii?Q?0rPy4hpsK2TPK6O1bnFDkXtd1UsY3pNCQefxw2qdrbcppMmXc4Hpu0Q5sng/?=
 =?us-ascii?Q?ukH1rSmzbp0VKJsH5IWjJA140033SulNMDD1cjyPzgKocGNI/aWKQBRHxAa+?=
 =?us-ascii?Q?VxBeYSJDnUff676s+YYWeW1Om4N68H77/LTBJU5HFWJCGcAxKJEJmArl5BrE?=
 =?us-ascii?Q?8yGEHdZBVp/Ne0RjBCUugwt5FXCuBidNfuVfpWTlpyKmzxDHO9cyMJdTqJTM?=
 =?us-ascii?Q?q+ThgcvLv+j+tApiqcYdGmHtFdMPolaSbpcTW6pdOrZ3L/ipg6GtErZxaUa0?=
 =?us-ascii?Q?rse4yPr+uX4Up/9N3XioFuqF4dAQBEKIbcMlUE6aE9E9spLXYamq8yzE7vx1?=
 =?us-ascii?Q?5hR1DEesMyiCOtJD++ySIgE4BnYmcTErkyHmyw17Jg8Y53BTL0uZkW6Yo/v+?=
 =?us-ascii?Q?05NFt6M0mvyFH8U7jgluU3lfcGsbJqsTsyN6D2Xi64hMCPUm0881i0+ANgVG?=
 =?us-ascii?Q?E8jLWiFrSdxaVc7k3uaWvkHyrRn5890Bqrd0y2diHPckEoQEzuYZxXtyHLWU?=
 =?us-ascii?Q?3QjGSs2LZBMRi/qyAKYsmLOQ7LopiJ3XHe0OJ63pz95uecWlqkPwWh0wuFvF?=
 =?us-ascii?Q?eJIfoT1ABWp+yi/XX0+CXUilai2LMDgqtJ7GBhRC2nGGrqM9bzUg+/fOUIL9?=
 =?us-ascii?Q?aY3CpsGPhbF3lweEhiQCO/2tf6V7H1D/2f5EXJPGSKFaWowspKbOsCFjnrMB?=
 =?us-ascii?Q?ZcxquQ47ILIcN9HCs/WuuIGQf1pk2GrV6KVH/BkZ4nQTGVlaBm3OMcAursdr?=
 =?us-ascii?Q?ou53lXzMzjJOLHEVqEMT/fNjVmcNGLKvoNPf4s8aM6ZH6bBZDateYfUjyRuu?=
 =?us-ascii?Q?kDodO+npb/lK9bQolTccnV7NPjgGJpoNSrdyT93jWvysDoIe7cIK+slcFRqS?=
 =?us-ascii?Q?xtTmmSLoPir5bF0EyIMuNhU3RHuqWLY1ODF4vw0oWCqhUHPmCfURRJ+9I8f3?=
 =?us-ascii?Q?uXFZ1eoW2K+Icv/xGWwFQcaUJdpjxTgSDWJVvRULOf6WDOZbWoWzArAwa0L+?=
 =?us-ascii?Q?k9HfIZ3v9pTqtc0oR97z2MhIRUwKdlxwRUFrSWe04YScNHwk1NhrQ1uCUBIX?=
 =?us-ascii?Q?jgl7cevBekQ3typ/vyxowzQTZNWHU9d9tamQnG96e4PLDo1QZTCDVgnnu7ER?=
 =?us-ascii?Q?kPqSoLYyl6Wru3iRx5d5ZtabnDCfFEWTAhcvkHBLJklNE4/0S3/aJuSXK2DZ?=
 =?us-ascii?Q?kOeMUoIS+TDwGIdT0EVMCWIVsiEJeLWAzFzcyhvKNoyx3wVizefyFDafgx/C?=
 =?us-ascii?Q?qZ8B7XJGuxoC4wA+5jr+1YZrJt5mFGR1psKb4AAkWm4P1gF38kmdpKSktIob?=
 =?us-ascii?Q?Obz6tPEeipXH+nrg4SrPfluM0CjoNJo5y6oqnc3gQedSG2L5fcqI+g4mO88O?=
 =?us-ascii?Q?JyqxVahOXa/4In+vapoZgIDjjTNJSsfXyrxA18tPYQD9qSImlrhd4rshN0lI?=
 =?us-ascii?Q?ELhSMs11jmvbsFn7lyRuzG/HBy4k/6cdk2mKO1CVyR63loYJ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a81aff5-b31b-4a43-8be2-08deece4b62c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2026 20:13:38.5999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: caSd47IfYYssxHPj5ZNrmnvHCPRQzpQ73626NMHt44CUpxrsx3xRcL9jWYkbLyldVvnPKEeJhk+4mXvtF1Fbug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB6515

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement UC QP creation in the RNIC HW for user API. An UC QP is exposed
> as three work queues: send, receive, and memory management. The latter is
> used for bind and invalidate WQEs to support memory windows.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>



> ---
> v5: no changes
> v4: renamed rc_qp destroy helper to rnic_qp. Use the latest robust udata =
API.
> Use new store/lookup introduced in 1/2
> v3: use new udata helpers
> v2: removed udata check and removed enum from mana-abi.h
>  drivers/infiniband/hw/mana/main.c    | 49 ++++++++++++++--
>  drivers/infiniband/hw/mana/mana_ib.h | 53 ++++++++++++++++--
>  drivers/infiniband/hw/mana/qp.c      | 84 +++++++++++++++++++++++++++-
>  include/uapi/rdma/mana-abi.h         | 11 ++++
>  4 files changed, 184 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/main.c
> b/drivers/infiniband/hw/mana/main.c
> index 0bfb1883a..52feb474b 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
> @@ -1046,16 +1046,55 @@ int mana_ib_gd_create_rc_qp(struct
> mana_ib_dev *mdev, struct mana_ib_qp *qp,
>  	return 0;
>  }
>=20
> -int mana_ib_gd_destroy_rc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp)
> +int mana_ib_gd_create_uc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp,
> +			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags)
>  {
> -	struct mana_rnic_destroy_rc_qp_resp resp =3D {0};
> -	struct mana_rnic_destroy_rc_qp_req req =3D {0};
> +	struct mana_ib_cq *send_cq =3D container_of(qp->ibqp.send_cq, struct
> mana_ib_cq, ibcq);
> +	struct mana_ib_cq *recv_cq =3D container_of(qp->ibqp.recv_cq, struct
> mana_ib_cq, ibcq);
> +	struct mana_ib_pd *pd =3D container_of(qp->ibqp.pd, struct
> mana_ib_pd,
> +ibpd);
>  	struct gdma_context *gc =3D mdev_to_gc(mdev);
> +	struct mana_rnic_create_uc_qp_resp resp =3D {};
> +	struct mana_rnic_create_uc_qp_req req =3D {};
> +	int err, i;
>=20
> -	mana_gd_init_req_hdr(&req.hdr, MANA_IB_DESTROY_RC_QP,
> sizeof(req), sizeof(resp));
> +	mana_gd_init_req_hdr(&req.hdr, MANA_IB_CREATE_UC_QP,
> sizeof(req),
> +sizeof(resp));
>  	req.hdr.dev_id =3D mdev->gdma_dev->dev_id;
>  	req.adapter =3D mdev->adapter_handle;
> -	req.rc_qp_handle =3D qp->qp_handle;
> +	req.pd_handle =3D pd->pd_handle;
> +	req.send_cq_handle =3D send_cq->cq_handle;
> +	req.recv_cq_handle =3D recv_cq->cq_handle;
> +	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; i++)
> +		req.dma_region[i] =3D qp->uc_qp.queues[i].gdma_region;
> +	req.doorbell_page =3D doorbell;
> +	req.max_send_wr =3D attr->cap.max_send_wr;
> +	req.max_recv_wr =3D attr->cap.max_recv_wr;
> +	req.max_send_sge =3D attr->cap.max_send_sge;
> +	req.max_recv_sge =3D attr->cap.max_recv_sge;
> +	req.flags =3D flags;
> +
> +	err =3D mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> &resp);
> +	if (err)
> +		return err;
> +
> +	qp->qp_handle =3D resp.qp_handle;
> +	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; i++) {
> +		qp->uc_qp.queues[i].id =3D resp.queue_ids[i];
> +		/* The GDMA regions are now owned by the RNIC QP handle
> */
> +		qp->uc_qp.queues[i].gdma_region =3D
> GDMA_INVALID_DMA_REGION;
> +	}
> +	return 0;
> +}
> +
> +int mana_ib_gd_destroy_rnic_qp(struct mana_ib_dev *mdev, struct
> +mana_ib_qp *qp) {
> +	struct mana_rnic_destroy_rnic_qp_resp resp =3D {0};
> +	struct mana_rnic_destroy_rnic_qp_req req =3D {0};
> +	struct gdma_context *gc =3D mdev_to_gc(mdev);
> +
> +	mana_gd_init_req_hdr(&req.hdr, MANA_IB_DESTROY_RNIC_QP,
> sizeof(req), sizeof(resp));
> +	req.hdr.dev_id =3D mdev->gdma_dev->dev_id;
> +	req.adapter =3D mdev->adapter_handle;
> +	req.qp_handle =3D qp->qp_handle;
>=20
>  	return mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp),
> &resp);  } diff --git a/drivers/infiniband/hw/mana/mana_ib.h
> b/drivers/infiniband/hw/mana/mana_ib.h
> index 18688072f..f69866696 100644
> --- a/drivers/infiniband/hw/mana/mana_ib.h
> +++ b/drivers/infiniband/hw/mana/mana_ib.h
> @@ -182,6 +182,17 @@ struct mana_ib_rc_qp {
>  	struct mana_ib_queue queues[MANA_RC_QUEUE_TYPE_MAX];  };
>=20
> +enum mana_uc_queue_type {
> +	MANA_UC_SEND_QUEUE_REQUESTER =3D 0,
> +	MANA_UC_RECV_QUEUE_RESPONDER,
> +	MANA_UC_SEND_QUEUE_MMQ,
> +	MANA_UC_QUEUE_TYPE_MAX,
> +};
> +
> +struct mana_ib_uc_qp {
> +	struct mana_ib_queue queues[MANA_UC_QUEUE_TYPE_MAX]; };
> +
>  enum mana_ud_queue_type {
>  	MANA_UD_SEND_QUEUE =3D 0,
>  	MANA_UD_RECV_QUEUE,
> @@ -200,6 +211,7 @@ struct mana_ib_qp {
>  	union {
>  		struct mana_ib_queue raw_sq;
>  		struct mana_ib_rc_qp rc_qp;
> +		struct mana_ib_uc_qp uc_qp;
>  		struct mana_ib_ud_qp ud_qp;
>  	};
>=20
> @@ -235,8 +247,9 @@ enum mana_ib_command_code {
>  	MANA_IB_CREATE_CQ       =3D 0x30008,
>  	MANA_IB_DESTROY_CQ      =3D 0x30009,
>  	MANA_IB_CREATE_RC_QP    =3D 0x3000a,
> -	MANA_IB_DESTROY_RC_QP   =3D 0x3000b,
> +	MANA_IB_DESTROY_RNIC_QP =3D 0x3000b,
>  	MANA_IB_SET_QP_STATE	=3D 0x3000d,
> +	MANA_IB_CREATE_UC_QP    =3D 0x30020,
>  	MANA_IB_QUERY_VF_COUNTERS =3D 0x30022,
>  	MANA_IB_QUERY_DEVICE_COUNTERS =3D 0x30023,  }; @@ -386,16
> +399,39 @@ struct mana_rnic_create_qp_resp {
>  	u32 reserved;
>  }; /* HW Data*/
>=20
> -struct mana_rnic_destroy_rc_qp_req {
> +struct mana_rnic_destroy_rnic_qp_req {
>  	struct gdma_req_hdr hdr;
>  	mana_handle_t adapter;
> -	mana_handle_t rc_qp_handle;
> +	mana_handle_t qp_handle;
>  }; /* HW Data */
>=20
> -struct mana_rnic_destroy_rc_qp_resp {
> +struct mana_rnic_destroy_rnic_qp_resp {
>  	struct gdma_resp_hdr hdr;
>  }; /* HW Data */
>=20
> +struct mana_rnic_create_uc_qp_req {
> +	struct gdma_req_hdr hdr;
> +	mana_handle_t adapter;
> +	mana_handle_t pd_handle;
> +	mana_handle_t send_cq_handle;
> +	mana_handle_t recv_cq_handle;
> +	u64 dma_region[MANA_UC_QUEUE_TYPE_MAX];
> +	u64 flags;
> +	u32 doorbell_page;
> +	u32 max_send_wr;
> +	u32 max_recv_wr;
> +	u32 max_send_sge;
> +	u32 max_recv_sge;
> +	u32 reserved;
> +}; /* HW Data */
> +
> +struct mana_rnic_create_uc_qp_resp {
> +	struct gdma_resp_hdr hdr;
> +	mana_handle_t qp_handle;
> +	u32 queue_ids[MANA_UC_QUEUE_TYPE_MAX];
> +	u32 reserved;
> +}; /* HW Data*/
> +
>  struct mana_rnic_create_udqp_req {
>  	struct gdma_req_hdr hdr;
>  	mana_handle_t adapter;
> @@ -589,6 +625,8 @@ static inline struct mana_ib_queue
> *mana_qp_get_sq(struct mana_ib_qp *qp)
>  	switch (qp->ibqp.qp_type) {
>  	case IB_QPT_RC:
>  		return &qp-
> >rc_qp.queues[MANA_RC_SEND_QUEUE_REQUESTER];
> +	case IB_QPT_UC:
> +		return &qp-
> >uc_qp.queues[MANA_UC_SEND_QUEUE_REQUESTER];
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		return &qp->ud_qp.queues[MANA_UD_SEND_QUEUE];
> @@ -602,6 +640,8 @@ static inline struct mana_ib_queue
> *mana_qp_get_rq(struct mana_ib_qp *qp)
>  	switch (qp->ibqp.qp_type) {
>  	case IB_QPT_RC:
>  		return &qp-
> >rc_qp.queues[MANA_RC_RECV_QUEUE_RESPONDER];
> +	case IB_QPT_UC:
> +		return &qp-
> >uc_qp.queues[MANA_UC_RECV_QUEUE_RESPONDER];
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		return &qp->ud_qp.queues[MANA_UD_RECV_QUEUE];
> @@ -766,8 +806,9 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev
> *mdev, struct mana_ib_cq *cq);
>=20
>  int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp,
>  			    struct ib_qp_init_attr *attr, u32 doorbell, u64
> flags); -int mana_ib_gd_destroy_rc_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp);
> -
> +int mana_ib_gd_destroy_rnic_qp(struct mana_ib_dev *mdev, struct
> +mana_ib_qp *qp); int mana_ib_gd_create_uc_qp(struct mana_ib_dev
> *mdev, struct mana_ib_qp *qp,
> +			    struct ib_qp_init_attr *attr, u32 doorbell, u64
> flags);
>  int mana_ib_gd_create_ud_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp,
>  			    struct ib_qp_init_attr *attr, u32 doorbell, u32
> type);  int mana_ib_gd_destroy_ud_qp(struct mana_ib_dev *mdev, struct
> mana_ib_qp *qp); diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index 47e1fadbd..8b7be1255 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -597,13 +597,67 @@ static int mana_ib_create_rc_qp(struct ib_qp
> *ibqp, struct ib_pd *ibpd,
>  	return 0;
>=20
>  destroy_qp:
> -	mana_ib_gd_destroy_rc_qp(mdev, qp);
> +	mana_ib_gd_destroy_rnic_qp(mdev, qp);
>  destroy_queues:
>  	while (i-- > 0)
>  		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
>  	return err;
>  }
>=20
> +static int mana_ib_create_uc_qp(struct ib_qp *ibqp, struct ib_pd *ibpd,
> +				struct ib_qp_init_attr *attr, struct ib_udata
> *udata) {
> +	struct mana_ib_dev *mdev =3D container_of(ibpd->device, struct
> mana_ib_dev, ib_dev);
> +	struct mana_ib_qp *qp =3D container_of(ibqp, struct mana_ib_qp,
> ibqp);
> +	struct mana_ib_create_uc_qp_resp resp =3D {};
> +	struct mana_ib_ucontext *mana_ucontext;
> +	struct mana_ib_create_uc_qp ucmd;
> +	u64 flags =3D 0;
> +	u32 doorbell;
> +	int err, i;
> +
> +	if (!udata)
> +		return -EINVAL;
> +
> +	mana_ucontext =3D rdma_udata_to_drv_context(udata, struct
> mana_ib_ucontext, ibucontext);
> +	doorbell =3D mana_ucontext->doorbell;
> +	err =3D ib_copy_validate_udata_in_cm(udata, ucmd, comp_mask, 0);
> +	if (err)
> +		return err;
> +
> +	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i) {
> +		err =3D mana_ib_create_queue(mdev, ucmd.queue_buf[i],
> ucmd.queue_size[i],
> +					   &qp->uc_qp.queues[i]);
> +		if (err)
> +			goto destroy_queues;
> +	}
> +
> +	err =3D mana_ib_gd_create_uc_qp(mdev, qp, attr, doorbell, flags);
> +	if (err)
> +		goto destroy_queues;
> +
> +	qp->ibqp.qp_num =3D qp-
> >uc_qp.queues[MANA_UC_RECV_QUEUE_RESPONDER].id;
> +	qp->port =3D attr->port_num;
> +
> +	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
> +		resp.queue_id[i] =3D qp->uc_qp.queues[i].id;
> +
> +	err =3D ib_respond_udata(udata, resp);
> +	if (err)
> +		goto destroy_qp;
> +
> +	err =3D mana_table_store_qp(mdev, qp);
> +	if (err)
> +		goto destroy_qp;
> +	return 0;
> +destroy_qp:
> +	mana_ib_gd_destroy_rnic_qp(mdev, qp);
> +destroy_queues:
> +	while (i-- > 0)
> +		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
> +	return err;
> +}
> +
>  static void mana_add_qp_to_cqs(struct mana_ib_qp *qp)  {
>  	struct mana_ib_cq *send_cq =3D container_of(qp->ibqp.send_cq, struct
> mana_ib_cq, ibcq); @@ -713,6 +767,8 @@ int mana_ib_create_qp(struct
> ib_qp *ibqp, struct ib_qp_init_attr *attr,
>  		return mana_ib_create_qp_raw(ibqp, ibqp->pd, attr, udata);
>  	case IB_QPT_RC:
>  		return mana_ib_create_rc_qp(ibqp, ibqp->pd, attr, udata);
> +	case IB_QPT_UC:
> +		return mana_ib_create_uc_qp(ibqp, ibqp->pd, attr, udata);
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		return mana_ib_create_ud_qp(ibqp, ibqp->pd, attr, udata);
> @@ -803,6 +859,7 @@ int mana_ib_modify_qp(struct ib_qp *ibqp, struct
> ib_qp_attr *attr,  {
>  	switch (ibqp->qp_type) {
>  	case IB_QPT_RC:
> +	case IB_QPT_UC:
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		return mana_ib_gd_modify_qp(ibqp, attr, attr_mask, udata);
> @@ -908,13 +965,34 @@ static int mana_ib_destroy_rc_qp(struct
> mana_ib_qp *qp, struct ib_udata *udata)
>  	/* Ignore return code as there is not much we can do about it.
>  	 * The error message is printed inside.
>  	 */
> -	mana_ib_gd_destroy_rc_qp(mdev, qp);
> +	mana_ib_gd_destroy_rnic_qp(mdev, qp);
>  	for (i =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i)
>  		mana_ib_destroy_queue(mdev, &qp->rc_qp.queues[i]);
>=20
>  	return 0;
>  }
>=20
> +static int mana_ib_destroy_uc_qp(struct mana_ib_qp *qp, struct ib_udata
> +*udata) {
> +	struct mana_ib_dev *mdev =3D
> +		container_of(qp->ibqp.device, struct mana_ib_dev, ib_dev);
> +	int i, err;
> +
> +	err =3D ib_no_udata_io(udata);
> +	if (err)
> +		return err;
> +
> +	mana_table_remove_qp(mdev, qp);
> +	/* Ignore return code as there is not much we can do about it.
> +	 * The error message is printed inside.
> +	 */
> +	mana_ib_gd_destroy_rnic_qp(mdev, qp);
> +	for (i =3D 0; i < MANA_UC_QUEUE_TYPE_MAX; ++i)
> +		mana_ib_destroy_queue(mdev, &qp->uc_qp.queues[i]);
> +
> +	return 0;
> +}
> +
>  static int mana_ib_destroy_ud_qp(struct mana_ib_qp *qp, struct ib_udata
> *udata)  {
>  	struct mana_ib_dev *mdev =3D
> @@ -954,6 +1032,8 @@ int mana_ib_destroy_qp(struct ib_qp *ibqp, struct
> ib_udata *udata)
>  		return mana_ib_destroy_qp_raw(qp, udata);
>  	case IB_QPT_RC:
>  		return mana_ib_destroy_rc_qp(qp, udata);
> +	case IB_QPT_UC:
> +		return mana_ib_destroy_uc_qp(qp, udata);
>  	case IB_QPT_UD:
>  	case IB_QPT_GSI:
>  		return mana_ib_destroy_ud_qp(qp, udata); diff --git
> a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h index
> 8336bf51b..169bf91b3 100644
> --- a/include/uapi/rdma/mana-abi.h
> +++ b/include/uapi/rdma/mana-abi.h
> @@ -57,6 +57,17 @@ struct mana_ib_create_rc_qp_resp {
>  	__u32 queue_id[4];
>  };
>=20
> +struct mana_ib_create_uc_qp {
> +	__aligned_u64 queue_buf[3];
> +	__u32 queue_size[3];
> +	__u32 comp_mask;
> +};
> +
> +struct mana_ib_create_uc_qp_resp {
> +	__u32 queue_id[3];
> +	__u32 reserved;
> +};
> +
>  struct mana_ib_create_wq {
>  	__aligned_u64 wq_buf_addr;
>  	__u32 wq_buf_size;
> --
> 2.43.0

