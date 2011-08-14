From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/1] ib/ipoib: Added adaptive moderation algorithm for better latency.
Date: Sun, 14 Aug 2011 11:47:03 +0300
Message-ID: <201108141147.03629.erezsh@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

The following patch adds a new algorithm for adaptive moderation.
The main idea is changing the CQ moderation (only for the RX) according to the 
traffic.
The Adaptive moderation is controlled via ethtool: adaptive-rx on/off.
(more details in the patch itself.)

Some results without/with adaptive-rx:
--------------------------------------
for latency i run the test: 
	netperf -n 8 -H 11.134.14.1 -c -C -P 1 -t UDP_RR -l 10
for BW i run the test:
	iperf -c 11.134.14.1 -l 64K -P8

first setup:
	no adaptive moderation, default moderation values:
	 rx-usecs: 0 rx-frames: 0
	we will get the next results:
	latency 9 usec 
	BW 6.60 Gbits/sec

second setup:
	no adaptive moderation, manually, moderation values:
	 rx-usecs: 10 rx-frames: 44
	we will get the next results:
	latency 18 usec 
	BW 8.50 Gbits/sec

third setup:	
	adaptive moderation on (Adaptive RX: on)
	we will get the next results:
	latency 9 usec 
	BW 8.60 Gbits/sec


As you can see, the adaptive moderation takes the "good" both tests (from 
different kind of traffic).

Thanks, Erez
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
