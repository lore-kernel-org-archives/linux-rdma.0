Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358609;
	b=PJ77uksjTYohVbniD7wzflvzD1bQmK9zMXwb3a4UXXsvSziGY8ou7ZYsr9DX2+/0j7mB
	 zXWDNt3dxJi2RDRsaQ4ChtBCBaxr/JgD+RIu04LVZnSX/T5r1cPLfa+9Z9jDUCzDjo0cF
	 0nfrRC1T6AKMsUP9KFnuqnWL9MFGQB7De4abQSkLtYk165rt1SBer6dXkBEZgsUXDIfyT
	 hN84SsHGoxFL4nMuu4g+qmEPO0z5lfBZcZvDHxNVq8Hn3AY+7dOpF5igSKRVicNn3nvW9
	 QYxPAUjQhvRLRl4MGf7b0nmqaREZ/BnumzluD0uudD80LrdWJinnt+dwSre6dD/cPmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358609;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=+1LibQQLPKM4D2ajYv2wbrs66QTPPLBOK0a4ogH5UlE=;
	b=BjYXefdO3boJQpJxMCQu/i/gxcqzgJRb5X2k7GvjdjjAqdx3MKmF99Pb7YiO3Gl5dbGo
	 exWp6fC+gdz8eSBEilaut9Kpj9xP9SptVfMTedWJwtvqZBChrp8pwwgzJw85xVLfTd7gD
	 JkRBAKEQy8vIzRd9DS0Y9uiTcp55S78W70sLOYiZNfiMMviSD8Uz5dHFLY/Ke/Xid9ODj
	 VsmmIHE8JWBI/lq5glWEE3e2ctZhw1DX3dtadlQFlT3V8kmYpu4Z9f1vqFlpItm2vb6Bs
	 3cc3rq3qHmA1MwRt+x+ZLkwMeFc6zoIm1KKRwcjv5LLWROJJWe5Lzu7DbzwWjf2JaNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="HZrBb/Rt";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED5E606AA02;
	Wed, 11 Nov 2026 00:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ED5E606AA02
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=HZrBb/Rt
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0WRv02552606;
	Tue, 10 Nov 2026 16:56:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=+1LibQQLPKM4D2ajYv2wbrs66QTPPLBOK0a4o
	gH5UlE=; b=HZrBb/RteNoalKWpVdIcGVtlZrRSQYdnBMhXJEXmheq9LQE79k/nz
	DQFuOSxjxwSIFDrouwdtLhnA6P+8/FLd4OgrVwwiEJ/bLQPDiRjS26XT2/asRP6e
	74LubeOcZzozm5bod3A+S4Tcq2yD7ncfgwx0LGOY0z44B4Ew0Tn7WecF7cOtO2/g
	kkBffDh4snoq9EktMeioLrkLEdjzH1oCAQ18pd7WXWAv7VC+AYOkF2sf4W9w6Ce7
	k5Kgvf0wqnLZaY3ty9lRqYs/yzVPINQ7IEXbkUgodSfTbCpbfudm5ZW6WTAhC2mh
	Uiz707pfxOADvd5WVIlipBAEDz/1OPjCA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7y3u5g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:21 -0800 (PST)
Received: from localhost (2620:10d:c085:108::150d) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:11 +0000
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
Subject: [PATCH net-next v1 12/15] selftests: drv-net: psp: test that software encap on ingress drops
Date: Tue, 10 Nov 2026 16:55:30 -0800
Message-ID: <20261111005533.6436-13-toddfreed@meta.com>
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
X-Proofpoint-GUID: Z92DtesEhwaiwfEfDUDd1wWq8PbtNJg-
X-Authority-Analysis: v=2.4 cv=PeFqFShd c=1 sm=1 tr=0 ts=6af3bd35 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VabnemYjAAAA:8 a=y88YBaQT-65dKC87SboA:9
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXxm5TlbWlYr3x
 7PkURyu0FwEq2vuwajvoGTBscQurqTnlzmJlyZiQKwIMcNvI1N66Fzew/3Crgl94JmiPqsbJFBE
 s5yBjrmU/8Kv959ZedH6W43eC5MMVL4=
X-Proofpoint-ORIG-GUID: Z92DtesEhwaiwfEfDUDd1wWq8PbtNJg-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfXwNqgTM+2c+iP
 25QmpwlQEH5CiFBM4urWCMgO8sP/2bFbdWsJVcDenCsWdv/2LmP5zfcSpqIAsrXGasS8sPg0FOG
 XL164asmDBmfmLhgsNsQDo7p14I6iAXLpxDW1sC4AKbCXeXqcndaSwJTbId7CRuOR4tt6xYMO9D
 lLWrm+f5JhnjV0hYQqV1WL9+vyf79L+GWE9yR+bwnIRmdGTtery97kW9FzF+EX5KdicArCehpBH
 SnNEx/8DyUa9Y+ZnrOrUZkYokVqjh7s7Bck5orC3vTz9wMFTTOYF7IWz2mLw2yoyu8ymBVo9Hj/
 peHuxGwNa92asFXQLwMEv0HLw6TcEGUEckX6IeDo5PN+ENcbI4C0H1oxU79+J4DraAQkkpsePv2
 qUmLaD4Oqy/urGbgQt5GAUjnUIldIUcziGuOolEgx5u/iw08/UX30IsUFWi61fI1PgygHe+VcVZ
 lpv5RixzkQF4LNPjY7A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

encap on ingress is hardware offload only. In software, the packet is
dropped.

Verify it on traffic of a client behind a veth, with encap on the veth's
ingress: forwarded, the packets must not reach the remote in clear text,
and to a local address, they must not reach the local socket.

  data_tc_encap_routed  routed packets are dropped by encap, IPv4 and
                        IPv6
  data_tc_encap_local   so are packets to a local address

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 tools/testing/selftests/drivers/net/config |   2 +
 tools/testing/selftests/drivers/net/psp.py | 159 ++++++++++++++++++++-
 2 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/config b/tools/testing/selftests/drivers/net/config
index baf1c9d0dd13..b39de6e64263 100644
--- a/tools/testing/selftests/drivers/net/config
+++ b/tools/testing/selftests/drivers/net/config
@@ -5,6 +5,7 @@ CONFIG_DUMMY=m
 CONFIG_INET_PSP=y
 CONFIG_IPV6=y
 CONFIG_MACSEC=m
+CONFIG_NET_ACT_GACT=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_NET_ACT_PSP=m
 CONFIG_NET_ACT_SKBEDIT=m
@@ -25,5 +26,6 @@ CONFIG_NET_SCH_PRIO=m
 CONFIG_PPP=y
 CONFIG_PPPOE=y
 CONFIG_TLS=y
+CONFIG_VETH=m
 CONFIG_VLAN_8021Q=m
 CONFIG_XDP_SOCKETS=y
diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
index fb7544410051..f7613fcd2fbf 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -22,7 +22,7 @@ from lib.py import ksft_variants, KsftNamedVariant
 from lib.py import KsftSkipEx, KsftFailEx
 from lib.py import NetDrvEpEnv, NetDrvContEnv
 from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
-from lib.py import NetNSEnter
+from lib.py import NetNS, NetNSEnter
 from lib.py import bkg, rand_port, wait_port_listen
 from lib.py import cmd, ip, tc
 
@@ -1242,6 +1242,160 @@ def data_tc_encap_ingress(cfg):
             del_flt.exec()
 
 
+def _tc_act_stats(dev, pref, host=None):
+    """ Stats of the first action of the ingress filter @pref of @dev """
+    filters = tc(f"-s filter show dev {dev} ingress pref {pref}",
+                 json=True, host=host)
+    for flt in filters:
+        for act in flt.get("options", {}).get("actions", []):
+            return act["stats"]
+    raise KsftFailEx(f"no action on the {dev} pref {pref} filter")
+
+
+def _tc_act_pkts(dev, pref, host=None):
+    """ Packets of the first action of the ingress filter @pref of @dev """
+    return _tc_act_stats(dev, pref, host)["packets"]
+
+
+def _fwd_client(cfg, ipver):
+    """
+    Set up a client in a netns behind veth psp-fwd0, and forward its
+    traffic: only from psp-fwd0, the host's own forwarding settings stay as
+    they are. Return a UDP socket of the client.
+    """
+    ns = NetNS()
+    defer(ns.__del__)
+    ip(f"link add psp-fwd0 type veth peer name psp-fwd1 netns {ns.name}")
+    defer(ip, "link del psp-fwd0")
+    if ipver == "4":
+        fwd = "/proc/sys/net/ipv4/conf/psp-fwd0/forwarding"
+        local, client, plen = "198.51.100.1", "198.51.100.2", 24
+    else:
+        fwd = "/proc/sys/net/ipv6/conf/psp-fwd0/force_forwarding"
+        local, client, plen = "2001:db8:fe::1", "2001:db8:fe::2", 64
+    if not os.path.exists(fwd):
+        raise KsftSkipEx(f"{fwd} not supported")
+    # Goes away with the device
+    with open(fwd, "w", encoding="utf-8") as fp:
+        fp.write("1")
+    # IPv6 may be disabled on new devices
+    if cmd(f"ip addr add {local}/{plen} dev psp-fwd0 nodad",
+           fail=False).ret:
+        raise KsftSkipEx(f"can't add {local} to a new device")
+    ip("link set psp-fwd0 up")
+    ip(f"-n {ns.name} addr add {client}/{plen} dev psp-fwd1 nodad")
+    ip(f"-n {ns.name} link set psp-fwd1 up")
+    ip(f"-n {ns.name} route add default via {local}")
+
+    family = socket.AF_INET if ipver == "4" else socket.AF_INET6
+    with NetNSEnter(ns.name):
+        s = socket.socket(family, socket.SOCK_DGRAM)
+    defer(s.close)
+    return s
+
+
+def _remote_filter(cfg, pref, proto, match):
+    """
+    Add a flower filter on the remote's ingress, to count what gets there.
+    In software only: drivers refresh the counters of offloaded filters
+    periodically, and these counts must be exact.
+    """
+    _tc_clsact(cfg.remote_ifname, host=cfg.remote)
+    tc(f"filter add dev {cfg.remote_ifname} ingress pref {pref} handle 1 "
+       f"protocol {proto} flower skip_hw {match}", host=cfg.remote)
+    defer(tc, f"filter del dev {cfg.remote_ifname} ingress pref {pref} "
+          f"handle 1 protocol {proto} flower", host=cfg.remote)
+
+
+def _tc_encap_ingress(proto, port, tx):
+    """ psp encap on psp-fwd0's ingress, which software drops """
+    _tc_clsact("psp-fwd0")
+    tc(f"filter add dev psp-fwd0 ingress pref 10 protocol {proto} "
+       f"flower ip_proto udp dst_port {port} "
+       f"action psp encap assoc {tx['id']}")
+
+
+@ksft_variants(_get_ip_variants())
+def data_tc_encap_routed(cfg, ipver):
+    """ Test software encap on ingress drops routed packets """
+    cfg.require_ipver(ipver)
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    proto = _tc_proto(ipver)
+    _, tx = _sockless_assocs(cfg)
+    s = _fwd_client(cfg, ipver)
+
+    port = rand_port(socket.SOCK_DGRAM)
+    _remote_filter(cfg, 10, proto,
+                   f"ip_proto udp dst_port {port} action drop")
+
+    def remote_pkts():
+        return _tc_act_pkts(cfg.remote_ifname, 10, host=cfg.remote)
+
+    def send(n):
+        for _ in range(n):
+            s.sendto(b'0123456789', (cfg.remote_addr_v[ipver], port))
+            time.sleep(0.01)
+        time.sleep(0.2)
+
+    # Without encap the packets are forwarded to the remote, unless
+    # something else, e.g. a FORWARD policy, stops them
+    send(10)
+    sent = remote_pkts()
+    if not sent:
+        raise KsftSkipEx("forwarded packets don't reach the remote")
+
+    # Encap on ingress is hardware offload only: in software the action
+    # drops the packets. They must not reach the remote in clear text.
+    _tc_encap_ingress(proto, port, tx)
+    send(10)
+    ksft_eq(_tc_act_pkts("psp-fwd0", 10), 10)
+    ksft_eq(_tc_act_stats("psp-fwd0", 10)["drops"], 10,
+            comment="dropped by encap")
+    ksft_eq(remote_pkts(), sent)
+
+
+@ksft_variants(_get_ip_variants())
+def data_tc_encap_local(cfg, ipver):
+    """ Test software encap on ingress drops packets to a local address """
+    cfg.require_ipver(ipver)
+    _init_psp_dev(cfg)
+    _require_tc_psp(cfg)
+
+    _, tx = _sockless_assocs(cfg)
+    s = _fwd_client(cfg, ipver)
+    fam = "inet" if ipver == "4" else "inet6"
+    addrs = ip("addr show dev psp-fwd0", json=True)[0]["addr_info"]
+    local = [a["local"] for a in addrs
+             if a["family"] == fam and a["scope"] == "global"][0]
+
+    family = socket.AF_INET if ipver == "4" else socket.AF_INET6
+    with socket.socket(family, socket.SOCK_DGRAM) as srv:
+        srv.bind((local, 0))
+        srv.settimeout(0.5)
+        port = srv.getsockname()[1]
+
+        # Without encap the packets are delivered, unless something
+        # else, e.g. an INPUT policy, stops them
+        s.sendto(b'clear', (local, port))
+        try:
+            got = srv.recv(64)
+        except socket.timeout as e:
+            raise KsftSkipEx("the client's packets aren't delivered") from e
+        ksft_eq(got, b'clear')
+
+        # Encap on ingress is hardware offload only: in software the
+        # action drops the packets, rather than let them be received
+        _tc_encap_ingress(_tc_proto(ipver), port, tx)
+        s.sendto(b'encap', (local, port))
+        with ksft_raises(socket.timeout):
+            srv.recv(64)
+        ksft_eq(_tc_act_pkts("psp-fwd0", 10), 1)
+        ksft_eq(_tc_act_stats("psp-fwd0", 10)["drops"], 1,
+                comment="dropped by encap")
+
+
 def removal_device_tc(cfg):
     """ Test removing a PSD with tc actions holding its assocs """
     cfg.require_nsim()
@@ -1760,7 +1914,8 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust, data_tc_basic_send]
+                cases = [data_basic_send, data_mss_adjust, data_tc_basic_send,
+                         data_tc_encap_routed, data_tc_encap_local]
 
                 if has_cont:
                     cases += [
-- 
2.53.0-Meta

