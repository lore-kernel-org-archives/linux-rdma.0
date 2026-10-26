Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051581;
	b=0FiO2ZaiDYUyt2N2zQyRpT/hv2M/OXZwAM4bvMWjZP4OYbxN1yzrk4mjiolowZ5AKZ/9
	 zU7LJuWt4ChHqWiMoXy10NRyh6gjG/XYh4EuwauIIh3bbtXpIkXvgaTc3MUfAstRplEZo
	 +aZfj1eRlpTm5CjsdHairuhDFUUSIxp6T/06QfaXCieUsufr6+P/QzeI7k3HDafYRUDoL
	 sKKLKP9LlJSvpKxcFcx+/n0KgSWg9qllgY7RhLLvur8+cgHrHM6vTbsIJZQ6VMbFb7eYk
	 4G6lmY6qF83dbg09vldZJYHmerXcRcRlo5h9taA7NTwjUne7RSkV7urfE4lmzq7cwbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051581;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qjaWG0vALGiJXc9hywX7QkL7t3I6sNsh0eoNehj0+/k=;
	b=sqsUXGb/MVML3LDWT3fCLJu2FLntTlfzO63TGfm1Wo25i7Tbhf6SUGix35uhGTJOyp/v
	 3G1S9TnD4Gzdv2NTnhEmdIQkVoYNvxGTDXqkORIO62C3F6mcpaTCZfMJ8eY+dW+ca4o4g
	 wOCARtrTw6UxvBORSJEDn/3a13/pGTeuVuiklKVUY+Umcl/suYxDhNeGopNyilWpzHyAF
	 BKdL0qGCDlUC0Li/sKUWx4S6ml+pcFwV7H2ev27F8myYVGWGatqbFEYRTgoPhDUA8dO7F
	 P7oc8EHe9aWnfOXB+whH+JKguZaiQd4JZfgzjxo4fIMV5KGegT2M/kw72csh44XrARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RrvwS5NR;
	arc=none smtp.remote-ip=91.218.175.159
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384A5606B4FB
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 21:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 384A5606B4FB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RrvwS5NR
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2VHdcLoDAHqWj/aS7wBNbfZc2c84UrFVRNmu7PCGSgE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793051578; v=1; x=1793656378;
 b=RrvwS5NRFA2T4Yvbv3DRLWwHIcNMEkQX2X3MWUFDdrPwQEqQf838ndOF+dW47Lh1yWWieFlz
 rjHABWIVSGKmVG+WQKkSGFGCF125SGCHrC3GkVifQCQEO6MWGHNExQGaxmYIG6Jl7nbiSgCHl3r
 5P9esBtKue/sdK0aXbkk4w7s=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cf730e25b9246161;
	Mon, 26 Oct 2026 21:52:58 +0000
X-Mizu-Trace-ID: cf730e25b9246161
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v4 1/2] selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE
Date: Mon, 26 Oct 2026 14:52:35 -0700
Message-ID: <20261026215236.60054-2-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026215236.60054-1-yanjun.zhu@linux.dev>
References: <20261026215236.60054-1-yanjun.zhu@linux.dev>
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

Add eBPF-based kernel and user-space packet dump utilities along with a
netkit test script (rxe_pkg_netkit.sh) to tools/testing/selftests/rdma/.
This enables capturing and parsing Soft-RoCE (RXE) traffic over netkit
devices for testing purposes.

Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 tools/testing/selftests/rdma/Makefile         |   24 +-
 tools/testing/selftests/rdma/config           |    3 +
 tools/testing/selftests/rdma/rxe_pkg_common.h |   17 +
 .../selftests/rdma/rxe_pkg_kernel_dump.c      |   78 +
 .../selftests/rdma/rxe_pkg_user_dump.c        | 1365 +++++++++++++++++
 5 files changed, 1486 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_common.h
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_user_dump.c

diff --git a/tools/testing/selftests/rdma/Makefile b/tools/testing/selftests/rdma/Makefile
index a91c14c45006..f7783c20f40d 100644
--- a/tools/testing/selftests/rdma/Makefile
+++ b/tools/testing/selftests/rdma/Makefile
@@ -4,6 +4,28 @@ TEST_PROGS := rxe_rping_between_netns.sh \
 		rxe_socket_with_netns.sh \
 		rxe_test_NETDEV_UNREGISTER.sh \
 		rxe_sent_rcvd_bytes.sh \
-		rxe_netns_names.sh
+		rxe_netns_names.sh \
+		rxe_pkg_netkit.sh
 
+TEST_GEN_PROGS_EXTENDED := rxe_netkit_dump
 include ../lib.mk
+
+CLANG	?= clang
+LLC	?= llc
+BPFTOOL	?= bpftool
+ARCH ?= $(shell uname -m | sed 's/x86_64/x86/' | sed 's/aarch64/arm64/' | sed 's/ppc64le/powerpc/')
+
+INCLUDES	:= -I../../../../usr/include -I../../../../include/uapi -I../bpf -I$(OUTPUT)
+CFLAGS		+= -g -Wall $(INCLUDES)
+LDFLAGS		+= -lbpf -lelf -lz
+
+$(OUTPUT)/rxe_netkit_dump: rxe_pkg_user_dump.c $(OUTPUT)/rxe_pkg_kernel.skel.h
+	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@
+
+$(OUTPUT)/rxe_pkg_kernel_dump.o: rxe_pkg_kernel_dump.c rxe_pkg_common.h
+	$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH) $(INCLUDES) -c $< -o $@
+
+$(OUTPUT)/rxe_pkg_kernel.skel.h: $(OUTPUT)/rxe_pkg_kernel_dump.o
+	$(BPFTOOL) gen skeleton $< > $@
+
+EXTRA_CLEAN := $(OUTPUT)/rxe_pkg_kernel_dump.o $(OUTPUT)/rxe_pkg_kernel.skel.h $(OUTPUT)/rxe_pkg_kernel.skel.h.tmp
diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
index e1ff54ec0f57..a98ffa95b0b7 100644
--- a/tools/testing/selftests/rdma/config
+++ b/tools/testing/selftests/rdma/config
@@ -3,3 +3,6 @@ CONFIG_VETH
 CONFIG_DUMMY
 CONFIG_NET_NS
 CONFIG_RDMA_RXE
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_NETKIT=y
diff --git a/tools/testing/selftests/rdma/rxe_pkg_common.h b/tools/testing/selftests/rdma/rxe_pkg_common.h
new file mode 100644
index 000000000000..0dca4147d5f9
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_common.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
+ */
+
+// rxe_pkg_common.h
+#ifndef RXE_PKG_COMMON_H
+#define RXE_PKG_COMMON_H
+
+#define MAX_PKT_LEN 512
+
+struct pkg_event {
+	__u32 len;
+	__u8 data[MAX_PKT_LEN];
+};
+
+#endif
diff --git a/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
new file mode 100644
index 000000000000..2030529f94af
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <arpa/inet.h>
+
+#include "rxe_pkg_common.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 256 * 1024);/* Shared by all CPUs */
+} rb SEC(".maps");
+
+SEC("netkit/primary")
+int handle_netkit_ingress(struct __sk_buff *skb)
+{
+	/* Get the header pointer of skb */
+	void *data_end = (void *)(long)skb->data_end;
+	void *data = (void *)(long)skb->data;
+
+	struct ethhdr *eth = data;
+
+	/* Verify the data */
+	if (data + sizeof(*eth) > data_end)
+		return BPF_OK;
+
+	/* Check if it is IP skb */
+	if (eth->h_proto == bpf_htons(ETH_P_IP)) {
+		struct iphdr *iph = data + sizeof(*eth);
+
+		if ((void *)iph + sizeof(*iph) <= data_end) {
+			bpf_printk("Got IP packet from netkit ingress, %d\n", skb->len);
+
+			__u32 len = skb->len;
+
+			/* It is a rping test, the size of packets should be
+			 * less than MAX_PKT_LEN
+			 */
+			if (len == 0 || len > MAX_PKT_LEN) {
+				bpf_printk("len is not in 0..MAX_PKT_LEN\n");
+				return BPF_OK;
+			}
+
+			struct pkg_event *e;
+
+			/* The len is fixed to MAX_PKT_LEN */
+			e = bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
+
+			if (!e) {
+				bpf_printk("bpf_ringbuf_reserve fails\n");
+				return BPF_OK;
+			}
+
+			e->len = len;
+
+			if (bpf_skb_load_bytes(skb, 0, e->data, len) < 0) {
+				bpf_ringbuf_discard(e, 0);
+				bpf_printk("bpf_skb_load_bytes fails\n");
+				return BPF_OK;
+			}
+
+			bpf_ringbuf_submit(e, 0);
+		}
+	}
+
+	/* BPF_OK:	Pass
+	 * BPF_DROP:	Drop skb
+	 */
+	return BPF_OK;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/rdma/rxe_pkg_user_dump.c b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c
new file mode 100644
index 000000000000..5d51e7d1af66
--- /dev/null
+++ b/tools/testing/selftests/rdma/rxe_pkg_user_dump.c
@@ -0,0 +1,1365 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2026 Zhu Yanjun <yanjun.zhu@linux.dev>
+ */
+
+#include <stdio.h>
+#include <sys/resource.h>
+#include <net/if.h>
+#include "rxe_pkg_kernel.skel.h"
+
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <ctype.h>
+
+#include <net/ethernet.h>
+#include <arpa/inet.h>
+
+#include <signal.h>
+
+#include "rxe_pkg_common.h"
+
+typedef __u8 u8;
+typedef __u16 u16;
+typedef __u32 u32;
+typedef __u64 u64;
+
+struct rxe_bth {
+	__u8		opcode;
+	__u8		flags;
+	__be16		pkey;
+	__be32		qpn;
+	__be32		apsn;
+};
+
+struct rxe_immdt {
+	__be32		imm;
+};
+
+struct rxe_reth {
+	__be64		va;
+	__be32		rkey;
+	__be32		len;
+};
+
+struct rxe_aeth {
+	__be32		smsn;
+};
+
+/******************************************************************************
+ * Atomic Ack Extended Transport Header
+ ******************************************************************************/
+struct rxe_atmack {
+	__be64		orig;
+};
+
+/******************************************************************************
+ * Invalidate Extended Transport Header
+ ******************************************************************************/
+struct rxe_ieth {
+	__be32		rkey;
+};
+
+/******************************************************************************
+ * Datagram Extended Transport Header
+ ******************************************************************************/
+struct rxe_deth {
+	__be32	qkey;
+	__be32	sqp;
+};
+
+#define IB_OPCODE(transport, op) \
+	IB_OPCODE_ ## transport ## _ ## op = \
+		IB_OPCODE_ ## transport + IB_OPCODE_ ## op
+
+enum {
+	/* transport types -- just used to define real constants */
+	IB_OPCODE_RC                                = 0x00,
+	IB_OPCODE_UC                                = 0x20,
+	IB_OPCODE_RD                                = 0x40,
+	IB_OPCODE_UD                                = 0x60,
+	/* per IBTA 1.3 vol 1 Table 38, A10.3.2 */
+	IB_OPCODE_CNP                               = 0x80,
+	/* Manufacturer specific */
+	IB_OPCODE_MSP                               = 0xe0,
+
+	/* operations -- just used to define real constants */
+	IB_OPCODE_SEND_FIRST                        = 0x00,
+	IB_OPCODE_SEND_MIDDLE                       = 0x01,
+	IB_OPCODE_SEND_LAST                         = 0x02,
+	IB_OPCODE_SEND_LAST_WITH_IMMEDIATE          = 0x03,
+	IB_OPCODE_SEND_ONLY                         = 0x04,
+	IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE          = 0x05,
+	IB_OPCODE_RDMA_WRITE_FIRST                  = 0x06,
+	IB_OPCODE_RDMA_WRITE_MIDDLE                 = 0x07,
+	IB_OPCODE_RDMA_WRITE_LAST                   = 0x08,
+	IB_OPCODE_RDMA_WRITE_LAST_WITH_IMMEDIATE    = 0x09,
+	IB_OPCODE_RDMA_WRITE_ONLY                   = 0x0a,
+	IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE    = 0x0b,
+	IB_OPCODE_RDMA_READ_REQUEST                 = 0x0c,
+	IB_OPCODE_RDMA_READ_RESPONSE_FIRST          = 0x0d,
+	IB_OPCODE_RDMA_READ_RESPONSE_MIDDLE         = 0x0e,
+	IB_OPCODE_RDMA_READ_RESPONSE_LAST           = 0x0f,
+	IB_OPCODE_RDMA_READ_RESPONSE_ONLY           = 0x10,
+	IB_OPCODE_ACKNOWLEDGE                       = 0x11,
+	IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
+	IB_OPCODE_COMPARE_SWAP                      = 0x13,
+	IB_OPCODE_FETCH_ADD                         = 0x14,
+	/* opcode 0x15 is reserved */
+	IB_OPCODE_SEND_LAST_WITH_INVALIDATE         = 0x16,
+	IB_OPCODE_SEND_ONLY_WITH_INVALIDATE         = 0x17,
+
+	/* real constants follow -- see comment about above IB_OPCODE()
+	 * macro for more details
+	 */
+
+	/* RC */
+	IB_OPCODE(RC, SEND_FIRST),
+	IB_OPCODE(RC, SEND_MIDDLE),
+	IB_OPCODE(RC, SEND_LAST),
+	IB_OPCODE(RC, SEND_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(RC, SEND_ONLY),
+	IB_OPCODE(RC, SEND_ONLY_WITH_IMMEDIATE),
+	IB_OPCODE(RC, RDMA_WRITE_FIRST),
+	IB_OPCODE(RC, RDMA_WRITE_MIDDLE),
+	IB_OPCODE(RC, RDMA_WRITE_LAST),
+	IB_OPCODE(RC, RDMA_WRITE_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(RC, RDMA_WRITE_ONLY),
+	IB_OPCODE(RC, RDMA_WRITE_ONLY_WITH_IMMEDIATE),
+	IB_OPCODE(RC, RDMA_READ_REQUEST),
+	IB_OPCODE(RC, RDMA_READ_RESPONSE_FIRST),
+	IB_OPCODE(RC, RDMA_READ_RESPONSE_MIDDLE),
+	IB_OPCODE(RC, RDMA_READ_RESPONSE_LAST),
+	IB_OPCODE(RC, RDMA_READ_RESPONSE_ONLY),
+	IB_OPCODE(RC, ACKNOWLEDGE),
+	IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
+	IB_OPCODE(RC, COMPARE_SWAP),
+	IB_OPCODE(RC, FETCH_ADD),
+	IB_OPCODE(RC, SEND_LAST_WITH_INVALIDATE),
+	IB_OPCODE(RC, SEND_ONLY_WITH_INVALIDATE),
+
+	/* UC */
+	IB_OPCODE(UC, SEND_FIRST),
+	IB_OPCODE(UC, SEND_MIDDLE),
+	IB_OPCODE(UC, SEND_LAST),
+	IB_OPCODE(UC, SEND_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(UC, SEND_ONLY),
+	IB_OPCODE(UC, SEND_ONLY_WITH_IMMEDIATE),
+	IB_OPCODE(UC, RDMA_WRITE_FIRST),
+	IB_OPCODE(UC, RDMA_WRITE_MIDDLE),
+	IB_OPCODE(UC, RDMA_WRITE_LAST),
+	IB_OPCODE(UC, RDMA_WRITE_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(UC, RDMA_WRITE_ONLY),
+	IB_OPCODE(UC, RDMA_WRITE_ONLY_WITH_IMMEDIATE),
+
+	/* RD */
+	IB_OPCODE(RD, SEND_FIRST),
+	IB_OPCODE(RD, SEND_MIDDLE),
+	IB_OPCODE(RD, SEND_LAST),
+	IB_OPCODE(RD, SEND_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(RD, SEND_ONLY),
+	IB_OPCODE(RD, SEND_ONLY_WITH_IMMEDIATE),
+	IB_OPCODE(RD, RDMA_WRITE_FIRST),
+	IB_OPCODE(RD, RDMA_WRITE_MIDDLE),
+	IB_OPCODE(RD, RDMA_WRITE_LAST),
+	IB_OPCODE(RD, RDMA_WRITE_LAST_WITH_IMMEDIATE),
+	IB_OPCODE(RD, RDMA_WRITE_ONLY),
+	IB_OPCODE(RD, RDMA_WRITE_ONLY_WITH_IMMEDIATE),
+	IB_OPCODE(RD, RDMA_READ_REQUEST),
+	IB_OPCODE(RD, RDMA_READ_RESPONSE_FIRST),
+	IB_OPCODE(RD, RDMA_READ_RESPONSE_MIDDLE),
+	IB_OPCODE(RD, RDMA_READ_RESPONSE_LAST),
+	IB_OPCODE(RD, RDMA_READ_RESPONSE_ONLY),
+	IB_OPCODE(RD, ACKNOWLEDGE),
+	IB_OPCODE(RD, ATOMIC_ACKNOWLEDGE),
+	IB_OPCODE(RD, COMPARE_SWAP),
+	IB_OPCODE(RD, FETCH_ADD),
+
+	/* UD */
+	IB_OPCODE(UD, SEND_ONLY),
+	IB_OPCODE(UD, SEND_ONLY_WITH_IMMEDIATE)
+};
+
+enum rxe_hdr_type {
+	RXE_LRH,
+	RXE_GRH,
+	RXE_BTH,
+	RXE_RETH,
+	RXE_AETH,
+	RXE_ATMETH,
+	RXE_ATMACK,
+	RXE_IETH,
+	RXE_RDETH,
+	RXE_DETH,
+	RXE_IMMDT,
+	RXE_PAYLOAD,
+	NUM_HDR_TYPES
+};
+
+#define RXE_NUM_OPCODE		256
+
+struct rxe_opcode_info {
+	char			*name;
+	int			length;
+	int			offset[NUM_HDR_TYPES];
+};
+
+/******************************************************************************
+ * Atomic Extended Transport Header
+ ******************************************************************************/
+struct rxe_atmeth {
+	__be64			va;
+	__be32			rkey;
+	__be64			swap_add;
+	__be64			comp;
+} __attribute__((packed));
+
+/******************************************************************************
+ * Reliable Datagram Extended Transport Header
+ ******************************************************************************/
+struct rxe_rdeth {
+	__be32			een;
+};
+
+enum rxe_hdr_length {
+	RXE_BTH_BYTES		= sizeof(struct rxe_bth),
+	RXE_DETH_BYTES		= sizeof(struct rxe_deth),
+	RXE_IMMDT_BYTES		= sizeof(struct rxe_immdt),
+	RXE_RETH_BYTES		= sizeof(struct rxe_reth),
+	RXE_AETH_BYTES		= sizeof(struct rxe_aeth),
+	RXE_ATMACK_BYTES	= sizeof(struct rxe_atmack),
+	RXE_ATMETH_BYTES	= sizeof(struct rxe_atmeth),
+	RXE_IETH_BYTES		= sizeof(struct rxe_ieth),
+	RXE_RDETH_BYTES		= sizeof(struct rxe_rdeth),
+};
+
+struct rxe_opcode_info rxe_opcode[RXE_NUM_OPCODE] = {
+	[IB_OPCODE_RC_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_RC_SEND_FIRST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_SEND_MIDDLE",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST]			= {
+		.name	= "IB_OPCODE_RC_SEND_LAST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_FIRST",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_MIDDLE",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_LAST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_ONLY",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_REQUEST]			= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_REQUEST",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_FIRST",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_AETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_AETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY]		= {
+		.name	= "IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_AETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RC_ACKNOWLEDGE",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_AETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE",
+		.length = RXE_BTH_BYTES + RXE_ATMACK_BYTES + RXE_AETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_AETH]	= RXE_BTH_BYTES,
+			[RXE_ATMACK]	= RXE_BTH_BYTES +
+					  RXE_AETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_ATMACK_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_COMPARE_SWAP]			= {
+		.name	= "IB_OPCODE_RC_COMPARE_SWAP",
+		.length = RXE_BTH_BYTES + RXE_ATMETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_ATMETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_ATMETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_FETCH_ADD]			= {
+		.name	= "IB_OPCODE_RC_FETCH_ADD",
+		.length = RXE_BTH_BYTES + RXE_ATMETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_ATMETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_ATMETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_LAST_WITH_INVALIDATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_LAST_WITH_INVALIDATE",
+		.length = RXE_BTH_BYTES + RXE_IETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RC_SEND_ONLY_WITH_INVALIDATE]		= {
+		.name	= "IB_OPCODE_RC_SEND_ONLY_INV",
+		.length = RXE_BTH_BYTES + RXE_IETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IETH_BYTES,
+		}
+	},
+
+	/* UC */
+	[IB_OPCODE_UC_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_UC_SEND_FIRST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_UC_SEND_MIDDLE",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_LAST]			= {
+		.name	= "IB_OPCODE_UC_SEND_LAST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_SEND_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_UC_SEND_ONLY",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_SEND_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_FIRST",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_MIDDLE",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_LAST",
+		.length = RXE_BTH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_IMMDT]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_ONLY",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UC_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_RETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RETH]	= RXE_BTH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+
+	/* RD */
+	[IB_OPCODE_RD_SEND_FIRST]			= {
+		.name	= "IB_OPCODE_RD_SEND_FIRST",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_SEND_MIDDLE",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_LAST]			= {
+		.name	= "IB_OPCODE_RD_SEND_LAST",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_SEND_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_RD_SEND_ONLY",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_SEND_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_FIRST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_FIRST",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_RETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_MIDDLE",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_LAST]			= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_LAST",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_LAST_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_LAST_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_ONLY]			= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_ONLY",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_RETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_WRITE_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_WRITE_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_RETH_BYTES +
+			  RXE_DETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_RETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_REQUEST]			= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_REQUEST",
+		.length = RXE_BTH_BYTES + RXE_RETH_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_RETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_FIRST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_FIRST",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_AETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_MIDDLE]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_MIDDLE",
+		.length = RXE_BTH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_LAST]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_LAST",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_AETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_RDMA_READ_RESPONSE_ONLY]		= {
+		.name	= "IB_OPCODE_RD_RDMA_READ_RESPONSE_ONLY",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_AETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RD_ACKNOWLEDGE",
+		.length = RXE_BTH_BYTES + RXE_AETH_BYTES + RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_AETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_ATOMIC_ACKNOWLEDGE]			= {
+		.name	= "IB_OPCODE_RD_ATOMIC_ACKNOWLEDGE",
+		.length = RXE_BTH_BYTES + RXE_ATMACK_BYTES + RXE_AETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_AETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_ATMACK]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_AETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_COMPARE_SWAP]			= {
+		.name	= "RD_COMPARE_SWAP",
+		.length = RXE_BTH_BYTES + RXE_ATMETH_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_ATMETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_ATMETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RDETH_BYTES,
+		}
+	},
+	[IB_OPCODE_RD_FETCH_ADD]			= {
+		.name	= "IB_OPCODE_RD_FETCH_ADD",
+		.length = RXE_BTH_BYTES + RXE_ATMETH_BYTES + RXE_DETH_BYTES +
+			  RXE_RDETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_RDETH]	= RXE_BTH_BYTES,
+			[RXE_DETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES,
+			[RXE_ATMETH]	= RXE_BTH_BYTES +
+					  RXE_RDETH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_ATMETH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_RDETH_BYTES,
+		}
+	},
+
+	/* UD */
+	[IB_OPCODE_UD_SEND_ONLY]			= {
+		.name	= "IB_OPCODE_UD_SEND_ONLY",
+		.length = RXE_BTH_BYTES + RXE_DETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_DETH]	= RXE_BTH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_DETH_BYTES,
+		}
+	},
+	[IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE]		= {
+		.name	= "IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE",
+		.length = RXE_BTH_BYTES + RXE_IMMDT_BYTES + RXE_DETH_BYTES,
+		.offset = {
+			[RXE_BTH]	= 0,
+			[RXE_DETH]	= RXE_BTH_BYTES,
+			[RXE_IMMDT]	= RXE_BTH_BYTES +
+					  RXE_DETH_BYTES,
+			[RXE_PAYLOAD]	= RXE_BTH_BYTES +
+					  RXE_DETH_BYTES +
+					  RXE_IMMDT_BYTES,
+		}
+	},
+
+};
+
+static inline u8 __bth_opcode(const void *arg)
+{
+	const struct rxe_bth *bth = arg;
+
+	return bth->opcode;
+}
+
+static inline u8 bth_opcode(const struct rxe_bth *bth)
+{
+	return __bth_opcode(bth);
+}
+
+static inline u8 bth_flags(const struct rxe_bth *bth)
+{
+	return bth->flags;
+}
+
+static inline u16 __bth_pkey(const void *arg)
+{
+	const struct rxe_bth *bth = arg;
+
+	return ntohs(bth->pkey);
+}
+
+static inline u16 bth_pkey(const struct rxe_bth *bth)
+{
+	return __bth_pkey(bth);
+}
+
+#define BTH_QPN_MASK		(0x00ffffff)
+#define BTH_PSN_MASK		((1 << 24) - 1)
+
+static inline u32 __bth_qpn(const void *arg)
+{
+	const struct rxe_bth *bth = arg;
+
+	return BTH_QPN_MASK & ntohl(bth->qpn);
+}
+
+static inline u32 bth_qpn(const struct rxe_bth *bth)
+{
+	return __bth_qpn(bth);
+}
+
+static inline u32 __bth_psn(const void *arg)
+{
+	const struct rxe_bth *bth = arg;
+
+	return BTH_PSN_MASK & ntohl(bth->apsn);
+}
+
+static inline u32 bth_psn(const struct rxe_bth *bth)
+{
+	return __bth_psn(bth);
+}
+
+static inline void print_bth(const struct rxe_bth *bth)
+{
+	printf("struct rxe_bth {\n");
+	printf("\t__u8            opcode; 0x%x\n", bth_opcode(bth));
+	printf("\t__u8            flags;  0x%x\n", bth_flags(bth));
+	printf("\t__be16          pkey;   0x%x\n", bth_pkey(bth));
+	printf("\t__be32          qpn;    0x%x\n", bth_qpn(bth));
+	printf("\t__be32          apsn;   0x%x\n", bth_psn(bth));
+	printf("};\n");
+}
+
+static inline u64 reth_va(const struct rxe_reth *reth)
+{
+	return be64toh(reth->va);
+}
+
+static inline u32 reth_rkey(const struct rxe_reth *reth)
+{
+	return ntohl(reth->rkey);
+}
+
+static inline u32 reth_len(const struct rxe_reth *reth)
+{
+	return ntohl(reth->len);
+}
+
+static inline void print_reth(const struct rxe_reth *reth)
+{
+	printf("struct rxe_reth {\n");
+	printf("\t__be64	va;	0x%llx\n", reth_va(reth));
+	printf("\t__be32	rkey;	0x%x\n", reth_rkey(reth));
+	printf("\t__be32	len;	0x%x\n", reth_len(reth));
+
+	printf("};\n");
+}
+
+#define AETH_MSN_MASK		(0x00ffffff)
+
+static inline u32 aeth_msn(struct rxe_aeth *aeth)
+{
+	return AETH_MSN_MASK & ntohl(aeth->smsn);
+}
+
+static inline void print_aeth(struct rxe_aeth *aeth)
+{
+	printf("struct rxe_aeth {\n");
+	printf("\t___be32		smsn; 0x%x\n", aeth_msn(aeth));
+	printf("};\n");
+}
+
+static inline u64 atmeth_va(struct rxe_atmeth *atmeth)
+{
+	return be64toh(atmeth->va);
+}
+
+static inline u32 atmeth_rkey(struct rxe_atmeth *atmeth)
+{
+	return ntohl(atmeth->rkey);
+}
+
+static inline u64 atmeth_swap_add(struct rxe_atmeth *atmeth)
+{
+	return be64toh(atmeth->swap_add);
+}
+
+static inline u64 atmeth_comp(struct rxe_atmeth *atmeth)
+{
+	return be64toh(atmeth->comp);
+}
+
+static inline void print_atmeth(struct rxe_atmeth *atmeth)
+{
+	printf("struct rxe_atmeth {\n");
+	printf("\t__be64		va;       0x%llx\n", atmeth_va(atmeth));
+	printf("\t__be32		rkey;     0x%x\n", atmeth_rkey(atmeth));
+	printf("\t__be64		swap_add; 0x%llx\n", atmeth_swap_add(atmeth));
+	printf("\t__be64		comp;     0x%llx\n", atmeth_comp(atmeth));
+	printf("} __packed;\n");
+}
+
+static inline u64 atmack_orig(struct rxe_atmack *atmack)
+{
+	return be64toh(atmack->orig);
+}
+
+static inline void print_atmack(struct rxe_atmack *atmack)
+{
+	printf("struct rxe_atmack {\n");
+	printf("\t__be64		orig; 0x%llx\n", atmack_orig(atmack));
+	printf("};\n");
+}
+
+static inline u32 ieth_rkey(struct rxe_ieth *ieth)
+{
+	return ntohl(ieth->rkey);
+}
+
+static inline void print_ieth(struct rxe_ieth *ieth)
+{
+	printf("struct rxe_ieth {\n");
+	printf("\t__be32		rkey; 0x%x\n", ieth_rkey(ieth));
+	printf("};\n");
+}
+
+#define RDETH_EEN_MASK		(0x00ffffff)
+
+static inline u32 rdeth_een(struct rxe_rdeth *rdeth)
+{
+	return RDETH_EEN_MASK & ntohl(rdeth->een);
+}
+
+static inline void print_rdeth(struct rxe_rdeth *rdeth)
+{
+	printf("struct rxe_rdeth {\n");
+	printf("\t__be32		een; 0x%x\n", rdeth_een(rdeth));
+	printf("};\n");
+}
+
+#define DETH_SQP_MASK		(0x00ffffff)
+
+static inline u32 deth_qkey(struct rxe_deth *deth)
+{
+	return ntohl(deth->qkey);
+}
+
+static inline u32 deth_sqp(struct rxe_deth *deth)
+{
+	return DETH_SQP_MASK & ntohl(deth->sqp);
+}
+
+static inline void print_deth(struct rxe_deth *deth)
+{
+	printf("struct rxe_deth {\n");
+	printf("\t__be32	qkey; 0x%x\n", deth_qkey(deth));
+	printf("\t__be32	sqp;  0x%x\n", deth_sqp(deth));
+	printf("};\n");
+}
+
+static inline __be32 immdt_imm(struct rxe_immdt *immdt)
+{
+	return ntohl(immdt->imm);
+}
+
+static inline void print_immdt(struct rxe_immdt *immdt)
+{
+	printf("struct rxe_immdt {\n");
+	printf("\t__be32		imm; 0x%x\n", immdt_imm(immdt));
+	printf("};\n");
+}
+
+static inline void print_ipaddr(const struct iphdr *iph)
+{
+	unsigned char *ip_addr = (unsigned char *)&iph->saddr;
+
+	printf("struct iphdr {\n");
+	printf("\t__be32	saddr; %d.%d.%d.%d\n",
+			ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3]);
+	ip_addr = (unsigned char *)&iph->daddr;
+	printf("\t__be32	daddr; %d.%d.%d.%d\n",
+			ip_addr[0], ip_addr[1], ip_addr[2], ip_addr[3]);
+	printf("};\n");
+}
+
+static inline void print_udphdr(const struct udphdr *udp_hdr)
+{
+	printf("struct udphdr {\n");
+	printf("\t__be16	source; %d\n", ntohs(udp_hdr->source));
+	printf("\t__be16	dest;   %d\n", ntohs(udp_hdr->dest));
+	printf("\t__be16	len;    %d\n", ntohs(udp_hdr->len));
+	printf("\t__sum16	check;  %d\n", ntohs(udp_hdr->check));
+	printf("};\n");
+}
+
+#define ROCEV2_PORT 4791
+
+static void print_bpf_output(const void *data, __u32 size)
+{
+	/* Validate size covers IP and UDP headers */
+	if (size < sizeof(struct iphdr) + sizeof(struct udphdr))
+		return;
+
+	const struct iphdr *iph = (const struct iphdr *)data;
+
+	if (iph->protocol != IPPROTO_UDP)
+		return;
+
+	const struct udphdr *udp_hdr = (const struct udphdr *)(data + sizeof(struct iphdr));
+
+	if (ntohs(udp_hdr->dest) != ROCEV2_PORT)
+		return;
+
+	print_ipaddr(iph);
+	printf("udp hdr:\n");
+	print_udphdr(udp_hdr);
+
+	size_t base_hdr_size = sizeof(struct iphdr) + sizeof(struct udphdr)
+				+ sizeof(struct rxe_bth);
+
+	if (size < base_hdr_size)
+		return;
+
+	const struct rxe_bth *bth = (struct rxe_bth *)(data + sizeof(struct iphdr)
+				+ sizeof(struct udphdr));
+
+	/* Validate opcode bounds and ensure name exists to prevent NULL dereference */
+	if (bth->opcode >= 256 || !rxe_opcode[bth->opcode].name) {
+		printf("Unknown or unpopulated opcode: 0x%x\n", bth->opcode);
+		return;
+	}
+
+	printf("%s\n", rxe_opcode[bth->opcode].name);
+	print_bth(bth);
+
+	for (int i = RXE_BTH + 1; i < NUM_HDR_TYPES; i++) {
+		int offset = rxe_opcode[bth->opcode].offset[i];
+
+		if (offset && (size >= sizeof(struct iphdr) + sizeof(struct udphdr) + offset)) {
+			const unsigned char *cur_p = (const unsigned char *)bth + offset;
+			size_t remaining_size = size - ((const void *)cur_p - data);
+
+			switch (i) {
+			case	RXE_RETH:
+				if (remaining_size < sizeof(struct rxe_reth))
+					break;
+				printf("RXE_RETH\n");
+				print_reth((const struct rxe_reth *)cur_p);
+				break;
+
+			case	RXE_AETH:
+				printf("RXE_AETH\n");
+				struct rxe_aeth *aeth = (struct rxe_aeth *)cur_p;
+
+				print_aeth(aeth);
+				break;
+
+			case	RXE_ATMETH:
+				printf("RXE_ATMETH\n");
+				struct rxe_atmeth *atmeth = (struct rxe_atmeth *)cur_p;
+
+				print_atmeth(atmeth);
+				break;
+
+			case	RXE_ATMACK:
+				printf("RXE_ATMACK\n");
+				struct rxe_atmack *atmack = (struct rxe_atmack *)cur_p;
+
+				print_atmack(atmack);
+				break;
+
+			case	RXE_IETH:
+				printf("RXE_IETH\n");
+				struct rxe_ieth *ieth = (struct rxe_ieth *)cur_p;
+
+				print_ieth(ieth);
+				break;
+
+			case	RXE_RDETH:
+				printf("RXE_RDETH\n");
+				struct rxe_rdeth *rdeth = (struct rxe_rdeth *)cur_p;
+
+				print_rdeth(rdeth);
+				break;
+
+			case	RXE_DETH:
+				printf("RXE_DETH\n");
+				struct rxe_deth *deth = (struct rxe_deth *)cur_p;
+
+				print_deth(deth);
+				break;
+
+			case	RXE_IMMDT:
+				printf("RXE_IMMDT\n");
+				struct rxe_immdt *immdt = (struct rxe_immdt *)cur_p;
+
+				print_immdt(immdt);
+				break;
+
+			case	RXE_PAYLOAD:
+				printf("RXE_PAYLOAD\n");
+				int expected_len = (int)ntohs(udp_hdr->len)
+							- (int)sizeof(struct udphdr)
+							- rxe_opcode[bth->opcode].length;
+				int len = (expected_len < (int)remaining_size) ?
+						expected_len : (int)remaining_size;
+
+				if (len < 0)
+					len = 0;
+
+				for (int j = 0; j < len; j++) {
+					if (isprint(cur_p[j]))
+						printf("%c", cur_p[j]);
+					else
+						printf("%02x", cur_p[j]);
+				}
+				printf("\n");
+				break;
+			default:
+				break;
+			}
+		}
+	}
+
+	printf("\n");
+}
+
+static int handle_event(void *ctx, void *data, unsigned long data_sz)
+{
+	const struct pkg_event *e = data;
+
+	if (data_sz < sizeof(*e))
+		return -1;
+
+	if (e->len < sizeof(struct ethhdr) || e->len > sizeof(e->data))
+		return -1;
+
+	print_bpf_output(e->data + sizeof(struct ethhdr),
+				e->len - sizeof(struct ethhdr));
+
+	return 0;
+}
+
+static volatile sig_atomic_t exiting;
+
+static void sig_handler(int sig)
+{
+	exiting = 1;
+}
+
+int main(void)
+{
+	struct rxe_pkg_kernel_dump *skel;
+	int err = 1;
+	struct ring_buffer *ringbuf = NULL;
+	struct rlimit rlim = { .rlim_cur = RLIM_INFINITY, .rlim_max = RLIM_INFINITY };
+
+	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
+		perror("setrlimit failed");
+		return 1;
+	}
+
+	setvbuf(stdout, NULL, _IOLBF, 0);
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	skel = rxe_pkg_kernel_dump__open_and_load();
+	if (!skel) {
+		fprintf(stderr, "Failed to open and load BPF skeleton\n");
+		return 1;
+	}
+
+	int ifindex = if_nametoindex("nk0");
+
+	if (ifindex == 0) {
+		perror("if_nametoindex nk0 failed");
+		goto cleanup;
+	}
+
+	skel->links.handle_netkit_ingress = bpf_program__attach_netkit(
+		skel->progs.handle_netkit_ingress, ifindex, NULL);
+
+	if (!skel->links.handle_netkit_ingress) {
+		fprintf(stderr, "Failed to attach to netkit nk0\n");
+		goto cleanup;
+	}
+
+	ringbuf = ring_buffer__new(bpf_map__fd(skel->maps.rb),
+				   handle_event, NULL, NULL);
+	if (!ringbuf) {
+		fprintf(stderr, "Failed to create ring buffer\n");
+		goto cleanup;
+	}
+
+	err = 0;
+
+	while (!exiting) {
+		err = ring_buffer__poll(ringbuf, 100 /* timeout */);
+		if (err < 0) {
+			if (err == -EINTR)
+				break;
+			fprintf(stderr, "poll error: %d\n", err);
+			break;
+		}
+	}
+
+cleanup:
+	ring_buffer__free(ringbuf);
+	rxe_pkg_kernel_dump__destroy(skel);
+	return err;
+}
-- 
2.54.0

