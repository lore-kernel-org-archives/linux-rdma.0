From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 04/15] IB/srp: Fail I/O fast if target offline
Date: Mon, 01 Jul 2013 13:53:04 +0200
Message-ID: <51D16DA0.7070206@profitbricks.com>
References: <51CD856A.3010102@acm.org> <51CD8676.6080205@acm.org> <51D146EE.6010209@profitbricks.com> <51D16918.60600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D16918.60600-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01.07.2013 13:33, Bart Van Assche wrote:
>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>> @@ -1755,6 +1755,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>>>       if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>>>                     SRP_TSK_ABORT_TASK) == 0)
>>>           ret = SUCCESS;
>>> +    else if (target->transport_offline)
>>> +        ret = FAST_IO_FAIL;
>>>       else
>>>           ret = FAILED;
>>>       srp_free_req(target, req, scmnd, 0);
>>>
>>
>> This doesn't give us much speed advantage IMHO. The check for
>> target->transport_offline should be before calling srp_send_tsk_mgmt().
>>
>> This way it would also match the patch description better.
> 
> Hello Sebastian,
> 
> Had you perhaps overlooked the following code at the start of
> srp_send_tsk_mgmt() ?
> 
>     if (!target->connected || target->qp_in_error)
>         return -1;
> 
> Given this I don't think it matters whether the transport_offline check
> occurs before or after the srp_send_tsk_mgmt() call.

Hi Bart,

okay, right. So you get an error due to the connected and qp_in_error
state first. Yes, I've overlooked that. Thanks!

Cheers,
Sebastian

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
