From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: SQ overflow seen running isert traffic
Date: Mon, 20 Mar 2017 15:45:28 +0530
Message-ID: <20170320101526.GA11699@chelsio.com>
References: <20160927070157.GA13140@chelsio.com>
 <672d8b05-5537-d45a-ba3f-cdd5f054a4ab@grimberg.me>
 <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
 <20161108100617.GA2812@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161108100617.GA2812@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: SWise OGC <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, November 11/08/16, 2016 at 15:36:18 +0530, Potnuri Bharat Teja wrote:
>    On Monday, October 10/31/16, 2016 at 09:10:08 +0530, Nicholas A. Bellinger
>    wrote:
Hi Nicholas,
Tested the following 3 patches for SQ overflow.
https://www.spinics.net/lists/target-devel/msg13571.html
They along with an additional change added on top of those seems to hold good.( Aborts seen 
intermittently as shown at the end of mail)
I have been testing the changes using fio with IO sizes ranging from 1KB to 32MB and test is 
running fine (despite few Intermittent Aborts).

Here is what I see with the 3 patches alone applied:

-> In isert_put_datain() and isert_post_response() a corresponding recv WR is posted before
posting a send and hence for every post failure a recv is already posted into a tightly packed
RQ, causing it to overflow.

Below are the logs suggesting it:

[  189.944714] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944718] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944721] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944724] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944729] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944731] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944731] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944732] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944733] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944734] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944735] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944736] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944736] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944737] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944738] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944739] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944740] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944740] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944741] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944746] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0 failed to post RDMA res
[  189.944747] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  189.944748] isert: isert_put_datain: ib_post_recv failed with -12
[  189.944749] isert: isert_post_recv: ib_post_recv() failed with ret: -12
[  251.543847] ABORT_TASK: Found referenced iSCSI task_tag: 68
[  251.543858] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 68
[  251.544071] ABORT_TASK: Found referenced iSCSI task_tag: 46
[  251.544076] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 46
[  251.544300] ABORT_TASK: Found referenced iSCSI task_tag: 51
[  251.544307] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 51
[  251.544528] ABORT_TASK: Found referenced iSCSI task_tag: 117
[  251.544533] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 117
[  282.778402] Unable to locate ITT: 0x00000062 on CID: 0
[  282.778404] Unable to locate RefTaskTag: 0x00000062 on CID: 0.
[  282.778407] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 0
[  282.778436] ABORT_TASK: Found referenced iSCSI task_tag: 37
[  282.778439] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 37
[  282.778519] ABORT_TASK: Found referenced iSCSI task_tag: 65
[  282.778522] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 65
[  282.778559] Unable to locate ITT: 0x00000019 on CID: 0
[  282.778560] Unable to locate RefTaskTag: 0x00000019 on CID: 0.
[  282.778563] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 0
[  293.004632] ABORT_TASK: Found referenced iSCSI task_tag: 22
[  293.004643] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 22
[  293.004808] TMR Opcode TARGET_WARM_RESET authorization failed for Initiator Node: iqn.1994-05.com.redhat:37fc2b6a5331
[  310.265993] iSCSI Login timeout on Network Portal 10.0.2.2:3260
[  493.567143] INFO: task iscsi_np:3998 blocked for more than 120 seconds.
[  493.567149]       Tainted: G           OE   4.9.0-For-DSGL-Debug+ #1
[  493.567151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  493.567153] iscsi_np        D    0  3998      2 0x00000084
[  493.567159]  0000000000000000 ffff883028a88b40 ffff88302693f7c0 ffff88302de3e300
[  493.567163]  ffff88303e057a40 ffffc900008abc00 ffffffff815e415b ffffc900008abca0
[  493.567166]  ffffffff81af4180 ffff883028a88b40 7fffffffffffffff ffff882f7426db68
[  493.567170] Call Trace:
[  493.567180]  [<ffffffff815e415b>] ? __schedule+0x23b/0x6c0
[  493.567184]  [<ffffffff815e4616>] schedule+0x36/0x80
[  493.567187]  [<ffffffff815e71c3>] schedule_timeout+0x1f3/0x390
[  493.567194]  [<ffffffff812c1f2e>] ? number+0x2ce/0x300
[  493.567197]  [<ffffffff812c42be>] ? vsnprintf+0x32e/0x4b0
[  493.567199]  [<ffffffff815e56a4>] wait_for_completion+0xb4/0xf0
[  493.567201]  [<ffffffff8108a6b0>] ? wake_up_q+0x80/0x80
[  493.567216]  [<ffffffffa05284d1>] iscsit_stop_session+0x1b1/0x1c0 [iscsi_target_mod]
[  493.567220]  [<ffffffffa0519db2>] iscsi_check_for_session_reinstatement+0x1e2/0x270 [iscsi_target_mod]
[  493.567225]  [<ffffffffa051c8c0>] iscsi_target_check_for_existing_instances+0x30/0x40 [iscsi_target_mod]
[  493.567230]  [<ffffffffa051c9ee>] iscsi_target_do_login+0x11e/0x610 [iscsi_target_mod]
[  493.567235]  [<ffffffffa051dbbe>] iscsi_target_start_negotiation+0x4e/0xa0 [iscsi_target_mod]
[  493.567239]  [<ffffffffa051b933>] iscsi_target_login_thread+0xa73/0xfc0 [iscsi_target_mod]
[  493.567244]  [<ffffffffa051aec0>] ? iscsi_target_login_sess_out+0x250/0x250 [iscsi_target_mod]
[  493.567246]  [<ffffffff810660c4>] ? SyS_exit_group+0x14/0x20
[  493.567249]  [<ffffffff8107ee5a>] kthread+0xca/0xe0
[  493.567250]  [<ffffffff8107ed90>] ? kthread_park+0x60/0x60
[  493.567252]  [<ffffffff815e8752>] ret_from_fork+0x22/0x30
[  493.567254] INFO: task iscsi_trx:4149 blocked for more than 120 seconds.
[  493.567255]       Tainted: G           OE   4.9.0-For-DSGL-Debug+ #1
[  493.567256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  493.567256] iscsi_trx       D    0  4149      2 0x00000084
[  493.567258]  0000000000000000 ffff882f5ef70340 ffff882f76253040 ffff88302de40340
[  493.567259]  ffff88303e097a40 ffffc90000f93c90 ffffffff815e415b ffffffff815e56c2
[  493.567261]  0000000000000001 ffff882f5ef70340 7fffffffffffffff ffff882d233cc9b0
[  493.567262] Call Trace:
[  493.567264]  [<ffffffff815e415b>] ? __schedule+0x23b/0x6c0
[  493.567265]  [<ffffffff815e56c2>] ? wait_for_completion+0xd2/0xf0
[  493.567267]  [<ffffffff815e4616>] schedule+0x36/0x80
[  493.567268]  [<ffffffff815e71c3>] schedule_timeout+0x1f3/0x390
[  493.567281]  [<ffffffffa118e910>] ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  493.567285]  [<ffffffffa118e910>] ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  493.567286]  [<ffffffff815e56a4>] wait_for_completion+0xb4/0xf0
[  493.567287]  [<ffffffff8108a6b0>] ? wake_up_q+0x80/0x80
[  493.567302]  [<ffffffffa04d5399>] target_wait_for_sess_cmds+0x49/0x1a0 [target_core_mod]
[  493.567306]  [<ffffffffa0471644>] isert_wait_conn+0x1a4/0x2d0 [ib_isert]
[  493.567311]  [<ffffffffa05289ab>] iscsit_close_connection+0x14b/0x820 [iscsi_target_mod]
[  493.567315]  [<ffffffffa05172ef>] iscsit_take_action_for_connection_exit+0x7f/0x100 [iscsi_target_mod]
[  493.567320]  [<ffffffffa0528265>] iscsi_target_rx_thread+0x95/0xa0 [iscsi_target_mod]
[  493.567324]  [<ffffffffa05281d0>] ? iscsi_target_tx_thread+0x1b0/0x1b0 [iscsi_target_mod]
[  493.567325]  [<ffffffff8107ee5a>] kthread+0xca/0xe0
[  493.567327]  [<ffffffff8107ed90>] ? kthread_park+0x60/0x60
[  493.567328]  [<ffffffff815e8752>] ret_from_fork+0x22/0x30

-> In order to address this I tried the following (experimental) change on top of your 3 patches:

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 501a0ad124a7..0aead5faa2a2 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1817,16 +1817,16 @@ isert_post_response(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd)
        struct ib_send_wr *wr_failed;
        int ret;

-       ret = isert_post_recv(isert_conn, isert_cmd->rx_desc);
+       ret = ib_post_send(isert_conn->qp, &isert_cmd->tx_desc.send_wr,
+                          &wr_failed);
        if (ret) {
-               isert_err("ib_post_recv failed with %d\n", ret);
+               isert_err("ib_post_send failed with %d\n", ret);
                return ret;
        }

-       ret = ib_post_send(isert_conn->qp, &isert_cmd->tx_desc.send_wr,
-                          &wr_failed);
+       ret = isert_post_recv(isert_conn, isert_cmd->rx_desc);
        if (ret) {
-               isert_err("ib_post_send failed with %d\n", ret);
+               isert_err("ib_post_recv failed with %d\n", ret);
                return ret;
        }
        return ret;
@@ -2166,6 +2166,13 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
        if (isert_prot_cmd(isert_conn, se_cmd)) {
                isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
                cqe = &isert_cmd->tx_desc.tx_cqe;
+
+               rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
+               if (rc) {
+                       isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ rc: %d\n",
+                                  isert_cmd, rc);
+                       return rc;
+               }
        } else {
                /*
                 * Build isert_conn->tx_desc for iSCSI response PDU and attach
@@ -2178,18 +2185,21 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
                isert_init_send_wr(isert_conn, isert_cmd,
                                   &isert_cmd->tx_desc.send_wr);

+               chain_wr = &isert_cmd->tx_desc.send_wr;
+
+               rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
+               if (rc) {
+                       isert_err("Cmd: %p posted RDMA_WRITE for iSER Data READ rc: %d\n",
+                                  isert_cmd, rc);
+                       return rc;
+               }
+
                rc = isert_post_recv(isert_conn, isert_cmd->rx_desc);
                if (rc) {
                        isert_err("ib_post_recv failed with %d\n", rc);
                        return rc;
                }
-
-               chain_wr = &isert_cmd->tx_desc.send_wr;
        }
-       rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe, chain_wr);
-       isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ rc: %d\n",
-                  isert_cmd, rc);
-
        return rc;
 }

-> With these changes it works fine, But I still see few Aborts intermittently as follows:

[10674.434643] isert: isert_rdma_rw_ctx_post: Cmd: ffff882cbb961138 failed to post RDMA res
[10674.434690] isert: isert_rdma_rw_ctx_post: Cmd: ffff882cbb9434c0 failed to post RDMA res
[10715.186372] ABORT_TASK: Found referenced iSCSI task_tag: 58
[10715.186417] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 58

-> Apart from the Aborts and post failure logs filling dmesg, luns are in state "running" and 
fio countinues to run.
[root@bharat ~]# iscsiadm -m session -P3 | grep "Attached scsi disk"
                        Attached scsi disk sdj          State: running
                        Attached scsi disk sdc          State: running
                        Attached scsi disk sdd          State: running
                        Attached scsi disk sde          State: running
                        Attached scsi disk sdf          State: running
                        Attached scsi disk sdg          State: running
                        Attached scsi disk sdh          State: running
                        Attached scsi disk sdi          State: running

Thanks,
Bharat.
>    > Hi Steve, Potnuri, & Co,
>    >
>    > On Tue, 2016-10-18 at 09:34 -0500, Steve Wise wrote:
>    > > >
>    > > > > I tried out this change and it works fine with iwarp. I dont see
>    SQ
>    > > > > overflow. Apparently we have increased the sq too big to overflow.
>    I am
>    > > going
>    > > > > to let it run with higher workloads for longer time, to see if it
>    holds
>    > > good.
>    > > >
>    > > > Actually on second thought, this patch is an overkill. Effectively
>    we
>    > > > now set:
>    > > >
>    > > > MAX_CMD=266
>    > > > and max_rdma_ctx=128 so together we take 394 which seems to too
>    much.
>    > > >
>    > > > If we go by the scheme of 1 rdma + 1 send for each IO we need:
>    > > > - 128 sends
>    > > > - 128 rdmas
>    > > > - 10 miscs
>    > > >
>    > > > so this gives 266.
>    > > >
>    > > > Perhaps this is due to the fact that iWARP needs to register memory
>    for
>    > > > rdma reads as well? (and also rdma writes > 128k for chelsio HW
>    right?)
>    > > >
>    > >
>    > > iWARP definitely needs to register memory for the target of reads, due
>    to
>    > > REMOTE_WRITE requirement for the protocol.  The source of a write
>    doesn't need
>    > > to register memory, but the SGE depth can cause multiple WRITE WRs to
>    be
>    > > required to service the IO.  And in theory there should be some
>    threshold where
>    > > it might be better performance-wise to do a memory register + 1 WRITE
>    vs X
>    > > WRITEs.   
>    > >
>    > > As you mentioned, the RW API should account for this, but perhaps it
>    is still
>    > > off some.  Bharat, have a look into the RDMA-RW API and let us see if
>    we can
>    > > figure out if the additional SQ depth it adds is sufficient.
>    > > 
>    > > > What is the workload you are running? with immediatedata enabled you
>    > > > should issue reg+rdma_read+send only for writes > 8k.
>    > > >
>    > > > Does this happen when you run only reads for example?
>    > > >
>    > > > I guess its time to get the sq accounting into shape...
>    > >
>    > > So to sum up - 2 issues:
>    > >
>    > > 1) we believe the iSER + RW API correctly sizes the SQ, yet we're
>    seeing SQ
>    > > overflows.  So the SQ sizing needs more investigation.
>    > >
>    > > 2) if the SQ is full, then the iSER/target code is supposed to
>    resubmit.  And
>    > > apparently that isn't working.
>    > >
>    >
>    > For #2, target-core expects -ENOMEM or -EAGAIN return from fabric driver
>    > callbacks to signal internal queue-full retry logic.  Otherwise, the
>    > extra se_cmd->cmd_kref response SCF_ACK_KREF is leaked until session
>    > shutdown and/or reinstatement occurs.
>    >
>    > AFAICT, Potunri's earlier hung task with v4.8.y + ABORT_TASK is likely
>    > the earlier v4.1+ regression:
>    >
>    >
>    [1]https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e
>    >
>    > That said, there is room for improvement in target-core queue-full error
>    > signaling, and iscsi-target/iser-target callback error propagation. 
>    >
>    > Sending out a series shortly to address these particular items.
>    > Please have a look.
>    >
>    Thanks for the changes Nicholas.
>    Testing them now.
>    --
>    To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>    the body of a message to majordomo@vger.kernel.org
>    More majordomo info at  [2]http://vger.kernel.org/majordomo-info.html
> 
> References
> 
>    Visible links
>    1. https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e
>    2. http://vger.kernel.org/majordomo-info.html
