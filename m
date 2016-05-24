From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 02/10] IB/core: Introduce Work Queue object
 and its verbs
Date: Tue, 24 May 2016 11:50:51 +0300
Message-ID: <d2401170-0ff4-c39a-d7c6-2a5face00fa2@dev.mellanox.co.il>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-3-git-send-email-yishaih@mellanox.com>
 <5d0982d2-3b07-11a3-a74c-a52b8e9fb392@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5d0982d2-3b07-11a3-a74c-a52b8e9fb392-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/23/2016 7:57 PM, Steve Wise wrote:
> On 5/23/2016 7:20 AM, Yishai Hadas wrote:
>> Introduce Work Queue object and its create/destroy/modify verbs.
>>
>> QP can be created without internal WQs "packaged" inside it,
>> this QP can be configured to use "external" WQ object as its
>> receive/send queue.
>> WQ is a necessary component for RSS technology since RSS mechanism
>> is supposed to distribute the traffic between multiple
>> Receive Work Queues.
>>
>> WQ associated (many to one) with Completion Queue and it owns WQ
>> properties (PD, WQ size, etc.).
>> WQ has a type, this patch introduces the IB_WQT_RQ (i.e.receive queue),
>> it may be extend to others such as IB_WQT_SQ. (send queue).
>> WQ from type IB_WQT_RQ contains receive work requests.
>>
>> PD is an attribute of a work queue (i.e. send/receive queue), it's used
>> by the hardware for security validation before scattering to a memory
>> region which is pointed by the WQ. For that, an external WQ object
>> needs a PD, letting the hardware makes that validation.
>>
>> When accessing a memory region that is pointed by the WQ its PD
>> is used and not the QP's PD, this behavior is similar
>> to a SRQ and a QP.
>>
>> WQ context is subject to a well-defined state transitions done by
>> the modify_wq verb.
>> When WQ is created its initial state becomes IB_WQS_RESET.
>> >From IB_WQS_RESET it can be modified to itself or to IB_WQS_RDY.
>> >From IB_WQS_RDY it can be modified to itself, to IB_WQS_RESET
>> or to IB_WQS_ERR.
>> >From IB_WQS_ERR it can be modified to IB_WQS_RESET.
>>
>> Note: transition to IB_WQS_ERR might occur implicitly in case there
>> was some HW error.
>
> Hey Yishai,
>
> What happens to posted RQ WRs when transitioning from RDY->RESET,
> RDY->ERR, and ERR->RESET?
> Shouldn't the state machine be defined more?

When the external RQ (i.e. WQ from type RQ) is moved to error/reset 
state it will behave similarly to the receive queue part of a QP when it 
enters error/reset state.

Specifically,
When moving to RESET:
RQ attributes are reset to the same values after the RQ was created.
Outstanding Work Requests are removed from the queues without notifying 
the Consumer.

When Moving to ERR:
RQ processing is stopped. Work Requests pending or in process are 
completed in error.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
