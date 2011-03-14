From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: initiator depth and responder resources in a connect request.
Date: Mon, 14 Mar 2011 08:28:44 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCAC5612@orsmsx501.amr.corp.intel.com>
References: <4D7E27E4.7060606@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D7E27E4.7060606-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Dumb question:  What exactly do the rdma_conn_param fields initiator_depth
> and responder_resources mean in an incoming
> connection request?  Does it mean the peer's values for these two
> resources, or is responder_resources set to match the
> peer's initiator_depth and initiator_depth set to match the peer's
> responder_resources?  IE Are they swapped so the app
> can turn around and use them in the rdma_accept()?

The values are swapped.  See the man page for rdma_get_cm_event and let me know if it's not clear.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
