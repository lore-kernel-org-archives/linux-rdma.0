Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643664A35
	for <linux-rdma@vger.kernel.org>; Wed,  8 Apr 2026 00:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775607017; cv=none; b=e88JYzqwAgFwaL4JnPfl6icj0FuolQhmboTKkXiRI0As6QtLLAiphbo//Q4HBcGuXoXHMvhXuVcIdUSFzKSUADekkgsVNn8mTT69BW5uiV5u3eZU7OWxgIK6jJymAPnI124BA+EQFAA47YCJwxzUy+3dx1ogwLJgzb8bPgpTCME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775607017; c=relaxed/simple;
	bh=tmyJRCYNGd8dt9swtikiDxXHO1KNGuB5c3YX9eHIvKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QvV4DRW7XyKhFLsIDsNR2dKV5moi3ih7ykEoYWtnyCBr1/ij184Jccz22rN7Heh9mYNM94sOPJNZINFU+QxZ9Ei9+DS6QHAM45u/ME2YOMi4+ziQgqRCSJf5DW2bJuLzkMI4NUbHUGJsOpWye/fQ39JRL1yx68m7uwBN9W3vpk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jZrOm8gj; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jZrOm8gj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775607011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kFFzLvq7ZvG1uGtLa8Rm+ALcKcE4RreLa1Aw0/kdtxc=;
	b=jZrOm8gjvk6NxzHhMfsIJeaCWZEKPuEZcLa//fqt1Bo/ANktiBhsvP2Fr5TNO3gZs9NwRh
	nznxzfdXBwvvewnsz5Ypn/wYhQRTT2b2MBiT4YyxS9XA26QECVyd+2W6SZg/sHytvNsPiY
	AmA+C66B8kPhQ0D9faJXK/MmUZuCtJQ=
From: zhenwei pi <zhenwei.pi@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	zhenwei pi <zhenwei.pi@linux.dev>
Subject: [PATCH v5 0/3] Support PERF MGMT for RXE
Date: Wed,  8 Apr 2026 08:09:53 +0800
Message-ID: <20260408000956.486522-1-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v5:
- remove patch "RDMA/core: Fix memory free for GID table", it was
  applied by Jason separately.
- suggested by Yanjun, use 'skb_network_offset' to calculate the
  length of received packets.

v4:
- drop rxe_ib_device_get_netdev and RXE_PORT, use 1 instead
- avoid UAF to get skb length
- remove one-line wrapper rxe_counter_get, use atomic64_read instead
- fix memory free for GID table, this is a new patch in this series.

v3:
- merge 'RDMA/rxe: use rxe_counter_get' into previous commit
- zero *out* MAD memory
- return success with error status rather than failure to avoid
  uplayer hang

v2:
- Fix overflow for PMA counter *link_downed_counter*
- Use *rxe_counter_get* instead of *atomic64_read* for hw-counters

v1:
Support PERF MGMT for RXE, add sent/received bytes for RXE counters,
also improve coding style.

zhenwei pi (3):
  RDMA/rxe: remove rxe_ib_device_get_netdev() and RXE_PORT
  RDMA/rxe: add SENT/RCVD bytes
  RDMA/rxe: support perf mgmt GET method

 drivers/infiniband/sw/rxe/Makefile          |   1 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.c |   2 +
 drivers/infiniband/sw/rxe/rxe_hw_counters.h |   2 +
 drivers/infiniband/sw/rxe/rxe_loc.h         |   6 ++
 drivers/infiniband/sw/rxe/rxe_mad.c         | 101 ++++++++++++++++++++
 drivers/infiniband/sw/rxe/rxe_mcast.c       |   4 +-
 drivers/infiniband/sw/rxe/rxe_net.c         |   9 +-
 drivers/infiniband/sw/rxe/rxe_recv.c        |   2 +
 drivers/infiniband/sw/rxe/rxe_verbs.c       |   5 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h       |  10 +-
 10 files changed, 129 insertions(+), 13 deletions(-)
 create mode 100644 drivers/infiniband/sw/rxe/rxe_mad.c

-- 
2.43.0

