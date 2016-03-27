From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/cm: Fix a recently introduced locking bug
Date: Sun, 27 Mar 2016 13:30:14 +0300
Message-ID: <CAAk-MO9BbZ_cpT2vQofG3DLCXfV1CAtqm1je1KE1u1Y3Gg8Pdg@mail.gmail.com>
References: <56F55A3C.2080608@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F55A3C.2080608-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 25, 2016 at 6:33 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> ib_cm_notify() can be called from interrupt context. Hence do not
> reenable interrupts unconditionally in cm_establish().
>
> This patch avoids that lockdep reports the following warning:
>
> WARNING: CPU: 0 PID: 23317 at kernel/locking/lockdep.c:2624 trace _hardirqs_on_caller+0x112/0x1b0
> DEBUG_LOCKS_WARN_ON(current->hardirq_context)
> Call Trace:
>  <IRQ>  [<ffffffff812bd0e5>] dump_stack+0x67/0x92
>  [<ffffffff81056f21>] __warn+0xc1/0xe0
>  [<ffffffff81056f8a>] warn_slowpath_fmt+0x4a/0x50
>  [<ffffffff810a5932>] trace_hardirqs_on_caller+0x112/0x1b0
>  [<ffffffff810a59dd>] trace_hardirqs_on+0xd/0x10
>  [<ffffffff815992c7>] _raw_spin_unlock_irq+0x27/0x40
>  [<ffffffffa0382e9c>] ib_cm_notify+0x25c/0x290 [ib_cm]
>  [<ffffffffa068fbc1>] srpt_qp_event+0xa1/0xf0 [ib_srpt]
>  [<ffffffffa04efb97>] mlx4_ib_qp_event+0x67/0xd0 [mlx4_ib]
>  [<ffffffffa034ec0a>] mlx4_qp_event+0x5a/0xc0 [mlx4_core]
>  [<ffffffffa03365f8>] mlx4_eq_int+0x3d8/0xcf0 [mlx4_core]
>  [<ffffffffa0336f9c>] mlx4_msi_x_interrupt+0xc/0x20 [mlx4_core]
>  [<ffffffff810b0914>] handle_irq_event_percpu+0x64/0x100
>  [<ffffffff810b09e4>] handle_irq_event+0x34/0x60
>  [<ffffffff810b3a6a>] handle_edge_irq+0x6a/0x150
>  [<ffffffff8101ad05>] handle_irq+0x15/0x20
>  [<ffffffff8101a66c>] do_IRQ+0x5c/0x110
>  [<ffffffff8159a2c9>] common_interrupt+0x89/0x89
>  [<ffffffff81297a17>] blk_run_queue_async+0x37/0x40
>  [<ffffffffa0163e53>] rq_completed+0x43/0x70 [dm_mod]
>  [<ffffffffa0164896>] dm_softirq_done+0x176/0x280 [dm_mod]
>  [<ffffffff812a26c2>] blk_done_softirq+0x52/0x90
>  [<ffffffff8105bc1f>] __do_softirq+0x10f/0x230
>  [<ffffffff8105bec8>] irq_exit+0xa8/0xb0
>  [<ffffffff8103653e>] smp_trace_call_function_single_interrupt+0x2e/0x30
>  [<ffffffff81036549>] smp_call_function_single_interrupt+0x9/0x10
>  [<ffffffff8159a959>] call_function_single_interrupt+0x89/0x90
>  <EOI>
>
> Fixes: commit be4b499323bf (IB/cm: Do not queue work to a device that's going away)
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

Acked-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
> Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2+
> ---
>  drivers/infiniband/core/cm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 1d92e09..c995255 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -3452,14 +3452,14 @@ static int cm_establish(struct ib_cm_id *cm_id)
>         work->cm_event.event = IB_CM_USER_ESTABLISHED;
>
>         /* Check if the device started its remove_one */
> -       spin_lock_irq(&cm.lock);
> +       spin_lock_irqsave(&cm.lock, flags);
>         if (!cm_dev->going_down) {
>                 queue_delayed_work(cm.wq, &work->work, 0);
>         } else {
>                 kfree(work);
>                 ret = -ENODEV;
>         }
> -       spin_unlock_irq(&cm.lock);
> +       spin_unlock_irqrestore(&cm.lock, flags);
>
>  out:
>         return ret;
> --
> 2.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
