Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6218D3B893A
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484145; cv=none; b=WAp3OSnnrut0lXwWCDOssZJkfcPW3YJaxrwaz7uCcmQAKcrDmcU8Lu3Xik4nqcazBbMuUgGGdlZ/9rTIKLGUil5S1eR8G/rdk30+koMkoE4Bvifblu158cLyfLf1UMMnjgy2OChBPpPqOzkp0rxPlp70lTLZiJwfpIt1c7CiHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484145; c=relaxed/simple;
	bh=Dfe8PX9EwXjJhm9Lnw+rhy+oUGJuYVGlKOauhy5RtYo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLV4Q0mhFAUcLXHHnAiHn9aJwT5DeHwcxV3zoed0sTPGeF6d5y/FNLoIagSDpbUr26gr0jj7UDjlY0uzHpjmOIOba2zhU+08JFpwZanf00rO3jsgPBxOclwqOBM7KiobmZ3R13wf7xu26vftUYqICRamJ2NTzkr7X3MUsUPfrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iy9GTXAC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iy9GTXAC"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ceb096e675so90511895ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484125; x=1785088925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FubUQWQXxGaLpagBZT9hiz5/sPKLgHImpVUa5N7oZFI=;
        b=Iy9GTXACKLjjCFoIEkSh3MC5gzJvk0HM28ylxyhW3lBJZw28iolngPyVsjUqkrL0IP
         lofpJ65qGrTdxCUfTIjKv6ci7nSCeTgkp3pj7JPjainrHwytrxPUog750jObhLSzIDqa
         c3KiyFugwkW1a2fZrTmVPs50jH93aX/jvLHA8S4sYMC5pDKEi2HYNUNXeyOrRd+KQruX
         Kz2GFWpx8nHuhxtX2psP0Zz6vn5rmpTNJS9Gi29IkfZuOnOOQaSrXkKZNpsDzKOZT7/R
         eP7BJQmxmnmoxFI7mVrB/7JmeyYyrg41kE+/PFQENDIKG+ksJVpNYbCzIiCGlUEzoVMN
         D/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484125; x=1785088925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FubUQWQXxGaLpagBZT9hiz5/sPKLgHImpVUa5N7oZFI=;
        b=KCcXflVpFF2jNchfS6xBVnl0g556fAPB2O8HuONcbeUIAuKeFA6CAwiQU9g+3BUcBT
         QHrgKGk62bG9vbNMKOMGkDRtQMF2jc8TcQUmiD3EXrXU7XIANizsyUb8bBqNYE5aZ/kf
         eQaluyN/nDPfykBjKxsMPkZBjs6Jaj1ASQa2WEe/qTZmgb5XKFIxH7wUQHow8u0VSbu6
         H6fUZnMt64k+QIjVj5HrgiGQG8QVWk2QD0Ca2+lGo8/JnKcf2FjHvz9Q5urLW3KIQv1x
         ErTRFO1YywzC884NoFFuL6KZBNpWSxOhfcZXjuuLiBikDgxPJ3pD8/KrVUE4k2OlUkyn
         cfgg==
X-Forwarded-Encrypted: i=1; AHgh+RpkVKQHhSycD8o9PFrdoHfw/baYVhwfhr4mB9HzHb7VmuMc3bUAn0eiyEphkBoQKJG8oVGmw8ubc3g4@vger.kernel.org
X-Gm-Message-State: AOJu0YybkzxZUuJy2T2i8jdWmkuzMU3VaHtO6E2rESUIyVJF+B2KCuEU
	aU3LNg2ox0of1ShGiy1kKfaxWO/wZOv3l/pNYekXFunzR6DS0X1qQ5PiJ5YJ26nEwyU=
X-Gm-Gg: AfdE7clP7PalFOgMYSZ9exgGOOHK4SThxOIa0gu4E0WF5/2iqIgjB5w1f68zsH4Q2nQ
	DYkVnCzfCdW8HS3ZYF32D3zh3yZzPjeHr++Zfm+JFwlzDhYxvaOlGm3EQZgJ6h1dh0X2CBoe6zu
	R6YuB9JfWRcEIzXn3JDBTzQyf6ZFe7ECikGTnEoRLAUCiZWk6usFpaa1O5i1oS0Hzslqw3AMcze
	fWCS4ymgcRBZdd4H3Fh2C+SmgMR5pFyaeVzM1Tp8/qFPEwNRMpx0krP5O6Q4V7dTb7yj/gxwHHB
	vejozaVouFgLYhnvvjqZO+rEdDFyB7Xb6ghUXpJB7Bvy1wjz+UeAKu/L8PE3NNiIMnufQUO2LaI
	N96Y/HtRnYOKI1RPxyoAsWWJSfYtAZYF362AQ1U89y22GsFq03FK1+Lb3uMX6j+k5+w==
X-Received: by 2002:a17:903:3510:b0:2cc:6817:d9bc with SMTP id d9443c01a7336-2cf349ea184mr118699745ad.38.1784484124796;
        Sun, 19 Jul 2026 11:02:04 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.11.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:02:03 -0700 (PDT)
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
Subject: [RFC PATCH net-next 12/13] selftests: drivers/net: add knod tests
Date: Sun, 19 Jul 2026 17:58:56 +0000
Message-ID: <20260719175857.4071636-13-ap420073@gmail.com>
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

Add attach/detach and XDP offload selftests for knod, exercising the
genetlink control plane and the BPF data path over a knod-capable NIC.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit 320315bfd9a324ab029c2fe9eee52997592e5d0c)
---
 .../selftests/drivers/net/knod/Makefile       |  17 ++
 .../testing/selftests/drivers/net/knod/config |   7 +
 .../selftests/drivers/net/knod/knod_attach.sh | 135 +++++++++++++
 .../drivers/net/knod/knod_xdp_ktime.sh        | 173 +++++++++++++++++
 .../drivers/net/knod/knod_xdp_loop.sh         | 129 +++++++++++++
 .../testing/selftests/drivers/net/knod/lib.sh | 181 ++++++++++++++++++
 .../drivers/net/knod/xdp_ktime.bpf.c          |  32 ++++
 .../selftests/drivers/net/knod/xdp_loop.bpf.c |  42 ++++
 8 files changed, 716 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/knod/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/knod/config
 create mode 100755 tools/testing/selftests/drivers/net/knod/knod_attach.sh
 create mode 100755 tools/testing/selftests/drivers/net/knod/knod_xdp_ktime.sh
 create mode 100755 tools/testing/selftests/drivers/net/knod/knod_xdp_loop.sh
 create mode 100755 tools/testing/selftests/drivers/net/knod/lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/knod/xdp_ktime.bpf.c
 create mode 100644 tools/testing/selftests/drivers/net/knod/xdp_loop.bpf.c

diff --git a/tools/testing/selftests/drivers/net/knod/Makefile b/tools/testing/selftests/drivers/net/knod/Makefile
new file mode 100644
index 000000000000..08138529b55e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+
+TEST_PROGS := \
+	knod_xdp_ktime.sh \
+	knod_xdp_loop.sh \
+	knod_attach.sh \
+# end of TEST_PROGS
+
+TEST_FILES := \
+	lib.sh \
+# end of TEST_FILES
+
+TEST_GEN_FILES += $(patsubst %.c,%.o,$(wildcard *.bpf.c))
+
+include ../../../lib.mk
+
+include ../../../net/bpf.mk
diff --git a/tools/testing/selftests/drivers/net/knod/config b/tools/testing/selftests/drivers/net/knod/config
new file mode 100644
index 000000000000..a60ece9da112
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/config
@@ -0,0 +1,7 @@
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_XDP_SOCKETS=y
+CONFIG_KNOD=m
+CONFIG_HSA_AMD=y
+CONFIG_HSA_AMD_KNOD_BPF=m
+CONFIG_DEBUG_FS=y
diff --git a/tools/testing/selftests/drivers/net/knod/knod_attach.sh b/tools/testing/selftests/drivers/net/knod/knod_attach.sh
new file mode 100755
index 000000000000..7ee6aca33ad8
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/knod_attach.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# knod_attach.sh - exercise the knod attach/detach control plane.
+#
+# Checks the NIC<->accel binding lifecycle (attach makes the pair appear in the
+# xdev list, detach removes it) and that malformed or impossible attach
+# requests are rejected without taking the framework down.
+#
+# Requires:
+#   - KNOD (knod + amdgpu) modules loaded
+#   - AMD GPU with KNOD support
+#   - a NIC registered with knod
+#   - iproute2, root
+#
+# Environment:
+#   NIC=<ifname>   (required) NIC to test on
+#   ACCEL_ID=<id>  (optional) GPU accel ID, auto-detected if omitted
+#
+# Exit: 0=pass, 1=fail, 4=skip
+
+set -o pipefail
+
+SELFDIR=$(dirname "$(readlink -f "$0")")
+source "$SELFDIR/lib.sh"
+
+: "${NIC:=}"
+: "${ACCEL_ID:=}"
+
+PASS=0
+FAIL=0
+
+cleanup() {
+	if [ -n "$NIC" ]; then
+		knod_detach "$NIC" 2>/dev/null
+		ip link set dev "$NIC" down 2>/dev/null
+	fi
+}
+trap cleanup EXIT
+
+check_result() {
+	local desc=$1
+	local ret=$2
+
+	if [ "$ret" -eq 0 ]; then
+		knod_pass "$desc"
+		PASS=$((PASS + 1))
+	else
+		knod_fail "$desc"
+		FAIL=$((FAIL + 1))
+	fi
+}
+
+# reject == the ynl attach request fails (exit nonzero)
+expect_reject() {
+	local desc=$1
+	local json=$2
+
+	if knod_ynl --do attach --json "$json" 2>/dev/null; then
+		knod_detach "$NIC" 2>/dev/null	# undo an unexpected success
+		check_result "$desc" 1
+	else
+		check_result "$desc" 0
+	fi
+}
+
+# -- prereq ------------------------------------------------------
+knod_check_prereq
+
+if [ -z "$NIC" ]; then
+	knod_skip "NIC env var not set"
+fi
+
+if ! ip link show "$NIC" >/dev/null 2>&1; then
+	knod_skip "NIC $NIC does not exist"
+fi
+
+accel_id=$(knod_find_accel)
+if [ -z "$accel_id" ]; then
+	knod_skip "no KNOD accelerator found"
+fi
+[ -n "$ACCEL_ID" ] && accel_id="$ACCEL_ID"
+
+echo "=== KNOD attach/detach control-plane test ==="
+echo "    NIC:      $NIC"
+echo "    ACCEL_ID: $accel_id"
+echo ""
+
+# attach requires the interface down; start from a known detached state
+ip link set dev "$NIC" down 2>/dev/null
+knod_detach "$NIC" 2>/dev/null
+
+# -- positive lifecycle ----------------------------------------
+knod_attach "$NIC" "$accel_id"
+check_result "attach $NIC -> accel $accel_id" $?
+
+knod_xdev_has "$NIC"
+check_result "xdev lists $NIC after attach" $?
+
+knod_detach "$NIC"
+check_result "detach $NIC" $?
+
+if knod_xdev_has "$NIC"; then
+	check_result "xdev drops $NIC after detach" 1
+else
+	check_result "xdev drops $NIC after detach" 0
+fi
+
+# -- negative requests must be rejected ------------------------
+nic_ifindex=$(knod_ifindex "$NIC")
+expect_reject "reject attach with no accel id"     "{\"nic-ifindex\":$nic_ifindex}"
+expect_reject "reject attach to nonexistent accel" "{\"nic-ifindex\":$nic_ifindex,\"accel-id\":999999}"
+expect_reject "reject attach of nonexistent NIC"   "{\"nic-ifindex\":999999,\"accel-id\":$accel_id}"
+
+ip link set dev "$NIC" up 2>/dev/null
+expect_reject "reject attach while NIC is up"      "{\"nic-ifindex\":$nic_ifindex,\"accel-id\":$accel_id}"
+ip link set dev "$NIC" down 2>/dev/null
+
+# -- framework survived the bad requests -----------------------
+knod_kernel_alive
+check_result "framework responsive after bad requests" $?
+
+# -- re-attach still works (state not corrupted) ---------------
+knod_attach "$NIC" "$accel_id"
+check_result "re-attach after errors" $?
+knod_detach "$NIC" 2>/dev/null
+
+# -- summary --------------------------------------------------
+echo ""
+echo "=== Results: $PASS passed, $FAIL failed ==="
+
+if [ "$FAIL" -gt 0 ]; then
+	exit 1
+fi
+exit 0
diff --git a/tools/testing/selftests/drivers/net/knod/knod_xdp_ktime.sh b/tools/testing/selftests/drivers/net/knod/knod_xdp_ktime.sh
new file mode 100755
index 000000000000..8df003052cb7
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/knod_xdp_ktime.sh
@@ -0,0 +1,173 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# knod_xdp_ktime.sh - test bpf_ktime_get_ns() on GPU XDP offload
+#
+# Loads an XDP program that calls bpf_ktime_get_ns() and stores
+# the result in an offloaded BPF_MAP_TYPE_ARRAY, then verifies
+# the GPU-side timestamp is sane.
+#
+# Requires:
+#   - KNOD (knod + amdgpu) modules loaded
+#   - AMD GPU with KNOD support
+#   - NIC with xdpoffload support (mlx5, bnxt)
+#   - bpftool, iproute2
+#   - root privileges
+#   - xdp_ktime.bpf.o (built by make)
+#
+# Environment:
+#   NIC=<ifname>       (required) NIC to test on
+#   ACCEL_ID=<id>      (optional) GPU accel ID, auto-detected if omitted
+#   REMOTE_IP=<ip>     (optional) ping target to generate traffic
+#
+# Exit: 0=pass, 1=fail, 4=skip
+
+set -o pipefail
+
+SELFDIR=$(dirname "$(readlink -f "$0")")
+source "$SELFDIR/lib.sh"
+
+: "${NIC:=}"
+: "${ACCEL_ID:=}"
+: "${REMOTE_IP:=}"
+
+PASS=0
+FAIL=0
+BPF_OBJ="$SELFDIR/xdp_ktime.bpf.o"
+
+cleanup() {
+	if [ -n "$NIC" ]; then
+		knod_cleanup "$NIC"
+	fi
+}
+trap cleanup EXIT
+
+check_result() {
+	local desc=$1
+	local ret=$2
+
+	if [ "$ret" -eq 0 ]; then
+		knod_pass "$desc"
+		PASS=$((PASS + 1))
+	else
+		knod_fail "$desc"
+		FAIL=$((FAIL + 1))
+	fi
+}
+
+# -- prereq ------------------------------------------------------
+knod_check_prereq
+
+if [ -z "$NIC" ]; then
+	knod_skip "NIC env var not set"
+fi
+
+if ! ip link show "$NIC" >/dev/null 2>&1; then
+	knod_skip "NIC $NIC does not exist"
+fi
+
+accel_id=$(knod_find_accel)
+if [ -z "$accel_id" ]; then
+	knod_skip "no KNOD accelerator found"
+fi
+[ -n "$ACCEL_ID" ] && accel_id="$ACCEL_ID"
+
+echo "=== KNOD XDP ktime_get_ns test ==="
+echo "    NIC:      $NIC"
+echo "    ACCEL_ID: $accel_id"
+echo ""
+
+# -- check BPF object ------------------------------------------
+if [ ! -f "$BPF_OBJ" ]; then
+	echo "FAIL: $BPF_OBJ not found (run make first)"
+	exit 1
+fi
+
+# -- attach NIC to GPU, select bpf feature ---------------------
+ip link set dev "$NIC" down 2>/dev/null
+knod_attach "$NIC" "$accel_id"
+if [ $? -ne 0 ]; then
+	echo "FAIL: attach failed"
+	exit 1
+fi
+
+knod_feature_select "$accel_id" bpf
+if [ $? -ne 0 ]; then
+	knod_skip "cannot select bpf feature"
+fi
+
+# -- load XDP offload program ----------------------------------
+knod_xdp_load "$NIC" "$BPF_OBJ"
+if [ $? -ne 0 ]; then
+	echo "FAIL: xdpoffload load failed"
+	exit 1
+fi
+
+# -- find prog/map IDs -----------------------------------------
+prog_id=$(bpftool prog show 2>/dev/null | \
+	  awk '/xdp_ktime_test/ {sub(/:/, "", $1); print $1; exit}')
+if [ -z "$prog_id" ]; then
+	echo "FAIL: cannot find loaded BPF program"
+	exit 1
+fi
+knod_log "prog_id=$prog_id"
+
+map_id=$(knod_get_map_id "$prog_id")
+if [ -z "$map_id" ]; then
+	echo "FAIL: cannot find BPF map"
+	exit 1
+fi
+knod_log "map_id=$map_id"
+
+# -- bring up interface and generate traffic -------------------
+ip link set dev "$NIC" up
+
+if [ -n "$REMOTE_IP" ]; then
+	knod_log "ping $REMOTE_IP to generate traffic"
+	ping -c 5 -W 1 "$REMOTE_IP" >/dev/null 2>&1 || true
+else
+	knod_log "waiting for ambient traffic (10s)"
+	sleep 10
+fi
+
+# -- bring down interface before reading map ------------------
+ip link set dev "$NIC" down
+
+# -- read map and verify --------------------------------------
+ktime_val=$(knod_map_lookup_u64 "$map_id" 0)
+pkt_count=$(knod_map_lookup_u64 "$map_id" 1)
+
+knod_log "ktime_ns=$ktime_val  pkt_count=$pkt_count"
+
+# Test 1: packets were processed
+rc=0
+[ "$pkt_count" -gt 0 ] || rc=1
+check_result "packets processed (count=$pkt_count)" $rc
+
+# Test 2: ktime is non-zero
+rc=0
+[ "$ktime_val" -gt 0 ] || rc=1
+check_result "ktime non-zero ($ktime_val)" $rc
+
+# Test 3: ktime is within 30s of current time
+if [ "$ktime_val" -gt 0 ]; then
+	now_ns=$(awk '{printf "%.0f", $1 * 1000000000}' /proc/uptime)
+	if [ -n "$now_ns" ]; then
+		diff=$(( now_ns - ktime_val ))
+		abs_diff=${diff#-}
+		rc=0
+		[ "$abs_diff" -lt 30000000000 ] || rc=1
+		check_result "ktime within 30s of wall clock (diff=${diff}ns)" $rc
+	else
+		knod_log "skipping wall clock check (/proc/uptime unavailable)"
+	fi
+fi
+
+# -- summary --------------------------------------------------
+echo ""
+echo "=== Results: $PASS passed, $FAIL failed ==="
+
+if [ "$FAIL" -gt 0 ]; then
+	exit 1
+fi
+exit 0
diff --git a/tools/testing/selftests/drivers/net/knod/knod_xdp_loop.sh b/tools/testing/selftests/drivers/net/knod/knod_xdp_loop.sh
new file mode 100755
index 000000000000..d7cba1236968
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/knod_xdp_loop.sh
@@ -0,0 +1,129 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# knod_xdp_loop.sh - the KNOD JIT must reject a bounded-loop XDP program.
+#
+# Loop emission is not implemented yet, so a program with a real back-edge has
+# to be rejected with -EOPNOTSUPP at JIT time rather than miscompiled.  This
+# checks that the load fails, that the back-edge is reported to dmesg, and that
+# nothing crashed or faulted in the reject path.
+#
+# Requires:
+#   - KNOD (knod + amdgpu) modules loaded
+#   - AMD GPU with KNOD support
+#   - NIC with xdpoffload support (mlx5, bnxt)
+#   - bpftool, iproute2, root
+#   - xdp_loop.bpf.o (built by make)
+#
+# Environment:
+#   NIC=<ifname>   (required) NIC to test on
+#   ACCEL_ID=<id>  (optional) GPU accel ID, auto-detected if omitted
+#
+# Exit: 0=pass, 1=fail, 4=skip
+
+set -o pipefail
+
+SELFDIR=$(dirname "$(readlink -f "$0")")
+source "$SELFDIR/lib.sh"
+
+: "${NIC:=}"
+: "${ACCEL_ID:=}"
+
+PASS=0
+FAIL=0
+BPF_OBJ="$SELFDIR/xdp_loop.bpf.o"
+
+cleanup() {
+	if [ -n "$NIC" ]; then
+		knod_cleanup "$NIC"
+	fi
+}
+trap cleanup EXIT
+
+check_result() {
+	local desc=$1
+	local ret=$2
+
+	if [ "$ret" -eq 0 ]; then
+		knod_pass "$desc"
+		PASS=$((PASS + 1))
+	else
+		knod_fail "$desc"
+		FAIL=$((FAIL + 1))
+	fi
+}
+
+# -- prereq ------------------------------------------------------
+knod_check_prereq
+
+if [ -z "$NIC" ]; then
+	knod_skip "NIC env var not set"
+fi
+
+if ! ip link show "$NIC" >/dev/null 2>&1; then
+	knod_skip "NIC $NIC does not exist"
+fi
+
+accel_id=$(knod_find_accel)
+if [ -z "$accel_id" ]; then
+	knod_skip "no KNOD accelerator found"
+fi
+[ -n "$ACCEL_ID" ] && accel_id="$ACCEL_ID"
+
+if [ ! -f "$BPF_OBJ" ]; then
+	echo "FAIL: $BPF_OBJ not found (run make first)"
+	exit 1
+fi
+
+echo "=== KNOD XDP loop-rejection test ==="
+echo "    NIC:      $NIC"
+echo "    ACCEL_ID: $accel_id"
+echo ""
+
+# -- setup: attach NIC to GPU, then select the bpf feature -----
+# feature_select needs the accel already attached (it swaps the live
+# worker), so attach first.
+ip link set dev "$NIC" down 2>/dev/null
+knod_attach "$NIC" "$accel_id"
+if [ $? -ne 0 ]; then
+	echo "FAIL: attach failed"
+	exit 1
+fi
+
+knod_feature_select "$accel_id" bpf
+if [ $? -ne 0 ]; then
+	knod_skip "cannot select bpf feature"
+fi
+
+# remember where dmesg is now so we only scan messages from this load
+dmesg_mark=$(dmesg | wc -l)
+
+# -- load must fail --------------------------------------------
+knod_log "loading bounded-loop program (expecting rejection)"
+if knod_xdp_load "$NIC" "$BPF_OBJ" 2>/dev/null; then
+	# unexpectedly accepted - unload and fail
+	knod_xdp_unload "$NIC"
+	check_result "loop program rejected at load" 1
+else
+	check_result "loop program rejected at load" 0
+fi
+
+new_dmesg=$(dmesg | tail -n +"$((dmesg_mark + 1))")
+
+# -- back-edge reported ----------------------------------------
+rc=1
+echo "$new_dmesg" | grep -q "knod_loop:.*back-edge" && rc=0
+check_result "loop back-edge reported in dmesg" $rc
+
+# -- framework still alive -------------------------------------
+knod_kernel_alive
+check_result "system responsive after rejection" $?
+
+# -- summary --------------------------------------------------
+echo ""
+echo "=== Results: $PASS passed, $FAIL failed ==="
+
+if [ "$FAIL" -gt 0 ]; then
+	exit 1
+fi
+exit 0
diff --git a/tools/testing/selftests/drivers/net/knod/lib.sh b/tools/testing/selftests/drivers/net/knod/lib.sh
new file mode 100755
index 000000000000..d0d9b03f109d
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/lib.sh
@@ -0,0 +1,181 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# lib.sh - KNOD XDP offload test utilities
+#
+# The KNOD control plane is the "knod" generic-netlink family; it is driven
+# here through the in-tree ynl CLI (tools/net/ynl/pyynl/cli.py) so the tests
+# need no dedicated user-space tool.
+
+KSRC=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../../.." && pwd)
+readonly KNOD_YNL="$KSRC/tools/net/ynl/pyynl/cli.py"
+readonly KNOD_SPEC="$KSRC/Documentation/netlink/specs/knod.yaml"
+
+KNOD_NIC=""
+KNOD_ACCEL_ID=""
+KNOD_CLEANUP_DONE=0
+
+knod_log()   { echo "  [INFO] $*"; }
+knod_pass()  { echo "  [PASS] $*"; }
+knod_fail()  { echo "  [FAIL] $*"; }
+knod_skip()  { echo "  [SKIP] $*"; exit 4; }
+
+# Invoke the knod generic-netlink family via the ynl CLI.
+knod_ynl() {
+	python3 "$KNOD_YNL" --spec "$KNOD_SPEC" "$@"
+}
+
+knod_ifindex() {
+	cat "/sys/class/net/$1/ifindex" 2>/dev/null
+}
+
+knod_check_prereq() {
+	if [ "$(id -u)" -ne 0 ]; then
+		knod_skip "must be root"
+	fi
+
+	if ! command -v python3 >/dev/null 2>&1; then
+		knod_skip "python3 not found (needed for the ynl CLI)"
+	fi
+
+	if ! command -v jq >/dev/null 2>&1; then
+		knod_skip "jq not found"
+	fi
+
+	if ! knod_ynl --dump accel-get >/dev/null 2>&1; then
+		knod_skip "knod genl family not available (module not loaded?)"
+	fi
+
+	if ! command -v bpftool >/dev/null 2>&1; then
+		knod_skip "bpftool not found"
+	fi
+
+	if ! command -v ip >/dev/null 2>&1; then
+		knod_skip "iproute2 (ip) not found"
+	fi
+}
+
+# Auto-detect the id of the first amdgpu accelerator.
+knod_find_accel() {
+	if [ -n "$KNOD_ACCEL_ID" ]; then
+		echo "$KNOD_ACCEL_ID"
+		return 0
+	fi
+
+	knod_ynl --dump accel-get --output-json 2>/dev/null | \
+		jq -r 'map(select(.name | startswith("amdgpu"))) | .[0].id // empty'
+}
+
+# Locate the knod debugfs directory (the DRI minor number varies).
+knod_debug_dir() {
+	local d
+
+	for d in /sys/kernel/debug/dri/*/knod; do
+		[ -d "$d" ] && { echo "$d"; return 0; }
+	done
+	return 1
+}
+
+# Activate a KNOD offload feature ("none", "bpf", "ipsec") on <accel_id>.
+knod_feature_select() {
+	local accel_id=$1
+	local feat=$2
+
+	knod_log "feature_select accel $accel_id -> $feat"
+	knod_ynl --do accel-set \
+		--json "{\"id\":$accel_id,\"feature-ena\":\"$feat\"}" >/dev/null
+}
+
+# Confirm the framework is still responsive (used after an expected failure to
+# catch an oops/hang in the reject path). The accel inventory is persistent
+# (independent of attach), so a successful dump means the family is alive.
+knod_kernel_alive() {
+	knod_ynl --dump accel-get >/dev/null 2>&1
+}
+
+# Is <nic> currently bound to an accel (present in the dev list)?
+knod_xdev_has() {
+	local nic=$1
+	local ifindex
+
+	ifindex=$(knod_ifindex "$nic") || return 1
+	knod_ynl --dump dev-get --output-json 2>/dev/null | \
+		jq -e --argjson i "$ifindex" \
+		   'any(.[]; .["nic-ifindex"] == $i)' >/dev/null
+}
+
+knod_attach() {
+	local nic=$1
+	local accel_id=$2
+	local ifindex
+
+	ifindex=$(knod_ifindex "$nic") || return 1
+	knod_log "attach $nic (ifindex $ifindex) to accel $accel_id"
+	knod_ynl --do attach \
+		--json "{\"nic-ifindex\":$ifindex,\"accel-id\":$accel_id}" >/dev/null
+}
+
+knod_detach() {
+	local nic=$1
+	local ifindex
+
+	ifindex=$(knod_ifindex "$nic") || return 1
+	knod_log "detach $nic"
+	knod_ynl --do detach \
+		--json "{\"nic-ifindex\":$ifindex}" >/dev/null 2>&1
+}
+
+knod_xdp_load() {
+	local nic=$1
+	local obj=$2
+
+	knod_log "xdpoffload load $obj on $nic"
+	ip link set dev "$nic" xdpoffload obj "$obj" sec xdp
+}
+
+knod_xdp_unload() {
+	local nic=$1
+
+	knod_log "xdpoffload off on $nic"
+	ip link set dev "$nic" xdpoffload off 2>/dev/null
+}
+
+knod_cleanup() {
+	local nic=$1
+
+	[ "$KNOD_CLEANUP_DONE" -eq 1 ] && return
+	KNOD_CLEANUP_DONE=1
+
+	knod_log "cleanup $nic"
+	knod_xdp_unload "$nic"
+	ip link set dev "$nic" down 2>/dev/null
+	knod_detach "$nic"
+}
+
+knod_get_map_id() {
+	local prog_id=$1
+
+	bpftool prog show id "$prog_id" 2>/dev/null | \
+		grep -o 'map_ids [0-9]*' | awk '{print $2}'
+}
+
+knod_map_lookup_u64() {
+	local map_id=$1
+	local key=$2
+	local hex
+
+	hex=$(bpftool map lookup id "$map_id" \
+	      key $key 0 0 0 2>/dev/null | \
+	      grep -o 'value:.*' | sed 's/value: //')
+	if [ -z "$hex" ]; then
+		echo 0
+		return
+	fi
+
+	printf '%d' "$(echo "$hex" | awk '{
+		v = 0;
+		for (i = 8; i >= 1; i--)
+			v = v * 256 + strtonum("0x" $i);
+		printf "0x%x", v;
+	}')"
+}
diff --git a/tools/testing/selftests/drivers/net/knod/xdp_ktime.bpf.c b/tools/testing/selftests/drivers/net/knod/xdp_ktime.bpf.c
new file mode 100644
index 000000000000..5025e41cf3e8
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/xdp_ktime.bpf.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u64);
+} ktime_map SEC(".maps");
+
+SEC("xdp")
+int xdp_ktime_test(struct xdp_md *ctx)
+{
+	__u32 key_ts = 0;
+	__u32 key_cnt = 1;
+	__u64 ts = bpf_ktime_get_ns();
+	__u64 *cnt;
+	__u64 new_cnt;
+
+	bpf_map_update_elem(&ktime_map, &key_ts, &ts, BPF_ANY);
+
+	cnt = bpf_map_lookup_elem(&ktime_map, &key_cnt);
+	if (cnt) {
+		new_cnt = *cnt + 1;
+		bpf_map_update_elem(&ktime_map, &key_cnt, &new_cnt, BPF_ANY);
+	}
+
+	return XDP_PASS;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/drivers/net/knod/xdp_loop.bpf.c b/tools/testing/selftests/drivers/net/knod/xdp_loop.bpf.c
new file mode 100644
index 000000000000..87c8251cc185
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/knod/xdp_loop.bpf.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+/*
+ * Minimal bounded-loop XDP program to exercise the KNOD JIT's loop detection.
+ *
+ * The trip count is read from the packet (runtime) and unrolling is disabled,
+ * so the compiler keeps a real loop with a back-edge instead of folding it
+ * into straight-line code.  The body is an xorshift step - a non-affine
+ * recurrence the compiler cannot reduce to a closed form (a simple sum like
+ * "sum += i" gets turned into n*(n-1)/2 and the loop disappears).  It touches
+ * no memory inside the loop, so the verifier is happy, and it has the simplest
+ * shape: one back-edge, a single exit (the loop condition), no break and no
+ * early return.
+ */
+SEC("xdp")
+int xdp_loop_test(struct xdp_md *ctx)
+{
+	void *data = (void *)(long)ctx->data;
+	void *data_end = (void *)(long)ctx->data_end;
+	__u8 *pkt = data;
+	__u32 sum;
+	int i, n;
+
+	if ((void *)(pkt + 1) > data_end)
+		return XDP_DROP;
+
+	n = pkt[0] & 0x3f;		/* runtime bound, 0..63 */
+	sum = pkt[0] | 1;		/* nonzero xorshift seed */
+
+#pragma clang loop unroll(disable)
+	for (i = 0; i < n; i++) {
+		sum ^= sum << 13;
+		sum ^= sum >> 17;
+		sum ^= sum << 5;
+	}
+
+	return (sum & 1) ? XDP_PASS : XDP_DROP;
+}
+
+char LICENSE[] SEC("license") = "GPL";
-- 
2.43.0

