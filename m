Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794356355;
	b=ZKMxkktgRybf0pNraliWXzRZPiEVIiundpla1BQzYmqjlO7x4PjqKON7SGIlVJEcg70d
	 3Szig/l6b7+OcsPyVkegSDYqL+hn2hlmqRIeEFl5CcEwjV15A4K5SRlOCTyPd4+Gi6uC7
	 qho87lfxHc9jYohImoeSutjzGS37ZbycIKGWmRPEpvCzEiD+anRkAqczmm/xSbB+cGcZ/
	 lE8YmBd+r5dOMzDz6XTkePeVGgPnl2oCxhg3MJ/2GgqikLTLClDja3xhwzvVC6yFqZ0yW
	 Q8RcVslvfUw0M3R/H4ghL1kAkj0nuB/WY6hnDsZ21WpIigoUrnarORGIUSFD5DwwgTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794356355;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=r7DyLtwHieaQd1pE/Ubra+bz4IU9bD03Im8a9wgjcYM=;
	b=RdIC/pBCOcAtvGt5ly2iL/4ovlJP2o8cVaohsUMETt+7cAa2VDzOvUYm+q/5evYYL558
	 RHWj4HsUgDA6JaTdZ2otvx2ZKsmhur2RrD/gm7kcmV9Ywo+MyGWILYa8AqbGhPY0AjEeb
	 MZdvudYawbkoluBiPxqKrxjvHVrOkBzx4jXntmRI5wsMtDD+dPg1VAg6bbLvv0rXAzClT
	 SmE/6KzSQpAHr6t9BqljpXOJ4biv/2uz9AmFR761XDs+XWzNddJLjjsTGuQu3GW4Gc/A0
	 ZnwQubmfMAx/P7uOwIOBxUkIUGijvhRHmd0O+9QJmY4Lwe63+iw3o2I/Kb2QP5aaikA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=V0DVI5uF;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A4360A5BCA;
	Wed, 11 Nov 2026 00:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4A4360A5BCA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=V0DVI5uF
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK1C82810117;
	Tue, 10 Nov 2026 16:19:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=r7DyLtwHieaQd1pE/Ubra+bz4IU9bD03Im8a9
	wgjcYM=; b=V0DVI5uFz4+pJYB9Ce2UZzHmuM2b47jTPgv12AGXjPegGCCUK4zOm
	uUtRPKnTW79TDvtE25lGn8hdzAEiSn0Hrxg6rQV00TgDyGgwofIwZaVo2imHpMO4
	nSzNnnfe+aL3tnanziR721CJBveGIYFuDcWHDnBh7TSjpmr4q6DnuKVOM3z3YQyg
	xdaPgh3e2WWigFYhAPUlMIt8v8CBvM5NUvqJBkriRxf6OthTSQi1c+n+tcsm4c85
	67IXm9jbMpaeklJ3XLGEJxGR0WIlMet4D1sPZ4dOMsW+1hHq3VfTEWpj1uc+Rt6y
	PKkpBHm8MCBqzENDf/uSxGHhRo6bxC2wQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk6bj-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:19:02 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:18:52 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
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
        "Sabrina
 Dubroca" <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v5 7/8] selftests: drv-net: psp: test that ipv4 psp packets aren't fragmented
Date: Tue, 10 Nov 2026 16:18:30 -0800
Message-ID: <20261111001831.3710881-8-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111001831.3710881-1-toddfreed@meta.com>
References: <20261111001831.3710881-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: uEU7G9n0kN_z9uUpYpCoJoWkR28QvIv7
X-Proofpoint-ORIG-GUID: uEU7G9n0kN_z9uUpYpCoJoWkR28QvIv7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX6O0ayd3EXnWS
 o9/wIp8zsvKa6alQpcFN3szFl9GROiFYcuXZVFXaLr0Q1px/7/rD41EmN7/jO9cVXHnlqOBvXQw
 cdL9dKdwlvwmPFj20dGtSFQ9hHYgROBwe05iDs6pevPM+3ZhN07vXVlST4YEKJ5V51eBZaQZNe6
 X+stO1qw6E2IchMBR+iSGlgkzs8fqqqe36v6hidlxil1dO2eC13drCZ5I1g/VaxIjonkYhq5XTB
 slbM9xGwBRX0tuoFX5lxGzJm7CGWyHogx53+l2JJ71U8EM2X7sREJ80JCFA4hNZHSPg3OWXTWvg
 nMebEiARXiYOOk6SlFRwUAIBfwnG+iMmYnH0p5Z32lAYgq5gtEnNd8qRCIkHScBP66eJWPxTg0Q
 MbbbslX2IthMowEByxMQYkwaihh0RPHDl+W9Mp2r2m6YmXlvdjPfT1SSeJE8iv8nOdMbWOjvSWJ
 aC3ezf7nvYhVNM29KZg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMCBTYWx0ZWRfX9bDyRL9ky/Qs
 a3CHcojeLyfaYB9fzePZPWj7OZiIj4Og+SAXrL9uWc+4xc7EfexS7vqeZoWFmrmuYlpwPIenF6f
 tk8sqAX2NCkNL0h2DPFLNWBdEAIfKlk=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b476 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=ClODYU1lsHz8rMzznhwA:9
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

make the ipv4 packets of a psp tcp socket need fragmenting, and check
that they're dropped (IpFragFails) and not transmitted unencrypted.

tcp sizes its segments from the route mtu. with IP_PMTUDISC_OMIT, ip
fragments them to the device mtu, and doesn't set df. so the test sets a
route mtu of twice the larger of the two device mtus (at most 65535) on
both ends (the peer's mss limits ours too), keeping the device and
source address of the current route, and IP_PMTUDISC_OMIT on the
socket. tcp mtu probing (tcp_mtu_probing 2) would cap the mss at the
probing base, so the test turns it off. if the peer isn't on-link, or
the socket's mss doesn't need fragmenting, the test is skipped.

a software filter on the peer counts, and drops, the ipv4 fragments
which reach it from the socket's address, and the test asserts there are
none. IpFragFails is per netns, so it only confirms that the packets
were dropped.

while both route mtus are in place, a new ssh connection to the remote
over these addresses can stall: its segments are sized from the route
mtu, and sent with df set. so the local route is added last, and removed
before the next remote command.

no ipv6 test: the stack only fragments ipv6 tcp packets when something
like ipvs sets ignore_df on them (see "net: don't fragment decrypted
skbs"), which this test doesn't set up.

without the fix in "net: don't fragment decrypted skbs", the packets are
fragmented, and the fragments go out unencrypted. they reach the peer,
IpFragFails doesn't move, and the test fails.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/psp.py | 101 +++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 7e251439a2fd..5dac62ad96b0 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -26,6 +26,8 @@ from lib.py import bkg, rand_port, wait_port_listen
 from lib.py import ip, tc
 
 TCP_ULP = 31
+IP_MTU_DISCOVER = 10
+IP_PMTUDISC_OMIT = 5
 
 
 def _get_outq(s):
@@ -799,6 +801,105 @@ def data_send_ipv6_exthdr(cfg, opt, val):
         _close_psp_conn(cfg, s)
 
 
+def _ipv4_snmp(key):
+    """ An Ip: counter of this netns, from /proc/net/snmp """
+    with open("/proc/net/snmp", encoding="utf-8") as f:
+        ip_lines = [line.split() for line in f if line.startswith("Ip:")]
+    return int(ip_lines[1][ip_lines[0].index(key)])
+
+
+def _ipv4_route_mtu(dst, mtu, host=None):
+    """ Add a route to @dst with @mtu, keeping the device and source of
+    the current one, which must be on-link. Returns the defer removing it.
+    """
+    route = ip(f"-4 route get {dst}", json=True, host=host)[0]
+    if route.get("gateway"):
+        raise KsftSkipEx(f"{dst} isn't on-link")
+    try:
+        ip(f"route add {dst}/32 dev {route['dev']} src {route['prefsrc']} "
+           f"mtu {mtu}", host=host)
+    except CmdExitFailure as e:
+        raise KsftSkipEx(f"can't set the route mtu to {dst}: {e}") from e
+    return defer(ip, f"route del {dst}/32 dev {route['dev']}", host=host)
+
+
+def data_send_ipv4_frags(cfg):
+    """ Test that IPv4 packets of a PSP TCP socket aren't fragmented """
+    cfg.require_ipver("4")
+    _init_psp_dev(cfg)
+
+    # Fragments which get out reach the remote. Set up the count before
+    # connecting, so a skip doesn't leave the responder mid key exchange.
+    # The socket's source is the one the kernel picks, which may not be
+    # LOCAL_V4, and the fragments would leave through the route's device
+    rem = cfg.remote_addr_v["4"]
+    route = ip(f"-4 route get {rem}", json=True)[0]
+    if route["dev"] != cfg.ifname:
+        raise KsftSkipEx(f"{rem} isn't routed through {cfg.ifname}")
+    loc = route["prefsrc"]
+    remote_frags = _remote_count(cfg, "ip",
+                                 f"src_ip {loc} dst_ip {rem} ip_flags frag")
+    if not remote_frags:
+        raise KsftSkipEx("can't count fragments on the remote")
+
+    # TCP sizes its segments from the route MTU. With IP_PMTUDISC_OMIT, IP
+    # fragments them to the device MTU. Set a route MTU above the device
+    # MTU on both ends, since the peer's MSS limits ours too. While both
+    # are in place, a new ssh connection to the remote over these addresses
+    # can stall, so add the local one last, and remove it first.
+    mtu = min(2 * max(cfg.dev['mtu'], cfg.remote_dev['mtu']), 65535)
+    _ipv4_route_mtu(loc, mtu, host=cfg.remote)
+    local_route = _ipv4_route_mtu(rem, mtu)
+
+    # With MTU probing on, TCP caps the MSS at the probing base, whatever
+    # the route MTU
+    probing_path = "/proc/sys/net/ipv4/tcp_mtu_probing"
+    with open(probing_path, encoding="utf-8") as fp:
+        probing = fp.read().strip()
+    if int(probing) > 1:
+        def set_probing(val):
+            with open(probing_path, "w", encoding="utf-8") as fp:
+                fp.write(val)
+        set_probing("0")
+        defer(set_probing, probing)
+
+    s = _make_psp_conn(cfg, 0, "4")
+    try:
+        rx_assoc = cfg.pspnl.rx_assoc({"version": 0,
+                                       "dev-id": cfg.psp_dev_id,
+                                       "sock-fd": s.fileno()})
+        tx = _spi_xchg(s, rx_assoc['rx-key'])
+        cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
+                            "version": 0,
+                            "tx-key": tx,
+                            "sock-fd": s.fileno()})
+        s.setsockopt(socket.IPPROTO_IP, IP_MTU_DISCOVER, IP_PMTUDISC_OMIT)
+        mss = s.getsockopt(socket.IPPROTO_TCP, socket.TCP_MAXSEG)
+        if mss + 40 <= cfg.dev['mtu']:
+            raise KsftSkipEx(f"mss {mss} needs no fragmenting")
+
+        fails = _ipv4_snmp("FragFails")
+        # The packets are dropped, so the send may not complete (with a
+        # jumbo device MTU, the socket buffer can take all of it)
+        s.settimeout(3)
+        try:
+            s.sendall(b'f' * 200000)
+        except socket.timeout:
+            pass
+        fails = _ipv4_snmp("FragFails") - fails
+
+        # Before the next ssh to the remote, see above
+        local_route.exec()
+
+        # Fragments would go out unencrypted: the packets must be dropped
+        # instead of fragmented. FragFails is per netns, so it only
+        # confirms the drop: the remote count is what decides.
+        ksft_eq(remote_frags(), 0, comment="fragments reached the remote")
+        ksft_gt(fails, 0, comment="packets dropped instead of fragmented")
+    finally:
+        _close_psp_conn(cfg, s)
+
+
 def _get_psp_ver_ip_variants():
     for ver in range(4):
         for ipv in ("4", "6"):
-- 
2.53.0-Meta

