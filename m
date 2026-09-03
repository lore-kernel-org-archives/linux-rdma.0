Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8309F372EDE;
	Thu,  3 Sep 2026 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431201; cv=fail; b=ABeKIafNvBbMp3cxdrYcfa74TNs63E42XKDP02j9dQLKybTgphFG3BsTj1lgZASaetJTeVtZvQ5lbPUvXmVDxaBZnELAvAvXRIY8p4Hi38E4PKqhs/13+r0SH5Ip+imKQl919FCZvurT/bUgpQj5DC0OEa633ZW5ip5uH6s8boM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431201; c=relaxed/simple;
	bh=2FHuZuYVvO6V67vK4FzoTcR2vO2OA+5C1Pykeg83br0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IYKgIRcLXpvEpwkx6S0Z90Rx+eQVDKm/K6850CjZiP0hWRmQjsq/ln50IAzFF6Gr6PhxsvIzGAPDyCKJ79lN0yd0+F9LctQ8A+Y1jbpuktHVO6bIruhv5+JPW6FRdLNXr0yaNiD80l/9hhvJmESB3Jei0cAYH8qdiiXw4Q59YOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NFFzbm6f; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NFFzbm6f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788431196; x=1819967196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2FHuZuYVvO6V67vK4FzoTcR2vO2OA+5C1Pykeg83br0=;
  b=NFFzbm6fbxHxc6bFOA4f2EFCd8i3Yjon4tFSASApSGYDHPXFnwd4CLBC
   eqONytJm+kRH0U+xRvzivQ0S4UTIQn9UX+p96oT4zd8a1pb54NyOoiD1g
   4mF6ruulM9sk3pX5g1fHtnLhHrPA3HCbaALccMEAsL6xpcz96KFYNWDRq
   0Vu0awO3Ha7lEZsqbZali6QbX+9EI7y/KNB2NdPFeRAZ1azpZN6POvbN9
   PPCRqNSCTp7dNRWGbDI7tIR9S5TkvJ3gqqfsBGgJYeen37C+KIZ5KiSEY
   +ZGHq1x3Nr/xmRjYYQrSjoZSw4/1LG4+nr9X/8/tgIjsWG7VEye6BYj4Y
   A==;
X-CSE-ConnectionGUID: pyRnZM4HReGb6QwYtZeinA==
X-CSE-MsgGUID: 31pu4UHQR+GIRWA+UR4Sqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="114454995"
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="114454995"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 03:26:29 -0700
X-CSE-ConnectionGUID: qJGZvTZvQs2Dsjm9eKCqow==
X-CSE-MsgGUID: vhzdyE04Q6G+4AuUaj0HZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="273435852"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 03:26:29 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 03:26:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 03:26:28 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 03:26:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u57gUN+0ZLJYfbznPCmwQ4qqK/jfu0U7mEGzBGA2MgwTLg1alMTyZZuEB4AiQ3IlQKgxJgYkCH6YSavRQulbforifZrLeANhmE7jvylEVXxrF5DHRDSSAy09mjVNqLEZSfHXHEH6A2FqSjhzLuKRxlHMrK/1VAUuz3yW1tThDctyggdYlbr5z48+IyRJRNQVBEabuY4ShvboHwfhSBWADrRUNKqEQStJCXW/515zXU7TfyXj7ozsj/r9siw4QWebiJ4IZTNvt+Fp6kHJp6IhYRFPNeGfcGgQg1fYN0SkZej9bSk7sXZDgdlDKZZ1FahoIgK7YAw+IVXuMwuDFNoKCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pylrm+mL3D5b8nmSdrTAPTbQy2W01KsNd0d7LPOFzE=;
 b=XcC81HiHCh2dIw40Qeh+rH1WbtjQPv+TwKABqb2pm42DtQKI99nSEZiNblwbndo1XhPD1zYiHrGZbpaLvnZjXuDEPnb49YCsguKXv3i13U2kZL13Xuu9T+LCpcP0fINpswTrV702n7v1roiUzwTzyJ13ADjk6x3Ggwh4Hn7Ja+wJoQwd9XyqVsFJXtG39BxZV24dzjvyPXO0fju265jya0GnlYl/O/jOcxzd5YmSGs72n9Ml4jIs5rGKjqMRdYU1PWxVCBMLBilgyILAsQpr9Nt8IVKSnFp1THOdXC004tMwue9oIaoXBRm1aiXNc9FCMNez3uWGeYIQG+ux4QYE3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by MN0PR11MB6009.namprd11.prod.outlook.com (2603:10b6:208:370::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 10:26:24 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%6]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 10:26:24 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca
	<sd@queasysnail.net>
CC: Alexei Lazar <alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>,
	Allison Henderson <allison.henderson@oracle.com>, Antonio Quartulli
	<antonio@openvpn.net>, Anubhav Singh <anubhavsinggh@google.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Zahka
	<daniel.zahka@gmail.com>, David Wei <dw@davidwei.uk>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, "Keller, Jacob E" <jacob.e.keller@intel.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Jianbo Liu <jianbol@nvidia.com>, "John
 Fastabend" <john.fastabend@gmail.com>, Kees Cook <kees@kernel.org>, "Lama
 Kayal" <lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Matthieu
 Baerts (NGI0)" <matttbe@kernel.org>, Patrisious Haddad <phaddad@nvidia.com>,
	Petr Machata <petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, Richard Gobert
	<richardbgobert@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Willem de Bruijn <willemb@google.com>, "Willem de
 Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH net-next V3 14/15] selftests: net: gro: Add PSP
 encapsulation and encryption
Thread-Topic: [PATCH net-next V3 14/15] selftests: net: gro: Add PSP
 encapsulation and encryption
Thread-Index: AQHdO4Imb0/LhpyegEKs4IjPL7svCra8pfUA
Date: Thu, 3 Sep 2026 10:26:24 +0000
Message-ID: <IA3PR11MB89865A2D1E7F7A94C9AD1480E5B62@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
 <20260903085215.3691657-15-tariqt@nvidia.com>
In-Reply-To: <20260903085215.3691657-15-tariqt@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|MN0PR11MB6009:EE_
x-ms-office365-filtering-correlation-id: 38ec4f0c-1682-478b-1037-08df09a5ce5d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|38070700021|10067099003|6133799003|11063799006|56012099006|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: /fRMC8QwYKdV7TDA+I+ff6JkPWT/hYOQcJ3Ef5PrhJ1eSdajyj7NRZZA/ITH9EvRWU0MJaTh72BqozfMQ6gvQwUcXTTYzy6dfCX68lRXaHKPLsl73XZ3saLwqqAlxunROivHzo3N62AA7KWtO1Ikov/Ku1LypUscYYR9/utmwgsrfUmG6tjFE6k72yr7LQwaSMEQqRu80KRVGV6SHeblvTddOeNpxQRjCkBid3nGd9wTmCH8iZACiuu/BH8xo7tsjxMPipMd//9rQUW2lMFXFvKBGf+pLA9tRl9zpPa5H5kQuQdni7KWP0Aee7OyB6gciM0IKexH0F0NNrkK56t1z+5lNlYsZC/7UjfeG99+3bW//Ckrv+iSfa/WDekc+ogxsinDbrE8hCFaSB2CZnTfjM5JNJ8y9u5BsYcqRxekjeREPynyCRfFbLvU1OpJYCaqLYK427Bb84gzLcpJ7RYKwBWAIO5Crqw4W8mfhyfqd5j8zaSM7LfGfC+IgXg/7MPJCKcL3Q83B5s+uaw4rFAdaiiyVzFlhPB3klyQHOvivRUXtZo93z+d5PaGmIQYGKfjU4W9g+GWhfVZcL3MG6uV0t3Jhyk2iYW0WCjwGDUYNXtoaA3WbFoezHmmx/qYc9khXB+icFNKyK+h7a2R2EdjI3i+hp45fWaB0/JxRF3cJUt9ptEFdJhEY28P+R86Dg/zBSvn2XlEkUdG4ChcAHZ5U9jWfiUORoqkbp9GM0jSXE0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(38070700021)(10067099003)(6133799003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lDLiJ1Yv5/kQ/JRPMSSeNXgRwwHMRLj0PeiOdFslkg3EVRQ50otP3XGIet2Q?=
 =?us-ascii?Q?r7LT7LWAwoLSCRITd7FxNHpDgMN+LLs7Ekx4QXpOkBqp8jUwubaeycD01oyz?=
 =?us-ascii?Q?suGCcYDHhXWOrZSUcenjPj3W7CFFvTfMzfkGRJH/zndWINh+959dZhrMb4jE?=
 =?us-ascii?Q?+NUGGpcZyE6VqnC9CUvvQXRULHhfiV81nMrcjS2XX/mvL5q2f1tNMamKlXAP?=
 =?us-ascii?Q?xy5jsnSio+734n5/MG1l+3muTIDfYbSGX3PclT8i4Stwx6g+ZqebGN+gDtMp?=
 =?us-ascii?Q?3SvhMpIo/MPRaklV2xjJLmbAbiP8qvB8HP5oGsvP8sNTyHBwzop6OMP0hXSR?=
 =?us-ascii?Q?T42Qbiknurpj5L8ehDn5kKAA1x3CgcDfnXV/RRf4Ja3EjqI6oKIjjvScFTJQ?=
 =?us-ascii?Q?ClOMAH9LfZ9G3vXwBcq6jxRcDhk2ExEluZtWaPmtRyojevBORxTEDK7FcrYk?=
 =?us-ascii?Q?hIZqNex/CgCQa5gLwF/S7jFl5SjaI35VqRljNM1B3wwNCb3I+ss2wAV3F6vg?=
 =?us-ascii?Q?VAsQCrj8pNk6r7VFhqp22xTJQXoqI+TFdiDG2/TV5Jxfmx/AFZYFCAJ2F88k?=
 =?us-ascii?Q?NfX/1UilKsX8Nix1NTxOEzc2ZYPsupaOu9aFpI2AA03MR7tggNWqluwE9j/i?=
 =?us-ascii?Q?pFmsVPSl8AlLSnQSTe3Zrojrsp40/BlXuUS/7F88sH+uqDfepknNA/1Syr2y?=
 =?us-ascii?Q?5vjB7HTfdzzf/7ZF1wVCqyJW9TYJNoi9EVZXzDW19Z4rW9jv8oOPlEJh4lIC?=
 =?us-ascii?Q?RHDhQQ+rNSd41Lqtmpp6JsBV2jc/N6pPQJn4msU3twyTOMNHvxhCPrWnFxAK?=
 =?us-ascii?Q?v7sIbjCtl7lfhJ4LBNgQn7N3sytlaAxnsXNC8qCa+4VHEDY0AmJOJ9u6wm9W?=
 =?us-ascii?Q?agVEAN3swSVrR05AKcNxCS80qT8DMEdyo44rk5cT33e2cURTuy/OtXcV+lIJ?=
 =?us-ascii?Q?MjzpLvzV4EcQK1JnCjfdBkRetI+sEnDVuqhAFuP3kIdrb+883Niev6tc/TUv?=
 =?us-ascii?Q?H1Wz99I5Wtq5oJoksZUesl9wZ23yQ5ppOOT0OAoR5eoFcF2OCaPfrnyl6/H/?=
 =?us-ascii?Q?zUqYx5reW3UK/6Eu1ayFiCzogskBKBmNlbJyBDpbjseYFIxruJjXVyIkT1zk?=
 =?us-ascii?Q?mZYOydathTDlQ8a0RPY6aZmwaRQUVKrDuZy3vhyWpC9FOIAXgayuXssD08dL?=
 =?us-ascii?Q?mbxi32/t8bobKptGS2K8gpfLH5Q0hyAu7r8Y0YHNPcZ9kCAhieecDgMWL0I5?=
 =?us-ascii?Q?NDuS4OoMVdkKBQfXhZx38Z/AFZrjCQBJYF0LEJA/AmpgZoFueKUnwkXt1PaE?=
 =?us-ascii?Q?Wxqgv6yEyVj072Ey4/4e2rvNb5QeDl1udeytt6ifRba80kEB9kluCvrBLgjC?=
 =?us-ascii?Q?oVp2Xmbg9GPhrJ8zjdEK/nkv2fxs/GSfP7snZ9/v4q4oK9ddKRygen/E1f8k?=
 =?us-ascii?Q?UbYAnGhLyAtLexsWMo1ja1E6BOwKNJ/yk6IkpXLnoPLNbUuM2O2PVV2rLXRp?=
 =?us-ascii?Q?oMep3bbkJb0kefBI4SXK1XKAU6nzQvMZ6cTSEK9WMhyhty0YQIQE58/f4ILe?=
 =?us-ascii?Q?4JHhiXoFBivc5143us+koNpL9CJI9CRqzjU6ci4XHgquJmvK62z5QABY18fG?=
 =?us-ascii?Q?VKjZG5Ojx3aHRQMAXdUyxgsI2WJL4zZU4Alcn1Q+Zyv1sA7H2/p/FoAe03PC?=
 =?us-ascii?Q?OR4gTAaQFOVvUjjZAxTGJRA0xFNiOxU6thPTFYsTSie/YWb1b1iDW8baXS4C?=
 =?us-ascii?Q?cBLy57RIX0wHqmZWb+ZtWvCtGc82jg4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qTBEPsuvg7srouPoBdpzcIdFte84MoKYiA+PzwF0QxqTFTUe07YTG2kI4dFd5weiazRbWF54C81nt+uKlcKvP18x9b/Mr9XCkHfyDuhb4aBgBgYH0Wuv8oPJEeDQ7ImWFFyDoCFs2QzxpVx1tUUg00/QjiLYURushOK1YVmfL5QcILYgJ07WZGwXMesaE6XTC6zbo49znJaFBVWDOZxLpzEmCzP7lztgGMff5ZK9Lcag3Dtq69XaZVllSnWXsUTHGDYmK6MzbADNYucFpJGjQzdl9NDlw5WyHZr3nrYV83dsbMT9Vw50e9DICnyXw2ErsGQMxjOwH1wvyfSoIKG62g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ec4f0c-1682-478b-1037-08df09a5ce5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2026 10:26:24.5734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MCLMtYr6BWzo9xRTNcU6N0XsQh3NlRKtW6XGhgAkLxi+fX167OIl1KYtQc/I+xdUkudCp0w803IvuiP2gVuIXOh//wan0L4dszAY6s8eWHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6009
X-OriginatorOrg: intel.com



> -----Original Message-----
> From: Tariq Toukan <tariqt@nvidia.com>
> Sent: Thursday, September 3, 2026 10:52 AM
> To: Andrew Lunn <andrew+netdev@lunn.ch>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org; Paolo Abeni
> <pabeni@redhat.com>; Sabrina Dubroca <sd@queasysnail.net>
> Cc: Loktionov, Aleksandr <aleksandr.loktionov@intel.com>; Alexei Lazar
> <alazar@nvidia.com>; Alexei Starovoitov <ast@kernel.org>; Allison
> Henderson <allison.henderson@oracle.com>; Antonio Quartulli
> <antonio@openvpn.net>; Anubhav Singh <anubhavsinggh@google.com>; Bobby
> Eshleman <bobbyeshleman@meta.com>; Boris Pismenny <borisp@nvidia.com>;
> bpf@vger.kernel.org; Carolina Jubran <cjubran@nvidia.com>; Chris Mi
> <cmi@nvidia.com>; Cosmin Ratiu <cratiu@nvidia.com>; Daniel Borkmann
> <daniel@iogearbox.net>; Daniel Zahka <daniel.zahka@gmail.com>; David
> Wei <dw@davidwei.uk>; Doruk Tan Ozturk <doruk@0sec.ai>; Dragos Tatulea
> <dtatulea@nvidia.com>; Gal Pressman <gal@nvidia.com>; Keller, Jacob E
> <jacob.e.keller@intel.com>; Jesper Dangaard Brouer <hawk@kernel.org>;
> Jianbo Liu <jianbol@nvidia.com>; John Fastabend
> <john.fastabend@gmail.com>; Kees Cook <kees@kernel.org>; Lama Kayal
> <lkayal@nvidia.com>; Leon Romanovsky <leon@kernel.org>; open list
> <linux-kernel@vger.kernel.org>; linux-kselftest@vger.kernel.org;
> linux-rdma@vger.kernel.org; Mark Bloch <mbloch@nvidia.com>; Matthieu
> Baerts (NGI0) <matttbe@kernel.org>; Patrisious Haddad
> <phaddad@nvidia.com>; Petr Machata <petrm@nvidia.com>; Raed Salem
> <raeds@nvidia.com>; Rahul Rameshbabu <rrameshbabu@nvidia.com>; Richard
> Gobert <richardbgobert@gmail.com>; Saeed Mahameed <saeedm@nvidia.com>;
> Shuah Khan <shuah@kernel.org>; Shuah Khan <skhan@linuxfoundation.org>;
> Simon Horman <horms@kernel.org>; Stanislav Fomichev <sdf@fomichev.me>;
> Stanislav Fomichev <sdf.kernel@gmail.com>; Tariq Toukan
> <tariqt@nvidia.com>; Willem de Bruijn <willemb@google.com>; Willem de
> Bruijn <willemdebruijn.kernel@gmail.com>
> Subject: [PATCH net-next V3 14/15] selftests: net: gro: Add PSP
> encapsulation and encryption
>=20
> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Add a PSP mode which wraps every transmitted frame in PSP transport
> mode and encrypts them in SW with the help of OpenSSL.
> The receiving NIC decrypts and decapsulates, so the frame the receiver
> sees on its AF_PACKET socket is identical to the non-PSP one and every
> geometry assertion in this file applies unchanged.
>=20
> Sender packet construction is unchange, PSP uses a different buffer to
Probably 'is unchange,' -> 'is unchanged,' ?

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

> avoid double encryption.
>=20
> A few PSP-only cases are added: psp_spi_diff, psp_ver_diff, psp_mixed,
> to cover coalescing scenarios which only exist for PSP.
>=20
> OpenSSL is optional and scoped to this binary: gro is deployed by
> several suites, so a missing libcrypto costs only the PSP mode.
>=20
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  tools/testing/selftests/net/lib/Makefile |  16 ++
>  tools/testing/selftests/net/lib/gro.c    | 337
> ++++++++++++++++++++++-
>  2 files changed, 351 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/net/lib/Makefile
> b/tools/testing/selftests/net/lib/Makefile
> index ff83603397d0..ce67e8d3e4f6 100644
> --- a/tools/testing/selftests/net/lib/Makefile
> +++ b/tools/testing/selftests/net/lib/Makefile
> @@ -22,4 +22,20 @@ TEST_INCLUDES :=3D $(wildcard py/*.py sh/*.sh)
>=20
>  include ../../lib.mk
>=20

...

>  	read_MAC(src_mac, smac);
>  	read_MAC(dst_mac, dmac);
>=20
> --
> 2.44.0

