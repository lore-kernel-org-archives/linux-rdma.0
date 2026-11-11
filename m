Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794358598;
	b=kPaFE87CsI0DW0ORw/xr2UpW2hOJVjOmrZfdHe7wO5UyycRAm+qp/KOuB6dew49A3oKJ
	 jvD5r58tboYSDJq2+Cq+pqniqDmLKVjf29y/v2z7TOB9uJABAS4InZqXUIJ7eZPtjB+zY
	 zuDn5eLKfubT6DIT9x45I0Nrwdex4JHO0JYv1mBkPgMUc5eZwWYnwIwyhiKlOD9RPkBvt
	 0WMdnkVUzEavRVHcepI0DwEshA1ebrs2w+pvcwy+8Ju5DktloGLPN+xKZqpklA0Z4VCqj
	 3z0fTO9mPFkIbqZQDTN/AbjH/qZRrh0JixDZKyPF1LIOjhsLGoopr+oRddPftGEGnGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794358598;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=2nF9pW26f/xooyA4m6UjuYL5rbGoqk/WNdiIPrvS4hE=;
	b=Avgb8pMQLT5mlz9hQscI7i0qwkaErjXP4ZMk2SHpVRkywtkX5BNfr2YcGiJtRep60POf
	 NnqTamn7vMxYx0QwRSqYxhq+1w5CF+kl7xMbO1dFWlAQZOmYhUgsWanTSeNdaKtQujbC3
	 RIIPjalNhl0CUf4gadeLcAi0d9sIMpN4c2Zw8w611Dn8fW0fTQ+VXE/KnSPMQPWDTjSc4
	 RgsUn8QN1ig/WE+GSBkJJK/PywKRjve3Ua6seUXbGFkF3DmHi/Et/0T8fn6ItS1DOpZlj
	 wfHSvblckfEdcuEWpK78ekFYVX4PURuT0wxvOPX4jOelJZYv5jLlVpDixa6gVEE1plA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LDsW4UI0;
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1FA606A31C;
	Wed, 11 Nov 2026 00:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E1FA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=LDsW4UI0
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB0Wp762553000;
	Tue, 10 Nov 2026 16:56:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=2nF9pW26f
	/xooyA4m6UjuYL5rbGoqk/WNdiIPrvS4hE=; b=LDsW4UI0NtSE1SIuNVEocZyKW
	z2oWaIGix/Rv/2nF78Z/5rQFpiSplRqcwM7PR4CQcjrj8EQnRX3ROfhlcGde0dvt
	X0jtxx2oxGXsEHYJ0usEv+MWqP7xNX4Re29m6dc610hhrwoBbPLhqXxE3B4dn3Xp
	xn5MrxRbmo5Ym6+Nww4hXNWNsBq+zNAmKVhINFD8hlMeh3F7W/FX4Ew1VciIFR6Y
	w9SgPdmGXJKj7HyJOwliMatJCOpR8NGzFfOohV9IOdgangGCsfc8pDvsqeaqhASw
	+OIYa/4dsELvDKCxTR0flLIFAatQrtslysiwV10TZboSp8uaLGs8JURwHkPlQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7y3u5dd-15
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:56:04 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:56:01 +0000
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
Subject: [PATCH net-next v1 00/15] psp: introduce socket-less associations
Date: Tue, 10 Nov 2026 16:55:18 -0800
Message-ID: <20261111005533.6436-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
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
X-Proofpoint-GUID: geWqqaDdjU6G4yxFsjj7FQJoA6rY5vQZ
X-Authority-Analysis: v=2.4 cv=PeFqFShd c=1 sm=1 tr=0 ts=6af3bd24 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=JnKecZnUtZousrUlYMGU:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=NEAV23lmAAAA:8
 a=-2befDNRRjLQaoOzd-4A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX2twRBnUzdIf2
 Nam/vkrBlaz9LjkqY67NE5Ag/Q2NHzOtdZH7IIHwMSwqlXkqhDyb6rrrixSxxyfer9LyO5+TtDY
 BkDwHRh9KK3UDs4yvZopyRadds0UVnM=
X-Proofpoint-ORIG-GUID: geWqqaDdjU6G4yxFsjj7FQJoA6rY5vQZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMyBTYWx0ZWRfX6uQABkhbMxYy
 Zh7uPb/Pue2EjX2UeyGkleTKkwNUM8PidCuL21DlIAAbtayignkj+U4erDqWgvRraw733bkB3bW
 FRqC2xzjoSfiwnGud8WYTvi7oFwhX3DpNyf9AZ473/1EV0HEfekkeWLht9VaZv7JsHSJtUQtwY/
 MTf+H2ITJ2sJX8JS1/KKwo88KbYOiZI+cTc1A8BNB3WEJ2br5KMu2nnm1hZy1UYPn8agYMsPF1k
 eO1eQ5XWhRKCUyE4v1nTdDxxcVCAPMChkP1YV3+A5llYur7DXh6yuRynTlBrWsTrcpokKnOpD6Y
 OQywpYRPpPq9FRMy2FCH7ttgpDwhMwjIuz1ul4hjYjXerlgfQ0f7EMn80jb2+pgmOQpnzE7KCVX
 aH9HhIJiS4xK6dV4Wqh1giiDIxfOEyJar2+itCOUFyDrkMoYslniWlZxTLTxGRSiw/bzGmlhyTr
 MX+vtsxh2RzNr01dA3A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

psp associations today are bound to a tcp socket when created. traffic
on that socket is encapsulated in transport-mode psp, and encrypted.

this series adds associations which aren't bound to a socket, which
allows psp encapsulation and encryption to be applied to forwarded
traffic. you can use this to transparently apply psp tunnels to flows,
with help from userspace to manage the tc rules and orchestrate key
exchange.

the lifecycle of socket-less associations is managed over the psp
netlink family. socket-less associations are stored in a small registry,
and are addressable by id. the registry does not contain socket
associations.

socket-less associations are on the device's association lists, like
socket associations. rx ones are therefore marked stale by key rotation
in the same way. in this series, nothing acts on socket-less rx
associations on key rotation. instead, userspace should replace decap
rules for a SPI before its device key has been rotated twice. a
follow-up will bring enforcement.

series structure,

1, 2/ prepares psp to work with non-tcp packets

3, 4/ adds the netlink commands for managing socket-less associations

5/ adds a METADATA_PSP dst which carries the socket-less psp association
on an skb for tx, and the transmit checks for it

6, 7/ keep mirred and bpf from sending decrypted skbs from egress to
ingress, since skb->decrypted depends on direction

8/ limit time-wait psp socket validator to sockets actually in
time-wait. the new psp actions check for presence of the validator

9/ adds the act_psp tc actions, psp encap and psp decap. in software,
encap is egress only. 

10/ adds flower matches on psp header fields, for rx matching

11, 12/ add drv-net tests (netdevsim and hardware)

13/ makes tc-testing run dependsOn probes outside the test namespace,
where they currently always fail

14/ adds tc-testing tests

15/ Documentation for socket-less psp associations

a following series adds hardware offload of the psp actions and flower
matches, psp tunnel mode (which is offload only and therefore not
included here), encap on ingress (also offload only), and the mlx5
implementation for switchdev mode. It's available in the tree below.

relation to the psp fixes in net:

this series is based on net-next, and overlaps with "psp, tls: don't
send offloaded contents in cleartext" in net:

 https://lore.kernel.org/netdev/20261111001831.3710881-1-toddfreed@meta.com

when net is merged into net-next:

 - net/psp/psp_main.c conflicts around psp_dev_encap_ok(), which both
   add: net's only allows tcp, this series' (patch 2) takes any l4
   protocol. keep this series' version of the function, and its
   comments above it and above psp_dev_encapsulate().
 - tools/testing/selftests/drivers/net/psp.py and
   tools/testing/selftests/drivers/net/config conflict: keep both sides
   (imports, constants, the list of test cases; the NET_ACT_* options).

relation to the netfilter fixes in nf-next:

packets which a psp device decrypted don't have to end in a local psp
socket. they can already be forwarded or bridged today, but with
socket-less associations that is the intended use, e.g. a router that
decaps and forwards. netfilter handles two cases itself, outside the ip
stack paths which the net series fixes, and would send such a packet's
decrypted contents in clear text:

 - the bridge refragments packets which bridge conntrack reassembled
   (br_ip6_fragment(), nf_br_ip_fragment()), without the check of "net:
   don't fragment decrypted skbs".
 - the reject code builds its own icmp errors and tcp resets
   (nf_reject_skb_v4_unreach() and friends), without icmp_send() and
   icmpv6_send(), which the net series' icmp patches cover.

a separate series to nf-next applies the net series' rules to both:

  "netfilter: bridge: don't refragment decrypted skbs"
  "netfilter: reject: don't reply to decrypted skbs"

  https://lore.kernel.org/netfilter-devel/20261111003111.3826942-1-toddfreed@meta.com

it doesn't depend on this series, and the two don't conflict.

trees:

the full tree, with the net fixes, the nf-next series, this series and
the mlx5 offload series, and the conflicts above resolved, is at:

 https://github.com/toddfreed/psptc branch psptc

iproute2 tree, with support for the psp action and the psp flower
matches, based on iproute2-next. the selftests need it:

 https://github.com/toddfreed/iproute2-psptc branch tc-psp

testing:

 - netdevsim: drivers/net psp.py passes (57 tests), and tc-testing
   psp.json (17 tests).
 - mlx5 (ConnectX-7, FW 28.48), two hosts: drivers/net psp.py passes:
   46 pass, 8 skip (GMAC versions not supported by the device),
   3 xfail (netdevsim only).
 - each patch builds without warnings with gcc and clang, allmodconfig,
   W=1.
Todd Freed (15):
  psp: get netns from net_device instead of sock
  psp: take the psp nexthdr from the packet on encap
  psp: declare psp_assoc_set_tx() in psp.h
  psp: add support for socket-less psp associations
  net: add METADATA_PSP dst to carry a psp association on an skb
  net/sched: act_mirred: don't send decrypted skbs from egress to
    ingress
  bpf: don't redirect decrypted skbs from egress to ingress
  psp: only give time-wait sockets of psp connections a validator
  net/sched: add act_psp for psp transport mode
  net/sched: flower: add psp_spi, psp_ver, and psp_dev matches
  selftests: drv-net: psp: test socket-less associations and the tc psp
    action
  selftests: drv-net: psp: test that software encap on ingress drops
  selftests: tc-testing: run dependsOn probes outside the test namespace
  selftests: tc-testing: add tests for the psp action
  Documentation: networking: psp: document socket-less associations

 Documentation/netlink/specs/psp.yaml          |  98 ++-
 Documentation/netlink/specs/tc.yaml           |  14 +
 Documentation/networking/psp.rst              | 139 +++-
 MAINTAINERS                                   |   3 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  33 +
 drivers/net/netdevsim/psp.c                   |   2 +-
 include/linux/skbuff.h                        |   4 +
 include/net/dst_metadata.h                    |  19 +
 include/net/flow_dissector.h                  |  18 +
 include/net/psp/functions.h                   |  91 ++-
 include/net/psp/types.h                       |   1 +
 include/net/tc_act/tc_psp.h                   |  23 +
 include/uapi/linux/pkt_cls.h                  |   6 +
 include/uapi/linux/psp.h                      |   6 +
 include/uapi/linux/tc_act/tc_psp.h            |  28 +
 net/core/dev.c                                |  48 +-
 net/core/dst.c                                |   5 +
 net/core/filter.c                             |   9 +
 net/core/flow_dissector.c                     |  27 +
 net/psp/Makefile                              |   2 +-
 net/psp/psp-nl-gen.c                          |  60 ++
 net/psp/psp-nl-gen.h                          |   8 +
 net/psp/psp.h                                 |   7 +
 net/psp/psp_assoc.c                           | 120 +++
 net/psp/psp_main.c                            |  54 +-
 net/psp/psp_nl.c                              | 261 ++++++
 net/psp/psp_sock.c                            |  32 +-
 net/sched/Kconfig                             |  13 +
 net/sched/Makefile                            |   1 +
 net/sched/act_mirred.c                        |   6 +
 net/sched/act_psp.c                           | 439 ++++++++++
 net/sched/cls_flower.c                        |  64 ++
 tools/testing/selftests/drivers/net/config    |   5 +
 tools/testing/selftests/drivers/net/psp.py    | 750 +++++++++++++++++-
 tools/testing/selftests/tc-testing/config     |   2 +
 .../tc-testing/tc-tests/actions/psp.json      | 459 +++++++++++
 tools/testing/selftests/tc-testing/tdc.py     |   2 +-
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 39 files changed, 2812 insertions(+), 50 deletions(-)
 create mode 100644 include/net/tc_act/tc_psp.h
 create mode 100644 include/uapi/linux/tc_act/tc_psp.h
 create mode 100644 net/psp/psp_assoc.c
 create mode 100644 net/sched/act_psp.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/psp.json


base-commit: ed04b202027249e2769420893220f54a56e0c59a
-- 
2.53.0-Meta

