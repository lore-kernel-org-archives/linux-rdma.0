Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D25D3B531D;
	Mon, 27 Apr 2026 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777332571; cv=none; b=QZ8TlqHAXlt6YZ5wBLDXKTou1r5V/pOg7hadyrvQVmhtLcHkeETXib9eIPGEYRhe1Cfk9c8o8kxeYg5Tvt2G6sqyEkcMBkpPz591yd55CPY5SgGQ8r7xQgiKWfCRGgFptvlO2SLrKd21iGKK3Q9sBtwXlggMypBa6odShgdoPGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777332571; c=relaxed/simple;
	bh=qj19Yu0pEN3zhyJBgl5K48l5aYQ0Ca/MRTT09l+PKsY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AobJs5BaqrKW3+ach2XYdlJ963apFexWVFKIOMyRVhUMBLyqKcA2aWGVZCuyw5sI928Ga2HYA9SOaMy2NWfRTmDIwdlX3Euo8QU/vlYISDO488kpW7jh8NkQVQmK2gbuar7pKcj23/miJsDOsM0VVDi3OEddb+h+YvZVD8HbtKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGOp15KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGOp15KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807C1C2BCB6;
	Mon, 27 Apr 2026 23:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777332571;
	bh=qj19Yu0pEN3zhyJBgl5K48l5aYQ0Ca/MRTT09l+PKsY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OGOp15KE4NVJ3QmDSsiv8Wc0QBUfsOJL643PqByK+jdfvXB9LBL0XcILv6RTOf+rk
	 W0iBdE/F1Jt6BcW3neokZ5BrD8wjXtf3kIKeakdKyCPF97MH5YcRhiWwHKhhvJE9B/
	 ER/AbspCePuaoPKUQmAyKm+gOMS2TvPDfpDvtuzZEOd2lQE5nTA3uLT8dPrh0Y39TX
	 z5sFgwOaxK8lcbFEa5lx83RnRbbeN5zu/xK6V5z9lmfpsJDgJNLR329rACAKs4sNZd
	 dKot1StDOl1eHtyNSzrcu37IjsdyQNw2alcuFZOuJndDOczd5NOSKcAs5+4s8i45yk
	 GKmWxyX5C3J3g==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org
Subject: [PATCH net-next v1 3/6] selftests: rds: Add timeout flag to run.sh
Date: Mon, 27 Apr 2026 16:29:24 -0700
Message-Id: <20260427232927.2712755-4-achender@kernel.org>
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

Add a -t flag to run.sh to optionally override the default
timeout.  The --timeout flag is already supported in test.py,
so just add the shorthand -t flag

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/run.sh  | 11 ++++++++---
 tools/testing/selftests/net/rds/test.py |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/run.sh
index 73a9b986b0ef..bc2e53126aab 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/run.sh
@@ -154,8 +154,9 @@ LOG_DIR="$current_dir"/rds_logs
 PLOSS=0
 PCORRUPT=0
 PDUP=0
+TIMEOUT=$timeout
 GENERATE_GCOV_REPORT=1
-while getopts "d:l:c:u:" opt; do
+while getopts "d:l:c:u:t:" opt; do
   case ${opt} in
     d)
       LOG_DIR=${OPTARG}
@@ -166,12 +167,15 @@ while getopts "d:l:c:u:" opt; do
     c)
       PCORRUPT=${OPTARG}
       ;;
+    t)
+      TIMEOUT=${OPTARG}
+      ;;
     u)
       PDUP=${OPTARG}
       ;;
     :)
       echo "USAGE: run.sh [-d logdir] [-l packet_loss] [-c packet_corruption]" \
-           "[-u packet_duplicate]"
+           "[-u packet_duplicate] [-t timeout]"
       exit 1
       ;;
     ?)
@@ -198,7 +202,8 @@ echo running RDS tests...
 echo Traces will be logged to "$TRACE_FILE"
 rm -f "$TRACE_FILE"
 strace -T -tt -o "$TRACE_FILE" python3 "$(dirname "$0")/test.py" \
-	--timeout "$timeout" -d "$LOG_DIR" -l "$PLOSS" -c "$PCORRUPT" -u "$PDUP"
+	-t "$TIMEOUT" -d "$LOG_DIR" -l "$PLOSS" -c "$PCORRUPT" \
+	-u "$PDUP"
 
 test_rc=$?
 dmesg > "${LOG_DIR}/dmesg.out"
diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 93e23e8b256c..90f9adad18b3 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -79,7 +79,7 @@ parser = argparse.ArgumentParser(description="init script args",
                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
 parser.add_argument("-d", "--logdir", action="store",
                     help="directory to store logs", default="/tmp")
-parser.add_argument('--timeout', help="timeout to terminate hung test",
+parser.add_argument('-t', '--timeout', help="timeout to terminate hung test",
                     type=int, default=0)
 parser.add_argument('-l', '--loss', help="Simulate tcp packet loss",
                     type=int, default=0)
-- 
2.25.1

