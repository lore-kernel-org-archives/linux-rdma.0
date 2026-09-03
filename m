Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010040.outbound.protection.outlook.com [40.93.198.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309E36F42B;
	Thu,  3 Sep 2026 08:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425763; cv=fail; b=F8thIB2NQsckmQMiuHcq3dfiU8/tbV8YD7eHyCQLtMcDqToH5ztLj46vMu9pmWNvYxQm7YlYecIfO7czs3mazv3u9bqlNZsjQBoq27C8AsvFfvdZR1n3xdTg7GnsyxSF68/zXlJQzjLewcy86lC7ORdgUe6adkgFgTjOlPjMtIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425763; c=relaxed/simple;
	bh=Q3S1v1EruHJl4Rjg7j4ew9eHvQlsHaBr8vrgzHnxqHs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qMF+pKdczTeQrVVcvKlXe5dDikC+XB3M3ffeudXlA68kt0LR4MuBciu6Vkcl5qDDislXgPgr+WZlPFRQlQS+3bb/XzznRc34X32Np1e2jaka4QrGHXRsEMfcSWN9bt37chAWXtvzLWbj7oPC3BPaR1Q3gnVTZ2/UPTg9d+RKNiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QwpDJQfX; arc=fail smtp.client-ip=40.93.198.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QwpDJQfX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3OD0SWi/eAJcWbn9cSoACaWZJ7UivodM7aR+QUjSHr6/wnLMAr7eSNr+Mf3TWTs7ppPGyi/jgjmp5+P9LsIACuA8xu0NflgMycTxWoU27GbyarEj7vi5ys5aAJGTc72sNJXzY5iNgxUUWzH2Yy1wfhp5+9I3jzkwCS57d4k+6GgNZlEdLILF+LkBuEB9SjVZNjYk539T8w4VLxhxDvyJBm9aD7cP0bux41YsqAly4lvBaDwNuHCj2kRJXF5t0uzpd2UarBefN1FFlgmPh0/tDd4H21Ph8v9gitfnds2RN38iA/fMJu3ascSXKb+7YDySceYvP+nfVXeyBkrgTOA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smH31k4Q2SQbCuYoPleClwmEVz5oOAYjaWZayr/C61c=;
 b=iG4kjPtblzIyvbZk/yrIlv6nlWsxEMOuO4B5DHD2jCOCXBX2ys8f2n2DSRXRjEQW7INTSIOuaIQ2g+OocjRmC0pqVPQRC9V5Y1OffC1DRv8MAPd9j8c2LbMHFLGi9Ajr0wPXYq4U+J4HZ5Xy2Z3qzn275hewEJf2gdanxARr0OOHU3RyYWrVOL6Cv78Z0ndwAAqgrMRnZ3aihDfPwwO2nL9UcEfslqsMnRAg6pnyi9MNupYbuwJeFaqSRV82jbmCiwbcBkkPvgultplkmhfdbvWOaQvZipEvh28to5Xus1zKPkQ6GU5WSfTUFgHhh2I116vRgWYA5ncQywoOajz8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smH31k4Q2SQbCuYoPleClwmEVz5oOAYjaWZayr/C61c=;
 b=QwpDJQfXiv1bIGifCTcUbsuuw02TlFQ0s5UrpI0prIUT9vW7k/nq+OY6p1t0Gi3iy4chJ1lopztD4oHE6GBs9lAJuP7y0qjwa42fHN9n4W9O2+K7jr0WbcnpsT7/ItUIwwar6xL+NHBrDkquWr+N7HTOnJXMRGTJvGxWjYBsPkWZfxArCXgxGP6uhUzkkle50kfQ2agPadxxsULRr+vUW+z0oh6lTTOxMulpH6IzvMPxAFTpk/FPX+haRMqSF1/DZWT0YDGBtIrjaQkOXdxNorkG5rlRMtc5DhSxb4LIP5OytBZKHXDbDqPclRsmFBpxbEMMA7hMcpKIx+hjLQnk3g==
Received: from BN9PR03CA0423.namprd03.prod.outlook.com (2603:10b6:408:113::8)
 by DS7PR12MB6358.namprd12.prod.outlook.com (2603:10b6:8:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:55:49 +0000
Received: from BN2PEPF0000A801.namprd02.prod.outlook.com
 (2603:10b6:408:113:cafe::60) by BN9PR03CA0423.outlook.office365.com
 (2603:10b6:408:113::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:55:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A801.mail.protection.outlook.com (10.167.245.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:55:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:25 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:55:12 -0700
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
Subject: [PATCH net-next V3 12/15] selftests: drv-net: psp: Extract shared helpers into psp_lib.py
Date: Thu, 3 Sep 2026 11:52:12 +0300
Message-ID: <20260903085215.3691657-13-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A801:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a747ca-9cac-4b38-8930-08df09992687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|23010399003|82310400026|10067099003|5023799004|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2X6zKRQCU0Y85M5j+pkbAZSNGeG7RoP0efDs61u18Uoj78y7NqbnJP/j2yH3ZQVoi9o/pAoLwOtrBiAkX5oImPVJ33cYmXc5bDOtw7k+TVj4eJrYBmROSwEqx6hwWyfDnPZ9L77enPZQfbTrQbxQmP3GHyB1jV46LfsRbv4ePDz/SNkAWoO0ASL9AVJkvnXQQaCPFW4EoeK1c/K3kLT//FdISunCambPJwoEXMAiwCmrZTfwyZER84QX6jblA1DgNGRKDX5A4+aI+OMlOrrR02dz5vgr4FVGmqYrKCTJk5ndsFPDKW8NxtsjToWUQoif929cM59sVmAY1GJzffELwC0rMeQ5Os9vbGq0R3DCHTCvROPShXOn8DFZoOrBJA9pFSc63szeUCZH4AiW+8hkHUEre/IxEh9IEcZ2LOcjugZcHZJLX/A+XtUU7KrNLYXgcobAjs3YLuYex7QZwYRqEiU7dlC5dMoVN2LbWQ6R4C+jB3thFoWFnuyhT9Z8o8QkPwes/sLzt0CniFrqWuR2IZUezzyBE9QVl18IszM+kkOsQlTl14aMCgIsc4ncOrcUj0h4N71P4Vyiq9UMv54JI8Kswj1bQcmugwxJ0Kedb6MbZT8laBOFcDhDHCbNvQ9n2HDDgiDCfq9o7WXngz6PbZMnoM+AzSaSwGtT7staR+ibUa74yuEgpYR17rRTg3fbbNTTJqJSOq+8BxyMY961/Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(23010399003)(82310400026)(10067099003)(5023799004)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9ud8PC2rR9VXCjRY5Xztw2ezIU9i167n3dBFTk0d3REawTAHAqWUxb/XjEgOjCG2x51Z4SfSlqDQlGHs2fFlw4jBq7xaCg7Zl0VS+802/e+lndvTM5mkVjqTf1NboUwEgYooqmxI7jQFPzuxI3mL9oWJ90W+Xf9HScSLQYtjlmGTOfB+eTgSVIFTskeKO/r3q3MFh7fWc4J0cm8wolWT1VctPK1rGFM2yvEbbG/asUcfDeMR2H/fGcMOR6nCXV5LjthyofebXDlzNeNESylSxTcljDtgrRcRL/7ae9ujxW2janpGLhuHM8zMBrFAxQyChfskAflhXarZsNn3x8oDvIhqCO0uaR12LnC+7yVZRds5ZUlLIPmmkCEWocx7SX8W7D3sKceP2ta5GfgDIcRPSxg3UXpSFVDXo8Sd+xheYbbvp6PcQtqbxmi5VBgfo7fh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:55:48.9481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a747ca-9cac-4b38-8930-08df09992687
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A801.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358

From: Cosmin Ratiu <cratiu@nvidia.com>

Put init_psp_dev() and the logic for requiring a psp version into a
shared lib, since they will soon be used by a second test file.

No functional change for psp.py.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/drivers/net/Makefile  |  4 +
 tools/testing/selftests/drivers/net/psp.py    | 77 ++++++-------------
 .../testing/selftests/drivers/net/psp_lib.py  | 57 ++++++++++++++
 3 files changed, 85 insertions(+), 53 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/psp_lib.py

diff --git a/tools/testing/selftests/drivers/net/Makefile b/tools/testing/selftests/drivers/net/Makefile
index d5bf4cb638a8..d68f9ab8955d 100644
--- a/tools/testing/selftests/drivers/net/Makefile
+++ b/tools/testing/selftests/drivers/net/Makefile
@@ -27,6 +27,10 @@ TEST_PROGS := \
 	xdp.py \
 # end of TEST_PROGS
 
+TEST_FILES := \
+	psp_lib.py \
+# end of TEST_FILES
+
 # YNL files, must be before "include ..lib.mk"
 YNL_GEN_FILES := psp_responder
 TEST_GEN_FILES += $(YNL_GEN_FILES)
diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 315648a770d0..47983fb8c7c2 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -11,6 +11,8 @@ import struct
 import termios
 import time
 
+from psp_lib import init_psp_dev, require_version
+
 from lib.py import defer
 from lib.py import ksft_run, ksft_exit, ksft_pr
 from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
@@ -122,34 +124,13 @@ def _get_stat(cfg, key):
 # Test case boiler plate
 #
 
-def _init_psp_dev(cfg, use_psp_ifindex=False):
-    if not hasattr(cfg, 'psp_dev_id'):
-        # Figure out which local device we are testing against
-        # For NetDrvContEnv: use psp_ifindex instead of ifindex
-        target_ifindex = cfg.psp_ifindex if use_psp_ifindex else cfg.ifindex
-        for dev in cfg.pspnl.dev_get({}, dump=True):
-            if dev['ifindex'] == target_ifindex:
-                cfg.psp_info = dev
-                cfg.psp_dev_id = cfg.psp_info['id']
-                break
-        else:
-            raise KsftSkipEx("No PSP devices found")
-
-    # Enable PSP if necessary
-    cap = cfg.psp_info['psp-versions-cap']
-    ena = cfg.psp_info['psp-versions-ena']
-    if cap != ena:
-        cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})
-        defer(cfg.pspnl.dev_set, {'id': cfg.psp_dev_id,
-                                  'psp-versions-ena': ena })
-
 #
 # Test cases
 #
 
 def dev_list_devices(cfg):
     """ Dump all devices """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     devices = cfg.pspnl.dev_get({}, dump=True)
 
@@ -161,7 +142,7 @@ def dev_list_devices(cfg):
 
 def dev_get_device(cfg):
     """ Get the device we intend to use """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     dev = cfg.pspnl.dev_get({'id': cfg.psp_dev_id})
     ksft_eq(dev['id'], cfg.psp_dev_id)
@@ -180,7 +161,7 @@ def dev_get_device_bad(cfg):
 
 def dev_rotate(cfg):
     """ Test key rotation """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     prev_rotations = _get_stat(cfg, 'key-rotations')
 
@@ -195,7 +176,7 @@ def dev_rotate(cfg):
 
 def dev_rotate_spi(cfg):
     """ Test key rotation and SPI check """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     top_a = top_b = 0
     with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
@@ -217,7 +198,7 @@ def dev_rotate_spi(cfg):
 
 def assoc_basic(cfg):
     """ Test creating associations """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
         assoc = cfg.pspnl.rx_assoc({"version": 0,
@@ -237,7 +218,7 @@ def assoc_basic(cfg):
 
 def assoc_bad_dev(cfg):
     """ Test creating associations with bad device ID """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
         with ksft_raises(NlError) as cm:
@@ -249,7 +230,7 @@ def assoc_bad_dev(cfg):
 
 def assoc_sk_only_conn(cfg):
     """ Test creating associations based on socket """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with _make_clr_conn(cfg) as s:
         assoc = cfg.pspnl.rx_assoc({"version": 0,
@@ -263,7 +244,7 @@ def assoc_sk_only_conn(cfg):
 
 def assoc_sk_only_mismatch(cfg):
     """ Test creating associations based on socket (dev mismatch) """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with _make_clr_conn(cfg) as s:
         with ksft_raises(NlError) as cm:
@@ -278,7 +259,7 @@ def assoc_sk_only_mismatch(cfg):
 
 def assoc_sk_only_mismatch_tx(cfg):
     """ Test creating associations based on socket (dev mismatch) """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with _make_clr_conn(cfg) as s:
         with ksft_raises(NlError) as cm:
@@ -296,7 +277,7 @@ def assoc_sk_only_mismatch_tx(cfg):
 
 def assoc_sk_only_unconn(cfg):
     """ Test creating associations based on socket (unconnected, should fail) """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
         with ksft_raises(NlError) as cm:
@@ -309,7 +290,7 @@ def assoc_sk_only_unconn(cfg):
 
 def assoc_version_mismatch(cfg):
     """ Test creating associations where Rx and Tx PSP versions do not match """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     versions = list(cfg.psp_info['psp-versions-cap'])
     if len(versions) < 2:
@@ -335,7 +316,7 @@ def assoc_version_mismatch(cfg):
 
 def assoc_twice(cfg):
     """ Test reusing Tx assoc for two sockets """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     def rx_assoc_check(s):
         assoc = cfg.pspnl.rx_assoc({"version": 0,
@@ -369,19 +350,9 @@ def assoc_twice(cfg):
 
 def _data_basic_send(cfg, version, ipver):
     """ Test basic data send """
-    _init_psp_dev(cfg)
-
-    # Version 0 is required by spec, don't let it skip
-    if version:
-        name = cfg.pspnl.consts["version"].entries_by_val[version].name
-        if name not in cfg.psp_info['psp-versions-cap']:
-            with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
-                with ksft_raises(NlError) as cm:
-                    cfg.pspnl.rx_assoc({"version": version,
-                                        "dev-id": cfg.psp_dev_id,
-                                        "sock-fd": s.fileno()})
-                ksft_eq(cm.exception.nl_msg.error, -errno.EOPNOTSUPP)
-            raise KsftSkipEx("PSP version not supported", name)
+    init_psp_dev(cfg)
+
+    require_version(cfg, version)
 
     s = _make_psp_conn(cfg, version, ipver)
 
@@ -418,7 +389,7 @@ def __bad_xfer_do(cfg, s, tx, version='hdr0-aes-gcm-128'):
 
 def data_send_bad_key(cfg):
     """ Test send data with bad key """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     s = _make_psp_conn(cfg)
 
@@ -433,7 +404,7 @@ def data_send_bad_key(cfg):
 
 def data_send_disconnect(cfg):
     """ Test socket close after sending data """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     with _make_psp_conn(cfg) as s:
         assoc = cfg.pspnl.rx_assoc({"version": 0,
@@ -451,7 +422,7 @@ def data_send_disconnect(cfg):
 
 
 def _data_mss_adjust(cfg, ipver):
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     # First figure out what the MSS would be without any adjustments
     s = _make_clr_conn(cfg, ipver)
@@ -491,7 +462,7 @@ def _data_mss_adjust(cfg, ipver):
 
 def data_stale_key(cfg):
     """ Test send on a double-rotated key """
-    _init_psp_dev(cfg)
+    init_psp_dev(cfg)
 
     prev_stale = _get_stat(cfg, 'stale-events')
     s = _make_psp_conn(cfg)
@@ -766,7 +737,7 @@ def _psp_dev_get_check_netkit_psp_assoc(cfg):
 
 def _dev_assoc_no_nsid(cfg):
     """ Test dev-assoc and dev-disassoc without nsid attribute """
-    _init_psp_dev(cfg, True)
+    init_psp_dev(cfg, True)
 
     # Associate without nsid - should look up ifindex in caller's netns
     cfg.pspnl.dev_assoc({'id': cfg.psp_dev_id,
@@ -800,7 +771,7 @@ def _psp_dev_assoc_cleanup_on_netkit_del(cfg):
     Creates a disposable netkit pair for this test to avoid destroying
     the shared environment.
     """
-    _init_psp_dev(cfg, True)
+    init_psp_dev(cfg, True)
     defer(delattr, cfg, 'psp_dev_id')
     defer(delattr, cfg, 'psp_info')
 
@@ -877,7 +848,7 @@ def _try_disassoc(cfg, psp_dev_id, ifindex, nsid=None):
 
 def _assoc_nk_guest(cfg):
     """Associate nk_guest with PSP device and register cleanup via defer()."""
-    _init_psp_dev(cfg, True)
+    init_psp_dev(cfg, True)
 
     cfg.pspnl.dev_assoc({'id': cfg.psp_dev_id,
                          'ifindex': cfg.nk_guest_ifindex,
diff --git a/tools/testing/selftests/drivers/net/psp_lib.py b/tools/testing/selftests/drivers/net/psp_lib.py
new file mode 100644
index 000000000000..d450db81cfc2
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/psp_lib.py
@@ -0,0 +1,57 @@
+# SPDX-License-Identifier: GPL-2.0
+
+"""Shared helpers for the PSP selftests."""
+
+import errno
+import socket
+
+from lib.py import defer
+from lib.py import ksft_eq, ksft_raises
+from lib.py import KsftSkipEx
+from lib.py import NlError
+
+
+def require_version(cfg, version):
+    """Skip unless the device supports a PSP version.
+
+    Version 0 is required by the spec, so it never skips.  Before
+    skipping, check that the kernel rejects the unsupported version
+    properly - this is the only coverage that path gets.
+    """
+    if not version:
+        return
+
+    name = cfg.pspnl.consts["version"].entries_by_val[version].name
+    if name in cfg.psp_info['psp-versions-cap']:
+        return
+
+    with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as s:
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.rx_assoc({"version": version,
+                                "dev-id": cfg.psp_dev_id,
+                                "sock-fd": s.fileno()})
+        ksft_eq(cm.exception.nl_msg.error, -errno.EOPNOTSUPP)
+    raise KsftSkipEx("PSP version not supported", name)
+
+
+def init_psp_dev(cfg, use_psp_ifindex=False):
+    """Find the PSP device under test and enable all supported versions."""
+    if not hasattr(cfg, 'psp_dev_id'):
+        # Figure out which local device we are testing against
+        # For NetDrvContEnv: use psp_ifindex instead of ifindex
+        target_ifindex = cfg.psp_ifindex if use_psp_ifindex else cfg.ifindex
+        for dev in cfg.pspnl.dev_get({}, dump=True):
+            if dev['ifindex'] == target_ifindex:
+                cfg.psp_info = dev
+                cfg.psp_dev_id = cfg.psp_info['id']
+                break
+        else:
+            raise KsftSkipEx("No PSP devices found")
+
+    # Enable PSP if necessary
+    cap = cfg.psp_info['psp-versions-cap']
+    ena = cfg.psp_info['psp-versions-ena']
+    if cap != ena:
+        cfg.pspnl.dev_set({'id': cfg.psp_dev_id, 'psp-versions-ena': cap})
+        defer(cfg.pspnl.dev_set, {'id': cfg.psp_dev_id,
+                                  'psp-versions-ena': ena})
-- 
2.44.0

