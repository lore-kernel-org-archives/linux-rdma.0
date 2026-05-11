Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAF637DE9C;
	Mon, 11 May 2026 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778484199; cv=none; b=j3drr8rcWLswe+abcQu5SWjIskmklITMOZCH6XAYuxmyGnuY19nwJn7hacewzz4tTVP7mdCKtUI87/rdxfPAM5h2AQwBsIwqBK7MQNsQuqUgii/xZuw95L/61nvDfvqBXR4++f/8QU/AdTZlKNZczVYqdvuKeFkmq41wK6q4wh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778484199; c=relaxed/simple;
	bh=t/+6rhUgZ8sfLePH5/EGAngIUcgN2Nxdbaz5LcrJLhw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xc8c0VFicGdO2SLcR5lBSFPcGAryb0540JHJClDWBZjf5C5UkHTVOOIOciTz+MlqNRGmaPSvJBq7+RaKy1Lf2No2mTbeFw41J5jJiIJUxsM8YJCenke7RtwiDJWqa6x/+5J4s2C/bfivVmrxNOCW9yZHNB8IExMJCatXHT9++Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSEam99q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSEam99q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7109CC2BCFC;
	Mon, 11 May 2026 07:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778484199;
	bh=t/+6rhUgZ8sfLePH5/EGAngIUcgN2Nxdbaz5LcrJLhw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XSEam99qXKPSaykOXWnkE75xrV5DZUxklPMBnAknA5WilzKTE+1AwCuponApq4bmx
	 eSuXhW8RJfSpjHe2h4RhYYK4A9sTIw0FthKhe/FK9NP7wpUSwdVhygB2zocuKaEgtd
	 Toih0HQ5ofUz5Q/A/ll5GO+2t68VPBN6lfDSJJRskCa/C3rtvVXXKjgkkDsyXFm481
	 dF1q6XbVMp0f4sYhIlhgeo7h1PS9JfnFkwbMWpegHbotpmjxEvy/3GigJHU6LuzqxC
	 aNonCb9NQhIMRKHlXkzoFj/HcWER/G6xzKTOHEghLeuJxXBedrud/o17ejRc64a63F
	 6nb3xT9vwxG9w==
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
Subject: [PATCH net-next v1 2/9] selftests: rds: Add helper function setup_tcp() in test.py
Date: Mon, 11 May 2026 00:23:09 -0700
Message-Id: <20260511072316.1174045-3-achender@kernel.org>
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

Hoist the network configs in test.py into a tcp specific helper
function, setup_tcp().  This is a preparatory refactoring for the
rds over ROCE series which will add separate function for rdma
specific configs.  No functional changes are introduced in this patch.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 113 +++++++++++++-----------
 1 file changed, 60 insertions(+), 53 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index d78c00226e7b..027131b26287 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -32,6 +32,15 @@ NET1 = 'net1'
 VETH0 = 'veth0'
 VETH1 = 'veth1'
 
+tcpdump_procs = []
+tcp_addrs = [
+    # we technically don't need different port numbers, but this will
+    # help identify traffic in the network analyzer
+    ('10.0.0.1', 10000),
+    ('10.0.0.2', 20000),
+]
+
+
 # Helper function for creating a socket inside a network namespace.
 # We need this because otherwise RDS will detect that the two TCP
 # sockets are on the same interface and use the loop transport instead
@@ -100,6 +109,55 @@ def signal_handler(_sig, _frame):
     print("not ok 1 rds selftest")
     sys.exit(1)
 
+def setup_tcp():
+    """
+    Configure tcp network
+    """
+
+    ip(f"netns add {NET0}")
+    ip(f"netns add {NET1}")
+    ip("link add type veth")
+
+    # Move TCP interfaces into separate namespaces so they can no longer be
+    # bound directly; this prevents rds from switching over from the tcp
+    # transport to the loop transport.
+    ip(f"link set {VETH0} netns {NET0} up")
+    ip(f"link set {VETH1} netns {NET1} up")
+
+    # add addresses
+    ip(f"-n {NET0} addr add {tcp_addrs[0][0]}/32 dev {VETH0}")
+    ip(f"-n {NET1} addr add {tcp_addrs[1][0]}/32 dev {VETH1}")
+
+    # add routes
+    ip(f"-n {NET0} route add {tcp_addrs[1][0]}/32 dev {VETH0}")
+    ip(f"-n {NET1} route add {tcp_addrs[0][0]}/32 dev {VETH1}")
+
+    # sanity check that our two interfaces/addresses are correctly set up
+    # and communicating by doing a single ping
+    ip(f"netns exec {NET0} ping -c 1 {tcp_addrs[1][0]}")
+
+    # Start a packet capture on each network
+    if logdir is not None:
+        for netn in [NET0, NET1]:
+            pcap = logdir+'/rds-'+netn+'.pcap'
+
+            tcpdump_cmd = ['ip', 'netns', 'exec', netn, '/usr/sbin/tcpdump']
+            sudo_user = os.environ.get('SUDO_USER')
+            if sudo_user:
+                tcpdump_cmd.extend(['-Z', sudo_user])
+            tcpdump_cmd.extend(['-i', 'any', '-w', pcap])
+
+            # pylint: disable-next=consider-using-with
+            p = subprocess.Popen(tcpdump_cmd,
+                                 stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
+            tcpdump_procs.append(p)
+
+    # simulate packet loss, duplication and corruption
+    for netn, iface in [(NET0, VETH0), (NET1, VETH1)]:
+        ip(f"netns exec {netn} /usr/sbin/tc qdisc add dev {iface} root netem  \
+             corrupt {PACKET_CORRUPTION} loss {PACKET_LOSS} duplicate  \
+             {PACKET_DUPLICATE}")
+
 #Parse out command line arguments.  We take an optional
 # timeout parameter and an optional log output folder
 parser = argparse.ArgumentParser(description="init script args",
@@ -120,59 +178,8 @@ PACKET_LOSS=str(args.loss)+'%'
 PACKET_CORRUPTION=str(args.corruption)+'%'
 PACKET_DUPLICATE=str(args.duplicate)+'%'
 
-ip(f"netns add {NET0}")
-ip(f"netns add {NET1}")
-ip("link add type veth")
-
-addrs = [
-    # we technically don't need different port numbers, but this will
-    # help identify traffic in the network analyzer
-    ('10.0.0.1', 10000),
-    ('10.0.0.2', 20000),
-]
-
-# move interfaces to separate namespaces so they can no longer be
-# bound directly; this prevents rds from switching over from the tcp
-# transport to the loop transport.
-ip(f"link set {VETH0} netns {NET0} up")
-ip(f"link set {VETH1} netns {NET1} up")
-
-
-
-# add addresses
-ip(f"-n {NET0} addr add {addrs[0][0]}/32 dev {VETH0}")
-ip(f"-n {NET1} addr add {addrs[1][0]}/32 dev {VETH1}")
-
-# add routes
-ip(f"-n {NET0} route add {addrs[1][0]}/32 dev {VETH0}")
-ip(f"-n {NET1} route add {addrs[0][0]}/32 dev {VETH1}")
-
-# sanity check that our two interfaces/addresses are correctly set up
-# and communicating by doing a single ping
-ip(f"netns exec {NET0} ping -c 1 {addrs[1][0]}")
-
-tcpdump_procs = []
-# Start a packet capture on each network
-if logdir is not None:
-    for net in [NET0, NET1]:
-        pcap = logdir+'/rds-'+net+'.pcap'
-
-        tcpdump_cmd = ['ip', 'netns', 'exec', net, '/usr/sbin/tcpdump']
-        sudo_user = os.environ.get('SUDO_USER')
-        if sudo_user:
-            tcpdump_cmd.extend(['-Z', sudo_user])
-        tcpdump_cmd.extend(['-i', 'any', '-w', pcap])
-
-        # pylint: disable-next=consider-using-with
-        p = subprocess.Popen(tcpdump_cmd,
-                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
-        tcpdump_procs.append(p)
-
-# simulate packet loss, duplication and corruption
-for net, iface in [(NET0, VETH0), (NET1, VETH1)]:
-    ip(f"netns exec {net} /usr/sbin/tc qdisc add dev {iface} root netem  \
-         corrupt {PACKET_CORRUPTION} loss {PACKET_LOSS} duplicate  \
-         {PACKET_DUPLICATE}")
+setup_tcp()
+addrs = tcp_addrs
 
 print("TAP version 13")
 print("1..1")
-- 
2.25.1

