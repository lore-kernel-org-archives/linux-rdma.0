Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525035;
	b=Y/avzTzKhrJ1+c9nU/+nStqqLa5F8/IHb7CFpWl2oyUiZ4SFAj+yE1Ztd+T+EmU4DUQf
	 k9GACWlbIAkDMKWYaKiuQgP473sgtf9FygMTPy9duNHOLd1K74FryqqiaV9TsInbXnJGb
	 OoTWaj6ZQR/ySdSd7vzCcK8Q6jwgfkMpSk3y6j619Nj8E2cepr/aC0S6EuCg370LW/2B+
	 o5qjujAAGCP2k3hbQjnU3EwvPqpL7wx4zfq+rKnWtEpNAzflGbRI52SPbWuDZ0v3IJeWA
	 8Zgm67FUG5HhqGpl8yqrodgymT3+s6LU38RleufHQkUJMGm//8sh6jyI5Rh7S86PyDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XvBo39oa7bpeKA03NVP1pIOBu5yhj0WFEtus/hl+7BI=;
	b=z17phJJrSP2XSFtnNvTRe6dYgn+fHplgSoGFNJXetWfDep4VD0gh4q3zbMH+wEl7NzKu
	 r4kYPmIyW1h6tLLccaMe2zLCo8UsmVaakrPrL0h6Eho0A8Dr7eLqACnyqSZKV+m5PQ8pa
	 zae8EWl+cgKhe5Am8USdhUBsNcMNGxwlmDvXjroJK8yShOXK3p8w9DxwLborz68bD0mld
	 3wqtTePnhF017e9MqUMuVuciZbeGFOTI1gVBNCg7R5JNO5b4olXfKPTS3d3f+5k1c6jki
	 U4bRYvYPdyLpV8Z7HCwV/8ULvlKPCPuMVAYZPZo7sW0FMkOEmP4HgAVfb3QOn/Nbl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8rrhvUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE18D606A31E;
	Tue, 24 Nov 2026 12:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8rrhvUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715FE1F000C4;
	Tue, 24 Nov 2026 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795525035;
	bh=XvBo39oa7bpeKA03NVP1pIOBu5yhj0WFEtus/hl+7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8rrhvUikY9XPyDwKdD2TMncflHFV8e+wbmxKQ4QphZNP2Jy8JD9raSLZHpmEz87w
	 pMrrYBdpEQVTqFZGUDWVh4W0hgY67f2uM7pg618hvw1Kd052+gWy5QcJi9w4le2e1j
	 +EBnfO/uOfUZ+qBakCkEG+YOuc2VXLkWafL2iyWlH8DzCSNBeWBDOqqTuTDR9DAGlD
	 mhHkY5C5hAEEhv4DBaaUFN4m/Ct6ICFKkc0e352cbU0s9HgZUFuvM7I69GHTmnJ/N7
	 lQQlJbfexhk+yLLgjzrUklGWTK8HXxqPNMehxV6c8/t3OXjHMACvOgYobee95K/7FB
	 ep9mRUzvMKasQ==
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
Subject: [PATCH net-next 01/15] xdp: Let memory providers offer XDP a view of their net_iovs
Date: Tue, 24 Nov 2026 13:56:36 +0100
Message-ID: <20261124125654.183091-1-bjorn@kernel.org>
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

Currently, a net_iov is memory that the kernel does not read.
netmem_address() and skb_frag_address() give NULL for it, and XDP
code, which takes buffer addresses the same way, cannot read it
either. Some providers back net_iovs with memory that the CPU can
reach and XDP must read, such as the UMEM of an AF_XDP socket that
receives in the device's buffer layout, later in this series. io_uring
zcrx could do the same.

Such memory is net_iov and not pages because it is user memory pinned
with GUP. mm owns the struct page fields that page_pool takes over
(lru, where pp_magic and pp live, and mapping), a chunk larger than a
page lies inside a hugetlb folio instead of being a page of its own,
and the provider keeps state per chunk. io_uring zcrx wraps pinned
user pages in net_iovs for the same reasons.

Let a net_iov area offer an XDP view, an address for each of its
net_iovs that XDP code may read and write. Add xdp_netmem_address()
for the head of an XDP buffer and xdp_frag_address() for its
fragments, and use them in bpf_xdp_pointer(), bpf_xdp_copy_buf(),
bpf_xdp_pull_data() and the tail growth of bpf_xdp_adjust_tail().

The area keeps the address and size of the view and the log2 of the
net_iov size, so net_iov i lies at xdp_vaddr + (i << xdp_shift). For
pages the helpers give page_address(), and for a net_iov without a
view they give NULL. dmabuf and io_uring zcrx areas are allocated
zeroed, so they offer no view. AF_XDP sinks are the first to offer
one.

XDP may read a net_iov only through these helpers, and only if its
provider offers a view. Such buffers must not become skb frags or
xdp_frames. For the core and the stack every net_iov stays unreadable,
netmem_address() and skb_frag_address() still give NULL, and
skb->unreadable is still set for every net_iov frag. Other readers get
NULL for a net_iov with a view too, so they fail closed.

The other rules for providers stay. Native XDP runs next to a provider
only if it opts in, and providers without an XDP view still need
header split. AF_XDP sinks are exempt from both through MP_XDP_ONLY.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 include/net/netmem.h |  8 ++++++++
 include/net/xdp.h    | 34 ++++++++++++++++++++++++++++++++++
 net/core/filter.c    |  8 ++++----
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index fb693bc1702a..4cf4ee1cd55d 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -104,6 +104,14 @@ struct net_iov_area {
 	/* Array of net_iovs for this area. */
 	struct net_iov *niovs;
 	size_t num_niovs;
+	/* XDP view, see xdp_netmem_address(): XDP may read and write net_iov i
+	 * at xdp_vaddr + (i << xdp_shift), xdp_vsize bytes in all. NULL if the
+	 * provider offers none. The core and the stack take every net_iov as
+	 * unreadable either way.
+	 */
+	void *xdp_vaddr;
+	size_t xdp_vsize;
+	unsigned int xdp_shift;
 };
 
 static inline struct net_iov_area *net_iov_owner(const struct net_iov *niov)
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 07231adfb5f8..1629e347b71f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -164,6 +164,40 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
 #endif
 }
 
+/* XDP view of net_iovs: a memory provider may give XDP an address for its
+ * net_iovs, see &net_iov_area.xdp_vaddr. XDP code may read and write a
+ * net_iov only through these helpers, and only if its provider offers a
+ * view; such buffers must not become skb frags or xdp_frames. For the core
+ * and the stack every net_iov stays unreadable: netmem_address() and
+ * skb_frag_address() give NULL for it. A net_iov without a view gives NULL
+ * here too, so a reader that does not use these helpers fails closed.
+ */
+static __always_inline void *xdp_net_iov_address(const struct net_iov *niov)
+{
+	const struct net_iov_area *area = net_iov_owner(niov);
+
+	if (!area->xdp_vaddr)
+		return NULL;
+	return area->xdp_vaddr +
+	       ((unsigned long)net_iov_idx(niov) << area->xdp_shift);
+}
+
+/* Address of @netmem, which a driver uses as the head of an XDP buffer */
+static __always_inline void *xdp_netmem_address(netmem_ref netmem)
+{
+	if (netmem_is_net_iov(netmem))
+		return xdp_net_iov_address(netmem_to_net_iov(netmem));
+	return __netmem_address(netmem);
+}
+
+/* Address of the bytes of @frag of an XDP buffer */
+static __always_inline void *xdp_frag_address(const skb_frag_t *frag)
+{
+	void *addr = xdp_netmem_address(skb_frag_netmem(frag));
+
+	return addr ? addr + skb_frag_off(frag) : NULL;
+}
+
 static __always_inline void
 xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
 		 int headroom, int data_len, const bool meta_valid)
diff --git a/net/core/filter.c b/net/core/filter.c
index f42ecfb5841f..d5774b2577e7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4310,7 +4310,7 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsigned long off,
 			break;
 
 		ptr_off += ptr_len;
-		ptr_buf = skb_frag_address(next_frag);
+		ptr_buf = xdp_frag_address(next_frag);
 		ptr_len = skb_frag_size(next_frag);
 		next_frag++;
 	}
@@ -4338,7 +4338,7 @@ void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
 		u32 frag_size = skb_frag_size(&sinfo->frags[i]);
 
 		if  (offset < frag_size) {
-			addr = skb_frag_address(&sinfo->frags[i]);
+			addr = xdp_frag_address(&sinfo->frags[i]);
 			size = frag_size;
 			break;
 		}
@@ -4429,7 +4429,7 @@ static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 	if (unlikely(offset > tailroom))
 		return -EINVAL;
 
-	memset(skb_frag_address(frag) + skb_frag_size(frag), 0, offset);
+	memset(xdp_frag_address(frag) + skb_frag_size(frag), 0, offset);
 	skb_frag_size_add(frag, offset);
 	sinfo->xdp_frags_size += offset;
 	if (rxq->mem.type == MEM_TYPE_XSK_BUFF_POOL)
@@ -12835,7 +12835,7 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
 		skb_frag_t *frag = &sinfo->frags[i];
 		u32 shrink = min_t(u32, delta, skb_frag_size(frag));
 
-		memcpy(xdp->data_end, skb_frag_address(frag), shrink);
+		memcpy(xdp->data_end, xdp_frag_address(frag), shrink);
 
 		xdp->data_end += shrink;
 		sinfo->xdp_frags_size -= shrink;
-- 
2.56.1

