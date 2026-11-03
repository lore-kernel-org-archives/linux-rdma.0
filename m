Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793729625;
	b=ctMpv7+h8i7560glsBF5DcR2KzERz+L33y6eqB0kb5C9cD5x7SAKgvFjjV8M/lPYk+i8
	 CdePV4BEoG9rfVowOCax/8Oe27dfk1UTOI7T3vcQXYHGvTJPkYH5eYRsPnlaW366ab8rt
	 w7xjYhD99N+ROi07g52T/32mbbJXa5i4z04ln/nX+vYJPD/cWlN/IU63cSZfzn1j3gM0I
	 WFYUAtrF8IKw1179pzMSd2AKQOdsu00kYGmd7dOhxqJtsT6414fXtYuizBF0oiEnsMawK
	 Al9mDi8bnaZoFrFlYLpcGOCBdg53PhOcDQuVn/Gs1f745EbNwXJq+1Lbkp9qMMVfiaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729625;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=hE4XXnrG6VTd14AKJ68Pvw6+P3y7784MtZZ/YWI9t9A=;
	b=Xc5FKdyBtkK/Sq5siTGdoNtQ8YPg9j69PaR1/gH/Dz469cpK7rcQNLaeTzyHkrP5M05v
	 6CWViAlY7j65/TVTrAZacPId4Q2R5oZEV2OEFxk3fGNuDgKUcvjElfWQI/LnFCcHajkwc
	 mzkGyguEw22W3LkU80Cl1e21N9CkVYfKu8N99Huxzz/mJkFlHUeR2ULrKe3xxY3qCIIH9
	 VIUgT4MBEu3ZDZdu54Cm3SYZwo5kAE+wOZz5TAxeY0/HRkjvVTdcyE4PBQAE2U3SNAllr
	 ElqsYZ1m4ZtlqquAF3eHsFOKqKDTHLC7yeyLnTeIv142Pk98WLJNpvO1qKBz9IMTCpg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LGopr1Ef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.58
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78600606A33E;
	Tue,  3 Nov 2026 18:13:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78600606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LGopr1Ef
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YQxvMH7vBvbqeJ4b55bMx9oOM9wvwcOYA6+BcsVnxJfKK/hTuXN2tBG70wIlNmsh0ojqnXciaS2wHpOcybqCpTr4qjvEMQ/AymgRsfYPfAg8eZRiYUOKLCsAz4K9WP3LfP+P6cE7nEcokaUJ33JWTQ1d36CzgZYTTvncyk6Mc5EcHcAPd8J9JuIyW42CxKU1UmLgNuxfZfW+UNFDQh6IMO22MB4/Nj3X7HBUJ1ctilHJG2QMEPvV7pkkXf5J0cakIfWvkRI5adp/G4eB1CqCxObnOqxpgW0oQoa9I7A1OUyDTJbeRWaHYTQBSmui3cNWYNK4K4soDzMBx+Mrt3k3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hE4XXnrG6VTd14AKJ68Pvw6+P3y7784MtZZ/YWI9t9A=;
 b=kHNZH3dhMO5ay6SJHuUbwnGi0KW2uTTTC5CK0HEbAS92NiF8Tqo8gXyY1NOfht50c7Qf4B11l1YqjkDEeqyFTxYwekmFUy1YJHpFSjpxaZY0/Qk2zwaIBSV6HD4JRrB7G5TjlOCnjRhtKJtcAQB+zuSqJjeqczjIi1y8OPnes0LxbpYLQBkSIP90iCVVJ6SxvsU+5Yuo57lssTooOXkX5wd4KQgzmYRGKibQu00pbTwH9QxEHZLa9/AJaEsu/8vp1aHrioUw9yxWIEAgRZDYwm85Sr2dxWyk3oJ5B4P6d0Gf1pXN+QN6N5OOf9nCjEYCnk6W+tNtNX/i11+8jGe1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hE4XXnrG6VTd14AKJ68Pvw6+P3y7784MtZZ/YWI9t9A=;
 b=LGopr1EfXtKI4ek+kPQlqxb/3zzxZ6zMwOqi8JmD2K+XEQzIQMtcCoTGVX8CE6xUaLV+jgAYCol9y256gbMtiJD9aOympRiO99r2nretwgPH/qcQdJYW9oPmPvznnO4QBkXREAoCoR5t8PehZRz3WOL33iMW1ASja+RiZMNyeLZqJU3I39qPdIdqk5PscUUkv+MaEziRUDhiKK9xdcDA6OtAGwKl2CwYTLH3L3rW+m9n0Z4o78oDzPVBia1V202DIj3Pd7o/l8zAwHmR/31fOLEf2EpVxaa3liT/ZhBFkdU0YH3M7Hk7cTDhvvBkpgg/FqQkt8ebENbk89OQ50kFgg==
Received: from SJ0PR13CA0187.namprd13.prod.outlook.com (2603:10b6:a03:2c3::12)
 by MW4PR12MB7141.namprd12.prod.outlook.com (2603:10b6:303:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 18:13:29 +0000
Received: from SJ1PEPF000037BB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::3d) by SJ0PR13CA0187.outlook.office365.com
 (2603:10b6:a03:2c3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 18:13:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000037BB.mail.protection.outlook.com (10.167.244.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 18:13:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 10:13:07 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:13:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 10:13:03 -0800
From: Edward Srouji <edwards@nvidia.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
	<yishaih@mellanox.com>
CC: Edward Srouji <edwards@nvidia.com>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mark Bloch
	<markb@mellanox.com>, Michael Gur <michaelgur@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: fs, treat ALLOW as a conflicting action upon merge
Date: Tue, 3 Nov 2026 20:12:50 +0200
Message-ID: <20261103-rdma-rx-classifier-v1-2-1ad6c8cfe936@nvidia.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
References: <20261103-rdma-rx-classifier-v1-0-1ad6c8cfe936@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037BB:EE_|MW4PR12MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f2c7c2-0e17-4a49-7200-08df39d629ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|10067099003|22082099003|261102123227099003|18002099003|921020|56012099006|261021121427099003|261026121527099003|261009223027099003|11063799006|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	oswziCz9gjqwSNvcI4WqUx3yjDPtB9Mdal62kyw2qjczOlOkgqS8tCLp8hDPV70ZLyU7y61FJt8f3hIMnnwKGV3EFNbk2t7Vwk6MABw3pyETqaeAGEE3j2Xt3XySOLvlw0jhfyqwQe4zJP5aSpxGgyEOIKF0Pe/Ae1Rdsc+Iflf11fzq2rTsYJ3bbxMCyxQWtdGpyZttW3ojwgHB8KoKJNRqTq12C4HyUymX2LWWG7zzFNCsTfdVO67D1RPJyGoWDRhE2KHG9dvIPM5XdlVLi36lo9O+iNQwtwrBu7uRQFx5AjGVfBigjx4KEfiP+8P/UW0E9EikvtEF87+/4yW7cRKKHds9Ecc6YkxhmyotOvDrYsffDxXbAOtxR3cuZ0n3JvVT+pVi9TVaoW7UkIcneDNaKcrVX9k6/OTq/kVImUZNo64QWxwyOqOmq8a4NA1bNbO311p1k+FZ5s2iO4F196bNyk+gtf6+vMWAr9LxPbhkeLbssTsVynvAEpb7xGrZwlUxy7JBfDE4PaOJgI004Pjvw40gdgYawenE72U+kqFC7NxtohUnjQo8v/UwNOH8A9OILl4vmK68h1nZzIq1JfnG63R4Tu3Bfh0ksSY3QrlJp9CAEJIP67cv+oOHfNQtbwJoqW2QSm0ksOcsOYRe3bfzm+255HHPx8f9wbsj7+rYvUD79B72HSa6nEwYi1qyxK5tbueqEw3BySc9w2k5T9IfU7PY2auelF8E7VEboWMSa8C7pYhTHURd3I7OzyqV
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(261102123227099003)(18002099003)(921020)(56012099006)(261021121427099003)(261026121527099003)(261009223027099003)(11063799006)(261021135927099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RQwFF42RA5umgBNiXDbYWzN5kNez7cVnVTMsWUhC8xNk5lBMCkEmSa92Kckr63x7x+vo+XlcTnGbV79q48unjJmWfUADbxqFnWuUOTK8zq01JMcHJLMq4oWsGxbCbubjbvkcSTej1pV6x0YDCK2W2Nmp8Bn4p+zhHxMNVHU+yAqdfGl8Uz5sJUET4Ji/+CFCBGEZ2CSaDJ9dWLf4zUKaongf9HpshrWTrOYGP0g0+myFaFwVbaQ6a8z/tbmGzheOB5XBpEC6m37vj/O/LALGzYTGEcdj8pRn/i6picslC5dqa5g1ikzEaG5VMU5dVk4M/K0Zm+2tp+6ozw5HxMlrLz/gHfbKzVmFuDjU31tRAIaEr2j0T42+sqVe0XcqJbzkeDghGlN9+YRKmWNTluYZOBnvLCKE5jfkrBZNrZGZBUmPnpUOB1XaWzT6E/88sKrf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 18:13:29.8942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f2c7c2-0e17-4a49-7200-08df39d629ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7141

From: Michael Gur <michaelgur@nvidia.com>

Two rules with identical match criteria are allowed to merge into one
firmware entry, combining their actions - this is how a single match
fans out to multiple actions. That merge logic rejects combining
conflicting actions, e.g a DROP rule with a forwarding rule, since one
entry can't carry both, but never learned to do the same for ALLOW.
Two same-match rules, one requesting ALLOW and the other forwarding,
merge into a single entry that ends up requesting both, violating
firmware's rule that exactly one of forward/drop/allow may be set per
entry.

Reject merging same-match rules that disagree on ALLOW, the same way
already done for other actions.

Fixes: a7ee18bdee83 ("RDMA/mlx5: Allow creating a matcher for a NIC TX flow table")
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c8f6adae6f51a03d058e48aba376fa4cfbe263b9..70545053f9c42d6f6ccf439852d14f9b9e16419f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1929,6 +1929,7 @@ static bool check_conflicting_actions(const struct mlx5_flow_act *act1,
 		return false;
 
 	if (xored_actions & (MLX5_FLOW_CONTEXT_ACTION_DROP  |
+			     MLX5_FLOW_CONTEXT_ACTION_ALLOW |
 			     MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
 			     MLX5_FLOW_CONTEXT_ACTION_DECAP |
 			     MLX5_FLOW_CONTEXT_ACTION_MOD_HDR  |

-- 
2.49.0

