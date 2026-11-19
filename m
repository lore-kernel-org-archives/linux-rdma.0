Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051891;
	b=Ny7Aq4kDHC/6IgBzYYhLSomTlhUobIWUX2X67conAvKseRqGSJv718wNwtOZdEjGs96R
	 3qku8niPvJF3hk0JGmySv4YD03WCuyKkx7w6kGN+CRaMKsAkGIueaUcj3GJgVNuUESECw
	 517OFZkRv66ulAJOh0wccd64114r/bulLPPb72cQRpMYEqB9g5l8RViCv8kXsE1cfqZap
	 MvaR/4rDJ/dP2A8McwDjKdhZ3vrcW8NPTn2d0YeJtVTZPyv8BigKT8FdVajOV/oCEC160
	 a4BN6UhJ4NuqOP4q2kfUkAhCe2Y6TpN4CjS2iVuYhI5n7FxN8mHazOq6NBJUtNgGliw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051891;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=8srwcl49PJdXgq0xiXSN9SIObQXzL4bu6FkqZ4QnNdU=;
	b=Abg1o+brTAlVqjmw/+oXYTeVuVS4QWkg+pbsGXcv85NjKKBjmzXNpnVwlysUap10yCB4
	 RPQuIF7gyM0ah8IWyyQ+x0CknGU2nIY5C/COSjd1/WfBvP5xqlMyZLmGawqLQpewUrsTA
	 Ng3vWQmGdYtn0PQF13jzAzBRHm28Y1J0mu4izkWCmrw8xDNzphThx9kwgXatbnZT1D2b/
	 2MNaZeu3yqPDofjPngvknHC++6v2tqMBhKPrIzprQVLkni2ahu+KfBYzubL+Dax2BHQs0
	 GdH0PLGV/eEH63XXb5ZW3o9kiX/HfNlO+OXNEQRc5TJMIzqYKGkx7bgpNmDke0oW98Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MwsTwDPD;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6889B606A32F;
	Thu, 19 Nov 2026 01:31:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6889B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=MwsTwDPD
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AJ192Hf1506716;
	Wed, 18 Nov 2026 17:31:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=8srwcl49P
	JdXgq0xiXSN9SIObQXzL4bu6FkqZ4QnNdU=; b=MwsTwDPDHMyclU8Oe0VWR+CGA
	5LJUN+qKXs+83Xs9FoJojVPzelyOOIODgerfG8wc54y689cISdez5CYdvWZiN0zL
	wzBOvLJ5eBoqM5OuEGxdJO6hZJmM9rxuMO2+RcGLHQ6uCm6Mgtx6V+nduZ3U2gBd
	KIvS4UXBeIvYQ/3xzjG3inE8NGtYyy7r09e1OdFrdyTp2O3+kJ4d5TSVz3xCL0Ks
	ydBypHxLqixBm/1nktRrIlPVWlXYzHsgqXMSFwUxWm5jgh7F//JOVgZEn1AjF0Z9
	fNHMNy/fLSLRlJt+SxNjoZ4ngMKmYNKA9k8yGpbkeaxh5kf5PqlT83tT41drQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu638ck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 18 Nov 2026 17:31:13 -0800 (PST)
Received: from localhost (2620:10d:c085:208::f) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Thu, 19 Nov
 2026 01:31:12 +0000
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
Subject: [PATCH net-next v2 00/12] psp: introduce socket-less associations
Date: Wed, 18 Nov 2026 17:30:51 -0800
Message-ID: <20261119013103.1092559-1-toddfreed@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfX4UYxQy0J1/V3
 6tKRyotSjhhsEVn1qFaVbTtkW/jcNfkwbkNzSNhovyyAiIETbOA0Dnkx9oB02bbFOSAU2o1PYDw
 UxDo4teRriYhlqVIcc7ztIZZWC5CI7CDXMP1gdKjANyS6HdAFv94MemtlgUz+76L525FRx6noUO
 gJRu7TMNEzAVvKHsxr+qpbcr5Dq/GbmRyYip/gKDwboX3fO4el4CBu9YjrUfjp77lcPckXi5ZFy
 cTNcYOVvyMIMjlTwQL9MUySLBY2pYgmXbFoftEqv6dyGDoUUf/rys6FShG9Dd/JFP/0JMIPwC1k
 YdvlD5o0F8y9EqGwTnBnQDaykvcRaML+sVx5GtFni/RSV/76hn84NwulIQxmz+UHjKkG4+0G4N7
 5j1BGi1s20ArRZ42LVkeHwg3auHPNGaCHDLp3jykKY5sVFSsuG6OIZpEKX1VdnU392Yu7CACCAY
 Q0e9V8zzP4E+ygZDRaQ==
X-Proofpoint-GUID: f3XHWQRL6_3J7nqzBh7Gli-QRORnfLod
X-Proofpoint-ORIG-GUID: f3XHWQRL6_3J7nqzBh7Gli-QRORnfLod
X-Authority-Analysis: v=2.4 cv=dbgVTnXe c=1 sm=1 tr=0 ts=6afe5161 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=NEAV23lmAAAA:8
 a=fSgYMpO5QbnG1SlCsgEA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE5MDAwNSBTYWx0ZWRfXzcVRw+iA2cKK
 7olH4Dn40hIwKGe6EEZf12p5BRojeh9WFJuu49cvGdcPI7vWq1bSmNtB2BcGh7HlbUTWrnSqF1U
 1K6vEmEFE6abtKSv+4mD36H7715ErX0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-19_01,2026-11-16_01,2025-10-01_01

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

Dependency on net:

v1 patches 6-8 are now a separate series to net:

  "net: don't redirect decrypted skbs to ingress, psp time-wait validator"

  https://lore.kernel.org/netdev/20261117192411.247117-1-toddfreed@meta.com

This series builds without it, but relies on it: act_psp marks the
packets it encaps decrypted, which mirred and bpf must not send back to
ingress (the data_tc_encap_ingress test fails without the fix), and
act_psp drops packets of sockets with a validator, which non-PSP
time-wait sockets have without the fix.

Relation to the PSP fixes in net:

 "psp, tls: don't send offloaded contents in cleartext"

 https://lore.kernel.org/netdev/20261117203137.804424-1-toddfreed@meta.com

When net is merged into net-next:

 - net/psp/psp_main.c conflicts around psp_dev_encap_ok(), which both
   add: net's only allows TCP, this series' (patch 2) takes any L4
   protocol. Keep this series' version of the function, and its comments
   above it and above psp_dev_encapsulate().
 - tools/testing/selftests/drivers/net/psp.py and
   tools/testing/selftests/drivers/net/config conflict: keep both sides
   (imports, constants, the list of test cases; the NET_ACT_* options).

Relation to the netfilter fixes in nf-next:

Packets which a PSP device decrypted don't have to end in a local PSP
socket. They can already be forwarded or bridged today, but with
socket-less PSP that is the intended use, e.g. a router that decaps and
forwards. Netfilter handles two cases itself, outside the IP stack paths
which the net series fixes, and would send such a packet's decrypted
contents in clear text:

 - The bridge refragments packets which bridge conntrack reassembled
   (br_ip6_fragment(), nf_br_ip_fragment()), without the check of "net:
   don't fragment decrypted skbs".
 - The reject code builds its own ICMP errors and TCP resets
   (nf_reject_skb_v4_unreach() and friends), without icmp_send() and
   icmpv6_send(), which the net series' ICMP patches cover.

A separate series to nf-next applies the net series' rules to both:

  "netfilter: bridge: don't refragment decrypted skbs"
  "netfilter: reject: don't reply to decrypted skbs"

  https://lore.kernel.org/netfilter-devel/20261111003111.3826942-1-toddfreed@meta.com

It doesn't depend on this series, and the two don't conflict.

Trees:

The full tree, with the net fixes, the nf-next series, this series and
the mlx5 offload series, and the conflicts above resolved, is at:

 https://github.com/toddfreed/psptc branch psptc

iproute2 support for the psp action and the PSP flower matches, which
the selftests need, is posted to iproute2-next as "tc: add the psp
action and flower psp matches", and at:

 https://github.com/toddfreed/iproute2-psptc branch tc-psp

It needs no change for v2: the tc uAPI is the same.

Testing:

 - netdevsim: drivers/net psp.py passes (57 tests), and tc-testing
   psp.json (15 tests), with the net fixes series applied and tc from
   the iproute2-next series.
 - mlx5 (ConnectX-7, FW 28.48), two hosts: drivers/net psp.py passes:
   46 pass, 8 skip (GMAC versions not supported by the device),
   3 xfail (netdevsim only), with the net fixes series applied.
 - Each patch builds without warnings with gcc and clang, allmodconfig,
   W=1.

v2:
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
 Documentation/netlink/specs/tc.yaml           |  14 +
 Documentation/networking/psp.rst              | 169 +++-
 MAINTAINERS                                   |   3 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  33 +
 drivers/net/netdevsim/psp.c                   |   2 +-
 include/linux/skbuff.h                        |   4 +
 include/net/dst_metadata.h                    |  19 +
 include/net/flow_dissector.h                  |  18 +
 include/net/psp/functions.h                   |  82 +-
 include/net/psp/types.h                       |   2 +
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
 net/psp/psp_assoc.c                           | 122 +++
 net/psp/psp_main.c                            |  62 +-
 net/psp/psp_nl.c                              | 242 ++++++
 net/psp/psp_sock.c                            |  16 +-
 net/sched/Kconfig                             |  13 +
 net/sched/Makefile                            |   1 +
 net/sched/act_psp.c                           | 439 +++++++++++
 net/sched/cls_flower.c                        |  74 ++
 tools/testing/selftests/drivers/net/config    |   5 +
 tools/testing/selftests/drivers/net/psp.py    | 729 +++++++++++++++++-
 tools/testing/selftests/tc-testing/README     |   1 +
 tools/testing/selftests/tc-testing/config     |   2 +
 .../creating-testcases/AddingTestCases.txt    |   4 +-
 .../tc-testing/tc-tests/actions/psp.json      | 403 ++++++++++
 tools/testing/selftests/tc-testing/tdc.py     |   2 +-
 tools/testing/selftests/tc-testing/tdc.sh     |   1 +
 39 files changed, 2727 insertions(+), 50 deletions(-)
 create mode 100644 include/net/tc_act/tc_psp.h
 create mode 100644 include/uapi/linux/tc_act/tc_psp.h
 create mode 100644 net/psp/psp_assoc.c
 create mode 100644 net/sched/act_psp.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/psp.json


base-commit: 89f0fb60afdb35cf2a94e6279c8960feb1c4d1d4
-- 
2.53.1-Meta

