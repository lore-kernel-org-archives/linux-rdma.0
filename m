From: =?UTF-8?B?4KSF4KSo4KWB4KSc?= <anuj01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: got DAT_INVALID_STATE_LMR_IN_USE while running dapltest using
	OFED-1.2
Date: Tue, 2 Mar 2010 17:34:35 +0530
Message-ID: <bb7677341003020404s638d7d06x5e9ed5b3eeb67a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh28-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi list,

I tried to run dapltest utility from ofed-1.2. But got the following
output. Any clues why I got this error and how can I resolve that?

[anuj@tf01 ~]$ dapltest -T T -d -s tf00pn -D OpenIB-cma-2 -i 100
client SR 4096 1 server SR 4096 1
-------------------------------------
TransCmd.server_name              : tf00pn
TransCmd.num_iterations           : 100
TransCmd.num_threads              : 1
TransCmd.eps_per_thread           : 1
TransCmd.validate                 : 0
TransCmd.dapl_name                : OpenIB-cma-2
TransCmd.num_ops                  : 2
TransCmd.op[0].transfer_type      : SEND_RECV  (client)
TransCmd.op[0].seg_size           : 4096
TransCmd.op[0].num_segs           : 1
TransCmd.op[0].reap_send_on_recv  : 0
TransCmd.op[1].transfer_type      : SEND_RECV  (server)
TransCmd.op[1].seg_size           : 4096
TransCmd.op[1].num_segs           : 1
TransCmd.op[1].reap_send_on_recv  : 0
Server Name: tf00pn
Server Net Address: 192.150.10.200
DT_cs_Client: Starting Test ...
DT_cs_Client: IA OpenIB-cma-2 opened
DT_cs_Client: EP created
*****  DAPL  Characteristics  *****
Provider: OpenIB-cma-2  Version 1.0  DAPL 1.2
Adapter:  by  Version 1.0
Supporting:
        4096 EPs with 512 DTOs and 1 RDMA/RDs each
        128 EVDs of up to 262144 entries  (default S/R size is 16/16)
        IOVs of up to 1 elements
        1073741824 LMRs (and 0 RMRs) of up to 0x40000000 bytes
        Maximum MTU 0x1000 bytes, RDMA 0x1000 bytes
        Maximum Private data size 48 bytes
        Local IP address 192.150.10.201
***** ***** ***** ***** ***** *****
DT_cs_Client: Posting 1 recv buffer
DT_cs_Client: Connect Endpoint
DT_cs_Client: Await connection ...
DT_cs_Client: Connected!
DAT_STATE: DAT_EP_STATE_CONNECTED
DAT_STATE: Inbound DTO Status: Active
DAT_STATE: Outbound DTO Status: Idle
DT_cs_Client: Sending Client_Info
DT_cs_Client: Sent Client_Info - awaiting completion
DT_cs_Client: Sending Command
DT_cs_Client: Sent Command - awaiting completion
DT_cs_Client: Waiting for Server_Info
DT_cs_Client: Server_Info Received
DT_cs_Client: Version OK!
-------------------------------------
Server_Info.dapltest_version   : 6
Server_Info.is_little_endian   : 1
-------------------------------------
Client_Info.dapltest_version   : 6
Client_Info.is_little_endian   : 1
Client_Info.test_type          : 1
-------------------------------------
TransCmd.server_name              : tf00pn
TransCmd.num_iterations           : 100
TransCmd.num_threads              : 1
TransCmd.eps_per_thread           : 1
TransCmd.validate                 : 0
TransCmd.dapl_name                : OpenIB-cma-2
TransCmd.num_ops                  : 2
TransCmd.op[0].transfer_type      : SEND_RECV  (client)
TransCmd.op[0].seg_size           : 4096
TransCmd.op[0].num_segs           : 1
TransCmd.op[0].reap_send_on_recv  : 0
TransCmd.op[1].transfer_type      : SEND_RECV  (server)
TransCmd.op[1].seg_size           : 4096
TransCmd.op[1].num_segs           : 1
TransCmd.op[1].reap_send_on_recv  : 0
Client: Starting Client side of test
Client[b0df]: Connect #0 on port 0xb0df
Client[b0df]: Got Connection #0
DT_BpoolAlloc: dat_lmr_create failed DAT_INVALID_STATE
DAT_INVALID_STATE_LMR_IN_USE
Test[b0df]: no memory for buffers (S/R)
dapltest: dapl/common/dapl_ep_free.c:114: dapl_ep_free: Assertion
`ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED ||
ep_ptr->param.ep_state == DAT_EP_STATE_UNCONNECTED' failed.
Aborted


Thanks in Advance
Anuj Aggarwal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
