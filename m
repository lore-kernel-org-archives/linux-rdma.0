Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB88B412C03
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 09:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229955; cv=none; b=YdZVQOWDsF5rNgYL7599X7FIgzxFfvnCvzCtJX848h1S+3kV71c2QOd+BcRelYW0ZSapEDusuiz92UmFdhV+2yIN3yONWN+7du4oPyV3NQYssP6jUNVVwPg7wwE+Gg3X3VYHNaTN8quHirK2HxChkpEogRihbut6C/ya3BTKFYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229955; c=relaxed/simple;
	bh=fGfIceLcIaUtqHbMITPYJtMV1eG4ZI6erIdwQ9Ul1bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c/UUhxIJutaDkuNo/HH3nMB/pRg6PVze4XqTlIrUaVGn4mx2k4vVcoXyhnWGrvfM9nDAfiNm1GgMPYu7n1cRvUmIYFvS59HLTRFekdpxhget/jgMRNsONAiqQm62xpk1Oppw4mOY5dHHjv6IXKn4l2XZ9r0GvTf6pgsp9X1EHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZexLp4Z/; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZexLp4Z/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785229950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1sAzbBalRs8j/y6mNWTtwweO455fLmYMdQ9qRci22so=;
	b=ZexLp4Z/uuMcoJWXNb0iY04Pf15y1QJqLAFB9qfKohlooFVwo0CpnTDNK7MNrRikr8EEr7
	z+Vv7xfRsDF/kTAGwsvwk1CW7T00pOz4rzjlYAq5yZ6wlFxa7T3hTe7vYRDpcnRh8crUVR
	tZksfkuPkZqDuX5/19EZTqCtqC5tLwU=
From: Gang Yan <gang.yan@linux.dev>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	Gang Yan <yangang@kylinos.cn>
Subject: [PATCH net 0/2] RDMA/rxe: fix mr_check_range() iova overflow (OOB)
Date: Tue, 28 Jul 2026 17:11:26 +0800
Message-ID: <20260728091128.9116-1-gang.yan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Gang Yan <yangang@kylinos.cn>

Hi, Maintainers

I've recently started learning RDMA, using soft-RoCE (rxe) as my study
platform. While pair-programming with an AI assistant during this learning,
it flagged an integer overflow in mr_check_range(). I dug in, stood up a
small reproducer, and -- believing the issue is real and worth fixing --
put together this small series.

Thanks
Gang

Gang Yan (2):
  RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB
    access
  DO-NOT-MERGE: selftest: add rxe mr_check_range() overflow reproducer

 drivers/infiniband/sw/rxe/rxe_mr.c            |   3 +-
 tools/testing/selftests/rdma/Makefile         |   8 +-
 tools/testing/selftests/rdma/config           |   2 +
 .../testing/selftests/rdma/rxe_mr_overflow.c  | 187 ++++++++++++++++++
 .../testing/selftests/rdma/rxe_mr_overflow.sh | 132 +++++++++++++
 5 files changed, 330 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.c
 create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.sh

-- 
2.43.0

