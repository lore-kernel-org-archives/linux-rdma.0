Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369213;
	b=R9iEYioK2xRjGx3yL3CKaTP9y9YCUEsphxr+sU5lr7u8tQ1N2pXlhjKu+hAGVG57qamt
	 W9vmmXGW8TDwavEeBMIMD1QUYwXqFo3oy5xdG5A3vYjFwbuaea6Mg9ghh1wXYDnJAenqS
	 8HBdsE3sLgvEafyo1m5TTVkxNXO8+2q2NdLqY+yqHh1QQ9GujqHS9bjBJ4vuHiF972B9e
	 fEaPQUJIfewotJ0fTX2aSzw6V72UmOIqbiyt1EQespxfLn50nXyJ/WoLc/YCQFcdsBCTy
	 qm9AhPcFlZCkuJ7IZQuBKJinqxRlxux5PKtXW7EPagE4NK8LYkrwXdxKpE4fCdYORcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369213;
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
	bh=IEmMKXXutwe8YaSBF4PTrAHqwY5HK4m/EVa4UA5xJQQ=;
	b=zTzP9Ao4jqyDQ9mAykTlyFdl5RbmoZuH6Ivn3yKfTSpeDMoUwS2UQ7DsQgLuZ3CkxZ9e
	 RH35pcURNIfkZF7T4AYN6C0G9Rcso2u1T2iLsCAbw9KMsHkgUEg5KSzJ30aS+tC7Ec/Tx
	 7f+zSuPTuPbX0/UKAgCe7bs53YK/xDag5OvPDRdfFsAEgxqeB67jGA0C+OiqI1ynxwY+5
	 nH4DvvX60oenIWPqKQ83oiN4vBWfQ/WdGHWUUdQlaqLNE/43Oi2rCq6uTgkJOojNaXRrU
	 kpkQXClxZs3ZDR8ErrNUrFNeSfFs55RYdFcgE1RiHsgEOZOAyzCOs2vBtmjf/9xmRAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="bX/kxvsA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.33
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39118606A33A;
	Sun, 22 Nov 2026 17:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39118606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bX/kxvsA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRh5VxfoSu+xGolEuj4/mypeIMZopZDwJwmlXx2Y81RfFci+BDxDWPZSpm8SYcNDtm8FP7AHb5BeWMxPrib+5DAA/zELtZYWnMHZRkg6/XvDSjSHL4X0LtHVE4ZeFqkaqu2urcco27JGyz6ohNPa1bYep3doSh6bcfCgsskP+IjCCh0WaIrVQVXlPYWV5N1KKVZ7puQ5ky+y1KgvHzj9wRgpOKivDGm/CMwZEo6K3udFQLubxjrm5TLmZMvMHXT1UWQ4SP5O+uuD+iCtuCHKiz5Iefvyj37imHTGi/aHr30e/zInMT3s9faRHQwkn5XuF+aTU08z4kV9/M2L05fU7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEmMKXXutwe8YaSBF4PTrAHqwY5HK4m/EVa4UA5xJQQ=;
 b=Y8YyNjCQ4L+nphjp5eJcW7JCbjCtAhintQ182ynEFhU86bTbVb0OWJW8wZ6O/+DC9B6c/uzQ7FsgqZwf8po6q3PYZkkb8zph3OcZk+2hf1IjkQfyAUz6fCod5ORhKV0W1+C4KWPZXxUt9SdTQgMdDfhyawet740CMclMuNphWm3fIWH48+0x4L5OhrTLiZah0rvhP7ekIG1vK0utzc6lFh7ZQdizh7CsXiH6i4zCtPTJXf6eQ2JGQqKzoDflcvsgxlcuTsBKQbjknOTrieQ+oSu9LTd+mbKZsQtxYdNeF/sy+JkKKYpdOYMR9HlcNYIEq4wxa60a0/qo1ryLop54sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEmMKXXutwe8YaSBF4PTrAHqwY5HK4m/EVa4UA5xJQQ=;
 b=bX/kxvsA/Zax591oi44v7WnneCtDMl39XNgEmxbmgJa6Ib2LHUL/fgUvs8QiYuBGArm2rLeQWh6EiJ6cdkRZy0S8yAGrW/Y+ofezGb70+gKu+KszZlb2dGu/+4jAb3s8TQQMeQZNGvyXD3Haead97QGruu9XsoOEoablziG13KXMKEhNkN/lOFtFWMNhH8uX7CmZ1k4yZcvX/EOTH7MipmG3oJb8fSOa2OH7AH5Ow0UBEjdUZOUZu7kpkh+yKEXrd3kv4zIPwizqC9DreJh8E9LF3F44tWQEnPz/nO9N6FGP1MWPF1bfHCOByEsRNa5D50aSJX9WyW1uFa1uXK79qA==
Received: from MW4PR04CA0318.namprd04.prod.outlook.com (2603:10b6:303:82::23)
 by IA1PR12MB6188.namprd12.prod.outlook.com (2603:10b6:208:3e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 22 Nov
 2026 17:40:04 +0000
Received: from PH4PEPF0000B60F.namprd21.prod.outlook.com
 (2603:10b6:303:82:cafe::79) by MW4PR04CA0318.outlook.office365.com
 (2603:10b6:303:82::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:40:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 PH4PEPF0000B60F.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Sun, 22 Nov 2026 17:40:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:47 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:46 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:43 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:16 +0200
Subject: [PATCH rdma-next 8/9] RDMA/mlx5: Replay port configuration events
 after probe
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
Message-ID: <20261122-mlx5-port-events-probe-v1-8-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=10291;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=FQXPxKUGVuKgXvjf3OCcrBKQEJeEaIsFKr5r2beAzuI=;
 b=4D3X/oq6mYIo4AeU+DToDpzURJIJZYVlfthzjvQ+woVt/CZYLXxxHDKaA6vZge3/vYalw3KWe
 hHBilAs85u1BWWIDWyMV89mn8GUBEjwprDz041SCuHV9IF79SiMJDez
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60F:EE_|IA1PR12MB6188:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c64b4aa-df52-4c74-d761-08df48bfa3ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|22082099003|18002099003|6133799003|261009223027099003|261022075727099003|11063799006|56012099006|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261022105027099003|261021121427099003|261028144727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	btSGykjYxUEGe6LQ9LcF0PFZhIrvOOkaVkxpko26PFBAbGFOkX2eDUHxtlrytXZtIKvBqF5KwmGL0nEIH7honfbwBeEfCGnuQ/Fpw44Z36B5mU5CsVbftFWIA2TCzaDjEx4YjpYGELR53246iVhuiJS/GIagItLGGi6eEG/kvfmvokALtKT2SO7Smx80Dga8ZQq1lpbzaw4rPDEPulzWrNR1gcotZQ61ag+0cu3vT8IT39ucgheYZ++Vh8xILhBmkdGXwGtXYC6XWxv/YFGvuUWtKdrn3Ac6kMTDQ4Wcq5U0B32Fphd7YpcsPnfK+YKcBOPiDyxp5t9nKpSVjDQsVo2cK9A2R092UdKHKLK28hAPHgpIohRS+J19hPWJU5f7DSAowri89wssBTcRvywVJpGMzGT7TyRmr3XJ33j3m0fHUpeAzZJdCQwawyMsXWe14gvDpzCbN7XbkQCcc+7VbQJPgsMOTPBhoZeXYuETZPrKq6ypptoScIngrusowp5gBX+OZLVbLt9+diQ/ABfIBIFO19pS/yH39lt9bE1X8aedx7SBCAF8gjXslYpgLO3ndBxeBl1aLVHO5hIgO+Kh8GcFwH0GvvlRE/gk+R5iXt+n0Hicapm9g252LF5RZbFfRIo6DlFU1sWKPcBPfodV62I6Sw6U+BV3ioLb7ZWnCFcNMeTplJnUEXOhSh4TWEUyvWqCGRKVYNrcpMQ3lo/bag==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(22082099003)(18002099003)(6133799003)(261009223027099003)(261022075727099003)(11063799006)(56012099006)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022105027099003)(261021121427099003)(261028144727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CR8ZNBmM/jSk6PDg+AGlKZEHv7hl7rxdmoheVQT1+MWtkq76cRb10CQwf5XKvY5wD788qoz7/3SdyyGBBXQGIy8GIwBchhcbNDxOPPQiYT54cASAVcmG0vQIE2nZcAcw72Q8c6QPrnJNZ6AFnWoukSldM79zOst/AFOABp5HUK0+qT3OD/W1UNBoCWrHMiiAIhTmKT4KlkB+V9GjX8qnbP9Ac80E3X/PvBrQkkNoUQh8JflOJBMv+8w6LyvHvRY50UVTMR8mG36L4RnPYtNAqxtRDLm3du5YDEeO6TdOmIAbhhVHxD4XJjoNGTP1BIH3ShVOrNaQOvyMe+wzPtGuonN06pWMy4bXs3LaJC7euGoc4yuaxbUrMbm15++28pEsB0BiOS6oVYMI/8bI9R63Sd7blYf0IHeADoPw/quxHhHlfCFbSwY5T5K8niUsgaca
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:40:03.5348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c64b4aa-df52-4c74-d761-08df48bfa3ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6188

ib_register_device() lets ib_core and its clients read the port's LID
and P_Key table, and they refresh what they read only on the matching
event. mlx5_ib dispatches no event until the device becomes active at
the end of probe, so a configuration change in between is lost for
good.

On hypervisor setups the SM can program a VF's partitions while it
probes, putting the tenant P_Key at index 0 in front of the default
one. ib_sa then keeps the stale index of the default P_Key and its
queries are dropped:

  log_trap_info: Bad P_Key:0x802a on SL:0 from LID1:724 (GUID
  0xc42a1030048d4bc) QP1:0x1 to LID2:546 (GUID 0xc42a10300e720ce)
  QP2:0x1 port 20

so IPoIB never gets a carrier.

Commit 97834eba7c19 ("net/mlx5: Delay events till ib registration
ends") made mlx5_core hold such events back until the add completed,
but commit df097a278c75 ("IB/mlx5: Use the new mlx5 core notifier
API") moved mlx5_ib to a notifier that does not. This went unnoticed
for years, as a lost P_Key change matters only when it changes
index 0, used by IPoIB, or moves the default P_Key, whose index ib_sa
uses. OpenSM keeps the default P_Key at index 0 unless a partition is
marked indx0, as the tenant partition above is, and even then only a
small fraction of probes lose the race with the SM's write.

Commit ede132a5cf55 ("RDMA/mlx5: Move events notifier registration to
be after device registration") widened the window in which a change
breaks the SA queries: one during ib_register_device() no longer
rebuilds the GSI transmit QPs either.

Record LID and P_Key changes and client reregistration requests on
InfiniBand ports while the device is inactive, and replay them when it
becomes active, ahead of any later event. The replay processes them
with ib_dispatch_event_sync(), so that a replayed change cannot
overwrite the result of a newer one. GUID changes are not recorded, as
on InfiniBand ports ib_core notifies no client of them; a lost one
leaves only the GID cache stale. Port state changes are not recorded
either, being sensitive to the order in which ib_core delivers events.
While the device is inactive, the notifier now queues no handler at
all, rather than running the handlers without dispatching to ib_core.

A device that hits a system error during probe now fails it with -EIO
rather than being activated, which would also replay the recorded
events into it; its clients are then removed instead of being left with
a device that never reports the error.

ib_active becomes a bool, as the lock now covering it does not cover
is_rep and lag_active, which shared its byte as bit fields.

Events during ib_register_device() are still missed, as the notifier
is registered after it; the next patch fixes that.

Fixes: df097a278c75 ("IB/mlx5: Use the new mlx5 core notifier API")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 116 +++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +++-
 2 files changed, 123 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 80399920078edfca8f672fb77514ba6b90966068..8a9e68782a5c449e5565a098e75636d5054ee6c1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3118,6 +3118,73 @@ static int handle_port_change(struct mlx5_ib_dev *ibdev, u32 port, u8 sub_type,
 	return 0;
 }
 
+#define MLX5_IB_PORT_CONFIG_SUBTYPES			\
+	(BIT(MLX5_PORT_CHANGE_SUBTYPE_LID) |		\
+	 BIT(MLX5_PORT_CHANGE_SUBTYPE_PKEY) |		\
+	 BIT(MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG))
+
+static void record_port_event(struct mlx5_ib_dev *dev, u32 port, u8 sub_type)
+{
+	lockdep_assert_held(&dev->pending_events_lock);
+
+	/*
+	 * Only InfiniBand ports are recorded, as all their port events come
+	 * through this notifier. Port state changes are not, as unlike
+	 * configuration changes they are sensitive to the order in which
+	 * ib_core delivers the replayed events.
+	 */
+	if (!rdma_is_port_valid(&dev->ib_dev, port) ||
+	    mlx5_ib_port_link_layer(&dev->ib_dev, port) !=
+		    IB_LINK_LAYER_INFINIBAND ||
+	    sub_type >= BITS_PER_LONG ||
+	    !(BIT(sub_type) & MLX5_IB_PORT_CONFIG_SUBTYPES))
+		return;
+
+	dev->port[port - 1].pending_port_events |= BIT(sub_type);
+}
+
+static bool mlx5_ib_dev_active(struct mlx5_ib_dev *dev)
+{
+	bool active;
+
+	spin_lock_irq(&dev->pending_events_lock);
+	active = dev->ib_active;
+	spin_unlock_irq(&dev->pending_events_lock);
+
+	return active;
+}
+
+static void mlx5_ib_replay_port_events(struct work_struct *_work)
+{
+	struct mlx5_ib_dev *dev = container_of(_work, struct mlx5_ib_dev,
+					       pending_events_work);
+	struct ib_event ibev = { .device = &dev->ib_dev };
+	unsigned long pending;
+	u32 port, sub_type;
+	int err;
+
+	rdma_for_each_port(&dev->ib_dev, port) {
+		spin_lock_irq(&dev->pending_events_lock);
+		pending = dev->port[port - 1].pending_port_events;
+		dev->port[port - 1].pending_port_events = 0;
+		spin_unlock_irq(&dev->pending_events_lock);
+
+		for_each_set_bit(sub_type, &pending, BITS_PER_LONG) {
+			if (!mlx5_ib_dev_active(dev))
+				return;
+
+			if (handle_port_change(dev, port, sub_type, &ibev))
+				continue;
+
+			/* Processed before events queued behind this work */
+			err = ib_dispatch_event_sync(&ibev);
+			if (err)
+				mlx5_ib_warn(dev, "replayed event %d on port %u failed, %d\n",
+					     ibev.event, port, err);
+		}
+	}
+}
+
 static void mlx5_ib_handle_event(struct work_struct *_work)
 {
 	struct mlx5_ib_event_work *work =
@@ -3161,14 +3228,31 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 static int mlx5_ib_event(struct notifier_block *nb,
 			 unsigned long event, void *param)
 {
+	struct mlx5_ib_dev *dev =
+		container_of(nb, struct mlx5_ib_dev, mdev_events);
 	struct mlx5_ib_event_work *work;
+	unsigned long flags;
+
+	/* Until the device is active, keep only what is to be replayed */
+	spin_lock_irqsave(&dev->pending_events_lock, flags);
+	if (!dev->ib_active) {
+		if (event == MLX5_EVENT_TYPE_PORT_CHANGE) {
+			struct mlx5_eqe *eqe = param;
+
+			record_port_event(dev, mlx5_ib_eqe_port_num(eqe),
+					  eqe->sub_type);
+		}
+		spin_unlock_irqrestore(&dev->pending_events_lock, flags);
+		return NOTIFY_OK;
+	}
+	spin_unlock_irqrestore(&dev->pending_events_lock, flags);
 
 	work = kmalloc_obj(*work, GFP_ATOMIC);
 	if (!work)
 		return NOTIFY_DONE;
 
 	INIT_WORK(&work->work, mlx5_ib_handle_event);
-	work->dev = container_of(nb, struct mlx5_ib_dev, mdev_events);
+	work->dev = dev;
 	work->is_slave = false;
 	work->param = param;
 	work->event = event;
@@ -3203,6 +3287,7 @@ static void mlx5_ib_handle_sys_error_event(struct work_struct *_work)
 		container_of(_work, struct mlx5_ib_event_work, work);
 	struct mlx5_ib_dev *ibdev = work->dev;
 	struct ib_event ibev;
+	bool active;
 
 	ibev.event = IB_EVENT_DEVICE_FATAL;
 	mlx5_ib_handle_internal_error(ibdev);
@@ -3214,10 +3299,13 @@ static void mlx5_ib_handle_sys_error_event(struct work_struct *_work)
 		goto out;
 	}
 
-	if (ibdev->ib_active)
-		ib_dispatch_event(&ibev);
-
+	spin_lock_irq(&ibdev->pending_events_lock);
+	active = ibdev->ib_active;
 	ibdev->ib_active = false;
+	spin_unlock_irq(&ibdev->pending_events_lock);
+
+	if (active)
+		ib_dispatch_event(&ibev);
 out:
 	kfree(work);
 }
@@ -4457,6 +4545,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	}
 
 	mutex_init(&dev->lb.mutex);
+	spin_lock_init(&dev->pending_events_lock);
+	INIT_WORK(&dev->pending_events_work, mlx5_ib_replay_port_events);
 
 	err = mlx5r_cmd_query_special_mkeys(dev);
 	if (err)
@@ -5024,13 +5114,31 @@ static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 
 static int mlx5_ib_stage_active_init(struct mlx5_ib_dev *dev)
 {
+	/*
+	 * Fail a device that hit a system error during probe, as the error
+	 * handler may already have run. The replay is queued in the same
+	 * critical section, so that it runs before any event the notifier
+	 * queues once it sees the device active.
+	 */
+	spin_lock_irq(&dev->pending_events_lock);
+	if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+		spin_unlock_irq(&dev->pending_events_lock);
+		return -EIO;
+	}
 	dev->ib_active = true;
+	queue_work(mlx5_ib_event_wq, &dev->pending_events_work);
+	spin_unlock_irq(&dev->pending_events_lock);
+
 	return 0;
 }
 
 static void mlx5_ib_stage_active_cleanup(struct mlx5_ib_dev *dev)
 {
+	spin_lock_irq(&dev->pending_events_lock);
 	dev->ib_active = false;
+	spin_unlock_irq(&dev->pending_events_lock);
+
+	cancel_work_sync(&dev->pending_events_work);
 }
 
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 3884e5524e7dfb2a37515a6f4e8caaa82224c964..7e1e0bcd096c994473dcfe2db5655b47bd48915e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -860,6 +860,8 @@ struct mlx5_ib_port {
 	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
 	struct mlx5_roce roce;
 	struct mlx5_eswitch_rep		*rep;
+	/* Port change subtypes to replay, protected by pending_events_lock */
+	unsigned long			pending_port_events;
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_reserved_gids *reserved_gids;
 #endif
@@ -1100,13 +1102,21 @@ struct mlx5_ib_dev {
 	 */
 	struct mutex			data_direct_lock;
 	struct notifier_block		mdev_events;
+	/* Protects ib_active writes and the ports' pending_port_events */
+	spinlock_t			pending_events_lock;
+	struct work_struct		pending_events_work;
 	struct notifier_block		sys_error_events;
 	struct notifier_block           lag_events;
 	int				num_ports;
 	/* serialize update of capability mask
 	 */
 	struct mutex			cap_mask_mutex;
-	u8				ib_active:1;
+	/*
+	 * Written under pending_events_lock, and read under it when the read
+	 * must be ordered with activation or with port event recording and
+	 * replay.
+	 */
+	bool				ib_active;
 	u8				is_rep:1;
 	u8				lag_active:1;
 	u8				fill_delay;

-- 
2.49.0

