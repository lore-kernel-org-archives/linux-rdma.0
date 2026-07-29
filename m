Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EEE1DDC07;
	Wed, 29 Jul 2026 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318002; cv=fail; b=ZqHTn2ap8++EbEBr2ujMHSL43OX+Is6lG8esuGOyKvAWOogAMdXJwKNX69bo3HOI/MDUj3Hh0G+P64H275m5b1PmIkcETl8MBoUH2Zk6FZrRvbiA00rSBn2rLIwUgApHsD8OSHZoYEIeMeF4OkBi7iY/d74TEjN/mN1CYj6+Gjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318002; c=relaxed/simple;
	bh=BvPhVEx0mFUD+Te3nvqyyLxZn6wsO0rO+5vWMSPB4sk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u5K5OSw7VW0AdxWe+Y0HUexJqj7r6oqq4LIbuqGe/HNEfkATSj7dPeo8Z6Y8rLFj7zaMQ06PIWv4ONgoPFV1byZzXIoYhx3sN6J4r+3xWWnJBYwUyyvcpqKCYOvUNC/LZeuJn6oFfutb5Bqr5r0/N8vVmuDvaKy7ZqpxJrAxmY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HS0DaU4A; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HS0DaU4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785318001; x=1816854001;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BvPhVEx0mFUD+Te3nvqyyLxZn6wsO0rO+5vWMSPB4sk=;
  b=HS0DaU4AeiA6e4K8sV+fFslaIY5pRFWFluRxarZ0YqS3739vFKaqXtfM
   EMrPTnML8fm6hBox+RWX7jI62f/DsV9U3mG0fZ0/c+d5U52SEDY04esCN
   OLRXmEifnpNGTr3BsTwB2svd5WBV6m82n7IrBOZB9Zgk++Qp/3STGB8xl
   72JOTbtb7Te8BTCUZ+t0o1ET1m+Tm9Ntacj1nEtQVUr0ZXcNZmtb84rw5
   hCgU504dQIou2mFDRHaHkqfeiBySzsldsUzQOoJlcRrdaq+h02Bci80bW
   mql9rflEKx+bQA/kwtUOPRKJso1A6jQd6tCrpgMBnhUBv0m6LDRvluG3s
   Q==;
X-CSE-ConnectionGUID: SoouDVTISzS50pihDuLa9w==
X-CSE-MsgGUID: 09pdQE7qRP+RT6IiZiq4fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="96503569"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="96503569"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 02:39:59 -0700
X-CSE-ConnectionGUID: bpQB9rrcQEapPyzaHynIkA==
X-CSE-MsgGUID: StsPL+wLRre792/j4bKhjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="261919529"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 02:39:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 02:39:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 29 Jul 2026 02:39:59 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 02:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffaXgFKKdQPGSDI5GafVzbE0cmx2fV73MnXqYQ8gB44EuBV8Un+0oLYyaysdxLLa3BumDC/uVEF5DZ2Y2HBsGXwwT9dkPnJtQHIUDvPbquAzNaCMX11LssXwdqEoK2ujdY9v4PwoJDE//nN6qLfW3GrpV4yLPa+KnltxXz1oQ3H3LlUrJqRvupTzNJfDeLax/F0hBHHDEaaGkHijIyp1izvaDwDBtTJgRPTxZ37dgswLn5JVwHJShhmZHpVgs4l+YxyAMEnh/IEAnebhoJvji3GXpVMlo7AXkhDr/ar2tFAeDFA7xN2mF0XOfSJLvvqdc6nzNFHcB+j5l6xsnxm/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+T7Dh8wxtclVtc8wNRLSkb99WORRhJjE0G1UNSidtY=;
 b=KS3JFANBA++HMAhC9YttIjqI9TcClvmVK/+QF2lJo+SenVgHrD/8faLuKuIUp9GKpnWpydFCUoPadIVtCzRk2knEFzKNWPWfMupwfCWH1V0xhcVpx+FuwgmqRHd2fCKLGdPKMrjM13hsFkLkgFxqD4EEnvb/uY9tIQ6aU7QkFUmbSaIvt7AJ/J4PBKD4Oj/BsKOpzl2hN9umpUzuP9F60HpiUraZAawQPdX8ZRlGipqQCJseUYm7sV5zlEKZPXWj5UcQIS9eGjTotrzoXtM1q3ASwZDYQxwC/fkWH/qQmNq1UApuhJC55DgJJMeuI7xCQ2fOFJx37VrtyUx9dmlgqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5014.namprd11.prod.outlook.com (2603:10b6:510:31::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 09:39:44 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::d9b3:e942:2686:3cdd%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 09:39:44 +0000
Date: Wed, 29 Jul 2026 11:39:34 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <anthony.l.nguyen@intel.com>,
	<przemyslaw.kitszel@intel.com>, <andrew+netdev@lunn.ch>, <saeedm@nvidia.com>,
	<tariqt@nvidia.com>, <mbloch@nvidia.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<sdf@fomichev.me>, <maxime.chevallier@bootlin.com>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<aleksander.lobakin@intel.com>, <horms@kernel.org>,
	<magnus.karlsson@intel.com>, <witu@nvidia.com>, <alice.kernel@fastmail.im>,
	<dtatulea@nvidia.com>, <yoong.siang.song@intel.com>, <martin.lau@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <leon@kernel.org>,
	<AutonomousCodeSecurity@microsoft.com>, "Cen Zhang (Microsoft)"
	<blbllhy@gmail.com>
Subject: Re: [PATCH net 0/6] xsk: harden TX metadata validation against races
Message-ID: <amnKVlHTITILY8H8@boxer>
References: <20260727161959.885642-1-sdf@fomichev.me>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260727161959.885642-1-sdf@fomichev.me>
X-ClientProxiedBy: DUZPR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8b8649-0ad1-47cc-3153-08deed555241
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|11063799006|5023799004|10067099003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: bI8aaNyS2HknuvlkGjLCMdFDJH3yy7fNaIJ8EWOW8kOq47LEwvphT/HRG4mK0sO8K+/SstQJ00x/a1hzTGT0p41Vgq7dDodr/y9OeA+lRPB9VVM4+IWJqCdcLtb+1hX42f38O6DvsIBvc3nmtYHLqFy9qHWpKr5TlazBcYSwl8yMwv6UCG5cpVFPM7OpH089cyo+pWUUoO7YYW/GW+2R4i+xKT9hqQcZMhDrN3Ncc5b1wR2v7IkcIoaaCRrizM6S08ab/OXiDl3EUThRfwLbuUaUqbW/VAv0rKJCIi/vCp4jKQahpj9iMXjn49RR9A7dPIqwfPVm3FSFOcyWRLcSdScYqui4y5QjYjtuVhRj43Dpa5jjjrRKIbVBlL5vy6hvU6csHVda8CBneEYNj+7yJCOkNkwgfXaoquIguwBM+RtNFN+6CahKMooGniGgNYvLTB9P8IsP5e2ZfE04nsh0V06AI86ycwboNGN8U5KPXkuA6NGy7/gj+WNx7g7vbskWRsRJ89Yo7PmSlFoSxiDE/QJ6pCDvlSoHm6FRhn4UoSA2hx9mSOxMSovbKvJq65wHIA1OhoGfQAaH7G5WneK2K+G5SwLh5EmiyAUUhvGsnVbKcgu1AQMEHms8UnlGygACFnm137XOIocHZpoIRWOSeHov3spwH7WCdbxbgHcZQy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(11063799006)(5023799004)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?umbx1rrXT3S5tzieLzELpi+NjE77u2icGpJF+jUgbIaK+8VfxXDRLFazkL1F?=
 =?us-ascii?Q?es0dSgTRbTThldoDntjhBmT1I2BnfeiXQlveqfObnX26GAaBKeA7nqI4HMti?=
 =?us-ascii?Q?MpLbL8OmgpFRaoWy7lkDG/I4M1W80guKFkvrMU8xQSmxK1yOS/EXmm3gowrO?=
 =?us-ascii?Q?QRl4kjrKweTgXWR4+97jyJlcjUhj1EfnxTOFa6vL7xNSJe/KE5NW726VOCaN?=
 =?us-ascii?Q?Ywi4GGcBcYZthTAIDdxnXBwru1NG8Agdna0C2Xi/ZmyqpyYCwZ8k37BFucND?=
 =?us-ascii?Q?3MjLLYPIS8QwcraUMr7KtB+qrWL9OXHBZ41gW35MxJ/YsT6TZs49+EGjQI3b?=
 =?us-ascii?Q?TO13/v8mDpV1vd/NzizIU37B4pqgW/iP6jn6T57bncG1+NhabjXWVe7HnNu5?=
 =?us-ascii?Q?ka5w9UsKR6RmDncYbbYMUsCohdpGYRvTuEbWC1s7KOSdKiRwqROm+dALlf8M?=
 =?us-ascii?Q?A9JAPPLTUk5YD4t8KHLATfz4VZ0Qh1NptIJrkwJckALem9Xbr2RvP4Cph+Ml?=
 =?us-ascii?Q?TfxjIZ1VIsd29E+BFCGt8gE8+PM/riTSi+u8qm7PWmjMAkiHAL/LNOm4g9JD?=
 =?us-ascii?Q?XaGArJhquO5mKPfPb7uGuF594D8zgMUNfBK2iFC99fiqQWTjuT3gyHwcOgzm?=
 =?us-ascii?Q?22VP+0RyloNfd0GkhqGNV9hXUgrHueWkfWRQXsBTa4jnsIawHNGjWtZSVWLQ?=
 =?us-ascii?Q?D41EQxpS4sj2AEG06ykIkMm64sUDrxli0AvX7vcPwwhrHA8bsTAl9RdAYZXW?=
 =?us-ascii?Q?6bPmyATYUWLMU03wHMYmUx9ByxHKwq08BPfEjvqmRmpGNMw2kt6IlxeY3wYh?=
 =?us-ascii?Q?lkRgwaMx6dxSAGbbooGlIykcWbGMo0ynfbUXbBB6QCvIlX8ZiKSBKLYQJFTU?=
 =?us-ascii?Q?6hrn55rufvF7IyvLacj551RzATtdvTNXG9KmlBz692yq48PQVuZwI4Dfc2S7?=
 =?us-ascii?Q?DTE9tNb5tnYM7g3AC4/t6hmnrw+BRx+HVy/1hj4RiA4l/nU3oiprod4uNa/7?=
 =?us-ascii?Q?zZnLPdTemAwtbQp36VtA01wUzb4ZeRMr56CwGUfLEMy4KCZjO8HnwpbSa5LD?=
 =?us-ascii?Q?QjXdOZ/4P5MTyrNO2ttkwZqGW1qoOjMXusDGLPOyChBNi76cgcXrNEkeM+fD?=
 =?us-ascii?Q?9niLXc03W00z6eMJBYbon1gLDepfPOm7n6QHYnBwI51UVBerr2caodgH+ZwN?=
 =?us-ascii?Q?Kl8WPNxYROLLnMDH9ReFVpeqZeh9IAJDQx2dSx9VxBcT3TFgpKT/W/kcRp7j?=
 =?us-ascii?Q?h6xvK5nSvRnSC6k+RlZz2SQ4XZFEFri0yXIAxQuP/55jwSraiZla1R7rtUKI?=
 =?us-ascii?Q?2oolzxeGlEDZlozjLbLCtjhAWC71Ii59jFJZREo9t1k9s66v7mDp/vJSgt16?=
 =?us-ascii?Q?y+gnyRzok/YvFEEt5+OtXTp9WUAdoFEUNvvBM72mTAr7vHtXsQ75ELkuPMOb?=
 =?us-ascii?Q?tKeQF0/zQdS8gQUpRg8mzOYS+yg/psZG7pSfPOco+RLb/pSh/E4EUKo1AoQ9?=
 =?us-ascii?Q?fo8uBWvhWwv3sDARjAjEYRoRfoxF3j2u2lKnLuoVAcr3UFrU7Ac9lF+LZFam?=
 =?us-ascii?Q?xXfUuItz7x6iA5/oc5Fte2VhfEzuU9mqoNhKr72rrLy7Qrh7nmsjChxtgjAl?=
 =?us-ascii?Q?vWU0jgequFQGykIZEE4kF37Ek3s6138JJJIQ7gQxz8oVYipcqNLnJxOOQbgs?=
 =?us-ascii?Q?4L3KC5UYXQidn95py8qmkgknYMy2NMbZ7yNweyUVYQ4BJxQSRfBWExfcu2jv?=
 =?us-ascii?Q?F+1T2f+RqFMk1y4vKvVQNET6NpjqWGQ=3D?=
X-Exchange-RoutingPolicyChecked: eEG41J4P+N2GnPPvlwxX/lh+Dln40bHSO0If5/VgFzNnskckUJJxALGYaYXrf+g4TyHgqANLeSnZLHvsgC3NXp3bxkshJmNyEeE48qOGQGAU19KHvweNiyXTdFMqYVZqMX92amb0ZDvz0e4X7cFPXMw51TvSi86N+YnUEsxL/j72bxoikJBSECtpsolVnKo165x6kWCtC3SLwceviPTSuVlyeYmL/DUIZuWjnGG7oCadtpHM9EB7aLeeLf6cx9EIJJaLUH5dCFX3dLwwCd4v4L9OjV57DYZ36f2FomcToQv+PMxSLEEsi8lpuG4Dst7nsrFZz4sb2B+Jke//vTHWBQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8b8649-0ad1-47cc-3153-08deed555241
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 09:39:44.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r98VAw1HDppREjVhInNFScpQXT7E4d4tZoLqqnnWnRHMOgQHMj/bgOnKSKMALGPoBciEz8G2EeIFT6WgSQzz0SjcZZkLrPq4cxEKLH5kZMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5014
X-OriginatorOrg: intel.com

On Mon, Jul 27, 2026 at 09:19:53AM -0700, Stanislav Fomichev wrote:
> Cen Zhang reported a KASAN out-of-bounds read when AF_XDP is configured
> with a TX metadata area smaller than struct xsk_tx_metadata. The metadata
> is also shared with user space, so reading its flags more than once can
> produce inconsistent validation and processing decisions.
> 
> Require enough space for the flags and one request field, validate the
> launch-time field against the configured metadata length, and use one
> snapshot of the flags while processing each request. Carry the validated
> decision through completion handling so later user-space changes cannot
> enable an unrequested completion timestamp.

Stan,

I'm taking week off and I see one sashiko-reported issue which is not a
pre-existing one. Hope you could clarify it and unless no one picks the
review of this set i'll get back at it next week.

>  static inline struct xsk_tx_metadata *
>  __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
>  {
>  	struct xsk_tx_metadata *meta;
> +	u64 flags;
>  
>  	if (!pool->tx_metadata_len)
>  		return NULL;
>  
>  	meta = data - pool->tx_metadata_len;
> -	if (unlikely(!xsk_buff_valid_tx_metadata(meta)))
> +	if (unlikely(!xsk_buff_valid_tx_metadata(pool, meta, &flags)))
>  		return NULL; /* no way to signal the error to the user */
>  
>  	return meta;
The snapshotted flags are validated for size compliance in
xsk_buff_valid_tx_metadata() but then discarded, returning the
un-snapshotted user memory pointer (meta) to the driver.
Later in the zero-copy driver path, xsk_tx_metadata_request() re-reads
meta->flags directly from user memory:
include/net/xdp_sock.h:xsk_tx_metadata_request() {
    ...
    if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
        ops->tmo_request_launch_time(meta->request.launch_time, priv);
    ...
}
Does this create a Time-of-Check to Time-of-Use (TOCTOU) race condition in
the zero-copy TX metadata validation where userspace can concurrently enable
launch time after the size validation?

> 
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
> Link: https://lore.kernel.org/netdev/20260720155210.34229-1-blbllhy@gmail.com/
> 
> Stanislav Fomichev (6):
>   xsk: require at least 16 bytes of TX metadata
>   xsk: pass TX metadata pointer by reference
>   xsk: clear metadata pointer when no timestamp is requested
>   xsk: validate launch-time metadata size
>   xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
>   xsk: validate metadata when processing requests
> 
>  drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 15 ++--
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  4 +-
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
>  include/net/libeth/xsk.h                      |  2 +-
>  include/net/xdp_sock.h                        | 45 ++---------
>  include/net/xdp_sock_drv.h                    | 77 ++++++++++++++++---
>  net/xdp/xdp_umem.c                            |  2 +
>  net/xdp/xsk.c                                 | 11 ++-
>  net/xdp/xsk_buff_pool.c                       |  6 +-
>  12 files changed, 101 insertions(+), 71 deletions(-)
> 
> -- 
> 2.53.0-Meta
> 
