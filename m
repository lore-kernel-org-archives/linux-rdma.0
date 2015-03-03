From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 7/9] IB/ipoib: fix MCAST_FLAG_BUSY usage
Date: Tue, 03 Mar 2015 11:53:21 +0200
Message-ID: <54F58491.6020407@dev.mellanox.co.il>
References: <cover.1424562072.git.dledford@redhat.com>	 <9d657f64ee961ee3b3233520d8b499b234a42bcd.1424562072.git.dledford@redhat.com>	 <54F2DC81.304@dev.mellanox.co.il> <1425310036.2354.24.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425310036.2354.24.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/2/2015 5:27 PM, Doug Ledford wrote:
> On Sun, 2015-03-01 at 11:31 +0200, Erez Shitrit wrote:
>> On 2/22/2015 2:27 AM, Doug Ledford wrote:
>>> Commit a9c8ba5884 ("IPoIB: Fix usage of uninitialized multicast
>>> objects") added a new flag MCAST_JOIN_STARTED, but was not very strict
>>> in how it was used.  We didn't always initialize the completion struct
>>> before we set the flag, and we didn't always call complete on the
>>> completion struct from all paths that complete it.  And when we did
>>> complete it, sometimes we continued to touch the mcast entry after
>>> the completion, opening us up to possible use after free issues.
>>>
>>> This made it less than totally effective, and certainly made its use
>>> confusing.  And in the flush function we would use the presence of this
>>> flag to signal that we should wait on the completion struct, but we never
>>> cleared this flag, ever.
>>>
>>> In order to make things clearer and aid in resolving the rtnl deadlock
>>> bug I've been chasing, I cleaned this up a bit.
>>>
>>>    1) Remove the MCAST_JOIN_STARTED flag entirely
>>>    2) Change MCAST_FLAG_BUSY so it now only means a join is in-flight
>>>    3) Test mcast->mc directly to see if we have completed
>>>       ib_sa_join_multicast (using IS_ERR_OR_NULL)
>>>    4) Make sure that before setting MCAST_FLAG_BUSY we always initialize
>>>       the mcast->done completion struct
>>>    5) Make sure that before calling complete(&mcast->done), we always clear
>>>       the MCAST_FLAG_BUSY bit
>>>    6) Take the mcast_mutex before we call ib_sa_multicast_join and also
>>>       take the mutex in our join callback.  This forces
>>>       ib_sa_multicast_join to return and set mcast->mc before we process
>>>       the callback.  This way, our callback can safely clear mcast->mc
>>>       if there is an error on the join and we will do the right thing as
>>>       a result in mcast_dev_flush.
>>>    7) Because we need the mutex to synchronize mcast->mc, we can no
>>>       longer call mcast_sendonly_join directly from mcast_send and
>>>       instead must add sendonly join processing to the mcast_join_task
>>>    8) Make MCAST_RUN mean that we have a working mcast subsystem, not that
>>>       we have a running task.  We know when we need to reschedule our
>>>       join task thread and don't need a flag to tell us.
>>>    9) Add a helper for rescheduling the join task thread
>>>
>>> A number of different races are resolved with these changes.  These
>>> races existed with the old MCAST_FLAG_BUSY usage, the
>>> MCAST_JOIN_STARTED flag was an attempt to address them, and while it
>>> helped, a determined effort could still trip things up.
>>>
>>> One race looks something like this:
>>>
>>> Thread 1                             Thread 2
>>> ib_sa_join_multicast (as part of running restart mcast task)
>>>     alloc member
>>>     call callback
>>>                                        ifconfig ib0 down
>>> 				     wait_for_completion
>>>       callback call completes
>>>                                        wait_for_completion in
>>> 				     mcast_dev_flush completes
>>> 				       mcast->mc is PTR_ERR_OR_NULL
>>> 				       so we skip ib_sa_leave_multicast
>>>       return from callback
>>>     return from ib_sa_join_multicast
>>> set mcast->mc = return from ib_sa_multicast
>>>
>>> We now have a permanently unbalanced join/leave issue that trips up the
>>> refcounting in core/multicast.c
>>>
>>> Another like this:
>>>
>>> Thread 1                   Thread 2         Thread 3
>>> ib_sa_multicast_join
>>>                                               ifconfig ib0 down
>>> 					    priv->broadcast = NULL
>>>                              join_complete
>>> 			                    wait_for_completion
>>> 			   mcast->mc is not yet set, so don't clear
>>> return from ib_sa_join_multicast and set mcast->mc
>>> 			   complete
>>> 			   return -EAGAIN (making mcast->mc invalid)
>>> 			   		    call ib_sa_multicast_leave
>>> 					    on invalid mcast->mc, hang
>>> 					    forever
>>>
>>> By holding the mutex around ib_sa_multicast_join and taking the mutex
>>> early in the callback, we force mcast->mc to be valid at the time we
>>> run the callback.  This allows us to clear mcast->mc if there is an
>>> error and the join is going to fail.  We do this before we complete
>>> the mcast.  In this way, mcast_dev_flush always sees consistent state
>>> in regards to mcast->mc membership at the time that the
>>> wait_for_completion() returns.
>>>
>>> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    drivers/infiniband/ulp/ipoib/ipoib.h           |  11 +-
>>>    drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 355 ++++++++++++++++---------
>>>    2 files changed, 238 insertions(+), 128 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
>>> index 9ef432ae72e..c79dcd5ee8a 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib.h
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
>>> @@ -98,9 +98,15 @@ enum {
>>>    
>>>    	IPOIB_MCAST_FLAG_FOUND	  = 0,	/* used in set_multicast_list */
>>>    	IPOIB_MCAST_FLAG_SENDONLY = 1,
>>> -	IPOIB_MCAST_FLAG_BUSY	  = 2,	/* joining or already joined */
>>> +	/*
>>> +	 * For IPOIB_MCAST_FLAG_BUSY
>>> +	 * When set, in flight join and mcast->mc is unreliable
>>> +	 * When clear and mcast->mc IS_ERR_OR_NULL, need to restart or
>>> +	 *   haven't started yet
>>> +	 * When clear and mcast->mc is valid pointer, join was successful
>>> +	 */
>>> +	IPOIB_MCAST_FLAG_BUSY	  = 2,
>>>    	IPOIB_MCAST_FLAG_ATTACHED = 3,
>>> -	IPOIB_MCAST_JOIN_STARTED  = 4,
>>>    
>>>    	MAX_SEND_CQE		  = 16,
>>>    	IPOIB_CM_COPYBREAK	  = 256,
>>> @@ -148,6 +154,7 @@ struct ipoib_mcast {
>>>    
>>>    	unsigned long created;
>>>    	unsigned long backoff;
>>> +	unsigned long delay_until;
>>>    
>>>    	unsigned long flags;
>>>    	unsigned char logcount;
>>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> index bb1b69904f9..277e7ac7c4d 100644
>>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>>> @@ -66,6 +66,48 @@ struct ipoib_mcast_iter {
>>>    	unsigned int       send_only;
>>>    };
>>>    
>>> +/*
>>> + * This should be called with the mcast_mutex held
>>> + */
>>> +static void __ipoib_mcast_schedule_join_thread(struct ipoib_dev_priv *priv,
>>> +					       struct ipoib_mcast *mcast,
>>> +					       bool delay)
>>> +{
>>> +	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
>> You don't need the flag IPOIB_MCAST_RUN, it is duplicated of
>> IPOIB_FLAG_OPER_UP
>> probably, need to be taken from all places (including ipoib.h file).
> This is probably true, however I skipped it for this series of patches.
> It wasn't a requirement of proper operation, and depending on where in
> the patch series you tried to inject this change, it had unintended
> negative consequences.  In particular, up until patch 7/9,
> mcast_restart_task used to do a hand rolled stop thread and a matching
> start_thread and so couldn't use FLAG_OPER_UP because we needed
> FLAG_OPER_UP to tell us whether or not to restart the thread.

OK, sounds reasonable. we can send a patch after that that fix that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
