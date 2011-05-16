From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: don't declare wr_wait objects on the stack.
Date: Mon, 16 May 2011 11:47:57 -0500
Message-ID: <4DD1553D.5060604@opengridcomputing.com>
References: <20110513183727.32157.8873.stgit@build.ogc.int> <4DD14036.9050704@opengridcomputing.com> <BANLkTimGzzo1xDTvApAVxvv4C8WcYuCdUA@mail.gmail.com> <4DD1493D.3060401@opengridcomputing.com> <4DD14B2D.9090104@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DD14B2D.9090104-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/16/2011 11:05 AM, Steve Wise wrote:
> On 05/16/2011 10:56 AM, Steve Wise wrote:
>> On 05/16/2011 10:53 AM, Roland Dreier wrote:
>>> On Mon, May 16, 2011 at 8:18 AM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>>>> Roland, I need to recall this patch.  It appears to have some problem.
>>> Good thing I didn't apply it yet.
>>>
>>> I did think it should be possible to declare wait objects on the stack... the
>>> origin of completions was to handle exactly that issue; the older semaphore
>>> structure was vulnerable to the wakeup after free, but completions handle
>>> that.  But I didn't look at the cxgb4 code at all...
>>
>> I'm pretty sure the race exists as described in my commit comment.  And I don't see how the wait object code could 
>> avoid this issue.  Unless I'm just all wrong. :)
>>
>>
>
> FYI:
>
> So the crash I kept seeing was that my wake up path would end up accessing a freed wait object.  I added a 100us 
> udelay in this path just after setting the wait condition to true, but before calling wake_up().  With this delay, I 
> hit the crash much more quickly.  So in my mind I proved that the race exists.   I then added this commit to get rid 
> of on-stack wait objects, but left the 100us delay in my code and tested that the crash goes away.  So I proved, in my 
> mind, that 1) this was a real issue, and 2) my fix worked.  I then ran some regression tests to convince myself the 
> fix was stable before posting the patch on Friday.  However our QA seems to be seeing some issues with this patch on 
> various backports with older kernels, so I need to investigate this further.  Thus I recalled the patch.
>
>

Roland,  complete() and wait_for_completion() is exactly what I need to be using. It solves the race condition and 
allows on-stack declarations.

I'll re-post a new patch once its ready and tested.

Thanks,

Steve.





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
