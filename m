Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793809366;
	b=tIGo9C7Mkr1CStylY01rwUhwzeMcDHGFC1BUJOXPWwa+vaZxUDPvSE0lLxX8PK0eIdAZ
	 6kJ2qTMG3tOCi/oY0GQDQm+ZvyMHLbRFT1QZ6LKqNPQzCTUvdlBGXAzP4sfoTYPE8esPD
	 3HRgXO2fhN+ZJsfJEnFG2RVCRL59W9hAhp/+qzAYLSdZU5N+/oO6XT2ZOEx00arTP4ZIH
	 DzfQqaV4qTn9/MGq5urlDmUp9IAmQrWhdeDcYr0NoywobVbbAY1BPtDgMBS+K3eY+xDqT
	 vmP1z9t61AdhlGt3T6x7bNP6//1wjkDIJwOLymfumVL0jT/GgkHP/YHlgG6zt5x2VTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809366;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
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
	bh=XXaup1ssF33yeRAHrLgyvKg0lC1Nyf4lKVuOzxOlW9U=;
	b=xsu3oXiC9qH9/098F81z3yNmmmZTw1NpmIc2yHTY2nzY7CzdPL+O+sy2nbOfuqKoqfOF
	 fjh1zNFnFyLA0tG8vce0XTYMe7vnyvsAjf/EwWLWRmT9LtkYbOqmKunAbgE6KO+ld1mPr
	 OavSbjXI33Fb/KPc45KhV0ew2HO/0Un6u7YnkM0NN4tsi1sleLTEVjQ4D5iciQNjn1XHw
	 s134IPwSVKfLXU6jjZqA/7UFswkDTyI2LpNyiDK4Lqo7dUwBoxVvjDZBd5MmcqL7B+zAv
	 +0ZAYLGVmUk4NyR9hjYBDIVsHApNM9FyMnHZAtp5JEEzyQERcqAtCozJW5Rp3GLJu0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PSBsMsq6;
	arc=fail smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F9606A336;
	Wed,  4 Nov 2026 16:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 582F9606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PSBsMsq6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793809366; x=1825345366;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XvfokJ45PHvhDtxkoWaSwERhlWDtoQJ1SQ5nRIbiJDE=;
  b=PSBsMsq6r1YgPP4Ucn3P+iywL2wughYVpwxOfWWnbQy9mp5EYBj2gAsT
   pXyh94sD9XxO7qobkaFFoZy9gxDRvC+dUBFd9icjJfwwrxED6NOGFJvJj
   v0qROe64WPY8/DemczPmc5zFS3bUsJx13ATZTy78i204ySxyDu8stmkAi
   1qvAgUz4f9NPLxXYoDhq46gJiAai2ByqJFq3RTa9asRTnr0NPlrjyHFxr
   63y+qNFa7N0/HRnAcxfQftLqqmgDAFNTb3HHBUmxnvh/aUj/OWO5hNgF8
   Vl2tCJnkEZYAg8mSsbJEtx3eHArUWEoefUigHgH4x41E+R95UAr+8Vym+
   Q==;
X-CSE-ConnectionGUID: cf8462+LTzej6Mu2y3UcbQ==
X-CSE-MsgGUID: oysMHu5QRjicjrjLl65S3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2573547"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2573547"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 08:22:45 -0800
X-CSE-ConnectionGUID: LRvBC6NXS7WVJ7AmC1olUg==
X-CSE-MsgGUID: 0HrkXYUTS/iyrPVZB1XIdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="7080338"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 08:22:44 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 08:22:43 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 4 Nov 2026 08:22:43 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.17) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 08:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ex1Be1ZBgF8N6pBQSjGOUJNgrO9nYV47JIdcSdQWL70pANrxGm22RcGEUQLx71M5S4F4rdl/GdAu8UQCaF7E4MUiWxTCAj5LuTUcEI+8bcYIHpIJhdKpufulPBXMuCSE/gniKPGQm5eL0fw3m0KBYDsc3EOG9tGOu22GsodufmJjmSm57A6px3gX5g0JQt4kyyDOgrHN2L/29eQnGHMFb/8uEa000moM0ShkaRPqMEIUSBvpGUsHSUpwTfDGM9X1hnKji/ZZxIJmNv8RRZTkgjAt/9XafL7QrCGJA7e2TZcgwCPrplHiviA/AjJlLbJfHX3Vj7QDK9MzQ9xZ7e2X7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXaup1ssF33yeRAHrLgyvKg0lC1Nyf4lKVuOzxOlW9U=;
 b=vDnsAF056Lfcnd/rQ6FA7PluRNE/G0UAmSaKzAhBmXcyq27kVm1SDf9LNNTginBBi7QrdzJmi+B75O3F3vnSnvHbwoKMplWw0i5Aecxa3WOBp/H93yt1ZPLkrH/h1+75igLAcSDq8ZIb3tX4jT4hibl3yS7Ae16N6MIqtpyJWoBgbhfG5AZNrcDpuKyzCy+JdqaOjNvh/2cPATgtsqHMxoxgu5cTPOrjVP3DWCy44JKy2GvQabU+b0bX3Xb02tMtPKmaBbbFFgoHpS/oCtpBR4M8z8ieyqyDUBDUGffL65Qp/66g5IRo0SoXWazRxo0tjKdLq/73iPMr5aGdBBTjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 (2603:10b6:408:422::13) by CY8PR11MB7800.namprd11.prod.outlook.com
 (2603:10b6:930:72::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 16:22:41 +0000
Received: from LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de]) by LV2PR11MB868673.namprd11.prod.outlook.com
 ([fe80::5bfd:6afe:a9db:b7de%4]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 16:22:40 +0000
Date: Wed, 4 Nov 2026 17:22:24 +0100
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Orgad Shaneh <orgads@gmail.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Wei Hu <weh@microsoft.com>, "Konstantin
 Taranov" <kotaranov@microsoft.com>, Simon Horman <horms@kernel.org>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
	"Jesper Dangaard Brouer" <hawk@kernel.org>, John Fastabend
	<john.fastabend@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>, Long Li
	<longli@microsoft.com>, Dipayaan Roy <dipayanroy@linux.microsoft.com>, Hamza
 Mahfooz <hamzamahfooz@linux.microsoft.com>, Aditya Garg
	<gargaditya@linux.microsoft.com>, Erni Sri Satya Vennela
	<ernis@linux.microsoft.com>, Muhammad Falak R Wani <falakreyaz@gmail.com>,
	Jesse Brandeburg <jbrandeb@kernel.org>
Subject: Re: [PATCH net] net: mana: fix XDP_REDIRECT of pre-allocated RX
 buffers
Message-ID: <autbwKmZPPWEj0Dq@boxer>
References: <20261102064324.806414-1-orgads@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261102064324.806414-1-orgads@gmail.com>
X-ClientProxiedBy: TLZP290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::20) To LV2PR11MB868673.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV2PR11MB868673:EE_|CY8PR11MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b6fb23-e039-4e37-80f4-08df3a8fd8be
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|10067099003|6133799003|18002099003|22082099003|5023799004|261102123227099003|11063799006|261021121427099003|56012099006|261026121527099003|261022105027099003|261022075727099003|261026140227099003|261028144727099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info: SOfkT9MklsximZxYqHOwwSSj9Pgv21t+DH76DsE6rQ3y7LbFO++JQfsj3u6lKy/zAVPLnmyYG3SIiGRptm5JStcgBHkHW2NcxDpCmsxTwOG9V/MXCy6LGDvJEb1QuB8wJkKwzC7NTKq7FBsGETaTtQghIQYE07CKbQYqHGQ8/OXZGE8pkoAfRKZbMOj/T3DVB0g0o8SmD7TJuIvbPtHDfnNBtjHGmrYk2L1tsP8SDtY5d68qYFL6gkhJH0IYb5x4WYZ0j5dWOkPP0SVgpN8N3EgNityEGMJVhN6AfSoFzLjKnXPkcqgo7qaIlgJBRTmvegwp67j5W2F/4+GKGD0wwpHAk0KaKq+KWbMV90tO/p6emo70SsuJ+fSqJA1Arz0E26DL7MSEkkEMeYa+yyefOBb95Ht2qyawT3zkmhLMP0S7muCCf5M30f2zxcbKGH1lKGnDImMjyUVzhs9sen0nzO1cPUC4hlvJW1c3CblqmFCufaVd9PRQSqBgbGr04P0h7r/WGU8CCALPSFZ7EsL7CMv4kPhYlxl68Nq44W+AnJLmwIQSHTQsJMuEdKt+0su0d5+j9VKsLv6fFe4MZVhflm+2MPE2AtZbUARyMBDVfilRkaiCALTJ/xdeqe4m2isjVRy1Zhx419QlJ31CSUp31KUzrX5wUdtAfIkldU8/arw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB868673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(10067099003)(6133799003)(18002099003)(22082099003)(5023799004)(261102123227099003)(11063799006)(261021121427099003)(56012099006)(261026121527099003)(261022105027099003)(261022075727099003)(261026140227099003)(261028144727099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iNdFLdSOJdqfzVXhUnYc4GFBr0JmCht1x53ODPoOx6K37gaySIOfodjojgu8?=
 =?us-ascii?Q?zcCEf8HOGeqUnfzrqjvcwjjTlZ193FAyTlPEI6R7m2hfTopVlg4vmSWzHpxd?=
 =?us-ascii?Q?6H2lgXiFJnz8KaJHDhkqsBdc8LhQgEZTBe23aVCn24AL4pBPhjP3C/9iYSVC?=
 =?us-ascii?Q?tMp+eYlrrjFLfyYkgPE504MWgN/Hgieivz4NIgP4AQZgGZol58ChVl9sZxIz?=
 =?us-ascii?Q?N5+0s9igm0vQoKJTiGGWHVRonRWZcmMlvgsd6/6sE6sdHX70yATH5EPSWkOo?=
 =?us-ascii?Q?5mLJ13YXmiiFdYqqC4/mbuN4jX+q8FFSH3xrMjtOw6GACTCzTBKx6QnQHhVX?=
 =?us-ascii?Q?0g45CEcYsFPLlJkt+/sXBz17wkjWb2G5BqWC4UsVcYjfZ4T+Gyq8zhRN1c7x?=
 =?us-ascii?Q?0cq2HN0TrJP7QzU1sr2uPx0zpnQzzqFsmjg4KUA9rGR/hAw6olcb8ydTDGE8?=
 =?us-ascii?Q?OAk7+obVwd1rD8fkokFAYlNmhybpCmuGhwBztDG1JNU25swfcew1Cwfp3OOM?=
 =?us-ascii?Q?MTU2rUCDZXowhbmLMWXWndwsJSgA+3DGS6L5Pnl7ZLiK+XLsFr5Gt49F3LUi?=
 =?us-ascii?Q?mWSrhx88SFXNaId+ikwB9Ie5jUC6qBpUgc0Kde7xgLY42bVYmTKIxW2jNrVp?=
 =?us-ascii?Q?rfnBj95CStwqepED21F6o6li+UuWOmpwghOKSV0IBphUZhFNe/KxhmVqikQp?=
 =?us-ascii?Q?YIvU9XlaRqc5m8bMm2VbNN6AMKRLX0IGbU2efrrXHpq/yIkH9KGTGbPDtVp6?=
 =?us-ascii?Q?oBBYSohejMAfiD+drI2sfJSrJp4tlRF0Yqw1tX2Q4CCiZLZlL3dAj9bdANWU?=
 =?us-ascii?Q?iBUL5WBnx0Sf7sIWKth5QfVaVPzqxiHWgZLjL+PPgBckKaB5Sd/Qo+kUpKn3?=
 =?us-ascii?Q?8I2OcRt5VO0+agkDtx0jiRRUUQ87Yh1iYM0Ba917gadY6eAV3XpCAOhYq8PY?=
 =?us-ascii?Q?XhKKP/1D02jq2uZCM2vOa3VsxUzNuUTlUeAnk1YXgTYhwCoIw1D+arqs54/p?=
 =?us-ascii?Q?YTsNIVTR0VSa3+BROrMq+sIiKnQla3hLIENCZ8sZqXJtuSHm1lcrg8mSu1s8?=
 =?us-ascii?Q?NSlpQMrHT+Cm283ZzZamAzJE5EnZG3IniP7zJ6XuBKjkXKb4sKoTpq+kj39g?=
 =?us-ascii?Q?41hwUzpaYBx/aTGx0z9stHiTKr330SQPrdVuBLgsTlixQHopDXLW8HgdyL4R?=
 =?us-ascii?Q?Y0MrDga8lShXkNQhco7xjj/M5T7aweDbhtOVDmL+7GekqF59EIZSM7JFB3Z3?=
 =?us-ascii?Q?n+h7xBYZVPOSA14hVCer7HHREsEdvN2qZRiP07CVRA8PBrDc1Y2zDi+ZLhWH?=
 =?us-ascii?Q?UCxDVa2VyHn9US0T6x703gt1cG2SjFWjvN8QYB7GgkLqnuOLKEv9klFxO4mj?=
 =?us-ascii?Q?KheBX0HnezaJ97dodUjrcm5QcjLFeqIwPub5u0xt8EO+Y2cIxzgBib3NOIF+?=
 =?us-ascii?Q?EvfNDrTrKKKIkMnlYgcAhT4JseiY0Gqqj3psIbQJ7+ONyc3M+2iDN/FqD3mb?=
 =?us-ascii?Q?pINOqW64/gFN3fpSacFJYMHPB7DFqzdw3CD56M+2vQ1NJGk5kn1t+dOgfYN1?=
 =?us-ascii?Q?W75N6wUyemmh00IRIpyHTi/YJzu+SGeuTKmYX1ct9oOCsfgX1+50nyYgvQ2V?=
 =?us-ascii?Q?aM7zw2dLf1m+O0RoK/4AJryoBuYM2hzSa+YrC9YBOEWDN/l8BkdlLsmwOfFX?=
 =?us-ascii?Q?ti2YuWlZeSGSMPw3Qt+7kY2me3UOa8PZrz0tIC4WFdo505aSRte9bSNanA9s?=
 =?us-ascii?Q?OKffXEXux5aK0dpg/kDIoqcMwBopxBI=3D?=
X-Exchange-RoutingPolicyChecked: JrKKUbc0SQGzVEwoRws2bt0KB/5rzQMBc+OMzmvcdk2DqVncLZOeWOQxBqxE6ttC9uY0Beg6rAjFUwVqG3EPqBzR9UdcIZFqU0CiXeSJ/YQyYPfaOeLNUU1cLG9bRQzDPCMRpFRo//phU2Z689k83nM+th3/v6B62mbj0UnDkL9lJhBLlwEGONEBXdUvtVuMG5spX0o5az42MtCJODXgsTNoAu48rq1kVUeUlDL5MLhtiHIQmWbE136PiSMaYDhoV1c1otjSA1ro1gTFL5KjskbY219jA40zDkkwg+BmIGGIJnO92rx0b/znvkCNoooXIqpEgVPUqBJILXNoDPqBNg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b6fb23-e039-4e37-80f4-08df3a8fd8be
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB868673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 16:22:40.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHiVV5UoVjPMNOxXtgLLtmWQORQt/jgAPICMAY5c9jJsnia0XQfxr+zJRpYEVO9VC4TAVIAsDOxdEQD910ek17dnKfw7WWF/74CSNPVfpy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7800
X-OriginatorOrg: intel.com

On Mon, Nov 02, 2026 at 06:43:24AM +0000, Orgad Shaneh wrote:
> mana_pre_alloc_rxbufs() fills the RX rings with plain pages from
> dev_alloc_pages() (from_pool == false), but the rxq is registered with
> MEM_TYPE_PAGE_POOL and mana_run_xdp() builds every xdp_buff with that
> rxq info. mana_rx_skb() frees a !from_pool buffer correctly on
> XDP_PASS, XDP_TX and XDP_DROP, but a redirected buffer is freed through
> its memory model: __xdp_return() hands the plain page to
> page_pool_put_full_netmem(). This triggers the WARN in
> include/net/page_pool/helpers.h, breaks the page refcount, RX refills
> fail and the queue stops receiving.
> 
> The pre-allocated buffers fill the whole ring of every rxq created by
> an MTU change, by ethtool -L / -G and, since
> commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
> instead of full pages to improve memory efficiency."), by every XDP
> attach and detach. So on current kernels the first ring of redirected
> packets after attaching an XDP program always hits this.
> 
> Reproduced on 7.2.11, and on 6.12.113 after ethtool -L, on an Azure
> MANA VF: an XDP program that redirects UDP to an XSKMAP with an AF_XDP
> socket in copy mode gives WARNINGs at __xdp_return+0x249 (stack
> __xsk_map_redirect, xdp_do_redirect, mana_run_xdp, mana_poll), then
> the queue stops.
> 
> Give each rxq a second xdp_rxq_info registered with
> MEM_TYPE_PAGE_SHARED, the model these buffers had before the page pool
> was added, and use it for buffers that are not from the pool. Those
> buffers are already DMA-unmapped by mana_refill_rx_oob() before XDP
> runs, and page_frag_free() frees them whatever their order. Allocating
> the pre-allocated buffers from the page pool instead would need the
> pools to exist before the rxqs and to outlive them, a much larger
> change.
> 
> Found, fixed and tested with an AI coding assistant (Claude Code).
> 
> Fixes: b1d13f7a3b53 ("net: mana: Add page pool for RX buffers")
> Signed-off-by: Orgad Shaneh <orgads@gmail.com>
> ---
> Tested on an Azure D2s_v6 MANA VF, net at cb284914e749 with and
> without this patch (same config), XDP program redirecting UDP to an
> AF_XDP socket in copy mode on queue 0, 25k pps offered right after
> attach:
> - without: 41 WARNINGs at __xdp_return+0x252, 0 packets relayed,
>   hc_rx_discards_no_wqe 301470.
> - with: no WARNING, 25k of 25k pps relayed, 0 loss; also over three
>   more attach/detach cycles, two ethtool -L combined 1/2 cycles and an
>   MTU 4000/1500 change before attach. MemAvailable unchanged.
> W=1 build of the mana directories: no new warnings.
> 
>  drivers/net/ethernet/microsoft/mana/mana_bpf.c |  9 +++++++--
>  drivers/net/ethernet/microsoft/mana/mana_en.c  | 11 ++++++++++-
>  include/net/mana/mana.h                        |  5 ++++-
>  3 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> index 7c55f8724441..494267b3069a 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -78,7 +78,8 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
>  }
>  
>  u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
> -		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
> +		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
> +		 uint pkt_len)
>  {
>  	struct mana_stats_rx *rx_stats;
>  	struct bpf_prog *prog;
> @@ -90,7 +91,11 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
>  	if (!prog)
>  		goto out;
>  
> -	xdp_init_buff(xdp, PAGE_SIZE, &rxq->xdp_rxq);
> +	/* A redirected buffer is freed by its memory model, so a buffer not
> +	 * from the page pool must not claim MEM_TYPE_PAGE_POOL.
> +	 */
> +	xdp_init_buff(xdp, PAGE_SIZE,
> +		      from_pool ? &rxq->xdp_rxq : &rxq->xdp_rxq_shared);
>  	xdp_prepare_buff(xdp, buf_va, rxq->headroom, pkt_len, true);
>  
>  	act = bpf_prog_run_xdp(prog, xdp);
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 6b7c027e497e..7547aeb3235d 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -2157,7 +2157,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
>  		return;
>  	}
>  
> -	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
> +	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, from_pool, pkt_len);

I wonder if it wouldn't be better to work with rxoob objects which seem to
carry the from_pool setting?

>  
>  	if (act == XDP_REDIRECT && !rxq->xdp_rc)
>  		return;
> @@ -2947,6 +2947,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
>  	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
>  		xdp_rxq_info_unreg(&rxq->xdp_rxq);
>  
> +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq_shared))
> +		xdp_rxq_info_unreg(&rxq->xdp_rxq_shared);
> +
>  	if (rxq->rxobj != INVALID_MANA_HANDLE)
>  		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
>  
> @@ -3225,6 +3228,12 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
>  	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
>  					   rxq->page_pool));
>  
> +	/* The pre-allocated buffers (mana_pre_alloc_rxbufs) are plain pages */
> +	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq_shared, ndev, rxq_idx,
> +				 cq->napi.napi_id));
> +	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_shared,
> +					   MEM_TYPE_PAGE_SHARED, NULL));
> +
>  	/* Initialize the DIM work before enabling NAPI, so that a poll
>  	 * cannot reach net_dim() with an uninitialized cq->dim.work.
>  	 */
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 71d726b1f784..11ceb5946ee0 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -420,6 +420,8 @@ struct mana_rxq {
>  
>  	struct bpf_prog __rcu *bpf_prog;
>  	struct xdp_rxq_info xdp_rxq;
> +	/* For buffers not from the page pool (from_pool == false) */
> +	struct xdp_rxq_info xdp_rxq_shared;
>  	void *xdp_save_va; /* for reusing */
>  	bool xdp_flush;
>  	int xdp_rc; /* XDP redirect return code */
> @@ -695,7 +697,8 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
>  int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
>  		  u32 flags);
>  u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
> -		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
> +		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
> +		 uint pkt_len);
>  struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
>  void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
>  int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
> 
> base-commit: cb284914e749388eef402938bdb3115fe1f6d337
> -- 
> 2.52.0
> 
> 
