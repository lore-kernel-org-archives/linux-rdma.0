Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795621222;
	b=2xMxx9QlOIGNxcNFhhKbuc14L3HQGy8n+8XmD4PZrRk8Ak1qtQu0a7OBlU0Uu1LR47vE
	 cBtdCEZ/NrT99FQ1sBI0AmjR4CkzvedXy5eSE14p1OrFvcTLbxDoh0QREip6pPId6X45C
	 Xn1pXNnT+13qEPPBNnknQvRKHjEwBHTVvHHysKr653eRN9TmKg36iArOKuv27sBmORsP3
	 zGeCZtY32tQaqrcrg45u/kZj/xEExfi5wdE3Tfo6L9dVyB8xvosMvKv1bhpPBU/OdIX00
	 /fBECQgIjJ/Xd4H43DWGgiW6U6dxsHRFNM8n6etuL8UUqkJlocl5pK6ATPEBi23bBug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621222;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=N7MgCH36LOpGbzll2FsB5w4F1EdhBiqOziNsOln3FdY=;
	b=SABnqVzL3StWO6c8LuHFIge/PU0v9+1bRj+Avsow2EGcgeH+MQo+Hu57XUtUu27hgXgt
	 CBRi48lmNMDP5sa326Wv5nIUhXelSXgHzKwPR26TL2f+N8+tDtRtrjBnsG3X1U2p0Qywx
	 9Z5OzSdboRLFgmQ4hz7LKFO23a+uDaw4SNTtLOoMk2Yisoh5bXwJsJgkJzo4envzug1sv
	 RnKLxoR9+ttHjv80bQrPli1MyXvGKifRfaA2Yl/q8Yom8t1NS08MOfiTHH/9LmmeH+bcn
	 ZcVPxJbal302AASBqCUtpDlq6e4/LMhhqyu/+iOlWq0lGuVqdVWfHytl+hNTtVkng+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="eal/tn3H";
	dkim=fail reason="signature verification failed" header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=WLrJyApG;
	arc=fail smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD21607DE80;
	Wed, 25 Nov 2026 15:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD21607DE80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=eal/tn3H;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=WLrJyApG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795621221; x=1827157221;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=roOVXj6CeQ8FA5Jan+1r9xqNNUgd0UpDRQYx6ULKAuw=;
  b=eal/tn3HAVz6Cqq+48EUpZDc/ASjs2tOj8yuuFU+3N5Iwxkdp1962RWy
   aqMGoj2cIy4+oks9qhbOwyM8ENy+l5zcgvap+vbmbaxp3d9a9U/fpbxoN
   98/HoBAkj60Dpwggyk49aYL4aJOquHdIq4CypsW8XnTMApIl8a3/C/b4k
   MCWzHICVEj9poCSdJ+B/HEVcU7X41/9oobY2RwRK1wrdtgAYtAMtzt6Ze
   YkM5G3YzyX9Anvx+NIycb24vG3lx2xgBf0xTm4Ot94lcIVd3gwnVU5UPD
   geB5A1irEBj6lGGkbjPrWhJ08GvoWeCA86lihdEb1XXmkFgI4WiMNsIbn
   Q==;
X-CSE-ConnectionGUID: 4/VaX0KCQ2KFUAMkvTJwgQ==
X-CSE-MsgGUID: W+zZR367Sc2D2MChookFQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4538407"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4538407"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:22:19 -0800
X-CSE-ConnectionGUID: UbJHHbNgS++TDMOy4vTI6A==
X-CSE-MsgGUID: 8dItsquVRVOmnnWtaBcB3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="12109670"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:22:17 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:22:17 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Wed, 25 Nov 2026 07:22:17 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.9) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:22:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ROYJEroIJ9L4+u1N3A7CDzQeeAgs1FiQJKcy86hUqM3nByeBDvYRBphb33HqUFlIcH0+F4Vg0Za99/4ghAhybXUBiNWvxkxqmjFFWTHD3DsKEXjjfc8rLUDsrInLF1NAgJ8nEMQmW2eQHn+d03n5RiBTGUCXbZEpXKTG9i3ah2q6c0jpiWnrXD7AjwDbk/jf7pLzhrcSuHpPZanjaB7bh8/GpjpAUPuZnuPtZUrF9pch4Pw2+orPKRSUSOszEn1jmwELqeVVNJcHpWxN5J+a6+TAYh7QgqeusFv5TAqrCpI6sAqHV7omZsUhCUHixY+Sq7ujbGunykKYkWtJsU7+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4CZebWwKQ4YdEIYOGnv5jHEFTrq2a6nzRFN2o19ZfI=;
 b=soYJ0Ya3pLnNAkFghLYqPec8BUt4iWIeUR8oSLO0D8rsfvkPVZVoTA1lRJm/lbEZuV49vB219asG18ANcmuFCEwsMeRg7TVNTfRkjm+1Zgs4zUqAtQrfm5Xx80xkRxiZ6Ptc409CD7XDbvG/a1NRVAtSIvB5425BL5jU4QABfBQuNW6Izh9j76tFEzzKUCVMCarjzvVFoQ57tBH0AUAXIVGH4BQ3l8VgCASnsmE4JcMsU1nzR8aY0BsMcQ0e0O+c6PJgWc5rst/xwGVYYEjcb46UzrUU5O5Yx9RV1wuX2kzpK8ZV9IIZjpDEuDMWa9yxXUp4c/8irkHQ1caDvRdLxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4CZebWwKQ4YdEIYOGnv5jHEFTrq2a6nzRFN2o19ZfI=;
 b=WLrJyApGaJCC5NIZD+TR+LSc6GyD/HR9wRssDJrWE5vQ0C1NrSjDLR4PMYPabFb2Q60o21yi/CnQQnDr1fsmLU8B6j9DbYmTf5im1Ox3YdLveucMV8ssqnXalzBTOGxoJuR5M0L46JD+ZxZdHM2IsH7+Lfcvip1gyEFJa9V74Hk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13) by DS2PR11MB595222.namprd11.prod.outlook.com
 (2603:10b6:8:3c6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 15:22:14 +0000
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de]) by LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de%4]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 15:22:14 +0000
Date: Wed, 25 Nov 2026 16:22:03 +0100
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>
CC: Magnus Karlsson <magnus.karlsson@intel.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi
	<memxor@gmail.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	"Alexander Duyck" <alexanderduyck@fb.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Tariq Toukan" <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Michael Chan
	<michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	<bpf@vger.kernel.org>, <netdev@vger.kernel.org>, "Stuart Clark"
	<stuclar@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, Simon Horman
	<horms@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Mina Almasry
	<almasrymina@google.com>, Song Liu <song@kernel.org>, Yonghong Song
	<yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis
	<emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, Randy Dunlap
	<rdunlap@infradead.org>, <kernel-team@meta.com>, Dimitri Daskalakis
	<dimitri.daskalakis1@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>, Kees Cook <kees@kernel.org>, "Breno
 Leitao" <leitao@debian.org>, Maxime Chevallier
	<maxime.chevallier@bootlin.com>, Tao Cui <cuitao@kylinos.cn>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, "Mike Marciniszyn (Meta)"
	<mike.marciniszyn@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>, David Wei <dw@davidwei.uk>, "Pavel
 Begunkov" <asml.silence@gmail.com>, <linux-rdma@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 05/15] xdp: Run programs on buffers that must
 not hold kernel structures
Message-ID: <awb9GzkXa9Z9LxuP@boxer>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-5-bjorn@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124125654.183091-5-bjorn@kernel.org>
X-ClientProxiedBy: DUZPR01CA0169.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::13) To LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR11MB868673:EE_|DS2PR11MB595222:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb50a20-13e0-4c8e-58ee-08df4b07e227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|56012099006|5023799004|11063799006|261026121527099003|261021121427099003|261021123027099003|261102123227099003|261009223027099003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info: WZHpzqHTq9P75QKUSnGmzuqluBrwJG9y6vUaHcVgTMqsqCUkid87/hypWmX463cGksaRcrRtttar0pXSWKls/xUMGw/7rUpeVi8vfQ1cdGE1PGNWkdONfkgU+Tvn+kL5yC4ANwNaWkB7U7Tf5zF+LWVmAfRZTV7hJw+q3luRJOi/wIZqznMspNrg0iWtTnufvovxbc9UpQsU6vWModSsUtmIn4zmAu9WVY/cr0pImszsvkVg7RCl0dshgwnYUdbcxnFdMzXHkyowqDTjaD4K9d1SJPpInBfd90AT99Rhl5It8wTZzR+38TJsrZNeGiXLWIUnL/O+GJRN7kKGfhhlDvESHJuenFkn+VcPQnrj/9E5RagGDPixu4/cgBE7ZhZtkc5apLJ9KJLYn5S9N+yahxyeyA8c5hHYAgpPDb2h67AtjlUzt/3ii/UclsKEoKm5pvshVknytfE4EE9dGnTDBPlUlHlClX61qWc8/b3VVjpkfMkavcTZIwwzdwwhZN6OGSBXgduwlU05TRYqK+BQ+02L5iGpKAe63tgAabc2WO48Ui6iwXMBMOmKQ4jJ11CJDRT2Xfr1VG3iKEcDirn3F0hYpTjeBKebGil4q6euS5XMnA7nq3JYo5jj7vwUmD2Wn7GGKUxfBpykogPXZrXfMapk54jMfTAEzhr+mlA8h80=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB868673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(261026121527099003)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ba0hda/MOVfs1lhClxbMv8Yy6qktgcc8TtcTQoORHPWHqhFWhQ2dvNFmnR?=
 =?iso-8859-1?Q?Hwr8vU6KQBAiWKsKbEva7q/+bc6um9GGfAmm3X45nKgj0n6XWfm+FZ28yd?=
 =?iso-8859-1?Q?FG0dcrkT3YyoL1vBqmAjspPBmihs8VbhT38swHRuW1V+S3U3FfjNTkyENG?=
 =?iso-8859-1?Q?WW605KNGmMo1T2C84lSkqpX7VjlnBSI4ql5D8TEWiq09ke2wwX074Iw895?=
 =?iso-8859-1?Q?boreLKTQEx/46NVOk5vYffiXEiJ50SVBY5g7m0bxenT4miHfn62ON5MGWw?=
 =?iso-8859-1?Q?vPSAJWqh0/HM9/5sEw11w1Ui2Dxca/yt2r4Ps6+rnxNIlwN5J+X3s6qmDQ?=
 =?iso-8859-1?Q?oj9PN8Bw3nGEgi+MQCm0j0m8MzRL63cGRAu4xibEJMrIB057kgjZUiKtXh?=
 =?iso-8859-1?Q?qgSzKOnho3HQXOvmWbQ2EojxW9HQ25tR7/E7VLRqoDbQmIgY6wIPUjFroX?=
 =?iso-8859-1?Q?jexBpVp2kR4AUxun3pwpsKRZm71IqxoeqO2vS+ssREVP1rjkNuQGLHLXCT?=
 =?iso-8859-1?Q?wSQwpRcC5YspwWbKqPeKvACbca3exHWHeiGa3R4p5QOqB1rpWNQxzsbnLv?=
 =?iso-8859-1?Q?ZTYoZD8ZRxIoVUWpC4IRG66IKv9qDdcdUWvgqVYVFuzrGTrp7fw0G1F1dq?=
 =?iso-8859-1?Q?zauvgk4H4asAw4aQ9AoUuWaWrTgZw+3898pJErDNOPLE/ZXdvxcxsROfsp?=
 =?iso-8859-1?Q?xRKDMsjWra/Sculhl3zKzI2F0DlJhSx0N4y4Wg02OOfPfSSljus36EWBuA?=
 =?iso-8859-1?Q?fpiVora27AU0AcUayAX+7iykl3bmvpNvbCM5ZjixGwWbB6Z3plEs+a78bF?=
 =?iso-8859-1?Q?yi2Ddbx/BlIwlG9t7DdS8qZBLGBtdGsuP3juQaYc7NEYDzC4C5k8Y5KvWJ?=
 =?iso-8859-1?Q?mMxCEqcvGX8kAowaEoAdPCuQzGeyZoyhLnj8fV9kx4b8ej7Y21M80ybbvC?=
 =?iso-8859-1?Q?V6RLYuOL7qQ3CFHWwh31z815T2g3i19VrERMm3/urLZWGokrvgCZK8HLKB?=
 =?iso-8859-1?Q?qtV+jEQekFr7pQ730RYUBv2HdlleuN33Jm5oEg8kG/jA46BtiUa4GAoEKx?=
 =?iso-8859-1?Q?DKsmwx33HqWEiQWHyPG1cGQJDGCxwP71EQW3hPgo2W6OM7esoX4w2wuA28?=
 =?iso-8859-1?Q?5FylnrC9O/1Wm7iB2r1aOylGMN6ChceKKiKSiFNyme7jVAZeImcX94y0tu?=
 =?iso-8859-1?Q?OxA1KxHbEr3bJPnv1zeIZwiy4ZeN3R5MfkNSXsQO/DkmYQyaVY/rdXkV+p?=
 =?iso-8859-1?Q?p1KssbNWk159+5A4xVi0Er2nZvVWBVgiXZsX/PIF/i5mGKhiNcqI1SIYWt?=
 =?iso-8859-1?Q?A5Y96rHhYpL8Lk82wnDsjt9Oxx95IdrSxeZy+qgGyK/QxaGPr6IB3c00aA?=
 =?iso-8859-1?Q?/Lf+wsfp++UwZBaFUzDjXK6xnMuGFeQS+GhEp6U/knY8HJXI2KN9Gqe/go?=
 =?iso-8859-1?Q?87h2p6cPEmjmQ8UPqe51VMVWF73qyF4o5S0Ik9mNjcXSfknJD06tcA6gt3?=
 =?iso-8859-1?Q?Df+2AILo2Ed7ahCe5OTMnRJQ1sUSMuXQPtHrEsiVHHuaEeiAzJHRr4q+zx?=
 =?iso-8859-1?Q?WZ71Vof7ZFH9+L0fbt2WciPakAjuy+zCLL8JTiOiz4cDTIVusBk8LPhN4Z?=
 =?iso-8859-1?Q?idV5W9lpHsWKGSp4CFJck0Nmfb9iEamDOvTvRGkaw9/ptrJMGnAzhcHFj4?=
 =?iso-8859-1?Q?zY3H2eJ2WS5+mKoxcjib72A5QaQw6fnkeDUay/6tsWrvCFh0FASXQCKbT+?=
 =?iso-8859-1?Q?NvhhZURRqKixPfXaVZJ4ULWWKoO8sevVxzwiLiuRWq3sjjbd3Ib7Jtv2dO?=
 =?iso-8859-1?Q?zpSweKuJnpqkNkRnO5L5TXjAmL2ykUA=3D?=
X-Exchange-RoutingPolicyChecked: ayaBNCjhql+RxD8PvnRQ2nPXkqsN1OjwMsKi7xHiE+l0p4BgS541XsQI9BlLdAviCPPYPEeWCmso0EaLu9nMbX/4GbAhUp/xaG3+hpxO+n14cfaaQ28zVVyjBI+6PeA7LvO6R8qnJlMRg4dGPlbT6sD4hhhEvjq8bWJr/K627K5AMh8xLOMMAqKl6SXyYKiHUGPVT3d7c4dVWgHjcG7npeoz7nDIp6BUHyiaI+Ns77dhOv67jlHIOn1fvwuBPBUzVPdoeUt1pvcaBkNKaQ3fNqH76ktatVqFUoS9Gs8u4EUMQShy5l8uo3tMKCcA/XEGqaNbcpkkE2Psy27FeHZRRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb50a20-13e0-4c8e-58ee-08df4b07e227
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB868673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 15:22:14.1729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeNrU+XBBDdGKJi5U8V7ZceOW2JsBJ0spNgEtkVZmF27IziHYNuzFbuncmwK+HLmn3k9viH/7QUyOvEUXv7A0dJ3kGtH/4wwkAdBBhsDXSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR11MB595222
X-OriginatorOrg: intel.com

On Tue, Nov 24, 2026 at 01:56:40PM +0100, Björn Töpel wrote:
> Currently, the core refuses native XDP programs next to a memory
> provider. An AF_XDP sink needs XDP to steer its packets and to use the
> RX metadata kfuncs. Its buffers are UMEM chunks that XDP may read
> through the kernel mapping, but that userspace may write at any time,
> also while the kernel reads them. If drivers build XDP buffers on them
> as on pages, the core puts kernel structures into them, such as the
> shared info of a multi-buffer packet, the xdp_frame of XDP_TX and
> redirects, and the skb of XDP_PASS.
> 
> Let programs run on sink buffers as on pages, and keep every kernel
> structure out of them.
> 
> A sink offers an XDP view of its UMEM, so drivers build the buffer as
> for a page, while netmem_address() and skb_frag_address() still give
> NULL for sink net_iovs. Programs and helpers read and write the packet
> in place, fragments included. xdp_prepare_buff() tells a sink head by
> its address, with one range check under a static key, and marks the
> buffer before the driver adds fragments. Other buffers pay nothing
> while no sink is bound.
> 
> A marked buffer keeps its shared info in the queue, with
> XDP_FLAGS_SINFO_EXT, set up when the driver registers a sink page pool
> as its memory model.
> 
> A sink buffer may only go to the AF_XDP socket of its queue. The core
> turns XDP_TX and XDP_PASS into XDP_DROP, so drivers need no checks of
> their own. XDP_ABORTED and invalid verdicts reach the driver, which
> traces them and drops the packet. Frame conversion and skb
> construction refuse sink buffers too, so devmap and cpumap drop them,
> and sink net_iovs never become skb frags, so every net_iov frag stays
> unreadable.
> 
> As userspace may change the bytes meanwhile, the kernel takes bounds
> only from its own fields, and only the program and its helpers read
> the bytes. A helper that reads bytes twice must check a copy.
> 
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
> ---
>  include/net/netmem.h          |  5 ++-
>  include/net/page_pool/types.h |  7 ++--
>  include/net/xdp.h             | 60 +++++++++++++++++++++++++++++++++--
>  net/core/xdp.c                | 46 +++++++++++++++++++++++++--
>  4 files changed, 108 insertions(+), 10 deletions(-)

>  	xdp_frame->data = xdp->data;
> @@ -763,6 +812,11 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
>  	 */
>  	u32 act = __bpf_prog_run(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
>  
> +	/* Sink buffers go to the AF_XDP socket of their queue, or nowhere */
> +	if (static_branch_unlikely(&xdp_sink_key) && xdp_buff_is_sink(xdp) &&
> +	    (act == XDP_PASS || act == XDP_TX))
> +		act = XDP_DROP;

I think it would be better to follow SEC(xdp.frags) approach and from
verifier POV disallow progs doing anything different than XDP_REDIRECT...?

Here you affect whole system.

Also, I don't follow currently why xdp pass is not allowed, management
traffic gonna be dead on this queue.

> +
>  	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
>  		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
>  			act = xdp_master_redirect(xdp);
