Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482431;
	b=dM/P4mPQrtKshxCc409cdoaMGGQg366De95MzjS4fsKAk9+NpwHOexn92FMYuCcfdCMV
	 5FfsVDJiZoLlKQJs8IEvfcVBI4kXaJQKBNNLqXalIOpWFVPp1MXKbVpM3LByebBYNs2Ly
	 O1LyVazK074LJVnCjmOCeb8YdNQuU5BhcOrS8j7EtSEPwQ7g210DQbb4TQJZqVxKUGXlH
	 hUN5gbGeGjPnMjaNydEshPBDvxkBWHUdeqBYyEXC7zXhOhRy71nLZFWfxSDrEmzZ5BRu8
	 QbSM94o0xudgWEhFK7DZlNSgRii+sE57w0Mk4RMwzrQb8EezNb+BGbSdIMNwgE2IdYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482431;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version;
	bh=gr9FqtLLkrw661gEj4SofHLI5sIPTJucREmXXLp670A=;
	b=WaQHXP4t5r2C/KqEuB31jhxlUWelzAQjqAc/Uf/sten3V0gi/bb2G1pNc96mwzuMW8o2
	 3L1MSgUS9d9VKTg5NofPjVNQSYc4aFVXcEsnK4yCRvARaZj+8zSbKW1eP95TIeRi2hhmF
	 IOCNhz/9h8Kipjbuulk6zDDx4LBdngna9yuF0PvGGkcNX+zE3GEBGDtRIi4MV4kJ4c00i
	 CyNYNA1B0SWk7MFArqr7dWqocN5SLVRlNOjc55VdMDHz+/+3rSprCBFjSb8wBqO8TX/3Q
	 lRGpmkjVOxvyOlkT7/lJCcgIIFuFRRvcJyaE85rlHYTYsIKqzEKAwlrdePiud8rKdlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=K4n1ECLk;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6A9606A330;
	Tue, 24 Nov 2026 01:07:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA6A9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=K4n1ECLk
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwAFP520573;
	Mon, 23 Nov 2026 17:06:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=gr9FqtLLkrw661gEj4SofHLI5sIPTJucREmXX
	Lp670A=; b=K4n1ECLke/Zd4GjGhpGLPGnpzRDpxbOjCZ15UGRiTTQctA+u5K9Zt
	cP/Jtjc6TWCbyFvvZXxhvCBf926cAF5hm+uLyo8bPWm6nyoiJASqdwUcUJ5XuHRH
	LZexNyY55I7FeXaJiW3uofWZmqNQ98ojwzNMPHSeQAKM9hYqpXxifD4hcVMnTVN/
	efrpF0ClCP3gN0nhGGMnIolZTtWQI1o57t7sN3dxynHIBJfzVLm1aEPOMsOHq1rY
	GlMXUGNFWY5vA1b27qTDYiwSZrJfQBKQYDA8PPtUx5NJBzV3XbKLTpM40vTp2XD9
	17q+NqcRO1mzEeXX7aZnxpIf+yMUM5+5A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j37nse9tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:34 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:33 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        David Ahern
	<dsahern@kernel.org>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski
	<kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Mark Bloch
	<mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem
	<raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Sabrina
 Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v7 7/9] selftests: drv-net: psp: test ipv6 tcp socket with extension headers
Date: Mon, 23 Nov 2026 17:05:59 -0800
Message-ID: <20261124010601.3995693-8-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124010601.3995693-1-toddfreed@meta.com>
References: <20261124010601.3995693-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=b9gncdGx c=1 sm=1 tr=0 ts=6b04e31a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=855S8uPTkML1Oy45N9_h:22 a=VabnemYjAAAA:8 a=JE7m3MBIUUSpghwH1AUA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: pJrxOsBzoV0qFkzQxFSuUAoTetr8Zw1m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX9HbOsabK+WDY
 B04XXrU+ZzwkWbiVPHJtyhCQYl6dyFdHn8qpF8SLt+Q0Rd7eX1VPlSFyBSl8LcInaODDgM7ezrG
 DF5MWJKz2DLIBbh0m45YzM/k0EX3hM5dfxzN7eD//St23jsf2Q+myNKTumnsDINEBF/zATUrfBS
 J/u+Ec7KFQdNpWZGOrPkeVP1sZbYNgbRftIYBszFeXvsbnjUxOTQhQgamEisE8j+UcTLv3TsJOh
 52GIqb+R0Wuyrz21oFdszIiVGHh/AsXXo6jkCCSM09+kNxup4dsC9TLMniLaAXsqqfIJzf0jZ/R
 2hT4dta6WZWvSCXOBtoirj7E03FUJYXcSgPM6v//+GuYQcywPvdaCrHNiNEnTa4DYxOfe4FnkGi
 uAFOdHUsw9RPxm0IDvvq/Zg4w5BmsSEwZRuf510AUU9ChHtAOVb7dbK0wMs5WFsBcL2adm1J0DU
 Xbt9Egp4FubbQzYFsDA==
X-Proofpoint-GUID: pJrxOsBzoV0qFkzQxFSuUAoTetr8Zw1m
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX9pGvxXcXNsuZ
 eCrvwUqfAdJeN5abOpl1vOzV82Jm6nUMn7Lz8DxtZuF3TR9tV11uPK4Z8NYsiTvnHZ5H3VZs5R5
 JIQdIwF08FbwSd42HqJisWrWqrBJulY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

Send on a PSP TCP socket in three phases, checking the device's
tx-packets and what the peer received after each:

 1/ No socket options. The data is sent, counted, and received.

 2/ An extension header set on the socket. The packets are dropped,
    tx-packets is unchanged, and nothing reaches the peer. The data
    stays queued.

 3/ Option removed. The queued data, then new data, is sent, counted,
    and received.

The test has three variants: a destination options header
(IPV6_DSTOPTS) and a hop-by-hop options header (IPV6_HOPOPTS), each
holding one PadN option, and a segment routing header (IPV6_RTHDR).

A software filter on the peer also counts, and drops, UDP packets from
the socket's address to the peer's. PSP packets reach the peer as
decrypted TCP packets, as expected. Packets which were encapsulated but
are malformed or unencrypted (this is what mlx5 does) show up as UDP,
and the test asserts there are none. If the filter cannot be set up, the
test is skipped.

tx-packets is read after it has quiesced, because some devices refresh
counters periodically (mlx5 takes about a second).

Without the fix in "psp: don't encapsulate ipv6 packets with extension
headers", netdevsim encapsulates the packets in a malformed way and
counts them in tx-packets, and the test fails on that. With mlx5
(ConnectX-7), the packets go out unencrypted and aren't counted in
tx-packets. The test fails on the UDP packets which reach the peer.
Capturing on the peer:

  tcpdump -i <dev> -nn -A 'ip6 and src host <sender> and not tcp'

shows them as UDP, with the test's payload readable.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/config |   1 +
 tools/testing/selftests/drivers/net/psp.py | 150 ++++++++++++++++++++-
 2 files changed, 148 insertions(+), 3 deletions(-)

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
index c114d2245135..cae369d8ab63 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -18,12 +18,12 @@ from lib.py import ksft_run, ksft_exit, ksft_pr
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
+from lib.py import ip, tc
 
 TCP_ULP = 31
 
@@ -153,6 +153,58 @@ def _check_data_outq(s, exp_len, force_wait=False):
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
+def _remote_count(cfg, proto, match):
+    """
+    Count, and drop, the @proto packets matching flower @match which reach
+    the remote, with a software filter on its ingress (offloaded filter
+    counters are refreshed periodically). Dropping keeps such packets away
+    from the remote's stack. Returns a function reading the count, or None
+    if the filter can't be installed.
+    """
+    flt = (f"dev {cfg.remote_ifname} ingress protocol {proto} pref 1 "
+           f"handle 0x5053 flower")
+    try:
+        qdiscs = tc(f"qdisc show dev {cfg.remote_ifname}", json=True,
+                    host=cfg.remote)
+        # An ingress qdisc takes the filter as well as clsact
+        if not any(q['kind'] in ('clsact', 'ingress') for q in qdiscs):
+            tc(f"qdisc add dev {cfg.remote_ifname} clsact", host=cfg.remote)
+            defer(tc, f"qdisc del dev {cfg.remote_ifname} clsact",
+                  host=cfg.remote)
+        tc(f"filter add {flt} skip_hw {match} action drop", host=cfg.remote)
+    except CmdExitFailure as e:
+        ksft_pr(f"Can't install a filter on the remote: {e}")
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
@@ -679,6 +731,97 @@ def removal_device_bi(cfg):
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
+def _src_addr(dst):
+    """ The source address the kernel picks for @dst """
+    with socket.socket(socket.AF_INET6, socket.SOCK_DGRAM) as u:
+        u.connect((dst, 9))
+        return u.getsockname()[0]
+
+
+@ksft_variants(_ipv6_exthdr_variants())
+def data_send_ipv6_exthdr(cfg, opt, val):
+    """ Test that PSP drops IPv6 packets with an extension header """
+    cfg.require_ipver("6")
+    _init_psp_dev(cfg)
+
+    # Packets which were encapsulated but malformed or left unencrypted
+    # reach the remote as UDP. Set up the count before connecting, so a
+    # skip doesn't leave the responder mid key exchange.
+    peer = cfg.remote_addr_v["6"]
+    remote_udp = _remote_count(cfg, "ipv6", f"src_ip {_src_addr(peer)} "
+                               f"dst_ip {peer} ip_proto udp")
+    if not remote_udp:
+        raise KsftSkipEx("can't count UDP on the remote")
+
+    s = _make_psp_conn(cfg, 0, "6")
+    try:
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
+        def wait_outq_empty():
+            for _ in range(100):
+                if _get_outq(s) == 0:
+                    break
+                time.sleep(0.5)
+            _check_data_outq(s, 0)
+
+        # 1. No option: sent, counted, and received
+        tx_pkts = _get_quiesced_stat(cfg, 'tx-packets')
+        total = _send_careful(cfg, s, 20)
+        wait_outq_empty()
+        ksft_gt(_get_quiesced_stat(cfg, 'tx-packets'), tx_pkts)
+        _check_data_rx(cfg, total)
+
+        # 2. With the option: dropped, not counted, and nothing reaches the
+        # peer. The data stays queued.
+        s.setsockopt(socket.IPPROTO_IPV6, opt, val(peer))
+        tx_pkts = _get_quiesced_stat(cfg, 'tx-packets')
+        udp = remote_udp()
+        queued = _send_careful(cfg, s, 20)
+        _check_data_outq(s, queued, force_wait=True)
+        ksft_eq(_get_quiesced_stat(cfg, 'tx-packets'), tx_pkts)
+        ksft_eq(remote_udp(), udp, comment="UDP at the remote")
+        _check_data_rx(cfg, total)
+        total += queued
+
+        # 3. Option removed: the queued data, then new data, sent and
+        # received
+        tx_pkts = _get_quiesced_stat(cfg, 'tx-packets')
+        s.setsockopt(socket.IPPROTO_IPV6, opt, b'')
+        wait_outq_empty()
+        total += _send_careful(cfg, s, 20)
+        wait_outq_empty()
+        ksft_gt(_get_quiesced_stat(cfg, 'tx-packets'), tx_pkts)
+        _check_data_rx(cfg, total)
+    finally:
+        # With the option, the queued data, the FIN and the ACKs would be
+        # dropped, leaving an orphan holding the association
+        try:
+            s.setsockopt(socket.IPPROTO_IPV6, opt, b'')
+        finally:
+            _close_psp_conn(cfg, s)
+
+
 def _get_psp_ver_ip_variants():
     for ver in range(4):
         for ipv in ("4", "6"):
@@ -1195,7 +1338,8 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust]
+                cases = [data_basic_send, data_mss_adjust,
+                         data_send_ipv6_exthdr]
 
                 if has_cont:
                     cases += [
-- 
2.53.1-Meta

