Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3323B38BE;
	Mon, 27 Apr 2026 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777332572; cv=none; b=lspAGZODZJvVeVvIFxLY7xS2MT/hIlb8qgLDh6D3pJfrScxCXQIeDdDy0Tbx9GecpTuPASIDNB68XSbXjtxM5M+VBUAdzB4L7iZZnP9LunV2UAF1FQBBDY+4Jg9H2FDo2iGzRHebyoTxF4ZmXro2L/+RbX10eGF1OQUcxe+PRMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777332572; c=relaxed/simple;
	bh=QqLIPFFrNU4pGo791LfTUzK8uXHG4Bv2RCgS+awKohs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yul75w8x38OvWGfiT9coHNV+2bj4uBked8J7NvJJ5Ka2oe7zdhdJcz2w0ODufrpaNEJ9EP3AnyFzIa3Jcc9CxF6Ctysu8YllO05qHWJ3nxjZ3GJNPEflC387skCASP28CYhS1qp5yL3+8EtSbHL3lIeBPZEFFQwhF7vdepkDEUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqxWhrZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqxWhrZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C75C19425;
	Mon, 27 Apr 2026 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777332571;
	bh=QqLIPFFrNU4pGo791LfTUzK8uXHG4Bv2RCgS+awKohs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TqxWhrZV660EpPNliTqKJE+ASsn/C92C7suDcXg4l3yuwfxYGVW0Jn1/ZsnmWxr1k
	 z4pFLPE4jWXTEKuKfXTqKKcBBnbgc0U1PRVBhzkLiy08C17R9DBch7mDc4kat0HODY
	 PVUiwGLCOmAAuRsQfIc9KGVat9BkFUIavut4nXXYSA08cVDfTaKeHvSyPtmiOfPE0x
	 huDm383JTG7RWB1T+Vkm/V9hMppMYNVGrCHqvgflDYL5pahxNgkVc50gzoCz0/oPu8
	 Cw8RSeO3me4sMsydcFQnETvRwkO1gJAsKzwwZXh91MfThPuanXFcwWxJcfoP/EkI5O
	 dff6Tp/hRg/7Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org
Subject: [PATCH net-next v1 4/6] selftests: rds: Fix gcov and pcap collection
Date: Mon, 27 Apr 2026 16:29:25 -0700
Message-Id: <20260427232927.2712755-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260427232927.2712755-1-achender@kernel.org>
References: <20260427232927.2712755-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vng guest shares the host filesystem via 9p and runs a minimal
systemd inherited from the host's /lib/systemd/system/. As a result,
which filesystems get auto-mounted in the guest depends on the host OS
and its systemd version.

The tcpdump pcaps are initially saved to /tmp because 9p does not support
chown which tcpdump requires. But whether /tmp is already a tmpfs depends
on the host's systemd configuration and may still sometimes fail if /tmp
is not mounted by default. Fix this by mounting tmpfs on /tmp in run.sh
when it is not already a separately mounted filesystem.

A similar dependency exists for gcov. debugfs is not mounted automatically
in vng guest, so the gcov data copy from /sys/kernel/debug/gcov/
silently finds nothing depending on whether debugfs is mounted by default
on the host OS. Fix this by mounting debugfs in run.sh before copying the
gcda files.

Finally, when invoked through the kselftest runner, the working directory
is the test directory rather than the kernel source root. gcovr defaults
--root to the current working directory, causing it to filter out all
coverage data for files under net/rds/ since they are not under the test
directory. Fix this by passing --root to gcovr explicitly.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/run.sh | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
index bc2e53126aab..3fc116d23410 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/run.sh
@@ -197,6 +197,13 @@ COVR_DIR="${LOG_DIR}/coverage/"
 mkdir -p  "$LOG_DIR"
 mkdir -p "$COVR_DIR"
 
+# tcpdump saves pcaps to /tmp because it requires chown to save the
+# pcap but chown is not supported by 9p.  Mount tmpfs on /tmp if it is
+# not already a separate filesystem
+if ! mountpoint -q /tmp 2>/dev/null; then
+	mount -t tmpfs tmpfs /tmp
+fi
+
 set +e
 echo running RDS tests...
 echo Traces will be logged to "$TRACE_FILE"
@@ -210,6 +217,12 @@ dmesg > "${LOG_DIR}/dmesg.out"
 
 if [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
        echo saving coverage data...
+
+       # Ensure debugfs is mounted
+       if ! test -d /sys/kernel/debug/gcov; then
+               mount -t debugfs debugfs /sys/kernel/debug 2>/dev/null || true
+       fi
+
        (set +x; cd /sys/kernel/debug/gcov; find ./* -name '*.gcda' | \
        while read -r f
        do
@@ -218,7 +231,7 @@ if [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
 
        echo running gcovr...
        gcovr -s --html-details --gcov-executable "$GCOV_CMD" --gcov-ignore-parse-errors \
-             -o "${COVR_DIR}/gcovr" "${ksrc_dir}/net/rds/"
+             --root "${ksrc_dir}" -o "${COVR_DIR}/gcovr" "${ksrc_dir}/net/rds/"
 else
        echo "Coverage report will be skipped"
 fi
-- 
2.25.1

