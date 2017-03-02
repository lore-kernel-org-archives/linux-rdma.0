From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: mlx5_ib_post_send stuck?
Date: Wed, 1 Mar 2017 20:04:36 -0700
Message-ID: <CAANLjFoU7ObzLmNgpOirP=_XQust3SvYKo_SQFfMD9zZYRN6rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've been trying to track down a hang in iSERT that requires rebooting
our target and is very inconvenient. Our environment is very
complicated so I've tried to reproduce the problem on a much simpler
config. I believe I have a situation that triggers the same backtrace
(it is hard to know 100% because our production is on 4.4 and
Infiniband and my test is on 4.9.0 with RoCE, but they look very
similar). I found that there is a bug in iSER (initiator) that
triggers the target hang with the ConnectX-4-LX cards. This commit
fixes the initiator side, but does not fix the target side, so I keep
leveraging the bug to track down the target bug. I include it here in
the case it adds useful information.

commit 24be606cd3b433412488ce962842489fe6e34a7a
Author: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Jan 18 00:40:39 2017 +0200

    IB/iser: Fix sg_tablesize calculation

    commit 1e5db6c31ade4150c2e2b1a21e39f776c38fea39 upstream.

    For devices that can register page list that is bigger than
    USHRT_MAX, we actually take the wrong value for sg_tablesize.
    E.g: for CX4 max_fast_reg_page_list_len is 65536 (bigger than USHRT_MAX)
    so we set sg_tablesize to 0 by mistake. Therefore, each IO that is
    bigger than 4k splitted to "< 4k" chunks that cause performance degredation.
    Remove wrong sg_tablesize assignment, and use the value that was set during
    address resolution handler with the needed casting.

    Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c
b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 64b3d11..140f3f3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -651,13 +651,6 @@ static void iscsi_iser_cleanup_task(struct
iscsi_task *task)
                                                   SHOST_DIX_GUARD_CRC);
                }

-               /*
-                * Limit the sg_tablesize and max_sectors based on the device
-                * max fastreg page list length.
-                */
-               shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
-
ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
-
                if (iscsi_host_add(shost,
                                   ib_conn->device->ib_device->dma_device)) {
                        mutex_unlock(&iser_conn->state_mutex);

Based on the backtraces produced by the target, it looks like there is
something in mlx5_ib_post_send that may be wonky such that the send Q
can't be drained.

[  369.794100] INFO: task iscsi_np:6998 blocked for more than 120 seconds.
[  369.794891]       Not tainted 4.9.0+ #5
[  369.795689] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  369.796525] iscsi_np        D    0  6998      2 0x00000084
[  369.797379]  ffff887f5e275d00 0000000000000000 ffff887f66650000
ffff887f7f219300
[  369.798275]  ffff887f3c691600 ffffc9003293fbf0 ffffffff816d86d5
ffff88807ffdba00
[  369.799190]  0000000200000000 0000000000000000 ffff887f3c691600
7fffffffffffffff
[  369.800120] Call Trace:
[  369.801041]  [<ffffffff816d86d5>] ? __schedule+0x195/0x630
[  369.801977]  [<ffffffff816d8ba6>] schedule+0x36/0x80
[  369.802921]  [<ffffffff816dbdbc>] schedule_timeout+0x21c/0x3a0
[  369.803877]  [<ffffffff8135fcbe>] ? vsnprintf+0x34e/0x4d0
[  369.804833]  [<ffffffff816d9682>] wait_for_completion+0xf2/0x130
[  369.805760]  [<ffffffff810b84b0>] ? wake_up_q+0x80/0x80
[  369.806666]  [<ffffffffa07a1701>] iscsit_stop_session+0x1b1/0x1c0
[iscsi_target_mod]
[  369.807600]  [<ffffffffa0792e72>]
iscsi_check_for_session_reinstatement+0x1e2/0x270 [iscsi_target_mod]
[  369.808572]  [<ffffffffa0795870>]
iscsi_target_check_for_existing_instances+0x30/0x40 [iscsi_target_mod]
[  369.809562]  [<ffffffffa07959b8>] iscsi_target_do_login+0x138/0x630
[iscsi_target_mod]
[  369.810562]  [<ffffffffa0796bce>]
iscsi_target_start_negotiation+0x4e/0xa0 [iscsi_target_mod]
[  369.811577]  [<ffffffffa079476e>]
__iscsi_target_login_thread+0x83e/0xf20 [iscsi_target_mod]
[  369.812597]  [<ffffffff816d8601>] ? __schedule+0xc1/0x630
[  369.813639]  [<ffffffffa0794e50>] ?
__iscsi_target_login_thread+0xf20/0xf20 [iscsi_target_mod]
[  369.814722]  [<ffffffffa0794e74>]
iscsi_target_login_thread+0x24/0x30 [iscsi_target_mod]
[  369.815819]  [<ffffffff810abbb9>] kthread+0xd9/0xf0
[  369.816861]  [<ffffffff810abae0>] ? kthread_park+0x60/0x60
[  369.817909]  [<ffffffff816dd4d5>] ret_from_fork+0x25/0x30
[  369.819118] INFO: task iscsi_trx:8458 blocked for more than 120 seconds.
[  369.820435]       Not tainted 4.9.0+ #5
[  369.821754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  369.823135] iscsi_trx       D    0  8458      2 0x00000084
[  369.824533]  ffff887f5e724d80 0000000000000000 ffff887f66659600
ffff887f7f399300
[  369.825984]  ffff883f5f7a9600 ffffc90035687b70 ffffffff816d86d5
0000000000000000
[  369.827189]  ffff887f65e12400 ffffc90035687b50 ffff883f5f7a9600
7fffffffffffffff
[  369.828283] Call Trace:
[  369.829369]  [<ffffffff816d86d5>] ? __schedule+0x195/0x630
[  369.830475]  [<ffffffff816d8ba6>] schedule+0x36/0x80
[  369.831575]  [<ffffffff816dbdbc>] schedule_timeout+0x21c/0x3a0
[  369.832698]  [<ffffffffa05b9e58>] ? mlx5_ib_post_send+0xc8/0x1750 [mlx5_ib]
[  369.833819]  [<ffffffff816d9682>] wait_for_completion+0xf2/0x130
[  369.834956]  [<ffffffff810b84b0>] ? wake_up_q+0x80/0x80
[  369.836130]  [<ffffffffa04c7b10>] __ib_drain_sq+0x190/0x1c0 [ib_core]
[  369.837234]  [<ffffffffa04c7960>] ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  369.838342]  [<ffffffffa04c7b65>] ib_drain_sq+0x25/0x30 [ib_core]
[  369.839435]  [<ffffffffa04c7d72>] ib_drain_qp+0x12/0x30 [ib_core]
[  369.840519]  [<ffffffffa049e5ff>] isert_wait_conn+0x5f/0x2d0 [ib_isert]
[  369.841621]  [<ffffffffa07a1be7>]
iscsit_close_connection+0x157/0x860 [iscsi_target_mod]
[  369.842747]  [<ffffffff81003a47>] ? do_syscall_64+0x67/0x180
[  369.843877]  [<ffffffffa079031b>]
iscsit_take_action_for_connection_exit+0x7b/0xf0 [iscsi_target_mod]
[  369.845037]  [<ffffffffa07a1495>] iscsi_target_rx_thread+0x95/0xa0
[iscsi_target_mod]
[  369.846189]  [<ffffffffa07a1400>] ?
iscsi_target_tx_thread+0x1d0/0x1d0 [iscsi_target_mod]
[  369.847276]  [<ffffffff810abbb9>] kthread+0xd9/0xf0
[  369.848333]  [<ffffffff810abae0>] ? kthread_park+0x60/0x60
[  369.849391]  [<ffffffff816dd4d5>] ret_from_fork+0x25/0x30

So I added some debug statements in the mlx5 driver.

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d1e9218..ce5180e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3812,6 +3812,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
ib_send_wr *wr,
        u8 next_fence = 0;
        u8 fence;

+       printk("Starting mlx5_ib_post_send.\n");
        if (unlikely(ibqp->qp_type == IB_QPT_GSI))
                return mlx5_ib_gsi_post_send(ibqp, wr, bad_wr);

@@ -3828,7 +3829,9 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
ib_send_wr *wr,
                goto out;
        }

+       printk("mips: start iterating through wr.\n");
        for (nreq = 0; wr; nreq++, wr = wr->next) {
+               printk("mips: nreq=%d\n", nreq);
                if (unlikely(wr->opcode >= ARRAY_SIZE(mlx5_ib_opcode))) {
                        mlx5_ib_warn(dev, "\n");
                        err = -EINVAL;
@@ -3847,12 +3850,14 @@ int mlx5_ib_post_send(struct ib_qp *ibqp,
struct ib_send_wr *wr,

                err = begin_wqe(qp, &seg, &ctrl, wr, &idx, &size, nreq);
                if (err) {
+                       printk("mips: begin_wqe error: %d\n", err);
                        mlx5_ib_warn(dev, "\n");
                        err = -ENOMEM;
                        *bad_wr = wr;
                        goto out;
                }

+               printk("mips: Starting qp_type switch on %d\n", ibqp->qp_type);
                switch (ibqp->qp_type) {
                case IB_QPT_XRC_INI:
                        xrc = seg;
@@ -3994,6 +3999,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
ib_send_wr *wr,
                                seg = mlx5_get_send_wqe(qp, 0);
                        break;
                case IB_QPT_UD:
+                       printk("mips: Starting IB_QPT_UD case.\n");
+                       dump_wqe(qp, idx, size);
                        set_datagram_seg(seg, wr);
                        seg += sizeof(struct mlx5_wqe_datagram_seg);
                        size += sizeof(struct mlx5_wqe_datagram_seg) / 16;
@@ -4015,6 +4022,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
ib_send_wr *wr,
                                if (unlikely((seg == qend)))
                                        seg = mlx5_get_send_wqe(qp, 0);
                        }
+                       printk("mips: Finished IB_QPT_UD case.\n");
                        break;
                case MLX5_IB_QPT_REG_UMR:
                        if (wr->opcode != MLX5_IB_WR_UMR) {
@@ -4070,11 +4078,12 @@ int mlx5_ib_post_send(struct ib_qp *ibqp,
struct ib_send_wr *wr,
                           get_fence(fence, wr), next_fence,
                           mlx5_ib_opcode[wr->opcode]);
 skip_psv:
-               if (0)
+               if (1)
                        dump_wqe(qp, idx, size);
        }

 out:
+       printk("mips: out.\n");
        if (likely(nreq)) {
                qp->sq.head += nreq;

@@ -4115,6 +4124,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct
ib_send_wr *wr,

        spin_unlock_irqrestore(&qp->sq.lock, flags);

+       printk("Finished mlx5_ib_post_send.\n");
        return err;
 }

And running `echo "func dump_wqe +p" >
/sys/kernel/debug/dynamic_debug/control` gives:

[  170.268608] Starting mlx5_ib_post_send.
[  170.268609] mips: start iterating through wr.
[  170.268609] mips: nreq=0
[  170.268610] mips: Starting qp_type switch on 2
[  170.268611] dump wqe at ffff887f30fa78c0
[  170.268612] 0089a30a 00011b02 00000008 00000000
[  170.268613] 0000004c 00183b51 0000007f 30f53858
[  170.268613] mips: out.
[  170.268614] Finished mlx5_ib_post_send.
[  170.268615] Starting mlx5_ib_post_send.
[  170.268615] mips: start iterating through wr.
[  170.268616] mips: nreq=0
[  170.268616] mips: Starting qp_type switch on 2
[  170.268617] dump wqe at ffff887f30fa7900
[  170.268618] 0089a40a 00011b02 00000008 00000000
[  170.268619] 0000004c 00183b51 0000007f 30f5b700
[  170.268619] mips: out.
[  170.268620] Finished mlx5_ib_post_send.
[  170.268621] Starting mlx5_ib_post_send.
[  170.268621] mips: start iterating through wr.
[  170.268622] mips: nreq=0
[  170.268623] mips: Starting qp_type switch on 2
[  170.268623] dump wqe at ffff887f30fa7940
[  170.268624] 0089a50a 00011b02 00000008 00000000
[  170.268625] 0000004c 00183b51 0000007f 30f52038
[  170.268626] mips: out.
[  170.268626] Finished mlx5_ib_post_send.
[  171.175601] Starting mlx5_ib_post_send.
[  171.176342] mips: start iterating through wr.
[  171.176620] systemd-journald[871]: /dev/kmsg buffer overrun, some
messages lost.
[  171.177814] mips: nreq=0
[  171.178628] mips: Starting qp_type switch on 2
[  171.179427] dump wqe at ffff887f30fa7980
[  171.179429] 0089a60a 00011b02 00000008 00000000
[  171.179431] 0000004c 00183b51 0000007f 30f4eff8
[  171.179432] mips: out.
[  171.180203] Finished mlx5_ib_post_send.
[  181.674314] Starting mlx5_ib_post_send.
[  181.675136] Starting mlx5_ib_post_send.
[  181.675926] mips: start iterating through wr.
[  181.676721] mips: nreq=0
[  181.677509] mips: Starting qp_type switch on 4
[  181.678323] mips: Starting IB_QPT_UD case.
[  181.679133] dump wqe at ffff887f4ac04180
[  181.679135] 00000000 00000000 00000008 00000000
[  181.679136] mips: Finished IB_QPT_UD case.
[  181.679933] dump wqe at ffff887f4ac04180
[  181.679934] 0000060a 00009706 00000008 00000000
[  181.679936] 80000000 00000000 80000001 30000000
[  181.679937] 00000000 0cc47a88 07310040 40200000
[  181.679939] 00000000 00000000 0000ffff c0a80b0e
[  181.679940] 00000018 00001202 0000007f 5d9f8000
[  181.679941] 000000e8 00001202 0000007f 5d9f8018
[  181.679942] mips: out.
[  181.680728] Finished mlx5_ib_post_send.
[  181.681588] Starting mlx5_ib_post_send.
[  181.682390] mips: start iterating through wr.
[  181.683197] mips: nreq=0
[  181.683997] mips: Starting qp_type switch on 2
[  181.684807] dump wqe at ffff887f30fa79c0
[  181.684809] 0089a708 00011b02 00000000 00000000
[  181.684810] 00000000 00000006 00000000 00000000
[  181.684811] mips: out.
[  181.685626] Finished mlx5_ib_post_send.
[  183.733919] Starting mlx5_ib_post_send.
[  183.734734] Starting mlx5_ib_post_send.
[  183.735530] mips: start iterating through wr.
[  183.736329] mips: nreq=0
[  183.737122] mips: Starting qp_type switch on 4
[  183.737926] mips: Starting IB_QPT_UD case.
[  183.738724] dump wqe at ffff887f4ac04200
[  183.738726] 00000000 00000000 00000008 00000000
[  183.738727] mips: Finished IB_QPT_UD case.
[  183.739517] dump wqe at ffff887f4ac04200
[  183.739519] 0000080a 00009706 00000008 00000000
[  183.739521] 80000000 00000000 80000001 30000000
[  183.739522] 00000000 0cc47a88 07310040 40200000
[  183.739523] 00000000 00000000 0000ffff c0a80b0e
[  183.739525] 00000018 00001202 0000007f 653ddc00
[  183.739526] 000000e8 00001202 0000007f 653ddc18
[  183.739527] mips: out.
[  183.740315] Finished mlx5_ib_post_send.
[  198.786376] iSCSI Login timeout on Network Portal 0.0.0.0:3260
[  200.962188] Starting mlx5_ib_post_send.
[  200.963030] Starting mlx5_ib_post_send.
[  200.963845] mips: start iterating through wr.
[  200.964672] mips: nreq=0
[  200.965507] mips: Starting qp_type switch on 4
[  200.966338] mips: Starting IB_QPT_UD case.
[  200.967171] dump wqe at ffff887f4ac04280
[  200.967173] 00000000 00000000 00000008 00000000
[  200.967174] mips: Finished IB_QPT_UD case.
[  200.967995] dump wqe at ffff887f4ac04280
[  200.967997] 00000a0a 00009706 00000008 00000000
[  200.967998] 80000000 00000000 80000001 30000000
[  200.968000] 00000000 0cc47a88 07310040 40200000
[  200.968001] 00000000 00000000 0000ffff c0a80b0e
[  200.968003] 00000018 00001202 0000007f 653dd400
[  200.968004] 000000e8 00001202 0000007f 653dd418
[  200.968005] mips: out.
[  200.968815] Finished mlx5_ib_post_send.

During the test it seems that for the most part wqe stays pretty
small, but when the 'issue' starts to happen (at 181) there is more
stuff there. The interesting thing is that by adding these statements,
the test is able to run longer than without them. It usually hangs
within the first 1 GB, but with this patch, it goes for a few GB
before hanging.

Sagi has been very helpful so far, but he thinks there might be
something in the driver preventing the queue from being drained. I
don't understand the output to know what it means. Based on what I've
seen during the disconnection of iSER, it seemed that qp_type 4 is
what was hanging, but the problem may have been on a different type
before then. I tried dumping wqe for each op, but it would cause the
box to be unresponsive.

I'd appreciate any ideas on how to troubleshoot this.

Thank you,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
