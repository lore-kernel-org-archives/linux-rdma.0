Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B8D47A875;
	Thu,  3 Sep 2026 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425791; cv=fail; b=HDrSUcIphiVEX31GuhaCSWk2U2tLKGxPx63q9bRs3w3/+8fyZ3iV7mqV+OXWMsa1iAIzH3i4KtjZbAVCebN51rtvD1Nk9+px7V2pfpt+w8Fd4b/d4J4CHY+f8jv9FHuNAxs+69PfupdnFfUBDd3as41V3zGncfSEfxMRoSAc46c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425791; c=relaxed/simple;
	bh=Xs+PLI2MN9p/LcZhufrikGJSrfbC8l3WCT60KZgXFBM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZw5vGqrvhOnU9X+O0N6rOIJ32k7GOwEi9bhy6F5mZ4+AHASFEHybDqSW5Fgb+RAqG6hd6LBDVt6IblXAMowvCa8wEp+BNr/fAIGAkn3S8O/ptgXGkt2pgdx9KaIxMHkRiDJL32ZpYOp5HtvvkUa4FS2+yyzl1U5OJwMURfvzCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PabGUr41; arc=fail smtp.client-ip=40.93.196.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PabGUr41"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=US6xufsOwAZd0FSyXEYOFM+lb0ypFssFOiqCcWkgcg/YJAZYnduIFlnf7UWuB+IHRQVi3DkXhskzrf+NnAe/slJFTtT+gDUaggm5DE25Bb/AF0RmDvJSukJJHhxW6LK3H5dLoepdddyXwb4O2thcuqaAjqU+VwjCR8mVdundaRzC95ySRSY2dzMgLkyzygdpSQfsl0X08ovhFfhxik8aMl8LsLpZ7TrPYvZU1YPt4ICv/i1W5rB7C/ch0UGualp7Y68W1ZevgVnI/OoaVafW5rvne4Bff68PvYPAkdNpaGx19cojNjju7jnJ4V/MNBzMZ2a0a101AbhBRkNpXJ9KHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBFhyW9EStcu9NwduBwuDsJn/mvRuKxgEY5dK6ADfAo=;
 b=rWyynr7a6WoPYZTJqx1z2zyR/2ZssJrFN4Mii3bS+8zYg8q+ImZ3x0HRLb/IhQ03b/bIrdgvYzOpjn/PU8civm2MJr/dP74i4H/lYX9QL8xnd/MwAnuGZhmfkoIzAtKFW8m42tQ+fAY6X0BQ2GfMMWW6vW0SlIkV/SLFyoM0w8laPto0OryaRt4HJU2FOFrUWvoLdHSQKXJBtkjCN3YrbOXTtz37yGx1/p0nEDjLE1k44nzfAEfGGEb9YBFgUMcq+sFH1AZj2jpSG7FHOxAU4MTdt2AA1uSMXVZvo4Aidjbc1078s0c4q1T1RFJqYbWkpqHgLjXM/z6KBLxXxupJkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBFhyW9EStcu9NwduBwuDsJn/mvRuKxgEY5dK6ADfAo=;
 b=PabGUr41Jy5WVWKejjvN1VNWd47CEuMVi0LHk8MJ+Ur4uZNl6QhFMeJADUv47qAvpw3lPX7KM6W1GBMDvUdn6T/fUnCKOkLR5ABLmQTUD2U4ChiasSpR6PdNan21W5ZBkoumLcvhpIVAlvBR9DLU98WhtTbdOCG57MaYf9crn7YqaiZCcVOuJQaPdaSX6mcUFfFWcjq0hF7gfROa/xKQMeSXNsCDHjYDc8IYaL/89Cr0pPouwxOpCItfxPTG5a/IX2oI0HdpFYU1nwKmKJZMos4qk4Hu2foS5U53yWkByCi3ynSuxhlIeZIJG6ZEG8PZ+4OtkLY8+TWzJOXYZrIFmQ==
Received: from CH2PR10CA0027.namprd10.prod.outlook.com (2603:10b6:610:4c::37)
 by SAWPR12MB999291.namprd12.prod.outlook.com (2603:10b6:806:55f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:56:23 +0000
Received: from BN2PEPF0000A800.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::5e) by CH2PR10CA0027.outlook.office365.com
 (2603:10b6:610:4c::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A800.mail.protection.outlook.com (10.167.245.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:56:22 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:56:02 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:56:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:55:49 -0700
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
Subject: [PATCH net-next V3 15/15] selftests: drv-net: Add PSP HW GRO conformance tests
Date: Thu, 3 Sep 2026 11:52:15 +0300
Message-ID: <20260903085215.3691657-16-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A800:EE_|SAWPR12MB999291:EE_
X-MS-Office365-Filtering-Correlation-Id: f597ec9b-11de-4e81-77b2-08df09993acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|6133799003|10067099003|11063799006|56012099006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Lj7r6VgySRj0tsp7FH4pL6y7cY8DUAb9Wm+wWVtOvM8nUmrg1phoUzyAG6o9oiHl5hrsvJgYt8CMlzFhtZEmdFqDcX0GI6cCzJkxVrNz9Pa45J9hhzbFCe+XA9chTVq0bg54TB97HJHONqIdAW7p9uLQvPnXVyrMR2gmA5TjrgdLIT9ycGnk8gUD1b67Tv4yMLBQSTGIvTeuBrDJ4hw+7BzBRf9kE64sVCDh9z5re9Yoxrelk2lF7UJXQxicJqz2ksYpG5Ib4vDoCPKbHThVh34vVcFjU4pX7kTOCNeGSbcjs19+6hm2H1mF9r/XXM8Cp50xK5eEBLJZRw5sUn7DxsrjZsry9lIadAtDujOsTeDRzuHjPCkVybWehXG7QlAbSq3Y2SaYgOo1FchLhEMa6FSFTqDrmHDPXfTw1etkPjpcIYQKAZYECeMX7/trkTSCOIy1rEiLw3H1DHZotaXso7sULk3EgovA9m+v3/CUVriH8OyQxGs6/2cmtzxJJCFLfsg49sV/DrpGrx4IjJV+YCxgl6XwWvICVa1ttFlNA/KYdpfdflsVya4m/IVJtdSY/M67QipDKVeMhkqUlNCckCwHJ07ceKAMJCCoaBU77FSMBxoKIHoBvbcm35kCZ6DGAcmBIkkavPiTFGh3tyV/ZP8mfuf3GvJjWH0zyvHp18R0pNUAch+ZtHAVmxLWMejHmWBm6jtwsr2/l/eaytjEbA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H7FHFLtaLp8YFfg3oUBg5bszE+W+FaZMrUaPFzw26yTjXzWLTE+9c4coSHWrRb84V1bb6vwDf8JEHMAj3zA3TAojcPGhdDTRJwWb9NGPQcj3/ea/0LPy1p+okdYUnR45Jnj1dq76H/7Qi13QfwYbxSHQwimEmm/vfI2X/iDW+xpvq0s707bMU6PGaQEWR/+IpWL2YYL/UH148qrEFaPeFTWOr1xiw0jkLLC+tb2Lqjkr+KJSVNrX//8q1tIF73iT1YQZyUzze26Z6+VwYg4tXqy37fJsB2uCTbJef+f5Gc66NKL9UT0y1D/hpUp95lp2b0H/N4uBfkEscejqC0Pylq7CgdcLkOS5Pzy+q9UUsxSZnh10lvhl8nSB9YZw9EWBR2teD3GMYKxkWDYY6HK83n1BOGKJ1Yz1KusMnzCpgXpEwNf8k+cegKCGbH5LG6s5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:56:22.9471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f597ec9b-11de-4e81-77b2-08df09993acb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A800.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999291

From: Cosmin Ratiu <cratiu@nvidia.com>

Add PSP conformance tests using the same gro helper binary as gro.py
does, but in --psp mode. SPIs are procured by psp_gro.py from a real PSP
device and handed off to the gro sender & receiver. The sender crafts
and encrypts packets in software, the receiver relies fully on the HW to
decrypt, decapsulate and do HW GRO.

Because the NIC decrypts and decapsulates before the frames reach the
receiver AF_PACKET tap, it sees the plain frames and the assertions
remain exactly the same as gro.py.

So these tests verify, at length, that the device does PSP HW-GRO the
same way as plain TCP.

Additional PSP-specific tests are defined to check that GRO doesn't
merge packets across PSP versions, SPIs, encryption-status, etc.

Some tests from gro.py are not included because they don't work:
- ip_csum: the checksum is recomputed by psp_dev_rcv().
- tcp_csum: packets are marked with CHECKSUM_UNNECESSARY.
- ip_frag4/ip_frag6: PSP is incompatible with IP fragmentation.
- IPv6 extension header tests: PSP doesn't deal with IPv6 ext headers.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../testing/selftests/drivers/net/gro_lib.py  |  14 +-
 .../testing/selftests/drivers/net/hw/Makefile |  17 ++
 .../selftests/drivers/net/hw/psp_gro.py       | 172 ++++++++++++++++++
 3 files changed, 201 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/hw/psp_gro.py

diff --git a/tools/testing/selftests/drivers/net/gro_lib.py b/tools/testing/selftests/drivers/net/gro_lib.py
index 4e3d704397fe..519986028980 100644
--- a/tools/testing/selftests/drivers/net/gro_lib.py
+++ b/tools/testing/selftests/drivers/net/gro_lib.py
@@ -121,9 +121,14 @@ def setup_hw_gro(cfg):
 
 
 # pylint: disable=too-many-arguments,too-many-positional-arguments
+# pylint: disable=too-many-locals
 def run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
-                order_check=False, verbose=False, fail=False):
-    """Runs gro binary with given test and return the process result."""
+                order_check=False, verbose=False, fail=False,
+                common_args=None):
+    """Runs gro binary with given test and return the process result.
+
+    common_args is a list of extra arguments passed to both ends.
+    """
     if not hasattr(cfg, "bin_remote"):
         cfg.bin_local = cfg.net_lib_dir / "gro"
         cfg.bin_remote = cfg.remote.deploy(cfg.bin_local)
@@ -150,6 +155,8 @@ def run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
         base_args.append("--order-check")
     if verbose:
         base_args.append("--verbose")
+    if common_args:
+        base_args += common_args
 
     args = " ".join(base_args)
 
@@ -169,6 +176,9 @@ def run_with_retries(cfg, test_name, protocol=None, **kwargs):
     packets that should coalesce will be considered in the same flow on
     every try.  Over-coalescing is a hard failure, retries can only
     cause false negatives there.
+
+    Extra keyword arguments (num_flows, order_check, verbose,
+    common_args) are forwarded to run_gro_bin().
     """
     max_retries = 6
     for attempt in range(max_retries):
diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
index 78bb0169350b..0a7851846708 100644
--- a/tools/testing/selftests/drivers/net/hw/Makefile
+++ b/tools/testing/selftests/drivers/net/hw/Makefile
@@ -13,6 +13,20 @@ else
 $(warning excluding iouring tests, liburing not installed or too old)
 endif
 
+# psp_gro.py uses the gro binary in PSP mode, which requires OpenSSL.
+PKG_CONFIG ?= pkg-config
+HAVE_OPENSSL := $(shell echo 'int main(void) { return 0; }' | \
+		  $(CC) -x c - -include openssl/evp.h \
+		  $(shell $(PKG_CONFIG) --cflags --libs libcrypto 2>/dev/null \
+			  || echo -lcrypto) \
+		  -o /dev/null >/dev/null 2>&1 && echo 1)
+
+ifeq ($(HAVE_OPENSSL),1)
+COND_PROGS += psp_gro.py
+else
+$(warning excluding PSP GRO tests, libcrypto not installed)
+endif
+
 TEST_GEN_FILES := \
 	$(COND_GEN_FILES) \
 # end of TEST_GEN_FILES
@@ -40,6 +54,7 @@ TEST_PROGS = \
 	nk_qlease.py \
 	ntuple.py \
 	pp_alloc_fail.py \
+	$(COND_PROGS) \
 	rss_api.py \
 	rss_ctx.py \
 	rss_drv.py \
@@ -64,6 +79,8 @@ TEST_FILES := \
 
 TEST_INCLUDES := \
 	$(wildcard lib/py/*.py ../lib/py/*.py) \
+	../gro_lib.py \
+	../psp_lib.py \
 	../../../net/lib.sh \
 	../../../net/forwarding/ipip_lib.sh \
 	../../../net/forwarding/lib.sh \
diff --git a/tools/testing/selftests/drivers/net/hw/psp_gro.py b/tools/testing/selftests/drivers/net/hw/psp_gro.py
new file mode 100755
index 000000000000..9af80a022a17
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/psp_gro.py
@@ -0,0 +1,172 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+"""
+PSP conformance tests built on the GRO test binary.
+
+This reuses the gro binary in --psp mode:
+The sender crafts encapsulated & sw-encrypted PSP packets with the receiver PSP
+rx-assoc, and the receiver device decrypts and decapsulates the packets before
+an AF_PACKET tap gets to analyze them.
+
+All tests from gro.py which could run with PSP are included.
+"""
+
+import socket
+
+from lib.py import ksft_run, ksft_exit
+from lib.py import ksft_variants, KsftNamedVariant
+from lib.py import KsftSkipEx
+from lib.py import NetDrvEpEnv, PSPFamily
+from lib.py import defer, ethtool
+
+# The helpers live next to their other users, gro.py and psp.py. Importing
+# lib.py above puts the selftests root on sys.path, which is what makes these
+# two resolve, so they have to stay after it - pylint wants the opposite.
+# pylint: disable=wrong-import-order,import-error
+from drivers.net.gro_lib import run_with_retries, set_mtu_restore, setup_hw_gro
+from drivers.net.psp_lib import init_psp_dev, require_version
+# pylint: enable=wrong-import-order,import-error
+
+
+# Tests for both IP versions, a subset of gro.py. Missing:
+# - tcp_csum: PSP packets are validated by HW (with the ICV) and marked with
+# CHECKSUM_UNNECESSARY.
+_COMMON = ["data_same", "data_lrg_sml", "data_sml_lrg", "data_lrg_1byte",
+           "data_burst",
+           "ack",
+           "flags_psh", "flags_syn", "flags_rst", "flags_urg", "flags_cwr",
+           "tcp_seq", "tcp_ts", "tcp_opt",
+           "ip_ecn", "ip_tos",
+           "large_max", "large_rem",
+]
+
+# Tests specific to IPv4, a subset of gro.py. Missing:
+# - ip_csum: psp_dev_rcv() recomputes the IP checksum.
+# - ip_frag4: PSP is incompatible with IP fragmentation.
+_V4 = ["ip_ttl", "ip_opt",
+       "ip_id_df1_inc", "ip_id_df1_fixed",
+       "ip_id_df0_inc", "ip_id_df0_fixed",
+       "ip_id_df1_inc_fixed", "ip_id_df1_fixed_inc",
+]
+
+# No IPv6-only tests:
+# - ip_frag6: PSP doesn't support fragmentation
+# - ip_v6ext_same, ip_v6ext_diff: PSP doesn't support IPv6 ext headers.
+
+
+def _psp_variants():
+    for ver in range(4):
+        for proto in ["ipv4", "ipv6"]:
+            for test_name in _COMMON + (_V4 if proto == "ipv4" else []):
+                yield KsftNamedVariant(f"v{ver}_{proto}_{test_name}",
+                                       ver, proto, test_name)
+
+
+def _ip_variants():
+    """IPv4/IPv6."""
+    for proto in ("ipv4", "ipv6"):
+        yield KsftNamedVariant(proto, proto)
+
+
+def _psp_assoc(cfg, version=0):
+    # This socket receives no traffic, exists solely to own the rx assoc.
+    s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
+    defer(s.close)
+    return cfg.pspnl.rx_assoc({"version": version, "dev-id": cfg.psp_dev_id,
+                               "sock-fd": s.fileno()})['rx-key']
+
+
+def _setup(cfg, version, test_name):
+    """Enables PSP and HW GRO on the device under test."""
+    init_psp_dev(cfg)
+    require_version(cfg, version)
+
+    if not hasattr(cfg, "feat"):
+        cfg.feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
+
+    setup_hw_gro(cfg)
+
+    # "large_*" tests need at least 4k MTU
+    if test_name.startswith("large_"):
+        set_mtu_restore(cfg.dev, 4096, None)
+        set_mtu_restore(cfg.remote_dev, 4096, cfg.remote)
+
+
+def _psp_args(cfg, versions):
+    """Produces PSP associations as gro binary --psp-assoc arguments."""
+    keys = [_psp_assoc(cfg, ver) for ver in versions]
+    return [f"--psp-assoc {ver},{key['spi']:x},{key['key'].hex()}"
+            for ver, key in zip(versions, keys)]
+
+
+def _run(cfg, test_name, protocol, versions):
+    """Sets up, associates and runs one gro test case under PSP."""
+    ipver = protocol[-1]
+    cfg.require_ipver(ipver)
+
+    _setup(cfg, max(versions), test_name)
+
+    run_with_retries(cfg, test_name, protocol=protocol, verbose=True,
+                     common_args=_psp_args(cfg, versions))
+
+
+@ksft_variants(_psp_variants())
+def test_psp_gro(cfg, version, protocol, test_name):
+    """Runs one gro conformance case with PSP encapsulation."""
+    _run(cfg, test_name, protocol, [version])
+
+
+# PSP-specific GRO tests
+
+@ksft_variants(_ip_variants())
+def test_psp_spi_diff(cfg, protocol):
+    """Frames from two different SPIs must not coalesce."""
+    _run(cfg, "psp_spi_diff", protocol, [0, 0])
+
+
+@ksft_variants(_ip_variants())
+def test_psp_ver_diff(cfg, protocol):
+    """Frames from two different PSP versions must not coalesce."""
+    init_psp_dev(cfg)
+    if len(cfg.psp_info['psp-versions-cap']) < 2:
+        raise KsftSkipEx("Device supports a single PSP version")
+
+    _run(cfg, "psp_ver_diff", protocol, [0, 1])
+
+
+@ksft_variants(_ip_variants())
+def test_psp_mixed(cfg, protocol):
+    """A PSP frame must not coalesce with a clear text one."""
+    _run(cfg, "psp_mixed", protocol, [0])
+
+
+@ksft_variants(_ip_variants())
+def test_psp_after_reconfig(cfg, protocol):
+    """Verifies that decap still works after PSP off + on."""
+    cfg.require_ipver(protocol[-1])
+
+    _setup(cfg, 0, "data_same")
+
+    cap = cfg.psp_info['psp-versions-cap']
+    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': []})
+    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})
+
+    run_with_retries(cfg, "data_same", protocol=protocol, verbose=True,
+                     common_args=_psp_args(cfg, [0]))
+
+
+def main() -> None:
+    """ Ksft boiler plate main """
+
+    with NetDrvEpEnv(__file__, nsim_test=False) as cfg:
+        cfg.pspnl = PSPFamily()
+
+        ksft_run(cases=[test_psp_gro, test_psp_spi_diff, test_psp_ver_diff,
+                        test_psp_mixed, test_psp_after_reconfig],
+                 args=(cfg, ))
+    ksft_exit()
+
+
+if __name__ == "__main__":
+    main()
-- 
2.44.0

