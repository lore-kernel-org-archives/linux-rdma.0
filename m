Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023141.outbound.protection.outlook.com [40.107.44.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019D360751;
	Sat, 10 Oct 2026 07:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791615665; cv=fail; b=e1xzK5OI6yKmSuwhezEC6FxPH5ZF1Nkam69zTnXQT58G5DbhVPnHGATCfwjkvXt2kF3jgEf6DQtZLqLeXWdvCuKqGfH+MMalRhqrcw1cxVEy77IQbLAbVKj0Sqa4SOBmPGTxYrdPrcQNOvR132fjNh0lTeLyLozSXxMSVlrCjgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791615665; c=relaxed/simple;
	bh=Ijo5uDns4zlj6csZrUnOtuyVipCIe3oTIGErUS0urdU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kat7Ik1i0dGqoKj7ZF/9g8nFLGEO8Iash/zvYZaOqh7ai9d5SKP7l7QwRQaEhy4bWIyJ6kaO7JLvIbPWHRXH122/c4FIcNXgnQ2va05wc6yu1DMN5lUEs0vSyiZzqcnZUPyJoXRQ45RnsH1QlamUN/CVKmTxJFbHchLkpFG7Kfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=JKiHHKM4; arc=fail smtp.client-ip=40.107.44.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="JKiHHKM4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZxW2gDx2LArwUIp7qthuX2YTT2+p/cBwD0zc757dtBUxY2DVCXvHR7qZvjCm7a3VgVZz8GUbEeuU/6HEWF1okE2qHuJAHCfDJR8ylYdKvd+tNBtf57IG4LvJzRrQN1Tu43NQ10q4lsSg4OAiRI1PeQYohZJY61yNmfDxLjVHwTrCP30c3r5Ye68Lrf66sybmqR1SzRAhSNa4VkGcTrCJ6+j/ZDHj1W4y93rwefPmjZ0ijncNfjZxfC+pchPNVIZpwBbNMYQWdzp31Fswhn9arncVsIOjbsLvPeuWrV9BptQ1AtyGQMWIBWSSPPzdkdjZ3hiowAWjZLW5dUvfY5U+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=7SU/4lOHtyEHfFJI0xL/1D27gniJmfS8h4opydbssV8=;
 b=yl3WJY6UsqJEC/s/3j20Ctt9LZKk9YaIIKacpCdVHGkiNf5ZezHmw8dlJuCD/7UWzeDkeVMRBWpukatXQ5h2oyq5qw1xQAdDJUo4lQLrSfAoLL/tyaeA21IrbTbL+kPVdgOXuwQ5uZ3AEHBBfFuY2O3Z8P1pGqlgsX+wgm2igCnvwG0dEdpJgqBC/yoAe9eq2HDkAveKhCEAjklbboTLx2+bnmEYJrEOE4sFFiyeG50CooGQXbNnjc7AUvmewOUlrwyNzdbDxosriJNFIOVovky87DG7PDPeHiHXR9xX36QntxkdiUb5Ag0XavGPnqMukg3aEHuCSsUi1pTlsjTPQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SU/4lOHtyEHfFJI0xL/1D27gniJmfS8h4opydbssV8=;
 b=JKiHHKM4RlD+ixPq/086MU8FvnyZIWcZjqy6kQ2dCISX5WXp95+GNrfu+KiymAJEDYM8Erx73IAOZCjnVLHwHk7Mf0P1euEUkEuQtOTtO62jGrtdw+z+sMpy0pw/umw+zW5qtIhbSLBuDq0uLEmQZ713clwuYCfpmdr1qlQJwT4=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by SI3P153MB2078.APCP153.PROD.OUTLOOK.COM (2603:1096:4:29e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.0; Sat, 10 Oct 2026 07:00:55 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0522.006; Sat, 10 Oct 2026
 07:00:53 +0000
From: Wei Hu <weh@microsoft.com>
To: Simon Horman <horms@kernel.org>, Wei Hu <weh@linux.microsoft.com>
CC: Long Li <longli@kernel.org>, Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>, Shradha Gupta
	<shradhagupta@linux.microsoft.com>, Erni Sri Satya Vennela
	<ernis@linux.microsoft.com>, Stephen Hemminger <stephen@networkplumber.org>,
	Shiraz Saleem <shirazsaleem@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Aditya Garg <gargaditya@linux.microsoft.com>,
	Kees Cook <kees+treewide@kernel.org>, Kees Cook <kees@kernel.org>, Manish
 Awasthi <mawasthi@linux.microsoft.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v6 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v6 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Index: AQHdVlrjqAKo7MR9c0+EfVD6M1+h6bb1VlYAgADn0gA=
Date: Sat, 10 Oct 2026 07:00:52 +0000
Message-ID:
 <SE3P153MB18480F7AC211C30412907878BB912@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1790665894.git.weh@linux.microsoft.com>
 <20261009151906.GF83879@horms.kernel.org>
In-Reply-To: <20261009151906.GF83879@horms.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2b79d915-9e74-47d9-b7ad-9d816fb3af14;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-10T05:08:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|SI3P153MB2078:EE_
x-ms-office365-filtering-correlation-id: b4e65e7f-60f1-4d0d-061c-08df269c3967
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|42112799006|38070700021|56012099006|11063799006|4143699003|7146999003|10067099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info:
 yGm3IZE2G52O8Za4VrOi5yrgCk2TiKQLlQXsT1mJgDWEOitm9qIkqgJvs5jREcoWkyfu6/nMu4cZlJKCYWdsYWeVxac4A9MuJN3jAylxOyqKYBAgw+jXKxfwkHzU5+CRyrWraqM7RxJSrDlse5A/Uu3BEhW4zbGT7jZq2n1rXc/4Y1FoqYnlorOXLpY5iBEYlgcbr0zYs3SMDPeZ/PgLnE/J0JO7pul9B/tJYmOo7IgQveZYK/k/sTa4gdmelAOaGwt8yV0TSUQyUHy7fmN2WDpxnl1cunwPeLOEGwb/qV2vnCgBEFFFNUhSluqNaVVrovkTKfFr9r36cEQ+0ZEhdUwVhTO0V463dPvKO3PhfdWgaaoypOQ5NGK0FctMG/R0yNSk/GxeCIp1QY+JGNjP6c8RX1/t6tLegQIBma9AaHS+dJQZ8+kGPuTEZ4cekoz1guZbCGZsZlEA30UW63QgIAArgwRmXLYQ21eAIvfuKT0knxEHT4IcmsA670cLvrMoETpGGkWK90e6DK9ijn0rw5Q1UiXijSb63t0At3AxmhFPvjWdO9K6SxS5IwSzPXlujsUCRHDZMdY9Jo7WwH6cnTeJnNf13Eibf4X/QFq56YU1RbsKn/u4s/abHj34sNhbnu06lWFwPfUE5bN3cadIb4K8A1Ad+cVk0fDu+SrjywHKOq1XSdj1KKQFmiVoYeF1/khdY6VbNoZDtZ/f4Pg8tjmQRNyahM+Bhg/Q/+VG+Tg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(42112799006)(38070700021)(56012099006)(11063799006)(4143699003)(7146999003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2eAKXF3YpTciLphjwHmlGsNTUQ4dnGqYxQss0ZkHacBN2HYkjY3Klwo5godo?=
 =?us-ascii?Q?pDTA9h3k42dOKYksbZR8u8NxWtE+AuYf2lfVo0DTGKB8fgDCEVQPFuD0J1xR?=
 =?us-ascii?Q?AOOjfWEQFybF7i03NVamG+SSZQAuNESe9DhjM10O+Hg0Vtc9BS7v1TKx0i6r?=
 =?us-ascii?Q?Hp2dAJ6AFkYuhmorWU7hhbQfbwII5YEij7HyfSOYwBvG5l0cvPSR+GeeRxqd?=
 =?us-ascii?Q?RXGo3/lxQ58PHWFa3o+pMkDxiwJcAU4Mx8m7g6+2CXt8wk5ApSbgxE3EI4cx?=
 =?us-ascii?Q?/nGzoZUyIWk3z2lrjGXdQaLcPGlFBgWdN/vedBt/yt5Tb0tGzCjhZNlfWmZD?=
 =?us-ascii?Q?NCIM9r9rmBCGI3Vt/QWCyaLo0iEo+RtuN+YNX3SL0N6qqU9uj2XIiHC6w9iQ?=
 =?us-ascii?Q?9Ibp8CLR7gx9b4XbgLFGCohxuETXTv+mE3aztnYzT7r59dt9hmcEVM1xya95?=
 =?us-ascii?Q?FBhTb80k7JkwtbtKbYs656xtG+wg2IDDRkhDA73QH7xXg9jkv4q27QvFm+3s?=
 =?us-ascii?Q?dgSBqZJwxd+Un0cAukDvWkghlKqM2CJR8KSIRJBm5iuW3VWZQIQd8c9zxexX?=
 =?us-ascii?Q?1ckqU4h0Kn7gGnPEbpYRo4T7YgBUwao7WA9KJmKPTNnVQXT+7GurvtGzQVLk?=
 =?us-ascii?Q?7YfpH090cHsxEyG+Pkv+ziQAKOTNljMP0wzfgEkn8Y8X33GnYkmqz5WGc9ut?=
 =?us-ascii?Q?56NjyWAF5Me/x7tzAC3W9VwSxvCRN/4SIzZaQF12CiFCK/707nTBoXCEe4e5?=
 =?us-ascii?Q?NUFMSQY1jUz7yy5SAlCm1FpEBAF5qOZwvePyUwhqjYbx4xh+jNdxTkgohBkv?=
 =?us-ascii?Q?bJhPqAQ4XKv+iinJ7UjeI67gOy8BQYfcWJ8flhtBRLWo91ZuFFmHS9Kr3yKC?=
 =?us-ascii?Q?bGet/9/182YY1vM18u+u5qAPnz+AAlYMEDqJiWsJUI+U8iqHZ3JrKnOjpFDr?=
 =?us-ascii?Q?X8l+rGfyX5y2q2QbLCConm+NA/TqpZ0q/cUQtb57NLWrQxcSzE/11ZjNBl7m?=
 =?us-ascii?Q?o8rn56+9av7PhWZQXuZt0MXRRUe2JqVNXsbAesgzHXL9AGhWZfrxHmrS83nT?=
 =?us-ascii?Q?C4QpabE/vyd2pWr5eLWEvKIizieokt01lotA/0edKqGSTSxdS6Dk7KaZYFVD?=
 =?us-ascii?Q?t5HMr/Vx+yww43CEwu3M/xg9VwjeC1lPDKETr3H7WTTABpQO5E+1tP7ZtYtl?=
 =?us-ascii?Q?Bb6ZI5YbiykHj1j7aoaoCaT9+U/4GA7gDw6UXmxL2rX/0IYspTcf6x9FTtau?=
 =?us-ascii?Q?fbPSv4FF70dp1USWMLZMBr6g0a3lZIWr534LH12wJv+RcHf+MDFfagtJz9HP?=
 =?us-ascii?Q?fOLeTGlY0P+Clf5GXsFy/s52vCQo81LK3eiV8GD40TD97XeUfu0fBUuSMiZY?=
 =?us-ascii?Q?uulkurbf50e78lxY21aKzljWbwy92bof83o9FCnqUIOhsTUwHNYeg6GElKIN?=
 =?us-ascii?Q?cLI8CQwokc9ejlJWHlwzW0QfbCL3WwFuz0Q6MWSIXEJAKPRtueU2bycjwrVe?=
 =?us-ascii?Q?Y+ivUr/L8o1mPrrJba8hD/FFVrTuC3pT6Gq3ZK9+13J7pBZ4kbWDRCDbQR6z?=
 =?us-ascii?Q?1vWdl02PjoALmdE4zZkxRoPwF73ivGCFsgQhyPraGY5uZ5bqYg6zEteg1lbZ?=
 =?us-ascii?Q?EcQSQGGw0BoW8LEmkk2CJaXv9ipaTPkcm0u3eCTzieZg1aiYv0xBcTMacT2D?=
 =?us-ascii?Q?D1Iig6h/C4sHexuIeFHd8i62mrc8vGUBMOGFd/+QBWPc2PFd?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e65e7f-60f1-4d0d-061c-08df269c3967
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2026 07:00:52.9291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RA9aeIiZPAhVbBXfWd37z4Xjh3TeJaUZAKuw3HYFxkNB8oCkP1MPyqeQLqEBgTxT8s7Yy2cbbTHunswewXWr6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3P153MB2078



> -----Original Message-----
> From: Simon Horman <horms@kernel.org>
> Sent: Friday, October 9, 2026 11:19 PM
> To: Wei Hu <weh@linux.microsoft.com>
> Cc: Long Li <longli@kernel.org>; Konstantin Taranov
> <kotaranov@microsoft.com>; Jakub Kicinski <kuba@kernel.org>; David S.
> Miller <davem@davemloft.net>; Paolo Abeni <pabeni@redhat.com>; Eric
> Dumazet <edumazet@google.com>; Andrew Lunn
> <andrew+netdev@lunn.ch>; Jason Gunthorpe <jgg@ziepe.ca>; Leon
> Romanovsky <leon@kernel.org>; Haiyang Zhang <haiyangz@microsoft.com>;
> K. Y. Srinivasan <kys@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexua=
n
> Cui <DECUI@microsoft.com>; Shradha Gupta
> <shradhagupta@linux.microsoft.com>; Erni Sri Satya Vennela
> <ernis@linux.microsoft.com>; Stephen Hemminger
> <stephen@networkplumber.org>; Shiraz Saleem
> <shirazsaleem@microsoft.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; linux-hyperv@vger.kernel.org; linux-
> kernel@vger.kernel.org; Aditya Garg <gargaditya@linux.microsoft.com>;
> Dipayaan Roy <dipayanroy@linux.microsoft.com>; Kees Cook
> <kees+treewide@kernel.org>; Kees Cook <kees@kernel.org>; Manish Awasthi
> <mawasthi@linux.microsoft.com>; Wei Hu <weh@microsoft.com>
> Subject: [EXTERNAL] Re: [PATCH net-next v6 0/4] net: mana: concurrent HWC
> requests and dynamic queue depth
>=20
> On Wed, Oct 07, 2026 at 12:53:26PM +0000, Wei Hu wrote:
>=20
> ...
>=20
> > Long Li (4):
> >   net: mana: prepare HWC ownership for safe reinitialization
> >   net: mana: give each HWC message slot its own completion state
> >   net: mana: support concurrent HWC requests
> >   net: mana: add dynamic HWC queue depth with reinit path
>=20
> Hi Wei,
>=20
> Unfortunately this patch-set did not apply cleanly to net-next, and thus =
our CI
> did not run.
>=20
> Please rebase and repost.
>=20
> ...
>=20
> --
> pw-bot: changes-requested
Hi Simon,

Thanks. I will send the rebased v7 soon.

Wei
