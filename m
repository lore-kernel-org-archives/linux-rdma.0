Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F4A3469E7;
	Thu,  7 May 2026 23:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778196735; cv=none; b=SBrNTyRLmpGK+8x6k7SMDw32osTNSR+sO20iLe5Ov9wpnK6i5Dnwik4r8cCtzwXllqbZoJz7/MoFVo6+1oUOQQlrJ8qM0zxqbJbjvPm6MczPT/5xasNRv+kQtKeeg4JE5oBOhDnCdDFQqWGrIJqd0+iN1SmVxHbfdU5xPkPLURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778196735; c=relaxed/simple;
	bh=rfbJDPvnydUiOQ/d5Z2qJ2YT3Vgs6mWHM+6Mu4Q/OzE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJw2hwmBGlkopw2smklDFKNfd/PQpAyizH8XGPx7VCKiQdvNYnsVtKBkOHStsLlqL285ICIk7+s1rxu9t7JYL39xRKoKhv/vzuimdhiL1OKyQXxK2Ws1uI/yFJhq7WaBf8AHt7RyJK663eLDVKFzuTiBfXxreNM7ijv4OrM2xFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpcMw50M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpcMw50M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF44CC2BCF5;
	Thu,  7 May 2026 23:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778196735;
	bh=rfbJDPvnydUiOQ/d5Z2qJ2YT3Vgs6mWHM+6Mu4Q/OzE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IpcMw50MfZhMsHSk4MV2zLpX9CfeaQGHl7CuZQoV47lijTioMWmGf0hH1aAN6xZZo
	 j5dnbVtmGiMufVlmnQJ/7FxiLPoKmHOfU0GaiNOdwX2ZcDG2G950VJp8UWk7VgTj1O
	 eMF/NvGTCx342h+vaGEDDyeDPkrzK9aY1vk1j/tVxUJ5009kd06tb2v/4UPdQVb3jd
	 nMYC6OpYrZ5oI4xQ10qDnbHq69EzIYsgWBiskEzNd8bTOfPdHU0Q99TmvV2Z/LrZN0
	 28z0R9MYXDrdQYRsDf8NOx3Q0j07RdyMTLNItwDlIu2lLRD3/QB/flxS88DyrMsSYd
	 Zk0xZ9W0myaUw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH net-next v1 1/3] selftests: rds: Fix stale log clean up
Date: Thu,  7 May 2026 16:32:11 -0700
Message-Id: <20260507233213.556182-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260507233213.556182-1-achender@kernel.org>
References: <20260507233213.556182-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since rds self tests no longer has a default folder, users must
specify a log collection folder if they want to collect logs.
Currently the log folder is deleted and recreated, but this can
be dangerous if the user exports RDS_LOG_DIR=/tmp or /var/log.
This patch corrects the clean up to delete only rds log artifacts
from the log folder, and further prefixes rds specific logs as rds*

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/run.sh  | 10 +++++++---
 tools/testing/selftests/net/rds/test.py |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
index 2404a889767a..4930aed8846b 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/run.sh
@@ -189,17 +189,21 @@ check_gcov_conf
 
 TRACE_CMD=()
 if [[ -n "$LOG_DIR" ]]; then
-   rm -fr "$LOG_DIR"
    FLAGS+=("-d" "$LOG_DIR")
 
    TRACE_FILE="${LOG_DIR}/rds-strace.txt"
    COVR_DIR="${LOG_DIR}/coverage/"
+   DMESG_FILE="${LOG_DIR}/rds-dmesg.out"
+
    mkdir -p  "$LOG_DIR"
    mkdir -p "$COVR_DIR"
 
-   echo "#Traces will be logged to ${TRACE_FILE}"
    rm -f "$TRACE_FILE"
+   rm -f "$DMESG_FILE"
+   rm -f "$LOG_DIR"/rds-*.pcap
+   rm -f "$COVR_DIR"/gcovr*
 
+   echo "# Traces will be logged to ${TRACE_FILE}"
    TRACE_CMD=(strace -T -tt -o "${TRACE_FILE}")
 fi
 
@@ -210,7 +214,7 @@ echo "#running RDS tests..."
 test_rc=$?
 
 if [[ -n "$LOG_DIR" ]]; then
-   dmesg > "${LOG_DIR}/dmesg.out"
+   dmesg > "${DMESG_FILE}"
 fi
 
 if [[ -n "$LOG_DIR" ]] && [ "$GENERATE_GCOV_REPORT" -eq 1 ]; then
diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index d19d30e5ec6f..e1813e43fb4e 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -151,7 +151,7 @@ tcpdump_procs = []
 # Start a packet capture on each network
 if logdir is not None:
     for net in [NET0, NET1]:
-        pcap = logdir+'/'+net+'.pcap'
+        pcap = logdir+'/rds-'+net+'.pcap'
 
         tcpdump_cmd = ['ip', 'netns', 'exec', net, '/usr/sbin/tcpdump']
         sudo_user = os.environ.get('SUDO_USER')
-- 
2.25.1

