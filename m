Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59B62FF657;
	Wed, 27 May 2026 02:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779849267; cv=none; b=Le+va76UUmhyHfP717Uwm1pcbne0cw7USvxa8iSm/pfRJPanIcUHs9eOckSn27cdh6TOVNblD4+5wBW3LYy94MaQkY9yPe2kFd2xpcQCxmSytx5uata55TrpOCgLYhzZen3Kq7O2F/I0H3I5RDF5AApSeU7BVdUEzClsPsrcBkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779849267; c=relaxed/simple;
	bh=A353jG6v4Xf+ficc2QHwROMy6RZ991EqlHbddOLJAPk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IgJN09CCUeLv84/s36/AFhLStAn2n2/BWV0LuSowtkE9aUH51aVOUfo9hpwAX6V8x4LMtyMnoQ5WXv0Ylbmg8L6iVYvTUF/m/pkgeQzPCYf/VkCX7Lzsi2MZobZzYFBwL1umhBZRp4qLVjOMeekOjoFlZb4v25VXMnm1rJQvVQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZe7es6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZe7es6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26621F00A3C;
	Wed, 27 May 2026 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779849265;
	bh=rvUiGXIlZLfkWLEsCqFZPSmPSyXchjjcFfHX3Gx5JwI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gZe7es6pSbYpVPNago6F35ulfTHmox/Lah8gMiLxwwycsO4Ps1YhIxlRcL1xfA43L
	 7ATDU4F/bVsgrm/3Kmrf92b2+yXwuBFutbBEFrjtLzfte7Hf+lNHAz1h43CqGL632F
	 tLI6pjuRuTzKXVCmZUvpHtXiNv4m+XY6CNIpgscNSrIamdGKuHJXy5yfjxzoYRYgzl
	 4DN+GVFu3jSCkS7LJVz4l5D7d9T0rPVvIcC0DPug3P7PkbJCAp5/1JRJHoBkoNsNn/
	 m+60xElBplhYQcKlUC6iP7HVTm3wOFSsbEIQx+QgQY1K10LR2pwX9ASer8ojnjKa5V
	 9yFSEZo+NzTuA==
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
Subject: [PATCH net-next v2 1/4] selftests: rds: Rename run.sh to rds_run.sh
Date: Tue, 26 May 2026 19:34:20 -0700
Message-Id: <20260527023423.387792-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260527023423.387792-1-achender@kernel.org>
References: <20260527023423.387792-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch renames run.sh to rds_run.sh. This gives the test a
self-describing name that appears in the netdev CI dashboard.

Suggested-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/Makefile               | 2 +-
 tools/testing/selftests/net/rds/README.txt             | 8 ++++----
 tools/testing/selftests/net/rds/{run.sh => rds_run.sh} | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/rds/Makefile b/tools/testing/selftests/net/rds/Makefile
index fe363be8e3586..ec10ae24e4cf1 100644
--- a/tools/testing/selftests/net/rds/Makefile
+++ b/tools/testing/selftests/net/rds/Makefile
@@ -3,7 +3,7 @@
 all:
 	@echo mk_build_dir="$(shell pwd)" > include.sh
 
-TEST_PROGS := run.sh
+TEST_PROGS := rds_run.sh
 
 TEST_FILES := \
 	include.sh \
diff --git a/tools/testing/selftests/net/rds/README.txt b/tools/testing/selftests/net/rds/README.txt
index bac6f15a80d52..8aa41148b1b5c 100644
--- a/tools/testing/selftests/net/rds/README.txt
+++ b/tools/testing/selftests/net/rds/README.txt
@@ -14,9 +14,9 @@ configs required for the RDMA transport.  The kernel may optionally be
 configured to omit the coverage report as well.
 
 USAGE:
-	run.sh [-d logdir] [-l packet_loss] [-c packet_corruption]
-	       [-u packet_duplicate] [-t timeout]
-	       [-T tcp|rdma|tcp,rdma]
+	rds_run.sh [-d logdir] [-l packet_loss] [-c packet_corruption]
+	           [-u packet_duplicate] [-t timeout]
+	           [-T tcp|rdma|tcp,rdma]
 
 OPTIONS:
 	-d	Log directory.  If set, logs will be stored in the
@@ -73,5 +73,5 @@ EXAMPLE:
         "export PYTHONPATH=tools/testing/selftests/net/; \
          export SUDO_USER=example_user; \
          export RDS_LOG_DIR=tools/testing/selftests/net/rds/rds_logs; \
-         tools/testing/selftests/net/rds/run.sh -T tcp,rdma"
+         tools/testing/selftests/net/rds/rds_run.sh -T tcp,rdma"
 
diff --git a/tools/testing/selftests/net/rds/run.sh b/tools/testing/selftests/net/rds/rds_run.sh
similarity index 98%
rename from tools/testing/selftests/net/rds/run.sh
rename to tools/testing/selftests/net/rds/rds_run.sh
index 07af2f927a2a7..ef16039be1ae5 100755
--- a/tools/testing/selftests/net/rds/run.sh
+++ b/tools/testing/selftests/net/rds/rds_run.sh
@@ -209,7 +209,7 @@ while getopts "d:l:c:u:t:T:" opt; do
       TRANSPORT=${OPTARG}
       ;;
     :)
-      echo "USAGE: run.sh [-d logdir] [-l packet_loss] [-c packet_corruption]" \
+      echo "USAGE: rds_run.sh [-d logdir] [-l packet_loss] [-c packet_corruption]" \
            "[-u packet_duplicate] [-t timeout] [-T tcp|rdma|tcp,rdma]"
       exit 1
       ;;
@@ -224,7 +224,7 @@ done
 IFS=',' read -ra transports <<< "$TRANSPORT"
 for t in "${transports[@]}"; do
     if [ "$t" != "tcp" ] && [ "$t" != "rdma" ]; then
-        echo "run.sh: unknown transport '$t' (expected tcp or rdma)"
+        echo "rds_run.sh: unknown transport '$t' (expected tcp or rdma)"
         exit 1
     fi
 done
-- 
2.25.1

