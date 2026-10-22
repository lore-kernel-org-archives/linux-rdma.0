Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.96
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792680860;
	b=Si0Qa1kqUXrMUZYHrhJ0AQDWCcp0jRVnReK6JzBNbM6DlIn4FgER1Z4fghsm7xaRYiJD
	 EUhA0DtydR7m8m7PvdIYqz8C2LdQWia9a1ml/MB8b0efTc8eT8hq735+KJLo1WKT7SkKg
	 CHWDNq2AuSqFGusZ7Sc5EiTMRBoKVXMp2rpzxRCqACXcCXLvK1gzT0dQ34HepnJ8Tyepu
	 Iz0NoJLGcHiMUnNMZ/ptdObJt/P4/1JgILRszrecvcmlWPapxzQ0SPVeolfJ5WIJPHeRk
	 lxRKwFG9wdlyb+ZyrHLEcvFXBbjPk+wRI+NPzaraxlQnscuZRQGX2YuQU8TmJ76CNsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680860;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
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
	bh=BBKPd9UR7+iao/JhNyVsCA5jf+TPpOnqKyIyM58hCD4=;
	b=HYe1My/LzCiF4t9coQ9hpoAe4FV0SrvJqyRqr2S/x796Y13Y62WNb4XvbyCBV6uhbanS
	 FjTJpo5vxaZuIabsZnk2yEfAemlGjHlSoJA5a+s+DTeJJh2TLRgo8OtqO7llOdQZ9QOYP
	 9rrLwTAEWdXRwXUevWhLE6hdd7PXV301x+ly4C4xO2UmcHLUt93hm9pc35Xh+jMTPCPmQ
	 D5yT0TnbAwM98mY+K/QqRKbOKjZ7WGZDoNXQ3CV7BMySy7R0HfpIMAvX6aQSUjNd/BVz1
	 EVgU0CunOYb+bIzj39b9EkMJv1kBI7dtMbvpFsLvNHSE+9i/lhsCjOlxvxJ2XUG9vjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=AwrexsM5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.75.96
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022096.outbound.protection.outlook.com [40.107.75.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435E1606A31D;
	Thu, 22 Oct 2026 14:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 435E1606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=AwrexsM5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKI9k9JwUUvktMBYBExkFU4rzqnh2pUDt71CtekXgjvt77AwjZB1RVVL59RuQ5g5Ga5XZI1sXn+a2CBMNhjAMvpj6wdgZUB8Z9BjT9MhmnK16QgznEdD2kllrhyZEL7UQgEZxE0qahVLDuwv4z+e4uPxaWgFV0Cr+AEM01jOQksYk/z50ZDrwnGxa277hbGPzlOuQElv9pycEv3m/xefv1P9lG+e67WB/Gss+a3Hs5q+TI818sH+JG8Nfwn3qBP2xg/v9qbvMnWnzoC5ZIo+H3qXPhqGf9HMKEVM7QMg81CiK/cY3uRo0DnugfjM6Yp5MOQHgqUmexrpEyb00PlKOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=BBKPd9UR7+iao/JhNyVsCA5jf+TPpOnqKyIyM58hCD4=;
 b=d5tBPSzRSmUqKhhRZAknZPzYPHWgnnxzs7HkqoFZDsC4bu3IVvjEpv4N4I9CTwVdqsIuV+9rRcsxW8NFXVyvEll7NGSljVlRNlZ1ImLxlwMQ6iPAUnz7VvQ63zdDu+d6GqLvAt4FDnaeXxLqb3hVaquvbdFt/yVopK7K3w6fBz0Ic80k0ZuQeVoS/mWOriNmBTy8n6pF3icfWeMh6fOkYfMqGuys2M2odu9UK5tdEkX7xmfTU3SWpDd/OYUv9WqeikGayDP45j86uXa972y0rTo5EscSOobq1vBwZqEZWDnV+JE4WpARllkroj0TDCWgNCFtTXtBwJUow6Vjuj5Tqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBKPd9UR7+iao/JhNyVsCA5jf+TPpOnqKyIyM58hCD4=;
 b=AwrexsM5xy8PVc2oS9c9jT3jCeVRI59+gM1a4vFXQtMFCtz0svslmQk1oXBqqoangUzPWmTglptyz0X8YCBTQEzEPMMEvLKw8VRyqFqsS8JYxb1P0OZCLPe5B66tfh8Ct8JIEtkdPEv0GD2N7k3Jc+euTQ8oAWhnSpNmGCpLmys=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by KUXP153MB2162.APCP153.PROD.OUTLOOK.COM (2603:1096:d10:66::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.3; Thu, 22 Oct
 2026 14:54:12 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0569.000; Thu, 22 Oct 2026
 14:54:12 +0000
From: Wei Hu <weh@microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>, Wei Hu <weh@linux.microsoft.com>
CC: "longli@kernel.org" <longli@kernel.org>, Konstantin Taranov
	<kotaranov@microsoft.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, Haiyang
 Zhang <haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	Dexuan Cui <DECUI@microsoft.com>, "shradhagupta@linux.microsoft.com"
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
Subject: RE: [EXTERNAL] Re: [PATCH net-next v8 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v8 0/4] net: mana: concurrent HWC
 requests and dynamic queue depth
Thread-Index: AQHdXWbIVR2CZtN/aEGATCJfWHE15rcIfiCAgAEvUcA=
Date: Thu, 22 Oct 2026 14:54:11 +0000
Message-ID:
 <SE3P153MB1848ED8701A4CEC783EB2C2EBB652@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <20261021134053.74169d5a@kernel.org>
In-Reply-To: <20261021134053.74169d5a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2a746acd-0b17-48ef-8877-fe349865f1c7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-22T14:46:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|KUXP153MB2162:EE_
x-ms-office365-filtering-correlation-id: 6caac795-b8ce-4c64-b6d2-08df304c557a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|42112799006|23010399003|38070700021|4143699003|56012099006|11063799006|10067099003|7146999003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 QSH0DJjGzaKuhSaW4Yo7SwqzC6M6suOXSInCVwsvYQcd7mpNBhtiCFXsgRunlhSfr/gs8VNtB1a//Wdzc7LNh3RelNGoeN5zsIEF9VMIgeDNUYHxmwd6Vm278+bYG8xUpJhyIq0YWZgLNHRTSq8PKJgJmQ/F7KmYJpqfeomKs55fhNzuy4JUkHloieOCc0jZRrai52sYxO0kFKKux03DmJn38F9rTFpDCYbssOz43GLi5qjQVzpIiWej5xz7lIjt0AkwYyA/52u9UNiAy/YdVnFqP8aos8ixKjsxNwHLOteZRxnLtr4NSRKBm2AEqVrx+BkLleRLsLxiQVl5SnMAsMf42glAPQreLe6olq6CnkqcLzRMbLnqzrsa20eQUQbLYXZ3PnWn0NVfKjCsQdUgNLtJbFb7eIrWYSuyIOwMPaKHSF5wGsdoUv8dgKVfPCNKNYfPMoCDtTBYSCinPI8Si0lKvEar1FOTXivzNJkrFyW+BR+48h2sEsstVz1kl5BHFTYKW5gRRGxBcNOmuxPA/HP1svY3tSZmfbqfSr/OrdlscFz82pMvEK02YDVuskEJqU7MrzM17ZE3YhGe2QNRxZJRKFe7R8lJi9uG+baNAx+vdoV0hEW0KI/acTvZ2xX6SrGL6YVOpaDWFC3sXy5lIas6Ovxkz/0d1o/cg+p0mhNt6t863XaR7pjbZblDtl8+r2v1RpfMECn+R27QIVP6nvCbDn2DVteFILJRfBgOrKw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(42112799006)(23010399003)(38070700021)(4143699003)(56012099006)(11063799006)(10067099003)(7146999003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?FYK7oKOH6YgxuJYF4u5FInnIR21wLLbv4iXdcGW2wKX9Pe7nEH76jj4ioXQx?=
 =?us-ascii?Q?HjhoWxyoOBUQ59QcomI+p2W4JXk34zausrt0NMLlgPFXEifth0h+BbbcKKMk?=
 =?us-ascii?Q?xmdOuPPf/5kIVus9fkXOxK3TgXk2Qxopt3vKomIbik61EVYwJAqQteVeqgZF?=
 =?us-ascii?Q?v3OUQJW0K51N3Anu3O2IAf5t5o+2TguFY9DDPiasj1escBOmXzAWJRXNQITh?=
 =?us-ascii?Q?nKjE3shJPbc38kkorr3tsl82BVPFCro3QTawRAJHuJSmJ5kIMCH+/EVTTzUp?=
 =?us-ascii?Q?nQJwyR9SmJZeLiQy3kEjt6F9U1ugiBVOxTUk33toUseOS34MR37pnEGzGaLi?=
 =?us-ascii?Q?hXl/TaescHinQG5SBXZT7wPEnJF+pbXzpbmq+agEY/OgQUhrE2FUQt+n75du?=
 =?us-ascii?Q?UUHKrEqkqfjaDXf84+lAYUwFapFsb+LPipj+5MeVdrL6UBZWKPF6Um/nT+OV?=
 =?us-ascii?Q?+eHUMfaUzRSDQWZJdC7Q0/dnMQyt3B9Y5by4UKeHRCSLKp0uKLhu4A3EtUjV?=
 =?us-ascii?Q?P1g3RDkNzv8d2ZsBHWB/wEBlLpqldqOUiDrCruwMTn9I5s5vKhwXDB/wNM6P?=
 =?us-ascii?Q?iDugxwlDdwzwYkLcdmchOu8Uaa0s7vzw2aG0rWl8St8r+22r/joThqyeVmWD?=
 =?us-ascii?Q?FaDbVDzx1brcj1YOO8ZxbZjD/PYwRpRECIv3G8HIo8opng98P/S3oN/vRt8k?=
 =?us-ascii?Q?nILWLUdWPeRSrP52tSfu3WvYoZeXuNT04Z991QawcqjjWNh3uYe4gLfphCeK?=
 =?us-ascii?Q?KF//3esoj0wB4gsGBZF6JBv+WFvPnt7wSDk/LQ3VsIocrVAtWUibCiwudPc0?=
 =?us-ascii?Q?rZyI61Yd/ZJ5N5eYk9x7chS1P1jSYrwpbLs870YNV7wKdoXkw85eD7UiVB2o?=
 =?us-ascii?Q?OodvT6/L+Lmsw/wp5b7R8oRur2BakCYSiH7Rn6Y3lreP63xONLO5QyBwrvvq?=
 =?us-ascii?Q?zRNzgbRV6P2gpq+9iIHbltjvoFXUniSiX0q97cXKfBbIj/aJbXYawSm3/MmM?=
 =?us-ascii?Q?YnPjZxZhldqUjxIt8bESa0w9OzWabvxGm/rQBi1+FL2nOinyQLtPwW3cA+3b?=
 =?us-ascii?Q?Ek45ReqMuqdQNKxeXeVVr7JhVjqgmzaw7rtJS5NHZ2Evrpt8/VRi6trum7ar?=
 =?us-ascii?Q?c+xHBie74kW2RL+B+bK9LVZJ01a9deRVIbiy+v34iNPifs0fp9S/tRfKmLP2?=
 =?us-ascii?Q?2aqETRhYbmB+xRoiB9XvRVWhSBFdEBZpbQoZ1twpf0OYB1bZuyDPi8UHYGYZ?=
 =?us-ascii?Q?mbhdF86zudHQ8Z+86xk83GU0gOAQZyx4/8Cn/KwkuATQ9x0TlFgntpXkfcUF?=
 =?us-ascii?Q?2j/C3MU1/gDKM1Um7B3LRGS9uJ5RX+8OmY3TuSHNKdNzhj2T8shCTBI2qsub?=
 =?us-ascii?Q?WtT79yz60rvbk3SUrwXs/nIutjNFlKJT6Seh/SIrwdOBU6rQafS9C/m1aTvA?=
 =?us-ascii?Q?38DUYu7+6nx+melFe9Mj1Fo/e4a43WxH8JRenhBi8u6iqv5PXo0n3BD4nOUJ?=
 =?us-ascii?Q?C/6amIaTUTwfzaLH6vJeqyCwE5miUhn4mMuH5LSiB16WahZemQ3mE6Jv3obN?=
 =?us-ascii?Q?tugTHfOGx0jo9/K8a4M2C4miRn9WUY3mCu5TkOG9q29/JzLBWF5TRn12Rebc?=
 =?us-ascii?Q?d7unFe9XXXqyOi3PsgsSGzy1QJolOnBJzqkwRF1oRmbkb6ukzd9KoHaMnGkX?=
 =?us-ascii?Q?ub8wiDcz0LeEX1dg8jXYPC5EiUm5f629VtAQGMf1/fXfOY86?=
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
X-MS-Exchange-CrossTenant-AuthSource: SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6caac795-b8ce-4c64-b6d2-08df304c557a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 14:54:11.9326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kzk5M1KswVht0I8xpSRvXEI2v2/Cy8G88e0jQG2FHyZMypXavjVmVJg0dNcvc9gZxBztbm+Be+37I/scOzAs+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXP153MB2162

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> On Fri, 16 Oct 2026 12:06:11 +0000 Wei Hu wrote:
> > This series adds concurrent HWC request ownership and negotiated HWC
> > queue depth to MANA. It starts from depth-one bootstrap queues, keeps
> > setup private until the final channel is tested, and preserves the
> > distinction between CPU lifetime and PF ownership of DMA mappings.
>=20
> Please respond to the netdev-bot AI review in a timely manner.
> (You can ignore the global review bot, it's not even CCed to netdev so
> maintainers don't actually see it :/)
>=20
> Can't tell at a glance whether the Medium / High severity issues are inde=
ed
> valid or nit picks, but since the merge window has already started let's =
revisit
> this after. Please repost in 2 weeks.
> --
> pw-bot: defer

I just replied to netdev-bot about its review findings. Only couple issues =
in=20
patch 3 are valid. Rest of them are either pre-existing or nit picks. I wil=
l
send a v9 shortly.=20

Thanks,
Wei

PS: Thanks for letting me know that I can ignore the global review bot.
