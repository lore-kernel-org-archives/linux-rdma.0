From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: udaddy.c question
Date: Fri, 12 Mar 2010 09:36:31 -0800
Message-ID: <D7D2007A49ED4421B795427606438083@amr.corp.intel.com>
References: <4B9A5CDA.1030704@opengridcomputing.com> <87571B1E12964DEE8582290B804E03A8@amr.corp.intel.com> <4B9A74A4.8030404@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B9A74A4.8030404-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>What if I don't want to use the qpn discovery mechanism from librdmacm?
>IE I have have an out of band protocol for exchanging qkeys -and- qpns.
>Can I avoid the connect on the active side, and the listen/accept on the
>server side?

If you exchange the qpn and qkeys out of band, then I'm not sure what the rdma
cm buys you. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
