From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: LID reconfiguration
Date: Mon, 9 Nov 2009 13:30:09 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911091324150.1226@desktop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm working on making an application multi-path aware and at the same time 
we would like to make it resilient to the SM restarting and reassigning 
LIDs.  We use a special multicast address to discover other nodes on the 
network and then MAD to get full path information.  The application is 
written directly to verbs and establishes reliable connections using 
information exchanged over ARP.

Is there anything I can do other than restart the discovery and connection 
process?  Shouldn't we have enough information with the GID to retain and 
reroute the connection?

One more question;  I saw librdmacm which looked nice but it does not 
support multi-path connections.  It would eliminate a lot of code if we 
could use this, are there plans for it?  Did I miss some functionality?

Thanks,
Jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
