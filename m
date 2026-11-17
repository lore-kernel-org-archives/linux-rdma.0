Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924139;
	b=RV26yxNHpEespo4xrL/i/RnkmPw2QVpQ1xlCHHv3isCC060eKPKtRgZ+5F0oo8hzL52e
	 z7CozJ4+k1KeZ4J+sfrSumFacHgHn55HHqf8OX/aERhYAVs342n27yoCNJnnSOk8/6eNa
	 4KH6Vbpkg6SyWmzXJ5zG4X9Lei7f5Pw56hIMCs/izaXTt7HL3MXpwqcQd9/RLLN81O9YF
	 u0qLgUhp1nN/AUPMyO+ceBXGbmrp+AkolRH9YyyfSqpD6qtztu2g9S8r4LFJa8ZVGYSia
	 W2CHafDMzYtmdZboCKk8r/6gpi08kRPPuxq3osw4Q5e4o/G6HqxYuUbYsnUyauujLsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924139;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=jp+4L5BmFYBJhBdvXaao5ZvDeboNQk+NZm20pkKE/so=;
	b=JmOrIBeUn5GG5ZGwRkYwF8WOcOAg637AJbh5NcJqU09OT55Cw4pMQATwFxNm2bNSkH9L
	 tFAJ9dnw81PVTU5WsxdLh4EbUObhqY86rjlTzFWIVJcCX5M0/yM0tMsQxgAtyATcSv6lZ
	 c6fTvRUw/5rMw63ZO7vrdAiGPU2lbblnBffpCDG3AYZd5r2dAP7ZLr73TXn0y6jvaek9L
	 y/4V/yTFt6/PFsdq6h80q1OVj+bwc/c7jdml1mkvhDMXKb5+G7fFbBF0morVhG11Bfo5b
	 G6Cji/0bxjPc7AGjOPcXe+pG0PRVpQtcedUpFzbuZ019FFY4EBQeKHNsJ7xS+QpQYFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GcROGodN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.52
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0309F606A8BA;
	Tue, 17 Nov 2026 14:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0309F606A8BA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GcROGodN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpzsUrWWy18HkQPzyDqiapeifezWqb23wxsRhMZQC0Ebo5DqWMYcvN8E6JfE3ybkaLEt/tScXpTkjPIuNH4MXG88T4rxJ/qunnIPdHK0XT4iBsWavMW1MDzgzzSWYiR1zNxk+dm+ultQgw3QfyMf5h0qYyEqjSFGWWfhM85cSHub8z+9MP1ZcwD/LeGqPp8tRQptQQdVJHwzbaV+yKwGK5X8BCRJq5xVWPeDGqPSoEki8hd1Zoo6FTyffDfCIHI/ozNKqJkgGiDieHnjMD+il4LKk2LXCr1IFuTZxL4x9mX66lyHMtUpSDVMrEqLIbIjfAdTZ/FCri0DRktPL5WoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jp+4L5BmFYBJhBdvXaao5ZvDeboNQk+NZm20pkKE/so=;
 b=twhzi7Z2LAVczsM5zp2Kny1F/P4CwYIz3BJ6JL6nV90Hz98WbP0ER+/yZEIHs97T0fXaqPrWpICk3CXD88XfvZKf5mSlwnCdMwjnRMvWI8stCRBrgOVk6pHndy7CqLVIGm/guBCjPjxI6LDv3A7wi7PkQQ6FhCAxOLRAkz0EbILp2oJhW/uhzzdMWM3zq5UN2l9vd1ky9BdRN3NY/guoxR9hYMmzcCOWlhn66BBnA27Kt+TZIlWCeHi8tm4g/NYWIC2h4K+AbVsahBjsL7sbcyqcBlrz2RaZXO5jnJRj8AlblddIJcqYsqMiDiVp9mGDHioXtCV4Xx4XtiprL0s8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jp+4L5BmFYBJhBdvXaao5ZvDeboNQk+NZm20pkKE/so=;
 b=GcROGodN4hNrpcb/H0goT0SgGFRSRpx2xf9KjfePfsDVXnwVgGVGiceK8MdXAdyiaQuBPYAed0YX8mloQ+ukJj4E/knA7yDIoVJvwxTqqeQDcFc5SiojCbd2SSWboyDNPEj/JsGywMu9pbvazDE++NbIAH8CEabfckxY2IDs/VDio+6Z1wZnKCM01pf+GmzJYbv4SpI1TRqjzAIygfZUA76QAUwMWJdrne6mG4+rFTtM97PDorsjHL6yATdHsFXvAseEwLwAzGzokAabML2F6OnYs/uUP5AJgFABwREJl1+usMGof8KsV99CMkb1l98XAL1wDmKgoXVQ8pNc6JKOag==
Received: from CH2PR14CA0007.namprd14.prod.outlook.com (2603:10b6:610:60::17)
 by CYYPR12MB8891.namprd12.prod.outlook.com (2603:10b6:930:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:13 +0000
Received: from IA0PEPF0000003E.namprd03.prod.outlook.com
 (2603:10b6:610:60:cafe::32) by CH2PR14CA0007.outlook.office365.com
 (2603:10b6:610:60::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Tue,
 17 Nov 2026 14:02:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 IA0PEPF0000003E.mail.protection.outlook.com (10.167.249.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:43 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:41 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:19 +0200
Subject: [PATCH rdma-next 08/11] RDMA/mlx5: Resolve core device from
 ucontext for DEVX resources
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
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-mlx5-sd-prep-v1-8-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=27863;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=H0o/pXs96UgJHPXG3J00NWoyeV0DHOc87kgfFPnplHo=;
 b=kmX+r1Gw1c9L8uypxhT8WT0IhxVbzA/jTrx548OcnoGx6ASXib8seW5eB4kMlL/X4yBRpER+H
 WOQdKhRb5xWAcTUMBH/lE1Ef4s8xAX1XsD1diofOcGN+4Y+53BX4s/t
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF0000003E:EE_|CYYPR12MB8891:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f4479d1-4c3a-4319-0620-08df44b36120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|22082099003|18002099003|261009223027099003|3023799007|11063799006|5023799004|260925022911599003|260925021311599003|260925021911599003|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|10067099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	9wQvgnqGosxtPqwThuJMPDxaztumLHKX0QpEDvDyx2qe4isGq6UgTai12pMZpP0pbzCBtERnfyDBImcuQPxCTutyN84wH/m8Wuaf7bL77ClW4/dosElUg4NX1FUHA3PDwMKaQXJdQTeZprt4dtEHYjt28sHGORlUlQvJARJCOg8RckdjzgFvALmZpUgc44Bfk2JeFvpVTnlBnAodcp6mkXI3fstz0rI12cE8uqFaKkfFXaQgi0TMuFrY/WHwqpqqW5jznGsogSoMFi0eoU6WDyCTDrJUGdSyA89s3jA/PZyEaBjEA8NCLqKBiSEZJrs8hz87JPbZ0Z00io1LmX8/xwYbSY/jSicuq2y2uW6PNWQp0TEROCWOOTRF7KiCngR4xteHz8+M12nqXXCI8kNE+ljcAcufHatin18wXgZoXYPsak0fh1ppw+0MSHGE+gCltgz53R2Wy+0Bg5CtyK9xl8w4PB0HrsT0HGtllZeZNKISH23knOMTt6bjnUgasL4T09H7Ny0avimzeRIbObyuB+JYjXyBlTckSp2ro80aInHUgzon7xg3eyHrIXU5fC47mHBK++LeyN9TWpvAnPJ9AKtBDU412yIrsC0YqO/zh4J6EBFF/+uSCqwprV6qdOaWAnuzk2E3OM155yXIj4SGEd8Ph8Nku6Xju3DZykMrr1UGKgUTUj8Ks8jvC00dmSk6p2PsGoEmW2TRSDuuOiL75w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(22082099003)(18002099003)(261009223027099003)(3023799007)(11063799006)(5023799004)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VRoaLAWA23f5HOeGEmjZ+X7jWuL3tTPEQ8sqqNBfHk7IJeq6SGZB+rP7wndJ3TrdKXJUppMuxIHPPjFbJbbwT8qgL96n1p2PH2nCSpSkUt/5tTS2sFqaXKCye4tjWt285Me3bPFmTKdkaBaN6Ci4t8iGVr88gnbFDCzZffSHRNmnNeFw6qzCzyBXXas5e0aE+2DSCEPfLEUK77xjPQnEKmoHfEXbnCNSlahSEwMtMIL18TCnIY24jYNmVM0qpd3y++bJts87rG6rkhr6S5r4u9v8WpaK0nQDMw089FzkT7T4Oh2TCBWRwIvqpmVfS3znmmTYKr6+UadvnZVsqSieb9qIanYRXvfujbFBy6nnH1Opvjghypx9dCtfs76sscjINYoSD9i5kpnml3O7VoHj/9HPAWYjJFKiFN/eUSwJHin9/ys2J9KWRjGSchUchvi5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:12.7558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4479d1-4c3a-4319-0620-08df44b36120
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF0000003E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8891

From: Akiva Goldberger <agoldberger@nvidia.com>

DEVX objects are all attached to a user context, which is tied to the
specific core device it was opened on. Resolve the core device from the
user context instead of through the IB dev. The DEVX UID of a user
context is created and destroyed on that same core device.

The DEVX umem and packet pacing objects kept their own copy of the core
device for cleanup. Drop it, and like the other DEVX objects resolve the
core device from the user context, which at cleanup is the one the
uobject was created in.

Introduces the uctx_to_mdev helper to easily translate between the user
context and the core device.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c      | 115 +++++++++++++++++----------------
 drivers/infiniband/hw/mlx5/devx.h      |  10 +--
 drivers/infiniband/hw/mlx5/dm.c        |   7 +-
 drivers/infiniband/hw/mlx5/dmah.c      |  10 ++-
 drivers/infiniband/hw/mlx5/main.c      |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h   |   6 +-
 drivers/infiniband/hw/mlx5/qos.c       |  11 ++--
 drivers/infiniband/hw/mlx5/std_types.c |   6 +-
 8 files changed, 96 insertions(+), 76 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 6d390e784b2f9eed524db40b8c9e2927c7de50a0..d0b1876f9e8afc6de57f7db1631327bb7c9b91ba 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -105,7 +105,6 @@ struct devx_async_event_file {
 };
 
 struct devx_umem {
-	struct mlx5_core_dev		*mdev;
 	struct ib_umem			*umem;
 	u32				dinlen;
 	u32				dinbox[MLX5_ST_SZ_DW(destroy_umem_in)];
@@ -123,17 +122,17 @@ devx_ufile2uctx(const struct uverbs_attr_bundle *attrs)
 	return to_mucontext(ib_uverbs_get_ucontext(attrs));
 }
 
-static int set_uctx_ucaps(struct mlx5_ib_dev *dev, u64 req_ucaps, u32 *cap)
+static int set_uctx_ucaps(struct mlx5_core_dev *mdev, u64 req_ucaps, u32 *cap)
 {
 	if (UCAP_ENABLED(req_ucaps, RDMA_UCAP_MLX5_CTRL_LOCAL)) {
-		if (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RDMA_CTRL)
+		if (MLX5_CAP_GEN(mdev, uctx_cap) & MLX5_UCTX_CAP_RDMA_CTRL)
 			*cap |= MLX5_UCTX_CAP_RDMA_CTRL;
 		else
 			return -EOPNOTSUPP;
 	}
 
 	if (UCAP_ENABLED(req_ucaps, RDMA_UCAP_MLX5_CTRL_OTHER_VHCA)) {
-		if (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
+		if (MLX5_CAP_GEN(mdev, uctx_cap) &
 		    MLX5_UCTX_CAP_RDMA_CTRL_OTHER_VHCA)
 			*cap |= MLX5_UCTX_CAP_RDMA_CTRL_OTHER_VHCA;
 		else
@@ -143,7 +142,8 @@ static int set_uctx_ucaps(struct mlx5_ib_dev *dev, u64 req_ucaps, u32 *cap)
 	return 0;
 }
 
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			bool is_user, u64 req_ucaps)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(create_uctx_out)] = {};
@@ -153,22 +153,22 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	u32 cap = 0;
 
 	/* 0 means not supported */
-	if (!MLX5_CAP_GEN(dev->mdev, log_max_uctx))
+	if (!MLX5_CAP_GEN(mdev, log_max_uctx))
 		return -EINVAL;
 
 	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
 	if (is_user &&
-	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX) &&
+	    (MLX5_CAP_GEN(mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX) &&
 	    rdma_dev_has_raw_cap(&dev->ib_dev))
 		cap |= MLX5_UCTX_CAP_RAW_TX;
 	if (is_user &&
-	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) &
+	    (MLX5_CAP_GEN(mdev, uctx_cap) &
 	     MLX5_UCTX_CAP_INTERNAL_DEV_RES) &&
 	    capable(CAP_SYS_RAWIO))
 		cap |= MLX5_UCTX_CAP_INTERNAL_DEV_RES;
 
 	if (req_ucaps) {
-		err = set_uctx_ucaps(dev, req_ucaps, &cap);
+		err = set_uctx_ucaps(mdev, req_ucaps, &cap);
 		if (err)
 			return err;
 	}
@@ -176,7 +176,7 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	MLX5_SET(create_uctx_in, in, opcode, MLX5_CMD_OP_CREATE_UCTX);
 	MLX5_SET(uctx, uctx, cap, cap);
 
-	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (err)
 		return err;
 
@@ -184,7 +184,7 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps)
 	return uid;
 }
 
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
+void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_uctx_in)] = {};
 	u32 out[MLX5_ST_SZ_DW(destroy_uctx_out)] = {};
@@ -192,7 +192,7 @@ void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
 	MLX5_SET(destroy_uctx_in, in, opcode, MLX5_CMD_OP_DESTROY_UCTX);
 	MLX5_SET(destroy_uctx_in, in, uid, uid);
 
-	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
 static bool is_legacy_unaffiliated_event_num(u16 event_num)
@@ -631,10 +631,8 @@ static u64 devx_get_obj_id(const void *in)
 	return obj_id;
 }
 
-static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
-				 struct ib_uobject *uobj, const void *in)
+static bool devx_is_valid_obj_id(struct ib_uobject *uobj, const void *in)
 {
-	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
 	u64 obj_id = devx_get_obj_id(in);
 
 	if (!obj_id)
@@ -659,7 +657,7 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 			opcode = MLX5_CMD_OP_CREATE_XRQ;
 			break;
 		default:
-			if (!dev->mdev->issi)
+			if (!srq_to_mdev(srq)->issi)
 				opcode = MLX5_CMD_OP_CREATE_SRQ;
 			else
 				opcode = MLX5_CMD_OP_CREATE_RMP;
@@ -992,12 +990,12 @@ static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
 	return c->devx_uid;
 }
 
-static bool devx_is_general_cmd(void *in, struct mlx5_ib_dev *dev)
+static bool devx_is_general_cmd(void *in, struct mlx5_core_dev *mdev)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 
 	/* Pass all cmds for vhca_tunnel as general, tracking is done in FW */
-	if ((MLX5_CAP_GEN_64(dev->mdev, vhca_tunnel_commands) &&
+	if ((MLX5_CAP_GEN_64(mdev, vhca_tunnel_commands) &&
 	     MLX5_GET(general_obj_in_cmd_hdr, in, vhca_tunnel_id)) ||
 	    (opcode >= MLX5_CMD_OP_GENERAL_START &&
 	     opcode < MLX5_CMD_OP_GENERAL_END))
@@ -1031,7 +1029,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
 	int user_vector;
 	int dev_eqn;
 	int err;
@@ -1043,9 +1040,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_EQN)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
 
-	err = mlx5_comp_eqn_get(dev->mdev, user_vector, &dev_eqn);
+	err = mlx5_comp_eqn_get(uctx_to_mdev(c), user_vector, &dev_eqn);
 	if (err < 0)
 		return err;
 
@@ -1108,7 +1104,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
+	struct mlx5_core_dev *mdev;
 	void *cmd_in = uverbs_attr_get_alloced_ptr(
 		attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN);
 	int cmd_out_len = uverbs_attr_get_len(attrs,
@@ -1120,14 +1116,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
 
 	/* Only white list of some general HCA commands are allowed for this method. */
-	if (!devx_is_general_cmd(cmd_in, dev))
+	if (!devx_is_general_cmd(cmd_in, mdev))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1135,7 +1131,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1448,6 +1444,8 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 			    enum rdma_remove_reason why,
 			    struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct mlx5_devx_event_table *devx_event_table;
 	struct devx_obj *obj = uobject->object;
@@ -1469,12 +1467,12 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	if (obj->flags & DEVX_OBJ_FLAGS_HW_FREED)
 		ret = 0;
 	else if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		ret = mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
+		ret = mlx5_core_destroy_dct(obj->ib_dev, mdev,
 					    &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		ret = mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
+		ret = mlx5_core_destroy_cq(mdev, &obj->core_cq);
 	else
-		ret = mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox,
+		ret = mlx5_cmd_exec(mdev, obj->dinbox,
 				    obj->dinlen, out, sizeof(out));
 	if (ret)
 		return ret;
@@ -1513,9 +1511,9 @@ static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
 	rcu_read_unlock();
 }
 
-static bool is_apu_cq(struct mlx5_ib_dev *dev, const void *in)
+static bool is_apu_cq(struct mlx5_core_dev *mdev, const void *in)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, apu) ||
+	if (!MLX5_CAP_GEN(mdev, apu) ||
 	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context), apu_cq))
 		return false;
 
@@ -1536,6 +1534,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	struct devx_obj *obj;
 	u16 obj_type = 0;
@@ -1573,18 +1572,18 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 	if (opcode == MLX5_CMD_OP_CREATE_DCT) {
 		obj->flags |= DEVX_OBJ_FLAGS_DCT;
-		err = mlx5_core_create_dct(dev, dev->mdev, &obj->core_dct,
+		err = mlx5_core_create_dct(dev, mdev, &obj->core_dct,
 					   cmd_in, cmd_in_len, cmd_out,
 					   cmd_out_len);
 	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
-		   !is_apu_cq(dev, cmd_in)) {
+		   !is_apu_cq(mdev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
-		err = mlx5_create_cq(dev->mdev, &obj->core_cq,
+		err = mlx5_create_cq(mdev, &obj->core_cq,
 				     cmd_in, cmd_in_len, cmd_out,
 				     cmd_out_len);
 	} else {
-		err = mlx5_cmd_do(dev->mdev, cmd_in, cmd_in_len,
+		err = mlx5_cmd_do(mdev, cmd_in, cmd_in_len,
 				  cmd_out, cmd_out_len);
 	}
 
@@ -1633,12 +1632,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		mlx5_core_destroy_dct(obj->ib_dev, obj->ib_dev->mdev,
-				      &obj->core_dct);
+		mlx5_core_destroy_dct(obj->ib_dev, mdev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
+		mlx5_core_destroy_cq(mdev, &obj->core_cq);
 	else
-		mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox, obj->dinlen, out,
+		mlx5_cmd_exec(mdev, obj->dinbox, obj->dinlen, out,
 			      sizeof(out));
 obj_free:
 	kfree(obj);
@@ -1655,7 +1653,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 							  MLX5_IB_ATTR_DEVX_OBJ_MODIFY_HANDLE);
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	void *cmd_out;
 	int err, err2;
 	int uid;
@@ -1670,7 +1668,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	if (!devx_is_obj_modify_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1680,7 +1678,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_MODIFY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1705,7 +1703,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	void *cmd_out;
 	int err, err2;
 	int uid;
-	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 
 	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
 		return -EINVAL;
@@ -1717,7 +1715,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	if (!devx_is_obj_query_cmd(cmd_in))
 		return -EINVAL;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1725,7 +1723,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 		return PTR_ERR(cmd_out);
 
 	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
-	err = mlx5_cmd_do(dev->mdev, cmd_in,
+	err = mlx5_cmd_do(mdev, cmd_in,
 			  uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
 			  cmd_out, cmd_out_len);
 	if (err && err != -EREMOTEIO)
@@ -1767,12 +1765,14 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_ASYNC_CMD_FD_ALLOC)(
 
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DEVX_ASYNC_CMD_FD_ALLOC_HANDLE);
-	struct mlx5_ib_dev *dev = udata_to_dev(&attrs->driver_udata);
+	struct mlx5_ib_ucontext *c =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
 
 	ev_file = container_of(uobj, struct devx_async_cmd_event_file,
 			       uobj);
 	devx_init_event_queue(&ev_file->ev_queue);
-	mlx5_cmd_init_async_ctx(dev->mdev, &ev_file->async_ctx);
+	mlx5_cmd_init_async_ctx(uctx_to_mdev(c), &ev_file->async_ctx);
 	return 0;
 }
 
@@ -1863,7 +1863,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	if (err)
 		return err;
 
-	if (!devx_is_valid_obj_id(attrs, uobj, cmd_in))
+	if (!devx_is_valid_obj_id(uobj, cmd_in))
 		return -EINVAL;
 
 	fd_uobj = uverbs_attr_get_uobject(attrs,
@@ -2148,7 +2148,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 	event_type_num_list = uverbs_attr_get_alloced_ptr(attrs,
 			MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST);
 
-	if (!is_valid_events(dev->mdev, num_events, event_type_num_list, obj))
+	if (!is_valid_events(uctx_to_mdev(c), num_events, event_type_num_list,
+			     obj))
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&sub_list);
@@ -2329,7 +2330,7 @@ static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
 	return page_size;
 }
 
-static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
+static int devx_umem_reg_cmd_alloc(struct mlx5_core_dev *mdev,
 				   struct uverbs_attr_bundle *attrs,
 				   struct devx_umem *obj,
 				   struct devx_umem_reg_cmd *cmd,
@@ -2382,7 +2383,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	MLX5_SET(umem, umem, page_offset,
 		 ib_umem_dma_offset(obj->umem, page_size));
 
-	if (mlx5_umem_needs_ats(dev->mdev, obj->umem, access))
+	if (mlx5_umem_needs_ats(mdev, obj->umem, access))
 		MLX5_SET(umem, umem, ats, 1);
 
 	mlx5_ib_populate_pas(obj->umem, page_size, mtt,
@@ -2402,6 +2403,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_dev(c->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	int access_flags;
 	int err;
 
@@ -2425,17 +2427,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	if (err)
 		goto err_obj_free;
 
-	err = devx_umem_reg_cmd_alloc(dev, attrs, obj, &cmd, access_flags);
+	err = devx_umem_reg_cmd_alloc(mdev, attrs, obj, &cmd, access_flags);
 	if (err)
 		goto err_umem_release;
 
 	MLX5_SET(create_umem_in, cmd.in, uid, c->devx_uid);
-	err = mlx5_cmd_exec(dev->mdev, cmd.in, cmd.inlen, cmd.out,
+	err = mlx5_cmd_exec(mdev, cmd.in, cmd.inlen, cmd.out,
 			    sizeof(cmd.out));
 	if (err)
 		goto err_umem_release;
 
-	obj->mdev = dev->mdev;
 	uobj->object = obj;
 	devx_obj_build_destroy_cmd(cmd.in, cmd.out, obj->dinbox, &obj->dinlen, &obj_id);
 	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_DEVX_UMEM_REG_HANDLE);
@@ -2455,11 +2456,13 @@ static int devx_umem_cleanup(struct ib_uobject *uobject,
 			     enum rdma_remove_reason why,
 			     struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	struct devx_umem *obj = uobject->object;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	int err;
 
-	err = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
+	err = mlx5_cmd_exec(mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
 	if (err)
 		return err;
 
@@ -2645,7 +2648,7 @@ int mlx5_ib_devx_init(struct mlx5_ib_dev *dev)
 	struct mlx5_devx_event_table *table = &dev->devx_event_table;
 	int uid;
 
-	uid = mlx5_ib_devx_create(dev, false, 0);
+	uid = mlx5_ib_devx_create(dev, dev->mdev, false, 0);
 	if (uid > 0) {
 		dev->devx_whitelist_uid = uid;
 		xa_init(&table->event_xa);
@@ -2678,7 +2681,7 @@ void mlx5_ib_devx_cleanup(struct mlx5_ib_dev *dev)
 		mutex_unlock(&dev->devx_event_table.event_xa_lock);
 		xa_destroy(&table->event_xa);
 
-		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
+		mlx5_ib_devx_destroy(dev->mdev, dev->devx_whitelist_uid);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/devx.h b/drivers/infiniband/hw/mlx5/devx.h
index ee9e7d3af93ffcec1b7b6142e2e755075acbba1e..0fb2dcf6bafd1bfdd972051296acff4e0f944383 100644
--- a/drivers/infiniband/hw/mlx5/devx.h
+++ b/drivers/infiniband/hw/mlx5/devx.h
@@ -24,18 +24,20 @@ struct devx_obj {
 	struct list_head event_sub; /* holds devx_event_subscription entries */
 };
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user, u64 req_ucaps);
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid);
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_core_dev *mdev,
+			bool is_user, u64 req_ucaps);
+void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid);
 int mlx5_ib_devx_init(struct mlx5_ib_dev *dev);
 void mlx5_ib_devx_cleanup(struct mlx5_ib_dev *dev);
 void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile);
 #else
-static inline int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user,
+static inline int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
+				      struct mlx5_core_dev *mdev, bool is_user,
 				      u64 req_ucaps)
 {
 	return -EOPNOTSUPP;
 }
-static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid) {}
+static inline void mlx5_ib_devx_destroy(struct mlx5_core_dev *mdev, u16 uid) {}
 static inline int mlx5_ib_devx_init(struct mlx5_ib_dev *dev)
 {
 	return 0;
diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index fbb46d821865b3f87602068431365c46a40c2bcf..31a7c0f72b40fe95c9393a45add6526a4747ae9b 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -209,6 +209,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 {
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(
 		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
+	struct mlx5_ib_ucontext *c = to_mucontext(uobj->context);
 	struct mlx5_ib_dev *dev = to_dev(uobj->context->device);
 	struct ib_dm *ibdm = uobj->object;
 	struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
@@ -223,7 +224,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 	if (op >= BITS_PER_TYPE(u32))
 		return -EOPNOTSUPP;
 
-	if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
+	if (!(MLX5_CAP_DEV_MEM(uctx_to_mdev(c), memic_operations) & BIT(op)))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&dm->ops_xa_lock);
@@ -357,7 +358,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 					    struct uverbs_attr_bundle *attrs,
 					    int type)
 {
-	struct mlx5_core_dev *mdev = to_dev(ctx->device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(to_mucontext(ctx));
 	enum mlx5_sw_icm_type icm_type;
 	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
@@ -474,7 +475,7 @@ static int mlx5_dm_icm_dealloc(struct mlx5_ib_ucontext *ctx,
 			       struct mlx5_ib_dm_icm *dm)
 {
 	enum mlx5_sw_icm_type type = get_icm_type(dm->base.type);
-	struct mlx5_core_dev *mdev = to_dev(dm->base.ibdm.device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(ctx);
 	int err;
 
 	err = mlx5_dm_sw_icm_dealloc(mdev, type, dm->base.size, ctx->devx_uid,
diff --git a/drivers/infiniband/hw/mlx5/dmah.c b/drivers/infiniband/hw/mlx5/dmah.c
index 84641e06d63c1ebc20ac57dbc11c36a46554b638..a9419324f03d5606e51b08ea372ce0fbe4b436fc 100644
--- a/drivers/infiniband/hw/mlx5/dmah.c
+++ b/drivers/infiniband/hw/mlx5/dmah.c
@@ -13,7 +13,10 @@
 static int mlx5_ib_alloc_dmah(struct ib_dmah *ibdmah,
 			      struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
+	struct mlx5_ib_ucontext *uctx =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(uctx);
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
 	u16 st_bits = BIT(IB_DMAH_CPU_ID_EXISTS) |
 		      BIT(IB_DMAH_MEM_TYPE_EXISTS);
@@ -39,8 +42,11 @@ static int mlx5_ib_alloc_dmah(struct ib_dmah *ibdmah,
 static int mlx5_ib_dealloc_dmah(struct ib_dmah *ibdmah,
 				struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_ib_ucontext *uctx =
+		rdma_udata_to_drv_context(&attrs->driver_udata,
+					  struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dmah *dmah = to_mdmah(ibdmah);
-	struct mlx5_core_dev *mdev = to_dev(ibdmah->device)->mdev;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(uctx);
 
 	if (ibdmah->valid_fields & BIT(IB_DMAH_CPU_ID_EXISTS))
 		return mlx5_st_dealloc_index(mdev, dmah->st_index);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 83b49f0fcdc06c9e7ccbad3c8765d2b6ca7d484d..0d9ef66765c6894b76067593420dab0350d9847c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2238,7 +2238,8 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		return -EINVAL;
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
-		err = mlx5_ib_devx_create(dev, true, uctx->enabled_caps);
+		err = mlx5_ib_devx_create(dev, uctx_to_mdev(context), true,
+					  uctx->enabled_caps);
 		if (err < 0)
 			goto out_ctx;
 		context->devx_uid = err;
@@ -2340,7 +2341,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 
 out_devx:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
-		mlx5_ib_devx_destroy(dev, context->devx_uid);
+		mlx5_ib_devx_destroy(uctx_to_mdev(context), context->devx_uid);
 
 out_ctx:
 	return err;
@@ -2386,7 +2387,7 @@ static void mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 		if (uctx_rdma_ctrl_is_enabled(ibcontext->enabled_caps))
 			mlx5_cmd_remove_privileged_uid(dev->mdev,
 						       context->devx_uid);
-		mlx5_ib_devx_destroy(dev, context->devx_uid);
+		mlx5_ib_devx_destroy(uctx_to_mdev(context), context->devx_uid);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 48d5ab47b45c3d240409212f5ad18a68f1a14381..15d28cad7ea6c1778419e490ccc9c78c24920a06 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -276,7 +276,6 @@ struct mlx5_ib_steering_anchor {
 
 struct mlx5_ib_pp {
 	u16 index;
-	struct mlx5_core_dev *mdev;
 };
 
 enum mlx5_ib_optional_counter_type {
@@ -1301,6 +1300,11 @@ static inline struct mlx5_core_dev *mw_to_mdev(struct ib_mw *ibmw)
 	return pd_to_mdev(ibmw->pd);
 }
 
+static inline struct mlx5_core_dev *uctx_to_mdev(struct mlx5_ib_ucontext *uctx)
+{
+	return to_dev(uctx->ibucontext.device)->mdev;
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
diff --git a/drivers/infiniband/hw/mlx5/qos.c b/drivers/infiniband/hw/mlx5/qos.c
index fea229c29611d46dae2ecaa39f786f9063063233..420dfdc6f1fd3fd257f3c7ee6d7ef6d5ab3d3ed2 100644
--- a/drivers/infiniband/hw/mlx5/qos.c
+++ b/drivers/infiniband/hw/mlx5/qos.c
@@ -27,7 +27,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
 	struct ib_uobject *uobj = uverbs_attr_get_uobject(attrs,
 		MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE);
-	struct mlx5_ib_dev *dev;
+	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_ucontext *c;
 	struct mlx5_ib_pp *pp_entry;
 	void *in_ctx;
@@ -44,7 +44,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	if (!c->devx_uid)
 		return -EINVAL;
 
-	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 	pp_entry = kzalloc_obj(*pp_entry);
 	if (!pp_entry)
 		return -ENOMEM;
@@ -63,13 +63,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_PP_OBJ_ALLOC)(
 	uid = (flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX) ?
 		c->devx_uid : MLX5_SHARED_RESOURCE_UID;
 
-	err = mlx5_rl_add_rate_raw(dev->mdev, rl_raw, uid,
+	err = mlx5_rl_add_rate_raw(mdev, rl_raw, uid,
 			(flags & MLX5_IB_UAPI_PP_ALLOC_FLAGS_DEDICATED_INDEX),
 			&pp_entry->index);
 	if (err)
 		goto err;
 
-	pp_entry->mdev = dev->mdev;
 	uobj->object = pp_entry;
 	uverbs_finalize_uobj_create(attrs, MLX5_IB_ATTR_PP_OBJ_ALLOC_HANDLE);
 
@@ -86,9 +85,11 @@ static int pp_obj_cleanup(struct ib_uobject *uobject,
 			  enum rdma_remove_reason why,
 			  struct uverbs_attr_bundle *attrs)
 {
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(uobject->context));
 	struct mlx5_ib_pp *pp_entry = uobject->object;
 
-	mlx5_rl_remove_rate_raw(pp_entry->mdev, pp_entry->index);
+	mlx5_rl_remove_rate_raw(mdev, pp_entry->index);
 	kfree(pp_entry);
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index 3f15feca98b529fda3d2619a4c260b2398d895ee..40048a64f2a08dea48622562d473b1cbe9631b05 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -155,6 +155,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_QUERY_PORT)(
 {
 	struct mlx5_ib_uapi_query_port info = {};
 	struct mlx5_ib_ucontext *c;
+	struct mlx5_core_dev *mdev;
 	struct mlx5_ib_dev *dev;
 	u32 port_num;
 	int ret;
@@ -167,15 +168,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_QUERY_PORT)(
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 	dev = to_dev(c->ibucontext.device);
+	mdev = uctx_to_mdev(c);
 
 	if (!rdma_is_port_valid(&dev->ib_dev, port_num))
 		return -EINVAL;
 
-	if (mlx5_eswitch_mode(dev->mdev) == MLX5_ESWITCH_OFFLOADS) {
+	if (mlx5_eswitch_mode(mdev) == MLX5_ESWITCH_OFFLOADS) {
 		ret = fill_switchdev_info(dev, port_num, &info);
 		if (ret)
 			return ret;
-	} else if (mlx5_core_mp_enabled(dev->mdev)) {
+	} else if (mlx5_core_mp_enabled(mdev)) {
 		ret = fill_multiport_info(dev, port_num, &info);
 		if (ret)
 			return ret;

-- 
2.49.0

