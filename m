Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194BC3B14DD
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 17:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784483999; cv=none; b=hNPESUx9G07DmeFxghuv+b3AN9frmu/OAc8zl1/fMMVH0iI4l8ubOQxQ904fbHvWf+f8hsBIrxE5cw5zCRUQLlzRJlYekJD4Tyj0Hz3Df373C0SF6ypCod/jFEzTjAZ5olMPgtn59wRbehMTW3vUcVKFUVVCn45Vyqxxi6Cr48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784483999; c=relaxed/simple;
	bh=SxgeUFl3a/Kj5MuHYmf7LKaXCbqGDkZ6eIkZB5MHqKs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjU/uTvckb8co8175MFryNh5hBq1Rj8zspbxcPrO1ZsVfGFPimzPSQ44grRUu06XalE9SUM1J1Iejt2bZ+EOcpm9N1FAQi20chnHF5xbOqM8Mnj9AKTRkhXDOTUp2V96CfrUQh5iHNdBLZeOAdqYwUFpSAuWvkyB/Hr8ux1SEJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=owwlH9u/; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="owwlH9u/"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cf41bab353so24082865ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784483991; x=1785088791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YyqhYngq0RlhZPKjh6r1tvXs2LIUb0LhEqMCu17FH5w=;
        b=owwlH9u/0Fu67JElRT0sfgxqvdSiHmThPeMC6yGJWcLNCbm4rqMMZEG0UhxhRwwEOZ
         JutYlW2S17eOzRQYWk6HfRXfYJnW2BdPcM1DdDqyRUBfYIakGIGguuOwUI3P30ezR4uA
         GmqgMYuIGtECbbkP5TC2T2L4WBfPl9wHw5SmK+qLH8mJIEmqk/lY6TGELFUnwW00BuNM
         09K+HnZIKPqjBWL5Bz3rePDxHFZNLtUAYcpxjFPXHKEJwu9nfUwKYrU6SuBro0MmtH+R
         jO99oMAIJ0qxQQgzkV/m+qwISecWr1WA3WLznrH9wNazHseaBGQsl7oB0q+90WfCmVRr
         eJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784483991; x=1785088791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YyqhYngq0RlhZPKjh6r1tvXs2LIUb0LhEqMCu17FH5w=;
        b=D/tgEU6+Mf+omEVndCPKU1084EE2jTmPCvk0ct+RD0iTSn3eoS+oZfcCQPbX4uQ4qd
         LFtv5c+GM5IdGCDXfeaV6FyWCltEV2/GkcbCZMir/LKbUYixLndgzCwIRCayrpUTKgfP
         PUiuDnviAzcxvp5T/j3kf4yVZuBBupX9w7sQ5D1GS9mu0zaHMypQYNp6guUJ7DsNilRl
         rqZsmmaL+0tDwLzwh0i4LYEO58xSNUNhNQmY11choQ63RABGwUVy7je92uvyZy8NfbVC
         +Q+McvI3M+ltrx3oAwOWQXDFRGyBCHeI5joX9sLpZv6S6mWxNRKJVf+dO2Mmf1//P4Sj
         GQrw==
X-Forwarded-Encrypted: i=1; AHgh+RqmY+e1vWhrNiY8nmAZL8hGAXRCokcw65jfdn69vxA6jHjtZPFKZg219GHcEcMwfxY1l3XCPsUr3w5D@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8SBtlS0lNsapxBjfHEGtrJf09kHbWr3AH2Qhw8EadM+uc02lD
	WrhXnaJeX+NfTnC7DlwAUvkepWhsRWwyq6OtSyHd2wDNELBaUuoP13m5
X-Gm-Gg: AfdE7clCqZYPfrIaB/LGJWy7NA6a5Zvh9n+dEkmKVTY7ZNqVOqyGNyEBlluPztP0yH3
	QwwUN3+znaRTM7EhyT4/QnNuabjMrrXXI+72MJ9UjI+7tzEJkugssiRx7khdvxuixTli7dvhNwH
	9UEmgsLY9PAU0nAehYmopdxMevmpndR0CK9EIiAAzJtWY3m+RVTPvDPMEFDUt0bFySYIvqIjfJM
	8fJB5r/cAj3uvm4AaaIuZZOYEuvAzkqagcLnaiKuzh0DyuYCd7Xm+CBD1CFYC5aPK5YhL1wCHZk
	E4oxLN9QG3yq4oOYa+/xlu6Q2S5wzRlkE+qlQEFsv7raIqcjkH1Divppdq+2QqaRa7ph70VfX1Q
	JVOa2DC/3wUN/qKW8kU2IdVzBgAxb793A4EsEdFgZccA6hOspKCVPgghfRT4c2m5VcQ==
X-Received: by 2002:a17:903:1987:b0:2ce:9c48:22d3 with SMTP id d9443c01a7336-2cf348840dfmr128578695ad.11.1784483990726;
        Sun, 19 Jul 2026 10:59:50 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.10.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 10:59:49 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Alexei Starovoitov <ast@kernel.org>,
	amd-gfx@lists.freedesktop.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Bill Wendling <morbo@google.com>,
	bpf@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Hoyeon Lee <hoyeon.rhee@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michael Chan <michael.chan@broadcom.com>,
	Nathan Chancellor <nathan@kernel.org>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [RFC PATCH net-next 01/13] net: knod: add uapi and core headers
Date: Sun, 19 Jul 2026 17:58:45 +0000
Message-ID: <20260719175857.4071636-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719175857.4071636-1-ap420073@gmail.com>
References: <20260719175857.4071636-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the uAPI and core headers for KNOD, an in-kernel network offload
device that connects a NIC RX path to an accelerator (e.g. a GPU) for
zero-copy packet processing.

 - include/uapi/linux/knod.h: genetlink uAPI
 - Documentation/netlink/specs/knod.yaml: netlink spec
 - include/net/knod.h: core framework types and ops
 - include/net/spsc_ring.h: lock-free SPSC ring for the data path

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit d93829acbce14528fcf70e155a0594c0c6151cce)
---
 Documentation/netlink/specs/knod.yaml | 176 +++++++
 include/net/knod.h                    | 467 +++++++++++++++++++
 include/net/spsc_ring.h               | 645 ++++++++++++++++++++++++++
 include/uapi/linux/knod.h             |  67 +++
 4 files changed, 1355 insertions(+)
 create mode 100644 Documentation/netlink/specs/knod.yaml
 create mode 100644 include/net/knod.h
 create mode 100644 include/net/spsc_ring.h
 create mode 100644 include/uapi/linux/knod.h

diff --git a/Documentation/netlink/specs/knod.yaml b/Documentation/netlink/specs/knod.yaml
new file mode 100644
index 000000000000..7c64df467634
--- /dev/null
+++ b/Documentation/netlink/specs/knod.yaml
@@ -0,0 +1,176 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+---
+name: knod
+
+doc:
+  KNOD (KFD network offload) control plane.
+
+  Bind a NIC netdevice to a GPU/DPU offload accelerator and select which
+  offload feature (BPF, IPsec) the accelerator runs.
+
+definitions:
+  -
+    type: enum
+    name: feature
+    entries: [none, bpf, ipsec]
+  -
+    type: enum
+    name: accel-type
+    entries: [gpu, dpu]
+
+attribute-sets:
+  -
+    name: accel
+    attributes:
+      -
+        name: id
+        doc: Accelerator id.
+        type: u32
+        checks:
+          min: 1
+      -
+        name: name
+        doc: Accelerator name.
+        type: string
+      -
+        name: type
+        doc: Accelerator type.
+        type: u32
+        enum: accel-type
+      -
+        name: feature-cap
+        doc: Bitmask of offload features the accelerator supports.
+        type: u32
+        enum: feature
+        enum-as-flags: true
+      -
+        name: feature-ena
+        doc: Currently active offload feature on the accelerator.
+        type: u32
+        enum: feature
+  -
+    name: nic
+    attributes:
+      -
+        name: ifindex
+        doc: ifindex of the NIC netdevice registered with KNOD.
+        type: u32
+        checks:
+          min: 1
+      -
+        name: name
+        doc: Name of the NIC netdevice.
+        type: string
+  -
+    name: dev
+    attributes:
+      -
+        name: nic-ifindex
+        doc: ifindex of the bound NIC netdevice.
+        type: u32
+        checks:
+          min: 1
+      -
+        name: accel-id
+        doc: id of the bound accelerator.
+        type: u32
+        checks:
+          min: 1
+
+operations:
+  list:
+    -
+      name: accel-get
+      doc: Get / dump accelerators registered on the system.
+      attribute-set: accel
+      do:
+        request:
+          attributes:
+            - id
+        reply: &accel-all
+          attributes:
+            - id
+            - name
+            - type
+            - feature-cap
+            - feature-ena
+      dump:
+        reply: *accel-all
+    -
+      name: accel-set
+      doc: Select the active offload feature of an accelerator.
+      attribute-set: accel
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - id
+            - feature-ena
+        reply:
+          attributes: []
+    -
+      name: nic-get
+      doc: Get / dump NICs registered with the KNOD framework.
+      attribute-set: nic
+      do:
+        request:
+          attributes:
+            - ifindex
+        reply: &nic-all
+          attributes:
+            - ifindex
+            - name
+      dump:
+        reply: *nic-all
+    -
+      name: attach
+      doc: Attach a NIC netdevice to an accelerator.
+      attribute-set: dev
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - nic-ifindex
+            - accel-id
+        reply:
+          attributes: []
+    -
+      name: detach
+      doc: Detach a NIC netdevice from its accelerator.
+      attribute-set: dev
+      flags: [admin-perm]
+      do:
+        request:
+          attributes:
+            - nic-ifindex
+        reply:
+          attributes: []
+    -
+      name: dev-get
+      doc: Get / dump active NIC <-> accelerator bindings.
+      attribute-set: dev
+      do:
+        request:
+          attributes:
+            - nic-ifindex
+        reply: &dev-all
+          attributes:
+            - nic-ifindex
+            - accel-id
+      dump:
+        reply: *dev-all
+    -
+      name: dev-add-ntf
+      doc: Notification about a new NIC <-> accelerator binding.
+      notify: dev-get
+      mcgrp: mgmt
+    -
+      name: dev-del-ntf
+      doc: Notification about a removed NIC <-> accelerator binding.
+      notify: dev-get
+      mcgrp: mgmt
+
+mcast-groups:
+  list:
+    -
+      name: mgmt
diff --git a/include/net/knod.h b/include/net/knod.h
new file mode 100644
index 000000000000..50333b0e028b
--- /dev/null
+++ b/include/net/knod.h
@@ -0,0 +1,467 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_KNOD_H
+#define __NET_KNOD_H
+
+#include <linux/bpf.h>
+#include <linux/dma-buf.h>
+#include <linux/ethtool_netlink.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/rtnetlink.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/if_link.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/atomic.h>
+#include <net/xdp.h>
+#include <net/spsc_ring.h>
+
+struct knod_dev;
+struct knod_netdev;
+struct knod_accel;
+struct gen_pool;
+struct page_pool;
+struct netlink_ext_ack;
+struct net_devmem_dmabuf_binding;
+
+extern struct mutex knod_lock;
+
+struct spsc_bd {
+	netmem_ref netmem;
+	u64 act;
+	u16 off;
+	u16 len;
+	u32 page_idx;
+	struct page_pool *pp;
+};
+
+/*
+ * KNOD action codes for spsc_bd.act
+ *
+ * Base actions (compatible with XDP constants for BPF/XDP path):
+ */
+#define KNOD_ABORTED	XDP_ABORTED	/* 0 */
+#define KNOD_DROP	XDP_DROP	/* 1 */
+#define KNOD_PASS	XDP_PASS	/* 2 */
+#define KNOD_TX		XDP_TX		/* 3 */
+#define KNOD_REDIRECT	XDP_REDIRECT	/* 4 */
+
+/*
+ * Extended actions - accel-specific, must not collide with XDP range [0..7].
+ * The NIC act_handler treats any unknown code as "in-flight to accel":
+ * stop releasing at that entry and wait for the accel to update bd->act.
+ */
+#define KNOD_ACT_INFLIGHT	0x80	/* accel processing in progress */
+#define KNOD_IPSEC_INFLIGHT	0x100	/* GPU IPsec dispatch in progress */
+#define KNOD_IPSEC_PASS		0x101	/* GPU IPsec done, recycle page */
+#define KNOD_IPSEC_DROP		0x102	/* GPU IPsec done, drop + recycle */
+
+/*
+ * PASS hand-off descriptor: the DD (NIC act_handler) fills one per PASS bd
+ * during its single act traversal and hands a batch to accel_ops->pass_copy.
+ * @netmem is the source RX page (GPU memory); @off/@len are post-BPF (may
+ * differ from the bd's original values if the program adjusted head/tail).
+ */
+struct spsc_pass_bd {
+	/* source RX page, recycled after the copy lands */
+	netmem_ref netmem;
+	u32 page_idx;		/* page index in the queue's dmabuf RX buffer
+				 * (the accel turns this into the GPU src addr;
+				 * the netmem dma_addr is the NIC's, not the
+				 * GPU's)
+				 */
+	u16 off;		/* packet offset within the page (post-BPF) */
+	u16 len;		/* packet length (post-BPF) */
+};
+
+/*
+ * Host-page page_pool provider context (GPU->host delivery pools).  The
+ * framework fills the public fields, points page_pool_params.mp_priv at it and
+ * sets .mp_ops to the NOD-private page_pool_hostmem_ops (knod_dev.c);
+ * ->init() builds @genpool and ->destroy() tears it down.  Must outlive the
+ * page_pool; @freed fires once the pool has fully drained.
+ */
+struct page_pool_hostmem {
+	struct page **pages;		/* owner-supplied, @count real pages */
+	unsigned int count;
+	dma_addr_t base_addr;		/* device addr of pages[0] */
+	void (*freed)(void *arg);	/* called once the pool fully drains */
+	void *arg;
+	struct gen_pool *genpool;	/* private: managed by the provider */
+};
+
+struct knod_work_priv {
+	struct dma_buf *dmabuf;
+	netmem_ref *netmems;
+	unsigned int *data_lens;
+	int *data_offs;
+	int cnt;
+	int index;
+	struct napi_struct *napi;
+	struct spsc_ring spsc_bds;
+	void *spsc_pool_priv;	/* accel driver priv for spsc pool memory */
+	u64 spsc_pool_gaddr;	/* device-visible address of spsc pool */
+	/* framework-owned delivery pool */
+	struct page_pool *pass_pool;
+	/* provider ctx (owner storage) */
+	struct page_pool_hostmem pass_hm;
+	/* d2h: SDMA-issued, awaiting drain */
+	struct spsc_ring pass_pending;
+} ____cacheline_aligned_in_smp;
+
+static inline void knod_napi_kick(struct knod_work_priv *wpriv)
+{
+	struct napi_struct *napi;
+
+	rcu_read_lock();
+	napi = READ_ONCE(wpriv->napi);
+	if (napi)
+		napi_schedule(napi);
+	rcu_read_unlock();
+}
+
+#define KNOD_DEFAULT_PASS_SLOTS	64
+
+/*
+ * GPU->host delivery descriptor: a packet at @off (preserved headroom) for
+ * @len bytes within @netmem, a page from the framework delivery pool.  The
+ * d2h path fills these into the per-queue pass_pending ring; knod_d2h_drain()
+ * turns each into an skb once its SDMA copy lands and hands it to the stack.
+ */
+struct knod_pass_desc {
+	u16 len;		/* head_frag length (ipsec: inner_len) */
+	u16 off;		/* head_frag offset (ipsec: inner_off) */
+	netmem_ref netmem;	/* dst: framework delivery-pool page */
+	netmem_ref src;		/* src: RX page recycled once the copy lands, or
+				 * 0 when the producer recycles it elsewhere
+				 * (ipsec: NIC act handler recycles via the bd)
+				 */
+	/* SDMA fence to await before delivery (async) */
+	u32 fence_val;
+	u8  sdma_idx;		/* which accel SDMA queue's fence to await */
+	/* Feature finalisation context, consumed by knod_dev->post_copy. */
+	struct {
+		u32 sa_slot;	/* ipsec SA table slot */
+		u32 seq_lo;	/* ESP sequence low 32 bits */
+		u32 seq_hi;	/* ESN high 32 bits (0 if !ESN) */
+		u8  mode;	/* XFRM_MODE_TRANSPORT / _TUNNEL */
+		u8  next_hdr;	/* ESP trailer next-header */
+		u8  family;	/* AF_INET / AF_INET6 */
+	} feat;
+};
+
+struct knod_accel_xdp_ops {
+	/* init/exit: permanent per-attach setup (attach/detach). */
+	int (*init)(struct knod_dev *knodev);
+	void (*exit)(struct knod_dev *knodev);
+	/* activate/deactivate: feature resource alloc/free (feature select). */
+	int (*activate)(struct knod_dev *knodev);
+	void (*deactivate)(struct knod_dev *knodev);
+	/*
+	 * true while user XDP progs/maps are still bound (blocks feature
+	 * switch).
+	 */
+	bool (*busy)(struct knod_dev *knodev);
+	int (*xdp_offload_init)(struct knod_dev *knodev);
+	void (*xdp_offload_uninit)(struct knod_dev *knodev);
+	int (*xdp_install)(struct knod_dev *knodev,
+			   struct netdev_bpf *bpf);
+	int (*rx_netmem)(struct knod_dev *knodev, netmem_ref netmem,
+			 unsigned int data_len, int data_offset, int index);
+	int (*rx_netmem_bulk)(struct knod_dev *knodev,
+			      struct knod_work_priv *wpriv);
+	/* Direct dispatch */
+	int (*dispatch)(struct knod_dev *knodev, int index);
+	/* Direct finish */
+	int (*finish)(struct knod_dev *knodev, int index);
+	void (*start)(struct knod_dev *knodev);
+	void (*stop)(struct knod_dev *knodev);
+};
+
+struct xfrm_state;
+struct xfrm_policy;
+struct netlink_ext_ack;
+
+struct knod_accel_ipsec_ops {
+	/* init/exit: permanent per-attach setup (attach/detach). */
+	int (*init)(struct knod_dev *knodev);
+	void (*exit)(struct knod_dev *knodev);
+	/* activate/deactivate: feature resource alloc/free (feature select). */
+	int (*activate)(struct knod_dev *knodev);
+	void (*deactivate)(struct knod_dev *knodev);
+	/*
+	 * true while offloaded xfrm SAs are still bound (blocks feature
+	 * switch).
+	 */
+	bool (*busy)(struct knod_dev *knodev);
+	/*
+	 * start/stop: worker/dispatcher start + GPU drain (interface
+	 * up/down).
+	 */
+	void (*start)(struct knod_dev *knodev);
+	void (*stop)(struct knod_dev *knodev);
+	int (*xdo_dev_state_add)(struct knod_dev *knodev,
+				 struct xfrm_state *x,
+				 struct netlink_ext_ack *extack);
+	void (*xdo_dev_state_delete)(struct knod_dev *knodev,
+				     struct xfrm_state *x);
+	void (*xdo_dev_state_free)(struct knod_dev *knodev,
+				   struct xfrm_state *x);
+	bool (*xdo_dev_offload_ok)(struct knod_dev *knodev,
+				   struct sk_buff *skb,
+				   struct xfrm_state *x);
+	void (*xdo_dev_state_advance_esn)(struct knod_dev *knodev,
+					  struct xfrm_state *x);
+	void (*xdo_dev_state_update_stats)(struct knod_dev *knodev,
+					   struct xfrm_state *x);
+	int (*xdo_dev_policy_add)(struct knod_dev *knodev,
+				  struct xfrm_policy *x,
+				  struct netlink_ext_ack *extack);
+	void (*xdo_dev_policy_delete)(struct knod_dev *knodev,
+				      struct xfrm_policy *x);
+	void (*xdo_dev_policy_free)(struct knod_dev *knodev,
+				    struct xfrm_policy *x);
+};
+
+struct knod_accel_ops {
+	int (*attach)(struct knod_dev *knodev);
+	void (*pre_detach)(struct knod_dev *knodev);
+	void (*detach)(struct knod_dev *knodev);
+	/* interface up/down (NIC driver knod_dev_start/stop): worker only. */
+	void (*dev_start)(struct knod_dev *knodev);
+	void (*dev_stop)(struct knod_dev *knodev);
+	void *(*alloc_mem)(struct knod_dev *knodev, size_t size,
+			   u64 *gaddr, struct page ***pages, void **priv);
+	void (*free_mem)(struct knod_dev *knodev, void *priv);
+	/*
+	 * Map dmabuf RX BOs into the GPU VM; must run after
+	 * knod_dmabuf_attach().
+	 */
+	int (*mp_map)(struct knod_dev *knodev);
+	/*
+	 * Device->host copy primitives, used by the common knod_d2h_copy /
+	 * knod_d2h_drain delivery path.  The accel owns the SDMA engine (and
+	 * its fence/ring); the framework owns the pending ring and dst pool.
+	 *   d2h_submit: queue one GPU->host copy.  Returns a monotonic fence
+	 *               position to tag the descriptor with, or 0 if the SDMA
+	 *               ring is full (caller drops -- backpressure).
+	 *   d2h_kick:   publish the batch (fence + doorbell).
+	 *   d2h_fence:  current completed fence position of an SDMA queue
+	 *               (drain compares the descriptor's tag against this).
+	 */
+	u32 (*d2h_submit)(struct knod_dev *knodev, u64 dst, int queue,
+			  u32 page_idx, u16 off, u32 len);
+	void (*d2h_kick)(struct knod_dev *knodev);
+	u32 (*d2h_fence)(struct knod_dev *knodev, int sdma_idx);
+	struct knod_accel_xdp_ops *xdp_ops;
+	struct knod_accel_ipsec_ops *ipsec_ops;
+
+	/* control plane (knod genetlink) feature select */
+	int (*feature_get)(struct knod_accel *accel, u32 *ena, u32 *cap);
+	int (*feature_set)(struct knod_accel *accel, u32 feature,
+			   struct netlink_ext_ack *extack);
+};
+
+struct knod_nic_ops {
+	int (*attach)(struct knod_dev *knodev);
+	int (*detach)(struct knod_dev *knodev);
+	int (*tx_handler)(struct knod_dev *knodev, struct spsc_bd **bds,
+			  int cnt, int napi_index, void *priv);
+	int (*redir_handler)(struct knod_dev *knodev, netmem_ref *netmems,
+			     u16 *lens, int cnt, int napi_index,
+			     struct net_device *target_dev, void *priv);
+	int (*drop_handler)(struct knod_dev *knodev, netmem_ref *netmems,
+			    u16 *lens, int cnt, void *priv);
+};
+
+struct knod_dev_stats {
+	u64_stats_t             tx_packets;
+	u64_stats_t             tx_bytes;
+	struct u64_stats_sync   syncp;
+	u32                     tx_dropped;
+	u32                     tx_errors;
+};
+
+#define __NOD_FLAGS_XDP		0
+#define __NOD_FLAGS_IPSEC	2
+#define __NOD_FLAGS_KTLS	3
+#define __NOD_FLAGS_MAX		(__NOD_FLAGS_KTLS + 1)
+#define KNOD_FLAGS_XDP		(1 << __NOD_FLAGS_XDP)
+#define KNOD_FLAGS_IPSEC		(1 << __NOD_FLAGS_IPSEC)
+#define KNOD_FLAGS_KTLS		(1 << __NOD_FLAGS_KTLS)
+
+#define KNOD_TYPE_GPU		0
+#define KNOD_TYPE_DPU		1
+#define KNOD_TYPE_MAX		(KNOD_TYPE_DPU + 1)
+
+#define KNOD_SPSC_MAX		32
+#define KNOD_SPSC_ELEMS_MAX	8192
+
+/* Per-RX-queue GPU->host delivery pages (in-flight cap; sized for the deepest
+ * feature pipeline, independent of any per-feature descriptor ring size).
+ * Must cover the worst case where one RSS-concentrated flow lands every
+ * in-flight work on a single queue: ipsec holds a full batch of delivery
+ * pages per work (alloc precedes the SDMA copy into them), so the cap needs
+ * KNOD_IPSEC_NR_WORK * KNOD_IPSEC_PKT_BATCH (= 4 * 512) plus the pass_pending
+ * ring depth. Sized to absorb a full bd ring (KNOD_SPSC_ELEMS_MAX = 8192)
+ * worth of decrypted-but-undelivered packets plus the in-flight works. The
+ * backing is GTT, sized nqueues * KNOD_PASS_SLOTS * PAGE_SIZE (2 GiB at the
+ * 32-queue cap), which is why the alloc size path is size_t rather than int.
+ */
+#define KNOD_PASS_SLOTS		16384
+
+#define KNOD_STATUS_FREE		0
+#define KNOD_STATUS_USED		1
+
+struct knod_netdev {
+	struct list_head list;
+	struct net_device *dev;
+	struct knod_dev *knodev;
+	struct knod_accel *accel;
+	struct knod_nic_ops *nic_ops;
+	struct module *owner;
+	int flags;
+	int status;
+	void *priv;
+};
+
+struct knod_accel_xdp {
+	struct bpf_offload_dev *bpf_dev;
+	struct xdp_attachment_info xdp;
+	struct xdp_attachment_info xdp_hw;
+	struct bpf_prog *bpf_offloaded;
+	struct list_head bound_maps;
+	void *priv;
+};
+
+struct knod_accel {
+	struct list_head list;
+	struct knod_accel_ops *accel_ops;
+	struct module *owner;
+	struct knod_accel_xdp xdp;
+	struct knod_dev *knodev;
+	struct knod_netdev *knetdev;
+	int status;
+	int type;
+	int flags;
+	int id;
+	void *priv;
+	char name[16];
+};
+
+struct knod_dev {
+	struct list_head list;
+	struct knod_netdev *knetdev;
+	struct knod_accel *accel;
+	struct net_devmem_dmabuf_binding *bindings[KNOD_SPSC_MAX];
+	struct mutex lock;
+	struct net_device *netdev;
+	struct knod_dev_stats *stats __percpu;
+
+	struct knod_nic_ops *nic_ops;
+	struct knod_accel_ops *accel_ops;
+	/* per-queue priv data */
+	struct knod_work_priv *wpriv;
+	bool started;
+
+	/* IPsec proxy: original NIC xfrmdev_ops/feature state saved at attach,
+	 * restored at detach so a NIC's native offload is not clobbered.
+	 */
+	const struct xfrmdev_ops *ipsec_orig_xfrmdev_ops;
+	bool ipsec_added_hw_esp;
+
+	/* framework-owned GPU->host delivery (default pass): drain barrier */
+	/* accel handle for the delivery buffer */
+	void *pass_priv;
+	atomic_t pp_live;		/* live delivery page_pools */
+	struct completion pp_drained;	/* all pools drained (teardown) */
+	/*
+	 * device->host (d2h) delivery: the accel owns the fence counter (its
+	 * SDMA ring position); this lock just serialises the shared SDMA
+	 * submit path across the per-queue NAPIs that drive knod_d2h_copy.
+	 */
+	spinlock_t d2h_lock;
+
+	/*
+	 * Feature delivery hook, set by the active feature on activate (NULL
+	 * for bpf/none).  knod_d2h_drain calls it after building the head_frag
+	 * skb to run feature-specific finalisation (ipsec: SA/replay/secpath);
+	 * it returns false to drop the packet.
+	 */
+	bool (*post_copy)(struct knod_dev *knodev, struct sk_buff *skb,
+			  const struct knod_pass_desc *desc, int queue_idx);
+};
+
+static inline bool knod_dev_active(struct knod_dev *knodev)
+{
+	return !!knodev->accel->xdp.xdp_hw.prog;
+}
+
+static inline struct bpf_prog *
+knod_dev_offloaded(struct knod_dev *knodev)
+{
+	return knodev->accel->xdp.bpf_offloaded;
+}
+
+static inline void knod_dev_offload(struct knod_dev *knodev,
+					   struct bpf_prog *bpf_offloaded)
+{
+	knodev->accel->xdp.bpf_offloaded = bpf_offloaded;
+}
+
+static inline bool knod_dev_map_empty(struct knod_dev *knodev)
+{
+	return list_empty(&knodev->accel->xdp.bound_maps);
+}
+
+void knod_netdev_register(struct knod_netdev *netdev);
+void knod_netdev_unregister(struct knod_netdev *netdev);
+void knod_accel_register(struct knod_accel *accel);
+void knod_accel_unregister(struct knod_accel *accel);
+void knod_dev_start(struct knod_dev *knodev);
+void knod_dev_stop(struct knod_dev *knodev);
+int knod_dev_xdp_install(struct knod_dev *knodev,
+				struct netdev_bpf *xdp);
+void knod_dev_get_stats64(struct knod_dev *knodev,
+				 struct rtnl_link_stats64 *stats);
+void knod_dev_lock(void);
+void knod_dev_unlock(void);
+struct sk_buff *knod_pass_build_skb(netmem_ref netmem, u16 off, u16 len,
+				    struct page_pool *pool, bool napi);
+int knod_d2h_copy(struct knod_dev *knodev, int napi_index,
+		  struct spsc_pass_bd *bds, int cnt);
+int knod_d2h_drain(struct knod_dev *knodev, int napi_index,
+		   struct napi_struct *napi, int budget);
+
+extern struct list_head knod_dev_list;
+extern struct list_head knod_netdev_list;
+extern struct list_head knod_accel_list;
+
+#define for_each_xdev(d)         \
+		list_for_each_entry(d, &knod_dev_list, list)
+#define for_each_xdev_safe(d)         \
+		list_for_each_entry_safe(d, n, &knod_dev_list, list)
+#define for_each_nodev(d)         \
+		list_for_each_entry(d, &knod_netdev_list, list)
+#define for_each_nodev_safe(d, n)         \
+		list_for_each_entry_safe(d, n, &knod_netdev_list, list)
+#define for_each_accel(d)         \
+		list_for_each_entry(d, &knod_accel_list, list)
+#define for_each_accel_safe(d, n)         \
+		list_for_each_entry_safe(d, n, &knod_accel_list, list)
+
+/* IPsec proxy functions */
+#if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
+int knod_ipsec_attach(struct knod_dev *knodev);
+void knod_ipsec_detach(struct knod_dev *knodev);
+#else
+#endif
+
+/* XDP PASS drain - called from NIC NAPI poll */
+int knod_dev_xdp_drain_pass(struct knod_dev *knodev,
+				   struct napi_struct *napi,
+				   int queue_idx, int budget);
+
+#endif
diff --git a/include/net/spsc_ring.h b/include/net/spsc_ring.h
new file mode 100644
index 000000000000..1eccadc927d6
--- /dev/null
+++ b/include/net/spsc_ring.h
@@ -0,0 +1,645 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * spsc_ring.h - Lock-free SPSC Ring Buffer with embedded element pool
+ *
+ * Single-Producer Single-Consumer ring buffer.  The ring owns a
+ * contiguous page-backed memory pool.  Each slot is permanently bound
+ * to a cacheline-aligned element inside that pool.
+ *
+ *   Producer calls spsc_produce() -> receives a pointer to a free
+ *   element, writes data into it, then calls spsc_produce_commit()
+ *   to publish.
+ *
+ *   Consumer calls spsc_acquire() / spsc_pop() -> receives a pointer
+ *   to a filled element.  After spsc_release() the slot becomes
+ *   available to the producer again - the element pointer is reused
+ *   automatically because it is fixed to the slot.
+ *
+ * Two consumer modes (do NOT mix on the same instance):
+ *
+ *   Mode 1 - Sliding window (2-step consumer):
+ *     spsc_produce / commit -> peek -> acquire -> release
+ *
+ *   Mode 2 - Simple queue:
+ *     spsc_push -> pop
+ *
+ * Return convention:
+ *   0           success
+ *   -ENOSPC     ring full   (producer side)
+ *   -ENOENT     ring empty  (consumer side)
+ *   -EINVAL     bad parameter
+ *   -ENOMEM     allocation failure
+ *
+ * Memory ordering:
+ *   Producer: write data -> smp_store_release(head)
+ *   Consumer: smp_load_acquire(head) -> read data
+ *   Consumer: done -> smp_store_release(tail)
+ *   Producer: smp_load_acquire(tail) -> write data
+ *
+ * Capacity is always a power of two.
+ */
+
+#ifndef _SPSC_RING_H
+#define _SPSC_RING_H
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/cache.h>
+#include <asm/barrier.h>
+
+struct spsc_ring {
+	void		**slots;	/* pointer-per-slot into pool */
+	unsigned int	mask;		/* capacity - 1 */
+
+	/* Producer side */
+	unsigned int	head;		/* next slot to publish */
+
+	/* Consumer side */
+	unsigned int	tail;		/* oldest unconsumed slot */
+	unsigned int	acquired;	/* sliding window read cursor
+					 *   tail <= acquired <= head
+					 */
+
+	/* Element pool */
+	struct page	*pool_page;	/* compound page backing elements */
+	unsigned int	pool_order;	/* page order */
+	unsigned int	elem_stride;	/* cacheline-aligned element size */
+} ____cacheline_aligned_in_smp;
+
+/* ================================================================== */
+/*  Init / Destroy                                                     */
+/* ================================================================== */
+
+/**
+ * __spsc_init - initialize ring with a pre-allocated element pool
+ * @r:         pointer to caller-allocated spsc_ring
+ * @elem_size: size of each element (rounded up to cacheline)
+ * @capacity:  number of elements (rounded up to power of 2)
+ * @pool:      pre-allocated pool memory (must be at least stride * capacity)
+ * @gfp:       allocation flags (for slots array only)
+ *
+ * The caller owns the pool memory; spsc_destroy will NOT free it.
+ * Returns 0 on success, negative errno on failure.
+ */
+static inline int __spsc_init(struct spsc_ring *r, unsigned int elem_size,
+			      unsigned int capacity, void *pool, gfp_t gfp)
+{
+	unsigned int stride = ALIGN(elem_size, SMP_CACHE_BYTES);
+	unsigned int i;
+	char *base = pool;
+
+	if (elem_size == 0 || capacity == 0 || !pool)
+		return -EINVAL;
+
+	capacity = roundup_pow_of_two(capacity);
+
+	r->slots = kcalloc(capacity, sizeof(void *), gfp);
+	if (!r->slots)
+		return -ENOMEM;
+
+	for (i = 0; i < capacity; i++)
+		r->slots[i] = base + (unsigned long)stride * i;
+
+	r->mask        = capacity - 1;
+	r->head        = 0;
+	r->tail        = 0;
+	r->acquired    = 0;
+	r->pool_page   = NULL;
+	r->pool_order  = 0;
+	r->elem_stride = stride;
+
+	return 0;
+}
+
+/**
+ * spsc_init - allocate ring and element pool
+ * @r:         pointer to caller-allocated spsc_ring
+ * @elem_size: size of each element (rounded up to cacheline)
+ * @capacity:  number of elements (rounded up to power of 2)
+ * @gfp:       allocation flags
+ *
+ * Returns 0 on success, negative errno on failure.
+ */
+static inline int spsc_init(struct spsc_ring *r, unsigned int elem_size,
+			    unsigned int capacity, gfp_t gfp)
+{
+	unsigned int stride = ALIGN(elem_size, SMP_CACHE_BYTES);
+	unsigned long pool_bytes;
+	unsigned int order;
+	struct page *page;
+
+	if (elem_size == 0 || capacity == 0)
+		return -EINVAL;
+
+	capacity = roundup_pow_of_two(capacity);
+	pool_bytes = (unsigned long)stride * capacity;
+	order = get_order(pool_bytes);
+
+	if (pool_bytes > (PAGE_SIZE << order))
+		return -EOVERFLOW;
+
+	/* Allocate element pool */
+	page = alloc_pages(gfp | __GFP_COMP | __GFP_ZERO, order);
+	if (!page)
+		return -ENOMEM;
+
+	if (__spsc_init(r, elem_size, capacity, page_address(page), gfp)) {
+		__free_pages(page, order);
+		return -ENOMEM;
+	}
+
+	r->pool_page  = page;
+	r->pool_order = order;
+
+	return 0;
+}
+
+/**
+ * spsc_destroy - free ring and element pool
+ */
+static inline void spsc_destroy(struct spsc_ring *r)
+{
+	if (r->pool_page) {
+		__free_pages(r->pool_page, r->pool_order);
+		r->pool_page = NULL;
+	}
+	kfree(r->slots);
+	r->slots = NULL;
+}
+
+/* ================================================================== */
+/*  Status helpers                                                     */
+/* ================================================================== */
+
+static inline unsigned int spsc_capacity(const struct spsc_ring *r)
+{
+	return r->mask + 1;
+}
+
+static inline unsigned int spsc_elem_size(const struct spsc_ring *r)
+{
+	return r->elem_stride;
+}
+
+/** spsc_count - total unconsumed entries (including acquired) */
+static inline unsigned int spsc_count(const struct spsc_ring *r)
+{
+	/* acquire head so a concurrent producer's slot writes are observed */
+	return smp_load_acquire(&((struct spsc_ring *)r)->head) - r->tail;
+}
+
+static inline bool spsc_empty(const struct spsc_ring *r)
+{
+	return spsc_count(r) == 0;
+}
+
+static inline bool spsc_full(const struct spsc_ring *r)
+{
+	return spsc_count(r) > r->mask;
+}
+
+/** spsc_pending - entries acquired but not yet released */
+static inline unsigned int spsc_pending(const struct spsc_ring *r)
+{
+	return r->acquired - r->tail;
+}
+
+/* ================================================================== */
+/*  Producer API  (single thread only, shared by both modes)           */
+/*                                                                     */
+/*  Two-phase produce:                                                 */
+/*    1) spsc_produce()        -> get pointer to free element           */
+/*    2) caller writes data                                            */
+/*    3) spsc_produce_commit() -> publish to consumer                   */
+/*                                                                     */
+/*  Or one-shot: spsc_push() for pre-filled elements.                  */
+/* ================================================================== */
+
+/**
+ * spsc_produce - reserve one slot and return its element pointer
+ * @r:   ring buffer
+ * @out: receives pointer to the element to write into
+ *
+ * The slot is NOT yet visible to the consumer.  Caller must write
+ * data into *out and then call spsc_produce_commit().
+ *
+ * Returns 0 on success, -ENOSPC if full.
+ */
+static inline int spsc_produce(struct spsc_ring *r, void **out)
+{
+	unsigned int head = r->head;
+	unsigned int tail;
+
+	/* acquire tail to observe the slots the consumer has released */
+	tail = smp_load_acquire(&r->tail);
+
+	if (head - tail > r->mask)
+		return -ENOSPC;
+
+	*out = r->slots[head & r->mask];
+
+	return 0;
+}
+
+/**
+ * spsc_produce_commit - publish the previously reserved slot
+ * @r: ring buffer
+ *
+ * Must be called exactly once after each successful spsc_produce().
+ */
+static inline void spsc_produce_commit(struct spsc_ring *r)
+{
+	/* wmb() (sfence on x86) is needed when the pool backing memory
+	 * is mapped Write-Combining (e.g. GPU GTT).  WC stores are not
+	 * ordered by x86 TSO, so smp_store_release (compiler barrier)
+	 * alone cannot guarantee the element writes are visible before
+	 * the head update reaches the consumer.
+	 */
+	wmb();
+	/* release: publish the reserved slot; pairs with the head acquire */
+	smp_store_release(&r->head, r->head + 1);
+}
+
+/**
+ * spsc_produce_n - reserve up to @n slots
+ * @r:   ring buffer
+ * @out: destination array for element pointers
+ * @n:   max slots to reserve
+ * @cnt: out - number actually reserved (may be NULL)
+ *
+ * Caller must write data into each out[i] and then call
+ * spsc_produce_commit_n(r, *cnt).
+ *
+ * Returns 0 on success, -ENOSPC if zero could be reserved.
+ */
+static inline int spsc_produce_n(struct spsc_ring *r, void **out,
+				 unsigned int n, unsigned int *cnt)
+{
+	/* acquire tail to observe the slots the consumer has released */
+	unsigned int tail = smp_load_acquire(&r->tail);
+	unsigned int head = r->head;
+	unsigned int free;
+	unsigned int i;
+
+	free = (r->mask + 1) - (head - tail);
+
+	n = min(n, free);
+	if (n == 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOSPC;
+	}
+
+	for (i = 0; i < n; i++)
+		out[i] = r->slots[(head + i) & r->mask];
+
+	if (cnt)
+		*cnt = n;
+	return 0;
+}
+
+/**
+ * spsc_produce_commit_n - publish @n previously reserved slots
+ * @r: ring buffer
+ * @n: number of slots to publish (must match produce_n count)
+ */
+static inline void spsc_produce_commit_n(struct spsc_ring *r, unsigned int n)
+{
+	/* drain WC element stores before the head update (see commit above) */
+	wmb();
+	/* release: publish the reserved slots; pairs with the head acquire */
+	smp_store_release(&r->head, r->head + n);
+}
+
+/* ================================================================== */
+/*  Mode 1: Sliding window consumer  (single thread only)              */
+/*                                                                     */
+/*    peek    -> read from acquired cursor, no cursor movement          */
+/*    acquire -> advance acquired cursor, return element pointers       */
+/*    release -> advance tail, slots become reusable by producer        */
+/*    rewind  -> reset acquired back to tail                            */
+/* ================================================================== */
+
+/**
+ * spsc_peek - read element pointers from acquired cursor (read-only)
+ * @r:   ring buffer
+ * @out: destination array for element pointers
+ * @max: max entries to peek
+ * @cnt: out - number of entries peeked (may be NULL)
+ *
+ * Does NOT move any cursor.
+ *
+ * Returns 0 on success, -ENOENT if nothing to peek.
+ */
+static inline int spsc_peek(struct spsc_ring *r, void **out, unsigned int max,
+			    unsigned int *cnt)
+{
+	/* acquire the producer's head; slots it published are now visible */
+	unsigned int head = smp_load_acquire(&r->head);
+	unsigned int acq = r->acquired;
+	unsigned int avail;
+	unsigned int i;
+
+	avail = head - acq;
+	avail = min(avail, max);
+
+	if (avail == 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOENT;
+	}
+
+	for (i = 0; i < avail; i++)
+		out[i] = r->slots[(acq + i) & r->mask];
+
+	if (cnt)
+		*cnt = avail;
+	return 0;
+}
+
+/**
+ * spsc_peek_at - peek starting at an offset past the acquired cursor
+ * @r:    ring buffer
+ * @skip: number of entries to skip past r->acquired
+ * @out:  destination array for element pointers
+ * @max:  max entries to peek
+ * @cnt:  out - number of entries peeked (may be NULL)
+ *
+ * Lets the consumer stage a second batch past entries that have been
+ * read by a previous peek but not yet committed via spsc_acquire.
+ * Does NOT move any cursor.  The caller is responsible for tracking
+ * the cumulative skip across staged batches; when those batches are
+ * eventually released to the producer via spsc_acquire, pass the same
+ * count so r->acquired catches up.
+ *
+ * Returns 0 on success, -ENOENT if nothing to peek at that offset.
+ */
+static inline int spsc_peek_at(struct spsc_ring *r, unsigned int skip,
+			       void **out, unsigned int max, unsigned int *cnt)
+{
+	/* acquire the producer's head; slots it published are now visible */
+	unsigned int head = smp_load_acquire(&r->head);
+	unsigned int pos = r->acquired + skip;
+	unsigned int avail;
+	unsigned int i;
+
+	if ((int)(head - pos) <= 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOENT;
+	}
+
+	avail = min(head - pos, max);
+	for (i = 0; i < avail; i++)
+		out[i] = r->slots[(pos + i) & r->mask];
+
+	if (cnt)
+		*cnt = avail;
+	return 0;
+}
+
+/**
+ * spsc_acquire - advance acquired cursor (step 1)
+ * @r:   ring buffer
+ * @out: destination array for element pointers, or NULL to skip
+ * @max: max entries to acquire
+ * @cnt: out - number acquired (may be NULL)
+ *
+ * Returns 0 on success, -ENOENT if nothing to acquire.
+ */
+static inline int spsc_acquire(struct spsc_ring *r, void **out,
+			       unsigned int max, unsigned int *cnt)
+{
+	/* acquire the producer's head; slots it published are now visible */
+	unsigned int head = smp_load_acquire(&r->head);
+	unsigned int acq = r->acquired;
+	unsigned int avail;
+	unsigned int i;
+
+	avail = head - acq;
+	avail = min(avail, max);
+
+	if (avail == 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOENT;
+	}
+
+	if (out) {
+		for (i = 0; i < avail; i++)
+			out[i] = r->slots[(acq + i) & r->mask];
+	}
+
+	/* Publish the window to the releasing consumer (a different CPU than
+	 * this acquirer): pair with the smp_load_acquire() in spsc_release()
+	 * so it cannot observe the advanced cursor before the element stores
+	 * (e.g. an accel verdict) those slots now point at.
+	 */
+	smp_store_release(&r->acquired, acq + avail);
+
+	if (cnt)
+		*cnt = avail;
+	return 0;
+}
+
+/**
+ * spsc_acquire_all - acquire all available entries
+ */
+static inline int spsc_acquire_all(struct spsc_ring *r, void **out,
+				   unsigned int *cnt)
+{
+	return spsc_acquire(r, out, UINT_MAX, cnt);
+}
+
+/**
+ * spsc_release - get element pointers of acquired entries (release step 1)
+ * @r:   ring buffer
+ * @out: destination array for element pointers, or NULL to skip
+ * @n:   number of entries to release (<= pending)
+ * @cnt: out - number of entries prepared for release (may be NULL)
+ *
+ * Returns element pointers for the oldest @n acquired entries but
+ * does NOT advance tail - the producer still cannot reuse these slots.
+ * Caller processes the elements, then calls spsc_release_commit() to
+ * actually free them.
+ *
+ * Returns 0 on success, -ENOENT if nothing to release.
+ */
+static inline int spsc_release(struct spsc_ring *r, void **out, unsigned int n,
+			       unsigned int *cnt)
+{
+	unsigned int tail = r->tail;
+	unsigned int pending;
+	unsigned int i;
+
+	/* Pairs with smp_store_release(&r->acquired) in spsc_acquire(): once
+	 * we see the advanced cursor we are guaranteed to see the element
+	 * stores (e.g. the accel verdict) for the slots it exposes.
+	 */
+	pending = smp_load_acquire(&r->acquired) - tail;
+
+	n = min(n, pending);
+	if (n == 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOENT;
+	}
+
+	if (out) {
+		for (i = 0; i < n; i++)
+			out[i] = r->slots[(tail + i) & r->mask];
+	}
+
+	if (cnt)
+		*cnt = n;
+	return 0;
+}
+
+/**
+ * spsc_release_commit - advance tail, free slots for producer (release step 2)
+ * @r: ring buffer
+ * @n: number of entries to commit (must match prior spsc_release count)
+ *
+ * After this call the producer may reuse these slots.
+ */
+static inline void spsc_release_commit(struct spsc_ring *r, unsigned int n)
+{
+	/* release: hand the consumed slots back to the producer */
+	smp_store_release(&r->tail, r->tail + n);
+}
+
+/**
+ * spsc_release_all - get all acquired entries' pointers (release step 1)
+ * @r:   ring buffer
+ * @out: destination array for element pointers, or NULL to skip
+ * @cnt: out - number of entries prepared for release (may be NULL)
+ *
+ * Convenience for spsc_release(r, out, pending, cnt).
+ * Caller must still call spsc_release_commit(r, *cnt) afterward.
+ *
+ * Returns 0 on success, -ENOENT if nothing pending.
+ */
+static inline int spsc_release_all(struct spsc_ring *r, void **out,
+				   unsigned int *cnt)
+{
+	return spsc_release(r, out, r->acquired - r->tail, cnt);
+}
+
+/**
+ * spsc_rewind - undo acquires, reset acquired cursor to tail
+ */
+static inline void spsc_rewind(struct spsc_ring *r)
+{
+	r->acquired = r->tail;
+}
+
+/* ================================================================== */
+/*  Mode 2: Simple push / pop  (single thread per side)                */
+/*                                                                     */
+/*  One-shot convenience wrappers.                                     */
+/*  Do NOT mix with Mode 1 acquire/release on the same instance.       */
+/* ================================================================== */
+
+/**
+ * spsc_push - reserve, let caller fill, and publish in one shot
+ * @r:   ring buffer
+ * @out: receives pointer to the element to write into
+ *
+ * Unlike produce/commit, the slot is published immediately.
+ * Caller must fill *out BEFORE this function returns if another
+ * thread could consume it - but since this is SPSC with push/pop
+ * the typical pattern is:
+ *
+ *   spsc_push(&r, &elem);
+ *   fill(elem);            // safe: consumer hasn't seen it yet?
+ *
+ * NO - push publishes immediately.  Use produce/commit if you need
+ * to fill before publishing.  push is an alias for produce+commit.
+ *
+ * Returns 0 on success, -ENOSPC if full.
+ */
+static inline int spsc_push(struct spsc_ring *r, void **out)
+{
+	int ret;
+
+	ret = spsc_produce(r, out);
+	if (ret)
+		return ret;
+
+	spsc_produce_commit(r);
+	return 0;
+}
+
+/**
+ * spsc_pop - dequeue one element
+ * @r:   ring buffer
+ * @out: receives pointer to the consumed element
+ *
+ * The element pointer remains valid until the next spsc_push() or
+ * spsc_produce() reuses that slot.
+ *
+ * Returns 0 on success, -ENOENT if empty.
+ */
+static inline int spsc_pop(struct spsc_ring *r, void **out)
+{
+	/* acquire the producer's head; slots it published are now visible */
+	unsigned int head = smp_load_acquire(&r->head);
+	unsigned int tail = r->tail;
+
+	if (tail == head)
+		return -ENOENT;
+
+	*out = r->slots[tail & r->mask];
+
+	r->acquired = tail + 1;
+	/* release: hand the consumed slot back to the producer */
+	smp_store_release(&r->tail, tail + 1);
+
+	return 0;
+}
+
+/**
+ * spsc_pop_n - dequeue up to @n elements
+ * @r:   ring buffer
+ * @out: destination array for element pointers
+ * @n:   max entries to dequeue
+ * @cnt: out - number dequeued (may be NULL)
+ *
+ * Returns 0 on success, -ENOENT if empty.
+ */
+static inline int spsc_pop_n(struct spsc_ring *r, void **out, unsigned int n,
+			     unsigned int *cnt)
+{
+	/* acquire the producer's head; slots it published are now visible */
+	unsigned int head = smp_load_acquire(&r->head);
+	unsigned int tail = r->tail;
+	unsigned int avail;
+	unsigned int i;
+
+	avail = head - tail;
+	n = min(n, avail);
+
+	if (n == 0) {
+		if (cnt)
+			*cnt = 0;
+		return -ENOENT;
+	}
+
+	for (i = 0; i < n; i++)
+		out[i] = r->slots[(tail + i) & r->mask];
+
+	r->acquired = tail + n;
+	/* release: hand the consumed slots back to the producer */
+	smp_store_release(&r->tail, tail + n);
+
+	if (cnt)
+		*cnt = n;
+	return 0;
+}
+
+#endif /* _SPSC_RING_H */
diff --git a/include/uapi/linux/knod.h b/include/uapi/linux/knod.h
new file mode 100644
index 000000000000..57602685c14e
--- /dev/null
+++ b/include/uapi/linux/knod.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/knod.yaml */
+/* YNL-GEN uapi header */
+/* To regenerate run: tools/net/ynl/ynl-regen.sh */
+
+#ifndef _UAPI_LINUX_KNOD_H
+#define _UAPI_LINUX_KNOD_H
+
+#define KNOD_FAMILY_NAME	"knod"
+#define KNOD_FAMILY_VERSION	1
+
+enum knod_feature {
+	KNOD_FEATURE_NONE,
+	KNOD_FEATURE_BPF,
+	KNOD_FEATURE_IPSEC,
+};
+
+enum knod_accel_type {
+	KNOD_ACCEL_TYPE_GPU,
+	KNOD_ACCEL_TYPE_DPU,
+};
+
+enum {
+	KNOD_A_ACCEL_ID = 1,
+	KNOD_A_ACCEL_NAME,
+	KNOD_A_ACCEL_TYPE,
+	KNOD_A_ACCEL_FEATURE_CAP,
+	KNOD_A_ACCEL_FEATURE_ENA,
+
+	__KNOD_A_ACCEL_MAX,
+	KNOD_A_ACCEL_MAX = (__KNOD_A_ACCEL_MAX - 1)
+};
+
+enum {
+	KNOD_A_NIC_IFINDEX = 1,
+	KNOD_A_NIC_NAME,
+
+	__KNOD_A_NIC_MAX,
+	KNOD_A_NIC_MAX = (__KNOD_A_NIC_MAX - 1)
+};
+
+enum {
+	KNOD_A_DEV_NIC_IFINDEX = 1,
+	KNOD_A_DEV_ACCEL_ID,
+
+	__KNOD_A_DEV_MAX,
+	KNOD_A_DEV_MAX = (__KNOD_A_DEV_MAX - 1)
+};
+
+enum {
+	KNOD_CMD_ACCEL_GET = 1,
+	KNOD_CMD_ACCEL_SET,
+	KNOD_CMD_NIC_GET,
+	KNOD_CMD_ATTACH,
+	KNOD_CMD_DETACH,
+	KNOD_CMD_DEV_GET,
+	KNOD_CMD_DEV_ADD_NTF,
+	KNOD_CMD_DEV_DEL_NTF,
+
+	__KNOD_CMD_MAX,
+	KNOD_CMD_MAX = (__KNOD_CMD_MAX - 1)
+};
+
+#define KNOD_MCGRP_MGMT	"mgmt"
+
+#endif /* _UAPI_LINUX_KNOD_H */
-- 
2.43.0

