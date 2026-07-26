Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7502BEC23;
	Sun, 26 Jul 2026 09:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058223; cv=fail; b=RWnZ2cwNcWSmAQuYsr2Cum4AsOdwEL4U/AM8BA4zt05XzPkP82pBtgIU9NkVfB4ZwRhVeaxB73Byjn0+51La+ZaNzpO8i7kQSB8izcCl0EaYG4pX2xdOUcVI5laXll8CaT4x8j+oc0/lM1x/wQ2ga/hbBFz6V7wvjQc2VC77Wvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058223; c=relaxed/simple;
	bh=7mRhfbR8J7bs7KjDlyk4FI+fxe4FqemAgTeVu8h5eXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mWBql2uCr50705fCgTIlqWQqkjxnD1e1J8njOkp+nlCAwa5IMZhz6GMpXvgkOWEUkVifglM35xLnmVFNryWZiSOY2kYMhoeW1msrtLMSIWpDL9LxF4ptUHTl92SZhXX3gAP08iJF0NOGzXM521GhL6BRd9FUTyLprbCljh1cI2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bNUaLqia; arc=fail smtp.client-ip=52.101.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bNUaLqia"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzFOoAWsVr6eyUW6xJkVwmrLXL9fZuPda0nxVzDW0pZlgWDUUnSux13P5HiD71cWDe/1SifvAZhSzbEuInKCwS2DofbUqsaxM4580XupmSJ+jtpwhLggPE7tUQYPbA4VTUxAPjfCnbOOpgYOP/8VpxHVuUcUqo8WS98wqH8/h6/ZBfbQEPJRijwL/NOijq73ztz5laJHfxCJGhfwPDV9JxCLcKGcqB2rBuSSi4Gb3x2/hYvZLpABb2I5uIQEFTrxDtWY7Al3VzkiloriXzHtx6Z7mIO7O/4FroHkQMp2mCAkyVNqOkTNPGjW6+6+isGyswGqFTQqSRpbMs+QGId4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WY4s6/ysO6GGpZWgsqDS3S7i04Vvqt2ZcxYEwVApLAg=;
 b=OGXxpgErrNUTNas9PI4nXTbhl/SM9DFFZ2wifYokrViya8skmKAuyuzhEHkbAKh5zi+jqp748DYjbnzA+otG8R3oNkquJ++1QvInUMbsXVfVmSW2Zdn+cErx5S8cUel1jWQjczkXdEsFwURL397yHaJGT0rGN/S+jVmIeL8aZ6stwQJtrMT/FMiMMOw53Q7TEm7AuaS6LJSBGweiET8VUH4MELpgSIoH7KwB1bRz1uGKfAsXQ4DKO3PR9sugV5bEGBldG/jut3c8u18qtjH/LsPCc5JtI8K3dB0/6KeKlyTr8Tk76NxzsFG61J2/0CkUpbIGLx7dhqLAI9O2R4aOpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WY4s6/ysO6GGpZWgsqDS3S7i04Vvqt2ZcxYEwVApLAg=;
 b=bNUaLqiaJFcobAJqf3Rpwlxodn2EWCxKA9zl2rB7S/HAGbtLMSMIBYQkmRzsEjX64kNINxKkcP4v6SEtfBgXhQNBxMJ8+3OKfRli3OCdUaKQwEuqD/m4H4tEns/Sez2+rxz5PwFZ//bIVYMTmvEzJz9hQobMACuIy59m0HEXN2kCHdHm5pbDSPsAUeXU0YBQE+MHKbOGA69JUpV3UnE39zdB0S/U3XF1pNscR7P70eo6tXFRAAtUsRKNna6o4DTQu1TAClrmiE2VFl5Lhgsy3SKKHAVcJFcfqGHuVu4RWR+9OfVhiCrdAbncYo77dr3iA1Kw1qz8fQ9htqQupsMQQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:18 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:18 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 02/15] RDMA/mlx5: Allow optional access flags in DEVX UMEM registration
Date: Sun, 26 Jul 2026 12:29:16 +0300
Message-ID: <20260726092943.2880176-3-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0146.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::20) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 08bd4a4e-f40e-4186-a27d-08deeaf8817c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7y8Puiisb7CALST+jbG3LKvZu5DGmGZFcwZ/H6RoHoNPPVpF/woGPGMpxpaAowmfu1Z0V1aGhrGjrfI4XYRDkRPGBKIY1FRJXXNqc8e1S2sO2qMbSMQ0fGM9ReeqZ377UuQKqZp/vT3FforXWkC+RZqdyBCKfbxhE+VJKoxpCuWhQFFjheQFbt/S6IZ/FddWA4+T/aBZcGdx3WWQIxEGIOqfu/SQrqNyn3tlKWNTRz7tNAtGwb12Yrjk7bKBBUdqqqF1+7kHPjmrbYTX2FUoZ+7DfqOJyXYHRsgxZImCqN0oNv/BoXGk9P36o77n9RnoUl3KaNt1AGQZ2U3gwoDLMzqlJxXr0XU6CwH6aXVtR+vQTpcDlrWmMkJdxuH8qSecbM3CdyWwsOambu0b/wIi+MLrIPDgAmf1ipDYWvBhm2akb9rcWeM1yUIgG1xaL466t/4aoke/KXeSascCRnKenL9rtqA5a0DQ1bYm510wiNCfleK7kAvGivaHZYv4D88IVjQ6C1CsueTxBgGhdLLjrKPNHjSovxAn1NyoIZNILf/0D+Cpfku9/BPWO/wmsWm6dfI5S6qqpUBq1yDjsw/oL57kFq1Q9uSWrASft6voQP7JP8ZkI6Dfak5+iH/Rjl9OI6rcBiGZD9cYCJ2urBGzRPAT31+gZ6GPEMdUqE+5hes=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lm3Zfp/4rjs67DhGEMwiwd7rp3P1FGIuzdzANKvYQy/EeafT5ScifQ+3XMVJ?=
 =?us-ascii?Q?1AlhHANSwrLhccRRqWCxXiiqcBBojVyo12ozWJMoXK5BdZTXLPUBHjslrjtH?=
 =?us-ascii?Q?Fg1DMttiuAtLw8vGpEFzkYnN6CkamRJOTZbs/pgprmz8Y0Vwopqo2JsREi54?=
 =?us-ascii?Q?2v1LXi8Fu3Ekb1pob7xE/lXBxTJA6K3gNopN7JmP/rNIayAFIu6wBBDPIm1+?=
 =?us-ascii?Q?C+eGJjmcJ0V1YSE3aad6cTFekN70FFB6r1po3FjDE5jK3vCyDM37B2ebllbh?=
 =?us-ascii?Q?2pZNPyvlYDRahIEOPvACNuw9hLaScmtW4Fh7Il5FJvif7Lz+2qC2DbUolahG?=
 =?us-ascii?Q?hIW2Cky9fqTXQzy+ljjaON6dlDnJkayFGU1vRvSl+HqfUnkXm3RmO8oAkUWi?=
 =?us-ascii?Q?DT9aUzqUviiUXKEyMUC7oQpEoEJvk1mvadn4VeY1HRkgeUaHlfA8gFeN90tG?=
 =?us-ascii?Q?cQWK7bJ4VRH/vpGoOQjcPF8m5LEOMvmeCHPYTc0wT6Ze+24aAL00Gn9s4AYb?=
 =?us-ascii?Q?/Rg3XQltlg5vjHcMJhbceWXM6DL/nG/XqHI8WylUciAkAx2IPH7K2haKqfs8?=
 =?us-ascii?Q?xEHa4BtS104M9txGagmhaqqSHwzjHvqYCLJmLqxaE4Y3WzERj6edk88nLuxW?=
 =?us-ascii?Q?VSprT3cE6+Kudbr4iU0bB/3YJk/1njqYJwn8n9z/l0eWI2qL1zj6Dm9dk4Ei?=
 =?us-ascii?Q?4xe71D0ks5LquXgInFcbwbxdHIQ6jVyZQBbH8FBiFVWl6zaj8svQVmR4cPTI?=
 =?us-ascii?Q?HsDTg2HxX5pOVBQx1+4WatfI3A1B8oO6Qb62PAIPitSmQXlAUfB0/GEqEfSQ?=
 =?us-ascii?Q?froARxUWUyHsDWOBABfiAKx30KbmaiJPfY0z+sa6QGYj3BLK6tGS8Y5gmrhd?=
 =?us-ascii?Q?0ZQAbxEZNn1ftOTFJ0R3XlthdLbJsoSA/1ES1F5ik61LrEHxV65NPwcrDOfD?=
 =?us-ascii?Q?idmzPxZ8aVXlumWkVz4P5ew1WsOudHHMA18ptcyv5LVF8SH8gTNKJrvEph8k?=
 =?us-ascii?Q?ykhF+SpPbSDBy7t1YB0ZL5ATFCmNG8PvCHn7FXft+9ldvdy/pc7hRP3h5Ccx?=
 =?us-ascii?Q?StNPHfxUg2R6+ktyOiLdKe/0a4ygEveRk8Ngk6baos6dfw18t2XAtsyEXsbJ?=
 =?us-ascii?Q?vGLIL/j5Me57y7H7cJGIXdH3cWpob4RhoSQNyhQVhZJVPdzdNc7rnof1sklx?=
 =?us-ascii?Q?AUxzHHxUSsCgpKlo6zwXrxQ3lKg6OkUxk6oXA3/rscHDyrQA5ERSKWTO9nA7?=
 =?us-ascii?Q?wg+j8UbIpwPm9ylwDeH24rwtfEn4HGiKHRxT0Hsat1wwjlw32R2xxrd4Itwp?=
 =?us-ascii?Q?bnZUZhsF7vsSjg6pwQ5jr6L6AXybxE7TkZc/APAmw6wWmXeJJpRkAa0zZAtO?=
 =?us-ascii?Q?iORt67m5wm2b0aad6Kx3dG3Yp3gEarMns1mB2FXinnQ8EK53pHgXW0o2dqaD?=
 =?us-ascii?Q?NvIaQO/SNucL5tNbmACp6qQn00PLJCdp5P3PM27nHyGpItR/rkGF7TAHr/3R?=
 =?us-ascii?Q?SOw9lUD9LE6lT8YpoCub+U/kQkUgZEghdo8lYdROwwgbjEZuyHzcrkICoCaj?=
 =?us-ascii?Q?CnmVrAyaWzE3gNSbB3r3ZLwpRDnZmJzgO7YASE2hF86e0K8tmFZ5yc4ZNp01?=
 =?us-ascii?Q?Dr/RXt3/jUNCPPudd3ue2tWqZngWgTGCDrZ1OCDufE7iB/VyVlNoaE5xNnZ1?=
 =?us-ascii?Q?a0/x0DMWnCo3Ry56m7ySXBpeOnjyaNwuMzqkiXm7xmIY/KxT2XkYfjJEzbgz?=
 =?us-ascii?Q?Rt0qOuyp+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bd4a4e-f40e-4186-a27d-08deeaf8817c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:17.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHK7x9gLwM4buVKp43VcB6kK9Jy6obTchHJ+/VzinNQKbcdDGsRZ9c4Z2+MwrFFvT3juJm7ywQPwGDXg4HSSYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of DEVX UMEM registration.
Uverbs users can now request any optional access flag on these
registrations and mlx5 will apply the flag's effect on a best-effort
basis when supported.

Fixes: 72b2f7608a59 ("RDMA/mlx5: Enable ATS support for MRs and umems")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index fc6f793dcc65..ec281a4ba42e 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2410,7 +2410,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 				 IB_ACCESS_LOCAL_WRITE |
 				 IB_ACCESS_REMOTE_WRITE |
 				 IB_ACCESS_REMOTE_READ |
-				 IB_ACCESS_RELAXED_ORDERING);
+				 IB_ACCESS_OPTIONAL);
 	if (err)
 		return err;
 
-- 
2.52.0

