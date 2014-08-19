From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/8] IPoIB: fix MCAST_FLAG_BUSY usage
Date: Tue, 19 Aug 2014 16:28:44 -0400 (EDT)
Message-ID: <902D5BF2-159A-4B31-A87F-7491F3C8057F@redhat.com>
References: <cover.1407885724.git.dledford@redhat.com> <a410e80dc5ca7cfa64229bbbf50c1337317e3bd8.1407885724.git.dledford@redhat.com> <CABgxfbH-Dt3CpxJKwCAZeHTUyupaA9y_WXVXuxgiPMet26PTQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbH-Dt3CpxJKwCAZeHTUyupaA9y_WXVXuxgiPMet26PTQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Excuse my top posting, I'm at a meeting and not using my normal mail client.

To answer your question, this is a confusing issue that I had to work through myself.

When we call ib_sa_multicast_join, it will create a record for us and return that.  That record is not valid for us to call ib_sa_multicast_leave until after the join has completed and our callback has acknowledged that join completion with a 0 return status from our callback.

At the time the record is created, ib_sa_multicast_join will also queue up the actual join.  When the join completes, they call our callback (and without my locking fixes, we can get the callback before ib_sa_multicast_join returns our record entry to us).

If our callback is called with the status already set, then the join has failed and will be handled that way when our callback returns.  In this case, the callback is informative for us, that's all.  When we trap -ENETRESET and put our return to 0, we are acknowledging that the join failed prior to our callback and that the join will not be completed and that mcast->mc as we have recorded is not valid.

If the status is 0 to start, and we set it to a non-0 value, then that also indicates that the join has failed, but in this case the core code must unroll the join that was completed up until the callback was done (and it does).  Any time this is the case, the member record returned from ib_sa_multicast_join is invalid and we can not call ib_sa_multicast_leave on the record or we will hang forever waiting for a completion that won't be coming.

Only if we get our callback entered with a 0 status and return with a 0 status does the member record that ib_sa_multicast_join returned to us become fully valid.  At this point, we must call ib_sa_multicast_leave on the record if we want it to go away.

So that's why in this patch we

1) take a mutex to force ib_sa_join_multicast to return and us to set mcast->mc to the proper return value before we process the join completion callback
2) always clear mcast->mc if there is any error since we can't call ib_sa_multicast_leave
3) always complete the mcast in case we are waiting on it
4) only if our status is ENETRESET set our return to 0 so the ib core code knows we acknowledged the event

Sent from my iPad

> On Aug 19, 2014, at 11:08 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> On Tue, Aug 12, 2014 at 4:38 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Commit a9c8ba5884 (IPoIB: Fix usage of uninitialized multicast objects)
>> added a new flag MCAST_JOIN_STARTED, but was not very strict in how it
>> was used.  We didn't always initialize the completion struct before we
>> set the flag, and we didn't always call complete on the completion
>> struct from all paths that complete it.  This made it less than totally
>> effective, and certainly made its use confusing.  And in the flush
>> function we would use the presence of this flag to signal that we should
>> wait on the completion struct, but we never cleared this flag, ever.
>> This is further muddied by the fact that we overload the MCAST_FLAG_BUSY
>> flag to mean two different things: we have a join in flight, and we have
>> succeeded in getting an ib_sa_join_multicast.
>> 
> 
> [snip]
> 
>> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> index 7e9cd39b5ef..f5e8da530d9 100644
>> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
>> @@ -271,16 +271,27 @@ ipoib_mcast_sendonly_join_complete(int status,
>>        struct ipoib_mcast *mcast = multicast->context;
>>        struct net_device *dev = mcast->dev;
>> 
>> +       /*
>> +        * We have to take the mutex to force mcast_sendonly_join to
>> +        * return from ib_sa_multicast_join and set mcast->mc to a
>> +        * valid value.  Otherwise we were racing with ourselves in
>> +        * that we might fail here, but get a valid return from
>> +        * ib_sa_multicast_join after we had cleared mcast->mc here,
>> +        * resulting in mis-matched joins and leaves and a deadlock
>> +        */
>> +       mutex_lock(&mcast_mutex);
>> +
>>        /* We trap for port events ourselves. */
>>        if (status == -ENETRESET)
>> -               return 0;
>> +               goto out;
>> 
> 
> [snip]
> 
> 
>> +out:
>> +       clear_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags);
>> +       if (status)
>> +               mcast->mc = NULL;
>> +       complete(&mcast->done);
>> +       if (status == -ENETRESET)
>> +               status = 0;
>> +       mutex_unlock(&mcast_mutex);
>>        return status;
>> }
>> 
> 
> I have not gone thru the whole patch yet. However, here is something quick ...
> 
> Would this "return 0 if (status == -ENETRESET)" be wrong in the
> original code ?  Say ..... when it returns to process_group_error(),
> without proper error return code, it'll skip ib_sa_free_multicast().
> Should we worry about it ?
> 
> -- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
