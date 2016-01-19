From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/8] IB/rdmavt: Add post send to rdmavt
Date: Tue, 19 Jan 2016 13:46:37 -0500
Message-ID: <20160119184636.GA29112@phlsvsds.ph.intel.com>
References: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com> <20160109150007.8585.76575.stgit@scvm10.sc.intel.com> <CAG9sBKOpDfxOaPU+dJ+M42JrbCVEoNAORi8jk1KJLay-KDhSSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKOpDfxOaPU+dJ+M42JrbCVEoNAORi8jk1KJLay-KDhSSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 19, 2016 at 06:23:14PM +0200, Moni Shoua wrote:
>> @@ -730,20 +863,46 @@ int rvt_post_recv(struct ib_qp *ibqp, struct 
>> ib_recv_wr *wr,
>>  int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>>                   struct ib_send_wr **bad_wr)
>>  {
>> +       struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
>> +       struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
>> +       unsigned long flags = 0;
>> +       int call_send;
>> +       unsigned nreq = 0;
>> +       int err = 0;
>> +
>> +       spin_lock_irqsave(&qp->s_lock, flags);
>> +
>>         /*
>> -        * VT-DRIVER-API: do_send()
>> -        * Driver needs to have a do_send() call which is a single entry point
>> -        * to take an already formed packet and throw it out on the wire. Once
>> -        * the packet is sent the driver needs to make an upcall to rvt so the
>> -        * completion queue can be notified and/or any other outstanding
>> -        * work/book keeping can be finished.
>Why was this design for do_send() removed?
>This requires that each low level drivers do the packet formatting by
>themselves --> code duplication.

The packet building is still being done in the drivers right now. While the 
code is similar between the existing drivers there are hardware specific 
aspects which are critical to performance which will need untangled very 
carefully.  We do plan to move this stuff into rdmavt as well. However, I 
think it makes sense to let this initial cut of rdmavt get some soak time 
given the scope of the changes. So this would be a next step in the 
iterative development.

>> +bail:
>> +       if (nreq && !call_send)
>> +               rdi->driver_f.schedule_send(qp);
>> +       spin_unlock_irqrestore(&qp->s_lock, flags);
>> +       if (nreq && call_send)
>> +               rdi->driver_f.do_send(qp);
>> +       return err;
>>  }
>Wouldn't it be better if scheduling for sending packets be done in RVT?

The progress mechanism is probably a device specific thing. One 
implementation may use work queues, another, something else. For this reason 
we leave it down in the driver. Rdmavt has the two driver calls shown here, 
one to tell the driver to schedule a packet for sending based on whatever 
it's policy is. The other is to kick the driver to do a send right away, for 
performance reasons.

>>  /**
>> diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
>> index f2d50b9..3d92239 100644
>> --- a/include/rdma/rdma_vt.h
>> +++ b/include/rdma/rdma_vt.h
>> @@ -230,6 +230,8 @@ struct rvt_driver_provided {
>>         void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
>>         void (*qp_priv_free)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
>>         void (*notify_qp_reset)(struct rvt_qp *qp);
>> +       void (*schedule_send)(struct rvt_qp *qp);
>> +       void (*do_send)(struct rvt_qp *qp);
>A proper explanation about the meaning for each driver provided
>function is required.
>This is true for the 2 new added function and for any other that was
>already there

Agree. I'll perhaps add another patch which cleans up these and other 
comments. Make sure it all makes sense as a number of the original comments 
were put in place to get the ball rolling and stimulate discussion.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
