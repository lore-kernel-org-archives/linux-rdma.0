Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.104
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792682258;
	b=LdKFPwqvjs9ywTE+whHeJ/wp5z83mg69GzEsmjgYEUE50Twwn2QEgdpMMr4Mth/XvpCX
	 v/SYL+nVCNEitg/ZK4dNJVvKUEsVwkKy/8zcaAdBWw/OetnGxKQ2CMUnwHNH5rkuV2Xmw
	 JmN54RBcQ3a5s4IGQxrqyiqHZxYUFifxJf9EtZf8xxZ1Z12/HUk5U1/1vHPEtov/B/eAn
	 w+l6kHknZe2xgfrGwMxkhf+JxiXOpMryA69JJZsTnEb8z/ttGAlvLg4ONs8sp2Nw8brM8
	 wxLRnymzddmBriOM7aoblJaxH5LqmsNEmaIhsPxpSlv39eGjAklpYE50ZMvuAH9Sjww==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682258;
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
	bh=q0SzshWkpXXO/leWbVWvWeTivhJ7U7mAksjNjSlle6c=;
	b=NjS3JrWkb2KhFtUF6cCOrcbHHxbaI9fZaziLGAEilLSyx6ffsl6XhAV/D/VIsisu6i8S
	 RCn48ZF8RpT0mLKgT+Yv1oplnt+wqdDiWpuWOiIhzhDBCG7/lu21H0vRUWc+jEehRSDHB
	 iicBBKmLkoNX0i92kaLx4wHqEcMuHictwj2xYHe+Wrkq/73F+IT2hdCGoEyrlzT5TRdap
	 Jqe1PmLrox9tRSOvvDwzNM8NQ1df51TQheXn3sFqLg2OMREoE2+Mf1ZVE2C3lZJPmeZHz
	 bfwIsUjFVyRInxbhm20oUGNLCv+Q+7Bvvj/KEqNZvaOaI7OdRoo3g5v091fbaxAsJvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=KrBFHr3Z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.127.104
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11023104.outbound.protection.outlook.com [52.101.127.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58F60A6F7C;
	Thu, 22 Oct 2026 15:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD58F60A6F7C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=KrBFHr3Z
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cggM62Mxz08JI58AP0TOHSVSal7lBix32/6sdm3H5D6XtEx2GbWa/ue+fSSR3Z5090rmg5Y3iZEfstm2smjk0bFRgrnqQMiri2Plywm5WFk9H+20EeKbf/0OU8jZlgiZAkXaK5HA+UcKkZlbgDKmFxF4VHmOLuSG6NtUimSvYwWJ8GqWlCBC4/lM3Dd7+T8osdRYt9CdDJBPW0Inq084EpmPhbe4VTtex5UnUBrkjDxexd4pdpnDaWAUxlb1aXO8nM8mMLkjxTxSJtRvIrYPSQN0/dcJmnKUkag5uEVE3bXg7adz08AmzW0wqBvaIH7/6pI2MyFkvtrXjyM4zVBHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=q0SzshWkpXXO/leWbVWvWeTivhJ7U7mAksjNjSlle6c=;
 b=VZZpkcPg+EqYxBq/+9ETdhwv/UnxeGykJhctSXfplmPLPTPqZ5+Y1Qp0/8Kwci4M0SK5d0+EbgSNk1auR5zQxJ/CrG6EDcSN1exOtsG8OiYxkY+bbyLl+XKkX51m5i+m6W7OKkTHuvwTni9DLiwif407jtXN6W/Gsfs2EOdcJaGwjDGjxaVhkgoTWJO1B/AaKX/M1tS2AAYdBxdV1VKHFeFXWE2L9cAZXuI+N7h8VSQ9D0PAEHaBtq/8hTrygDg9Y8lPtXuVzvOT2K9X+XxHFW5boSB8dWiPHekA1VsROnODOhzYYwfBEcGjuj6M5gNEsZgNSVrr9Ih2MG5YKy33tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0SzshWkpXXO/leWbVWvWeTivhJ7U7mAksjNjSlle6c=;
 b=KrBFHr3ZxRE2R9p3n5vPw51Ps3bvMQsIudjVagJSXuybtqHG0SxkPiTFMa3nSs/5yiMGeJ538JYtJg8I0hzRZZAQsxtn6scA1Ft2Z903jRIXYfEUENzcJt7UGXdn0XDoIyE7qaJmvj9iv62pB8t46gHPIWexWBbUTz8P2RgojRE=
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM (2603:1096:101:340::5)
 by KL1P153MB1032.APCP153.PROD.OUTLOOK.COM (2603:1096:820:125::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.3; Thu, 22 Oct
 2026 15:17:28 +0000
Received: from SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e]) by SE3P153MB1848.APCP153.PROD.OUTLOOK.COM
 ([fe80::8f4e:575a:4706:a56e%6]) with mapi id 15.21.0569.000; Thu, 22 Oct 2026
 15:17:27 +0000
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
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"hawk@kernel.org" <hawk@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "edumazet@kernel.org"
	<edumazet@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v7 00/13] net: mana: reconfigure
 by replacing the queue set
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v7 00/13] net: mana: reconfigure
 by replacing the queue set
Thread-Index: AQHdXYR3tisjI+eJx0SwkRFHTKT7ubcIkBsAgAEiViA=
Date: Thu, 22 Oct 2026 15:17:27 +0000
Message-ID:
 <SE3P153MB1848038C8DA6E7AE7A446F87BB652@SE3P153MB1848.APCP153.PROD.OUTLOOK.COM>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <20261021144604.5a56a096@kernel.org>
In-Reply-To: <20261021144604.5a56a096@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8b1d6c87-8232-4581-8d7c-4db0b129f1e1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-10-22T15:05:13Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SE3P153MB1848:EE_|KL1P153MB1032:EE_
x-ms-office365-filtering-correlation-id: b173be8e-5d86-48d1-7158-08df304f9538
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|42112799006|23010399003|38070700021|4143699003|56012099006|11063799006|261021121427099003|10067099003|7146999003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info:
 7UYcV0MI13ZiZ+rGldHH70oDbV8PDHulIxlrNYqpTQ4FS8RhfdvrnvoA5iFlZNpLTtup1CTUnMvt/85Nym+O59egruGLVHnnALeT3muPr732gNu9QxHWMICtAikT2MwzJrIieTBoM9sYw1DMpo75JzyJThr3ztr/67mYxmGw72xC7In2P3fcHd11RqlZK0grWqY0X2emJCRr+MPYpHJ6BXsAyv1DaIN+rbZhNTjOAX8EUgdQrB3WCGIQnO6ReTR7XzKcb6ImpQmaF1t7sgQi9GSmXwlGaiWprwcKuJlfbpi8J/++Ltk6LcBQpxJd+fi4Voe3rrB5GYBP+HlPMuFabtkfvbvINb6+Vn892I3qNTkKbpD2jNwEMAAZm5opjy8qwz7Vb/k2XbJ2YUj0qmqLnj6sGy5MlB9QCghlZzj8wM0Bq4T4cjDmjjuyZzVfTF6FYsibs8viwswoUOi+7ICTVGRgtPOryQdXhf7zxVJQNeMfw9X/upeS2hxN32Jt6/3tG+SyqVG1bCV82ACdEaJe9sygH0OCM6Rl6WsdOh3trnr7zCVW65eh2ELsqx/Qf1KgFtujeGfXV3gXrpxkw8Se2LkHiI1s5naIMlNRbLmLwXLowg9cwbG+sqlkNCKwbQocgnZoDPh9QPER84iXGgScUz3PDQ/iZ2mIB93K0F2Wa8QnMkqOqWs3r0VP7ntHM8HL9Yuv7Zq+UCOsZk+9RWGpcsNSiI3tK14hoqzPSGqNOgA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SE3P153MB1848.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(42112799006)(23010399003)(38070700021)(4143699003)(56012099006)(11063799006)(261021121427099003)(10067099003)(7146999003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?S1eywrHzirDDARTP0/QBLTo2ZpJGqKOBT5Z2zb8rNsK+mk2zj7J9kYq2a0NT?=
 =?us-ascii?Q?Fhss1FepPswHcNMH7Lw1g+V8qeolyFqICmmovozL44VNVkEvy1NZInN7vcWm?=
 =?us-ascii?Q?/fudOuw/a+hkL3vbCSR11LUcvZcMLC/B4S2qFGYTW7WeTEDWcsIGgWtHXL9i?=
 =?us-ascii?Q?rLkL59+EyRUXCHodweJjD6Hu7iRdnnWBcVN/D/CgDqwyjtHxocQOBIFIhTxG?=
 =?us-ascii?Q?2zDa4jm0XZEw7kka5aWHTXKwMUqntGEW6SyliDK/Fedc9Wki7+cHkZF9xDGy?=
 =?us-ascii?Q?rFRzuf+Sf9KzvY2Te8/yi5RFt/i3XQItMIVMQcd+xI8CH7s4oVotXQKpd+pO?=
 =?us-ascii?Q?a5E6DwpA193UMKHTCzWtRiOG2YYKaJGPN2JQH66MdxG0eSRroQ2Eoonxium9?=
 =?us-ascii?Q?0bq6abzruEnTpvkBNn1XbPhWC8V90ppEF0povcFbzYuqh/OvPgZFm0FnbrjE?=
 =?us-ascii?Q?tNMRRTrOJFpPuNvEfNpDXMLKv1FeOKA2Xm+XEaHy8undq9QVkYVkUIh2Ue5M?=
 =?us-ascii?Q?n1wn8SG7Pz1j823w3rwH3lIH09V2DJ08OBUxsBfOzSnMynfYVlLQagOxRhWm?=
 =?us-ascii?Q?PRSo62Dkv+3hJhrfiGNwr6kvmz/CHIhf6Z8rTG9/Qw2N/Lmv+oUmPPRUubnk?=
 =?us-ascii?Q?sdEnW77UyjOw+2tL4HC5+jLf3p9AVFAIDyCj4hkogWpdhBK06OrDCWDZpEvO?=
 =?us-ascii?Q?1cbz5pkKeXbiAUmDs7XJRV8x49YDlisJgkgkVT6FTP+B643nfJtFsADU8nh4?=
 =?us-ascii?Q?IOZhLLqpUXtgs1JNkr9WlfgaYzut9rzYGarLZ3mcTOh/Oz52549oBpDqig0o?=
 =?us-ascii?Q?MToUlKx4pUOx7RaHcF35vBHLyI8rut0TSJmTh/pZug9b4617w8H9PmqZetLW?=
 =?us-ascii?Q?c5iTkvtxFALbULX6jlMcpH4sU1Z3w4HcjOS8Hp6xzx599mi9+TO7oqPXWwGk?=
 =?us-ascii?Q?xaU7q3SjvGkwS24j3TZ9U1oW09eEMGOfHqcjQVFlTipgCUPcb7tkb/38Jhyg?=
 =?us-ascii?Q?MYGBLGlxuAkX3+0dJzGdqvr67/gh9ca6Mcj5NpHtjBNGUpPufXbNAv6RoCKU?=
 =?us-ascii?Q?MORr0L4CMRqjiG3lOdqcSwhoVpeRTFcAPum0E7BZWvxYNiDMWNFxZNMdmynr?=
 =?us-ascii?Q?6y+sx7MkX61fkEZI7gC+gTxPT5uJtwnaX2Mohccet0jwxG3dw7iPkvso0rG2?=
 =?us-ascii?Q?UiRDgXlHdczPYnNK/UkZBRyMFi2vg5i2KdLazO+3oJN6xxgkw+A8e+j8ubf+?=
 =?us-ascii?Q?3L8YJahkhw47hIwkGTtcEQ+5bcnvbQQfwQJ/3MXkXrwZcujeSX2P/EQdQVF2?=
 =?us-ascii?Q?IuJqFKRejivZHsxn9wGSwejWdOqWIDjZjrlTOpdwO0tDKtAwOyI7LKAJgce3?=
 =?us-ascii?Q?EA8QLaqM9NYIIiT1SPP1IX8akgqJusvLmy0Q3dGB6NYHMZ+gJnNo0RuKHYng?=
 =?us-ascii?Q?rcuhv7/GFazgYlfQ/h80hW9JvA0Xo0nGFnFy8Z72O0AiluFKl/W4tpSWe2L/?=
 =?us-ascii?Q?pwqQBATi1ZziMW4TcN//Bhkgw/icyx+sZPX0zlS9GM+Rm6SPRie8F38aVazX?=
 =?us-ascii?Q?WqTZ4VQrd6m4W5Bxw1Gu9MxxggjRhQCQkg4WJZeQN1Y9hA30n5X/PEJjGNu2?=
 =?us-ascii?Q?fHs6ohToCFDzP/+AaQBy1Ik5iepuY4k8ybhKkzKzaoq6NXFH5CULaiXBA/Fo?=
 =?us-ascii?Q?Qr5B0DNaE1O8qxq0RK7+k2LiXWHhetIXn3ZKpH1b/YP40v10?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b173be8e-5d86-48d1-7158-08df304f9538
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 15:17:27.3543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: av86Z7vG9K+7bvDrOSc+fNfLM+aOTvW+JvzsimqRWtv/6zPMTST/v80NqdpeF2w24cFQ6j11zunOmoKjbcqgyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P153MB1032

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, October 22, 2026 5:46 AM
>=20
> On Fri, 16 Oct 2026 15:38:33 +0000 Wei Hu wrote:
> > I am carrying Long Li's queue-set reconfiguration series forward for
> > this revision. Long remains the author of twelve patches, and Dipayaan
> > Roy remains the author of the detach change. Their authorship and
> > signoffs are retained; I have added my signoff for this revision.
>=20
> The BQL support went in and this series no longer applies, sorry :( Pleas=
e
> rebase & repost after the merge window.
> --
> pw-bot: cr

I will rebase and address the netdev-bot findings. It also has conflict
with my pending HWC series. I just posted the v9 HWC patch-set. Hopefully
it could get accepted first. Then I can rebase this on both BQL and=20
HWC patches.=20

Thanks,
Wei
