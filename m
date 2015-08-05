From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Wed, 05 Aug 2015 18:09:45 +0300
Message-ID: <55C22739.5060808@dev.mellanox.co.il>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com> <1438697008-26209-7-git-send-email-yishaih@mellanox.com> <20150804220903.GE10934@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804220903.GE10934-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/5/2015 1:09 AM, Jason Gunthorpe wrote:
> On Tue, Aug 04, 2015 at 05:03:28PM +0300, Yishai Hadas wrote:
>> Currently, IB/cma remove_one flow blocks until all user descriptor managed by
>> IB/ucma are released. This prevents hot-removal of IB devices. This patch
>> allows IB/cma to remove devices regardless of user space activity. Upon getting
>> the RDMA_CM_EVENT_DEVICE_REMOVAL event we close all the underlying HW resources
>> for the given ucontext. The ucontext itself is still alive till its explicit
>> destroying by its creator.
>>
>> Running applications at that time will have some zombie device, further
>> operations may fail.
>
> I've never made it far enough to look at this patch before... It is
> Sean's stuff so he is best qualified to comment on it. The rest of the
> series is OK now Sean.
>
>> +static void ucma_close_id(struct work_struct *work)
>> +{
>> +	struct ucma_context *ctx =  container_of(work, struct ucma_context, close_work);
>> +
>> +	/* Fence to ensure that ctx->closing was seen by all
>> +	 * ucma_get_ctx running
>> +	 */
>> +	mutex_lock(&mut);
>> +	mutex_unlock(&mut);
>
> Uh, no. That isn't how to use mutex's.

That locking scheme is used in some other places in the kernel when a 
barrier/fence is needed, see below some examples of that usage and my 
comment around the usage.

One of (see below in cma.c) was added by Sean Hefty as part of commit ID 
a396d43a in rdma_destroy_id, it's part of same kernel subsystem and uses 
same concept as of above code.

I believe that we can go ahead and merge this patch as part of the series.

If you still don't agree we can go ahead and merge the first 5 patches 
that doesn't depend on that last patch and handle/discuss this patch later.

The first 4 you already review and acked the fifth is in mlx4_ib and has 
no comments to fix so far - some months in the list.


Some examples of that usage:
------------------------------
http://lxr.free-electrons.com/source/kernel/audit.c#L532
         /* wait for parent to finish and send an ACK */
532         mutex_lock(&audit_cmd_mutex);
533         mutex_unlock(&audit_cmd_mutex);

http://lxr.free-electrons.com/source/fs/configfs/dir.c#L1386
1386                         /* Wait until the racing operation 
terminates */
1387                         mutex_lock(wait_mutex);
1388                         mutex_unlock(wait_mutex);

http://lxr.free-electrons.com/source/drivers/infiniband/core/cma.c#L1053
1050          /* Wait for any active callback to finish.  New callbacks 
will find
1051          * the id_priv state set to destroying and abort.
1052          */
1053         mutex_lock(&id_priv->handler_mutex);
1054         mutex_unlock(&id_priv->handler_mutex);

http://lxr.free-electrons.com/source/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c#L96
  96         /* barrier */
  97         mutex_lock(&sec_gc_mutex);
  98         mutex_unlock(&sec_gc_mutex);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
