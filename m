From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/rxe: Fix handling of erroneous WR
Date: Tue, 13 Dec 2016 09:04:44 +0100
Message-ID: <ba254635-c8f9-7b3b-eb73-60075d079542@sandisk.com>
References: <1479285558-19627-1-git-send-email-leon@kernel.org>
 <1479285558-19627-3-git-send-email-leon@kernel.org>
 <5bd83de1-64d3-e5a9-1c58-cca52d89d64a@sandisk.com>
 <20161213074441.GE8204@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161213074441.GE8204-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/13/2016 08:44 AM, Leon Romanovsky wrote:
> On Tue, Dec 13, 2016 at 08:03:03AM +0100, Bart Van Assche wrote:
>> On 11/16/2016 09:39 AM, Leon Romanovsky wrote:
>>> @@ -745,13 +746,17 @@ int rxe_requester(void *arg)
>>>  	wqe->status = IB_WC_LOC_PROT_ERR;
>>>  	wqe->state = wqe_state_error;
>>>
>>> -complete:
>>> -	if (qp_type(qp) != IB_QPT_RC) {
>>> -		while (rxe_completer(qp) == 0)
>>> -			;
>>> -	}
>>> -
>>> -	return 0;
>>> +	/*
>>> +	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
>>> +	 * ---------8<---------8<-------------
>>> +	 * ...Note that if a completion error occurs, a Work Completion
>>> +	 * will always be generated, even if the signaling
>>> +	 * indicator requests an Unsignaled Completion.
>>> +	 * ---------8<---------8<-------------
>>> +	 */
>>> +	wqe->wr.send_flags |= IB_SEND_SIGNALED;
>>> +	__rxe_do_task(&qp->comp.task);
>>> +	return -EAGAIN;
>>
>> Hello Leon and Yonatan,
>>
>> Sorry for the late reply but I think setting IB_SEND_SIGNALED for WQE's
>> reporting a completion error is wrong.
>
> I'm not clear about it. I didn't find in spec what to do with IB_SEND_SIGNALED
> flag in case of error.
>
> According to spec:
> 	"C10-91: The CI shall generate a CQE when a Work Request
> 	completed under any of the following conditions:
> 	• The Work Request completed in error"

Hello Leon,

To me that paragraph from the spec means that do_complete() is wrong. 
And once do_complete() is fixed, callers that set the WQE status to 
"error" no longer have to set IB_SEND_SIGNALED.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
