Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021077.outbound.protection.outlook.com [40.93.194.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C40D3A453A;
	Mon,  7 Sep 2026 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788822870; cv=fail; b=KZh2SPqmqkL6RU0RTTisKPtVixTgc1XWmOXTXzKvA/9+6XsBQFf8w1/q0Wtz9VY5WQ3e0ER+bEwOviHoaB2J+uwTDrDgzkJo7wwpZzPc8qHfjwindnpQBNPsv48RluIHtfedetGL7vns26U6KFgY01cI9pUzGh8/gIk6niCLt5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788822870; c=relaxed/simple;
	bh=Y+vLudvIY4b64ibRv04apDBtnE/ymLAxz2X2IXecMIg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bPz2Tu1fP3AySZScUsfua7oRS4e38iwnSZR4IA1eaTmGzN8bShYSvwWBYKb/ZgBdYgflwS5mkOfNM5npRgf27bI7BUjfxNQ1eU9uPPyKat8ydHeUqaCqFFA5jVchXhmYka2yjiN5SeWfDZIsHP5j7rKCbMm9YHstl+QRO8DWq/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=LcICpBuj; arc=fail smtp.client-ip=40.93.194.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="LcICpBuj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgI99GXgCoDVV6oM39X1xxrgt/0t8crYYZiumQ1s2e/uj0oOwOExFUlotZy/aXWLKoxIr1gqkKb9FQ+sG1IyR1WHxj9hSiyJD92LR88fzpa/6Pn3BqLFrHtSHSm6SYke5/uTL6Gd3eVUdZkbBJexGLd6KzB33Za98F/G0y+WBDZAd7YxguyhSS3mzbLTOVmxFTLhNykGNUCqSgJO7sATvnvrGsY5eBf1vLJ+LLB7zDlsuCAhT52TmzopnXo0ZuFyJYQIS5Mn5DxHitKLSVhIeWez01uUUKiQyQpCOaiKvtGovdQjZUudvmQx63wrCtMtqjGIKUU2hI12ValZF0DfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+vLudvIY4b64ibRv04apDBtnE/ymLAxz2X2IXecMIg=;
 b=feYEAvoyDPsUj1hPUS82VM1CdyvgD/5JHy6K1AdnsqOhrlmuJAM5qJWUHJjINk1d92PtyKiK/4WzhNcPVuGjJrGB0WWCh1Zpe7w8VwTzRXrPbUsR2kqL8B/iIGi4tZkjwmCrMqRV7q7sAKranWKgbaHcQSP1Sgvzoburem0mj/l5wA//oepNqistCnShMVngHHJRsbMYOKoTfn1v9gjAJWzq44m2XHYHs888AF5zMiTveYxcFFB3xCc7lDxLYuKGm50hWZ/KtrrFYc6LIkSId0JLyNE3wrtN2mssOk1gkYrMXdfVaf2ViIl3i2+tU7ezkHUTDUvLH1noTJIwgjSFBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+vLudvIY4b64ibRv04apDBtnE/ymLAxz2X2IXecMIg=;
 b=LcICpBujvwgIKS1BI2w7Raa01t/Z+YNUyCFr7eZhz8FcTzqDXSUCn0hwooqBMbLAao/WQuw6+KI7rlR6r2KRNuh2OwC1z29EWfCaJfYmHax1kA3lCv8Oy1KQxQPFCDgzu/xyQQnQ9fNpTX0VJ1FGtQWeyuzHXeNkVI9xwhEN1ks=
Received: from SA1PR21MB6683.namprd21.prod.outlook.com (2603:10b6:806:4a4::6)
 by SA1PR21MB4325.namprd21.prod.outlook.com (2603:10b6:806:3df::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.3; Mon, 7 Sep 2026
 23:14:25 +0000
Received: from SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18]) by SA1PR21MB6683.namprd21.prod.outlook.com
 ([fe80::8bad:6294:8a07:fe18%6]) with mapi id 15.21.0315.008; Mon, 7 Sep 2026
 23:14:25 +0000
From: Long Li <longli@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>, Simon
 Horman <horms@kernel.org>, "ernis@linux.microsoft.com"
	<ernis@linux.microsoft.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "shirazsaleem@microsoft.com"
	<shirazsaleem@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v3 00/13] net: mana: reconfigure
 by replacing the queue set
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v3 00/13] net: mana: reconfigure
 by replacing the queue set
Thread-Index: AQHdObORl56UnCqQx0e1x/hW63VD/La/L6kAgASX2GA=
Date: Mon, 7 Sep 2026 23:14:25 +0000
Message-ID:
 <SA1PR21MB66830D05FA11076C120BD699CEB22@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260901014442.2945689-1-longli@microsoft.com>
 <20260904175732.41c0d5b6@kernel.org>
In-Reply-To: <20260904175732.41c0d5b6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e8e5ecf4-664d-4cfb-bde8-df6851e015b4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-09-07T23:06:02Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB6683:EE_|SA1PR21MB4325:EE_
x-ms-office365-filtering-correlation-id: 4fb929ee-9da3-4ea8-0811-08df0d35c26d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|7146999003|22082099003|18002099003|56012099006|4143699003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 XP93sCSwPXk5JGSLP7KnoxEmaD/tqg2KqFrcqQsmb050l259+XmOjiPJU5KKMfZfH6biO8++s2HtL8rRp6OYwveoJwxfbmltr3iupPrI8psfi8rbpwCdgLDtYTc1h+QqOtlN4V7irPGJZIFVMVfZ0ld5fUDLprs9wks92/UXWSIaZpkhoN9KSlo3kWLXTuMIRvFqndgMSTyUBhtmCdvY7XvDpA/Solt+Ydv5uXm0PsSkLi09xImmrkLhrni5LUk811XO1M7U74O5IGCue9N1nExFnTP2JZLR4Kz/qCW+ZZIzeKszF3W+ik5jvxkyJW9IyrkNN9VqVhlM6For7iaK8OjXxtt5drmixZ9zPyU8m2LAoX8j/8yndShFoOeENC73ZHPydMXEUiiO/Us8+0Nr0YZzBuABx36JgzBkhT2mvQqKr3ZE7Y4QcBTIHO7k3YGQAVxOubW4JqTEMFrmyjsdcOHeWBmcKemoT+Vt/Wsssb+QJ9cnpVXyNf/fJr2pwnoV58/AOje4AF4ypSLJwZkLeN22CtI9k6AZUrITGKuOEOwMyzPe9zF/7HAequ0KlN0KIXKYTf2gb9GW1yoOZfEWrhWFWOjkebjNaBtLaScnk8kP3pbOgS8/UXopq1U+hQIhWkLAOm+FcrNELeDlnnQU7YE2/rif66O/mbSpN/pthhAYN0mwX88jxFAsFduJo7xO3NtYc1DCFULbNd3Useb6kjG2TjqMh4bzpMDivf3vE5M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB6683.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(7146999003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?iKlxYltseH+2mnZb6GYIGmg8db+VpURYE91nPNPB9ln8rOTWup5nyMURhWOQ?=
 =?us-ascii?Q?9MQWt2U5py1qB5Pvko9LlRL4d2vLHQ+hOyW1hRUUoWNYWBGa1NhNJpVYuNM0?=
 =?us-ascii?Q?ibbE2q7gTk5Uxg/jeEcpRc6OcDw/zIQvw9Xf4+9PO5Q0NZLMdtE92/Tl/5fl?=
 =?us-ascii?Q?NhCpqVNp2R3fFXPZEEqSxq4YIzQ8ssEyQUVLnm7k/hVLTeqXDfFeWc9zwazc?=
 =?us-ascii?Q?yvIrFqGYVYk5KbO2vJDAiZvTb9sd3aPmQoz8Li7zoyZqFHH+cG4E2UpeclsQ?=
 =?us-ascii?Q?Xi4ZYfbu2EiuMVTrET6yG7mNAzTSYK8h6PjU8YmGT8X33OOpr1sQYDMNtKGN?=
 =?us-ascii?Q?L/OjPfpDAo5e4If5U/HPiaUUcnjeSxqY3xdM3Wtm57A3YHm/qtbP1p6vMSGP?=
 =?us-ascii?Q?fQVL34KVQnYJmZWZpUufBC5pgj1vRTJPkwC1XVSHjP7XijamzM8AxpMXBVQy?=
 =?us-ascii?Q?FpMm3h/FGTW2C317paYV0Oyadl31vSamNE3TV7DiBbLviiSZBunQ2JwouDtQ?=
 =?us-ascii?Q?XfLSZEGlB/KCGmU7rL6RDZGxQ60qt+DXcFsLOVzclUVPS9jmH0IwDrikEa3g?=
 =?us-ascii?Q?KRUJMYFkinJYC46ciI62zY4gYidxOpRiqVKp3UpyKUQBN451sufUxBvJIMpF?=
 =?us-ascii?Q?ry5tkk5XJ3e8zNwqSGZwj8gtos/7pStwrgLAIhCgRW4dbnPNCe/rX5zAfC9y?=
 =?us-ascii?Q?HnpaXA/yNLITZkoWF22qefkG+ffXp3sDgl94KKI+b/uqxFZVtcMq8tOW6LW+?=
 =?us-ascii?Q?d+4lAn/qfQeOpbQQfjr1lqyRV/KQbFPG9jqvy5Q1i4mq3EUFF3JhpGIgKyWM?=
 =?us-ascii?Q?nP/6FhymWoLAZ1nD7OJNYy3IdiukYb0dJ35B/7OvXRZBrwdeQXCSVM0loBUh?=
 =?us-ascii?Q?z3bsO849Ggdp9YvhSRmFLh4XrVF7LcfectZuLGDfj9RAdZQFdzAoKD49ydGk?=
 =?us-ascii?Q?INICNTmVZo5obhrbAv0k0EvnQQpqSjkjdOHBOhtj7xK23wvH4Hj1NFxpmvIx?=
 =?us-ascii?Q?JSVaJqpdarpbvKeXgRZmWh9e797aY9fpMZiXwXaDYmf+meg1aXe8X9NFpC5O?=
 =?us-ascii?Q?eSVbwItEaTUqhwiL+C3pP6AOIS4MTjPG/nfvLJ9swYSch/jXZF9z2cqMww8q?=
 =?us-ascii?Q?aPddOZLqwscedRH/kmgEmjES1n5hHL1Z21HesEeGYz6h+nUeEsQdUlRxY/Uw?=
 =?us-ascii?Q?IXbav0UEISCZzVUqR90XvPM//WTdHJLLJp05rZKypuWsi9uwF/Tq2g9lzlQo?=
 =?us-ascii?Q?ZkfZcH1nmSoY+CcZWpopnE1HIP2eOKx+RGzlzXLZNtwNMQJof3hvl0Pn4Huz?=
 =?us-ascii?Q?APiKKmN2GboPwEDUVgMZxEiCSK+YBi39OETFoMajzgHCDmUX1R935myaz9Fh?=
 =?us-ascii?Q?t2q4HMf7ysFXVL8WY8a9mPfjsJRbzn5nGcYUPqRRRnTjFAa0E27mFO1uVfPK?=
 =?us-ascii?Q?x0wnTOmASi8na/5GQ2CxpE4LMISnUKhU+IdJWo3Dw4D+FJB+DgKCQzPHevMX?=
 =?us-ascii?Q?SkI2vOcVJCNAT8yzsEEdGNxdMTLOldyl0Zg2xkrWFLHdFpGynIAdAjc+6ng0?=
 =?us-ascii?Q?qD1qKyXxVOP+8xq7TX03YUCQAThtbtU9PG8AQg4YCmyV1R19VKrgIV81ThOR?=
 =?us-ascii?Q?0yd/l63gDr1MHkqTCWCsKCbe5Jn749ydn1wJEs+V+WBoSfJvCmoN1Cr7DVpG?=
 =?us-ascii?Q?lvG4y/r7TKOAbHp8iNc8//8x+z5Pjgsdgdh2imGboEXfDKez?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb929ee-9da3-4ea8-0811-08df0d35c26d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 23:14:25.5865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y4giHMnvymZMum4i3BnF8gwMonRXITcEgJjsclgZIzoGBuEJd1u8qHkTfQjmQNhSIjam/mUV6kGgJ52m3FbHFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB4325

>=20
> On Mon, 31 Aug 2026 18:44:29 -0700 Long Li wrote:
> > MANA reconfigures a port by destroying its queues and building them
> again.
> > mana_detach() tears the whole queue set down, mana_attach() allocates
> > a new one, and every path that changes a queue property does this: the
> > ethtool channel, ring and private-flag setters, the MTU change and XDP
> attach.
>=20
> Given the sheer number of reports I'm going to assume that at least one o=
f
> the Medium+ ones is right and respin is needed. Please LMK if that's not =
the
> case.
>=20
> If you're respinning please take a pass and delete the more pointless
> comments your LLM has added.
> --
> pw-bot: cr

Thank you for looking at this.

Sashiko flagged that two fixes should be sent with the "Fixes" tag. I have =
sent those two separate patches to net:
https://lore.kernel.org/all/20260904202640.3900685-1-longli@microsoft.com/
https://lore.kernel.org/all/20260905004401.3937066-1-longli@microsoft.com/

But I can also argue that those fixes are related to this patch series and =
should be included in this series instead. Sending them together reduces co=
de churns.

Please let me know if those net patches are appropriate, or they should be =
sent part of the net-next series.

I'll respin the patches with all the Sashiko reviews addressed.

Long
