Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B25488203;
	Wed, 16 Sep 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549097; cv=none; b=fTgbzVFfP+OjZDfOFyWBgThAvgkCj+E9t3KecUBEWpI00vFg02PVYBT5spDZkp5J9Z5dVzsZKpopIZIcd/l6FgYFarjMvWlZ1P/bS2DOB9Ic+GcYrassz7xt4v0juNnljM+c33AS5ZdcSEch0/BPVJqwQdE7SP+Mhj8Ec8yg53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549097; c=relaxed/simple;
	bh=apoYZJ4aV78BIhXxsNc2PRd/zWM26Cir71eYXWkL0bI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HCJhUKoz4u95LXl6xzyyV8C5BeORVt27hFUFGu1x4OYtsON1QVxHXZvvoWwzql7yMVUjfSn8AW+YLrWyqX+kWi5d8J5PUd70oMcSkDZBLUmaxyyK6z5A6AGp+09bamVA1souUQH//PvVTSRaQ7c51zbIbDrp9/ZGfmF9ZLv+TGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=VVZJqFJP; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="VVZJqFJP"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Li
 RongQing <lirongqing@baidu.com>, Yonatan Nachum <ynachum@amazon.com>, Or
 Har-Toov <ohartoov@nvidia.com>, Michael Margolin <mrgolin@amazon.com>, Yishai
 Hadas <yishaih@mellanox.com>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT
Date: Wed, 16 Sep 2026 16:55:29 +0800
Message-ID: <20260916085529.1838-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc3.internal.baidu.com (172.31.50.47) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789548939;
	bh=1Tu/nikAoihOXJqtnS0E0C7QWUtUTpWvxcZ4GxY0fEU=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=VVZJqFJP/7RSKHlbAR64yJvKbbLOzNVnQvx5Bw2A4aDMf8PqMiDo22gC4optw8Wno
	 ZNMJajJw952GjBRp8gjp0UEPsMV0NAqOvsJjxjOKIf2oGKo3rBfo4H9YiZN63dXqnu
	 T6fkd99t4uqrFLBju3pesWwlHFToh4BpTNgjg6iLupwRIMJVxlzo6SXIMv+IK+1JGv
	 6DkTj75KKNE3Csx2AVwGgynxReZduXXTG72taM4HW1iJt3chcFPSpyXE7lbv4CnfmM
	 ORhw8Lqtlyf+nQd1YA8OLLyzsNizK0Cbi+y1ZTeg7qivS4I+c+0V1jY7WRz9eYifLc
	 qTVw9PpE+wQqA==

From: Li RongQing <lirongqing@baidu.com>

The UVERBS_METHOD_GET_CONTEXT handler allocates the ucontext via
ib_alloc_ucontext(), which calls rdma_restrack_new() (initialising the
kref to 1) and rdma_restrack_set_name(NULL), the latter attaching the
current task and taking a task_struct reference.  When ib_init_ucontext()
subsequently fails, the error path only does:

	kfree(attrs->context);
	attrs->context = NULL;

without first calling rdma_restrack_put() on &attrs->context->res.  The
kref therefore never reaches zero, restrack_release() is never invoked,
and put_task_struct() is never called, so the task_struct reference taken
during set_name is leaked permanently.

A local user with access to an RDMA device can repeat this path (e.g. by
hitting an RDMA cgroup limit or supplying invalid ucaps) and leak one
task_struct reference per attempt, eventually preventing those processes
from being reaped or exhausting memory.

The legacy ib_uverbs_get_context() path already handles this correctly
at its err_ucontext label, where rdma_restrack_put() precedes kfree().
Mirror that ordering here.

Fixes: a1123418ba10 ("RDMA/uverbs: Add ioctl command to get a device context")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/infiniband/core/uverbs_std_types_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/infiniband/core/uverbs_std_types_device.c
index ce0a7de0..db65032 100644
--- a/drivers/infiniband/core/uverbs_std_types_device.c
+++ b/drivers/infiniband/core/uverbs_std_types_device.c
@@ -272,6 +272,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT)(
 		return ret;
 	ret = ib_init_ucontext(attrs);
 	if (ret) {
+		rdma_restrack_put(&attrs->context->res);
 		kfree(attrs->context);
 		attrs->context = NULL;
 		return ret;
-- 
2.9.4

