From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [PATCH v2 6/8] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 18:29:45 +0530
Message-ID: <CAHv-k__yWEaBhNYqvdjZPFpVtMKGMC75_eMh7Y4V_=MNhtzMbw@mail.gmail.com>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org>
 <1477396919-27669-7-git-send-email-binoy.jayan@linaro.org> <5375848.bxLv0aDzDv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5375848.bxLv0aDzDv@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 25 October 2016 at 17:58, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday, October 25, 2016 5:31:57 PM CEST Binoy Jayan wrote:
>>  static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
>>                                     u64 out_param, unsigned long in_modifier,
>> @@ -198,11 +218,12 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
>>         struct hns_roce_cmdq *cmd = &hr_dev->cmd;
>>         struct device *dev = &hr_dev->pdev->dev;
>>         struct hns_roce_cmd_context *context;
>> -       int ret = 0;
>> +       int orig_free_head, ret = 0;
>> +
>> +       wait_event(cmd->wq, (orig_free_head = atomic_free_node(cmd, -1)) != -1);
>>
>>         spin_lock(&cmd->context_lock);
>> -       WARN_ON(cmd->free_head < 0);
>> -       context = &cmd->context[cmd->free_head];
>> +       context = &cmd->context[orig_free_head];
>>         context->token += cmd->token_mask + 1;
>>         cmd->free_head = context->next;
>>         spin_unlock(&cmd->context_lock);
>>
>
> You get the lock in atomic_free_node() and then again right after that.
> Why not combine the two and only take the lock inside of that
> function that returns a context?


Hi Arnd,

I couldn't figure out a way to wait for a node to be free followed by
acquiring a lock
in an atomic fashion. If the lock is acquired after the wait_event,
there could be race
between the wait_event and acquiring the lock. If the lock is acquired
before the
wait_event, the process may goto sleep with the lock held which is not desired.
Could you suggest me of some way to circumvent this?

-Binoy
