Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14218233149
	for <linux-rdma@vger.kernel.org>; Sat, 28 Mar 2026 09:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774690136; cv=none; b=Lj+a/jNSvwr5XMfihH0kxTc7eWVZkY5Hfv1pu0N2YrUAabE53RMT6KKG72+NA863ofKSDJMdYq7t05T995T3EHwvbFtygQ4h6EJxj6KDaZk+YJCtdjasYQmZ1qfRMGeFDg/8z+AnQzTzcDG7pPvYEkqKpqMUweaftXzJTyFYJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774690136; c=relaxed/simple;
	bh=MwToWGGwAJxd4I07E76R9RLeAr7fUhYHdBo/93lT+dc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XCQXgrKSy5239f03lT1GPEL57solfN+UmI2wrsWRNudWnlowQSuKxuuHgwfrTQcWp+PaQhTJ254+wpgjkjCaxxbv/6Mmgthb+LTNrQuVkkHwkWBXjLY/1CwjUnYHhrcsk0ZgzLYIUInRQXEfYqKt/6RoqqIjqrLjjC1ep7RmXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q/FHGFyk; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q/FHGFyk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774690133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3ROJjKsrBGyUGnqrwClopQY/AxLgW8yrz9t0NfMUC7s=;
	b=Q/FHGFykyz/2wZkOaiokTkkB682snIof1/fknL7cnZl1Hag2c6w/LrSE2d67ETs6wuW9+w
	ZHc0vK49T495wCe3O4B0frCdKgFuWrQw92YhSZEhbbKOYsKdROJa01IZ2APZ8kY+Q8PTOK
	XiWxvQC3vcpiV5L8Ol6LXE1RGEmnZKA=
From: zhenwei pi <zhenwei.pi@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	zhenwei pi <zhenwei.pi@linux.dev>
Subject: [PATCH 0/3] Support PERF MGMT for RXE
Date: Sat, 28 Mar 2026 17:28:35 +0800
Message-ID: <20260328092839.111499-1-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Support PERF MGMT for RXE, add sent/received bytes for RXE counters,
also improve coding style.

zhenwei pi (3):
  RDMA/rxe: use RXE_PORT instead of magic number 1
  RDMA/rxe: add SENT/RCVD bytes
  RDMA/rxe: support perf mgmt

 drivers/infiniband/sw/rxe/Makefile          |  1 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.c |  2 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.h |  2 +
 drivers/infiniband/sw/rxe/rxe_loc.h         |  6 ++
 drivers/infiniband/sw/rxe/rxe_mad.c         | 86 +++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_net.c         |  7 +-
 drivers/infiniband/sw/rxe/rxe_recv.c        |  1 +
 drivers/infiniband/sw/rxe/rxe_verbs.c       |  9 ++-
 drivers/infiniband/sw/rxe/rxe_verbs.h       | 11 +++
 9 files changed, 118 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_mad.c

-- 
2.43.0

