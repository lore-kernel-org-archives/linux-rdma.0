From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Tue, 24 Jan 2017 14:59:30 -0700
Message-ID: <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
 <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c7f1af87-a846-ed8a-a46e-ab5888ea9b92-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 24, 2017 at 3:37 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Robert,
> can you please try replacing the ib_drain_qp with ib_drain_rq ? or make sure
> ib_drain_qp don't stuck.
> in the past (before v4.6) we sent "recv_beacon" on the isert disconnect
> flow.
> I suspect that area.
>
> Max.

It is getting stuck in target_wait_for_sess_cmds. ib_drain_qp is
returning just fine. I put in a bunch of debug statements and here is
a clip of them from a previous test.

[Tue Jan  3 16:55:24 2017] Starting iscsit_close_connection.
[Tue Jan  3 16:55:24 2017] Calling flush_workqueue.
[Tue Jan  3 16:55:24 2017] Returned from flush_workqueue.
[Tue Jan  3 16:55:25 2017] isert_wait_conn calling ib_close_qp/ib_drain_qp.
[Tue Jan  3 16:55:25 2017] isert_wait_conn finished ib_close_qp/ib_drain_qp.
[Tue Jan  3 16:55:25 2017] isert_wait_conn calling isert_put_unsol_pending_cmds.
[Tue Jan  3 16:55:25 2017] isert_wait_conn returned from
isert_put_unsol_pending_cmds.
[Tue Jan  3 16:55:25 2017] isert_wait_conn calling isert_wait4cmds.
[Tue Jan  3 16:55:25 2017] isert_wait4cmds calling
target_sess_cmd_list_set_waiting.
[Tue Jan  3 16:55:25 2017] isert_wait4cmds returned from
target_sess_cmd_list_set_waiting.
[Tue Jan  3 16:55:25 2017] isert_wait4cmds calling target_wait_for_sess_cmds.
[Tue Jan  3 16:55:25 2017] Waiting for se_cmd: ffff887ebf88bd00
t_state: 6, fabric state: 29
[Tue Jan  3 16:55:25 2017] target_wait_for_sess_cmds calling
spin_unlock_irqrestore.
[Tue Jan  3 16:55:25 2017] target_wait_for_sess_cmds calling
wait_for_completion.
[Tue Jan  3 16:55:26 2017] Calling wait_for_common.
[Tue Jan  3 16:55:27 2017] Starting __wait_for_common.
[Tue Jan  3 16:55:27 2017] Calling do_wait_for_common.
[Tue Jan  3 16:55:27 2017] Starting do_wait_for_common with x->done = 0.
[Tue Jan  3 16:55:27 2017] x->done = 0.
[Tue Jan  3 16:55:27 2017] Calling __set_current_state.
[Tue Jan  3 16:55:27 2017] Calling spin_unlock_irq.
[Tue Jan  3 16:55:27 2017] Calling action(7fffffffffffffff).
[Tue Jan  3 16:55:27 2017] Starting schedule_timeout with timeout
7fffffffffffffff (7fffffffffffffff).
[Tue Jan  3 16:55:27 2017] Starting schedule() in switch.
[Tue Jan  3 16:55:27 2017] Finished schedule() in switch.
[Tue Jan  3 16:55:27 2017] Calling spin_lock_irq.
[Tue Jan  3 16:55:27 2017] Calling __remove_wait_queue.
[Tue Jan  3 16:55:27 2017] Returned from __remove_wait_queue.
[Tue Jan  3 16:55:27 2017] Finished do_wait_for_common with x->done = 0.
[Tue Jan  3 16:55:27 2017] Returned from do_wait_for_common.
[Tue Jan  3 16:55:27 2017] Finished __wait_for_common.
[Tue Jan  3 16:55:27 2017] Returned from wait_for_common.
[Tue Jan  3 16:55:27 2017] Calling wait_for_common.
[Tue Jan  3 16:55:27 2017] Starting __wait_for_common.
[Tue Jan  3 16:55:27 2017] Calling do_wait_for_common.
[Tue Jan  3 16:55:27 2017] Starting do_wait_for_common with x->done = 0.
[Tue Jan  3 16:55:27 2017] x->done = 0.
[Tue Jan  3 16:55:27 2017] Calling __set_current_state.
[Tue Jan  3 16:55:27 2017] Calling spin_unlock_irq.
[Tue Jan  3 16:55:27 2017] Calling action(7fffffffffffffff).
[Tue Jan  3 16:55:27 2017] Starting schedule_timeout with timeout
7fffffffffffffff (7fffffffffffffff).
[Tue Jan  3 16:55:27 2017] Starting schedule() in switch.
[Tue Jan  3 16:55:27 2017] Finished schedule() in switch.
[Tue Jan  3 16:55:27 2017] Calling spin_lock_irq.
[Tue Jan  3 16:55:27 2017] Calling __remove_wait_queue.

If you think changing ib_drain_qp to ib_drain_rq might still help, I can do it.

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
