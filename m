From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/mlx5: Use tasklet to decrease completions
 processing time in interrupts
Date: Sun, 15 May 2016 10:31:57 +0300
Message-ID: <868e5bcf-18c5-30f4-fe3f-b361c0ce43ec@mellanox.com>
References: <1460902121-5567-1-git-send-email-matanb@mellanox.com>
 <20160418130456.GA11508@infradead.org> <5714DF68.6040509@mellanox.com>
 <a93b20ca-42bf-ca2b-2995-aa2837a1bafe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a93b20ca-42bf-ca2b-2995-aa2837a1bafe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13/05/2016 23:16, Doug Ledford wrote:
> On 04/18/2016 09:21 AM, Matan Barak (External) wrote:
>> On 18/04/2016 16:04, Christoph Hellwig wrote:
>>> On Sun, Apr 17, 2016 at 05:08:39PM +0300, Matan Barak wrote:
>>>> Hi Doug,
>>>>
>>>> The mlx5 driver handles completion callbacks inside interrupts.
>>>> These callbacks could be lengthy and thus cause hard lockups.
>>>> In order to avoid these lockups, we introduce a tasklet mechanism.
>>>> The mlx5_ib driver uses this mechanism in order to defer its
>>>> completion callbacks processing to the tasklet.
>>>>
>>>> This follows the same mechanism we implemented for mlx4 that
>>>> successfully decreased the processing time in interrupts.
>>>
>>> Just curious:  how much of this time is spent inside the mlx5 driver,
>>> and how much is spent in the callbacks from the consumers?  We've now
>>> more than half done with switch the kernel ULPs to the new CQ API
>>> which will always offload the callbacks to softirq or workqueue context,
>>> so if we can avoid a previous offload the completions would be a lot
>>> more efficient.
>>>
>>
>> In short, you could hit a situation where processing the completions in
>> the interrupt takes longer than the rate at which they arrive (lab cases
>> that use one event queue, but still).
>> I agree that going to softirqs/WQs (like the rest of the offloads) is a
>> good solution too - maybe even better than this one as the mechanism
>> already exists, but why would it be a lot more efficient?
>>
>
> Given the amount of the kernel converted to the new CQ API, are you guys
> still looking to have this included?
>

Using irqpoll might be better, although - If I got things right it 
really polls the CQ instead of just notifying the user-space it has some 
work to do (because it handles kernel usages probably). So, in order to 
use the current approach for user-space, we might needs to change it a 
bit (unless I missed something).

Saying that, because we're risking here at having a hard lockup and the 
mlx4 driver already uses this proposed method successfully, I'll be very 
happy if we can merge this and look at migrating to the new CQ API later 
if it makes sense here.

Regards,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
