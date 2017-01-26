From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Thu, 26 Jan 2017 11:05:25 -0700
Message-ID: <CAANLjFpVMMp9kaqmugT0yxoR=0f0gmvxGzhBnW-djXyZgMN-CA@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
 <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com> <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
 <21bfa6a7-9199-9341-1193-7d186fd36326@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21bfa6a7-9199-9341-1193-7d186fd36326-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 3:52 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> It is getting stuck in target_wait_for_sess_cmds. ib_drain_qp is
>> returning just fine. I put in a bunch of debug statements and here is
>> a clip of them from a previous test.
>
>
> It won't make a difference, and we need both the rq and the sq drained
> before we continue with session teardown.
>
> Robert,
>
> I'm still missing the information of which commands are pending without
> a completion.
>
> Please activate target_wait_for_sess_cmds() debug logging.
>
> You can turn on the whole file with:
> echo "file target_core_transport.c +p" >
> /sys/kernel/debug/dynamic_debug/control

OK, I'm using commit bb3d5f95f46dfe19554820dbce620d31504dafb2 from the
bvanassche/scsi-target-for-v4.11 tree. I've exported the target with
InitialR2T=No then I ran
echo 4 > /sys/module/ib_isert/parameters/debug_level
echo "file target_core_transport.c +p" > /sys/kernel/debug/dynamic_debug/control

but it seems there is no new information during the period of the hang.

[  806.924011] isert: isert_recv_done: DMA: 0x7eff323000, iSCSI
opcode: 0x01, ITT: 0x000001a3, flags: 0xa1 dlen: 4096
[  806.924011] isert: isert_recv_done: ISER ISCSI_CTRL PDU
[  806.924014] isert: isert_create_send_desc: tx_desc ffff887eff0e9c30
lkey mismatch, fixing
[  806.924015] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x7eff0e9c30 length: 76 lkey: 0x425a
[  806.924016] isert: isert_put_response: Posting SCSI Response
[  806.924017] isert: isert_create_send_desc: tx_desc ffff887eff0ed278
lkey mismatch, fixing
[  806.924017] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x7eff0ed278 length: 76 lkey: 0x425a
[  806.924018] isert: isert_put_response: Posting SCSI Response
[  806.924019] isert: isert_create_send_desc: tx_desc ffff887eff0f14d0
lkey mismatch, fixing
[  806.924019] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x7eff0f14d0 length: 76 lkey: 0x425a
[  806.924020] isert: isert_put_response: Posting SCSI Response
[  806.924021] isert: isert_create_send_desc: tx_desc ffff887eff0f26e8
lkey mismatch, fixing
[  806.924022] isert: isert_init_tx_hdrs: Setup tx_sg[0].addr:
0x7eff0f26e8 length: 76 lkey: 0x425a
[  806.924022] isert: isert_put_response: Posting SCSI Response
[  817.066975] isert: isert_cma_handler: disconnected (10): status 0
id ffff887efe7be400 np ffff887f1c648d80
[  817.077425] isert: isert_wait_conn: Starting conn ffff887f25f84000
[  817.084212] isert: isert_conn_terminate: Terminating conn
ffff887f25f84000 state 3
[  819.202986] isert: isert_cma_handler: timewait exit (15): status 0
id ffff887efe7be400 np ffff887f1c648d80
[  819.607370] isert: isert_cma_handler: connect request (4): status 0
id ffff887efec36400 np ffff887f1c648d80
[  819.617859] isert: isert_connect_request: cma_id: ffff887efec36400,
portal: ffff887f1c648d80
[  819.617873] isert: isert_device_get: Found iser device
ffff887f20df5f40 refcount 2
[  819.626055] isert: isert_set_nego_params: Using initiator_depth: 16
[  819.626056] isert: isert_set_nego_params: Using remote invalidation
[  819.632925] isert: isert_comp_get: conn ffff887f25f86000, using
comp ffff887efe7be818 min_index: 1
[  819.643201] isert: isert_login_post_recv: Setup sge: addr:
7ebdb50000 length: 8268 0x0000425a
[  819.644010] isert: isert_cma_handler: established (9): status 0 id
ffff887efec36400 np ffff887f1c648d80
[  819.653970] isert: isert_connected_handler: conn ffff887f25f86000
[  819.660627] isert: isert_connected_handler: np ffff887f1c648d80:
Allow accept_np to continue
[  819.669680] isert: isert_accept_np: Processing isert_conn:
ffff887f25f86000
[  819.669688] isert: isert_get_login_rx: before login_req comp conn:
ffff887f25f86000
[  819.872665] isert: isert_rx_login_req: conn ffff887f25f86000
[  819.879052] isert: isert_rx_login_req: Using login payload size:
504, rx_buflen: 504 MAX_KEY_VALUE_PAIRS: 8192
[  819.879053] isert: isert_get_login_rx: before login_comp conn:
ffff887f1a457800
[  819.886973] isert: isert_get_login_rx: processing login->req:
ffff887effcb13a4
[  819.894936] isert: isert_get_sup_prot_ops: conn ffff887f25f86000 PI
offload disabled
[  834.639402] isert: isert_cma_handler: disconnected (10): status 0
id ffff887efec36400 np ffff887f1c648d80
[  835.203732] iSCSI Login timeout on Network Portal 0.0.0.0:3260
[  836.893231] isert: isert_cma_handler: connect request (4): status 0
id ffff887efec31800 np ffff887f1c648d80
[  836.903737] isert: isert_connect_request: cma_id: ffff887efec31800,
portal: ffff887f1c648d80
[  836.903752] isert: isert_device_get: Found iser device
ffff887f20df5f40 refcount 3
[  836.911938] isert: isert_set_nego_params: Using initiator_depth: 16
[  836.911951] isert: isert_set_nego_params: Using remote invalidation
[  836.918819] isert: isert_comp_get: conn ffff887f25f82000, using
comp ffff887efe7be830 min_index: 2
[  836.928920] isert: isert_login_post_recv: Setup sge: addr:
7f11f34000 length: 8268 0x0000425a
[  836.929796] isert: isert_cma_handler: established (9): status 0 id
ffff887efec31800 np ffff887f1c648d80
[  836.939815] isert: isert_connected_handler: conn ffff887f25f82000
[  836.946522] isert: isert_connected_handler: np ffff887f1c648d80:
Allow accept_np to continue
[  851.970046] isert: isert_cma_handler: disconnected (10): status 0
id ffff887efec31800 np ffff887f1c648d80
[  851.980368] isert: isert_conn_terminate: Terminating conn
ffff887f25f82000 state 1
[  851.989703] isert: isert_release_work: Starting release conn
ffff887f25f82000
[  851.997449] isert: isert_release_work: Destroying conn
ffff887f25f82000
[  852.004665] isert: isert_release_kref: conn ffff887f25f82000 final
kref kworker/u66:0/80
[  852.013351] isert: isert_connect_release: conn ffff887f25f82000
[  852.014178] isert: isert_device_put: device ffff887f20df5f40
refcount 2
[  854.223515] isert: isert_cma_handler: connect request (4): status 0
id ffff887efec33800 np ffff887f1c648d80
[  854.234033] isert: isert_connect_request: cma_id: ffff887efec33800,
portal: ffff887f1c648d80
[  854.234039] isert: isert_device_get: Found iser device
ffff887f20df5f40 refcount 3
[  854.242271] isert: isert_set_nego_params: Using initiator_depth: 16
[  854.242272] isert: isert_set_nego_params: Using remote invalidation
[  854.249204] isert: isert_comp_get: conn ffff887f25f82000, using
comp ffff887efe7be830 min_index: 2
[  854.259359] isert: isert_login_post_recv: Setup sge: addr:
7f11f34000 length: 8268 0x0000425a
[  854.260222] isert: isert_cma_handler: established (9): status 0 id
ffff887efec33800 np ffff887f1c648d80
[  854.270220] isert: isert_connected_handler: conn ffff887f25f82000
[  854.276901] isert: isert_connected_handler: np ffff887f1c648d80:
Allow accept_np to continue
[  869.295790] isert: isert_cma_handler: disconnected (10): status 0
id ffff887efec33800 np ffff887f1c648d80

I don't think journal is able to log all the messages before the hang
if any of those are important,

Jan 26 10:31:08 prv-0-13-roberttest kernel: isert: isert_get_login_rx:
before login_req comp conn: ffff887f25f84000
Jan 26 10:31:08 prv-0-13-roberttest kernel: isert: isert_rx_login_req:
conn ffff887f25f84000
Jan 26 10:31:08 prv-0-13-roberttest kernel: isert: isert_get_login_rx:
before login_comp conn: ffff887f23c95800
Jan 26 10:31:08 prv-0-13-roberttest kernel: isert: isert_get_login_rx:
processing login->req: ffff883f6614f8e4
Jan 26 10:31:08 prv-0-13-roberttest kernel: isert:
isert_get_sup_prot_ops: conn ffff887f25f84000 PI offload disabled
Jan 26 10:31:08 prv-0-13-roberttest kernel:
iSCSI/iqn.2004-12.com.betterservers:10.91.0.14: Unsupported SCSI
Opcode 0xa3, sending CHECK_CONDITION.
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 639 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 101 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 62 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 60 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 62 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 52 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 68 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 56 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 57 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 49 kernel messages
Jan 26 10:31:30 prv-0-13-roberttest journal: Missed 63 kernel messages
...
Jan 26 10:31:31 prv-0-13-roberttest journal: Missed 99 kernel messages
Jan 26 10:31:31 prv-0-13-roberttest journal: Missed 123 kernel messages
Jan 26 10:31:31 prv-0-13-roberttest journal: Missed 216 kernel messages
Jan 26 10:31:31 prv-0-13-roberttest journal: Missed 64 kernel messages
Jan 26 10:31:31 prv-0-13-roberttest journal: Missed 7 kernel messages
Jan 26 10:31:34 prv-0-13-roberttest kernel: WRITE_SAME sectors: 4088
exceeds max_write_same_len: 0
Jan 26 10:31:34 prv-0-13-roberttest rsyslogd-2177: imjournal: begin to
drop messages due to rate-limiting
Jan 26 10:40:03 prv-0-13-roberttest rsyslogd-2177: imjournal: 1210115
messages lost due to rate-limiting
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert: isert_cma_handler:
connect request (4): status 0 id ffff887efec32c00 np ffff887f1c648d80
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert: isert_device_get:
Found iser device ffff887f20df5f40 refcount 3
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert:
isert_set_nego_params: Using remote invalidation
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert: isert_comp_get:
conn ffff887f25f82000, using comp ffff887efe7be830 min_index: 2
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert: isert_cma_handler:
established (9): status 0 id ffff887efec32c00 np ffff887f1c648d80
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert:
isert_connected_handler: conn ffff887f25f82000
Jan 26 10:40:03 prv-0-13-roberttest kernel: isert:
isert_connected_handler: np ffff887f1c648d80: Allow accept_np to
continue
Jan 26 10:40:03 prv-0-13-roberttest systemd: Removed slice user-0.slice.
Jan 26 10:40:03 prv-0-13-roberttest systemd: Stopping user-0.slice.
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert: isert_cma_handler:
disconnected (10): status 0 id ffff887efec32c00 np ffff887f1c648d80
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert:
isert_conn_terminate: Terminating conn ffff887f25f82000 state 1
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert: isert_release_work:
Starting release conn ffff887f25f82000
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert: isert_release_work:
Destroying conn ffff887f25f82000
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert: isert_release_kref:
conn ffff887f25f82000 final kref kworker/u66:2/1743
Jan 26 10:40:18 prv-0-13-roberttest kernel: isert: isert_device_put:
device ffff887f20df5f40 refcount 2
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert: isert_cma_handler:
connect request (4): status 0 id ffff887efec31c00 np ffff887f1c648d80
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert: isert_device_get:
Found iser device ffff887f20df5f40 refcount 3
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert:
isert_set_nego_params: Using remote invalidation
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert: isert_comp_get:
conn ffff887f25f82000, using comp ffff887efe7be830 min_index: 2
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert: isert_cma_handler:
established (9): status 0 id ffff887efec31c00 np ffff887f1c648d80
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert:
isert_connected_handler: conn ffff887f25f82000
Jan 26 10:40:21 prv-0-13-roberttest kernel: isert:
isert_connected_handler: np ffff887f1c648d80: Allow accept_np to
continue
Jan 26 10:40:36 prv-0-13-roberttest kernel: isert: isert_cma_handler:
disconnected (10): status 0 id ffff887efec31c00 np ffff887f1c648d80
Jan 26 10:40:36 prv-0-13-roberttest kernel: isert:
isert_conn_terminate: Terminating conn ffff887f25f82000 state 1
Jan 26 10:40:36 prv-0-13-roberttest kernel: isert: isert_release_work:
Starting release conn ffff887f25f82000
Jan 26 10:40:36 prv-0-13-roberttest kernel: isert: isert_release_work:
Destroying conn ffff887f25f82000

I thought I saw some new messages in dmesg in regards to the new debug
command when I logged into the target, but I can't find them in
/var/log/messages now. I assume that I would find the messages in
dmesg, please let me know if I should be looking elsewhere.

Thanks for your help and patience.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
