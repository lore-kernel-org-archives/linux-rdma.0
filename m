From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 6/8] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 14:28:57 +0200
Message-ID: <5375848.bxLv0aDzDv@wuerfel>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org> <1477396919-27669-7-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477396919-27669-7-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 25, 2016 5:31:57 PM CEST Binoy Jayan wrote:
>  static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
>                                     u64 out_param, unsigned long in_modifier,
> @@ -198,11 +218,12 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
>         struct hns_roce_cmdq *cmd = &hr_dev->cmd;
>         struct device *dev = &hr_dev->pdev->dev;
>         struct hns_roce_cmd_context *context;
> -       int ret = 0;
> +       int orig_free_head, ret = 0;
> +
> +       wait_event(cmd->wq, (orig_free_head = atomic_free_node(cmd, -1)) != -1);
>  
>         spin_lock(&cmd->context_lock);
> -       WARN_ON(cmd->free_head < 0);
> -       context = &cmd->context[cmd->free_head];
> +       context = &cmd->context[orig_free_head];
>         context->token += cmd->token_mask + 1;
>         cmd->free_head = context->next;
>         spin_unlock(&cmd->context_lock);
> 

You get the lock in atomic_free_node() and then again right after that.
Why not combine the two and only take the lock inside of that
function that returns a context?

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
