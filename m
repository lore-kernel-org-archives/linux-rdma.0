Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69E3B3C06
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484191; cv=none; b=HLSshWvbedoYQkNd3zIIebhIozwFWKKGgIkm1Ogd+rSZFYWSlJX7EPBr5W5jyzY3h58pvBXPNhWlkNPJw0LBOPE7jB54MmpB/LJvagzGfT/r4ijZ4mL2Q+E9yn+oITzoZeQI6RufyiH++PAV0C1ehU1h8VK+8W56tu7IC9b59YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484191; c=relaxed/simple;
	bh=kw8RXLQJ5L/pi5bv+kifeE7bwsxh0qwnPTg/JisPKls=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlSLcBp4lGRxw4jIEKLRccG6h41EIeHJndbhZuV9qVV7cAaJYuhrEnMUzM0I2jZAbwjige7l2gjumzuSlnDNcGHlemFJW5vBlg5lXVyaziVnBuTzD1Y3PM9x6jih9nrtCzqZXS3ykMAraZLLl9zyV8YJHRczFxsfXbyRwLe1R1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtG4dukU; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtG4dukU"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf27856f9cso36569045ad.2
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484141; x=1785088941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zg6prSrF11vlTrFRmegzqdrSMPgY3uw3Tb6xFm9uGhI=;
        b=QtG4dukUIT/ZO5h1AX8N4Y+Eaiahn6jkNfyn36vu5gQAmt8eng4eVFrYSK8O+SbEPu
         uGCE83T4hLunv4Ufi1NJxoN4l+esfdYDF+bC8yefHhxone/5C3CUT4/604CUfaPsdSwx
         CwTDj2wrA0hKLbxYg3Jw9j/Go/t+hcc6eFRYUtRVoJwZVTuUFvyxnD2YOjZkKwFQFARe
         4FKh4KXQOW642G08AHE/YJC/EGo0tHgzwxycoLU9ymjNwU+W6Lai+cfxDxM/OyRY51L9
         6ibEp6aYrV50yS+Wv8FVLoowv61MQ/A7gVp/Hwg505v1vRFhJG4oAAreItCWJrpLmDv0
         OzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484141; x=1785088941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zg6prSrF11vlTrFRmegzqdrSMPgY3uw3Tb6xFm9uGhI=;
        b=sb61bHqQ4fKanl6W0TqWHhR1PA0GzYBg0D2csuvsRBbX03kFYPnVFaaAPAuGgaTawg
         xm5MV4QPeJwtSrq+G8MGfamS6lyBuD3H4WJXFK6r5yWz3PKgOpcEjuzYQLU+GyRkAraw
         jRyIGgRlTJpz7FzKUoi55vKsjxYNRao+psqrowSCOHNnAgxqgonxhFURhVC7XeVerNLy
         zcGMjN3CFzrWUudYzOKjCjZN8e3qX9iCYIhuCQLO4V9yr+jw6pvdQYDXyX/MQzkSTW8b
         oGOvnvwJUevUoIV6uy0QBeesqnubYn43ZCkB1681hZuiHQEw9y3D8UFvim9o+pKQp6wi
         eRng==
X-Forwarded-Encrypted: i=1; AHgh+RrKJKgQTAF6c2YGGquXYvt0glUVcv9HcnWplyPyBNKDsewmhkNE5eCbAlDh7L3ssVZJkMsIbdgUrqrL@vger.kernel.org
X-Gm-Message-State: AOJu0YwZq6cLGiRzwhQVQIirzjxIH5NAS/9ATjT/5dpGKVzv575/6p1/
	CmVfsEwjr2S1pbXvH9xtiajyx8m7qYN33CnrDk/ssUx7itc8vBBfg8uH
X-Gm-Gg: AfdE7ckmAaAtZ7cg7zM9NdIzACRbrBVVQwrC5nFonputcObJSagJ25+zwvEgsLtfFw9
	BcIUUFR4W4DZ6t8nZKNy3ITeBw6uWjnAHXISx+e/u2oLaHIK6ww+nRsMTU8x5nUHI6FEXBMeV1C
	tftAzF01AVoXhMq3gxcPDDValwY//Lhi7dqcmR1Jb63yX3a7aAICcDwhSiTOsqcbOFu/6x8kdn7
	v6l3ybuiSDxuUKcP1uwRt8jsI4Nrw31iwHzn53JoIm30FyRSQjoMQXp7njm6lNGR6X9vgohRaVG
	yvwnifGJSgTM6MdCaR882d7gj1y7Qwu4zEamresucbXVaCsYKcjpsEG7liersYVZxXCEoc8uOeY
	ICkcuq71OVIkjI//8Fr3CpO/Vg9C5CIXusEfdXpOj/XsvPCezcCaHH/Z71hnZOA8t0Q==
X-Received: by 2002:a17:903:2986:b0:2ce:b7b7:30e3 with SMTP id d9443c01a7336-2cf348575cbmr130100785ad.17.1784484138203;
        Sun, 19 Jul 2026 11:02:18 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.11.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:02:16 -0700 (PDT)
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
Subject: [RFC PATCH net-next 13/13] drm/amdkfd: add IPsec full-packet offload
Date: Sun, 19 Jul 2026 17:58:57 +0000
Message-ID: <20260719175857.4071636-14-ap420073@gmail.com>
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

Add a second knod feature, alongside BPF, to show the accel ops are not
tied to a single use case: GPU-offloaded IPsec ESP.  xfrm SAs installed
with XFRM_DEV_OFFLOAD_PACKET are handed to the GPU, which parses ESP,
looks up the SA, checks anti-replay, does AES-GCM decrypt and writes the
verdict back.  Built as a separate module (knod_ipsec).

This is a functional proof of concept: it demonstrates that a
full-packet crypto feature can run on top of the knod accelerator, not
a hardened, production-ready implementation.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit 56ea4f90b43677e6944f1bc3ca4cf02e736ec340)
---
 drivers/gpu/drm/amd/amdkfd/Kconfig            |    9 +
 drivers/gpu/drm/amd/amdkfd/Makefile           |    3 +
 .../gpu/drm/amd/amdkfd/knod/aesgcm_shader.h   |  984 ++++
 .../drm/amd/amdkfd/knod/ipsec_fused_gfx10.h   | 1796 +++++++
 .../drm/amd/amdkfd/knod/ipsec_fused_gfx9.h    | 1349 ++++++
 drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.c  | 4273 +++++++++++++++++
 drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.h  |  596 +++
 .../testing/selftests/drivers/net/knod/config |    1 +
 8 files changed, 9011 insertions(+)
 create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/aesgcm_shader.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx10.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx9.h
 create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.c
 create mode 100644 drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.h

diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
index 708aa5fc051b..67efae53e395 100644
--- a/drivers/gpu/drm/amd/amdkfd/Kconfig
+++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
@@ -60,3 +60,12 @@ config HSA_AMD_KNOD_BPF
 	  the verdict path (PASS/DROP/TX) off the host CPU.
 
 	  If unsure, say N.
+
+config HSA_AMD_KNOD_IPSEC
+	tristate "KNOD IPsec (xfrm) full-packet offload"
+	depends on HSA_AMD_KNOD && XFRM_OFFLOAD && INET_ESP
+	help
+	  GPU-accelerated IPsec ESP full-packet offload via KNOD.
+	  Accepts xfrm SAs configured with XFRM_DEV_OFFLOAD_PACKET and
+	  performs ESP parse, SA lookup, anti-replay, AES-GCM decrypt and
+	  verdict writeback on the GPU.
diff --git a/drivers/gpu/drm/amd/amdkfd/Makefile b/drivers/gpu/drm/amd/amdkfd/Makefile
index 4df3850e1466..c5d801ddabb7 100644
--- a/drivers/gpu/drm/amd/amdkfd/Makefile
+++ b/drivers/gpu/drm/amd/amdkfd/Makefile
@@ -77,3 +77,6 @@ AMDKFD_FILES += $(AMDKFD_PATH)/kfd_knod.o
 endif
 
 obj-$(CONFIG_HSA_AMD_KNOD_BPF) += $(AMDKFD_PATH)/knod/knod_bpf.o
+
+
+obj-$(CONFIG_HSA_AMD_KNOD_IPSEC) += $(AMDKFD_PATH)/knod/knod_ipsec.o
diff --git a/drivers/gpu/drm/amd/amdkfd/knod/aesgcm_shader.h b/drivers/gpu/drm/amd/amdkfd/knod/aesgcm_shader.h
new file mode 100644
index 000000000000..ae5276edb9fd
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/knod/aesgcm_shader.h
@@ -0,0 +1,984 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+/*
+ * AES-GCM GPU shader emit helpers for GFX9 (Vega) / GFX10 (RDNA)
+ *
+ * Per-step emitters (AES rounds, encrypt block, GHASH gfmul, T-table
+ * lookup) shared by the IPsec fused shaders.
+ */
+
+#ifndef AESGCM_SHADER_H_
+#define AESGCM_SHADER_H_
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include "knod_amdgpu_insn.h"
+
+/* ======================================================================
+ * Emit pattern macros (file-local)
+ *
+ * _E(fn, ...)   - emit instruction, advance n by instruction size
+ * _BR(fn, ...)  - emit branch, save position, advance n
+ * ======================================================================
+ */
+
+#define _E(fn, ...) (n += fn(__VA_ARGS__) / 4)
+#define _BR(fn, ...) ({ int _p = n; n += fn(__VA_ARGS__) / 4; _p; })
+
+/* ======================================================================
+ * AES T-table Round Helper
+ *
+ * Emits one AES round using T-table lookups from LDS.
+ *
+ * T-table layout in LDS (4KB total):
+ *   T0: offset 0..1023     (256 x 4 bytes)
+ *   T1: offset 1024..2047
+ *   T2: offset 2048..3071
+ *   T3: offset 3072..4095
+ *
+ * AES round function:
+ *   new[0] = T0[s0.b0] ^ T1[s1.b1] ^ T2[s2.b2] ^ T3[s3.b3] ^ rk[0]
+ *   new[1] = T0[s1.b0] ^ T1[s2.b1] ^ T2[s3.b2] ^ T3[s0.b3] ^ rk[1]
+ *   new[2] = T0[s2.b0] ^ T1[s3.b1] ^ T2[s0.b2] ^ T3[s1.b3] ^ rk[2]
+ *   new[3] = T0[s3.b0] ^ T1[s0.b1] ^ T2[s1.b2] ^ T3[s2.b3] ^ rk[3]
+ * ======================================================================
+ */
+
+/*
+ * Emit code to extract a byte from a VGPR and compute LDS T-table address.
+ *
+ * @buf:        instruction buffer
+ * @n:          current position
+ * @vdst_addr:  output VGPR for LDS address
+ * @vdst_val:   output VGPR for loaded T-table value (ds_read destination)
+ * @v_state:    input VGPR (state word)
+ * @byte_pos:   byte position (0, 1, 2, 3)
+ * @table_base: LDS base offset for this table (0, 1024, 2048, 3072)
+ * @s_mask:     SGPR holding 0xFF
+ * @v_tmp:      temp VGPR for byte extraction
+ */
+static int emit_ttable_lookup_gfx9(u32 *buf, int n,
+				   int v_addr, int v_val,
+				   int v_state, int byte_pos,
+				   int table_base, int s_mask, int v_tmp)
+{
+	/*
+	 * Extract byte: result = (state >> (byte_pos*8)) & 0xFF
+	 * Then: LDS addr = result * 4 + table_base
+	 */
+	if (byte_pos == 0) {
+		/* byte 0: just mask, no shift needed */
+		/* v_and_b32: src0=SGPR(mask), vsrc1=VGPR(state) */
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(v_tmp), P_S(s_mask),
+		   P_V(v_state));
+	} else if (byte_pos == 3) {
+		/* byte 3: shift right 24, no mask needed */
+		/* v_lshrrev: vdst = vsrc1 >> src0 = v_state >> 24 */
+		_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(v_tmp), P_I(24),
+		   P_V(v_state));
+	} else {
+		/* byte 1 or 2: shift then mask */
+		_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(v_tmp),
+		   P_I(byte_pos * 8), P_V(v_state));
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(v_tmp), P_S(s_mask),
+		   P_V(v_tmp));
+	}
+
+	/* LDS addr = byte * 4 + table_base */
+	/* v_lshlrev: vdst = vsrc1 << src0 = v_tmp << 2 */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(v_addr), P_I(2),
+	   P_V(v_tmp));
+	if (table_base > 0)
+		_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(v_addr),
+		   P_L(table_base), P_V(v_addr));
+
+	/* Issue LDS read (don't wait yet -- caller batches reads) */
+	_E(emit_gfx9_ds_read_b32, I9(buf, n), v_val, v_addr, 0);
+
+	return n;
+}
+
+/*
+ * Emit one full AES round (rounds 1 to Nr-1).
+ *
+ * @buf, @n:    instruction buffer and position
+ * @s0-s3:      input state VGPRs
+ * @d0-d3:      output state VGPRs (new state)
+ * @rk:         SGPR base for round key (4 consecutive SGPRs)
+ * @s_mask:     SGPR holding 0xFF
+ * @v_tmp:      temp VGPR for byte extraction
+ * @v_addr:     temp VGPR for LDS address
+ * @vt0-vt3:    temp VGPRs for 4 T-table values per column
+ */
+static int emit_aes_round_gfx9(u32 *buf, int n,
+			       int s0, int s1, int s2, int s3,
+			       int d0, int d1, int d2, int d3,
+			       int rk, int s_mask, int v_tmp, int v_addr,
+			       int vt0, int vt1, int vt2, int vt3)
+{
+	/*
+	 * Issue all 16 LDS reads (4 per column), then wait once.
+	 * This maximizes LDS throughput by overlapping reads.
+	 *
+	 * Column 0: T0[s0.b0] ^ T1[s1.b1] ^ T2[s2.b2] ^ T3[s3.b3]
+	 * Column 1: T0[s1.b0] ^ T1[s2.b1] ^ T2[s3.b2] ^ T3[s0.b3]
+	 * Column 2: T0[s2.b0] ^ T1[s3.b1] ^ T2[s0.b2] ^ T3[s1.b3]
+	 * Column 3: T0[s3.b0] ^ T1[s0.b1] ^ T2[s1.b2] ^ T3[s2.b3]
+	 *
+	 * We reuse d0-d3 and vt0-vt3 as temporaries for the 16 results.
+	 * Process column by column to minimize register pressure.
+	 */
+
+	/* ---- Column 0 ---- */
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt0, s0, 0, 0, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt1, s1, 1, 1024, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt2, s2, 2, 2048, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt3, s3, 3, 3072, s_mask,
+				    v_tmp);
+	_E(emit_gfx9_s_waitcnt, I9(buf, n), 0xF, 0);  /* lgkmcnt=0 */
+
+	/* XOR: d0 = vt0 ^ vt1 ^ vt2 ^ vt3 ^ rk */
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d0), P_V(vt0), P_V(vt1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d0), P_V(d0), P_V(vt2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d0), P_V(d0), P_V(vt3));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d0), P_S(rk), P_V(d0));
+
+	/* ---- Column 1 ---- */
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt0, s1, 0, 0, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt1, s2, 1, 1024, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt2, s3, 2, 2048, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt3, s0, 3, 3072, s_mask,
+				    v_tmp);
+	_E(emit_gfx9_s_waitcnt, I9(buf, n), 0xF, 0);
+
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d1), P_V(vt0), P_V(vt1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d1), P_V(d1), P_V(vt2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d1), P_V(d1), P_V(vt3));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d1), P_S(rk + 1), P_V(d1));
+
+	/* ---- Column 2 ---- */
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt0, s2, 0, 0, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt1, s3, 1, 1024, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt2, s0, 2, 2048, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt3, s1, 3, 3072, s_mask,
+				    v_tmp);
+	_E(emit_gfx9_s_waitcnt, I9(buf, n), 0xF, 0);
+
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d2), P_V(vt0), P_V(vt1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d2), P_V(d2), P_V(vt2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d2), P_V(d2), P_V(vt3));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d2), P_S(rk + 2), P_V(d2));
+
+	/* ---- Column 3 ---- */
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt0, s3, 0, 0, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt1, s0, 1, 1024, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt2, s1, 2, 2048, s_mask,
+				    v_tmp);
+	n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt3, s2, 3, 3072, s_mask,
+				    v_tmp);
+	_E(emit_gfx9_s_waitcnt, I9(buf, n), 0xF, 0);
+
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d3), P_V(vt0), P_V(vt1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d3), P_V(d3), P_V(vt2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d3), P_V(d3), P_V(vt3));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(d3), P_S(rk + 3), P_V(d3));
+
+	return n;
+}
+
+/*
+ * Emit the last AES round (SubBytes + ShiftRows + AddRoundKey, no MixColumns).
+ *
+ * S-box is extracted from T0: S(x) = (T0[x] >> 8) & 0xFF
+ * (In standard AES T-table encoding: T0[x] = {2*S(x), S(x), S(x), 3*S(x)})
+ *
+ * Last round output:
+ *   d[c] = S(s[c].b0) | (S(s[(c+1)%4].b1)<<8) |
+ *          (S(s[(c+2)%4].b2)<<16) | (S(s[(c+3)%4].b3)<<24) ^ rk[c]
+ */
+static int emit_aes_last_round_gfx9(u32 *buf, int n,
+				    int s0, int s1, int s2, int s3,
+				    int d0, int d1, int d2, int d3,
+				    int rk, int s_mask, int v_tmp, int v_addr,
+				    int vt0, int vt1, int vt2, int vt3)
+{
+	/*
+	 * For each column, look up T0 for all 4 bytes,
+	 * extract S(x) = (T0[x] >> 8) & 0xFF, then assemble.
+	 */
+	int cols[4][4] = {
+		{s0, s1, s2, s3},  /* column 0 */
+		{s1, s2, s3, s0},  /* column 1 */
+		{s2, s3, s0, s1},  /* column 2 */
+		{s3, s0, s1, s2},  /* column 3 */
+	};
+	int dsts[4] = {d0, d1, d2, d3};
+	int col;
+
+	for (col = 0; col < 4; col++) {
+		/* Look up T0 for all 4 bytes of this column */
+		n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt0, cols[col][0],
+					    0, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt1, cols[col][1],
+					    1, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt2, cols[col][2],
+					    2, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx9(buf, n, v_addr, vt3, cols[col][3],
+					    3, 0, s_mask, v_tmp);
+		_E(emit_gfx9_s_waitcnt, I9(buf, n), 0xF, 0);
+
+		/*
+		 * Extract S(x) from T0[x]:
+		 *   S(x) = (T0[x] >> 8) & 0xFF
+		 */
+		/* byte 0: S(x) in bits [15:8] of T0, place in bits [7:0] */
+		_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(vt0), P_I(8),
+		   P_V(vt0));
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(vt0), P_S(s_mask),
+		   P_V(vt0));
+
+		/* byte 1: S(x) in bits [15:8], place in bits [15:8] */
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(vt1), P_L(0xFF00),
+		   P_V(vt1));
+
+		/* byte 2: S(x) in bits [15:8], place in bits [23:16] */
+		_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(vt2), P_I(8),
+		   P_V(vt2));
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(vt2), P_L(0xFF0000),
+		   P_V(vt2));
+
+		/* byte 3: S(x) in bits [15:8], place in bits [31:24] */
+		_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(vt3), P_I(16),
+		   P_V(vt3));
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(vt3),
+		   P_L(0xFF000000), P_V(vt3));
+
+		/* Assemble: d = b0 | b1 | b2 | b3 ^ rk */
+		_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(dsts[col]), P_V(vt0),
+		   P_V(vt1));
+		_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(dsts[col]),
+		   P_V(dsts[col]), P_V(vt2));
+		_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(dsts[col]),
+		   P_V(dsts[col]), P_V(vt3));
+		_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(dsts[col]),
+		   P_S(rk + col), P_V(dsts[col]));
+	}
+
+	return n;
+}
+
+/* ======================================================================
+ * GFX9 AES-GCM emit helpers
+ * ======================================================================
+ */
+
+/*
+ * Register allocation:
+ *
+ * SGPRs:
+ *   s[0:3]    system: private_segment_buffer
+ *   s[4:5]    system: dispatch_ptr
+ *   s[6:7]    system: queue_ptr
+ *   s[8:9]    system: kernarg_segment_ptr
+ *   s[10:11]  system: dispatch_id
+ *   s[12:13]  system: flat_scratch_init
+ *   s14       system: private_segment_size
+ *   s15       system: workgroup_id_x
+ *   s16       system: workgroup_id_y (batch lane)
+ *   s17       system: workgroup_id_z
+ *
+ *   s[18:19]  subparam base address (computed)
+ *   s[20:21]  input buffer address (from subparam)
+ *   s[22:23]  output buffer address (from subparam)
+ *   s[24:25]  round keys address (from subparam)
+ *   s26       nbytes (from subparam)
+ *   s27       temp / block count
+ *   s[28:31]  current round key (loaded per-round)
+ *   s32       0xFF constant
+ *   s[34:35]  T-table VRAM address pair (temp)
+ *   s[36:37]  IV word 0-1 (from subparam.iv)
+ *   s38       IV word 2 (from subparam.iv, 4 bytes)
+ *   s[48:49]  saved EXEC
+ *
+ * VGPRs:
+ *   v0        workitem_id_x (tid)
+ *   v[1:4]    AES state A
+ *   v[5:8]    AES state B / T-table results
+ *   v9        byte extraction temp
+ *   v10       LDS address temp
+ *   v11       block_id (global)
+ *   v[12:13]  64-bit global memory address
+ *   v[14:17]  data words (plaintext/ciphertext)
+ *   v18       temp
+ */
+
+#define SR_KEYS		24	/* s[24:25] */
+#define SR_NBLOCKS	27
+#define SR_RK		28	/* s[28:31] round key */
+#define SR_MASK		32	/* s32 = 0xFF */
+#define SR_LOOP_CTR	33	/* s33 = loop counter (Phase 4) */
+#define SR_T_ADDR	34	/* s[34:35] temp for T-table load */
+#define SR_IV0		36	/* s36 = IV word 0 */
+#define SR_IV1		37	/* s37 = IV word 1 */
+#define SR_IV2		38	/* s38 = IV word 2 */
+#define SR_NR_ROUNDS	39	/* s39 = nr_rounds from subparam */
+#define SR_EXEC_SAVE	48	/* s[48:49] */
+
+#define VR_TID		0	/* workitem_id_x */
+#define VR_S0		1	/* state A: v[1:4] */
+#define VR_S1		2
+#define VR_S2		3
+#define VR_S3		4
+#define VR_D0		5	/* state B / T-table: v[5:8] */
+#define VR_D1		6
+#define VR_D2		7
+#define VR_D3		8
+#define VR_TMP		9	/* byte extraction temp */
+#define VR_ADDR		10	/* LDS address temp */
+#define VR_BLK		11	/* block_id */
+#define VR_GA_LO	12	/* 64-bit global addr lo */
+#define VR_GA_HI	13	/* 64-bit global addr hi */
+#define VR_DATA0	14	/* plaintext/ciphertext v[14:17] */
+#define VR_DATA1	15
+#define VR_DATA2	16
+#define VR_DATA3	17
+#define VR_TMP2		18
+/* Phase 5.5: saved AES(K, J0) result for ICV finalization */
+#define VR_J0_0		19
+#define VR_J0_1		20
+#define VR_J0_2		21
+#define VR_J0_3		22
+
+/* Phase 7 GHASH: additional SGPR for exec save during sub-masking */
+#define SR_GHASH_EXEC	40	/* s[40:41] */
+#define SR_BSWAP	44	/* s44 = 0x00010203 (bswap32 selector for v_perm_b32) */
+#define SR_RK2		56	/* s[56:59] alternate round key for double-buffered AES */
+
+/*
+ * sizeof(knod_aesgcm_subparam) = 80
+ * Offsets within subparam:
+ *   0:  u64 in
+ *   8:  u64 out
+ *   16: u64 keys
+ *   24: u64 h_table
+ *   32: u64 aad
+ *   40: u64 tag
+ *   48: u32 nbytes
+ *   52: u32 aad_len
+ *   56: u8  iv[12]  (3 words at offsets 56, 60, 64 -- last only 4 bytes)
+ *   68: u32 op
+ *   72: u32 nr_rounds  (10 or 14)
+ *   76: u32 _pad
+ *
+ * T-table addresses in knod_aesgcm_param (after sub[128]):
+ *   128 * 80 = 10240: u64 t0
+ *   10248: u64 t1
+ *   10256: u64 t2
+ *   10264: u64 t3
+ */
+#define SUBPARAM_SIZE		80
+
+#define OFF_T0			(AESGCM_MAX_DIM_Y * SUBPARAM_SIZE)
+
+/* ======================================================================
+ * GFX9 AES Block Encrypt Helper
+ *
+ * Encrypts the 128-bit block in v[VR_S0:VR_S3] using T-tables in LDS.
+ * Expects SR_KEYS = round keys GPU addr (will be advanced).
+ * Expects SR_NR_ROUNDS = number of AES rounds.
+ * Result in v[VR_S0:VR_S3].
+ * Clobbers: v[VR_D0:VR_D3], v[VR_DATA0:VR_DATA3], v[VR_TMP], v[VR_ADDR],
+ *           s[SR_RK:SR_RK+3], s[SR_NBLOCKS], s[SR_LOOP_CTR], s[SR_KEYS+1]
+ * ======================================================================
+ */
+static int emit_aes_encrypt_block_gfx9(u32 *buf, int n)
+{
+	int br_loop, loop_top;
+
+	/* Round 0: XOR with first round key */
+	_E(emit_gfx9_s_load_dwordx4, I9(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S0), P_S(SR_RK),
+	   P_V(VR_S0));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S1), P_S(SR_RK + 1),
+	   P_V(VR_S1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S2), P_S(SR_RK + 2),
+	   P_V(VR_S2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S3), P_S(SR_RK + 3),
+	   P_V(VR_S3));
+
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx9_s_addc_u32, I9(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+
+	/* pair_count = nr_rounds / 2 - 1 */
+	_E(emit_gfx9_s_lshr_b32, I9(buf, n), P_S(SR_NBLOCKS), P_S(SR_NR_ROUNDS),
+	   P_I(1));
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_NBLOCKS), P_L(0xFFFFFFFFu),
+	   P_S(SR_NBLOCKS));
+
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_LOOP_CTR), P_I(0));
+
+	/* Prefetch round 1 key - overlaps with loop-entry overhead */
+	_E(emit_gfx9_s_load_dwordx4, I9(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+
+	loop_top = n;
+
+	/* Odd round: S -> D  (SR_RK was prefetched) */
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx9_s_addc_u32, I9(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx9_s_load_dwordx4, I9(buf, n), P_S(SR_RK2), P_S(SR_KEYS), 0);
+	n = emit_aes_round_gfx9(buf, n, VR_S0, VR_S1, VR_S2, VR_S3,
+				VR_D0, VR_D1, VR_D2, VR_D3,
+				SR_RK, SR_MASK, VR_TMP, VR_ADDR,
+				VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	/* Even round: D -> S  (SR_RK2 was prefetched during odd round) */
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx9_s_addc_u32, I9(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx9_s_load_dwordx4, I9(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+	n = emit_aes_round_gfx9(buf, n, VR_D0, VR_D1, VR_D2, VR_D3,
+				VR_S0, VR_S1, VR_S2, VR_S3,
+				SR_RK2, SR_MASK, VR_TMP, VR_ADDR,
+				VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_LOOP_CTR), P_I(1),
+	   P_S(SR_LOOP_CTR));
+	_E(emit_gfx9_s_cmp_lt_u32, I9(buf, n), P_S(SR_LOOP_CTR),
+	   P_S(SR_NBLOCKS));
+	br_loop = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	/* Final odd round: S -> D  (SR_RK prefetched from last even) */
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx9_s_addc_u32, I9(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx9_s_load_dwordx4, I9(buf, n), P_S(SR_RK2), P_S(SR_KEYS), 0);
+	n = emit_aes_round_gfx9(buf, n, VR_S0, VR_S1, VR_S2, VR_S3,
+				VR_D0, VR_D1, VR_D2, VR_D3,
+				SR_RK, SR_MASK, VR_TMP, VR_ADDR,
+				VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	/* Last round: D -> S  (SR_RK2 prefetched during final odd) */
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	n = emit_aes_last_round_gfx9(buf, n, VR_D0, VR_D1, VR_D2, VR_D3,
+				      VR_S0, VR_S1, VR_S2, VR_S3,
+				      SR_RK2, SR_MASK, VR_TMP, VR_ADDR,
+				      VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	return n;
+}
+
+/* ======================================================================
+ * GFX9 GF(2^128) Multiply Helper
+ *
+ * Computes Z = X * Y in GF(2^128) with GCM polynomial.
+ *
+ * Input:  X in v[VR_DATA0:VR_DATA3], Y in v[VR_D0:VR_D3]
+ * Output: Z in v[VR_S0:VR_S3]
+ * Clobbers: v[VR_TMP], v[VR_TMP2], v[VR_ADDR] (holds 0xE1000000),
+ *           v[VR_DATA0:VR_DATA3] (shifted), v[VR_D0:VR_D3] (shifted),
+ *           s[SR_LOOP_CTR]
+ *
+ * GCM bit ordering: bit 0 = MSB of first byte.
+ * Algorithm: Shoup's method (right-shift V, test MSB of X).
+ *   Z = 0, V = Y
+ *   for i = 0..127:
+ *     if MSB(X) set: Z ^= V
+ *     lsb = V[3] & 1
+ *     V >>= 1  (128-bit right shift)
+ *     if lsb: V[0] ^= 0xE1000000
+ *     X <<= 1  (128-bit left shift)
+ * ======================================================================
+ */
+static int emit_gfmul_128_gfx9(u32 *buf, int n)
+{
+	int loop_top, br_loop;
+
+	/* Z = 0 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S0), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S1), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S2), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S3), P_I(0));
+
+	/* Preload reduction constant into VR_ADDR (v10) */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_ADDR), P_L(0xE1000000));
+
+	/* Loop counter */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_LOOP_CTR), P_I(0));
+
+	loop_top = n;
+
+	/* Step 1: Test MSB of X[0] via signed compare (bit 31 set = negative) */
+	_E(emit_gfx9_v_cmp_gt_i32, I9(buf, n), P_I(0), P_V(VR_DATA0));
+
+	/*
+	 * Step 2: Conditional Z ^= V.
+	 * v_cndmask selects V[i] or 0 based on VCC, then XOR into Z.
+	 * v_cndmask_b32: vdst = VCC ? vsrc1 : src0
+	 * We want: VR_TMP2 = VCC ? VR_D0 : 0
+	 * So src0=0, vsrc1=VR_D0
+	 */
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D0));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S0), P_V(VR_S0),
+	   P_V(VR_TMP2));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S1), P_V(VR_S1),
+	   P_V(VR_TMP2));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S2), P_V(VR_S2),
+	   P_V(VR_TMP2));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D3));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_TMP2));
+
+	/*
+	 * Step 3: Save LSB of V[3] for reduction.
+	 */
+	_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(VR_TMP), P_I(1), P_V(VR_D3));
+
+	/*
+	 * Step 4: 128-bit right shift V (v[D0:D3]).
+	 * v_alignbit_b32(dst, hi, lo, 1) = {hi,lo} >> 1 (lower 32 bits).
+	 */
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_D3), P_V(VR_D2),
+	   P_V(VR_D3), P_I(1));
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_D2), P_V(VR_D1),
+	   P_V(VR_D2), P_I(1));
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_D1), P_V(VR_D0),
+	   P_V(VR_D1), P_I(1));
+	_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(VR_D0), P_I(1), P_V(VR_D0));
+
+	/*
+	 * Step 5: Conditional reduction V[0] ^= 0xE1000000.
+	 * If saved LSB was 1, XOR with reduction polynomial.
+	 * 0xE1000000 is preloaded in VR_ADDR (v10).
+	 */
+	_E(emit_gfx9_v_cmp_ne_u32, I9(buf, n), P_I(0), P_V(VR_TMP));
+	/* VR_TMP2 = VCC ? VR_ADDR : 0 */
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_ADDR));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_D0), P_V(VR_D0),
+	   P_V(VR_TMP2));
+
+	/*
+	 * Step 6: 128-bit left shift X (v[DATA0:DATA3]).
+	 * X[0] = (X[0] << 1) | (X[1] >> 31)
+	 * X[1] = (X[1] << 1) | (X[2] >> 31)
+	 * X[2] = (X[2] << 1) | (X[3] >> 31)
+	 * X[3] = X[3] << 1
+	 */
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_DATA0), P_V(VR_DATA0),
+	   P_V(VR_DATA1), P_I(31));
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_DATA1), P_V(VR_DATA1),
+	   P_V(VR_DATA2), P_I(31));
+	_E(emit_gfx9_v_alignbit_b32, I9(buf, n), P_V(VR_DATA2), P_V(VR_DATA2),
+	   P_V(VR_DATA3), P_I(31));
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_DATA3), P_I(1),
+	   P_V(VR_DATA3));
+
+	/* Loop control: 128 iterations */
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_LOOP_CTR), P_I(1),
+	   P_S(SR_LOOP_CTR));
+	_E(emit_gfx9_s_cmp_lt_u32, I9(buf, n), P_S(SR_LOOP_CTR), P_L(128));
+	br_loop = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	return n;
+}
+
+/* ======================================================================
+ * GFX10 (RDNA) AES-GCM emit helpers
+ *
+ * Same as GFX9 but with GFX10 encodings; GLOBAL saddr mode (scalar base
+ * + VGPR offset) avoids VOP3B v_add_co_u32 for 64-bit addresses.
+ * ======================================================================
+ */
+
+/* ---- GFX10 T-table lookup ---- */
+
+static int emit_ttable_lookup_gfx10(u32 *buf, int n,
+				    int v_addr, int v_val,
+				    int v_state, int byte_pos,
+				    int table_base, int s_mask,
+				    int v_tmp)
+{
+	if (byte_pos == 0) {
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(v_tmp),
+		   P_S(s_mask), P_V(v_state));
+	} else if (byte_pos == 3) {
+		_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(v_tmp), P_I(24),
+		   P_V(v_state));
+	} else {
+		_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(v_tmp),
+		   P_I(byte_pos * 8), P_V(v_state));
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(v_tmp),
+		   P_S(s_mask), P_V(v_tmp));
+	}
+
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(v_addr), P_I(2),
+	   P_V(v_tmp));
+	if (table_base > 0)
+		_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(v_addr),
+		   P_L(table_base), P_V(v_addr));
+
+	_E(emit_gfx10_ds_read_b32, I10(buf, n), v_val, v_addr);
+
+	return n;
+}
+
+/* ---- GFX10 AES round ---- */
+
+static int emit_aes_round_gfx10(u32 *buf, int n,
+				int s0, int s1, int s2, int s3,
+				int d0, int d1, int d2, int d3,
+				int rk, int s_mask, int v_tmp, int v_addr,
+				int vt0, int vt1, int vt2, int vt3)
+{
+	/* Column 0: T0[s0.b0] ^ T1[s1.b1] ^ T2[s2.b2] ^ T3[s3.b3] */
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt0, s0, 0, 0, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt1, s1, 1, 1024, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt2, s2, 2, 2048, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt3, s3, 3, 3072, s_mask,
+				     v_tmp);
+	_E(emit_gfx10_s_waitcnt, I10(buf, n), 0x3F, 0);
+
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d0), P_V(vt0), P_V(vt1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d0), P_V(d0), P_V(vt2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d0), P_V(d0), P_V(vt3));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d0), P_S(rk), P_V(d0));
+
+	/* Column 1: T0[s1.b0] ^ T1[s2.b1] ^ T2[s3.b2] ^ T3[s0.b3] */
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt0, s1, 0, 0, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt1, s2, 1, 1024, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt2, s3, 2, 2048, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt3, s0, 3, 3072, s_mask,
+				     v_tmp);
+	_E(emit_gfx10_s_waitcnt, I10(buf, n), 0x3F, 0);
+
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d1), P_V(vt0), P_V(vt1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d1), P_V(d1), P_V(vt2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d1), P_V(d1), P_V(vt3));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d1), P_S(rk + 1),
+	   P_V(d1));
+
+	/* Column 2 */
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt0, s2, 0, 0, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt1, s3, 1, 1024, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt2, s0, 2, 2048, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt3, s1, 3, 3072, s_mask,
+				     v_tmp);
+	_E(emit_gfx10_s_waitcnt, I10(buf, n), 0x3F, 0);
+
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d2), P_V(vt0), P_V(vt1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d2), P_V(d2), P_V(vt2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d2), P_V(d2), P_V(vt3));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d2), P_S(rk + 2),
+	   P_V(d2));
+
+	/* Column 3 */
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt0, s3, 0, 0, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt1, s0, 1, 1024, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt2, s1, 2, 2048, s_mask,
+				     v_tmp);
+	n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt3, s2, 3, 3072, s_mask,
+				     v_tmp);
+	_E(emit_gfx10_s_waitcnt, I10(buf, n), 0x3F, 0);
+
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d3), P_V(vt0), P_V(vt1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d3), P_V(d3), P_V(vt2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d3), P_V(d3), P_V(vt3));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(d3), P_S(rk + 3),
+	   P_V(d3));
+
+	return n;
+}
+
+/* ---- GFX10 AES last round ---- */
+
+static int emit_aes_last_round_gfx10(u32 *buf, int n,
+				     int s0, int s1, int s2, int s3,
+				     int d0, int d1, int d2, int d3,
+				     int rk, int s_mask, int v_tmp, int v_addr,
+				     int vt0, int vt1, int vt2, int vt3)
+{
+	int cols[4][4] = {
+		{s0, s1, s2, s3},
+		{s1, s2, s3, s0},
+		{s2, s3, s0, s1},
+		{s3, s0, s1, s2},
+	};
+	int dsts[4] = {d0, d1, d2, d3};
+	int col;
+
+	for (col = 0; col < 4; col++) {
+		n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt0, cols[col][0],
+					     0, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt1, cols[col][1],
+					     1, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt2, cols[col][2],
+					     2, 0, s_mask, v_tmp);
+		n = emit_ttable_lookup_gfx10(buf, n, v_addr, vt3, cols[col][3],
+					     3, 0, s_mask, v_tmp);
+		_E(emit_gfx10_s_waitcnt, I10(buf, n), 0x3F, 0);
+
+		/* S(x) = (T0[x] >> 8) & 0xFF */
+		_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(vt0), P_I(8),
+		   P_V(vt0));
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(vt0), P_S(s_mask),
+		   P_V(vt0));
+
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(vt1), P_L(0xFF00),
+		   P_V(vt1));
+
+		_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(vt2), P_I(8),
+		   P_V(vt2));
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(vt2),
+		   P_L(0xFF0000), P_V(vt2));
+
+		_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(vt3), P_I(16),
+		   P_V(vt3));
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(vt3),
+		   P_L(0xFF000000), P_V(vt3));
+
+		_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(dsts[col]),
+		   P_V(vt0), P_V(vt1));
+		_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(dsts[col]),
+		   P_V(dsts[col]), P_V(vt2));
+		_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(dsts[col]),
+		   P_V(dsts[col]), P_V(vt3));
+		_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(dsts[col]),
+		   P_S(rk + col), P_V(dsts[col]));
+	}
+
+	return n;
+}
+
+/* ======================================================================
+ * GFX10 AES Encrypt Block Helper
+ *
+ * Same as emit_aes_encrypt_block_gfx9 but with GFX10 instructions.
+ * Input:  plaintext in v[VR_S0:VR_S3]
+ * Output: ciphertext in v[VR_S0:VR_S3]
+ * Requires: SR_KEYS, SR_NR_ROUNDS set. T-tables in LDS.
+ * ======================================================================
+ */
+static int emit_aes_encrypt_block_gfx10(u32 *buf, int n)
+{
+	int br_loop, loop_top;
+
+	/* Round 0: XOR with first round key */
+	_E(emit_gfx10_s_load_dwordx4, I10(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S0), P_S(SR_RK),
+	   P_V(VR_S0));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S1), P_S(SR_RK + 1),
+	   P_V(VR_S1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S2), P_S(SR_RK + 2),
+	   P_V(VR_S2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S3), P_S(SR_RK + 3),
+	   P_V(VR_S3));
+
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx10_s_addc_u32, I10(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+
+	/* pair_count = nr_rounds / 2 - 1 */
+	_E(emit_gfx10_s_lshr_b32, I10(buf, n), P_S(SR_NBLOCKS),
+	   P_S(SR_NR_ROUNDS), P_I(1));
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_NBLOCKS), P_L(0xFFFFFFFFu),
+	   P_S(SR_NBLOCKS));
+
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_LOOP_CTR), P_I(0));
+
+	/* Prefetch round 1 key - overlaps with loop-entry overhead */
+	_E(emit_gfx10_s_load_dwordx4, I10(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+
+	loop_top = n;
+
+	/* Odd round: S -> D  (SR_RK was prefetched) */
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx10_s_addc_u32, I10(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx10_s_load_dwordx4, I10(buf, n), P_S(SR_RK2), P_S(SR_KEYS),
+	   0);
+	n = emit_aes_round_gfx10(buf, n, VR_S0, VR_S1, VR_S2, VR_S3,
+				 VR_D0, VR_D1, VR_D2, VR_D3,
+				 SR_RK, SR_MASK, VR_TMP, VR_ADDR,
+				 VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	/* Even round: D -> S  (SR_RK2 was prefetched during odd round) */
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx10_s_addc_u32, I10(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx10_s_load_dwordx4, I10(buf, n), P_S(SR_RK), P_S(SR_KEYS), 0);
+	n = emit_aes_round_gfx10(buf, n, VR_D0, VR_D1, VR_D2, VR_D3,
+				 VR_S0, VR_S1, VR_S2, VR_S3,
+				 SR_RK2, SR_MASK, VR_TMP, VR_ADDR,
+				 VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_LOOP_CTR), P_I(1),
+	   P_S(SR_LOOP_CTR));
+	_E(emit_gfx10_s_cmp_lt_u32, I10(buf, n), P_S(SR_LOOP_CTR),
+	   P_S(SR_NBLOCKS));
+	br_loop = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	/* Final odd round: S -> D  (SR_RK prefetched from last even) */
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_KEYS), P_I(16),
+	   P_S(SR_KEYS));
+	_E(emit_gfx10_s_addc_u32, I10(buf, n), P_S(SR_KEYS + 1), P_I(0),
+	   P_S(SR_KEYS + 1));
+	_E(emit_gfx10_s_load_dwordx4, I10(buf, n), P_S(SR_RK2), P_S(SR_KEYS),
+	   0);
+	n = emit_aes_round_gfx10(buf, n, VR_S0, VR_S1, VR_S2, VR_S3,
+				 VR_D0, VR_D1, VR_D2, VR_D3,
+				 SR_RK, SR_MASK, VR_TMP, VR_ADDR,
+				 VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	/* Last round: D -> S  (SR_RK2 prefetched during final odd) */
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	n = emit_aes_last_round_gfx10(buf, n, VR_D0, VR_D1, VR_D2, VR_D3,
+				      VR_S0, VR_S1, VR_S2, VR_S3,
+				      SR_RK2, SR_MASK, VR_TMP, VR_ADDR,
+				      VR_DATA0, VR_DATA1, VR_DATA2, VR_DATA3);
+
+	return n;
+}
+
+/* ======================================================================
+ * GFX10 GF(2^128) Multiply Helper
+ *
+ * Same algorithm as GFX9 version but with GFX10 instructions.
+ * Input:  X in v[VR_DATA0:VR_DATA3], Y in v[VR_D0:VR_D3]
+ * Output: Z in v[VR_S0:VR_S3]
+ * ======================================================================
+ */
+static int emit_gfmul_128_gfx10(u32 *buf, int n)
+{
+	int loop_top, br_loop;
+
+	/* Z = 0 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S0), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S1), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S2), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S3), P_I(0));
+
+	/* Preload reduction constant into VR_ADDR (v10) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_ADDR),
+	   P_L(0xE1000000));
+
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_LOOP_CTR), P_I(0));
+
+	loop_top = n;
+
+	/* Step 1: Test MSB of X[0] via signed compare (bit 31 set = negative) */
+	_E(emit_gfx10_v_cmp_gt_i32, I10(buf, n), P_I(0), P_V(VR_DATA0));
+
+	/* Step 2: Conditional Z ^= V */
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D0));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S0), P_V(VR_S0),
+	   P_V(VR_TMP2));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S1), P_V(VR_S1),
+	   P_V(VR_TMP2));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S2), P_V(VR_S2),
+	   P_V(VR_TMP2));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_D3));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_TMP2));
+
+	/* Step 3: Save LSB of V[3] */
+	_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(VR_TMP), P_I(1),
+	   P_V(VR_D3));
+
+	/* Step 4: 128-bit right shift V */
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_D3), P_V(VR_D2),
+	   P_V(VR_D3), P_I(1));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_D2), P_V(VR_D1),
+	   P_V(VR_D2), P_I(1));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_D1), P_V(VR_D0),
+	   P_V(VR_D1), P_I(1));
+	_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(VR_D0), P_I(1),
+	   P_V(VR_D0));
+
+	/* Step 5: Conditional reduction V[0] ^= 0xE1000000 */
+	_E(emit_gfx10_v_cmp_ne_u32, I10(buf, n), P_I(0), P_V(VR_TMP));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n), P_V(VR_TMP2), P_I(0),
+	   P_V(VR_ADDR));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_D0), P_V(VR_D0),
+	   P_V(VR_TMP2));
+
+	/* Step 6: 128-bit left shift X */
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA0), P_V(VR_DATA0),
+	   P_V(VR_DATA1), P_I(31));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA1), P_V(VR_DATA1),
+	   P_V(VR_DATA2), P_I(31));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA2), P_V(VR_DATA2),
+	   P_V(VR_DATA3), P_I(31));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_DATA3), P_I(1),
+	   P_V(VR_DATA3));
+
+	/* Loop control: 128 iterations */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_LOOP_CTR), P_I(1),
+	   P_S(SR_LOOP_CTR));
+	_E(emit_gfx10_s_cmp_lt_u32, I10(buf, n), P_S(SR_LOOP_CTR), P_L(128));
+	br_loop = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	return n;
+}
+
+#undef _E
+#undef _BR
+
+#endif /* AESGCM_SHADER_H_ */
diff --git a/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx10.h b/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx10.h
new file mode 100644
index 000000000000..555bf2962f73
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx10.h
@@ -0,0 +1,1796 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+/*
+ * KNOD IPsec fused RX shader - GFX9 (Vega10/20).
+ *
+ * Full AES-GCM decrypt pipeline for inbound ESP packets:
+ *   1) ESP header parse -> SPI + seq extract
+ *   2) SA table linear scan -> resolve SPI to slot index
+ *   3) Cooperative T-table load (VRAM -> LDS, 256 threads)
+ *   4) AES-CTR decrypt ciphertext -> out_addr
+ *   5) Parallel GHASH over (AAD || ciphertext || len)
+ *   6) ICV verify (GHASH ^ AES(K,J0) vs received tag)
+ *   7) ESP trailer strip -> inner_len
+ *   8) Write verdict to bd->act, inner_len to bd->len
+ *
+ * Dispatch geometry:
+ *   workgroup  = (256, 1, 1)     - 256 threads = 1 AES block per thread
+ *   grid       = (256, nr_pkts, 1)
+ *   workgroup_id_y == packet index in the batch
+ *
+ * Anti-replay is NOT in the shader - CPU-side sliding window in NIC NAPI.
+ *
+ * Verdict encoding in bd->act high32:
+ *   0..NR_SA-1  - SA hit + ICV pass, value is slot_idx
+ *   0xFFFFFFFF  - SA miss (no entry for this SPI)
+ *   0xFFFFFFFE  - non-IPv4/IPv6 bypass (unknown L3 protocol)
+ *   0xFFFFFFFD  - ICV mismatch (decrypt succeeded but tag wrong)
+ *
+ * bd->len is set to inner_len on success (decrypted payload minus ESP
+ * trailer and padding). On miss/bypass/ICV-fail, bd->len is left as-is.
+ */
+
+#ifndef KNOD_HELPERS_IPSEC_FUSED_GFX10_H_
+#define KNOD_HELPERS_IPSEC_FUSED_GFX10_H_
+
+#include <linux/types.h>
+#include "knod_amdgpu_insn.h"
+/* Provide AESGCM_MAX_DIM_Y so aesgcm_shader.h compiles (OFF_T0 macro).
+ * Only emit_aes_encrypt_block_gfx10 / emit_gfmul_128_gfx10 are used here;
+ * the full aesgcm_gen_shader_* functions are unreferenced.
+ */
+#ifndef AESGCM_MAX_DIM_Y
+#define AESGCM_MAX_DIM_Y	1024
+#endif
+#include "aesgcm_shader.h"
+
+/* SA entry constants - must match knod_ipsec.h */
+#define KNOD_IPSEC_SHADER_NR_SA	256
+#define KNOD_IPSEC_SHADER_SA_ENTRY_SZ	104
+
+/* SA entry field offsets (struct knod_ipsec_sa_entry) */
+#define SA_OFF_SPI		0
+#define SA_OFF_KEY_ADDR		16
+#define SA_OFF_HTABLE_ADDR	24
+#define SA_OFF_T_TABLES_ADDR	32
+#define SA_OFF_SALT		40
+#define SA_OFF_KEY_LEN		44
+#define SA_OFF_NR_ROUNDS	48
+#define SA_OFF_MODE		52	/* XFRM_MODE_TRANSPORT=0, TUNNEL=1 */
+#define SA_OFF_STATS_ADDR	88	/* per-SA GPU stats (u64 gpu addr) */
+
+/* ESP packet geometry (ETH=14, IPv4=20 / IPv6=40, no VLAN/opts).
+ * IPv4: ESP header starts at offset 34 (14+20).
+ * IPv6: ESP header starts at offset 54 (14+40).
+ * Within ESP header: SPI+0, seq+4, IV+8, ctext+16.
+ * The shader dynamically computes offsets based on IP version.
+ */
+#define ESP_HDR_OFF_V4		34	/* ETH(14) + IPv4(20) */
+#define ESP_HDR_OFF_V6		54	/* ETH(14) + IPv6(40) */
+#define ESP_REL_SPI		0
+#define ESP_REL_SEQ		4
+#define ESP_REL_IV		8
+#define ESP_REL_CTEXT		16	/* SPI(4)+seq(4)+IV(8) */
+#define ESP_ICV_LEN		16
+
+/* Fixed IPv4 layout offsets used by the crypto KAT */
+#define ESP_SPI_OFF		34
+#define ESP_SEQ_OFF		38
+#define ESP_IV_OFF		42
+#define ESP_CTEXT_OFF		50
+
+/* Fused sub[] offsets within kernarg (sub[i] = kernarg + 40 + i*32) */
+#define SUB_BASE_OFF		40
+#define SUB_STRIDE		32
+#define SUB_OFF_PKT_ADDR	0
+#define SUB_OFF_OUT_ADDR	8
+#define SUB_OFF_BD_ADDR		16
+#define SUB_OFF_PKT_LEN		24
+#define SUB_OFF_RESULT_SEQ	28
+
+/* ICV-fail sentinel (distinct from MISS=0xFFFFFFFF and BYPASS=0xFFFFFFFE) */
+#define VERDICT_ICV_FAIL	0xFFFFFFFDu
+
+/* High VGPRs for saving pre-crypto IPsec state (above AES v0-v22 range) */
+#define VR_SAVE_SLOT		30
+#define VR_SAVE_BD_LO		31
+#define VR_SAVE_BD_HI		32
+#define VR_SAVE_PKT_LO		33
+#define VR_SAVE_PKT_HI		34
+#define VR_SAVE_PKTLEN		35
+#define VR_SAVE_OUT_LO		36
+#define VR_SAVE_OUT_HI		37
+#define VR_SAVE_SEQ		38
+#define VR_SAVE_SPI		39
+#define VR_SAVE_STATS_LO	40	/* per-SA stats GPU addr low */
+#define VR_SAVE_STATS_HI	41	/* per-SA stats GPU addr high */
+/* ESP header offset: 34(v4) or 54(v6) */
+#define VR_SAVE_ESP_OFF		42
+/* Ciphertext prefetch destination - free v23-v27, outside AES v0-v22 range */
+#define VR_PREFETCH0		23
+#define VR_PREFETCH1		24
+#define VR_PREFETCH2		25
+#define VR_PREFETCH3		26
+/* extra dword for GFX10 unaligned fix */
+#define VR_PREFETCH4		27
+
+/* Extra SGPRs for IPsec-specific state that survives into AES phases.
+ * These must NOT collide with SR_* from aesgcm_shader.h (s18-s49, s56-s59).
+ * s50-s55 are IPsec-specific. s56-s59 = SR_RK2 (AES round key double-buffer).
+ */
+#define SR_CTEXT_LEN		50	/* ciphertext length in bytes */
+#define SR_NBLOCKS_GCM		51	/* ceil(ctext_len/16) */
+#define SR_HTABLE_LO		52	/* H-power table GPU addr */
+#define SR_HTABLE_HI		53
+#define SR_TOTAL_GHASH_BLK	54	/* nblocks + 2 (AAD + ctext + len) */
+#define SR_SA_MODE		55	/* XFRM_MODE_TRANSPORT=0, TUNNEL=1 */
+
+/* File-local emit helpers */
+#ifndef _KNOD_IPSEC_EMIT
+#define _KNOD_IPSEC_EMIT
+#define _E(fn, ...) (n += fn(__VA_ARGS__) / 4)
+#define _BR(fn, ...) ({ int _p = n; n += fn(__VA_ARGS__) / 4; _p; })
+#endif
+
+/*
+ * KNOD_IPSEC_GFX10_DIAG_STUB - graduated diagnostic stubs.
+ * Uncomment exactly one level to bisect the SQC inst-fault:
+ *
+ *  Level 1: bare s_endpgm - tests KD, entry offset, BO mapping.
+ *  Level 2: compute bd_addr from kernarg, store 0xDEAD0001, endpgm.
+ *           Tests SGPR layout, VOP2/VOP1 ALU, GLOBAL load/store.
+ *  Level 3: full Phase 0 (parse + SA scan) + write result, endpgm.
+ *           Tests branches, patch_branch, VOP3B carry, SOPC.
+ *
+ * Leave all commented out for the real shader.
+ */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 1 */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 7 */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 2 */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 3 */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 4 */
+/* #define KNOD_IPSEC_GFX10_DIAG_STUB 5 */
+
+static inline int kfd_ipsec_gen_fused_shader_gfx10(void *vbuf)
+{
+	int br_skip12, br_skip14, br_skip15, br_skip18, br_skip16, br_skip13;
+	int br_skip_aad, br_skip_ctext, br_skip_len;
+	int loop_top, br_match, br_loop, br_end;
+	int br_no_sdma, br_no_copy, br_not_last;
+	int br_ipv4, br_bypass, br_crypto_end;
+	int br_ipv6, br_v6_to_common;
+	int br_not_transport, li;
+	const int L3_TMP_BASE = 14;	/* v14..v23 */
+	u32 *buf = (u32 *)vbuf;
+	int br_crypto_done;
+	int br_execz_ctr;
+	int br_execz2;
+	int br_icv_bad;
+	int br_icv_ok;
+	int br_tid0;
+	int br_skip;
+	int br_ok;
+	int level;
+	int n = 0;
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 1
+	/* LEVEL 1: bare s_endpgm - if this faults, KD or BO mapping is
+	 * wrong
+	 */
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 1 (bare endpgm), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 2
+	/* LEVEL 2: load bd_addr from kernarg, write 0xDEAD0001 to bd+8.
+	 * Tests: s8/s9 kernarg ptr, s16 workgroup_id_y, VOP1/VOP2 ALU,
+	 * GLOBAL_LOAD_DWORDX2, GLOBAL_STORE_DWORD, s_waitcnt.
+	 */
+	_E(emit_gfx10_s_waitcnt_vmcnt_lgkmcnt, I10(buf, n));
+	/* v1 = sub offset = 40 + wg_id_y * 32 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(1), P_S(16));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(1), P_I(5), P_V(1));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(1), P_L(SUB_BASE_OFF),
+	   P_V(1));
+	/* v[3:4] = &sub[wg_id_y] */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(2), P_S(9));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(3), P_S(8), P_V(1));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(4), P_I(0), P_V(2));
+	/* v[5:6] = sub[].bd_addr */
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(5), P_V(3),
+	   SUB_OFF_BD_ADDR);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	/* v0 = 0 for lane check: only lane 0 writes */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	/* write 0xDEAD0001 to bd->act (offset +8) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0001u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(5), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 2 (bd write), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 3
+	/* LEVEL 3: s_dcache_inv (SMEM 8-byte) + Level 2 body.
+	 * If this faults but Level 2 passed, SMEM encoding is the culprit.
+	 */
+	_E(emit_gfx10_s_dcache_inv, I10(buf, n));
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	/* --- Level 2 body below --- */
+	_E(emit_gfx10_s_waitcnt_vmcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(1), P_S(16));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(1), P_I(5), P_V(1));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(1), P_L(SUB_BASE_OFF),
+	   P_V(1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(2), P_S(9));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(3), P_S(8), P_V(1));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(4), P_I(0), P_V(2));
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(5), P_V(3),
+	   SUB_OFF_BD_ADDR);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0003u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(5), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 3 (SMEM + bd write), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 4
+	/* LEVEL 4: SOP1 + SOP2 + SOPC + SMEM + Level 2 body.
+	 * Tests the three scalar encoding formats not covered by Levels 1-3.
+	 *   SOP1: s_mov_b32 (encoding 0x17D)
+	 *   SOP2: s_add_u32, s_lshr_b32 (encoding 0x2)
+	 *   SOPC: s_cmp_eq_u32 + s_cbranch_scc1 (encoding 0x17E)
+	 */
+	_E(emit_gfx10_s_dcache_inv, I10(buf, n));
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+
+	/* SOP1: s_mov_b32 s28, 0xCAFE0004 (literal) */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(28), P_L(0xCAFE0004u));
+	/* SOP2: s_add_u32 s28, s28, 1 (inline const) */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(28), P_S(28), P_I(1));
+	/* SOP2: s_lshr_b32 s28, s28, 0 (nop shift) */
+	_E(emit_gfx10_s_lshr_b32, I10(buf, n), P_S(28), P_S(28), P_I(0));
+	/* SOPC: s_cmp_eq_u32 s28, 0xCAFE0005 - should set SCC=1 */
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n), P_S(28), P_L(0xCAFE0005u));
+	br_ok = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+	/* SCC=0 path: write 0xBAD00004 as error marker */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(28), P_L(0xBAD00004u));
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	patch_branch(buf, br_ok, n);
+
+	/* --- Level 2 body: bd write --- */
+	_E(emit_gfx10_s_waitcnt_vmcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(1), P_S(16));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(1), P_I(5), P_V(1));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(1), P_L(SUB_BASE_OFF),
+	   P_V(1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(2), P_S(9));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(3), P_S(8), P_V(1));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(4), P_I(0), P_V(2));
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(5), P_V(3),
+	   SUB_OFF_BD_ADDR);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0004u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(5), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 4 (SOP1/SOP2/SOPC + bd), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+	/* ================================================================
+	 * Phase 0: Parse ESP header + SA table lookup
+	 *
+	 * s_dcache_inv: flush K$ so s_load reads fresh round keys.
+	 * ================================================================
+	 */
+	_E(emit_gfx10_s_dcache_inv, I10(buf, n));
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_BSWAP), P_L(0x00010203));
+
+	/* v1 = 40 + wg_id_y*32 = offset of sub[wg_id_y] within kernarg */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(1), P_S(16));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(1), P_I(5), P_V(1));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(1), P_L(SUB_BASE_OFF),
+	   P_V(1));
+
+	/* v[3:4] = kernarg_ptr + v1 = &sub[wg_id_y] */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(2), P_S(9));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(3), P_S(8), P_V(1));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(4), P_I(0), P_V(2));
+
+	/* Load sub[].pkt_addr -> v[9:10], sub[].bd_addr -> v[5:6] */
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(9), P_V(3),
+	   SUB_OFF_PKT_ADDR);
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(5), P_V(3),
+	   SUB_OFF_BD_ADDR);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* Seed v[11:12] with pkt_addr as a safe default BEFORE the IP
+	 * version branch. The bypass path (non-v4/v6 packets like ARP)
+	 * unconditionally branches past the v[11:12] setup at line ~195
+	 * and later Phase 1 does a global_load at v[11:12]+ESP_REL_SEQ to
+	 * read the ESP sequence number. Without this seed v[11:12] would
+	 * hold uninitialised VGPR state (wave launch garbage), producing
+	 * a fault at ~0x{random}_00000000. For valid v4/v6 packets the
+	 * common path below overwrites v[11:12] with pkt+esp_hdr_off so
+	 * this seed is harmless.
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(11), P_V(9));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(12), P_V(10));
+
+	/* IP version gate: load dword at pkt+12 to get first byte of L3
+	 * header (byte[14]). Extract version nibble -> s28.
+	 */
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(15), P_V(9), 12);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 28, 15);
+	_E(emit_gfx10_s_lshr_b32, I10(buf, n), P_S(28), P_S(28), P_I(20));
+	_E(emit_gfx10_s_and_b32_p, I10(buf, n), P_S(28), P_I(0xF), P_S(28));
+
+	/* Check IPv4 (version==4) */
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n), P_S(28), P_I(4));
+	br_ipv4 = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+
+	/* Check IPv6 (version==6) */
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n), P_S(28), P_I(6));
+	br_ipv6 = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+
+	/* Bypass: neither IPv4 nor IPv6 */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(26), P_L(0xFFFFFFFEu));
+	br_bypass = _BR(emit_gfx10_s_branch, I10(buf, n), 0);
+
+	/* IPv6 landing: esp_hdr_off = 54 */
+	patch_branch(buf, br_ipv6, n);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_ESP_OFF),
+	   P_L(ESP_HDR_OFF_V6));
+	br_v6_to_common = _BR(emit_gfx10_s_branch, I10(buf, n), 0);
+
+	/* IPv4 landing: esp_hdr_off = 34 */
+	patch_branch(buf, br_ipv4, n);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_ESP_OFF),
+	   P_L(ESP_HDR_OFF_V4));
+
+	/* Common path: both IPv4 and IPv6 converge here */
+	patch_branch(buf, br_v6_to_common, n);
+
+	/* v[11:12] = pkt_addr + esp_hdr_off (dynamic) */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(11),
+	   P_V(VR_SAVE_ESP_OFF), P_V(9));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(12), P_I(0),
+	   P_V(10));
+
+	/* v13 = *(u32*)(pkt + esp_hdr_off) - SPI in big-endian.
+	 *
+	 * GFX10 (RDNA2) quirk: global_load_dword silently clears EA's
+	 * low 2 bits, so loading at v[11:12] = pkt + 34 (v4) or pkt + 54
+	 * (v6) would actually read pkt + 32 / pkt + 52. Both ESP offsets
+	 * are 2 mod 4, so the shift to reconstruct the target dword is
+	 * always 16 bits. Use dwordx2 (HW still clears low 2 bits, but
+	 * we get enough data) + v_alignbit_b32 to extract bytes
+	 * [addr..addr+3] from the 8-byte window.
+	 */
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(20), P_V(11), 0);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	/* v_alignbit_b32 D, HIGH, LOW, shift: D = ({HIGH, LOW} >> shift)[31:0].
+	 * tmp_lo = v20 (memory-low dword), tmp_hi = v21 (memory-high dword).
+	 */
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(13), P_V(21), P_V(20),
+	   P_I(16));
+
+	/* Byteswap SPI: v13 = bswap32(v13) via v_perm_b32 */
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(13), P_V(13), P_V(13),
+	   P_S(SR_BSWAP));
+
+	/* SA table linear scan (VMEM path for K$ coherence).
+	 * s22 = target SPI, s[24:25] = sa_table_addr, s23 = counter,
+	 * s26 = result (slot_idx or 0xFFFFFFFF), v[16:17] = running ptr.
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(16), P_S(8));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(17), P_S(9));
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(18), P_V(16), 0);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 24, 18);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 25, 19);
+
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 22, 13);
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(23), P_I(0));
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(26), P_L(0xFFFFFFFFu));
+
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(16), P_S(24));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(17), P_S(25));
+
+	loop_top = n;
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(20), P_V(16),
+	   SA_OFF_SPI);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 27, 20);
+
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(16),
+	   P_L(KNOD_IPSEC_SHADER_SA_ENTRY_SZ), P_V(16));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(17), P_I(0),
+	   P_V(17));
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(23), P_I(1), P_S(23));
+	_E(emit_gfx10_s_nop, I10(buf, n));
+
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n), P_S(27), P_S(22));
+	br_match = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+
+	_E(emit_gfx10_s_cmp_lt_u32, I10(buf, n), P_S(23),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_loop = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	br_end = _BR(emit_gfx10_s_branch, I10(buf, n), 0);
+
+	/* Match: s26 = s23 - 1 */
+	patch_branch(buf, br_match, n);
+	_E(emit_gfx10_s_sub_u32_p, I10(buf, n), P_S(26), P_S(23), P_I(1));
+
+	patch_branch(buf, br_end, n);
+
+	patch_branch(buf, br_bypass, n);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 5
+	/* LEVEL 5: early exit after real Phase 0.
+	 * s26 = slot_idx (or 0xFFFFFFFF if no match).
+	 * Write s26 to bd->act via v[5:6] (bd_addr loaded during Phase 0).
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0005u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(5), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 5 (Phase 0 + exit), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+	/* ================================================================
+	 * Phase 1: Save pre-crypto state + load extra sub[] fields
+	 *
+	 * Move IPsec-specific values to v30+ so v1-v22 and s18-s49 are
+	 * free for AES-GCM helpers from aesgcm_shader.h.
+	 * ================================================================
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_SLOT), P_S(26));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_BD_LO), P_V(5));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_BD_HI), P_V(6));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_PKT_LO), P_V(9));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_PKT_HI), P_V(10));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_SPI), P_V(13));
+
+	/* Load sub[].out_addr -> v[VR_SAVE_OUT_LO:VR_SAVE_OUT_HI] */
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(VR_SAVE_OUT_LO),
+	   P_V(3), SUB_OFF_OUT_ADDR);
+	/* Load sub[].pkt_len -> v[VR_SAVE_PKTLEN] */
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_SAVE_PKTLEN),
+	   P_V(3), SUB_OFF_PKT_LEN);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* Load ESP seq number: pkt + esp_hdr_off + 4, BE -> bswap ->
+	 * v[VR_SAVE_SEQ].
+	 * v[11:12] still holds pkt_addr + esp_hdr_off from Phase 0.
+	 *
+	 * GFX10 unaligned load fix: esp_hdr_off is 34(v4) or 54(v6),
+	 * both == 2 mod 4. EA = pkt+38 clips to pkt+36. Load dwordx2
+	 * from the clipped addr, then v_alignbit_b32 shift=16 to
+	 * reconstruct the target dword.  v[20:21] are free scratch.
+	 */
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(20), P_V(11),
+	   ESP_REL_SEQ);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_SAVE_SEQ), P_V(21),
+	   P_V(20), P_I(16));
+
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_SAVE_SEQ),
+	   P_V(VR_SAVE_SEQ), P_V(VR_SAVE_SEQ), P_S(SR_BSWAP));
+
+	/* Write bswapped seq back into sub[].result_seq for CPU finish worker.
+	 * v[3:4] still points to &sub[wg_id_y].
+	 */
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(3),
+	   P_V(VR_SAVE_SEQ), SUB_OFF_RESULT_SEQ);
+
+	/* ================================================================
+	 * Phase 2: Branch on miss/bypass - skip crypto entirely
+	 * ================================================================
+	 */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 26, VR_SAVE_SLOT);
+	_E(emit_gfx10_s_cmp_ge_u32, I10(buf, n), P_S(26),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_crypto_end = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+
+	/* ================================================================
+	 * Phase 3: Load SA entry fields for the matched slot
+	 *
+	 * entry_addr = sa_table_addr + slot_idx * SA_ENTRY_SIZE
+	 * Load: key_gpu_addr, salt, nr_rounds, t_tables_gpu_addr,
+	 *       htable_gpu_addr
+	 * ================================================================
+	 */
+	/* s27 = slot_idx * SA_ENTRY_SIZE (scalar mul) */
+	_E(emit_gfx10_s_mul_i32, I10(buf, n), P_S(27), P_S(26),
+	   P_L(KNOD_IPSEC_SHADER_SA_ENTRY_SZ));
+	/* s[24:25] = sa_table_addr (already there from Phase 0 scan) */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(24), P_S(24), P_S(27));
+	_E(emit_gfx10_s_addc_u32, I10(buf, n), P_S(25), P_S(25), P_I(0));
+
+	/* Use VMEM for coherence: stage entry addr into VGPR pair */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_LO), P_S(24));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_HI), P_S(25));
+
+	/* Batched SA entry loads: issue all 4 loads to different
+	 * VGPR destinations, then single waitcnt. v1-v8 (S0-S3,
+	 * D0-D3) are free at Phase 3 - not used until Phase 7.
+	 *
+	 * Layout:
+	 *   dwordx4 @+16 -> v[1:4]: key_lo, key_hi, htable_lo, htable_hi
+	 *   dwordx4 @+32 -> v[5:8]: ttables_lo, ttables_hi, salt, key_len
+	 *   dwordx2 @+48 -> v[14:15]: nr_rounds, mode
+	 *   dwordx2 @+88 -> v[16:17]: stats_lo, stats_hi
+	 */
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_S0),
+	   P_V(VR_GA_LO), SA_OFF_KEY_ADDR);
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_D0),
+	   P_V(VR_GA_LO), SA_OFF_T_TABLES_ADDR);
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), SA_OFF_NR_ROUNDS);
+	_E(emit_gfx10_global_load_dwordx2, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_GA_LO), SA_OFF_STATS_ADDR);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* key_addr: v1=lo, v2=hi */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_KEYS, VR_S0);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_KEYS + 1, VR_S1);
+	/* htable_addr: v3=lo, v4=hi */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_HTABLE_LO, VR_S2);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_HTABLE_HI, VR_S3);
+	/* t_tables_addr: v5=lo, v6=hi */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_T_ADDR, VR_D0);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_T_ADDR + 1, VR_D1);
+	/* salt: v7 */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_IV0, VR_D2);
+	/* nr_rounds: v14, mode: v15 */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_NR_ROUNDS, VR_DATA0);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_SA_MODE, VR_DATA1);
+	/* stats_addr: v16=lo, v17=hi -> save VGPRs for Phase 10 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_STATS_LO),
+	   P_V(VR_DATA2));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_STATS_HI),
+	   P_V(VR_DATA3));
+
+	/* ================================================================
+	 * Phase 4: Build AES-GCM nonce
+	 *
+	 * nonce[12] = salt[4] || IV[8]
+	 * salt is already in s[SR_IV0]. Load IV from pkt + esp_hdr_off + 8.
+	 * Recompute ESP base from saved pkt_addr + VR_SAVE_ESP_OFF since
+	 * v[11:12] were clobbered by Phase 3 SA loads (VR_GA_LO=12).
+	 * IV goes to s[SR_IV1] (bytes 4-7) and s[SR_IV2] (bytes 8-11).
+	 * ================================================================
+	 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	/* GFX10 unaligned load fix: EA = pkt+42/62 == 2 mod 4, clips
+	 * to pkt+40/60. Load dwordx4 (16B from clipped addr), then
+	 * alignbit shift=16 to reconstruct IV[0:3] and IV[4:7].
+	 */
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), ESP_REL_IV);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA1), P_V(VR_DATA0), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA2), P_V(VR_DATA1), P_I(16));
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_IV1, VR_DATA0);
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_IV2, VR_DATA1);
+
+	/* ================================================================
+	 * Phase 5: Compute ciphertext bounds
+	 *
+	 * ctext_off = esp_hdr_off + 16 (SPI+seq+IV)
+	 * ctext_len = pkt_len - ctext_off - ICV_LEN
+	 * nblocks = (ctext_len + 15) >> 4
+	 *
+	 * s28 is free here (last used in version gate) - use as scratch.
+	 * ================================================================
+	 */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 28, VR_SAVE_ESP_OFF);
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(28),
+	   P_I(ESP_REL_CTEXT + ESP_ICV_LEN),
+	   P_S(28));  /* s28 = ctext_off + ICV_LEN = overhead to subtract */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), SR_CTEXT_LEN,
+	   VR_SAVE_PKTLEN);
+	_E(emit_gfx10_s_sub_u32_p, I10(buf, n), P_S(SR_CTEXT_LEN),
+	   P_S(SR_CTEXT_LEN), P_S(28));
+	/* s[SR_NBLOCKS_GCM] = (ctext_len + 15) >> 4 */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_NBLOCKS_GCM), P_I(15),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx10_s_lshr_b32, I10(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_S(SR_NBLOCKS_GCM), P_I(4));
+	/* total GHASH blocks = 1(AAD) + nblocks(ctext) + 1(len) = nblocks + 2
+	 */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(SR_TOTAL_GHASH_BLK),
+	   P_I(2), P_S(SR_NBLOCKS_GCM));
+
+	/* ================================================================
+	 * Phase 6: Cooperative T-table load (VRAM -> LDS)
+	 *
+	 * All 256 threads load from SA's t_tables_gpu_addr. Each thread
+	 * loads one u32 per table (4 tables x 256 entries = 4KB).
+	 * ================================================================
+	 */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_MASK), P_L(0xFF));
+
+	/* v[VR_TMP] = tid * 4 (byte offset within each 1KB table) */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_TMP), P_I(2),
+	   P_V(VR_TID));
+
+	/* T0: VRAM[t_tables + tid*4] -> LDS[tid*4] */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_LO),
+	   P_S(SR_T_ADDR));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_S(SR_T_ADDR + 1));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO), P_V(VR_GA_LO),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI), P_I(0),
+	   P_V(VR_GA_HI));
+	/* GFX10 GLOBAL offset is 12-bit signed (-2048..+2047).
+	 * Offsets 2048 and 3072 overflow, so advance the base VGPR
+	 * after the first two loads.
+	 */
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_GA_LO), 1024);
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO), P_L(2048),
+	   P_V(VR_GA_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI), P_I(0),
+	   P_V(VR_GA_HI));
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_DATA3),
+	   P_V(VR_GA_LO), 1024);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* Write to LDS: T0 at +0, T1 at +1024, T2 at +2048, T3 at +3072 */
+	_E(emit_gfx10_ds_write_b32, I10(buf, n), VR_TMP, VR_DATA0);
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_ADDR), P_L(1024),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_ds_write_b32, I10(buf, n), VR_ADDR, VR_DATA1);
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_ADDR), P_L(2048),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_ds_write_b32, I10(buf, n), VR_ADDR, VR_DATA2);
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_ADDR), P_L(3072),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_ds_write_b32, I10(buf, n), VR_ADDR, VR_DATA3);
+
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_barrier, I10(buf, n));
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 6
+	/* LEVEL 6: early exit after Phase 6 (T-table -> LDS + barrier).
+	 * Tests Phase 1-6: SA loads, nonce build, DS writes, s_barrier.
+	 * bd_addr is in v[VR_SAVE_BD_LO:VR_SAVE_BD_HI] = v[31:32].
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0006u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 6 (Phase 0-6 + exit), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+	/* ================================================================
+	 * Phase 7: AES-CTR decrypt
+	 *
+	 * Each thread handles block_id = tid. Only threads with tid <
+	 * nblocks are active. Counter = nonce[12] || bswap32(tid+2).
+	 * AES-encrypt the counter -> keystream. XOR with ciphertext ->
+	 * plaintext. Store to out_addr + tid*16.
+	 * ================================================================
+	 */
+	/* VCC = (nblocks > tid) i.e. tid < nblocks - selects active CTR lanes
+	 */
+	_E(emit_gfx10_v_cmp_gt_u32, I10(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_V(VR_TID));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_EXEC_SAVE,
+	   106 /* VCC_LO */);
+	br_execz_ctr = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+	/* Save SR_KEYS for reload after this block encrypt */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_T_ADDR), P_S(SR_KEYS));
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_T_ADDR + 1),
+	   P_S(SR_KEYS + 1));
+
+	/* Prefetch ciphertext into v[23:27] before AES.
+	 * GFX10 unaligned fix: ctext addr == 2 mod 4, so load
+	 * dwordx4 (clips to aligned) + extra dword at +16.
+	 * The ~200+ cycle AES encrypt hides the VMEM latency.
+	 * v23-v27 are not touched by AES rounds (which use
+	 * v1-v10 only). VR_GA/VR_BLK are also AES-safe.
+	 */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_BLK), P_I(4),
+	   P_V(VR_TID));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_I(ESP_REL_CTEXT), P_V(VR_GA_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_BLK));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_PREFETCH0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_PREFETCH4),
+	   P_V(VR_GA_LO), 16);
+
+	/* Build AES counter block in v[VR_S0:VR_S3]:
+	 * VR_S0 = nonce[0:3] = salt (SR_IV0)
+	 * VR_S1 = nonce[4:7] = IV[0:3] (SR_IV1)
+	 * VR_S2 = nonce[8:11] = IV[4:7] (SR_IV2)
+	 * VR_S3 = bswap32(tid + 2)
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S0), P_S(SR_IV0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S1), P_S(SR_IV1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S2), P_S(SR_IV2));
+
+	/* v[VR_S3] = bswap32(tid + 2) */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_S3), P_I(2),
+	   P_V(VR_TID));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_S3), P_S(SR_BSWAP));
+
+	/* AES encrypt the counter block -> result in v[VR_S0:VR_S3] */
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 7
+	/* LEVEL 7: exit just before emit_aes_encrypt_block_gfx10.
+	 * If this passes but Level 8 (after encrypt) faults,
+	 * the AES block cipher GFX10 code is the culprit.
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0007u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(VR_SAVE_BD_LO), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 7 (before AES encrypt), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+	n = emit_aes_encrypt_block_gfx10(buf, n);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 8
+	/* LEVEL 8: exit right after first emit_aes_encrypt_block_gfx10.
+	 * If this faults, the illegal insn is inside the AES block cipher.
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0008u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(VR_SAVE_BD_LO), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 8 (after AES encrypt), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+	/* Ciphertext arrived during AES - drain vmcnt */
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* GFX10 unaligned fix: 4x alignbit on prefetched data */
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_PREFETCH0),
+	   P_V(VR_PREFETCH1), P_V(VR_PREFETCH0), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_PREFETCH1),
+	   P_V(VR_PREFETCH2), P_V(VR_PREFETCH1), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_PREFETCH2),
+	   P_V(VR_PREFETCH3), P_V(VR_PREFETCH2), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_PREFETCH3),
+	   P_V(VR_PREFETCH4), P_V(VR_PREFETCH3), P_I(16));
+
+	/* XOR keystream with ciphertext -> plaintext */
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_PREFETCH0),
+	   P_V(VR_S0), P_V(VR_PREFETCH0));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_PREFETCH1),
+	   P_V(VR_S1), P_V(VR_PREFETCH1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_PREFETCH2),
+	   P_V(VR_S2), P_V(VR_PREFETCH2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_PREFETCH3),
+	   P_V(VR_S3), P_V(VR_PREFETCH3));
+
+	/* Store plaintext to out_addr + tid*16 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_BLK), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_OUT_HI));
+	_E(emit_gfx10_global_store_dwordx4, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_PREFETCH0), 0);
+
+	patch_branch(buf, br_execz_ctr, n);
+
+	/* ================================================================
+	 * Phase 7.5: Compute AES(K, J0) for ICV finalization
+	 *
+	 * J0 = nonce[12] || 0x00000001 (BE). Only thread 0 needs this
+	 * but all active lanes can compute it; we just save the result.
+	 * ================================================================
+	 */
+	/* Restore SR_KEYS (consumed by encrypt_block) */
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_KEYS), P_S(SR_T_ADDR));
+	_E(emit_gfx10_s_mov_b32, I10(buf, n), P_S(SR_KEYS + 1),
+	   P_S(SR_T_ADDR + 1));
+
+	/* Restore full EXEC for J0 encrypt (all 256 threads) */
+	_E(emit_gfx10_s_or_b64, I10(buf, n), 126 /* EXEC_LO */, SR_EXEC_SAVE,
+	   SR_EXEC_SAVE);
+
+	/* J0 block: nonce || bswap32(1) = nonce || 0x01000000 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S0), P_S(SR_IV0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S1), P_S(SR_IV1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S2), P_S(SR_IV2));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_S3), P_L(0x01000000u));
+
+	n = emit_aes_encrypt_block_gfx10(buf, n);
+
+	/* Save AES(K, J0) -> v[VR_J0_0:VR_J0_3] */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_J0_0), P_V(VR_S0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_J0_1), P_V(VR_S1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_J0_2), P_V(VR_S2));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_J0_3), P_V(VR_S3));
+
+	_E(emit_gfx10_s_barrier, I10(buf, n));
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 9
+	/* LEVEL 9: exit after Phase 7.5 (J0 encrypt + barrier).
+	 * Tests Phase 7 ctext XOR+store, Phase 7.5 second AES encrypt,
+	 * s_or_b64 EXEC restore, s_barrier.
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7),
+	   P_L(0xDEAD0009u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(VR_SAVE_BD_LO), P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	pr_info("knod_ipsec: GFX10 DIAG STUB level 9 (Phase 7.5 + exit), %d bytes\n",
+		n * 4);
+	return n * 4;
+#endif
+
+	/* ================================================================
+	 * Phase 8: Parallel GHASH
+	 *
+	 * GHASH input blocks (total_blocks = nblocks + 2):
+	 *   tid 0            -> AAD: SPI(4B,BE)||seq(4B,BE)||0s (16B)
+	 *   tid 1..nblocks   -> ciphertext block (tid-1)
+	 *   tid nblocks+1    -> len: AAD_bitlen(64b)||ctext_bitlen(64b)
+	 *   tid > nblocks+1  -> zero (does not participate)
+	 *
+	 * Each thread loads its block -> v[VR_DATA0:VR_DATA3] (big-endian
+	 * for GF multiply), loads H^(total-tid) -> v[VR_D0:VR_D3], runs
+	 * GF multiply -> v[VR_S0:VR_S3], then tree-reduces via LDS XOR.
+	 * ================================================================
+	 */
+	/* Prefetch H^(total-tid) from H-power table before data selection.
+	 * The ~60 ALU instructions in the data selection block below
+	 * cover the VMEM latency. Result lands in VR_D0:D3, which
+	 * data selection does not touch. VR_TMP/VR_GA are consumed
+	 * here then free for reuse by the ctext section.
+	 */
+	_E(emit_gfx10_v_sub_nc_u32, I10(buf, n), P_V(VR_TMP),
+	   P_S(SR_TOTAL_GHASH_BLK), P_V(VR_TID));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFFF), P_V(VR_TMP));
+	_E(emit_gfx10_v_max_i32, I10(buf, n), P_V(VR_TMP), P_I(0), P_V(VR_TMP));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_TMP), P_I(4),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_LO),
+	   P_S(SR_HTABLE_LO));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_S(SR_HTABLE_HI));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_TMP));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_D0),
+	   P_V(VR_GA_LO), 0);
+
+	/* EXEC-based per-lane data selection. Default = zero, then
+	 * each case narrows EXEC to matching lanes and writes data.
+	 * This avoids scalar VCC branching (s_cbranch_vccnz) which
+	 * makes the entire wave take one path, not individual lanes.
+	 */
+	/* Default: all threads get zero (non-participating) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA2), P_I(0));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA3), P_I(0));
+
+	/* ---- AAD: tid == 0 ---- */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_aad = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+	/* VR_SAVE_SPI/SEQ are already in BE register convention:
+	 * raw LE load from packet (BE wire bytes) + bswap = byte[0]
+	 * in bits[31:24]. No second bswap needed - use directly.
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_SAVE_SPI));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SEQ));
+	/* DATA2, DATA3 already 0 */
+
+	patch_branch(buf, br_skip_aad, n);
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 12
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip12 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Cu));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip12, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* ---- Ctext: 1 <= tid <= nblocks ---- */
+	/* block_idx = tid - 1 (unsigned; tid==0 -> 0xFFFFFFFF > nblocks) */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_TMP), P_L(0xFFFFFFFF),
+	   P_V(VR_TID));
+	_E(emit_gfx10_v_cmp_gt_u32, I10(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_ctext = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 14
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip14 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Eu));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip14, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* Load ctext block: pkt + esp_hdr_off + 16 + block_idx*16 */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_TMP), P_I(4),
+	   P_V(VR_TMP));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_I(ESP_REL_CTEXT), P_V(VR_GA_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_TMP));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	/* GFX10 unaligned load fix: ctext addr == 2 mod 4.
+	 * dwordx4 + extra dword + 4x alignbit. VR_BLK is free.
+	 */
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_BLK),
+	   P_V(VR_GA_LO), 16);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA1), P_V(VR_DATA0), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA2), P_V(VR_DATA1), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA3), P_V(VR_DATA2), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA3),
+	   P_V(VR_BLK), P_V(VR_DATA3), P_I(16));
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 15
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip15 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Fu));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip15, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* Zero trailing dwords in the last partial ctext block.
+	 * The load above reads 16 raw bytes, but for the last block
+	 * only (ctext_len % 16) bytes are ciphertext - the rest are
+	 * ICV bytes which must NOT enter GHASH.  ESP ctext is always
+	 * 4-byte aligned so the partial count is 4, 8 or 12 - pure
+	 * dword-level zeroing suffices, no byte masking needed.
+	 *
+	 * VR_TMP still holds block_idx * 16 from the address calc.
+	 * remaining = ctext_len - block_idx*16. For full blocks
+	 * (remaining >= 16) every v_cmp evaluates true -> no change.
+	 */
+	_E(emit_gfx10_v_sub_nc_u32, I10(buf, n), P_V(VR_TMP),
+	   P_S(SR_CTEXT_LEN), P_V(VR_TMP));
+	/* VR_TMP = remaining bytes in this block */
+
+	/* DATA3 (bytes 12-15): keep only if remaining > 12 */
+	_E(emit_gfx10_v_cmp_lt_u32, I10(buf, n), P_I(12), P_V(VR_TMP));
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 18
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip18 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD0012u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip18, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n),
+	   P_V(VR_DATA3), P_I(0), P_V(VR_DATA3));
+
+	/* DATA2 (bytes 8-11): keep only if remaining > 8 */
+	_E(emit_gfx10_v_cmp_lt_u32, I10(buf, n), P_I(8), P_V(VR_TMP));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n),
+	   P_V(VR_DATA2), P_I(0), P_V(VR_DATA2));
+
+	/* DATA1 (bytes 4-7): keep only if remaining > 4 */
+	_E(emit_gfx10_v_cmp_lt_u32, I10(buf, n), P_I(4), P_V(VR_TMP));
+	_E(emit_gfx10_v_cndmask_b32_e32, I10(buf, n),
+	   P_V(VR_DATA1), P_I(0), P_V(VR_DATA1));
+
+	/* DATA0 (bytes 0-3): always valid (ESP 4-byte alignment) */
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 16
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip16 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD0010u));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip16, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* bswap each dword for GHASH (big-endian GF arithmetic) */
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA0), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA1), P_V(VR_DATA1), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA2), P_V(VR_DATA2), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_DATA3),
+	   P_V(VR_DATA3), P_V(VR_DATA3), P_S(SR_BSWAP));
+
+	patch_branch(buf, br_skip_ctext, n);
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 13
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip13 = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Du));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip13, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* ---- Len block: tid == nblocks + 1 ---- */
+	/* Compute nblocks+1 in s42 (scratch) */
+	_E(emit_gfx10_s_add_u32, I10(buf, n), P_S(42), P_I(1),
+	   P_S(SR_NBLOCKS_GCM));
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_S(42),
+	   P_V(VR_TID));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_len = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+	/* Length block format (GCM big-endian):
+	 *   DATA0 = AAD_bits[63:32] = 0
+	 *   DATA1 = AAD_bits[31:0]  = 64  (8 bytes AAD x 8)
+	 *   DATA2 = ctext_bits[63:32] = 0
+	 *   DATA3 = ctext_bits[31:0] = ctext_len * 8
+	 *
+	 * No bswap32: length values are computed integers already
+	 * in the correct big-endian register representation.
+	 * bswap32 is only needed for data loaded from LE memory.
+	 */
+	/* DATA0, DATA2 already 0 from default init */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1),
+	   P_L(0x00000040u));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA3),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_DATA3), P_I(3),
+	   P_V(VR_DATA3));
+
+	patch_branch(buf, br_skip_len, n);
+	_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 11
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Bu));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	/* H-table data was prefetched before data selection; drain + bswap */
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_D0),
+	   P_V(VR_D0), P_V(VR_D0), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_D1),
+	   P_V(VR_D1), P_V(VR_D1), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_D2),
+	   P_V(VR_D2), P_V(VR_D2), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_D3),
+	   P_V(VR_D3), P_V(VR_D3), P_S(SR_BSWAP));
+
+	/* ---- GF(2^128) multiply: Z = DATA * H^k ---- */
+#if defined(KNOD_IPSEC_GFX10_DIAG_STUB) && KNOD_IPSEC_GFX10_DIAG_STUB == 10
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(0));
+	br_skip = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_L(0xDEAD000Au));
+	_E(emit_gfx10_global_store_dword, I10(buf, n), P_V(VR_SAVE_BD_LO),
+	   P_V(7), 8);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	patch_branch(buf, br_skip, n);
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+	return n * 4;
+#endif
+	n = emit_gfmul_128_gfx10(buf, n);
+	/* Result in v[VR_S0:VR_S3] */
+
+	/* ---- Tree reduction via LDS XOR (8 levels for 256 threads) ---- */
+	/* Write v[VR_S0:VR_S3] to LDS at tid * 16 */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_ADDR), P_I(4),
+	   P_V(VR_TID));
+	_E(emit_gfx10_ds_write_b128, I10(buf, n), VR_ADDR, VR_S0);
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+	_E(emit_gfx10_s_barrier, I10(buf, n));
+
+	for (level = 1; level <= 128; level <<= 1) {
+		/* if (tid & level) skip */
+		_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(VR_TMP),
+		   P_L(level), P_V(VR_TID));
+		_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(VR_TMP));
+		_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_GHASH_EXEC,
+		   106 /* VCC */);
+		br_skip = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+		/* Compute both addresses up front */
+		_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_TMP),
+		   P_L(level), P_V(VR_TID));
+		_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_TMP),
+		   P_I(4), P_V(VR_TMP));
+		_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_ADDR),
+		   P_I(4), P_V(VR_TID));
+
+		/* Issue both reads, single wait */
+		_E(emit_gfx10_ds_read_b128, I10(buf, n), VR_D0, VR_TMP);
+		_E(emit_gfx10_ds_read_b128, I10(buf, n), VR_S0, VR_ADDR);
+		_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+
+		/* XOR */
+		_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S0),
+		   P_V(VR_S0), P_V(VR_D0));
+		_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S1),
+		   P_V(VR_S1), P_V(VR_D1));
+		_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S2),
+		   P_V(VR_S2), P_V(VR_D2));
+		_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S3),
+		   P_V(VR_S3), P_V(VR_D3));
+
+		/* Write back */
+		_E(emit_gfx10_ds_write_b128, I10(buf, n), VR_ADDR, VR_S0);
+		_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+
+		patch_branch(buf, br_skip, n);
+		/* Restore EXEC */
+		_E(emit_gfx10_s_mov_b64, I10(buf, n), 126 /* EXEC */,
+		   SR_GHASH_EXEC);
+		_E(emit_gfx10_s_barrier, I10(buf, n));
+	}
+
+	/* Thread 0 now has the final GHASH in LDS[0..15]. Read it. */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_TMP), P_I(0));
+	_E(emit_gfx10_ds_read_b128, I10(buf, n), VR_S0, VR_TMP);
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+
+	/* ================================================================
+	 * Phase 9: ICV verify (thread 0 only)
+	 *
+	 * computed_tag = bswap(GHASH) XOR AES(K, J0)
+	 * received_tag = last 16 bytes of ESP packet
+	 * ================================================================
+	 */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_EXEC_SAVE, 106);
+	br_tid0 = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+	/* bswap GHASH from big-endian to little-endian */
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_S0), P_V(VR_S0),
+	   P_V(VR_S0), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_S1), P_V(VR_S1),
+	   P_V(VR_S1), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_S2), P_V(VR_S2),
+	   P_V(VR_S2), P_S(SR_BSWAP));
+	_E(emit_gfx10_v_perm_b32, I10(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_S3), P_S(SR_BSWAP));
+
+	/* computed_tag = GHASH XOR AES(K, J0) */
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S0),
+	   P_V(VR_S0), P_V(VR_J0_0));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S1),
+	   P_V(VR_S1), P_V(VR_J0_1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S2),
+	   P_V(VR_S2), P_V(VR_J0_2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_S3),
+	   P_V(VR_S3), P_V(VR_J0_3));
+
+	/* Load received ICV: pkt + pkt_len - 16.
+	 * GFX10 unaligned load fix: ICV addr == 2 mod 4.
+	 * dwordx4 + extra dword + 4x alignbit. VR_TMP is
+	 * free after address calc; use VR_BLK for 5th dword.
+	 */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFF0u), P_V(VR_SAVE_PKTLEN)); /* pkt_len - 16 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_BLK),
+	   P_V(VR_GA_LO), 16);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA1), P_V(VR_DATA0), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA2), P_V(VR_DATA1), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA3), P_V(VR_DATA2), P_I(16));
+	_E(emit_gfx10_v_alignbit_b32, I10(buf, n), P_V(VR_DATA3),
+	   P_V(VR_BLK), P_V(VR_DATA3), P_I(16));
+
+	/* Compare: XOR each dword, OR together; if any non-zero -> fail */
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_S0));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA1), P_V(VR_S1));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA2), P_V(VR_S2));
+	_E(emit_gfx10_v_xor_b32_e32, I10(buf, n), P_V(VR_DATA3),
+	   P_V(VR_DATA3), P_V(VR_S3));
+	_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA1));
+	_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA2));
+	_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA3));
+
+	/* If VR_DATA0 != 0 -> ICV fail: overwrite verdict with sentinel */
+	_E(emit_gfx10_v_cmp_ne_u32, I10(buf, n), P_I(0), P_V(VR_DATA0));
+	br_icv_ok = _BR(emit_gfx10_s_cbranch_vccz, I10(buf, n), 0);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_SAVE_SLOT),
+	   P_L(VERDICT_ICV_FAIL));
+	patch_branch(buf, br_icv_ok, n);
+
+	/* ================================================================
+	 * Phase 10: ESP trailer strip + write verdict (thread 0)
+	 *
+	 * Decrypted tail: pad_len at out + ctext_len - 2
+	 *                 next_hdr at out + ctext_len - 1
+	 * inner_len = ctext_len - pad_len - 2
+	 * ================================================================
+	 */
+	/* Only strip if ICV passed (slot < NR_SA) */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 27, VR_SAVE_SLOT);
+	_E(emit_gfx10_s_cmp_ge_u32, I10(buf, n), P_S(27),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_icv_bad = _BR(emit_gfx10_s_cbranch_scc1, I10(buf, n), 0);
+
+	/* Load last 4 bytes of decrypted payload: out + ctext_len - 4.
+	 * VOP2 src1 must be VGPR, so move SGPR to VR_TMP first.
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_TMP),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFFC), P_V(VR_TMP)); /* ctext_len - 4 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_OUT_HI));
+	_E(emit_gfx10_global_load_dword, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* On LE: loaded dword has byte layout [b0,b1,b2,b3].
+	 * We loaded from (ctext_len - 4), so:
+	 *   b2 = pad_len (at ctext_len - 2)
+	 *   b3 = next_hdr (at ctext_len - 1)
+	 * pad_len = (dword >> 16) & 0xFF
+	 */
+	_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(VR_TMP),
+	   P_I(16), P_V(VR_DATA0));
+	_E(emit_gfx10_v_and_b32_e32, I10(buf, n), P_V(VR_TMP),
+	   P_L(0xFF), P_V(VR_TMP));
+
+	/* inner_len = ctext_len - pad_len - 2 */
+	_E(emit_gfx10_v_sub_nc_u32, I10(buf, n), P_V(VR_DATA1),
+	   P_S(SR_CTEXT_LEN), P_V(VR_TMP));
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n), P_V(VR_DATA1),
+	   P_L(0xFFFFFFFE), P_V(VR_DATA1)); /* -2 */
+
+	/* Write bd->len = inner_len (u16 at bd + 18) */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_L(18), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx10_global_store_short, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA1), 0);
+
+	/* Write bd->off = mode | (next_hdr << 8) (u16 at bd + 16).
+	 * next_hdr = byte[3] of the ESP trailer dword (VR_DATA0).
+	 * mode from s[SR_SA_MODE].
+	 */
+	_E(emit_gfx10_v_lshrrev_b32, I10(buf, n), P_V(VR_TMP),
+	   P_I(24), P_V(VR_DATA0));
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n), P_V(VR_TMP),
+	   P_I(8), P_V(VR_TMP));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA2),
+	   P_S(SR_SA_MODE));
+	_E(emit_gfx10_v_or_b32_e32, I10(buf, n), P_V(VR_TMP),
+	   P_V(VR_DATA2), P_V(VR_TMP));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_L(16), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx10_global_store_short, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), 0);
+
+	/* Per-SA GPU stats: atomically increment rx_packets
+	 * and rx_bytes at stats_addr. VR_DATA1 still holds
+	 * inner_len from the bd->len computation above.
+	 *
+	 * global_atomic_add_x2 uses v[data:data+1] as u64.
+	 * Save inner_len to VR_TMP before clobbering DATA1.
+	 *
+	 * stats layout (knod_ipsec_sa_gpu_stats):
+	 *   +0: rx_packets (u64, LE)
+	 *   +8: rx_bytes   (u64, LE)
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_TMP),
+	   P_V(VR_DATA1));	/* save inner_len */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_STATS_LO));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_V(VR_SAVE_STATS_HI));
+
+	/* rx_packets += 1: v[DATA0:DATA1] = {1, 0} */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0), P_I(1));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1), P_I(0));
+	_E(emit_gfx10_global_atomic_add_x2, I10(buf, n),
+	   P_V(VR_DATA2), P_V(VR_GA_LO), P_V(VR_DATA0), 0, 0);
+
+	/* rx_bytes += inner_len: v[DATA0:DATA1] = {inner_len, 0} */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_V(VR_TMP));
+	/* DATA1 already 0 from above */
+	_E(emit_gfx10_global_atomic_add_x2, I10(buf, n),
+	   P_V(VR_DATA2), P_V(VR_GA_LO), P_V(VR_DATA0), 8, 0);
+
+	/* ================================================================
+	 * L3 header passthrough (transport mode only).
+	 *
+	 * Copy 20 B of the outer IPv4 L3 header from
+	 * pkt + 14 (skip ETH) to out_addr - 20. In shader-GTT
+	 * direct mode (knod_ipsec_sdma=0), out_addr - 20 is
+	 * pass_buf_slot + 0 so the host-side finalise can skip
+	 * the per-packet L3 SDMA copy entirely - the only
+	 * remaining SDMA call on the transport IPv4 fast path.
+	 *
+	 * Tunnel-mode SAs (SR_SA_MODE != 0) skip this write
+	 * because for tunnel the destination at slot+0 wants
+	 * the *inner* packet, not an outer IP header.
+	 *
+	 * The VRAM staging path (knod_ipsec_sdma=1) also runs
+	 * this copy, but the destination is the 20-byte
+	 * headroom knod_ipsec.c reserves at the front of
+	 * the decrypt pool; CPU finalise still SDMAs the real
+	 * L3 header from the raw packet into the GTT pass_buf
+	 * so the shader's write is harmless wasted work.
+	 *
+	 * Alignment: pkt + 14 is only 2-byte aligned (ETH hdr
+	 * = 14 bytes != 4-byte multiple), so dword / dwordx4
+	 * loads would fault. Use 10 x global_load_ushort at
+	 * offsets 14,16,...,32, paired with 10 x store_short
+	 * at slot + 0,2,...,18. 10 scratch VGPRs (v14..v23),
+	 * all free by Phase 10 since AES-GCM / GHASH state is
+	 * done. One waitcnt between loads and stores.
+	 * ================================================================
+	 */
+
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n),
+	   P_S(SR_SA_MODE), P_I(0));
+	br_not_transport = _BR(emit_gfx10_s_cbranch_scc0,
+			       I10(buf, n), 0);
+
+	/* src = pkt_addr + 14 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n),
+	   P_V(VR_GA_LO), P_I(14),
+	   P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n),
+	   P_V(VR_GA_HI), P_I(0),
+	   P_V(VR_SAVE_PKT_HI));
+
+	/* 10 x 2-byte loads from src+0..+18 */
+	for (li = 0; li < 10; li++) {
+		_E(emit_gfx10_global_load_ushort,
+		   I10(buf, n),
+		   P_V(L3_TMP_BASE + li),
+		   P_V(VR_GA_LO), li * 2);
+	}
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* dst = out_addr - 20.
+	 *
+	 * Two GFX9 landmines here:
+	 *
+	 *  1. v_add_co_u32 can't take a 32-bit
+	 *     literal src together with implicit VCC
+	 *     - same class as the v_cndmask literal
+	 *     restriction.
+	 *  2. P_I(n) is a raw initializer that always
+	 *     sets type=INTEGER_0 and stores n in .v.
+	 *     For negative inline constants the
+	 *     encoder must flip to INTEGER_MINUS_1
+	 *     with v=~n, which P_I does NOT do.
+	 *     P_I(-1) therefore encodes as
+	 *     GFX9_SRC_INTEGER_0 + (-1) = 127, a
+	 *     bogus register that gave us random
+	 *     high-32 bits and page-faulted stores.
+	 *
+	 * Dodge both by materialising -20 into VR_TMP
+	 * and -1 into VR_TMP2 via v_mov_b32 literals
+	 * (VOP1, no VCC, literals fine), then pure
+	 * VGPR+VGPR add_co / addc_co. Borrow flows
+	 * through VCC as the carry-in to addc_co.
+	 */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n),
+	   P_V(VR_TMP), P_L(0xFFFFFFECu));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n),
+	   P_V(VR_TMP2), P_L(0xFFFFFFFFu));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n),
+	   P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n),
+	   P_V(VR_GA_HI),
+	   P_V(VR_TMP2), P_V(VR_SAVE_OUT_HI));
+
+	/* 10 x 2-byte stores to dst+0..+18 */
+	for (li = 0; li < 10; li++) {
+		_E(emit_gfx10_global_store_short,
+		   I10(buf, n),
+		   P_V(VR_GA_LO),
+		   P_V(L3_TMP_BASE + li),
+		   li * 2);
+	}
+
+	patch_branch(buf, br_not_transport, n);
+
+	patch_branch(buf, br_icv_bad, n);
+
+	/* Write bd->act (u64 at bd + 8):
+	 * high32 = slot_idx (or sentinel),
+	 * low32 = KNOD_IPSEC_INFLIGHT so NIC NAPI recognises
+	 * this slot as in-flight until the finish worker stamps
+	 * the final PASS/DROP.
+	 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_L(8), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_L(KNOD_IPSEC_INFLIGHT));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SLOT));
+	_E(emit_gfx10_global_store_dwordx2, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA0), 0);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	patch_branch(buf, br_tid0, n);
+
+	/* ================================================================
+	 * Phase 11: Miss/bypass path verdict - thread 0 only
+	 *
+	 * If we skipped crypto (Phase 2 branch), write the miss/bypass
+	 * sentinel that's still in v[VR_SAVE_SLOT].
+	 * ================================================================
+	 */
+	br_crypto_done = _BR(emit_gfx10_s_branch, I10(buf, n), 0);
+
+	patch_branch(buf, br_crypto_end, n);
+
+	/* Thread 0 writes bd->act with miss/bypass sentinel */
+	_E(emit_gfx10_v_cmp_eq_u32, I10(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx10_s_and_saveexec_b64, I10(buf, n), SR_EXEC_SAVE, 106);
+	br_execz2 = _BR(emit_gfx10_s_cbranch_execz, I10(buf, n), 0);
+
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n), P_V(VR_GA_LO),
+	   P_L(8), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA0),
+	   P_L(KNOD_IPSEC_INFLIGHT));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SLOT));
+	_E(emit_gfx10_global_store_dwordx2, I10(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA0), 0);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	patch_branch(buf, br_execz2, n);
+
+	patch_branch(buf, br_crypto_done, n);
+
+	/* ================================================================
+	 * Phase 12: GPU-initiated SDMA dispatch (thread 0 only)
+	 *
+	 * Identical logic to GFX9 Phase 12.  See ipsec_fused_gfx9.h
+	 * for the full protocol description.
+	 *
+	 * GPU writes SDMA COPY_LINEAR packets only.  FENCE, wptr update,
+	 * and doorbell are left to the CPU.
+	 *
+	 * GFX10 differences:
+	 *  - v_add_nc_u32 / v_sub_nc_u32 (no-carry variants)
+	 *  - v_add_co_ci_u32_e32 for carry-in addition
+	 *  - s_or_b64 for 64-bit zero test (no s_or_b32 helper)
+	 *  - GFX10 global offset is 12-bit signed (all offsets <=56 OK)
+	 * ================================================================
+	 */
+	/* --- kernarg loads ---------------------------------------- */
+	_E(emit_gfx10_s_load_dwordx2, I10(buf, n),
+	   P_S(24), P_S(8), 16);		/* s[24:25] = sdma_ring_addr */
+	_E(emit_gfx10_s_load_dwordx2, I10(buf, n),
+	   P_S(26), P_S(8), 32);		/* s[26:27] = sdma_ctl_addr */
+	_E(emit_gfx10_s_waitcnt_lgkmcnt, I10(buf, n));
+
+	/* s_or_b64 sets SCC = (s[26:27] != 0) */
+	_E(emit_gfx10_s_or_b64, I10(buf, n), 28, 26, 26);
+	br_no_sdma = _BR(emit_gfx10_s_cbranch_scc0, I10(buf, n), 0);
+
+	/* --- load sdma_ctl into VGPRs ----------------------------- */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(1), P_S(26));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(2), P_S(27));
+
+	/* ctl+28: wptr_base_dw(4) ring_mask(4) nr_total_wg(4) copy_hdr(4)
+	 * -> v[3:6]
+	 */
+	_E(emit_gfx10_global_load_dwordx4, I10(buf, n),
+	   P_V(3), P_V(1), 28);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* v3=wptr_base_dw  v4=ring_mask  v5=nr_total_wg  v6=copy_hdr */
+
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n),
+	   28, 5);				/* s28 = nr_total_wg */
+
+	/* --- verdict check ---------------------------------------- */
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n),
+	   29, VR_SAVE_SLOT);			/* s29 = verdict */
+	_E(emit_gfx10_s_cmp_ge_u32, I10(buf, n),
+	   P_S(29), P_L(0xFFFFFFFEu));		/* MISS|BYPASS? */
+	br_no_copy = _BR(emit_gfx10_s_cbranch_scc0, I10(buf, n), 0);
+
+	/* === This WG needs SDMA copy === */
+
+	/* atomic_add(&ctl->claim_counter, 1, GLC=1) -> my_idx */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx10_global_atomic_add, I10(buf, n),
+	   P_V(7), P_V(1), P_V(7), 0, 1);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+	/* v7 = my_idx (old claim_counter) */
+
+	/* ring dword position: (wptr_base_dw + my_idx*7) & ring_mask */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n),
+	   P_V(8), P_I(3), P_V(7));		/* my_idx * 8 */
+	_E(emit_gfx10_v_sub_nc_u32, I10(buf, n),
+	   P_V(8), P_V(8), P_V(7));		/* my_idx * 7 */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n),
+	   P_V(8), P_V(3), P_V(8));		/* + wptr_base_dw */
+	_E(emit_gfx10_v_and_b32_e32, I10(buf, n),
+	   P_V(8), P_V(4), P_V(8));		/* & ring_mask */
+	_E(emit_gfx10_v_lshlrev_b32, I10(buf, n),
+	   P_V(8), P_I(2), P_V(8));		/* * 4 -> byte offset */
+
+	/* v[9:10] = sdma_ring_addr + byte_offset */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(14), P_S(25));
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n),
+	   P_V(9), P_S(24), P_V(8));
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n),
+	   P_V(10), P_I(0), P_V(14));
+
+	/* DW0: copy_hdr */
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(6), 0);
+
+	/* DW1: nbytes - 1 */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n),
+	   P_V(14), P_L(0xFFFFFFFFu), P_V(VR_SAVE_PKTLEN));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(14), 4);
+
+	/* DW2: 0 (sub-op parameter) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(14), P_I(0));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(14), 8);
+
+	/* DW3-4: src = pkt_addr (VRAM) */
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(VR_SAVE_PKT_LO), 12);
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(VR_SAVE_PKT_HI), 16);
+
+	/* DW5-6: dst = out_addr - 20 (GTT slot start) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n),
+	   P_V(14), P_L(0xFFFFFFECu));		/* -20 */
+	_E(emit_gfx10_v_add_co_u32, I10(buf, n),
+	   P_V(15), P_V(14), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n),
+	   P_V(14), P_L(0xFFFFFFFFu));		/* -1 */
+	_E(emit_gfx10_v_add_co_ci_u32_e32, I10(buf, n),
+	   P_V(16), P_V(14), P_V(VR_SAVE_OUT_HI));
+
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(15), 20);
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(9), P_V(16), 24);
+
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* --- done counter (all WGs) ------------------------------- */
+	patch_branch(buf, br_no_copy, n);
+
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx10_global_atomic_add, I10(buf, n),
+	   P_V(7), P_V(1), P_V(7), 4, 1);	/* ctl+4 = done_counter */
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* Last WG check: my_done + 1 == nr_total_wg? */
+	_E(emit_gfx10_v_add_nc_u32, I10(buf, n),
+	   P_V(7), P_I(1), P_V(7));
+	_E(emit_gfx10_v_readfirstlane_b32, I10(buf, n), 29, 7);
+	_E(emit_gfx10_s_cmp_eq_u32, I10(buf, n), P_S(29), P_S(28));
+	br_not_last = _BR(emit_gfx10_s_cbranch_scc0, I10(buf, n), 0);
+
+	/* === Last WG - publish counters for CPU === */
+
+	/* Read final claim_counter (atomic add 0, GLC=1) */
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_I(0));
+	_E(emit_gfx10_global_atomic_add, I10(buf, n),
+	   P_V(7), P_V(1), P_V(7), 0, 1);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	/* Store final_sdma_count (ctl+52) and gpu_sdma_ready (ctl+48) */
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(1), P_V(7), 52);
+	_E(emit_gfx10_v_mov_b32_e32, I10(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx10_global_store_dword, I10(buf, n),
+	   P_V(1), P_V(7), 48);
+	_E(emit_gfx10_s_waitcnt_vmcnt, I10(buf, n));
+
+	patch_branch(buf, br_not_last, n);
+	patch_branch(buf, br_no_sdma, n);
+
+	_E(emit_gfx10_s_endpgm, I10(buf, n));
+
+	/* GFX10 RDNA2 prefetches instructions aggressively past s_endpgm.
+	 * Without an s_code_end cushion the SQC fetches garbage beyond the
+	 * shader and raises an SQC(inst) page fault at a seemingly random
+	 * address. Pad to a 256-dword boundary - same pattern the BPF GFX10
+	 * emitter (knod_bpf.c) uses on working shaders.
+	 */
+	while (n % 256)
+		_E(emit_gfx10_s_code_end, I10(buf, n));
+
+	return n * 4;
+}
+
+#endif /* KNOD_HELPERS_IPSEC_FUSED_GFX10_H_ */
diff --git a/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx9.h b/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx9.h
new file mode 100644
index 000000000000..5121ece1f2eb
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/knod/ipsec_fused_gfx9.h
@@ -0,0 +1,1349 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+/*
+ * KNOD IPsec fused RX shader - GFX9 (Vega10/20).
+ *
+ * Full AES-GCM decrypt pipeline for inbound ESP packets:
+ *   1) ESP header parse -> SPI + seq extract
+ *   2) SA table linear scan -> resolve SPI to slot index
+ *   3) Cooperative T-table load (VRAM -> LDS, 256 threads)
+ *   4) AES-CTR decrypt ciphertext -> out_addr
+ *   5) Parallel GHASH over (AAD || ciphertext || len)
+ *   6) ICV verify (GHASH ^ AES(K,J0) vs received tag)
+ *   7) ESP trailer strip -> inner_len
+ *   8) Write verdict to bd->act, inner_len to bd->len
+ *
+ * Dispatch geometry:
+ *   workgroup  = (256, 1, 1)     - 256 threads = 1 AES block per thread
+ *   grid       = (256, nr_pkts, 1)
+ *   workgroup_id_y == packet index in the batch
+ *
+ * Anti-replay is NOT in the shader - CPU-side sliding window in NIC NAPI.
+ *
+ * Verdict encoding in bd->act high32:
+ *   0..NR_SA-1  - SA hit + ICV pass, value is slot_idx
+ *   0xFFFFFFFF  - SA miss (no entry for this SPI)
+ *   0xFFFFFFFE  - non-IPv4/IPv6 bypass (unknown L3 protocol)
+ *   0xFFFFFFFD  - ICV mismatch (decrypt succeeded but tag wrong)
+ *
+ * bd->len is set to inner_len on success (decrypted payload minus ESP
+ * trailer and padding). On miss/bypass/ICV-fail, bd->len is left as-is.
+ */
+
+#ifndef KNOD_HELPERS_IPSEC_FUSED_GFX9_H_
+#define KNOD_HELPERS_IPSEC_FUSED_GFX9_H_
+
+#include <linux/types.h>
+#include "knod_amdgpu_insn.h"
+/* Provide AESGCM_MAX_DIM_Y so aesgcm_shader.h compiles (OFF_T0 macro).
+ * Only emit_aes_encrypt_block_gfx9 / emit_gfmul_128_gfx9 are used here;
+ * the full aesgcm_gen_shader_* functions are unreferenced.
+ */
+#ifndef AESGCM_MAX_DIM_Y
+#define AESGCM_MAX_DIM_Y	1024
+#endif
+#include "aesgcm_shader.h"
+
+/* SA entry constants - must match knod_ipsec.h */
+#define KNOD_IPSEC_SHADER_NR_SA	256
+#define KNOD_IPSEC_SHADER_SA_ENTRY_SZ	104
+
+/* SA entry field offsets (struct knod_ipsec_sa_entry) */
+#define SA_OFF_SPI		0
+#define SA_OFF_KEY_ADDR		16
+#define SA_OFF_HTABLE_ADDR	24
+#define SA_OFF_T_TABLES_ADDR	32
+#define SA_OFF_SALT		40
+#define SA_OFF_KEY_LEN		44
+#define SA_OFF_NR_ROUNDS	48
+#define SA_OFF_MODE		52	/* XFRM_MODE_TRANSPORT=0, TUNNEL=1 */
+#define SA_OFF_STATS_ADDR	88	/* per-SA GPU stats (u64 gpu addr) */
+
+/* ESP packet geometry (ETH=14, IPv4=20 / IPv6=40, no VLAN/opts).
+ * IPv4: ESP header starts at offset 34 (14+20).
+ * IPv6: ESP header starts at offset 54 (14+40).
+ * Within ESP header: SPI+0, seq+4, IV+8, ctext+16.
+ * The shader dynamically computes offsets based on IP version.
+ */
+#define ESP_HDR_OFF_V4		34	/* ETH(14) + IPv4(20) */
+#define ESP_HDR_OFF_V6		54	/* ETH(14) + IPv6(40) */
+#define ESP_REL_SPI		0
+#define ESP_REL_SEQ		4
+#define ESP_REL_IV		8
+#define ESP_REL_CTEXT		16	/* SPI(4)+seq(4)+IV(8) */
+#define ESP_ICV_LEN		16
+
+/* Fixed IPv4 layout offsets used by the crypto KAT */
+#define ESP_SPI_OFF		34
+#define ESP_SEQ_OFF		38
+#define ESP_IV_OFF		42
+#define ESP_CTEXT_OFF		50
+
+/* Fused sub[] offsets within kernarg (sub[i] = kernarg + 40 + i*32) */
+#define SUB_BASE_OFF		40
+#define SUB_STRIDE		32
+#define SUB_OFF_PKT_ADDR	0
+#define SUB_OFF_OUT_ADDR	8
+#define SUB_OFF_BD_ADDR		16
+#define SUB_OFF_PKT_LEN		24
+#define SUB_OFF_RESULT_SEQ	28
+
+/* ICV-fail sentinel (distinct from MISS=0xFFFFFFFF and BYPASS=0xFFFFFFFE) */
+#define VERDICT_ICV_FAIL	0xFFFFFFFDu
+
+/* High VGPRs for saving pre-crypto IPsec state (above AES v0-v22 range) */
+#define VR_SAVE_SLOT		30
+#define VR_SAVE_BD_LO		31
+#define VR_SAVE_BD_HI		32
+#define VR_SAVE_PKT_LO		33
+#define VR_SAVE_PKT_HI		34
+#define VR_SAVE_PKTLEN		35
+#define VR_SAVE_OUT_LO		36
+#define VR_SAVE_OUT_HI		37
+#define VR_SAVE_SEQ		38
+#define VR_SAVE_SPI		39
+#define VR_SAVE_STATS_LO	40	/* per-SA stats GPU addr low */
+#define VR_SAVE_STATS_HI	41	/* per-SA stats GPU addr high */
+/* ESP header offset: 34(v4) or 54(v6) */
+#define VR_SAVE_ESP_OFF		42
+/* Ciphertext prefetch destination - free v23-v26, inside AES v0-v22 gap */
+#define VR_PREFETCH0		23
+#define VR_PREFETCH1		24
+#define VR_PREFETCH2		25
+#define VR_PREFETCH3		26
+
+/* Extra SGPRs for IPsec-specific state that survives into AES phases.
+ * These must NOT collide with SR_* from aesgcm_shader.h (s18-s49, s56-s59).
+ * s50-s55 are IPsec-specific. s56-s59 = SR_RK2 (AES round key double-buffer).
+ */
+#define SR_CTEXT_LEN		50	/* ciphertext length in bytes */
+#define SR_NBLOCKS_GCM		51	/* ceil(ctext_len/16) */
+#define SR_HTABLE_LO		52	/* H-power table GPU addr */
+#define SR_HTABLE_HI		53
+#define SR_TOTAL_GHASH_BLK	54	/* nblocks + 2 (AAD + ctext + len) */
+#define SR_SA_MODE		55	/* XFRM_MODE_TRANSPORT=0, TUNNEL=1 */
+
+/* File-local emit helpers */
+#ifndef _KNOD_IPSEC_EMIT
+#define _KNOD_IPSEC_EMIT
+#define _E(fn, ...) (n += fn(__VA_ARGS__) / 4)
+#define _BR(fn, ...) ({ int _p = n; n += fn(__VA_ARGS__) / 4; _p; })
+#endif
+
+static inline int kfd_ipsec_gen_fused_shader_gfx9(void *vbuf)
+{
+	int br_skip_aad, br_skip_ctext, br_skip_len;
+	int loop_top, br_match, br_loop, br_end;
+	int br_no_sdma, br_no_copy, br_not_last;
+	int br_ipv4, br_bypass, br_crypto_end;
+	const int L3_TMP_BASE = 14;   /* v14..v23 */
+	int br_ipv6, br_v6_to_common;
+	int br_not_transport, li;
+	u32 *buf = (u32 *)vbuf;
+	int br_crypto_done;
+	int br_execz_ctr;
+	int br_execz2;
+	int br_icv_bad;
+	int br_icv_ok;
+	int br_tid0;
+	int level;
+	int n = 0;
+
+	/* ================================================================
+	 * Phase 0: Parse ESP header + SA table lookup
+	 *
+	 * s_dcache_inv: flush K$ so s_load reads fresh round keys.
+	 * ================================================================
+	 */
+	_E(emit_gfx9_s_dcache_inv, I9(buf, n));
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+
+	/* Cache bswap32 selector in SR_BSWAP for reuse across all phases */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_BSWAP), P_L(0x00010203));
+
+	/* v1 = 40 + wg_id_y*32 = offset of sub[wg_id_y] within kernarg */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(1), P_S(16));
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(1), P_I(5), P_V(1));
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(1), P_L(SUB_BASE_OFF), P_V(1));
+
+	/* v[3:4] = kernarg_ptr + v1 = &sub[wg_id_y] */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(2), P_S(9));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(3), P_S(8), P_V(1));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(4), P_I(0), P_V(2));
+
+	/* Load sub[].pkt_addr -> v[9:10], sub[].bd_addr -> v[5:6] */
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(9), P_V(3),
+	   SUB_OFF_PKT_ADDR);
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(5), P_V(3),
+	   SUB_OFF_BD_ADDR);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Seed v[11:12] with pkt_addr as a safe default BEFORE the IP
+	 * version branch. The bypass path (non-v4/v6 packets like ARP)
+	 * unconditionally branches past the v[11:12] setup at line ~195
+	 * and later Phase 1 does a global_load at v[11:12]+ESP_REL_SEQ to
+	 * read the ESP sequence number. Without this seed v[11:12] would
+	 * hold uninitialised VGPR state (wave launch garbage), producing
+	 * a fault at ~0x{random}_00000000. For valid v4/v6 packets the
+	 * common path below overwrites v[11:12] with pkt+esp_hdr_off so
+	 * this seed is harmless.
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(11), P_V(9));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(12), P_V(10));
+
+	/* IP version gate: load dword at pkt+12 to get first byte of L3
+	 * header (byte[14]). Extract version nibble -> s28.
+	 */
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(15), P_V(9), 12);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 28, 15);
+	_E(emit_gfx9_s_lshr_b32, I9(buf, n), P_S(28), P_S(28), P_I(20));
+	_E(emit_gfx9_s_and_b32_p, I9(buf, n), P_S(28), P_I(0xF), P_S(28));
+
+	/* Check IPv4 (version==4) */
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n), P_S(28), P_I(4));
+	br_ipv4 = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	/* Check IPv6 (version==6) */
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n), P_S(28), P_I(6));
+	br_ipv6 = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	/* Bypass: neither IPv4 nor IPv6 */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(26), P_L(0xFFFFFFFEu));
+	br_bypass = _BR(emit_gfx9_s_branch, I9(buf, n), 0);
+
+	/* IPv6 landing: esp_hdr_off = 54 */
+	patch_branch(buf, br_ipv6, n);
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_ESP_OFF),
+	   P_L(ESP_HDR_OFF_V6));
+	br_v6_to_common = _BR(emit_gfx9_s_branch, I9(buf, n), 0);
+
+	/* IPv4 landing: esp_hdr_off = 34 */
+	patch_branch(buf, br_ipv4, n);
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_ESP_OFF),
+	   P_L(ESP_HDR_OFF_V4));
+
+	/* Common path: both IPv4 and IPv6 converge here */
+	patch_branch(buf, br_v6_to_common, n);
+
+	/* v[11:12] = pkt_addr + esp_hdr_off (dynamic) */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(11),
+	   P_V(VR_SAVE_ESP_OFF), P_V(9));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(12), P_I(0), P_V(10));
+
+	/* v13 = *(u32*)(pkt + esp_hdr_off) - SPI in big-endian */
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(13), P_V(11), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Byteswap SPI: v13 = bswap32(v13) via v_perm_b32 */
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(13), P_V(13), P_V(13),
+	   P_S(SR_BSWAP));
+
+	/* SA table linear scan (VMEM path for K$ coherence).
+	 * s22 = target SPI, s[24:25] = sa_table_addr, s23 = counter,
+	 * s26 = result (slot_idx or 0xFFFFFFFF), v[16:17] = running ptr.
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(16), P_S(8));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(17), P_S(9));
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(18), P_V(16), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 24, 18);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 25, 19);
+
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 22, 13);
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(23), P_I(0));
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(26), P_L(0xFFFFFFFFu));
+
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(16), P_S(24));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(17), P_S(25));
+
+	loop_top = n;
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(20), P_V(16),
+	   SA_OFF_SPI);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 27, 20);
+
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(16),
+	   P_L(KNOD_IPSEC_SHADER_SA_ENTRY_SZ), P_V(16));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(17), P_I(0), P_V(17));
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(23), P_I(1), P_S(23));
+	_E(emit_gfx9_s_nop, I9(buf, n));
+
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n), P_S(27), P_S(22));
+	br_match = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	_E(emit_gfx9_s_cmp_lt_u32, I9(buf, n), P_S(23),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_loop = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+	patch_branch(buf, br_loop, loop_top);
+
+	br_end = _BR(emit_gfx9_s_branch, I9(buf, n), 0);
+
+	/* Match: s26 = s23 - 1 */
+	patch_branch(buf, br_match, n);
+	_E(emit_gfx9_s_sub_u32_p, I9(buf, n), P_S(26), P_S(23), P_I(1));
+
+	patch_branch(buf, br_end, n);
+
+	patch_branch(buf, br_bypass, n);
+
+	/* ================================================================
+	 * Phase 1: Save pre-crypto state + load extra sub[] fields
+	 *
+	 * Move IPsec-specific values to v30+ so v1-v22 and s18-s49 are
+	 * free for AES-GCM helpers from aesgcm_shader.h.
+	 * ================================================================
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_SLOT), P_S(26));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_BD_LO), P_V(5));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_BD_HI), P_V(6));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_PKT_LO), P_V(9));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_PKT_HI), P_V(10));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_SPI), P_V(13));
+
+	/* Load sub[].out_addr -> v[VR_SAVE_OUT_LO:VR_SAVE_OUT_HI] */
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(VR_SAVE_OUT_LO),
+	   P_V(3), SUB_OFF_OUT_ADDR);
+	/* Load sub[].pkt_len -> v[VR_SAVE_PKTLEN] */
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_SAVE_PKTLEN),
+	   P_V(3), SUB_OFF_PKT_LEN);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Load ESP seq number: pkt + esp_hdr_off + 4, BE -> bswap ->
+	 * v[VR_SAVE_SEQ].
+	 * v[11:12] still holds pkt_addr + esp_hdr_off from Phase 0.
+	 */
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_SAVE_SEQ), P_V(11),
+	   ESP_REL_SEQ);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_SAVE_SEQ),
+	   P_V(VR_SAVE_SEQ), P_V(VR_SAVE_SEQ), P_S(SR_BSWAP));
+
+	/* Write bswapped seq back into sub[].result_seq for CPU finish worker.
+	 * v[3:4] still points to &sub[wg_id_y].
+	 */
+	_E(emit_gfx9_global_store_dword, I9(buf, n), P_V(3),
+	   P_V(VR_SAVE_SEQ), SUB_OFF_RESULT_SEQ);
+
+	/* ================================================================
+	 * Phase 2: Branch on miss/bypass - skip crypto entirely
+	 * ================================================================
+	 */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 26, VR_SAVE_SLOT);
+	_E(emit_gfx9_s_cmp_ge_u32, I9(buf, n), P_S(26),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_crypto_end = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	/* ================================================================
+	 * Phase 3: Load SA entry fields for the matched slot
+	 *
+	 * entry_addr = sa_table_addr + slot_idx * SA_ENTRY_SIZE
+	 * Load: key_gpu_addr, salt, nr_rounds, t_tables_gpu_addr,
+	 *       htable_gpu_addr
+	 * ================================================================
+	 */
+	/* s27 = slot_idx * SA_ENTRY_SIZE (scalar mul) */
+	_E(emit_gfx9_s_mul_i32, I9(buf, n), P_S(27), P_S(26),
+	   P_L(KNOD_IPSEC_SHADER_SA_ENTRY_SZ));
+	/* s[24:25] = sa_table_addr (already there from Phase 0 scan) */
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(24), P_S(24), P_S(27));
+	_E(emit_gfx9_s_addc_u32, I9(buf, n), P_S(25), P_S(25), P_I(0));
+
+	/* Use VMEM for coherence: stage entry addr into VGPR pair */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_LO), P_S(24));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_HI), P_S(25));
+
+	/* Batched SA entry loads: issue all 4 loads to different
+	 * VGPR destinations, then single waitcnt. v1-v8 (S0-S3,
+	 * D0-D3) are free at Phase 3 - not used until Phase 7.
+	 *
+	 * Layout:
+	 *   dwordx4 @+16 -> v[1:4]: key_lo, key_hi, htable_lo, htable_hi
+	 *   dwordx4 @+32 -> v[5:8]: ttables_lo, ttables_hi, salt, key_len
+	 *   dwordx2 @+48 -> v[14:15]: nr_rounds, mode
+	 *   dwordx2 @+88 -> v[16:17]: stats_lo, stats_hi
+	 */
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_S0),
+	   P_V(VR_GA_LO), SA_OFF_KEY_ADDR);
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_D0),
+	   P_V(VR_GA_LO), SA_OFF_T_TABLES_ADDR);
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), SA_OFF_NR_ROUNDS);
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(VR_DATA2),
+	   P_V(VR_GA_LO), SA_OFF_STATS_ADDR);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* key_addr: v1=lo, v2=hi */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_KEYS, VR_S0);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_KEYS + 1, VR_S1);
+	/* htable_addr: v3=lo, v4=hi */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_HTABLE_LO, VR_S2);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_HTABLE_HI, VR_S3);
+	/* t_tables_addr: v5=lo, v6=hi */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_T_ADDR, VR_D0);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_T_ADDR + 1, VR_D1);
+	/* salt: v7 */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_IV0, VR_D2);
+	/* nr_rounds: v14, mode: v15 */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_NR_ROUNDS, VR_DATA0);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_SA_MODE, VR_DATA1);
+	/* stats_addr: v16=lo, v17=hi -> save VGPRs for Phase 10 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_STATS_LO),
+	   P_V(VR_DATA2));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_STATS_HI),
+	   P_V(VR_DATA3));
+
+	/* ================================================================
+	 * Phase 4: Build AES-GCM nonce
+	 *
+	 * nonce[12] = salt[4] || IV[8]
+	 * salt is already in s[SR_IV0]. Load IV from pkt + esp_hdr_off + 8.
+	 * Recompute ESP base from saved pkt_addr + VR_SAVE_ESP_OFF since
+	 * v[11:12] were clobbered by Phase 3 SA loads (VR_GA_LO=12).
+	 * IV goes to s[SR_IV1] (bytes 4-7) and s[SR_IV2] (bytes 8-11).
+	 * ================================================================
+	 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx9_global_load_dwordx2, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), ESP_REL_IV);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_IV1, VR_DATA0);
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_IV2, VR_DATA1);
+
+	/* ================================================================
+	 * Phase 5: Compute ciphertext bounds
+	 *
+	 * ctext_off = esp_hdr_off + 16 (SPI+seq+IV)
+	 * ctext_len = pkt_len - ctext_off - ICV_LEN
+	 * nblocks = (ctext_len + 15) >> 4
+	 *
+	 * s28 is free here (last used in version gate) - use as scratch.
+	 * ================================================================
+	 */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 28, VR_SAVE_ESP_OFF);
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(28),
+	   P_I(ESP_REL_CTEXT + ESP_ICV_LEN),
+	   P_S(28));  /* s28 = ctext_off + ICV_LEN = overhead to subtract */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), SR_CTEXT_LEN,
+	   VR_SAVE_PKTLEN);
+	_E(emit_gfx9_s_sub_u32_p, I9(buf, n), P_S(SR_CTEXT_LEN),
+	   P_S(SR_CTEXT_LEN), P_S(28));
+	/* s[SR_NBLOCKS_GCM] = (ctext_len + 15) >> 4 */
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_NBLOCKS_GCM), P_I(15),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx9_s_lshr_b32, I9(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_S(SR_NBLOCKS_GCM), P_I(4));
+	/* total GHASH blocks = 1(AAD) + nblocks(ctext) + 1(len) = nblocks + 2
+	 */
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(SR_TOTAL_GHASH_BLK),
+	   P_I(2), P_S(SR_NBLOCKS_GCM));
+
+	/* ================================================================
+	 * Phase 6: Cooperative T-table load (VRAM -> LDS)
+	 *
+	 * All 256 threads load from SA's t_tables_gpu_addr. Each thread
+	 * loads one u32 per table (4 tables x 256 entries = 4KB).
+	 * ================================================================
+	 */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_MASK), P_L(0xFF));
+
+	/* v[VR_TMP] = tid * 4 (byte offset within each 1KB table) */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_TMP), P_I(2),
+	   P_V(VR_TID));
+
+	/* T0: VRAM[t_tables + tid*4] -> LDS[tid*4] */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_LO), P_S(SR_T_ADDR));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_HI),
+	   P_S(SR_T_ADDR + 1));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO), P_V(VR_GA_LO),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI), P_I(0),
+	   P_V(VR_GA_HI));
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_GA_LO), 1024);
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_DATA2),
+	   P_V(VR_GA_LO), 2048);
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_DATA3),
+	   P_V(VR_GA_LO), 3072);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Write to LDS: T0 at +0, T1 at +1024, T2 at +2048, T3 at +3072 */
+	_E(emit_gfx9_ds_write_b32, I9(buf, n), VR_TMP, VR_DATA0);
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_ADDR), P_L(1024),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_ds_write_b32, I9(buf, n), VR_ADDR, VR_DATA1);
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_ADDR), P_L(2048),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_ds_write_b32, I9(buf, n), VR_ADDR, VR_DATA2);
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_ADDR), P_L(3072),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_ds_write_b32, I9(buf, n), VR_ADDR, VR_DATA3);
+
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_s_barrier, I9(buf, n));
+
+	/* ================================================================
+	 * Phase 7: AES-CTR decrypt
+	 *
+	 * Each thread handles block_id = tid. Only threads with tid <
+	 * nblocks are active. Counter = nonce[12] || bswap32(tid+2).
+	 * AES-encrypt the counter -> keystream. XOR with ciphertext ->
+	 * plaintext. Store to out_addr + tid*16.
+	 * ================================================================
+	 */
+	/* VCC = (nblocks > tid) i.e. tid < nblocks - selects active CTR lanes
+	 */
+	_E(emit_gfx9_v_cmp_gt_u32, I9(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_V(VR_TID));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_EXEC_SAVE,
+	   106 /* VCC_LO */);
+	br_execz_ctr = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	/* Save SR_KEYS for reload after this block encrypt */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_T_ADDR), P_S(SR_KEYS));
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_T_ADDR + 1),
+	   P_S(SR_KEYS + 1));
+
+	/* Prefetch ciphertext into v[23:26] before AES.
+	 * The ~200+ cycle AES encrypt hides the VMEM latency.
+	 * v23-v26 are not touched by AES rounds (which use
+	 * v1-v18 only). VR_GA/VR_BLK are also AES-safe.
+	 */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_BLK), P_I(4),
+	   P_V(VR_TID));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_I(ESP_REL_CTEXT), P_V(VR_GA_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_BLK));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_PREFETCH0),
+	   P_V(VR_GA_LO), 0);
+
+	/* Build AES counter block in v[VR_S0:VR_S3]:
+	 * VR_S0 = nonce[0:3] = salt (SR_IV0)
+	 * VR_S1 = nonce[4:7] = IV[0:3] (SR_IV1)
+	 * VR_S2 = nonce[8:11] = IV[4:7] (SR_IV2)
+	 * VR_S3 = bswap32(tid + 2)
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S0), P_S(SR_IV0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S1), P_S(SR_IV1));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S2), P_S(SR_IV2));
+
+	/* v[VR_S3] = bswap32(tid + 2) */
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_S3), P_I(2), P_V(VR_TID));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_S3), P_S(SR_BSWAP));
+
+	/* AES encrypt the counter block -> result in v[VR_S0:VR_S3] */
+	n = emit_aes_encrypt_block_gfx9(buf, n);
+
+	/* Ciphertext arrived during AES - drain vmcnt */
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* XOR keystream with prefetched ciphertext -> plaintext */
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_PREFETCH0),
+	   P_V(VR_S0), P_V(VR_PREFETCH0));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_PREFETCH1),
+	   P_V(VR_S1), P_V(VR_PREFETCH1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_PREFETCH2),
+	   P_V(VR_S2), P_V(VR_PREFETCH2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_PREFETCH3),
+	   P_V(VR_S3), P_V(VR_PREFETCH3));
+
+	/* Store plaintext to out_addr + tid*16 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_BLK), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_OUT_HI));
+	_E(emit_gfx9_global_store_dwordx4, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_PREFETCH0), 0);
+
+	patch_branch(buf, br_execz_ctr, n);
+
+	/* ================================================================
+	 * Phase 7.5: Compute AES(K, J0) for ICV finalization
+	 *
+	 * J0 = nonce[12] || 0x00000001 (BE). Only thread 0 needs this
+	 * but all active lanes can compute it; we just save the result.
+	 * ================================================================
+	 */
+	/* Restore SR_KEYS (consumed by encrypt_block) */
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_KEYS), P_S(SR_T_ADDR));
+	_E(emit_gfx9_s_mov_b32, I9(buf, n), P_S(SR_KEYS + 1),
+	   P_S(SR_T_ADDR + 1));
+
+	/* Restore full EXEC for J0 encrypt (all 256 threads) */
+	_E(emit_gfx9_s_or_b64, I9(buf, n), 126 /* EXEC_LO */, SR_EXEC_SAVE,
+	   SR_EXEC_SAVE);
+
+	/* J0 block: nonce || bswap32(1) = nonce || 0x01000000 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S0), P_S(SR_IV0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S1), P_S(SR_IV1));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S2), P_S(SR_IV2));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_S3), P_L(0x01000000u));
+
+	n = emit_aes_encrypt_block_gfx9(buf, n);
+
+	/* Save AES(K, J0) -> v[VR_J0_0:VR_J0_3] */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_J0_0), P_V(VR_S0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_J0_1), P_V(VR_S1));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_J0_2), P_V(VR_S2));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_J0_3), P_V(VR_S3));
+
+	_E(emit_gfx9_s_barrier, I9(buf, n));
+
+	/* ================================================================
+	 * Phase 8: Parallel GHASH
+	 *
+	 * GHASH input blocks (total_blocks = nblocks + 2):
+	 *   tid 0            -> AAD: SPI(4B,BE)||seq(4B,BE)||0s (16B)
+	 *   tid 1..nblocks   -> ciphertext block (tid-1)
+	 *   tid nblocks+1    -> len: AAD_bitlen(64b)||ctext_bitlen(64b)
+	 *   tid > nblocks+1  -> zero (does not participate)
+	 *
+	 * Each thread loads its block -> v[VR_DATA0:VR_DATA3] (big-endian
+	 * for GF multiply), loads H^(total-tid) -> v[VR_D0:VR_D3], runs
+	 * GF multiply -> v[VR_S0:VR_S3], then tree-reduces via LDS XOR.
+	 * ================================================================
+	 */
+	/* Prefetch H^(total-tid) from H-power table before data selection.
+	 * The ~60 ALU instructions in the data selection block below
+	 * cover the VMEM latency. Result lands in VR_D0:D3, which
+	 * data selection does not touch. VR_TMP/VR_GA are consumed
+	 * here then free for reuse by the ctext section.
+	 */
+	_E(emit_gfx9_v_sub_u32, I9(buf, n), P_V(VR_TMP),
+	   P_S(SR_TOTAL_GHASH_BLK), P_V(VR_TID));
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFFF), P_V(VR_TMP));
+	_E(emit_gfx9_v_max_i32, I9(buf, n), P_V(VR_TMP), P_I(0), P_V(VR_TMP));
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_TMP), P_I(4),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_LO),
+	   P_S(SR_HTABLE_LO));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_HI),
+	   P_S(SR_HTABLE_HI));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_TMP));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_D0),
+	   P_V(VR_GA_LO), 0);
+
+	/* EXEC-based per-lane data selection. Default = zero, then
+	 * each case narrows EXEC to matching lanes and writes data.
+	 * This avoids scalar VCC branching (s_cbranch_vccnz) which
+	 * makes the entire wave take one path, not individual lanes.
+	 */
+	/* Default: all threads get zero (non-participating) */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA2), P_I(0));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA3), P_I(0));
+
+	/* ---- AAD: tid == 0 ---- */
+	_E(emit_gfx9_v_cmp_eq_u32, I9(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_aad = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	/* VR_SAVE_SPI/SEQ are already in BE register convention:
+	 * raw LE load from packet (BE wire bytes) + bswap = byte[0]
+	 * in bits[31:24]. No second bswap needed - use directly.
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_SAVE_SPI));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SEQ));
+	/* DATA2, DATA3 already 0 */
+
+	patch_branch(buf, br_skip_aad, n);
+	_E(emit_gfx9_s_mov_b64, I9(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+	/* ---- Ctext: 1 <= tid <= nblocks ---- */
+	/* block_idx = tid - 1 (unsigned; tid==0 -> 0xFFFFFFFF > nblocks) */
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_TMP), P_L(0xFFFFFFFF),
+	   P_V(VR_TID));
+	_E(emit_gfx9_v_cmp_gt_u32, I9(buf, n), P_S(SR_NBLOCKS_GCM),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_ctext = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	/* Load ctext block: pkt + esp_hdr_off + 16 + block_idx*16 */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_TMP), P_I(4),
+	   P_V(VR_TMP));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_ESP_OFF), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_I(ESP_REL_CTEXT), P_V(VR_GA_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_GA_LO), P_V(VR_TMP));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_GA_HI));
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Zero trailing dwords in the last partial ctext block.
+	 * The load above reads 16 raw bytes, but for the last block
+	 * only (ctext_len % 16) bytes are ciphertext - the rest are
+	 * ICV bytes which must NOT enter GHASH.  ESP ctext is always
+	 * 4-byte aligned so the partial count is 4, 8 or 12 - pure
+	 * dword-level zeroing suffices, no byte masking needed.
+	 *
+	 * VR_TMP still holds block_idx * 16 from the address calc.
+	 * remaining = ctext_len - block_idx*16. For full blocks
+	 * (remaining >= 16) every v_cmp evaluates true -> no change.
+	 */
+	_E(emit_gfx9_v_sub_u32, I9(buf, n), P_V(VR_TMP),
+	   P_S(SR_CTEXT_LEN), P_V(VR_TMP));
+	/* VR_TMP = remaining bytes in this block */
+
+	/* DATA3 (bytes 12-15): keep only if remaining > 12 */
+	_E(emit_gfx9_v_cmp_lt_u32, I9(buf, n), P_I(12), P_V(VR_TMP));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n),
+	   P_V(VR_DATA3), P_I(0), P_V(VR_DATA3));
+
+	/* DATA2 (bytes 8-11): keep only if remaining > 8 */
+	_E(emit_gfx9_v_cmp_lt_u32, I9(buf, n), P_I(8), P_V(VR_TMP));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n),
+	   P_V(VR_DATA2), P_I(0), P_V(VR_DATA2));
+
+	/* DATA1 (bytes 4-7): keep only if remaining > 4 */
+	_E(emit_gfx9_v_cmp_lt_u32, I9(buf, n), P_I(4), P_V(VR_TMP));
+	_E(emit_gfx9_v_cndmask_b32_e32, I9(buf, n),
+	   P_V(VR_DATA1), P_I(0), P_V(VR_DATA1));
+
+	/* DATA0 (bytes 0-3): always valid (ESP 4-byte alignment) */
+
+	/* bswap each dword for GHASH (big-endian GF arithmetic) */
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA0), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA1), P_V(VR_DATA1), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA2), P_V(VR_DATA2), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_DATA3),
+	   P_V(VR_DATA3), P_V(VR_DATA3), P_S(SR_BSWAP));
+
+	patch_branch(buf, br_skip_ctext, n);
+	_E(emit_gfx9_s_mov_b64, I9(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+	/* ---- Len block: tid == nblocks + 1 ---- */
+	/* Compute nblocks+1 in s42 (scratch) */
+	_E(emit_gfx9_s_add_u32, I9(buf, n), P_S(42), P_I(1),
+	   P_S(SR_NBLOCKS_GCM));
+	_E(emit_gfx9_v_cmp_eq_u32, I9(buf, n), P_S(42),
+	   P_V(VR_TID));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_GHASH_EXEC,
+	   106 /* VCC */);
+	br_skip_len = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	/* Length block format (GCM big-endian):
+	 *   DATA0 = AAD_bits[63:32] = 0
+	 *   DATA1 = AAD_bits[31:0]  = 64  (8 bytes AAD x 8)
+	 *   DATA2 = ctext_bits[63:32] = 0
+	 *   DATA3 = ctext_bits[31:0] = ctext_len * 8
+	 *
+	 * No bswap32: length values are computed integers already
+	 * in the correct big-endian register representation.
+	 * bswap32 is only needed for data loaded from LE memory.
+	 */
+	/* DATA0, DATA2 already 0 from default init */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1),
+	   P_L(0x00000040u));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA3),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_DATA3), P_I(3),
+	   P_V(VR_DATA3));
+
+	patch_branch(buf, br_skip_len, n);
+	_E(emit_gfx9_s_mov_b64, I9(buf, n), 126 /* EXEC */,
+	   SR_GHASH_EXEC);
+
+	/* H-table data was prefetched before data selection; drain + bswap */
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_D0),
+	   P_V(VR_D0), P_V(VR_D0), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_D1),
+	   P_V(VR_D1), P_V(VR_D1), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_D2),
+	   P_V(VR_D2), P_V(VR_D2), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_D3),
+	   P_V(VR_D3), P_V(VR_D3), P_S(SR_BSWAP));
+
+	/* ---- GF(2^128) multiply: Z = DATA * H^k ---- */
+	n = emit_gfmul_128_gfx9(buf, n);
+	/* Result in v[VR_S0:VR_S3] */
+
+	/* ---- Tree reduction via LDS XOR (8 levels for 256 threads) ---- */
+	/* Write v[VR_S0:VR_S3] to LDS at tid * 16 */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_ADDR), P_I(4),
+	   P_V(VR_TID));
+	_E(emit_gfx9_ds_write_b128, I9(buf, n), VR_ADDR, VR_S0);
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+	_E(emit_gfx9_s_barrier, I9(buf, n));
+
+	for (level = 1; level <= 128; level <<= 1) {
+		int br_skip;
+
+		/* if (tid & level) skip */
+		_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(VR_TMP),
+		   P_L(level), P_V(VR_TID));
+		_E(emit_gfx9_v_cmp_eq_u32, I9(buf, n), P_I(0), P_V(VR_TMP));
+		_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_GHASH_EXEC,
+		   106 /* VCC */);
+		br_skip = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+		/* Compute both addresses up front */
+		_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_TMP),
+		   P_L(level), P_V(VR_TID));
+		_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_TMP),
+		   P_I(4), P_V(VR_TMP));
+		_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_ADDR),
+		   P_I(4), P_V(VR_TID));
+
+		/* Issue both reads, single wait */
+		_E(emit_gfx9_ds_read_b128, I9(buf, n), VR_D0, VR_TMP);
+		_E(emit_gfx9_ds_read_b128, I9(buf, n), VR_S0, VR_ADDR);
+		_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+
+		/* XOR */
+		_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S0),
+		   P_V(VR_S0), P_V(VR_D0));
+		_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S1),
+		   P_V(VR_S1), P_V(VR_D1));
+		_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S2),
+		   P_V(VR_S2), P_V(VR_D2));
+		_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S3),
+		   P_V(VR_S3), P_V(VR_D3));
+
+		/* Write back */
+		_E(emit_gfx9_ds_write_b128, I9(buf, n), VR_ADDR, VR_S0);
+		_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+
+		patch_branch(buf, br_skip, n);
+		/* Restore EXEC */
+		_E(emit_gfx9_s_mov_b64, I9(buf, n), 126 /* EXEC */,
+		   SR_GHASH_EXEC);
+		_E(emit_gfx9_s_barrier, I9(buf, n));
+	}
+
+	/* Thread 0 now has the final GHASH in LDS[0..15]. Read it. */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_TMP), P_I(0));
+	_E(emit_gfx9_ds_read_b128, I9(buf, n), VR_S0, VR_TMP);
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+
+	/* ================================================================
+	 * Phase 9: ICV verify (thread 0 only)
+	 *
+	 * computed_tag = bswap(GHASH) XOR AES(K, J0)
+	 * received_tag = last 16 bytes of ESP packet
+	 * ================================================================
+	 */
+	_E(emit_gfx9_v_cmp_eq_u32, I9(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_EXEC_SAVE, 106);
+	br_tid0 = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	/* bswap GHASH from big-endian to little-endian */
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_S0), P_V(VR_S0),
+	   P_V(VR_S0), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_S1), P_V(VR_S1),
+	   P_V(VR_S1), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_S2), P_V(VR_S2),
+	   P_V(VR_S2), P_S(SR_BSWAP));
+	_E(emit_gfx9_v_perm_b32, I9(buf, n), P_V(VR_S3), P_V(VR_S3),
+	   P_V(VR_S3), P_S(SR_BSWAP));
+
+	/* computed_tag = GHASH XOR AES(K, J0) */
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S0),
+	   P_V(VR_S0), P_V(VR_J0_0));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S1),
+	   P_V(VR_S1), P_V(VR_J0_1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S2),
+	   P_V(VR_S2), P_V(VR_J0_2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_S3),
+	   P_V(VR_S3), P_V(VR_J0_3));
+
+	/* Load received ICV: pkt + pkt_len - 16 */
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFF0u), P_V(VR_SAVE_PKTLEN)); /* pkt_len - 16 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_PKT_HI));
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Compare: XOR each dword, OR together; if any non-zero -> fail */
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_S0));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_DATA1), P_V(VR_S1));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_DATA2),
+	   P_V(VR_DATA2), P_V(VR_S2));
+	_E(emit_gfx9_v_xor_b32_e32, I9(buf, n), P_V(VR_DATA3),
+	   P_V(VR_DATA3), P_V(VR_S3));
+	_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA1));
+	_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA2));
+	_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_DATA0), P_V(VR_DATA3));
+
+	/* If VR_DATA0 != 0 -> ICV fail: overwrite verdict with sentinel */
+	_E(emit_gfx9_v_cmp_ne_u32, I9(buf, n), P_I(0), P_V(VR_DATA0));
+	br_icv_ok = _BR(emit_gfx9_s_cbranch_vccz, I9(buf, n), 0);
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_SAVE_SLOT),
+	   P_L(VERDICT_ICV_FAIL));
+	patch_branch(buf, br_icv_ok, n);
+
+	/* ================================================================
+	 * Phase 10: ESP trailer strip + write verdict (thread 0)
+	 *
+	 * Decrypted tail: pad_len at out + ctext_len - 2
+	 *                 next_hdr at out + ctext_len - 1
+	 * inner_len = ctext_len - pad_len - 2
+	 * ================================================================
+	 */
+	/* Only strip if ICV passed (slot < NR_SA) */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 27, VR_SAVE_SLOT);
+	_E(emit_gfx9_s_cmp_ge_u32, I9(buf, n), P_S(27),
+	   P_L(KNOD_IPSEC_SHADER_NR_SA));
+	br_icv_bad = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	/* Load last 4 bytes of decrypted payload: out + ctext_len - 4.
+	 * VOP2 src1 must be VGPR, so move SGPR to VR_TMP first.
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_TMP),
+	   P_S(SR_CTEXT_LEN));
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_TMP),
+	   P_L(0xFFFFFFFC), P_V(VR_TMP)); /* ctext_len - 4 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_OUT_HI));
+	_E(emit_gfx9_global_load_dword, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_GA_LO), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* On LE: loaded dword has byte layout [b0,b1,b2,b3].
+	 * We loaded from (ctext_len - 4), so:
+	 *   b2 = pad_len (at ctext_len - 2)
+	 *   b3 = next_hdr (at ctext_len - 1)
+	 * pad_len = (dword >> 16) & 0xFF
+	 */
+	_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(VR_TMP),
+	   P_I(16), P_V(VR_DATA0));
+	_E(emit_gfx9_v_and_b32_e32, I9(buf, n), P_V(VR_TMP),
+	   P_L(0xFF), P_V(VR_TMP));
+
+	/* inner_len = ctext_len - pad_len - 2 */
+	_E(emit_gfx9_v_sub_u32, I9(buf, n), P_V(VR_DATA1),
+	   P_S(SR_CTEXT_LEN), P_V(VR_TMP));
+	_E(emit_gfx9_v_add_u32, I9(buf, n), P_V(VR_DATA1),
+	   P_L(0xFFFFFFFE), P_V(VR_DATA1)); /* -2 */
+
+	/* Write bd->len = inner_len (u16 at bd + 18) */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_L(18), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx9_global_store_short, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA1), 0);
+
+	/* Write bd->off = mode | (next_hdr << 8) (u16 at bd + 16).
+	 * next_hdr = byte[3] of the ESP trailer dword (VR_DATA0).
+	 * mode from s[SR_SA_MODE].
+	 */
+	_E(emit_gfx9_v_lshrrev_b32, I9(buf, n), P_V(VR_TMP),
+	   P_I(24), P_V(VR_DATA0));
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n), P_V(VR_TMP),
+	   P_I(8), P_V(VR_TMP));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA2),
+	   P_S(SR_SA_MODE));
+	_E(emit_gfx9_v_or_b32_e32, I9(buf, n), P_V(VR_TMP),
+	   P_V(VR_DATA2), P_V(VR_TMP));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_L(16), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx9_global_store_short, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_TMP), 0);
+
+	/* Per-SA GPU stats: atomically increment rx_packets
+	 * and rx_bytes at stats_addr. VR_DATA1 still holds
+	 * inner_len from the bd->len computation above.
+	 *
+	 * global_atomic_add_x2 uses v[data:data+1] as u64.
+	 * Save inner_len to VR_TMP before clobbering DATA1.
+	 *
+	 * stats layout (knod_ipsec_sa_gpu_stats):
+	 *   +0: rx_packets (u64, LE)
+	 *   +8: rx_bytes   (u64, LE)
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_TMP),
+	   P_V(VR_DATA1));	/* save inner_len */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_SAVE_STATS_LO));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_GA_HI),
+	   P_V(VR_SAVE_STATS_HI));
+
+	/* rx_packets += 1: v[DATA0:DATA1] = {1, 0} */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0), P_I(1));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1), P_I(0));
+	_E(emit_gfx9_global_atomic_add_x2, I9(buf, n),
+	   P_V(VR_DATA2), P_V(VR_GA_LO), P_V(VR_DATA0), 0, 0);
+
+	/* rx_bytes += inner_len: v[DATA0:DATA1] = {inner_len, 0} */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_V(VR_TMP));
+	/* DATA1 already 0 from above */
+	_E(emit_gfx9_global_atomic_add_x2, I9(buf, n),
+	   P_V(VR_DATA2), P_V(VR_GA_LO), P_V(VR_DATA0), 8, 0);
+
+	/* ================================================================
+	 * L3 header passthrough (transport mode only).
+	 *
+	 * Copy 20 B of the outer IPv4 L3 header from
+	 * pkt + 14 (skip ETH) to out_addr - 20. In shader-GTT
+	 * direct mode (knod_ipsec_sdma=0), out_addr - 20 is
+	 * pass_buf_slot + 0 so the host-side finalise can skip
+	 * the per-packet L3 SDMA copy entirely - the only
+	 * remaining SDMA call on the transport IPv4 fast path.
+	 *
+	 * Tunnel-mode SAs (SR_SA_MODE != 0) skip this write
+	 * because for tunnel the destination at slot+0 wants
+	 * the *inner* packet, not an outer IP header.
+	 *
+	 * The VRAM staging path (knod_ipsec_sdma=1) also runs
+	 * this copy, but the destination is the 20-byte
+	 * headroom knod_ipsec.c reserves at the front of
+	 * the decrypt pool; CPU finalise still SDMAs the real
+	 * L3 header from the raw packet into the GTT pass_buf
+	 * so the shader's write is harmless wasted work.
+	 *
+	 * Alignment: pkt + 14 is only 2-byte aligned (ETH hdr
+	 * = 14 bytes != 4-byte multiple), so dword / dwordx4
+	 * loads would fault. Use 10 x global_load_ushort at
+	 * offsets 14,16,...,32, paired with 10 x store_short
+	 * at slot + 0,2,...,18. 10 scratch VGPRs (v14..v23),
+	 * all free by Phase 10 since AES-GCM / GHASH state is
+	 * done. One waitcnt between loads and stores.
+	 * ================================================================
+	 */
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n),
+	   P_S(SR_SA_MODE), P_I(0));
+	br_not_transport = _BR(emit_gfx9_s_cbranch_scc0,
+			       I9(buf, n), 0);
+
+	/* src = pkt_addr + 14 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n),
+	   P_V(VR_GA_LO), P_I(14),
+	   P_V(VR_SAVE_PKT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n),
+	   P_V(VR_GA_HI), P_I(0),
+	   P_V(VR_SAVE_PKT_HI));
+
+	/* 10 x 2-byte loads from src+0..+18 */
+	for (li = 0; li < 10; li++) {
+		_E(emit_gfx9_global_load_ushort,
+		   I9(buf, n),
+		   P_V(L3_TMP_BASE + li),
+		   P_V(VR_GA_LO), li * 2);
+	}
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* dst = out_addr - 20.
+	 *
+	 * Two GFX9 landmines here:
+	 *
+	 *  1. v_add_co_u32 can't take a 32-bit
+	 *     literal src together with implicit VCC
+	 *     - same class as the v_cndmask literal
+	 *     restriction.
+	 *  2. P_I(n) is a raw initializer that always
+	 *     sets type=INTEGER_0 and stores n in .v.
+	 *     For negative inline constants the
+	 *     encoder must flip to INTEGER_MINUS_1
+	 *     with v=~n, which P_I does NOT do.
+	 *     P_I(-1) therefore encodes as
+	 *     GFX9_SRC_INTEGER_0 + (-1) = 127, a
+	 *     bogus register that gave us random
+	 *     high-32 bits and page-faulted stores.
+	 *
+	 * Dodge both by materialising -20 into VR_TMP
+	 * and -1 into VR_TMP2 via v_mov_b32 literals
+	 * (VOP1, no VCC, literals fine), then pure
+	 * VGPR+VGPR add_co / addc_co. Borrow flows
+	 * through VCC as the carry-in to addc_co.
+	 */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n),
+	   P_V(VR_TMP), P_L(0xFFFFFFECu));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n),
+	   P_V(VR_TMP2), P_L(0xFFFFFFFFu));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n),
+	   P_V(VR_GA_LO),
+	   P_V(VR_TMP), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n),
+	   P_V(VR_GA_HI),
+	   P_V(VR_TMP2), P_V(VR_SAVE_OUT_HI));
+
+	/* 10 x 2-byte stores to dst+0..+18 */
+	for (li = 0; li < 10; li++) {
+		_E(emit_gfx9_global_store_short,
+		   I9(buf, n),
+		   P_V(VR_GA_LO),
+		   P_V(L3_TMP_BASE + li),
+		   li * 2);
+	}
+
+	patch_branch(buf, br_not_transport, n);
+
+	patch_branch(buf, br_icv_bad, n);
+
+	/* Write bd->act (u64 at bd + 8):
+	 * high32 = slot_idx (or sentinel),
+	 * low32 = KNOD_IPSEC_INFLIGHT so NIC NAPI recognises
+	 * this slot as in-flight until the finish worker stamps
+	 * the final PASS/DROP.
+	 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_L(8), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_L(KNOD_IPSEC_INFLIGHT));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SLOT));
+	_E(emit_gfx9_global_store_dwordx2, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA0), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	patch_branch(buf, br_tid0, n);
+
+	/* ================================================================
+	 * Phase 11: Miss/bypass path verdict - thread 0 only
+	 *
+	 * If we skipped crypto (Phase 2 branch), write the miss/bypass
+	 * sentinel that's still in v[VR_SAVE_SLOT].
+	 * ================================================================
+	 */
+	br_crypto_done = _BR(emit_gfx9_s_branch, I9(buf, n), 0);
+
+	patch_branch(buf, br_crypto_end, n);
+
+	/* Thread 0 writes bd->act with miss/bypass sentinel */
+	_E(emit_gfx9_v_cmp_eq_u32, I9(buf, n), P_I(0), P_V(VR_TID));
+	_E(emit_gfx9_s_and_saveexec_b64, I9(buf, n), SR_EXEC_SAVE, 106);
+
+	br_execz2 = _BR(emit_gfx9_s_cbranch_execz, I9(buf, n), 0);
+
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n), P_V(VR_GA_LO),
+	   P_L(8), P_V(VR_SAVE_BD_LO));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n), P_V(VR_GA_HI),
+	   P_I(0), P_V(VR_SAVE_BD_HI));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA0),
+	   P_L(KNOD_IPSEC_INFLIGHT));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(VR_DATA1),
+	   P_V(VR_SAVE_SLOT));
+	_E(emit_gfx9_global_store_dwordx2, I9(buf, n), P_V(VR_GA_LO),
+	   P_V(VR_DATA0), 0);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	patch_branch(buf, br_execz2, n);
+
+	patch_branch(buf, br_crypto_done, n);
+
+	/* ================================================================
+	 * Phase 12: GPU-initiated SDMA dispatch (thread 0 only)
+	 *
+	 * Both merge paths (crypto-done, bypass/miss) arrive here with
+	 * EXEC restricted to lane 0 of wave 0; waves 1-3 have EXEC=0.
+	 * Scalar instructions fire on every wave but are side-effect-free;
+	 * vector memory ops are NOPs when EXEC=0.
+	 *
+	 * The GPU writes SDMA COPY_LINEAR packets only.  FENCE, wptr
+	 * update, and doorbell are left to the CPU - this avoids a race
+	 * where a GPU-emitted FENCE would prematurely satisfy the CPU
+	 * fence poll before CPU-added SDMA copies (e.g. IPv6 transport
+	 * L3 header) complete.
+	 *
+	 * Protocol per work-group (= per packet):
+	 *  1. Load sdma_ring_addr (kernarg+16) and sdma_ctl_addr (+32).
+	 *  2. If sdma_ctl_addr == 0, gpu_sdma disabled - skip.
+	 *  3. Load sdma_ctl fields (wptr_base_dw, ring_mask, etc.).
+	 *  4. If verdict is MISS/BYPASS, claim a ring slot via
+	 *     atomic_add(&claim_counter) and write a 7-dword
+	 *     SDMA COPY_LINEAR packet.
+	 *  5. ALL WGs atomic_add(&done_counter).
+	 *  6. Last WG: read final claim_counter, store
+	 *     final_sdma_count + gpu_sdma_ready for CPU.
+	 * ================================================================
+	 */
+	/* --- kernarg loads ---------------------------------------- */
+	_E(emit_gfx9_s_load_dwordx2, I9(buf, n),
+	   P_S(24), P_S(8), 16);		/* s[24:25] = sdma_ring_addr */
+	_E(emit_gfx9_s_load_dwordx2, I9(buf, n),
+	   P_S(26), P_S(8), 32);		/* s[26:27] = sdma_ctl_addr */
+	_E(emit_gfx9_s_waitcnt_lgkmcnt, I9(buf, n));
+
+	/* Skip Phase 12 entirely if sdma_ctl_addr == 0 */
+	_E(emit_gfx9_s_or_b32, I9(buf, n), 28, 26, 27);
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n), P_S(28), P_I(0));
+	br_no_sdma = _BR(emit_gfx9_s_cbranch_scc1, I9(buf, n), 0);
+
+	/* --- load sdma_ctl into VGPRs ----------------------------- */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(1), P_S(26));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(2), P_S(27));
+
+	/* ctl+28: wptr_base_dw(4) ring_mask(4) nr_total_wg(4) copy_hdr(4)
+	 * -> v[3:6]
+	 */
+	_E(emit_gfx9_global_load_dwordx4, I9(buf, n),
+	   P_V(3), P_V(1), 28);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* v3=wptr_base_dw  v4=ring_mask  v5=nr_total_wg  v6=copy_hdr */
+
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n),
+	   28, 5);				/* s28 = nr_total_wg */
+
+	/* --- verdict check ---------------------------------------- */
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n),
+	   29, VR_SAVE_SLOT);			/* s29 = verdict */
+	_E(emit_gfx9_s_cmp_ge_u32, I9(buf, n),
+	   P_S(29), P_L(0xFFFFFFFEu));		/* MISS|BYPASS? */
+	br_no_copy = _BR(emit_gfx9_s_cbranch_scc0, I9(buf, n), 0);
+
+	/* === This WG needs SDMA copy === */
+
+	/* atomic_add(&ctl->claim_counter, 1, GLC=1) -> my_idx */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx9_global_atomic_add, I9(buf, n),
+	   P_V(7), P_V(1), P_V(7), 0, 1);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+	/* v7 = my_idx (old claim_counter) */
+
+	/* ring dword position: (wptr_base_dw + my_idx*7) & ring_mask */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n),
+	   P_V(8), P_I(3), P_V(7));		/* my_idx * 8 */
+	_E(emit_gfx9_v_sub_u32, I9(buf, n),
+	   P_V(8), P_V(8), P_V(7));		/* my_idx * 7 */
+	_E(emit_gfx9_v_add_u32, I9(buf, n),
+	   P_V(8), P_V(3), P_V(8));		/* + wptr_base_dw */
+	_E(emit_gfx9_v_and_b32_e32, I9(buf, n),
+	   P_V(8), P_V(4), P_V(8));		/* & ring_mask */
+	_E(emit_gfx9_v_lshlrev_b32, I9(buf, n),
+	   P_V(8), P_I(2), P_V(8));		/* * 4 -> byte offset */
+
+	/* v[9:10] = sdma_ring_addr + byte_offset */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(14), P_S(25));
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n),
+	   P_V(9), P_S(24), P_V(8));
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n),
+	   P_V(10), P_I(0), P_V(14));
+
+	/* DW0: copy_hdr */
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(6), 0);
+
+	/* DW1: nbytes - 1 */
+	_E(emit_gfx9_v_add_u32, I9(buf, n),
+	   P_V(14), P_L(0xFFFFFFFFu), P_V(VR_SAVE_PKTLEN));
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(14), 4);
+
+	/* DW2: 0 (sub-op parameter) */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(14), P_I(0));
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(14), 8);
+
+	/* DW3-4: src = pkt_addr (VRAM) */
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(VR_SAVE_PKT_LO), 12);
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(VR_SAVE_PKT_HI), 16);
+
+	/* DW5-6: dst = out_addr - 20 (GTT slot start) */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n),
+	   P_V(14), P_L(0xFFFFFFECu));		/* -20 */
+	_E(emit_gfx9_v_add_co_u32, I9(buf, n),
+	   P_V(15), P_V(14), P_V(VR_SAVE_OUT_LO));
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n),
+	   P_V(14), P_L(0xFFFFFFFFu));		/* -1 */
+	_E(emit_gfx9_v_addc_co_u32, I9(buf, n),
+	   P_V(16), P_V(14), P_V(VR_SAVE_OUT_HI));
+
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(15), 20);
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(9), P_V(16), 24);
+
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* --- done counter (all WGs) ------------------------------- */
+	patch_branch(buf, br_no_copy, n);
+
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx9_global_atomic_add, I9(buf, n),
+	   P_V(7), P_V(1), P_V(7), 4, 1);	/* ctl+4 = done_counter */
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Last WG check: my_done + 1 == nr_total_wg? */
+	_E(emit_gfx9_v_add_u32, I9(buf, n),
+	   P_V(7), P_I(1), P_V(7));
+	_E(emit_gfx9_v_readfirstlane_b32, I9(buf, n), 29, 7);
+	_E(emit_gfx9_s_cmp_eq_u32, I9(buf, n), P_S(29), P_S(28));
+	br_not_last = _BR(emit_gfx9_s_cbranch_scc0, I9(buf, n), 0);
+
+	/* === Last WG - publish counters for CPU === */
+
+	/* Read final claim_counter (atomic add 0, GLC=1) */
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(7), P_I(0));
+	_E(emit_gfx9_global_atomic_add, I9(buf, n),
+	   P_V(7), P_V(1), P_V(7), 0, 1);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	/* Store final_sdma_count (ctl+52) and gpu_sdma_ready (ctl+48) */
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(1), P_V(7), 52);
+	_E(emit_gfx9_v_mov_b32_e32, I9(buf, n), P_V(7), P_I(1));
+	_E(emit_gfx9_global_store_dword, I9(buf, n),
+	   P_V(1), P_V(7), 48);
+	_E(emit_gfx9_s_waitcnt_vmcnt, I9(buf, n));
+
+	patch_branch(buf, br_not_last, n);
+	patch_branch(buf, br_no_sdma, n);
+
+	_E(emit_gfx9_s_endpgm, I9(buf, n));
+
+	return n * 4;
+}
+
+#endif /* KNOD_HELPERS_IPSEC_FUSED_GFX9_H_ */
diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.c b/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.c
new file mode 100644
index 000000000000..f67e7e4299f2
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.c
@@ -0,0 +1,4273 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+/*
+ * KNOD IPsec (xfrm) full-packet GPU offload.
+ *
+ * Accepts xfrm SAs configured with XFRM_DEV_OFFLOAD_PACKET and runs
+ * ESP parse / SA lookup / AES-GCM decrypt on the GPU. Anti-replay is
+ * handled CPU-side in the NIC dd NAPI (see knod_ipsec_sa_window_check)
+ * after the finish worker has SDMA-copied decrypted inner packets into
+ * the per-queue framework delivery pool (pass_pool). Control plane allocates
+ * per-SA key and GHASH H-power tables in VRAM (via the AES-GCM helpers below)
+ * and mirrors SA state into a GPU-visible SA table consumed by the
+ * fused RX shader.
+ *
+ * RX path: the GPU shader decrypts in place in VRAM and flags per-packet
+ * verdicts (ICV ok / malformed / no SA). A CPU finish worker then SDMA-
+ * bulk-copies successfully decrypted inner packets into per-queue host pages
+ * from the framework delivery pool (pass_pool, page_pool-backed) and pushes
+ * a knod_pass_desc onto the framework per-queue pass_pending ring. The NIC
+ * dd drains that ring from its own NAPI (knod_d2h_drain), which builds the
+ * zero-copy head_frag skb (knod_pass_build_skb) and runs the ipsec
+ * finalisation hook (knod_ipsec_post_copy): RFC 4303 sliding-window
+ * anti-replay, cleartext L3 fix-up and secpath attach. The page recycles
+ * to the pool on skb free.
+ *
+ * The original p2pdma bd ring is only used for NIC netmem lifecycle /
+ * recycle and is completely decoupled from verdict delivery.
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/jump_label.h>
+#include <linux/xarray.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/percpu.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/ip.h>
+#include <net/dst.h>
+#include <net/neighbour.h>
+#include <net/xfrm.h>
+#include <net/page_pool/helpers.h>
+#include <net/esp.h>
+#include <net/gso.h>
+#include <net/knod.h>
+#include <linux/random.h>
+#include <linux/unaligned.h>
+#include <crypto/aes.h>
+#include <linux/bitops.h>
+#include <linux/string.h>
+#include <drm/ttm/ttm_tt.h>
+
+#include "kfd_priv.h"
+#include "kfd_hsa.h"
+#include "kfd_knod.h"
+#include "knod_ipsec.h"
+#include "ipsec_fused_gfx9.h"
+#include "ipsec_fused_gfx10.h"
+
+/* ====================================================================
+ * AES-GCM core helpers: AES T-tables in VRAM and GHASH H-power table
+ * precomputation.  IPsec ESP is the only KNOD GCM consumer, so these
+ * live here rather than in the always-builtin KNOD core.
+ * ====================================================================
+ */
+
+/* AES T-tables: 4 tables * 256 entries * 4 bytes = 4KB, laid out as
+ * T0 | T1 | T2 | T3 in a single VRAM page.
+ */
+#define KNOD_GCM_T_TABLE_SIZE		(256 * sizeof(u32))
+#define KNOD_GCM_T_TABLE_COUNT		4
+#define KNOD_GCM_T_TABLES_TOTAL		\
+	(KNOD_GCM_T_TABLE_SIZE * KNOD_GCM_T_TABLE_COUNT)
+
+/* GHASH H-power table: H^1 .. H^256, each 16 bytes. */
+#define KNOD_GCM_H_POWER_COUNT		256
+#define KNOD_GCM_H_POWER_SIZE		16
+#define KNOD_GCM_H_TABLE_SIZE		\
+	(KNOD_GCM_H_POWER_COUNT * KNOD_GCM_H_POWER_SIZE)
+
+static struct knod_mem *knod_gcm_alloc_tables(struct knod *knod)
+{
+	struct knod_mem *tables;
+	u32 *p;
+	int i;
+
+	tables = knod_alloc_mem(knod, PAGE_SIZE, KFD_IOC_ALLOC_MEM_FLAGS_VRAM);
+	if (IS_ERR(tables))
+		return tables;
+
+	p = (u32 *)tables->kaddr;
+
+	/*
+	 * Four rotated versions of aes_enc_tab matching the kernel
+	 * enc_quarterround() convention (lib/crypto/aes.c):
+	 *   T0[x] = aes_enc_tab[x]
+	 *   Tk[x] = rol32(T0[x], k * 8)
+	 * The GPU shader performs one AES round as four table lookups and
+	 * four XORs per column.
+	 */
+	for (i = 0; i < 256; i++)
+		p[i] = aes_enc_tab[i];
+	for (i = 0; i < 256; i++)
+		p[256 + i] = rol32(aes_enc_tab[i], 8);
+	for (i = 0; i < 256; i++)
+		p[512 + i] = rol32(aes_enc_tab[i], 16);
+	for (i = 0; i < 256; i++)
+		p[768 + i] = rol32(aes_enc_tab[i], 24);
+
+	return tables;
+}
+
+static void knod_gcm_free_tables(struct knod *knod, struct knod_mem *tables)
+{
+	if (tables)
+		knod_free_mem(knod, tables);
+}
+
+/*
+ * Multiply a by b in GF(2^128) with the GCM polynomial
+ *   x^128 + x^7 + x^2 + x + 1
+ * Both inputs and the output are stored as two big-endian u64.
+ */
+static void gf128_mul(u64 r[2], const u64 a[2], const u64 b[2])
+{
+	u64 v[2], z[2];
+	int i, j;
+
+	v[0] = a[0];
+	v[1] = a[1];
+	z[0] = 0;
+	z[1] = 0;
+
+	for (i = 0; i < 2; i++) {
+		u64 x = b[i];
+
+		for (j = 63; j >= 0; j--) {
+			if ((x >> j) & 1) {
+				z[0] ^= v[0];
+				z[1] ^= v[1];
+			}
+
+			/* v >>= 1 (128-bit) with GCM reduction */
+			if (v[1] & 1) {
+				v[1] = (v[1] >> 1) | (v[0] << 63);
+				v[0] = (v[0] >> 1) ^ ((u64)0xe1 << 56);
+			} else {
+				v[1] = (v[1] >> 1) | (v[0] << 63);
+				v[0] = v[0] >> 1;
+			}
+		}
+	}
+
+	r[0] = z[0];
+	r[1] = z[1];
+}
+
+static void knod_gcm_precompute_h_table(const u8 *key, int key_len,
+					u8 *h_table_buf)
+{
+	struct aes_enckey enc_key;
+	u8 h_block[AES_BLOCK_SIZE] = {};
+	u64 h[2], h_power[2];
+	int i;
+
+	/* H = AES_K(0^128) */
+	aes_prepareenckey(&enc_key, key, key_len);
+	aes_encrypt(&enc_key, h_block, h_block);
+
+	h[0] = get_unaligned_be64(h_block);
+	h[1] = get_unaligned_be64(h_block + 8);
+
+	/* H^1 = H, then H^(i+1) = H^i * H */
+	h_power[0] = h[0];
+	h_power[1] = h[1];
+
+	for (i = 0; i < KNOD_GCM_H_POWER_COUNT; i++) {
+		u64 next[2];
+
+		put_unaligned_be64(h_power[0],
+				   h_table_buf + i * KNOD_GCM_H_POWER_SIZE);
+		put_unaligned_be64(h_power[1],
+				   h_table_buf + i * KNOD_GCM_H_POWER_SIZE + 8);
+
+		gf128_mul(next, h_power, h);
+		h_power[0] = next[0];
+		h_power[1] = next[1];
+	}
+
+	memzero_explicit(&enc_key, sizeof(enc_key));
+	memzero_explicit(h_block, sizeof(h_block));
+}
+
+/* Single AQL queue on purpose: CPU parallelism is provided by per-queue
+ * double-buffering through `nr_aql_ring` slots inside this one queue, not
+ * by multiple AQL queues. Multiple AQL queues cause ordering / contention
+ * issues with the fused RX dispatch path - stick to one.
+ */
+/*
+ * Dispatcher idle strategy toggle. Exposed as a debugfs toggle
+ * (knod_ipsec/poll) so it can be flipped mid-run without reloading
+ * the module and without the sysfs-module-param discoverability cost.
+ *
+ * - poll_mode=false (default): when try_rx finds no work,
+ *   sleep via usleep_range(20, 100). Lets the CPU idle but adds up to
+ *   ~100us latency between a packet landing in the SPSC ring and the
+ *   dispatcher picking it up.
+ *
+ * - poll_mode=true: busy-poll with cpu_relax() instead of sleeping. Pins
+ *   one CPU core at 100% even when no traffic is flowing, but removes
+ *   the handoff latency entirely.
+ *
+ * GPU completion wait (knod_ipsec_dispatch_and_wait) is always polled -
+ * this switch only affects the between-dispatch idle path.
+ */
+static bool knod_ipsec_poll_mode;
+
+/*
+ * RX decrypt output: the shader decrypts ESP payloads into a per-work VRAM
+ * output buffer; the finish worker SDMA-copies the result into a framework
+ * delivery-pool page.  For BYPASS/MISS traffic, the shader's Phase 12 writes
+ * SDMA COPY_LINEAR packets directly into the SDMA ring, and the CPU only adds
+ * FENCE + doorbell.
+ */
+
+/*
+ * Parallel RX dispatcher count. Each dispatcher gets its own kaql
+ * AQL queue on the GPU, its own SDMA queue for finalise copies, its
+ * own work_pool slice and pool BOs, and an exclusive contiguous range
+ * of NIC RX queues. Two dispatchers running on kaql[0] and
+ * kaql[1] can execute dispatches in true parallel on disjoint CU
+ * slices, which is the only way to break the single-kaql FIFO
+ * throughput ceiling observed at ~60 Gbps (UDP) / ~41 Gbps (TCP) on
+ * the current test rig.
+ *
+ * The number must be fixed at module_init time because it drives
+ * knod_alloc_ctx() which creates the kaql[]/sdma[] pairs when NOD
+ * attaches. Hot-path code reads priv->nr_dispatchers which is
+ * initialised from priv->knod->queue_cnt.
+ *
+ * Load-time only (0444) - flipping between 1 and N at runtime would
+ * require tearing down / re-creating the knod context, which means
+ * unbinding NOD on the NIC. Reload the module instead.
+ */
+static int nr_dispatch = 1;
+module_param(nr_dispatch, int, 0444);
+MODULE_PARM_DESC(nr_dispatch,
+		 "Number of parallel KNOD IPsec dispatchers (1..4, default: 1). Each runs on its own AQL queue for real GPU parallelism.");
+
+static DEFINE_STATIC_KEY_FALSE(ipsec_stats_enabled_key);
+
+#define IPSEC_STAT_INC(s, field) do {					\
+	if (static_branch_unlikely(&ipsec_stats_enabled_key))		\
+		this_cpu_inc((s)->field);				\
+} while (0)
+#define IPSEC_STAT_ADD(s, field, val) do {				\
+	if (static_branch_unlikely(&ipsec_stats_enabled_key))		\
+		this_cpu_add((s)->field, (val));			\
+} while (0)
+
+static struct knod_ipsec_priv *ipsec_priv;
+
+static int knod_ipsec_nod_init(struct knod_dev *knodev);
+static void knod_ipsec_nod_exit(struct knod_dev *knodev);
+static bool knod_ipsec_post_copy(struct knod_dev *knodev, struct sk_buff *skb,
+				 const struct knod_pass_desc *desc,
+				 int queue_idx);
+static int knod_ipsec_init_shader_gfx9(struct knod *knod);
+static int knod_ipsec_init_shader_gfx10(struct knod *knod);
+static int knod_ipsec_work_pool_alloc(struct knod_ipsec_priv *priv);
+static void knod_ipsec_work_pool_free(struct knod_ipsec_priv *priv);
+static int knod_ipsec_dispatcher(void *arg);
+static void knod_ipsec_dispatcher_drain(struct knod_ipsec_dispatcher *disp);
+static int knod_ipsec_disp_create_all(struct knod_ipsec_priv *priv);
+static void knod_ipsec_disp_destroy_all(struct knod_ipsec_priv *priv);
+static void knod_ipsec_debugfs_init(struct knod_ipsec_priv *priv);
+static void knod_ipsec_debugfs_exit(struct knod_ipsec_priv *priv);
+
+/* ========================================================================
+ * Slot management
+ * ========================================================================
+ */
+
+static int knod_ipsec_find_free_slot(struct knod_ipsec_priv *priv)
+{
+	int i;
+
+	/*
+	 * Reuse only fully-freed slots (key_mem cleared by state_free); a
+	 * deactivated slot whose free is still pending (an in-flight skb holds
+	 * the xfrm_state) would be memset here, leaking its BOs.
+	 */
+	for (i = 0; i < KNOD_IPSEC_NR_SA; i++) {
+		if (!priv->slots[i].active && !priv->slots[i].key_mem)
+			return i;
+	}
+	return -ENOSPC;
+}
+
+static struct knod_ipsec_sa_slot *
+knod_ipsec_lookup_slot_by_spi(struct knod_ipsec_priv *priv, u32 spi)
+{
+	return xa_load(&priv->spi_to_slot, spi);
+}
+
+/*
+ * Write (or clear) a slot entry into the GPU-visible SA table via the
+ * kernel mapping. SDMA flush is not required - the VRAM mapping used
+ * here is coherent and the shader re-reads per-dispatch.
+ */
+static void knod_ipsec_write_sa_entry(struct knod_ipsec_priv *priv,
+				      int slot_idx,
+				      const struct knod_ipsec_sa_slot *slot,
+				      struct xfrm_state *x)
+{
+	struct knod_ipsec_sa_entry *e;
+	u32 flags = 0;
+
+	e = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr;
+	e += slot_idx;
+	memset(e, 0, sizeof(*e));
+
+	if (!slot || !x) {
+		e->active = cpu_to_le32(0);
+		/* Zero per-SA stats on delete */
+		memset((u8 *)priv->sa_table->kaddr +
+		       KNOD_IPSEC_STATS_REGION_OFF +
+		       slot_idx * KNOD_IPSEC_SA_STATS_SIZE, 0,
+		       KNOD_IPSEC_SA_STATS_SIZE);
+		return;
+	}
+
+	if (x->props.flags & XFRM_STATE_ESN)
+		flags |= 1u << 0;
+
+	/* Store SPI in host byte order (little-endian on this platform).
+	 * The GPU shader byteswaps the raw BE SPI from the packet header
+	 * before comparing, so the table entry must be in the same
+	 * host-order form. cpu_to_le32(be32_to_cpu()) converts BE->host->LE
+	 * which on LE is a no-op for the numeric value.
+	 */
+	e->spi              = cpu_to_le32(be32_to_cpu(x->id.spi));
+	e->dir              = cpu_to_le32(0);
+	e->family           = cpu_to_le32(x->props.family);
+	e->flags            = cpu_to_le32(flags);
+	e->key_gpu_addr     = cpu_to_le64(slot->key_mem ?
+					  slot->key_mem->gaddr : 0);
+	e->htable_gpu_addr  = cpu_to_le64(slot->htable_mem ?
+					  slot->htable_mem->gaddr : 0);
+	e->t_tables_gpu_addr = cpu_to_le64(priv->t_tables ?
+					   priv->t_tables->gaddr : 0);
+	e->replay_bitmap_addr = cpu_to_le64(slot->replay_mem ?
+					    slot->replay_mem->gaddr : 0);
+	e->replay_window    = cpu_to_le32(x->replay_esn ?
+					  x->replay_esn->replay_window : 64);
+
+	if (x->aead) {
+		int key_len = (x->aead->alg_key_len + 7) / 8;
+
+		/* AES-GCM: last 4 bytes of keymat are the salt. */
+		if (key_len >= 4) {
+			memcpy(e->salt,
+			       x->aead->alg_key + key_len - 4, 4);
+			key_len -= 4;
+		}
+		e->key_len = cpu_to_le32(key_len);
+		/* nr_rounds: AES-128->10, AES-192->12, AES-256->14 */
+		e->nr_rounds = cpu_to_le32(6 + key_len / 4);
+	}
+
+	e->mode             = cpu_to_le32(x->props.mode);
+	e->stats_addr       = cpu_to_le64(priv->sa_table->gaddr +
+					   KNOD_IPSEC_STATS_REGION_OFF +
+					   slot_idx * KNOD_IPSEC_SA_STATS_SIZE);
+	/* Zero per-SA stats on (re)key */
+	memset((u8 *)priv->sa_table->kaddr + KNOD_IPSEC_STATS_REGION_OFF +
+	       slot_idx * KNOD_IPSEC_SA_STATS_SIZE, 0,
+	       KNOD_IPSEC_SA_STATS_SIZE);
+	e->version          = cpu_to_le32(slot->version);
+	e->active           = cpu_to_le32(1);
+}
+
+/* ========================================================================
+ * xfrmdev_ops callbacks
+ * ========================================================================
+ */
+
+static int knod_ipsec_xdo_state_add(struct knod_dev *knodev,
+				    struct xfrm_state *x,
+				    struct netlink_ext_ack *extack)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_sa_entry *e_dbg;
+	struct crypto_aes_ctx aes_ctx;
+	struct knod_ipsec_sa_slot *slot;
+	int slot_idx, key_len, err;
+	u32 spi;
+
+	if (!priv || !priv->knod) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: not initialized");
+		return -ENODEV;
+	}
+
+	/* Only support AEAD AES-GCM in packet offload mode. */
+	if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: only packet offload supported");
+		return -EINVAL;
+	}
+	if (x->xso.dir != XFRM_DEV_OFFLOAD_IN) {
+		NL_SET_ERR_MSG(extack,
+			       "knod_ipsec: only inbound (RX decrypt) offload supported");
+		return -EINVAL;
+	}
+	if (!x->aead ||
+	    strcmp(x->aead->alg_name, "rfc4106(gcm(aes))")) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: only rfc4106(gcm(aes)) supported");
+		return -EINVAL;
+	}
+	if (x->id.proto != IPPROTO_ESP) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: only ESP supported");
+		return -EINVAL;
+	}
+
+	key_len = (x->aead->alg_key_len + 7) / 8;
+	if (key_len < 4) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: key too short");
+		return -EINVAL;
+	}
+	key_len -= 4; /* strip salt */
+	if (key_len != 16 && key_len != 24 && key_len != 32) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: unsupported AES key length");
+		return -EINVAL;
+	}
+
+	spi = be32_to_cpu(x->id.spi);
+
+	mutex_lock(&priv->slot_lock);
+
+	if (knod_ipsec_lookup_slot_by_spi(priv, spi)) {
+		mutex_unlock(&priv->slot_lock);
+		NL_SET_ERR_MSG(extack, "knod_ipsec: SPI already offloaded");
+		return -EEXIST;
+	}
+
+	slot_idx = knod_ipsec_find_free_slot(priv);
+	if (slot_idx < 0) {
+		mutex_unlock(&priv->slot_lock);
+		NL_SET_ERR_MSG(extack, "knod_ipsec: SA table full");
+		return -ENOSPC;
+	}
+
+	slot = &priv->slots[slot_idx];
+	memset(slot, 0, sizeof(*slot));
+	slot->slot_idx = slot_idx;
+	slot->spi = spi;
+
+	/* Expanded round key buffer (VRAM). The GPU shader loads round keys
+	 * via s_load_dwordx4 (16 bytes per round), so we expand up front
+	 * rather than shipping raw key material. AES-128 is 176B,
+	 * AES-256 is 240B; a full PAGE_SIZE allocation leaves room and
+	 * avoids the VRAM
+	 * 7-page alloc trap.
+	 */
+	slot->key_mem = knod_alloc_mem(priv->knod, PAGE_SIZE,
+				       KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+				       KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+				       KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+	if (IS_ERR(slot->key_mem)) {
+		err = PTR_ERR(slot->key_mem);
+		slot->key_mem = NULL;
+		goto err_slot;
+	}
+	err = aes_expandkey(&aes_ctx, x->aead->alg_key, key_len);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "knod_ipsec: AES key expand failed");
+		goto err_key;
+	}
+	/* Store the encryption schedule. Nr+1 round keys x 16 bytes.
+	 * The shader reads s[SR_NR_ROUNDS] to know how many rounds.
+	 */
+	memcpy(slot->key_mem->kaddr, aes_ctx.key_enc,
+	       (aes_ctx.key_length / 4 + 7) * 16);
+	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+
+	/* H-power table (VRAM) */
+	slot->htable_mem = knod_alloc_mem(priv->knod, KNOD_GCM_H_TABLE_SIZE,
+					  KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+					  KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+					  KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+	if (IS_ERR(slot->htable_mem)) {
+		err = PTR_ERR(slot->htable_mem);
+		slot->htable_mem = NULL;
+		goto err_key;
+	}
+	knod_gcm_precompute_h_table(x->aead->alg_key, key_len,
+				    (u8 *)slot->htable_mem->kaddr);
+
+	/* Replay bitmap (VRAM) */
+	slot->replay_mem = knod_alloc_mem(priv->knod, PAGE_SIZE,
+					  KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+					  KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+					  KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+	if (IS_ERR(slot->replay_mem)) {
+		err = PTR_ERR(slot->replay_mem);
+		slot->replay_mem = NULL;
+		goto err_htable;
+	}
+	memset(slot->replay_mem->kaddr, 0, PAGE_SIZE);
+
+	slot->x = x;
+	slot->version = 1;
+	slot->active = true;
+
+	knod_ipsec_write_sa_entry(priv, slot_idx, slot, x);
+
+	err = xa_insert(&priv->spi_to_slot, spi, slot, GFP_KERNEL);
+	if (err)
+		goto err_replay;
+
+	x->xso.offload_handle = (unsigned long)slot;
+
+	mutex_unlock(&priv->slot_lock);
+
+	this_cpu_inc(priv->stats->sa_add);
+
+	e_dbg = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr + slot_idx;
+
+	pr_info("knod_ipsec: SA added spi=0x%08x slot=%d dir=%d\n",
+		spi, slot_idx, x->xso.dir);
+	pr_info("  sa_entry: spi_le=0x%08x active=%u nr_rounds=%u key_len=%u\n",
+		le32_to_cpu(e_dbg->spi), le32_to_cpu(e_dbg->active),
+		le32_to_cpu(e_dbg->nr_rounds), le32_to_cpu(e_dbg->key_len));
+	pr_info("  sa_entry: key_addr=0x%llx htable_addr=0x%llx salt=%*ph\n",
+		le64_to_cpu(e_dbg->key_gpu_addr),
+		le64_to_cpu(e_dbg->htable_gpu_addr),
+		4, e_dbg->salt);
+	return 0;
+
+err_replay:
+	knod_free_mem(priv->knod, slot->replay_mem);
+err_htable:
+	knod_free_mem(priv->knod, slot->htable_mem);
+err_key:
+	knod_free_mem(priv->knod, slot->key_mem);
+err_slot:
+	memset(slot, 0, sizeof(*slot));
+	mutex_unlock(&priv->slot_lock);
+	return err;
+}
+
+static void knod_ipsec_xdo_state_delete(struct knod_dev *knodev,
+					struct xfrm_state *x)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_sa_slot *slot;
+	u32 spi;
+
+	if (!priv)
+		return;
+
+	spi = be32_to_cpu(x->id.spi);
+
+	mutex_lock(&priv->slot_lock);
+	slot = knod_ipsec_lookup_slot_by_spi(priv, spi);
+	if (!slot) {
+		mutex_unlock(&priv->slot_lock);
+		return;
+	}
+
+	/* Deactivate first so GPU shaders skip this slot on next dispatch. */
+	slot->active = false;
+	slot->version++;
+	knod_ipsec_write_sa_entry(priv, slot->slot_idx, NULL, NULL);
+
+	xa_erase(&priv->spi_to_slot, spi);
+
+	mutex_unlock(&priv->slot_lock);
+
+	this_cpu_inc(priv->stats->sa_del);
+}
+
+static void knod_ipsec_xdo_state_free(struct knod_dev *knodev,
+				      struct xfrm_state *x)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_sa_slot *slot;
+
+	if (!priv)
+		return;
+
+	slot = (struct knod_ipsec_sa_slot *)x->xso.offload_handle;
+	if (!slot)
+		return;
+
+	mutex_lock(&priv->slot_lock);
+
+	if (slot->replay_mem)
+		knod_free_mem(priv->knod, slot->replay_mem);
+	if (slot->htable_mem)
+		knod_free_mem(priv->knod, slot->htable_mem);
+	if (slot->key_mem)
+		knod_free_mem(priv->knod, slot->key_mem);
+
+	memset(slot, 0, sizeof(*slot));
+	x->xso.offload_handle = 0;
+
+	mutex_unlock(&priv->slot_lock);
+}
+
+static bool knod_ipsec_xdo_offload_ok(struct knod_dev *knodev,
+				      struct sk_buff *skb,
+				      struct xfrm_state *x)
+{
+	/* We support only ESP / AES-GCM / packet offload; state_add
+	 * already filtered unsupported cases. Offload OK for matching SA.
+	 */
+	return x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
+	       x->id.proto == IPPROTO_ESP && x->aead;
+}
+
+static void knod_ipsec_xdo_state_advance_esn(struct knod_dev *knodev,
+					     struct xfrm_state *x)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_sa_slot *slot;
+	struct knod_ipsec_sa_entry *e;
+
+	if (!priv || !x->replay_esn)
+		return;
+	slot = (struct knod_ipsec_sa_slot *)x->xso.offload_handle;
+	if (!slot || !slot->active)
+		return;
+
+	e = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr;
+	e += slot->slot_idx;
+
+	/* xfrm calls advance_esn whenever the inbound ESN high-32 bits
+	 * change. The GPU reads seq_hi/seq_last via VMEM (global_load) so
+	 * the COHERENT VRAM mapping ensures visibility without SDMA.
+	 */
+	WRITE_ONCE(e->seq_hi, cpu_to_le32(x->replay_esn->seq_hi));
+	WRITE_ONCE(e->seq_last, cpu_to_le64(
+		((u64)x->replay_esn->seq_hi << 32) |
+		 (u64)x->replay_esn->seq));
+	/* Ensure both fields are visible to GPU before returning. */
+	wmb();
+}
+
+static void knod_ipsec_xdo_state_update_stats(struct knod_dev *knodev,
+					      struct xfrm_state *x)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_sa_slot *slot;
+	struct knod_ipsec_sa_gpu_stats *gs;
+	u32 spi;
+
+	if (!priv || !priv->sa_table)
+		return;
+
+	spi = be32_to_cpu(x->id.spi);
+	slot = xa_load(&priv->spi_to_slot, spi);
+	if (!slot || !slot->active)
+		return;
+
+	/* Read GPU-side per-SA counters (atomically updated by shader). */
+	gs = (struct knod_ipsec_sa_gpu_stats *)
+		((u8 *)priv->sa_table->kaddr + KNOD_IPSEC_STATS_REGION_OFF +
+		 slot->slot_idx * KNOD_IPSEC_SA_STATS_SIZE);
+
+	x->curlft.packets = le64_to_cpu(READ_ONCE(gs->rx_packets));
+	x->curlft.bytes   = le64_to_cpu(READ_ONCE(gs->rx_bytes));
+}
+
+/* ========================================================================
+ * RX delivery queues (host SPSC descriptor ring; pages from pass_pool)
+ * ========================================================================
+ */
+
+/*
+ * RFC 4303 anti-replay window check + update (single-writer, lockless).
+ * Returns true if the packet is accepted (not a replay and in window),
+ * false if it must be dropped.
+ *
+ * Caller guarantees that RSS pins the SA to a single RX queue, so the
+ * only writer to `win` on this CPU is the NAPI for this queue. The
+ * function both tests and updates - NIC dd calls it exactly once per
+ * desc, either to accept or to drop.
+ */
+static inline bool knod_ipsec_sa_window_check(struct knod_ipsec_sa_window *win,
+					      u64 seq)
+{
+	const unsigned int nwords = KNOD_IPSEC_CPU_REPLAY_WORDS;
+	unsigned int diff;
+	unsigned int w;
+	u64 bit;
+	int i;
+
+	if (seq == 0)
+		return false;
+
+	if (seq > win->top_seq) {
+		diff = (unsigned int)(seq - win->top_seq);
+		if (diff >= KNOD_IPSEC_CPU_REPLAY_BITS) {
+			memset(win->bitmap, 0, sizeof(win->bitmap));
+		} else {
+			unsigned int word_shift = diff >> 6;   /* diff / 64 */
+			unsigned int bit_shift  = diff & 63;   /* diff % 64 */
+
+			/* Shift the whole bitmap left by `diff` bits. bit at
+			 * position p in bitmap[w] moves to p + diff. Work
+			 * from the high word downwards so we don't overwrite
+			 * source words before reading them.
+			 */
+			if (bit_shift == 0) {
+				for (i = (int)nwords - 1; i >= 0; i--) {
+					int src = i - (int)word_shift;
+
+					win->bitmap[i] = (src >= 0)
+						? win->bitmap[src] : 0;
+				}
+			} else {
+				for (i = (int)nwords - 1; i >= 0; i--) {
+					int src_hi = i - (int)word_shift;
+					int src_lo = src_hi - 1;
+					u64 hi = 0, lo = 0;
+
+					if (src_hi >= 0)
+						hi = win->bitmap[src_hi] <<
+						     bit_shift;
+					if (src_lo >= 0)
+						lo = win->bitmap[src_lo] >>
+						     (64 - bit_shift);
+					win->bitmap[i] = hi | lo;
+				}
+			}
+		}
+		win->top_seq = seq;
+		win->bitmap[0] |= 1ull;
+		return true;
+	}
+
+	diff = (unsigned int)(win->top_seq - seq);
+	if (diff >= KNOD_IPSEC_CPU_REPLAY_BITS)
+		return false;	/* too old */
+	w = diff >> 6;
+	bit = 1ull << (diff & 63);
+
+	if (win->bitmap[w] & bit)
+		return false;	/* replay */
+	win->bitmap[w] |= bit;
+	return true;
+}
+
+static int knod_ipsec_rxq_init_all(struct knod_ipsec_priv *priv)
+{
+	/* One delivery queue per NIC RX queue, capped at KNOD_SPSC_MAX to
+	 * match the rest of the NOD/offmem/bd ring infrastructure.  Per-queue
+	 * delivery now flows through the framework pass_pending ring, so this
+	 * only records the queue count for the finish-worker bounds check.
+	 */
+	int nr = priv->knodev && priv->knodev->netdev
+		? (int)priv->knodev->netdev->num_rx_queues : 1;
+
+	if (nr > KNOD_SPSC_MAX)
+		nr = KNOD_SPSC_MAX;
+	if (nr < 1)
+		nr = 1;
+
+	priv->nr_rxq = nr;
+	return 0;
+}
+
+static void knod_ipsec_rxq_exit_all(struct knod_ipsec_priv *priv)
+{
+	priv->nr_rxq = 0;
+}
+
+/* ========================================================================
+ * NOD init / exit - allocate SA table and shared T-tables
+ * ========================================================================
+ */
+
+static int knod_ipsec_nod_init(struct knod_dev *knodev)
+{
+	struct amdgpu_device *adev;
+	struct knod_ipsec_priv *priv;
+	int err;
+
+	if (ipsec_priv) {
+		pr_warn("knod_ipsec: priv already initialized\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Pin the module while IPsec is the selected feature: the core calls
+	 * into these ops, so it must not be unloaded until feature->none.
+	 * (No-op when built in - THIS_MODULE is NULL.)
+	 */
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	/* kvzalloc because priv has grown large (slots[NR_SA] each with
+	 * win[KNOD_SPSC_MAX] sliding windows - a couple of MB now). kzalloc
+	 * may succeed but kvzalloc falls back to vmalloc if kmalloc can't
+	 * find contiguous pages, which is safer under memory pressure.
+	 */
+	priv = kvzalloc_obj(*priv, GFP_KERNEL);
+	if (!priv) {
+		module_put(THIS_MODULE);
+		return -ENOMEM;
+	}
+
+	priv->stats = alloc_percpu(struct knod_ipsec_stats);
+	if (!priv->stats) {
+		err = -ENOMEM;
+		goto err_priv;
+	}
+
+	priv->knod = knodev->accel->priv;
+	if (!priv->knod) {
+		pr_err("knod_ipsec: no knod context (NOD not attached?)\n");
+		err = -ENODEV;
+		goto err_stats;
+	}
+	priv->knodev = knodev;
+	mutex_init(&priv->slot_lock);
+	xa_init(&priv->spi_to_slot);
+
+	/* Number of parallel dispatchers = number of AQL/SDMA queue pairs
+	 * that the accel was allocated with, capped at the ipsec module's
+	 * compile-time limit. Falls back to 1 when the knod layer reports
+	 * 0 or the clamp leaves nothing usable.
+	 */
+	priv->nr_dispatchers = priv->knod->queue_cnt;
+	if (priv->nr_dispatchers > KNOD_IPSEC_MAX_DISPATCHERS)
+		priv->nr_dispatchers = KNOD_IPSEC_MAX_DISPATCHERS;
+	if (priv->nr_dispatchers < 1)
+		priv->nr_dispatchers = 1;
+	priv->pkt_batch = KNOD_IPSEC_PKT_BATCH;
+
+	priv->t_tables = knod_gcm_alloc_tables(priv->knod);
+	if (IS_ERR(priv->t_tables)) {
+		err = PTR_ERR(priv->t_tables);
+		priv->t_tables = NULL;
+		goto err_ctx;
+	}
+
+	adev = priv->knod->process->pdds[0]->dev->adev;
+
+	if (adev->asic_type == CHIP_VEGA10 ||
+	    adev->asic_type == CHIP_VEGA20) {
+		priv->isa_version = 9;
+		priv->shader_size = knod_ipsec_init_shader_gfx9(priv->knod);
+	} else {
+		priv->isa_version = 10;
+		priv->shader_size = knod_ipsec_init_shader_gfx10(priv->knod);
+	}
+
+	err = knod_ipsec_work_pool_alloc(priv);
+	if (err) {
+		knod_ipsec_work_pool_free(priv);
+		goto err_ttables;
+	}
+
+	/* Persistent KAT scratch BO. Sized for the largest nr
+	 * (KNOD_IPSEC_PKT_BATCH=64 bd slots at 64B stride, plus a matching
+	 * per-packet dummy area at 128B stride for IPv6 ESP minimum).
+	 * 4 pages = 16KB to fit max batch. Keeping it as a single long-lived
+	 * BO avoids the per-KAT alloc/free dance that retriggers the
+	 * multi-BO mapping bug.
+	 */
+	priv->kat_scratch = knod_alloc_mem(priv->knod, PAGE_SIZE * 4,
+					   KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+					   KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+					   KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+	if (IS_ERR(priv->kat_scratch)) {
+		err = PTR_ERR(priv->kat_scratch);
+		priv->kat_scratch = NULL;
+		goto err_works;
+	}
+
+	/*
+	 * Allocate sa_table LAST. The GTT/VRAM multi-BO mapping bug
+	 * (memory/gtt_multi_bo_bug.md) makes some BOs allocated mid-init fail
+	 * to bind their backing pages at the returned gaddr even though the
+	 * CPU kaddr is valid. Empirically, BOs allocated after all other init
+	 * BOs (knod ctx, t_tables, shader init, work pool, kat_scratch) bind
+	 * reliably. Allocating sa_table last sidesteps this.
+	 */
+	/* DIAGNOSTIC bisect step 1b: BO size is still ENLARGED, but rounded up
+	 * to the next power-of-two (8 pages = 32 KB) instead of the natural
+	 * 7 pages = 28 KB. Exact-7-page (0x7000) sa_table alloc empirically
+	 * corrupts the subsequent dispatch (kernarg TCP fault at 0x01af5000);
+	 * 6 pages (0x6000) is fine. Suspicion: amdgpu VRAM/GTT path handles
+	 * non-power-of-two sizes differently for mappings of this scale.
+	 */
+	/* RX delivery desc rings (host kvmalloc; payload pages come from the
+	 * framework pass_pool, no per-queue GTT BO). Set up before sa_table,
+	 * which must stay the last BO bound on this KFD process VM per the
+	 * "sa_table last" constraint in memory/gtt_multi_bo_bug.md.
+	 */
+	err = knod_ipsec_rxq_init_all(priv);
+	if (err)
+		goto err_kat_scratch;
+
+	priv->sa_table = knod_alloc_mem(priv->knod,
+					ALIGN(KNOD_IPSEC_SA_BO_SIZE,
+					      8 * PAGE_SIZE),
+					KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+					KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+					KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+	if (IS_ERR(priv->sa_table)) {
+		err = PTR_ERR(priv->sa_table);
+		priv->sa_table = NULL;
+		goto err_rxq;
+	}
+	memset(priv->sa_table->kaddr, 0, KNOD_IPSEC_SA_BO_SIZE);
+	pr_info("knod_ipsec: sa_table gaddr=0x%llx kaddr=%p size=%u\n",
+		priv->sa_table->gaddr, priv->sa_table->kaddr,
+		(u32)KNOD_IPSEC_SA_BO_SIZE);
+
+	err = knod_ipsec_disp_create_all(priv);
+	if (err)
+		goto err_sa_table;
+
+	ipsec_priv = priv;
+	knodev->post_copy = knod_ipsec_post_copy;
+	knod_ipsec_debugfs_init(priv);
+	pr_info("knod_ipsec: initialized on %s (gfx%d, single dispatcher)\n",
+		netdev_name(knodev->netdev), priv->isa_version);
+	return 0;
+
+err_sa_table:
+	knod_free_mem(priv->knod, priv->sa_table);
+	priv->sa_table = NULL;
+err_rxq:
+	knod_ipsec_rxq_exit_all(priv);
+err_kat_scratch:
+	knod_free_mem(priv->knod, priv->kat_scratch);
+err_works:
+	knod_ipsec_work_pool_free(priv);
+err_ttables:
+	knod_gcm_free_tables(priv->knod, priv->t_tables);
+err_ctx:
+	priv->knod = NULL;
+err_stats:
+	free_percpu(priv->stats);
+err_priv:
+	kvfree(priv);
+	module_put(THIS_MODULE);
+	return err;
+}
+
+static void knod_ipsec_nod_exit(struct knod_dev *knodev)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	int i;
+
+	if (!priv)
+		return;
+
+	knod_ipsec_debugfs_exit(priv);
+
+	/*
+	 * Publish the NULL and wait a grace period before freeing: the
+	 * softirq RX reader (knod_ipsec_post_copy) samples ipsec_priv and must
+	 * not touch it once it is freed.  Runs under rtnl (feature_set/detach),
+	 * so the synchronize_net() is expedited.
+	 */
+	knodev->post_copy = NULL;
+	WRITE_ONCE(ipsec_priv, NULL);
+	synchronize_net();
+
+	knod_ipsec_disp_destroy_all(priv);
+
+	/* Free any leftover slots (should be none if xfrm tore down SAs). */
+	mutex_lock(&priv->slot_lock);
+	for (i = 0; i < KNOD_IPSEC_NR_SA; i++) {
+		struct knod_ipsec_sa_slot *slot = &priv->slots[i];
+
+		if (!slot->active && !slot->key_mem)
+			continue;
+		if (slot->replay_mem)
+			knod_free_mem(priv->knod, slot->replay_mem);
+		if (slot->htable_mem)
+			knod_free_mem(priv->knod, slot->htable_mem);
+		if (slot->key_mem)
+			knod_free_mem(priv->knod, slot->key_mem);
+		memset(slot, 0, sizeof(*slot));
+	}
+	xa_destroy(&priv->spi_to_slot);
+	mutex_unlock(&priv->slot_lock);
+
+	knod_ipsec_work_pool_free(priv);
+
+	knod_ipsec_rxq_exit_all(priv);
+
+	if (priv->kat_scratch) {
+		knod_free_mem(priv->knod, priv->kat_scratch);
+		priv->kat_scratch = NULL;
+	}
+	if (priv->sa_table)
+		knod_free_mem(priv->knod, priv->sa_table);
+	if (priv->t_tables)
+		knod_gcm_free_tables(priv->knod, priv->t_tables);
+	/* knod context is owned by NOD core (knod_attach), don't free */
+	priv->knod = NULL;
+	if (priv->stats)
+		free_percpu(priv->stats);
+
+	kvfree(priv);
+	module_put(THIS_MODULE);
+	pr_info("knod_ipsec: torn down\n");
+}
+
+/* True while an offloaded xfrm SA is still bound to this accel. */
+static bool knod_ipsec_nod_busy(struct knod_dev *knodev)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+
+	if (!priv)
+		return false;
+	return !xa_empty(&priv->spi_to_slot);
+}
+
+static int knod_ipsec_disp_create_all(struct knod_ipsec_priv *priv)
+{
+	int d, i;
+
+	for (d = 0; d < priv->nr_dispatchers; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+		struct task_struct *p;
+
+		p = kthread_create(knod_ipsec_dispatcher, disp,
+				   "knod_ipsec-d%d", d);
+		if (IS_ERR(p)) {
+			pr_warn("knod_ipsec: failed to create dispatcher %d: %ld\n",
+				d, PTR_ERR(p));
+			for (i = 0; i < d; i++) {
+				kthread_stop(priv->disp[i].kthread);
+				priv->disp[i].kthread = NULL;
+			}
+			return PTR_ERR(p);
+		}
+		kthread_park(p);
+		disp->kthread = p;
+	}
+	return 0;
+}
+
+static void knod_ipsec_disp_destroy_all(struct knod_ipsec_priv *priv)
+{
+	int d;
+
+	for (d = 0; d < priv->nr_dispatchers; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+		if (disp->kthread) {
+			kthread_stop(disp->kthread);
+			disp->kthread = NULL;
+		}
+	}
+}
+
+static void knod_ipsec_nod_start(struct knod_dev *knodev)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	int base_rx, rem_rx;
+	int off_rx;
+	struct knod *knod;
+	int d, nr_rxq;
+
+	if (!priv || READ_ONCE(priv->running))
+		return;
+
+	knod = priv->knod;
+
+	/* Partition RX queues across dispatchers. Each disp
+	 * owns a contiguous range of queues so the per-SPSC single-
+	 * consumer invariant holds without cross-dispatcher locking.
+	 * Leftover (when the total isn't a multiple of nr_dispatchers)
+	 * lands on the first few disps, one extra each.
+	 */
+	nr_rxq = knodev->netdev ? knodev->netdev->real_num_rx_queues : 0;
+	if (nr_rxq > KNOD_SPSC_MAX)
+		nr_rxq = KNOD_SPSC_MAX;
+	if (nr_rxq > knod->channels)
+		nr_rxq = knod->channels;
+	if (nr_rxq < 0)
+		nr_rxq = 0;
+
+	base_rx = nr_rxq / priv->nr_dispatchers;
+	rem_rx  = nr_rxq % priv->nr_dispatchers;
+	off_rx = 0;
+
+	for (d = 0; d < priv->nr_dispatchers; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+		int n_rx = base_rx + (d < rem_rx ? 1 : 0);
+
+		disp->rxq_first = off_rx;
+		disp->rxq_count = n_rx;
+		off_rx += n_rx;
+	}
+
+	WRITE_ONCE(priv->running, true);
+	for (d = 0; d < priv->nr_dispatchers; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+		if (!disp->kthread)
+			continue;
+		kthread_unpark(disp->kthread);
+		pr_info("knod_ipsec: disp[%d] started rxq[%d..%d) kaql=%d\n",
+			d, disp->rxq_first,
+			disp->rxq_first + disp->rxq_count,
+			disp->kaql_idx);
+	}
+}
+
+static void knod_ipsec_nod_stop(struct knod_dev *knodev)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	int d;
+
+	if (!priv || !READ_ONCE(priv->running))
+		return;
+
+	WRITE_ONCE(priv->running, false);
+	for (d = 0; d < priv->nr_dispatchers; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+		if (!disp->kthread)
+			continue;
+		kthread_park(disp->kthread);
+	}
+}
+
+/* ========================================================================
+ * Phase 3: fused RX shader load + dispatch
+ * ========================================================================
+ *
+ * The fused RX shader parses ESP, resolves the SA via SPI lookup, and
+ * (in follow-up work) runs AES-GCM decrypt/ICV. The resulting inner
+ * packet lives in VRAM; the CPU finish worker SDMA-copies it into a
+ * per-queue delivery-pool page and publishes a knod_pass_desc onto the
+ * framework pass_pending ring. Anti-replay and skb build happen in the NIC
+ * dd NAPI consumer - the shader does neither. See knod_ipsec.h for the
+ * full data-flow description.
+ */
+
+static int knod_ipsec_init_shader_gfx9(struct knod *knod)
+{
+	struct compute_pgm_rsrc1 rsrc1 = {};
+	struct compute_pgm_rsrc2 rsrc2 = {};
+	struct kernel_descriptor *kd = knod->kernels[0]->kaddr;
+	struct code_properties props = {};
+	int shader_size;
+
+	memset(kd, 0, sizeof(*kd));
+	kd->kernel_code_entry_byte_offset = 1024;
+	kd->group_segment_fixed_size = KNOD_GCM_T_TABLES_TOTAL;
+
+	/* VGPRs: (gran+1)*4. Need v0-v42 (43 VGPRs) -> gran=12 -> 52.
+	 * SGPRs: (gran+1)*8. Need s0-s59 (SR_RK2) -> gran=7 -> 64.
+	 */
+	rsrc1.granulated_workitem_vgpr_count = 12;
+	rsrc1.granulated_wavefront_sgpr_count = 7;
+	rsrc1.float_denorm_mode_32 = 3;
+	rsrc1.float_denorm_mode_16_64 = 3;
+	rsrc1.enable_dx10_clamp = 1;
+	rsrc1.enable_ieee_mode = 1;
+
+	rsrc2.user_sgpr_count = 15;
+	rsrc2.enable_sgpr_workgroup_id_x = 1;
+	rsrc2.enable_sgpr_workgroup_id_y = 1;
+	rsrc2.enable_sgpr_workgroup_id_z = 1;
+	rsrc2.granulated_lds_size = 8;
+
+	props.enable_sgpr_private_segment_buffer = 1;
+	props.enable_sgpr_dispatch_ptr = 1;
+	props.enable_sgpr_queue_ptr = 1;
+	props.enable_sgpr_kernarg_segment_ptr = 1;
+	props.enable_sgpr_dispatch_id = 1;
+	props.enable_sgpr_flat_scratch_init = 1;
+	props.enable_sgpr_private_segment_size = 1;
+
+	memcpy(&kd->compute_pgm_rsrc1, &rsrc1, sizeof(rsrc1));
+	memcpy(&kd->compute_pgm_rsrc2, &rsrc2, sizeof(rsrc2));
+	memcpy(&kd->code_properties, &props, sizeof(props));
+
+	memset(knod->kernels[0]->kaddr + kd->kernel_code_entry_byte_offset,
+	       0, (PAGE_SIZE << 4) - kd->kernel_code_entry_byte_offset);
+	shader_size = kfd_ipsec_gen_fused_shader_gfx9(
+		knod->kernels[0]->kaddr + kd->kernel_code_entry_byte_offset);
+	pr_debug("knod_ipsec: GFX9 RX shader generated, %d bytes\n",
+		 shader_size);
+
+	return shader_size;
+}
+
+static int knod_ipsec_init_shader_gfx10(struct knod *knod)
+{
+	struct compute_pgm_rsrc1 rsrc1 = {};
+	struct compute_pgm_rsrc2 rsrc2 = {};
+	struct kernel_descriptor *kd = knod->kernels[0]->kaddr;
+	struct code_properties props = {};
+	int shader_size;
+	u32 rsrc1_raw;
+
+	memset(kd, 0, sizeof(*kd));
+	kd->kernel_code_entry_byte_offset = 1024;
+	kd->group_segment_fixed_size = KNOD_GCM_T_TABLES_TOTAL;
+
+	/* VGPRs: Wave64, granularity=4. (12+1)*4 = 52 VGPRs.
+	 * Shader uses v0-v42 (VR_SAVE_ESP_OFF).
+	 *
+	 * SGPRs: RDNA2 ignores granulated_wavefront_sgpr_count -
+	 * SGPRs come from a flat 106-entry pool. Field is reserved
+	 * and must be 0 (non-zero corrupts RSRC1 interpretation on
+	 * some RDNA2 steppings, causing SQC inst-fetch faults).
+	 */
+	rsrc1.granulated_workitem_vgpr_count = 12;
+	rsrc1.granulated_wavefront_sgpr_count = 0;
+	rsrc1.float_denorm_mode_32 = 3;
+	rsrc1.float_denorm_mode_16_64 = 3;
+	rsrc1.enable_dx10_clamp = 1;
+	rsrc1.enable_ieee_mode = 1;
+	rsrc1.wgp_mode = 0;
+	rsrc1.mem_ordered = 1;
+
+	rsrc2.user_sgpr_count = 15;
+	rsrc2.enable_sgpr_workgroup_id_x = 1;
+	rsrc2.enable_sgpr_workgroup_id_y = 1;
+	rsrc2.enable_sgpr_workgroup_id_z = 1;
+	rsrc2.granulated_lds_size = 8;
+
+	props.enable_sgpr_private_segment_buffer = 1;
+	props.enable_sgpr_dispatch_ptr = 1;
+	props.enable_sgpr_queue_ptr = 1;
+	props.enable_sgpr_kernarg_segment_ptr = 1;
+	props.enable_sgpr_dispatch_id = 1;
+	props.enable_sgpr_flat_scratch_init = 1;
+	props.enable_sgpr_private_segment_size = 1;
+
+	memcpy(&kd->compute_pgm_rsrc1, &rsrc1, sizeof(rsrc1));
+	memcpy(&kd->compute_pgm_rsrc2, &rsrc2, sizeof(rsrc2));
+	memcpy(&kd->code_properties, &props, sizeof(props));
+
+	memset(knod->kernels[0]->kaddr + kd->kernel_code_entry_byte_offset,
+	       0, (PAGE_SIZE << 4) - kd->kernel_code_entry_byte_offset);
+	shader_size = kfd_ipsec_gen_fused_shader_gfx10(
+		knod->kernels[0]->kaddr + kd->kernel_code_entry_byte_offset);
+	memcpy(&rsrc1_raw, &kd->compute_pgm_rsrc1, 4);
+	pr_info("knod_ipsec: GFX10 shader %d bytes, RSRC1=0x%08x (vgpr=%u sgpr=%u wgp=%u mem=%u)\n",
+		shader_size, rsrc1_raw,
+		rsrc1_raw & 0x3F,
+		(rsrc1_raw >> 6) & 0xF,
+		(rsrc1_raw >> 29) & 1,
+		(rsrc1_raw >> 30) & 1);
+
+	return shader_size;
+}
+
+/*
+ * Single-dispatcher AQL machinery.
+ *
+ * One AQL queue (kaql[0]), one in-flight dispatch, one kthread that owns
+ * everything. The dispatcher drains per-queue NIC RX SPSC bd rings, builds one
+ * dispatch, kicks the GPU, spins on the completion signal, finalises, and
+ * loops. No lock on the hot path.
+ *
+ * KAT paths park the dispatcher with kthread_park() for exclusive ownership
+ * of the queue and the work slot.
+ */
+
+static void knod_ipsec_fill_dispatch(struct knod *knod,
+				     struct knod_ipsec_work *work,
+				     struct knod_dispatch_params *p)
+{
+	p->workgroup_size_x = 256;
+	p->grid_size_x = 256;
+	p->grid_size_y = max(work->nr_packets, 1);
+	p->private_segment_size = 0;
+	p->group_segment_size = KNOD_GCM_T_TABLES_TOTAL;
+	p->kernel_object = (u64)knod->kernels[0]->gaddr;
+	p->kernarg_address = work->param.gaddr;
+}
+
+/*
+ * Prepare the dispatcher's single work slot to run the fused RX shader
+ * over `sub[0..nr)`. Must be called from dispatcher context only (or while
+ * the dispatcher is parked - e.g. from KAT). `bds` may be NULL for the
+ * in-kernel KAT path; in that case the KAT owns out_addr and this helper
+ * leaves it untouched.
+ */
+static void knod_ipsec_prepare_rx_dispatch(struct knod_ipsec_priv *priv,
+					   struct knod_ipsec_work *work,
+					   struct knod_ipsec_fused_sub *sub,
+					   struct spsc_bd **bds, int nr,
+					   struct napi_struct *napi,
+					   int queue_idx)
+{
+	struct knod_ipsec_fused_param *param;
+	struct amd_signal *signal;
+
+	if (nr > (int)READ_ONCE(priv->pkt_batch))
+		nr = (int)READ_ONCE(priv->pkt_batch);
+
+	param = (struct knod_ipsec_fused_param *)work->param.kaddr;
+	memset(param, 0, sizeof(*param));
+	param->sa_table_addr = cpu_to_le64(priv->sa_table->gaddr);
+	param->t_tables_addr = cpu_to_le64(priv->t_tables->gaddr);
+	param->nr_sa         = cpu_to_le32(KNOD_IPSEC_NR_SA);
+	memcpy(param->sub, sub, sizeof(sub[0]) * nr);
+
+	/* Patch out_addr to point to the per-work decrypt output buffer
+	 * instead of pkt_addr. AES-CTR writes plaintext here; GHASH reads
+	 * the original ciphertext from pkt_addr. In-place would corrupt
+	 * the ciphertext before GHASH could read it.
+	 *
+	 * Skip for KAT (bds==NULL): the KAT manages out_addr itself.
+	 */
+	if (bds) {
+		int pi;
+
+		for (pi = 0; pi < nr; pi++)
+			param->sub[pi].out_addr = cpu_to_le64(
+				work->rx_out_gaddr +
+				(u64)pi * KNOD_IPSEC_DECRYPT_PKT_SIZE);
+	}
+
+	work->nr_packets = nr;
+	work->rx_napi = napi;
+	work->rx_queue_idx = queue_idx;
+	if (bds) {
+		int bi;
+
+		for (bi = 0; bi < nr; bi++) {
+			work->rx_bds[bi] = bds[bi];
+			/* Single-queue legacy/KAT path: all packets belong
+			 * to queue_idx. Multi-queue dispatches populate
+			 * rx_pkt_queue[] directly in try_rx and never call
+			 * this function.
+			 */
+			work->rx_pkt_queue[bi] = (u8)queue_idx;
+		}
+	} else {
+		memset(work->rx_bds, 0, sizeof(work->rx_bds[0]) * nr);
+		memset(work->rx_pkt_queue, (u8)queue_idx,
+		       sizeof(work->rx_pkt_queue[0]) * nr);
+	}
+	signal = (struct amd_signal *)priv->knod->kaql[0].queue_signal->kaddr;
+	work->sigval = READ_ONCE(signal->value);
+	if (static_branch_unlikely(&ipsec_stats_enabled_key))
+		work->dispatch_ts = ktime_to_ns(ktime_get());
+}
+
+/*
+ * Legacy exported entry points. With the single-dispatcher architecture,
+ * NICs publish bds into knodev->wpriv[].spsc_bds and the dispatcher polls
+ * them directly - no NIC driver actually calls these anymore, but keep the
+ * exports so external out-of-tree builds don't break while they transition.
+ */
+int knod_ipsec_rx_submit(struct knod_ipsec_fused_sub *sub, int nr,
+			 struct napi_struct *napi, int queue_idx)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(knod_ipsec_rx_submit);
+
+int knod_ipsec_rx_submit_bds(struct knod_ipsec_fused_sub *sub,
+			     struct spsc_bd **bds, int nr,
+			     struct napi_struct *napi, int queue_idx)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(knod_ipsec_rx_submit_bds);
+
+/*
+ * Shader verdict sentinels (low-side) - kept in lockstep with
+ * ipsec_fused_gfx9.h. `bd->act` is packed as (low32=snapshot, high32=
+ * slot_idx|sentinel); we only read the high half here.
+ */
+#define KNOD_IPSEC_SHADER_VERDICT_MISS		0xFFFFFFFFu
+#define KNOD_IPSEC_SHADER_VERDICT_BYPASS	0xFFFFFFFEu
+#define KNOD_IPSEC_SHADER_VERDICT_ICV_FAIL	0xFFFFFFFDu
+
+/*
+ * The dispatcher fences each RX batch at the SDMA ring position that
+ * knod_sdma_submit() returned (a 32-bit dword cursor that wraps), so the
+ * completion test is a signed-32 compare against the signal's low word.
+ */
+static bool knod_ipsec_fence_passed(struct knod_ipsec_work *w)
+{
+	return (s32)((u32)READ_ONCE(*w->sdma_fence_ptr) -
+		     w->sdma_fence_target) >= 0;
+}
+
+/* Bounded spin until @w's RX-batch SDMA fence fires (teardown path only). */
+static void knod_ipsec_fence_wait(struct knod_ipsec_work *w)
+{
+	int timeout = 100000;
+
+	while (!knod_ipsec_fence_passed(w)) {
+		if (--timeout <= 0)
+			break;
+		cpu_relax();
+	}
+}
+
+/*
+ * RX finish: GPU is done writing verdicts for this batch. For every
+ * packet that the shader flagged as a hit, SDMA-copy the decrypted
+ * inner payload from VRAM to a per-queue delivery-pool (pass_pool) page,
+ * then push a knod_pass_desc onto the framework pass_pending ring so the
+ * NIC dd NAPI picks it up via knod_d2h_drain() + knod_ipsec_post_copy().
+ *
+ * Packets with a miss/bypass/malformed verdict never reach the pending
+ * ring; they just get accounted here and the bd is recycled by the
+ * NIC dd through its normal bd ring path (unchanged).
+ */
+static void knod_ipsec_finish_rx_deliver(struct knod_ipsec_dispatcher *disp,
+					 struct knod_ipsec_work *work)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	struct knod_ipsec_fused_param *param;
+	struct knod_ipsec_stats *s = NULL;
+	struct knod *knod = priv->knod;
+	int sdma_idx = disp->kaql_idx;
+	struct knod_sdma *sdma_q = &knod->sdma[sdma_idx];
+	struct knod_sdma_copy_desc copies[2];
+	u32 batch_fence = 0;
+	int i;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+	int n_sdma = 0;
+	u32 sdma_copies = 0;
+	u32 sdma_bytes = 0;
+	int pkt_idx_of[KNOD_IPSEC_PKT_BATCH];
+	struct knod_ipsec_rx_pending *pending = work->rx_pending;
+
+	if (stats_on)
+		s = this_cpu_ptr(priv->stats);
+
+	param = (struct knod_ipsec_fused_param *)work->param.kaddr;
+
+	/* Step 1: classify + schedule SDMA for hits. Each packet in the
+	 * batch may belong to a different NIC RX queue, so rxq routing
+	 * happens per-packet via work->rx_pkt_queue[i] -> priv->rxq[].
+	 */
+	for (i = 0; i < work->nr_packets; i++) {
+		struct knod_ipsec_sa_slot *sa_slot;
+		struct spsc_bd *bd = work->rx_bds[i];
+		struct page_pool *pool;
+		netmem_ref netmem;
+		u64 pkt_gaddr, out_gaddr;
+		u64 dst_base;
+		u8 pkt_next_hdr;
+		u32 verdict_hi;
+		u32 inner_len;
+		u32 pend_inner_len;
+		u32 fv;
+		int ncopy;
+		u8 pkt_family;
+		u8 pkt_mode;
+		unsigned int rxq_idx = work->rx_pkt_queue[i];
+
+		if (!bd)
+			continue;
+		if ((int)rxq_idx >= priv->nr_rxq)
+			continue;
+		pool = READ_ONCE(priv->knodev->wpriv[rxq_idx].pass_pool);
+
+		verdict_hi = (u32)(bd->act >> 32);
+
+		if (verdict_hi == KNOD_IPSEC_SHADER_VERDICT_MISS ||
+		    verdict_hi == KNOD_IPSEC_SHADER_VERDICT_BYPASS) {
+			u32 raw_len = bd->len;
+			u64 pkt_gaddr;
+			u64 dst_gaddr;
+
+			if (raw_len == 0 || raw_len > PAGE_SIZE) {
+				if (stats_on)
+					s->rx_drop_malformed++;
+				pr_warn_ratelimited("knod_ipsec: malform-A bypass raw_len=%u pkt[%d] act=0x%llx q%u\n",
+					raw_len, i, bd->act, rxq_idx);
+				bd->act = KNOD_IPSEC_DROP;
+				continue;
+			}
+			netmem = pool ? page_pool_dev_alloc_netmems(pool) : 0;
+			if (!netmem) {
+				if (stats_on)
+					s->rx_drop_malformed++;
+				pr_warn_ratelimited("knod_ipsec: malform-bypass-nomem pkt[%d] raw_len=%u q%u\n",
+						    i, raw_len, rxq_idx);
+				bd->act = KNOD_IPSEC_DROP;
+				continue;
+			}
+			pkt_gaddr = le64_to_cpu(param->sub[i].pkt_addr);
+			dst_gaddr = page_pool_get_dma_addr_netmem(netmem);
+			copies[0].dst = dst_gaddr;
+			copies[0].src = pkt_gaddr;
+			copies[0].len = raw_len;
+			fv = knod_sdma_submit(knod, sdma_idx, copies, 1);
+			if (!fv) {
+				page_pool_put_full_netmem(pool, netmem, false);
+				if (stats_on)
+					s->rx_drop_sdma_full++;
+				bd->act = KNOD_IPSEC_DROP;
+				continue;
+			}
+			batch_fence = fv;
+			sdma_copies++;
+			sdma_bytes += raw_len;
+
+			pending[n_sdma].inner_len = raw_len;
+			pending[n_sdma].netmem    = netmem;
+			pending[n_sdma].sa_slot   = KNOD_IPSEC_NR_SA;
+			pending[n_sdma].rxq_idx   = (u16)rxq_idx;
+			pending[n_sdma].mode      = 0;
+			pending[n_sdma].next_hdr  = 0;
+			pending[n_sdma].family    = 0;
+			pending[n_sdma].inner_off = 0;
+			pkt_idx_of[n_sdma] = i;
+			n_sdma++;
+
+			bd->act = KNOD_IPSEC_PASS;
+			continue;
+		}
+		if (verdict_hi == KNOD_IPSEC_SHADER_VERDICT_ICV_FAIL) {
+			if (stats_on)
+				s->rx_drop_icv++;
+			pr_warn_ratelimited("knod_ipsec: RX ICV fail pkt[%d] act=0x%llx len=%u off=%u\n",
+					    i, bd->act, bd->len, bd->off);
+			bd->act = KNOD_IPSEC_DROP;
+			continue;
+		}
+		if (verdict_hi >= KNOD_IPSEC_NR_SA) {
+			if (stats_on)
+				s->rx_drop_malformed++;
+			pr_warn_ratelimited("knod_ipsec: malform-B verdict_hi=%u pkt[%d] act=0x%llx len=%u q%u\n",
+				verdict_hi, i, bd->act, bd->len, rxq_idx);
+			bd->act = KNOD_IPSEC_DROP;
+			continue;
+		}
+
+		inner_len = bd->len;
+		if (inner_len == 0 || inner_len > PAGE_SIZE) {
+			if (stats_on)
+				s->rx_drop_malformed++;
+			pr_warn_ratelimited("knod_ipsec: malform-C inner_len=%u pkt[%d] act=0x%llx slot=%u q%u\n",
+				inner_len, i, bd->act, verdict_hi, rxq_idx);
+			continue;
+		}
+
+		pkt_mode = bd->off & 0xFF;
+		pkt_next_hdr = (bd->off >> 8) & 0xFF;
+
+		sa_slot = &priv->slots[verdict_hi];
+		pkt_family = sa_slot->x ? sa_slot->x->props.family : AF_INET;
+
+		netmem = pool ? page_pool_dev_alloc_netmems(pool) : 0;
+		if (!netmem) {
+			if (stats_on)
+				s->rx_drop_malformed++;
+			pr_warn_ratelimited("knod_ipsec: malform-decrypt-nomem pkt[%d] slot=%u inner_len=%u q%u\n",
+					    i, verdict_hi, inner_len, rxq_idx);
+			bd->act = KNOD_IPSEC_DROP;
+			continue;
+		}
+		pkt_gaddr = le64_to_cpu(param->sub[i].pkt_addr);
+		out_gaddr = le64_to_cpu(param->sub[i].out_addr);
+		dst_base = page_pool_get_dma_addr_netmem(netmem);
+
+		if (pkt_mode == XFRM_MODE_TRANSPORT) {
+			u32 l3_hdr_len = (pkt_family == AF_INET6) ? 40 : 20;
+
+			copies[0].dst = dst_base + l3_hdr_len;
+			copies[0].src = out_gaddr;
+			copies[0].len = inner_len;
+			copies[1].dst = dst_base;
+			copies[1].src = pkt_gaddr + 14;
+			copies[1].len = l3_hdr_len;
+			ncopy = 2;
+			pend_inner_len = l3_hdr_len + inner_len;
+		} else {
+			copies[0].dst = dst_base + KNOD_IPSEC_GTT_OUT_L3_OFF;
+			copies[0].src = out_gaddr;
+			copies[0].len = inner_len;
+			ncopy = 1;
+			pend_inner_len = inner_len;
+		}
+
+		fv = knod_sdma_submit(knod, sdma_idx, copies, ncopy);
+		if (!fv) {
+			page_pool_put_full_netmem(pool, netmem, false);
+			if (stats_on)
+				s->rx_drop_sdma_full++;
+			bd->act = KNOD_IPSEC_DROP;
+			continue;
+		}
+		batch_fence = fv;
+		sdma_copies += ncopy;
+		sdma_bytes += pend_inner_len;
+
+		pending[n_sdma].inner_len = pend_inner_len;
+		pending[n_sdma].netmem = netmem;
+		pending[n_sdma].sa_slot = verdict_hi;
+		pending[n_sdma].rxq_idx = (u16)rxq_idx;
+		pending[n_sdma].mode = pkt_mode;
+		pending[n_sdma].next_hdr = pkt_next_hdr;
+		pending[n_sdma].family = pkt_family;
+		pending[n_sdma].inner_off =
+			(pkt_mode != XFRM_MODE_TRANSPORT) ?
+			KNOD_IPSEC_GTT_OUT_L3_OFF : 0;
+		pkt_idx_of[n_sdma] = i;
+		n_sdma++;
+	}
+
+	if (stats_on) {
+		work->rx_sdma_copies = sdma_copies;
+		work->rx_sdma_bytes  = sdma_bytes;
+	}
+
+	/* Step 2: FENCE + doorbell.  knod_sdma_submit() emitted the copies
+	 * above; kick fences the ring position it returned (batch_fence).
+	 */
+	if (n_sdma == 0)
+		return;
+	knod_sdma_kick(knod, sdma_idx);
+	work->sdma_fence_target = batch_fence;
+
+	work->sdma_fence_ptr = (s64 *)&((struct amd_signal *)
+		sdma_q->queue_signal->kaddr)->value;
+	work->sdma_submit_ns = stats_on ? ktime_get_ns() : 0;
+	work->n_sdma_pending = n_sdma;
+	for (i = 0; i < n_sdma; i++)
+		work->sdma_pkt_idx_of[i] = (u16)pkt_idx_of[i];
+}
+
+/*
+ * Deferred SDMA completion: publish to pass_pending and mark bds PASS.
+ *
+ * Called from the dispatcher loop once work->sdma_fence_ptr shows the
+ * SDMA fence has fired. All SDMA copies have landed in the delivery pages
+ * so the drain path can now read from them.
+ */
+static void knod_ipsec_finish_rx_complete(struct knod_ipsec_dispatcher *disp,
+					  struct knod_ipsec_work *work)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	struct knod_ipsec_fused_param *param =
+		(struct knod_ipsec_fused_param *)work->param.kaddr;
+	struct knod_ipsec_rx_pending *pending = work->rx_pending;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+	struct knod_ipsec_stats *s = NULL;
+	int n_sdma = work->n_sdma_pending;
+	int i;
+
+	if (stats_on) {
+		s = this_cpu_ptr(priv->stats);
+		if (work->sdma_submit_ns)
+			work->sdma_wait_ns =
+				ktime_get_ns() - work->sdma_submit_ns;
+	}
+
+	/* Publish each decrypted packet onto its RX queue's common pending
+	 * ring; knod_d2h_drain delivers it through knod_ipsec_post_copy.  The
+	 * SDMA fence already fired (the dispatcher waited), so the descriptor
+	 * is tagged already-landed and the drain's fence check is a no-op.
+	 */
+	for (i = 0; i < n_sdma; i++) {
+		u16 rxq = pending[i].rxq_idx;
+		struct knod_work_priv *wpriv = &priv->knodev->wpriv[rxq];
+		int src_j = work->sdma_pkt_idx_of[i];
+		struct knod_pass_desc *d;
+
+		if (spsc_produce(&wpriv->pass_pending, (void **)&d)) {
+			struct page_pool *pool = READ_ONCE(wpriv->pass_pool);
+
+			/* ring full: return the undelivered page */
+			if (pool)
+				page_pool_put_full_netmem(pool,
+							  pending[i].netmem,
+							  false);
+			if (stats_on)
+				s->rx_drop_desc_full++;
+			continue;
+		}
+		d->netmem = pending[i].netmem;
+		d->src = 0;		/* NIC act handler recycles the RX bd */
+		d->len = pending[i].inner_len;
+		d->off = pending[i].inner_off;
+		d->fence_val = work->sdma_fence_target;
+		d->sdma_idx = disp->kaql_idx;
+		d->feat.sa_slot = pending[i].sa_slot;
+		if (pending[i].sa_slot < KNOD_IPSEC_NR_SA) {
+			struct knod_ipsec_sa_slot *sa =
+				&priv->slots[pending[i].sa_slot];
+
+			d->feat.seq_lo =
+				le32_to_cpu(param->sub[src_j].result_seq);
+			d->feat.seq_hi = (sa->x && sa->x->replay_esn) ?
+					 sa->x->replay_esn->seq_hi : 0;
+		} else {
+			d->feat.seq_lo = 0;
+			d->feat.seq_hi = 0;
+		}
+		d->feat.mode = pending[i].mode;
+		d->feat.next_hdr = pending[i].next_hdr;
+		d->feat.family = pending[i].family;
+		spsc_produce_commit(&wpriv->pass_pending);
+	}
+
+	if (stats_on) {
+		s->rx_packets += n_sdma;
+		s->finish_produced += n_sdma;
+	}
+
+	/* Mark all bds as KNOD_IPSEC_PASS so the NIC act_handler recycles
+	 * the netmem on the next NAPI poll.
+	 */
+	for (i = 0; i < work->nr_packets; i++) {
+		if (work->rx_bds[i])
+			work->rx_bds[i]->act = KNOD_IPSEC_PASS;
+	}
+	memset(work->rx_bds, 0,
+	       sizeof(work->rx_bds[0]) * work->nr_packets);
+
+	work->n_sdma_pending = 0;
+}
+
+/*
+ * NIC dd NAPI consumer: drain the per-queue host desc ring, run the
+ * RFC 4303 sliding window check on each descriptor, and deliver the
+ * inner packet up the stack as a zero-copy head_frag skb wrapping the
+ * delivery-pool page (knod_pass_build_skb); the page recycles to the
+ * pool on skb free.
+ *
+ * Safe to call before knod_ipsec_priv has been created: returns 0.
+ * NIC drivers can therefore wire this call unconditionally from their
+ * NAPI poll without extra gating.
+ *
+ * Ordering w.r.t. the bd recycle ring: the NIC driver should drain its
+ * bd ring *first* (to recycle netmem back into the page_pool) and then
+ * call drain_rx. The two rings are independent - bd ring delivers no
+ * verdicts, desc ring carries only PASS candidates.
+ */
+/*
+ * Feature delivery hook (knod_dev->post_copy) for the ipsec RX path.
+ * knod_d2h_drain has already built the head_frag skb wrapping the delivery
+ * page; here we run the SA lookup, RFC 4303 anti-replay window, cleartext
+ * L3 fix-up and secpath attach.  Returns false to drop the packet (the
+ * drain frees the skb, which recycles the page).
+ */
+static bool knod_ipsec_post_copy(struct knod_dev *knodev, struct sk_buff *skb,
+				 const struct knod_pass_desc *desc,
+				 int queue_idx)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	struct knod_ipsec_stats *s = NULL;
+	struct knod_ipsec_sa_slot *slot;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+	u32 sa_slot = desc->feat.sa_slot;
+	u64 seq;
+
+	if (stats_on)
+		s = this_cpu_ptr(priv->stats);
+
+	/* Raw bypass: packet was not IPsec (ARP, non-ESP IP, ESP with an
+	 * unknown SPI).  The page holds the full Ethernet frame; deliver it
+	 * with no IPsec state.
+	 */
+	if (sa_slot == KNOD_IPSEC_NR_SA) {
+		skb->dev = knodev->netdev;
+		skb->protocol = eth_type_trans(skb, knodev->netdev);
+		skb_reset_network_header(skb);
+		return true;
+	}
+	if (sa_slot > KNOD_IPSEC_NR_SA) {
+		if (stats_on)
+			s->rx_drop_malformed++;
+		pr_warn_ratelimited("knod_ipsec: malform-pc-saslot sa_slot=%u len=%u q%d\n",
+				    sa_slot, desc->len, queue_idx);
+		return false;
+	}
+
+	slot = &priv->slots[sa_slot];
+	if (!slot->active) {
+		if (stats_on)
+			s->rx_drop_no_sa++;
+		return false;
+	}
+
+	seq = ((u64)desc->feat.seq_hi << 32) | (u64)desc->feat.seq_lo;
+	if (!knod_ipsec_sa_window_check(&slot->win[queue_idx], seq)) {
+		if (stats_on)
+			s->rx_drop_replay++;
+		return false;
+	}
+
+	/* skb->data is the decrypted inner packet (head_frag at inner_off). */
+	if (desc->feat.mode == XFRM_MODE_TRANSPORT) {
+		/* Transport: the page holds the outer L3 header (20B IPv4 or
+		 * 40B IPv6) followed by the decrypted payload; patch the
+		 * next-header and length fields to describe the cleartext.
+		 */
+		if (desc->feat.family == AF_INET6) {
+			struct ipv6hdr *ip6h;
+
+			if (desc->len < 40) {
+				if (stats_on)
+					s->rx_drop_malformed++;
+				pr_warn_ratelimited("knod_ipsec: malform-pc-v6len len=%u q%d\n",
+						    desc->len, queue_idx);
+				return false;
+			}
+			ip6h = (struct ipv6hdr *)skb->data;
+			ip6h->nexthdr = desc->feat.next_hdr;
+			ip6h->payload_len = htons(desc->len - 40);
+			skb->protocol = htons(ETH_P_IPV6);
+		} else {
+			struct iphdr *iph;
+
+			if (desc->len < 20) {
+				if (stats_on)
+					s->rx_drop_malformed++;
+				pr_warn_ratelimited("knod_ipsec: malform-pc-v4len len=%u q%d\n",
+						    desc->len, queue_idx);
+				return false;
+			}
+			iph = (struct iphdr *)skb->data;
+			iph->protocol = desc->feat.next_hdr;
+			iph->tot_len = htons(desc->len);
+			iph->check = 0;
+			iph->check = ip_fast_csum((u8 *)iph, iph->ihl);
+			skb->protocol = htons(ETH_P_IP);
+		}
+	} else {
+		/* Tunnel: decrypted payload is a bare inner L3 packet; infer
+		 * v4/v6 from the IP version nibble.
+		 */
+		u8 first = *(const u8 *)skb->data;
+
+		if ((first >> 4) == 4) {
+			skb->protocol = htons(ETH_P_IP);
+		} else if ((first >> 4) == 6) {
+			skb->protocol = htons(ETH_P_IPV6);
+		} else {
+			if (stats_on)
+				s->rx_drop_malformed++;
+			pr_warn_ratelimited("knod_ipsec: malform-pc-tunver first=0x%02x len=%u off=%u q%d\n",
+				first, desc->len, desc->off, queue_idx);
+			return false;
+		}
+	}
+
+	skb->dev = knodev->netdev;
+	skb_reset_mac_header(skb);
+	skb_reset_network_header(skb);
+
+	/* The inner L4 checksum was computed by the sender before encryption
+	 * and ESP authentication guarantees the decrypted payload is byte-
+	 * identical, so trust it instead of recomputing (saves ~1.8% CPU at
+	 * 45+ Gbps UDP).
+	 */
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	/* Attach secpath so xfrm_policy_check() recognises this packet as
+	 * decrypted by an offload engine; without it the inbound policy
+	 * drops the cleartext.
+	 */
+	if (slot->x) {
+		struct sec_path *sp;
+		struct xfrm_offload *xo;
+
+		sp = secpath_set(skb);
+		if (unlikely(!sp)) {
+			if (stats_on)
+				s->rx_drop_malformed++;
+			pr_warn_ratelimited("knod_ipsec: malform-pc-secpath len=%u q%d\n",
+					    desc->len, queue_idx);
+			return false;
+		}
+		xfrm_state_hold(slot->x);
+		sp->xvec[sp->len++] = slot->x;
+		sp->olen++;
+
+		xo = xfrm_offload(skb);
+		xo->flags = CRYPTO_DONE;
+		xo->status = CRYPTO_SUCCESS;
+	}
+
+	if (stats_on) {
+		s->rx_bytes += desc->len;
+		s->drain_delivered++;
+	}
+	return true;
+}
+
+/*
+ * After the GPU completion signal has fired for `work`, finalise it:
+ * SDMA-copy decrypted RX inner packets into per-queue delivery-pool pages
+ * and publish them on the host desc ring. Called only from dispatcher
+ * context. No lock needed: the dispatcher is the sole accessor.
+ */
+static void knod_ipsec_finalise_work(struct knod_ipsec_dispatcher *disp,
+				     struct knod_ipsec_work *work)
+{
+	knod_ipsec_finish_rx_deliver(disp, work);
+
+	if (work->rx_napi) {
+		napi_schedule(work->rx_napi);
+		work->rx_napi = NULL;
+	}
+	/* rx_bds[] clear is deferred to finish_rx_complete /
+	 * finalise_sdma_done for the SDMA path, because the bd
+	 * pointers are needed to mark bd->act = PASS after SDMA
+	 * completes. For the no-SDMA path (n_sdma_pending == 0),
+	 * finalise_inflight clears them inline before returning
+	 * EMPTY.
+	 */
+	if (work->n_sdma_pending == 0)
+		memset(work->rx_bds, 0,
+		       sizeof(work->rx_bds[0]) * work->nr_packets);
+
+	/* Timing stats are now accumulated by the dispatcher
+	 * (try_rx) which has visibility into all phases -
+	 * build / gpu / sdma / finalise. This function no longer
+	 * touches *_gpu_ns.
+	 */
+}
+
+/*
+ * Kick the GPU using kaql[disp->kaql_idx]. Assigns a forward-looking
+ * sigval by decrementing disp->dispatch_sigval_next so each in-flight
+ * slot has a distinct target - required for depth-N pipelining where
+ * multiple dispatches are queued on the same AQL queue and GPU
+ * decrements signal->value by 1 per completion.
+ *
+ * Submit-only: does not wait. The caller is responsible for polling
+ * knod_ipsec_dispatch_done() or blocking via knod_ipsec_dispatch_wait().
+ */
+static void knod_ipsec_dispatch_submit(struct knod_ipsec_dispatcher *disp,
+				       struct knod_ipsec_work *work)
+{
+	struct knod_dispatch_params p;
+
+	disp->dispatch_sigval_next--;
+	work->sigval = disp->dispatch_sigval_next;
+	knod_ipsec_fill_dispatch(disp->priv->knod, work, &p);
+	knod_setup_header(disp->priv->knod, &p, disp->kaql_idx);
+}
+
+/*
+ * Non-blocking completion check. Returns true if the kernel dispatch
+ * for `work` has finished. Used by the pipelined dispatcher loop to
+ * poll in-flight slots without stalling the build side.
+ */
+static bool knod_ipsec_dispatch_done(struct knod_ipsec_dispatcher *disp,
+				     struct knod_ipsec_work *work)
+{
+	struct amd_signal *signal =
+		(struct amd_signal *)disp->priv->knod->kaql[disp->kaql_idx]
+			.queue_signal->kaddr;
+
+	return READ_ONCE(signal->value) <= work->sigval;
+}
+
+/*
+ * Blocking wait. Synchronous path used by the KAT selftest where we
+ * don't want pipelining. Spin-waits with cpu_relax and a best-effort
+ * timeout. In production, the dispatcher uses the non-blocking
+ * dispatch_done() check instead.
+ */
+static void knod_ipsec_dispatch_wait(struct knod_ipsec_dispatcher *disp,
+				     struct knod_ipsec_work *work)
+{
+	struct amd_signal *signal =
+		(struct amd_signal *)disp->priv->knod->kaql[disp->kaql_idx]
+			.queue_signal->kaddr;
+	int timeout = 1000000;
+
+	while (READ_ONCE(signal->value) > work->sigval) {
+		if (--timeout <= 0) {
+			pr_warn_ratelimited("knod_ipsec: GPU signal timeout nr=%d\n",
+					    work->nr_packets);
+			return;
+		}
+		cpu_relax();
+	}
+}
+
+/*
+ * Convenience wrapper: submit + block until done. Keeps the existing
+ * KAT / selftest call sites that expect a synchronous dispatch.
+ */
+static void knod_ipsec_dispatch_and_wait(struct knod_ipsec_dispatcher *disp,
+					 struct knod_ipsec_work *work)
+{
+	knod_ipsec_dispatch_submit(disp, work);
+	knod_ipsec_dispatch_wait(disp, work);
+}
+
+/*
+ * Multi-queue RX drain into one GPU dispatch.
+ *
+ * For each NIC RX queue round-robin'd from *rx_rr, peek up to
+ * `cap_per_q = KNOD_IPSEC_PKT_BATCH / nr_queues` packets and stage them
+ * directly into the fused-shader kernarg sub[] array. This gives strict
+ * per-queue fairness: no single queue can monopolise the batch even if
+ * it has 10k packets backed up. When cap_per_q < 1 we fall back to 1 so
+ * that PKT_BATCH < nr_queues setups still drain something per queue.
+ *
+ * All queues drained in one dispatch must share the same SA table, but
+ * their packets may be for different SAs (each sub[].pkt_addr is an
+ * independent ESP frame with its own SPI); the shader performs the SPI
+ * scan per workgroup. Per-packet rx_pkt_queue[i] is recorded so
+ * finish_rx_deliver() routes each decrypted packet to the matching
+ * priv->rxq[q] delivery pool + desc_ring.
+ *
+ * NAPIs for every queue we touched are scheduled at the end so the
+ * driver-side act_handler sees the INFLIGHT -> PASS/DROP transition and
+ * recycles the netmem pages.
+ */
+static bool knod_ipsec_dispatcher_try_rx(struct knod_ipsec_dispatcher *disp,
+					 struct knod_ipsec_work *work)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	struct knod_dev *knodev = priv->knodev;
+	struct knod_ipsec_fused_param *param;
+	struct {
+		u16 q;
+		u16 count;
+	} per_q[KNOD_SPSC_MAX];
+	int nr_queues, nr_disp_queues, i, q = -1, start;
+	int active, pass, pi;
+	unsigned int total_n = 0;
+	unsigned int cap_per_q;
+	int per_q_n = 0;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+	u64 t_start = 0, t_build_end = 0;
+
+	if (!knodev || !priv->knod || !priv->knod->buf)
+		return false;
+
+	if (stats_on) {
+		t_start = ktime_get_ns();
+		work->sdma_wait_ns = 0;
+		work->rx_sdma_copies = 0;
+		work->rx_sdma_bytes  = 0;
+	}
+
+	nr_queues = knodev->netdev ? knodev->netdev->real_num_rx_queues : 0;
+	if (nr_queues > KNOD_SPSC_MAX)
+		nr_queues = KNOD_SPSC_MAX;
+	if (nr_queues > priv->knod->channels)
+		nr_queues = priv->knod->channels;
+	if (nr_queues <= 0)
+		return false;
+
+	/* This dispatcher's window into the global queue set. Everything
+	 * below indexes with `disp->rxq_first + (rr_offset % nr_disp_queues)`
+	 * so dispatcher N only ever touches queues it owns.
+	 */
+	nr_disp_queues = disp->rxq_count;
+	if (nr_disp_queues > nr_queues - disp->rxq_first)
+		nr_disp_queues = nr_queues - disp->rxq_first;
+	if (nr_disp_queues <= 0)
+		return false;
+
+	/* Count active (non-empty) queues within this dispatcher's range
+	 * so the fair-share cap reflects actual demand. Without this, a
+	 * single-flow iperf3 that only populates 1 out of N RX queues
+	 * would be limited to BATCH/N per dispatch.
+	 */
+	active = 0;
+	for (i = 0; i < nr_disp_queues; i++) {
+		int qi = disp->rxq_first +
+			 ((disp->rx_rr + i) % nr_disp_queues);
+		struct knod_work_priv *wp = &knodev->wpriv[qi];
+		struct spsc_ring *rr = &wp->spsc_bds;
+
+		if (!wp->napi || !rr->slots || rr->mask == 0)
+			continue;
+		if (!priv->knod->buf[qi])
+			continue;
+		if (spsc_count(rr) > 0)
+			active++;
+	}
+	if (active == 0)
+		return false;
+	cap_per_q = DIV_ROUND_UP(READ_ONCE(priv->pkt_batch), active);
+
+	/* Build fused_param directly into kernarg. Zero the entire struct
+	 * so stale sub[batch_n..BATCH-1] entries from previous dispatches
+	 * cannot be picked up by a GPU kernarg prefetch - the GFX9 CP may
+	 * speculatively read beyond grid_size_y into the kernarg buffer,
+	 * and a stale sub[].pkt_addr pointing at valid VRAM could cause
+	 * the shader to process garbage packets (observed as ICV failures
+	 * when the memset was removed).
+	 */
+	param = (struct knod_ipsec_fused_param *)work->param.kaddr;
+	memset(param, 0, sizeof(*param));
+	param->sa_table_addr = cpu_to_le64(priv->sa_table->gaddr);
+	param->t_tables_addr = cpu_to_le64(priv->t_tables->gaddr);
+	param->nr_sa         = cpu_to_le32(KNOD_IPSEC_NR_SA);
+
+	/* Two-pass fair drain.
+	 *
+	 * Pass 1 caps each queue at cap_per_q (= BATCH / active_queues) so
+	 * one queue cannot monopolise the batch when several queues have
+	 * traffic.
+	 *
+	 * Pass 2 fills any remaining batch budget greedily from queues
+	 * that still have packets. This matters for single-flow iperf3
+	 * where only one RX queue is active: pass 1 fills that queue up
+	 * to its fair share (= BATCH for active=1) and pass 2 is a no-op,
+	 * but with a few active queues pass 2 picks up the slack left by
+	 * queues that had fewer than their fair share.
+	 *
+	 * IMPORTANT: we advance the SPSC acquired cursor IMMEDIATELY after
+	 * each per-queue peek so that a subsequent pass re-visiting the
+	 * same queue never re-reads the same packets. Earlier naive 2-pass
+	 * without this acquire double-processed packets and caused ~50%
+	 * anti-replay drops downstream.
+	 */
+	start = disp->rx_rr;
+	for (pass = 0; pass < 2; pass++) {
+		unsigned int per_q_cap = (pass == 0) ?
+			cap_per_q : READ_ONCE(priv->pkt_batch);
+
+		for (i = 0; i < nr_disp_queues; i++) {
+			struct knod_work_priv *wpriv;
+			struct spsc_ring *r;
+			u64 base_gaddr;
+			unsigned int cnt = 0;
+			unsigned int acq_start;
+			unsigned int remaining, budget;
+			int err, k, pi;
+			bool found;
+
+			q = disp->rxq_first +
+			    ((start + i) % nr_disp_queues);
+			wpriv = &knodev->wpriv[q];
+			r = &wpriv->spsc_bds;
+
+			if (!wpriv->napi || !r->slots || r->mask == 0)
+				continue;
+			if (!priv->knod->buf[q])
+				continue;
+
+			remaining = READ_ONCE(priv->pkt_batch) - total_n;
+			if (remaining == 0)
+				break;
+			budget = min(per_q_cap, remaining);
+
+			base_gaddr = priv->knod->buf[q]->gaddr;
+			acq_start = r->acquired;
+
+			err = spsc_peek(r, (void **)&work->rx_bds[total_n],
+					budget, &cnt);
+			if (err || cnt == 0)
+				continue;
+
+			/* Delivery pages are allocated lazily at finish time
+			 * from the framework page_pool; no per-packet slot
+			 * reservation here.
+			 */
+			for (k = 0; k < (int)cnt; k++) {
+				struct spsc_bd *bd = work->rx_bds[total_n + k];
+				u32 ring_idx = (acq_start + k) & r->mask;
+				u64 pkt_addr, bd_gaddr, out_gaddr;
+				unsigned int si = total_n + k;
+
+				pkt_addr = base_gaddr +
+					   ((u64)bd->page_idx << PAGE_SHIFT) +
+					   bd->off;
+				bd_gaddr = wpriv->spsc_pool_gaddr +
+					   (u64)ring_idx * r->elem_stride;
+
+				out_gaddr = work->rx_out_gaddr +
+					    (u64)si *
+					    KNOD_IPSEC_DECRYPT_PKT_SIZE;
+
+				param->sub[si].pkt_addr =
+					cpu_to_le64(pkt_addr);
+				param->sub[si].out_addr =
+					cpu_to_le64(out_gaddr);
+				param->sub[si].bd_addr  =
+					cpu_to_le64(bd_gaddr);
+				param->sub[si].pkt_len  =
+					cpu_to_le32(bd->len);
+				param->sub[si].result_seq = 0;
+
+				work->rx_pkt_queue[si] = (u8)q;
+				bd->act = KNOD_IPSEC_INFLIGHT;
+			}
+
+			/* Advance r->acquired now so pass 2 never
+			 * re-peeks the same entries.
+			 */
+			spsc_acquire(r, NULL, cnt, NULL);
+
+			found = false;
+			for (pi = 0; pi < per_q_n; pi++) {
+				if (per_q[pi].q == (u16)q) {
+					per_q[pi].count += (u16)cnt;
+					found = true;
+					break;
+				}
+			}
+			if (!found) {
+				per_q[per_q_n].q = (u16)q;
+				per_q[per_q_n].count = (u16)cnt;
+				per_q_n++;
+			}
+			total_n += cnt;
+		}
+
+		if (total_n >= READ_ONCE(priv->pkt_batch))
+			break;
+	}
+
+	if (total_n == 0)
+		return false;
+
+	if (static_branch_unlikely(&ipsec_stats_enabled_key)) {
+		struct knod_ipsec_stats *cs = this_cpu_ptr(priv->stats);
+
+		cs->rx_peek_total += total_n;
+	}
+
+	/* spsc_acquire was already called per-queue inside the drain loop
+	 * to prevent the two-pass logic from re-peeking the same entries,
+	 * so there is nothing to commit here.
+	 */
+
+	work->nr_packets = (int)total_n;
+	/* Multi-queue: no single napi. finalise_work will skip its
+	 * rx_napi kick and we schedule per-queue napis below.
+	 */
+	work->rx_napi = NULL;
+	work->rx_queue_idx = per_q[0].q; /* used only by single-queue KAT */
+
+	if (stats_on) {
+		t_build_end = ktime_get_ns();
+		work->t_build_end = t_build_end;
+	}
+
+	if (stats_on) {
+		struct knod_ipsec_stats *s = this_cpu_ptr(priv->stats);
+
+		s->rx_dispatches++;
+		s->rx_batch_total += total_n;
+		if ((u64)total_n > s->rx_batch_max)
+			s->rx_batch_max = total_n;
+	}
+
+	/* Stash per-queue drain bookkeeping so the deferred finalise
+	 * path (called when the dispatch completes, possibly in a later
+	 * dispatcher iteration) can wake the touched NAPIs and attribute
+	 * stats back to this slot.
+	 */
+	work->per_q_n = per_q_n;
+	for (pi = 0; pi < per_q_n; pi++)
+		work->per_q_touched[pi] = per_q[pi].q;
+	work->t_build_start = t_start;
+	work->t_submit = stats_on ? ktime_get_ns() : 0;
+
+	param->sdma_ring_addr = 0;
+	param->sdma_ctl_addr  = 0;
+
+	/* Submit-only: do not wait, do not finalise. The dispatcher loop
+	 * polls knod_ipsec_dispatch_done() and runs finalise via
+	 * knod_ipsec_finalise_inflight() once the completion signal fires.
+	 */
+	knod_ipsec_dispatch_submit(disp, work);
+
+	disp->rx_rr = nr_disp_queues > 0
+		? ((q - disp->rxq_first + 1) % nr_disp_queues)
+		: 0;
+	return true;
+}
+
+/*
+ * Deferred finalise for a slot whose GPU dispatch has completed (signal
+ * fired). Runs finish_rx_deliver(), wakes per-queue
+ * napis tracked by try_rx, and accumulates per-phase timing stats.
+ * Called from the pipelined dispatcher loop once
+ * knod_ipsec_dispatch_done() returns true for the slot.
+ */
+/*
+ * Called when GPU dispatch completes. For RX with SDMA copies, this
+ * transitions to SDMA_PENDING (the dispatcher loop polls the fence
+ * and calls knod_ipsec_finalise_sdma_done when ready). For RX without
+ * SDMA, completes everything inline and returns true so the
+ * caller can transition directly to EMPTY.
+ *
+ * Returns true if fully done (-> EMPTY), false if -> SDMA_PENDING.
+ */
+static bool knod_ipsec_finalise_inflight(struct knod_ipsec_dispatcher *disp,
+					 struct knod_ipsec_work *work)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	struct knod_dev *knodev = priv->knodev;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+	u64 t_gpu_end = 0, t_end = 0;
+	int i;
+
+	if (stats_on)
+		t_gpu_end = ktime_get_ns();
+
+	work->t_finalise_start = t_gpu_end;
+	knod_ipsec_finalise_work(disp, work);
+
+	/* RX path with SDMA copies pending - defer completion until the
+	 * SDMA fence fires. The dispatcher loop will poll sdma_fence_ptr
+	 * and call knod_ipsec_finalise_sdma_done().
+	 */
+	if (work->n_sdma_pending > 0) {
+		if (stats_on) {
+			struct knod_ipsec_stats *s = this_cpu_ptr(priv->stats);
+			u64 build_ns = work->t_build_end - work->t_build_start;
+			u64 gpu_ns = t_gpu_end > work->t_submit
+				? t_gpu_end - work->t_submit : 0;
+
+			s->rx_build_ns += build_ns;
+			s->rx_gpu_ns   += gpu_ns;
+			s->rx_sdma_copies_total += work->rx_sdma_copies;
+			s->rx_sdma_bytes_total  += work->rx_sdma_bytes;
+			if (work->rx_sdma_copies > s->rx_sdma_copies_max)
+				s->rx_sdma_copies_max = work->rx_sdma_copies;
+		}
+		return false;   /* -> SDMA_PENDING */
+	}
+
+	/* No SDMA copies - mark bds PASS and schedule NAPIs. */
+	for (i = 0; i < work->nr_packets; i++) {
+		if (work->rx_bds[i])
+			work->rx_bds[i]->act = KNOD_IPSEC_PASS;
+	}
+	if (knodev) {
+		for (i = 0; i < work->per_q_n; i++) {
+			struct knod_work_priv *wpriv =
+				&knodev->wpriv[work->per_q_touched[i]];
+
+			knod_napi_kick(wpriv);
+		}
+	}
+
+	if (stats_on) {
+		struct knod_ipsec_stats *s = this_cpu_ptr(priv->stats);
+
+		t_end = ktime_get_ns();
+
+		/* RX no-SDMA: all stats fit here. The SDMA path
+		 * records build/gpu stats in the early-return above
+		 * and sdma/finalise stats in finalise_sdma_done().
+		 */
+		u64 build_ns = work->t_build_end - work->t_build_start;
+		u64 gpu_ns = t_gpu_end > work->t_submit
+			? t_gpu_end - work->t_submit : 0;
+		u64 finalise_ns = t_end > t_gpu_end
+			? t_end - t_gpu_end : 0;
+
+		s->rx_build_ns    += build_ns;
+		s->rx_gpu_ns      += gpu_ns;
+		s->rx_finalise_ns += finalise_ns;
+		s->rx_total_ns    += t_end - work->t_build_start;
+	}
+
+	/* Clear slot state so the dispatcher can reuse this work entry. */
+	work->per_q_n = 0;
+	work->nr_packets = 0;
+	work->sdma_wait_ns = 0;
+	work->rx_sdma_copies = 0;
+	work->rx_sdma_bytes = 0;
+	work->n_sdma_pending = 0;
+
+	return true;  /* -> EMPTY */
+}
+
+/*
+ * SDMA fence has fired for a slot in SDMA_PENDING. Publish desc_ring
+ * entries, mark bds PASS, schedule NAPIs, accumulate remaining stats,
+ * and clear the slot for reuse.
+ */
+static void knod_ipsec_finalise_sdma_done(struct knod_ipsec_dispatcher *disp,
+					  struct knod_ipsec_work *work)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	bool stats_on = static_branch_unlikely(&ipsec_stats_enabled_key);
+
+	knod_ipsec_finish_rx_complete(disp, work);
+
+	/* Schedule NAPIs now that bds are marked PASS. */
+	if (priv->knodev) {
+		int i;
+
+		for (i = 0; i < work->per_q_n; i++) {
+			struct knod_work_priv *wpriv =
+				&priv->knodev->wpriv[work->per_q_touched[i]];
+
+			knod_napi_kick(wpriv);
+		}
+	}
+
+	if (stats_on) {
+		struct knod_ipsec_stats *s = this_cpu_ptr(priv->stats);
+		u64 t_end = ktime_get_ns();
+		u64 finalise_ns = t_end > work->t_finalise_start
+			? t_end - work->t_finalise_start : 0;
+
+		if (finalise_ns > work->sdma_wait_ns)
+			finalise_ns -= work->sdma_wait_ns;
+		else
+			finalise_ns = 0;
+
+		s->rx_sdma_ns     += work->sdma_wait_ns;
+		s->rx_finalise_ns += finalise_ns;
+		s->rx_total_ns    += t_end - work->t_build_start;
+	}
+
+	work->per_q_n = 0;
+	work->nr_packets = 0;
+	work->sdma_wait_ns = 0;
+	work->rx_sdma_copies = 0;
+	work->rx_sdma_bytes = 0;
+	work->n_sdma_pending = 0;
+}
+
+/*
+ * Pipelined dispatcher kthread. Each dispatcher owns one kaql[i] /
+ * sdma[i] pair, a private slice of the work_pool, and a contiguous
+ * range of RX queues. Up to KNOD_IPSEC_NR_WORK dispatches
+ * may be in-flight on this AQL queue at once. Each iteration:
+ *
+ *   1) Scan INFLIGHT slots within this disp's slice, finalise any
+ *      whose completion signal fired.
+ *   2) Scan EMPTY slots in the same slice, try to build+submit one RX
+ *      batch into it.
+ *   3) If nothing happened (no work to finalise, nothing to build),
+ *      idle (usleep or cpu_relax spins).
+ *
+ * With nr_dispatchers > 1 the AQL queues run independently on the
+ * GPU - disjoint CU allocations per kaql - so two dispatchers get
+ * real parallel execution on the GPU. Within a single dispatcher,
+ * kaql[i] is FIFO: dispatches complete in submission order, and each
+ * slot's work->sigval is assigned a distinct target by
+ * dispatch_submit() so dispatch_done() can distinguish completions
+ * of different in-flight slots.
+ *
+ * No cross-dispatcher synchronisation on the hot path: each disp
+ * only touches its own rxq range and its own work slice.
+ * The shared SA table, slot array and per-CPU stats are read-mostly
+ * or percpu respectively.
+ */
+static int knod_ipsec_dispatcher(void *arg)
+{
+	struct knod_ipsec_dispatcher *disp = arg;
+	struct knod_ipsec_priv *priv = disp->priv;
+	int i;
+
+	while (!kthread_should_stop()) {
+		bool did_work = false;
+
+		if (kthread_should_park()) {
+			knod_ipsec_dispatcher_drain(disp);
+			kthread_parkme();
+			continue;
+		}
+
+		/* Phase 1a: finalise any INFLIGHT slot whose GPU work done. */
+		for (i = 0; i < disp->work_count; i++) {
+			struct knod_ipsec_work *w =
+				&priv->work_pool[disp->work_first + i];
+
+			if (w->state != KNOD_WORK_INFLIGHT)
+				continue;
+			if (!knod_ipsec_dispatch_done(disp, w))
+				continue;
+
+			if (knod_ipsec_finalise_inflight(disp, w))
+				w->state = KNOD_WORK_EMPTY;
+			else
+				w->state = KNOD_WORK_SDMA_PENDING;
+			did_work = true;
+		}
+
+		/*
+		 * Phase 1b: complete any SDMA_PENDING slot whose fence
+		 * fired.
+		 */
+		for (i = 0; i < disp->work_count; i++) {
+			struct knod_ipsec_work *w =
+				&priv->work_pool[disp->work_first + i];
+
+			if (w->state != KNOD_WORK_SDMA_PENDING)
+				continue;
+			if (!knod_ipsec_fence_passed(w))
+				continue;
+
+			knod_ipsec_finalise_sdma_done(disp, w);
+			w->state = KNOD_WORK_EMPTY;
+			did_work = true;
+		}
+
+		/* Phase 2: try to build + submit into at most one EMPTY slot
+		 * per iteration. Limiting to one per iteration keeps phase-1
+		 * polling responsive so completions don't queue up while we
+		 * greedily fill every empty slot.
+		 */
+		for (i = 0; i < disp->work_count; i++) {
+			int idx = (disp->build_cursor + i) % disp->work_count;
+			struct knod_ipsec_work *w =
+				&priv->work_pool[disp->work_first + idx];
+
+			if (w->state != KNOD_WORK_EMPTY)
+				continue;
+
+			if (knod_ipsec_dispatcher_try_rx(disp, w)) {
+				w->state = KNOD_WORK_INFLIGHT;
+				did_work = true;
+				disp->build_cursor =
+					(idx + 1) % disp->work_count;
+				break;
+			}
+		}
+
+		if (priv->knodev) {
+			int q;
+
+			for (q = disp->rxq_first;
+			     q < disp->rxq_first + disp->rxq_count;
+			     q++) {
+				struct knod_work_priv *wp =
+					&priv->knodev->wpriv[q];
+
+				if (!spsc_empty(&wp->pass_pending))
+					knod_napi_kick(wp);
+			}
+		}
+
+		if (!did_work) {
+			u64 idle_t0 = 0;
+			bool stats_on =
+			    static_branch_unlikely(&ipsec_stats_enabled_key);
+
+			if (stats_on)
+				idle_t0 = ktime_get_ns();
+
+			if (READ_ONCE(knod_ipsec_poll_mode)) {
+				/* Busy-poll: spin a small number of times with
+				 * cpu_relax() so newly-produced SPSC entries or
+				 * completions are picked up in <1us.
+				 */
+				int spins = 64;
+
+				while (spins-- > 0)
+					cpu_relax();
+			} else {
+				usleep_range(20, 100);
+			}
+
+			if (stats_on)
+				this_cpu_ptr(priv->stats)->rx_idle_ns +=
+					ktime_get_ns() - idle_t0;
+		}
+	}
+
+	knod_ipsec_dispatcher_drain(disp);
+	return 0;
+}
+
+static void knod_ipsec_dispatcher_drain(struct knod_ipsec_dispatcher *disp)
+{
+	struct knod_ipsec_priv *priv = disp->priv;
+	int i;
+
+	for (i = 0; i < disp->work_count; i++) {
+		struct knod_ipsec_work *w =
+			&priv->work_pool[disp->work_first + i];
+
+		if (w->state == KNOD_WORK_INFLIGHT) {
+			knod_ipsec_dispatch_wait(disp, w);
+			if (!knod_ipsec_finalise_inflight(disp, w)) {
+				/*
+				 * SDMA started - spin-wait, we can't
+				 * defer.
+				 */
+				knod_ipsec_fence_wait(w);
+				knod_ipsec_finalise_sdma_done(disp, w);
+			}
+			w->state = KNOD_WORK_EMPTY;
+		} else if (w->state == KNOD_WORK_SDMA_PENDING) {
+			knod_ipsec_fence_wait(w);
+			knod_ipsec_finalise_sdma_done(disp, w);
+			w->state = KNOD_WORK_EMPTY;
+		}
+	}
+}
+
+/*
+ * Work slot pool allocator.
+ *
+ * `work_pool[0..KNOD_IPSEC_NR_WORK-1]` are pipelined work slots owned by
+ * the dispatcher kthread. Each slot gets its own slice of the param /
+ * decrypt pool BOs - single large BOs avoid the multi-BO GPU-VA
+ * mapping bug. KAT / selftest code paths always run against slot 0.
+ *
+ */
+static int knod_ipsec_work_pool_alloc(struct knod_ipsec_priv *priv)
+{
+	/* Round the kernarg pool up to a power-of-two page count so we never
+	 * hit the 7-page (or other non-pow2) VRAM alloc bug the KNOD
+	 * allocator triggers on certain sizes. At PKT_BATCH=512 fused_param
+	 * is ~16 KB = 4 pages (already pow2). At BATCH=1024 it is ~32 KB = 8
+	 * pages. Harmless extra slack otherwise.
+	 */
+	const size_t param_raw_bytes =
+		ALIGN(sizeof(struct knod_ipsec_fused_param), PAGE_SIZE);
+	const unsigned long param_raw_pages = param_raw_bytes >> PAGE_SHIFT;
+	const unsigned long param_pages =
+		param_raw_pages <= 1 ? 1 : roundup_pow_of_two(param_raw_pages);
+	const size_t param_stride = param_pages << PAGE_SHIFT;
+	struct amd_signal *signal;
+	int nr_disp = priv->nr_dispatchers;
+	int d, i;
+
+	if (nr_disp < 1)
+		nr_disp = 1;
+	if (nr_disp > KNOD_IPSEC_MAX_DISPATCHERS)
+		nr_disp = KNOD_IPSEC_MAX_DISPATCHERS;
+	priv->nr_dispatchers = nr_disp;
+
+	memset(priv->work_pool, 0, sizeof(priv->work_pool));
+
+	for (d = 0; d < nr_disp; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+		disp->priv = priv;
+		disp->kthread = NULL;
+		disp->kaql_idx = d;
+		disp->work_first = d * KNOD_IPSEC_NR_WORK;
+		disp->work_count = KNOD_IPSEC_NR_WORK;
+		disp->rx_rr = 0;
+		disp->build_cursor = 0;
+
+		/* GTT (not VRAM) for param_pool so the dispatcher CPU
+		 * can read sub[].pkt_addr / sub[].out_addr back in
+		 * finish_rx_deliver via WB cache rather than WC PCIe.
+		 */
+		disp->param_pool = knod_alloc_mem(priv->knod,
+			ALIGN(param_stride * KNOD_IPSEC_NR_WORK, PAGE_SIZE),
+			KFD_IOC_ALLOC_MEM_FLAGS_GTT |
+			KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+			KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+		if (IS_ERR(disp->param_pool)) {
+			int err = PTR_ERR(disp->param_pool);
+
+			disp->param_pool = NULL;
+			return err;
+		}
+
+		/* +KNOD_IPSEC_GTT_OUT_L3_OFF: 20 B headroom so the
+		 * shader's "L3 header -> out_addr - L3_OFF" write has a
+		 * valid GPU VM target when a SLOT_NONE fallback directs
+		 * output here. Each work slot's rx_out_gaddr includes
+		 * this offset.
+		 */
+		disp->decrypt_pool = knod_alloc_mem(priv->knod,
+			KNOD_IPSEC_DECRYPT_WORK_SIZE * KNOD_IPSEC_NR_WORK +
+				KNOD_IPSEC_GTT_OUT_L3_OFF,
+			KFD_IOC_ALLOC_MEM_FLAGS_VRAM |
+			KFD_IOC_ALLOC_MEM_FLAGS_WRITABLE |
+			KFD_IOC_ALLOC_MEM_FLAGS_COHERENT);
+		if (IS_ERR(disp->decrypt_pool)) {
+			int err = PTR_ERR(disp->decrypt_pool);
+
+			disp->decrypt_pool = NULL;
+			return err;
+		}
+
+		for (i = 0; i < KNOD_IPSEC_NR_WORK; i++) {
+			struct knod_ipsec_work *work =
+				&priv->work_pool[disp->work_first + i];
+
+			memset(work, 0, sizeof(*work));
+			work->state = KNOD_WORK_EMPTY;
+			work->param.kaddr = (u8 *)disp->param_pool->kaddr +
+					    (size_t)i * param_stride;
+			work->param.gaddr = disp->param_pool->gaddr +
+					    (u64)i * param_stride;
+			work->rx_out_gaddr = disp->decrypt_pool->gaddr +
+				KNOD_IPSEC_GTT_OUT_L3_OFF +
+				(u64)i * KNOD_IPSEC_DECRYPT_WORK_SIZE;
+		}
+
+		/* Initialise this dispatcher's forward-looking sigval
+		 * counter from its kaql[d] completion signal. Every
+		 * submit decrements this so each in-flight slot has a
+		 * distinct target.
+		 */
+		signal = (struct amd_signal *)
+			priv->knod->kaql[d].queue_signal->kaddr;
+		disp->dispatch_sigval_next = READ_ONCE(signal->value);
+
+		pr_info("knod_ipsec: disp[%d] param=0x%llx decrypt=0x%llx kaql=%d\n",
+			d, (u64)disp->param_pool->gaddr,
+			(u64)disp->decrypt_pool->gaddr,
+			disp->kaql_idx);
+	}
+
+	return 0;
+}
+
+static void knod_ipsec_work_pool_free(struct knod_ipsec_priv *priv)
+{
+	int d;
+
+	for (d = 0; d < KNOD_IPSEC_MAX_DISPATCHERS; d++) {
+		struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+		if (disp->decrypt_pool) {
+			knod_free_mem(priv->knod, disp->decrypt_pool);
+			disp->decrypt_pool = NULL;
+		}
+		if (disp->param_pool) {
+			knod_free_mem(priv->knod, disp->param_pool);
+			disp->param_pool = NULL;
+		}
+	}
+	memset(priv->work_pool, 0, sizeof(priv->work_pool));
+}
+
+
+/* ========================================================================
+ * Phase 5: in-kernel KAT (randomized + dispatch smoke)
+ * ========================================================================
+ *
+ * Two-layer validation:
+ *
+ *   1) CPU layer - randomized H-table check
+ *      For each supported AES key length (128/192/256), run N iterations:
+ *      generate a fresh random key, compute the reference H = AES_K(0^128)
+ *      via the kernel's verified <crypto/aes.h> library, then recompute the
+ *      same H via our gcm_core helper (which will be used on the GPU path)
+ *      and require a bytewise match. This exercises aes_prepareenckey /
+ *      aes_encrypt for every round count and the downstream gf128 squaring
+ *      chain that builds the H-power table. No hand-computed constants.
+ *
+ *   2) GPU layer - multi-packet shader dispatch smoke test
+ *      Run the fused RX shader at several batch sizes (1, 8, 32, 64) with
+ *      each sub[i].bd_addr pointing at a distinct fake spsc_bd slot inside
+ *      a single scratch BO. Pre-stamp each bd->act with a UNIQUE sentinel
+ *      (sentinel base XORed with packet index) and verify the shader
+ *      rewrites ALL slots to XDP_PASS. This covers workgroup_id_y indexing
+ *      in the shader + variable grid dimensions in the AQL packet. When
+ *      the real RX crypto shader lands, the per-slot verification can be
+ *      upgraded to "decrypted inner packet matches expected plaintext".
+ *
+ * Randomness seeds vary per run so repeated `echo 1 > selftest` covers a
+ * widening input space over time. The shader layer is O(ms); the CPU
+ * layer runs in microseconds per iteration.
+ */
+
+#define KNOD_IPSEC_KAT_RAND_ROUNDS	16
+
+static int knod_ipsec_last_kat_result = -1;
+static char knod_ipsec_last_kat_detail[256];
+
+static int knod_ipsec_kat_h_one(const u8 *key, int key_len)
+{
+	u8 h_table[KNOD_GCM_H_TABLE_SIZE];
+	struct aes_enckey enckey;
+	u8 zero[AES_BLOCK_SIZE] = {};
+	u8 h_ref[AES_BLOCK_SIZE];
+	int rc;
+
+	rc = aes_prepareenckey(&enckey, key, key_len);
+	if (rc)
+		return rc;
+	aes_encrypt(&enckey, h_ref, zero);
+	memzero_explicit(&enckey, sizeof(enckey));
+
+	memset(h_table, 0, sizeof(h_table));
+	knod_gcm_precompute_h_table(key, key_len, h_table);
+
+	return memcmp(h_table, h_ref, AES_BLOCK_SIZE) == 0 ? 0 : -EBADMSG;
+}
+
+static int knod_ipsec_run_cpu_kat(void)
+{
+	static const int key_lens[] = { 16, 24, 32 };
+	u8 key[32];
+	int i, r, failed = 0;
+
+	for (i = 0; i < ARRAY_SIZE(key_lens); i++) {
+		int kl = key_lens[i];
+		int round_fail = 0;
+
+		for (r = 0; r < KNOD_IPSEC_KAT_RAND_ROUNDS; r++) {
+			get_random_bytes(key, kl);
+			if (knod_ipsec_kat_h_one(key, kl)) {
+				pr_err("knod_ipsec: H-KAT aes%d round=%d FAIL\n",
+				       kl * 8, r);
+				round_fail++;
+			}
+		}
+		if (round_fail) {
+			failed += round_fail;
+		} else {
+			pr_info("knod_ipsec: H-KAT aes%d ok (%d random rounds)\n",
+				kl * 8, KNOD_IPSEC_KAT_RAND_ROUNDS);
+		}
+	}
+	memzero_explicit(key, sizeof(key));
+	return failed;
+}
+
+/*
+ * Shader-dispatch smoke test (post 32d.2 architecture pivot).
+ *
+ * Uses the persistent priv->kat_scratch BO as a private sandbox for both
+ * per-packet spsc_bd slots and synthetic ESP packet buffers:
+ *
+ *   scratch[0 .. nr*64)                 -- spsc_bd slots (act at +i*64+8)
+ *   scratch[pkt_region_base + i*64 ..)  -- ETH+IPv4+ESP synthetic packet
+ *
+ * Each synthetic packet gets a unique SPI = SPI_KAT_BASE | i written in
+ * network byte order at ESP header offset (14 ETH + 20 IPv4 = 34). The
+ * corresponding slot in priv->sa_table is pre-populated with the same
+ * SPI (in host byte order) at index i. The fused RX shader reads
+ * sub[wg_id_y].pkt_addr, loads the BE SPI from pkt+34, byteswaps it,
+ * linear-scans priv->sa_table for a match, and writes the matching
+ * slot_idx (as u64) into bd->act.
+ *
+ * Verification scope (single pass):
+ *   - even i (IPv4): bd->act high32 == 0xFFFFFFFD (ICV fail - garbage
+ *     keys mean decryption produces wrong tag, but the full crypto
+ *     pipeline runs to completion proving SPI scan + dispatch work)
+ *   - odd  i (IPv6): bd->act high32 == 0xFFFFFFFD (ICV fail - same as
+ *     IPv4 but exercises the IPv6 ESP offset path; SPI at +54)
+ *
+ * The 32d.1/32d.2 in-shader replay bitmap path has been removed (the
+ * sliding window now lives CPU-side in the NIC dd NAPI), so the
+ * second dispatch pass and the replay_bitmap_addr/readback block have
+ * been dropped. End-to-end worker->desc_ring->NIC-dd delivery is covered
+ * by the userspace selftest `knod_ipsec_offload.sh`, not by this KAT.
+ */
+static int knod_ipsec_run_shader_kat_n(struct knod_ipsec_priv *priv, int nr)
+{
+	static const u64 SENTINEL_BASE = 0xDEADBEEFCAFEBABEULL;
+	static const u32 SPI_KAT_BASE  = 0xDECAF000u;
+	const size_t SLOT_STRIDE = 64;
+	/* must fit IPv6 ESP minimum (86B overhead) */
+	const size_t PKT_STRIDE  = 128;
+	/* Heap-backed sub[] - at BATCH=512 the stack copy would be 16 KB
+	 * and overflow the dispatcher kernel stack. KAT is cold path, so
+	 * kvmalloc is fine.
+	 */
+	struct knod_ipsec_sa_entry *e_dbg;
+	struct knod_ipsec_sa_entry *e;
+	struct knod_ipsec_work *dbg_work;
+	struct knod_ipsec_fused_sub *sub;
+	struct amd_signal *sig;
+	struct knod_mem *scratch;
+	void *sa_backup = NULL;
+	size_t bd_region;
+	size_t pkt_region_base;
+	int written_final = 0;
+	s64 sig_before;
+	u64 dbg16 = 0;
+	int ret = 0;
+	int tries, i;
+
+	if (nr < 1 || nr > KNOD_IPSEC_KAT_MAX_BATCH)
+		return -EINVAL;
+
+	sub = kvcalloc(KNOD_IPSEC_KAT_MAX_BATCH, sizeof(*sub), GFP_KERNEL);
+	if (!sub) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch[%d] FAIL: sub alloc", nr);
+		return -ENOMEM;
+	}
+
+	bd_region       = SLOT_STRIDE * nr;
+	pkt_region_base = ALIGN(bd_region, 64);
+	if (pkt_region_base + nr * PKT_STRIDE > PAGE_SIZE * 4) {
+		ret = -EINVAL; /* defensive; kat_scratch is 4 pages */
+		goto out_free;
+	}
+
+	/* Reuse the persistent per-priv scratch BO - see priv->kat_scratch */
+	scratch = priv->kat_scratch;
+	if (!scratch) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch[%d] FAIL: kat_scratch not allocated",
+			  nr);
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	memset(scratch->kaddr, 0, PAGE_SIZE * 4);
+
+	/* Back up the production SA table before trashing it with KAT
+	 * fixtures. Without this, any production SA installed by the user
+	 * (e.g. via `ip xfrm state add`) gets wiped when the KAT wipes the
+	 * SA BO at exit, which causes a subsequent production dispatch
+	 * to load key_gpu_addr=0 -> VM fault at address 0.
+	 */
+	sa_backup = kvmalloc(KNOD_IPSEC_SA_BO_SIZE, GFP_KERNEL);
+	if (!sa_backup) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch[%d] FAIL: sa_backup alloc", nr);
+		ret = -ENOMEM;
+		goto out_free;
+	}
+	memcpy(sa_backup, priv->sa_table->kaddr, KNOD_IPSEC_SA_BO_SIZE);
+
+	/* Pre-populate priv->sa_table[0..nr) with one entry per synthetic
+	 * packet. Entry i carries spi = SPI_KAT_BASE | i in host byte order
+	 * (the table is CPU-side LE and the shader reads it as a host u32).
+	 * Higher-index slots are zeroed first so a previous KAT iteration
+	 * at larger nr cannot leak into a smaller one.
+	 */
+	BUILD_BUG_ON(sizeof(struct knod_ipsec_sa_entry) != 104);
+	BUILD_BUG_ON(KNOD_IPSEC_NR_SA < KNOD_IPSEC_KAT_MAX_BATCH);
+	e = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr;
+
+	/* Wipe entries + replay bitmap region (one BO). Size is
+	 * ALIGNed to 8 pages in the alloc path to dodge the KNOD VRAM
+	 * 7-page alloc bug; the logical payload is still SA_BO_SIZE.
+	 */
+	memset(e, 0, KNOD_IPSEC_SA_BO_SIZE);
+	for (i = 0; i < nr; i++) {
+		e[i].spi    = cpu_to_le32(SPI_KAT_BASE | (u32)i);
+		e[i].active = cpu_to_le32(1);
+		/* Full crypto shader loads key/htable/t_tables from
+		 * the SA entry after scan hit. Point them at valid
+		 * GPU addresses to avoid NULL page faults. The data
+		 * is garbage so decryption will produce ICV mismatch,
+		 * but the dispatch will complete without a VM fault.
+		 */
+		e[i].key_gpu_addr = cpu_to_le64(scratch->gaddr);
+		e[i].htable_gpu_addr = cpu_to_le64(scratch->gaddr);
+		e[i].t_tables_gpu_addr = cpu_to_le64(
+			priv->t_tables ? priv->t_tables->gaddr :
+			scratch->gaddr);
+		e[i].key_len    = cpu_to_le32(16);
+		e[i].nr_rounds  = cpu_to_le32(10);
+	}
+	/* publish the key-table writes to WC VRAM before dispatch */
+	wmb();
+
+	/* sub was zero-filled by kvcalloc at entry. */
+	for (i = 0; i < nr; i++) {
+		u64 *act_i = (u64 *)((u8 *)scratch->kaddr +
+				     i * SLOT_STRIDE + 8);
+		u8  *pkt_i = (u8 *)scratch->kaddr +
+			     pkt_region_base + i * PKT_STRIDE;
+		__be32 spi_be = cpu_to_be32(SPI_KAT_BASE | (u32)i);
+		bool is_ipv4 = !(i & 1);
+
+		/* Pre-stamp bd->act with a sentinel so an untouched slot is
+		 * distinguishable from one that was overwritten with the SPI.
+		 */
+		*act_i = SENTINEL_BASE ^ (u64)i;
+
+		/* Alternate IPv4 / IPv6 packets per slot to exercise both
+		 * code paths in the same batch. Even i: standard IPv4 header
+		 * (version=4, IHL=5 -> byte 0x45), SPI at offset 34.
+		 * Odd i: IPv6 header (version=6 -> byte 0x60), SPI at
+		 * offset 54. Both hit the SA scan, both get ICV fail
+		 * (since ciphertext is garbage).
+		 */
+		pkt_i[14] = is_ipv4 ? 0x45 : 0x60;
+		if (is_ipv4)
+			memcpy(pkt_i + 34, &spi_be, sizeof(spi_be));
+		else
+			memcpy(pkt_i + 54, &spi_be, sizeof(spi_be));
+
+		sub[i].pkt_addr = cpu_to_le64(scratch->gaddr +
+					      pkt_region_base + i * PKT_STRIDE);
+		sub[i].out_addr = sub[i].pkt_addr;
+		sub[i].bd_addr  = cpu_to_le64(scratch->gaddr +
+					      i * SLOT_STRIDE);
+		sub[i].pkt_len  = cpu_to_le32(PKT_STRIDE);
+	}
+	/* publish the sub-descriptor writes to WC VRAM before dispatch */
+	wmb();
+
+	/* Single dispatch: post-32d.2 architecture has no in-shader replay,
+	 * so the KAT only validates the fresh scan-hit path (+ the IPv6
+	 * IPv6 ESP offset path). End-to-end worker->desc_ring->NAPI delivery
+	 * is covered by the userspace selftest, not here.
+	 */
+	/* Force the dispatch onto queue 0 so the signal we observe below is
+	 * actually the one CP updates. The public rx_submit() picks a queue
+	 * by smp_processor_id(), which would let the KAT measure a queue it
+	 * never submitted to and see a stale sig=-1 forever.
+	 */
+	sig = (struct amd_signal *)
+		priv->knod->kaql[0].queue_signal->kaddr;
+	sig_before = READ_ONCE(sig->value);
+	dbg_work = &priv->work_pool[0];
+
+	e_dbg = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr;
+
+	pr_info("knod_ipsec: KAT[%d] scratch.gaddr=0x%llx work.param.gaddr=0x%llx kernel.gaddr=0x%llx sa_table.gaddr=0x%llx cpu-readback: entry[0].spi=0x%08x entry[1].spi=0x%08x\n",
+		nr,
+		(u64)scratch->gaddr,
+		(u64)dbg_work->param.gaddr,
+		(u64)priv->knod->kernels[0]->gaddr,
+		(u64)priv->sa_table->gaddr,
+		le32_to_cpu(e_dbg[0].spi),
+		le32_to_cpu(e_dbg[1].spi));
+
+	if (priv->disp[0].kthread)
+		kthread_park(priv->disp[0].kthread);
+	knod_ipsec_prepare_rx_dispatch(priv, dbg_work, sub, NULL,
+				       nr, NULL, 0);
+	knod_ipsec_dispatch_and_wait(&priv->disp[0], dbg_work);
+	if (priv->disp[0].kthread)
+		kthread_unpark(priv->disp[0].kthread);
+	ret = 0;
+	pr_info("knod_ipsec: shader-dispatch[%d] submitted, signal %lld -> (done)\n",
+		nr, sig_before);
+
+	/* bd->act is packed as
+	 *    low  = s22 = scan target SPI
+	 *    high = s26 = final result
+	 *      even i (IPv4): ICV fail -> 0xFFFFFFFD
+	 *      odd  i (IPv6): ICV fail -> 0xFFFFFFFD
+	 *      scan miss    : 0xFFFFFFFF
+	 *
+	 * Both IPv4 and IPv6 paths run the full crypto pipeline. The SPI
+	 * is placed at the correct offset (34 for v4, 54 for v6) so the
+	 * SA scan finds a match, then decrypt + ICV check fails on garbage.
+	 */
+	written_final = 0;
+#define KAT_EXPECT_LOW_MASK  (0ULL)
+/* Both IPv4 and IPv6 slots: full crypto pipeline -> ICV mismatch
+ * -> verdict = VERDICT_ICV_FAIL (0xFFFFFFFD).
+ */
+#define KAT_EXPECT_FOR_SLOT						\
+	(((u64)KNOD_IPSEC_SHADER_VERDICT_ICV_FAIL << 32) | 0ULL)
+
+	for (tries = 0; tries < 500; tries++) {
+		int w = 0;
+
+		for (i = 0; i < nr; i++) {
+			u64 expect = KAT_EXPECT_FOR_SLOT;
+			u64 mask = 0xFFFFFFFF00000000ULL |
+				   KAT_EXPECT_LOW_MASK;
+			u64 v = READ_ONCE(*(u64 *)(
+				(u8 *)scratch->kaddr +
+				i * SLOT_STRIDE + 8));
+			if ((v & mask) == (expect & mask))
+				w++;
+		}
+		if (w == nr) {
+			written_final = w;
+			break;
+		}
+		written_final = w;
+		usleep_range(500, 1000);
+	}
+
+	if (written_final != nr) {
+		int first_ok = -1, first_bad = -1, last_ok = -1;
+		u64 first_bad_val = 0;
+		u64 first_bad_expect = 0;
+		struct amd_signal *sig = (struct amd_signal *)
+			priv->knod->kaql[0].queue_signal->kaddr;
+		s64 sig_after = READ_ONCE(sig->value);
+
+		for (i = 0; i < nr; i++) {
+			u64 expect = KAT_EXPECT_FOR_SLOT;
+			u64 mask = 0xFFFFFFFF00000000ULL |
+				   KAT_EXPECT_LOW_MASK;
+			u64 v = READ_ONCE(*(u64 *)(
+				(u8 *)scratch->kaddr +
+				i * SLOT_STRIDE + 8));
+			if ((v & mask) == (expect & mask)) {
+				if (first_ok < 0)
+					first_ok = i;
+				last_ok = i;
+			} else if (first_bad < 0) {
+				first_bad = i;
+				first_bad_val = v;
+				first_bad_expect = expect;
+			}
+		}
+		dbg16 = 0;
+		if (first_bad >= 0) {
+			dbg16 = READ_ONCE(*(u64 *)(
+				(u8 *)scratch->kaddr +
+				first_bad * SLOT_STRIDE + 16));
+		}
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch[%d] FAIL written=%d/%d first_bad=%d got=0x%llx (low=0x%08x high=0x%08x) expect=0x%llx sig_after=%lld first_ok=%d last_ok=%d dbg[s27,s23]=0x%08x 0x%08x",
+			  nr, written_final, nr,
+			  first_bad, first_bad_val,
+			  (u32)first_bad_val,
+			  (u32)(first_bad_val >> 32),
+			  first_bad_expect, sig_after,
+			  first_ok, last_ok,
+			  (u32)dbg16,
+			  (u32)(dbg16 >> 32));
+		pr_err("knod_ipsec: %s\n", knod_ipsec_last_kat_detail);
+		ret = -EIO;
+		goto out_free;
+	}
+#undef KAT_EXPECT_FOR_SLOT
+#undef KAT_EXPECT_LOW_MASK
+
+	pr_info("knod_ipsec: shader-dispatch[%d] ok (%d slots, %d us poll)\n",
+		nr, nr, tries * 750);
+
+out_free:
+	/* Restore the production SA table we saved at entry. Never wipe -
+	 * wiping would destroy any live xfrm SAs installed by userspace.
+	 */
+	if (sa_backup) {
+		memcpy(priv->sa_table->kaddr, sa_backup, KNOD_IPSEC_SA_BO_SIZE);
+		/* publish the restored SA table to the GPU */
+		wmb();
+		kvfree(sa_backup);
+	}
+	kvfree(sub);
+	return ret;
+}
+
+/* ========================================================================
+ * Crypto KAT: end-to-end AES-GCM decrypt verification via GPU shader
+ *
+ * Builds a synthetic ESP packet with known AES-128-GCM ciphertext+ICV,
+ * dispatches the fused RX shader, and verifies the decrypted output
+ * matches the expected plaintext. This exercises the full decrypt
+ * pipeline: T-table load, CTR decrypt, parallel GHASH, ICV verify,
+ * ESP trailer strip.
+ *
+ * Layout in kat_scratch (2 pages = 8192B):
+ *   [0x0000..0x003F]  bd slot (64B, act at +8)
+ *   [0x0040..0x00FF]  out buffer for decrypted output (192B)
+ *   [0x0100..0x01FF]  expanded AES round keys (256B)
+ *   [0x0200..0x02FF]  synthetic ESP packet (256B)
+ *   [0x1000..0x1FFF]  GHASH H-power table (4096B)
+ * ========================================================================
+ */
+
+/* GF(2^128) multiply for reference GHASH - identical to gcm_core but
+ * local to avoid exporting an internal helper for test-only use.
+ */
+static void kat_gf128_mul(u64 r[2], const u64 a[2], const u64 b[2])
+{
+	u64 v[2], z[2];
+	int i, j;
+
+	v[0] = a[0]; v[1] = a[1];
+	z[0] = 0;    z[1] = 0;
+
+	for (i = 0; i < 2; i++) {
+		u64 x = b[i];
+
+		for (j = 63; j >= 0; j--) {
+			if ((x >> j) & 1) {
+				z[0] ^= v[0];
+				z[1] ^= v[1];
+			}
+			if (v[1] & 1) {
+				v[1] = (v[1] >> 1) | (v[0] << 63);
+				v[0] = (v[0] >> 1) ^ ((u64)0xe1 << 56);
+			} else {
+				v[1] = (v[1] >> 1) | (v[0] << 63);
+				v[0] = v[0] >> 1;
+			}
+		}
+	}
+	r[0] = z[0];
+	r[1] = z[1];
+}
+
+/* GHASH: hash `data` (must be multiple of 16 bytes) with key H.
+ * Result is stored in `out` (16 bytes, big-endian).
+ */
+static void kat_ghash(const u8 *h, const u8 *data, int data_len, u8 *out)
+{
+	u64 y[2] = { 0, 0 };
+	u64 hh[2];
+	int i;
+
+	hh[0] = get_unaligned_be64(h);
+	hh[1] = get_unaligned_be64(h + 8);
+
+	for (i = 0; i < data_len; i += 16) {
+		u64 d[2], r[2];
+
+		d[0] = get_unaligned_be64(data + i);
+		d[1] = get_unaligned_be64(data + i + 8);
+		y[0] ^= d[0];
+		y[1] ^= d[1];
+		kat_gf128_mul(r, y, hh);
+		y[0] = r[0];
+		y[1] = r[1];
+	}
+	put_unaligned_be64(y[0], out);
+	put_unaligned_be64(y[1], out + 8);
+}
+
+static int knod_ipsec_run_crypto_kat(struct knod_ipsec_priv *priv)
+{
+	/* Fixed AES-128 key + 4-byte salt (from RFC 4106 conventions). */
+	static const u8 kat_key[16] = {
+		0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
+		0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08
+	};
+	static const u8 kat_salt[4] = { 0xca, 0xfe, 0xba, 0xbe };
+	static const u8 kat_iv[8] = {
+		0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88
+	};
+	/* 32-byte plaintext (2 AES blocks) + ESP trailer (pad_len=0,
+	 * next_hdr=4).
+	 * Total decrypted payload = 34 bytes, but ciphertext is padded to
+	 * block boundary: 48 bytes (3 blocks) with 14 pad bytes + trailer.
+	 * Actually simpler: use exactly 32 bytes of payload + 2 bytes trailer
+	 * = 34 bytes, which is NOT block-aligned. The shader handles this
+	 * because nblocks = ceil(34/16) = 3, and the last partial block is
+	 * XORed with only the relevant bytes.
+	 *
+	 * Simplification: use 32 bytes ciphertext (2 full blocks) where
+	 * the last 2 bytes are ESP trailer: byte[30]=pad_len=0, byte[31]=4
+	 * (IPv4 next header). inner_len = 32 - 0 - 2 = 30.
+	 */
+	static const u8 kat_plain[32] = {
+		0xd9, 0x31, 0x32, 0x25, 0xf8, 0x84, 0x06, 0xe5,
+		0xa5, 0x59, 0x09, 0xc5, 0xaf, 0xf5, 0x26, 0x9a,
+		0x86, 0xa7, 0xa9, 0x53, 0x15, 0x34, 0xf7, 0xda,
+		0x2e, 0x4c, 0x30, 0x3d, 0x8a, 0x31,
+		0x00,   /* pad_len = 0 */
+		0x04,   /* next_hdr = IPPROTO_IPIP (IPv4 tunnel) */
+	};
+	static const u32 kat_spi = 0xA5A5A5A5u;
+	static const u32 kat_seq = 0x00000001u;
+
+#define CRYPTO_KAT_BD_OFF	0x0000
+#define CRYPTO_KAT_OUT_OFF	0x0040
+#define CRYPTO_KAT_KEY_OFF	0x0100
+#define CRYPTO_KAT_PKT_OFF	0x0200
+#define CRYPTO_KAT_HTABLE_OFF	0x1000
+
+	struct knod_ipsec_sa_gpu_stats *gs;
+	struct knod_mem *scratch = priv->kat_scratch;
+	struct knod_ipsec_sa_entry *sa_entry;
+	struct knod_ipsec_fused_sub sub[1];
+	struct crypto_aes_ctx aes_ctx;
+	struct aes_enckey enckey;
+	void *sa_backup = NULL;
+	u8 nonce[12], ctr_blk[16], keystream[16];
+	u8 ciphertext[32], icv[16];
+	u8 ghash_input[80];
+	u8 h_block[16], ghash_out[16], j0_enc[16];
+	u8 *pkt, *out_buf, *key_buf, *htable_buf;
+	u64 *act_ptr;
+	u32 j0_ctr;
+	int ret, tries, i, b;
+
+	if (!scratch) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "crypto-kat FAIL: kat_scratch not allocated");
+		return -ENOMEM;
+	}
+	if (!priv->t_tables) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "crypto-kat FAIL: t_tables not allocated");
+		return -ENOMEM;
+	}
+
+	memset(scratch->kaddr, 0, PAGE_SIZE * 4);
+
+	pkt        = (u8 *)scratch->kaddr + CRYPTO_KAT_PKT_OFF;
+	out_buf    = (u8 *)scratch->kaddr + CRYPTO_KAT_OUT_OFF;
+	key_buf    = (u8 *)scratch->kaddr + CRYPTO_KAT_KEY_OFF;
+	htable_buf = (u8 *)scratch->kaddr + CRYPTO_KAT_HTABLE_OFF;
+	act_ptr    = (u64 *)((u8 *)scratch->kaddr + CRYPTO_KAT_BD_OFF + 8);
+
+	/* ---- Step 1: Expand AES key into kat_scratch ---- */
+	/* GPU round-key format uses crypto_aes_ctx.key_enc
+	 * (matches xdo_state_add)
+	 */
+	ret = aes_expandkey(&aes_ctx, kat_key, sizeof(kat_key));
+	if (ret) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "crypto-kat FAIL: aes_expandkey=%d", ret);
+		return ret;
+	}
+	/* AES-128: 11 round keys x 4 u32 = 44 u32 = 176B */
+	memcpy(key_buf, aes_ctx.key_enc,
+	       (aes_ctx.key_length / 4 + 7) * 16);
+	/* Also prepare aes_enckey for CPU-side reference encryption */
+	ret = aes_prepareenckey(&enckey, kat_key, sizeof(kat_key));
+	if (ret) {
+		memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+		return ret;
+	}
+
+	/* ---- Step 2: Precompute H-power table into kat_scratch page 2 ---- */
+	knod_gcm_precompute_h_table(kat_key, sizeof(kat_key), htable_buf);
+
+	/* ---- Step 3: CPU-side AES-GCM encrypt to produce ciphertext + ICV */
+	/* H = AES_K(0^128) */
+	memset(h_block, 0, 16);
+	aes_encrypt(&enckey, h_block, h_block);
+
+	/* Nonce = salt || IV */
+	memcpy(nonce, kat_salt, 4);
+	memcpy(nonce + 4, kat_iv, 8);
+
+	/* CTR encrypt: counter starts at 2 for payload blocks */
+	for (i = 0; i < 2; i++) {
+		u32 ctr_val = cpu_to_be32(i + 2);
+
+		memcpy(ctr_blk, nonce, 12);
+		memcpy(ctr_blk + 12, &ctr_val, 4);
+		aes_encrypt(&enckey, keystream, ctr_blk);
+
+		/* C_i = P_i XOR keystream */
+		for (b = 0; b < 16; b++)
+			ciphertext[i * 16 + b] =
+				kat_plain[i * 16 + b] ^ keystream[b];
+	}
+
+	/* GHASH over AAD(16) || ciphertext(32) || len_block(16) */
+	memset(ghash_input, 0, sizeof(ghash_input));
+	/* AAD = SPI(4B,BE) || seq(4B,BE) || zero-pad to 16B */
+	put_unaligned_be32(kat_spi, ghash_input);
+	put_unaligned_be32(kat_seq, ghash_input + 4);
+	/* ciphertext blocks */
+	memcpy(ghash_input + 16, ciphertext, 32);
+	/* len block: AAD_bitlen(64b) || ctext_bitlen(64b) */
+	/* 8 bytes AAD = 64 bits */
+	put_unaligned_be64(8ULL * 8, ghash_input + 48);
+	/* 32 bytes ctext = 256 bits */
+	put_unaligned_be64(32ULL * 8, ghash_input + 56);
+
+	kat_ghash(h_block, ghash_input, 64, ghash_out);
+
+	/* ICV = GHASH XOR AES_K(J0), where J0 = nonce || 0x00000001 (BE) */
+	j0_ctr = cpu_to_be32(1);
+	memcpy(ctr_blk, nonce, 12);
+	memcpy(ctr_blk + 12, &j0_ctr, 4);
+	aes_encrypt(&enckey, j0_enc, ctr_blk);
+	for (b = 0; b < 16; b++)
+		icv[b] = ghash_out[b] ^ j0_enc[b];
+	memzero_explicit(&enckey, sizeof(enckey));
+	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+
+	/* ---- Step 4: Build synthetic ESP packet ---- */
+	/* ETH header (14B): dst=00:..., src=00:..., ethertype=0x0800 */
+	pkt[12] = 0x08; pkt[13] = 0x00;
+	/* IPv4 header (20B): version=4, IHL=5, protocol=50(ESP) */
+	pkt[14] = 0x45;
+	/* total_length (network order):
+	 * 20(IP) + 8(ESP) + 8(IV) + 32(ctext) + 16(ICV) = 84
+	 */
+	pkt[16] = 0x00; pkt[17] = 84;
+	/* protocol = 50 (ESP) */
+	pkt[23] = 50;
+	/* SPI at +34 (network byte order) */
+	put_unaligned_be32(kat_spi, pkt + ESP_SPI_OFF);
+	/* Seq at +38 */
+	put_unaligned_be32(kat_seq, pkt + ESP_SEQ_OFF);
+	/* IV at +42 (8 bytes) */
+	memcpy(pkt + ESP_IV_OFF, kat_iv, 8);
+	/* Ciphertext at +50 (32 bytes) */
+	memcpy(pkt + ESP_CTEXT_OFF, ciphertext, 32);
+	/* ICV at +82 (16 bytes) */
+	memcpy(pkt + ESP_CTEXT_OFF + 32, icv, 16);
+
+	/* total pkt len = 14 + 84 = 98 bytes */
+#define CRYPTO_KAT_PKT_LEN	98
+
+	/* ---- Step 5: Set up SA entry (slot 0) in sa_table ---- */
+	BUILD_BUG_ON(sizeof(struct knod_ipsec_sa_entry) != 104);
+
+	/* Back up production SA table before trashing slot 0 with the KAT SA.
+	 * Restored at out_wipe. Without this, any live xfrm SA in slot 0
+	 * gets wiped and subsequent production dispatch faults on key=0.
+	 */
+	sa_backup = kvmalloc(KNOD_IPSEC_SA_BO_SIZE, GFP_KERNEL);
+	if (!sa_backup) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "crypto-kat FAIL: sa_backup alloc");
+		return -ENOMEM;
+	}
+	memcpy(sa_backup, priv->sa_table->kaddr, KNOD_IPSEC_SA_BO_SIZE);
+	memset(priv->sa_table->kaddr, 0, KNOD_IPSEC_SA_BO_SIZE);
+
+	sa_entry = (struct knod_ipsec_sa_entry *)priv->sa_table->kaddr;
+	sa_entry->spi           = cpu_to_le32(kat_spi);
+	sa_entry->dir           = cpu_to_le32(0);
+	sa_entry->family        = cpu_to_le32(AF_INET);
+	sa_entry->flags         = cpu_to_le32(0);
+	sa_entry->key_gpu_addr  = cpu_to_le64(scratch->gaddr +
+					      CRYPTO_KAT_KEY_OFF);
+	sa_entry->htable_gpu_addr = cpu_to_le64(scratch->gaddr +
+						CRYPTO_KAT_HTABLE_OFF);
+	sa_entry->t_tables_gpu_addr = cpu_to_le64(priv->t_tables->gaddr);
+	memcpy(sa_entry->salt, kat_salt, 4);
+	sa_entry->key_len       = cpu_to_le32(16);
+	sa_entry->nr_rounds     = cpu_to_le32(10); /* AES-128 */
+	/* KAT uses tunnel mode */
+	sa_entry->mode          = cpu_to_le32(XFRM_MODE_TUNNEL);
+	sa_entry->stats_addr    = cpu_to_le64(priv->sa_table->gaddr +
+					      KNOD_IPSEC_STATS_REGION_OFF);
+	sa_entry->active        = cpu_to_le32(1);
+	sa_entry->version       = cpu_to_le32(1);
+	/* publish the SA entry to the GPU before it becomes live */
+	wmb();
+
+	/* Pre-stamp bd->act with sentinel */
+	*act_ptr = 0xDEADDEADDEADDEADULL;
+
+	/* ---- Step 6: Build sub[] and dispatch ---- */
+	memset(sub, 0, sizeof(sub));
+	sub[0].pkt_addr = cpu_to_le64(scratch->gaddr + CRYPTO_KAT_PKT_OFF);
+	sub[0].out_addr = cpu_to_le64(scratch->gaddr + CRYPTO_KAT_OUT_OFF);
+	sub[0].bd_addr  = cpu_to_le64(scratch->gaddr + CRYPTO_KAT_BD_OFF);
+	sub[0].pkt_len  = cpu_to_le32(CRYPTO_KAT_PKT_LEN);
+	sub[0].result_seq = 0;
+
+	pr_info("knod_ipsec: crypto-kat: dispatching AES-128-GCM decrypt (spi=0x%08x, %d bytes ctext)\n",
+		kat_spi, 32);
+
+	if (priv->disp[0].kthread)
+		kthread_park(priv->disp[0].kthread);
+	knod_ipsec_prepare_rx_dispatch(priv, &priv->work_pool[0], sub, NULL,
+				       1, NULL, 0);
+	knod_ipsec_dispatch_and_wait(&priv->disp[0], &priv->work_pool[0]);
+	if (priv->disp[0].kthread)
+		kthread_unpark(priv->disp[0].kthread);
+	ret = 0;
+
+	/* ---- Step 7: Poll for completion ---- */
+	for (tries = 0; tries < 500; tries++) {
+		u64 v = READ_ONCE(*act_ptr);
+		u32 verdict_hi = (u32)(v >> 32);
+
+		if (verdict_hi != 0xDEADDEAD) {
+			if (verdict_hi == 0) {
+				/*
+				 * Slot 0 = ICV passed!
+				 * Verify decrypted output.
+				 */
+				if (memcmp(out_buf, kat_plain, 32) != 0) {
+					pr_err("knod_ipsec: crypto-kat FAIL: plaintext mismatch\n");
+					print_hex_dump(KERN_ERR, "  expected: ",
+						       DUMP_PREFIX_NONE,
+						       16, 1, kat_plain, 32,
+						       false);
+					print_hex_dump(KERN_ERR, "  got:      ",
+						       DUMP_PREFIX_NONE,
+						       16, 1, out_buf, 32,
+						       false);
+					scnprintf(knod_ipsec_last_kat_detail,
+					  sizeof(knod_ipsec_last_kat_detail),
+					  "crypto-kat FAIL: plaintext mismatch (verdict ok)");
+					ret = -EBADMSG;
+					goto out_wipe;
+				}
+				gs = (struct knod_ipsec_sa_gpu_stats *)
+					((u8 *)priv->sa_table->kaddr +
+					 KNOD_IPSEC_STATS_REGION_OFF);
+				pr_info("knod_ipsec: crypto-kat PASS: AES-128-GCM decrypt verified (%d us poll, gpu_stats: pkts=%llu bytes=%llu)\n",
+					tries * 750,
+					le64_to_cpu(gs->rx_packets),
+					le64_to_cpu(gs->rx_bytes));
+				ret = 0;
+				goto out_wipe;
+			} else if (verdict_hi == VERDICT_ICV_FAIL) {
+				pr_err("knod_ipsec: crypto-kat FAIL: ICV mismatch (verdict=0x%08x)\n",
+				       verdict_hi);
+				print_hex_dump(KERN_ERR, "  ref-icv:  ",
+					       DUMP_PREFIX_NONE,
+					       16, 1, icv, 16, false);
+				print_hex_dump(KERN_ERR, "  out-buf:  ",
+					       DUMP_PREFIX_NONE,
+					       16, 1, out_buf, 32, false);
+				print_hex_dump(KERN_ERR, "  ref-plain:",
+					       DUMP_PREFIX_NONE,
+					       16, 1, kat_plain, 32, false);
+				scnprintf(knod_ipsec_last_kat_detail,
+					  sizeof(knod_ipsec_last_kat_detail),
+					  "crypto-kat FAIL: shader ICV mismatch");
+				ret = -EBADMSG;
+				goto out_wipe;
+			} else {
+				pr_err("knod_ipsec: crypto-kat FAIL: unexpected verdict=0x%08x (low=0x%08x)\n",
+				       verdict_hi, (u32)v);
+				scnprintf(knod_ipsec_last_kat_detail,
+					  sizeof(knod_ipsec_last_kat_detail),
+					  "crypto-kat FAIL: verdict=0x%08x",
+					  verdict_hi);
+				ret = -EIO;
+				goto out_wipe;
+			}
+		}
+		usleep_range(500, 1000);
+	}
+
+	pr_err("knod_ipsec: crypto-kat FAIL: timeout (bd->act=0x%016llx)\n",
+	       READ_ONCE(*act_ptr));
+	scnprintf(knod_ipsec_last_kat_detail,
+		  sizeof(knod_ipsec_last_kat_detail),
+		  "crypto-kat FAIL: timeout");
+	ret = -ETIMEDOUT;
+
+out_wipe:
+	if (sa_backup) {
+		memcpy(priv->sa_table->kaddr, sa_backup, KNOD_IPSEC_SA_BO_SIZE);
+		/* publish the restored SA table to the GPU */
+		wmb();
+		kvfree(sa_backup);
+	}
+	return ret;
+
+#undef CRYPTO_KAT_BD_OFF
+#undef CRYPTO_KAT_OUT_OFF
+#undef CRYPTO_KAT_KEY_OFF
+#undef CRYPTO_KAT_PKT_OFF
+#undef CRYPTO_KAT_HTABLE_OFF
+#undef CRYPTO_KAT_PKT_LEN
+}
+
+static int knod_ipsec_run_shader_kat(struct knod_ipsec_priv *priv)
+{
+	static const int batch_sizes[] = { 1, 8, 32, KNOD_IPSEC_KAT_MAX_BATCH };
+	int i, failed = 0;
+	int last_ok = 0;
+
+	if (!priv->work_pool[0].param.kaddr) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch SKIPPED (NOD not attached)");
+		pr_info("knod_ipsec: %s\n", knod_ipsec_last_kat_detail);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(batch_sizes); i++) {
+		int rc = knod_ipsec_run_shader_kat_n(priv, batch_sizes[i]);
+
+		if (rc)
+			failed++;
+		else
+			last_ok = batch_sizes[i];
+	}
+
+	if (!failed) {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch PASS (batch sizes 1/8/32/%d, last_ok=%d)",
+			  KNOD_IPSEC_PKT_BATCH, last_ok);
+		pr_info("knod_ipsec: %s\n", knod_ipsec_last_kat_detail);
+	}
+	return failed;
+}
+
+static int knod_ipsec_run_kat(void)
+{
+	struct knod_ipsec_priv *priv = ipsec_priv;
+	int failed = 0;
+
+	failed += knod_ipsec_run_cpu_kat();
+
+	if (priv) {
+		failed += knod_ipsec_run_shader_kat(priv);
+		if (priv->work_pool[0].param.kaddr)
+			failed += knod_ipsec_run_crypto_kat(priv);
+		else
+			pr_info("knod_ipsec: crypto-kat SKIPPED (NOD not attached)\n");
+	} else {
+		scnprintf(knod_ipsec_last_kat_detail,
+			  sizeof(knod_ipsec_last_kat_detail),
+			  "shader-dispatch SKIPPED (priv not initialized)");
+	}
+
+	knod_ipsec_last_kat_result = failed;
+	return failed;
+}
+
+static void knod_ipsec_stats_sum(struct knod_ipsec_priv *priv,
+				 struct knod_ipsec_stats *dst)
+{
+	int cpu;
+
+	memset(dst, 0, sizeof(*dst));
+	if (!priv)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		struct knod_ipsec_stats *s = per_cpu_ptr(priv->stats, cpu);
+
+		dst->rx_packets		+= s->rx_packets;
+		dst->rx_bytes		+= s->rx_bytes;
+		dst->rx_dispatches	+= s->rx_dispatches;
+		dst->rx_batch_total	+= s->rx_batch_total;
+		if (s->rx_batch_max > dst->rx_batch_max)
+			dst->rx_batch_max = s->rx_batch_max;
+		dst->rx_sdma_copies_total += s->rx_sdma_copies_total;
+		dst->rx_sdma_bytes_total  += s->rx_sdma_bytes_total;
+		if (s->rx_sdma_copies_max > dst->rx_sdma_copies_max)
+			dst->rx_sdma_copies_max = s->rx_sdma_copies_max;
+		dst->rx_drop_icv	+= s->rx_drop_icv;
+		dst->rx_drop_replay	+= s->rx_drop_replay;
+		dst->rx_drop_no_sa	+= s->rx_drop_no_sa;
+		dst->rx_drop_malformed	+= s->rx_drop_malformed;
+		dst->rx_drop_desc_full	+= s->rx_drop_desc_full;
+		dst->rx_drop_sdma_full	+= s->rx_drop_sdma_full;
+		dst->rx_build_ns	+= s->rx_build_ns;
+		dst->rx_gpu_ns		+= s->rx_gpu_ns;
+		dst->rx_sdma_ns		+= s->rx_sdma_ns;
+		dst->rx_finalise_ns	+= s->rx_finalise_ns;
+		dst->rx_total_ns	+= s->rx_total_ns;
+		dst->rx_idle_ns		+= s->rx_idle_ns;
+		dst->sa_add		+= s->sa_add;
+		dst->sa_del		+= s->sa_del;
+		dst->sa_rekey		+= s->sa_rekey;
+		dst->drain_calls	+= s->drain_calls;
+		dst->drain_found	+= s->drain_found;
+		dst->drain_delivered	+= s->drain_delivered;
+		dst->drain_alloc_ns	+= s->drain_alloc_ns;
+		dst->drain_copy_ns	+= s->drain_copy_ns;
+		dst->drain_proto_ns	+= s->drain_proto_ns;
+		dst->drain_gro_ns	+= s->drain_gro_ns;
+		dst->drain_total_ns	+= s->drain_total_ns;
+		dst->drain_zc_ok	+= s->drain_zc_ok;
+		dst->drain_zc_fallback	+= s->drain_zc_fallback;
+		dst->finish_produced	+= s->finish_produced;
+		dst->rx_peek_total	+= s->rx_peek_total;
+		dst->rx_submit_fail	+= s->rx_submit_fail;
+	}
+}
+
+static int knod_ipsec_stats_show(struct seq_file *s, void *v)
+{
+	struct knod_ipsec_priv *priv = s->private;
+	struct knod_ipsec_stats tot;
+	int i;
+
+	if (!priv)
+		return -ENODEV;
+
+	knod_ipsec_stats_sum(priv, &tot);
+
+	seq_printf(s, "stats_enabled  : %d\n",
+		   static_branch_unlikely(&ipsec_stats_enabled_key) ? 1 : 0);
+	seq_puts(s, "== RX ==\n");
+	seq_printf(s, "rx_packets     : %llu\n", tot.rx_packets);
+	seq_printf(s, "rx_bytes       : %llu\n", tot.rx_bytes);
+	seq_printf(s, "rx_dispatches  : %llu\n", tot.rx_dispatches);
+	seq_printf(s, "rx_batch_total : %llu\n", tot.rx_batch_total);
+	seq_printf(s, "rx_batch_max   : %llu\n", tot.rx_batch_max);
+	if (tot.rx_dispatches)
+		seq_printf(s, "rx_batch_avg   : %llu\n",
+			   tot.rx_batch_total / tot.rx_dispatches);
+	seq_printf(s, "rx_sdma_copies : %llu\n", tot.rx_sdma_copies_total);
+	seq_printf(s, "rx_sdma_cp_max : %llu\n", tot.rx_sdma_copies_max);
+	seq_printf(s, "rx_sdma_bytes  : %llu\n", tot.rx_sdma_bytes_total);
+	if (tot.rx_dispatches) {
+		seq_printf(s, "rx_sdma_cp_avg : %llu\n",
+			   tot.rx_sdma_copies_total / tot.rx_dispatches);
+		seq_printf(s, "rx_sdma_by_avg : %llu\n",
+			   tot.rx_sdma_bytes_total / tot.rx_dispatches);
+	}
+	if (tot.rx_sdma_copies_total)
+		seq_printf(s, "rx_sdma_by_per : %llu\n",
+			   tot.rx_sdma_bytes_total / tot.rx_sdma_copies_total);
+	seq_printf(s, "rx_drop_icv    : %llu\n", tot.rx_drop_icv);
+	seq_printf(s, "rx_drop_replay : %llu\n", tot.rx_drop_replay);
+	seq_printf(s, "rx_drop_no_sa  : %llu\n", tot.rx_drop_no_sa);
+	seq_printf(s, "rx_drop_malform: %llu\n", tot.rx_drop_malformed);
+	seq_printf(s, "rx_drop_descful: %llu\n", tot.rx_drop_desc_full);
+	seq_printf(s, "rx_drop_sdmaful: %llu\n", tot.rx_drop_sdma_full);
+	seq_puts(s, "-- RX timing (ns, summed across dispatches) --\n");
+	seq_printf(s, "rx_build_ns    : %llu\n", tot.rx_build_ns);
+	seq_printf(s, "rx_gpu_ns      : %llu\n", tot.rx_gpu_ns);
+	seq_printf(s, "rx_sdma_ns     : %llu\n", tot.rx_sdma_ns);
+	seq_printf(s, "rx_finalise_ns : %llu\n", tot.rx_finalise_ns);
+	seq_printf(s, "rx_total_ns    : %llu\n", tot.rx_total_ns);
+	seq_printf(s, "rx_idle_ns     : %llu\n", tot.rx_idle_ns);
+	if (tot.rx_dispatches) {
+		seq_printf(s, "rx_build_avg_ns  : %llu\n",
+			   tot.rx_build_ns / tot.rx_dispatches);
+		seq_printf(s, "rx_gpu_avg_ns    : %llu\n",
+			   tot.rx_gpu_ns / tot.rx_dispatches);
+		seq_printf(s, "rx_sdma_avg_ns   : %llu\n",
+			   tot.rx_sdma_ns / tot.rx_dispatches);
+		seq_printf(s, "rx_finalise_avg_ns: %llu\n",
+			   tot.rx_finalise_ns / tot.rx_dispatches);
+		seq_printf(s, "rx_total_avg_ns  : %llu\n",
+			   tot.rx_total_ns / tot.rx_dispatches);
+	}
+	seq_puts(s, "== Control ==\n");
+	seq_printf(s, "sa_add         : %llu\n", tot.sa_add);
+	seq_printf(s, "sa_del         : %llu\n", tot.sa_del);
+	seq_printf(s, "sa_rekey       : %llu\n", tot.sa_rekey);
+	seq_puts(s, "== Debug ==\n");
+	seq_printf(s, "drain_calls    : %llu\n", tot.drain_calls);
+	seq_printf(s, "drain_found    : %llu\n", tot.drain_found);
+	seq_printf(s, "drain_delivered: %llu\n", tot.drain_delivered);
+	seq_puts(s, "-- drain_rx timing (ns, summed) --\n");
+	seq_printf(s, "drain_alloc_ns : %llu\n", tot.drain_alloc_ns);
+	seq_printf(s, "drain_copy_ns  : %llu\n", tot.drain_copy_ns);
+	seq_printf(s, "drain_proto_ns : %llu\n", tot.drain_proto_ns);
+	seq_printf(s, "drain_gro_ns   : %llu\n", tot.drain_gro_ns);
+	seq_printf(s, "drain_total_ns : %llu\n", tot.drain_total_ns);
+	if (tot.drain_delivered) {
+		seq_printf(s, "drain_alloc_per: %llu\n",
+			   tot.drain_alloc_ns / tot.drain_delivered);
+		seq_printf(s, "drain_copy_per : %llu\n",
+			   tot.drain_copy_ns / tot.drain_delivered);
+		seq_printf(s, "drain_proto_per: %llu\n",
+			   tot.drain_proto_ns / tot.drain_delivered);
+		seq_printf(s, "drain_gro_per  : %llu\n",
+			   tot.drain_gro_ns / tot.drain_delivered);
+		seq_printf(s, "drain_total_per: %llu\n",
+			   tot.drain_total_ns / tot.drain_delivered);
+	}
+	if (tot.drain_calls)
+		seq_printf(s, "drain_pkts_call: %llu\n",
+			   tot.drain_delivered / tot.drain_calls);
+	seq_printf(s, "finish_produced: %llu\n", tot.finish_produced);
+	seq_printf(s, "rx_peek_total  : %llu\n", tot.rx_peek_total);
+	seq_printf(s, "rx_submit_fail : %llu\n", tot.rx_submit_fail);
+	seq_printf(s, "drain_zc_ok    : %llu\n", tot.drain_zc_ok);
+	seq_printf(s, "drain_zc_fallback: %llu\n", tot.drain_zc_fallback);
+
+	/* Per-queue SPSC ring state - shows where bds are stuck */
+	if (priv && priv->knodev) {
+		int nr_q = priv->knodev->netdev ?
+			priv->knodev->netdev->real_num_rx_queues : 0;
+
+		if (nr_q > KNOD_SPSC_MAX)
+			nr_q = KNOD_SPSC_MAX;
+		seq_puts(s, "== SPSC per-queue ==\n");
+		for (i = 0; i < nr_q; i++) {
+			struct spsc_ring *r = &priv->knodev->wpriv[i].spsc_bds;
+
+			if (!r->slots || r->mask == 0)
+				continue;
+			/* Only show queues with non-zero activity */
+			if (r->head == 0 && r->acquired == 0 && r->tail == 0)
+				continue;
+			seq_printf(s, "  q%02d: head=%u acq=%u tail=%u (unpeek=%u inflight=%u)\n",
+				   i, r->head, r->acquired, r->tail,
+				   r->head - r->acquired,
+				   r->acquired - r->tail);
+		}
+	}
+
+	/* Dispatcher */
+	if (priv) {
+		int d, n_running = 0;
+
+		for (d = 0; d < priv->nr_dispatchers; d++)
+			if (priv->disp[d].kthread)
+				n_running++;
+		seq_printf(s, "== Dispatchers ==\n  running=%d/%d\n",
+			   n_running, priv->nr_dispatchers);
+		for (d = 0; d < priv->nr_dispatchers; d++) {
+			struct knod_ipsec_dispatcher *disp = &priv->disp[d];
+
+			seq_printf(s,
+				"  disp[%d]: kaql=%d work=[%d..%d) rxq=[%d..%d)\n",
+				d, disp->kaql_idx,
+				disp->work_first,
+				disp->work_first + disp->work_count,
+				disp->rxq_first,
+				disp->rxq_first + disp->rxq_count);
+		}
+	}
+
+	return 0;
+}
+
+static int knod_ipsec_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_stats_show, inode->i_private);
+}
+
+static const struct file_operations knod_ipsec_stats_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_stats_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static ssize_t knod_ipsec_stats_enable_write(struct file *file,
+					     const char __user *ubuf,
+					     size_t len, loff_t *ppos)
+{
+	char buf[4] = {};
+	int val;
+
+	if (len == 0 || len > sizeof(buf) - 1)
+		return -EINVAL;
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+	if (kstrtoint(strim(buf), 0, &val))
+		return -EINVAL;
+
+	if (val)
+		static_branch_enable(&ipsec_stats_enabled_key);
+	else
+		static_branch_disable(&ipsec_stats_enabled_key);
+	return len;
+}
+
+static int knod_ipsec_stats_enable_show(struct seq_file *s, void *v)
+{
+	seq_printf(s, "%d\n",
+		   static_branch_unlikely(&ipsec_stats_enabled_key) ? 1 : 0);
+	return 0;
+}
+
+static int knod_ipsec_stats_enable_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_stats_enable_show, NULL);
+}
+
+static const struct file_operations knod_ipsec_stats_enable_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_stats_enable_open,
+	.read    = seq_read,
+	.write   = knod_ipsec_stats_enable_write,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static ssize_t knod_ipsec_poll_write(struct file *file,
+				     const char __user *ubuf,
+				     size_t len, loff_t *ppos)
+{
+	char buf[4] = {};
+	int val;
+
+	if (len == 0 || len > sizeof(buf) - 1)
+		return -EINVAL;
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+	if (kstrtoint(strim(buf), 0, &val))
+		return -EINVAL;
+
+	WRITE_ONCE(knod_ipsec_poll_mode, !!val);
+	return len;
+}
+
+static int knod_ipsec_poll_show(struct seq_file *s, void *v)
+{
+	seq_printf(s, "%d\n", READ_ONCE(knod_ipsec_poll_mode) ? 1 : 0);
+	return 0;
+}
+
+static int knod_ipsec_poll_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_poll_show, NULL);
+}
+
+static const struct file_operations knod_ipsec_poll_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_poll_open,
+	.read    = seq_read,
+	.write   = knod_ipsec_poll_write,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static ssize_t knod_ipsec_pkt_batch_write(struct file *file,
+					  const char __user *ubuf,
+					  size_t len, loff_t *ppos)
+{
+	struct knod_ipsec_priv *priv = file_inode(file)->i_private;
+	char buf[8] = {};
+	u32 val;
+
+	if (!priv)
+		return -ENODEV;
+	if (len == 0 || len > sizeof(buf) - 1)
+		return -EINVAL;
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+	if (kstrtou32(strim(buf), 0, &val))
+		return -EINVAL;
+	if (val < 1 || val > KNOD_IPSEC_PKT_BATCH)
+		return -ERANGE;
+
+	WRITE_ONCE(priv->pkt_batch, val);
+	return len;
+}
+
+static int knod_ipsec_pkt_batch_show(struct seq_file *s, void *v)
+{
+	struct knod_ipsec_priv *priv = s->private;
+
+	if (!priv)
+		return -ENODEV;
+	seq_printf(s, "%u\n", READ_ONCE(priv->pkt_batch));
+	return 0;
+}
+
+static int knod_ipsec_pkt_batch_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_pkt_batch_show, inode->i_private);
+}
+
+static const struct file_operations knod_ipsec_pkt_batch_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_pkt_batch_open,
+	.read    = seq_read,
+	.write   = knod_ipsec_pkt_batch_write,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static ssize_t knod_ipsec_stats_reset_write(struct file *file,
+					    const char __user *ubuf,
+					    size_t len, loff_t *ppos)
+{
+	struct knod_ipsec_priv *priv = file_inode(file)->i_private;
+	int cpu;
+
+	if (!priv)
+		return -ENODEV;
+
+	for_each_possible_cpu(cpu) {
+		struct knod_ipsec_stats *s = per_cpu_ptr(priv->stats, cpu);
+		u64 sa_add = s->sa_add, sa_del = s->sa_del;
+		u64 sa_rekey = s->sa_rekey;
+
+		memset(s, 0, sizeof(*s));
+		s->sa_add = sa_add;
+		s->sa_del = sa_del;
+		s->sa_rekey = sa_rekey;
+	}
+	return len;
+}
+
+static const struct file_operations knod_ipsec_stats_reset_fops = {
+	.owner = THIS_MODULE,
+	.open  = simple_open,
+	.write = knod_ipsec_stats_reset_write,
+};
+
+static int knod_ipsec_sa_table_show(struct seq_file *s, void *v)
+{
+	struct knod_ipsec_priv *priv = s->private;
+	int i, used = 0;
+
+	if (!priv)
+		return -ENODEV;
+
+	mutex_lock(&priv->slot_lock);
+	for (i = 0; i < KNOD_IPSEC_NR_SA; i++) {
+		struct knod_ipsec_sa_slot *slot = &priv->slots[i];
+
+		if (!slot->active)
+			continue;
+		seq_printf(s, "slot[%3d] spi=0x%08x version=%u\n",
+			   i, slot->spi, slot->version);
+		used++;
+	}
+	mutex_unlock(&priv->slot_lock);
+	seq_printf(s, "used: %d / %d\n", used, KNOD_IPSEC_NR_SA);
+	return 0;
+}
+
+static int knod_ipsec_sa_table_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_sa_table_show, inode->i_private);
+}
+
+static const struct file_operations knod_ipsec_sa_table_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_sa_table_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+/*
+ * Disassembly goes through the shared amdgcn_disasm_raw() (knod_amdgpu_insn.h):
+ * it classifies each raw instruction into a struct amdgcn_insn and prints it
+ * via the complete-opnames disassembler, so every feature shares one decoder
+ * instead of the old per-feature hand-rolled hex re-parsers.
+ */
+static int knod_ipsec_insn_show(struct seq_file *s, void *v)
+{
+	struct knod_ipsec_priv *priv = s->private;
+	struct kernel_descriptor *kd;
+	u32 *code;
+	int ndw, off;
+
+	if (!priv || !priv->knod || !priv->knod->kernels[0])
+		return -ENODEV;
+
+	kd = priv->knod->kernels[0]->kaddr;
+	code = priv->knod->kernels[0]->kaddr +
+	       kd->kernel_code_entry_byte_offset;
+	ndw = max_t(int, 1, (int)priv->shader_size / 4);
+
+	seq_printf(s, "=== IPsec fused RX shader (GFX%d, %zu bytes, %d dwords) ===\n",
+		   priv->isa_version, priv->shader_size, ndw);
+	seq_printf(s, "kernel_code_gaddr: 0x%llx\n\n",
+		   priv->knod->kernels[0]->gaddr +
+		   kd->kernel_code_entry_byte_offset);
+
+	off = 0;
+	while (off < ndw) {
+		int adv;
+
+		seq_printf(s, "%04x: ", off * 4);
+		adv = amdgcn_disasm_raw(priv->isa_version, &code[off],
+					ndw - off, s);
+		if (adv <= 0)
+			break;
+		off += adv;
+	}
+
+	if (ndw == 1 && code[0] == 0xBF810000)
+		seq_puts(s, "\n(empty shader: single s_endpgm)\n");
+
+	return 0;
+}
+
+static int knod_ipsec_insn_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_insn_show, inode->i_private);
+}
+
+static const struct file_operations knod_ipsec_insn_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_insn_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static ssize_t knod_ipsec_selftest_write(struct file *file,
+					 const char __user *ubuf,
+					 size_t len, loff_t *ppos)
+{
+	char buf[4] = {};
+	int val;
+
+	if (len == 0 || len > sizeof(buf) - 1)
+		return -EINVAL;
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+	if (kstrtoint(strim(buf), 0, &val))
+		return -EINVAL;
+	if (val)
+		knod_ipsec_run_kat();
+	return len;
+}
+
+static int knod_ipsec_selftest_show(struct seq_file *s, void *v)
+{
+	seq_puts(s, "write 1 to trigger in-kernel KAT\n");
+	seq_puts(s, "  cpu layer   : H = AES_K(0^128) for aes128/192/256, ");
+	seq_printf(s, "%d random keys each\n", KNOD_IPSEC_KAT_RAND_ROUNDS);
+	seq_printf(s, "  gpu layer   : fused-shader dispatch at batch sizes 1/8/32/%d\n",
+		   KNOD_IPSEC_PKT_BATCH);
+	seq_puts(s, "  crypto layer: AES-128-GCM full decrypt+ICV verify via GPU shader\n");
+	seq_puts(s, "  tx-crypto   : AES-128-GCM full encrypt+ICV generate via GPU shader\n");
+	if (knod_ipsec_last_kat_result < 0) {
+		seq_puts(s, "last run: never\n");
+	} else if (knod_ipsec_last_kat_result == 0) {
+		seq_puts(s, "last run: PASS\n");
+	} else {
+		seq_printf(s, "last run: FAIL (%d checks failed)\n",
+			   knod_ipsec_last_kat_result);
+	}
+	if (knod_ipsec_last_kat_detail[0])
+		seq_printf(s, "detail: %s\n", knod_ipsec_last_kat_detail);
+	return 0;
+}
+
+static int knod_ipsec_selftest_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knod_ipsec_selftest_show, NULL);
+}
+
+static const struct file_operations knod_ipsec_selftest_fops = {
+	.owner   = THIS_MODULE,
+	.open    = knod_ipsec_selftest_open,
+	.read    = seq_read,
+	.write   = knod_ipsec_selftest_write,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+/*
+ * debugfs lives under the shared knod ctx dir so IPsec files coexist
+ * with MACsec (aesgcm_selftest) and WG (wg subdir) under one tree:
+ *   /sys/kernel/debug/dri/<N>/knod/ipsec/{stats,selftest,insn,...}
+ *
+ * The knod ctx is owned by knod_init/knod_exit, so debugfs lifecycle is
+ * tied to those callbacks rather than module init/exit.
+ */
+static void knod_ipsec_debugfs_init(struct knod_ipsec_priv *priv)
+{
+	struct dentry *parent;
+
+	if (!priv || !priv->knod || !priv->knod->debug_dir)
+		return;
+
+	parent = debugfs_create_dir("ipsec", priv->knod->debug_dir);
+	if (IS_ERR_OR_NULL(parent))
+		return;
+	priv->debug_dir = parent;
+
+	/* Populate this module's opcode-name tables for the shared
+	 * disassembler (amdgcn_disasm_raw, used by the "insn" file). Each
+	 * feature module carries its own copy of the opnames_gfx9/10 tables
+	 * (knod_amdgpu_insn.h), so the tables must be initialised here rather
+	 * than relying on the BPF module having done it.
+	 */
+
+	debugfs_create_file("stats", 0444, parent,
+			    priv, &knod_ipsec_stats_fops);
+	debugfs_create_file("stats_enable", 0644, parent,
+			    priv, &knod_ipsec_stats_enable_fops);
+	debugfs_create_file("stats_reset", 0200, parent,
+			    priv, &knod_ipsec_stats_reset_fops);
+	debugfs_create_file("sa_table", 0444, parent,
+			    priv, &knod_ipsec_sa_table_fops);
+	debugfs_create_file("insn", 0444, parent,
+			    priv, &knod_ipsec_insn_fops);
+	debugfs_create_file("selftest", 0644, parent,
+			    priv, &knod_ipsec_selftest_fops);
+	debugfs_create_file("poll", 0644, parent,
+			    priv, &knod_ipsec_poll_fops);
+	debugfs_create_file("pkt_batch", 0644, parent,
+			    priv, &knod_ipsec_pkt_batch_fops);
+}
+
+static void knod_ipsec_debugfs_exit(struct knod_ipsec_priv *priv)
+{
+	if (!priv)
+		return;
+	debugfs_remove_recursive(priv->debug_dir);
+	priv->debug_dir = NULL;
+}
+
+/* ========================================================================
+ * Policy offload - accept PACKET-mode policies so xfrm_state_find()
+ * will match our PACKET-mode SAs. No GPU-side action needed; we just
+ * return 0 to let the kernel record the offload type on the policy.
+ * ========================================================================
+ */
+static int knod_ipsec_xdo_policy_add(struct knod_dev *knodev,
+				     struct xfrm_policy *xp,
+				     struct netlink_ext_ack *extack)
+{
+	return 0; /* accept unconditionally */
+}
+
+static void knod_ipsec_xdo_policy_delete(struct knod_dev *knodev,
+					 struct xfrm_policy *xp)
+{
+	/* nothing to clean up on the GPU side */
+}
+
+static void knod_ipsec_xdo_policy_free(struct knod_dev *knodev,
+				       struct xfrm_policy *xp)
+{
+	/* nothing to free */
+}
+
+/* ========================================================================
+ * knod_accel_ipsec_ops registration
+ * ========================================================================
+ */
+
+static struct knod_accel_ipsec_ops knod_ipsec_ops = {
+	/* feature select: alloc/free the IPsec GPU resources */
+	.activate		       = knod_ipsec_nod_init,
+	.deactivate		       = knod_ipsec_nod_exit,
+	.busy			       = knod_ipsec_nod_busy,
+	/* interface up/down (or feature switch): dispatchers + GPU drain */
+	.start			       = knod_ipsec_nod_start,
+	.stop			       = knod_ipsec_nod_stop,
+	.xdo_dev_state_add	       = knod_ipsec_xdo_state_add,
+	.xdo_dev_state_delete	       = knod_ipsec_xdo_state_delete,
+	.xdo_dev_state_free	       = knod_ipsec_xdo_state_free,
+	.xdo_dev_offload_ok	       = knod_ipsec_xdo_offload_ok,
+	.xdo_dev_state_advance_esn     = knod_ipsec_xdo_state_advance_esn,
+	.xdo_dev_state_update_stats    = knod_ipsec_xdo_state_update_stats,
+	.xdo_dev_policy_add	       = knod_ipsec_xdo_policy_add,
+	.xdo_dev_policy_delete	       = knod_ipsec_xdo_policy_delete,
+	.xdo_dev_policy_free	       = knod_ipsec_xdo_policy_free,
+};
+
+static int __init knod_ipsec_init(void)
+{
+	pr_debug("knod_ipsec: module load\n");
+
+	/* Publish our dispatcher-count requirement to the shared knod
+	 * core before any NOD attach happens so knod_attach() creates a
+	 * context with enough kaql/sdma pairs. knod_request_queue_cnt
+	 * is a high-water mark so raising it here is idempotent and
+	 * won't stomp on a larger value from another accel.
+	 */
+	knod_request_queue_cnt(clamp(nr_dispatch, 1,
+				     KNOD_IPSEC_MAX_DISPATCHERS));
+
+	/* knod_accel_ipsec_register() already attaches and inits the ipsec
+	 * ops on every registered accel via knod_ipsec_attach(), so there is no
+	 * separate per-accel init loop here: a second init() would only be
+	 * rejected with -EBUSY by the ipsec_priv guard and log a misleading
+	 * "init failed (-16)".
+	 */
+	knod_dev_lock();
+	knod_accel_ipsec_register(&knod_ipsec_ops);
+	knod_dev_unlock();
+	return 0;
+}
+
+static void __exit knod_ipsec_exit(void)
+{
+	struct knod_accel *accel;
+
+	rtnl_lock();
+	knod_dev_lock();
+	for_each_accel(accel) {
+		if (!strncmp(accel->name, "amdgpu-", 7) && accel->knodev) {
+			if (accel->accel_ops->ipsec_ops)
+				accel->accel_ops->ipsec_ops->exit(
+					accel->knodev);
+		}
+	}
+	knod_accel_ipsec_unregister();
+	knod_dev_unlock();
+	rtnl_unlock();
+
+	pr_debug("knod_ipsec: module unload\n");
+}
+
+module_init(knod_ipsec_init);
+module_exit(knod_ipsec_exit);
+
+MODULE_DESCRIPTION("AMDGPU IPsec (xfrm) full-packet offload via KNOD");
+MODULE_AUTHOR("Taehee Yoo <ap420073@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.h b/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.h
new file mode 100644
index 000000000000..3754a86d6c63
--- /dev/null
+++ b/drivers/gpu/drm/amd/amdkfd/knod/knod_ipsec.h
@@ -0,0 +1,596 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Copyright (c) 2021 Taehee Yoo <ap420073@gmail.com>
+ * Copyright (c) 2021 Hoyeon Lee <hoyeon.rhee@gmail.com>
+ */
+
+#ifndef KNOD_IPSEC_H_
+#define KNOD_IPSEC_H_
+
+#include <linux/types.h>
+#include <linux/xarray.h>
+#include <linux/mutex.h>
+#include <linux/jump_label.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/ktime.h>
+#include <linux/mmzone.h>
+#include <net/spsc_ring.h>
+#include <net/knod.h>		/* KNOD_SPSC_MAX */
+
+struct knod;
+struct knod_mem;
+struct dentry;
+struct xfrm_state;
+struct sk_buff;
+struct task_struct;
+struct net_device;
+struct napi_struct;
+struct knod_ipsec_priv;
+
+#define KNOD_IPSEC_NR_SA		256
+/* The shader-dispatch KAT installs one fake SA per fused_sub entry, so
+ * its maximum batch size is bounded by NR_SA. Keep separate from
+ * KNOD_IPSEC_PKT_BATCH so production can run larger batches without
+ * growing the SA table BO.
+ */
+#define KNOD_IPSEC_KAT_MAX_BATCH	64
+/* 128-bit window, 4 u32 words */
+#define KNOD_IPSEC_REPLAY_WORDS		4
+#define KNOD_IPSEC_REPLAY_BITS		(KNOD_IPSEC_REPLAY_WORDS * 32)
+#define KNOD_IPSEC_REPLAY_BYTES		(KNOD_IPSEC_REPLAY_WORDS * 4)
+
+/*
+ * CPU-side per-queue sliding anti-replay window (knod_ipsec_sa_window).
+ * Independent from the GPU-side REPLAY_BITS above - the shader's
+ * replay region stays 128 bits for GPU-visible state, but the CPU path
+ * needs a much larger window because with multi-queue RSS the packets
+ * of a single SA may land on several RX queues due to NIC hash
+ * collisions. Each per-queue window then sees only a sparse subset of
+ * the SA's monotonic seq stream, and the seq gap between consecutive
+ * packets arriving at one queue can exceed 128 easily. 2048 bits lets
+ * the window absorb worst-case gaps (e.g. 8 queues x 256 batch).
+ *
+ * Sized as u64 words for easier bit-shift logic in the check function.
+ */
+#define KNOD_IPSEC_CPU_REPLAY_WORDS	32	/* 32 * 64 = 2048 bits */
+#define KNOD_IPSEC_CPU_REPLAY_BITS	\
+	(KNOD_IPSEC_CPU_REPLAY_WORDS * 64)
+
+/*
+ * Per-dispatch packet batch. The RX fused shader launches grid_y=nr_packets
+ * workgroups and each workgroup indexes its own sub[wg_y] entry, so batch
+ * scales linearly with GPU occupancy up to the LDS-bound concurrent
+ * workgroup limit (~1024 on 64-CU gfx9 with 4 KB LDS per WG). Bumping this
+ * grows:
+ *   - struct knod_ipsec_fused_param  (sub[] inline in kernarg)
+ *   - work_decrypt_pool VRAM          (BATCH * DECRYPT_PKT_SIZE)
+ *   - struct knod_ipsec_work          (rx_bds[], rx_pkt_queue[], rx_pending[])
+ */
+#define KNOD_IPSEC_PKT_BATCH		512
+
+/*
+ * Kernarg layout consumed by the fused RX shader.
+ *
+ * The shader dereferences sa_table_addr/t_tables_addr from the top-level
+ * struct and then iterates `sub[]` for per-packet work. Decrypted inner
+ * packets are written to `out_addr` (VRAM); a CPU finish worker later
+ * SDMA-copies them into a per-queue framework delivery-pool page and
+ * publishes a `knod_pass_desc` onto the framework pass_pending ring. The
+ * bd ring is not used for verdict delivery.
+ */
+struct knod_ipsec_fused_sub {
+	__le64	pkt_addr;	/* raw packet VRAM addr (ETH start) */
+	__le64	out_addr;	/* decrypted inner packet dest */
+	__le64	bd_addr;	/* SPSC bd for direct verdict write */
+	__le32	pkt_len;
+	__le32	result_seq;	/* shader writes bswapped ESP seq here */
+};
+
+struct knod_ipsec_fused_param {
+	__le64	sa_table_addr;		/* 0 */
+	__le64	t_tables_addr;		/* 8 */
+	__le64	sdma_ring_addr;		/* 16: SDMA ring buffer gaddr */
+	__le32	nr_sa;			/* 24 */
+	__le32	family_filter;		/* 28 */
+	__le64	sdma_ctl_addr;		/* 32: GPU VA of sdma_ctl region */
+	struct knod_ipsec_fused_sub sub[KNOD_IPSEC_PKT_BATCH]; /* 40 */
+};
+
+/*
+ * GPU-visible SA table entry. Layout is shared with the GPU shader and
+ * must remain stable / packed.
+ */
+struct knod_ipsec_sa_entry {
+	/* network byte order in wire, LE in table */
+	__le32	spi;
+	__le32	dir;			/* 0=IN, 1=OUT */
+	__le32	family;			/* AF_INET=2, AF_INET6=10 */
+	__le32	flags;			/* bit0: ESN, bit1: CRYPT_ONLY */
+	__le64	key_gpu_addr;		/* AES key buffer (VRAM) */
+	__le64	htable_gpu_addr;	/* GHASH H-power table (VRAM) */
+	__le64	t_tables_gpu_addr;	/* shared T-tables (VRAM) */
+	u8	salt[4];
+	__le32	key_len;		/* 16/24/32 */
+	__le32	nr_rounds;		/* AES rounds: 10/12/14 */
+	/* XFRM_MODE_TRANSPORT=0, XFRM_MODE_TUNNEL=1 */
+	__le32	mode;
+	__le64	replay_bitmap_addr;	/* GPU-visible replay bitmap */
+	__le32	replay_window;		/* 64/128/256 */
+	__le32	seq_hi;			/* ESN high-32 */
+	__le64	seq_last;		/* last accepted sequence number */
+	__le32	active;
+	__le32	version;		/* rekey protection */
+	__le64	stats_addr;		/* per-SA counters (optional) */
+	__le64	_pad1;
+};
+
+#define KNOD_IPSEC_SA_ENTRY_SIZE	sizeof(struct knod_ipsec_sa_entry)
+#define KNOD_IPSEC_SA_TABLE_SIZE	\
+	(KNOD_IPSEC_NR_SA * KNOD_IPSEC_SA_ENTRY_SIZE)
+
+/*
+ * Replay bitmap + per-SA stats regions are appended to the SA entry table
+ * inside the same backing BO. Keeping everything in one BO avoids the
+ * multi-BO GPU VA mapping bug (see gtt_multi_bo_bug.md).
+ */
+#define KNOD_IPSEC_REPLAY_REGION_SIZE	\
+	(KNOD_IPSEC_NR_SA * KNOD_IPSEC_REPLAY_BYTES)
+#define KNOD_IPSEC_REPLAY_REGION_OFF	KNOD_IPSEC_SA_TABLE_SIZE
+
+/*
+ * Per-SA GPU-visible stats. The shader atomically increments these via
+ * global_atomic_add_x2 on every successful decrypt. CPU reads them back
+ * in xdo_state_update_stats to feed x->curlft.
+ */
+struct knod_ipsec_sa_gpu_stats {
+	__le64	rx_packets;
+	__le64	rx_bytes;
+};
+
+#define KNOD_IPSEC_SA_STATS_SIZE	sizeof(struct knod_ipsec_sa_gpu_stats)
+#define KNOD_IPSEC_STATS_REGION_SIZE	\
+	(KNOD_IPSEC_NR_SA * KNOD_IPSEC_SA_STATS_SIZE)
+#define KNOD_IPSEC_STATS_REGION_OFF	\
+	(KNOD_IPSEC_REPLAY_REGION_OFF + KNOD_IPSEC_REPLAY_REGION_SIZE)
+
+#define KNOD_IPSEC_SA_BO_SIZE		\
+	(KNOD_IPSEC_SA_TABLE_SIZE + KNOD_IPSEC_REPLAY_REGION_SIZE + \
+	 KNOD_IPSEC_STATS_REGION_SIZE)
+
+/*
+ * RFC 4303 anti-replay sliding window - CPU-side, per-SA, per-RXQ.
+ *
+ * RSS hashes ESP flows on (saddr, daddr, proto, SPI) so that every packet
+ * of a given SA lands on the same NIC RX queue. That means a single writer
+ * (the NIC dd NAPI for that queue) owns the window and no locking is
+ * required on the fast path. Replicated per queue because different SAs
+ * may still be hashed to different queues, and we do not want false
+ * sharing between queues on a shared cacheline.
+ */
+struct knod_ipsec_sa_window {
+	u64 top_seq;			/* highest accepted seq */
+	/* N*64-bit sliding window */
+	u64 bitmap[KNOD_IPSEC_CPU_REPLAY_WORDS];
+};
+
+/* CPU-side slot metadata */
+struct knod_ipsec_sa_slot {
+	struct xfrm_state *x;		/* back pointer (CPU only) */
+	struct knod_mem *key_mem;
+	struct knod_mem *htable_mem;
+	struct knod_mem *replay_mem;
+	u32 spi;			/* host order */
+	u32 slot_idx;
+	u32 version;
+	bool active;
+	/* Per-RXQ sliding window state. Owned by the NIC dd NAPI for that
+	 * queue - do not touch from control plane while SA is active.
+	 */
+	struct knod_ipsec_sa_window win[KNOD_SPSC_MAX];
+};
+
+/* Percpu stats for observability */
+struct knod_ipsec_stats {
+	/* RX */
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_dispatches;
+	u64 rx_batch_total;
+	u64 rx_batch_max;
+	/* SDMA copy observability: per dispatch we emit 1 copy per raw-bypass
+	 * or tunnel packet, 2 copies per transport packet (outer L3 + inner
+	 * payload). rx_sdma_copies_total accumulates every call; max tracks
+	 * the peak single-dispatch count; bytes tracks total DMA volume.
+	 */
+	u64 rx_sdma_copies_total;
+	u64 rx_sdma_copies_max;
+	u64 rx_sdma_bytes_total;
+	u64 rx_drop_icv;
+	u64 rx_drop_replay;
+	u64 rx_drop_no_sa;
+	u64 rx_drop_malformed;
+	u64 rx_drop_desc_full;
+	u64 rx_drop_sdma_full;
+	/* Per-phase RX dispatch timings, accumulated per percpu counter.
+	 * Hot path guarded by ipsec_stats_enabled_key static branch so
+	 * they cost zero cycles when disabled.
+	 *
+	 * rx_build_ns     : try_rx pre-scan + per-queue drain loop
+	 *                   (CPU staging work into kernarg sub[]).
+	 * rx_gpu_ns       : spin on GPU completion signal.
+	 * rx_sdma_ns      : spin on SDMA fence after finish scheduled
+	 *                   per-packet SDMA copies.
+	 * rx_finalise_ns  : finish_rx_deliver CPU work excluding SDMA
+	 *                   fence wait (verdict loop + desc publish +
+	 *                   per-queue NAPI schedule).
+	 * rx_total_ns     : end-to-end try_rx call time (build + dispatch
+	 *                   wait + finalise + napi kicks).
+	 * rx_idle_ns      : time the dispatcher spent in usleep_range
+	 *                   waiting for work when both try_tx and
+	 *                   try_rx returned false.
+	 */
+	u64 rx_build_ns;
+	u64 rx_gpu_ns;
+	u64 rx_sdma_ns;
+	u64 rx_finalise_ns;
+	u64 rx_total_ns;
+	u64 rx_idle_ns;
+	/* Control plane */
+	u64 sa_add;
+	u64 sa_del;
+	u64 sa_rekey;
+	/* Debug: drain_rx pipeline visibility */
+	u64 drain_calls;
+	u64 drain_found;
+	u64 drain_delivered;
+	u64 finish_produced;
+	u64 rx_peek_total;
+	u64 rx_submit_fail;
+	/* drain_rx per-phase timing (ns, summed). Each drain_rx call
+	 * processes `drain_found` descriptors; these buckets split the
+	 * CPU work per-phase so we can see which step dominates:
+	 *   drain_alloc_ns  : knod_pass_build_skb cost
+	 *   drain_copy_ns   : legacy copy cost (0 - delivery is zero-copy)
+	 *   drain_proto_ns  : L3 header patch + secpath setup
+	 *   drain_gro_ns    : netif_receive_skb_list (stack entry)
+	 *   drain_total_ns  : end-to-end drain_rx call time
+	 * Guarded by ipsec_stats_enabled_key so zero cost when off.
+	 */
+	u64 drain_alloc_ns;
+	u64 drain_copy_ns;
+	u64 drain_proto_ns;
+	u64 drain_gro_ns;
+	u64 drain_total_ns;
+	u64 drain_zc_ok;
+	u64 drain_zc_fallback;
+};
+
+/*
+ * Work-slot pool owned by the dispatcher kthread. Depth-2 pipelining:
+ * while one slot is executing on the GPU, the dispatcher can build and
+ * submit the next batch into the other slot and finalise the one that
+ * just completed. kaql[0] is still a single AQL queue; multiple
+ * in-flight dispatches are queued in-order and complete in-order.
+ *
+ * A slot's lifecycle:
+ *   EMPTY          -> try_tx/try_rx fills kernarg and submits -> INFLIGHT
+ *   INFLIGHT       -> GPU running; dispatcher polls completion signal
+ *   INFLIGHT       -> signal fires -> start SDMA copies + fence (no spin)
+ *                    -> SDMA_PENDING
+ *   SDMA_PENDING   -> dispatcher polls SDMA fence (non-blocking)
+ *   SDMA_PENDING   -> fence done -> desc publish, napi kicks, bd PASS,
+ *                    stats -> EMPTY
+ *
+ * The SDMA_PENDING state decouples the SDMA fence wait from the
+ * dispatcher loop so the CPU never busy-spins on the fence. While
+ * one slot sits in SDMA_PENDING, the dispatcher can build and
+ * submit the next batch into another EMPTY slot - true 3-way
+ * parallelism of GPU execution, SDMA transfer, and CPU build.
+ */
+#define KNOD_IPSEC_NR_WORK		4
+
+/*
+ * Front offset reserved in each delivery page (= IPv4 transport L3 size).
+ * The shader decrypts into a per-work VRAM output buffer; finish_rx_deliver
+ * then SDMA-lays the packet into the delivery page by mode:
+ *
+ *   transport: outer L3 header (20B IPv4 / 40B IPv6) to page+0, decrypted
+ *              L4 payload to page+l3_len; inner_off = 0.
+ *   tunnel:    decrypted inner L3 packet to page+GTT_OUT_L3_OFF, leaving
+ *              20B of headroom at the front; inner_off = 20.
+ *
+ * (The name is a holdover from a removed mode where the shader wrote
+ * straight into a GTT slot at this offset.)
+ */
+#define KNOD_IPSEC_GTT_OUT_L3_OFF	20
+
+/*
+ * GPU-initiated SDMA control block, placed at a fixed offset after
+ * knod_ipsec_fused_param in the same kernarg BO.  The shader's Phase 12
+ * uses atomic counters here to coordinate multi-workgroup SDMA ring
+ * writes without CPU involvement.
+ */
+#define KNOD_IPSEC_SDMA_CTL_OFF \
+	ALIGN(sizeof(struct knod_ipsec_fused_param), 64)
+
+struct knod_ipsec_sdma_ctl {
+	/*  0: atomic - SDMA-needing WGs increment */
+	__le32	claim_counter;
+	__le32	done_counter;		/*  4: atomic - ALL WGs increment */
+	/*  8: current wptr byte offset (CPU snapshot) */
+	__le64	wptr_val;
+	__le64	fence_addr;		/* 16: SDMA fence write target GPU VA */
+	/* 24: value SDMA writes on completion */
+	__le32	fence_val;
+	/* 28: wptr_val / 4 (dword index into ring) */
+	__le32	wptr_base_dw;
+	__le32	ring_mask;		/* 32: (ring_size_bytes/4) - 1 */
+	__le32	nr_total_wg;		/* 36: grid_size_y = nr_packets */
+	__le32	copy_hdr;		/* 40: SDMA COPY_LINEAR header dword */
+	__le32	fence_hdr;		/* 44: SDMA FENCE header dword */
+	__le32	gpu_sdma_ready;		/* 48: last WG sets 1 -> CPU polls */
+	/* 52: total SDMA COPY packets emitted */
+	__le32	final_sdma_count;
+	/* 56: GPU VA of HW wptr (queue->gaddr+8) */
+	__le64	wptr_gpu_addr;
+};
+
+enum knod_ipsec_work_state {
+	KNOD_WORK_EMPTY = 0,
+	KNOD_WORK_INFLIGHT,
+	KNOD_WORK_SDMA_PENDING,
+};
+
+/*
+ * Per-work RX decrypt output buffer size. AES-CTR decrypt writes plaintext
+ * here instead of overwriting the ciphertext in-place (which would corrupt
+ * the data before GHASH reads it). One slot per packet in the batch.
+ *
+ * Must hold the largest expected plaintext (ctext_len, before ESP trailer
+ * strip). Sized for MTU 9000 ESP jumbo frames (up to ~9200B total),
+ * rounded up to 16 KB. At PKT_BATCH=64 the total pool is 1 MB of VRAM.
+ * Smaller values silently corrupt adjacent slots and eventually fault
+ * past the end of the pool BO.
+ */
+#define KNOD_IPSEC_DECRYPT_PKT_SIZE	16384
+#define KNOD_IPSEC_DECRYPT_WORK_SIZE	\
+	((size_t)KNOD_IPSEC_PKT_BATCH * KNOD_IPSEC_DECRYPT_PKT_SIZE)
+
+/*
+ * Per-work kernarg and decrypt buffers are SLICES of a single large
+ * BO owned by `struct knod_ipsec_works`, not individual BOs. Allocating
+ * many small BOs and mapping them all to the KFD process GPU VA hits a
+ * long-standing AMDKFD issue where only the first BO is reliably mapped
+ * (see memory/gtt_multi_bo_bug.md) - subsequent BOs fault on GPU access.
+ * One large pool BO, sliced at fixed offsets, sidesteps this entirely.
+ */
+struct knod_ipsec_slice {
+	void	*kaddr;
+	u64	gaddr;
+};
+
+/*
+ * Per-packet finish state built by knod_ipsec_finish_rx_deliver() while it
+ * schedules SDMA copies, then read back to publish desc_ring entries.
+ *
+ * Kept as an array inside struct knod_ipsec_work so the dispatcher does
+ * not have to stack-allocate BATCH * sizeof(...) on every finalise - at
+ * large PKT_BATCH values (512+) stack allocation would overflow the
+ * 16 KB kernel stack.
+ */
+struct knod_ipsec_rx_pending {
+	netmem_ref netmem;	/* delivery page from framework pass_pool */
+	u32	inner_len;	/* bytes copied into the delivery page   */
+	u32	sa_slot;	/* SA table index, or KNOD_IPSEC_NR_SA (raw) */
+	u16	rxq_idx;	/* which priv->rxq[] this packet belongs to */
+	u8	mode;		/* XFRM_MODE_TRANSPORT / TUNNEL          */
+	u8	next_hdr;	/* ESP trailer next_hdr                  */
+	u8	family;		/* AF_INET / AF_INET6                    */
+	u8	inner_off;	/* byte offset within the delivery page  */
+	u8	_pad[2];
+};
+
+struct knod_ipsec_work {
+	/* Views into the shared pools in priv. No per-work BO. */
+	struct knod_ipsec_slice	param;	/* kernarg slice (VRAM pool) */
+	/* RX decrypt output (VRAM pool) */
+	u64			rx_out_gaddr;
+	/* Pipelined slot state + deferred finalise tracking. The dispatcher
+	 * sets state to INFLIGHT on submit, polls completion, then flips to
+	 * EMPTY after finalise. Timestamps / per-queue napi info captured
+	 * at build time get consumed when finalise runs later.
+	 */
+	enum knod_ipsec_work_state state;
+	u64			t_build_start;
+	u64			t_build_end;
+	u64			t_submit;
+	u64			t_finalise_start;
+	/* Per-queue tracker for deferred napi_schedule. try_rx records
+	 * which NIC RX queues had packets drained into this slot so the
+	 * finalise path (running later, possibly one iteration later) can
+	 * wake those NAPIs after finalise completes.
+	 */
+	u16			per_q_touched[KNOD_SPSC_MAX];
+	int			per_q_n;
+	/* Per-dispatch state (owned by dispatcher) */
+	s64			sigval;
+	u64			dispatch_ts;
+	/* SDMA deferred-fence state. When the work transitions from
+	 * INFLIGHT -> SDMA_PENDING, finish_rx_deliver queues copies +
+	 * fence but does NOT spin. The dispatcher checks sdma_fence_ptr
+	 * on the next iteration and transitions to EMPTY once the fence
+	 * fires. sdma_fence_target is the expected fence value; the
+	 * pointer is the host-visible signal->value location.
+	 */
+	u32			sdma_fence_target;
+	s64			*sdma_fence_ptr;
+	u64			sdma_submit_ns;
+	/* Carry the SDMA fence wait time out of finish_rx_deliver so
+	 * the caller (try_rx) can subtract it from the finalise phase
+	 * and report it as rx_sdma_ns. Zero when stats are disabled.
+	 */
+	u64			sdma_wait_ns;
+	/* Per-dispatch SDMA copy accounting (populated by finish_rx_deliver).
+	 * rx_sdma_copies = number of knod_sdma_copy() calls issued this
+	 * batch (1 per raw/tunnel packet, 2 per transport packet). bytes =
+	 * total bytes DMA'd. Zero when stats are disabled.
+	 */
+	u32			rx_sdma_copies;
+	u32			rx_sdma_bytes;
+	/* Deferred SDMA completion state. finish_rx_deliver stores
+	 * n_sdma_pending + pkt_idx_of[] so the dispatcher's
+	 * SDMA_PENDING -> EMPTY transition can publish descs and mark
+	 * bds without re-scanning the verdict loop.
+	 */
+	int			n_sdma_pending;
+	u16			sdma_pkt_idx_of[KNOD_IPSEC_PKT_BATCH];
+	int			nr_packets;
+	/* RX: napi to kick after GPU writes verdicts (single-queue fallback
+	 * for KAT; production multi-queue dispatch schedules per-queue napis
+	 * at dispatcher level and leaves rx_napi == NULL).
+	 */
+	struct napi_struct	*rx_napi;
+	int			rx_queue_idx;
+	struct spsc_bd		*rx_bds[KNOD_IPSEC_PKT_BATCH];
+	/* Per-packet queue index for multi-queue batched RX dispatches.
+	 * finish_rx_deliver uses this to route each decrypted packet to
+	 * the correct priv->rxq[] delivery pool + desc_ring.
+	 */
+	u8			rx_pkt_queue[KNOD_IPSEC_PKT_BATCH];
+	/* Heap-backed finish-state scratchpad used by finish_rx_deliver.
+	 * Sized to KNOD_IPSEC_PKT_BATCH so we never overflow the dispatcher
+	 * kernel stack when BATCH grows.
+	 */
+	struct knod_ipsec_rx_pending rx_pending[KNOD_IPSEC_PKT_BATCH];
+};
+
+/*
+ * Hard upper bound on parallel dispatchers. Each dispatcher owns one
+ * kaql[i] / sdma[i] pair, one private slice of work_pool and the
+ * backing pool BOs, and one contiguous range of RX queues. The actual
+ * count is knod_ipsec_priv::nr_dispatchers, set at
+ * start time from knod->queue_cnt.
+ *
+ * Bumped beyond 1 for real parallelism: one GPU AQL queue is a
+ * hardware FIFO, so throughput is single-kaql drain rate bound. Two
+ * kaqls let the GPU scheduler run two dispatches on disjoint CUs in
+ * parallel, subject to CU / memory bandwidth contention.
+ */
+#define KNOD_IPSEC_MAX_DISPATCHERS	4
+
+/*
+ * Per-dispatcher runtime state. Each dispatcher kthread owns exactly
+ * one of these and never shares hot-path state with any other
+ * dispatcher - cursors, in-flight work slots, pool BOs, fence counters
+ * and the kaql/sdma index are all private.
+ *
+ * Cross-dispatcher sharing lives in knod_ipsec_priv: the SA table +
+ * slot array + spi_to_slot xarray (read-mostly), the per-CPU stats,
+ * and the delivery pool / desc_ring for RX delivery (but each rxq slot is
+ * only drained by the owning dispatcher, so no locking needed inside
+ * a queue).
+ */
+struct knod_ipsec_dispatcher {
+	struct knod_ipsec_priv	*priv;
+	struct task_struct	*kthread;
+
+	/* kaql[kaql_idx] + sdma[kaql_idx] owned exclusively by this disp. */
+	int			kaql_idx;
+
+	/* Slice into priv->work_pool[]. Dispatcher N uses slots
+	 * [work_first, work_first+work_count). work_count is usually
+	 * KNOD_IPSEC_NR_WORK but can be smaller if the final dispatcher
+	 * got a partial slice.
+	 */
+	int			work_first;
+	int			work_count;
+
+	/* Private backing BOs for this dispatcher's work slice. Each
+	 * slot within [work_first, work_first+work_count) gets its own
+	 * sub-range of these BOs, so no cross-dispatcher aliasing.
+	 */
+	struct knod_mem		*param_pool;
+	struct knod_mem		*decrypt_pool;
+
+	/* RX queue range this dispatcher drains. [rxq_first, rxq_first+
+	 * rxq_count) indexes into priv->rxq[] and knodev->wpriv[].spsc_bds.
+	 */
+	int			rxq_first;
+	int			rxq_count;
+
+	/* Hot-path cursors, previously locals in the dispatcher loop. */
+	int			rx_rr;
+	int			build_cursor;
+
+	/* Forward-looking AQL completion-signal counter. See old priv->
+	 * dispatch_sigval_next comment; now per-dispatcher because each
+	 * disp has its own kaql signal.
+	 */
+	s64			dispatch_sigval_next;
+};
+
+struct knod_ipsec_priv {
+	struct knod *knod;
+	struct knod_dev *knodev;
+
+	/* Shared GCM tables (VRAM, one per priv, owned by knod ctx) */
+	struct knod_mem *t_tables;
+
+	/* GPU-visible SA table */
+	struct knod_mem *sa_table;
+
+	/* CPU-side slot metadata */
+	struct knod_ipsec_sa_slot slots[KNOD_IPSEC_NR_SA];
+	struct xarray spi_to_slot;
+	struct mutex slot_lock;
+
+	/*
+	 * Work pool is sized NR_WORK * MAX_DISPATCHERS so each
+	 * dispatcher gets its own NR_WORK-sized slice via work_first.
+	 * With nr_dispatchers=1 only the first slice is populated, so
+	 * runtime cost is identical to the old single-slot layout when
+	 * a single dispatcher is in use.
+	 */
+	struct knod_ipsec_work	work_pool[KNOD_IPSEC_NR_WORK *
+					  KNOD_IPSEC_MAX_DISPATCHERS];
+
+	/* Number of NIC RX queues bound to the NOD (<= KNOD_SPSC_MAX); the
+	 * finish worker bounds-checks the shader's queue index against it.
+	 */
+	int			nr_rxq;
+
+	/* Dispatcher state. nr_dispatchers <= KNOD_IPSEC_MAX_DISPATCHERS,
+	 * set at start time from the knod queue_cnt the accel was
+	 * created with. Each disp[i] owns kaql[i] / sdma[i].
+	 */
+	struct knod_ipsec_dispatcher disp[KNOD_IPSEC_MAX_DISPATCHERS];
+	int			nr_dispatchers;
+	bool			running;
+	u32			pkt_batch;
+
+	/* Shaders */
+	size_t shader_size;
+	int isa_version;
+
+	/* Observability */
+	struct dentry *debug_dir;
+	struct knod_ipsec_stats __percpu *stats;
+
+	/* Persistent KAT scratch BO. Allocated once at priv init, reused on
+	 * every KAT invocation. Re-allocating per-KAT re-triggers the GTT/VRAM
+	 * multi-BO mapping symptom (only the first BO is reliably mapped on
+	 * the KFD process VM), which is the same class of bug documented for
+	 * the BPF delivery path. One long-lived BO sidesteps it entirely.
+	 */
+	struct knod_mem *kat_scratch;
+};
+
+/* Public entry points for NIC consumers. */
+struct spsc_bd;
+int knod_ipsec_rx_submit(struct knod_ipsec_fused_sub *sub, int nr,
+			 struct napi_struct *napi, int queue_idx);
+int knod_ipsec_rx_submit_bds(struct knod_ipsec_fused_sub *sub,
+			     struct spsc_bd **bds, int nr,
+			     struct napi_struct *napi, int queue_idx);
+
+#endif /* KNOD_IPSEC_H_ */
diff --git a/tools/testing/selftests/drivers/net/knod/config b/tools/testing/selftests/drivers/net/knod/config
index a60ece9da112..837187205f89 100644
--- a/tools/testing/selftests/drivers/net/knod/config
+++ b/tools/testing/selftests/drivers/net/knod/config
@@ -4,4 +4,5 @@ CONFIG_XDP_SOCKETS=y
 CONFIG_KNOD=m
 CONFIG_HSA_AMD=y
 CONFIG_HSA_AMD_KNOD_BPF=m
+CONFIG_HSA_AMD_KNOD_IPSEC=m
 CONFIG_DEBUG_FS=y
-- 
2.43.0

