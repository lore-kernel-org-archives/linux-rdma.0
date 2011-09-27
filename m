From: "Manoj Nambiar" <manoj_n09-kXrGd1YOZaxBDgjK7y7TUQ@public.gmane.org>
Subject: Issue with ibv_post_send
Date: Tue, 27 Sep 2011 09:53:19 +0530
Message-ID: <E3692BCE687F4FC6ABC395098AA5ECF7@01hw294151>
Reply-To: "Manoj Nambiar" <nambiar-EkmVulN54Sk@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I have an issue with ibv_post_send.

Here is what I am doing ....

I have 3 work requests (chained with the next field =E2=80=93 last next=
 set to=20
NULL). Each work request has one sg_list entry.

the wr_id=E2=80=99s are 0, 1 and 2.
All opcodes are  IBV_WR_RDMA_WRITE.
All send_flags    =3D IBV_SEND_INLINE | IBV_SEND_SIGNALED;

Mellanox NIC =3D InfiniBand: Mellanox Technologies MT26428 [ConnectX VP=
I PCIe=20
2.0 5GT/s - IB QDR / 10GigE] (rev b0)
(HCA Firmware version: 2.8.600)

I am using RDMA CM
The OS is Linux ...... 2.6.18-164.el5 #1 SMP Fri Sep 17 12:37:48 PDT 20=
10=20
x86_64 x86_64 x86_64 GNU/Linux

After all the initializations (memory registrations, etc ......) my pro=
cess=20
executes its first ibv_post_send.

it returns =E2=80=931.

I look at the first element of bad_wr updated by the call. It shows a w=
ork=20
id (wr_id field) that is totally unrelated (anything but 0, 1 or 2).

I print errno =E2=80=93 The value is zero.

Infiniband software I am using is MLNX OFED 1.5.1

(If I send only one work request in ibv_post_send - it works.)

BTW - The same code has worked on a Intel NetEffect card before on a Ub=
untu=20
10.04 server OS =E2=80=93 no issues.

How do I go about debugging this problem? I have put in additional deta=
ils=20
below.

Thanks,
Manoj


Additional details


code snips=20
start -----------------------------------------------------------------=
-----------------------------
int rc;
struct ibv_send_wr bad_send_wr[3];
=2E
=2E
=2E
bad_send_wr[0].wr_id =3D bad_send_wr[1].wr_id =3D bad_send_wr[2].wr_id =
=3D 0; //=20
no other init or memset of bad_send_wr array
errno =3D 0;
rc =3D ibv_post_send(rdmaptr->cm_id->qp, &rdmaptr->wr[0], &bad_send_wr)=
;
if (rc){
    printf("There is something wrong in this RDMA write case rc =3D %d,=
 wr_id=20
=3D %d, errno =3D %d\n", rc, bad_send_wr[0].wr_id, errno);
    exit(1);
=2E

code snips=20
end -------------------------------------------------------------------=
------------------------------

gdb snip start (breakpoint on=20
printf)----------------------------------------------------------------=
-------
(gdb) p rc
$17 =3D <value optimized out> #my comment - printf prints rc as -1
(gdb) p rdmaptr->wr[0]
$18 =3D {wr_id =3D 0, next =3D 0x7fff6703bfe0, sg_list =3D 0x7fff6703c0=
80,
  num_sge =3D 1, opcode =3D IBV_WR_RDMA_WRITE, send_flags =3D 10, imm_d=
ata =3D 0,
  wr =3D {rdma =3D {remote_addr =3D 47878802383600, rkey =3D 3892586125=
}, atomic =3D {
      remote_addr =3D 47878802383600, compare_add =3D 3892586125, swap =
=3D 0,
      rkey =3D 0}, ud =3D {ah =3D 0x2b8ba70222f0, remote_qpn =3D 389258=
6125,
      remote_qkey =3D 0}}, xrc_remote_srq_num =3D 0}
(gdb) p rdmaptr->wr[1]
$19 =3D {wr_id =3D 1, next =3D 0x7fff6703c030, sg_list =3D 0x7fff6703c0=
90,
  num_sge =3D 1, opcode =3D IBV_WR_RDMA_WRITE, send_flags =3D 10, imm_d=
ata =3D 0,
  wr =3D {rdma =3D {remote_addr =3D 47878802319112, rkey =3D 3892586125=
}, atomic =3D {
      remote_addr =3D 47878802319112, compare_add =3D 3892586125, swap =
=3D 0,
      rkey =3D 0}, ud =3D {ah =3D 0x2b8ba7012708, remote_qpn =3D 389258=
6125,
      remote_qkey =3D 0}}, xrc_remote_srq_num =3D 0}
(gdb) p rdmaptr->wr[2]
$20 =3D {wr_id =3D 2, next =3D 0x0, sg_list =3D 0x7fff6703c0a0, num_sge=
 =3D 1,
  opcode =3D IBV_WR_RDMA_WRITE, send_flags =3D 10, imm_data =3D 0, wr =3D=
 {rdma =3D {
      remote_addr =3D 47878802319088, rkey =3D 3892586125}, atomic =3D =
{
      remote_addr =3D 47878802319088, compare_add =3D 3892586125, swap =
=3D 0,
      rkey =3D 0}, ud =3D {ah =3D 0x2b8ba70126f0, remote_qpn =3D 389258=
6125,
      remote_qkey =3D 0}}, xrc_remote_srq_num =3D 0}
(gdb) p &rdmaptr->wr[1]
$21 =3D (struct ibv_send_wr *) 0x7fff6703bfe0 # my comment -  just to s=
how=20
that this is next in list to rdmaptr->wr[0]
(gdb) p &rdmaptr->wr[1]
$22 =3D (struct ibv_send_wr *) 0x7fff6703bfe0 # my comment -  just to s=
how=20
that this is next in list to rdmaptr->wr[1]
(gdb) p &rdmaptr->wr[2]
$23 =3D (struct ibv_send_wr *) 0x7fff6703c030
(gdb)  p rdmaptr->wr[0].sg_list[0]
$24 =3D {addr =3D 47966518199024, length =3D 512, lkey =3D 2684626508}
(gdb)  p rdmaptr->wr[1].sg_list[0]
$25 =3D {addr =3D 47966518134536, length =3D 8, lkey =3D 2684626508}
(gdb)  p rdmaptr->wr[2].sg_list[0]
$26 =3D {addr =3D 47966518134512, length =3D 8, lkey =3D 2684626508}
(gdb) p errno
$27 =3D 0
(gdb) p bad_send_wr[0]
$28 =3D {wr_id =3D 140734921686928, next =3D 0x2ba013203fc8,
  sg_list =3D 0x7fff6703bd10, num_sge =3D 1728298176, opcode =3D 32767,
  send_flags =3D -338177694, imm_data =3D 0, wr =3D {rdma =3D {
      remote_addr =3D 140734921686232, rkey =3D 0}, atomic =3D {
      remote_addr =3D 140734921686232, compare_add =3D 0, swap =3D 2124=
79283730,
      rkey =3D 0}, ud =3D {ah =3D 0x7fff6703bcd8, remote_qpn =3D 0, rem=
ote_qkey =3D=20
0}},
  xrc_remote_srq_num =3D 0}
(gdb) p bad_send_wr[1]
$29 =3D {wr_id =3D 0, next =3D 0x2ba013203c68, sg_list =3D 0x1, num_sge=
 =3D -1,
  opcode =3D IBV_WR_RDMA_WRITE, send_flags =3D 1, imm_data =3D 0, wr =3D=
 {rdma =3D {
      remote_addr =3D 2184432, rkey =3D 1728298720}, atomic =3D {
      remote_addr =3D 2184432, compare_add =3D 140734921686752,
      swap =3D 47966518132736, rkey =3D 323070272}, ud =3D {ah =3D 0x21=
54f0,
      remote_qpn =3D 1728298720, remote_qkey =3D 32767}},
  xrc_remote_srq_num =3D 194951584}
(gdb) p bad_send_wr[2]
$30 =3D {wr_id =3D 0, next =3D 0x3178c0cd15, sg_list =3D 0x2ba000000001=
, num_sge =3D=20
0,
  opcode =3D IBV_WR_RDMA_WRITE, send_flags =3D 320876544, imm_data =3D =
11168, wr =3D=20
{
    rdma =3D {remote_addr =3D 4195498, rkey =3D 320888632}, atomic =3D =
{
      remote_addr =3D 4195498, compare_add =3D 47966515650360, swap =3D=
 10005,
      rkey =3D 1728298512}, ud =3D {ah =3D 0x4004aa, remote_qpn =3D 320=
888632,
      remote_qkey =3D 11168}}, xrc_remote_srq_num =3D 2025924754}

gdb snip end(breakpoint on=20
printf)----------------------------------------------------------------=
-------=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
