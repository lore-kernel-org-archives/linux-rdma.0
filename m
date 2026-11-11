Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358610;
	b=rAi2Si969NuTVMVyCalqKgXOBmtbwqmRDU2RYvhh2lR0P47/Jc9e63Ttra0x8bTbkyaZ
	 Q6tfoD821AWimjgvgH9jzqDmkadhEZzXZe4x1mfSNL2Y9/043AtoT9TwvysvZkEQPmaFu
	 Y8LUGHIGcJb3WLhZQT2bfNX7e8T1YBej3r7lyF+ANd77V9MWHifOqXOoLinvFZyZVu598
	 /rp6hoMgdoCKFCyX4PvCDHW0Vuh4sQxR/XQHrNYnxtwmnkHr6oFbqxbsGUSRiKBxT7Pay
	 fpCxUIWVTl9C4jK28FGNC1D3irF+DDVbKQyLKBamM9r+kC3HOdVqOxbrBxgHunj5cZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358610;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=ixCLq/sUcCKV5YxY4Ax9irrgeHRY31D7dBovl/B327Y=;
	b=Qqpa2ykaIu0MgisdGG9jXwdlOpcGMqfr1duAnJzXSNTbQP6HCQKHRvwKYD2bqsqq6TIe
	 oqkfwdMbjK/V7Fkn7bp0zIvgIKMaEjg+fTeGrosFdEfe4sbxnPyVK3tmWep56Sms7ny8f
	 gMpXFIryaY+CsebnjgT8d9QLhcjxFWv2kVKvGjiAj/bW+lu3wlyNGRWx2G/2AD75bQbZt
	 Gy6wrniBvB6EYpp6wJM6BsM9IV0AUYJYAlGog9ZQOC/GMnAqWR3afb1vDL0pH0EXOlk7V
	 WLFOlz7GyZ3dfd0CM61RZXVIzkyCxoAx1IrsWNmIb9x56tbGqDc5CrauDXKoViHiSSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=gU5rhyDP;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A27D606AA04;
	Wed, 11 Nov 2026 00:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A27D606AA04
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=gU5rhyDP
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WNhX3063874;
	Tue, 10 Nov 2026 16:56:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=ixCLq/sUcCKV5YxY4Ax9irrgeHRY31D7dBovl
	/B327Y=; b=gU5rhyDPrnqJ/hqAoOFnl8BBYtpxgE0OYtz8XNDT3fAp4jAOoWrzO
	ubuhFCkdpQ6QTsGTE2tyAwA9DRHBfOYX7u6Visuef371i5wtf3jPzYU0pDA4kkxF
	/mzZ0CFk5+vU0UB/eSkSwTFBYF4oeTtCL7/7cXfDp1JBu7m9qC873YZOFu23IuO1
	hONZhWZyItiSrnmKWwSCV7i9qbEOWOLcSXzjazLnU7xBDRu0OwsjChJFVrhfwamC
	a8cpyJhZWvLVDm5shR6axoAtEYDZnVctGW9A7+DR9nXu4PKRNTNjdxZbiRW0fPyv
	iwQJudShUAlExjdRcXnbYsqWjiTL0fC0w==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4huqrpspky-19
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:16 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:10 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netdev@vger.kernel.org>, <toddfreed@meta.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn
	<andrew+netdev@lunn.ch>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <bpf@vger.kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter
	<donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko
	<jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>,
        "Martin
 KaFai Lau" <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v1 11/15] selftests: drv-net: psp: test socket-less associations and the tc psp action
Date: Tue, 10 Nov 2026 16:55:29 -0800
Message-ID: <20261111005533.6436-12-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111005533.6436-1-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
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
X-Authority-Analysis: v=2.4 cv=PapqFShd c=1 sm=1 tr=0 ts=6af3bd30 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=nJhrvKaXXhYoOGMhGe8A:9
 a=44ujZIcIfs4hl6B_:21 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: lHEd9NKhhyVGyd8yKzljbaeINtggrHDH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX9tZhGMU1yE7f
 fQecmkBxz7z/DFGb+aWCca93SBHne5I4h6i2/bayFv6E1VHcUh/N2BQpxnz1OKbKeJGklpGoBxn
 WIjgpgzwN5UspQZWug+q/WLBO965BxE=
X-Proofpoint-ORIG-GUID: lHEd9NKhhyVGyd8yKzljbaeINtggrHDH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX0uTg9A+WD0mK
 S2I/hqlVK3sk3x5zYRQ2UlrV9WvyG9AcjbmTfguP+WeoRpSFJYVspNRseFSK1+hps9WabzDkW2W
 NyJY+M1oWr5wEEy7y7HsAbYjcWbTn4AO3Oy5qNBrNhaAx4uz6gfqc6dfetKl0b7CWKJ471owD4b
 o9nP/kMxa1Y/Qw7bpUgiIj+g7GApEsCIy2Q3Sy+DaJn6yE3DasyaLf57EfAGKK0nwp8YRs3B/Xa
 bD3GvF/Dpos1pPghyRpZAd09oylr44Scgv/N9rEEuelbywiqLavQb8+K1vljljC/xdcCi+uskUG
 GwQRAC3sJi6Puf8xBlVx1DQM180AjoI7NSrHZ7h0JAUO0w0kiLDvNc/d7SaQrsjMuhovowRZdHF
 6jhOQeJFNJN/yDMLj7hF1Eayy9oU286Vo0k1oHSt1R4IZAlg51xPtrcfPmd96qR0pqriAYu0urS
 3If3bzvQqgx38eKtkmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

Cover the socket-less association commands and the tc psp action.

The data path tests connect a plain local TCP socket to a PSP socket of
the responder, and give the local side PSP with tc and socket-less
associations: on ingress, flower psp_spi, psp_ver and psp_dev match what
was decrypted with the local Rx SPI, and psp decap removes its PSP
state; on egress, psp encap attaches the Tx association to the socket's
packets, which the device encrypts.

Test cases,

  assoc_sockless_basic     rx-spi-alloc / assoc-add / get / dump / del,
                           only the SPI is ever reported
  assoc_sockless_stale     key rotation marks socket-less Rx assocs
                           stale, and not Tx ones
  assoc_sockless_bad       bad device, key size, missing key
  assoc_sockless_tc        encap only takes a Tx association, decap none
  data_tc_basic_send       data to the responder and its acks back, for
                           each PSP version and IP version
  data_tc_no_decap         decrypted packets don't reach a plain socket
  data_tc_assoc_del        associations deleted while tc uses them,
                           encap holding its Tx one
  data_tc_decap_match      decap only takes the packets of the filter's
                           SPI, version and device
  data_tc_encap_wrong_dev  packets redirected to another device drop
  data_tc_encap_short_hdr  an IPv4 packet shorter than its header
                           length is dropped by encap
  data_tc_encap_too_big    packets which won't fit the MTU once
                           encapsulated are dropped, with and without GSO
  data_tc_encap_psp_sock   packets of a PSP socket, which are marked
                           decrypted, are dropped by psp encap action
  data_tc_encap_ingress    packets with an assoc aren't redirected from
                           egress to ingress
  removal_device_tc        PSP device removed while tc holds associations

Note that the tc tests require a newer tc, which has support for the psp
action and the flower psp matches. If it's detected that tc is missing
that support, the tc tests simply skip.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/config |   3 +
 tools/testing/selftests/drivers/net/psp.py | 593 ++++++++++++++++++++-
 2 files changed, 593 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/config b/tools/testing/selftests/drivers/net/config
index 4838adf27fa1..baf1c9d0dd13 100644
--- a/tools/testing/selftests/drivers/net/config
+++ b/tools/testing/selftests/drivers/net/config
@@ -1,9 +1,12 @@
 CONFIG_CONFIGFS_FS=y
 CONFIG_DEBUG_INFO_BTF=y
 CONFIG_DEBUG_INFO_BTF_MODULES=n
+CONFIG_DUMMY=m
 CONFIG_INET_PSP=y
 CONFIG_IPV6=y
 CONFIG_MACSEC=m
+CONFIG_NET_ACT_MIRRED=m
+CONFIG_NET_ACT_PSP=m
 CONFIG_NET_ACT_SKBEDIT=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_CLS_BPF=y
diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index 473500901879..fb7544410051 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -15,7 +15,8 @@ from contextlib import contextmanager
 
 from lib.py import defer
 from lib.py import ksft_run, ksft_exit, ksft_pr
-from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
+from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_ge
+from lib.py import ksft_raises
 from lib.py import ksft_not_none
 from lib.py import ksft_variants, KsftNamedVariant
 from lib.py import KsftSkipEx, KsftFailEx
@@ -23,9 +24,10 @@ from lib.py import NetDrvEpEnv, NetDrvContEnv
 from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
 from lib.py import NetNSEnter
 from lib.py import bkg, rand_port, wait_port_listen
-from lib.py import ip
+from lib.py import cmd, ip, tc
 
 TCP_ULP = 31
+UDP_SEGMENT = 103
 
 
 def _get_outq(s):
@@ -683,6 +685,591 @@ def data_mss_adjust(cfg, ipver):
     _data_mss_adjust(cfg, ipver)
 
 
+#
+# Socket-less associations and the tc psp action
+#
+
+def _assoc_del(cfg, assoc_id):
+    """ Delete a socket-less assoc, unless the test already did """
+    try:
+        cfg.pspnl.assoc_del({"id": assoc_id})
+    except NlError as e:
+        if e.nl_msg.error != -errno.ENOENT:
+            raise
+
+
+def _sockless_assocs(cfg, version=0):
+    """ Allocate an Rx SPI and add a Tx assoc with its key """
+    rx = cfg.pspnl.rx_spi_alloc({"dev-id": cfg.psp_dev_id,
+                                 "version": version})
+    defer(_assoc_del, cfg, rx['id'])
+    tx = cfg.pspnl.assoc_add({"dev-id": cfg.psp_dev_id,
+                              "version": version,
+                              "tx-key": rx['rx-key']})
+    defer(_assoc_del, cfg, tx['id'])
+    return rx, tx
+
+
+def _require_tc_psp(cfg):
+    if not hasattr(cfg, 'tc_psp'):
+        # tc exits with an error either way, look at what it says. The
+        # tests need both the psp action and the flower psp keys.
+        try:
+            act = cmd("tc action add action psp help", fail=False)
+            flt = cmd("tc filter add dev lo ingress flower help",
+                      fail=False)
+        except FileNotFoundError:
+            cfg.tc_psp = False
+        else:
+            cfg.tc_psp = ("psp encap" in act.stdout + act.stderr and
+                          "psp_spi" in flt.stdout + flt.stderr)
+    if not cfg.tc_psp:
+        raise KsftSkipEx("tc does not support the psp action and matches")
+
+
+def _require_psp_version(cfg, version):
+    name = cfg.pspnl.consts["version"].entries_by_val[version].name
+    if name not in cfg.psp_info['psp-versions-cap']:
+        raise KsftSkipEx("PSP version not supported", name)
+
+
+def _tc_proto(ipver):
+    return "ip" if ipver == "4" else "ipv6"
+
+
+def _tc_clsact(ifname, host=None):
+    """ Add clsact to @ifname, unless it has one already: the env or the
+    host may use it too, so only remove it if it was added here
+    """
+    qdiscs = tc(f"qdisc show dev {ifname}", json=True, host=host)
+    if any(q['kind'] == 'clsact' for q in qdiscs):
+        return
+    tc(f"qdisc add dev {ifname} clsact", host=host)
+    defer(tc, f"qdisc del dev {ifname} clsact", host=host)
+
+
+def _make_tc_conn(cfg, version, ipver):
+    """ Connect a plain socket to a PSP socket of the responder """
+    _send_with_ack(cfg, b'conn psp\0' + struct.pack('BB', version, version))
+    family = socket.AF_INET if ipver == "4" else socket.AF_INET6
+    s = socket.socket(family, socket.SOCK_STREAM)
+    # The stack doesn't know tc will add PSP headers (40 bytes), leave room
+    # for them. TCP takes its options off the MSS.
+    mtu = ip(f"link show dev {cfg.ifname}", json=True)[0]['mtu']
+    iph = 20 if ipver == "4" else 40
+    s.setsockopt(socket.IPPROTO_TCP, socket.TCP_MAXSEG,
+                 mtu - 40 - iph - 20)
+    s.connect((cfg.remote_addr_v[ipver], cfg.comm_port))
+    defer(_tc_conn_close, cfg, s)
+    return s
+
+
+def _tc_conn_close(cfg, s):
+    """ Close a test's connection, unless the test got to do it """
+    if s.fileno() != -1:
+        _close_psp_conn(cfg, s)
+
+
+def _tc_psp_conn(cfg, version, ipver, decap=True):
+    """
+    Connect a plain socket to a PSP socket of the responder, and give that
+    flow PSP encap using socket-less assocs and tc: decap what was decrypted
+    with its Rx SPI, version and device on ingress, encap its packets on
+    egress, which the device encrypts. Returns the socket and the assocs.
+    """
+    proto = _tc_proto(ipver)
+
+    # The Rx SPI and the decap rule first: once connected, the responder
+    # waits for our key, and an error in between would leave the comm
+    # channel out of step
+    rx = cfg.pspnl.rx_spi_alloc({"dev-id": cfg.psp_dev_id,
+                                 "version": version})
+    defer(_assoc_del, cfg, rx['id'])
+
+    _tc_clsact(cfg.ifname)
+    # The responder starts sending with our SPI as soon as it has our key
+    if decap:
+        tc(f"filter add dev {cfg.ifname} ingress pref 10 handle 1 "
+           f"protocol {proto} flower psp_spi {rx['rx-key']['spi']:#x} "
+           f"psp_ver {version} psp_dev {cfg.psp_dev_id} action psp decap")
+        defer(tc, f"filter del dev {cfg.ifname} ingress pref 10 handle 1 "
+              f"protocol {proto} flower")
+
+    s = _make_tc_conn(cfg, version, ipver)
+    tx_key = _spi_xchg(s, rx['rx-key'])
+    tx = cfg.pspnl.assoc_add({"dev-id": cfg.psp_dev_id,
+                              "version": version,
+                              "tx-key": tx_key})
+    defer(_assoc_del, cfg, tx['id'])
+
+    # Make sure the SPI exchange got through in clear text
+    _check_data_outq(s, 0)
+
+    # The comm socket goes to the same port, match on ours
+    sport = s.getsockname()[1]
+    tc(f"filter add dev {cfg.ifname} egress pref 10 handle 1 "
+       f"protocol {proto} flower ip_proto tcp src_port {sport} "
+       f"action psp encap assoc {tx['id']}")
+    defer(tc, f"filter del dev {cfg.ifname} egress pref 10 handle 1 "
+          f"protocol {proto} flower")
+
+    return s, rx, tx
+
+
+def _tc_action_stats(cfg, direction):
+    """ Stats of the psp action of the pref 10 filter """
+    filters = tc(f"-s filter show dev {cfg.ifname} {direction} pref 10",
+                 json=True)
+    for flt in filters:
+        for act in flt.get("options", {}).get("actions", []):
+            if act["kind"] == "psp":
+                return act["stats"]
+    raise KsftFailEx(f"no psp action on {direction}")
+
+
+def _wait_data_outq(s, exp_len, timeout=5):
+    """ Like _check_data_outq() but leave time for retransmits """
+    outq = 0
+    end = time.monotonic() + timeout
+    while time.monotonic() < end:
+        outq = _get_outq(s)
+        if outq == exp_len:
+            break
+        time.sleep(0.05)
+    ksft_eq(outq, exp_len)
+
+
+def assoc_sockless_basic(cfg):
+    """ Test socket-less associations """
+    _init_psp_dev(cfg)
+
+    rx, tx = _sockless_assocs(cfg)
+    ksft_eq(rx['dev-id'], cfg.psp_dev_id)
+    ksft_gt(rx['rx-key']['spi'], 0)
+    ksft_eq(len(rx['rx-key']['key']), 16)
+    ksft_eq(tx['dev-id'], cfg.psp_dev_id)
+    ksft_ne(tx['id'], rx['id'])
+
+    # Only the SPI is ever reported, never the key
+    version = cfg.pspnl.consts["version"].entries_by_val[0].name
+    spi = {'spi': rx['rx-key']['spi']}
+    assoc = cfg.pspnl.assoc_get({"id": rx['id']})
+    ksft_eq(assoc['dev-id'], cfg.psp_dev_id)
+    ksft_eq(assoc['version'], version)
+    ksft_eq(assoc['rx-key'], spi)
+    ksft_true('tx-key' not in assoc)
+    assoc = cfg.pspnl.assoc_get({"id": tx['id']})
+    ksft_eq(assoc['dev-id'], cfg.psp_dev_id)
+    ksft_eq(assoc['version'], version)
+    ksft_eq(assoc['tx-key'], spi)
+    ksft_true('rx-key' not in assoc)
+
+    ids = [x['id'] for x in cfg.pspnl.assoc_get({}, dump=True)]
+    ksft_true(rx['id'] in ids)
+    ksft_true(tx['id'] in ids)
+
+    for assoc_id in (rx['id'], tx['id']):
+        cfg.pspnl.assoc_del({"id": assoc_id})
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.assoc_get({"id": assoc_id})
+        ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.assoc_del({"id": assoc_id})
+        ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+
+
+def assoc_sockless_stale(cfg):
+    """ Test key rotation marks socket-less Rx assocs stale """
+    _init_psp_dev(cfg)
+
+    rx, tx = _sockless_assocs(cfg)
+    for assoc_id in (rx['id'], tx['id']):
+        ksft_true('stale' not in cfg.pspnl.assoc_get({"id": assoc_id}))
+    # The second rotation retires the device key they were created under
+    for i in range(2):
+        cfg.pspnl.key_rotate({"id": cfg.psp_dev_id})
+        stale = 'stale' in cfg.pspnl.assoc_get({"id": rx['id']})
+        ksft_eq(stale, i == 1, comment=f"rotation {i + 1}")
+    # A Tx assoc holds the peer's key, which the device key rotation
+    # doesn't affect
+    ksft_true('stale' not in cfg.pspnl.assoc_get({"id": tx['id']}))
+
+
+def assoc_sockless_bad(cfg):
+    """ Test socket-less associations with bad arguments """
+    _init_psp_dev(cfg)
+
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.rx_spi_alloc({"dev-id": cfg.psp_dev_id + 1234567,
+                                "version": 0})
+    ksft_eq(cm.exception.nl_msg.error, -errno.ENODEV)
+
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_add({"dev-id": cfg.psp_dev_id + 1234567,
+                             "version": 0,
+                             "tx-key": {"spi": 1, "key": b'\0' * 16}})
+    ksft_eq(cm.exception.nl_msg.error, -errno.ENODEV)
+
+    # Key of the wrong size for the version
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_add({"dev-id": cfg.psp_dev_id,
+                             "version": 0,
+                             "tx-key": {"spi": 1, "key": b'\0' * 32}})
+    ksft_eq(cm.exception.nl_msg.error, -errno.EINVAL)
+
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_add({"dev-id": cfg.psp_dev_id, "version": 0})
+    ksft_eq(cm.exception.nl_msg.error, -errno.EINVAL)
+
+
+def assoc_sockless_tc(cfg):
+    """ Test the tc psp action takes the right kind of assoc """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    rx, tx = _sockless_assocs(cfg)
+    unknown = max(x['id'] for x in cfg.pspnl.assoc_get({}, dump=True)) + 1
+
+    # encap takes a Tx assoc, decap none
+    for act in (f"encap assoc {unknown}", f"encap assoc {rx['id']}",
+                f"decap assoc {rx['id']}", f"decap assoc {tx['id']}"):
+        ret = cmd(f"tc action add action psp {act}", fail=False)
+        ksft_ne(ret.ret, 0, comment=act)
+
+    for act in (f"encap assoc {tx['id']}", "decap"):
+        tc(f"action add action psp {act} index 100")
+        defer(tc, "action del action psp index 100").exec()
+
+
+@ksft_variants(_get_psp_ver_ip_variants())
+def data_tc_basic_send(cfg, version, ipver):
+    """ Test data send with socket-less assocs and the tc psp action """
+    cfg.require_ipver(ipver)
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+    if version:
+        _require_psp_version(cfg, version)
+
+    rx_pkts = _get_stat(cfg, 'rx-packets')
+    tx_pkts = _get_stat(cfg, 'tx-packets')
+
+    s, _, _ = _tc_psp_conn(cfg, version, ipver)
+
+    data_len = _send_careful(cfg, s, 100)
+    _check_data_rx(cfg, data_len)
+    # ... and the ACKs got through decap
+    _check_data_outq(s, 0)
+
+    ksft_gt(_get_stat(cfg, 'rx-packets'), rx_pkts)
+    ksft_gt(_get_stat(cfg, 'tx-packets'), tx_pkts)
+    ksft_gt(_tc_action_stats(cfg, "ingress")["packets"], 0)
+    ksft_gt(_tc_action_stats(cfg, "egress")["packets"], 0)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_no_decap(cfg):
+    """ Test decrypted packets don't reach a plain socket without decap """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    s, _, _ = _tc_psp_conn(cfg, 0, cfg.addr_ipver, decap=False)
+
+    # Without ACKs we can't send more than the initial window
+    data_len = _send_careful(cfg, s, 1)
+    _check_data_rx(cfg, data_len)
+    # The responder's ACKs come encrypted, and get dropped
+    _check_data_outq(s, data_len, force_wait=True)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_assoc_del(cfg):
+    """ Test deleting assocs while tc uses them: encap holds its Tx one """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    s, rx, tx = _tc_psp_conn(cfg, 0, cfg.addr_ipver)
+
+    data_len = _send_careful(cfg, s, 10)
+    _check_data_rx(cfg, data_len)
+
+    cfg.pspnl.assoc_del({"id": rx['id']})
+    cfg.pspnl.assoc_del({"id": tx['id']})
+
+    data_len += _send_careful(cfg, s, 10)
+    _check_data_rx(cfg, data_len)
+    _check_data_outq(s, 0)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_decap_match(cfg):
+    """ Test decap only takes what the filter's PSP matches allow """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    ipver = cfg.addr_ipver
+    s, rx, _ = _tc_psp_conn(cfg, 0, ipver)
+    spi, dev = rx['rx-key']['spi'], cfg.psp_dev_id
+
+    def match(m_spi, m_ver, m_dev):
+        return f"psp_spi {m_spi:#x} psp_ver {m_ver} psp_dev {m_dev}"
+
+    data_len = _send_careful(cfg, s, 10)
+    _check_data_rx(cfg, data_len)
+    _check_data_outq(s, 0)
+
+    # flower can only replace a filter with one matching the same keys
+    def decap_filter(keys):
+        tc(f"filter replace dev {cfg.ifname} ingress pref 10 handle 1 "
+           f"protocol {_tc_proto(ipver)} flower {keys} action psp decap")
+
+    for keys in (match(spi ^ 1, 0, dev), match(spi, 1, dev),
+                 match(spi, 0, dev + 1)):
+        # The responder's ACKs don't match, and the socket drops them
+        decap_filter(keys)
+        n = _send_careful(cfg, s, 1)
+        data_len += n
+        _check_data_rx(cfg, data_len)
+        _check_data_outq(s, n, force_wait=True)
+
+        # Once they match again, the retransmits get through
+        decap_filter(match(spi, 0, dev))
+        _wait_data_outq(s, 0)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_encap_wrong_dev(cfg):
+    """ Test packets with an assoc sent to another device are dropped """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    ip("link add psp-dummy0 type dummy")
+    defer(ip, "link del psp-dummy0")
+    ip("link set psp-dummy0 up")
+
+    ipver = cfg.addr_ipver
+    s, _, tx = _tc_psp_conn(cfg, 0, ipver)
+
+    sport = s.getsockname()[1]
+    tc(f"filter replace dev {cfg.ifname} egress pref 10 handle 1 "
+       f"protocol {_tc_proto(ipver)} flower ip_proto tcp src_port {sport} "
+       f"action psp encap assoc {tx['id']} pipe "
+       f"action mirred egress redirect dev psp-dummy0")
+
+    def dummy_drops():
+        dev = ip("-s link show dev psp-dummy0", json=True)[0]
+        return dev['stats64']['tx']['dropped']
+
+    drops = dummy_drops()
+    data_len = _send_careful(cfg, s, 10)
+    _check_data_outq(s, data_len, force_wait=True)
+    _check_data_rx(cfg, 0)
+    ksft_gt(dummy_drops(), drops)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_encap_short_hdr(cfg):
+    """ Test encap drops an IPv4 packet shorter than its header length """
+    cfg.require_ipver("4")
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    _, tx = _sockless_assocs(cfg)
+    loc, rem = cfg.addr_v["4"], cfg.remote_addr_v["4"]
+    _tc_clsact(cfg.ifname)
+    # An IP protocol nothing else sends, so the filter only takes the
+    # test's frame
+    tc(f"filter add dev {cfg.ifname} egress pref 10 handle 1 protocol ip "
+       f"flower ip_proto 0xfd dst_ip {rem} "
+       f"action psp encap assoc {tx['id']}")
+    defer(tc, f"filter del dev {cfg.ifname} egress pref 10 handle 1 "
+          f"protocol ip flower")
+
+    # A 20 byte IPv4 header which claims 60 (ihl 15), and nothing after
+    # it. Encap must not take the 40 missing bytes for header. (Its total
+    # length check would drop it too: this covers the IPv4 length checks
+    # together.)
+    iph = struct.pack("!BBHHHBBH4s4s", 0x4f, 0, 60, 0, 0, 64, 253, 0,
+                      socket.inet_aton(loc), socket.inet_aton(rem))
+    eth = (b"\xff" * 6 + bytes.fromhex(cfg.dev["address"].replace(":", "")) +
+           struct.pack("!H", 0x0800))
+
+    drops = _tc_action_stats(cfg, "egress")["drops"]
+    with socket.socket(socket.AF_PACKET, socket.SOCK_RAW) as ps:
+        ps.bind((cfg.ifname, 0x0800))
+        try:
+            ps.send(eth + iph)
+        except OSError as e:
+            # The drop on egress is reported to the sender
+            if e.errno != errno.ENOBUFS:
+                raise
+    ksft_eq(_tc_action_stats(cfg, "egress")["drops"], drops + 1,
+            comment="short IPv4 header dropped by encap")
+
+
+def data_tc_encap_too_big(cfg):
+    """ Test packets too big for the MTU once encapsulated are dropped """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    ipver = cfg.addr_ipver
+    _, tx = _sockless_assocs(cfg)
+    port = rand_port(socket.SOCK_DGRAM)
+    _tc_clsact(cfg.ifname)
+    tc(f"filter add dev {cfg.ifname} egress pref 10 handle 1 "
+       f"protocol {_tc_proto(ipver)} flower ip_proto udp dst_port {port} "
+       f"action psp encap assoc {tx['id']}")
+    defer(tc, f"filter del dev {cfg.ifname} egress pref 10 handle 1 "
+          f"protocol {_tc_proto(ipver)} flower")
+
+    # The UDP payload which fits the MTU once the device adds UDP, the PSP
+    # header and the ICV (40 bytes)
+    mtu = ip(f"link show dev {cfg.ifname}", json=True)[0]['mtu']
+    room = mtu - 40 - (20 if ipver == "4" else 40) - 8
+
+    family = socket.AF_INET if ipver == "4" else socket.AF_INET6
+    dst = (cfg.remote_addr_v[ipver], port)
+    with socket.socket(family, socket.SOCK_DGRAM) as s:
+        s.sendto(b'x' * room, dst)
+        with ksft_raises(OSError) as cm:
+            s.sendto(b'x' * (room + 1), dst)
+        ksft_eq(cm.exception.errno, errno.EMSGSIZE)
+
+        # GSO (UDP_SEGMENT): each segment must fit
+        s.setsockopt(socket.IPPROTO_UDP, UDP_SEGMENT, room)
+        s.sendto(b'x' * room * 2, dst)
+        s.setsockopt(socket.IPPROTO_UDP, UDP_SEGMENT, room + 1)
+        with ksft_raises(OSError) as cm:
+            s.sendto(b'x' * (room + 1) * 2, dst)
+        ksft_eq(cm.exception.errno, errno.EMSGSIZE)
+    ksft_ge(_tc_action_stats(cfg, "egress")["packets"], 4)
+
+
+def data_tc_encap_psp_sock(cfg):
+    """
+    Test psp encap drops packets of a PSP socket, which already have a crypto
+    offload
+    """
+
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    s = _make_psp_conn(cfg)
+    defer(_tc_conn_close, cfg, s)
+    rx = cfg.pspnl.rx_assoc({"version": 0,
+                             "dev-id": cfg.psp_dev_id,
+                             "sock-fd": s.fileno()})['rx-key']
+    tx = _spi_xchg(s, rx)
+    cfg.pspnl.tx_assoc({"dev-id": cfg.psp_dev_id,
+                        "version": 0,
+                        "tx-key": tx,
+                        "sock-fd": s.fileno()})
+    data_len = _send_careful(cfg, s, 10)
+    _check_data_rx(cfg, data_len)
+
+    _, sl_tx = _sockless_assocs(cfg)
+    _tc_clsact(cfg.ifname)
+    sport = s.getsockname()[1]
+    tc(f"filter add dev {cfg.ifname} egress pref 10 handle 1 "
+       f"protocol {_tc_proto(cfg.addr_ipver)} flower ip_proto tcp "
+       f"src_port {sport} action psp encap assoc {sl_tx['id']}")
+    flt = defer(tc, f"filter del dev {cfg.ifname} egress pref 10 handle 1 "
+                f"protocol {_tc_proto(cfg.addr_ipver)} flower")
+
+    n = _send_careful(cfg, s, 1)
+    _check_data_outq(s, n, force_wait=True)
+    _check_data_rx(cfg, data_len)
+    ksft_gt(_tc_action_stats(cfg, "egress")["drops"], 0)
+
+    # Without the rule, the retransmits get through
+    flt.exec()
+    _wait_data_outq(s, 0)
+    _check_data_rx(cfg, data_len + n)
+    _close_psp_conn(cfg, s)
+
+
+def data_tc_encap_ingress(cfg):
+    """ Test packets with an assoc aren't redirected to ingress """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    _, tx = _sockless_assocs(cfg)
+    # Traffic to a local address leaves through lo, and comes back on its
+    # ingress. With the dst gone, input routing takes a loopback source for
+    # a martian, and needs accept_local for a local one.
+    sysctl = "net.ipv4.conf.lo.accept_local"
+    old = cmd(f"sysctl -n {sysctl}").stdout.strip()
+    cmd(f"sysctl -w {sysctl}=1")
+    defer(cmd, f"sysctl -w {sysctl}={old}")
+    ip("link add psp-dummy1 type dummy")
+    defer(ip, "link del psp-dummy1")
+    ip("addr add 203.0.113.1/32 dev psp-dummy1")
+    fams = [(socket.AF_INET, "203.0.113.1", "ip")]
+    if cmd("ip addr add 2001:db8:ff::1/128 dev psp-dummy1 nodad",
+           fail=False).ret == 0:
+        fams.append((socket.AF_INET6, "2001:db8:ff::1", "ipv6"))
+    else:
+        ksft_pr("no IPv6 on psp-dummy1, IPv4 only")
+    ip("link set psp-dummy1 up")
+    _tc_clsact("lo")
+    for family, addr, proto in fams:
+        with socket.socket(family, socket.SOCK_DGRAM) as srv, \
+             socket.socket(family, socket.SOCK_DGRAM) as s:
+            srv.bind((addr, 0))
+            srv.settimeout(0.5)
+            port = srv.getsockname()[1]
+            flt = (f"dev lo egress pref 10 handle 1 protocol {proto} "
+                   f"flower ip_proto udp dst_port {port}")
+            redir = "action mirred ingress redirect dev lo"
+
+            tc(f"filter add {flt} {redir}")
+            del_flt = defer(tc, "filter del dev lo egress pref 10 "
+                            f"handle 1 protocol {proto} flower")
+            s.sendto(b'clear', (addr, port))
+            ksft_eq(srv.recv(64), b'clear', comment=proto)
+
+            # After encap the packet is marked decrypted: received, that
+            # would read as decrypted by the device
+            tc(f"filter replace {flt} action psp encap assoc {tx['id']} "
+               f"pipe {redir}")
+            s.sendto(b'encap', (addr, port))
+            with ksft_raises(socket.timeout):
+                srv.recv(64)
+            flts = tc("-s filter show dev lo egress pref 10", json=True)
+            mirred = [a["stats"] for f in flts
+                      for a in f.get("options", {}).get("actions", [])
+                      if a["kind"] == "mirred"]
+            ksft_eq(mirred[0]["overlimits"], 1, comment=proto)
+            del_flt.exec()
+
+
+def removal_device_tc(cfg):
+    """ Test removing a PSD with tc actions holding its assocs """
+    cfg.require_nsim()
+    _require_tc_psp(cfg)
+    # Only look the device up: enabling PSP would register an undo for the
+    # device which the test removes
+    if not hasattr(cfg, 'psp_dev_id'):
+        for dev in cfg.pspnl.dev_get({}, dump=True):
+            if dev['ifindex'] == cfg.ifindex:
+                cfg.psp_info = dev
+                cfg.psp_dev_id = dev['id']
+                break
+        else:
+            raise KsftSkipEx("No PSP devices found")
+
+    rx, tx = _sockless_assocs(cfg)
+    tc(f"action add action psp encap assoc {tx['id']} index 100")
+    defer(tc, "action del action psp index 100")
+
+    __nsim_psp_rereg(cfg)
+
+    # Unregistering the device drops its socket-less assocs
+    for assoc_id in (rx['id'], tx['id']):
+        with ksft_raises(NlError) as cm:
+            cfg.pspnl.assoc_get({"id": assoc_id})
+        ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+
+
 def _check_assoc_list(cfg, psp_dev_id, ifindex, nsid=None):
     """Verify assoc-list contains device with given ifindex, no duplicates."""
     dev_info = cfg.pspnl.dev_get({'id': psp_dev_id})
@@ -1173,7 +1760,7 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust]
+                cases = [data_basic_send, data_mss_adjust, data_tc_basic_send]
 
                 if has_cont:
                     cases += [
-- 
2.53.0-Meta

