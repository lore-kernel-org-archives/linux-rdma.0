Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793899774;
	b=gahK9mD5xQq1wu8StBrIM53EniTeqXAb0cXzReK86eluAkJEYV/2SIt6R3AgZ6tbwt3c
	 Lv5iFMlQHA2X7iYEOpHy4Ti3f5nOmEuPR/38X+G72fStL91QBYvceGXtqIXp6NBNH2KZJ
	 EjyffRWyJD+aewbqKdZmzUm99RtSvciIgv3fpj+RgoGsCgaBYwSDaApRea98dyZ7PpJko
	 F/mo3+upO17QVGh5Yg7WXdCTmCHAyhSIvjAKrmDxrpuJ39oSKQyLSydF8rj1k2mQ5PmGA
	 DTN2O9ks/NU1msX4BThfvNfZ/WEAnA7JKxIVZgM6fTeU8uil+zEvxYejOjLRGbhMv+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899774;
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
	bh=vcWEnmQtZ84D8svS1Xvwyka56+hsvLpnXBzaRYes8Mg=;
	b=NhCqkkSkureAkcqAE1roSZk+tMBn+eSmAuizGNbGKee4rQj9Xcaq6GX3iLGf/E4i6AI7
	 70BXqBCtRtk7ms7dpnXVw6WR8QwxzQ/wamV7l7rdq/Pqns1n3nq+eoRFfX7u0B6tiBSNT
	 ESNmzVjbs8Iq2XfVuKThcvwrd5lkjFX5aUWFEDOnF4d+SOyJm2/dEmXw4zd+lBHxXQl83
	 xgU5C/wbnq+xUWsDz2rzWaU79V9ahaW1gZGpXX+6PuhDwh3GJ4dPO9hJwXIfHZhbS+P8V
	 4MRJRZfBgkJfprHADRjjb5aX+CKvhrelBXgyngZPAs7skcEICJiz3W6dkbqfR+f11yg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ibpB2Oow;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350D4606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 17:29:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 350D4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ibpB2Oow
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793899773; x=1825435773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vcWEnmQtZ84D8svS1Xvwyka56+hsvLpnXBzaRYes8Mg=;
  b=ibpB2OowMT06OQjalkwKdpaWXeTRwgCV6fuQDtq/r2bhQPcvVd86N/S3
   Sg+qFFz2uKBjoHodZst5s8J+tGalnRfVjIdSWy+V1k2ku7IEgZDlS1ucQ
   jdYr/ffUwJUP51xoHgQSJAuAqvZ5Qb21zpcJBjhN3PIl29YOs7ym+6tfr
   wehKSdX4glGmOBc4KHe5+XLEX0przEozCFIllNJxkynuPpCoeSx6+P4Z4
   UachSja8+9Q60UGyoEG50NirXKm4lYgXoaheOmIz08YRqH8apwICn64hb
   sU+MzdMaj8zBELqxB8/dwCIdzEYTSH4T14wNXNZL8kxwVVeEwTXfYHc21
   g==;
X-CSE-ConnectionGUID: QKRdIpwTQ9ikbaofQjKvGA==
X-CSE-MsgGUID: fBFor2Y3S0iIFc8l4SxnNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2716625"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2716625"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:29:32 -0800
X-CSE-ConnectionGUID: w4w7SVzlQja65Kxq6uOraQ==
X-CSE-MsgGUID: oBvtHWpEQb2pEqHszxMxpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="6955426"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:29:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 09:29:31 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 09:29:31 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.47) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 09:29:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DzDjyqaA8eX/XBHJskf/OMOisy+HC5lhnWiQ6Xu/Fxu45NMSvpiI7PIJKbccEQfJiNFt1usL1w3km8ZZmqxsuLSUEvafO/5D05Zv3dPTUcxIswVJqRQrF74nWjrNQTj9+GkNAPNZUO0WVjLIOqV9zMQv7JVjP2icOPA0nZQizgRntQkJxY5jeQiAgya9zFGTffWx2NOi6js8YVmF6EWvpHXr5ZZA6ID6n85wiMgKC20YolACvXW0Z016NcmukFdY1XWrejwahqjvze0FFTLlZyi/S1bHDsG//QVSFCi0TGqxZMbvdmnisRwrYynKmXOSdTDPJnRUAbsAlYSXtl2S/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcWEnmQtZ84D8svS1Xvwyka56+hsvLpnXBzaRYes8Mg=;
 b=b2KI60i85molxu2FEXr1B5M0pyuE9FG6UYhJ0rvI0BxUtLv2jeR/J532MHrfIAUPqHLIwv93ARMUA88fvS8OLnObhHE+hmqzCKmtfg0ukXHmwbyws2Y5+Mmc4uH/Gu2p8Ee3WvRD3fC7NjWMCigBuEnNdU+5kEv6HF81fK657YyOx2y4v07Rb5y5eEHug1KuBzSpW8HRtPTRn66q3rV2K6dnZtzRCZlzRUJXWXl+gfrJk5mbV16ZRj89ZnzIcngQwpf0LmNyiwgWmCG8oimnMyTtwx3UZpOG+r/g+9utpRLoFKgsbZKKjNwgElJqWrmgc4R3hiyQkJ8XrwRNfdIDRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB7727.namprd11.prod.outlook.com (2603:10b6:208:3f1::17)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 17:29:28 +0000
Received: from IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875]) by IA1PR11MB7727.namprd11.prod.outlook.com
 ([fe80::a99c:3219:bf01:5875%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 17:29:28 +0000
From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
To: Jacob Moroni <jmoroni@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"leon@kernel.org" <leon@kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Bhat, Jay"
	<jay.bhat@intel.com>, "Lacombe, John S" <john.s.lacombe@intel.com>
Subject: RE: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Thread-Topic: [PATCH rdma-next] MAINTAINERS: Add Jacob Moroni as irdma
 co-maintainer
Thread-Index: AQHdaJU56tplYzfwTkSny7IE5cUVArcfxPJw
Date: Thu, 5 Nov 2026 17:29:28 +0000
Message-ID: <IA1PR11MB7727B6B57BFA2E5730B474E3CB772@IA1PR11MB7727.namprd11.prod.outlook.com>
References: <20261030173556.1873811-1-jmoroni@google.com>
In-Reply-To: <20261030173556.1873811-1-jmoroni@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB7727:EE_|SN7PR11MB6993:EE_
x-ms-office365-filtering-correlation-id: c5ca8eb5-e126-46fa-a6e9-08df3b62583d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|38070700021|11063799006|56012099006|3023799007|261026140227099003|261009223027099003|261028144727099003|261102123227099003|261022105027099003|261021121427099003|10067099003;
x-microsoft-antispam-message-info: ulPo/DMGXKuPeIkpIu66GkgncEB1ma4wHxNZouX4Uj8XTzEFX51TJBuQaqnS8tSzozsqRN2R/xDK/AWO4XQ2DlZJ1oNTVarNnu1p4pYnnx96vS3Yg8BG2JiriyXHIgBHkYm6cVv58R4nYRuxz0PjDuNReSaUqscaLuY9GLvHwHOaDrSRSho1ALRk9RhUSwGMiR1tfmMUjcVdDz8AYOKBqar8th5mxKusHpIV0BJVktpe8ZhxoUNxThl+KrY+i5KFzFYQMeOJJWuDQN/hb8cvG3z9a/8MXmdMAVBu8HXz7caw0nqAMIVg58xxTs1pDosdFOePVZRa2ajQGTtzwnWvMA8Q5c3f/7NyxXiVzInVbGpKtWAOCglmcEHxqLf+5g6xYVmjdGxsF3vIYBqpPUdBtwMqT0GW+F3GSB58dWNJs5gzMNNjrJRVYZ81FO80N7GHNqvWV3/AuuW7MkxVASzZgIe4mDNf5eFtUee5ZWCmtL1DDHrmAkXuL7urBWxnvGp98NfesogxIX369kUR7IkY/Rl3ONYO8V6z/IDC45NEuntSNVZQ/n6OtrxfASQxwiHHnv0bAcuwwzSzFWvXi2WC8tkI2cJdRK2LU9S6kMnxiD1KH8fEB4PtfSUvLKx27mWlIZl9Iu9fp5Hhazlp2wOcSaZgUuden2r30bxhm7nE3i+hwGi552fz30NLOoox0PH2n4BZ3dzS3T+0hUbIE7EMS5TOSR6Mvt07rw1v597f5xo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7727.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(38070700021)(11063799006)(56012099006)(3023799007)(261026140227099003)(261009223027099003)(261028144727099003)(261102123227099003)(261022105027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUh5MUZJUXFzamNiZ3ZldW1JU2grMWNZZ0xIR2lxdVVTUWQyTkppS1U5ZHkx?=
 =?utf-8?B?YWpoZ1Y3K1BJWThRS0czWEY5K3pScmFkbEhhWlpSR084Wmc3dmQwUE5Gdytl?=
 =?utf-8?B?R3NSbjJ2Mk5ISkgzRFY2VndXN29UdXNlT1NHTFBkTFZiZDZVMmE4cmNNN1Q5?=
 =?utf-8?B?TEtwR2pxMDVBNEw4WWg3TjdxWndpTnJ1MXlHNzN1Uk15M00rTE9mdnN0cGVZ?=
 =?utf-8?B?QThXT1pDLzRpVUs0Y1p2UWlUay9ZUHJGZkQ5blRaOTBacFpyV1M2OFdZODlE?=
 =?utf-8?B?SFd5MkhxZEVFTllPUTYxMXBVb3F4VE9tUVNIcGl5TFNjZmtPN01vdXVzb2Fm?=
 =?utf-8?B?QkYyWnBEVXZIUU5CZEp1RjQycCs1RDQxOUcyTVRsN1VZZitzRFU5OXBCL0gr?=
 =?utf-8?B?YmVuTWtXVnlEWHFKanlDL2QvYU1HNWFBbzViTCs5c080emFkNUVUT21ZOERL?=
 =?utf-8?B?eFdMejA0QVowYk1EaE9jbE1WVVpqTGN2OUozcmVmWTVDZkxpT1dPVHBHR3Ns?=
 =?utf-8?B?RmhHT0ZETW1pamVuam9MdytVMHJJcXpzMXlYL01TNEkyMUZ0N3k4UldtWXY4?=
 =?utf-8?B?ZjJXRm5JQ2hoQlZXYldWdzJBVktsbEVQSkNGemRwNE1laE0xT01NVzFlUWR3?=
 =?utf-8?B?eVhYMERlVkpNUys2b1lUQ2tmbThiNFJoenBVeVFDV3BESEhSV1VsYnR5SE9o?=
 =?utf-8?B?YTAwUkNXTzVMcGp1RWtEVE9YaytNLzQ2WUFZUnoydHJJVWFnUTdPczBnMUl2?=
 =?utf-8?B?MlZGWnM3WkZUbk1BWE4xT0xmVHFVQmE5Y0VXTkk1MFllTXJmMTA4TmNuSHlj?=
 =?utf-8?B?WVF6YzhsbUNxaVhhTXU0ZEFVbll3aDBWVGp5VWZ2NjVwZy94cmpaM0ZkTnY5?=
 =?utf-8?B?aThySDJhVXlMWnNMbnNqdzhoc2o4clI1Uk93anMvRnlLNVlxK0Z0ZkNxeHdk?=
 =?utf-8?B?cVVIWlBCY3NhOXpxcS9BSmdGQms0NjBIc0xITzB4MHZDSXFCMjh5MEo2c0pT?=
 =?utf-8?B?ZG9aK2F1SnRyYVNNRmJrQmdyR0VMK0w4eWo0NjN1ZlRUVXJlRDN4SzQ0aVlh?=
 =?utf-8?B?TnJCc0lmei95Q0h0MHpmcVdUaWpiYTh4VUpMTDBRWUFkbWc0clplTzFFQUdl?=
 =?utf-8?B?d0lQOE5ZdWlZM21OVnh5b3dFQTNzU3FhMUhBNFQyNnFmN2JxVTRETm8zajdt?=
 =?utf-8?B?dTNyL3k3WXgvdFgxcm5VSEU2YWJDNzRabVUxOVlEdHBZN3p0V0NiMTZHamdq?=
 =?utf-8?B?am1wa2NxVmJIb3EwTzY0aWJMQnFHU1J2RVVaeG9vaVpBUTlKbzZhVE5pYXJs?=
 =?utf-8?B?ejlhcXVIbnd0SitkWm1UVHlIOGtkMjRuTkFRSC9HMjI4VU5PenB1ZHZ4djJq?=
 =?utf-8?B?WlhucnNGN1YwcEI0VFpXTy9WdjEwcld2eEs1YWtaL2ZQN0lwK3laZjJTakV5?=
 =?utf-8?B?Mmw3b0dzeEg0SE5weDhrVnBoV1p1STdSenBMME5BSGJGMmRYK2FGbVNiajA2?=
 =?utf-8?B?T3U0SkFoYW12MExLcEVuMTlRdEVueFVLR1ZsNkJ6b1NubmxuTjFEVzdhR1l3?=
 =?utf-8?B?S1pxd3N6dGJRYUc4bHZiV3YxTlV0V3dTZkZlTWJpZ3N6MmNxcjhQZDVXM0tP?=
 =?utf-8?B?c0pNUWlEcW5HNjRvaVZ6YWE0Y0dHSXdwaTRKRzc1R2RvL0U4WDNwTm9jNk1K?=
 =?utf-8?B?S3FlU0hmVmMzVFdPNlZtaXFDci80cjBIL0U4YW5aaEdGUjdTVVB5SnFNQ0pI?=
 =?utf-8?B?T0FBTkp5eEZjZ2FTdXVyd3FCM3I1Vjg3V3RJMVZSVE9PUmZtQzEzdFl5Wmgx?=
 =?utf-8?B?SDNtL2V3N01udDFtMEttalZLbXlBd1dDSzU4ZnZUWVZLN3F5WXV5Qkd3a0hU?=
 =?utf-8?B?c05oT0lXbEtjaVVwT0R3VTJPcDhucG9rT0ZOODRHQkNwelVqL1hwK2dHZWtR?=
 =?utf-8?B?aDhUUDdwbTRkVkJMbS80Qy96aHE1RmJDbmRQWERaV1JrZWxnM1Q1RDI0bmZF?=
 =?utf-8?B?RmVNUlRXRGthWUxLUHBOUzRhOE8rU2ZlZnJXYzN5TzNzR1FKUjg4VlVwUUpR?=
 =?utf-8?B?Z295ajZjYlE5YmFYNEJOSnBROUtUT3NteHpuMmozNVFLZ1VaelZTUTlOSVRn?=
 =?utf-8?B?UVZ3SURUTFU4Y0pHZDh5WFpTT0h6NzVtMnJ5bHRvZHFsYStHak9zRkFObFpu?=
 =?utf-8?B?Vk5WdmVnREkrQlRwYXk1b0IrWFpoOVB0QzdUSEZ0NmxjbUozbXhhVGE5N2dT?=
 =?utf-8?B?UC9abDBxWmFLcDczOW85SXdFWUxiZFlheWJJaXdoYjh2N3VoTDFEYnl0QnFx?=
 =?utf-8?B?akFpck1HTEtoWjgxQ0ZVN2lZOWZ2MkMrcFA5RndFL29wUkRoRXZwUT09?=
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
X-Exchange-RoutingPolicyChecked: c2QBC4EzH2kwkbst9evYWKiD1bwjRRzWoH1BUOfhCnFd+/PXxuPIgUENLV/qGXUb3M0EP/rFLORPNvkgXJZVeTMSdVZqf2Z2pN6NpcqcK5hl1Y0YqzsE/J0h2L+bkzWNbVQjV2f8kaqLb8en+A5BXfOL+YprB7oZ4c6FRgj9k/u6hNigeTlniCDDOIJLPTDIOkTUQas8+XO61mgnu0sC+f8jml4BdSNasiEiGEgK8qzoiHEf8igqq9VxDn7GWKn7e093IHC3BPXmQgs1S4E3k0eoatmiZp+yWD5Zs5qQYU1at9wBovDrv77FWRcwpi1uJDRhPmIt7y2NX7SQMyWpuA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7727.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ca8eb5-e126-46fa-a6e9-08df3b62583d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 17:29:28.2631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6m+rnz9C7YdSzj/5adMwyXezOHUt2vaU/1iyD4T826sVkvyyF//CWML2FkQQZ6DQbx57EQZooWRaAa+fofOLf3DHVtGHwpT0dtEaQGuiAcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFjb2IgTW9yb25pIDxq
bW9yb25pQGdvb2dsZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAzMCwgMjAyNiAxMjoz
NiBQTQ0KPiBUbzogTmlrb2xvdmEsIFRhdHlhbmEgRSA8dGF0eWFuYS5lLm5pa29sb3ZhQGludGVs
LmNvbT47IGpnZ0B6aWVwZS5jYTsNCj4gbGVvbkBrZXJuZWwub3JnDQo+IENjOiBsaW51eC1yZG1h
QHZnZXIua2VybmVsLm9yZzsgQmhhdCwgSmF5IDxqYXkuYmhhdEBpbnRlbC5jb20+OyBMYWNvbWJl
LA0KPiBKb2huIFMgPGpvaG4ucy5sYWNvbWJlQGludGVsLmNvbT47IEphY29iIE1vcm9uaSA8am1v
cm9uaUBnb29nbGUuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggcmRtYS1uZXh0XSBNQUlOVEFJTkVS
UzogQWRkIEphY29iIE1vcm9uaSBhcyBpcmRtYSBjby0NCj4gbWFpbnRhaW5lcg0KPiANCj4gVGF0
eWFuYSBOaWtvbG92YSBpcyBjdXJyZW50bHkgdGhlIG9ubHkgbGlzdGVkIG1haW50YWluZXIgb2Yg
dGhlIGlyZG1hDQo+IGRyaXZlci4gQWRkIG15c2VsZiBhcyBhIGNvLW1haW50YWluZXIgdG8gaGVs
cCB3aXRoIHBhdGNoIHJldmlldyBhbmQNCj4gb25nb2luZyBtYWludGVuYW5jZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEphY29iIE1vcm9uaSA8am1vcm9uaUBnb29nbGUuY29tPg0KDQpBY2tlZC1i
eTogVGF0eWFuYSBOaWtvbG92YSA8dGF0eWFuYS5lLm5pa29sb3ZhQGludGVsLmNvbT4NCg0KPiAt
LS0NCj4gIE1BSU5UQUlORVJTIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQo+IGluZGV4
IDJhNmU2ZWM2MjllMC4uNTI5NTJiMWM4MzE5IDEwMDY0NA0KPiAtLS0gYS9NQUlOVEFJTkVSUw0K
PiArKysgYi9NQUlOVEFJTkVSUw0KPiBAQCAtMTMxMTgsNiArMTMxMTgsNyBAQCBGOglpbmNsdWRl
L2xpbnV4L25ldC9pbnRlbC8NCj4gDQo+ICBJTlRFTCBFVEhFUk5FVCBQUk9UT0NPTCBEUklWRVIg
Rk9SIFJETUENCj4gIE06CVRhdHlhbmEgTmlrb2xvdmEgPHRhdHlhbmEuZS5uaWtvbG92YUBpbnRl
bC5jb20+DQo+ICtNOglKYWNvYiBNb3JvbmkgPGptb3JvbmlAZ29vZ2xlLmNvbT4NCj4gIEw6CWxp
bnV4LXJkbWFAdmdlci5rZXJuZWwub3JnDQo+ICBTOglTdXBwb3J0ZWQNCj4gIEY6CWRyaXZlcnMv
aW5maW5pYmFuZC9ody9pcmRtYS8NCj4gLS0NCj4gMi41Ni4wLjMxNy5nNDU0ZjgzMDJlMS1nb29n
DQoNCg==
