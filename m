From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 31/37] librdmacm: provide abstracted verb calls
Date: Wed, 07 Apr 2010 17:07:21 -0500
Message-ID: <4BBD0219.2080602@opengridcomputing.com>
References: <27A4CFF94530491F88C8E528428FF93E@amr.corp.intel.com> <4BBCDF57.20303@opengridcomputing.com> <411E3A9BECF04B598FFEFFF08505DE6F@amr.corp.intel.com> <4BBCED37.9040708@opengridcomputing.com> <3F9969F0569A431A9B40B8DED7E18FB4@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F9969F0569A431A9B40B8DED7E18FB4-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>>> I think it's possible for the function to return without having filled in a
>>>       
>> wc.
>>     
>> So its busted?  Or is this intended behavior?
>>     
>
> Depends on the point of view, I guess.  :)  It would be nice to avoid that
> situation.
>
>   
>> Is rdma_get_send_completion() supposed to return exactly one wc?  If so
>> then the 2 polls can cause a wc to get silently discarded.   I must
>> still not be understanding the intended use?
>>     
>
> How can a wc get discarded?  Maybe the return code from ibv_poll_cq is confusing
> you?  If the first poll finds a wc, ibv_poll_cq returns 1, and we exit the
> function.  Otherwise, we rearm the cq, then poll again to make sure that nothing
> got missed.
>
>   


Right.  I missed that.  poll will return 1 if there's a completion 
returned.  Nevermind :)


>> I would think this should just be:
>>
>> get_cq_event()
>> notify_cq()
>> poll()
>>     
>
> This requires arming the CQ up front.  I was also trying to avoid the overhead
> of always calling get_cq_event and notify_cq to just pull a completed request
> off of the work queue.
>
>   


I was confused on the poll_cq return code (and I've been working in this 
code for umpteen years :) ).


>>> The only drawback I see is that it's theoretically possible to build up a
>>>       
>> queue
>>     
>>> of cq events in the kernel.  Not sure how to fix that.  Any ideas?
>>>
>>>       
>> That can always happen, yes?
>>     
>
> It seems like it should be avoidable.  Maybe 1 event can queue up, but I think
> we can prevent more by not rearming until that event gets pulled.
>
> If nothing else, I think this discussion shows why we need this sort of wrapper.
> :)
>   

Indeed!  I like the wrappers.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
