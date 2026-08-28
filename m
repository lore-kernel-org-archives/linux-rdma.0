Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020076.outbound.protection.outlook.com [52.101.201.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4B946EF7C;
	Fri, 28 Aug 2026 19:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787945987; cv=fail; b=CaQFcf7YyCtahGp2G/LPaWLgwbCxXBPyuymhqD6/OeliZOxgz8SMCUk6l16doGN4Ag/ZPyaQ0uOe1MezHiNOsegEPzt0ChRxxlm3qK1R6tnosHqaBUVxQsYvEMi1KKfpwzevWFzlzSw1ZUgyF58jU2yS50fkQB+gIbN0UYGGCzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787945987; c=relaxed/simple;
	bh=VLCPlNSEOzqIdcZPqPoFsPSFVERIiVW40OSPpSKTjVc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FPdC2VvWKJCp3skwyf0hBMJKljYlnMKlsIXrs6ULudsNGBxRdPa8yqvLiAElGtRwdvMhCAxCqTOKBQzOPqEgFpc0YzMrYNdrtPW3KxibOgARK8VHVUh5CJutUYSn1On+h3A1f9vorrr9kogXcQR6x5CFkVGbwQ2mHkA7mpJ/pt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=InK+Io5N; arc=fail smtp.client-ip=52.101.201.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="InK+Io5N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YE7PGtL74e9FyZk84WNBrbjF2y9cQb/pyIva9OYZwnCpVyD+fGhuDTS494uyh7jMVuCLM3UWszEkh/MWmqArIpSlKy239S4uPKMCa8TcFqlTeZC0+oK9hU6COhibM8LOo6zyvvgylnRD7465tOKdYWjWbxbEkUpp1rzSbPbrSsqzVn4gvJ4Z/alFPXAFoBLRlmC9/H9SWhS1ko7ewpRxo+KrcENK4/DhEJJy25gRHAzxylOAtloM5PgVP2PI7kETMVL4AQ7qIdRtTXaAZ85ivfNRGu1ohOyMOfB4J2jzu4EbdMAij5GGdFzEU25tCi/Y+Wv1MABEG2BUr2kOmuHomg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkZlDCAcFhx+FM6wlo/SuZRYFj7MsFI3y42wbk2y2qs=;
 b=j55h2CIib1b1zChAzQrP03041wmOJu9NASgyIAz/x9wXRHEX7cjLH1bA82okYd0sbFCrkaYdxwkylDlkNiKTiebHQ8qLvoI6htUFIvcBBiBwuDLloljbeEd8ZPOWpeTADbWKP+1qyLHI/pOgQLefpq8AqBpZrWzLo5tJK8re0PkvHeUMb99fbvPhRKUvw8E7gzx9a7z1vHejcJaDMCXTX16tiVAZ03SRSsNlptrMCBCkml4+bwsjC7AZItaf+bVHBYukpnxK5hDAbXW1h3Eyej/BeldZL46XmAGLHB7z1ruGoWZfcii5oETdjSpPlTObow4MzkkIl6CvN4kYpeB5CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkZlDCAcFhx+FM6wlo/SuZRYFj7MsFI3y42wbk2y2qs=;
 b=InK+Io5Npvi/yyG5hhaW+zt8xynnfTmh27FrSS7X3+B2bH6mt4BhDOwY2B6skGz+rNW+glL5t2znGt9gLxEQusdOlh4xnH3Hl5UFgjv3FQRWjLc2NYP87TBrHjsSH9gl+m1iG2Xh/ZRad/sljisJvhA/ZGCONEF/fEd+4GBFYCc=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA3PR21MB5894.namprd21.prod.outlook.com (2603:10b6:806:496::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.0; Fri, 28 Aug
 2026 19:39:40 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Fri, 28 Aug 2026
 19:39:40 +0000
From: Long Li <longli@microsoft.com>
To: Konstantin Taranov <kotaranov@linux.microsoft.com>, Konstantin Taranov
	<kotaranov@microsoft.com>, Snehal Sanghvi <snsanghvi@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rdma-next v2 2/3] RDMA/mana_ib: MMQ creation for RC QPs
Thread-Topic: [PATCH rdma-next v2 2/3] RDMA/mana_ib: MMQ creation for RC QPs
Thread-Index: AQHdNjGwy8LjlBj210OXBHet0KBtg7az3SZg
Date: Fri, 28 Aug 2026 19:39:40 +0000
Message-ID:
 <SA1PR21MB6683B9D0E235F3306B5FED53CEAC2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
 <20260827143736.2013093-3-kotaranov@linux.microsoft.com>
In-Reply-To: <20260827143736.2013093-3-kotaranov@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7c4d289f-7cd8-408e-9da4-ef2370ede1a1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-28T19:38:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA3PR21MB5894:EE_
x-ms-office365-filtering-correlation-id: 6979c7c8-abb3-4076-777f-08df053c1a02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|38070700021|11063799006|4143699003|56012099006|10067099003|7146999003;
x-microsoft-antispam-message-info:
 A4tUk+J3RLeJ5agVJ6hX5uM6+apDdf3mvK+nSEa4SncamkCUgfq+DgU7CzD+THUA13mV8S1LRBW3w+MWWaWjwnWiSWexvYvnpkkcIkkVA0ufgtdSLehuf9Zw/LGDUjSA5xeCJEplERNKrqcEAkgm8wLXlLdrBbW9criM5hK1qMgpwBwEjoR9zmcdfKTY4fraFNLUtTYbQy1RjRgkGQ5C+TMEJEdw0AIXkuFiiWqGsAFge4jOm0+D5fc5jvbyNs0Ir3YEjLghEZ99OKqDnz4R1067TR6938kyrGga3cVGcK5jD+l5cQfIFCKImy5VNCunQlH7ovFYcMTxZFGB6SIPEO9dYBSbfNzH4HWaFOcNP5k92kb+XCl/fE1nOBv0W+i0SzFN5onAbnJwQB3GaAWbFUt5jGYdP/+r6IYNoOuLJcSOaJODJe7olwZCDLWtew0AJs/bEK9m7tR0nx7KmtWBqFoVAHJ/J+V+U8XSWlThQuMoYRLiGtvisxyJVn9FFm38yezdOPYG52zExismRRh3CT/DdcSIo9a9kyzoc3Wfl5cR9j7uItFDdPp2W2i8AbfinfhW5io9NM1bZ9UKAi7ttb6Cb9LmFWnopDxhKe0FqMxbeg2YJ95Z50AoJTbfvxoN5BiA4E17dvlzpmmfyqC0FWlv2Rdvb9Y6MwsDCOlphIZon/K+HBT0BnEOrTjyfk9D4uKjQN21LKkL5z7YhBiVa/wnOqx2GdxzzIa0cCzRamg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(38070700021)(11063799006)(4143699003)(56012099006)(10067099003)(7146999003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?NmdsMr4E5xD1MSpGo3Rc6ZCm4JuWRmGA31qiUe9aoh2IB60w7gXQgjt6ZsWR?=
 =?us-ascii?Q?RUQFsKwNUR7u6+P/5C+4I79De1XCE9Wab0bTL4AWo3B43BRvyrAy/f33KHop?=
 =?us-ascii?Q?TdA6p7Bn/fEi6qqDoYxLRclS7Rf62b2+n5TxNkninR575SUhKcGge14v+Zup?=
 =?us-ascii?Q?5JRZnTMUslT/ZzH8uoss3J9Tnah64az7CAJcVIjPtJ+q3lPbIFMOr5OHF/j0?=
 =?us-ascii?Q?tFUlBhZt6KApyP9dSO0JLpLGW1F6RXE7CMNVFtH79kX1LevyMc3W3F9nf5re?=
 =?us-ascii?Q?Ye/tYvg+XkwI63sv+apKhabXzGX1TZsiivpJ0PA3czBzJvRmvQXL0zUbJces?=
 =?us-ascii?Q?UBh22xeOQxpt6GpIiv86CuWfMiGOSj1PW6lLqBdNuqhZ6Gevfo4HfrxKjo7Y?=
 =?us-ascii?Q?ePlNwCp/NlRaxEvi3UR/2eZS1OHQFnJ7EL9seIYhRyXN/ThgtCfyQcVq7Ql9?=
 =?us-ascii?Q?8RaAgq+1OfsoQh6p6QGPupK2OifTWV9J3IjvItfHn2Ppako5hfKzFkgW2px8?=
 =?us-ascii?Q?GDUxcEO9imOScnxs222ryqrX2RfvyukKbGqBNJrrGs0seyyohzqVMMD8AS7X?=
 =?us-ascii?Q?MjWSnmXuDvtj4mtWi3hDJwhauyOMkmDNIy0LsRbwKYykdUvz37OUqEU1mVHe?=
 =?us-ascii?Q?vGFsjdFvIsxRMhSF0QYpYBlkerJrdhskzrvOZXn4nAkTKaMtkIJp1Jv0bRJs?=
 =?us-ascii?Q?C7fc4mASQkyEldxhZgHu8D0c3U8anlmlOTCpQaozI6XKAuwOIhTtpc2zClNM?=
 =?us-ascii?Q?yTxtgvuuazY9wxiZrvakEYXivPW3tp9j8Gn5Uu6eBjJMDGQROGQKyu6FZRPm?=
 =?us-ascii?Q?F1H5UbQTZRwlHZ1aMGcL6YXX2PHYi+XcMBBu0bkc0g5crvla6NkPE7OVz53R?=
 =?us-ascii?Q?kQdWFmF0+oDPzFPh7RfQ6FW/BPbVVwN+UYvhb91+4Lyrw/tc1u6fIShKx+8f?=
 =?us-ascii?Q?xOFf1ymzzggt3UrveAR4VQnZfdtHvsjNrbi00KGr/0Y2heSJS/L1IgwrDVDa?=
 =?us-ascii?Q?vZMuGFwlfTps1f7VVqAnf9vTGeL41oYk5uAhAW9mB9MrL+MFA29Y5FY3CUts?=
 =?us-ascii?Q?yxfmumZQjckT9XHiqcRLFw+BEfQZmOM4Ocv4vGrLprJJHy2g/hPnowz/p9mh?=
 =?us-ascii?Q?urFjD5GY8VMYBD3m/4Xo2SXJpK7tE52b3dtTSgLf/rm9wTbzsCCLLNpLaafE?=
 =?us-ascii?Q?Nq/EuOVF6WAXAT8gwIInlB0puP41o2iR7yEMSLDiABGPyQM374h+M6k1CHez?=
 =?us-ascii?Q?+XSumO0v5a//iD9w12pfV/rWDAgcmSPIe0EeRP4dSJlm4aJDtzzslG9LxEwT?=
 =?us-ascii?Q?+QusoTVZcfSUxMne1lQBFFO95HkazSyZJsrSc2gRRj0WdzoDhMYGadXO4XgI?=
 =?us-ascii?Q?sguW155MvaW+o1Qp5QyO+CO17Z8pdeFlBAE0D+KgwHkUe36m7htpFqKTtq70?=
 =?us-ascii?Q?rHCRjBYawuP7V/tWrVdyt0qjz1MiJQjBkoDWBcEpvK7/MjKHgGodzxk9I5IG?=
 =?us-ascii?Q?4mOtRJaGnSN06iJpiGwn3eU74fkZpiiQy7TqnjSlcpoBJUqg+Dd4423aBkeF?=
 =?us-ascii?Q?9g1SULf+vqtEZo6uR+/9NXXkoyPFHi6qWJad3zMnawQM0g3EvxGqwJoFMNnV?=
 =?us-ascii?Q?lHv11lZLoFJFGsPr9qfOOr5I9up5Z22BCFt19X8K4f4Oh6c1mrkDwp948QkM?=
 =?us-ascii?Q?/lvjGTCyy6OURudqSmmH0HONfwV+fZsEJO1ud2EPfcpdXxxe?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6979c7c8-abb3-4076-777f-08df053c1a02
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2026 19:39:40.2094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C9xBZg4rTjZjdaEC9qcopptwh60DehBXwTpvwgwVwDSAm+EBGZ/mV9v+mkBO4qrgwD9Iz33clUPIPyy37T/UpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB5894

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Create an MMQ for an RC QP when userspace sets the corresponding
> compatibility-mask flag. Register the userspace MMQ buffer and pass the
> queue to hardware instead of setting the NO_MMQ creation flag.
>=20
> Keep the MMQ disabled for applications that do not request it, preserving=
 the
> existing behavior. Return the created MMQ ID to userspace in the extended=
 RC
> QP response.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Reviewed-by: Long Li <longli@microsoft.com>




> ---
>  drivers/infiniband/hw/mana/qp.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mana/qp.c
> b/drivers/infiniband/hw/mana/qp.c index aa5f8c607..c6821ae5f 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -557,16 +557,22 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>=20
>  	for (i =3D 0, j =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
>  		if (i =3D=3D MANA_RC_SEND_QUEUE_MMQ) {
> -			qp->rc_qp.queues[i].id =3D INVALID_QUEUE_ID;
> -			qp->rc_qp.queues[i].gdma_region =3D
> GDMA_INVALID_DMA_REGION;
> +			if (ucmd.comp_mask & MANA_IB_RC_MMQ_CREATE)
> {
> +				flags &=3D ~MANA_RC_FLAG_NO_MMQ;
> +				err =3D mana_ib_create_queue(mdev,
> ucmd.mmq_buf, ucmd.mmq_size,
> +							   &qp-
> >rc_qp.queues[i]);
> +				if (err)
> +					goto destroy_queues;
> +			} else {
> +				qp->rc_qp.queues[i].id =3D INVALID_QUEUE_ID;
> +				qp->rc_qp.queues[i].gdma_region =3D
> GDMA_INVALID_DMA_REGION;
> +			}
>  			continue;
>  		}
>  		err =3D mana_ib_create_queue(mdev, ucmd.queue_buf[j],
> ucmd.queue_size[j],
>  					   &qp->rc_qp.queues[i]);
> -		if (err) {
> -			ibdev_err(&mdev->ib_dev, "Failed to create queue %d,
> err %d\n", i, err);
> +		if (err)
>  			goto destroy_queues;
> -		}
>  		j++;
>  	}
>=20
> @@ -580,8 +586,10 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp,
> struct ib_pd *ibpd,
>=20
>  	if (udata) {
>  		for (i =3D 0, j =3D 0; i < MANA_RC_QUEUE_TYPE_MAX; ++i) {
> -			if (i =3D=3D MANA_RC_SEND_QUEUE_MMQ)
> +			if (i =3D=3D MANA_RC_SEND_QUEUE_MMQ) {
> +				resp.mmq_id =3D qp->rc_qp.queues[i].id;
>  				continue;
> +			}
>  			resp.queue_id[j] =3D qp->rc_qp.queues[i].id;
>  			j++;
>  		}
> --
> 2.43.0

