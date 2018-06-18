From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH rdma-next v2 09/20] IB/core: Improve
 uverbs_cleanup_ucontext algorithm
Date: Mon, 18 Jun 2018 14:27:22 +0300
Message-ID: <d5f535d4-ad77-1ebd-25d5-29cbf00ea983@dev.mellanox.co.il>
References: <20180617100006.30663-1-leon@kernel.org>
 <20180617100006.30663-10-leon@kernel.org>
 <20180617195106.eai7iajx4y5w3ii6@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617195106.eai7iajx4y5w3ii6@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 6/17/2018 10:51 PM, Jason Gunthorpe wrote:
> On Sun, Jun 17, 2018 at 12:59:55PM +0300, Leon Romanovsky wrote:
> 
>> +void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
>> +{
>>   	/*
>>   	 * Waits for all remove_commit and alloc_commit to finish. Logically, We
>>   	 * want to hold this forever as the context is going to be destroyed,
>>   	 * but we'll release it since it causes a "held lock freed" BUG message.
>>   	 */
>>   	down_write(&ucontext->cleanup_rwsem);
>> +	while (!list_empty(&ucontext->uobjects))
>> +		if (__uverbs_cleanup_ucontext(ucontext, RDMA_REMOVE_DESTROY))
>> +			/* No entry was cleaned-up successfully during this iteration */
>> +			break;
> 
> No, this isn't right, it must remain REMOVE or CLOSE here. The enum is
> a signal to the driver what is going on. DESTROY is only for user
> triggered destroy called in a user context.
> 

The algorithm must enable the drivers an option to fully cleanup their 
resources as was done before this change.

Using REMOVE or CLOSE without some following change won't do the work as 
the infrastructure (e.g. remove_commit_idr_uobject) and other IB cleanup 
functions during the road (e.g. uverbs_free_qp, uverbs_free_cq) will 
force cleanup of some memory/idr/ref resources and prevent a second 
successful iteration in case of a failure.

For that reason the initial iteration should be with some relaxed mode 
and just later in case were left uncleaned-up resources the code should 
use the REMOVE/CLOSE option.

However, I do agree that we need to preserve the original signal to let 
downstream layers to know what happened, at the moment it looks like 
there is one place that it's even a must as part of 
uverbs_hot_unplug_completion_event_file() where 
'RDMA_REMOVE_DRIVER_REMOVE' is used explicitly as part of the cleanup flow.

For that I suggest below [1] patch which replaces RDMA_REMOVE_DESTROY in 
the first iteration with RDMA_REMOVE_DRIVER_REMOVE_RELAX/ 
RDMA_REMOVE_CLOSE_RELAX new enum values to do the job.

> There needs to be some kind of guarenteed return from the driver that
> destroy is failing due to elevated refcounts, and not some other
> reason.. This is just checking for any ret?

We can't rely on all drivers' return codes from legacy/current firmware 
code for all objects to return a specific ret code for that case.
Even if we had such, the second iteration where we should force cleanup 
might still fail with that ret code and a kernel memory leak would occur.

> 
>> -	while (!list_empty(&ucontext->uobjects)) {
>> -		struct ib_uobject *obj, *next_obj;
>> -		unsigned int next_order = UINT_MAX;
>> +	if (!list_empty(&ucontext->uobjects))
>> +		__uverbs_cleanup_ucontext(ucontext, device_removed ?
>> +			RDMA_REMOVE_DRIVER_REMOVE : RDMA_REMOVE_CLOSE);
> 
> Failure to cleanup is a driver bug, and should be reported with
> WARN_ON. This is also mis using the remove enum, CLOSE is not a
> 'bigger hammer'
> 

The patch saves the previous behavior that set a warn message [2] and 
not a WARN_ON, if you think that WARN_ON is better we can change to.

[2]
pr_warn("ib_uverbs: unable to remove uobject id %d err %d\n",
				obj->id, err);


The suggested patch on top of current can look like below.


diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 4685ef5..6b03ca7
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1468,8 +1468,21 @@ enum rdma_remove_reason {
         RDMA_REMOVE_DRIVER_REMOVE,
         /* Context is being cleaned-up, but commit was just completed */
         RDMA_REMOVE_DURING_CLEANUP,
+       /* Driver is being hot-unplugged, retry may be called upon an 
error */
+       RDMA_REMOVE_DRIVER_REMOVE_RELAX,
+       /* Context deletion, retry may be called upon an error */
+       RDMA_REMOVE_CLOSE_RELAX,
  };

+static inline bool ib_is_remove_retry(enum rdma_remove_reason why)
+{
+       if (why == RDMA_REMOVE_DESTROY || why == 
RDMA_REMOVE_DRIVER_REMOVE_RELAX ||
+               why == RDMA_REMOVE_CLOSE_RELAX)
+               return true;
+
+       return false;
+}
+


// In the new algorithm below enums will be used instead of 
//RDMA_REMOVE_DESTROY

@@ -700,7 +701,9 @@ void uverbs_cleanup_ucontext(struct ib_ucontext 
*ucontext, bool device_removed)
          */
         down_write(&ucontext->cleanup_rwsem);
         while (!list_empty(&ucontext->uobjects))
-               if (__uverbs_cleanup_ucontext(ucontext, 
RDMA_REMOVE_DESTROY))
+               if (__uverbs_cleanup_ucontext(ucontext, device_removed ?
+                                       RDMA_REMOVE_DRIVER_REMOVE_RELAX :
+                                       RDMA_REMOVE_CLOSE_RELAX))
                         /* No entry was cleaned-up successfully during 
this iteration */
                         break;


// Below logic will be replaced in all applicable places, I just put few 
// of to demonstrate the solution.

--- a/drivers/infiniband/core/uverbs_std_types_cq.c
+++ b/drivers/infiniband/core/uverbs_std_types_cq.c
@@ -44,7 +44,7 @@ static int uverbs_free_cq(struct ib_uobject *uobject,
         int ret;

         ret = ib_destroy_cq(cq);
-       if (!ret || why != RDMA_REMOVE_DESTROY)
+       if (!ret || !ib_is_remove_retry(why))
                 ib_uverbs_release_ucq(uobject->context->ufile, ev_queue 
? container_of(ev_queue, struct ib_uverbs_completion_event_file,


++ b/drivers/infiniband/core/rdma_core.c
@@ -360,9 +360,10 @@ static int __must_check 
remove_commit_idr_uobject(struct ib_uobject *uobj,

         /*
          * We can only fail gracefully if the user requested to destroy the
-        * object. In the rest of the cases, just remove whatever you can.
+        * object or when a retry may be called upon an error.
+        * In the rest of the cases, just remove whatever you can.
          */
-       if (why == RDMA_REMOVE_DESTROY && ret)
+       if (ret && ib_is_remove_retry(why))
                 return ret;

         ib_rdmacg_uncharge(&uobj->cg_obj, uobj->context->device,
@@ -393,7 +394,7 @@ static int __must_check 
remove_commit_fd_uobject(struct ib_uobject *uobj,
                 container_of(uobj, struct ib_uobject_file, uobj);
         int ret = fd_type->context_closed(uobj_file, why);

-       if (why == RDMA_REMOVE_DESTROY && ret)
+       if (ret && ib_is_remove_retry(why))
                 return ret;


//Here is the specific place that checks for RDMA_REMOVE_DRIVER_REMOVE. 
// it should do the work also when RDMA_REMOVE_DRIVER_REMOVE was called.

@@ -187,7 +187,7 @@ static int 
uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
         event_queue->is_closed = 1;
         spin_unlock_irq(&event_queue->lock);

-       if (why == RDMA_REMOVE_DRIVER_REMOVE) {
+       if (why == RDMA_REMOVE_DRIVER_REMOVE || why == 
RDMA_REMOVE_DRIVER_REMOVE_RELAX) {
                 wake_up_interruptible(&event_queue->poll_wait);
                 kill_fasync(&event_queue->async_queue, SIGIO, POLL_IN);
         }


What do you think ?

Yishai
