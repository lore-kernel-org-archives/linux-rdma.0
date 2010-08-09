From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ucma question - backlog limit
Date: Mon, 9 Aug 2010 11:45:07 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954B87C@orsmsx501.amr.corp.intel.com>
References: <OFD9132F2D.FEEEA35D-ONC125777A.005D920E-C125777A.005DF132@ch.ibm.com>
 <4C603AA6.6030409@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A954B79E@orsmsx501.amr.corp.intel.com>
 <4C6049EE.1020907@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C6049EE.1020907-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> For TCP, a dropped SYN will cause the peer to retransmit the SYN, and
> the connection will be eventually established.  So a small backlog limit
> is probably ok for TCP.  With iWARP, the connect request is TCP payload
> an on established connection.  So the connection request is transmitted
> and acked at the TCP level by the time the connect request gets dropped
> in the ucma.  What finally happens is the peer times out (after many
> seconds typically) and kills the connection.  Further, a 32 node 256NP
> OpenMPI job will generate > 128 connect requests on some ranks.
> 
> So I think its reasonable to up default max value.   I'll post a patch
> to change the max and make it a sysctl variable as well.
> 
> Ok?

Yes - I think that makes sense.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
