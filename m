From: Marius Hillenbrand <marius-YNthFWz8GsSVVg0uGvK5oA@public.gmane.org>
Subject: virtual lanes and impact on ib_write_bw
Date: Fri, 22 Apr 2011 00:25:05 +0200
Message-ID: <4DB0AEC1.9080003@sirius.inka.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I am currently running experiments with different virtual lane settings,
but my results so far do not match my understanding of IB virtual lane
arbitration (from the IB specs and the opensm QoS docs). Especially the
high- and low-prio arbitration tables "do not behave". So, I hope one of
you might find the flaw in my approach:

My opensm configuration (reduced to qos entries):
qos TRUE # and --qos at startup
qos_high_limit 255

# 8 VLs supported, straight mapping
qos_sl2vl      0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7
[qos_ca_sl2vl and qos_swe_sl2vl lines with same content]

# VL0 in high priority table, VL1 in low priority table
qos_vlarb_high 0:255
qos_vlarb_low  1:255

I expect that traffic in VL0 (from SL0, or SL8) is preferred over
traffic in VL1 (from SL1, or SL9). Actually, traffic in VL1 should
starve, when there are packets available in VL0, right?!
But, when I run two instances of ib_write_bw from the perftest
collection between two nodes at the same time (modified to use a pthread
barrier to start simultaneously), both receive half the available
bandwidth. Further, varying the weights in the arbitration tables seems
to have no effect.

Service Levels 2 and above are filtered, so I conclude that opensm does
indeed set the arbitration tables.

My current assumption is, that a scheduling policy internal to the HCA
(maybe round robin on QPs) masks the virtual lane arbitration in this
setup (HCA->switch->HCA, so the switch does not influence packet order
anymore). Does this make sense, or is there something else fundamentally
wrong in my configuration above?

Thanks in advance for any hints,
Marius Hillenbrand

PS, background info:
opensm versions: 3.3.7_MLNX and 3.3.9_83b6752 tested with same results.
HW: 2 Intel Nehalem 4-core nodes with Mellanox ConnectX-2 HCAs on a
Mellanox InfiniScale switch.
SW: OFED 1.5.3, CentOS 5.5, kernel 2.6.18...,
Benchmark: ib_write_bw from the perftest collection, modified to run
several threads at the same time with different parameters (especially
different service levels).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
