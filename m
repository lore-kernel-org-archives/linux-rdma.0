Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id A13A52C027B;
	Fri, 11 Sep 2026 02:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092980; cv=none; b=j4YIh9017+we+GRb1dqDakJkthm7HF3yhHvFxy5yhaAY3LhydMNrX2ElcDh+9q4oA0O+eo+Tb9mjvmXbLTTGLXoO1ORrf2n6+zmKMznnPhjQ11Lu0pMY1DqQnCsJCVXA3DVHnPRC8hbDHhlH6DKeu3W01i3i0ZeAgE83qszuSWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092980; c=relaxed/simple;
	bh=YCkICqyYmkSa7p7AStB+yREB5y+r2gr54uPB38dZGIw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qGdpiKQq6epTkVP3euSG3ac/gmJmEAGz0ZgryEnCyTRuBfSCNW7uqzZOMy5M0NqNzkjXzrNkUXGGJjGdw1O5rm7ra92zYnWAJbuPL6dAP4/TGJHgDeBvaxcEqMft8V38cRF8xsia3qZjBDzH5k/WMdRJ7Aiko9KGcbuvRIX1VyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=PoEvty63; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="PoEvty63"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Yishai Hadas <yishaih@mellanox.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] RDMA/uverbs: Make CQ handle mandatory for WQ creation
Date: Fri, 11 Sep 2026 10:15:57 +0800
Message-ID: <20260911021557.2113-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc2.internal.baidu.com (172.31.3.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789092966;
	bh=YHK4optObjzU8ODd5OSQZiZ+5HVywfUDRSYNzxzidyY=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=PoEvty63DBmu0jHaDGhlIaNNa5J8ibzSAQvpAkGDl1Hn3ADfAVNeupDJgkE9UndpY
	 DRrATBP69bYfNtQPE35evfMtS3lVJja0Zkll6lVk1+brRN3Ddl9LjG8tLePDamO4vU
	 q3nM7xt/wvVyA7ppZpDdcHFCZEfupom1Pk6iicGM3k8lJwvKRBamTv4lKTK7hXuTQe
	 KHP6l/nbsT8xLFNQrX/c44hD6VyaNgSE6GaK3SR5Trr9Cp6DyvNichohRWeZrJf8RK
	 2fE1BKCzPewL/iGtnE3/fDThG11S4Sj4UHw0wUPupaPpAthcAFWg7Yb3iA0rPgWIZp
	 a4Ln8wttKzzYg==

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
one via uobj_get_obj_read() in ib_uverbs_ex_create_wq().  Declare the
attribute UA_MANDATORY so the uverbs framework rejects the ioctl early
when the CQ handle is missing, before the handler ever runs.

Fixes: ef3bc084a8ed ("IB/uverbs: Introduce create/destroy WQ commands over ioctl")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: declare it as UA_MANDATORY, rather than
adding a manual IS_ERR check in the handler.

 drivers/infiniband/core/uverbs_std_types_wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_wq.c b/drivers/infiniband/core/uverbs_std_types_wq.c
index 7ded833..c23f455 100644
--- a/drivers/infiniband/core/uverbs_std_types_wq.c
+++ b/drivers/infiniband/core/uverbs_std_types_wq.c
@@ -140,7 +140,7 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_WQ_CQ_HANDLE,
 			UVERBS_OBJECT_CQ,
 			UVERBS_ACCESS_READ,
-			UA_OPTIONAL),
+			UA_MANDATORY),
 	UVERBS_ATTR_FD(UVERBS_ATTR_CREATE_WQ_EVENT_FD,
 		       UVERBS_OBJECT_ASYNC_EVENT,
 		       UVERBS_ACCESS_READ,
-- 
2.9.4

