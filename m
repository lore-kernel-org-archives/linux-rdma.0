Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E413B4EB0;
	Mon, 27 Apr 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777332572; cv=none; b=TWOKAm3JzvqdWlE8/rAa/Q67GE+3RQE3Ib9Qgr2iTmovYkIAOM/Ity6ZDFJ8HsjOJS64PNs9PLEK39UUukWKn/qLFfBkO3xsoMtjNRd0I1xHnHCwHdvkbBXd+VrJuBCcrBmzdfp8jAR5EpiPPxoPYisalWcOvFzb7fmdVC0z2gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777332572; c=relaxed/simple;
	bh=aT3wh2p3LdeaKD14G7HhELAKzRc4rEQVzVrqO1AXWqs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SPN5dg7R1jQAqMROsgeWH/0GAqCBlsylXMaxFkdxbXYArwva4ijnGDtyWWIQ+mia4bMUglvZFE8jM5wjmmieDnJxjWgKWgOULPn6VnIh3WAKnLbZY7hztLsrDCnmFPESYP9WjrHsGn6+bzAaM0lVJRaMG4sgjxus9qm/6Xn+lOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G58UwvGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G58UwvGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA429C2BCB6;
	Mon, 27 Apr 2026 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777332572;
	bh=aT3wh2p3LdeaKD14G7HhELAKzRc4rEQVzVrqO1AXWqs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=G58UwvGRoEU2ja/JxTaBh3mkL6h9uzHMeQmT51gHMI6Qd9i16Do6T0L+9dGcdKaiN
	 sUQYk20yPFavzn2jXEBUZQvZIkjOMUGmprF3Qt4xRG4bemWwb5fbS1LoU3ZwfH+Dtx
	 TZsWfg1omAzchJNJOc3g/gbh6GFa0Pi3zBLCALLeBfV3ac13oriTqkzEkYcbQq/pro
	 t4GqIRpjm8BqxpHcETH9U8/ss1mmfbJUBJWcsTmzXIbVeLgbW/XhJdCHpaIT4/I/Pt
	 2jj65rzH9avATRl9meKDLm4HQQF4zKL/8ublHFqsJE7/lMMu2EhfHYf+LAtikpjBZ5
	 cffTmoxc8yf3Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	achender@kernel.org
Subject: [PATCH net-next v1 5/6] selftests: rds: Collect pcaps on timeout
Date: Mon, 27 Apr 2026 16:29:26 -0700
Message-Id: <20260427232927.2712755-6-achender@kernel.org>
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

The timeout signal handler for the rds selftests currently just
exits when the time limit is exceeded, and forgets to collect the
network dumps.  Which can be valueable for discerning why the test
timed out in the first place.  Fix this by hoisting the network
dump collection into a helper function, and call it from the
signal handler before exiting

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 90f9adad18b3..6685b960d013 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -66,11 +66,20 @@ def netns_socket(netns, *sock_args):
     u1.close()
     return socket.fromfd(fds[0], *sock_args)
 
+def collect_pcaps():
+    print("Stopping network packet captures")
+    for p, pcap_tmp, pcap, fd in tcpdump_procs:
+        p.terminate()
+        p.wait()
+        os.close(fd)
+        shutil.move(pcap_tmp, pcap)
+
 def signal_handler(_sig, _frame):
     """
     Test timed out signal handler
     """
     print('Test timed out')
+    collect_pcaps()
     sys.exit(1)
 
 #Parse out command line arguments.  We take an optional
@@ -246,13 +255,7 @@ for s in sockets:
                 pass
 
 print(f"getsockopt(): {nr_success}/{nr_error}")
-
-print("Stopping network packet captures")
-for p, pcap_tmp, pcap, fd in tcpdump_procs:
-    p.terminate()
-    p.wait()
-    os.close(fd)
-    shutil.move(pcap_tmp, pcap)
+collect_pcaps()
 
 # We're done sending and receiving stuff, now let's check if what
 # we received is what we sent.
-- 
2.25.1

