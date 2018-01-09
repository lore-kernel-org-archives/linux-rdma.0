From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: krping problem on 4.15-rc4
Date: Tue, 9 Jan 2018 10:30:04 -0500
Message-ID: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi folks,

I have 2 linux machines with CX-5 cards (Mellanox MCX515A-CCAT (one
port)) and krping doesn't work in one direction but works in another.
rping works in both direction. ib_send_bw works in both directions and
display 39Gb one way and 36Gb other way on a 40Gb setup.

krping is upstream commit 4df520c888d80e5370d0f58b2eeac8355e3f2286.

Server is started with: [kolga@localhost krping]$ sudo echo
"server,port=9999,addr=172.20.35.191,count=10,verbose" > /proc/krping
And it displays in /var/log/messages:
Jan 4 14:23:29 localhost kernel: mlx5_0:dump_cqe:277:(pid 0): dump error cqe
Jan 4 14:23:29 localhost kernel: 00000000 00000000 00000000 00000000
Jan 4 14:23:29 localhost kernel: 00000000 00000000 00000000 00000000
Jan 4 14:23:29 localhost kernel: 00000000 00000000 00000000 00000000
Jan 4 14:23:29 localhost kernel: 00000000 93003204 10000122 0005bfd2
Jan 4 14:23:29 localhost kernel: krping: cq completion failed with
wr_id 0 status 4 opcode 128 vender_err 32
Jan 4 14:23:29 localhost kernel: krping: cq completion in ERROR state
Jan 4 14:23:29 localhost kernel: krping: wait for RDMA_READ_COMPLETE state 10

Client is run with: [kolga@sti-rx200-231-d1 ~]$ sudo echo
"client,addr=172.20.35.191,port=9999,verbose,count=10" > /proc/krping
And in var log messages:
Jan 4 14:19:27 localhost kernel: krping: DISCONNECT EVENT...
Jan 4 14:19:27 localhost kernel: krping: wait for RDMA_WRITE_ADV state 10
Jan 4 14:19:28 localhost kernel: krping: cq completion in ERROR state

On the network trace is see (over RRoCE):
CM: ConnectRequest
CM: ConnectReply
CM: ReadyToUse
RC Send Only QP
RC Ack
RC RDMA Read Request
RC RDMA Read Response Only
CM: DisconnectRequest
CM: DisconnectReply

I have previously submitted it to Mellanox but they told me to
resubmit to linux-rdma list: They also said the engineering did look
at the CQE error and the meaning of it was:
PD (protection domain) violation - error in fetch data in rxs in pd
(send opcodes/ read respond / atomic ack).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
