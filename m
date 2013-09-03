From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview
Date: Tue, 3 Sep 2013 17:22:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CAA713@ORSMSX109.amr.corp.intel.com>
References: <20130831194127.GA22152@TENIKOLO-MOBL1>
 <52260168.8030706@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52260168.8030706-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think there are lots of #defines and enums replicated in both
> nes_netlink.h and c4iw_netlink.h.  For example, the IWPM_* defines and
> enums.  It seems like we could put all this in a common header file to
> be included by all iwarp providers?  Say include/rdma/iw_portmap.h or
> something.  Basically the interface to the user mode daemon is the same
> for all providers, no?  Those bits should be in a common header.  (and
> maybe even a common core module if there is enough common functions).
> 
> Thoughts?

I agree.  This enum change looks off:

+	RDMA_NL_NES,
+	RDMA_NL_C4IW

Why is the communication with the daemon device specific?  Can the iwarp cm fully encapsulate these changes?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
