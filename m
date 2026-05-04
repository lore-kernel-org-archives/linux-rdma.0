Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AAE286D57;
	Mon,  4 May 2026 05:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777873306; cv=none; b=fP5j+UQopeVt9hOcCdlGhPeUBwehdpqm/DIyLxSqXNWRp1pGc3C1pe6q6BQXUxEFYCsG3MlVatHpWUsJMQZ7ENN6U7USymXaLCpUp3wvaSZmYtA9p3EVckvP47los2Gp7glPMenxGv3XC+GBtRLKoUvsbadiMycet6AMUSld5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777873306; c=relaxed/simple;
	bh=AzcEuGQxW5HnT+9hKxiYEzYX/WKDcXo69VDWyZunXy0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HNMutXaXWo3dwgLncW9c75F4ihJDfhMKUbXTOCUdwpLPxZJm1d2JZb1X0XQoODYIOAMvZuAd2YL6kD+fVEFtpLXkaS3EjRjWU4bL+6lfhkmesifPjPvVEHsSQKMBoVdyXuGZ/kqQX51J2XQs9q2myt++6YTREw+torzu5OkUinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjcRProX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjcRProX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39553C2BCB8;
	Mon,  4 May 2026 05:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777873306;
	bh=AzcEuGQxW5HnT+9hKxiYEzYX/WKDcXo69VDWyZunXy0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TjcRProXTSfjIPGFltbQujMQeWjfCf2CAL7vr/S3vLyYaCozrHo4UY4+3Mu8yZ+Tt
	 dREcIwsh8DhEtQ5vKwP0YL7xSGzolQfCd/VEc0Kkugf+ZdiodC8RmZSECZNn57laG1
	 kVaczZuPSi+R0T+pSNwRRHXfjXHVzK9Axd/oxh5ubN0puZ8OMCsrQE2LFUgTH3yiTs
	 U1LWvdzpjwYD0dl5MHGshmk6YZt1xPVH7+QahkIWJXBqLCYUNAg3vQH+DaweUWtQPy
	 NXyffx2Ka1A/+lg05VXVBPdCEZVRVJf6VvgVDb/sHfDcQQwVX91oasMLGbf6ePMTZW
	 H0g2FojaR8cxQ==
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
Subject: [PATCH net-next v3 03/10] selftests: rds: Fix more pylint errors
Date: Sun,  3 May 2026 22:41:36 -0700
Message-Id: <20260504054143.4027538-4-achender@kernel.org>
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

This patch fixes a few pylint errors in test.py. Remove unused exception
variables from except blocks, and disable warnings for imports that cannot
appear at the start of the module.  Also disable warnings for the
tcpdump processes.  The suggestion to use a with block does not apply
here since the process needs to outlive the parent to collect the dumps.
Lastly add the module docstring at the top of the module.

Signed-off-by: Allison Henderson <achender@kernel.org>
---
 tools/testing/selftests/net/rds/test.py | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/rds/test.py b/tools/testing/selftests/net/rds/test.py
index 93e23e8b256c..4b6ffbb3a81c 100755
--- a/tools/testing/selftests/net/rds/test.py
+++ b/tools/testing/selftests/net/rds/test.py
@@ -1,5 +1,8 @@
 #! /usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
+"""
+This module provides functional testing for the net/rds component.
+"""
 
 import argparse
 import ctypes
@@ -17,7 +20,8 @@ import shutil
 # Allow utils module to be imported from different directory
 this_dir = os.path.dirname(os.path.realpath(__file__))
 sys.path.append(os.path.join(this_dir, "../"))
-from lib.py.utils import ip
+# pylint: disable-next=wrong-import-position,import-error,no-name-in-module
+from lib.py.utils import ip # noqa: E402
 
 libc = ctypes.cdll.LoadLibrary('libc.so.6')
 setns = libc.setns
@@ -129,6 +133,7 @@ tcpdump_procs = []
 for net in [NET0, NET1]:
     pcap = logdir+'/'+net+'.pcap'
     fd, pcap_tmp = tempfile.mkstemp(suffix=".pcap", prefix=f"{net}-", dir="/tmp")
+    # pylint: disable-next=consider-using-with
     p = subprocess.Popen(
         ['ip', 'netns', 'exec', net,
          '/usr/sbin/tcpdump', '-i', 'any', '-w', pcap_tmp])
@@ -192,7 +197,7 @@ while nr_send < NUM_PACKETS:
             send_hashes.setdefault((sender.fileno(), receiver.fileno()),
                     hashlib.sha256()).update(f'<{send_data}>'.encode('utf-8'))
             nr_send = nr_send + 1
-        except BlockingIOError as e:
+        except BlockingIOError:
             break
         except OSError as e:
             if e.errno in [errno.ENOBUFS, errno.ECONNRESET, errno.EPIPE]:
@@ -214,7 +219,7 @@ while nr_send < NUM_PACKETS:
                             receiver.fileno()), hashlib.sha256()).update(
                                     f'<{recv_data}>'.encode('utf-8'))
                         nr_recv = nr_recv + 1
-                    except BlockingIOError as e:
+                    except BlockingIOError:
                         break
 
     # exercise net/rds/tcp.c:rds_tcp_sysctl_reset()
-- 
2.25.1

