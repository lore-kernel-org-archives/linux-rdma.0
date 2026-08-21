Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC9478E47;
	Fri, 21 Aug 2026 10:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787308339; cv=fail; b=Ofl1ZVUNNlsBwXs9CL/ebQI6z7Pa5SohIbHp7lSO5u/6mH/p9wI6F5+Qu6YHR4vl4QKbKNZm0fYmR8dstH1gYNQC9M0L6ZWjRygtayChHtea/ZMIAmsRxVtYVFkqjy9R+feCK23JcdQuKQ5RG3rTxnM2WqvC/w676lXJgk8iHrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787308339; c=relaxed/simple;
	bh=kmJGQE7E/wdVOT/+t0iDSz2wFDoQPXn5dcohef0pHuk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HyrW4dLYp1a99WjiDF2MB2y2jPXcW2Xv70KhIP+E6ORCvFu2j3m54M1zSj4rd8l5cQt8hw48Zzju70bV9whdzRJIi376+bvtKJvJSgGeIcIaFdM48UVyvnoDtDjRZVVuQ2bd2Yvggvtkuy1G52mTs8zKBnwvBpHGQ5dH8mea558=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LUqJQylC; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LUqJQylC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787308333; x=1818844333;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kmJGQE7E/wdVOT/+t0iDSz2wFDoQPXn5dcohef0pHuk=;
  b=LUqJQylCtIgxRWtZ3vSpK/GvBHUQK5Amg51VK/F2J1MNIfFD2dUXzu0O
   FBn8cq55xMYejn+kBTgi669ZVwgIZiVqcWn7I8WM7IlIcIzpx6btdSM+4
   g1i9kpaRaOAkFYgBFEwGblTvUVvI/FLHVmHTIPr+y47KqRz/Icb7ESYZj
   eEFe9SkT9crwD/R9loL43OlxW/dSbu+YRMY7q3V4hvnksTpRTX9BZDz+n
   bmGeNuzZNrdwN9DU7JeyxoFYG76FQ9oaVF2lgHQKvIldlJyt8jRnVnvBQ
   KBftCNuyaAyplzJaFIJV2/yADUJ/3GyUOBbq99aKsySwiiV2sZvnYDtlc
   w==;
X-CSE-ConnectionGUID: JAWJmCvgRUKp2UivkPTAcQ==
X-CSE-MsgGUID: GQWmDCUxTTmZ2sYsR0BASA==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="87874898"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="87874898"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 03:32:06 -0700
X-CSE-ConnectionGUID: rZQWCpZQSZGHGKKmDm+7fA==
X-CSE-MsgGUID: HjGYWxbfQq+6HP6bQ8SPdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="266374294"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 03:32:05 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 03:32:04 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 03:32:04 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.39) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 03:32:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=op8V68Scf9phuRzLRs3TKE0ZFqWhwP5GBEuxCaB+fIJ3NMOP3RFlka5N5/hKyOe8gfQbg7QWjtWGlebzhZ4iWwAEYeqVs7jB0LgE7pDRmJxgiJb6P66LAo06gqj6RB7ojDHE0b4g+ZTU6wpZmQMuInr7lY5oNWghkVUwCy1JZPqGloerXDEtWt0G43Um6fQuwE1HUyLpe5gsdL3KY78W43j1Zvj1V0eH0RhRl1EZiM/jaxaOnlyQ5X1SZXk/vVvp6kCGUwhMDNrqi4VhNc9ZX/B6yNOJ2J4fUhWIXcrPP1cZAtWY4FXNgcds0w0P6/vZHEmTiNbG2WumcFm3JygVgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUc8cUpKMiwfQZiHw3aNiFIwFwgzdQU/CWaB+eB2FC4=;
 b=p0Fg5HX+7MptP09SuAQkEwdW1oXWe38rKDcsoTqJpHyEWv0xaTir+mJGGOjZmFiHmPh1R7StAw+J4B/lyk0aFjOlWQpWQa11DUHSJDRytfdZGC4UrcsXG0N6BXq6pEdbnXlhZK35XddZlLg62VN5FImstFVzKauyCOXp8BRYo6LHDQeTARjiEX134IsaA9nPHRrf9aW3GblPl0KsrDMwAdAb6P1ec9OZHg/Tt9VYvjPIP3C9Z+qx89Tq9fC2RVOWlGIhMVSTsmQ6fnkCXbe3NpaQ8AFE9C25/WcffwXh6D1B8vc7heYVTlS3FYJB1MI0lnIvzpBL36NG0PXCBCtbKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7870.namprd11.prod.outlook.com (2603:10b6:208:3f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 10:32:00 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd%6]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 10:32:00 +0000
Date: Fri, 21 Aug 2026 12:31:42 +0200
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
Message-ID: <aogpDsa8hz6CPpD3@boxer>
References: <20260819160535.1472459-1-sdf@fomichev.me>
 <20260819160535.1472459-4-sdf@fomichev.me>
 <aoceSoSFMx69Z9up@boxer>
 <aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aoeoJ6-njBxcWs4w@devvm7509.cco0.facebook.com>
X-ClientProxiedBy: TL2P290CA0029.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: b56b599a-8cb8-43b5-7a30-08deff6f6ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|6133799003|56012099006|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 1FJfcUSEd8RjSLBi+aOZcVH6THiwW8cD6mMD/kmwjFLlWIb4YWpICPqXu/IHGD2VDv4C8Lj9mxYODTobveJlILb65D+CSg9RlW1p8IQwHkVY/1dU0Xh046ePYS6moN6+BGmhCUrEC+CsRKgO8mQWTcOKXd6EpE8F6Dj6Qrni6tAzNtBKhIEU+rK260uFcYTDj/8VxHn2fGPtI2dndOkBTWLUt0CkV2/oEYaqBHj/isP98Ng//TwZMEkaiYXJOdpJr8Lew3W+ZGanNjrdmcZr5rG1LRAtR4rrg1Yf8zd62RT+XeUoK7sidho3tGqV3XlbybnfvmKIuUfbkHLOqx/bjTYcwKcUZUGg/UTTcN8AvfqwKjpC+1k3XTBDR3NgJkeq2n7PQuGdzFQCz6/xSCFtPlb7qjP6L3p1COmxOnLO6JnNjJlbYe0m23yIq+r5DzXG5MuXUvbtYaF1E42Q3EsisRrZOuZFu0i1/X5aHtwzD9vLMTqz7kllkUiN3urdGQ1mpA5PDy/phiYC471OtydhOpP4fZFv8BetqHKnCWRN7itLLkqRKFhxtigSi39szYpG46IWbuQ0IDX6SCxUzhfW0z+ghG4guYGZUEpotf1vEOTqUqXM3LQ1Ell/tLra+RaErtt2dMhfemXZ+TIXRrfE05CbD0LnJarTnEQgoLMMC6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aBFVOGagoniy/jDNZ/qYv+KGiueCK+eM1JA1+zZqM87paHq3lwDPqEFXNAMP?=
 =?us-ascii?Q?yQG3TQWeeqskSefBlOVNfs85n7KpZMXFONPabt6nYBMGwARll1ZraVflz1tp?=
 =?us-ascii?Q?itQ2+/MJ0VXOFxdwdotAF8AXRIH7QIScUgT2s0thpzdUeoh8Q1F5JgCAAUL5?=
 =?us-ascii?Q?CHxHLx68fPVK8+8FiD5873ilmhBre+Qust6z0VFqcdqMpBkOA7OUrCfgMKUa?=
 =?us-ascii?Q?L54do3y1B7lJGc/DkG/qlRAdpst9T+ilsOOV4BTDH+LbabJtsV3Wzhgalj6A?=
 =?us-ascii?Q?c5rwC1JaBSJZaqVhp/SsfR0jh9eL32gD50E9R4xmdI2TX/rYBIY8zlGHXh6a?=
 =?us-ascii?Q?dd7qsvKYTJK5uFC2AEZfjgypDGoY/TQO8ZV4uMFatvz3YFwg7vwZGSjvjS0B?=
 =?us-ascii?Q?/ImG5YCnpiNawXTthP3qetXJn0a1kx0iDflRSDUPTGyA+nxvYqHtfr8SVmSo?=
 =?us-ascii?Q?dX0mvsXlg0yr7/UoGSovngto/SkO/JQFRvs8NJygZsBv57TA05TxK99Lv7S6?=
 =?us-ascii?Q?TRgIh1iPZC+RcczuyfvzbJyNC6Vs9FExZg3CSzKyXGZkGznpzptDlZlmf8uf?=
 =?us-ascii?Q?r/mJvko8sHwDzSIN8WxCBQ+x7M+BNdQUW9U08v/y5k7kw/GSBDxqUFtuf4xE?=
 =?us-ascii?Q?QPOVxNXcgVbvCdtKoyR4nW/pAByeRDAJP70wTPUO1CzVXvDlpLSlcbDvVsQ6?=
 =?us-ascii?Q?k99JecGWRInRZifJjCf8gEIg/jT1yh4rrygzlTYofBETJ/FjbeBfdSYprkUl?=
 =?us-ascii?Q?q6i6VIpY29sWeW+664XbIUBw5az5X5AEEWXb4iYZ/eOzcDyk/dUtnx4k1qzH?=
 =?us-ascii?Q?jdOF6iwxEl0dew2UTd37Uq7hCSfEF6CaesETgF8X/g8ca2XiY9gTR65pan24?=
 =?us-ascii?Q?6FoY5WmsjVEPbC4MZcWMDSaUyQR34R3+FQbhsASQLZY9T56/z9JnTZ9B34uV?=
 =?us-ascii?Q?aaOH7d4798QglhK71F2PEKgrXz3bAKb6qHSy1cz+6aDP1lt9zJhdiK/IrPLL?=
 =?us-ascii?Q?fiYwMBS6gB70Bc6/U4vuhZCixA2b4R1Q6s/UJ0lc/4Dws0Phv7x2Ja/O/uoS?=
 =?us-ascii?Q?HolGTG4kRqMar55XQrB7P3LsTgHbzYSs4sHiTviJ+jbjM7PxMtcGf0pfudWb?=
 =?us-ascii?Q?PIpC29qWHnIxH9S190XLKb8k2VyaaLKBxScAlTuoI2sN0dyWmaDOyqcDmfkS?=
 =?us-ascii?Q?/rKC+Ja7uiHChyG5Ach9VsynaU/ckfjxjU+ByTBRM4yKqC6rOULW8XGJ1YrL?=
 =?us-ascii?Q?qIwNjvsfOwkOIGz7rHVkxr1fRhdrpYY+iZL5tB+Wq2skbxuGzPTcvRTXCBMp?=
 =?us-ascii?Q?GO1sdEMQeaNh+M/TxmX8Pe0oRMNcoUmFpoLE2FvmhuM8rETlQjnxhM/irzh4?=
 =?us-ascii?Q?qYklthlrNnGCstSiXg9nn8iTV7k412V4rpkq7N6lTE8OkQDVfMsJL5yL97T9?=
 =?us-ascii?Q?0zwiaDgFlZNkJeMLyowGdfTimHNowH79ZqRfCrZJnZRmr7F41sZ5MktSexXJ?=
 =?us-ascii?Q?KndVpct4PNK1L8RZzHxniErDqxMONKmoDaiq8YB27gKP0tYQ6Sl8jtcQJ/6o?=
 =?us-ascii?Q?+l79/zPxLZsAEPcHrBhwRIKV7LzsrSPofMOefh7odJwphUpw6WYucdxZQSIm?=
 =?us-ascii?Q?EGiQsT0v60uLuZPhuoki0ERJ7IxLKB8HQ5e8hgNZjhQd1gA30SR1yQDULQBq?=
 =?us-ascii?Q?QYblZ1MFzH9tahwcCMXf+JpejvFqJhkt/h3dfQUj0un0hfEL8MItdCkinjkC?=
 =?us-ascii?Q?Rf12iuF8K8Di2nVBI3mmXlmIXAltOcM=3D?=
X-Exchange-RoutingPolicyChecked: PKqa6WN4CnjULbHtavo4nwcCc9ge2JCYHisIaKDxhzuJ9QXkkB6mSt4NGA5HjuHbEgUGgQVAIY1l/ilwwRXj1EpRKGYHCHtNLIfL/uFnstkZwg9NcrJm8lBr7QBpjvp5ePwULk08ExxDqNkwlYS4U46Jm+AZm82u9ZTXNmgaAiez7Gcy7xNtc/E1PIiGHj64FZgk5cloJda/exkqyTZ+4olc48+MfkVyIU9l0s156WlOtH1kKoNDrDBWLI3O+cKcuSN4EJneL2QRMLlIZqmhwGgey6iccJA9KdOsSv48Mk/FLXgIth/KSZ31fuyqfbd6++T9HfRrEZ5xsSzNLdTDAQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: b56b599a-8cb8-43b5-7a30-08deff6f6ecf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 10:32:00.0474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDLUbWFANWJeMZw2RSOE/WjOXlhLN9tpI5oxsS6y+b4wg4486kp5zUm1ZYEF1QRarifaMHBMR3pP957RkovXaF+AOVBijPJOirnZXLZRmLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7870
X-OriginatorOrg: intel.com

On Thu, Aug 20, 2026 at 06:29:16PM -0700, Stanislav Fomichev wrote:
> On 08/20, Maciej Fijalkowski wrote:
> > On Wed, Aug 19, 2026 at 09:05:35AM -0700, Stanislav Fomichev wrote:
> > > stmmac drops AF_XDP zero-copy frames that exceed taprio's queueMaxSDU
> > > after xsk_tx_peek_desc() has reserved their completion entries.
> > > 
> > > Completing a rejected descriptor is unsafe because AF_XDP completions are
> > > ordered: xsk_tx_completed(pool, 1) would complete the oldest outstanding
> > > descriptor, which may still be owned by hardware. Instead, leave the
> > > completion pending so the ring eventually wedges and increment the drop
> > > counter to expose the application error without risking hardware
> > > misbehavior.
> > > 
> > > Document this intentional ring imbalance at the check.
> > > 
> > > Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index 62de03e65a90..6a532747c039 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -2713,6 +2713,10 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
> > >  		if (priv->est && priv->est->enable &&
> > >  		    priv->est->max_sdu[queue] &&
> > >  		    xdp_desc.len > priv->est->max_sdu[queue]) {
> > > +			/* Completions are ordered, so this descriptor cannot
> > > +			 * be completed safely. Wedge the ring to expose the
> > > +			 * application error instead.
> > > +			 */
> > >  			priv->xstats.max_sdu_txq_drop[queue]++;
> > >  			continue;
> > 
> > Hmm. I read the discussion on v2. Maybe we could cancel cq entry here in
> > this branch? Also it feels like something achievable at bind time when
> > taprio is configured and vice versa?
> > 
> > Otherwise we over-commit cq entries.
> 
> What do you want to achieve with the cancel here? IIUC it will make it look
> as if some (if the user has posted many) tx descriptor has not been consumed
> by the kernel?

Oof. My bad. I meant completely different thing :D

Right now the semantics are that we post invalid/dropped addrs to cq (the
rationale was that dropped descs are gone and unreachable which might
eventually lead to dying traffic).

We should submit xdp_desc's addr to cq.

Regarding the comment included in code I must disagree. CQ entries no
longer imply that 'this particular descriptor has been successfully sent
by HW'.

> 
> I do agree that a better idea is to probably do these checks during control
> paths, but it's a bit more involved (and not sure if it's possible? if we
> have a bunch of xsk sockets and we change that max_sdu, do we go over all
> sockets on the system somehow?). My main motivation with this patch was
> to make our LLM reviewers less chatty about preexisting issues.

I hear you, however I feel like we do not know this driver too much and
probably we don't have a HW to test out such changes, so maybe let us try
to fix existing behavior?
