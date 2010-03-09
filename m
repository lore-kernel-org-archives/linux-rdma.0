From: Larry <tsrjzq-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: problems about opensm 3.3.2
Date: Tue, 9 Mar 2010 10:10:56 +0800
Message-ID: <78022df1003081810x1a2633f3sa4895f7bbc1fe5e4@mail.gmail.com>
References: <78022df1003081806v542ec57dy491fc27e32520d7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <78022df1003081806v542ec57dy491fc27e32520d7e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, all
We have an infiniband network with about 1,000 nodes, and have two
opensm nodes, one active and one standby. But there are a lot of error
in the opensm's log, like that

Mar 08 09:41:05 003518 [4580A940] 0x02 -> SUBNET UP
Mar 08 09:41:06 035406 [42804940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02bf (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 036331 [44007940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02ab (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 037045 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b026b (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 037728 [44808940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02f3 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 038929 [42804940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02d7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 040478 [41001940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b029f (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:06 040642 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02e7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 044892 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02bf (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 046116 [41001940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02ab (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 046564 [44007940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b026b (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 048440 [44808940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02d7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 049224 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02f3 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 050253 [41802940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b029f (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 050455 [44007940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02e7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:09 084310 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x20
trans_id=3D0x8e614b257505) -- dropping
Mar 08 09:41:09 084346 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:09 084366 [4600B940] 0x01 -> Received SMP on a 4 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0
Mar 08 09:41:09 084379 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:09 084424 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x4
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................ 0x4b25=
7505
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x20 (S=
MInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................
0x0000000000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,22,11
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:09 364332 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258973) -- dropping
Mar 08 09:41:09 364370 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:09 364393 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:09 364409 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:09 364465 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
973
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,6,19,24
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:09 412323 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258af8) -- dropping
Mar 08 09:41:09 412358 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:09 412381 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:09 412396 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:09 412451 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
af8
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,10,17,13
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:09 440326 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258b7d) -- dropping
Mar 08 09:41:09 440361 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:09 440384 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:09 440399 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:09 440453 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
b7d
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,10,21,13
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:09 908345 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258bda) -- dropping
Mar 08 09:41:09 908381 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:09 908404 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:09 908420 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:09 908473 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
bda
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,17,11
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:10 168348 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258bde) -- dropping
Mar 08 09:41:10 168386 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:10 168409 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:10 168424 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:10 168479 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
bde
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,17,15
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:10 224344 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c04) -- dropping
Mar 08 09:41:10 224379 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:10 224403 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:10 224417 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:10 224471 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c04
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,22,15
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:10 244310 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c07) -- dropping
Mar 08 09:41:10 244344 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:10 244380 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:10 244395 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:10 244449 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c07
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,22,19
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:10 712361 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c09) -- dropping
Mar 08 09:41:10 712397 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:10 712421 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:10 712436 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:10 712490 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c09
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,22,24
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:10 972363 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c15) -- dropping
Mar 08 09:41:10 972399 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:10 972421 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:10 972436 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:10 972490 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c15
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,8,20,13
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 048363 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c79) -- dropping
Mar 08 09:41:11 056589 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 056620 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 056635 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 056691 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c79
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,13,20
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 056736 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c8c) -- dropping
Mar 08 09:41:11 056768 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 056789 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 056803 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 056856 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c8c
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,14,24
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 516381 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258c95) -- dropping
Mar 08 09:41:11 516418 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 516441 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 516456 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 516510 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
c95
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,15,11
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 776387 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258ca8) -- dropping
Mar 08 09:41:11 776424 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 776447 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 776462 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 776517 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
ca8
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,16,12
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 860388 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258cad) -- dropping
Mar 08 09:41:11 860423 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 860447 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 860461 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 860516 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
cad
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,16,18
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:11 860580 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258cb0) -- dropping
Mar 08 09:41:11 860616 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:11 860639 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:11 860653 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:11 860707 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
cb0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,16,24
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:12 015232 [41001940] 0x01 -> trap_rcv_process_request:
Received Generic Notice type:1 num:128 (Link state change) Producer:2
(Switch) from LID:1212 TID:0x000000000000001f
Mar 08 09:41:12 015332 [41001940] 0x02 -> osm_report_notice: Reporting
Generic Notice type:1 num:128 (Link state change) from LID:1212
GID:fe80::d200:0:0:68
Mar 08 09:41:12 054465 [44007940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02bf (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 055979 [43005940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02ab (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 056121 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b026b (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 057983 [41001940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02d7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 058803 [44007940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02f3 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 060284 [43005940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02e7 (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 061670 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b029f (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:12 320396 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258cbc) -- dropping
Mar 08 09:41:12 320435 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:12 320459 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:12 320476 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:12 320532 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
cbc
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,18,14
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:12 596401 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258d02) -- dropping
Mar 08 09:41:12 596436 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:12 596459 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:12 596473 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:12 596528 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
d02
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,7,21,12
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:12 724423 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258f10) -- dropping
Mar 08 09:41:12 724460 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:12 724484 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:12 724499 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:12 724554 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
f10
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,4,19,17
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:12 756407 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258f91) -- dropping
Mar 08 09:41:12 756431 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:12 756453 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:12 756468 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:12 756522 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
f91
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,11,14,13
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:13 124374 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b258f97) -- dropping
Mar 08 09:41:13 124389 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:13 124398 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:13 124404 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:13 124425 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b258=
f97
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,11,14,20
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:13 516395 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x11
trans_id=3D0x8e614b259178) -- dropping
Mar 08 09:41:13 516410 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:13 516419 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:13 516426 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:13 516446 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b259=
178
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x11 (N=
odeInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,9,24,11
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:13 596432 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x15
trans_id=3D0x8e614b25933a) -- dropping
Mar 08 09:41:13 596470 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:13 596494 [4600B940] 0x01 -> Received SMP on a 6 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0,0,=
0
Mar 08 09:41:13 596509 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:13 596565 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x6
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b259=
33a
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x15 (P=
ortInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,1,6,19,14
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:14 784437 [4600B940] 0x01 -> umad_receiver: ERR 5409:
send completed with error (method=3D0x1 attr=3D0x20
trans_id=3D0x8e614b25bb1b) -- dropping
Mar 08 09:41:14 784468 [4600B940] 0x01 -> umad_receiver: ERR 5411: DR
SMP Hop Ptr: 0x0
Mar 08 09:41:14 784478 [4600B940] 0x01 -> Received SMP on a 4 hop path:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path =3D 0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path=A0 =3D 0,0,0,0,0
Mar 08 09:41:14 784486 [4600B940] 0x01 -> sm_mad_ctrl_send_err_cb: ERR
3113: MAD completed in error (IB_TIMEOUT)
Mar 08 09:41:14 784508 [4600B940] 0x01 -> SMP dump:
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 base_ver................0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 mgmt_class..............0x81
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 class_ver...............0x1
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 method..................0x1 (Su=
bnGet)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 D bit...................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 status..................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_ptr.................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 hop_count...............0x4
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 trans_id................0x4b25b=
b1b
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_id.................0x20 (S=
MInfo)
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 resv....................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 attr_mod................0x0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 m_key...................0x00000=
00000000000
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_slid.................65535
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 dr_dlid.................65535

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Initial path: 0,1,1,22,11
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Return path:=A0 0,0,0,0,0
=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Reserved:=A0=A0=A0=A0 [0][0][0]=
[0][0][0][0]

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 00 00 00 00 00 00 00 00=A0=A0 0=
0 00 00 00 00 00 00 00

Mar 08 09:41:15 064054 [42003940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02bf (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
Mar 08 09:41:15 065782 [42804940] 0x01 -> mcmr_rcv_join_mgrp: ERR
1B12: validate_more_comp_fields, validate_port_caps, or JoinState =3D 0
failed from port 0x0008f100010b02ab (ISR2012 Voltaire sFB-2012),
sending IB_SA_MAD_STATUS_REQ_INVALID
=2E..
=2E..

After the opensm runs for about 20 days, it dies; and changes to the
standby one(sm2). And about 20 days more, the process on sm2 also
dies. Every node cannot communicate with opensm until restarting the
process manually. I think this have some business with the errors in
log. So what does the ERR 1B12, 5409, 5413 mean? How to configure the
opensm correctly? Thanks a lot
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
