Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013008.outbound.protection.outlook.com [40.93.196.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AA13DEAE3
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 20:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786479343; cv=fail; b=b/7sBcc2SfuexbNKhy9aM499T0X9kBvnGM8Hmobnx/hJ1ieIwtrjwSK9xx6U612h9AF/ENJa4vmtP0GoD2urcpKXKWU/mzD2ZdGFEDd13Dg7aKWD8a0KYPl1kjU/uQvLrHcOiCpHrx8xBJ5fbf54xsxzTTc56zo8xWIrA8Mlwl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786479343; c=relaxed/simple;
	bh=31XnDSc5yji9W4Boq4lus/qVD0E3P4Xb0mgGFcy5fvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NcSPZXbUo1GbfCuci1WsOM0QiHiyP0DJBOdGXvNeAz6pnnTafmqDAwtxn3kSzH0vJxbe/OSBMg/fwhdWKvjP3K78XUefTceEfNupI6GRQghtCRN6sxNCDIUFHEe0K266MayU8CVdnQTb+reHrDLe9dYL0YvzDncSZKIs36N04VI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qe8F43RW; arc=fail smtp.client-ip=40.93.196.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qe8F43RW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=omuYawr9PNBSPC8UfKNL1oBhc0OuprZWO90dcjm/UTFLgdbBeCsDaW2wO4u7PrqNneFru6f1YyLVTRVpL2vU3oZuDeR1Iqt4La/TwOKHG5LOiR51b8Au5b8QlkcOLkTIwzbCTsfkpwpJsUCinXdPnQLbObL93w/TvwqMWowyYAsXeH5RVw5q4Q7bCVFzk+q0RYXkHFpfxXZT+SOPx2xXQOmmhKe7trCP8buXiZla8KR/+QTDZuFap3VRo5W2WlTalTWoM+5GlkZ51BRR+vT/m1kWubTzl/2u1XOKOGKUIMMA14bEjQ1gYbPYJxBk+8dab4WGa3pb9jQE9Nb43LaOrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=arr4k0M/n16IB7a9Ctv0gKZ3UEukYuNs2FT01v6Rei4=;
 b=Z2lc7O/i3SBZoq1sQal47FSsFvxT02jcgS2gUcWiMRZBm+36RbKzSCRMdgXpmvo4cuBHEJC835id3WWHOgwYxjXpy2/c1A89Wb25momXupf54g+e0pB5NW3GvDo5T0FdlacA/j0puCYKefmIqUQLML4vLsKiCx/6LFqdtR+hGxSUMTBO9lWVpYACXYQ+vM2v1GGR2x8euJ+YR+QsY4V6q3OAiWWPVagMji4JxKfkPpAhJOjquC1G2+V1oUMB4XjBfG2m3A0AOUgFo8xMvIEBzX+fQX1oL1iY1nBsHjwzBRjVK5IUsvVLfA0TlnV4VpyoL+ii8u8CJleH8PfmHnIVRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arr4k0M/n16IB7a9Ctv0gKZ3UEukYuNs2FT01v6Rei4=;
 b=Qe8F43RWiieOApCLM8CLpfujZkHdRGPZwuENoHTUcV2xfPoDr08kJ2ir45YxvMuOts5B+16Mkz9FKJ5pXEjNfKCmfD7p+30JLtFZGHgppr/7bt6INjxqwl3jkBQvtevj3/NAMdTptL2zLfNIFiP/d3etJotNWRLnQxh3GS1hf7n64DU+YQf0BvhHhTm5XxXUsEzRXXAn6zCsDAFcQF3ZUGqI//pKUXdWLLjg2JmNb9R7ZXEJSFnjXTKwNDu1FjTK8WPO06sh7eklk1cBqEmZI3gCekfD9u70th0CLUCDyIel7Pjl1+42JnG7FeGnfQHGAdLpsINPDq8vEwULTVTuMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Tue, 11 Aug
 2026 20:15:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 20:15:36 +0000
Date: Tue, 11 Aug 2026 17:15:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org,
	syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 1/1] RDMA/cma: Fix WARNING in res_to_rt
Message-ID: <20260811201535.GA667435@nvidia.com>
References: <20260810220123.191696-1-yanjun.zhu@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810220123.191696-1-yanjun.zhu@linux.dev>
X-ClientProxiedBy: BN9PR03CA0881.namprd03.prod.outlook.com
 (2603:10b6:408:13c::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: f47fd9a4-d445-46fc-a913-08def7e54ded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|11063799006|10067099003|56012099006|5023799004|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gVAsEdSChBGYY+8qt4QY4d3whYP6E08Iv9Kbbqd/w3FWnqAwSkOLw+jnrfNe5hqKPUEM1wcG36AKLmKcTm8Vfe5AUvU8uqR/x7iMPz7FL8t79s83XlroCA9YBiObwB88KcqPvHbOD/2rryH3BMR0Rzl8+zA1k0ENi+DCSb5/eYhNUjdvAMWfUUKDZ+2JQ9H8rukeBL/mNAUJVsZYDmpgnJbLMTJ4V8KHLSNJiCzuMuEOQxDetT/tuRC2U9YGemmcEqfEV7K0eSTSzZdIesuU8N4WDeRAtev40feo5kOkjbDigU7fYReczpqCtZhXIsWiI1t3ucuofVm3zDsaU2tuQ2askCFDTnHV/ScOP4mualNqDKy5qF7r+9kpNT1IQEvmGXh14Op8hi1LXxALRrxy62W3T0kt5gs5xT6/dbHK9cDpSOipNNNCNGYdwqHmS52QEkHKOMbLnZUOj4TwRf007uMyVo3bnsZ0yP/X3OTnfk61kJ0fuNxNs+HcQJf/Jcj3R7zEfVUc9OKlt86qyUB/Esez5vOCeM0SPxcCR9kq9zQS+oscFZjbvaA/7WNDe5yI1BiX5BbNz1NLv0s38vwKrqpO5zKTBMX7gqkd9vHcP7X8nvgLFIbTJhIRHGzR8M1qOv8nmETQiLE4S2hITznD8iu0LPHLwDm79g2Cf3B9NJ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(11063799006)(10067099003)(56012099006)(5023799004)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zhql+WnsdSjow5qSYI+JdN13eOIp3rhmgux+alamg4dwQoVVewCtPl++WoGx?=
 =?us-ascii?Q?YBmX0pPR3XpzhTGxVFHzm6OtkbBro2LQAPC+vP4tob7e/xqRtYFjgkDWLcUx?=
 =?us-ascii?Q?tu4hxw/DoC8puAWWLOBwFmh40FZvhYFSqcWOmuyZP/Q4Sg6LPHi0hInvVNWm?=
 =?us-ascii?Q?Zsg66e6wysrjR3JkO+pbYSzwE1vq+TO5y7EzqRoHuEukRDDcVOi3GVtPUC/4?=
 =?us-ascii?Q?vUqRqDhfoyQD6ty9fNPNlFGqzHIXMghN7Gr6xUsoRjqkQnwjgaKHlV5vb8/2?=
 =?us-ascii?Q?INMYR9O2NyV4uCcXmiKHMqiMiowG5+Hels+bSsCW4u9xqbaJo1lr5S04kzCQ?=
 =?us-ascii?Q?DA08Lccp5SRp80ynKY61U5EbAx1gOGSVvVebkw0wAyzveY5Od9JwdkVSFNIw?=
 =?us-ascii?Q?XniGcKJCgpN+LPxvzsdZ9kUvIODuV4eICAznTd+gRYxw9ZdOq9fl7wZQ30Yd?=
 =?us-ascii?Q?XbKiPo9s6EX/DQ+R16YGTLciSqojwNerySa1SsynCihhLpWvAityIBJjf4kh?=
 =?us-ascii?Q?9y5V5EDEvuHOY3EmXZE/NVCmLvoKo+HXJNRbVzo01w+oaFcehS0wBo/Ns6eU?=
 =?us-ascii?Q?sXhtHOsMmp4ibaJ4n0ozsFkwdMG0IiP9OKu6N6XKIXL2Io7YgokZl4NUFblP?=
 =?us-ascii?Q?w5d/zlMox7J0N5msv5KcnFWsN1FNOBxrDlgETuOTHInqiAhep2xB57X0gegV?=
 =?us-ascii?Q?W0DhGSv+CzVjX3UdGLrBfkXAT6Idu+3r6XXVQl32EKT2s4nN6fm4kbyPE0w2?=
 =?us-ascii?Q?u7l8TCJDR+yiBxVc3Wj230SStiF1t7/7F9COQMWCqiMk28GTI52fnFM+LmDf?=
 =?us-ascii?Q?36eUpB//opGtSEtYxT2x3Qv2dLOvUMQOyXhYKpTEfUsOO6XvaMrxZklzJ6sm?=
 =?us-ascii?Q?fO8CgJnL4bLxw7r/nJQc6sQr/5oaPeB01Q4TrZ8lObgW9k8ZeH0BVUXlTthP?=
 =?us-ascii?Q?N0bsA+OOaS/CIdZ42wNfaVmWbc0JNuCELQ0gh0iOzaCGOD1t2SZg/0TsTVry?=
 =?us-ascii?Q?p9F3rO3ZMT54ls84txu9T91NetvYNt7Danp3oBmbnpKYw93rB4sZ2mAlKmus?=
 =?us-ascii?Q?7jlhdNeNuL3qOmTRFGo42Eoghbmz1bXlmL3y+wkErclQXOfYr8z21Iobw0/T?=
 =?us-ascii?Q?Pr95YpMDuCykTSwfz2D5rM9ORFh/9vyfMysmrhdEsWZ84ITld0z7UQYPZpTe?=
 =?us-ascii?Q?rPYQ+7RtRLGfhNdWoT4yadNx7NRzhtuymMNFpF9+rcExOIL+uCmRYCzQLHMH?=
 =?us-ascii?Q?8yvrcvf0iQRWfd4pJ4Cq7dQUuWVV0HNLF6PRvBx6KiGkFmfk1zW95AhvuNJa?=
 =?us-ascii?Q?lu9oI/TDmWb8TteGRDgYCzvS0MnfA5aKGH65l7HcrcSlRcDixUAOOttqrZ52?=
 =?us-ascii?Q?qxBIg/lQPgB8dVkCeycnZA4ta5lMfUn5EYiQ3lq0V6rc/E14z955P7HoBMbV?=
 =?us-ascii?Q?nY8piR0WG01Wvi9kCclCKhocyBvYkrz4qSBYCDDSRZKKYMGQMYV3R0xqRUHq?=
 =?us-ascii?Q?Utd1XKMtciWOkewc2NJQlrbEvS68jHlQp3Ws8SN/TE5Zqah++BA/0C7ats3i?=
 =?us-ascii?Q?rJsK/OxbKX7lgKu8ew8s2Q4sKaDSbZwFCQ4XpBUgoRJsBFCo9owgWScPZsW6?=
 =?us-ascii?Q?0aEcB/qnpF9R3wl8CJlIJ6dA86zlZvsbN0aKKbgW76IW7uGAk0C3Rt+Pxz0e?=
 =?us-ascii?Q?R+K61Ox6qPekUvEoVBE8GeJa3TPxWNdsyMCROO/L05IVegQzI+gYbJF8+UNn?=
 =?us-ascii?Q?KPevOPqj3A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47fd9a4-d445-46fc-a913-08def7e54ded
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 20:15:36.1810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbpjjjA/jq3OPrTUuT9tTbbcofycYXvPH5wjBzs7le4ARMyvvyR+7MUwFY0zotQ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348

On Tue, Aug 11, 2026 at 12:01:23AM +0200, Zhu Yanjun wrote:
> id_priv->cma_dev and bind the associated ib_device to id_priv->id.device.
> If cma_acquire_dev_by_src_ip() returns an error (non-zero status), the ID
> remains unassociated with any RDMA device.
> 
> Previously, rdma_restrack_add(&id_priv->res) was invoked unconditionally
> even when cma_acquire_dev_by_src_ip() failed, passing a resource with a
> NULL dev pointer and triggering the WARN_ON assertion in res_to_rt().
> 
> Fix this by only adding the resource to restrack when acquiring the device
> succeeds.
> 
> Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
> Tested-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com
> Fixes: cb5cd0ea4eb3 ("RDMA/core: Add CM to restrack after successful attachment to a device")
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> ---
> V1 -> V2: Follow Jason's advice to use if/else to handle this problem.
> ---
>  drivers/infiniband/core/cma.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Applied to for-next, thanks

Jason
