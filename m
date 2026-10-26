Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993136;
	b=Qjdqa279yoIuQtZyXTELIc5OfXU/JRRkOTJ6gWk44w7LqMVOHGyzY6IqlUMNGreh9EZP
	 uaAHq0Kd1I2PZwMAyaipy/zYhNx37GkFZEu9tqKvOQsV2xI++3/wQHuyLx/9AZRiTVRpL
	 YR3Cf68yTszFXZ2Plp6TyDAn9r2F8Zqrkl3v/0iTg+1ctEFiOGknjJIhZzB6JEa/WT5w/
	 OsnEH+4ITWy01+uRgO/d356xn07x4wA5X0ZjXVJR5z7+DiJ6cDARpIRnfarBsSaSY5b9Y
	 k6s1kg7aBQJT35rPncyMLgA83A5/g4zBplLQcLKpxYjNC3x8Q6N1PnC/SmJlHgMos2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993136;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=D2tcbimZRdK8rXHP4wNz5aAiHuIflYB7qa0Frayw9QE=;
	b=r32YrFl+a8GD73eUq9LXI5VW1f9gUA2n0pzSfbnicf3e+xU5NLpVZsEXr8CxBg783E4x
	 A4tMR9ocsbtYsSzRXBYfyZicdXSBhMbWnI64wUnSUuaBQC/RLFfzhBQeANojatHZ6cn++
	 DgKCBtpiFl/azWMYxFximAxtSSgurGsw47OJl1JI82T0AJTNTD+9kMuiB4nmj4+uZSkx7
	 r1ScbCe1kWwh56zK3x8+6pn//LDIHygkt19JHOzguR9c1T9lLBmraSMg+xfW2GW3pI78p
	 idGXkRnCmerrvCY5gjhu17S0N9hFZWGU6m8zoRH310vUXBbjfjDLiNM5SxnO8/K4UNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MqZ9pmN9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.32
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E360A3812;
	Mon, 26 Oct 2026 05:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 556E360A3812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MqZ9pmN9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JK0W/hr4uTf+8sf0Kf6iHq3LBbqAoBw+RH8bEzf6ywnrgY0XAoR6z4Mew3q+4d0Gl/sPdpcx5tkaKHkX8SDlGSLScC9T9oI/wTO9qe68Ri9lmXv8uo5ztPHTi1RI9i3ANw+7HJ1TxXR2VQy/8rnFyMU0wlVDtZOaXan2LwpMX6ImmArvTOXjNhS+lDHh8QZVb7NUPRGXtYzcAJcxflR1rpGZTea7AwNsHeV1ag0LN6GWGVSkANpIIG72qOu0zBjo4eiyQXEL2rgdf3aTuDSbDDRalfxcEVHDv/MPDB57bQLwS+mOC9Lg3i/6tz+nCOsHisGsfn8VZgQ0WdcNMqmaBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2tcbimZRdK8rXHP4wNz5aAiHuIflYB7qa0Frayw9QE=;
 b=YCtBuxbB4lxwH5/tvFw7AjwC/HgahknCF/9jNOe8KyikzWPPOGkabdZLxZQby9aRq3i90SWF2qzHVWGAyfW1Ge9Qph/ETkqvmiZBei9Ix6M8f9/691zk5LaGwjw+5NCAwk0wfJ4MlelmO996AGSVEZUpJnRf0nnm4z5LP2B2UlAH6vlTqkeKp7iEf+P1MLneisReeQ1sipdig134/lgD3gkVnYZ/tGfxPq9Eunun5GsY1G2g1ji91m94d7qayJb4wPfwd3MgEURDN9XtJrLYL8ydUKUl3NPDaghMAuz3eFVVbUn4Mq9XS7qddm0Iw6KKdEKWTxYwZxGMOaLJvkcZpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2tcbimZRdK8rXHP4wNz5aAiHuIflYB7qa0Frayw9QE=;
 b=MqZ9pmN9Cusuz8ONtt96kcpa7nTeMo87W5xqp8eAZplARCU0ZJprR44FjVXmzSltDYUsr1rQTNaVY55pShX4m1t9j1fe3yqogTLI6FclTD7fMb1CyYiSgruPTVw4t6U/jwSogHbJXF0qLdVuGCAYC9+QTXOX1Mg3DCNiW7l3dF7vXPW0Ai7TjjYEuDP2IkPAgH9znufBQsxBQGmD3qEUay3LCXQmzJWIeSRvLU+gJnLT0nu5jhVBwdWQm6JyEowtHvtKRQqv/5GU1ki+CYCnBLhtvrHGK5iXoh2PLPlgxoLdwVat0MMvOPsmP/OBiEWUNuXQ7vHKOBlOEa+e4s3Gqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7296.namprd12.prod.outlook.com
 (2603:10b6:806:2ba::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:50 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:49 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 03/26] dma-buf: Add dma_buf_mapping_attach()
Date: Mon, 26 Oct 2026 16:35:54 +1100
Message-ID: <20261026053623.202642-4-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0172.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::19) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: da4c2d31-d6ff-47d8-0963-08df332321e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|261009223027099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|10067099003|56012099006|6133799003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	4ejcZdtvnf3MulKgszJEqOeMkiVtevcAW5O0OL0pLWENwkezPHgXgLVV0R4p8jb/soQQSVQ+vzAwYSf0kSulzE81j/aD5t1FRXH/zFiWioqiaiXU17e2sKh0p5ww7lqEC170Nr9cUO1n73W/KWGvL8Or16jNhtuIt7PfEngX7l8hrAiO5OOKaEDYxtoV4Ztg4jMyi0pWj4uFP7igoadt4EwM5x20TDff62l6THS+b6vG4/AOtLnB6NYsu3pl2t0Lnitkyja8sxfst3XfPQzyeUhDRh8FCvtCE+mzuxLqqWAdn6xQKSfMpaoGMLds85PQ4C7V9DnVQAYwwt1yfUJDnDeZzBlrFDnED1vFBOoLHM7rsn0n67zrZBt2+fqqeGhtO/6qgmew/CY5Y32kamFtPrcQ9ac8n+PjyrriDbQixhVGEaSZfYFvKNO+c6a5r2G95lltUKm4HyOz8YXHjxkbJO9GvudlxyR6nlFnb06/MvqbrYJkrHik2fMHZnU3mepl2x97F4jQ+ICqagYQfM/Pq5lmSsJK4cVjqhJTPrAHS6Qva92XIPrcbh/ai0t86xdOi4zLJXmSCXrMb/VvfHDswZAoEXPuGgy/AfYS4SlYyv7SkApXkDP+VNqPPHfF0oQVRc65wXA9Qo68N9IV0i3BN1i42l34kVI8ZoWN/oAsjBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(261009223027099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6B48QglzU08PdZWZILhNPwjmXgw3eaNzCePGjNaYOFXNvXh9lqbLxMyx4qWQ?=
 =?us-ascii?Q?pohEXE5tF5j8jwlj7uBwbcrD7fSa2FofFM8tPOcepufHGad4dEAyxKlOpAlH?=
 =?us-ascii?Q?kYrhRiEQtylrtulZru3vTwtKqynXuRSUu+tNCtKDRFSdDde4KFcuOgpnQUE0?=
 =?us-ascii?Q?mXnAuyAN1Ttqhxxcib8nOeEs3eEDRSjpIHh2VV0GIzQumMyusB4ueylYEXmB?=
 =?us-ascii?Q?gvjG8LLIcMJvPxaS0H0HaUeRM9lf2VUbZJzYWe1sBMgK0hJL6+O3j9FKb1jP?=
 =?us-ascii?Q?KsOko9z/JfQb7jNN7J5SK6JpCSbYG0l8m3MW0n09xzVSA+3AymIxpFOmxzZJ?=
 =?us-ascii?Q?JrLK9WiTRklKFkUZ+0XGgeKpI/OIdWfo5ahYt5EZNL0ZEjNghTzDG0Opv11K?=
 =?us-ascii?Q?u9liSb4jrndYtgnH7RFE+Ecfs8MZP2w6UILw+VE+0d0al1YUz8m88q9KaBIH?=
 =?us-ascii?Q?OtfxBZ1nuNfIsVKV0rrvY3+QyAefAqqWGaeSdIGm1d8lauuDolHRYh/9A1zw?=
 =?us-ascii?Q?RU9dviG3Lb/dpJp8A7qMCRT9GCOgI6iNM3torTsA1NNl9oxwlRSxJ14wv8Rv?=
 =?us-ascii?Q?TPuHFDiHI494SUWz4BbX5ni2aQmM03gZfPK8dm/9UalVqw3iWeasnD+JqhKQ?=
 =?us-ascii?Q?EDpAHboNP+eSgs4huj7hZA4FiVgps9e+aruCMG2W0Fygvpc3edZGb3mVMig3?=
 =?us-ascii?Q?azvHZUowm1Y1mLlzn+Rs7lstp8pk7VOcvo8YJTyHZdXv1gMeHfYWZp1ChDwz?=
 =?us-ascii?Q?pqHPWo3XBqcGotCb88JgrK2ff5Tfe+QTZwF6IzyVf4787edENvljVgc3SM/p?=
 =?us-ascii?Q?McPKiIvBlca/GDtG9VLDmNEs77VeKWeIRhnTYtnOraGn2YNIhEldvJntOVyU?=
 =?us-ascii?Q?DFQxM3yO3Ia21mmQC8m22nxPlkrQwcO2LBxJLbtNv1l+Z31edr+kBZBoidwh?=
 =?us-ascii?Q?YbUf8/TgGYPMYf+QmO6SAU26MjxzaJB0qvUZ3v1qhu48VHZV+zleFjI/rNps?=
 =?us-ascii?Q?ndcJP6WsqTTEkaxXw7dQL4sbJdbIo2eYLEmqoLNs6OkHSaqwVuWa7pXLHoYd?=
 =?us-ascii?Q?XZrqlOntE/WrL4st8tklf4phpLvxkwxfprAWCWKrH9QoXFzdoC6Fbj8sjXjZ?=
 =?us-ascii?Q?+KszornVgZlLC8WlEe2KCte8zewc5jCkUkizYyC3RWVn2NmqO0UPEZZvcqRI?=
 =?us-ascii?Q?Sqa6M/KazAhHxv6mAbEwBIqWcWhhGUTiOhbrNi2SAtTnJVStF1dio+/bva1a?=
 =?us-ascii?Q?IVqL4g4tzJFQlGsCRKU6OhKEL+J1Nc+xfW2evZuXzIAXXjg+XLl+O9azO9KJ?=
 =?us-ascii?Q?nIQbGGeI7K0qLTbS94PI9+EOJA/iJ0SjtNs4J79/CQ7n9cNTOchbgz6tRzXQ?=
 =?us-ascii?Q?0GIQ8sXwr16kDIeZ2qbO1CGo7KiCmhZogBt3+odbpgmeAw9EkMxEpzistPWs?=
 =?us-ascii?Q?mCbK6f7vvbUcZHyAmq9A2qz/svNkOC8jp2UdEX/1p+e+LRPshLBwdPW/rGeK?=
 =?us-ascii?Q?T/K4RecF+MDEeIswmG3mjkZA17aWUGy43js22ZdX8DnZFwxS+Xi/MUQtRcZg?=
 =?us-ascii?Q?W8xfqNZ/7NNshYfhOOmZJjID6VJkK4VbCG6WhgHchNJGc89HpxyNzSSiO8eg?=
 =?us-ascii?Q?N29aJcG84g5agNyZ7lnlxtRouU6RpXVyKz+ncn9MmEUAbeX1r3EJk4O9jSrC?=
 =?us-ascii?Q?HFQTf5ZrmfeSLgKBofMidK7ugUGSRzSvBNKJ943bLxXJDRKTpwB2p9kf62YS?=
 =?us-ascii?Q?dpyY+rzjAA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4c2d31-d6ff-47d8-0963-08df332321e3
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:49.7488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VD/hp8T+Mi7yK41kDjd0VEUfjZD3n8k41viSAhwu8iRp/MCmb0aZSAqEEpm3q6ThEjXPe71/LwgyEJ7Vh8PtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296

From: Jason Gunthorpe <jgg@nvidia.com>

Introduce a new attach function that accepts the list of importer
supported mapping types from the caller. Turn dma_buf_dynamic_attach() and
dma_buf_attach() into simple wrappers calling this new function with a
compatibility mapping type list that only includes sgt.

dma_buf_mapping_attach() checks if the exporter is mapping aware and calls
its ops->match_mapping() function to pick up the exporter match list and
call dma_buf_match_mapping().

If unaware it will use dma_buf_sgt_exp_compat_match as a compatibility
matchlist that uses the unaware exporter's dma_buf_ops callbacks.

The resulting match set is stored in attach->matches with the first entry,
the exporter's preferred type, in attach->map_type.

In effect attach->map_type is always available and always makes sense
regardless of what combination of aware/unaware importer/exporter is used.

The attachment's importer side (dmabuf, importer_ops, importer_priv) is
initialised before match_mapping() runs so that exporters can consult it,
for example to recognise an importer driven by the same driver. The
dma_resv lock is not held at this point, so match_mapping() may only look
at properties that cannot change for the lifetime of the attachment.

For compatibility with unaware drivers copy the sgt matching data into the
attach->dev and peer2peer.

If the exporter sets exporter_requires_p2p then only the following are
allowed:
 - dma_buf_dynamic_attach() with importer_ops->allow_peer2peer = true
 - dma_buf_mapping_attach() with a
    DMA_BUF_IMAPPING_SGT(xx, exporter_requires_p2p=true)

Other combinations are blocked.

Exporters that want to behave differently based on the importer's
capability can declare exporter_requires_p2p=false and check
attach->map_type.sgt_data.importer_accepts_p2p. Or they can declare two
SGT exporters with different map/unmap functions.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ rebase context change due to upstream removing a WARN_ON - apopple ]
[ rebase context change due to upstream switching to kzalloc_obj() - apopple ]
[ use dma_buf_sgt_dma_device(attach) for trace points - apopple ]
[ initialise the attachment before calling match_mapping(), reported by Karl Mehltretter - apopple ]
[ kdoc updates - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c      | 103 +++++++++++++++++++++++++++------
 include/linux/dma-buf.h        |  27 +++++++++
 include/trace/events/dma_buf.h |   2 +-
 3 files changed, 112 insertions(+), 20 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4c9add51f9ef..16a7fbb8aaab 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
@@ -714,11 +715,19 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	int ret;
 
 	if (WARN_ON(!exp_info->priv || !exp_info->ops
-		    || !exp_info->ops->map_dma_buf
-		    || !exp_info->ops->unmap_dma_buf
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
+	if (exp_info->ops->match_mapping) {
+		if (WARN_ON(exp_info->ops->map_dma_buf ||
+			    exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	} else {
+		if (WARN_ON(!exp_info->ops->map_dma_buf ||
+			    !exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	}
+
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
 
@@ -1007,9 +1016,10 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  */
 
 /**
- * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
+ * dma_buf_mapping_attach - Add the device to dma_buf's attachments list
  * @dmabuf:		[in]	buffer to attach device to.
- * @dev:		[in]	device to be attached.
+ * @importer_matches:	[in]	mapping types supported by the importer
+ * @match_len:		[in]	length of @importer_matches
  * @importer_ops:	[in]	importer operations for the attachment
  * @importer_priv:	[in]	importer private pointer for the attachment
  *
@@ -1025,31 +1035,55 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * error code wrapped into a pointer on failure.
  *
  * Note that this can fail if the backing storage of @dmabuf is in a place not
- * accessible to @dev, and cannot be moved to a more suitable place. This is
- * indicated with the error code -EBUSY.
+ * accessible to any importers, and cannot be moved to a more suitable place.
+ * This is indicated with the error code -EBUSY.
+ *
+ * This records the attachment's match set, i.e. the intersection of types
+ * supported by both importer and exporter, in &dma_buf_attachment.matches.
+ * Later attachments by other importers never change the set but may affect
+ * what type the exporter selects when the attachment is first mapped or
+ * pinned.
  */
-struct dma_buf_attachment *
-dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
-		       const struct dma_buf_attach_ops *importer_ops,
-		       void *importer_priv)
+struct dma_buf_attachment *dma_buf_mapping_attach(
+	struct dma_buf *dmabuf, struct dma_buf_mapping_match *importer_matches,
+	size_t match_len, const struct dma_buf_attach_ops *importer_ops,
+	void *importer_priv)
 {
+	struct dma_buf_match_args match_args = {
+		.dmabuf = dmabuf,
+		.imp_matches = importer_matches,
+		.imp_len = match_len,
+	};
 	struct dma_buf_attachment *attach;
 	int ret;
 
-	if (WARN_ON(!dmabuf || !dev))
+	if (WARN_ON(!dmabuf))
 		return ERR_PTR(-EINVAL);
 
 	attach = kzalloc_obj(*attach);
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
 
-	attach->dev = dev;
 	attach->dmabuf = dmabuf;
-	if (importer_ops)
-		attach->peer2peer = importer_ops->allow_peer2peer;
 	attach->importer_ops = importer_ops;
 	attach->importer_priv = importer_priv;
 
+	/*
+	 * The exporter's match_mapping() may look at the importer side of the
+	 * attachment, so initialise it before the match.
+	 */
+	match_args.attach = attach;
+	if (dmabuf->ops->match_mapping) {
+		ret = dmabuf->ops->match_mapping(&match_args);
+		if (ret)
+			goto err_attach;
+	} else {
+		ret = dma_buf_match_mapping(&match_args,
+					    &dma_buf_sgt_exp_compat_match, 1);
+		if (ret)
+			goto err_attach;
+	}
+
 	if (dmabuf->ops->attach) {
 		ret = dmabuf->ops->attach(dmabuf, attach);
 		if (ret)
@@ -1060,7 +1094,8 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	dma_resv_unlock(dmabuf->resv);
 
 	DMA_BUF_TRACE(trace_dma_buf_dynamic_attach, dmabuf, attach,
-		dma_buf_attachment_is_dynamic(attach), dev);
+		dma_buf_attachment_is_dynamic(attach),
+		dma_buf_sgt_dma_device(attach));
 
 	return attach;
 
@@ -1068,23 +1103,53 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	kfree(attach);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_dynamic_attach, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_attach, "DMA_BUF");
 
 /**
- * dma_buf_attach - Wrapper for dma_buf_dynamic_attach
+ * dma_buf_attach - Wrapper for dma_buf_mapping_attach
  * @dmabuf:	[in]	buffer to attach device to.
  * @dev:	[in]	device to be attached.
  *
- * Wrapper to call dma_buf_dynamic_attach() for drivers which still use a static
+ * Wrapper to call dma_buf_mapping_attach() for drivers which still use a static
  * mapping.
  */
 struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 					  struct device *dev)
 {
-	return dma_buf_dynamic_attach(dmabuf, dev, NULL, NULL);
+	struct dma_buf_mapping_match sgt_match[] = {
+		DMA_BUF_IMAPPING_SGT(dev, DMA_SGT_NO_P2P),
+	};
+
+	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
+				      NULL, NULL);
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_attach, "DMA_BUF");
 
+/**
+ * dma_buf_dynamic_attach - Add the device to dma_buf's attachments list
+ * @dmabuf:		[in]	buffer to attach device to.
+ * @dev:		[in]	device to be attached.
+ * @importer_ops:	[in]	importer operations for the attachment
+ * @importer_priv:	[in]	importer private pointer for the attachment
+ *
+ * Wrapper to call dma_buf_mapping_attach() for drivers which only support SGT.
+ */
+struct dma_buf_attachment *
+dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
+		       const struct dma_buf_attach_ops *importer_ops,
+		       void *importer_priv)
+{
+	struct dma_buf_mapping_match sgt_match[] = {
+		DMA_BUF_IMAPPING_SGT(dev, importer_ops->allow_peer2peer ?
+						  DMA_SGT_IMPORTER_ACCEPTS_P2P :
+						  DMA_SGT_NO_P2P),
+	};
+
+	return dma_buf_mapping_attach(dmabuf, sgt_match, ARRAY_SIZE(sgt_match),
+				      importer_ops, importer_priv);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_dynamic_attach, "DMA_BUF");
+
 /**
  * dma_buf_detach - Remove the given attachment from dmabuf's attachments list
  * @dmabuf:	[in]	buffer to detach from.
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 3e82ec59d5ce..83ab2902a23b 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -29,6 +29,7 @@ struct dma_buf;
 struct dma_buf_attachment;
 struct dma_buf_mapping_type;
 struct dma_buf_mapping_exp_ops;
+struct dma_buf_match_args;
 
 
 /*
@@ -315,6 +316,27 @@ struct dma_buf_ops {
 
 	int (*vmap)(struct dma_buf *dmabuf, struct iosys_map *map);
 	void (*vunmap)(struct dma_buf *dmabuf, struct iosys_map *map);
+
+	/**
+	 * @match_mapping:
+	 *
+	 * Called during attach, without the dma_resv lock held. Allows the
+	 * exporter to build its own exporter struct dma_buf_mapping_match[]
+	 * and call dma_buf_match_mapping() to record every mutually
+	 * acceptable type in &dma_buf_attachment.matches in the exporter's
+	 * order of preference.
+	 *
+	 * The match set is fixed for the lifetime of the attachment, so every
+	 * input to the decision must hold for that long: either static for the
+	 * dma_buf (the importer's list, PCI P2P topology, buffer creation
+	 * flags) or runtime state the exporter pins until @detach, for example
+	 * a runtime PM reference.
+	 *
+	 * It must not depend on the set of attachments or on current buffer
+	 * placement as matches are static and buffer placement can change at
+	 * any time until the final location is resolved during map/pin.
+	 */
+	int (*match_mapping)(struct dma_buf_match_args *args);
 };
 
 /**
@@ -606,6 +628,11 @@ struct dma_buf_attachment *
 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		       const struct dma_buf_attach_ops *importer_ops,
 		       void *importer_priv);
+struct dma_buf_attachment *dma_buf_mapping_attach(
+	struct dma_buf *dmabuf, struct dma_buf_mapping_match *importer_matches,
+	size_t match_len, const struct dma_buf_attach_ops *importer_ops,
+	void *importer_priv);
+
 void dma_buf_detach(struct dma_buf *dmabuf,
 		    struct dma_buf_attachment *attach);
 int dma_buf_pin(struct dma_buf_attachment *attach);
diff --git a/include/trace/events/dma_buf.h b/include/trace/events/dma_buf.h
index 3bb88d05bcc8..13d3a82856b6 100644
--- a/include/trace/events/dma_buf.h
+++ b/include/trace/events/dma_buf.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(dma_buf_attach_dev,
 	TP_ARGS(dmabuf, attach, is_dynamic, dev),
 
 	TP_STRUCT__entry(
-		__string(	dev_name,			dev_name(dev))
+		__string(	dev_name,			dev ? dev_name(dev) : "none")
 		__string(	exp_name,			dmabuf->exp_name)
 		__field(	size_t,				size)
 		__field(	ino_t,				ino)
-- 
2.54.0

