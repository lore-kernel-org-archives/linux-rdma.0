Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051902;
	b=sm4lmfgblVEfuRFMJceTP6mmWR85qv9uaZzXVfchZ23Aw3A9qg+uSVbFbTpUx4ymesbv
	 UnPv711tnylWOZlP32tAeBPR7RbY/39LJKTb7nV9UPOBKUGX6SOV8/zbXnMCAD857vqQR
	 M8fBTxLL6ddi2e1KdBO7+APn9GQhww0P8NQJejeJPLx0tSWSf2J/PZu86hsRRFpLcgibc
	 DFAqnY/KK33EeiTTntPdHvlSePiL9PdnBC0/LcH9cM10FThorId7CbDbjV0f9sH/+Znfe
	 JrF5QoAEydUzpggGsrbkPlbZYsgC+rv6Ir01anN6pwL3lIhSBTVRJCqdC6NYQkIn7BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051902;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version;
	bh=Lh0aEv6+3YhRhDmK+m2URl9+b0Ru+Lwdb9DthZvo1N8=;
	b=IRkq1lwhX/hPmszkXi3UHjk8SWl9zgy1sMb8PSs5CeO/fb3HKNE31kxfJurDvabjHtef
	 3BXSm4FA8P5ThzzeTHcw+z9cGATxidXqcFWsJlFMrImdwYjlCrfvDaMJHbv8rtcByYn/O
	 72uO5czaetUtePWXVrbgE3/5zeXd7tRju7zgLCrADVrYkRoxA8T5+XgaPduZ23iPXBIp3
	 OwCZUaHFPjidBwHl45+cIXIuLfSaK8i712TykQZSads+Zk0n3oxg+hMXxv2JqYdroZluz
	 KFs7YEEaa3j2Dl6Bi2AfHEF+442YLeeyWAci18cUMhsOrW7+YhwDYyXqg+dukWBjGzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=GRppm+1w;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF3260A2606;
	Thu, 19 Nov 2026 01:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EF3260A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=GRppm+1w
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ19YcZ1603433;
	Wed, 18 Nov 2026 17:31:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Lh0aEv6+3YhRhDmK+m2URl9+b0Ru+Lwdb9Dth
	Zvo1N8=; b=GRppm+1wpUR9qzS3+hCe9pmfUs8/+xXZc8ZLHxQ6HzYOsQZ47b9Ue
	Nk4q6oAOrzafOsg9ahslc8tD65HGLf44HloQsoKMSaqxTghBq4xOe9mDBPfJfnvx
	voT9bnHMUi/+4BBygDNsIaSnehlqeu5WHPtYIGdUf6e/X/szGS03VgkKpi5mcYT+
	dKrDdKLCVxMhVmjmmU0ICe9iGIgyzy4ZGOXazIKnTlIcqEf0n5fyRXZPDr2iBOzl
	0fvJE7m2c15OliN9Xw3DmNd3VZadITrqoW6nlSfTBK9ahfmIeFexL2uHFo+gi8Ra
	DNAaO4vjDwMKTvmC9pYgj9RZIq0huCZZA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu6kb28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:28 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:27 +0000
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
	<willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 09/12] selftests: drv-net: psp: test that software encap on ingress drops
Date: Wed, 18 Nov 2026 17:31:00 -0800
Message-ID: <20261119013103.1092559-10-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261119013103.1092559-1-toddfreed@meta.com>
References: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Proofpoint-GUID: QepVC49UDBjvMKxIOOQrDZ-z1smEtvgY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX9VeZgDEkRlc8
 RfbM5WnpEb5IzPeB8C9xvtUxDponfAuRfCmNooAg2RPN9h1fdWf1aaH/2xXFYwCtm+KehpR47Co
 PqDvpBcxyMSIeudwk1o+6aMiGwSFkZY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX0FoTnzPi9U89
 zHidLT9irUyZioRcRDDuw7iqNlfN5PsKZDKFNyyzzKbQNzZpy+sagmmHkU1679cAyozvEvXEEp4
 f5Qb6zkjFw4qeePXrxGhVmBUOQe0x2lpsMh/Wng8rrbUwZca4PXFFbTiA0yheTlaYuj2xOE2Yj5
 WC7O5T+ZIY6fcrpWp1mPLbUo3dz/qq0/pnG3EibU/dhM+erqAFQ2wncHzrLu9znMd74/ko3DL3y
 hCxVZCqP/86lXgK/Z28Tjk8crcxy74bJXh2ftlrLURHsSY/b9pYdV+b2WgsQOWs0swA2unYjUGL
 rT3hHGNw0pNJO1bCL8bgV5qZ6+ir71K/ZzqNWj06mrJPuZkCELQMAoJDLcvW/V2ba7i6u57ksez
 Hh9czj+/FjHJhmtb51/VBUpk7bbKKewislg8MtrVYhLCnDflQdusKNSSsfBOnUQhbWL2dKZBj0G
 /G+PqagidA4/m+XtLUw==
X-Authority-Analysis: v=2.4 cv=H6JOUOYi c=1 sm=1 tr=0 ts=6afe5170 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VabnemYjAAAA:8 a=y88YBaQT-65dKC87SboA:9
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: QepVC49UDBjvMKxIOOQrDZ-z1smEtvgY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

Encap on ingress isn't supported: the action drops the packet.

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
index 5cef2d396900..c3eb408fe1b0 100755
--- a/tools/testing/selftests/drivers/net/psp.py
+++ b/tools/testing/selftests/drivers/net/psp.py
@@ -22,7 +22,7 @@ from lib.py import ksft_variants, KsftNamedVariant
 from lib.py import KsftSkipEx, KsftFailEx
 from lib.py import NetDrvEpEnv, NetDrvContEnv
 from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
-from lib.py import NetNSEnter
+from lib.py import NetNS, NetNSEnter
 from lib.py import bkg, rand_port, wait_port_listen
 from lib.py import cmd, ctl_file_write, ip, tc
 
@@ -1239,6 +1239,160 @@ def data_tc_encap_ingress(cfg):
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
+    # Encap on ingress isn't supported: the action drops the packets.
+    # They must not reach the remote in clear text.
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
+        # Encap on ingress isn't supported: the action drops the
+        # packets, rather than let them be received
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
@@ -1763,7 +1917,8 @@ def main() -> None:
                                                           cfg.comm_port),
                                                          timeout=1)
 
-                cases = [data_basic_send, data_mss_adjust, data_tc_basic_send]
+                cases = [data_basic_send, data_mss_adjust, data_tc_basic_send,
+                         data_tc_encap_routed, data_tc_encap_local]
 
                 if has_cont:
                     cases += [
-- 
2.53.1-Meta

