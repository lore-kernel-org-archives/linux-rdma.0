Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795873005;
	b=N+/ji487PiiwEWeqn2+29I+B6lSh5eyc53j8kqgDtIxrdwr+N11Uolma/tk1dMdV8DCk
	 0N1EVcimPRdBxLMzqUdyg3+htNTbslyoXzqtpDLGZUufQY0Fq4XnSnjJAkW/ULgntAtRa
	 I0fzHbDP/EaLKmXz3J6oySE1M0ZHIDd2pycfVe50rFwvukbPn/Wi5eOSFVbKkgonTpP3b
	 NOJHATPA37OYv8/FI9Ht8+eP7coijN5ZQbV77hQojxNpZxz7vmYEeSJsBa31nx6FSMn7p
	 cUt5R9A+ktM+pjtxGB3lCimHSGrjJSrMSklWAXT4NCtG/zQCN5SOKEMtpwP7Bchk4OQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795873005;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 CC:X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=gF9AFt4GDSBjn386b1eKHluP/RyvTux6SGgUjQi3+VU=;
	b=aUuWmbqC8+y7yNmlY1HlOQq2uc15XWOyK0CtJi058pwApLBgrxY1Rm7eDJrV3skqaPxc
	 h7FeyRSzLLzFgloBHTe1g/OW5XHjKP+CFFzxdWU1o/7cWVnReZIYlr5yuo9LE75LpDkcr
	 vhwTAG9riZPHuDhyuegx+ZdzdQ6jIckl0XJ0N7fiO7GVR8sFvxxXdaPryeDV/VLBP8HmO
	 kEZ+7beexS5NAyHtAZMMf4mtFKarAqmpeUvYqa2aAe8mS2Fy/ukk88dXETbuNKol4iFlw
	 GTf8/I2Rmoki6zArykfNq0oxKXu/qsl+c2pNiLbFMUMKqHFN41fnRKsp5yp73D7g0yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nn9XStDj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.30
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010030.outbound.protection.outlook.com [52.101.201.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F028606A31C;
	Sat, 28 Nov 2026 13:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F028606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nn9XStDj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vlHwfaScoLK5H9Tasl3o83oc+mc1pDPAM+W09ORpU5+uNjHqDVXephrzXV26GIDj1s2hMNNcJA5LU57TxcgmwcDrGe/flzi4Eh/8+hM/gNsVyoWvpJEqZAX7A5/GA1vpo62LQQ0xlrwq9roFu1zwWfh7s6ZhdXz51oBOuqIzGcXBBYCU+NxyZ9mAho28Tr5eowLs8N3FhhOdgDZB3Psl7bJBjMFJOwAVYU2WqpAjDHEOF+nKYHoPYEuwJcYBvacJRXITPM0BGwqHLHKc1Ov13dpDZkSpbowwH4CYHKSRFatEstKwQxuSJuSo8LNNwYsf95ONb7bX+KaJWnRf9n/Tcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gF9AFt4GDSBjn386b1eKHluP/RyvTux6SGgUjQi3+VU=;
 b=yzlMOYBwG/Yi1+Qy9p4Di4FS/f+BKI8lBkK3eugAJ7F9NMCCbUOXvm73IUjoIoRnzm6aiJ/c2NYysJXCSIadJJ9mRqODMlTbPtsjJsMj0s6D2yhedisrHjzwN6hqIAtV6/Xp0dz1Jn9q+HVjGHNaLWlXEQdaBUTj/BRA93ln3MnjbIC8DICcinSO8ZK6EnfXCjOq008mWs3ozFm33996cUPVFA4eqdjkmoeRl3zxxjEUPEJFcx2v/cHrrUnfgh/Mw6fBEu743skUzsP6ayKBK+ie1YJzRy3gz8vqf5ObmnMCUOc0OqJ4VoHqFHorVSfSv+74chOBwrXvTZ+zAIipkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF9AFt4GDSBjn386b1eKHluP/RyvTux6SGgUjQi3+VU=;
 b=nn9XStDj4KBQg3KjksXhyfkiIAWeU9fwIp8Fw5u9B7YaYwAFSZEDQaC7lySYdi+YRvRMtku3Zmiv5zJr1C1pFUrTB3IHtqmyeXEZRqV5l9q7ihqru+OrZfu5ny8HtzOz+mXITVBTMn5GC/Q79HKmsk5s0d3leocv9DRfvWM1t233hDCPI5mwEPqjCV5+8puqIH7AWQL49rjtjn1b7yzBYKvYGBuTgKHojlmMirM9+a+X4wRrU/4lyfoagAvS8qUbh7ai8b9UMmpaMztmQr+aODVYCfS3wt6kxx1t6CXALb/ZSbCZxmBzQwf00oFhTyPaJIEIcRfUDIGdhG1ZJRDOLg==
Received: from DM6PR02CA0206.namprd02.prod.outlook.com (2603:10b6:5:1f4::34)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:36:39 +0000
Received: from DS4PEPF000001BF.namprd21.prod.outlook.com
 (2603:10b6:5:1f4:cafe::4d) by DM6PR02CA0206.outlook.office365.com
 (2603:10b6:5:1f4::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:36:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS4PEPF000001BF.mail.protection.outlook.com (10.167.23.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.0 via Frontend Transport; Sat, 28 Nov 2026 13:36:38 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:32 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:36:32 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Sat, 28
 Nov 2026 05:36:28 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next 0/3] RDMA/mlx5: Support pinned revocable dma-buf
 import
Date: Sat, 28 Nov 2026 15:36:24 +0200
Message-ID: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
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
X-B4-Tracking: v=1; b=H4sIANjYCmsC/x2MwQqDMBAFf0X23IUkxdL0V0oP0by0C7pKYktA/
 PcGjwMzs1NBFhR6dDtl/KTIog3spaPxE/QNltiYnHE3a92d56n2vIoqIrdgGcMwgeMchm/iq4U
 3xvmQPKgt1owk9dw/KTeJFXWj13H8Af6ByGl5AAAA
X-Change-ID: 20261128-mlx5-pinned-revocable-dmabuf-31e90029af9e
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?q?Christian_K=C3=B6nig?=
	<christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>, Edward Srouji <edwards@nvidia.com>, "Chiara
 Meiohas" <cmeiohas@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795872988; l=2286;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=bqmIs5LVzFSW0Fd0YnCf6uJcHNyAh3qaC5N7ewshRE8=;
 b=2ygnlv8nhV+9jssWXMx4oAdhDfELzaJj3aMnlBUK5wxkmKiJ+aACVNGYvMcl0L9CZHtufYFoN
 uTCDBlRdVmwCGrQwa8wz6W6mxEnrSpgqF4ftE7++t+stEIs1vItPcrN
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PEPF000001BF:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: 6014ab7c-a26a-41c2-f40f-08df4d54a14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|82310400026|376014|7416014|10067099003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	iFt1OJS/bLOfc/3OeKj4EGgr4QKVgl8BVoOs7Gt5UoisX4SSiuYnlvqqhIkyJ+76ZOqP+tzOloYccMyy9Ofv3BL0XD05yv3/PUPoOt+VhJpLYqWb8fLiu5mPCN9R1eLxdi5u5DctxRBgABuJZuSNhaGJYrqjcWdhdRftKXZkYAyFG27lUE2264e4DeU0YjFcUtvRbQGbT/gAt7qy9Uwm4iVhN3QGVm5vx+nxddKK2VeL0bsggPkXBnyPxfpzBkO7eHAJJuQLr4Jp7qQdXhbFjAU2YdX6hNbSFD0f8KEfoV5uFlv7jAia9zC6FpqtJVgHrgf75ZS3940K/79O8rkQwbqLiMkHrEX6rdiBQOcEqhSjVl20FHhFPtDj62CDybTtmMhF2eh7zqsca/XXLEmJpEVeQs8SgO7R9BCidi23ZHDyk8K1wrHht2KCqJJXNM2lyplzbjplvatxmvkphwjsTEscSAxAZahdWBJeZEgZ1UxspXzxZrFAlwPg/h9YQZrnt6TCcH5r+oPMTPoQioj2hUGjRITrRjuQkhSbx7wtnn1d22tdkQTpweB3+ung9iJUmHG2/ZzEHSR18HmwdEheKZ9ahlzp2Q5OFrmuOit6L6ZvOK+wlTEUZuqZxmJyRjI2Ehajdidyi6SQss08nug6o9t/fDnnTLWF9+Vqb2PMtUUTApuy2kHh6GlfYr9yT66IlD09Ch7rbN9R5MXs8RI6LA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(82310400026)(376014)(7416014)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VkO5X3FrbX3bALfcAvoRlARRzNqPTLGIFMj/9SkGeLuZ0aws5fmKaPClSP9jvgUs0Dfn2/+88MyBfz1YR9pelh+hWILs1RHacjxzKop6DDUii1wYYoIFNKCNavo1dSL3UT5X7NVjGED3JPpzmWKhH1tjvgNN2+GWmzWFQddxCSY7bSgFHqah2PGFNi+ifM7w0CTa3dVS/Vwd4ILW3ZifdR3MxsH7Z8QgfKMhtsZ9QeafoirHmcseKVnPWvAKDn7P8iCGUt+jZlmSZqfbvncbgB4LXXyzGCi24vHjg5lirFBGPagfxQSc6NdhFgaI5jpKexOx6vuTz8taZHnGQDOhoHvUWdCxlx4X0YK4Sdim28O4h+36lFuKucsP2/UIzOk1AJgLJhmAFrb50j51B7xxERZ0iG3MSY14aiFaDuHlAOAL/lifRvBvEOC1wCddL1E9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:36:38.7531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6014ab7c-a26a-41c2-f40f-08df4d54a14e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS4PEPF000001BF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321

Today mlx5 imports every dma-buf as movable. The mkey is sized for the
worst case, one entry per PAGE_SIZE of the dma-buf, and an invalidation
zaps the mkey and relies on ODP page faults to map it again. This makes
dma-buf MRs depend on CONFIG_INFINIBAND_ON_DEMAND_PAGING, and wastes
translation entries for exporters that never move their memory, such as
when GPU or device memory is registered for peer-to-peer DMA.

Exporters of PCI BAR memory, VFIO and the uverbs dma-buf export, do not
move the memory, but they must be able to take it away on a reset or a
memory-disable. The dma-buf core supports this with pinned revocable
attachments (dma_buf_attach_revocable()), and irdma already imports
dma-bufs this way, see commit 4707bf5f6c86 ("RDMA/irdma: Add support for
revocable pinned dmabuf import").

This series adds the same support to mlx5:

- Patch 1 lets the uverbs dma-buf export accept pinned importers that
  can handle a revoke.

- Patch 2 moves the dma-buf MR init out of the ODP-only odp.c into mr.c,
  with no functional change.

- Patch 3 makes mlx5 try a pinned revocable import first. When the
  exporter grants it, the buffer cannot move, so the mkey is sized
  exactly to its mapping. Otherwise mlx5 falls back to the existing
  movable import, which is the only case that still requires ODP. On a
  revoke the mkey is disabled with a UMR, so the device stops accessing
  the buffer before the exporter takes the memory away.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Chiara Meiohas (2):
      RDMA/uverbs: Permit dma-buf export to work with pinned importers
      RDMA/mlx5: Move dma-buf MR init out of ODP-only compilation

Yishai Hadas (1):
      RDMA/mlx5: Try pinned revocable dmabuf import by default

 drivers/infiniband/core/uverbs_std_types_dmabuf.c |  14 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |   7 +-
 drivers/infiniband/hw/mlx5/mr.c                   | 187 ++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/odp.c                  |  58 +------
 4 files changed, 185 insertions(+), 81 deletions(-)
---
base-commit: 94e81a1f3ffabb388f7d0a9674bb1d3acc067e00
change-id: 20261128-mlx5-pinned-revocable-dmabuf-31e90029af9e

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

