Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1D137C90E;
	Thu, 20 Aug 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787240039; cv=fail; b=b7vJ8FBtlHsTwPk+g0lRWnsmEHIFaKmzdzts/0xJXMeNcqPcfI2CL5q7fBWcwx6QiU0itG2zhz10Jya8iKSuodp0KiYXPpFjANRnvh/cuQN5P5bqnsnM8S9rYAWYOwZE9slSTzu8cALowvKbAnzdWrQZjqiW6uKVZk2k5lgBQro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787240039; c=relaxed/simple;
	bh=9DkZlovEqkilhcJCxrsIhvdLYwDtRzS7oUa/tFJ/sSg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dNNYABz91Cc9TjjEaZhr5CB5nG0YZUB/XhsWPVOz3QWfldYoPrkZuAZmJ16Lp+BNMdUrNcRB+tVL9yNZqlmSZ3B8hDciV/GLVUu/CmvhG1heLvBzVgCbf1kl6GhBS2l14D3hQwik3MeSZxaifTRQeIlGbemFmApkdUwAX6jWvZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LK5b5cfD; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LK5b5cfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787240037; x=1818776037;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9DkZlovEqkilhcJCxrsIhvdLYwDtRzS7oUa/tFJ/sSg=;
  b=LK5b5cfDKIk+eslwd4+AdFC+U1Hh0Yr549pB7TOVirsDck3I6ZIJyPwz
   ljapo27Gw+p4P0xvvrkVBvq6cTqKOtIkCvzwRFaYM/n5+3jmJGbGOG8yO
   +Mweh9KmiwW+V9I3/RNv+PrRoRBXp2vJwdfDmcjRuxVULcaRau+frs9i1
   L9O+kTnVo+1OPak6ox02BgkvK1lwkOFG/5d11yHDgWNRGikhkREBhnAsN
   dCZI8Th1IjOkt5sRKua6lyoKgGB79Bq9ksdIRnW6q9gP9B9av4zN5Ofrj
   FVjwLcSFmqi6XyDI8FKfjP4oKNQnK1kua3aQdfbwcvhRuoCKgq8AEl+jb
   w==;
X-CSE-ConnectionGUID: j4h4yShFRYql5DR77WXMXg==
X-CSE-MsgGUID: NcaQuhE7RDqqWk9LMGaPTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="98447461"
X-IronPort-AV: E=Sophos;i="6.25,233,1779174000"; 
   d="scan'208";a="98447461"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 08:33:56 -0700
X-CSE-ConnectionGUID: Th3MsI1PQ0m1rnpDuMXsiA==
X-CSE-MsgGUID: 0aVFQN4yRwmLScs3oc+vMg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 08:33:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 08:33:55 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 20 Aug 2026 08:33:55 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.9) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 20 Aug 2026 08:33:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jzPbqqQIDvEcNvy9+zBPMkmp29O80Ru7EWGRgpahohWtXo+r0j3yTjuFYVrMbM8rHQF87G0cMhCpOaU/t4LUSL0bA7L4g1KOvLH6hGzKHcB+9ovTbGXf943x3+kOSacDOZOuHTgzboDxZEYqEWhU063abtxm+xsasTGpCDhnlf/6GUuSH5Y0e6DsmFDfxbdMG/d4QU0qq6JwUxx+0hDsUVOOZdmeTzr5JMrZHG1g2l2ljga0n9PKgUwwzgQ2vrbO1RvkLNVKmRqGeWbA04hszbThthv991LGb3Nqj465w7HM6vqHR9ZM19Z14Gp9eIz3vLdkE5aptD9tVFVHVZwlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAt8MLJAo/VfDjUNT+oUDLNIY3FxUtnsWA6xMq+/nkE=;
 b=hX1Ju0M6WqvliI3DMc9b8/KLaz1nZwXFAQ5PMn+R6DRU4xMkv4MuvmLDScYe4cuTqtHgvYllksNANdvTzheg9Cdx1XZCuySVYEfGFHsSTQnzY01Ft3BijcqaTYETCZkz8aLSaJTTVRdT8R0jSkrjiyuUu3VRZXjDJSwj7zgibEX7q2tBXEBnzU26sDmVul+Zu9NjnRPdGoV54gmq7EGzOWKUvGtP0aCKfixdGjw8MYztTyuyZqPiiqbk8pfHqL+Xx3ZSche+YybLalcpGc9vC+xcswfgewMIdQRErHrfiLFlqngPUMjlacepBLyq+p6M+UsF1/YR1Dz1KGQTL4BAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB4818.namprd11.prod.outlook.com (2603:10b6:303:93::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.10; Thu, 20 Aug 2026 15:33:50 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd%6]) with mapi id 15.21.0339.007; Thu, 20 Aug 2026
 15:33:50 +0000
Date: Thu, 20 Aug 2026 17:33:30 +0200
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
Subject: Re: [PATCH net v3 3/3] net: stmmac: document oversized AF_XDP frame
 handling
Message-ID: <aoceSoSFMx69Z9up@boxer>
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-4-sdf@fomichev.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260819160535.1472459-4-sdf@fomichev.me>
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB4818:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b8d7a9c-448d-46fe-7cbe-08defed06ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|6133799003|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: PGkGV0EGIuDtCcoTaJqVy38SRvdVfkNc1bvEGiOHIzBULu4GyP2PjDQu15uQ7O+Q8dpeLu73+O4jNDtESdYlmZA5RYOBZ9XUeO5tsXCALAGpUQP6EudaB2TxbzAHCnzKHkpzklWMWKywUEMgj4wre/ff35Kgx8T3urSlIvC8GWF+ksTf9R9PxLF3sp0pyTMFakE7V5t/UYeq9J6vcpmvtkDr55wg8wvJjUxLt2sfzXfPb2WA3N/lB1Pk54ULd7p9wtMEs9EHUn54vlCSlEG065RnZd3DWkU7dvTcoJlSs+EYVmTX0lpPZBuEoYnW259adIU46e8XQJOky+OA9qMTXxjDcZWBQ32l/yAwlFWj4F4d+ZSZImSHGl9FAhPEuy64yC3dXRJDxZEadY/0IYuMIDMQchIArsgq8P2frRV95QNGtCiGMY21++0VGfcyWuBx0Qac40tto3n39Hy1fe4RhbUH1srk/ZYImStEPazDJ/hqbxS0/Jw+ygS2a6044hWEj00KUpJD170/1tU2vXeid9UBkmiKr00ChkPOol8KtwvXZO9HGV8M3j3c1/RYQD3WMM/O8b5FAJ+wdcNw+37SeUaI30Fsw0BgStfAUI3OCTSwKxsbQ3WiyWYzFLYYzs1MVnrNbJzz7pl457yej7MLBTATNYbI/O4YR59n4dJtPH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fVPymRffDwESlX3opbP3hn5xgVfy25YxISRHk2uAV4ciKCo/ybf6dCA231mn?=
 =?us-ascii?Q?quxThijiKS7xZvvqiPNHn1np9owWfLhkz/x6ydb9xH3rRlRK/fHxihPQn2UH?=
 =?us-ascii?Q?hLSq+gVRPpAPOFlnk0CfyRaOiCsqRZAHkSZQkGJVX51RJsd7zWdgAL2xVG2C?=
 =?us-ascii?Q?ZCIT09l33zla2MbElPI/CmFaYfv4G5CCH4rTN6k1UPsjVHpUqFh5cjmFiXxZ?=
 =?us-ascii?Q?nTsyZ6o+IGw0eVEmtoBKeHMFj9aUtwlIkBdZMlbUaYis9dLugyqfv1kVtzQV?=
 =?us-ascii?Q?YvhoKpcIZ8qs3CBaMGq4RW36T+BP0E/DA9+dIknZUKs423ryFnGMNAnGpxay?=
 =?us-ascii?Q?x+hRYReTHUseTAWxVb8XE+VRR1zjy7p7DVF+EkRyJic3F62RBN677KHV+G+U?=
 =?us-ascii?Q?vI1htXZZqIkDTsQL4SNwnNJJKgXUXMtjgne+9CzqxMlhqrb2X/dncuOZ0Ran?=
 =?us-ascii?Q?C77zTuQRGoO6hDQQF+oEynFyW95x92hlzK1djsB/4TTHSjlg98NmWs2PI7xg?=
 =?us-ascii?Q?D/uTjha6SPDCeP+FiI9C9oefKCfEYwGDc4246C2mCTcF7ieJmMIuM0OQX4lA?=
 =?us-ascii?Q?0sNez9TtRyI/1809UTbahPtLBL6dHA762QUQTRl5x+0uh42THNKxH7WyI0TR?=
 =?us-ascii?Q?YKB1sVf5QcM1xxZI2pDyzR03Z/BIPevuNBecDrXNSRPiKHSwMa+0ZALkhwBa?=
 =?us-ascii?Q?JLwuWxroguhC+47+cogoFpy1tagYboD1TFBPn1K+TIvh6cUkbPzyTW5hqfJz?=
 =?us-ascii?Q?oXeaCYiDRTqNpNCvdxp8KQM8NMLv+PvW1GedjHQrBozhn/klHHoljrGF8Z4/?=
 =?us-ascii?Q?NIBqJVlIhmPM+lShFfh1aiLAE9bo53YVgSSRoOELS7fEDz8xY6HOyipddn8D?=
 =?us-ascii?Q?Jo9V5p38++Prvsd7I1FfTgRC8ajvL+03U4zTAFd8wb92PHEVA8SQz1ImGxIz?=
 =?us-ascii?Q?419OzgznPmzgntdHZfLLH/v/1eXlH6SCfNeamjtb1h1b5ovkHsgSOrDuVWNx?=
 =?us-ascii?Q?TJBR+2orpDi8OplytwbFW2ozBh2LjJf2rs7Vb4xv7AzYxJE+R6z/CO/yjgrY?=
 =?us-ascii?Q?UQW8JvqWVUkLiuxxkjSjj9TviaJN8fk1UQcbXm9UJwbuo5Xv2F6iFB0S4Q9W?=
 =?us-ascii?Q?pnlPNofblk4ImddvGXOcB0U54o4YBCm580X6chxYjtSinOIjYxEjZnX/Jx0L?=
 =?us-ascii?Q?HY583CfuVOuZFAG4Q60AT6eAGloPxgVOhdOoqGeJl5io9OnGWbz4svnma3Wk?=
 =?us-ascii?Q?sNHCpKcHPck57ZutsvOW0qg9I7Obs378KSPWLoVjQbKis7G35DAxemc2pIhx?=
 =?us-ascii?Q?fv6Y3k+NmRI7uu/OxS9NMg0Io0H+3Y2QAfj3cYlxkwbYiJshcIdZgkNOQMiw?=
 =?us-ascii?Q?vAVegkns/Y4MIUyp2YESxtgeRxZ3MoK88t4BYrdxnqVqZtBmuxTrnDyBguyV?=
 =?us-ascii?Q?FQ5g6i5PCCTu/Rk2xm5SaH7DqrdHikj+oxQ0O36pv1fbLzctKzkCyDLzd8wV?=
 =?us-ascii?Q?gAk/u0xrlf5mUEL1o7KLWxyOj7RAFDx6kS4Ru4T0a6nFqgrrF+t73bf4v1jT?=
 =?us-ascii?Q?pXpETMNNR0QAdJ5d8+MJ4Dnld16XL1lbpAm34qMeCgHS/+Pc4+C/XqtkQcI6?=
 =?us-ascii?Q?EoD/8TSFqBVbyi1UZiM0fAP8a0kET+YrDbeCCBl/MqevWu2n2h5hAux27MBf?=
 =?us-ascii?Q?q8x5+i/DI1Z/8d83dh/1nwJ9BYukHJp7GwPYe3FgHP5IxjcJK0JmwqIoomJp?=
 =?us-ascii?Q?Y/GGIs+2GiFT3jFtgkxfDZh3YdI6RTQ=3D?=
X-Exchange-RoutingPolicyChecked: LjRsMZmNZ5xUIScVkdThN7dXhJ+NQB+wulxL7bh2PzwHHGuBFpWHbFmBbgUTuVVBkJt42n29B01wDsP0VF9kKUxnT6GK+dJHpvCJDA86ZrjQxgbXloeRT+ImaoNl+L5Y0sfeLMeNOKRvA8E1kZ5oSV74ShMvIxUk9S2MFuYS/qNbncuLcVUB9HUGTFf3DQ6hXRGO1A0iZjhFKvY/wrGNQacoaf4TRLk9adAEWp5omthd/iRq8Hev42fKg/+s118tOMb0H9j3qwduHOCdztHHcnYZKTY2pkh+e0EMyCOP4spWLjJR7Hy/1yAVPw1t6BPVtDHJ3Do5d3uVdTn8F3zQiA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8d7a9c-448d-46fe-7cbe-08defed06ef5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 15:33:50.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2pp0fMy7mj9Kbd8FUFbPTXk9xvayKiC94sMCVRpZE+dCck7uWuA0wUUysiC5s+xOOdSa3aD3Jb1wLvvpmUGURR4jAUBCJ5CjVHZ4Ljybx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4818
X-OriginatorOrg: intel.com

On Wed, Aug 19, 2026 at 09:05:35AM -0700, Stanislav Fomichev wrote:
> stmmac drops AF_XDP zero-copy frames that exceed taprio's queueMaxSDU
> after xsk_tx_peek_desc() has reserved their completion entries.
> 
> Completing a rejected descriptor is unsafe because AF_XDP completions are
> ordered: xsk_tx_completed(pool, 1) would complete the oldest outstanding
> descriptor, which may still be owned by hardware. Instead, leave the
> completion pending so the ring eventually wedges and increment the drop
> counter to expose the application error without risking hardware
> misbehavior.
> 
> Document this intentional ring imbalance at the check.
> 
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 62de03e65a90..6a532747c039 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2713,6 +2713,10 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
>  		if (priv->est && priv->est->enable &&
>  		    priv->est->max_sdu[queue] &&
>  		    xdp_desc.len > priv->est->max_sdu[queue]) {
> +			/* Completions are ordered, so this descriptor cannot
> +			 * be completed safely. Wedge the ring to expose the
> +			 * application error instead.
> +			 */
>  			priv->xstats.max_sdu_txq_drop[queue]++;
>  			continue;

Hmm. I read the discussion on v2. Maybe we could cancel cq entry here in
this branch? Also it feels like something achievable at bind time when
taprio is configured and vice versa?

Otherwise we over-commit cq entries.

>  		}
> -- 
> 2.53.0-Meta
> 
