Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794373336;
	b=gvecJqrG5IkiLXsJDHmSpbZbF/kin16MkfecL/R92FjQXZtz+vg8SZE7c8Hwbjv/u2mj
	 T8dmkkUqKLrNcKo+PHGiHbHGKxXCcYkNZw/TdbSHA2278rXN26Mxsu2FFt/PLcjeP9dno
	 TkYE65BFDdq3UATDQY3IKWM3qX5B92YUuYv5oOBPIh7WMjkVqUkDssNPCf2rjEGHhM79S
	 xrMK8WGwF9Ty7pXAksih9ul2ETmVM6CHbLYF3mRO8KxCGYiMG+R5uLtmzCovXmZpyMyVN
	 KuKdCc77D+pFaRHM+Uhn5ZsqZD5SknQ+OzUv24Fwu41SImOMN//6cf5Fv1Acpku1pIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794373336;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
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
	bh=AXLTFYptMPrCkn2iB5tFR3lQimla10qFbx2oON+xRfE=;
	b=yiMJ8vSVGwkoHGd+5Ph1jwXSUDOSacjSaLE8++Ez+5O8Dil8369N+m0YlkS1BkJf9GEE
	 cyHo7B3X9Q6DQ7AgS9DQsT8TfFaglm7XS7d/bm9USV2FQcaUAYRnHnFUTyKf+9hfmWaL4
	 A7f9fR+SDgJz8rZ0cFuApbxrXiVYZy0G+p4PfCn3zNPyBzZCI9BWBgX+gCopEQkWgTYhH
	 2LiK0P4Ucel+QefE2AjBGZYpi4WA8q1hAyQ1JAHPCNPqfp9L1BZ8QnfrWQR99n/w3ipg4
	 JMJPnO0wofdELw/GwZUKnAKUNCkRDPEAXmbhVS8L5bL6/VNfo3P33p2WFTMhca1wFhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DMhKio8E;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=p3MS3JNU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=68.232.143.124
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2108606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 05:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2108606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=DMhKio8E;
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=p3MS3JNU
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794373335; x=1825909335;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vqk0e80kLmdrN9pAWAlO0T5JQcNRU7GqRcMTjxzoYak=;
  b=DMhKio8EjF0j+dAd61JnP54ph57hiWX3F2mlvsL7J882yHqELq857QQP
   hNkMbTxK0EpiiZ9kAB2uo+ITqRol2bG6B6S5/UioLe/vmCVMK7PdwrDWE
   FyTS/fE1DxmUI/DEBBkPHJij7A1+pGs35HkYDJMbOR4YHkyrOpvyK86wS
   UCyTNduGB0jS1nP5eBjBJxRA15Ucad7Iief9/2ADzQ281BBGPHOf2cqMS
   0c9ncV6h5fEwJ6WL4VgLtwTbpITUm01zS1zvo9Mb3VPomLbHJkbdsZjwj
   LDDj4k879QGUli9rsrOlhx+2yhhT2pQapm6zY6Xockza50J9Af8KELtxo
   g==;
X-CSE-ConnectionGUID: A/YrsjCbQzKyjMUs4WeI1w==
X-CSE-MsgGUID: 7APD9YegRv6oiLDnQIiWpw==
X-IronPort-AV: E=Sophos;i="6.27,207,1786982400"; 
   d="scan'208";a="161577351"
Received: from mail-eastus2azon11010050.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.50])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Nov 2026 13:02:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mYJZDyyMxJsjntGoo7HMnjvq2urXI4yRfIDHDJoKRj+dr+slUhiUv/28I+1eEIwz19JoWY5C5i98234bVlTcdyIMWyVDHp9BN+falh6DFX0pKv1BboYQFmNZLgCx/Puk6MTpYlMDy3/pVDlzhpskQS1yoj7ZRtjU4CkokuRom5ReHphdFQTk+R06Z3qc0985uEgqGbjIOpJyq8rrGqSmCZ+9tx2s/de5wfoxWZPqmNLhzAtQK5VYV2ow317X/Wd3w6qrB2+wypi5EkMCBrd/33Q0i35xvo04xTltF4khEm5Oba5jYXAwePPtGq/52ogtiZCe8cKHzw6eZxGI19HGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXLTFYptMPrCkn2iB5tFR3lQimla10qFbx2oON+xRfE=;
 b=Kg0Xns1AOy4HfIIj9ECPRIyWNW9aR2MX4jgtXgiqRByyJTw94Ni3PaBxz5PFaR+waioAGFLKskk/PIZzTFj8L7NDbwYV4wO4sFIAC40O03UtPLrk6n6DWLgZunTp4RQHuT2z7TJiv8YAmQIeb1uyjPHM8CxrUJuIGuWU+r3iK9XBtt9QxR+efUO03rvWpboF5ZK1CWySPutcQlD5M5dPhq5ZhtukHImhJewwmFemaXP3kwV19PR9r+TZCO+iYUqgFdSkaW+KV3T0gowpN7zDeppM15Cpfppfz6YcDwDQWLMofPNSCM9iqxjYnU1FBSuTQUpPZ2nbO6FR4f7XPXDceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXLTFYptMPrCkn2iB5tFR3lQimla10qFbx2oON+xRfE=;
 b=p3MS3JNUvZpdvdXsGV9pEeaIdpvAZmWuUK3/wOCCJcfAk0f80bdYiLacFoJVKdyNKC6qDoBdurjIZjmwaB1YAaqJHCIIq2cfBxqpBrDN9lS+5wei9dOqyKYE3+qnFmiHl9xpmywe7phkHGTH2KgxJ7cOsVQyTbDSrhd+zGyVjpE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by CH8PR04MB994408.namprd04.prod.outlook.com
 (2603:10b6:610:35e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 05:02:05 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 05:02:05 +0000
Date: Wed, 11 Nov 2026 14:01:58 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Keith Busch <kbusch@kernel.org>, Surabhi Gogte <sgogte@purestorage.com>
Subject: Re: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for the
 listening cm_id
Message-ID: <avP07JWvBtMboL8k@shinmob>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
 <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
 <20261110003243.GS663069@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110003243.GS663069@ziepe.ca>
X-ClientProxiedBy: TYCPR01CA0151.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::7) To SA1PR04MB10065.namprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|CH8PR04MB994408:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b60d39-8fbe-4126-1bfb-08df3fb0ee03
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|23010399003|18002099003|22082099003|261009223027099003|4143699003|11063799006|56012099006|261028144727099003|261026140227099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	TVXlu2lmDLTmWIIWjpcuvnfSf1RJp3Cua4XeFy218NLz8OXAuKYyraeStxK63SCRxguet/Zms+xAz8vDuhTqM6X6W/VnN7NTPwBSq9eaCfD+TqLjkjw17lUlWiDSgzobmZxAsi+C6ilAyUW03fRYli9NrjStHM7NUY4tgBZonkymFcvwjPPN7ZYDQAk+yP6MP1jDbZPDOrmcBv/yfaXBvRD5z0Qmr9OOvfEeJUjsfusQxqCXs0zydcpD7oosjTUa5X7WADJt5w2yo/RTZQ5v+H806fzG++0yB0Cwb/ZSt2ltmPQhmY1/69ZrPghprjWwOf0ojexW7gKm/bGghDk8bJB6+A03FPEnN/wKvHGmOGwJXqSyxQE4qi8tCraJECYC45grZGE4q1YS9adC+Cchlaoyk1K0aQks9x95PAfvbmHVdFsvM3nuQTAOxoq4cPXEn8iPeECmJV2Ytu6MWBpDWcg5EDgbswQWq8s91vx1GBWU951Ey5Ct50fa5W9RL7goTcmKEfpVTRhDHGri9LbLFDYrbYANWjuGR3uhW+y14ntOmktbpn6TKEzD3rJ7EyxN0FJcrV0CazumZPH8TI20vrf7MX/hbD41Dom5CsnJMaOltz7CXR3ArnC0pQ0YXQHhtR7b6LkFBsUnYPrNfRb68kDw8qNDkjIsOfFD/Z5bUCk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(4143699003)(11063799006)(56012099006)(261028144727099003)(261026140227099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wjhwohd2ihrWJ7+/hg/ZsZ9sHLfZPL/m2dNRe4zWUgcy83yAcPXJHmp9X3Hd?=
 =?us-ascii?Q?h/3KQV2/4hIurYa9Jhm0OBb/22FcVrx0mvnDJMnZ5mDGYbm6oQrBtkr7ZhTJ?=
 =?us-ascii?Q?jpLrBClrByNb19c3gVO2BYWMHx1tZQQv6qzFkw5x3bM4HnzHMuainn9RVkUP?=
 =?us-ascii?Q?BbFuNBxj0aXNwGh6aMG2h/kpPATj/j9vgFvcCXd+L7vsTaXzOvfh8e+uYAJ+?=
 =?us-ascii?Q?63vLjiNZEl1ZcS9sUC+URcmRIdEH7kF9amdDud880LNn73/1g6rGwWNyaq2U?=
 =?us-ascii?Q?IvH0vrmenDp8vAlk18fBkNlUAp48BOgkWsjcolFxAagFUB4QH2QhHyV69XSz?=
 =?us-ascii?Q?G+6JdpTbTh7dUIDcocQEvR1NqTGl8ztmGwQ3WJZ1UNuajBwoQrFyn0dVT6C+?=
 =?us-ascii?Q?Nu9+F/C9PgqshwAknrxjm8O1Eve59CDUjCTBb00D1bMNKqiZLF0eyV0l97xp?=
 =?us-ascii?Q?JBPGF1Pcrd9JHvpuZom8rYHEwXQZardt6yQ686GWS+00/h0XruSvi7QjIt/n?=
 =?us-ascii?Q?uReauM+AowTWDkLoE07VNE0qQGAHi0T9nUTyhB/U+Y+7n6DJ7ZV+7nE1+TzF?=
 =?us-ascii?Q?zpPrt08eShfP2necqr7oSEGBptFDaKhPUWw0l2vq7RAToZGJSWxsn98ZSy8y?=
 =?us-ascii?Q?Uu3I32Izz+aXRVJTyt1TpNchyMucNWv1pvRPigNIPaiL9QnhjKd2fL6O6jm8?=
 =?us-ascii?Q?if63f1gvAdeYJxopucnEJ4b3KxLhPaOSUu2P8D9z7Vfu19fnf8rCTHPhlVJw?=
 =?us-ascii?Q?kXICcXPk3EoX/OvjwzQ9ybudwVMihqUVaMbfIdidLL6qL67Si8S0nMzdLmBP?=
 =?us-ascii?Q?OKYOhEyG3J4ewS8a98HP0zstkDOLZqn9XUSccRQtkqqrlP6eoCjWVVlr0w8c?=
 =?us-ascii?Q?E4fo4EMZcubidyC7QqKuC+pSSK7WTVbuM372dD0TtzCkMCBmA39WA32HB8fx?=
 =?us-ascii?Q?1RCHtKrDO3VxbuiV15dJgZxjUV27klCNKI0BrI3t+Yo3TXgBNY3roOvLrMnL?=
 =?us-ascii?Q?kOowTkCpf2J2hjyPk4ijE0tzkSlprHjnl+svBVTFoFrt3UlvWNdwp2qc/ilJ?=
 =?us-ascii?Q?zm8lCmH/UWQMfvVbKnes8mL2Z4OBWSRKqFAKO8Lr5FpQ8eQv2D0+aOQEjk1t?=
 =?us-ascii?Q?zxZ4lyOBqabiQygMGq8A8t0l2huO8CKqNj+rEtvOOSFBS14PBcTHLya2ApfX?=
 =?us-ascii?Q?0C7bq7ic/3oZ9ZUG2P6FIHC5egApfpD6Yg27VPrc2AsOyy4T62ktJRJSv281?=
 =?us-ascii?Q?lEWZ+vf1ryfD+/Dr42syAVzPWI4sTCf/0oZDTcacJ4OwU2ZLezM3xQiJ6mN/?=
 =?us-ascii?Q?aCqGypd5ihCDZ4b168I0qLCZUaq+cJymTFtDP3N5j/PNfx//MSO2hrA1ylgX?=
 =?us-ascii?Q?OllEsv6cdW8+hzwSaQ8wW8kMVJnxyhMV3tFiznSWjBFQCj3BU86i7eSo9nej?=
 =?us-ascii?Q?aiigIb4P4epOaeVtkrpf6l4VnlLJYwAWHBKL07QWb+K0Q1o8e7iuuvyOdz9q?=
 =?us-ascii?Q?pIMabpbNQ95HWLNfC912zChjCPAtQYyVbkmBxh1NJQJFx7nbl1HoUI4NfFFl?=
 =?us-ascii?Q?x4rvfD5naHd32+oGxnNLY+NEqfvAKob3CsPsnG9vuNSc2wYaVjC3mMtfTyFX?=
 =?us-ascii?Q?+9RBLX4EUHiTpug53HTVpQ1jevtarVZimng5vN+KcQcLxJ/moLlR84D2eKEU?=
 =?us-ascii?Q?GRmndTC9oLtIVBqCGpnNnGXNak6Nvg7SLNyVjLaqMiKw+ZyUbwe+VWY/6hCU?=
 =?us-ascii?Q?JnIX3UazcDpW4/r7b7ENhCjzse2lWhI=3D?=
X-Exchange-RoutingPolicyChecked:
	jGX2ywYPde6mN2LVd6D9Bsdp4RATa+RYHJZcKGKih9Dat3GDf0MDyvJzpIgKosRemdMf2baqay9nRevPrZjEzM+BpvcfeYLrVp49KIGUvq8bNDqxDR4kD6MPJSb22LOcqWrMSfmo3/1EZX73FzpIuMP3MtTFhHtAnqmOnlszC/17qs/u12dhnPHzJNs1qhehe4o+Yam/YPvE+kk2I3cKDTQ3LMeWJ1MRk+Iag8a5W26RJAs0Dglub+3ZkW4qptFzdddC2fDI63ZcuFTvcJnm76LRPgnk4yNewxzuVXLHrv5LxZmycSCFg4PRGS0fwj4BRP1s4Egq7ET/lkTD1G+8eQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X0bAUxgAjtbJ53Xs31kNWQuy2bZNRdgA5oLAQO6OoKKgA/FWx+FQtIPzvh4QpwR/I55DgYmIBN9ubl9PuRR7RmY4lL2tCnMzwWKGXgvGQnAqR2FqL5+Wje0/pedN/DstAXIFG2Mj9YVMi0+c/8tyRmw0PZdxTjjFnWXEZd+4+leJytggArCFPhXzbho2k9tHdPhz+CzGO9OFhhab3W5JGohciI6zlcNHpW0oRY1+vhj0mHLqOM9LC1wQHo8ET3ktPk0DKSzrRPjzWIckx5gldYmE/fbA+rSogNqMxktKRvZ9w+cOdR+qLSpG6xkNxTD6RrBXd0Kcmxp0yKZdjzLYaxZcBSoqED3ggZ22hRN0WD5ZPkqc4HS8VFiSdyGW8RRMqiWZIMbfWZmEqfEnGrdRgvNpaDOjU+xSqmFrm5L2MV3NMB016e0cb5q83XYmBVorvgK0aUH03vai+g/RQ1QoeLjsrMs5+43tOltM2U8KEn9vJ4EvrdVZ3VzKoxnjsA52qU1K0hZMeSFxBYQifL3tBq8qTipIkah1yomQHM94oHyB9XvJQ4ALKl74jjX58OwQLG7CDHb3gXZ9HCSNYR2w2tuGAhoopn33jOHaH+rS6b3FNQ0ZwjQ4kVShYYEuloX+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b60d39-8fbe-4126-1bfb-08df3fb0ee03
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 05:02:05.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtNnQmnkNvKokr/OImsw1cKV5TyXuHVztMHRe+mMtZse4mqaklV1YjG+iC78rTng7AI6TLyIwI9mtN6as15V1hR8I5Sl33tHUWoBnZu5xpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR04MB994408

Jason, thank you for the comments.

On Nov 09, 2026 / 20:32, Jason Gunthorpe wrote:
> On Sun, Nov 08, 2026 at 09:01:54PM +0900, Shin'ichiro Kawasaki wrote:
> > @@ -1914,6 +1914,8 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
> >  		return PTR_ERR(cm_id);
> >  	}
> >  
> > +	rdma_reclassify_id_for_listen(cm_id);
> > +
> 
> It seems like a flag or new function for the create would make more
> sense,

I see, new function approach sounds better than this patch.

> and if this is the right fix then all the callers with the
> pattern of rdma_create_id() .. rdma_listen() should be fixed too?

I agree that it is ideal to apply the same change to the all the callers.

> 
> I suppose we cannot change the lock class in rdma_listen ?

Oh, this approach sounds the best. It modifies only RDMA driver, and can cover
all the callers. I did a quick trial with the change below, and confirmed it
avoids the WARN. So this approach works well :)  I will wait some more days for
comments. If there is no other voices, I will post this solution as a formal
patch.

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 337a49d1acf7..334f39c2f5e5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3949,6 +3949,12 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 		container_of(id, struct rdma_id_private, id);
 	int ret;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	static struct lock_class_key cma_listen_handler_mutex_key;
+	lockdep_set_class(&id_priv->handler_mutex,
+			  &cma_listen_handler_mutex_key);
+#endif
+
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_LISTEN)) {
 		struct sockaddr_in any_in = {
 			.sin_family = AF_INET,
