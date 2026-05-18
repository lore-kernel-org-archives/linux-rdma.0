Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418EB2673AA;
	Mon, 18 May 2026 01:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067489; cv=none; b=tet6vXqdMHd2kr2oP9pIYW6MaX0Ab/zYGZ7lHTmo5dTXCMR9MuBWeYTqK6H8oJ2ptK3SoEEfzmaCo/xFwWOGkj7sblFpTJ+52ht87isZ7VLB1dDCoJX4O146nDchzIoGptwbN+pT1xD29JulJoN3Wt8usuPi+rKX08/s/xZcOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067489; c=relaxed/simple;
	bh=s22WkY+7BUp/NmRxcL800S54LC51fzYCTT4Jj0IeFkY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eTxuSkpJOW7rLL9OwGDBCa2kVyPWsutxg9phO6/zB2lmdyX6NfsbPaZTdkAOIZkG7t9bqbcebGub95gli/+kPeJR+wFQLoUob/CKEQsJ3VpvVDfBq93GQAEd6u7XjWyfuSKQi23QFH1MxUOue2rCgo2R+nnBUu5jB+A+A1DqRNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lb+Q1RuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lb+Q1RuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9CBC2BCB0;
	Mon, 18 May 2026 01:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779067489;
	bh=s22WkY+7BUp/NmRxcL800S54LC51fzYCTT4Jj0IeFkY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lb+Q1RuCkNmm9HlA4uzV8/ZQw92RfZ3p4MvIrQK/zPpheRUmjrIvAUmtFpelS2sBA
	 dTgRjBYFJRvMYsukppXrA0yJBsjS+GTi5ciG2U4chx771zibtAorpdyDNKuavY+M+Q
	 QYVU4rXMFLE+w1TI+UHoFtbR1e21h8iLJMV1kDN7vGdpnO63obotBQmS4an/fqVcuW
	 sZXB4elo9nVhyB5bWVd0qB/9Mv4Yh0raPXnHqKP6DE7Z+bY3C3rUT0s2/Q9NBEY61P
	 1wCXsjuI8fyDU2NsAqA4jii/r8KSp6eBfZZ74Mq9ODWn/BaSrDZMcPYYeij1x6fq54
	 5OQSm1ckanQlQ==
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
Subject: [PATCH net-next v3 06/11] selftests: rds: Add helper function verify_hashes() in test.py
Date: Sun, 17 May 2026 18:24:38 -0700
Message-Id: <20260518012443.2629206-7-achender@kernel.org>
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

Hoist the verify hashes logic in test.py into a helper function,
verify_hashes().  This is a preparatory refactoring for the rds over
ROCE series that helps modularize the send/recv logic. Breaking up the
logic now will help avoid large function pylint errors later.  No
functional changes are introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 33 ++++++++++++-------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index ae74117b41747..a3def413d84ad 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -152,6 +152,21 @@ def check_info(socks):
 
     ksft_pr(f"getsockopt(): {nr_success}/{nr_error}")
 
+def verify_hashes(snd_hashes, rcv_hashes):
+    """Compare send/recv hashes per (sender, receiver) pair."""
+    for key, snd_hash in snd_hashes.items():
+        rcv_hash = rcv_hashes.get(key)
+        if rcv_hash is None:
+            ksft_pr("FAIL: No data received")
+            return 1
+        if snd_hash.hexdigest() != rcv_hash.hexdigest():
+            ksft_pr("FAIL: Send/recv mismatch")
+            ksft_pr("hash expected:", snd_hash.hexdigest())
+            ksft_pr("hash received:", rcv_hash.hexdigest())
+            return 1
+        ksft_pr(f"{key[0]}/{key[1]}: ok")
+    return 0
+
 def stop_pcaps():
     """Stop tcpdump processes.
 
@@ -310,23 +325,7 @@ stop_pcaps()
 
 # We're done sending and receiving stuff, now let's check if what
 # we received is what we sent.
-ret = 0
-for (sender, receiver), send_hash in send_hashes.items():
-    recv_hash = recv_hashes.get((sender, receiver))
-
-    if recv_hash is None:
-        ksft_pr("FAIL: No data received")
-        ret = 1
-        break
-
-    if send_hash.hexdigest() != recv_hash.hexdigest():
-        ksft_pr("FAIL: Send/recv mismatch")
-        ksft_pr("hash expected:", send_hash.hexdigest())
-        ksft_pr("hash received:", recv_hash.hexdigest())
-        ret = 1
-        break
-
-    ksft_pr(f"{sender}/{receiver}: ok")
+ret = verify_hashes(send_hashes, recv_hashes)
 
 if ret == 0:
     ksft_pr("Success")
-- 
2.25.1

