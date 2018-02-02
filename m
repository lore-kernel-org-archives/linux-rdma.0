From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: interoperability issue between rxe and mlx5
Date: Fri, 2 Feb 2018 13:39:22 -0500
Message-ID: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi folks,

I'm testing interoperability between software ROCE (rdma_rxe) and
Mellanox CX-5 (mlx5) (kernel version 4.15-rc5). While the problem was
discovered doing NFSoRDMA testing, I can reproduce the problem using
kpring tool.

A simple krping works. However, when I specify using "size=4093",
krping fails to write those bytes. I don't know all the values for
which it doesn't work. For instance for "size=4096" it works again.
But values=4089-4095 it doesn't work.

On the network trace, for the size=4093, I see:
Read request for 4093
Read response first data 1024bytes
Read response middle data 1024bytes
Read response middle data 1024bytes
Read response last data 1024bytes
Read request for 1021
Read response last data1024

Then the last two message are repeated 6times. Then disconnect.

server side output from krping (uses the mlx5 driver)
Feb  2 13:34:39 localhost kernel: krping: proc write
|server,port=9999,addr=172.20.35.191,count=1,verbose,size=4093|
Feb  2 13:34:39 localhost kernel: server
Feb  2 13:34:39 localhost kernel: port 9999
Feb  2 13:34:39 localhost kernel: ipaddr (172.20.35.191)
Feb  2 13:34:39 localhost kernel: count 1
Feb  2 13:34:39 localhost kernel: verbose
Feb  2 13:34:39 localhost kernel: size 4093
Feb  2 13:34:39 localhost kernel: created cm_id 000000001be95fde
Feb  2 13:34:39 localhost kernel: rdma_bind_addr successful
Feb  2 13:34:39 localhost kernel: rdma_listen
Feb  2 13:34:48 localhost kernel: cma_event type 4 cma_id
000000003f54d0c7 (child)
Feb  2 13:34:48 localhost kernel: child cma 000000003f54d0c7
Feb  2 13:34:48 localhost kernel: Fastreg supported - device_cap_flags
0x15ed721c36
Feb  2 13:34:48 localhost kernel: created pd 000000004b3b2cf8
Feb  2 13:34:48 localhost kernel: created cq 00000000baf473cf
Feb  2 13:34:48 localhost kernel: created qp 00000000b35a3e3d
Feb  2 13:34:48 localhost kernel: krping: krping_setup_buffers called
on cb 000000000bdbbc98
Feb  2 13:34:48 localhost kernel: krping: reg rkey 0x1923 page_list_len 1
Feb  2 13:34:48 localhost kernel: krping: allocated & registered buffers...
Feb  2 13:34:48 localhost kernel: accepting client connection request
Feb  2 13:34:49 localhost kernel: cma_event type 9 cma_id
000000003f54d0c7 (child)
Feb  2 13:34:49 localhost kernel: ESTABLISHED
Feb  2 13:34:49 localhost kernel: recv completion
Feb  2 13:34:49 localhost kernel: Received rkey 1001 addr
ffff8abe19f56000 len 4093 from peer
Feb  2 13:34:49 localhost kernel: server received sink adv
Feb  2 13:34:49 localhost kernel: krping: post_inv = 1, reg_mr new
rkey 0x1901 pgsz 4096 len 4093 iova_start 8563da000
Feb  2 13:34:49 localhost kernel: server posted rdma read req
Feb  2 13:35:23 localhost kernel: krping: cq completion failed with
wr_id 0 status 12 opcode -27397 vender_err 81
Feb  2 13:35:23 localhost kernel: krping: cq completion in ERROR state
Feb  2 13:35:23 localhost kernel: krping: wait for RDMA_READ_COMPLETE state 10
Feb  2 13:35:23 localhost kernel: krping_free_buffers called on cb
000000000bdbbc98
Feb  2 13:35:23 localhost kernel: destroy cm_id 000000001be95fde

Client side output (uses the rxe driver)
Feb  2 13:30:50 localhost kernel: krping: proc write
|client,addr=172.20.35.191,port=9999,verbose,count=1,size=4093|
Feb  2 13:30:50 localhost kernel: client
Feb  2 13:30:50 localhost kernel: ipaddr (172.20.35.191)
Feb  2 13:30:50 localhost kernel: port 9999
Feb  2 13:30:50 localhost kernel: verbose
Feb  2 13:30:50 localhost kernel: count 1
Feb  2 13:30:50 localhost kernel: size 4093
Feb  2 13:30:50 localhost kernel: created cm_id 00000000c216a7dc
Feb  2 13:30:50 localhost kernel: cma_event type 0 cma_id
00000000c216a7dc (parent)
Feb  2 13:30:51 localhost kernel: cma_event type 2 cma_id
00000000c216a7dc (parent)
Feb  2 13:30:51 localhost kernel: Fastreg supported - device_cap_flags 0x203c76
Feb  2 13:30:51 localhost kernel: rdma_resolve_addr -
rdma_resolve_route successful
Feb  2 13:30:51 localhost kernel: created pd 00000000472401f1
Feb  2 13:30:51 localhost kernel: created cq 000000005a7ae08e
Feb  2 13:30:51 localhost kernel: created qp 000000002838d9b8
Feb  2 13:30:51 localhost kernel: krping: krping_setup_buffers called
on cb 0000000009a8311f
Feb  2 13:30:51 localhost kernel: krping: reg rkey 0x1060 page_list_len 1
Feb  2 13:30:51 localhost kernel: krping: allocated & registered buffers...
Feb  2 13:30:52 localhost kernel: cma_event type 9 cma_id
00000000c216a7dc (parent)
Feb  2 13:30:52 localhost kernel: ESTABLISHED
Feb  2 13:30:52 localhost kernel: rdma_connect successful
Feb  2 13:30:52 localhost kernel: krping: post_inv = 1, reg_mr new
rkey 0x1001 pgsz 4096 len 4093 iova_start ffff8abe19f56000
Feb  2 13:30:52 localhost kernel: RDMA addr ffff8abe19f56000 rkey 1001 len 4093
Feb  2 13:30:52 localhost kernel: send completion
Feb  2 13:31:27 localhost kernel: cma_event type 10 cma_id
00000000c216a7dc (parent)
Feb  2 13:31:27 localhost kernel: krping: DISCONNECT EVENT...
Feb  2 13:31:27 localhost kernel: krping: wait for RDMA_WRITE_ADV state 10
Feb  2 13:31:27 localhost kernel: krping_free_buffers called on cb
0000000009a8311f
Feb  2 13:31:27 localhost kernel: destroy cm_id 00000000c216a7dc

Please let me know what other kind of debugging information I can provide.

Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
