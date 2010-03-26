From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 12:42:50 -0500
Message-ID: <4BACF21A.8020001@opengridcomputing.com>
References: <4BACD985.1070906@opengridcomputing.com> <DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com> <4BACE28A.2080409@opengridcomputing.com> <AB19885D9F4245DFABBCB131959382C5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AB19885D9F4245DFABBCB131959382C5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> In other words, I think we want the ucma context to stay around until
>> the application destroys it (via explicit means or via exit).   But the
>> rdma_cm_id gets destroyed immediately upon receiving a DEVICE_REMOVE event.
>>     
>
> Yes - this is what I was trying to say.
>
> The problem is trying to destroy the rdma_cm_id 'immediately' upon receiving a
> device remove event.  The user could be in a separate downcall into the rdma_cm
> at the time the device removal occurs, and we cannot call rdma_destroy_id while
> calling rdma_foo() for the same id.  Plus, 'foo' may be 'destroy_id', and we
> can't destroy the id twice.
>
> For the trivial case, if the rdma_cm_id is not in use, we just return -1 to the
> remove device callback to destroy the id.  But if the rdma_cm_id is in use, then
> we must schedule the destruction of the rdma_cm_id to a separate thread and
> synchronize that thread against user space destroying the id before the thread
> can run.
>
>   

I think you don't want to schedule another thread.  The semantics of the 
device removal and eeh events is that when the driver returns, all usage 
of the device is stopped and it can be removed, reset, etc.  Because of 
this, these events are run on a thread so they can block if needed.

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
