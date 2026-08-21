Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A97737DAB5;
	Fri, 21 Aug 2026 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311333; cv=fail; b=owESB9vaLdU4+CobarplSXNMy5qUlpFemnznWLDD+2sW4ogeY2kf2YfLbrJX/2QRaRP00ugtwNXtVd4aIs9RcptOHlx7YngB8inh2VWD4bnn/Hd2N/rGek0FDc7xeJ6btubKuecrSiQTGw+IpCuJNCNbWhjOLJW0MkGhTscoBao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311333; c=relaxed/simple;
	bh=dVqpDjhWfYFwUNfGDHeCGktw557cjfp4Gg2Cdn9tvEE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aSlCDIM23S9+DffmDMJVEHa44hLTxU9hNJar7RGkxB23VTkSe21KiLAluKWPDmV2ORvlDdYPRODtshRWDl7+B4By9Tf1t+uDhmBrYqTeqr9PaZWbNtNjJ7rjtMHJwc3MMP45RBjuPTIKbLhTXw/KR0yfw3z2kofvazKxtUBp87A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCm2DyjZ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCm2DyjZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787311329; x=1818847329;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dVqpDjhWfYFwUNfGDHeCGktw557cjfp4Gg2Cdn9tvEE=;
  b=LCm2DyjZl75NDXRGvPcKhOe/rtdMUHIHbuAGF3jWmpcoCEy2HluI49ZW
   IVzAtlb5It2JPfONbMowxCMhkopqnRVtSe2pSlHLs6Fm9tUMXtfcE/eCB
   PKQFWucl1tOVNlp4EC3eYHaJz/0ANyUv7U6aKM+0ZcRZIlU9BEsrfWc8B
   SvEKU4/ff/hzP0TaT8EiIDr5Y+RG9nUmS/yjuKI0bilop3hhKMCYCAGWK
   w4sXzODR1NxQ55F+i8UAA7VJMXap4ErbYlXaJjmocm2548ADQUhFUk9TG
   KIo1g++fg8nUXfYNfZ3vppTUj6HIysRSKZLNkPhc9XdGCC0YgcZCT7T0M
   g==;
X-CSE-ConnectionGUID: fuDu0WiSQZec0fzE1Eid+g==
X-CSE-MsgGUID: cvFZlTvYRKepvCIikiqdQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87919208"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="87919208"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 04:22:05 -0700
X-CSE-ConnectionGUID: f2x2DIarSaKDC/H33EDN3g==
X-CSE-MsgGUID: nCrnzgVOQnSW56dT9vBJbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="266910343"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 04:22:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 04:22:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 04:22:03 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.43) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 04:22:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIf8Y6lRNzWkZE47UEUj6h1DGQJWwa6S80rYNFyKtI47gqL6nL+F5FNtMWFg2LJWpVgVWbQQC72E3XAAtWMSdAPxTj5VyObm7NRwDv8aPjd90dMfO84t8iirrDv/6KgI3dhQUAxr1AzviPOZbwJe6XhlOmyINOVmIClBu21eGFbeo4Q3pMgSjZ3IGPZpyVfirQoa+v8MN54dbvJcf3/A3+bzEPnt51I+Ij67FgFH+WiiU16pqXT1DysTFZwEot36F8+i6nufcZrD5MnU3KtLtn7kV43KSa23NEd+3qVFCTw+NwqE6UWQVbcoMj2pisMKycyexoSYIENxo8iRXl1JKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtsEkn/+BTHHwNgiX/Dgdv1hLayCqg8HD6WK4uhxMRI=;
 b=fx3F/3BpvBQhJm93xPgwbH1JMR5TSRULPh59gh/VrDe2x+R/kOnpg0DSGlWP+4rTZsm8ZbKVvmyxnGBsLSFff5QUIL5Ze7r7Uogh+1Rgg8Wu6ZVkaviYe+95c/nS6atHBcw+dQrZwI6zYFKiJYodbylwFmnpeM4PAsGNbwaS2LRhCwOEWEcacTn6/EHIwWnu7l8+zU/vlxr3/MNHoktY4j73VSDkQ9amNyJI0v+s6HIHOHDPjHlyeSDa1u02MjNqINIkFoFJxTnNLTROCLJquV52605BqTBkHlaeFBr3J0759/ed2CgZyG2GG0gTZB7NkSuU6CT7BF2GrFCpuwzcJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW6PR11MB8437.namprd11.prod.outlook.com (2603:10b6:303:249::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 11:21:59 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd%6]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 11:21:59 +0000
Date: Fri, 21 Aug 2026 13:21:45 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <anthony.l.nguyen@intel.com>,
	<przemyslaw.kitszel@intel.com>, <andrew+netdev@lunn.ch>, <saeedm@nvidia.com>,
	<tariqt@nvidia.com>, <mbloch@nvidia.com>, <maxime.chevallier@bootlin.com>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<aleksander.lobakin@intel.com>, <horms@kernel.org>,
	<magnus.karlsson@intel.com>, <sdf@fomichev.me>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<guoren@kernel.org>, <dtatulea@nvidia.com>, <witu@nvidia.com>,
	<martin.lau@kernel.org>, <yoong.siang.song@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <bpf@vger.kernel.org>,
	<linux-csky@vger.kernel.org>, <leon@kernel.org>
Subject: Re: [PATCH net v3 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
Message-ID: <aog0yV9ZwSJ14P8Y@boxer>
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-3-sdf@fomichev.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260819160535.1472459-3-sdf@fomichev.me>
X-ClientProxiedBy: TL2P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW6PR11MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee1de98-f849-4937-47fa-08deff766a9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: KgeA2flJA+mJ3U6y/UsCzqmJuovAnBvzAvtGBCHKbESUNnc3DkZPCAvyO27V2q87+9CwoDoXwsC5x2NhUC38929Kjikwyv8baae7r7P9vIR5kUGcRUVkXjYwTN63kC90dye/wgDXvo7jJWAco4DM3LtuBShQ4tql7/mYbSmYekg/PaGguMvnG5viASjAzStQtLxcSbEohiNT1ALOYdD6005omzQgXrJsMU3oi+BPZREMedDD8QRXRlhXzYwLjab9CeuZCFxQNFD9g51vLcOGjPIVIzlZcljBAuYmuteMPJoP4JgPHH/Jhvpm3rjSWTZYNPgFX05FhSArbLttu3DIdctGG4oTf2OtPgYjPa3FJ+cAyhBm85e8NgHE1qGXIuKT1HaltXAlGfieK0A8YOajY2+ZFcMAXCcCzplMuGc1Kcc/tHBqt2JODAd61XADa9nm3nWTcf8lfRLhBccaiZ95xHHTIhfAiH+JoE6Jv+HoeD00dJU1YW+0zDiofXMHaWxGnC3XDHWVtxf22LMtx9VfHWp9/pmREl3QuNREbR0qy1sXuGN6WbzJa5wCcf0rfJs8RxVIws4/h+j+iI9/FD77Yvqv40HkJPnGonStKAKGE+ZsijJwRpl8ABr1cbqKPK3buhtIlUrKlTqM5rLic7acUhbsKV+SWi71qZtgWSGC/pg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fIlS8D223UUeuFenCigeOsYPO1Oi/GH98vBeFyqOym8+RdH6zY4G2gsaKvsT?=
 =?us-ascii?Q?DSdbLvBHuBellZvSt2LsSM/5QZ1Iu3Za/qK6J4vOOYY5AQcgTVkLKlWDthIS?=
 =?us-ascii?Q?iTZBJ7tE8SzEmUwSZVbMuCP5OjiSkJZDnaEoHFC6k1RVuM1+x+0dbQmGsvSd?=
 =?us-ascii?Q?W0HMO/8/sHIs+Xpqyctwd2/O2s6buUZBXk0WHHHFsRmBxG42LbJYBIrv6UJu?=
 =?us-ascii?Q?CK6EDA2JU9lE6yLCrwR3XKqeOl8uewg7IhvA3a0PNzzlDvaUx9jaMeq9I73t?=
 =?us-ascii?Q?Bjr+ZWeXwGqFp57I05pp6E2xVAc5knqqEXRKG82GYChiHvDr2StZgH3OH4SR?=
 =?us-ascii?Q?M+yyGLOx1iTZItxx9K7k9t9lQowhqkS4WYUtkD41Tpf4RetNDayOD1N9en2Y?=
 =?us-ascii?Q?Iy8YAQ3+yWrPgKtgJewjsMDy8ua+F6op5q78F6jST/iEyNZ4YRYaJ+qcfGjJ?=
 =?us-ascii?Q?BhcwM5zFpLe/7QczeoGuswtRsQRFs3emMnRwhZlVijpxImJAEdH4uwYZ9FsX?=
 =?us-ascii?Q?THhF+qJNkPnLznYOzHJ8jCqKbB/CKUmz3aBfveiR7CJSjsCB0G1cb30BLYKC?=
 =?us-ascii?Q?wHQ8igngXoX7anyGbME+C86cFKat+fb8cH0INpE7tlOu8dTm0KHUIfg+HDNp?=
 =?us-ascii?Q?jHYJj7dCnqTaHpcsbvf5NcsemOzZYeZAHUiKy1JR1KnzFWIPy6VjuBLe2r5b?=
 =?us-ascii?Q?irQumDLQveO3mW8XNi9ZPeyPeLJJhhbhoO+TeyLuugc49Lk6sYU89o4zYMkS?=
 =?us-ascii?Q?llnHqbOZepiv7w9EvAvabc5cMWPIq4ItLvmYo0KdR+yw7CuTVlhhjqw3frhS?=
 =?us-ascii?Q?Sa9kM98AzK/JHwSxIVtofRSYRfXxdIDhG3uJukHWmpNZAAyqIPRSHMMJHAVc?=
 =?us-ascii?Q?MvNL20jioR/e96gw2jLWrVzU34mnXjHad+EeS43ZvXrE9oJ0HymvJMfsuAk2?=
 =?us-ascii?Q?EM7Bur+OY9emJkm0HkVeXc+XngRATt+AsegpbC5pdGd7R2mrJEtwwlHbKtF7?=
 =?us-ascii?Q?2Nhfvj6X6liMQ+zNKkKvaBRScCLVFPgu7U6k4QyR0RM8dnssSuC9an/peA7+?=
 =?us-ascii?Q?XgTuXThWhLeDtIItQSn3w7dKqIpjuKXQXIFKK3+E1MUqE6do916vUSGMklLt?=
 =?us-ascii?Q?SIOT2jV0DEeuC3Gxl/5OHoZVKtlFLwfI5OGqTTU4K7pRuqMl2X5aX21uxcY9?=
 =?us-ascii?Q?bhKaffdmSj2aveU9PLFz1+gNkChB/dqoZV7fOMtmXI1BkdRKknDb2y03g1Yt?=
 =?us-ascii?Q?6GecG2Nnn/iWHspwmciZPYheGd4+XKs5N7C0rfn229xOVzytmrULnRsyV1XF?=
 =?us-ascii?Q?AZh+3GdP6NrTt+WDd4ZYLpowxnZvChoPciwFmY1yziilwnKk/VTCqT5LtqhN?=
 =?us-ascii?Q?4f6oBkgRue6+bVAQxA0ilY9lpR0hcCXE+7rMywIFMcrp6OsX5ePPfxGsvfwG?=
 =?us-ascii?Q?I1hpVqV1Aj1nJ+blzKeeUDlg2+y3lsQ29M6redwg0SsJlqykqdaHQgxDw6eq?=
 =?us-ascii?Q?KWZG21BTSds9cn8gLKYQE+HXwJM+PVGlsOyg7rFsJgm5zP5dWopSz+Kb6qwV?=
 =?us-ascii?Q?49SzR+JuxgFw2rCGrOPsGVf7wJh3voc+/VWMUlGtEsOvGlupJMXWvuExlmf5?=
 =?us-ascii?Q?QIPJWROyt8ZhaunYot9syjeMVjKETE1/Kd9SbpkleORIg/+bXHtOSXQJrC6e?=
 =?us-ascii?Q?Y1wRhJO26r28QDkGGRZgKTWnxeelrO77PxL0hdMPNwNxdXI1dlz7dLNDE5Oj?=
 =?us-ascii?Q?99wZJDLAZCAfEPJkLaLe8dNjUA3DdTE=3D?=
X-Exchange-RoutingPolicyChecked: hwWr6K2pTbQ9C/ueJYdnWHiLf8JLoG2GEYtRAiuskN9ggWk6cUnjrYPeIIqaF4R8Q+GdLKVNB9ikbDwf4rE8DYWCSXz3qIOb9ZHHwPoAUPt607ky1BEutYbKyJGzwT/Dp7Sa6eeCPdJh3O+RNMsGD0SPPThswf/GVafpNplshsH5pogJLIfkhw4/hLnOsJ8icdUsDvGC/G04vfG19+z3uxYvqXN+Kkr56+Sk1NJzrf5Tezl/8sSGhvA71A1xXG1A/LDKQxk9sxUiOBChx3rt+yrGLSOs0EjccA6kkqsivoCHDMFcOgL/mEVUM/SDXCFncVGJ0fpcURXagkuuk0UBKA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee1de98-f849-4937-47fa-08deff766a9c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 11:21:59.4470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnZawhsxW3w667rBVjxtdXn1dhCdV8GkIJVv2HJGjQKdygQXARH2Qtdnuzho+Esrf2Bx8U0OeFU1Vspbale00VWOJh+UC5JwSy3ARiWh8BI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8437
X-OriginatorOrg: intel.com

On Wed, Aug 19, 2026 at 09:05:34AM -0700, Stanislav Fomichev wrote:
> The zero-copy path reads TX metadata whenever the UMEM has metadata space,
> even if the descriptor does not set XDP_TX_METADATA. Pass descriptor
> options through the metadata helpers and ignore metadata unless the option
> is set.
> 
> This does not fix the existing per-WQE metadata handling for mlx5 MPWQEs.
> Only the descriptor that starts a session passes through
> xsk_tx_metadata_request() and configures offload state shared by the batch.
> Metadata on descriptors joining an open session is therefore not validated
> and does not configure its requested offloads. In addition, a non-NULL
> metadata pointer from such a descriptor is treated as a timestamp
> completion request even when XDP_TXMD_FLAGS_TIMESTAMP is not set, so its
> metadata union can be overwritten with an unrequested timestamp. Fixing
> mixed metadata states within one MPWQE requires a separate change.
> 
> Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/igc/igc_main.c     |  3 ++-
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
>  include/net/libeth/xsk.h                      |  2 +-
>  include/net/xdp_sock_drv.h                    | 22 +++++++++++--------
>  include/net/xsk_buff_pool.h                   |  3 ++-
>  net/xdp/xsk_buff_pool.c                       |  7 ++++--
>  7 files changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 39043d8ca1bf..59067939a586 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -3074,7 +3074,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
>  		olinfo_status = xdp_desc.len << IGC_ADVTXD_PAYLEN_SHIFT;
>  
>  		dma = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
> -		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
> +		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
> +					     xdp_desc.options);
>  		xsk_buff_raw_dma_sync_for_device(pool, dma, xdp_desc.len);
>  		bi = &ring->tx_buffer_info[ntu];
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> index 3d19dad8f868..d194eeddd7b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
> @@ -99,7 +99,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
>  		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool, desc.addr);
>  		xdptxd.data = xsk_buff_raw_get_data(pool, desc.addr);
>  		xdptxd.len = desc.len;
> -		meta = xsk_buff_get_metadata(pool, desc.addr);
> +		meta = xsk_buff_get_metadata(pool, desc.addr, desc.options);
>  
>  		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
>  
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index a71f0df26378..62de03e65a90 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2719,7 +2719,8 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
>  
>  		tx_desc = stmmac_get_tx_desc(priv, tx_q, entry);
>  		dma_addr = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
> -		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
> +		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
> +					     xdp_desc.options);
>  		xsk_buff_raw_dma_sync_for_device(pool, dma_addr, xdp_desc.len);
>  
>  		/* To return XDP buffer to XSK pool, we simple call
> diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
> index 5dcc0d7f65b7..a452b7828ce4 100644
> --- a/include/net/libeth/xsk.h
> +++ b/include/net/libeth/xsk.h
> @@ -196,7 +196,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct xdp_desc *xdesc,
>  	struct libeth_xdp_tx_desc desc;
>  	struct xdp_desc_ctx ctx;
>  
> -	ctx = xsk_buff_raw_get_ctx(sq->pool, xdesc->addr);
> +	ctx = xsk_buff_raw_get_ctx(sq->pool, xdesc->addr, xdesc->options);
>  	desc = (typeof(desc)){
>  		.addr	= ctx.dma,
>  		__libeth_xdp_tx_len(xdesc->len),
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index b344789f5df8..d94aeb506379 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -240,6 +240,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
>   * xsk_buff_raw_get_ctx - get &xdp_desc context
>   * @pool: XSk buff pool desc address belongs to
>   * @addr: desc address (from userspace)
> + * @options: desc options (from userspace)
>   *
>   * Wrapper for xp_raw_get_ctx() to be used in drivers, see its kdoc for
>   * details.
> @@ -248,9 +249,9 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
>   * pointer, if it is present (initialized to %NULL otherwise).
>   */
>  static inline struct xdp_desc_ctx
> -xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32 options)
>  {
> -	return xp_raw_get_ctx(pool, addr);
> +	return xp_raw_get_ctx(pool, addr, options);
>  }
>  
>  #define XDP_TXMD_FLAGS_VALID ( \
> @@ -318,18 +319,20 @@ xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
>  }
>  
>  static inline struct xsk_tx_metadata *
> -__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
> +__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
> +			unsigned int options)
>  {
> -	if (!pool->tx_metadata_len)
> +	if (!pool->tx_metadata_len || !(options & XDP_TX_METADATA))
>  		return NULL;
>  
>  	return data - pool->tx_metadata_len;
>  }
>  
>  static inline struct xsk_tx_metadata *
> -xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
>  {
> -	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool, addr));
> +	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool, addr),
> +				       options);
>  }
>  
>  static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
> @@ -510,7 +513,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
>  }
>  
>  static inline struct xdp_desc_ctx
> -xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32 options)
>  {
>  	return (struct xdp_desc_ctx){ };
>  }
> @@ -530,13 +533,14 @@ xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
>  }
>  
>  static inline struct xsk_tx_metadata *
> -__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
> +__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
> +			unsigned int options)
>  {
>  	return NULL;
>  }
>  
>  static inline struct xsk_tx_metadata *
> -xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
> +xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
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
>  
> -struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr);
> +struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr,
> +				   u32 options);
>  
>  static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
>  {
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 78c14f106395..9d2d94f1fb75 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -763,6 +763,7 @@ EXPORT_SYMBOL(xp_raw_get_dma);
>   * xp_raw_get_ctx - get &xdp_desc context
>   * @pool: XSk buff pool desc address belongs to
>   * @addr: desc address (from userspace)
> + * @options: desc options (from userspace)
>   *
>   * Helper for getting desc's DMA address and metadata pointer, if present.
>   * Saves one call on hotpath and double calculation of the actual address.
> @@ -771,14 +772,16 @@ EXPORT_SYMBOL(xp_raw_get_dma);
>   * Return: new &xdp_desc_ctx struct containing desc's DMA address and metadata
>   * pointer, if it is present (initialized to %NULL otherwise).
>   */
> -struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
> +struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr,
> +				   u32 options)
>  {
>  	struct xdp_desc_ctx ret;
>  
>  	addr = __xp_raw_get_addr(pool, addr);
>  
>  	ret.dma = __xp_raw_get_dma(pool, addr);
> -	ret.meta = __xsk_buff_get_metadata(pool, __xp_raw_get_data(pool, addr));
> +	ret.meta = __xsk_buff_get_metadata(pool, __xp_raw_get_data(pool, addr),
> +					   options);
>  
>  	return ret;
>  }
> -- 
> 2.53.0-Meta
> 
