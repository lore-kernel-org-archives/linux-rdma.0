Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C4E19538D62;
	Thu, 17 Sep 2026 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652082; cv=none; b=qYNCVBpFsnxflvvV1KAzbvB17/v4SzpgVnH0wu/XUCoEzQFnfQoLJjrylaih6Sx/rUHz7N2aFhKDND2K0WPWTHxo/Lizv1mgvzX+48fhxjv87v+UyQiUAe0ySQpg7xKav+TvPdcsWUXIz73jb1drU7PWe8CbnSQKkgRNC8nJrWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652082; c=relaxed/simple;
	bh=ZTG7y0HY15eRjRgzwv9U7whPJMJ9kGJdXix9iFezd+U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hhqxZhTO8lUdauTKrRHpVCPUOW/qPDKybKXOPr5nPuTq6tcGg3JdU1/neEGmwComYjWQOvFI5yhtWDJquYQaFHDLOj8ZwGnAzqRzJEMaTCfnwJHgKvMgTYMUE/cDI0yPWlwpPfEeUfFQY8TGlj6p7OfTPCpqmAJNnU5O53QrL8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=CFGGFYcd; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="CFGGFYcd"
X-MD-Sfrom: zhangyili01@baidu.com
X-MD-SrcIP: 172.31.51.15
From: Yili Zhang <zhangyili01@baidu.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yili Zhang
	<zhangyili01@baidu.com>
Subject: [PATCH v2] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
Date: Thu, 17 Sep 2026 21:33:40 +0800
Message-ID: <20260917133340.42002-1-zhangyili01@baidu.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc14.internal.baidu.com (172.31.4.12) To
 BJKJY-Exc19.internal.baidu.com (172.31.51.15)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1789652055;
	bh=HFYYlv2XHPNG8YPTtFJDLDnwIh6oqIUKTVISqtVSXyA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=CFGGFYcd+2r/q5Dp2ukNbYqCCR26gvrq3BIkqMtZUlE6qRiZDlzifeCCemRAKJEbR
	 v1+sxblYvNBGXXguimBZX4WHjlD6yUJNY+bGs5aSA+StuytqY1aOuDzd31MH5Khhcz
	 SikrXpILRq/HyfWkJFFvmri6YkpXbzvCMKfhewY7JdozuPNI1whXpF9Ho+D61jnWJb
	 e8uvsddV2zoSRjbR43M0NBf4TxmhS3YSktlhqwguJtelsNgjucg77pwmoaoaZP6H9Q
	 b/E270xZR0TkKSlw4hlKaNbMyigDWNL2KDR8HU389SNCc8KMPpoYBo/rXxXwH+BMqA
	 TzBkWSqCd/6nQ==

fill_res_cq_entry() dereferences
cq->uobject->uevent.uobject.context->res.id unconditionally for user
resources.

This is normally safe by ordering: destroy_hw() removes the resource
from the restrack before uverbs_destroy_uobject() clears ->context,
and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
the entry from concurrent netlink dumps.

The ordering breaks when a driver keeps failing to destroy an object
during ucontext teardown. uverbs_destroy_ufile_hw() then falls back
to __uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
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
never removes it from the restrack. Verified on v7.3-rc3, the
fallback path is unchanged, so the committed context == NULL state
is reachable on current mainline as well.

From the fallback until the device is unregistered, any "rdma res
show cq" deterministically takes the NULL pointer dereference; this
is a long-lived state, NOT A RACE. The dump path holds neither the
restrack lock (dropped before the fill callback runs) nor
ufile->hw_destroy_rwsem, and rdma_restrack_get() only guarantees
that the res memory stays alive, not that ->context is still valid.

Fix the dump side: add nla_put_res_ctxn() which checks the uobject
context and skips the RES_CTXN attribute for orphaned entries
instead of crashing. The orphaned resource itself remains visible
in "rdma res show" (cqn/cqe/usecnt/pid), which is what an operator
needs after the accompanying uverbs WARN to diagnose the driver
destroy failure.

fill_res_pd_entry() has the same pattern (pd->uobject->context->res.id)
and is fixed the same way; a PD can even reach the fallback without
its own driver callback failing, e.g. uverbs_free_pd() returns -EBUSY
while another object that failed to destroy still holds the PD usecnt.

Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP objects")
Link: https://lore.kernel.org/all/20260813000442.GI662699@ziepe.ca/
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
---
 drivers/infiniband/core/nldev.c | 34 +++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4e8fbee34745..497768d027d6 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -678,6 +678,34 @@ static int fill_res_cm_id_entry(struct sk_buff *msg, bool has_cap_net_admin,
 err: return -EMSGSIZE;
 }
 
+/*
+ * Emit RDMA_NLDEV_ATTR_RES_CTXN, the id of the ucontext owning this
+ * user resource.
+ *
+ * If the teardown of a ufile cannot destroy all of its uobjects (e.g.
+ * a driver destroy callback keeps failing), the cleanup falls back to
+ * the "driver failure" sweep (__uverbs_cleanup_ufile() with
+ * RDMA_REMOVE_DRIVER_FAILURE): every remaining object is abandoned
+ * in place, its HW object and restrack entry are intentionally leaked,
+ * while the uobject bookkeeping is torn down and ->context is cleared
+ * to NULL by uverbs_destroy_uobject().
+ *
+ * Such orphaned entries remain reachable by netlink dumps, so ->context
+ * must not be dereferenced unconditionally. Skip the attribute for
+ * orphans instead of crashing the dump.
+ *
+ */
+static int nla_put_res_ctxn(struct sk_buff *msg, struct ib_uobject *uobj)
+{
+	struct ib_ucontext *ucontext = uobj->context;
+
+	if (!ucontext)
+		return 0;
+
+	return nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
+			   ucontext->res.id);
+}
+
 static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			     struct rdma_restrack_entry *res, uint32_t port)
 {
@@ -701,8 +729,7 @@ static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQN, res->id))
 		return -EMSGSIZE;
 	if (!rdma_is_kernel_res(res) &&
-	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
-			cq->uobject->uevent.uobject.context->res.id))
+	    nla_put_res_ctxn(msg, &cq->uobject->uevent.uobject))
 		return -EMSGSIZE;
 
 	if (fill_res_name_pid(msg, res))
@@ -791,8 +818,7 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 		goto err;
 
 	if (!rdma_is_kernel_res(res) &&
-	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
-			pd->uobject->context->res.id))
+	    nla_put_res_ctxn(msg, pd->uobject))
 		goto err;
 
 	return fill_res_name_pid(msg, res);
-- 
2.27.0

