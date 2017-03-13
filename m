From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Mon, 13 Mar 2017 17:17:48 +0200
Message-ID: <1b4d3cc4-cf44-d052-9129-88ef6b9bfae5@dev.mellanox.co.il>
References: <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
 <20170307191824.GD2228@obsidianresearch.com>
 <6571cf34-63b9-7b83-ddb0-9279e7e20fa9@dev.mellanox.co.il>
 <20170308215609.GB4109@obsidianresearch.com>
 <4dcf0cea-3652-0df2-9d98-74e258e6170a@dev.mellanox.co.il>
 <20170309170320.GA12694@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309170320.GA12694-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2017 7:03 PM, Jason Gunthorpe wrote:
> I honestly think you are trying far too much to pointlessly preserve
> the exact original code...

At that stage we would like to solve the degradation that was introduced 
in previous series of the barriers. Further improvements will be as some 
incremental patches after making the required performance testing.

> If you are going to send this a patch please include my updated
> comment.

I put some comment in mlx4/5 that points that code is latency oriented 
and flush immediately.

>> +/* Do mmio_wc_start and grab a spinlock */
>> +static inline void mmio_wc_spinlock(pthread_spinlock_t *lock)
>> +{
>> +       pthread_spin_lock(lock);
>> +#if !defined(__i386__) && !defined(__x86_64__)
>> +       /* For x86 the serialization within the spin lock is enough to
>> +        * strongly order WC and other memory types. */
>> +       mmio_wc_start();
>> +#endif
>
> I would like to see the unlock inline still present in the header for
> clarity to the reader what the expected pattern is, and a comment in
> mlx4/mlx5 indicating they are not using the unlock macro directly to
> try and reduce latency to the flush.

For now this macro is not in use by mlx4 & mlx5 as pointed before.

In addition, it still needs some work to verify whether the unlock is 
fully equal to flushing the data immediately as you also wondered.
The lock macro is used for ordering and as such can be used based on 
Intel docs that were pointed.

In case there will be some provider that needs this optimization it can 
be added after finalizing above work.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
