Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792581768;
	b=Olu92YhfwRhvTyhGm+0U5TjT9XDcln92rWzjqrcGg46f0kac+uiw+3Rf9WwHLRo5+yUB
	 0PznUWVXv4+MsOVZCZ3nbxQnqbzX6OGdOQ7sQW11ZX2gsHTjxm/FSYBfq1aM56kaqWFM1
	 HrgkXS9xStyABhiHViH+vA/tm5M61VOmPuDWVyLuzts+8m9r6wYSlr86R1XwV7OkKXKhA
	 8ZJYlhCxVVjC6FRhNIakT1EAL3R1aNQIlfwuvXdcUjN7u/FOTOhp1UVRJNm7zx6/q2ss5
	 +yCunQ5h2cZisAg0/6s/0SmsrCWtmkscnpKuhYM8MohQJUHZo9GpoGOUiKLUdTXHJ6Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792581768;
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
	bh=QirMFq1vSO7/XYJQ3ZZHkphib6vGvDhieS96H4njS0A=;
	b=FUhHlJ5hWWFJhoHWtWq5TsA+Kv0/DJ2wkhsmuWbYCabvwifJ/msXySqMUJnVOafqp5Tc
	 kibCYGMrt9VvJhkGWRFp2rJew3gbeNhJRJjuzU1B/EvzAj/UWxkh0VKgNjw6Azvk5yymR
	 HxtBAgAgfgWzkVKgToj6vlyhO/gk026FQGpKlqGwuE3j/MGoABnI0HF+mbklbcebhohA3
	 tTAjq4iWJnCWqsri3H3OIUSYomFRRpoHLhXFUhKsmLmn9uCqadyn9gOB1LQQNKBnWRMhG
	 hEQh5EMfPQBkZev+bFinTWXLqk0pK4s+ew44xRTlAWGUCaW63rVakwpX2eAAGHVDsCQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nmFmtrEx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E4C606A31A;
	Wed, 21 Oct 2026 11:22:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2E4C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nmFmtrEx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792581768; x=1824117768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hnlzjverBfQQ4rjq1+hOi0pQU4SfO7//PCQ8wSCdlZY=;
  b=nmFmtrExCeiQvCG6FT21NZCE8Ffw1nXnEZdr/OF3KmnfCVadRakVd51S
   YnUYrMy48EdK2x05soagzxAFlpinZBFPgVGKb/XiBNdZhR80XcIntJ8RJ
   oLXM3Lbw68bg6jK8Y1tpgMvssLD5n21uk1L5pQef7VIV9RJhRSRVFYHHz
   gU5QgEckV7lrRAm5dxqlWKSZ/cjSqWo9jtRxTK0s6R4XRTP/5V7K3UQgr
   FTh1zPMKshUHWznvAMWCGio9vrXtqp3waf0M6Xd0Khcx1gryd/L3QzX6Z
   QeNjo1eRB732vLWdTILbuONwZgkgYHP18YCtldOBb5UR2WqNR0COd6cy0
   A==;
X-CSE-ConnectionGUID: m4jN2eGmTzKrMcv/MHTFLg==
X-CSE-MsgGUID: RwIuJju9T5CD8nVwSAQCCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1191661"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1191661"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 04:22:46 -0700
X-CSE-ConnectionGUID: 6v5NiwLkQcyVM2+FU1AVDw==
X-CSE-MsgGUID: cE1KZNybTjOB7Ej8Ho0H+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="3407425"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 04:22:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 04:22:45 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 04:22:45 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 04:22:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dd4g+MIO41FpxcTo6iSoeLUQnpluZ8QNIG8I96ccoZsqjVx40NApo6hJfmBMP/OfqY/auBNW1QmBkpyJhd0A5UnoeBKOP/4Dk59sC8eJy+i+BIQhFHU1qTITa723LKiTJcdDCKo6YyTnDEnMAZtwE+jo6wP8qlXaWxiLaAxpdwSvY0vlmzplkh7vT9OOm4SMhryIFxy7QuTgdhruM5zX28htHZvxTlqV40JFUXo/ch68TETGXmcLWBpgL3V9b/QaUn5o+I5IJ9/jHifILfH7/PyxKKYsd+i34shj8sFsurBrbkzIDlu5//Xxw6uTzhSK5e79Hk8LKML2SwrA2QkzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QirMFq1vSO7/XYJQ3ZZHkphib6vGvDhieS96H4njS0A=;
 b=KcCQK5KhgHv210Lqj0FxoR4x312ckibAjBcHUc4CGg77cQ1XOxPe3BktWhhJxhaA65w1ar70ywsz+f70liLXuji40+K5FUfmdraIxRsXnSbJ1Wkv+Eet0ybWwokn5KyMOsX8IE64D6hiP20DIqS/l6Qgm1YpiU3saiOWZZyaWNM9OLiRtgpHdDgMuHaRSHqu0dO7oRnVwW0W1AImx9mCZeVuovvfmZyliwQX+HR81xAEl1vWaZUMJnmDQV5ipTOPd9n4+qtn7NGGeOhvOYpaZCbHR2qL4NfpnxHWTvsBbDUHkufYEWVdPwY641q5zZOpt6yYHcs1hjwFa9GkXRrBSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 (2603:10b6:610:34d::22) by LV8PR11MB8512.namprd11.prod.outlook.com
 (2603:10b6:408:1e7::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 11:22:41 +0000
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584]) by CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584%7]) with mapi id 15.21.0546.012; Wed, 21 Oct 2026
 11:22:41 +0000
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
Subject: RE: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in
 ndo_setup_tc
Thread-Topic: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in
 ndo_setup_tc
Thread-Index: AQHdX5ajzo293ziltEqeFtrtBEK9U7cH3YlA
Date: Wed, 21 Oct 2026 11:22:41 +0000
Message-ID: <CH3PR11MB566895E0410B0694F734EA7DAFE5662@CH3PR11MB566895.namprd11.prod.outlook.com>
References: <20261019065301.3983537-1-poros@redhat.com>
 <20261019065301.3983537-4-poros@redhat.com>
In-Reply-To: <20261019065301.3983537-4-poros@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB566895:EE_|LV8PR11MB8512:EE_
x-ms-office365-filtering-correlation-id: 1c2e7e95-9226-4a11-eb02-08df2f659f10
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|22082099003|18002099003|38070700021|11063799006|261009223027099003|56012099006|10067099003|4143699003;
x-microsoft-antispam-message-info: 3ZWlmE/WttOKlW7MR692XgWP5L2QbYnd/k58jt5yk/bA0rJ09sE+xhD91/hjyOjeWqXPEYpLNaOLsFYs9d2d7nexS/dJVgfdmc1EJhCJDyP07DRCNbMQ2TXzkK/fGscIIc67eD6/spzXBD1NpaB2j7QPoHOU8QYdapRjL827llbJFj6wAMdZcUxp85rpNlkBaLAY2pNHulrTHodjX3fbonYbGODEITIpoaqllJpntNo76kUAen4sIvVLx5dYE/bYYkK7RQZhDL+kwwrLFJKMZbPGQGDt3l+Iv9CNF50hG/+LXG+1mL5BeUYNPgakhhZsR8gjtUk+PTYOaiGKyEYq4bJ1hkY0CenzdxZ88Aq4nwD0zk3YYVAzHsHL5QLC1IcOzcH/xoZrn7h+MQM2xEhs3UZB9LjZKiOChUTsaFTJUBo+t+FqIOm1pqCuQgdnUpuzKRszVWVDIMs2DgYeqRrA93tB7wf0nVEzRAZe/VHMr3wj2o/d2qhKv/eCRIHGAd/Ji880vnuE6zNVo+tinqhZu5psiMuPHXs2qLhRcxM+27wQ1mcnEc1W4ROyL4O+/Z+b0cxN7jdKZMetbBICfw3/pa4cdwOsbEGNXUcEXm0ZoThzmBI0gSPQV58ltPxgRFQv3SbB+t/2HUpJpPksM7QHrwsb8msqrg3lvB4NSg05E3V5VES4Ae1jJFvlUQFUdaXCHCYf0lFNIYK2A6x3Zs7iiGt3dyE63h5gf4mtV9hehGc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB566895.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(38070700021)(11063799006)(261009223027099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p//+7SFSgUh/WCKI4aGC/f11YInGJeTGk4CMQCoPX4mA1/8l3gB5t/vP80gi?=
 =?us-ascii?Q?DWsUGI+WVcIEYPcme7fTuWD/tf3AmfmZir9iXokKDPm8Dap+9ZmPrEGwB7Ao?=
 =?us-ascii?Q?2vT588v2osuKT1sIAy7JqcsoVMDGMw7tKGbLEXT3inzesYZyC+H9GkOpmLi8?=
 =?us-ascii?Q?DYL69z5Yy6vfR1D0T9TxSOuLxBtnG37RX6n4abqGhYIVeZ1mC95g50mmVQZ/?=
 =?us-ascii?Q?Ow60Qefj8p2Vtv9XDdfe2pQdQaYVcqkhBs+fR95p3qzw8a3XJGWv6gcppLNZ?=
 =?us-ascii?Q?cDsPk+gNkbAehVBYfGgdnq4Rn2DHTA6XRHy9W7Ei6cSP8oayf6ZsytDmUi1c?=
 =?us-ascii?Q?PxbSHSjXGiwTgOAD7Np8YARYesMCnDysofk+L/tstFrLWamfBqRI2QhVpsCX?=
 =?us-ascii?Q?iUt6YNrQy+JVMf5JnoX+LZAeDpjmfeJhJ1VFgbOlLVFoJatnbNW4STcXKyjm?=
 =?us-ascii?Q?qvbY1R0/l3hdww4WzD5TghoijIZo/PdkaL7wNrfaOPSH2Kttm+ExuSrnjTXF?=
 =?us-ascii?Q?1l9Luw0nzcRBBpot7kWtLdf2EcRLq3q5LOOTgQNHpKAq37PUJSq1xvAbt0c+?=
 =?us-ascii?Q?Jz5Qq0TmqUz9IkOeEa1KxvCV3MMRhVzHygrghz9nxLFNORdIDtcDAEMfbsdx?=
 =?us-ascii?Q?AiLF6CMIqRoSp1Bo7BTl3lVjJZIdTKHITonyUHKN/ZqHurERIpfz5ik3g8Bg?=
 =?us-ascii?Q?rJZGzgdNS+8OJOyc27aG1BQ/SaaGiqGa4ScsaQ39XIptR3A9TLAHrwoPNJWC?=
 =?us-ascii?Q?dthudP+B5OAxN6xcntF/bgM+iTZz8ZBQZuUTq0J+tTYU9OLdfSe8KmIVJVO1?=
 =?us-ascii?Q?E0k3MjmzishvC7QHMyYGR3rse7/ApT6YUPw9v8ZfXMw/xUEQr6CAJgL2IA0+?=
 =?us-ascii?Q?Batre8BrQySGnD7lPRwtY/c2XQYNR5zw/bMryFszPL8HR5PLLoSnM6QxuXGN?=
 =?us-ascii?Q?/jx5BdVvuwuo5u2vQVfRqx8Li5csZinW8H7tFirvvh0Nrp1s8ZFKV/B1aDus?=
 =?us-ascii?Q?g8v5rRiqiJtuSRo+Q1fD83S7eHQ+8W9pff3t9Jc1muRdjHENLdAmpKJGV4B5?=
 =?us-ascii?Q?B451hcx4nbeodrSAQHtlzeMzAsL6EQfmgdxmJ4xOLFHBsJ+txS2PqCw1OpwI?=
 =?us-ascii?Q?x4y+aXfoXmorYGaQi3eoo8t85tPDp+NRFWE0Zs3rC/4tnIIp1GWWVtOhxSDH?=
 =?us-ascii?Q?/teFENVWhLOYlmQIEquRpWRZy5FzrtM3DzmllgKBM+i2Txp1HURl+SMPIeik?=
 =?us-ascii?Q?vTBCce5Vd6o1k6QW13HWY2WySWvH97ia/uYrxE/mo+okIG/DlckRYB1Hg9MI?=
 =?us-ascii?Q?bTaZjGNH2ljwt7sPFm3BnFaPzDMKS3UKy4vPsOluOSxHPtOWbC7LcV1DiAFZ?=
 =?us-ascii?Q?NvUkFCrnWB40MZUPH9Lm0F3Q+sDB3x/b2gT4dujh0zhOsQCyrqeguL7DdyMh?=
 =?us-ascii?Q?OP2f7iWWngfKw54Sr0fba6IXAUkPY4RgYd40dS0QyA9ABuYINWZj9NW5md3D?=
 =?us-ascii?Q?Egw6VWk7K+f7z0MfL3M8Nqvc98kqcHovsNsoeSZoJLAW4lqzNbg8BGUF3wre?=
 =?us-ascii?Q?vdel0Rr4qHr4s17loZp8t01ATYkKa5bzSl6UeaI+D46ah3S8d5itYB526MQe?=
 =?us-ascii?Q?LRYcu3nBuM81LDf4dPI2+MaXT6aZKsg/sgvxYFbfrAn1e8mH+2oDLiaJg1kh?=
 =?us-ascii?Q?PATkz7fD3m/AtP0cscfNK8O2lnTxPY723kdn52uabGPD0RvkXxZEIbxCU3On?=
 =?us-ascii?Q?RmQ4EfR7Ew=3D=3D?=
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
X-Exchange-RoutingPolicyChecked: lDC2CxCSpKshEVG2BbsV+By0gtziSuRb1qXwFveIV5SvdtiN3WYmnhYQXjGGTBkB0sAml5P6NrFB1sKD2uqCCJUL9WU9+f09B4WUjdatZ5LkD+HFsKYk3fXFLkUb7vkdIkbmUti3UDiIYnmuWntg5MCVyVxectlv/OwUv5tzeQVvzY9BN1rlVxVRk3mGUkjsTo7jPwDb//+LRfQOdVOHeU5X89jD4hh2fUXxz+2yHrt3V6WvA0xuwRlUaTbe0MDv/j0jKiFmSIMFh74orFk3FZiiGa/C/Wei65w0BgNbO0/4iTEPjbqTbgmnSIDK6TPPmPUcubK3HDn/pnMCboLdRQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB566895.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2e7e95-9226-4a11-eb02-08df2f659f10
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 11:22:41.6687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N1WGPyL0QlOqmDGjmTdl8mNkGpaIrQlaiA5OCYRi07Z91cIFaRI4xHt5yeqx3rc/R4WojOrjklUEdZ1rH7aQZPIXH0xPkNdodz0rQVrMz/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8512
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
> Subject: [PATCH iwl-net 3/3] ice: do not block on the aux device lock in
> ndo_setup_tc
>=20
> The TC_SETUP_QDISC_MQPRIO path of ice_setup_tc() takes the auxiliary
> device lock to test whether the RDMA driver is bound, and ndo_setup_tc()
> runs with the RTNL lock held. This closes the same cycle against the
> RDMA auxiliary probe as the two preceding patches.
>=20
> Use device_trylock() and report the device as busy when it fails, with a
> distinct message for the same reason as in the previous patch.
>=20
> Fixes: 4b31fd4d77ff ("ice: Fix RDMA VSI removal during queue rebuild")
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index edb62606d2aae3..7b251136149615 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -9448,7 +9448,11 @@ ice_setup_tc(struct net_device *netdev, enum
> tc_setup_type type,
>  		cdev =3D pf->cdev_info;
>  		if (cdev && cdev->adev) {
>  			mutex_lock(&pf->adev_mutex);
> -			device_lock(&cdev->adev->dev);
> +			if (!device_trylock(&cdev->adev->dev)) {
> +				mutex_unlock(&pf->adev_mutex);
> +				netdev_dbg(netdev, "RDMA auxiliary device is
> busy, try again\n");
> +				return -EBUSY;
You return error here, but it looks like being silently dropped in mqprio_d=
isable_offload() isn't it ?=20

> +			}
>  			locked =3D true;
>  			if (cdev->adev->dev.driver) {
>  				netdev_err(netdev, "Cannot change qdisc when
> RDMA is active\n");
> --
> 2.56.0


