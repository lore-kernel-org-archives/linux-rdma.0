Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793217606;
	b=IUTsshQfv+TDZ95KbrfM8vfGIm+oGiljxQG6vV37hsRchPyys5M4/C6BAxucAHS9vBYx
	 0cE33S/f2eP/KjDsm11RmOy50WeHf0P3PK40RDLjuDcEOUILC19y0msYw7o4tjSihJLK8
	 t6AVRCeHgV2sg6OavNat3M2d/vJ8jFcwL35K7oNsWrsPEjvcWEOwDcu2r9DptdEJXGelj
	 +OAZZCepxyxLJxg8PfJMlbXTuS91m0AcwWUvF2mkiemzKQKmCmORg0S1vaSbZrJBNrzv1
	 bImd3IZv+Ot8GoMe1KyO3UMhQFf9ucpr30YHM9JleAtg8/G+4iwDTrP1BnXDpNQ68FA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217606;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=16LGTz4vLGkxqFAnVqnYEoU68L62p2AQ1kVvfXSnaaQ=;
	b=X58yZ6NzD2VoZiOeEKZmLyLKAAjN5zyqVTii7yWVyBxk6HtWwJDgiWZ3sdEmDCvflU7W
	 KGToLI759j0HxkWFSKbwtwqVCNC+E9W98VRpgt6pp9c+dgaFaipVs8hy/VNDo7qBPEgve
	 O4RqECqaF4Cb1DQ6bmQIIWNGn0dzMfc5F06vuXra5bOW9NZA5oCbfDMUHSV22rhYga0yO
	 /HyvLoOn7a/eSP8UVxyH4HF6Acn7nodQ6XEeOfu55UnxfJy0DGKyKIwbcwnHNql3/P3e/
	 Tlq+u+d/VajvAmqQZU5j5SDop9YwnOzp7J+9n/CXLcTfqSC0K6QnWWkMiq5A6nF7BTw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GNVNKaCS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28BF606A31E
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 20:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F28BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=GNVNKaCS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793217605; x=1824753605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=16LGTz4vLGkxqFAnVqnYEoU68L62p2AQ1kVvfXSnaaQ=;
  b=GNVNKaCSewE3NIVHGDp4dEBdZsKobyRivcuQyv5gUN8A1TKUYpygLSCe
   XYm2EHNuv80GrtD7cmHhcvIascSScLZYvdA98+Lk9C4qY08zzvMJJapRY
   wrF+riR59YONZIYcsZV3LE2L5J5E9bMiv+D6l0meHOyR1OPfyJX2yFxwI
   xkLTL8IJB+AwizbKBpuII8pzV0kRLBImfOZOJiQSttxEhKdyEbZdOPtLC
   n31481I4XDRiI8dnloyy+kg4Vi7zK3UQxymM4caxORvDLftJHHR8WQVBn
   1c7P7yW3Rte7tA8m/UEtSFzRjgGluZmqINGDjt3Hwb8kxD1W4CQJR8Sdz
   w==;
X-CSE-ConnectionGUID: f4Plt/J1SN2csK0VCsbIcg==
X-CSE-MsgGUID: nblLxGE7QgGbQ5OEGJeulQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1982443"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1982443"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 13:00:05 -0700
X-CSE-ConnectionGUID: WnGnfo91RauwdHqqw7HwtQ==
X-CSE-MsgGUID: suM+Z+KNTg23OfWNNeCIZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="4818003"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 13:00:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 28 Oct 2026 13:00:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 28 Oct 2026 13:00:03 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.23) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 28 Oct 2026 13:00:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEoxDvZdBMGXQd5ZMMuAK7+Zwe/ERwL4WvkvqOwjc8AC0hjBSFaVLzwACRadYS3/sAeB16TTVsQRecyMCZKi0YzrtU2qe9h7Ry8qvk67/eyFmAxE+h+WT5StpBKyWsucsMMe4B4JOm+gpopRIPsxLI+nKhe/YtDYd0x01VyCiDbF0cGdaAovzqM/MxaMf4RonWHipf0uiqEkFNDaZ87PkmFQln8H/Lzwn0EbbSXc0Cfgzmiof+JXk1j4KilJXZz5hBTPo1PhXVmUAS9bX2GEY27N2J15Ix0QE7nuu5u9RbAzNyYJpCVfU9xXOMdTcIqohlBXSouxRZNDAL2BEEujFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16LGTz4vLGkxqFAnVqnYEoU68L62p2AQ1kVvfXSnaaQ=;
 b=fjV+x8nUMM/r2J1GJKmOo2u+zYc1Mu0ZgvrLK285ZJYCqH+I5iKbwowXQpycU8tSH+9AoeZRTK6EMpTkrQOMrS4Q6Dpzd2KiqATevrKICfyN5xOohOtjWsh6wOGU3rK5cANxj8s3O6bg8mv+p/z4q4ynNJvN52mfUZ6BoBuDzUYYIsUscZWAVX0MVTJf11NgNrfy+SdApOssFljULlp2TtBQO3KgutvOqxq0xRsKrh8ViYeh06WZBxoQAN4k3LKbXI1ERaqywhmdS5zvTE0iERE6WCArSN9iJ6VNURdSaH5JPG6sLLlST6O4rEVqSdWV0SmIvt5n2IhQ+SHrrkM10Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB7727.namprd11.prod.outlook.com (2603:10b6:208:3f1::17)
 by PH7PR11MB5944.namprd11.prod.outlook.com (2603:10b6:510:124::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 19:59:59 +0000
Received: from IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875]) by IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875%3]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 19:59:59 +0000
From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
To: Jacob Moroni <jmoroni@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leah Li
	<leahlijuan@google.com>
Subject: RE: [PATCH rdma-next 2/2] RDMA/irdma: Fix paged PBLE and virtual AEQ
 for PAGE_SIZE > 4K
Thread-Topic: [PATCH rdma-next 2/2] RDMA/irdma: Fix paged PBLE and virtual AEQ
 for PAGE_SIZE > 4K
Thread-Index: AQHdYmlPaPDbJlKknkKXf16KGiIj47cTaNAg
Date: Wed, 28 Oct 2026 19:59:59 +0000
Message-ID: <IA1PR11MB7727DE61F0D5F464DD0EA777CB6F2@IA1PR11MB7727.namprd11.prod.outlook.com>
References: <20261022210650.1182000-1-jmoroni@google.com>
 <20261022210650.1182000-3-jmoroni@google.com>
In-Reply-To: <20261022210650.1182000-3-jmoroni@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB7727:EE_|PH7PR11MB5944:EE_
x-ms-office365-filtering-correlation-id: 60d09cb3-cdab-4753-d085-08df352e0bbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|261028144727099003|38070700021|11063799006|4143699003|56012099006|261009223027099003|261026140227099003|10067099003|261022105027099003|261022075727099003|261021121427099003|261021123027099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info: 4QRewJWL4gihbTgn62BtK+5ZBXBOdxDiwreUyATWJ0eaNZR3Prgky72s/c4/JMT8h9mgWYIVR7cfJ0yhVd4FFNY9tjMKjlQwZnuHSsgb6S19qm8YsazLC1NV7rBCpVIMWABLgB5/wBudUmQVJJoMRmSqt/OoiwPAmVZo9FeX6qc6JcHQS5DrW3YORkIu35Phws40YpauWnatT+pVIhVmMEazZey2hepxEZ7+yXWtWVOU9TxvJ2TIei8JefovsIzf14S3r+PYut+m/cxU6ekjkqB5mYuLenZdVv2ttgyZ4vsHCIuw6WV2G9ph5bK52UuUAyGvcgvApzHmZ+eEil3AJSYClVCisznOtkyY/pqW0ibobwi4AQ2yW8TvRjeo7nDvbnL/1M+WdrhhbiYd5UqHWzbXZe7mEJJHc6b3KyGGb9tK7BYB1Hiqo9lUvJ70UvBXypIN0f6B2bdARMqsNxv6Qkx1bcFZqMA5xiEpDQRzSQ0nl+JjmnafujQyTlC4jO/4BtGVg7GlJhYPzzd6D+PyMgFBZMHqzFltV3BS3TzZG79VNSEXiTTRDKTsjElTJ8JLrtti5QOZj+IOhktAXfaqvLpC2Pbksf2iFVh0JU/NgZ+p+KWtVu/Ez9A5sTBt+q7K3GT6bQyNCt6bBVOM3o3Uz/TRn5+n5sRwh/gysCH+mxLqOHOx1lfTUFIbXBMCw9B/d4vVtcSCsYDeiolIOvMPkKs+TxH2XgThUHXkAxINyXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7727.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(261028144727099003)(38070700021)(11063799006)(4143699003)(56012099006)(261009223027099003)(261026140227099003)(10067099003)(261022105027099003)(261022075727099003)(261021121427099003)(261021123027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTFUQ2puZU5vemJuMGMycStYUjVGUS83TjJHalpQQThNRkVsUWFJM1hsOHpu?=
 =?utf-8?B?SEIyRkFLSk91VnU1R3lLcmpWb1lXeTFIQk1sUVAxTEhpR3dXa1EvSmVqUjBr?=
 =?utf-8?B?eGtGWGc3MCt0UTBQdldUL2N1RkNRQVY4Tkd0bjkzbmdiZ2V0SFBjNm55YUhj?=
 =?utf-8?B?MHRQSlUwUmpUS0RDeittZTkrK00rb3pJVnRzamFIMmxjU3ZJR0lYckhDY09v?=
 =?utf-8?B?c212VTgwQUI0WU44KytWYTBUbHA2ci82MGk4clZnS292bXM1TXFrUkJQeEdG?=
 =?utf-8?B?TzI2ZDhyZGtaSUFuRGJRWkhlZS8wb0ZDSzAwMEZDemRkSER3TDVDc3ltSGxI?=
 =?utf-8?B?Q0d4ZEpuLzNJR21EczBpRTRwVlBPTGpzTUQyWXBkMy9KdWVIbVZYY0lnV3dT?=
 =?utf-8?B?eUxock40cjJDdTNKZ0dnU0xQYXdhWmlCVWsyQi9wYlpjOG5GeTlLc3Z4Nmxi?=
 =?utf-8?B?UUQwaHFkeWg3UkovZXFLTW9TNkpIZWxGL2ZuTHVZb1FNUUZmajZ4MzJPN1hq?=
 =?utf-8?B?NHlTa3VBQkFjL1NhRG0wVEQ5YUQ3OUNYa3BEV1BSTjY3WjZxOXNRKzlHdGJR?=
 =?utf-8?B?TDI0eHdaTS9TRk1SdkpPSXlSaHh5YkRoM1pFWEliVUk2WTd4K0t3V3NjalV5?=
 =?utf-8?B?dEg5aGgydkkzMFFFaHM3RWhuZXhtRjViazl2RDMwNlYyRXk0TU8vVlYwMWJ6?=
 =?utf-8?B?U0VoQmRTNGNZU29reEdOelA1dmlJVlRzU2c1NjJkSnFzM1FGc0ZZcFdEZUVO?=
 =?utf-8?B?SUN1U0Zvb3UvdTc3MXZxM1BocEYwS2lESnBTNFlRelpxbWx2MFA5akxJaVFs?=
 =?utf-8?B?ZDgzUDEyczBITS82cFpHaHY0NC9CUWovRWYyNCszM0F2ODRXdjlqaW11MlMv?=
 =?utf-8?B?dlR6Q3UwVjhqN2I4M2lMVWY0L1ppV1p5eFpDV05teXZNTnRNckFaVWZPQnpM?=
 =?utf-8?B?R2ZVRTRVMitoMmtDYUVtbkZFelovUjlHL29ORDdOVjA5TVdkTzZnYjc4UC83?=
 =?utf-8?B?eU1CMHdDckx4TEdGZU9Md3pBK09LOHgwNEdTaWJPUlNBQXVKWDNnL0g2TTFx?=
 =?utf-8?B?N0VxZHhBcVcveDMzMVY4dU93eGdCYWVUbjdhalREa0o2SDFtS1VDaGRiK3R5?=
 =?utf-8?B?dmNwOWk3SFdmM3UycUw3Tm1LK1htTHNzSGVHQVVVbHZ1T21wUVh6Mktsd1M0?=
 =?utf-8?B?MVVueTduZytKeFoxSEdHZFdITTN6RysxR041aXk5V2M0L0RhUXZrd3RQTnVO?=
 =?utf-8?B?bXhQZmRGQlloOHZlRkN3elZDOTF3T0tpbVYrVXBGbFFRbW1zS1pYbXBmU1NS?=
 =?utf-8?B?cUQ4MDNsaVFOQnl1T09hdEZWUy9kZkJwbG5pdnBSci9iM1ZQUmdiVzhtOS9K?=
 =?utf-8?B?Z05tZWVMS1JXeHRPV25XeHJnZWNmZ0gxUUxGVGlIRldTZHhBczlGSWIyTlE3?=
 =?utf-8?B?RmxvOHNvSkZYMlhlUThLMXBjczl1cDIxQW82a1hPVWVkWmx0WW1uSFJFS01v?=
 =?utf-8?B?MTArQ1FFUzY1Tll3Q3M1U0F2ckwwa0o1Mk1RMTFnTXRoRi8rMFBiTnR2OFhr?=
 =?utf-8?B?ZWEvcTRPSFBrWlg3K0tZaWZGZ2lvV0FLVDc4Vml6M21vUzBvN2EvTnN2Lzls?=
 =?utf-8?B?LzY1b2FZNmdHaFVUNnB0cS9Galc0d1psN21VZ250REF5aWN3V1g1N3lwc0I4?=
 =?utf-8?B?aWZGcTRWNWtoUUt2MWdRUVZhcU5XeTZxNjBadVBWN0hWRHpyMHMzQjlzdG5E?=
 =?utf-8?B?WEMvTUIyYWVKRFdEWGR3OGNPV2wrZGhKTm0vaDZ5Ti9JU0RnalE1YmwrMWJ1?=
 =?utf-8?B?clhJYnZOYWcwWFBRdmdQVkttSmZQeDZLSDQvNU1lUlZTTlZRSk55SDJRRlIv?=
 =?utf-8?B?cWduUkZ1RTkxMDh0TUlySGV4RXVCSFB3bktweXFRVlpGa256c3VkTFRpQ3Vw?=
 =?utf-8?B?MGlSakl3Z1B0OCs5dkV6LzBRRUdrWFFKM0tvWGZzUU5lQzFkMkdZUWdLMlFi?=
 =?utf-8?B?SHZLRE5lWk5QZnBCQVRSRTAybER1M2pUVkVMNmNBczdrbWFaM3grMDRFcERG?=
 =?utf-8?B?TzU4b1F5WllKdWVvRXJtK2krWHFjVUpFVkdxdnZNWDFPWGphQk11eHJVWTQw?=
 =?utf-8?B?TXJhNjd1czJsV1JXMisyekVsOHhBaGpMWnBQUHIwTzhRbytlZlF4S1lYVmlt?=
 =?utf-8?B?aTRWUFdjU3QzaTMzYzhjZzYzTUJDY0xoSkU4b0dJKzBtTTBHNUZmZm92K29K?=
 =?utf-8?B?RTlyQnI3R2E0N0l0amNNd0dYK2V3VDVYVm5aTUE4NVpaeHhFOFZpblM4d08y?=
 =?utf-8?B?aHZVb05TTzZLWERJRGNnYUJiSWNQa25DSExkNEtJQ0pWZjBWUWl5QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ee7seHx0zqhk0F3mmvmTzvEpl9qJVOADlZdgEj0bgB1LKWGAMKY/LmkXytejJHeo7m5ovcUASFtYTmhbYgnkO/IMTnNqVkXpQ+H60JTiH5oqH7Sed4Lauy6cuaJFVZ9D1wMzvlWEMMQU+7d0eJkNVpfRUxpFQU0wwGfSXsovyf+Y4k8hE2Zpxheo60i8V2QsOOC0K2jE7soaIKvkBkmc4aqTCHJgpeZyCZS7fq7AnxoZjfGiBe09SnMLd3od49kF8JKfRIZLkQWfKpSUdjk1JI5kPjGd/4FgV45iwWNiTEUIt/QjrzYKHyWpseLBmzNvK7HfW7scNWB1Mi0QF2mFqQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7727.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d09cb3-cdab-4753-d085-08df352e0bbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 19:59:59.1090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Qzm11DdwIBeTYDcBD0yJAczl57AJ7kkeIyyfZQpEa1HKHEdeDfVE4sYKj7GuxiBeds+MenqyS1mEt6wHrvBngpfSvIG+XMgECq1gKUu1Fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5944
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFjb2IgTW9yb25pIDxq
bW9yb25pQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDIyLCAyMDI2IDQ6
MDcgUE0NCj4gVG86IE5pa29sb3ZhLCBUYXR5YW5hIEUgPHRhdHlhbmEuZS5uaWtvbG92YUBpbnRl
bC5jb20+OyBqZ2dAemllcGUuY2E7DQo+IGxlb25Aa2VybmVsLm9yZw0KPiBDYzogbGludXgtcmRt
YUB2Z2VyLmtlcm5lbC5vcmc7IEphY29iIE1vcm9uaSA8am1vcm9uaUBnb29nbGUuY29tPjsgTGVh
aA0KPiBMaSA8bGVhaGxpanVhbkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggcmRtYS1u
ZXh0IDIvMl0gUkRNQS9pcmRtYTogRml4IHBhZ2VkIFBCTEUgYW5kIHZpcnR1YWwgQUVRDQo+IGZv
ciBQQUdFX1NJWkUgPiA0Sw0KPiANCj4gSE1DIHBhZ2UgZGVzY3JpcHRvcnMgYW5kIHRoZSB2aXJ0
dWFsIEFFUSBQQkwgYWx3YXlzIGFzc3VtZSA0Sw0KPiBIVyBwYWdlcywgYnV0IGlyZG1hX21hcF92
bV9wYWdlX2xpc3QoKSByZXR1cm5zIG9uZSBETUEgYWRkcmVzcw0KPiBwZXIgUEFHRV9TSVpFIHBh
Z2UgYW5kIGlyZG1hX3BibGVfZ2V0X3BhZ2VkX21lbSgpIHNpemVzIHRoZSBjaHVuaw0KPiBhcyBQ
QUdFX1NJWkUgKiBwZ19jbnQuDQo+IA0KPiBUaGlzIGJyZWFrcyB3aGVuIFBBR0VfU0laRSBpcyBn
cmVhdGVyIHRoYW4gNEsuIEZvciBleGFtcGxlLCB3aXRoDQo+IGEgNjRLIFBBR0VfU0laRSwgdGhl
IHNlY29uZCBIVyBwYWdlIHBvaW50cyB0byB2YWRkcis2NEsgd2hlcmVhcw0KPiB0aGUgZHJpdmVy
IGFzc3VtZXMgaXQgdG8gYmUgYXQgdmFkZHIrNDA5NiwgZXRjLg0KPiANCj4gSXQgYWxzbyBlbmRz
IHVwIHVzaW5nIGFuIGluY29ycmVjdCBjaHVuayBzaXplIHdoaWNoIGNhdXNlcyBlYWNoDQo+IHBh
Z2VkIGNodW5rIHRvIGNsYWltIDE2eCBtb3JlIFBCTCBlbnRyaWVzIHRoYW4gd2hhdCBhY3R1YWxs
eSBleGlzdC4NCj4gDQo+IEZpeCB0aGVzZSBpc3N1ZXMgYnkgdGFraW5nIGludG8gYWNjb3VudCB0
aGUgcG90ZW50aWFsIGRpZmZlcmVuY2UNCj4gYmV0d2VlbiB0aGUgSFcgcGFnZSBzaXplICg0Sykg
YW5kIHRoZSBzeXN0ZW0gUEFHRV9TSVpFIGR1cmluZw0KPiBhbGxvY2F0aW9uIGFuZCBtYXBwaW5n
IChzbyBvbiBhIDY0SyBrZXJuZWwsIGVhY2ggcGFnZSBlbmRzIHVwDQo+IHBvcHVsYXRpbmcgMTYg
UERzLCBldGMuKS4NCj4gDQo+IEZpeGVzOiA0NGQ5ZTUyOTc3YTEgKCJSRE1BL2lyZG1hOiBJbXBs
ZW1lbnQgZGV2aWNlIGluaXRpYWxpemF0aW9uDQo+IGRlZmluaXRpb25zIikNCj4gRml4ZXM6IDkx
NWNjN2FjMGY4ZSAoIlJETUEvaXJkbWE6IEFkZCBtaXNjZWxsYW5lb3VzIHV0aWxpdHkgZGVmaW5p
dGlvbnMiKQ0KPiBUZXN0ZWQtYnk6IExlYWggTGkgPGxlYWhsaWp1YW5AZ29vZ2xlLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogSmFjb2IgTW9yb25pIDxqbW9yb25pQGdvb2dsZS5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2h3LmMgICAgfCAgNCArKy0tDQo+ICBkcml2
ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvdXRpbHMuYyB8IDIyICsrKysrKysrKysrKystLS0tLS0t
LS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2h3LmMNCj4g
Yi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvaHcuYw0KPiBpbmRleCBmYmI4ZmI0N2QwZDEu
LjFkNTdiM2M5ZjQ5MCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1h
L2h3LmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2h3LmMNCj4gQEAgLTcw
MCw3ICs3MDAsNyBAQCBzdGF0aWMgdm9pZCBpcmRtYV9kZXN0cm95X2NxcChzdHJ1Y3QgaXJkbWFf
cGNpX2YgKnJmKQ0KPiAgc3RhdGljIHZvaWQgaXJkbWFfZGVzdHJveV92aXJ0X2FlcShzdHJ1Y3Qg
aXJkbWFfcGNpX2YgKnJmKQ0KPiAgew0KPiAgCXN0cnVjdCBpcmRtYV9hZXEgKmFlcSA9ICZyZi0+
YWVxOw0KPiAtCXUzMiBwZ19jbnQgPSBESVZfUk9VTkRfVVAoYWVxLT5tZW0uc2l6ZSwgUEFHRV9T
SVpFKTsNCj4gKwl1MzIgcGdfY250ID0gRElWX1JPVU5EX1VQKGFlcS0+bWVtLnNpemUsDQo+IElS
RE1BX0hXX1BBR0VfU0laRSk7DQo+ICAJZG1hX2FkZHJfdCAqcGdfYXJyID0gKGRtYV9hZGRyX3Qg
KilhZXEtPnBhbGxvYy5sZXZlbDEuYWRkcjsNCj4gDQo+ICAJaXJkbWFfdW5tYXBfdm1fcGFnZV9s
aXN0KCZyZi0+aHcsIHBnX2FyciwgcGdfY250KTsNCj4gQEAgLTE0NzksNyArMTQ3OSw3IEBAIHN0
YXRpYyBpbnQgaXJkbWFfY3JlYXRlX3ZpcnRfYWVxKHN0cnVjdCBpcmRtYV9wY2lfZg0KPiAqcmYs
IHUzMiBzaXplKQ0KPiAgCWlmICghYWVxLT5tZW0udmEpDQo+ICAJCXJldHVybiAtRU5PTUVNOw0K
PiANCj4gLQlwZ19jbnQgPSBESVZfUk9VTkRfVVAoYWVxLT5tZW0uc2l6ZSwgUEFHRV9TSVpFKTsN
Cj4gKwlwZ19jbnQgPSBESVZfUk9VTkRfVVAoYWVxLT5tZW0uc2l6ZSwgSVJETUFfSFdfUEFHRV9T
SVpFKTsNCj4gIAlzdGF0dXMgPSBpcmRtYV9nZXRfcGJsZShyZi0+cGJsZV9yc3JjLCAmYWVxLT5w
YWxsb2MsIHBnX2NudCwgdHJ1ZSk7DQo+ICAJaWYgKHN0YXR1cykgew0KPiAgCQl2ZnJlZShhZXEt
Pm1lbS52YSk7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvdXRp
bHMuYw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS91dGlscy5jDQo+IGluZGV4IDI5
MGFkMDJlZDY1Ny4uM2VmYzQxMjViYjU5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJh
bmQvaHcvaXJkbWEvdXRpbHMuYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEv
dXRpbHMuYw0KPiBAQCAtMjE5OSwyMCArMjE5OSwyNCBAQCBpbnQgaXJkbWFfbWFwX3ZtX3BhZ2Vf
bGlzdChzdHJ1Y3QgaXJkbWFfaHcNCj4gKmh3LCB2b2lkICp2YSwgZG1hX2FkZHJfdCAqcGdfZG1h
LA0KPiAgCQkJICAgdTMyIHBnX2NudCkNCj4gIHsNCj4gIAlzdHJ1Y3QgcGFnZSAqdm1fcGFnZTsN
Cj4gLQlpbnQgaTsNCj4gKwlkbWFfYWRkcl90IGRtYTsNCj4gKwl1MzIgaSwgajsNCj4gIAl1OCAq
YWRkcjsNCj4gDQo+ICAJYWRkciA9ICh1OCAqKSh1aW50cHRyX3QpdmE7DQo+IC0JZm9yIChpID0g
MDsgaSA8IHBnX2NudDsgaSsrKSB7DQo+ICsJZm9yIChpID0gMDsgaSA8IHBnX2NudDsgaSArPSBJ
UkRNQV9IV19QQUdFU19QRVJfUEFHRSkgew0KPiAgCQl2bV9wYWdlID0gdm1hbGxvY190b19wYWdl
KGFkZHIpOw0KPiAgCQlpZiAoIXZtX3BhZ2UpDQo+ICAJCQlnb3RvIGVycjsNCj4gDQo+IC0JCXBn
X2RtYVtpXSA9IGRtYV9tYXBfcGFnZShody0+ZGV2aWNlLCB2bV9wYWdlLCAwLA0KPiBQQUdFX1NJ
WkUsDQo+IC0JCQkJCSBETUFfQklESVJFQ1RJT05BTCk7DQo+IC0JCWlmIChkbWFfbWFwcGluZ19l
cnJvcihody0+ZGV2aWNlLCBwZ19kbWFbaV0pKQ0KPiArCQlkbWEgPSBkbWFfbWFwX3BhZ2UoaHct
PmRldmljZSwgdm1fcGFnZSwgMCwgUEFHRV9TSVpFLA0KPiArCQkJCSAgIERNQV9CSURJUkVDVElP
TkFMKTsNCj4gKwkJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKGh3LT5kZXZpY2UsIGRtYSkpDQo+ICAJ
CQlnb3RvIGVycjsNCj4gDQo+ICsJCWZvciAoaiA9IDA7IGogPCBJUkRNQV9IV19QQUdFU19QRVJf
UEFHRSAmJiBpICsgaiA8IHBnX2NudDsNCj4gaisrKQ0KPiArCQkJcGdfZG1hW2kgKyBqXSA9IGRt
YSArIGogKiBJUkRNQV9IV19QQUdFX1NJWkU7DQo+ICsNCj4gIAkJYWRkciArPSBQQUdFX1NJWkU7
DQo+ICAJfQ0KPiANCj4gQEAgLTIyMjUsOSArMjIyOSw5IEBAIGludCBpcmRtYV9tYXBfdm1fcGFn
ZV9saXN0KHN0cnVjdCBpcmRtYV9odw0KPiAqaHcsIHZvaWQgKnZhLCBkbWFfYWRkcl90ICpwZ19k
bWEsDQo+IA0KPiAgdm9pZCBpcmRtYV91bm1hcF92bV9wYWdlX2xpc3Qoc3RydWN0IGlyZG1hX2h3
ICpodywgZG1hX2FkZHJfdA0KPiAqcGdfZG1hLCB1MzIgcGdfY250KQ0KPiAgew0KPiAtCWludCBp
Ow0KPiArCXUzMiBpOw0KPiANCj4gLQlmb3IgKGkgPSAwOyBpIDwgcGdfY250OyBpKyspDQo+ICsJ
Zm9yIChpID0gMDsgaSA8IHBnX2NudDsgaSArPSBJUkRNQV9IV19QQUdFU19QRVJfUEFHRSkNCj4g
IAkJZG1hX3VubWFwX3BhZ2UoaHctPmRldmljZSwgcGdfZG1hW2ldLCBQQUdFX1NJWkUsDQo+IERN
QV9CSURJUkVDVElPTkFMKTsNCj4gIH0NCj4gDQo+IEBAIC0yMjU0LDcgKzIyNTgsNyBAQCB2b2lk
IGlyZG1hX3BibGVfZnJlZV9wYWdlZF9tZW0oc3RydWN0DQo+IGlyZG1hX2NodW5rICpjaHVuaykN
Cj4gIC8qKg0KPiAgICogaXJkbWFfcGJsZV9nZXRfcGFnZWRfbWVtIC1hbGxvY2F0ZSBwYWdlZCBt
ZW1vcnkgZm9yIHBibGVzDQo+ICAgKiBAY2h1bms6IGNodW5rIHRvIGFkZCBmb3IgcGFnZWQgbWVt
b3J5DQo+IC0gKiBAcGdfY250OiBudW1iZXIgb2YgcGFnZXMgbmVlZGVkDQo+ICsgKiBAcGdfY250
OiBudW1iZXIgb2YgSFcgKDRLKSBwYWdlcyBuZWVkZWQNCj4gICAqLw0KPiAgaW50IGlyZG1hX3Bi
bGVfZ2V0X3BhZ2VkX21lbShzdHJ1Y3QgaXJkbWFfY2h1bmsgKmNodW5rLCB1MzIgcGdfY250KQ0K
PiAgew0KPiBAQCAtMjI2NSw3ICsyMjY5LDcgQEAgaW50IGlyZG1hX3BibGVfZ2V0X3BhZ2VkX21l
bShzdHJ1Y3QNCj4gaXJkbWFfY2h1bmsgKmNodW5rLCB1MzIgcGdfY250KQ0KPiAgCWlmICghY2h1
bmstPmRtYWluZm8uZG1hYWRkcnMpDQo+ICAJCXJldHVybiAtRU5PTUVNOw0KPiANCj4gLQlzaXpl
ID0gUEFHRV9TSVpFICogcGdfY250Ow0KPiArCXNpemUgPSBwZ19jbnQgKiBJUkRNQV9IV19QQUdF
X1NJWkU7DQo+ICAJdmEgPSB2bWFsbG9jKHNpemUpOw0KPiAgCWlmICghdmEpDQo+ICAJCWdvdG8g
ZXJyOw0KPiAtLQ0KPiAyLjU2LjAuMjE4LmcxZWM5MDRiMTczLWdvb2cNCg0KQWNrZWQtYnk6IFRh
dHlhbmEgTmlrb2xvdmEgPHRhdHlhbmEuZS5uaWtvbG92YUBpbnRlbC5jb20+DQo=
