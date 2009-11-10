From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Tue, 10 Nov 2009 09:44:14 +0200
Message-ID: <4AF919CE.5020007@Voltaire.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop>	<4AF91138.7000809@Voltaire.com> <alpine.BSF.2.00.0911092110000.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.0911092110000.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jeff Roberson wrote:
> I would want a way to specify the alternate sockaddr with automatic
> failover between them.  Perhaps with some notification when a failover occured

>From your description I still don't see what the alternate address buys you. 


As was suggested here, bond two IPoIB devices, use the address of the bond in your librdmacm based app and automatic HA. You get indications on failover through RDMA_CM_EVENT_ADDR_CHANGE, see rdma_get_cm_event(3)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
