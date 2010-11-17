From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: rdma_lat whos
Date: Wed, 17 Nov 2010 12:54:13 +0200
Message-ID: <4CE3B455.4080003@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis@v>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ido, 

We came into a situation where running rdma_lat with vs with out the -c flag, which means w. or w.o using the rdma-cm introduces a notable ~1us difference in latency for 1k messages, that is ~3us w.o using rdma-cm and 3.9us when using the rdma-cm.

I have reproduced that now with the latest code from your git tree and also with the RHEL provided package of perftest-1.2.3-1.el5, see the results below. Also, your tree is not available through the ofa git web service, Vlad, can you help set this out.

Now, Jack, using this patch, 


Index: perftest/rdma_lat.c
===================================================================
--- perftest.orig/rdma_lat.c
+++ perftest/rdma_lat.c
@@ -666,7 +666,7 @@ static int pp_connect_ctx(struct pingpon
 {
 	struct ibv_qp_attr attr = {
 		.qp_state 		= IBV_QPS_RTR,
-		.path_mtu 		= IBV_MTU_256,
+		.path_mtu 		= IBV_MTU_2048,
 		.dest_qp_num 	= data->rem_dest->qpn,
 		.rq_psn 		= data->rem_dest->psn,
 		.max_dest_rd_atomic = 1,




I could get rdma_lat which doesn't use the rdma-cm, which means setting all the low-level QP params 
"by the hand" to produce the SAME result of 3.9us as with the rdma-cm, as you can see its one liner 
patch which uses higher MTU of 2048 vs the hard coded MTU of 256 used in the code. This is quite counter 
intuitive, for packets whose size is > 256, correct? is there any known issue that can 
explain that?! The SA is convinced that 2048 (0x84) is the best MTU for that path, both nodes 
have ConnectX DDR with firmware 2.7.0 

Or.


> # saquery -p --src-to-dst 1:14
> Path record for 1 -> 14
> PathRecord dump:
>                 service_id..............0x0000000000000000
>                 dgid....................fe80::8:f104:399:3c91
>                 sgid....................fe80::2:c903:2:6be3
>                 dlid....................0xE
>                 slid....................0x1
>                 hop_flow_raw............0x0
>                 tclass..................0x0
>                 num_path_revers.........0x80
>                 pkey....................0xFFFF
>                 qos_class...............0x0
>                 sl......................0x0
>                 mtu.....................0x84
>                 rate....................0x86
>                 pkt_life................0x92
>                 preference..............0x0
>                 resv2...................0x0
>                 resv3...................0x0


before the patch

active side, w.o rdma-cm
> # rdma_lat 192.168.20.15 -s 1024 -n 10000
> 26113:pp_client_connect: Couldn't connect to 192.168.20.15:18515
> [root@nsg1 ~]# rdma_lat 192.168.20.15 -s 1024 -n 10000
>    local address: LID 0x0e QPN 0x1c004d PSN 0x3a3dca RKey 0x48002600 VAddr 0x00000008a71400
>   remote address: LID 0x04 QPN 0x20004c PSN 0x27973 RKey 0x50042700 VAddr 0x0000001b724400
> Latency typical: 3.01932 usec
> Latency best   : 2.97582 usec
> Latency worst  : 11.3183 usec

passive side w.o rdma-cm
> # rdma_lat -s 1024 -n 10000
>    local address: LID 0x04 QPN 0x20004c PSN 0x27973 RKey 0x50042700 VAddr 0x0000001b724400
>   remote address: LID 0x0e QPN 0x1c004d PSN 0x3a3dca RKey 0x48002600 VAddr 0x00000008a71400
> Latency typical: 3.02386 usec
> Latency best   : 2.97436 usec
> Latency worst  : 6.63569 usec

active side, w.o rdma-cm
> # rdma_lat 192.168.20.15 -s 1024 -n 10000 -c
> 26133: Local address:  LID 0000, QPN 000000, PSN 0xa12538 RKey 0x50002600 VAddr 0x00000013d27400
> 26133: Remote address: LID 0000, QPN 000000, PSN 0x5c01e8, RKey 0x58042700 VAddr 0x00000006dbb400
> 
> Latency typical: 3.89977 usec
> Latency best   : 3.83227 usec
> Latency worst  : 13.6462 usec

passive side, w.o rdma-cm

> # rdma_lat -s 1024 -n 10000 -c
> 21826: Local address:  LID 0000, QPN 000000, PSN 0x5c01e8 RKey 0x58042700 VAddr 0x00000006dbb400
> 21826: Remote address: LID 0000, QPN 000000, PSN 0xa12538, RKey 0x50002600 VAddr 0x00000013d27400
> 
> Latency typical: 3.89982 usec
> Latency best   : 3.83082 usec
> Latency worst  : 13.6974 usec

after the patch, the result w.o -c and with MTU=2048 becomes 3.9us as well,

>  /home/ogerlitz/linux/tools/perftest/rdma_lat 192.168.20.15 -s 1024 -n 10000
>    local address: LID 0x0e QPN 0x3c004d PSN 0x14ff1e RKey 0x68002600 VAddr 0x00000016c5d400
>   remote address: LID 0x04 QPN 0x40004c PSN 0xba137e RKey 0x70042700 VAddr 0x0000001f259400
> Latency typical: 3.88327 usec
> Latency best   : 3.80378 usec
> Latency worst  : 8.27951 usec


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
