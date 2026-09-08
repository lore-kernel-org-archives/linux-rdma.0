Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0843A0B3B;
	Tue,  8 Sep 2026 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850537; cv=fail; b=bm8q/6RwzflOlsTmo/bgjkbL8458XcwGLduRHUvsVzarpQOMrsolRRkgddsvtfFEy5XLgzx7aVE0iB0VRbAVlGaOT+A0YXHAp96Avye2+xhVcv5xAib40FaZfkjsau6qgOq9WHSlK4QkBxzIcOlic5c7zUaifwLvrDR/uRhOehA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850537; c=relaxed/simple;
	bh=iF96JdLWujOkuBsKtX/ea7pKnCZf08RRzTn1wqij5ww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rywVIPlMN58GWmk9SxJrTip6/LM3ioOKgdTtAzsMFY8dVe152tLOJIsxBIjU/ImmqK65i2GWQkUpzitsYtlm2FURtlp8Z9iApGXHvon49v4S9Cl2xG7Aa9c/sBNBbBdwklt4KELxlDBg9lv/TztNPzZWhQ4V6RNsL+z4t/nDySU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YAExET/j; arc=fail smtp.client-ip=52.101.46.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YAExET/j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMXdr9zhYS8FOAM9AT1vu0nrEFKmTXYnbjd7BJqamrheZR+jSOSp+X4wjIxSDfKboawXP8m1poakNm6jk2ak6z+dyx9Q4Oo2lc6eCqSWgEXyGxoOC5z2bIJ/aHkIkq1Kg9nekpCYTS2zxnkT/4PTmPZswUZVBOoC7QsJuLMdGjbJJhnnO3TvQCCPNIl1m9psqBF4RBj3IHaW/XM/IEaBwgwPbmCAYYD1iC1cBMB8rvNSnarEkKsDYFnr10S8K1+qFfUxvoAf5Bnv4XyJ29IUgo+ZEyNyUwJ0LgDR97ulZv4ffq+6XW8i4GB3h/Aodyu9y57dhD4aD3sAWOeEdsYQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnzSzms0oM+0R0eSPIXHaC3vuWCVPAeDHMnoKRlM7H4=;
 b=e80M/GuaCT5tkkqeMyNHzxvj2QaJiZ/YaXB0505XPP/do0HUbpMOFvw8xg51J2lMFbqdcoAAJRKr6qv+MgdYuR1kur0IAOtCU/IhUuoQl2XUE4+Ivc22HAW3WPMR1HvTrQS8mRld9qOvjFjkc/ra5pUllKiGIDvucaHY9JKl5Dv01sDkJWAHxDKpr4OVSDX9RcWpttXOBj01fNKrZdjDNt5ZJQcRWHtIL9vXgK6NsKSk63Ukwkt0bq3Lv697YrbzSakKO3BN0MMSJXV+HisbwO0u0+kZf70Jh+hTHiO7Z62w29u/QwYlfhy0lWelRHOQBILvi8ssNS0HDDcPSalLIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnzSzms0oM+0R0eSPIXHaC3vuWCVPAeDHMnoKRlM7H4=;
 b=YAExET/j8+J3nE+SgAnxQuHW1RXJBTZyT5xdSurnFXB6HKIwNyt3NylhjZfep6RGZW5XY7ln7XWurv9luXTkkA9g727/FRkaU4HZx3nVxNgqkJ9Ps4kB5ssrfIBE2Pfh1CcrxXGkKWt4+9WI7jzIyW4Q0qik9Kp7gO6TV4dmdN4wZFMyyUDfVVIubVQDMVpCtwLs2mh1+Fbjx9JMmJpNtPylHWjWCMnhtrtAoWOd+QTKyexaiEy8AuJUUf1IlPVBSCF27z7alxZGVaBx1X7mePjQxmDU6gXvAlMb6ZaD3VCtI03Y9aUFDVpcPlYp0huSClFXqCcoCcOJtUxMKt/RKA==
Received: from BN8PR04CA0050.namprd04.prod.outlook.com (2603:10b6:408:d4::24)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.13; Tue, 8 Sep
 2026 06:55:28 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:408:d4:cafe::13) by BN8PR04CA0050.outlook.office365.com
 (2603:10b6:408:d4::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:55:27 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:55:12 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:55:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:55:04 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Willem de Bruijn
	<willemb@google.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO conformance tests
Date: Tue, 8 Sep 2026 09:52:44 +0300
Message-ID: <20260908065244.3799142-15-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260908065244.3799142-1-tariqt@nvidia.com>
References: <20260908065244.3799142-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: a274e3ec-20a0-41d8-205d-08df0d762a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|7416014|10067099003|56012099006|11063799006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b5+dydtyB4a5eCgW5XmMqpuL1Z+x4XP2vyCLRh3AjwoATpU8VDZiX7bOlonmEu4jJV4DMSPmcK4jGzKd2KF/RRdFdokvlssSdurCkC6aTo4Jli0+Jx3Y9PutZFuOls1C34LA5W3u/x9P1AsFTMnZHNejwc7XENKh58sqgzGsaBdfYrbJvuvFieWtn9OZwy9ZZK+04QldmLeDe+WiYz+sFTt21Dv9NrZvD4Up3lNaKi39VDQxJrajCu7cKi07+olL5LqC9Old+DAEEeICZcIhOiAt1rq3ykw2x1tsaggdTJssnZY9QZJor98ggaiOvfSHkjx0TWgd5thF1fucGAgynodYpK4F3WOHq7QGudNVJYNK7KMO/mfC06mJ2+YL6t8QGav14MuVgL5df4jfKdVRxXR+/9RIrrvCqnwAaZh/XyJgQjmtHpeOIcj6fPcV4v1rdsNZsQ/ODQok+5O8JwEa+oagg8o3SCl4BU9Ks8aGxneGviQaegX7728RiXn4bbIchLWWKI3ceAF9vWYQdT448xSHjIoi/OwIcr9BE1g/JQ4MlCwuVUcxqUaZqw15LKjUkU2ltcnLGEq8SKF2/DTuQwISmWcoHJJWLJtkwVZ7LtFRFNhZwOttm8C6gycBdccjTGnlkRY+ooceBIkqtGtGUfFvl/j2bjdFkB7TuWgG2CNKzMz3KQ00AyTAaosnLsGXdfbbK2mCk0XFuzC/adNBhw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FmmC4YM5QNRO+RYrcjjE2xkB3LPM5EmGuOkRroougjgRp+f6LLOOTxTv+BeJYJXnMTtN6TqASru3jnHlp2jXTS0ZAK2/OzzU5pqYe3u0PF/IRR/Bydj19G5XDAG97NRjbUKeEnTeQFbECEY1AB1VZFxNIJipHIDo+5GWIUysu9wDNIBbXADglxs8rJFoxEr0ckUZYj2yInDElTHdOYobWnsLOLhAjsq84xFKVYk8dP8NTxUX2y2e/VxVxf5BvDqlmA6F+iPkevPD4Y9IaTZ3iENyNlzbWRuueGq025tmZ4lhtbaAwrwuaFqnrAP1hTxRShO7luR1jwKecH1hLlvMpBgNj3DQFQzVLDztCzMdayJ7Jkiacw7KXKvbh86yeYRGBg1JFYznngPOgPOjN66xWXeQiyv6k5VRcD9BcdYtHgyE/kE1HPaUHFm8SPy0vQJI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:55:27.7459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a274e3ec-20a0-41d8-205d-08df0d762a72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607

From: Cosmin Ratiu <cratiu@nvidia.com>

Add PSP conformance tests using the same gro helper binary as other gro
tests , but in --psp mode. SPIs are procured by psp_gro.py from a real
PSP device and handed off to the gro sender & receiver. The sender
crafts and encrypts packets in software, the receiver relies fully on
the HW to decrypt, decapsulate and do HW GRO.

Because the NIC decrypts and decapsulates before the frames reach the
receiver AF_PACKET tap, the gro receiver sees the plain frames and the
assertions remain exactly the same as other gro tests.

So these tests verify, at length, that the device does PSP HW-GRO the
same way as plain TCP.

Additional PSP-specific tests are defined to check that GRO doesn't
merge packets across PSP versions, SPIs, encryption-status, etc.

Some gro tests are not included because they don't work:
- ip_csum: the checksum is recomputed by psp_dev_rcv().
- tcp_csum: packets are marked with CHECKSUM_UNNECESSARY.
- ip_frag4/ip_frag6: PSP is incompatible with IP fragmentation.
- IPv6 extension header tests: PSP doesn't deal with IPv6 ext headers.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../testing/selftests/drivers/net/gro_lib.py  |  15 +-
 .../testing/selftests/drivers/net/hw/Makefile |  17 ++
 tools/testing/selftests/drivers/net/hw/config |   1 +
 .../selftests/drivers/net/hw/psp_gro.py       | 157 ++++++++++++++++++
 4 files changed, 186 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/hw/psp_gro.py

diff --git a/tools/testing/selftests/drivers/net/gro_lib.py b/tools/testing/selftests/drivers/net/gro_lib.py
index 45ded8477a50..8edae7d736a9 100644
--- a/tools/testing/selftests/drivers/net/gro_lib.py
+++ b/tools/testing/selftests/drivers/net/gro_lib.py
@@ -189,7 +189,8 @@ def _setup_queue_count(cfg, num_queues):
 
 
 def _run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
-                 order_check=False, verbose=False, fail=False):
+                 order_check=False, verbose=False, fail=False,
+                 common_args=None):
     """Run gro binary with given test and return the process result."""
     if not hasattr(cfg, "bin_remote"):
         cfg.bin_local = cfg.net_lib_dir / "gro"
@@ -217,6 +218,8 @@ def _run_gro_bin(cfg, test_name, protocol=None, num_flows=None,
         base_args.append("--order-check")
     if verbose:
         base_args.append("--verbose")
+    if common_args:
+        base_args += common_args
 
     args = " ".join(base_args)
 
@@ -341,8 +344,11 @@ def _gro_variants():
                 yield protocol, test_name
 
 
-def run_test(cfg, mode, protocol, test_name):
-    """Run a single GRO test with retries."""
+def run_test(cfg, mode, protocol, test_name, common_args=None):
+    """Run a single GRO test with retries.
+
+    common_args are extra arguments passed to both gro sender and receiver.
+    """
 
     ipver = "6" if protocol[-1] == "6" else "4"
     cfg.require_ipver(ipver)
@@ -356,7 +362,8 @@ def run_test(cfg, mode, protocol, test_name):
     for attempt in range(max_retries):
         fail_now = attempt >= max_retries - 1
         rx_proc = _run_gro_bin(cfg, test_name, protocol=protocol,
-                               verbose=True, fail=fail_now)
+                               verbose=True, fail=fail_now,
+                               common_args=common_args)
 
         if rx_proc.ret == 0:
             return
diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
index 6105be8e590f..daa7e52f236e 100644
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
diff --git a/tools/testing/selftests/drivers/net/hw/config b/tools/testing/selftests/drivers/net/hw/config
index d89a9ba17655..060ed1423bf3 100644
--- a/tools/testing/selftests/drivers/net/hw/config
+++ b/tools/testing/selftests/drivers/net/hw/config
@@ -8,6 +8,7 @@ CONFIG_INET6_ESP=y
 CONFIG_INET6_ESP_OFFLOAD=y
 CONFIG_INET_ESP=y
 CONFIG_INET_ESP_OFFLOAD=y
+CONFIG_INET_PSP=y
 CONFIG_IO_URING=y
 CONFIG_IPV6=y
 CONFIG_IPV6_GRE=y
diff --git a/tools/testing/selftests/drivers/net/hw/psp_gro.py b/tools/testing/selftests/drivers/net/hw/psp_gro.py
new file mode 100755
index 000000000000..3a069c944ae1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/hw/psp_gro.py
@@ -0,0 +1,157 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+"""
+PSP HW GRO conformance tests.
+
+This reuses the gro binary in --psp mode:
+The sender crafts encapsulated & SW-encrypted PSP packets with receiver's PSP
+rx-assoc, and the receiver's device decrypts and decapsulates the packets
+before an AF_PACKET tap gets to analyze them.
+
+All GRO conformance tests which could run with PSP are included.
+"""
+
+import socket
+
+from lib.py import ksft_run, ksft_exit
+from lib.py import ksft_variants, KsftNamedVariant
+from lib.py import KsftSkipEx
+from lib.py import NetDrvEpEnv, PSPFamily
+from lib.py import defer
+
+# The helpers live next to their other users, gro_*.py and psp.py. Importing
+# lib.py above puts the selftests root on sys.path, which is what makes these
+# two resolve, so they have to stay after it - pylint wants the opposite.
+# pylint: disable=wrong-import-order,import-error
+from drivers.net.gro_lib import run_test
+from drivers.net.psp_lib import init_psp_dev, require_version
+# pylint: enable=wrong-import-order,import-error
+
+
+# Tests for both IP versions, a subset of gro tests. Missing:
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
+# Tests specific to IPv4, a subset of gro tests. Missing:
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
+def _setup(cfg, version):
+    """Enables PSP on the device under test."""
+    init_psp_dev(cfg)
+    require_version(cfg, version)
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
+    """Sets up, associates and runs one gro test case under PSP + HW GRO."""
+    _setup(cfg, max(versions))
+
+    run_test(cfg, "hw", protocol, test_name,
+             common_args=_psp_args(cfg, versions))
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
+    _setup(cfg, 0)
+
+    cap = cfg.psp_info['psp-versions-cap']
+    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': []})
+    cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})
+
+    run_test(cfg, "hw", protocol, "data_same",
+             common_args=_psp_args(cfg, [0]))
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

