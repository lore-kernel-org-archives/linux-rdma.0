From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/8] infiniband: fix ulp/srpt/ib_srpt.c kernel-doc
 notation
Date: Fri, 5 Jan 2018 21:55:32 -0800
Message-ID: <31f69352-b8b1-9ed1-635b-2c654b49c775@infradead.org>
References: <5a5016c0.4c0a620a.ed2b3.60da@mx.google.com>
 <fcc3f226-848d-abc4-2a81-f4fd821761c9@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fcc3f226-848d-abc4-2a81-f4fd821761c9-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 01/05/18 16:36, Bart Van Assche wrote:
> On 01/05/18 16:22, Randy Dunlap wrote:
>> Use correct parameter names in kernel-doc notation to eliminate
>> warnings from scripts/kernel-doc.
>>
>> ../drivers/infiniband/ulp/srpt/ib_srpt.c:1146: warning: Excess function parameter 'context' description in 'srpt_abort_cmd'
>> ../drivers/infiniband/ulp/srpt/ib_srpt.c:1482: warning: Excess function parameter 'ioctx' description in 'srpt_handle_new_iu'
>>
>> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>   drivers/infiniband/ulp/srpt/ib_srpt.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- linux-next-20171222.orig/drivers/infiniband/ulp/srpt/ib_srpt.c
>> +++ linux-next-20171222/drivers/infiniband/ulp/srpt/ib_srpt.c
>> @@ -1139,7 +1139,6 @@ static struct srpt_send_ioctx *srpt_get_
>>   /**
>>    * srpt_abort_cmd() - Abort a SCSI command.
>>    * @ioctx:   I/O context associated with the SCSI command.
>> - * @context: Preferred execution context.
>>    */
>>   static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
>>   {
>> @@ -1473,7 +1472,8 @@ fail:
>>   /**
>>    * srpt_handle_new_iu() - Process a newly received information unit.
>>    * @ch:    RDMA channel through which the information unit has been received.
>> - * @ioctx: SRPT I/O context associated with the information unit.
>> + * @recv_ioctx: SRPT I/O context associated with the receive information unit.
>> + * @send_ioctx: SRPT I/O context associated with the send information unit.
>>    */
>>   static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
>>                      struct srpt_recv_ioctx *recv_ioctx,
> 
> Please drop this patch. It conflicts with a patch series I'm working on.
> 

Sure, no problem.  Do you have this kernel-doc notation fixed, then?


-- 
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
