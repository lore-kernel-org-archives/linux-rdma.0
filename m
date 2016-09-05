From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 28/28] Avoid gcc warning -Wpointer-to-int-cast
Date: Mon,  5 Sep 2016 15:08:18 -0600
Message-ID: <1473109698-31408-29-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In C99 casting a pointer to an integer should always be done via
uintptr_t.

When compiling on 32 bit all these sites produce warnings.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpm/src/iwarp_pm_helper.c  | 2 +-
 libhfi1verbs/src/verbs.c    | 2 +-
 libi40iw/src/i40iw_uverbs.c | 2 +-
 libipathverbs/src/verbs.c   | 2 +-
 librdmacm/src/rsocket.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/iwpm/src/iwarp_pm_helper.c b/iwpm/src/iwarp_pm_helper.c
index f5c7b96a22e1..89d2b6cef5e6 100644
--- a/iwpm/src/iwarp_pm_helper.c
+++ b/iwpm/src/iwarp_pm_helper.c
@@ -82,7 +82,7 @@ iwpm_mapping_request *create_iwpm_map_request(struct nlmsghdr *req_nlh,
 	/* assochandle helps match iwpm request sent to remote peer with future iwpm accept/reject */
 	iwpm_map_req->assochandle = assochandle;
 	if (!assochandle)
-		iwpm_map_req->assochandle = (__u64)iwpm_map_req;
+		iwpm_map_req->assochandle = (uintptr_t)iwpm_map_req;
 
 	memcpy(&iwpm_map_req->src_addr, src_addr, sizeof(struct sockaddr_storage));
 	/* keep record of remote IP address and port */
diff --git a/libhfi1verbs/src/verbs.c b/libhfi1verbs/src/verbs.c
index 854c5676908d..e245ad9e5b4f 100644
--- a/libhfi1verbs/src/verbs.c
+++ b/libhfi1verbs/src/verbs.c
@@ -607,7 +607,7 @@ int hfi1_modify_srq(struct ibv_srq *ibsrq,
 			 (sizeof(struct ibv_sge) * srq->rq.max_sge)) *
 			srq->rq.size;
 	}
-	cmd.offset_addr = (__u64) &offset;
+	cmd.offset_addr = (uintptr_t) &offset;
 	ret = ibv_cmd_modify_srq(ibsrq, attr, attr_mask,
 				 &cmd.ibv_cmd, sizeof cmd);
 	if (ret) {
diff --git a/libi40iw/src/i40iw_uverbs.c b/libi40iw/src/i40iw_uverbs.c
index db69b66c1e90..8369e10f61ee 100644
--- a/libi40iw/src/i40iw_uverbs.c
+++ b/libi40iw/src/i40iw_uverbs.c
@@ -557,7 +557,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 		return 0;
 	}
 	cmd.user_wqe_buffers = (__u64)((uintptr_t)info->sq);
-	cmd.user_compl_ctx = (u64)&iwuqp->qp;
+	cmd.user_compl_ctx = (uintptr_t)&iwuqp->qp;
 
 	ret = ibv_cmd_create_qp(pd, &iwuqp->ibv_qp, attr, &cmd.ibv_cmd, sizeof(cmd),
 				&resp->ibv_resp, sizeof(struct i40iw_ucreate_qp_resp));
diff --git a/libipathverbs/src/verbs.c b/libipathverbs/src/verbs.c
index 17d54cd4026b..578a38af3428 100644
--- a/libipathverbs/src/verbs.c
+++ b/libipathverbs/src/verbs.c
@@ -583,7 +583,7 @@ int ipath_modify_srq(struct ibv_srq *ibsrq,
 			 (sizeof(struct ibv_sge) * srq->rq.max_sge)) *
 			srq->rq.size;
 	}
-	cmd.offset_addr = (__u64) &offset;
+	cmd.offset_addr = (uintptr_t) &offset;
 	ret = ibv_cmd_modify_srq(ibsrq, attr, attr_mask,
 				 &cmd.ibv_cmd, sizeof cmd);
 	if (ret) {
diff --git a/librdmacm/src/rsocket.c b/librdmacm/src/rsocket.c
index 5645f40d2460..205101f1702f 100644
--- a/librdmacm/src/rsocket.c
+++ b/librdmacm/src/rsocket.c
@@ -4290,7 +4290,7 @@ static void tcp_svc_send_keepalive(struct rsocket *rs)
 	if (rs_ctrl_avail(rs) && (rs->state & rs_connected)) {
 		rs->ctrl_seqno++;
 		rs_post_write(rs, NULL, 0, rs_msg_set(RS_OP_CTRL, RS_CTRL_KEEPALIVE),
-			      0, (uint64_t) NULL, (uint64_t) NULL);
+			      0, (uintptr_t) NULL, (uintptr_t) NULL);
 	}
 	fastlock_release(&rs->cq_lock);
 }	
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
