Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F5F38DC64;
	Tue,  8 Sep 2026 06:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788850521; cv=fail; b=IgWzeVgqddn9cqOX0eJl9YfjPq61KSRvH8Jkv1hdPAf3JLFeVH42HbtsY7n9mfVLJ/3PrKpSiDDv79qOzj1INI8LY/qI1vOfmpr858obAhJ+uKGrH2kB72DVJlHFK0d0H5KtX6WqQhpIY1Xp6Pq5ss1ENbREbYbemhBUMRw1ha0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788850521; c=relaxed/simple;
	bh=//XTi84jj8Qk/LFagutunU7kh5JOdVQ+pKUMU5hBUGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6rHPS63yPrt2wVQLN8wQhu3cdWHtuRHOPj0DAdM8Z2O65AeoPePQap0P65dnmPhbjxKeIOnVvh1yhonJ7Y5PjhezyF6mKHs3Sjt6idwQoDKn4rT43zx68LERRqz4aM1oayRUqBDSxK3qqeH4Xv72bRO3ECSB5DJZ2vlnN7iSQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RyqO0WXk; arc=fail smtp.client-ip=40.107.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RyqO0WXk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PhC0MYGE/I87gIFgjsV9UtPk1JzmoVGf2BOMwOI5XJnKQVaFOaod/QUPVGyBbfOKik+gL4kCUujUGryWO9Kx5WVFooPEL1GYbqOA8S3YduE4RG69l8o35wqpuRhfW/mWJG075ZwXyGZ9jFXieRE5bWgi0E05hZQ//xTFH/ttwaoLBd90JvjUa6mETaaEvq3lDfu02WHS2UDYbFffyqTiHUAfsjmvflNoV5XbBVjP3JygOF0kBmJdpWDPyPukHb6/JkGhEXGoGTWF62TP/c25KikxZ+m/EBvL3zIHJkeG00LP6eQKyc1OA78MKiWBCZilczhjrmlmoswnSQOEM24TTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZnhXXFCkGDujobVeixBCUOTW7Zd1VeEGHLjX9fsERc=;
 b=xebyzkgAP/OHMAmRIclS/sJa94djPRNJY0M7XFAbMWasoWjI6/ZuyFEypmwJmzXyUTyfVVan+p1YhPzN5u3Pv3w4JR4ZmLcrzUhQdPJ7vlCYmDVwD6lhAI7OYaR06tXSssY1RprjF5MS3CA7baGVcTPLzk5qNyHLlabESAsNeF1+3a+5Fzd0yTfFBWW4x9p+dvGAeDsx+h2J8yDgkKWDv+3UshYaRgaoMvJ3l5WCfvCRyujSyZXNxW7W1yQll4fVbEWZqvmVC/OgcBH+l3q1dOwkwfQYzetLRE6tDBtB4fmKRI3K/eMVSAS8v64pV23a9Xqp31LTgo56qJJCtnWI4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZnhXXFCkGDujobVeixBCUOTW7Zd1VeEGHLjX9fsERc=;
 b=RyqO0WXkKP2Og5xb7fl0uyYP49IeHWKq+SqjRsfju95J/3gGadHnUFISplo/EEf9pBaNYn7u413zL6kPGgi0h36oPTL261JJaaCG7IJTlp3iJcjNSSGJ4Q7wdC2hn1nbuuell+i4V8L24EBuBCdLrUrKETHpZTQDDTm6haw9RGgr7wEISobxlW5eVJ/K90mM/ZqWpp4UxQadUVlewoML60I3ni5U+BPM559TtfR/bi/mduyDzhHwlcqAKrlfNy2h1IzeNQ36InQPrPVKA/Ze7EpbeskvkJzbiLLHccSnKl/9v4IOjDq2rLYj/FPWyFmpXKnIdu1EzZXDlZg2vxNDig==
Received: from BN9PR03CA0437.namprd03.prod.outlook.com (2603:10b6:408:113::22)
 by SJ2PR12MB8737.namprd12.prod.outlook.com (2603:10b6:a03:545::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Tue, 8 Sep 2026
 06:55:13 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:113:cafe::1a) by BN9PR03CA0437.outlook.office365.com
 (2603:10b6:408:113::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Tue, 8
 Sep 2026 06:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 06:55:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:56 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 7 Sep
 2026 23:54:56 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Mon, 7 Sep
 2026 23:54:48 -0700
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
Subject: [PATCH net-next V4 12/14] selftests: drv-net: psp: Extract shared helpers into psp_lib.py
Date: Tue, 8 Sep 2026 09:52:42 +0300
Message-ID: <20260908065244.3799142-13-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|SJ2PR12MB8737:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed02a7e-288b-4761-a639-08df0d762166
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|1800799024|376014|7416014|36860700016|6133799003|11063799006|5023799004|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	i43m891qHpnecrYk5myFhYlaRcBDReuROMpNQ9ZL3KkxDOEG3E93Bx8IaX3fhAEfHdP32X5OaZOIxbx1+aOTgQL/8nYgTmgxOkMAZFJ5R2B4gI1Ek1KFY2OQZvuNk477FCtKqh3TQFfrfIjNyMrINFe49C2qkSF3TehMktCFEtcCSPUV7UbmONDxc1ROkuvGcW9jIzlGGevu/QXhSQ8/S9Wzn7Sf/aQ41V/r/OzP8uisOPMbCl+efPADzxpzfh75k6vdMj9rE1JFYxVQLuIKHkWlFR1RvA/8BDdKI6l5Dd+ny0FnkK3lURzfy8+x2fVTVERm7qCH2G7NtbWAOS5Z6+D6t6c9G7Imc5XIgkV7nA98alzCZxQImMZ/LQI+bU4zVqh1BBEt6e1XaqY/n2jStN7qg3Mi/xClr9yrkHSC6zcATbMztXG24t73CQjGbxP0/MzfafG9+BW8dUGt61iuhnguAcOaCd0ukWe6pmeti5YiKcaXY0eQHla6avciC8uyOIeVz+wCG/ZyArcoW8WooEcA3BaLccw8jq9I+fxqK7oEgS+WGO5h2rL0Q7Hg+dA/qC3L9GoZ7QBBU0fdG34xgxFRvvL6MJ1QU+ZE3QgqQHIN/xPNbBE6QU6aeWuTqFm/6EW/Q2e+29tkc/UCo6Se5LKqSh/Wng/nZQd8K57cugMrH1niVSlQ2yt4O3Koyx3nM0DzW6yKTOZkWToAre2mbA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(1800799024)(376014)(7416014)(36860700016)(6133799003)(11063799006)(5023799004)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1zA1Q4s0dPPD7XlPFDuXMPZoTnHe23S7tocsA598sC2bOGdfNoowhTa8D70sNvstZVY6+8IjJShpEsK7kmsz4oI+8o97Y1gpo1mDtCGQipYCgaQsgjZSPnFKvBdjwdu25no3QdMzotys2DSqtPBCuLMOb9n2FAcrllB2XIACHwMMB8EWcXfGlOBRcNIeDrRRgaN+Z8mGACaksJl9VeecA9EtxmRHoSXsTfdKTHXi4emLw3WPmzoKxIwTyLZbsTJyfjicc9IYhyzIXddZ0ieYgi1QdvA9STI2PI+aVfiMeIfU7IW7y7QC3ub9+D8yrUXx70ByLViuu9S+9tAD9ZsUTWkX22J8f/3bdK9x82egN06YENwrgZNfcGH+bIzildxFNNBiyBuJryscJoA+UVDRofvbDPIEDDtFI/RxlOsAcajneND9q59zUiE/wAm0FAzP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 06:55:12.5649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed02a7e-288b-4761-a639-08df0d762166
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8737

From: Cosmin Ratiu <cratiu@nvidia.com>

Put init_psp_dev() and the logic for requiring a psp version into a
shared lib, since they will soon be used by a second test file.

No functional change for psp.py.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/drivers/net/Makefile  |  1 +
 tools/testing/selftests/drivers/net/psp.py    | 77 ++++++-------------
 .../testing/selftests/drivers/net/psp_lib.py  | 57 ++++++++++++++
 3 files changed, 82 insertions(+), 53 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/psp_lib.py

diff --git a/tools/testing/selftests/drivers/net/Makefile b/tools/testing/selftests/drivers/net/Makefile
index 1f21e17d8c22..8cea66fa323c 100644
--- a/tools/testing/selftests/drivers/net/Makefile
+++ b/tools/testing/selftests/drivers/net/Makefile
@@ -32,6 +32,7 @@ TEST_PROGS := \
 
 TEST_FILES := \
 	gro_lib.py \
+	psp_lib.py \
 # end of TEST_FILES
 
 # YNL files, must be before "include ..lib.mk"
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

