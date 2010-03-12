From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: udaddy.c question
Date: Fri, 12 Mar 2010 09:25:14 -0600
Message-ID: <4B9A5CDA.1030704@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello rdma wizards,

I'm trying to understand how IB UD service works with the rdmacm in 
linux.  According to the IBTA specification, I should be able to create 
a single UD QP and exchange messages with any number of peers as long as 
I know their qkeys.  Yet when I look at udaddy.c (and even mckey.c), it 
appears that the UD service in the rdmacm is really connection oriented 
and a QP is required for each pair of processes exchanging data.  I 
think this is just the way udaddy.c was implemented, but I want to know 
if it is possible with librdmacm to create a single cm_id with a single 
QP, bind it to an IP address/port, and then send/recv to multiple peers 
(via unicast).  Is this possible?

Thanks!

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
