From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V5 libibverbs 0/7] Completion timestamping
Date: Wed, 1 Jun 2016 10:49:41 -0500
Message-ID: <006901d1bc1d$35c63270$a1529750$@opengridcomputing.com>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464786340-7630-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



<snip>

> 
> The batching API is thread-safe (assuming the CQ wasn't created with
> SINGLE_THREADED attribute) and represents a series of completions the user
> would like to poll one after another.  The vendor user space driver should
> guarantee this.
>

Hey Yishai,

Can you please explain how multiple threads can use this API concurrently?  I
don't understand how two threads can be in the middle of the next branch
concurrently?  Is only one thread allowed in at a time for a
start/next/next/.../end branch?

Thanks,

Steve.
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
