Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB2F40B360;
	Thu, 30 Jul 2026 09:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403238; cv=fail; b=eIqCB36odYUpe4Ppg+mvPE1130x4Bjwd8ifPN0vDYX5WG2FeKWmPJOUPVvFJ+BxteWDIxWS8OMSTPo1zzAkbr9OptQSg9kjZh8/gWyiXbxaoCktjw9kqHG3FJZlX3WLGaagY14iGGIZt5yYfzBH+QGc3eqWmBose0INIoSgvsqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403238; c=relaxed/simple;
	bh=yjfriBvXKjoDk6+wN4kqTRXj4+81EBPFO23znCrpGdo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yxvo7CsY9dc3b5GpG6IxfNwyTw/qSVhcMfhZu3QBh4dKoWkfLQuaUHWOxqM35hQmAmO402UE7mMIQ93heZ78R1I1VD6Zu96w+gqOzEdEYHqph+VZmVDu6U8mwPHN12zd4XpMUr5DKqi7vBum7I+T0izFrqOBmAjLoyM5LTsq6fI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IRuA7K2Y; arc=fail smtp.client-ip=40.93.194.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IRuA7K2Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3jYnMVf0xDc2E+dDwDvfkUgrxzrHHsH3m6oBFNVavqd1Ij8S5M1/qZ7tu0jx63TEWf7TkG6eqoRK/5Lhw36JiLpTLd7wxo9PxCxaUzm8EW+ZLt312DagmoO6NvHdV69Vv2NCAFcM3NZC+k5bbKB0+2iSEuijcJ8+POaL1iSYiy/PndZkDTG1P9ORvE/56LOLVGXe+Bg63Ud8qAfoCJfS8M9eHLXUi7aA/AHGD9Q3XsKPZGXjmSXZa1SIH9JHptvQWvWDDzOgOy+ymI31UZs0t6IG18h7UqEUj/JR0Cw5y10cabt6MsxfE9Y8vU6phgRAEA/RE+vSlpvToeDL9P9tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXCBKta+fsTSI6LQkHP8qqVZPR4FEcTWtHyTKEL2A0E=;
 b=V/gFkLAh8jXV+Ob08itM1HG6AbWkNRtuAS1Dv+xbQhK6GG0XbkxRWrHX36CKXuU33tHC2qFA3X64JJTMIfL8UwK5BR9wWC1yZ6yO70cVy40ESoDF/vQPMpxLTnPxSFzIpophnGqz7lMXfyPBz0HdjPf8g+l4L73gFEcZioEHHfSzH5TWpild0FrfSaLG/taQqxVccwZi44qGeDwSGYfpGvv2yFWWPj6DoVsrtbJ29GXP1udb9ewrI6huB8BTWbrxqDEOPmgkhCE/MxB1mMIK8ziFyU/dBJv3krIAHrro1FrZ8TJ8kSSCnHNQOSNU2R6/9ENlcVOxaln+j5TxgAdcfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXCBKta+fsTSI6LQkHP8qqVZPR4FEcTWtHyTKEL2A0E=;
 b=IRuA7K2YVC+5Iisz8cDjMQs6tvxja4ghf78kwwZABP+q5p9z6I51nJBSnHjlE6n3VYrpGpf1qQWGGUDtpcAd/VxcBIcnBtEZYYUCkVWVVQ0TjZe3Z5SEHkZsnbFCOgJrgK11AYRPbeOBuVZj9c0mIJ0AhL387JyBIWWVRPDu0XVV2HuE2e8DUpLmCf4XKUftBr+WKbfTK5XT2AtqOZ3Qj08Y40qs7BuIldUL+7NkVwnNwezKsoUf+DPuEajnWCpEw32oPz9p8QeOxE4YiXl4B6AOFfuRlO+RkrmZveVyx3Cd9KG/4/fMUAWrLdksG433ExUjRuOpoZQE7rcmjlpXnw==
Received: from CY8P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::29)
 by PH8PR12MB6868.namprd12.prod.outlook.com (2603:10b6:510:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 09:20:30 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:930:6b:cafe::4d) by CY8P222CA0005.outlook.office365.com
 (2603:10b6:930:6b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 09:20:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:20:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:20:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:20:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:20:10 -0700
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
Subject: [PATCH net-next 13/13] selftests: drv-net: psp: Add a test for PSP with HW-GRO
Date: Thu, 30 Jul 2026 12:17:56 +0300
Message-ID: <20260730091756.2543777-15-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|PH8PR12MB6868:EE_
X-MS-Office365-Filtering-Correlation-Id: d86d7e09-8f74-4a2b-13f0-08deee1bccc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|7416014|376014|18002099003|22082099003|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	996yJLbFPha+g36RZpTJ2JMSmHmVc0iB3bpWEa6yHoTvYNRZpb1x4iC3PlKlsU/h3zh/Da1yhTTsQeLzwdrLT2cvbEi1+Hv95Zp+6CdXEem/jxrlp+qysl6ae1loA0V1pIGWuYCoQ0rQu2EvQojWYXiWsNcFmjkNiTgUluxocyIlLAQ+mxqBn4eVOKw4yK+P01H6K0Ym+q6i64D/rRgQIqH9RmApSl0OkhsSR0gV3892QXNRie9pDSbAYvYeOqUP/bAi5NAlSs4FmBlrJI+87qr4l3oeo45ppOELNJv/Vur3pF1Q2EMHrsHLub3vewVzn6iksyC7uhLoHeqmMSGHy3cubMbstLbgzGR8LYKU1FJ1Kjytr99tvzkF0IMRw0bayv8oGJfMaSzMbZsCP4RhsS+iry6FfE84Bxi0qdq+7Gr33WsTm2FE4pNe/RTdKALppqSsT0Ib0JSp3F19WOmMqBAPpdYgnl4iZFx1cG33+QwuPNI5cMommfbQyTCSTojXnA9G4MQ2/VrLZrKQNRxyuqM47RP7Si2W7yrur20K87aRF5VeH++fFggXoY6svJtQ/A2SkL0jbKoP/ChE+SST0IPEKcPSK7Wk+Ysxa34isFbDOkxjkEmP9A+F6I6/QlUksAqH97zMy6QOW1qwVefK6+Flrx3snba0maEzVwmjJdvi8z8vOsxcqKOrO9hDte9Zj3O5jM928OSay3gqDBIDZg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(7416014)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+GWje+Vd1EXe/KrmgspoDio4JfSJTUzEG8w5l7AvZrFmWQJB3M/EmaHPr73qdEkafQEPWUtluhQERG211Pe0bfSqbbvj5ewQ8/WI1bA7Ht425uwLLnCzco7SGHiark1o5A5FEsjkF9BnLvmD8xQA+zlff30Pp2Ltqigh+1NJ0FfJ5Ob7GjcCw5ltz4wXg7mLITFcz8JAo6niQ5sNZN8AP9tAqNAs+S2PecCCV8yC7EFgEbIMBo22pbMRdvit2XYJZdWp7/IcsHVnaQ3J6nTadZmSmafvLaoUX2/9sRLzPXfvjYKitqQF5lN5ZkvDRtPiuCc0C4Bl9DkW1YBep7ky1tPMBKf2RQS9ZS3i8cj5K0VuY0mMXslwpGv36sxLVk+wgabeBY3ekY2nB5XWj1TmGgu6VvT3LbROPAiYVPhayXktkQATI22MX5IxJrj6IPMC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:20:29.9209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d86d7e09-8f74-4a2b-13f0-08deee1bccc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6868

From: Cosmin Ratiu <cratiu@nvidia.com>

Add a test case which attempts to send several 64K chunks over PSP,
which is more than MTU, and thus trigger GSO on the TX side and HW GRO
on the RX side. Verify HW GRO counters increase.

This required the addition of a new command in the psp responder, so it
sends the data in order to get it reassembled on the local (DUT) side.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/drivers/net/psp.py    | 129 ++++++++++++++++--
 .../selftests/drivers/net/psp_responder.c     |  49 +++++++
 2 files changed, 170 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 315648a770d0..503516f76722 100755
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
+    cfg.comm_sock.sendall(b'data send\0' + struct.pack('!I', size))
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
index 985161eb482b..9a675bf449f5 100644
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
@@ -224,6 +253,26 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 						fprintf(stderr, "WARN: echo but no data sock\n");
 					send_ack(comm_sock);
 				}
+				if (cmd("data send", 4)) {
+					__u32 len;
+
+					memcpy(&len, buf, sizeof(len));
+					__consume(sizeof(len));
+					len = ntohl(len);
+
+					if (data_sock < 0) {
+						fprintf(stderr,
+							"WARN: send but no data sock\n");
+						send_err(comm_sock);
+						continue;
+					}
+
+					send_ack(comm_sock);
+					if (send_data(data_sock, len))
+						fprintf(stderr,
+							"WARN: send incomplete for %u bytes\n",
+							len);
+				}
 				if (cmd("data close", 0)) {
 					if (data_sock >= 0) {
 						close(data_sock);
-- 
2.44.0

