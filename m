Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0783415665C;
	Wed, 14 Oct 2026 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974682; cv=fail; b=dMhiR4jt2D5GmohNI09sAFfXHeJ36OyLiCjIsKTI2AUXk1U0BaOnfA+zKPkXemzFBrJUthtjS14KblznA1Usqa7wd/gTr1BXoEuKvqfCndcmqDJdJNVk9yY9YfpM27Aeb2AYR4K+fEYpfSHjd60zstGv4KSWLkkEEru1FkD9mS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974682; c=relaxed/simple;
	bh=CcSB8elyvCi+p1mtt6572P5Aq3yd8cAvJuoCNeew4eI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8Oyv7c3GHoKKZsq/kNVUe9+VgEoMhx/rjyiXDzh4SY0wthz4INK6P1ib0ztr8jHa5TBBURiFGusfkCruGq+5wKjdQzoeHKzh3yYXs1tY5nllnCFm4zFaqaDJNWYBGkfy5aszCefmmpmACXY5jlS08lpWsqdmfRaJHRvw8MHsnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZuT2OGPd; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZuT2OGPd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791974681; x=1823510681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CcSB8elyvCi+p1mtt6572P5Aq3yd8cAvJuoCNeew4eI=;
  b=ZuT2OGPd12sJacGJkMmD/6uflbcqss6cv/JedA4FpqSFHWLN81e42lCx
   Xq3B2H6NZop4DcLY/+hrb/ywXwpkfzyHSBm6XZeauMkfCVUPksqdezNRo
   BZjkrmfBezllpp9XekG2hBv5H7Vwbb1gKW0Z7U+APj5tcDioyLlXNc4GQ
   mOdATIgR9lsKuWZnpxhFwg/sJ2GrHlDVG7MfwItNNy6/RH/rN8nCzjoYt
   cxkcgZgkl5noqYyOmq5T+608Dmm/Z2bTboISAOGtbvndcRRa3cISkAxTY
   chPC6BjgxJFGHq9Zc+u6CnpSr+IKfg+g0HXle6IxyZ3yYeaGSknRryu64
   g==;
X-CSE-ConnectionGUID: VLzYR6f5Qo6Is0itLVeAaA==
X-CSE-MsgGUID: E2GYqg+AQ96VOdCCYcFKoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="823096"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="823096"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:44:40 -0700
X-CSE-ConnectionGUID: vVgPEQ3YQaiVFZPuiTPU8g==
X-CSE-MsgGUID: rE0VmaGwRDWZxcbHpGxurQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1323170"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:44:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:44:39 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 03:44:39 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.28) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:44:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c7Be2v8yviWubEKFJAdIw0TKazXCP9AyRq9zTW8oaCJBcsqCnMts1/qzdk2ao2KaMisx9iESbu7qwMA6t2sBg9JOMUE9RBtG6lNG1EcFP3En2w2udoVeDfv1Sr7hjS/yuEXipPWTVo+OzjZudYngs/akCLnYbWer2BeZMe8G9/sSViYt+wcAITUHDy9hYGw3PiFH5Mj7KUJZ2Qjpyx6L/E8iwR1ztpKkpTs2Ymj3mcvk+3/Tn3ea8WWPQh2f8gDtTHqJ3GY6hxnbq15AOgKbZKvTPoR/2g54nIn9MyiM129Nd6BAaM0mL2i89hs/5h/jQDfM15GsrANgd2YjKahZqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcSB8elyvCi+p1mtt6572P5Aq3yd8cAvJuoCNeew4eI=;
 b=Xg6rk3qOD6e8tBlaLzOkJttntuWIQU+Yd3InB5t1QnXQmrZ1h/AfsZBfQALgG3a4hAS7KoS2/MmFnS8BR98ER7+37aSqw4JWysI+K4couBRo+wlRHXf7+s4AAdyz0kMtDwltPGv3QMstXj24mvd+ESI85zc0etJZP34lJ8YRCKd1CAHthex58NhPVNcB1PfQzXF6JUGbkOIS9zASCqdBsg8r0G48wyMKEHZFIIDzWI1ivU6VYO8xB96B8aK+vtvlXajop4B4sQi97tvcWdfmgN2ag4uqccm1gBTDEkyDZcOWuOlPGZOQ6gMe2OF2zqQXCaj2WIFOgV+ILmGgoFduZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::31) by CY8PR11MB7363.namprd11.prod.outlook.com
 (2603:10b6:930:86::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 14 Oct
 2026 10:44:31 +0000
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f]) by DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 10:44:30 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Josef Bacik <josef@toxicpanda.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew+netdev@lunn.ch>
CC: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "Juergen Gross"
	<jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Oleksandr
 Tyshchenko <oleksandr_tyshchenko@epam.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>, Manish Chopra <manishc@marvell.com>, "Rahul
 Verma" <rahulv@marvell.com>, "GR-Linux-NIC-Dev@marvell.com"
	<GR-Linux-NIC-Dev@marvell.com>, Shahed Shaikh <shshaikh@marvell.com>, "Simon
 Horman" <horms@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next v2 09/10] qlcnic: use pskb_may_pull() to pull
 excess TX frags into the head
Thread-Topic: [PATCH net-next v2 09/10] qlcnic: use pskb_may_pull() to pull
 excess TX frags into the head
Thread-Index: AQHdV2iPhjcjoTngS0CJA/3Rchai4rb84yFw
Date: Wed, 14 Oct 2026 10:44:30 +0000
Message-ID: <DS4PPF7551E6552197ECD6C84B156DEA4CCE59D2@DS4PPF7551E6552.namprd11.prod.outlook.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-9-8f2bd9bee138@toxicpanda.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-9-8f2bd9bee138@toxicpanda.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPF7551E6552:EE_|CY8PR11MB7363:EE_
x-ms-office365-filtering-correlation-id: 48291a1a-303a-4bf4-857c-08df29e02090
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|22082099003|10067099003|38070700021|56012099006|18002099003|261009223027099003|11063799006|4143699003|5023799004;
x-microsoft-antispam-message-info: KtGJvRT8zuZt1rfLaGSo+JQ0woxUGJSi9DshXb8fk+xmALoNiSStLih9qUkAP2n3DNJ/zjMmA7QwcwL5172oqrN/urHLWyETRICcOTUB/yBexPF36t7tPgjCdnL2p2j1VTfTasiS9HAd+fqPp+Zna31vmuR54cIYynHQgTOV/HB8UnKLG0v2CbCmqCzAVoPXMO85f0ff1kDRsN2CbNA//yK4uOBwmfwUg57bgTyiWhPs19rm7JThlRrR31OTm4HVjdIevQQTBn9wu5YCvMJzDDQy9CBy9OAAWAW3JUv0QPEAwsVtDv/zf8TDH1oOh5D4MoH584xg7i29RlkavwbX8G3CUKThFkGwj+LBtU5tv6SjvvUOX62c0JHZkgZrXjtShGaQYS3IhuvtjA+V9u2q24+nI3fOkE+uW84SrjCQVsq537L4iP+r2uE4URlx9aZEQw8t4hUm59aSaGFfzWKO74EMP+/zHCMolloYYG+Q43J84YmM1H1qaOuYVEsDF72mc6vry0Z67/DRh8PckJ0zCRD9F8kN1Pd8QG0Lp3O0Hq3G4no+QoxAvItqDRCfZCCXEf/MIoKGEbwsxMhIXeaNidFXW8wWKUQa5GZgAq+MCW0HMoO5j6CcPXF1d5F4TS4qc6YSfII/AsoY1wsMfNQXvZssBZnV4K9Wcmr81TFVu0ts4uhY8fEL3P/6xk8A/Xu4BJtQQNoUNXPHZSPFlWV2PICuO+LNrKXPFWwvLtjG58w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF7551E6552.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(22082099003)(10067099003)(38070700021)(56012099006)(18002099003)(261009223027099003)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFpPUTVPWVE4REFHUnA1RGl3SzBBRkc0dHVVTzVxYjM4WklIMmxCdFc3aUFR?=
 =?utf-8?B?Y21sNmxYdm14K1pyWjVSeE4wdS9rdVhQdEtHcEUyZno0MDZUbm0wb1NkejRY?=
 =?utf-8?B?OFJubXBMdHhEdXJKZU9XM0F5bW9KWjdyWlJuRjZ3em52NHd3UGN6dGJuZU1l?=
 =?utf-8?B?VkRwUUtoVGtITytRZlNEM0wxRFpRZVpKTnpBUlB5Ynk1R05pYkgvbzBWcFFL?=
 =?utf-8?B?bUI4Z2ErOWVDdytJajVyM1Q3am9UTlo0a3Y1eTF3bUFJcXM3RE1kWW9hZzdG?=
 =?utf-8?B?WjVEZld0UUIvK0JLK2NZbkx6TlVBQ3RyMHZvb2h2QlM2R0hlNDMxZ2R1T1E5?=
 =?utf-8?B?M0Q0REVaMFkyVUlBRkFRM2RCdmhmSTIzdEZzQ1VHTXYwUlpqMTFYQjRQVmw5?=
 =?utf-8?B?aVNudTM4bm5JcmI5bTVXZWd0U1hwbHBpRG90bzlvREFZRGxoc2JiRFJmcDFw?=
 =?utf-8?B?ZnB5anF6R0dnZldPV1M0ZUUyejd2YlZrSVNhUWd1MUFScEdzalNUS2RqL0pS?=
 =?utf-8?B?V2crS3FwWUxlRHJNTGlOcC9PZ3BvM2xaSHI3TlUvWG4zZkZaaG1MTjlrWldC?=
 =?utf-8?B?dHZvdlgvRjhxanhSVnZ5aXJMOHVERE5RTUJMN0t6K1MzSWE2RXd1N0ZnMkJE?=
 =?utf-8?B?VldFNzNTa25SZzRZd1JyV0lkbEdCcGlPb2hvbk9TMVlDWlNONERCMmNLMmVN?=
 =?utf-8?B?ZW9xRGI5bDhobjVFWjRyc3JqQm9nMDRpcnN1K2d5ZnBYM3JjUFRJN09uQXpp?=
 =?utf-8?B?WlZVVXliTzg2TlMxTGNaS25RRlRtNDgrMHdveEJvREVuWG5QY3A1SXBJWW56?=
 =?utf-8?B?ZUdkTnRtL2FzVFVLdjdWbFNSays5VG5jZTRNaTUxeHFxN0hwNXVQekJJWDBC?=
 =?utf-8?B?KzJMUEd6MWV2b2VZL1VPcy9qTVRMeWE2MFcvbUtmUlZrN3BkZDdVdlQzejF1?=
 =?utf-8?B?SnV5VTdjVGFEa3JRZDhhSmFQTHRkR1lEUi9JdGpCNzlBSGdRampybHZIT00x?=
 =?utf-8?B?ZGN1ai9sUFNEdHExK2xBRm5mSzQzWUlVY0ZuRDVWMFU2TUpFeitzbm1YRXV3?=
 =?utf-8?B?SjliR2xLY2NCZm9UZDNla2RtTWlxVWU3NmtXazREclhuQlpGWTc0SWt1Z2VF?=
 =?utf-8?B?SFhqU09sSGlDT3pHMHJLRGxxOWlXM2JsZEZDcVZseFB5YkloTmd2cm9LOVlY?=
 =?utf-8?B?VmFlOFNRUGlSM3YwT0RmS0dGSWNhbWRoUU9EMHQvMm0wRjA5Vys3UDhIblpB?=
 =?utf-8?B?VjhRUUpOcTVkUzNGbmRPN3pZcmVaLysrRzdKSnFTNll6RDRFMUI3QjFubWE0?=
 =?utf-8?B?VytwUEs0ZTVObG5FN1R5YUo2SE5sWjBGQks5NEJDLy9nbXJmR0dwOXBVcW5i?=
 =?utf-8?B?VHdUZi9WN1JJNnVoZXNNVnhiR1RaV3VVa0p4STlQcHB2NkZVTExuNjk1VGNU?=
 =?utf-8?B?RkJWTFozWmFxN0ZtejFmVzFVdzRkRUx6ZTMvaEpGc1lrYXhvTGFMV1I5Y3lo?=
 =?utf-8?B?Ky8wVW56cm1hMmZpcXh2UFR4S0ZIWGVaMER1ZGdrcjZZcVpLL1dFQ1Q4dnBX?=
 =?utf-8?B?WS9ZVXR6M3NkUnNFK3MvZVNpTm5Pa0EyT3FzV0VCRjArakRlZ0xlU1p4N3V0?=
 =?utf-8?B?SmM2OUdHcVNiZGg2WXQvZWk5cjN5TjlyRjNLbEwrV00vYjUrYUxCSW0vMU5w?=
 =?utf-8?B?K3RyUEpFTFZ5L3NFakhSczliTXJ5TjhITkcwMzJMUmNnRnlkUHpqK01POE83?=
 =?utf-8?B?N0wrSDZhYkVKa2Nva1VCR0hCZDZ2MUM0M25remRQMjZBSUljUkgzMk14VHh3?=
 =?utf-8?B?V3FoZTZkdVpHR3AvdDN3WmRXNGh0YXdHbHJTZklaTHNNZGJQdDNHR0xVK0U0?=
 =?utf-8?B?N2dhb0NoYnIyVXQvczllb3ViSkNuUUlCbHNML1NhMWJuYzQrMEFzVlU0VHRJ?=
 =?utf-8?B?WThTbFEvQWxTcEQ1aXVLZmR2N1liOGdqWDA4RnNqSEFHLy9WUnpoemlzMzhy?=
 =?utf-8?B?SlVNZzlyQUtDMlk1RlJ0dGhqdFdNcHpINTh5ODQzd1F6RExDUmphTzRiN1Fq?=
 =?utf-8?B?Z052MUdsWlVNRGJ5bnFsbnFpeVpQajVmWW9CSUllMUlYbWRuR1BEdlpBSy9o?=
 =?utf-8?B?YU04bUt4aUNVMGk3eDJqRG1oa1FQK2hmdXJuc1dRbWdGNGNPTlNYYkNGc0Mr?=
 =?utf-8?B?cUVTaTBBb1pMeW1KclhEZGlPUUtBQ09xa1c1Z29mMmVQQzNZOXlzckoySTFI?=
 =?utf-8?B?R2J2WHN1VnhzT2JhZTZvWFlBeVhxQ0xKWnRweGFjRnlEUnFjV0s3b2lGUmhs?=
 =?utf-8?B?WUV3ejQ5c3ZVSlJkakIrMjNJWG1VRWJ6ek9MSVRSaGgvOW43QmwrY2RaVjF0?=
 =?utf-8?Q?fPhIw2YilcSxHLZI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: vuDc7dpOLYqEKoOtmwtfDW2vKqLo5nJSNfLY2/J17u94cd97nkjx7S/KRllNDs5KF0Zcci7n1dxrlNZEMF2GRE0H/pFBz9kQtt3oJoYAfAAa2ly1Qa4QlqclNSNwvEECQzyzRSnlwx7EW0fGlfy7hqN3IwKfQUIBCfei/f/leBxWyehh5Yumc1RL7Zsu6PQNdT3jxhdjaN3hqDQDfYVcDLZMIzs9vyDBaZJklUqrYShsQWp+vwmJQCDSEArFnhHwgSySdIs9d8zILJEF9+VX+x6ykTbaWTccc7vffaMlXCTyKVspVJREedKU7DQOj8M+9MY25QQjevGVaveQl8P1sg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF7551E6552.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48291a1a-303a-4bf4-857c-08df29e02090
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 10:44:30.5264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHT+TQy104Mt9/A5GSLzdLkkF2tGoqGwZsJO29KfwwtOpZkrKvOCNhiXDK3lM4b0TileJ7yXsyr+fPHQ1Dl+TOWpTYp/e92V3UbRQ+9VwUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7363
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9zZWYgQmFjaWsgPGpv
c2VmQHRveGljcGFuZGEuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgT2N0b2JlciA4LCAyMDI2IDEx
OjAzIFBNDQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJl
bmkgPHBhYmVuaUByZWRoYXQuY29tPjsNCj4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBrZXJuZWwu
b3JnPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgQW5kcmV3IEx1
bm4gPGFuZHJldytuZXRkZXZAbHVubi5jaD4NCj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bnZpZGlhLmNvbT47IFRhcmlxIFRvdWthbg0KPiA8dGFyaXF0QG52aWRpYS5jb20+OyBNYXJrIEJs
b2NoIDxtYmxvY2hAbnZpZGlhLmNvbT47IExlb24gUm9tYW5vdnNreQ0KPiA8bGVvbkBrZXJuZWwu
b3JnPjsgSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPjsgU3RlZmFubyBTdGFiZWxsaW5p
DQo+IDxzc3RhYmVsbGluaUBrZXJuZWwub3JnPjsgT2xla3NhbmRyIFR5c2hjaGVua28NCj4gPG9s
ZWtzYW5kcl90eXNoY2hlbmtvQGVwYW0uY29tPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhv
bnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgS2l0c3plbCwgUHJ6ZW15c2xhdw0KPiA8cHJ6ZW15c2xh
dy5raXRzemVsQGludGVsLmNvbT47IE1hbmlzaCBDaG9wcmEgPG1hbmlzaGNAbWFydmVsbC5jb20+
Ow0KPiBSYWh1bCBWZXJtYSA8cmFodWx2QG1hcnZlbGwuY29tPjsgR1ItTGludXgtTklDLURldkBt
YXJ2ZWxsLmNvbTsgU2hhaGVkDQo+IFNoYWlraCA8c2hzaGFpa2hAbWFydmVsbC5jb20+OyBTaW1v
biBIb3JtYW4gPGhvcm1zQGtlcm5lbC5vcmc+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gcmRtYUB2Z2VyLmtlcm5lbC5v
cmc7IHhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZzsgaW50ZWwtd2lyZWQtDQo+IGxhbkBs
aXN0cy5vc3Vvc2wub3JnOyBKb3NlZiBCYWNpayA8am9zZWZAdG94aWNwYW5kYS5jb20+DQo+IFN1
YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCB2MiAwOS8xMF0gcWxjbmljOiB1c2UgcHNrYl9tYXlfcHVs
bCgpIHRvIHB1bGwNCj4gZXhjZXNzIFRYIGZyYWdzIGludG8gdGhlIGhlYWQNCj4gDQo+IHFsY25p
Y194bWl0X2ZyYW1lKCkgcHVsbHMgdGhlIGZyYWdzIHRoYXQgZG9uJ3QgZml0IGluIGEgVFggZGVz
Y3JpcHRvcg0KPiBpbnRvIHRoZSBoZWFkIHdpdGggX19wc2tiX3B1bGxfdGFpbCgpLiAgSXQgYWxy
ZWFkeSBjaGVja3MgdGhlIHJlc3VsdC4NCj4gU3dpdGNoIHRvIHBza2JfbWF5X3B1bGwoKSwgd2hp
Y2ggdGFrZXMgdGhlIGxlbmd0aCB0aGUgaGVhZCBzaG91bGQgZW5kIHVwDQo+IHdpdGggYW5kIGNo
ZWNrcyBpdCBhZ2FpbnN0IHRoZSBza2IsIHNvIHRoaXMgZHJpdmVyIG5vIGxvbmdlciBjYWxscw0K
PiBfX3Bza2JfcHVsbF90YWlsKCkgZGlyZWN0bHkuDQo+IA0KPiBfX3Bza2JfcHVsbF90YWlsKCkg
YWxzbyByZWxlYXNlcyBlbXB0eSBmcmFncywgZXZlbiB3aGVuIHRoZXJlJ3Mgbm90aGluZw0KPiB0
byBwdWxsLCBzbyBpZiB0aGUgZnJhZ3MgYmVpbmcgcHVsbGVkIGFyZSBhbGwgZW1wdHkgaXQgc3Rp
bGwgZ2V0cyB0aGUNCj4gZnJhZyBjb3VudCB1bmRlciB0aGUgbGltaXQuICBwc2tiX21heV9wdWxs
KCkgcmV0dXJucyBlYXJseSBpbiB0aGF0IGNhc2UsDQo+IHNvIGZvbGxvdyBpdCB3aXRoIHNrYl9k
cm9wX2VtcHR5X2ZyYWdzKCkuDQo+IA0KPiBBc3Npc3RlZC1ieTogTExNDQo+IFNpZ25lZC1vZmYt
Ynk6IEpvc2VmIEJhY2lrIDxqb3NlZkB0b3hpY3BhbmRhLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9xbG9naWMvcWxjbmljL3FsY25pY19pby5jIHwgMyArKy0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWxjbmljL3FsY25pY19pby5jDQo+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FsY25pYy9xbGNuaWNfaW8uYw0KPiBpbmRleCA3
NjFlZjNiYzgxOTMuLmU3YWI1NTg2Nzk4YiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcWxvZ2ljL3FsY25pYy9xbGNuaWNfaW8uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9xbG9naWMvcWxjbmljL3FsY25pY19pby5jDQo+IEBAIC02ODIsNyArNjgyLDggQEAgbmV0
ZGV2X3R4X3QgcWxjbmljX3htaXRfZnJhbWUoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gc3RydWN0
IG5ldF9kZXZpY2UgKm5ldGRldikNCj4gIAkJZm9yIChpID0gMDsgaSA8IChmcmFnX2NvdW50IC0g
UUxDTklDX01BWF9GUkFHU19QRVJfVFgpOw0KPiBpKyspDQo+ICAJCQlkZWx0YSArPSBza2JfZnJh
Z19zaXplKCZza2Jfc2hpbmZvKHNrYiktPmZyYWdzW2ldKTsNCj4gDQo+IC0JCWlmICghX19wc2ti
X3B1bGxfdGFpbChza2IsIGRlbHRhKSkNCj4gKwkJaWYgKCFwc2tiX21heV9wdWxsKHNrYiwgc2ti
X2hlYWRsZW4oc2tiKSArIGRlbHRhKSB8fA0KPiArCQkgICAgc2tiX2Ryb3BfZW1wdHlfZnJhZ3Mo
c2tiLCBHRlBfQVRPTUlDKSkNCj4gIAkJCWdvdG8gZHJvcF9wYWNrZXQ7DQo+IA0KPiAgCQlmcmFn
X2NvdW50ID0gMSArIHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7DQo+IA0KPiAtLQ0KPiAyLjU1
LjANCg0KUmV2aWV3ZWQtYnk6IEFsZWtzYW5kciBMb2t0aW9ub3YgPGFsZWtzYW5kci5sb2t0aW9u
b3ZAaW50ZWwuY29tPg0K
