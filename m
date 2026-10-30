Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793399439;
	b=m4PrY7nwcK6xfk/BpbsRdryFlmZOxNoV6q6tZEAYHd/Itxgh2lk0qAtFBTM8dQZOFSPA
	 yyPOHhVegOuOvK+lA2PDqybg3gwxmF/oUtadqxBhxD6Aq1UmsBf1j5ozcQ5qW/K0lYMbK
	 ZV9aKpmW5SGTr7N6vgrtFeVNUoNytgQWDtIq3u2mNPro1G7YDVL/RI0T409KwfKMJ/z0E
	 L1CJ2nK1+c8Gtzu6Yh2p8qLB9ua9Nr4MMx0p6L4sH0ee6OgeGLsKaw/AwG715p0VbQsUq
	 nTeLi34PSNH5dpYUBszRvOuSaObTD/sdhshdQSJYg+jhrwEJdJqFdv5rb8J6mUdYpFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793399439;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=resTIy9F1RYH9LatY/q7encT6XvOovkAGIzwtkUbXvs=;
	b=P6y9A4uSG3ssWb2rdQvy4LNsWhOHjmjNDP2ZUBQMXEQtPvSWF3KHHdzzpqMPACNXBGzw
	 Nt8PtbVgSuBQTvURrtaGWyeftQY0rY2LML2ULP2kewckwi3sF6y2hGGLkEt+92Trojte+
	 3jJK55fwEQfA01Q69w6RQfoBWjvvKok+2xPniEir3iWGdDnsTfPUesXJTPENJQIsy7ZZR
	 LXINpEhFDOEjDp+nKa3N+Anhp4/hWsC8e/Nj7N7j8OfgWsDqpGV9UMjDP7jwFBOUEMEax
	 jYeKxYVvsIjW6hBzvOPWOcvBn99JDCMDKr+FrQHiF18HWtW7HMM+0B851XU0gkvc5cQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UOuDwy+Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E94E606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 22:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E94E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UOuDwy+Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793399438; x=1824935438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=resTIy9F1RYH9LatY/q7encT6XvOovkAGIzwtkUbXvs=;
  b=UOuDwy+YY9igguxwL2q431WiwGJDFIZ1Ux9pKtuxi79hYLwgcAGFEXEf
   BBxUQFjDR9kiXsRC4ihdoFTKMsRC5u1mcQNG8jyb2a/RySGuKdwrpICrU
   L4wb//kbkxyZZySbTYKq6/hyEOsKkfgGlVhLg795LakAqYQ2ypiDMv/00
   bwXJpMiWyVx2PVUxwZsZv72OhQB/ae4bqRv2AX5FlyQsomkLqfPaIngWV
   WVSDfWXPiBn2/+AFaIfzc+UcjvHmwZeLax8XU3k8PkvToSuViDCZV9tMx
   qWFPnx7sjy7bHGDpNBw9NJX52+pgTHHEwCtHmirJZIq7pRWHiy4fXaK1b
   g==;
X-CSE-ConnectionGUID: 3HNw+q2OSzaLwdiIKRKdIg==
X-CSE-MsgGUID: p8+EDxNlSNyoWTyWAPoqrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2048552"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2048552"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 15:30:38 -0700
X-CSE-ConnectionGUID: dGp/NBIsSIq0Gbh63gxbNw==
X-CSE-MsgGUID: mW7wUCbDRpq3u2alFb8W9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5933648"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 15:30:38 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 30 Oct 2026 15:30:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 30 Oct 2026 15:30:37 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.2) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 30 Oct 2026 15:30:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuBHeQSosVEz8ZYVSSaloT+h1OIRxqk4fBNmPiRtnOtW4tWwFx/Ci6U0zjzQkCRw8nhf7DdqvGtp4CX4kFNqR6PfY0NU/WYh3XAq8FqLcY5RLn6kb8CN9NjvD9LHjAPsTlHvh4jMRTsUhr7P4gMp/HtqLlnclAts/I3eMkvz5IQ8PKsh59McqmV/pxLtVot/6lwCrJbIBPLPBeGHNQFY3pk1i/+RVEL4ZXS7EgdjtEWJSr+nYU6NV1MVehKqMVbn609mp8wWEN5UXhWxGikjv3C9+fEx123MvqpoiuGj1DFHMEpqt4osnSdip9paiE5Z3cNaT2tvzduSUvPIysMoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=resTIy9F1RYH9LatY/q7encT6XvOovkAGIzwtkUbXvs=;
 b=Xki/j/ynDcvZD/NEoEroFIzjiA4YWEJvfZ/GvIQFM6v04h47SjJTWUv7A6xsRTIfPlULtalz5uczxth8wIZNHsS0KGNa8y5TTisL6ijYaCC4U4/0QaBEK7lTpgEF08wo+LOIrJUFBz4rhoAJETv1zVxPSxZIXuMHgLMu/eNcAVRd5I5EBQX3LMRvK/9oZbFFrwexKkh9CX3sX4lfcDgaGxeYi4Wah/83hn+fywdntBk2bCKGHyYgAmQ07Dy+pHhZ2H0ph+2luwF1xr6/2CqMOYfMlDT62VxJVQ3CwMnrByCEZJzMMUm2RvVjSyslws9Setf+J3bavINJHdWA9jEFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB8190.namprd11.prod.outlook.com (2603:10b6:610:188::5)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 22:30:28 +0000
Received: from CH0PR11MB8190.namprd11.prod.outlook.com
 ([fe80::ed7a:91e2:29a3:ae7d]) by CH0PR11MB8190.namprd11.prod.outlook.com
 ([fe80::ed7a:91e2:29a3:ae7d%5]) with mapi id 15.21.0546.017; Fri, 30 Oct 2026
 22:30:28 +0000
From: "Bhat, Jay" <jay.bhat@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>
CC: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>, "leon@kernel.org"
	<leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"Lacombe, John S" <john.s.lacombe@intel.com>
Subject: Re: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Thread-Topic: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Thread-Index: AQHdaJU6yp6SCjFzEkqochnanLX9Q7cWXmeAgABMrJA=
Date: Fri, 30 Oct 2026 22:30:28 +0000
Message-ID: <CH0PR11MB8190010F9E6956632029A0758C6D2@CH0PR11MB8190.namprd11.prod.outlook.com>
References: <20261030173556.1873811-1-jmoroni@google.com>
 <20261030175501.GF3889730@ziepe.ca>
In-Reply-To: <20261030175501.GF3889730@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB8190:EE_|IA0PR11MB7354:EE_
x-ms-office365-filtering-correlation-id: 5bf0dfb6-8cc0-49b2-9542-08df36d56671
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|22082099003|18002099003|38070700021|56012099006|4143699003|11063799006|261026140227099003|261022105027099003|261021121427099003|261009223027099003|261028144727099003;
x-microsoft-antispam-message-info: g/P1xbmEE0IQgwUtxlYd7WkGw6T2fSy6XXPPdRRMdRAo/MpBGLx86fRHuKa9RF3Giff4zcY9lzZ3mZExIYfCX2ivTqZ+O5AhI9PVFvuDIwPjYpCLc1R1vwvpXF+bIjDfOVy3jZ2BMU6te8wvHfcRqms+s5HktKCuYMbcrDk+AKZvvkl1QSIhsIEnFGIDkeqFW6ut1PVeLjbNgC4ojs8moqmN1HzMiBjvdAQr6xhq/ocEUmQLSK38ul2uGmm+vN68A3c2yoqRC5ymLoqfVHQzFEyEOlUm9OgccqiWCVmHmmKOgj5hihhkgvuXrId9lbeRpscETGAHha5r+qYE+jKIL0gpa4HiOETPTMClXKCYnl5hoM5d8C7stU4ZzoQLd1ntc9I7Ty/qzOEVHb8VFaRlYrofiHri5wfoRGE+SRwMSw3ccpzOpbD+jPG7iJCamqDQ1kxEQWnNbXRm7EmeOmITmNqN2QLKhgSw1fWde1kjucKWN5fQZY1Agv2RKYZmFXPd9hRnmPBA/RQBSHFq18BtaCxbYpr2YoQi/i9ZZgeH7UulXqgZqj0GapoB/4JrhHXM4VarMjUyUM1waJG7kD+WBxR9erzhRKn8ueWndU2zhG1tFQD8PECRpDceUUhOsxaJj2mQ9PmdZIs8dnpLsVShAPmbyJLA1W6Qqhnus8TYoJ8Ic4R0PylUP/b9j/XKsTeKKwOQKlK+QX6hzTV9x3etrX3O8ofAfBSXxeRQKdGmQmo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB8190.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(22082099003)(18002099003)(38070700021)(56012099006)(4143699003)(11063799006)(261026140227099003)(261022105027099003)(261021121427099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?t5M2qh2chhhxwQGR4vCLyAn6THNVRiVhDsC1JFGzf2Z1uR1+V2AcODNmH5?=
 =?iso-8859-1?Q?0wlqNwNPtYcYdWup5CM55lvYr9pCitjSFYZ3OZeARX6wQFeR2JQSuA1DOG?=
 =?iso-8859-1?Q?5jBvm6wYinlDLjasjCdONzSgjmaM5O8kMvGJqRF3BV7XgqjW5b62kgCASv?=
 =?iso-8859-1?Q?oweKKK9Rmo50c3NScQ12zDC1Atmnt3eNXdnAVyOIF9cnq+2NuKfvKdV2Hh?=
 =?iso-8859-1?Q?Q7bQ2VAX9IqY8oA9ZBdx30fpz+uVPZo1a/psayG88bbOPFzan0LhX65ESz?=
 =?iso-8859-1?Q?1qcqbC0R6GewfcVQn33y8WuWrXppJE57O92lU9JlDnuHqkpBXNBusOG2Ai?=
 =?iso-8859-1?Q?1ctA9xNYpMd73jeSMYB4KRuIic6GRWxW3PYh2iSSo4SLhX0pBrCHS+MsNF?=
 =?iso-8859-1?Q?OIPtvX+dJpaTveVNLY9/g5f10uZEI32Y3dFRdzZspATi/DjqmBE7Qcqt+v?=
 =?iso-8859-1?Q?fif5OC52f77jnp4Ebdz0j3H9AW2JsuRfzbWR3ijhNuRKgp+PtoF6mpAayA?=
 =?iso-8859-1?Q?rOfksEyBbGMey7S2Yfth+ivevcF1OU4fN37oeYzlTWVc5mkYckda8RgW0T?=
 =?iso-8859-1?Q?RgQL//sqdBjGrzm2hji4vDLQwA/YE3vLUThGnV21cCnLSRtISGEHMTvVD1?=
 =?iso-8859-1?Q?5g4M4PSrRcidJiMIyx+oNTPjsijLfWEmunrNM8zwXjayx9bluTcXlR+iCJ?=
 =?iso-8859-1?Q?6jKHVyu2dFjSv0CQ1KM557OOc4IpjHztiHO2GG8srQ8cv3BqO/RImqZ01w?=
 =?iso-8859-1?Q?xWDzckZfweenIc7vcl3tLgejlJ5wQTrQCa1mD9Mk5uhTIu1EnGXVXMCwAh?=
 =?iso-8859-1?Q?X6h5ripP3OtP/fkyIAyVNTwxEWF6hUpWTID3iHp2TVtER5E2q61WWoYoND?=
 =?iso-8859-1?Q?lMkDe9eGeLn70mYHfjIRMztscjHUTvDtJri10kQhWPF614hJvBZXV82Pc+?=
 =?iso-8859-1?Q?uTaeHfz51nPXX+naQ+f9oMiwuticaezeVr1G5Zcw4biG5T1y+W/1wpgJr2?=
 =?iso-8859-1?Q?TK3PGRd3pBHesbzR91WWXeHWNOsOBHY0ZGYla2kqC4eSLHxL4/A5tQ6MJD?=
 =?iso-8859-1?Q?nYuBOoMMwjVnxkfCbcHkayLHKo/uo3EK89dRjGNlQdGYL2KW5/t926lkoY?=
 =?iso-8859-1?Q?FIJn975c7ksopmDdbDK4LM7ryYHjSnT+M+w9uk+El7TuaHTnzm1EplrhyA?=
 =?iso-8859-1?Q?50LhrC7Rep2i+El9t+nqLpNmABUh2l2Oxcyfw0bTi4up9yTSUp5E1yvFFb?=
 =?iso-8859-1?Q?raDefOn6VIJE++PUtDrPBBrGnW4Av8YnSVETuW+5m/zil+zRvtEmEKdhx9?=
 =?iso-8859-1?Q?jC1Z1W2DeULtkkeln0rkTDw8/meIi6QHixoak7L4Psx7qovAwuQ3OIkCGG?=
 =?iso-8859-1?Q?434Beczivnx2d3jlF3Lms7TUrh2mpP0UuIl2KNG4gGIpMgGdcXjmIKx/Kp?=
 =?iso-8859-1?Q?C1/P7sI+nafRL68PSoj0np1f5Q6OsWBfteyl9xC2dSUbTR/dLozrAB8AMn?=
 =?iso-8859-1?Q?BCocqb82zAbDRHlEITyuepQgicz3flVAajVCD7AXt7d2Tw+8/1gHmylThu?=
 =?iso-8859-1?Q?48OJFe2iNggMm8yrw2VWewgjvvbtvuuv8kgXqxUbKIJH7TvNZHSIddD0ac?=
 =?iso-8859-1?Q?ysWDgryzClQQiWpKla+taexQiGFSrU7TMjcwxbQn8o5emdXa+A8CbRhyhv?=
 =?iso-8859-1?Q?FCBLXEFoNW2b6P7Q8NRMqlIq66gjOTc7pqNxvt7zgh2FKaKqs0pP38P7KO?=
 =?iso-8859-1?Q?9Mu6MUQfEdwXSSkanM4+UHE6clu9kt3n8sySMyPkyEZ6SI?=
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
X-Exchange-RoutingPolicyChecked: N0/ewRJ+817flLRadHWlkGJBsvAzQS531qe1CHVL5uhy9867l5Vt9ErZ7Up81XD/yzNv/MHeMREd2kkZ5MdptEVLcRp6CewmoLbyGBn9OJxVlRwDX9u3fTc+VC9lQKh3BRFoMsMoDhXrROvPRwEP5CI0K9P3C3jjBizkbvWELAPpIzuZ3qJ8aeLiVr/v1SyzlYvOVAAI/jtd/9PoEhkqrieXwKRBtWPDTTHNVVebRGV4tsaFWzr5ZGixzB2EdQW+iZ2aX/bf6eBGhR8wp5kz5jmr2dLmZ//kN1l4WCXS5kSM1D7G3l2YM9yaBkZ53kcu84cGQCHKc3q0SePbUqQ2OQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB8190.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf0dfb6-8cc0-49b2-9542-08df36d56671
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2026 22:30:28.4537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qnsydNkcXWUIGZ2WS+ovndYRqzue8lR+cOEQthL+eTRfJs1CMkq+UmFzNp7LI0lJ5d3TN+FbZsqOYJ56gTOOxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com

Ack from Intel as well. Thanks, Jake.=0A=
=0A=
Jay=0A=
=0A=
________________________________________=0A=
From: Jason Gunthorpe <jgg@ziepe.ca>=0A=
Sent: Friday, October 30, 2026 12:55 PM=0A=
To: Jacob Moroni <jmoroni@google.com>=0A=
Cc: Nikolova, Tatyana E <tatyana.e.nikolova@intel.com>; leon@kernel.org <le=
on@kernel.org>; linux-rdma@vger.kernel.org <linux-rdma@vger.kernel.org>; Bh=
at, Jay <jay.bhat@intel.com>; Lacombe, John S <john.s.lacombe@intel.com>=0A=
Subject: Re: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma co-ma=
intainer=0A=
=0A=
=0A=
On Fri, Oct 30, 2026 at 05:35:56PM +0000, Jacob Moroni wrote:=0A=
=0A=
> Tatyana Nikolova is currently the only listed maintainer of the irdma=0A=
=0A=
> driver. Add myself as a co-maintainer to help with patch review and=0A=
=0A=
> ongoing maintenance.=0A=
=0A=
>=0A=
=0A=
> Signed-off-by: Jacob Moroni <jmoroni@google.com>=0A=
=0A=
> ---=0A=
=0A=
>=A0 MAINTAINERS | 1 +=0A=
=0A=
>=A0 1 file changed, 1 insertion(+)=0A=
=0A=
=0A=
=0A=
No objection from me! Thank you for volunteering!=0A=
=0A=
=0A=
=0A=
Jason=0A=
=0A=
