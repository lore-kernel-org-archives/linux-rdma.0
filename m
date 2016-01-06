From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 13/15] IB/srpt: Detect session shutdown reliably
Date: Wed, 6 Jan 2016 14:34:40 +0100
Message-ID: <568D17F0.4080804@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD2A9.6070600@sandisk.com>
 <20160106052138.GM15574@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106052138.GM15574-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/06/2016 06:21 AM, Christoph Hellwig wrote:
> On Tue, Jan 05, 2016 at 03:26:49PM +0100, Bart Van Assche wrote:
>> The Last WQE Reached event is only generated after one or more work
>> requests have been queued on the QP associated with a session. Since
>> session shutdown can start before any work requests have been queued,
>> use a zero-length RDMA write to wait until a QP has been drained.
>
> We actually ran into the same issue with a SRPT-derived work in progress
> driver recently..
>
>> @@ -2314,14 +2346,13 @@ static void srpt_cm_timewait_exit(struct srpt_rdma_ch *ch)
>>   {
>>   	pr_info("Received CM TimeWait exit for ch %s-%d.\n", ch->sess_name,
>>   		ch->qp->qp_num);
>> +	srpt_close_ch(ch);
>>   }
>>
>>   static void srpt_cm_rep_error(struct srpt_rdma_ch *ch)
>>   {
>>   	pr_info("Received CM REP error for ch %s-%d.\n", ch->sess_name,
>>   		ch->qp->qp_num);
>>   }
>>
>>   /**
>> @@ -2329,33 +2360,7 @@ static void srpt_cm_rep_error(struct srpt_rdma_ch *ch)
>>    */
>>   static void srpt_cm_dreq_recv(struct srpt_rdma_ch *ch)
>>   {
>> +	srpt_disconnect_ch(ch);
>>   }
>>
>>   /**
>> @@ -2364,7 +2369,7 @@ static void srpt_cm_dreq_recv(struct srpt_rdma_ch *ch)
>>   static void srpt_cm_drep_recv(struct srpt_rdma_ch *ch)
>>   {
>>   	pr_info("Received InfiniBand DREP message for cm_id %p.\n", ch->cm_id);
>> +	srpt_close_ch(ch);
>>   }
>
>
> Is there any good reason to keep these one-liner helpers around?

Hello Christoph,

Not really. I will inline these functions.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
