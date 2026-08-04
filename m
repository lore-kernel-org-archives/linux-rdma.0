Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011047.outbound.protection.outlook.com [40.107.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B58841D12F;
	Tue,  4 Aug 2026 08:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832733; cv=fail; b=XymEOLYk9XHrAY0JBcRC2L7WogU3qPb2cs6+5IkcX7FfUs4FT53+heAd4vXG7tjEmA2GjImsMESHu3gZnCgFQZW2JbzErs6Eaap+d83uianZzrI8NJsDxSVQDjymXD70HVxhUP+prhplB7oCghq8TulcNge56eTe2z1IhTaq6Qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832733; c=relaxed/simple;
	bh=pRs1d7exX2CTZlgQ/pQ4DdKwUwkL1yUWWvs3KMhSRpg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAhKAecda2HiYRjfz6mvhR6OX0UTXAVVHJzWu0Upd31lQCG+O0Nr4jTpHYceS0zH+3NB+HtvSyVwWikXTu34e5HWm/pRfLRgS2Bp0ZyMyuWJqm95Q8FZ9M2y9QJsxUKnpzwT3D9BEpUrZ3rJVBgaBTbyVJ5htNfSoXmGxvOxkx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EGhFCs/M; arc=fail smtp.client-ip=40.107.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EGhFCs/M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8JschJPzRQMsntPPYDBCdDEMjY1AybNVyYjEL8AYXyWMdHpHtF1BEP8/0/aKje7f0nfQ3LGX99seFCotts4uJIkJR0EbYT9SI6E0Imkiox3PKpesP4+d8xL/3W3Hrmevgcoy0Lufzo58ZpzYxJ3MCKdNOLBM2zufIurkUNuz9lxhQKZ97T6vkdbUc/t9ya+IcmrzfnibwvS0s3mu/0PDicdaVHnLhGR7rfA2u8d8lvgzQI4Nm8zhCWAwv+tU6FJNbFSidhCZW+PWmEFq/b6yBPLafm27QgiSNLO9QDLCnNEkPP0I66m1TPHWLsyqvOqbksqLtEtyxrheTvqUNQiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMrLY0yInKU641Hd5nGGp2MRkxOi+pLr/UbL3QBlHJk=;
 b=R9TtO6+g6IFVccR3IHaIRO/GX+3mWQlttiXeRGFLeT9ehM03AEKEJV/zMW44F0IqPgWG+s2wt/G8+HY6UpUN+caBvAtIM8xdaoEP9cvVOXL67/bqI1rFawPng7Ygsg0iuuKbApvgcn7GJaTS/jAb5X9ckmHvMeY/6QGHk+1wipr3hvTd2rBScNRbhEla1+f9ELLnmX58w2I06pNemQ21Nr1/IEhPxvaBd1YjK7Bc16B/TIzQ1i5PteVf5xwaYx2BMpjiI3kMbWBQMsLRADyDQWyZgBtohtw1JawJhU/nQlQU87+5ZaMXKK7n2qkMpN0yb73mH25fT4K6R1Ssj1vV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMrLY0yInKU641Hd5nGGp2MRkxOi+pLr/UbL3QBlHJk=;
 b=EGhFCs/McuApkt35bZPbTfC3U6eF/KEd0PhsflogSNeWh9Xcy/PqenTxkJbDf+2Rd/20OBMXWWdv4d08Oz3a34ZqA7E+kVHtoy6CYTJXVl6hOzazWOoEgCrZ6N5w/FLtgjZKm2IUD1Vwadqi3+FJxg6xu1dfyDFeJHsCT2TNjbddu2j5XcmR2KbAlcJ5St68TwvcGET7AVfcTNqUbLhUvIziCgLxyAufRQgoJIaZfuEuDmEqam1HroSLahf4F6XcCcVkiKL8TT0/hWcyNpTk1QcNWcHYLpUiRDpWzxPVVSDNO/egZjWDDTSeOIc20yazlXf9QdVUf+ABdOw82w/z2w==
Received: from PH0P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::26)
 by SA1PR12MB9469.namprd12.prod.outlook.com (2603:10b6:806:45a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Tue, 4 Aug
 2026 08:38:46 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:d3:cafe::80) by PH0P220CA0015.outlook.office365.com
 (2603:10b6:510:d3::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Tue, 4
 Aug 2026 08:38:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:38:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:38:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:38:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:38:24 -0700
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
Subject: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test for PSP with HW-GRO
Date: Tue, 4 Aug 2026 11:35:35 +0300
Message-ID: <20260804083535.2946459-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|SA1PR12MB9469:EE_
X-MS-Office365-Filtering-Correlation-Id: 3983d18d-4884-4f0d-6e7d-08def203cc40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|23010399003|1800799024|82310400026|6133799003|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YCZzEntMZrlgpCwzJ+Jvpkt7+Nd2DMXyI14wVgPPf+iUaeiu9FtDkDByq9AdlvjYCiDbEtxFTP5zVFgO2nf5uqh5O+jJhtVQwyAJ7CED3jtLIV8p1ycOFGPh1pJoILbHNTmTueIj5KZX2MO7xeXLcTJFHyyFMBXXqZRCBRVx//CvY3OtGyRTIY01q7yy8djKz70VWnK1gvvgE2t3QGlobaKZYp3lLEbM498vKQszmulIEL/oQ+QWi2JLwsVKq+uveqhs9W73Z8RkeppWS+ha+wS+r6ykVEqT9gToG8WI7bSFK+1OWX7K+cqCIYNpJLL/Y4jeA3F5dvLmzcrHVraK9660cEnaDxbAIVKZ4w25VXP7/LVTXZL0Ee9bLRC1hyagc7famQSKFdY0kC1Ex50YiYW5Uqa05xvzf0i/j/F9bIxjZfcrc8Rksf4D7Wjmfx+Rj/Sdj68FDVQR3Phn+Ss839LB2GAUsBx7PEF8kQ+qTj4x+Qmx7TMDjwr9LyilEcOC6RIVsdh5B0FvXBiS7szjdGkxih4z7WXVARihXMsk2gkU5yFX9vWr41Ms2F/9xGRvVu79vlVRLWeIgt5iprGiU8X3Xwrh+OrAMNaMAuC6O1SUP50WFA3SJR89VeANv2/b73kN0Zps3y8o41Rp3CO5xfJ5DLavwJh5cWUuk/isvh5u97YIpinc6l6zmC+VdNIj8MNun+yntANBPnSgeIyvEw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(23010399003)(1800799024)(82310400026)(6133799003)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fzbk+FikZBiUJ1fxKh8ZVoRs2uvXxCP6lE9++QbQWqa4MD88lU6l5cdv2ILsBcZUDLw0Fz9a+nLrl/Q+F3aH2uH/VXOXlnv2DvYJBgrRvyrPpF3TUTlAomn1YEY695ksnshwlLUzBTPol0cg6XcqtWShbxyeAIsauUURbEzxEwBkL5jlu01CwpTqECbP3lW5e7gFwreulqnPJjwNrnpiOh/UEkPODFwTj14L7YaRTGQe7vvEJIXmz9NgSnEhhbvIlQWhw50mHrzEFmXG6Y2DPC9b8JfDRe0YWWLsMCi4T2KUcHTW6nhDry36pzkYyvpr7qGg73pgtUTmdodacqOEyvf0ABNIKLWKXiR2EeniYO+WqYTrCXd0LxA3U90Sp3qlo5OlY1rqM3uetdYJZfIu9vuI7I8ckKIAusCR9I0xpDDiI6fDdfxykux+xhozOq+v
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:38:45.7184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3983d18d-4884-4f0d-6e7d-08def203cc40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9469

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
 tools/testing/selftests/drivers/net/psp.py    | 131 ++++++++++++++++--
 .../selftests/drivers/net/psp_responder.c     |  49 +++++++
 2 files changed, 171 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 315648a770d0..9b899723a635 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -16,11 +16,12 @@ from lib.py import ksft_run, ksft_exit, ksft_pr
 from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
 from lib.py import ksft_not_none
 from lib.py import ksft_variants, KsftNamedVariant
-from lib.py import KsftSkipEx, KsftFailEx
+from lib.py import KsftSkipEx, KsftFailEx, KsftXfailEx
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
+        raise KsftXfailEx("HW GRO not supported by device")
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

