From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: are IB port counters functioning over --IB-- with the RDMAoE  patch
 set?
Date: Thu, 27 May 2010 12:04:55 +0300
Message-ID: <4BFE35B7.80009@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli, Vlad, 

Using some lab node here, I noticed that the IB port counters were not functioning over --IB-- with the RDMAoE patches present in an OFED drop named OFED-RDMAoE-1.5-rc6, see below.

Was/is this a known issue? if yes, was it fixed? is/was there an ofa bz case open for this? I didn't find such... I was told that under ofed 1.5.1 this doesn't happen, but I wanted to 1st clarify with you.

Or.


> > [root@dodly4 ~]# rdma_bw dodly0
> > 15050: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | sl=0 | iters=1000 | duplex=0 | cma=0 |
> > 15050: Local address:  LID 0x03, QPN 0x14004a, PSN 0x5fb3a8 RKey 0x2804260c VAddr 0x002acb54d6a000
> > 15050: Remote address: LID 0x04, QPN 0x250406, PSN 0xf6d97d, RKey 0x28043c04 VAddr 0x002b9026b6a000
> > 15050: Bandwidth peak (#0 to #989): 938.697 MB/sec
> > 15050: Bandwidth average: 938.695 MB/sec --> the link is SDR, so the result makes sense
> > 15050: Service Demand peak (#0 to #989): 3113 cycles/KB
> > 15050: Service Demand Avg  : 3113 cycles/KB
>   
> > [root@dodly4 ~]# perfquery
> > ibwarn: [15057] dump_perfcounters: PortXmitWait not indicated so ignore this counter
> > # Port counters: Lid 3 port 1
> > PortSelect:......................1
> > CounterSelect:...................0x0000
> > SymbolErrors:....................0
> > LinkRecovers:....................0
> > LinkDowned:......................0
> > RcvErrors:.......................0
> > RcvRemotePhysErrors:.............0
> > RcvSwRelayErrors:................0
> > XmtDiscards:.....................0
> > XmtConstraintErrors:.............0
> > RcvConstraintErrors:.............0
> > CounterSelect2:..................0x00
> > LinkIntegrityErrors:.............0
> > ExcBufOverrunErrors:.............0
> > VL15Dropped:.....................0
> > XmtData:.........................72
> > RcvData:.........................0
> > XmtPkts:.........................1
> > RcvPkts:.........................0
> > XmtWait:.........................0
>   
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
