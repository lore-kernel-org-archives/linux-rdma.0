From: jeff-ruUnomVL5WBWk0Htik3J/w@public.gmane.org (Jeff Haferman)
Subject: Re: rdma problems on Sun / ConnectX hardware
Date: Sun,  3 Jan 2010 12:00:23 -0800 (PST)
Message-ID: <20100103200023.169DF1D90008@adint.net>
Reply-To: jeff-ruUnomVL5WBWk0Htik3J/w@public.gmane.org
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


I tried posting this to general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org and got an auto-reply saying that
list is no longer active and to instead post here... I posted here a few days ago but
no response, so, my question is, does anyone have any ideas, or, is there a more
appropriate place to post?

I've made a bit of progress, with the latest ibtools there is a "-F" option that can be
passed to "ib_write_lat" to ignore cpufreq stuff, and I now get latencies returned.  

"rping" however always seems to fail with CQ errors.

mvapich / openmpi over infiniband usually fails with CQ errors but sometimes my test
programs run to completion.

Original message below:

> OS = Centos 5.2
> 
> We have a Sun Blade system with Sun IB products 
> (switch= Sun part number X2821A-Z 36 port QDR switch)
> (hcas = Sun part number X4216A-Z dual port DDR PCI-E)
> 
> I can SOMETIMES run mvapich or openmpi over IB and it works, but generally I get
> a "CQ polling error".  So I went back to the rdma tests and see some problems.
> 
> We have installed OFED 1.4.1-4, and because I was having problems I upgraded the firmware on the HCAS:
> 
> lspci | grep -i infin
> 0b:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX IB DDR, PCIe 2.0 2.5GT/s] (rev a0)
> 
> mstflint -d 0b:00.0 q 
> Image type:      ConnectX
> FW Version:      2.6.0
> Device ID:       25418
> Chip Revision:   A0
> Description:     Node             Port1            Port2            Sys
> image
> GUIDs:           0003ba000100d770 0003ba000100d771 0003ba000100d772
> 0003ba000100d773 
> MACs:                             0003ba00d771     0003ba00d772     
> Board ID:         (SUN0060000001)
> VSD:             
> PSID:            SUN0060000001
> 
> An rping from the client to server gives
> verbose
> client
> created cm_id 0x10ca7c70
> cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x10ca7c70 (parent)
> cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0x10ca7c70 (parent)
> rdma_resolve_addr - rdma_resolve_route successful
> created pd 0x10caa3d0
> created channel 0x10caa3f0
> created cq 0x10caa410
> created qp 0x10caa550
> rping_setup_buffers called on cb 0x10ca5010
> allocated & registered buffers...
> cq_thread started.
> cma_event type RDMA_CM_EVENT_ESTABLISHED cma_id 0x10ca7c70 (parent)
> ESTABLISHED
> rmda_connect successful
> RDMA addr 10caaa90 rkey 2002800 len 100
> send completion
> cma_event type RDMA_CM_EVENT_DISCONNECTED cma_id 0x10ca7c70 (parent)
> client DISCONNECT EVENT...
> wait for RDMA_WRITE_ADV state 6
> cq completion failed status 5
> rping_free_buffers called on cb 0x10ca5010
> destroy cm_id 0x10ca7c70
> 
> 
> An ib_rdma_lat gives
>    local address: LID 0x16 QPN 0x004f PSN 0x743778 RKey 0x002500 VAddr 0x00000007c72001
>   remote address: LID 0x01 QPN 0x004f PSN 0x6497a1 RKey 0x002500 VAddr 0x00000018780001
> Conflicting CPU frequency values detected: 2336.000000 != 2003.000000
> Latency typical: inf usec
> Latency best   : inf usec
> Latency worst  : inf usec
> 
> 
> Linux kernel = 2.6.18-92.1.26.el5_lustre.1.6.7.2smp

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
