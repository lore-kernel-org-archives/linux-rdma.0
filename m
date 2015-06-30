From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use flow-counters for process_mad only when
 appropriate
Date: Tue, 30 Jun 2015 12:28:55 +0300
Message-ID: <55926157.8030400@mellanox.com>
References: <1435243538-26937-1-git-send-email-ogerlitz@mellanox.com>
 <CAJ3xEMjtgvK_FfYi0DNz4rhgRv-Aj__ahf3BuA-KmrZVWVUOdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjtgvK_FfYi0DNz4rhgRv-Aj__ahf3BuA-KmrZVWVUOdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/28/2015 1:33 PM, Or Gerlitz wrote:
> On Thu, Jun 25, 2015 at 5:45 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> For IB links, reading HCA flow counters through iboe_process_mad() should
>> be used when mlx4_ib_process_mad() is invoked only for VFs PMA queries and
>> exactly nothing else.
>>
>> Fixes: 7193a141eb74 ('IB/mlx4: Set VF to read from QP counters')
>> Reported-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>
>> Hi Doug, Dave
>>
>> Doug, I've rebased the patch on top of Ira's fix [1], also you would need to merge the mlx4 (7193a141eb74 etc) changes that went-in through net-next for the patch to apply -- simply fetch from the latest upstream tree, they're there.
> Doug, we still have few concerns re the original patch... please wait
> few days with this one till we are sure it's the right fix.

OK, we made the extra review and checks, the fix is the correct one, 
please go ahead and pick it up. As the bug was introduced in the 4.2 
merge window, no need for -stable here.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
