Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DC3A8744;
	Fri, 21 Aug 2026 12:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787314952; cv=fail; b=McRXGnnKhHTe2SrQVx3RTJpTkFIPEFLz1ExoPAr/CS3/ONTXChGmqD7LTVFUjM1fIVh2KtMiJN8q/xru1yzjGEPh6IwgSrgs3ZhOhAq440Ac1yAX6WonF7xQJtwjjRi3eIHbure3lhyDhE6u5RGnHHFXWeSC28B6ewmpOUC1/KA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787314952; c=relaxed/simple;
	bh=ZxywOCVtcW0wuFuX6A63sYHcsMPhuvZWcHrIQIMtxpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VSSyen39CP3Qg+1avfxoafoLr/fbsJAfMaL8hIBux9BD9J+BlbnODHqMiYPuu//ypgAGYZCJrT+KBV+ik0i77r0N7ikz4XCUjT2CxT8d9l+/jpfWYP+JYldg2phbd4cXSQjaIKyso8ovum/f0mnAmVuphaY1MQhpFA5YF7w5xUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=haARLApv; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="haARLApv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787314946; x=1818850946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZxywOCVtcW0wuFuX6A63sYHcsMPhuvZWcHrIQIMtxpE=;
  b=haARLApv+vEthKqg6wV1gwuCp3znFLsYWU7dwzDN+TDFLfi6obxFt4P/
   ajnaRQyX0H2HW3qRxpnS/ZABH+Eumy314cDhtLZo+boKbDBJxvOtz7OzJ
   pvQcrqT13OWmmDu/L63psN8LJqWKUX0YUbY81zvh4UGhgdtdnsXMJpMTD
   627pqM9NsQCRmjIdjQRiBq/NPnPTOUvUjM2fDRDYxHEbQLjj9cxu+azpp
   U+0u+zh3QWv6SHpUHuqioFfKAB0WED1c/j6p+fU6KZHL+fnaDhx80H1dr
   WWL0XcUe3StOUNuZaHm0hKvffZf5n6ZPw3kjCSEjH6a2OJRfMY8+ExSoj
   A==;
X-CSE-ConnectionGUID: LjfDRaPCQiye13iiulUTbg==
X-CSE-MsgGUID: D2ZFnIWGQsikNjQOnv/NrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87922910"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="87922910"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 05:22:20 -0700
X-CSE-ConnectionGUID: uI7PjAtqRv24mdOTrqvRbQ==
X-CSE-MsgGUID: 11f4ZY/+TAi96/zWwVovbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="262619822"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 05:22:19 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 05:22:19 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 05:22:19 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.1) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 05:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VOFJHSuKwWJKcKbi0Q3W/IKbBNCe3xfTVYN8n3GURzMvYKmBwaS6ITjV1eSpTG3Gcg2xSPE1ovnqgnEbwLq4wVtMA6+Ejwxgql5EzOikvq1JBMteF/Uk0lo/oiVpjnD8afUUVl084PivGqg4chReJn0L3YnZP/3/gp6oHnkT2oRws1Oc6YjTzUeuAnxiL1pCrbWqo6a20LgDL2c18IDAVkkXQ8ioPy4QApvEdyk1n2gO2Q4/UEVuyRwEhG3LjkJ/b5xMQs8iw61IExKfxvnaS5R/JbMpdB/62OSDVgFkGVlQG56jFHUspWQFlWK2jlZoiYRv12P7s3FLIwiaYfyxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JJ4PU1w/CslgxtJLCOa1o4SY/M/lMPOG1hqS5Ccb0I=;
 b=QJ+wuE9/X8erbtMc+0+jOfHDwGGQNNbHk+vPy3bgrnSWgQrL6KQrXh/PoQyanSuzXUhkDE6In28g5oQjzbJEy7oocAqYvwb8zRVXiWGVl6UxtV0nsXgJyh166b4hpHqjf2Sv98U29iPGdb4oSrnZ/7U48urqBAzB8HMoOAmkK3ImoHUgUzv4sj4DZZ6iOYlKbTiRPK2iDOWubGp4Ldg7Yt/YeoF9lECevBODsUwLlwjx6m6XMTjwn26gQJbYXWIK4pBGoKvy7dPoNGmFcUriXBD6Uc3vVeO/xYmlaJpHEF9E3JhHz8IB67CkgCZKYwkGHDe+NrzJosPzkVTgeXnVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by PH7PR11MB5768.namprd11.prod.outlook.com (2603:10b6:510:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 12:22:08 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%6]) with mapi id 15.21.0339.008; Fri, 21 Aug 2026
 12:22:08 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Stanislav Fomichev <sdf.kernel@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"tariqt@nvidia.com" <tariqt@nvidia.com>, "mbloch@nvidia.com"
	<mbloch@nvidia.com>, "maxime.chevallier@bootlin.com"
	<maxime.chevallier@bootlin.com>, "mcoquelin.stm32@gmail.com"
	<mcoquelin.stm32@gmail.com>, "alexandre.torgue@foss.st.com"
	<alexandre.torgue@foss.st.com>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>, "horms@kernel.org" <horms@kernel.org>,
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, "Fijalkowski, Maciej"
	<maciej.fijalkowski@intel.com>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "hawk@kernel.org" <hawk@kernel.org>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "guoren@kernel.org"
	<guoren@kernel.org>, "dtatulea@nvidia.com" <dtatulea@nvidia.com>,
	"witu@nvidia.com" <witu@nvidia.com>, "martin.lau@kernel.org"
	<martin.lau@kernel.org>, "Song, Yoong Siang" <yoong.siang.song@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "linux-csky@vger.kernel.org"
	<linux-csky@vger.kernel.org>, "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net v3 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
Thread-Topic: [PATCH net v3 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
Thread-Index: AQHdL/SmXgyqtDdYQUaVd2408OQu7Laob2Cw
Date: Fri, 21 Aug 2026 12:22:07 +0000
Message-ID: <IA3PR11MB8986C83D3B64E9670AAFF1D4E5A32@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-3-sdf@fomichev.me>
In-Reply-To: <20260819160535.1472459-3-sdf@fomichev.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|PH7PR11MB5768:EE_
x-ms-office365-filtering-correlation-id: 32a87d19-98d6-4ed5-546a-08deff7ed189
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|22082099003|18002099003|4143699003|56012099006|38070700021|11063799006|10067099003;
x-microsoft-antispam-message-info: oP6rfCLg2+dqK1YMQuIf2KZ7VSQlKEz8D2OKSGY91Qa9v+w2m29+lh7udbeVt+4yFaDFHtqd2bJsfu9nQNKIGLQfcAC+9exGpeYwVUguIUoPOyyteEIh0fks9YcR1Pnah++FayLr7cE9hXdcTGWqKn3LS9MRn90+zwFmrb/Sf8JL7zfVq51fvTGbVKaLEYxKo0/MO3FDS3aCEDFaJesMCMRnVqBCSnjDe7i0WgHx55ZRHqwgoaUDZFpgVeDbSIVeUJlZjlQemC3noTRsRbW2jCXUyLSoN9APaji2aY5YPl1lG3HDHhgF4yLCJo2R3i4YHz+Subt5m2FRp/yjXNZQOZ5eelLu4yknYY+6NzpkVSd1LJ5Ghim5Q4cBWBh58uX86Rda6KiiPcUE+wzhfqQtPhF6kf0Q04Xn29iTQUn8aeikn6kcvx+pqISbwomndaSoESo9OQI/3oNUfoiEIqlzSk/HI4axTMd+Iv6paEFks52tWZrT0LmLPeSYGAVSWUmpqI93MeXtUWPAZ9wLt8OabDnz8ONGDpm1OMHWBJLX6j2Tu2to1mc66O4hkY1LBvvT2IlOtg01F3Nn4yK73tWLBGe1kyx1MF/WEwzdvVfL4j6uUsSWO/Nh6rPMLqNlbQUhQiuX4N7GqcK7yupZ4cdLYsLgSqPUa/FBbkG5gjMDhGMUQvGW2TcET5gO+QO56fGXRoavAUCHROviS/OXrg39bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(38070700021)(11063799006)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bpFjVRlZ4ICH3yjjtMROUKtBtTQvGj3iK9BUIs7fSi81V68bQ6nDG8KRjjbo?=
 =?us-ascii?Q?2q9uejvX/3glcrsNkrHZrEBt9TpCsyAzUI8BafZgYFVdW7rXu+YbvKoH/YOc?=
 =?us-ascii?Q?sF1Omz+nEl/Rda4xZitg4PCX8yubUcukyoceOkXj8uI7tMyfsnlMTf4/fQ2H?=
 =?us-ascii?Q?ZFL8wncSFE9YCL8qV3m6Ow7RpwOi1LWoNIIEWFccN2TbSb1W1hsOYtXMfMfx?=
 =?us-ascii?Q?ZVnL4CJ9xRIDBqOw8EjV3F4Q2JGQcp65SZcm6eKiPUK+fLCdwnGYkgSo8J6y?=
 =?us-ascii?Q?wRexSaX4SLQ1PRVR27oGJ+LJrxbFi+P25YNP7GTqlOsVhg/0JTOcJZLMgH7N?=
 =?us-ascii?Q?vewJa5kV/WCCsrIa50uoKDz1uEddTjXNeE2UCDCrddhSzFlM5J+syBkIE32I?=
 =?us-ascii?Q?xOYs3kGsKRK95IBanDf70k3IW4rDVK9tSYPoztYr+kNTmL6kAURYZkTTc0/u?=
 =?us-ascii?Q?HaZTFEMfieTlZPWkRcAxLbIOoGGHaH6YxccdPf8XQ8PfBUyR0mWg4hWt4Ngk?=
 =?us-ascii?Q?0h+RduFBCubsfGWcTRKoIhLgh149uYNe+ZUBiIHR7N3cEc4P7RQA/9PVaOlP?=
 =?us-ascii?Q?37C+jpoarbwnHtlaIR2a7x5n72ZmpGuNNKXdPLQ+ovF7taeKIKy2u0A5ClKz?=
 =?us-ascii?Q?yWo/Hg2DJDyqxOu9Xb/y9iI+ouTSqpLkccdrn8ZrIKfZbCMg5rmo2Y/J9vNX?=
 =?us-ascii?Q?PgmYaIuIfj+WAEGeXHLDwjXtJS3dbNjuP+OWS2nuUZC+7gNLJn7ZbGAD0eJW?=
 =?us-ascii?Q?hpBO4YZ1DkeyfgqnevRWTEmjOEN5A/CMPE49GWy7pHDWIYJWz7ffXNsFG20j?=
 =?us-ascii?Q?4B8oVa6on2GiFtXxI1XxmWWMI34njgy/MBl/wVtuDSJODL2xoooz/YQnZkB5?=
 =?us-ascii?Q?OWpVcpCcbYfe5omhn8BVsVGD+2ZqQ9ihRSTfJCoTLOPlyn80Qgynn8B5KqJ7?=
 =?us-ascii?Q?3h4BpFRtcnqbRUVQL5hTLRlRxvaFXLaxkOYRflbcboumtatYVBKN7Iv0rehG?=
 =?us-ascii?Q?f7ptKVSBPWZeT7u9W2qXkesvmNb8KUbyOSDdGiKyYXormf5/xM74MF4qVIcn?=
 =?us-ascii?Q?krrQ3cgv/JTr3DzUcyLCPlsb3lsapFkAXBF7gzoKPTqf25V4KV4rRwQo4Rp/?=
 =?us-ascii?Q?ozw2pl6CA/4APHeATzxiLwiIpffgqDAVsW6RPIaXMuZbASpGbeAQyg8deXbg?=
 =?us-ascii?Q?R/w9WYSwIODC1hM2FtRKmpuBIKoO8cx+gI/U5q+0JOK11LyqO/DtVyvWMIYB?=
 =?us-ascii?Q?OLdbpgITBsNEDz12ircKwix143RkbYJtRYy26ZN5wSkL4xG98qptguU/vhN8?=
 =?us-ascii?Q?4IpFE8+sgp8n9tdHE02iCk1C4uzu53iQKBrl5v8FqlTEMdgaL9MZX1CgdStE?=
 =?us-ascii?Q?a2c159UQeZ/I5OkEfdhlXMsYfqokxOLnVjeDcQ5FWZqyP2kPYn31FcKjU1bH?=
 =?us-ascii?Q?JoFBZXI32/FQI17pvn/sfg6P6npGF5OHZ2s1JRBQ52uH74/QQ2I8Jo71uRmL?=
 =?us-ascii?Q?hKay4AEr/7Xc+/3vkSUaiozjNrnamJgyDttICM7zZGKDqs5AqE/Oiqw6HhTr?=
 =?us-ascii?Q?8TOV9I1lIyLY3HW+EMNW5ysftsvdG0Fylc7VX/vkCTke+mP/KhNgoLmUtNkF?=
 =?us-ascii?Q?QVEWx1pOO9YjnL+45RH4QySR/jeQeK+m0m5Z60ll5c/WES4UvmgqIEB2tgm8?=
 =?us-ascii?Q?V3VpFfxEXaTrwLlDZxofY8GbaISh27rAsN/b1SE45A93wjXSwooG6nr9SIH7?=
 =?us-ascii?Q?3jB7Thci90ni8GdZcngfqRz6rvLsHhs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: T6OCH/5iCgNEE7muiyVVFw/YSyipv2xHtoJg39C13rDt/1tIRfdKizjT8utLKHRv9F3RPQwPN1XPWeeQV6+4EayMY38Xm5OgXGomr70znpSUHWyHdiODdQtsNhFD/0eWBH8mXgiBNxBTt6gho94qlnYElUJUEYpKqJGGs4xa0Q3ssdqa0imnNf4aQ6zf46N7QHtUWSf2+aVYFycf0zP8ilplciQw9/2DH0myBhkD81UdICkn2OJQ30UCMuqJBmk34JPYsSbBGSvIFUzWZ1kUuk5cQ31BXi4+Ikf6xD/2PNAAjKfd6gIpgKCxWLiiFSEs28XI1Vxj7FgYMe23f4qJwg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a87d19-98d6-4ed5-546a-08deff7ed189
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2026 12:22:07.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uZJFi7jZkZmHPV7zdZK5Dh4/0sYnJE+GVutUcHe1QOGUrD7UwZsyaQl5aG4No2XSxNUXoCO0xLgmXcYkSKkYI0KShdFqNHvg4dGSA8igtc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5768
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Stanislav Fomichev <sdf.kernel@gmail.com>
> Sent: Wednesday, August 19, 2026 6:06 PM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> Kitszel, Przemyslaw <przemyslaw.kitszel@intel.com>;
> andrew+netdev@lunn.ch; saeedm@nvidia.com; tariqt@nvidia.com;
> mbloch@nvidia.com; maxime.chevallier@bootlin.com;
> mcoquelin.stm32@gmail.com; alexandre.torgue@foss.st.com; Lobakin,
> Aleksander <aleksander.lobakin@intel.com>; horms@kernel.org; Karlsson,
> Magnus <magnus.karlsson@intel.com>; Fijalkowski, Maciej
> <maciej.fijalkowski@intel.com>; sdf@fomichev.me; ast@kernel.org;
> daniel@iogearbox.net; hawk@kernel.org; john.fastabend@gmail.com;
> guoren@kernel.org; dtatulea@nvidia.com; witu@nvidia.com;
> martin.lau@kernel.org; Song, Yoong Siang <yoong.siang.song@intel.com>;
> intel-wired-lan@lists.osuosl.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com; linux-
> arm-kernel@lists.infradead.org; bpf@vger.kernel.org; linux-
> csky@vger.kernel.org; leon@kernel.org
> Subject: [PATCH net v3 2/3] xsk: honor XDP_TX_METADATA in zero-copy
> path
>=20
> The zero-copy path reads TX metadata whenever the UMEM has metadata
> space, even if the descriptor does not set XDP_TX_METADATA. Pass
> descriptor options through the metadata helpers and ignore metadata
> unless the option is set.
>=20
> This does not fix the existing per-WQE metadata handling for mlx5
> MPWQEs.
> Only the descriptor that starts a session passes through
> xsk_tx_metadata_request() and configures offload state shared by the
> batch.
> Metadata on descriptors joining an open session is therefore not
> validated and does not configure its requested offloads. In addition,
> a non-NULL metadata pointer from such a descriptor is treated as a
> timestamp completion request even when XDP_TXMD_FLAGS_TIMESTAMP is not
> set, so its metadata union can be overwritten with an unrequested
> timestamp. Fixing mixed metadata states within one MPWQE requires a
> separate change.
>=20
> Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload
> support")
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c     |  3 ++-
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
>  include/net/libeth/xsk.h                      |  2 +-
>  include/net/xdp_sock_drv.h                    | 22 +++++++++++-------
> -
>  include/net/xsk_buff_pool.h                   |  3 ++-
>  net/xdp/xsk_buff_pool.c                       |  7 ++++--
>  7 files changed, 26 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
> b/drivers/net/ethernet/intel/igc/igc_main.c
> index 39043d8ca1bf..59067939a586 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -3074,7 +3074,8 @@ static void igc_xdp_xmit_zc(struct igc_ring
> *ring)
>  		olinfo_status =3D xdp_desc.len << IGC_ADVTXD_PAYLEN_SHIFT;
>=20
>  		dma =3D xsk_buff_raw_get_dma(pool, xdp_desc.addr);
> -		meta =3D xsk_buff_get_metadata(pool, xdp_desc.addr);
> +		meta =3D xsk_buff_get_metadata(pool, xdp_desc.addr,
> +					     xdp_desc.options);
>  		xsk_buff_raw_dma_sync_for_device(pool, dma,
> xdp_desc.len);
>  		bi =3D &ring->tx_buffer_info[ntu];
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> index 3d19dad8f868..d194eeddd7b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> @@ -99,7 +99,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned
> int budget)
>  		xdptxd.dma_addr =3D xsk_buff_raw_get_dma(pool, desc.addr);
>  		xdptxd.data =3D xsk_buff_raw_get_data(pool, desc.addr);
>  		xdptxd.len =3D desc.len;
> -		meta =3D xsk_buff_get_metadata(pool, desc.addr);
> +		meta =3D xsk_buff_get_metadata(pool, desc.addr,
> desc.options);
>=20
>  		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr,
> xdptxd.len);
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index a71f0df26378..62de03e65a90 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2719,7 +2719,8 @@ static bool stmmac_xdp_xmit_zc(struct
> stmmac_priv *priv, u32 queue, u32 budget)
>=20
>  		tx_desc =3D stmmac_get_tx_desc(priv, tx_q, entry);
>  		dma_addr =3D xsk_buff_raw_get_dma(pool, xdp_desc.addr);
> -		meta =3D xsk_buff_get_metadata(pool, xdp_desc.addr);
> +		meta =3D xsk_buff_get_metadata(pool, xdp_desc.addr,
> +					     xdp_desc.options);
>  		xsk_buff_raw_dma_sync_for_device(pool, dma_addr,
> xdp_desc.len);
>=20
>  		/* To return XDP buffer to XSK pool, we simple call diff
> --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h index
> 5dcc0d7f65b7..a452b7828ce4 100644
> --- a/include/net/libeth/xsk.h
> +++ b/include/net/libeth/xsk.h
> @@ -196,7 +196,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct
> xdp_desc *xdesc,
>  	struct libeth_xdp_tx_desc desc;
>  	struct xdp_desc_ctx ctx;
>=20
> -	ctx =3D xsk_buff_raw_get_ctx(sq->pool, xdesc->addr);
> +	ctx =3D xsk_buff_raw_get_ctx(sq->pool, xdesc->addr, xdesc-
> >options);
>  	desc =3D (typeof(desc)){
>  		.addr	=3D ctx.dma,
>  		__libeth_xdp_tx_len(xdesc->len),
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index b344789f5df8..d94aeb506379 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -240,6 +240,7 @@ static inline void *xsk_buff_raw_get_data(struct
> xsk_buff_pool *pool, u64 addr)
>   * xsk_buff_raw_get_ctx - get &xdp_desc context
>   * @pool: XSk buff pool desc address belongs to
>   * @addr: desc address (from userspace)
> + * @options: desc options (from userspace)
>   *
>   * Wrapper for xp_raw_get_ctx() to be used in drivers, see its kdoc
> for
>   * details.
> @@ -248,9 +249,9 @@ static inline void *xsk_buff_raw_get_data(struct
> xsk_buff_pool *pool, u64 addr)
>   * pointer, if it is present (initialized to %NULL otherwise).
>   */
>  static inline struct xdp_desc_ctx
> -xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32
> +options)
>  {
> -	return xp_raw_get_ctx(pool, addr);
> +	return xp_raw_get_ctx(pool, addr, options);
>  }
>=20
>  #define XDP_TXMD_FLAGS_VALID ( \
> @@ -318,18 +319,20 @@ xsk_tx_metadata_request(const struct
> xsk_buff_pool *pool,  }
>=20
>  static inline struct xsk_tx_metadata *
> -__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
> +__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
> +			unsigned int options)
>  {
> -	if (!pool->tx_metadata_len)
> +	if (!pool->tx_metadata_len || !(options & XDP_TX_METADATA))
>  		return NULL;
>=20
>  	return data - pool->tx_metadata_len;
>  }
>=20
>  static inline struct xsk_tx_metadata *
> -xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32
> +options)
>  {
> -	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool,
> addr));
> +	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool,
> addr),
> +				       options);
>  }
>=20
>  static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp) @@
> -510,7 +513,7 @@ static inline void *xsk_buff_raw_get_data(struct
> xsk_buff_pool *pool, u64 addr)  }
>=20
>  static inline struct xdp_desc_ctx
> -xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32
> +options)
>  {
>  	return (struct xdp_desc_ctx){ };
>  }
> @@ -530,13 +533,14 @@ xsk_tx_metadata_request(const struct
> xsk_buff_pool *pool,  }
>=20
>  static inline struct xsk_tx_metadata *
> -__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
> +__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
> +			unsigned int options)
>  {
>  	return NULL;
>  }
>=20
>  static inline struct xsk_tx_metadata *
> -xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32
> +options)
>  {
>  	return NULL;
>  }
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 2bb1d122b1bc..a7df573784fd 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -154,7 +154,8 @@ struct xdp_desc_ctx {
>  	struct xsk_tx_metadata *meta;
>  };
>=20
> -struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool,
> u64 addr);
> +struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool,
> u64 addr,
> +				   u32 options);
>=20
>  static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)  {
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c index
> 78c14f106395..9d2d94f1fb75 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -763,6 +763,7 @@ EXPORT_SYMBOL(xp_raw_get_dma);
>   * xp_raw_get_ctx - get &xdp_desc context
>   * @pool: XSk buff pool desc address belongs to
>   * @addr: desc address (from userspace)
> + * @options: desc options (from userspace)
>   *
>   * Helper for getting desc's DMA address and metadata pointer, if
> present.
>   * Saves one call on hotpath and double calculation of the actual
> address.
> @@ -771,14 +772,16 @@ EXPORT_SYMBOL(xp_raw_get_dma);
>   * Return: new &xdp_desc_ctx struct containing desc's DMA address and
> metadata
>   * pointer, if it is present (initialized to %NULL otherwise).
>   */
> -struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool,
> u64 addr)
> +struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool,
> u64 addr,
> +				   u32 options)
>  {
>  	struct xdp_desc_ctx ret;
>=20
>  	addr =3D __xp_raw_get_addr(pool, addr);
>=20
>  	ret.dma =3D __xp_raw_get_dma(pool, addr);
> -	ret.meta =3D __xsk_buff_get_metadata(pool,
> __xp_raw_get_data(pool, addr));
> +	ret.meta =3D __xsk_buff_get_metadata(pool,
> __xp_raw_get_data(pool, addr),
> +					   options);
>=20
>  	return ret;
>  }
> --
> 2.53.0-Meta

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
