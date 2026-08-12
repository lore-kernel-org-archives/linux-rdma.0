Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CBB4302FC;
	Wed, 12 Aug 2026 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786532981; cv=fail; b=lqfnRcclIzj2AA+YGrZkj1vfuAUhiQ6C9FUCdY6Sxj9jZzD99z5nSBBj+qqKM7m/c5vOyXdRlikZYTqxwWy1l6CKcTxqbizatVT39lUzTMrc1GwKCZ0SYD8g34XziD00kXekebjMz3Ty2rkLvEhcv08pnyxNvW92et9LQmq9VTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786532981; c=relaxed/simple;
	bh=GknXaxEPK8OkF5mDn5w7AvId6lxMiOZQVUxp1r7x2M4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VddsHyEEL4QJyQ2GGskkaP7l02UnbhaOaCp3SW8pFeupyayIzn0r0LXkhPomKJcea1ZycLfiwYlhSNJm+oRVnxhKhKyUo79Qdx4tyVIa/PuHoez39AZVvHuciwbd+8FFxI3LGgsm3/y8jB0g4GUz72zg397JFsy5dsksw1mOsg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hCWRHZHp; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hCWRHZHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786532979; x=1818068979;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GknXaxEPK8OkF5mDn5w7AvId6lxMiOZQVUxp1r7x2M4=;
  b=hCWRHZHpEA5R/sUSxyHTKZa10rkqdUll08Dpq6wO2W6LCTSz0BRaMtd4
   fz7UNFPcaqyejcDnV8b5xdnokO1a12Ez6w9PK3z2OU4V/fuxwZ8EQ7JwF
   Mr41yb2XHXmJ+MfB9p8oHmhOcOfai+pu23PZkHOCi1ZjDRTg+qEGf3Kfk
   VrsZRnyUi4uWPnL8KAJnPKedUcQZnRDMqIDXZj6fh4MWxQCHzJMGHBuYK
   qyCfx0iQpmUvkpNIeG3SER+QmfqJw27ZSfSbN6xZNffhncrrknnSSURtO
   PwXd4PDfSJfG8BK+crTKsPL0FDxQYt5IKJaVMWaOiYk9YX0CQ+47IesQ+
   w==;
X-CSE-ConnectionGUID: 9tN/RalbQPOkK2pe8tbx2A==
X-CSE-MsgGUID: Bxnpqd3vSnGMs6cM2D/5lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="86041703"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="86041703"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 04:09:38 -0700
X-CSE-ConnectionGUID: kr4r+r+/QvO0oT4GGKU1eQ==
X-CSE-MsgGUID: 7tjjTq+zR16S2ui0jzgd2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="261864585"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 04:09:37 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 04:09:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 12 Aug 2026 04:09:36 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.11) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 04:09:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfEftQwDMR2xksue7q63+D3pE2D9at/V1hCn4ILQPoNDgL06Wz+qK3lDHyG07lknykln5nzfKO+4wijLmq5fDrgcuyzgYzPLdt0c25Sn4OccsA+bHoH3lUaNp8aCgQwu1nkJ7AOlMHwLtvrg3rHWlkIj4vov06Edpu+z5tEra9s/GWQKDnzBv3yjBRENuCWEh4UBBY8Tiw9ea8K4lDPfUqvFxBJJ5J7Yp2QrEUyIudURObj48jS3dJ06lZfcBrAX6+Jujcy8+ppaij6kLGn7Wnka4Nlv7aHr/YlRt5mlIZmAZscx8+TOZLYT9uHR1AIfEENvD95Pkdw+b8nIhsM7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxMTD8BveI72rto9kYAEnn2Cy3pCgHVtC/tm+w+kQHM=;
 b=MrNsBxxP4k7kHu2sSIDF9HK7xw4uTc7rWXqIJp1gVDCRF/0rPR8mPkaBMd68TiApdSuJjvLExnD3mwVX0mlG7Z5PlM6ScaDcqtH8+fsYMIC2N1n2FLtiMrfUStwrA+gWQAAO1l7CMA9DsdmmY0oqr4mLa0C9SyGQwjf/a45Z9zCVe7HSOMpb9jIJRS0RoR7Mz4QZ61nbTqrtyFEvMSBlr1xJk2gOeWNifSHd10Kl7CJM1vy7krnkUEEaRv/HPXkgY/S0Y1oCYOr3A0kha4lyXjAC2Xr9tivx8FaioMZTiNonPSm2g1byKv8AdAk7hiK8vE3gfPyrgBA+AXcNZbU5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by DS4PPF93A1BBECD.namprd11.prod.outlook.com (2603:10b6:f:fc02::3c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 11:09:32 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 11:09:32 +0000
Message-ID: <4ef38557-8181-463b-a19c-1447d6ae10ab@intel.com>
Date: Wed, 12 Aug 2026 13:05:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
To: Stanislav Fomichev <sdf.kernel@gmail.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <anthony.l.nguyen@intel.com>,
	<przemyslaw.kitszel@intel.com>, <andrew+netdev@lunn.ch>, <saeedm@nvidia.com>,
	<tariqt@nvidia.com>, <mbloch@nvidia.com>, <maxime.chevallier@bootlin.com>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
	<horms@kernel.org>, <magnus.karlsson@intel.com>,
	<maciej.fijalkowski@intel.com>, <sdf@fomichev.me>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<alice.kernel@fastmail.im>, <dtatulea@nvidia.com>, <witu@nvidia.com>,
	<martin.lau@kernel.org>, <yoong.siang.song@intel.com>,
	<rohan.g.thomas@intel.com>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-stm32@st-md-mailman.stormreply.com>,
	<linux-arm-kernel@lists.infradead.org>, <bpf@vger.kernel.org>,
	<leon@kernel.org>
References: <20260810184753.135756-1-sdf@fomichev.me>
 <20260810184753.135756-3-sdf@fomichev.me>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20260810184753.135756-3-sdf@fomichev.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0224.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::19) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|DS4PPF93A1BBECD:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2cc319-81ee-48fe-7f86-08def8622f23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: l6gIjv2e4kdjmX5KGkjP4KwdKy9M0wiHhoKkz2cFmbx2rwjf5wvL293lx9TGRodrb93LGM+87Y40xNmWFK7vJfQiXsRxjZUsx0f/ezYUHWObM+owbSyLdPkby33/+PDA9NNtraE1oWoBmdzr5kslM5ViFBBHxK6h9wOzf1LjX6aW06oc0A1IgWonahSn4M5HCx7E3JrP16I/nFdhac0KAUimJvvnjWdeCDuc0IZAOoLb93idb2SyOEIvxUOid30YNxmB3J17QiydreGeZAbCqMxHuo1GKeSTHkLp5dsjpdqeBdcnTAlMjfdx7cBuWa2tSHcRx0P45f/Z356Z2UotjVPjVAHfJZNPZGFNfNdiTzecG+X1soRY9CX+T1hJcobJDhDJsuNwCnOf9+Ha1ifV4WMjWGZH6r7wESxkPcswOUfVkI8eDHEqpRlYYOY/q05F5UVKXmoEbjUaUOVt7Y1Tc0bWTA7OuDzEIcdVVlPhatM6piSmYYLKD30MB3+hWcLVI4e5VGitgUai/rDm9BZ6/C3auFZmswH5Ofw/tWawVx/Zbzy3Bo6Q6WZNOtD6h5STXp1WIu45efY+trqNXGB8Kn1Dspfs9eztyH7I9hykXWbCHk69tfTg1rYIuuJyqVvHSOzorOsn6fUAjWgV6ptj5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L01ZeWM3bFF2MWRnV3dPSVBsSm9HaEVUOXltZ3B4TWZ4WUhLVVF6TnFZRTIz?=
 =?utf-8?B?bFU1eDZRZWVjZXBtQ0FWbVpZcEpzeDU3Y21RZ0diNi9MS1hRck9mQjhQZTBO?=
 =?utf-8?B?ZGJMMk1xaFQrb3QzWUpGZHh6c0gyZGFoQTZqL1l3WUFqZ1dZNUE5TDhFdm4v?=
 =?utf-8?B?UU5GOWtGYlc0ZXJCbkJOQmZDTlg5ZnhBTTZWTWh0QWZ5L1Zwb1YvbUo4NG4v?=
 =?utf-8?B?WFVVU1dIWGNvRGxGOUVaalRheUdaR2NqUEJ3WUsvY01iTG9sRS9ZaGQ3SU1p?=
 =?utf-8?B?R1ZTTDBVNHJFdlF3M2JZMGlTT2dzdC84VlRpL3ZUZWhROTE0ZjhxT0J3RFU2?=
 =?utf-8?B?cytFMVdOWEZCMnQ2dlppOWZTYllkTkpvSEtLY0cxeFF0TVRJekZvRUJUNFBX?=
 =?utf-8?B?RHNkbE16Vi9uQkhsQkNlNDhlSWduVEJUOCtuNkxPbzI3Sk56a1ZyZ2g1MXZF?=
 =?utf-8?B?Vk80S0E5VVhFNkZBdjk2dDQvdkd4dzlGS3FnQmJmSjFucG5RSXdWS0ZjSWhW?=
 =?utf-8?B?NWxuTThRc0x5MmJhTUlHb3U3L3Nldmw5YW9zZVd0NVp5ZjRpbjFnYnNMMVRG?=
 =?utf-8?B?U2pxMmxwdXpMOGlXRHdjSG45SnVxWGJCMkxjcVdJNFdSMWxTeHlYSFhkazMy?=
 =?utf-8?B?aXZmWkkxRm1JWm1YQ0RQODNOTEtLWmFRWCtrVUgrblNTSUF2M2pkRnpXU3Qr?=
 =?utf-8?B?dmNEMFJkcFl6WTFoTHdoN1pEM0pwYlFJdHA0M3o3KzE5OHdUZWhzSVVvOUM4?=
 =?utf-8?B?Y3c5QW9qL2VzaE1OZVZTc3QvT0VuaHZoK2pWMzVzVGlFLzI1Yk4xb2hYazVT?=
 =?utf-8?B?MFdaVEsvS2lTYkl4VDllNDUwenl4dHQ4dE1RUmVMNi90Q2oySm40VGdQRFQ0?=
 =?utf-8?B?WEo0aDAvczREU1p2d3ZWaXNnYUJGNlpqem81d3JzMnQ2WlNKRUhZRjlLc3Bk?=
 =?utf-8?B?Zi9GTGhmNkJqVFVPeWwzWUFRQWpiOVBvazUzaTlNZG9welhCaGUyYzJKd1ho?=
 =?utf-8?B?N2xoYVpNTHdnMnVWTE14b0xERjEvNWpyMkNuaEpwSkhGMU9iem0raVByTlBa?=
 =?utf-8?B?eElyKzlYWm11cGppbnY5eUtuRWNHNTRvajRIcFFCMUVIU1p3NkQ3R0tPQ2dH?=
 =?utf-8?B?bWN6c1VUNTVacnQvUVd4Y0FUNjRnYTd0WU9oRzVkSWsxcUdVWnBxbjBjVmds?=
 =?utf-8?B?bGk2bTJkL1JObjNQUHlrZHg0dlVvcyt6NTV4bEtxQUR2Y29GcmJMVnJZejlQ?=
 =?utf-8?B?bDBZQ2lWUVhaVndnRjE5RG5zVnBER1YybTFncjN4Vjg5SDhzK2tKSWJWQXZa?=
 =?utf-8?B?emFid05iTVdmT0Q2RUNiODVKVFBoYTViYldiWTZoYmpFSkE4UDA2alV6K0E2?=
 =?utf-8?B?UG83M2hKVlZjd2FVN3RXMzlXWURpbkhlYTdQR3FiNkdOWGlwVk5xRWRrbzMz?=
 =?utf-8?B?UHZBM0FaOGRWSkxNbW15a1MwSGRyOXlkcEZ2dHVQRVBLSi9CV2kwQk92OEZZ?=
 =?utf-8?B?S2NnMWFsNkRCUVFVSlhJYkVJN1pLVHFHZ1BmVHBXU2l0aGRpZHE4QkJJNms0?=
 =?utf-8?B?VkNPYnJSWjMyL2E3dkZqdFYzT1JUUmdiNStxYjdtYWk4OTJyc1ZHSnB0eEdW?=
 =?utf-8?B?SjFrR2g1WXcyTjl3MWNFOExtREljeWJST005ZE8rMjZJdlJGVWNZN1lxalg2?=
 =?utf-8?B?ZG5haThZQlN4OFhZRjA4YmliZVpOY0c5QmwwYi9YcmhUSlBod2FKUU4xRnQz?=
 =?utf-8?B?VTZLeFhuVTkzbmlFbWtqdENFWkpkUjhDemVQTGcyY0JXL2QybFpyUVpkNi9q?=
 =?utf-8?B?ckxObkltMERhU0VEL1krRUliNFNiSjI5K2I0SVRRTzlJRXcxSVVFUzh3bjRV?=
 =?utf-8?B?ejFkQzE0Z0dUZWx4U0FwRlNzRnJwcnFGU1NHRXc0YS80bC9DbHBqQkxvY1VN?=
 =?utf-8?B?a2l5UWVDNUpLeHFrK05QRGs5SGVJTnE1TnlOUldHNVpSdGova1BPMiswZDNq?=
 =?utf-8?B?YzBpR01WVmhFc2hlVm5FWC9kOTNZYWhSek9aYklkcUVxTU9SZklxZjlIdnhu?=
 =?utf-8?B?OEFJenQvWSs3TCtaeGhNYUlodGxDcDBXVUxuTjhabUZISk1Mc3JxUTdIeGVq?=
 =?utf-8?B?U0d6Z2pCaUFkRU96R3pLN2tqeGNzQkVvU1ZTNXNjRVRBKzlXM1BRN3EvWUIy?=
 =?utf-8?B?ZC9oRVRpaXVHcnVkM292eGQwVEsva3ZZekN6eTNJcnZtdUNwVTgrdDJSYzgv?=
 =?utf-8?B?RVdMREx0NFo4b2VYb2FJcS9uNWJkZGRhTVFkRTloYlovQ3dCMVNqdXU1cksx?=
 =?utf-8?B?bW9KaUl1N3E4ME5BNmsyMEZTZjc4RVNxSWtYUjNrOGFXSjkvZFdyWUdsbmQ5?=
 =?utf-8?Q?XHqdye24J/6rBy+g=3D?=
X-Exchange-RoutingPolicyChecked: kwErCMsccs3dECfZ7o6DmNMn7xSvM4FUB2G9QSul4T386EPKQsLWTvnCUwxg6o3oMI14Ub9uRBDQzTMxKcI/2JJP23Uy1WQalFim7SureKxASO0OQnY8bD57fbiDNaqXJAHvVrEGcoZ/zfUJY43IOq/NUqOsRKS1as9pt3YEV9IIlu5olABGYvLnWU+oqn2uxKObMwwqn/B4R33CA7SA4/BEB9I6K98qp1hA6X0Nr2hcbMqFh4sE16Ce7iYqyUyz6ACLe/9aituKnJcEBTbk5gKIjEN1y8YyP4WvUDgR4svUt8JMoQL9KKOAFj7Z3oZTyHaa8+0nCVi+lvOAFgRBZg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2cc319-81ee-48fe-7f86-08def8622f23
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 11:09:31.8000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: musezl18UM0zWpVIf/H+ktMR0YglL7YG73sCEIOTXT73ENT9tkE1oOhZ7b4LpvoXdtqcelb7B1/TqmK4zy9mr2echZzqiOSYDDTq0ysMpWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF93A1BBECD
X-OriginatorOrg: intel.com

From: Stanislav Fomichev <sdf.kernel@gmail.com>
Date: Mon, 10 Aug 2026 11:47:52 -0700

> The zero-copy path reads TX metadata whenever the UMEM has metadata space,
> even if the descriptor does not set XDP_TX_METADATA. Pass descriptor
> options through the metadata helpers and ignore metadata unless the option
> is set.
> 
> This does not change the existing per-WQE metadata handling for mlx5
> MPWQEs, where the descriptor that starts a session configures offload state
> shared by the batch. Supporting mixed metadata states within one MPWQE
> requires a separate fix.
> 
> Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

Reviwed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Thanks,
Olek
