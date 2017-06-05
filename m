From: Jia-Ju Bai <baijiaju1990-9Onoh4P/yGk@public.gmane.org>
Subject: Re: [PATCH V3] rxe: Fix a sleep-in-atomic bug in post_one_send
Date: Mon, 05 Jun 2017 16:40:47 +0800
Message-ID: <5935190F.7090708@163.com>
References: <1496648342-906-1-git-send-email-baijiaju1990@163.com> <CAG9sBKNKTT8ceHrXRhLRns53ejH0kwaLMy-qAzdmo=Hy5h02Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKNKTT8ceHrXRhLRns53ejH0kwaLMy-qAzdmo=Hy5h02Yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/05/2017 04:30 PM, Moni Shoua wrote:
>> -                       if (qp->is_user&&  copy_from_user(p, (__user void *)
>> -                                           (uintptr_t)sge->addr, sge->length))
>> +                       spin_unlock_irqrestore(&qp->sq.sq_lock, *flags);
>> +                       err = copy_from_user(p, (__user void *)
>> +                                       (uintptr_t)sge->addr, sge->length);
>> +                       spin_lock_irqsave(&qp->sq.sq_lock, *flags);
>> +                       if (qp->is_user&&  err)
>>                                  return -EFAULT;
> qp-_is_user is always false in this function (flow starts from
> rxe_post_send_kernel) so this line is a dead code
> In fact, this patch seems to add a serious bug when it uses
> copy_from_user() from a non user pointer.
> Do you agree?
I agree.
So, it is fine to me to remove this line, as you said in the former email:

>  Second, I think that there is no flow that leads to this function
>  when qp->is user is true so maybe the correct action is to remove this
>  line completely
>  if (qp->is_user&&  copy_from_user(p, (__user void *)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
