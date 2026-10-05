Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AC488755;
	Mon,  5 Oct 2026 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206639; cv=fail; b=tskscsNVE9LlVtTUh0nGVKAAw1AktyghqgGFFbVhO8A9YOgcW0LKkUPGcaBQGUxJYyfPB3qUtoB8rMLOmLEQT7QPDoeioXwH2EjiLS9iwKEZ2QdDEZkM/BvGj4P4u3zA+szxAp6bGHiHQQ47THAneatH9RPV8BQkNPtgmJ/3K00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206639; c=relaxed/simple;
	bh=Z9kri2qTLMtImyBes5yUQGoiCqo+sgX40hirM0GZDCc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K1llyAU4+fNkuxGmloWVdkoD3U+5jReD8rVGI3R7EtvVA+ex6IXfk0t0MKlFPwVX2fk9z6rP4YWkfJewWwORxsDr9RQkkH56KgkXykAC/XX8xVsZZ9VGqZof1/wwNyhCPN4hqrxh/Q7z++8uKD0gkK4bKeb5jxBwwtjewoF52nw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LaT8MQU8; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LaT8MQU8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791206620; x=1822742620;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z9kri2qTLMtImyBes5yUQGoiCqo+sgX40hirM0GZDCc=;
  b=LaT8MQU8cd+Vhtr98NcQGZoWxD597vqqASyf4SZku7pdjB8fEkRKR1oZ
   GssdmEP98sKpZQW9n3ZFlsiTxXidp3IiZKYVfBjRXRhqz+LpGyCy1YIMu
   MIpTY/+pLuS8ZRoKivcCO8/Be8SrfoZt5p8Owg1/Ct7xllhSrMf0acg3q
   48+XQIOrh05FfyTn8qKzfYkVYi+ga2kGsOqrLR3hduAvcMEdp48hc6Nuf
   cDCUmrkNe7VX7pfKN2FbAkj9dl9fvAaxypvdPES+5EhLqm5tXWjO3sKO4
   GJo+WfdU701shtRD7bFRkchRzL/M4o6i/JnRlWibKcv7+fk0eQu0+8Dm0
   w==;
X-CSE-ConnectionGUID: V0WbMI6rTv6Wd9jLrodsaQ==
X-CSE-MsgGUID: qL4iBM6JSy2c6xwUrXCLXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="90825715"
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="90825715"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 06:23:30 -0700
X-CSE-ConnectionGUID: q+y/flt7SqqY0rKHe+8dVg==
X-CSE-MsgGUID: gR57xmnaSbCgfhWioOkcGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,142,1787036400"; 
   d="scan'208";a="314828882"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 06:23:30 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 06:23:28 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 5 Oct 2026 06:23:28 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.26) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 5 Oct 2026 06:23:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMjZNrXM9xxCyezk/S6TFnsOHF9aITxB8CMqvBJN19Ejn5Is1uKjDEyOqnQCIL4t/1GEc0QkyWqwdObXj3T1bc/GoBtMwipkf5oGG+6hUu1MuekWSVsGqQTl08KexndiPWVjD5o7lhxSJP4bCYZMeUt70d10BBGNczYDfO1BoLZmBxnMX/SvQSKf6gwXvQugndxb7ZbzNGeMpfjaJlaCBvjGImfBVZ+YIMqQMXSn2Wa867SDGlj5RLwKBHY4u2FYmfeonzS3NdGovcxHZAW4LDQkyZispEAG7Q0fMlG/1LBpVxMRIlOjUbBdtjX0BJIxG2kBRFWxZxCeSa9/Rp4sYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1bWkLOQIgx0nXBi8QqOJfP1/fmpPXUxYlI5NjcwVC0U=;
 b=KFLZay7IgsPtUP/C/fUVyoFO+YYK6EEmCIanGUBLbeVfnts/V2CuqKaF+/1PUgo8WZyG5Vh95pocoJlpfQlBDs/ZwwBzrPvnnJThHGZeZPuwdVg/31vcfqW0/xQceN2eptO1TDBkk8PeuL+Jtc1EkWEKbPzuZia2O/uuZhdgJViqCdP5Cj97/Y7vpGOuoOpm80IJ8VKl0KZSClRjUC9s+NawqHysTtaS8weDcOS0/cf1d96jMHZ5vtaF4ELtaF8Oubi34BFjx8/nLB9XYgzC4lOxJRoXN7b5HXOxgYCrpGI0PhPjEszDtYui529vFdi5118k3RNYEjFWaKBBUC7sYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8)
 by CH3PR11MB8415.namprd11.prod.outlook.com (2603:10b6:610:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Mon, 5 Oct
 2026 13:23:23 +0000
Received: from LV3PR11MB8508.namprd11.prod.outlook.com
 ([fe80::a1e8:1786:e5d1:8e51]) by LV3PR11MB8508.namprd11.prod.outlook.com
 ([fe80::a1e8:1786:e5d1:8e51%5]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 13:23:21 +0000
Message-ID: <ae31c9f2-eb4e-4d9e-8ea5-27364e389be5@intel.com>
Date: Mon, 5 Oct 2026 15:29:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mlx5-next 0/2] mlx5-next updates 2026-10-05
To: Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	<netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Content-Language: en-US
In-Reply-To: <20261005084047.237081-1-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: WA0P291CA0017.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1::16) To LV3PR11MB8508.namprd11.prod.outlook.com
 (2603:10b6:408:1b4::8)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8508:EE_|CH3PR11MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: 63129612-7543-4862-7f97-08df22e3d366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|7416014|18002099003|10067099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: 9VA1ffIsK0okmDvXI3htM0N7yZwuZfwaSmXQJHu/92qnqvRdEVVeW5CoSJ5461IPhSP5yMX4oOkKPJI9tSyuq+v3toI8anynx6jyuUA30vysvz1nwYKzJkq/QBZ/2Tl7hLSfpjNJlBFp79d2zANgi5rP/ps5jhnF3beBN2bcbfB9iWEgwMGTb5e/1viFOpZA8kX3LYj01U7rZ2Rm3QYM+DJJICKXg3AhMjnXnTj2/PzDURk4WdHSr5iWTHwhCC0tCahxnjNHCCNBFeNFn/y4usT0eHoYillpcsjGfCV6bhZFMZ2xUG5vXQtk0gGCYtjUhEPnf8S0WpdAi5srT8Za80mxlZxuPN3vK7hqEiDzYC9SV5pdGKmyWqDveFtAmOt4ZDu+YyHWA8DRS0pKoWTzpVcylbxRrcJR0CmgptfEn3OOY7Pk+w2aoqmM1NvJ1N9pT4Sv40ZxY6et3A4VVnnteeLC1gWn5rOj3hU2wdLL549JFCB8fiZzjF/VbXxfwxaCJ+b+xqJcrZ0CHV15ukKDlEi5INpqfUo5PBl3XTqB6aweaRXvWuazPnL6jfF9qYgM2mfmAgIiVS6CHhraJVOyAFW053fye24vD408/kC2mnnshak1U9H+kbXCfql2h7+InfgS1uDtC4GhDhBfwDxk+vc6b+EB6gj4VLp3nnJeeQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(7416014)(18002099003)(10067099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VW1DaUJRMHFkelUvTzBkK2xlbzRxaWJ5UEl0M0IvSGRFemZCYWhEdm5DNlB3?=
 =?utf-8?B?SHRkNXdMSjZBbHY3VnFMM1F5Y0piTkQ5bHdCOGtMNG5vSkFhNWdBSGlsQjNy?=
 =?utf-8?B?SFBpdGduMEtrMzF5bVR0N2l0OURWbzFLalVwQWhCNkdBcC9UcmNsZ1VVMmFT?=
 =?utf-8?B?eXY4b1oyejJMNlBxZkFtbDYwTUU3c3M0S2g0clVkK014R3p0WGQ3VCt5c0Jo?=
 =?utf-8?B?bXZkakpSd1NxbWMyT0JBT2phSTlGQlhxaFBDb0ZENHR4cm50OXRCMURHK3g1?=
 =?utf-8?B?cnA2MUpQbmtjazE4MG9Pa0tBN0NyQVU3R1ZVamFVRjM4S2J0WVpoSTVadEcy?=
 =?utf-8?B?M1VOc1ZJejN0WTl4WGZGMDZTeHNHOGl6bGgzaUhUVVVzVXRRT1JGMHR6Z0Vu?=
 =?utf-8?B?Q0FGcjNiY0VPOTNkV2JCbzRKd3ErOVQ5MzQ4OEwzdldMV0JKZGMxTlJFQXB4?=
 =?utf-8?B?T2NDQXdLYXU3VTVPVnY2ZHB1ZmhtdDBRUTViSkpVd0Q0Z0JHQ0VJUlBxVXBM?=
 =?utf-8?B?K0xCTEJZSXhDZVZFSjhkbjZmYm5yczM2NFVQdXVSWW5lNVFaYkVoQS9VeGNH?=
 =?utf-8?B?bklaVUw1cjRNdk1sRWhQT2M2WDlBaHhwaHc1d2VocWU4RVJ4RGtZN1ZwMG8x?=
 =?utf-8?B?RkJua0lLRmc2UXR0WU5tNXQwekdmdktIamVGTjJEakU2Z3c1UHM4QUJqKzBk?=
 =?utf-8?B?dFN4T1VsMzc0R0NaUkZYK2xaMDNyOVR5dm5xTU9BTjhPdjdhZlBrQUdBWjNH?=
 =?utf-8?B?bTdYcmdqWU9IeHVORWJmTVlnM0RmQkFObnFvZlNzVi9lMi9lK0p6ZitWZkVS?=
 =?utf-8?B?MnZ6NVRIOU9tdHRwblRiaG9EQlJxU0RXSE1jVmtOOElLcW8vSzhyUm1PaHo3?=
 =?utf-8?B?Q3N6VnVjbDRFRzdqeUhGY0N6elA0UGMwYzdzZEovRGFySDBYTlU5MURyRnFQ?=
 =?utf-8?B?MXhUTmFEUURyY0pRWU5OdVJzSFEzdEdJaTJlU2tkZnplemZ6WklnNVNLUUgy?=
 =?utf-8?B?UnRHME02S0Q2YUhTc2N4ZzNXNFVEMGZmdnBabjRNMnNqTENEV2xyUFVMVXVj?=
 =?utf-8?B?cS9BTnlaVU1TM3dJNUNnd0tKWlR5OHEyelFrd0N4QUdwN1VwQkpBUGw1YWxK?=
 =?utf-8?B?WG9aSllwcDhuYjh4WUxMLzEvZGREdXBlYkJTVGE1bE96VDhxa1FRTWNyNUh2?=
 =?utf-8?B?SmwrN1ZneXdGblRpRHVtUEtKYkZsb2g3YTc0QUpFWHNsSjA3bzBxVmd5bTJJ?=
 =?utf-8?B?RkFRMFp6a0VyMWJyeG5IM1ArNWlBUFhSdUtLS25iUm9IUUJDZXBLT0pWbjZH?=
 =?utf-8?B?Qkw4eFJveWJBdFlsYmcyajNuVk4xZFdNRjd5ZkZaVlFQdnF5NmFzaW0vY0xM?=
 =?utf-8?B?MTBjc1cxTk9RWFNseDltVHFJQytZV3BRcmpOK3NVdjJpZnhtL1B4c0FYd2xy?=
 =?utf-8?B?MHNGV3A0RWEyRnJKUElweHcvQ3VMeWJPWU1CRW9zNUpiakxPSytUMDhJbjI1?=
 =?utf-8?B?S3N0OHpvM0hTM2UwMk5hbjVUOHVXY2RoNnp1SGlweEM2QVJ1VS9kMG9MWkVK?=
 =?utf-8?B?Mm1ZUnlqQzJOcUNVVG9zTmgvZEpzQ2F0Y2ZpNUFPZ3pIdVZnMzgyMUtabUlH?=
 =?utf-8?B?TEJOdkF3c2hKTHVuKzc1Y1JGdXE4MW1valRuWU53TFQzRlNtUVM0bmFGTzc0?=
 =?utf-8?B?Y1NiZkhhNTd0UXo2eUpJekd0MW5SWUhXSWdGUnRrbFF2ZFJWcnNrWW4zNnU3?=
 =?utf-8?B?VGhTQWw4OS9IeHhaOGc5aENuYm01ZkJ2aVJXaThrY1RmckRGSGcyUlBHU25l?=
 =?utf-8?B?ZnVNUDJMOWtjUlgyV05WYjA1Rkx6WEpwN3lhSWpsTko1MklCTDNYMlphSEda?=
 =?utf-8?B?T3VtaFpGT3g0NVJsQWhJdHVaWHZDb1FEVjA3MTBUNCtQVW8yaHlQSFhQN0hu?=
 =?utf-8?B?RXVsRVdIbHF0SWc0anBGWUpUWEh4cE43UFhDdUJmcUpubEhGdWtaR1RUNFFY?=
 =?utf-8?B?bzVNNEt5WVk0UFBZWDlPbGpvVWlUVDh2SFhqYmJ4WnpZMk9YS1p2QnFRRXdQ?=
 =?utf-8?B?cDBXYUo2VnBGbUlla0hkOVRKZHhDbHArWFR6UitBYkFMSDltSEdIQkY1bDdu?=
 =?utf-8?B?azNmTzF6NmtyZGNROUlDcW5EbzF4NWxjTS9ETGpSSkNReDllYjF1a2g2dHAr?=
 =?utf-8?B?TS9EaVpBWWFaMHI1QlVCNTRKbEV0OVRERVVVWldEREJhdlNIc0pjWVBTZnZW?=
 =?utf-8?B?U0szREN6MXJ3SndVbTR0T1FNY2VYcmdjWndKeTUxR3VKY0krcUN3R0p0MXhI?=
 =?utf-8?B?VS94ZjBCVjQ4amNBU1B3ZjA0TWk2RGJ1dGkzRHBMT21KdUkrbjd6ODFMYnNj?=
 =?utf-8?Q?Hf/K9kZpUJ2qckO4=3D?=
X-Exchange-RoutingPolicyChecked: gZvHBo7p34/qtC2ARxXRapyGYyGzW6fEydVo/xi3+9B254y/PWPOr5z1VvZqPENKKkO5E3bGLTwdIMmOhbOPM2I4IPLZP8ThKuw0V5AoI6xVzs5rwotV/FQyBV40hiBuAFb/wVrIA4TWakOltZKW8z8jEeJ4G/FjrLdQ7BzVx4e2vddsnX34Xe9x0fpD3EH1RbG2JHxSLFPfRwrDrkD3Gjmcf1C5THyzHTXdSYzlouyWciVVJUDUhG2YBHgE/EtiQ4sPXLifuh/Ytp8Bu4paeNmlPnh2AAutO1t1gr0tNTVjizeeZvuRNpfDBOsQKtC8QlsecsHV0yFqAgfiO3q4HA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 63129612-7543-4862-7f97-08df22e3d366
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 13:23:21.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZoiwL+JbWarDCTuXL/HQ1ZGgwi+hyOOjud7pWdLF7t6EwkeaVcDOB64NiQszNlYjP8rKIbdNZ9rVh7MFWudKkCOJg3FivvPwg7PZennXbZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8415
X-OriginatorOrg: intel.com

On 10/5/26 10:40 AM, Tariq Toukan wrote:
> Hi,
> 
> This series contains mlx5 shared updates as preparation for upcoming
> features.
> 
> Regards,
> Tariq
> 
> Or Har-Toov (1):
>    net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC
> 
> Shay Drory (1):
>    net/mlx5: IFC, Add capability bits for virtual LAG
> 
>   include/linux/mlx5/mlx5_ifc.h | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 00290b9ff59ef47b990d26a6b1a8b2ea6dedf5e9

my understanding is that you should at least link to the
actual code using the new stuff
