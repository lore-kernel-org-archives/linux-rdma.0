From: Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: CQ overrun with ib_send_bw
Date: Fri, 13 Aug 2010 11:44:24 -0700
Message-ID: <4C659288.4030402@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hi,

If I run ib_send_bw with the -a option, we seem to be getting CQ overrun 
errors.

Server :
[root@dscbad01 ~]# ib_send_bw
------------------------------------------------------------------
                    Send BW Test
Connection type : RC
Inline data is used up to 1 bytes message
  local address:  LID 0x24, QPN 0x1c004c, PSN 0x85c292
  remote address: LID 0x2a, QPN 0x14004a, PSN 0x858358
Mtu : 2048
------------------------------------------------------------------
 #bytes #iterations    BW peak[MB/sec]    BW average[MB/sec] 
------------------------------------------------------------------

Client :
[root@dscbad03 ~]# ib_send_bw -a dscbad01
------------------------------------------------------------------
                    Send BW Test
Connection type : RC
Inline data is used up to 1 bytes message
  local address:  LID 0x2a, QPN 0x14004a, PSN 0x858358
  remote address: LID 0x24, QPN 0x1c004c, PSN 0x85c292
Mtu : 2048
------------------------------------------------------------------
 #bytes #iterations    BW peak[MB/sec]    BW average[MB/sec] 
      2        1000               5.99                  5.45
Completion wth error at client:
Failed status 12: wr_id 1 syndrom 0x81
scnt=600, ccnt=300

and on the client console

mlx4_core 0000:13:00.0: CQ overrun on CQN 000086
mlx4_core 0000:13:00.0: Internal error detected:
mlx4_core 0000:13:00.0:   buf[00]: 00328f6f
mlx4_core 0000:13:00.0:   buf[01]: 00000000
mlx4_core 0000:13:00.0:   buf[02]: 20070000
mlx4_core 0000:13:00.0:   buf[03]: 00000000
mlx4_core 0000:13:00.0:   buf[04]: 00328f3c
mlx4_core 0000:13:00.0:   buf[05]: 0014004a
mlx4_core 0000:13:00.0:   buf[06]: 00340000
mlx4_core 0000:13:00.0:   buf[07]: 00000044
mlx4_core 0000:13:00.0:   buf[08]: 00000804
mlx4_core 0000:13:00.0:   buf[09]: 00000804
mlx4_core 0000:13:00.0:   buf[0a]: 00000000
mlx4_core 0000:13:00.0:   buf[0b]: 00000000
mlx4_core 0000:13:00.0:   buf[0c]: 00000000
mlx4_core 0000:13:00.0:   buf[0d]: 00000000
mlx4_core 0000:13:00.0:   buf[0e]: 00000000
mlx4_core 0000:13:00.0:   buf[0f]: 00000000

This is with OFED 1.5.1 but it also happens with OFED 1.4.2. Sometimes, 
the node crashes because it runs out of memory but most of the time, I 
see just the above errors. What could be wrong?

- Sumeet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
