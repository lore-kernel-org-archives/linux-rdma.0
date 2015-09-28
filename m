From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] xprtrdma: disconnect and flush cqs before freeing
 buffers
Date: Mon, 28 Sep 2015 10:57:19 -0400
Message-ID: <5609554F.3050201@Netapp.com>
References: <20150921172423.9761.92399.stgit@build2.ogc.int>
 <56094F16.3040608@opengridcomputing.com> <56095286.6030201@Netapp.com>
 <005401d0f9fd$16399920$42accb60$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005401d0f9fd$16399920$42accb60$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/28/2015 10:50 AM, Steve Wise wrote:
> 
> 
>> -----Original Message-----
>> From: Anna Schumaker [mailto:Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org]
>> Sent: Monday, September 28, 2015 9:45 AM
>> To: Steve Wise; trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
>> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH 1/3] xprtrdma: disconnect and flush cqs before freeing buffers
>>
>> Hi Steve,
>>
>> On 09/28/2015 10:30 AM, Steve Wise wrote:
>>> On 9/21/2015 12:24 PM, Steve Wise wrote:
>>>> Otherwise a FRMR completion can cause a touch-after-free crash.
>>>>
>>>> In xprt_rdma_destroy(), call rpcrdma_buffer_destroy() only after calling
>>>> rpcrdma_ep_destroy().
>>>>
>>>> In rpcrdma_ep_destroy(), disconnect the cm_id first which should flush the
>>>> qp, then drain the cqs, then destroy the qp, and finally destroy the cqs.
>>>>
>>>> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>>>> Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>
>>> Hey Trond,  I'm hoping this can make 4.3-rc (and stable if you agree).
>>
>> This patch looks fine to me.  I'll pass it on to Trond!
>>
>> I'll save patch 3/3 for the Linux 4.4 merge.
>>
>> Thanks,
>> Anna
>>
> 
> Thanks.  Going forward I'll make sure you are CC'd for client patches too!  I wasn't sure if you are formally taking all xprtrdma patches and sending them to Trond...

Yeah, I'm taking all the client RDMA patches.  I'm glad that's cleared up now! :)

Anna

> 
> Steve.
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
