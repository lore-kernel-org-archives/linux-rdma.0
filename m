Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5D334374;
	Tue, 21 Jul 2026 00:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594982; cv=fail; b=AVWDipBMeMLy4jti6RsHKbH/M2RBV7OJX7wSlXuqPh2n3wPZnRsNwv8hq0WY7mPvU3y4LRcFXHahHJrSbu0/8Z+gJ4xnm0JKpeA5opqltuO9alN+VIxg5KaPB97uuf2U0vyTowXmvw/CPVr7Z05jkt3FwS2k13rO21/MnStlejs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594982; c=relaxed/simple;
	bh=tYksgYYFA+Gt7Gk2T39c4Juk98I+Qp8qBiMO2EPCiz4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fZwVamZm3ekcX9JP77vsIefRq1TnEIgzfyAr8csZhAAizSbCNmd9/qmGn1rfjWYs3ILOfoMvCza57VSJetb9jkfgHg0JGscsocaRzpK6U083NfgPl14HDTB3r4fdRUx/tokrxn4cL7uQ6xZ+FenvjwMQIPC6jZE5QywPGonmCdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aoDNILsF; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aoDNILsF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784594980; x=1816130980;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tYksgYYFA+Gt7Gk2T39c4Juk98I+Qp8qBiMO2EPCiz4=;
  b=aoDNILsFKyluyAsKrCR0+/NLbvtfukKLdm9sfs8SAz9FutFOn23W61L0
   w6iA/R0mXVIcdhe5cJLJJ5atcshUojFB+eSD1jErVZ1pXd7KA/g9Y17LU
   pJYg5ZrKdcQ0ohIaEhPZPk6zOZy6h92a1NhtNu4++pNRtSew5e2qzNSp9
   y7RgY0Fj5lMiwaJg94q1nsEKL2UKgBdQKKxi0epmqAJmBNRAutD+5ALYa
   rg9bOhLnoa8KnMXmxwztlMl0pkEIyc9Xun/d6o0gsa9FmXH9C3wktKCWQ
   r2IgxYZABuOscrYcO0rR13Q0bVf4c3dFxi7H/VEGRiFPSKRLj5J+n3hbu
   g==;
X-CSE-ConnectionGUID: ETTmN56oR3KBkQBuXpDHYw==
X-CSE-MsgGUID: hE6fLEi9QK+ktkSA/GbWWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="84949441"
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="84949441"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 17:49:39 -0700
X-CSE-ConnectionGUID: bSnguvpvTWO75il3Z0XmKw==
X-CSE-MsgGUID: 40u96Sy+SZywPs0JedrhIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,175,1779174000"; 
   d="scan'208";a="259593975"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 17:49:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 17:49:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 20 Jul 2026 17:49:37 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 17:49:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKFSsvU+zx1oGwLYfEmgu0UGnvfoL8+OLpzkI9TM3oG1LIasBGF+hCe43giT1Ilj3MoqePVg4+fMTrowB7fthwqGDpmAAUbK0fq5O+2VUe23QPJ5tx3vuEkxJH3FMj4O3l89JuH0zT5dofXuEnyn5tIlYfqpC5Jf0RrjP5XYgm0FwV8r6RuEfBBQN6CthEUDL3s889/Ou4cf7h2ySuuFoatXpFoaqDnMyW0RhCVFonoSdwPP3f6JsqjhfE1ftPS31L51+QFSMGiSe+RPDR+CuNxGPZJlW9eOntZ3J84R0KNNTk0aEoDQhDtgQQSsbSt4RqH6jVKZRlohYxIaaQY2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daC85imikPVcOjZMtMbBxmF7fj/rr11mEHU77aeIBJY=;
 b=foYPBqPyuzMiJVuqGzQUyuwdkrWvlkE6TukYrKm7TPLS1iaPLOynHKLX1Wtwy6evShvxj8aWxSu6BNmHw22vsisf/Exjx8vRIVZci5ZyBx8Spo2qJTcvffowHXOgxpz079oCosmkB9//Em0Py1GKoW6dCsfR2FWECjQ7Y5ES6fRw02f0ET0QE2TDSwDVoi91EGVPdAYBUbEwOd/4LEl8hAK2PrTARuplh7GrfpMMiVRccBqHT/U+hrjuXXoY6VYZXlwIfibIRGXl6tOE6DEfjNcdmes4SRHmqKaF8D+4Z9S+ZJ0KSKszzclBz7i6tGXE3BGecNTIY+8/6BeckaMMDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by LV2PR11MB9540.namprd11.prod.outlook.com (2603:10b6:408:378::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 00:49:34 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 00:49:34 +0000
Date: Mon, 20 Jul 2026 17:49:28 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
CC: <airlied@gmail.com>, <akhilesh@ee.iitb.ac.in>,
	<akpm@linux-foundation.org>, <corbet@lwn.net>, <dakr@kernel.org>,
	<david@kernel.org>, <decui@microsoft.com>, <haiyangz@microsoft.com>,
	<jgg@ziepe.ca>, <kees@kernel.org>, <kys@microsoft.com>, <leon@kernel.org>,
	<liam@infradead.org>, <lizhi.hou@amd.com>, <ljs@kernel.org>,
	<longli@microsoft.com>, <lyude@redhat.com>,
	<maarten.lankhorst@linux.intel.com>, <mamin506@gmail.com>, <mhocko@suse.com>,
	<mripard@kernel.org>, <nouveau@lists.freedesktop.org>, <ogabbay@kernel.org>,
	<oleg@redhat.com>, <rppt@kernel.org>, <shuah@kernel.org>, <simona@ffwll.ch>,
	<skhan@linuxfoundation.org>, <surenb@google.com>, <tzimmermann@suse.de>,
	<vbabka@kernel.org>, <wei.liu@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<intel-xe@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v9 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <al7CGPdJGM+asOFK@gsse-cloud1.jf.intel.com>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
 <178413941236.1155966.14485211391150425997.stgit@skinsburskii>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <178413941236.1155966.14485211391150425997.stgit@skinsburskii>
X-ClientProxiedBy: MW4PR04CA0141.namprd04.prod.outlook.com
 (2603:10b6:303:84::26) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|LV2PR11MB9540:EE_
X-MS-Office365-Filtering-Correlation-Id: d492ba17-075e-4e6c-f4ad-08dee6c1ee26
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info: HLjIQaNtNyV0EA7Dd3dC5RmhkaZwhYlr2KdPP+RDkPgEEWAFO0japy2IbnZaA4dcRoiwG2g3vizfI5e3qlL7BS7X9+QjdD1rzOWgJrbl1AqCowUO4EVsfI2bQQ2rj2d6aQP5OOtWHVTGBkZWt4l/iTLdQPQ9R789XOxxNkHUYefUmzmIrHRMu0Wy1CEOtYKBPdKn1XPRiRV+dV5KThEibamDGiFj7LW/HoLzdexu4VLZRsX29XZScJwsGmFX0UDhmAPpgUlxtrPNQQ0sl1aAhlyl/nC+tqHDYVX1tbHTyVq8sv0oKlD8sfac+NtWpFeXPsBvyNwpTMCJL4xmI58pUxjw334y96TJ+WvBBvRcmdtWtGzZ8u+d8KPrph8JslBg5Vk2xhOsxwZQ49ApolBRta7looSHGGd23Mi5VhVrsCfzV0q9OhSp25Z0piNJMX1/V/fRw0Gf6OcPB7DModlr/wP+bae97Co/+fgTBY+pq7YNfkZHn+UXOCNdVY8GkYMr2hBbAc1DJD6Fmz+wE8qLuWp+tgXPVCFlzv0/UQLI0WnWKrCh89K8dKHc8m16sfCOMoQM17VZ6IY8hd07iIURgmXQG+VfFqh5HO61nv9MVZcOWi2fWqwyIuT8QLQ3rqCc1DHLdU36xFAdqCnBRbQU3HD5/T6JW2KJpPLtn0XWm5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ldSmYExASKXBxpEOMon1rfY7yBzIcKRb6vb13n6di0B7XARBTDu7bpDkgzdg?=
 =?us-ascii?Q?7Lin4IlLSFfiolExq9QRu/UHSWDRutfRJy6fsva3ZMCZbkLLYQKYj4iTgNEb?=
 =?us-ascii?Q?dZzMfnuOlEL5LLj2/OAQomXX16xf96CwOb4KE+hjTvjMkF39jcaRt5I9SAUt?=
 =?us-ascii?Q?3Gx9JIbAgPk9OQOb097we4tZeoUa9KN9wGh4w1V1BY4kVUECS24nyzcVo1uB?=
 =?us-ascii?Q?BwSt6gxjamQmB+q7oIhRVTYf5/UMDWsBRyQ3LRbwvGeAqhubCLE6auiE19P/?=
 =?us-ascii?Q?J1nd5ChSN/CfyAfs/LS6WgBp0tVGvJome7h6yGAPUkZfdfG+kZN0uBA2QZ+Q?=
 =?us-ascii?Q?s+WnXptjH9nvKqq2Ek2i3tb1AJH+P+BM304IvhTRQFgCMtuFOmkLiHbdlfZ3?=
 =?us-ascii?Q?9XJB4r72LGd2l4K0zBj18LJVda39sMKt606lbCj3ejanLBbee05USL03cBAU?=
 =?us-ascii?Q?PhfXIg6fGplfs/e6+gfeJHQ9vmE3v8mB7R1V1wTIGkq+qgTVVsz5gBI/xDzw?=
 =?us-ascii?Q?zErrQLrMn7REyU/Fk5G3fwUQaMJWZozQbNUG/0eb2Ze0tn5HTyThsf38nxgB?=
 =?us-ascii?Q?+XoNQnMnhWSa542vB67MMKX7fEx4ShLxRLRdhO8y4iTiOC2MrpJHQHTfvTeZ?=
 =?us-ascii?Q?c8VsSRFwjQHhsT8Vgrziz6NMAZKwnnjbe4tmy3Xx1Tb73/QmLl/QMKCCulCM?=
 =?us-ascii?Q?BCiT603szcrQ1xuUy9ByLknfpmt8Dpfk2aM6UQNmXSlluTLd9JMZFYoa0vWp?=
 =?us-ascii?Q?OvsgWK76hR/hQTvPJXmgswpklNetsY2OhgAqhDnQ99Hk7IQNyd1sSoLhUBzG?=
 =?us-ascii?Q?64tv/lmR9ThuXDTxUiLs83Qc9sH49z7vNYf1WjHdOq8S9iiSYnxFYnDh4sTB?=
 =?us-ascii?Q?5UBoq5IMUf9dQeULvB5x/1uxaDy5UIsOZAQhIWhHjVvWmFxIu+Ft/Vjlc11n?=
 =?us-ascii?Q?hxusX1fF9aGdEnQp8otuD2mTpI/BJRfNdAq2gDjruSmBVvb1Vu1PrxIeBJ7y?=
 =?us-ascii?Q?Kbfon2+HsnUYOTLOjQX61F2VuFakLq7Uho0t1uxMx4hA0u9RWn5V3XoHMysA?=
 =?us-ascii?Q?r87xWa+IFdc9FYNzzwKW4ON8UfrYKbC4nlGHrBK8s1sTvfVqhxcQUKxWtmgU?=
 =?us-ascii?Q?fuSmAXOEmgWO7zCbBidMmy2xZV7LZ2jnSShIqM8Y1QyMsl6+w1B2afsUrKMU?=
 =?us-ascii?Q?g9idO4S6NqMbwD1znhBGYEkjc43JJDfQsbBcamtZ+H/LjdYf+/QDSBh3xPFG?=
 =?us-ascii?Q?4mdP7o0LUZW/yCMi2rYiiSje6OtrSXb48nf0T6wBTTfR0OC3edCTyTFmafTU?=
 =?us-ascii?Q?MToH50124g5PJibth73E+1U7ZkjlvACw4qbFgrOacqd/aG7nDFtBEHFCOhmN?=
 =?us-ascii?Q?4t4LIlP44Zzuw2G+RTrm0URNve/fzHOnsSaQjXNXwxivP0hm0GjFtbyPIzKG?=
 =?us-ascii?Q?A9f5B8eB1mYAchw9qpAY56dVEjp4Z4ipAHIUBAzP8qW2ran6FwVkHntuPO+y?=
 =?us-ascii?Q?sdmemC6DF7zW1z0Ek76TtGek4USsX2QEpIsr9dKSzv23CI+8nhwMsXN6A+q2?=
 =?us-ascii?Q?v7epq619noLj0HjLEGFOl++IX81lMhzOzEixG3cv+hcvFtLfvI3c6SHolN3j?=
 =?us-ascii?Q?tTS9iAARbFnwR9Tqt/sKT+wJ6ZI8qsznQ59WuWsgUVifqd7fu9n+rRpYuUBU?=
 =?us-ascii?Q?6x7qnFVHGcAnoOz21zs1Et7Q6s8/QvZsHtKxHTmqXFSNrnjvsN7TOdTfwjXs?=
 =?us-ascii?Q?AsUKI7N2QnMHfpFNG+IQAh483B8slJI=3D?=
X-Exchange-RoutingPolicyChecked: Q688loU1kYHr5EE+nth0p4ViuqEZjOZcRSXb01Fdc7nXGhYxzounl+SbBOZcvZRtSDXPMdxpaJhex/VqL0Ed/zzpO8mcVpudjaCRRvPhxOq0Vo6Pc6vTPkapKU24W6v8xqiZh/X90jCok4z59ENhIaBnCh9xbdqMnIzEhGAh7lH88dPUjxcn0YIHnYuw3fPkP/K7gzbHSy8pJB7EBer/8DH6qHfT9O9Vz9z/nKrT+bpRfJyV9w0/Jp/Q3600Rk+7ixM//Am0yk/3kG69VwiZWqSOCcuIcfxvVTy0WRucfVSKW23U79JnXpbQU1xJFV+G7UlFFjjKdi5JRRJIpLuUOQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d492ba17-075e-4e6c-f4ad-08dee6c1ee26
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 00:49:33.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yHyr2VLp9Ks5o04LGTC2bAOMntoO66USJVBUWVJ1TU7KX2+9Gy4r05rMJjF4mkCQIB6nPECjU+FzYJxVT2rs/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB9540
X-OriginatorOrg: intel.com

On Wed, Jul 15, 2026 at 11:16:52AM -0700, Stanislav Kinsburskii wrote:
> Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault()
> and open-code mmu interval sequence setup before each HMM walk. They also
> retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires.
> 
> Use hmm_range_fault_unlocked_timeout() for those faults. The HMM helper now
> owns mmap_lock acquisition and refreshes range->notifier_seq for its
> internal retries, while GPU SVM keeps its existing driver-lock validation
> with mmu_interval_read_retry() after a successful fault.
> 
> Pass HMM_RANGE_DEFAULT_TIMEOUT as the helper retry budget for each HMM
> fault attempt. This scopes the timeout to repeated HMM notifier retries
> while preserving the outer retry loops that restart when the interval is
> invalidated before GPU SVM updates or consumes the mapping state.
> 

This part doesn't seem right for get_pages(), see below.

> Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> called with the mmap lock already held by its caller.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---
>  drivers/gpu/drm/drm_gpusvm.c |   61 +++++-------------------------------------
>  1 file changed, 7 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> index 958cb605aedd..de5bbfe58ee9 100644
> --- a/drivers/gpu/drm/drm_gpusvm.c
> +++ b/drivers/gpu/drm/drm_gpusvm.c
> @@ -773,8 +773,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
>  		.end = end,
>  		.dev_private_owner = dev_private_owner,
>  	};
> -	unsigned long timeout =
> -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
>  	enum drm_gpusvm_scan_result state = DRM_GPUSVM_SCAN_UNPOPULATED, new_state;
>  	unsigned long *pfns;
>  	unsigned long npages = npages_in_range(start, end);
> @@ -788,22 +787,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
>  	hmm_range.hmm_pfns = pfns;
>  
>  retry:
> -	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> -	mmap_read_lock(range->gpusvm->mm);
> -
> -	while (true) {
> -		err = hmm_range_fault(&hmm_range);
> -		if (err == -EBUSY) {
> -			if (time_after(jiffies, timeout))
> -				break;
> -
> -			hmm_range.notifier_seq =
> -				mmu_interval_read_begin(notifier);
> -			continue;
> -		}
> -		break;
> -	}
> -	mmap_read_unlock(range->gpusvm->mm);
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
>  	if (err)
>  		goto err_free;
>  
> @@ -1406,8 +1390,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
>  		.dev_private_owner = ctx->device_private_page_owner,
>  	};
>  	void *zdd;
> -	unsigned long timeout =
> -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
>  	unsigned long i, j;
>  	unsigned long npages = npages_in_range(pages_start, pages_end);
>  	unsigned long num_dma_mapped;
> @@ -1422,9 +1405,6 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
>  	struct dma_iova_state *state = &svm_pages->state;
>  
>  retry:
> -	if (time_after(jiffies, timeout))
> -		return -EBUSY;
> -

I think that by deleting the code above, you have changed this function's
semantics by removing the hard cap of HMM_RANGE_DEFAULT_TIMEOUT. This
code was added because, on some non-production platforms, the timing in
this function could cause it to livelock.

Is there any reason this was remove aside from timeout variable not
being a deadline now? You likely should add the deadline back in.

Matt

>  	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
>  	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
>  		goto set_seqno;
> @@ -1439,21 +1419,7 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
>  	}
>  
>  	hmm_range.hmm_pfns = pfns;
> -	while (true) {
> -		mmap_read_lock(mm);
> -		err = hmm_range_fault(&hmm_range);
> -		mmap_read_unlock(mm);
> -
> -		if (err == -EBUSY) {
> -			if (time_after(jiffies, timeout))
> -				break;
> -
> -			hmm_range.notifier_seq =
> -				mmu_interval_read_begin(notifier);
> -			continue;
> -		}
> -		break;
> -	}
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
>  	mmput(mm);
>  	if (err)
>  		goto err_free;
> @@ -1720,8 +1686,7 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
>  		.end = drm_gpusvm_range_end(range),
>  		.dev_private_owner = NULL,
>  	};
> -	unsigned long timeout =
> -		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
>  	unsigned long *pfns;
>  	unsigned long npages = npages_in_range(drm_gpusvm_range_start(range),
>  					       drm_gpusvm_range_end(range));
> @@ -1736,24 +1701,12 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
>  		return -ENOMEM;
>  
>  	hmm_range.hmm_pfns = pfns;
> -	while (!time_after(jiffies, timeout)) {
> -		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> -		if (time_after(jiffies, timeout)) {
> -			err = -ETIME;
> -			break;
> -		}
> -
> -		mmap_read_lock(mm);
> -		err = hmm_range_fault(&hmm_range);
> -		mmap_read_unlock(mm);
> -		if (err != -EBUSY)
> -			break;
> -	}
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
>  
>  	kvfree(pfns);
>  	mmput(mm);
>  
> -	return err;
> +	return err == -EBUSY ? -ETIME : err;
>  }
>  EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
>  
> 
> 
