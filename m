From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: OSM doesn't send notice on traps 129, 130 and 131
Date: Sun, 13 Mar 2011 15:15:22 +0000
Message-ID: <6E7F64DEFBCFFA46B37B4914CEB21D4F03124E@mtldag02.mtl.com>
References: <4D7CC496.1040805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7CC496.1040805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a long standing IBA spec non conformance. I guess nobody to date has wanted to subscribe to those reports on hardware events (local link integrity threshold, excessive Buffer Overrun threshold, and flow control watchdog expired).

-- Hal

-----Original Message-----
From: Yevgeny Kliteynik [mailto:kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: Sunday, March 13, 2011 9:20 AM
To: Alex Netes; Eli Dorfman; Hal Rosenstock
Cc: Linux RDMA; Yevgeny Kliteynik
Subject: OSM doesn't send notice on traps 129, 130 and 131

It appears that SM is not sending notice on receiving traps 129, 130 and 131. 

>From osm_trap_rcv.c: 

547  /* If we reached here due to trap 129/130/131 - do not need to do 
548     the notice report. Just goto exit. We know this is the case 
549     if physp_change_trap is TRUE. */ 
550     if (physp_change_trap == TRUE) 
551            goto Exit; 

Does anybody knows why? Spec doesn't say that SM shouldn't send notice on these traps. Is this a bug?

-- YK
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
