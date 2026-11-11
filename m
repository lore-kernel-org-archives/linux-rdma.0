Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.133
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794415741;
	b=h4qYrQ6yUsVSG+zwov7i3ej8TXF21aLwUqf6fMIWJcm4fUPbGlBOhldwj/eH9UjUCXBo
	 phC/xAtAjk9QZbm/iQb6bm8GUFBtp9D2XTuLYTFgTU07d9AeRT6/BriezPcaddQHYMvl9
	 s8fad9ONOrebjchvcQ1vdy05sES9ca4LaHVonJrcK9WKOh+8gGGfsTMrrM1lj3LtXeIfA
	 OUZOREKfwq+4YeHhLmibLqQTxCbdRrLGS5QtsRlDgB017Us0llFnTXSulURI+Orj8+Pex
	 N+xFx5Gh6C7bggDg3L+/71LJTUf7rh+LJxDGE/iDCySbBHkmIka7V+0Wx8DaWgjxp3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415741;
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
	bh=uftAJCYeGcXrKvzmzMp5TzZgBBS59oBMQoP3d9tmS6Q=;
	b=DeufTLQresS73l9P/ctANktnkTV3DWqM4/RwjyA6o+gK0BKHnbLeDRRsichCfZws7yPU
	 YcwkDBWRIsQTtvVcURjPDwugWYeJdzd6UOXJno5PwWgjh7xGNqYHzZXB+Fw11QXIblYrP
	 8ipHW+d9xaB4qOuA+cTThggIQPwUoTj8fxXwhGpVfkGC2k42ByyTgk9vPAiCkKiJyzqzb
	 6+tEo4uSf96Jjpo0IAh6YFbNVm0HevnvOxCM+n88ob779GTMPPwR4kl8jKVwFgq9Ovob1
	 GdWX+8fX4AVzIKiCb/r2JkZHTjX4v9Qk5LIBpg4RqT/kUbMts6VnW4YOAJ4FywWCTWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=JOyFInld;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.133
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021133.outbound.protection.outlook.com [40.107.130.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5EC606A33A
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E5EC606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=JOyFInld
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jc7211ozCsEDK6a8fuefjJWlciZM0ItrqWij/LfYAan5RcRWhlHWClKs1dKQa+lU9w/BtRHjHs6FGTTMfUal4MkTsbNYaWzHoceDuoFDbW2eg+pLxb4yGsz2yHm+xVnWDKkBfUTNMDPROZnfLgRYkf5791lw7YgAQ9sYXQkCLHdAe7wgwdiJqPZkNxtZn8hygFo+7gYa4Zp4MuOB/bIVbocCTgEzhEkw5KYnOfllEHCuP9k9UE9kIJT0tByerE7+h8Cp+EzIN1uOe57td5wiquIZyL5HZLBC2pNI3mV94PMsh7PylTzZULnvgNi9VE4ViQKz2NxXgXwfzF+AAXbTtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uftAJCYeGcXrKvzmzMp5TzZgBBS59oBMQoP3d9tmS6Q=;
 b=SrMRO7MxM91X/d4EpYn2/omy29iBceWBYUrZbyWT0DmoDPJw6W9t24vIimSIT96DA3FScHzs/qnbQS6U6EvYlz3XBA95n0uQDoZ1LybrJEv+wuJfP2ztOpdDcwbpMkcTLrgbjlxNvrZxeych0nIg3cE55dFQhWqJ5eAc5a2ZAl2sMCTHn+apB8adM6i2ih+svFJNnvCnC2Z+hu9wBKwaw6aHwVu+zyP2ElkAf79NWxKfG1J2/G/TpI9wfJq6ZQ+unLRgSB/VW8dXlFlOR1buTRn05VzeJMRi88eCy7bQ2H/a0FO3mHe1rqrrhNjUMVV/0Kz9cxT2HWOnR5osz9WQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uftAJCYeGcXrKvzmzMp5TzZgBBS59oBMQoP3d9tmS6Q=;
 b=JOyFInldIicMxKrPhD31sT9h4YsBoW+zqXsQ2wH61kQKOkJoAIHb3x32icRQfTvyvKHyJKisptZ5r64uiWSzPIJIysqYILyPMU1BofHt3lstCrNS/UAJc3S/Hur++OP1YKzbRfeQrrZkqIkGIQZ3mpTjIKaqF4DygFeyqjM4vB8=
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 (2603:10a6:250:7c::20) by PA6PR83MB0599.EURPRD83.prod.outlook.com with HTTP
 via P2P; Wed, 11 Nov 2026 16:48:57 +0000
Received: from MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102]) by MA8PR83MB465002.EURPRD83.prod.outlook.com
 ([fe80::7dc3:38ee:abc1:5102%5]) with mapi id 15.21.0639.000; Wed, 11 Nov 2026
 16:48:57 +0000
From: Konstantin Taranov <kotaranov@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	Konstantin Taranov <kotaranov@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v10 7/9] RDMA/mana_ib: Poll RC completions using
 PSN and FSN progress
Thread-Topic: [PATCH rdma-next v10 7/9] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Thread-Index: AQHdcfyL0ejDEr9f4EibuSeG//lBzA==
Date: Wed, 11 Nov 2026 16:48:57 +0000
Message-ID:
 <MA8PR83MB465002C26A8B53D12CDE962941B4712@MA8PR83MB465002.EURPRD83.prod.outlook.com>
References: <20261111121417.1265896-1-kotaranov@linux.microsoft.com>
 <20261111121417.1265896-8-kotaranov@linux.microsoft.com>
 <sashiko-outbox-209073@kernel.org>
In-Reply-To: <sashiko-outbox-209073@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2803d78a-1923-46bb-ad65-124e93e8b0fd;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-11T16:46:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: MA8PR83MB465002:EE_|PA6PR83MB0599:EE_
x-ms-publictraffictype: Email
client-request-id: 4ecfa8e3-8356-45f2-b57e-33bf68e798fe
request-id: eea76ec7-4e08-4631-91de-08df4013adc5
x-ms-office365-filtering-correlation-id: eea76ec7-4e08-4631-91de-08df4013adc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|261021130227099003|261026135527099003|38070700021|261009221227099003|261021123027099003|261026121527099003|261022113327099003|261021135927099003|261022105027099003|261021121427099003|261026140227099003|11063799006|261026130827099003|261009221727099003|4143699003|261009220027099003|56012099006|261009223327099003|261009223027099003|261022075727099003|7146999003|261021133027099003|261022115727099003|261028144727099003|10067099003|22082099003|18002099003|261102123227099003|4133799003;
x-microsoft-antispam-message-info:
 FT5y4leUfg4xjz3eeOUgciGbNICAJhbWlgfS3a3XGTvwODt43mBFkdMiWhTCLVnlBfY/awxa4GMfdY2w1nTDAC+dqJHPfvnJR0wD7QfsG5nRd/gOYTEs6nQUqZJOoKo6ls7oV9ihJKud+8APgeqWsuLL9aNaQ1ENuVDLqkrr63Tilmw+FXsx9aqyp3mMFwurFHwz5/lwRMiB5S+lezM9wFqqmGmBHw3Ti5RUFRKhwzX/bL3WV+SXG5avsD+q5RdOG6GYLn61pXIlLi7fKgJ0Qbpt2l35IlRywdqrEqy12PSUH/de3q3hOV2JgIP6XvVrpNN2Fb1Id0IjaspGIy4Eyacyor6g6XrcSp2ePKPpVFSPVepIDLHkwNZ0GI9OXDz8IKXhMsiU20tarthGxxij9nd0puQWIY1arl15q+Y2eKDuuP9Q6JYUd9kxqVUYNKu6DOmFTKcaXkOozzrh0OyA1umA8MdWf+w2Dwhle9W7pL/zxwHQJhanco0n/p1YA0JhCKzTJRqeyXbn+rHeNP6d04ynxraHqAQ5NmfOCA21Mu5J5uP2QVArZvZkPYy6qsqyL7Z/G46ktYeZ1CiNjF+5NeX1enZgz1N3IZdbwWjcyWgseToRZUuWcXc5XVGjx/XvQ0Fy5ZG7mHCKLyBhTY6vEyHiOTDyDEMAtd+VStrPjEod6PoXyJXXi3ci+d0bbWeWeiPnxpcqNhFpyez4nJenzpkqJ8mvhWJGTwP5mhzi74I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(261021130227099003)(261026135527099003)(38070700021)(261009221227099003)(261021123027099003)(261026121527099003)(261022113327099003)(261021135927099003)(261022105027099003)(261021121427099003)(261026140227099003)(11063799006)(261026130827099003)(261009221727099003)(4143699003)(261009220027099003)(56012099006)(261009223327099003)(261009223027099003)(261022075727099003)(7146999003)(261021133027099003)(261022115727099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(261102123227099003)(4133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?opP+21OLTTA+m4ydnqOPcmwPQ1q6+yMB7ZSXuioHE5PQ9DH9J+It69buyGO9?=
 =?us-ascii?Q?1bSOmkmhfSI20TeCu9B+eT/vgjAhzDivWk7I3LDVd5w6ymV2yYUxnHK173Iv?=
 =?us-ascii?Q?rTQIJIX6DLdm89lUTMTDG+pfbGh8/rclf5NgSAz0Lmuaw+V28Amz0Es0un5P?=
 =?us-ascii?Q?qfmL90Yh4DJo/KstXot1r/dCHYcDb/Zuq3/7xOiDgNdBM7yEesXvUYsvnYBT?=
 =?us-ascii?Q?k3ahdWvQUJXe2Y8Oh55LmPp1qOtypT6i4IZ+JJF+A2crlosQCIC7zLaqXRSi?=
 =?us-ascii?Q?haduBAF1HyYe3fHQUFIlzjnIoNCf2u/jLLnmoDfZydoXyB5INyrWWAFI4fbr?=
 =?us-ascii?Q?AbZo5rEjFW3cq3Wc14I8rm//z5rml8tCQx7vKrN/lbnimyd6eVdv/uO2E7eT?=
 =?us-ascii?Q?e2bchoKiUs1NHQQshpCEbBal9vMnuYNhDoc7guLjPgaDxzd89qTYQjl3kWlE?=
 =?us-ascii?Q?WTpQwExfqG60i+/GjVGoTpty2OtSfKE29gexQRyWOcR9OcziZh4y/xSQF4cU?=
 =?us-ascii?Q?De7F9ND86q8TjPD9DjD/g1/7mYqyFbYitLO6SPR60/Zs81yfdSxEoVnq9Usn?=
 =?us-ascii?Q?3LqDbjCvrbBxjQt7Me6uv5PRlUJ+bTyeZQzEkYx+qKn5+30U5Yf+8LhPto4X?=
 =?us-ascii?Q?kIplgP8uzUPPaWF3B73koHYxXNFRP+NGWIW7scI0BANQAX9sDoaeVWaHX/pf?=
 =?us-ascii?Q?xYvoMoOTbWbq+tl5ITct1pb467I6DZ+tFqbk3wSnggwPB2V9D12ookOrNCzg?=
 =?us-ascii?Q?gJdxx1J2mZa00Fbxjsj1gN2BzAee5oIHaDvyf8ttz32BLU3COjlqseFfmOVn?=
 =?us-ascii?Q?fqhlm8lOG/QOg/3IhCwZZmeXBOyO3ILu5z0I3AmXTExW4xJyeBbIvneLPwfO?=
 =?us-ascii?Q?4UJIVIUXwKEW4R0D6wJQZ8SPXcLd1zPoqXFKsiquy9rL2TZYI4E+L7U/v4Ue?=
 =?us-ascii?Q?heMAqglqdJYQE051s0WB8OW68xVn0FFMvcVHSpRSL8TjPqnh2NTSbeYhscbh?=
 =?us-ascii?Q?q6OjYHpnd3w2cMDLWlNZbKDA3Rvf05hQW5JB67TbT/C8lZNLUpdZffwU0Rkl?=
 =?us-ascii?Q?42lkhIiKIlnPey2kWLNk+wvmc/BQ2STYgnf9xbzfu40aKs62Abr5NnPJXNYh?=
 =?us-ascii?Q?/tE92qclwpCDGFIGb9DccTlijv2aJWQJXflBhHRv33Lvbt4D/jAFLj9Q9DTG?=
 =?us-ascii?Q?OmdAvcznrGVyFK4Qno18eBQgutGEswKGstgWVdqTsxg7Bsx13zT2QpWQTDVO?=
 =?us-ascii?Q?4c3lIyxlqX/d/+r9xnxsZEwYKn7T/F51mXJERZiLnU2FEqhQ6vFcv6TKy0kz?=
 =?us-ascii?Q?e/AkKG+JLCREr6eBwsZ4eHtZ33RpsD+O9lsHQbZwcuCLy1w4sMhCverHhgu/?=
 =?us-ascii?Q?5YZWScS3DgfmlwGAmF624kAtIe59YPpsUP012Kq4FCmzN9GLD5jY2u0e7NpO?=
 =?us-ascii?Q?cqoqFKyXEb9EYq+ZPYXQ6BbIYf9WIX0VrXOVdjUtssE1aawXYyNz9/L7ygnF?=
 =?us-ascii?Q?tD6tFnY8zYM9cRuwTK/HGQW+G8z0awta2wcz7iFLIe7q+iVX2t1dhigX49XJ?=
 =?us-ascii?Q?0IDYKejQwM5Uk/H+oSq22QC8DnN82GggS2xa7MdXVoOr3RFWtFM+ZlMFhsU3?=
 =?us-ascii?Q?w/3bnNN1jorFlNPMvZmxgBUsSjb9qdgg021krPmjVA4DOmrIMg3eA4A0Lqd3?=
 =?us-ascii?Q?os/aCg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eea76ec7-4e08-4631-91de-08df4013adc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 16:48:57.3231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6Z5XnIrzQHfvE+d0R7FTRjBZUjVwCQRhosTaxVTwh7zLGQS/oYDmhBT7XfQpdl9wecUEqJZodX/dW4+NvogDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR83MB0599

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e to
> consider:
> - [Medium] RDMA/mana_ib: stale pending_cqe left on shared CQ in
>   mana_remove_qp_from_cqs()
> --
>=20
> commit 806a276151b888efca6e4438e92abdefb2dc1d9e
> Author: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> RDMA/mana_ib: Poll RC completions using PSN and FSN progress
>=20
> This commit decodes RC receive, armed-PSN, and MMQ completions, retiring
> requester and MMQ shadow entries using PSN and FSN progress while
> honoring cross-queue fence dependencies and rearming the next signaled PS=
N.
>=20
> > diff --git a/drivers/infiniband/hw/mana/cq.c
> > b/drivers/infiniband/hw/mana/cq.c index 843e2c64b32bc..307383bfa4ac7
> > 100644
> > --- a/drivers/infiniband/hw/mana/cq.c
> > +++ b/drivers/infiniband/hw/mana/cq.c
>=20
> [ ... ]
>=20
> > @@ -277,15 +283,18 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum
> ib_cq_notify_flags flags)
> >  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq)=
;
> >  	struct gdma_queue *gdma_cq =3D cq->queue.kmem;
> >  	unsigned long irq_flags;
> > +	bool missed =3D false;
> >
> >  	if (!gdma_cq)
> >  		return -EINVAL;
> >
> >  	spin_lock_irqsave(&cq->cq_lock, irq_flags);
> >  	mana_ib_cq_doorbell(cq, SET_ARM_BIT);
> > +	if (flags & IB_CQ_REPORT_MISSED_EVENTS)
> > +		missed =3D cq->has_pending_cqe;
> >  	spin_unlock_irqrestore(&cq->cq_lock, irq_flags);
> >
> > -	return 0;
> > +	return missed;
> >  }
>=20
> [ ... ]
>=20
> > @@ -390,17 +425,108 @@ static void handle_rq_cqe(struct mana_ib_qp
> *qp, struct gdma_comp *cqe,
> >  	shadow_queue_advance_consumer(&qp->shadow_rq);
> >  }
>=20
> [ ... ]
>=20
> >  static bool mana_handle_cqe(struct mana_ib_cq *cq, struct mana_ib_dev
> *mdev,
> >  			    struct mana_cq_poll *poll)
> >  {
> >  	struct gdma_comp *cqe =3D &cq->pending_cqe;
> >  	struct mana_rdma_cqe *rdma_cqe =3D (struct mana_rdma_cqe *)cqe-
> >cqe_data;
> >  	struct mana_ib_qp *qp =3D mana_get_qp_ref(mdev, cqe->wq_num,
> > cqe->is_sq);
> > +	bool consumed =3D true;
> >
> >  	if (!qp)
> >  		return true;
> >
> >  	switch (rdma_cqe->cqe_type) {
> > +	case CQE_TYPE_ARMED_CMPL:
> > +		consumed =3D handle_psn_cqe(qp, rdma_cqe-
> >rc_armed_completion.psn, poll);
> > +		break;
> > +	case CQE_TYPE_LWR:
> > +		consumed =3D handle_mmq_cqe(qp, rdma_cqe->rc_mm.fsn,
> poll);
> > +		break;
>=20
> [Severity: Medium]
> Can destroying an RC QP leave a stale cq->pending_cqe on a shared CQ when
> handle_psn_cqe() or handle_mmq_cqe() hits poll->budget?

I agree that it was possible. I will add stopping kernel QPs (by moving to =
RESET) on destroy
and will also clean CQ from stale CQEs when we destroy.
Will be fixed in v11.

Konstantin

>=20
> When mana_advance_send() exhausts poll->budget, mana_handle_cqe()
> returns false and mana_ib_poll_cq() leaves cq->has_pending_cqe set.  If t=
hat QP
> is then destroyed before the remaining WQEs are polled, mana_ib_arm_cq()
> with IB_CQ_REPORT_MISSED_EVENTS falsely reports a missed event, and if th=
e
> hardware queue ID is reused by a new QP before the next poll,
> mana_ib_poll_cq() will process the destroyed QP's pending_cqe against the
> new QP and prematurely retire its shadow WQEs.
>=20
> Follow-up commit "RDMA/mana_ib: Handle error CQEs for kernel QPs" in this
> series adds mana_ib_cq_clean() to mana_remove_qp_from_cqs(), but only
> under if (reset), so mana_ib_destroy_rc_qp() calling
> mana_remove_qp_from_cqs(qp, false) still leaves the destroyed QP's
> pending_cqe and unpolled CQEs on the shared CQ.
>=20
> --
> Sashiko AI review *
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fsashi=
ko.
> dev%2F%23%2Fpatchset%2F20261111121417.1265896-1-
> kotaranov%40linux.microsoft.com%3Fpart%3D7&data=3D05%7C02%7Ckotaranov
> %40microsoft.com%7C5a297a517fa543ee42bd08df3ff8ed2e%7C72f988bf86f1
> 41af91ab2d7cd011db47%7C1%7C0%7C639300010526733979%7CUnknown%
> 7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJX
> aW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3D4f%2F
> 58DrkaoHVfyi4DZ4FnNAfk7EIExnhjQ0qHjufNoE%3D&reserved=3D0

