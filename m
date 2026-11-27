Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795811807;
	b=NB0DNVIH6DvisqUO40JMf+04t9DL1CsBpqEuq6aMBRIAV3OrtRHiAA+HxOtEvbpExeL5
	 YZSLg2kIHKGgkCO28BCeNE6AGfLeyrfM+iw80V8YNa7WLhUHTDh5IqA8VgZAjUJFUXiUS
	 y7sk/s6YI/dbzhzM1SteiP+agyMwQ2euzkSIVnYMiXsiVb71LLoubYjY/HtlaKkbXIy+s
	 UGbF4/1Lc7qY43Z8D0BYREObfX/9AAli+5xLA4DN+KXsAy4QATGAVXTyk0xjTTQJ/nNG0
	 3im2DScGScplRljRjcRwn3tntNUi1PJZqToTd4hCXoA8yO/+r3YzWhRJ8TlcB/o6Pdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795811807;
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
	bh=ZlW8XgLYuYw2AJQiMJ88+cdG/e2N8IMmxYLOkfWtqTQ=;
	b=C3d0ToABxBGFUvb05VMtQbEWM8RcHtW593usSq+TuwtyfopbT1z5SkLhAJD7L+vZVGOj
	 4N8DkLK9gfTHDFE11pe7sLClW5oXv2Kd3ALMSBgBvIheDa1I1jNNc2zaFFnAEhPzWWFnD
	 9E2fhKw+R7Y7JXnr9a6cczM4Udo9PmqrepSFm+j3BVXAaXXA4O1734/2qJRV3DHuJy0K/
	 rksXWWW4KEfskzarYxMKCnZE5ovqJuAtwXE3X9guaIG1NusYDxpqdbNg5tlwt9BItCIGF
	 KO3pZzjW+Ivy6Gg1bJ0YDe7eM46WyWT6tnySEGSycTlUk7hYQkQxBDUjdZ1s1zHsVYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ddn.com;
	spf=pass smtp.mailfrom=ddn.com;
	dkim=pass header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=YYEtMifq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.222.82.124
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76170606A31C;
	Fri, 27 Nov 2026 20:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76170606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ddn.com header.i=@ddn.com header.a=rsa-sha256 header.s=selector2 header.b=YYEtMifq
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021107.outbound.protection.outlook.com [52.101.57.107]) by mx-outbound19-1.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 27 Nov 2026 20:36:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQvLFmcVZ+VNOPB2S/Fx/hBTfXf9RIqzi6UtBFvmGSW0muAMntK54KqYA758Dw2zzsi7MiKkX/nW8Mt+jwSjaYFNedWrp/+efBgo3gj6mdTUribuTMyGUURYhRyKmAXVT/+65xwrWl6hMDMr7jB+YaZo+wBuQffW986YHDlEL1+dd/HrLHpwYP5hJsoUGe/oPT8bvNcMD54XLuJO4niOPQPChvK6QAZN433YUXtlNsgUQ/nQXYpVR7N46iJXJINGjnBSm26Herd0zVx6mlam3CvOjxbABa9eCn136ju3d/djpUfMNB4iHjbbU1jCp+iGDs6dGIi99ApnJzao6d7R+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlW8XgLYuYw2AJQiMJ88+cdG/e2N8IMmxYLOkfWtqTQ=;
 b=iRJfwvhdjN+00EFzZptjx5zmZPQfP1/+kZji2ooxw/Lqi5FEhozVdy73EJxVbaBuzV2OgVQys301l8UCxzj/VjMmuMTxWYb+0Nitkaw8/LbLGMRMBcIB7LdMWOnmgQQiOriNDF8te8QtIpv8S+ptvTX9qt4irVBwTqrvQZBmMHuT0aSkLVVuaDz88b36jF06ck2veW6w7gI+ssYIVFBihc/5w+cCSfTFzapa3nfmso85xDvtsPG2YhWb8iPqgBtbWqJjPdV4PDVNE24pTptbhaU1k0HmgYwaxcubbIdqHpDARYmtN0XyvgVAqusceER4cxlPVwvAmefq6uBiY8g6+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlW8XgLYuYw2AJQiMJ88+cdG/e2N8IMmxYLOkfWtqTQ=;
 b=YYEtMifq7kZ5p/qn5loVgapQYJBondJwYeG1h5SlDmSMabge9A0dIl7cbZFQiDwGsS4feMwAmLZO0pwTMGumdKPMOBR9STWtw4pl6Sa4phZn3SS+mMieb6Ocl1w9GgZ4ABRUrS9c01+CHqz1fe1VAQQPNtY2eSLgcZjtihttu30=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by SJ2PR19MB7578.namprd19.prod.outlook.com (2603:10b6:a03:4ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 20:32:09 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0639.012; Fri, 27 Nov 2026
 20:32:09 +0000
Date: Fri, 27 Nov 2026 21:31:56 +0100
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
Message-ID: <awnovA2_GjB8ETZR@eaujamesFR0130>
References: <awcn1-LpcFgzRKgq@eaujamesFR0130>
 <20261126144122.3886594-1-dtatulea@nvidia.com>
 <awljlARPJweYKIZb@eaujamesFR0130>
 <5e95879a-0b9f-41b9-be6d-c91a1c5c0666@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e95879a-0b9f-41b9-be6d-c91a1c5c0666@nvidia.com>
X-ClientProxiedBy: PR3P189CA0082.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::27) To SA1PR19MB5570.namprd19.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|SJ2PR19MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd24dc1-b258-4cce-f370-08df4cc582a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|23010399003|10070799003|1800799024|376014|7416014|366016|261102123227099003|261028144727099003|261022105027099003|261021121427099003|261026121527099003|261026140227099003|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003|6133799003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	yPbpFDZtstS05TtTD9REJqzoA/bVY3Nup9CXKN8wT1hUoiTEzWw8KIEl7nIJ6JzlcIQ07Jl5NbEx1V9yzLcBfv4f3HkV24eVskjUKETfR0QGaAJSePaI0+PBykIXMq21+WsBLivVckBMoxQCjwsAdw3zFstxsQxTecYlZe35sPFtVYK13B7ZhcAhxNix8qR4AhzR78FfvUk8n1GRMGYgretWX7Q6qTjA6lMwNNQH1l90GLWT9wxdHe8UOjsEXpiK7mRqoKaZZOc7wHaoll2Wkc0dWoHci5iy9cQtwSJnzIUUlb9m/coVWi0Go3UOcRaYEWfUf/f3EPeWigEDuJMD9sxk+O/AIsbkFuN5r9WOwqLaCxqcZWZEXdjD6EUS8yf553+i3dXLuMccHr2O+vGmlJevKCHpxnS3/QexniCyLy91fOwUbLGphm/43dFOgY8NHhZvydoLzOy7jQr0y0ZEqI2yq/TW0+c5zkGg57RD4MzvU5nunW/3b0X7M5ztRocGkn4TPWlZ5Y7Ih+85zjLvk3AGC+AHGqe3F6stUTspaOU7hV5wmre1agO31I1rAtyFbDOMwYuk9dn4z7eQtRBDnXEJa0jKhMG7ojRmRqKc7TXc+qx/LpRapzo3fTNZUbsqDcpfa6Bm0yyxHa5gcmslpSY1HtLp5Z5hTtad6mkE+Sc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(23010399003)(10070799003)(1800799024)(376014)(7416014)(366016)(261102123227099003)(261028144727099003)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(6133799003)(261009223027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SmDLpGTVf0nZtaJ3rynA9J5zYeCSDZrcUz728Rn6rpMzdJ9N7Gq9FsH7D1Qw?=
 =?us-ascii?Q?hcdIKdZ/KG0IldJLo1UqCCrCDG7St0UcA4Pt0LsuAsPxbRItW/6cLdcfj2ly?=
 =?us-ascii?Q?3h6kDH5z2/tPVUYnWEJWrhYWbE2RqjQhpOEdbIeMSO0RuKccSavggmn/7oi3?=
 =?us-ascii?Q?y0sIbjlK5DRHC2ZJVfWAUNeBRNK70tR4bIfAI7l/bn2xF/H+6COPBEZAQDWK?=
 =?us-ascii?Q?uKe1N1DDy/rCEyGJUuHMOlWEaKTwc4njlwc0Q9U9SXWGIUb/TI/+5qZK99ky?=
 =?us-ascii?Q?C/9LsmJdWwU1PWcbdDsTdBWTG1BkeiZimciVkfDE92RuQcxATJCR8V8eeS0q?=
 =?us-ascii?Q?u3O8NTraA0kEUjQXuBke1A4jhA6QPL7i8s/1g5E9HgcokYrfmt1yLtztK/OK?=
 =?us-ascii?Q?lS0BLv4VD/iT5hHowobqfzMBYrhGisvgWnYIW2MM9HMY13dvA7I95DleKDQv?=
 =?us-ascii?Q?qNZzoD4cPNVgPql5AHs0ccV7JsizbzTprk9WRH40z+mxutLRc9s0tZVVJrNn?=
 =?us-ascii?Q?n1K/durq6a0OD65OZCDqQKsGlTSSou59q+lBoG/MTgr3nABOkkynRsa1E40i?=
 =?us-ascii?Q?wk2K70kbI4K5l1ZUdGXuMT7FnZTaeJsx4Tf8RcP9QtkzvFboWVpzG7jP1B3s?=
 =?us-ascii?Q?0cDg/eHzyQuGm/PKO2jIAOeh1iGWL40Bui1WNzhr0rIPCdNjNtGMm1uQks1i?=
 =?us-ascii?Q?SP6EbtchJ/6t56eFiIVIW/f8W4AB5zUQg62zKQgpNHJqV4ZkXTdoiVVDmtcS?=
 =?us-ascii?Q?LJ6jG5pCl+e8tUSr9aZGuhXtTm3PvN680JxDKJfqlQWZs3G4lE796AKMpVLH?=
 =?us-ascii?Q?vLXqInxiQegYaoWxNotQ58gf/sMVM8kAMO1EuPz3sdcl+w0ubVZUyANwxgwK?=
 =?us-ascii?Q?S5nBtoSnZ0xkDwC4DJg+dZ2UrlCfGLpVX6FFbCLX7g9GtlytAXU/W4z9ChHa?=
 =?us-ascii?Q?aiLNGXmWy8V1uAoOa8zHUwytvyzT/dfPa28uWAt3IC+2n9rZA64lJG1Rak6f?=
 =?us-ascii?Q?me2ZqxQO5LVsN/k7X/cUCmWcwFiJ3bGY62BMOk7INO7LeBUbtNKS85y6lhA8?=
 =?us-ascii?Q?TVEisTPs4SU8CxStyiPa+9h8OzwhA6CCjqmXt35bWHIKQOAzbjrstY7xSSsh?=
 =?us-ascii?Q?R5DGgE8vd/HnJbiQyV7A6ZHbHPVoDSaLViG2RM3gtSt9RgUsVau+eGT8hA2G?=
 =?us-ascii?Q?+FYhVbxl/6lypFBHGWtiZIoMBOjTz7rzeUhBDaCOkdhTnbJJz9YAazJz9aW4?=
 =?us-ascii?Q?IN4iEt7/Hl4+pOlTzHEgHK+rVnr5JCdOFzYCrhbn14Aqd/uMU9s2rbxdUeq1?=
 =?us-ascii?Q?g2II44rwfhUs1v+Dh+RxErfW+vDcS6FuZE143BfzxKUQXDRrN50POHTqtTSm?=
 =?us-ascii?Q?vme0fLvjV/xP2xzhuwio5TNE/lD3bM/AVn8Z19aT9Nz0O6AniT+i9KBLBoZU?=
 =?us-ascii?Q?dblFlwWxqfXUUjNskVjb5d8q2Iux7t+qUiJc5Kh7hbqRgIxbs+pWWRQWl61e?=
 =?us-ascii?Q?o4OpWGtrubzhpa9zVsJ01gX5ZMZxfbZhgMg42Ad50GnKNCPyK3Eh3NbFrmJ/?=
 =?us-ascii?Q?XelsIsIqExRRQQF8Y10sJGFM7PrY7sl8aApEgzESnPJmxYsfsJRhmlAjGd9M?=
 =?us-ascii?Q?wiYvQ4Cntct7HBGZ+cAHPaPgUtBZbpiyz3eu6aRVcvqMOjlL5FUNzeX9FKTy?=
 =?us-ascii?Q?h6A1QoB5Jr0I8Vcyr6o0hBjpW25mQjHIEVrqvupHFDNGWrxtV/DqW7HG6gN+?=
 =?us-ascii?Q?6ofZM0IacTCsxEMKrc/FSyljOdYnJLbrIGYuHhc6DnVcSnu/VYU1UJyQEDmw?=
X-MS-Exchange-AntiSpam-MessageData-1: 5pLWrClArT/NsQ==
X-Exchange-RoutingPolicyChecked:
	JH5RB0P1PAG6AflGc3lA7vh8yhZr5+gYcOS4HOyr0JY25zMwRrpFx+bleK9GoAllROI972qDR4I48Fodk3u0Rqk967uLanqW/EzVMbLdV2KyjEutxyYVOaRWH3MLfWshBqDN4wA/jgqpNYVwBr+x93OzErjOpQxLCBX3wdzCjQCUpID5D+IMy7MgCnfv2UJnjbdOef76WxNCoX11iBTqPaZHF1Pyk4x1gQ4flP8hqX7VKwZqMqAgFcFEqGjDQ+/Q9bmIoH6MybGlWRw68wTpRVganJAuu5ED/tTvWKSxCLROC+NFQrdLLp9WAxP3jbbHDgQ1ccjPFpEdv9kE2lR2fw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	psQl8h3NSfr1PQg/bSsx4ossXyUHPOTFNr9UsiesUg2fe6lQNo65LWh1Ahe9W5uhnPwsK5UR8lZtcBt1gS7M3OhJvZW3LiQ0sBuiuS/U2xYPhHWnsKNT7U3P+xa2bAXE6bhIVm8JUb88eiWuXkxRzr7mN7GdMyvuzi7Eh9rp3AiU37ne31vJ1j1HiC7rKsq9TwDSnCAkaFkL7f4Jk4tjQy8T6euGGNfWbAXU4/CgEBJa+rr/GlaskuHW+lY+7haKFXg0MOoJQ7RFBRDV2r44nBl0nEM71LZYnVJNmjyY4lsVcbBWgmmni6dJ3aXElRDCoY3K10QcBFkNKkbcNVhoNlsyQfpsfjMRn4k6Sm1ml+9w7Y7w00U0noBH1c0B13+SCmwNOGtAwfM+09suorh1Q11bMUWNeCnTfykFvXpg1eLaVqb8orp+paZjCD1m0626Sr/6bJGjhghE5AY4RJxsspRuTmAfb2ne8TmzFNW922d9iZRiaFqGsiot8PXvRwODxTqk8DUD5V9Wt1HiqHoFNhsvw9PaOMmrDI59Bf8RiEyZoikVVQZ75AWmbboL1FccwdmKgm/voEtBEimo0mdxwLDXYr1GGaO6VYtg/NXDXjsoFsm00PfnmejYmno1EZaY++7oU4I2ogdQY5qWhQB1yg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd24dc1-b258-4cce-f370-08df4cc582a0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 20:32:09.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwBIv671aL2MIFNbAY6iGlNN24HK4dTOhfUfavtlfP+/G513zF+adtZaA/wTItRM9nEdB9L8fz2myl5zsGsCCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB7578
X-BESS-ID: 1795811773-104865-7825-2074-1
X-BESS-VER: 2019.1_20261116.1548
X-BESS-Apparent-Source-IP: 52.101.57.107
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaG5gZAVgZQMC3JIs3AMikxLc
	XE2MTS3MQoOSnF3DLRwNQgLc3CwDBFqTYWADR/6O5BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.277890 [from 
	cloudscan10-225.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On 27/11/26, Dragos Tatulea wrote:
> On 27.11.26 12:03, Etienne AUJAMES wrote:
> > Can you confirm that the parent channel count cannot be resized while
> > a sub-interface is present (whether UP or DOWN)?"
> >
> True. I had forgotten about this change. However, it is still possible to have
> a parent created with > 128 channels and the pkeys created afterwards. And then
> you can run into the issue again...

I am not sure to understand.
Are you referring to the following commit?

commit dbc94a0fb81771a38733c0e8f2ea8c4fa6934dc1
Author: Dragos Tatulea <dtatulea@nvidia.com>
Date:   Thu Dec 8 09:52:54 2022 +0200

    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

    There are 2 ways to create IPoIB PKEY child interfaces:
    1) Writing a PKEY to /sys/class/net/<ib parent interface>/create_child.
    2) Using netlink with iproute.
...
    This change adds the get_num_tx/rx_queues() ops which allows for
    interfaces with multiple queues to be created over netlink. This
    constant only represents the max number of tx and rx queues on that
    net device.

+static unsigned int ipoib_get_max_num_queues(void)
+{
+       return min_t(unsigned int, num_possible_cpus(), 128);
+}
+

A child interface created via netlink (ip link add link ... type ipoib)
ends up with min(num_possible_cpus(), 128) RX/TX queues. The parent
may therefore have more allocated channels than the child, which would
trigger the same crash in the receive path.

Is there another scenario you had in mind?

The following guard should prevent most crash cases:
31c70bfe58 ("net/mlx5e: IPoIB, Block PKEY interfaces with less rx queues than parent")

@@ -168,6 +168,15 @@ static int mlx5i_pkey_dev_init(struct net_device *dev)
                return -EINVAL;
        }

+       if (dev->num_rx_queues < parent_dev->real_num_rx_queues) {
+               mlx5_core_warn(priv->mdev,
+                              "failed to create child device with rx queues [%d] less than parent's [%d]\n",
+

While digging I found a related problem in mlx5e_calc_max_nch(), which
sizes priv->channel_stats[] (max_nch) for the child:

        /* netdev rx queues */
        max_nch = min_t(unsigned int, max_nch, netdev->num_rx_queues);

        /* netdev tx queues */
        tmp = netdev->num_tx_queues;
        if (mlx5_qos_is_supported(mdev))
                tmp -= mlx5e_qos_max_leaf_nodes(mdev);
        if (MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn))
                tmp -= profile->max_tc;
        tmp = tmp / profile->max_tc;
        max_nch = min_t(unsigned int, max_nch, tmp);

1/ It subtracts the QoS and PTP TX queues based only on the HW
   capabilities, not on the profile. Commit 1958c2bddfa2 ("net/mlx5e: Add
   profile indications for PTP and QOS HTB features") made the txq
   allocation depend on profile->features, but did not update
   mlx5e_calc_max_nch(). The IPoIB profiles have no .features, so they
   never get these queues.

2/ I am not entiery sure but I think 'tmp' (unsigned int) can underflow
   for the netlink allocation path (if the firmwares return true for
   mlx5_qos_is_supported() and for MLX5_CAP_GEN(mdev, ts_cqe_to_dest_cqn).

Thanks

Etienne
