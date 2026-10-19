Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDE73C3F58
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 04:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383575; cv=none; b=fF/xYc9JP+GcnMe0dZqJe4ZTkIVW9lxN7Dd05uxh8PvBfSs7NPwXsqJo0OCjPjxOoF1xQOfVyWQP2FQxzDtpwnFC3kKGbwTznSPIzIL+4pUgETXk8r47HjxHiDpVWOacssxJROkvPuSPvWOyhGKWOY1cknrAiieyCq8KtYmykxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383575; c=relaxed/simple;
	bh=L80dWmu257Ub/OczU4qA6YPrszYfh9cH34VglMX8rpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N4smxaWo8JFAN48/aBiFzMEApA/77du2b8bQRXlcE2ESdYxEmzrwG1WUWRjVFNbMnllb+8FZGSH97bg6pabDNBUncliWF2V3eGCdFNiyhaCD7cr8o4P4++RJmF1i4AD7eoqo4KKHHf8MG/CXhGeu68b6MKhuCRysL1fDdaKMT+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xus7uO9F; arc=none smtp.client-ip=95.215.58.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xus7uO9F"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L80dWmu257Ub/OczU4qA6YPrszYfh9cH34VglMX8rpY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792383567; v=1; x=1792988367;
 b=xus7uO9FTOe42gt+ZVL09T2tNedCmLl8CVYo9RAcM7u2/u/IZuYLP1iA3N8bdwwEQb2zDW/9
 SvYHkuw4xjlnrUlvgXWwnvrue27/j1V63nDzrfGZc/B40Ygl0ARBSQSkzT08WwzVGy0fWZ9lQLF
 KhaXkQVNogaNC3bD1v6WSY40=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5920061a1c94efe1;
	Mon, 19 Oct 2026 04:19:27 +0000
X-Mizu-Trace-ID: 5920061a1c94efe1
X-Migadu-Flow: FLOW_OUT
From: Zhu Yanjun <yanjun.zhu@linux.dev>
To: jgg@ziepe.ca,
	leon@kernel.org,
	shuah@kernel.org,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH 0/2] selftests/rdma: Add an eBPF-based testcase using netkit for RXE
Date: Sun, 18 Oct 2026 21:19:10 -0700
Message-ID: <20261019041912.29488-1-yanjun.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new self-test case to verify RXE (Soft-RoCE) traffic using
netkit virtual interfaces and an eBPF tcx ingress program to dump
and parse RDMA transport headers (BTH, etc.).

Zhu Yanjun (2):
  selftests/rdma: Introduce eBPF kernel and user dump utilities for RXE
  selftests/rdma: Add netkit-based automated test script for RXE

 tools/testing/selftests/rdma/Makefile         |   23 +-
 tools/testing/selftests/rdma/config           |    3 +
 .../selftests/rdma/rxe_pkg_kernel_dump.c      |   62 +
 .../testing/selftests/rdma/rxe_pkg_netkit.sh  |   63 +
 .../selftests/rdma/rxe_pkg_user_dump.c        | 1275 +++++++++++++++++
 5 files changed, 1425 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_kernel_dump.c
 create mode 100755 tools/testing/selftests/rdma/rxe_pkg_netkit.sh
 create mode 100644 tools/testing/selftests/rdma/rxe_pkg_user_dump.c

-- 
2.54.0

