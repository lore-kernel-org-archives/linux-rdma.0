From: =?UTF-8?B?4KSF4KSo4KWB4KSc?= <anuj01-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: got DAT_INVALID_STATE_LMR_IN_USE with dapltest
Date: Mon, 8 Mar 2010 14:15:44 +0530
Message-ID: <bb7677341003080045k7ff9c620i5e07f0c63004a492@mail.gmail.com>
References: <bb7677341003051038g60e537bft9bddaf57f24b0238@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bb7677341003051038g60e537bft9bddaf57f24b0238-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Devesh Sharma <devesh28-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aniket Agashe <agasheac-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi list,

I tried to run dapltest utility from OFED. But got the output below.
=C2=A0Any clues why I got this error and how can I resolve that?

I am having some background of IB uverbs. But I'm new to udapl. So plz
correct me if m wrong.

As per my knowledge, if there is duplicated lmr context while
registering the memory,
then because of use of hash tables in udapl implementation
(dapl_lmr_create), we can get DAT_INVALID_STATE_LMR_IN_USE.
m I right?
And if yes, then if underlying network (driver+hca) is such that it
can generate the same lmr context for
different memory regions being registered ( and can also represent
that registered memory region uniquely
by the combination of memory region virtual address (VA) and lmr
context. Then in this case how the above mentioned problem
can be resolved? Any suggestions?

Please redirect me to any pointer, patch or anything else if already av=
ailable.


[anuj@tf01 ~]$ dapltest -T T -d -s tf00pn -D OpenIB-cma-2 -i 100
client SR 4096 1 server SR 4096 1
-------------------------------------
TransCmd.server_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: =
tf00pn
TransCmd.num_iterations =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 100
TransCmd.num_threads =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: =
1
TransCmd.eps_per_thread =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.validate =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 : 0
TransCmd.dapl_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: OpenIB-cma-2
TransCmd.num_ops =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0: 2
TransCmd.op[0].transfer_type =C2=A0 =C2=A0 =C2=A0: SEND_RECV =C2=A0(cli=
ent)
TransCmd.op[0].seg_size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 4096
TransCmd.op[0].num_segs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.op[0].reap_send_on_recv =C2=A0: 0
TransCmd.op[1].transfer_type =C2=A0 =C2=A0 =C2=A0: SEND_RECV =C2=A0(ser=
ver)
TransCmd.op[1].seg_size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 4096
TransCmd.op[1].num_segs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.op[1].reap_send_on_recv =C2=A0: 0
Server Name: tf00pn
Server Net Address: 192.150.10.200
DT_cs_Client: Starting Test ...
DT_cs_Client: IA OpenIB-cma-2 opened
DT_cs_Client: EP created
***** =C2=A0DAPL =C2=A0Characteristics =C2=A0*****
Provider: OpenIB-cma-2 =C2=A0Version 1.0 =C2=A0DAPL 1.2
Adapter: =C2=A0by =C2=A0Version 1.0
Supporting:
=C2=A0 =C2=A0 =C2=A0 4096 EPs with 512 DTOs and 1 RDMA/RDs each
=C2=A0 =C2=A0 =C2=A0 128 EVDs of up to 262144 entries =C2=A0(default S/=
R size is 16/16)
=C2=A0 =C2=A0 =C2=A0 IOVs of up to 1 elements
=C2=A0 =C2=A0 =C2=A0 1073741824 LMRs (and 0 RMRs) of up to 0x40000000 b=
ytes
=C2=A0 =C2=A0 =C2=A0 Maximum MTU 0x1000 bytes, RDMA 0x1000 bytes
=C2=A0 =C2=A0 =C2=A0 Maximum Private data size 48 bytes
=C2=A0 =C2=A0 =C2=A0 Local IP address 192.150.10.201
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
Server_Info.dapltest_version =C2=A0 : 6
Server_Info.is_little_endian =C2=A0 : 1
-------------------------------------
Client_Info.dapltest_version =C2=A0 : 6
Client_Info.is_little_endian =C2=A0 : 1
Client_Info.test_type =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: 1
-------------------------------------
TransCmd.server_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: =
tf00pn
TransCmd.num_iterations =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 100
TransCmd.num_threads =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: =
1
TransCmd.eps_per_thread =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.validate =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 : 0
TransCmd.dapl_name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0: OpenIB-cma-2
TransCmd.num_ops =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0: 2
TransCmd.op[0].transfer_type =C2=A0 =C2=A0 =C2=A0: SEND_RECV =C2=A0(cli=
ent)
TransCmd.op[0].seg_size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 4096
TransCmd.op[0].num_segs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.op[0].reap_send_on_recv =C2=A0: 0
TransCmd.op[1].transfer_type =C2=A0 =C2=A0 =C2=A0: SEND_RECV =C2=A0(ser=
ver)
TransCmd.op[1].seg_size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 4096
TransCmd.op[1].num_segs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 1
TransCmd.op[1].reap_send_on_recv =C2=A0: 0
Client: Starting Client side of test
Client[b0df]: Connect #0 on port 0xb0df
Client[b0df]: Got Connection #0
DT_BpoolAlloc: dat_lmr_create failed DAT_INVALID_STATE
DAT_INVALID_STATE_LMR_IN_USE
Test[b0df]: no memory for buffers (S/R)
dapltest: dapl/common/dapl_ep_free.c:114: dapl_ep_free: Assertion
`ep_ptr->param.ep_state =3D=3D DAT_EP_STATE_DISCONNECTED ||
ep_ptr->param.ep_state =3D=3D DAT_EP_STATE_UNCONNECTED' failed.
Aborted


Thanks in Advance

Regards,
Anuj Aggarwal

--

=C2=A0.''`.
: :=E2=92=B6 : =C2=A0 # apt-get install hakuna-matata
`. `'`
=C2=A0 `-
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
