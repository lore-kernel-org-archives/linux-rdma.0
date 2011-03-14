From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 09:36:20 -0500
Message-ID: <4D7E27E4.7060606@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

Dumb question:  What exactly do the rdma_conn_param fields initiator_depth and responder_resources mean in an incoming 
connection request?  Does it mean the peer's values for these two resources, or is responder_resources set to match the 
peer's initiator_depth and initiator_depth set to match the peer's responder_resources?  IE Are they swapped so the app 
can turn around and use them in the rdma_accept()?

(hope that question makes sense)


Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
