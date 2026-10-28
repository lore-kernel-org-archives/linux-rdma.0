Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793217558;
	b=dzqyTiZx+HFbt2Kx6ZfV3pExBIWWaptM1gcwWL/RyaFIsK9WJo+uLhcjNl/Zkx3AGpJl
	 uJuGdgqrKOHwDCZMMIFXHsW0ObrFU6JoeXvASzeahr1GOmXqd4Px7LW7Ol2s2YQTW5cBQ
	 xWXZWnFfnddIHDmgHHeeNKh9Hi4IsJsQTE+w9F7YlDPccKwleL5BC/njDAtfn+bBnirkG
	 QiH44VosLd2cLp5lQL3MMOqa/RBS418LLGo+/hIH3mEb9WHYIaZo1ygzy78v3vDBXu41a
	 OoZTraL2F7t1hz2wG+67vE5ODuzdb5rV2u1juJlp4n1GRCYUpRl/o5rJ3kQRBfims+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217558;
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
	bh=gfbtXzcc8j7U3NeTun8yacHeYVQ1oP1j2zrb5jfoyOE=;
	b=Hwo6ajPJb1TbMAjoAOZCPNVqN0fShm1ep0O1I2I5sITyIm3lBEVg8uKzitJ/JQU+qMY3
	 +4vWbiwSv48urkqTvWKpakFmbfdrp7ATyBvErWZ4NeQw3TvtIZRMV7BwwgWNYmHcMxom6
	 yPkm6lxH6zMRlS+4IScWuamPRTAq0n6dpiCDJA6dfdVgkvKhyACYP6bgSifEuQsQK2MSc
	 SP0FaQaLgsT057kQLPO3mHU7hH7uh0nZuMB5Jt/wpMNINsVUqn9l5om5ft7oz8Ge2oiwZ
	 Mj8DIdW1jwX9qr4d1ko7ggCeUv8NVv2lY/pPbe5MDsqbgbD0Se1BTQfvRYSzGMzcOGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZRzRXwPU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4B606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 19:59:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42E4B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZRzRXwPU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793217556; x=1824753556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gfbtXzcc8j7U3NeTun8yacHeYVQ1oP1j2zrb5jfoyOE=;
  b=ZRzRXwPU09qBHeYkXwWNcB93GfTyoeq5dM7TjiG8B3rCJbagSFLSi1a5
   C8PtcnymdxMn2KUWIPfbMp0+1AUdO4rr9gEGwFNgvl6AfuzJ35FajKrhY
   MsMbGfkpOnpsrNiZC0+q/REcRY69iLoglHvXjTz6f945HDXL18ojU5iV/
   g6AzEKq9QAnypS87xuiv2JLNcvG3AcxnbkLhp7XNXSl5fszDX0cOIysSU
   PHlJ1I0/9z7kqHP2lhvqB5XuxPd22lyTi7dl8/s2ttU0mnfReCX6l0Fdm
   BXwbZGVOuNlsn+DlgYlKOzdzyQc2W2PAa+yT4AheJsvBbilb6UY+L4oPr
   Q==;
X-CSE-ConnectionGUID: vB3fkewhSte5zm2e2ZotbQ==
X-CSE-MsgGUID: +Ob+c9x9R/ixlp2O6eAyzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1977413"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1977413"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 12:59:15 -0700
X-CSE-ConnectionGUID: M+xMaE/lSqm/5viaoqKqOA==
X-CSE-MsgGUID: hUzACJiISA2uitVsLzmfVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="6768795"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 12:59:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 28 Oct 2026 12:59:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 28 Oct 2026 12:59:14 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 28 Oct 2026 12:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FpZqlTmDMIpuxmHxPVJysKgoCyHPznXhL3CYknoP+lvS2LNDE1zOCHlBS3GCdT/AWG1R2DsQY0cWaznKw6vK/ZAqGmz9jRMfYK691FDty+LmyuR29JOUgLaOENW06dn4/ZAB/9ZB4I1ByJSZ95k6iET6qWG6q6wvErLZjGKj0BRauqCuXYar5ccT2xVK2n+vZPpYDPRIEH6o3cw5L8/9zGxLF26qb31dyR4wCMx8SGfiEkNqIVC2VicdGwqkjjnmFt1R9KGwS7CMM0lrYTtW7V0AZUERJlKHPsZAGAtMlw7gKuEek51tUx93yP0+zN/aV9Iesu9K/5cpqjSyUALgiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfbtXzcc8j7U3NeTun8yacHeYVQ1oP1j2zrb5jfoyOE=;
 b=at3lec6/ZZ0u1wuOW4cs7nYP6cvidmUq4R11toJJk7exptnS2FPhxHtdXl5s/kEpsWuwp73x4R97F6sx0pEpmhckkw1yAXhJdQ/wgHRrTnDiT3Ck5zWMu/DD5N81+hIvQ7GlkE87N/ZmOQyemix/osHIjQ6o6y4S2S89A8Vy/gze0jcEES1D7dPiYfX9g7NMCMejHwpq/2n7VquuIzHm2CD2+TBPVB/CdHuYiGcLcxSOaqt2xW7yJca6BymKLHfe9TAtGP0x6xRnQGwEw++OniRDw+gZ9zjh5UXLXJo3l06hn/sQQXM9GffuEgtpKSjnt7WHr3aW4tCHbawBY87ciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB7727.namprd11.prod.outlook.com (2603:10b6:208:3f1::17)
 by MW4PR11MB6959.namprd11.prod.outlook.com (2603:10b6:303:228::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 19:59:12 +0000
Received: from IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875]) by IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875%3]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 19:59:08 +0000
From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
To: Jacob Moroni <jmoroni@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leah Li
	<leahlijuan@google.com>
Subject: RE: [PATCH rdma-next 1/2] RDMA/irdma: Fix FRWR logic for PAGE_SIZE >
 4K
Thread-Topic: [PATCH rdma-next 1/2] RDMA/irdma: Fix FRWR logic for PAGE_SIZE >
 4K
Thread-Index: AQHdYmlPje1CJ8oHvESToaCIsPU0qLcTaIhw
Date: Wed, 28 Oct 2026 19:59:08 +0000
Message-ID: <IA1PR11MB77272BD4971F62D349DCA21BCB6F2@IA1PR11MB7727.namprd11.prod.outlook.com>
References: <20261022210650.1182000-1-jmoroni@google.com>
 <20261022210650.1182000-2-jmoroni@google.com>
In-Reply-To: <20261022210650.1182000-2-jmoroni@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB7727:EE_|MW4PR11MB6959:EE_
x-ms-office365-filtering-correlation-id: 1e8e9ba7-e45c-44f6-5692-08df352ded94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|261026140227099003|261026130827099003|38070700021|261028144727099003|4143699003|11063799006|56012099006|261026121527099003|261022113327099003|261009223027099003|260925021911599003|261021123027099003|261021135927099003|261022105027099003|261021121427099003|261022115727099003|260925022911599003|260925021311599003|10067099003|261022075727099003|261021130227099003|22082099003|18002099003|3023799007|6133799003;
x-microsoft-antispam-message-info: gpV3vDVFy6HNVZbHbddqrElEcmJjIdsKa3clvrjhb6ZAM9Nxlo0x3dxMBXVetnRWPLwlvPNEojSHkfsjjEw+1FQrNLDg9uOtVqcbZcggHyN5rwouuDiF18SObQK3w8sBYJbL8NtAXa70S/Z6abOhKG2jFWTC95uLLyY7DI12AbIBfuQTES/cbYtLCO2wV0cfkU7u1avC5/t0zT/rferHIjisbLHb2LH9isO65gXT6kLIt6lMBc50L35bp2Lza4hSwVIVjOQRhLacN90x9NXM09Ed647OSXGgvEwR4vE26uZwTWZekpqLCrc86i1WrmJmlsEGv4bAN+WTtlsk4cMwXdCcMTTyeT2sygz6INKbufmzgM0hQzgUXAPAdxJ+ODcTIOY4Pn3yAqCbFd8Ky3SpF50JLb51hAT9Gs4gnT0zCc5XTsJqMrD/gxvr/6pT4wU1JIN2vt5yKr9/Pm2LngEcmUMvIAoYN4FxvLDYVbJqJDzlzGinOX6roG+lonk9lXPXD9NalmLiIoNtwneKtWs0c+gY5M8VLQ+VC/1CPXY8zRQwBayM1Etkw9mx6ukWWcX8UwDHM/sJb640cTV9R1yXUj+CQFdjgelgKhUTEnZuq2T4Adh6n4/qF1CN+gLtnWYeoq8iPAugcmGrsbR8tICw6AhO6g5vW1lKoPDrq0nbtLT3vMYQrGPlZuHXS6hZ7NOlKEO7PS8o18SODiuGJYGiEEcRQ/5D1dYZb07xNpW1h5E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7727.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(261026140227099003)(261026130827099003)(38070700021)(261028144727099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261022113327099003)(261009223027099003)(260925021911599003)(261021123027099003)(261021135927099003)(261022105027099003)(261021121427099003)(261022115727099003)(260925022911599003)(260925021311599003)(10067099003)(261022075727099003)(261021130227099003)(22082099003)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czFqNkw5dWdXQkhmRG5iQ2Vod3c2WWJEekZIRE0wRDI1Ryt2YjRlTVpZRlNv?=
 =?utf-8?B?U3FzeUtGRXhVTVhPSWJ3M3RvVDVjM1lnOEdmYUlCakwrVm82MGpxbG1SK0NY?=
 =?utf-8?B?dGxmZ2ZVMmxtQ29ySWVKWkRJVGFoV1lXNWF3Mk1KV2hVUHBRRjhlMEowQUhJ?=
 =?utf-8?B?NWl6eWUzVURERXRxbjVMZjEvYmVvaUdkQjF6Q1p6N2gxY1Q1QkdXRkdSblBl?=
 =?utf-8?B?blROMjY4RS9hYm0zSnRBY2NjUjFGUTRvRWNtWWp5bE9rcm1QVytUb1luYWs5?=
 =?utf-8?B?bEF3QWpPc0ZZcjBZTEJ4OVNDMmM3d2NuNmJjMEplZnBZNzM3M2dZYjlxT3Fu?=
 =?utf-8?B?Qm9nYldnamEzNGh0UjZHVGZ0L2p1ZmxyMGduQzlvaEk0YzJmUWFEMnFpQ3lW?=
 =?utf-8?B?MEZkVlFsa3lUN21aYzBBd0MxL0lBQzJpVHZvbi9UTVFEdFlXR3BYY25CZnJX?=
 =?utf-8?B?L2xObzZ2RlJyK3NSSFI0bmJGZm0zd2paZ20yemtnOFdiWURFWTZrbGtVczA3?=
 =?utf-8?B?N0lxUXRmV1MvVGxUMGhrby9ZVDFjTEZaM3E4aTg5WTZZQ0Q4Q0t5SWpxd3JF?=
 =?utf-8?B?eUVucHJHMDl3K3AwSzBRQzlvZjZlOHRQQ3Vqd3dKK05WdXZlekVYdlFuRFhu?=
 =?utf-8?B?eTRGSzhadXhSd3BLbUU3eVlVTHJuR2xNRytSMk85RlhOWnNvTCs3djJBbGxC?=
 =?utf-8?B?UzFLU2ZsdDZEaC80cy94WUM3UVgzRzB5MHVFUVBZRU1ldE8vcVVCQWZYR2Jw?=
 =?utf-8?B?K3d5OVNTRE9mam01ZERIc242NndHRGREVXJicGVySW5SVTA3UFYzb2Y4a1Jn?=
 =?utf-8?B?MWRkM0lmRDlQZmc4RDIzcGtPZzlZSXFld21leUZ1ZndyY21ueTZGZTVBUkxr?=
 =?utf-8?B?dGV3MlJBN0NzdEJlUG1UZWxMNGxtOHdudW5YZGtFdTBZQVVlMTZMbjBzRjky?=
 =?utf-8?B?TGdNbUx3bDVCd3V1NHBFOWVxenRleHNXYXZuZWxXek9jbkdNNVEzVTJMUnJE?=
 =?utf-8?B?OHNQMXpGMWlaWEhacURyallHTGs1UUxRR2hEbzV1a0E5bzZiVHhoZ0pKcTJx?=
 =?utf-8?B?VGZtOW14U2lkS3gxZTh2WFExWHdDY0xKcy9SUTRzY2g1ODBTb1U3YnVoeG4x?=
 =?utf-8?B?ZGZwOXE1RjJtd1RpYURtckdxTGFqOXhaK2kxbU9sQ3hqQ2thV2krTzE4TndV?=
 =?utf-8?B?R3JkVkZSZVp2YnhZU2FvNUtSTHVjZXFBQzJ4cFhzb3dGeUp3dnUvdG9GYW9P?=
 =?utf-8?B?QjdVM1U1QnJsK1l3TkZseWxoUE9kYi84akxOOXJraXoxMTh5R29ma0pYejV6?=
 =?utf-8?B?NFMzakdKYXRwcllSejBPczgyMXhHTjI3cVY0OUxFZVJCVGJtUkdRSVhWVlhU?=
 =?utf-8?B?ZmI5R09YUFRiOTVUU1h5aXJ2MkpRWkt0QkQ5QlBDWlhmeG10anFsYWhWRUJ0?=
 =?utf-8?B?WXdnYXdnYVN6ZjRmUXNYZ3NqMXlPZDlqZ0xDV3dOMTYweHhjUDJLSUFObnRY?=
 =?utf-8?B?cFVYOVAzRGVGOXBybWZlWHlMMXpLRVI3NFpiUU41cm1HWnBLcGVoeVdJWjB6?=
 =?utf-8?B?TEFvUW53Ym8rbkNuQTlJVmYrWU5ubUpCRmZZc2ErRklDeDd3R3hVV0FmSDJP?=
 =?utf-8?B?MG1UWWg2VlE5SGJDeEhQakxLLzZ3L2hneHJDVDZZK0RGTjllR2k4QzBFc0xW?=
 =?utf-8?B?cU5rWDMyZnN1T2hDcW1WcE9FcWpjQ0Z6V1FUdm5zOHNUWTMzV2JDZnhWTnNz?=
 =?utf-8?B?N3JxY0JvNjhVa0FFR0hwZDJ1bjlqb1R1cUJEc3pESVN0Y1VMb0xqdTEwZElI?=
 =?utf-8?B?QUNDMy9FN21BSnFwME1BbmVobm9PRHBaM3FWaEthMk4xbkl3V3A3Zk5sMFFv?=
 =?utf-8?B?VEgvYWtBbWNFMnVaamYrc2N0dXZRRHhDRS9KZHFTKzdyeStNTUlFcXUrOEJF?=
 =?utf-8?B?Tk1JSHN5NTdPcUFkUGx6R1BhaWY4WHF4bHBkci9vVnFaYWpmQUhPazlNa2x5?=
 =?utf-8?B?bWk1aG5LOUtvR1lSdGpGN2NaWXEvbmFFcGlXUTloby9WdWhsb0hIV1g3SDBP?=
 =?utf-8?B?UWNnOGxaUVdTaFdmRzMrb2xNSk9RTWEwRlhzRHUxOU03TzQ2aGxzMjVzSTB2?=
 =?utf-8?B?MFkwSkswUUdNdGIxWFNEQVFSdi9kVTBUTi9WZ1hySFFRVlEwR2lqejRPdGkz?=
 =?utf-8?B?WUc4TG8yU1JSZStoVE92Yk1BbFhlY09FT3lTN0ZCTnhIcVdjUlJHWWhEY3ho?=
 =?utf-8?B?WGxFS2RDTVBiUkczZlVrYTFlVUk0L0VwQllvbmxkdEhodk1ZYTVEQlgyaDJI?=
 =?utf-8?B?dXgyTlptb0lFZUtLVVhuTERGUEt6dDF5UjJIM21XU3RpQkRlN09hUT09?=
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
X-Exchange-RoutingPolicyChecked: K4zChCduu9szCtEv09au2CHmYfqcVY4aHp2JbQC2Yz/rzr6Xx1TEj82jaSsW2D4hiwzV8ZIAcHW3t7UpnvU/fsi/L+++p9HETlLeh0TiRDYCHdgGp/0Av73wsQ6q+RoMtVhwHgkpkiNEP0ShKUxdY3gWM+CjE5kRn4TwxIc4coytXE5UH3C1vMkLeZNTlVcHjVEN9oyVdJg7MYeCiFbft/1hIdlX6diZ75DI5oUknohT4wOcXdMI1wz34IAQgYq1YvshY0yxpHjek//RSeMuRFp/lDpyazMmLD/lRSHo7zQMc8hfcLOyTjZhQml9aNuAYc+c+tcVUl2hZi1ZnrHwnA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7727.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8e9ba7-e45c-44f6-5692-08df352ded94
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2026 19:59:08.5424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3OyjE+QSBTG+826EQT9y5gXkxcLc5kt+ZYBmEybOafnMsFNWOUyl2vd0hWKJr06Or6VMYIWVjWJOKvpRmV/neKInfN99ZSQQ33afXQr3MDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6959
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFjb2IgTW9yb25pIDxq
bW9yb25pQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDIyLCAyMDI2IDQ6
MDcgUE0NCj4gVG86IE5pa29sb3ZhLCBUYXR5YW5hIEUgPHRhdHlhbmEuZS5uaWtvbG92YUBpbnRl
bC5jb20+OyBqZ2dAemllcGUuY2E7DQo+IGxlb25Aa2VybmVsLm9yZw0KPiBDYzogbGludXgtcmRt
YUB2Z2VyLmtlcm5lbC5vcmc7IEphY29iIE1vcm9uaSA8am1vcm9uaUBnb29nbGUuY29tPjsgTGVh
aA0KPiBMaSA8bGVhaGxpanVhbkBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggcmRtYS1u
ZXh0IDEvMl0gUkRNQS9pcmRtYTogRml4IEZSV1IgbG9naWMgZm9yIFBBR0VfU0laRSA+DQo+IDRL
DQo+IA0KPiBUaGUgSFcgb25seSBzdXBwb3J0cyAxRywgMk0sIGFuZCA0SyBwYWdlIHNpemVzLCBi
dXQgc29tZSBVTFBzDQo+IHBhc3MgUEFHRV9TSVpFIHRvIGliX21hcF9tcl9zZygpLCBhbmQgUEFH
RV9TSVpFIGNhbiBiZSBzb21lDQo+IG11bHRpcGxlIG9mIDRLICg2NEsgYXJtIGtlcm5lbHMsIGV0
Yy4pLiBUaGUgSFcgY2FuIHN0aWxsIHN1cHBvcnQNCj4gdGhlc2Ugc2NlbmFyaW9zLCBidXQgd2Ug
bXVzdCBmb3JjZSBpdCB0byB1c2UgNEsgcGFnZXMuIFRoZQ0KPiBtYXhfZmFzdF9yZWdfcGFnZV9s
aXN0X2xlbiBhbmQgcGFnZV9jbnQgZHVyaW5nIE1SIGFsbG9jYXRpb24NCj4gbXVzdCBhbHNvIGJl
IHNjYWxlZCB0byBhY2NvbW1vZGF0ZSBmb3IgdGhlIGFkZGl0aW9uYWwgUEJMRXMNCj4gdGhhdCB3
aWxsIGJlIHVzZWQgd2hlbiBpYl9zZ190b19wYWdlcygpIGVuZHMgdXAgcHJvZHVjaW5nDQo+IG1v
cmUgcGFnZXMgdGhhbiB3aGF0IHdvdWxkIGhhdmUgb3RoZXJ3aXNlIGJlZW4gcmVxdWlyZWQgd2l0
aA0KPiB0aGUgb3JpZ2luYWwgcGFnZSBzaXplLiBJdCBpcyB3b3J0aCBub3RpbmcgdGhhdCB0aGlz
IGNoYW5nZQ0KPiBhdm9pZHMgdGhpcyBvdmVyLWFsbG9jYXRpb24vY3JhY2tpbmcgaW4gdGhlIG9m
ZiBjaGFuY2UgdGhhdA0KPiBhIDFHIG9yIDJNIFBBR0VfU0laRSBpcyBldmVyIHVzZWQ7IGl0J3Mg
b25seSBhcHBsaWNhYmxlIHdoZW4NCj4gUEFHRV9TSVpFIGlzIHNvbWUgcG93ZXIgb2YgMiBtdWx0
aXBsZSBvZiA0SyB0aGF0IGlzIG5vdA0KPiBjdXJyZW50bHkgc3VwcG9ydGVkIGJ5IEhXLg0KPiAN
Cj4gVGhpcyB3YXMgZGlzY292ZXJlZCBieSBlbmNvdW50ZXJpbmcgU01NVSBmYXVsdHMgd2hlbiBy
dW5uaW5nDQo+IGtlcm5lbCBORlMvUkRNQSBvbiBhIDY0SyBrZXJuZWwsIHdoaWNoIHdhcyBkdWUg
dG8gdGhlIHBhZ2UNCj4gbGlzdCBob2xkaW5nIFBBR0VfU0laRSBlbnRyaWVzIHdoaWxlIHRoZSBX
UUUgd2FzIGluZGljYXRpbmcNCj4gNEssIHNvIEhXIHdhcyB0cmFuc2xhdGluZyBldmVyeSBhY2Nl
c3MgYWZ0ZXIgdGhlIGZpcnN0IDRLDQo+IGluY29ycmVjdGx5Lg0KPiANCj4gRml4ZXM6IGI0OGMy
NGMyZDcxMCAoIlJETUEvaXJkbWE6IEltcGxlbWVudCBkZXZpY2Ugc3VwcG9ydGVkIHZlcmINCj4g
QVBJcyIpDQo+IFRlc3RlZC1ieTogTGVhaCBMaSA8bGVhaGxpanVhbkBnb29nbGUuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBKYWNvYiBNb3JvbmkgPGptb3JvbmlAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY3RybC5jICB8ICA0ICsrKy0NCj4gIGRyaXZl
cnMvaW5maW5pYmFuZC9ody9pcmRtYS9kZWZzLmggIHwgIDEgKw0KPiAgZHJpdmVycy9pbmZpbmli
YW5kL2h3L2lyZG1hL3ZlcmJzLmMgfCAzNg0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKyst
LQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jdHJsLmMNCj4g
Yi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY3RybC5jDQo+IGluZGV4IDFjMmFkNTc3M2I5
Zi4uZWY4NjI3ZjA3MGNlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJk
bWEvY3RybC5jDQo+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jdHJsLmMNCj4g
QEAgLTE3MDMsOCArMTcwMywxMCBAQCBpbnQgaXJkbWFfc2NfbXJfZmFzdF9yZWdpc3RlcihzdHJ1
Y3QgaXJkbWFfc2NfcXANCj4gKnFwLA0KPiAgCQlwYWdlX3NpemUgPSBJUkRNQV9QQUdFX1NJWkVf
MUc7DQo+ICAJZWxzZSBpZiAoaW5mby0+cGFnZV9zaXplID09IDB4MjAwMDAwKQ0KPiAgCQlwYWdl
X3NpemUgPSBJUkRNQV9QQUdFX1NJWkVfMk07DQo+IC0JZWxzZQ0KPiArCWVsc2UgaWYgKGluZm8t
PnBhZ2Vfc2l6ZSA9PSAweDEwMDApDQo+ICAJCXBhZ2Vfc2l6ZSA9IElSRE1BX1BBR0VfU0laRV80
SzsNCj4gKwllbHNlDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gIAlzcV9pbmZvLndyX2lk
ID0gaW5mby0+d3JfaWQ7DQo+ICAJc3FfaW5mby5zaWduYWxlZCA9IGluZm8tPnNpZ25hbGVkOw0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2RlZnMuaA0KPiBiL2Ry
aXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9kZWZzLmgNCj4gaW5kZXggZDZhMzE1Mjk1OWRkLi5l
YjkxNzk2NjQ4ODQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9k
ZWZzLmgNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2RlZnMuaA0KPiBAQCAt
MTU5LDYgKzE1OSw3IEBAIGVudW0gaXJkbWFfcHJvdG9jb2xfdXNlZCB7DQo+IA0KPiAgI2RlZmlu
ZSBJUkRNQV9IV19QQUdFX1NJWkUJNDA5Ng0KPiAgI2RlZmluZSBJUkRNQV9IV19QQUdFX1NISUZU
CTEyDQo+ICsjZGVmaW5lIElSRE1BX0hXX1BBR0VTX1BFUl9QQUdFCShQQUdFX1NJWkUgPj4NCj4g
SVJETUFfSFdfUEFHRV9TSElGVCkNCj4gICNkZWZpbmUgSVJETUFfQ1FFX1FUWVBFX1JRCTANCj4g
ICNkZWZpbmUgSVJETUFfQ1FFX1FUWVBFX1NRCTENCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2luZmluaWJhbmQvaHcvaXJkbWEvdmVyYnMuYw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9p
cmRtYS92ZXJicy5jDQo+IGluZGV4IGM5MWM1NTkxN2RlOS4uOTQ0M2U5NzMyYzRhIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvdmVyYnMuYw0KPiArKysgYi9kcml2
ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvdmVyYnMuYw0KPiBAQCAtMiw2ICsyLDIxIEBADQo+ICAv
KiBDb3B5cmlnaHQgKGMpIDIwMTUgLSAyMDIxIEludGVsIENvcnBvcmF0aW9uICovDQo+ICAjaW5j
bHVkZSAibWFpbi5oIg0KPiANCj4gKy8qKg0KPiArICogaXJkbWFfZm1yX3BhZ2VzX3Blcl9wYWdl
KCkgLSBIVyBwYWdlcyBuZWVkZWQgcGVyIFBBR0VfU0laRSBwYWdlIGluDQo+IGFuIEZSV1IuDQo+
ICsgKiBAZGV2OiBzYyBkZXZpY2UNCj4gKyAqDQo+ICsgKiBJZiBQQUdFX1NJWkUgaXMgb25lIG9m
IHRoZSBIVyBzdXBwb3J0ZWQgcGFnZSBzaXplcywgdGhlbiBpdCBjYW4gYmUgZGlyZWN0bHkNCj4g
KyAqIHVzZWQuIE90aGVyd2lzZSwgd2UgbmVlZCB0byBicmVhayBQQUdFX1NJWkUgaW50byBtdWx0
aXBsZSBIVyAoNEspDQo+IHBhZ2VzLg0KPiArICovDQo+ICtzdGF0aWMgdTMyIGlyZG1hX2Ztcl9w
YWdlc19wZXJfcGFnZShzdHJ1Y3QgaXJkbWFfc2NfZGV2ICpkZXYpDQo+ICt7DQo+ICsJaWYgKFBB
R0VfU0laRSAmIGRldi0+aHdfYXR0cnMucGFnZV9zaXplX2NhcCkNCj4gKwkJcmV0dXJuIDE7DQo+
ICsNCj4gKwlyZXR1cm4gSVJETUFfSFdfUEFHRVNfUEVSX1BBR0U7DQo+ICt9DQo+ICsNCj4gIC8q
Kg0KPiAgICogaXJkbWFfcXVlcnlfZGV2aWNlIC0gZ2V0IGRldmljZSBhdHRyaWJ1dGVzDQo+ICAg
KiBAaWJkZXY6IGRldmljZSBwb2ludGVyIGZyb20gc3RhY2sNCj4gQEAgLTU4LDcgKzczLDggQEAg
c3RhdGljIGludCBpcmRtYV9xdWVyeV9kZXZpY2Uoc3RydWN0IGliX2RldmljZSAqaWJkZXYsDQo+
ICAJcHJvcHMtPm1heF9tY2FzdF9ncnAgPSByZi0+bWF4X21jZzsNCj4gIAlwcm9wcy0+bWF4X21j
YXN0X3FwX2F0dGFjaCA9IElSRE1BX01BWF9NR1NfUEVSX0NUWDsNCj4gIAlwcm9wcy0+bWF4X3Rv
dGFsX21jYXN0X3FwX2F0dGFjaCA9IHJmLT5tYXhfcXAgKg0KPiBJUkRNQV9NQVhfTUdTX1BFUl9D
VFg7DQo+IC0JcHJvcHMtPm1heF9mYXN0X3JlZ19wYWdlX2xpc3RfbGVuID0gSVJETUFfTUFYX1BB
R0VTX1BFUl9GTVI7DQo+ICsJcHJvcHMtPm1heF9mYXN0X3JlZ19wYWdlX2xpc3RfbGVuID0NCj4g
KwkJSVJETUFfTUFYX1BBR0VTX1BFUl9GTVIgLw0KPiBpcmRtYV9mbXJfcGFnZXNfcGVyX3BhZ2Uo
JnJmLT5zY19kZXYpOw0KPiAgCXByb3BzLT5tYXhfc3JxID0gcmYtPm1heF9zcnEgLSByZi0+dXNl
ZF9zcnFzOw0KPiAgCXByb3BzLT5tYXhfc3JxX3dyID0gSVJETUFfTUFYX1NSUV9XUlM7DQo+ICAJ
cHJvcHMtPm1heF9zcnFfc2dlID0gaHdfYXR0cnMtPnVrX2F0dHJzLm1heF9od193cV9mcmFnczsN
Cj4gQEAgLTMyMDgsMTIgKzMyMjQsMTYgQEAgc3RhdGljIHN0cnVjdCBpYl9tciAqaXJkbWFfYWxs
b2NfbXIoc3RydWN0IGliX3BkDQo+ICpwZCwgZW51bSBpYl9tcl90eXBlIG1yX3R5cGUsDQo+ICAJ
CQkJICAgIHUzMiBtYXhfbnVtX3NnKQ0KPiAgew0KPiAgCXN0cnVjdCBpcmRtYV9kZXZpY2UgKml3
ZGV2ID0gdG9faXdkZXYocGQtPmRldmljZSk7DQo+ICsJdTMyIHBhZ2VzX3Blcl9wYWdlID0gaXJk
bWFfZm1yX3BhZ2VzX3Blcl9wYWdlKCZpd2Rldi0+cmYtDQo+ID5zY19kZXYpOw0KPiAgCXN0cnVj
dCBpcmRtYV9wYmxlX2FsbG9jICpwYWxsb2M7DQo+ICAJc3RydWN0IGlyZG1hX3BibCAqaXdwYmw7
DQo+ICAJc3RydWN0IGlyZG1hX21yICppd21yOw0KPiAgCXUzMiBzdGFnOw0KPiAgCWludCBlcnJf
Y29kZTsNCj4gDQo+ICsJaWYgKG1heF9udW1fc2cgPiBJUkRNQV9NQVhfUEFHRVNfUEVSX0ZNUiAv
IHBhZ2VzX3Blcl9wYWdlKQ0KPiArCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gKw0KPiAg
CWl3bXIgPSBremFsbG9jX29iaigqaXdtcik7DQo+ICAJaWYgKCFpd21yKQ0KPiAgCQlyZXR1cm4g
RVJSX1BUUigtRU5PTUVNKTsNCj4gQEAgLTMyMzMsNyArMzI1MywxMiBAQCBzdGF0aWMgc3RydWN0
IGliX21yICppcmRtYV9hbGxvY19tcihzdHJ1Y3QgaWJfcGQNCj4gKnBkLCBlbnVtIGliX21yX3R5
cGUgbXJfdHlwZSwNCj4gIAlpd3BibC0+aXdtciA9IGl3bXI7DQo+ICAJaXdtci0+dHlwZSA9IElS
RE1BX01FTVJFR19UWVBFX01FTTsNCj4gIAlwYWxsb2MgPSAmaXdwYmwtPnBibGVfYWxsb2M7DQo+
IC0JaXdtci0+cGFnZV9jbnQgPSBtYXhfbnVtX3NnOw0KPiArCS8qIFNvbWUgVUxQcyBwYXNzIFBB
R0VfU0laRSB0byBpYl9tYXBfbXJfc2coKSBidXQgUEFHRV9TSVpFIGNhbg0KPiBiZSBzb21lDQo+
ICsJICogbXVsdGlwbGUgb2YgNEsgdGhhdCB0aGUgSFcgZG9lcyBub3QgbmF0aXZlbHkgc3VwcG9y
dC4gV2UgY2FuIHdvcmsNCj4gKwkgKiBhcm91bmQgdGhpcyBieSBjcmFja2luZyB0aGUgbGFyZ2Vy
IHBhZ2UgaW50byBtdWx0aXBsZSA0SyBwYWdlcywgYnV0DQo+ICsJICogcGFnZV9jbnQgbmVlZHMg
dG8gYmUgc2NhbGVkLg0KPiArCSAqLw0KPiArCWl3bXItPnBhZ2VfY250ID0gbWF4X251bV9zZyAq
IHBhZ2VzX3Blcl9wYWdlOw0KPiAgCS8qIFVzZSBzeXN0ZW0gUEFHRV9TSVpFIGFzIHRoZSBzZyBw
YWdlIHNpemVzIGFyZSB1bmtub3duIGF0IHRoaXMNCj4gcG9pbnQgKi8NCj4gIAlpd21yLT5sZW4g
PSBtYXhfbnVtX3NnICogUEFHRV9TSVpFOw0KPiAgCWVycl9jb2RlID0gaXJkbWFfZ2V0X3BibGUo
aXdkZXYtPnJmLT5wYmxlX3JzcmMsIHBhbGxvYywgaXdtci0NCj4gPnBhZ2VfY250LA0KPiBAQCAt
MzI5Nyw4ICszMzIyLDE1IEBAIHN0YXRpYyBpbnQgaXJkbWFfc2V0X3BhZ2Uoc3RydWN0IGliX21y
ICppYm1yLCB1NjQNCj4gYWRkcikNCj4gIHN0YXRpYyBpbnQgaXJkbWFfbWFwX21yX3NnKHN0cnVj
dCBpYl9tciAqaWJtciwgc3RydWN0IHNjYXR0ZXJsaXN0ICpzZywNCj4gIAkJCSAgIGludCBzZ19u
ZW50cywgdW5zaWduZWQgaW50ICpzZ19vZmZzZXQpDQo+ICB7DQo+ICsJc3RydWN0IGlyZG1hX2Rl
dmljZSAqaXdkZXYgPSB0b19pd2RldihpYm1yLT5kZXZpY2UpOw0KPiAgCXN0cnVjdCBpcmRtYV9t
ciAqaXdtciA9IHRvX2l3bXIoaWJtcik7DQo+IA0KPiArCS8qIEhXIG9ubHkgc3VwcG9ydHMgNEss
IDJNIGFuZCAxRyBwYWdlcywgYnV0IHNvbWUgVUxQcyBwYXNzDQo+IFBBR0VfU0laRQ0KPiArCSAq
IHdoaWNoIGNhbiBiZSBzb21lIG11bHRpcGxlIG9mIDRLIHRoYXQgd2UgZG8gbm90IHN1cHBvcnQs
IHNvIGZvcmNlDQo+IDRLLg0KPiArCSAqLw0KPiArCWlmICghKGlibXItPnBhZ2Vfc2l6ZSAmIGl3
ZGV2LT5yZi0+c2NfZGV2Lmh3X2F0dHJzLnBhZ2Vfc2l6ZV9jYXApKQ0KPiArCQlpYm1yLT5wYWdl
X3NpemUgPSBTWl80SzsNCj4gKw0KPiAgCWl3bXItPm5wYWdlcyA9IDA7DQo+IA0KPiAgCXJldHVy
biBpYl9zZ190b19wYWdlcyhpYm1yLCBzZywgc2dfbmVudHMsIHNnX29mZnNldCwgaXJkbWFfc2V0
X3BhZ2UpOw0KPiAtLQ0KPiAyLjU2LjAuMjE4LmcxZWM5MDRiMTczLWdvb2cNCj4gDQoNCkFja2Vk
LWJ5OiBUYXR5YW5hIE5pa29sb3ZhIDx0YXR5YW5hLmUubmlrb2xvdmFAaW50ZWwuY29tPg0KDQo=
