From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix rb-tree duplicate free and
 use-after-free
Date: Thu, 15 Oct 2015 18:15:21 +0300
Message-ID: <561FC309.2030102@mellanox.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734333@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9734333-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 10/12/2015 7:37 PM, Hefty, Sean wrote:
>> ib_send_cm_sidr_rep could sometimes erase the node from the sidr
>> (depending on errors in the process). Since ib_send_cm_sidr_rep is
>> called both from cm_sidr_req_handler and cm_destroy_id, cm_id_priv
>
> This should clarify that it is the app calling from the callback, and not a direct call from the cm_sidr_req_handler.
>

Consider the following error flows:

Double free:
cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep:3233->erase_rb 
 
cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->ib_send_cm_sidr_rep:3233->erase_rb

RB contains free node:
cm_sidr_req_handler:3156->cm_reject_sidr_req:663->ib_send_cm_sidr_rep->returns 
error(for example cm_alloc_msg,3219)
 
cm_sidr_req_handler:3173->ib_destroy_cm_id->cm_destroy_id:846->cm_reject_sidr_req->cm_reject_sidr_req:663->returns
error(for example cm_alloc_msg,3219)->RB wasn't erased but memory is 
freed :910 kfree(cm_id_priv)


>> could be either erased from the rb_tree twice or not erased at all.
>
> In an error case, I can see why it would be left in the rbtree, but I don't see how it can be removed twice.
>
>
>> Fixing that by making sure it's erased only once before freeing
>> cm_id_priv.
>>
>> Fixes: a977049dacde ('[PATCH] IB: Add the kernel CM implementation')
>> Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>
>> Hi Doug,
>> This patch fixes a bug in the CM. In some flow, rb-tree could be
>> freed twice or used after it was freed. This bug was picked by
>> our regression tests and this fix was verified.
>>
>> Thanks,
>> Doron and Matan
>>
>>   drivers/infiniband/core/cm.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index f5cf1c4..56ff0f3 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -844,6 +844,11 @@ retest:
>>   	case IB_CM_SIDR_REQ_RCVD:
>>   		spin_unlock_irq(&cm_id_priv->lock);
>>   		cm_reject_sidr_req(cm_id_priv, IB_SIDR_REJECT);
>> +		spin_lock_irq(&cm.lock);
>> +		if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node))
>> +			rb_erase(&cm_id_priv->sidr_id_node,
>> +				 &cm.remote_sidr_table);
>> +		spin_unlock_irq(&cm.lock);

This change seeks to remove the about to be freed node from the rb tree, 
while verifying it has not been freed already

>
> We should be able to use a return value from cm_reject_sidr_req() -- passed through from ib_send_cm_sidr_rep() to determine if the id was removed from the tree.
>

But this won't protect from double free in ib_send_cm_sidr_rep, unless 
we pass this parameter to the cm destroy function, but this alternative 
is cumbersome.

>>   		break;
>>   	case IB_CM_REQ_SENT:
>>   	case IB_CM_MRA_REQ_RCVD:
>> @@ -3210,7 +3215,10 @@ int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
>>   	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
>>
>>   	spin_lock_irqsave(&cm.lock, flags);
>> -	rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
>> +	if (!RB_EMPTY_NODE(&cm_id_priv->sidr_id_node)) {
>> +		rb_erase(&cm_id_priv->sidr_id_node, &cm.remote_sidr_table);
>> +		RB_CLEAR_NODE(&cm_id_priv->sidr_id_node);
>> +	}

This change protects against double free

>>   	spin_unlock_irqrestore(&cm.lock, flags);
>
> Something is very wrong in this function if the id is not in the tree at this point.
>

We agree, but there's an error flow that triggers this behavior.

Regards,
Matan and Doron.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
