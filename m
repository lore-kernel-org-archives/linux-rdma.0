From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 04/15] IB/srp: Fail I/O fast if target offline
Date: Mon, 01 Jul 2013 14:57:52 +0200
Message-ID: <51D17CD0.5050707@acm.org>
References: <51CD856A.3010102@acm.org> <51CD8676.6080205@acm.org> <51D14AF1.4000803@profitbricks.com> <51D16A39.4050709@acm.org> <51D176B5.90609@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D176B5.90609-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/01/13 14:31, Sebastian Riemer wrote:
> On 01.07.2013 13:38, Bart Van Assche wrote:
>>>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>>> @@ -1755,6 +1755,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>>>>        if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>>>>                      SRP_TSK_ABORT_TASK) == 0)
>>>>            ret = SUCCESS;
>>>> +    else if (target->transport_offline)
>>>> +        ret = FAST_IO_FAIL;
>>>>        else
>>>>            ret = FAILED;
>>>>        srp_free_req(target, req, scmnd, 0);
>>>
>>> I'm also missing the concept for srp_reset_device(). There is a very
>>> common case that the SCSI error handling and the transport layer error
>>> handling run in parallel: Congestion.
>>
>> Can you explain this comment further, and also how this comment relates
>> to patch 04/15 ?
>
> Sorry, found it. Even if only one srp_reset_device() fails, then
> srp_reset_host() is called anyway. So there this check + returning
> FAST_IO_FAIL doesn't make so much sense.

Hello Sebastian,

I agree that if one or more srp_abort() calls return FAILED that 
srp_reset_host() will be called anyway. However, this patch helps if the 
first call of srp_abort() occurs after a reconnect failure, which is 
likely with the default reconnnect_delay and SCSI timeout settings. In 
that case all srp_abort() calls will return FAST_IO_FAIL, 
scsi_eh_abort_cmds() will terminate the pending commands and hence the 
host reset will be skipped.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
