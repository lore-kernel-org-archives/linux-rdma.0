From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 13/15] IB/rxe: Fix reference leaks in memory key invalidation code
Date: Tue, 10 Jan 2017 11:08:20 -0800
Message-ID: <20170110190822.16953-14-bart.vanassche@sandisk.com>
References: <20170110190822.16953-1-bart.vanassche@sandisk.com>
 <20170110190822.16953-2-bart.vanassche@sandisk.com>
 <20170110190822.16953-3-bart.vanassche@sandisk.com>
 <20170110190822.16953-4-bart.vanassche@sandisk.com>
 <20170110190822.16953-5-bart.vanassche@sandisk.com>
 <20170110190822.16953-6-bart.vanassche@sandisk.com>
 <20170110190822.16953-7-bart.vanassche@sandisk.com>
 <20170110190822.16953-8-bart.vanassche@sandisk.com>
 <20170110190822.16953-9-bart.vanassche@sandisk.com>
 <20170110190822.16953-10-bart.vanassche@sandisk.com>
 <20170110190822.16953-11-bart.vanassche@sandisk.com>
 <20170110190822.16953-12-bart.vanassche@sandisk.com>
 <20170110190822.16953-13-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110190822.16953-13-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c  | 1 +
 drivers/infiniband/sw/rxe/rxe_resp.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index d62be4828899..512e74326b16 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -635,6 +635,7 @@ int rxe_requester(void *arg)
 				goto exit;
 			}
 			rmr->state = RXE_MEM_STATE_FREE;
+			rxe_drop_ref(rmr);
 			wqe->state = wqe_state_done;
 			wqe->status = IB_WC_SUCCESS;
 		} else if (wqe->wr.opcode == IB_WR_REG_MR) {
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 60d78f45aa04..05f374986cea 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -907,6 +907,7 @@ static enum resp_states do_complete(struct rxe_qp *qp,
 					return RESPST_ERROR;
 				}
 				rmr->state = RXE_MEM_STATE_FREE;
+				rxe_drop_ref(rmr);
 			}
 
 			wc->qp			= &qp->ibqp;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
