Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022095.outbound.protection.outlook.com [52.101.48.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416E73911AF;
	Thu, 30 Jul 2026 21:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445864; cv=fail; b=hDoWpfwGQibsIYRS6hd/ikWpLcRGepigGkiDOQOvsc8rdVgFIDXLv8nLHY09jQEfvmNUHemhWpuBT9+b+CWmr6euFrBsJLrKvXBBtBvAuqQjdkPg4qvd2t+cwbCyQmAHOrlsJXHJi6UPjldIBl7pVKfoEMXfF/CPEeQrN61UYSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445864; c=relaxed/simple;
	bh=uFDlcEODU8eiS927kqwj0RXpI96wJuLBIczsLVSxkVI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ck9RpYHOa0DfvIL+vPZnVAgV6feZrasAaVTE4mqAdn0ILZpiFCE28kEbUnfFgYP+SBTLwjA4iQnDPamFYer3kAvpk+zl4j+wGee3AfWUGpYHcyFmpJfwvnwRtXK7gZTCb2rBPoNf7J95Rnsplq/PgIDzTXdsFhTZOIpKqy2N7Ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=HqNezl9i; arc=fail smtp.client-ip=52.101.48.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="HqNezl9i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qf5QEr6ep3P+B13RgYZ2mIgshHrGHqGdWSRlcccNwwm5fN67eiLEwm0y7R0fpwvDoRH9LX/IROI8Y0/XByxNDk35l4vQbqtSY08TsuHdhAMG2Nvj/3Aur0OaWXM8tSc+lBYbeyIxvhKkdhucllmfkM71+0RJltUz6Dejo21O6UixwAqyuDks83ZQHEcPEjAHoLCkMggmcv5N4EDmDRlSLBQ7miDTgMwKS2anS4wmT4wvEyL7H3PmHVXDcqB3FK4Ru4XzLFznfgpqIlPBXu73H7uqFvqoYohncBj0oSHFfZluWhD9xAo/vWwqeTDciT1sOgS8MgLXz07YiCpN3YsZJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0H/hibzo9dpFkoPbA5S22ohFpMu34glstoYR+VOAHfM=;
 b=G1EZBVW+A4v6rrkDC0YdhujN51WVwqLziVP2L/Z9GaHIAqo2LS9HrS+kveXIMN9vXHM0bBlYZ8Jq61NHavyqVJOzqhVgsZZxIzQs8QuDvliDSZEOilbRP8+bBkA5ibfxD3WkAUlFrNrsYgOecsO9KJJ5SPYI0KDjgtbt78PIWtRP1JskBRagamjZtJez36MxhWUq1/IfHWaYxB19l/156gSV6U/mnXTZpsr4ED9vnPa/bLDOzEOUROeDbIKbKc8d3xvpAPazJUAyQM32Bv/EtN611hjUBGGgJYQ94k9HxXbQ15WW6e9RQ/w3Z0w6j/Nr3U06QWnrvZTJIOAMLz/w5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0H/hibzo9dpFkoPbA5S22ohFpMu34glstoYR+VOAHfM=;
 b=HqNezl9iMnqfRJoGtmNO0uyFo6AWgNR2y27AEyejxAtA0H1iXWPlbxA3ZAQZU2/IcW7UPJNHLEjGWBr+QZPmloj/qDMdoom/gwS8pTZWDZP6aYkJC2c9Ay3v0ER+i/8UjQEXdbvl0afhcK9EBE+Aq6vuBoCSAfQokHwO1d4dl4c=
Received: from LV5PR21MB4704.namprd21.prod.outlook.com (2603:10b6:408:307::7)
 by LV2PR21MB6211.namprd21.prod.outlook.com (2603:10b6:408:34c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.9; Thu, 30 Jul
 2026 21:11:00 +0000
Received: from LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb]) by LV5PR21MB4704.namprd21.prod.outlook.com
 ([fe80::144b:98da:1262:2ebb%6]) with mapi id 15.21.0292.005; Thu, 30 Jul 2026
 21:10:59 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Damato <joe@dama.to>, Haiyang Zhang <haiyangz@linux.microsoft.com>
CC: "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, KY Srinivasan
	<kys@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
	<DECUI@microsoft.com>, Long Li <longli@microsoft.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>, Simon
 Horman <horms@kernel.org>, Erni Sri Satya Vennela
	<ernis@linux.microsoft.com>, Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>, Breno Leitao
	<leitao@debian.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Paul Rosswurm <paulros@microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next] net: mana: Extend RX CQE
 coalescing up to 8 packets
Thread-Topic: [EXTERNAL] Re: [PATCH net-next] net: mana: Extend RX CQE
 coalescing up to 8 packets
Thread-Index: AQHdH60NAbCTQ7nCeEOGyXAU5iVN67aGOCUAgABVgVA=
Date: Thu, 30 Jul 2026 21:10:59 +0000
Message-ID:
 <LV5PR21MB470435BFD268BC00B7C7E8E4CAC92@LV5PR21MB4704.namprd21.prod.outlook.com>
References: <20260729225235.3573786-1-haiyangz@linux.microsoft.com>
 <amtzyNmcIIYy6/bK@devvm20253.cco0.facebook.com>
In-Reply-To: <amtzyNmcIIYy6/bK@devvm20253.cco0.facebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0d8b907d-3f1f-4f0b-b08e-c7d17a98a087;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-30T21:00:50Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV5PR21MB4704:EE_|LV2PR21MB6211:EE_
x-ms-office365-filtering-correlation-id: 292aac4e-36f9-4dab-3dd2-08deee7f0def
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|38070700021|11063799006|56012099006|7146999003|10067099003|4143699003|7053199004|22082099003|18002099003;
x-microsoft-antispam-message-info:
 qUt2F7KTDrn1do0rWCNFYHJXjksWeIJpQQphWKVOl/jSRAF31jHdbNtflTbrghIDDobpMOTGc3MvlIKL4XLHVtDgEvSeL50GMHvGOqV829yrp3aH5AQfQMjtSTr/rshQvAY9AjdSBnCo4JSArCC5RDSQmfiolYyYrkclKbHzsXqgOh5e5Ai4a64++p+04cqjNsyBXiP3AAPTT9Dllpafef43+7J8y8M0Y3Yaxd8boBczUrU79x5vRnGTYMEuooHammrJtYMpj53VxJOjp+BxPiEc0yk4UVQJz87SFD2rbJihvTG7pZH66K08rNILgFHeywm+hnYIsdTcG/BgVxAwlTbT77stCJrF4mMFUWQqLzeJDcdJ7kOF6lMiX8s9M9gUxXkiWu2AvlXd51nk2+4rWFtDVd34xll25iFFwi3gcvcBbY0IkdZRrtfbRyu+GViqp9X/D4jGU+g5HUwLaxT0+ICMWathEoLTrtW5kvAHrjwUkK8bxHyTz2UxhKBXPb2GTE7ojYQoQcxORtFhe7MtUE6FGD5RqvDdZn5grNYphguMDjly3m/kii969IExKvwurnoU0vlzTixs94wwtYViUO3lGVOVC+SBKF2orisHT//plhG8cJcrvIiU+Q7PmQH/Cd4mEudDcR8vpYTt1+2GhKFcD1b7KcDC4UF2RRNtbU/wBkcuNrcCkxcmTQyxGpuDboNqL0smFEd2laZHvuS+4wJXGvWcE2xCXCiPUIAxl3I=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR21MB4704.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(38070700021)(11063799006)(56012099006)(7146999003)(10067099003)(4143699003)(7053199004)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?6x/lWT8fIH09Bzg04mHwQ+h1uwOJVD1Mct3E+PhLQ5MSIq6t5dLUYZYla3cb?=
 =?us-ascii?Q?eyEEkyoY+xu7x3z/DHCky23z1apVVtpjF6MTdBjm2fMurAOsgP3vJeqRPWSy?=
 =?us-ascii?Q?fJkp0NtcJiLZ7+OvoYlOBmCvrFoTMX/o4EaLCpgH0GIaR/oHRRS8Udvs6g6c?=
 =?us-ascii?Q?FuTcFA2KvkxdgSCjTDBDHQzDIyUHVjxPw44f7IkdkzOtqPAn+xCp0H5Tih+c?=
 =?us-ascii?Q?ODN2NSc3JkZbeaboRUqPZ3ONGZVOrJrkofCdOCqEUnKroVAqhAS18w2fmzYt?=
 =?us-ascii?Q?qF2FVPwzkMF4Uyp6mfxthwbxr4VQNrznJ2hmKivqfftaY7iAHB2z22hYSfma?=
 =?us-ascii?Q?0lL5tj2Kr8TjxHF/nZlChnP3ecakxcT1cvDCwcqhb9M2LpBp4mSNWyNsuc0J?=
 =?us-ascii?Q?0P3f9ttIyHzYHa7OdNREzp1ergz6BMgb+XTR8L2nYP5mXs8Q96rBCcLljEH9?=
 =?us-ascii?Q?+oFIKvqN65DJVW35i4078QkNiCS/nbXlR/Ef2JYSdNMO+CG+8gQgZRE857j7?=
 =?us-ascii?Q?6lg+9ZabzVyn+HhIY0ngjVAokiDXy6JIosQSGv2LM4qUZ8mlkF4mbXDa8RcM?=
 =?us-ascii?Q?rfB0Sano/nHRdYb9bXKwpFzqLWb/Jn9BEJ1c40cojtTR5B2ZvStubBycmzsa?=
 =?us-ascii?Q?A6JHC/6/inS/zpv0ulxrK99f57eSLYgmYioBcU8Yf6Lay2YPW5oXs1zFPkUF?=
 =?us-ascii?Q?XK5M2/k0hlW8fA29toNBLSyJNCkQnljoBzRWm6wYbc9nLAgtdqI5brGzXdH8?=
 =?us-ascii?Q?30CNlOmTBJhOdrIfGWod5dCUkZHMUsFe9khXCo8aQzBluZk9V0sARd/cZ4/b?=
 =?us-ascii?Q?knIbpdmZd3r7pZSPAXSI5kQIKOd4y63Y5whk3dOzhxwRzqBlthz9HaNlH5NY?=
 =?us-ascii?Q?kkGjK5+yJorNyuH3dqycXuSPJZUtogiyBeAHxZIbbJYU9isutLL8hg5RiHM9?=
 =?us-ascii?Q?54FC+vPocIpFybo8lyLJWnfsXzGJJS9GaSqZmsaNbGh/9TPtMmCDDCP+/bW4?=
 =?us-ascii?Q?HKysYRg8zstL/nHXsyirX9gs1HoIanO4njPN4KnMyaErawONiWn3BWkbdRF/?=
 =?us-ascii?Q?6NYen3zU2z05/kqFwUq3g4x+2R0OpmqFbdWwWAMMQUVYgSWZKxLraGbVIwO5?=
 =?us-ascii?Q?7FAjFWFxnYluZVprw2xpLwGr+9PMgoz6d5AmFAJFPMaWmq6/rzJiso+jfAGJ?=
 =?us-ascii?Q?0LHJCxQvFcxLqEh7LVlqIiKoqAQyAwIx+rPL0eX+6vXZRdIm2/1zUdC39TtZ?=
 =?us-ascii?Q?sxU6gGjLGdrdZNpclUxeCezvJ0J4hMs5QaNRyXZ21S6XjN4Sx9v9hrZzf+jg?=
 =?us-ascii?Q?zsWuX+cSGK6JShbYzzmr7g4UvvLyTy7j2Dcj1goLvnjRKi0pF0+2QK24CD1A?=
 =?us-ascii?Q?DWwncoCpKyuE5wEQuGl7AnVzbmYmKCHe+iD1/TCBevgMoJUQyAJpTim3aWsV?=
 =?us-ascii?Q?yoCV4vn252Mw/vhkA4zzdVswj4OKIkFjuCiI5cIXvk8NQrTeMcbUJdwEEdXL?=
 =?us-ascii?Q?pX3EHwvmM211BpA4A3KhqSaH/zhCLtcnkdPCxEj4EhE+PdlEa9ATPbsTC9GE?=
 =?us-ascii?Q?ZazS/j+2uh5J7t0vGj3b0Dw+qM71G5JiDb9W7MQwHI4FPmHgwforutSjpvlZ?=
 =?us-ascii?Q?Ofn8RS8wWK7NFMYKVXI+jnGdSH2Zb87kKHU+Z4SiklWlEOc5BuCbiJ8+i/DE?=
 =?us-ascii?Q?lCrW+ATC/zH//mKU5ml7hFa0Gzcb1M868stinGK4Z6eT+K+SimTuXxjkSKio?=
 =?us-ascii?Q?xxZGzw6IpQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: LV5PR21MB4704.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292aac4e-36f9-4dab-3dd2-08deee7f0def
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2026 21:10:59.5194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I8kWxFNhhdcqpVj18x+tFq3DrgwL61dokMrAjheWp3UrvmFvKuIbN02K/bdZH54I0InF099UjvzQHHGIoxJ0Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB6211



> -----Original Message-----
> From: Joe Damato <joe@dama.to>
> Sent: Thursday, July 30, 2026 11:55 AM
> To: Haiyang Zhang <haiyangz@linux.microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Wei Liu
> <wei.liu@kernel.org>; Dexuan Cui <DECUI@microsoft.com>; Long Li
> <longli@microsoft.com>; Andrew Lunn <andrew+netdev@lunn.ch>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Konstantin
> Taranov <kotaranov@microsoft.com>; Simon Horman <horms@kernel.org>; Erni
> Sri Satya Vennela <ernis@linux.microsoft.com>; Dipayaan Roy
> <dipayanroy@linux.microsoft.com>; Aditya Garg
> <gargaditya@linux.microsoft.com>; Breno Leitao <leitao@debian.org>; linux=
-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Paul Rosswurm
> <paulros@microsoft.com>
> Subject: [EXTERNAL] Re: [PATCH net-next] net: mana: Extend RX CQE
> coalescing up to 8 packets
>=20
> [You don't often get email from joe@dama.to. Learn why this is important
> at https://aka.ms/LearnAboutSenderIdentification ]
>=20
> On Wed, Jul 29, 2026 at 03:52:22PM -0700, Haiyang Zhang wrote:
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> >
> > To support up to 8 packets per CQE, put two packet lengths and
> > hash values into one PPI entry by using the reserved fields.
> > Update ethtool handlers to set this feature.
> > Update per queue stat to show the coalesced CQE counters.
> > This feature is supported on NIC hardware showing the relevant
> > PF flag.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/mana_en.c | 137 ++++++++++++------
> >  .../ethernet/microsoft/mana/mana_ethtool.c    |  30 +++-
> >  include/net/mana/gdma.h                       |   4 +
> >  include/net/mana/mana.h                       |  43 ++++--
> >  4 files changed, 150 insertions(+), 64 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index a8c329bdbacf..720d22e6aea9 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -1241,6 +1241,9 @@ int mana_gd_query_device_cfg(struct gdma_context
> *gc, u32 proto_major_ver,
>=20
> [...]
>=20
> >
> > +static void mana_process_one_rx_pkt(struct device *dev, struct mana_rx=
q
> *rxq,
> > +                                 struct mana_rxcomp_oob *oob,
> > +                                 u32 pktlen, u32 pkt_hash)
> > +{
> > +     struct mana_recv_buf_oob *rxbuf_oob;
> > +     struct net_device *ndev =3D rxq->ndev;
> > +     void *old_buf =3D NULL;
> > +     bool old_fp;
> > +
> > +     rxbuf_oob =3D &rxq->rx_oobs[rxq->buf_index];
> > +     WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu !=3D 1);
> > +
> > +     if (unlikely(pktlen > rxq->datasize)) {
> > +             /* Increase it even if mana_rx_skb() isn't called. */
> > +             rxq->rx_cq.work_done++;
> > +
> > +             ++ndev->stats.rx_dropped;
>=20
> It looks like this code was moved from mana_process_rx_cqe, so this is
> prob
> out of scope, but I saw this and was wondering if maybe rx_length_errors
> is more
> appropriate?
>=20
> from if_link.h:
>=20
>  * @rx_length_errors: Number of packets dropped due to invalid length.
>  *   Part of aggregate "frame" errors in `/proc/net/dev`.

Yes, it's moved from mana_process_rx_cqe(). We can consider a separate
patch if any changes are needed here.

I found: "Linux rx_length_errors is a network interface counter that
tracks incoming packets dropped because their actual size does not match
the packet length stated in the header."

But (pktlen > rxq->datasize) is different, it means the len in OOB is
bigger than the data buflen, which is a HW error, and unexpected. So
it probably should not be put into "rx_length_errors"?

Thanks,
- Haiyang

