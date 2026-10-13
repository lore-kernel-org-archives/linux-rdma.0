Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022118.outbound.protection.outlook.com [52.101.126.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2AF412BF1;
	Tue, 13 Oct 2026 11:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791889893; cv=fail; b=LRBw4tNQV8QUdd03IkxuK2kUnWdoz6JBcbF9r6KKehTcF4OGzMD9AjqXi6HzdIi0E25jGjZM9lJgkAVw6C9m62KUBlZyS9VCw2LIK+/u5tJU5byiu4JL+QfjyxYKrbd94HIz1D5MfAojF2RFBjQWsFnLDVcuqauIDtANz5dHg4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791889893; c=relaxed/simple;
	bh=zzvnLiz020Qai9rNS9kzePxG3uAsDhXNRqQO3oWS+dI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uf99JqXg9c1EXO/g0dx5p951pJ7TANCJ2InT3KwgjIPU70KbzZ+YILlvbSxQ8mPpbadzzCIdSGiane1HXjP5d+dTciebJjVULFGihAo1COyHUBbMkClWwvebQk+BubuOLAeJW1DXQBRmeBHmS0lM44nuZlPslTKxeLeORiGiGtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=LAF9IaM/; arc=fail smtp.client-ip=52.101.126.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="LAF9IaM/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eqw+JQTKkX1wHSYV28Tk/ku3/R7AGtItftXAdIkZFLfh2DR61c2INp8w4rKqxxrMjm21EXECOyNfANdDM5xrXYnWuVh6Ybl734wE5y8xDx6RdYIzbig2xSMgpR6MemwP9Fk8o0EmXpCThtS48J3xV4gR3vA5YAES2bcfs+XnCZ+5HpnufFSPjtuI9oo/zfp+PtksEmV1O4B07djNPnzobxAbyKSSFiKEk+AU2Y2F1oAMZPcg6IaBYA8p+IacjfWxUpmhsGQKvRpmZJEzuV4vKUBVUy0VWc8qIaim+OGUOG5/DLlZJVie/BrlGgGZjOvarJmbx/FX8Zw1r7ocFG0KWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=zzvnLiz020Qai9rNS9kzePxG3uAsDhXNRqQO3oWS+dI=;
 b=oGKdpYD5FYPAflLn84h6iI4lfvgtlMSjXast7u6TfDk1DyANkAvbkavs6+u669uiz6vWw+tlMwRbxnxi7zg2e4bOTio35+SHzM1bI3FGt0c2By96M9R8mInqlFGsHmCytbe8sPvLDux+VPoRWGZo7CRbGy5QHiaGzeWDqolxtBQsG7k8Y77hzLRY0tjYFhYfjmfjUCwuygcyY33QnkCYjISBsQ0I8pPPjeVKaYyt9Bxu4s8EOlX/mQ5fBWuQVCtTAxo6eAkfYA0hAl1gdxJmRrKF7V5NLnd0hFKRIt5aP4Wp/QwliaZM/I9IPra0Wi6AE87ZGUHMkY66HEhR9P9V/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzvnLiz020Qai9rNS9kzePxG3uAsDhXNRqQO3oWS+dI=;
 b=LAF9IaM/0CtS9a9ecIeGfPK2K+QkABY4hxejvmLLGQSgyvAI6emtt4J6BEcySc5yxkcVJgIAHDZvAlp9+Hz12P9UQWVMMOOIvEumL2n2qrP6xEHfG/1/vfaPekOYDZjALX6QLAtQgpjJLGIr++xmHfMGdiOBJqINu2gj5WAlEHg=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SE3P153MB2099.APCP153.PROD.OUTLOOK.COM (2603:1096:101:323::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.6; Tue, 13 Oct
 2026 11:11:25 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0546.001; Tue, 13 Oct 2026
 11:11:24 +0000
From: Wei Hu <weh@microsoft.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>, Wei
 Hu <weh@linux.microsoft.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v6 07/13] net: mana: swap queue
 sets in mana_change_mtu
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v6 07/13] net: mana: swap queue
 sets in mana_change_mtu
Thread-Index: AQHdV/xZfoetrlwwVUyHM/BIc/zJCrb22xkAgARzOPA=
Date: Tue, 13 Oct 2026 11:11:24 +0000
Message-ID:
 <SE3P153MB18487B1C1C405F3F2881ECF1BB9E2@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <e9524a67c6e157f2e110f4e9f51ec3c94293a64d.1790795005.git.weh@linux.microsoft.com>
 <sashiko-outbox-166667@kernel.org>
In-Reply-To: <sashiko-outbox-166667@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dbe220f1-b2da-4917-9d9a-e6d7a67dfdef;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-13T10:39:38Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SE3P153MB2099:EE_
x-ms-office365-filtering-correlation-id: 8792215b-4cd2-46cb-149f-08df291ab828
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|42112799006|38070700021|56012099006|11063799006|4143699003|261009223027099003|7146999003|10067099003|18002099003|22082099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 J3sW00ON9qrrKnamoTQWwZ38DjPPmiD9D62NlHLFV3cxemchPOPBh8oUg795FCJqMZmF7G7DmSV0D2IS8ZHaAzuy8rHkoN4hZdAf8VvaCvvQJ/+8LXrYEezXBDRkXyPylk14NoMEyqeX7AoIqXdLe1kC3IF/2oncHS0hnWvF5DxOr/j3X9r30c5qptKCXLcbVsn4atwM+BAW68abfb7SNKfs45QuuvQ5K3vNYFgrjK6Nx1GxeXMhfHbDoy71QMmUhX5fiWAdlX1SLLfciNFp5miltiLMPnVI+g74MlgqF34fGB1daBIGzsGpXwp/gthKJ8fEjzfTcKxwZ9i28rIGSJVPGkh/F2bGT+wkqqZGH+1IVsYmGMPbVL3Y2DVrIPiZqhTPNdFMGbpvGT7XRIdKCDHatQg6Z4P6Se1dUgChKiJWEQZ/tYlwidIf5Z8z2JzDT4zeY6H/ZFnu30/YtBHjaKrppo1Y+dX83CCdpOB7nDkOR5dSrzRLVppZGgXfA5POdQXPIkRYeDND+mI0WJvsB/d9iK75CgMaEB+9UxZkup65hpcpiK/U33gdNtcoCHwgV7LueDnZ2r6afZMWPfBMuMVsWeYw+jcTvz1Jf2G2wY+/bvqp6P3PdxqF2PQ4RvlRvIn7xuRWSvFqQQWZMKb8ASpJ7VeK1nGiCd/lshqRTeiSaTGguCZwKIjAYT8ovALEX5C0bdNn1Zo1qh/K1xDvjPFBlJWzUGCUVasDG8EzEB8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(42112799006)(38070700021)(56012099006)(11063799006)(4143699003)(261009223027099003)(7146999003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tL0/Tn/YtcGct1wOUv8oyF8wY9sBf0oqSfqbCKbHGBHCsFPWz2eNCPxBAjE0?=
 =?us-ascii?Q?3cFZXYZB6kAYAJ+UfaF3+Yw4NYiWL7wKZrc0d9IkdwO4oA/3Vonb679FOS+q?=
 =?us-ascii?Q?77ceUhhqrfHMaaMIGZMFBsZzUPnGgt6uVJcEx3qE6zbqjYEzkKntQmY6gRsr?=
 =?us-ascii?Q?xHLcArJYjyZY0J9xiStgCqkwKfbb1W1muWTHEpQTZIeQiHwdmbXhwKWUSMnE?=
 =?us-ascii?Q?0iW+y/N8cQXwyEGxfljYMXHzNRd9JTxxeSx0/w3+ZBDwevOBdc2ss3SxrYyj?=
 =?us-ascii?Q?hKuZ49yWALOYn4mX4w7jVFPDRIKyknQ7KYDnuupasjvW0nh47VIKuCld3Znx?=
 =?us-ascii?Q?ftYW8PYj5Wup5wyPxY6huGYk2IX7fGt1v6Jx7utR+bM+7+Eegv7mzo0lbbe/?=
 =?us-ascii?Q?mJOYU8oAYtVsXElNj2OScdJfElp5iIWxR+AQl9axbdyAEzA2LGIVvh7YOk7b?=
 =?us-ascii?Q?2/xVPfRvEirUNoDjw0xYehnvSF5NBeNW5YdZqR88CK/UvgplErdOx+WPugRK?=
 =?us-ascii?Q?DuF3OddWZ+nWBxdN2iSpWPCw1Wdez5CG72kvw/9RURy+34ADah74/dj8I/xJ?=
 =?us-ascii?Q?WYVxKWnVSssK5i4yaCIRAEk69nnp5/bJ4j0vxPJrhLAgo/MnwANMc9OAzcu0?=
 =?us-ascii?Q?FWZqu6h261da0GBSzTzWz2bRD9QDKOZ6s/mhJT5EDlNKjX7RULx4LdHnHwq3?=
 =?us-ascii?Q?WVKhfEPl/ndHa0xeyU9QOIIDezF7bEFkrTY5D2KRDxi3tPwECNqGTNdTkqv5?=
 =?us-ascii?Q?Xw10x0PqpX8vieGedSNFhUBcIqmTeUltSpPYfOIr7TivoO9Wc6mZ9seSS6mD?=
 =?us-ascii?Q?iM176oBEKnz5phobANx7gjO5+QFlVf0x9NrkoDXXpx+/N9CsCBCM/ZrGXy29?=
 =?us-ascii?Q?u/OEMQXYuWSjj9TZjL7h977K2EEXvWAHfMrFIOTC5DfEunRw8hc/vf5GELtc?=
 =?us-ascii?Q?lOds7GNI4D41osjN6eyimx6zFJ6eJ/hMULiTrmVIw54DnzPgzd4+j/6rl0fs?=
 =?us-ascii?Q?+oMdMyqNaAdtVsGZQDH+uYfinhM23XVYfUfypPmczoP0Y6kIMiGib4NThgE9?=
 =?us-ascii?Q?GOdBJp810EQ0hZSGlbWZLO0bAQVDl9bdM1/sB6clAj8bVeSaWwyBaddcDpq7?=
 =?us-ascii?Q?d/PXEh0YKcTy0uy8wFhU2DuibfJ+rIdj4dlQodkLBso22kd+FvL0jULFoPaN?=
 =?us-ascii?Q?w3sg2sBJ9d/kBUa3/jYXNJWZUpossZYCWCXH2tnxlJsGYign2OdHprpCyNdJ?=
 =?us-ascii?Q?9ba+TxVek/Qy5bYG1O022bIFyb454aYFE4m+RDkdNIoTqTjBlJqKW0BSm/6u?=
 =?us-ascii?Q?E/mwMy2jQ45FiGS4jXtzy4Y0zgusatOXj2Vn0VoQ4/Kv3oz+5M5psGyvoJVs?=
 =?us-ascii?Q?K8xcRB8yehsXEnPY4JFp+dKIG1dPlUUYmcRYQIpJYxDEz6nXUfwA2AGTXmJT?=
 =?us-ascii?Q?xGpXHMRFfRl0A/xba0np3ElPvfHFbv7Nzp3X0h0ePF5kyssLQCIWTORTQama?=
 =?us-ascii?Q?eGtARB0tin+DryIWmYhGlLAQGM1YZr6dfkwXCND7vKji6iUWnL+mHXtYb7Jo?=
 =?us-ascii?Q?AXGDJZWUT6uUTuy/rBjiEeltMrI+eCEGnFyvofv+XYqHuVsUp/9DU0RtFLWp?=
 =?us-ascii?Q?Wr1Z7VxBKbnjWTu6coeMV/ay7cxWnLeQyZ23ZgQK/zO50HrltjxHB2wK/mDB?=
 =?us-ascii?Q?6WFe3fNI4igZO92kQZkQ93u1XTe5l0+w0LHnTQLrqn0zdryR?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8792215b-4cd2-46cb-149f-08df291ab828
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2026 11:11:24.5177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3iyTZ0sx9x1anc8nhb77ykIRZWlHfAyZcIPnG18zFOUNamx6SqoTxVNaJqVROq4rTEU9OWnHQ6eHz+XbJtsV8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3P153MB2099

Thanks for the review.

> Can this lead to a deadlock on 32-bit systems?

The described odd-seqcount deadlock requires a 32-bit MANA configuration,
which is not supported by either the v6 base or the rebased v7.

MICROSOFT_MANA is restricted to X86_64 or little-endian ARM64. The upstream
CDX transport present in the v7 base also explicitly requires 64BIT.
The common GDMA core is selected by those supported transports; it does
not provide a separate 32-bit MANA device path.

On 64-bit, include/linux/u64_stats_sync.h has no seqcount in
struct u64_stats_sync. Its update helpers are empty and fetch_retry always
returns false. A reader cannot enter the odd-sequence retry loop described
in the report, even if the folding task is preempted.

The MTU change does not change these architecture constraints or the
64-bit helper implementation. The fold remains under RTNL and after
quiescing the retiring RX drain-stat writers.

I have therefore not added preemption/IRQ disabling for this report in v7.
This conclusion concerns the reported seqcount deadlock, not a guarantee
for a hypothetical future 32-bit port or for unrelated concurrent-writer
statistics bugs.

Thanks,
Wei
