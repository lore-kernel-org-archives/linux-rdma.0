Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022095.outbound.protection.outlook.com [52.101.126.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E3435EF3;
	Fri, 16 Oct 2026 07:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136434; cv=fail; b=jDV9Z6dRgDHoKcaL5ZhzOgcSOoJP01RZOSljFd+fzMM5R22Alv1fuMvDQGyYqn60Xm+khtd2l3+Jwlin6ioEOPvZVreqvsw1bwdm+EhiMqQGrsL7ASwfmW5rR8czwzAErdAdxsi4c2ppsRvkbRzZZFyBBSLnSMnGH8tBDBb+xk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136434; c=relaxed/simple;
	bh=lhom33XahgFvALtpa5UizGYySZHd2yRTsOEdRWXjRg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iulk9sKK+d4ue8Fv1LqEBXUEWKad56VwmyLTQWO4uTs955z1zqm509SXaVb0ix8obVIYprE396xsYUB4tBaMye7GOdWpS7TBq48MLVmlwMIUXOIxE7T3qgV5L0EPx3DcFZeeoyCf98w8JThW8pLicIWcYwVTJkT4UfKyHr8MLeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=h8ajZBdS; arc=fail smtp.client-ip=52.101.126.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="h8ajZBdS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9qseUpSoKvRuyAXLxVoiBHD+exXCusp46iLeWB9EK/nazj4TQlnkkk06FVrph12Lq0trL17KK4d5UOtzlV0Ownna8mQqBSSo4GEtJ/gh6Gv0HVfipWWJ8hJoesk8fvvqT6UfbG+Tzkx2UGUT71/hWH7ow6u7R73ghAxdqLcAj6V+FcFIT54iUZgTXm7J0xiONm0rbKM9ErlwQsVnli5S9ewkkDdHD0V5sqpaq3WSphRqDILNaBA0ckfNwNGFzYCAzjMBs+jriJk45+UdtlNpUHPdjB3xxPrfYKYA0tG3o/87lE7bZ7YQAPaK0CPZ3Yk1PwmuijctHno2TmMOdKe/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=lhom33XahgFvALtpa5UizGYySZHd2yRTsOEdRWXjRg0=;
 b=IkDFyd0PaBoaYHTheCZCd5puABiPPfCJqywTxhpXFx0WjzTUFCVAb5qDY38X/k8UFxY+cOwQR4svs3llGi+U9JyYuPxQ64K6z/uxvqBiv+dkvbT6jHzyfHNFwtWMoTyqBSZDyZp3usq5KykadvNXDn7POPvv1G0612dZatanMg9jCd3lAP6LQSbn66kNHf/SQXLHtG5fso+TLG3yZxQtpbuzzlfaNVxTxJ2A2mKzHzdixfy+5gJlnrjv8OMctyJYIwzDtqsGPXHU2ywP2/IZq2OEcO4lij2SP3kWp+ZjPkgA/R8RPLDJ0wZht5fKlFsZ5ouBXOlQT2OCdj0mYGjLnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhom33XahgFvALtpa5UizGYySZHd2yRTsOEdRWXjRg0=;
 b=h8ajZBdSfAoXmPULVCWG6zExJ/efrvEp0YcRS3mqZdFQYlR16q17sanhYl5yPYysg54tF09PY99quYOizO8G7vMNzFsL13hosMI2uH1eQR9fo4mwLs33wBZ/j6cvM/3O/vn/EXAMg+J2i6cypEZmwDg74fzTGYnErd9UPf7peOM=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SI3P153MB2030.APCP153.PROD.OUTLOOK.COM (2603:1096:4:29e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.9; Fri, 16 Oct
 2026 07:40:16 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.006; Fri, 16 Oct 2026
 07:40:15 +0000
From: Wei Hu <weh@microsoft.com>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>,
	"weh@linux.microsoft.com" <weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "edumazet@google.com" <edumazet@google.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang Zhang
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan
 Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>, "horms@kernel.org" <horms@kernel.org>,
	"ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"stephen@networkplumber.org" <stephen@networkplumber.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"kees+treewide@kernel.org" <kees+treewide@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "mawasthi@linux.microsoft.com"
	<mawasthi@linux.microsoft.com>, "edumazet@kernel.org" <edumazet@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 1/4] net: mana: prepare HWC
 ownership for safe reinitialization
Thread-Index: AQHdW7RAXrocW1G9fUmzctKe5wPQbrb/xgug
Date: Fri, 16 Oct 2026 07:40:15 +0000
Message-ID:
 <SE3P153MB1848F2D34654FB8E976C7373BB9B2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: =?utf-8?q?=3Ce6ef84d7481de34f259d2b244f7994e3f1d9ab6f=2E17915619?=
 =?utf-8?q?95=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
 <179196575238.434549.10775387794024020898@kernel.org>
In-Reply-To: <179196575238.434549.10775387794024020898@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bb7ea11c-208c-47e8-a6ea-24cda371a7c0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-16T07:19:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SI3P153MB2030:EE_
x-ms-office365-filtering-correlation-id: 3cebf1db-0172-40b6-44d6-08df2b58b833
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|42112799006|366016|56012099006|38070700021|11063799006|10067099003|7053199004|7146999003|22082099003|18002099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 65tJvGEN9VykLuEvXYmbu+ISnneqDU2oKx8wJ1OSMSpnCb0PpQctiJllYznXnaIRVE/hFQt8BHfnl1CVleNgkAdITl7Z7qfcBOWJLTNa+5XH6nHvtv/AkmKuBevhXWHl7s+0D6w++4L8OBpJ2Ae/37nwt5M6CHwxRcst4T+3zJwDptO18gAox3yRdkjJ813mOo+I/yiZpAlu/SLDjCHgFXqsKMYBQiGkl7XHBayoZu5B/7WxfC1IP3VjDaOXd19Z56fHNAXhtcHurCpoFdwDikCdqzLq6y+1ft4csypjdGq/yUv9NTVv5cTVnlVdVVOsHlgtguVfa1Hbfx/+IgpZHyvW4pdXdfCHvRuZhn7FdkI1Hwo4lD9pc2heWMsxbBPAQAgN0QGX/0P8zU27GI2xqhYLBtTLEReP9k5Sq2SpS6LuZWtV5FlVIWOdAl7DDkZe+9PJnzpxdPQnF6ulg9nBESj/U5RDrVLoV+MnuuintvmLFxi0EmTSZlADsilvE0arQgxMK5/9pbrrMRlpvbnbefAaWcCkU6CdugWL+PMuMPBF7jsW6hDcK1TPcBIyO05SV30OWsqYuMSiS+4FMafc7QBv6wDjiH+gTCop1XmLlsPdLqj3GCkWDqOIJh+ac8UwrZu8MWwOW4cFCUuKGGayF0+4i42t80jXsqMBFTKszWZTSGrWq9iytzShmIu/+mtteHeiB+/pgmf5m/lw3J70co9zRPRMWJT25iXvSw7q5eM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(42112799006)(366016)(56012099006)(38070700021)(11063799006)(10067099003)(7053199004)(7146999003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?CTvhi7DXTwDIB1xWh1dEds+DcZl7c1ayIVLdD9WnPqrrBm1TN47BlpMaHmao?=
 =?us-ascii?Q?EE9wL4ObpLXsdRn5HpXFtjgwmYbOPEeMUqglAbZCyou1OGllSUW+S9/+AsUW?=
 =?us-ascii?Q?TJbRTqu6b2sK9/xOyxL8Q+JE6fTTqD/vg6qgAcMdRqk/L5aWWBFB3nbck9wv?=
 =?us-ascii?Q?dU+fyQ/oikuBkd04aKlk6pxIdneu4vMtCumNNITzTIOfTQXhRV2eSUt+F8s9?=
 =?us-ascii?Q?khfQUnn6CZkNzHZ+30DoOEunvc5bK8ixzGe/TqSHR0NlhRXlCDGYmIhiTEW9?=
 =?us-ascii?Q?QvO6VzYo3brqzcoZt07+wIG2EgVexVmXe7s5nZNIDkfYIyJM0oq1kMc6/m9X?=
 =?us-ascii?Q?I/4Q12qfcqiFfvW8/EYHL8fs4VMiHYRstjmIX0EUWLlFoEXgTHSIk1JoKjZu?=
 =?us-ascii?Q?K07m8Pqe0/FvVYxurmiwPQB03rCn/nTDUYw71Uh/rQ6sCgt7JG+xOBdHP5+j?=
 =?us-ascii?Q?Vn7jtnMmeKfg1Od6V10vJm4xFBu0foAGf3Cv6Mp+zzP0REQIoa4aOgn8jlc4?=
 =?us-ascii?Q?7IA6VVGIJ4XrngGtkR/C5OHTNZthpxeiUzYM7Aaj5Vho3hVroWMTADiTATKp?=
 =?us-ascii?Q?8RbScdwhJ8E3Qgam/6piVXcYFrsf2sPACpCli8sycos3NCn1137VxinXP94W?=
 =?us-ascii?Q?elbsG4f0SCMgAqBhaMWniGhWG11quWS7CHRZf1wtd16koiuPEBEluUkkuJpz?=
 =?us-ascii?Q?Pap5VnQZGMUEvUQL1sclXEo3WkaVIOBCzwXVpXgIiPvgbGA8UhqYM0rLSUml?=
 =?us-ascii?Q?fPKxL/bdl1f9mLR00si/mzgzHk1pvKrhQYY/kJSEgb7cJbHh5tvEztg7VisR?=
 =?us-ascii?Q?XcBre+zb48Rq8An+W1I5svFIkCtSsiQQ8gW6rLSH+wJz4MA9PP9Tbwoq2PVl?=
 =?us-ascii?Q?jxngDta9JFGD7pk7T8qGeoo7Ek10gcXduFVdESRA9GLYeih4O89RXPW7l0sy?=
 =?us-ascii?Q?bOn3t9BaM73wACjVV+9B2Q+BLr8oIs3+s0AU5mzp5t+L/nJqV+WAVM5V6fcC?=
 =?us-ascii?Q?eUgFMSrCvfjYuqVrhk+p0WjZFa2bM42JY8dZm0hxKApH2B+y1SvFqXWlWIOp?=
 =?us-ascii?Q?jbBe0KFBderAiP/cUlVcraFLjsqFDt8U367LgNp+kXmc1i3mPtcJ8fVUgVzH?=
 =?us-ascii?Q?KOp2NPdmA2tP1G9Ik3rpBja3X003cas8o5mU8qn0h0iEEuMzN0uiuj9cqqTQ?=
 =?us-ascii?Q?He3xBaCdLuo9qy/zAbaAiOw4oAFAkH8fbeJH3/qgNCv0oNxbk0Jrc1bOiG1Z?=
 =?us-ascii?Q?F2p4v8BON+7wvgsK8P2C/Gm6pC9lIOhRXgxnN7SmDiK8X59XU22Hw4ABu7pw?=
 =?us-ascii?Q?amDo8PAN3nliGGEdRDLloJ6ih8uIYP7TKsYiO4WEuUzcBR5ZoSUQzBmqO8yt?=
 =?us-ascii?Q?4y/y35d5B0WjtHqMxGMErxxK/wuLDlimeaMGgR4wL1+MXilVgZLp499qs34g?=
 =?us-ascii?Q?kX0xS+P7KvRzEUt78SdHP/O8pXc/pqAMiEq8M7u6NLEVHGVXMTXeLSEwR+xs?=
 =?us-ascii?Q?vT2A3KgEB813ThsQAmaClmgbZTz4b4xo5dEVYkb7+jJQkNET296ZOBzUHwGM?=
 =?us-ascii?Q?lnto93LZi/8KpyxYoMAb9wJRnVoQDTTeqzjoPYfprP0JE5lpkwFEBJuIVKiS?=
 =?us-ascii?Q?AmqBdSpFXGMIOkvzc1+V34JleIFEVN2W9W4hlj+vV8++LdX0P1uMmnxibU37?=
 =?us-ascii?Q?WI4Nk16jCC/Wrxqwj7u6mbjYMziBSzi+Pdz4qK6MrYjRYjSZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cebf1db-0172-40b6-44d6-08df2b58b833
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 07:40:15.6907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vDzvfT0JCZIFsMnL3Hw8jX7gMDmveJl/hHBjst/yJuJQf1nkFSJEde2xZMTmCHSvE9g5hbeHIyvPdq4FUEEXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3P153MB2030

Thanks for the review. I have prepared a four-patch v8 based on net-next
commit 05b5019b01fb, with the following dispositions.

On Wed, 14 Oct 2026 08:15:52 +0000, netdev-bot+sashiko@kernel.org wrote:

> Could these fixes be split out with Fixes: tags, so they can go to net an=
d
> stable separately from the reinitialization preparation?

Agreed that these changes also fix existing behavior; they are not merely
cosmetic preparation. The v8 messages describe that behavior explicitly.
This revision retains the four-patch feature lineage and does not label a
whole feature-preparation patch as a safe standalone stable backport. A
minimal net/stable series needs separate extraction, a verified Fixes
origin and validation on its target baseline. That separate backport work
is deferred, not rejected, and no claim is made that older kernels are
fixed.

> Does this leak the retained hw_channel_context when the gdma_context
> itself is freed?

Fixed in v8 patch 1. A retained channel remains available for retry while
its gdma_context survives. When a PCI or CDX path finally discards that
context, a common final-disposal helper now releases software-only
wrappers, caller state, the bitmap and CQ table after the required CPU
users are quiesced. Coherent allocations are deliberately NOT freed without
an acknowledged ownership transfer. This fixes the additional software
leak; it does not claim that an unresponsive PF can be made to release DMA
memory.

> Say an EQ interrupt on another CPU has already loaded the slot here. Can
> it then read freed memory and call through cq->cq.callback? A local RDMA
> user can reach this by calling ibv_destroy_cq() on an armed CQ.

This is a valid independent RDMA CQ concern, not dismissed because it is
pre-existing. mana_ib_install_cq_cb() and mana_ib_remove_cq_cb() are
byte-identical to the pinned baseline: the separate callback object is
published without the required per-object protocol and freed before
withdrawal/grace. The HWC series protects its own table/bundle lifetime; it
does not establish a lifetime for every RDMA callback object. A fix belongs
in the RDMA install/remove/destroy protocol and requires its own ordering
and coexistence validation. No RDMA CQ lifetime fix is claimed here.

> Then mana_gd_destroy_queue() frees the queue memory and calls
> kfree(queue) without waiting for a grace period.

Agreed that table lifetime and individual datapath CQ lifetime are
different contracts. The baseline generic destroy path clears the slot and
frees the CQ without an intervening grace period, and the IRQ reader does
not restrict a device-supplied CQ ID to the delivering EQ. HWC's table
withdrawal does not repair those earlier individual-CQ retirements. The
independent queue-set work addresses Ethernet CQ publication/retirement; it
is not stacked into this HWC series. Overlapping hunks must be reconciled
while preserving both contracts, whichever series lands second.

Regards,
Wei
