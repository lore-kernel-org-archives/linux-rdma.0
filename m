From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 06/15] IB/srpt: Simplify srpt_handle_tsk_mgmt()
Date: Tue, 26 Jan 2016 10:46:59 -0800
Message-ID: <56A7BF23.1060306@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD1D2.1030609@sandisk.com>
 <F3529576D8E232409F431C309E29399328F6B06A@CRSMSX102.amr.corp.intel.com>
 <56A7ADA3.5080507@sandisk.com>
 <F3529576D8E232409F431C309E29399328F6B0C3@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F3529576D8E232409F431C309E29399328F6B0C3-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/26/16 10:35, Estrin, Alex wrote:
>> Thank you for the feedback. Since the kernel 4.5 merge has been closed I
>> will retest and resend the whole patch series.
> 
> Bart,
> 
> In this case I would suggest to extend the patch by removing
> this unlikely check, since it is also taken care of in target:
> 
> @@ -1843,25 +1801,10 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
>          srpt_set_cmd_state(send_ioctx, SRPT_STATE_MGMT);
>          send_ioctx->tag = srp_tsk->tag;
>          tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
> -       if (tcm_tmr < 0) {
> -               send_ioctx->cmd.se_tmr_req->response =
> -                       TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
> -               goto fail;
> -       }

Hello Alex,

How about introducing a symbolic constant for unrecognized task management
functions, e.g. as in the below variant of your patch ?

---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 7 +------
 include/target/target_core_base.h     | 1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 21cdb7e..352dd87 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1595,7 +1595,7 @@ static int srp_tmr_to_tcm(int fn)
 	case SRP_TSK_CLEAR_ACA:
 		return TMR_CLEAR_ACA;
 	default:
-		return -1;
+		return UNKNOWN_TMR;
 	}
 }
 
@@ -1629,11 +1629,6 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 	srpt_set_cmd_state(send_ioctx, SRPT_STATE_MGMT);
 	send_ioctx->cmd.tag = srp_tsk->tag;
 	tcm_tmr = srp_tmr_to_tcm(srp_tsk->tsk_mgmt_func);
-	if (tcm_tmr < 0) {
-		send_ioctx->cmd.se_tmr_req->response =
-			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
-		goto fail;
-	}
 	rc = target_submit_tmr(&send_ioctx->cmd, sess, NULL,
 			       scsilun_to_int(&srp_tsk->lun), srp_tsk, tcm_tmr,
 			       GFP_KERNEL, srp_tsk->task_tag,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ec2ddbf..2fb005a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -192,6 +192,7 @@ enum target_sc_flags_table {
 
 /* fabric independent task management function values */
 enum tcm_tmreq_table {
+	UNKNOWN_TMR		= -1,
 	TMR_ABORT_TASK		= 1,
 	TMR_ABORT_TASK_SET	= 2,
 	TMR_CLEAR_ACA		= 3,
-- 
2.7.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
