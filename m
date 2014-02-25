From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Tue, 25 Feb 2014 11:33:25 +0100
Message-ID: <530C7175.5060907@acm.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>		 <1392954937.26557.3.camel@haswell.thedillows.org>		 <53071B2E.2050302@acm.org>	 <1393047697.12377.11.camel@haswell.thedillows.org>	 <530BA476.7040005@acm.org> <1393302995.9096.1.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393302995.9096.1.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/25/14 05:36, David Dillow wrote:
> On Mon, 2014-02-24 at 20:58 +0100, Bart Van Assche wrote:
>> On 02/22/14 06:41, David Dillow wrote:
>>> I didn't suggest that -- I'm saying add a common functionality to turn
>>> on/off the message printing for commands that failed due to a dead
>>> transport. If it is useful for SRP initiators, it is probably useful for
>>> SAS and iSCSI imitators as well.
>>>
>>> At a quick look, it seems you need to add a new value to the
>>> rq_flag_bits enum in include/linux/blk_types.h, __REQ_FAILED_TRANSPORT,
>>> somewhere before __REQ_NR_BITS. And a #define in the style of those
>>> following it. Use that flag instead of REQ_QUIET in the patch we are
>>> discussing, and change the code in scsi_lib.c to check
>>>
>>>   ((req->cmd_flags & REQ_FAILED_TRANSPORT) && $user_wants_this_knob) || !(req->cmd_flags & REQ_QUIET)
>>>
>>> before calling scsi_print_sense(), with appropriate naming, of course.
>>> This gives you a central place to control it, and allows for consistency
>>> between initiators.
>>>
>>> I agree it is much easier to just fix it in SRP, especially given the
>>> glacial rate of change for the SCSI mid-layer, but I really think a
>>> central control and driver-by-driver enablement would be the best
>>> approach. YMMV.
>>
>> That makes sense to me. Do you think the (untested) patch below could
>> be a valid alternative to the above proposal ?
> 
> I'd still like to see a knob to let the user turn it off -- sometimes
> you want to see those messages -- but it seems like a viable approach,
> especially if it works when you test it :)
> 
> I'll leave to others about how important that knob is, though. If no one
> else barks, then it should be OK.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 7bd7f0d..124ab53 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -857,7 +857,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>  		 */
>>  		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
>>  			;
>> -		else if (!(req->cmd_flags & REQ_QUIET))
>> +		else if (cmd->device->sdev_state != SDEV_TRANSPORT_OFFLINE &&
>> +			 !(req->cmd_flags & REQ_QUIET))
>>  			scsi_print_sense("", cmd);
>>  		result = 0;
>>  		/* BLOCK_PC may have set error */

Hello Dave,

Testing learned me that the above patch suppresses the messages reported
by the SCSI mid-layer due to a transport failure but not the messages
reported by the block layer (e.g. "end_request: recoverable transport
error, dev sdc, sector 42514" -- see also blk_update_request() in
block/blk-core.c). Do you really think it is essential to introduce a
new flag in the block layer for the purpose of suppressing transport
layer error messages and to add support for that flag in the block core
and in the SCSI mid-layer ? To me it seems a lot simpler to use the
existing REQ_QUIET flag.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
