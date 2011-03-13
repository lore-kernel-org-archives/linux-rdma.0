From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: OSM doesn't send notice on traps 129, 130 and 131
Date: Sun, 13 Mar 2011 15:20:22 +0200
Message-ID: <4D7CC496.1040805@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
