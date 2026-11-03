Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724087;
	b=k98yeFSq0aR8cBIeGbga/pksnKOVc3/cQzpqZI83cRJR7P/ev4sRlxHJcLY7ydgJYvt9
	 obVtOWB8sUDyGbAvr9wP3P/kdlZJs9ozBqjShDm2+Ar4aj2kLIUfnTqh6/8JZnSgljNGK
	 77dbebZZyl6j6Csdsn+gdh0l1hGVZW1cCl/r3FiVpBE3OBqFg6nHB6qt19+2cYyNMEJCW
	 xR6zLNMKGXE9f+YTHQCNk+6A9UvzZJm0JLynGELYG+HH2BaS1shdu3SU/esuOdHRGapXG
	 uHjXQj1kj/3/zqcVuTAFvkD9F7V2Df8p1eYZl6+slafFBU8DMT7PiQjnNkcnIYT8n1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724087;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=UO5t6rYIMKnQiPdXdJ0gPRCnyizB5X8Sylcr1ob/UeQ=;
	b=k80nihkeOCmEAuEhuz05BilgFQ1jI+X6DPyMRi6rMEvt2GI/EjjxddJvYsss/ptu+mMQ
	 MtgAWOI/PeYn3fh04xdnvt3F7AXD7iv6cjbYIlwn1HRpX/VqNLxqvHJaRg9HLTI9TmQhQ
	 /iG1yfNgZH89MFHHogrBtYKcml1k0I5jWib6UadKhfvRTpqj6bZxEB4QQfOFmYYfrqScS
	 EW68/OZ3cSuzeuzKBNnVBaocmc2OqQJ9255UC6HJLPSVubLB6tcTUxZ0PxfOqivU0kA8T
	 qa32rv06HBGp2ABXKkfxjZr69fVyhNnfeCUfCneGH9grgUeHMazXRLAlyYqyFTH0jWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fx1GPFpP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.9
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3BB6082BF9;
	Tue,  3 Nov 2026 16:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA3BB6082BF9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fx1GPFpP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwYPT0Tj3Gr2x7b8MOFSbHqdeCZvfoQo7hR1suZWWcs/lzmvptwQeeL1pNuXzWKNRAKf6boZlBp3GcOSdQN4aegGN+848+dT/+hY8pvDTc/laVEFP+vTF0khVjNTU5DmKBAFGYdQhshd82sjlmHAu/v20NtJmAqMdroA5CqzNmY65QOJCFtO4ZCvnPyVTS7V5DuiGoedVAo6IP+U6nlZMJi0ZpX0ZBBOuBujjOCSRdhwP7JfwAqWP0+luu17k3VE9fyuYSvLWPUdsflLdUbZtpfmASerHl78WauAeyxVBepNVEu1zq7w3ZjGZBe3Oibr10e18vkDX83OCUOwFA/kQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UO5t6rYIMKnQiPdXdJ0gPRCnyizB5X8Sylcr1ob/UeQ=;
 b=AX7AkJrZnamONQFs0iz3OlbitbTUgsExbIOrk6cTKHPwYK7eMWG6ZZdMyCu17v2XaT/+ZXQOhlLKz9sLmWyULUzRiXgr7b400JwN1pClHrSmEAgv6RyDZ8vnxnth3PpcG45eu20mH88VqWS5nRTPUJTBOoGN+xhNzh0Qwrw/W6z7HkSj4NnIoXpQkQHQJJQ4tU2DdhrB+KSKp1UToLyLKPli93C+Q6wEXQI31Kgo9AU5PI8gT+RDQLV7kHDf8m/mB7vKq+5QT7BU06Soh0StrnkOMaCoqKveGKMIr3YOBnimLu+SZB3lt67XX9943fZmDNIPotdLVehJPa0a81DCQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UO5t6rYIMKnQiPdXdJ0gPRCnyizB5X8Sylcr1ob/UeQ=;
 b=Fx1GPFpPafGhZV/f1EyRbFZ02VaiE5HbH6o1BHE57w9Y8YFtCpntLZ5VEHhiR34mNHTtr607ahf2tJigWblVsy0T25Y+zZPoxsw/HdxN3QHavA9R0bmu+ZgoW78CzM/4ULWwBJw0acaNyNu5IXhJah6COeIk/1a3E+YjjJLrkoCdaJmxYbxr3LGBZTDWMo142QrG4yLK2EFL/XnTSWL5eQQ98t9ReDhRu+5hg9FAKmeVJB65odHmcYyo80xE6ZOKKl5XX6seyFzTm4N2I92lJTPKDkncal5Cf0bUElMpnE+TT1Tg/4rX4dlOWOIdYMQx3ckKxpUcLD8ZUuFvv3ytjg==
Received: from SJ0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:33a::10)
 by SN7PR12MB7132.namprd12.prod.outlook.com (2603:10b6:806:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:41:19 +0000
Received: from SJ1PEPF000037A9.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::9c) by SJ0PR03CA0005.outlook.office365.com
 (2603:10b6:a03:33a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037A9.mail.protection.outlook.com (10.167.244.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:18 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:50 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:49 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:45 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 06/23] RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
Date: Tue, 3 Nov 2026 18:39:32 +0200
Message-ID: <20261103163949.1554-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A9:EE_|SN7PR12MB7132:EE_
X-MS-Office365-Filtering-Correlation-Id: 4edd5241-3a41-4f90-94f3-08df39c94941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|261026121527099003|261028144727099003|261026140227099003|261009223027099003|261102123227099003|261022105027099003|261021123027099003|261021121427099003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	09FadACG4nXqapiTnhQlpvMwdLWDQC+E5gRr94hUCjIoqhGqyDQCuIurzlJSHyQF/6k+IIqzYnGVduXPxucno4rKIfz46Q+0bz2L8KXnIUg0zBmX/RaNsZTARgbQjIQ0IuNKvqj56qZUz7TKcE5+2C6d4OB4w6Z2DSXIQVNiGP8KF6RRPkCruKmHkzbuPKAwsbns+WOUUYkAe52TR44HoqwJXmDG7ChR/Kx7vbn4Ducimx0c2NbGEQVf25AIXPWPAXDLGqSJvbXcxZtI8z+L+Fg3ytEPbs7Hp/yT01jAy4CDrNElfJMCqeSidhFxzbftCjh/r/o851gNcKDRQCctO4LHrs8fPPNt3YhmRdoyPs9bHuvV/yu96YrDk/TRxSKFogrktU8AdB2Fy+ZSKAnnDN0OYxxDQ9UWHUj3UOP84Bfkivow1NiZ636QVw6VMcy7vwpb6pSaMpl02ut5cKrmXAAxid64c1AaK+ODgDRJnqwdSYB8v5aVOpdrNRPwVchzKNYN6U11ZwYLFoXYq18JS63ELyLBubSBHZJWxTHOB53TWFxr3zf8ci9BwyNiQBADPgV9lB6kWUZinqzM/Il2ROlc8ZHtVFiB5kw2cT9aUUhP0UM7wfcuIVHp9JNbyVua31EnaejK+1s/sXNkElBIjaKm2mS30AMFcueu3Mpz3pfJL2J1VkeB2QrfHDNKEsy2n3qoGKjiEq4kpK7foFCWog==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(261026121527099003)(261028144727099003)(261026140227099003)(261009223027099003)(261102123227099003)(261022105027099003)(261021123027099003)(261021121427099003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GqlvVHgEv95pFMAVQNg4M3xezf1tnc9fubpBSfYGmGm7SnDSQkOyePMSgG8CiFisExc8IteMLpyiS2kJOiYFsgs4OJquylvSXhZ2j3I6JYGwMvpeA4XfC9SMmamB40yyfRwUKBGh/jZzrkdoqACtk0tZwEbplUjRMOqDvJjVjYeOwDYHPBAeZ73B+QtYP+6ZvfkIigLBbMaxvn3K+pvVfYz69K7IyYjsJYBJL7+HJqJAmTjwgD8mt+V7WYvsoj6l0Bm4B7peYz6whoOSwfMaKdUMfjqIQwcsHn7CTx7u0gkg891TKQaHHSwxecant+Oeo2LBOuI/kTXZw8zLzm7OoSOOe9sF043p1eCjF3RIXcxTuAYtZZ5yN8W/nEHLSfkDhwXgOPCuzMBPKA6qaZ6rkENwaiseZSpibnMhlG61lYXzT0vkgeg0bS2EFftCbe4M
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:18.9897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edd5241-3a41-4f90-94f3-08df39c94941
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7132

check_qp_type() checks the dct capability only for IB_QPT_DRIVER, but
process_vendor_flags() turns any QP that carries a DC type flag into a
DCI or DCT QP. A QP created as, for example, IB_QPT_RC with a DC flag
thus becomes a DC QP without the capability check.

Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
uses to create DC QPs.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 943ee5c55538..19cbf6b2b979 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2965,18 +2965,22 @@ static int process_vendor_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	switch (flags & (MLX5_QP_FLAG_TYPE_DCT | MLX5_QP_FLAG_TYPE_DCI)) {
 	case MLX5_QP_FLAG_TYPE_DCI:
+		if (qp->type != IB_QPT_DRIVER)
+			return -EINVAL;
 		qp->type = MLX5_IB_QPT_DCI;
 		break;
 	case MLX5_QP_FLAG_TYPE_DCT:
+		if (qp->type != IB_QPT_DRIVER)
+			return -EINVAL;
 		qp->type = MLX5_IB_QPT_DCT;
 		break;
+	case 0:
+		/* IB_QPT_DRIVER needs a subtype */
+		if (qp->type == IB_QPT_DRIVER)
+			return -EINVAL;
+		break;
 	default:
-		if (qp->type != IB_QPT_DRIVER)
-			break;
-		/*
-		 * It is IB_QPT_DRIVER and or no subtype or
-		 * wrong subtype were provided.
-		 */
+		/* Both subtypes */
 		return -EINVAL;
 	}
 
-- 
2.18.1

