From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before destroying
 the CQ.
Date: Wed, 20 Oct 2010 15:12:32 -0500
Message-ID: <4CBF4D30.3050500@opengridcomputing.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/20/2010 03:05 PM, Bart Van Assche wrote:
> On Wed, Oct 20, 2010 at 9:28 PM, Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>  wrote:
>    
>> It is possible for the CQ event thread to poll the CQ after it has been
>> destroyed which can result in a seg fault on T3 interfaces.  This patch
>> cancels the thread and waits for it to exit before destroying the CQ.
>>
>> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> ---
>>
>>   examples/rping.c |    8 ++++++--
>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/examples/rping.c b/examples/rping.c
>> index 91952e7..e603d3b 100644
>> --- a/examples/rping.c
>> +++ b/examples/rping.c
>> @@ -800,10 +800,10 @@ static void *rping_persistent_server_thread(void *arg)
>>
>>         rping_test_server(cb);
>>         rdma_disconnect(cb->child_cm_id);
>> -       rping_free_buffers(cb);
>> -       rping_free_qp(cb);
>>         pthread_cancel(cb->cqthread);
>>         pthread_join(cb->cqthread, NULL);
>> +       rping_free_buffers(cb);
>> +       rping_free_qp(cb);
>>         rdma_destroy_id(cb->child_cm_id);
>>         free_cb(cb);
>>         return NULL;
>> @@ -888,6 +888,8 @@ static int rping_run_server(struct rping_cb *cb)
>>
>>         rping_test_server(cb);
>>         rdma_disconnect(cb->child_cm_id);
>> +       pthread_cancel(cb->cqthread);
>> +       pthread_join(cb->cqthread, NULL);
>>         rdma_destroy_id(cb->child_cm_id);
>>   err2:
>>         rping_free_buffers(cb);
>> @@ -1055,6 +1057,8 @@ static int rping_run_client(struct rping_cb *cb)
>>
>>         rping_test_client(cb);
>>         rdma_disconnect(cb->cm_id);
>> +       pthread_cancel(cb->cqthread);
>> +       pthread_join(cb->cqthread, NULL);
>>   err2:
>>         rping_free_buffers(cb);
>>   err1:
>>      
> Hello Steve,
>
> Are you aware that in general it is easy to trigger a deadlock or
> other undesired behavior by invoking pthread_cancel() ? If a thread
> e.g. gets canceled after having obtained a mutex lock and before that
> mutex is unlocked, this will cause trouble for any other thread that
> tries to grab the mutex.
>
>    

I was under the impression that the thread would only be canceled at 
precise cancellation points.  Like in system calls, or if the thread 
calls pthread_testcancel(), which is what rping does.   There are no 
mutexes held by the thread being canceled either.  I think its ok.  Do 
you see some other issue with the rping CQ event thread that would cause 
these problems?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
