From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [BUG]kworker blocked for more than 120 seconds in IB_CM/RDMA_CM
Date: Fri, 11 Nov 2016 14:32:04 +0100
Message-ID: <CAD+HZHUF=tdeJo0bQUD8iCc+V40W1wrAPupFRFq3-VYrEuY7cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi folks,

I had warnings in our test server:

Nov  9 16:57:06 st401a-5 kernel: [193935.833022] INFO: task
kworker/1:6:32363 blocked for more than 120 seconds.
Nov  9 16:57:06 st401a-5 kernel: [193935.848942]       Tainted: G
     O    4.4.28-1-storage #1
Nov  9 16:57:06 st401a-5 kernel: [193935.865146] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  9 16:57:06 st401a-5 kernel: [193935.882059] kworker/1:6     D
ffff880a9ac77b88     0 32363      2 0x00000000
Nov  9 16:57:06 st401a-5 kernel: [193935.882066] Workqueue: ib_cm
ib_cm_listen [ib_cm]
Nov  9 16:57:06 st401a-5 kernel: [193935.882068]  ffff880a9ac77b88
ffff88103898b900 ffff88094d570000 ffff880a9ac78000
Nov  9 16:57:06 st401a-5 kernel: [193935.882070]  ffff88094d570000
ffff880074a2626c 00000000ffffffff ffff880074a26270
Nov  9 16:57:06 st401a-5 kernel: [193935.882071]  ffff880a9ac77ba0
ffffffff8158ba55 ffff880074a26268 ffff880a9ac77bb0
Nov  9 16:57:06 st401a-5 kernel: [193935.882073] Call Trace:
Nov  9 16:57:06 st401a-5 kernel: [193935.882078]  [<ffffffff8158ba55>]
schedule+0x35/0x80
Nov  9 16:57:06 st401a-5 kernel: [193935.882080]  [<ffffffff8158bcde>]
schedule_preempt_disabled+0xe/0x10
Nov  9 16:57:06 st401a-5 kernel: [193935.882082]  [<ffffffff8158d5ff>]
__mutex_lock_slowpath+0x8f/0x100
Nov  9 16:57:06 st401a-5 kernel: [193935.882084]  [<ffffffff8158d68f>]
mutex_lock+0x1f/0x30
Nov  9 16:57:06 st401a-5 kernel: [193935.882087]  [<ffffffffa033f9ff>]
rdma_destroy_id+0x78f/0x1930 [rdma_cm]
Nov  9 16:57:06 st401a-5 kernel: [193935.882092]  [<ffffffffa01ca9cb>]
? rdma_port_get_link_layer+0x1b/0x90 [ib_core]
Nov  9 16:57:06 st401a-5 kernel: [193935.882095]  [<ffffffffa01cd980>]
? ib_get_client_data+0x50/0x60 [ib_core]
Nov  9 16:57:06 st401a-5 kernel: [193935.882097]  [<ffffffffa01ca9cb>]
? rdma_port_get_link_layer+0x1b/0x90 [ib_core]
Nov  9 16:57:06 st401a-5 kernel: [193935.882100]  [<ffffffffa014823d>]
? ib_init_ah_from_path+0xfd/0x1b0 [ib_sa]
Nov  9 16:57:06 st401a-5 kernel: [193935.882103]  [<ffffffffa01cf63f>]
? ib_find_cached_pkey+0xdf/0x110 [ib_core]
Nov  9 16:57:06 st401a-5 kernel: [193935.882105]  [<ffffffffa0264376>]
ib_destroy_cm_id+0x1d6/0x630 [ib_cm]
Nov  9 16:57:06 st401a-5 kernel: [193935.882107]  [<ffffffffa0265351>]
ib_cm_listen+0xb81/0x24b5 [ib_cm]
Nov  9 16:57:06 st401a-5 kernel: [193935.882109]  [<ffffffffa02655e3>]
ib_cm_listen+0xe13/0x24b5 [ib_cm]
Nov  9 16:57:06 st401a-5 kernel: [193935.882113]  [<ffffffff8106c01d>]
process_one_work+0x14d/0x410
Nov  9 16:57:06 st401a-5 kernel: [193935.882115]  [<ffffffff8106c626>]
worker_thread+0x66/0x460
Nov  9 16:57:06 st401a-5 kernel: [193935.882117]  [<ffffffff8106c5c0>]
? rescuer_thread+0x2e0/0x2e0
Nov  9 16:57:06 st401a-5 kernel: [193935.882119]  [<ffffffff810715eb>]
kthread+0xdb/0x100
Nov  9 16:57:06 st401a-5 kernel: [193935.882121]  [<ffffffff81071510>]
? kthread_park+0x60/0x60
Nov  9 16:57:06 st401a-5 kernel: [193935.882123]  [<ffffffff8158fa9f>]
ret_from_fork+0x3f/0x70
Nov  9 16:57:06 st401a-5 kernel: [193935.882125]  [<ffffffff81071510>]
? kthread_park+0x60/0x60
Nov  9 16:59:06 st401a-5 kernel: [194055.880839] INFO: task
kworker/9:1:31073 blocked for more than 120 seconds.
Nov  9 16:59:06 st401a-5 kernel: [194055.897983]       Tainted: G
     O    4.4.28-1-storage #1


After that there were different errors on both client side and above
storage server like  cm error CM event: RDMA_CM_EVENT_UNREACHABLE,
err: -ETIMEDOUT, or RDMA_CM_EVENT_REJECTED.

Aftr reboot this storage server, pserver could establish connection again.

I checked the code path with crash:
crash> l *ib_cm_listen+0xe13
0xffffffffa01f95e3 is in cm_work_handler (drivers/infiniband/core/cm.c:3714).
3709                    break;
3710            default:
3711                    ret = -EINVAL;
3712                    break;
3713            }
3714            if (ret)
3715                    cm_free_work(work);
3716    }
3717
3718    static int cm_establish(struct ib_cm_id *cm_id)
crash> l *ib_cm_listen+0xb81
0xffffffffa01f9351 is in cm_req_handler (./arch/x86/include/asm/atomic.h:118).
113      * returns true if the result is 0, or false for all other
114      * cases.
115      */
116     static __always_inline int atomic_dec_and_test(atomic_t *v)
117     {
118             GEN_UNARY_RMWcc(LOCK_PREFIX "decl", v->counter, "%0", "e");
119     }
120
121     /**
122      * atomic_inc_and_test - increment and test

crash> l *ib_destroy_cm_id+0x1d6
0xffffffffa01f8376 is in cm_process_work (drivers/infiniband/core/cm.c:1440).
1435    {
1436            int ret;
1437
1438            /* We will typically only have the current event to report. */
1439            ret = cm_id_priv->id.cm_handler(&cm_id_priv->id,
&work->cm_event);
1440            cm_free_work(work);
1441
1442            while (!ret && !atomic_add_negative(-1,
&cm_id_priv->work_count)) {
1443                    spin_lock_irq(&cm_id_priv->lock);
1444                    work = cm_dequeue_work(cm_id_priv);
crash> l *rdma_destroy_id+0x78f
0xffffffffa031b9ff is in cma_req_handler (drivers/infiniband/core/cma.c:698).
693
694     static int cma_disable_callback(struct rdma_id_private *id_priv,
695                                     enum rdma_cm_state state)
696     {
697             mutex_lock(&id_priv->handler_mutex);
698             if (id_priv->state != state) {
699                     mutex_unlock(&id_priv->handler_mutex);
700                     return -EINVAL;
701             }
702             return 0;
crash>

During the hung task happened, there were multiple server connected to
this storage server, there were doing connection
establish/destroy/reboot/crash kinds of tests.

Likely it's could be either:
ib_cm received REQ, and call into rdma_cm cma_req_handler, but some
one hold handler_mutex  already.

Unfortunately  I don't have kdump when that happened, server was
rebooted, only netconsole log available.

I checked the code path, didn't find anything, could some one give me
some light.

Note: we're using 4.4.28 + MLNXOFED 3.3

Thanks,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
