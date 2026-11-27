Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795777483;
	b=WUrAL9QQea5AFDs9ko0TSQXzyxHEmAhw/F8/8UJZHMXhVpq3NI0CI0xxDHC+n92t7ay/
	 mHVYfufXGI4xzLkFOkuT7Zj1VwYNPena+4iPFXDI/Ugo+f1cUA4jXjCEbKc+/hsrM4VEX
	 5rr0zvimHngmqLoGa++p7cJAh/hDJ71o3MpEQQfu5QURuu8/MmcxgQ/1Zeg6onp0O+n0e
	 NPOaFu/4wYIPEC8dr4Jg+Lwk/Hs6fXUixT3CKLfZZRyfZnahLKb4cFzXVt9Hk53cSSZ6f
	 8WKRMaWSpwmT58FtY3Lyse0ROzxY/1IOFIJtjxD7qb/izKNrRQupzs8Al9fTrB5uJPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795777483;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-BESS-ID:
	 X-BESS-VER:X-BESS-Apparent-Source-IP:X-BESS-Parts:
	 X-BESS-Outbound-Spam-Score:X-BESS-Outbound-Spam-Report:
	 X-BESS-Outbound-Spam-Status:X-BESS-BRTS-Status;
	bh=yVaG20NKJtRh+hN8u80q0JeJUYq1XeMc7vyRbbCS9G0=;
	b=OiLTB3hSjLL0izRju/X9nhf8BK+zqH+RiqaSLsKUHilu2tjBhrybRCNNqqU8TTQ3Dhvk
	 HUFL8qa+UvFtRnUzhQkQeq31P+o3rBV7SEkqRcWrfvmSl88P0/p7F7C87hlz/lnD3mOze
	 W6YrLs4HyNgIHzQImETa8xNDS8WS7c9F6l/JvSaoHFRAZqGy0GJ5GxwmOlNr7ThHPiJ/F
	 fLJQB7x+aSYoobRROm+X1SqxPL+y5wiloiuQHZh3HUjPnV8Ex2q5fTaXBo3ktMg7GNmf6
	 Vr+DWvHLhgt7Gsx76sLn+RZPJlLZSsh/DkEDKwC/a5AAt4MUi/PRyTrElnXsEEz1FlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ddn.com;
	spf=pass smtp.mailfrom=ddn.com;
	dkim=pass header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b="w9VF/bCB";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.58
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98208606A31C;
	Fri, 27 Nov 2026 11:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98208606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=w9VF/bCB
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021076.outbound.protection.outlook.com [40.93.194.76]) by mx-outbound13-183.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 27 Nov 2026 11:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SZCmJT4/Fhwzn/u/7H/xpdSkrO1wqnAphyKT7C1u+Oszq2fSxdsKDQ1Jh28oClEENZKeseUISbMM76jcU31lb7OZKZMc9RY+Q9Leqtc8QThcD0/XGAew7eIjt0D/L6iTfUcy4rBzgJ8UKG8n67P5CzRxOO8Fzg5Y9+ks+ErFfJ9rId4MgliVl0Wi/VIgAUcW0aVWLDdoNew9GKqyPzYmCAALQv/46aOwlkPQWvkE6vPtSdmS0BO3sVkyLQGrmnguQVHopcOXRN4/5ytAegBLnWMpezbu5F+KYbLOKQI+o6in2zGllZ1VBatO/lN+pcqsSNpMxDsUOVgq1SfQweQirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVaG20NKJtRh+hN8u80q0JeJUYq1XeMc7vyRbbCS9G0=;
 b=Fvh6C33rEto83X1PI3ghPK25etzMpAkuqsxt97mWf87GHW/QoSEzSUcnQSQAxwjyZk+sMsLrjFCBoVuK7gnkDKmNCZtQnLOfW0DnewnJ4pwzpI5bVHH1UVrHFsNb0KpPU7ZBgFZy7h9ftHyag48oqCF8DoJ3PCUCfvWCyeyqkFAr7f2eWMvv/O16mxB8Q89nXmbj2vHCYRtuJ7IVgKgZzhaguAs1s/Gylhg+Qh0w2ITzf/lrIdHmW1dOfdJu+ZIeX2aURmnCQ/CEmJdQh02fiWa+7yJW9+dw57+CKS8Ze6F/ZxlssJ+FaIkZ4J5miVXfAuP3uOb5EeEtjx5/udO7VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVaG20NKJtRh+hN8u80q0JeJUYq1XeMc7vyRbbCS9G0=;
 b=w9VF/bCBhdi0yGmYBs3os3sdlN4VrUbUB409LoPcotBT+nW8KuvbxaUax5L6+wY15Gtam/zVEwF1DAHS9mZ7AKBs5Ov1oVH5qP4fJDiLY28sSXTNxTZhn2sqvlwX4CImKciZpWi1Z+Vh7O5jieKJbv8+URbKCt5A+hGf7+lPMM8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by DS0PR19MB8416.namprd19.prod.outlook.com (2603:10b6:8:1b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 11:04:02 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0639.012; Fri, 27 Nov 2026
 11:04:02 +0000
Date: Fri, 27 Nov 2026 12:03:48 +0100
From: Etienne AUJAMES <eaujames@ddn.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
	Feng Liu <feliu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	COURRIER Guillaume <guillaume.courrier@cea.fr>
Subject: Re: [PATCH net] net/mlx5e: guard child PKEY channel stats lookup in
 rx path
Message-ID: <awljlARPJweYKIZb@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
 <20261126144122.3886594-1-dtatulea@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261126144122.3886594-1-dtatulea@nvidia.com>
X-ClientProxiedBy: PR3P193CA0017.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::22) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
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
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|DS0PR19MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bfebb92-33c8-42d2-bca4-08df4c76250c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|19092799006|366016|1800799024|7416014|376014|10070799003|4143699003|6133799003|18002099003|22082099003|11063799006|10067099003|56012099006|261026121527099003|261102123227099003|261028144727099003|261022105027099003|261022075727099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	t8gcj/fIzMmLFOKc0g0CbpHnGtoE6eubXCD6J6XY42Jnq9qcdhIZcvjzAe/6QTT0I7qI0jAmGox9MRkuEigEMzeAaQ5oJzTalMJJ3BJ+MkwF/f4ppguj+Ic4xgZkGNQfpeJeGsDl6WePXn1njLXaDRS7jNj3RM7Z0ZxtZaB/0GoUE7BHhxLNwgSBqmNHml06uTvVql/FpA5OZ1NKR0rR6H7tI28wIEW2deXi9fSNsUYi+IFLS4fJFyTNjrgxjvP+UBqmalOUUeRMYMm2h/m5VFS+ST5zXmY7JugRp+MHgqiRIWwCBwLKVTUZRTHFfW1pVfYsrZrR8ODdnaCNDVbfIuAMdNOrwSn9rezD8UlCL5mYnbUc/gzlSVH7/Khs3EvYFTE3tYtTTFMOhXuuJPPfVFeQ6p2/OmfxW2OqCIi1jq6AzMBD6PIuiWDM5CN+g/y2VUpqZhkNzX0oA+TzMGWS19qrEzlAF6rjoKmGRmViAvZ+hs9kUa+9w1+zyrpcBe30AvnAWuuctNsNj+WqXeADfNiJ2mJ+xNGEW804qqWuhr4ijJmB+m+/TEYslbfS6FRm9t9DLV8WzFSCS7irW86lNj74mgSlMEHL/rIcXK4bH7FhALv/n9bNaLmq7L0uYm4jOPJkdQUu9E8lACKGq+qMR9N2ml3wfVKSIxVtRFbu1Js=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(19092799006)(366016)(1800799024)(7416014)(376014)(10070799003)(4143699003)(6133799003)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006)(261026121527099003)(261102123227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z3uRkOKCV0mUMp0qerZ9Djmop+UHatjORgM8bAWE/OxFFDC56ymnFDpmhQOY?=
 =?us-ascii?Q?ramC3qNupNHrA6Ic7u6ivzRkzPrk6ywUJ0woSSROBcnN77pz6bL/iJRct2ZC?=
 =?us-ascii?Q?TeYIKeWjNNcu3SbteNGJGRe9T12C4PjGZ89NgviPgKB4cESTuJR7+UZRiCVd?=
 =?us-ascii?Q?iSZu0bzakBIJyVvi29j9b5oXsDVxjzhPwcI4/SmIRkgOfr+GXVKAUi2Rhwtv?=
 =?us-ascii?Q?NP/tWj3vwpa8dDnI3/o5k1cuAEhaydyAa/wqt+HgPNl5Kysx1rh/gB/Vd+mh?=
 =?us-ascii?Q?CUrhxd4Y3ZO+cig20l+iq13tzbmgecu9Mf7Zr2ltfjDeDyGT/bNhU2L78DP2?=
 =?us-ascii?Q?AmE4XWdgXoJlDT1XwQhe028Ox6hOLlQu++uQvmlTN5Po6i8q2tgonJeO9upp?=
 =?us-ascii?Q?3+fkI7dt3SzTO6BmReRvXwS/30SJDalR+uWSi14LHC+mPUYZRwngcYLZ1CTw?=
 =?us-ascii?Q?J+TAowDpyA+u2HpJSxjRmA3asI+Jv/GaWwhkzqYlea5FUQbN2bjG7JvKVtK6?=
 =?us-ascii?Q?KXXfxeK91Cj6rKNhWeyCeskSi1v36occaLFn0md/kAwfS6p7Vwr1TcLFLGAl?=
 =?us-ascii?Q?28RQKPOKQvsLRn8fbqzx9a7FxqZ9dwg7nealB6s0tTVi9krndR4YdqKbq0Dw?=
 =?us-ascii?Q?SoRQcAxOC57aR5oVagUa0HUxmoeYBID/l7A6hdj7BpWpkA7tKvZ173li0diQ?=
 =?us-ascii?Q?VxPQNfpTKjyn7ly2Hoq4Ai3EZKnlAofx8sj0zt1ONAfXu0ZC/ZH9z2wh6Hzy?=
 =?us-ascii?Q?FeoC24nlvRxS4gDAsReucKJZmNGxhrbWBHh7p+4ep4M3uTPJBAblmmi7Vhvx?=
 =?us-ascii?Q?at8VC9P0VbeqXoFWZB+dbj9OH5vMioWmYkg4qiG+oy15Z2y40gmmLvlb+BIB?=
 =?us-ascii?Q?dgwnH1GNE+fNnMPclpHri1UTKcazMzJH23xZzYu1RXcsO/RGvj7JqmlWxr1n?=
 =?us-ascii?Q?kkMcpJpZnRdzzlB+TOFE/BkAt4S+JnjHjW8of1AxiKSal8Htxe/GW3mkaqXq?=
 =?us-ascii?Q?2zuBN2rOu0d9t9AJpjd9StZE86rXvOHRcWpfTR6WnUEkITXsouespm1+DdGj?=
 =?us-ascii?Q?VXCj6eg6SNMuUU1YCOXz4kwHatZ+PfBp9lcm/q98Frj2Tkl7teBm1aqG1lUT?=
 =?us-ascii?Q?2Ze6Y2L4OTzaVcYFKpW/P6/aQMI2+s3P6it5/H5ej5fmMpZMHMYfrP9lqkCN?=
 =?us-ascii?Q?0hES2R/Tk2ARh3Y3QJ4X+pXHdQPSUzwUFhOCYrXvdLHcNH8UJ8LynqS7158d?=
 =?us-ascii?Q?08R/pzarwzi+NwXr/4q0/18wQD1aX1BEnfLQBRNtqf2SFPIYanf1JWYOYXwu?=
 =?us-ascii?Q?n+iAMhgXg/Vn3o+luouYKE61wt0M7nL2HZ/jSizYy20dArgjF2otKwe3iHak?=
 =?us-ascii?Q?KInKUrpK5bCQhtGTiz0Qn//qz0IgpQKwFggktvmXK/Am/6MShQI/e91C8jPb?=
 =?us-ascii?Q?HoeSaeZH/BBcN6RNfuJi54obsiDA3AKzMhyBl1N+5naNJ0p2ZjcmYznLhfgb?=
 =?us-ascii?Q?JdMOMI1TdlYln0u3dtM6IaVMhzqKQeZ5dY+DD9mywuW7eV+81LcrPBcEb2M1?=
 =?us-ascii?Q?UwTcq0VgaQ4QMBnFi/AM5kgG2cgh6xUlG+hPrSAAM7f0ErKFIP6Q6GsS7eMr?=
 =?us-ascii?Q?biqLc5guYfZoaIBk5xDkgGfTtb5ZzhCMwZWKvJ4pQjOO+RCvEBKVMvLWNUoP?=
 =?us-ascii?Q?o11UTc5QbKI+f1YE8Wxq+qKdb0rYyfQVj2yIJLqQRGtmc2tr2iDlco75rmXF?=
 =?us-ascii?Q?bNsrhYhATxDGuXGPggWB0C/ZwFtjr7/xOsiUnqvwaBEcqaQMDXhznSBoSswc?=
X-MS-Exchange-AntiSpam-MessageData-1: 1vxjG0525hQMRw==
X-Exchange-RoutingPolicyChecked:
	JPdMrUsLZp1AK2sUq4U7xw2bEu7nObGsghQCpjXXumQi1iAQ8VX9FA1cWeuGKojl/T0Cz96sT/WM56OWLQ5eJPmXbAZQRp3w0rbAuk1c49YosJdRZYwNCJ2UQeNvRhQn4NEnyCkIs8uxLCiYHFgL3p7wavRJAL5B1YWcPNpCdKUxos3MwnNW5UPmQ/WBhIEiWfuIDH76ADMPIh5YkaOp9ZSgj/4vi4/iQYnnkaw7eFWpx7n6E25WM+XtnGAeIKTWeAqncJvAdOTATDKPG3+doFjQ7+DXaX9/AwxbAEyXQCqhrF2uoyNdD9C/+AzOVRJnb/iX8UbkAd//fGFs6+rD8A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E4ECddAD4vzi0Z4Uhtdsyvihkam+uQm+LAHXiPY4g4tPBrLONBf/phY211CEGH2HucnlIKtnMjpz6NQ9n6JCmn8D8q8xLV0KXDGO2vc6Zj8Glw46jmFy6nKdZGF+Il0Z1WCX9ZaZ6w3oxi7SwxlUPA1QVcA65E/W6NB9nhVytH0OcVs1i5YZqPrpdua/whJhaxlVdE+iog0lLUmfATd9bwQj1E2mAn822CIqctdQ5kaKYh/ASjz0El+Xm59hVJzPGhGQCHpYn0Emz8O8HEaA1zTdxfod/1RpDkB88re1DWMlfLlXaE9ovuM4O01GDvf+Livz9yQtQJm1UlR5rd6hWbMBN4pXyxKYgZVKtjYpWVfjCJt69+5IK3siJ7DeH9ZcAQBflvPC9QsZ7kLu9NLMHaIhNlG2ErmWQkZZulNMLBCP+TaUnZv5PkyPevIFWhd3X0Ozwci1QA1MW+FzQbGKWkNUyqshqidvv2g2LQ7vxUsv1C0GCEi33MKZWd/8AhAY+6iI8CR3PllIXjLWiQmaLvjFqnO46mtrACBv7VlAvMcqpDXj3PWO6u12sqUsooShAAx9cbgio0zE/TQjMP06qKizxaB1azM/PTfmwhOCNIocNGbrlPnXtvjTHvajCI+PWg5JUm8DOTYEQH4jVFpKww==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bfebb92-33c8-42d2-bca4-08df4c76250c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 11:04:02.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EVYEYT1JsKCYsvq7c1qIE0M9HQAGZs3SVdwgBvcxGVdq8HI7V762h0mEjCfz6NqJOqxkUvXJUtzqBEz1y6blQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB8416
X-BESS-ID: 1795777446-103511-7733-407-1
X-BESS-VER: 2019.1_20261116.1548
X-BESS-Apparent-Source-IP: 40.93.194.76
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYGRsZAVgZQ0CLZMsXMzMjI0s
	A01cTQKDXR0tLIIjklNSXNNMXAIM1cqTYWAFePbNJBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.277881 [from 
	cloudscan18-111.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Hi Dragos,

Thanks for your reply.

On 26/11/26, Dragos Tatulea wrote:
> There are 2 issues here, each needs its own fix:
> 
> a) Packets shouldn't be steered to the parent RQ before the pkey netdev
> channel stats are allocated. Fix by moving the flow steering setup
> (mlx5_fs_add_rx_underlay_qpn()) after the channel open in
> mlx5i_pkey_open().
Ok, I will try to make this change.

> b) The thing with the resizing of the parent channels. Can be fixed
> by allocating the max number of channels for the pkey netdev. AFAIU,
> `priv->channels.params.num_channels = priv->max_nch` in
> mlx5i_pkey_init() should do the trick.
I don't believe that's possible. The following commit prevents
changing the parent channel count once child interfaces are initialized:

commit 806a8df7126a8c05d60411eeb81057c2a8bbe7a7
Author: Dragos Tatulea <dtatulea@nvidia.com>
Date:   Thu Dec 15 13:02:38 2022 +0200

    net/mlx5e: IPoIB, Block queue count configuration when sub interfaces are present

    PKEY sub interfaces share the receive queues with the parent interface.
    While setting the sub interface queue count is not supported, it is
    currently possible to change the number of queues of the parent interface.
    Thus we can end up with inconsistent queue sizes between the parent and its
    sub interfaces.

    This change disallows setting the queue count on the parent interface when
    sub interfaces are present.

+       if (ipriv->num_sub_interfaces > 0) {
+               mlx5_core_warn(epriv->mdev,
+                              "can't change number of channels for interfaces with sub interfaces (%u)\n",
+                              ipriv->num_sub_interfaces);
+               return -EINVAL;

Can you confirm that the parent channel count cannot be resized while
a sub-interface is present (whether UP or DOWN)?"

With this, it should be safe to pre-allocate the channel_stats in
mlx5i_pkey_dev_init() using parent channel count.

I will try to implement this and test it in the field.

Thanks,

Etienne
