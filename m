From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v2 6/8] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 19:05:59 +0530
Message-ID: <CAHv-k_92-bs=0kKSdGhZ15n9roUsn1B+t9dxA+oSw=2wn8t9kw@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <5375848.bxLv0aDzDv@wuerfel> <CAHv-k__yWEaBhNYqvdjZPFpVtMKGMC75_eMh7Y4V_=MNhtzMbw@mail.gmail.com>
 <3400101.E3rphEBHnx@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3400101.E3rphEBHnx@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 25 October 2016 at 18:51, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday, October 25, 2016 6:29:45 PM CEST Binoy Jayan wrote:
>
> Something like
>
> static struct hns_roce_cmd_context *hns_roce_try_get_context(struct hns_roce_cmdq *cmd)
> {
>         struct hns_roce_cmd_context *context = NULL;
>
>         spin_lock(&cmd->context_lock);
>
>         if (cmd->free_head < 0)
>                 goto out;
>
>         context = &cmd->context[cmd->free_head];
>
>         ... /* update free_head */
>
> out:
>         spin_unlock(&cmd->context_lock);
>
>         return context;
> }
> ...
>
> static struct hns_roce_cmd_context *hns_roce_get_context(struct hns_roce_cmdq *cmd)
> {
>         struct hns_roce_cmd_context *context;
>
>         wait_event(cmd->wq, (context = hns_roce_try_get_context(cmd)));
>
>         return context;
> }

That looks more elegant. Didn't think of that, Thank you Arnd.:)
