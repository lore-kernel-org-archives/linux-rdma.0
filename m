From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V5 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 30 Jun 2015 00:33:04 +0300
Message-ID: <5591B990.8040807@dev.mellanox.co.il>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com> <1434984438-21733-4-git-send-email-yishaih@mellanox.com> <20150624182519.GD21033@obsidianresearch.com> <558C0775.4000104@dev.mellanox.co.il> <20150625170937.GE21033@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625170937.GE21033-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 8:09 PM, Jason Gunthorpe wrote:
> On Thu, Jun 25, 2015 at 04:51:49PM +0300, Yishai Hadas wrote:
>> On 6/24/2015 9:25 PM, Jason Gunthorpe wrote:
>>> Is not holding the RCU lock while ib_uverbs_release_dev is reading
>>> ib_dev. The barriers in kref are not strong enough to guarentee the RCU
>>> protected data will be visible. (remember when I asked if you checked
>>> all of these?)
>>
>> This is not a locking problem, the only option that here the reference count
>> becomes 0 is if ib_uverbs_remove_one was previously called and decreased the
>> reference count that was taken upon load. However, it was done after that
>> rcu_assign_pointer(uverbs_dev->ib_dev, NULL) was called so the check whether
>> if (!dev->ib_dev) is fully protected and can't race with HW removal flow.
>
> The problem with RCU is not to do with instruction concurrancy, you
> need to convince yourself the unlocked accesses have *data* coherency,
> that is what rcu_derference and friends are all about.
>
> So, looked too briefly yesterday (sorry, busy), but it turns out that
> atomic_sub_return guarentees a full smp_mb(), so the data barrier in
> kref_put *IS* strong enough for this use. Thus it is OK.
>
>> The kref is used to manage the uverbs_dev allocation, the internal code in
>> ib_uverbs_release_dev depends on the state. Usually the natural place to
>> free the memory is as part of the release function as done in other kernel
>> places. In case that ib_device was previously removed it can be safely freed
>> here as it's called when the last client disconnected, this logic is
>> introduced by this patch. In case there is a need to wait clients as the
>> driver doesn't support HW device removal the free can't be done internally
>> but must be done externally in ib_uverbs_remove_one when last client
>> disconnected and complete should be used instead. As of I believe that we
>> can stay with only one kref that manage the uverbs_dev which is safe as I
>> pointed above.
>
> Many other places in the kernel split the 'can i complete remove'
> counter (ie the active count) from the kref. It just makes things
> simpler and cleaner

OK, will use 2 krefs one will control the complete and the second will 
manage the memory, V6 will have this change in.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
