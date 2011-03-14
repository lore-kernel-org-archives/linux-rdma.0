From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 14:40:56 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39E12@orsmsx501.amr.corp.intel.com>
References: <4D7E27E4.7060606@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com>
 <4D7E3568.7010406@opengridcomputing.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB39DF3@orsmsx501.amr.corp.intel.com>
 <4D7E8A25.8010701@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7E8A25.8010701-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > -max_qp_rd_atom and the responder_resources value reported in the connect
> > -request event.
> > +max_qp_rd_atom, but preferably greater than or equal to the
> responder_resources
> > +value reported in the connect request event.
> >
> 
> For iwarp, its a fatal connection termination if the responder resources
> (aka IRD) is overflowed by the peer.  Is it not
> fatal for an IB connection?

Yes - it's fatal.  With rdma_accept, the user _can_ specify a lower number of responder_resources than what the client side requested in their initiator_depth.  The client must then determine if the responder_resources that were offered is sufficient (at least with IB).  This is why I added 'preferably' to the documentation.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
