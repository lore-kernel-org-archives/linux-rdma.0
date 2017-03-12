From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH 2/5] rds: ib: replace spin_lock_irq with spin_lock_irqsave
Date: Sat, 11 Mar 2017 22:37:39 -0800
Message-ID: <7792d93c-4f20-5bf6-4f0c-01602fcb6d76@oracle.com>
References: <1489044405-26150-1-git-send-email-yanjun.zhu@oracle.com>
 <1489044405-26150-2-git-send-email-yanjun.zhu@oracle.com>
 <65ac3de8-9fdd-b5c5-b7aa-aa4393626551@oracle.com>
 <58C4B361.6010100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <58C4B361.6010100@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Yanjun Zhu <yanjun.zhu@oracle.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 3/11/17 6:33 PM, Yanjun Zhu wrote:
> Sorry. I have no test case to show some issue.
> But from Linux Kernel Development Second Edition by Robert Love.
>
Yes I know the book and what the API does :D

> Use spin_lock_irq is dangerous since spin_unlock_irq unconditionally
> enables interrupts.
>
> We can assume the following scenario:
>
> --->the interrupt is disabled.
>
>         spin_lock_irq(lock_ptr);   <---this will disable interrupt again
>         list_del(&ic->ib_node);
>         spin_unlock_irq(lock_ptr); <---this will enable interrupt
>
> ---->the interrupt is enabled.
>
> our code change the state of interrupt. This will make potential risk.
> But spin_lock_irqsave/spin_unlock_irqrestore will not make potential risk.
>
ic is well protected for any possible race and hence I asked
if you had any test case. Please re-post the series again with
the subject patch dropper for Dave to pick it up.

Regards,
Santosh
