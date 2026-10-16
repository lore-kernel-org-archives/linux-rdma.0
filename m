Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022106.outbound.protection.outlook.com [40.107.75.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A0D26C385;
	Fri, 16 Oct 2026 07:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792134845; cv=fail; b=q5xZIhTOVpJfYmnOHcKmyiUMz1Y1oKUko08OlaCo1AoPE2vCiBZMaTQcYQ/N2uRFJIXJ4omPi8ZkGOQzhaK/HW2w7SjmSapX4ZxvN8E6wWux6XVF1PYjByY0Q43EVAAX7uuF9GNtvOS+gVlTyNrYsnWoock331IDQJQPy/LB7mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792134845; c=relaxed/simple;
	bh=nCcN9sSsQAOkTi1V3Y3LwM/50I80L61sATf9wQ7RPZw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SikmKujoT8n6xs0fkcZbrJY/HzjScl/dspoMjZ4VQxw9xB+NSq8vPGeE6uwDvEWdBOkF3G5C2E/NL/qM733BhGD81202T+Klsmyg12bvTaGFOl5fr40rpHgqGZer9KhdIn8A7KCUir7UkUC0RB3wdUtAVfuBPGnLsICRq3grRns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=MF9TK6vL; arc=fail smtp.client-ip=40.107.75.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="MF9TK6vL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SgovJESpLZ8WKnQOXEXGW8euBpYlrr5mY+iqCgZrSqOTLDS45uZqOE6W/L9H3ZzMNYxsSVSI7eMWfrBiOJDHX5nuypc6akZ3u0FPdoJfmwpBlhbIpgaeYUnl5Iand/8s5s6/Qs8jeK3fFeWqfTgT43Oea5EZMhzYHnu7ZjSnCpr3qJPthgroWji05CliTcIyvnZYtdmDYKRVo54vhSZc0ZNv2mjQC0bP1qnuVfLKLHp/+Sr83uXtJru1FPK/dWpyx01rRh5mCbqPwt055Xfvpf6jbWzDJ5Q8q/PCcFqSpWuHIzcTi4PoWhaDLapkb2B7XKSw2w7fErC4H2V9E5/MaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=nCcN9sSsQAOkTi1V3Y3LwM/50I80L61sATf9wQ7RPZw=;
 b=ian0arpR6fmCAtXAfw2xbXG6bBi6jepMpdkh/obMbW1wUJYzI/sWJjinIRnmEO1CiyahFvOfRhtlKnYMV1SMjyhH1mcKIXqK2O4WI6QdTmb3m2qwW9K6/2BczFJLHOS8h1vMpRcOuNrW6T4R99PsNKU4kV3vYI56jP+4NUvP8HqmoF49LZH+ONaBbQJoZ1eIaBm5DNPmwt20oZ3UyVUR/SEQh8z7TfwrJLGqbhhhyp5UF5CM+4JGIFHgSvivCxMBLfPe5/JOCCENc0NE0KaGaXLEMTBOaKpCezV03kUMDwG42aFjAJ/WOSvPFsa84ms351/mE/aEOKyTelBYqkjHgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCcN9sSsQAOkTi1V3Y3LwM/50I80L61sATf9wQ7RPZw=;
 b=MF9TK6vLZnEIrG5uaxN4BCcJ01VJHraziGBmxLzrPjVWj/mjQIgobbdiHm1Rw0poalL59K4yt3ffDwPrhfio8AY53sCoRzixe9IBa4n/vs2TBFNeaPRO7tAYrB3EamC19k+WnkIl8XISxyxTVosMKPwUJEU3g1hjbGpMzNfuGkY=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SI3P153MB1574.APCP153.PROD.OUTLOOK.COM (2603:1096:4:29f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Fri, 16 Oct
 2026 07:13:42 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 07:13:42 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Index: AQHdWum3Mxfmd9EpNkaXqZjXFQKoi7b8r/2AgAMPnDA=
Date: Fri, 16 Oct 2026 07:13:42 +0000
Message-ID:
 <SE3P153MB1848625E66EA6C21AA4CB7A8BB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1791561995.git.weh@linux.microsoft.com>
 <e6ef84d7481de34f259d2b244f7994e3f1d9ab6f.1791561995.git.weh@linux.microsoft.com>
 <sashiko-outbox-170992@kernel.org>
In-Reply-To: <sashiko-outbox-170992@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9301d43b-6341-44cb-bcdd-a93470e634b0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T06:51:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SI3P153MB1574:EE_
x-ms-office365-filtering-correlation-id: 6b3c89f3-2fca-4e11-a9bc-08df2b550268
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|23010399003|42112799006|366016|38070700021|56012099006|4143699003|11063799006|10067099003|7146999003|22082099003|6133799003|3023799007|18002099003;
x-microsoft-antispam-message-info:
 cHkz2MUoU1/ljIKL6j4c/GhMv7cPXuGL78zsBg5KwlM1QAytjwzsyIi46OuA5QocFELuWpzxSGb6XpNZmZ8vivuaBoIUnO+o1DGpAGL/7jL8l/Xwtpdoiit8KqMWEpgJyMcNaLZedBUMdkFSgZH1yEkyVEgaqBppsSj/z49XnMUvDx2RqYkMgG4C3oEBStwqSkFOy9nBZ+tKfT4J5yljUu0kCfJPluEr6OGdCGtVu+w5uEwVSfI3aFZXxUDdoSl8k4lQFsL7N0s9gNTEt7K7Zi1hgUUXPmxKsC4GbDiIiQJ+tqaFASWEMup7coAVBS9gEDdC5U52+w8Uw+SmJzH962XjjYWInU/jx7Jhk9MtkwmRyPG8tTb3yWToRO6lXhGfq3nBT0vzcsBdvOlXY0yMTjePBApoqfSN3fGCQJhnkQaMvTANSCxzH+s/IT9uKLhlm1eAR4hsVwlkW+pvWPN8nDhsX1Lm5u0ia6x0Ta6VPwwaliDsf9HDBL/vnX2ovGAzn9QJeFWCIu26feeq32DDqIhoOAuWnCwdKN2Hte+XElLQ4KT1inWUpZatvgnOHc/b1vtyV6EJyMsUZ7lVxs4UJzEsqvxhLqCDXT+G84VqhhpcHwKigqRiDLJyXHtFFC3tSIe3erIN+KafOQA/xLhhrDyygwBOoKNE1vbcZtfCHkJZOm7261fsUOyDX8Ro6H+kqCq6LR1oL4EFAN42B2NDQDFYXSnJQEyGaH2a8lEj28Q=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(42112799006)(366016)(38070700021)(56012099006)(4143699003)(11063799006)(10067099003)(7146999003)(22082099003)(6133799003)(3023799007)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cscd33BL2G46R+Zyb8a53JPD10LcuNGCDqy3ch+nWdhDXLnlRLRbnBN8OdMB?=
 =?us-ascii?Q?3wAexktO2oTrTN3cUMazHcNHKWY7Ane8MOlun2JvQNRsa8dBJ5o6335PUPGJ?=
 =?us-ascii?Q?nnuL0+pCGleL6IZdWHHKsqIQF6R7ukYf5C4Y4T3i6vvcf5TlkGZlAwsqTGSZ?=
 =?us-ascii?Q?hRAu+xxand9ln2U1fBDGvergShuNpTbic+hWyobdv95w8FIZzsGXoM1I/IFQ?=
 =?us-ascii?Q?FIU7XDzY9x5FOdnfh4631A3hT9wpxbuso9ZUy7qfa8kBm3pCHOuozu44DrbX?=
 =?us-ascii?Q?gKjRBTaM6HFVFkfv6G43UWhpALQOqFKXi6QoBuTNQCW23eBfnNEmRTooBgjD?=
 =?us-ascii?Q?FqIzOEPKYeeL4JFhaGjg5m8GqMOzU6P/Ad2Fs9t6oZbBNdpYb5/gD39VF6tV?=
 =?us-ascii?Q?aONXLWE32ooTADitSBPl1/mzLHHA7sPsdibNXaI9Aq4Xx+Zltzojmk1sSdRr?=
 =?us-ascii?Q?GbGDJACa5Eva8QStjAAw6CgSP72N6AMKmqjk4gP4jOTPq9VVdO3SeGsstl7N?=
 =?us-ascii?Q?2emgmEr+OoP/zOp9t9maMwsKUUCnbs0Bctjamomi2fgBg83l5IWiMW52Uc4I?=
 =?us-ascii?Q?jKHFeWAsATlqsUSxTrgdx1Tq8aEShaDRAAEE0UqRYAYKj6yk7PGXBSm9UAIm?=
 =?us-ascii?Q?QKFxJZbQ3OXDtdrvAPrNeSYyI/gp6GHcQ+uBGS3n1XuVliUEJ2033TW2KB56?=
 =?us-ascii?Q?4wZksbkvWBP8wxE6Aa61/hEJlRpTlp+kCvoBjr5sGKT29f3TWT2mXHzZBhVn?=
 =?us-ascii?Q?bYzMCR+r/7VDlnSELo+anW3sr9c9fJR/vLUWzoTCXXGZfgo3HujhK3MKqlFA?=
 =?us-ascii?Q?RutFnZRZabET3Xt8T6XUKZ7PC+gQOeo/JrPL2qjDwJ8h0Et/IJdjS7EWlY2/?=
 =?us-ascii?Q?Oxmx/hMJuDDY9ogAYszugdi54HEM2Y/ZFIYbBont5H4j84/tZgJHAz83kaFv?=
 =?us-ascii?Q?WGCYoW2jjUSYwq51mlvUwewc4xoDq4P6PI7n03iKO9ByGP4CjwZEsh3pdMO7?=
 =?us-ascii?Q?D9jxpx4pXlNQDGMbdwdvktFCWIszSxSMnYssJ1y8YMqQ2mwdk1BVsSHdqOWj?=
 =?us-ascii?Q?UR42VxCweMIvdokbFA+vvZcerudcDUeFIQjBJ9soQk3wpDlR8hAwdXDiIQ2q?=
 =?us-ascii?Q?f/fb6ICyrACbMjrwX5oqPSt9R47jx3K9TbvGocBgMdaUgjMYr6tI7T7RwpJi?=
 =?us-ascii?Q?Gfg2yhpFjeoHYfupHeg+3AcBK5TEclCJ1USZdKgCUNlBPUvPh8QwJUo4AYD+?=
 =?us-ascii?Q?2p+vOYseZt6QFRfIZ/rnZEylJ4+jm4Ug2O3j5h8S/h7fBaZTSp0heH43xX2+?=
 =?us-ascii?Q?hyR1ZnyllijShzjI5ks1DI0SUauSuBgmYqAeUp30Sj0gDp2HvxfTU1ukuzAr?=
 =?us-ascii?Q?2iGGlCqpEcfNSr50eEEGL8lnBJyWcRlb2hY+i9jQsjHvhJkV2wKOAFzajYLD?=
 =?us-ascii?Q?oD57BnDAOkgOCNMHbeAYtorasQNLLV6/X484ZarhVOKT4xkBLAroGElrBsUi?=
 =?us-ascii?Q?uoaigmXnmI4y1LvH7Ti6xcXVU392WOGaK7YIn3ArqHkiHLgjgDyaSgamQL9f?=
 =?us-ascii?Q?vTZXgBxlMRIiNGs1I2ZemHkPnPRKIACWinWnDnKnpRZvT8w8XM8l9jjXy8aG?=
 =?us-ascii?Q?VTEEVWMqyjl5ZQWNNFzzU4d74xl1nTswpW/XQojjIj1Xc7jkf8Gjz1zCQ1HZ?=
 =?us-ascii?Q?5q5tckE7Ksh+MwELNU7iccrpmvRKj+unOIha94XAlmwoVVKj?=
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
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3c89f3-2fca-4e11-a9bc-08df2b550268
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:13:42.2245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: THJasuZSjdUdgm0QKQoZiqzzR1cNZWa6yFyvL+sGzF9OQAhbhqywyVui3awCmyMV/nCBz6HERhsTiLMQ3OHyyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3P153MB1574

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:06:25 +0000, sashiko-bot@kernel.org wrote:

> [Severity: High]
> During HWC teardown, the dedicated HWC EQ is fenced (which includes a
> synchronize_rcu() wait), and then the HWC CQ is destroyed. The CQ memory
> is freed without a subsequent RCU grace period. Can a concurrently runnin=
g
> IRQ handler for a different active EQ (like an ENET EQ) read the CQ point=
er
> from cq_table just before it is cleared, and dereference it after it is f=
reed here?
>=20
Addressed in v8 patch 1. The CQ table is withdrawn and existing IRQ-side
RCU readers are drained BEFORE the HWC CQ, completion buffer and queue
bundle are freed. Fencing only the dedicated HWC EQ is not used as proof
that another EQ cannot hold this CQ. The ordering is in the owning first
patch, not a later repair. This is HWC table/bundle protection, not a claim
to repair every individual Ethernet or RDMA CQ lifetime

> [Severity: Low]
> For normal networking queues, this happens before the EQ is fenced, so th=
e
> EQ handler may concurrently execute the READ_ONCE(cq_table[cq_id]).
> Should this writer be updated to WRITE_ONCE() to prevent a formal data
> race?
Fixed in v8 patch 1: CQ-slot clearing uses WRITE_ONCE to pair with the
annotated reader. This annotation does not by itself supply a grace period
or solve individual CQ publication/lifetime.

> [Severity: Medium]
> During driver unload (mana_gd_remove), vfree(gc) is eventually called, wh=
ich
> destroys the parent gdma_context and permanently leaks the retained
> gc->hwc.driver_data (hwc) and gc->cq_table on this error path.
>=20
Fixed in v8 patch 1. A retained channel remains available for retry while
its gdma_context survives. When a PCI or CDX path finally discards that
context, a common final-disposal helper now releases software-only
wrappers, caller state, the bitmap and CQ table after the required CPU
users are quiesced. Coherent allocations are deliberately NOT freed without
an acknowledged ownership transfer. This fixes the additional software
leak; it does not claim that an unresponsive PF can be made to release DMA
memory.

Regards,
Wei
