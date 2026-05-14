Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB15B3B0ACE;
	Thu, 14 May 2026 04:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778733213; cv=none; b=joMSW9aMZnFiQ9XQ3c568zR/66nkotYBEnzCHS7pjNrNb4HNeGjOw9r/CRCEVnqPqhoJcceE6bw4GmqNzq9exiVmVUQqeiVS2Vw471LZpP24YaggOhXGzSkHLTjiCoTHzuZgqGThg7YTa9IjlimzrD0t76L2VYRqGoKtBPywmkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778733213; c=relaxed/simple;
	bh=ajpIF1x+m5CpWidzQlnuc1CWrR/Y+p4/Wb13mjIoJ90=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=soChA7Pt2PnTowlVj1XuCID5vpyzvOCEhus3qfuVEMFrsYO+VzuAEIHmO/uE4HpKCgS1cmvlNLj6Ko6BkhsCwu1LOtoxBcVTiD7x2KN6lqZEwkNhp4yssHq+9pdxkh3LYxDwVGq20+vnR4Q1zb/Qzf75wWqeuO7OfhWjk9hLGNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGrKp+Eg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGrKp+Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F61BC2BCB7;
	Thu, 14 May 2026 04:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778733213;
	bh=ajpIF1x+m5CpWidzQlnuc1CWrR/Y+p4/Wb13mjIoJ90=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fGrKp+EgkqmulxlGsroXXRP+PoZ6gvVy5NncukSPhY3hSpeTRfNCCP+ZIwPNn/177
	 hEF8FguMoawUxv8AJ0kSqMyOjzo/08PRP2piYi7xZTwvYAJmZCLdgu1LS/6UeiGV09
	 cryCwrgwm18ioshfDMeQCEOajLpwjOlCaXdPCJcNh70Rz4nq6L2OWP3Cp8pxC5iK13
	 TLo7WN3W7wBrUG3kHGRxDiAyNxK5wYtjjXwVXNyYASamQIIQ2X3PQ9h+/52rB33vXQ
	 CqawS177Fk2g7o2ECsnidX4KSC2Ig/gdaZmMy53RLaGL5HfCX+yIP5t7WR9G2aP2bM
	 0ugj4ymTWoWHQ==
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
Subject: [PATCH net-next v2 2/9] selftests: rds: Add helper function check_info() in test.py
Date: Wed, 13 May 2026 21:33:23 -0700
Message-Id: <20260514043330.1718969-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260514043330.1718969-1-achender@kernel.org>
References: <20260514043330.1718969-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hoist the page info logic in test.py into a helper function,
check_info().  This is a preparatory refactoring for the rds over ROCE
series that helps modularize the send/recv logic. Breaking up the logic
now will help avoid large function pylint errors later.  No functional
changes are introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 53 +++++++++++++++----------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 118a5da83c98..d64af9e662e8 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -79,6 +79,36 @@ def netns_socket(netns, *sock_args):
     u1.close()
     return socket.fromfd(fds[0], *sock_args)
 
+def check_info(socks):
+    """
+    Check all rds info pages for errors
+
+    :param socks: list of sockets to check
+    """
+
+    # the Python socket module doesn't know these
+    rds_info_first = 10000
+    rds_info_last = 10017
+
+    nr_success = 0
+    nr_error = 0
+
+    for sock in socks:
+        for optname in range(rds_info_first, rds_info_last + 1):
+            # Sigh, the Python socket module doesn't allow us to pass
+            # buffer lengths greater than 1024 for some reason. RDS
+            # wants multiple pages.
+            try:
+                sock.getsockopt(socket.SOL_RDS, optname, 1024)
+                nr_success = nr_success + 1
+            except OSError as e:
+                nr_error = nr_error + 1
+                if e.errno == errno.ENOSPC:
+                    # ignore
+                    pass
+
+    ksft_pr(f"getsockopt(): {nr_success}/{nr_error}")
+
 def stop_pcaps():
     """Stop tcpdump processes.
 
@@ -268,28 +298,7 @@ while nr_send < NUM_PACKETS:
 
 ksft_pr("done", nr_send, nr_recv)
 
-# the Python socket module doesn't know these
-RDS_INFO_FIRST = 10000
-RDS_INFO_LAST = 10017
-
-nr_success = 0
-nr_error = 0
-
-for s in sockets:
-    for optname in range(RDS_INFO_FIRST, RDS_INFO_LAST + 1):
-        # Sigh, the Python socket module doesn't allow us to pass
-        # buffer lengths greater than 1024 for some reason. RDS
-        # wants multiple pages.
-        try:
-            s.getsockopt(socket.SOL_RDS, optname, 1024)
-            nr_success = nr_success + 1
-        except OSError as e:
-            nr_error = nr_error + 1
-            if e.errno == errno.ENOSPC:
-                # ignore
-                pass
-
-ksft_pr(f"getsockopt(): {nr_success}/{nr_error}")
+check_info(sockets)
 
 # cancel timeout
 signal.alarm(0)
-- 
2.25.1

