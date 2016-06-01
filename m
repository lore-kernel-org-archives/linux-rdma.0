From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5 libibverbs 0/7] Completion timestamping
Date: Wed, 1 Jun 2016 19:07:06 +0300
Message-ID: <bc75ca98-5d67-a86b-5c65-2bb94ccf6063@dev.mellanox.co.il>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
 <006901d1bc1d$35c63270$a1529750$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <006901d1bc1d$35c63270$a1529750$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/1/2016 6:49 PM, Steve Wise wrote:
>
>
> <snip>
>
>>
>> The batching API is thread-safe (assuming the CQ wasn't created with
>> SINGLE_THREADED attribute) and represents a series of completions the user
>> would like to poll one after another.  The vendor user space driver should
>> guarantee this.
>>
>
> Hey Yishai,
>
> Can you please explain how multiple threads can use this API concurrently?  I
> don't understand how two threads can be in the middle of the next branch
> concurrently?  Is only one thread allowed in at a time for a
> start/next/next/.../end branch?

When a CQ is created with the new API the application states whether 
it's going to be used by a single thread or not. The vendor (e.g. 
libmlx5) based on that will hook its underlying functions for the 
start/next/end for this CQ.

In case the CQ going to be used by multiple threads the vendor will take 
a lock as part of the start and release it as part of the end, 
preventing any other thread to run in the middle of this batch. This 
logic for multi-threaded application is similar to what happened today 
when ibv_poll_cq is called.

As mentioned, the new API gives an option to enjoy from stating that the 
CQ will be used by one thread comparing current legacy API which has no 
idea and always use lock/unlock per ibv_poll_cq call.

You can look in the libmlx5 implementation that I sent today and see the 
above behavior.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
