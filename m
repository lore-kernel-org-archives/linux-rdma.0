Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795558757;
	b=oaen71x7f0emfmFps8DeqehbK7lskjHM9F9izKcTGLyqA+AMkrCcwUCIvHmBtLDwuVQX
	 QAW7IZnWkkZ9xMAr0V/gGgPaFEq00bY0J8OK+Yyxh/PXhOM5qtfZc7zr+TAtcWM0lFqzI
	 9KSjVymbaeVzp3OkjyLD2rND0LiGNcWjN3vnBNBYIfZNAJQIOW2LvC/vyas+23BsjQ8Q6
	 yF8u6WS2q01zwdIqJEWC0oOqnkoRMz00Z7WcUb9k3wxANjfD4+NMnFV7RrIpztjZwp5qI
	 ovA/GWcAj+PY1XMue4Dqriaky8sbqcIoRsOjvIx0noVCDdimrxn1mWjl6ILxX/+8vGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795558757;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=B01mUzwAXs28NK4CVN5+CFcEjgarYzFHUCEYKNfC1F0=;
	b=2bRPGPptuMv6Jc/WekYvR+EDwblz/eYcZLvghJ6jsppBLjiFWLyjoily3hgBgrdGKwSM
	 kLw2WTfqzZTNkGXceasRCfmCmsTQh7tyyKehbZsyI+m/7oaW4vTHJGG1E5fhjiMkJUQvv
	 rLuXDXkcoCqEKkwGNn2hYZlRyWIcv7N7B92bZ2ETXTm2u+83qbwpcnZxXs3SGH1JzPz8I
	 NVUwfCiUBo9pT8I063Gnp1amLwGqG706HsxB3LcnZfCxNB8gYO8T+m6Ym4POgFk1tmW9a
	 bsq6jS/SdfaOvtrvUnal1n0DuuD1lA9IiT7TdfQSddOQ9AxMk3v+8zEF1LurNQwu/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DIPDhcgB;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A79E606A6B6;
	Tue, 24 Nov 2026 22:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A79E606A6B6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=DIPDhcgB
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMBASh1691505;
	Tue, 24 Nov 2026 14:18:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=B01mUzwAX
	s28NK4CVN5+CFcEjgarYzFHUCEYKNfC1F0=; b=DIPDhcgBOW4wpZ+jZ5v4fhaH9
	xpMdconKAniM87K7nB+w7YESZjU7PBxIu7cEWSE2YQsl691r9YXdcITf+HcS4xDW
	yg3iLY1ZZy8P+QSyCHZds1au7yFjBqw3ylboX/9G8Zx7A7oj48QFGtvWxpnMSShH
	PbOX0uRln5qZl1T55wyxFrU3lCMA9/TnRUUTthEUcuy24fqvRd0vhIN2M1i1WpKx
	JUBofx1Bqe7z9uKoB8mYFRrs+Bk2TFwBUUyYm8kmGhl75QhQVyRysgaOULBuN8y6
	FbIXnCEHhlxSOlXJQPfq2GgwN1zzkZ43Xs26HTzB99q7J8G/odofuLYQ0X8IQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5d6wud05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 24 Nov 2026 14:18:13 -0800 (PST)
Received: from localhost (2620:10d:c085:108::4) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Tue, 24 Nov
 2026 22:18:12 +0000
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
Subject: [PATCH net-next v3 00/12] psp: introduce socket-less associations
Date: Tue, 24 Nov 2026 14:17:46 -0800
Message-ID: <20261124221758.3230929-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX9GHzVzq2XTDg
 dRivfQF9/hT7sBJV3eGSswG/jgJyUyv7iAW6NnxDFGCo+gyjx71B6XrgJawtud1VXrnVybPCi9k
 G8YT+XM6p9D9ZKQ095iOuozimwpxB8Y=
X-Proofpoint-ORIG-GUID: GlLW5ypFQr7vhs0iJYuSyRfY6NTOTijc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NyBTYWx0ZWRfX35PWmBrehfTS
 SpdA5ZizRhUB/HA+QCt8nAbmepUgZKWw2QTfdNNneB3HnWwzt1Zfm+wFBfkLJHDiNfRe7x3twY5
 /lLpplfesE+NQ5XiHTiWLCYe+rO/tX3/Wi/7KNccr8WP3ywbaWDbjP7ilgzGqsRZ0nOCbbp0scv
 hRVzQor2EUnaKSoiSeipW11DQ4/oz1mfADAgGnbBt1o88aFN9YXpHOj6uAiggdQQs5IqRQe5Q10
 9zgiVQAMhJctUkyepvx9AkfeLj7XAPT3n5DJMCOO8D6/bgKMpJcqbPv8jPVKAYseIa78c/l3DTN
 ZXf46yJrA3sbsi9BN4Z9KG/emnJYd4AKscwUkmSAsyFPUuelltpGrrkUZrMTfTaooqN2njlDxnu
 GamUX0zu//s0kaNr2JptHSAk+EW503RLqHFilu6ig0PJLhrr0LKoVQg1+Ml8emrS7Ptwn5a+K9c
 y1p8Um0u7j17Sw5wcTQ==
X-Proofpoint-GUID: GlLW5ypFQr7vhs0iJYuSyRfY6NTOTijc
X-Authority-Analysis: v=2.4 cv=f5rdl+yM c=1 sm=1 tr=0 ts=6b060d26 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=NEAV23lmAAAA:8
 a=fSgYMpO5QbnG1SlCsgEA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01

PSP associations today are bound to a TCP socket when created. Traffic
on that socket is encapsulated in transport mode PSP, and encrypted.

This series adds PSP which isn't bound to a socket, which allows PSP
encapsulation and encryption to be applied to forwarded traffic. You can
use this to transparently apply PSP to flows, with help from userspace
to manage the tc rules and orchestrate key exchange.

Socket-less PSP is managed over the PSP netlink family. Tx associations
hold the peer's key in the device, and are addressable by ID, for the tc
psp encap action. Rx does not have any kernel state.

Since the kernel keeps no Rx state, it doesn't enforce key rotation for
socket-less Rx. Userspace must remove the decap rules of an SPI before a
second rotation lets the device allocate the same SPI again. The
documentation patch describes this, with ways to use tc to keep track of
the rules.

Series structure:

1, 2/ Prepare PSP to work with non-TCP packets.

3, 4/ Add the netlink commands for socket-less PSP.

5/ Adds a METADATA_PSP dst which carries a socket-less PSP association
on an skb for Tx, and the transmit checks for it.

6/ Adds the act_psp tc action, psp encap and psp decap. Encap is egress
only.

7/ Adds flower matches on PSP header fields, for Rx matching.

8, 9/ Add drv-net tests (netdevsim and hardware).

10/ Makes tc-testing run dependsOn probes outside the test namespace,
where they currently always fail.

11/ Adds tc-testing tests.

12/ Documentation for socket-less PSP.

A following series adds hardware offload of the psp actions and flower
matches, PSP tunnel mode (which is offload only and therefore not
included here), encap on ingress (also offload only), and the mlx5
implementation for switchdev mode. It's available in the tree below.

Relation to the PSP fixes in net:

 "psp, tls: don't send offloaded contents in cleartext"

 https://lore.kernel.org/netdev/20261124010601.3995693-1-toddfreed@meta.com

When net is merged into net-next:

 - net/psp/psp_main.c conflicts around psp_dev_encap_ok(), which both
   add: net's only allows TCP, this series' (patch 2) takes any L4
   protocol. Keep this series' version of the function, and its comments
   above it and above psp_dev_encapsulate().
 - tools/testing/selftests/drivers/net/psp.py and
   tools/testing/selftests/drivers/net/config conflict: keep both sides
   (imports, constants, the list of test cases; the NET_ACT_* options).

Relation to the netfilter fix in nf:

  "netfilter: reject: don't quote decrypted payload in icmp errors"

  https://lore.kernel.org/netfilter-devel/20261123231835.2356740-1-toddfreed@meta.com

Packets which a PSP device decrypted don't have to end in a local PSP
socket. They can already be forwarded or bridged today, but with
socket-less PSP that is the intended use, e.g. a router that decaps and
forwards. The netfilter reject expression in netdev and bridge chains
builds its own ICMP errors, outside icmp_send() and icmpv6_send(), which
the net series' ICMP patches cover. A separate patch to nf applies the
same rule there:

It doesn't depend on this series, and the two don't conflict.

Relation to the iproute2 series:

 "tc: add the psp action and flower psp matches"

 https://lore.kernel.org/netdev/20261112192426.397604-1-toddfreed@meta.com

adds tc support for the psp action and the flower psp matches, which the
tc selftests of this series need. It waits for this series' uAPI in
iproute2-next, and needs no change for v3: the tc uAPI is the same.

Trees:

The full tree, with the net fixes, the nf fix, this series and the mlx5
offload series, and the conflicts above resolved, is at:

 https://github.com/toddfreed/psptc branch psptc

The iproute2 series, plus tc support for the tunnel mode of the offload
series, is at:

 https://github.com/toddfreed/iproute2-psptc branch tc-psp

Testing:

 - netdevsim: drivers/net psp.py passes (72 tests), and tc-testing
   psp.json (16 tests), with tc from the iproute2-next series.
 - mlx5 (ConnectX-7, FW 28.48), two hosts: drivers/net psp.py passes:
   55 pass, 14 skip (GMAC versions not supported by the device),
   3 xfail (netdevsim only).
 - Each patch builds without warnings with gcc and clang, allmodconfig,
   W=1.

v3:
 - psp_dev_encapsulate(): refuse a packet with a checksum to complete
   (CHECKSUM_PARTIAL) for a next header other than TCP or UDP. (Sashiko)
 - Document the sockless_assocs list in struct psp_dev. (Sashiko)
 - The METADATA_PSP checks on the transmit path are now behind a static key,
   enabled while any METADATA_PSP dst exists.
 - flower: psp_dev 0 is rejected, PSP device IDs start at 1. (Sashiko)
 - psp.rst: rx-assoc allocates SPIs from the same space as rx-spi-alloc,
   so stale decap rules have to go before the device rotates, or as soon
   as it does; list the drop of a packet whose socket gained an offload
   while queued; a packet redirected to ingress after encap is delivered
   locally with skb->decrypted set.
   psp_xmit_md() kernel-doc. Selftests: assoc_sockless_tc no longer
   relies on tc to reject decap with an association, use the rekey
   series' helpers, and tdc 3203 and 006b match the kernel's extack. The
   tc-testing dependsOn fix says which probes failed. (Sashiko)
 - CC the maintainers which patchwork flagged.
 - Wrap lines over 80 columns (psp_nl.c, cls_flower.c), fix the unused
   variable and argument warnings in psp.py. psp.py keeps socket.timeout,
   which ruff flags (UP041): it is TimeoutError only from Python 3.10, and the
   kernel's minimum is 3.9.
 - Rebased on net-next.

v2: https://lore.kernel.org/netdev/20261119013103.1092559-1-toddfreed@meta.com
 - Moved the mirred, bpf and time-wait validator fixes (v1 patches 6-8)
   to a net series, with Fixes tags. (Daniel)
 - Don't store Rx associations at all (Daniel)
 - Keep socket-less Tx associations on their own device list (Daniel)
 - Documentation: the userspace key rotation contract, and the use of tc
   action cookies, filter handles and a chain per key phase to track
   decap rules. (Daniel)
 - act_psp: add .get_fill_size. (Sashiko, Jamal)
 - psp.py: use ctl_file_write(), and _check_data_outq() to wait for
   retransmits. (Sashiko)
 - tc-testing dependsOn fix: add a Fixes tag, and document the probe
   stage. (Sashiko)
 - Outer UDP source port: only use sk_hash for TCP sockets. (Sashiko)
 - flower: don't offload a rule which uses the PSP matches, and reject it
   with skip_sw, until a driver supports them: some drivers would offload
   it without them. (Sashiko)
 - Moved the drop of a packet with both a socket offload and a
   METADATA_PSP dst to the METADATA_PSP patch, with the rest of
   sk_validate_xmit_skb().
 - Say that encap on ingress isn't supported, rather than hardware
   offload only, in act_psp.c, psp.rst and the commit messages.
   (Sashiko)
 - psp.rst: an encapped packet is dropped if it loses its association
   or the PSP device is unregistered, not when the association is
   deleted. (Sashiko)
 - tc-testing: the tests of rejected psp actions match the kernel's
   extack, the decap with an association and encap without an
   association tests are dropped (tc rejects those itself), and the
   flower decap tests also probe for the psp action. (Sashiko)
 - Rebased on net-next.

v1: https://lore.kernel.org/netdev/20261111005533.6436-1-toddfreed@meta.com

Todd Freed (12):
  psp: get netns from net_device instead of sock
  psp: take the psp nexthdr from the packet on encap
  psp: declare psp_assoc_set_tx() in psp.h
  psp: add support for socket-less psp associations
  net: add METADATA_PSP dst to carry a psp association on an skb
  net/sched: add act_psp for psp transport mode
  net/sched: flower: add psp_spi, psp_ver, and psp_dev matches
  selftests: drv-net: psp: test socket-less associations and the tc psp
    action
  selftests: drv-net: psp: test that software encap on ingress drops
  selftests: tc-testing: run dependsOn probes outside the test namespace
  selftests: tc-testing: add tests for the psp action
  Documentation: networking: psp: document socket-less associations

 Documentation/netlink/specs/psp.yaml          |  91 +++
 Documentation/netlink/specs/tc.yaml           |  19 +
 Documentation/networking/psp.rst              | 182 ++++-
 MAINTAINERS                                   |   3 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  33 +
 drivers/net/netdevsim/psp.c                   |   2 +-
 include/linux/skbuff.h                        |   4 +
 include/net/dst_metadata.h                    |  19 +
 include/net/flow_dissector.h                  |  18 +
 include/net/psp/functions.h                   | 106 ++-
 include/net/psp/types.h                       |   4 +
 include/net/tc_act/tc_psp.h                   |  23 +
 include/uapi/linux/pkt_cls.h                  |   6 +
 include/uapi/linux/psp.h                      |   6 +
 include/uapi/linux/tc_act/tc_psp.h            |  28 +
 net/core/dev.c                                |  50 +-
 net/core/dst.c                                |   5 +
 net/core/flow_dissector.c                     |  27 +
 net/psp/Makefile                              |   2 +-
 net/psp/psp-nl-gen.c                          |  60 ++
 net/psp/psp-nl-gen.h                          |   8 +
 net/psp/psp.h                                 |   7 +
 net/psp/psp_assoc.c                           | 122 ++++
 net/psp/psp_main.c                            | 104 ++-
 net/psp/psp_nl.c                              | 244 +++++++
 net/psp/psp_sock.c                            |  16 +-
 net/sched/Kconfig                             |  13 +
 net/sched/Makefile                            |   1 +
 net/sched/act_psp.c                           | 437 ++++++++++++
 net/sched/cls_flower.c                        |  76 ++
 tools/testing/selftests/drivers/net/config    |   5 +
 tools/testing/selftests/drivers/net/psp.py    | 668 +++++++++++++++++-
 tools/testing/selftests/tc-testing/README     |   1 +
 tools/testing/selftests/tc-testing/config     |   2 +
 .../creating-testcases/AddingTestCases.txt    |   4 +-
 .../tc-testing/tc-tests/actions/psp.json      | 427 +++++++++++
 tools/testing/selftests/tc-testing/tdc.py     |   2 +-
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 39 files changed, 2777 insertions(+), 51 deletions(-)
 create mode 100644 include/net/tc_act/tc_psp.h
 create mode 100644 include/uapi/linux/tc_act/tc_psp.h
 create mode 100644 net/psp/psp_assoc.c
 create mode 100644 net/sched/act_psp.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/psp.json


base-commit: c2621b518b38ed38e280e008aa33e6c2d302f8cc
-- 
2.53.1-Meta

