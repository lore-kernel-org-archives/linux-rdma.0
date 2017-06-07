From: "Thomas Rosenstein" <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Subject: iSER Connection via LIO not working
Date: Wed, 07 Jun 2017 20:15:10 +0200
Message-ID: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

i have setup a lio with 1 LUN on kernel 4.9.11, works fine via iSCSI, =

but when switching to iSER the message logs are spammed with:

Jun  7 17:59:57 at-host-18 kernel: iser: iser_fast_reg_fmr: =

ib_fmr_pool_map_phys failed: -22
Jun  7 17:59:57 at-host-18 kernel: iser: iser_prepare_read_cmd: Failed =

to set up Data-IN RDMA
Jun  7 17:59:57 at-host-18 kernel: iser: iser_send_command: conn =

ffff88239eaf3b30 failed task->itt 127 err -22

Based on the error I found that there was a bug in 4.5.x rc Kernels and =

therefore tried 4.4.71, 4.9.31 and 4.9.27 but all of them have exactly =

the same behaviour.

I got HP DL160 (SE316) with QLogic Infiniband Adapters connected via a =

HP Voltair switch.

ibnetdiag says everything is fine.
Network via ib0 works without issues (can mount the iSCSI via that).
rdma_server and rdma_client both are successful (end 0)

ib_read_bw 10.0.13.3
-------------------------------------------------------------------------=
--------------
Device not recognized to implement inline feature. Disabling it
-------------------------------------------------------------------------=
--------------
                     RDMA_Read BW Test
  Dual-port       : OFF		Device         : qib0
  Number of qps   : 1		Transport type : IB
  Connection type : RC		Using SRQ      : OFF
  TX depth        : 128
  CQ Moderation   : 100
  Mtu             : 4096[B]
  Link type       : IB
  Outstand reads  : 16
  rdma_cm QPs	 : OFF
  Data ex. method : Ethernet
-------------------------------------------------------------------------=
--------------
  local address: LID 0x04 QPN 0x0017 PSN 0xd20eae OUT 0x10 RKey =

0x2d2d300 VAddr 0x007f892ea78000
  remote address: LID 0x13 QPN 0x0d7d PSN 0x66ee4e OUT 0x10 RKey =

0x070800 VAddr 0x007fcf485ee000
-------------------------------------------------------------------------=
--------------
  #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]   =

MsgRate[Mpps]
  65536      1000             3256.60            3156.37		   0.050502
-------------------------------------------------------------------------=
--------------

ib_send_bw 10.0.13.3
-------------------------------------------------------------------------=
--------------
                     Send BW Test
  Dual-port       : OFF		Device         : qib0
  Number of qps   : 1		Transport type : IB
  Connection type : RC		Using SRQ      : OFF
  TX depth        : 128
  CQ Moderation   : 100
  Mtu             : 4096[B]
  Link type       : IB
  Max inline data : 0[B]
  rdma_cm QPs	 : OFF
  Data ex. method : Ethernet
-------------------------------------------------------------------------=
--------------
  local address: LID 0x04 QPN 0x0019 PSN 0xae4e4c
  remote address: LID 0x13 QPN 0x0d89 PSN 0xd25041
-------------------------------------------------------------------------=
--------------
  #bytes     #iterations    BW peak[MB/sec]    BW average[MB/sec]   =

MsgRate[Mpps]
  65536      1000             3232.96            3232.92		   0.051727
-------------------------------------------------------------------------=
--------------

ib_read and ib_send also look fine. (Throughput as expected with 3.2 =

GB/s - 40 Gbit/s QDR)

Also srpt is working, but I need iSCSI.




Does anyone know what the issue could be, or how I can better analyze =

what's happening there?

Thanks
BR
Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
