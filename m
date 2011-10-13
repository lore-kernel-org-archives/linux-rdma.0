From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Unblock reads on comp_channel
Date: Thu, 13 Oct 2011 11:12:50 -0500
Message-ID: <4E970E02.2090207@opengridcomputing.com>
References: <1318494090-9996-1-git-send-email-kumaras@chelsio.com> <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU9Ka7-sGVnCnobgQjoh7p2bsXbSLp-Fnn6aA1Q9of36w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/13/2011 11:01 AM, Roland Dreier wrote:
> Would this generate a completion event even if no completion entries are queued?
>

I guess it can if the QP has no WRs posted at all.

> Maybe I'm misunderstanding, but this sounds like a bandaid for broken
> applications,
> and a bandaid that other hardware drivers won't implement.
>

I'm not sure other drivers have this issue.  For example, when a mlx or mthca QP moves out of RTS, does the HW flush the 
pending recv WRs?  For Chelsio devices, the provider driver/library must handle this.

This logic is needed to adhere to the iwarp verbs spec which states that when the QP moves out of RTS, all WRs that are 
pending get completed with FLUSH status.  For T3/T4 devices, this is all done in software.  For user mode, the provider 
library has to flush the QP (IE the kernel doesn't own the queue state).

The idea is that if an application is expecting a CQ event notification when the QP moves out of RTS, and there are only 
recv wrs posted, then the T4 (and T3 does this too) driver must post this CQ notification, in addition to marking the CQ 
as "in error" which means some QP bound to this CQ needs flushing.  Then when the app wakes up and polls the CQ, the 
libcxgb4 code will flush the QPs in error and thus CQEs will be inserted into the CQ.  We have seen certain applications 
that rely on this event to discover that a QP has moved out of RTS.  IE they don't look at async QP events nor RDMACM 
events.



Steve.



> On Thu, Oct 13, 2011 at 1:21 AM, Kumar Sanghvi<kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>  wrote:
>> At the time when peer closes connection, iw_cxgb4 will not
>> send a cq event if ibqp.uobject exists. In that case, its possible
>> for user application to get blocked in ibv_get_cq_event.
>>
>> To resolve this, call the cq's comp_handler to unblock any read
>> from ibv_get_cq_event.
>>
>> Signed-off-by: Kumar Sanghvi<kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/cxgb4/qp.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
>> index ec3ce67..b59b56c 100644
>> --- a/drivers/infiniband/hw/cxgb4/qp.c
>> +++ b/drivers/infiniband/hw/cxgb4/qp.c
>> @@ -970,8 +970,12 @@ static void flush_qp(struct c4iw_qp *qhp)
>>         if (qhp->ibqp.uobject) {
>>                 t4_set_wq_in_error(&qhp->wq);
>>                 t4_set_cq_in_error(&rchp->cq);
>> -               if (schp != rchp)
>> +               (*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
>> +               if (schp != rchp) {
>>                         t4_set_cq_in_error(&schp->cq);
>> +                       (*schp->ibcq.comp_handler)(&schp->ibcq,
>> +                                       schp->ibcq.cq_context);
>> +               }
>>                 return;
>>         }
>>         __flush_qp(qhp, rchp, schp);
>> --
>> 1.7.1
>>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
