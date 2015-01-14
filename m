From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 20:47:38 +0200
Message-ID: <54B6B9CA.6090208@dev.mellanox.co.il>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>	 <54B692FB.1010904@dev.mellanox.co.il> <1421251762.43839.249.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421251762.43839.249.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/14/2015 6:09 PM, Doug Ledford wrote:
> On Wed, 2015-01-14 at 18:02 +0200, Erez Shitrit wrote:
>> Hi Doug,
>>
>> Perhaps I am missing something here, but ping6 still doesn't work for me
>> in many cases.
>>
>> I think the reason is that your origin patch does the following:
>> in function ipoib_mcast_join_task
>>           if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
>>               ipoib_mcast_sendonly_join(mcast);
>>           else
>>               ipoib_mcast_join(dev, mcast, 1);
>>           return;
>> The flow for sendonly_join doesn't include handling the mc_task, so only
>> the first mc in the list (if it is sendonly mcg) will be sent, and no
>> more mcg's that are in the ipoib mc list are going to be sent. (see how
>> it is in ipoib_mcast_join flow)
> Yes, I know what you are talking about.  However, my patches did not add
> this bug, it was present in the original code.  Please check a plain
> v3.18 kernel, which does not have my patches, and you will see that
> ipoib_mcast_sendonly_join_complete also fails to restart the mcast join
> thread there as well.
Agree.
but in 3.18 there was no call from mc_task to sendonly_join, just to the 
full-member join, so no need at that point to handle the task. (the call 
for sendonly-join was by demand whenever new packet to mcg was sent by 
the kernel)
only in 3.19 the sendonly join was called explicitly from the mc_task.
>
>> I can demonstrate it with the log of ipoib:
>> I am trying to ping6 fe80::202:c903:9f:3b0a via ib0
>>
>> The log is:
>> ib0: restarting multicast task
>> ib0: setting up send only multicast group for
>> ff12:601b:ffff:0000:0000:0000:0000:0016
>> ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff43:3bf1
>> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
>> starting sendonly join
>> ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (status 0)
>> ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88081afb5f40,
>> LID 0xc015, SL 0
>> ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (status 0)
>> ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff88081e1c42c0,
>> LID 0xc014, SL 0
>> ib0: sendonly multicast join failed for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
>> starting sendonly join
>> ib0: sendonly multicast join failed for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
>> starting sendonly join
>> ib0: sendonly multicast join failed for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> ib0: setting up send only multicast group for
>> ff12:601b:ffff:0000:0000:0000:0000:0002
>> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
>> starting sendonly join
>> ib0: sendonly multicast join failed for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>> ib0: setting up send only multicast group for
>> ff12:601b:ffff:0000:0000:0001:ff9f:3b0a
>>       >>>>>> here you can see that the ipv6 address is added and queued
>> to the list
>> ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016,
>> starting sendonly join
>> ib0: sendonly multicast join failed for
>> ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
>>       >>>>>> the ipv6 mcg will not be sent because it is after some other
>> sendonly, and no one in that flow re-queue the mc_task again.
> This is a problem with the design of the original mcast task thread.
> I'm looking at a fix now.  Currently the design only allows one join to
> be outstanding at a time.  Is there a reason for that that I'm not aware
> of?  Some historical context that I don't know about?
IMHO, the reason for  only one mc on the air at a time was to make our 
life easier, otherwise there are locks to take/manage, races between few 
responses, etc. also, the multicast module in the core keeps all the 
requests in serialize mode.
perhaps, you can use the relevant code from the full-member join in the 
sendonly joinin order to handle the mc_task, or to return the call to 
send-only to the mcast_send instead of the mc_task.

>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
