From: Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: SQ overflow seen running isert traffic
Date: Tue, 21 Mar 2017 13:21:34 +0530
Message-ID: <20170321075131.GA11565@chelsio.com>
References: <20161017111655.GA21245@chelsio.com>
 <021001d228a4$6cd6a6c0$4683f440$@opengridcomputing.com>
 <c4ee3313-9e67-f30a-3679-4c9afab79ac9@grimberg.me>
 <20161018112801.GA3117@chelsio.com>
 <ed7ebb39-be81-00b3-ef23-3f4c0e3afbb1@grimberg.me>
 <005101d2294c$be5bb460$3b131d20$@opengridcomputing.com>
 <1477885208.27946.8.camel@haakon3.risingtidesystems.com>
 <20161108100617.GA2812@chelsio.com>
 <20170320101526.GA11699@chelsio.com>
 <1490077940.8236.77.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490077940.8236.77.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: SWise OGC <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday, March 03/21/17, 2017 at 12:02:20 +0530, Nicholas A. Bellinger wrote:
>    Hi Bharat & Co,
> 
>    On Mon, 2017-03-20 at 15:45 +0530, Potnuri Bharat Teja wrote:
>    > On Tuesday, November 11/08/16, 2016 at 15:36:18 +0530, Potnuri Bharat
>    Teja wrote:
>    > >    On Monday, October 10/31/16, 2016 at 09:10:08 +0530, Nicholas A.
>    Bellinger
>    > >    wrote:
>    > Hi Nicholas,
>    > Tested the following 3 patches for SQ overflow.
>    > [1]https://www.spinics.net/lists/target-devel/msg13571.html
> 
>    Thanks for following up on this.
> 
>    I was just thinking about sending these patches out again, as separate
>    from iser-target bits in patch #3 (and your incremental below) they do
>    address a couple of long-standing target-core issues wrt queue-full
>    handling.
> 
>    > They along with an additional change added on top of those seems to hold
>    good.( Aborts seen
>    > intermittently as shown at the end of mail)
>    > I have been testing the changes using fio with IO sizes ranging from 1KB
>    to 32MB and test is
>    > running fine (despite few Intermittent Aborts).
>    >
> 
>    At what I/O size do the post RDMA_WRITE failures for iw_cxgb4 and
>    associated TMR ABORT_TASK begin..?
Hi Nicholas,
I see them from 2MB onwards.
> 
>    > Here is what I see with the 3 patches alone applied:
>    >
>    > -> In isert_put_datain() and isert_post_response() a corresponding recv
>    WR is posted before
>    > posting a send and hence for every post failure a recv is already posted
>    into a tightly packed
>    > RQ, causing it to overflow.
> 
>    Just for me to understand, the intermittent TMR ABORT_TASKs are caused
>    by the repeated failure to post RDMA_WRITE WRs for a large ISER Data-In
>    payload, due to mis-sizing of needed WRs from RDMA R/W API vs.
>    underlying hardware capabilities.
Yes.
> 
>    Moving the recv posts after the send post for RDMA_WRITEs helps to
>    reduce the severity of the issue with iw_cxgb4, but doesn't completely
>    eliminate the issue under load.
Moving recv posts only comes in to effect along with your changes.
> 
>    >
>    > Below are the logs suggesting it:
>    >
>    > [  189.944714] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944718] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944721] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944724] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944729] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944731] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944731] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944732] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944733] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944734] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944735] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944736] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944736] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944737] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944738] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944739] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944740] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944740] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944741] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944746] isert: isert_rdma_rw_ctx_post: Cmd: ffff882d233e83d0
>    failed to post RDMA res
>    > [  189.944747] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
>    > [  189.944748] isert: isert_put_datain: ib_post_recv failed with -12
>    > [  189.944749] isert: isert_post_recv: ib_post_recv() failed with ret:
>    -12
> 
>    Mmmm, why does the retry of isert_put_datain() stop here..?
It is because the iser command continues to loop failing to post either with SQ 
or RQ failure and reties reposting. Subsequently iser command times out on the 
Initiator and aborts the command.
>
>    Does this delay between the last isert_put_datain() retry and subsequent
>    TMR ABORT_TASKs happen with your incremental patch applied too..?
With my changes applied, I see a few aborts with high IO sizes like 
32MB, 16MB etc. I dont see login time out failure with incremental patch.
> 
>    > [  251.543847] ABORT_TASK: Found referenced iSCSI task_tag: 68
>    > [  251.543858] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 68
>    > [  251.544071] ABORT_TASK: Found referenced iSCSI task_tag: 46
>    > [  251.544076] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 46
>    > [  251.544300] ABORT_TASK: Found referenced iSCSI task_tag: 51
>    > [  251.544307] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 51
>    > [  251.544528] ABORT_TASK: Found referenced iSCSI task_tag: 117
>    > [  251.544533] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag:
>    117
>    > [  282.778402] Unable to locate ITT: 0x00000062 on CID: 0
>    > [  282.778404] Unable to locate RefTaskTag: 0x00000062 on CID: 0.
>    > [  282.778407] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
>    0
>    > [  282.778436] ABORT_TASK: Found referenced iSCSI task_tag: 37
>    > [  282.778439] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 37
>    > [  282.778519] ABORT_TASK: Found referenced iSCSI task_tag: 65
>    > [  282.778522] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 65
>    > [  282.778559] Unable to locate ITT: 0x00000019 on CID: 0
>    > [  282.778560] Unable to locate RefTaskTag: 0x00000019 on CID: 0.
>    > [  282.778563] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag:
>    0
>    > [  293.004632] ABORT_TASK: Found referenced iSCSI task_tag: 22
>    > [  293.004643] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 22
>    > [  293.004808] TMR Opcode TARGET_WARM_RESET authorization failed for
>    Initiator Node: iqn.1994-05.com.redhat:37fc2b6a5331
>    > [  310.265993] iSCSI Login timeout on Network Portal 10.0.2.2:3260
>    > [  493.567143] INFO: task iscsi_np:3998 blocked for more than 120
>    seconds.
>    > [  493.567149]       Tainted: G           OE   4.9.0-For-DSGL-Debug+ #1
>    > [  493.567151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>    disables this message.
>    > [  493.567153] iscsi_np        D    0  3998      2 0x00000084
>    > [  493.567159]  0000000000000000 ffff883028a88b40 ffff88302693f7c0
>    ffff88302de3e300
>    > [  493.567163]  ffff88303e057a40 ffffc900008abc00 ffffffff815e415b
>    ffffc900008abca0
>    > [  493.567166]  ffffffff81af4180 ffff883028a88b40 7fffffffffffffff
>    ffff882f7426db68
>    > [  493.567170] Call Trace:
>    > [  493.567180]  [<ffffffff815e415b>] ? __schedule+0x23b/0x6c0
>    > [  493.567184]  [<ffffffff815e4616>] schedule+0x36/0x80
>    > [  493.567187]  [<ffffffff815e71c3>] schedule_timeout+0x1f3/0x390
>    > [  493.567194]  [<ffffffff812c1f2e>] ? number+0x2ce/0x300
>    > [  493.567197]  [<ffffffff812c42be>] ? vsnprintf+0x32e/0x4b0
>    > [  493.567199]  [<ffffffff815e56a4>] wait_for_completion+0xb4/0xf0
>    > [  493.567201]  [<ffffffff8108a6b0>] ? wake_up_q+0x80/0x80
>    > [  493.567216]  [<ffffffffa05284d1>] iscsit_stop_session+0x1b1/0x1c0
>    [iscsi_target_mod]
>    > [  493.567220]  [<ffffffffa0519db2>]
>    iscsi_check_for_session_reinstatement+0x1e2/0x270 [iscsi_target_mod]
>    > [  493.567225]  [<ffffffffa051c8c0>]
>    iscsi_target_check_for_existing_instances+0x30/0x40 [iscsi_target_mod]
>    > [  493.567230]  [<ffffffffa051c9ee>] iscsi_target_do_login+0x11e/0x610
>    [iscsi_target_mod]
>    > [  493.567235]  [<ffffffffa051dbbe>]
>    iscsi_target_start_negotiation+0x4e/0xa0 [iscsi_target_mod]
>    > [  493.567239]  [<ffffffffa051b933>]
>    iscsi_target_login_thread+0xa73/0xfc0 [iscsi_target_mod]
>    > [  493.567244]  [<ffffffffa051aec0>] ?
>    iscsi_target_login_sess_out+0x250/0x250 [iscsi_target_mod]
>    > [  493.567246]  [<ffffffff810660c4>] ? SyS_exit_group+0x14/0x20
>    > [  493.567249]  [<ffffffff8107ee5a>] kthread+0xca/0xe0
>    > [  493.567250]  [<ffffffff8107ed90>] ? kthread_park+0x60/0x60
>    > [  493.567252]  [<ffffffff815e8752>] ret_from_fork+0x22/0x30
>    > [  493.567254] INFO: task iscsi_trx:4149 blocked for more than 120
>    seconds.
>    > [  493.567255]       Tainted: G           OE   4.9.0-For-DSGL-Debug+ #1
>    > [  493.567256] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>    disables this message.
>    > [  493.567256] iscsi_trx       D    0  4149      2 0x00000084
>    > [  493.567258]  0000000000000000 ffff882f5ef70340 ffff882f76253040
>    ffff88302de40340
>    > [  493.567259]  ffff88303e097a40 ffffc90000f93c90 ffffffff815e415b
>    ffffffff815e56c2
>    > [  493.567261]  0000000000000001 ffff882f5ef70340 7fffffffffffffff
>    ffff882d233cc9b0
>    > [  493.567262] Call Trace:
>    > [  493.567264]  [<ffffffff815e415b>] ? __schedule+0x23b/0x6c0
>    > [  493.567265]  [<ffffffff815e56c2>] ? wait_for_completion+0xd2/0xf0
>    > [  493.567267]  [<ffffffff815e4616>] schedule+0x36/0x80
>    > [  493.567268]  [<ffffffff815e71c3>] schedule_timeout+0x1f3/0x390
>    > [  493.567281]  [<ffffffffa118e910>] ? ib_sg_to_pages+0x1a0/0x1a0
>    [ib_core]
>    > [  493.567285]  [<ffffffffa118e910>] ? ib_sg_to_pages+0x1a0/0x1a0
>    [ib_core]
>    > [  493.567286]  [<ffffffff815e56a4>] wait_for_completion+0xb4/0xf0
>    > [  493.567287]  [<ffffffff8108a6b0>] ? wake_up_q+0x80/0x80
>    > [  493.567302]  [<ffffffffa04d5399>]
>    target_wait_for_sess_cmds+0x49/0x1a0 [target_core_mod]
>    > [  493.567306]  [<ffffffffa0471644>] isert_wait_conn+0x1a4/0x2d0
>    [ib_isert]
>    > [  493.567311]  [<ffffffffa05289ab>] iscsit_close_connection+0x14b/0x820
>    [iscsi_target_mod]
>    > [  493.567315]  [<ffffffffa05172ef>]
>    iscsit_take_action_for_connection_exit+0x7f/0x100 [iscsi_target_mod]
>    > [  493.567320]  [<ffffffffa0528265>] iscsi_target_rx_thread+0x95/0xa0
>    [iscsi_target_mod]
>    > [  493.567324]  [<ffffffffa05281d0>] ?
>    iscsi_target_tx_thread+0x1b0/0x1b0 [iscsi_target_mod]
>    > [  493.567325]  [<ffffffff8107ee5a>] kthread+0xca/0xe0
>    > [  493.567327]  [<ffffffff8107ed90>] ? kthread_park+0x60/0x60
>    > [  493.567328]  [<ffffffff815e8752>] ret_from_fork+0x22/0x30
>    >
> 
>    OK, AFAICT these hung tasks basically mean iser-target never gave
>    target-core back the outstanding se_cmd it was attempting to retry, even
>    up to the point in which session reinstatement was eventually triggered
>    by iser-initiator.
Yes.
> 
>    So the reason why your patch to swap post_recv -> post_send to post_send
>    -> post_recv makes a difference is because it allows enough trickle of
>    RDMA_WRITEs to make it through, where iser-initiator doesn't attempt to
>    escalate recovery and doesn't attempt session reinstatement.
I dont exactly know if above thing comes into play but the actual reason I did 
swap posting RQ and SQ is, unlike SQ, RQ is posted with WRs to the brim during 
the intialisation itself. From thereon we post a RQ WR for every RQ completion 
That makes it almost full at any point of time.

Now in our scenario, SQ is miscalulated and too small for few adapters and so 
filled gradually as the IO starts. Once SQ is full, according to your patches 
isert queues it and tries to repost the command again. Here in iser functions 
like isert_post_response(), isert_put_datain() post send is done after post recv.
For the first post send failure in say isert_put_datain(), the corresponding 
post recv is already posted, then on queuing the command and trying reposting 
an extra recv is again posted which fills up the RQ also.

 By swapping post recv and send as in my incermental patch, we dont post that 
extra recv, and post recv only on successful post send.
Therfore I think this incremental patch is necessary. 
> 
>    Have you been able to confirm with your incremental patch below that
>    once TMR ABORT_TASKs start to occur due to isert_rdma_rw_ctx_post
>    failures, that any subsequent session reinstatement events for unrelated
>    reasons (or explicit logout..?) doesn't run into the same issue..?
Yes, It is tested good! I've left it to run from yesterday. IO is still running 
with out any login timeouts.
[root@bharat ~]# iscsiadm -m session -P3 | grep "Attached scsi disk"
                        Attached scsi disk sdj          State: running
                        Attached scsi disk sdc          State: running
                        Attached scsi disk sdd          State: running
                        Attached scsi disk sde          State: running
                        Attached scsi disk sdf          State: running
                        Attached scsi disk sdg          State: running
                        Attached scsi disk sdh          State: running
                        Attached scsi disk sdi          State: running
[root@bharat ~]# uptime
 13:12:04 up 1 day,  1:22,  3 users,  load average: 8.11, 8.30, 7.26

> 
>    > -> In order to address this I tried the following (experimental) change
>    on top of your 3 patches:
>    >
>    > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
>    b/drivers/infiniband/ulp/isert/ib_isert.c
>    > index 501a0ad124a7..0aead5faa2a2 100644
>    > --- a/drivers/infiniband/ulp/isert/ib_isert.c
>    > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>    > @@ -1817,16 +1817,16 @@ isert_post_response(struct isert_conn
>    *isert_conn, struct isert_cmd *isert_cmd)
>    >         struct ib_send_wr *wr_failed;
>    >         int ret;
>    >
>    > -       ret = isert_post_recv(isert_conn, isert_cmd->rx_desc);
>    > +       ret = ib_post_send(isert_conn->qp, &isert_cmd->tx_desc.send_wr,
>    > +                          &wr_failed);
>    >         if (ret) {
>    > -               isert_err("ib_post_recv failed with %d\n", ret);
>    > +               isert_err("ib_post_send failed with %d\n", ret);
>    >                 return ret;
>    >         }
>    >
>    > -       ret = ib_post_send(isert_conn->qp, &isert_cmd->tx_desc.send_wr,
>    > -                          &wr_failed);
>    > +       ret = isert_post_recv(isert_conn, isert_cmd->rx_desc);
>    >         if (ret) {
>    > -               isert_err("ib_post_send failed with %d\n", ret);
>    > +               isert_err("ib_post_recv failed with %d\n", ret);
>    >                 return ret;
>    >         }
>    >         return ret;
>    > @@ -2166,6 +2166,13 @@ isert_put_datain(struct iscsi_conn *conn, struct
>    iscsi_cmd *cmd)
>    >         if (isert_prot_cmd(isert_conn, se_cmd)) {
>    >                 isert_cmd->tx_desc.tx_cqe.done = isert_rdma_write_done;
>    >                 cqe = &isert_cmd->tx_desc.tx_cqe;
>    > +
>    > +               rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe,
>    chain_wr);
>    > +               if (rc) {
>    > +                       isert_dbg("Cmd: %p posted RDMA_WRITE for iSER
>    Data READ rc: %d\n",
>    > +                                  isert_cmd, rc);
>    > +                       return rc;
>    > +               }
>    >         } else {
>    >                 /*
>    >                  * Build isert_conn->tx_desc for iSCSI response PDU and
>    attach
>    > @@ -2178,18 +2185,21 @@ isert_put_datain(struct iscsi_conn *conn, struct
>    iscsi_cmd *cmd)
>    >                 isert_init_send_wr(isert_conn, isert_cmd,
>    >                                    &isert_cmd->tx_desc.send_wr);
>    >
>    > +               chain_wr = &isert_cmd->tx_desc.send_wr;
>    > +
>    > +               rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe,
>    chain_wr);
>    > +               if (rc) {
>    > +                       isert_err("Cmd: %p posted RDMA_WRITE for iSER
>    Data READ rc: %d\n",
>    > +                                  isert_cmd, rc);
>    > +                       return rc;
>    > +               }
>    > +
>    >                 rc = isert_post_recv(isert_conn, isert_cmd->rx_desc);
>    >                 if (rc) {
>    >                         isert_err("ib_post_recv failed with %d\n", rc);
>    >                         return rc;
>    >                 }
>    > -
>    > -               chain_wr = &isert_cmd->tx_desc.send_wr;
>    >         }
>    > -       rc = isert_rdma_rw_ctx_post(isert_cmd, isert_conn, cqe,
>    chain_wr);
>    > -       isert_dbg("Cmd: %p posted RDMA_WRITE for iSER Data READ rc:
>    %d\n",
>    > -                  isert_cmd, rc);
>    > -
>    >         return rc;
>    >  }
>    >
> 
>    Unsure of the implications for other RNICs + iser-target here..
I believe it is needed. Lets wait for Sagi's opinion.
> 
>    I'll have to defer to Sagi judgment on this one.  ;)
> 
>    > -> With these changes it works fine, But I still see few Aborts
>    intermittently as follows:
>    >
>    > [10674.434643] isert: isert_rdma_rw_ctx_post: Cmd: ffff882cbb961138
>    failed to post RDMA res
>    > [10674.434690] isert: isert_rdma_rw_ctx_post: Cmd: ffff882cbb9434c0
>    failed to post RDMA res
>    > [10715.186372] ABORT_TASK: Found referenced iSCSI task_tag: 58
>    > [10715.186417] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 58
>    >
> 
>    OK, so there is still a delay between the isert_rdma_rw_ctx_post
>    failures, and receiving TMR ABORT_TASKs.
> 
>    Is target-core -> iser-target aggressively retrying the posting of
>    RDMA_WRITEs via isert_put_datain() during this entire time..?
> 
Yes, at higher IO sizes it happens.

I belive that in addition to this Queue failure handling. There should be flow 
control mechanism to slow down the posts on ENOMEM/ post failures.

I see something like that happening in Initiator:

iscsi_iser.h:
/* the max TX (send) WR supported by the iSER QP is defined by                 *
 * max_send_wr = T * (1 + D) + C ; D is how many inflight dataouts we expect   *
 * to have at max for SCSI command. The tx posting & completion handling code  *
 * supports -EAGAIN scheme where tx is suspended till the QP has room for more *
 * send WR. D=8 comes from 64K/8K                                              */

"where tx is suspended til the QP has room for more send WR"
I am not sure if that is done on target side.
>    > -> Apart from the Aborts and post failure logs filling dmesg, luns are
>    in state "running" and
>    > fio countinues to run.
>    > [root@bharat ~]# iscsiadm -m session -P3 | grep "Attached scsi disk"
>    >                         Attached scsi disk sdj          State: running
>    >                         Attached scsi disk sdc          State: running
>    >                         Attached scsi disk sdd          State: running
>    >                         Attached scsi disk sde          State: running
>    >                         Attached scsi disk sdf          State: running
>    >                         Attached scsi disk sdg          State: running
>    >                         Attached scsi disk sdh          State: running
>    >                         Attached scsi disk sdi          State: running
>    >
> 
>    Ok, so it looks like you've got the second order issues under control
>    for target-core + iser-target, once the first order issue of RDMA R/W
>    API vs. iw_cxgb4 WR resource mis-sizing continuously triggers failed
>    calls to isert_put_datain() -> isert_rdma_rw_ctx_post()
>    rdma_rw_ctx_post().
Yes, Thank you for the patches :).
> 
>    That said, I'm going to go ahead and queue patch #1 and #2 from the
>    original series to target-pending/for-next as they do address issues
>    separate from iser-target scenario here, and await on Sagi's feedback
>    for patch #3 and your incremental above.
> 
>    Thanks again.
> 
> References
> 
>    Visible links
>    1. https://www.spinics.net/lists/target-devel/msg13571.html
