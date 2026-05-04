Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B49D2BEC2E;
	Mon,  4 May 2026 05:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777873309; cv=none; b=YcvtbDmn3OBxGx1bhIBWZVXlAlqb3BPpcS4kuyB9FVkUmTD4HeRkC2vm7ZMsz2ka+65HvnIGD1f7a46JfuC/0Ipp+6XI3z6cWTv7eQK2DQVfLd/ghuFckKeonma3GMXRPUSOxn2lda1lEtCSFW87ct8c3a+7ZgmoA2SvPlR6Mls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777873309; c=relaxed/simple;
	bh=W1UZywNgm6KEaG2HHW7jk9F6SznAK7+261808x20/kk=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kYWoTjJty5TUfTyi3V7nSZxuoZyvtsG8/jppvGUX9T5PNLVT3iGv+syR7ZrgmQVonWtS9k/RxvYaxc6xzwm85DY/K1NIGMDYDgN4VUCD4DFlERa9ZA/Jdd/Nq/1wtpe2uLbeMMk0h2jdpLLwqnoyiOtvzV+fDontMhSgr2KIIqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qu4698/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qu4698/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFBBC2BCB8;
	Mon,  4 May 2026 05:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777873308;
	bh=W1UZywNgm6KEaG2HHW7jk9F6SznAK7+261808x20/kk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Qu4698/wJv54T/8KYudgPS8DTMWKTETCex5q/312Q7w9FN9fHHSEU2GLbp4EFoj6n
	 eCjfdiIMsgvckzISl8Z0QOad0GfZ8poj70LIDcUdbDMT98uQ2ucChA0S7vEx0+W+9D
	 hp4O4qnZzfp0DnHk9LwGl7DEhZ6hiJcJZRTUpDBqxNYN9YFllu05WZier6i+ylGLzZ
	 /bJzPbX+f6eAqIBEb89QDJWR+aJrNojFzXPteGiEQOp0FxaLeME6BX7r+ZG9sKF81n
	 shZGDulrT1KRhHlA6WaORAqSEr+xVX+b8/6QMqGxB6Ylgwc+xYnRUPGx9Z7SxCU3/o
	 KhMWHfvsW9TyQ==
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
Subject: [PATCH net-next v3 06/10] selftests: rds: Add SUDO_USER env variable
Date: Sun,  3 May 2026 22:41:39 -0700
Message-Id: <20260504054143.4027538-7-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260504054143.4027538-1-achender@kernel.org>
References: <20260504054143.4027538-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch modifies rds selftests to use the environment variable
SUDO_USER for tcpdumps if it is set.  This is needed to avoid chown
operations on the vng 9pfs which is not supported.  Passing a user
listed in sudoers avoids the tcpdump privilege drop which may
otherwise create empty pcaps

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/README.txt |  7 +++++++
 tools/testing/selftests/net/rds/test.py    | 11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/rds/README.txt b/tools/testing/selftests/net/rds/README.txt
index e629e08f04ef..295dc82c0770 100644
--- a/tools/testing/selftests/net/rds/README.txt
+++ b/tools/testing/selftests/net/rds/README.txt
@@ -37,6 +37,12 @@ ENV VARIABLES:
 			the specified --rwdir path for logs to persist on
 			the host.
 
+	SUDO_USER	The user name that should be used for tcpdump
+			--relinquish-privileges.  Set this to a user
+			belonging to the sudoers group to avoid drop
+			privilege errors with the vng 9p filesystem
+			which may result in empty pcaps
+
 EXAMPLE:
 
     # Create a suitable gcov enabled .config
@@ -54,6 +60,7 @@ EXAMPLE:
     # launch the tests in a VM
     vng -v --rwdir ./ --run . --user root --cpus 4 -- \
         "export PYTHONPATH=tools/testing/selftests/net/; \
+         export SUDO_USER=example_user; \
          export RDS_LOG_DIR=tools/testing/selftests/net/rds/rds_logs; \
          tools/testing/selftests/net/rds/run.sh"
 
diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 0ece8324d255..7a3616ac288f 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -134,10 +134,15 @@ if logdir is not None:
     for net in [NET0, NET1]:
         pcap = logdir+'/'+net+'.pcap'
         fd, pcap_tmp = tempfile.mkstemp(suffix=".pcap", prefix=f"{net}-", dir="/tmp")
+
+        tcpdump_cmd = ['ip', 'netns', 'exec', net, '/usr/sbin/tcpdump']
+        sudo_user = os.environ.get('SUDO_USER')
+        if sudo_user:
+            tcpdump_cmd.extend(['-Z', sudo_user])
+        tcpdump_cmd.extend(['-i', 'any', '-w', pcap_tmp])
+
         # pylint: disable-next=consider-using-with
-        p = subprocess.Popen(
-            ['ip', 'netns', 'exec', net,
-             '/usr/sbin/tcpdump', '-i', 'any', '-w', pcap_tmp])
+        p = subprocess.Popen(tcpdump_cmd)
         tcpdump_procs.append((p, pcap_tmp, pcap, fd))
 
 # simulate packet loss, duplication and corruption
-- 
2.25.1

