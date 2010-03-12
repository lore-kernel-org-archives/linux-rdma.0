From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: udaddy.c question
Date: Fri, 12 Mar 2010 08:37:02 -0800
Message-ID: <87571B1E12964DEE8582290B804E03A8@amr.corp.intel.com>
References: <4B9A5CDA.1030704@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B9A5CDA.1030704-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I'm trying to understand how IB UD service works with the rdmacm in
>linux.  According to the IBTA specification, I should be able to create
>a single UD QP and exchange messages with any number of peers as long as
>I know their qkeys.  Yet when I look at udaddy.c (and even mckey.c), it
>appears that the UD service in the rdmacm is really connection oriented
>and a QP is required for each pair of processes exchanging data.  I
>think this is just the way udaddy.c was implemented, but I want to know
>if it is possible with librdmacm to create a single cm_id with a single
>QP, bind it to an IP address/port, and then send/recv to multiple peers
>(via unicast).  Is this possible?

It's intended to be possible.  :)  The rdma_cm uses a single qkey be default in
order to handle mixed UD and multicast traffic.  You could override this by
exchanging whatever qkey you want via private data.  But you must discover the
remote qpn.

To discover the remote qpn, you use the normal rdma calls (resolve_addr /
resolve_route / connect or listen / accept).  You need to do this for each
remote QP that you want to exchange data with.  You don't need a QP associated
with the rdma_cm_id's when resolving the remote qpn, or even need to keep the
rdma_cm_id's around afterwards.  Actually, I don't think there's any reason why
you can't create the UD QPs using ibv_create_qp, and only use the rdma cm to
discover the QPNs. 

The udaddy code was derived from ucmatose, which is why it looks a lot like
connection oriented code.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
