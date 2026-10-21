Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792581656;
	b=AwJk+K6MpellWz6lQMoCqIsf1grne+OQkhjOtHbgU5K55jGlVAoS3Xo9ej95jexz9T8W
	 Ss41YCCT4UkfgbtPX/FH7awXF+DrriCH8QC5s7ZaFRUVM0DcJULyLjslyuFaq504VNTk6
	 dvyCU/hzmBCdZdaKsvG4+gOCamK2I5vKwIFf4OIpyceMoh1NCRVM/oJEMmJAJ2Cp04FIx
	 jH2R5B+Jn4Vw7vaE8oILgVOKpdRto0hjkVpb5gW7/LUz/YLa//XL5HTHXf7tLvlNB/KBM
	 QhMyoTHUJeOuXgAcrAjlnrPcRYjh4XWuYQVwyeyz/yqOIl12Y5Fr36gF8TvNg8X4gFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792581656;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ld-processed:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
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
	bh=apDxtG0LsfRBAYG1fhqlDrhnE1TJe0Oe8aukwH8aDp0=;
	b=euMpRLCx18Ai9+m7LutqgcAqhs+yEpul2agvzbidfR9ozG/cu+nqNMO4UWiRnWGGbAs6
	 p2akBx5ZVuBNVvwsDenqFc5FIwjaUhgMqWZxMb6ga4JRIsaX5LC38O8D2Us6wugLolFCs
	 j1/OpsIs8HEYYESkkWZcmtQa+24uyg/f9asHXMVqqMusT1ssDGuGQd/R4tUXLQINrNvp1
	 4Qpn/VWRcF+AAOMLeqi6ybg3qToSuFhxt5rzzJJGhc0+1UM1OqKr1JF5BzKf2L0WiNg7A
	 /ru/2kBQclHcKf5tC1V1W6SKoT9pf5r+xkwZDTzKVtCao58r5hwZiJ2iUf7wMhmD42g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Taj6LMig;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59951606A31A;
	Wed, 21 Oct 2026 11:20:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59951606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Taj6LMig
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792581655; x=1824117655;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zzi6oDIzzzJ4SlVAWUgAG+Q/tldkwsdqP6dtrMwNeQY=;
  b=Taj6LMigkOl72q81gOXktMiH5Jw4O6d/mSAvGmah+8RgoJsSJFtSWnho
   fRIbH1q7SAXBw6fjfhveUiu5ag37GtZzz9c8Av4byQwymiU6otj1AFloB
   /KIbfny8M0ctaoglGglr9yx4cPb/CawWaivf7nh5BE8UlIawOuWtcRDN3
   EJWnSTuXg5f1pSZ2wFYPWHh9hiY51752cYaHM5WBfF8HU0Sus5cJrPlrb
   w/RNuRxO65t7eC38WeFuTSbDqe2qggCdKQhLWeKcmGLuBn3oTMjFR3nSq
   XCzpoZaAJEEcLDzrSiiI89hssh5Wx+c5MgPyFyIsrjqMzBvWl2hGdz9Pj
   w==;
X-CSE-ConnectionGUID: 2pAkznrKR5GS+6fUjEtIqQ==
X-CSE-MsgGUID: lqNZ5H3hT+OEr0ejIMvgug==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1320290"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1320290"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 04:20:51 -0700
X-CSE-ConnectionGUID: SY6xZjVwRfK89mXU8IkISA==
X-CSE-MsgGUID: eNleYNrHSqmxzTNNRTaqlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="3393692"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 04:20:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 04:20:50 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 04:20:50 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 04:20:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgYVnkLQw9lirbtJfpnWFccga0vgTMCQ58lZ3MUzhkJCIbH9BDDsXBsWjQ91Iy7DCDc9vfCIG2zJdCwr072IMSg5r/LyzF9n5iRAflq1WPzCj3xaPQsqpsCcfN63e5nVKez1mBwu8aHHGdNEL1BjDlL/A7fJEheXpJAJMOx1EY7AsjZf3QqaX5i8nm8ywnQyQYRRopnLZEmruQoYBKL5zkE+qW+FuW4a3Sk3ylTlO0Flpz4XpLhI/wsBwZv9JFhhymrgpWA8nqp4Ec5lJnAfd6o3O95u6VvCB3FehVT6cAYZ636wlsNq4DzQ6WQtkW3UyNfmrjrqWoQyJwUB60vSSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apDxtG0LsfRBAYG1fhqlDrhnE1TJe0Oe8aukwH8aDp0=;
 b=Jm9VbhppIZNqvlMnt/UMPJTnqOUy8pbfsf1N5JWhcRiy+JykF5lfueqM7VqCFDMGCSP9G3xq8a7DJDQaThOfP0deUbDBEFN6BwWSkscpWR9H21wC+/nYgtSnKQjbkd62js0X9x/6uFBS7e7CELaVaOUpIiwoA15qxlZtmpsaRiTvvy1xEtPTXPB5rjWU3cv6QuMcc3FniuzqItcm1M2RLFd5OVTay7/hxCLPTNJwmkzDjb33EnZcJpLM0xU+/wLuGIWB6gNFnJLnO2YcqCCI195rW83GeeDv9GUbZWdTq0IiZEmKuUOKf+CNT8fkQUmd6TK+/hFEjVO+E3Ct2/g5jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 (2603:10b6:610:34d::22) by PH7PR11MB8549.namprd11.prod.outlook.com
 (2603:10b6:510:308::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 11:20:46 +0000
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584]) by CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584%7]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 11:20:46 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: "Oros, Petr" <poros@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "Oros, Petr" <poros@redhat.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S
 . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Ertman, David
 M" <david.m.ertman@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Maziarz, Kamil" <kamil.maziarz@intel.com>,
	Rafal Rogalski <rafalx.rogalski@intel.com>, "Schmidt, Michal"
	<mschmidt@redhat.com>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	"linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>
Subject: RE: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the
 RDMA auxiliary driver
Thread-Topic: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the
 RDMA auxiliary driver
Thread-Index: AQHdX5aQklaskxUBMEe+InjmVE4GX7cH3JUA
Date: Wed, 21 Oct 2026 11:20:46 +0000
Message-ID: <CH3PR11MB566895C406B00646530A5249C9E5662@CH3PR11MB566895.namprd11.prod.outlook.com>
References: <20261019065301.3983537-1-poros@redhat.com>
 <20261019065301.3983537-2-poros@redhat.com>
In-Reply-To: <20261019065301.3983537-2-poros@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB566895:EE_|PH7PR11MB8549:EE_
x-ms-office365-filtering-correlation-id: 31f1b376-ec94-4890-74a5-08df2f655a6a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|38070700021|56012099006|4143699003|11063799006|261009223027099003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: ukLAAyTQvh1WSHC81u6HMNB8iNF5wdnM1vmSuLpaRuLaYjVizlppFCQs8ddL0KxcES8ff+uh6dmBIDu7x2zZPYOZbE5o/l/yeX13lwznBrBF9pGWTSJuSEqzsbckUGbOOwxirtNd4bQ/2T1rR2IvY2N2zFyVmuDAu1PvWRn+j/JRjcx7YKnq3PSFKFARJ8L7XXZEGCzhY8slSTgHxuqwO44a4pw1/WB+lVxnmDY+5SpqGBzbEsWpoOw4CCo8sNpYbFFzivoBzmT3ZPBC3iVR2dCFFQm0HThq43CzWGRS1A2VUTjvSL84XvKIsL4rNtLhLMpsoSZr+4JODbqJWJJbiA5urHr1VFR9oJ69kpiDyA6DaELTmOrBMoXwE2YGy3Hnvjy/NpIRUkHS2bfLEk0iV6c5DJM9pexaXSe6oV+45G3a9HChyLDbhMwXGO9AMQFvAEPC6WsiAkE/nnIQMs+zYQeUv1Z2CY4idyPzQJN7m+QFFcRsHI9OdIiE6KHCin2uy4qs6ZkrvnK/TDhkupWlnpgISvdJ4rd3mU1YydAGpRh6Qi1aWArMsMP3AuCRhJgC5Eo86KW6/ZxltYq1DYpmZzrSqx55aTPieFSU2DJ+OFG11LIBXdVh7odBAyGxJbOHhxbeOh/KgIQWRMpb467UNlUelF3x0rYqmptwVY49LOCpfc86p+mm/CzFc8huGJqloOzbReuBud0uFC/f9LUBKTJsB9iXCRq0GfV0I3tJeGE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB566895.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(38070700021)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y3uj4+g2IP53rhFVTo8ZLs+L9Iz6z4rMgioFc3exGWt1fknLuR9JlnjnPFzr?=
 =?us-ascii?Q?1wG7XuFDNxdT7HoyblbZzA15CNENaOR2p4uFWLRzBn0KKdeDYQpDwg2ge2g5?=
 =?us-ascii?Q?OVBS+Q2xED/KZ/Ksu7O5eC6ElPIPvfGzYyhFnO/AiTGPjK28V1QZksrmm8AP?=
 =?us-ascii?Q?i4YkAJ/Zpuq3d6EGFOJmiH8p44k5hXUgEr09HKwKKcxFDImI/pPfs6/p/hKr?=
 =?us-ascii?Q?6YPrKoVU4EwxZ6ESVTjsfwUiQrn/7p+0/W5SaBSnoGtSw7QbAuTurehTqTbG?=
 =?us-ascii?Q?wgQBfjR/ahFXsiaPKraQNfKjrv0y80PcX4Tu92cubugHb1+VcH3W+FL2fWgU?=
 =?us-ascii?Q?k/B1MCtAx1CoP9uO+KZdvmH9AtiwMTcIJMbyWnBNRoK9tOUuN8thDxe7NTiF?=
 =?us-ascii?Q?ACK5Na+D9nfT/VOnbkROfHU4imNARcBLK+ZaHmegLf8zZdXWK2uxbyDPC8G2?=
 =?us-ascii?Q?NyD4RAF3sugMjszWG8+64PdvKpJ/JoeIa54fAmmOuLaYy/GM47maWS4UMSfH?=
 =?us-ascii?Q?PJTiSciqNC11Vk9I4IodAPfAUfs+aJGfdZ5VhG6x2j9Oic8aebVeSr3hTxTG?=
 =?us-ascii?Q?B0mOX6R4/ZLnIAUDw0OXxcb5BJsakZdAEA0gNsQmJilTSxkUjrUi9bPvafXA?=
 =?us-ascii?Q?nj9l75VGMbhdnOAFYtRFEsjznd+bPFtxKsiKjVRDUVuYrvrYRA+DanGgmUlj?=
 =?us-ascii?Q?b0zPPGy7ISPjPoiaq4l/CheaDxQojJ855OCBsDLTzvoTCIw7D7s6u0hHTNn+?=
 =?us-ascii?Q?3Yo2OgUAiQzgcYeEFGV1w4rMHsfVq2r1JJZJyPtvQda8oVRxA977909sl0S5?=
 =?us-ascii?Q?w8txDt/7cPRBrTypbAzhHgaDChnwzxR+2E3VGVU7cuxhC+WlPG/xIb3osiY2?=
 =?us-ascii?Q?szLIqLwy/i697I+mg/lVS4+y6SfGjoDlUGl6Rj0P/oqwPMHUZKi+wHBXywxq?=
 =?us-ascii?Q?XYeVvIxyFUHUQuEO60NYWwTH8SKkl4ouX82evIfe2TFBVY1ZPF3tIBCpO3LK?=
 =?us-ascii?Q?KI1cpC2ypshjAEOqaeKT00t2WC3HMul93M96/b32Klv6+DZ6Cxf3WkZhn1lY?=
 =?us-ascii?Q?NFPNuq3PcI/oR3gUQ2RHq58Tyt5uPjM4B88GPy1cO1f7chV2+Vpla3jo31y6?=
 =?us-ascii?Q?OZ+tLSK+Ub7/MKHo+h9LkkPilZAlCDwJAtWGz1iMWywHFwqJA65m59AkRae2?=
 =?us-ascii?Q?7afrbN/9YMrv2+2CYYr+Hs8FcBonal4nwm85msJ6QAqRgTMTbaavmzlitomg?=
 =?us-ascii?Q?GOQy9XXl9SzjzttUe53ogVEhpMkC4x/y4LPvrQ9IQ5qwMRjyvquaOkyUz1nx?=
 =?us-ascii?Q?I9NXzzrtvMxsHXwS0K3zFFdYFNwvLpb/onmSx2K8wMIdDtdeKykuciGpiuLk?=
 =?us-ascii?Q?cX+ULPjRb/2TVMNeOuObJboMPFc8ShoOHjjY/xJUVe68I/p1agffogKYtKYb?=
 =?us-ascii?Q?IfMPzqUpIdQQshulKYGyOlBHrxPg5/yhmOG4/M4feELhjwU18Vd3ZNsyJxm1?=
 =?us-ascii?Q?nXOPmgd1Js8xdFwK99NQWR8VXo3I8KWIQvsja7r+D+tURqzCyZzWsOqRW+vH?=
 =?us-ascii?Q?4vET9rKB16bgLF1lyXz6j73YZN2Fdkxi16YrvZQoYBJ+xpy/AxgpOADvUpQb?=
 =?us-ascii?Q?aM9HmugCTQemzqiEASx/OUY6re4TZkEaAznPecmf5ObrE2W4WFBJC4XGN76E?=
 =?us-ascii?Q?jP82A4IA/O7OuIM8dRSCQfT1GRQI7+0SxEni5JaE5nIkUESVspYc0GX62Sjd?=
 =?us-ascii?Q?AfF1gE5Ar21eb8HGVe/jnzUQpTPNeGY=3D?=
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
X-Exchange-RoutingPolicyChecked: iTgqxHbWIq8Hhag80fQ8FPFY6eENcdyWruDSYMc1VomGKXF730IrITGuTckP5Lfv1gEi8Kg9ZOrYyc8vuGw5HAGPlhZGzTeK+y3k94ieQr+1wxFbcbqmprJIvdSC0eqwQ3EHSAJYgUVxwNR8C7ZkqAry8ESdRTj+MuTUcMQEmQTpqhmKz59/pAuxDftEJTnW0KhvosgJBLD9xV4HhVWN23Fd4pIA32XBzmui+MSChed/PmHWdW8fpQGMf/UQfKacrKFi/YtSB+/+f0/98Hu56RmYCH+3VyRqS+azEncbF9klDAF8GpbLKBLZzdp9t2u8Zob2rLZS9cG5kFlKnd1ceg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB566895.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f1b376-ec94-4890-74a5-08df2f655a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 11:20:46.4662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: foMhF8q99/8qWltqSMvDmThzSq7EyysnQ36tfjZrsRZc12J20FDPBLM0FzDgIk6RKpKgMt5CXlGKVepoGg3qzRMGeKmxVr06PiEDS6bwGho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8549
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Petr Oros <poros@redhat.com>
> Sent: Monday, October 19, 2026 8:53 AM
> To: netdev@vger.kernel.org
> Cc: Oros, Petr <poros@redhat.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kitszel, Przemyslaw
> <przemyslaw.kitszel@intel.com>; Andrew Lunn <andrew+netdev@lunn.ch>;
> David S . Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@kernel.org>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Ertman, David M <david.m.ertman@intel.com>; Shiraz
> Saleem <shiraz.saleem@intel.com>; Leon Romanovsky <leon@kernel.org>;
> Maziarz, Kamil <kamil.maziarz@intel.com>; Rafal Rogalski
> <rafalx.rogalski@intel.com>; Loktionov, Aleksandr
> <aleksandr.loktionov@intel.com>; Schmidt, Michal <mschmidt@redhat.com>;
> linux-rdma@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org; Sebastian Andrzej
> Siewior <bigeasy@linutronix.de>; Clark Williams <clrkwllms@kernel.org>;
> Steven Rostedt <rostedt@goodmis.org>; Mateusz Palczewski
> <mateusz.palczewski@intel.com>; linux-rt-devel@lists.linux.dev
> Subject: [PATCH iwl-net 1/3] ice: avoid RTNL deadlock when notifying the
> RDMA auxiliary driver
>=20
> ice_send_event_to_aux() blocks on the auxiliary device lock, and the
> dcbnl callers reach it with the RTNL lock held. The RDMA auxiliary probe
> takes the two in the opposite order, because __driver_attach() holds the
> auxiliary device lock across ib_register_device(), which needs the RTNL
> lock:
>=20
>   systemd-udevd   state:D
>     really_probe                  <- holds device_lock(&adev->dev)
>     icrdma_probe
>     irdma_ib_register_device
>     ib_register_device
>     setup_device
>     irdma_roce_port_immutable
>     ib_query_port
>     irdma_query_port
>     ib_get_eth_speed              <- blocks on rtnl_lock()
>=20
>   lldpad          state:D
>     rtnetlink_rcv_msg             <- holds rtnl_lock()
>     dcb_doit
>     dcbnl_ieee_set
>     ice_dcbnl_setets
>     ice_pf_dcb_cfg
>     ice_send_event_to_aux         <- blocks on device_lock(&adev->dev)
>=20
> Everything else that needs the RTNL lock piles up behind lldpad and the
> boot never completes. The probe side cannot be changed, so use
> device_trylock() and report whether the event reached the driver.
>=20
> IIDC_RDMA_EVENT_BEFORE_TC_CHANGE has to arrive before the traffic
> classes change, so ice_pf_dcb_cfg() refuses the request with -EBUSY
> rather than run it behind the RDMA driver's back. The critical error and
> MTU change events are sent from the service task, which consumes their
> pending bits before sending, so those are re-armed instead.
> AFTER_TC_CHANGE keeps its fire and forget behaviour, it can be neither
> refused, the hardware has already changed, nor deferred, every lock that
> would serialise a deferred delivery against the dcbnl callers forms
> another cycle.
>=20
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  9 ++++++++-
>  drivers/net/ethernet/intel/ice/ice_idc.c     | 20 ++++++++++++++++----
>  drivers/net/ethernet/intel/ice/ice_idc_int.h |  2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c    | 16 ++++++++++++----
>  4 files changed, 37 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> index 0bc6dd37568792..2022b46c990cb2 100644
> --- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> +++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> @@ -355,8 +355,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct
> ice_dcbx_cfg *new_cfg, bool locked)
>  	struct iidc_rdma_event *event;
>  	int ret =3D ICE_DCB_NO_HW_CHG;
>  	struct ice_vsi *pf_vsi;
> +	bool dcb_ena;
>=20
>  	curr_cfg =3D &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
> +	dcb_ena =3D test_bit(ICE_FLAG_DCB_ENA, pf->flags);
>=20
>  	/* FW does not care if change happened */
>  	if (!pf->hw.port_info->qos_cfg.is_sw_lldp)
> @@ -406,7 +408,12 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct
> ice_dcbx_cfg *new_cfg, bool locked)
>  	}
>=20
>  	set_bit(IIDC_RDMA_EVENT_BEFORE_TC_CHANGE, event->type);
> -	ice_send_event_to_aux(pf, event);
> +	if (!ice_send_event_to_aux(pf, event)) {
> +		assign_bit(ICE_FLAG_DCB_ENA, pf->flags, dcb_ena);
> +		kfree(event);
> +		ret =3D -EBUSY;
-EBUSY doesn't match to any ICE_DCB_* constant, are you sure you tested thi=
s case?
It looks like it will be processed like ICE_DCB_NO_HW_CHG i.e. no change ne=
eded, isn't it?


> +		goto free_cfg;
> +	}
>  	kfree(event);
>=20
>  	/* avoid race conditions by holding the lock while disabling and
> diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c
> b/drivers/net/ethernet/intel/ice/ice_idc.c
> index 102d63c3018b1f..7fd35ce966ea65 100644
> --- a/drivers/net/ethernet/intel/ice/ice_idc.c
> +++ b/drivers/net/ethernet/intel/ice/ice_idc.c
> @@ -34,30 +34,42 @@ ice_get_auxiliary_drv(struct iidc_rdma_core_dev_info
> *cdev)
>   * ice_send_event_to_aux - send event to RDMA AUX driver
>   * @pf: pointer to PF struct
>   * @event: event struct

...

>  			kfree(event);
>  		}
>  	}
> --
> 2.56.0

