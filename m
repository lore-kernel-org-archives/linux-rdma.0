Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558772;
	b=hcfZItHsbhgUOtfe6hufHCfcS5g6kI8ZoCWRxS22dmMnvy0gGpFhc99jw312G3q+YDn9
	 b0nGD4KHyYqX8G2l8EEE25G6CUgX8tnLxx4/XkFPL3NATCAaRQe/ncZSnVe078ClLJUxx
	 lY+XLMqlZl+I/tIRrPINEpt7FbNIIrt/I6fkXHpxvhtBnekSOGeslHoqVfvkSKvLLZjzw
	 sGonwcds9Rih8cwJagPi+B9G2XCYzvJUzCEH7TMramPpL5V2WrizBmsYvIxqSG85zb9L0
	 HcN7Z25COZExiLDQQmsaTMzL7PPXp4NO2rLE4emkLasSF3+8oA21KqJslLqKFyRbBCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558772;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=j5SmxxlHeHuDubsUdf1mgIAqyrkIlAIH3ZJ7uXPrmuY=;
	b=ex1Snee+9JCE2uAPKJe/rVPrXW3b/bBXokaIy0+ofyjSvQNvEWGgjrQlDE9ay9XN4YnL
	 /Cr5sO/iZ/IBNC/dMu+8j6EDh7hhKmqaL19tMmxVdgE1APg2fC/lEdYw+euMbc7tMXybj
	 SBYIMFQIMzbp1eSwYMKcSHiRMWE9e+lxfTRx96y7FZ7ExRjFZIsDUlRIoUgQrYdgo3FJP
	 gGPXZINfHmQ1f6Kdz0P3ruGzRpMC3nXn/rmNR5WR2ETdrX2AERQx5ZJ4th1D05Mn+SpQ1
	 8TEts3Ll9N+6Cs5+mp9gwPEsJQbJwTxCuP9b/6Ka0dBSwzs0tibGOFnSmGmB++T6zTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DZuwcYOU;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21A9606A33D;
	Tue, 24 Nov 2026 22:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B21A9606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DZuwcYOU
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMB8Uf1293071;
	Tue, 24 Nov 2026 14:18:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=j5SmxxlHeHuDubsUdf1mgIAqyrkIlAIH3ZJ7u
	XPrmuY=; b=DZuwcYOUD+QwjhInR6UhnzosW2crPSOs20IKHGAQ7rMJFV3o/yyWi
	sfWVBwsLkgpl4OSnFbBYx6Ab3BJrPRMzbds1hPX1JbGk6pi1YVzxx8a9CIj3SlQJ
	WM9x58dYjUp5ZGa+JfsKogmPzH6K+T6aothBC0JanF1R3KJQy/0Ay8hSxMoSkbm9
	1qxw/nTeHmq0zxQq7YQqKl/P+NBMjaO3l0frjpEhBhlTzxV3chPRytL1nIkG2YaB
	6m30JocXn2ZOr0NeSq85lgwcsSUYQ/aGJ+3SJEBlsI9om2NuY4NyKxEvf3IvYYAn
	w4KxGsS+6KzDqx+DgkLkEHF0PFFK63TuA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5gqwh6m8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:26 -0800 (PST)
Received: from localhost (2620:10d:c0a8:fe::f072) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:25 +0000
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
        Donald Hunter
	<donald.hunter@gmail.com>,
        Dragos Tatulea <dtatulea@nvidia.com>,
        Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim
	<jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>,
        Paolo Abeni
	<pabeni@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
        Tariq Toukan
	<tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, <bpf@vger.kernel.org>,
        =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?=
	<ast@fiberby.net>,
        Qingfang Deng <qingfang.deng@linux.dev>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan
	<shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan
	<skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthieu
 Baerts <matttbe@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
        Hangbin Liu
	<hangbin.liu@linux.dev>
Subject: [PATCH net-next v3 08/12] selftests: drv-net: psp: test socket-less associations and the tc psp action
Date: Tue, 24 Nov 2026 14:17:54 -0800
Message-ID: <20261124221758.3230929-9-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261124221758.3230929-1-toddfreed@meta.com>
References: <20261124221758.3230929-1-toddfreed@meta.com>
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
X-Proofpoint-ORIG-GUID: qfGFNgSZku6QjCgVAvXriGkJYP1VcNVM
X-Proofpoint-GUID: qfGFNgSZku6QjCgVAvXriGkJYP1VcNVM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX44/x7Tkk054a
 qPu6FZMIDz1td5RWUytpSV++itVVS+MnEgIt+bxQfSa6Iwa3ATyWuyJNmJbO549i1j56Btzq23p
 Lfk4O/Oa+e+04pom19KXmjTlKAcCK+E=
X-Authority-Analysis: v=2.4 cv=eJyGH3p1 c=1 sm=1 tr=0 ts=6b060d32 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VabnemYjAAAA:8 a=Tg9yRN0CKSX-gpsRQOMA:9
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX+ogG9GeckfFj
 1EYfLL5JjkAPiAmA4AgTsl6EBN0mAAiV6qak43cG1cG1BYrUBkkAa6w/DR6/bT9+uwOy3kA8x3h
 RIJ/JIF4aqFf+iXCxdp7cJLPaf9GcDG2ODdL2l6uckUmHg5A5XN3zl95KvodQV0PPtrWckC4I4G
 IkEyU/AGORHXzfp77Pq/bxrbI7JAj6aRr1E1fkJykSs2EtM2V9kq1MN9qvEMhheXBicjqOliiiz
 HW+YfIPTcxA1zVmSS/cRiiuwD5H90H07xfiuRkt3Gpsk04SXgv3N/T/QnwtXvVDXaA2PmfKp7bk
 ljfZwbZ5Df/enJWVee6JcC7TI2+wDJwsvJahvnqlI0quHzjNcMK1BQEEFP3blI9eq5np4vTcPtO
 NRmkpTuuD6LiyFMRU3NgAxwRrGqoq0iPItBJr5IaANQQZnAwyxg87RNo1L5CzDaddJ5iiNxirRN
 SM4cdJMaHWIxVItDDEA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

Cover the socket-less PSP commands and the tc psp action.

The data path tests connect a plain local TCP socket to a PSP socket of
the responder, and give the local side PSP with tc and socket-less PSP:
on ingress, flower psp_spi, psp_ver and psp_dev match what was decrypted
with the local Rx SPI, and psp decap removes its PSP state; on egress,
psp encap attaches the Tx association to the socket's packets, which
the device encrypts.

Test cases:

  assoc_sockless_basic     rx-spi-alloc, and assoc-add / get / dump / del
                           of a Tx association, only the SPI is ever
                           reported
  assoc_sockless_rotations rx-spi-alloc reports the key rotations, Tx
                           associations are unaffected by them
  assoc_sockless_bad       bad device, key size, missing key
  assoc_sockless_tc        encap rejects an unknown association and
                           takes a Tx association, decap is accepted
                           without one
  data_tc_basic_send       data to the responder and its ACKs back, for
                           each PSP version and IP version
  data_tc_no_decap         decrypted packets don't reach a plain socket
  data_tc_assoc_del        the Tx association deleted while encap uses
                           it, which holds it
  data_tc_decap_match      decap only takes the packets of the filter's
                           SPI, version and device
  data_tc_encap_wrong_dev  packets redirected to another device drop
  data_tc_encap_short_hdr  an IPv4 packet shorter than its header
                           length is dropped by encap
  data_tc_encap_too_big    packets which won't fit the MTU once
                           encapsulated are dropped, with and without GSO
  data_tc_encap_psp_sock   packets of a PSP socket, which are marked
                           decrypted, are dropped by the psp encap action
  removal_device_tc        PSP device removed while tc holds its Tx
                           association

Note that the tc tests require a newer tc, which has support for the psp
action and the flower psp matches. If tc is missing that support, the tc
tests skip.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/config |   3 +
 tools/testing/selftests/drivers/net/psp.py | 511 ++++++++++++++++++++-
 2 files changed, 509 insertions(+), 5 deletions(-)

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
index 67577f722b3b..936ac37dd913 100755
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
 
 
 _PSP_MAX_KEY_LEN = 32
@@ -171,9 +173,9 @@ def _req_echo(cfg, s):
     ksft_eq(_recv_careful(s, 5), b'echo\0')
 
 
-def _check_data_outq(s, exp_len, force_wait=False):
+def _check_data_outq(s, exp_len, force_wait=False, tries=10):
     outq = 0
-    for _ in range(10):
+    for _ in range(tries):
         outq = _get_outq(s)
         if not force_wait and outq == exp_len:
             break
@@ -938,6 +940,504 @@ def data_mss_adjust(cfg, ipver):
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
+def assoc_sockless_basic(cfg):
+    """ Test socket-less Rx SPIs and Tx associations """
+    _init_psp_dev(cfg)
+
+    rx, tx = _sockless_assocs(cfg)
+    ksft_eq(rx['dev-id'], cfg.psp_dev_id)
+    ksft_gt(rx['rx-key']['spi'], 0)
+    ksft_eq(len(rx['rx-key']['key']), 16)
+    ksft_eq(rx['key-rotations'], _get_stat(cfg, 'key-rotations'))
+    # The kernel keeps no state for an Rx SPI
+    ksft_true('id' not in rx)
+    ksft_eq(tx['dev-id'], cfg.psp_dev_id)
+
+    # Only the SPI is ever reported, never the key
+    version = cfg.pspnl.consts["version"].entries_by_val[0].name
+    assoc = cfg.pspnl.assoc_get({"id": tx['id']})
+    ksft_eq(assoc['dev-id'], cfg.psp_dev_id)
+    ksft_eq(assoc['version'], version)
+    ksft_eq(assoc['tx-key'], {'spi': rx['rx-key']['spi']})
+    ksft_true('rx-key' not in assoc)
+
+    ids = [x['id'] for x in cfg.pspnl.assoc_get({}, dump=True)]
+    ksft_true(tx['id'] in ids)
+
+    cfg.pspnl.assoc_del({"id": tx['id']})
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_get({"id": tx['id']})
+    ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_del({"id": tx['id']})
+    ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+
+
+def assoc_sockless_rotations(cfg):
+    """ Test rx-spi-alloc reports the key rotations, Tx assocs survive them """
+    _init_psp_dev(cfg)
+
+    rx, tx = _sockless_assocs(cfg)
+    rotations = _get_stat(cfg, 'key-rotations')
+    ksft_eq(rx['key-rotations'], rotations)
+    for i in range(2):
+        cfg.pspnl.key_rotate({"id": cfg.psp_dev_id})
+        new = cfg.pspnl.rx_spi_alloc({"dev-id": cfg.psp_dev_id,
+                                      "version": 0})
+        ksft_eq(new['key-rotations'], rotations + i + 1)
+    # A Tx assoc holds the peer's key, which the device key rotation
+    # doesn't affect
+    assoc = cfg.pspnl.assoc_get({"id": tx['id']})
+    ksft_eq(assoc['tx-key'], {'spi': rx['rx-key']['spi']})
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
+    """ Test the tc psp action takes the right assoc """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    _, tx = _sockless_assocs(cfg)
+    unknown = max(x['id'] for x in cfg.pspnl.assoc_get({}, dump=True)) + 1
+
+    # encap takes an existing Tx assoc. tc itself refuses decap with an
+    # assoc, so the kernel's check of that can't be tested with tc.
+    defer(cmd, "tc action del action psp index 101", fail=False)
+    ret = cmd(f"tc action add action psp encap assoc {unknown} index 101",
+              fail=False)
+    ksft_ne(ret.ret, 0)
+    ksft_true("PSP association not found" in ret.stderr, comment=ret.stderr)
+
+    defer(cmd, "tc action del action psp index 100", fail=False)
+    for act in (f"encap assoc {tx['id']}", "decap"):
+        tc(f"action add action psp {act} index 100")
+        tc("action del action psp index 100")
+
+
+@ksft_variants(_get_psp_ver_ip_variants())
+def data_tc_basic_send(cfg, version, ipver):
+    """ Test data send with socket-less assocs and the tc psp action """
+    cfg.require_ipver(ipver)
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+    if version:
+        _require_version(cfg, version)
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
+    """ Test deleting the Tx assoc while encap uses it: encap holds it """
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    s, _, tx = _tc_psp_conn(cfg, 0, cfg.addr_ipver)
+
+    data_len = _send_careful(cfg, s, 10)
+    _check_data_rx(cfg, data_len)
+
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
+        _check_data_outq(s, 0, tries=500)
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
+    s = _establish_psp_conn(cfg, 0)
+    defer(_tc_conn_close, cfg, s)
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
+    _check_data_outq(s, 0, tries=500)
+    _check_data_rx(cfg, data_len + n)
+    _close_psp_conn(cfg, s)
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
+    _, tx = _sockless_assocs(cfg)
+    tc(f"action add action psp encap assoc {tx['id']} index 100")
+    defer(tc, "action del action psp index 100")
+
+    __nsim_psp_rereg(cfg)
+
+    # The Tx assoc of the removed device can no longer be looked up
+    with ksft_raises(NlError) as cm:
+        cfg.pspnl.assoc_get({"id": tx['id']})
+    ksft_eq(cm.exception.nl_msg.error, -errno.ENOENT)
+
+
 def _check_assoc_list(cfg, psp_dev_id, ifindex, nsid=None):
     """Verify assoc-list contains device with given ifindex, no duplicates."""
     dev_info = cfg.pspnl.dev_get({'id': psp_dev_id})
@@ -1436,7 +1936,8 @@ def main() -> None:
                                                          timeout=1)
 
                 cases = [data_basic_send, data_mss_adjust,
-                         rekey_rx_basic, rekey_tx_basic, rekey_both_sides]
+                         rekey_rx_basic, rekey_tx_basic, rekey_both_sides,
+                         data_tc_basic_send]
 
                 if has_cont:
                     cases += [
-- 
2.53.1-Meta

