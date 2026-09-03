Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05037470433;
	Thu,  3 Sep 2026 08:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425770; cv=fail; b=B3hstiqDtgKtEe1nhcY0hRlfKY25GDOH60xkY6eh2QRhOnokzYDG0ONW3CJ9OyAdMQUIppWd5qSUwiwZGsn3pjBhluLuhyAtmo5uuaw/PsJBxk2DTrkHFRPeOCKd4OEZQxb6oYMDfO/6L8H5iReAJHmqOrLXv3c20JhjMtXV6UA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425770; c=relaxed/simple;
	bh=Eph/fPcH/GzyvLBwlajSWThGWMqf/QjxgPQA9yHK1Bw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XIQJLAkkiQWqd64bfJzZz2FM15Qj3QDRvBAcCNxjMJ6Dq+f9B0XLKWya/GS2Gf08zOXngYBb7aIvvDjxH/CyzCWlrhQip1Hv19FPXGV3h73mAywzz+4gkU2cAgGI1MPAl/7AeT9LYqRyh751N/HZ/BGFLNGvvta4YIPHArc1LeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VNgI1Gkl; arc=fail smtp.client-ip=52.101.57.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VNgI1Gkl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NWIZ8/cXG4Ioj027KCmAsEh3/InscQhUUylix+tgBgZPipG5vghz/YOxo7+MAaY3ZZQ10+cRBk8EcgkdlGqQYrdHqqgT03KJz610EimMTCcuLKyPkESegcvba8TWWDfF4poot0gwCer/1AnyWvc1TwRYYh6ccjM3Lf9//1BWMKwFlxEklfwf4qvn9005Tp0fBDSMMhhq/oVD4qpe6g5W7IuRVVUQFBJuF3v7jcSJhNn6dKowL06wCXYym9rvW7QafZ1yS8YIcmKsm4wwiyxj0Nmz1AaDjC4ul+OTb0M8pe2u3b50zn7AVxgzFy2H7VXHMcaY78+MJSggvfgrtAplWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Oj4FKTMYS54bb5iovvFFhV7syeoubeLMAjRuEb/1EE=;
 b=rvkTHV3tZAQglIaXpzu3JaisqmYlpDP3F1o2e27dU4BgJT7FdZFD7igUEtmWyJo+2oeAO1kHazt5G4S9g4mqy8X57Y5gDf7lQKqlXPPAqXljAd1UE9SEPWuuQ++saBnUfL8aZwIQKjzW+A7VmKUOa07aAybxp3eY/7LoqLjMMAXbO61q1E/QIthgluEG6ZphsAk+nVB/TeZmM8NuvHU5ZfDsoRUkMfGBzJDy1y4P7CTSWLMWBB1GLR58oPOgo+uMO0/mwo4EydvwnnCpzSx5ugy7mEgtl9+Y4WqbTikUWCSUN+yHUfvQLjxIFrSIJnIiS1gQkTyOlaWaV9N4UjQHrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Oj4FKTMYS54bb5iovvFFhV7syeoubeLMAjRuEb/1EE=;
 b=VNgI1GklNUOF2EcKv9kNQgkjj4ufaUgXrBIF+7xCjaJYndinp+W3B4PoFIxlbGmQbL50D01cW1751goMWxMwb90HGK5zsgqjLqu2nQtwKqYWrwFc5/9Z8N/RY5Ue+3H7ujQNrecjy0FvCEVPcQvmVtmSLyIodkSyrCaWNwElX2S/pBfVY1aFmS2SbZ2N+XWyGS8MvKQ+05JLxfOC9aTTnxmKH7eVtvJ4o6Jt1iFN7aZN/NwNK1aH/GIHAU/Vyq1UccoxfayORlyHUyFlfQA+4tP8rEO9ijDaghaLLnyjcy334kwbpY9bKbxKwr6N8gnmNyPfiAYRjdfSnWbg/CurmA==
Received: from CH0PR13CA0036.namprd13.prod.outlook.com (2603:10b6:610:b2::11)
 by LY0PR12MB120611.namprd12.prod.outlook.com (2603:10b6:408:3b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:56:00 +0000
Received: from BN2PEPF0000A803.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::7d) by CH0PR13CA0036.outlook.office365.com
 (2603:10b6:610:b2::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.3 via Frontend Transport; Thu, 3
 Sep 2026 08:56:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A803.mail.protection.outlook.com (10.167.245.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:56:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:37 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:36 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:55:25 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 13/15] selftests: drv-net: gro: Extract shared helpers into gro_lib.py
Date: Thu, 3 Sep 2026 11:52:13 +0300
Message-ID: <20260903085215.3691657-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A803:EE_|LY0PR12MB120611:EE_
X-MS-Office365-Filtering-Correlation-Id: 107084a1-ee8b-4dfa-0365-08df09992d23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|7416014|376014|6133799003|3023799007|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	6ccSsmJi2ak1lBO7hz+jtXiAeoTiVJM99TfHNyS/7yWZQeTpFJmIq4usoDmK3QnPdNrQ+izp7flM1yABe69VBFhvTlJqmDUXQgxtP4fHGniuIdvxdutNHsLe0JuSBincsIj2oOnLfFGSEQlpfT9bpB2NGtBUYuZvkPfoqnGUQVRP9y9ZbwMf5tfTf9F0mFq6aGVVnHNwcgB3kcLvqEP3OWXyI/+PWOVhhBLYrMcLMFZJiPSq/LtQoF0yTfdeg4J+wgjW5YqAA0wZqKqMotglzXbI0fjIJ8bearoeFeqBWjfI6u/sFn3bpEIpCRSPmZW+eewUNYDr97REmeQLLisUegN+0frBjEDaoZIhKHj71X0FgB8x9yPAD64a5nXtZlBsBZ+L35OWDhnBmt5MSwqUBGqNK74a/5nNeOTiGuWMOSpScpoNPcrRKoOG8VlYKSZetejO40sLgQHdLL+h33EatyRaV6Gb8i98gW/GcQFlXT4TawCiQBgX+geErXPXtcDLTL3aneT/kKwP4DF0pwS3LGLHuuhwxfzJeeKshw9qg3GbZrHWyPlwfmOwyLHbtKuc90DZxlE5pNSdBs3dyGpInx6ZeOz1Tp3IZ7KK0vsUMir3oLFBxXL1SPKrFoxxPaEYJ8VAw74AZJCWYu2zpB7yYxJ8xQKIYu1yrjV15eX+FCEjt23QMzyCrTXxrkfaFGyAfl8ApqT2u7x3gvhgHF6tWg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(376014)(6133799003)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K8o/38XdimDLNL5lgKayP6WK1V4KmNkGVUcMdNpaK8iNXOoGaurwwN1pEXMtTlyzZ11RRzjMYKoMhG2XDjFWKRNouuVA0ns7jVVqfqb4C5ItoIMumg7eVdYlv7H6TwQRha/+bGdnokY1fEbDALRtMrOpuglYyCCeP0I4pCiAflkMFkDUH11kJs9oq+/EOpsSInowhSUzKIvXd75UZyP4Z4xpMKxbKQdpQbgLJ5okMOXOqsOTw9y/Tmcs90Wj6JJN2eGqog/i2PchuDafRGT5u4229UsEKmk045e6/JKkklEZxJ8Zxqvhj1QSAdoSRG3qHbXHMPUU1C4CwypfFnADbBOycjofULYMEXbGxNlQaVa8TfSI65xYtymPsirWO5XxJC6u/qyu/V3/ID5+ItMELhz2Z04X/zqOLtZ+xtWEPa3Z/Xj11CVBhkoyRGRzYA7O
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:56:00.0330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 107084a1-ee8b-4dfa-0365-08df09992d23
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A803.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB120611

From: Cosmin Ratiu <cratiu@nvidia.com>

Bits and pieces of gro.py are needed by a second test file:
- dmac resolution
- the ethtool/sysfs feature dance
- the HW GRO setup logic
- the gro binary invocation
- the retry loop

Move them to gro_lib.py, installed via TEST_FILES (like psp_lib.py).

hw/gro_hw.py keeps its own copies for now since they diverged.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/drivers/net/Makefile  |   1 +
 tools/testing/selftests/drivers/net/gro.py    | 200 ++----------------
 .../testing/selftests/drivers/net/gro_lib.py  | 194 +++++++++++++++++
 3 files changed, 217 insertions(+), 178 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/gro_lib.py

diff --git a/tools/testing/selftests/drivers/net/Makefile b/tools/testing/selftests/drivers/net/Makefile
index d68f9ab8955d..be77a15eaf38 100644
--- a/tools/testing/selftests/drivers/net/Makefile
+++ b/tools/testing/selftests/drivers/net/Makefile
@@ -28,6 +28,7 @@ TEST_PROGS := \
 # end of TEST_PROGS
 
 TEST_FILES := \
+	gro_lib.py \
 	psp_lib.py \
 # end of TEST_FILES
 
diff --git a/tools/testing/selftests/drivers/net/gro.py b/tools/testing/selftests/drivers/net/gro.py
index 6ab8c97880d1..7111095bb479 100755
--- a/tools/testing/selftests/drivers/net/gro.py
+++ b/tools/testing/selftests/drivers/net/gro.py
@@ -37,90 +37,20 @@ Test cases:
 """
 
 import glob
-import os
 import re
 from lib.py import ksft_run, ksft_exit, ksft_pr
-from lib.py import NetDrvEpEnv, KsftFailEx, KsftXfailEx
+from lib.py import NetDrvEpEnv, KsftXfailEx
 from lib.py import NetdevFamily, EthtoolFamily
-from lib.py import bkg, cmd, defer, ethtool, ip
+from lib.py import defer, ethtool
 from lib.py import ksft_variants, KsftNamedVariant
+from gro_lib import run_gro_bin, run_with_retries, set_ethtool_feat
+from gro_lib import set_mtu_restore, setup_hw_gro, write_defer_restore
 
 
 # gro.c uses hardcoded DPORT=8000
 GRO_DPORT = 8000
 
 
-def _resolve_dmac(cfg, ipver):
-    """
-    Find the destination MAC address remote host should use to send packets
-    towards the local host. It may be a router / gateway address.
-    """
-
-    attr = "dmac" + ipver
-    # Cache the response across test cases
-    if hasattr(cfg, attr):
-        return getattr(cfg, attr)
-
-    route = ip(f"-{ipver} route get {cfg.addr_v[ipver]}",
-               json=True, host=cfg.remote)[0]
-    gw = route.get("gateway")
-    # Local L2 segment, address directly
-    if not gw:
-        setattr(cfg, attr, cfg.dev['address'])
-        return getattr(cfg, attr)
-
-    # ping to make sure neighbor is resolved,
-    # bind to an interface, for v6 the GW is likely link local
-    cmd(f"ping -c1 -W0 -I{cfg.remote_ifname} {gw}", host=cfg.remote)
-
-    neigh = ip(f"neigh get {gw} dev {cfg.remote_ifname}",
-               json=True, host=cfg.remote)[0]
-    setattr(cfg, attr, neigh['lladdr'])
-    return getattr(cfg, attr)
-
-
-def _write_defer_restore(cfg, path, val, defer_undo=False):
-    with open(path, "r", encoding="utf-8") as fp:
-        orig_val = fp.read().strip()
-        if str(val) == orig_val:
-            return
-    with open(path, "w", encoding="utf-8") as fp:
-        fp.write(val)
-    if defer_undo:
-        defer(_write_defer_restore, cfg, path, orig_val)
-
-
-def _set_mtu_restore(dev, mtu, host):
-    if dev['mtu'] < mtu:
-        ip(f"link set dev {dev['ifname']} mtu {mtu}", host=host)
-        defer(ip, f"link set dev {dev['ifname']} mtu {dev['mtu']}", host=host)
-
-
-def _set_ethtool_feat(dev, current, feats, host=None):
-    s2n = {True: "on", False: "off"}
-
-    new = ["-K", dev]
-    old = ["-K", dev]
-    no_change = True
-    for name, state in feats.items():
-        new += [name, s2n[state]]
-        old += [name, s2n[current[name]["active"]]]
-
-        if current[name]["active"] != state:
-            no_change = False
-            if current[name]["fixed"]:
-                raise KsftXfailEx(f"Device does not support {name}")
-    if no_change:
-        return
-
-    eth_cmd = ethtool(" ".join(new), host=host)
-    defer(ethtool, " ".join(old), host=host)
-
-    # If ethtool printed something kernel must have modified some features
-    if eth_cmd.stdout:
-        ksft_pr(eth_cmd)
-
-
 def _get_queue_stats(cfg, queue_id):
     """Get stats for a specific Rx queue."""
     cfg.wait_hw_stats_settle()
@@ -182,47 +112,6 @@ def _setup_queue_count(cfg, num_queues):
     ethtool(f"-L {cfg.ifname} combined {num_queues}")
 
 
-def _run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
-                 order_check=False, verbose=False, fail=False):
-    """Run gro binary with given test and return the process result."""
-    if not hasattr(cfg, "bin_remote"):
-        cfg.bin_local = cfg.net_lib_dir / "gro"
-        cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
-
-    if protocol is None:
-        ipver = cfg.addr_ipver
-        protocol = f"ipv{ipver}"
-    else:
-        ipver = "6" if protocol[-1] == "6" else "4"
-
-    dmac = _resolve_dmac(cfg, ipver)
-
-    base_args = [
-        f"--{protocol}",
-        f"--dmac {dmac}",
-        f"--smac {cfg.remote_dev['address']}",
-        f"--daddr {cfg.addr_v[ipver]}",
-        f"--saddr {cfg.remote_addr_v[ipver]}",
-        f"--test {test_name}",
-    ]
-    if num_flows:
-        base_args.append(f"--num-flows {num_flows}")
-    if order_check:
-        base_args.append("--order-check")
-    if verbose:
-        base_args.append("--verbose")
-
-    args = " ".join(base_args)
-
-    rx_cmd = f"{cfg.bin_local} {args} --rx --iface {cfg.ifname}"
-    tx_cmd = f"{cfg.bin_remote} {args} --iface {cfg.remote_ifname}"
-
-    with bkg(rx_cmd, ksft_ready=True, exit_wait=True, fail=fail) as rx_proc:
-        cmd(tx_cmd, host=cfg.remote)
-
-    return rx_proc
-
-
 def _setup(cfg, mode, test_name):
     """ Setup hardware loopback mode for GRO testing. """
 
@@ -237,60 +126,39 @@ def _setup(cfg, mode, test_name):
 
     # "large_*" tests need at least 4k MTU
     if test_name.startswith("large_"):
-        _set_mtu_restore(cfg.dev, 4096, None)
-        _set_mtu_restore(cfg.remote_dev, 4096, cfg.remote)
+        set_mtu_restore(cfg.dev, 4096, None)
+        set_mtu_restore(cfg.remote_dev, 4096, cfg.remote)
 
     if mode == "sw":
         flush_path = f"/sys/class/net/{cfg.ifname}/gro_flush_timeout"
         irq_path = f"/sys/class/net/{cfg.ifname}/napi_defer_hard_irqs"
 
-        _write_defer_restore(cfg, flush_path, "200000", defer_undo=True)
-        _write_defer_restore(cfg, irq_path, "10", defer_undo=True)
+        write_defer_restore(cfg, flush_path, "200000", defer_undo=True)
+        write_defer_restore(cfg, irq_path, "10", defer_undo=True)
 
-        _set_ethtool_feat(cfg.ifname, cfg.feat,
-                          {"generic-receive-offload": True,
-                           "rx-gro-hw": False,
-                           "large-receive-offload": False})
+        set_ethtool_feat(cfg.ifname, cfg.feat,
+                         {"generic-receive-offload": True,
+                          "rx-gro-hw": False,
+                          "large-receive-offload": False})
     elif mode == "hw":
-        _set_ethtool_feat(cfg.ifname, cfg.feat,
-                          {"generic-receive-offload": False,
-                           "rx-gro-hw": True,
-                           "large-receive-offload": False})
-
-        # Some NICs treat HW GRO as a GRO sub-feature so disabling GRO
-        # will also clear HW GRO. Use a hack of installing XDP generic
-        # to skip SW GRO, even when enabled.
-        feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
-        if not feat["rx-gro-hw"]["active"]:
-            ksft_pr("Driver clears HW GRO and SW GRO is cleared, using generic XDP workaround")
-            prog = cfg.net_lib_dir / "xdp_dummy.bpf.o"
-            ip(f"link set dev {cfg.ifname} xdpgeneric obj {prog} sec xdp")
-            defer(ip, f"link set dev {cfg.ifname} xdpgeneric off")
-
-            # Attaching XDP may change features, fetch the latest state
-            feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
-
-            _set_ethtool_feat(cfg.ifname, feat,
-                              {"generic-receive-offload": True,
-                               "rx-gro-hw": True,
-                               "large-receive-offload": False})
+        setup_hw_gro(cfg)
     elif mode == "lro":
         # netdevsim advertises LRO for feature inheritance testing with
         # bonding/team tests but it doesn't actually perform the offload
         cfg.require_nsim(nsim_test=False)
 
-        _set_ethtool_feat(cfg.ifname, cfg.feat,
-                          {"generic-receive-offload": False,
-                           "rx-gro-hw": False,
-                           "large-receive-offload": True})
+        set_ethtool_feat(cfg.ifname, cfg.feat,
+                         {"generic-receive-offload": False,
+                          "rx-gro-hw": False,
+                          "large-receive-offload": True})
 
     try:
         # Disable TSO for local tests
         cfg.require_nsim()  # will raise KsftXfailEx if not running on nsim
 
-        _set_ethtool_feat(cfg.remote_ifname, cfg.remote_feat,
-                          {"tcp-segmentation-offload": False},
-                          host=cfg.remote)
+        set_ethtool_feat(cfg.remote_ifname, cfg.remote_feat,
+                         {"tcp-segmentation-offload": False},
+                         host=cfg.remote)
     except KsftXfailEx:
         pass
 
@@ -356,31 +224,7 @@ def test(cfg, mode, protocol, test_name):
 
     _setup(cfg, mode, test_name)
 
-    # Each test is run 6 times to deflake, because given the receive timing,
-    # not all packets that should coalesce will be considered in the same flow
-    # on every try.
-    max_retries = 6
-    for attempt in range(max_retries):
-        fail_now = attempt >= max_retries - 1
-        rx_proc = _run_gro_bin(cfg, test_name, protocol=protocol,
-                               verbose=True, fail=fail_now)
-
-        if rx_proc.ret == 0:
-            return
-
-        ksft_pr(rx_proc)
-
-        # ret==42 means the receiver detected over-coalescing.
-        # This is unambiguous proof of a bug, retries can only cause
-        # false negatives.
-        if rx_proc.ret == 42:
-            raise KsftFailEx(f"GRO over-coalesced in {protocol}/{test_name}")
-
-        if test_name.startswith("large_") and os.environ.get("KSFT_MACHINE_SLOW"):
-            ksft_pr(f"Ignoring {protocol}/{test_name} failure due to slow environment")
-            return
-
-        ksft_pr(f"Attempt {attempt + 1}/{max_retries} failed, retrying...")
+    run_with_retries(cfg, test_name, protocol=protocol, verbose=True)
 
 
 def _capacity_variants():
@@ -420,7 +264,7 @@ def test_gro_capacity(cfg, mode, setup_func):
             if queue_id is not None:
                 stats_before = _get_queue_stats(cfg, queue_id)
 
-            rx_proc = _run_gro_bin(cfg, "capacity", num_flows=num_flows)
+            rx_proc = run_gro_bin(cfg, "capacity", num_flows=num_flows)
             output = rx_proc.stdout
 
             if queue_id is not None:
diff --git a/tools/testing/selftests/drivers/net/gro_lib.py b/tools/testing/selftests/drivers/net/gro_lib.py
new file mode 100644
index 000000000000..4e3d704397fe
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/gro_lib.py
@@ -0,0 +1,194 @@
+# SPDX-License-Identifier: GPL-2.0
+
+"""Shared helpers for the GRO selftests."""
+
+import os
+
+from lib.py import ksft_pr
+from lib.py import KsftFailEx, KsftXfailEx
+from lib.py import bkg, cmd, defer, ethtool, ip
+
+
+# gro.c exits with this code when it detects over-coalescing
+EXIT_OVER_COALESCE = 42
+
+
+def resolve_dmac(cfg, ipver):
+    """
+    Finds the destination MAC address remote host should use to send packets
+    towards the local host. It may be a router / gateway address.
+    """
+
+    attr = "dmac" + ipver
+    # Cache the response across test cases
+    if hasattr(cfg, attr):
+        return getattr(cfg, attr)
+
+    route = ip(f"-{ipver} route get {cfg.addr_v[ipver]}",
+               json=True, host=cfg.remote)[0]
+    gw = route.get("gateway")
+    # Local L2 segment, address directly
+    if not gw:
+        setattr(cfg, attr, cfg.dev['address'])
+        return getattr(cfg, attr)
+
+    # ping to make sure neighbor is resolved,
+    # bind to an interface, for v6 the GW is likely link local
+    cmd(f"ping -c1 -W0 -I{cfg.remote_ifname} {gw}", host=cfg.remote)
+
+    neigh = ip(f"neigh get {gw} dev {cfg.remote_ifname}",
+               json=True, host=cfg.remote)[0]
+    setattr(cfg, attr, neigh['lladdr'])
+    return getattr(cfg, attr)
+
+
+def write_defer_restore(cfg, path, val, defer_undo=False):
+    """Writes val to a sysfs file, optionally restoring it on test exit."""
+    with open(path, "r", encoding="utf-8") as fp:
+        orig_val = fp.read().strip()
+        if str(val) == orig_val:
+            return
+    with open(path, "w", encoding="utf-8") as fp:
+        fp.write(val)
+    if defer_undo:
+        defer(write_defer_restore, cfg, path, orig_val)
+
+
+def set_mtu_restore(dev, mtu, host):
+    """Raises a device's MTU to at least mtu, restoring it on test exit."""
+    if dev['mtu'] < mtu:
+        ip(f"link set dev {dev['ifname']} mtu {mtu}", host=host)
+        defer(ip, f"link set dev {dev['ifname']} mtu {dev['mtu']}", host=host)
+
+
+def set_ethtool_feat(dev, current, feats, host=None):
+    """Sets ethtool features, restoring them on test exit.
+
+    current is the feature state as reported by "ethtool -k", xfail if a
+    feature which needs changing is fixed.
+    """
+    s2n = {True: "on", False: "off"}
+
+    new = ["-K", dev]
+    old = ["-K", dev]
+    no_change = True
+    for name, state in feats.items():
+        new += [name, s2n[state]]
+        old += [name, s2n[current[name]["active"]]]
+
+        if current[name]["active"] != state:
+            no_change = False
+            if current[name]["fixed"]:
+                raise KsftXfailEx(f"Device does not support {name}")
+    if no_change:
+        return
+
+    eth_cmd = ethtool(" ".join(new), host=host)
+    defer(ethtool, " ".join(old), host=host)
+
+    # If ethtool printed something kernel must have modified some features
+    if eth_cmd.stdout:
+        ksft_pr(eth_cmd)
+
+
+def setup_hw_gro(cfg):
+    """Turns on HW GRO and make sure SW GRO stays out of the way.
+
+    Expects cfg.feat to hold the local device's "ethtool -k" state.
+    """
+    set_ethtool_feat(cfg.ifname, cfg.feat,
+                     {"generic-receive-offload": False,
+                      "rx-gro-hw": True,
+                      "large-receive-offload": False})
+
+    # Some NICs treat HW GRO as a GRO sub-feature so disabling GRO
+    # will also clear HW GRO. Use a hack of installing XDP generic
+    # to skip SW GRO, even when enabled.
+    feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
+    if not feat["rx-gro-hw"]["active"]:
+        ksft_pr("Driver clears HW GRO and SW GRO is cleared, using generic XDP workaround")
+        prog = cfg.net_lib_dir / "xdp_dummy.bpf.o"
+        ip(f"link set dev {cfg.ifname} xdpgeneric obj {prog} sec xdp")
+        defer(ip, f"link set dev {cfg.ifname} xdpgeneric off")
+
+        # Attaching XDP may change features, fetch the latest state
+        feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
+
+        set_ethtool_feat(cfg.ifname, feat,
+                         {"generic-receive-offload": True,
+                          "rx-gro-hw": True,
+                          "large-receive-offload": False})
+
+
+# pylint: disable=too-many-arguments,too-many-positional-arguments
+def run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
+                order_check=False, verbose=False, fail=False):
+    """Runs gro binary with given test and return the process result."""
+    if not hasattr(cfg, "bin_remote"):
+        cfg.bin_local = cfg.net_lib_dir / "gro"
+        cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
+
+    if protocol is None:
+        ipver = cfg.addr_ipver
+        protocol = f"ipv{ipver}"
+    else:
+        ipver = "6" if protocol[-1] == "6" else "4"
+
+    dmac = resolve_dmac(cfg, ipver)
+
+    base_args = [
+        f"--{protocol}",
+        f"--dmac {dmac}",
+        f"--smac {cfg.remote_dev['address']}",
+        f"--daddr {cfg.addr_v[ipver]}",
+        f"--saddr {cfg.remote_addr_v[ipver]}",
+        f"--test {test_name}",
+    ]
+    if num_flows:
+        base_args.append(f"--num-flows {num_flows}")
+    if order_check:
+        base_args.append("--order-check")
+    if verbose:
+        base_args.append("--verbose")
+
+    args = " ".join(base_args)
+
+    rx_cmd = f"{cfg.bin_local} {args} --rx --iface {cfg.ifname}"
+    tx_cmd = f"{cfg.bin_remote} {args} --iface {cfg.remote_ifname}"
+
+    with bkg(rx_cmd, ksft_ready=True, exit_wait=True, fail=fail) as rx_proc:
+        cmd(tx_cmd, host=cfg.remote)
+
+    return rx_proc
+
+
+def run_with_retries(cfg, test_name, protocol=None, **kwargs):
+    """Runs a single gro test case, retrying to deflake it.
+
+    Each test is run 6 times, because given the receive timing, not all
+    packets that should coalesce will be considered in the same flow on
+    every try.  Over-coalescing is a hard failure, retries can only
+    cause false negatives there.
+    """
+    max_retries = 6
+    for attempt in range(max_retries):
+        fail_now = attempt >= max_retries - 1
+        rx_proc = run_gro_bin(cfg, test_name, protocol=protocol,
+                              fail=fail_now, **kwargs)
+
+        if rx_proc.ret == 0:
+            return
+
+        ksft_pr(rx_proc)
+
+        # ret==42 means the receiver detected over-coalescing.
+        # This is unambiguous proof of a bug, retries can only cause
+        # false negatives.
+        if rx_proc.ret == EXIT_OVER_COALESCE:
+            raise KsftFailEx(f"GRO over-coalesced in {protocol}/{test_name}")
+
+        if test_name.startswith("large_") and os.environ.get("KSFT_MACHINE_SLOW"):
+            ksft_pr(f"Ignoring {protocol}/{test_name} failure due to slow environment")
+            return
+
+        ksft_pr(f"Attempt {attempt + 1}/{max_retries} failed, retrying...")
-- 
2.44.0

