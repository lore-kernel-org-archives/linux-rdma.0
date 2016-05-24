From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 02/10] IB/core: Introduce Work Queue object
 and its verbs
Date: Tue, 24 May 2016 17:51:59 +0300
Message-ID: <f196f9b5-9735-6fcb-37d6-7bafed020308@dev.mellanox.co.il>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-3-git-send-email-yishaih@mellanox.com>
 <5d0982d2-3b07-11a3-a74c-a52b8e9fb392@opengridcomputing.com>
 <d2401170-0ff4-c39a-d7c6-2a5face00fa2@dev.mellanox.co.il>
 <007001d1b5c8$26c9c8a0$745d59e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <007001d1b5c8$26c9c8a0$745d59e0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/24/2016 5:25 PM, Steve Wise wrote:
>>> Hey Yishai,
>>>
>>> What happens to posted RQ WRs when transitioning from RDY->RESET,
>>> RDY->ERR, and ERR->RESET?
>>> Shouldn't the state machine be defined more?
>>
>> When the external RQ (i.e. WQ from type RQ) is moved to error/reset
>> state it will behave similarly to the receive queue part of a QP when it
>> enters error/reset state.
>>
>> Specifically,
>> When moving to RESET:
>> RQ attributes are reset to the same values after the RQ was created.
>> Outstanding Work Requests are removed from the queues without notifying
>> the Consumer.
>>
>> When Moving to ERR:
>> RQ processing is stopped. Work Requests pending or in process are
>> completed in error.
>>
>
> Thanks for the explanation.  These semantics should be documented somewhere.
>
> This series appears to me to be reasonable.
>
> Series Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks Steve for your Reviewed-by on the series, it's really appreciated.

Doug, can you please take it into 4.7 ? it missed few kernel merging 
already, hope that now it will be in.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
