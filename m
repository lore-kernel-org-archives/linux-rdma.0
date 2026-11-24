Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795482433;
	b=J2CO5pfozSxV4a7G7E2xdvaPV91KkoM80LXoqPlN9ClwomnVCeuj8I6m9jOWoeCLRREk
	 ww6zTPURlTvbe9OvcvwgFQ032xG5XwmkSmYQjHz/LjlVR1LaEjDWaBI+lOOtgynMiw5/m
	 emoYXbjNexUqMh+odvjjUVtwwZsr9Jbb1kLtV9f0NqylDf2IsOswHJ7A8TYeQRwX1rrLF
	 V8TdBVHoaQzdSBl72PnmJm4IUaFAU0K6MPLhWMafw4MBVgMuU9enGTlFpQloUIP34x72e
	 Me39G4xL1ZuOZzmKo37NTz7okywtBBST69z4g0z3Wccm48alSfsagElQj1B1JBvfqNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795482433;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=GaC+coiRxB+HJ68ZP4ImTvThBADzflMqQJW3Mj6rbrI=;
	b=E9f8Vt2RRHNEOYGDLdXIMuqeaLeNcRlUeYrybKF2xaD9C7c/NPhsW+8TqZggXZkr9A+i
	 tjZAc7O6p0Ly6rTPBDyaeFO+eCRUoF4zHtaaz0Ur329wDRUb9zVopsagoLsRHrzpriquY
	 jhWycJQyiNJZq2jFpgcbkpcQd3IzkM9GSdU2gGEeRmxQme4MMw2LDucx6fI3lmsOAvVze
	 L5QKkhUSnP4+9Eaebm3pOEcGmr/nLl4pYfNpg9OnaQe5FryiqyBQeAAmoRd/dar2Lio9L
	 momAFRYIGdThaUgeCK5+AzuCoPfnoR6wYTrIpXeX1FwHjXo86YthQWop3coTOZBRorg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=cJyG1S8P;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1937606A6A7;
	Tue, 24 Nov 2026 01:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1937606A6A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=cJyG1S8P
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJwPIb2407513;
	Mon, 23 Nov 2026 17:06:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=GaC+coiRxB+HJ68ZP4ImTvThBADzflMqQJW3M
	j6rbrI=; b=cJyG1S8PKenYrMD9JiWCifq0QZ8Bf1e6nWVbDdns1+Upsu9FNWIu1
	2MwBsxZoihU+UVuC62ygq+OdVhqGkh3ZtqikVCPSdh0KUNgiPZf1Kr/i02xLjQn2
	gTHO5CDnXW49PuOe2g0h47Wem+wFmOH4Xa07r7XaiQihVh8ssox77rneVvhS5K5i
	/9WXohcGwRa7wz19mXAuBMIO5fEIgRRaY1Y592+ugHphezqJerkIwAQpLki29bLw
	AFjofEGpial3q9JI+Zw+9hiIfRycqWK9xcGRWHdJlJrf52Dt3trjcjCpyzQUzQGP
	K3oBiEFVDXHzUHXv5YKVe9I5QNeEJsvrg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3a0awwja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 17:06:40 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 01:06:39 +0000
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
Subject: [PATCH net v7 8/9] selftests: drv-net: psp: test that ipv4 psp packets aren't fragmented
Date: Mon, 23 Nov 2026 17:06:00 -0800
Message-ID: <20261124010601.3995693-9-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: Lu8N98dBBE1NRny0gCncr_whVioksvaO
X-Proofpoint-GUID: Lu8N98dBBE1NRny0gCncr_whVioksvaO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfXzdb7+iRjcEj6
 rO1l2vs/kDujqAjTJgrTPkOxTiE6Erhm+JNAMPs+Igr8aB35UFdMbvnroly035MY2yE7qW8YLnv
 VF3gYXeBxniz2phq8tY5jYs1Kx1Zswk=
X-Authority-Analysis: v=2.4 cv=FeCiV5+6 c=1 sm=1 tr=0 ts=6b04e320 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=wpfVPzegXHpEFt3DAXn9:22 a=VabnemYjAAAA:8 a=ClODYU1lsHz8rMzznhwA:9
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAwNCBTYWx0ZWRfX2zFqfJ0PfS8B
 H8zHQZCqJmlCXLqzJrXZBa6kY3UrAGGW7f21SABeOugqJWOVnOQ7PP+p5Bn3N8kHrQNVF2IGk9T
 plJHZ3ZmTJI5u6o3VZBGdr+4Y2QA04yKMcs8YeBYtT5TuYABpNmpRYmvblqeBrFXDUNzN5U+Y19
 +xNJnamsDCkptiHAdQWHuGpH6swd6bhbJS2dBJywvd64LUTEp5mX40StmszZK3xoXoy7Hun/C4J
 XPO7/WHOflVbYPyV3W5bcSBXknV29Wvw8H0XspB8Z3wvc9jKTn2nQG1pF1Pej+OHFZm7sSOCkLk
 lXv42jNMyxU9yacUe2sVJYS8zUuy/u6TcGUAB5ilf7FJvAQ+FvE74i3vNwK8mwYhd5infqQgAFi
 PFr1yUUNC4aGzJXY1Ge84pKq++yNE5WUhM91fNbp+zeD28ORW43VfbFjoBbUcFzkFanaxR7uW4f
 WjdU6k6y6HD6gFzVZ5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

Make the IPv4 packets of a PSP TCP socket need fragmenting, and check
that they're dropped (IpFragFails) and not transmitted unencrypted.

TCP sizes its segments from the route MTU. With IP_PMTUDISC_OMIT, IP
fragments them to the device MTU, and doesn't set DF. So the test sets a
route MTU of twice the larger of the two device MTUs (at most 65535) on
both ends (the peer's MSS limits ours too), keeping the device and
source address of the current route, and IP_PMTUDISC_OMIT on the socket.
TCP MTU probing (tcp_mtu_probing 2, or 1 once a black hole is detected)
can cap the MSS at the probing base, so the test turns it off. If the
peer isn't on-link, or the socket's MSS doesn't need fragmenting, the
test is skipped.

A software filter on the peer counts, and drops, the IPv4 fragments
which reach it from the socket's address, and the test asserts there are
none. IpFragFails is per netns, so it only confirms that the packets
were dropped.

While both route MTUs are in place, a new ssh connection to the remote
over these addresses can stall: its segments are sized from the route
MTU, and sent with DF set. So the local route is added last, and removed
before the next remote command.

No IPv6 test: the stack only fragments IPv6 TCP packets when something
like IPVS sets ignore_df on them (see "net: don't fragment decrypted
skbs"), which this test doesn't set up.

Without the fix in "net: don't fragment decrypted skbs", the packets are
fragmented, and the fragments go out unencrypted. They reach the peer,
IpFragFails doesn't move, and the test fails.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/psp.py | 95 +++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index cae369d8ab63..9c1d4c59b1ac 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -22,10 +22,12 @@ from lib.py import KsftSkipEx, KsftFailEx, CmdExitFailure
 from lib.py import NetDrvEpEnv, NetDrvContEnv
 from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
 from lib.py import NetNSEnter
-from lib.py import bkg, rand_port, wait_port_listen
+from lib.py import bkg, ctl_file_write, rand_port, wait_port_listen
 from lib.py import ip, tc
 
 TCP_ULP = 31
+IP_MTU_DISCOVER = 10
+IP_PMTUDISC_OMIT = 5
 
 
 def _get_outq(s):
@@ -822,6 +824,97 @@ def data_send_ipv6_exthdr(cfg, opt, val):
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
+    # With MTU probing on, TCP can cap the MSS at the probing base, whatever
+    # the route MTU
+    ctl_file_write("/proc/sys/net/ipv4/tcp_mtu_probing", 0)
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
2.53.1-Meta

