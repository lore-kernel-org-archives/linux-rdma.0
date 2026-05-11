Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EA037E30C;
	Mon, 11 May 2026 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484200; cv=none; b=oAfOgby8qwi/GAMEvGe+q+HjKJna+s1xxmtfI0bilvMy/aF0s+WgUDMNyuP/fjOrtUyFqRrp86qVCY/oOHZahG+bZzt+FJWecOTCvAIdh6iIXbz9RMp9mNO4UgIQMKd/7uoV8YUCHI0DphcivMkQEGR0hmiq+uQVJWjO3rbKQIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484200; c=relaxed/simple;
	bh=KG6pW0j2q9TtLN/BqYsg6Ko8fpp8rjoXBp5PMI2CHC0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nC0fssKSNAIKpYxSRCM+pzRgsgA5EZMOkzk9uGFRuVc3DGgKQFFdLEL0uJBZHLHeTNtmFCF0YXJ6hAKzKZx8yM3dhSvk+ARFzhyIMLLFxZgx+VJFHcj6Q35D/GKdqA0Y7YkIfRWScKI5IIAhhjc2RZzieOOpVi+oukrkvflMM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WD8abpuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WD8abpuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A407C2BCB0;
	Mon, 11 May 2026 07:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778484199;
	bh=KG6pW0j2q9TtLN/BqYsg6Ko8fpp8rjoXBp5PMI2CHC0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WD8abpuIQpSehG5qQ5sGU07TfbzEugxT3YfGiQUL/y7b30fUKh5WNNjgapBcMzNFL
	 y2r9172IOrdS9D+yiq+PYcjn/8tbWDNXJYNqM73LtbHNTyYpA3FGZGGnmvNuQKwFwb
	 f6gpFluuTOUHqngEwZXuRkDRpZllz1+3gV7Qtc9UCmo4eIhV0grT6Q4tXXOY0fEy3w
	 z+Ge4/5DpNXjZj5PhjViuqJT7ZAiFnBYV/8HUGWJ966KWD28Mm+D5iCb+weHFtQc6w
	 nggDuC1ffpd4PyBw5pOuOn+LuRd0kLMM0wHStWlHi1e5FwQBQwy9Z1HvpQbny9BoYc
	 kSCFNPAB1YG6g==
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
Subject: [PATCH net-next v1 3/9] selftests: rds: Add helper function check_info() in test.py
Date: Mon, 11 May 2026 00:23:10 -0700
Message-Id: <20260511072316.1174045-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260511072316.1174045-1-achender@kernel.org>
References: <20260511072316.1174045-1-achender@kernel.org>
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
index 027131b26287..5d4b039580df 100755
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

