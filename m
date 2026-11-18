Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=216.71.153.141
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795002817;
	b=SKjrKhVxMNlkRw8BqfrBE08TIIYwHrXdY69MQAi54V5I8cei5/ZXUVKfc/eZk5aMKWUC
	 jDhnbAC/J7UdElv0sBg/hOaiBR+7fE1MngTJyufCYY+Gd9d7Ye4A99ky7qrdbXIgyLyNi
	 Z/v92q9WjuHt9GyRZAS1Br+y9k/3+vLlk4wmYmj3KyxBz4Hwv15kv6iAFuPhmb/Jck/qk
	 h2o+nGKQnNsGL2mq4CP1tNCF9+WatuugRPMIz5xrqTVlkMagKQXKgzhnmms2uWn+ImT4w
	 TNFzNwc2z/J4rqo4G7xGtpFdnLbbf7hGaNAeC7OfYdwvnCkxZeGmCR/rm4IEuKW+eqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002817;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BohHhXvZbrZy0ztxuhYuHZxLoMO5OrBjQwu+LIwOp38=;
	b=rPu8ysqYz73pzKa2eYx9b9a9+frTsjO9YjdOjPPR8LyJi5e91na13yUJy19Z16A1AEaP
	 hHTRTuoyor7Cge6xs5k4JSewkqQyvEgl6//WJelbLL+Iln/kUF2wBEjm1A3j709ZoMvQN
	 X/Xb0It1BB7czJm5vAS3/Rg5eEpbz/l/RJ1xzLIxtQbZqbqOeNJKFrA6WV2aoMr5KQthC
	 ip4eXpYalmqvqpKEiBN5oJfI+NhKvIu7wBv5uZy81XvjbbkWxykC8UVqiXVym1kcv/n9B
	 4uwCWkrxVzBTUrkynxjUTrgFE9QHxcQCETjND/oA6na8s2z/zvKEfCl9bKT1YSajtfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=fail smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KunAjETh;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wIMBOAnF;
	arc=fail smtp.remote-ip=216.71.153.141
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF249606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF249606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=KunAjETh;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=wIMBOAnF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1795002817; x=1826538817;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=05CRe0E4J//N/LFToZTBKY7xe6ukmOY8NuwuhbvuIfY=;
  b=KunAjEThKMix7OJ34R9gIp+sQllnmEXuPgXsHPFeLF3GB49w9RPTUxGl
   FGQFOntpQbUndvwiBPeGDb8gJ7pFkFB7Y/6MZ7vIfs4oK+uTwE5uttqUg
   kFdf0KVN/izbne4AxOpP9pDgI91dOHbKlS8qZKbterBnlyYEe6kgFLco8
   OBxJz2ND5gIMzZQ87iB9eAdsPtjXPip2yRodOfuav6MINdIkJSmj4GiDI
   ag8xanNJQymQnXujeG8eYfgKzumciHaV2GQsmmHdqGGnwmStgfYlC+Fko
   owaST1IbcQok2pVP2R1hYKHwVmXsXM4emdxO+fRh+9wyE+MFcPx4tCfIe
   w==;
X-CSE-ConnectionGUID: D0HF3AjAR8KGAkazUyBw3g==
X-CSE-MsgGUID: r59GAkkCSMi7birh9SgP9g==
X-IronPort-AV: E=Sophos;i="6.27,219,1786982400"; 
   d="scan'208";a="161190229"
Received: from mail-westus3azon11010054.outbound.protection.outlook.com (HELO PH7PR06CU001.outbound.protection.outlook.com) ([52.101.201.54])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2026 19:53:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IfaXFPjyS7I9d/+gY4tAdMG7UjxGyZDYRJKEykenhoswgnRj7ftRoMJH17KwFPkF4iuaz9k8dU2NFI3GtXllWKRD5+qu07ZnyV6wg3pHlC3WzHc7jzdsUThcN4NwsvglOVWgpH8orHZtcAsi3vK4GZpxJLb9Zer17QOXxqkXbnqk9GIgcB8mGRonx1ny1q/7zdqd3YUfWTYZkt0W72dRvab1z+IH6Opr/QcKlxBqv2JfMhStk6gLi+TgRPyeTyMEltqEvl0Hh9PEZFx5LPHJKWlfSBQzIVXfzaP1WgRAR+ZXRIJjSn23zqM8FvPbALAA/c605dv3iw+CvpzGfwGyrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BohHhXvZbrZy0ztxuhYuHZxLoMO5OrBjQwu+LIwOp38=;
 b=PDshf6QP2imsE4q3KqtrbIjw+lf2DDQPHNcLD8nAWpP0k/8kRTDCgFQn8ewJif9dasPQZqbtz9l6fDGK/3WWxe7O7Ad44PeW7ng/YEJ1nrqfrlGXqglP4O613glepKvNEJ2cff++7a8MlRWBDGeI//u8uY3D5MJ4tmLgG8bO9NS3v7b/WAO0KO+0Hr6HiYXMUHnn/aK5MejP9t33luupUJoewjv61dngbZxxbTymVWheYpk1AixK2ANVJzQUgjdGsgoluyJsXCPFKJD8tmQM7hT9roK/ns6/lCA2stYBtl+is8bmE8kUExn87K3D8vRNTczeNVnrTEDKsaTXlvtEVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BohHhXvZbrZy0ztxuhYuHZxLoMO5OrBjQwu+LIwOp38=;
 b=wIMBOAnFhJm9TtlkqDRTFFoyeijR0mT/jCEEaOfcnyRpnSftTe/QERcQLXhs2XY3gg2kuztzyzmey+w8K5/qGsj3TLNRR1cLlzTwTccGCvMZ5+gMEQl68HtH5qPPxX4NZ2eWm4ynlzGmB5fszWMF9AfuS6zL3vkJPYRH9Vj2Yhg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by SA0PR04MB7193.namprd04.prod.outlook.com
 (2603:10b6:806:e0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:53:28 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:53:28 +0000
Date: Wed, 18 Nov 2026 20:53:21 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v2] RDMA/cma: Use a separate lockdep class for the
 listening cm_id
Message-ID: <av2QarZ0_u32MHzM@shinmob>
References: <20261117113129.746490-1-shinichiro.kawasaki@wdc.com>
 <sashiko-outbox-218731@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-218731@kernel.org>
X-ClientProxiedBy: TYCPR01CA0167.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::7) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
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
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|SA0PR04MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec865ac-48cd-4151-f5dc-08df456a8f0f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|19092799006|23010399003|376014|366016|18002099003|22082099003|11063799006|4143699003|56012099006|261026121527099003|261028144727099003|261026140227099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	rVIKR81ALfXgB8zYyJQ260IoqBMvwBI9Vcrm9OqeSj0ooWMdTIgNTY572Olzj3qTtatPR5RpXh0aMIgdpI6rW7g8QXPe8tP28y7WETOUVHScddCLQf7t7KZuZPo89qpAFI8m9aDUh8SUOyRLogwuaX5NKqZk24uU2frpDHmH3298p0/ucWlmWnHKhKi4rnk7wSme+Lc7AK8HkMv9fCh9qfoE8P3beZPX2lnpm7b0Xv+hHRetnAnICuOqp5JY8WzexZ+6OzuuQJAHNpgnbMDOd2dh4poVasLQI+3ZLP0C+qFYyNnuFl2yUs7ThIvgHXV2URYa1+T6j4XIiR5u3DOMQkDFjG1ICCFZNisCkiWhmjPrLBUWye4H3nVD44HK+o5gQJJuEs8sbxgCZz+BxRRokzCx8LdQunrNuR0jIGBaQCmsgMySPKUoxqNaKMytUcOL+qyc0LZHp8tWiGXp2C1wQ09HVkU8Km5h7exldvYOycpJdbZcrAF+TEG/kW3Vq3fLE7mmTK2cF/8WU2bUSQpTYdAq07cXjtZt0SSE8HM0xBr3WajuQT8QzjuEuxJamvVd8IaPTKMf6NfSoHCWRolWBYEOOqA6U6dkbh3mwVgPnkbGby9cJVeKCAPg82mr7TcAPipa1akXDVBWupLI4+rTADPmSLTdOxFQunsFtMp4lBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(23010399003)(376014)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261028144727099003)(261026140227099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XdAlWUsvYROXmPX+bUIzuj0ZT+fBdNrN39Po5z5kuHTqS1KPrCTPt1Nwrajn?=
 =?us-ascii?Q?EzLWNQOgOySMyRH730dnPxZ2FeWNMUsCOp3gAa9IcsD5SX2h92oBG0rbnMys?=
 =?us-ascii?Q?prNcHLvbwYVgmjyy6mAnUf3brECC7TzpLcV2bNXAa2D4k6c6tRNhP50lMtDJ?=
 =?us-ascii?Q?qkXDG40MwpuFxeIwQVTbFUyRCX4RPizwoz8JDcClkG3Z4Hv6AvHDemWLUksi?=
 =?us-ascii?Q?65wywdMqDl80lcKhycuBk6wED0R/UCyT9Rn3H6cywUrc9TLwNIVzEzJE/97P?=
 =?us-ascii?Q?dc3UCyPZDuNXBpYsZ8S5tJXI2PkiX6ntGLmuLM7iuJRFJbQmeuTyIc61LKaJ?=
 =?us-ascii?Q?mL4h2ptc6uRcmOgC6+tl9Tjwwxe4IeSNn4ij7jlFW06L+f0bN386aFWxWKnp?=
 =?us-ascii?Q?fnWvNyYl/U4gbyspyJvwf0Ch8/IgxAm6ca2SPkhquiJFQvipmoA36WT2WFGE?=
 =?us-ascii?Q?OjOPfiWJ5yLuQcVmdSB5blxizhDW4flCB9fIH3m/M/UKkoCaCnBCARUmwq1p?=
 =?us-ascii?Q?N39gur2Bgq36kv0rKyXZ/ovPpaqet+DHQvQWyLp3iycepbhjMCjgJhVEPzTe?=
 =?us-ascii?Q?L2/XVeS9gLZpnrVjqFzlpQQBP+fFdJjwmNNgYTdikst50aOQ5Mv0so9uA8o+?=
 =?us-ascii?Q?7XEw1S/me4NWCp05wU1/em8zueJdphWr0TtgQYPf5yDaFj65SLY8Lq2Uxr+w?=
 =?us-ascii?Q?NT2AtdqocgzQGIPoP04PaSiStBmdmhmX8ITKvyhI0OQfDblTGYlJ8HaT5IWC?=
 =?us-ascii?Q?5Ntz9XkWtPpsOXHWZNtOqWrhZ428XHgHzRq/3Xlw7tt7q/F6VpF7bOaKRptj?=
 =?us-ascii?Q?KGJUS+hvAyzbbQurndVv/sLXdKhaPeZc/pII8yFJpodYGRpxJiTrA1zILbqG?=
 =?us-ascii?Q?CbhEK3tz87hym9MDcBQrGfdmDuSKAFtX7qIu32uq8o/giF33GmTFMI0AbV7e?=
 =?us-ascii?Q?BJlmxdFjjNy4Zlb7l9TJVYF5xu21DnI9+i+KlgC3gKHL+yk/611taTyRRs8C?=
 =?us-ascii?Q?ohPx2J+5RweP/Cl0OiutKdnwTnEP6KECB+EDX0oXfP7pMdRAx/9Cm+a1NTnV?=
 =?us-ascii?Q?vScvqN6FS9T9Rq8S8Dsi5MgW96VWJIM1r2e6e7iNq2kq5N5UxtDXlH5WPlxI?=
 =?us-ascii?Q?Jo79VvXItfHR24yr4ZTBfykNHZEDJoNtLat/CXeqU3vzCspFx4hl9nxIC5sl?=
 =?us-ascii?Q?a/LoiEEpc+EWVVURYO91SniwSdXAtTfpYNqVF/3HRWtPGW04rRnDl8NgnpqB?=
 =?us-ascii?Q?KvFBBRGIgJoPxmGga3JcrWBkc5UOd6IS7OjKH909jmNNhr9KMXm8LA0Q1gI3?=
 =?us-ascii?Q?3iWdtwXK+mk3ZYR5WvrMVtktGp6JcGGCl06umGuZd8iP2qeQK4WZy+P6GBJs?=
 =?us-ascii?Q?L7kz4z6RADtF5aC3ST7ICVmySSIxnX2x4yK5JkkUctwa2jivvxFCDvtW1egG?=
 =?us-ascii?Q?l1/+Zm9wwoQGmbvmurWSHiFuHXzgu592X7ll7TEH/T3QmW2sZmpnNpAjaBtU?=
 =?us-ascii?Q?8jlG+if1uwPGobpPeK6oq2lqqmdFhGLjbQrWHDrgAu1HMRteZy+N3KuF0+Px?=
 =?us-ascii?Q?JKfRONcUkBJBNgFWQv5FwBM62qPKQH/A8mGzD/sMmHT4ZGqy9Rr4XpfOT3fI?=
 =?us-ascii?Q?hxh4YuXmad+0gEvjt07zpUQiFIkcGC8yeKvXZonC2rcBNJSQVA0GwTnsQvFc?=
 =?us-ascii?Q?sQhkqQ0hxxbzp8p4vffbXWl8aroQJyLHXzkPApWROA91aaPjL/RdRivXT0lF?=
 =?us-ascii?Q?f8QHG+wZamCDK4BTUwQiVM9prJVCeeA=3D?=
X-Exchange-RoutingPolicyChecked:
	d4ekeOxGxcluKZV9u5g2ce0c/pjVm8ngDH3/7iLj7h5HKfp29sunBzrF7ercF+cDIj11l2fJF85hhNOhqspZsP/tFBaeSRASEpTaGV3aGo3oje6Mw8zxLl0bJ+KDIl132l4ETcUx0gGaFsi+erikLjNW4halMKPyi5qQqhuitNQrMvx1IS5AKqfFjXTQwAamms2vXZnSqHS9OM3tvu0I2usMdS0gi9uaWzpuAUzvP5NZpnDRkJdhDLXKDkqVbclsoWH4f1KLqqHUyx/lKEmkICDm2S3lSfV0mK0GqiJGxlmwvRlht+Mp32L1YPoPJ2bIoCZFSD4zrBydx40+95efIg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QOHyn7HUj6caKLkfZ+WVeyFohGHp5AlfbKxPnpUQd5qhSC9+zFA8CjkdwlE612tyeqxFW5DYMbXyuNPi6BXC7UyA/tXuKy4DBuMLaji3WpVcHyHUkRakZw+x5BZEkp4pG5iJcfhTjlDVRMzasZwJCtQwsbWzwKbtv+9VGII+Txds7CeZlvaaSVtvubdoqhGPJqTwgMwvB91dhS0vbtyriOnbE9n4SOlXAb/zwxK8r53CPxz5chQtDylemu/neo0QZi/8C+vPGvT7cDXbPXNt40J2M0lSIOd5vjhJIJYj7I7mn43K9E6j2+rAL5Xu+dNv8wxeTgkktIlzvzh430Lw13Si685RDqQgd6vGlN4ttfTfoW5OLceoiMl7kYVPIq8Em45cGIBE+x0MzmbubdebyRuKdKPzdr+VnsdUAAE5JSiS22sNE14r+XWmPewe6UxHGjDLfPaEARU/GWsj3SZs+b/uZgERyxcFrkB1wx4RjOi8lzKFRFL8LbH+p4sWqpZC9pU8plY4qVi2aA/xi8pHejlty6JmRHgKEXJJDtfOCMXsb4qUWBY4bRUwVuPkOQHNmRdYBQzmtPgj6VLtT1PXV9Yy+GsQgFYCEfFjkVI8BfGz/fQq1Ol7CTHCH6albQ8V
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec865ac-48cd-4151-f5dc-08df456a8f0f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:53:28.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJeynG3NqGDp06AS4aQsuGn3myCfB2HcVOis9GkttJtbqm/eENzpO2+jULSS4iOrYKRaYU694+UpWSP+4M3LNLksZ2M4mEHT7ciapvQEaxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7193

On Nov 17, 2026 / 11:48, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] RDMA/cma: unsafe lockdep_set_class() placement in
>   rdma_listen()
> - [Low] RDMA/cma: unreclassified handler_mutex on
>   nvmet_rdma_enable_port() error

I think the two issues are valid. The first one means that the approach
to reclassify ids in rdma_listen() does not work well. I will think about other
solutions. One idea is to go back to the solutions to add a new function to
create rdma id. The other idea is to reclassify the rdma ids not for
listening. I will try if these approach can address the sashiko issues.
