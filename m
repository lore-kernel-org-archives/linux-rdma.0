Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795462153;
	b=kxOVizZ8Ee5LExU1nruFZugy3y0otGXVHPi8jtX3DZZO5b0SwSbnl50AZRZgFt9C//04
	 m4FRVzQP0oDsAbFYmaTFOzjKx4+o3EtV2QJ9wdvG6vpKzUPq8ElSKet33gRSgM71COJXH
	 voAnWigo5FY7HpqSvEzFFJcmSo10CDiNIHeCqy5VeuENu3e/TbHqq4IkZ7tW4sjmdz/gM
	 bHXeB0kCmXhmAIHUCdkEysEUaxtwr/XePwwnTGRfmkYN95CAd04sYqdxn1IKl0bHuHraG
	 hDPsYSjz4DGFEm4rToVw+FNPRmpROJBgzWWXaDDBEnW7ohAg77gSuiQ/yUyBnLH/ZSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795462153;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=uZ0k6beVZQu218nmFTQMMlvzZ30cdV2uRd57GEvg+5A=;
	b=gDj50cZ9Mo6y8ZE1kDJFwvO60qL3ESusMuyeHpxJ+aPIMjfOigvOuhUyghv6QMGmt7Ed
	 GfNDxh4xzScqEQhKDBi/HtJXjk3Vmow1INV2rbqNPGKGl6LWXK89rhwAXD19VS1c6/oeb
	 +U+U5J1soa1pzTtMrq6ZbG/wSMbU9uKpJGefxm/RcdtZoPD1wlSTLDSn4cISRROdVwNl+
	 eOJ/bkzp1E4/LOV/MEM82ooVcubYA5E8l8Ada8IwjvRBTPI+hzZcHrLbyJ8MUUdYRAIzr
	 9e8LNmC/IXUfaekDuMaFX5HKo2D5KQwxh98VN8joozZDWH2lZOrXOJVe/A2lRuBR97w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mqe3axXM;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b="jwjlE/jA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40033606A31A;
	Mon, 23 Nov 2026 19:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40033606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mqe3axXM;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=jwjlE/jA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795462153; x=1826998153;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f9SjSSjaJkRCFQQ2Olo1KyFegN/kn9cINHAJnbaucAU=;
  b=mqe3axXMox5EzQNYv/ST1BD6amvl8YZwDODlUTNZt0iGYHpMDW44AvPc
   SI2eQESzL3P4dmcWSK1In+uB8BVjuPqWl5+1pRFC6nlMTximJLy/rxUuW
   Av47ejSZ4qjCI77ZNZu781PZlP0DcXxwL4K7/ooLP2IZHFQdEdtjIMmla
   qtEuNNUlt/1C1CzNmhymL4Z+daEGg1f3e1nQDxqO0d1nB2xiIkj6qnW+b
   x1FccYwUsfisv6ItPFUoCPWf4H6LYYVu90j8lcqxgz9mrIclBf8mHyeKZ
   sgSNSCv5CLaOJ74M7xcG/W+uhW7di/dVQpxNkWGaTWPiuolcUGwDYShB/
   g==;
X-CSE-ConnectionGUID: Hi6sqpzCRNK+i0V/nRhJXg==
X-CSE-MsgGUID: RkNQdAozS6GG7b8EU1SkKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4193949"
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="4193949"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 11:29:13 -0800
X-CSE-ConnectionGUID: arPWtJMzQIGRqftgzE33wQ==
X-CSE-MsgGUID: FPucJXzwSrW2E/rh1JOlFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="13071795"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 11:29:12 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 23 Nov 2026 11:29:11 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Mon, 23 Nov 2026 11:29:11 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.7) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 11:29:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZSIQruSfZs+uyuCXUIkGumwDtiYkpKV4cxyR2JtK+ie75ZNRUevNueRN1AgEknc7PbdOsjD5/Lr1icZgmWffW1KmOgLxGbQyKzTDq7UKCL2mJlP6cfq4fTLPUdp8yfyoCik4Qyr6Oz7EuXsDCBk+GJqacmq1Vcfq1E5C1UvqkT8qGsADFPR3IKhxE/CfFxfU1g9NQffX+8Z11MoxkzsID2ncpXqJt5AeIHY/dDIokPu66LeOtzhz9PB3krXgOd9UUan2ANEDa95pDcrehejEN17wouu09LfHxH0sQnE13thdPlWrGBMtmv4DJI7/QDh4SVeljKH0pmgfMTJ756ZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZ0k6beVZQu218nmFTQMMlvzZ30cdV2uRd57GEvg+5A=;
 b=NkcPs+hIvXgntesqqaoE6a6hgqa8os3JOddrVHWR2K4/9pV/xgtzRstL4372PuWv1+nkIQ6pvFK1Wzox8q3D6ev3KBNSXhN2fthi87wBcpz6YukMqACEf4XFR336vDnjP5iT8gLm01q58DKVMKnqO5UE04issWI763w4BwGD8WTV7w7RZq+HZnCJdRzKXw+w/A+HoyNHP8IprC4L5Lf8ir6TXguQ++uAjMxaRBMr1D1nMznaZBGXvIDzxLiAT8vBytkaceis5dSU/KpUxD7T18hK9scBXX082bF+p1kNepE8i8H43OQqR/4TRPX8G/+B9aLH1nBSQDnnV7ehNVZ7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ0k6beVZQu218nmFTQMMlvzZ30cdV2uRd57GEvg+5A=;
 b=jwjlE/jAcVSI60ZZ9OlJkRC6O1xi/UEkzKcvCB2iFSh76wNjq9tTWkm8kWO0HP5MUQKc+gqINhc9CmPgmLbdNa5jYiF1NiHmLgr+Wlxd5gyndGrIszuJg6BEYnzk6TVmGvNW3Fq5IyP3hEWsoFmGdCrUa+khN1GO8j5BH/OwXTw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8451.namprd11.prod.outlook.com (2603:10b6:a03:56e::20)
 by SA2PR11MB5081.namprd11.prod.outlook.com (2603:10b6:806:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Mon, 23 Nov
 2026 19:29:08 +0000
Received: from SJ2PR11MB8451.namprd11.prod.outlook.com
 ([fe80::7d5f:b2ba:92d4:5f3c]) by SJ2PR11MB8451.namprd11.prod.outlook.com
 ([fe80::7d5f:b2ba:92d4:5f3c%4]) with mapi id 15.21.0639.011; Mon, 23 Nov 2026
 19:29:08 +0000
Message-ID: <7717b2d7-b72e-40ff-82ad-54d0fbd8c36e@intel.com>
Date: Mon, 23 Nov 2026 11:29:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] driver core: auxiliary bus: Fix IRQ sysfs directory
 cleanup
To: Tariq Toukan <tariqt@nvidia.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
	"Danilo Krummrich" <dakr@kernel.org>, Johan Hovold <johan@kernel.org>
CC: <driver-core@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Amir Tzin
	<amirtz@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>, Przemek Kitszel
	<przemyslaw.kitszel@intel.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>
References: <20261112081319.3466442-1-tariqt@nvidia.com>
From: Jacob Keller <jacob.e.keller@intel.com>
Content-Language: en-US
In-Reply-To: <20261112081319.3466442-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To SJ2PR11MB8451.namprd11.prod.outlook.com
 (2603:10b6:a03:56e::20)
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8451:EE_|SA2PR11MB5081:EE_
X-MS-Office365-Filtering-Correlation-Id: 53477da5-d482-41c2-4416-08df49980b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|261102123227099003|261026140227099003|261022105027099003|261028144727099003|261021121427099003|261021123027099003|10067099003|11063799006|56012099006|260925021911599003|260925022911599003|260925021311599003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: iDjCGIvPPUGUT98Dn6VGQ6A3KEHb2r1hQveomoepk3FZzuZOwpvAXGv+CZafWCVhF0sONQq5G4G+9JfV2XG5ilU1uCGU7/vVecuk9tGkbhFTiYvepid3tY4C6ETf+IG70SU/RZqTHsA3TjVgLrj+Pq1D8WAQDFVsN2/kFOWLfBZ3tCCLVH6w/Gd9lRtFfeD7lWAg6Tf81pQgzqPpe48dFnY+B9eF8hguWlm7m+AgbOc9atqG35VbsZP9u7NcwPZjIoPsMm0E9N614iljXqU4S7sNXvz927KxRHIceQSCEChVX5zpztXstR4HhxEnkL/Zo4aMBCW4+PVI7bUM9Onl7m4u62FZ/yVW7wQtdNBxahFBSCOPYGnYX00tcfiHtwS+CYsW6OWKBlTE7uusoKlEnhXnxhj9+W2iYv3ByxKZ8efDDo5cibtWDa3LAf0iWosv411MEkDrpPiD4uJ2aD+22x80sB6PaI8JxjSFjmP2RDwTKyeSseze5eW1CkJ/13v+fvyfOzC2xo6VB2g8wbxYX0aY2iE+Fsh5lwIScvcOXSTjcJrfSRlAa/WP7oGWwZwKpHwd5SbY1K55iDz6bStq45nY7O1L6MyvsJtQ1jfQBSn+rOeAqsJRtSZESldQVvf6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(261102123227099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021121427099003)(261021123027099003)(10067099003)(11063799006)(56012099006)(260925021911599003)(260925022911599003)(260925021311599003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VGNUUFFMOXRMQ2RzRGcrRXVTd0RlanhJSHBBemU4UC9qaXVzakUvckxKclZn?=
 =?utf-8?B?RGt1bWhTUnhUVjgvUTUxZ2paZ0twRkFidWVHNlRuTFRCdkJUczNRaHYzc0M0?=
 =?utf-8?B?ZHA5VkxFYjg3bHZGbXpycnVCckdPLzBKbUNnVkg0SEYybzRqNncrRHV5bWNl?=
 =?utf-8?B?RUlHRjN6bnAzbStTcEhGUDBTTmZTeW1oNVZsY1dYYnI4S05wQ0pWMVV2N2RM?=
 =?utf-8?B?RUNrZU5pWTJnOU81MGpyNWVCK3A3ckZUVDlwblZDQ1RWMVpjMmxHUFRIWDB6?=
 =?utf-8?B?L2ZCU1FNenlvV01EYnZLMEVxOFhac3N6Mzc2cW14TTkrUnFoZTlqRHo3dzJT?=
 =?utf-8?B?SnRiTGhOemZKR3k2MXNHYVpxcGxNK3V1MFlYMXFaUVNVa3NHQjQ1ZEhLL0RK?=
 =?utf-8?B?eTltazB2NG5uU1VzYnVrODFiS0ZMSU1GWW9NdHBIcXZ3WmpqSVQzWTU4bVlh?=
 =?utf-8?B?c2xPTzlyaXZkSjIvRVF5TUlubVIyejlsdnJ4MWxVYUxMWThEejduOWdHNk5T?=
 =?utf-8?B?NFRzRWpHdHAwckpSV1pvZ1VaRi9DTG9VY2doKzhkWkFmU2tERHVVbjI4VHNL?=
 =?utf-8?B?ZldRZ2RvU2dESVV5VDB5amQ4RmVoY3plSWQwOXNqSFlsMmhJMmN5NXB3ZzZC?=
 =?utf-8?B?YmZBampBVXhjTm5yYVdKdHNCenkrNGZKOWs4Mk9jMFJmZnErRUd6RGVaekRX?=
 =?utf-8?B?enVtOUhXb29iNmxGQXhiOVlIbFl1YkJRdjJpM01ka3V2akY4OTFsY1VEMWli?=
 =?utf-8?B?QmVvTWl3N0t0RXlDdUw1dEVPd3J1RWVESGRrbGhoMVF4b1VncUJHYUhraXNT?=
 =?utf-8?B?OHFxK0pGT0ltZUx2MzF0OHl3NUJ5UFk3TktnMXJLa2Y1ci9QV0NjbWJKMkNM?=
 =?utf-8?B?dzhCNEdQSU9RM2d5cC9WZzVFbU5MQ0NtMWdsQWNjcWgzK0xVVWcrUjVKbWhw?=
 =?utf-8?B?eC80b1hBVVRzYlpxRk1DdUg1anNDT0kwaERnbVppUkNOS2hHcXN4eHRLdlh6?=
 =?utf-8?B?QlBEMTA4QmR6TDNyYWUzMzNsRlU5TlNuNHpwcTI4VUtONXJNdjE3UTBVenIr?=
 =?utf-8?B?eS9uM2NWTkwvcndJK1YySm00TEpMTHgvYU0yRVNUQkxRVTd5anpkWjNPRDBk?=
 =?utf-8?B?V0xkemttbDBYUElXampYSmhPYXMxRi9NTUVLZDl6ajQyTURvS0NEcnFPOHl1?=
 =?utf-8?B?dXZuWkJhaURjdlNteThobWplSm9oZUhqTHB3YVY5OFdUWXRsL1ZBVHRLOGZL?=
 =?utf-8?B?a0ZzQ0c2WXl0SisyVG9mLzZKY3loOWhRS2RuQjFObloxWHFtWm5sbTVkUDVX?=
 =?utf-8?B?U1gyWndQaHFhVGpKcGxrKzJFQktxcWtEZjZkLzczellUUTBOcGVtU1VlL1FL?=
 =?utf-8?B?dUxtVllKbDFDVm9LNHJ4MlBaYUhuL2FuQlBxSkhPMDVCVUJJRjVUcGY2ck80?=
 =?utf-8?B?SFdIdDVEQU0wZys5cDMrc041WjZGajJ5SmQ5YUNIUlNLQVJkTGJSWFdrMW10?=
 =?utf-8?B?dUptY2RzWERzMFhlYStML29TdWpwdEJtTHB5TUpnWjA1ZXhCajE4OXZaRGFr?=
 =?utf-8?B?SDRiM0pMdWd3ZTN6UjU0cWk4MitnanFlV2RPckpQckdLZHAzQ1hvdi9JRVBE?=
 =?utf-8?B?SHJvZVlXcUVlOFErRVJIWGIwR0kwZVlVL1JmQnJzbis0Y0ZJZzQ0YkloeDVv?=
 =?utf-8?B?UVJEWk5KSWpoUGE1QW11TWFCTFNtc2FCUnpnNjRIMEJJT0toL0trcDlqZU54?=
 =?utf-8?B?NHBCRy82MzRMU1BaQUZBQ1pjVW5OcHVUZDd4bzExcWIyc3NNZlIyTUFpbGdU?=
 =?utf-8?B?VWRMZ2xlSTZtaUNBWG5FSzZlVmc3M3huTXllK2pnYlZOL3drTWViM3FWU3Qw?=
 =?utf-8?B?a0VhK01YRkVDdjJMejMya1VaUHoxQWlCUkxqbzFIc1RYdUNsRk1MRUFjdS9L?=
 =?utf-8?B?ZE5UZ1BWSzEyV0dwOEJnNUR6TWprcEczaWFVMHpTTTg5czBoRklpZC9MRi8w?=
 =?utf-8?B?MDQ2aWdEeEd0L3pRZW5XY1hkNjFRQzB1NGlxMjEraWpHaWxXYVQveHNROUtJ?=
 =?utf-8?B?Tjd5aG11aGN4WGhEc2dhQ2ExQlZGZ3kyYnNxOWFuY2g0aHdWT0k2VTlBUloz?=
 =?utf-8?B?a2IzcEZBSWVUcXpPV1JOTXdqanBteC8yNUpUd2lZNHk2ZUVrRmxURDcyQU4w?=
 =?utf-8?B?WjlNNmMxRFU3VmJiRndxVkxPV0o2eFhEaXRzSnN4UlZtYUV2cHBvbEtOaXl6?=
 =?utf-8?B?bUN1bkM1RzlKYi9BZ1FNVXl1Q3dxdy9vNjJkNFgrcWFNaVF4SDNOVGFaNlAz?=
 =?utf-8?B?S1BXTmo0QXZQa0QzZWNvUThFUjdhK3JLUS9JT1VLMDRXUFkwWDQvVEgvRUxo?=
 =?utf-8?Q?/+alJLb8R6kKASe4=3D?=
X-Exchange-RoutingPolicyChecked: IoC/5INqWJHr6qejJ7hdQxcf2AnWvVW2lYCXhlnLiHQwKWBryLMWwcdzUVX8w2tLrpYVrFhRHKHKjh+th2PbfAG6UFZvYC8ABnhPjeXJoibI5YInaswwsP3S4wJ3HShPHjunRWaXSnqeTgXVBcy2hZi+ymVP9qMvEo0glBXQv5C8FufO5cuhnhEVjzgs2qI+OZFKZZC5xylwqccvK+CiIoFE4SQtzgEemMYr67VIi3COF6Eh04uiKG4sAnOLNkYbTAQdgslHyxpGThGagIhBEo0Y9xO05zQlTOD7aQd7VWmUIwG5tvNNoKp0wF2K9TFoehSZIGwJc4MyQ9TZ6n+y7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 53477da5-d482-41c2-4416-08df49980b22
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 19:29:08.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOjP1HZU2kvV0x6GCpPOHZo76qQJM4O+LWF1puLxNXSMiEQ/VwxuZO1XXRwn6waqcdAxI+hYaUniFFUwPk9x1PTWTJVzJCU/7lPI0IlLB1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5081
X-OriginatorOrg: intel.com

On 11/12/2026 12:13 AM, Tariq Toukan wrote:
> From: Amir Tzin <amirtz@nvidia.com>
> 
> In case an auxiliary device with IRQs directory is unbound, the
> directory is released, but auxdev->sysfs.irq_dir_exists remains true.
> This leads to a failure recreating the directory on bind.
> 
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_irq_affinity_request:167:(pid 1939):
>    Failed to create sysfs entry for irq 56, ret = -2
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_eq_table_create:1195:(pid 1939):
>    Failed to create async EQs
> [] mlx5_core.sf mlx5_core.sf.2: mlx5_load:1362:(pid 1939):
>    Failed to create EQs
> 
> The irqs directory state is described by three pieces: the sysfs group,
> the irq_dir_exists flag and the irqs xarray. Currently, only the sysfs
> group removal is managed by the devres API, and on unbind the group is
> removed while the flag and xarray are left intact. Thus, a subsequent
> bind sees irq_dir_exists still set and skips recreating the directory.
> 
> Manage all three under a single release function passed to
> devm_add_action_or_reset(), so the whole directory state is created and
> destroyed as a unit.
> 
> Fixes: a808878308a8 ("driver core: auxiliary bus: show auxiliary device IRQs")
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Amir Tzin <amirtz@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  drivers/base/auxiliary_sysfs.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> V3:
> - New approach.
> - Retitle, and add Danilo's Suggested-by.
> - Drop Jacob's Reviewed-by, as the approach changed.
> 

This is much better since the existing behavior already relied on
devm/devres, and this avoids needing a lot of changes throughout.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> V2:
> https://lore.kernel.org/all/20260219210435.1769394-1-tariqt@nvidia.com/
> 
> V1:
> https://lore.kernel.org/all/1761200367-922346-1-git-send-email-tariqt@nvidia.com/
> 
> diff --git a/drivers/base/auxiliary_sysfs.c b/drivers/base/auxiliary_sysfs.c
> index dea7f46f7dd0..656ba057dc98 100644
> --- a/drivers/base/auxiliary_sysfs.c
> +++ b/drivers/base/auxiliary_sysfs.c
> @@ -22,21 +22,32 @@ static const struct attribute_group auxiliary_irqs_group = {
>  	.attrs = auxiliary_irq_attrs,
>  };
>  
> +static void auxiliary_irq_dir_release(void *data)
> +{
> +	struct auxiliary_device *auxdev = data;
> +
> +	xa_destroy(&auxdev->sysfs.irqs);
> +	auxdev->sysfs.irq_dir_exists = false;
> +	sysfs_remove_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
> +}
> +
>  static int auxiliary_irq_dir_prepare(struct auxiliary_device *auxdev)
>  {
> -	int ret = 0;
> +	int ret;
>  
>  	guard(mutex)(&auxdev->sysfs.lock);
>  	if (auxdev->sysfs.irq_dir_exists)
>  		return 0;
>  
> -	ret = devm_device_add_group(&auxdev->dev, &auxiliary_irqs_group);
> +	ret = sysfs_create_group(&auxdev->dev.kobj, &auxiliary_irqs_group);
>  	if (ret)
>  		return ret;
>  
>  	auxdev->sysfs.irq_dir_exists = true;
>  	xa_init(&auxdev->sysfs.irqs);
> -	return 0;
> +
> +	return devm_add_action_or_reset(&auxdev->dev,
> +					auxiliary_irq_dir_release, auxdev);
>  }
>  
>  /**
> 
> base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4

