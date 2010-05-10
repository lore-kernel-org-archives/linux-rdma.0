From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/37] librdmacm: replace query_route call with separate queries
Date: Mon, 10 May 2010 11:33:41 -0700
Message-ID: <053733AA9B7B4EBFB94A54DEF34DC73A@amr.corp.intel.com>
References: <D81E70C032A3452B9FD00D7EB445F6CF@amr.corp.intel.com> <4BE84B7D.40703@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BE84B7D.40703-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Steve Wise' <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>You define global int af_ib_support.  It never gets set to non-zero.
>Was this debug code or does it get set somewhere else that I'm missing?

It doesn't get set until a later patch in the series, once all the needed
infrastructure is in place.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
