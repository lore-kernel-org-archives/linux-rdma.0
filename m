From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/9] IB/core: Allow QP state transition from reset
 to error
Date: Mon, 29 May 2017 17:20:53 -0700
Message-ID: <20170530002032.534.25061.stgit@scvm10.sc.intel.com>
References: <20170530000314.534.72983.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530000314.534.72983.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Playing with IP-O-IB interface can trigger a warning message:
"ib0: Failed to modify QP to ERROR state" to be logged.
This happens when the QP is in IB_QPS_RESET state and the stack
is trying to transition it to IB_QPS_ERR state in ipoib_ib_dev_stop().

According to the IB spec, Table 91 - "QP State Transition Properties"
it looks like the transition from reset to error is valid:

Transition: Any State to Error
Required Attributes: None
Optional Attributes: None allowed
Actions: Queue processing is stopped. Work Requests pending or in
process are completed in error, when possible.

This patch allows the transition and quiets the message.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f52..b822bed 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -872,6 +872,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 	[IB_QPS_RESET] = {
 		[IB_QPS_RESET] = { .valid = 1 },
+		[IB_QPS_ERR] =   { .valid = 1 },
 		[IB_QPS_INIT]  = {
 			.valid = 1,
 			.req_param = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
