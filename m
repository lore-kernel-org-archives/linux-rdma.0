Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795621128;
	b=aPakopYjcacqcVhR64dQKFR5Fnenm2LxeCvGQEKqv2jCWMAcRjr7ZVdzOzQfGgAn0keg
	 fD5upQwvv5JdwkWdBc0GaKtB/UmIks4LNbOdfcZlHM1T4o2dFE6da+TtdwWKvADOnXB05
	 rtrqoVlJ4YoSgeSd4QW/SG/L8rgZPaHvccFHsq6qR8Vv1O9xx/P38MJnjLKzCqr8NQ+9Y
	 OsJqqITMcoPim/sSgM3ZdEOK6u+kMMJCDRAavCO+PBLC7CNRJHDxN1gBQ1NmUrTuzS/nT
	 QowDvh46/x+FPLTf3dgEes6hNDIXfIFO1wDN7S7YVv/kNmCUAajrlq4oKzuYckcvX/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621128;
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
	bh=sVvPeWTwzGdW69mx6OGvvaPeCAlWhe3iQckWTuk2Tac=;
	b=uRhu2jRRESZVYDnVy858fOJHeDBA9GMXpGPY/MYzshgwnhmQSdMO8UnQPxhsUMcEiJyd
	 2symz+J/YZXXqwbMiy6OAcHC/6FE/sGmb70wmkapu68ssySxOstQAoS4PZU2qrGhPuHgA
	 ZGC+sSfg9F9EC5/oRWUrAv/kix998yKPLrfN2+gcZuwLdDTv7niwkYJiKcR7mKlEMV+Gl
	 ayd9deudUPiFK2mcwXi4OGO4+3UIfZr3YKnY9KxqYy0USRFLpcXdH53clQJXD5dlTRR7n
	 suohTbDj5XP0Zumt/gLrJGNIYQQ4/e8p0TOM2bfMJuln7NPh2oO7/R+liUAVX1m9B5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SbT1nnWF;
	dkim=fail reason="signature verification failed" header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Q87HlC8Z;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126B3606A31E;
	Wed, 25 Nov 2026 15:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 126B3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SbT1nnWF;
	dkim=fail reason="signature verification failed" (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=Q87HlC8Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795621128; x=1827157128;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=46NiGWDNRpHoOoSBzKHJOmEdbJE1b4XZYCTz4Qgz+ys=;
  b=SbT1nnWFUqrU5/7VOk+caR9728Tu/bBZA0MLZS5OCILl0L4+nryYDaCr
   nkfFwLLZJ/WHkKkhgaYRu7ebB9p6/qLV2mex73ZlRMsshDDr/ZsllGxAp
   7TZwUS5xzSD4/G93L3iBoHIpLt2qo3z5su9s4VADIijHsViOaNZP6pyjv
   e9pXGsi14iJLQmIbCUH9XsWs8ZP5p2or+UJ6BDZ5Mq1V2YfMENGYVZ7/u
   FkW0ZoOn/PZ06LO/rTI3jeB7ma0AAUves9+zCTssejbrYL0BlL6WfEkpb
   HlGl8w1nTaSMlAWPd9NEKHIQtlazHpMBu6C46whq0T8ADRJ9oCKms05n+
   A==;
X-CSE-ConnectionGUID: V271sjuzSEaxlLAcZoDP4g==
X-CSE-MsgGUID: oVr5NPWVTDS/hFeachukVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4393705"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4393705"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:18:38 -0800
X-CSE-ConnectionGUID: bqseXwI7Sq2qUBqbcOROjw==
X-CSE-MsgGUID: r1/6CRmhQUuGbnIQVn2qfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="12366173"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 07:18:37 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:18:36 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Wed, 25 Nov 2026 07:18:36 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Wed, 25 Nov 2026 07:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vriS9R5CwlCiyVlKVjjiocKLMeS5pw3xLyPqk8lXe1UnAFczkcphtPGmXj61ro8Hz7U3Qn1vofylnstiI7ccRuFXRlDlXtc1f5x0S6Y0wtvto9LHpRjHZhQ1bpjQefL/GcDqCfpTsIvBtIArQ04OJ6lwdeL9nqvGtkAHG6e2jzdnctA/RxuTvzIidINuPDiELyTeWki7KC7vl+Pr3X7BZT+CUcF/z8ESX5b4Ge09jKC47vWukATjCiEAHA47v5UzkDEUNAtbLLEeXp7WTdzPA91zSXEwqRCbs8TCALjuaoVYGKOwkCBbRpEHIoDHFp2VhaTTql7rSXLiChKvrpDzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8y6FjtpQi1jTgZkHxpMYsMhlYJh6eCkG0ZD5gpIWoio=;
 b=W3Nv1mR2naVVGf561VHn7sLm1a4tfDZQ7OmJLZfawBCw7YCBmQFKcLjTIICR0aKKQ9Gf672g/AdOgWKpHjh3z4JuIqpmLEC18FYvGvFGK6/9EHisnzccjF9wygyflUz4i3zqJWgvwRTHokiAY+mA35KiXCPlcBYLOkMyZcWfgwFkEoOgCHd6lZgJacVdxtHqy8Y/f03YtG/wVLFAod3n1ykzfrFh1K0g1Qs4hznAbl4iSrjC6BrG7x82KbduYeUoUufsJVSe8umDsQajRXtABBviszz2GN4i/ajfEvjkIeypTCyuDfDtw+WC+CN3zrXMqp7Uc0V0MGk7TTxFH07nVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8y6FjtpQi1jTgZkHxpMYsMhlYJh6eCkG0ZD5gpIWoio=;
 b=Q87HlC8ZKLGGjfDo5Z1tp4+7G6+G6alBdZi8RJSDQT7fwCl++W9PjSMEWs5owwrbEJXKxZYdUg18QQvPXVgLvDC+/rwPeFaRW5C0YXFJ+lmJkSYzB1T2dQRtL3S4ggUK/icguIRmGHzpj3G6ZpMf2YT0qTbfffH1CKHv3zrxpWg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13) by SA1PR11MB6712.namprd11.prod.outlook.com
 (2603:10b6:806:25c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 15:17:38 +0000
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de]) by LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de%4]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 15:17:36 +0000
Date: Wed, 25 Nov 2026 16:17:25 +0100
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
Subject: Re: [PATCH net-next 02/15] xdp: Keep the shared info of a buffer in
 kernel memory
Message-ID: <awb8BX2lbZ4sotpQ@boxer>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-2-bjorn@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124125654.183091-2-bjorn@kernel.org>
X-ClientProxiedBy: DB8P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::26) To LV2PR11MB868673.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV2PR11MB868673:EE_|SA1PR11MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: a87e60e8-9630-4ef9-3fce-08df4b073caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|56012099006|11063799006|5023799004|4143699003|261009223027099003|261028144727099003|261102123227099003|261021121427099003|261102130727099003|261021123027099003|261026121527099003|10067099003|261022105027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info: XnJDPRj8yoOa73S0iDHLRrmEJBKk68fKeVMULOnSUSJ3E368BOxreFlJFzBaFkIUHXX69M4+Zf7eJB3UA+EUJPdBgqJYtXowR0SMFisDus4Lxjw/fhdJDrJsyAvxOY7w4uRJnzAos4eUUDq3RGIdsOZiQBsk6XcOSJ4ZRhlXGI1a8UTsGCBnI1jVUmKdSrahuTRIv9VDo70qlZ4oczV+RxTd6ZH9g3coMydoEW1AXgpugKzPB/rXryfYe2mLUQjOAt+M5Y0xMkYjf6LTJC6vKehjHDSH+WE4zmelMP4WSwhb9sOE+BaEnfT7C7gw+yZRBHNODOsN5JXVWygUaKPtV3RpRvioFjeecJaiEGJvd7dQTS5VNbmMmpSz5DFEjUUeXuGdaRROHTWzpnaPwIcr0VzHsnNb5JrX8QRWuC98TR3QgiwcM0bGf2ogtyTFWjQiDD3KFClLKAAdEEvvyZs5obEC6grtqFtEedoRbG/mr8cmQY1dtgukO58Vr41PxGsqZrE8YE0FhH0UKSh9G3W/uZkkMYxEYYddeI+iKiiyN1g8z2zFeZ6Haho7fhjaliLnWTBxQfboVOsVKJw8qrIyHiah/i7l8ti1hHQGOf1F38FzUhcz39glNN/g/K3QBRht+mCZmaCFXGu4uFvrmq6iQqcSyvTtCNmGqVFCOAutObs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB868673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(4143699003)(261009223027099003)(261028144727099003)(261102123227099003)(261021121427099003)(261102130727099003)(261021123027099003)(261026121527099003)(10067099003)(261022105027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ejVl3DLpZflHkPwaS+3hH7bsi7eU+sFPBByjaUnJwo/5xKNIwrKFn67t/d?=
 =?iso-8859-1?Q?ZJ7hmX4lZ9cTrtu7NF8YmxHSfwvKRcch6BemPhCNfAkfnnKalzsEeWepV1?=
 =?iso-8859-1?Q?qNwufTBz3bokm9I8uuDn/lHZJiuyvpQaePJP48sd3DnvkeGz18p7Qirt3r?=
 =?iso-8859-1?Q?X4BnQRiCiFhizDdvIC7C6PyjBb3/Ta/xcwMUEL1cPD3FIihsasHf3CXM3z?=
 =?iso-8859-1?Q?9mlHUeA2dA37/YMuRxICxpNKqR8q0xvuwkJQHTsWfaLjEMzruP7ImznD4x?=
 =?iso-8859-1?Q?vEq4qGI1fRNZ4jDK+YJ3Omqq2s/hOhLp2pPe0IrsRjCVtRkKn7mrUrKBAH?=
 =?iso-8859-1?Q?b2n3blZ9XsOWJ+jBoNqkQ57zXm9CZJt/LrceNWV6KBAG8KdKbflvJhAdTu?=
 =?iso-8859-1?Q?2UgYWmVeuqdyGeTnTQWnFJinks6J6pqmPQqTh4yo7ePMYjlTr/dq97RWls?=
 =?iso-8859-1?Q?h+MjO6vP+oWNVAvs0boZmG4EvBir5bSY9lANRMmJFQ4agVQ5T3ihE6zrBq?=
 =?iso-8859-1?Q?b5DFLFNTRMmeuOeIhrYKpoKpkNOpWdsFmKGm3XRgBANadGBN1OV60YzcpU?=
 =?iso-8859-1?Q?4MyEvputtGp3UfnUSIUIgS8MXtfX6U72waqo+CZhOgJw/Vezs4aBDjUSnU?=
 =?iso-8859-1?Q?yrDH0SA+dd6Fz6rko7fXl1KZYXTs92nU5npL+LYw/8py6NxieVsXuCcCa7?=
 =?iso-8859-1?Q?NVQgVlNllAhLFdbpgu2RRqD2shFGqcWIePr/SellipYEMnicfjgCkMy9Tb?=
 =?iso-8859-1?Q?eucBnNHSjpnau24MJiKhN2S7+BKK02G/q8ayJpfQA5Q531TIzdLV6OJ5bp?=
 =?iso-8859-1?Q?CrLIf5o4HxCD0SQW5z4EODOREySSOZZ9235D66nw5RlSPlw/X2/0uTrkQq?=
 =?iso-8859-1?Q?ikrWvWpZBXLhnmTkI7IZhzerGnzxn4lfdpgXt3C62p+8be8nU7biVhDwY8?=
 =?iso-8859-1?Q?x0APaAEGWvCB0bzTFiYoXTImFNYCuuYLvDDIRW+OoBSxJQDFgZ26FeYHdZ?=
 =?iso-8859-1?Q?H4V96NpKyFih6X9f68g5uA79+i/yQcZYejlw9msefqcfiBQgu3xwK3AUcd?=
 =?iso-8859-1?Q?SDFsEyhwOB+Groy90pbp+eonSkBpp645XH8PMgjCwkOJy1XiDgWeNmmRj7?=
 =?iso-8859-1?Q?aMPsIY68cE1udjjxOrk/w6LcGH+BXDnqWg7M4gIdyLWwR/fgKizSPHBsBG?=
 =?iso-8859-1?Q?qypm2zoXCUTx3y6AWLcY90HDdssNlmxjzbNopWbC1yanJ6O/2/sQhwumxU?=
 =?iso-8859-1?Q?6B4MeJ2gIcUgezF4oMkSOHbtE6A48CO6sAJ7dWmFmGsGdkUtmdjTt0Dfsl?=
 =?iso-8859-1?Q?MlqS4to4qjrrQk/vTJAh1Y//oXmQFZHrpmY8F959k5wj9omckjlBVuSiQ0?=
 =?iso-8859-1?Q?tLNJ7x3cLRkKptwpXXDINkcV9aNjVZ+l3x4BNz//iICXC8Ul382ARCS3NT?=
 =?iso-8859-1?Q?/MgdUmHDDqDsfqdSyQ2l76SBvpaRv0ktmSRtR9JD95hfJitPrh//+nzfnc?=
 =?iso-8859-1?Q?vmThEVaQDeHbRIDcRvHeeKP5lLFnoWKYQNpRKbohJk6v2L9MOY0n60ambR?=
 =?iso-8859-1?Q?nUNPRVYoZO+2sWhbYvXSo+ngMxDeVePHd7stH/ernEI2PJdaO7CnZk4WDd?=
 =?iso-8859-1?Q?omKwH4C/FbAe2shebX8haU9Scalyql5pZ3B+Fc2hLlhPx0P+2GS0HXiHXf?=
 =?iso-8859-1?Q?sfY/WTrXC7QrMrQruUWCUMezQq52nQGItHdyywSmX6BTd8liFec2CRI32S?=
 =?iso-8859-1?Q?6mchr1apx8sZzGbmpm9JbD1np4Ai61FqOgHhDOMnzZQbsB8L7nL/6df6dJ?=
 =?iso-8859-1?Q?S9LFSI/9aH813uiqpc9SdJqrJMCr+RQ=3D?=
X-Exchange-RoutingPolicyChecked: ivH8oqXLUVMWrZwvVkS9nhK5Qtb/Wc31oHK71dh6vaSci69p207mvUJiyZ1tjxP9QjJH8XvuIwVm0XwiQRJleFd1nyxEEuJy8ZOk2S8Bywn0e/oD5uahaksCuQv22RAdPmyh5TJLWzDNuWprxnoKB6X65/QC0ib2vYITCp0McEs3YYELi1kMhdfOpPn5/3IgqsR2dvwfOtaEZ1l4q96TxbHDJtSy8GNLBumcccyc4nuf4ITOyYf6JHa1e2s7HXDLadmI+BWZjaEOwASgjpIgE/KoSOPFdu7Qmkd3rF7fW0ZGAdfcoz+2etmSAPQTQwX1NQjLPhJpRAlbeAqZ7gmkWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: a87e60e8-9630-4ef9-3fce-08df4b073caf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB868673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 15:17:36.5769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQRkOAXaVKjyuO8Fbo1PRfUH7oa4+slgPzCUOhAXzrHxANWBmSkYIttJpBvBi3HiOjK7/dFzuXvypBuKdXaRihfIMJsKlNT0i7eyzKASviU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6712
X-OriginatorOrg: intel.com

On Tue, Nov 24, 2026 at 01:56:37PM +0100, Björn Töpel wrote:
> Currently, the shared info of an XDP buffer, with the fragment list of
> a multi-buffer packet, lives at the end of the buffer's frame, in
> memory that the device writes. Helpers follow its fragments, drivers
> free them through it, and frame and skb conversion copy it, so memory
> that others may write while the kernel uses it must not hold it.
> Classic AF_XDP zero copy keeps it in the tail of a UMEM chunk, where
> userspace can rewrite it.
> 
> Let an RX queue keep the shared info of its buffers in kernel memory.
> The queue gets one from xdp_rxq_info_reg_ext_sinfo(), and
> xdp_rxq_info_unreg_mem_model() frees it. A buffer with the new
> XDP_FLAGS_SINFO_EXT finds its shared info there.
> 
> Whoever prepares a buffer sets the flag before adding fragments. The
> queue NAPI builds one buffer at a time, so one shared info per queue
> is enough. It is valid until the buffer is redirected, dropped or
> copied. Frame conversion and skb construction refuse buffers with the
> flag, as a frame or an skb would keep its shared info in the buffer.
> Nothing sets the flag until later in this series.
> 
> xdp_data_hard_end() reserves no shared-info tailroom for such a
> buffer, so its data may reach the end of the frame. frame_sz then
> bounds every write past the data, such as tail growth and
> bpf_xdp_pull_data(), so the frame must not cover memory of other
> buffers. Drivers may then pack such buffers tighter.
> 
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
> ---
>  include/net/xdp.h | 41 +++++++++++++++++++++++++++++++++++------
>  net/core/xdp.c    | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+), 6 deletions(-)

couldn't this effort be sent separately and address classic zc as well?

> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 1629e347b71f..944418111a86 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -65,6 +65,11 @@ struct xdp_rxq_info {
>  	u32 reg_state;
>  	struct xdp_mem_info mem;
>  	u32 frag_size;
> +	/* Shared info of buffers with %XDP_FLAGS_SINFO_EXT, in kernel
> +	 * memory, see xdp_rxq_info_reg_ext_sinfo(). The queue builds one
> +	 * such buffer at a time.
> +	 */
> +	struct skb_shared_info *ext_sinfo;
>  } ____cacheline_aligned; /* perf critical, avoid false-sharing */
>  
>  struct xdp_txq_info {
> @@ -81,6 +86,15 @@ enum xdp_buff_flags {
>  	 * XDP program is not attached.
>  	 */
>  	XDP_FLAGS_FRAGS_UNREADABLE	= BIT(2),
> +	/* The shared info lives in &xdp_rxq_info.ext_sinfo, in kernel memory,
> +	 * not at the end of the frame. For memory that someone outside the
> +	 * kernel may write. Whoever prepares the buffer sets it before adding
> +	 * fragments, on a queue that has ext_sinfo. The queue NAPI builds one
> +	 * such buffer at a time: its shared info is valid until the buffer
> +	 * is redirected, dropped or copied. The data may reach the end of the
> +	 * frame, see xdp_data_hard_end(): the frame must hold nothing else.
> +	 */
> +	XDP_FLAGS_SINFO_EXT		= BIT(3),
>  };
>  
>  struct xdp_buff {
> @@ -212,17 +226,27 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>  
>  /* Reserve memory area at end-of data area.
>   *
> - * This macro reserves tailroom in the XDP buffer by limiting the
> - * XDP/BPF data access to data_hard_end.  Notice same area (and size)
> - * is used for XDP_PASS, when constructing the SKB via build_skb().
> + * This reserves tailroom in the XDP buffer by limiting the XDP/BPF data
> + * access to data_hard_end.  Notice same area (and size) is used for
> + * XDP_PASS, when constructing the SKB via build_skb(). Buffers with
> + * %XDP_FLAGS_SINFO_EXT keep the shared info elsewhere and reserve none.
>   */
> -#define xdp_data_hard_end(xdp)				\
> -	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> -	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> +static __always_inline void *xdp_data_hard_end(const struct xdp_buff *xdp)
> +{
> +	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +	if (xdp->flags & XDP_FLAGS_SINFO_EXT)
> +		tailroom = 0;
> +	return xdp->data_hard_start + xdp->frame_sz - tailroom;
> +}
>  
>  static inline struct skb_shared_info *
>  xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
>  {
> +	/* Kernel structures stay out of memory that userspace may write */
> +	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
> +		return xdp->rxq->ext_sinfo;
> +
>  	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
>  }
>  
> @@ -454,6 +478,10 @@ int xdp_update_frame_from_buff(const struct xdp_buff *xdp,
>  		return -ENOSPC;
>  	}
>  
> +	/* A frame keeps its shared info in the buffer */
> +	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
> +		return -EFAULT;
> +
>  	xdp_frame->data = xdp->data;
>  	xdp_frame->len  = xdp->data_end - xdp->data;
>  	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
> @@ -533,6 +561,7 @@ bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
>  int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  			       enum xdp_mem_type type, void *allocator);
>  void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
> +int xdp_rxq_info_reg_ext_sinfo(struct xdp_rxq_info *xdp_rxq);
>  int xdp_reg_mem_model(struct xdp_mem_info *mem,
>  		      enum xdp_mem_type type, void *allocator);
>  void xdp_unreg_mem_model(struct xdp_mem_info *mem);
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 1d679e8fd649..3472b03ee661 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -142,6 +142,8 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
>  	}
>  
>  	xdp_unreg_mem_model(&xdp_rxq->mem);
> +	kfree(xdp_rxq->ext_sinfo);
> +	xdp_rxq->ext_sinfo = NULL;
>  }
>  EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
>  
> @@ -368,6 +370,30 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  
>  EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>  
> +/**
> + * xdp_rxq_info_reg_ext_sinfo - keep the shared info of buffers in the queue
> + * @xdp_rxq: registered RX queue
> + *
> + * For buffers in memory that someone outside the kernel may write: those
> + * with %XDP_FLAGS_SINFO_EXT keep their shared info in kernel memory of
> + * @xdp_rxq instead of at the end of their frame.
> + * xdp_rxq_info_unreg_mem_model() frees it.
> + *
> + * Return: 0 on success, or a negative errno.
> + */
> +int xdp_rxq_info_reg_ext_sinfo(struct xdp_rxq_info *xdp_rxq)
> +{
> +	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
> +		WARN(1, "Missing register, driver bug");
> +		return -EFAULT;
> +	}
> +
> +	if (!xdp_rxq->ext_sinfo)
> +		xdp_rxq->ext_sinfo = kzalloc_obj(*xdp_rxq->ext_sinfo);
> +	return xdp_rxq->ext_sinfo ? 0 : -ENOMEM;
> +}
> +EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_ext_sinfo);
> +
>  /**
>   * xdp_reg_page_pool - register &page_pool as a memory provider for XDP
>   * @pool: &page_pool to register
> @@ -638,6 +664,10 @@ struct sk_buff *xdp_build_skb_from_buff(const struct xdp_buff *xdp)
>  	u32 nr_frags = 0;
>  	int metalen;
>  
> +	/* An skb keeps its shared info in the buffer */
> +	if (unlikely(xdp->flags & XDP_FLAGS_SINFO_EXT))
> +		return NULL;
> +
>  	if (unlikely(xdp_buff_has_frags(xdp))) {
>  		sinfo = xdp_get_shared_info_from_buff(xdp);
>  		nr_frags = sinfo->nr_frags;
> -- 
> 2.56.1
> 
