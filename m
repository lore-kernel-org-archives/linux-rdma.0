From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 03/14] IB/srp: Avoid that srp_reset_host() is skipped
 after a TL error
Date: Thu, 13 Jun 2013 11:57:07 +0200
Message-ID: <51B99773.8020104@acm.org>
References: <51B87501.4070005@acm.org> <51B87638.50102@acm.org> <51B99120.9000503@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B99120.9000503-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/13/13 11:30, Sebastian Riemer wrote:
> On 12.06.2013 15:23, Bart Van Assche wrote:
>> The SCSI error handler assumes that the transport layer is
>> operational if an eh_abort_handler() returns SUCCESS. Hence let
>> srp_abort() only return SUCCESS if sending the ABORT TASK task
>> management function succeeded. This patch avoids that the SCSI
>> error handler skips the srp_reset_host() call after a transport
>> layer error.
>>
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
>> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c |   11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 9c638dd..fb37b47 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -1742,18 +1742,23 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>>   {
>>   	struct srp_target_port *target = host_to_target(scmnd->device->host);
>>   	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
>> +	int ret;
>>
>>   	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
>>
>>   	if (!req || !srp_claim_req(target, req, scmnd))
>>   		return FAILED;
>> -	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>> -			  SRP_TSK_ABORT_TASK);
>> +	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>> +			      SRP_TSK_ABORT_TASK) == 0 ||
>> +	    target->transport_offline)
>> +		ret = SUCCESS;
>
> Here you try to hide a little trick. Returning success upon
> (target->transport_offline == true) is perhaps not the best way. I guess
> you try to fail IO fast here but up to this point
> "target->transport_offline = true" is only set in srp_reset_host().
>
> Please explain for what you need that in this patch!
>
> Furthermore, returning "FAST_IO_FAIL" sounds better to me in this situation.

Hello Sebastian,

Sorry, forgot to explain that bit in the patch description. The purpose 
of the "transport_offline" test is indeed to fail I/O fast in case no IB 
RC connection to the target is available. You suggestion to return 
FAST_IO_FAIL in that case makes sense to me. I will move that change to 
a separate patch.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
