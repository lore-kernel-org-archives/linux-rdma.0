From: Konstantin Boyanov <boyanov-/DgOsau14IQ@public.gmane.org>
Subject: InfiniBand HCA loopback on a single host (subnet manager needed?)
Date: Wed, 9 Mar 2011 09:04:39 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1103090903140.15803@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello list,

I want to apologize if I am intruding some development-only mailing list 
with my questions, but that is the only mailing list considering 
InfiniBand and Linux which I was able to find.

But let me tell you why I am writing this email - we have one dual-GPU 
server with and InfiniBand HCA on it. In the future we would like to test 
GPU-to-GPU communication between two or more hosts through the IB HCA, but 
for now we just want to test how much time  is needed by some packet to 
travel from system memory / GPU memory to the IB HCA.
I think this is achievable on a single host by using the loopback 
capabilities of the InfiniBand HCA. The problem is, that I was not able to 
find a comprehensive description of how one sets up such loopback 
operation on the HCA chip.

The only thing i have found in this regard is a snippet from a rather old 
SunVTS 6.2 Test Reference Manual for x86:

<CITE>
The HCA supports internal loopback for packets transmitted between QPs 
that are assigned to the same HCA port. If a packet is being transmitted 
to a DLID that is equivalent to the Port LID with the LMC bits masked out 
or the packet DLID is a multicast LID, the packet goes on the loopback 
path. In this latter case, the packet also is transmitted to the fabric. 
In the inbound direction, the ICRC and VCRC checks are blindly passed for 
looped back packets. Note that internal loopback is supported only for 
packets that are transmitted and received on the same port. Packets that 
are transmitted on one port and received on another port are transmitted 
to the fabric. The fabric directs these packets to the destination port.
<ENDCITE>

I don't know whether or not this is still true (or true at all) for the 
case of our HCA (Mellanox ConnectX dual port QDR MT25408 chip). Can 
someone with experience in setting up such loopback shed some light on 
this?

Another question - must there be a subnet manager running on the box, so 
the port(s) get configured properly or the loopback operation of the HCA 
does not require it?

I have dug through the examples in OFED-1.4/src/perftest-1.2 and with its 
help have up until now managed to create a single-threaded program which 
can sucesfully open the HCA, set up two different QPs. Unfortunately the 
programm crashes with a segmentation fault just at begining of 
transmission of data between the two QPs and I am wondering if this is not 
due to the lack of and subnet manager, wrong (or lacking configuration) or 
just my awesome programming skills (see end of mail).

You can find the source of my program here:
http://www.ifh.de/~boyanov/gpeIBloopback.cc
http://www.ifh.de/~boyanov/gpeIBloopback.h

Any ideas, comments or suggestions regarding the questions described above 
are highly appreciated! Please let me know if anything does not make sense 
or you need more information on the subject.


With best regards,
Konstantin Boyanov



# uname -a
Linux gpu1.ifh.de 2.6.18-194.26.1.el5 #1 SMP Tue Nov 9 12:46:16 EST 2010 
x86_64 x86_64 x86_64 GNU/Linux

# ibv_devinfo:
hca_id:	mlx4_0
 	transport:			InfiniBand (0)
 	fw_ver:				2.7.626
 	node_guid:			0002:c903:000b:e242
 	sys_image_guid:			0002:c903:000b:e245
 	vendor_id:			0x02c9
 	vendor_part_id:			26428
 	hw_ver:				0xB0
 	board_id:			MT_0D90110009
 	phys_port_cnt:			1
 		port:	1
 			state:			PORT_DOWN (1)
 			max_mtu:		2048 (4)
 			active_mtu:		2048 (4)
 			sm_lid:			0
 			port_lid:		0
 			port_lmc:		0x00

Output from GDB:
################
Starting program: /user/b/boyanov/workspace/GPEubench/src/ibloop 
--len-min=1024 --len-max=8192 --len-inc=1024 --nmeas=1 --npass=1 --conn=0 
--txdpth=64 --port=1
[Thread debugging using libthread_db enabled]
optLenMin = 1024, optLenMax = 8192, optLenInc = 1024, optNmeas = 1, 
optNpass = 1
# dev_name:   uverbs0
# dev_path:   /sys/class/infiniband_verbs/uverbs0
# ibdev_path: /sys/class/infiniband/mlx4_0
# name: 	  mlx4_0


Data fields in ibv_device_attr:
atomic_cap = 1
device_cap_flags = 7117942
local_ca_ack_delay = 15
max_ah = 0
max_cq = 65408
max_cqe = 4194303
max_ee = 0
max_ee_init_rd_atom = 0
max_ee_rd_atom = 0
max_fmr = 0
max_map_per_fmr = 8191
max_map_per_fmr = 8192
max_mcast_qp_attach = 56
max_mcast_qp_attach = 524272
max_mr_size = 18446744073709551615
max_mw = 0
max_pd = 32764
max_pkeys = 128
max_qp = 261824
max_qp_init_rd_atom = 128
max_qp_rd_atom = 16
max_qp_wr = 16351
max_raw_ethy_qp = 1
max_raw_ipv6_qp = 0
max_rdd = 0
max_res_rd_atom = 4189184
max_sg = e32
max_sge_rd = 0
max_srq = 65472
max_srq_sge = 31
max_srq_wr = 16383
max_total_mcast_qp_attach = 458752
node_guid = 4819426645931262464
page_size_cap = 4294966784
phys_port_cnt = 1
sys_image_guid = 5035599428045046272
vendor_id = 713
vendor_part_id = 26428


qp_state = 1
path_mig_state = 0
qkey = 286331153
rq_psn = 0
sq_psn = 1441792
dest_qp_num = 0
qp_access_flags = 352
pkey_index = 0
alt_pkey_index = 0
en_sqd_async_notify = 55
sq_draining = 0
max_rd_atomic = 0
max_dest_rd_atomic = 0
min_rnr_timer = 0
port_num = 1
timeout = 0
retry_cnt = 0
rnr_retry = 0
alt_port_num = 0
alt_timeout = 0


qp_state = 1
path_mig_state = 0
qkey = 286331153
rq_psn = 0
sq_psn = 1441792
dest_qp_num = 0
qp_access_flags = 352
pkey_index = 0
alt_pkey_index = 0
en_sqd_async_notify = 170
sq_draining = 0
max_rd_atomic = 0
max_dest_rd_atomic = 0
min_rnr_timer = 0
port_num = 1
timeout = 0
retry_cnt = 0
rnr_retry = 0
alt_port_num = 0
alt_timeout = 0

QP number = 2097225
QP handle = 0
QP state = 1
QP type = 4
QP events completed = 0

QP number = 2097226
QP handle = 1
QP state = 1
QP type = 4
QP events completed = 0

set the send work request fields
set the receive work request fields

      local address: LID 0000 QPN 0x200049 PSN 0x204a16 RKEY 
0x000000b0041c24 VADDR 0x00000000606010
   remote address: LID 0000 QPN 0x20004a PSN 0x442a26 RKEY 0x000000b0041c24 
VADDR 0x00000000606010

PING

Program received signal SIGSEGV, Segmentation fault.
0x00002aaaab006037 in ibv_cmd_create_qp () from 
/usr/lib64/libmlx4-rdmav2.so
(gdb) bt
#0  0x00002aaaab006037 in ibv_cmd_create_qp () from 
/usr/lib64/libmlx4-rdmav2.so
#1  0x00000000004010ba in ibv_post_send (qp=0x605da0, wr=0x7fffffffdf10, 
bad_wr=0x7fffffffe0b0) at /usr/include/infiniband/verbs.h:1000
#2  0x000000000040270b in main (argc=9, argv=0x7fffffffe1f8) at 
gpeIBloopback.cc:557




Konstantin Boyanov
DESY Zeuthen, Platanenallee 6, 15738 Zeuthen
Tel.:+49(33762)77178
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
