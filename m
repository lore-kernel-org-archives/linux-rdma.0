Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792799280;
	b=zQdYizih4o+Jx9F4KLzNtVe5CCMmljAIQAVlY8S+hQyoifgEmAM8OWc7x+xGJDCb6lNR
	 aQVa3+Uefd8MU7ui5aYG4F9hxzNwgPzGaMnbWY5WaakSL110z4jyaOr+APCjgXVYL/N+u
	 4FyDrjNeV5MArpPj/104M26ERH+2ZF0EwNrQv1AOojTTd5ZJn7AnYfTaNgjnX3MO+jR07
	 FIqFxNMxAthysGFwdo65hlT7Ot9cNTZGcaXJh7un5iTWTxrcPzmPkPSIhWv+6wYBXMZvN
	 xZYEHL+tXkKyxxYybv3+c0uyUXcyG4O8GBrT6t0vAj5Z51Mkg7r6bhQzxy5uv9sgdSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792799280;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=V0KRSnTQgsuyoCnqcOCSP7hPdfB/sup6xM+GXkHFEg4=;
	b=xTaysACaKFlUSbRxfCoAB+mP2jI2od3afZOi5LzxacmGxV1br23tcFia981YJsuN/Zj6
	 grsJVtsWtsc3HGWNosT6IFmKupe8FgnM4DaAreguuSXCjZVodwH7n9FSlQUk4qfk31Ffq
	 5VYxj7T5Gq46weY2jFuSHodywTcFfcOKsaVN4bn0UV8OtU7hs/r9FBgsw87Rfcpoi1ZTC
	 mWAdIYVzSdgI3WcpsGuZvMddtMBjtB/ub3Ah09tLJGoqYuZlA3cLYHFC5JJQdWnpSVKzf
	 uxsoPoqLdNhsOktv3oMSxn7X+57W2OKi3IjnL+ZLzYJxGEYb2OOLzWOTWYRTzK/A9VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="KXH8OX7/";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE7606A332;
	Fri, 23 Oct 2026 23:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDBE7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KXH8OX7/
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NLwaIt363340;
	Fri, 23 Oct 2026 16:47:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=V0KRSnTQgsuyoCnqcOCSP7hPdfB/sup6xM+GX
	kHFEg4=; b=KXH8OX7/8Bbzm3JJCagUcMRm9DCm/Wm/SmqrbhKY44qpUcWbfd54M
	VN2zv99SHc6LoSyxytgq67hS5wCnXvJZoTjGha/mLB4h1IcDxU/Aq+HFZ5dTsctW
	xbgcPaEXcdU1QYR3Oq07zG14wHe+LnildxosEgxUe7fqAzym3ekNzrx2eR8baMSN
	+qVjp5IX56KHNQvwBIatxuY2COmCvuV3JIpS+CSCqohSfICfAlVgZLAi/NFL4bfk
	m17gBSqwtNnXvLz8UrsXSwZNMLK77i5ovqfP61zVLX630A62jsiCjtkEG2yLgs4l
	pDgbMZ0ynl6E/p77w0zsPerOvxK9fMIbw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hfjf6mnvs-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 23 Oct 2026 16:47:45 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Fri, 23 Oct
 2026 23:47:44 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: Boris Pismenny <borisp@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        "Mark
 Bloch" <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Daniel Zahka
	<daniel.zahka@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Cosmin Ratiu
	<cratiu@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Rahul Rameshbabu
	<rrameshbabu@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Dragos Tatulea
	<dtatulea@nvidia.com>
Subject: [PATCH net v3 4/4] selftests: drv-net: psp: test ipv6 tcp socket with extension headers
Date: Fri, 23 Oct 2026 16:46:40 -0700
Message-ID: <20261023234640.1459291-5-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261023234640.1459291-1-toddfreed@meta.com>
References: <20261023234640.1459291-1-toddfreed@meta.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tN8MEShNm2XChcwZRmfDImvy0DOI_x2o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfX1QZSx8dSBEnO
 +ftIZCQLUnYBkIgcjiyPJjwPA1TK0uiaXsVqW/kA6U4yJoXvDbc/ou0gCsXKJbEEflK+k5jTkpt
 kt+BSCm5rdY4WmlEglOyBRMtD7i+pt2jO4QcQi1ktfXmtaUwYuK6hhthy+w31k0H04umAwBMunw
 3uzDmtbwCMkBI9smr5gJsyvdh0U8lUlVIb/u6YsBJTP9g9vHAoasbhWl6WOmgAp5yeVFMdaKhxp
 LrUEH5VnVmQ2kL3ZjZ3xC81BYfFEuSvG02kYbIDmwutIUehbuIDmFr8lvqlJWhaH0PBPaGgUecG
 Z8X4RaP8kaHEd9F/Ea87UPjzdVlTtFz77W+VKEAGxHUDv0r5mdMkpISmB/F9++L8nEDVzVN/VMT
 C9Ioe5QddHiuTrIJx4tayp/F8GUEZuzD8nEiYIBFouiW5zHW43BO+CjFP3I1aYlmUj4zMWijNB1
 RwZRn26TeiAlHyZjMBw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA5MyBTYWx0ZWRfXwWooCrDkrTNP
 snJ4beN+Zxpo4YueZlNE/bQ6hVk2c5gVVtHT0MZQHm74S3VgRn1zzton/KdPqDm16+I37pJ8gsa
 Oyw3l2YWPZBWZQb1O8YdgH8D4faNY6E=
X-Authority-Analysis: v=2.4 cv=PNaaavqC c=1 sm=1 tr=0 ts=6adbf221 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=VabnemYjAAAA:8 a=lTER4rxrKETuIA4zvy0A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: tN8MEShNm2XChcwZRmfDImvy0DOI_x2o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_06,2026-10-21_02,2025-10-01_01

send on a psp tcp socket in three phases, and after each, check that the
data was sent, counted in the device's tx-packets, and received by the
peer. phases:

 1/ no socket options.

 2/ an extension header set on the socket.

 3/ option removed.

the test has a variant for each supported extension header type. for
the routing header, the test enables seg6_enabled on the peer, which
otherwise drops packets with a segment routing header.

a software filter on the peer also counts udp packets from the socket's
address to the peer's. the psp packets reach the peer as decrypted tcp
packets, as expected. malformed or unencrypted packets show up as udp,
and the test asserts there are none. if the peer can't take the filter,
the test is skipped.

tx-packets is read after it has quiesced, because some devices refresh
counters periodically (mlx5 takes about a second).

without the fixes in the preceding patches:

- with netdevsim, the peer receives none of the data of phase 2. it
  stays in the send queue, and the test fails after waiting for it to
  drain.
- with mlx5 (connectx-7), the packets go out unencrypted and aren't
  counted in tx-packets. the test fails on the udp packets which reach
  the peer. capturing on the peer,

    tcpdump -i <dev> -nn -A 'ip6 and src host <sender> and not tcp'

  shows them as udp, with the test's payload readable

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/config |   1 +
 tools/testing/selftests/drivers/net/psp.py | 137 ++++++++++++++++++++-
 2 files changed, 135 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/config b/tools/testing/selftests/drivers/net/config
index 4838adf27fa1..409f9a96a102 100644
--- a/tools/testing/selftests/drivers/net/config
+++ b/tools/testing/selftests/drivers/net/config
@@ -4,6 +4,7 @@ CONFIG_DEBUG_INFO_BTF_MODULES=n
 CONFIG_INET_PSP=y
 CONFIG_IPV6=y
 CONFIG_MACSEC=m
+CONFIG_NET_ACT_GACT=m
 CONFIG_NET_ACT_SKBEDIT=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_CLS_BPF=y
diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index a5b1e14f120f..2a56a7bf5d24 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -16,12 +16,12 @@ from lib.py import ksft_run, ksft_exit, ksft_pr
 from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
 from lib.py import ksft_not_none
 from lib.py import ksft_variants, KsftNamedVariant
-from lib.py import KsftSkipEx, KsftFailEx
+from lib.py import KsftSkipEx, KsftFailEx, CmdExitFailure
 from lib.py import NetDrvEpEnv, NetDrvContEnv
 from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
 from lib.py import NetNSEnter
 from lib.py import bkg, rand_port, wait_port_listen
-from lib.py import ip
+from lib.py import cmd, ip, tc
 
 TCP_ULP = 31
 
@@ -120,6 +120,57 @@ def _check_data_outq(s, exp_len, force_wait=False):
 def _get_stat(cfg, key):
     return cfg.pspnl.get_stats({'dev-id': cfg.psp_dev_id})[key]
 
+
+def _get_quiesced_stat(cfg, key, timeout=10):
+    """
+    Like _get_stat(), but wait till the value stops changing. Note
+    that some devices refresh flow counters periodically, e.g. once
+    per second with mlx5.
+    """
+    val = _get_stat(cfg, key)
+    end = time.monotonic() + timeout
+    while True:
+        time.sleep(1.5)
+        new = _get_stat(cfg, key)
+        if new == val:
+            return val
+        val = new
+        if time.monotonic() >= end:
+            ksft_pr(f"{key} still changing after {timeout}s: {val}")
+            return val
+
+
+def _remote_udp_from(cfg, src, dst):
+    """
+    Count what reaches the remote from @src to @dst as UDP, with a software
+    filter on its ingress (offloaded filter counters are refreshed
+    periodically). Returns a function reading the count, or None if the
+    filter can't be installed.
+    """
+    flt = (f"dev {cfg.remote_ifname} ingress protocol ipv6 pref 1 "
+           f"handle 0x5053 flower")
+    try:
+        qdiscs = tc(f"qdisc show dev {cfg.remote_ifname}", json=True,
+                    host=cfg.remote)
+        if not any(q['kind'] == 'clsact' for q in qdiscs):
+            tc(f"qdisc add dev {cfg.remote_ifname} clsact", host=cfg.remote)
+            defer(tc, f"qdisc del dev {cfg.remote_ifname} clsact",
+                  host=cfg.remote)
+        tc(f"filter add {flt} skip_hw src_ip {src} dst_ip {dst} "
+           f"ip_proto udp action drop", host=cfg.remote)
+    except CmdExitFailure as e:
+        ksft_pr(f"Can't count UDP on the remote: {e}")
+        return None
+    defer(tc, f"filter del {flt}", host=cfg.remote)
+
+    def count():
+        filters = tc(f"-s filter get {flt}", json=True, host=cfg.remote)
+        for f in filters:
+            for act in f.get("options", {}).get("actions", []):
+                return act["stats"]["packets"]
+        raise KsftFailEx("no action on the remote filter")
+    return count
+
 #
 # Test case boiler plate
 #
@@ -624,6 +675,85 @@ def removal_device_bi(cfg):
         _close_conn(cfg, s)
 
 
+def _ipv6_exthdr_variants():
+    padn = bytes([0, 0, 1, 4, 0, 0, 0, 0])  # one PadN option
+
+    def srh(peer):
+        """ segment routing header, with @peer as its only segment """
+        return (bytes([0, 2, 4, 0, 0, 0, 0, 0]) +
+                socket.inet_pton(socket.AF_INET6, peer))
+
+    yield KsftNamedVariant("dstopts", socket.IPV6_DSTOPTS, lambda peer: padn)
+    yield KsftNamedVariant("hopopts", socket.IPV6_HOPOPTS, lambda peer: padn)
+    yield KsftNamedVariant("rthdr", socket.IPV6_RTHDR, srh)
+
+
+def _remote_seg6_enable(cfg):
+    """ Make the remote accept segment routing headers """
+    for conf in ("all", cfg.remote_ifname):
+        # slashes, so that sysctl doesn't split a dotted ifname
+        key = f"net/ipv6/conf/{conf}/seg6_enabled"
+        old = cmd(f"sysctl -n {key}", host=cfg.remote).stdout.strip()
+        cmd(f"sysctl -qw {key}=1", host=cfg.remote)
+        defer(cmd, f"sysctl -qw {key}={old}", host=cfg.remote)
+
+
+@ksft_variants(_ipv6_exthdr_variants())
+def data_send_ipv6_exthdr(cfg, opt, val):
+    """ Test PSP on IPv6 packets with an extension header """
+    cfg.require_ipver("6")
+    _init_psp_dev(cfg)
+    if opt == socket.IPV6_RTHDR:
+        _remote_seg6_enable(cfg)
+
+    s = _make_psp_conn(cfg, 0, "6")
+    try:
+        # In happy path, PSP traffic arrives at the remote decrypted as TCP
+        remote_udp = _remote_udp_from(cfg, s.getsockname()[0],
+                                      s.getpeername()[0])
+        if not remote_udp:
+            raise KsftSkipEx("can't count UDP on the remote")
+
+        rx_assoc = cfg.pspnl.rx_assoc({"version": 0,
+                                       "dev-id": cfg.psp_dev_id,
+                                       "sock-fd": s.fileno()})
+        tx = _spi_xchg(s, rx_assoc['rx-key'])
+        cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
+                            "version": 0,
+                            "tx-key": tx,
+                            "sock-fd": s.fileno()})
+        _check_data_outq(s, 0)
+
+        total = 0
+
+        def send(phase):
+            """ Sent encrypted, counted, and received. Nothing reaches the
+            peer as plain UDP.
+            """
+            nonlocal total
+            tx_pkts = _get_quiesced_stat(cfg, 'tx-packets')
+            udp = remote_udp()
+            total += _send_careful(cfg, s, 20)
+            for _ in range(100):
+                if _get_outq(s) == 0:
+                    break
+                time.sleep(0.5)
+            _check_data_outq(s, 0)
+            ksft_gt(_get_quiesced_stat(cfg, 'tx-packets'), tx_pkts,
+                    comment=phase)
+            ksft_eq(remote_udp(), udp, comment=f"{phase}: UDP at the remote")
+            _check_data_rx(cfg, total)
+
+        send("no option")
+        # UDP + PSP go after the extension header
+        s.setsockopt(socket.IPPROTO_IPV6, opt, val(s.getpeername()[0]))
+        send("with the option")
+        s.setsockopt(socket.IPPROTO_IPV6, opt, b'')
+        send("option removed")
+    finally:
+        _close_psp_conn(cfg, s)
+
+
 def _get_psp_ver_ip_variants():
     for ver in range(4):
         for ipv in ("4", "6"):
@@ -1019,7 +1149,8 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust]
+                cases = [data_basic_send, data_mss_adjust,
+                         data_send_ipv6_exthdr]
 
                 if has_cont:
                     cases += [
-- 
2.53.0-Meta

