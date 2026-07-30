Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCDB409103;
	Thu, 30 Jul 2026 09:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403232; cv=fail; b=moiRd+iddk7qPOeGuRW4E4B5l+bDLW5oE2r4upatyfT6sNTj8V/ttmCNBv7xBQt4nyxec34wIyN9hxUgNuSzp2VMVvH7hYJr/08AAIIUFftBWY9DhFvf37Bb6CG4a76mg1wfSOQiUwaT/vmRNLmBK37tK47ygWTE1ZyavyMjTzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403232; c=relaxed/simple;
	bh=bN8DCadmefRe/exx7ZiNg2vwfKfjfsEFkPr5xi8Jr/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sUz9lkfZi56lK+HIKIXnw8LnqyBHATgKvSkK9IqERRWZ8CitKCu7MvkyiA6Ggjb6Ww077ZbWsKFHEwXZH79yYRiIYvOSQ/qQUbFlfiVkJ9kpn3Co0H0ntqewkk0y1UKkonxz0L+kuDo8C7SnmrF6Cp1WeqbwBb/LWSYSD4veqrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uf4uLgul; arc=fail smtp.client-ip=52.101.52.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uf4uLgul"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G51dDd2JozETtqp0nbW37aaGZ+jH5gLioP6rBXJm7wEtJpE2vR1BvKj3HySLFnL2RkSjC9vQG35D7VPGszzv6O0wPVAIlMVs5TH3psTkR4V2lz4EC9SlHAJqA9oZrhVTEUjEo5R+BJwxwvdZ9FhX7C+QsVx5dRHF+IfEGqVYqHLn0HNbLtADGAe3cDb9jjDBSJKF+S3ioT1imMVo9qK3R/9TalKafYNDXn0gRkXQeHdHf1GAy+IxDJ9yjv1aR5HOVrHio2yzTsAFb2VpQYM3TwGm26QLzcbbLR4OmV4s1RzRWd4BwFjoOO9RqaDD8yOZxG3xhKpVrxFPKeX5xOhzkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8Aq8wCzG6ifRIJ90MbSmoO864fidAa8u6MSCWCE7h8=;
 b=qK3LhjDl4vVni/c1vxoSjJNQFILLlJr4m2KZdRrNfq8U1M1SLPIMeg4sN7rpzSZvzX4t9mStmhjjLSwh23nBMeRfiYOYmCgAWEI7blTt/4ig/tOfBLq8yXSEa3V0k+WXGkxKpw8eFf0XUZLUKoXvmbj0UqmK2E8AI02NpACHp4wrZuZbgDL03wPYSLmKMaxZwT+xXVy2LJum4Cv22aARCp3xlCUhTCxOnW4KkgyyTlazMkgdbmNpNzZU+ydWRVuih0uMe+zjAAQGKszodnRCidhpLRaFEgwlwSy0DrS8yg2OK12wZyvbwemsUXbmQ3pdCavl13TneHuMkAxjidAgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8Aq8wCzG6ifRIJ90MbSmoO864fidAa8u6MSCWCE7h8=;
 b=uf4uLgultFG8AXVoYQV95vhi3VwgwZLmnsNucx9CBmvCMiBLO94oCmPIFgO1LKzMx6xIjw01XJUB+7blEWNF8J80ffg3x3B4qLB13FO3QDH67Hyqmg5s72KX210BNdzHogCwikhG6MbJYwlkfgn76lRUlJTQfdQ9ZVV1ZtYt6008XJXN/nuv88NkNP47eJoLN7GtrIrVx2qEqNnqBLaCpAeh5D9TdOqoavkv8Kib4gXtIxeu6rm2z9tbcJnKGEGX5XCbQ3JA1E4Qj9zU17qgt9O6QKR6+LBDTflPz+BpJ6l3KRfEeJHvUb25YHi2mgLHyxSFNbVrSiq3K5b7J/xoOg==
Received: from CY8P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::15)
 by MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 09:20:17 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:930:6b:cafe::71) by CY8P222CA0022.outlook.office365.com
 (2603:10b6:930:6b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 09:20:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:20:17 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:20:01 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:20:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:19:53 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 12/12] net: psp: Add a self test for PSP with HW-GRO
Date: Thu, 30 Jul 2026 12:17:54 +0300
Message-ID: <20260730091756.2543777-13-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|MN2PR12MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: 55eec234-73b1-490a-0ef3-08deee1bc531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|10063799003|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OaiquLYL1he+an81gSwcnhP52GNdbOk9+wdtB0DDm53Anw+ep1/jhsxvondpiWrUbRG7Os/zay6eFreuUCDo/SYCqqA1wTCXDaMfwpmotyXFKKKHgtG1bPXDrx4weP30AShdFhiY2XbVt3qOA1peNACrRtfSJS5fBGxs6Vf+HKLsFqdHpIkirlzMoWYftJZhDjypgKSeEk7CAI7H+/N32nfMLA3XD9XbIm3FKx8c0UyDo14hR0pc/W0s1ffpRju9IAsRwiZAArsx8X4AgeNbFbLF+5MYRKIk4YxjUx7QCtTEaysQnHQx5fY2zxQkFf/WKcScD/Sj5R7wvWzGpCw8+p6rqBTtGJzfeUK9UPYn/GSuvx00Q+IpCx7IyPxFZWNznJxxNvj/OmaGHtyfhQqqozmMejCZ4ZK7osZUdDbVa2Dv48qEZBCtfkLjGrxA574EJ9bz1Dkzkjp4w4lxnW0TTNCmy8HAMk8NNPLIU9feACp1ARDddPDySjadU6Ojgq+2tSKxqR5hnONvKk4z+KnMc4F1VhHW/LcjpmZhXCGJUDMv9wu9Jrk4wxDz+QUVJIeVGJMKyTvqThngxhoJ6HE/PghPI4ecMgC4d26K+N2EMCYFAI6B4lSCCtL8so2pXMMF2Oe+s+dohwpezNGttngM7L6+ndyletNMXZ3HykQRtQZLSfqLu6sJ02VxOJINha/8AZ5odzMhP/bkQqSfobOB+Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(10063799003)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	60rJrFI6naxjzvAstRYiF3l/cZ3BYgZDLe7Mv/+9/kg5ZtaXYMMELDn1GOP0wHIdjPUla04v7FYfPZJIlUgnF1Q+QNO2uweHg1H8pZYarf/fIv1cUivyfgAvUekd1O+OGAEltmRGhIFqnIUB8V67wB5TAAPZMuxIrvv54cc8/kqERAWrcZMtl8eulorlKjJ4Ag0QCrpdEgV8iK2psBoOaZo26l4yzAzLm3puRQZRl/MF4+COJEBoXBENNSiFHgdSmxAhta51ilydjG8J8cF/3FFoZt+OO9rT9ppk1YdVT68d+s4XvndHDblyPr7WKiGAYWOWn6lTvhRDv7EIuI/LspnVchJhwnLLooK7QCCHbYFaPBiPlkoNqsxD1uI8QLZYMRxAVWJkKLkO077FV1z/sG0WkTueubZCQ1a5IdQ6QB5AkysRjROmkFYhUZ3CdiGG
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:20:17.1882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55eec234-73b1-490a-0ef3-08deee1bc531
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080

From: Cosmin Ratiu <cratiu@nvidia.com>

Add a test case which attempts to send several 64K chunks over PSP,
which is more than MTU, and thus trigger GSO on the TX side and
hopefully HW GRO on the RX side. Verify HW GRO counters increase.
This required the addition of a new command in the psp responder, so it
sends the data in order to get it reassembled on the local (DUT) side.
This is required in order to read the qstats.

Some light refactoring of the PSP responder was also done, because the
number of indentation levels started making checkpack unhappy.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/drivers/net/psp.py    | 129 ++++++++++++++++--
 .../selftests/drivers/net/psp_responder.c     |  51 +++++++
 2 files changed, 172 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 315648a770d0..7ac13df6d59d 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -18,9 +18,10 @@ from lib.py import ksft_not_none
 from lib.py import ksft_variants, KsftNamedVariant
 from lib.py import KsftSkipEx, KsftFailEx
 from lib.py import NetDrvEpEnv, NetDrvContEnv
-from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
+from lib.py import Netlink, NlError, NetdevFamily, PSPFamily, RtnlFamily
 from lib.py import NetNSEnter
 from lib.py import bkg, rand_port, wait_port_listen
+from lib.py import bkg, ethtool, rand_port, wait_port_listen, CmdExitFailure
 from lib.py import ip
 
 
@@ -30,15 +31,25 @@ def _get_outq(s):
     return struct.unpack("I", outq)[0]
 
 
+def _recv_exact(sock, n):
+    buf = b''
+    while len(buf) < n:
+        chunk = sock.recv(n - len(buf))
+        if not chunk:
+            break
+        buf += chunk
+    return buf
+
+
 def _send_with_ack(cfg, msg):
-    cfg.comm_sock.send(msg)
-    response = cfg.comm_sock.recv(4)
+    cfg.comm_sock.sendall(msg)
+    response = _recv_exact(cfg.comm_sock, 4)
     if response != b'ack\0':
         raise RuntimeError("Unexpected server response", response)
 
 
 def _remote_read_len(cfg):
-    cfg.comm_sock.send(b'read len\0')
+    cfg.comm_sock.sendall(b'read len\0')
     return int(cfg.comm_sock.recv(1024)[:-1].decode('utf-8'))
 
 
@@ -97,7 +108,7 @@ def _send_careful(cfg, s, rounds):
 def _check_data_rx(cfg, exp_len):
     read_len = -1
     for _ in range(30):
-        cfg.comm_sock.send(b'read len\0')
+        cfg.comm_sock.sendall(b'read len\0')
         read_len = int(cfg.comm_sock.recv(1024)[:-1].decode('utf-8'))
         if read_len == exp_len:
             break
@@ -583,6 +594,108 @@ def _get_psp_ver_ip_variants():
         for ipv in ("4", "6"):
             yield KsftNamedVariant(f"v{ver}_ip{ipv}", ver, ipv)
 
+def _enable_local_hw_gro(cfg):
+    cfg.require_cmd("ethtool")
+    feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
+    gro = feat.get("rx-gro-hw")
+    if not gro or "active" not in gro or "fixed" not in gro:
+        raise KsftSkipEx("HW GRO feature not reported by ethtool")
+    if gro["fixed"] and not gro["active"]:
+        raise KsftSkipEx("HW GRO not supported by device")
+    if not gro["active"]:
+        try:
+            ethtool(f"-K {cfg.ifname} rx-gro-hw on")
+        except CmdExitFailure as e:
+            raise KsftSkipEx("Cannot enable HW GRO via ethtool") from e
+        defer(ethtool, f"-K {cfg.ifname} rx-gro-hw off")
+        feat = ethtool(f"-k {cfg.ifname}", json=True)[0]
+        gro = feat.get("rx-gro-hw", {})
+        if not gro.get("active"):
+            raise KsftSkipEx("HW GRO failed to activate")
+
+
+def _remote_send(cfg, size):
+    cfg.comm_sock.sendall(b'data send\0' + struct.pack('I', size))
+    response = _recv_exact(cfg.comm_sock, 4)
+    if response != b'ack\0':
+        raise RuntimeError("Unexpected server response to data send", response)
+
+
+def _recv_all(s, expected, timeout=20):
+    s.settimeout(timeout)
+    total = 0
+    try:
+        while total < expected:
+            data = s.recv(min(65536, expected - total))
+            if not data:
+                break
+            total += len(data)
+    except socket.timeout:
+        raise RuntimeError(
+            f"Timed out receiving data: got {total}/{expected} bytes "
+            f"(responder may have failed to send)")
+    if total < expected:
+        raise RuntimeError(
+            f"Short read: got {total}/{expected} bytes "
+            f"(responder connection closed early)")
+    return total
+
+
+def _data_hw_gro(cfg, version, ipver):
+    """ Test PSP data transfer with HW GRO enabled """
+    _init_psp_dev(cfg)
+    # Version 0 is required by spec, don't let it skip
+    if version:
+        name = cfg.pspnl.consts["version"].entries_by_val[version].name
+        if name not in cfg.psp_info['psp-versions-cap']:
+            raise KsftSkipEx("PSP version not supported", name)
+
+    _enable_local_hw_gro(cfg)
+
+    s = _make_psp_conn(cfg, version, ipver)
+    try:
+        rx_assoc = cfg.pspnl.rx_assoc({"version": version,
+                                        "dev-id": cfg.psp_dev_id,
+                                        "sock-fd": s.fileno()})
+        rx = rx_assoc['rx-key']
+        tx = _spi_xchg(s, rx)
+        cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
+                             "version": version,
+                             "tx-key": tx,
+                             "sock-fd": s.fileno()})
+
+        try:
+            before = cfg.netnl.qstats_get({"ifindex": cfg.ifindex}, dump=True)[0]
+        except NlError as e:
+            if e.error == errno.EOPNOTSUPP:
+                raise KsftSkipEx("qstats not supported by the device") from e
+            raise
+        if ('rx-hw-gro-packets' not in before or
+            'rx-hw-gro-wire-packets' not in before):
+            raise KsftSkipEx("rx-hw-gro-packets counter not available")
+
+        # Remote sends data in 8KB chunks; GSO on remote TX segments them,
+        # HW GRO reassembles on local RX
+        data_len = 10 * 65536
+        _remote_send(cfg, data_len)
+        recv_len = _recv_all(s, data_len)
+        ksft_eq(recv_len, data_len)
+
+        cfg.wait_hw_stats_settle()
+        after = cfg.netnl.qstats_get({"ifindex": cfg.ifindex}, dump=True)[0]
+        ksft_gt(after['rx-hw-gro-packets'],
+                before['rx-hw-gro-packets'])
+        ksft_gt(after['rx-hw-gro-wire-packets'],
+                before['rx-hw-gro-wire-packets'])
+    finally:
+        _close_psp_conn(cfg, s)
+
+@ksft_variants(_get_psp_ver_ip_variants())
+def data_hw_gro(cfg, version, ipver):
+    """ Test PSP data transfer with HW GRO enabled """
+    cfg.require_ipver(ipver)
+    _data_hw_gro(cfg, version, ipver)
+
 
 def _get_ip_variants():
     for ipv in ("4", "6"):
@@ -937,7 +1050,6 @@ def _setup_psp_attributes(cfg):
     cfg.psp_dev_peer_nsid = _get_nsid(cfg.netns.name)
 
 
-
 def main() -> None:
     """ Ksft boiler plate main """
 
@@ -954,6 +1066,7 @@ def main() -> None:
 
     with env as cfg:
         cfg.pspnl = PSPFamily()
+        cfg.netnl = NetdevFamily()
 
         if has_cont:
             _setup_psp_attributes(cfg)
@@ -973,7 +1086,7 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust]
+                cases = [data_basic_send, data_hw_gro, data_mss_adjust]
 
                 if has_cont:
                     cases += [
@@ -990,7 +1103,7 @@ def main() -> None:
                          case_pfx={"dev_", "data_", "assoc_", "removal_"},
                          args=(cfg, ))
 
-                cfg.comm_sock.send(b"exit\0")
+                cfg.comm_sock.sendall(b"exit\0")
                 cfg.comm_sock.close()
         finally:
             if srv and (srv.stdout or srv.stderr):
diff --git a/tools/testing/selftests/drivers/net/psp_responder.c b/tools/testing/selftests/drivers/net/psp_responder.c
index a26e7628bbb1..90f09c1f6984 100644
--- a/tools/testing/selftests/drivers/net/psp_responder.c
+++ b/tools/testing/selftests/drivers/net/psp_responder.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <errno.h>
 #include <stdio.h>
 #include <string.h>
 #include <sys/poll.h>
@@ -118,6 +119,34 @@ static void send_str(int sock, int value)
 	send(sock, buf, ret + 1, MSG_WAITALL);
 }
 
+static int send_data(int sock, size_t len)
+{
+	char sbuf[8192] = {0};
+	ssize_t sent;
+
+	while (len > 0) {
+		size_t chunk = len;
+
+		if (chunk > sizeof(sbuf))
+			chunk = sizeof(sbuf);
+
+		sent = send(sock, sbuf, chunk, MSG_NOSIGNAL);
+		if (sent < 0) {
+			if (errno == EINTR)
+				continue;
+			fprintf(stderr, "ERR: %s: %s\n", __func__,
+				strerror(errno));
+			return -1;
+		}
+		if (sent == 0) {
+			fprintf(stderr, "ERR: %s: peer closed\n", __func__);
+			return -1;
+		}
+		len -= sent;
+	}
+	return 0;
+}
+
 static void
 run_session(struct ynl_sock *ys, struct opts *opts,
 	    int server_sock, int comm_sock)
@@ -224,6 +253,28 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 						fprintf(stderr, "WARN: echo but no data sock\n");
 					send_ack(comm_sock);
 				}
+				if (cmd("data send")) {
+					__u32 len;
+
+					if (data_sock < 0) {
+						fprintf(stderr, "WARN: send but no data sock\n");
+						send_err(comm_sock);
+						continue;
+					}
+
+					if (off < 4) {
+						fprintf(stderr, "WARN: short data send command!\n");
+						send_err(comm_sock);
+						continue;
+					}
+					memcpy(&len, buf, sizeof(len));
+					__consume(sizeof(len));
+					send_ack(comm_sock);
+					if (send_data(data_sock, len))
+						fprintf(stderr,
+							"WARN: send incomplete for %u bytes\n",
+							len);
+				}
 				if (cmd("data close")) {
 					if (data_sock >= 0) {
 						close(data_sock);
-- 
2.44.0

