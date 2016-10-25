From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 6/8] IB/hns: Replace counting semaphore event_sem with wait_event
Date: Tue, 25 Oct 2016 15:21:19 +0200
Message-ID: <3400101.E3rphEBHnx@wuerfel>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org> <5375848.bxLv0aDzDv@wuerfel> <CAHv-k__yWEaBhNYqvdjZPFpVtMKGMC75_eMh7Y4V_=MNhtzMbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHv-k__yWEaBhNYqvdjZPFpVtMKGMC75_eMh7Y4V_=MNhtzMbw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux kernel mailing list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 25, 2016 6:29:45 PM CEST Binoy Jayan wrote:
> On 25 October 2016 at 17:58, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday, October 25, 2016 5:31:57 PM CEST Binoy Jayan wrote:
> >>  static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
> >>                                     u64 out_param, unsigned long in_modifier,
> >> @@ -198,11 +218,12 @@ static int __hns_roce_cmd_mbox_wait(struct hns_roce_dev *hr_dev, u64 in_param,
> >>         struct hns_roce_cmdq *cmd = &hr_dev->cmd;
> >>         struct device *dev = &hr_dev->pdev->dev;
> >>         struct hns_roce_cmd_context *context;
> >> -       int ret = 0;
> >> +       int orig_free_head, ret = 0;
> >> +
> >> +       wait_event(cmd->wq, (orig_free_head = atomic_free_node(cmd, -1)) != -1);
> >>
> >>         spin_lock(&cmd->context_lock);
> >> -       WARN_ON(cmd->free_head < 0);
> >> -       context = &cmd->context[cmd->free_head];
> >> +       context = &cmd->context[orig_free_head];
> >>         context->token += cmd->token_mask + 1;
> >>         cmd->free_head = context->next;
> >>         spin_unlock(&cmd->context_lock);
> >>
> >
> > You get the lock in atomic_free_node() and then again right after that.
> > Why not combine the two and only take the lock inside of that
> > function that returns a context?
> 
> 
> Hi Arnd,
> 
> I couldn't figure out a way to wait for a node to be free followed by
> acquiring a lock
> in an atomic fashion. If the lock is acquired after the wait_event,
> there could be race
> between the wait_event and acquiring the lock. If the lock is acquired
> before the
> wait_event, the process may goto sleep with the lock held which is not desired.
> Could you suggest me of some way to circumvent this?

Something like

static struct hns_roce_cmd_context *hns_roce_try_get_context(struct hns_roce_cmdq *cmd)
{
	struct hns_roce_cmd_context *context = NULL;

	spin_lock(&cmd->context_lock);

	if (cmd->free_head < 0)
		goto out;

	context = &cmd->context[cmd->free_head];

	... /* update free_head */

out:
	spin_unlock(&cmd->context_lock);

	return context;
}
...

static struct hns_roce_cmd_context *hns_roce_get_context(struct hns_roce_cmdq *cmd)
{
	struct hns_roce_cmd_context *context;

	wait_event(cmd->wq, (context = hns_roce_try_get_context(cmd)));

	return context;
}

	Arnd
