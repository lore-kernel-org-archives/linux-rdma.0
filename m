From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview
Date: Thu, 5 Sep 2013 21:03:17 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB0D836DC0@FMSMSX104.amr.corp.intel.com>
References: <20130831194127.GA22152@TENIKOLO-MOBL1>
 <52260168.8030706@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A8237388CAA713@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CAA713-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Sharp, Robert O" <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Sean,

+	RDMA_NL_NES,
+	RDMA_NL_C4IW

>> Why is the communication with the daemon device specific?  

These enums are necessary. The communication with the IWPM daemon is device specific, because each device is a different netlink client and needs to register with netlink a set of callback functions. The drivers nes and cxgb4 are consuming two netlink clients, using the following 

ibnl_add_client(RDMA_NL_NES, RDMA_NL_IWPM_NUM_OPS, nes_nl_cb_table)
ibnl_add_client(RDMA_NL_C4IW, RDMA_NL_IWPM_NUM_OPS, c4iw_nl_cb_table)

The current implementation will work with two iwarp providers (nes and cxgb4) on the same system and the user space iwarp port mapper will be servicing two clients at the same time.

>> Can the iwarp cm fully encapsulate these changes?
This needs more consideration, because it may not be a trivial change.

Thank you,
Tatyana

-----Original Message-----
From: Hefty, Sean 
Sent: Tuesday, September 03, 2013 12:22 PM
To: Steve Wise; Nikolova, Tatyana E
Cc: Roland Dreier; Sharp, Robert O; Lacombe, John S; vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH 0/4] RDMA/nes and RDMA/cxgb4: iWARP Port Mapper Overview

> I think there are lots of #defines and enums replicated in both 
> nes_netlink.h and c4iw_netlink.h.  For example, the IWPM_* defines and 
> enums.  It seems like we could put all this in a common header file to 
> be included by all iwarp providers?  Say include/rdma/iw_portmap.h or 
> something.  Basically the interface to the user mode daemon is the 
> same for all providers, no?  Those bits should be in a common header.  
> (and maybe even a common core module if there is enough common functions).
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
