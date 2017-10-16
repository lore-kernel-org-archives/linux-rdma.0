From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/core: Fix use workqueue without
 WQ_MEM_RECLAIM
Date: Mon, 16 Oct 2017 13:24:12 -0400
Message-ID: <4f08314e-fd5d-c108-438a-d9e83821e4b3@redhat.com>
References: <20171016054517.30643-1-leon@kernel.org>
 <20171016054517.30643-5-leon@kernel.org>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054517.30643-5-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/16/2017 01:45 AM, Leon Romanovsky wrote:
> From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The IB/core provides address resolution service and invokes callback
> handler when address resolve request completes of requester in worker
> thread context.
> 
> Such caller might allocate or free memory in callback handler
> depending on the completion status to make further progress or to
> terminate a connection. Most ULPs resolve route which involves
> allocating route entry and path record elements in callback event handler.
> 
> It has been noticed that WQ_MEM_RECLAIM flag should not be used for
> workers that tend to allocate memory in this [1] thread discussion.
> 
> In order to mitigate this situation, WQ_MEM_RECLAIM flag was dropped for
> other such WQs in this [2] patch.
> 
> Similar problem might arise with address resolution path, though its not
> yet noticed. The ib_addr workqueue is not memory reclaim path due to its
> nature of invoking callback that might allocate memory or don't free any
> memory under memory pressure.
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg53239.html
> [2] https://www.spinics.net/lists/linux-rdma/msg53416.html
> 
> Fixes: f54816261c2b ("IB/addr: Remove deprecated create_singlethread_workqueue")
> Fixes: 5fff41e1f89d ("IB/core: Fix race condition in resolving IP to MAC")
> Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This looks like a -stable patch candidate. Once accepted this should
probably be queued for v4.9+.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
