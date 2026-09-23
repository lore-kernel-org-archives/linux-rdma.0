Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id AA629529402;
	Wed, 23 Sep 2026 13:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169196; cv=none; b=U61zIkDp/8MRmR09Z7KiqKUCwygILIJdcmIVhOi9zcLVbY6ibsnDiTn2R1WsL97NmW4D8RSAb6uWsX8fPFke/kazlK0dhIVZx+c6eaxpdr+MYBS8Akj0/JtywDFjT6qDmfLLiI/iBNiIF91lJQOO6LQ6r44Oun8hLV2Qz+Gm3gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169196; c=relaxed/simple;
	bh=4u1cV/+zBqXTZwoC63kkm21YJ9ltLJ100b3nmXjCoqQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CPokmCAnVgwfU1SERRtFw+JVDsfDnl6i5VRQNqcYXLVLMc1oSDDw2rttqMgc9CB2IacNMQUG36vsUfTsJHsvT11zqokS8ptqhc4YIKpbNUDB2oPq3PcorVFldYXEfxrCctQnQJ5FXsKOR+0Nw6vUPoWd0ugUnAR5Am1lMrYp0Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=iBK+QPna; arc=none smtp.client-ip=111.202.115.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="iBK+QPna"
X-MD-Sfrom: zhangyili01@baidu.com
X-MD-SrcIP: 172.31.51.15
From: Yili Zhang <zhangyili01@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yili Zhang
	<zhangyili01@baidu.com>
Subject: [PATCH v3] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
Date: Wed, 23 Sep 2026 21:12:39 +0800
Message-ID: <20260923131239.6521-1-zhangyili01@baidu.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc12.internal.baidu.com (172.31.3.22) To
 BJKJY-Exc19.internal.baidu.com (172.31.51.15)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1790169181;
	bh=9EmMVzvuXEUjSfPbP7SWLHH6qv4L3yFCCBsDEWeP/sA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=iBK+QPna4GuW5kzKOyayH4nJFRllHR7Jp27Eu7xzTIS07AW6Sx+WimZ3waRONyAu6
	 LC+iLM2ybkgqY2w5eesdMZcsZarDGYCCJ1Jo/Dgtz0dkE73c6ERyBSKvbetIsbjvyM
	 TRyOx3BjGLMs6knmGGD+e7Ra1udxxCwoHQaotPvs3YojsOvDRNSG2ZkEcgCdBpv4Y/
	 Po9LuMYnFqUQBQzgFhotRGqvmeNxJzj3Dh+wj2KlSCs7Ni1oOCUNX2bnCEphMkyt5S
	 Z5E6Wa4XcClYVHXVQyb6Y/fdkQ7UDqRDZ9ADDEW+w9by2cu3uhGYeEouPVDwh24n7A
	 IqyESTvbAQtAQ==

fill_res_cq_entry() dereferences
cq->uobject->uevent.uobject.context->res.id unconditionally for user
resources.

This is normally safe by ordering: destroy_hw() removes the resource
from the restrack before uverbs_destroy_uobject() clears ->context,
and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
the entry from concurrent netlink dumps.

The ordering breaks when a driver keeps failing to destroy an object
during ucontext teardown. uverbs_destroy_ufile_hw() then falls back to
__uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
abandons the object in place: the HW object and its restrack entry
are intentionally leaked, while the uobject bookkeeping is torn down
and ->context is explicitly set to NULL by uverbs_destroy_uobject().
rdma_restrack_del() is never reached, so the orphaned entry stays in
the device restrack with a valid kref, reachable by any subsequent
netlink dump.

Observed on 6.1.52 with MLNX_OFED 24.10, after an mlx5 FW failure
left a process unable to tear down its CQ (destroy_cq FW command
failing during FD close):

  WARNING: ... uverbs_destroy_ufile_hw+0xe3/0x100
  BUG: kernel NULL pointer dereference, address: 0000000000000058
  RIP: 0010:fill_res_cq_entry+0x15e/0x180 [ib_core]
   res_get_common_dumpit+0x304/0x530 [ib_core]
   nldev_res_get_cq_dumpit+0x1a/0x20 [ib_core]

The faulting chain maps to the source (CR2 = 0x58):
  cq->uobject            (struct ib_cq +0x08, res at +0x98)
  uobject->context       (struct ib_uobject +0x10, NULL after abandon)
  context->res.id        (struct ib_ucontext +0x58)

The recent restrack rework (8d186210677c and its series) moved the
restrack deletion to the start of the destroy flow and thus fences
concurrent dumps from an object being destroyed, but it does not
cover this case: when destroy fails, rdma_restrack_abort_del()
restores the entry, and the RDMA_REMOVE_DRIVER_FAILURE sweep still
never removes it from the restrack. 

From the fallback until the device is unregistered, any "rdma res
show cq" deterministically takes the NULL pointer dereference; this
is a long-lived state, NOT A RACE. The dump path holds neither the
restrack lock (dropped before the fill callback runs) nor
ufile->hw_destroy_rwsem, and rdma_restrack_get() only guarantees
that the res memory stays alive, not that ->context is still valid.

Fix the dump side: check the uobject context directly instead of the
rdma_is_kernel_res() marker. A non-NULL uobject already implies a
user resource, so kernel resources keep being skipped, and the
additional ->context check skips the RES_CTXN attribute for
orphaned entries instead of crashing the dump. The orphaned resource
itself remains visible in "rdma res show" (cqn/cqe/usecnt/pid),
which is what an operator needs after the accompanying uverbs WARN
to diagnose the driver destroy failure.

fill_res_pd_entry() has the same pattern (pd->uobject->context->res.id)
and is fixed the same way; a PD can even reach the fallback without
its own driver callback failing, e.g. uverbs_free_pd() returns -EBUSY
while another object that failed to destroy still holds the PD usecnt.

Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP objects")
v2: https://lore.kernel.org/linux-rdma/20260917133340.42002-1-zhangyili01@baidu.com/
v1: https://lore.kernel.org/all/20260813000442.GI662699@ziepe.ca/
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
---
Changes in v3 (per Leon Romanovsky):
- Drop the nla_put_res_ctxn() helper and check the uobject context
  directly instead of rdma_is_kernel_res().

 drivers/infiniband/core/nldev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4e8fbee34745..eddf846e27b1 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -700,7 +700,11 @@ static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQN, res->id))
 		return -EMSGSIZE;
-	if (!rdma_is_kernel_res(res) &&
+	/*
+	 * uobject is NULL for kernel resources; context is NULL for
+	 * uobjects abandoned by the RDMA_REMOVE_DRIVER_FAILURE sweep
+	 */
+	if (cq->uobject && cq->uobject->uevent.uobject.context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			cq->uobject->uevent.uobject.context->res.id))
 		return -EMSGSIZE;
@@ -790,7 +794,11 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, res->id))
 		goto err;
 
-	if (!rdma_is_kernel_res(res) &&
+	/*
+	 * uobject is NULL for kernel resources; context is NULL for
+	 * uobjects abandoned by the RDMA_REMOVE_DRIVER_FAILURE sweep
+	 */
+	if (pd->uobject && pd->uobject->context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			pd->uobject->context->res.id))
 		goto err;
-- 
2.27.0

