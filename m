Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 2E18B49EC46;
	Mon,  7 Sep 2026 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788781677; cv=none; b=ns2OAKSG+9Lsdb6d7w+8rLz1/cfuAcGJ2+xLp0n6Mobq9S7IK7MPmt5jGxpmtN47BZn4S6Pvgn81eD7gqsDY+sZThwqaQasKVUvW2W9u9Hc+c8gAFvxCQEQxc8tp3H5Hx8S9bWeuyFvKUchA32yrJPQdeRTFPJFfdFpqQvmdgKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788781677; c=relaxed/simple;
	bh=OF12tUy46rA7F+/AsV/bZbNqxUDOIShGuxaQ8fUa4Ok=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s2a/1K6cy4+JYTI/af+GDnxIcy0C8zvw0Wjhz8TQopcgOPnz0r4natyIC+IQ0WCCCiZteRMj28pVLczTCfCuAbv0WghOcJu+8u4wgZJVHWslNdNRvbniOAQjPDZpwODnyNwdZIrfvh3incaAcnVs5YycyF+QokazED6C1/q85ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=WQgHHl/d; arc=none smtp.client-ip=111.202.115.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="WQgHHl/d"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Yishai Hadas <yishaih@mellanox.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/uverbs: Reject WQ creation without a completion queue
Date: Mon, 7 Sep 2026 19:39:18 +0800
Message-ID: <20260907113918.2315-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc7.internal.baidu.com (172.31.3.17) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1788781169;
	bh=LCK40fSz/LE22Gwcj/6/dDENH8nWeSNJGZCZ4WQ6gzU=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=WQgHHl/dvoXFELPtes6PIdsBPCE+/1bRR2Sm7E5BSKrxWJHGgNfEiLzMlvqN2lcqx
	 J5FQrkhk6hZCboqq5B3i263QBhVspw/podz5gfCXqjlQueDanpDsc2rqXWuhkRpmZ/
	 XRZZ8WQM+mpgiW8u2Iq5nfLYQIxgrprilqmeyuD/rtgWosFeqFM9FgfdJOhzHS0hl+
	 NoFpF+dTb6CCVbWgzOolsCVrUz7iAv868Y/Z/yIyjWw1Wra8xUYLA2HEPtNLOeH0Fc
	 Jby2zclyXACsZgKnUNzOUtXKkr5NY32/Z8VbbRBgJLZUKx5JXazbXMlUXTxFkRWLVu
	 nzKQme6HLbxqA==

From: Li RongQing <lirongqing@baidu.com>

UVERBS_ATTR_CREATE_WQ_CQ_HANDLE is declared UA_OPTIONAL in the ioctl
method definition, so the mandatory attribute bitmap does not enforce
its presence.  When userspace omits it, uverbs_attr_get_obj() returns
ERR_PTR(-ENOENT) and the handler stores that error pointer into
wq_init_attr.cq without validation.

The bogus cq pointer is then passed to the driver's create_wq callback.
In the mlx5 case, create_rq() calls to_mcq(init_attr->cq) which applies
container_of to the ERR_PTR value, producing a near-NULL pointer.  The
subsequent access in get_rq_ts_format() triggers a kernel NULL pointer
dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000296
  RIP: 0010:create_rq+0x32/0x550 [mlx5_ib]
  Call Trace:
   mlx5_ib_create_wq+0x14a/0x210 [mlx5_ib]
   ib_uverbs_handler_UVERBS_METHOD_WQ_CREATE+0x1f0/0x320 [ib_uverbs]
   ib_uverbs_run_method+0x296/0x320 [ib_uverbs]
   ib_uverbs_cmd_verbs+0x1a0/0x260 [ib_uverbs]
   ib_uverbs_ioctl+0xa8/0x120 [ib_uverbs]

A WQ without a CQ was never valid; the legacy write path always required
one via uobj_get_obj_read() in ib_uverbs_ex_create_wq().  Add the missing
IS_ERR check on the cq pointer to fail the ioctl early with -ENOENT.

Fixes: ef3bc084a8ed ("IB/uverbs: Introduce create/destroy WQ commands over ioctl")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/uverbs_std_types_wq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_wq.c b/drivers/infiniband/core/uverbs_std_types_wq.c
index 7ded833..0308906 100644
--- a/drivers/infiniband/core/uverbs_std_types_wq.c
+++ b/drivers/infiniband/core/uverbs_std_types_wq.c
@@ -39,6 +39,9 @@ static int UVERBS_HANDLER(UVERBS_METHOD_WQ_CREATE)(
 	u64 user_handle;
 	int ret;
 
+	if (IS_ERR(cq))
+		return PTR_ERR(cq);
+
 	ret = uverbs_get_flags32(&wq_init_attr.create_flags, attrs,
 				 UVERBS_ATTR_CREATE_WQ_FLAGS,
 				 IB_UVERBS_WQ_FLAGS_CVLAN_STRIPPING |
-- 
2.9.4

