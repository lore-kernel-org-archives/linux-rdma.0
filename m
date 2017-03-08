From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: double free on error
Date: Wed, 8 Mar 2017 18:42:44 +0200
Message-ID: <CAG9sBKOB5Zg7EB7Xr0dCSWjCk7W4RajOjT=yqOav+0ddYWxhKA@mail.gmail.com>
References: <20170308052152.GA31503@mwanda> <20170308065829.GV14379@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308065829.GV14379-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> This rxe_xmit_packet() looks a little bit awkward. It calls to
> kfree_skb and returns ret = 0 after drop decision. It doesn't
> free on error (ret != 0), but this rxe_requester does.
>
> However in case of not error, the skb won't be released and goto
> next_cqe will be called, which has a lot of exit paths without freeing
> skb.
>
> Moni, Yonatan
> Is it done on purpose?
>
>
In good flow skb will be freed when going down the chain call from
rxe_xmit_packet(). This is the design.
In bad flow we can immediately free the skb

>>       if (ret) {
>>               qp->need_req_skb = 1;
>> -             kfree_skb(skb);
>>
>>               rollback_state(wqe, qp, &rollback_wqe, rollback_psn);
>>
>>               if (ret == -EAGAIN) {
>> +                     kfree_skb(skb);
>>                       rxe_run_task(&qp->req.task, 1);
>>                       goto exit;
>>               }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
