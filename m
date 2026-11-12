Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.120
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794484936;
	b=MIBW6KdJ1iAglHjeeN1Kk4qVgNpbG5StYcm0Jwo+E8WUM0jXWMUD5aQMAO+JBDZ9FMM/
	 EkFu8l0NjqQcPzA+9Ub1BUiBKU7C7VYxF5RDTACLuMzttbb4kaYEEIPaZb8dlEsWrlcxL
	 Tj167z0X60LXhLW8IicnG8DqYM0JbIdgE2FKW2RWEfT4eBHdcUBZdKc66i98R1/F5y4A3
	 XJ6j1skSkN/JHkTMfwfqK6kTA7325R9R5ToL9DYA8u1TR5saT9HM4Ye7tC24yyOp0Axr3
	 Mc6WwlZ805E7xpXkXyksFyRwCfVY83YhmM8OPdiUg0whETCiGlCOloT9m6AEk9G+zSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484936;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-Mentions:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:msip_labels:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
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
	bh=Ko/Gkkeo0mdvDUa5o4qk3Q6B+iiG2ypU13H8M4wnhOM=;
	b=lc0IgbjXwOQqw2O/BSAsXtyDXGPE2ApDrE4hU9oEEjyIo4P36exAYqHXmQb7JREaG1Dz
	 E+SiLv66eoM3/5qTnSw77jaFx4Y05hpltr3se3qe4ysH7z73K3oW977/G2dPRwoSV18Jd
	 uhrtv2s85Jlu6sLNPvwZn14/LsMm1su4s43SF8qqkc2vEUVdhdi0XammlN5mc3Pkxjpz8
	 dCXSUlaROaf3+rNXNgoW7KnKD3Lymry4cLg/HCKLNWwFiVQbjZC5td7opavO+meJOz6PE
	 dbX0xdF8BUtQRcfa9KyVZgo4fKlBoe2JV/Tekz5X7dSB16ioBw7bkly8MOro3bxO8/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=earthlink.iq;
	spf=pass smtp.mailfrom=earthlink.iq;
	dkim=pass header.d=earthlink.iq header.i=@earthlink.iq header.a=rsa-sha256 header.s=selector1 header.b=j13WoJ0v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.120
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023120.outbound.protection.outlook.com [40.107.159.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AEE606A335;
	Thu, 12 Nov 2026 12:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0AEE606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=earthlink.iq
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earthlink.iq
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=earthlink.iq header.i=@earthlink.iq header.a=rsa-sha256 header.s=selector1 header.b=j13WoJ0v
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XS1mGc/eBA7GNDheElp2EuFdj2KxCgdZE2498e4A7QpeXjrzReHc6GiiYDt631pQLh5qt08I0890aKTVUvYBWtkECoC0ZeuUc6LzFUtMSROjjZsnqwAMtZM8XUtzwsvGbhP+JXrNrzSfgIoanDjbtdHrGVHdkzHlBRGEmpjUfItNNghbAJ85gb1H9d4CAR+dBe7JJTlgIpX8Ool+wLh2vUvNW14OX0Kdq4ZpSW9q8hlaqWHHARFlHj2IfKt/RVf24136ngwuA0yFKaM90Si41aRFlsKOkKtj0t1h+Qgl4q09tuYJ3Jl18yByZqYjwmXrwg7ODimCR3oVCjK0SkY6Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ko/Gkkeo0mdvDUa5o4qk3Q6B+iiG2ypU13H8M4wnhOM=;
 b=ogex3oU5qw5Z4sLCTGUZiycDzBwkOF/ImqX5JG/4+cqqOaM1YcnWj1CngOVxaxc7y+SDXDbWnVqTGVv/mOomRh9hF0thNOzjad98MZCnbOu91FBgAzOYt8HfD67f6npXlDsGX7j64GBu8FP/kmD709CE80KxTX/PXh6c1dIUC7h5ggdPve4oGfwhyPvD34aaOCwdnpNSvl6fzO3DmXZ/FIjZ7MS0LJvVSd98nDYlhjoWNJCGA43EYAtW04w9p13Nrkwun9zm6mHZKzLf2twrKqgzinS/nGuOAH6XzzEnS3BwnhFsfqtPvgAry3qw9QXXAyLUGp6Jq/42J6XBf4pFqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=earthlink.iq; dmarc=pass action=none header.from=earthlink.iq;
 dkim=pass header.d=earthlink.iq; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=earthlink.iq;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ko/Gkkeo0mdvDUa5o4qk3Q6B+iiG2ypU13H8M4wnhOM=;
 b=j13WoJ0vNe4naz9TLAP39yAzRuB8CwVNmVPSFapP3LNzRNvt9G+YxELBxYmrmTn2X0VZuzMktcc/RTiz5LP6NDQCMhSOtaZYiaqWmBB1q+dgY8RvPGmw+QqG30Eu34wc9Do2cEySc8sgShGaar67PS4l2dGd6gocDu/jGDvlUbZ+QQdlGZo+pAkpl/6hmthYxZ291CxrYH9vavPnZ/ZZhHybRAUVkmZUcA12//yIJhOSjbxFR3eI8PDRQSqo3xyZXYSje5bJB77c0AGVu1oKAVxqs3xy42VH3WQ+gjnpGoX3G8TNk9MzQ067Zx1zgsIgb6DICZ6LBgtFi9bgfmfcGw==
Received: from DB7PR02MB4313.eurprd02.prod.outlook.com (2603:10a6:10:48::15)
 by VI6PPF84D0E6D3B.eurprd02.prod.outlook.com (2603:10a6:808:1::313) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 12:02:09 +0000
Received: from DB7PR02MB4313.eurprd02.prod.outlook.com
 ([fe80::ac76:9f97:356c:b810]) by DB7PR02MB4313.eurprd02.prod.outlook.com
 ([fe80::ac76:9f97:356c:b810%5]) with mapi id 15.21.0615.008; Thu, 12 Nov 2026
 12:02:09 +0000
From: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Cosmin Ratiu
	<cratiu@nvidia.com>
CC: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>
Subject: Re: [BUG] net/mlx5: nf flowtable offload rules never hit in switchdev
 - root chain misses to slow path, not to the FT chain
Thread-Topic: [BUG] net/mlx5: nf flowtable offload rules never hit in
 switchdev - root chain misses to slow path, not to the FT chain
Thread-Index: AQHdbElUgfk1enT3QE6ugzlHtdAqZbcqTM+AgAAVLV8=
Date: Thu, 12 Nov 2026 12:02:09 +0000
Message-ID:
 <DB7PR02MB43130E9B57458E49F3B8BCF1C6702@DB7PR02MB4313.eurprd02.prod.outlook.com>
References:
 <AM0PR02MB4307F6D53A2B0AD628D91C81C6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
 <62612ebd42aef5eec1f06a5465e3e6aff9110d41.camel@nvidia.com>
In-Reply-To: <62612ebd42aef5eec1f06a5465e3e6aff9110d41.camel@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: cratiu@nvidia.com
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=earthlink.iq;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB7PR02MB4313:EE_|VI6PPF84D0E6D3B:EE_
x-ms-office365-filtering-correlation-id: 53f54f56-af7e-4e97-7a01-08df40b4c792
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|261028144727099003|56012099006|4143699003|261026140227099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261022075727099003|5023799004|261009223027099003|38070700021|10067099003;
x-microsoft-antispam-message-info:
 JLJ3962CmfgSL6U3ZNZ1WDQmvJN+E14ZroFH1N8TDRjeAZclZPfQfXvRL/5xHwS9wqZHH7ZR2aYKAKRRbD9wQt03EQFlJeXIUdLLzryL7MKVRKB8erDcGBXGJijCZ/bUBybEaShJySdJWl6Hz3ezrRXt+A32sZpjkdr92R5Yem1ZOqg1L89a1I0RWKyfjJJ7jzkgQ8y1Vul5QYGY90zrIqxw57gxTJDHBtH7DYuSS9D4k2nM69t4weWl6sDDg8jU7ZhlQkyJEyZK/IsbLw1KM6OYqgifHSH/z6xdJHBFBLKeEetT7flCAHC5vkkM249in5/bYRKSg1TMMvuZD/+EHBX63edTcOfc7iOdBGemxMmDhEAIpQ8UPw+Yw5AtZLOr66r4oFZ6hKt4TxuxGlTPCzhjLu5xZ4h1B+SeY53eitsFiuYo0wNppzXVilv/Cl2Wm8cw0aPUc+MXCyRQ343e4Syzk9uR7TWdppgdSqh/tfl6kDJCjhsMXs4gbII010BkpJAdHN/iJ5Sif/1cx20WD6hAS2lAgrpQmfduddfJRdE+Z6SKBiVzSW3FpsZgLelW9yv0w7nn+d2D4DYKIEuz9G0SXs/MW/RogHWLI7eJE7V39Xpq+wveb2rNxI7/GWTMTtitR8rnTkF34yy3qXFA0JjwrPsoV2yUWF5A/vzxrn7L8A+0jiaTf+6S6+nEDGiP47CuvYWwOu4QUXJaVVOcKZGLTjs9Qy2elS2SKmqLEew=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR02MB4313.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(261028144727099003)(56012099006)(4143699003)(261026140227099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261022075727099003)(5023799004)(261009223027099003)(38070700021)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?GPWuKVD0D0CQqZxwQi4l29418aDv612tYW7GY3DnZKQ0QwtgRwrRUizfGM?=
 =?iso-8859-1?Q?Qcv3qhPcaMpdpR3/orehKG5ezqOo4PVfAjQKIkuolIwg8AWXRTjW6l2qJl?=
 =?iso-8859-1?Q?9NGVLQUEcNUEW5DfJEpra78Q4mefA/5Vke+q/Ph/c7LCltD8mCaSKAmg4Y?=
 =?iso-8859-1?Q?nC3PU5SqW8E5qcm2L0yV3FamN4CTq4s4kDsvGKY7+O4DnptauaNOTu0Lsj?=
 =?iso-8859-1?Q?9dkV2oG1ZfBFuSS7YoHKddoPPq9frmrMX2p1ERH4oXpSHzRghc3n7VaSyT?=
 =?iso-8859-1?Q?3xwvSRwgYZcjcGtj0Wi2FWD0ocRbuHV2/myYZJsf8IPZnlUyP1k6hLRwOX?=
 =?iso-8859-1?Q?2CeexL4xAKDZ/ca02wCVoff5sVCJYaRiG+RcyFq7Lws+fZZ2X7Vm5I0TrL?=
 =?iso-8859-1?Q?bA3Ydgo56hbej1LZiS1KTiVqDoLJATJkLYKAmsAw6y5elo7buHqpt9pZR2?=
 =?iso-8859-1?Q?VlDJ3L/6gpddqL6zC+DIOTju/3Y8PCuuMnKqTtE2hsmu+4lrwf9vVM+UAI?=
 =?iso-8859-1?Q?r39djE/6zQIEkMVgwj+Hyt4hukwLqXiAELNJgFhkhPn3Fz1QedC6lYsfO5?=
 =?iso-8859-1?Q?QOjNJ/aYOgODXh2Z8DrnauNwTP7P9eidyvvtluhEvKIO4EGZfWlTM5kTc4?=
 =?iso-8859-1?Q?EFi8sTJVKshvg14WiSLctksnZOVTTDFZft5fnh7ZVkoYCRH6wDkYV+W/KU?=
 =?iso-8859-1?Q?4Y6D4mbw/JKYFwa3X8P2E7d7taO1Yv7HInerHJlG5GTI3N7bfevj0x0Pqe?=
 =?iso-8859-1?Q?L+3M+H2gfxQ6xlaGTUPI7GyT7MWFw8eiEJI4eBQbMGxSJMHA2y2yYl/zWQ?=
 =?iso-8859-1?Q?Nc/sNaUHOw4UbQS6iJVn/Q0AO7/7vDvBH6yb1ON83H0SMg5bwnrCMYFJh1?=
 =?iso-8859-1?Q?qxEoPUpHXnvWgmQF644j8LIoKGKFkNq7Vihdzn3Oh69WfLTEOlwkn8+cNU?=
 =?iso-8859-1?Q?KimhrQW/Su8Nzg6rP6G0Maj4OdLsCt2alWoFnyt3GNhTJsbYAjQYOG6/LR?=
 =?iso-8859-1?Q?i6N8aS0gcB49XdeT0S+mF9KnjO2FOfi+zfxHrvUyxZ4ppZX2nbrc2BWMNE?=
 =?iso-8859-1?Q?+Z+8B8ArZxq7vRrgHATUCmBsFol/dZ3e0ZtSBuq68j8L6dvYbgqy1ZWQp5?=
 =?iso-8859-1?Q?cA97+8y84xn+YtgW+RrrYtznzo+0gQvKRgXMhbCrxTfDhRWKysrSkIWKVJ?=
 =?iso-8859-1?Q?U8Gpm9vwudFRChttZyElJlm+qaPNrCtliBA7nT/p2xKEoib04kR0Qrj71U?=
 =?iso-8859-1?Q?MSbMFlvwcrFx/7dh7lyC4gEn9C/jmUYCeDxJdTM3bMQrutXVsU1l/+iJk4?=
 =?iso-8859-1?Q?11l2aDAIc+EKN2y1ycLDMKYLPow82hqxnK9oiAHfzQcEB7qrknWjvAzdDG?=
 =?iso-8859-1?Q?n6by8To7UiyEU4S+tuuRETljzfo6iS0s6mxrlSuzwCSIH1D/10/SwWzvUY?=
 =?iso-8859-1?Q?fxAjony++ocQyEz66g6NcD28vqXPmLjofYhq/a7QF0vOzr9D3Kck0+C83j?=
 =?iso-8859-1?Q?zidSa5LEKX94Bn0cFk6ou/ZKaH9/ax9SZYByFCH801LfNHQly8xsRlzNVQ?=
 =?iso-8859-1?Q?xlmbII8Pi305IoUeWAB6nOJ1tM/ef1w7EgDFE3WAZXYmXG5aC14Z11hpYx?=
 =?iso-8859-1?Q?P0q21KfeGqaPn/x2MBU7uab/aDCYWFe9liqlhCsGcZMTvcnsj0xRIlp3db?=
 =?iso-8859-1?Q?C3iZD3xPWrAAGDwe4uhs4WifhJ88mf2iA4FlFd8vKEnz24ZIRWhgKBSErG?=
 =?iso-8859-1?Q?Fb23/UsIu4C7SSTSG+llViUiWkjLmcqCxuef3I9s6UOIVd?=
Content-Type: text/plain; charset="iso-8859-1"
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
X-OriginatorOrg: earthlink.iq
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR02MB4313.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f54f56-af7e-4e97-7a01-08df40b4c792
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 12:02:09.6034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 89d949e4-9c48-4c58-9092-cf9b53301a04
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZcTc0pcV3x1uJrAtmuvbYD20DvQ0J8gpSnuQAzc6TVo23tddk8Be0aC8kRl+eyyEJT9ddxzLIpsI2q+Q0lNBgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI6PPF84D0E6D3B

Dear @Cosmin,=A0=0A=
=0A=
Thanks for your reply. I would really appreciate it if you could handle thi=
s, as my schedule is currently very tight.=0A=
=0A=
Best Regards,=0A=
=0A=
Mohammed=0A=
=0A=
=0A=
=0A=
________________________________________=0A=
From: Cosmin Ratiu <cratiu@nvidia.com>=0A=
Sent: Thursday, November 12, 2026 1:43 PM=0A=
To: netdev@vger.kernel.org <netdev@vger.kernel.org>; Muhammad Zuhayr al-Tay=
yar <mzuhayr@earthlink.iq>=0A=
Cc: Tariq Toukan <tariqt@nvidia.com>; Leon Romanovsky <leonro@nvidia.com>; =
Saeed Mahameed <saeedm@nvidia.com>; linux-rdma@vger.kernel.org <linux-rdma@=
vger.kernel.org>; Mark Bloch <mbloch@nvidia.com>=0A=
Subject: Re: [BUG] net/mlx5: nf flowtable offload rules never hit in switch=
dev - root chain misses to slow path, not to the FT chain=0A=
=0A=
=0A=
[External Email] This message originated from outside our organization. Ple=
ase exercise caution when clicking links or opening attachments.=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
On Wed, 2026-11-04 at 10:46 +0000, Muhammad Zuhayr al-Tayyar wrote:=0A=
=0A=
> Analysis=0A=
=0A=
> --------=0A=
=0A=
> esw_chains_create() (eswitch_offloads.c) does, in this order:=0A=
=0A=
>=0A=
=0A=
>=A0=A0 1. nf_ft =3D mlx5_chains_get_table(chains,=0A=
=0A=
> mlx5_chains_get_nf_ft_chain(chains), 1, 0);=0A=
=0A=
>=A0=A0 2. ft =3D mlx5_chains_get_table(chains, 0, 1, 0);=A0=A0=A0=A0=A0 /*=
 "Always=0A=
=0A=
> open the root" */=0A=
=0A=
>=A0=A0 3. mlx5_chains_set_end_ft(chains, nf_ft);=0A=
=0A=
>=0A=
=0A=
> mlx5_chains_create_prio() (lib/fs_chains.c) chooses the miss=0A=
=0A=
> destination=0A=
=0A=
> of a new prio when that prio is created:=0A=
=0A=
>=0A=
=0A=
>=A0=A0=A0=A0=A0=A0 next_ft =3D (chain =3D=3D mlx5_chains_get_nf_ft_chain(c=
hains)) ?=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 chains_default_ft(chains)=
 :=0A=
=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 chains_end_ft(chains);=0A=
=0A=
>=0A=
=0A=
> When the root prio is created in step 2, chains_end_ft() is still=0A=
=0A=
> attr->default_ft (set in mlx5_chains_init(), here tc_miss_table). So=0A=
=0A=
> the=0A=
=0A=
> root's miss rule forwards to tc_miss_table, i.e. the slow path, and=0A=
=0A=
> the FT=0A=
=0A=
> chain is unreachable.=0A=
=0A=
=0A=
=0A=
Thank you for the report, it looks correct.=0A=
=0A=
The suggested fix also looks correct.=0A=
=0A=
=0A=
=0A=
Would you prefer to formally send a patch with the fix or are you happy=0A=
=0A=
to let us handle it, with a Reported-by attributing to you?=0A=
=0A=
=0A=
=0A=
Cosmin.=0A=
=0A=
