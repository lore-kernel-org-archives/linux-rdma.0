From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libcxgb4 1/2] kernel abi: adds explicit padding in struct c4iw_create_cq_resp
Date: Sun,  4 May 2014 23:31:51 +0200
Message-ID: <85f6638383276563046cdf45daa81a19ac4c621e.1399235229.git.ydroneaud@opteya.com>
References: <cover.1399235229.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> <cover.1399235229.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

i386 ABI disagree with most other ABIs regarding alignment
of data type larger than 4 bytes: on most ABIs a padding must
be added at end of the structures, while it is not required
on i386.

Such ABI disagreement will make an x86_64 kernel try to write past
the struct c4iw_create_cq_resp buffer provided by an i386
userspace binary. As struct c4iw_create_cq_resp is likely
on stack, see function c4iw_create_cq(), side effects are
expected.

On kernel side, this structure was added for kernel v2.6.35-rc1
by following commit.

  Commit cfdda9d764362ab77b11a410bb928400e6520d57
  Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
  Date:   Wed Apr 21 15:30:06 2010 -0700

      RDMA/cxgb4: Add driver for Chelsio T4 RNIC

If boundary check is implemented on kernel side, the x86_64 kernel
will refuse to write past the i386 userspace provided buffer and the
uverbs will fail.

To fix these issues, this patch adds an explicit padding at end
of structure so that i386 and others ABI share the same structure
layout. This patch makes c4iw_create_cq() check for a value in the
padding field to detect newer kernel using the field for a future
purpose (only activated in debug).

With this patch, libcxgb4 will work against older kernel and
newer patched kernel.

Link: http://marc.info/?i=cover.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cxgb4-abi.h | 1 +
 src/verbs.c     | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/src/cxgb4-abi.h b/src/cxgb4-abi.h
index d70b0f132a7f..23870f66dc0d 100644
--- a/src/cxgb4-abi.h
+++ b/src/cxgb4-abi.h
@@ -53,6 +53,7 @@ struct c4iw_create_cq_resp {
 	__u32 cqid;
 	__u32 size;
 	__u32 qid_mask;
+	__u32 reserved;
 };
 
 enum {
diff --git a/src/verbs.c b/src/verbs.c
index ab4a45d7cdbc..4a6c1b47bc9e 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -181,12 +181,17 @@ struct ibv_cq *c4iw_create_cq(struct ibv_context *context, int cqe,
 		return NULL;
 	}
 
+	resp.reserved = 0;
 	ret = ibv_cmd_create_cq(context, cqe, channel, comp_vector,
 				&chp->ibv_cq, &cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof resp);
 	if (ret)
 		goto err1;
 
+	if (resp.reserved)
+		PDBG("%s c4iw_create_cq_resp reserved field modified by kernel\n",
+		     __FUNCTION__);
+
 	pthread_spin_init(&chp->lock, PTHREAD_PROCESS_PRIVATE);
 #ifdef STALL_DETECTION
 	gettimeofday(&chp->time, NULL);
-- 
1.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
