Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.116
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795124016;
	b=TLJMudBxdTdkV5c4FbBop9jl8siWCkPc3fO9iNx5EM9s29WuTWQMw1TI9aH9KPhhMyY/
	 PCZ6mNsYt71459/Rx+XdjXsDilBQ7NGv4KSHdOzvRHpYjbNeEGiG54upw6Ua33q/HgUkC
	 9IQvqxzl16BhWyTDe6WctbWJ4a5axS3UMfDK3YuLRfFn18RdZhFvC/aI6VNyZrYA/yma0
	 EfB+5F6oymxr+bQcHnKd0gEnKBFHpRW+sg4V6Zd+C7F/VOiiNXPI5HAsqwRaAau8jZVLv
	 RMRrrHt9n3ppLR3CzWfCT2rdhxN4e8gxINQT8LQlxxzexsVium3YXBEVX1VBlutihjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795124016;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 msip_labels:x-ms-traffictypediagnostic:x-ms-publictraffictype:
	 client-request-id:request-id:x-ms-office365-filtering-correlation-id:
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
	bh=HIDQA+u4y2bkO9BO+GU6s2FDKh2s7jOydoRaiNT1sHo=;
	b=sNcL9ryUefAtLl5qH3dm2XMn2f8tSsTnIqlQIXZo8/GLLU95J9KdmipPkJVd3co1QgEf
	 svb22lT01ucciz6qPT+TKMVT3+AzWJLSoZmd6OrsSgr1QVxwbAoE8Yd+HHuqUpo+ECzqk
	 1GsyVWPRJzlj75RH5A1CUmOYmY81024wFSJeo9rR7zmhdlP4RIiGzgSh8pNp1wt5VHez0
	 T8GVXHXhV+c/bM7HQhtfi4194I5bg0oive2bShSprv9YMbMHiu3qK8X0i6uBOcqtMtBsN
	 OHo9tCa/AHyypAoAzQT32K5YcOs9qhqrykbvEHEgKBy81/wsBv2SsOMW2FEC8t7cWag==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microsoft.com;
	spf=pass smtp.mailfrom=microsoft.com;
	dkim=pass header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=QGWQxN9d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.116
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020116.outbound.protection.outlook.com [52.101.201.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05752606A320;
	Thu, 19 Nov 2026 21:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05752606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=microsoft.com header.i=@microsoft.com header.a=rsa-sha256 header.s=selector2 header.b=QGWQxN9d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGTZcTqXfmhGkwJw745GorRd5yWzDWXKLXoi8vg5fxKnzxJBaWIbL/F906VaknzIfHfnccpqByY5gwxzDxRSYLodOtr/QJUvqdFhO7nExX9BtQGWQEFkL2rjE7wf0DH8DShmiU8TWZkwWKYmHEVzFCauS3GBX0Nsk+gZ/aF77ApyqQygxwvpwoblMPOYq6wE/CWHDCPnUg4kCJKDORsN0pmCJXJ9qH1jQbzRqx9Vk14s0QZ4rrPVcb34PUXK9+ua12hZsif+GEcU7uEptP0wmm/bNmlEZiPkTGc4UWQz1cAABaNL8K3WoRs/xqou454lhormTP0XVQepqS4lYM/bJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIDQA+u4y2bkO9BO+GU6s2FDKh2s7jOydoRaiNT1sHo=;
 b=JIiMLsfssfWwvxPGA6TT97HcfzjkYa9Dzp+lRFc3q+FUCh43ti25VtgQyxPxVmDJqub80KW0rZqSJIauB4doNzxxpVTwJekAPIpLNoKtoViWS+jHKKx3XPERTVgUBi48vWZOlwHkeEurUpYoPyDDwDeX9OZVrjYZb/F21kU25LcSPlG8j6dO8bB3HFGPOsjE4wQuUNb9baxW8OZ0xSSXRvajaq+fzQlgDAz07+YYIUF3pUk+1WrrramxgcJ9J35IrNWx/xxRxy0zP2YNgfNo+Kinq/QVDA2ZPHbHMI9bCmmoqGEynzkub9KBe3/4uBy5ZJLaGIpqqbY6YXllagZwNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIDQA+u4y2bkO9BO+GU6s2FDKh2s7jOydoRaiNT1sHo=;
 b=QGWQxN9dukF57ULUN3goF+HPgi8dbivco2o0pHHKSPBdEsY5rLsv0yQFwLUEZbX+hkIkKlbcPzI3h7qEDujU9XvpOQqpD2QL6lRaZZ6+zzZ+WtZLhll7m9/01Y1H2AXsD7VPItLi1ygSvmtmTSMcr03syL+jphBWN7e9ajd1OFg=
Received: from DS4PR21MB6867.namprd21.prod.outlook.com (2603:10b6:8:2e5::19)
 by DS2PR21MB4965.namprd21.prod.outlook.com with HTTP via P2P; Thu, 19 Nov
 2026 21:33:31 +0000
Received: from DS4PR21MB6867.namprd21.prod.outlook.com
 ([fe80::ca4d:7155:e45a:3250]) by DS4PR21MB6867.namprd21.prod.outlook.com
 ([fe80::ca4d:7155:e45a:3250%6]) with mapi id 15.21.0662.001; Thu, 19 Nov 2026
 21:33:31 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sahil Chandna <sahilchandna@linux.microsoft.com>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
	"andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@kernel.org" <edumazet@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	Konstantin Taranov <kotaranov@microsoft.com>, "horms@kernel.org"
	<horms@kernel.org>, "ernis@linux.microsoft.com" <ernis@linux.microsoft.com>,
	"gargaditya@linux.microsoft.com" <gargaditya@linux.microsoft.com>,
	"mawasthi@linux.microsoft.com" <mawasthi@linux.microsoft.com>,
	"kees+treewide@kernel.org" <kees+treewide@kernel.org>,
	"schakrabarti@linux.microsoft.com" <schakrabarti@linux.microsoft.com>,
	"leitao@debian.org" <leitao@debian.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net v4] net: mana: Avoid waiting on dead HWC after device
 reset
Thread-Topic: [PATCH net v4] net: mana: Avoid waiting on dead HWC after device
 reset
Thread-Index: AQHddz1eoh77ImL/P0mrS5GGpvqOQ7c17FjA
Date: Thu, 19 Nov 2026 21:33:31 +0000
Message-ID:
 <DS4PR21MB68671DF4211103A5814ABAD9CA792@DS4PR21MB6867.namprd21.prod.outlook.com>
References: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
In-Reply-To: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d0ca8241-e0f8-4bcf-a4af-aba0bd16b9f7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-11-19T21:32:01Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-traffictypediagnostic: DS4PR21MB6867:EE_|DS2PR21MB4965:EE_
x-ms-publictraffictype: Email
client-request-id: 93d03520-cf73-482d-8a2f-1584c6682440
request-id: 7d802804-28e8-4e46-b107-08df4684c202
x-ms-office365-filtering-correlation-id: 7d802804-28e8-4e46-b107-08df4684c202
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261022105027099003|261022075727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|921020|261028144727099003|38070700021|11063799006|56012099006|10067099003|7146999003|22082099003|18002099003|7053199004|6133799003|3023799007;
x-microsoft-antispam-message-info:
 w3shkWMqGdlcIJE8YyQkaxS6jwTNV/xSpaxwV9OzHUtgKF+WL4oSsyjfF50msAnr7FNYDtrSvBj/RZ9FJIoK5hnPhY1Ozdr4BVGtS23pNnQuOhJQh+t3b8Ko1DdTX5BhYHQyTufJW6kNMXqbImkkzxbCkC43C47xqnO661eutiRge5zzMOiy4UKYnB7I3JJIkVmD5jR518FRxvRS6zsaNbajlnGSf/M8u/XSc4gVdF8DMhPQlvce0YBB1OWkc2M1noM6sulm9ZD9gIPIsOV0gjovLWYdGjVF5FqGJ/w7djVzCguPa/sYF6VUP62Nl33VY75PwtyYmqjno75ltsOrT1+ESMewCQ6XNB1wcdrasQIUjlyzxye4xEHfDkQNuzlc+4lHGMC+n0lD+U1caajDiRgvlWEuPIC2fa7dNIZEOHbD1VwGHJf2tnqIvolNzb5tqtB9cndl6l56p5Svmi6Qv/lJk8nFTBIrl1z8D+2CQM0VrKvbNTLOuxxCGJXXnbx2tOSoZIbtIu1lWAL9qLEXKB7J1bb6MV55uFpfVICJfPbXaBhQL9QB8aF7NGSLpgMLD71NOJAA0XJaxdMrdUGXtFWUzS83iUII5CM7vzkJpNNRGOhgujJd1i/kUmoFo2Nj/DRFYWhHTZfn4/R+u9+fnKgfgUijdiCj+KefYaf8LXsY4qbk6huCkMTLY2V0niuLDXpd58jykEnzQxeP9J5a1xv76hHh00PkpqrKwTCYyRuwIObWxd3zNgVXHpBrwM3C
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261022105027099003)(261022075727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(921020)(261028144727099003)(38070700021)(11063799006)(56012099006)(10067099003)(7146999003)(22082099003)(18002099003)(7053199004)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?aavB/mWfITm6+uYN91VY6c2qkMY3tTWjXH5wcGE4319VnlmduNzub7+vXK2Q?=
 =?us-ascii?Q?6LFTIR48w9WoWCWt5QtYOEA/lfBaFEbHw7pdNAWXLMT72aL6BGVoxbQ4AZ2i?=
 =?us-ascii?Q?8/9yONfP2mNKVrxhJk2THxUPWD7enze2jltqDl+t1VHhzwnS9wzk0AjaC5xG?=
 =?us-ascii?Q?36LXOWmGht8oeP+nJ1ci8tCf1MVPr+vfWy0GLU29g7RatG+O5iReSaymeUP5?=
 =?us-ascii?Q?NPROiFYg6XipmwF9B/OKelAcpnte7Se7EWf4Y8AGk/yWZCb9In3mvQpklIxq?=
 =?us-ascii?Q?CPVpKw3tJzhYzLpoQCppYo7U/iLEQ9ulzRJScW6AUDaYcQXggT2r8pf6AgS+?=
 =?us-ascii?Q?gkrNAYHS9YKp5T6ObLB7XyDBA23zcEmOvEwxY02hIc3hb2k8283ek7sUTnuu?=
 =?us-ascii?Q?oyfBYxZ9+OAD+7L2hBZgP+kdB/OdbuXjTj3iRFUiEbF9/Lg/I2GtSunRrxu5?=
 =?us-ascii?Q?6Zv7EAQ03pghqt64bvBLI/OaUh9OGdSQQOewXiv0xaRoe1hln5QwgOw29H+D?=
 =?us-ascii?Q?yKlOLWYjlAvWokIAZG3jtX56IfeZ2K/KTjA9RAAPCV7TbQv3HL/F1drK/zvi?=
 =?us-ascii?Q?Sj4kosYyPvBT7XTgGxSvq4K7gcPpPsdZvGnP7DjD/FZmEYbtnaPJyxaqIVio?=
 =?us-ascii?Q?sqqKKGTztzP/AaErCd4qyrZWeAil7x1qTuSa028/Dk57WlRKjPylAm1JQeN1?=
 =?us-ascii?Q?vI7MZOdZtbwdZp1k7fhak43l5mo4ZiGP/DW8giEBroH3R8MaqqPyk5ll4vbE?=
 =?us-ascii?Q?IFgKe7XxFPEoTBGUZalSW6NEYMzFRKFpZ6DT6sdLwD9FkukQ/Iwsg6Lf/l6k?=
 =?us-ascii?Q?VOYYEjskZ5uoQ1Tpz9tDBzNIBMRexlojUOnI2mjp0BOhIyA2ZnU/4o12Vtnk?=
 =?us-ascii?Q?avlsln2DVl50bvVl95tPVGahOw6u8YjpXFijrQgPFXvXw/6wCaO78FHLhOAX?=
 =?us-ascii?Q?xV3rTOz9xk1fe13faBRW53EjZNNaztmN2qE4eVh8HYwSYDpgerju5sIElcVd?=
 =?us-ascii?Q?+mq9nT63jzBHu6253E77/z5aUZs6OBQg782WIOtolb0Y3RG9MDg6SRSUfZ8D?=
 =?us-ascii?Q?JMEZ3d6jiGhAkK1Egc36YH7mGEtStOGJ5+AMCs7zvUnoavLejTGi8CSiOAah?=
 =?us-ascii?Q?QMR2CBw5XqGUcaqaQWT4TR1JlR8ujI6wh0caUVC8i6xRndxdUvC0M+06DYrX?=
 =?us-ascii?Q?7jGVps14VXB6ZxM+oPzj6zZetPaaT1YkdyaC7KL+uVWZDk1Sz8+hiiYLh6Ig?=
 =?us-ascii?Q?VbB/14evG2uWRQgHxNAo7KlVom2D/R+XUtXZqC8yHT/h3fl8PEqKqpqSrZ66?=
 =?us-ascii?Q?greF1ktq5fjzWB/dxC/0s+VyXxxB8xCaL5QpZjfS0pX3gMJtAPz8ChLbHR4q?=
 =?us-ascii?Q?2nFd3d0oi+MeRlcEB4HDHohBNhnPxGSR/JxPfYMpVaxR0FglqKnGOq8a2hwq?=
 =?us-ascii?Q?ofBX4JLEYNKpDhp89eIa1aoQwpsU3y3CgAX98DO03zzagVNl8n4Iz6P1Iqw5?=
 =?us-ascii?Q?7nPOZtu6J2oRkTX1filqKJAcuYkYaRBXAyfEYdyY0rrAXfYDbn/I+Di+ziGm?=
 =?us-ascii?Q?zzTAwotSBWYi5j9CQKXk4iwwyxIc1BKk7QSoDoNcVFcF3dgG/0pTdcvT51QT?=
 =?us-ascii?Q?W6hCYZaXQcphsN/UWJRebmEd16WJ/wpIoP9G3rLbYUB/Nitm/iwf26eEyYyw?=
 =?us-ascii?Q?JLcuFqVoH/sin1/dcm1ArwwWalTBcDBblDGxizM0Ib3I71cWY6bzvWEyeOB3?=
 =?us-ascii?Q?6xfsNDQGhg=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: DS4PR21MB6867.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d802804-28e8-4e46-b107-08df4684c202
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 21:33:31.4327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9JRdhUOPxwM223nG8x4BGEa7RU20Q2ZGoEuIPCzz7O8VjE6gAX/h8zDE2IbPxjDXGnFebreKOyXsypYXQ+uTTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR21MB4965



> -----Original Message-----
> From: Sahil Chandna <sahilchandna@linux.microsoft.com>
> Sent: Wednesday, November 18, 2026 4:14 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan
> Cui <DECUI@microsoft.com>; andrew+netdev@lunn.ch; davem@davemloft.net;
> edumazet@kernel.org; kuba@kernel.org; pabeni@redhat.com; Konstantin
> Taranov <kotaranov@microsoft.com>; horms@kernel.org;
> ernis@linux.microsoft.com; gargaditya@linux.microsoft.com;
> mawasthi@linux.microsoft.com; kees+treewide@kernel.org;
> schakrabarti@linux.microsoft.com; leitao@debian.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org
> Cc: stable@vger.kernel.org
> Subject: [PATCH net v4] net: mana: Avoid waiting on dead HWC after device
> reset
>=20
> After device reset is issued due to TX drain timeout in
> mana_dealloc_queues(), hardware channel (HWC) state is non-functional.
> However, the driver continues to issue HWC commands
> (mana_disable_vport_rx,
> mana_fence_rqs, mana_destroy_wq_obj) which will each wait for a
> completion that never arrives.
>=20
> The first such command (MANA_CONFIG_VPORT_RX) blocks for the full
> hwc_timeout (60s as set by the firmware on the tested system), after
> which the timeout is reduced to 1 ms for subsequent commands. This
> causes the calling thread to hold the RTNL lock for over 180 seconds
> (120s TX drain + 60s HWC timeout), triggering hung task warnings and
> blocking all other networking operations on the system.
>=20
> Fix this by:
> 1. Replacing the sleep-based TX drain with a CQE polling approach:
>    disable NAPI per queue and poll its CQ synchronously, with up to 3
>    more polls 100 ms apart to collect late completions. Reset the
>    device only if sends remain unacknowledged after that, then free
>    uncompleted SKBs. The device is reset at most once per call, and
>    not at all if an earlier reset already marked the HWC dead. Once a
>    queue is found stuck or the HWC is dead, the remaining queues are
>    polled only once. This replaces the 120s drain timeout with at most
>    300 ms of sleep per queue. If queue is still stuck,
>    mana_gd_dev_reset() waits for device to return. The 300 ms budget
>    is not based on a hardware limit but in testing under load, the
>    completions still outstanding on a queue had all arrived by its
>    second poll.
> 2. Setting the hwc_dead flag after a successful device reset. If the
>    reset fails, the device may not have been reset and may still access
>    memory, so teardown commands are still posted.
> 3. Checking the hwc_dead flag in mana_hwc_send_request() before taking
>    an HWC message slot and again before posting the WQE, and returning
>    -ETIMEDOUT immediately without submitting commands to hardware that
>    cannot respond. A request that was already posted, or that passed
>    these checks just before hwc_dead was set (for example from the
>    gf_stats worker or mana_ib, which do not hold RTNL), still waits for
>    its own timeout, as before this patch.
> 4. Skipping mana_fence_rqs() and the SHM channel teardown handshake
>    once hwc_dead is set.
>=20
> Fixes: a7dfeda6fdec ("net: mana: Fix MANA VF unload when hardware is
> unresponsive")
> Cc: stable@vger.kernel.org
> Co-developed-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
> ---

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


