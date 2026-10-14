Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5E4EC649;
	Wed, 14 Oct 2026 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974657; cv=fail; b=Olw54C7K74cL96rWrlZvV1q/BCEzJ00u4+AEsQ20MnyUK6AO+z8FdSLhZeL+5lptWNNNSVWtV7wNcUtc/9s3XxG57a/rEKkdpbY24cyRJ4i3o/kXYqPNZbJvo5njAU+oPKwy6asjBd9sddhE2Qwin/Z4McT2jZbiWuSq7aMM8xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974657; c=relaxed/simple;
	bh=oQzRNnK5vwyyQeKvdyHpRRup8MZ7y+Sp/h2zbPxwwgw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tBPmpkqIVrEUcaxgqMsMx0syUn1NkawjyTtIRIj+a6Ct0B7ZrYf3s3vGomMXcrd65ieDafw1FdnxiSXH2sTjt1sVLkesnAliYmQAjekOb4ZtqxIMm466IiqDsId1p3BSpfsDdT/nIquhckeYGRX88uj/JYkIK0644k9SXaBmDE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Th5tWNcN; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Th5tWNcN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791974654; x=1823510654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oQzRNnK5vwyyQeKvdyHpRRup8MZ7y+Sp/h2zbPxwwgw=;
  b=Th5tWNcNgR/Om0nzodeLMKhChok9kqsXqIHxOaLVFMQ7+La1pTwXt5DP
   PntevMWXPmT7yzKWypbIEmtlY1eCtWGhnXGezqBuv5ltqp42egqRT10+I
   2DFdnmP060C0XIelXRuQZQ22KDLIJqEFaPV9M9ayU0cr3D9Boj1HfpISU
   7Ppph/CBd74SrXy+MH+HFBuLV6XIX3ldQDI4yQznbvg/atJx9oTBHbEHt
   lOyPBcGH6oKqoj+88RdZkUSCqTPZKZofkY+zug+pJOqXWFeKpZopLXoC5
   1fLSNjmIDNRikoEr/GjljOCkXVM6iXZCW48DSbhAOSIRqcldH6aC1MHqG
   g==;
X-CSE-ConnectionGUID: 72TzEmz+T6uzv9yP2DISUQ==
X-CSE-MsgGUID: Jj9LHZHDRyWuzUDjUcS5dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="604227"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="604227"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:44:14 -0700
X-CSE-ConnectionGUID: ZJs0++6JTlmwEHKsblb/2g==
X-CSE-MsgGUID: af/RwsDdSiqXx/pZi6+1bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1721542"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 03:44:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:44:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 03:44:12 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.49) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:44:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHWu3wxewyIRfdfrrjQZnhd0ls4DiKXA4xMSz73oUh8630F5LuMm1QlOrVtaMcfxtQ/TSPhFRIqWvtRzxFpPYjzXV1CDSVdlKWeii6/uGWhdA1RKG4/m2Ce782FoVPoAAb+f1PekwojvVGzg3Bcy6WbtMZX3dfbFNcl0oHMJs7zmjNHs+VZF5VvZbBPZwzENJEiLr88meCQI/8DsGtoTrTc0ngsFzmNo2jCuuipMRSekhdrkbnuqXxCFtJVWxJM67ojPVjw5A5UkY2VPgNoAD7ykbWZyEx4V/VfduSO5AvZtnEkU8brYbKlIytKkzOfFRQ3qZGpWDSvMQA0KFlARxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQzRNnK5vwyyQeKvdyHpRRup8MZ7y+Sp/h2zbPxwwgw=;
 b=r1IxJFVJNOkVLAWWosFbHwdSsgUh7BJfAqn8N8NryWskzEsQbSJJO7/LZwXhRMbY7KfRKRLgzAF1zRBG3Y3esAAIHwE2hzV5MBFAsjTh6iy3hx0jQUqJMp3mumf0nFvh8h/7vL7gtvP+It8UrfTHeUhVpyJ0CdBr+kcR5hibi8vHFXDeIYYM44VpmQll1sc6tItWt90wvpBVBkvLpy1e5hiynJDnSZhCJn/F6/ZhyGoh1T6s5CvXXO73kQ1YOzkCNHzTItSBckI8S1z4b3d8bE7P7gXn4pgxGPjewScDWGVmK0ZNs1r9yAeWBAmk0ZKumb6B/0eewouk5hX+X7/Q0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::31) by CY8PR11MB7363.namprd11.prod.outlook.com
 (2603:10b6:930:86::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 14 Oct
 2026 10:44:04 +0000
Received: from DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f]) by DS4PPF7551E6552.namprd11.prod.outlook.com
 ([fe80::ac6c:1d96:c766:799f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 10:44:04 +0000
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
Subject: RE: [PATCH net-next v2 10/10] net: skbuff: don't reset truesize in
 skb_condense() if the pull fails
Thread-Topic: [PATCH net-next v2 10/10] net: skbuff: don't reset truesize in
 skb_condense() if the pull fails
Thread-Index: AQHdV2iQSwkJ8X/q3kW4y1x3MSmxj7b84vew
Date: Wed, 14 Oct 2026 10:44:04 +0000
Message-ID: <DS4PPF7551E65522ED9D6342B485E69A843E59D2@DS4PPF7551E6552.namprd11.prod.outlook.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-10-8f2bd9bee138@toxicpanda.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-10-8f2bd9bee138@toxicpanda.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPF7551E6552:EE_|CY8PR11MB7363:EE_
x-ms-office365-filtering-correlation-id: fa2586c1-0cc4-496a-db0a-08df29e0110e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|22082099003|10067099003|38070700021|56012099006|18002099003|11063799006|4143699003|5023799004;
x-microsoft-antispam-message-info: wfkMq+tUFuF6efn7D9aqeCCJn9L34GIrjDEXG4+7XcfM0QY1temnvI3PyKh8cuZkv0dxjBhhMtnFl2R3J/UdXMPvBr9Vv97rfsXoE2yWAprjCjZ38SVsyXqGKZLpdUEorM23/8tO3Eqc4F0hhgZG9vvlo5lX++4Xf77UI4ELH8lA8+9GBdRTIBwRP+mhtQNoRZ6d4iv+CG28M9syBZvynTJButP8HrPplKHJV0O9MQBs//vV4XoN4bnxjaNMyw3sZ5luIXk4iYi7RsSu2r37Uq1jougwliWWNLagZx9E6jBn4V/ac/+Ghe4DhfhjH2sv5Z6GYCteNSElsD4CUzzhP1MAKJYTDwTiPJwwht4v4p5u7rhxYgzvEDIpf/XRR8W+lRSameucfOsF829ZvOgbOUfrk63ipl5dorK2fyf/wkjVE0PZIECuEmi04B3CkJCUOS+2grv4yFpa/uhZFEcxFjaz1I7mpAVsXv78FTtPzBnlBxT0g5jWZqrXKbManC5gYFrNKk50UEaS2GgSAWKQMaUM9fpr76w4iAlKyOqVRuQtKkuW/2qES8Z0SfHkWVoJCpV9KtvhBZQmGLcO2BeSE65BUSpY+6oKoEhEJ3pb999srhYgk67ppTT/jdviI8F+f8UWq0CKaCcmcUy4K3LIRvlpcOd0BKRO5BZJbalYMiphjp3YdbWyUpVvVCMjvuS70rRivNYlmQGIi438PYEo/ER/6YSqLf68W4qf9vrab/w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF7551E6552.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(22082099003)(10067099003)(38070700021)(56012099006)(18002099003)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzhDU1hVVTQyb1JvSWRPb0hwZWVWRjIvWDIvckR0WWdYNUkxSnhMc0tFb1h0?=
 =?utf-8?B?SUZvcXBiRUl3MTk1ZjA2c29DNVRKeU5idGYwNnN3MHJWdUhURHNjWi9ycjkv?=
 =?utf-8?B?dHVzb25DTE5Talk3NkUyRDg3K3ZhS3NMY0F0Y1FWQWo3dk54L29hTEd6WVhE?=
 =?utf-8?B?WEdqcW0vODVUYW14aE9OY2lvUGVJTldyQXlZNlZTOUEyNGE5OEpSa3BJWlBS?=
 =?utf-8?B?OTVmVUdYQXdLeW5HUytqMU1SeExkSWJsbEdsZ3pUYnhmWThtYkVVNzZyVTlv?=
 =?utf-8?B?Zk5iY3Vxa0hER3A3dG5Za0hISjBLUUdKK0E0QVhIc2RydGtZM0EyRUorSjlL?=
 =?utf-8?B?aTc0c2orNlAzSkJ4WnQ4RTJKb29hM21vOElYUzFiSnZsOXdVVnVCbWcvMzBX?=
 =?utf-8?B?RTkrWWRGM2t1eXphUk1BcUZZei9sbGkwc0NQdy80VnpHV1REUXB5a01kVXha?=
 =?utf-8?B?eDVWS2diZjE0YTZ5dWl6NmFKUUwrMUoweC9KbGU2TlhCNzN5VHgxbkRIRGhQ?=
 =?utf-8?B?Z0w1RjlXQ3hDQ09wWE5DL1ZDVlFnQTdWbmcrcjltbGt2bm1CdzlZYnBsMFZY?=
 =?utf-8?B?VW12THJHR1A1NmtCbzlMUHd4ckNMVFpVN1B3WGFaZFVIaHlEaHh1UVB5NW9C?=
 =?utf-8?B?ZGRhUm9jNWMxMnVFaVpnbjhGdmp3dDIrUS9mUTJCSEJ5L1pnaUJpMUxZNjRU?=
 =?utf-8?B?MnBkOXpaS2lSRXRhSTV1VkZ3d0dxMmN3dExRZS9vQklVK2hnUDc5cnJiZTUz?=
 =?utf-8?B?YlhiUWE4dXdNWTI4SlY2M0R2VzVJbmw5S1ZJMDEzcUNxRjZHT1dCTFlVSERh?=
 =?utf-8?B?T2NVT2haclNHakV5WDJRVERQbmU5MGhHa1c0SmdvMnM2bVlPcVFyNUNCN3lo?=
 =?utf-8?B?N1RhTlYxOHk2SEJSbkVPMmJGaUZYbHJPTmp3M0pvWHBLbkMyMnZIK3hOOEwy?=
 =?utf-8?B?RnArUWlLSHlPRXpWaVJ0RXFEQm9wNFVvclBpWjh6bmtrcEtzdU9wREw5RVZM?=
 =?utf-8?B?NTZSTDVOSlU4RW1RQk51VGVUVGgvQmJYUGhieTZGL0NtTnN6NzM4alBDdVgv?=
 =?utf-8?B?SlJkMlBMdklhRmhxejBKYVptUC9KL2x4WUtBeXlXcXhRYTFlU1kvY1QxUGhD?=
 =?utf-8?B?c29ndTFBdHViNmlBNVF6aGtKSm9MZXJJQk9HZnpHRy95Nkh3V1c2MFRHbkhW?=
 =?utf-8?B?ZGlIL2M3RXBNT1NzNmxHTHFXY0VWcFY1bHFjY2s2czA3cGV2MzNpd1ZXRFU4?=
 =?utf-8?B?Ymk2ZGszeVFPdXp4RkRwcmFhWmhNaWRSQ1NndFBQbDUyWjV5YkhyMTNkMGdT?=
 =?utf-8?B?c01OYTdlZmJTV0ppdFVOaVBVbUNFcDA3WWh3d3lrL2FITStGNHIzQjB6Zit3?=
 =?utf-8?B?SGk4c1l0cm04RFBNd2h1VHhDTkF1ZW1meHNaOWwweU4wQnh5bjVrQkNsd091?=
 =?utf-8?B?Zll4RlZNakJaZE16WkJlR0VVb21BRjlrSXVwZWRvTXBJNEZlTlZzS3FrajNj?=
 =?utf-8?B?b3F3c0FNbWpIL05oSjBralFQalYvR0RiTkhTaFZwTVhsUmsycmxjMEJicDRr?=
 =?utf-8?B?R2Z4Ny84empZd0ZiVzJuSFV1QUNsTmtyK3dJbytySmIvR0tnWTBzaGdCUHRu?=
 =?utf-8?B?azR0bTRLeFZRdFgzZHpFdnpDanZIVEVLNWVlQ2JsZXVPNU5MY3RDVjFoaUxK?=
 =?utf-8?B?SEhyS3pFTlV6NTlCUGdNc3o0VEpVOWduYUQrQ2MvQ29nWENBR0NIa2lOUlRB?=
 =?utf-8?B?UGVjSy9rRGQ3ZGU1c2VwYXo0NWxMRWpSejdKb1BjaWZBeVBpZXNXc2lOcVRy?=
 =?utf-8?B?dk94TTVFcUI1OVFkdmRzUjBscWNsOEJwZEsxZUFWTDA1WFJZaGNyVkh3UCt2?=
 =?utf-8?B?OVJEaGk0Q1U4VHFMajRCZXJNRC9ZZmVPcE9WQWN3Szg2aFNWcHJSNXpKL3Zk?=
 =?utf-8?B?dHI5RGxOVVl2WmVaODllN28vZm8wbkVWQ1phRWJuYWMwM2JnV0tyRzZLbDhL?=
 =?utf-8?B?R1RUaHgwMGVCbE5QK1VweVZSUklxOXJqVmszRlNIek4xRkRaS2x3NnhpRzhC?=
 =?utf-8?B?Tzdsb05DTUJXdWZpbngxNUx3bURXLy84bUFYd3RSZEZsczBvMlVjRjJ5dDU1?=
 =?utf-8?B?ZVVwT1VFT0tsT1o3K0FlK1J6ZENOWUV0dllpZk92Q2MvdU0zV204dnRGK2VZ?=
 =?utf-8?B?bm1lQXFKMkNYMFRiOWdZZ2c1bUJaT200eHQ1dUY2WUdzMHJFWnh4bHhUNFZp?=
 =?utf-8?B?QWRpRUIrUjdBSWs2TEtiRW5XK3NnWW1UT2FNakpqemNJY0hLWlo3KzN4QjNZ?=
 =?utf-8?B?eHF5NGQyZnZuelV3VzBWMXJmYnJsRktsNTF0ZStBRTdqUzJFK25uK0w1bHVl?=
 =?utf-8?Q?XNGMkPP00xOpuqXo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ldkai9o4kbN+Ml/8B3OdNM/x5XantGxcPQ+ibKidtL9kcv/yCCKX6nYcbYGUsit5XyhuS/OGpK3mgMfQdGWxEF4U6uZgNYV7JFVi5OWBPjUuwZj0zOgNW+lYV/vp5P8l6j6TpJMxzIiRFcpy/kw1wilNkpssuJh0OSiaxIMi5+bgCTnewrZvG81mumHLbSFxvnvev+fzKcDeM03rSec+Xmis6OHXwExGy5EBEu8iaIVUedWEZ2itrjKtLhkPnpJa27GIRaluHgfLn807mEusmp46W0XMncOAG3Lj+hSqporamjewdxLYU8sdo6WSke2PTJgcXjH6FRK27EqnNWe4rw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF7551E6552.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2586c1-0cc4-496a-db0a-08df29e0110e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 10:44:04.4943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/7TxqAfR6qtT50ndJG+m0HawjIrLeasxDXmtRp5x8uW4ybNPcjgXpaHBP7HfwfbeJnGgEqIjSYK+9kWWGFfrHHqL/IYEsU9bMajrl+Ke4c=
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
YmplY3Q6IFtQQVRDSCBuZXQtbmV4dCB2MiAxMC8xMF0gbmV0OiBza2J1ZmY6IGRvbid0IHJlc2V0
IHRydWVzaXplIGluDQo+IHNrYl9jb25kZW5zZSgpIGlmIHRoZSBwdWxsIGZhaWxzDQo+IA0KPiBz
a2JfY29uZGVuc2UoKSBwdWxscyBhbGwgb2YgdGhlIGZyYWcgZGF0YSBpbnRvIHRoZSBoZWFkIGFu
ZCB0aGVuIHNldHMNCj4gdHJ1ZXNpemUgdG8gY292ZXIganVzdCB0aGUgaGVhZCwgYnV0IGl0IGln
bm9yZXMgdGhlIHJldHVybiB2YWx1ZSBvZg0KPiBfX3Bza2JfcHVsbF90YWlsKCkuICBJZiB0aGUg
cHVsbCBmYWlsZWQsIHRoZSBmcmFncyB3b3VsZCBzdGlsbCBiZQ0KPiBhdHRhY2hlZCBhbmQgdHJ1
ZXNpemUgd291bGQgdW5kZXJjb3VudCB0aGVtLg0KPiANCj4gSXQgY2FuJ3QgZmFpbCB0b2RheS4g
IFRoZSBjYWxsZXIgaGFzIGNoZWNrZWQgdGhhdCB0aGUgaGVhZCBoYXMgcm9vbSwNCj4gdGhhdCB0
aGUgc2tiIGlzbid0IGNsb25lZCBhbmQgdGhhdCB0aGUgZnJhZ3MgYXJlIHJlYWRhYmxlLCBhbmQg
cHVsbGluZw0KPiBhbGwgb2YgZGF0YV9sZW4gZWF0cyBldmVyeSBmcmFnX2xpc3Qgc2tiIHdob2xl
LCBzbyBub3RoaW5nIGlzIGFsbG9jYXRlZC4NCj4gQ2hlY2sgdGhlIHJlc3VsdCBhbnl3YXkgYW5k
IGxlYXZlIHRoZSBza2IgYWxvbmUgb24gZmFpbHVyZSwgc28gdGhpcw0KPiBzdGF5cyBjb3JyZWN0
IGlmIGFueSBvZiB0aGF0IGNoYW5nZXMuICBVc2UgX19za2JfbGluZWFyaXplKCksIHdoaWNoIGlz
DQo+IHdoYXQgdGhpcyBwdWxsIGlzLg0KPiANCj4gQXNzaXN0ZWQtYnk6IExMTQ0KPiBTaWduZWQt
b2ZmLWJ5OiBKb3NlZiBCYWNpayA8am9zZWZAdG94aWNwYW5kYS5jb20+DQo+IC0tLQ0KPiAgbmV0
L2NvcmUvc2tidWZmLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NrYnVmZi5jIGIv
bmV0L2NvcmUvc2tidWZmLmMgaW5kZXgNCj4gZjc5ODExOGRmMTEyLi41NTZkMzc5ODFmMGYgMTAw
NjQ0DQo+IC0tLSBhL25ldC9jb3JlL3NrYnVmZi5jDQo+ICsrKyBiL25ldC9jb3JlL3NrYnVmZi5j
DQo+IEBAIC03MTU4LDcgKzcxNTgsOCBAQCB2b2lkIHNrYl9jb25kZW5zZShzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQ0KPiAgCQkJcmV0dXJuOw0KPiANCj4gIAkJLyogTmljZSwgd2UgY2FuIGZyZWUgcGFn
ZSBmcmFnKHMpIHJpZ2h0IG5vdyAqLw0KPiAtCQlfX3Bza2JfcHVsbF90YWlsKHNrYiwgc2tiLT5k
YXRhX2xlbik7DQo+ICsJCWlmIChfX3NrYl9saW5lYXJpemUoc2tiKSkNCj4gKwkJCXJldHVybjsN
Cj4gIAl9DQo+ICAJLyogQXQgdGhpcyBwb2ludCwgc2tiLT50cnVlc2l6ZSBtaWdodCBiZSBvdmVy
IGVzdGltYXRlZCwNCj4gIAkgKiBiZWNhdXNlIHNrYiBoYWQgYSBmcmFnbWVudCwgYW5kIGZyYWdt
ZW50cyBkbyBub3QgdGVsbA0KPiANCj4gLS0NCj4gMi41NS4wDQoNClJldmlld2VkLWJ5OiBBbGVr
c2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT4NCg==
