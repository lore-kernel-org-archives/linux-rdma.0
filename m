From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 6/8] IB/hns: Replace counting semaphore event_sem with wait condition
Date: Mon, 17 Oct 2016 22:29:57 +0200
Message-ID: <5900385.6T4BAIyXjD@wuerfel>
References: <1476721862-7070-1-git-send-email-binoy.jayan@linaro.org> <1476721862-7070-7-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476721862-7070-7-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Monday, October 17, 2016 10:01:00 PM CEST Binoy Jayan wrote:
> --- a/drivers/infiniband/hw/hns/hns_roce_cmd.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_cmd.c
> @@ -248,10 +248,14 @@ static int hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
>  {
>         int ret = 0;
>  
> -       down(&hr_dev->cmd.event_sem);
> +       wait_event(hr_dev->cmd.event_sem.wq,
> +                  atomic_add_unless(&hr_dev->cmd.event_sem.count, -1, 0));
> +
>         ret = __hns_roce_cmd_mbox_wait(hr_dev, in_param, out_param,
>                                        in_modifier, op_modifier, op, timeout);
> -       up(&hr_dev->cmd.event_sem);
> +
> +       if (atomic_inc_return(&hr_dev->cmd.event_sem.count) == 1)
> +               wake_up(&hr_dev->cmd.event_sem.wq);
>  
>         return ret;
>  }

This is the only interesting use of the event_sem that cares about
the counting and it protects the __hns_roce_cmd_mbox_wait() from being
entered too often. The count here is the number of size of the
hr_dev->cmd.context[] array.

However, that function already use a spinlock to protect that array
and pick the correct context. I think changing the inner function
to handle the case of 'no context available' by using a waitqueue
without counting anything would be a reasonable transformation
away from the semaphore.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
