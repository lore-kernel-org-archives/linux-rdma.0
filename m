From: Parav Pandit <paravpandit-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Does SDP on Chelsio RNIC in ofed 1.5.2 work?
Date: Tue, 5 Apr 2011 06:14:20 -0700 (PDT)
Message-ID: <550378.63701.qm@web30107.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am having Chelsio T310 adapters connected via 10G switch in servers using OFED 1.5.2.

I am trying to measure SDP performance over iWarp on Chelsio adapters.
but I find below error message from the /var/log/messages.

Apr  5 23:28:11 linux kernel: [ 2066.238932] eth8: link up, 10Gbps, full-duplex
Apr  5 23:28:11 linux kernel: [ 2066.240016] ADDRCONF(NETDEV_CHANGE): eth8: link
becomes ready
Apr  5 23:28:15 linux kernel: [ 2070.629530] iw_cxgb3: Chelsio T3 RDMA Driver -
version 1.1
Apr  5 23:28:15 linux kernel: [ 2070.642134] fmr_pool: Device cxgb3_0 does not
support FMRs
Apr  5 23:28:15 linux kernel: [ 2070.642137] Error creating fmr pool
Apr  5 23:28:15 linux kernel: [ 2070.642142] iw_cxgb3: Initialized device
0000:05:00.0
Apr  5 23:28:18 linux kernel: [ 2073.551607] sdp_post_recv:236 sdp_sock( 3142:2
41209:0): ib_post_recv failed. status -22

I find some discussion on previous ofed list in 2008 about broken support for same.
http://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg10720.html

Below link seem to calculate the SDP performance over Chelsio iWARP.
http://hpc.ufl.edu/benchmarks/iwarp_sdp/

Can anyone please tell me what am I missing? I have done SDP configuration from the above link.

Regards,
Parav Pandit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
