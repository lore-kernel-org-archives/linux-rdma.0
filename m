Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793883096;
	b=IGJGrAdO/XSBPOYbq847O/+K6AeKYmSPXczpEy8v7YtvYU3kDy+eOUjV4TUNf/ORSVkU
	 QuB2Mr5QUuh0lH5rpnNU2zNEWkEhkOSQ3pfAjyVoIfJJNUJ8UYqsTJ5ioalbxY3dqB8L2
	 uS+3oXpqLAsT9K6BdaLHc2Es56W3z4qZf7eRCQIJEpzoPY86ItGGTvtNK2eZE8GUnI591
	 zpc3CgDqyz/l5ymaKrz8t2AcbJsqHPQPzJTtjpnp3sO8vEAhi0ihduEa8f2plrDDKqfdK
	 WUQ9aS+2UJw7MlV+3oAN0n3EDGYDZ8CprD9Kj5gMi+E1dzr3Jk+XIkHHyb8ui6Bq0aQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883096;
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
	bh=8skIC5iU75GJszF8sxnnl0uGOGTklkzPu1m53Rdr2ts=;
	b=oOePkWhMqXMTeUjlbv+KEdb457Jc3HNiNWgmWwbh2rmjfwfJmWwAVazaZ4hd50TgtwMF
	 Wq9U1mgfjs/z2mVSX+GnbZ64XkjJmHmRDpT78KRUwn6M/3kNmxKXGERHDicKlZfzU4aiT
	 nZrg5cR6B8vL/2L7GcQS41ESC3EWcmv6rflA1K34b/Tj//mtvKvcJ4Rx69IQC6P40rgLQ
	 OxUc/66xE54GAuWD7X9mMsVSATEtuDYDn7BfzK8BzsuadOHmprHDz/gcmbtgalc3/6Cgb
	 3TPOZ9hbjt6Kv4ohn4K33W+M/TAy8/H5t9+qQHRYswPnhgCK4Xd4LduNhMWVD45ba+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kfgEX3q8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEF9606A332;
	Thu,  5 Nov 2026 12:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FEF9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kfgEX3q8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793883095; x=1825419095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7DrVuWNI0J+Mc66vviySa3knCfovhZzMM/paxCCEK08=;
  b=kfgEX3q8A/Ln9JiSQ1fV7iyATTYpG5DgaM4CtK/XWHXFVktAF2jXwsp/
   4KOlpJMK2KvAch7KeWx/0n9r4M7xFC/Jn/Y7Q51tEO38yNKGqLB8Iinos
   CJ528LPOvkWScrmVXLvQ4NC1De86MFNRmuU2meoY4woXGgu1Ht+p74lxa
   oxbZce6Jp6bvqOa+BYCoGjNcarrKQ3irWgainALkohjhd7XbL5FXcBH9a
   6t5sJK39IR6xNgqhesh89Hs/B7JFCYrSTlTo+r+bWVBAlzyg/G7YdAwQY
   Gwmwg4mzj+WnmUzv4sD+iZ+TZ4Fw8KRjUXAd2YUX+e3gY+rvNMU8v+zmw
   A==;
X-CSE-ConnectionGUID: sQYMPXGaS8SPRhZqc/HFbQ==
X-CSE-MsgGUID: tt8h1JrQS2+3VeeSUNZTQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2768627"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2768627"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:51:34 -0800
X-CSE-ConnectionGUID: IaH8hPtvRPKmbpPIZP3Fzw==
X-CSE-MsgGUID: 0dTQdu1dRjquCE6wYBuV/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="6886982"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:51:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:51:34 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 04:51:34 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.16) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:51:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdcJeDIOnVNEnSZMGTt6jyFJbKyfaMiD+IP74QsUvVJ5G6Ck7C4p2iwKfm926oMhfYf3o8dcJlqgRUaVVATieOdZmvVKvnRQbYCWpYgH6G0JPWNkrvs1wT6CRtN0mW9/cQoZVQJZGMgtAP7WFpDcmwCwkCUuIJbzhGiIj9wcTIHJvqIf5SXdTPgV9wRNPBzhhU1HZyUVZFuIPFefsUjRrqcVB2ZkGJW3WtoMa6L9ktfQYKgUW+ZKcnywPR4T9rV4G70qSCop2YB2U8jvivZjhKtxpaT5H6Tga0lZqPLziOVxPr/PTC3iCezpWhOXwmjVq30Y7X6NhHJORv/lLDV9cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8skIC5iU75GJszF8sxnnl0uGOGTklkzPu1m53Rdr2ts=;
 b=diEVN8sCM9KHczRYxC/5vZSI6tZCuhClfa36eXpv+Bh1gkAeIRjtaS33h6y2rEL5D9rUxe+NjpH76FSfBbESq0lKQbZPDpUuium8+9f1xVr3lLW5odmX9Xl/paDSL+KfnyvLt8X/C8LsxAP/wNG3SrMDDDKhZuukkIWw755q9NGzprnTAtMOQ0jtlEwCiAQxNBT8WTPwJZ4y88ap2RstzkUdJ8TGTRV3n5Jb1FX6VDa9rOUiLstOyzIr5BYPmNXffe9YsKFU4tY/ddEf2r2j2wKxlvfDkeLKvDRsiJS1kPFOwjvoRUCUVAGba6WjeOwv8NoYq9xd3QZxQ1WgvCv/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 (2603:10b6:610:34d::22) by DS7PR11MB8827.namprd11.prod.outlook.com
 (2603:10b6:8:254::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 12:51:31 +0000
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584]) by CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584%7]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 12:51:31 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: David Hu <dhu@x6u.co>, Mustafa Ismail <mustafa.ismail@intel.com>, "Shiraz
 Saleem" <shiraz.saleem@intel.com>, Leon Romanovsky <leon@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>
CC: Jacob Moroni <jmoroni@google.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "David, Hu" <xuehaohu@google.com>
Subject: RE: [PATCH rdma-next v4 2/6] RDMA/irdma: Register irdma UVERBS ioctl
 namespace
Thread-Topic: [PATCH rdma-next v4 2/6] RDMA/irdma: Register irdma UVERBS ioctl
 namespace
Thread-Index: AQHdaxojrDxuDh2kf0qbAEHzYwg5RLcfcnpQ
Date: Thu, 5 Nov 2026 12:51:31 +0000
Message-ID: <CH3PR11MB566895AAE815D00C51479B31A8E5772@CH3PR11MB566895.namprd11.prod.outlook.com>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-3-dhu@x6u.co>
In-Reply-To: <20261030181512.2056056-3-dhu@x6u.co>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB566895:EE_|DS7PR11MB8827:EE_
x-ms-office365-filtering-correlation-id: d41de504-81a3-44c0-5b62-08df3b3b83e4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|18002099003|22082099003|38070700021|11063799006|4143699003|261022113327099003|261102123227099003|261028144727099003|261026121527099003|261022105027099003|261026140227099003|261009223027099003|261021121427099003|56012099006|261022075727099003;
x-microsoft-antispam-message-info: qUAjTAbOIY6aqrRcafE/E/i2jrrFvhgtAkvUWuQJRuMQ2IbdnnB439SkfWiw9YSG92qK9WHvU/1oEMw5DzuO3TCWhOYymaP4jzCSSSCX6XSD7ylHQuf8K8LIFhh+Ne9tx60snxkUhg4CffHbJvigCcSIS+rVha8CvLawBfR1PjNfdRbbAHDESDBsIGcMJGyfj2/l9sS9KKc9Amb7OpcP6jzbz8JOH1TyCd8Tnl7yYc2thqWVXol05ZATGyz3ADAo5pxu/2LpOpJh9VKdyEMRC+nN7gfANl9QYSIO8JGdP2NRfxVQ974CCUc4JoQNxE00z0NTKQ0/fmSmWUL6tfhFMwxDNRq7AVBpSEDkckcw2mKlG+DRzc20HElNFIjDQf1deNyW9uiHMH8lYXAB5I9QPvv4l6TWkicEAaSKmOFjfs90sv6eTmKsevegdLcxvm3F73RqNSKN9ES0axdpnDb7kKI9LOCKV0CUj+c9wCZ2kpbEVk7WGIIfIH8BfESc4LOEyAQG44jN6Jrt9dOW+bmayfYedC+x0rMvj3Ea9VSsS1NoSB6xxIqnPSTmoh4m9hKBrV2/R9Qr98s2erKszwFXZTsjDij4uz0zGmsrfk/UuZJYx2WlCbIaDEiQdQUfuJogmioScE7UttNmDJP18+6mZCqry0rMLG3KI6ryvcpGU8A3Rp3bqjZFDC23r985FyBjE4ql5ntzkcTtHnblHZns2N5+XPiX19QBe/t/f3dBdWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB566895.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(38070700021)(11063799006)(4143699003)(261022113327099003)(261102123227099003)(261028144727099003)(261026121527099003)(261022105027099003)(261026140227099003)(261009223027099003)(261021121427099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4ao3He2gEFCOoPyx1MSNUYuRetCBVOxA95znQGeHWjHGPFX1+DvbIsoegcmq?=
 =?us-ascii?Q?NpKt0bFLtx3em/pWMIwrke9f3C7Y0gc5YcvVUnl2GkBmlVErfO5QzSREQBi8?=
 =?us-ascii?Q?UoC+zgiQSAlDUH1BzQqFW0WIFgWtL0WQqxZz08tWlGAGVfStG+C7zJTv4rna?=
 =?us-ascii?Q?ryMpUuk7gfZBXbyO4pObTXMzRzGqJtjkeOE8siCuM0bb2STgiknsiK/Dk0Au?=
 =?us-ascii?Q?Uo7/Bb13S5eG1/lax4cr8i9fkEtXDtuTC7Akr+0vEwkwbQDg7UR7HtNbKhYN?=
 =?us-ascii?Q?f8IEC/emlZ03odkEIOrnbUkAD63dnMx13h5ziVjDFEOYlK9QuZwAhfglF8au?=
 =?us-ascii?Q?i/DKFasOXBXbhNRYN2tJbaDWIRUR2qkP9KmIBE5bOe4SO83JJmIPexjHufww?=
 =?us-ascii?Q?l7QrCbWagcX8ScMRFNL0V5s3KCCSt00Q3TR4Tf6PZAFih14YwTwqDVQ5ARHJ?=
 =?us-ascii?Q?tvRx+jZ1EEIZ/QcgyVtnZZBfTNH9xvLZMEe1xCJMf6uqv71jvZ/SEmsVl3mh?=
 =?us-ascii?Q?OcdTydQUqWFObMv4cAF5GLn+ZVZ6AbhR1CcONRplERq/GtYtLUBhkY9YiNIb?=
 =?us-ascii?Q?Od+OQN6c1YkfRrp+8I+iByZDqNYW6nY2pags5FwiFk8cjPDWY4CXYxATTJND?=
 =?us-ascii?Q?n6yMNsgaWTF0IiAwZnN8drUiOP+DdZ56QTJAlkhq8cbf0GX1of8y6+LLAdWi?=
 =?us-ascii?Q?bZX+1dakWk5Wz2hXshb0WQWfCYWvbJ6wbfjOGu1XAHaI2nNw5k9QkBME1FJW?=
 =?us-ascii?Q?yIIfue8xT0NL8XYuP+yWSDZ1kdkCZszuIMlYIOYvRk5eRisvxI9uVARJVtrl?=
 =?us-ascii?Q?1DXnoHf24FaAYVAeS8D2OH52H9HTCiBw384aqkOrIOTDkdYclsW4s5qfbtZ2?=
 =?us-ascii?Q?CQo68kFoPxdtckAz7egSqaBSJjbNg02icX0YIDn/L8XDjgPK2oRG8drYz2Ci?=
 =?us-ascii?Q?weQ5QMz8vjPfKp3M5+MYCiwXVjJTShchzO1d1w+8cUMs816qFcaL4DQ46PJ8?=
 =?us-ascii?Q?7RohrpFMgY+3QOAdNHXRqR6tGxenRzu4ys0XnGVRDwyyzQastBYHc8HJ32a7?=
 =?us-ascii?Q?ItysYk+8gs9NkYAfoDf5Yc8vAiLMV5DCArKq/BHFM2UChohP87bDAAmUYXQ0?=
 =?us-ascii?Q?UH0GbrIWSmITHg8Vs7kwWJ+D1ohS1E5HVsG9L6cdy+oE5t9HnpfxJ+akNz4X?=
 =?us-ascii?Q?bhJM2fMMgELssFiVztXe5pf2ptR2+ZyWCy+za8XeGB8PYDvRkU8Q3ZCWvl97?=
 =?us-ascii?Q?WQhCbwQ13Nwvge/+Ndp0pCcF+ub/Jprf9mgIM/xkYYT7DQcKvZ9zI9k2b4N6?=
 =?us-ascii?Q?PAutr2wNyng3B8qOLiXS/DrBB9fWObYkY/18vDnS1W/TN/6zmNkGN0vChKhB?=
 =?us-ascii?Q?nb1q9ca2yhRVNfddK7dxHwoKB99WvhWwBK9sIyqv5fszWyw+sXb6p4bPOnQR?=
 =?us-ascii?Q?CxPbQYTpCxbWjRJkHuV+CzfVjo1+NPF0okO9goMN7IJIeRd7NjS3tqWzBSlh?=
 =?us-ascii?Q?+LImAlMoEkeDGpXfPXMSIdL1pQpUMFGST3wFRajW1get5ZNp3g2L2S9Pzq9a?=
 =?us-ascii?Q?gxp2XDLgvJXF6mm6gHc1JSMWLnHDnWkKZUHGqK6oVnEgt90jii7d55VBPJPg?=
 =?us-ascii?Q?55y+Ufl3T6B6TioS0PhRzs6hbBGs1pamI2+u69EhrG36OKamE4RurqKVcgj+?=
 =?us-ascii?Q?boGyUnd/mVwQMBK+FyUpN0G/b99DpxK6lyuAeZiRRfIf1i240Yekt+9J5nkS?=
 =?us-ascii?Q?8qp8pHpIjcjmLNOuGSWgXjjceWLi0YQ=3D?=
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
X-Exchange-RoutingPolicyChecked: J7mq4q1tcT2ujggBwV45m1/Lq52umM0m9XlLSQ3bi3p+K13Wn0uHG9eP7g0Kgox5JbHtWYidky4PMfdecF1zz+s7lJu27dhc446onrmNJj/b9wSvbXGd0+amseFCA69SMJ1LGvKoaSFI1JeeHtZIIjlg2H+AM09rO47uuU7MvYWEKSFEPDZtuU46g2Ei5vPGLTC9yd9x+03J3I+c0zNu09QW1HEmRLDpALi0Tmp4322/9Iu4j22LutV9695aeMg9dFRYV0yN4s6VodvTr1H2SBEsoYNexMN5UEvMpAYup9EcjiO9/W3QWg2avUss8WFq/5HB4Y2oBiQOG7lpy0tNJg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB566895.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41de504-81a3-44c0-5b62-08df3b3b83e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 12:51:31.1483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7O3SPLdaMiVdT2tnx/pH5Dc/sGF40ceFzOnP7i3azpojWKU8+OuMHaDS2nX+uAEhIl0uh3NVgmKuOa8TI1UpUtg5hBj3hQ6Pk6F+JbD2hY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8827
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: David Hu <dhu@x6u.co>
> Sent: Friday, October 30, 2026 7:15 PM
> To: Mustafa Ismail <mustafa.ismail@intel.com>; Shiraz Saleem
> <shiraz.saleem@intel.com>; Leon Romanovsky <leon@kernel.org>; Jason
> Gunthorpe <jgg@ziepe.ca>
> Cc: Jacob Moroni <jmoroni@google.com>; intel-wired-lan@lists.osuosl.org;
> linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; David, Hu
> <xuehaohu@google.com>
> Subject: [PATCH rdma-next v4 2/6] RDMA/irdma: Register irdma UVERBS
> ioctl namespace
>=20
> From: David Hu <xuehaohu@google.com>
>=20
> An irdma UVERBS module is now created. An irdma specific shadow buf is
> defined for CQ, while QP and SRQ reuses core's uapi definitions. This
> works since core builds shared core ioctl parsing tree first, before
> adding driver specific `uapi_definition`.
>=20
> Destroy paths are automatically handled by core dispatchers, as objects
> are now registered in the parsing tree and no additional driver
> specifics are needed in destroy ioctls. Resize, Query, and Modify
> continue to go through write() cmds.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 18 ++++++++++++++++++
>  include/uapi/rdma/irdma-abi.h       |  5 +++++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/irdma/verbs.c
> b/drivers/infiniband/hw/irdma/verbs.c
> index 811b1d532599..dd824720671c 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -1,6 +1,22 @@
>  // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>  /* Copyright (c) 2015 - 2021 Intel Corporation */  #include "main.h"
> +#include <rdma/uverbs_ioctl.h>
> +#define UVERBS_MODULE_NAME irdma
> +#include <rdma/uverbs_named_ioctl.h>
> +#include <rdma/ib_user_ioctl_cmds.h>
> +
> +ADD_UVERBS_ATTRIBUTES_SIMPLE(
> +	irdma_cq_attrs,
> +	UVERBS_OBJECT_CQ,
> +	UVERBS_METHOD_CQ_CREATE,
> +	UVERBS_ATTR_UMEM(IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM,
> UA_OPTIONAL)
> +);
> +
> +static const struct uapi_definition irdma_uapi_defs[] =3D {
> +	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_CQ, &irdma_cq_attrs),
> +	{}
> +};
>=20
>  /**
>   * irdma_query_device - get device attributes @@ -5602,6 +5618,8 @@
> static void irdma_init_rdma_device(struct irdma_device *iwdev)
>  	iwdev->ibdev.phys_port_cnt =3D 1;
>  	iwdev->ibdev.num_comp_vectors =3D iwdev->rf->ceqs_count;
>  	iwdev->ibdev.dev.parent =3D &pcidev->dev;
> +	if (IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS))
> +		iwdev->ibdev.driver_def =3D irdma_uapi_defs;
>  	ib_set_device_ops(&iwdev->ibdev, &irdma_dev_ops);
>  	if (iwdev->rf->rdma_ver =3D=3D IRDMA_GEN_1)
>  		ib_set_device_ops(&iwdev->ibdev, &irdma_gen1_dev_ops);
> diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-
> abi.h index 38155affc8b4..a1a26529aa85 100644
> --- a/include/uapi/rdma/irdma-abi.h
> +++ b/include/uapi/rdma/irdma-abi.h
> @@ -10,6 +10,7 @@
>  #define IRDMA_ABI_H
>=20
>  #include <linux/types.h>
> +#include <rdma/ib_user_ioctl_cmds.h>
>=20
>  /* irdma must support legacy GEN_1 i40iw kernel
>   * and user-space whose last ABI ver is 5 @@ -23,6 +24,10 @@ enum
> irdma_memreg_type {
>  	IRDMA_MEMREG_TYPE_SRQ  =3D 3,
>  };
>=20
> +enum irdma_ib_create_cq_attrs {
> +	IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM =3D
> +UVERBS_ID_DRIVER_NS_WITH_UHW, };
> +
>  enum {
>  	IRDMA_ALLOC_UCTX_USE_RAW_ATTR =3D 1 << 0,
>  	IRDMA_ALLOC_UCTX_MIN_HW_WQ_SIZE =3D 1 << 1,
> --
> 2.56.0.317.g454f8302e1-goog

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

