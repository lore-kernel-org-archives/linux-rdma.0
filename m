Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023112.outbound.protection.outlook.com [40.93.196.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272B6249E5;
	Thu, 13 Aug 2026 00:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786580731; cv=fail; b=i2xGy27yrcRu2VL6WJAwt7whNVBK++LVTcHCIg8HYRKzWRZ9nbOd8GKsMkb4U1VoaChWTtdb4Qv/Cm2btO8m7hlEcEvPUUvWPHDNMNA5lWVWsNE7XoWuSzm96gyka10nY6Qysc5+mYlQ03CMLDaSwl/m2FpRycovcBwCmjTrnRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786580731; c=relaxed/simple;
	bh=NaqNVygv2B6Z70B0eRZEjQNlVE00CDMgzk43YG3Sesw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K6sldOfwPkdAFHz4wGRoMUiIRv0E38B5aQw6CE50EtR98fXmrXxxXmZ39WToBF67NU+AikrwdMMP+YLWAzrD5YKemf4KBPMtAwEKfu342HaJ5UA8FJGqgfwIECvL8dQfhOGrwl5tiCzVFhIbSpVecgcDwvIZt6sQiauAyBulVZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=L8qYD6fY; arc=fail smtp.client-ip=40.93.196.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="L8qYD6fY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEem+/J9D5zCJ+K0TmbKOY4WxaQSn+fVFMhNRX9+tLnG7MvKd9IndBqKZtg5GtvJE5yU1dgvZkzNCQe2w04TZOf87FFZ6VA0gtIDdkiOUkG1rSWVkpuPELKCy5exVdzF72awU9LIS36Kw3+KvuNeXjzVqklFdm1lHNdDvJ4bol1OO472cnzkPevd4o8gX7D267HIg2Lx3S5USsXVxkm0dQALRh7W52wwiwRo2KOjFoq+TwfmOvPpyzq/L1Ncl+MtwjmKWMpS+yj5ga8Wgo51gdtHqZtzFw7psF46uNWhcfNUvYkr28rRmrKm+s526Iw8T7+MT1sGPP6yN9GgG4JhPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6X2Qs4lMoVRn+RV9aU94t9C1Ld0kWlRG01zgjM1wYE=;
 b=Vegt6fmgf79U5/WwCW8rM6ev38miw7QIk05XhuvHHHFRBXzwFyErHnhLZA7oa7fw/Qifi1cHO1YZlDNLPvrKix+gAOrS0TnjZUB2/qFh7HicPnH/P96OZFwTvP3+d5U9j2AaoWTkXDmsXn54F//J1yazCRJYNlHEKplp1HREF6+fpa6fNY6QqcJXjtIUbIyekjmbX9QykebuMHg+rp0QkIm4mMLziE1JaAdkdRH0f6Ap5/w5AWBqNAJCS8tnw+H0OpFs5SQLTXUgd7gJurq2yxVE1FlFxm+p/umR1+WJ/r9uaPn4DWHrEjMmX5w69jp6cZ4dFwJ7qD9rhnCxDXTsLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6X2Qs4lMoVRn+RV9aU94t9C1Ld0kWlRG01zgjM1wYE=;
 b=L8qYD6fYqr2VrKHuk2q64yeryWsJ9aDaG/f9pISdvbSwDwwNX00CDCAjpP+pICuijLe7wN03mLyW8OT3AUXTuOVisPl2dGgjVLD+D6Z/I8Hb1sllgmLMslo8NIASKLiajgu3wxB7gwwfxESrzcryhHy6z+dzFqjD/JVJD4JSIfw=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by DS4PR21MB5009.namprd21.prod.outlook.com (2603:10b6:8:29f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.1; Thu, 13 Aug
 2026 00:25:25 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Thu, 13 Aug 2026
 00:25:25 +0000
From: Long Li <longli@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"edumazet@google.com" <edumazet@google.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org"
	<leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan
	<kys@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net v6 1/7] net: mana: RCU-protect
 gc->cq_table lookups against concurrent CQ destroy
Thread-Topic: [EXTERNAL] Re: [PATCH net v6 1/7] net: mana: RCU-protect
 gc->cq_table lookups against concurrent CQ destroy
Thread-Index: AQHdKTqPxn+SeL0D+U+Lxn/p3UL227abFzsAgAAKPSA=
Date: Thu, 13 Aug 2026 00:25:25 +0000
Message-ID:
 <SA1PR21MB6683879509E7B544DE1E5C8CCEDB2@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260811023823.2391255-2-longli@microsoft.com>
 <20260812234650.2193421-1-kuba@kernel.org>
In-Reply-To: <20260812234650.2193421-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e0cfcc80-f41c-40d1-b87b-a94010c11232;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-08-13T00:23:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|DS4PR21MB5009:EE_
x-ms-office365-filtering-correlation-id: 5ef66412-c02b-46e2-e276-08def8d15e9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|5023799004|18002099003|56012099006|11063799006|38070700021|7146999003|4143699003|10067099003;
x-microsoft-antispam-message-info:
 M9LhnDFq6Hh1mHDgHdJr61i8IfhjQ47PDRWJj5CJbvex21IBHcJfjsyASNLt5vBNUK8eqCebacyreSmUkvJf3h7kuKmkN6SyIjcG0n/fSwlm9nHB2noc/NgFIjytdX9yEzaEVwpB8fGkKhLKgV3QbpS4BRavnH0vaouWTDuwfoZ7uiLQWZb1dln3R4rZZtqGkuFiQi02KaMtYIbuUxtJTW2VYzhs3t+OM/ISguLTn6ml3iGw/na7DCyVfH8xuq2kDs2BcX3wB0Eq+5bEf02q/rXhHpJm6EbKetrdkkK+uh3YEVzVgjwVU+kksiPbgMy7Tdt4zITVUocB9BAZLzfmjqEc+TOeKDbulZFHwpWozIUuORc1HCsLnK6cYpBj6o4KrNsLJbZhpvkfmRpoMBYUlswKhw2m+vivkH2leLWrHcXDAyVR0MxI0XoF74Hahr5CBZdKFW5PpZj1SY93dO+HyQ9Og2lZoq+d9sTgy5kng7oW33xYZn6QLD1e2hC5Ns0uWXaAGoYUIeLzuKecrRGtaoyr1iBliWVGy7tk5KGll/pZGweW/CR4zIRetHlVeiAdmdzZal2nfYgP4jvyGGpvrsWHnWpTrkQYh8Tx05Oc+eA6dPB7hfSGMH4xL/QZ95YshuZrbFZWHXSwkKoZEy03NXVslXly5YvkbGB9yctImwvXFSfjwP5A0061fcCpN5dePq0LEPsFWh3NXbn9uCAiwJllfdImZgw7/nSU0ln4/xU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(5023799004)(18002099003)(56012099006)(11063799006)(38070700021)(7146999003)(4143699003)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?sdHw5OaxXOxQbsqkvIZniiPqZXb19G2Zy3XEDO/X5tACvUgUKVmR8pUcieKe?=
 =?us-ascii?Q?TeR7u5GypKvGD4mpDWnB439sjwN2yVlnzsc6Wwu0lSSDHNhIATsOWkiGJCxH?=
 =?us-ascii?Q?0mTProi62gWM8Fs2FmJGQ6kmYBzKLje07o1EK26Q55TvKi2za3TNNvRi50+r?=
 =?us-ascii?Q?N2JgdryObECfWQaPC/O781kFyLNYrKGywOAw3+7RvnDCbIMeW8ehssqNVAZ9?=
 =?us-ascii?Q?v1PwGhC8PApOOEGK7FhWmpIgoupqxdUeLxaTq7iu6Je72xSP1jyA7vXgaiPp?=
 =?us-ascii?Q?HRCU/WewIS49xxSX4bnZ2i7lvhmqrr3V7FLPwxyu7VaJbugylvYFD8Xy6oQx?=
 =?us-ascii?Q?nKijl0ZwjnY9bCPcyR3GQnZMFWDFwYneA0jah2TunJCllRsDGnalOUxp8PYT?=
 =?us-ascii?Q?tFdZSlwpa/d5KzXbJbSsze+sX6V88pGJg1wm+HXJJGuFMHQo2cXsG/OLf8sh?=
 =?us-ascii?Q?IQFFCVderkebUMmq0FdgAFqiaWEtV1LRIX8JrRiEHYMBtE6zfT7s+u095r6/?=
 =?us-ascii?Q?7pfBmozCWHJGRTh5fsFPVVIJm0iJBU8iSYjUS2qhDjavXFi8fSRdMJRJbmof?=
 =?us-ascii?Q?2qG6oMAxNFmtoclujzk+rZ9zn2STM+vaEQqHwqNmCP8OSF3brA+Ve3FO7xZN?=
 =?us-ascii?Q?s7CnEpK/QgqXR+alSi3ihYh5voY5sjftyqKrm0PBRqC/K5KtNCq2Kcj4x/jT?=
 =?us-ascii?Q?oGqd853LyTCJve/mY0MG2ypbvSc1mALcGNV803yiR59O7lIel5qSDLv9uzmf?=
 =?us-ascii?Q?qb5l1RL0+xLfVx37bPsGbzR8DaCkBZ5y8L7xazFn566K8meCoDVB0f5T4bxz?=
 =?us-ascii?Q?rofUz4aywMUe2PvuqEbW9ET8tL1Ew3NG+6ah/CFUFquyHd9RtDizDezz7AJW?=
 =?us-ascii?Q?Uxf9/NilAZ1MvjVNqBpz6xFbxXnZ12zddb4vdR0qiOpwv1iET/vkmjEJ0boG?=
 =?us-ascii?Q?ihtOxEOsV7S4G7R/UAuWUolbjNRczK1jNdaTLFoMgv0m8FMVPU+bakowyV0a?=
 =?us-ascii?Q?g/LcKvfc6+HNQNQqtzhg1GTY96i70wCPemRSfxpGd7zNQMsfiCB0cA3Dg5Lx?=
 =?us-ascii?Q?aMF6Nnv87/QYrOlhfGzs5/lH8078knF9miOcOBY7myoCDWbCTHrrIRW5uOy7?=
 =?us-ascii?Q?8cMIX37Itp7w+lq57zSs7F+V+j8Lemw7OZ8dzEHIRsxPNvYhEV9NxAkhKhbD?=
 =?us-ascii?Q?/WT0Z9yXqylxBQz61bR8TRhVXucrXq4zjpvbT8UnrMFjHQje3/2X6pVFrlKT?=
 =?us-ascii?Q?jUOXYXu4+BV9YL7/P+PbqChI3MvZ0U3VCP8aT6EUaznvrDbvZDd9tp99an2V?=
 =?us-ascii?Q?sVz4iLsp6P4IDE7ZUfEgP23yVtxRK1Z1YbgCtMs8cdgOLw70Wjv3YdTxUOIU?=
 =?us-ascii?Q?kaIuZOGkFZftbb9ewHKpDDZeS8mqUcGtCrPapfT1UuYcWE8eu3QAAjkJckdE?=
 =?us-ascii?Q?7x0/XforzWi/77lw1FAwd9yyuJMkX7HgnXFdZuIh+j8gDj8A+uuPflxXQMzl?=
 =?us-ascii?Q?hIIfMZHf0B4UsIShRoHPIFk87IktiaU2d41uQZvECL1Zj+sXpdO4fUZn+AEy?=
 =?us-ascii?Q?WxO0rkVaez/b4C9wZ63Dla7E4RdjJ9vWQXmydbmVhUXK/kjS80s1e7D/oYSN?=
 =?us-ascii?Q?v9zNLRSLSSXpdZu/01whqtPjx2GyiOfwsFU2tgqzbCX+5frkICvTotyekgP6?=
 =?us-ascii?Q?iFvp+drzSKIzD6/XX3+9awuAflC46NCpfM/R6KuC+2CUS3Od?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef66412-c02b-46e2-e276-08def8d15e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 00:25:25.2211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: INCry7ttoXUMj0/6td/+NRrnOjXtmzVS/b4GwHrm4Sn4m5niZMr0ClvRy1uqAIyAeqhklm9T0pQMjItgHxG8VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR21MB5009

>=20
> This is an AI-generated review of your patch. The human sending this emai=
l has
> considered the AI review valid, or at least plausible.
> ---
> net: mana: RCU-protect gc->cq_table lookups against concurrent CQ destroy
>=20
> This puts gc->cq_table (base pointer and entries) under RCU so the EQ
> interrupt handler can no longer dereference a CQ that a concurrent teardo=
wn
> has freed.  Teardown clears the slot and takes a grace period before the =
CQ
> memory is released, and the Ethernet paths are converted to a two-pass
> quiesce/free so the grace periods are batched instead of one per CQ.
>=20
> A few questions below.

I'm sending V7 addressing all the issues pointed out in this review, togeth=
er with Leon's suggestion on rearrange CQ and adding refcounts.

Thanks,

Long


>=20
> > diff --git a/drivers/infiniband/hw/mana/cq.c
> > b/drivers/infiniband/hw/mana/cq.c index f2547989f4229..73d97b2f5cf9b
> > 100644
> > --- a/drivers/infiniband/hw/mana/cq.c
> > +++ b/drivers/infiniband/hw/mana/cq.c
>=20
> [ ... ]
>=20
> > @@ -149,23 +157,54 @@ int mana_ib_install_cq_cb(struct mana_ib_dev
> *mdev, struct mana_ib_cq *cq)
> >  	gdma_cq->type =3D GDMA_CQ;
> >  	gdma_cq->cq.callback =3D mana_ib_cq_handler;
> >  	gdma_cq->id =3D cq->queue.id;
> > -	gc->cq_table[cq->queue.id] =3D gdma_cq;
> > +	rcu_assign_pointer(cq_table[cq->queue.id], gdma_cq);
> >  	return 0;
> >  }
> >
> >  void mana_ib_remove_cq_cb(struct mana_ib_dev *mdev, struct
> mana_ib_cq
> > *cq)  {
> >  	struct gdma_context *gc =3D mdev_to_gc(mdev);
> > +	struct gdma_queue __rcu **cq_table;
> > +	struct gdma_queue *gdma_cq;
> >
> > -	if (cq->queue.id >=3D gc->max_num_cqs || cq->queue.id =3D=3D
> INVALID_QUEUE_ID)
> > +	if (cq->queue.id =3D=3D INVALID_QUEUE_ID)
> >  		return;
> >
> >  	if (cq->queue.kmem)
> >  	/* Then it will be cleaned and removed by the mana */
> >  		return;
> >
> > -	kfree(gc->cq_table[cq->queue.id]);
> > -	gc->cq_table[cq->queue.id] =3D NULL;
> > +	/* No rcu_read_lock(): like mana_ib_install_cq_cb(), this runs within
> > +	 * the IB device lifetime that mana_rdma_remove() drains before the
> > +	 * base cq_table can be freed.  See gdma_context::cq_table in gdma.h.
> > +	 */
> > +	cq_table =3D rcu_dereference_protected(gc->cq_table, true);
> > +	if (!cq_table || cq->queue.id >=3D gc->max_num_cqs)
> > +		return;
> > +	/* Removers for a given CQ are serialized by the IB core, so the slot
> > +	 * is read and cleared without rcu_read_lock() or atomicity: a CQ is
> > +	 * never torn down while a live QP references it (cq->usecnt), nor
> > +	 * while the QP-create that installed the entry is still running (tha=
t
> > +	 * create holds a reference on the CQ uobject across its error path,
> > +	 * before usecnt is taken).  Any double-remove is therefore sequentia=
l
> > +	 * -- the later caller sees the NULL stored below and returns.
> > +	 */
> > +	gdma_cq =3D rcu_dereference_protected(cq_table[cq->queue.id], true);
> > +	/* Clear the slot only if it still holds the entry this CQ installed
> > +	 * (gdma_cq->cq.context =3D=3D cq).  If the id was already removed, o=
r was
> > +	 * recycled and republished for another CQ, leave the current entry
> > +	 * intact instead of wiping a live one.
> > +	 */
> > +	if (!gdma_cq || gdma_cq->cq.context !=3D cq)
> > +		return;
> > +
> > +	rcu_assign_pointer(cq_table[cq->queue.id], NULL);
>=20
> [Severity: Low]
> The comment says the identity test protects against an id that "was recyc=
led
> and republished for another CQ", but the compare and the clear are two
> separate accesses with nothing making them indivisible.  Both
> mana_ib_remove_cq_cb() here and mana_gd_unpublish_cq() do:
>=20
>     /* read */
>     gdma_cq =3D rcu_dereference_protected(cq_table[cq->queue.id], true);
>     if (!gdma_cq || gdma_cq->cq.context !=3D cq)
>             return;
>     /* separate store */
>     rcu_assign_pointer(cq_table[cq->queue.id], NULL);
>=20
> The two sides of the table are also asymmetric: mana_ib_install_cq_cb()
> refuses to publish into a non-NULL slot, but mana_create_txq() and
> mana_create_rxq() publish with rcu_assign_pointer(cq_table[cq->gdma_id],
> cq->gdma_cq) and no occupancy check at all.
>=20
> So can this interleaving wipe a live entry?
>=20
>     remover                              publisher
>     reads slot, sees A
>                                          stores B' into the same slot
>     stores NULL                          (B' is now gone)
>=20
> Since mana_gd_process_eqe() now drops a NULL slot silently, would every
> completion for B' then be discarded with no diagnostic, and would B''s ow=
n
> remover later see NULL and skip its kfree()?  Would a cmpxchg on the slot=
, or a
> small lock covering cq_table entry mutation, make the conditional clear a=
ctually
> atomic?
>=20
> This does need the device to hand the same CQ id to two live consumers, s=
o I
> could not demonstrate it in practice; the pre-patch code cleared the slot
> unconditionally, so the guard is still an improvement.
>=20
> > +
> > +	/* Wait for in-flight EQ handlers that may have loaded the old
> > +	 * pointer via rcu_dereference() to finish before freeing.
> > +	 */
> > +	synchronize_rcu();
> > +	kfree(gdma_cq);
> >  }
> >
> >  int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index e8b7ffb47eb98..d40f25a1a74a7 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
>=20
> [ ... ]
>=20
> > @@ -743,11 +744,30 @@ static void mana_gd_process_eqe(struct
> gdma_queue *eq)
> >  	switch (type) {
> >  	case GDMA_EQE_COMPLETION:
> >  		cq_id =3D eqe->details[0] & 0xFFFFFF;
> > +		cq_table =3D rcu_dereference(gc->cq_table);
> > +		if (WARN_ON_ONCE(!cq_table))
> > +			break;
> > +
> > +		/* Pair with the rcu_assign_pointer(gc->cq_table) release in
> > +		 * mana_hwc_establish_channel(), which publishes the table
> > +		 * after storing gc->max_num_cqs.  The rmb keeps this bound
> > +		 * read ordered after the table load, so a shrinking
> > +		 * re-establish cannot pair a stale, larger max_num_cqs with a
> > +		 * newly published, smaller table and index out of bounds.
> > +		 */
> > +		smp_rmb();
> >  		if (WARN_ON_ONCE(cq_id >=3D gc->max_num_cqs))
> >  			break;
> >
> > -		cq =3D gc->cq_table[cq_id];
> > -		if (WARN_ON_ONCE(!cq || cq->type !=3D GDMA_CQ || cq->id !=3D
> cq_id))
> > +		cq =3D rcu_dereference(cq_table[cq_id]);
>=20
> [Severity: High]
> This isn't a bug introduced by this patch, but at this commit the bound u=
sed
> here is still mutable while a table is published.
> mana_hwc_init_event_handler() writes it straight from EQ interrupt contex=
t
> from a device-supplied value:
>=20
>     case HWC_INIT_DATA_MAX_NUM_CQS:
>             gd->gdma_context->max_num_cqs =3D val;
>=20
> while the table itself is sized once in mana_hwc_establish_channel() with
> vcalloc(gc->max_num_cqs, sizeof(*cq_table)).  A later, larger value would
> inflate every bound test (cq_id >=3D gc->max_num_cqs here, cq->gdma_id >=
=3D
> gc->max_num_cqs in mana_create_txq()/mana_create_rxq(), cq->queue.id >=3D
> gc->max_num_cqs in mana_ib_install_cq_cb()) past the allocation, and a
> smaller one would make mana_gd_unpublish_cq() return false so
> mana_gd_destroy_cq() skips the grace period for a still-published CQ.
>=20
> The gdma.h comment added by this patch states the invariant as already
> holding ("max_num_cqs above is the size of cq_table and an upper bound on
> valid CQ indices for the table's lifetime"), which only becomes true with=
 the last
> patch in this series, "net: mana: keep max_num_cqs immutable once cq_tabl=
e
> is allocated" -- that one moves the handler to WRITE_ONCE(hwc-
> >hwc_init_max_num_cqs, val) and has
> mana_hwc_establish_channel() commit a single READ_ONCE() snapshot as
> both the vcalloc() size and gc->max_num_cqs.  Should the documented
> contract land together with the change that establishes it, or reference =
it?
>=20
> > +		/* A NULL entry is expected while a concurrent teardown
> > +		 * (e.g. ifdown or an MTU change) has unpublished this CQ but
> > +		 * not yet freed it; the completion is stale, so drop it
> > +		 * quietly rather than warning.
> > +		 */
> > +		if (!cq)
> > +			break;
> > +		if (WARN_ON_ONCE(cq->type !=3D GDMA_CQ || cq->id !=3D
> cq_id))
> >  			break;
> >
> >  		if (cq->cq.callback)
> > @@ -1050,18 +1070,47 @@ static void mana_gd_create_cq(const struct
> gdma_queue_spec *spec,
> >  	queue->cq.callback =3D spec->cq.callback;  }
> >
> > -static void mana_gd_destroy_cq(struct gdma_context *gc,
> > -			       struct gdma_queue *queue)
> > +bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue
> > +*queue)
> >  {
> > +	struct gdma_queue __rcu **cq_table;
> >  	u32 id =3D queue->id;
> >
> > -	if (id >=3D gc->max_num_cqs)
> > -		return;
> > +	/* No rcu_read_lock() here: unpublish runs only on the
> > +	 * CQ-destroy/teardown path, where the base cq_table is stable.  See
> > +	 * the lifecycle note on gdma_context::cq_table in gdma.h for why the
> > +	 * "true" predicate is sound.
> > +	 */
> > +	cq_table =3D rcu_dereference_protected(gc->cq_table, true);
> > +	if (!cq_table || id >=3D gc->max_num_cqs)
> > +		return false;
> > +
> > +	/* Clear the slot only if it still refers to this queue.  The
> > +	 * Ethernet two-pass teardown unpublishes the same index twice, a
> > +	 * grace period apart, and a CQ that legitimately recycled this id in
> > +	 * between (e.g. a new RDMA CQ via mana_ib_install_cq_cb()) must
> not
> > +	 * have its fresh entry wiped by the second pass.
> > +	 */
> > +	if (rcu_access_pointer(cq_table[id]) !=3D queue)
> > +		return false;
> > +
> > +	rcu_assign_pointer(cq_table[id], NULL);
> > +	return true;
> > +}
> >
> > -	if (!gc->cq_table[id])
> > +static void mana_gd_destroy_cq(struct gdma_context *gc,
> > +			       struct gdma_queue *queue)
> > +{
> > +	/* A batched teardown may already have cleared the slot and taken
> the
> > +	 * grace period; then there is nothing left to wait for.
> > +	 */
> > +	if (!mana_gd_unpublish_cq(gc, queue))
> >  		return;
> >
> > -	gc->cq_table[id] =3D NULL;
> > +	/* Wait for in-flight EQ handlers that may have loaded the old
> > +	 * pointer via rcu_dereference() to finish before the caller
> > +	 * frees the CQ memory.
> > +	 */
> > +	synchronize_rcu();
> >  }
>=20
> [Severity: Medium]
> mana_gd_unpublish_cq() returns false for two different states, and
> mana_gd_destroy_cq() treats both as "nothing left to wait for":
>=20
>   a) the slot is already NULL because a batched pass cleared it and
>      already took the grace period, and
>=20
>   b) rcu_access_pointer(cq_table[id]) !=3D queue, i.e. this queue's entry
>      was overwritten by another publisher and no grace period has been
>      taken for this pointer.
>=20
> In case (b), mana_gd_destroy_queue() then kfree()s the queue with no wait=
.
> Can an in-flight mana_gd_process_eqe() that already did
>=20
>     cq =3D rcu_dereference(cq_table[cq_id]);
>=20
> on exactly that pointer go on to read cq->type / cq->id and call
> cq->cq.callback(cq->cq.context, cq) after the free?
>=20
> One route into state (b): for an RDMA kernel (kmem) CQ,
> mana_ib_install_cq_cb() publishes the entry, mana_ib_remove_cq_cb()
> returns early for kmem ("Then it will be cleaned and removed by the mana"=
),
> so the entry stays published across mana_ib_gd_destroy_cq() which release=
s
> the CQ id on the device, and is only cleared later via
> mana_ib_destroy_queue() -> mana_gd_destroy_queue() ->
> mana_gd_destroy_cq().
> If the device hands that id to an Ethernet CQ being created in that windo=
w,
> mana_create_txq()/mana_create_rxq() overwrite the slot unconditionally, a=
nd
> the identity test above then fails.
>=20
> Would it be safer to distinguish "we cleared our slot", "never published"
> and "our entry was overwritten", and still synchronize in the last case?
>=20
> I could not confirm the device actually recycles ids inside that window, =
so this
> may not be reachable in practice.
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > index e3c24d50dad07..409e20caeccdc 100644
> > --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
>=20
> [ ... ]
>=20
> > @@ -698,11 +699,15 @@ static int mana_hwc_establish_channel(struct
> gdma_context *gc, u16 *q_depth,
> >  	if (WARN_ON(cq->id >=3D gc->max_num_cqs))
> >  		return -EPROTO;
> >
> > -	gc->cq_table =3D vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue
> *));
> > -	if (!gc->cq_table)
> > +	cq_table =3D vcalloc(gc->max_num_cqs, sizeof(*cq_table));
> > +	if (!cq_table)
> >  		return -ENOMEM;
> >
> > -	gc->cq_table[cq->id] =3D cq;
> > +	rcu_assign_pointer(cq_table[cq->id], cq);
> > +	/* Publish the fully-initialised table last; pairs with the
> > +	 * rcu_dereference(gc->cq_table) in mana_gd_process_eqe().
> > +	 */
> > +	rcu_assign_pointer(gc->cq_table, cq_table);
> >
> >  	return 0;
> >  }
>=20
> [ ... ]
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index 92bb55935c1c4..5d215981bba83 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -2427,12 +2427,18 @@ static void mana_deinit_txq(struct
> > mana_port_context *apc, struct mana_txq *txq)
> >
> >  static void mana_destroy_txq(struct mana_port_context *apc)  {
> > +	struct gdma_context *gc =3D apc->ac->gdma_dev->gdma_context;
> >  	struct napi_struct *napi;
> >  	int i;
> >
> >  	if (!apc->tx_qp)
> >  		return;
> >
> > +	/* Pass 1: quiesce each CQ on the device and clear its cq_table slot.
> > +	 * Taking one grace period below for the whole port avoids up to
> > +	 * apc->num_queues serialized synchronize_rcu() calls (one per CQ in
> > +	 * mana_gd_destroy_cq()) under RTNL on every teardown.
> > +	 */
>=20
> [Severity: Low]
> This isn't a bug, but is "the whole port" accurate here?  RX and TX are b=
atched
> independently: mana_destroy_rxqs() unpublishes only the RX CQs and calls
> synchronize_rcu(), then mana_destroy_txq() unpublishes only the TX CQs an=
d
> calls synchronize_rcu() again, and mana_detach() runs both back to
> back:
>=20
>     mana_destroy_rxqs(apc);
>     mana_destroy_txq(apc);
>=20
> The same pairing happens on the attach error path.  So each ifdown, MTU
> change or ring reconfigure takes two grace periods per port rather than o=
ne.
>=20
> The commit message says the same thing:
>=20
>     Clear all of a port's CQ slots first and take a single grace period
>     per teardown instead
>=20
> and the comment in mana_destroy_rxqs() reads "One grace period for the
> whole port instead of one per RXQ".  Would "one grace period per RX batch
> and one per TX batch" describe the result more precisely?
>=20
> >  	for (i =3D 0; i < apc->num_queues; i++) {
> >  		if (!apc->tx_qp[i])
> >  			continue;
> > @@ -2448,8 +2454,24 @@ static void mana_destroy_txq(struct
> mana_port_context *apc)
> >  			apc->tx_qp[i]->txq.napi_initialized =3D false;
> >  		}
> >
> > -		if (apc->tx_qp[i]->tx_object !=3D INVALID_MANA_HANDLE)
> > -			mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i]-
> >tx_object);
> > +		if (apc->tx_qp[i]->tx_object !=3D INVALID_MANA_HANDLE) {
> > +			mana_destroy_wq_obj(apc, GDMA_SQ,
> > +					    apc->tx_qp[i]->tx_object);
> > +			apc->tx_qp[i]->tx_object =3D INVALID_MANA_HANDLE;
> > +		}
> > +
> > +		if (apc->tx_qp[i]->tx_cq.gdma_cq)
> > +			mana_gd_unpublish_cq(gc, apc->tx_qp[i]-
> >tx_cq.gdma_cq);
> > +	}
> > +
> > +	synchronize_rcu();
> > +
> > +	/* Pass 2: the slots are clear, so mana_gd_destroy_cq() skips its own
> > +	 * grace period; free the CQ, the TXQ and the queue pair.
> > +	 */
> > +	for (i =3D 0; i < apc->num_queues; i++) {
> > +		if (!apc->tx_qp[i])
> > +			continue;
> >
> >  		mana_deinit_cq(apc, &apc->tx_qp[i]->tx_cq);
> >
>=20
> [ ... ]
>=20
> > @@ -2987,16 +3054,31 @@ static void mana_destroy_rxqs(struct
> mana_port_context *apc)
> >  	struct mana_rxq *rxq;
> >  	u32 rxq_idx;
> >
> > -	if (apc->rxqs) {
> > +	if (!apc->rxqs)
> > +		return;
> >
> > -		for (rxq_idx =3D 0; rxq_idx < apc->num_queues; rxq_idx++) {
> > -			rxq =3D apc->rxqs[rxq_idx];
> > -			if (!rxq)
> > -				continue;
> > +	/* Pass 1: quiesce every RXQ's CQ and clear its cq_table slot. */
> > +	for (rxq_idx =3D 0; rxq_idx < apc->num_queues; rxq_idx++) {
> > +		rxq =3D apc->rxqs[rxq_idx];
> > +		if (!rxq)
> > +			continue;
> >
> > -			mana_destroy_rxq(apc, rxq, true);
> > -			apc->rxqs[rxq_idx] =3D NULL;
> > -		}
> > +		mana_quiesce_rxq(apc, rxq, true);
> > +	}
> > +
> > +	/* One grace period for the whole port instead of one per RXQ. */
> > +	synchronize_rcu();
>=20
> [ ... ]
>=20
> > diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h index
> > 0c395917b2144..0f591029d363b 100644
> > --- a/include/net/mana/gdma.h
> > +++ b/include/net/mana/gdma.h
>=20
> [ ... ]
>=20
> > @@ -496,6 +525,12 @@ int mana_gd_create_mana_wq_cq(struct
> gdma_dev
> > *gd,
> >
> >  void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue
> > *queue);
> >
> > +/* Clear a CQ's cq_table slot without waiting for a grace period.
> > +Batched
> > + * teardown paths clear several slots and then take a single
> > +synchronize_rcu();
> > + * single-CQ callers use mana_gd_destroy_cq() instead, which also wait=
s.
> > + */
> > +bool mana_gd_unpublish_cq(struct gdma_context *gc, struct gdma_queue
> > +*queue);
>=20
> [Severity: Low]
> This isn't a bug, but the comment directs includers of this header to an =
API
> they cannot reach: mana_gd_destroy_cq() is static in gdma_main.c and is n=
ot
> declared anywhere.  The reachable entry point is mana_gd_destroy_queue(),
> which is EXPORT_SYMBOL_NS("NET_MANA") and dispatches GDMA_CQ into
> the private helper.
>=20
> mana_gd_unpublish_cq() itself is non-static and declared here, but has no
> EXPORT_SYMBOL_NS("NET_MANA") unlike its header-declared siblings, so a
> mana_ib user of it would not link; its only users (gdma_main.c and
> mana_en.c) are both in mana.ko.
>=20
> Would keeping the declaration in a mana-private header, or exporting it a=
nd
> pointing the comment at mana_gd_destroy_queue(), avoid the situation this
> patch already runs into -- mana_ib_remove_cq_cb() open-coding the same
> unpublish-then-wait sequence with a different identity predicate (gdma_cq=
-
> >cq.context !=3D cq) from the one in mana_gd_unpublish_cq()
> (rcu_access_pointer(cq_table[id]) !=3D queue)?
>=20
> >  int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp,
> > int num_cqe);
> >
> >  void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
> --
> pw-bot: cr
