From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 11:36:26 -0500
Message-ID: <4BACE28A.2080409@opengridcomputing.com>
References: <4BACD985.1070906@opengridcomputing.com> <DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DAF23AFA2B904B32B418D9C8798D4276-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> 4) rdma_ucm gets this event and dutifully posts it for the use app to
>> reap.   But since the app doesn't reap this event and exit or at least
>> destroy the cm id, nothing else happens.
>>     
>
> For the rdma_ucm, it should post the event, but destroy the underlying
> rdma_cm_id (possibly by returning non-zero from the remove callback or from
> another thread).  The only call that the rdma_ucm will succeed from user space
> at that point is destroy.  State checking and synchronization would need to be
> used to mark that the kernel id has already been freed.
>
> We just need to ensure that the rdma_ucm doesn't try to destroy an id that is in
> another downcall, and I think the synchronization will be non-trivial.
>
>   

In addition I think there is an assumption in the rdma_ucm that the 
underlying rdma_cm_id exists whenever the ucma context is still valid.  
We might need some state in the ucma context that sez "no rdma_cm_id 
exists".    Then all the ucma code will have to check this before 
utilizing the rdma_cm_id.  Maybe just checking the ctx->cm_id pointer is 
sufficient.  

In other words, I think we want the ucma context to stay around until 
the application destroys it (via explicit means or via exit).   But the 
rdma_cm_id gets destroyed immediately upon receiving a DEVICE_REMOVE event.

Steve.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
