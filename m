Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794680875;
	b=0Di6TkdO80YKUfAev7Z4SvDcpCiyN+cYklkT9/5PDQ9L5okUM3UED/RZCpfcgxfaZ1Lw
	 gd91yGOCy+oXl6qSwiJb/KBY6EQYw8VZ/ABURhA/A79gO6agQq/j2uROT1PqVqECCD+vA
	 mWPFKklOHKt0LD/himv3YiSywIFsxSVRJfSUH1QVqdkZnxIL7nf9PtQuUCCR8rXwM+9fy
	 1nFSVDxuTte8MMerYi6Tuodd5mh89FSFBLyR8jDga20Dfyrn0j1TqjUHSeRkpiEXvzHGh
	 RpKPqE+R2RUekbHWNnkXtzpKqX0HqsejmwlnOKPR1i1JgnIE6vyMaJE99voiwjoqM2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794680875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcB/McjzelyYWItWwhkUhExwUPy2K+ekZLEMhUXmAx8=;
	b=x5M3CYLXZOsn5HNYgMkv9ubnVdqRgUNs6FF8OtrNbuMXwGQJ7kNLi3rXmlyTylw1HpsI
	 SFnSQY7Gpnndhn19dNfZu+c2LS+SQQloFZxWkgzgHq8n5MAwZyIYWoxKDQDBnbx8hVsk7
	 biA9+TLh9m3LM92hNCLMY9U9RPAFcLVO1LSNMDLBkIeRf8/nPvB4FfGlrZFoa8W/o9+QR
	 SnmeoyIXKUaSWly2Y2vC2t1u6w1XAC8ixnNHfXp6T6VB9TD3E7eZPG2OXe8zHBRIgFoWj
	 IyKISr/0ox38BlbOKDE7U7h85iNffrY3qPOE90WBzXWUkE/AowfSzuhkN6Y/+SrN21Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b="jseqeFe/";
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B66606A8B2
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 18:27:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07B66606A8B2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=jseqeFe/
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c505186727fso406109866b.3
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 10:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794680872; x=1795285672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcB/McjzelyYWItWwhkUhExwUPy2K+ekZLEMhUXmAx8=;
        b=jseqeFe/t4vPtwdvmHeXp+fI6Two60zfVI3q2S44PCyvHNOSkTc8B6/LR2ZEGsg3Iq
         FRnKKXxGjkEqO1K2JOlKlL1lWURmYc/5WMskl3DqPN/P9R8aeRwvyzANB+JNBzF/ut1K
         DaLUDT+PrkHroYQDRzMywxmqAgoT/wyblMkLa0jpOj/GliKlaQoU1iUBPnhTSzmA0fqk
         i/EzJDnxfBT3O1FbM2yuTKuJYI6OzsSyasCXEO6wyq+2FZIIRY4MVJbbhjbRmLMVbV/G
         8NGjhjMXpwS3S08i3ETiRkp77L97JERNsTj7I+PeKclLYeFGUxUfwtvzy7alTg3sykPS
         YL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794680872; x=1795285672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zcB/McjzelyYWItWwhkUhExwUPy2K+ekZLEMhUXmAx8=;
        b=hRaBqtE9fjYmZbd563uWaOqx/lpL+bOXV9RNo2OOJkP3T0fCvo5hfzb7Zf8mtLrK/8
         2yS93+nBSV6pRLnrBoK+RiAgnCA3MHzyHHEnxj+rT1RYuBWQMVLYy5NZH/LA08BSQ5D2
         dy7lSOIcn7MT5H4PByMr7IwnMQkUk1sjOiC7rteiNTQp3cNX1YKKteME/7iw5zjS+yZF
         kkW8KY4F2tEHrUFVq6nI1Y5ol20NuCFCrTYvJSicCsSMccik+KZAAGg96RW8xvzGViwR
         F+CyOirHn9t+WeKrngz37bEF+6gbUIrUc/lBsNDTweN9vkgtv7ejSxq9+T6ZwRFY8tK9
         iWLQ==
X-Forwarded-Encrypted: i=1; AL+hErHK5eT3qLix3GWOsFgJWAHZrmjjOCpGdpLsuATbPrdi1odFvMBgKv3jcftlGfrwWXJNwXlfrpQiaYqn@vger.kernel.org
X-Gm-Message-State: APuU4Z+308YUEhjaBz+oSPHrsQzwQlEScs61H9CqOX9RDQyk9EwVfGjh
	PeDJH91sWOXLHDSm0X7ERH0hfVbOAaTC8Z2eTw3ZoDXjdvEyOYVcAU5HsC8EKuM0Hw==
X-Gm-Gg: AYBFou1T4BX0vkfnQsYBdyM8Y7Rjewrho4u1sHnY/XsCCi7UgDr3+NEcLLR1kro0Bmk
	mOv2Axwv8JmVPXf/cEP52Sc9io16F11h/CCveFz2Rriibr4sXKCZUVs+9kGZAyzpTgei283W3fH
	e8Tn9op6lfxomZLc+5k2Sn2DFMdfSTRM08TK/kdgqLCmiaHLyC472Rnakh1V/G5S0VevuJX0rNj
	62mrJbzyuX29TSSEml2KEXSYKyaaVB8Q8OR1yVL4fIOM/iNiRUtCWkiZ0tyRk4S/Eqo/dT8S/hI
	EwlP05OeVyn/s6JaQOo08Lg/ZTLC5bKKiv3+AHKivn9+YKTTeCMCLwwrQdviAQFyr+AQzNDlaGo
	/gzU5sq366RUWkzris1Bnx9r75UQbPdBgeU5hgrVg+nxLfy4u53WtG/2zz+1622EBHeO2QBDdKf
	xQ3VGDBOVK1RVHKQhVHI26wMsHwSV35Fqdafn78qxnwRuEvEx/z/4gZFXyLuoK+Y350HewrZRFr
	W/MlSgNMuXFxhgTSBW0UuXA5gWaCoYKEePZzSAVmgLGlMSNjSfhT4o7woG44y5inbUM7Z1DSZzK
	UfcU7VSiVPRyDgpejl5L16p40U3vxnxl6p7z7EJQFTYiM9ekxMCIFIpe0pXsIl5or/8hgBWfI8t
	uafy3Op6wE1YiGwRagIYJA4w7Wb+PROzyGEmT1Nz7obJ9HVoFa6u39s5xhOBpv9igMZf+NoJTg1
	860jnLLRnQ66VFP0Hg80BtANVt0fxjbRlPYzsbvtGxOg4ZmtMmTThj0sRJCt1vkmmCrhOVjd+RW
	7OZOtkyYTjsIxdZrmSOYgm4tY30xF0Ro36XoQCmSm2X/WiwnVUisJlue0Le84v6gxTvLzk66AUH
	Td0=
X-Received: by 2002:a17:906:4795:b0:c2e:856:2a08 with SMTP id a640c23a62f3a-c509614e75cmr466090966b.1.1794680872165;
        Sat, 14 Nov 2026 10:27:52 -0800 (PST)
Received: from Desktop.fritz.box ([185.181.130.189])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b56df7sm245554366b.47.2026.11.14.10.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 10:27:51 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	richardbgobert@gmail.com,
	willemb@google.com,
	ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	martin.lau@linux.dev,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] selftests: net: check TCP IP IDs across tunnels after GRO and GSO
Date: Sat, 14 Nov 2026 19:27:45 +0100
Message-ID: <c4f9c977725ee51341ca84dedf2dddb9fcb4e8ea.1794139176.git.julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1794139176.git.julius@bairaktaris.de>
References: <cover.1794139176.git.julius@bairaktaris.de>
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

Send TCP segments with fixed or incrementing IPv4 IDs from a packet
socket, let GRO on a veth merge them, forward the merged packets into
IPIP, GRE and VXLAN tunnels over IPv4 and IPv6 and into an ESP tunnel
mode SA offloaded to netdevsim, with segmentation done in software, and
check that the inner IDs come out as they went in and the IDs of a new
outer IPv4 header are unique, or for ESP increment. Also forward a VXLAN
stream with one header's IDs fixed after decapsulation into IPIP, and
send the merged packets through a tunnel that the far end decapsulates
without segmenting them before it forwards them.

A test where GRO merged nothing is skipped.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 tools/testing/selftests/net/.gitignore     |   1 +
 tools/testing/selftests/net/Makefile       |   2 +
 tools/testing/selftests/net/tcp_fixedid.c  | 411 +++++++++++++++++++++
 tools/testing/selftests/net/tcp_fixedid.sh | 400 ++++++++++++++++++++
 4 files changed, 814 insertions(+)
 create mode 100644 tools/testing/selftests/net/tcp_fixedid.c
 create mode 100755 tools/testing/selftests/net/tcp_fixedid.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 21412510ac26b..96263d5978258 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -46,6 +46,7 @@ so_rcv_listener
 stress_reuseport_listen
 tap
 tcp_fastopen_backup_key
+tcp_fixedid
 tcp_inq
 tcp_mmap
 tcp_port_share
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 9180b9bec5155..755f2536a510f 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -107,6 +107,7 @@ TEST_PROGS := \
 	stress_reuseport_listen.sh \
 	tcp_ecmp_failover.sh \
 	tcp_fastopen_backup_key.sh \
+	tcp_fixedid.sh \
 	test_bridge_backup_port.sh \
 	test_bridge_neigh_suppress.sh \
 	test_ingress_egress_chaining.sh \
@@ -169,6 +170,7 @@ TEST_GEN_FILES := \
 	socket \
 	stress_reuseport_listen \
 	tcp_fastopen_backup_key \
+	tcp_fixedid \
 	tcp_inq \
 	tcp_mmap \
 	tfo \
diff --git a/tools/testing/selftests/net/tcp_fixedid.c b/tools/testing/selftests/net/tcp_fixedid.c
new file mode 100644
index 0000000000000..25c752beab4ed
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_fixedid.c
@@ -0,0 +1,411 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Send TCP segments with fixed or incrementing IPv4 IDs, optionally in
+ * VXLAN, and report the IP IDs of TCP segments received on a device,
+ * also inside IPIP, GRE, VXLAN or ESP.
+ *
+ * tx: tcp_fixedid -T -i dev -M dmac -s saddr -d daddr [-f] [-n segs]
+ *                 [-b bursts] [-l len] [-V osaddr,odaddr -m inner_dmac [-F]]
+ * rx: tcp_fixedid -R -i dev [-f] [-c segs] [-w ms]
+ *
+ * The receiver prints "ready" once it is bound, then the number of
+ * segments, of segments with an outer IPv4 header, of distinct outer and
+ * inner IDs, and of inner IDs the sender did not use: other than the fixed
+ * ID with -f, outside the incrementing range of segs IDs without it.
+ */
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <linux/if_packet.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <time.h>
+#include <unistd.h>
+
+#define TEST_PORT	9000
+#define VXLAN_PORT	4789
+#define FIXED_ID	0x1234
+#define INCR_ID		0x1000
+
+static const char *ifname;
+static bool fixed_id, fixed_outer;
+static int segs = 40, bursts = 10, len = 1000, wait_ms = 2000, stop;
+static struct in_addr saddr, daddr, osaddr, odaddr;
+static bool vxlan;
+static unsigned char dmac[ETH_ALEN], inner_dmac[ETH_ALEN];
+
+static void parse_mac(const char *s, unsigned char *mac)
+{
+	if (sscanf(s, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &mac[0], &mac[1],
+		   &mac[2], &mac[3], &mac[4], &mac[5]) != 6)
+		error(1, 0, "bad mac %s", s);
+}
+
+static void parse_addr(const char *s, struct in_addr *a)
+{
+	if (inet_pton(AF_INET, s, a) != 1)
+		error(1, 0, "bad address %s", s);
+}
+
+static uint32_t csum_add(uint32_t sum, const void *data, size_t n)
+{
+	const uint8_t *p = data;
+
+	while (n > 1) {
+		sum += (p[0] << 8) | p[1];
+		p += 2;
+		n -= 2;
+	}
+	if (n)
+		sum += p[0] << 8;
+	return sum;
+}
+
+static uint16_t csum_fold(uint32_t sum)
+{
+	while (sum >> 16)
+		sum = (sum & 0xffff) + (sum >> 16);
+	return htons(~sum & 0xffff);
+}
+
+static void build_ip(struct iphdr *iph, int proto, int payload, uint16_t id,
+		     struct in_addr s, struct in_addr d)
+{
+	memset(iph, 0, sizeof(*iph));
+	iph->version = 4;
+	iph->ihl = 5;
+	iph->tot_len = htons(sizeof(*iph) + payload);
+	iph->id = htons(id);
+	iph->frag_off = htons(IP_DF);
+	iph->ttl = 64;
+	iph->protocol = proto;
+	iph->saddr = s.s_addr;
+	iph->daddr = d.s_addr;
+	iph->check = csum_fold(csum_add(0, iph, sizeof(*iph)));
+}
+
+/* Ethernet, IPv4 and TCP header plus payload for segment @i at @p */
+static int build_tcp(unsigned char *p, const unsigned char *mac, int i,
+		     uint16_t id)
+{
+	struct ethhdr *eth = (struct ethhdr *)p;
+	struct iphdr *iph = (struct iphdr *)(eth + 1);
+	struct tcphdr *th = (struct tcphdr *)(iph + 1);
+	struct {
+		uint32_t s, d;
+		uint8_t zero, proto;
+		uint16_t len;
+	} ph;	/* 12 bytes, no padding */
+	uint32_t sum;
+
+	memcpy(eth->h_dest, mac, ETH_ALEN);
+	memset(eth->h_source, 0, ETH_ALEN);
+	eth->h_source[0] = 0x02;
+	eth->h_source[5] = 0x01;
+	eth->h_proto = htons(ETH_P_IP);
+	build_ip(iph, IPPROTO_TCP, sizeof(*th) + len, id, saddr, daddr);
+
+	memset(th, 0, sizeof(*th));
+	th->source = htons(TEST_PORT + 1);
+	th->dest = htons(TEST_PORT);
+	th->seq = htonl(1 + i * len);
+	th->ack_seq = htonl(1);
+	th->doff = 5;
+	th->ack = 1;
+	th->window = htons(65535);
+	memset(th + 1, 'a' + i % 26, len);
+
+	ph.s = iph->saddr;
+	ph.d = iph->daddr;
+	ph.zero = 0;
+	ph.proto = IPPROTO_TCP;
+	ph.len = htons(sizeof(*th) + len);
+	sum = csum_add(0, &ph, sizeof(ph));
+	th->check = csum_fold(csum_add(sum, th, sizeof(*th) + len));
+
+	return sizeof(*eth) + sizeof(*iph) + sizeof(*th) + len;
+}
+
+static int do_tx(int fd, struct sockaddr_ll *sll)
+{
+	unsigned char buf[ETH_FRAME_LEN + 128];
+	int b, s, i = 0, n;
+
+	for (b = 0; b < bursts; b++) {
+		for (s = 0; s < segs; s++, i++) {
+			uint16_t id = fixed_id ? FIXED_ID : INCR_ID + i;
+			unsigned char *p = buf;
+
+			if (vxlan) {
+				struct ethhdr *eth = (struct ethhdr *)p;
+				struct iphdr *iph = (struct iphdr *)(eth + 1);
+				struct udphdr *uh = (struct udphdr *)(iph + 1);
+				uint32_t *vx = (uint32_t *)(uh + 1);
+				int inner;
+
+				inner = build_tcp((unsigned char *)(vx + 2),
+						  inner_dmac, i, id);
+				memcpy(eth->h_dest, dmac, ETH_ALEN);
+				memset(eth->h_source, 0, ETH_ALEN);
+				eth->h_source[0] = 0x02;
+				eth->h_source[5] = 0x01;
+				eth->h_proto = htons(ETH_P_IP);
+				memset(uh, 0, sizeof(*uh));
+				uh->source = htons(VXLAN_PORT + 1);
+				uh->dest = htons(VXLAN_PORT);
+				uh->len = htons(sizeof(*uh) + 8 + inner);
+				vx[0] = htonl(0x08000000);
+				vx[1] = htonl(42 << 8);
+				build_ip(iph, IPPROTO_UDP,
+					 sizeof(*uh) + 8 + inner,
+					 fixed_outer ? FIXED_ID : 0x2000 + i,
+					 osaddr, odaddr);
+				n = sizeof(*eth) + sizeof(*iph) + sizeof(*uh) +
+				    8 + inner;
+			} else {
+				n = build_tcp(p, dmac, i, id);
+			}
+
+			if (sendto(fd, buf, n, 0, (struct sockaddr *)sll,
+				   sizeof(*sll)) != n)
+				error(1, errno, "sendto");
+		}
+		usleep(50000);
+	}
+	return 0;
+}
+
+/* Return the inner IPv4 header of a TCP segment to TEST_PORT, or NULL */
+static const struct iphdr *find_inner(const unsigned char *p, int n,
+				      const struct iphdr **outer4)
+{
+	const struct ethhdr *eth = (const struct ethhdr *)p;
+	const unsigned char *end = p + n;
+	const unsigned char *l4;
+	int proto, depth;
+
+	*outer4 = NULL;
+	if (n < (int)sizeof(*eth))
+		return NULL;
+	p += sizeof(*eth);
+
+	for (depth = 0; depth < 2; depth++) {
+		uint16_t etype = depth ? htons(ETH_P_IP) : eth->h_proto;
+
+		if (etype == htons(ETH_P_IP)) {
+			const struct iphdr *iph = (const struct iphdr *)p;
+
+			if (p + sizeof(*iph) > end)
+				return NULL;
+			proto = iph->protocol;
+			l4 = p + iph->ihl * 4;
+			if (proto == IPPROTO_TCP) {
+				const struct tcphdr *th;
+
+				th = (const struct tcphdr *)l4;
+				if (l4 + sizeof(*th) > end ||
+				    th->dest != htons(TEST_PORT))
+					return NULL;
+				return iph;
+			}
+			if (depth)
+				return NULL;
+			*outer4 = iph;
+		} else if (etype == htons(ETH_P_IPV6)) {
+			const struct ip6_hdr *ip6h = (const struct ip6_hdr *)p;
+
+			if (p + sizeof(*ip6h) > end)
+				return NULL;
+			proto = ip6h->ip6_nxt;
+			l4 = p + sizeof(*ip6h);
+		} else {
+			return NULL;
+		}
+
+		/* step over the tunnel header to the inner IPv4 header */
+		if (proto == IPPROTO_IPIP) {
+			p = l4;
+		} else if (proto == IPPROTO_GRE) {
+			uint16_t flags;
+
+			if (l4 + 4 > end)
+				return NULL;
+			flags = (l4[0] << 8) | l4[1];
+			if (((l4[2] << 8) | l4[3]) != ETH_P_IP)
+				return NULL;
+			p = l4 + 4 + 4 * (!!(flags & 0x8000) +
+					  !!(flags & 0x2000) +
+					  !!(flags & 0x1000));
+		} else if (proto == IPPROTO_UDP) {
+			const struct udphdr *uh = (const struct udphdr *)l4;
+
+			if (l4 + sizeof(*uh) + 8 + sizeof(*eth) > end ||
+			    uh->dest != htons(VXLAN_PORT))
+				return NULL;
+			p = l4 + sizeof(*uh) + 8 + sizeof(*eth);
+		} else if (proto == IPPROTO_ESP) {
+			/* SPI, sequence number and the 8 byte IV of
+			 * rfc4106(gcm(aes)); netdevsim does not encrypt
+			 */
+			if (l4 + 16 > end)
+				return NULL;
+			p = l4 + 16;
+		} else {
+			return NULL;
+		}
+	}
+	return NULL;
+}
+
+static void count_id(uint8_t *map, unsigned int *distinct, uint16_t id)
+{
+	if (!(map[id / 8] & (1 << (id % 8)))) {
+		map[id / 8] |= 1 << (id % 8);
+		(*distinct)++;
+	}
+}
+
+static int do_rx(int fd)
+{
+	static uint8_t outer_map[8192], inner_map[8192];
+	unsigned int frames = 0, outer4 = 0, outer_ids = 0, inner_ids = 0;
+	unsigned int inner_bad = 0;
+	unsigned char buf[65536];
+	struct pollfd pfd = { .fd = fd, .events = POLLIN };
+
+	printf("ready\n");
+	fflush(stdout);
+
+	/* wait longer for the first segment than between segments */
+	while (poll(&pfd, 1, frames ? wait_ms : 10 * wait_ms) > 0) {
+		const struct iphdr *iph, *oiph;
+		struct sockaddr_ll from;
+		socklen_t fl = sizeof(from);
+		uint16_t id;
+		int n;
+
+		n = recvfrom(fd, buf, sizeof(buf), 0, (struct sockaddr *)&from,
+			     &fl);
+		if (n < 0)
+			error(1, errno, "recvfrom");
+		if (from.sll_pkttype == PACKET_OUTGOING)
+			continue;
+		iph = find_inner(buf, n, &oiph);
+		if (!iph)
+			continue;
+		frames++;
+		id = ntohs(iph->id);
+		count_id(inner_map, &inner_ids, id);
+		if (fixed_id ? id != FIXED_ID : (uint16_t)(id - INCR_ID) >= stop)
+			inner_bad++;
+		if (oiph) {
+			outer4++;
+			count_id(outer_map, &outer_ids, ntohs(oiph->id));
+		}
+		if (stop && frames == (unsigned int)stop)
+			break;
+	}
+
+	printf("frames %u outer4 %u outer_ids %u inner_ids %u inner_bad %u\n",
+	       frames, outer4, outer_ids, inner_ids, inner_bad);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct sockaddr_ll sll = {};
+	bool tx = false, rx = false;
+	char *comma;
+	int c, fd;
+
+	while ((c = getopt(argc, argv, "TRi:M:s:d:fn:b:l:V:m:Fw:c:")) != -1) {
+		switch (c) {
+		case 'T':
+			tx = true;
+			break;
+		case 'R':
+			rx = true;
+			break;
+		case 'i':
+			ifname = optarg;
+			break;
+		case 'M':
+			parse_mac(optarg, dmac);
+			break;
+		case 's':
+			parse_addr(optarg, &saddr);
+			break;
+		case 'd':
+			parse_addr(optarg, &daddr);
+			break;
+		case 'f':
+			fixed_id = true;
+			break;
+		case 'n':
+			segs = atoi(optarg);
+			break;
+		case 'b':
+			bursts = atoi(optarg);
+			break;
+		case 'l':
+			len = atoi(optarg);
+			break;
+		case 'V':
+			comma = strchr(optarg, ',');
+			if (!comma)
+				error(1, 0, "-V needs outer saddr,daddr");
+			*comma = '\0';
+			parse_addr(optarg, &osaddr);
+			parse_addr(comma + 1, &odaddr);
+			vxlan = true;
+			break;
+		case 'm':
+			parse_mac(optarg, inner_dmac);
+			break;
+		case 'F':
+			fixed_outer = true;
+			break;
+		case 'w':
+			wait_ms = atoi(optarg);
+			break;
+		case 'c':
+			stop = atoi(optarg);
+			break;
+		default:
+			error(1, 0, "bad option");
+		}
+	}
+	if (tx == rx || !ifname || len < 1 || len > 1400 || segs < 1 ||
+	    bursts < 1)
+		error(1, 0, "usage: see the comment at the top of %s",
+		      __FILE__);
+
+	fd = socket(AF_PACKET, SOCK_RAW, htons(tx ? 0 : ETH_P_ALL));
+	if (fd < 0)
+		error(1, errno, "socket");
+	sll.sll_family = AF_PACKET;
+	sll.sll_protocol = htons(ETH_P_ALL);
+	sll.sll_ifindex = if_nametoindex(ifname);
+	if (!sll.sll_ifindex)
+		error(1, errno, "%s", ifname);
+	if (bind(fd, (struct sockaddr *)&sll, sizeof(sll)))
+		error(1, errno, "bind");
+	sll.sll_halen = ETH_ALEN;
+	memcpy(sll.sll_addr, dmac, ETH_ALEN);
+
+	c = tx ? do_tx(fd, &sll) : do_rx(fd);
+	close(fd);
+	return c;
+}
diff --git a/tools/testing/selftests/net/tcp_fixedid.sh b/tools/testing/selftests/net/tcp_fixedid.sh
new file mode 100755
index 0000000000000..05ef7ec6b08e7
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_fixedid.sh
@@ -0,0 +1,400 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Check the IPv4 IDs of a TCP stream that GRO merged and software
+# segmentation split again across a tunnel. A sender in NSRC writes
+# segments with fixed or incrementing IDs onto a veth with GRO on in
+# NRTR, which forwards the merged packets:
+#
+#  encap:       into an IPIP, GRE or VXLAN tunnel over IPv4 or IPv6,
+#               segmented on the underlay towards NMID
+#  decap:       out of VXLAN, received from NSRC with one header fixed and
+#               the other incrementing, into an IPIP tunnel towards NMID
+#  encap+decap: into a tunnel that NMID ends without segmenting, and on
+#               to NDST, segmented there
+#  esp:         into an ESP tunnel mode SA offloaded to netdevsim, which
+#               segments the packet in software and does not encrypt it
+#
+# The inner IDs must come out as they went in, and the IDs of a new outer
+# IPv4 header must be unique, or for ESP, whose outer IDs start at 0 for
+# each packet with DF set, increment. A run in which GRO merged nothing is
+# skipped.
+
+source lib.sh
+
+NSRC=""
+NRTR=""
+NMID=""
+NDST=""
+
+SEGS=40
+BURSTS=10
+TOTAL=$((SEGS * BURSTS))
+INNER_SRC=10.1.0.1
+INNER_DST=10.9.0.2
+VX_MAC=02:00:00:00:00:42
+TUN_MAC=02:00:00:00:00:99
+MID_MAC=02:00:00:00:00:98
+TX=./tcp_fixedid
+
+NOSEG="tso gso tx-gre-segmentation tx-gre-csum-segmentation
+       tx-ipxip4-segmentation tx-ipxip6-segmentation
+       tx-udp_tnl-segmentation tx-udp_tnl-csum-segmentation"
+
+cleanup() {
+	cleanup_all_ns
+	rm -f "$RESULT"
+}
+
+trap cleanup EXIT
+
+# NSRC s0 - r0 NRTR r1 - m1 NMID m2 - d2 NDST
+setup() {
+	setup_ns NSRC NRTR NMID NDST || return "$ksft_skip"
+
+	ip link add s0 netns "$NSRC" type veth peer name r0 netns "$NRTR"
+	ip link add r1 netns "$NRTR" type veth peer name m1 netns "$NMID"
+	ip link add m2 netns "$NMID" type veth peer name d2 netns "$NDST"
+
+	ip -n "$NRTR" addr add 10.1.0.2/24 dev r0
+	ip -n "$NRTR" addr add 10.2.0.1/24 dev r1
+	ip -n "$NRTR" addr add fd02::1/64 dev r1 nodad
+	ip -n "$NMID" addr add 10.2.0.2/24 dev m1
+	ip -n "$NMID" addr add fd02::2/64 dev m1 nodad
+	ip -n "$NMID" addr add 10.4.0.1/24 dev m2
+	ip -n "$NDST" addr add 10.4.0.2/24 dev d2
+	ip -n "$NSRC" link set s0 up
+	ip -n "$NRTR" link set r0 up
+	ip -n "$NRTR" link set r1 up
+	ip -n "$NMID" link set m1 up
+	ip -n "$NMID" link set m2 up
+	ip -n "$NDST" link set d2 up
+
+	ip netns exec "$NRTR" sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec "$NMID" sysctl -qw net.ipv4.ip_forward=1
+	for ns in "$NRTR" "$NMID"; do
+		ip netns exec "$ns" sysctl -qw net.ipv4.conf.all.rp_filter=0 \
+			net.ipv4.conf.default.rp_filter=0
+	done
+
+	# veth passes packets to GRO only if the sender does not do TSO
+	ip netns exec "$NRTR" ethtool -K r0 gro on >/dev/null ||
+		return "$ksft_skip"
+	ip netns exec "$NSRC" ethtool -K s0 tso off >/dev/null ||
+		return "$ksft_skip"
+	# release the sender's segments in bursts for GRO to merge
+	tc -n "$NSRC" qdisc add dev s0 root netem slot 20ms 20ms \
+		packets "$SEGS" || return "$ksft_skip"
+}
+
+# tunnel <ns> <name> <type> <family> <local> <remote>
+tunnel() {
+	local ns=$1 name=$2 type=$3 family=$4 local=$5 remote=$6
+
+	case "$type" in
+	ipip)
+		if [ "$family" = 4 ]; then
+			ip -n "$ns" link add "$name" type ipip \
+				local "$local" remote "$remote"
+		else
+			ip -n "$ns" link add "$name" type ip6tnl mode ipip6 \
+				local "$local" remote "$remote" encaplimit none
+		fi ;;
+	gre)
+		if [ "$family" = 4 ]; then
+			ip -n "$ns" link add "$name" type gre \
+				local "$local" remote "$remote"
+		else
+			ip -n "$ns" link add "$name" type ip6gre \
+				local "$local" remote "$remote" encaplimit none
+		fi ;;
+	vxlan)
+		ip -n "$ns" link add "$name" address "$TUN_MAC" type vxlan \
+			id 7 dstport 4789 local "$local" remote "$remote" \
+			nolearning ;;
+	esac || return 1
+	# no IPv6 link-local traffic in the tx_packets of the tunnel
+	ip netns exec "$ns" sysctl -qw "net.ipv6.conf.$name.disable_ipv6=1"
+	ip -n "$ns" link set "$name" up
+}
+
+# route_into <ns> <dev>: send INNER_DST into <dev>
+route_into() {
+	ip -n "$1" route add "$INNER_DST/32" dev "$2"
+	ip -n "$1" neigh add "$INNER_DST" lladdr "$TUN_MAC" dev "$2" \
+		2>/dev/null
+	return 0
+}
+
+# noseg <ns> <dev>: segment everything in software before <dev>
+noseg() {
+	local f
+
+	for f in $NOSEG; do
+		ip netns exec "$1" ethtool -K "$2" "$f" off >/dev/null 2>&1
+	done
+}
+
+tx_packets() {
+	ip netns exec "$1" cat "/sys/class/net/$2/statistics/tx_packets"
+}
+
+# fwd_packets <ns>: packets forwarded, a GSO packet counting once
+fwd_packets() {
+	ip netns exec "$1" awk '/^Ip: [0-9]/ { print $7 }' /proc/net/snmp
+}
+
+# check <name> <result> <want: fixed|incr> <outer: 0|unique|incr> <merged>
+check() {
+	local name=$1 res=$2 want=$3 outer=$4 sent=$5
+	local frames outer_ids inner_ids inner_bad
+
+	read -r _ frames _ _ _ outer_ids _ inner_ids _ inner_bad <<< "$res"
+	RET=0
+	if [ -z "$inner_bad" ]; then
+		check_err 1 "no result from the receiver"
+		log_test "$name"
+		return
+	fi
+	check_err $((frames != TOTAL)) "$frames of $TOTAL segments received"
+	check_err "$inner_bad" "$inner_bad inner IDs not sent"
+	if [ "$want" = fixed ]; then
+		check_err $((inner_ids != 1)) "$inner_ids inner IDs, want 1"
+	else
+		check_err $((inner_ids != TOTAL)) \
+			"$inner_ids inner IDs, want $TOTAL"
+	fi
+	if [ "$outer" = unique ]; then
+		check_err $((outer_ids != frames)) \
+			"$outer_ids outer IDs for $frames segments"
+	elif [ "$outer" = incr ]; then
+		check_err $((outer_ids < 2)) "fixed outer IDs"
+	fi
+	if [ "$RET" -eq 0 ] && [ "$sent" -ge "$TOTAL" ]; then
+		ret_set_ksft_status "$ksft_skip" "GRO did not merge"
+	fi
+	log_test "$name"
+}
+
+# capture <ns> <dev> <want: fixed|incr>: start the receiver in the
+# background, pid in CAP_PID, and wait until it is bound
+capture() {
+	local f="" i
+
+	[ "$3" = fixed ] && f=-f
+	: > "$RESULT"
+	ip netns exec "$1" "$TX" -R -i "$2" -c "$TOTAL" -w 3000 $f > "$RESULT" &
+	CAP_PID=$!
+	for i in $(seq 100); do
+		grep -q ready "$RESULT" && return
+		sleep 0.1
+	done
+}
+
+run_encap() {
+	local type=$1 family=$2 want=$3
+	local r0mac t0 laddr=10.2.0.1 raddr=10.2.0.2
+	local f=""
+
+	setup || { log_test_skip "encap $type IPv$family"; return; }
+	if [ "$family" = 6 ]; then
+		laddr=fd02::1
+		raddr=fd02::2
+	fi
+	if ! tunnel "$NRTR" tun0 "$type" "$family" "$laddr" "$raddr"; then
+		log_test_skip "encap $type IPv$family"
+		cleanup_all_ns
+		return
+	fi
+	route_into "$NRTR" tun0
+	noseg "$NRTR" r1
+
+	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
+	capture "$NMID" m1 "$want"
+	t0=$(tx_packets "$NRTR" tun0)
+	[ "$want" = fixed ] && f=-f
+	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
+		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" $f
+	wait "$CAP_PID"
+	check "encap $type IPv$family, $want inner IDs" \
+		"$(tail -n 1 "$RESULT")" "$want" \
+		"$([ "$family" = 4 ] && echo unique || echo 0)" \
+		$(($(tx_packets "$NRTR" tun0) - t0))
+	cleanup_all_ns
+}
+
+# run_decap <fixed: inner|outer>: VXLAN from NSRC, decapsulated in NRTR
+run_decap() {
+	local fixed=$1 want=incr flags=-F
+	local r0mac t0
+
+	setup || { log_test_skip "decap"; return; }
+	ip -n "$NRTR" link add vx0 address "$VX_MAC" type vxlan id 42 \
+		dstport 4789 local 10.1.0.2 nolearning ||
+		{ log_test_skip "decap"; cleanup_all_ns; return; }
+	ip -n "$NRTR" addr add 10.3.0.2/24 dev vx0
+	ip -n "$NRTR" link set vx0 up
+	if ! tunnel "$NRTR" tun0 ipip 4 10.2.0.1 10.2.0.2; then
+		log_test_skip "decap"
+		cleanup_all_ns
+		return
+	fi
+	route_into "$NRTR" tun0
+	noseg "$NRTR" r1
+
+	if [ "$fixed" = inner ]; then
+		want=fixed
+		flags=-f
+	fi
+	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
+	capture "$NMID" m1 "$want"
+	t0=$(tx_packets "$NRTR" tun0)
+	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s 10.3.0.1 \
+		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" \
+		-V 10.1.0.1,10.1.0.2 -m "$VX_MAC" $flags
+	wait "$CAP_PID"
+	check "decap VXLAN with fixed $fixed IDs, into IPIP" \
+		"$(tail -n 1 "$RESULT")" "$want" unique \
+		$(($(tx_packets "$NRTR" tun0) - t0))
+	cleanup_all_ns
+}
+
+# run_encap_decap <type>: NRTR encapsulates, NMID decapsulates the GSO
+# packet without segmenting it and forwards it to NDST
+run_encap_decap() {
+	local type=$1
+	local r0mac t0
+
+	setup || { log_test_skip "encap+decap $type"; return; }
+	if ! tunnel "$NRTR" tun0 "$type" 4 10.2.0.1 10.2.0.2 ||
+	   ! tunnel "$NMID" tun0 "$type" 4 10.2.0.2 10.2.0.1; then
+		log_test_skip "encap+decap $type"
+		cleanup_all_ns
+		return
+	fi
+	route_into "$NRTR" tun0
+	# VXLAN drops frames from its own address as loops
+	if [ "$type" = vxlan ]; then
+		ip -n "$NMID" link set tun0 address "$MID_MAC"
+		ip -n "$NRTR" neigh replace "$INNER_DST" lladdr "$MID_MAC" \
+			dev tun0
+	fi
+	ip -n "$NMID" route add "$INNER_DST/32" via 10.4.0.2
+	ip -n "$NDST" addr add "$INNER_DST/32" dev d2
+	noseg "$NMID" m2
+
+	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
+	capture "$NDST" d2 fixed
+	t0=$(tx_packets "$NRTR" tun0)
+	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
+		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" -f
+	wait "$CAP_PID"
+	check "encap+decap $type, fixed inner IDs" "$(tail -n 1 "$RESULT")" \
+		fixed 0 $(($(tx_packets "$NRTR" tun0) - t0))
+	cleanup_all_ns
+}
+
+NSIM_ID=$((RANDOM % 1024 + 1024))
+NSIM_BUS=/sys/bus/netdevsim
+
+# nsim_add <id> <ns>: create a netdevsim port in <ns>, print its name
+nsim_add() {
+	local dev
+
+	echo "$1 1" > "$NSIM_BUS/new_device" || return 1
+	for dev in "$NSIM_BUS/devices/netdevsim$1/net/"*; do
+		dev=${dev##*/}
+		ip link set "$dev" netns "$2" || return 1
+		echo "$dev"
+		return 0
+	done
+	return 1
+}
+
+nsim_del() {
+	echo "$NSIM_ID" > "$NSIM_BUS/del_device" 2>/dev/null
+	echo $((NSIM_ID + 1)) > "$NSIM_BUS/del_device" 2>/dev/null
+}
+
+# run_esp: NRTR forwards into an ESP tunnel mode SA offloaded to a
+# netdevsim port with TSO off, linked to a netdevsim port in NMID
+run_esp() {
+	local key=0x3132333435363738393031323334353664636261
+	local r0mac rdev mdev rfd mfd t0
+
+	setup || { log_test_skip "esp"; return; }
+	if ! modprobe -q netdevsim 2>/dev/null && [ ! -w "$NSIM_BUS/new_device" ]; then
+		log_test_skip "esp: no netdevsim"
+		cleanup_all_ns
+		return
+	fi
+	if ! rdev=$(nsim_add "$NSIM_ID" "$NRTR") ||
+	   ! mdev=$(nsim_add $((NSIM_ID + 1)) "$NMID"); then
+		log_test_skip "esp: netdevsim"
+		nsim_del
+		cleanup_all_ns
+		return
+	fi
+	exec {rfd}<"/run/netns/$NRTR" {mfd}<"/run/netns/$NMID"
+	echo "$rfd:$(ip netns exec "$NRTR" cat "/sys/class/net/$rdev/ifindex")" \
+	     "$mfd:$(ip netns exec "$NMID" cat "/sys/class/net/$mdev/ifindex")" \
+	     > "$NSIM_BUS/link_device"
+	exec {rfd}<&- {mfd}<&-
+
+	ip -n "$NRTR" addr add 10.5.0.1/24 dev "$rdev"
+	ip -n "$NMID" addr add 10.5.0.2/24 dev "$mdev"
+	ip -n "$NRTR" link set "$rdev" up
+	ip -n "$NMID" link set "$mdev" up
+	ip -n "$NRTR" neigh add 10.5.0.2 dev "$rdev" lladdr \
+		"$(ip -n "$NMID" -br link show "$mdev" | awk '{ print $3 }')"
+	ip -n "$NRTR" route add "$INNER_DST/32" via 10.5.0.2 dev "$rdev"
+	ip netns exec "$NRTR" ethtool -K "$rdev" tso off >/dev/null
+	if ! ip -n "$NRTR" xfrm state add src 10.5.0.1 dst 10.5.0.2 \
+		proto esp spi 0x100 reqid 1 mode tunnel \
+		aead 'rfc4106(gcm(aes))' "$key" 128 \
+		offload dev "$rdev" dir out ||
+	   ! ip -n "$NRTR" xfrm policy add dir out \
+		src "$INNER_SRC/32" dst "$INNER_DST/32" \
+		tmpl src 10.5.0.1 dst 10.5.0.2 proto esp reqid 1 mode tunnel; then
+		log_test_skip "esp: no ESP offload"
+		nsim_del
+		cleanup_all_ns
+		return
+	fi
+
+	r0mac=$(ip -n "$NRTR" -br link show r0 | awk '{ print $3 }')
+	capture "$NMID" "$mdev" fixed
+	t0=$(fwd_packets "$NRTR")
+	ip netns exec "$NSRC" "$TX" -T -i s0 -M "$r0mac" -s "$INNER_SRC" \
+		-d "$INNER_DST" -n "$SEGS" -b "$BURSTS" -f
+	wait "$CAP_PID"
+	check "esp tunnel offload, fixed inner IDs" "$(tail -n 1 "$RESULT")" \
+		fixed incr $(($(fwd_packets "$NRTR") - t0))
+	cleanup_all_ns
+	nsim_del
+}
+
+require_command ethtool
+require_command tc
+
+if [ ! -x "$TX" ]; then
+	echo "SKIP: $TX not built"
+	exit "$ksft_skip"
+fi
+
+RESULT=$(mktemp)
+
+for type in ipip gre vxlan; do
+	for family in 4 6; do
+		run_encap "$type" "$family" fixed
+		run_encap "$type" "$family" incr
+	done
+done
+run_decap inner
+run_decap outer
+for type in ipip gre vxlan; do
+	run_encap_decap "$type"
+done
+run_esp
+
+exit "$EXIT_STATUS"
-- 
2.53.0

