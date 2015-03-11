From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] iser-target: Handle errors from isert_put_datain and
 isert_get_dataout
Date: Wed, 11 Mar 2015 19:00:31 +0200
Message-ID: <550074AF.2030908@dev.mellanox.co.il>
References: <462EF229174FDB4D92ACE4656EA561005DD2BD41@CMEXMB1.ad.emulex.com>	 <54FA5F8B.1030003@dev.mellanox.co.il> <1425712747.22358.18.camel@haakon3.risingtidesystems.com> <54FB733F.2030304@dev.mellanox.co.il> <462EF229174FDB4D92ACE4656EA561005DD34C62@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <462EF229174FDB4D92ACE4656EA561005DD34C62-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel (target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2015 5:30 PM, Chris Moore wrote:
>> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> On 3/7/2015 9:19 AM, Nicholas A. Bellinger wrote:
>>> On Sat, 2015-03-07 at 04:16 +0200, Sagi Grimberg wrote:
>>>> On 3/6/2015 7:56 PM, Chris Moore wrote:
>>>>> isert_put_datain() always returns 1 and isert_get_dataout() always
>> returns 0, even if
>>>>> ib_post_send() fails.   They should return an error in this case so the
>> caller can handle it.
>>>>> Also, in the case of an ib_post_send() failure, user isert_err instead of
>> isert_warn.
>>>>>
>>>>> With these changes, these two functions handle errors from
>>>>> ib_post_send() in the same way as other functions within ib_isert.c
>>>>>
>>>>
>>>> Hi Chris,
>>>>
>>>> This is indeed needed, but I'm afraid this is not complete given the
>>>> rc is completely ignored by the callers (see
>>>> lio_queue_data_in/lio_write_pending).
>>>>
>>>
>>> So lio_write_pending() is propagating up the return back to
>>> transport_generic_new_cmd().  When the return is -EAGAIN or -ENOMEM,
>>> it triggers transport_handle_queue_full() to retry ->write_pending()
>>> from se_device->qf_work_queue context.
>>
>> Ah, Right...
>>
>>>
>>> It's lio_queue_data_in() + lio_queue_status() that aren't propagating
>>> up failures to trigger queue_full in target_complete_ok_work().
>>> Looking at this code again for traditional iscsi-target, I don't see a
>>> reason why
>>> iscsit_add_cmd_to_response_queue() failure should not be triggering
>>> queue_full logic to kick in..
>>>
>>> On the iser-target side, is it OK for isert_put_datain() +
>>> isert_put_response() to be re-invoked from transport_complete_qf()
>>> context after ib_post_send() failure..?
>>
>> Well, Generally the QP owner is obligated to not post more than the QP size
>> and/or request for send completion once every SQ size. If we got ENOMEM
>> from ib_post_send this usually indicates a bug, and there is no sense in
>> retrying later, and I'm not aware of any provider that may return EAGAIN at
>> the moment, but maybe this can happen theoretically...
>>
>> But I think the correct behavior from iSCSI PoV is to have ENOMEM/EAGAIN
>> error codes from queue_data_in/queue_status trigger queue_full logic and
>> terminate the session for any other
>> (non-transient) error code.
>
> Interesting, I missed that part.  I am seeing ocrdma_post_send() fail because it's
> out of QP entries.   So maybe the real fix is to find out why that's happening.

Right...

>  Either the
> caller is posting more entries than it should, or maybe ocrdma is reporting the
> wrong QP size.  Any pointers to where that gets checked?

the iser target ignores the device capabilities for SQ size at the
moment (BUG), so I doubt it has something to do with ocrdma QP size
report.

>   If the target has received
> a SCSI READ it's going to have to post back one or more datain phases.  Somewhere
> in the stack there has to be back pressure so that the target layer doesn't try to
> send a datain if the QP is full.  I had assumed that was handled by the ENOMEM
> return and then queue full processing, but it sounds like it should be caught before
> the error even occurs.

I still think the error should be propagated and not ignored by iscsit.
As I mentioned transient errors should be retired later and
non-transient errors should shutdown the connection.

What was the initiator cmds_max you were running with? There is a bug
I know of that the initaitor and target does not really sync the number
of inflight commands (see MaxOutstandingUnexpectedPDUs). That might be
related.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
