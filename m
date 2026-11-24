Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525192;
	b=jhYjqGDuydmhfBgzvO0ptp7MnozI6OC+OrvVn6p3wcNL7D8TeWsVZMqFFJxaeCLeDjFr
	 DOt+Jt/ecv0PkVJzlJgXyk6dWSRvjz1uncSXgED66fuAuJ1frS/FrFzEIftWR5ZLLdME5
	 ih4IMGeDHeMBqfOYV5LGKe0JugNm11zgnia78yzX5WgMQB65PQPMRMAZ9iw5u6QKFumio
	 ZbKyCXJWzDnEECZdNjV0eEKWE1Nu7pEU09W7A3Gwyt0xwYqY9+gcv4r/VO6SaqyuSQmxG
	 rJbBxZBm/3PPF2/43uI1mnCykREEPhLGrAOhpjHwMBY4uopiIniJM1geUiSQPXdynbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JH7SN0eqX4+dy//G2msSFHnogrii3MMOPPs7zpt5KCk=;
	b=BMZLsW4zRSR7kKpLuXYJGQvriqx4WNkh+4nLuwIeZBnXc9NsBTgk8HTSR0SaYUClZlrv
	 n7nPaDxUHq5x/t2YPCKPmoYkKM/k3oIKR4Ev9F4BArO0Xp5Xnzr5kj4J47ycuahMDer9z
	 FH1PkzChsjsjjtExcCAx9PbxnQ31pHYa9duziMbCN5jZj0R5GSHgmqRwQmokKTFn52dlV
	 MnULCxpVvhJupUbaY46qb0uiPR4roONWUz41rCWg+HsQ1ybR7AXP8kWWqhuvYp0EUdKXk
	 5csXg7mXAX3UjXZ1BJWZCK5IZ3DIZ+B5fZWsO3ReSONhB959BjNgga1kPJ32/QYrgxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+GHAzX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A6606A31E;
	Tue, 24 Nov 2026 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+GHAzX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2C41F000C0;
	Tue, 24 Nov 2026 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525191;
	bh=JH7SN0eqX4+dy//G2msSFHnogrii3MMOPPs7zpt5KCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+GHAzX03lRg07+TG45sX3rbt+DSzDCD0NHrtnEfpUv5EBLHWewpjzRlEAbvht8dh
	 756blsiy7GzCHnjLZT5+7d2Uvr8W/pwnlMG2ULPm5V7GYXEUmTEB2fxnKuqamjQGKc
	 Uz2+y19oH8uPcApACnLrYpvdhogNKMUT4hiIF5zF7PrR0DlLqsbq7RmeAVjqy1smCF
	 FNiw4OlL3DXspoiGaRosZoinnKKlYwNcjinFSmSI8KsXYkAXBWzz+zkUnMBCDDENf8
	 1W40URQ6Y6rkpkDkym9mEflH+LGCdAfcA2GIludExxDlan8RzSTD2eQQB1sfZK8Xac
	 HpWNnvOCFugLQ==
From: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Stuart Clark <stuclar@meta.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-team@meta.com,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin Karsten <mkarsten@uwaterloo.ca>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	David Wei <dw@davidwei.uk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 14/15] selftests: net: xsk: Test the device's RX buffer layout
Date: Tue, 24 Nov 2026 13:56:49 +0100
Message-ID: <20261124125654.183091-14-bjorn@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124112707.118678-1-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently, xskxceiver cannot test a UMEM in the device's buffer
layout, as it expects one chunk per packet at the UMEM headroom and
puts every received chunk back on FILL.

Add -D, which registers the UMEM with XDP_UMEM_DRV_LAYOUT in drv mode
and binds multi-buffer sockets without XDP_COPY.

Buffers may then start anywhere in a chunk and in the packet, so check
their bytes by packet offset, and report how many descriptors of an RX
batch share a chunk. A chunk goes back on FILL only when an RX
descriptor carries XDP_RX_CHUNK_FREE, and empty descriptors are not
packets. Skip the tests that need other chunk sizes or headroom, an RX
descriptor per packet, or two sockets that receive on one queue.

In this layout the queue takes its first buffers from FILL when bind
starts it, and more only when NAPI refills, so populate FILL before
bind. Otherwise packets that arrive before the first refill find no
buffer, and the device drops them. Other modes, and the test that
wants FILL to run dry, keep filling after bind.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 .../testing/selftests/net/lib/xsk/test_xsk.c  | 248 ++++++++++++++++--
 .../testing/selftests/net/lib/xsk/test_xsk.h  |   4 +
 .../selftests/net/lib/xsk/xskxceiver.c        |  25 +-
 3 files changed, 250 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/net/lib/xsk/test_xsk.c b/tools/testing/selftests/net/lib/xsk/test_xsk.c
index ca161511f1e5..bae503432eeb 100644
--- a/tools/testing/selftests/net/lib/xsk/test_xsk.c
+++ b/tools/testing/selftests/net/lib/xsk/test_xsk.c
@@ -19,6 +19,8 @@
 #include "xsk_xdp_progs.skel.h"
 
 #define DEFAULT_BATCH_SIZE		64
+/* Descriptors of an RX batch that count_drv_shared() compares */
+#define DRV_SHARE_WINDOW		64
 #define MIN_PKT_SIZE			64
 #define MAX_ETH_JUMBO_SIZE		9000
 #define MAX_INTERFACES			2
@@ -38,6 +40,9 @@
 static const u8 g_mac[ETH_ALEN] = {0x55, 0x44, 0x33, 0x22, 0x11, 0x00};
 
 bool opt_verbose;
+bool opt_drv_layout;
+/* RX descriptors, and those whose chunk an earlier one of the batch holds */
+u64 drv_rx_descs, drv_rx_shared;
 pthread_barrier_t barr;
 pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
 
@@ -94,6 +99,8 @@ int xsk_configure_umem(struct ifobject *ifobj, struct xsk_umem_info *umem, void
 
 	if (umem->unaligned_mode)
 		cfg.flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
+	if (opt_drv_layout)
+		cfg.flags |= XDP_UMEM_DRV_LAYOUT;
 
 	ret = xsk_umem__create(&umem->umem, buffer, size,
 			       &umem->fq, &umem->cq, &cfg);
@@ -161,7 +168,8 @@ int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem
 	cfg.bind_flags = ifobject->bind_flags;
 	if (shared)
 		cfg.bind_flags |= XDP_SHARED_UMEM;
-	if (ifobject->mtu > MAX_ETH_PKT_SIZE)
+	/* The device may split any frame, see XDP_UMEM_DRV_LAYOUT */
+	if (ifobject->mtu > MAX_ETH_PKT_SIZE || opt_drv_layout)
 		cfg.bind_flags |= XDP_USE_SG;
 	if (umem->comp_size)
 		cfg.tx_size = umem->comp_size;
@@ -262,6 +270,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 	test->set_ring = false;
 	test->adjust_tail = false;
 	test->adjust_tail_support = false;
+	test->adjust_grow = 0;
 	test->mtu = MAX_ETH_PKT_SIZE;
 	test->xdp_prog_rx = ifobj_rx->xdp_progs->progs.xsk_def_prog;
 	test->xskmap_rx = ifobj_rx->xdp_progs->maps.xsk;
@@ -289,7 +298,7 @@ void test_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->bind_flags = XDP_USE_NEED_WAKEUP;
 		if (mode == TEST_MODE_ZC)
 			ifobj->bind_flags |= XDP_ZEROCOPY;
-		else
+		else if (!opt_drv_layout || mode != TEST_MODE_DRV)
 			ifobj->bind_flags |= XDP_COPY;
 	}
 
@@ -878,6 +887,77 @@ static bool is_frag_valid(struct xsk_umem_info *umem, u64 addr, u32 len, u32 exp
 	return false;
 }
 
+/* Driver layout: a buffer may start and end anywhere in the packet, and
+ * anywhere in its chunk. Check its bytes against the generated pattern by
+ * packet offset. XDP_ADJUST_TAIL_GROW zeroes the last @grow bytes and
+ * writes the sequence number of the last word, so that word only needs the
+ * right sequence number, and the bytes before it may be zero.
+ */
+static bool is_frag_valid_drv(struct xsk_umem_info *umem, u64 addr, u32 len,
+			      u32 expected_pkt_nb, u32 bytes_processed,
+			      u32 pkt_len, u32 grow)
+{
+	u32 payload_end = PKT_HDR_SIZE + ((pkt_len - PKT_HDR_SIZE) & ~3U);
+	u8 *bytes = xsk_umem__get_data(umem->buffer, addr);
+	u64 umem_sz = umem_size(umem);
+	u32 i, off, word;
+
+	addr -= umem->base_addr;
+	if (addr >= umem_sz || addr + len > umem_sz ||
+	    addr % umem->frame_size + len > umem->frame_size) {
+		ksft_print_msg("Frag invalid addr: %llx len: %u\n",
+			       (unsigned long long)addr, len);
+		return false;
+	}
+
+	for (i = 0; i < len; i++) {
+		off = bytes_processed + i;
+		if (off < PKT_HDR_SIZE || off >= payload_end)
+			continue;
+		if (off >= pkt_len - grow && !bytes[i])
+			continue;
+
+		off -= PKT_HDR_SIZE;
+		word = htonl(expected_pkt_nb << 16 | (off / 4));
+		if (off / 4 == (payload_end - PKT_HDR_SIZE) / 4 - 1 &&
+		    off % 4 < 2)
+			continue;
+		if (bytes[i] == ((u8 *)&word)[off % 4])
+			continue;
+
+		ksft_print_msg("[%s] pkt %u: byte %u (pkt offset %u) is %#x, expected %#x\n",
+			       __func__, expected_pkt_nb, i,
+			       (u32)(off + PKT_HDR_SIZE), bytes[i],
+			       ((u8 *)&word)[off % 4]);
+		return false;
+	}
+
+	return true;
+}
+
+/* Driver layout: count descriptors whose chunk an earlier descriptor of the
+ * same RX batch holds, that is, chunks the device split. Only the first
+ * DRV_SHARE_WINDOW descriptors of a batch are compared.
+ */
+static void count_drv_shared(struct xsk_umem_info *umem, u64 *chunks, u32 n,
+			     u64 addr)
+{
+	u64 chunk = addr / umem->frame_size;
+	u32 i;
+
+	drv_rx_descs++;
+	if (n >= DRV_SHARE_WINDOW)
+		return;
+
+	for (i = 0; i < n; i++) {
+		if (chunks[i] != chunk)
+			continue;
+		drv_rx_shared++;
+		break;
+	}
+	chunks[n] = chunk;
+}
+
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
 	if (pkt->len != len) {
@@ -983,10 +1063,15 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
 {
 	u32 frags_processed = 0, nb_frags = 0, pkt_len = 0;
 	u32 idx_rx = 0, idx_fq = 0, rcvd, pkts_sent = 0;
+	/* Driver layout: FILL entries written, and those of a partial packet */
+	u32 fills = 0, pkt_fills = 0;
 	struct pkt_stream *pkt_stream = xsk->pkt_stream;
 	struct ifobject *ifobj = test->ifobj_rx;
 	struct xsk_umem_info *umem = xsk->umem;
 	struct pollfd fds = { };
+	u64 batch_chunks[DRV_SHARE_WINDOW];
+	/* Entries of batch_chunks[]: data descriptors only */
+	u32 batch_n = 0;
 	struct pkt *pkt;
 	u64 first_addr = 0;
 	int ret;
@@ -1038,6 +1123,22 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
 		orig = xsk_umem__extract_addr(addr);
 		addr = xsk_umem__add_offset_to_addr(addr);
 
+		/* Driver layout: an empty descriptor only gives a chunk back */
+		if (opt_drv_layout && !desc->len) {
+			if (nb_frags || !(desc->options & XDP_RX_CHUNK_FREE)) {
+				ksft_print_msg("[%s] empty descriptor addr: %lx options: %u\n",
+					       __func__, addr, desc->options);
+				return TEST_FAILURE;
+			}
+			if (ifobj->use_fill_ring) {
+				*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) =
+					orig - orig % umem->frame_size;
+				fills++;
+			}
+			frags_processed++;
+			continue;
+		}
+
 		if (!nb_frags) {
 			pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &pkts_sent);
 			if (!pkt) {
@@ -1050,46 +1151,74 @@ static int __receive_pkts(struct test_spec *test, struct xsk_socket_info *xsk)
 		print_verbose("Rx: addr: %lx len: %u options: %u pkt_nb: %u valid: %u\n",
 			      addr, desc->len, desc->options, pkt->pkt_nb, pkt->valid);
 
-		if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb, pkt_len) ||
-		    !is_offset_correct(umem, pkt, addr) || (ifobj->use_metadata &&
-		    !is_metadata_correct(pkt, umem->buffer, addr)))
+		if (opt_drv_layout) {
+			/* The device picks offsets; metadata precedes the
+			 * head
+			 */
+			if (!is_frag_valid_drv(umem, addr, desc->len,
+					       pkt->pkt_nb, pkt_len,
+					       pkt->len, test->adjust_grow) ||
+			    (ifobj->use_metadata && !nb_frags &&
+			     !is_metadata_correct(pkt, umem->buffer, addr)))
+				return TEST_FAILURE;
+			count_drv_shared(umem, batch_chunks, batch_n++, addr);
+		} else if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb,
+					  pkt_len) ||
+			   !is_offset_correct(umem, pkt, addr) ||
+			   (ifobj->use_metadata &&
+			    !is_metadata_correct(pkt, umem->buffer, addr))) {
 			return TEST_FAILURE;
+		}
 
 		if (!nb_frags++)
 			first_addr = addr;
 		frags_processed++;
 		pkt_len += desc->len;
-		if (ifobj->use_fill_ring)
+		if (!ifobj->use_fill_ring) {
+		} else if (!opt_drv_layout) {
 			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
+		} else if (desc->options & XDP_RX_CHUNK_FREE) {
+			/* Driver layout: only a free chunk goes back to FILL */
+			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) =
+				orig - orig % umem->frame_size;
+			fills++;
+			pkt_fills++;
+		}
 
 		if (pkt_continues(desc->options))
 			continue;
 
 		/* The complete packet has been received */
 		if (!is_pkt_valid(pkt, umem->buffer, first_addr, pkt_len) ||
-		    !is_offset_correct(umem, pkt, addr))
+		    (!opt_drv_layout && !is_offset_correct(umem, pkt, addr)))
 			return TEST_FAILURE;
 
 		pkt_stream->nb_rx_pkts++;
 		nb_frags = 0;
 		pkt_len = 0;
+		pkt_fills = 0;
 	}
 
 	if (nb_frags) {
 		/* In the middle of a packet. Start over from beginning of packet. */
 		idx_rx -= nb_frags;
 		xsk_ring_cons__cancel(&xsk->rx, nb_frags);
-		if (ifobj->use_fill_ring) {
+		if (ifobj->use_fill_ring && !opt_drv_layout) {
 			idx_fq -= nb_frags;
 			xsk_ring_prod__cancel(&umem->fq, nb_frags);
 		}
 		frags_processed -= nb_frags;
+		fills -= pkt_fills;
 		pkt_stream_cancel(pkt_stream);
 		pkts_sent--;
 	}
 
-	if (ifobj->use_fill_ring)
+	if (ifobj->use_fill_ring && opt_drv_layout) {
+		xsk_ring_prod__cancel(&umem->fq, rcvd - fills);
+		xsk_ring_prod__submit(&umem->fq, fills);
+	} else if (ifobj->use_fill_ring) {
 		xsk_ring_prod__submit(&umem->fq, frags_processed);
+	}
 	if (ifobj->release_rx)
 		xsk_ring_cons__release(&xsk->rx, frags_processed);
 
@@ -1161,19 +1290,29 @@ static int receive_pkts(struct test_spec *test)
 }
 
 static int __send_pkts(struct ifobject *ifobject, struct xsk_socket_info *xsk,
-		       bool test_timeout)
+		       bool test_timeout, bool drv_rx)
 {
 	u32 i, idx = 0, valid_pkts = 0, valid_frags = 0, buffer_len;
 	struct xsk_umem_info *umem = ifobject->xsk_arr[0].umem_real;
 	struct pkt_stream *pkt_stream = xsk->pkt_stream;
 	bool use_poll = ifobject->use_poll;
 	struct pollfd fds = { };
-	int ret;
+	int ret, max_in_flight;
 
 	buffer_len = pkt_get_buffer_len(umem, pkt_stream->max_pkt_len);
+	max_in_flight = (umem_size(umem) - xsk->batch_size * buffer_len) /
+			buffer_len;
+	/* A receiver in the device's buffer layout needs more: its queue
+	 * also holds chunks without packets, posted on rings that the
+	 * traffic does not fill, such as a header ring, and in the page
+	 * pool cache. And a packet takes an RX descriptor per buffer, and
+	 * empty ones that give chunks back. Keep a quarter of the frames in
+	 * flight to such a receiver.
+	 */
+	if (drv_rx)
+		max_in_flight /= 4;
 	/* pkts_in_flight might be negative if many invalid packets are sent */
-	if (pkts_in_flight >= (int)((umem_size(umem) - xsk->batch_size * buffer_len) /
-	    buffer_len) && !test_timeout) {
+	if (pkts_in_flight >= max_in_flight && !test_timeout) {
 		ret = kick_tx(xsk);
 		if (ret)
 			return TEST_FAILURE;
@@ -1316,6 +1455,7 @@ bool all_packets_sent(struct test_spec *test, unsigned long *bitmap)
 
 static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 {
+	bool drv_rx = opt_drv_layout && test->ifobj_rx->use_fill_ring;
 	DECLARE_BITMAP(bitmap, test->nb_sockets);
 	u32 i, ret;
 
@@ -1330,7 +1470,8 @@ static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 				__set_bit(i, bitmap);
 				continue;
 			}
-			ret = __send_pkts(ifobject, &ifobject->xsk_arr[i], test->poll_tmout);
+			ret = __send_pkts(ifobject, &ifobject->xsk_arr[i],
+					  test->poll_tmout, drv_rx);
 			if (ret != TEST_CONTINUE)
 				return ret;
 
@@ -1574,6 +1715,7 @@ static int thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	int mmap_flags;
 	u64 umem_sz, mmap_sz;
+	bool fill_first;
 	void *bufs;
 	int ret;
 	u32 i;
@@ -1600,6 +1742,21 @@ static int thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (ret)
 		return ret;
 
+	/* In the device's buffer layout, the queue takes its first buffers
+	 * from FILL when bind starts it: fill FILL first, or the first
+	 * packets find no buffer. A test without the fill ring wants FILL
+	 * to run dry, so it fills after bind as before.
+	 */
+	fill_first = opt_drv_layout && test->mode == TEST_MODE_DRV &&
+		     ifobject->rx_on && ifobject->use_fill_ring;
+	if (fill_first) {
+		ret = xsk_populate_fill_ring(umem,
+					     ifobject->xsk_arr[0].pkt_stream,
+					     ifobject->use_fill_ring);
+		if (ret)
+			return ret;
+	}
+
 	ret = xsk_configure(test, ifobject, umem, false);
 	if (ret)
 		return ret;
@@ -1609,10 +1766,12 @@ static int thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (!ifobject->rx_on)
 		return 0;
 
-	ret = xsk_populate_fill_ring(umem, ifobject->xsk->pkt_stream,
-				     ifobject->use_fill_ring);
-	if (ret)
-		return ret;
+	if (!fill_first) {
+		ret = xsk_populate_fill_ring(umem, ifobject->xsk->pkt_stream,
+					     ifobject->use_fill_ring);
+		if (ret)
+			return ret;
+	}
 
 	for (i = 0; i < test->nb_sockets; i++) {
 		ret = xsk_update_xskmap(ifobject->xskmap, ifobject->xsk_arr[i].xsk, i);
@@ -1789,12 +1948,32 @@ static void clean_umem(struct test_spec *test, struct ifobject *ifobj1, struct i
 		testapp_clean_xsk_umem(ifobj2);
 }
 
+/* UMEM in the device's buffer layout: page chunks, no headroom */
+static bool drv_layout(struct test_spec *test)
+{
+	return opt_drv_layout && test->mode == TEST_MODE_DRV;
+}
+
+static bool drv_layout_umem_ok(struct ifobject *ifobj)
+{
+	struct xsk_umem_info *umem = ifobj->xsk->umem;
+
+	return umem->frame_size == getpagesize() && !umem->frame_headroom &&
+	       !umem->unaligned_mode;
+}
+
 static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
 				      struct ifobject *ifobj2)
 {
 	pthread_t t0, t1;
 	int err;
 
+	if (drv_layout(test) && (!drv_layout_umem_ok(ifobj1) ||
+				 (ifobj2 && !drv_layout_umem_ok(ifobj2)))) {
+		ksft_print_msg("drv layout needs page chunks without headroom\n");
+		return TEST_SKIP;
+	}
+
 	if (test->mtu > MAX_ETH_PKT_SIZE) {
 		if (test->mode == TEST_MODE_ZC && (!ifobj1->multi_buff_zc_supp ||
 						   (ifobj2 && !ifobj2->multi_buff_zc_supp))) {
@@ -1899,11 +2078,12 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 
 int testapp_teardown(struct test_spec *test)
 {
-	int i;
+	int i, ret;
 
 	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
-		if (testapp_validate_traffic(test))
-			return TEST_FAILURE;
+		ret = testapp_validate_traffic(test);
+		if (ret)
+			return ret == TEST_SKIP ? TEST_SKIP : TEST_FAILURE;
 		test_spec_reset(test);
 	}
 
@@ -1926,6 +2106,12 @@ int testapp_bidirectional(struct test_spec *test)
 {
 	int res;
 
+	/* Both sockets would receive on one queue */
+	if (drv_layout(test)) {
+		ksft_print_msg("One socket receives per queue in drv layout\n");
+		return TEST_SKIP;
+	}
+
 	test->ifobj_tx->rx_on = true;
 	test->ifobj_rx->tx_on = true;
 	test->total_steps = 2;
@@ -1960,6 +2146,12 @@ static int swap_xsk_resources(struct test_spec *test)
 
 int testapp_xdp_prog_cleanup(struct test_spec *test)
 {
+	/* The second socket would receive on the queue of the first */
+	if (drv_layout(test)) {
+		ksft_print_msg("One socket receives per queue in drv layout\n");
+		return TEST_SKIP;
+	}
+
 	test->total_steps = 2;
 	test->nb_sockets = 2;
 	if (testapp_validate_traffic(test))
@@ -2013,6 +2205,12 @@ int testapp_stats_rx_full(struct test_spec *test)
 {
 	struct pkt_stream *tmp;
 
+	/* Empty descriptors that give chunks back take RX slots too */
+	if (drv_layout(test)) {
+		ksft_print_msg("RX slots are not all packets in drv layout\n");
+		return TEST_SKIP;
+	}
+
 	tmp = pkt_stream_generate(DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
 	if (!tmp)
 		return TEST_FAILURE;
@@ -2209,6 +2407,12 @@ int testapp_xdp_shared_umem(struct test_spec *test)
 	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
 	int ret;
 
+	/* Both sockets would receive on one queue */
+	if (drv_layout(test)) {
+		ksft_print_msg("One socket receives per queue in drv layout\n");
+		return TEST_SKIP;
+	}
+
 	test->total_steps = 1;
 	test->nb_sockets = 2;
 
@@ -2535,6 +2739,8 @@ static int testapp_adjust_tail(struct test_spec *test, u32 value, u32 pkt_len)
 
 	test->adjust_tail_support = true;
 	test->adjust_tail = true;
+	/* A negative value shrinks */
+	test->adjust_grow = (int)value > 0 ? value : 0;
 	test->total_steps = 1;
 
 	ret = pkt_stream_replace_ifobject(test->ifobj_tx, DEFAULT_BATCH_SIZE, pkt_len);
diff --git a/tools/testing/selftests/net/lib/xsk/test_xsk.h b/tools/testing/selftests/net/lib/xsk/test_xsk.h
index 2506b0dcc6bf..4f4956c0440f 100644
--- a/tools/testing/selftests/net/lib/xsk/test_xsk.h
+++ b/tools/testing/selftests/net/lib/xsk/test_xsk.h
@@ -35,6 +35,9 @@
 #define SMP_CACHE_BYTES_PATH "/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
 
 extern bool opt_verbose;
+/* XDP_UMEM_DRV_LAYOUT: the device lays out RX buffers in UMEM chunks */
+extern bool opt_drv_layout;
+extern u64 drv_rx_descs, drv_rx_shared;
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
 
@@ -200,6 +203,7 @@ struct test_spec {
 	struct bpf_map *xskmap_tx;
 	test_func_t test_func;
 	int mtu;
+	u32 adjust_grow;
 	u16 total_steps;
 	u16 current_step;
 	u16 nb_sockets;
diff --git a/tools/testing/selftests/net/lib/xsk/xskxceiver.c b/tools/testing/selftests/net/lib/xsk/xskxceiver.c
index 0a63651434a5..6b00a586b3af 100644
--- a/tools/testing/selftests/net/lib/xsk/xskxceiver.c
+++ b/tools/testing/selftests/net/lib/xsk/xskxceiver.c
@@ -64,11 +64,6 @@
  * - Tx thread Transmits a number of packets from veth<xxxx> to veth<yyyy>
  * - Rx thread verifies if all packets were received and delivered in-order,
  *   and have the right content
- *
- * Enable/disable packet dump mode:
- * --------------------------
- * To enable L2 - L4 headers and payload dump of each packet on STDOUT, add
- * parameter -D to params array in test_xsk.sh, i.e. params=("-S" "-D")
  */
 
 #define _GNU_SOURCE
@@ -164,6 +159,7 @@ static struct option long_options[] = {
 	{"mode", required_argument, 0, 'm'},
 	{"list", no_argument, 0, 'l'},
 	{"test", required_argument, 0, 't'},
+	{"drv-layout", no_argument, 0, 'D'},
 	{"help", no_argument, 0, 'h'},
 	{0, 0, 0, 0}
 };
@@ -179,6 +175,7 @@ static void print_usage(char **argv)
 		"  -m, --mode           Run only mode skb, drv, or zc\n"
 		"  -l, --list           List all available tests\n"
 		"  -t, --test           Run a specific test. Enter number from -l option.\n"
+		"  -D, --drv-layout     Receive in the device's buffer layout (drv mode)\n"
 		"  -h, --help           Display this help and exit\n";
 
 	ksft_print_msg(str, basename(argv[0]));
@@ -202,7 +199,8 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:vbm:lt:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:vbm:lt:D", long_options,
+				&option_index);
 		if (c == -1)
 			break;
 
@@ -244,6 +242,9 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 		case 'l':
 			opt_print_tests = true;
 			break;
+		case 'D':
+			opt_drv_layout = true;
+			break;
 		case 't':
 			errno = 0;
 			opt_run_test = strtol(optarg, NULL, 0);
@@ -255,6 +256,12 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 			print_usage(argv);
 		}
 	}
+
+	/* The device's buffer layout is a drv mode feature */
+	if (opt_drv_layout && opt_mode == TEST_MODE_ALL)
+		opt_mode = TEST_MODE_DRV;
+	else if (opt_drv_layout && opt_mode != TEST_MODE_DRV)
+		print_usage(argv);
 }
 
 static void xsk_unload_xdp_programs(struct ifobject *ifobj)
@@ -266,7 +273,13 @@ static void run_pkt_test(struct test_spec *test)
 {
 	int ret;
 
+	drv_rx_descs = 0;
+	drv_rx_shared = 0;
 	ret = test->test_func(test);
+	if (opt_drv_layout)
+		ksft_print_msg("drv layout: rx descs %llu, in a chunk shared within an RX batch %llu\n",
+			       (unsigned long long)drv_rx_descs,
+			       (unsigned long long)drv_rx_shared);
 
 	switch (ret) {
 	case TEST_PASS:
-- 
2.56.1

