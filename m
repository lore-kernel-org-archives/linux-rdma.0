From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Tue, 24 Jan 2017 14:49:37 -0700
Message-ID: <CAANLjFrpsmDeFV_OZZroJjLWyLY6b+X0KSon0Y_JZRZKF3H6jQ@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 23, 2017 at 4:12 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> On Mon, Jan 23, 2017 at 3:20 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> Hi Robert,
>>
>> Seeing this, makes me realize that the entire "iscsi_trx going
>> into D state" thread which I did not bother to read is actually an
>> iser-target related bug. I'm really sorry for not addressing this
>> sooner (much sooner).
>
> I was hesitant to start a new thread and fragment the discussion and
> cause confusion. I thought by presenting my findings as an RFC with
> some code, I might get some new ideas.
>
>> The patch looks wrong to me, but lets try and talk about
>> the hang you are trying to solve.
>>
>>> In certain circumstances the RDMA connection can be abruptly
>>> terminated,
>>
>>
>> Does it make a difference which port is causing the abruption?
>> Is it the target switch port? or the initiator switch port?
>
> It seems more tied to initiator port, but previously with our target
> export scripts it also seems that a target crash and re-export
> (generally out of order) could also cause the issue. My theory is that
> the session didn't mach enough and because of that would not get torn
> down completely. It is more of speculation from observations and
> thought than anything concrete.
>
>>> but something is getting stuck preventing the iSCSI clean
>>> up commands from being completed.
>>
>>
>> I think this means, that at least one command was missing
>> a final kref_put and causing target_wait_for_sess_cmds() to
>> block forever.
>>
>>> Just removing the isert_wait4*
>>> commands isn't enough.
>>
>>
>> Yes, because all the inflight IO needs to be properly cleaned up
>> for the session to terminate gracefully.
>>
>>> Just resetting the queue pair isn't enough
>>> either.
>>
>>
>> This is true as well. Before tearing down the RDMA queue pair we
>> need to make sure we will never see a completion for it on its
>> corresponding completion queue. This is why ib_drain_qp exists.
>>
>>> some help getting this patch fixed right as resetting the queue pair
>>> is probably not the right approach and overkill to solving the
>>> problem. I think it at least shows where the problem is occurring and
>>> how I can get around it.
>>
>>
>> As said, I have a feeling that we have a flow we are missing the last
>> kref_put on (at least) one of the session commands. The fact that this
>> involves port toggling, probably boils down to error completions.
>>
>> Bart, I recall you had a patch at some point to periodically print
>> out the hanging session commands in target_wait_for_sess_cmds(), do we
>> want to get it in? I think we can all benefit from it.
>
> Do you have a link to the path and I can add it in?
>
>> Would it be possible to turn on isert debug_level=4 and send us the log?
>> $ echo 4 > /sys/module/ib_isert/parameters/debug_level
>
> I'll get that to you tomorrow.

This is using the scsi-target-for-v4.11 branch and debug_level set to 4:

[ 7181.311934] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 7181.311939] isert: isert_create_send_desc: tx_desc ffff88653e371ad8
lkey mismatch, fixing
[ 7181.311940] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e371ad8 length: 76 lkey: 0x4260
[ 7181.311940] isert: isert_put_response: Posting SCSI Response
[ 7181.311941] isert: isert_create_send_desc: tx_desc ffff88653e3586c0
lkey mismatch, fixing
[ 7181.311942] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e3586c0 length: 76 lkey: 0x4260
[ 7181.311943] isert: isert_put_response: Posting SCSI Response
[ 7181.311944] isert: isert_create_send_desc: tx_desc ffff88653e365fe0
lkey mismatch, fixing
[ 7181.311944] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e365fe0 length: 76 lkey: 0x4260
[ 7181.311945] isert: isert_put_response: Posting SCSI Response
[ 7181.311945] isert: isert_create_send_desc: tx_desc ffff88653e36a238
lkey mismatch, fixing
[ 7181.311962] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e36a238 length: 76 lkey: 0x4260
[ 7181.311963] isert: isert_put_response: Posting SCSI Response
[ 7181.311964] isert: isert_create_send_desc: tx_desc ffff88653e3671f8
lkey mismatch, fixing
[ 7181.311964] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e3671f8 length: 76 lkey: 0x4260
[ 7181.311964] isert: isert_put_response: Posting SCSI Response
[ 7181.311965] isert: isert_create_send_desc: tx_desc ffff88653e348970
lkey mismatch, fixing
[ 7181.311966] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e348970 length: 76 lkey: 0x4260
[ 7181.311966] isert: isert_put_response: Posting SCSI Response
[ 7181.311967] isert: isert_create_send_desc: tx_desc ffff88653e36cc70
lkey mismatch, fixing
[ 7181.311968] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e36cc70 length: 76 lkey: 0x4260
[ 7181.311968] isert: isert_put_response: Posting SCSI Response
[ 7181.311969] isert: isert_create_send_desc: tx_desc ffff88653e362390
lkey mismatch, fixing
[ 7181.311969] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e362390 length: 76 lkey: 0x4260
[ 7181.311969] isert: isert_put_response: Posting SCSI Response
[ 7181.311984] isert: isert_recv_done: DMA: 0x7eaa406000, iSCSI
opcode: 0x01, ITT: 0x0000013b, flags: 0xa1 dlen: 4096
[ 7181.311985] isert: isert_create_send_desc: tx_desc ffff88653e3428f0
lkey mismatch, fixing
[ 7181.311986] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e3428f0 length: 76 lkey: 0x4260
[ 7181.311987] isert: isert_put_response: Posting SCSI Response
[ 7181.311988] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 7181.311989] isert: isert_create_send_desc: tx_desc ffff88653e367800
lkey mismatch, fixing
[ 7181.311989] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e367800 length: 76 lkey: 0x4260
[ 7181.311990] isert: isert_put_response: Posting SCSI Response
[ 7181.311991] isert: isert_create_send_desc: tx_desc ffff88653e35cf20
lkey mismatch, fixing
[ 7181.311991] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 7181.311992] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e35cf20 length: 76 lkey: 0x4260
[ 7181.311993] isert: isert_put_response: Posting SCSI Response
[ 7181.311994] isert: isert_create_send_desc: tx_desc ffff88653e370ec8
lkey mismatch, fixing
[ 7181.311994] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e370ec8 length: 76 lkey: 0x4260
[ 7181.311994] isert: isert_put_response: Posting SCSI Response
[ 7181.311996] isert: isert_recv_done: DMA: 0x7eaa49f000, iSCSI
opcode: 0x01, ITT: 0x0000013e, flags: 0xa1 dlen: 4096
[ 7181.311997] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 7181.311998] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 7181.312000] isert: isert_recv_done: DMA: 0x7eaa424000, iSCSI
opcode: 0x01, ITT: 0x00000171, flags: 0xa1 dlen: 4096
[ 7181.312000] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 7181.312002] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 7181.312004] isert: isert_recv_done: DMA: 0x7eaa4d2000, iSCSI
opcode: 0x01, ITT: 0x00000043, flags: 0xa1 dlen: 4096
[ 7181.312004] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 7181.312005] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 7181.312007] isert: isert_recv_done: DMA: 0x7eaa57a000, iSCSI
opcode: 0x01, ITT: 0x000001ab, flags: 0xa1 dlen: 4096
[ 7181.312007] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 7181.312009] isert: isert_create_send_desc: tx_desc ffff88653e34dde0
lkey mismatch, fixing
[ 7181.312010] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e34dde0 length: 76 lkey: 0x4260
[ 7181.312011] isert: isert_put_response: Posting SCSI Response
[ 7181.312012] isert: isert_create_send_desc: tx_desc ffff88653e36d278
lkey mismatch, fixing
[ 7181.312013] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e36d278 length: 76 lkey: 0x4260
[ 7181.312013] isert: isert_put_response: Posting SCSI Response
[ 7181.312014] isert: isert_create_send_desc: tx_desc ffff88653e36a840
lkey mismatch, fixing
[ 7181.312015] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e36a840 length: 76 lkey: 0x4260
[ 7181.312015] isert: isert_put_response: Posting SCSI Response
[ 7181.312016] isert: isert_create_send_desc: tx_desc ffff88653e36fcb0
lkey mismatch, fixing
[ 7181.312017] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x653e36fcb0 length: 76 lkey: 0x4260
[ 7181.312017] isert: isert_put_response: Posting SCSI Response
[ 7181.312033] systemd-journald[1358]: /dev/kmsg buffer overrun, some
messages lost.
[ 7191.370368] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e684400 np ffff887f1bed5d80
[ 7191.380635] isert: isert_wait_conn: Starting conn ffff887f25f2e000
[ 7191.387667] isert: isert_conn_terminate: Terminating conn
ffff887f25f2e000 state 3
[ 7193.456737] isert: isert_cma_handler: timewait exit (15): status 0
id ffff88653e684400 np ffff887f1bed5d80
[ 7193.660233] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e595400 np ffff887f1bed5d80
[ 7193.660235] isert: isert_connect_request: cma_id: ffff88653e595400,
portal: ffff887f1bed5d80
[ 7193.660258] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 2
[ 7193.660258] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7193.660259] isert: isert_set_nego_params: Using remote invalidation
[ 7193.660261] isert: isert_comp_get: conn ffff887f25f2c000, using
comp ffff88653e684818 min_index: 1
[ 7193.661196] isert: isert_login_post_recv: Setup sge: addr:
653e5fc000 length: 8268 0x00004260
[ 7193.662041] isert: isert_cma_handler: established (9): status 0 id
ffff88653e595400 np ffff887f1bed5d80
[ 7193.662043] isert: isert_connected_handler: conn ffff887f25f2c000
[ 7193.662067] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7193.662085] isert: isert_accept_np: Processing isert_conn: ffff887f25f2c000
[ 7193.662101] isert: isert_get_login_rx: before login_req comp conn:
ffff887f25f2c000
[ 7193.929623] isert: isert_rx_login_req: conn ffff887f25f2c000
[ 7193.935895] isert: isert_rx_login_req: Using login payload size:
504, rx_buflen: 504 MAX_KEY_VALUE_PAIRS: 8192
[ 7193.935895] isert: isert_get_login_rx: before login_comp conn:
ffff887f25a99800
[ 7193.943843] isert: isert_get_login_rx: processing login->req:
ffff887ea2962ce4
[ 7193.951790] isert: isert_get_sup_prot_ops: conn ffff887f25f2c000 PI
offload disabled
[ 7208.696191] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e595400 np ffff887f1bed5d80
[ 7209.297524] iSCSI Login timeout on Network Portal 0.0.0.0:3260
[ 7210.949920] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e594800 np ffff887f1bed5d80
[ 7210.960293] isert: isert_connect_request: cma_id: ffff88653e594800,
portal: ffff887f1bed5d80
[ 7210.960307] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7210.968496] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7210.968496] isert: isert_set_nego_params: Using remote invalidation
[ 7210.975350] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7210.985314] isert: isert_login_post_recv: Setup sge: addr:
7eaa7b0000 length: 8268 0x00004260
[ 7210.986162] isert: isert_cma_handler: established (9): status 0 id
ffff88653e594800 np ffff887f1bed5d80
[ 7210.996156] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7211.002839] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7226.017139] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e594800 np ffff887f1bed5d80
[ 7226.027390] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7226.036933] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7226.044659] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7226.051852] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:1/310
[ 7226.060626] isert: isert_connect_release: conn ffff887f25f2a000
[ 7226.061592] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7228.270580] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e594c00 np ffff887f1bed5d80
[ 7228.280959] isert: isert_connect_request: cma_id: ffff88653e594c00,
portal: ffff887f1bed5d80
[ 7228.280972] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7228.289173] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7228.289174] isert: isert_set_nego_params: Using remote invalidation
[ 7228.296030] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7228.306105] isert: isert_login_post_recv: Setup sge: addr:
653d538000 length: 8268 0x00004260
[ 7228.306862] isert: isert_cma_handler: established (9): status 0 id
ffff88653e594c00 np ffff887f1bed5d80
[ 7228.316851] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7228.323580] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7243.336981] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e594c00 np ffff887f1bed5d80
[ 7243.347320] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7243.356878] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7243.364667] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7243.371927] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:2/22941
[ 7243.380940] isert: isert_connect_release: conn ffff887f25f2a000
[ 7243.381748] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7245.590796] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e597800 np ffff887f1bed5d80
[ 7245.601233] isert: isert_connect_request: cma_id: ffff88653e597800,
portal: ffff887f1bed5d80
[ 7245.601247] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7245.609505] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7245.609505] isert: isert_set_nego_params: Using remote invalidation
[ 7245.616450] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7245.626606] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7245.627327] isert: isert_cma_handler: established (9): status 0 id
ffff88653e597800 np ffff887f1bed5d80
[ 7245.637403] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7245.644168] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7260.657275] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e597800 np ffff887f1bed5d80
[ 7260.667577] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7260.677085] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7260.684908] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7260.692193] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:2/22941
[ 7260.701219] isert: isert_connect_release: conn ffff887f25f2a000
[ 7260.702013] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7262.911031] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e592400 np ffff887f1bed5d80
[ 7262.921456] isert: isert_connect_request: cma_id: ffff88653e592400,
portal: ffff887f1bed5d80
[ 7262.921461] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7262.929699] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7262.929699] isert: isert_set_nego_params: Using remote invalidation
[ 7262.936642] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7262.946822] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7262.947545] isert: isert_cma_handler: established (9): status 0 id
ffff88653e592400 np ffff887f1bed5d80
[ 7262.957632] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7262.964418] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7277.977210] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e592400 np ffff887f1bed5d80
[ 7277.987624] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7277.996977] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7278.004803] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7278.012103] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:1/310
[ 7278.020951] isert: isert_connect_release: conn ffff887f25f2a000
[ 7278.022070] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7280.230596] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e594000 np ffff887f1bed5d80
[ 7280.241093] isert: isert_connect_request: cma_id: ffff88653e594000,
portal: ffff887f1bed5d80
[ 7280.241106] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7280.249396] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7280.249396] isert: isert_set_nego_params: Using remote invalidation
[ 7280.256387] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7280.266607] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7280.267304] isert: isert_cma_handler: established (9): status 0 id
ffff88653e594000 np ffff887f1bed5d80
[ 7280.277408] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7280.284172] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7295.297259] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e594000 np ffff887f1bed5d80
[ 7295.307589] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7295.317063] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7295.324897] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7295.332190] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:1/310
[ 7295.341026] isert: isert_connect_release: conn ffff887f25f2a000
[ 7295.341884] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7297.550811] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e594000 np ffff887f1bed5d80
[ 7297.561237] isert: isert_connect_request: cma_id: ffff88653e594000,
portal: ffff887f1bed5d80
[ 7297.561243] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7297.569490] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7297.569491] isert: isert_set_nego_params: Using remote invalidation
[ 7297.576443] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7297.586594] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7297.587294] isert: isert_cma_handler: established (9): status 0 id
ffff88653e594000 np ffff887f1bed5d80
[ 7297.597371] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7297.604160] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7312.617204] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e594000 np ffff887f1bed5d80
[ 7312.627513] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7312.636920] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7312.644733] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7312.652031] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:1/310
[ 7312.660902] isert: isert_connect_release: conn ffff887f25f2a000
[ 7312.661725] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7315.448740] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e592400 np ffff887f1bed5d80
[ 7315.459216] isert: isert_connect_request: cma_id: ffff88653e592400,
portal: ffff887f1bed5d80
[ 7315.459222] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7315.467509] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7315.467509] isert: isert_set_nego_params: Using remote invalidation
[ 7315.474494] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7315.484601] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7315.485289] isert: isert_cma_handler: established (9): status 0 id
ffff88653e592400 np ffff887f1bed5d80
[ 7315.495398] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7315.502218] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue
[ 7330.485314] isert: isert_cma_handler: disconnected (10): status 0
id ffff88653e592400 np ffff887f1bed5d80
[ 7330.495629] isert: isert_conn_terminate: Terminating conn
ffff887f25f2a000 state 1
[ 7330.504877] isert: isert_release_work: Starting release conn ffff887f25f2a000
[ 7330.512694] isert: isert_release_work: Destroying conn ffff887f25f2a000
[ 7330.519994] isert: isert_release_kref: conn ffff887f25f2a000 final
kref kworker/u66:2/22941
[ 7330.529032] isert: isert_connect_release: conn ffff887f25f2a000
[ 7330.529990] isert: isert_device_put: device ffff883f590c6ac0 refcount 2
[ 7332.782764] isert: isert_cma_handler: connect request (4): status 0
id ffff88653e597800 np ffff887f1bed5d80
[ 7332.793278] isert: isert_connect_request: cma_id: ffff88653e597800,
portal: ffff887f1bed5d80
[ 7332.793284] isert: isert_device_get: Found iser device
ffff883f590c6ac0 refcount 3
[ 7332.801642] isert: isert_set_nego_params: Using initiator_depth: 16
[ 7332.801656] isert: isert_set_nego_params: Using remote invalidation
[ 7332.808665] isert: isert_comp_get: conn ffff887f25f2a000, using
comp ffff88653e684830 min_index: 2
[ 7332.818813] isert: isert_login_post_recv: Setup sge: addr:
653d7f4000 length: 8268 0x00004260
[ 7332.819745] isert: isert_cma_handler: established (9): status 0 id
ffff88653e597800 np ffff887f1bed5d80
[ 7332.829836] isert: isert_connected_handler: conn ffff887f25f2a000
[ 7332.836621] isert: isert_connected_handler: np ffff887f1bed5d80:
Allow accept_np to continue

>>> The problem easily shows up with two ConnectX-4-LX card connected to a
>>> 10 Gb switch. The target is a RAM disk and the initiator just mounts
>>> it as ext4 and runs fio.
>>
>>
>> Can you please share the fio workload? Does this happen when for example
>> you run 100% read workload? or 100% write workload?
>
> echo "3" > /proc/sys/vm/drop_caches; fio --rw=read --bs=4K --size=1G
> --numjobs=40 --name=worker.matt --group_reporting
>
> With the ConnectX-4-LX cards, it will usually cause the issue while
> laying out the first four files, usually on the first one or two. When
> I was able to replicate it on IB, I believe I was able to replicate by
> pulling the cable on lay out or during the read portion of the test.
> So I don't think it matters what the workload is, but I think it needs
> a workload of some sort.
>
>> And, can you try and disable the unsolicited-data-out in the target
>> (IIRC its InitialR2T=Yes)? unsol dataout has been known to trigger
>> cause similar hangs before (which were supposed to be solved).
>
> I'll figure out how to do this and test it tomorrow and let you know
> the results.

Same branch and debug as above, but with targetcli
/iscsi/iqn.2016-12.com.betterservers/tpg1 set parameter InitialR2T=No

The test completed the first time, I reformatted and reran the test
(without messing with the iSCSI session) and got this in the log:

[ 1329.829689] isert: isert_put_response: Posting SCSI Response
[ 1329.829690] isert: isert_create_send_desc: tx_desc ffff88258a355680
lkey mismatch, fixing
[ 1329.829691] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x258a355680 length: 76 lkey: 0x138c
[ 1329.829691] isert: isert_put_response: Posting SCSI Response
[ 1329.829692] isert: isert_recv_done: DMA: 0x3ee953e000, iSCSI
opcode: 0x01, ITT: 0x00000127, flags: 0xa1 dlen: 4096
[ 1329.829693] isert: isert_create_send_desc: tx_desc ffff88258a3635a8
lkey mismatch, fixing
[ 1329.829693] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x258a3635a8 length: 76 lkey: 0x138c
[ 1329.829694] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 1329.829695] isert: isert_put_response: Posting SCSI Response
[ 1329.829697] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 1329.829700] isert: isert_recv_done: DMA: 0x3ee941e000, iSCSI
opcode: 0x01, ITT: 0x000000cd, flags: 0xa1 dlen: 4096
[ 1329.829701] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 1329.829702] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 1329.829705] isert: isert_create_send_desc: tx_desc ffff88258a349580
lkey mismatch, fixing
[ 1329.829705] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x258a349580 length: 76 lkey: 0x138c
[ 1329.829705] isert: isert_put_response: Posting SCSI Response
[ 1329.829706] isert: isert_create_send_desc: tx_desc ffff88258a352c48
lkey mismatch, fixing
[ 1329.829707] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x258a352c48 length: 76 lkey: 0x138c
[ 1329.829707] isert: isert_put_response: Posting SCSI Response
[ 1329.829709] isert: isert_recv_done: DMA: 0x3ee9424000, iSCSI
opcode: 0x01, ITT: 0x00000156, flags: 0xa1 dlen: 4096
[ 1329.829710] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 1329.829712] isert: isert_handle_scsi_cmd: Transfer Immediate
imm_data_len: 4096
[ 1329.829715] isert: isert_recv_done: DMA: 0x3ee948d000, iSCSI
opcode: 0x01, ITT: 0x000001ea, flags: 0xa1 dlen: 4096
[ 1329.829715] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[ 1329.829716] isert: isert_create_send_desc: tx_desc ffff88258a347150
lkey mismatch, fixing
[ 1329.829717] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x258a347150 length: 76 lkey: 0x138c
[ 1329.829717] isert: isert_put_response: Posting SCSI Response
[ 1332.815592] isert: isert_wait_conn: Starting conn ffff887f1a860000
[ 1332.822012] isert: isert_conn_terminate: Terminating conn
ffff887f1a860000 state 3
[ 1332.831289] isert: isert_cma_handler: disconnected (10): status 0
id ffff887ebc6b8c00 np ffff887f23d74a80
[ 1334.874979] isert: isert_cma_handler: connect request (4): status 0
id ffff887f24cb5c00 np ffff887f23d74a80
[ 1334.885001] isert: isert_connect_request: cma_id: ffff887f24cb5c00,
portal: ffff887f23d74a80
[ 1334.885015] isert: isert_device_get: Found iser device
ffff887f1da5cc00 refcount 2
[ 1334.892792] isert: isert_set_nego_params: Using initiator_depth: 16
[ 1334.892792] isert: isert_set_nego_params: Using remote invalidation
[ 1334.899263] isert: isert_comp_get: conn ffff887f1a862000, using
comp ffff887ebc6b9018 min_index: 1
[ 1334.908871] isert: isert_login_post_recv: Setup sge: addr:
7eb0ef4000 length: 8268 0x0000138c
[ 1334.909235] isert: isert_cma_handler: timewait exit (15): status 0
id ffff887ebc6b8c00 np ffff887f23d74a80
[ 1334.919160] isert: isert_cma_handler: established (9): status 0 id
ffff887f24cb5c00 np ffff887f23d74a80
[ 1334.928795] isert: isert_connected_handler: conn ffff887f1a862000
[ 1334.935127] isert: isert_connected_handler: np ffff887f23d74a80:
Allow accept_np to continue
[ 1334.943864] isert: isert_accept_np: Processing isert_conn:
ffff887f1a862000
[ 1334.943875] isert: isert_get_login_rx: before login_req comp conn:
ffff887f1a862000
[ 1335.143891] isert: isert_rx_login_req: conn ffff887f1a862000
[ 1335.149817] isert: isert_rx_login_req: Using login payload size:
504, rx_buflen: 504 MAX_KEY_VALUE_PAIRS: 8192
[ 1335.149818] isert: isert_get_login_rx: before login_comp conn:
ffff887f1bee7000
[ 1335.157405] isert: isert_get_login_rx: processing login->req:
ffff883f5b66afe4
[ 1335.165010] isert: isert_get_sup_prot_ops: conn ffff887f1a862000 PI
offload disabled
[ 1349.909304] isert: isert_cma_handler: disconnected (10): status 0
id ffff887f24cb5c00 np ffff887f23d74a80
[ 1350.334806] iSCSI Login timeout on Network Portal 0.0.0.0:3260
[ 1352.162863] isert: isert_cma_handler: connect request (4): status 0
id ffff887f24cb3800 np ffff887f23d74a80
[ 1352.173132] isert: isert_connect_request: cma_id: ffff887f24cb3800,
portal: ffff887f23d74a80
[ 1352.173145] isert: isert_device_get: Found iser device
ffff887f1da5cc00 refcount 3
[ 1352.181138] isert: isert_set_nego_params: Using initiator_depth: 16
[ 1352.181139] isert: isert_set_nego_params: Using remote invalidation
[ 1352.187825] isert: isert_comp_get: conn ffff887f1a864000, using
comp ffff887ebc6b9030 min_index: 2
[ 1352.197560] isert: isert_login_post_recv: Setup sge: addr:
7eb7048000 length: 8268 0x0000138c
[ 1352.198721] isert: isert_cma_handler: established (9): status 0 id
ffff887f24cb3800 np ffff887f23d74a80
[ 1352.208547] isert: isert_connected_handler: conn ffff887f1a864000
[ 1352.215074] isert: isert_connected_handler: np ffff887f23d74a80:
Allow accept_np to continue
[ 1367.239002] isert: isert_cma_handler: disconnected (10): status 0
id ffff887f24cb3800 np ffff887f23d74a80
[ 1367.249249] isert: isert_conn_terminate: Terminating conn
ffff887f1a864000 state 1
[ 1367.258302] isert: isert_release_work: Starting release conn ffff887f1a864000
[ 1367.265965] isert: isert_release_work: Destroying conn ffff887f1a864000
[ 1367.273088] isert: isert_release_kref: conn ffff887f1a864000 final
kref kworker/u66:2/1631
[ 1367.281870] isert: isert_connect_release: conn ffff887f1a864000
[ 1367.282679] isert: isert_device_put: device ffff887f1da5cc00 refcount 2
[ 1369.492633] isert: isert_cma_handler: connect request (4): status 0
id ffff887f24cb0400 np ffff887f23d74a80
[ 1369.503049] isert: isert_connect_request: cma_id: ffff887f24cb0400,
portal: ffff887f23d74a80
[ 1369.503061] isert: isert_device_get: Found iser device
ffff887f1da5cc00 refcount 3
[ 1369.511199] isert: isert_set_nego_params: Using initiator_depth: 16
[ 1369.511199] isert: isert_set_nego_params: Using remote invalidation
[ 1369.518010] isert: isert_comp_get: conn ffff887f1a866000, using
comp ffff887ebc6b9030 min_index: 2
[ 1369.527949] isert: isert_login_post_recv: Setup sge: addr:
7f22bc0000 length: 8268 0x0000138c
[ 1369.529094] isert: isert_cma_handler: established (9): status 0 id
ffff887f24cb0400 np ffff887f23d74a80
[ 1369.539056] isert: isert_connected_handler: conn ffff887f1a866000
[ 1369.545747] isert: isert_connected_handler: np ffff887f23d74a80:
Allow accept_np to continue
[ 1384.567681] isert: isert_cma_handler: disconnected (10): status 0
id ffff887f24cb0400 np ffff887f23d74a80
[ 1384.578034] isert: isert_conn_terminate: Terminating conn
ffff887f1a866000 state 1
[ 1384.587321] isert: isert_release_work: Starting release conn ffff887f1a866000
[ 1384.595093] isert: isert_release_work: Destroying conn ffff887f1a866000
[ 1384.602328] isert: isert_release_kref: conn ffff887f1a866000 final
kref kworker/u66:0/16494
[ 1384.611337] isert: isert_connect_release: conn ffff887f1a866000
[ 1384.612370] isert: isert_device_put: device ffff887f1da5cc00 refcount 2
[ 1386.821154] isert: isert_cma_handler: connect request (4): status 0
id ffff887f24cb6c00 np ffff887f23d74a80
[ 1386.831788] isert: isert_connect_request: cma_id: ffff887f24cb6c00,
portal: ffff887f23d74a80
[ 1386.831794] isert: isert_device_get: Found iser device
ffff887f1da5cc00 refcount 3
[ 1386.840127] isert: isert_set_nego_params: Using initiator_depth: 16
[ 1386.840127] isert: isert_set_nego_params: Using remote invalidation
[ 1386.847144] isert: isert_comp_get: conn ffff887f1a864000, using
comp ffff887ebc6b9030 min_index: 2
[ 1386.857346] isert: isert_login_post_recv: Setup sge: addr:
7f22bc0000 length: 8268 0x0000138c
[ 1386.858217] isert: isert_cma_handler: established (9): status 0 id
ffff887f24cb6c00 np ffff887f23d74a80
[ 1386.868303] isert: isert_connected_handler: conn ffff887f1a864000
[ 1386.875085] isert: isert_connected_handler: np ffff887f23d74a80:
Allow accept_np to continue

>> Also, can you please summarize what kernel versions do you see this
>> with? The previous thread is a bit hard to follow at once.
>
> 4.9, 4.4.x, 4.1.x (we believe we saw it here, but it has been a long
> time since we have run this version.)
>
> Thanks for the response Sagi, I'm happy to have new things to try, I
> was really lost at where to go next.
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
