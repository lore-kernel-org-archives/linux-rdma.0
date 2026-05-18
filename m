Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCD11FECAB;
	Mon, 18 May 2026 01:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067487; cv=none; b=LzP9mxFKfpPGgu2FqvT+Pj8ilJnkvTbZZFHQuZJ1iudcObyQwBzolHWh5SSdEZkigfBlIAEnscYjhH1rMIM6cYzVtXFoiguQjtjWX/qSTvmf5jF9NSrdk4CcAT/NB8jkY0lvMMCOnSXCrqv/taCQz6uSInfJVB8a8OU8AmD9m98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067487; c=relaxed/simple;
	bh=tiaNCC2ZPZbHtuseGwHRt3jO0+j10LMHqeNdoW6wzQk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BQnyvi8M2uVzmQvPT6WFKApTqDy6be9jwHTKolDoHy0zC/b8K584nWlDMfn6dTSVQrCAQ1QfXFCUtCoq2bajb2ZVZXEHSAZDZ88GErQ+1xoSDShWWSJnVEWO9/aaPE60X0oyoZMHhBiHXzoglUUMInGdJnvpTUpffgVYPj1bdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFRg4HHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFRg4HHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C917C2BCF5;
	Mon, 18 May 2026 01:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779067487;
	bh=tiaNCC2ZPZbHtuseGwHRt3jO0+j10LMHqeNdoW6wzQk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uFRg4HHUP0L3eZZ4hHw0H6iHMbPUqnWoL6eYPVgVrPd2+AnPVPVugwIQixhJ8WFj1
	 tcEXvgkHisMokOnSytb41Yvtfqw9JkIsAMFqwlLXLnJiFidrzX70OkqITDzshqA96H
	 yeeSSMDKs+6mVF/yTBaOUguyakC2iQFZfA+nAgeDwRM6iiFxQlC9Nme6OP9iuOXcFC
	 yPFBM5YiJIO10sRHHYhPucF1fbshWTB7ubwitooKuRmbRTZlFN+f0nHE86f/71j2bO
	 81kFJiGrBO6EsOSMiBs+JsDyIMjn+jzgJH4aiXUittOXJFhHebn0RaTfAmxPWd/7/k
	 O8QVModSwLNpA==
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
Subject: [PATCH net-next v3 03/11] selftests: rds: Add helper function check_info() in test.py
Date: Sun, 17 May 2026 18:24:35 -0700
Message-Id: <20260518012443.2629206-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260518012443.2629206-1-achender@kernel.org>
References: <20260518012443.2629206-1-achender@kernel.org>
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
index 118a5da83c98e..d64af9e662e8c 100755
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

