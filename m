Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2932A37CD2E;
	Tue, 28 Apr 2026 22:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777415238; cv=none; b=qsAE9uI2yYcFkEIAOyaZLfw8UcX00p90pouw8+OiaJlWzAj5DhHRtac8rAAqFtn06WrTvBbp0SjfPSC8vFblPV68okCE002pOCIHow5PlnktqHvpQJ1hu7U8SehB1qlCg9oi6KzzNXPnCKqJDrKhidDafjjYpMQayg5lBdPflHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777415238; c=relaxed/simple;
	bh=8pyThgtbNSdQ+bgiiI5KQ9VowNeeXwoqBtxjg0gFO8A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=tvQJ1XBleAL2Y4AcfR7HSt5Lq6IGdzUj/DLEOE1QQIRgocvdPcN6L4uN2pDIqdDshSjsFaE51pvtl/wA6swFx7C8MT/WDyYC7TfvaKgq/N9h6qLBfrCqNrOTphlWG7ecpyEs09vJG+UD9gsW7cB/O7KsJhxOhWNC9rYyKz6GBYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3vDnWq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3vDnWq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1DDC2BCAF;
	Tue, 28 Apr 2026 22:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777415237;
	bh=8pyThgtbNSdQ+bgiiI5KQ9VowNeeXwoqBtxjg0gFO8A=;
	h=From:To:Subject:Date:From;
	b=k3vDnWq2pPZp4tL3rurYXj/cvniIPQ8OrhR24Jh7YnKh7YqFumHJkd3H/XhM7oV4+
	 CqMjjLmAXCSMyZACyx2k1qZ9ZgoKzauzm9dTCsWBUAK2DyNqACURAdA75us3V02pr7
	 w9KOEu4RXNng+R+gAzySXDrZwPaevqRRFxTW1IjJrzTAONo97DEvWnt5aQvSyxHvqR
	 nd+7ZLOaY53TQCqaj/Wfk34PZ60RBgIS99PBzhKF9tDj00kRrUJi9VpZt8WwCwfJOc
	 GX1QphwzYPEpogcgJyoDCEGQrypyWnk877op0GPhsK5rIAMBAg/oGICaXBcVhX5Odu
	 LCoPEMRcR9Oog==
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
Subject: [PATCH net-next v2 0/7] selftests: rds: Log collection, TAP compliance and cleanups
Date: Tue, 28 Apr 2026 15:27:09 -0700
Message-Id: <20260428222716.2960871-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is a set of bug fixes and improvements for the rds
selftests.

Patch 1 bumps the kselftest timeout from 400s to 800s. The original
limit was developed against a lean config, but the kselftest harness
counts boot time and gcov log collection against the limit, so a
default config with gcov enabled needs more headroom. 

Patch 2 corrects some typos in the run.sh USAGE string and removes an
unused "-g" flag.

Patch 3 silences a handful of pylint warnings in test.py: it adds a
module docstring, suppresses the warnings tied to the sys.path.append
import trick, marks the long lived tcpdump Popen with disable-next
consider-using-with, and drops unused exception variables from two
BlockingIOError except clauses.

Patch 4 adds a -t flag to run.sh so the timeout can be overridden
if needed.

Patch 5 fixes log collection under vng. The vng guest inherits the
host's systemd config, so tmp and debugfs may not be mounted by
default; without them tcpdump can't write pcaps and gcov data is
silently dropped. The patch mounts each filesystem when it isn't
already mounted, and also specifies the --root folder so that gcov
can still find the kernel source when it is run from the ksft
test directory.

Patch 6 hoists pcap collection into a helper and calls it from the
timeout signal handler so dumps are preserved when a test times out.

Patch 7 makes the test output TAP compliant so the kselftest runner
parses results correctly.

Questions, comments and feedback appreciated!

Thanks everyone!
Allison

Change log:
v2:
   [PATCH net-next v2 3/7] selftests: rds: Fix more pylint errors
      NEW

   [PATCH net-next v2 6/7] selftests: rds: Collect pcaps on timeout
      Fixed pylint errors in collect_pcaps()

   [PATCH net-next v2 7/7] selftests: rds: Make rds selftests TAP compliant
      Fixed pylint errors from ksft import

Allison Henderson (7):
  selftests: rds: Increase selftest timeout
  selftests: rds: Update USAGE string for run.sh
  selftests: rds: Fix more pylint errors
  selftests: rds: Add timeout flag to run.sh
  selftests: rds: Fix gcov and pcap collection
  selftests: rds: Collect pcaps on timeout
  selftests: rds: Make rds selftests TAP compliant

 tools/testing/selftests/net/rds/run.sh   | 42 ++++++++----
 tools/testing/selftests/net/rds/settings |  2 +-
 tools/testing/selftests/net/rds/test.py  | 83 +++++++++++++++---------
 3 files changed, 86 insertions(+), 41 deletions(-)

-- 
2.25.1

