Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB442877F7;
	Tue,  2 Jun 2026 05:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376821; cv=none; b=JgLMUcVUZVF+COVFKshp8Wv719Y/IddGQ6b/yOyoGVGBjaqUMWOsV+gksIHiYRYVyxWxmJOdgV1IpmMzeOw3rhE/UlqeoPa3roUb28x5v+Q/jQR4TapAgTKUMAVuZLUCEhmtj1bZAg6fEwRDZSFO7KMqcnPZ2emZNvmVuBvyS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376821; c=relaxed/simple;
	bh=6Y0ISuxZgz/P3ld5rbFvop5CRCFHLlT0T5DbHrF2OXg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ctf9lsexeUpNDeIDfzaeuGfZP8vuYLTX7Sf+1KW62B9X7ItpN9G2tcnDj8b08eQCHM2eS+VjlFBreBWH20BDRHYa99guumIoeH5jOzZZOzEP8b5CaL50bAX7ZF6R8kkjhcgxbM5Mz2B21GBss80+SGYQYsBz4GAAqvf2KM/HJBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/+cLge3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/+cLge3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F121F00898;
	Tue,  2 Jun 2026 05:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376820;
	bh=33Q+0nVF0ARpJV3lvmXHvrP9ISNqoJj90QlqqmgjQNA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=h/+cLge3Zz/RrdVfL/WzghZR0QhNnKROuYyc5pXxDfpmaDO+3KM6m2aMxMwojGrcF
	 qI+N7fmAHxvEuYeupf6hjPMtNU3BwxK+2FXewEWvEZBOpz07mVoUpogzY8d2XwekH8
	 wnrV90j2glbHNKPGP+MYQ7FwcpBKWv0sDYktp5Aa3P1EQx1V07WUVAGwSSjt4z7IXB
	 PI268bT+izU+kXJJQ6oua8mjPtx2/VnIBdBtFt3CnHdWCzllmIguuQCLjMtfVUUNlZ
	 AroILPmctHEbMuJX9rbdnDb50CkiNs0VUhrtJoL3l08RMNZwsYvPr6zizeLjeFLbhH
	 XZoT/BIL5s8hA==
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
Subject: [PATCH net-next v3 2/4] selftests: rds: pin RDS sockets to their intended transport
Date: Mon,  1 Jun 2026 22:06:55 -0700
Message-Id: <20260602050657.26389-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260602050657.26389-1-achender@kernel.org>
References: <20260602050657.26389-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RDS selftests create AF_RDS sockets but never selects a transport,
so the transport is chosen implicitly based on network topology when
the socket is bound.  If underlying connection establishment fails, RDS
can fall back to another transport (e.g. loopback) and the test still
passes, silently bypassing the intended datapath it is meant to
exercise.

Set SO_RDS_TRANSPORT to the proper RDS_TRANS_IB or RDS_TRANS_TCP before
they are bound, so the test fails loudly if the intended transport is
unavailable rather than passing on a different path.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 08f2a846a8ab5..9e4df01cb0d4b 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -59,6 +59,14 @@ rdma_addrs = [
 OP_FLAG_TCP     = 0x1
 OP_FLAG_RDMA    = 0x2
 
+# from include/uapi/linux/rds.h: SO_RDS_TRANSPORT pins a socket to a
+# specific RDS transport so connection setup cannot silently fall back
+# to another (e.g. loopback) transport.
+SOL_RDS          = 276
+SO_RDS_TRANSPORT = 8
+RDS_TRANS_TCP    = 2
+RDS_TRANS_IB     = 0
+
 signal_handler_label = ""
 
 tap_idx = 0
@@ -214,11 +222,21 @@ def snd_rcv_packets(env):
             netns_socket(netns_list[0], socket.AF_RDS, socket.SOCK_SEQPACKET),
             netns_socket(netns_list[1], socket.AF_RDS, socket.SOCK_SEQPACKET),
         ]
+
+        # Pin the sockets to the TCP transport so it doesn't fail over to a
+        # different transport during this test
+        for s in sockets:
+            s.setsockopt(SOL_RDS, SO_RDS_TRANSPORT, RDS_TRANS_TCP)
     elif flags & OP_FLAG_RDMA:
         sockets = [
             socket.socket(socket.AF_RDS, socket.SOCK_SEQPACKET),
             socket.socket(socket.AF_RDS, socket.SOCK_SEQPACKET),
         ]
+
+        # Pin the sockets to the RDMA transport so it doesn't fail over to a
+        # different transport during this test
+        for s in sockets:
+            s.setsockopt(SOL_RDS, SO_RDS_TRANSPORT, RDS_TRANS_IB)
     else:
         raise RuntimeError(f"Invalid transport flag sets no transports: {flags}")
 
-- 
2.25.1

